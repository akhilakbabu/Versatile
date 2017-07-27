unit Alter;

interface

uses SysUtils, WinTypes, WinProcs, Classes, Graphics, Forms, Controls,
  Buttons, StdCtrls, ExtCtrls, Dialogs, TimeChartGlobals,GlobalToTcAndTcextra, XML.DISPLAY;

type
  TAlterDlg = class(TForm)
    HelpBtn: TBitBtn;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Edit1: TEdit;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    InsertBtn: TBitBtn;
    DeleteBtn: TBitBtn;
    Finish: TBitBtn;
    AlterScope: TRadioGroup;
    WarnBox: TCheckBox;
    ComboBox3: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure AlterScopeClick(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure InsertBtnClick(Sender: TObject);
    procedure DeleteBtnClick(Sender: TObject);
    procedure WarnBoxClick(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure ComboBox3Change(Sender: TObject);
    procedure ComboBox3Enter(Sender: TObject);
  private
    function CheckPosition: bool;
  end;

var
  AlterDlg: TAlterDlg;

implementation

{$R *.DFM}
uses tcommon,DlgCommon,TTundo,ttable,tcommon2;

var
 ad,ap,ay,al:  smallint;
 firstStart:      bool;

procedure TAlterDlg.FormCreate(Sender: TObject);
begin
  TopCentre(self);
  firstStart:=true;
  AlterScope.ItemIndex:=XML_DISPLAY.AlterBox;
  WarnBox.checked:=Warn;
  label1.caption:='&'+Yeartitle;
  FillComboYears(false,ComboBox1);
  FillComboDays(false,ComboBox2);
  ay:=ny; al:=nl; ad:=nd; ap:=np;
  FillComboTimeSlots(false,nd,combobox3);
  Combobox1.ItemIndex := Combobox1.Items.IndexOf(yearname[ay]);
  edit1.text:=inttostr(al);
  Combobox2.ItemIndex := Combobox2.Items.IndexOf(day[ad]);
  combobox3.ItemIndex:=ap;
  firstStart:=false;
end;

procedure TAlterDlg.AlterScopeClick(Sender: TObject);
begin
 if FirstStart then exit;
 XML_DISPLAY.AlterBox:=AlterScope.ItemIndex;
end;

procedure TAlterDlg.ComboBox2Change(Sender: TObject);
var
 found:  integer;
begin
 if FirstStart then exit;
 if ChangeDayCombo(ad,Combobox2,combobox3) then ComboBox3Change(Sender);
 found:=findDayMsg(ComboBox2.text,label5);
 if found>=0 then ad:=found;
end;

procedure TAlterDlg.ComboBox1Change(Sender: TObject);
var
 found:  integer;
begin
 if FirstStart then exit;
 found:=findYearname(ComboBox1.text,label5);
 if found>=0 then ay:=found;
end;

procedure TAlterDlg.Edit1Change(Sender: TObject);
begin
 if FirstStart then exit;
 al:=getLevel(ay,Edit1.text,label5);
end;

function TAlterDlg.CheckPosition: bool;
var
 found: smallint;
 MyError: boolean;
begin
 myError:=BadComboYear(found,ComboBox1);
 if not(myError) then myError:=BadLevel(al,ay,edit1);
 if not(myError) then myError:=BadDayCombo(found,ComboBox2);
 if not(myError) then myError:=BadTimeCombo(ap,ad,ComboBox3);
 result:=not(myError);
end;



procedure TAlterDlg.InsertBtnClick(Sender: TObject);
var
 d1,d2,p1,p2,d,p,l,i:  integer;
begin
 if not(CheckPosition) then exit;
 if level[ay]=levelprint then
  begin
   messagedlg('No room to increase levels.',mtError,[mbOK],0);
   exit;
  end;
 p1:=ap; p2:=ap; d1:=ad; d2:=ad;
 if XML_DISPLAY.Alterbox>0 then
  begin
   p1:=0;p2:=periods-1;
  end;
 if XML_DISPLAY.Alterbox>1 then
  begin
   d1:=0;d2:=days-1;
  end;
 PushInsertLevel(d1,p1,d2,p2,ay,al);
 for d:=d1 to d2 do
  for p:=p1 to p2 do
   begin
    for l:=levelprint-1 downto al do
     for i:=0 to 3 do FNT(d,p,ay,l+1,2*i)^:=FNT(d,p,ay,l,2*i)^;
    for i:=0 to 3 do FNT(d,p,ay,al,2*i)^:=0;
   end;
 inc(level[ay]);
 CalcLevelsUsed;
 SaveTimeFlag:=True; alterTimeFlag:=true; alterWSflag:=True;
 UpdateTimetableWins;
end;

procedure TAlterDlg.DeleteBtnClick(Sender: TObject);
var
 d1,d2,p1,p2,d,p,l,i:  integer;
 d3,p3,Nblock:                integer;
 fixedentry,StopClear:             bool;
 Sbyte,Cbyte:                byte;
 location,msg:                  string;
begin
 if not(CheckPosition) then exit;
 p1:=ap; p2:=ap; d1:=ad; d2:=ad; d3:=0; p3:=0;
 if XML_DISPLAY.Alterbox>0 then
  begin
   p1:=0;p2:=periods-1;
  end;
 if XML_DISPLAY.Alterbox>1 then
  begin
   d1:=0;d2:=days-1;
  end;
 fixedentry:=false;
 for d:=d1 to d2 do
  begin
   for p:=p1 to p2 do
    begin
     Sbyte:=FNTByte(d,p,ay,al,6)^;
     if (Sbyte and 4)=4 then
      begin
       fixedentry:=true; p3:=p; d3:=d;
       break;
      end;
    end; {p}
   if fixedentry then break;
  end; {d}
 if fixedentry then
  begin
   msg:='Entry at '+day[d3]+': '+inttostr(p3+1)+' is fixed.';
   messagedlg(msg, mtInformation, [mbOK], 0);
   exit;
  end;
 StopClear:=false;

 for d:=d1 to d2 do
  begin
   for p:=p1 to p2 do
    begin
     Sbyte:=FNTByte(d,p,ay,al,6)^;
     location:=' at '+day[d]+': '+inttostr(p+1);
     if warn and ((Sbyte and 1)=1) then if OpCheck(location,'double','Delete')
      then StopClear:=true;
     if StopClear then break;
     Nblock:=FNgetBlockNumber(d,p,ay,al);
     if warn and (Nblock>0) then if OpCheck(location,'block','Delete')
      then StopClear:=true;
    end; {p}
   if StopClear then break;
  end; {d}
 if StopClear then exit;
 pushTtStack(d1,p1,ay,al,d2,p2,aY,levelsUsed,utDeleteLevel);
 for d:=d1 to d2 do
  for p:=p1 to p2 do
   begin
    Cbyte:=FNTByte(d,p,ay,al,7)^;
    if Cbyte>=8 then Fclash[d,p]:=1;
    if al<level[ay] then
     for l:=al+1 to level[ay] do
      for i:=0 to 3 do  FNT(d,p,ay,l-1,2*i)^:=FNT(d,p,ay,l,2*i)^;
    for i:=0 to 3 do FNT(d,p,ay,level[ay],2*i)^:=0;
   end;
 ttclash;
 RebuildLabels;   SaveTimeFlag:=True; 
 UpdateTimetableWins;
end;

procedure TAlterDlg.WarnBoxClick(Sender: TObject);
begin
 warn:=WarnBox.checked;
end;

procedure TAlterDlg.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
 allowNumericInputOnly(key);
end;

procedure TAlterDlg.ComboBox3Change(Sender: TObject);
begin
 if FirstStart then exit;
 ChangeTimeCombo(ap,combobox3,label5);
end;

procedure TAlterDlg.ComboBox3Enter(Sender: TObject);
begin
 ComboBox3.SelectAll;
end;

end.
