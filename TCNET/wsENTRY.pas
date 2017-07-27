unit wsEntry;

interface

uses SysUtils,WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls,Dialogs,Grids, TimeChartGlobals,GlobalToTcAndTcextra, XML.TEACHERS;

type
  TwsEntryDlg = class(TForm)
    HelpBtn: TBitBtn;
    Finish: TBitBtn;
    SkipBtn: TBitBtn;
    EnterBtn: TBitBtn;
    ClearBtn: TBitBtn;
    AutoMove: TRadioGroup;
    GroupBox1: TGroupBox;
    LabelBox: TCheckBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit2: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Edit5: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    WarnBox: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    BlockChk: TCheckBox;
    ShareBox: TCheckBox;
    Label4: TLabel;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    ComboBox5: TComboBox;
    cboSubject: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure AutoMoveClick(Sender: TObject);
    procedure ShareBoxClick(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure LabelBoxClick(Sender: TObject);
    procedure EnterBtnClick(Sender: TObject);
    procedure SkipBtnClick(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
    procedure WarnBoxClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FinishClick(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure ComboBox3Change(Sender: TObject);
    procedure ComboBox4Change(Sender: TObject);
    procedure ComboBox5Change(Sender: TObject);
    procedure cboSubjectChange(Sender: TObject);
  private
    procedure Restore;
    procedure NewPos;
    procedure ClearPos;
    procedure SetButtonStatus;
  end;

var
  wsEntryDlg: TwsEntryDlg;

procedure setwsEntryDlg;

implementation

{$R *.DFM}
uses tcommon,tcommon2,tcommon5, Worksheet,DlgCommon,TTundo;

var
 Sub1,Te1,Room1,EnLabel,Nblock:  smallint;
 OldSub1,OldTe1,OldRoom1,Mult1:        Integer;
 flgShare,flgTclash,flgRclash:      bool;
 posy,posl,posb:  integer;
 startflag,HasPos:            bool;

procedure setSelectedCell;
var
 CurRow,CurCol: integer;
 Srect: TGridRect;
begin
 CurRow:=FindWSrow(wsy,wsl);
 CurCol:=wsb;
 Srect.top:=CurRow; Srect.bottom:=CurRow;
 Srect.left:=CurCol; Srect.right:=CurCol;
 WorkSheetwin.StringGrid1.selection:=Srect;
end;

procedure setwsEntryDlg;
begin
 startFlag:=true;
 with wsEntryDlg do
  begin
   if wsMultChangeFlg then FillComboMult(ComboBox3);
   Restore;
  end; 
 startFlag:=false;
end;

procedure TwsEntryDlg.ClearPos;
begin
 edit5.Text:='';       Combobox4.Text:='';   Combobox5.Text:='';
 cboSubject.text :='';  //mantis -01591
end;

procedure TwsEntryDlg.SetButtonStatus;
begin
 EnterBtn.Enabled:=HasPos;
 SkipBtn.Enabled:=HasPos;
 ClearBtn.Enabled:=HasPos;
end;


procedure TwsEntryDlg.NewPos;
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


procedure TwsEntryDlg.Restore;
var
 IntPoint:      tpIntPoint;
 s:             string;
 cByte,sByte:   byte;
 i,j,m,k,sub,subSz,yearY,L:     smallint;
 TeFound:   array[0..nmbrteachers] of boolean;
 RoFound:   array[0..nmbrRooms] of boolean;
 aFnt:          tpintpoint;
begin
 IntPoint:=FNWS(wsb,wsy,wsl,0);
 Sub1:=IntPoint^;
 inc(IntPoint); te1:=IntPoint^;
 inc(IntPoint); room1:=IntPoint^;
 inc(IntPoint,2); mult1:=IntPoint^;
 sByte:=FNWSByte(wsb,wsy,wsl,6)^;
 cByte:=FNWSByte(wsb,wsy,wsl,7)^;
 flgShare:=((sByte and 2)=2);   {2nd bit}
 Nblock:=FNgetWSblockNumber(wsb,wsy,wsl);
 flgTclash:=((cByte and 8)=8); {4th bit}
 flgRclash:=((cByte and 16)=16); {5th bit}
 posy:=wsy; posl:=wsl; posb:=wsb;  HasPos:=true;
 ComboBox1.ItemIndex := ComboBox1.Items.IndexOf(yearname[wsy]);
 Edit2.text:=inttostr(wsl);
 ComboBox2.ItemIndex := ComboBox2.Items.IndexOf(IntToStr(wsb));
 if (mult1>=0) and (mult1<=wsMultNum) then
  if wsOrder[mult1]>=0 then combobox3.ItemIndex:=wsOrder[mult1];

 if Sub1>LabelBase then
  begin
   EnLabel:=Sub1-LabelBase;
   Sub1:=0;
   Labelbox.checked:=true;
   if ((EnLabel>0) and (EnLabel<=nmbrlabels)) then
    s:=TcLabel[EnLabel]
   else s:='';
   s:=TrimRight(s);
   Edit5.text:=s;
   cboSubject.text :='';   //mantis -01591
   Combobox4.text:='';
   Combobox5.text:='';
   Edit5.Enabled:=True;
   cboSubject.Enabled:=False;   //mantis -01591
   Combobox4.Enabled:=False; Combobox5.Enabled:=False;
  end
 else
  begin
   Labelbox.checked:=false;
   EnLabel:=0;
   Edit5.text:='';

    //mantis -01591
  { if ((Sub1>0) and (Sub1<=nmbrsubjects)) then
    Edit6.text:=trim(SubCode[Sub1])
   else Edit6.text:='';  }


    cboSubject.Clear;
  for i := 1 to CodeCount[0] do
    cboSubject.Items.AddObject(Trim(SubCode[CodePoint[i, 0]]), TObject(codepoint[i, 0]));

   if ((Sub1>0) and (Sub1<=nmbrsubjects)) then
    cboSubject.text := trim(SubCode[Sub1])
   else
    cboSubject.text := '';
         //mantis -01591


   //populate Teacher dropdown
   for j:=1 to numcodes[1] do TeFound[j]:=false;
   for yearY:=0 to years_minus_1 do
    for L:=1 to level[yearY] do
     begin
      aFnt:=FNWS(wsb,yearY,L,2);
      m:=aFNt^;
      if (m>0) and (m<=numcodes[1]) then TeFound[m]:=true;
     end; {for L}
   combobox4.Clear;
   for i:=1 to codeCount[1] do
    begin
     k:=codepoint[i,1];
     if TeFound[k] then continue;  //only if free
      combobox4.items.add(XML_TEACHERS.tecode[k,0]{+' '+tename[k,0]});
    end;

   //populate Room dropdown
   aFnt:=FNWS(wsb,wsy,wsl,0);
   sub:=aFnt^;
   if (sub>0) and (sub<=numcodes[0]) then subSz:=GroupSubCount[GsubXref[sub]]
    else subSz:=0;
   for j:=1 to numcodes[2] do RoFound[j]:=false;
   for yearY:=0 to years_minus_1 do
    for L:=1 to level[yearY] do
     begin
      aFnt:=FNWS(wsb,yearY,L,4);
      m:=aFNt^;
      if (m>0) and (m<=numcodes[2]) then RoFound[m]:=true;
     end; {for L}
   combobox5.Clear;
   for i:=1 to codeCount[2] do
    begin
     k:=codepoint[i,2];
     if RoFound[k] then continue;  //only if free
     if (XML_TEACHERS.RoSize[k]>=subSz) then   //only if room capacity is large enough for the class
       combobox5.items.add(XML_TEACHERS.tecode[k,1]);
    end; {for i}

   if ((te1>0) and (te1<=nmbrteachers)) then
     Combobox4.Text := Trim(XML_TEACHERS.tecode[te1,0])
   else
     Combobox4.Text := '';
   if ((room1>0) and (room1<=nmbrrooms)) then
    Combobox5.Text := Trim(XML_TEACHERS.tecode[room1,1])
   else
     Combobox5.Text := '';
   Edit5.Enabled:=False;
   cboSubject.Enabled:=True;   //mantis -01591
   Combobox4.Enabled:=True; Combobox5.Enabled:=True;
  end;
 Sharebox.Checked:=flgShare;
 BlockChk.Checked:=(Nblock>0);
 s:=inttostr(wsTclash[wsb]);
 if flgTclash then s:=s+'*';
 label8.Caption:=s;
 s:=inttostr(wsRclash[wsb]);
 if flgRclash then s:=s+'*';
 label9.Caption:=s;
 oldSub1:=Sub1; oldTe1:=Te1; oldRoom1:=Room1;
end;


procedure TwsEntryDlg.FormCreate(Sender: TObject);
begin
 topcentre(self);
 startflag:=true;
 FillComboYears(false,ComboBox1);
 FillComboBlocks(Combobox2);
 FillComboMult(ComboBox3);
 AutoMove.ItemIndex:=arrow;
 WarnBox.checked:=Bool(WSeWarn);
 label1.caption:='&'+Yeartitle;

 Edit5.Maxlength:=szTcLabel;
 //Edit6.Maxlength:=lencodes[0];
 cboSubject.Maxlength :=lencodes[0];  //mantis -01591
 Combobox4.Maxlength:=lencodes[1];
 Combobox5.Maxlength:=lencodes[2];
 BringIntoView;
 startflag:=false;
 fwsEntryDlgUp:=true;
end;

procedure TwsEntryDlg.FormActivate(Sender: TObject);
begin
 Restore;
end;

procedure TwsEntryDlg.AutoMoveClick(Sender: TObject);
begin
 arrow:=AutoMove.ItemIndex;
end;

procedure TwsEntryDlg.ShareBoxClick(Sender: TObject);
begin
 flgShare:=ShareBox.Checked;
end;


procedure TwsEntryDlg.Edit2Change(Sender: TObject);
var
 oldval: integer;
begin
 if startflag then exit;
 oldval:=posl;
 posl:=getLevel(wsy,Edit2.text,label12);
 if (posl<>oldval) then NewPos;
end;

 {
procedure TwsEntryDlg.Edit6Change(Sender: TObject);
var
 codeStr: string;
begin
 codeStr:=trim(Edit6.text);
 Sub1:=checkCode(0,codestr);
 if Sub1=0 then label11.caption:='Enter Subject code'
  else label11.caption:=subname[Sub1];
end; }

Function CheckClash(Te,code,b,y,l: integer): bool;
var
 y2,l2:     integer;
 IntPoint:  tpIntPoint;
 found:     bool;
begin
 found:=False;
 for y2:=0 to years_minus_1 do
  begin
   for l2:=1 to level[y2] do
   begin
    if (y2=y) and (l2=l) then continue;
    IntPoint:=FNWS(b,y2,l2,2*code);
    if Te=IntPoint^ then
     begin
      found:=true;
      break;
     end;
   end;
   if found then break;
  end;
 result:=found;
end;

procedure TwsEntryDlg.LabelBoxClick(Sender: TObject);
begin                                    
 if Labelbox.checked=true then
  begin
   Edit5.Enabled:=True;
   cboSubject.Enabled:=False;   //mantis -01591
   Combobox4.Enabled:=False; Combobox5.Enabled:=False;
  end
 else
  begin
   Edit5.Enabled:=False;
   cboSubject.Enabled:=True;   //mantis -01591
   Combobox4.Enabled:=True; Combobox5.Enabled:=True;
  end;
end;


procedure Stepon;
var
 oldy,oldl,oldb: integer;
begin
 oldy:=wsy; oldl:=wsl; oldb:=wsb;
 wsMoveSelect(arrow);
 if (oldy=wsy) and (oldb=wsb) and (oldl=wsl) then exit;
 setSelectedCell;  BringIntoView;
 wsEntryDlg.restore;
end;

function clashwarn(b,y,l: integer): bool;
var
 msg: string;
begin
 result:=false;
 if not(WSeWarn) then exit;
 msg:='';
 if (Te1>0) then if CheckClash(Te1,1,b,y,l) then
    msg:='Teacher clash! ';
 if (Room1>0) then if CheckClash(Room1,2,b,y,l) then
    msg:=msg+'Room clash! ';
 if msg>'' then
  begin
   msg:=msg+'at '+'Block '+inttostr(b);
   msg:=msg+endline+'Continue with entry?';
   if messagedlg(msg,mtWarning,[mbyes,mbno],0)<>mrYes then result:=true;
  end;
end;

function labelwarn: bool;
var msg: string;
begin
 result:=false;
 if not(WSeWarn) then exit;
 if (oldSub1=0) and (oldTe1=0) and (oldRoom1=0) then exit;
 msg:='Label will replace ';
 if oldSub1>0 then msg:=msg+SubCode[oldSub1]+' ';
 if oldTe1>0 then msg:=msg+XML_TEACHERS.tecode[oldTe1,0]+' ';
 if oldRoom1>0 then msg:=msg+XML_TEACHERS.tecode[oldRoom1,1]+' ';
 msg:=msg+endline+'Continue with entry?';
 if messagedlg(msg,mtWarning,[mbyes,mbno],0)<>mrYes then result:=true;
end;

procedure DeleteLabel(Lplace: integer);
begin
 if (Lplace<0) or (Lplace>nmbrLabels) then exit;
 TcLabel[Lplace]:='';
 if Lplace=Lnum then dec(Lnum);
end;




procedure AddLabel;
var
 oldLabel,newlabel,checkstr: string;
 oldEnlabel: integer;
begin
 oldEnlabel:=Enlabel;
 oldLabel:='';
 if Enlabel>0 then
  begin
   oldLabel:=TcLabel[EnLabel];
   TcLabel[Enlabel]:='';
  end;
 newLabel:=TrimRight(wsEntryDlg.Edit5.Text);
 checkstr:=newLabel;
 if (Enlabel=0) and (checkstr>'') then Enlabel:=FindLabel;
 if checkstr='' then Enlabel:=0;
 if (Enlabel=0) and (checkstr>'') then
  begin
   messagedlg('No room to add more labels',mtError,[mbOK],0);
   exit;
  end;
 if checkstr>'' then TcLabel[Enlabel]:=newLabel;
 FNWS(wsb,wsy,wsl,0)^:=Enlabel+LabelBase;
 FNWS(wsb,wsy,wsl,2)^:=0;
 FNWS(wsb,wsy,wsl,4)^:=0;
 FNWS(wsb,wsy,wsl,6)^:=0;
 if oldEnlabel=0 then wsFclash[wsb]:=1;
end;


procedure TwsEntryDlg.EnterBtnClick(Sender: TObject);
var
 IntPoint:  tpIntPoint;
 sByte:     Byte;
begin
if Labelbox.checked=false then
 begin
 if (Sub1=0) and (trim(cboSubject.text)<>'') then     //mantis -01591
  begin
   ComboMsg('Check subject code',cboSubject);
   exit;
  end;
 if (Te1=0) and (trim(Combobox4.text)<>'') then
  begin
   ComboMsg('Check teacher code',Combobox4);
   exit;
  end;
  if (Room1=0) and (trim(Combobox5.text)<>'') then
  begin
   ComboMsg('Check room code',Combobox5);
   exit;
  end;
  if not(flgshare) then if clashwarn(posb,posy,posl) then exit; {don't do entry}
  if Labelbox.checked then if labelwarn then exit;
 end; {not label}

 pushOneWSstack(wsb,wsy,wsl,utEditWSentry);
 IntPoint:=FNws(wsb,wsy,wsl,0);

 if Labelbox.checked then
   addlabel
 else
   begin
    if Enlabel>0 then DeleteLabel(Enlabel);
    IntPoint^:=Sub1;
    inc(IntPoint); IntPoint^:=Te1;
    inc(IntPoint); IntPoint^:=Room1;
    inc(IntPoint,2); IntPoint^:=mult1;
    sByte:=0;   {status byte}
    if flgShare then sByte:=sByte or 2;
    FNwsByte(wsb,wsy,wsl,6)^:=Sbyte;
    if BlockChk.Checked then Nblock:=wsb else Nblock:=0;
    //keep to set other flags but set block number properly
    FNputWSblockNumber(wsb,wsy,wsl,Nblock);
   end;
 wsFclash[wsb]:=1;
 wsBlockClash(wsb);                                 
 Stepon;
 Restore;
 WSclash;
 UpdateWSwins;
 SaveTimeFlag:=True;
end;
                                        
procedure TwsEntryDlg.SkipBtnClick(Sender: TObject);
begin                                     
 Stepon;
end;

procedure TwsEntryDlg.cboSubjectChange(Sender: TObject);  //mantis -01591
var
 codeStr: string;
begin
 codeStr:=trim(cboSubject.text);
 Sub1:=checkCode(0,codestr);
 if Sub1=0 then label11.caption:='Enter Subject code'
  else label11.caption:=subname[Sub1];

end;

procedure TwsEntryDlg.ClearBtnClick(Sender: TObject);
begin
 pushOneWSstack(wsb,wsy,wsl,utEditWSentry);
 if Enlabel>0 then DeleteLabel(Enlabel);
 FNws(wsb,wsy,wsl,0)^:=0;
 FNws(wsb,wsy,wsl,2)^:=0;
 FNws(wsb,wsy,wsl,4)^:=0;
 FNws(wsb,wsy,wsl,6)^:=0;
 wsFclash[wsb]:=1;
 wsBlockClash(wsb);
 Stepon;
 Restore;
 UpdateWSwins;
 SaveTimeFlag:=True;
end;

procedure TwsEntryDlg.WarnBoxClick(Sender: TObject);
begin
 WSeWarn:=WarnBox.checked;
end;

procedure TwsEntryDlg.ComboBox1Change(Sender: TObject);
var
 oldval: integer;
begin
 if startflag then exit;
 oldval:=posy;
 posy:=findYearname(ComboBox1.text,label12);
 if (posy<>oldval) then NewPos;
end;

procedure TwsEntryDlg.ComboBox2Change(Sender: TObject);
var
 oldval: integer;
begin
 if startflag then exit;
 oldval:=posb;
 posb:=findWSblock(ComboBox2.text,label12);
 if (posb<>oldval) then NewPos;
end;

procedure TwsEntryDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 UpdateTimetableWins;
 action:=caFree; fwsEntryDlgUp:=false;
 if ((usrPassLevel=utTime) or (usrPassLevel=utSuper)) then
  if not(saveTimeFlag) then CheckAccessRights(utTime,16,false);
end;

procedure TwsEntryDlg.FinishClick(Sender: TObject);
begin
 close;
end;

procedure TwsEntryDlg.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
 allowNumericInputOnly(key);
end;

procedure TwsEntryDlg.ComboBox3Change(Sender: TObject);
begin
 if startflag then exit;
 GetMultIndex(mult1,Combobox3);
end;

procedure TwsEntryDlg.ComboBox4Change(Sender: TObject);
var
 codeStr: string;
begin
 codeStr:=trim(Combobox4.text);
 Te1:=checkCode(1,codestr);
 if Te1=0 then label11.caption:='Enter Teacher code'
  else
   if CheckClash(Te1,1,posb,posy,posl) then label11.Caption:='This Code Clashes!'
    else label11.Caption:=XML_TEACHERS.TeName[te1,0];
end;

procedure TwsEntryDlg.ComboBox5Change(Sender: TObject);
var
 codeStr: string;
begin
 codeStr:=trim(Combobox5.text);
 Room1:=checkCode(2,codestr);
 if Room1=0 then label11.caption:='Enter Room code'
  else
   if CheckClash(Room1,2,posb,posy,posl) then label11.Caption:='This Code Clashes!'
    else label11.Caption:=XML_TEACHERS.TeName[Room1,1];
end;

end.



