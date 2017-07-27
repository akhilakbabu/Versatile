unit Subbyslt;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Menus,ClassDefs,TimeChartGlobals,GlobalToTcAndTcextra,
  XML.DISPLAY, XML.TEACHERS, XML.STUDENTS;

type
  TSubByTimeSlotWin = class(TStudListWin)
    PopupMenu1: TPopupMenu;
    TimeSlot2: TMenuItem;
    N2: TMenuItem;
    PrintSetup1: TMenuItem;
    Print1: TMenuItem;
    StudentTimetable1: TMenuItem;
    Copy1: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TimeSlot2Click(Sender: TObject);
    procedure Print1Click(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure StudentTimetable1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  protected
    procedure SetTabs; override;
    procedure GetLists; override;
    procedure GetListContents(i: integer); override;
    procedure PaintHead;  override;
    procedure ListHead(i:integer);  override;
  end;

var
  SubByTimeSlotWin: TSubByTimeSlotWin;

procedure subbytimeslotprint;
procedure subbytimeslotOut;

implementation
uses tcommon,StCommon,sbtsdlg,main,printers,tcommon2;
{$R *.DFM}

type TPrintTimeList=class(TPrintStudListWin)
  public
   procedure head; override;
   procedure SetTabs; override;
   procedure GetLists; override;
   procedure GetListContents(i: integer); override;
   procedure ListHead(i:integer); override;
 end;

type TOutTimeList=class(TOutStudListWin)
  public
   procedure head; override;
   procedure SetTabs;
   procedure GetLists; override;
   procedure GetListContents(i: integer); override;
   procedure ListHead(i:integer); override;
 end;

var
 PrintTimeList:    TPrintTimeList;
 OutTimeList:  TOutTimeList;
 order:   tpSubData;
 ordernum:  integer;
 maxStnum:  integer;


procedure studentsinperiodsizes(p: integer);
var
 L,Y,D,A,B:          integer;
 aFnt:                          tpintpoint;
 yya,yyb:                              smallint;
begin
 D:=XML_DISPLAY.sublistday;
 ordernum:=0; maxStnum:=0;
 if XML_DISPLAY.sublistfree=2 then begin yya:=0; yyb:=years_minus_1; end
   else begin yya:=XML_DISPLAY.sublistYear;
 yyb:=XML_DISPLAY.sublistYear; end;
 for Y:=yya to yyb do
  begin
   aFnt:=FNT(D,P,Y,0,0);
   for L:=1 to level[Y] do
   begin
    inc(aFnt,4); a:=aFnt^;
    if ((a>0) and (a<=LabelBase)) then
    begin
     inc(ordernum);
     order[ordernum]:=a;
     b:=GroupSubCount[GsubXref[a]];
     if b>maxStnum then maxStnum:=b;
    end;
   end; {for L}
  end; {for Y}
end;

Function StudFree(i:integer): boolean;
var
 j,k,a: integer;
 found: boolean;
begin
 found:=false;
 for j:=1 to chmax do
  begin
   a:=XML_STUDENTS.Stud[i].choices[j];
   if a<>0 then
    for k:=1 to ordernum do
     if order[k]=a then begin found:=true; break; end;
   if found then break;
  end; {for j}
 result:=not(found);
end;

procedure findSubSlotTeacher(var tc,rc:integer; p,snu: integer);
var
 L: integer;
 fntA:    tpintpoint;
begin
 tc:=0;  rc:=0;
 for L:=1 to level[XML_DISPLAY.sublistYear] do
  begin
   fntA:=FNT(XML_DISPLAY.sublistday,P,XML_DISPLAY.sublistYear,L,0);
   if fntA^=snu then
    begin
     inc(fntA); tc:=fntA^;
     inc(fntA); rc:=fntA^;
     break;
    end;
  end; {for L}
end; {end of local proc}


Procedure GeneralListContents(i,size,myset:integer;var Contents: array of integer);
var
 j,count: integer;
begin
 count:=0;
 if Size=0 then exit;
 studentsinperiodsizes(myset);
 for j:= 1 to groupnum do
  if StudFree(StPointer[j]) then
   begin inc(count); Contents[count]:=StPointer[j]; end;
end;


procedure TSubByTimeSlotWin.GetListContents(i:integer);
begin
 SetLength(ListContents,ListSize[i]+1);
 GeneralListContents(i,ListSize[i],ListSet[i],ListContents);
end;

procedure TSubByTimeSlotWin.GetLists;
var
 i,p,j,count: integer;
begin
 if XML_DISPLAY.sublisttime1>XML_DISPLAY.sublisttime2 then swapint(XML_DISPLAY.sublisttime1,XML_DISPLAY.sublisttime2);
 NumOfLists:=1+XML_DISPLAY.sublisttime2-XML_DISPLAY.sublisttime1; SetArraySizes;
 for j:=1 to NumOfLists do
  begin
   p:=j-1+XML_DISPLAY.sublisttime1;
   ListSet[j]:=p;
   studentsinperiodsizes(p);
   count:=0;
   for i:= 1 to groupnum do
    if StudFree(StPointer[i]) then inc(count);
   ListSize[j]:=count;
  end;
end;


procedure TSubByTimeSlotWin.SetTabs;
begin
 studentPointerSet;
 caption:='Students in Time Slot - '+groupname;
  codeColor:=cpStList;
 if XML_DISPLAY.sublistfree>0 then
  begin
   ListType:=1; EnrolFlag:=false;
   ListHeadLines:=1;
   {1 - student list  2- numbers}
   ShowZeroList:=true;
   GetLists;
   CalcArrayTops;
   RedoSelection;
  end
 else begin ListType:=0; SelCode:=0; end;
end;

procedure TSubByTimeSlotWin.PaintHead;
begin
 fcolor(cpNormal);
 case XML_DISPLAY.sublistfree of
  1,2: printw('Students Free');
 end;
 newline;
end;

procedure TSubByTimeSlotWin.ListHead(i:integer);
var
 astr: string;
begin
 astr:=TimeSlotName[XML_DISPLAY.sublistday,ListSet[i]];
 fcolor(cpNormal);
 case XML_DISPLAY.sublistfree of
  1:printwl('Students Not in '+yeartitle+yearname[XML_DISPLAY.sublistYear]+' subjects - '+dayname[XML_DISPLAY.sublistday]+' '+astr);
  2:printwl('Students Not in - '+dayname[XML_DISPLAY.sublistday]+' '+astr);
 end;
end;


procedure TSubByTimeSlotWin.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 action:=caFree;
end;

procedure TSubByTimeSlotWin.TimeSlot2Click(Sender: TObject);
begin
 SubjectsByTimeSlotDlg:=TSubjectsByTimeSlotDlg.create(self);
 SubjectsByTimeSlotDlg.showmodal;
 SubjectsByTimeSlotDlg.free;
end;


procedure TSubByTimeSlotWin.Print1Click(Sender: TObject);
begin
 printOurWindow(self.tag);
end;

procedure TSubByTimeSlotWin.FormPaint(Sender: TObject);

 procedure showstudenttimes;
 var
  tc,rc,su:   integer;
  p,I,I1,j,k,a:       integer;
  found2:              bool;
  count,tcount,scount:              integer;
  maxOrdernum:                      integer;
  colwidth:                  integer;
  oldy:                      integer;
 begin
  colwidth:=fwcode[0]+fwcode[1]+fwcode[2]+blankwidth*3;
  i:=fwstname+blankwidth;
  if i>colwidth then colwidth:=i;
  tcount:=0;  maxOrdernum:=0;
  for p:=XML_DISPLAY.sublisttime1 to XML_DISPLAY.sublisttime2 do
  begin
   count:=0;
   studentsinperiodsizes(p);
   if ordernum>maxOrdernum then maxOrdernum:=ordernum;
   fcolor(cpNormal);
    if ordernum>0 then
     printw('Students in '+yeartitle+yearname[XML_DISPLAY.sublistYear]+' subjects - '
              +dayname[XML_DISPLAY.sublistday]+' '+TimeSlotName[XML_DISPLAY.sublistday,p])
    else
     printw('No '+yeartitle+yearname[XML_DISPLAY.sublistYear]+' Subjects at '
              +dayname[XML_DISPLAY.sublistday]+' '+TimeSlotName[XML_DISPLAY.sublistday,p]);
   newline;
   oldy:=y;
   if ordernum>0 then
     for k:=1 to ordernum do
     begin
      su:=order[k];  scount:=0;
      x:=(k-1)*colwidth;
      y:=oldy; fcolor(cpNormal);
      findSubSlotTeacher(tc,rc,p,su);
      printw(SubCode[su]+' '+XML_TEACHERS.tecode[tc,0]+' '+XML_TEACHERS.tecode[rc,1]); newline;
      for i1:=1 to groupnum do
      begin
       i:=StPointer[i1]; found2:=false;
       for j:=1 to chmax do
       begin
        a:=XML_STUDENTS.Stud[i].choices[j];
        if a<>0 then
        begin
         if a=su then
         begin
          found2:=true; break;
         end;
        end;
       end; {for j}
       if found2 then
       begin
        fcolor(codecolor); inc(scount);
        x:=(k-1)*colwidth;
        printw(XML_STUDENTS.Stud[i].stname+' '+XML_STUDENTS.Stud[i].first); newline;
       end; {if found}
      end; {for i1}
      fcolor(cpNormal); x:=(k-1)*colwidth;
      printw(SubCode[su]+'='+inttostr(scount));
      if scount>count then count:=scount;
      newline; newline;
     end; {for k}
   y:=oldy+(count+3)*txtheight;
   inc(tcount,count);
  end; {for p}

  maxH:=(2+tcount+(XML_DISPLAY.sublisttime2-XML_DISPLAY.sublisttime1+1)*4)*txtheight;
  if maxH>maxWinScrollRange then maxH:=maxWinScrollRange;
  vertscrollbar.range:=maxH;
  maxW:=(maxOrdernum)*colwidth+2*hmargin;
  if maxW>maxWinScrollRange then maxW:=maxWinScrollRange;
  horzscrollbar.range:=maxW;
 end;


begin   {start of main paint proc}
 if XML_DISPLAY.sublistfree=0 then showstudenttimes;
end;


{----------------          print procs follow         -----------------------}

procedure TPrintTimeList.head;
begin
 UnderlineOn;
 fcolor(cpNormal);
 printwl('Students in Time Slot '+GroupCaption);
 printw(PageCount);
 UnderlineOff;
 x:=0; y:=y+PrnttxtHeight;
end;


procedure TPrintTimeList.ListHead(i:integer);
var
 astr: string;
begin
 astr:=TimeSlotName[XML_DISPLAY.sublistDay,ListSet[i]];
 fcolor(cpNormal);
 case XML_DISPLAY.sublistfree of
  1:printwl('Students Not in '+yeartitle+yearname[XML_DISPLAY.sublistYear]+' subjects - '+dayname[XML_DISPLAY.sublistday]+' '+astr);
  2:printwl('Students Not in - '+dayname[XML_DISPLAY.sublistday]+' '+astr);
 end;
end;


procedure TPrintTimeList.GetLists;
var
 i: integer;
begin
 NumOfLists:=SubByTimeSlotWin.NumOfLists;
 SetArraySizes;
 if NumOfLists>0 then
  for i:=1 to NumOfLists do
   begin
    ListSize[i]:=SubByTimeSlotWin.ListSize[i];
    ListSet[i]:=SubByTimeSlotWin.ListSet[i];
   end;
end;

procedure TPrintTimeList.GetListContents(i: integer);
begin
 SetLength(ListContents,ListSize[i]+1);
 GeneralListContents(i,ListSize[i],ListSet[i],ListContents);
end;

procedure TPrintTimeList.SetTabs;
begin
 codeColor:=cpStList;
 if XML_DISPLAY.sublistfree>0 then
  begin
   ListType:=1; EnrolFlag:=false;
   {1 - student list  2- numbers}
   ShowZeroList:=true;
   GetLists;
   CalcHeights;
  end
 else ListType:=0;
end;


procedure subbytimeslotprint;

    procedure studPer;
    var
     lc,lp,listpoint,te,ro: array[0..nmbrLevels] of smallint;
     k,MyStud,i1,i2,D,P,Y1,L:  smallint;
     colwidth,a,b,nu,pas,E,F,G,i,j,m:   smallint;
     aFnt,bfnt:                          tpintpoint;
     entry: smallint;

       procedure nextStudent;
       var
        j1:      integer;
       label topit;
       begin
       topit:
        inc(listpoint[k]);
        a:=0; if listpoint[k]>groupnum then exit;
        MyStud:=StGroup[listpoint[k]];
        for j1:=1 to chmax do
        begin
         b:=XML_STUDENTS.Stud[MyStud].choices[j1];
         if b=0 then continue;
         if b=lc[k] then
         begin
          a:=MyStud;
          inc(lp[k]);
          break;
         end;
        end; {for j1}
        if a=0 then goto topit;
       end;



    begin {studper}
     with PrintTimeList do
      begin
       for i:=1 to nmbrLevels do
       begin  {inits}
        lc[i]:=0; lp[i]:=0; listpoint[i]:=0; te[i]:=0; ro[i]:=0;
       end;

       M:=0;
       FOR I:=1 TO NumCodes[0] do
       begin
        A:=GroupSubCount[GsubXref[i]]; IF A>M THEN M:=A;
       end;

       colwidth:=fwprntcode[0]+fwprntcode[1]+fwprntcode[2]+prntblankwidth*3;
       i:=fwprntstname+prntblankwidth;
       if i>colwidth then colwidth:=i;

       for p:=XML_DISPLAY.sublisttime1 to XML_DISPLAY.sublisttime2 do
       begin
        fcolor(cpNormal);
        UnderlineOn;
        printw('Students in '+yeartitle+yearname[XML_DISPLAY.sublistYear]+' subjects - '
                      +dayname[XML_DISPLAY.sublistday]+' '+TimeSlotName[XML_DISPLAY.sublistday,p]);
        UnderlineOff;   newline;
        j:=0;
        for L:=1 to Level[XML_DISPLAY.sublistYear] do
        begin
         Y1:=XML_DISPLAY.sublistYear;
         D:=XML_DISPLAY.sublistday;
         aFnt:=FNT(D,P,Y1,L,0);  a:=afnt^;
         if (a>0) and (a<LabelBase) then
         begin
          lc[j]:=a; inc(afnt); te[j]:=afnt^; inc(afnt); ro[j]:=afnt^; inc(j);
         end;
        end; {for L}
        nu:=J-1;
        for i1:=0 to level[XML_DISPLAY.sublistYear] do listpoint[i1]:=0;
        if nu=-1 then
        begin
         printw('No subjects in this time.');
         continue; {next p}
        end;
        for i2:=0 to level[XML_DISPLAY.sublistYear] do lp[i2]:=0;
        pas:=1+nu div 5; E:=5; F:=125; G:=25;
        for i:=1 to pas do
        begin
         for j:=0 to e-1 do
         begin
          fcolor(cpNormal);
          k:=e*i+j-e;
          if k<=nu then
            printw(SubCode[lc[k]]+' '+XML_TEACHERS.tecode[te[k],0]+' '+XML_TEACHERS.tecode[ro[k],1]);
          inc(x,colwidth);
         end; {for j}
         newline;
         for L:=0 to m-1 do
         begin
          entry:=0;
          for j:=0 to e-1 do
          begin
           k:=e*i+j-e;
           nextstudent;
           if ((a>0) and (k<=nu)) then
           begin
            fcolor(codeColor);
            printw(XML_STUDENTS.Stud[a].stname+' '+XML_STUDENTS.Stud[a].first);
            entry:=-1;
           end;
           inc(x,colwidth);
          end; {for j}
          if bool(entry) then newline;
         end; {for L}
         newline; fcolor(cpNormal); printw('Totals:'); newline;
         for j:=0 to e-1 do
         begin
          k:=e*i+j-e;
          if k<=nu then printw(SubCode[lc[k]]+'='+inttostr(lp[k]));
          inc(x,colwidth);
         end; {for j}
         newline; newline;

        end; {for  i}
       end; {for p}
      end; {with PrintTimeList}
    end;





begin   {start of main paint proc}
 PrintTimeList:=TPrintTimeList.Create;
 PrintTimeList.DoHeader := XML_DISPLAY.StHeadShow;
 with PrintTimeList do
  try
   SetTabs;
   if XML_DISPLAY.sublistfree=0 then
      begin
       header;
       studPer;
       printCustomAddon;
      end
   else ShowLists;
  finally
   PrintTimeList.free;
  end;
end;



{----------------     Text File Output procs follow         -----------------------}

procedure TOutTimeList.head;
begin
 printw('Students in Time Slot '+GroupCaption);
 newline;
end;


procedure TOutTimeList.ListHead(i:integer);
var
 astr: string;
begin
 astr:=TimeSlotName[XML_DISPLAY.sublistday,ListSet[i]];
 case XML_DISPLAY.sublistfree of
  1:printw('Students Not in '+yeartitle+yearname[XML_DISPLAY.sublistYear]+' subjects - '+dayname[XML_DISPLAY.sublistday]+' '+astr);
  2:printw('Students Not in - '+dayname[XML_DISPLAY.sublistday]+' '+astr);
 end;
 newline;
end;


procedure TOutTimeList.GetLists;
var
 i: integer;
begin
 NumOfLists:=SubByTimeSlotWin.NumOfLists;
 SetArraySizes;
 if NumOfLists>0 then
  for i:=1 to NumOfLists do
   begin
    ListSize[i]:=SubByTimeSlotWin.ListSize[i];
    ListSet[i]:=SubByTimeSlotWin.ListSet[i];
   end;
end;

procedure TOutTimeList.GetListContents(i: integer);
begin
 SetLength(ListContents,ListSize[i]+1);
 GeneralListContents(i,ListSize[i],ListSet[i],ListContents);
end;

procedure TOutTimeList.SetTabs;
begin
 if XML_DISPLAY.sublistfree>0 then
  begin
   ListType:=1; EnrolFlag:=false;
   {1 - student list  2- numbers}
   ShowZeroList:=true;
   GetLists;
   CalcTotalCount;
  end
 else ListType:=0;
end;


procedure subbytimeslotOut;

    procedure studPer;
    var
     lc,lp,listpoint,te,ro: array[0..nmbrLevels] of smallint;
     k,MyStud,i1,i2,D,P,Y1,L:  smallint;
     colwidth,a,b,nu,pas,E,F,G,i,j,m:   smallint;
     aFnt,bfnt:                          tpintpoint;
     entry: smallint;
     s: string;

       procedure nextStudent;
       var
        j1:      integer;
       label topit;
       begin
       topit:
        inc(listpoint[k]);
        a:=0; if listpoint[k]>groupnum then exit;
        MyStud:=StGroup[listpoint[k]];
        for j1:=1 to chmax do
        begin
         b:=XML_STUDENTS.Stud[MyStud].choices[j1];
         if b=0 then continue;
         if b=lc[k] then
         begin
          a:=MyStud;
          inc(lp[k]);
          break;
         end;
        end; {for j1}
        if a=0 then goto topit;
       end;



    begin {studper}
     with OutTimeList do
      begin
       for i:=1 to nmbrLevels do
       begin  {inits}
        lc[i]:=0; lp[i]:=0; listpoint[i]:=0; te[i]:=0; ro[i]:=0;
       end;

       M:=0;
       FOR I:=1 TO NumCodes[0] do
       begin
        A:=GroupSubCount[GsubXref[i]]; IF A>M THEN M:=A;
       end;

       for p:=XML_DISPLAY.sublisttime1 to XML_DISPLAY.sublisttime2 do
       begin
        printw('Students in '+yeartitle+yearname[XML_DISPLAY.sublistYear]+' subjects - '
                      +dayname[XML_DISPLAY.sublistday]+' '+TimeSlotName[XML_DISPLAY.sublistday,p]);
        newline;
        j:=0;
        for L:=1 to Level[XML_DISPLAY.sublistYear] do
        begin
         Y1:=XML_DISPLAY.sublistYear;
         D:=XML_DISPLAY.sublistday;
         aFnt:=FNT(D,P,Y1,L,0);  a:=afnt^;
         if (a>0) and (a<LabelBase) then
         begin
          lc[j]:=a; inc(afnt); te[j]:=afnt^; inc(afnt); ro[j]:=afnt^; inc(j);
         end;
        end; {for L}
        nu:=J-1;
        for i1:=0 to level[XML_DISPLAY.sublistYear] do listpoint[i1]:=0;
        if nu=-1 then
        begin
         printw('No subjects in this time.');
         continue; {next p}
        end;
        for i2:=0 to level[XML_DISPLAY.sublistYear] do lp[i2]:=0;
        pas:=1+nu div 5; E:=5; F:=125; G:=25;
        for i:=1 to pas do
        begin
         for j:=0 to e-1 do
         begin
          k:=e*i+j-e;
          if k<=nu then
           begin
            s:=SubCode[lc[k]]+' '+XML_TEACHERS.tecode[te[k],0]+' '+XML_TEACHERS.tecode[ro[k],1];
            if j=0 then printw(s) else printc(s);
           end;
         end; {for j}
         newline;
         for L:=0 to m-1 do
         begin
          entry:=0;
          for j:=0 to e-1 do
          begin
           k:=e*i+j-e;
           nextstudent;
           if ((a>0) and (k<=nu)) then
           begin
            s:=XML_STUDENTS.Stud[a].stname+' '+XML_STUDENTS.Stud[a].first;
            if j=0 then printw(s) else printc(s);
            entry:=-1;
           end;
          end; {for j}
          if bool(entry) then newline;
         end; {for L}
         newline; printw('Totals:'); newline;
         for j:=0 to e-1 do
         begin
          k:=e*i+j-e;
          if k<=nu then
          begin
           s:=SubCode[lc[k]]+'='+inttostr(lp[k]);
           if j=0 then printw(s) else printc(s);
          end;
         end; {for j}
         newline; newline;

        end; {for  i}
       end; {for p}
      end; {with OutTimeList}
    end;

begin   {start of main paint proc}
 OutTimeList := TOutTimeList.Create;
 OutTimeList.DoHeader := XML_DISPLAY.StHeadShow;
 with OutTimeList do
  try
   SetTabs;
   if XML_DISPLAY.sublistfree=0 then
      begin
       header;
       studPer;
       printCustomAddon;
      end
   else ShowLists;
  finally
   OutTimeList.free;
  end;
end;

procedure TSubByTimeSlotWin.StudentTimetable1Click(Sender: TObject);
begin
 ShowStudTt;
end;

procedure TSubByTimeSlotWin.PopupMenu1Popup(Sender: TObject);
begin
 StudentTimetable1.visible:=(selcode>0);
end;

procedure TSubByTimeSlotWin.FormCreate(Sender: TObject);
begin
 setWindowDefaults(self,wnTimeList)
end;

end.
