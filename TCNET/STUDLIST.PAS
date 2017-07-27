unit Studlist;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Menus, StdCtrls, ClassDefs,TimeChartGlobals,StBarC,
  GlobalToTcAndTcextra, XML.DISPLAY, XML.TEACHERS, XML.STUDENTS;

type
  TStudentListWin = class(TStudListWin)
    PopupMenu1: TPopupMenu;
    Selection1: TMenuItem;
    N1: TMenuItem;
    Group1: TMenuItem;
    Select1: TMenuItem;
    AddStudent1: TMenuItem;
    ChangeStudent1: TMenuItem;
    DeleteStudent1: TMenuItem;
    CommonData1: TMenuItem;
    ClearChoices1: TMenuItem;
    N3: TMenuItem;
    PrintSetup1: TMenuItem;
    Print1: TMenuItem;
    ShowStudentTimetable1: TMenuItem;
    Exportastextfile1: TMenuItem;
    MainMenu1: TMainMenu;
    Edit1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    Sort1: TMenuItem;
    N2: TMenuItem;
    grp11: TMenuItem;
    grp21: TMenuItem;
    grp31: TMenuItem;
    grp41: TMenuItem;
    grp51: TMenuItem;
    grp61: TMenuItem;
    grp71: TMenuItem;
    grp81: TMenuItem;
    grp91: TMenuItem;
    grp01: TMenuItem;
    grp101: TMenuItem;
    grp111: TMenuItem;
    grp121: TMenuItem;
    grp131: TMenuItem;
    grp141: TMenuItem;
    grp151: TMenuItem;
    StudentInput1: TMenuItem;
    popStudentN2: TMenuItem;
    popStudentHealth: TMenuItem;
    grp161: TMenuItem;
    grp171: TMenuItem;
    grp181: TMenuItem;
    grp191: TMenuItem;
    popStudentDeleteCurrentYear: TMenuItem;
    procedure Selection1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure AddStudent1Click(Sender: TObject);
    procedure ChangeStudent1Click(Sender: TObject);
    procedure DeleteStudent1Click(Sender: TObject);
    procedure CommonData1Click(Sender: TObject);
    procedure ClearChoices1Click(Sender: TObject);
    procedure Print1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure ShowStudentTimetable1Click(Sender: TObject);
    procedure Select1Click(Sender: TObject);
    procedure Sort1Click(Sender: TObject);
    procedure grp01Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure DisplayStudentInput(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DisplayStudentHealth(Sender: TObject);
    procedure SetupGroupCheck(Sender: TObject);
    procedure DeleteCurrentGroup(Sender: TObject);
  private
    FNonAllocM: Integer;
    FNonAllocF: Integer;
    procedure updateStudGroupMenu;
    procedure CountFacultyStudents;
    procedure ParseClipStudentText;
    function GetNonExistingYears: Integer;
  protected
    procedure SetTabs; override;
    procedure GetLists; override;
    procedure GetListContents(i: integer); override;
    procedure PaintHead;  override;
    procedure ListHead(i:integer);  override;
  public
    procedure ChangeView; override;
  end;

var
  StudentListWin: TStudentListWin;


procedure Studentlistprint;
procedure StudentlistOut(const pIsSpecial: Boolean = False);

implementation

uses
  tcommon, stulidlg, edstud, addstud, delstud, groupsel, main, printers, tcommon2,
  sortgrp, clipbrd, Stcommon, tcommon5, FlexiPaste, FlexiPasteQuiz, DlgCommon,
  customOutput, HealthCondition;

{$R *.DFM}

type TPrintStudList=class(TPrintStudListWin)
  public
   procedure head; override;
   procedure SetTabs; override;
   procedure GetLists; override;
   procedure GetListContents(i: integer); override;
   procedure ListHead(i:integer); override;
 end;

type TOutStudList=class(TOutStudListWin)
  public
    procedure head; override;
    procedure GetLists; override;
    procedure GetListContents(i: integer); override;
    procedure ListHead(i:integer); override;
    procedure SetTabs;
  end;

var
  PrintStudList:    TPrintStudList;
  OutStudList:     TOutStudList;
  maleCount,femaleCount:   array[0..nmbrSubjects] of integer;
  teach:          array[0..nmbrSubYear] of smallint;
  Tmale,Tfemale:  integer;
  HasClassTutor,CanAddSubs: boolean;

function GetClassTutor(c: smallint):smallint;
// determine tutor for class - assume all studs in class take same tutor
// use tutor from first stud in class
var
 i: smallint;
begin
 result:=0;
 for i:=1 to XML_STUDENTS.numstud do
 begin
  if (XML_STUDENTS.Stud[i].tcClass=c) and (XML_STUDENTS.Stud[i].tutor>0) then
  begin
   result:=XML_STUDENTS.Stud[i].tutor;
   break; {exit}
  end;
 end; {for i}
end;

function CalcCountMax(max: integer):integer;
var
 i,j: integer;
begin
 j:=0;
 for i:=1 to max do
  if ((maleCount[i]+femaleCount[i])>0) then inc(j);
 result:=j;
end;

procedure CountClasses;
var
 i,i9,a:       integer;
begin
 HasClassTutor:=false;
 for i:=0 to nmbrClass do
 begin
  maleCount[i]:=0; femaleCount[i]:=0;
 end; {for i}
 Tmale:=0; Tfemale:=0;
 for i9:=1 to groupnum do
 begin
  i:=StGroup[i9];
  a:=XML_STUDENTS.Stud[i].TcClass;
  if (trim(ClassCode[a])='') then a:=0;
  if XML_STUDENTS.Stud[i].sex='M' then
  begin
   inc(maleCount[a]);
   inc(Tmale);
  end
  else
   begin
    inc(femaleCount[a]);
    inc(Tfemale);
   end;
 end; {for i9}
 if Classnum>0 then
  for i:=1 to Classnum do
   if (Malecount[i]+Femalecount[i])>0 then
    if GetClassTutor(i)>0 then HasClassTutor:=true;
end;

procedure CountSubjects;
var
 i,j,i9,su,a:  integer;
begin
 for i:=0 to nmbrSubYear do
 begin
  maleCount[i]:=0;  femaleCount[i]:=0;
 end;  {for i}
 Tmale:=0;  Tfemale:=0;
 for i9:=1 to groupnum do
 begin
  i:=StGroup[i9];
  for j:=1 to chmax do
   begin
    su:=XML_STUDENTS.Stud[i].Choices[j];
    if su<>0 then
     begin
      a:=GsubXref[su];
      if XML_STUDENTS.Stud[i].sex=genderShort[0]{'M'} then
       inc(maleCount[a])
      else
        inc(femaleCount[a]);
     end;
   end;
 end; {for i9}
end;

procedure CountRooms;
var
 i,i9,a:  integer;
 aStr:    string;
begin
 for i:=0 to nmbrRooms do
 begin
  maleCount[i]:=0;  femaleCount[i]:=0;
 end; {for i}
 Tmale:=0;   Tfemale:=0;
 for i9:=1 to groupnum do
 begin
  i:=StGroup[i9];
  a:=XML_STUDENTS.Stud[i].Home;
  aStr:=copy(XML_TEACHERS.Tecode[a,1],1,2);
  if aStr='00' then a:=0;
  if XML_STUDENTS.Stud[i].Sex=genderShort[0]{'M'} then
  begin
   inc(maleCount[a]);
   inc(Tmale);
  end
  else
   begin
    inc(femaleCount[a]);
    inc(Tfemale);
   end;
 end; {for i9}
end;

procedure CountTutors;
var
 i,i9,a:  integer;
 aStr:    string;
begin
 for i:=0 to nmbrTeachers do
 begin
  maleCount[i]:=0;  femaleCount[i]:=0;
 end; {for i}
 Tmale:=0;  Tfemale:=0;
 for i9:=1 to groupnum do
 begin
  i:=StGroup[i9];
  a:=XML_STUDENTS.Stud[i].Tutor;
  aStr:=copy(XML_TEACHERS.TeCode[a,0],1,2);
  if aStr='00' then a:=0;
  if XML_STUDENTS.Stud[i].Sex=genderShort[0]{'M'} then
  begin
   inc(maleCount[a]);
   inc(Tmale);
  end
  else
   begin
    inc(femaleCount[a]);
    inc(Tfemale);
   end;
 end;  {for i9}
end;

procedure CountHouses;
var
 i,i9,a:       integer;
begin
 for i:=0 to nmbrHouse do
 begin
  maleCount[i]:=0;  femaleCount[i]:=0;
 end; {for i}
 Tmale:=0;  Tfemale:=0;
 for i9:=1 to groupnum do
 begin
  i:=StGroup[i9];
  a:=XML_STUDENTS.Stud[i].House;
  if trim(HouseName[a])='' then a:=0;
  if XML_STUDENTS.Stud[i].sex=genderShort[0]{'M'} then
  begin
   inc(maleCount[a]);
   inc(Tmale);
  end
  else
   begin
    inc(femaleCount[a]);
    inc(Tfemale);
   end;
 end; {for i9}
end;

procedure StudentNumberTeach;
var
 d,p,l,i,i2,y:       integer;
 su,te:         integer;
 yrAR:    array[0..nmbryears] of wordbool; //only check year if true
 doneTeach:   array[0..nmbrSubYear] of boolean;
begin
 for i:=0 to nmbryears do yrAR[i]:=false;
 for i:=1 to groupnum do
 begin
  i2:=StPointer[i];
  yrAR[XML_STUDENTS.Stud[i2].TcYear]:=true; //add year to search
 end;

 for i:=1 to nmbrSubYear do teach[i]:=0;
 for y:=years_minus_1 downto 0 do
 begin
  if yrAR[y] then //only for years of students selected
  for d:=0 to days-1 do
   for p:=0 to periods-1 do
    for l:=1 to level[y] do
     begin
      su:=FNT(d,p,y,l,0)^;
      te:=FNT(d,p,y,l,2)^;
      i:=0;
      if (su>0) and (su<=numcodes[0]) then i:=GsubXref[su];
      if (i>0) and (te>0) and (te<=numcodes[1]) then
       begin
        if teach[i]=0 then teach[i]:=te;
        if (teach[i]>0) and (teach[i]<>te) then teach[i]:=-1;
       end;
     end;
 end; {for y}

 for i:=1 to nmbrSubYear do DoneTeach[i]:=(Teach[i]<>0);
 if XML_DISPLAY.MatchAllYears then  {check other years for subjects with no teacher}
  for y:=years_minus_1 downto 0 do
   if not(yrAR[y]) then //only for years not covered
   begin
    for d:=0 to days-1 do
     for p:=0 to periods-1 do
      for l:=1 to level[y] do
       begin
        su:=FNT(d,p,y,l,0)^;
        te:=FNT(d,p,y,l,2)^;
        i:=0;
        if (su>0) and (su<=numcodes[0]) then i:=GsubXref[su];
        if (i>0) and (te>0) and (te<=numcodes[1]) then
         begin
          if DoneTeach[i]=false then
           begin
            if teach[i]=0 then teach[i]:=te;
            if (teach[i]>0) and (teach[i]<>te) then teach[i]:=-1;
           end;
         end;
       end;
   end; {for y}
end;

procedure TStudentListWin.ChangeView;
begin
 XML_DISPLAY.listEnrolment:=not(XML_DISPLAY.listEnrolment);
 UpdateWin;
end;

procedure TStudentListWin.SetTabs;
var
 tabT: integer;
begin
 SetLength(Tabs,8);
 studentPointerSet;
 if XML_DISPLAY.StudListType<7 then ListType:=1 else ListType:=2;
 {1 - student list  2- numbers}
 codeColor:=cpStList; EnrolFlag:=XML_DISPLAY.listEnrolment; ShowZeroList:=true;
 ListHeadLines:=1;
 tabT:=canvas.textwidth('123Total  ');
 if XML_DISPLAY.StudListType<>7 then
  begin
   GetLists;
   CalcArrayTops;
  end
 else {numbers}
  begin
   case XML_DISPLAY.listnumbertype of
    1: begin
        MaxTab(1,fwClass,'Not Allocated  ');
        countClasses;
        TotalCount:=7+CalcCountMax(Classnum);
        if HasClassTutor then
         begin
          MaxTab(2,fwCode[1]+fwCodename[1]+2*blankwidth,'Teacher ');
          Tabs[5]:=Tabs[1];Tabs[1]:=Tabs[2];
          Tabs[6]:=Tabs[5]+fwcode[1]+blankwidth;
         end;
       end;
    2: begin
        MaxTab(1,fwHouse,'Not Allocated  ');
        countHouses;
        TotalCount:=7+CalcCountMax(Housecount);
       end;
    3: begin
        MaxTab(1,fwCode[0],'  Subject ');
        MaxTab(2,fwCodename[0],'Subject Name ');
        MaxTab(3,fwCode[1],'Teacher ');
        MaxTab(4,fwCodename[1],'Teacher Name ');
        MaxTab(5,0,'123'+genderLong[0]);
        MaxTab(6,0,'123'+genderLong[1]);
        Tabs[7]:=Tabs[6]+tabT;
        countSubjects;
        StudentNumberTeach;
        TotalCount:=7+CalcCountMax(NumCodes[0]);
       end;
    4: begin
        MaxTab(1,fwCode[1]+fwCodename[1]+blankwidth,'Not Allocated  ');
        countTutors;
        TotalCount:=7+CalcCountMax(numcodes[1]);
       end;
    5: begin
        MaxTab(1, fwCode[2] + fwCodename[2] + blankwidth, 'Not Allocated  ');
        countRooms;
        TotalCount:=7+CalcCountMax(numcodes[2]);
       end;
    6: begin
        MaxTab(1, fwFaculty + blankwidth,'Not Allocated  ');
        CountFacultyStudents;
        TotalCount := 7 + CalcCountMax(FacNum);
       end;
   end; {case}
   if XML_DISPLAY.listnumbertype<>3 then
    begin
      MaxTab(2,0,'123'+genderLong[0]);
      MaxTab(3,0,'123'+genderLong[1]);
      Tabs[7]:=Tabs[3]+tabT;
    end;
   maxH:=XML_DISPLAY.double_print*TxtHeight*TotalCount;
   maxW:=Tabs[7];
   Selcode:=0;
  end;
 RedoSelection;
end;

procedure TStudentListWin.SetupGroupCheck(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to Main.MainForm.Group1.Count - 1 do
    Group1.Items[i].Checked := Main.MainForm.Group1.Items[i].Checked;
end;

Procedure GeneralListContents(i,size,myset:integer;var Contents: array of integer);
var
 j,count: integer;
begin
 count:=0;
 if Size=0 then exit;
 case XML_DISPLAY.StudListType of
  1: for j:=1 to size do Contents[j]:=liststudentselection[j];
  2: for j:=1 to size do Contents[j]:=StPointer[j];
  3: for j:=1 to GroupNum do
       if XML_STUDENTS.Stud[StPointer[j]].TcClass=myset then
          begin inc(count); Contents[count]:=StPointer[j]; end;
  4: for j:=1 to GroupNum do
       if XML_STUDENTS.Stud[StPointer[j]].house=myset then
          begin inc(count); Contents[count]:=StPointer[j]; end;
  5: for j:=1 to GroupNum do
       if XML_STUDENTS.Stud[StPointer[j]].tutor=myset then
          begin inc(count); Contents[count]:=StPointer[j]; end;
  6: for j:=1 to GroupNum do
       if XML_STUDENTS.Stud[StPointer[j]].home=myset then
          begin inc(count); Contents[count]:=StPointer[j]; end;
 end;{case}
end;

procedure TStudentListWin.GetListContents(i:integer);
begin
 SetLength(ListContents,ListSize[i]+1);
 GeneralListContents(i,ListSize[i],ListSet[i],ListContents);
end;

procedure TStudentListWin.GetLists;
var
 i,i2,kk: integer;
 verify,InUse:  tpTeData;

  procedure AddInUse(j:integer);
  begin
    if bool(verify[j]) then
      begin
       inc(kk);
       InUse[kk]:=j;
      end;
  end;

begin
 for i:=0 to nmbrTeachers do begin verify[i]:=0; InUse[i]:=0; end;
 kk:=0;
 if XML_DISPLAY.StudListType>2 then
   begin
    for i:=1 to groupnum do
    begin
     i2:=StPointer[i];
     case XML_DISPLAY.StudListType of
      3: inc(verify[XML_STUDENTS.Stud[i2].Tcclass]);
      4: inc(verify[XML_STUDENTS.Stud[i2].house]);
      5: inc(verify[XML_STUDENTS.Stud[i2].tutor]);
      6: inc(verify[XML_STUDENTS.Stud[i2].home]);
     end; {case}
    end; {for i}
    case XML_DISPLAY.StudListType of
     3: for i:=1 to classnum do AddInUse(RollClassPoint[i]);
     4: for i:=1 to HouseCount do AddInUse(i);
     5: for i:=1 to codeCount[1] do AddInUse(codepoint[i,1]);
     6: for i:=1 to codeCount[2] do AddInUse(codepoint[i,2]);
    end; {case}

 end; {if StudListType>2 }
 NumOfLists:=1; SetArraySizes;
 case XML_DISPLAY.StudListType of
  1: ListSize[1]:=liststudentselection[0];
  2: ListSize[1]:=GroupNum;
  3..6: if XML_DISPLAY.listranges[XML_DISPLAY.StudListType-2,1]=0 then
      begin
       NumOfLists:=kk; SetArraySizes;
       if kk>0 then for i:=1 to kk do
         begin
           ListSize[i]:=verify[InUse[i]];
           ListSet[i]:=InUse[i];
         end;
      end
       else
        begin
         ListSet[1]:=XML_DISPLAY.listranges[XML_DISPLAY.StudListType-2,1];
         ListSize[1]:=verify[XML_DISPLAY.listranges[XML_DISPLAY.StudListType-2,1]];
        end;
 end;{case}
end;

function TStudentListWin.GetNonExistingYears: Integer;
var
  ss,ss2: ansistring;
  i, j, pcnt: Integer;
  studpiece: array[0..(12+nmbrChoices)] of string[szStName];
  faStud:  tpStudRec;
  //faStudID2: string[szID];
  faStudID2: string[50];
  faStudEmail: string[100];
  lFound: Integer;
begin
  lFound := 0;
  try
    GetTextFromClipboard(CF_TEXT); {get clip text}
    j := Pos(cr,genText);     //get student line
    ss2 := Copy(genText,1,j-1);
    genText := Copy(genText, j + 2, Length(genText));
    {init pieces}
    for i:=1 to (12+nmbrchoices) do studpiece[i]:='';
    //parse line into pieces
    i := pos(ht, ss2);
    pcnt := 1;
    while i > 0 do
    begin
      ss := Copy(ss2,1,i-1);
      studpiece[pcnt] := ss;
      Inc(pcnt);
      ss2 := Copy(ss2,i+1,length(ss2));
      i := Pos(ht,ss2);
    end;
    studpiece[pcnt] := ss2; //whats left
    for i:=1 to pcnt do
      studpiece[i] := Trim(studpiece[i]);

    faStudID2 := '';
    faStudEmail:='';

    //assume surname followed by first name are first two fields
    faStud.Stname := studpiece[1];
    faStud.First := studpiece[2];
    //get rest of student fields
    for i := 3 to pcnt do //check sex
    begin
     if studpiece[i]='' then continue;
     if ((UpperCase(studpiece[i])=genderShort[0]{'M'}) or (uppercase(studpiece[i])=genderShort[1]{'F'})
     or (uppercase(studpiece[i])=genderShort[2]{'X'})) then   //mantis-1566.
     begin
       faStud.sex:=UpperCase(studpiece[i]);
       studpiece[i] := '';
       Break; //don't reuse
     end;
    end; //for i
    for i := 3 to pcnt do //check year
    begin
      if FindYear(studpiece[3]) = - 1 then
      begin
        Inc(lFound);
        //Break;
      end;
    end; //for i
  finally
    Result := lFound;
  end;
end;

procedure TStudentListWin.PaintHead;
begin
 fcolor(cpNormal);
 printWl('Student');
 case XML_DISPLAY.StudListType of
  1:  if liststudentselection[0]>0 then printWl(' Selection');
  2:  printWl('s '+' Group: '+groupname+' sorted by '+groupsortname[groupsort]);
  3:  begin
       if XML_DISPLAY.listRanges[1,1]>0 then
        printWl('s in '+ClassCode[XML_DISPLAY.listRanges[1,1]])
       else printWl('s in All Classes');
       printWl(' sorted by '+groupsortname[groupsort]);
      end;
  4:  begin
       if XML_DISPLAY.listRanges[2,1]>0 then
        printWl('s in '+HouseName[XML_DISPLAY.listRanges[2,1]])
       else printWl('s in All Houses');
       printWl(' sorted by '+groupsortname[groupsort]);
      end;
  5:  begin
       if XML_DISPLAY.listRanges[3,1]>0 then
        printWl('s in '+XML_TEACHERS.TeCode[XML_DISPLAY.listRanges[3,1],0])
       else printWl('s in All Tutors');
       printWl(' sorted by '+groupsortname[groupsort]);
      end;
  6:  begin
       if XML_DISPLAY.listRanges[4,1]>0 then
        printWl('s in '+XML_TEACHERS.TeCode[XML_DISPLAY.listRanges[4,1],1])
       else printWl('s in All Home Rooms');
       printWl(' sorted by '+groupsortname[groupsort]);
      end;
  7:  begin
       case XML_DISPLAY.listnumbertype of
       1: begin
           printWl(' Numbers for Classes');
           newline; newline;
           printWl('Class');
           if HasClassTutor then
            begin
             x:=Tabs[5]; printw('Teacher');
            end;
          end;
       2: begin
           printWl(' Numbers for Houses');
           newline; newline;
           printWl('House');
          end;
       3:  begin
           printWl(' Numbers for Subjects');
           newline; newline;
           printWl('Subject');
           x:=Tabs[1]; printwl('Subject name');
           x:=Tabs[2]; printWl('Teacher');
           x:=Tabs[3]; printWl('Teacher name');
           x:=Tabs[4]; printWl(genderLong[0]);   //printWl('Male');
           x:=Tabs[5]; printWl(genderLong[1]);  //printWl('Female');
           x:=Tabs[6]; printWl('Total');
          end;
       4:  begin
           printWl(' Numbers for Tutors');
           newline; newline;
           printWl('Tutor');
          end;
       5: begin
           printWl(' Numbers for Rooms');
           newline; newline;
           printWl('Room');
          end;
       6: begin
           printWl(' Numbers for Faculties');
           newline; newline;
           printWl('Faculty');
          end;
       end; {case}
       if XML_DISPLAY.ListNumberType <> 3 then
       begin
         x := Tabs[1];
         printWl(genderLong[0]);
         x := Tabs[2];
         printWl(genderLong[1]);
         x := Tabs[3];
         printWl('Total');
       end;
      end;
 end; {case}
 newline;
end;

procedure TStudentListWin.ListHead(i:integer);
begin
 fcolor(cpNormal);
 case XML_DISPLAY.StudListType of
  3:printwl('Class '+ClassCode[ListSet[i]]);
  4:printwl('House '+HouseName[ListSet[i]]);
  5:printwl('Tutor '+XML_TEACHERS.TeCode[ListSet[i],0]+' '+XML_TEACHERS.TeName[ListSet[i],0]);
  6:printwl('Room '+XML_TEACHERS.TeCode[ListSet[i],1]+' '+XML_TEACHERS.TeName[ListSet[i],1]);
 end;
end;

procedure TStudentListWin.updateStudGroupMenu;
var
 j,i: smallint;
begin
 j:=GOSmenu[0];
 try
  n2.visible:=(j>0);
  grp01.visible:=(j>0); grp11.visible:=(j>1);
  grp21.visible:=(j>2); grp31.visible:=(j>3);
  grp41.visible:=(j>4); grp51.visible:=(j>5);
  grp61.visible:=(j>6); grp71.visible:=(j>7);
  grp81.visible:=(j>8); grp91.visible:=(j>9);
  grp101.visible:=(j>10); grp111.visible:=(j>11);
  grp121.visible:=(j>12); grp131.visible:=(j>13);
  grp141.visible:=(j>14); grp151.visible:=(j>15);
  grp161.visible:=(j>16); grp171.visible:=(j>17);
  grp181.visible:=(j>18); grp191.visible:=(j>19);

  if j>0 then
   for i:=1 to j do
   begin
    case i of
     1: grp01.caption:=GOSname[GOSmenu[i]];
     2: grp11.caption:=GOSname[GOSmenu[i]];
     3: grp21.caption:=GOSname[GOSmenu[i]];
     4: grp31.caption:=GOSname[GOSmenu[i]];
     5: grp41.caption:=GOSname[GOSmenu[i]];
     6: grp51.caption:=GOSname[GOSmenu[i]];
     7: grp61.caption:=GOSname[GOSmenu[i]];
     8: grp71.caption:=GOSname[GOSmenu[i]];
     9: grp81.caption:=GOSname[GOSmenu[i]];
    10: grp91.caption:=GOSname[GOSmenu[i]];
    11: grp101.caption:=GOSname[GOSmenu[i]];
    12: grp111.caption:=GOSname[GOSmenu[i]];
    13: grp121.caption:=GOSname[GOSmenu[i]];
    14: grp131.caption:=GOSname[GOSmenu[i]];
    15: grp141.caption:=GOSname[GOSmenu[i]];
    16: grp151.caption:=GOSname[GOSmenu[i]];
    17: grp161.caption:=GOSname[GOSmenu[i]];
    18: grp171.caption:=GOSname[GOSmenu[i]];
    19: grp181.caption:=GOSname[GOSmenu[i]];
    20: grp191.caption:=GOSname[GOSmenu[i]];
    end; {case}
   end;
 except
 end;
end;

procedure TStudentListWin.Selection1Click(Sender: TObject);
var
  i: Integer;
begin
  StudListDlg := TStudListDlg.Create(Application);
  try
    if StudListDlg.ShowModal = mrOK then
    begin
      for i := 0 to MainForm.Group1.Count - 1 do
        MainForm.Group1.Items[i].Checked := False;
      XML_DISPLAY.GroupIndexDisplay := 0;
    end;
  finally
    FreeAndNil(StudListDlg);
  end;
end;

procedure TStudentListWin.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 StBarCode1.Free;
 action:=cafree;
end;

procedure TStudentListWin.FormPaint(Sender: TObject);

  procedure printNumbers(max: integer);
  var
   tabN,i,j,a,te,ro: integer;
   teStr: string;

     procedure AdjustPrint(n:integer);
      begin
       x:=x+tabN-canvas.textwidth(inttostr(n));
       printw(inttostr(n));
      end;

  begin
   tabN:=canvas.textwidth('9999');
   for j:=1 to max do
    begin
     if XML_DISPLAY.listnumbertype=1 then i:=RollClassPoint[j] else i:=j;
     if ((maleCount[i]+femaleCount[i])>0) then
      begin
       if XML_DISPLAY.double_space then newline;
       case XML_DISPLAY.listnumbertype of
        1: begin  {classes}
            printw(ClassCode[i]);
            if HasClassTutor then
             begin
              a:=GetClassTutor(i);
              if a>0 then
               begin
                fcolor(cpTeach);
                x:=Tabs[5];
                printw(XML_TEACHERS.TeCode[a,0]);
                x:=Tabs[6];
                printw(XML_TEACHERS.TeName[a,0]);
                fcolor(codecolor);
               end;
             end;
           end;
        2: printw(HouseName[i]); {houses}
        3: begin {subjects}
            a:=GroupSubs[i];
            printw(SubCode[a]); x:=Tabs[1]; printw(Subname[a]);
            x:=Tabs[2];
            te:=teach[i]; if teach[i]=-1 then findSubTeacher(te,ro,a);
            testr:='';
            if te>0 then
             begin
              testr:=XML_TEACHERS.tecode[te,0];
              if teach[i]=-1 then testr:=testr+'*';
              fcolor(cpTeach);
              printw(testr);
              x:=Tabs[3]; printw(XML_TEACHERS.Tename[te,0]);
              fcolor(codecolor);
             end;
            x:=Tabs[4]; AdjustPrint(maleCount[i]);
            x:=Tabs[5]; AdjustPrint(femaleCount[i]);
            x:=Tabs[6]; AdjustPrint(maleCount[i]+femaleCount[i]);
            newline;
           end;
        4: begin  {tutors}
            fcolor(cpTeach);
            printw(XML_TEACHERS.TeCode[i,0]);
            x:=fwCode[1]+blankwidth; printw(XML_TEACHERS.TeName[i,0]);
            fcolor(codecolor);
           end;
        5: begin {rooms}
            fcolor(cpRoom);
            printw(XML_TEACHERS.teCode[i,1]);
            x:=fwCode[2]+blankwidth;
            printw(XML_TEACHERS.TeName[i,1]);
            fcolor(codecolor);
           end;
        6: begin //Faculty
            FColor(cpFac);
            PrintW(FacName[i]);
            FColor(codecolor);
           end;
       end; {case}

       if (XML_DISPLAY.listnumbertype<>3) then
        begin
         x:=Tabs[1]; AdjustPrint(maleCount[i]);
         x:=Tabs[2]; AdjustPrint(femaleCount[i]);
         x:=Tabs[3]; AdjustPrint(maleCount[i]+femaleCount[i]);
         newline;
        end;
      end;  {if ((maleCount[i]+femaleCount[i])>0) }
    end; {for j}
   if ((maleCount[0]+femaleCount[0])>0) then
   begin
    if XML_DISPLAY.double_space then newline;
    printw('Not allocated:');
    x:=Tabs[1]; AdjustPrint(maleCount[0]);
    x:=Tabs[2]; AdjustPrint(femaleCount[0]);
    x:=Tabs[3]; AdjustPrint(maleCount[0]+femaleCount[0]);
    newline;
   end
   else if XML_DISPLAY.ListNumberType = 6 then
   begin
     if XML_DISPLAY.double_space then newline;
     printw('Not allocated:');
     x := Tabs[1]; AdjustPrint(FNonAllocM);
     x := Tabs[2]; AdjustPrint(FNonAllocF);
     x := Tabs[3]; AdjustPrint(FNonAllocM + FNonAllocF);
     newline;
   end;

   if XML_DISPLAY.ListNumberType <> 3 then
   begin
    if ((XML_DISPLAY.ListNumberType = 6) and ((Tmale > FNonAllocM) or (Tfemale > FNonAllocF))) then   // if any values then dont show the totals
      Exit;
    fcolor(cpNormal);
    if XML_DISPLAY.double_space then newline;
    printw('Totals:');
    x:=Tabs[1]; AdjustPrint(Tmale);
    x:=Tabs[2]; AdjustPrint(Tfemale);
    x:=Tabs[3]; AdjustPrint(Tmale+Tfemale);
    newline
   end;
  end; {---------------- local procedure printnumbers ---------------}

begin    { START  of main paint proc}
 if XML_DISPLAY.StudListType=7 then
  begin
   PaintHead;
   fcolor(codecolor);
   case XML_DISPLAY.listnumbertype of
      1: printNumbers(RollClassPoint[0]);
      2: printNumbers(nmbrHouse);
      3: printNumbers(GroupSubs[0]);
      4: printNumbers(nmbrTeachers);
      5: printNumbers(nmbrRooms);
      6: PrintNumbers(nmbrFaculty);
   end; {case}
  end;
end;

procedure TStudentListWin.FormCreate(Sender: TObject);
begin
 setWindowDefaults(self,wnStudentList);
 updateStudGroupMenu;
 rangeCheckStudSels(liststudentselection);
 BarcodeMake;
 //#198 - set initial sort
 groupsort := 1;
end;

procedure TStudentListWin.AddStudent1Click(Sender: TObject);
begin
 mainform.AddStudent1Click(Self);
end;

procedure TStudentListWin.ChangeStudent1Click(Sender: TObject);
begin
 mainform.ChangeStudent1Click(Self);
end;

procedure TStudentListWin.DeleteStudent1Click(Sender: TObject);
begin
 mainform.DeleteStudent1Click(Self);
end;

procedure TStudentListWin.DisplayStudentHealth(Sender: TObject);
var
  lFrmHealthCondition: TFrmHealthCondition;
begin
  lFrmHealthCondition := TFrmHealthCondition.Create(Application);
  try
    lFrmHealthCondition.HasAccess := usrPassLevel <> utGen;
    lFrmHealthCondition.StudentNo := MySelStud;
    lFrmHealthCondition.ShowModal;
  finally
    FreeAndNil(lFrmHealthCondition);
  end;
end;

procedure TStudentListWin.DisplayStudentInput(Sender: TObject);
begin
  MainForm.DisplayStudentInput(Self);
end;

procedure TStudentListWin.CommonData1Click(Sender: TObject);
begin
 mainform.CommonData1Click(Self);
end;

procedure TStudentListWin.CountFacultyStudents;
var
  i,i9,a:  integer;
  lFacIdx: Integer;
  lIsAllocated: Boolean;
begin
  FNonAllocM := 0;
  FNonAllocF := 0;
  for i:=0 to nmbrTeachers do
  begin
    maleCount[i] := 0;
    femaleCount[i] := 0;
  end; {for i}
  Tmale := 0;
  Tfemale := 0;

  for i9 := 1 to GroupNum do
  begin
    i := StGroup[i9];
    lIsAllocated := False;
    for lFacIdx := 1 to 4 do
    begin
      a := GetTeacherFaculty(XML_STUDENTS.Stud[i].Tutor, lFacIdx);
      if a > 0 then
      begin
        if XML_STUDENTS.Stud[i].Sex = GenderShort[0]{'M'} then
        begin
          Inc(maleCount[a]);
        end
        else
        begin
          Inc(femaleCount[a]);
        end;
        lIsAllocated := True;
      end;
    end;  // for
    if XML_STUDENTS.Stud[i].Sex = genderShort[0]{'M'} then
    begin
      Inc(Tmale);
      if not lIsAllocated then
        Inc(FNonAllocM);
    end
    else
    begin
      Inc(Tfemale);
      if not lIsAllocated then
        Inc(FNonAllocF);
    end;
  end;  {for i9}
end;

procedure TStudentListWin.ClearChoices1Click(Sender: TObject);
begin
 MainForm.ClearChoices1Click(self);
end;

procedure TStudentListWin.Print1Click(Sender: TObject);
begin
end;

{---------------------- print procs follow -----------------------------------------}

procedure TPrintStudList.head;
begin
 if DoHeader then
  begin
   UnderlineOn;
   printwl('Student List '+GroupCaption);
   printw(PageCount);
   UnderlineOff;
  end;
 if DoHeader or (XML_DISPLAY.StudListType=7) then
  begin
   x:=0; y:=y+PrnttxtHeight;
   fcolor(cpNormal);
   printWl('Student');
   case XML_DISPLAY.StudListType of
    1:  if liststudentselection[0]>0 then printWl(' Selection');
    2:  printWl('s '+' Group: '+groupname+' sorted by '+groupsortname[groupsort]);
    3:  begin
         if XML_DISPLAY.listRanges[1,1]>0 then
          printWl('s in '+ClassCode[XML_DISPLAY.listRanges[1,1]])
         else printWl('s in All Classes');
         printWl(' sorted by '+groupsortname[groupsort]);
        end;
    4:  begin
         if XML_DISPLAY.listRanges[2,1]>0 then
          printWl('s in '+HouseName[XML_DISPLAY.listRanges[2,1]])
         else printWl('s in All Houses');
         printWl(' sorted by '+groupsortname[groupsort]);
        end;
    5:  begin
         if XML_DISPLAY.listRanges[3,1]>0 then
          printWl('s in '+XML_TEACHERS.TeCode[XML_DISPLAY.listRanges[3,1],0])
         else printWl('s in All Tutors');
         printWl(' sorted by '+groupsortname[groupsort]);
        end;
    6:  begin
         if XML_DISPLAY.listRanges[4,1]>0 then
          printWl('s in '+XML_TEACHERS.TeCode[XML_DISPLAY.listRanges[4,1],1])
         else printWl('s in All Home Rooms');
         printWl(' sorted by '+groupsortname[groupsort]);
        end;
    7:  begin
         case XML_DISPLAY.listnumbertype of
         1: begin
             printWl(' Numbers for Classes');
             x:=0; y:=y+2*PrnttxtHeight;
             printWl('Class');
             if HasClassTutor then
              begin
               x:=PrntTabs[5]; printw('Teacher');
              end;
            end;
         2: begin
             printWl(' Numbers for Houses');
             x:=0; y:=y+2*PrnttxtHeight;
             printWl('House');
            end;
         3:  begin
             printWl(' Numbers for Subjects');
             x:=0; y:=y+2*PrnttxtHeight;
             printWl('Subject');
             x:=PrntTabs[1]; printwl('Subject name');
             x:=PrntTabs[2]; printWl('Teacher');
             x:=PrntTabs[3]; printWl('Teacher name');
             x:=PrntTabs[4]; printWl('Male');
             x:=PrntTabs[5]; printWl('Female');
             x:=PrntTabs[6]; printWl('Total');
            end;
         4:  begin
             printWl(' Numbers for Tutors');
             x:=0; y:=y+2*PrnttxtHeight;
             printWl('Tutor');
            end;
         5: begin
             printWl(' Numbers for Rooms');
             x:=0; y:=y+2*PrnttxtHeight;
             printWl('Room');
            end;
         6: begin
             PrintWl(' Numbers for faculties');
             x := 0; y := y + 2 * PrnttxtHeight;
             PrintWl('Faculty');
            end;
         end; {case}
         if XML_DISPLAY.listnumbertype<>3 then
          begin
           x:=PrntTabs[1]; printWl('Male');
           x:=PrntTabs[2]; printWl('Female');
           x:=PrntTabs[3]; printWl('Total');
          end;
        end;
   end; {case}
    x:=0; y:=y+PrnttxtHeight;
  end; {if DoHeader or (StudListType=7)}
end;

procedure TPrintStudList.ListHead(i:integer);
begin
 if DoHeader and not(EnrolFlag) then
  begin
   fcolor(cpNormal);
   case XML_DISPLAY.StudListType of
    3:printwl('Class '+ClassCode[ListSet[i]]);
    4:printwl('House '+HouseName[ListSet[i]]);
    5:printwl('Tutor '+XML_TEACHERS.TeCode[ListSet[i],0]+' '+XML_TEACHERS.TeName[ListSet[i],0]);
    6:printwl('Room '+XML_TEACHERS.TeCode[ListSet[i],1]+' '+XML_TEACHERS.TeName[ListSet[i],1]);
   end;
  end;
end;

procedure TPrintStudList.GetLists;
var
 i: integer;
begin
 NumOfLists:=StudentListWin.NumOfLists;
 SetArraySizes;
 if NumOfLists>0 then
  for i:=1 to NumOfLists do
   begin
    ListSize[i]:=StudentListWin.ListSize[i];
    ListSet[i]:=StudentListWin.ListSet[i];
   end;
end;

procedure TPrintStudList.GetListContents(i: integer);
begin
 SetLength(ListContents,ListSize[i]+1);
 GeneralListContents(i,ListSize[i],ListSet[i],ListContents);
end;

procedure TPrintStudList.SetTabs;
var
 tabT: integer;
begin
 SetLength(PrntTabs,8);
 if XML_DISPLAY.StudListType<7 then ListType:=1 else ListType:=2;
 {1 - student list  2- numbers}
 codeColor:=cpStList; EnrolFlag:=XML_DISPLAY.listEnrolment;
 ShowZeroList:=true;
 tabT:=PrintCanvas.textwidth('123Total  ');
 if XML_DISPLAY.StudListType<>7 then
 begin
   GetLists;
   CalcHeights;
 end
 else {numbers}
 begin
   case XML_DISPLAY.listnumbertype of
    1: begin
        MaxTab(1,fwPrntClass,'Not Allocated  ');
        countClasses;
        TotalCount:=7+CalcCountMax(Classnum);
        if HasClassTutor then
         begin
          MaxTab(2,fwPrntCode[1]+fwPrntCodename[1]+2*Prntblankwidth,'Teacher ');
          PrntTabs[5]:=PrntTabs[1];PrntTabs[1]:=PrntTabs[2];
          PrntTabs[6]:=PrntTabs[5]+fwPrntcode[1]+Prntblankwidth;
         end;
       end;
    2: begin
        MaxTab(1,fwPrntHouse,'Not Allocated  ');
        countHouses;
        TotalCount:=7+CalcCountMax(Housecount);
       end;
    3: begin
        MaxTab(1,fwPrntCode[0],'Subject ');
        MaxTab(2,fwPrntCodename[0],'Subject Name ');
        MaxTab(3,fwPrntCode[1],'Teacher ');
        MaxTab(4,fwPrntCodename[1],'Teacher Name ');
//        MaxTab(5,0,'123Male');
//        MaxTab(6,0,'123Female');
        MaxTab(5,0,'123'+genderLong[0]);
        MaxTab(6,0,'123'+genderLong[1]);

        PrntTabs[7]:=PrntTabs[6]+tabT;
        countSubjects;
        StudentNumberTeach;
        TotalCount:=7+CalcCountMax(NumCodes[0]);
       end;
    4: begin
        MaxTab(1,fwPrntCode[1]+fwPrntCodename[1]+PrntBlankwidth,'Not Allocated  ');
        countTutors;
        TotalCount:=7+CalcCountMax(numcodes[1]);
       end;
    5: begin
        MaxTab(1,fwPrntCode[2]+fwPrntCodename[2]+PrntBlankwidth,'Not Allocated  ');
        countRooms;
        TotalCount:=7+CalcCountMax(numcodes[2]);
       end;
    6: begin
        MaxTab(1, fwprntFaculty + PrntBlankwidth,'Not Allocated  ');
        StudentListWin.CountFacultyStudents;
        TotalCount := 7 + CalcCountMax(FacNum);
       end;
   end; {case}
   if XML_DISPLAY.listnumbertype<>3 then
   begin
     MaxTab(2,0,'123'+genderLong[0]);
     MaxTab(3,0,'123'+genderLong[1]);

     PrntTabs[7]:=PrntTabs[3]+tabT;
   end;
 end;
end;

procedure Studentlistprint;

 procedure printNumbers(max: integer);
 var
  tabN,i,j,a: integer;

     procedure AdjustPrint(n:integer);
      begin
       with PrintStudList do
        begin
         x:=x+tabN-PrintCanvas.textwidth(inttostr(n));
         printw(inttostr(n));
        end;
      end;

 begin
  with PrintStudList do
  begin
   tabN:=PrintCanvas.textwidth('9999');
   for j:=1 to max do
    begin
     if XML_DISPLAY.listnumbertype=1 then i:=RollClassPoint[j] else i:=j;
     if ((maleCount[i]+femaleCount[i])>0) then
      begin
       if XML_DISPLAY.double_space then newline;
       case XML_DISPLAY.listnumbertype of
        1: begin  {classes}
            printw(ClassCode[i]);
            if HasClassTutor then
             begin
              a:=GetClassTutor(i);
              if a>0 then
               begin
                fcolor(cpTeach);
                x:=PrntTabs[5];
                printw(XML_TEACHERS.TeCode[a,0]);
                x:=PrntTabs[6];
                printw(XML_TEACHERS.TeName[a,0]);
                fcolor(codecolor);
               end;
             end;
           end;
        2: printw(HouseName[i]); {houses}
        3: begin {subjects}
            a:=GroupSubs[i];
            printw(SubCode[a]); x:=PrntTabs[1]; printw(Subname[a]);
            x:=PrntTabs[2];
            if teach[i]<>-1 then
            begin
             fcolor(cpTeach);
             printw(XML_TEACHERS.TeCode[teach[i],0]);
             x:=PrntTabs[3]; printw(XML_TEACHERS.Tename[teach[i],0]);
             fcolor(codecolor);
            end
            else
             printw('*');
            x:=PrntTabs[4]; AdjustPrint(maleCount[i]);
            x:=PrntTabs[5]; AdjustPrint(femaleCount[i]);
            x:=PrntTabs[6]; AdjustPrint(maleCount[i]+femaleCount[i]);
            newline;
           end;
        4: begin  {tutors}
            fcolor(cpTeach);
            printw(XML_TEACHERS.TeCode[i,0]);
            x:=fwPrntCode[1]+PrntBlankwidth; printw(XML_TEACHERS.TeName[i,0]);
            fcolor(codecolor);
           end;
        5: begin {rooms}
            fcolor(cpRoom);
            printw(XML_TEACHERS.teCode[i,1]);
            x:=fwPrntCode[2]+PrntBlankwidth;
            printw(XML_TEACHERS.TeName[i,1]);
            fcolor(codecolor);
           end;
        6: begin // Faculty
            fcolor(cpFac);
            Printw(FacName[i]);
            FColor(codecolor);
           end;
       end; {case}

       if (XML_DISPLAY.listnumbertype<>3) then
        begin
         x:=PrntTabs[1]; AdjustPrint(maleCount[i]);
         x:=PrntTabs[2]; AdjustPrint(femaleCount[i]);
         x:=PrntTabs[3]; AdjustPrint(maleCount[i]+femaleCount[i]);
         newline;
        end;
      end;   {if ((maleCount[i]+femaleCount[i])>0) }
    end; {for j}
   if ((maleCount[0]+femaleCount[0])>0) then
    begin
     if XML_DISPLAY.double_space then newline;
     printw('Not allocated:');
     x:=PrntTabs[1]; AdjustPrint(maleCount[0]);
     x:=PrntTabs[2]; AdjustPrint(femaleCount[0]);
     x:=PrntTabs[3]; AdjustPrint(maleCount[0]+femaleCount[0]);
     newline;
   end
   else if XML_DISPLAY.ListNumberType = 6 then
   begin
     if XML_DISPLAY.double_space then newline;
     printw('Not allocated:');
     x := PrntTabs[1]; AdjustPrint(StudentListWin.FNonAllocM);
     x := PrntTabs[2]; AdjustPrint(StudentListWin.FNonAllocF);
     x := PrntTabs[3]; AdjustPrint(StudentListWin.FNonAllocM + StudentListWin.FNonAllocF);
     newline;
    end;
    if (XML_DISPLAY.ListNumberType <> 3)  and (XML_DISPLAY.ListNumberType <> 6) then
     begin
      fcolor(cpNormal);
      if XML_DISPLAY.double_space then newline;
      printw('Totals:');
      x:=PrntTabs[1]; AdjustPrint(Tmale);
      x:=PrntTabs[2]; AdjustPrint(Tfemale);
      x:=PrntTabs[3]; AdjustPrint(Tmale+Tfemale);
      newline
     end;
  end; {with PrintStudList}
 end; {---------------- local procedure printnumbers ---------------}

begin    { START  of main paint proc}
 PrintStudList:=TPrintStudList.Create;
 with PrintStudList do
  try
   DoHeader:=XML_DISPLAY.StHeadShow;
   BarcodeMake;
   SetTabs;
   if XML_DISPLAY.StudListType=7 then
      begin
       header;
       fcolor(codecolor);
       case XML_DISPLAY.listnumbertype of
          1: printNumbers(RollClassPoint[0]);
          2: printNumbers(nmbrHouse);
          3: printNumbers(GroupSubs[0]);
          4: printNumbers(nmbrTeachers);
          5: printNumbers(nmbrRooms);
          6: PrintNumbers(nmbrFaculty);
       end; {case}
       printCustomAddon;
      end
   else ShowLists;
   StBarCode1.free;
  finally
   PrintStudList.free;
  end;
end;

procedure TOutStudList.head;
begin
 if DoHeader then printLine(['Student List ',GroupCaption]);
 if DoHeader or (XML_DISPLAY.StudListType=7) then
  begin
   printw('Student');
   case XML_DISPLAY.StudListType of
    1:  if liststudentselection[0]>0 then printw(' Selection');
    2:  printw('s '+' Group: '+groupname+' sorted by '+groupsortname[groupsort]);
    3:  begin
         if XML_DISPLAY.listRanges[1,1]>0 then
          printw('s in '+ClassCode[XML_DISPLAY.listRanges[1,1]])
         else printw('s in All Classes');
         printw(' sorted by '+groupsortname[groupsort]);
        end;
    4:  begin
         if XML_DISPLAY.listRanges[2,1]>0 then
          printw('s in '+HouseName[XML_DISPLAY.listRanges[2,1]])
         else printw('s in All Houses');
         printw(' sorted by '+groupsortname[groupsort]);
        end;
    5:  begin
         if XML_DISPLAY.listRanges[3,1]>0 then
          printw('s in '+XML_TEACHERS.TeCode[XML_DISPLAY.listRanges[3,1],0])
         else printW('s in All Tutors');
         printW(' sorted by '+groupsortname[groupsort]);
        end;
    6:  begin
         if XML_DISPLAY.listRanges[4,1]>0 then
          printW('s in '+XML_TEACHERS.TeCode[XML_DISPLAY.listRanges[4,1],1])
         else printW('s in All Home Rooms');
         printW(' sorted by '+groupsortname[groupsort]);
        end;
    7:  begin
         case XML_DISPLAY.listnumbertype of
         1: begin
             printW(' Numbers for Classes');
             newline; newline;
             printW('Class');
             if HasClassTutor then
              begin
               printc('Teacher'); printc('');
              end;
            end;
         2: begin
             printW(' Numbers for Houses');
             newline; newline;
             printW('House');
            end;
         3:  begin
             printW(' Numbers for Subjects');
             newline; newline;
             printW('Subject');
             printc('Subject name');
             printc('Teacher');
             printc('Teacher name');
             printc('Male');
             printc('Female');
             printc('Total');
            end;
         4:  begin
             printW(' Numbers for Tutors');
             newline; newline;
             printW('Tutor');
            end;
         5: begin
             printW(' Numbers for Rooms');
             newline; newline;
             printW('Room');
            end;
         6: begin
             PrintW(' Numbers for Faculties');
             newline; newline;
             PrintW('Faculty');
            end;
         end; {case}
         if XML_DISPLAY.listnumbertype<>3 then
          begin
           printc('Male');
           printc('Female');
           printc('Total');
          end;
        end;
   end; {case}
    newline; newline;
  end; {if DoHeader or (StudListType=7)}
end;

procedure TOutStudList.ListHead(i:integer);
begin
 if DoHeader and not(EnrolFlag) then
  begin
   case XML_DISPLAY.StudListType of
    3:printw('Class '+ClassCode[ListSet[i]]);
    4:printw('House '+HouseName[ListSet[i]]);
    5:printw('Tutor '+XML_TEACHERS.TeCode[ListSet[i],0]+' '+XML_TEACHERS.TeName[ListSet[i],0]);
    6:printw('Room '+XML_TEACHERS.TeCode[ListSet[i],1]+' '+XML_TEACHERS.TeName[ListSet[i],1]);
   end;
   newline;
  end;
end;

procedure TOutStudList.GetLists;
var
 i: integer;
begin
 NumOfLists:=StudentListWin.NumOfLists;
 SetArraySizes;
 if NumOfLists>0 then
  for i:=1 to NumOfLists do
   begin
    ListSize[i]:=StudentListWin.ListSize[i];
    ListSet[i]:=StudentListWin.ListSet[i];
   end;
end;

procedure TOutStudList.GetListContents(i: integer);
begin
 SetLength(ListContents,ListSize[i]+1);
 GeneralListContents(i,ListSize[i],ListSet[i],ListContents);
end;

procedure TOutStudList.SetTabs;
begin
 if XML_DISPLAY.StudListType<7 then ListType:=1 else ListType:=2;
 {1 - student list  2- numbers}
 EnrolFlag:=XML_DISPLAY.listEnrolment;
 ShowZeroList:=true;
 if XML_DISPLAY.StudListType<>7 then
  begin
   GetLists;
   CalcTotalCount;
  end
 else {numbers}
  begin
   case XML_DISPLAY.listnumbertype of
    1: begin
        countClasses;
        TotalCount:=7+CalcCountMax(Classnum);
       end;
    2: begin
        countHouses;
        TotalCount:=7+CalcCountMax(Housecount);
       end;
    3: begin
        countSubjects;
        StudentNumberTeach;
        TotalCount:=7+CalcCountMax(NumCodes[0]);
       end;
    4: begin
        countTutors;
        TotalCount:=7+CalcCountMax(numcodes[1]);
       end;
    5: begin
        countRooms;
        TotalCount:=7+CalcCountMax(numcodes[2]);
       end;
    6: begin
        StudentListWin.CountFacultyStudents;
        TotalCount := 7 + CalcCountMax(FacNum);
       end;
   end; {case}
  end;
end;

procedure StudentlistOut(const pIsSpecial: Boolean = False);

 procedure printNumbers(max: integer);
 var
  i,j,a: integer;

     procedure Printn(n:integer);
      begin
       OutStudList.printc(inttostr(n));
      end;

 begin
  with OutStudList do
  begin
   for j:=1 to max do
    begin
     if XML_DISPLAY.listnumbertype=1 then i:=RollClassPoint[j] else i:=j;
     if ((maleCount[i]+femaleCount[i])>0) then
      begin
       if XML_DISPLAY.double_space then newline;
       case XML_DISPLAY.listnumbertype of
        1: begin {classes}
            printw(ClassCode[i]);
            if HasClassTutor then
             begin
              a:=GetClassTutor(i);
              printc(XML_TEACHERS.TeCode[a,0]);
              printc(XML_TEACHERS.TeName[a,0]);
             end;
           end;
        2: printw(HouseName[i]); {houses}
        3: begin {subjects}
            a:=GroupSubs[i];
            printw(SubCode[a]); printc(Subname[a]);
            if teach[i]<>-1 then
            begin
             printc(XML_TEACHERS.TeCode[teach[i],0]);
             printc(XML_TEACHERS.Tename[teach[i],0]);
            end
            else
             printc('*');
             printn(maleCount[i]);
             printn(femaleCount[i]);
             printn(maleCount[i]+femaleCount[i]);
            newline;
           end;
        4: begin  {tutors}
            printw(XML_TEACHERS.TeCode[i,0]);
            printc(XML_TEACHERS.TeName[i,0]);
           end;
        5: begin {rooms}
            printw(XML_TEACHERS.teCode[i,1]);
            printc(XML_TEACHERS.TeName[i,1]);
           end;
        6: begin //Faculty
            printw(FacName[i]);
           end;
       end; {case}

       if (XML_DISPLAY.listnumbertype<>3) then
        begin
         printn(maleCount[i]);
         printn(femaleCount[i]);
         printn(maleCount[i]+femaleCount[i]);
         newline;
        end;
      end; {if ((maleCount[i]+femaleCount[i])>0) }
    end; {for i}
   if ((maleCount[0]+femaleCount[0])>0) then
    begin
     if XML_DISPLAY.double_space then newline;
     printw('Not allocated:');
     if (XML_DISPLAY.listnumbertype=1) and HasClassTutor then
          begin printc(''); printc(''); end;
     if XML_DISPLAY.listnumbertype>3 then printc('');
     printn(maleCount[0]);
     printn(femaleCount[0]);
     printn(maleCount[0]+femaleCount[0]);
     newline;
   end
   else if XML_DISPLAY.ListNumberType = 6 then
   begin
     if XML_DISPLAY.double_space then newline;
     printw('Not allocated:');
     printn(StudentListWin.FNonAllocM);
     printn(StudentListWin.FNonAllocF);
     printn(StudentListWin.FNonAllocM + StudentListWin.FNonAllocF);
     newline;
    end;
   if (XML_DISPLAY.ListNumberType <> 3) and (XML_DISPLAY.ListNumberType <> 6) then
    begin
     if XML_DISPLAY.double_space then newline;
     printw('Totals:');
     if XML_DISPLAY.listnumbertype>3 then printc('');
     printn(Tmale);
     printn(Tfemale);
     printn(Tmale+Tfemale);
     newline
    end;
  end; {with OutStudList}
 end; {---------------- local procedure printnumbers ---------------}

begin    { START  of main paint proc}
 OutStudList:=TOutStudList.Create;
 ///OutStudList.IsSpecial := pIsSpecial;

 with OutStudList do
  try
   DoHeader:=XML_DISPLAY.StHeadShow;
   SetTabs;
   if XML_DISPLAY.StudListType=7 then
      begin
       header;
       case XML_DISPLAY.listnumbertype of
          1: printNumbers(RollClassPoint[0]);
          2: printNumbers(nmbrHouse);
          3: printNumbers(GroupSubs[0]);
          4: printNumbers(nmbrTeachers);
          5: printNumbers(nmbrRooms);
          6: PrintNumbers(nmbrFaculty);
       end; {case}
       printCustomAddon;
      end
   else
     if pIsSpecial then
       ShowLists(True)
     else
       ShowLists;

  finally
   OutStudList.free;
  end;
end;

procedure TStudentListWin.PopupMenu1Popup(Sender: TObject);
begin
  if XML_STUDENTS.numstud=0 then
  begin
    group1.enabled := False;
    changestudent1.enabled := False;
    deletestudent1.enabled := False;
    commondata1.enabled := False;
    clearchoices1.enabled := False;
    popStudentHealth.Enabled := False;
  end
  else
  begin
    group1.Enabled := True;
    changestudent1.Enabled := True;
    deletestudent1.Enabled := True;
    commondata1.Enabled := True;
    clearchoices1.Enabled := True;
    popStudentHealth.Enabled := True;
  end;
  popStudentDeleteCurrentYear.Visible := ((usrPassLevel = utTime) or (usrPassLevel = utSuper)) and (GroupType = 1) and (GroupNum > 0) and (XML_DISPLAY.StudListType = 2);
  selection1.enabled:=(XML_STUDENTS.numstud>0);

  ShowStudentTimetable1.visible:=false;
  if self.selcode>0 then ShowStudentTimetable1.visible:=true;
end;

procedure TStudentListWin.ShowStudentTimetable1Click(Sender: TObject);
begin
 if self.selcode>0 then
 begin
  XML_DISPLAY.StudTtListType:=1; {selection}
  winView[wnStudentTt]:=1; {weekly}
  XML_DISPLAY.StudentTtSelection[0]:=1;
  XML_DISPLAY.StudentTtSelection[1]:=MySelStud;
  XML_DISPLAY.stuttlistvals[3]:=0; {class;}
  XML_DISPLAY.stuttlistvals[4]:=0; {tmphouse; }
  XML_DISPLAY.stuttlistvals[5]:=0; {tmptutor; }
  XML_DISPLAY.stuttlistvals[6]:=0; {room;  }
  studentTtablewinSelect;
  UpdateWindow(wnStudentTt);
 end;
end;


{---------------clipboard routine ------------------------}


procedure TStudentListWin.Select1Click(Sender: TObject);
begin
 MainForm.Select2Click(Self);
end;

procedure TStudentListWin.Sort1Click(Sender: TObject);
begin
 MainForm.Sort1Click(Self);
end;

procedure TStudentListWin.DeleteCurrentGroup(Sender: TObject);
var
  i: Integer;
  lNumStud: Integer;
  lYearStr: string;
  lTempY: Integer;
  lCount: Integer;
begin
  if XML_DISPLAY.StudListType = 2 then
  begin
    lYearStr := UpperCase(Trim(GroupSelStr[1]));
    lCount := GroupNum;
    if MessageDlg(Format('There are %d students in %s %s group. Are you sure you want to delete all the students of this %s group?', [lCount, YearTitle, lYearStr, YearTitle]) + Cr +'To proceed click Yes otherwise click No.', mtConfirmation, mbYesNo, 0) = mrYes then
    begin
      lTempY := FindYear(lYearStr);
      lNumStud := XML_STUDENTS.NumStud;
      for i := lNumStud downto 1 do
        if XML_STUDENTS.Stud[i].TcYear = lTempY then
          RemoveStudent(i);
      SaveAllStudentYears;
      Self.SelCode := 0;
      UpdateStudCalcs;
      RangeCheckStudSels(ListStudentSelection);
      RangeCheckStudSels(XML_DISPLAY.StudentInputSelection);
      RangeCheckStudSels(XML_DISPLAY.StudentTTSelection);
      UpDateAllWins;
      MessageDlg(Format('%d students have been removed.', [lCount]), mtConfirmation, [mbOk], 0);
    end;
  end;
end;

procedure TStudentListWin.grp01Click(Sender: TObject);
var
  i: Integer;
begin
  CookCustomGroup(GOSmenu[(sender as TMenuItem).tag]);
  XML_DISPLAY.GroupIndexDisplay := GOSmenu[(sender as TMenuItem).tag];
  for i := 0 to (Sender as TMenuItem).Parent.Count - 1 do
  begin
    //Keep the tags of group menu in Main in synch with group menu here
    if Main.MainForm.Group1.Items[i].Tag = (Sender as TMenuItem).Tag then
       Main.MainForm.Group1.Items[i].Checked := True
    else
      Main.MainForm.Group1.Items[i].Checked := False;
  end;
end;

function getMinYearWithStuds: smallint;
var
 i,j: smallint;
begin
 j:=0;
 for i:=0 to years_minus_1 do
  if yearStat[i].numStud>0 then
  begin
   j:=i; break;
  end;
 result:=j;
end;

function findStudentByID(fStudID: string): smallint;
var
 i:  integer;
 astr: string;
begin
 result:=0;  astr:=Uppercase(trim(fStudID));
 for i:=1 to XML_STUDENTS.numstud do
  if astr=Uppercase(trim(XML_STUDENTS.Stud[i].ID)) then
   begin
    result:=i; break;
   end;
end;

function findStudentByNameAndYear(fStname,fFisrt: string; fTCYear: smallint): smallint;
var
 i,j:  integer;

 function DoSkip(n1,n2: smallint):boolean;
 begin
  result:=(((n1>0) and (n2>0)) and (n1<>n2));
 end;

 function DoSkipS(s1,s2: string):boolean;
 begin
  s1:=Uppercase(trim(s1));  s2:=Uppercase(trim(s2));
  result:=(((s1>'')and (s2>'')) and (s1<>s2));
 end;

begin
 result:=0;
 for i:=1 to XML_STUDENTS.numstud do
 begin
  j:=i;
  if DoSkipS(fStname,XML_STUDENTS.Stud[j].StName) then continue; {check surname}
  if DoSkipS(fFisrt,XML_STUDENTS.Stud[j].First) then continue; {check first name}
  if DoSkip(fTCYear+1,XML_STUDENTS.Stud[j].TcYear+1) then continue; {check year}
  {still here so found stud match}
  result:=j; break;
 end; {for i}
end;

procedure TStudentListWin.ParseClipStudentText;
var
 tmpGenText: ansistring;
 tmpI,tmpJ,tmpK: smallint;
 oldSorttype:    smallint;
 CUPAcnt:        smallint;
 msg:       string;
 SubsAdded: boolean;

  procedure getStudClipCell;
  var
   ss,ss2: ansistring;
   codeStr: string;
   i,j,k,pcnt,fnm,cci: integer;
   m,codePlace: integer;
//   StudPiece: array[0..(12+nmbrChoices)] of string[szStName];
   StudPiece: array[0..(12+nmbrChoices)] of string[100];
   faStud:  tpStudRec;
//   faStudID2: string[szID];
   faStudID2: string[50];
   faStudEmail: string[100];
   lNoOfFields: Integer;

    procedure RemoveSubDuplicates;
    var
     i,j,k: integer;
    begin
     for i:=1 to nmbrchoices-1 do
      for j:=i+1 to nmbrchoices do
       if faStud.choices[i]=faStud.choices[j] then
        begin
         faStud.choices[j]:=0;
         if j<nmbrchoices then
          for k:=j to nmbrchoices-1 do
            faStud.Choices[j]:=faStud.choices[j+1];
        end;
    end;

  begin  {getStudClipCell}
   {get student line}
   j:=pos(cr,genText);
   ss2:=copy(genText,1,j-1);
   genText:=copy(genText,j+2,length(genText));
   {init pieces}
   if XML_DISPLAY.stID2 then
     lNoOfFields := 11 + NmbrChoices
   else
     lNoOfFields := 10 + NmbrChoices;
   if XML_DISPLAY.stEmail then inc(lNoOfFields);


   for i:=1 to lNoOfFields do studpiece[i]:='';
   {parse line into pieces}
   i:=pos(ht,ss2);  pcnt:=1;
   while i>0 do
    begin
     ss:=copy(ss2,1,i-1); studpiece[pcnt]:=ss; inc(pcnt);
     ss2:=copy(ss2,i+1,length(ss2)); i:=pos(ht,ss2);
    end;
   StudPiece[pcnt]:=ss2; {whats left}
   {trim pieces}
   for i:=1 to pcnt do studpiece[i]:=trim(studpiece[i]);
   {try to sort out pieces into a student - pcnt=# of pieces}
   {init stud}
   faStud.Stname:=''; faStud.First:=''; faStud.ID:=''; faStud.sex:='';
   faStud.TcClass:=0; faStud.TcYear:=-1; faStud.house:=0; faStud.Tutor:=0;
   faStud.home:=0;    faStud.StrRecord:=0;
   faStudID2:='';
   faStudEmail:='';

   for i:=1 to nmbrchoices do faStud.choices[i]:=0;
   {assume surname followed by first name are first two fields}
   faStud.Stname:=studpiece[1]; faStud.First:=studpiece[2];
   {get rest of student fields}
   for i:=3 to pcnt do //check year
   begin
     if studpiece[i]='' then continue;
     k := findyear(StudPiece[i]);
     if (k>=0) then
     begin
       faStud.TcYear:=k;
       StudPiece[i]:=''; break; //don't reuse
     end;
   end; {for i}
   if faStud.TcYear = -1 then  // the Year is ubknown
     StudPiece[3] := '';  //We know it is field 3
   for i:=3 to pcnt do //check sex
   begin
     if studpiece[i]='' then continue;
     if ((uppercase(studpiece[i])=genderShort[0]{'M'}) or
        (uppercase(studpiece[i])=genderShort[1]{'F'})or (uppercase(studpiece[i])=genderShort[2]{'X'})) then  //mantis-1566.
         begin
          faStud.sex:=uppercase(studpiece[i]);
          studpiece[i]:=''; break; {don't reuse}
         end;
   end; {for i}
   for i:=3 to pcnt do  //check class
   begin
     if studpiece[i]='' then continue;
     k:=findClass2(studpiece[i]);
     if k>0 then
     begin
       faStud.TcClass:=k;
       studpiece[i]:=''; break; //don't reuse
     end;
   end; {for i}
   for i:=3 to pcnt do  //check house
   begin
     if studpiece[i]='' then continue;
     k:=findHouse2(studpiece[i]);
     if k>0 then
     begin
       faStud.house:=k;
       studpiece[i]:=''; break; //don't reuse
     end;
   end; {for i}
   for i:=3 to pcnt do //check tutor
   begin
     if studpiece[i]='' then continue;
     k:=findTutor2(studpiece[i]);
     if k>0 then
     begin
       faStud.tutor:=k;
       studpiece[i]:=''; break; //don't reuse
     end;
   end; //for i
   for i:=3 to pcnt do //check home
   begin
     if studpiece[i]='' then continue;
     k:=findRoom2(studpiece[i]);
     if k>0 then
     begin
       faStud.home:=k;
       studpiece[i]:=''; break; //don't reuse
     end;
   end; {for i}
   cci:=1;
   for i:=3 to pcnt do //check choices
   begin
     if studpiece[i]='' then continue;
     k:=findChoice3(studpiece[i]);
     if k>0 then
     begin
       faStud.choices[cci]:=k;
       studpiece[i]:=''; //don't reuse piece
       inc(cci);
       if cci>nmbrchoices then break;
     end;
   end; {for i}
   RemoveSubDuplicates;

   for i:=3 to pcnt do  {pick anything that's left as being an ID}
   begin
     if trim(studpiece[i])>'' then
     begin
       faStud.ID:=studpiece[i];
       studpiece[i]:=''; break; {don't reuse}
     end;
   end; {for i}
       //for i:=3 to pcnt do  {pick anything that's left as being an ID2}
    //begin
      if XML_DISPLAY.stID2 then
      begin
        if trim(studpiece[6])>'' then
        begin
          faStudID2 := studpiece[6];
          studpiece[6] := '';   //don't reuse
        end;
      end; // if
    //end;

    //for i:=3 to pcnt do  {pick anything that's left as being an Email}
    //begin
      if XML_DISPLAY.stEmail then
      begin
        if trim(studpiece[7])>'' then
        begin
          faStudEmail := studpiece[7];
          studpiece[7] := '';   //don't reuse
        end;
      end; // if
    //end;

   if (trim(faStud.Stname)>'') then {if surname, add other fields}
    begin
     if XML_DISPLAY.StudPasteAddSub and CanAddSubs then // undefined subject check
      for i:=3 to pcnt do
       begin
        if (cci>nmbrchoices) or (codeCount[0]>=nmbrsubjects) then break;
        codeStr:=uppercase(studpiece[i]);
        if codeStr='' then continue;
        ss:=copy(codeStr,1,2);
        if (ss='00') or (ss='NA') or (faStudID2 = codeStr) then continue; {only legit codes}
        k:=findChoice3(codeStr); if k>0 then continue; {existing code}
        if length(codeStr)>lencodes[0] then continue;
        FlexiPasteQueryDlg:=tFlexiPasteQueryDlg.create(application);   {allocate dlg}
        FlexiPasteQueryDlg.label2.caption:=codeStr;
        FlexiPasteQueryDlg.edit1.text:='';
        if FlexiPasteQueryDlg.showmodal=mrOK then  // add subject
         begin
          codePlace:=FindNextCode(0);  studpiece[i]:=''; {clear}
          Subcode[codePlace]:=codeStr;
          Subname[codePlace]:=trim(FlexiPasteQueryDlg.edit1.text);
          SubReportCode[codePlace]:=Subcode[codePlace];
          SubReportName[codePlace]:=Subname[codePlace];
          faStud.choices[cci]:=codePlace;  inc(cci);
          link[codePlace]:=0;
          InsertCode(0,codePlace);
          SubsAdded:=true;
         end;
        FlexiPasteQueryDlg.free;   {release dlg}
       end; {for i}
   {assign default sex if not specified}
   if faStud.Sex='' then
    if random(10)>4 then faStud.Sex:=genderShort[0]{'M'} else faStud.Sex:=genderShort[1]{'F'};
   {assign default year if not specified}
   if faStud.TcYear=-1 then
    faStud.TcYear:=getMinYearWithStuds;{faStud.TcYear;}
   {check if student already exists}

   if not(CheckUserYearPassAccess(faStud.TcYear)) then
    begin
     inc(CUPAcnt);
     exit;
    end;
   StudYearFlag[faStud.TcYear]:=true;
   fnm:=0;
   case XML_DISPLAY.StudPasteID of
    0: fnm:=findStudentByID(faStud.ID);                      //stud id
    1: fnm:=findStudentByNameAndYear(faStud.stname,faStud.first,faStud.TcYear);  //stud name and year
    2: fnm:=findThisStudent(faStud);   //using all fields
   end;
   {update or add student data}
   if fnm > 0 then
   begin {update existing stud}
     if XML_DISPLAY.StudPasteFields=0 then {update from new}
     begin
       if XML_STUDENTS.Stud[fnm].TcClass=0 then XML_STUDENTS.Stud[fnm].TcClass:=faStud.TcClass;
       if XML_STUDENTS.Stud[fnm].House=0 then XML_STUDENTS.Stud[fnm].House:=faStud.House;
       if trim(XML_STUDENTS.Stud[fnm].ID)='' then XML_STUDENTS.Stud[fnm].ID:=faStud.ID;
       if XML_STUDENTS.Stud[fnm].Tutor=0 then XML_STUDENTS.Stud[fnm].Tutor:=faStud.Tutor;
       if XML_STUDENTS.Stud[fnm].Home=0 then XML_STUDENTS.Stud[fnm].Home:=faStud.Home;

     end
     else
     begin
//       Stud[fnm].ID := faStud.ID;
//       Stud[fnm].TcClass := faStud.TcClass;
//       Stud[fnm].House := faStud.House;
//       Stud[fnm].Tutor := faStud.Tutor;
//       Stud[fnm].Home := faStud.Home;

         if (faStud.TcClass > 0) and (faStud.tcClass <> XML_STUDENTS.Stud[fnm].TcClass) then
           XML_STUDENTS.Stud[fnm].TcClass:=faStud.TcClass;

         if (faStud.House > 0) and (faStud.House <> XML_STUDENTS.Stud[fnm].House) then
           XML_STUDENTS.Stud[fnm].House:=faStud.House;

         if (faStud.ID > '') and (faStud.ID <> XML_STUDENTS.Stud[fnm].ID) then
           XML_STUDENTS.Stud[fnm].ID:=faStud.ID;

         if (faStud.Tutor > 0) and (faStud.Tutor <> XML_STUDENTS.Stud[fnm].Tutor) then
           XML_STUDENTS.Stud[fnm].Tutor:=faStud.Tutor;

         if (faStud.Home > 0) and (faStud.Home <> XML_STUDENTS.Stud[fnm].Home) then
           XML_STUDENTS.Stud[fnm].Home:=faStud.Home;
         //--------------//mantis-1566..-----------------------
          if (faStud.Sex > '') and (faStud.Sex <> XML_STUDENTS.Stud[fnm].Sex) then
           XML_STUDENTS.Stud[fnm].Sex:=faStud.Sex;
         //--------------//mantis-1566.-----------------------
     end;

     if trim(StudID2[fnm])='' then
       StudID2[fnm]:=faStudID2;

     if trim(StudEmail[fnm])='' then
       StudEmail[fnm]:=faStudEmail;

     case XML_DISPLAY.StudPasteSub of
      0: begin {replace choices}
          for i:=1 to nmbrChoices do
           begin
            if (faStud.choices[i] > 0) and (faStud.choices[i] <> XML_STUDENTS.Stud[fnm].Choices[i]) then
              XML_STUDENTS.Stud[fnm].Choices[i]:=faStud.choices[i];
            if faStud.choices[i]>0 then
               if i>chmax then chmax:=i;
           end;
         end;
       //add to existing choices as needed - do not create duplicates!
      1: begin {add to choices}
          for i:=1 to nmbrChoices do
           begin
            if faStud.choices[i]=0 then continue;
            j:=0; k:=0;
            for m:=1 to nmbrChoices do
             begin
              if XML_STUDENTS.Stud[fnm].Choices[m]=0 then if j=0 then j:=m;  //remember first free spot
              if XML_STUDENTS.Stud[fnm].Choices[m]=faStud.choices[i] then begin k:=1; break; end; //subject already in stud's choices - move on
             end; {for m}
             if k=0 then //sub not yet in stud's choices
              if j<>0 then  //and there's a free spot
               begin
                XML_STUDENTS.Stud[fnm].Choices[j]:=faStud.choices[i];
                if j>chmax then chmax:=j;
               end;
           end; {for i}
         end;
     end; {case}
   end
   else
   begin {add new stud}
     if XML_STUDENTS.Numstud < nmbrStudents then
     begin
      fnm:=XML_STUDENTS.NumStud+1;
      XML_STUDENTS.NumStud:=fnm;
      SetStArrays;
      StudSort[fnm]:=fnm;

      XML_STUDENTS.Stud[fnm]:=faStud;

      //if (CustomerIDnum=cnMountainCreekSHS) then // only for MOUNTAIN CREEK STATE HIGH SCHOOL
      begin
       studID2[fnm]:=faStudID2;
       studEmail[fnm]:=faStudEmail;
      end;

      for i:=1 to nmbrChoices do
       if faStud.choices[i]>0 then
        if i>chmax then chmax:=i;

      XML_STUDENTS.Stud[fnm].tctag:=0;
      resetstudentorder(fnm);
     end; {if (Numstud<nmbrStudents) then}
   end;
   end; {non blank name}
  end; {getStudClipCell}

begin     {main parseClipStudentText}
 CUPAcnt:=0;  SubsAdded:=false;
// count how many lines for status display
 tmpGenText:=genText; tmpI:=1;
 tmpJ:=pos(cr,tmpGenText);
 while tmpJ>0 do
 begin
  inc(tmpI);
  tmpGenText:=copy(tmpGenText,tmpJ+1,length(tmpGenText));
  tmpJ:=pos(cr,tmpGenText);
 end;
// tmpI now has count of lines coming in

//ensure subcodes in sort by codes else change for bin search
 oldSorttype:=1;
 if XML_DISPLAY.sorttype[0]<>oldSorttype then
 begin
  oldSorttype:=XML_DISPLAY.sorttype[0];
  XML_DISPLAY.sorttype[0]:=1;
  sortcodes(0)
 end;

 tmpJ:=0;
 while genText<>'' do
 begin
  getStudClipCell;
  inc(tmpJ);
  if (genText>'') and ((genText[1]=cr) or (genText[1]=lf)) then
  begin
   genText:=copy(genText,2,length(genText));
  end;
  tmpK:=trunc((100*tmpJ)/tmpI);
  if tmpK>100 then tmpK:=100;
// show status to show it hasn't hung ...
   MainForm.stbTimeChart.Panels[0].Text := IntToStr(tmpK)+'% pasted ...';
 end;

 MainForm.stbTimeChart.Panels[0].Text := 'Finished pasting';

//restore sorttype if changed
 if XML_DISPLAY.sorttype[0]<>oldSorttype then
 begin
  XML_DISPLAY.sorttype[0]:=oldSorttype;
  sortcodes(0)
 end;
 UpdateStudCalcs;
 SaveAllStudentYears;
 if SubsAdded then
  begin
   getCodeFontWidths(0);
   AlterTimeFlag:=True;  AlterWSflag:=true;
   if NumSubRepCodes>0 then NumSubRepCodes:=NumCodes[0];
   updatesub(0);
  end;
 if (CUPAcnt>0) then
 begin
  msg:=inttostr(CUPAcnt)+' students were skipped'+endline;
  msg:=msg+'as you do NOT currently have access to change'+endline;
  msg:=msg+'the student data for the relevant '+yeartitle+'(s)';
  messagedlg(msg,mtWarning,[mbOK],0);
 end;
end;

procedure TStudentListWin.Paste1Click(Sender: TObject);
var
  CanPaste: Boolean;
  lIsDeleteAll: Boolean;
  lUserAction: Integer;
  function DeleteAllStudents: Boolean;
  var
    i: Integer;
  begin
    for i := 1 to XML_STUDENTS.NumStud do
      RemoveStudent(i);
    Result := True;
  end;

begin
 if CheckAccessRights(utStud,35,true) then
  begin
   CanPaste:=false;
   CanAddSubs:=SilentCheckAccessRights(utStud,6,true);
   FlexiPasteDlg:=tFlexiPasteDlg.create(self);   {allocate dlg}
   if not(CanAddSubs) then FlexiPasteDlg.CheckBox1.Visible:=false;
   if FlexiPasteDlg.showmodal=mrOK then
     CanPaste := True;
   lIsDeleteAll := FlexiPasteDlg.IsDeleteOK;
   FlexiPasteDlg.Free;   {release dlg}
   if CanPaste then
    begin
     if not(Clipboard.HasFormat(CF_TEXT)) then exit;
     try
      screen.cursor:=crHourglass;
      if lIsDeleteAll then
      begin
        if DeleteAllStudents Then
          UpdateStudCalcs;
      end;

      MainForm.stbTimeChart.Panels[0].Text := '0% pasted ...';
      lUserAction := mrOk;
      if GetNonExistingYears > 0 then
        lUserAction := MessageDlg(Format('Some of the student records contain %ss that are not configured in the system. These students will be added to the lowest %s that have students.', [YearTitle, YearTitle]), mtConfirmation, mbOKCancel, 0);
      if lUserAction <> mrCancel then
      begin
        GetTextFromClipboard(CF_TEXT); //get clip text
        ParseClipStudentText;
        Updateallwins;
      end;
     finally
       screen.Cursor := crDefault;
     end;
    end;
   SilentCheckAccessRights(utStud,6,false);
   CheckAccessRights(utStud,35,false);
  end;
end;

procedure TStudentListWin.Edit1Click(Sender: TObject);
var
 clpDatType1,clpDatType2: smallint;
 ok:         wordbool;
begin
  clpDatType1:=0;  clpDatType2:=0;  ok:=true;
  if Clipboard.HasFormat(CF_TEXT) then clpDatType1:=1;
  if Clipboard.HasFormat(CF_AMIG_Block_Data) then clpDatType2:=1;
  if Clipboard.HasFormat(CF_AMIG_Timetable_Data) then clpDatType2:=2;
  if Clipboard.HasFormat(CF_AMIG_Student_Data) then clpDatType2:=3;
  if clpDatType2=1 then ok:=false; {don't paste blocks}
  if clpDatType2=2 then ok:=false; {don't paste ttable entries}
  if clpDatType1=0 then ok:=false; {don't paste non text}
  paste1.enabled:=ok;
end;

procedure TStudentListWin.FormDeactivate(Sender: TObject);
begin
 copy1.ShortCut:=ShortCut(0,[]);
 paste1.ShortCut:=ShortCut(0,[]);
end;

procedure TStudentListWin.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key  = Ord('S') then
  begin
    if MessageDlg('Time Chart will export the Student classes in a special format file. Are you sure you want to proceed?', mtConfirmation, mbYesNo, 0) = mrYes then
      StudentlistOut(True);
  end;
end;

procedure TStudentListWin.FormActivate(Sender: TObject);
begin
 copy1.ShortCut:=ShortCut(Word('C'),[ssCtrl]);
 paste1.ShortCut:=ShortCut(Word('V'),[ssCtrl]);
end;

end.
