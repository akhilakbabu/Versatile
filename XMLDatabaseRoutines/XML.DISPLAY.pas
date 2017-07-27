unit XML.DISPLAY;

interface
uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Dialogs, SysUtils,Messages,  OXmlPDOM, clipBrd, OXmlUtils, TimeChartGlobals,
  XML.UTILS, GlobalToTcAndTcextra;


const
   OLD_DISPLAY_FILE = 'DISPLAY5.DAT';
   NEW_DISPLAY_FILE = 'DISPLAY5.XML';

type
  TXML_DISPLAY = class
  public
    DisplayHeader: String[4];
    fontlen: byte;
    tmpStr : string;
    tmpFs  : tFontStyles;
    tcfont,previewfont:           Tfont;
    winOrder                      : array [0..nmbrWindows] of smallint; {display.dat}
    winpos                        : array [0..nmbrWindows] of tpWinPos;
    winOrderNum                   : smallint;
    sortType: array [0..2] of smallint; {0,1, or 2}
    StudListType                  : smallint;  {1-7}
    ListNumberType                : smallint; {1-6}
    sTfind                        : smallint; {1-8 ,by name, sex etc}
    listRanges                    : array [1..4, 1..2] of smallint; {class to & from, then house then tutor then room}
    commonDataAll                 : wordbool;
    editBlockCheck                : wordbool;
    SubListType              : smallint;
    SubListGroupType      : smallint;
    _cI: smallint;
    sublistRanges                 : array [-2..nmbrOfGroupSubjects] of smallint;
    sublistfacnum                 : smallint;
    sublistday,
    sublisttime1,
    sublisttime2                  : smallint;
    sublistfree                   : smallint;
    studentttselection            : tpstudentdata;  // array [0..nmbrstudents] of smallint;
    StudTtListType            : smallint;
    stuttEnrolment                : wordbool;  //show enrolments under student weekly timetable
    stuttlistVals                 : array [1..8] of smallint;
    tettselection                 : tpTeData; //  tpTeData = array [0..nmbrteachers] of smallint;  nmbrteachers = 400;
  {teach ttable}
    tettseltype                   : smallint;
    tettLoads                     : wordbool; {show loads with weekly teacher tt}
    tettlistVals                  : array [1..5] of smallint;
    rottselection                 : tpTeData; // tpTeData = array [0..nmbrteachers] of smallint;  nmbrteachers = 400;
    rottseltype                   : smallint;
    OnlineUpdateCheck             :smallint;
    rottlistVals                  : array [1..5] of smallint;
    subttlistSelection            : smallint;
    subttlistVals                 : array [1..4] of smallint;
    subttGroup                    : tplevelSub; //tplevelSub = array [0..nmbrLevels] of smallint;  nmbrLevels = 150;
    ttprntselsubg                 : tpSubData; //tpSubData = array [0..nmbrSubjects] of smallint; nmbrSubjects = 3000; :(
    ttprntselteachg               : tpTeData; // tpTeData = array [0..nmbrteachers] of smallint;  nmbrteachers = 400;
    ttprntselroomg                : tpTeData; // tpTeData = array [0..nmbrteachers] of smallint;  nmbrteachers = 400;
      {tt print selection dlg}
    ttprntseltype                 : smallint;
    ttPrntFac                     : smallint;
    ttprntselday                  : smallint;
    ttprntselyear                 : smallint;
    ttPrntType                    : smallint;
    grpofteselsubg                : tpSubData;
    grpofteyear                   : smallint;
    grpofteclass                  : smallint;
    grpoftelevel                  : smallint;
    grpoftefac                    : smallint;
    grpoftetimes                  : smallint;
    grpofteday                    : smallint;
    clashmatrixselection          : tpCmatrixSelection;  //tpCmatrixSelection = array [0..nmbrSubYear] of smallint;   nmbrSubYear = 3000;
    TeFreeSelect                  : tpTeData;
    teachersfreeday               : smallint;
    teachersfreefac               : smallint;
    teachersfreeshow1             : smallint; {1..3, time slot/frees/teacher}
    teachersfreeshow2             : smallint; {1..3, all/selection/year }
    TeFreePeriod                  : smallint;
    teFreeYear                    : smallint;
    RoomsFreeSelection            : tpTeData;
    roomsfreeday                  : smallint;
    roomsfreePeriod               : smallint;
    roomsfreefac                  : smallint;
    roomsfreeshow1                : smallint; {1..3, time slot/frees/room}
    roomsfreeshow2                : smallint; {1..2, all/selection/ }
    {teacher times dlg}
    TeTimesSelect         : tpTeData;
    teachertimesyear              : smallint;
    teachertimesfac               : smallint;
    teachertimesshow1             : smallint; {1..3, time slot/frees/teacher}
    teachertimesshow2             : smallint; {1..3, all/selection/faculty }
    {teacher list dlg}
    teListSelection               : tpTeData;
    teListFac                     : smallint;
    teListShow                    : smallint; {1..2, all/selection}
      {subject times dlg}
    subjecttimesyear              : smallint;
    subjecttimesfac               : smallint;
    subjecttimesshow2             : smallint; {1..3, all/selection/faculty }
    studentinputselection         : tpstudentdata;  // array [0..nmbrstudents] of smallint;

    StInputPref1             : smallint;
    StInputPref2             : smallint;
    StInputClass             : smallint;
    StInputHouse             : smallint;
    StInputTutor             : smallint;
    StInputRoom              : smallint;
    studentinputshow1        : smallint;
    studentinputshow2        : smallint;
    {promote students dlg}
    clearstudentchoicesflag       : wordbool;
    {teaacher clashes}
    tcCurPeriodOnly               : wordbool;
    {room clashes}
    rcCurPeriodOnly               : wordbool;
    blocknum                      : smallint; {no. of blocks}
    blocklevel                    : smallint; {no. of levels in blocks}
    prntLeftMargin,
    prntTopMargin                 : single; {keep cm wanted}
    datestamp: wordbool;
    sTtag: wordbool;
    colorPrinterFlag:                wordbool;
    sTsex: wordbool;
    sTclass: wordbool;
    sThouse: wordbool;
    sTtutor: wordbool;
    sThome: wordbool;
    sTID: wordbool;
     {printer settings}
    double_space: wordbool;
    double_print: smallint;
    blockshow: wordbool;
    sTselect: smallint;
    sexselect: smallint;
    PreviewLastZoom:  smallint;
    listEnrolment                 : wordbool;
    listShowClashes               : wordbool;
    prefNotebookPageIndex         : smallint;
    tsOn: array  [0..nmbrDays,0..nmbrPeriods] of boolean;
    Pyear: array [0..nmbrYears] of boolean;
    Dprint: array[0..nmbrDays] of boolean;
    Tfreeshow: wordbool;
    Rfreeshow: wordbool;
    Pweek: smallint;
    Tyr: smallint;
    ttWeekDaysFlg,
    ttClockShowFlg:  wordbool;
    fsDoRoomCap: wordbool;
    wsAlterBox           : smallint;
    MaxClassSize: smallint;
    BLsolution,
    BLtries: smallint; {create blocks}
    ExcludeClassSize: smallint;
    SplitDiff: wordbool;
    autobalance,balanceflag: smallint;
    trackflag                     : wordbool; {entry dialog - track timetable }
    StudPasteID: smallint;
    StudPasteSub: smallint;
    StudPasteFields: smallint;
    StudPasteAddSub               : wordbool;
    abOverwrite                   : wordbool;
    AlterBox           : smallint;
    SearchBox                     : smallint;
    chScope,
    chType                        : smallint; {timetable clash help}
    EdfacSubType: smallint; {edit faculty dialogue}
    Formfeed                      : wordbool;
    GroupIndexDisplay: Integer;
    globalHints                   : wordbool;
    OKbackup                      : wordbool;
    OKquitcheck                   : wordbool;
    Txtsep: smallint;
    Txtlim: smallint;
    showHintsDlg                  : wordbool;
    fgReshowWStoolbar         : wordbool;
    fgReshowTTtoolbar         : wordbool;
    fgReshowBlockToolbar      : wordbool;
    fgTTtoolbarDock           : smallint;
    fgBlockToolbarDock        : smallint;
    fgGenToolbarDock          : smallint;
    sTyear: wordbool;
                 // form here down need to write
    EntrySelectionLink            : wordbool;
    sublistYear                   : smallint;
    FAfirst,
    FAsex,
    FAclass,
    FAID,
    FAhouse: wordbool;
    FAreplace,
    FAtutor,
    FAhome,
    FAyear: wordbool;
    FAsubnum: smallint;
    GenericTtableFlag             : wordbool;
    MatchAllYears:                boolean;
    customFileLoadFlag            : wordbool;
    customFileLoad                : string;
    OberonOutputType              : smallint;
    fgsubBySubListZeroSkip        : wordbool;
    fgWStoolbarDock               : smallint;
    UseGroupFindStud              : wordbool;
    StInputDlgPageIndex           : smallint;
    subttWide                     : boolean;
    TrackEnrolFlag                : wordbool;
    StHeadShow                    : wordbool;
    EnrolBarcodeFlg               : wordbool;
    winViewMax:                   array[0..nmbrWindows] of smallint;
    sTID2:                        wordbool;
    FExportFileIdx                : Integer;
    FIsLandscape                  : Integer;
    stEmail:                      wordbool;


    procedure saveDisplayFile(_dir: string);

    constructor create;
  end;

(*
procedure LoadWinDisplay;
  -> loadDisplayFile('DISPLAY5.DAT')

procedure saveDisplayFile(displayFile:string);
  ->
*)


var  XML_DISPLAY: TXML_DISPLAY;

implementation

{ TXML_DISPLAY }

constructor TXML_DISPLAY.create;
begin
  inherited;
  StudPasteID:= 2;
  StudPasteSub:= 1;
  StudPasteFields:= 1;
  StudPasteAddSub := false;
  fgReshowWStoolbar:= false;
  fgReshowTTtoolbar:= false;
  fgReshowBlockToolbar:= false;
  fgTTtoolbarDock:= 1;
  fgBlockToolbarDock:= 1;
  fgGenToolbarDock:= 1;
  fgWStoolbarDock:=1;
  TrackEnrolFlag:= false;
  StHeadShow:=  true;
  EnrolBarcodeFlg:= false;


end;

procedure TXML_DISPLAY.saveDisplayFile(_dir: string);
var
  _XML: IXMLDocument;
  _Root, _Attribute, _Node: PXMLNode;
  i, j: integer;
begin
    chdir(_dir);
    _XML := CreateXMLDoc('DISPLAY5', True);//create XML doc with root node named "root"
    _XML.WriterSettings.IndentType := itIndent;
    _Root := _XML.DocumentElement;
    _Node := _Root.AddChild('SIGNATURE');//add child to root node
     writeToAttribute(_Node, 'DISPLAYHEADER', DisplayHeader);
    _Node.SetAttribute('DISPLAYHEADER', DisplayHeader);
    _Node := _Root.AddChild('TIMECHART_FONTS');//add child to root node
     writeToAttribute(_Node, 'NAME', tcfont.Name);
     writeToAttribute(_Node, 'SIZE', tcfont.size);
     writeToAttribute(_Node, 'STYLE', tcfont.style);
    // winOrder                      : array [0..nmbrWindows] of smallint; {display.dat}
    for i := 0 to nmbrWindows do begin
       _Node:= writeNodeIndexValues(_Root,'WINDOW_ORDER',i,winOrder[i]);
    end;
    //winpos                        : array [0..nmbrWindows] of tpWinPos;
    for i := 0 to nmbrWindows do begin
      _Node := _Root.AddChild('WINDOW_POSITION');
      writeToAttribute(_Node, 'INDEX', i);
      writeToAttribute(_Node, 'TOP', winpos[i].top);
      writeToAttribute(_Node, 'LEFT', winpos[i].left);
      writeToAttribute(_Node, 'WIDTH', winpos[i].width);
      writeToAttribute(_Node, 'HEIGHT', winpos[i].height);
      writeToAttribute(_Node, 'STATE', winpos[i].state);
    end;
    //sortType: array [0..2] of smallint; {0,1, or 2}
    for i := 0 to 2 do begin
      _Node:= writeNodeIndexValues(_Root,'SORT_TYPE',i,sortType[i]);
    end;
    //XML_DISPLAY.StudListType:=BlockReadInt2(1,7);
    writeToNode(_Root,'STUDENT_LIST_TYPE',StudListType);
    //XML_DISPLAY.listnumbertype:=BlockReadInt2(1,6);
    writeToNode(_Root,'LIST_NUMBER_TYPE',listnumbertype);
    //XML_DISPLAY.sTfind:=BlockReadInt2(1,9);
    writeToNode(_Root,'STUDENT_FIND',sTfind);
    //listRanges                    : array [1..4, 1..2] of smallint; {class to & from, then house then tutor then room}
    for i:=1 to 4 do
      for j:=1 to 2 do begin
          _Node := _Root.AddChild('LIST_RANGES');//add child to root node
          writeToAttribute(_Node, 'X', i);
          writeToAttribute(_Node, 'Y', j);
          writeToAttribute(_Node, 'VALUE',listRanges[i,j]);
      end;
     writeToNode(_Root,'COMMONDATAALL',COMMONDATAALL);
     writeToNode(_Root,'EDITBLOCKCHECK',EDITBLOCKCHECK);
     writeToNode(_Root,'SUBLISTTYPE',SUBLISTTYPE);
     writeToNode(_Root,'SUBLISTGROUPTYPE',SUBLISTGROUPTYPE);
    //sublistRanges                 : array [-2..nmbrOfGroupSubjects] of smallint;
    for i := -2 to nmbrOfGroupSubjects do begin
       _Node:= writeNodeIndexValues(_Root,'SUBLISTRANGES',i,SUBLISTRANGES[i]);
    end;
    //sublistday,    sublisttime1,    sublisttime2                  : smallint;
    writeToNode(_Root,'SUBLISTDAY',SUBLISTDAY);
    writeToNode(_Root,'SUBLISTTIME1',SUBLISTTIME1);
    writeToNode(_Root,'SUBLISTTIME2',SUBLISTTIME2);
    //SUBLISTFREE
    writeToNode(_Root,'SUBLISTFREE',SUBLISTFREE);
    //STUDENTTTSELECTION            : tpstudentdata;  // array [0..nmbrstudents] of smallint;
    for i := 0 to nmbrstudents do begin
      if STUDENTTTSELECTION[i] = 0 then
        continue;
      _Node:= writeNodeIndexValues(_Root,'STUDENTTTSELECTION',i,STUDENTTTSELECTION[i]);
    end;
    //STUTTLISTVALS                 : array [1..8] of smallint;
    for i := 1 to 8 do begin
       _Node:= writeNodeIndexValues(_Root,'STUTTLISTVALS',i,STUTTLISTVALS[i]);
    end;
    //TETTSELECTION                 : tpTeData; //  tpTeData = array [0..nmbrteachers] of smallint;  nmbrteachers = 400;
    for i := 0 to nmbrteachers do begin
      if TETTSELECTION[i] =  0 then
        continue;
      _Node:= writeNodeIndexValues(_Root,'TETTSELECTION',i,TETTSELECTION[i]);
    end;
    //TETTSELTYPE  : smallint; TETTLOADS : wordbool;   TETTLISTVALS                  : array [1..5] of smallint;
    writeToNode(_Root,'TETTSELTYPE',TETTSELTYPE);
    writeToNode(_Root,'TETTLOADS',TETTLOADS);
    for i := 1 to 5 do begin
      _Node:= writeNodeIndexValues(_Root,'TETTLISTVALS',i,TETTLISTVALS[i]);
    end;
    //ROTTSELECTION: tpTeData; // tpTeData = array [0..nmbrteachers] of smallint;  nmbrteachers = 400;
    for i := 0 to nmbrteachers do begin
      if ROTTSELECTION[i] = 0 then
          continue;
      _Node:= writeNodeIndexValues(_Root,'ROTTSELECTION',i,ROTTSELECTION[i]);
    end;
    //ROTTSELTYPE: SMALLINT; ONLINEUPDATECHECK:SMALLINT; ROTTLISTVALS: ARRAY [1..5] OF SMALLINT;
    writeToNode(_Root,'ROTTSELTYPE',ROTTSELTYPE);
    writeToNode(_Root,'ONLINEUPDATECHECK',ONLINEUPDATECHECK);
    for i := 1 to 5 do begin
      _Node:= writeNodeIndexValues(_Root,'ROTTSELECTION',i,ROTTLISTVALS[i]);
    end;
    //SUBTTLISTSELECTION : SMALLINT; SUBTTLISTVALS: ARRAY [1..4] OF SMALLINT;
    writeToNode(_Root,'SUBTTLISTSELECTION',SUBTTLISTSELECTION);
    for i := 1 to 4 do begin
      _Node:= writeNodeIndexValues(_Root,'SUBTTLISTVALS',i,SUBTTLISTVALS[i]);
    end;
    //SUBTTGROUP: TPLEVELSUB; //TPLEVELSUB = ARRAY [0..NMBRLEVELS] OF SMALLINT;  NMBRLEVELS = 150;
    for i := 0 to NMBRLEVELS do begin
      if SUBTTGROUP[i] = 0 then
        continue;
      _Node:= writeNodeIndexValues(_Root,'SUBTTGROUP',i,SUBTTGROUP[i]);
    end;
    //TTPRNTSELSUBG                 : TPSUBDATA; //TPSUBDATA = ARRAY [0..NMBRSUBJECTS] OF SMALLINT; NMBRSUBJECTS = 3000; :(
    for i := 0 to NMBRSUBJECTS do begin
      if TTPRNTSELSUBG[i] = 0 then
        continue;
      _Node:= writeNodeIndexValues(_Root,'TTPRNTSELSUBG',i,TTPRNTSELSUBG[i]);
    end;
    //TTPRNTSELTEACHG               : TPTEDATA; // TPTEDATA = ARRAY [0..NMBRTEACHERS] OF SMALLINT;  NMBRTEACHERS = 400;
    for i := 0 to NMBRTEACHERS do begin
      if TTPRNTSELTEACHG[i] = 0 then
        continue;
      _Node:= writeNodeIndexValues(_Root,'TTPRNTSELTEACHG',i,TTPRNTSELTEACHG[i]);
    end;
    //TTPRNTSELROOMG                : TPTEDATA; // TPTEDATA = ARRAY [0..NMBRTEACHERS] OF SMALLINT;  NMBRTEACHERS = 400;
    for i := 0 to NMBRTEACHERS do begin
      if TTPRNTSELROOMG[i] = 0 then
        continue;
      _Node:= writeNodeIndexValues(_Root,'TTPRNTSELROOMG',i,TTPRNTSELROOMG[i]);
    end;
    //TTPRNTSELTYPE                 : SMALLINT;
    writeToNode(_Root,'TTPRNTSELTYPE',TTPRNTSELTYPE);
    //TTPRNTFAC               : SMALLINT;
    writeToNode(_Root,'TTPRNTFAC',TTPRNTFAC);
    //TTPRNTSELDAY                  : SMALLINT;
    writeToNode(_Root,'TTPRNTSELDAY',TTPRNTSELDAY);
    //TTPRNTSELYEAR                 : SMALLINT;
    writeToNode(_Root,'TTPRNTSELYEAR',TTPRNTSELYEAR);
    //TTPRNTTYPE             : SMALLINT;
    writeToNode(_Root,'TTPRNTTYPE',TTPRNTTYPE);

    //GRPOFTESELSUBG                : TPSUBDATA; //tpSubData = array [0..nmbrSubjects] of smallint; nmbrSubjects = 3000; :(
     for i := 0 to NMBRSUBJECTS do begin
      if GRPOFTESELSUBG[i] = 0 then
        continue;
      _Node:= writeNodeIndexValues(_Root,'GRPOFTESELSUBG',i,GRPOFTESELSUBG[i]);
    end;
    //GRPOFTEYEAR                   : SMALLINT;
    writeToNode(_Root,'GRPOFTEYEAR',GRPOFTEYEAR);
    //GRPOFTECLASS                  : SMALLINT;
    writeToNode(_Root,'GRPOFTECLASS',GRPOFTECLASS);
    //GRPOFTELEVEL                  : SMALLINT;
    writeToNode(_Root,'GRPOFTELEVEL',GRPOFTELEVEL);
    //GRPOFTEFAC                    : SMALLINT;
    writeToNode(_Root,'GRPOFTEFAC',GRPOFTEFAC);
    //GRPOFTETIMES                  : SMALLINT;
    writeToNode(_Root,'GRPOFTETIMES',GRPOFTETIMES);
    //GRPOFTEDAY                    : SMALLINT;
    writeToNode(_Root,'GRPOFTEDAY',GRPOFTEDAY);
    //CLASHMATRIXSELECTION          : TPCMATRIXSELECTION;  //TPCMATRIXSELECTION = ARRAY [0..NMBRSUBYEAR] OF SMALLINT;   NMBRSUBYEAR = 3000;
    for i := 0 to nmbrSubYear do begin
      if CLASHMATRIXSELECTION[i] = 0 then
        continue;
      _Node:= writeNodeIndexValues(_Root,'CLASHMATRIXSELECTION',i,CLASHMATRIXSELECTION[i]);
    end;
    //TEFREESELECT                  : TPTEDATA;
    for i := 0 to NMBRTEACHERS do begin
      if TEFREESELECT[i] = 0 then
        continue;
      _Node:= writeNodeIndexValues(_Root,'TEFREESELECT',i,TEFREESELECT[i]);
    end;
    //TEACHERSFREEDAY               : SMALLINT;
    writeToNode(_Root,'TEACHERSFREEDAY',TEACHERSFREEDAY);
    //TEACHERSFREEFAC               : SMALLINT;
    writeToNode(_Root,'TEACHERSFREEFAC',TEACHERSFREEFAC);
    //TEACHERSFREESHOW1             : SMALLINT; {1..3, TIME SLOT/FREES/TEACHER}
    writeToNode(_Root,'TEACHERSFREESHOW1',TEACHERSFREESHOW1);
    //TEACHERSFREESHOW2             : SMALLINT; {1..3, ALL/SELECTION/YEAR }
    writeToNode(_Root,'TEACHERSFREESHOW2',TEACHERSFREESHOW2);
    //TEFREEPERIOD                  : SMALLINT;
    writeToNode(_Root,'TEFREEPERIOD',TEFREEPERIOD);
    //TEFREEYEAR                    : SMALLINT;
    writeToNode(_Root,'TEFREEYEAR',TEFREEYEAR);

    //ROOMSFREESELECTION            : TPTEDATA;
    for i := 0 to nmbrteachers do begin
      if ROOMSFREESELECTION[i] =  0 then
        continue;
      _Node:= writeNodeIndexValues(_Root,'ROOMSFREESELECTION',i,ROOMSFREESELECTION[i]);
    end;
    //ROOMSFREEDAY                  : SMALLINT;
    writeToNode(_Root,'ROOMSFREEDAY',ROOMSFREEDAY);
    //ROOMSFREEPERIOD               : SMALLINT;
    writeToNode(_Root,'ROOMSFREEPERIOD',ROOMSFREEPERIOD);
    //ROOMSFREEFAC                  : SMALLINT;
    writeToNode(_Root,'ROOMSFREEFAC',ROOMSFREEFAC);
    //ROOMSFREESHOW1                : SMALLINT; {1..3, TIME SLOT/FREES/ROOM}
    writeToNode(_Root,'ROOMSFREESHOW1',ROOMSFREESHOW1);
    //ROOMSFREESHOW2                : SMALLINT; {1..2, ALL/SELECTION/ }
    writeToNode(_Root,'ROOMSFREESHOW2',ROOMSFREESHOW2);

    //TETIMESSELECT         : TPTEDATA;
    for i := 0 to nmbrteachers do begin
      if TETIMESSELECT[i] =  0 then
        continue;
      _Node:= writeNodeIndexValues(_Root,'TETIMESSELECT',i,TETIMESSELECT[i]);
    end;
    //TEACHERTIMESYEAR              : SMALLINT;
    writeToNode(_Root,'TEACHERTIMESYEAR',TEACHERTIMESYEAR);
    //TEACHERTIMESFAC               : SMALLINT;
    writeToNode(_Root,'TEACHERTIMESFAC',TEACHERTIMESFAC);
    //TEACHERTIMESSHOW1             : SMALLINT; {1..3, TIME SLOT/FREES/TEACHER}
    writeToNode(_Root,'TEACHERTIMESSHOW1',TEACHERTIMESSHOW1);
    //TEACHERTIMESSHOW2             : SMALLINT; {1..3, ALL/SELECTION/FACULTY }
    writeToNode(_Root,'TEACHERTIMESSHOW2',TEACHERTIMESSHOW2);
    //TELISTSELECTION               : TPTEDATA;
    for i := 0 to nmbrteachers do begin
      if TELISTSELECTION[i] =  0 then
        continue;
      _Node:= writeNodeIndexValues(_Root,'TELISTSELECTION',i,TELISTSELECTION[i]);
    end;
    //TELISTFAC                     : SMALLINT;
    writeToNode(_Root,'TELISTFAC',TELISTFAC);
    //TELISTSHOW                    : SMALLINT; {1..2, ALL/SELECTION}
    writeToNode(_Root,'TELISTSHOW',TELISTSHOW);
    //SUBJECTTIMESYEAR              : SMALLINT;
    writeToNode(_Root,'SUBJECTTIMESYEAR',SUBJECTTIMESYEAR);
    //SUBJECTTIMESFAC               : SMALLINT;
    writeToNode(_Root,'SUBJECTTIMESFAC',SUBJECTTIMESFAC);
    //SUBJECTTIMESSHOW2             : SMALLINT; {1..3, ALL/SELECTION/FACULTY }
    writeToNode(_Root,'SUBJECTTIMESSHOW2',SUBJECTTIMESSHOW2);
    //studentinputselection         : tpstudentdata;  // array [0..nmbrstudents] of smallint;
    for i := 0 to nmbrstudents do begin
      if studentinputselection[i] = 0 then
        continue;
      _Node:= writeNodeIndexValues(_Root,'STUDENTINPUTSELECTION',i,STUDENTINPUTSELECTION[i]);
    end;
    //STINPUTPREF1             : SMALLINT;
    writeToNode(_Root,'STINPUTPREF1',STINPUTPREF1);
    //STINPUTPREF2             : SMALLINT;
    writeToNode(_Root,'STINPUTPREF2',STINPUTPREF2);
    //STINPUTCLASS             : SMALLINT;
    writeToNode(_Root,'STINPUTCLASS',STINPUTCLASS);
    //STINPUTHOUSE             : SMALLINT;
    writeToNode(_Root,'STINPUTHOUSE',STINPUTHOUSE);
    //STINPUTTUTOR             : SMALLINT;
    writeToNode(_Root,'STINPUTTUTOR',STINPUTTUTOR);
    //STINPUTROOM              : SMALLINT;
    writeToNode(_Root,'STINPUTROOM',STINPUTROOM);
    //STUDENTINPUTSHOW1        : SMALLINT;
    writeToNode(_Root,'STUDENTINPUTSHOW1',STUDENTINPUTSHOW1);
    //STUDENTINPUTSHOW2        : SMALLINT;
    writeToNode(_Root,'STUDENTINPUTSHOW2',STUDENTINPUTSHOW2);
    //clearstudentchoicesflag       : wordbool;
    writeToNode(_Root,'clearstudentchoicesflag',clearstudentchoicesflag);
    //tcCurPeriodOnly               : wordbool;
    writeToNode(_Root,'tcCurPeriodOnly',tcCurPeriodOnly);
    //rcCurPeriodOnly               : wordbool;
    writeToNode(_Root,'rcCurPeriodOnly',rcCurPeriodOnly);
    //blocknum                      : smallint; {no. of blocks}
    writeToNode(_Root,'blocknum',blocknum);
    //blocklevel                    : smallint; {no. of levels in blocks}
    writeToNode(_Root,'blocklevel',blocklevel);
    //prntLeftMargin,
    writeToNode(_Root,'prntLeftMargin',prntLeftMargin);
    //prntTopMargin                 : single; {keep cm wanted}
    writeToNode(_Root,'prntTopMargin',prntTopMargin);
    //datestamp: wordbool;
    writeToNode(_Root,'datestamp',datestamp);
    //sTtag: wordbool;
    writeToNode(_Root,'sTtag',sTtag);
    //colorPrinterFlag:                wordbool;
    writeToNode(_Root,'colorPrinterFlag',colorPrinterFlag);
    //sTsex: wordbool;
    writeToNode(_Root,'sTsex',sTsex);
    //sTclass: wordbool;
    writeToNode(_Root,'sTclass',sTclass);
    //sThouse: wordbool;
    writeToNode(_Root,'sThouse',sThouse);
    //sTtutor: wordbool;
    writeToNode(_Root,'sTtutor',sTtutor);
    //sThome: wordbool;
    writeToNode(_Root,'sThome',sThome);
    //sTID: wordbool;
    writeToNode(_Root,'sTID',sTID);
    //double_space: wordbool;
    writeToNode(_Root,'double_space',double_space);
    //double_print: smallint;
    writeToNode(_Root,'double_print',double_print);
    //blockshow: wordbool;
    writeToNode(_Root,'blockshow',blockshow);
    //sTselect: smallint;
    writeToNode(_Root,'sTselect',sTselect);
    //sexselect: smallint;
    writeToNode(_Root,'sexselect',sexselect);
    //PreviewLastZoom:  smallint;
    writeToNode(_Root,'PreviewLastZoom',PreviewLastZoom);
    //listEnrolment                 : wordbool;
    writeToNode(_Root,'listEnrolment',listEnrolment);
    //listShowClashes               : wordbool;
    writeToNode(_Root,'listShowClashes',listShowClashes);
    //prefNotebookPageIndex         : smallint;
    writeToNode(_Root,'prefNotebookPageIndex',prefNotebookPageIndex);
    //tsOn: array  [0..nmbrDays,0..nmbrPeriods] of boolean;
    for i := 0 to nmbrDays do begin
      for j:=0 to nmbrPeriods do begin
          _Node := _Root.AddChild('TSON');//add child to root node
          writeToAttribute(_Node, 'X', i);
          writeToAttribute(_Node, 'Y', j);
          writeToAttribute(_Node, 'VALUE',tsOn[i,j]);
      end;
    end;
    //Pyear: array [0..nmbrYears] of boolean;
    for i := 0 to nmbrYears do begin
      _Node:= writeNodeIndexValues(_Root,'Pyear',i,Pyear[i]);
    end;
    //Dprint: array[0..nmbrDays] of boolean;
    for i := 0 to nmbrDays do begin
      _Node:= writeNodeIndexValues(_Root,'Dprint',i,Dprint[i]);
    end;
    //Tfreeshow: wordbool;
    writeToNode(_Root,'Tfreeshow',Tfreeshow);
    //Rfreeshow: wordbool;
    writeToNode(_Root,'Rfreeshow',Rfreeshow);
    //Pweek: smallint;
    writeToNode(_Root,'Pweek',Pweek);
    //Tyr: smallint;
    writeToNode(_Root,'Tyr',Tyr);
    //ttWeekDaysFlg,
    writeToNode(_Root,'ttWeekDaysFlg',ttWeekDaysFlg);
    //ttClockShowFlg:  wordbool;
    writeToNode(_Root,'ttClockShowFlg',ttClockShowFlg);
    //fsDoRoomCap: wordbool;
    writeToNode(_Root,'fsDoRoomCap',fsDoRoomCap);
    //wsAlterBox           : smallint;
    writeToNode(_Root,'wsAlterBox',wsAlterBox);
    //MaxClassSize: smallint;
    writeToNode(_Root,'MaxClassSize',MaxClassSize);
    //BLsolution,
    writeToNode(_Root,'BLsolution',BLsolution);
    //BLtries: smallint; {create blocks}
    writeToNode(_Root,'BLtries',BLtries);
    //ExcludeClassSize: smallint;
    writeToNode(_Root,'ExcludeClassSize',ExcludeClassSize);
    //SplitDiff: wordbool;
    writeToNode(_Root,'SplitDiff',SplitDiff);
    //autobalance,balanceflag: smallint;
    writeToNode(_Root,'autobalance',autobalance);
    //trackflag                     : wordbool;
    writeToNode(_Root,'trackflag',trackflag);
    //StudPasteID: smallint;
    writeToNode(_Root,'StudPasteID',StudPasteID);
    //StudPasteSub: smallint;
    writeToNode(_Root,'StudPasteSub',StudPasteSub);
    //StudPasteFields: smallint;
    writeToNode(_Root,'StudPasteFields',StudPasteFields);
    //StudPasteAddSub               : wordbool;
    writeToNode(_Root,'StudPasteAddSub',StudPasteAddSub);
    //abOverwrite                   : wordbool;
    writeToNode(_Root,'abOverwrite',abOverwrite);
    //AlterBox           : smallint;
    writeToNode(_Root,'AlterBox',AlterBox);
    //SearchBox                     : smallint;
    writeToNode(_Root,'SearchBox',SearchBox);
    //chScope,
    writeToNode(_Root,'chScope',chScope);
    //chType                        : smallint; {timetable clash help}
    writeToNode(_Root,'chType',chType);
    //EdfacSubType: smallint; {edit faculty dialogue}
    writeToNode(_Root,'EdfacSubType',EdfacSubType);
    //Formfeed                      : wordbool;
    writeToNode(_Root,'Formfeed',Formfeed);
    //GroupIndexDisplay: Integer;
    writeToNode(_Root,'GroupIndexDisplay',GroupIndexDisplay);
    //globalHints                   : wordbool;
    writeToNode(_Root,'globalHints',globalHints);
    //OKbackup                      : wordbool;
    writeToNode(_Root,'OKbackup',OKbackup);
    //OKquitcheck                   : wordbool;
    writeToNode(_Root,'OKquitcheck',OKquitcheck);
    //Txtsep: smallint;
    writeToNode(_Root,'Txtsep',Txtsep);
    //Txtlim: smallint;
    writeToNode(_Root,'Txtlim',Txtlim);
    //showHintsDlg                  : wordbool;
    writeToNode(_Root,'showHintsDlg',showHintsDlg);
    //fgReshowWStoolbar         : wordbool;
    writeToNode(_Root,'fgReshowWStoolbar',fgReshowWStoolbar);
    //fgReshowTTtoolbar         : wordbool;
    writeToNode(_Root,'fgReshowTTtoolbar',fgReshowTTtoolbar);
    //fgReshowBlockToolbar      : wordbool;
    writeToNode(_Root,'fgReshowBlockToolbar',fgReshowBlockToolbar);
    //fgTTtoolbarDock           : smallint;
    writeToNode(_Root,'fgTTtoolbarDock',fgTTtoolbarDock);
    //fgBlockToolbarDock        : smallint;
    writeToNode(_Root,'fgBlockToolbarDock',fgBlockToolbarDock);
    //fgGenToolbarDock          : smallint;
    writeToNode(_Root,'fgGenToolbarDock',fgGenToolbarDock);
    //sTyear: wordbool;
    writeToNode(_Root,'sTyear',sTyear);

    //EntrySelectionLink            : wordbool;
    writeToNode(_Root,'EntrySelectionLink',EntrySelectionLink);
    //sublistYear                   : smallint;
    writeToNode(_Root,'sublistYear',sublistYear);
    //FAfirst,
    writeToNode(_Root,'FAfirst',FAfirst);
    //FAsex,
    writeToNode(_Root,'FAsex',FAsex);
    //FAclass,
    writeToNode(_Root,'FAclass',FAclass);
    //FAID,
    writeToNode(_Root,'FAID',FAID);
    //FAhouse: wordbool;
    writeToNode(_Root,'FAhouse',FAhouse);
    //FAreplace,
    writeToNode(_Root,'FAreplace',FAreplace);
    //FAtutor,
    writeToNode(_Root,'FAtutor',FAtutor);
    //FAhome,
    writeToNode(_Root,'FAhome',FAhome);
    //FAyear: wordbool;
    writeToNode(_Root,'FAyear',FAyear);
    //FAsubnum: smallint;
    writeToNode(_Root,'FAsubnum',FAsubnum);
    //GenericTtableFlag             : wordbool;
    writeToNode(_Root,'GenericTtableFlag',GenericTtableFlag);
    //MatchAllYears:                boolean;
    writeToNode(_Root,'MatchAllYears',MatchAllYears);
    //customFileLoadFlag            : wordbool;
    writeToNode(_Root,'scustomFileLoadFlagTyear',customFileLoadFlag);
    //customFileLoad                : string;
    writeToNode(_Root,'customFileLoad',customFileLoad, True);
    //OberonOutputType              : smallint;
    writeToNode(_Root,'OberonOutputType',OberonOutputType);
    //fgsubBySubListZeroSkip        : wordbool;
    writeToNode(_Root,'fgsubBySubListZeroSkip',fgsubBySubListZeroSkip);
    //fgWStoolbarDock               : smallint;
    writeToNode(_Root,'fgWStoolbarDock',fgWStoolbarDock);
    //UseGroupFindStud              : wordbool;
    writeToNode(_Root,'UseGroupFindStud',UseGroupFindStud);
    //StInputDlgPageIndex           : smallint;
    writeToNode(_Root,'StInputDlgPageIndex',StInputDlgPageIndex);
    //subttWide                     : boolean;
    writeToNode(_Root,'subttWide',subttWide);
    //subttWide                : wordbool;
    writeToNode(_Root,'subttWide',subttWide);
    //StHeadShow                    : wordbool;
    writeToNode(_Root,'StHeadShow',StHeadShow);
    //EnrolBarcodeFlg               : wordbool;
    writeToNode(_Root,'EnrolBarcodeFlg',EnrolBarcodeFlg);
    //winViewMax:                   array[0..nmbrWindows] of smallint;
    for i := 0 to nmbrWindows do begin
       _Node:= writeNodeIndexValues(_Root,'winViewMax',i,winViewMax[i]);
    end;

    //sTID2:                        wordbool;
    writeToNode(_Root,'sTID2',sTID2);
    //FExportFileIdx                : Integer;
    writeToNode(_Root,'FExportFileIdx',FExportFileIdx);
    //FIsLandscape                  : Integer;
    writeToNode(_Root,'FIsLandscape',FIsLandscape);
    //    stEmail:                      wordbool;
    writeToNode(_Root,'stEmail',stEmail);




    _XML.SaveToFile(NEW_DISPLAY_FILE);//save XML document
end;

initialization
  XML_DISPLAY:= TXML_DISPLAY.Create;

finalization
  XML_DISPLAY.free;

end.
