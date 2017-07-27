unit CustomOutput;

interface

uses sysutils,classes,Forms,Dialogs,Controls,TimeChartGlobals,ClassDefs, XML.TTABLE, XML.UTILS,
GlobalToTcAndTcextra, XML.DISPLAY, XML.TEACHERS, XML.STUDENTS;

 type TCustomOutWin=class(TOutputwin)
  public
    procedure head; override;
  private
    procedure WindarooCustomExport;
    procedure MarymountCustomExport2;
    procedure VCAsecCustomExport;
    procedure EvertonParkSHSCustomExport;
    procedure RollMarkerCustomExport1;
    procedure RollMarkerCustomExport2;
    procedure RollMarkerCustomExport3;
    procedure RollMarkerCustomExport4;
    procedure OberonCustomExport;
    procedure OberonExport2;
    procedure OberonExport1;
    procedure OberonExport0;
    procedure BurwoodGirlsHSCustomExport;
  public
    procedure BrisbaneDistEdCustomExport(const pStealth: Boolean = False);
  end;

const
 {customer constants}
  cnWindaroo=101;      //WINDAROO VALLEY STATE HIGH SCHOOL      July 2004
  cnPrinceAlfred=102;  //Prince Alfred College          July 2004
  cnMarymount=103;     //Marymount College   November 2004
  cnVCAsec=104;  //Victorian College Of The Arts Secondary School added in Dec 04)
  cnEvertonParkSHS=105;  //Everton Park Sltate High Scholl  Dec 2004
  cnBrisbaneDistEd=106;  //Brisbane School Of Distance Education Aug 2005
  cnOberon=107;        //Oberon High School  June 2006
  cnBurwoodGirlsHS=108;   //BURWOOD GIRLS HIGH SCHOOL Nov 2006
  cnBairnsdaleSC=109;  //Bairnsdale Secondary College Feb 2008
  //NASSAR BIN ABDULLA AL ATTYA INDEPENDENT SECONDARY SCHOOL   June 2008
  cnNassarBinAbdullaAlAttyaISS=110;   {now in single user version}

  //cnMountainCreekSHS=111; {MOUNTAIN CREEK STATE HIGH SCHOOL April 1009}

procedure CustomerSetup;
procedure Transfer1TextExport;
procedure Transfer2TextExport;
procedure Transfer3TextExport;
procedure Transfer4TextExport;
procedure TransferTextExport;
procedure ExportRollMarkerFiles;
procedure SetRollMarkerPath;
procedure CheckRollMarkerExport;
procedure OberonTrackChoices;
procedure OberonFindTeacher2(i,j: smallint; var ftc,frc: smallint);


implementation

uses
  tcommon, main, tcload, tcommon5, TrackChoices, STCommon, uAMGFamily, uAMGStudent,
  FamilyClash, uAMGConst;

var
 CustomOutWin:      TCustomOutWin;
 OberonTeCodesFound:       array[0..nmbrTeachers] of byte;  //for latest custom output of one record per teacher per subject choice
 FRollMarkerPath: string;

procedure TCustomOutWin.head;
begin
{ printw('Information');
 newline; newline;}
end;

procedure CustomerSetup;
begin
//custom text export menu activation
     if ((usrPasslevel=1) or (usrPasslevel=6)) then begin //for timetabler and supervisor only
        mainform.mnuTrackEnrolments1.Visible:=true;
    end;
    //OberonShow := true;
 case CustomerIDnum of

  cnWindaroo,cnVCAsec,cnEvertonParkSHS,cnBurwoodGirlsHS:
    begin
     mainform.Transfer1.Visible:=true;
    end;
  cnBrisbaneDistEd:
    begin
     MainForm.mniFileImportFamilyList.Visible := True;
     MainForm.Transfer1.Visible := True;
     mainform.Transfer1.Caption := 'Family Clashes ...';
     Transfer1Caption:='Family Clashes ...';
    end;
  cnPrinceAlfred:
    begin
     genderShort[0]:='B';
     genderShort[1]:='D';
     genderLong[0]:='Boarder';
     genderLong[1]:='Day Boy';
    end;

  cnMarymount:
    begin
     mainform.Transfer3.Visible:=true;
    end;
  cnOberon:
    begin
     mainform.Transfer1.Visible:=true;
     OberonShow:=true;
     //mainform.CustomA1.Caption:='Track Enrolments ...';
     //if ((usrPasslevel=1) or (usrPasslevel=6)) then  //for timetabler and supervisor only
     //   mainform.CustomA1.Visible:=true;
    end;
  cnNassarBinAbdullaAlAttyaISS:
    begin
     BaseDay[0]:='SUN. ';
     BaseDay[1]:='MON. ';
     BaseDay[2]:='TUE. ';
     BaseDay[3]:='WED. ';
     BaseDay[4]:='THU. ';
     SetDays;
    end;
 end; {case CustomerIDnum}
end;

function isTeachingSUBJECT(te, sub: integer):wordbool;
var
  aFnt: tpIntPoint;
  y,
  L,d,p   : integer;
  su  : integer;
  yn: wordbool;
begin
  yn:=false;
  for y := 0 to years_minus_1 do
  begin
    for L := 1 to level[y] do
    begin
     for d:=0 to days-1 do
      for p:=1 to tlimit[d] do
      begin
       aFnt := FNT(d, (p - 1), y, L, 2);
       if aFnt^ = te then
       begin
         dec(aFnt);
         su:=aFnt^;
         if su=sub then
         begin
          yn:=true;
          break;
         end;
       end;
      end; {for p}
      if yn then break;
    end; {for l}
    if yn then break;
  end; {for y}
  Result:=yn
end;

function IsSplitSub(asub: smallint):boolean;
var
 stra,strb: string;
 strc,strd: string;
 i:     smallint;
begin
 result:=false;
 if length(trim(SubCode[asub]))<>lencodes[0] then exit;     //can't be a split sub
 strb:=copy(SubCode[asub],1,lencodes[0]-1);
 for i:=1 to numCodes[0] do
 begin
  if length(trim(SubCode[i]))<>lencodes[0] then continue;     //can't be a split sub
  stra:=copy(SubCode[i],1,lencodes[0]-1);
  if (stra=strb) and (i<>asub) then  {possible split subject}
  begin   //now check for sequential last char
   strc:=copy(uppercase(SubCode[asub]),lencodes[0],1);
   strd:=copy(uppercase(SubCode[i]),lencodes[0],1);
   if abs(ord(strc[1])-ord(strd[1]))=1 then
   begin
    result:=true;
    break;
   end;
  end;
 end;
end;

procedure OberonTrackChoices;
begin
 if CheckAccessRights(6,38,true) then
  begin
   TrackChoicesDlg:=TTrackChoicesDlg.create(application);   {allocate dlg}
   TrackChoicesDlg.showmodal;
   TrackChoicesDlg.free;    {release dlg}
   CheckAccessRights(6,38,false)
  end;
end;

procedure TCustomOutWin.RollMarkerCustomExport1;
var
 j,m,n,tmpint,tmpint2,StrLen: smallint;
 tname,fname,Str: string;
//scourses.txt
//student id,class code,subject code,teacher code,year level

   procedure SendOut;
   begin
    with ourSafetyMemStream do
     begin
      StrLen:=length(Str);
      if StrLen>0 then Write(Pchar(@Str[1])^,StrLen);
     end;
   end;

begin
 tname:='SCOURSES.TMP';
 fname:='SCOURSES.TXT';
 try
  try
   ourSafetyMemStreamStr:='';
   ourSafetyMemStream:=TStringStream.Create(ourSafetyMemStreamStr);
   with ourSafetyMemStream do
    for j:=1 to XML_STUDENTS.numstud do
     for n:=1 to chmax do
      begin
       m:=XML_STUDENTS.Stud[j].Choices[n];
       if m<=0 then continue;
       Str:=delim2+XML_STUDENTS.Stud[j].ID+delim2; SendOut;     // Student ID
       Str:=delim+delim2+trim(SubCode[m])+delim2; SendOut;     //jon snyder's "class code" i.e. ENG7A
       if IsSplitSub(m) then Str:=copy(SubCode[m],1,lencodes[0]-1)   //jon snyder's "subject code" i.e. ENG7
        else Str:=SubCode[m];           //if not a split sub then print same
       Str:=delim+delim2+trim(Str)+delim2; SendOut;
       Str:=SubName[m]; Str:=delim+delim2+trim(Str)+delim2; SendOut; // subject name
       findteacher(j,n,tmpint,tmpint2);
       Str:=delim+delim2+trim(XML_TEACHERS.TeCode[tmpInt,0])+delim2; SendOut;  // teacher code
       Str:=delim+delim2+yearname[XML_STUDENTS.Stud[j].tcyear]+delim2; SendOut;  // Student year
       if (CustomerIDnum=cnBairnsdaleSC) then // only for Bairnsdale
        begin
         Str:=delim+delim2+housename[XML_STUDENTS.Stud[j].house]+delim2; SendOut;  // Student house
        end;
       Str:=endline; SendOut; // end of line
      end;
   SafelyStreamToFile(tname,fname);
  finally
   ourSafetyMemStream.Free;
  end;
 except
 end;

end;

procedure TCustomOutWin.RollMarkerCustomExport2;
var
 D,P,Y,L,sub,te,ro,StrLen:      smallint;
 aFnt:               tpintpoint;
 ss: string;
 tname,fname,Str: string;
//ttable.txt
//day (as a number),period,class code,subject code,teacher code,room,year level

   procedure SendOut;
   begin
    with ourSafetyMemStream do
     begin
      StrLen:=length(Str);
      if StrLen>0 then Write(Pchar(@Str[1])^,StrLen);
     end;
   end;

begin
 tname:='TTABLE.TMP';
 fname:='TTABLE.TXT';
 try
  try
   ourSafetyMemStreamStr:='';
   ourSafetyMemStream:=TStringStream.Create(ourSafetyMemStreamStr);
   with ourSafetyMemStream do
    For D:=0 to days-1 do
     For P:=0 to periods-1 do
      For Y:=0 to years_minus_1 do
       For L:=1 to level[Y] do
       begin
        aFnt:=FNT(D,P,Y,L,0);
        sub:=aFnt^; inc(aFnt);
        te:=aFnt^; inc(aFnt);
        ro:=aFnt^;
        if ((sub<=LabelBase) and ((sub>0) or (te>0) or (ro>0))) then
        begin
           //jon snyder's "class code" i.e. ENG7A
           //jon snyder's "subject code" i.e. ENG7
         if IsSplitSub(sub) then
          ss:=trim(copy(SubCode[sub],1,lencodes[0]-1))
         else
          ss:=trim(SubCode[sub]);   //if not a split sub then print same

         Str:=delim2+inttostr(D+1)+delim2; SendOut; // day number
         Str:=delim+delim2+inttostr(P+1)+delim2; SendOut; // time slot number
         Str:=delim+delim2+trim(Subcode[sub])+delim2; SendOut; // subject class code
         Str:=delim+delim2+trim(ss)+delim2; SendOut; // subject code
         Str:=SubName[sub]; Str:=delim+delim2+trim(Str)+delim2; SendOut; // subject name
         Str:=delim+delim2+trim(XML_TEACHERS.tecode[te,0])+delim2; SendOut; // teacher code
         Str:=delim+delim2+trim(XML_TEACHERS.tecode[ro,1])+delim2; SendOut; // room code
         Str:=delim+delim2+trim(yearname[Y])+delim2; SendOut; // year
         Str:=endline; SendOut; // end of line
        end;
       end;

   SafelyStreamToFile(tname,fname);
  finally
   ourSafetyMemStream.Free;
  end;
 except
 end;

 // Now also output a file of day/period times
  tname:='PERIODS.TMP';
 fname:='PERIODS.TXT';
 try
  try
   ourSafetyMemStreamStr:='';
   ourSafetyMemStream:=TStringStream.Create(ourSafetyMemStreamStr);
   with ourSafetyMemStream do
    For D:=0 to days-1 do
     For P:=0 to periods-1 do
      //For Y:=0 to yr do
       //For L:=1 to level[Y] do
       //begin
        //aFnt:=FNT(D,P,Y,L,0);
        //sub:=aFnt^; inc(aFnt);
        //te:=aFnt^; inc(aFnt);
        //ro:=aFnt^;
        //if ((sub<=LabelBase) and ((sub>0) or (te>0) or (ro>0))) then
        begin
           //jon snyder's "class code" i.e. ENG7A
           //jon snyder's "subject code" i.e. ENG7
         //if IsSplitSub(sub) then
         // ss:=trim(copy(SubCode[sub],1,lencodes[0]-1))
         //else
         // ss:=trim(SubCode[sub]);   //if not a split sub then print same

         Str:=delim2+inttostr(D+1)+delim2; SendOut; // day number
         Str:=delim+delim2+inttostr(P+1)+delim2; SendOut; // time slot number
         Str:=delim+delim2+timetostr(tsstart[D,P])+delim2; SendOut; // Start time
         Str:=delim+delim2+timetostr(tsend[D,P])+delim2; SendOut; // end time
         Str:=delim+delim2+TimeSlotName[D,P]+delim2; SendOut; // subject name
         Str:=delim+delim2+tsCode[D,P]+delim2; SendOut; // subject name
         Str:=delim+delim2+IntToStr(tsType[D,P])+delim2; SendOut; // subject name
         //Str:=delim+delim2+trim(tecode[te,0])+delim2; SendOut; // teacher code
         //Str:=delim+delim2+trim(tecode[ro,1])+delim2; SendOut; // room code
         //Str:=delim+delim2+trim(yearname[Y])+delim2; SendOut; // year
         Str:=endline; SendOut; // end of line
        end;
       //end;

   SafelyStreamToFile(tname,fname);
  finally
   ourSafetyMemStream.Free;
  end;
 except
 end;

 // Sentral
  tname:='TTSTRUCTURE.TMP';
 fname:='TTSTRUCTURE.TXT';
 try
  try
   ourSafetyMemStreamStr:='';
   ourSafetyMemStream:=TStringStream.Create(ourSafetyMemStreamStr);
   with ourSafetyMemStream do
    For D:=0 to days-1 do
     For P:=0 to periods-1 do
      //For Y:=0 to yr do
       //For L:=1 to level[Y] do
       //begin
        //aFnt:=FNT(D,P,Y,L,0);
        //sub:=aFnt^; inc(aFnt);
        //te:=aFnt^; inc(aFnt);
        //ro:=aFnt^;
        //if ((sub<=LabelBase) and ((sub>0) or (te>0) or (ro>0))) then
        begin
           //jon snyder's "class code" i.e. ENG7A
           //jon snyder's "subject code" i.e. ENG7
         //if IsSplitSub(sub) then
         // ss:=trim(copy(SubCode[sub],1,lencodes[0]-1))
         //else
         // ss:=trim(SubCode[sub]);   //if not a split sub then print same

         Str:=delim2+inttostr(D+1)+delim2; SendOut; // day number
         Str:=delim+delim2+inttostr(P+1)+delim2; SendOut; // time slot number
         Str:=delim+delim2+TimeSlotName[D,P]+delim2; SendOut; // subject name
         Str:=delim+delim2+timetostr(tsstart[D,P])+delim2; SendOut; // Start time
         Str:=delim+delim2+timetostr(tsend[D,P])+delim2; SendOut; // end time

        // Str:=delim+delim2+tsCode[D,P]+delim2; SendOut; // subject name
         case tsType[D,P] of
           1:  begin
                 Str:=delim+delim2+'Break'+delim2; SendOut;
               end;
           2:  begin
                 Str:=delim+delim2+'Other'+delim2; SendOut;
               end
         else
           Str:=delim+delim2+'Teaching'+delim2; SendOut;
         end;
         //Str:=delim+delim2+IntToStr(tsType[D,P])+delim2; SendOut; // subject name
         //Str:=delim+delim2+trim(tecode[te,0])+delim2; SendOut; // teacher code
         //Str:=delim+delim2+trim(tecode[ro,1])+delim2; SendOut; // room code
         //Str:=delim+delim2+trim(yearname[Y])+delim2; SendOut; // year
         Str:=endline; SendOut; // end of line
        end;
       //end;

   SafelyStreamToFile(tname,fname);
  finally
   ourSafetyMemStream.Free;
  end;
 except
 end;

end;

procedure TCustomOutWin.RollMarkerCustomExport3;
var
 j,StrLen: smallint;
 tname,fname,Str: string;
//students.txt
//student id,surname,first name,gender,year level,home group,status (ie 'current'),home group teacher code
//home group is our rollclass

   procedure SendOut;
   begin
    with ourSafetyMemStream do
     begin
      StrLen:=length(Str);
      if StrLen>0 then Write(Pchar(@Str[1])^,StrLen);
     end;
    end;

begin
 tname:='STUDENTS.TMP';
 fname:='STUDENTS.TXT';
 try
  try
   ourSafetyMemStreamStr:='';
   ourSafetyMemStream:=TStringStream.Create(ourSafetyMemStreamStr);
   with ourSafetyMemStream do
    for j:=1 to XML_STUDENTS.numstud do
    begin
     Str:=delim2+XML_STUDENTS.Stud[j].ID+delim2; SendOut; // student ID
     Str:=delim+delim2+XML_STUDENTS.Stud[j].StName+delim2; SendOut;  // Surname
     Str:=delim+delim2+XML_STUDENTS.Stud[j].First+delim2; SendOut;  // first name
     Str:=delim+delim2+XML_STUDENTS.Stud[j].Sex+delim2; SendOut;  // gender
     Str:=delim+delim2+yearname[XML_STUDENTS.Stud[j].tcyear]+delim2; SendOut; // year
     Str:=delim+delim2+ClassCode[XML_STUDENTS.Stud[j].TcClass]+delim2; SendOut; // roll class
     Str:=delim+delim2+'current'+delim2; SendOut; // 'current'
     Str:=endline; SendOut; // end of line
    end; {for j}
   SafelyStreamToFile(tname,fname);
  finally
   ourSafetyMemStream.Free;
  end;
 except
 end;
end;

procedure TCustomOutWin.RollMarkerCustomExport4;
var
 i,k,StrLen: smallint;
 tname,fname,Str: string;
//staff.txt
//teacher code,teacher name

   procedure SendOut;
   begin
    with ourSafetyMemStream do
     begin
      StrLen:=length(Str);
      if StrLen>0 then Write(Pchar(@Str[1])^,StrLen);
     end;
   end;

begin
 tname:='STAFF.TMP';
 fname:='STAFF.TXT';
 try
  try
   ourSafetyMemStreamStr:='';
   ourSafetyMemStream:=TStringStream.Create(ourSafetyMemStreamStr);
   with ourSafetyMemStream do
    if codeCount[1] > 0 then
     for k:=1 to codeCount[1] do
      begin
       i:=codepoint[k,1];
       Str:=delim2+trim(XML_TEACHERS.tecode[i,0])+delim2; SendOut; // teacher code
       Str:=delim+delim2+trim(XML_TEACHERS.tename[i,0])+delim2; SendOut; // teacher name
       Str:=endline; SendOut; // end of line
      end;
   SafelyStreamToFile(tname,fname);
  finally
   ourSafetyMemStream.Free;
  end;
 except
 end;
end;

procedure TCustomOutWin.EvertonParkSHSCustomExport;
var
 j,i,m,n,tmpint,tmpint2: smallint;
begin
 for j:=1 to groupnum do
 begin
  i:=StGroup[j];
  for n:=1 to chmax do
  begin
   m:=XML_STUDENTS.Stud[i].Choices[n];
   if m<=0 then continue;
    if m>0 then
    begin
     printw(XML_STUDENTS.Stud[i].ID);
     printc(XML_STUDENTS.Stud[i].StName);
     printc(XML_STUDENTS.Stud[i].First);
     printc(XML_STUDENTS.Stud[i].Sex);
     printc(yearname[XML_STUDENTS.Stud[i].tcyear]);
     printc(ClassCode[XML_STUDENTS.Stud[i].TcClass]);
     printc(trim(SubCode[m]));
     printc(trim(SubCode[m]));
     findteacher(i,n,tmpint,tmpint2);
     printc(trim(XML_TEACHERS.TeCode[tmpInt,0]));
     printc(trim(XML_TEACHERS.TeName[tmpInt,0]));
     newline;
    end;
  end; {for n}
 end; {for j}
end;

function OberonFindTeacher(i,j: smallint; var ftc,frc: smallint):smallint; {return tc}
var
 found:          wordbool;
 oldTC,tc,rc,sc:       smallint;
 p,l,d:        smallint;
 class1:         smallint;
 lowClass:       smallint;
 snu:            smallint;
 foundYR:        smallint;

 procedure checkClass;
 var d,p,y,y1,y2,l2,l21,l22:  smallint;
 begin
  if XML_DISPLAY.MatchAllYears then
  begin
   y1:=years_minus_1; y2:=0;   l21:=1; l22:=level[years_minus_1];
  end
  else
   begin
    y1:=foundYR; y2:=foundYR; l21:=l; l22:=l;
   end;
  for y:=y1 downto y2 do
  begin
   for d:=0 to days-1 do
    for p:=0 to periods-1 do
    begin
     if XML_DISPLAY.MatchAllYears then l22:=level[y];
     for l2:=l21 to l22 do
     begin
      sc:=word((FNT(d,p,y,l2,0))^);
      if sc=snu then
      begin
       oldTC:=tc;
       tc:=word((FNT(d,p,y,l2,2))^);
       if tc>0 then
       begin
        found:=true;
        OberonTeCodesFound[tc]:=1;
       end;
      end;
     end;
    end;
   end; {for y}
 end;

 function FNsc1:smallint;
 var l:   smallint;
 begin
  lowClass:=0;
  for l:=1 to level[foundYR] do
   if ClassCode[l]=ClassCode[class1] then
    if trim(ClassCode[l])<>'' then
    begin
     lowClass:=l;
     break;
    end;
    result:=lowclass;
 end;

begin
 found:=false;  tc:=0; ftc:=0; frc:=0;  result:=0;
 foundYR:=XML_STUDENTS.Stud[i].TcYear;
 snu:=XML_STUDENTS.Stud[i].Choices[j];
 class1:=XML_STUDENTS.Stud[i].TcClass;
 if XML_DISPLAY.MatchAllYears OR ((class1>0) and (class1<=level[foundYR])) then
 begin
  l:=class1;
  checkClass;
 end;
 if (class1>level[foundYR]) then
  if boolean(FNsc1) then
  begin
   l:=lowClass;
   checkClass;
  end;
 for p:=0 to periods-1 do
 begin
  for l:=1 to level[foundYR] do
  begin
   for d:=0 to days-1 do
   begin
    if word((FNT(d,p,foundYR,l,0))^)=word(snu) then
    begin
     oldTC:=tc;
     tc:=word((FNT(d,p,foundYR,l,2))^);
     rc:=word((FNT(d,p,foundYR,l,4))^);
     found:=true;
     ftc:=tc; frc:=rc;
     OberonTeCodesFound[tc]:=1;
    end;
   end;
  end;
 end;
end;

procedure TCustomOutWin.VCAsecCustomExport;
var
 i,j,n,m: smallint;
 tmpint,tmpint2,none,k: smallint;
begin

 for j:=1 to groupnum do
 begin
  i:=StGroup[j];
  for n:=1 to chmax do
  begin
   m:=XML_STUDENTS.Stud[i].Choices[n];
   if m<=0 then continue;
   fillchar(OberonTeCodesFound,sizeof(OberonTeCodesFound),chr(0));  //clear array
   OberonFindTeacher(i,n,tmpint,tmpint2);  //fill array
   none:=1;
   //output one record for each teacher found
   for k:=1 to NumCodes[1] do
   begin
    if OberonTeCodesFound[k]=0 then continue;
    none:=0;
    printw(XML_STUDENTS.Stud[i].ID);
    printc(XML_STUDENTS.Stud[i].StName);
    printc(XML_STUDENTS.Stud[i].First);
    printc(ClassCode[XML_STUDENTS.Stud[i].TcClass]);
    printc(yearname[XML_STUDENTS.Stud[i].tcyear]);
    printc(XML_STUDENTS.Stud[i].Sex);
    printc(TRIM(SubCode[m]));
    printc(XML_TEACHERS.TeCode[k,0]);
    printc(XML_TEACHERS.TeCode[XML_STUDENTS.Stud[i].Tutor,0]);
    newline;
   end;
   if none=1 then
   begin   //output at least one record - with empty teacher
    printw(XML_STUDENTS.Stud[i].ID);
    printc(XML_STUDENTS.Stud[i].StName);
    printc(XML_STUDENTS.Stud[i].First);
    printc(ClassCode[XML_STUDENTS.Stud[i].TcClass]);
    printc(yearname[XML_STUDENTS.Stud[i].tcyear]);
    printc(XML_STUDENTS.Stud[i].Sex);
    printc(TRIM(SubCode[m]));
    printc('');
    printc(XML_TEACHERS.TeCode[XML_STUDENTS.Stud[i].Tutor,0]);
    newline;
   end;
  end;
 end; {for i9}

end;

procedure TCustomOutWin.BrisbaneDistEdCustomExport(const pStealth: Boolean);
type
  tpfam = record
            stud: smallint;
            sub: smallint;
            onTT: smallint;
          end;
var
  i,j: smallint;
  //fam: array[0..nmbrstudents] of tpfam; //sub choices within family and which stud takes it
  //famNum: smallint;   //number of members in family
  //aFnt:               tpintpoint;
  lFamilies: TAMGFamilies;
  lFamily: TAMGFamily;
  lStudent: TAMGStudent;
  sc, ro, lYear, lev: Integer;
  lTeacher: Integer;
  lStudNo: Integer;
  lDay: Integer;
  lPeriod: Integer;
  lClashStr: string;
  lTempList: TStringList;
  lFamilyClash: TAMGFamilyClash;
  lFamilyClashTemp: TAMGFamilyClash;
  lFamilyClashesTemp: TAMGFamilyClashes;
  lFrmFamilyClash: TFrmFamilyClash;
  //lPrevStudentCode: string;
  lPrevDay: string;
  lPrevTimeSlot: string;
  lCurrentDir: string;
  lDataFound: Boolean;
begin
  Application.ProcessMessages;
  lFamilies := TAMGFamilies.Create;
  lTempList := TStringList.Create;
  if not Assigned(FamilyClashes) then
    FamilyClashes := TAMGFamilyClashes.Create;
  lFamilyClashesTemp := TAMGFamilyClashes.Create;
  lCurrentDir := GetCurrentDir;
  ChDir(Directories.DataDir);
  try
    lDataFound := True;
    lFamilies.RefreshFromFile;
    if (lFamilies.Count = 0) then
    begin
      if not pStealth then
        MessageDlg('No family data available.' + #13#10 + 'To import data Go to File menu an select Import Family List.', mtInformation, [mbOK], 0);
      lDataFound := False;
    end;
    if lDataFound then
    begin
      lTempList.Clear;
      for i := 0 to lFamilies.Count - 1 do
      begin
        lFamily := TAMGFamily(lFamilies.Items[i]);
        if lFamily.HasMultiStudents then
        begin
          for lDay := 0 to Days-1 do
          begin
            for lPeriod := 0 to Periods-1 do
            begin
              lFamilyClashesTemp.Clear;
              for j := 0 to lFamily.Students.Count - 1 do  //loop in the family students
              begin
                lStudent := TAMGStudent(TAMGFamily(lFamilies.Items[i]).Students.Items[j]);
                lStudNo := FindStudentByID(lStudent.Code);
                if GetStudentTtItem(lTeacher, sc, ro, lYear, lev, lStudNo, lDay, lPeriod) then
                begin
                  lFamilyClashTemp := TAMGFamilyClash.Create;
                  lFamilyClashTemp.FamilyCode := lFamily.FamilyCode;
                  lFamilyClashTemp.StudentCode := lStudent.Code;
                  lFamilyClashTemp.Day := DayName[lDay];
                  lFamilyClashTemp.TimeSlot := TimeSlotName[lDay, lPeriod];
                  lFamilyClashTemp.SubjectCode := SubCode[sc];
                  lFamilyClashesTemp.Add(lFamilyClashTemp);
                  {if not ((lStudent.Code = lPrevStudentCode) and
                          (DayName[lDay] = lPrevDay) and
                          (TimeSlotName[lDay, lPeriod] = lPrevTimeSlot)) then
                  begin
                    lTempList.Add(lFamily.FamilyCode + ',' + lStudent.Code + ',' + DayName[lDay] + ',' + TimeSlotName[lDay, lPeriod]);
                    lFamilyClash := TAMGFamilyClash.Create;
                    lFamilyClash.FamilyCode := lFamily.FamilyCode;
                    lFamilyClash.StudentCode := lStudent.Code;
                    lFamilyClash.Day := DayName[lDay];
                    lFamilyClash.TimeSlot := TimeSlotName[lDay, lPeriod];
                    lFamilyClashes.Add(lFamilyClash);
                    lPrevStudentCode := lStudent.Code;
                    lPrevDay := DayName[lDay];
                    lPrevTimeSlot := TimeSlotName[lDay, lPeriod];
                  end;}
                end; // if
              end;  // for j
              if lFamilyClashesTemp.Count > 1 then
                for j := 0 to lFamilyClashesTemp.Count - 1 do
                begin
                  if lFamilyClashesTemp.IsClash(j) then
                  begin
                    lFamilyClash := TAMGFamilyClash.Create;
                    lFamilyClash.FamilyCode := TAMGFamilyClash(lFamilyClashesTemp.Items[j]).FamilyCode;
                    lFamilyClash.StudentCode := TAMGFamilyClash(lFamilyClashesTemp.Items[j]).StudentCode;
                    lFamilyClash.Day := TAMGFamilyClash(lFamilyClashesTemp.Items[j]).Day;
                    lFamilyClash.TimeSlot := TAMGFamilyClash(lFamilyClashesTemp.Items[j]).TimeSlot;
                    lFamilyClash.SubjectCode := TAMGFamilyClash(lFamilyClashesTemp.Items[j]).SubjectCode;
                    lTempList.Add(lFamilyClash.FamilyCode + ',' +
                                  lFamilyClash.StudentCode + ',' +
                                  lFamilyClash.Day + ',' +
                                  lFamilyClash.TimeSlot);
                    if not FamilyClashes.IsClashAlreadyExist(lFamilyClash) then
                      FamilyClashes.Add(lFamilyClash);
                  end;
                end;  // for

            end;  // for
          end;  // for
          if lTempList.Count > 1 then
            lClashStr := lClashStr + lTempList.GetText;
        end; // if
      end;  // for
    end;  // if lDataFound
    if (FamilyClashes.Count > 0) and not pStealth then
    begin
      if FileExists(mainform.SaveDialog.Filename) then
      begin
        //DeleteFile(mainform.SaveDialog.Filename);
        //lTempList.SaveToFile(mainform.SaveDialog.Filename);
        printw(lTempList.Text);

      end;
      lFrmFamilyClash := TFrmFamilyClash.Create(Application);
      try
        lFrmFamilyClash.FamilyClashes := FamilyClashes;
        lFrmFamilyClash.ShowModal;
      finally
        FreeAndNil(lFrmFamilyClash);
      end;
    end;
  finally
    FreeAndNil(lFamilyClashesTemp);
    FreeAndNil(lTempList);
    FreeAndNil(lFamilies);
    ChDir(lCurrentDir)
  end;



  (*for i:=1 to RollClassPoint[0] do
  begin
    famNum:=0;
    for j:=1 to numstud do
    begin
      if stud[j].tcClass=i then
      begin
        for k:=1 to chmax do
        begin
          su:=Stud[j].Choices[k];
          if trim(SubCode[su])>'' then
          begin
            inc(famNum);
            fam[famNum].stud:=j;
            fam[famNum].sub:=su;
          end;
        end;
      end;
    end; {for j}
    if famNum<2 then
      continue;
    for D:=0 to days-1 do
      for P:=0 to periods-1 do
      begin
       for n:=1 to famNum do
         fam[n].onTT:=-1; //reset flag
       MultCount:=0;
       for Y:=0 to yr do
        for L:=1 to level[Y] do
        begin
          aFnt:=FNT(D,P,Y,L,0);
          sub:=aFnt^;
          if ((sub<=LabelBase) and (sub>0)) then
          begin
            //loop through fam subs to find duplicates
            for j:=1 to famNum do
            begin
              if fam[j].sub=sub then
              begin
                fam[j].onTT:=Y;
                inc(MultCount);
              end;
            end;
          end;
        end; {for l}
        if MultCount>1 then  //have clashing subjects so dump out to text file the details
        begin
          for j:=1 to famNum do
            if fam[j].onTT>-1 then
            begin
              k:=fam[j].stud;
              printw(ClassCode[Stud[k].TcClass]);
              printc(Stud[k].ID);
              printc(Stud[k].StName);
              printc(Stud[k].First);
              printc(TRIM(SubCode[fam[j].sub]));
              printc(dayname[D]);
              printc(TimeSlotName[D,P]);
              printc(yearname[fam[j].onTT]);
              newline;
            end; //if
        end; //if
      end; {for p}
  end; {for i}*)
end;

(*procedure TCustomOutWin.BrisbaneDistEdCustomExport;
type
  tpfam = record
            stud: smallint;
            sub: smallint;
            onTT: smallint;
          end;
var
  i,j,k,n,su,MultCount: smallint;
  fam: array[0..nmbrstudents] of tpfam; //sub choices within family and which stud takes it
  famNum: smallint;   //number of members in family
  D,P,Y,L,sub:      integer;
  aFnt:               tpintpoint;
begin
  for i:=1 to RollClassPoint[0] do
  begin
    famNum:=0;
    for j:=1 to numstud do
    begin
      if stud[j].tcClass=i then
      begin
        for k:=1 to chmax do
        begin
          su:=Stud[j].Choices[k];
          if trim(SubCode[su])>'' then
          begin
            inc(famNum);
            fam[famNum].stud:=j;
            fam[famNum].sub:=su;
          end;
        end;
      end;
    end; {for j}
    if famNum<2 then
      continue;
    for D:=0 to days-1 do
      for P:=0 to periods-1 do
      begin
       for n:=1 to famNum do
         fam[n].onTT:=-1; //reset flag
       MultCount:=0;
       for Y:=0 to yr do
        for L:=1 to level[Y] do
        begin
          aFnt:=FNT(D,P,Y,L,0);
          sub:=aFnt^;
          if ((sub<=LabelBase) and (sub>0)) then
          begin
            //loop through fam subs to find duplicates
            for j:=1 to famNum do
            begin
              if fam[j].sub=sub then
              begin
                fam[j].onTT:=Y;
                inc(MultCount);
              end;
            end;
          end;
        end; {for l}
        if MultCount>1 then  //have clashing subjects so dump out to text file the details
        begin
          for j:=1 to famNum do
            if fam[j].onTT>-1 then
            begin
              k:=fam[j].stud;
              printw(ClassCode[Stud[k].TcClass]);
              printc(Stud[k].ID);
              printc(Stud[k].StName);
              printc(Stud[k].First);
              printc(TRIM(SubCode[fam[j].sub]));
              printc(dayname[D]);
              printc(TimeSlotName[D,P]);
              printc(yearname[fam[j].onTT]);
              newline;
            end;
        end;  //if
      end; {for p}
  end; {for i}
end;*)

procedure TCustomOutWin.WindarooCustomExport;
var
 i,j,n: smallint;
 firstsub: smallint;
begin
 for j:=1 to codeCount[1] do
  begin
   firstSub:=0;
   i:=codepoint[j,1];
   printw(XML_TEACHERS.tecode[i,0]);  //teacher code
   for n:=1 to numcodes[0] do
   begin
    if isTeachingSUBJECT(i,n) then
    begin
     if firstSub=0 then begin printw(','); firstSub:=1; end
      else begin printw('.'); end;
     printw(SubCode[n]);  //subject code if teacher taking it on timetable
    end;
   end; {for n}
   newline;
  end; {for j}
end;

procedure TCustomOutWin.MarymountCustomExport2; {maintimetabletextCustomHillbrook}
var
 D,P,Y,L,sub,te,ro,pP,pO:      integer;
 aFnt:               tpintpoint;
begin
 For D:=0 to days-1 do
 begin
  pP:=0;  pO:=-1;
  For P:=0 to periods-1 do
   For Y:=0 to years_minus_1 do ///{Don't send highest year}
    For L:=1 to level[Y] do
    begin
     aFnt:=FNT(D,P,Y,L,0);
     sub:=aFnt^; inc(aFnt);
     te:=aFnt^; inc(aFnt);
     ro:=aFnt^;
     if ((sub<=LabelBase) and ((sub>0) or (te>0) or (ro>0))) then
     begin
      if (boolean(XML_DISPLAY.pyear[Y]) and boolean(XML_DISPLAY.dprint[D+1]) and boolean(XML_DISPLAY.TsOn[D,P])) then
      begin
       printw(trim(inttostr(D+1)));
       if P<>pO then
       begin
        inc(pP);
        pO:=P;
       end;
       printc(trim(inttostr(pP)));

       printc(trim(Subcode[sub]));
       printc(trim(yearname[Y]));
       printc(trim(XML_TEACHERS.tecode[te,0]));
       printc(trim(XML_TEACHERS.tecode[ro,1]));
       printc('');   //trailing comma as before
       newline;
      end; {if disp settings}
     end;
    end;

 end; {for D}
end;

procedure OberonFindTeacher2(i,j: smallint; var ftc,frc: smallint);
var
 found:          wordbool;
 oldTC,tc,rc,sc:       smallint;
 p,l,d:        smallint;
 class1:         smallint;
 lowClass:       smallint;
 snu:            smallint;
 foundYR:        smallint;
 multyTC:        wordbool;

 procedure checkClass;
 var d,p,y,y1,y2,l2,l21,l22:  smallint;
 begin
  if XML_DISPLAY.MatchAllYears then
  begin
   y1:=years_minus_1; y2:=0;   l21:=1; l22:=level[years_minus_1];
  end
  else
   begin
    y1:=foundYR; y2:=foundYR; l21:=l; l22:=l;
   end;
  for y:=y1 downto y2 do
  begin
   for d:=0 to days-1 do
    for p:=0 to periods-1 do
    begin
     if XML_DISPLAY.MatchAllYears then l22:=level[y];
     for l2:=l21 to l22 do
     begin
      sc:=word((FNT(d,p,y,l2,0))^);
      if sc=snu then
      begin
       oldTC:=tc;
       tc:=word((FNT(d,p,y,l2,2))^);
       if ((tc>0) and (oldTC>0) and (tc<>oldTC)) then multyTC:=true;
       if tc>0 then found:=true;
      end;
      if multyTC then break;
     end;
    end;
    if multyTC then break;
   end; {for y}
   if multyTC then found:=false;
   if multyTC then tc:=0; // don't show anything if multiple
 end;

 function FNsc1:smallint;
 var l:   smallint;
 begin
  lowClass:=0;
  for l:=1 to level[foundYR] do
   if ClassCode[l]=ClassCode[class1] then
    if trim(ClassCode[l])<>'' then
    begin
     lowClass:=l;
     break;
    end;
    result:=lowclass;
 end;

begin
 found:=false;  tc:=0; ftc:=0; frc:=0;
 foundYR:=XML_STUDENTS.Stud[i].TcYear;   multyTC:=false;
 snu:=XML_STUDENTS.Stud[i].Choices[j];
 class1:=XML_STUDENTS.Stud[i].TcClass;
 if XML_DISPLAY.MatchAllYears OR ((class1>0) and (class1<=level[foundYR])) then
 begin
  l:=class1;
  checkClass;
  if found then
  begin
   ftc:=tc;
   exit;
  end;
 end;
 if (class1>level[foundYR]) then
  if boolean(FNsc1) then
  begin
   l:=lowClass;
   checkClass;
   if found then
   begin
    ftc:=tc;
    exit;
   end;
  end;
 for p:=0 to periods-1 do
 begin
  for l:=1 to level[foundYR] do
  begin
   for d:=0 to days-1 do
   begin
    if word((FNT(d,p,foundYR,l,0))^)=word(snu) then
    begin
     oldTC:=tc;
     tc:=word((FNT(d,p,foundYR,l,2))^);
     rc:=word((FNT(d,p,foundYR,l,4))^);
     found:=true;
     if ((tc>0) and (oldTC>0) and (tc<>oldTC)) then multyTC:=true;
     ftc:=tc; frc:=rc;
    end;
    if multyTC then break;
   end;
   if multyTC then break;
  end;
  if multyTC then break;
 end;
 if multyTC then found:=false;
 if multyTC then tc:=0; // don't show anything if multiple
end;

procedure TCustomOutWin.OberonExport2;  //separate records
var
 i,j,m,n,tmpInt,tmpint2,k,none:   smallint;
begin
 for j:=1 to groupnum do
 begin
  i:=StGroup[j];
  for n:=1 to chmax do
  begin
   m:=XML_STUDENTS.Stud[i].Choices[n];
   if m<=0 then continue;
   fillchar(OberonTeCodesFound,sizeof(OberonTeCodesFound),chr(0));  //clear array
   OberonFindTeacher(i,n,tmpint,tmpint2);  //fill array

   none:=1;
   //output one record for each teacher found
   for k:=1 to NumCodes[1] do
   begin
    if OberonTeCodesFound[k]=0 then continue;
    none:=0;
    printw(XML_STUDENTS.Stud[i].ID);
    printc(XML_STUDENTS.Stud[i].StName);
    printc(XML_STUDENTS.Stud[i].First);
    printc(ClassCode[XML_STUDENTS.Stud[i].TcClass]);
    printc(yearname[XML_STUDENTS.Stud[i].tcyear]);
    printc(XML_STUDENTS.Stud[i].Sex);
    printc(TRIM(SubCode[m]));
    printc(XML_TEACHERS.TeCode[k,0]);
    printc(XML_TEACHERS.TeCode[XML_STUDENTS.Stud[i].Tutor,0]);
    printc(HouseName[XML_STUDENTS.Stud[i].House]);   //later minor modification request
    newline;
   end;
   if none=1 then
   begin   //output at least one record - with empty teacher
    printw(XML_STUDENTS.Stud[i].ID);
    printc(XML_STUDENTS.Stud[i].StName);
    printc(XML_STUDENTS.Stud[i].First);
    printc(ClassCode[XML_STUDENTS.Stud[i].TcClass]);
    printc(yearname[XML_STUDENTS.Stud[i].tcyear]);
    printc(XML_STUDENTS.Stud[i].Sex);
    printc(TRIM(SubCode[m]));
    printc('');
    printc(XML_TEACHERS.TeCode[XML_STUDENTS.Stud[i].Tutor,0]);
    printc(HouseName[XML_STUDENTS.Stud[i].House]);   //later minor modification request
    newline;
   end;
  end;
 end; {for i9}
end;

procedure TCustomOutWin.OberonExport1;  // use space
var
 i,j,k:  smallint;
begin
 for j:=1 to groupnum do
  begin
   i:=StGroup[j];
   printw(XML_STUDENTS.Stud[i].stname);
   printc(XML_STUDENTS.Stud[i].first);
   if XML_DISPLAY.sTsex then printc(XML_STUDENTS.Stud[i].Sex);
   if XML_DISPLAY.sTID then printc(XML_STUDENTS.Stud[i].ID);
   if XML_DISPLAY.sTclass then printc(ClassCode[XML_STUDENTS.Stud[i].TcClass]);
   if XML_DISPLAY.sTHouse then printc(Housename[XML_STUDENTS.Stud[i].House]);
   if XML_DISPLAY.sTtutor then printc(XML_TEACHERS.TeCode[XML_STUDENTS.Stud[i].Tutor,0]);
   if XML_DISPLAY.sThome then printc(XML_TEACHERS.TeCode[XML_STUDENTS.Stud[i].home,1]);
   if XML_DISPLAY.FAsubnum>0 then 
    for k:=1 to XML_DISPLAY.FAsubnum do
     begin
      if k=1 then
       printc(subcode[XML_STUDENTS.Stud[i].Choices[k]])
      else
       begin
        printw(' ');
        printw(subcode[XML_STUDENTS.Stud[i].Choices[k]]);
       end;
     end;
  newline;
 end; {for i9}
end;

procedure TCustomOutWin.OberonExport0;  //further custom for Oberon
var
 i,j,tmpInt,tmpint2,k:   smallint;
 strA: string;

       function tenameSpec(myte:integer):string;
       var
        strA,strB: string;
        pos1:      integer;
       begin
        strA:=''; strB:='';result:='';
        if trim(XML_TEACHERS.TeCode[myte,0])>'' then
         begin
          pos1:=pos(',',XML_TEACHERS.TeName[myte,0]);
          strA:=copy(XML_TEACHERS.TeName[myte,0],1,pos1-1);
          strB:=trim(copy(XML_TEACHERS.TeName[myte,0],pos1+1,length(XML_TEACHERS.TeName[myte,0])));
          strB:=copy(strB,1,1);
          result:=strA+' '+strB;
         end;
       end;

begin
 for j:=1 to groupnum do
 begin
  if XML_DISPLAY.FAsubnum>0 then
   for k:=1 to XML_DISPLAY.FAsubnum do
   begin
    i:=StGroup[j];
    if trim(subcode[XML_STUDENTS.Stud[i].Choices[k]])>'' then
    begin
     printw(XML_STUDENTS.Stud[i].stname);
     printc(XML_STUDENTS.Stud[i].first);
     IF boolean(XML_DISPLAY.sTsex) THEN printc(XML_STUDENTS.Stud[i].Sex);
     IF boolean(XML_DISPLAY.sTID) THEN printc(XML_STUDENTS.Stud[i].ID);
     IF boolean(XML_DISPLAY.sTclass) THEN printc(ClassCode[XML_STUDENTS.Stud[i].TcClass]);
     IF boolean(XML_DISPLAY.sTHouse) THEN printc(Housename[XML_STUDENTS.Stud[i].House]);
     IF boolean(XML_DISPLAY.sTtutor) THEN printc(XML_TEACHERS.TeCode[XML_STUDENTS.Stud[i].Tutor,0]);
     IF boolean(XML_DISPLAY.sThome) THEN printc(XML_TEACHERS.TeCode[XML_STUDENTS.Stud[i].home,1]);
     printc(subcode[XML_STUDENTS.Stud[i].Choices[k]]);

(* modifying customisation for Oberon by adding four new fields   *)

     if boolean(XML_DISPLAY.styear) then printc(yearname[XML_STUDENTS.Stud[i].TcYear]);  //year level
     IF boolean(XML_DISPLAY.sTtutor) THEN
        printc(tenameSpec(XML_STUDENTS.Stud[i].Tutor));  //tutor name
     // get subject teacher into tmpint
     OberonFindTeacher2(i,k,tmpint,tmpint2);

     if trim(XML_TEACHERS.TeCode[tmpInt,0])>'' then strA:=XML_TEACHERS.TeCode[tmpint,0]
      else strA:='';
     printc(strA); //subject teacher code
      //SURNAME,First Name (Surname in Upper Case, then a comma, then Title case for first name)
      //WANT Surname and only first letter of christian name

     printc(tenameSpec(tmpInt));  //subject teacher name in format specified

     newline;
    end;
   end; {for k}
 end; {for i9}
end;

procedure TCustomOutWin.OberonCustomExport;  //further custom for Oberon
begin
 case XML_DISPLAY.OberonOutputType of
  0: OberonExport0;  //use separator
  1: OberonExport1;   //use space
  2: OberonExport2; //separate records
 end;
end;

procedure TCustomOutWin.BurwoodGirlsHSCustomExport;
var
 i1,studnum:    integer;
 Iy,dI,Il,j:      integer;
 a,b,p,sc,l,Lowclass:                    integer;
 found:                   boolean;
 aStr,bStr,aastr:                    string;
 lev:                 integer;
 yrf1,yrf2:                  integer;
 aFnt: tpIntPoint;
begin
 if groupnum>0 then
  for i1:=1 to groupnum do
   begin
    studnum:=StGroup[i1];
    lev:=0; sc:=0;
    for dI:=0 to days-1 do        //asked to be sorted by day before periods on 27 nov 06
     for p:=0 to (tlimit[dI]-1) do
      begin
       found:=false;
       lowClass:=0;
       yrf1:=XML_STUDENTS.Stud[studnum].TcYear;
       yrf2:=XML_STUDENTS.Stud[studnum].TcYear;
       if XML_DISPLAY.MatchAllYears then begin yrf1:=years_minus_1; yrf2:=0; end;
       for Iy:=yrf1 downto yrf2 do
        begin
         for l:=1 to level[Iy] do
          if ClassCode[ClassShown[l,Iy]]=ClassCode[XML_STUDENTS.Stud[studnum].Tcclass] then
           if trim(ClassCode[ClassShown[l,Iy]])<>'' then
            begin
             lowClass:=l;
             break;
            end;
         if lowClass>0 then
          for j:=1 to nmbrChoices do
           begin
            a:=XML_STUDENTS.Stud[studnum].Choices[j];;
            if a<>0 then if a=FNT(dI,p,Iy,lowClass,0)^ then
             begin
              found:=true;
              lev:=lowClass;
              sc:=a;
              break;
             end;
           end;

       if not(found) then
        for j:=1 to nmbrChoices do
         begin
          a:=XML_STUDENTS.Stud[studnum].Choices[j];
          if a<>0 then
           for Il:=1 to level[Iy] do
            begin
             aFnt:=FNT(dI,p,Iy,Il,0);
             sc:=aFnt^;
             if a=sc then
              begin
               found:=true;
               lev:=Il;
               break;
              end;
            end; {for Il}
          if found then break;
         end; {for j}
        if found then break;
       end; {for Iy}

       if found then
        begin
         Il:=lev;
         aStr:=trim(subcode[sc]);
         aFnt:=FNT(dI,p,Iy,Il,2);
         aaStr:=trim(XML_TEACHERS.tecode[(aFnt)^,0]);
         aFnt:=FNT(dI,p,Iy,Il,4);
         bStr:=trim(XML_TEACHERS.tecode[(aFnt)^,1]);
         printw(XML_STUDENTS.Stud[studnum].ID);
         printc(XML_STUDENTS.Stud[studnum].stname);
         printc(XML_STUDENTS.Stud[studnum].first);
         printc(dayname[dI]);
         printc(tsCode[dI,p]);
         printc(astr);  //sub
         printc(aastr);  //te
         printc(bstr);  //ro
         newline;
        end; {if found}
     end; {for p}
   end;  {for il}
end;

procedure Transfer1TextExport;
begin    { START  of main text proc}
 CustomOutWin:=TCustomOutWin.create;
 with CustomOutWin do
 try
  case CustomerIDnum of
   cnWindaroo:  WindarooCustomExport;
   cnVCAsec:  VCAsecCustomExport;
   cnEvertonParkSHS: EvertonParkSHSCustomExport;
   cnBrisbaneDistEd: BrisbaneDistEdCustomExport;
   cnOberon: OberonCustomExport;
   cnBurwoodGirlsHS: BurwoodGirlsHSCustomExport;
  end;
 finally
  CustomOutWin.Free;
 end;
end;

procedure Transfer2TextExport;
begin    { START  of main text proc}
 CustomOutWin:=TCustomOutWin.create;
 with CustomOutWin do
 try
  case CustomerIDnum of
   0:  ;
  end;
 finally
  CustomOutWin.Free;
 end;
end;

procedure Transfer3TextExport;
begin    { START  of main text proc}
 CustomOutWin:=TCustomOutWin.create;
 with CustomOutWin do
 try
  case CustomerIDnum of
   cnMarymount:  MarymountCustomExport2;

  end;
 finally
  CustomOutWin.Free;
 end;
end;

procedure Transfer4TextExport;
begin    { START  of main text proc}
 CustomOutWin:=TCustomOutWin.create;
 with CustomOutWin do
 try
  case CustomerIDnum of
   0: ;
  end;
 finally
  CustomOutWin.Free;
 end;
end;

procedure TransferTextExport;
var
 i,j,n,m: smallint;
 tmpint,tmpint2: smallint;
begin    { START  of main text proc}
 CustomOutWin:=TCustomOutWin.create;
 with CustomOutWin do
 try
  for j:=1 to groupnum do
   begin
    i:=StGroup[j];
    for n:=1 to chmax do
     begin
      m:=XML_STUDENTS.Stud[i].Choices[n];
      if m<=0 then continue;
      printw(XML_STUDENTS.Stud[i].ID);
      printc(XML_STUDENTS.Stud[i].StName);
      printc(XML_STUDENTS.Stud[i].First);
      if XML_DISPLAY.sTyear then printc(yearname[XML_STUDENTS.Stud[i].tcyear]);
      if XML_DISPLAY.stSex then printc(XML_STUDENTS.Stud[i].Sex);
      if XML_DISPLAY.stClass then printc(ClassCode[XML_STUDENTS.Stud[i].TcClass]);
      if XML_DISPLAY.stHouse then printc(HouseName[XML_STUDENTS.Stud[i].house]);
      if XML_DISPLAY.stTutor then printc(XML_TEACHERS.Tecode[XML_STUDENTS.Stud[i].tutor,0]);
      if XML_DISPLAY.stHome then printc(XML_TEACHERS.Tecode[XML_STUDENTS.Stud[i].home,1]);
      printc(SubCode[m]);  printc(SubName[m]);
      findteacher(i,n,tmpint,tmpint2);
      printc(XML_TEACHERS.TeCode[tmpInt,0]);
      printc(XML_TEACHERS.TeName[tmpInt,0]);
      newline;
     end;
   end; {for i9}
 finally
  CustomOutWin.Free;
 end;
end;

procedure ExportRollMarkerFiles;
var
 oldTtfilename: string;
 needReloadTT: wordbool;
begin
 if trim(FileNames.CurentTimeTable)='' then exit;  //hasn't been set yet, wait till it has been set
 delim:=',';   delim2:=chr(XML_DISPLAY.txtlim); if XML_DISPLAY.txtlim=0 then delim2:='';
 //load ttable in use first if not already loaded
 needReloadTT:=false;
 if Uppercase(FileNames.CurentTimeTable)<>Uppercase(FileNames.LoadedTimeTable) then
 begin
  needReloadTT:=true;
  oldTtfilename:=FileNames.LoadedTimeTable;
  chdir(Directories.datadir);
  FileNames.LoadedTimeTable:=FileNames.CurentTimeTable;
  getTTable;
  SetTimeCell;
  SetDays;
 end;

 with CustomOutWin do
 begin
  SetCurrentDir(FRollMarkerPath);
  if RollMarkerExport1 then RollMarkerCustomExport1;
  if RollMarkerExport2 then RollMarkerCustomExport2;
  if RollMarkerExport3 then RollMarkerCustomExport3;
  if RollMarkerExport4 then RollMarkerCustomExport4;
 end;

 //reload ttable that was open if needed
 if needReloadTT then
 begin
  FileNames.LoadedTimeTable:=oldTtfilename;  //restore orig filename
  chdir(Directories.datadir);
  getTTable;
  SetTimeCell;
  SetDays;
 end;

 //reset flags
 RollMarkerExport1:=false;
 RollMarkerExport2:=false;
 RollMarkerExport3:=false;
 RollMarkerExport4:=false;
end;

procedure SetRollMarkerPath;
var
  lStrList: TStringList;
  lCurrentDir: string;
  lDir: string;
begin
  lCurrentDir := GetCurrentDir;
  SetCurrentDir(Directories.ProgDir);
  lStrList := TStringList.Create;
  Application.ProcessMessages;
  try
    if FileExists(AMG_ROLLMARKER_FILE) then
    begin
        lStrList.LoadFromFile(AMG_ROLLMARKER_FILE);
        lDir := Trim(lStrList.GetText);
        try
          if DirectoryExists(lDir) then
            FRollMarkerPath := lDir
          else
            FRollMarkerPath := Directories.DataDir;
        except
          FRollMarkerPath := Directories.DataDir;
        end;
    end;
  finally
    SetCurrentDir(lCurrentDir);
    FreeAndNil(lStrList);
  end;
end;

procedure saveOutRMFile;
var
 j: smallint;
 tmpF,f: file;
 sz:  longint;
 dt: tdatetime;

  Procedure WriteDateSize(FileName: string);
  begin
   if fileexists(FileName) then
    begin
     FileAge(FileName,dt);
     doAssignFile(tmpF,FileName); Reset(tmpF,1);
     try sz:=FileSize(tmpF); finally CloseFile(tmpF); end;
    end
   else
    begin dt:=now; sz:=0; end;
   blockwrite(f,dt,sizeof(dt)); blockwrite(f,sz,sizeof(sz));
  end;

begin
 if trim(FileNames.CurentTimeTable)='' then exit;  //hasn't been set yet, wait till it has been set
 try
  try
   doAssignFile(f,RollMarkerCheckFile);
   rewrite(f,1);
   WriteDateSize(FileNames.CurentTimeTable+XMLHelper.getTTW_EXTENSION('',JustTheExtension));
   WriteDateSize('SUBCODE.DAT');
   WriteDateSize('TECODE.DAT');
   WriteDateSize('ROOMS.DAT');
   WriteDateSize('CLASS.DAT');
   for j:=1 to years do WriteDateSize('CHOICE'+trim(inttostr(j))+'.ST');
  finally
   closefile(f);
  end;
 except
 end;
end;

procedure CheckRollMarkerExport;
var
 f,fCmp: file;
 j: smallint;
 msg: string;
 sz,szCmp:  longint;
 dt,dtCmp: tdatetime;
 msgret:      word;
 lAmtTransferred: Integer;

  Function CheckWriteDateSize(FileName: string): boolean;
  begin
   BlockRead(f, dt, sizeOf(dt), lAmtTransferred);
   BlockRead(f, sz, sizeOf(sz), lAmtTransferred);
   if fileexists(FileName) then
    begin
     FileAge(FileName,dtCmp);
     doAssignFile(fCmp,FileName); Reset(fCmp,1);
     try szCmp:=FileSize(fCmp); finally CloseFile(fCmp); end;
    end
   else
    begin dtCmp:=now; szCmp:=0; end;

   result:=((dt<>dtCmp) or (sz<>szCmp))
  end;

begin
 if not(RollMarkerFlg) or not (DirectoryExists(Directories.DataDir)) then exit;

 SetRollMarkerPath;
 SetCurrentDir(FRollMarkerPath);
 if not(fileExists(RollMarkerCheckFile)) or not(fileExists('Scourses.txt'))
    or not(fileExists('ttable.txt')) or not(fileExists('students.txt'))
    or not(fileExists('staff.txt'))  then
  begin
   RollMarkerExport1:=true;
   RollMarkerExport2:=true;
   RollMarkerExport3:=true;
   RollMarkerExport4:=true;
  end
 else      try
   try
    doAssignFile(f,RollMarkerCheckFile);
    reset(f,1);
    if CheckWriteDateSize(FileNames.CurentTimeTable+XMLHelper.getTTW_EXTENSION('',JustTheExtension)) then
     begin
      RollMarkerExport1:=true;
      RollMarkerExport2:=true;
      RollMarkerExport3:=true;
     end;
    if CheckWriteDateSize('SUBCODE.DAT') then
     begin
      RollMarkerExport1:=true;
      RollMarkerExport2:=true;
     end;
    if CheckWriteDateSize('TECODE.DAT') then
     begin
      RollMarkerExport1:=true;
      RollMarkerExport2:=true;
      RollMarkerExport4:=true;
     end;
    if CheckWriteDateSize('ROOMS.DAT') then RollMarkerExport2:=true;
    if CheckWriteDateSize('CLASS.DAT') then
     begin
      RollMarkerExport1:=true;
      RollMarkerExport2:=true;
      RollMarkerExport3:=true;
     end;

    for j:=1 to years do
     if CheckWriteDateSize('CHOICE'+trim(inttostr(j))+'.ST') then
      begin
       RollMarkerExport1:=true;
       RollMarkerExport3:=true;
      end;

   finally
    closefile(f);
   end;
  except
  end;

 if RollMarkerExport1 or RollMarkerExport2
  or RollMarkerExport3 or RollMarkerExport4 then
 begin
  if SilentCheckAccessRights(utStud,43,true) then  //for all non general users
  begin
   if (CustomerIDnum=cnBairnsdaleSC) then
    begin
     msg:='Do you want to create'+chr(10);
     msg:=msg+'attendance text files?';
     msgret:=messagedlg(msg,mtWarning,[mbNo,mbYes,mbCancel],0);
     if msgret<>mrYes then
      begin
       SilentCheckAccessRights(utStud,43,false);
       exit;
      end;
     XML_DISPLAY.MatchAllYears:=true; // requested by Bairnsdale
    end;
   saveOutRMFile;
   ExportRollMarkerFiles;
   SilentCheckAccessRights(utStud,43,false)
  end;
 end;
  ChDir(Directories.datadir);
end;

end.
