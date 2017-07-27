unit wsMultiple;

interface

uses SysUtils,WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls,Dialogs,Grids, TimeChartGlobals,GlobalToTcAndTcextra, XML.TEACHERS;

type       
  TwsMultipleDlg = class(TForm)
    HelpBtn: TBitBtn;
    Finish: TBitBtn;
    SkipBtn: TBitBtn;
    EnterBtn: TBitBtn;
    AutoMove: TRadioGroup;
    MultScope: TRadioGroup;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label11: TLabel;
    Label12: TLabel;
    WarnBox: TCheckBox;
    Label8: TLabel;
    Edit3: TEdit;
    Label9: TLabel;
    Edit4: TEdit;
    Label10: TLabel;
    Edit5: TEdit;
    Label3: TLabel;
    ComboBox2: TComboBox;
    ComboBox1: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Edit2: TEdit;
    CheckBox1: TCheckBox;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure MultScopeClick(Sender: TObject);
    procedure AutoMoveClick(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure EnterBtnClick(Sender: TObject);
    procedure SkipBtnClick(Sender: TObject);
    procedure WarnBoxClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FinishClick(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Edit3Change(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
    procedure Edit5Change(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    procedure Restore;
    procedure NewPos;
    procedure ClearPos;
    procedure SetButtonStatus;
    procedure SetDefaultLabel;
    procedure SetMultScope;
    procedure NewMultEdit(var myEntry: smallint; myEdit:Tedit);
  end;

var
  wsMultipleDlg: TwsMultipleDlg;

procedure setwsMultipleDlg;


implementation

{$R *.DFM}
uses tcommon,tcommon2,tcommon5, Worksheet,DlgCommon,ttUndo;

var
 Mult1,One1,Two1,Three1:  smallint;
 Mbox:  byte;
 posy,posl,posb,wsmy,wsml,wsmb:  integer;
 startflag,HasPos,SetDefaultFlg,ExternalFlg:            bool;

procedure setSelectedCell;
begin
 Worksheetwin.restoreWSselection;
end;

procedure setwsMultipleDlg;
begin
 with wsMultipleDlg do
  begin
   ExternalFlg:=true;
   SetMultScope;
   restore;
   SetButtonStatus;
   ExternalFlg:=false;
  end;
end;

procedure TwsMultipleDlg.SetDefaultLabel;
begin
 label11.Caption:='(default '+wsMultName(0)+')';
end;

procedure TwsMultipleDlg.ClearPos;
begin
 label4.Caption:='';
end;

procedure TwsMultipleDlg.SetButtonStatus;
begin
 EnterBtn.Enabled:=HasPos;
 SkipBtn.Enabled:=HasPos;
end;


procedure TwsMultipleDlg.NewPos;
var
 tmpPos: boolean;
begin
 tmpPos:=(posb>0) and (posb<=wsBlocks) and (posy>=0) and (posl>0);
 if HasPos<>tmpPos then
  begin
   if not(tmpPos) then clearPos;
   HasPos:=tmpPos;
   SetButtonStatus;
  end;
 if HasPos then
  begin
   wsy:=posy; wsl:=posl; wsb:=posb;
   restore;
   setSelectedCell; BringIntoView;
  end;
end;


procedure TwsMultipleDlg.Restore;
var
 IntPoint:      tpIntPoint;
 sub1,te1,room1,Enlabel: integer;
 s: string;
begin
 IntPoint:=FNWS(wsb,wsy,wsl,0);
 Sub1:=IntPoint^;
 inc(IntPoint); te1:=IntPoint^;
 inc(IntPoint); room1:=IntPoint^;
 s:='';
 if Sub1>LabelBase then
  begin
   EnLabel:=Sub1-LabelBase;
   if ((EnLabel>0) and (EnLabel<=nmbrlabels))
    then s:=TcLabel[EnLabel];
  end
 else
  s:=trim(SubCode[Sub1])+' '+trim(XML_TEACHERS.tecode[te1,0])+' '+trim(XML_TEACHERS.tecode[room1,1]);

 label4.Caption:=s;

 if (posy=wsy) and (posl=wsl) and (posb=wsb) and not(ExternalFlg)
  then exit; 
 IntPoint:=FNWS(wsb,wsy,wsl,8);
 Mult1:=IntPoint^; IntRange(Mult1,0,wsMultNum);
 One1:=wsOne[Mult1];  Two1:=wsTwo[Mult1];
 Three1:=wsThree[Mult1];
 {position}
 ComboBox1.text:=yearname[wsy];
 Edit2.text:=inttostr(wsl);
 combobox2.Text:=inttostr(wsb);
 {multiples}
 edit3.Text:=inttostr(One1);
 edit4.Text:=inttostr(Two1);
 edit5.Text:=inttostr(Three1);

 posy:=wsy; posl:=wsl; posb:=wsb; HasPos:=true;

end;

procedure TwsMultipleDlg.SetMultScope;
begin
 case wsbox of
  bxYrTime: MultScope.ItemIndex:=1;
  bxLevel: MultScope.ItemIndex:=2;
  bxYear: MultScope.ItemIndex:=3;
  bxTime: MultScope.ItemIndex:=4;
  bxALL: MultScope.ItemIndex:=5;
  else MultScope.ItemIndex:=0;
 end;
 Mbox:=MultScope.ItemIndex;
end;

procedure TwsMultipleDlg.FormCreate(Sender: TObject);
begin
 topcentre(self);
 startflag:=true;  SetDefaultFlg:=false;  ExternalFlg:=false;
 posy:=wsy; posb:=wsb; posl:=wsl;
 FillComboYears(false,ComboBox1);
 FillComboBlocks(Combobox2);
 AutoMove.ItemIndex:=arrow;
 WarnBox.checked:=Bool(WSmWarn);
 label1.caption:='&'+Yeartitle;
 SetDefaultLabel;
 BringIntoView;
 startflag:=false;
 fwsMultDlgUp:=true;
end;

procedure TwsMultipleDlg.FormActivate(Sender: TObject);
begin
 setwsMultipleDlg;
end;

procedure TwsMultipleDlg.MultScopeClick(Sender: TObject);
begin
 if startflag then exit;
 if Mbox=MultScope.ItemIndex then exit;
 Mbox:=MultScope.ItemIndex;
 case Mbox of
  0: wsbox:=bxcell;
  1: wsbox:=bxYrTime;
  2: wsbox:=bxlevel;
  3: wsbox:=bxyear;
  4: wsbox:=bxTime;
  5: wsbox:=bxALL;
 end;
 setSelectedCell;
 BringIntoView;
end;

procedure TwsMultipleDlg.AutoMoveClick(Sender: TObject);
begin
 arrow:=AutoMove.ItemIndex;
end;


procedure TwsMultipleDlg.Edit2Change(Sender: TObject);
var
 oldval: integer;
begin
 if startflag then exit;
 oldval:=posl;
 posl:=getLevel(wsy,Edit2.text,label12);
 if (posl<>oldval) then NewPos;
end;


procedure Stepon;
var
 oldy,oldl,oldb: integer;
begin
 oldy:=wsy; oldl:=wsl; oldb:=wsb;
 wsMoveSelect(arrow);
 if (oldy=wsy) and (oldb=wsb) and (oldl=wsl) then exit;
 setSelectedCell;
 BringIntoView;
 wsMultipleDlg.restore;
end;

function clashwarn: bool;
var
 msg: string;
begin
 result:=false;
 if not(WSmWarn) then exit;
 msg:='';
 if SetDefaultFlg and ((One1<>wsOne[0]) or (Two1<>wsTwo[0]) or
   (Three1<>wsThree[0]) )then
  begin
   msg:='Change default multiples?';
   if messagedlg(msg,mtWarning,[mbyes,mbno],0)<>mrYes then
    begin
     result:=true;
     exit;
    end;
  end;
 if Mbox>0 then
  begin
   case Mbox of
    1: msg:=yearShort+'/block';
    2: msg:='level';
    3: msg:=yeartitle;
    4: msg:='block';
    5: msg:='worksheet';
   end;
   msg:='Change all entries in '+msg;
   if messagedlg(msg,mtWarning,[mbyes,mbno],0)<>mrYes then result:=true;
  end;
end;


procedure DoMultUnit;
var
 IntPoint:  tpIntPoint;
begin
 PushWScell(wsmb,wsmy,wsml);
 IntPoint:=FNws(wsmb,wsmy,wsml,8);
 IntPoint^:=Mult1;
end;

procedure CopyMultCell;
begin
 wsmb:=wsb; wsmy:=wsy; wsml:=wsl;
 DoMultUnit;
end;


procedure copyMultLevel;
var
 b: smallint;
begin
 wsmy:=wsy; wsml:=wsl;
 for b:=1 to wsBlocks do
  begin
   wsmb:=b;
   DoMultUnit;
  end;
end;

procedure copyMultYear;
var
 b,l: smallint;
begin
 wsmy:=wsy;
 for b:=1 to wsBlocks do
  for l:=1 to level[wsy] do
   begin
    wsmb:=b; wsml:=l;
    DoMultUnit;
   end;
end;

procedure copyMultYrBlock;
var
 l: smallint;
begin
 wsmb:=wsb; wsmy:=wsy;
 for l:=1 to level[wsy] do
  begin
   wsml:=l;
   DoMultUnit;
  end;
end;

procedure copyMultBlock;
var
 y,l: smallint;
begin
 wsmb:=wsb;
 for y:=0 to years_minus_1 do
  for l:=1 to level[y] do
   begin
    wsmy:=y; wsml:=l;
    DoMultUnit;
   end;
end;


procedure copyMultAll;
var
 b,y,l: smallint;
begin
 for b:=1 to wsBlocks do
  for y:=0 to years_minus_1 do
   for l:=1 to level[y] do
    begin
     wsmb:=b; wsmy:=y; wsml:=l;
     DoMultUnit;
    end;
end;


procedure SetMult;
var
 i,j: integer;
begin
 j:=0;
 mult1:=-1;
 if SetDefaultFlg then mult1:=0;
 if mult1=-1 then
  if wsMultNum>=0 then
   for i:=0 to wsMultNum do
    begin
     if (wsOne[i]=One1) and (wsTwo[i]=Two1) and (wsThree[i]=Three1) then mult1:=i;
     if (wsOne[i]=0) and (wsTwo[i]=0) and (wsThree[i]=0) then j:=i;
    end;
 wsMultChangeFlg:=(mult1=-1);
 if (mult1=-1) and (j>0) then mult1:=j;
 if mult1=-1 then
  begin
   inc(wsMultNum);
   SetWSmultArrays;
   mult1:=wsMultNum;
  end;
 wsOne[mult1]:=One1; wsTwo[mult1]:=Two1; wsThree[mult1]:=Three1;
 PushTtStackStart(utWSmultiple);
 case Mbox of
  0: copyMultCell;
  1: copyMultYrBlock;
  2: copyMultLevel;
  3: copyMultYear;
  4: copyMultBlock;
  5: copyMultAll;
 end;
end;


procedure TwsMultipleDlg.EnterBtnClick(Sender: TObject);
begin
 NewMultEdit(One1,Edit3);
 NewMultEdit(Two1,Edit4);
 NewMultEdit(Three1,Edit5);
 if (One1<=0) and (Two1<=0) and (Three1<=0) then
  begin
   ShowMsg('No multiples entered.',Edit3);
   exit;
  end;
 if ClashWarn then exit;
 SetMult;
 Stepon;
 Restore;
 UpdateWSwins;
 SaveTimeFlag:=True;
end;

procedure TwsMultipleDlg.SkipBtnClick(Sender: TObject);
begin
 Stepon;
end;

procedure TwsMultipleDlg.WarnBoxClick(Sender: TObject);
begin
 WSmWarn:=WarnBox.checked;
end;

procedure TwsMultipleDlg.ComboBox1Change(Sender: TObject);
var
 oldval: integer;
begin
 if startflag then exit;
 oldval:=posy;
 posy:=findYearname(ComboBox1.text,label12);
 if (posy<>oldval) then NewPos;
end;

procedure TwsMultipleDlg.ComboBox2Change(Sender: TObject);
var
 oldval: integer;
begin
 if startflag then exit;
 oldval:=posb;
 posb:=findWSblock(ComboBox2.text,label12);
 if (posb<>oldval) then NewPos;
end;

procedure TwsMultipleDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 UpdateTimetableWins;
 action:=caFree; fwsMultDlgUp:=false;
 if ((usrPassLevel=utTime) or (usrPassLevel=utSuper)) then
  if not(saveTimeFlag) then CheckAccessRights(utTime,16,false);
end;

procedure TwsMultipleDlg.FinishClick(Sender: TObject);
begin
 close;
end;

procedure TwsMultipleDlg.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
 allowNumericInputOnly(key);
end;


procedure TwsMultipleDlg.NewMultEdit(var myEntry: smallint; myEdit:Tedit);
begin
 if startflag then exit;
 myEntry:=IntFromEdit(myEdit);
end;

procedure TwsMultipleDlg.Edit3Change(Sender: TObject);
begin
 NewMultEdit(One1,Edit3);
end;

procedure TwsMultipleDlg.Edit4Change(Sender: TObject);
begin
 NewMultEdit(Two1,Edit4);
end;

procedure TwsMultipleDlg.Edit5Change(Sender: TObject);
begin
 NewMultEdit(Three1,Edit5);
end;

procedure TwsMultipleDlg.CheckBox1Click(Sender: TObject);
begin
 SetDefaultFlg:=CheckBox1.Checked;
end;

end.



