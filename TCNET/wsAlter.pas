unit wsAlter;

interface

uses SysUtils, WinTypes, WinProcs, Classes, Graphics, Forms, Controls,
  Buttons, StdCtrls, ExtCtrls, Dialogs, TimeChartGlobals,GlobalToTcAndTcextra, XML.DISPLAY;

type
  TwsAlterDlg = class(TForm)
    HelpBtn: TBitBtn;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Edit1: TEdit;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    InsertBtn: TBitBtn;
    DeleteBtn: TBitBtn;
    Finish: TBitBtn;
    AlterScope: TRadioGroup;
    WarnBox: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure AlterScopeClick(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure InsertBtnClick(Sender: TObject);
    procedure DeleteBtnClick(Sender: TObject);
    procedure WarnBoxClick(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  private
    function CheckPosition: bool;
  end;

var
  wsAlterDlg: TwsAlterDlg;

implementation

{$R *.DFM}
uses tcommon,DlgCommon,TTundo,worksheet,tcommon2;



var
 ab,ay,al:  smallint;
 firstStart:      bool;

procedure TwsAlterDlg.FormCreate(Sender: TObject);
begin
  TopCentre(self);
  firstStart:=true;
  AlterScope.ItemIndex:=XML_DISPLAY.wsAlterBox;
  WarnBox.checked:=Warn;
  label1.caption:='&'+Yeartitle;
  FillComboYears(false,ComboBox1);
  FillComboBlocks(Combobox2);
  ay:=wsy; al:=wsl; ab:=wsb;
  Combobox1.ItemIndex := Combobox1.Items.IndexOf(yearname[ay]);
  edit1.text:=inttostr(al);
  Combobox2.ItemIndex := Combobox2.Items.IndexOf(IntToStr(ab));
  firstStart:=false;
end;

procedure TwsAlterDlg.AlterScopeClick(Sender: TObject);
begin
 if FirstStart then exit;
 XML_DISPLAY.wsAlterBox:=AlterScope.ItemIndex;
end;

procedure TwsAlterDlg.ComboBox2Change(Sender: TObject);
var
 found:  integer;
begin
 if FirstStart then exit;
 found:=findWSblock(ComboBox2.text,label5);
 if found>0 then ab:=found;
end;

procedure TwsAlterDlg.ComboBox1Change(Sender: TObject);
var
 found:  integer;
begin
 if FirstStart then exit;
 found:=findYearname(ComboBox1.text,label5);
 if found>=0 then ay:=found;
end;

procedure TwsAlterDlg.Edit1Change(Sender: TObject);
begin
 if FirstStart then exit;
 al:=getLevel(ay,Edit1.text,label5);
end;

function TwsAlterDlg.CheckPosition: bool;
var
 found: smallint;
 MyError: boolean;
begin
 myError:=BadComboYear(found,ComboBox1);
 if not(myError) then myError:=BadLevel(al,ay,edit1);
 if not(myError) then myError:=(ab<1) or (ab>wsBlocks);
 result:=not(myError);
end;



procedure TwsAlterDlg.InsertBtnClick(Sender: TObject);
var
 b1,b2,b,l,i:  integer;
begin
 if not(CheckPosition) then exit;
 if level[ay]=levelprint then
  begin
   messagedlg('No room to increase levels.',mtError,[mbOK],0);
   exit;
  end;
 b1:=ab; b2:=ab;
 if XML_DISPLAY.wsAlterBox=1 then
  begin
   b1:=1;b2:=wsBlocks;
  end;
 PushWSinsertLevel(b1,b2,ay,al);
 for b:=b1 to b2 do
  begin
   for l:=levelprint-1 downto al do
    for i:=0 to 3 do FNws(b,ay,l+1,2*i)^:=FNws(b,ay,l,2*i)^;
   for i:=0 to 3 do FNws(b,ay,al,2*i)^:=0;
  end;
 inc(level[ay]);
 CalcLevelsUsed;
 SaveTimeFlag:=True; alterTimeFlag:=true; alterWSflag:=True;
 UpdateTimetableWins;
end;

procedure TwsAlterDlg.DeleteBtnClick(Sender: TObject);
var
 b1,b2,b,l,i:  integer;
 Nblock:                integer;
 StopClear:             bool;
 Cbyte:                byte;
 location:                  string;
begin
 if not(CheckPosition) then exit;
 b1:=ab; b2:=ab;
 if XML_DISPLAY.wsAlterBox=1 then
  begin
   b1:=1;b2:=wsBlocks;
  end;
 StopClear:=false;
 for b:=b1 to b2 do
  begin
   location:=' at block: '+inttostr(b);
   Nblock:=FNgetWSBlockNumber(b,ay,al);
   if warn and (Nblock>0) then if OpCheck(location,'block','Delete')
      then StopClear:=true;
   if StopClear then break;
  end; {b}
 if StopClear then exit;
 pushWSStack(b1,ay,al,b2,aY,levelsUsed,utWSDeleteLevel);
 for b:=b1 to b2 do
   begin
    Cbyte:=FNWSbyte(b,ay,al,7)^;
    if Cbyte>=8 then WSFclash[b]:=1;
    if al<level[ay] then
     for l:=al+1 to level[ay] do
      for i:=0 to 3 do  FNWS(b,ay,l-1,2*i)^:=FNWS(b,ay,l,2*i)^;
    for i:=0 to 3 do FNws(b,ay,level[ay],2*i)^:=0;
   end;
 WSclash;
 RebuildLabels;   
 UpdateWSWins;
 SaveTimeFlag:=True;
end;

procedure TwsAlterDlg.WarnBoxClick(Sender: TObject);
begin
 warn:=WarnBox.checked;
end;

procedure TwsAlterDlg.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
 allowNumericInputOnly(key);
end;

end.
