unit Teachtt;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Menus,ClassDefs, TimeChartGlobals, Contnrs, XML.UTILS,
  GlobalToTcAndTcextra, XML.DISPLAY, XML.TEACHERS;

type
  TTeTimetable = class;

  TTeTtable = class(TListTtWin)
    PopupMenu1: TPopupMenu;
    Selection2: TMenuItem;
    N2: TMenuItem;
    PrintSetup1: TMenuItem;
    Print1: TMenuItem;
    Copy1: TMenuItem;
    popTeachTTExportAsCSV: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Selection2Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
    function PopulateFieldData(aFieldName: string): Variant;
    function GetGridFieldValue(pRecIndex: Integer; const pFieldName: string): Variant;
    procedure FormShow(Sender: TObject);
    procedure ExportAsCSV(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  protected
    procedure SetTabs; override;
    procedure GetLists; override;
    procedure GetListContents(i: integer); override;
    procedure ShowTtItems(i,d,p,x1: integer); override;
    procedure ListHead(i,d:integer);  override;
    procedure ShowName(i:integer);  override;
    procedure WeeklyFooter(i:integer); override;
  private
    teLoadslines:         smallint;
    FTeTimetable: TTeTimetable;
    FAllowCSV: boolean;
    procedure printteachtimes(yeary,mylev: smallint);
    procedure PrintOffset(b:smallint; tab:integer);
    procedure AppendTeacherLoads(i: integer);
    procedure CalcTeLoadLines;
    procedure TeLoad_SetTabs;
  end;

  TTeTimetableItem =  class(TObject)
  private
    FTeacherNo: Integer;
    FRoomNo: Integer;
    FDayNo: Integer;
    FSubjectNo: Integer;
    FPeriodNo: Integer;
  public
    property TeacherNo: Integer read FTeacherNo write FTeacherNo;
    property DayNo: Integer read FDayNo write FDayNo;
    property PeriodNo: Integer read FPeriodNo write FPeriodNo;
    property SubjectNo: Integer read FSubjectNo write FSubjectNo;
    property RoomNo: Integer read FRoomNo write FRoomNo;
  end;

  TTeTimetable =  class(TObjectList)
  end;

var
  TeTtable: TTeTtable;

procedure teacherTtableprint;
procedure teacherTtableOut;

implementation

uses
  tcommon, main, tettdlg, printers, tcommon2, uAMGConst;

{$R *.DFM}

type TPrintTeTtWin=class(TPrintListTtWin)
  public
   procedure head; override;
   procedure SetTabs; override;
   procedure GetLists; override;
   procedure GetListContents(i: integer); override;
   procedure ListHead(i,d:integer); override;
   procedure ShowName(i:integer);  override;
   procedure WeeklyFooter(i:integer); override;
   procedure ShowTtItems(i,d,p,x1: integer);  override;
  private
   procedure printteachtimes(yeary,mylev: smallint);
   procedure PrintOffset(b:smallint; tab:integer);
   procedure AppendTeacherLoads(i: integer);
   procedure TeLoad_SetTabs;
 end;

type TOutTeTtWin=class(TOutListTtWin)
  public
   procedure head; override;
   procedure SetTabs; override;
   procedure GetLists; override;
   procedure GetListContents(i: integer); override;
   procedure ListHead(i,d:integer); override;
   procedure ShowName(i:integer);  override;
   procedure WeeklyFooter(i:integer); override;
   procedure ShowTtItems(i,d,p: integer);  override;
  private
   procedure printteachtimes(yeary,mylev: smallint);
   procedure AppendTeacherLoads(i: integer);
 end;

var
 PrintTeTtWin:    TPrintTeTtWin;
 OutTeTtWin:     TOutTeTtWin;
 tscount:                       integer;
 ldcount:                       double;
 maxLines:             smallint;
 subcount : double;

Procedure GeneralListContents(i,size,myset:integer;var Contents: array of integer);
var
 j,count,countfrom,t: integer;
begin
 count:=0;
 if Size=0 then exit;
 if XML_DISPLAY.tettseltype=1 then countfrom:=codeCount[1]
  else countfrom:=XML_DISPLAY.tettselection[0];
 for j:=1 to countfrom do
  begin
   if XML_DISPLAY.tettseltype=2 then t:=XML_DISPLAY.tettselection[j] else t:=codepoint[j,1];
  if TeachInAnyFac(t,myset) then begin inc(count); Contents[count]:=t; end;
  end;
end;

function TTeTtable.GetGridFieldValue(pRecIndex: Integer; const pFieldName: string): Variant;
var
  ro,sc,teyear,lev,offset: Integer;
  itemTt1, itemTt2, itemTt3: string;
  lNoOfStud: Integer;
  i: Integer;
  j: Integer;
  k: Integer;
begin
 (* ToDo Complete when required
 for i := 1 to NumOfLists do
  for j := 1 to ListSize[i] do
   begin
    k := ListContents[j];
  // the Call ShowTtItems(i, d, p, x1)

    //if GetTeachTtItem(sc, ro, teYear, Lev, i, d, p) then
    begin
      if (sc <> subNA) then
      begin
        inc(tscount);
        //ldcount := ldCount + tsAllot[d,p];
      end;
      itemTt1 := Trim(SubCode[sc]);
      itemTt2 := Trim(tecode[ro, 1]);
      //itemTt3 := FNycSHARED(d, p, i,1);
      printwl(ItemTt1 + ' '); {subject}
      printw(ItemTt2); {room}
      if Tyr = 3 then
      begin
        //lNoOfStud := GetNoOfStudentsInClass(TeYear, sc, i, ro, D, P);
        itemTt3 := IntToStr(lNoOfStud);
      end;
      printw(itemTt3)
    end;

  if pFieldName = 'fldDay1Subject' then
    Result := 'TAB'
  else if pFieldName = 'fldDay2Subject' then
    Result := 'TCD'
  else if pFieldName = 'fldDay3Subject' then
    Result := 'TEF'
  else if pFieldName = 'fldDay4Subject' then
    Result := 'TKL'
  else if pFieldName = 'fldDay5Subject' then
    Result := 'TGH'
  else if pFieldName = 'fldDay6Subject' then
    Result := 'TIJ'
  else if pFieldName = 'fldDay7Subject' then
    Result := 'TMN'
  else if pFieldName = 'fldDay8Subject' then
    Result := 'TOP'
  else if pFieldName = 'fldDay9Subject' then
    Result := 'TQR'
  else if pFieldName = 'fldDay10Subject' then
    Result := 'TST';

  if pFieldName = 'fldDay1Room' then
    Result := 'R12'
  else if pFieldName = 'fldDay2Room' then
    Result := 'R23'
  else if pFieldName = 'fldDay3Room' then
    Result := 'R34'
  else if pFieldName = 'fldDay4Room' then
    Result := 'R45'
  else if pFieldName = 'fldDay5Room' then
    Result := 'R56'
  else if pFieldName = 'fldDay6Room' then
    Result := 'R67'
  else if pFieldName = 'fldDay7Room' then
    Result := 'R78'
  else if pFieldName = 'fldDay8Room' then
    Result := 'R89'
  else if pFieldName = 'fldDay9Room' then
    Result := 'R90'
  else if pFieldName = 'fldDay10Room' then
    Result := 'R14';
   end;*)
end;

procedure TTeTtable.GetListContents(i:integer);
begin
 SetLength(ListContents,ListSize[i]+1);
 GeneralListContents(i,ListSize[i],ListSet[i],ListContents);
end;

procedure TTeTtable.GetLists;
var
 i,t,kk,count: integer;
begin
 NumOfLists:=1; SetArraySizes;
 if XML_DISPLAY.tettseltype=1 then count:=codeCount[1]
  else count:=XML_DISPLAY.tettselection[0];
 kk:=0;
 if count>0 then
  for i:=1 to count do
   begin
    if XML_DISPLAY.tettseltype=2 then t:=XML_DISPLAY.tettselection[i] else t:=codepoint[i,1];
    if TeachInAnyFac(t,XML_DISPLAY.tettlistvals[3]) then inc(kk);
   end;
 ListSize[1]:=kk; ListSet[1]:=XML_DISPLAY.tettlistvals[3]
end;

procedure TTeTtable.ShowName(i:integer);
begin
 tscount:=0; ldcount:=0;
 if listtype=1 then
  begin
   x:=blankwidth div 3;
   printw(XML_TEACHERS.tecode[i,0]);
   inc(y,txtHeight);
   printw(XML_TEACHERS.tename[i,0]);
   dec(y,txtHeight);
  end
  else printw(XML_TEACHERS.tecode[i,0]+' '+XML_TEACHERS.tename[i,0]);
end;

procedure TTeTtable.ListHead(i,d:integer);
var
 s:string;
 j: integer;
begin
 if listtype=1 then s:=dayname[d]+' for ' else s:='For ';
 j:=ListSet[i];
  case XML_DISPLAY.tettseltype of
   1: s:=s+'All Teachers';
   2: s:=s+'Teacher Selection';
  end; {case}
  if j>0 then s:=s+' in faculty '+facname[j];
  printw(s);   newline;
end;

procedure TTeTtable.ShowTtItems(i,d,p,x1: integer);
var
  ro,sc,teyear,lev,offset: integer;
  itemTt1,itemTt2,itemTt3,aStr: string;
  lNoOfStud: Integer;
  lTeTimetableItem: TTeTimetableItem;
begin
  if FAllowCSV then
  begin
    lTeTimetableItem := TTeTimetableItem.Create;
    lTeTimetableItem.FTeacherNo := i;
    lTeTimetableItem.FDayNo := D;
    lTeTimetableItem.FPeriodNo := p;
  end;
  if GetTeachTtItem(sc,ro,teYear,Lev,i,d,p) then
  begin
    if (sc<>subNA) then
    begin
       if SubWillcount[sc]<>'N' then     //-----------Mantis-1295
      begin
      inc(tscount); ldcount:=ldCount+tsAllot[d,p];
      end;
        //-----------Mantis-1295

   { if SubWillcount[i]='N' then
    begin
        str(TeAllot[i]:6:2,aStr);
        subcount   := subcount+StrToFloat(aStr) ;
        aStr :='0.00';
    end ; }
     //-----------Mantis-1295

    end;
    itemTt1:=trim(SubCode[sc]);
    itemTt2:=trim(XML_TEACHERS.tecode[ro,1]);
    itemTt3:=FNycSHARED(d,p,i,1);
    offset:=(dx-3-canvas.textwidth(ItemTt1)) div 2;
    x:=x1+offset; fcolor(cpSub); printwl(ItemTt1); {subject}
    inc(y,txtHeight);
    if XML_DISPLAY.Tyr = 3 then
    begin
      lNoOfStud := GetNoOfStudentsInClass(TeYear, sc, i, ro, D, P);
      itemTt3 := IntToStr(lNoOfStud);
    end;
    if itemTt2 <> '' then
    begin
      offset:=(dx-3-canvas.textwidth(itemTt2 + ' ' + ItemTt3)) div 2;
      x := x1 + Offset; fcolor(cpRoom); printw(itemTt2); //Room
      Offset := (canvas.textwidth(' ' + itemTt2));
      x := x + offset;
    end
    else
      x:= X1 + (dx-3-canvas.textwidth(itemTt3)) div 2;
    fcolor(cpClass);
    printw(' ' + ItemTt3); // Class
    dec(y,txtHeight);
    if FAllowCSV then
    begin
      lTeTimetableItem.FSubjectNo := Sc;
      lTeTimetableItem.FRoomNo := Ro;
    end;
  end;
  if FAllowCSV then
  begin
    FTeTimetable.Add(lTeTimetableItem);
  end;
end;

procedure TTeTtable.TeLoad_SetTabs;
begin
 calculateloads;
 SetLength(Tabs,11);
 Tabs[1]:=Hmargin+blankwidth div 3;
 MaxTab(2,fwcode[0],'Subject');
 MaxTab(3,fwyearname,yeartitle);
 MaxTab(4,fwclass,'Class');
 MaxTab(5,0,'Males');
 MaxTab(6,0,'Females');
 MaxTab(7,0,'Stud.');
 MaxTab(8,0,'Times');
 MaxTab(9,0,'Alloted');
 headwidth:=(longint(hmargin)*2)+longint(Tabs[9])
       +canvas.textwidth('/99 ');
 CalcTeLoadLines;
 yFooter:=yFooter+maxLines*txtHeight;
 FooterWidth:=Hmargin+Tabs[9];
end;

procedure TTeTtable.CalcTeLoadLines;
var
 TeCount,TeSub: tpTeData;
 i,j,k,v:             integer;
 yeary,l:           integer;
 count1,dutycount:           integer;
 num:                   integer;
 astr:                  string;

  procedure tcount1;
  var
   d,p,sub,te:         integer;
   aFnt:   tpintpoint;
  begin
   for d:=0 to days-1 do
    for p:=1 to tlimit[d] do
     begin
      aFnt:=FNT(d,p-1,yeary,l,2);
      te:=aFnt^;
      if te>0 then
       begin
        dec(aFnt);
        sub:=aFnt^;
        if (sub<>subNA) then
        begin
         if TeSub[te]=0 then TeSub[te]:=sub;
         if (TeSub[te]>0) and (TeSub[te]<>sub) then TeSub[te]:=-1;
        end;
       end; {if (te>0)}
     end; {for p}
  end;

begin
 maxLines:=0;

 for i:=0 to nmbrteachers do TeCount[i]:=0;

 for yeary:=0 to years_minus_1 do
  begin
   if ClassInYear[yeary] then
    for l:=1 to level[yeary] do
     begin
      for j:=0 to nmbrteachers do TeSub[j]:=0;
      tcount1;
      for i:=1 to numcodes[1] do begin
       if TeSub[i]>0 then inc(TeCount[i]);
       if TeSub[i]<0 then
        begin
         ClearTeDoSub;
         tcount(yeary,i,l);
         for j:=1 to numcodes[0] do if TeDoSub[j]>0 then inc(TeCount[i]);
        end;
      end; {i}
     end {for l}
   else {not classInYear}
    begin
     for j:=0 to nmbrteachers do TeSub[j]:=0;
     for l:=1 to level[yeary] do tcount1;
     for i:=1 to numcodes[1] do begin
       if TeSub[i]>0 then inc(TeCount[i]);
       if TeSub[i]<0 then
        begin
         ClearTeDoSub;
         for l:=1 to level[yeary] do tcount(yeary,i,l);
         for j:=1 to numcodes[0] do if TeDoSub[j]>0 then inc(TeCount[i]);
        end;
      end; {i}
    end;
  end; {yeary}

 if XML_DISPLAY.tettseltype=2 then num:=XML_DISPLAY.tettselection[0]
  else num:=codeCount[1];
 for k:=1 to num do
  begin
   if XML_DISPLAY.tettseltype<>2 then i:=codepoint[k,1] else i:=XML_DISPLAY.tettselection[k];
   if not(TeachInAnyFac(i,XML_DISPLAY.tettlistvals[3])) then continue;
   aStr:=copy(XML_TEACHERS.tecode[i,0],1,2);
   if (i=0) or (aStr='00') or (TeCount[i]=0) then continue;
   dutycount:=0;
   for v:=0 to 2 do
    if (trim(XML_TEACHERS.DutyCode[i,v])<>'') then inc(dutycount);
   count1:=2+dutycount+TeCount[i];
   if count1>maxLines then maxLines:=count1;
  end; {k}
end;

procedure TTeTtable.ExportAsCSV(Sender: TObject);
var
  i: Integer;
  lTeTimetableItem: TTeTimetableItem;
  lList: TStringList;
  k: Integer;
  DI: Integer;
  D, j, p, Ip: Integer;
  Ro, Sc, TeYear, Lev: Integer;
  lFileName: string;

  procedure AddDayTimetableToList(const pDay: Integer);
  var
    i: Integer;
    lDayUse: Integer;
    lTeacher: string;
    lDay: string;
    lPeriod: string;
    lPeriodStart: string;
    lPeriodEnd: string;
    lSubject: string;
    lRoom: string;
    lStr: string;
    lSubLine: string;
    lRoLine: string;
    lCurrTe: Integer;
  begin
    lDayUse := pDay;
    lList.Add(DayName[pDay]);
    lStr := 'Week ##' + ',' + 'Term #' + ',,' + School + ',,' + DateToStr(Date);
    lList.Add(lStr);
    lStr := AMG_PERIODS + ',';
    for i := 1 to Tlimit[lDayUse] do
      lStr := lStr + TimeSlotName[lDayUse, i-1] + ',';
    lList.Add(lStr);

    lStr := AMG_TIMES + ',';
    for i := 1 to Tlimit[lDayUse] do
      lStr := lStr + TimeToStr(TsStart[lDayUse, i-1]) + ' - ' + TimeToStr(TsEnd[lDayUse, i-1]) + ',';
    lList.Add(lStr);
    lSubLine := '';
    lRoLine := '';
    lCurrTe := 0;
    for i := 0 to FTeTimetable.Count - 1 do
    begin
      lTeTimetableItem := TTeTimetableItem(FTeTimetable.Items[i]);
      lTeacher := Trim(XML_TEACHERS.TeName[lTeTimetableItem.FTeacherNo, 0]);
      if lTeacher = '' then
        lTeacher := Trim(XML_TEACHERS.TeCode[lTeTimetableItem.FTeacherNo, 0]);

      lDay := DayName[lTeTimetableItem.FDayNo];
      lPeriod := TimeSlotName[lTeTimetableItem.FDayNo, lTeTimetableItem.FPeriodNo];
      lPeriodStart := TimeToStr(TsStart[lTeTimetableItem.FDayNo, lTeTimetableItem.FPeriodNo]);
      lPeriodEnd := TimeToStr(TsEnd[lTeTimetableItem.FDayNo, lTeTimetableItem.FPeriodNo]);
      lSubject := Trim(SubCode[lTeTimetableItem.FSubjectNo]);
      lRoom := XML_TEACHERS.TeCode[lTeTimetableItem.FRoomNo, 1];
      if lTeTimetableItem.FTeacherNo <> lCurrTe then
      begin
        lSubLine := lTeacher + ',' + lSubject + ',';
        lRoLine := ',' + lRoom + ',';
        lList.Add(lSubLine);
        lList.Add(lRoLine);
        lCurrTe := lTeTimetableItem.FTeacherNo;
      end
      else
      begin
        lSubLine := lSubLine + lSubject + ',';
        lRoLine := lRoLine + lRoom + ',';
        lList.Strings[lList.Count -2] := lSubLine;
        lList.Strings[lList.Count -1] := lRoLine;
      end;
    end;
    lList.Add(Chr(10) + Chr(13));  //Just a line space at the end
  end;
begin
  if not(FAllowCSV) then exit;
  
  lList := TStringList.Create;
  try
    for DI := Day1 to Day2 do
    begin
      FTeTimetable.Clear;
      for i := 1 to NumOfLists do
        if ListSize[i] > 0 then
        begin
          GetListContents(i);
          for j := 1 to ListSize[i] do
          begin
            k := ListContents[j];
            for p := 1 to tsShowMax do
            begin
              Ip := tsShow[DI,p];
              if (Ip = 0) and (p > 1) then Break;
              lTeTimetableItem := TTeTimetableItem.Create;
              lTeTimetableItem.FTeacherNo := k;
              lTeTimetableItem.FDayNo := DI;
              lTeTimetableItem.FPeriodNo := Ip;
              if GetTeachTtItem(sc, ro, teYear, Lev, k, DI, Ip) then
              begin
                lTeTimetableItem.FSubjectNo := Sc;
                lTeTimetableItem.FRoomNo := Ro;
              end;
              FTeTimetable.Add(lTeTimetableItem);
            end;
          end;  // for
        end; //if
      AddDayTimetableToList(DI);
    end;
  finally
    lFileName := Directories.DataDir + '\' + AMG_TEACHER_TTABLE_CSV_FILE;
    lList.SaveToFile(lFileName);
    Application.ProcessMessages;
    if FileExists(lFileName) then
    begin
      MessageDlg(Format(AMG_DATA_EXPORTED_AS_MSG, [Directories.DataDir, AMG_TEACHER_TTABLE_CSV_FILE]), mtInformation, [mbOK], 0);
    end;
    FreeAndNil(lList);
  end;
end;

procedure TTeTtable.SetTabs;
var
 i,A1:       integer;
begin
 listtype:=winView[wnTeacherTt]+1;  CodeColor:=cpTeach;
 day1:=XML_DISPLAY.tettlistvals[4];
 day2:=XML_DISPLAY.tettlistvals[5];
 yFooter:=2*txtHeight; FooterWidth:=0;
 dx := 8 + fwCode[0];// + BlankWidth;   //+ fwClass
// WIdth now matches Student TT with the following bits commented
 dx := 8 + fwCode[0] + (BlankWidth div 2);// + BlankWidth;   //+ fwClass
 case XML_DISPLAY.Tyr of
   0: begin
        if fwyearname > fwclass then
        begin
          A1 := 8 + fwyearname + fwCode[2] + (BlankWidth * 3);
        end else begin
          A1 := 8 + fwClass + fwCode[2] + (BlankWidth * 3);
        end;
     end;
   1: A1 := 8 + fwyearname + fwCode[2] + (BlankWidth * 3);
   2: A1 := 8 + fwClass + fwCode[2] + (BlankWidth div 2);
   3: A1 := 8 + fwCode[2] + (BlankWidth div 2);
   4: A1 := 0;
 end;
 {*
 if tyr < 4 then
   begin
     if Tyr <= 1 then   //Year or class
     begin
       //A1 := 10 + fwyearname + fwCode[2] ;
       A1 := 8 + fwyearname + fwCode[2];// + BlankWidth;
       if A1 > dx then dx := A1;
     end
     else
     begin
       A1:= 8 + fwClass + fwCode[2];
       if A1>dx then dx:=A1;
     end;
   end;
 *}
 if A1>dx then dx:=A1;

 if listtype=2 then
  begin         {weekly}
   A1:=8+fwDayname;
   if A1>dx then dx:=A1;
   if XML_DISPLAY.tettLoads then
      TeLoad_SetTabs;
  end
 else    {daily}
  begin
   A1:=8+fwperiodname;
   if A1>dx then dx:=A1;
   i:=fwcodename[1];
   if fwcode[1]>i then i:=fwcode[1];
   tab1:=i+blankwidth;
  end;
 GetLists;
 CalcArrayTops;
end;

procedure TTeTtable.AppendTeacherLoads(i: integer);
var
 v,l,f: smallint;
 ldt:    double;
 yeary,shared: integer;
 tmpStr:                string;
begin
 fcolor(cpNormal);
 x:=Tabs[1]; printw('Loads'); newline;
 x:=Tabs[1]; printw('Subject');
 x:=Tabs[2]; printw(yeartitle);
 x:=Tabs[3]; printw('Class');
 x:=Tabs[4]; printw('Males');
 x:=Tabs[5]; printw('Females');
 x:=Tabs[6]; printw('Stud.');
 x:=Tabs[7]; printw('Times');
 x:=Tabs[8]; printwl('  Alloted'); newline;
 teLoadslines:=2; TeDoSub[0]:=0;
  subcount:=0;//mantis-1295
 for yeary:=0 to years_minus_1 do
  begin
   if classInYear[yeary] then
    for l:=1 to level[yeary] do
     begin
      ClearTeDoSub;
      tcount(yeary,i,l);
      printteachtimes(yeary,l);
     end {for l}
   else {not classInYear}
    begin
     ClearTeDoSub;
     for l:=1 to level[yeary] do tcount(yeary,i,l);
     printteachtimes(yeary,1);
    end;
  end; {for yeary}

  ldt:=0; {double}
  fcolor(cpNormal);
  for v:=0 to 2 do
   if trim(XML_TEACHERS.DutyCode[i,v])<>'' then
    begin
     x:=Tabs[1];
     printwl('Duty'+chr(49+v)+': '+XML_TEACHERS.DutyCode[i,v]);
     str(XML_TEACHERS.DutyLoad[i,v]:6:2,tmpStr);
     x:=Tabs[9]-self.canvas.textwidth(tmpstr);
     printwl(tmpstr);
     ldt:=ldt+XML_TEACHERS.DutyLoad[i,v];
     inc(teLoadslines);
     newline;
    end;
  shared:=TeDoSub[0]-Teaching[i];

   begin
    if shared>1 then tmpstr:='classes' else tmpstr:='class';
    if shared>0 then
     begin
      fcolor(cpBlockClash);
      printw(inttostr(shared)+' shared '+tmpstr);
      fcolor(cpNormal);
     end;
    x:=Tabs[5]-blankwidth*3; printwl('Totals ');
    PrintOffset(Teaching[i],Tabs[7]);
 //   str((TeLoad[i]+ldt):6:2,tmpstr);            //mantis-1295
      str((TeLoad[i]-subcount+ldt):6:2,tmpstr);  //mantis-1295

    x:=Tabs[9]-canvas.textwidth(tmpstr);
    printwl(tmpstr);
    printw('/'+inttostr(XML_TEACHERS.Load[i]));
    newline;
   end;
   if (teLoadslines<maxLines) then for f:=1 to (maxLines-teLoadslines) do newline;
  newline;
end;

procedure TTeTtable.PrintOffset(b:smallint; tab:integer);
var
 aStr: string;
 inset: integer;
begin
 Inset:=canvas.textwidth('999');
 astr:=inttostr(b);
 x:=tab+Inset-canvas.textwidth(aStr); printw(astr);
end;

procedure TTeTtable.printteachtimes(yeary,mylev: smallint);
var
 j,a:   integer;
 aStr:          string;
 mycount,YearUse: integer;
begin
 for j:=1 to numcodes[0] do
  begin
   a:=TeDoSub[j];
   if a>0 then
   begin
    fcolor(cpSub); x:=Tabs[1]; printwl(SubCode[j]);
    fcolor(cpClass); x:=Tabs[2]; printwl(yearname[yeary]);
    x:=Tabs[3];
    if ClassInYear[yeary] then printwl(ClassCode[ClassShown[myLev,yeary]]);
    fcolor(cpNormal);
    YearUse:=yeary;if XML_DISPLAY.MatchAllYears then YearUse:=-1;
    if SuMale[j,YearUse]>0 then PrintOffset(SuMale[j,YearUse],Tabs[4]);
    if SuFemale[j,YearUse]>0 then PrintOffset(SuFemale[j,YearUse],Tabs[5]);
    mycount:=SuMale[j,YearUse]+SuFemale[j,YearUse];
    if mycount>0 then PrintOffset(mycount,Tabs[6]);
    PrintOffset(a,Tabs[7]);
    str(TeAllot[j]:6:2,aStr);
     if SubWillcount[j]='N' then   //Mantis-1295
    begin
        subcount   := subcount+StrToFloat(aStr) ;
        aStr :='0.00';
    end ;

    x:=Tabs[9]-self.canvas.textwidth(aStr);
    printwl(aStr);
    fcolor(cpBlockClash);
    if TeShare[j]=-1 then printwl(' shared');
    fcolor(cpNormal);
    inc(teLoadslines);
    newline;
   end; {if a>0}
  end; {for j}
end;

procedure TTeTtable.WeeklyFooter(i:integer);
var
 a,j: integer;
 astr,bstr: string;
begin
 if listtype=1 then {daily}
  begin
   printw('Teachers: '+inttostr(ListSize[i]));
  end
 else    //weekly
  begin
   if XML_DISPLAY.tettLoads then
    AppendTeacherLoads(i)
   else
    begin
     x:=0;  fcolor(cpNormal);
     for a:=0 to 2 do
     begin
      if trim(XML_TEACHERS.dutycode[i,a])>'' then
       ldcount:=ldcount+XML_TEACHERS.dutyload[i,a];
     end; {for a}


     str(ldcount:4:2,aStr);
     printw('Total time slots: '+inttostr(tscount)+'   Load: '+aStr+'/'+inttostr(XML_TEACHERS.Load[i]));
     newline;
     for a:=0 to 2 do
     begin
      if XML_TEACHERS.dutyload[i,a]=0 then aStr:='0' else str(XML_TEACHERS.dutyload[i,a]:4:2,aStr);
      bstr:=Trim(XML_TEACHERS.dutycode[i,a]); if bstr='' then bstr:='-';
      if bstr<>'-' then  {do not want duty codes if none assigned}
       printwl('Duty Code'+inttostr(a+1)+': '+bstr+'  Load: '+aStr+'    ');
     end; {for a}
     newline;
    end;
  end;
end;

procedure TTeTtable.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action:=caFree;
end;

procedure TTeTtable.FormCreate(Sender: TObject);
begin
  setWindowDefaults(self,wnTeacherTt);
  FTeTimetable := TTeTimetable.Create;
  FAllowCSV := true;
end;

procedure TTeTtable.Selection2Click(Sender: TObject);
begin
 TeacherTTdlg:=TTeacherTTdlg.create(self);   {allocate dlg}
 TeacherTTdlg.showmodal;
 TeacherTTdlg.free;
end;

{--------------            print procs follow             - ------------------}

procedure TPrintTeTtWin.head;
begin
 UnderlineOn;
 printwl('Teacher Timetable ');
 printw(PageCount);
 UnderlineOff;
 x:=0; y:=y+PrnttxtHeight;
end;

procedure TPrintTeTtWin.AppendTeacherLoads(i: integer);
var
 v,l: smallint;
 ldt:    double;
 yeary,shared: integer;
 tmpStr:                string;
begin
 fcolor(cpNormal);
 x:=PrntTabs[1]; printw('Loads'); newline;
 x:=PrntTabs[1]; printw('Subject');
 x:=PrntTabs[2]; printw(yeartitle);
 x:=PrntTabs[3]; printw('Class');
 x:=PrntTabs[4]; printw('Males');
 x:=PrntTabs[5]; printw('Females');
 x:=PrntTabs[6]; printw('Stud.');
 x:=PrntTabs[7]; printw('Times');
 x:=PrntTabs[8]; printwl('  Alloted'); newline;
 TeDoSub[0]:=0;
 for yeary:=0 to years_minus_1 do
  begin
   if classInYear[yeary] then
    for l:=1 to level[yeary] do
     begin
      ClearTeDoSub;
      tcount(yeary,i,l);
      printteachtimes(yeary,l);
     end {for l}
   else {not classInYear}
    begin
     ClearTeDoSub;
     for l:=1 to level[yeary] do tcount(yeary,i,l);
     printteachtimes(yeary,1);
    end;
  end; {for yeary}

  ldt:=0; {double}
  fcolor(cpNormal);
  for v:=0 to 2 do
   if trim(XML_TEACHERS.DutyCode[i,v])<>'' then
    begin
     x:=PrntTabs[1];
     printwl('Duty'+chr(49+v)+': '+XML_TEACHERS.DutyCode[i,v]);
     str(XML_TEACHERS.DutyLoad[i,v]:6:2,tmpStr);
     x:=PrntTabs[9]-PrintCanvas.textwidth(tmpstr);
     printwl(tmpstr);
     ldt:=ldt+XML_TEACHERS.DutyLoad[i,v];
     newline;
    end;
  shared:=TeDoSub[0]-Teaching[i];

   begin
    if shared>1 then tmpstr:='classes' else tmpstr:='class';
    if shared>0 then
     begin
      fcolor(cpBlockClash);
      printw(inttostr(shared)+' shared '+tmpstr);
      fcolor(cpNormal);
     end;
    x:=PrntTabs[5]-PrntBlankwidth*3; printwl('Totals ');
    PrintOffset(Teaching[i],PrntTabs[7]);
    str((TeLoad[i]+ldt):6:2,tmpstr);
    x:=PrntTabs[9]-PrintCanvas.textwidth(tmpstr);
    printwl(tmpstr);
    printw('/'+inttostr(XML_TEACHERS.Load[i]));
    newline;
   end;
  newline;
end;

procedure TPrintTeTtWin.PrintOffset(b:smallint; tab:integer);
var
 aStr: string;
 Inset:  integer;
begin
 Inset:=PrintCanvas.textwidth('999');
 astr:=inttostr(b);
 x:=tab+Inset-PrintCanvas.textwidth(aStr); printw(astr);
end;

procedure TPrintTeTtWin.printteachtimes(yeary,mylev: smallint);
var
 j,a:   integer;
 aStr:          string;
 mycount,YearUse: integer;
begin
 for j:=1 to numcodes[0] do
  begin
   a:=TeDoSub[j];
   if a>0 then
   begin
    fcolor(cpSub); x:=PrntTabs[1]; printwl(SubCode[j]);
    fcolor(cpClass); x:=PrntTabs[2]; printwl(yearname[yeary]);
    x:=PrntTabs[3];
    if ClassInYear[yeary] then printwl(ClassCode[ClassShown[myLev,yeary]]);
    fcolor(cpNormal);
    YearUse:=yeary;if XML_DISPLAY.MatchAllYears then YearUse:=-1;
    if SuMale[j,YearUse]>0 then PrintOffset(SuMale[j,YearUse],PrntTabs[4]);
    if SuFemale[j,YearUse]>0 then PrintOffset(SuFemale[j,YearUse],PrntTabs[5]);
    mycount:=SuMale[j,YearUse]+SuFemale[j,YearUse];
    if mycount>0 then PrintOffset(mycount,PrntTabs[6]);
    PrintOffset(a,PrntTabs[7]);
    str(TeAllot[j]:6:2,aStr);
    x:=PrntTabs[9]-PrintCanvas.textwidth(aStr);
    printwl(aStr);
    fcolor(cpBlockClash);
    if TeShare[j]=-1 then printwl(' shared');
    fcolor(cpNormal);
    newline;
   end; {if a>0}
  end; {for j}
end;

procedure TPrintTeTtWin.WeeklyFooter(i:integer);
var
 a: integer;
 astr,bstr: string;
begin
 if listtype=1 then {daily}
   printw('Teachers: '+inttostr(ListSize[i]))
 else
  begin
   if XML_DISPLAY.tettLoads then
    AppendTeacherLoads(i)
   else
    begin
     for a:=0 to 2 do if Trim(XML_TEACHERS.dutycode[i,a])>'' then
         ldcount:=ldcount+XML_TEACHERS.dutyload[i,a];
     str(ldcount:4:2,aStr);
     printw('Total time slots: '+inttostr(tscount)+'   Load: '+aStr+'/'+inttostr(XML_TEACHERS.Load[i]));
     newline;
     for a:=0 to 2 do
       begin
        if XML_TEACHERS.dutyload[i,a]=0 then aStr:='0' else str(XML_TEACHERS.dutyload[i,a]:4:2,aStr);
        bstr:=Trim(XML_TEACHERS.dutycode[i,a]);
        if bstr<>'' then     {do not want duty codes if none assigned}
         printwl('Duty Code'+inttostr(a+1)+': '+bstr+'  Load: '+aStr+'    ');
       end; {for a}
       newline;
    end;
  end;
end;

procedure TPrintTeTtWin.TeLoad_SetTabs;
begin
 SetLength(PrntTabs,11);
 PrntTabs[1]:=PrntBlankwidth div 3;
 MaxTab(2,fwprntcode[0],'Subject');
 MaxTab(3,fwprntyearname,yeartitle);
 MaxTab(4,fwprntclass,'Class');
 MaxTab(5,0,'Males');
 MaxTab(6,0,'Females');
 MaxTab(7,0,'Stud.');
 MaxTab(8,0,'Times');
 MaxTab(9,0,'Alloted');
 yFooter:=yFooter+maxLines*PrntTxtHeight;
end;

procedure TPrintTeTtWin.SetTabs;
var
 A1,i: integer;
begin
 listtype:=winView[wnTeacherTt]+1;  CodeColor:=cpTeach;
 day1:=XML_DISPLAY.tettlistvals[4]; day2:=XML_DISPLAY.tettlistvals[5];
 yFooter:=2*PrntTxtHeight;
 //dx:=3+fwPrntCode[0]+fwPrntCode[2]+Prntblankwidth;
 dx := 8 + fwPrntCode[0] + Prntblankwidth;
 if XML_DISPLAY.tyr < 4 then
 begin
   if XML_DISPLAY.Tyr <= 1 then   //Year or class
   begin
     A1 := 10 + fwPrntyearname + fwPrntCode[2] + Prntblankwidth;
     if A1>dx then dx:=A1;
   end
   else
   begin
     A1 := 8 + fwPrntClass + fwPrntCode[2];
     if A1>dx then dx:=A1;
   end;
 end;
 if listtype=2 then
  begin         {weekly}
   A1:=8+fwPrntDayname;
   if A1>dx then dx:=A1;
   tab1:=fwPrntPeriodname+Prntblankwidth;
   if XML_DISPLAY.ttClockShowFlg then
    if tab1<fwPrntClockStartEnd then tab1:=fwPrntClockStartEnd;
   if XML_DISPLAY.tettLoads then
    TeLoad_SetTabs;
  end
 else    {daily}
  begin
   A1:=8+fwPrntperiodname;
   if A1>dx then dx:=A1;
   i:=fwPrntcodename[1];
   if fwPrntcode[1]>i then i:=fwPrntcode[1];
   tab1:=i+Prntblankwidth;
  end;
 GetLists;
end;

procedure TPrintTeTtWin.GetLists;
var
 i: integer;
begin
 NumOfLists:=TeTtable.NumOfLists;
 SetArraySizes;
 if NumOfLists>0 then
  for i:=1 to NumOfLists do
   begin
    ListSize[i]:=TeTtable.ListSize[i];
    ListSet[i]:=TeTtable.ListSet[i];
   end;
end;

procedure TPrintTeTtWin.GetListContents(i: integer);
begin
 SetLength(ListContents,ListSize[i]+1);
 GeneralListContents(i,ListSize[i],ListSet[i],ListContents);
end;

procedure TPrintTeTtWin.ShowName(i:integer);
begin
 tscount:=0; ldcount:=0;
 if listtype=1 then
  begin
   x:=PrntBlankwidth div 3;
   printw(XML_TEACHERS.tecode[i,0]);
   inc(y,PrntTxtHeight);
   printw(XML_TEACHERS.tename[i,0]);
   dec(y,PrntTxtHeight);
  end
  else printw(XML_TEACHERS.tecode[i,0]+' '+XML_TEACHERS.tename[i,0]);
end;

procedure TPrintTeTtWin.ListHead(i,d:integer);
var
 s:string;
 j: integer;
begin
 if listtype=1 then s:=dayname[d]+' for ' else s:='For ';
 j:=ListSet[i];
  case XML_DISPLAY.tettseltype of
   1: s:=s+'All Teachers';
   2: s:=s+'Teacher Selection';
  end; {case}
  if j>0 then s:=s+' in faculty '+facname[j];
  printw(s);   newline;
end;

procedure TPrintTeTtWin.ShowTtItems(i,d,p,x1: integer);
var
  ro,sc,teyear,lev,offset: integer;
  itemTt1,itemTt2,itemTt3: string;
  lNoOfStud: Integer;
begin
  if GetTeachTtItem(sc,ro,teYear,Lev,i,d,p) then
  begin
    if (sc<>subNA) then
    begin
      inc(tscount); ldcount:=ldCount+tsAllot[d,p];
    end;
    itemTt1:=trim(SubCode[sc]);
    itemTt2:=trim(XML_TEACHERS.tecode[ro,1]);
    itemTt3:=FNycSHARED(d,p,i,1);
    offset := (dx - 3 - PrintCanvas.textwidth(ItemTt1)) div 2;
    x:=x1+offset; fcolor(cpSub); printwl(ItemTt1); {subject}
    inc(y,PrntTxtHeight);
    if XML_DISPLAY.Tyr = 3 then
    begin
      lNoOfStud := GetNoOfStudentsInClass(TeYear, sc, i, ro, D, P);
      itemTt3 := IntToStr(lNoOfStud);
    end;
    if itemTt2 <> '' then
    begin
      offset:=(dx-3-PrintCanvas.Textwidth(itemTt2 + ' ' + ItemTt3)) div 2;
      x := x1 + Offset; fcolor(cpRoom); printw(itemTt2); //Room
      Offset := (PrintCanvas.Textwidth(' ' + itemTt2));
      x := x + offset;
    end
    else
      x:= X1 + (dx-3-PrintCanvas.Textwidth(itemTt3)) div 2;
    fcolor(cpClass);
    printw(' ' + ItemTt3); // Class
    dec(y,PrntTxtHeight);
  end;
end;

procedure teacherTtableprint;
begin
 PrintTeTtWin:=TPrintTeTtWin.Create;
 with PrintTeTtWin do
  try
   PaintOnPrinter;
  finally
   PrintTeTtWin.free;
  end;
end;

{--------------      Text Output procs follow             - ------------------}

procedure TOutTeTtWin.head;
begin
 printLine(['Teacher Timetable']);
end;

procedure TOutTeTtWin.printteachtimes(yeary,mylev: smallint);
var
 j,a:   integer;
 aStr:          string;
 mycount,YearUse: integer;
begin
  for j:=1 to numcodes[0] do
  begin
   a:=TeDoSub[j];
   if a>0 then
   begin
    printw(SubCode[j]);
    printc(yearname[yeary]); astr:='';
    if ClassInYear[yeary] then astr:=ClassCode[ClassShown[myLev,yeary]];
    printc(astr); astr:='';
    YearUse:=yeary;if XML_DISPLAY.MatchAllYears then YearUse:=-1;
    if SuMale[j,YearUse]>0 then astr:=inttostr(SuMale[j,YearUse]);
    printc(astr);  astr:='';
    if SuFemale[j,YearUse]>0 then astr:=inttostr(SuFemale[j,YearUse]);
    printc(astr); astr:='';
    mycount:=SuMale[j,YearUse]+SuFemale[j,YearUse];
    if mycount>0 then  astr:=inttostr(mycount);
    printc(astr);
    printc(inttostr(a));
    str(TeAllot[j]:6:2,aStr);
    printc(aStr);
    if TeShare[j]=-1 then printc(' shared');
    newline;
   end; {if a>0}
  end; {for j}
end;

procedure TOutTeTtWin.AppendTeacherLoads(i: integer);
var
 v,l: smallint;
 ldt:    double;
 yeary,shared: integer;
 tmpStr:                string;
begin
   printLine(['Loads']);
   printLine(['Subject',yeartitle,'Class','Males','Females','Stud.','Times','Alloted']);
   TeDoSub[0]:=0;
   for yeary:=0 to years_minus_1 do
    begin
     if classInYear[yeary] then
      for l:=1 to level[yeary] do
       begin
        ClearTeDoSub;
        tcount(yeary,i,l);
        printteachtimes(yeary,l);
       end {for l}
     else {not classInYear}
      begin
       ClearTeDoSub;
       for l:=1 to level[yeary] do tcount(yeary,i,l);
       printteachtimes(yeary,1);
      end;
    end; {for yeary}


   ldt:=0; {double}
   for v:=0 to 2 do
    if trim(XML_TEACHERS.DutyCode[i,v])<>'' then
    begin
     str(XML_TEACHERS.DutyLoad[i,v]:6:2,tmpStr);
     PrintLine(['Duty'+chr(49+v)+': '+XML_TEACHERS.DutyCode[i,v],'','','','','','',tmpstr]);
     ldt:=ldt+XML_TEACHERS.DutyLoad[i,v];
    end;
    shared:=TeDoSub[0]-Teaching[i];

     begin
      if shared>1 then tmpstr:='classes' else tmpstr:='class';
      if shared>0 then
       begin
        printc(inttostr(shared)+' shared '+tmpstr);
       end;
      str((TeLoad[i]+ldt):6:2,tmpstr);
      printLine(['Totals','','','','','',inttostr(Teaching[i]),tmpstr,'/'+inttostr(XML_TEACHERS.Load[i])]);
     end;
    newline;
end;

procedure TOutTeTtWin.WeeklyFooter(i:integer);
var
 a: integer;
 astr,bstr: string;
begin
 if listtype=1 then {daily}
   printw('Teachers: '+inttostr(ListSize[i]))
 else
  begin
   if XML_DISPLAY.tettLoads then
      AppendTeacherLoads(i)
   else
    begin
   for a:=0 to 2 do if Trim(XML_TEACHERS.dutycode[i,a])>'' then
       ldcount:=ldcount+XML_TEACHERS.dutyload[i,a];
   str(ldcount:4:2,aStr);
   printw('Total time slots: '+inttostr(tscount)+'   Load: '+aStr+'/'+inttostr(XML_TEACHERS.Load[i]));
   newline;
   for a:=0 to 2 do
     begin
      if XML_TEACHERS.dutyload[i,a]=0 then aStr:='0' else str(XML_TEACHERS.dutyload[i,a]:4:2,aStr);
      bstr:=Trim(XML_TEACHERS.dutycode[i,a]);
      if bstr<>'' then     {do not want duty codes if none assigned}
       printc('Duty Code'+inttostr(a+1)+': '+bstr+'  Load: '+aStr+'    ');
     end; {for a}
     newline;
    end;
  end;
end;

procedure TOutTeTtWin.SetTabs;
begin
 listtype:=winView[wnTeacherTt]+1;
 day1:=XML_DISPLAY.tettlistvals[4];
 day2:=XML_DISPLAY.tettlistvals[5];
 GetLists;
 TabCount:=1;
end;

procedure TOutTeTtWin.GetLists;
var
 i: integer;
begin
 NumOfLists:=TeTtable.NumOfLists;
 SetArraySizes;
 if NumOfLists>0 then
  for i:=1 to NumOfLists do
   begin
    ListSize[i]:=TeTtable.ListSize[i];
    ListSet[i]:=TeTtable.ListSet[i];
   end;
end;

procedure TOutTeTtWin.GetListContents(i: integer);
begin
 SetLength(ListContents,ListSize[i]+1);
 GeneralListContents(i,ListSize[i],ListSet[i],ListContents);
end;

procedure TOutTeTtWin.ShowName(i:integer);
begin
 tscount:=0; ldcount:=0;
 if listtype=1 then
  begin
   printw(XML_TEACHERS.tecode[i,0]);
   printc(XML_TEACHERS.tename[i,0]);
  end
  else printw(XML_TEACHERS.tecode[i,0]+' '+XML_TEACHERS.tename[i,0]);
end;

procedure TOutTeTtWin.ListHead(i,d:integer);
var
 s:string;
 j: integer;
begin
 if listtype=1 then s:=dayname[d]+' for ' else s:='For ';
 j:=ListSet[i];
  case XML_DISPLAY.tettseltype of
   1: s:=s+'All Teachers';
   2: s:=s+'Teacher Selection';
  end; {case}
  if j>0 then s:=s+' in faculty '+facname[j];
  printw(s);   newline;
end;

procedure TOutTeTtWin.ShowTtItems(i,d,p: integer);
var
  ro,sc,teyear,lev: integer;
  itemTt1,itemTt2,itemTt3: string;
  lNoOfStud: Integer;
begin
  if GetTeachTtItem(sc,ro,teYear,Lev,i,d,p) then
  begin
    if (sc<>subNA) then
    begin
      inc(tscount); ldcount:=ldCount+tsAllot[d,p];
    end;
    itemTt1:=trim(SubCode[sc]);
    itemTt2:=trim(XML_TEACHERS.tecode[ro,1]);
    itemTt3:=FNycSHARED(d,p,i,1);
    printc(ItemTt1); {subject}
    printc(ItemTt2); {room}
    if XML_DISPLAY.Tyr = 3 then
    begin
      lNoOfStud := GetNoOfStudentsInClass(TeYear, sc, i, ro, D, P);
      itemTt3 := IntToStr(lNoOfStud);
    end;
    printc(itemTt3); {class}
  end
  else
  begin printc(''); printc(''); printc(''); end;
end;

procedure teacherTtableOut;
begin
 OutTeTtWin:=TOutTeTtWin.Create;
 with OutTeTtWin do
  try
   PaintOnOutput;
  finally
   OutTeTtWin.free;
  end;
end;

procedure TTeTtable.PopupMenu1Popup(Sender: TObject);
begin
  selection2.Enabled := (codeCount[1] > 0);
  popTeachTTExportAsCSV.Visible := ListType = 1; //For daily
end;

function TTeTtable.PopulateFieldData(aFieldName: string): Variant;
begin
  //GetGridFieldValue(pipTeacherTT.RecordIndex, aFieldName);
end;

procedure TTeTtable.FormDblClick(Sender: TObject);
begin
 selection2click(self);
end;

procedure TTeTtable.FormDestroy(Sender: TObject);
begin
  if Assigned(FTeTimetable) then
    FreeAndNil(FTeTimetable);
end;

procedure TTeTtable.FormShow(Sender: TObject);
begin
  {pipTeacherTT.InitialIndex := 1;
  pipTeacherTT.RecordCount := 5;
  repTeacherTT.Print;}
end;

end.


