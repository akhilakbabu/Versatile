unit Delscode;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, TimeChartGlobals, uAMGSubject,
  GlobalToTcAndTcextra, XML.DISPLAY, XML.STUDENTS;

type
  TDelSCodeDlg = class(TForm)
    finish: TBitBtn;
    delete: TBitBtn;
    BitBtn3: TBitBtn;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Label12: TLabel;
    lblSubjectTotal: TLabel;
    btnNextSub: TButton;
    btnPreviousSub: TButton;
    btnRemoveUnusedSubjects: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure deleteClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure nextClick(Sender: TObject);
    procedure previousClick(Sender: TObject);
    procedure RemoveUnusedSubjects(Sender: TObject);
  private
    IsUpdated:  Boolean;
    MySubPoint: smallint;
    procedure PoulateUsedSubjects(var pSubjects: TAMGSubjects);
    procedure AddToSubjects(var pSubjects: TAMGSubjects; const pSubNo: Integer);
    procedure Restore;
    procedure SetButtons;
    procedure UpdateSubjectTotal;
  public
    procedure DeleteUnusedSubjects(const pUnusedSubjects: TAMGSubjects);
  end;

var
  DelSCodeDlg:   TDelSCodeDlg;

implementation

uses
  SuWnd, tcommon, DlgCommon, block1, Edfac2, tcommon2, RemoveUnusedSubjects, uAMGConst;

{$R *.DFM}

var
  mysub: integer;
  subXref: array of integer;
  IsFacUpdated: Boolean;

procedure SetSubXref;
var
 i: integer;
begin
 setLength(subXref,numcodes[0]+1);
 for i:=1 to codeCount[0] do subXref[codepoint[i,0]]:=i;
end;

procedure TDelSCodeDlg.SetButtons;
begin
  btnNextSub.Enabled := MySubPoint < CodeCount[0];
  btnPreviousSub.Enabled := MySubPoint > 1;
  delete.Enabled := mySub > 0;
end;

procedure TDelSCodeDlg.UpdateSubjectTotal;
begin
  lblSubjectTotal.Caption := IntToStr(CodeCount[0]);
end;

procedure TDelSCodeDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 action:=caFree;
 if IsUpdated then updateSub(0); {update subject data files}
 if IsFacUpdated then UpdateFaculty;
end;

procedure TDelSCodeDlg.AddToSubjects(var pSubjects: TAMGSubjects; const pSubNo: Integer);
var
  lSubject: TAMGSubject;
  lSubCode: string;
begin
  if pSubNo <= nmbrSubjects then
  begin
    lSubCode := Trim(SubCode[pSubNo]);
    if (pSubjects.IndexOf(lSubCode) = -1) and (lSubCode <> AMG_NA_SUBJECT) then
    begin
      lSubject := TAMGSubject.Create;
      lSubject.Code := lSubCode;
      lSubject.ID := pSubNo;
      lSubject.SubjectFullName := Trim(SubName[pSubNo]);
      if lSubject.SubjectFullName = '' then
        lSubject.SubjectFullName := lSubCode;

      pSubjects.Add(lSubject);
    end;
  end;
end;

procedure TDelSCodeDlg.PoulateUsedSubjects(var pSubjects: TAMGSubjects);
var
  YYear, d, p, L, lSubNo: Integer;
  lEnrolled: Integer;
  lCodePos: Integer;
  i, j: Integer;
  lStudNo: Integer;
begin
  pSubjects.Clear;

  //In Timetable
  lSubNo := 0;
  for YYear := Years - 1 downto 0 do
  begin
    for d := 0 to Days - 1 do
      for p := 1 to Tlimit[d] do
        for L := 1 to level[yyear] do
        begin
          lSubNo := FNT(d, p - 1, YYear, L, 0)^;
          if ((lSubNo > 0) and (lSubNo <= LabelBase)) then
          begin
            AddToSubjects(pSubjects, lSubNo);
          end;
        end; //for L
  end; // for YYear

  //In group subjects
  lCodePos := GsubXref[lSubNo];
  if lCodePos > 0 then
  begin
    lEnrolled := GroupSubCount[lCodePos];
    if lEnrolled > 0 then
      AddToSubjects(pSubjects, lSubNo);
  end;

  //In student choices
  for i := 1 to GroupNum do
  begin
    lStudNo := StPointer[i];
    for j := 1 to NmbrChoices do
    begin
      lSubNo := XML_STUDENTS.Stud[lStudNo].Choices[j];
      if lSubNo > 0 then
        AddToSubjects(pSubjects, lSubNo);
    end;
  end; //for i
end;

procedure TDelSCodeDlg.RemoveUnusedSubjects(Sender: TObject);
var
  lFrmRemoveUnusedSubjects: TFrmRemoveUnusedSubjects;
  lSubjects: TAMGSubjects;
  lUnusedSubjects: TAMGSubjects;
  i: Integer;
begin
  lSubjects := TAMGSubjects.Create;
  PoulateUsedSubjects(lSubjects);

  lUnusedSubjects := TAMGSubjects.Create;
  for i := 1 to CodeCount[0] do
    if lSubjects.IndexOf(Trim(SubCode[CodePoint[i, 0]])) = -1 then
      AddToSubjects(lUnusedSubjects, CodePoint[i, 0]);
  lFrmRemoveUnusedSubjects := TFrmRemoveUnusedSubjects.Create(Application);
  try
    if lUnusedSubjects.Count > 0 then
    begin
      lFrmRemoveUnusedSubjects.UnusedSubjects := lUnusedSubjects;
      lFrmRemoveUnusedSubjects.TotalSubCount := CodeCount[0];
      lFrmRemoveUnusedSubjects.UsedSubCount := lSubjects.Count + 1;  //Add NA to count
      lFrmRemoveUnusedSubjects.ShowModal;
    end
    else
      MessageDlg(AMG_NO_UNUSED_SUBJECTS_MSG, mtInformation, [mbOK], 0);
  finally
    if Assigned(lSubjects) then
      FreeAndNil(lSubjects);
    if Assigned(lUnusedSubjects) then
      FreeAndNil(lUnusedSubjects);
    FreeAndNil(lFrmRemoveUnusedSubjects);
  end;
  UpdateSubjectTotal;
end;

procedure TDelSCodeDlg.Restore;
begin
 intRange(mySubPoint,0,codeCount[0]);
 mySub:=codepoint[mySubPoint,0];
 lblSubjectTotal.caption:=inttostr(codeCount[0]);
 if mySubPoint>0 then
  begin
   edit1.Text:=subcode[mySub]; label3.Caption:=subname[mySub];
  end
 else
  begin
   edit1.text:=''; label3.caption:='';
  end;
 SetButtons;
 edit1.SelectAll; edit1.SetFocus;
end;

procedure checkfaculties(Place: integer);
var
i,j: integer;
facPlace:    integer;
found,foundsame:       bool;
place1,place2:  integer;
a,b:              string;

  procedure removeSubFac;
  var
  j: integer;
   begin
    facCount[i]:=facCount[i]-1;
    for j:=facPlace to facCount[i] do
     facSubs[i,j]:=facSubs[i,j+1];
    facSubs[i,facCount[i]+1]:=0;
   end;

begin
 place2:=0;
 a:=copy(SubCode[Place],1,lencodes[0]-1);
 for i:=1 to facnum do
 begin
  found:=false;
  for j:=1 to facCount[i] do
   if abs(facSubs[i,j])=Place then
   begin
    found:=true;
    facPlace:=j;
    break;
   end;
  if found then
  begin
   IsFacUpdated := True;
   if facSubs[i,facPlace]>0 then removeSubFac
   else
    begin
     foundsame:=false;
     for j:=1 to codeCount[0] do
     begin
      place1:=codepoint[j,0];
      B:=copy(SubCode[place1],1,(lenCodes[0]-1));
      if (A=B) and (place1<>place) then
      begin
       foundsame:=true;
       place2:=place1;
       break;
      end;
     end; {for j}
     if foundsame then facSubs[i,facPlace]:=-place2
     else removeSubFac;
    end;
  end;  {if found}
 end; {for i}

end;

procedure TDelSCodeDlg.deleteClick(Sender: TObject);
var
 codeStr:       string;
 mySubName:      string;
 msg:           string;
 enrolled:      integer;
 foundpos:      integer;
 i,temp:        integer;
 fromblock,sublevel: integer;
begin
 msg:='';
 if NoCodesAvail(codeCount[0],'Subject Codes') then exit;
 mySubName:=trim(label3.caption);
 if NoCode(codeStr,edit1) then exit;
 if CodeNotFound(mySub,0,edit1) then exit;
 if mySubName = 'Not Available' then
 begin
   MessageDlg('"Not Available" is a reserved subject name and cannot be deleted.',mtCustom, [mbOK], 0);
   if Edit1.Visible and Edit1.Enabled then
     Edit1.SetFocus;
   Exit; {Back to editing}
 end;

 enrolled:=0;
 foundpos:=GsubXref[mySub];
 if foundpos>0 then enrolled:=GroupSubCount[foundpos];
 if enrolled>0 then
 begin
  msg:=inttostr(enrolled)+' students are enrolled in'+endline;
  msg:=msg+codeStr+' - '+mySubName+'.';
  msg:=msg+endline+'Remove '+codeStr+' from Group Subjects first.';
  ShowMsg(msg,edit1);
  exit; {return to editing}
 end;

 IsUpdated := True;
 SubCode[mySub]:=StringPad(lenCodes[0],48);
 SubName[mySub]:='';  SubReportCode[mySub]:='';
 SubReportName[mySub]:='';
 if link[mySub]>0 then
 begin
  link[link[mySub]]:=0;
  link[mySub]:=0;
 end;

 temp:= SuWindow.selcode;
 if temp>0 then
   if (codepoint[temp,0]=mySub) then SuWindow.selcode:=-1; {cancel selection}

  fromblock:=findblock(mySub,sublevel);
  if fromblock>0 then blockchange(mySub,0);  {remove from blocks}
  foundpos:=GsubXref[mySub];
  if foundpos>0 then
  begin
   dec(GroupSubs[0]);
   if foundpos<=GroupSubs[0] then
    begin
    for i:=foundpos to GroupSubs[0] do
     begin
      GroupSubs[i]:=GroupSubs[i+1];
      GroupSubCount[i]:=GroupSubCount[i+1];
     end;
     GroupSubs[GroupSubs[0]+1]:=0;
     GroupSubCount[GroupSubs[0]+1]:=0;
    end;
  end;

 XrefGroupSubs;
 checklink;
 if facnum>0 then checkfaculties(mySub);
 sortCodes(0);  SetSubXref;
 getCodeFontWidths(0);

 rangeCheckSubSels(XML_DISPLAY.ttPrntSelSubg);
 rangeCheckSubyrSels(XML_DISPLAY.ClashMatrixSelection);
 updateAllWins;
 restore;
end;

procedure TDelSCodeDlg.FormActivate(Sender: TObject);
begin
  {init here}
  edit1.maxlength:=lencodes[0];
 lblSubjectTotal.caption:=inttostr(codeCount[0]);
  if (SuWindow.selCode>0) then mySubPoint:=SuWindow.selCode
  else mySubPoint:=0;
  Restore;
end;

procedure TDelSCodeDlg.DeleteUnusedSubjects(const pUnusedSubjects: TAMGSubjects);
var
  foundpos:      integer;
  i: Integer;
  j: Integer;
  fromblock,sublevel: integer;
  lSubject: TAMGSubject;
  lSubNo: Integer;
begin
  for j := 0 to pUnusedSubjects.Count - 1 do
  begin
    lSubject := TAMGSubject(pUnusedSubjects.Items[j]);
    lSubNo := lSubject.ID;
    SubCode[lSubNo] := StringPad(lenCodes[0],48);
    SubName[lSubNo] := '';
    SubReportCode[lSubNo] := '';
    SubReportName[lSubNo] := '';
    if link[lSubNo] > 0 then
    begin
      link[link[lSubNo]] := 0;
      link[lSubNo] := 0;
    end;

    fromblock := findblock(lSubNo, sublevel);
    if fromblock > 0 then blockchange(lSubNo,0);  {remove from blocks}
    foundpos := GsubXref[lSubNo];
    if foundpos > 0 then
    begin
      dec(GroupSubs[0]);
      if foundpos <= GroupSubs[0] then
      begin
        for i := foundpos to GroupSubs[0] do
        begin
          GroupSubs[i] := GroupSubs[i + 1];
          GroupSubCount[i] := GroupSubCount[i+1];
        end;
        GroupSubs[GroupSubs[0] + 1] := 0;
        GroupSubCount[GroupSubs[0] + 1] := 0;
      end;
    end;

    XrefGroupSubs;
    checklink;
    if facnum > 0 then
      Checkfaculties(lSubNo);
    sortCodes(0);
    SetSubXref;
    getCodeFontWidths(0);

    rangeCheckSubSels(XML_DISPLAY.ttPrntSelSubg);
    rangeCheckSubyrSels(XML_DISPLAY.ClashMatrixSelection);
    UpdateSub(0);
    if IsFacUpdated then UpdateFaculty;
  end;
  updateAllWins;
end;

procedure TDelSCodeDlg.Edit1Change(Sender: TObject);
var
 codeStr:       string;
begin
 codeStr:=TrimRight(edit1.text);
 mySub:=checkCode(0,codestr);
 mySubPoint:=subXref[mysub];
 if mySub>0 then
  label3.caption:=subname[mySub]
 else
  label3.caption:='';
 SetButtons;
end;

procedure TDelSCodeDlg.FormCreate(Sender: TObject);
begin
  TopCentre(self);
  IsUpdated := False;
  IsFacUpdated := False;
  SetSubXref;
end;

procedure TDelSCodeDlg.nextClick(Sender: TObject);
begin
 inc(mySubPoint); restore;
end;

procedure TDelSCodeDlg.previousClick(Sender: TObject);
begin
 dec(mySubPoint); restore;
end;

end.
