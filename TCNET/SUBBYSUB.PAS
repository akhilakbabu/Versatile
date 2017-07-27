unit Subbysub;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Menus,ClassDefs,TimeChartGlobals,XML.diSPLAY, XML.TEACHERS, XML.STUDENTS;

type
  TSubBySubjectWin = class(TStudListWin)
    PopupMenu1: TPopupMenu;
    Subject2: TMenuItem;
    N2: TMenuItem;
    PrintSetup1: TMenuItem;
    Print1: TMenuItem;
    StudentTimetable1: TMenuItem;
    ChangeStudent1: TMenuItem;
    N1: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Subject2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure StudentTimetable1Click(Sender: TObject);
    procedure ChangeStudent1Click(Sender: TObject);
  protected
    procedure SetTabs; override;
    procedure GetLists; override;
    procedure GetListContents(i: integer); override;
    procedure PaintHead;  override;
    procedure ListHead(i:integer);  override;
  end;

var
  SubBySubjectWin: TSubBySubjectWin;

procedure subbysubprint;
procedure subbysubOut;

implementation
uses subbsdlg,tcommon,StCommon,main,printers,tcommon2;
{$R *.DFM}

type TPrintSubList=class(TPrintStudListWin)
  public
   procedure head; override;
   procedure SetTabs; override;
   procedure GetLists; override;
   procedure GetListContents(i: integer); override;
   procedure ListHead(i:integer); override;
 end;

type TOutSubList=class(TOutStudListWin)
  public
   procedure head; override;
   procedure SetTabs;
   procedure GetLists; override;
   procedure GetListContents(i: integer); override;
   procedure ListHead(i:integer); override;
 end;


var
 PrintSubList:    TPrintSubList;
 OutSubList:    TOutSubList;
 ordernum: integer;
 order:  array[0..30] of integer;

function CheckStudInSplit(st:integer): boolean;
var
 j,k,a: integer;
 found: boolean;
begin
 found:=false;
 for j:=1 to chmax do
 begin
  a:=XML_STUDENTS.Stud[st].choices[j];
  if a<>0 then
  begin
   for k:=1 to ordernum do
   begin
    if a=order[k] then
    begin
     found:=true;
     break;
    end;
   end; {for k}
   if found then break;
  end;
 end; {for j}
 result:=found;
end;

function checkSubInFac(subI:integer):bool;
var
 i,k:  integer;
 f:      bool;
 aStr,bStr:   string;
begin
 f:=false;
 for i:=1 to faccount[XML_DISPLAY.sublistfacnum] do
 begin
  k:=facsubs[XML_DISPLAY.sublistfacnum,i];
  if k>0 then
  begin
   if facsubs[XML_DISPLAY.sublistfacnum,i]=GroupSubs[subI] then
   begin
    f:=true;
    break;
   end;
  end
  else
   begin
    aStr:=uppercase(trim(copy(subcode[abs(k)],1,lencodes[0]-1)));
    bStr:=uppercase(trim(copy(subcode[GroupSubs[subI]],1,lencodes[0]-1)));
    if aStr=bStr then
    begin
     f:=true;
     break;
    end;
   end;
 end; {for i}
 result:=f;
end;

procedure GetSplitOrder(su:integer);
var
 i,a: integer;
 astr,bstr: string;
begin
 aStr:=copy(SubCode[abs(su)],1,lencodes[0]-1); ordernum:=0;
  for i:=1 to GroupSubs[0] do
  begin
   a:=GroupSubs[i]; bStr:=copy(SubCode[a],1,lencodes[0]-1);
   if bstr=aStr then
   begin
    inc(ordernum); order[ordernum]:=a;
   end;
  end; {for i}
end;

function StudInGroupOfSubs(st:integer):boolean;
var
 count,j,k,a,b: integer;
 astr,bstr: string;
 found: boolean;
begin
 count:=0; found:=false;
  for k:=1 to XML_DISPLAY.sublistranges[0] do
   begin
    if XML_DISPLAY.sublistranges[k]<0 then
    begin
     aStr:=copy(subcode[abs(XML_DISPLAY.sublistranges[k])],1,lencodes[0]-1);
     for j:=1 to chmax do
      begin
       a:=XML_STUDENTS.Stud[st].choices[j];
       if a<>0 then
       begin
        bstr:=copy(subcode[a],1,lencodes[0]-1);
        if bstr=astr then
        begin
         inc(count); break;
        end;
       end;
      end; {for j}
    end
    else
     begin
       b:=XML_DISPLAY.sublistranges[k];
       for j:=1 to chmax do
       begin
        a:=XML_STUDENTS.Stud[st].choices[j];
        if a<>0 then
        begin
         if b=a then
         begin
          inc(count); break;
         end;
        end;
       end; {for j}
     end;
    if ((XML_DISPLAY.SubListGroupType=1) and (count>0)) then
      begin
       found:=true; break;
      end;
   end; {for k}
 if ((XML_DISPLAY.SubListGroupType=2) and (count=XML_DISPLAY.sublistranges[0])) then found:=true;
 result:=found;
end;

Procedure GeneralListContents(i,size,myset:integer;var Contents: array of integer);
var
 j,count: integer;

begin
 count:=0;
 if Size=0 then exit;
 case XML_DISPLAY.SubListType of
  1,2,4: begin {single list}
          for j:=1 to GroupNum do
           if CheckStudInSub(StPointer[j],myset) then
             begin inc(count); Contents[count]:=StPointer[j]; end;
         end;
  3: begin  {split sub}
      GetSplitOrder(XML_DISPLAY.sublistranges[-2]);
      if ordernum>0 then
         for j:=1 to GroupNum do
          if CheckStudInSplit(StPointer[j]) then
            begin inc(count); Contents[count]:=StPointer[j]; end;
     end;
  5: case XML_DISPLAY.SubListGroupType of
        1,2: begin  {any of}
              for j:=1 to GroupNum do
                if StudInGroupOfSubs(StPointer[j]) then
                 begin inc(count); Contents[count]:=StPointer[j]; end;
             end;
        3: begin {separate subjects}
            if myset<0 then GetSplitOrder(myset)
              else begin ordernum:=1; order[1]:=myset; end;
            for j:=1 to GroupNum do
              if CheckStudInSplit(StPointer[j]) then
                begin inc(count); Contents[count]:=StPointer[j]; end;
           end;
     end; {case}
 end;{case}
end;

procedure TSubBySubjectWin.GetListContents(i:integer);
begin
 SetLength(ListContents,ListSize[i]+1);
 GeneralListContents(i,ListSize[i],ListSet[i],ListContents);
end;

procedure TSubBySubjectWin.GetLists;
var
 i,j,a: integer;
 last,first: smallint;
begin
 NumOfLists:=1; SetArraySizes;
 case XML_DISPLAY.SubListType of
  1: begin {all subs-with students enrolled}
      NumOfLists:=GroupSubs[0];
      SetArraySizes;
      for i:=1 to NumOfLists do
       begin
        ListSize[i]:=GroupSubCount[i];
        ListSet[i]:=GroupSubs[i];
       end;
     end;
  2: begin {single sub}
      first:=GsubXref[XML_DISPLAY.sublistranges[-2]];
      last:=GsubXref[XML_DISPLAY.sublistranges[-1]];
      if last<first then swapint(last,first);
      NumOfLists:=1+last-first;
      SetArraySizes;
      a:=0;
      for i:=first to last do
       begin
        inc(a);
        ListSize[a]:=GroupSubCount[i];
        ListSet[a]:=GroupSubs[i];
       end;
     end;
  3: begin   {split sub}
      GetSplitOrder(XML_DISPLAY.sublistranges[-2]);
      if ordernum=0 then ListSize[1]:=0
       else
        begin
         a:=0;
         for i:=1 to GroupNum do
          if CheckStudInSplit(StPointer[i]) then inc(a);
         ListSize[1]:=a;
        end;
     end;
  4: begin  {fac subs}
      a:=0; NumOfLists:=0;
      for i:=1 to GroupSubs[0] do
       if checkSubInFac(i) then
        begin
         inc(a); NumOfLists:=a; SetArraySizes;
         ListSize[a]:=GroupSubCount[i];
         ListSet[a]:=GroupSubs[i];
        end;
     end;
  5: begin   {group of subs}
       case XML_DISPLAY.SubListGroupType of
        1,2: begin  {any of}
              a:=0;
              for j:=1 to GroupNum do
                if StudInGroupOfSubs(StPointer[j]) then inc(a);
              ListSize[1]:=a;
             end;
        3: begin {separate subjects}
            if XML_DISPLAY.sublistranges[0]>0 then
             begin
              NumOfLists:=XML_DISPLAY.sublistranges[0];  SetArraySizes;
              for i:= 1 to XML_DISPLAY.sublistranges[0] do
               begin
                 ListSet[i]:=XML_DISPLAY.sublistranges[i];
                 if ListSet[i]<0 then GetSplitOrder(ListSet[i])
                  else begin ordernum:=1; order[1]:=ListSet[i]; end;
                 a:=0;
                 for j:=1 to GroupNum do
                  if CheckStudInSplit(StPointer[j]) then inc(a);
                 ListSize[i]:=a;
               end;
             end;
           end;
       end;
     end;
   end; {case}
end;

procedure TSubBySubjectWin.SetTabs;
begin
 studentPointerSet;
 caption:='Subject List - '+groupname;
 ListType:=1;
 {1 - student list  2- numbers}
 codeColor:=cpStList; EnrolFlag:=false; ListHeadLines:=1;
 ShowZeroList:=not(XML_DISPLAY.fgsubBySubListZeroSkip);
 GetLists;
 CalcArrayTops;
 RedoSelection;
end;

procedure TSubBySubjectWin.PaintHead;
begin
 fcolor(cpNormal);
 printWl('Subject list for students in Group: '+groupname+' sorted by '+groupsortname[groupsort]);
 newline;
end;

procedure TSubBySubjectWin.ListHead(i:integer);
var
  te,ro,su,j: Integer;
  lFTc, lSTc: Integer;
  astr: string;

  function GetHeadingDetails: string;
  begin
    //findSubTeacher(te,ro,su);
    FindSubTeachers(lFTc, lSTc, ro, su);
    if (Trim(XML_TEACHERS.tename[lSTc,0]) <> '') and (lFTc <> lSTc) then
      Result := astr+subcode[su]+' '+Subname[su]+' - '+ XML_TEACHERS.tename[lFTc,0] + ' and ' + XML_TEACHERS.tename[lSTc,0] + ' - '+XML_TEACHERS.tecode[ro,1]
    else
      Result := astr+subcode[su]+' '+Subname[su]+' - '+XML_TEACHERS.tename[lFTc,0]+' - '+XML_TEACHERS.tecode[ro,1];
  end;

begin
 te:=0;ro:=0;
 astr:='Students choosing ';
 fcolor(cpNormal);
 case XML_DISPLAY.SubListType of
  1,2,4: begin {single list}
          su:=ListSet[i];
          printwl(GetHeadingDetails);
         end;
  3: begin  {split sub}
      if ordernum>0 then
       begin
        for j:=1 to ordernum do astr:=astr+SubCode[order[j]]+' ';
        printwl(astr);
       end;
     end;
  5: case XML_DISPLAY.SubListGroupType of
        1,2: begin  {any of}
              if XML_DISPLAY.SubListGroupType=1 then astr:=astr+'any of '
               else if XML_DISPLAY.SubListGroupType=2 then astr:=astr+'all of ';
              for j:=1 to XML_DISPLAY.sublistranges[0] do
                if XML_DISPLAY.sublistranges[j]<0 then
                 astr:=astr+copy(SubCode[abs(XML_DISPLAY.sublistranges[j])],1,lencodes[0]-1)+'* '
                  else astr:=astr+SubCode[XML_DISPLAY.sublistranges[j]]+' ';
              printwl(astr);
             end;
        3: begin {separate subjects}
            su:=ListSet[i];
            if su<0 then astr:=astr+copy(SubCode[abs(su)],1,lencodes[0]-1)+'* '
             else
              begin
               {findSubTeacher(te,ro,su);
                astr:=astr+subcode[su]+' '+Subname[su]+' - '+tename[te,0]+' - '+tecode[ro,1];}
                FindSubTeachers(lFTc, lSTc, ro, su);
                if (Trim(XML_TEACHERS.tename[lSTc,0]) <> '') and (lFTc <> lSTc) then
                  astr := astr+subcode[su]+' '+Subname[su]+' - '+ XML_TEACHERS.tename[lFTc,0] + ' and ' + XML_TEACHERS.tename[lSTc,0] + ' - '+XML_TEACHERS.tecode[ro,1]
                else
                  astr := astr+subcode[su]+' '+Subname[su]+' - '+XML_TEACHERS.tename[lFTc,0]+' - '+XML_TEACHERS.tecode[ro,1];
              end;
            printwl(astr);
           end;
     end; {case}
 end;{case}
end;

procedure TSubBySubjectWin.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 action:=caFree;
end;

procedure TSubBySubjectWin.Subject2Click(Sender: TObject);
begin
 SubjectBySubjectdlg:=TSubjectBySubjectdlg.create(self);
 SubjectBySubjectDlg.showmodal;
 SubjectBySubjectDlg.free;
end;

procedure TSubBySubjectWin.FormCreate(Sender: TObject);
begin
 caption:='Subject List'+GroupCaption;
 setWindowDefaults(self,wnSubjectList)
end;

{---------------------        print procs follow         --------------------}


procedure TPrintSubList.head;
begin
 UnderlineOn;
 printWl('Subject list for students in Group: '+groupname+' sorted by '+groupsortname[groupsort]);
 printw(PageCount);
 UnderlineOff;
 x:=0; y:=y+PrnttxtHeight;
 fcolor(cpNormal);
end;

procedure TPrintSubList.ListHead(i:integer);
var
  te,ro,su,j: integer;
  lFTc, lSTc: Integer;
  astr: string;

  function GetHeadingDetails: string;
  begin
    FindSubTeachers(lFTc, lSTc, ro, su);
    if (Trim(XML_TEACHERS.tename[lSTc,0]) <> '') and (lFTc <> lSTc) then
      Result := astr+subcode[su]+' '+Subname[su]+' - '+ XML_TEACHERS.tename[lFTc,0] + ' and ' + XML_TEACHERS.tename[lSTc,0] + ' - '+XML_TEACHERS.tecode[ro,1]
    else
      Result := astr+subcode[su]+' '+Subname[su]+' - '+XML_TEACHERS.tename[lFTc,0]+' - '+XML_TEACHERS.tecode[ro,1];
  end;

begin
 te:=0;ro:=0;
 astr:='Students choosing ';
 fcolor(cpNormal);
 case XML_DISPLAY.SubListType of
  1,2,4: begin {single list}
          su:=ListSet[i];
          //findSubTeacher(te,ro,su);
          //printwl(astr+subcode[su]+' '+Subname[su]+' - '+tename[te,0]+' - '+tecode[ro,1]);
          printwl(GetHeadingDetails);
         end;
  3: begin  {split sub}
      if ordernum>0 then
       begin
        for j:=1 to ordernum do astr:=astr+SubCode[order[j]]+' ';
        printwl(astr);
       end;
     end;
  5: case XML_DISPLAY.SubListGroupType of
        1,2: begin  {any of}
              if XML_DISPLAY.SubListGroupType=1 then astr:=astr+'any of '
               else if XML_DISPLAY.SubListGroupType=2 then astr:=astr+'all of ';
              for j:=1 to XML_DISPLAY.sublistranges[0] do
                if XML_DISPLAY.sublistranges[j]<0 then
                 astr:=astr+copy(SubCode[abs(XML_DISPLAY.sublistranges[j])],1,lencodes[0]-1)+'* '
                  else astr:=astr+SubCode[XML_DISPLAY.sublistranges[j]]+' ';
              printwl(astr);
             end;
        3: begin {separate subjects}
            su:=ListSet[i];
            if su<0 then astr:=astr+copy(SubCode[abs(su)],1,lencodes[0]-1)+'* '
             else
              begin
               //findSubTeacher(te,ro,su);
               //astr:=astr+subcode[su]+' '+Subname[su]+' - '+tename[te,0]+' - '+tecode[ro,1];
                FindSubTeachers(lFTc, lSTc, ro, su);
                if (Trim(XML_TEACHERS.tename[lSTc,0]) <> '') and (lFTc <> lSTc) then
                  astr := astr+subcode[su]+' '+Subname[su]+' - '+ XML_TEACHERS.tename[lFTc,0] + ' and ' + XML_TEACHERS.tename[lSTc,0] + ' - '+XML_TEACHERS.tecode[ro,1]
                else
                  astr := astr+subcode[su]+' '+Subname[su]+' - '+XML_TEACHERS.tename[lFTc,0]+' - '+XML_TEACHERS.tecode[ro,1];
              end;
            printwl(astr);
           end;
     end; {case}
 end;{case}
end;

procedure TPrintSubList.GetLists;
var
 i: integer;
begin
 NumOfLists:=SubBySubjectWin.NumOfLists;
 SetArraySizes;
 if NumOfLists>0 then
  for i:=1 to NumOfLists do
   begin
    ListSize[i]:=SubBySubjectWin.ListSize[i];
    ListSet[i]:=SubBySubjectWin.ListSet[i];
   end;
end;

procedure TPrintSubList.GetListContents(i: integer);
begin
 SetLength(ListContents,ListSize[i]+1);
 GeneralListContents(i,ListSize[i],ListSet[i],ListContents);
end;

procedure TPrintSubList.SetTabs;
begin
 studentPointerSet;
 ListType:=1;
 {1 - student list  2- numbers}
 codeColor:=cpStList; EnrolFlag:=false;
 ShowZeroList:=not(XML_DISPLAY.fgsubBySubListZeroSkip);
 GetLists;
 CalcHeights;
end;

procedure subbysubprint;
begin   {start of main paint proc}
 PrintSubList := TPrintSubList.Create;
 PrintSubList.DoHeader := XML_DISPLAY.StHeadShow;
 with PrintSubList do
  try
   SetTabs;
   ShowLists;
  finally
   PrintSubList.free;
  end;
end;
{---------------------        Text File Out procs follow         --------------------}


procedure TOutSubList.head;
begin
 printW('Subject list for students in Group: '+groupname+' sorted by '+groupsortname[groupsort]);
 newline;
end;

procedure TOutSubList.ListHead(i:integer);
var
  te,ro,su,j: integer;
  lFTc, lSTc: Integer;
  astr: string;

  function GetHeadingDetails: string;
  begin
    FindSubTeachers(lFTc, lSTc, ro, su);
    if (Trim(XML_TEACHERS.tename[lSTc,0]) <> '') and (lFTc <> lSTc) then
      Result := astr+subcode[su]+' '+Subname[su]+' - '+ XML_TEACHERS.tename[lFTc,0] + ' and ' + XML_TEACHERS.tename[lSTc,0] + ' - '+XML_TEACHERS.tecode[ro,1]
    else
      Result := astr+subcode[su]+' '+Subname[su]+' - '+XML_TEACHERS.tename[lFTc,0]+' - '+XML_TEACHERS.tecode[ro,1];
  end;

begin
 te:=0;ro:=0;
 astr:='Students choosing ';
 case XML_DISPLAY.SubListType of
  1,2,4: begin {single list}
          su:=ListSet[i];
          //findSubTeacher(te,ro,su);
          //printw(astr+subcode[su]+' '+Subname[su]+' - '+tename[te,0]+' - '+tecode[ro,1]);
          printw(GetHeadingDetails);
         end;
  3: begin  {split sub}
      if ordernum>0 then
       begin
        for j:=1 to ordernum do astr:=astr+SubCode[order[j]]+' ';
        printw(astr);
       end;
     end;
  5: case XML_DISPLAY.SubListGroupType of
        1,2: begin  {any of}
              if XML_DISPLAY.SubListGroupType=1 then astr:=astr+'any of '
               else if XML_DISPLAY.SubListGroupType=2 then astr:=astr+'all of ';
              for j:=1 to XML_DISPLAY.sublistranges[0] do
                if XML_DISPLAY.sublistranges[j]<0 then
                 astr:=astr+copy(SubCode[abs(XML_DISPLAY.sublistranges[j])],1,lencodes[0]-1)+'* '
                  else astr:=astr+SubCode[XML_DISPLAY.sublistranges[j]]+' ';
              printw(astr);
             end;
        3: begin {separate subjects}
            su:=ListSet[i];
            if su<0 then astr:=astr+copy(SubCode[abs(su)],1,lencodes[0]-1)+'* '
             else
              begin
               {findSubTeacher(te,ro,su);
               astr:=astr+subcode[su]+' '+Subname[su]+' - '+tename[te,0]+' - '+tecode[ro,1];}
               FindSubTeachers(lFTc, lSTc, ro, su);
               if (Trim(XML_TEACHERS.tename[lSTc,0]) <> '') and (lFTc <> lSTc) then
                 astr := astr+subcode[su]+' '+Subname[su]+' - '+ XML_TEACHERS.tename[lFTc,0] + ' and ' + XML_TEACHERS.tename[lSTc,0] + ' - '+XML_TEACHERS.tecode[ro,1]
               else
                 astr := astr+subcode[su]+' '+Subname[su]+' - '+XML_TEACHERS.tename[lFTc,0]+' - '+XML_TEACHERS.tecode[ro,1];

              end;
            printw(astr);
           end;
     end; {case}
 end;{case}
 newline;
end;

procedure TOutSubList.GetLists;
var
 i: integer;
begin
 NumOfLists:=SubBySubjectWin.NumOfLists;
 SetArraySizes;
 if NumOfLists>0 then
  for i:=1 to NumOfLists do
   begin
    ListSize[i]:=SubBySubjectWin.ListSize[i];
    ListSet[i]:=SubBySubjectWin.ListSet[i];
   end;
end;

procedure TOutSubList.GetListContents(i: integer);
begin
 SetLength(ListContents,ListSize[i]+1);
 GeneralListContents(i,ListSize[i],ListSet[i],ListContents);
end;

procedure TOutSubList.SetTabs;
begin
 studentPointerSet;
 ListType:=1;
 {1 - student list  2- numbers}
 EnrolFlag:=false;
 ShowZeroList:=not(XML_DISPLAY.fgsubBySubListZeroSkip);
 GetLists;
 CalcTotalCount;
end;

procedure subbysubOut;
begin   {start of main paint proc}
 OutSubList := TOutSubList.Create;
 OutSubList.DoHeader := XML_DISPLAY.StHeadShow;
 with OutSubList do
  try
   SetTabs;
   ShowLists;
  finally
   OutSubList.free;
  end;
end;

procedure TSubBySubjectWin.PopupMenu1Popup(Sender: TObject);
begin
 StudentTimetable1.visible:=(selcode>0);
end;

procedure TSubBySubjectWin.StudentTimetable1Click(Sender: TObject);
begin
 ShowStudTt;
end;

procedure TSubBySubjectWin.ChangeStudent1Click(Sender: TObject);
begin
 mainform.ChangeStudent1Click(Self);
end;

end.
