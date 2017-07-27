unit Tcommon2;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Dialogs, SysUtils,Messages,grids,TimeChartGlobals,ClassDefs, XML.UTILS,
  GlobalToTcAndTcextra, XML.DISPLAY, XML.TEACHERS, XML.STUDENTS;

 procedure saveWinDisplay;
 procedure saveDisplayFile(displayFile:string);
 procedure findstudentWinSelect;
 function FNycSHARED(d,p,te,b: smallint):string;
 procedure rangeCheckStudSels(var aa: tpstudentdata);
 procedure rangeCheckCodeSels(var aa: tpTeData; code: smallint);
 procedure rangeCheckSubSels(var aa: tpSubData);
 procedure rangeCheckSubyrSels(var aa: tpCmatrixSelection);
 procedure updatetoolbar;
 function GetClipStatus(winnum: smallint): boolean;

procedure getStudentText2;  {morayfield}
procedure showStudentText3;  {OBERON}

procedure updateClass;
procedure copyTextToClipboard(cf: word);
procedure getTextFromClipboard(clpFormatToUse:word);
function GetNextClipStr: string;
procedure getClipCell(var su,te,ro,flg: smallint);
procedure getClipBlkCell(var su: smallint);
procedure CheckPasteMsg;

procedure REselectgroup;
procedure SetBclashesGroup(methodSel:integer);
procedure SetBfreeGroup(methodSel:integer);
procedure SetSubGroup(methodSel:integer);
procedure SetTagGroup(methodSel:integer);
procedure SetRoomGroup(methodSel:integer);
procedure SetTutorGroup(methodSel:integer);
procedure SetIDGroup(grType,methodSel:integer);
procedure SetHouseGroup(methodSel:integer);
procedure SetClassGroup(methodSel:integer);
procedure SetYearGroup(methodSel:integer);

procedure loadGroups;
procedure saveGroups;
procedure setRecipeFromGOS(nm: integer);
procedure CookCustomGroup(GI: integer);
procedure updateCustomMenus;
procedure dumpOldClassFiles;

procedure updateGroupSubs;
procedure addSubToGroupSubs(k: smallint);
procedure updateRollClassPoint;
function FindLabel:integer;

function GetBlockLevels(d,p,y,L:integer; var ml1,ml2:integer): bool;
procedure FNputWSblockNumber(b,y,l: smallint; BlockNum: Byte);
Procedure FNputBlockNumber(d,p,y,l: smallint; BlockNum: Byte);
function FNgetBlockNumber(d,p,y,l: smallint): Byte;
function FNgetWSblockNumber(b,y,l: smallint): Byte;
function GroupCaption: string;
function GetTeachTtItem(var su,ro,TeYear,TeLevel: integer;te,D,P: integer): boolean;
function GetRoomTtItem(var su,te,RoYear,RoLevel: integer;ro,D,P: integer): boolean;
function StudFreeinBlock(st_i,ablock:integer):boolean;
procedure calculateloads;
procedure ClearTeDoSub;
procedure tcount(yeary,i,myLev: smallint);
procedure ReadSubOfferFile;
Procedure SetSubOfferArrays;
function FindRow(y,L:byte):integer;
function FindCol(d,p:byte):integer;
procedure ConfigureTimetable(newdays, newperiods, newyears, newformat: integer);
procedure tsClash(d,p:integer);
procedure wsBlockClash(b: integer);
procedure CalcLevelsUsed;
function CalcLevelsOfData: integer;
function CalcLevelMax(ttformat,MyYears,MyDays,Myperiods: smallint):smallint;
procedure CheckResize(MyYears,MyDays,Myperiods: smallint);
procedure RebuildLabels;
procedure ClearWorksheet;
procedure SetWSarrays;
procedure SetWSmultArrays;
function wsMultName(i: integer): string;
procedure trimLabelToFit(var tmpStr: string; myCanvas: Tcanvas; myWidth:integer);
function NoWeekSelect: string;
procedure SetTTtitle;
procedure LoadText2(fname: string);
function GetTeacherFaculty(const pTeacheNo, pFactOrder: Integer): Integer;


implementation

uses    Tcgetdir,tcommon, main,CodeView,subyr,tcinfo,block1,subbysub,subbyslt,
        studlist,printers, studttab,teachtt,roomtt,subjcttt, clashhlp,blkclash,
        teclash,roclash,tefree,rofree,tetimes,subtimes,grpofte,clmatrix,
        clmatsel,edcustom,stinput,findstud,clipbrd, gentool, tttoolbarwin,
         blcktool,tcommon5,stcommon,worksheet,wsToolbarwin,Ttable, customOutput;

function NoWeekSelect: string;
var
 astr: string;
begin
 astr:='';
 if (SelDays=0) or (tsShowMax=0) then
  begin
   if SelDays=0 then astr:='No days selected. ';
   if tsShowMax=0 then astr:=astr+'No time slots selected. ';
  end;
 result:=astr;
end;

procedure SetTTtitle;
begin
 if wnFlag[wnTtable] then
   ttablewin.caption:='Timetable  Version:'+Version+'  File:'+FileNames.LoadedTimeTable;
 if wnFlag[wnWorksheet] then
   Worksheetwin.caption:='Worksheet  Version:'+Version+'  File:'+FileNames.LoadedTimeTable;
end;

procedure trimLabelToFit(var tmpStr: string; myCanvas: Tcanvas; myWidth:integer);
var
 i:   integer;
begin
 i:=myCanvas.textwidth(tmpStr);
 while (i>myWidth) and (tmpStr>'') do
 begin
  tmpstr:=copy(tmpstr,1,Length(tmpstr)-1);
  i:=myCanvas.textwidth(tmpStr);
 end; {while}
end;

procedure SetWSarrays;
var
 i: integer;
begin
 wsMainSize:=szWScell*years*(levelprint+2);
 wsmem1:= szWScell*LevelPrint;
 SetLength(wsMain,wsBlocks+1);
 for i:=1 to wsBlocks do
   setlength(wsMain[i],wsMainSize+2);
end;

procedure SetWSmultArrays;
begin
 if wsMultNum<0 then wsMultNum:=0;
 SetLength(wsOne,wsMultNum+2);
 SetLength(wsTwo,wsMultNum+2);
 SetLength(wsThree,wsMultNum+2);
 SetLength(wsOrder,wsMultNum+2);
 SetLength(wsXorder,wsMultNum+2);
end;

function wsMultName(i: integer): string;
begin
 result:=inttostr(wsOne[i])+'-'+
   inttostr(wsTwo[i])+'-'+inttostr(wsThree[i])
end;

procedure ClearWorksheet;
var
 i,j: integer;
begin
 SetWSarrays;
 for i:=1 to wsBlocks do
  for j:=1 to wsMainSize do wsMain[i][j]:=0;
  fillchar(WSTclash,sizeof(WSTclash),chr(0));
  fillchar(WSRclash,sizeof(WSRclash),chr(0));
  fillchar(WSFclash,sizeof(WSFclash),chr(0));
  WSclash;
end;

procedure duplicateLabel(var labelIndex: smallint);
var
 j       : smallint;
 oldlabel: word;
 found   : smallint;
begin
 if Lnum>=nmbrLabels then exit;
 oldlabel:=labelIndex;
 found:=0;
 if Lnum>0 then
  for j:= 1 to Lnum do
   if TcLabel[j]='' then
    begin
     found:=j;
     break;
    end;
 if (found=0) then
  begin
   inc(Lnum);
   found := Lnum
  end;
 labelIndex:=found;
 TcLabel[labelIndex]:=TcLabel[oldlabel];
end;

procedure RebuildLabels;
var
 labelcheck: array [0..nmbrLabels] of smallint;
 labelIndex: smallint;
 b,d,p,y,L   : smallint;
 su,sub    : smallint;
 IntPoint  : tpIntPoint;
 i         : smallint;


  procedure DoLabelCheck;
  begin
   if su>=LabelBase then
    begin
     labelIndex:=su-LabelBase;
     if (labelIndex>Lnum) or (TcLabel[labelIndex]='') or (labelindex=0) then
      begin
       labelIndex:=0;
       IntPoint^:=labelIndex;
      end;
     inc(labelcheck[labelIndex]);
     if (TcLabel[labelIndex]>'') and (labelIndex>0)
              and (labelcheck[labelIndex]>1) then
      begin
       duplicateLabel(labelIndex);
       sub:=LabelBase+labelIndex;
       IntPoint^:=sub;
       labelcheck[labelIndex]:= 1;
      end;
    end; {if su>Labelbase}
   end;

begin
 if Lnum = 0 then exit;
 for i:=0 to nmbrLabels do labelcheck[i]:=0;
 {check on timetable}
 for d:=0 to days-1 do
  for p:=0 to periods-1 do
   for y:=0 to years_minus_1 do
    begin
     IntPoint:=FNT(d,p,y,0,0);
     for L:=1 to LevelPrint do
      begin
       inc(IntPoint,4);
       su:=IntPoint^;
       DoLabelCheck;
      end; {for l}
    end; {for y}
 {check on worksheet}
 for b:=1 to wsBlocks do
  for y:=0 to years_minus_1 do
   for L:=1 to LevelPrint do
    begin
     IntPoint:=FNws(b,y,L,0);
     su:=IntPoint^;
     DoLabelCheck;
    end; {for l}

 for i:=1 to Lnum do
  if labelcheck[i]=0 then TcLabel[i]:='';
 while (Lnum>0) and (TcLabel[Lnum]='') do dec(Lnum);
end;

function CalcLevelMax(ttformat,MyYears,MyDays,Myperiods: smallint):smallint;
begin
 ttformat:=ttformat mod 10;
 if ttformat=1 then
  result:=trunc(8000/(word(MyDays)*word(Myperiods)*word(MyYears)))
 else
  result:=trunc((ttformat*1000)/(Myperiods*MyYears));
end;

function CalcWSHiddenlevelsUsed(y:smallint): integer;
var
 b,l: smallint;
 su,te,ro: smallint;
 afnt:    tpintpoint;
 myLevels: integer;
begin
 myLevels:=1;
 for l:=level[y] to levelprint do
  begin
   if l<=myLevels then continue;
   for b:=1 to wsBlocks do
    begin
     afnt:=FNws(b,y,l,0);
     su:=afnt^; inc(afnt);
     te:=afnt^; inc(afnt);
     ro:=afnt^;
     if (su<>0) or (te<>0) or (ro<>0) then
      begin
       if l>myLevels then myLevels:=l;
       break;
      end;
    end;
  end;
 result:=myLevels;
end;

function CalcLevelsOfData: integer;
var
 d,p,y,l: smallint;
 su,te,ro: smallint;
 afnt:    tpintpoint;
 found: boolean;
 myLevels: integer;
 _GotERangeError: boolean;
begin
 myLevels:=1;
 _GotERangeError := false;
 for y:=0 to years_minus_1 do
  for l:=level[y] to levelprint do
   begin
    if _GotERangeError then
        break;
    found:=false;
    if l<=myLevels then continue;
    for d:=0 to days-1 do
     begin
      if _GotERangeError then
        break;
      for p:=0 to tlimit[d]-1 do
       begin
        try
          afnt:=FNT(d,p,y,l,0);
        except
          // This needs testing.  Seems OK just to handle as a temp glitch while new structure does not exit.
          // but David will have to give a proper test.
          on E: ERangeError  do begin
            _GotERangeError := true;
            break;
          end;
        end;
        su:=afnt^; inc(afnt);
        te:=afnt^; inc(afnt);
        ro:=afnt^;
        if (su<>0) or (te<>0) or (ro<>0) then
         begin
          if l>myLevels then myLevels:=l;
          found:=true;
          break;
         end;
       end;
      if found then break;
     end;
   end;

 for y:=0 to years_minus_1 do
  begin
   l:=CalcWSHiddenlevelsUsed(y);
   if l>myLevels then myLevels:=l;
  end;

 result:=myLevels;
end;

procedure CalcLevelsUsed;
var
 y: smallint;
begin
 levelsUsed:=CalcLevelsOfData;
 for y:=0 to years_minus_1 do if level[y]>levelsUsed then levelsUsed:=level[y];
end;

procedure CheckResize(MyYears,MyDays,Myperiods: smallint);
const
 HasSize: array [0..3] of integer=(1,2,4,6);
var
 mySize,oldSize,mySizeI,oldSizeI,LevelsOfData: integer;
 tmpFormat,i: integer;
 myLevelMax: array[0..3] of smallint;
 msg: string;

begin
 LevelsOfData:=CalcLevelsOfData;
 oldSize:=ttMainFormat mod 10;
 oldSizeI:=0;
 for i:=0 to 3 do if HasSize[i]=oldSize then oldSizeI:=i;
 for i:=0 to 3 do
  begin
   tmpFormat:=HasSize[i];
   myLevelMax[i]:=CalcLevelMax(tmpFormat,MyYears,MyDays,Myperiods);
  end;
 if LevelsOfData<=myLevelMax[oldSizeI] then exit;{has enough room}
 mySizeI:=3;
 for i:=0 to 3 do
  if MyLevelMax[i]>=LevelsOfData then
   begin
    mySizeI:=i; break;
   end;
 if mySizeI>oldSizeI then
  begin
   mySize:=HasSize[MySizeI];
   if ttmainformat>10 then inc(mySize,10);
   ConfigureTimetable(days,periods,years,mySize);
   msg:='Timetable size has been increased.';
   messagedlg(msg,mtInformation,[mbOK],0);
  end;
end;

procedure wsBlockClash(b: integer);
var
 y,L,y2,l2        : integer;
 IntPoint,IntPoint2 : tpIntPoint;
 BytePoint,BytePoint2,BytePoint3: tpBytePoint;
 t1,t2,R1,R2,shareP,shareP2   : integer;
 tmpByte   : byte;
begin
 if wsFclash[b]=0 then exit;
 wsTclash[b]:=0;  wsRclash[b]:=0;
 for y:=0 to years_minus_1 do
  for L:=1 to level[y] do  // only want to clear bits 3+4 - zero based
   begin
    tmpByte:=FNwsByte(b,y,L,7)^;
    tmpByte:=tmpByte and 231; // 11100111
    FNwsByte(b,y,L,7)^:=tmpByte
   end;
 for y:=0 to years_minus_1 do
  for L:=1 to level[y] do
   begin
    IntPoint:=FNws(b,y,L,2);  t1:=IntPoint^;
    inc(IntPoint);  R1:=IntPoint^;
    BytePoint:=FNwsByte(b,y,L,6);
    shareP:=2 and BytePoint^;
    if (t1=0) and (R1=0) then continue;
    for y2:=y to years_minus_1 do
     for l2:=1 to level[y2] do
      begin
       IntPoint2:=FNws(b,y2,L2,2);  t2:=IntPoint2^;
       inc(IntPoint2); R2:=IntPoint2^;
       BytePoint2:=FNwsByte(b,y2,L2,6);
       shareP2:= 2 and BytePoint2^;
       if (y2=y) and (l2<=L) then continue;
       if (shareP<>0) and (shareP2<>0) then continue;
       if (t1>0) and (t1=t2) then
        begin
         BytePoint3:=BytePoint;
         inc(BytePoint3);
         BytePoint3^:=8 or BytePoint3^;
         BytePoint3:=BytePoint2;
         inc(BytePoint3);
         BytePoint3^:=8 or BytePoint3^;
         inc(wsTclash[b])
        end; {t1=t2}
       if (R1>0) and (R1=R2) then
        begin
         BytePoint3:=BytePoint;
         inc(BytePoint3);
         BytePoint3^:= 16 or BytePoint3^;
         BytePoint3:=BytePoint2;
         inc(BytePoint3);
         BytePoint3^:=16 or BytePoint3^;
         inc(wsRclash[b])
        end; {R1=R2}
      end; {l2}
    end; {l}
  wsFclash[b] := 0
end;

procedure tsClash(d,p:integer);
var
 y,L,y2,l2        : integer;
 IntPoint,IntPoint2 : tpIntPoint;
 BytePoint,BytePoint2,BytePoint3: tpBytePoint;
 t1,t2,R1,R2,shareP,shareP2   : integer;
 tmpByte   : byte;
begin
 if Fclash[d,p]=0 then exit;
 Tclash[d,p]:=0; Rclash[d,p]:=0;
 for y:=0 to years_minus_1 do
  for L:=1 to level[y] do // only want to clear bits 3+4 - zero based
   begin
    tmpByte:=FNTByte(d,p,y,L,7)^;
    tmpByte:=tmpByte and 231; // 11100111
    FNTByte(d,p,y,L,7)^:=tmpByte
   end;
 for y:=0 to years_minus_1 do
  begin
   IntPoint:=FNT(d,p,y,0,4);
   BytePoint:=FNTByte(d,p,y,0,6);
   for L:=1 to level[y] do
    begin
     inc(IntPoint,3); t1:=IntPoint^;
     inc(IntPoint);   R1:=IntPoint^;
     inc(BytePoint,8); shareP:=2 and BytePoint^;
     if (t1=0) and (R1=0) then continue;
     for y2:=y to years_minus_1 do
      begin
       IntPoint2:=FNT(d,p,y2,0,4);
       BytePoint2:=FNTByte(d,p,y2,0,6);
       for l2:=1 to level[y2] do
        begin
         inc(IntPoint2,3);  t2:=IntPoint2^;
         inc(IntPoint2);    R2:=IntPoint2^;
         inc(BytePoint2,8); shareP2:=2 and BytePoint2^;
         if (y2=y) and (l2<=L) then continue;
         if (shareP<>0) and (shareP2<>0) then continue;
         if (t1>0) and (t1=t2) then
          begin
           BytePoint3:=BytePoint;
           inc(BytePoint3);
           BytePoint3^:=8 or BytePoint3^;
           BytePoint3:=BytePoint2;
           inc(BytePoint3);
           BytePoint3^:=8 or BytePoint3^;
           inc(Tclash[d,p])
          end; {t1=t2}
         if (R1>0) and (R1=R2) then
          begin
           BytePoint3:=BytePoint; inc(BytePoint3);
           BytePoint3^:=16 or BytePoint3^;
           BytePoint3:=BytePoint2; inc(BytePoint3);
           BytePoint3^:=16 or BytePoint3^;
           inc(Rclash[d,p])
          end; {R1=R2}
        end; {l2}
      end; {y2}
    end; {l}
  end; {y}
 Fclash[d,p]:=0
end;

procedure ConfigureTimetable(newdays, newperiods, newyears, newformat: integer);
var
 newLevelMax,newttmem1,newttmem2,newttmem3,newLevelprint: integer;
 TempDay      : ^tpTtDayBlock;
 TempWSblock  : array of byte;
 d,y,p,L,i,b    : integer;
 Ad1,Ad2      : longint;
 levelcopy,ttformatTemp : integer;
 wsmem1Temp,wsMainSizeTemp : integer;
begin
 if (newdays=days) and (newperiods=periods) and (newyears=years)
     and (ttMainFormat=newformat) then exit;
 ttformatTemp:=newformat mod 10;
 newLevelMax:=CalcLevelMax(ttformatTemp,newyears,newdays,newperiods);
 newttmem1:=8*newLevelMax;   newttmem2:=newyears*newttmem1;
 newttmem3:=64000 div newdays;
 newLevelprint:=newLevelMax;
 if newLevelprint>nmbrLevels then newLevelprint:=nmbrLevels;
 levelcopy:=newLevelprint;
 if levelcopy>LevelPrint then levelcopy:=LevelPrint;
 new(TempDay);
 for d:=0 to newdays-1 do
  begin
   fillchar(TempDay^,sizeof(TempDay^),chr(0));
   if d>=days then
    begin
     fillchar(ttMain[d]^,sizeof(ttMain[d]^),chr(0));
     continue
    end;
   for p:=0 to newperiods-1 do
    begin
     if p>=periods then break;
     for y:=0 to newyears-1 do
      begin
       if y>=years then break;
       Ad1:=(ttMemSetting2.Value*p)+(ttMemorySetting1.Value*y)+8;
       Ad2:=(newttmem2*p)+(newttmem1*y)+8;
       move(ttMain[d]^[Ad1],TempDay^[Ad2],8*levelcopy)
      end; {y}
    end; {p}
   move(TempDay^, ttMain[d]^, sizeof(TempDay^))
  end; {d}
 {configure worksheet}
 wsMainSizeTemp:=szWScell*newyears*(newLevelprint+2);
 wsmem1Temp:= szWScell*newLevelprint;
 if (wsMainSizeTemp<>wsMainSize) or (wsmem1Temp<>wsmem1) then
  begin {new worksheet is different}
   setlength(TempWSblock,wsMainSizeTemp+2);
   for b:=1 to WSblocks do
    begin
     for i:=0 to wsMainSizeTemp do TempWSblock[i]:=0; {clear temp}
     for y:=0 to newyears-1 do
      begin
       if y>=years then break;
       for l:=1 to newLevelPrint do
        if l<=levelPrint then
         for i:= 0 to szWScell-1 do
          begin
           Ad1:=(wsmem1*y)+(szWScell*l)+i;
           Ad2:=(wsmem1Temp*y)+(szWScell*l)+i;
           TempWSblock[Ad2]:=WSMain[b][Ad1];
          end;
      end; {for y}
     setlength(WSMain[b],wsMainSizeTemp+2);
     for i:=1 to wsMainSizeTemp do wsMain[b][i]:=TempWSblock[i];
    end; {for b}
   wsMainSize:=wsMainSizeTemp;
   wsmem1:=wsmem1Temp;
  end; {different worksheet}

 {configure targets}
 if newyears>years then
  begin
   i:=newyears-years;
   for d:=0 to days-1 do
    begin
     for y:=years+nmbrWSTspecials-1 downto years do  {move specials up}
      begin
       wstSingle[y+i,d]:=wstSingle[y,d];
       wstDouble[y+i,d]:=wstDouble[y,d];
       wstTriple[y+i,d]:=wstTriple[y,d];
      end;
     for y:=years to years+i-1 do      {fill new years with last year's targets}
      begin
       wstSingle[y,d]:=wstSingle[years_minus_1,d];
       wstDouble[y,d]:=wstDouble[years_minus_1,d];
       wstTriple[y,d]:=wstTriple[years_minus_1,d];
      end;
    end;
  end;
 if newyears<years then
  begin
   i:=years-newyears;
   for d:=0 to days-1 do
    for y:=newyears to newyears+nmbrWSTspecials-1 do  {move specials down}
     begin
      wstSingle[y,d]:=wstSingle[y+i,d];
      wstDouble[y,d]:=wstDouble[y+i,d];
      wstTriple[y,d]:=wstTriple[y+i,d];
     end;
  end;
 if newdays>days then {fill new days}
  for d:=days to newdays-1 do
   for y:=-1 to newyears+nmbrWSTspecials do
    begin
     wstSingle[y,d]:=wstSingle[y,days-1];
     wstDouble[y,d]:=wstDouble[y,days-1];
     wstTriple[y,d]:=wstTriple[y,days-1];
    end;

 for y:=0 to newyears-1 do
  begin
   if y>=years then level[y]:=6;
   if level[y]>newLevelprint then level[y]:=newLevelprint
  end;
 days:=newdays; periods:=newperiods; years:=newyears;
 years_minus_1:=years-1;
 ttMainFormat:=newformat;
 LevelMax:=newLevelMax;  LevelPrint:=newLevelprint;
 ttMemorySetting1.Value:=newttmem1;  ttMemSetting2.Value:=newttmem2; ttMemSetting3.Value:=newttmem3;


 if XML_DISPLAY.blocklevel>LevelPrint then
    XML_DISPLAY.blocklevel:=LevelPrint;
 for p:=1 to XML_DISPLAY.blocknum do
  if Sheet[p,0]> XML_DISPLAY.blocklevel then
    for L:=XML_DISPLAY.blocklevel to Sheet[p,0] do
     if Sheet[p,L]>0 then blockchange(Sheet[p,L],0);
 SaveTimeFlag:=true;
 AlterTimeFlag:=true;  AlterWSflag:=true;
 DoAllTtClashes;
 SetTimeCell;
 SetDays;
 dispose(TempDay)
end;

function FindRow(y,L:byte):integer;
var
 i,count: integer;
begin
 count:=1;
 if y<years_minus_1 then
  for i:=years_minus_1 downto y+1 do inc(count,level[i]+1);
 inc(count,L+1);
 Result:=count;
end;

function FindCol(d,p:byte):integer;
var
 i,count: integer;
begin
 count:=0;
 if d>0 then
  for i:=0 to d-1 do inc(count,Tlimit[i]);
 inc(count,p+1);
 Result:=count;
end;

Procedure SetSubOfferArrays;
begin
 SetLength(OfferTitle,OfferSections+1); SetLength(OfferDesc,OfferSections+1);
 SetLength(OfferSubs,OfferSections+1,OfferSubMax+1);
end;

procedure ReadSubOfferFile;
var
 f:       file;
 fn,strA: string;
 i,j,a,b,m,count:       smallint;
 tmpFix,blockyear,tmpBlockNum:     smallint;
begin
 if (OfferFile='') then exit;
 chdir(Directories.datadir);
 fn:=OfferFile+'.SBO';
 if not(fileexists(fn)) then exit;
 try
  try
   assign(f,fn);
   filemode:=fmOpenRead+fmShareDenyNone;
   reset(f,1);
   blockread(f,OfferBlockFlag,sizeof(OfferBlockFlag));
   blockread(f,OfferSections,sizeof(OfferSections));
   blockread(f,OfferSubMax,sizeof(OfferSubMax));
   blockread(f,a,sizeof(a));
   SetLength(OfferGOSname,a);
   if a>0 then blockread(f,OfferGOSname[1],a) else OfferGOSname:='';
   SetSubOfferArrays;
   if OfferBlockFlag then {using blockfile}
    begin
     blockread(f,a,sizeof(a));
     SetLength(OfferBlocks,a);
     blockread(f,OfferBlocks[1],a);
    end
   else
     for i:=1 to OfferSections do
      begin
       blockread(f,m,2);  OfferSubs[i,0]:=m;
       if m>0 then for j:=1 to m do blockread(f,OfferSubs[i,j],2);
      end;
   for i:=1 to OfferSections do
    begin
     blockread(f,a,sizeof(a)); SetLength(OfferTitle[i],a);
     if a>0 then blockread(f,OfferTitle[i][1],a);
     blockread(f,a,sizeof(a));  SetLength(OfferDesc[i],a);
     if a>0 then blockread(f,OfferDesc[i][1],a);
    end;
  finally
   closefile(f);
  end;
 except
 end;
 if not(OfferBlockFlag) then exit;

 if (OfferBlocks='') then exit;
 fn:=OfferBlocks+'.BLK';
 if not(fileexists(fn)) then exit;
 try
  try
   assign(f,fn);
   filemode:=fmOpenRead+fmShareDenyNone;
   reset(f,1);
   blockread(f,blockyear,2);
   blockread(f,tmpBlockNum,2);
   IntRange(tmpBlockNum,2,nmbrBlocks);
   if tmpBlockNum<OfferSections then OfferSections:=tmpBlockNum;
   blockread(f,OfferSubMax,2);
   SetSubOfferArrays;
   for i:=1 to OfferSections do
    begin
     blockread(f,m,2);
     blockread(f,tmpFix,2);
     if m>0 then
      begin
       count:=0;
       for j:=1 to m do
        begin
         blockread(f,b,2);
         strA:=copy(SubCode[b],1,2);
         if ((strA<>'00') and (b>0) and (b<=NumCodes[0])) then
         begin
          inc(count);
          OfferSubs[i,count]:=b;
         end;
        end;  {for j}
       OfferSubs[i,0]:=count;
      end; {if m>0}
    end; {for i}
  finally
   closefile(f);
  end;
 except
 end;
end;

function GetRoomTtItem(var su,te,RoYear,RoLevel: integer;ro,D,P: integer): boolean;
var
 y,L: integer;
 found: boolean;
 afnt,bfnt:  tpintpoint;
begin
 found:=false;
 for y:=0 to years_minus_1 do
  begin
    afnt:=FNT(d,p,y,0,0);
    for L:=1 to level[y] do
     begin
      inc(afnt,4);
      bfnt:=afnt;
      inc(bfnt,2);
      if (ro=bfnt^) then
       begin
        found:=true;
        su:=afnt^; bfnt:=afnt; inc(bfnt);
        te:=bfnt^; royear:=y; rolevel:=L;
        break;
       end;
     end; {for L}
    if found then break;
   end; {for y}
 result:=found;
end;

function GetTeachTtItem(var su,ro,TeYear,TeLevel: integer;te,D,P: integer): boolean;
var
 y,L: integer;
 found: boolean;
 afnt,bfnt:  tpintpoint;
begin
 found:=false;
 for y:=0 to years_minus_1 do
  begin
    afnt:=FNT(d,p,y,0,0);
    for L:=1 to level[y] do
     begin
      inc(afnt,4);
      bfnt:=afnt;
      inc(bfnt);
      if (te=bfnt^) then
       begin
        found:=true;
        su:=afnt^; inc(bfnt);
        ro:=bfnt^; teyear:=y; televel:=L;
        break;
       end;
     end; {for L}
    if found then break;
   end; {for y}
 result:=found;
end;

function GroupCaption: string;
begin
  if grouptype<>myGRPALL then
   result:='    USING GROUP: '+groupname
     +' ('+groupsortname[groupsort]+')'
   else result:='  All Students';
end;

procedure getYearSexCounts;
var
 i,j,a:                smallint;
begin
 {init arr}
 SubSexCountFlg:=false;
 for j:=-1 to years-1 do
  for i:=0 to nmbrsubjects do
   begin
    SuMale[i,j]:=0; SuFemale[i,j]:=0;    SuUnspecified[i,j] :=0;
   end; {for i}
 {now parse and inc. counts}
 if XML_STUDENTS.numstud>0 then
  for i:=1 to XML_STUDENTS.numstud do
  begin
   if uppercase(XML_STUDENTS.Stud[i].sex)='F' then
   begin {SuFemale}
    for j:=1 to chmax do
     begin
      a:=XML_STUDENTS.Stud[i].Choices[j];
      if (a>0) and (a<=NumCodes[0]) then
       begin
         inc(SuFemale[a,XML_STUDENTS.Stud[i].TcYear]);
         inc(SuFemale[a,-1]);
       end;
     end;
   end
   else if uppercase(XML_STUDENTS.Stud[i].sex)='M' then
    begin  {SuMale}
     for j:=1 to chmax do
     begin
      a:=XML_STUDENTS.Stud[i].Choices[j];
      if (a>0) and (a<=NumCodes[0]) then
       begin
         inc(SuMale[a,XML_STUDENTS.Stud[i].TcYear]);
         inc(SuMale[a,-1]);
       end;
     end;
    end  //SuUnspecified  mantis-0181
    Else
    begin  {SuMale}
    for j:=1 to chmax do
     begin
      a:=XML_STUDENTS.Stud[i].Choices[j];
      if (a>0) and (a<=NumCodes[0]) then
       begin
         inc(SuUnspecified[a,XML_STUDENTS.Stud[i].TcYear]);
         inc(SuUnspecified[a,-1]);
       end;
     end;
    end;
   // mantis-0181
  end; {for i}
end;

procedure ClearTeDoSub;
var
 v: integer;
begin
 for v:=1 to nmbrSubjects do TeDoSub[v]:=0;
 for v:=0 to nmbrSubjects do TeShare[v]:=0;
 for v:=0 to nmbrSubjects do TeAllot[v]:=0;
end;

procedure tcount(yeary,i,myLev: smallint);
var
 d,p,b:         integer;
 aFnt,bFnt:   tpintpoint;
begin
 for d:=0 to days-1 do
  for p:=0 to tlimit[d]-1 do
  begin
   aFnt:=FNT(d,p,yeary,myLev,0);
   bFnt:=aFnt; inc(bFnt);
   if (i=bFnt^) then
   begin
    b:=aFnt^;
    if (b<>subNA) and (b<labelbase) then
    begin
     inc(TeDoSub[0]);
     if b>0 then
     begin
      inc(TeDoSub[b]);
      TeAllot[b]:=TeAllot[b]+tsAllot[d,p];
      bFnt:=aFnt; inc(bFnt,3);
      if bool(2 and bFnt^) then TeShare[b]:=-1;
     end;
    end;
   end; {if (i=bFnt^)}
  end; {for p}
end;

procedure calculateloads;
var
 d,p,y,l,i:              integer;
 afnt,bfnt:            tpintpoint;
 te,su:                integer;
 TeFound:    array of boolean;
begin
 if SubSexCountFlg then getYearSexCounts;
 SetLength(Teaching,NumCodes[1]+2);  SetLength(TeLoad,NumCodes[1]+2);
 SetLength(TeFound,NumCodes[1]+2);
 for i:=0 to NumCodes[1] do begin Teaching[i]:=0; TeLoad[i]:=0; end;
 for d:=0 to days-1 do
  for p:=0 to tlimit[d]-1 do
  begin
   for i:=0 to NumCodes[1] do TeFound[i]:=false;
   for y:=0 to years_minus_1 do
   begin
    ClassInYear[y]:=false;
    afnt:=FNT(d,p,y,0,2);
    for l:=1 to level[y] do
    begin
     if trim(ClassCode[ClassShown[l,y]])>'' then classInYear[y]:=true;
     inc(afnt,4);  te:=afnt^;
     if (te>0) and (te<=NumCodes[1]) then
     begin
      bfnt:=afnt; dec(bfnt);  su:=bfnt^;
      if ((su<>subNA) and (TeFound[te]=false)) then
      begin
       TeLoad[te]:=TeLoad[te]+tsAllot[d,p];
       inc(Teaching[te]);
       TeFound[te]:=true;
      end;
     end;
    end; {for l}
   end; {for y}
  end; {for p}
end;

function FindLabel:integer;
var
 i,found: integer;
begin
 if Lnum=0 then
  begin
   inc(Lnum);
   Result:=Lnum;
   exit
  end;
 found:=0;
 for i:=1 to Lnum do
  if TcLabel[i]='' then
   begin
    found:=i;
    break
   end;
 if (found=0) and (Lnum<nmbrLabels) then
  begin
   inc(Lnum);
   found:=Lnum;
  end;
 Result:=found;
end;

function GetBlockLevels(d,p,y,L:integer; var ml1,ml2:integer): bool;
var
 Nblock: byte;
 l2    : integer;
begin
 Result:=false;
 Nblock:=FNgetBlockNumber(d,p,y,L);
 if Nblock=0 then exit;
 Result:=true;
 for l2:=1 to L do
  if Nblock=FNgetBlockNumber(d,p,y,l2) then
   begin
    ml1:=l2; break
   end;
 for l2:=L to level[y] do
  if Nblock=FNgetBlockNumber(d,p,y,l2) then ml2:=l2;
end;

function FNgetWSblockNumber(b,y,l: smallint): Byte;
var
 Byte7,Byte8,BlockNum: byte;
begin
 Byte7:=FNwsByte(b,y,l,6)^;
 Byte8:=FNwsByte(b,y,l,7)^;
 Byte7:=Byte7 shr 3;  //previous block num
 Byte8:=Byte8 and 7;
 Byte8:=Byte8 shl 5;
 BlockNum:=Byte7 or Byte8;
 result:=BlockNum;
end;

function FNgetBlockNumber(d,p,y,l: smallint): Byte;
var
 Byte7,Byte8,BlockNum: byte;
begin
 Byte7:=FNTByte(d,p,y,l,6)^;
 Byte8:=FNTByte(d,p,y,l,7)^;
 Byte7:=Byte7 shr 3;  //previous block num
 Byte8:=Byte8 and 7;
 Byte8:=Byte8 shl 5;
 BlockNum:=Byte7 or Byte8;
 result:=BlockNum;
end;

procedure FNputWSblockNumber(b,y,l: smallint; BlockNum: Byte);
var
 Byte7,Byte8,tmpByte: byte;
begin
 Byte7:=((BlockNum and 31) shl 3); //move low 5 bits to top 5 bits of byte
 tmpByte:=FNwsByte(b,y,l,6)^;
 tmpByte:=tmpByte and 7; // mask off low 3 bits
 Byte7:=Byte7 or tmpByte;
 FNwsByte(b,y,l,6)^:=Byte7;
 Byte8:=BlockNum shr 5; //move top 3 bits to low 3 bits of byte
 tmpByte:=FNwsByte(b,y,l,7)^;
 tmpByte:=tmpByte and 24; // mask off bits 3 and 4
 Byte8:=Byte8 or tmpByte;
 FNwsByte(b,y,l,7)^:=Byte8;
end;

procedure FNputBlockNumber(d,p,y,l: smallint; BlockNum: Byte);
var
 Byte7,Byte8,tmpByte: byte;
begin
 Byte7:=((BlockNum and 31) shl 3); //move low 5 bits to top 5 bits of byte
 tmpByte:=FNTByte(d,p,y,l,6)^;
 tmpByte:=tmpByte and 7; // mask off low 3 bits
 Byte7:=Byte7 or tmpByte;
 FNTByte(d,p,y,l,6)^:=Byte7;
 Byte8:=BlockNum shr 5; //move top 3 bits to low 3 bits of byte
 tmpByte:=FNTByte(d,p,y,l,7)^;
 tmpByte:=tmpByte and 24; // mask off bits 3 and 4
 Byte8:=Byte8 or tmpByte;
 FNTByte(d,p,y,l,7)^:=Byte8;
end;

procedure UpdateBlocktop;
var
 i,j,k: smallint;
begin
 for i:=0 to nmbrsubjects do
  Blocktop[i]:=0;
 XrefGroupSubs;
 for i:=1 to GroupSubs[0] do
  Blocktop[i]:=GroupSubs[i];
 {set those in blocks to blocktop=0}
 for i:=1 to XML_DISPLAY.blocknum do
 begin
  if Sheet[i,0]>0 then
   for j:=1 to Sheet[i,0] do
   begin
    k:=Sheet[i,j];
    if ((k>0) and (k<=numCodes[0])) then
     Blocktop[GsubXref[k]]:=0;
   end; {for j}
 end; {for i}
end;

procedure addSubToGroupSubs(k: smallint);
var
 f,groupinsert,ii: smallint;
begin
 if ((k>0) and (k<=numCodes[0])) then
 begin
  f:=GsubXref[k];
  if f=0 then {add to groupsubs}
  begin
   inc(GroupSubs[0]);
   groupInsert:=GroupSubs[0];
   for ii:=1 to GroupSubs[0] do
    if (SubCode[k]<SubCode[GroupSubs[ii]]) then
    begin
     groupInsert:=ii;
     break;
    end;
   if groupInsert<GroupSubs[0] then
   for ii:=GroupSubs[0] downto (groupInsert+1) do
   begin
    GroupSubs[ii]:=GroupSubs[ii-1];
    Blocktop[ii]:=Blocktop[ii-1];
    GroupSubCount[ii]:=GroupSubCount[ii-1];
   end;
   GroupSubs[groupInsert]:=k;
   Blocktop[groupInsert]:=k;
   GroupSubCount[groupInsert]:=0;
   XrefGroupSubs;
  end;
 end;
end;

procedure updateCustomMenus;
var
 j,i: smallint;
begin

 j:=GOSmenu[0];
 try
  if wnFlag[wnStudentList] then
   with StudentListWin do
    begin
     n2.visible:=(j>0);
     grp01.visible:=(j>0);   grp11.visible:=(j>1);
     grp21.visible:=(j>2);   grp31.visible:=(j>3);
     grp41.visible:=(j>4);   grp51.visible:=(j>5);
     grp61.visible:=(j>6);   grp71.visible:=(j>7);
     grp81.visible:=(j>8);   grp91.visible:=(j>9);
     grp101.visible:=(j>10); grp111.visible:=(j>11);
     grp121.visible:=(j>12); grp131.visible:=(j>13);
     grp141.visible:=(j>14); grp151.visible:=(j>15);

     grp161.visible:=(j>16); grp171.visible:=(j>17);
     grp181.visible:=(j>18); grp191.visible:=(j>19);
     if j>0 then
      for i:=1 to j do
       case i of
        1:  grp01.caption:=GOSname[GOSmenu[i]];
        2:  grp11.caption:=GOSname[GOSmenu[i]];
        3:  grp21.caption:=GOSname[GOSmenu[i]];
        4:  grp31.caption:=GOSname[GOSmenu[i]];
        5:  grp41.caption:=GOSname[GOSmenu[i]];
        6:  grp51.caption:=GOSname[GOSmenu[i]];
        7:  grp61.caption:=GOSname[GOSmenu[i]];
        8:  grp71.caption:=GOSname[GOSmenu[i]];
        9:  grp81.caption:=GOSname[GOSmenu[i]];
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
    end; {with StudentListWin}
 except
 end;

 with mainform do
  try
   n15.visible:=(j>0);
   grp01.visible:=(j>0);   grp11.visible:=(j>1);
   grp21.visible:=(j>2);   grp31.visible:=(j>3);
   grp41.visible:=(j>4);   grp51.visible:=(j>5);
   grp61.visible:=(j>6);   grp71.visible:=(j>7);
   grp81.visible:=(j>8);   grp91.visible:=(j>9);
   grp101.visible:=(j>10); grp111.visible:=(j>11);
   grp121.visible:=(j>12); grp131.visible:=(j>13);
   grp141.visible:=(j>14); grp151.visible:=(j>15);

   grp161.visible:=(j>16); grp171.visible:=(j>17);
   grp181.visible:=(j>18); grp191.visible:=(j>19);
   if j>0 then
    for i:=1 to j do
     case i of
      1:  grp01.caption:=GOSname[GOSmenu[i]];
      2:  grp11.caption:=GOSname[GOSmenu[i]];
      3:  grp21.caption:=GOSname[GOSmenu[i]];
      4:  grp31.caption:=GOSname[GOSmenu[i]];
      5:  grp41.caption:=GOSname[GOSmenu[i]];
      6:  grp51.caption:=GOSname[GOSmenu[i]];
      7:  grp61.caption:=GOSname[GOSmenu[i]];
      8:  grp71.caption:=GOSname[GOSmenu[i]];
      9:  grp81.caption:=GOSname[GOSmenu[i]];
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
   n16.visible:=(j>0);
   grp02.visible:=(j>0);   grp12.visible:=(j>1);
   grp22.visible:=(j>2);   grp32.visible:=(j>3);
   grp42.visible:=(j>4);   grp52.visible:=(j>5);
   grp62.visible:=(j>6);   grp72.visible:=(j>7);
   grp82.visible:=(j>8);   grp92.visible:=(j>9);
   grp102.visible:=(j>10); grp112.visible:=(j>11);
   grp122.visible:=(j>12); grp132.visible:=(j>13);
   grp142.visible:=(j>14); grp152.visible:=(j>15);

   grp162.visible:=(j>16); grp172.visible:=(j>17);
   grp182.visible:=(j>18); grp192.visible:=(j>19);
   if j>0 then
    for i:=1 to j do
     case i of
      1:  grp02.caption:=GOSname[GOSmenu[i]];
      2:  grp12.caption:=GOSname[GOSmenu[i]];
      3:  grp22.caption:=GOSname[GOSmenu[i]];
      4:  grp32.caption:=GOSname[GOSmenu[i]];
      5:  grp42.caption:=GOSname[GOSmenu[i]];
      6:  grp52.caption:=GOSname[GOSmenu[i]];
      7:  grp62.caption:=GOSname[GOSmenu[i]];
      8:  grp72.caption:=GOSname[GOSmenu[i]];
      9:  grp82.caption:=GOSname[GOSmenu[i]];
      10: grp92.caption:=GOSname[GOSmenu[i]];
      11: grp102.caption:=GOSname[GOSmenu[i]];
      12: grp112.caption:=GOSname[GOSmenu[i]];
      13: grp122.caption:=GOSname[GOSmenu[i]];
      14: grp132.caption:=GOSname[GOSmenu[i]];
      15: grp142.caption:=GOSname[GOSmenu[i]];
      16: grp152.caption:=GOSname[GOSmenu[i]];

      17: grp162.caption:=GOSname[GOSmenu[i]];
      18: grp172.caption:=GOSname[GOSmenu[i]];
      19: grp182.caption:=GOSname[GOSmenu[i]];
      20: grp192.caption:=GOSname[GOSmenu[i]];
     end; {case}
 except
 end;
end;

procedure CookCustomGroup(GI: integer);
begin
  if (GI > 0) and (GI < Length(GOSname)) then
  begin
    XML_DISPLAY.StudListType := 2;  //Group
    XML_DISPLAY.GroupIndexDisplay := GI;
    setRecipeFromGOS(GI);
    GroupName:=GOSname[GI];
    REselectgroup;
    if GroupNum > 0 then
      MySelStud := StGroup[1]     //Choose the first student in the new list
    else
      MySelStud := -1;

    UpdateStudWins;
  end;
end;

procedure updateGroupSubs;
var
 i,j,k,nm: smallint;
 xi,xgroupinsert: smallint;
 xxxv:        array of smallint;
 xxxv2:        array of String;
 string1,sub1,sub2: string;
 count,subnum:      smallint;

     procedure sortGroupSubCodesbyCode;
       var
         D,H,i:         smallint;
         J,L,A,B:           smallint;
         tmpStr1,tmpStr2: string;
       label label1,label2;

     begin
      D:=1;
      while D<codeCount[0] do D:=D+D;
      label1:
      D:=(D-1) div 2;
      if D=0 then exit;
      H:=codeCount[0]-D;
      for i:=1 to H do
        begin
         J:=i;
         Label2:
         L:=J+D;
         A:=xxxv[L];
         B:=xxxv[J];

         tmpStr1:=uppercase(SubCode[A]);
         tmpStr2:=uppercase(SubCode[B]);

         if tmpStr1<tmpStr2 then
           begin
            xxxv[J]:=A;
            xxxv[L]:=B;
            dec(J,D);
           end;
         if (tmpStr1<tmpStr2) and (J>0) then goto Label2;
       end; {for}
       goto label1;
     end;

begin
  for j:=0 to nmbrSubYear do
  begin
   GroupSubs[j]:=0;
   GroupSubCount[j]:=0;
   GsubXref[j]:=0;
  end;

  {check stud choices}
  if XML_STUDENTS.numStud > 0 then
    if groupnum > 0 then
    begin
     for i:=1 to groupnum do
     begin
      nm:=StGroup[i];
      for j:=1 to chmax do
      begin
       k:=XML_STUDENTS.Stud[nm].Choices[j];
       if ((k>0) and (k<=numCodes[0])) then
       begin
        GsubXref[k]:=-1;   //just mark flag to include it
       end;
      end; {for j}
     end; {for i}
    end;

  {check blocks}
  for i:=1 to XML_DISPLAY.blocknum do
  begin
   if Sheet[i,0]>0 then
    for j:=1 to Sheet[i,0] do
    begin
     k:=Sheet[i,j];
     if ((k>0) and (k<=numCodes[0])) then
     begin
      GsubXref[k]:=-1;   //just mark flag to include it
     end;
    end; {for j}
  end; {for i}

{check for parent split sub, i.e. if ENA & ENB then add EN  }

 setlength(xxxv,nmbrsubjects+1); // xxxvI:=0;
 setlength(xxxv2,nmbrsubjects+1);

 for xi:=1 to nmbrsubjects do
 begin
  xxxv[xi]:=0;{'';}
  xxxv2[xi]:='';
 end;

 for i:=1 to codeCount[0] do
  xxxv[i]:=codepoint[i,0];   //sorted (by code) copy of subject codes

 if XML_DISPLAY.sorttype[0]<>1 then //not sorted on code allready
  sortGroupSubCodesbyCode;

 for i:=1 to numcodes[0] do
 begin
  xxxv2[i]:=copy(SubCode[i],1,lencodes[0]-1); //second copy minus last char
 end;

 string1:=''; count:=0;
 for i:=codeCount[0] downto 1 do
 begin
  subnum:=xxxv[i];
  sub1:=SubCode[subnum];
  sub2:=xxxv2[subnum];
  if string1=sub2 then
  begin
   if (GsubXref[subnum]=-1) then inc(count)
   else
    if ((count>1) and (sub1=sub2+' ')) then GsubXref[subnum]:=-1;
  end
  else
   begin
    if GsubXref[subnum]=-1 then
    begin
     count:=1; string1:=sub2;
    end;
   end;
 end; {for i}

  GroupSubs[0]:=0;
  for i:=1 to codeCount[0] do
  begin
   j:=xxxv[i];
   if GsubXref[j]=-1 then //add to group subs
   begin
    inc(GroupSubs[0]);
    xgroupInsert:=GroupSubs[0];
    GroupSubs[xgroupInsert]:=j;
    GroupSubCount[xgroupInsert]:=0;
    GsubXref[j]:=xgroupInsert;
   end;
  end;
 UpdateBlocktop;
 CountGroupSubs;
 needClashMatrixRecalc:=true;
end;

procedure CheckRecipeOffer;
begin
 chdir(Directories.datadir);
 if GOSrecipe.SubOfferName>'' then
  if GOSrecipe.SubOfferName<>OfferFile then
   if fileexists(GOSrecipe.SubOfferName+'.SBO') then
    begin
      OfferFile:=GOSrecipe.SubOfferName;
      ReadSubOfferFile;
     end;
end;

procedure setRecipeFromGOS(nm: integer);
var
  cnt, i: smallint;
begin
  if nm < Length(GOS) then
  begin
    cnt:=GOS[nm].NumSteps;
    setlength(GOSrecipe.steps,cnt+1);
    GOSrecipe.NumSteps:=cnt;
    for i:=1 to cnt do GOSrecipe.steps[i]:=GOS[nm].steps[i];
    GOSrecipe.SubOfferName:=GOS[nm].SubOfferName;
    CheckRecipeOffer;
  end;
end;

procedure saveGroupFile;
var
 f:       file;
 fn,s,msg:      string;
 i,k,a:       smallint;
begin
 fn:='GROUP.DAT';
 try
   begin
    try
      assign(f,fn);
      rewrite(f,1);
       s:='TC52';
       blockwrite(f,s[1],4);
       blockwrite(f,GOSnum,2);
       if GOSnum>0 then
       begin
        for i:=1 to GOSnum do
        begin
         a:=length(GOSname[i]);
         blockwrite(f,a,2);
         if a>0 then blockwrite(f,GOSname[i][1],a);
         a:=length(GOS[i].SubOfferName);
         blockwrite(f,a,2);
         if a>0 then blockwrite(f,GOS[i].SubOfferName[1],a);
         blockwrite(f,GOS[i].NumSteps,2);  {num sels in grp}
         for k:=1 to GOS[i].NumSteps do
         begin
           blockwrite(f,GOS[i].steps[k].slct,2);
           blockwrite(f,GOS[i].steps[k].meth,2);
            s:=RpadString(GOS[i].steps[k].e1,10);
           blockwrite(f,s[1],10);
            s:=RpadString(GOS[i].steps[k].e2,10);
           blockwrite(f,s[1],10);
         end; {for k}
        end; {for i}
        blockwrite(f,GOSmenu[0],2);
        if GOSmenu[0]>0 then
         for k:=1 to GOSmenu[0] do
          blockwrite(f,GOSmenu[k],2);
       end; {for GOSnum>0}

      finally
       closefile(f);
       FileAge(fn,NEW_DateChecks[5]);
      end;
   end;
  except
   msg:='Error saving Group file.'+endline;
   messagedlg(msg,mtWarning,[mbOK],0);
  end;
end;

procedure saveGroups;
begin
 if (usrPasslevel=utGen) then exit;
 if UsrPassLevel=utSuper then
  begin
   chdir(Directories.DataDir);
   SaveGroupFile;
   exit;
  end;
 if verifyUserDirectory(usrPassDir)>0 then exit;
 chdir(usrPassDir);  //user with access rights & password
 SaveGroupFile;
end;

procedure SetGOSunit(a,b,num,slct1,meth1: smallint; en1,en2: string);
begin
 GOS[a].NumSteps:=num;
 GOS[a].steps[b].slct:=slct1;
 GOS[a].steps[b].meth:=meth1;
 GOS[a].steps[b].e1:=en1;
 GOS[a].steps[b].e2:=en2;
 GOS[a].SubOfferName:='';
end;

procedure MakeGOS;
var
 i,a:       smallint;
begin
 setlength(GOS,nmbryears+1);
 setlength(GOSname,nmbryears+1);
 for i:=0 to nmbryears do setlength(GOS[i].steps,2+1);
 GOSnum:=1;
 SetGOSunit(0,0,1,0,0,'','');
 SetGOSunit(1,1,1,0,0,'',''); GOSname[1]:='All';
 GOSmenu[0]:=0; {none}
 a:=1;
 try
  for i:=years_minus_1 downto 0 do
   if yearStat[i].numstud>0 then
   begin
    inc(a);
    GOSname[a]:=yeartitle+' '+yearname[i];
    GOS[a].SubOfferName:='';
    SetGOSunit(a,1,1,1,0,yearname[i],'');
   end;
  GOSnum:=a; {nmbr of groups}
  GOSmenu[0]:=a;
  for i:=1 to a do GOSmenu[i]:=i;
  saveGroups;
 except
 end;

end;

procedure CheckGOSyears;
var
 i,j: smallint;
 needYr: array[0..nmbryears+1] of boolean;
 changeFlag: boolean;
begin
 changeFlag:=false;
 if GOSnum<1 then begin MakeGOS; exit; end;
 for i:=0 to years_minus_1 do needYr[i]:= (yearStat[i].numstud>0);
 for i:=1 to GOSnum do
  if GOS[i].NumSteps=1 then
   if ((GOS[i].steps[1].slct=1) and (GOS[i].steps[1].meth=0)) then
    for j:=0 to years_minus_1 do if GOS[i].steps[1].e1=yearname[j] then needYr[j]:=false;
 for i:=years_minus_1 downto 0 do
   if needYr[i] then
   begin
    changeFlag:=true;
    inc(GOSnum);
    setlength(GOS,GOSnum+1);
    setlength(GOSname,GOSnum+1);  setlength(GOS[GOSnum].steps,2+1);
    GOSname[GOSnum]:=yeartitle+' '+yearname[i];
    GOS[GOSnum].SubOfferName:='';
    SetGOSunit(GOSnum,1,1,1,0,yearname[i],'');
    if GOSmenu[0]<nmbrCustomGroupMenus then
     begin
      inc(GOSmenu[0]);
      GOSmenu[GOSmenu[0]]:=GOSnum;
     end;
   end;
 if changeFlag then SaveGroups;
end;

procedure loadGroups;
var
 f:       file;
 fn,s:      string;
 dummy: smallint;

 function ReadEntry(len: smallint): string;
 begin
  s:=RpadString('',len); blockread(f,s[1],len);
  result:=trim(s);
 end;

    procedure loadGOSold;
    var
     i,k,a,m,n:       smallint;
    begin
     blockread(f,GOSnum,2); blockread(f,dummy,2);
     ReadEntry(10);  ReadEntry(10);
     setlength(GOS,GOSnum+1);
     setlength(GOSname,GOSnum+1);
     if GOSnum>0 then
      for i:=1 to GOSnum do
       begin
        GOSname[i]:=ReadEntry(250); GOS[i].SubOfferName:='';
        blockread(f,a,2);
        if a>50 then a:=0;
        setlength(GOS[i].steps,a+1);
        GOS[i].NumSteps:=a;                 {num sels in grp}
        blockread(f,GOS[i].steps[0].meth,2);
        GOS[i].steps[0].e1:=ReadEntry(10);
        GOS[i].steps[0].e2:=ReadEntry(10);
        for k:=1 to a do
         begin
          blockread(f,GOS[i].steps[k].slct,2);
          blockread(f,GOS[i].steps[k].meth,2);
          GOS[i].steps[k].e1:=ReadEntry(10);
          GOS[i].steps[k].e2:=ReadEntry(10);;
         end; {for k}
        blockread(f,m,2);
        if m>nmbrsubjects then m:=0;
        if m>0 then for n:=1 to m do blockread(f,dummy,2);
       end; {for i}
       blockread(f,GOSmenu[0],2);
        IntRange(GOSmenu[0],0,nmbrCustomGroupMenus);
       if GOSmenu[0]>0 then
        for k:=1 to GOSmenu[0] do
        begin
         blockread(f,GOSmenu[k],2);
         IntRange(GOSmenu[k],0,GOSnum);
        end;
    end;


   procedure loadGOSnew;
    var
     i,k,a:       smallint;
    begin
     blockread(f,GOSnum,2);
     setlength(GOS,GOSnum+1);
     setlength(GOSname,GOSnum+1);
     if GOSnum>0 then
      for i:=1 to GOSnum do
       begin
        blockread(f,a,2);
        if a>0 then GOSname[i]:=ReadEntry(a) else GOSname[i]:='';
        blockread(f,a,2);
        if a>0 then GOS[i].SubOfferName:=ReadEntry(a) else GOS[i].SubOfferName:='';
        blockread(f,a,2);
        if a>50 then a:=0;
        setlength(GOS[i].steps,a+1);
        GOS[i].NumSteps:=a;                 {num sels in grp}
        GOS[i].Steps[0].slct:=0; GOS[i].steps[0].meth:=0;
        GOS[i].steps[0].e1:=''; GOS[i].steps[0].e2:='';
        for k:=1 to a do
         begin
          blockread(f,GOS[i].steps[k].slct,2);
          blockread(f,GOS[i].steps[k].meth,2);
          GOS[i].steps[k].e1:=ReadEntry(10);
          GOS[i].steps[k].e2:=ReadEntry(10);;
         end; {for k}

       end; {for i}
       blockread(f,GOSmenu[0],2);
        IntRange(GOSmenu[0],0,nmbrCustomGroupMenus);
       if GOSmenu[0]>0 then
        for k:=1 to GOSmenu[0] do
        begin
         blockread(f,GOSmenu[k],2);
         IntRange(GOSmenu[k],0,GOSnum);
        end;
    end;
begin
         if (usrPasslevel=utGen) or (usrPassLevel=utSuper) then
  chdir(Directories.datadir)  //general access or supervisor
 else
  chdir(usrPassDir);  //user with access rights & password
 fn:='GROUP.DAT';
 if fileexists(fn) then
 begin
  try
   try
     assign(f,fn);
     filemode:=fmOpenRead+fmShareDenyNone;
     reset(f,1);
     s:='AMIG';
     blockread(f,s[1],4);
     if s='TC52' then loadGOSNew
      else if s='TC5W' then loadGOSOld
       else MakeGOS;

   finally
    closefile(f);
    checkGOSyears;
   end;

   except
   end;
  end
 else MakeGOS;
 try
   updateCustomMenus;
 except
 end;

end;

function StudClashinBlocks(st_i:integer):boolean;
 var
  p,j,a,k:   integer;
  c:         array[0..nmbrBlocks] of integer;
begin
  result:=false;
  for p:=1 to XML_DISPLAY.blocknum do c[p]:=0;
  for j:=1 to chmax do
   begin
    a:=XML_STUDENTS.Stud[st_i].choices[j];
    if a<>0 then
      for p:=1 to XML_DISPLAY.blocknum do
       begin
          if Sheet[p,0]>0 then
            for k:=1 to Sheet[p,0] do
              if a=Sheet[p,k] then
                begin
                 inc(c[p]);
                 if c[p]>1 then
                   begin
                    result:=true;
                    break;
                   end;
                end;
          if c[p]>1 then break;
       end;  {for p}
   end; {for j}
end;

procedure SetBclashesGroup(methodSel:integer);
  var
    i,st_i:    integer;

begin
  countsubsinblock;
  if blockload=0 then exit;
  case methodSel of
    0: begin {new}
        for i:=1 to XML_STUDENTS.numstud do
         begin
          st_i:=i;
          if StudClashinBlocks(st_i) then StudGrpFlg[st_i]:=1
              else StudGrpFlg[st_i]:=0;
         end; {for i}
       end; {methodSel=0}
    1: begin {add to}
        for i:=1 to XML_STUDENTS.numstud do
         begin
          st_i:=i;
          if StudClashinBlocks(st_i) then StudGrpFlg[st_i]:=1;
         end; {for i}
       end; {methodSel=1}
    2: begin {select from}
        for i:=1 to groupnum do
         begin
          st_i:=StGroup[i];
          if StudClashinBlocks(st_i) then StudGrpFlg[st_i]:=1
           else StudGrpFlg[st_i]:=0;
         end; {for i}
       end; {methodSel=2}
  end; {case methodsel}
end;

function StudFreeinBlock(st_i,ablock:integer):boolean;
 var
  p,j,a,k:   integer;

begin
 result:=true;
 for j:=1 to chmax do
  begin
   a:=XML_STUDENTS.Stud[st_i].choices[j];
   if a<>0 then
    begin
     p:=ablock;
     if (Sheet[p,0]>0) then
       begin
        for k:=1 to Sheet[p,0] do
         begin
          if a=Sheet[p,k] then
           begin result:=false; break; end;
         end; {for k}
       end;  {Sheet[p,0]>0}
    end; {a<>0}
   if result=false then break;
  end; {for j}
end;

procedure SetBfreeGroup(methodSel:integer);
  var
    i,st_i,ablock:    integer;
begin
 countsubsinblock;
 ablock:=strtointdef(groupSelStr[1],1);
  if (blockload=0) or (ablock<1) or (ablock>XML_DISPLAY.blocknum)
      then exit;  {no blocks loaded, or ablock out of range}
  case methodSel of
    0:begin {new}
       for i:=1 to XML_STUDENTS.numstud do
        begin
         st_i:=i;
         if StudFreeinBlock(st_i,ablock) then StudGrpFlg[st_i]:=1
              else StudGrpFlg[st_i]:=0;
        end; {for i}
       end; {methodSel=0}
    1: begin {add to}
        for i:=1 to XML_STUDENTS.numstud do
         begin
          st_i:=i;
          if StudFreeinBlock(st_i,ablock) then StudGrpFlg[st_i]:=1;
         end; {for i}
       end; {methodSel=1}
    2: begin {select from}
        for i:=1 to groupnum do
         begin
          st_i:=StGroup[i];
          if StudFreeinBlock(st_i,ablock) then StudGrpFlg[st_i]:=1
           else StudGrpFlg[st_i]:=0;
         end; {for i}
       end; {methodSel=2}
  end; {case methodsel}
end;

function StudInSub(st_i,asub:integer):boolean;
var
 a,j:      integer;
 strB,strC:   string;
begin
 result:=false;
 strB:=copy(SubCode[abs(asub)],1,lencodes[0]-1);
 for j:=1 to chmax do begin
   a:=XML_STUDENTS.Stud[st_i].choices[j];
   if ((asub>0) and (a=asub)) then
     begin
      result:=true;
      break;
     end;
   if ((asub<0) and (a>0)) then
     begin
      strC:=copy(SubCode[a],1,lencodes[0]-1);
      if strC=strB then
       begin
        result:=true;
        break;
       end;
     end;
  end; {for j}
end;

procedure SetSubGroup(methodSel:integer);
var
 st_i,i,j,tmpNum:    integer;
 codeStr:            string;
 matchArr:           array of integer;
begin
 if Numcodes[0]=0 then exit; {no subjects to select}
 codeStr:=uppercase(trim(groupSelStr[1]));
 tmpNum:=checkWildSub(codeStr);
 if methodSel<>3 then if tmpNum=0 then exit;
 setlength(matchArr,nmbrSubjects+1);
 case methodSel of
   0:begin {new}
       for i:=1 to XML_STUDENTS.numstud do
        begin
         st_i:=i;
         if StudInSub(st_i,tmpNum) then StudGrpFlg[st_i]:=1
              else StudGrpFlg[st_i]:=0;
        end; {for i}
       end; {methodSel=0}
    1: begin {add to}
        for i:=1 to XML_STUDENTS.numstud do
         begin
          st_i:=i;
          if StudInSub(st_i,tmpNum) then StudGrpFlg[st_i]:=1;
         end; {for i}
       end; {methodSel=1}
    2: begin {select from}
        for i:=1 to groupnum do
         begin
          st_i:=StGroup[i];
          if StudInSub(st_i,tmpNum) then StudGrpFlg[st_i]:=1
           else StudGrpFlg[st_i]:=0;
         end; {for i}
       end; {methodSel=2}
    3: begin {match to}
        for i:=0 to numCodes[0] do matchArr[i]:=0; {init MatchArray}
        for i:=1 to groupnum do
         begin
          st_i:=StGroup[i];
          for j:=1 to chmax do
               matchArr[XML_STUDENTS.Stud[st_i].choices[j]]:=1;
         end;
        for i:=1 to XML_STUDENTS.numstud do
          for j:=1 to chmax do
            if matchArr[XML_STUDENTS.Stud[i].choices[j]]=1 then
              if (XML_STUDENTS.Stud[i].choices[j]>0) then
                  StudGrpFlg[i]:=1;
       end;
 end; {case methodsel}
end;

function StudHasTag(atag,st_i:integer):boolean;
begin
 result:=false;
 if atag<0 then {all}
   begin
     if XML_STUDENTS.Stud[st_i].tctag<>0 then result:=true;
   end
 else  {only one tag}
   begin
     if bool(XML_STUDENTS.Stud[st_i].tctag and (1 shl (atag-1))) then result:=true;
   end;
end;

procedure SetTagGroup(methodSel:integer);
var
 i,j,st_i,tmpNum:      integer;
 codeStr:         string;
 matchArr:        array of integer;
begin
 codestr:=trim(groupSelStr[1]);
 tmpNum:=0;
 for i:=1 to nmbrTags do
  if codestr=TagCode[i] then tmpNum:=i;
 if codestr='*' then tmpNum:=-1;
 if ((tmpNum=0) and (methodSel<>3)) then exit;
 setlength(matchArr,10);
 case methodSel of
   0:begin {new}
       for i:=1 to XML_STUDENTS.numstud do
        begin
         st_i:=i;
         if StudHasTag(tmpNum,st_i) then StudGrpFlg[st_i]:=1
              else StudGrpFlg[st_i]:=0;
        end; {for i}
     end; {methodSel=0}
   1: begin {add to}
        for i:=1 to XML_STUDENTS.numstud do
         begin
          st_i:=i;
          if StudHasTag(tmpNum,st_i) then StudGrpFlg[st_i]:=1;
         end; {for i}
      end; {methodSel=1}
   2: begin {select from}
        for i:=1 to groupnum do
         begin
          st_i:=StGroup[i];
          if StudHasTag(tmpNum,st_i) then StudGrpFlg[st_i]:=1
           else StudGrpFlg[st_i]:=0;
         end; {for i}
      end; {methodSel=2}
   3: begin {match to}
        for i:=0 to 8 do matchArr[i]:=0; {init MatchArray}
        for i:=1 to groupNum do  {scan group}
          begin
            st_i:=StGroup[i];
            for j:=1 to 8 do
              if bool(XML_STUDENTS.Stud[st_i].tctag and (1 shl (j-1))) then
                 matchArr[j]:=1;
          end;{for i}
        for i:=1 to XML_STUDENTS.numstud do
          for j:=1 to 8 do
            begin
               if bool(XML_STUDENTS.Stud[i].tctag and (1 shl (j-1))) then
                 if matchArr[j]=1 then
                   begin
                    StudGrpFlg[i]:=1;
                    break;
                   end;
            end; {j}
      end; {match to}
 end; {case methodsel}
end;

procedure SetRoomGroup(methodSel:integer);
var
 i,st_i,tmpNum:      integer;
 codeStr:         string;
 matchArr:        array of integer;
begin
 if Numcodes[2]=0 then exit;
 codeStr:=uppercase(trim(groupSelStr[1]));
 tmpNum:=checkcode(2,codeStr);
 if ((tmpNum=0) and (methodSel<>3)) then exit;
 setlength(matchArr,numCodes[2]+1);
 case methodSel of
   0:begin {new}
      for i:=1 to XML_STUDENTS.numstud do
        if XML_STUDENTS.Stud[i].home=tmpNum then StudGrpFlg[i]:=1
          else StudGrpFlg[i]:=0;
     end; {new}
   1:begin {add to}
       for i:=1 to XML_STUDENTS.numstud do
         if XML_STUDENTS.Stud[i].home=tmpNum then StudGrpFlg[i]:=1;
     end; {methodSel=1}
   2:begin {select from}
       for i:=1 to groupnum do
        begin
         st_i:=StGroup[i];
         if XML_STUDENTS.Stud[st_i].home=tmpNum then StudGrpFlg[st_i]:=1
          else StudGrpFlg[st_i]:=0;
        end; {for i}
     end; {methodSel=2}
   3:begin {match to}
      for i:=0 to numCodes[2] do matchArr[i]:=0; {init MatchArray}
      for i:=1 to groupNum do  {scan group}
       begin
         st_i:=StGroup[i];
         matchArr[XML_STUDENTS.Stud[st_i].home]:=1;
       end;
      for i:=1 to XML_STUDENTS.numstud do
       if matchArr[XML_STUDENTS.Stud[i].home]=1 then
        if (XML_STUDENTS.Stud[i].home>0) then StudGrpFlg[i]:=1;
     end; {match to}
 end; {case methodsel}
end;

procedure SetTutorGroup(methodSel:integer);
var
 i,st_i,tmpNum:      integer;
 codeStr:         string;
 matchArr:        array of integer;
begin
 if Numcodes[1]=0 then exit;
 codeStr:=uppercase(trim(groupSelStr[1]));
 tmpNum:=checkcode(1,codeStr);
 if ((tmpNum=0) and (methodSel<>3)) then exit;
 setlength(matchArr,numCodes[1]+1);
 case methodSel of
   0:begin {new}
      for i:=1 to XML_STUDENTS.numstud do
        if XML_STUDENTS.Stud[i].tutor=tmpNum then StudGrpFlg[i]:=1
          else StudGrpFlg[i]:=0;
     end; {new}
   1:begin {add to}
       for i:=1 to XML_STUDENTS.numstud do
         if XML_STUDENTS.Stud[i].tutor=tmpNum then StudGrpFlg[i]:=1;
     end; {methodSel=1}
   2:begin {select from}
       for i:=1 to groupnum do
        begin
         st_i:=StGroup[i];
         if XML_STUDENTS.Stud[st_i].tutor=tmpNum then StudGrpFlg[st_i]:=1
          else StudGrpFlg[st_i]:=0;
        end; {for i}
     end; {methodSel=2}
   3:begin {match to}
      for i:=0 to numCodes[1] do matchArr[i]:=0; {init MatchArray}
      for i:=1 to groupNum do  {scan group}
       begin
         st_i:=StGroup[i];
         matchArr[XML_STUDENTS.Stud[st_i].tutor]:=1;
       end;
      for i:=1 to XML_STUDENTS.numstud do
       if matchArr[XML_STUDENTS.Stud[i].tutor]=1 then
       if (XML_STUDENTS.Stud[i].tutor>0) then StudGrpFlg[i]:=1;
     end; {match to}
 end; {case methodsel}
end;

procedure SetIDGroup(grType,methodSel:integer);
var
 i,st_i:               integer;
 codeStr,codeStr2:      string;
 byval:                 boolean;
 IDval1,IDval2:         longint;

   function StudInID(st:integer):boolean;
   var
    IDval3: longint;
    tmpStr: string;
   begin
    result:=false;
    if byval then
      begin
        IDval3:=strtointdef(XML_STUDENTS.Stud[st].ID,0);
        if ((IDval3>=IDval1) and (IDval3<=IDval2)) then result:=true;
      end
    else
      begin
        tmpStr:=trim(Uppercase(XML_STUDENTS.Stud[i].ID));
        if ((tmpStr>=codeStr) and (tmpStr<=codeStr2)) then result:=true;
      end;
   end;

begin
 codeStr:=uppercase(trim(groupSelStr[1]));
 codeStr2:=uppercase(trim(groupSelStr[2]));
 if codestr2<codeStr then codeStr2:=codestr;
 if grType=11 then byval:=true else byval:=false;
 IDval1:=strtointdef(codeStr,0); IDval2:=strtointdef(codestr2,0);
     {Groupname:='ID range'; }

 case methodSel of
   0:begin {new}
       for i:=1 to XML_STUDENTS.numstud do
        begin
         st_i:=i;
         if StudInID(st_i) then StudGrpFlg[st_i]:=1
              else StudGrpFlg[st_i]:=0;
        end; {for i}
       end; {methodSel=0}
    1: begin {add to}
        for i:=1 to XML_STUDENTS.numstud do
         begin
          st_i:=i;
          if StudInID(st_i) then StudGrpFlg[st_i]:=1;
         end; {for i}
       end; {methodSel=1}
    2: begin {select from}
        for i:=1 to groupnum do
         begin
          st_i:=StGroup[i];
          if StudInID(st_i) then StudGrpFlg[st_i]:=1
           else StudGrpFlg[st_i]:=0;
         end; {for i}
       end; {methodSel=2}
 end;  {case}
end;

procedure SetHouseGroup(methodSel:integer);
var
 a,i,st_i,tmpNum:      integer;
 codeStr:         string;
 matchArr:        array of integer;

  function StudInHouse(st:integer):boolean;
   begin
    result:=false;
    a:=XML_STUDENTS.Stud[st].House;
    if (a>0) and ((a=tmpNum) or (tmpNum=-1)) then result:=true;
   end;

begin
 if HouseCount=0 then exit;
 codeStr:=uppercase(trim(groupSelStr[1]));
 tmpNum:=findHouse2(codeStr);
 if codeStr='*' then tmpNum:=-1;
 if ((tmpNum=0) and (methodSel<>3)) then exit;
 setlength(matchArr,housecount+1);
 case methodSel of
   0:begin {new}
      for i:=1 to XML_STUDENTS.numstud do
       begin
        st_i:=i;
        if StudInHouse(st_i) then StudGrpFlg[i]:=1
          else StudGrpFlg[i]:=0;
       end;
     end; {new}
   1:begin {add to}
       for i:=1 to XML_STUDENTS.numstud do
        begin
         st_i:=i;
         if StudInHouse(st_i) then StudGrpFlg[i]:=1;
        end;
     end; {methodSel=1}
   2:begin {select from}
       for i:=1 to groupnum do
        begin
         st_i:=StGroup[i];
         if StudInHouse(st_i) then StudGrpFlg[st_i]:=1
          else StudGrpFlg[st_i]:=0;
        end; {for i}
     end; {methodSel=2}
   3:begin {match to}
      for i:=0 to HouseCount do matchArr[i]:=0; {init MatchArray}
      for i:=1 to groupNum do  {scan group}
       begin
         st_i:=StGroup[i];
         matchArr[XML_STUDENTS.Stud[st_i].house]:=1;
       end;
      for i:=1 to XML_STUDENTS.numstud do
       if matchArr[XML_STUDENTS.Stud[i].house]=1 then
       if (XML_STUDENTS.Stud[i].house>0) then StudGrpFlg[i]:=1;
     end; {match to}
 end; {case methodsel}
end;

procedure SetClassGroup(methodSel:integer);
var
 a,i,st_i,tmpNum:      integer;
 tmpGroup,wcPos:       integer;
 codeStr:         string;
 matchArr:        array of integer;

  function StudInClass(st:integer):boolean;
   begin
    result:=false;
    a:=XML_STUDENTS.Stud[st].tcClass;
    if (a>0) then
     begin
      if (a=tmpNum) or (tmpNum=-1) then result:=true;
      if tmpGroup<>0 then if codeStr=uppercase(copy(trim(ClassCode[a]),1,wcPos-1))
        then result:=true;
     end;
   end;
begin
 if classnum=0 then exit;
 codeStr:=uppercase(trim(groupSelStr[1]));
 tmpNum:=findClass2(codeStr);tmpGroup:=0;
 if codeStr='*' then tmpNum:=-1;
 wcPos:=pos('*',codeStr);
 if wcPos>1 then
   begin
    codeStr:=copy(codeStr,1,wcPos-1);
    tmpGroup:= findClass2(codeStr);
   end;
 if ((tmpNum=0) and (tmpGroup=0) and (methodSel<>3)) then exit;
 setlength(matchArr,classnum+1);
 case methodSel of
   0:begin {new}
      for i:=1 to XML_STUDENTS.numstud do
       begin
        st_i:=i;
        if StudInClass(st_i) then StudGrpFlg[i]:=1
          else StudGrpFlg[i]:=0;
       end;
     end; {new}
   1:begin {add to}
       for i:=1 to XML_STUDENTS.numstud do
        begin
         st_i:=i;
         if StudInClass(st_i) then StudGrpFlg[i]:=1;
        end;
     end; {methodSel=1}
   2:begin {select from}
       for i:=1 to groupnum do
        begin
         st_i:=StGroup[i];
         if StudInClass(st_i) then StudGrpFlg[st_i]:=1
          else StudGrpFlg[st_i]:=0;
        end; {for i}
     end; {methodSel=2}
   3:begin {match to}
      for i:=0 to Classnum do matchArr[i]:=0; {init MatchArray}
      for i:=1 to groupNum do  {scan group}
       begin
         st_i:=StGroup[i];
         matchArr[XML_STUDENTS.Stud[st_i].tcClass]:=1;
       end;
      for i:=1 to XML_STUDENTS.numstud do
       if matchArr[XML_STUDENTS.Stud[i].tcClass]=1 then
       if (XML_STUDENTS.Stud[i].tcClass>0) then StudGrpFlg[i]:=1;
     end; {match to}
 end; {case methodsel}
end;

procedure SetYearGroup(methodSel:integer);
var
 i,st_i,tmpNum:      integer;
 codeStr:         string;
 matchArr:        array of integer;
begin
 codeStr:=uppercase(trim(groupSelStr[1]));
 tmpNum:=findyear(codeStr);
 if ((tmpNum=-1) and (methodSel<>3)) then exit;
 setlength(matchArr,nmbrYears+1);
 case methodSel of
   0:begin {new}
      for i:=1 to XML_STUDENTS.numstud do
        if XML_STUDENTS.Stud[i].TcYear=tmpNum then StudGrpFlg[i]:=1
          else StudGrpFlg[i]:=0;
     end; {new}
   1:begin {add to}
       for i:=1 to XML_STUDENTS.numstud do
         if XML_STUDENTS.Stud[i].TcYear=tmpNum then StudGrpFlg[i]:=1;
     end; {methodSel=1}
   2:begin {select from}
       for i:=1 to groupnum do
        begin
         st_i:=StGroup[i];
         if XML_STUDENTS.Stud[st_i].TcYear=tmpNum then StudGrpFlg[st_i]:=1
          else StudGrpFlg[st_i]:=0;
        end; {for i}
     end; {methodSel=2}
   3:begin {match to}
      for i:=0 to nmbrYears do matchArr[i]:=0; {init MatchArray}
      for i:=1 to groupNum do  {scan group}
       begin
         st_i:=StGroup[i];
         matchArr[XML_STUDENTS.Stud[st_i].TcYear]:=1;
       end;
      for i:=1 to XML_STUDENTS.numstud do
       if matchArr[XML_STUDENTS.Stud[i].TcYear]=1 then
       if (XML_STUDENTS.Stud[i].TcYear>0) then StudGrpFlg[i]:=1;
     end; {match to}
 end; {case methodsel}
end;

procedure REselectgroup;
var
 i,j,k,m:     integer;
 num:        integer;
 oldStudSelcode:      integer;
 methodSel:           integer;
 matchArr:         array of integer;
begin
 setlength(StGroup,(XML_STUDENTS.numStud+1)); {zero based so +1}
 setlength(StudGrpFlg,(XML_STUDENTS.numStud+1)); {zero based so +1}
 setlength(matchArr,nmbrSubjects+1);
 oldStudSelcode:=-1;
 {protect stud selcode}
 if wnFlag[wnStudentList] then
 begin
  try
   if studentlistwin.selcode>0 then oldStudSelcode:=studentlistwin.selcode;
  except
   oldStudSelcode:=0;
   studentlistwin.selcode:=0;
  end;
 end;

// clear StudGrpFlg
 for i:=1 to XML_STUDENTS.numstud do StudGrpFlg[i]:=0;

 for i:=1 to GOSrecipe.NumSteps do
 begin
  GroupType:=GOSrecipe.steps[i].slct;
  methodSel:=GOSrecipe.steps[i].meth;
  groupSelStr[1]:=GOSrecipe.steps[i].e1;
  groupselstr[2]:=GOSrecipe.steps[i].e2;
  case GroupType of
   0: for j:=1 to XML_STUDENTS.numstud do StudGrpFlg[j]:=1;  {all}
   1: SetYearGroup(methodSel);  {year}
   2:SetClassGroup(methodSel);  {class}
   3:SetHouseGroup(methodSel);  {house}
   4,11: SetIDGroup(GroupType,methodSel);   {ID}
   5: SetTutorGroup(methodSel); {tutor}
   6: SetRoomGroup(methodSel); {room}
   7: SetTagGroup(methodSel); {tag}
   8: SetSubGroup(methodSel); {subject}
   9: SetBclashesGroup(methodSel);   {block clashes}
   10: SetBfreeGroup(methodSel);   {free in block}
  end; {case}

  num:=0;
  for k:=1 to XML_STUDENTS.numstud do
  begin
   j:=StudSort[k];
   if StudGrpFlg[j]>0 then
      begin inc(num); StGroup[num]:=j; end;
  end; {for k}
  groupnum:=num;
 end;

 if wnFlag[wnStudentList] then
 begin
  if ((XML_DISPLAY.StudListType<>7) and (studentlistwin.selcode>0)) then   {restore stud selcode}
  begin
   studentpointerset;
   m:=0;
   if XML_DISPLAY.StudListType=1 then
   begin
    for k:=1 to ListStudentSelection[0] do
    begin
     if ListStudentSelection[k]=oldStudSelcode then
     begin
      m:=k;
      break;
     end;
    end;
   end
   else
    begin
     for k:=1 to groupnum do
     begin
      if StGroup[k]=oldStudSelcode then
      begin
       m:=k;
       break;
      end;
     end;
    end;

   if m=0 then
    studentlistwin.selcode:=m;  //previous selection no longer part of selection - so remove it
  end;
 end;  {if wnFlag[wnStudentList]}

if loadFinished then updateGroupSubs;
end;

function GetNextClipStr: string;
var
 i,j: integer;
begin
 i:=pos(ht,genText); {i=position of next tab}
 j:=pos(cr,genText); {j=position of next cr}
 if ((j>0) and ((i=0) or (j<i))) then  {if no tab or cr first, then use cr}
   begin i:=j; GotCr:=true; end;
 if (i=0) then i:=length(genText)+1;
 result:=copy(genText,1,i-1);
 genText:=copy(genText,i+1,length(genText));
 if (genText>'') and (genText[1]=lf) then   {remove lf }
   genText:=copy(genText,2,length(genText));
end;

procedure getClipCell(var su,te,ro,flg: smallint);
var
 i: integer;
 suStr,teStr,roStr,labStr: string;
 ss: string;
begin
 GotCr:=false;
 ss:=GetNextClipStr; labStr:=ss; ss:=trim(ss); SuStr:=ss; su:=checkcode(0,ss); {su}
 ss:=GetNextClipStr; ss:=trim(ss); teStr:=ss; te:=checkcode(1,ss); {te}
 ss:=GetNextClipStr; ss:=trim(ss); roStr:=ss; ro:=checkcode(2,ss); {ro}
 if customPaste then
  begin
   ss:=GetNextClipStr; flg:=strtointdef(ss,0); {flags}
  end;
 {check if need to treat as label}
 if ((teStr='') and (roStr='') and (su=0) and (suStr >'')) then
  begin
   i:=FindLabel;
   TcLabel[i]:=labStr;
   su:=LabelBase+i; te:=0; ro:=0; flg:=0{te,ro,flg blank for label}
  end;
  {count invalid inputs which had no matches for use in showing message}
  if ((su=0) and (suStr>'')) then inc(suMissedCnt);
  if ((te=0) and (teStr>'')) then inc(teMissedCnt);
  if ((ro=0) and (roStr>'')) then inc(roMissedCnt);
end;

procedure getClipBlkCell(var su: smallint);
var
 suStr,ss: string;
begin
 GotCr:=false;
 ss:=GetNextClipStr; ss:=trim(ss); suStr:=ss; su:=checkcode(0,ss); {su}
 if ((su=0) and (suStr>'')) then inc(suMissedCnt);
 ss:=GetNextClipStr; {stud count}
end;

function MessageEnd(cnt: integer): string;
begin
 if Cnt>1 then result:='entries'+endline
   else result:='entry'+endline;
end;

procedure CheckPasteMsg;
var
 Msg: string;
begin
 if ((suMissedCnt>0) or (teMissedCnt>0) or (roMissedCnt>0)) then
  begin
   Msg:='Not all entries were pasted because one or more codes did not match your data:'
          +endline+endline;
   if suMissedCnt>0 then Msg:=Msg+'    '
      +IntToStr(suMissedCnt)+' subject '+MessageEnd(suMissedCnt);
   if teMissedCnt>0 then Msg:=Msg+'    '
      +IntToStr(teMissedCnt)+' teacher '+MessageEnd(teMissedCnt);
   if roMissedCnt>0 then Msg:=Msg+'    '
      +IntToStr(roMissedCnt)+' room '+MessageEnd(roMissedCnt);
   messagedlg(Msg, mtWarning, [mbOK], 0)
  end;
end;

procedure getTextFromClipboard(clpFormatToUse:word);
var
  MyHandle: Thandle;
  TextPtr: PChar;
  tmpStr: ansistring;
begin
  genText:='';
  if not(Clipboard.HasFormat(clpFormatToUse)) then exit;
  ClipBoard.Open;
  try
    MyHandle:= GetClipboardData(clpFormatToUse);
     TextPtr := GlobalLock(MyHandle);
    try

     setlength(tmpStr,length(PChar(TextPtr)));
     tmpStr:=PChar(TextPtr);
     setlength(genText,length(tmpStr));
     genText := Copy(tmpstr,1,length(tmpstr));  {leave it in our global clip string}
    finally
     GlobalUnlock(MyHandle);
    end;
  finally
    Clipboard.Close;
  end;
end;

procedure copyTextToClipboard(cf: word);
var
  Data,Data2: THandle;  {0-text only, 1-our stud +txt, 2-tt+ +txt, 3 block+ +txt}
  DataPtr,DataPtr2: Pointer;
  len,len2:              integer;
begin
  { Allocate memory from global heap }
  len:=length(studText);  len2:=length(genText);
  Data := GlobalAlloc(GMEM_MOVEABLE, len);
  Data2 := GlobalAlloc(GMEM_MOVEABLE, len2);
  try
    DataPtr := GlobalLock(Data);   { Get a pointer to the memory area }
    DataPtr2 := GlobalLock(Data2);
    try
      Move(studText[1], DataPtr^, len); { Move the data in Buffer to DataPtr }
      Move(genText[1], DataPtr2^, len2);
      ClipBoard.Open;
      try
        case cf of
         cfTtable: begin
              ClipBoard.SetAsHandle(CF_AMIG_Timetable_Data, Data);
              ClipBoard.SetAsHandle(CF_TEXT, Data2);
            end;
         cfBlock: begin
              ClipBoard.SetAsHandle(CF_AMIG_Block_Data, Data);
              ClipBoard.SetAsHandle(CF_TEXT, Data2);
            end;
        end; {case}
      finally
        Clipboard.Close;
      end
    finally
      GlobalUnlock(Data);               { Unlock the globally allocated memory  }
      GlobalUnlock(Data2);
    end;
  except
    GlobalFree(Data);                   { Free the memory allocated, only if    }
    GlobalFree(Data2);
    raise;                              { an exception occurs as this memory is }
  end;                                  { managed by Windows.             }
end;

procedure sortClassCodes;
  var
    D,H,i,pos:         smallint;
    J,L,A,B,cnum:           smallint;
    tmpStr1,tmpStr2: string;
  label label1,label2;

begin
 pos:=RollClassPoint[0];
 cnum:=pos;
 D:=1;
 while D<cnum do D:=D+D;
 label1:
 D:=(D-1) div 2;
 if D=0 then exit;
 H:=cnum-D;
 for i:=1 to H do
   begin
    J:=i;
    Label2:
    L:=J+D;
    A:=RollClassPoint[L];
    B:=RollClassPoint[J];
    tmpStr1:=uppercase(ClassCode[A]);
    tmpStr2:=uppercase(ClassCode[B]);
    if tmpStr1<tmpStr2 then
      begin
       RollClassPoint[J]:=A;
       RollClassPoint[L]:=B;
       dec(J,D);
      end;
    if (tmpStr1<tmpStr2) and (J>0) then goto Label2;
  end; {for}
  goto label1;
end;

procedure updateRollClassPoint;
var
 i,k: smallint;
begin
 k:=0;
 for i:=1 to classnum do
  if trim(ClassCode[i])>'' then
  begin
   inc(k); RollClassPoint[k]:=i;
  end;
 RollClassPoint[0]:=k;
// reduce trailing blank classes from count
 i:=classnum;
 while ((i>0) and (trim(ClassCode[i])='')) do
 begin
  dec(classnum);
  dec(i);
 end;
 sortClassCodes;
end;

procedure dumpOldClassFiles;
var
 i,y,c,cc,cL,k,zzi,zzc,zzj:     smallint;
 f:         file;
 tmpFileName,h:      string;
 tmpClass:           array[0..150] of string[4];
begin
 if usrPassLevel=utGen then exit;
 chdir(Directories.datadir); cL:=4;
 for y:=0 to years_minus_1 do
 begin
  try
   try
    for i:=0 to 150 do tmpClass[i]:=space(4);
    cc:=0;
    for k:=1 to XML_STUDENTS.numstud do
    begin
     if XML_STUDENTS.Stud[k].TcYear<>y then continue;
     c:=XML_STUDENTS.Stud[k].TcClass;
     if ((c>0) and (c<=150)) then
     begin
      if trim(ClassCode[c])>'' then
      begin
       tmpClass[c]:=copy(trim(ClassCode[c]),1,cL);
       if c>cc then cc:=c;
      end;
     end;
    end; {for k}
    if y=0 then  //dump out class codes without student data into class1.dat
    begin
     for zzc:=1 to classnum do
     begin
      zzj:=0;
      for zzi:=1 to XML_STUDENTS.numstud do
      begin
       if (XML_STUDENTS.Stud[zzi].TcClass=zzc) then
       begin zzj:=1; break; end;
      end;
      if (zzj=0) then //no students with this class
      begin
       if trim(ClassCode[zzc])>'' then
       begin
        tmpClass[zzc]:=copy(trim(ClassCode[zzc]),1,cL);
        if zzc>cc then cc:=zzc;
       end;
      end; {if zzj=0}
     end; {for zzc}
    end; {if y=0}
    tmpFileName:='CLASS'+trim(inttostr(y+1))+'.DAT';
    doAssignFile(f,tmpFileName);
    rewrite(f,1);
    blockwrite(f,cc,2);
    if cc>0 then
     for i:=1 to cc do
     begin
      h:=RpadString(tmpClass[i],cL);
      blockwrite(f,h[1],cL);
     end; {for y}
   finally
    closefile(f);
   end;
  except
  end;
 end; {for y}
end;

procedure updateClass;
var
 i:     smallint;
 f:         file;
 tmpFileName,h:      string;
begin
 if usrPassLevel=utGen then exit;
 chdir(Directories.datadir);
 try
  try
   tmpFileName:='CLASS.DAT';
   doAssignFile(f,tmpFileName);
   rewrite(f,1);
    blockwrite(f,LenClassCodes,2);
    blockwrite(f,classnum,2);
    if classnum>0 then
     for i:=1 to classnum do
     begin
      h:=RpadString(ClassCode[i],LenClassCodes);
      blockwrite(f,h[1],LenClassCodes);
     end; {for y}
   finally
    closefile(f);
   end;
  except
  end;
 FileAge('CLASS.DAT',NEW_DateChecks[4]);
 dumpOldClassFiles;
end;

procedure showStudentText3;  {OBERON}
var
 tmpStr,tmpDir,tmpfilename:  string;
 txtDirtest:       integer;
 f:       textfile;
 delim:   string;
 delim2:   string;

     procedure OutputStudentsAsText;
     var
      i,j,k:      integer;
      tmpint,tmpint2:  smallint;
      strA:   string;

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
      try
       try
        chdir(tmpdir);
        doAssignFile(f,tmpfilename+'.TXT');
        rewrite(f);

        for j:=1 to groupnum do
        begin
         if XML_DISPLAY.FAsubnum>0 then
          for k:=1 to XML_DISPLAY.FAsubnum do
          begin
           i:=StGroup[j];
           if trim(SubCode[XML_STUDENTS.Stud[i].Choices[k]])>'' then
           begin
            write(f,delim2,XML_STUDENTS.Stud[i].stname,delim2);
            write(f,delim,delim2,XML_STUDENTS.Stud[i].first,delim2);
            IF XML_DISPLAY.sTsex THEN write(f,delim,delim2,XML_STUDENTS.Stud[i].Sex,delim2);
            IF XML_DISPLAY.sTID THEN write(f,delim,delim2,XML_STUDENTS.Stud[i].ID,delim2);
            IF XML_DISPLAY.sTclass THEN write(f,delim,delim2,ClassCode[XML_STUDENTS.Stud[i].TcClass],delim2);
            IF XML_DISPLAY.sTHouse THEN write(f,delim,delim2,Housename[XML_STUDENTS.Stud[i].House],delim2);
            IF XML_DISPLAY.sTtutor THEN write(f,delim,delim2,XML_TEACHERS.TeCode[XML_STUDENTS.Stud[i].Tutor,0],delim2);
            IF XML_DISPLAY.sThome THEN write(f,delim,delim2,XML_TEACHERS.TeCode[XML_STUDENTS.Stud[i].home,1],delim2);
            write(f,delim,delim2,SubCode[XML_STUDENTS.Stud[i].Choices[k]],delim2);

  (* modifying customisation for Oberon by adding four new fields   *)

            if XML_DISPLAY.styear then write(f,delim,delim2,yearname[XML_STUDENTS.Stud[i].TcYear],delim2);  //year level
            IF boolean(XML_DISPLAY.sTtutor) THEN write(f,delim,delim2,tenameSpec(XML_STUDENTS.Stud[i].Tutor),delim2);  //tutor name
            // get subject teacher into tmpint
            findteacher(i,k,tmpint,tmpint2); {no longer care about result - using 2 var parm}

            if trim(XML_TEACHERS.TeCode[tmpInt,0])>'' then strA:=XML_TEACHERS.TeCode[tmpint,0]
             else strA:='';
            write(f,delim,delim2,strA,delim2); //subject teacher code
             //SURNAME,First Name (Surname in Upper Case, then a comma, then Title case for first name)
             //WANT Surname and only first letter of christian name

            write(f,delim,delim2,tenameSpec(tmpInt),delim2);  //subject teacher name in format specified

            writeln(f,'');
           end;
          end; {for k}
        end; {for i9}
       finally
        CloseFile(f);
        chdir(Directories.datadir);
       end;
      except
      end;
     end; {local proc}

begin
  delim:=''; delim2:='';
  mainform.SaveDialog.Title:='Text file out';
  mainform.SaveDialog.HelpContext:=0;
  mainform.SaveDialog.Filter:='Text file|*.txt';
  mainform.SaveDialog.InitialDir:=Directories.datadir;
  mainform.SaveDialog.defaultext:='txt';
  if mainform.SaveDialog.Execute then
  begin
   tmpStr:=ExtractFileName(mainform.SaveDialog.Filename);
   tmpfilename:=RemoveExtension(tmpStr);
   tmpStr:=mainform.SaveDialog.Filename;
   tmpdir:=GetDirName(tmpStr);

    txtDirtest:=verifyUserDirectory(tmpdir);
    if txtDirtest>2 then //doesn't exist or no read/write access
    begin
     showInvalidDirectoryMsg(txtDirtest,tmpdir);
     exit;
    end;

   delim:=chr(XML_DISPLAY.txtsep);
   delim2:=chr(XML_DISPLAY.txtlim);
   if XML_DISPLAY.txtlim=0 then delim2:='';
   OutputStudentsAsText;
  end;
end;

procedure splitName(StudentI:smallint; StudentName:string);
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

procedure LoadText2(fname: string);
var
 f:       textfile;
 filestr,pathstr:  string;
 msg:              string;
 stxfirst,stxname,astr,bstr,stxsex,stxID:     string;
 stxyear,stxclass,stxhouse,
 stxtutor,stxhome,j,oldnum:        integer;
 sn,tn:                   array[0..nmbrchoices] of integer;

   function getTextField(var astr: string): string;
   var
    i:      integer;
   begin
    try
     i:=pos(',',astr);
     if i=0 then
     begin
      result:=astr;
      readln(f,astr);
      exit;
     end;
     result:=copy(astr,1,i-1); {return field}
     astr:=copy(astr,i+1,length(astr));
    except
     result:='';
    end;
   end;

   function checkSkip: bool;
   var
    k: integer;
   begin
    result:=false;
    if oldnum=0 then exit;
    for k:=1 to oldnum do
    begin
     if ((XML_STUDENTS.Stud[k].stname=stxname) and (XML_STUDENTS.Stud[k].first=stxfirst)
      and (XML_STUDENTS.Stud[k].tcclass=stxclass) and (XML_STUDENTS.Stud[k].house=stxhouse)
       and (XML_STUDENTS.Stud[k].TCyear=stxyear)) then
      begin
       result:=true; break;
      end;
    end;
   end;

begin
 stxtutor:=0;  stxhome:=0;
 oldnum:=XML_STUDENTS.numstud;
 if trim(fname)='' then
 begin
  msg:='Text file not specified.';
  messagedlg(msg,mtError,[mbOK],0);
  exit;
 end;
 if not(fileexists(fname)) then
 begin
  msg:='Text file not found.';
  messagedlg(msg,mtError,[mbOK],0);
  exit;
 end;

  filestr:=ExtractFileName(fname);
  pathstr:=ExtractFilePath(fname);
  if trim(pathstr)='' then pathstr:=Directories.datadir;
  if pathstr[length(pathstr)]='\' then
   pathstr:=copy(pathstr,1,(length(pathstr)-1));

 if XML_DISPLAY.FAsubnum>nmbrChoices then
 begin
  msg:='From 0 to '+inttostr(nmbrChoices)+' subjects only!';
  messagedlg(msg,mtError,[mbOK],0);
  exit;
 end;
 screen.cursor:=crhourglass;

 chdir(pathstr);
 doAssignFile(f,filestr);
 filemode:=fmOpenRead+fmShareDenyNone;
 reset(f);
 astr:='';
 if XML_DISPLAY.FAreplace then XML_STUDENTS.numstud:=0;

 while ( (not(eof(f)) or (eof(f) and (astr>''))) and (XML_STUDENTS.numstud<nmbrStudents)) do
 begin
  try

   stxfirst:=''; stxname:=''; stxsex:=''; stxID:='';
   stxyear:=0; stxclass:=0; stxhouse:=0;
   stxtutor:=0; stxhome:=0;

   if astr='' then readln(f,astr);
   stxname:=getTextField(astr);
   if XML_DISPLAY.FAfirst then stxfirst:=getTextField(astr)
    else
    begin
     splitName(0,stxname);
     stxname:=XML_STUDENTS.Stud[0].Stname; stxfirst:=XML_STUDENTS.Stud[0].first;
    end;
    if XML_DISPLAY.FAyear then
    begin
     bstr:=getTextField(astr);
     stxyear:=findyear(bstr);
    end;
    if XML_DISPLAY.FAsex then stxsex:=getTextField(astr);
    if XML_DISPLAY.FAID then stxID:=getTextField(astr);
    stxclass:=0;
    if XML_DISPLAY.FAclass then
    begin
     bstr:=getTextField(astr);
     if stxyear>-1 then stxclass:=findclass2(bstr);
    end;
    stxhouse:=0;
    if XML_DISPLAY.FAhouse then
    begin
     bstr:=getTextField(astr);
     stxhouse:=findhouse2(bstr);
    end;
    stxtutor:=0;
    if XML_DISPLAY.FAtutor then
    begin
     bstr:=getTextField(astr);
     stxtutor:=findtutor2(copy(bstr,1,lencodes[1]));
    end;
    stxhome:=0;
    if XML_DISPLAY.FAhome then
    begin
     bstr:=getTextField(astr);
     stxhome:=findroom2(copy(bstr,1,lencodes[2]));
    end;
    for j:=1 to nmbrchoices do
    begin
     sn[j]:=0; tn[j]:=0;
    end;
    if XML_DISPLAY.FAsubnum>0 then
    begin
     for j:=1 to XML_DISPLAY.FAsubnum do
     begin
      bstr:=getTextField(astr);
      sn[j]:=checkcode(0,bstr);
     end;
    end;

  except

  end;

  if not(XML_DISPLAY.FAreplace) then if checkSkip then continue;
  if TooMany('students',XML_STUDENTS.numstud,nmbrStudents) then
   begin
    screen.cursor:=crDefault;
    break;
   end;
  {add stud}
  XML_STUDENTS.numstud := XML_STUDENTS.numstud + 1;
  setlength(XML_STUDENTS.Stud,(XML_STUDENTS.numStud+1)); {zero based so +1}

  XML_STUDENTS.Stud[XML_STUDENTS.numstud].stname:=stxname;
  XML_STUDENTS.Stud[XML_STUDENTS.numstud].first:=stxfirst;
  XML_STUDENTS.Stud[XML_STUDENTS.numstud].TCyear:=stxyear;

  StudYearFlag[stxyear]:=true;

  XML_STUDENTS.Stud[XML_STUDENTS.numstud].sex:=stxsex;
  XML_STUDENTS.Stud[XML_STUDENTS.numstud].id:=stxid;
  XML_STUDENTS.Stud[XML_STUDENTS.numstud].tcclass:=stxclass;
  XML_STUDENTS.Stud[XML_STUDENTS.numstud].house:=stxhouse;
  XML_STUDENTS.Stud[XML_STUDENTS.numstud].tutor:=stxtutor;
  XML_STUDENTS.Stud[XML_STUDENTS.numstud].home:=stxhome;
  XML_STUDENTS.Stud[XML_STUDENTS.numstud].tctag:=0;
  for j:=1 to nmbrchoices do
  begin
   XML_STUDENTS.Stud[XML_STUDENTS.numstud].choices[j]:=sn[j];
   if sn[j]>0 then
    if j>chmax then chmax:=j;
  end;

  SetStArrays;

  StudSort[XML_STUDENTS.numStud]:=XML_STUDENTS.numstud;

  resetstudentorder(XML_STUDENTS.numstud);
 end; {while}
 closefile(f);
 chdir(Directories.datadir);
 sortStudents;
 UpdateStudCalcs;
 SaveAllStudentYears;
 screen.cursor:=crDefault;
end;

procedure getStudentText2;
const
 delim=chr(9); {tab}
var
 tmpStr,tmpDir,tmpfilename:  string;
begin
  mainform.openDialog.Title:='Text file in';
  mainform.openDialog.HelpContext:=305;
  mainform.openDialog.Filter:='Text files (*.txt)|*.txt|All files|*.*';
  mainform.openDialog.InitialDir:=Directories.datadir;
  mainform.openDialog.defaultext:='txt';
  mainform.OpenDialog.options:=[ofFileMustExist,ofHideReadOnly,ofPathMustExist];
  if mainform.openDialog.Execute then
  begin
   tmpStr:=ExtractFileName(mainform.openDialog.Filename);
   tmpfilename:=RemoveExtension(tmpStr);
   tmpStr:=mainform.openDialog.Filename;
   tmpdir:=GetDirName(tmpStr);
   loadText2(tmpstr);
  end;
end;

procedure updatetoolbar;
begin
 if not(loadFinished) then exit;
 if fgGenToolbar and (Assigned(GenToolBarWin)) then GenToolBarWin.SetStatus;
 if fgTTtoolbar and (Assigned(TtableToolBarWin)) then TtableToolBarWin.SetStatus;
 if fgBlockToolbar and (Assigned(BlockToolBarWin)) then BlockToolBarWin.SetStatus;
 if fgWStoolbar and (Assigned(WorkSheetToolbar)) then WorkSheetToolbar.SetStatus;
end;

function GetClipStatus(winnum: smallint): boolean;
var
 clpDatType1,clpDatType2: smallint;
 ok:         boolean;
begin
 ok:=true;
 try
  clpDatType1:=0;  clpDatType2:=0;
  if Clipboard.HasFormat(CF_TEXT) then clpDatType1:=1;
  if Clipboard.HasFormat(CF_AMIG_Block_Data) then clpDatType2:=1;
  if Clipboard.HasFormat(CF_AMIG_Timetable_Data) then clpDatType2:=2;
  if Clipboard.HasFormat(CF_AMIG_Student_Data) then clpDatType2:=3;
  if clpDatType1=0 then ok:=false; {don't paste non text}
  case winnum of
   wnBlock: if (clpDatType2=3) then ok:=false; {don't paste studs}
   wnTtable: if clpDatType2=3 then ok:=false; {don't paste studs}
   wnStudentList:
     begin
      if (clpDatType2=1) then ok:=false; {don't paste blocks}
      if clpDatType2=2 then ok:=false; {don't paste ttable entries}
     end;
  end;
 except
 end;
 result:=ok;
end;

procedure rangeCheckCodeSels(var aa: tpTeData; code: smallint);
var
 i,j,k:     smallint;
 tmp:     tpTeData;
begin
 fillchar(tmp,sizeof(tmp),chr(0));

 if aa[0]>0 then
 begin
  for i:=1 to aa[0] do
  begin
   j:=aa[i];
   if ((j>0) and (j<=numcodes[code])) then {range}
   begin
    if (copy(XML_TEACHERS.tecode[j,code-1],1,2)<>'00') then   {deletion}
    begin
     inc(tmp[0]);
     tmp[tmp[0]]:=aa[i];
    end;
   end;
  end; {for i}

  if tmp[0]>0 then for i:=1 to tmp[0] do aa[i]:=tmp[i];
  aa[0]:=tmp[0];
  fillchar(tmp,sizeof(tmp),chr(0));
  j:=0;
  if aa[0]>0 then {remove duplicates}
   for i:=1 to aa[0] do
    begin
     k:=aa[i];
     if tmp[k]=0 then begin inc(j); aa[j]:=k; tmp[k]:=1; end;
    end;
  aa[0]:=j;
 end;
end;

procedure rangeCheckSubSels(var aa: tpSubData);
var
 i,j:     smallint;
 tmp:     tpSubData;
begin
 fillchar(tmp,sizeof(tmp),chr(0));

 if aa[0]>0 then
 begin
  for i:=1 to aa[0] do
  begin
   j:=aa[i];
   if ((j>0) and (j<=numcodes[0])) then {range}
   begin
    if (copy(SubCode[j],1,2)<>'00') then   {deletion}
    begin
     inc(tmp[0]);
     tmp[tmp[0]]:=j;
    end;
   end;
  end; {for i}

  if tmp[0]>0 then
  begin
   for i:=1 to tmp[0] do
    aa[i]:=tmp[i];
  end;
   aa[0]:=tmp[0];
 end;
end;

procedure rangeCheckSubyrSels(var aa: tpCmatrixSelection);
var
 i,j:     smallint;
 tmp:     tpSubData;
begin
 fillchar(tmp,sizeof(tmp),chr(0));

 if aa[0]>0 then
 begin
  for i:=1 to aa[0] do
  begin
   j:=aa[i];
   if ((j>0) and (j<=numcodes[0])) then {range}
   begin
    if (copy(SubCode[j],1,2)<>'00') then   {deletion}
    begin
     if GsubXref[j]>0 then {ensure in yearsubs}
     begin
      inc(tmp[0]);
      tmp[tmp[0]]:=j;
     end
    end;
   end;
  end; {for i}

  if tmp[0]>0 then
  begin
   for i:=1 to tmp[0] do
    aa[i]:=tmp[i];
  end;
   aa[0]:=tmp[0];
 end;
end;

procedure rangeCheckStudSels(var aa: tpstudentdata);
var
 i,tmp:     smallint;
begin
 if aa[0]>XML_STUDENTS.numstud then aa[0]:=XML_STUDENTS.numstud;
 tmp:=0;
 if aa[0]>0 then
 begin
  for i:=1 to aa[0] do
   if ((aa[i]>0) and (aa[i]<=XML_STUDENTS.numstud)) then
   begin
    inc(tmp);
    aa[tmp]:=aa[i];
   end;
  aa[0]:=tmp;
  if tmp<XML_STUDENTS.numstud then
   for i:=tmp+1 to XML_STUDENTS.numstud do
    aa[i]:=0;
 end;
end;

procedure saveWinDisplay;
var
  msg:     string;

begin
 if (usrPassLevel=utGen) then exit;
 if verifyUserDirectory(usrPassDir)>0 then exit;
 try
  chdir(usrPassDir);
  saveDisplayFile(OLD_DISPLAY_FILE);
 except
  screen.cursor:=crDefault;
  msg:='Your preferences could not be saved';
  msg:=msg+endline+'to '+OLD_DISPLAY_FILE+endline;
  msg:=msg+'in '+usrPassDir;
  messagedlg(msg,mtError,[mbOK],250);
 end;
end;

procedure saveDisplayFile(displayFile:string);
var
  len: byte;
  i,j,cI,cJ,dummysmall:          smallint;
  fname,tname: string;
  tmpStr:     string;
  DisplayHeader: String[4];
  tmpFs:      tFontStyles;
begin
 try
  try
   fname:=displayfile;
   tmpStr:=RemoveExtension(fname);
   tname:=tmpStr+'.TMP';
   ourSafetyMemStreamStr:='';
   ourSafetyMemStream:=TStringStream.Create(ourSafetyMemStreamStr);
   {start}
   with ourSafetyMemStream do
    begin
   {header}
   DisplayHeader:='TC52';  dummysmall:=0;
   Write(Pchar(@DisplayHeader[1])^,4);
   {time chart's font}
   tmpStr:=XML_DISPLAY.TcFont.name;
   len:=Length(tmpStr);
   Write(len,1);
   Write(Pchar(@tmpStr[1])^,len);
   tmpFs:=XML_DISPLAY.tcFont.style;
   Write(Pchar(@tmpFs)^,sizeof(TFontstyles));
   i:=XML_DISPLAY.Tcfont.size;
   Write(i,2);
   {end of font}

  {window pos}
   Write(XML_DISPLAY.winOrderNum,2);
   if XML_DISPLAY.winOrderNum>0 then
    for i:=1 to XML_DISPLAY.winOrderNum do Write(XML_DISPLAY.winOrder[i],2);
   i:=nmbrWindows;
   Write(i,2);
   for i:=0 to nmbrWindows do Write(Pchar(@XML_DISPLAY.winPos[i])^,sizeof(XML_DISPLAY.winPos[i]));
   for i:=0 to 2 do Write(XML_DISPLAY.sorttype[i],2);

   {stud list win}
   Write(XML_DISPLAY.StudListType,2);
   Write(XML_DISPLAY.listnumbertype,2);

   {stud list dialog}
   Write(XML_DISPLAY.sTfind,2);
   for i:=1 to 4 do
    for j:=1 to 2 do
     Write(XML_DISPLAY.listRanges[i,j],2);
   cI:=ListStudentSelection[0];
   Write(cI,2);
   if cI>0 then for i:=1 to cI do Write(ListStudentSelection[i],2);

   Write(XML_DISPLAY.commonDataAll,2);
   Write(XML_DISPLAY.editBlockCheck,2);
   {sub list dialog}
   Write(XML_DISPLAY.SubListType,2);
   Write(XML_DISPLAY.SubListGroupType,2);
   cI:=nmbrOfgroupsubjects;
   Write(cI,2);
   for i:=-2 to nmbrOfgroupsubjects do
    Write(XML_DISPLAY.sublistRanges[i],2);
   Write(XML_DISPLAY.sublistfacnum,2);
   Write(XML_DISPLAY.sublistday,2);
   Write(XML_DISPLAY.sublisttime1,2);
   Write(XML_DISPLAY.sublisttime2,2);
   Write(XML_DISPLAY.sublistfree,2);
   {stud ttable}
   cI:=XML_DISPLAY.StudentTtSelection[0];
   Write(cI,2);
   if cI>0 then for i:=1 to cI do
    Write(XML_DISPLAY.StudentTtSelection[i],2);

   Write(XML_DISPLAY.StudTtListType,2);
   Write(XML_DISPLAY.stuttEnrolment,2);
   for i:=1 to 8 do
    Write(XML_DISPLAY.stuttlistvals[i],2);
   {teach ttable}
   cI:=XML_DISPLAY.TeTtSelection[0];
   Write(cI,2);
   if cI>0 then for i:=1 to cI do
    Write(XML_DISPLAY.TeTtSelection[i],2);
   Write(XML_DISPLAY.tettseltype,2);
   Write(XML_DISPLAY.tettLoads,2);
   for i:=1 to 5 do
    Write(XML_DISPLAY.tettlistVals[i],2);
   {room ttable}
   cI:=XML_DISPLAY.RoTtSelection[0];
   Write(cI,2);
   if cI>0 then for i:=1 to cI do
    Write(XML_DISPLAY.RoTtSelection[i],2);
   Write(XML_DISPLAY.rottseltype,2);
   Write(XML_DISPLAY.OnlineUpdateCheck,2);
   for i:=1 to 5 do
    Write(XML_DISPLAY.rottlistVals[i],2);
   {sub ttable}
   Write(XML_DISPLAY.subttlistSelection,2);
   for i:=1 to 4 do
    Write(XML_DISPLAY.subttlistVals[i],2);
   Write(subttgroupcnt,2);
   cI:=subttgroupcnt;
   if cI>0 then
    for i:=1 to cI do
     Write(XML_DISPLAY.SubTtGroup[i],2);
   {tt prnt seldlg}
   cI:=XML_DISPLAY.ttPrntSelSubg[0];
   Write(cI,2);
   if cI>0 then
    for i:=1 to cI do
     Write(XML_DISPLAY.ttPrntSelSubg[i],2);
   cI:=XML_DISPLAY.ttPrntSelTeachg[0];
   Write(cI,2);
   if cI>0 then
    for i:=1 to cI do
     Write(XML_DISPLAY.ttPrntSelTeachg[i],2);
   cI:=XML_DISPLAY.ttprntselroomg[0];
   Write(cI,2);
   if cI>0 then
    for i:=1 to cI do
     Write(XML_DISPLAY.ttprntselroomg[i],2);
   Write(XML_DISPLAY.ttprntseltype,2);
   Write(XML_DISPLAY.ttPrntFac,2);
   Write(XML_DISPLAY.ttprntselday,2);
   Write(XML_DISPLAY.ttprntselyear,2);
   Write(XML_DISPLAY.ttPrntType,2);
  {group of teachers}
   cI:=XML_DISPLAY.GrpOfTeSelSubg[0];
   Write(cI,2);
   if cI>0 then for i:=1 to cI do
    Write(XML_DISPLAY.GrpOfTeSelSubg[i],2);
   Write(dummysmall,2);     { was grpofteshow}
   Write(XML_DISPLAY.grpofteyear,2);
   Write(XML_DISPLAY.grpofteclass,2);
   Write(XML_DISPLAY.grpoftelevel,2);
   Write(XML_DISPLAY.grpoftefac,2);
   Write(XML_DISPLAY.grpofteday,2);
   Write(XML_DISPLAY.grpoftetimes,2);

  {clash matrix sel dlg}
   cI:=XML_DISPLAY.ClashMatrixSelection[0];
   Write(cI,2);
   if cI>0 then
    for i:=1 to cI do
     Write(XML_DISPLAY.ClashMatrixSelection[i],2);
   Write(dummysmall,2);

   {teachers free dlg}
   cI:=XML_DISPLAY.TeFreeSelect[0];
   Write(cI,2);
   if cI>0 then
    for i:=1 to cI do
     Write(XML_DISPLAY.TeFreeSelect[i],2);
   Write(XML_DISPLAY.teachersfreeday,2);
   Write(XML_DISPLAY.TeFreePeriod,2);
   Write(XML_DISPLAY.teachersfreefac,2);
   Write(XML_DISPLAY.teachersfreeshow1,2);
   Write(XML_DISPLAY.teachersfreeshow2,2);
   Write(XML_DISPLAY.teFreeYear,2);
   {rooms free dlg}
   cI:=XML_DISPLAY.RoomsFreeSelection[0];
   Write(cI,2);
   if cI>0 then
    for i:=1 to cI do
     Write(XML_DISPLAY.RoomsFreeSelection[i],2);
   Write(XML_DISPLAY.roomsfreeday,2);
   Write(XML_DISPLAY.roomsfreePeriod,2);
   Write(XML_DISPLAY.roomsfreefac,2);
   Write(XML_DISPLAY.roomsfreeshow1,2);
   Write(XML_DISPLAY.roomsfreeshow2,2);
  {teachers times dlg}
   cI:=XML_DISPLAY.TeTimesSelect[0];
   Write(cI,2);
   if cI>0 then
    for i:=1 to cI do      {zero index is count}
     Write(XML_DISPLAY.TeTimesSelect[i],2);
   Write(XML_DISPLAY.teachertimesyear,2);    {0-days ; if =days means all days}
   Write(XML_DISPLAY.teachertimesfac,2);
   Write(XML_DISPLAY.teachertimesshow1,2); {1-3}
   Write(XML_DISPLAY.teachertimesshow2,2); {1-3}
  {teacher list dlg}
   cI:=XML_DISPLAY.TeListSelection[0];
   Write( cI, 2);
   if cI > 0 then
    for i := 1 to cI do
     Write( XML_DISPLAY.TeListSelection[i], 2);
   Write( XML_DISPLAY.teListFac, 2);
   Write( XML_DISPLAY.teListShow,2); {1-2}
  {subjects times dlg}
   Write(XML_DISPLAY.subjecttimesyear,2);
   Write(XML_DISPLAY.subjecttimesfac,2);    {0-facnum}
   Write(XML_DISPLAY.subjecttimesshow2,2); {1-3}
  {student input}
   cI:=XML_DISPLAY.StudentInputSelection[0];
   Write(cI,2);
   if cI>0 then
    for i:=1 to cI do
     Write(XML_DISPLAY.StudentInputSelection[i],2);

   Write(XML_DISPLAY.StInputPref1,2);
   Write(XML_DISPLAY.StInputPref2,2);

   Write(XML_DISPLAY.StInputClass,2);
   Write(XML_DISPLAY.StInputHouse,2);
   Write(XML_DISPLAY.StInputTutor,2);
   Write(XML_DISPLAY.StInputRoom,2);
   Write(XML_DISPLAY.studentinputshow1,2);
   Write(XML_DISPLAY.studentinputshow2,2);
   {promote students}
   Write(XML_DISPLAY.clearstudentchoicesflag,2);     {bool}

   {teaacher clashes}
    Write(XML_DISPLAY.tcCurPeriodOnly,2);
   {room clashes}
    Write(XML_DISPLAY.rcCurPeriodOnly,2);
   {block defaults}
   Write(XML_DISPLAY.blocknum,2);   {was tagGroupAll}
   Write(XML_DISPLAY.blocklevel,2);  {was tagOverwrite}

   {margins etc}
   Write(XML_DISPLAY.prntLeftMargin,4); {single so 4 bytes}
   Write(XML_DISPLAY.prntTopMargin,4);
   Write(XML_DISPLAY.datestamp,2);

   {preferences}
   {general}
   Write(XML_DISPLAY.prefNotebookPageIndex,2);
   Write(XML_DISPLAY.sTtag,2);
   Write(XML_DISPLAY.colorPrinterFlag,sizeof(XML_DISPLAY.colorPrinterFlag));
   {student section}
   Write(XML_DISPLAY.sTsex,2);
   Write(XML_DISPLAY.sTClass,2);
   Write(XML_DISPLAY.sTHouse,2);
   Write(XML_DISPLAY.sTID,2);
   Write(XML_DISPLAY.sTTutor,2);
   Write(XML_DISPLAY.sTHome,2);
   Write(XML_DISPLAY.double_space,2);
   Write(XML_DISPLAY.blockshow,2);
   Write(XML_DISPLAY.sTselect,2);
   Write(XML_DISPLAY.Sexselect,2);
   Write(XML_DISPLAY.PreviewLastZoom,2);
   Write(XML_DISPLAY.listEnrolment,2);
   Write(XML_DISPLAY.listShowClashes,2);
   {timetable section}
   cI:=periods; Write(cI,2);
   for i:=0 to periods-1 do
      Write(XML_DISPLAY.tsOn[0,i],sizeof(boolean));
  cI:=nmbryears;
  Write(cI,2);
   for i:=0 to nmbryears do
    Write(XML_DISPLAY.Pyear[i],sizeof(boolean));
  cI:=nmbrdays;
  Write(cI,2);
   for i:=1 to nmbrdays do
    Write(XML_DISPLAY.Dprint[i],sizeof(boolean));
   Write(XML_DISPLAY.Tfreeshow,2);
   Write(XML_DISPLAY.Rfreeshow,2);
   Write(XML_DISPLAY.Pweek,2);
   Write(XML_DISPLAY.Tyr,2);
   Write(XML_DISPLAY.ttWeekDaysFlg,2);
   Write(XML_DISPLAY.ttClockShowFlg,2);
   {fill rooms}
   Write(XML_DISPLAY.fsDoRoomCap,2);
  {Alter Worksheet dialogue}
   Write(XML_DISPLAY.wsAlterBox,2);
  {block dialogues}
   Write(XML_DISPLAY.MaxClassSize,2);
   Write(XML_DISPLAY.BLsolution,2);
   Write(XML_DISPLAY.BLtries,2);
   Write(XML_DISPLAY.ExcludeClassSize,2);
   Write(XML_DISPLAY.SplitDiff,2);
   Write(XML_DISPLAY.autobalance,2);
   Write(XML_DISPLAY.balanceflag,2);
   {timetable entry dialog}
   Write(XML_DISPLAY.trackflag,2);
   {Student Paste}
   Write(XML_DISPLAY.StudPasteID,2);    {was abSingle}
   Write(XML_DISPLAY.StudPasteSub,2);    {was abDouble}
   Write(XML_DISPLAY.StudPasteFields,2);    {was abTriple}
   Write(XML_DISPLAY.StudPasteAddSub,2);    {was abperiod}
  {Build dialogue}
   Write(XML_DISPLAY.abOverwrite,2);
   Write(XML_DISPLAY.AlterBox,2);
   Write(XML_DISPLAY.SearchBox,2);
   Write(XML_DISPLAY.chScope,2);
   Write(XML_DISPLAY.chType,2);
   Write(XML_DISPLAY.EdfacSubType,2);
   Write(XML_DISPLAY.Formfeed,2);
   Write(XML_DISPLAY.GroupIndexDisplay, 2); //Write(colorPrinterFlag,2);  Dummy

   Write(XML_DISPLAY.globalHints,2);
   Write(XML_DISPLAY.OKbackup,2);
   Write(XML_DISPLAY.OKquitcheck,2);

   Write(XML_DISPLAY.txtsep,2);
   Write(XML_DISPLAY.txtlim,2);

   Write(XML_DISPLAY.styear,2);
   Write(XML_DISPLAY.showHintsDlg,2);

  {toolbars}
   Write(XML_DISPLAY.fgReshowWStoolbar,2);
   Write(XML_DISPLAY.fgReshowTTtoolbar,2);
   Write(XML_DISPLAY.fgReshowBlockToolbar,2);
   Write(XML_DISPLAY.fgTTtoolbarDock,2);
   Write(XML_DISPLAY.fgBlockToolbarDock,2);
   Write(XML_DISPLAY.fgGenToolbarDock,2);

   i:=0; {was length(studentinputmsg) - this string no longer used}
   Write(i,2);

   Write(XML_DISPLAY.EntrySelectionLink,2);
   Write(XML_DISPLAY.sublistYear,2);

   Write(XML_DISPLAY.FAfirst,2);
   Write(XML_DISPLAY.FAyear,2);
   Write(XML_DISPLAY.FAsex,2);
   Write(XML_DISPLAY.FAID,2);
   Write(XML_DISPLAY.FAclass,2);
   Write(XML_DISPLAY.FAhouse,2);
   Write(XML_DISPLAY.FAtutor,2);
   Write(XML_DISPLAY.FAhome,2);
   Write(XML_DISPLAY.FAsubnum,2);
   Write(XML_DISPLAY.FAreplace,2);

   Write(XML_DISPLAY.GenericTtableFlag,2);
   Write(XML_DISPLAY.MatchAllYears,2);

   Write(XML_DISPLAY.customFileLoadFlag,2);
     if XML_DISPLAY.customFileLoadFlag then
      begin
       tmpstr:=custom+'.cus';
       cI:=length(tmpstr);
       Write(cI,2);
       Write(tmpstr[1],cI);
      end;

    Write(XML_DISPLAY.OberonOutputType,2);
    {subject list}
    Write(XML_DISPLAY.fgsubBySubListZeroSkip,2);
    {worksheet toolbar docking}
    Write(XML_DISPLAY.fgWStoolbarDock,2);
    Write(XML_DISPLAY.UseGroupFindStud,2);
    Write(XML_DISPLAY.StInputDlgPageIndex,2);

    Write(XML_DISPLAY.subttWide,2);  {used as bool}

    Write(XML_DISPLAY.TrackEnrolFlag,2);
    Write(XML_DISPLAY.StHeadShow,2);

    Write(XML_DISPLAY.EnrolBarcodeFlg,2);
    cI:=nmbrWindows;
    write(cI, 2);
    for i := 1 to nmbrWindows do write(winView[i],2);
    cI:=days; write(cI,2);
    cJ:=periods; write(cJ,2);
    if cI>1 then
     for i:= 1 to cI do
       for j:=0 to cJ-1 do
         write(XML_DISPLAY.tsOn[i,j],sizeof(boolean));

    //if (CustomerIDnum=cnMountainCreekSHS) then // only for MOUNTAIN CREEK STATE HIGH SCHOOL
    begin
     try
      Write(XML_DISPLAY.sTID2,2);
     except
     end;
    end;
    Write(XML_DISPLAY.FExportFileIdx, 2);
    Write(XML_DISPLAY.FIsLandscape, 2);
    write(XML_DISPLAY.stEmail,2);
   end; {with}

   SafelyStreamToFile(tname,fname);
  finally
   ourSafetyMemStream.free;
   Application.ProcessMessages;
  end;
 except
 end;
end;

function FNycSHARED(d,p,te,b: smallint):string;
var
 block,y,m,sy,sm: array[0..nmbrdays] of smallint;
 su:              array[0..nmbrdays,0..2] of smallint;
 found, found2:              bool;
 share,sbyte,i:              smallint;
 yi,li,mm:              smallint;
 aFnt,bFnt,cFnt:               tpintpoint;
 astr,cstr,bstr,dstr:          string;
begin     {b=1 te  b=2 ro}
 if b=1 then mm:=2 else mm:=1;   bFnt:=nil;
 fillchar(block,sizeof(block),chr(0));  fillchar(y,sizeof(y),chr(0));
 fillchar(m,sizeof(m),chr(0));          fillchar(su,sizeof(su),chr(0));
 fillchar(sm,sizeof(sm),chr(0));

 for i:=0 to nmbrdays do sy[i]:=-1;

 found:=false; share:=0; found2:=false;
 for yi:=0 to years_minus_1 do
 begin
  for li:=1 to level[yi] do
  begin
   aFnt:=FNT(d,p,yi,li,0); bFnt:=aFnt; inc(bFnt,b);
   if (found and (share>0) and (bFnt^=te)) then
   begin
    sy[d]:=yi; sm[d]:=li; found2:=true; break;
   end;
   if ((share=0) and (bFnt^=te)) then
   begin
    found:=true; su[d,0]:=aFnt^;
    cFnt:=aFnt; inc(cFnt,mm); su[d,mm]:=cFnt^;
    cFnt:=afnt; inc(cFnt,3); sbyte:=cFnt^;
    block[d]:=FNgetBlockNumber(d,p,yi,li);
    y[d]:=yi;
    m[d]:=li; share:=(sbyte and 2);
    if share=0 then break;
   end;
  end; {for li}
  if ((share=0) and (bFnt^=te)) or found2 then break;
 end; {for yi}

 astr:=trim(ClassCode[ClassShown[m[d],y[d]]]); cstr:='';
 if (sy[d]>-1) then cstr:=trim(ClassCode[ClassShown[sm[d],sy[d]]]);
 bstr:=yearshort+trim(copy(yearname[y[d]],1,8)); dstr:='';
 if (sy[d]>-1) then dstr:=trim(copy(yearname[sy[d]],1,5));
 if XML_DISPLAY.tyr=1 then
 begin
  astr:=bstr;  cstr:=dstr;
 end;
 if XML_DISPLAY.tyr=0 then
  if (boolean(block[d]) or (astr='')) then
  begin
   astr:=bstr;  cstr:=dstr;
  end;
 if ((XML_DISPLAY.tyr = 4) or (m[d]=0)) then
 begin
  astr:=''; cstr:='';
 end;
 astr:=trim(astr); cstr:=trim(cstr);

 if (sy[d]>-1) then astr:=astr+'/'+cstr;
 FNycSHARED:=astr;
end;

procedure findstudentWinSelect;
begin
 if wnFlag[wnFindStud] then findstudent.show
  else findstudent:=tfindstudent.create(application);
end;

function GetTeacherFaculty(const pTeacheNo, pFactOrder: Integer): Integer;
var
  lFacNo: Integer;
begin
  lFacNo := XML_TEACHERS.TFaculty[pTeacheNo, pFactOrder];
  if lFacNo > 0 then
    Result := lFacNo
  else
   Result := 0;
end;

end.



