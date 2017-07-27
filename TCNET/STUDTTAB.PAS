unit Studttab;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Menus,ClassDefs,TimeChartGlobals, XML.UTILS,GlobalToTcAndTcextra,
  XML.DISPLAY, XML.TEACHERS, XML.STUDENTS;

type
  TSTtable = class(TListTtWin)
    PopupMenu1: TPopupMenu;
    Selection2: TMenuItem;
    N2: TMenuItem;
    PrintSetup1: TMenuItem;
    Print1: TMenuItem;
    Copy1: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Selection2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
  protected
    procedure SetTabs; override;
    procedure GetLists; override;
    procedure GetListContents(i: integer); override;
    procedure ShowTtItems(i,d,p,x1: integer); override;
    procedure ListHead(i,d:integer);  override;
    procedure ShowName(i:integer);  override;
    procedure WeeklyFooter(i:integer); override;
  private
    procedure StudTrackEnrolment(st:integer);
    procedure GetTrackCounts;
  end;

var
  STtable: TSTtable;

procedure studTtableprint;
procedure studTtableOut;

implementation
uses tcommon,main,stuttdlg,printers,tcommon2,stcommon,DateUtils;
{$R *.DFM}

type TPrintStudTtWin=class(TPrintListTtWin)
  public
   procedure head; override;
   procedure SetTabs; override;
   procedure GetLists; override;
   procedure GetListContents(i: integer); override;
   procedure ListHead(i,d:integer); override;
   procedure ShowName(i:integer);  override;
   procedure WeeklyFooter(i:integer); override;
   procedure ShowTtItems(i,d,p,x1: integer); override;
  private
    procedure StudTrackEnrolment(st:integer);
 end;

type TOutStudTtWin=class(TOutListTtWin)
  public
   procedure head; override;
   procedure SetTabs; override;
   procedure GetLists; override;
   procedure GetListContents(i: integer); override;
   procedure ListHead(i,d:integer); override;
   procedure ShowName(i:integer);  override;
   procedure WeeklyFooter(i:integer); override;
   procedure ShowTtItems(i,d,p: integer); override;
  private
    procedure StudTrackEnrolment(st:integer);
 end;


var
 PrintStudTtWin:    TPrintStudTtWin;
 OutStudTtWin:    TOutStudTtWin;
 TrackInUse,TrackLines: array[1..nmbrTrackSems] of smallint;
 TrackParts: array[1..2] of smallint;
 TrackCount:  smallint;


function findAnyStudentID(fasID:  string): smallint;
var
 i,k:  integer;
 s1,s2:  string;
begin
 k:=0;
 for i:=1 to XML_STUDENTS.numstud do
 begin
  {check id}
  s1:=Uppercase(trim(fasID));
  s2:=Uppercase(trim(XML_STUDENTS.Stud[i].ID));
  if (((s1>'') and (s2>'')) and (s1=s2)) then
  begin
   k:=i; {skip to next stud}
   break;
  end;
 end; {for i}
 result:=k;
end;


procedure LoadYearTrackingFile(CalYear,AcadYear,Sem,PstTrack:smallint);
var
 i,j:   integer;
 a,trkId:    string;
 fname: string;
 trkIDlen: smallint;
 su,te,count: smallint;
 TrckRecordSize: smallint;
 trkNumstud,trkChmax,trkStud: smallint;
 ourReadFileStream: TFileStream;
begin
 chdir(Directories.datadir);
 try
  fname:=trim(inttostr(CalYear));
  fname:=fname+trim(yearname[AcadYear]);
  fname:=fname+trim(inttostr(Sem));
  fname:=fname+'.ST';
  if not(fileexists(fname)) then exit;
  ourReadFileStream:=TFileStream.Create(fname,fmOpenRead);
  try
   with ourReadFileStream do
    begin
     TC4fileHeader:='1234';   ///TC4fileHeader:='TCV4';
     Read(Pchar(@TC4fileHeader[1])^,4);
     if TC4fileHeader<>'TCV4' then exit;

     Read(trkNumstud,2);
     Read(trkChmax,2);
     Read(trkIDlen,2);
     TrckRecordSize:=trkIDlen+trkchmax*4;
     a:=space(TrckRecordSize-10);
     dbgi:=length(a);
     Read(Pchar(@a[1])^,length(a));
     if trkNumstud>0 then
      for i:=1 to trkNumstud do
      begin
       trkId:=space(trkIDlen);
       if trkIDlen>0 then Read(Pchar(@trkId[1])^,trkIDlen);
       trkStud:=findAnyStudentID(trkId);    //search only on ID
       count:=0;
       for j:=1 to trkChmax do
       begin
        Read(su,2); Read(te,2);
        if su>0 then
         begin
          inc(count);
          StudTrack[trkStud].subs[PstTrack,count]:=su;
          StudTrack[trkStud].subs[PstTrack,0]:=count;
          StudTrack[trkStud].tes[PstTrack,count]:=te;
         end;
       end;

      end;
    end;
  finally
   ourReadFileStream.Free
  end;
 except
 end;
end;


procedure getTrackingData;
var
 y,curSem,curYear,trks: smallint;
 trkSem,trkYear:  smallint;
 i,j,k: integer;
begin
 setlength(StudTrack,2+XML_STUDENTS.numstud);
 for i:=1 to XML_STUDENTS.numstud do
  for j:=1 to nmbrTrackSems do
   for k:=0 to nmbrchoices do
    begin
     StudTrack[i].subs[j,k]:=0;
     StudTrack[i].tes[j,k]:=0;
    end;

 //if MonthOfTheYear(now)>6 then curSem:=2 else curSem:=1;
 curSem:= 4;

 curYear:=yearof(now);
 for y:=0 to years_minus_1 do
 begin
  trkSem:=curSem; trkYear:=curYear;
  for trks:=1 to nmbrTrackSems do
  begin
   dec(trkSem);
   if (trkSem<1) then
   begin
    dec(trkYear); trkSem:=4;
   end;
   LoadYearTrackingFile(trkYear,y,trkSem,trks);
  end; {for trks}
 end; {for y}
 HasStudTrackData:=true;
end;


procedure TSTtable.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 action:=caFree;
end;

procedure TSTtable.Selection2Click(Sender: TObject);
begin
 Studttabledlg:=TStudttabledlg.create(self);   {allocate dlg}
 Studttabledlg.showmodal;
 Studttabledlg.free;
end;



Procedure GeneralListContents(i,size,myset:integer;var Contents: array of integer);
var
 j,count: integer;
begin
 count:=0;
 if Size=0 then exit;
 case XML_DISPLAY.StudTtListType of
  1: for j:=1 to size do Contents[j]:=XML_DISPLAY.studentttselection[j];
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


procedure TSTtable.GetListContents(i:integer);
begin
 SetLength(ListContents,ListSize[i]+1);
 GeneralListContents(i,ListSize[i],ListSet[i],ListContents);
end;

procedure TSTtable.GetLists;
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
 if XML_DISPLAY.StudTtListType>2 then
   begin
    for i:=1 to groupnum do
    begin
     i2:=StPointer[i];
     case XML_DISPLAY.StudTtListType of
      3: inc(verify[XML_STUDENTS.Stud[i2].Tcclass]);
      4: inc(verify[XML_STUDENTS.Stud[i2].house]);
      5: inc(verify[XML_STUDENTS.Stud[i2].tutor]);
      6: inc(verify[XML_STUDENTS.Stud[i2].home]);
     end; {case}
    end; {for i}
    case XML_DISPLAY.StudTtListType of
     3: for i:=1 to classnum do AddInUse(RollClasspoint[i]);
     4: for i:=1 to HouseCount do AddInUse(i);
     5: for i:=1 to codeCount[1] do AddInUse(codepoint[i,1]);
     6: for i:=1 to codeCount[2] do AddInUse(codepoint[i,2]);
    end; {case}

 end; {if StudTtListType>2 }
 NumOfLists:=1; SetArraySizes;
 case XML_DISPLAY.StudTtListType of
  1: ListSize[1]:=XML_DISPLAY.studentttselection[0];
  2: ListSize[1]:=GroupNum;
  3..6: if XML_DISPLAY.stuttlistvals[XML_DISPLAY.StudTtListType]=0 then
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
         ListSet[1]:=XML_DISPLAY.stuttlistvals[XML_DISPLAY.StudTtListType];
         ListSize[1]:=verify[XML_DISPLAY.stuttlistvals[XML_DISPLAY.StudTtListType]];
        end;
 end;{case}
end;


procedure TSTtable.GetTrackCounts;
var
 i,j,k,st,a,count: integer;
begin
 for i:=1 to nmbrTrackSems do
  begin
   TrackInUse[i]:=0; TrackLines[i]:=0;
  end;

 if NumOfLists>0 then
  for i:=1 to NumOfLists do
   if ListSize[i]>0 then
    begin
     GetListContents(i);
     for j:=1 to ListSize[i] do
      begin
       st:=ListContents[j];
       for k:=1 to nmbrTrackSems do
        begin
         count:=StudTrack[st].subs[k,0];
         if count>TrackLines[k] then TrackLines[k]:=count;
        end; {k}
      end; {j}
    end;{i}
 TrackCount:=0;
 for i:=1 to 2 do TrackParts[i]:=0;
 for i:=1 to nmbrTrackSems do
  if TrackLines[i]>0 then
   begin
    inc(TrackCount); TrackInUse[TrackCount]:=i;
   end;
 if TrackCount>0 then TrackParts[1]:=TrackLines[TrackInUse[1]];
 if TrackCount>1 then
  begin
   a:=TrackLines[TrackInUse[2]];
   if a>TrackParts[1] then TrackParts[1]:=a;
  end;
 if TrackCount>2 then TrackParts[2]:=TrackLines[TrackInUse[3]];
 if TrackCount>3 then
  begin
   a:=TrackLines[TrackInUse[4]];
   if a>TrackParts[2] then TrackParts[2]:=a;
  end;
end;



procedure TSTtable.ShowName(i:integer);
begin
 if listtype=1 then showstudentname(i)
  else printw(GetStudentName(i));
end;


procedure TSTtable.ListHead(i,d:integer);
var
 s:string;
 j: integer;
begin
 if listtype=1 then s:=dayname[d]+' for ' else s:='For ';
 j:=ListSet[i];
  case XML_DISPLAY.StudTtListType of
   1: s:=s+'Student selection';
   2: s:=s+'Group '+groupname;
   3: s:=s+'Class '+ClassCode[j];
   4: s:=s+'House '+HouseName[j];
   5: begin
       s:=s+'Tutor '+XML_TEACHERS.tecode[j,0];
       if trim(XML_TEACHERS.tename[j,0])>'' then s:=s+' ('+XML_TEACHERS.tename[j,0]+')';
      end;
   6: begin
       s:=s+'Room '+XML_TEACHERS.tecode[j,1];
       if trim(XML_TEACHERS.tename[j,1])>'' then s:=s+' ('+XML_TEACHERS.tename[j,1]+')';
      end;
  end; {case}
  printw(s);   newline;
end;

procedure TSTtable.ShowTtItems(i,d,p,x1: integer);
var
 te,sc,ro,gotyear,lev,offset: integer;
 itemTt1,itemTt2,itemTt3: string;
begin
 sc:=0;
 GetStudentTtItem(te,sc,ro,gotyear,lev,i,d,p);
 if sc>0 then
  begin
   itemTt1:=trim(SubCode[sc]);
   itemTt2:=trim(XML_TEACHERS.tecode[te,0]);
   itemTt3:=trim(XML_TEACHERS.tecode[ro,1]);
   offset:=(dx-3-canvas.textwidth(ItemTt1)) div 2;
   x:=x1+offset; fcolor(cpSub); printw(ItemTt1); {subject}
   inc(y,txtHeight);
   offset:=(dx-3-canvas.textwidth(ItemTt2+' '+ItemTt3)) div 2;
   x:=x1+offset;
   fcolor(cpTeach);  printwl(ItemTt2+' '); {teacher}
   fcolor(cpRoom);  printw(ItemTt3);  {room}
   dec(y,txtHeight);
  end;
end;


procedure TSTtable.SetTabs;
var
 A1: integer;
begin
 caption:='Student Timetable'+GroupCaption;
 SetLength(Tabs,4);
 studentPointerSet;
 listtype:=winView[wnStudentTt]+1;  CodeColor:=cpStList; {student}
 day1:=XML_DISPLAY.stuttlistvals[7];
 day2:=XML_DISPLAY.stuttlistvals[8];
 yFooter:=0;  FooterWidth:=0;
 dx:=8+fwCode[1]+fwCode[2]+(blankwidth div 2);
 A1:=8+fwCode[0];
 if A1>dx then dx:=A1;
 GetLists;
 case listtype of
   1: {daily}
     begin
      A1:=8+fwperiodname;
      if A1>dx then dx:=A1;
      tab1:=fwstname+blankwidth;
      CalcTabStField;
      inc(tab1,TabStField);
     end;
   2: {weekly}
     begin
      A1:=8+fwDayname;
      if A1>dx then dx:=A1;
      if XML_DISPLAY.stuttEnrolment then
       begin
         yFooter:=(chmax+2)*txtHeight;
         FooterWidth:=Hmargin+fwCode[0]+fwCodename[0]+fwCode[1]+fwCodename[1]
          +blankwidth*10;
         //if OberonShow and TrackEnrolFlag then
         if  XML_DISPLAY.TrackEnrolFlag then
          begin
           Tabs[1]:=fwCode[0]+fwcodename[0]+fwcode[1]+blankwidth*5;
           if not(HasStudTrackData) then getTrackingData;
           if HasStudTrackData then
            begin
             GetTrackCounts;
             Tabs[2]:=(TrackParts[1]+3)*txtHeight;
             Tabs[3]:=Tabs[2];
             if TrackParts[2]>0 then Tabs[3]:=Tabs[2]+(TrackParts[2]+2)*txtHeight;

             yFooter:=yFooter+Tabs[3];
             if TrackCount>1 then FooterWidth:=Hmargin+2*Tabs[1];
            end;
          end;
       end;
     end;
 end;
 CalcArrayTops;
end;

function GetTrackLabel(i,trks: integer): string;
var
 curSem,t: smallint;
 trkSem,trkYear:  smallint;
begin
 //if MonthOfTheYear(now)>6 then curSem:=2 else curSem:=1;
 curSem := 4;
 trkSem:=curSem; trkYear:=XML_STUDENTS.stud[i].tcyear;
 for t:=1 to trks do
 begin
  dec(trkSem);
  if (trkSem<1) then
  begin
   dec(trkYear); trkSem:=4;
  end;
 end;
 if trkyear<0 then result:='-'
  else result:=yearshort+' '+yearname[trkyear]+' '+'Sem '+inttostr(trkSem);
end;


procedure TSTtable.StudTrackEnrolment(st:integer);
var
 i3,j,su,trks: integer;
 te: smallint;
 tabW2,origY: smallint;
 trackLabel: string;
begin
 origY:=y;
 newline;
 if TrackCount>0 then
  for i3:=1 to TrackCount do
   begin
    trks:=TrackInUse[i3];
    y:=origY; if i3>2 then y:=origY+Tabs[2];
    if (i3 mod 2)=1 then tabW2:=0 else tabW2:=Tabs[1];
    x:=tabW2;
    trackLabel:=GetTrackLabel(st,trks);
    if trackLabel='-' then continue;   //invalid year
    fcolor(cpNormal);
    printw(trackLabel); newline;
    x:=tabW2;
    for j:=1 to TrackLines[trks] do
     begin
      su:=StudTrack[st].Subs[trks,j];
      if trim(SubCode[su])>'' then
       begin
        fcolor(cpSub);
        printw(SubCode[su]+': ');
        x:=tabW2+fwCode[0]+blankwidth; printw(Subname[su]);
        te:=StudTrack[st].Tes[trks,j];
        if trim(XML_TEACHERS.TeCode[te,0])>'' then
         begin
          fcolor(cpTeach);
          x:=tabW2+fwCode[0]+blankwidth*2+fwCodename[0];
          printw(XML_TEACHERS.TeCode[te,0]);
         end;
        newline;
        x:=tabW2;
       end;
  end; {for j}
 end; {for trks}

 y:=origY+Tabs[3];
 fcolor(codecolor);
end;



procedure TSTtable.WeeklyFooter(i:integer);
begin
 case listtype of
  1: printw('Students: '+inttostr(ListSize[i])); {daily}
  2: if XML_DISPLAY.stuttEnrolment then {weekly}
      begin
       fcolor(cpNormal); printwl('Legend:'); StudEnrolment(i,false,false);
       //if OberonShow and TrackEnrolFlag and HasStudTrackData then
       if  XML_DISPLAY.TrackEnrolFlag and HasStudTrackData then
        begin
         fcolor(cpNormal); printwl('History:');
         StudTrackEnrolment(i);
        end;
      end;
 end;
end;

procedure TSTtable.FormCreate(Sender: TObject);
begin
 setWindowDefaults(self,wnStudentTt);
end;


{-------=======--------========= printing procs follow -------=======--------=========}


procedure TPrintStudTtWin.head;
begin
 UnderlineOn;
 printwl('Student Timetable ');
 if DoHeader then
  begin
   if winView[wnStudentTt]=0 then printwl(GroupCaption);
   printw(PageCount);
  end;
 UnderlineOff;
 x:=0; y:=y+PrnttxtHeight;
end;

procedure TPrintStudTtWin.StudTrackEnrolment(st:integer);
var
 i3,j,su,trks: integer;
 te: smallint;
 tabW2: smallint;
 trackLabel: string;

   procedure MyHeading;
    begin
     x:=tabW2;
     trackLabel:=GetTrackLabel(st,trks);
     fcolor(cpNormal);
     printw(trackLabel);
    end;

   procedure MyEntry;
   begin
    x:=tabW2;
    if trim(SubCode[su])>'' then
     begin
      fcolor(cpSub);
      printw(SubCode[su]+': ');
      x:=tabW2+fwPrntCode[0]+Prntblankwidth; printw(Subname[su]);
      if trim(XML_TEACHERS.TeCode[te,0])>'' then
       begin
        fcolor(cpTeach);
        x:=tabW2+fwPrntCode[0]+Prntblankwidth*2+fwPrntCodename[0];
        printw(XML_TEACHERS.TeCode[te,0]);
       end;
     end;
   end;

begin
 newline;
 if TrackParts[1]>0 then
  begin
   if ((y+(TrackParts[1]+1)*prntTxtHeight)>PrintPageheight) then startnewPage;
   for i3:=1 to 2 do
    begin
     if i3>TrackCount then continue;
     if (i3 mod 2)=1 then tabW2:=0 else tabW2:=PrntTabs[1];
     trks:=TrackInUse[i3]; MyHeading;
    end;
   newline;
   for j:=1 to TrackParts[1] do
    begin
     for i3:=1 to 2 do
      begin
       if i3>TrackCount then continue;
       if (i3 mod 2)=1 then tabW2:=0 else tabW2:=PrntTabs[1];
       trks:=TrackInUse[i3];
       su:=StudTrack[st].Subs[trks,j];
       te:=StudTrack[st].Tes[trks,j];
       MyEntry
      end;
     newline;
    end;
   newline; newline;
  end;

 if TrackParts[2]>0 then
  begin
   if ((y+(TrackParts[2]+1)*prntTxtHeight)>PrintPageheight) then startnewPage;
   for i3:=3 to 4 do
    begin
     if i3>TrackCount then continue;
     if (i3 mod 2)=1 then tabW2:=0 else tabW2:=PrntTabs[1];
     trks:=TrackInUse[i3]; MyHeading;
    end;
   newline;
   for j:=1 to TrackParts[2] do
    begin
     for i3:=3 to 4 do
      begin
       if i3>TrackCount then continue;
       if (i3 mod 2)=1 then tabW2:=0 else tabW2:=PrntTabs[1];
       trks:=TrackInUse[i3];
       su:=StudTrack[st].Subs[trks,j];
       te:=StudTrack[st].Tes[trks,j];
       MyEntry
      end;
     newline;
    end;
   newline; newline; 
  end;

 fcolor(codecolor);
end;



procedure TPrintStudTtWin.WeeklyFooter(i:integer);
begin
 case listtype of
  1: printw('Students: '+inttostr(ListSize[i])); {daily}
  2: if XML_DISPLAY.stuttEnrolment then {weekly}
      begin
       printwl('Legend:'); StudEnrolment(i,false);
       //if OberonShow and TrackEnrolFlag and HasStudTrackData then
       if  XML_DISPLAY.TrackEnrolFlag and HasStudTrackData then
        begin
         fcolor(cpNormal); printwl('History:');
         StudTrackEnrolment(i);
        end;
      end;
 end;
end;

procedure TPrintStudTtWin.SetTabs;
var
 A1: integer;
begin
 SetLength(PrntTabs,4);
 listtype:=winView[wnStudentTt]+1;  CodeColor:=cpStList; {student}
 day1:=XML_DISPLAY.stuttlistvals[7];
 day2:=XML_DISPLAY.stuttlistvals[8];
 yFooter:=0; 
 dx:=8+fwPrntCode[1]+fwPrntCode[2]+Prntblankwidth;
 A1:=8+fwPrntCode[0];
 if A1>dx then dx:=A1;
 case listtype of
   1: {daily}
     begin
      A1:=8+fwPrntperiodname;
      if A1>dx then dx:=A1;
      tab1:=fwPrntstname+Prntblankwidth;
      CalcTabStField;
      inc(tab1,TabStField);
     end;
   2: {weekly}
     begin
      A1:=8+fwPrntDayname;
      if A1>dx then dx:=A1;
      if XML_DISPLAY.stuttEnrolment then
       begin
        yFooter:=(chmax+2)*PrnttxtHeight;
        //if OberonShow and TrackEnrolFlag then
        if XML_DISPLAY.TrackEnrolFlag then
         begin
          PrntTabs[1]:=fwPrntCode[0]+fwPrntcodename[0]+fwPrntcode[1]+Prntblankwidth*5;
          if HasStudTrackData then
           begin
            PrntTabs[2]:=(TrackParts[1]+3)*PrnttxtHeight;
            PrntTabs[3]:=PrntTabs[2];
            if TrackParts[2]>0 then
              PrntTabs[3]:=PrntTabs[2]+(TrackParts[2]+2)*PrnttxtHeight;
            yFooter:=yFooter+PrntTabs[3];
           end;
         end;
       end;

     end;
 end;
 GetLists;
end;





procedure TPrintStudTtWin.GetLists;
var
 i: integer;
begin
 NumOfLists:=STtable.NumOfLists;
 SetArraySizes;
 if NumOfLists>0 then
  for i:=1 to NumOfLists do
   begin
    ListSize[i]:=STtable.ListSize[i];
    ListSet[i]:=STtable.ListSet[i];
   end;
end;


procedure TPrintStudTtWin.GetListContents(i: integer);
begin
 SetLength(ListContents,ListSize[i]+1);
 GeneralListContents(i,ListSize[i],ListSet[i],ListContents);
end;

procedure TPrintStudTtWin.ShowName(i:integer);
begin
  if listtype=1 then showstudentname(i)
  else printw(GetStudentName(i));
end;


procedure TPrintStudTtWin.ListHead(i,d:integer);
var
 s:string;
 j: integer;
begin
 if not(DoHeader) and (listtype=2) then exit;
 if listtype=1 then s:=dayname[d]+' for ' else s:='For ';
 j:=ListSet[i];
  case XML_DISPLAY.StudTtListType of
   1: s:=s+'Student selection';
   2: s:=s+'Group '+groupname;
   3: s:=s+'Class '+ClassCode[j];
   4: s:=s+'House '+HouseName[j];
   5: begin
       s:=s+'Tutor '+XML_TEACHERS.tecode[j,0];
       if trim(XML_TEACHERS.tename[j,0])>'' then s:=s+' ('+XML_TEACHERS.tename[j,0]+')';
      end;
   6: begin
       s:=s+'Room '+XML_TEACHERS.tecode[j,1];
       if trim(XML_TEACHERS.tename[j,1])>'' then s:=s+' ('+XML_TEACHERS.tename[j,1]+')';
      end;
  end; {case}
  printw(s);   newline;
end;


procedure TPrintStudTtWin.ShowTtItems(i,d,p,x1: integer);
var
 te,sc,ro,gotyear,lev,offset: integer;
 itemTt1,itemTt2,itemTt3: string;
begin
 sc:=0;
 GetStudentTtItem(te,sc,ro,gotyear,lev,i,d,p);
 if sc>0 then
  begin
   itemTt1:=trim(SubCode[sc]);
   itemTt2:=trim(XML_TEACHERS.tecode[te,0]);
   itemTt3:=trim(XML_TEACHERS.tecode[ro,1]);
   offset:=(dx-3-PrintCanvas.textwidth(ItemTt1)) div 2;
   x:=x1+offset; fcolor(cpSub); printw(ItemTt1); {subject}
   inc(y,PrntTxtHeight);
   offset:=(dx-3-PrintCanvas.textwidth(ItemTt2+' '+ItemTt3)) div 2;
   x:=x1+offset;
   fcolor(cpTeach);  printwl(ItemTt2+' '); {teacher}
   fcolor(cpRoom);  printw(ItemTt3);  {room}
   dec(y,PrntTxtHeight);
  end;
end;


procedure studTtableprint;
begin
 PrintStudTtWin:=TPrintStudTtWin.Create;
 with PrintStudTtWin do
  try
   DoHeader:=XML_DISPLAY.StHeadShow;
   PaintOnPrinter;
  finally
   PrintStudTtWin.free;
  end;
end;



{-------=======-------- Text Output procs follow -------=======--------=========}

procedure TOutStudTtWin.head;
begin
 printw('Student Timetable ');
 if DoHeader and (winView[wnStudentTt]=0) then printc(GroupCaption);
 newline;
end;

procedure TOutStudTtWin.StudTrackEnrolment(st:integer);
var
 i3,j,trks: integer;
 su,te: smallint;
 trackLabel: string;
begin
 newline;
 if TrackCount>0 then
  for i3:=1 to TrackCount do
   begin
    trks:=TrackInUse[i3];
    trackLabel:=GetTrackLabel(st,trks);
    if trackLabel='-' then continue;   //invalid year
    printLine([trackLabel]);
    for j:=1 to TrackLines[trks] do
     begin
      su:=StudTrack[st].Subs[trks,j];
      te:=StudTrack[st].Tes[trks,j];
      if trim(SubCode[su])>'' then
       begin
        printw(SubCode[su]+': ');
        printc(Subname[su]);
        printc(XML_TEACHERS.TeCode[te,0]);
        newline;
       end;
  end; {for j}
 end; {for trks}
end;



procedure TOutStudTtWin.WeeklyFooter(i:integer);
begin
 case listtype of
  1: begin    {daily}
      printLine(['Students: ',inttostr(ListSize[i])]);
      newline;
     end;
  2: if XML_DISPLAY.stuttEnrolment then
      begin
       printw('Legend:'); StudEnrolment(i,false);
       //if OberonShow and TrackEnrolFlag and HasStudTrackData then
       if  XML_DISPLAY.TrackEnrolFlag and HasStudTrackData then
        begin
         printw('History');
         StudTrackEnrolment(i);
        end;
      end;{weekly}
 end;
end;

procedure TOutStudTtWin.SetTabs;
begin
 listtype:=winView[wnStudentTt]+1;
 day1:=XML_DISPLAY.stuttlistvals[7];
 day2:=XML_DISPLAY.stuttlistvals[8];
 GetLists;
 TabCount:=0;
 if listtype=1 then CalcTabCount;
end;


procedure TOutStudTtWin.GetLists;
var
 i: integer;
begin
 NumOfLists:=STtable.NumOfLists;
 SetArraySizes;
 if NumOfLists>0 then
  for i:=1 to NumOfLists do
   begin
    ListSize[i]:=STtable.ListSize[i];
    ListSet[i]:=STtable.ListSet[i];
   end;
end;


procedure TOutStudTtWin.GetListContents(i: integer);
begin
 SetLength(ListContents,ListSize[i]+1);
 GeneralListContents(i,ListSize[i],ListSet[i],ListContents);
end;

procedure TOutStudTtWin.ShowName(i:integer);
begin
 showstudentname(i);
end;


procedure TOutStudTtWin.ListHead(i,d:integer);
var
 s:string;
 j: integer;
begin
 if not(DoHeader) and (listtype=2) then exit;
 if listtype=1 then s:=dayname[d]+' for ' else s:='For ';
 j:=ListSet[i];
  case XML_DISPLAY.StudTtListType of
   1: s:=s+'Student selection';
   2: s:=s+'Group '+groupname;
   3: s:=s+'Class '+ClassCode[j];
   4: s:=s+'House '+HouseName[j];
   5: begin
       s:=s+'Tutor '+XML_TEACHERS.tecode[j,0];
       if trim(XML_TEACHERS.tename[j,0])>'' then s:=s+' ('+XML_TEACHERS.tename[j,0]+')';
      end;
   6: begin
       s:=s+'Room '+XML_TEACHERS.tecode[j,1];
       if trim(XML_TEACHERS.tename[j,1])>'' then s:=s+' ('+XML_TEACHERS.tename[j,1]+')';
      end;
  end; {case}
  printw(s);   newline;
end;

procedure TOutStudTtWin.ShowTtItems(i,d,p: integer);
var
 te,sc,ro,gotyear,lev: integer;
 itemTt1,itemTt2,itemTt3: string;
begin
 sc:=0;
 GetStudentTtItem(te,sc,ro,gotyear,lev,i,d,p);
 if sc>0 then
  begin
   itemTt1:=trim(SubCode[sc]);
   itemTt2:=trim(XML_TEACHERS.tecode[te,0]);
   itemTt3:=trim(XML_TEACHERS.tecode[ro,1]);
   printc(ItemTt1); {subject}
   printc(ItemTt2); {teacher}
   printc(ItemTt3);  {room}
  end
 else
  begin
   printc(''); printc(''); printc('');
  end;
end;


procedure studTtableOut;
begin
 OutStudTtWin:=TOutStudTtWin.Create;
 with OutStudTtWin do
  try
   DoHeader:=XML_DISPLAY.StHeadShow;
   PaintOnOutput;
  finally
   OutStudTtWin.free;
  end;
end;

procedure TSTtable.PopupMenu1Popup(Sender: TObject);
begin
 selection2.enabled:=(XML_STUDENTS.numstud>0);
end;

end.


