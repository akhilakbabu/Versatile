unit Entry;

interface

uses SysUtils,WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls,Dialogs,Grids, TimeChartGlobals, GlobalToTcAndTcextra, XML.DISPLAY, XML.TEACHERS;

type
  TEntryDlg = class(TForm)
    HelpBtn: TBitBtn;
    Finish: TBitBtn;
    SkipBtn: TBitBtn;
    EnterBtn: TBitBtn;
    ClearBtn: TBitBtn;
    AutoMove: TRadioGroup;
    TrackBox: TCheckBox;
    EntryScope: TRadioGroup;
    GroupBox1: TGroupBox;
    LabelBox: TCheckBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Edit2: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Edit5: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    GroupBox3: TGroupBox;
    Label10: TLabel;
    Edit9: TEdit;
    DoubleBox: TCheckBox;
    FixBox: TCheckBox;
    ShareBox: TCheckBox;
    Label11: TLabel;
    Label12: TLabel;
    WarnBox: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    cboRoom: TComboBox;
    cboSubject: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure EntryScopeClick(Sender: TObject);
    procedure TrackBoxClick(Sender: TObject);
    procedure AutoMoveClick(Sender: TObject);
    procedure Edit9KeyPress(Sender: TObject; var Key: Char);
    procedure Edit9Change(Sender: TObject);
    procedure DoubleBoxClick(Sender: TObject);
    procedure ShareBoxClick(Sender: TObject);
    procedure FixBoxClick(Sender: TObject);
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
    procedure ComboBox3Change(Sender: TObject);
    procedure ComboBox3Enter(Sender: TObject);
    procedure ComboBox4Change(Sender: TObject);
    procedure cboRoomChange(Sender: TObject);
    procedure ComboBox4DropDown(Sender: TObject);
    procedure cboSubjectChange(Sender: TObject);
  private
    FIsSmallRoomAvail: Boolean;
    procedure Restore;
    procedure NewPos;
    procedure ClearPos;
    procedure SetButtonStatus;
    procedure SetEntryScope;
    procedure FillTeachCombo;
  end;

var
  EntryDlg: TEntryDlg;

procedure setEntryDlgPosExt;

implementation

{$R *.DFM}

uses
  tcommon, DlgCommon, ttable, tcommon2, tcommon5, TTundo, uAMGConst;

var
 Sub1,Te1,Room1,EnLabel,Nblock:  Integer;
 OldSub1,OldTe1,OldRoom1:        Integer;
 flgDouble,flgShare,flgFix,flgTclash,flgRclash:      bool;
 Ebox:  byte;
 EndCol:  integer;
 posd,posp,posy,posl:  smallint;
 startflag,HasPos:            bool;

procedure setSelectedCell;
var
 CurRow,CurCol: integer;
 Srect: TGridRect;
begin
 CurRow:=FindRow(ny,nl);
 CurCol:=FindCol(nd,np);
 Srect.top:=CurRow; Srect.bottom:=CurRow;
 Srect.left:=CurCol; Srect.right:=CurCol;
 if box=bxlevel then
  begin
   Srect.left:=0; Srect.right:=EndCol;
  end;
 if box=bxyear then
  begin
   Srect.left:=0; Srect.right:=EndCol;
   Srect.top:=CurRow-nl; Srect.bottom:=CurRow+level[ny]-nl;
  end;
 Ttablewin.StringGrid1.selection:=Srect;
end;

procedure setEntryDlgPosExt;
begin
 try
   with EntryDlg do
    begin
     SetEntryScope;
     Restore;
    end;
 except
 end;
end;

procedure TEntryDlg.ClearPos;
begin
  edit5.Text:='';
  combobox4.Text:='';
  cboRoom.Text:='';
  edit9.Text:='';
  cboSubject.Text:='' //mantis -01591
end;

procedure TEntryDlg.SetButtonStatus;
begin
 EnterBtn.Enabled:=HasPos;
 SkipBtn.Enabled:=HasPos;
 ClearBtn.Enabled:=HasPos;
end;

procedure TEntryDlg.SetEntryScope;
begin
 if box=bxLevel then EntryScope.ItemIndex:=1
  else if box=bxYear then EntryScope.ItemIndex:=2
   else EntryScope.ItemIndex:=0;
 if (box<>bxLevel) and (box<>bxYear) and (box<>bxCell) then
  begin
   box:=bxCell;
   setSelectedCell;
  end;
end;

procedure TEntryDlg.NewPos;
var
 tmpPos: boolean;
begin
 tmpPos:=(posd>=0) and (posp>=0) and (posy>=0) and (posl>0);
 if HasPos<>tmpPos then
  begin
   if not(tmpPos) then clearPos;
   HasPos:=tmpPos;
   SetButtonStatus;
  end;
 if HasPos then
  begin
   ny:=posy; nl:=posl; np:=posp; nd:=posd;
   restore;
   setSelectedCell; BringIntoView;
  end;
end;

procedure TEntryDlg.FillTeachCombo;
var
 i,j,m,k,v,yearY,L:     smallint;
 ldt:           double;
 TeFound:   array[0..nmbrteachers] of integer;
 codeStr: string;
begin
 codeStr:=Combobox4.text;
 for j:=1 to numcodes[1] do TeFound[j]:=0;
 for yearY:=0 to years_minus_1 do
  for L:=1 to level[yearY] do
   begin
    if (yearY=ny) and (L=nl) then continue;
     m:=FNT(nd,np,yearY,L,2)^;
     if (m>0) and (m<=numcodes[1]) then inc(TeFound[m]);
    end; {for L}

 combobox4.Clear;   calculateLoads;
  for i:=1 to codeCount[1] do
   begin
    k:=codepoint[i,1];
    if (TeFound[k]>0) then continue;  //only if free
    ldt:=TeLoad[k];  //only if teachers load less than nominal load
    for v:=0 to 2 do
     if trim(XML_TEACHERS.DutyCode[k,v])<>'' then
      begin
       ldt:=ldt+XML_TEACHERS.DutyLoad[k,v];
      end;
    if (XML_TEACHERS.load[k]>ldt) then combobox4.items.add(XML_TEACHERS.tecode[k,0]);
   end; //for i
 ComboBox4.Text := codeStr;
end;

procedure TEntryDlg.Restore;
var
  IntPoint:      tpIntPoint;
  s:             string;
  cByte,sByte:   byte;
  i,j,m,k,sub,subSz,yearY,L:     smallint;
  RoFound:   array[0..nmbrRooms] of boolean;
  aFnt:          tpintpoint;
begin
  FIsSmallRoomAvail := False;
  IntPoint:=FNT(nd,np,ny,nl,0);
  Sub1:=IntPoint^;
  inc(IntPoint); te1:=IntPoint^;
  inc(IntPoint); room1:=IntPoint^;
  sByte:=FNTByte(nd,np,ny,nl,6)^;
  cByte:=FNTByte(nd,np,ny,nl,7)^;
  flgDouble:=((sByte and 1)=1);  {1st bit}
  flgShare:=((sByte and 2)=2);   {2nd bit}
  flgFix:=((sByte and 4)=4);  {3rd bit}
  Nblock:=FNgetBlockNumber(nd,np,ny,nl);
  flgTclash:=((cByte and 8)=8); {4th bit}
  flgRclash:=((cByte and 16)=16); {5th bit}
  posd:=nd; posp:=np; posy:=ny; posl:=nl;  HasPos:=true;
  ComboBox1.ItemIndex := ComboBox1.Items.IndexOf(yearname[ny]);
  Edit2.text:=inttostr(nl);
  ComboBox2.ItemIndex := ComboBox2.Items.IndexOf(Day[nd]);
  combobox3.ItemIndex:=np;
  Edit9.text:=inttostr(Nblock);
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
    cboSubject.text:='';//mantis -01591
    Combobox4.text:='';
    cboRoom.text:='';
    Edit5.Enabled:=True;
    cboSubject.Enabled:=False;//mantis -01591
    Combobox4.Enabled:=False;
    cboRoom.Enabled := False;
  end
  else
  begin
    Labelbox.checked:=false;
    EnLabel:=0;
    Edit5.text:='';
     //mantis -01591
   { if ((Sub1>0) and (Sub1<=nmbrsubjects)) then
      Edit6.text:=trim(SubCode[Sub1])
    else Edit6.text:=''; }

      cboSubject.Clear;
  for i := 1 to CodeCount[0] do
    cboSubject.Items.AddObject(Trim(SubCode[CodePoint[i, 0]]), TObject(codepoint[i, 0]));

    if ((Sub1>0) and (Sub1<=nmbrsubjects)) then
      cboSubject.text := trim(SubCode[Sub1])
    else
      cboSubject.text := '';
        //mantis -01591


    //populate Room dropdown
    aFnt:=FNT(nd,np,ny,nl,0);
    sub:=aFnt^;
    if (sub>0) and (sub<=numcodes[0]) then subSz:=GroupSubCount[GsubXref[sub]]
    else subSz:=0;

    for j:=1 to numcodes[2] do RoFound[j]:=false;
    for yearY:=0 to years_minus_1 do
    begin
      aFnt:=FNT(nd,np,yearY,0,4);
      for L:=1 to level[yearY] do
      begin
        inc(aFnt,4);
        m:=aFNt^;
        if (m>0) and (m<=numcodes[2]) then RoFound[m]:=true;
      end; {for L}
    end; {for yearY}

    cboRoom.Clear;
    for i:=1 to codeCount[2] do
    begin
      k:=codepoint[i,2];
      if RoFound[k] then continue;  //only if free
      if (XML_TEACHERS.RoSize[k]>=subSz) then   //only if room capacity is large enough for the class
        cboRoom.Items.Add(XML_TEACHERS.tecode[k,1])
      else
        FIsSmallRoomAvail := True;
    end; //for i

    if ((te1>0) and (te1<=nmbrteachers)) then
      Combobox4.Text := Trim(XML_TEACHERS.tecode[te1,0])
    else Combobox4.text:='';
    if ((room1>0) and (room1<=nmbrrooms)) then
      cboRoom.Text := Trim(XML_TEACHERS.tecode[room1,1])
    else cboRoom.Text := '';
    Edit5.Enabled:=False;
    cboSubject.Enabled:=True; //mantis -01591
    Combobox4.Enabled:=True;
    cboRoom.Enabled := True;
  end;
  Doublebox.Checked:=flgDouble;
  Sharebox.Checked:=flgShare;
  Fixbox.Checked:=flgFix;
  s:=inttostr(Tclash[nd,np]);
  if flgTclash then s:=s+'*';
  label8.Caption:=s;
  s:=inttostr(Rclash[nd,np]);
  if flgRclash then s:=s+'*';
  label9.Caption:=s;
  oldSub1:=Sub1; oldTe1:=Te1; oldRoom1:=Room1;
  if FIsSmallRoomAvail and (cboRoom.Items.Count = 0) then
    cboRoom.Hint := AMG_ROOM_HINT + AMG_FREE_ROOMS_MSG
  else
    cboRoom.Hint := AMG_ROOM_HINT;

end;

procedure TEntryDlg.FormCreate(Sender: TObject);
var
 i: integer;
begin

 topcentre(self);
 startflag:=true;
 SetEntryScope;
 FillComboYears(false,ComboBox1);
 FillComboDays(false,ComboBox2);
 FillComboTimeSlots(false,nd,combobox3);
 AutoMove.ItemIndex:=arrow;
 Trackbox.Checked:=XML_DISPLAY.TrackFlag;
 WarnBox.checked:=Warn;
 Ebox:=EntryScope.ItemIndex;
 label1.caption:='&'+Yeartitle;
 EndCol:=0;
 for i:=0 to days-1 do inc(EndCol,Tlimit[i]);

 Edit5.Maxlength:=szTcLabel;
 cboSubject.Maxlength:=lencodes[0]; //mantis -01591
 Combobox4.Maxlength:=lencodes[1];
 cboRoom.Maxlength := lencodes[2];
 if XML_DISPLAY.TrackFlag then BringIntoView;
 startflag:=false;
 fEntryDlgUp:=true;
end;

procedure TEntryDlg.FormActivate(Sender: TObject);
begin
 Restore;
end;

procedure TEntryDlg.EntryScopeClick(Sender: TObject);
begin
 if startflag then exit;
 if Ebox=EntryScope.ItemIndex then exit;
 Ebox:=EntryScope.ItemIndex;
 case Ebox of
  0: box:=bxcell;
  1: box:=bxlevel;
  2: box:=bxyear;
 end;
 setSelectedCell;
 if XML_DISPLAY.TrackFlag then BringIntoView;
end;

procedure TEntryDlg.TrackBoxClick(Sender: TObject);
begin
 XML_DISPLAY.TrackFlag:=TrackBox.Checked;
end;

procedure TEntryDlg.AutoMoveClick(Sender: TObject);
begin
 arrow:=AutoMove.ItemIndex;
end;

procedure TEntryDlg.Edit9KeyPress(Sender: TObject; var Key: Char);
begin
 allowNumericInputOnly(key);
end;

procedure TEntryDlg.Edit9Change(Sender: TObject);
begin
 Nblock:=IntFromEdit(edit9);
 if Nblock=0 then label11.Caption:='Not a block'
  else if (Nblock<0) or (Nblock>nmbrBlocks) then
   label11.Caption:='Enter block No. (0-'+inttostr(nmbrBlocks)+')'
   else label11.caption:='Block '+inttostr(Nblock);
end;

procedure TEntryDlg.DoubleBoxClick(Sender: TObject);
begin
 flgDouble:=DoubleBox.Checked;
end;

procedure TEntryDlg.ShareBoxClick(Sender: TObject);
begin
 flgShare:=ShareBox.Checked;
end;

procedure TEntryDlg.FixBoxClick(Sender: TObject);
begin
 flgFix:=FixBox.Checked;
end;

procedure TEntryDlg.Edit2Change(Sender: TObject);
var
 oldval: integer;
begin
 if startflag then exit;
 oldval:=posl;
 posl:=getLevel(ny,Edit2.text,label12);
 if (posl<>oldval) then NewPos;
end;

{procedure TEntryDlg.Edit6Change(Sender: TObject);
var
 codeStr: string;
begin
 codeStr:=trim(Edit6.text);
 Sub1:=checkCode(0,codestr);
 if Sub1=0 then label11.caption:='Enter Subject code'
  else label11.caption:=subname[Sub1];
end; }

Function CheckClash(Te,code,d,p,y,l: integer): bool;
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
    IntPoint:=FNT(d,p,y2,l2,2*code);
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

procedure TEntryDlg.LabelBoxClick(Sender: TObject);
begin
 if Labelbox.checked=true then
  begin
   Edit5.Enabled:=True; //Edit6.Enabled:=False;
   cboSubject.Enabled:=False;    //mantis-0001591
   Combobox4.Enabled:=False;
   cboRoom.Enabled := False;
  end
 else
  begin
   Edit5.Enabled:=False; //Edit6.Enabled:=True;
   cboSubject.Enabled:=True;  //mantis-0001591
   Combobox4.Enabled:=True;
   cboRoom.Enabled := True;
  end;
end;

procedure Stepon;
var
 oldy,oldl,oldd,oldp: integer;
begin
 oldy:=ny; oldl:=nl; oldd:=nd; oldp:=np;
 MoveSelect(arrow);
 if (oldy=ny) and (oldp=np) and (oldl=nl) and (oldd=nd) then exit;
 setSelectedCell;
 if XML_DISPLAY.TrackFlag then BringIntoView;
 EntryDlg.restore;
end;

function clashwarn(d,p,y,l: integer): bool;
var
 msg: string;
begin
 result:=false;
 if not(warn) then exit;
 msg:='';
 if (Te1>0) then if CheckClash(Te1,1,d,p,y,l) then
    msg:='Teacher clash! ';
 if (Room1>0) then if CheckClash(Room1,2,d,p,y,l) then
    msg:=msg+'Room clash! ';
 if msg>'' then
  begin
   msg:=msg+'at '+Day[d]+' '+inttostr(p+1);
   msg:=msg+endline+'Continue with entry?';
   if messagedlg(msg,mtWarning,[mbyes,mbno],0)<>mrYes then result:=true;
  end;
end;

function labelwarn: bool;
var msg: string;
begin
 result:=false;
 if not(warn) then exit;
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

procedure LevelLabel(oldLabel,NewLabel: string);
var
 msg: string;
 d,p: integer;
 su: integer;
begin
 if warn then
  begin
   msg:='Change other '''+oldLabel+''' on the same level';
   if messagedlg(msg,mtWarning,[mbyes,mbno],0)<>mrYes then exit;
  end;
  for d:=0 to days-1 do
   for p:=0 to Tlimit[d]-1 do
    begin
     su:=FNT(d,p,ny,nl,0)^;
     if su>LabelBase then
      if TcLabel[su-LabelBase]=oldLabel then
       begin
        TcLabel[su-LabelBase]:=Newlabel;
        if Newlabel='' then FNT(d,p,ny,nl,0)^:=0;
       end;
    end; {p}
end;

procedure YearLabel(oldLabel,NewLabel: string);
var
 msg: string;
 d,p,l: integer;
 su: integer;
begin
 if warn then
  begin
   msg:='Change other '''+oldLabel+''' on the same '+yeartitle;
   if messagedlg(msg,mtWarning,[mbyes,mbno],0)<>mrYes then exit;
  end;
  for d:=0 to days-1 do
   for p:=0 to Tlimit[d]-1 do
    for l:=1 to level[ny] do
     begin
      su:=FNT(d,p,ny,l,0)^;
      if su>LabelBase then
       if TcLabel[su-LabelBase]=oldLabel then
        begin
         TcLabel[su-LabelBase]:=Newlabel;
         if Newlabel='' then FNT(d,p,ny,l,0)^:=0;
        end;
    end; {l}
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
 newLabel:=TrimRight(EntryDlg.Edit5.Text);
 checkstr:=newLabel;
 if (Enlabel=0) and (checkstr>'') then Enlabel:=FindLabel;
 if checkstr='' then Enlabel:=0;
 if (Enlabel=0) and (checkstr>'') then
  begin
   messagedlg('No room to add more labels',mtError,[mbOK],0);
   exit;
  end;
 if checkstr>'' then TcLabel[Enlabel]:=newLabel;
 FNT(nd,np,ny,nl,0)^:=Enlabel+LabelBase;
 FNT(nd,np,ny,nl,2)^:=0;
 FNT(nd,np,ny,nl,4)^:=0;
 FNT(nd,np,ny,nl,6)^:=0;
 if oldEnlabel=0 then Fclash[nd,np]:=1;
 if (oldLabel>'') and (oldLabel<>NewLabel) and (box=bxLevel) then LevelLabel(oldLabel,Newlabel);
 if (oldLabel>'') and (oldLabel<>NewLabel) and (box=bxYear) then YearLabel(oldLabel,Newlabel);
end;

function NotAddCheck(s: string):boolean;
var
 msg: string;
begin
 result:=false;
 msg:='';
 if Te1<>oldTe1 then
   if Te1>0 then msg:='Add '+XML_TEACHERS.tecode[Te1,0]+' to'
    else msg:='Remove teachers from';
 if Room1<>oldRoom1 then
  begin
   if msg>'' then msg:=msg+', ';
   if Room1>0 then msg:=msg+'Add '+XML_TEACHERS.tecode[Room1,1]+' to'
    else msg:=msg+'Remove rooms from';
  end;
 msg:=msg+' other '+SubCode[Sub1]+' on the same '+s;
 if messagedlg(msg,mtWarning,[mbyes,mbno],0)<>mrYes then result:=true;
end;

procedure tlevel;
var
 d,p: integer;
begin
 if warn then if NotAddCheck('level') then exit;
 for d:=0 to days-1 do
  for p:=0 to Tlimit[d]-1 do
   if (FNT(d,p,ny,nl,0)^=Sub1) and
     ((FNT(d,p,ny,nl,2)^<>Te1) or (FNT(d,p,ny,nl,4)^<>Room1)) then
    begin
     if warn and ((FNTByte(d,p,ny,nl,6)^ and 2)=0) then
          if clashwarn(d,p,ny,nl) then continue;
     PushCell(d,p,ny,nl);
     if (Te1<>oldTe1) then FNT(d,p,ny,nl,2)^:=Te1;
     if (Room1<>oldRoom1) then FNT(d,p,ny,nl,4)^:=Room1;
     Fclash[d,p]:=1; tsClash(d,p);
    end;
end;

procedure tyear;
var
 d,p,l: integer;
begin
 if warn then if NotAddCheck('year') then exit;
 for d:=0 to days-1 do
  for p:=0 to Tlimit[d]-1 do
   begin
    for l:=1 to level[ny] do
     if (FNT(d,p,ny,l,0)^=Sub1) and
       ((FNT(d,p,ny,l,2)^<>Te1) or (FNT(d,p,ny,l,4)^<>Room1)) then
      begin
       if warn and ((FNTByte(d,p,ny,l,6)^ and 2)=0) then
          if clashwarn(d,p,ny,l) then continue;
       PushCell(d,p,ny,l);
       if (Te1<>oldTe1) then FNT(d,p,ny,l,2)^:=Te1;
       if (Room1<>oldRoom1) then FNT(d,p,ny,l,4)^:=Room1;
       Fclash[d,p]:=1;
      end;
    tsClash(d,p);
   end;
end;

procedure TEntryDlg.EnterBtnClick(Sender: TObject);
var
 IntPoint:  tpIntPoint;
 sByte:     Byte;
begin
 Nblock:=IntFromEdit(edit9);
 if (Nblock<0) or (Nblock>nmbrBlocks) then
  begin
   ShowMsg('Check block number',edit9);
   exit;
  end;
if Labelbox.checked=false then
 begin
 if (Sub1=0) and (trim(cboSubject.text)<>'') then
  begin
   ComboMsg('Check subject code',cboSubject);
   exit;
  end;
 if (Te1=0) and (trim(Combobox4.text)<>'') then
  begin
   ComboMsg('Check teacher code',Combobox4);
   exit;
  end;
  if (Room1=0) and (Trim(cboRoom.Text)<>'') then
  begin
   ComboMsg('Check room code', cboRoom);
   exit;
  end;
  if not(flgshare) then if clashwarn(posd,posp,posy,posl) then exit; {don't do entry}
  if Labelbox.checked then if labelwarn then exit;
 end; {not label}

 nd:=posd; np:=posp; ny:=posy; nl:=posl;
 pushOneTtStack(nd,np,ny,nl,utEditEntry);
 IntPoint:=FNT(nd,np,ny,nl,0);
 if Labelbox.checked then
   addlabel
 else
   begin
    if Enlabel>0 then DeleteLabel(Enlabel);
    IntPoint^:=Sub1;
    inc(IntPoint); IntPoint^:=Te1;
    inc(IntPoint); IntPoint^:=Room1;
    sByte:=0;   {status byte}
    if flgDouble then sByte:=sByte or 1;
    if flgShare then sByte:=sByte or 2;
    if flgFix then sByte:=sByte or 4;
    FNTByte(nd,np,ny,nl,6)^:=Sbyte;
    //keep to set other flags but set block number properly
    FNputBlockNumber(nd,np,ny,nl,Nblock);

    if ((Te1<>oldTe1) or (Room1<>oldRoom1)) then
     begin
      if (box=bxlevel) and (Sub1>0) then tlevel;
      if (box=bxYear) and (Sub1>0) then tyear;
     end;
   end;
 Fclash[nd,np]:=1;
 tsClash(nd,np);
 Stepon;
 Restore;
 ttclash;
 UpdateTimetableWins;
 SaveTimeFlag:=True;
end;

procedure TEntryDlg.SkipBtnClick(Sender: TObject);
begin
 Stepon;
end;

procedure TEntryDlg.ClearBtnClick(Sender: TObject);
begin
 pushOneTtStack(nd,np,ny,nl,utClearEntry);
 if Enlabel>0 then DeleteLabel(Enlabel);
 FNT(nd,np,ny,nl,0)^:=0;
 FNT(nd,np,ny,nl,2)^:=0;
 FNT(nd,np,ny,nl,4)^:=0;
 FNT(nd,np,ny,nl,6)^:=0;
 Fclash[nd,np]:=1;
 tsClash(nd,np);
 Stepon;
 Restore;
 UpdateTimetableWins;
 SaveTimeFlag:=True;
end;

procedure TEntryDlg.WarnBoxClick(Sender: TObject);
begin
 warn:=WarnBox.checked;
end;

procedure TEntryDlg.ComboBox1Change(Sender: TObject);
var
 oldval: integer;
begin
 if startflag then exit;
 oldval:=posy;
 posy:=findYearname(ComboBox1.text,label12);
 if (posy<>oldval) then NewPos;
end;

procedure TEntryDlg.ComboBox2Change(Sender: TObject);
var
 oldval: integer;
begin
 if startflag then exit;
 oldval:=posd;
 if ChangeDayCombo(posd,Combobox2,combobox3) then ComboBox3Change(Sender);
 posd:=findDayMsg(ComboBox2.Text,label12);
 if (posd<>oldval) then NewPos;
end;

procedure TEntryDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 UpdateTimetableWins;
 action:=caFree; fEntryDlgUp:=false;
 if ((usrPassLevel=utTime) or (usrPassLevel=utSuper)) then
  if not(saveTimeFlag) then CheckAccessRights(utTime,16,false);
end;

procedure TEntryDlg.FinishClick(Sender: TObject);
begin
 close;
end;

procedure TEntryDlg.ComboBox3Change(Sender: TObject);
var
 oldval: integer;
begin
 if startflag then exit;
 oldval:=posp;
 ChangeTimeCombo(posp,combobox3,label12);
 if (posp<>oldval) then NewPos;
end;

procedure TEntryDlg.ComboBox3Enter(Sender: TObject);
begin
 ComboBox3.SelectAll;
end;

procedure TEntryDlg.ComboBox4Change(Sender: TObject);
var
 codeStr: string;
begin
 codeStr := Trim(Combobox4.text);
 Te1:=checkCode(1,codestr);
 if Te1=0 then label11.caption:='Enter Teacher code'
  else
   if CheckClash(Te1,1,posd,posp,posy,posl) then label11.Caption:='This Code Clashes!'
    else label11.Caption:=XML_TEACHERS.TeName[te1,0];
end;

procedure TEntryDlg.cboRoomChange(Sender: TObject);
var
 codeStr: string;
begin
 codeStr := Trim(cboRoom.Text);
 Room1:=checkCode(2,codestr);
 if Room1=0 then label11.caption:='Enter Room code'
  else
   if CheckClash(Room1,2,posd,posp,posy,posl) then label11.Caption:='This Code Clashes!'
    else label11.Caption:=XML_TEACHERS.TeName[Room1,1];
end;

procedure TEntryDlg.cboSubjectChange(Sender: TObject);  //mantis -01591
var
 codeStr: string;
begin
 codeStr := trim(cboSubject.text);
 Sub1    := checkCode(0,codestr);
 if Sub1=0 then
   label11.caption := 'Enter Subject code'
 else
   label11.caption := subname[Sub1];


end;

procedure TEntryDlg.ComboBox4DropDown(Sender: TObject);
begin
 FillTeachCombo;
end;

end.



