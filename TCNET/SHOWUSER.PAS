unit Showuser;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Menus,ClassDefs, ExtCtrls, XML.UTILS, XML.USERS, GlobalToTcAndTcextra;

type
  TShowUsersWin = class(TCodeWin)
    PopupMenu1: TPopupMenu;
    add2: TMenuItem;
    Change2: TMenuItem;
    Delete2: TMenuItem;
    N6: TMenuItem;
    Print2: TMenuItem;
    PrintSetup2: TMenuItem;
    Copy1: TMenuItem;
    Timer1: TTimer;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure add2Click(Sender: TObject);
    procedure Change2Click(Sender: TObject);
    procedure Delete2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  protected
    procedure PaintItem(i:integer;SelFlag:boolean); override;
    procedure SetTabs; override;
    procedure PaintHead; override;
  public
    procedure ResetUsers;
  end;

 procedure ShowUsersWinPrint;
 procedure ShowUsersWinOut;

var
  ShowUsersWin: TShowUsersWin;



implementation
uses tcload,tcommon,tcommon2,main,printers,TimeChartGlobals,tcommon5;
{$R *.DFM}

 type TPrintShowUsersWin=class(TPrintCodeWin)
  public
   procedure head; override;
   procedure SetTabs; override;
 end;

 type TOutShowUsersWin=class(TOutCodeWin)
  public
   procedure head; override;
   function CodeToPrint(i:integer):string; override;
 end;

var
 PrintShowUsersWin: TPrintShowUsersWin;
 OutShowUsersWin: TOutShowUsersWin;
 InTimerRoutine: bool;  //prevent reentry
 LastUsrOnCheck: TDateTime;
 UsrDataDir,UsrOn,UsrTt,UsrDate,UsrDataSect: array of string;
 UsrRead: array of boolean;

procedure TShowUsersWin.ResetUsers;
var
 i: integer;
begin
 if UserRecordsCount>0 then
  begin
   for i:=1 to UserRecordsCount do UsrRead[i]:=true;
   UpdateWindow(wnShowUsers);
  end;
end;



procedure TShowUsersWin.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 Action:= caFree;
end;

procedure TShowUsersWin.FormCreate(Sender: TObject);
var
 i: integer;
begin
 setWindowDefaults(self,wnShowUsers);
 Setlength(UsrRead,UserRecordsCount+22);
 for i:=1 to UserRecordsCount+20 do UsrRead[i]:=true;
end;


procedure TShowUsersWin.PaintHead;
begin
 codeColor:=cpTeach; {teacher}
 printw2('Users: ',inttostr(UserRecordsCount));
 newline;
 if TotalCodes>0 then
   case winView[wnShowUsers] of
    1: begin  {code + name}
        fcolor(cpNormal); printwl('User ID');
        x:=Tabs[1]; printw('Access level');
        x:=Tabs[2]; printw('User display folder');
        x:=Tabs[3]; printw('On');
        x:=Tabs[4]; printw('Data folder');
        x:=Tabs[5]; printw('Timetable');
        x:=Tabs[6]; printw('Time');
        x:=Tabs[7]; printw('Data');
       end;
   end;
 newline;
end;

function getUsernameMaxWidths(mycanvas:Tcanvas):smallint;
var
 mw,i,a: smallint;
begin
 mw:=10;
 if UserRecordsCount>0 then
  for i:=1 to UserRecordsCount do
   begin
    a:=mycanvas.textwidth(passID[i]);
    if a>mw then mw:=a;
   end;
 result:=mw;
end;

function getUserDirMaxWidths(mycanvas:Tcanvas):smallint;
var
 mw,i,a: smallint;
begin
 mw:=10;
 if UserRecordsCount>0 then
  for i:=1 to UserRecordsCount do
   begin
    a:=mycanvas.textwidth(passUserDir[i]);
    if a>mw then mw:=a;
   end;
 result:=mw;
end;

function getArrayMaxWidth(mycanvas:Tcanvas; myArray:array of string):smallint;
var
 mw,i,a: smallint;
begin
 mw:=10;
 if UserRecordsCount>0 then
  for i:=1 to UserRecordsCount do
   begin
    a:=mycanvas.textwidth(myArray[i]);
    if a>mw then mw:=a;
   end;
 result:=mw;
end;


procedure GetMyUserInfo(MyUser: integer);
var
 astr,bstr: string;
 fname,myDir: string;
 myAccessFile: textfile;
 tmpDataLocksStr,tmpStrA: string;
 i,k: integer;
 usrStr: string;
 ThisUsrLock: array[0..accessCountMax] of boolean;

   function YrsInUse(offset:integer): string;
   var
    astr: string;
    i,count: integer;
    start: boolean;
    startyr,endyr: array[0..nmbrYears] of integer;
   begin
    start:=false; count:=0;  astr:='';
    for i:=0 to nmbrYears do
     begin
      startyr[i]:=-1; endyr[i]:=-1;
     end;
    for i:=offset to offset+years_minus_1 do
     begin
      if ThisUsrLock[i] and not(start) then
       begin
        start:=true;
        inc(count);
        startYr[count]:=i-offset;
       end;
      if not(ThisUsrLock[i]) and start then
       begin
        start:=false; endYr[count]:=i-offset-1;
       end;
      if (i=offset+years_minus_1) and ThisUsrLock[i] and start
        then endYr[count]:=years_minus_1;
     end;
    astr:='';
    if count>0 then  {has student data}
     begin
      astr:=yearShort;
      for i:=1 to count do
       begin
        astr:=astr+' '+yearname[startYr[i]];
        if endYr[i]>startYr[i] then astr:=astr+'-'+yearname[endYr[i]];
       end;
      if (count=1) and (startYr[1]=0) and (endYr[1]=years_minus_1) then astr:='All';
      if (Directories.datadir<>UsrDataDir[MyUser]) then astr:=' ';
     end;
    result:=astr;
   end;

   procedure AddStr(i: integer);
   var
    a: string;
   begin
    a:='';
    case i of
     1: a:='Teachers';
     2: a:='Rooms';
     3: a:='Houses';
     4: a:='Roll Classes';
     6: a:='Subjects';
     14: a:='Faculties';
     16: a:='Timetable';
     38: a:='Admin';
    end;
    if a>'' then  usrStr:=usrStr+a+'  ';
   end;


begin
 UsrDataDir[MyUser]:=''; UsrOn[MyUser]:='OFF'; UsrTt[MyUser]:='';
 UsrDate[MyUser]:='';    UsrDataSect[MyUser]:='';
 for i:=0 to accessCountMax do ThisUsrLock[i]:=false;

 if passID[myUser]=usrPassID then {get from array}
  begin
   UsrOn[MyUser]:='ON';
   UsrDataDir[MyUser]:=Directories.datadir;
   UsrTt[MyUser]:=FileNames.LoadedTimeTable;
   UsrDate[MyUser]:=usrAccessTime;
   for i:=1 to accessCountMax do
    if usrDataSectionLocked[i] then
     begin
      k:=i; if i>60 then k:=16;
      ThisUsrLock[k]:=true;
     end;
  end
 else
  begin  {get from file}

   myDir:=passUserDir[MyUser];
   fname:=passID[MyUser]+myLogOnFileExt;    //filename based on username
   if myDir<>Directories.datadir then
    begin
     chdir(Directories.datadir);
     if fileexists(fname) then myDir:=Directories.datadir;
    end;
   if not(directoryexists(myDir)) then exit; {can't access directory}
   chdir(myDir);
   if not(fileexists(fname)) then exit; {no file}

   doAssignFile(myAccessFile,fname);
   try
    try
     Reset(myAccessFile);
     Readln(myAccessFile,astr);
     UsrOn[MyUser]:=trim(astr);
     if UsrOn[MyUser]<>'ON' then exit; {user not logged on}
     Readln(myAccessFile,UsrDataDir[MyUser]);
     Readln(myAccessFile,UsrTt[MyUser]);
     Readln(myAccessFile,UsrDate[MyUser]);
     Readln(myAccessFile,astr);
     tmpDataLocksStr:=trim(astr);
     k:=pos(',',tmpDataLocksStr);
     while(k>0) do
      begin
       tmpStrA:=trim(copy(tmpDataLocksStr,1,k-1));
       tmpDataLocksStr:=copy(tmpDataLocksStr,k+1,length(tmpDataLocksStr));
       i:=strtointdef(tmpStrA,0);  if i>60 then i:=16; {put timetable locks together}
       if (i>0) then ThisUsrLock[i]:=true;
       k:=pos(',',tmpDataLocksStr);
      end;
     i:=strtointdef(trim(tmpDataLocksStr),0);  if i>60 then i:=16;
     if (i>0) then ThisUsrLock[i]:=true;

    except
    end;
   finally
    Closefile(myAccessFile);
    UsrRead[MyUser]:=false;
   end;
  end;

//check for students only use yearnames if same data directory  17+
//check for blocks - if no students, do year check 43+, else show 'blocks'
 usrStr:='';
 for i:=1 to 38 do if ThisUsrLock[i] then AddStr(i);
 astr:=YrsInUse(17);
 bstr:=YrsInUse(43);
 if astr>'' then
  begin
   usrStr:=usrStr+astr+' Students ';
   if bstr>'' then usrStr:=usrStr+' Blocks';
  end
 else if bstr>'' then usrStr:=usrStr+bstr+' Blocks'; ;
 if ThisUsrLock[42] then usrStr:='All data'; {replaces other strings}
 UsrDataSect[MyUser]:=usrStr;
end;


procedure GetUserInfo;
var
 i: integer;
begin
 Setlength(UsrDataDir,UserRecordsCount+2);   Setlength(UsrOn,UserRecordsCount+2);
 Setlength(UsrTt,UserRecordsCount+2);   Setlength(UsrDate,UserRecordsCount+2);
 Setlength(UsrDataSect,UserRecordsCount+2);  Setlength(UsrRead,UserRecordsCount+2);
 if UserRecordsCount>0 then
  for i:=1 to UserRecordsCount do if UsrRead[i] then GetMyUserInfo(i);
end;


procedure TShowUsersWin.setTabs;
var
 a: integer;
begin
 GetUserInfo;
 TotalCodes:=UserRecordsCount;
 codecolor:=cpTeach;
 setlength(Tabs,9);
 TotalCodes:=UserRecordsCount;
 headwidth:=canvas.textwidth('User ID    Access level   User display directory');
 CodeWidth:=getUsernameMaxWidths(canvas)+blankWidth;
 CalcScreenCodeFit;
 maxTab(1,Codewidth,'User ID ');
 maxTab(2,1,'Access level ');
 a:=getUserDirMaxWidths(canvas);
 maxTab(3,a,'Display folder');
 maxTab(4,0,'OFF ');
 a:=getArrayMaxWidth(canvas,UsrDataDir);
 maxTab(5,a,'Data folder');
 a:=getArrayMaxWidth(canvas,UsrTt);
 maxTab(6,a,'Timetable');
 a:=getArrayMaxWidth(canvas,UsrDate);
 maxTab(7,a,'Date');
 a:=getArrayMaxWidth(canvas,UsrDataSect);
 maxTab(8,a,'Data');
 case winView[wnShowUsers] of
  0: maxW:=CodeWidth*CodeFit;  {codes}
  1: maxW:=Tabs[8]; {code + dir}
 end; {case}
 LastUsrOnCheck:=now;
end;



procedure TShowUsersWin.PaintItem(i:integer;SelFlag:boolean);
var
 tmpCol: Tcolor;
begin
 tmpCol:=canvas.font.color;
 case winView[wnShowUsers] of
   0: printw(passID[i]);  {codes only}
   1: begin  {code + dir}
       printw(passID[i]);
       x:=Tabs[1]; printw(accessType[passLevel[i]]);
       x:=Tabs[2]; printw(passUserDir[i]);
       x:=Tabs[3]; if UsrOn[i]='ON' then topcolor(cpDouble);
       printw(UsrOn[i]);    canvas.font.color:=tmpCol;
       x:=Tabs[4]; printw(UsrDataDir[i]);
       x:=Tabs[5]; printw(UsrTt[i]);
       x:=Tabs[6]; printw(UsrDate[i]);
       x:=Tabs[7]; printw(UsrDataSect[i]);
      end;
  end;
 fcolor(codecolor);
end;


procedure TShowUsersWin.add2Click(Sender: TObject);
begin
 MainForm.adduser1Click(self)
end;

procedure TShowUsersWin.Change2Click(Sender: TObject);
begin
 MainForm.edituser1Click(self)
end;

procedure TShowUsersWin.Delete2Click(Sender: TObject);
begin
 MainForm.deleteuser1Click(self)
end;





{------------- print procs follow -----------------------}


procedure TPrintShowUsersWin.setTabs;
var
 a: integer;
begin
 codecolor:=cpTeach;
 setlength(PrntTabs,9);
 TotalCodes:=UserRecordsCount;
 CodeWidth:=getUsernameMaxWidths(PrintCanvas)+PrntBlankWidth;
 CalcPrintCodeFit;
 maxTab(1,Codewidth,'User ID ');
 maxTab(2,1,'Access level ');
 a:=getUserDirMaxWidths(PrintCanvas);
 maxTab(3,a,'Display folder');
 maxTab(4,0,'OFF ');
 a:=getArrayMaxWidth(PrintCanvas,UsrDataDir);
 maxTab(5,a,'Data folder');
 a:=getArrayMaxWidth(PrintCanvas,UsrTt);
 maxTab(6,a,'Timetable');
 a:=getArrayMaxWidth(PrintCanvas,UsrDate);
 maxTab(7,a,'Date');
 a:=getArrayMaxWidth(PrintCanvas,UsrDataSect);
 maxTab(8,a,'Data');
end;

procedure TPrintShowUsersWin.head;
begin
 fcolor(cpNormal);
 UnderlineOn;
 printw2('Users: ',inttostr(UserRecordsCount));
 printw(PageCount);
 UnderlineOff;
 x:=0; y:=y+PrnttxtHeight;
 if winView[wnShowUsers]=1 then
  begin  {code + name}
   printwl('User ID');
   x:=PrntTabs[1]; printw('Access level');
   x:=PrntTabs[2]; printw('User display directory');
   x:=PrntTabs[3]; printw('On');
   x:=PrntTabs[4]; printw('Data folder');
   x:=PrntTabs[5]; printw('Timetable');
   x:=PrntTabs[6]; printw('Time');
   x:=PrntTabs[7]; printw('Data');
  end;
 x:=0; y:=y+PrnttxtHeight;
 fcolor(codeColor);
end;


procedure ShowUsersWinPrint;
var
 i: integer;
begin
 PrintShowUsersWin:=TPrintShowUsersWin.Create;
 with PrintShowUsersWin do
  try
   PrintHead;
   code:=1;
   if TotalCodes>0 then
    for i:=1 to TotalCodes do
     case winView[wnShowUsers] of
      0: begin   {codes only}
          printw(passID[i]);
          x:=(i mod codefit)*CodeWidth;
          if (i mod codefit)=0 then newline;
         end;
      1: begin  {code + dir}
          printw(passID[i]);
          x:=prntTabs[1]; printw(accessType[passLevel[i]]);
          x:=prntTabs[2]; printw(passUserDir[i]);
          x:=prntTabs[3]; if UsrOn[i]='ON' then fcolor(cpDouble);
          printw(UsrOn[i]);    fcolor(codecolor);
          x:=prntTabs[4]; printw(UsrDataDir[i]);
          x:=prntTabs[5]; printw(UsrTt[i]);
          x:=prntTabs[6]; printw(UsrDate[i]);
          x:=prntTabs[7]; printw(UsrDataSect[i]);
          newline;
         end;
     end;
    newline; fcolor(cpNormal);
   printCustomAddon;
  finally;
   PrintShowUsersWin.Free;
  end;
end;




procedure TOutShowUsersWin.head;
begin
 printLine(['Users: ',inttostr(UserRecordsCount)]);
 if winView[wnShowUsers]=1 then
   PrintLine(['User ID','Access level','User display directory','On',
              'Data folder','Timetable','Time','Data'])
  else newline;
end;

function TOutShowUsersWin.CodeToPrint(i:integer):string;
begin
 result:=passID[i];
end;

procedure ShowUsersWinOut;
var
 i: integer;
begin
 OutShowUsersWin:=TOutShowUsersWin.Create;
 with OutShowUsersWin do
  try
   Setup(UserRecordsCount);
   if TotalCodes>0 then
   for i:=1 to TotalCodes do
    begin
     case winView[wnShowUsers] of
      0: PrintCode(i);
      1: printLine([passID[i],accessType[passLevel[i]],passUserDir[i],UsrOn[i],
                    UsrDataDir[i],UsrTt[i],UsrDate[i],UsrDataSect[i]]);
     end;  {case}
    end;  {for i  to totalcodes}
    newline;
   printCustomAddon;
  finally; {with OutShowUsersWin}
   OutShowUsersWin.Free;
  end;
end;


procedure TShowUsersWin.Timer1Timer(Sender: TObject);
var
 i: smallint;
 fname: string;
 needUserRefresh: bool;
 myFileAge: TDateTime;
begin
  if InTimerRoutine then exit;  //prevent reentry
  if winView[wnShowUsers]=0 then exit; {don't need update on short view}
  InTimerRoutine:=true;
  needUserRefresh:=false;
  for i:=1 to UserRecordsCount do
  begin
   if passID[i]=usrPassID then continue;
   if not(directoryexists(passUserDir[i])) then continue;
   chdir(passUserDir[i]);
   fname:=passID[i]+myLogOnFileExt;    //filename based on username
   if not(fileexists(fname)) then continue;
   if FileAge(fname,myFileAge) then
    if (LastUsrOnCheck<myFileAge) then
     begin
      needUserRefresh:=true; UsrRead[i]:=true;
     end;
  end;
  if needUserRefresh then
  begin
   LastUsrOnCheck:=now;
   UpdateWindow(wnShowUsers);
  end;
  InTimerRoutine:=false;
end;

end.
