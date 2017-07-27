unit Chelp;

interface

uses SysUtils, WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, Dialogs, TimeChartGlobals,GlobalToTcAndTcextra, XML.DISPLAY,
  XML.TEACHERS;

type
  TClashHelpDlg = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    HelpBtn: TBitBtn;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Edit2: TEdit;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ClashScope: TRadioGroup;
    ClashType: TRadioGroup;
    GroupBox2: TGroupBox;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    ComboBox3: TComboBox;
    edtSubjectList: TEdit;
    edtTeacherList: TEdit;
    edtRoomsList: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure TeEditChange(Sender: TObject);
    procedure RoEditChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ClashScopeClick(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure ClashTypeClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure ComboBox3Change(Sender: TObject);
    procedure ComboBox3Enter(Sender: TObject);
    procedure RefreshHint(Sender: TObject);
  end;

var
  ClashHelpDlg: TClashHelpDlg;

implementation

{$R *.DFM}
uses tcommon,DlgCommon,ttable,tcommon2;
var
 bd, bp, by, bl:  integer;
 CanShow,firstStart: bool;
 teEdit:  array[1..8] of TEdit;
 roEdit:  array[1..8] of TEdit;
 Nblock,l1,l2:  integer;
 tegroup, sugroup, rogroup:  tplevelsub;
 Ntegroup,Nsugroup,Nrogroup:  integer;


procedure TClashHelpDlg.FormCreate(Sender: TObject);
var
 i,temp: integer;
 s:      string;
begin
 firstStart:=true;
 ClashScope.ItemIndex:=XML_DISPLAY.chScope;
 ClashType.ItemIndex:=XML_DISPLAY.chType;
 label3.caption:='&'+Yeartitle;
 edtSubjectList.Font.Color := FontColorPair[cpSub,1];
 edtTeacherList.Font.Color := FontColorPair[cpTeach,1];
 edtRoomsList.Font.Color := FontColorPair[cpRoom,1];
 FillComboYears(false,ComboBox1);
 FillComboDays(false,ComboBox2);
 FillComboTimeSlots(false,nd,combobox3);
 for i:=1 to 8 do
  begin
   teEdit[i]:=TEdit.create(application);  roEdit[i]:=TEdit.create(application);
   teEdit[i].parent:=GroupBox2;           roEdit[i].parent:=GroupBox2;
   teEdit[i].text:='';                    roEdit[i].text:=''; { values needed}

   teEdit[i].hint:='Enter teacher code';  roEdit[i].hint:='Enter room code';
   teEdit[i].showhint:=true;              roEdit[i].showhint:=true;

   teEdit[i].width:=105;                  roEdit[i].width:=105;
   teEdit[i].height:=20;                  roEdit[i].height:=20;
   teEdit[i].left:=64+((i-1) mod 4)*112;  roEdit[i].left:=64+((i-1) mod 4)*112;
   teEdit[i].top:=17+((i-1) div 4)*24;    roEdit[i].top:=65+((i-1) div 4)*24;
   teEdit[i].OnChange:=TeEditChange;      roEdit[i].OnChange:=RoEditChange;
   teEdit[i].tag:=i;                      roEdit[i].tag:=i;
   teEdit[i].Maxlength:=lencodes[1];      roEdit[i].Maxlength:=lencodes[2];
   s:=''; temp:=chtegroup[i];
   if (temp>0) and (temp<=numcodes[1]) then s:=XML_TEACHERS.tecode[temp,0];
   teEdit[i].text:=s;
   s:=''; temp:=chrogroup[i];
   if (temp>0) and (temp<=numcodes[2]) then s:=XML_TEACHERS.tecode[temp,1];
   roEdit[i].text:=s;
  end;
 by:=ny; bl:=nl; bd:=nd; bp:=np;
end;

procedure Restore;
var
  IntPoint:      tpIntPoint;
  s:             string;
  l,i:             integer;
  su,te,ro:      integer;
  lLongestLength: Integer;
begin
 lLongestLength := GetLongestLength;
 Ntegroup:=0; Nsugroup:=0; Nrogroup:=0;
 l1:=0; l2:=0; Canshow:=False; Nblock:=0;
 if ((bl>0) and (bl<=level[by]) and (bp>=0) and (bp<=Tlimit[bd])) or (XML_DISPLAY.chScope=3) then
  begin      { ^- check on valid position}
   Case XML_DISPLAY.chScope of
    0: begin  {cell}
        l1:=bl; l2:=bl;
       end;
    1: GetBlockLevels(bd,bp,by,bl,l1,l2);  {block}
    2: begin              {yr/time}
        l1:=1; l2:=level[by];
       end;
    3: for i:=1 to 8 do
         begin
          if chTegroup[i]>0 then
           begin
            inc(Ntegroup); TeGroup[Ntegroup]:=chTegroup[i];
           end;
          if chrogroup[i]>0 then
           begin
            inc(Nrogroup); RoGroup[Nrogroup]:=chRogroup[i];
           end;
         end;
   end;
   if (l1>0) then
    for l:=l1 to l2 do
     begin
      Intpoint:=FNT(bd,bp,by,l,0);
      su:=Intpoint^;
      if (su>0) and (su<=LabelBase) then
       begin
        inc(Nsugroup); SuGroup[Nsugroup]:=su;
       end;
      inc(Intpoint); te:=Intpoint^;
      if (te>0) then
       begin
        inc(Ntegroup); TeGroup[Ntegroup]:=te;
       end;
      inc(Intpoint); ro:=Intpoint^;
      if (ro>0) then
       begin
        inc(Nrogroup); RoGroup[Nrogroup]:=ro;
       end;
      i:=FNgetBlockNumber(bd,bp,by,l);
      if Nblock=0 then Nblock:=i;
     end;
  end; {if valid pos}
 with ClashHelpDlg do
 begin
  Combobox2.text:=day[bd];
  Combobox1.text:=yearname[by];
  if (bp>=0) and (bp<Tlimit[bd]) then combobox3.ItemIndex:=bp;
  if (bl>0) and (bl<=level[by]) then edit2.text:=inttostr(bl);
  s:='';
  if (Nsugroup=0) and (Ntegroup=0) and (Nrogroup=0) then
   begin
    if XML_DISPLAY.chScope=3 then s:='No custom codes entered'
     else s:='No codes at this position';
   end
  else CanShow:=True;
  if Nsugroup>0 then
   begin
    for i:=1 to Nsugroup do
     s:= s + Trim(subcode[SuGroup[i]]) + ' ' + GetSpacesToAlign(Trim(subcode[SuGroup[i]]), lLongestLength);
    end
   else if (l1=0) and (l2=0) and (XML_DISPLAY.chScope=1) then s:='No block number at this position';
  edtSubjectList.Text := s; s:='';
  if Ntegroup>0 then
   for i:=1 to Ntegroup do
     s := s + Trim(XML_TEACHERS.tecode[TeGroup[i],0]) + ' ' + GetSpacesToAlign(Trim(XML_TEACHERS.tecode[TeGroup[i],0]), lLongestLength);
  edtTeacherList.Text := s;
  if (bl<1) or (bl>level[by]) then
   begin
    label10.Caption:='Enter level in range 1-'+inttostr(level[by]);
    edit2.Setfocus; Edit2.SelectAll;
   end;
  s:='';
  if Nrogroup>0 then
   for i:=1 to Nrogroup do
     s := s + Trim(XML_TEACHERS.tecode[RoGroup[i],1]) + ' ' + GetSpacesToAlign(Trim(XML_TEACHERS.tecode[RoGroup[i],1]), lLongestLength);
  edtRoomsList.Text := s;
  if (bp<0) or (bp>=Tlimit[bd]) then
   begin
    label10.Caption:='Enter time slot in range 1-'+inttostr(Tlimit[bd]);
    combobox3.Setfocus; combobox3.SelectAll;
   end;
  label14.Caption:=inttostr(Nblock);
  if ((XML_DISPLAY.chtype=0) and (Ntegroup>0)) or ((XML_DISPLAY.chtype=1) and (Nrogroup>0)) or
    ((XML_DISPLAY.chtype=2) and ((Ntegroup+Nrogroup)>0)) then OKbtn.Enabled:=true
    else OKbtn.Enabled:=false;
 end;
end;

Procedure TClashHelpDlg.TeEditChange(Sender: TObject);
var
 i: integer;
 codeStr: string;
begin
 if firstStart then exit;
 i:=activecontrol.tag;
 codeStr:=trim(teEdit[i].text);
 chtegroup[i]:=checkCode(1,codestr);
 if chtegroup[i]=0 then label10.caption:='Enter Teacher code'
  else
   begin
    label10.Caption:=XML_TEACHERS.TeName[chtegroup[i],0];
    restore;
   end;
end;

procedure TClashHelpDlg.RefreshHint(Sender: TObject);
begin
  TLabel(Sender).Hint := TLabel(Sender).Caption;
end;

Procedure TClashHelpDlg.RoEditChange(Sender: TObject);
var
 i: integer;
 codeStr: string;
begin
 if firstStart then exit;
 i:=activecontrol.tag;
 codeStr:=trim(roEdit[i].text);
 chrogroup[i]:=checkCode(2,codestr);
 if chrogroup[i]=0 then label10.caption:='Enter Room code'
  else
   begin
    label10.Caption:=XML_TEACHERS.TeName[chrogroup[i],1];
    restore;
   end;
end;

procedure TClashHelpDlg.FormActivate(Sender: TObject);
begin
 firstStart:=true;
 Restore;
 firstStart:=false;
end;

procedure TClashHelpDlg.ClashScopeClick(Sender: TObject);
begin
 if FirstStart then exit;
 if XML_DISPLAY.chScope<>ClashScope.ItemIndex then
  begin
   XML_DISPLAY.chScope:=ClashScope.ItemIndex;
   Restore;
  end;
end;

procedure TClashHelpDlg.ComboBox2Change(Sender: TObject);
var
 found,oldday:  integer;
begin
 if FirstStart then exit;
 oldday:=bd;
 if ChangeDayCombo(bd,Combobox2,combobox3) then ComboBox3Change(Sender);
 found:=findDay(ComboBox2.text);
 if found>=0 then bd:=found;
 if bd<>oldday then restore;
end;

procedure TClashHelpDlg.ComboBox1Change(Sender: TObject);
var
 found,oldyear:  integer;
begin
 if FirstStart then exit;
 oldyear:=by;
 found:=findYear(ComboBox1.text);
 if found>=0 then by:=found;
 if oldyear<>by then restore;
end;

procedure TClashHelpDlg.Edit2Change(Sender: TObject);
var
 oldlevel:  integer;
begin
 if FirstStart then exit;
 oldlevel:=bl;
 bl:=IntFromEdit(edit2);
 if (oldlevel<>bl) and (XML_DISPLAY.chScope<>2) then restore;
end;

procedure TClashHelpDlg.ClashTypeClick(Sender: TObject);
begin
 if FirstStart then exit;
 XML_DISPLAY.chType:=ClashType.ItemIndex;
 restore;
end;

procedure TClashHelpDlg.OKBtnClick(Sender: TObject);
begin
 chd:=bd; chp:=bp; chy:=by; chl:=bl;
 ClashHelpwinSelect;   {show it if not already there}
 UpdateWindow(wnCHelp);  {ensure repaint}
end;

procedure TClashHelpDlg.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
 allowNumericInputOnly(key);
end;

procedure TClashHelpDlg.ComboBox3Change(Sender: TObject);
var
 oldperiod:  integer;
begin
 if FirstStart then exit;
 oldperiod:=bp;
 bp:=combobox3.ItemIndex;
 ComboBox3.SelectAll;
 if bp<>oldperiod then restore;
end;

procedure TClashHelpDlg.ComboBox3Enter(Sender: TObject);
begin
 ComboBox3.SelectAll;
end;

end.



