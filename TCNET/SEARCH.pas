unit Search;

interface

uses SysUtils, WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, Dialogs, Grids, TimeChartGlobals,GlobalToTcAndTcextra, XML.DISPLAY, XML.TEACHERS;

type
  TSearchDlg = class(TForm)
    HelpBtn: TBitBtn;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Edit1: TEdit;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Label5: TLabel;
    WarnBox: TCheckBox;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    edtSearchSubject: TEdit;
    edtSearchTeacher: TEdit;
    edtSearchRoom: TEdit;
    edtReplaceSubject: TEdit;
    edtReplaceTeacher: TEdit;
    edtReplaceRoom: TEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Edit14: TEdit;
    Edit15: TEdit;
    Edit16: TEdit;
    SearchScope: TRadioGroup;
    SearchBtn: TBitBtn;
    ReplaceAllBtn: TBitBtn;
    Finish: TBitBtn;
    ReplaceBtn: TBitBtn;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Label15: TLabel;
    ExcludeNAchk: TCheckBox;
    ComboBox3: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure WarnBoxClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure SearchScopeClick(Sender: TObject);
    procedure SearchBtnClick(Sender: TObject);
    procedure ReplaceBtnClick(Sender: TObject);
    procedure ReplaceAllBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure edtSearchSubjectChange(Sender: TObject);
    procedure edtReplaceSubjectChange(Sender: TObject);
    procedure edtSearchTeacherChange(Sender: TObject);
    procedure edtReplaceTeacherChange(Sender: TObject);
    procedure edtSearchRoomChange(Sender: TObject);
    procedure edtReplaceRoomChange(Sender: TObject);
    procedure Edit9Change(Sender: TObject);
    procedure Edit13Change(Sender: TObject);
    procedure Edit10Change(Sender: TObject);
    procedure Edit11Change(Sender: TObject);
    procedure Edit12Change(Sender: TObject);
    procedure Edit14Change(Sender: TObject);
    procedure Edit15Change(Sender: TObject);
    procedure Edit16Change(Sender: TObject);
    procedure Edit10KeyPress(Sender: TObject; var Key: Char);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FinishClick(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure Edit9KeyPress(Sender: TObject; var Key: Char);
    procedure Edit13KeyPress(Sender: TObject; var Key: Char);
    procedure ExcludeNAchkClick(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure ComboBox3Enter(Sender: TObject);
  private
    function CheckPosition: bool;
    procedure NewPosition;
  end;

var
  SearchDlg: TSearchDlg;

implementation

{$R *.DFM}
uses tcommon,DlgCommon,TTundo,ttable,main,tcommon2,tcommon5;

var
 ad,ap,ay,al:  smallint;
 firstStart,firstSearch:      bool;
 Nblock,bl1,bl2:  integer;
 replacecount:  integer;
 fd, fp,fy,fl: integer;
 su1,te1,ro1,block1: integer;
 fix1,double1,share1: bool;

procedure TSearchDlg.FormCreate(Sender: TObject);
begin
 TopCentre(self);
 firstStart:=true;
 SearchScope.ItemIndex:=XML_DISPLAY.SearchBox;
 WarnBox.checked:=Warn;
 label1.caption:='&'+Yeartitle;
 FillComboYears(false,ComboBox1);
 FillComboDays(false,ComboBox2);
 combobox1.hint:='Select starting '+yeartitle;
 ay:=ny; al:=nl; ad:=nd; ap:=np;
 FillComboTimeSlots(false,nd,combobox3);
 combobox3.ItemIndex:=ap;
 Combobox1.ItemIndex := Combobox1.Items.IndexOf(yearname[ay]);
 edit1.text:=inttostr(al);
 Combobox2.ItemIndex := Combobox2.Items.IndexOf(day[ad]);
 ExcludeNAchk.Checked:=ExcludeNA;
 replacecount:=0;
 firstStart:=false;
end;

procedure TSearchDlg.WarnBoxClick(Sender: TObject);
begin
 warn:=WarnBox.checked;
end;

procedure TSearchDlg.ComboBox1Change(Sender: TObject);
var
 found:  integer;
begin
 if FirstStart then exit;
 found:=findYearname(ComboBox1.text,label5);
 replacecount:=0;
 if found>=0 then ay:=found;
 firstsearch:=true;
end;

procedure TSearchDlg.Edit1Change(Sender: TObject);
begin
 if FirstStart then exit;
 replacecount:=0;
 al:=IntFromEdit(edit1);
 if (al<1) or (al>level[ay]) then
   label5.Caption:='Enter level (1-'+inttostr(level[ay])+')'
 else label5.Caption:='Level '+inttostr(al);
  firstsearch:=true;
end;

procedure TSearchDlg.ComboBox2Change(Sender: TObject);
var
 found:  integer;
begin
 if FirstStart then exit;
 if ChangeDayCombo(ad,Combobox2,combobox3) then ComboBox3Change(Sender);
 replacecount:=0;
 found:=findDayMsg(ComboBox2.text,label5);
 if found>=0 then ad:=found;
 firstsearch:=true;
end;

function CheckBlock: bool;
begin
 bl1:=0; bl2:=0; result:=true;
 if XML_DISPLAY.Searchbox<>1 then exit;
 Nblock:=FNgetBlockNumber(ad,ap,ay,al);
 if (Nblock<1) or (Nblock>nmbrBlocks) then
  begin
   messagedlg('No block at current position',mtError,[mbOK],0);
   result:=false;
   exit;
  end;
 GetBlockLevels(ad,ap,ay,al,bl1,bl2);
end;

procedure TSearchDlg.SearchScopeClick(Sender: TObject);
begin
 if FirstStart then exit;
 replacecount:=0;
 XML_DISPLAY.SearchBox:=SearchScope.ItemIndex;
  firstsearch:=true;
end;

function TSearchDlg.CheckPosition: bool;
var
 found: smallint;
 MyError: boolean;
begin
 myError:=BadComboYear(found,ComboBox1);
 if not(myError) then myError:=BadLevel(al,ay,edit1);
 if found>=0 then ay:=found;
 if not(myError) then myError:=BadDayCombo(found,comboBox2);
 if found>=0 then ad:=found;
 if not(myError) then myError:=BadTimeCombo(ap,ad,comboBox3);
 result:=not(myError);
end;

function SearchEntry: Bool;
var
 s: string;
begin
  Result := True;
  SearchDlg.edtSearchSubject.Text := Trim(SearchDlg.edtSearchSubject.Text);
  s := SearchDlg.edtSearchSubject.Text;
  if (Fsub=0) and (s<>'') then
  begin
     messagedlg('Check search subject code',mtError,[mbOK],0);
     SearchDlg.edtSearchSubject.SetFocus;
     SearchDlg.edtSearchSubject.SelectAll;
     result:=false;
     exit;
  end;
  SearchDlg.edtSearchTeacher.Text := Trim(SearchDlg.edtSearchTeacher.Text);
  s := SearchDlg.edtSearchTeacher.Text;
  if (Fteach=0) and (s<>'') then
  begin
     messagedlg('Check search teacher code',mtError,[mbOK],0);
     SearchDlg.edtSearchTeacher.SetFocus;
     SearchDlg.edtSearchTeacher.SelectAll;
     result:=false;
     exit;
  end;
  SearchDlg.edtSearchRoom.Text := Trim(SearchDlg.edtSearchRoom.Text);
  s := SearchDlg.edtSearchRoom.Text;
  if (Froom=0) and (s<>'') then
  begin
     messagedlg('Check search room code',mtError,[mbOK],0);
     SearchDlg.edtSearchRoom.SetFocus;
     SearchDlg.edtSearchRoom.SelectAll;
     result:=false;
     exit;
  end;
  if (Fblock>nmbrBlocks) then
  begin
     messagedlg('Check search block number',mtError,[mbOK],0);
     SearchDlg.edit9.setfocus;
     SearchDlg.edit9.SelectAll;
     result:=false;
     exit;
  end;
end;

function ReplaceEntry: Bool;
var
 s: string;
begin
  Result := True;
  SearchDlg.edtReplaceSubject.Text := Trim(SearchDlg.edtReplaceSubject.Text);
  s := SearchDlg.edtReplaceSubject.Text;
  if (Rsub=0) and (s<>'') then
  begin
     messagedlg('Check replace subject code',mtError,[mbOK],0);
     SearchDlg.edtReplaceSubject.SetFocus;
     SearchDlg.edtReplaceSubject.SelectAll;
     result:=false;
     exit;
  end;
  SearchDlg.edtReplaceTeacher.Text := Trim(SearchDlg.edtReplaceTeacher.Text);
  s := SearchDlg.edtReplaceTeacher.Text;
  if (Rteach=0) and (s<>'') then
  begin
     messagedlg('Check replace teacher code',mtError,[mbOK],0);
     SearchDlg.edtReplaceTeacher.SetFocus;
     SearchDlg.edtReplaceTeacher.SelectAll;
     result:=false;
     exit;
  end;
  SearchDlg.edtReplaceRoom.Text := Trim(SearchDlg.edtReplaceRoom.Text);
  s := SearchDlg.edtReplaceRoom.Text;
  if (Rroom=0) and (s<>'') then
  begin
     messagedlg('Check replace room code',mtError,[mbOK],0);
     SearchDlg.edtReplaceRoom.SetFocus;
     SearchDlg.edtReplaceRoom.SelectAll;
     result:=false;
     exit;
  end;
  if (Rblock>nmbrBlocks) then
  begin
     messagedlg('Check replace block number',mtError,[mbOK],0);
     SearchDlg.edit13.setfocus;
     SearchDlg.edit13.SelectAll;
     result:=false;
     exit;
  end;
end;

function SearchFind: bool;
var
 found,start,got: bool;
 d,p,y,l,d1,p1,y1,l1,d2,p2,y2,l2: integer;
 Sbyte: byte;
 IntPoint:      tpIntPoint;
begin
 found:=false;
 d1:=ad; p1:=ap; y1:=ay; l1:=al;
 case XML_DISPLAY.Searchbox of
  0:begin {all}
     d1:=0; p1:=0; l1:=1;
     d2:=days-1; p2:=periods-1; y2:=0;
     l2:=levelprint;
     if SearchDlg.radiobutton2.checked  and firstsearch then
     begin
      y1:=years_minus_1;
     end;
    end;
  1:begin {block}
     d2:=d1; p2:=p1; y2:=y1;
     l2:=bl2;
     if SearchDlg.radiobutton2.checked  and firstsearch then
     begin
      l1:=bl1;
     end;
    end;
  2:begin {year time}
     d2:=d1; p2:=p1; y2:=y1;
     l2:=level[y1];
     if SearchDlg.radiobutton2.checked  and firstsearch then
     begin
      l1:=1;
     end;
    end;
  3:begin {level}
     p1:=0;
     d2:=days-1; p2:=periods-1; y2:=y1;
     l2:=l1;
     if SearchDlg.radiobutton2.checked  and firstsearch then
     begin
      d1:=0;
     end;
    end;
  4:begin {year}
     d1:=0; p1:=0;
     d2:=days-1; p2:=periods-1; y2:=y1;
     l2:=level[y1];
     if SearchDlg.radiobutton2.checked  and firstsearch then
     begin
      l1:=1;
     end;
    end;
  5:begin {time slot}
     d2:=d1; p2:=p1; l1:=1; y2:=0;
     l2:=levelprint;
     if SearchDlg.radiobutton2.checked  and firstsearch then
     begin
      y1:=years_minus_1;
     end;
    end;
  6:begin {day}
     p1:=0;
     d2:=d1; p2:=periods-1; y2:=0;
     l2:=levelprint;
     if SearchDlg.radiobutton2.checked and firstsearch then
     begin
      l1:=1; y1:=years_minus_1;
     end;
    end;
 end; {case}
 start:=true;
 if SearchDlg.radiobutton2.checked and firstsearch then start:=false;

 for y:=y1 downto y2 do
  begin
   for l:=l1 to l2 do
    begin
     for d:=d1 to d2 do
      begin
       for p:=p1 to p2 do
        begin
         if start and ((l<>al) or (d<>ad) or (p<>ap)) then continue; {cycle to start}
         start:=false;
         if not(firstsearch) then
          begin
           firstsearch:=true;
           continue;
          end;
         if (l>level[y]) or (p>=Tlimit[d]) then continue;
         IntPoint:=FNT(d,p,y,l,0); su1:=Intpoint^;
         if su1>labelbase then continue; //not for labels - were getting teachers attached to labels crashing teacher loads
         inc(Intpoint); te1:=Intpoint^;
         inc(Intpoint); ro1:=Intpoint^;
         Sbyte:=FNTbyte(d,p,y,l,6)^;
         double1:=((sByte and 1)=1);
         share1:=((sByte and 2)=2);
         fix1:=((sByte and 4)=4);
         block1:=FNgetBlockNumber(d,p,y,l);
         got:=true;
         if (Fsub>=0) and (Fsub<>su1) then got:=false;
         if (Fteach>=0) and (Fteach<>te1) then got:=false;
         if (Froom>=0) and (Froom<>ro1) then got:=false;
         if (Fdouble>=0) and (bool(Fdouble)<>double1) then got:=false;
         if (Fshare>=0) and (bool(Fshare)<>share1) then got:=false;
         if (Ffix>=0) and (bool(Ffix)<>fix1) then got:=false;
         if (Fblock>=0) and (Fblock<>block1) then got:=false;
         if ExcludeNA and (subNA>0) and (su1=subNA) then got:=false;
         if got then
          begin
           found:=true;
           fy:=y; fl:=l; fd:=d; fp:=p;
           break;
          end;
        end; {p}
       if found then break;
      end; {d}
     if found then break;
    end;{l}
   if found then break;
  end; {y}
 result:=found;
end;

procedure setSelectedCell;
var
 CurRow,CurCol: integer;
 Srect: TGridRect;
begin
 CurRow:=FindRow(ny,nl);
 CurCol:=FindCol(nd,np);
 Srect.top:=CurRow; Srect.bottom:=CurRow;
 Srect.left:=CurCol; Srect.right:=CurCol;
 box:=bxcell;
 Ttablewin.StringGrid1.selection:=Srect;
end;

procedure TSearchDlg.NewPosition;
begin
 ay:=ny; al:=nl; ad:=nd; ap:=np;
 Combobox1.ItemIndex := Combobox1.Items.IndexOf(yearname[ay]);
 edit1.text:=inttostr(al);
 Combobox2.ItemIndex := Combobox2.Items.IndexOf(day[ad]);
 combobox3.ItemIndex:=ap;
 SetSelectedCell;
 BringIntoView;
end;

procedure TSearchDlg.SearchBtnClick(Sender: TObject);
begin
 if not(CheckPosition) then exit;
 if not(CheckBlock) then exit;
 if not(SearchEntry) then exit;
 if SearchFind then
  begin
   nd:=fd; np:=fp; ny:=fy; nl:=fl;
   NewPosition;
   label5.Caption:='Search Successful!';
  end
 else
  begin
   messagedlg('No entries found to match search',mtInformation,[mbOK],0);
   label5.Caption:='';
  end;
 firstsearch:=false;
end;

function CheckEntry: bool;
var
 msg,location: string;
 y,l: integer;

begin
 result:=true; msg:='';
 location:='on '+day[nd]+': '+inttostr(np+1)+ ' '+Yearshort+' '+yearname[ny]+
             endline+'Continue with replacement?';
 if not(warn) then exit;
 if (Rsub>=0) and (Rsub<>su1) then
  begin
   if (block1>0) and (Rblock<>0) then msg:='Subject change in block ';
   if double1 and (Rdouble<>0) then msg:='Subject change in double ';
  end;
 if msg>'' then
  if messagedlg(msg+location,mtWarning,[mbyes,mbno],0)<>mrYes then
   begin
    result:=false;
    exit;
   end;
 msg:='';
 if (Rteach>0) and (Rteach<>te1) then
  begin
   for y:=0 to years_minus_1 do
    begin
     for l:=1 to level[y] do
      if Rteach=FNT(nd,np,y,l,2)^ then
       begin
        msg:='Replace teacher clashes ';
        break;
       end;
     if msg>'' then break;
    end; {y}
  end;
 if msg>'' then
  if messagedlg(msg+location,mtWarning,[mbyes,mbno],0)<>mrYes then
   begin
    result:=false;
    exit;
   end;
 if (Rroom>0) and (Rroom<>ro1) then
  begin
   for y:=0 to years_minus_1 do
    begin
     for l:=1 to level[y] do
      if Rroom=FNT(nd,np,y,l,4)^ then
       begin
        msg:='Replace room clashes ';
        break;
       end;
     if msg>'' then break;
    end; {y}
  end;
 if msg>'' then
  if messagedlg(msg+location,mtWarning,[mbyes,mbno],0)<>mrYes then
   begin
    result:=false;
    exit;
   end;
end;

procedure TSearchDlg.ReplaceBtnClick(Sender: TObject);
var
 sbyte: byte;
 ReplaceDone: bool;
begin
 if not(CheckPosition) then exit;
 if not(CheckBlock) then exit;
 if not(SearchEntry) then exit;
 if not(ReplaceEntry) then exit;
 firstsearch:=(replacecount=0);
 ReplaceDone:=False;
 if SearchFind then
  begin
   nd:=fd; np:=fp; ny:=fy; nl:=fl;
   NewPosition;
   if CheckEntry then
    begin
     pushOneTtStack(nd,np,nY,nL,utReplace);
     if Rsub>=0 then FNT(nd,np,ny,nl,0)^:=Rsub;
     if Rteach>=0 then FNT(nd,np,ny,nl,2)^:=Rteach;
     if Rroom>=0 then FNT(nd,np,ny,nl,4)^:=Rroom;
     if Rblock>=0 then block1:=Rblock;
     if Rdouble>=0 then double1:=bool(Rdouble);
     if Rshare>=0 then share1:=bool(Rshare);
     if Rfix>=0 then fix1:=bool(Rfix);
     sByte:=0;   {status byte}
     if double1 then sByte:=sByte or 1;
     if share1 then sByte:=sByte or 2;
     if fix1 then sByte:=sByte or 4;
     FNTByte(nd,np,ny,nl,6)^:=Sbyte;
//   keep to set other flags but set block number properly
     FNputBlockNumber(nd,np,ny,nl,block1);
     Fclash[nd,np]:=1; tsClash(nd,np);
     inc(replacecount); ReplaceDone:=True;
     label5.Caption:='Replace Completed';
    end;
  end
 else
  begin
   messagedlg('No entries found to match search',mtInformation,[mbOK],0);
   label5.Caption:='';
  end;
 if ReplaceDone then
  begin
   ttclash;
   UpdateTimetableWins;
   SaveTimeFlag:=True;
  end;
end;

procedure TSearchDlg.ReplaceAllBtnClick(Sender: TObject);
var
 sbyte: byte;
 Found,ReplaceOne: bool;
 finalCount: integer;
begin
 if not(CheckPosition) then exit;
 if not(CheckBlock) then exit;
 if not(SearchEntry) then exit;
 if not(ReplaceEntry) then exit;
 firstsearch:=true; replacecount:=0;  ReplaceOne:=false;
 repeat
  found:=false;
  if SearchFind then
   begin
    found:=true; firstsearch:=false;
    nd:=fd; np:=fp; ny:=fy; nl:=fl;
    ay:=ny; al:=nl; ad:=nd; ap:=np;
    if CheckEntry then
     begin
      if ReplaceOne then PushCell(nd,np,ny,nl)
       else begin
             pushOneTtStack(nd,np,nY,nL,utReplaceAll);
             ReplaceOne:=true;
            end;
      if Rsub>=0 then FNT(nd,np,ny,nl,0)^:=Rsub;
      if Rteach>=0 then FNT(nd,np,ny,nl,2)^:=Rteach;
      if Rroom>=0 then FNT(nd,np,ny,nl,4)^:=Rroom;
      if Rblock>=0 then block1:=Rblock;
      if Rdouble>=0 then double1:=bool(Rdouble);
      if Rshare>=0 then share1:=bool(Rshare);
      if Rfix>=0 then fix1:=bool(Rfix);
      sByte:=0;   {status byte}
      if double1 then sByte:=sByte or 1;
      if share1 then sByte:=sByte or 2;
      if fix1 then sByte:=sByte or 4;
      FNTByte(nd,np,ny,nl,6)^:=Sbyte;
//    keep to set other flags but set block number properly
      FNputBlockNumber(nd,np,ny,nl,block1);
      Fclash[nd,np]:=1; tsClash(nd,np);
      inc(replacecount);
     end;
   end;
 until not(found);
 if Replacecount>0 then
  begin
   finalCount:=Replacecount;
   NewPosition;
   label5.Caption:='Entries Replaced: '+inttostr(FinalCount);
   ttclash;
   UpdateTimetableWins;
   SaveTimeFlag:=True;
  end
 else
   begin
    messagedlg('No entries found to match search',mtInformation,[mbOK],0);
    label5.Caption:='';
   end;
end;

function Getsub(sub,code: integer): string;
var
 s:  string;
begin
 if sub<0 then s:='*' else if (sub=0) OR (sub>NumCodes[0])
    then s:='' else
      begin
       if code=0 then s:=Subcode[sub];
       if code>0 then s:=XML_TEACHERS.tecode[sub,code-1];
      end;
 result:=s;
end;

function Sflag(a: integer): string;
begin
 if a<0 then result:='*' else if a>0 then result:='Y' else result:='N';
end;

procedure TSearchDlg.FormActivate(Sender: TObject);
begin
  edtSearchSubject.Text := Getsub(Fsub,0);
  edtSearchSubject.MaxLength := lenCodes[0];
  edtSearchTeacher.Text := Getsub(Fteach,1);
  edtSearchTeacher.MaxLength := lenCodes[1];
  edtSearchRoom.Text := Getsub(Froom,2);
  edtSearchRoom.MaxLength := lenCodes[2];
  edit9.text:='*';
  if (Fblock>=0) and (Fblock<=nmbrBlocks) then edit9.text:=inttostr(Fblock);
  Edit10.Text := Sflag(Fdouble);
  Edit11.Text := Sflag(Fshare);
  Edit12.Text := Sflag(Ffix);
  edtReplaceSubject.Text := Getsub(Rsub,0);
  edtReplaceSubject.MaxLength := lenCodes[0];
  edtReplaceTeacher.Text := Getsub(Rteach,1);
  edtReplaceTeacher.MaxLength := lenCodes[1];
  edtReplaceRoom.Text := Getsub(Rroom,2);
  edtReplaceRoom.MaxLength := lenCodes[2];
  edit13.text:='*';
  if (Rblock>=0) and (Rblock<=nmbrBlocks) then edit13.text:=inttostr(Rblock);
  edit14.Text := Sflag(Rdouble);
  edit15.Text := Sflag(Rshare);
  edit16.Text := Sflag(Rfix);
  Label5.Caption := '';
end;

function SearchSub(codeStr: string; code: integer): integer;
var
 s: string;
 sub: integer;
begin
 codeStr:=trim(codeStr);
 if codeStr='' then
  begin
   s:='Blank '+codename[code]; sub:=0;
  end
 else if codeStr='*' then
  begin
   s:='Any '+codename[code]; sub:=-1;
  end
 else
  begin
   sub:=checkCode(code,codestr);
   if sub=0 then s:='Enter '+codename[code]+' code'
    else s:=FNsubname(sub,code);
  end;
 SearchDlg.label5.Caption:=s;
 result:=sub;
end;

procedure TSearchDlg.edtSearchSubjectChange(Sender: TObject);
var
  codeStr: string;
begin
  codeStr := edtSearchSubject.Text;
  replacecount := 0;
  Fsub := SearchSub(codeStr,0);
  firstsearch := True;
end;

procedure TSearchDlg.edtReplaceSubjectChange(Sender: TObject);
var
  codeStr: string;
begin
  codeStr := edtReplaceSubject.Text;
  replacecount := 0;
  Rsub := SearchSub(codeStr, 0);
end;

procedure TSearchDlg.edtSearchTeacherChange(Sender: TObject);
var
 codeStr: string;
begin
  codeStr := edtSearchTeacher.Text;
  replacecount := 0;
  Fteach := SearchSub(codeStr,1);
  firstsearch := True;
end;

procedure TSearchDlg.edtReplaceTeacherChange(Sender: TObject);
var
  codeStr: string;
begin
  codeStr := edtReplaceTeacher.Text;
  replacecount := 0;
  Rteach := SearchSub(codeStr,1);
end;

procedure TSearchDlg.edtSearchRoomChange(Sender: TObject);
var
  codeStr: string;
begin
  codeStr := edtSearchRoom.Text;
  replacecount := 0;
  Froom := SearchSub(codeStr,2);
  firstsearch := True;
end;

procedure TSearchDlg.edtReplaceRoomChange(Sender: TObject);
var
  codeStr: string;
begin
  codeStr := edtReplaceRoom.text;
  replacecount := 0;
  Rroom := SearchSub(codeStr,2);
end;

function SearchBlock(codeStr: string): integer;
var
 s: string;
 sub: integer;
begin
 codeStr:=trim(codeStr);
 if codeStr='' then
  begin
   s:='No block'; sub:=0;
  end
 else if codeStr='*' then
  begin
   s:='Any block'; sub:=-1;
  end
 else
  begin
   sub:=strtointdef(codeStr,0);
   if sub=0 then s:='No block '
    else if (sub<0) or (sub>nmbrBlocks) then
     s:='Enter block (0-'+inttostr(nmbrBlocks)+')'
      else s:='Block '+inttostr(sub);
  end;
 SearchDlg.label5.Caption:=s;
 result:=sub; replacecount:=0;
end;

procedure TSearchDlg.Edit9Change(Sender: TObject);
var
 s: string;
begin
 s:=edit9.text;
 Fblock:=SearchBlock(s);
  firstsearch:=true;
end;

procedure TSearchDlg.Edit13Change(Sender: TObject);
var
 s: string;
begin
 s:=edit13.text;
 Rblock:=SearchBlock(s);
end;

function SearchFlag(s: string): integer;
var
 msg: string;
begin
 s:=trim(s);
 s:=uppercase(s);
 if s='Y' then
  begin
   result:=1; msg:='Flag set';
  end
 else if s='N' then
  begin
   result:=0; msg:='Flag not set';
  end
   else
    begin
     result:=-1; msg:='Any flag';
    end;
 searchDlg.label5.Caption:=msg; replacecount:=0;
end;

procedure TSearchDlg.Edit10Change(Sender: TObject);
var
 s: string;
begin
 s:=edit10.text;
 Fdouble:=SearchFlag(s);
  firstsearch:=true;
end;

procedure TSearchDlg.Edit11Change(Sender: TObject);
var
 s: string;
begin
 s:=edit11.text;
 Fshare:=SearchFlag(s);
  firstsearch:=true;
end;

procedure TSearchDlg.Edit12Change(Sender: TObject);
var
 s: string;
begin
 s:=edit12.text;
 Ffix:=SearchFlag(s);
  firstsearch:=true;
end;

procedure TSearchDlg.Edit14Change(Sender: TObject);
var
 s: string;
begin
 s:=edit14.text;
 Rdouble:=SearchFlag(s);
end;

procedure TSearchDlg.Edit15Change(Sender: TObject);
var
 s: string;
begin
 s:=edit15.text;
 Rshare:=SearchFlag(s);
end;

procedure TSearchDlg.Edit16Change(Sender: TObject);
var
 s: string;
begin
 s:=edit16.text;
 Rfix:=SearchFlag(s);
end;

procedure TSearchDlg.Edit10KeyPress(Sender: TObject; var Key: Char);
begin
 if pos(key,'*YyNn')=0 then if ord(key)>32 then key:=chr(0);
end;

procedure TSearchDlg.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
 allowNumericInputOnly(key);
end;

procedure TSearchDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 action:=cafree; fSearchReplaceDlgUp:=false;

 if ((usrPassLevel=utTime) or (usrPassLevel=utSuper)) then
  if not(saveTimeFlag) then CheckAccessRights(utTime,16,false)
end;

procedure TSearchDlg.FinishClick(Sender: TObject);
begin
 close;
end;

procedure TSearchDlg.RadioButton1Click(Sender: TObject);
begin
 firstsearch:=true;
end;

procedure TSearchDlg.RadioButton2Click(Sender: TObject);
begin
 firstsearch:=true;
end;

procedure TSearchDlg.Edit9KeyPress(Sender: TObject; var Key: Char);
begin
 if pos(key,'*0123456789')=0 then if ord(key)>32 then key:=chr(0);
end;

procedure TSearchDlg.Edit13KeyPress(Sender: TObject; var Key: Char);
begin
 if pos(key,'*0123456789')=0 then if ord(key)>32 then key:=chr(0);
end;

procedure TSearchDlg.ExcludeNAchkClick(Sender: TObject);
begin
 ExcludeNA:=excludeNAchk.Checked;
end;

procedure TSearchDlg.ComboBox3Change(Sender: TObject);
begin
 if FirstStart then exit;
 replacecount:=0;
 ChangeTimeCombo(ap,combobox3,label5);
 firstsearch:=true;
end;

procedure TSearchDlg.ComboBox3Enter(Sender: TObject);
begin
 ComboBox3.SelectAll;
end;

end.


