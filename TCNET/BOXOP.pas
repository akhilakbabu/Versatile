unit Boxop;

interface

uses SysUtils, WinTypes, WinProcs, Classes, Graphics, Forms, Controls,
  Buttons, StdCtrls, ExtCtrls, Dialogs, TimeChartGlobals,GlobalToTcAndTcextra;


type
  TBoxDlg = class(TForm)
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label12: TLabel;
    Edit2: TEdit;
    Edit8: TEdit;
    BoxScope: TRadioGroup;
    WarnBox: TCheckBox;
    Finish: TBitBtn;
    ClearBtn: TBitBtn;
    MoveBtn: TBitBtn;
    CopyBtn: TBitBtn;
    Label5: TLabel;
    Label6: TLabel;
    SwapBtn: TBitBtn;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    ComboBox5: TComboBox;
    ComboBox6: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure WarnBoxClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BoxScopeClick(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Edit8Change(Sender: TObject);
    procedure CopyBtnClick(Sender: TObject);
    procedure SwapBtnClick(Sender: TObject);
    procedure MoveBtnClick(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
    procedure Edit4KeyPress(Sender: TObject; var Key: Char);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox4Change(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure ComboBox5Enter(Sender: TObject);
    procedure ComboBox6Enter(Sender: TObject);
    procedure ComboBox5Change(Sender: TObject);
    procedure ComboBox6Change(Sender: TObject);
  private
    procedure CopyGeneral;
    function ToFlags: bool;
    function FromFlags: bool;
  end;

var
  BoxDlg: TBoxDlg;

implementation

{$R *.DFM}
uses tcommon,DlgCommon,ttable,tcommon2,TTundo;

var
 Ebox,box1: smallint;
 fd, fp, fy, fl:       smallint;
 td, tp, ty, tl:       smallint;
 Lflag,Tflag,Yflag:    wordbool;
 Bflag,Fflag,Dflag:    wordbool;
 CopyOp:               smallint;
 Optype:               String;
 CopyStop:             wordbool;


procedure boxFromE;
begin
 box1:=Ebox;
 case Ebox of
  1: box1:=5;
  2: box1:=3;
  3: box1:=1;
  4: box1:=2;
  5: box1:=4;
 end;
end;

procedure EfromBox;
begin
 Ebox:=box;
 case box of
  1: Ebox:=3;
  2: Ebox:=4;
  3: Ebox:=2;
  4: Ebox:=5;
  5: Ebox:=1;
 end;
end;

procedure TBoxDlg.FormCreate(Sender: TObject);
begin
 topcentre(self);
 WarnBox.checked:=Warn;
 FillComboYears(false,ComboBox1);
 FillComboYears(false,ComboBox4);
 Combobox1.Hint:='Select '+Yeartitle+' for From position';
 Combobox4.Hint:='Select '+Yeartitle+' for To position';
 FillComboDays(false,ComboBox2);
 FillComboDays(false,ComboBox3);
 FillComboTimeSlots(false,nd,combobox5);
 FillComboTimeSlots(false,nd,combobox6);
end;

procedure TBoxDlg.WarnBoxClick(Sender: TObject);
begin
 Warn:=WarnBox.checked;
end;

procedure TBoxDlg.FormActivate(Sender: TObject);
begin
 Warn:=WarnBox.checked;
 box1:=box;
 EfromBox;
 BoxScope.ItemIndex:=Ebox;
 label1.caption:=Yeartitle;
 Combobox1.text:=yearname[ny]; Combobox4.text:=yearname[ny];
 Edit2.text:=inttostr(nl); Edit8.text:=inttostr(nl);
 Combobox2.text:=Day[nd];      Combobox3.text:=Day[nd];
 combobox5.ItemIndex:=np;     combobox6.ItemIndex:=np;
 fd:=nd; fp:=np; fy:=ny; fl:=nl;
 td:=nd; tp:=np; ty:=ny; tl:=nl;
 Combobox3.Setfocus;
end;

procedure Restore;
begin
 With BoxDlg do begin
 Edit2Change(BoxDlg);
 Edit8Change(BoxDlg);
 ComboBox5Change(BoxDlg);
 ComboBox6Change(BoxDlg);
 ComboBox2Change(BoxDlg);
 ComboBox1Change(BoxDlg);
 ComboBox4Change(BoxDlg);
 ComboBox3Change(BoxDlg);
 end;
end;

procedure TBoxDlg.BoxScopeClick(Sender: TObject);
begin
 Ebox:=BoxScope.ItemIndex;
 BoxFromE;
end;

procedure TBoxDlg.Edit2Change(Sender: TObject);
var
 lev:  integer;
begin
 fl:=IntFromEdit(edit2);
 if fy>=0 then lev:=level[fy] else lev:=level[ny];
 if (fl<1) or (fl>lev) then
  label12.Caption:='Enter Level (1-'+inttostr(lev)+')'
 else
  label12.Caption:='Level '+inttostr(fl);
end;

procedure TBoxDlg.Edit8Change(Sender: TObject);
var
 s:  string;
 lev:  integer;
begin
 s:=trim(edit8.text);
 tl:=IntFromEdit(edit8);
 if ty>=0 then lev:=level[ty] else lev:=level[ny];
 if (tl<1) or (tl>lev) then
  label12.Caption:='Enter Level (1-'+inttostr(lev)+')'
 else
  label12.Caption:='Level '+s;
end;

function TBoxDlg.FromFlags: bool;
begin
 result:=false;
 Bflag:=false; Fflag:=false; Dflag:=false;  CopyStop:=False;
 Tflag:=(box1=0) or (box1=3) or (box1=4) or (box1=5);
 Yflag:=(box1<4) or (box1=5);
 Lflag:=(box1<2) or (box1=5);
 if fd<0 then
  begin
   ComboMsg('Check ''From'' Day',ComboBox2);
   result:=true;
   exit;
  end;
 if Tflag then if (fp<0) or (fp>=Tlimit[fd]) then
  begin
   ComboMsg('Check ''From'' Time Slot',ComboBox5);
   result:=true;
   exit;
  end;
 if Yflag then if fy<0 then
  begin
   ComboMsg('Check ''From'' '+Yeartitle,ComboBox1);
   result:=true;
   exit;
  end;
 if Lflag then if (fl<1) or (fl>level[fy]) then
  begin
   ShowMsg('Check ''From'' Level',edit2);
   result:=true;
   exit;
  end;
end;

function TBoxDlg.ToFlags: bool;
begin
 result:=false;
 Bflag:=false; Fflag:=false; Dflag:=false;
 Tflag:=(box1=0) or (box1=3) or (box1=4) or (box1=5);
 Yflag:=(box1<4);
 Lflag:=(box1<2);
 if td<0 then
  begin
   ComboMsg('Check ''To'' Day',ComboBox3);
   result:=true;
   exit;
  end;
 if Tflag then if (tp<0) or (tp>=Tlimit[td]) then
  begin
   ComboMsg('Check ''To'' Time Slot',ComboBox6);
   result:=true;
   exit;
  end;
 if Yflag then if ty<0 then
  begin
   ComboMsg('Check ''To'' '+Yeartitle,ComboBox4);
   result:=true;
   exit;
  end;
 if Lflag then if (tl<1) or (tl>level[ty]) then
  begin
   ShowMsg('Check ''To'' Level',edit8);
   result:=true;
   exit;
  end;
end;


procedure Checkunit;
var
 Sbyte1, Sbyte2: byte;
 Double1, Fix1:  wordbool;
 Nblock1: byte;
begin
 Sbyte1:=FNTByte(fd,fp,fy,fl,6)^;
 Sbyte2:=FNTByte(td,tp,ty,tl,6)^;
 Double1:=((sByte1 and 1)=1); Fix1:=((sByte1 and 4)=4);
 Nblock1:=FNgetBlockNumber(fd,fp,fy,fl);
 if copyop<>3 then
  begin
   if Fix1 then
    begin
     Fflag:=true;
     exit;
    end;
   if (Nblock1>0) and (box1=0) then Bflag:=True;
   if Double1 then Dflag:=true;
  end;
 if Copyop=0 then exit;
 Double1:=((sByte2 and 1)=1); Fix1:=((sByte2 and 4)=4);
 Nblock1:=FNgetBlockNumber(td,tp,ty,tl);
 if Fix1 then Fflag:=true;
 if (Nblock1>0) and (box1=0) then Bflag:=True;
 if Double1 then Dflag:=true;
end;

procedure CheckBox;
var
 msg: string;
begin
 if Fflag then
  begin
   msg:='One or more entries are fixed - can''t '+optype;
   messagedlg(msg,mtWarning,[mbOK],0);
   CopyStop:=true;
   exit;
  end;
 if not(warn) then exit;
 if Bflag then
  begin
   if OpCheck('','block',Optype) then CopyStop:=true;
   if CopyStop then exit;
  end;
 if Dflag then if OpCheck('','double',Optype) then CopyStop:=true;
end;

Procedure DoUnit;
var
 Tmax1: smallint;
 A,B,C:  tpIntPoint;
 Swapint,Lplace,Lplace1:   smallint;

 procedure ClearLabel;
 begin
  Lplace:=A^; if Lplace<=LabelBase then exit;
  Lplace:=Lplace-LabelBase;
  TcLabel[Lplace]:='';
  if Lplace=Lnum then dec(Lnum);
  if Lnum<0 then Lnum:=0;
 end;

 procedure NewLabel;
 begin
  Lplace1:=B^; if Lplace1<=LabelBase then exit;
  Lplace1:=Lplace1-LabelBase;
  Lplace:=FindLabel; if Lplace=0 then exit;
  B^:=Lplace+LabelBase;
  TcLabel[Lplace]:=TcLabel[Lplace1];
 end;

begin
 Tmax1:=Tlimit[fd];
 if Tmax1>Tlimit[td] then Tmax1:=Tlimit[td];
 if Copyop<3 then PushCell(fd,fp,fy,fl);
 if CopyOp>0 then PushCell(td,tp,ty,tl);
 if(Copyop=0) and (fp<Tlimit[fd]) then  {clear}
  begin
   A:=FNT(fd,fp,fy,fl,0);
   ClearLabel; A^:=0;
   inc(A); A^:=0; inc(A); A^:=0; inc(A); A^:=0;
  end;
 if (CopyOp>0) and ((box1=1) or (box1=2) or (box1=6)) then
  if (fp>=Tmax1) OR (tp>=Tmax1) then exit;
 if (CopyOp=1) or (CopyOp=3) then
  begin
   A:=FNT(td,tp,ty,tl,0);
   ClearLabel;
  end;
 if (CopyOp=1) then {move}
  begin
  C:=FNT(fd,fp,fy,fl,0); B:=FNT(td,tp,ty,tl,0); B^:=C^; C^:=0;
  inc(B); inc(C); B^:=C^; C^:=0;
  inc(B); inc(C); B^:=C^; C^:=0;
  inc(B); inc(C); B^:=C^; C^:=0;
  end;
 if (CopyOp=2) then {swap}
  begin
  C:=FNT(fd,fp,fy,fl,0); B:=FNT(td,tp,ty,tl,0);
  Swapint:=B^; B^:=C^; C^:=Swapint;
  inc(B); inc(C); Swapint:=B^; B^:=C^; C^:=Swapint;
  inc(B); inc(C); Swapint:=B^; B^:=C^; C^:=Swapint;
  inc(B); inc(C); Swapint:=B^; B^:=C^; C^:=Swapint;
  end;
 if (CopyOp=3) then {copy}
  begin
  C:=FNT(fd,fp,fy,fl,0); B:=FNT(td,tp,ty,tl,0); B^:=C^; NewLabel;
  inc(B); inc(C); B^:=C^;
  inc(B); inc(C); B^:=C^;
  inc(B); inc(C); B^:=C^;
  end;
 if Copyop>0 then Fclash[td,tp]:=1;
 Fclash[fd,fp]:=1;
end;


procedure copycell;
begin
 CheckUnit;
 CheckBox;
 if CopyStop then exit;
 DoUnit;
end;

procedure copylevel;
var
 xxfp: smallint;
begin
 for xxfp:=0 to periods-1 do
  begin
   fp:=xxfp;
   tp:=fp;
   CheckUnit;
  end;
 CheckBox;
 if CopyStop then exit;
 for xxfp:=0 to periods-1 do
  begin
   fp:=xxfp;
   tp:=fp;
   DoUnit;
  end;
end;

procedure copyyear;
var
 xxfp,xxfl: smallint;
begin
 for xxfp:=0 to periods-1 do
  for xxfl:=1 to level[fy] do
   begin
    fp:=xxfp; fl:=xxfl;
    tp:=fp; tl:=fl;
    CheckUnit;
   end;
 CheckBox;
 if CopyStop then exit;
 for xxfp:=0 to periods-1 do
  for xxfl:=1 to level[fy] do
   begin
    fp:=xxfp; fl:=xxfl;
    tp:=fp; tl:=fl;
    DoUnit;
   end;
end;

procedure copyYrTime;
var
 xxfl: smallint;
begin
 for xxfl:=1 to level[fy] do
  begin
   fl:=xxfl;
   tl:=fl;
   CheckUnit;
  end;
 CheckBox;
 if CopyStop then exit;
 for xxfl:=1 to level[fy] do
  begin
   fl:=xxfl;
   tl:=fl;
   DoUnit;
  end;
end;

procedure copyTime;
var
 xxfy,xxfl: smallint;
begin
 for xxfy:=0 to years_minus_1 do
  for xxfl:=1 to level[xxfy] do
   begin
    fy:=xxfy; fl:=xxfl;
    ty:=fy; tl:=fl;
    CheckUnit;
   end;
 CheckBox;
 if CopyStop then exit;
 for xxfy:=0 to years_minus_1 do
  for xxfl:=1 to level[xxfy] do
   begin
    fy:=xxfy; fl:=xxfl;
    ty:=fy; tl:=fl;
    DoUnit;
   end;
end;

procedure copyBlock;
var
 msg:          string;
 ml1,ml2,fli:    integer;
begin
 if not(GetBlockLevels(fd,fp,fy,fl,ml1,ml2)) then
  begin
   msg:='No block at ''From'' position';
   messagedlg(msg,mtWarning,[mbOK],0);
   exit;
  end;
 for fli:=ml1 to ml2 do
  begin
   fl:=fli;
   tl:=fl; ty:=fy;
   CheckUnit;
  end;
 CheckBox;
 if CopyStop then exit;
 for fli:=ml1 to ml2 do
  begin
   fl:=fli;
   tl:=fl; ty:=fy;
   DoUnit;
  end;
end;

procedure copyDay;
var
 xxfp,xxfy,xxfl: smallint;
begin
 for xxfp:=0 to periods-1 do
  for xxfy:=0 to years_minus_1 do
   for xxfl:=1 to level[xxfy] do
    begin
     fl:=xxfl; fy:=xxfy; fp:=xxfp;
     tp:=fp; ty:=fy; tl:=fl;
     CheckUnit;
    end;
 CheckBox;
 if CopyStop then exit;
 for xxfp:=0 to periods-1 do
  for xxfy:=0 to years_minus_1 do
   for xxfl:=1 to level[xxfy] do
    begin
     fl:=xxfl; fy:=xxfy; fp:=xxfp;
     tp:=fp; ty:=fy; tl:=fl;
     DoUnit;
    end;
end;


procedure TBoxDlg.CopyGeneral;
begin
 if fromflags then exit;
 if Copyop>0 then if toflags then exit;
 PushTtStackStart(utBoxClear+CopyOp);
 case box1 of
  bxcell: copycell;
  bxLevel: copylevel;
  bxYear: copyyear;
  bxYrTime: copyYrTime;
  bxTime: copyTime;
  bxblock: copyblock;
  bxday: copyday;
 end;
 if CopyStop then exit;
 ttclash;
 UpdateTimetableWins;
 SaveTimeFlag:=True;
end;

procedure TBoxDlg.CopyBtnClick(Sender: TObject);
begin
 Copyop:=3; Optype:='Copy';
 CopyGeneral; Restore;
end;

procedure TBoxDlg.SwapBtnClick(Sender: TObject);
begin
 CopyOp:=2; Optype:='Swap';
 CopyGeneral; Restore;
end;

procedure TBoxDlg.MoveBtnClick(Sender: TObject);
begin
 CopyOp:=1; Optype:='Move';
 CopyGeneral; Restore;
end;

procedure TBoxDlg.ClearBtnClick(Sender: TObject);
begin
 CopyOp:=0; Optype:='Clear';
 CopyGeneral; Restore;
end;

procedure TBoxDlg.Edit4KeyPress(Sender: TObject; var Key: Char);
begin
 allowNumericInputOnly(key);
end;

procedure TBoxDlg.ComboBox2Change(Sender: TObject);
begin
 if ChangeDayCombo(fd,Combobox2,combobox5) then ComboBox5Change(Sender);
 fd:=findDayMsg(Combobox2.text,label12);
end;

procedure TBoxDlg.ComboBox1Change(Sender: TObject);
begin
 fy:=findYear(Combobox1.text);
 if fy=-1 then
  label12.Caption:='Enter '+yeartitle
 else
  label12.Caption:=Yeartitle+' '+Yearname[fy];
end;

procedure TBoxDlg.ComboBox4Change(Sender: TObject);
begin
 ty:=findYear(Combobox4.text);
 if ty=-1 then
  label12.Caption:='Enter '+yeartitle
 else
  label12.Caption:=Yeartitle+' '+Yearname[ty];
end;

procedure TBoxDlg.ComboBox3Change(Sender: TObject);
begin
 if ChangeDayCombo(td,Combobox3,combobox6) then ComboBox6Change(Sender);
 td:=findDayMsg(Combobox3.text,label12);
end;

procedure TBoxDlg.ComboBox5Enter(Sender: TObject);
begin
 ComboBox5.SelectAll;
end;

procedure TBoxDlg.ComboBox6Enter(Sender: TObject);
begin
 ComboBox6.SelectAll;
end;

procedure TBoxDlg.ComboBox5Change(Sender: TObject);
begin
 ChangeTimeCombo(fp,combobox5,label12);
end;

procedure TBoxDlg.ComboBox6Change(Sender: TObject);
begin
 ChangeTimeCombo(tp,combobox6,label12);
end;


end.
