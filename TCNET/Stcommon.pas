unit Stcommon;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Dialogs, SysUtils,Messages,TimeChartGlobals, XML.UTILS,
  GlobalToTcAndTcextra, XML.DISPLAY, XML.TEACHERS, XML.STUDENTS;

 procedure newsub(sub:string;splitSu:integer);
 procedure splitlinks(SplitSu,classnum:integer;split:array of integer);
 procedure horsplit(Splitsu,clsize,classnum: integer;split:array of integer);
 Procedure CheckCurrentYear;
 Procedure UpdateStudCalcs;

 function checkGrSub(a:string): integer;
 function GetStudentTtItem(var te,su,ro,Sttyear,Sttlevel: integer;st,D,P: integer): Boolean;
 function FNcm(a,b:  smallint):smallint;
 procedure CalculateClashMatrix;
 procedure CalculateBlockClashes;
 procedure ClearMyStud(var MyStud: tpStudRec);
 procedure countsubsinblock;
 function CheckStudChoiceForClash(stnum,chnum: smallint): bool;
 function hasstudentclash(i: smallint): bool;
 procedure GetStClashes(st: integer);
 procedure weightSolutions(st: integer);
 procedure studentPointerSet;
 procedure CountGroupSubs;
 procedure removeStudent(stp: integer);
 procedure sortStudents;
 procedure resetStudentOrder(H: smallint);
 function CalcIDlen: smallint;
 procedure StudentQuickStreamLoad(year:smallint);
 procedure CountChmax;
 procedure getYearStats;
 procedure SaveAllStudentYears;
 function findThisStudent(Stud1: tpStudRec): smallint;
 function subISAlreadyinBlock(ss: smallint; bb: smallint):wordbool;
 procedure InitClassSizes;
 procedure SetClassSizePoint;
 function GetClassMax(i:integer):smallint;
 procedure SetDefaultClassSize(newsize: smallint);
 function StudHasTag(myStud,myTag: smallint): wordbool;
 procedure CalcTagsUsed;
 function IsStudentInGroup(const pStudNo: Integer): Boolean;

implementation

uses     tcommon,tcommon2,tcommon5,main,subyr,block1, customOutput;

function StudHasTag(myStud,myTag: smallint): wordbool;
begin
 result:=wordbool((1 shl (myTag-1)) and XML_STUDENTS.Stud[myStud].tctag)
end;


procedure CalcTagsUsed;
var
 i,j: smallint;
begin
 TagOrderNum:=0;
 for i:=1 to nmbrTags do
  begin
   TagsUsed[i]:=false;
   TagOrder[i]:=0;
  end;
 for j:=1 to nmbrTags do
  begin
   for i:=1 to XML_STUDENTS.numstud do
    if StudHasTag(i,j) then
     begin
      TagsUsed[j]:=true;
      break;
     end;
  end;
 for i:=1 to nmbrTags do
  if TagsUsed[i] then
   begin
    inc(TagOrderNum);
    TagOrder[TagOrderNum]:=i;
   end;
 TagCalcFlag:=false;
end;


procedure SetDefaultClassSize(newsize: smallint);
var
 i: integer;
begin
 for i:=1 to nmbrSubjects do
  if SubStMax[i]=XML_DISPLAY.MaxClassSize then SubStMax[i]:=newsize;
 XML_DISPLAY.MaxClassSize:=newsize;
 SetClassSizePoint;
end;

function GetClassMax(i:integer):smallint;
var
 j:smallint;
 a,b: string;
begin
 result:=SubStMax[i];
 if SubStMax[i]=XML_DISPLAY.MaxClassSize then {hasn't been set}
  begin
   a:=copy(Subcode[i],lencodes[0],1);
   if (a>='A') and (a<='Z') then  {split sub}
    begin
     b:=copy(SubCode[i],1,lencodes[0]-1);
     j:=checkCode(0,b);
     if j>0 then result:=SubStMax[j];
    end;
  end;
end;

procedure SetClassSizePoint;
var
 i,j,count: integer;
begin
 count:=0;
 Setlength(SubStMaxPoint,count+1);
 IntRange(XML_DISPLAY.MaxClassSize,1,nmbrStudents);
 if codeCount[0]>0 then
  for i:=1 to codeCount[0] do
   begin
    j:=codepoint[i,0];
    if (SubStMax[j]<1) or (SubStMax[j]>nmbrStudents) then SubStMax[j]:=XML_DISPLAY.MaxClassSize;
    if SubStMax[j]<>XML_DISPLAY.MaxClassSize then
     begin
      inc(count);
      Setlength(SubStMaxPoint,count+1);
      SubStMaxPoint[count]:=j;
     end;
   end;
 SubStMaxPoint[0]:=count;
end;

procedure InitClassSizes;
var
 i: integer;
begin
 for i:=1 to nmbrSubjects do SubStMax[i]:=XML_DISPLAY.MaxClassSize;
 SetClassSizePoint;
end;



function subISAlreadyinBlock(ss: smallint; bb: smallint):wordbool;
var
 L: integer;
begin
 if XML_DISPLAY.blocklevel>levelprint then
    XML_DISPLAY.blocklevel:=levelprint;
 result:=false;
 if ss=0 then exit;
 if bb>XML_DISPLAY.blocknum then exit;
 for L:=1 to XML_DISPLAY.blocklevel do
  if Sheet[bb,L]=ss then result:=true;
end;

function findThisStudent(Stud1: tpStudRec): smallint;
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
  if DoSkipS(Stud1.stname,XML_STUDENTS.Stud[j].StName) then continue; {check surname}
  if DoSkipS(Stud1.first,XML_STUDENTS.Stud[j].First) then continue; {check first name}
//  if DoSkipS(Stud1.Sex,XML_STUDENTS.Stud[j].Sex) then continue; {check sex}  //mantis-1566.
  if DoSkipS(Stud1.ID,XML_STUDENTS.Stud[j].ID) then continue; {check ID}
  if DoSkip(Stud1.TcYear+1,XML_STUDENTS.Stud[j].TcYear+1) then continue; {check year}
  if DoSkip(Stud1.tcClass,XML_STUDENTS.Stud[j].TcClass) then continue; {check class}
  if DoSkip(Stud1.House,XML_STUDENTS.Stud[j].house) then continue; {check house}
  if DoSkip(Stud1.tutor,XML_STUDENTS.Stud[j].tutor) then continue; {check tutor}
  if DoSkip(Stud1.home,XML_STUDENTS.Stud[j].home) then continue; {check home}
  {still here so found stud match}
  result:=j; break;
 end; {for i}
end;



procedure getYearStats;
var
 i,j,k,y: smallint;
 len: smallint;
 strA: string;
begin
  for y := 0 to years_minus_1 do
  begin
    yearStat[y].numstud := 0;
    yearStat[y].chmax := 5;
    yearStat[y].IDlen := 0;
    yearStat[y].Namelen := 0;
    yearStat[y].MaleNum := 0;
    yearStat[y].FemaleNum := 0;
    if XML_STUDENTS.numstud>0 then
    begin
      for i:=1 to XML_STUDENTS.numstud do
      begin
       if XML_STUDENTS.Stud[i].TcYear=y then
       begin
         inc(yearStat[y].numstud);
         len := 1 + length(XML_STUDENTS.Stud[i].StName)+length(XML_STUDENTS.Stud[i].First);
         if len> yearStat[y].Namelen then
           yearStat[y].Namelen:=len;
         strA := uppercase(XML_STUDENTS.Stud[i].Sex);
         if (strA=genderShort[0]{'M'}) then
           inc(yearStat[y].MaleNum)
         else
           inc(yearStat[y].FemaleNum);
         for j:=1 to nmbrchoices do
           if (XML_STUDENTS.Stud[i].choices[j]>0) and (j>yearStat[y].chmax) then
             yearStat[y].chmax:=j;
         k := length(trim(XML_STUDENTS.Stud[i].ID));
         if k>yearStat[y].IDlen then
           yearStat[y].IDlen:=k;
         if yearStat[y].chmax > nmbrChoices then
           yearStat[y].chmax := nmbrChoices;
         if yearStat[y].IDlen > szID then
           yearStat[y].IDlen := szID;
       end; {.tcyear=y}
      end;  {for i}
    end;
//   yearStat[y].recordSize:=53+(2*yearStat[y].chmax)+yearStat[y].IDlen;
   yearStat[y].recordSize:=73+(2*yearStat[y].chmax)+yearStat[y].IDlen;
  end; {for y}
end;


procedure SaveStudents(year:smallint);
var
 i,j:   integer;
 a,b,c:    string;
 fname,tname: string;
 YearDigit:     string[2];
 MyIDlen: smallint;
begin
 chdir(Directories.datadir);
 YearDigit:=inttostr(year+1);
 YearDigit:=trim(YearDigit);
 try
  try
   needClashMatrixRecalc:=true;
   MyIDlen:=yearStat[year].IDlen;
   fname:='CHOICE'+YearDigit+'.ST';
   tname:='CHOICE'+YearDigit+'.TMP';
   ourSafetyMemStreamStr:='';
   ourSafetyMemStream:=TStringStream.Create(ourSafetyMemStreamStr);
   with ourSafetyMemStream do
    begin
     TC4fileHeader:='TCV6'; Write(Pchar(@TC4fileHeader[1])^,4);
     write(yearStat[year].numstud,2);
     write(yearStat[year].chmax,2);
     write(yearStat[year].IDlen,2);
     write(yearStat[year].recordSize,2);
     write(yearStat[year].Namelen,2);
     write(yearStat[year].MaleNum,2);
     write(yearStat[year].FemaleNum,2);
     a:=space(yearStat[year].recordSize-18);
     Write(Pchar(@a[1])^,length(a));
     if XML_STUDENTS.numstud>0 then
      for i:=1 to XML_STUDENTS.numstud do
       if XML_STUDENTS.Stud[i].TcYear=year then
       begin
        a:=RpadString(XML_STUDENTS.Stud[i].StName,szStName);
        b:=RpadString(XML_STUDENTS.Stud[i].First,szStFirst);
        c:=RpadString(XML_STUDENTS.Stud[i].ID,MyIDlen);
        Write(Pchar(@a[1])^,szStName);
        Write(Pchar(@b[1])^,szStFirst);
        for j:=1 to yearStat[year].chmax do write(XML_STUDENTS.Stud[i].choices[j],2);
        Write(Pchar(@XML_STUDENTS.Stud[i].Sex[1])^,1);
        Write(XML_STUDENTS.Stud[i].TcClass,2);
        Write(XML_STUDENTS.Stud[i].House,2);
        if MyIDlen>0 then Write(Pchar(@c[1])^,MyIDlen);
        Write(XML_STUDENTS.Stud[i].tutor,2);
        Write(XML_STUDENTS.Stud[i].home,2);
        Write(XML_STUDENTS.Stud[i].TcTag,2);
        Write(XML_STUDENTS.Stud[i].strRecord,2);
       end;
    end;
   SafelyStreamToFile(tname,fname);
  finally
   ourSafetyMemStream.Free;
   FileAge(fname,NEW_DateChecks[17+year]);
  end;
 except
 end;
end;


procedure SaveAllStudentYears;
var
 y: smallint;
begin
 getYearStats;
 if usrPassLevel=utGen then exit;
 for y:=0 to years_minus_1 do
 begin
  if StudYearFlag[y] then
  begin
   saveStudents(y);
   //if (CustomerIDnum=cnMountainCreekSHS) then // only for MOUNTAIN CREEK STATE HIGH SCHOOL
   begin
    UpdateStudID2File(y);
    UpdateStudID2FileNew(y);
   end;
  end;
  StudYearFlag[y]:=false;
 end; {for y}
 SaveStudFlag:=False;  HasStudTrackData:=false;
 TagCalcFlag:=true;
 if SaveSubsFlag then updatesub(0);
end;




procedure CountChmax;
var
  i,j,k,y:    smallint;
begin
  chmax:=10;
  for i:=0 to years-1 do yearStat[i].IDlen:=0;
  for i:=1 to XML_STUDENTS.numstud do
    begin
      y:=XML_STUDENTS.Stud[i].TcYear;
      for j:=1 to nmbrchoices do
         if (XML_STUDENTS.Stud[i].choices[j]>0) and (j>chmax) then chmax:=j;
      k:=ord(XML_STUDENTS.Stud[i].ID[0]);
      if k>yearStat[y].IDlen then yearStat[y].IDlen:=k;
    end;
  if chmax>nmbrChoices then chmax:=nmbrChoices;
  for y:=0 to years-1 do if yearStat[y].IDlen>szID then yearStat[y].IDlen:=szID;
end;



procedure splitStreamName(StudentI:smallint; StudentName:string);
var
 strA,strB:  string;
 stpos,stpos1:     smallint;
begin
 StudentName:=trim(StudentName);
 strA:=StudentName;
 stpos:=pos(' ',strA);
 strB:=copy(strA,stpos+1,length(strA));
 stpos1:=stpos;
 while stpos1>0 do
 begin
  stpos1:=pos(' ',strB);
  strB:=copy(strB,stpos1+1,length(strB));
  stpos:=stpos+stpos1;
 end;
 XML_STUDENTS.Stud[StudentI].StName:=copy(strA,1,stpos-1);
 XML_STUDENTS.Stud[StudentI].First:=copy(strA,stpos+1,length(strA));
end;



procedure StudentQuickStreamLoad(year:smallint);
//Load Student data
var
 tmpfilename:   string;
 YearDigit:     string[2];
 FFileHandle:   THandle;
 FMapHandle:    THandle;
 FFileSize:     integer;
 FData,FDataStrt:         ^Byte;
 FDataPntrChk:  integer;

       function getbyte:byte;
       begin
        inc(FDataPntrChk);
        if FDataPntrChk>FFileSize then
        begin  {preventing old read beyond eof becoming a major gpf problem ???}
         result:=0; exit;
        end;
        result:=byte(FData^);
        inc(FData);
       end;

       function getINT:word;
       var
        i1,i2:smallint;
       begin
        i1:=getbyte; i2:=getbyte;
        result:=i1+(i2*256);
       end;

       function getStr(a:smallint): string;
       var
        i: smallint;
        s: string;
       begin
        s:='';
        for i:=1 to a do
         s:=s+chr(getbyte);
        result:=s;
       end;

     procedure getQuickStreamOldStudentFormat;
     var
      i,i1,j:     longint;
      strA,astr:    string;
     begin
      YearStat[year].RecordSize:=75;
      try
         YearStat[year].numstud:=getINT; IntRange(YearStat[year].numstud,0,nmbrStudents);
         setlength(XML_STUDENTS.Stud,(YearStat[year].numstud+XML_STUDENTS.numstud+1)); {zero based so +1}
         YearStat[year].chmax:=getINT; IntRange(YearStat[year].chmax,0,nmbrChoices);
         YearStat[year].IDlen:=getINT; IntRange(YearStat[year].IDlen,0,szID);
         YearStat[year].RecordSize:=getINT;
        if YearStat[year].numstud>0 then
        begin
         for i:=1 to YearStat[year].numStud do
         begin
          FData:=FDataStrt; i1:=i+XML_STUDENTS.numstud;
          inc(FData,(i*YearStat[year].RecordSize));
          FDataPntrChk:=(i*YearStat[year].RecordSize);
          astr:=getStr(25);
          strA:=trim(strA); splitStreamName(i1,strA);
          for j:=1 to nmbrchoices do XML_STUDENTS.Stud[i1].choices[j]:=0;
          for j:=1 to YearStat[year].chmax do
           XML_STUDENTS.Stud[i1].choices[j]:=getINT;
          XML_STUDENTS.Stud[i1].Sex:=chr(getbyte);
          XML_STUDENTS.Stud[i1].TcClass:=getINT;
          XML_STUDENTS.Stud[i1].House:=getINT;
          if YearStat[year].IDlen>0 then astr:=getStr(YearStat[year].IDlen)
           else astr:='';
          XML_STUDENTS.Stud[i1].ID:=trim(aStr);
          XML_STUDENTS.Stud[i1].TcYear:=year;
          XML_STUDENTS.Stud[i1].Tutor:=0;XML_STUDENTS.Stud[i1].Home:=0;
          XML_STUDENTS.Stud[i1].TcTag:=0;XML_STUDENTS.Stud[i1].StrRecord:=0;
         end;
        end; {if}
      except

      end;
     end;

     procedure getQuickStreamNewStudentFormat;
     var
      i,i1,j,ai:     longint;
      astr:    string;
     begin
      YearStat[year].RecordSize:=98;
      try
         YearStat[year].numstud:=getINT; IntRange(YearStat[year].numstud,0,nmbrStudents);
         setlength(XML_STUDENTS.Stud,(YearStat[year].numstud+XML_STUDENTS.numstud+1)); {zero based so +1}
         YearStat[year].chmax:=getINT; IntRange(YearStat[year].chmax,0,nmbrChoices);
         YearStat[year].IDlen:=getINT; IntRange(YearStat[year].IDlen,0,szID);
         YearStat[year].RecordSize:=getINT;

        if YearStat[year].numstud>0 then
         for i:=1 to YearStat[year].numstud do
         begin
          FData:=FDataStrt;i1:=i+XML_STUDENTS.numstud;
          inc(FData,(i*YearStat[year].RecordSize));
          FDataPntrChk:=(i*YearStat[year].RecordSize);
          astr:=getStr(20); XML_STUDENTS.Stud[i1].StName:=trim(aStr);
          astr:=getStr(20); XML_STUDENTS.Stud[i1].First:=trim(aStr);
          for j:=1 to nmbrchoices do XML_STUDENTS.Stud[i1].choices[j]:=0;
          for j:=1 to YearStat[year].chmax do
           XML_STUDENTS.Stud[i1].choices[j]:=getINT;
          ai:=getbyte;
          XML_STUDENTS.Stud[i1].Sex:=chr(ai);
          XML_STUDENTS.Stud[i1].TcClass:=getINT;
          XML_STUDENTS.Stud[i1].House:=getINT;
          if YearStat[year].IDlen>0 then astr:=getStr(YearStat[year].IDlen)
           else astr:='';
          XML_STUDENTS.Stud[i1].ID:=trim(aStr);
          XML_STUDENTS.Stud[i1].Tutor:=getINT;
          XML_STUDENTS.Stud[i1].Home:=getINT;
          XML_STUDENTS.Stud[i1].TcTag:=getINT;
          XML_STUDENTS.Stud[i1].strRecord:=smallint(getINT);
          XML_STUDENTS.Stud[i1].TcYear:=year;
         end; {for i}
      except

      end;
     end;

     procedure getQuickStreamNewStudentFormat6;
     var
      i,i1,j,ai:     longint;
      astr:    string;
     begin
      YearStat[year].RecordSize:=123;
      try
         YearStat[year].numstud:=getINT; IntRange(YearStat[year].numstud,0,nmbrStudents);
         setlength(XML_STUDENTS.Stud,(YearStat[year].numstud+XML_STUDENTS.numstud+1)); {zero based so +1}
         YearStat[year].chmax:=getINT; IntRange(YearStat[year].chmax,0,nmbrChoices);
         YearStat[year].IDlen:=getINT; IntRange(YearStat[year].IDlen,0,szID);
         YearStat[year].RecordSize:=getINT;

        if YearStat[year].numstud>0 then
         for i:=1 to YearStat[year].numstud do
         begin
          FData:=FDataStrt;i1:=i+XML_STUDENTS.numstud;
          inc(FData,(i*YearStat[year].RecordSize));
          FDataPntrChk:=(i*YearStat[year].RecordSize);
          astr:=getStr(30); XML_STUDENTS.Stud[i1].StName:=trim(aStr);
          astr:=getStr(30); XML_STUDENTS.Stud[i1].First:=trim(aStr);
          for j:=1 to nmbrchoices do XML_STUDENTS.Stud[i1].choices[j]:=0;
          for j:=1 to YearStat[year].chmax do
           XML_STUDENTS.Stud[i1].choices[j]:=getINT;
          ai:=getbyte;
          XML_STUDENTS.Stud[i1].Sex:=chr(ai);
          XML_STUDENTS.Stud[i1].TcClass:=getINT;
          XML_STUDENTS.Stud[i1].House:=getINT;
          if YearStat[year].IDlen>0 then astr:=getStr(YearStat[year].IDlen)
           else astr:='';
          XML_STUDENTS.Stud[i1].ID:=trim(aStr);
          XML_STUDENTS.Stud[i1].Tutor:=getINT;
          XML_STUDENTS.Stud[i1].Home:=getINT;
          XML_STUDENTS.Stud[i1].TcTag:=getINT;
          XML_STUDENTS.Stud[i1].strRecord:=smallint(getINT);
          XML_STUDENTS.Stud[i1].TcYear:=year;
         end; {for i}
      except

      end;
     end;

  procedure ClearStudents;
  var
    i: Integer;
  begin
    for i := 1 to XML_STUDENTS.NumStud do
      RemoveStudent(i);
  end;
begin
 //ClearStudents;
 chdir(Directories.datadir); HasStudTrackData:=false;
 FMapHandle:=0;
 YearStat[year].numstud:=0; YearStat[year].chmax:=20; YearStat[year].IDlen:=5;
 YearStat[year].Namelen:=0; YearStat[year].MaleNum:=0; YearStat[year].FemaleNum:=0;
 YearDigit:=inttostr(year+1);  YearDigit:=trim(YearDigit);
 tmpfilename:='CHOICE'+YearDigit+'.ST';
 if fileexists(tmpfilename) then
  begin
   try
    FileAge(tmpfilename,NEW_DateChecks[17+year]);
    {mem map file}
    FFileHandle:=FileOpen(tmpfilename,(fmOpenRead + fmShareDenyNone));
    FDataPntrChk:=0;
    FFileSize:=GetFileSize(FFileHandle,Nil);
    try
     try
      FMapHandle:=CreateFileMapping(FFileHandle,nil,PAGE_READONLY,0,FFileSize,nil);
      FData:=MapViewOfFile(FMapHandle,FILE_MAP_READ,0,0,FFileSize);
     finally
      dbgbool:=CloseHandle(FMapHandle);
     end;
    finally
     dbgbool:=CloseHandle(FFileHandle);
    end;

    try
     FDataStrt:=FData;
     {use FData in here as ^byte}
     TC4fileHeader:=getStr(4);
     if TC4fileHeader = 'TCV6' then
     begin
       getQuickStreamNewStudentFormat6;
     end else begin
       if TC4fileHeader = 'TCV4' then
       begin
         getQuickStreamNewStudentFormat;
       end else begin
         if (FFileSize>=4) then dec(FData,4);
         getQuickStreamOldStudentFormat;
       end;
     end;
     {
     if TC4fileHeader<>'TCV4' then
      begin
       if (FFileSize>=4) then dec(FData,4);
       getQuickStreamOldStudentFormat;
      end
     else
      getQuickStreamNewStudentFormat;
     }
    finally
     dbgbool:=UnmapViewOfFile(FDataStrt);  {not FData as it has changed by now}
     dbgdword:=getlasterror();
    end;

   except
   end;
   setlength(StGroup,(YearStat[year].numStud+XML_STUDENTS.numstud+1)); {zero based so +1}
   setlength(StPointer,(YearStat[year].numStud+XML_STUDENTS.numstud+1)); {zero based so +1}
  end;
 XML_STUDENTS.numstud:=XML_STUDENTS.numstud+YearStat[year].numstud;
 if YearStat[year].chmax >chmax then  chmax:=YearStat[year].chmax;
 TagCalcFlag:=true;
end;


function CalcIDlen: smallint;
var
  i,IDlen:    smallint;
begin
 IDlen:=1;
 for i:=0 to years-1 do
  if IDlen<yearStat[i].IDlen then IDlen:=yearStat[i].IDlen;
 if IDlen>szID then IDlen:=szID;
 result:=IDlen;
end;



function SortString(g1,GrSort: smallint):string;
 begin
  result:='';
  case GrSort of
    0: result:=uppercase(trim(char(65+XML_STUDENTS.Stud[g1].TcYear))); {year}
    1: result:=uppercase(trim(XML_STUDENTS.Stud[g1].Stname)+' '+trim(XML_STUDENTS.Stud[g1].first)); {name}
    2: result:=uppercase(trim(ClassCode[XML_STUDENTS.Stud[g1].tcClass]));{class}
    3: result:=uppercase(trim(HouseName[XML_STUDENTS.Stud[g1].House]));  {House}
    4: result:=uppercase(trim(XML_STUDENTS.Stud[g1].ID));  {ID}
    6: result:=uppercase(trim(XML_TEACHERS.TeCode[XML_STUDENTS.Stud[g1].tutor,0]));   {tutor}
    7: result:=uppercase(trim(XML_TEACHERS.TeCode[XML_STUDENTS.Stud[g1].home,1])); {room}
    end; {case}
end;



procedure swapStudents(A,B: smallint);
var
 tmp:      tpStudRec;
 tmpstudID2: string[50];
 tmpstudemail: string[100];
begin
 tmp:=XML_STUDENTS.Stud[A];
 XML_STUDENTS.Stud[A]:=XML_STUDENTS.Stud[B];
 XML_STUDENTS.Stud[B]:=tmp;
               
 //if (CustomerIDnum=cnMountainCreekSHS) then // only for MOUNTAIN CREEK STATE HIGH SCHOOL
 begin           //do matching swap for ID2 data
  tmpstudID2:=studID2[A];
  studID2[A]:=studID2[B];
  studID2[B]:=tmpstudID2;

  tmpstudEmail:=studEmail[A];
  studEmail[A]:=studEmail[B];
  studEmail[B]:=tmpstudEmail;
 end;
end;

procedure resetStudentOrder(H: smallint);
var
 aStr,bStr:     string;
 a,b,i:             smallint;
 notFin:          bool;
 ID1,ID2,error:         Integer;
 XrefSort: array of smallint;


 procedure SwapSort(a,b:smallint);
 begin
  StudSort[XrefSort[a]]:=b;
  StudSort[XrefSort[b]]:=a;
  swapint(XrefSort[a],XrefSort[b]);
 end;

begin
 setlength(XrefSort,XML_STUDENTS.numstud+1);
 for i:=1 to XML_STUDENTS.numstud do
  XrefSort[StudSort[i]]:=i;
 notFin:=true;
 aStr:=Uppercase(trim(XML_STUDENTS.Stud[h].stName))+' '+Uppercase(trim(XML_STUDENTS.Stud[h].first));
 while ((h<XML_STUDENTS.numstud) and notFin) do
 begin
  notFin:=false;   {exit while}
  bStr:=Uppercase(trim(XML_STUDENTS.Stud[h+1].stName))+' '+Uppercase(trim(XML_STUDENTS.Stud[h+1].first));
  if aStr>bStr then
  begin
   a:=h;  b:=h+1;
   swapStudents(a,b);SwapSort(a,b);
   inc(h);
   notFin:=true; {stay in while}
  end;
 end;
 notFin:=true;
 while ((h>1) and notFin) do
 begin
  notFin:=false; {exit while}
  bStr:=Uppercase(trim(XML_STUDENTS.Stud[h-1].stName)+' '+Uppercase(trim(XML_STUDENTS.Stud[h-1].first)));
  if aStr<bStr then
  begin
   a:=h;  b:=h-1;
   swapStudents(a,b); SwapSort(a,b);
   dec(h);
   notFin:=true; {stay in while}
  end;
 end;

 ID1:=1; ID2:=1;
 h:=XrefSort[h];
 if GroupSort=5 then
    begin
     val(XML_STUDENTS.Stud[StudSort[h]].ID,ID1,error); aStr:=SortString(StudSort[h],1);
    end
   else
     aStr:=SortString(StudSort[h],GroupSort)+space(10)
      +SortString(StudSort[h],1);
 notFin:=true;
 while ((h<XML_STUDENTS.numstud) and notFin) do
 begin
  notFin:=false;   {exit while}
  if GroupSort=5 then
   begin
    val(XML_STUDENTS.Stud[StudSort[h+1]].ID,ID2,error); bStr:=SortString(StudSort[h+1],1);
   end
   else
     bStr:=SortString(StudSort[h+1],GroupSort)+space(10)
      +SortString(StudSort[h+1],1);

  if ((aStr>bStr) and (GroupSort<>5)) or
     ((GroupSort=5) and ((ID1>ID2) or ((aStr>bStr)and (ID1=ID2)))) then
  begin
   a:=h;  b:=h+1;
   swapint(StudSort[a],StudSort[b]);
   inc(h);
   notFin:=true; {stay in while}
  end;
 end;
 notFin:=true;
 while ((h>1) and notFin) do
 begin
  notFin:=false; {exit while}
  if GroupSort=5 then
   begin
    val(XML_STUDENTS.Stud[StudSort[h-1]].ID,ID2,error); bStr:=SortString(StudSort[h-1],1);
   end
   else
     bStr:=SortString(StudSort[h-1],GroupSort)+space(10)
      +SortString(StudSort[h-1],1);


  if ((aStr<bStr) and (GroupSort<>5)) or
     ((GroupSort=5) and ((ID1<ID2) or ((aStr<bStr)and (ID1=ID2)))) then
  begin
   a:=h;  b:=h-1;
   swapint(StudSort[a],StudSort[b]);
   dec(h);
   notFin:=true; {stay in while}
  end;
 end;

end;

procedure sortStudents;
var
 i:            smallint;
 J,K,L,M,A,B:  smallint;
 strA,strB:    string;
label
 Label1,label2;
begin
 SetStArrays;

 K:=1;
 while K<XML_STUDENTS.numstud do
  K:=K+K;
 label2:
 K:=(K-1) div 2;
 if K=0 then
 begin
  //init sort array to alpha sort
  for i:=1 to XML_STUDENTS.numstud do StudSort[i]:=i;
  exit;
 end;

 M:=XML_STUDENTS.numstud-K;
 for i:=1 to M do
 begin
   J:=i;
   Label1:
   L:=J+K;

   A:=L;
   B:=J;


   strA:=XML_STUDENTS.Stud[A].StName+' '+XML_STUDENTS.Stud[A].First;
   strA:=UpperCase(strA);
   strB:=XML_STUDENTS.Stud[B].StName+' '+XML_STUDENTS.Stud[B].First;
   strB:=UpperCase(strB);
   if strA<strB then
   begin
    swapStudents(A,B);
    J:=J-K;
   end;
   if (strA<strB) and (J>0) then goto Label1;
  end;   {for}
 goto label2;
end;

procedure removeStudent(stp: integer);
var
 j,i5:       integer;
 a,b,c,stpoint:   integer;
begin
 SaveStudFlag:=true;
  StudYearFlag[XML_STUDENTS.Stud[stp].TcYear]:=true;

 for j:=1 to nmbrChoices do
 begin
  a:=XML_STUDENTS.Stud[stp].choices[j];
  b:=GsubXref[a];
  c:=GroupSubCount[b];
  if ((a>0) and (b>0) and (c>0)) then GroupSubCount[b]:=c-1;
 end; {for j}
 if stp<XML_STUDENTS.numstud then
  for i5:=stp to (XML_STUDENTS.numstud-1) do
  begin
   XML_STUDENTS.Stud[i5]:=XML_STUDENTS.Stud[i5+1];

   //if (CustomerIDnum=cnMountainCreekSHS) then // only for MOUNTAIN CREEK STATE HIGH SCHOOL
   begin
    studID2[i5]:=studID2[i5+1];
    studEmail[i5]:=studemail[i5+1];
   end;

  end;

 stpoint:=0;
 for j:=1 to groupnum do
  if StPointer[j]=stp then stpoint:=j;
 if ((stpoint<groupnum) and (stpoint>0)) then
 begin
  for i5:=stpoint to (groupnum-1) do StPointer[i5]:=StPointer[i5+1];
  for i5:=stpoint to (groupnum-1) do
    if StPointer[i5]>stp then dec(StPointer[i5]);
 end;
 if stpoint>0 then StPointer[groupnum]:=0;

 stpoint:=0;
 for j:=1 to XML_STUDENTS.numstud do
  if StudSort[j]=stp then stpoint:=j;
 if ((stpoint<XML_STUDENTS.numstud) and (stpoint>0)) then
 begin
  for i5:=stpoint to (XML_STUDENTS.numstud-1) do StudSort[i5]:=StudSort[i5+1];
  for i5:=stpoint to (XML_STUDENTS.numstud-1) do
    if StudSort[i5]>stp then dec(StudSort[i5]);
 end;
 if stpoint>0 then StudSort[XML_STUDENTS.numstud]:=0;

 stpoint:=0;
 for j:=1 to groupnum do
  if StGroup[j]=stp then stpoint:=j;
 if ((stpoint<groupnum) and (stpoint>0)) then
 begin
  for i5:=stpoint to (groupnum-1) do StGroup[i5]:=StGroup[i5+1];
  for i5:=1 to (groupnum-1) do
    if StGroup[i5]>stp then dec(StGroup[i5]);
 end;

 if stpoint>0 then
  begin StGroup[groupnum]:=0;  dec(groupnum); end;


 XML_STUDENTS.Stud[XML_STUDENTS.numstud].stname:='';   XML_STUDENTS.Stud[XML_STUDENTS.numstud].first:='';
 XML_STUDENTS.Stud[XML_STUDENTS.numstud].house:=0;     XML_STUDENTS.Stud[XML_STUDENTS.numstud].sex:='';
 XML_STUDENTS.Stud[XML_STUDENTS.numstud].id:='';       XML_STUDENTS.Stud[XML_STUDENTS.numstud].tcclass:=0;

 //if (CustomerIDnum=cnMountainCreekSHS) then // only for MOUNTAIN CREEK STATE HIGH SCHOOL
 begin
  studID2[XML_STUDENTS.numstud]:='';
  studEmail[XML_STUDENTS.numstud]:='';
 end;

 XML_STUDENTS.Stud[XML_STUDENTS.numstud].tutor:=0;     XML_STUDENTS.Stud[XML_STUDENTS.numstud].home:=0;
 XML_STUDENTS.Stud[XML_STUDENTS.numstud].strrecord:=0;  XML_STUDENTS.Stud[XML_STUDENTS.numstud].tctag:=0;
 XML_STUDENTS.Stud[XML_STUDENTS.numstud].tcyear:=0;
 for j:=1 to nmbrChoices do
  XML_STUDENTS.Stud[XML_STUDENTS.numstud].choices[j]:=0;
 XML_STUDENTS.numstud := XML_STUDENTS.numstud - 1;
end;

procedure CountGroupSubs;
var
  i,j,k: Smallint;
begin
  try
    for i := 1 to nmbrSubyear do GroupSubCount[i]:=0;
    if XML_STUDENTS.NumStud > 0 then
    begin
      for i := 1 to groupnum do
      begin
        k := StGroup[i];
        if (sexbalance=0) or ((sexbalance=1)and(XML_STUDENTS.Stud[k].sex=genderShort[1]{'F'}))
        or ((sexbalance=2)and(XML_STUDENTS.Stud[k].sex=genderShort[0]{'M'})) then
          for j:=1 to chmax do
            if XML_STUDENTS.Stud[k].choices[j]>0 then
              Inc(GroupSubCount[GsubXref[XML_STUDENTS.Stud[k].choices[j]]]);
      end; {for i}
    end;
  except
  end;
end;

procedure studentPointerFemale;
var
 i8,i9,pos:     smallint;
begin
 pos:=1;
 for i9:=1 to GroupNum do
 begin
  i8:=StGroup[i9];
  if XML_STUDENTS.Stud[i8].Sex=genderShort[1]{'F'} then
  begin
   StPointer[pos]:=i8;
   inc(pos);
  end;
 end; {for i9}
(* sexGap:=pos;  *)
 for i9:=1 to GroupNum do
 begin
  i8:=StGroup[i9];
  if XML_STUDENTS.Stud[i8].Sex=genderShort[0]{'M'} then
  begin
   StPointer[pos]:=i8;
   inc(pos);
  end;
 end; {for i9}
end;

procedure studentPointerMale;
var
 i8,i9,pos:     smallint;
begin
 pos:=1;
 for i9:=1 to GroupNum do
 begin
  i8:=StGroup[i9];
  if XML_STUDENTS.Stud[i8].Sex=genderShort[0]{'M'} then
  begin
   StPointer[pos]:=i8;
   inc(pos);
  end;
 end; {for i9}
(* sexGap:=pos; *)
 for i9:=1 to GroupNum do
 begin
  i8:=StGroup[i9];
  if XML_STUDENTS.Stud[i8].Sex=genderShort[1]{'F'} then
  begin
   StPointer[pos]:=i8;
   inc(pos);
  end;
 end; {for i9}
end;

procedure studentPointerSet;
var
 i:     smallint;
begin
 try
  setlength(StPointer,(XML_STUDENTS.numStud+1)); {zero based so +1}
  case XML_DISPLAY.sexSelect of
   0: for i:=1 to XML_STUDENTS.numStud do StPointer[i]:=StGroup[i];
   1: studentpointerfemale;
   2: studentpointermale;
  end; {case}
 except
 end;
end;

procedure weightSolutions(st: integer);
 var
  j,k,k1,a,a1,aas,as1,weight:     integer;
  aa:       array[0..nmbrSolutions] of integer;
  r:        array[0..nmbrSubjects] of integer;
  max,place:                       integer;
begin
 fillchar(r,sizeof(r),chr(0));
 for j:=1 to nmbrChoices do r[XML_STUDENTS.Stud[st].choices[j]]:=1;
 for j:=1 to MyBlSolution do
  begin
   aa[j]:=0;
   for k:=1 to blnum do
    begin
     a:=BlClash[1,k];
     a1:=BlClash[j,k];
     if a<>a1 then
      begin
       aas:=GroupSubCount[GsubXref[a]]-r[a];
       as1:=GroupSubCount[GsubXref[a1]]-r[a1];
       weight:=aas-as1;
       inc(aa[j],weight);
      end;
    end; {for k}
   if linknum>0 then
    for k:=1 to blnum-1 do
     begin
      a:=BlClash[j,k];
      a1:=link[a];
      if a1>0 then
       for k1:=k+1 to blnum do
        if BlClash[j,k1]=a1 then inc(aa[j],20);
     end;
  end; {for j}
 for j:=1 to MyBlSolution do
  begin
   max:=-10000;  place:=0;
   for k:=1 to MyBlSolution do
    if aa[k]>max then
     begin
      max:=aa[k];
      place:=k;
     end;
   ClashOrder[j]:=place;
   aa[place]:=-10000;
  end; {for j}
end;  {Weight Solutions}

procedure removeFlag(a: integer);
var
 i:     integer;
begin
 for i:=1 to XML_DISPLAY.blocknum do
   if BlFlag[i]=a then BlFlag[i]:=0;
end;

function BlockDuplicates: boolean;
var
 a:     integer;
 duplicates: boolean;
 i5,j5,i6,j6:        integer;
 b,sub:          integer;

begin
 duplicates:=false;
 for i5:=1 to (XML_DISPLAY.blocknum-1) do
  begin
   a:=Sheet[i5,0];
   if a>0 then
    for j5:=1 to a do
     begin
      sub:=Sheet[i5,j5];
      if sub<>0 then
       for i6:=i5+1 to XML_DISPLAY.blocknum do
        begin
         b:=Sheet[i6,0];
         if b<>0 then
          for j6:=1 to b do
           begin
            if sub=Sheet[i6,j6] then duplicates:=true;
            if duplicates then break;
           end;{for j6}
         if duplicates then break;
        end; {for i6}
      if duplicates then break;
     end;  {for j5}
    if duplicates then break;
  end;   {for i5}
 result:=duplicates;
end;

procedure GetStClashes(st: integer);
var
 a,j:     integer;
 duplicates,HasSub: boolean;
 i1,j1:           integer;
 swapfrom1,swapfrom2,swapto1,swapto2: integer;
 b,pos,BaseNum,ClCount:     integer;
 subject:            integer;
 sublevel:           integer;
 SubHasClash:       array[0..nmbrChoices] of bool;

 procedure checkDuplicates;
  var
   ib1,ab,jb:               integer;
 begin
  for ib1:=1 to XML_DISPLAY.blocknum do
   begin
    ab:=Sheet[ib1,0];
    if ((ib1<>b) and (ab>0)) then
      for jb:=1 to ab do
       if ((Sheet[ib1,jb]=subject) and (BlFlag[ib1]>0) and (BlFlag[ib1]<>a)) then
        begin
         HasSub:=false;
         break;
        end;
    if not(HasSub) then break;
   end; {for ib1}
 end; {local checkDuplicates}

 procedure storeSolutions;
  var
   j:       integer;
   different: boolean;
  begin
   inc(MyBlSolution);
   for j:=1 to blnum do
    BlClash[MyBlSolution,j]:=BlWork[j];
   for j:=blnum+1 to blnum1 do
    BlClash[MyBlSolution,j]:=BlClash[0,j];
   if swapfrom2>0 then
    swapint(BlClash[MyBlSolution,swapfrom2],BlClash[MyBlSolution,swapto2]);
   if swapfrom1>0 then
    swapint(BlClash[MyBlSolution,swapfrom1],BlClash[MyBlSolution,swapto1]);
   if MyBlSolution<=1 then exit;
   {check for same solution as last one - can occur with duplicate subs in block}
   different:=false;
   for j:=1 to blnum1 do
    if BlClash[MyBlSolution,j]<>BlClash[MyBlSolution-1,j] then
     begin
      different:=true;
      break;
     end;
   if not(different) then dec(MyBlSolution);
  end;  {local storeSolutions}

 procedure moveUpLevel;
  var
   j,k:     integer;
  begin
   dec(sublevel);
   for j:=sublevel to blnum do
    for k:=1 to XML_DISPLAY.blocknum do
     if BlFlag[k]=BlClash[0,j] then BlFlag[k]:=0;
 end;   {local proc}

    function checkSplitSubs: boolean;
    var
     stmin,j,a3:     integer;
     stra,strb:              string;
    begin
     subject:=0;   stmin:=6000;
     stra:=copy(SubCode[a],1,lencodes[0]-1);
     for j:=1 to Sheet[b,0] do
     begin
      strb:=copy(SubCode[Sheet[b,j]],1,lencodes[0]-1);
      if stra=strb then
      begin
       a3:=GroupSubCount[GsubXref[Sheet[b,j]]];
       if a3<stmin then
       begin
        stmin:=a3;
        subject:=Sheet[b,j];
       end;
      end;
     end; {for j}
     result:=(subject>0);
    end; {local proc}

  procedure GetClashes;
  var
   j1T,j2:           integer;
  label clashStart;
  begin
   sublevel:=1;
   for j1T:=0 to nmbrBlocks do
    begin
     BlFlag[j1T]:=0;  blblock[j1T]:=0; BlWork[j1T]:=0;
    end;{for j1T}

   if blnum=0 then exit;
   clashStart:
   b:=blblock[sublevel];
   if (((b=XML_DISPLAY.blocknum) and (sublevel=1)) or (MyBlSolution=nmbrSolutions)) then exit;
   if b=XML_DISPLAY.blocknum then
    begin
     blblock[sublevel]:=0;
     moveUpLevel;
     goto clashStart;
    end; {if b=h}
   a:=BlClash[0,sublevel];
   if BlFlag[b]=a then removeFlag(a);
   inc(b);
   blblock[sublevel]:=b;
   if BlFlag[b]>0 then goto clashStart;
   HasSub:=checkSplitSubs;
   if (HasSub and duplicates) then checkDuplicates;
   if not(HasSub) then goto clashStart;
   BlFlag[b]:=a;
   BlWork[sublevel]:=subject;
   if duplicates then
    for j1T:=1 to XML_DISPLAY.blocknum do
     for j2:=1 to Sheet[j1T,0] do
      if Sheet[j1T,j2]=subject then BlFlag[j1T]:=a;
   if sublevel=blnum then
    begin
     storeSolutions;
     goto clashStart;
    end;
   inc(sublevel);
   goto clashStart;
  end;

begin
 duplicates:=Blockduplicates;
 BlPartial:=false; MyBlSolution:=0;
 for i1:=0 to nmbrSolutions do
  for j1:=0 to nmbrBlocks do BlClash[i1,j1]:=0;
 blnum:=0;  ClCount:=0;
 for j:=1 to nmbrChoices do
  begin
   a:=XML_STUDENTS.Stud[st].choices[j];
   pos:=GsubXref[a];
   if ((a>0) and (Blocktop[pos]=0)) then
    begin
     inc(blnum);
     BlClash[0,blnum]:=a;
     if CheckStudChoiceForClash(st,a) then
      begin inc(ClCount); SubHasClash[blnum]:=true; end else SubHasClash[blnum]:=false;
    end;
  end; {for j}
 blnum1:=blnum; BaseNum:=blnum;
 for j:=1 to nmbrChoices do
  begin
   a:=XML_STUDENTS.Stud[st].choices[j];
   pos:=GsubXref[a];
   if ((a>0) and (Blocktop[pos]=a)) then
    begin
     inc(blnum1);
     BlClash[0,blnum1]:=a;
    end;
  end; {for j}
 swapfrom1:=0;swapfrom2:=0;swapto1:=0;swapto2:=0;
 GetClashes;
 if ((MyBlSolution=0) and (ClCount>2)) then BlPartial:=true;
 if BlPartial then
  begin
   for i1:=1 to BaseNum do
    if SubHasClash[i1] then
     begin
      swapint(BlClash[0,i1],BlClash[0,BaseNum]);
      swapfrom1:=i1; swapto1:=BaseNum;
      blnum:=BaseNum-1;
      GetClashes;
      swapint(BlClash[0,i1],BlClash[0,BaseNum]);
     end;
   if ((MyBlSolution=0) and (ClCount>3)) then
    for i1:=1 to BaseNum-1 do
     if SubHasClash[i1] then
      for j1:= i1+1 to BaseNum do
       if SubHasClash[j1] then
        begin
         swapint(BlClash[0,i1],BlClash[0,BaseNum-1]);
         swapint(BlClash[0,j1],BlClash[0,BaseNum]);
         swapfrom1:=i1; swapto1:=BaseNum-1;
         swapfrom2:=j1; swapto2:=BaseNum;
         blnum:=BaseNum-2;
         GetClashes;
         swapint(BlClash[0,j1],BlClash[0,BaseNum]);
         swapint(BlClash[0,i1],BlClash[0,BaseNum-1]);
        end;
  end;
 blnum:=BaseNum;
 if MyBlSolution>0 then WeightSolutions(st);
 if (MyBlSolution=0) then BlPartial:=false;
end;  {end of getStclashes proc}

function hasstudentclash(i: smallint): bool;
//Returns whether the student has a clash
 var
  p,j,k,studclash,num,a:  smallint;
begin
 result:=false;
 for p:=1 to XML_DISPLAY.blocknum do
  begin
   BlInvert[p]:=false;
   studclash:=0; num:=Sheet[p,0];
   if (num<2) then continue;
   for j:=1 to chmax do
    begin
     a:=XML_STUDENTS.Stud[i].choices[j];
     if a=0 then continue;
     for k:=1 to num do
      begin
       if a=Sheet[p,k] then inc(studclash);
       if studclash>1 then
        begin
         result:=true;
         BlInvert[p]:=true;
         break;
        end;
      end; {k}
     if BlInvert[p] then break;
    end;{j}
  end; {p}
end; {has studentclash}

procedure countsubsinblock;
var
 i,j:     smallint;
begin
 subsinblock:=0;
 for i:=1 to XML_DISPLAY.blocknum do
   if Sheet[i,0]>0 then for j:=1 to Sheet[i,0] do
      if Sheet[i,j]>0 then inc(subsinblock);
 if subsinblock=0 then BlockLoad:=0
  else if (Blockday='') and (BlockFile='') then BlockLoad:=3;
end;

function CheckStudChoiceForClash(stnum,chnum: smallint): bool;
//Find dout if a certain student Choice has clash
// First find out if the student has clash, if so then find out if the given choice has a clash
var
 p,k:    smallint;
begin
 result:=false;
 if chnum=0 then exit;
 countsubsinblock;   //Get number of Subjects in a block
 if blockload=0 then exit; {no blocks}
 if not(hasstudentclash(stnum)) then exit; {no clashes}
 for p:=1 to XML_DISPLAY.blocknum do
  begin
   if not(BlInvert[p]) then continue; {no clashes in this block}
   for k:=1 to Sheet[p,0] do
    if chnum=Sheet[p,k] then  {subject is in block with a clash}
     begin
      result:=true;
      break;
     end;
  end; {p}
end;

procedure ClearMyStud(var MyStud: tpStudRec);
var
 i: integer;
begin
 MyStud.stname:=''; MyStud.first:='';
 for i:=0 to nmbrchoices do MyStud.Choices[i]:=0;
 MyStud.Sex:='';   MyStud.ID:='';
 MyStud.tcClass:=0;  MyStud.TcYear:=-1;
 MyStud.House:=0;  MyStud.tutor:=0;
 MyStud.home:=0;  MyStud.TcTag:=0;
 MyStud.strRecord:=0;
end;

function FNcm(a,b:  smallint):smallint;
var
 S1:     smallint;
begin
 S1:=((1+GroupSubs[0]) div 2);
 if a=b then
 begin
  result:=GroupSubCount[a];
  exit;
 end;
 if a>b then SwapInt(a,b);
 if a>S1 then
 begin
  a:=GroupSubs[0]+1-a;
  b:=GroupSubs[0]+1-b;
 end;
 result:=Cmatrix[a,b];
end;

procedure CalculateBlockClashes;
var
 i,j,k:       integer;
 A,B,D:       integer;
 ZZ:          integer;
begin
 BlockClashes[0]:=0; {totalcount}
 for i:=1 to XML_DISPLAY.blocknum do
 begin
  BlockClashes[i]:=0;
  D:=Sheet[i,0];
  if D>=2 then
  begin
   for j:=1 to (D-1) do
   begin
    A:=Sheet[i,j];
    if A<>0 then
    begin
     for k:=(j+1) to D do
     begin
      B:=Sheet[i,k];
      if B<>0 then
      begin
       try
        ZZ:=FNcm(GsubXref[a],GsubXref[b]);
        inc(BlockClashes[i],ZZ);
       except
         dbgi:=1969;
       end;
      end; {if B<>0}
     end; {for k}
    end; {if A<>0}
   end; {for j}
   inc(BlockClashes[0],BlockClashes[i]); {update totalcount}
  end; {if D>=2}
 end; {for i}
end;

procedure CalculateClashmatrix;
var
 i,j,k,iG:       smallint;
 S1,s2:          smallint;
 AA,BB,a,b:      smallint;
begin
 needClashMatrixRecalc:=false;
 S1:=((1+GroupSubs[0]) div 2);
 S2:=GroupSubs[0]+1;
 setlength(Cmatrix,S1+1,S2+1);
 for i:=1 to S1 do
  for j:=1 to S2 do
   Cmatrix[i,j]:=0;

 for i:=1 to GroupNum do
 begin
  iG:=StGroup[i];
  for j:=1 to chmax do
  begin
   AA:=XML_STUDENTS.Stud[iG].Choices[j];
   if AA<>0 then
   begin
    for k:=1 to chmax do
    begin
     BB:=XML_STUDENTS.Stud[iG].Choices[k];
     if BB<>0 then
     begin
      a:=GsubXref[AA];
      b:=GsubXref[BB];
      if a<b then
      begin
       if a>S1 then
       begin
        a:=GroupSubs[0]+1-a;
        b:=GroupSubs[0]+1-b;
       end;
        inc(Cmatrix[a,b]);
      end;  {if a<b}
     end;  {if B<>0}
    end;  {for k}
   end;  {if A<>0}
  end;  {for j}
 end;  {for i}

 CalculateBlockClashes;
end;

function GetStudentTtItem(var te,su,ro,Sttyear,Sttlevel: integer;st,D,P: integer): Boolean;
var
 Y,lowclass,rollclass:      integer;
 found:                   boolean;
 // #814
 Fix814: boolean;
 Choice814: integer;
 SavedChoice814: integer;


  procedure SearchLowLevel;
  var
   j,a: integer;
  begin
   for j:=1 to nmbrChoices do
    begin
     a:=XML_STUDENTS.Stud[st].Choices[j];
     if a<>0 then if a=FNT(D,P,Y,lowclass,0)^ then
     begin
      found:=true; Sttyear:=Y; Sttlevel:=lowclass; Choice814:=j;
      break;
     end;
    end;
  end;

  procedure SearchYear;
  var
   j,L,a: integer;
  begin
   for j:=1 to nmbrChoices do
   begin
    a:=XML_STUDENTS.Stud[st].Choices[j];
    if a<>0 then
     for L:=1 to level[Y] do
      if a=FNT(D,P,Y,L,0)^ then
      begin
       found:=true;  Sttyear:=Y; Sttlevel:=L; Choice814:=j;
       break;
      end;
    if found then break;
   end; {for j}
  end;

  procedure SearchYear814;
  var
   Y,j,L,a: integer;
  begin
   for j:=1 to nmbrChoices do
   begin
    a:=XML_STUDENTS.Stud[st].Choices[j];
    if a<>0 then
    begin
     for Y := years_minus_1 downto 0 do
     begin
     {*
         lowclass:=GetLevelTtClass(Y,rollclass);
         if a=FNT(D,P,Y,lowclass,0)^ then
         begin
           if j<Choice814 then
           begin
             found:=true;  Sttyear:=Y; Sttlevel:=lowclass; Choice814:=j;
            //break;
           end;
         end;
     *}
       for L:=1 to level[Y] do
       begin
         if a=FNT(D,P,Y,L,0)^ then
         begin
           if j<Choice814 then
           begin
             found:=true;  Sttyear:=Y; Sttlevel:=L; Choice814:=j;
            //break;
           end;
         end;
       end;
     end;
    end;
    if found then break;
   end; {for j}
  end;

begin
  try
    // #814
    Fix814 := true;
    Choice814:=9999;
    SavedChoice814:=9999;

    te:=0; su:=0; ro:=0;
    Sttyear:=0; Sttlevel:=0; rollclass:=XML_STUDENTS.Stud[st].Tcclass;
    found:=false;
    Y:=XML_STUDENTS.Stud[st].TcYear;    {search studs own year first}
    lowclass:=GetLevelTtClass(Y,rollclass);
    if lowClass>0 then
      SearchLowLevel;
    if not(found) then
      SearchYear;
    if (not(found)) and XML_DISPLAY.MatchAllYears then
    for Y:=years_minus_1 downto 0 do
    begin
      lowclass:=GetLevelTtClass(Y,rollclass);
      if lowClass>0 then SearchLowLevel;
      if not(found) then SearchYear;
      if found then break;
    end;
    if found then
    begin
      su:=FNT(D,P,Sttyear,Sttlevel,0)^;
      te:=FNT(D,P,Sttyear,Sttlevel,2)^;
      ro:=FNT(D,P,Sttyear,Sttlevel,4)^;
    end;

    // #814
    // need to search everywhere for an earlier choice
    if (Fix814 and XML_DISPLAY.MatchAllYears) then
    begin
      SavedChoice814 := Choice814;
      found:=false;
      SearchYear814;
      if found then
      begin
        su:=FNT(D,P,Sttyear,Sttlevel,0)^;
        te:=FNT(D,P,Sttyear,Sttlevel,2)^;
        ro:=FNT(D,P,Sttyear,Sttlevel,4)^;
      end;
    end;
  finally
    Result := Found;
  end;
end;

Procedure CheckCurrentYear;
var
 HasYear:       array[0..nmbrYears] of boolean;
 i,nm,k: integer;
begin
  for i:=0 to years do HasYear[i]:=false;
  for i:=1 to groupnum do
   begin
    nm:=StGroup[i];
    k:=XML_STUDENTS.Stud[nm].TcYear;
    if (k>=0) and (k<years) then HasYear[k]:=true;
   end;
  k:=0;
  for i:=0 to years-1 do
    if HasYear[i] then begin currentyear:=i;inc(k); end;
  if k>1 then currentyear:=-1;
end;

function checkGrSub(a:string): integer;
var
 i:  integer;
begin
 result:=0;
 for i:=1 to GroupSubs[0] do
  if SubCode[GroupSubs[i]]=a then
   begin
    result:=i;
    break;
   end;
end;

procedure splitlinks(SplitSu,classnum:integer;split:array of integer);
var
 i,j,k,a,b:  integer;
 i1,found1,found2:  integer;
begin
 for i:=1 to classnum do
  if link[GroupSubs[split[i]]]>0 then
   begin
    a:=GroupSubs[split[i]];
    b:=link[GroupSubs[split[i]]];
    for j:=1 to groupnum do
     begin
      i1:=StGroup[j];
      found1:=0;
      found2:=0;
      for k:=1 to chmax do
       begin
        if XML_STUDENTS.Stud[i1].choices[k]=splitSu then found1:=k;
        if XML_STUDENTS.Stud[i1].choices[k]=b then found2:=k;
       end; {k}
      if (found1>0) and (found2>0) then
       begin
        XML_STUDENTS.Stud[i1].Choices[found1]:=a;
        inc(GroupSubCount[split[i]]);
       end;
     end; {j}
   end;  {if}
end;

procedure NewSubCodepoint(place: integer);
var
 i,j:     integer;
begin
 inc(codeCount[0]);
 j:=codeCount[0];
 case XML_DISPLAY.sorttype[0] of
 0: begin
     codepoint[codeCount[0],0]:=place;
     exit;
    end;
 1: for i:=1 to (codeCount[0]-1) do
      if uppercase(SubCode[codepoint[i,0]])>uppercase(SubCode[place]) then
       begin j:=i; break; end;
 2: for i:=1 to (codeCount[0]-1) do
      if uppercase(Subname[codepoint[i,0]])>uppercase(Subname[place]) then
       begin j:=i; break; end;
 end; {case}
//shuffle rest up
 if j<codeCount[0] then
   for i:=codeCount[0] downto (j+1) do
     codepoint[i,0]:=codepoint[i-1,0];
//insert in correct place
 codepoint[j,0]:=place;
end;

procedure newsub(sub:string;splitSu:integer);
var
 found:  bool;
 place:  integer;
 j,l,insert:      integer;
 a:      string;

 procedure newname;
 begin
  a:=trim(Subname[splitSu]);
  Subname[place]:=a;
  l:=length(a);
  if (l>0) and (l<23) then
    a:=a+' '+sub[LenCodes[0]];
  Subname[place]:=a;
 end;

begin
 found:=false;
 place:=0;
 for j:=1 to NumCodes[0] do
  if SubCode[j]=sub then
   begin
    place:=j;
    found:=true;
    break;
   end;
 if not(found) then
   for j:=1 to NumCodes[0] do
    begin
     a:=copy(SubCode[j],1,2);
     if a='00' then
       begin
        place:=j;
        break;
       end;
    end; {j}
 if (GroupSubs[0]>=nmbrSubYear)
  or ((place=0) and not(found) and (NumCodes[0]>=nmbrSubjects)) then
  begin
   toomanysubs:=true;
   exit;
  end;
 if (place=0) and not(found) then
  begin
    inc(NumCodes[0]);
    place:=NumCodes[0]
  end;
 if (place>0) and not(found) then
  begin
    SubCode[place]:=sub;
    link[place]:=0;
    newname;
    SubReportCode[place]:=SubReportCode[splitSu];
    SubReportName[place]:=SubReportName[splitSu];
    NewSubCodepoint(place);
  end;

 inc(GroupSubs[0]);
 insert:=GroupSubs[0];
 for j:=1 to GroupSubs[0] do
  if SubCode[place]<SubCode[GroupSubs[j]] then
   begin
    insert:=j;
    break;
   end;
 if insert<GroupSubs[0] then
  for j:=GroupSubs[0] downto insert+1 do
   begin
    GroupSubs[j]:=GroupSubs[j-1];
    Blocktop[j]:=Blocktop[j-1];
    GroupSubCount[j]:=GroupSubCount[j-1];
   end;
 GroupSubs[insert]:=place;
 GroupSubCount[insert]:=0;
 Blocktop[insert]:=place;
 XrefGroupSubs;
 SaveSubsFlag:=True;
end;

procedure horsplit(Splitsu,clsize,classnum: integer;split:array of integer);
var
 i,i1,j,per,lev,snum,oldblock,sublevel:   integer;
 horclash:  array[0..nmbrblocks] of integer;
 horsplit:  array[0..30] of integer;
 order:  tpStudentData;
 count,Brange:           integer;
 place:                  integer;
label
 labelB,labelC;

function periodclash: integer;
var
 a,b,k,sum: integer;
begin
 sum:=0; result:=0;
 if lev<2 then exit;
 a:=Sheet[per,lev];
 for k:=1 to lev-1 do
  begin
   b:=Sheet[per,k];
   sum:=sum+FNcm(GsubXref[a],GsubXref[b]);
   result:=sum;
  end;
end;

function minplace: integer;
var
 per,max,j:  integer;
begin
 per:=0;
 max:=30000;
 for j:=Lblock to Hblock do
   if horclash[j]<max then
     begin
      max:=horclash[j];
      per:=j;
     end;
 if per>0 then horclash[per]:=30000 else BlFull:=true;
 result:=per;
end;

procedure OrderStudents;
var
 stclash:  tpStudentData;
 i2,i,j,k,l,a,pos,j2:  integer;
begin
 fillchar(stclash,sizeof(stclash),chr(0));
 for i2:=1 to groupnum do
  begin
   i:=StGroup[i2];
   stclash[i]:=0;
   for k:=1 to classnum do
    for j:=1 to chmax do
     begin
      a:=XML_STUDENTS.Stud[i].Choices[j];
      if a>0 then
        for l:=1 to Sheet[horsplit[k],0] do
          if a=Sheet[horsplit[k],l] then
            begin
              inc(stclash[i]);
              break;
            end;
     end; {j}
  end; {i2}
 pos:=1;
 for i:=classnum-1 downto 1 do
  for j2:=1 to groupnum do
   begin
    j:=StGroup[j2];
    if stclash[j]=i then
     begin
      order[pos]:=j;
      inc(pos);
     end;
   end;
 for j2:= 1 to groupnum do
  begin
   j:=StGroup[j2];
   if stclash[j]>=classnum then
     begin
      order[pos]:=j;
      inc(pos);
     end;
  end;
 for j2:= 1 to groupnum do
  begin
   j:=StGroup[j2];
   if stclash[j]=0 then
     begin
      order[pos]:=j;
      inc(pos);
     end;
  end;
end;

procedure AllocateChoice;
var
 R,F:  integer;
 found: bool;
 k,l,a:   integer;

label
 labelD;

procedure put;
begin
 XML_STUDENTS.Stud[i].Choices[j]:=GroupSubs[split[F]];
 inc(horclash[F]);  SaveStudFlag:=true; saveBlockFlag:=true;
 StudYearFlag[XML_STUDENTS.Stud[i].tcYear]:=true;
end;

procedure decrease;
begin
 dec(F);
 inc(R);
 if F=0 then F:=classnum;
end;

begin
 R:=0; F:=classnum;
 labelD:
 if horclash[F]>=clsize then
  begin
   decrease;
   if R<(2*classnum) then goto labelD;
  end;
 if R>classnum then
  begin
   put;
   exit;
  end;
 found:=false;
 for k:=1 to Sheet[horsplit[F],0] do
  for l:=1 to chmax do
   begin
    a:=XML_STUDENTS.Stud[i].Choices[l];
    if a>0 then
     if a=Sheet[horsplit[F],k] then
      begin
       found:=true;
       break;
      end;
    if found then break;
   end;
  if not(found) then put
   else
    begin
     decrease;
     goto labelD;
    end;
end;

begin
 place:=0;
 fillchar(order,sizeof(order),chr(0));
 for i:=0 to levelprint do
   Sheet[0,i]:=0;
 for per:=1 to XML_DISPLAY.blocknum do
  begin
   lev:=1+Sheet[per,0];
   Sheet[per,lev]:=splitSu;
   horclash[per]:=periodclash;
   Sheet[per,lev]:=0;
  end; {per}
 for i:=1 to classnum do
  begin
   snum:=GroupSubs[split[i]];
   oldblock:=findblock(snum,sublevel);
   if oldblock=0 then
    begin
     count:=1;
     Brange:=1+Hblock-Lblock;
     if (oldblock<Lblock) or (oldblock>Hblock) then oldblock:=Lblock;
     if i>Brange then
      begin
       labelB:
       oldblock:=random(Brange)+Lblock;
       inc(count);
       place:=Sheet[oldblock,0]+1;
       if (place>XML_DISPLAY.blocklevel) and (count<40) then goto labelB;
      end;
     if count=40 then
      begin
       inc(XML_DISPLAY.blocklevel); count:=1;
       if XML_DISPLAY.blocklevel>levelprint then
        begin
         XML_DISPLAY.blocklevel:=levelprint; BlFull:=true; oldblock:=0;
        end;
      end;
     if i<=Brange then
      begin
       labelC:
       oldblock:=minplace; inc(count);
       place:=Sheet[oldblock,0]+1;
       if (place>levelprint) and (count<40) and not(BlFull) then goto labelC
      end;
     if place>XML_DISPLAY.blocklevel then
      begin
       inc(XML_DISPLAY.blocklevel);
       if XML_DISPLAY.blocklevel>levelprint then XML_DISPLAY.blocklevel:=levelprint;
      end;
     Sheet[oldblock,0]:=place;
     Sheet[oldblock,place]:=GroupSubs[split[i]];
     if oldblock=0 then Blocktop[split[i]]:=GroupSubs[split[i]];
    end;
   horsplit[i]:=oldblock;
  end; {i}
 for i:=1 to classnum do
  horclash[i]:=GroupSubCount[split[i]];
  OrderStudents;
  for i1:=1 to groupnum do
   begin
    i:=order[i1];
    for j:=1 to chmax do
     if XML_STUDENTS.Stud[i].Choices[j]=splitSu then
      begin
       AllocateChoice;
       break;
      end;
   end; {i1}
 for i:=1 to classnum do
  GroupSubCount[split[i]]:=horclash[i];
end;

Procedure UpdateStudCalcs;
begin
 CountChmax;
 CalcTagsUsed;
 REselectgroup;
 getStudentFontWidths;
 rangeCheckSubyrSels(XML_DISPLAY.ClashMatrixSelection);
 studentPointerSet;
 SubSexCountFlg:=true;
 UpdateStudWins;
end;

function IsStudentInGroup(const pStudNo: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;

  case XML_DISPLAY.StudListType of
    1:
    begin
      for i := 1 to Length(ListStudentSelection) do
        if ListStudentSelection[i] = pStudNo then
        begin
          Result := True;
          Break;
        end;
    end;
    2:
    begin
      for i := 1 to GroupNum do           //
        if StPointer[i] = pStudNo then
        begin
          Result := True;
          Break;
        end;
    end;
  end;
end;


end.
