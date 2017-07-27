unit Main;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Menus, Tcgetdir, ToolWin, ImgList,
  ActnList, ActnMan, StdActns, TimeChartGlobals,ClassDefs, XPStyleActnCtrls, ehsbase,
  ehswhatsthis, ehshelprouter, ComCtrls, uAMGStudent, SHDocVw, OleCtrls, DB,
  //ZAbstractRODataset, ZAbstractDataset, ZAbstractTable, ZDataset,ZSequence,
  printers, XML.TTABLE, XML.USERS, XML.UTILS,GlobalToTcAndTcextra, XML.DISPLAY,
  XML.STUDENTS;

  type
  TMainForm = class(TForm)
    MainMenu: TMainMenu;
    FileOpenItem: TMenuItem;
    Close1: TMenuItem;
    Save1: TMenuItem;
    ReverttoSaved1: TMenuItem;
    Print1: TMenuItem;
    PrintSetup1: TMenuItem;
    FileExitItem: TMenuItem;
    WindowTileItem: TMenuItem;
    WindowCascadeItem: TMenuItem;
    WindowArrangeItem: TMenuItem;
    HelpContentsItem: TMenuItem;
    HelpAboutItem: TMenuItem;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    PrintSetupDialog: TPrinterSetupDialog;
    Display: TMenuItem;
    N5: TMenuItem;
    Info1: TMenuItem;
    Codes1: TMenuItem;
    YearSubjects1: TMenuItem;
    N6: TMenuItem;
    Blocks1: TMenuItem;
    SubjectList1: TMenuItem;
    StudentList1: TMenuItem;
    BlockInfo1: TMenuItem;
    StudentTimetable1: TMenuItem;
    N7: TMenuItem;
    Timetable1: TMenuItem;
    ClashHelp1: TMenuItem;
    TimetableInfo1: TMenuItem;
    Teacher1: TMenuItem;
    Room1: TMenuItem;
    Subject1: TMenuItem;
    N8: TMenuItem;
    SaveAs: TMenuItem;
    Subject2: TMenuItem;
    Teacher2: TMenuItem;
    Room2: TMenuItem;
    Class1: TMenuItem;
    Faculty1: TMenuItem;
    House1: TMenuItem;
    TileVertical1: TMenuItem;
    N2: TMenuItem;
    Font1: TMenuItem;
    Preferences1: TMenuItem;
    FontDialog1: TFontDialog;
    N4: TMenuItem;
    NewData1: TMenuItem;
    Find1: TMenuItem;
    Student1: TMenuItem;
    Timetable2: TMenuItem;
    Student2: TMenuItem;
    Teacher3: TMenuItem;
    Room3: TMenuItem;
    N9: TMenuItem;
    YearSubjects2: TMenuItem;
    Blocks2: TMenuItem;
    N10: TMenuItem;
    Group1: TMenuItem;
    AddStudent1: TMenuItem;
    ChangeStudent1: TMenuItem;
    DeleteStudent1: TMenuItem;
    CommonData1: TMenuItem;
    ClearChoices1: TMenuItem;
    N11: TMenuItem;
    Promote1: TMenuItem;
    Configure1: TMenuItem;
    Timetable3: TMenuItem;
    Years1: TMenuItem;
    Days1: TMenuItem;
    TimeSlots1: TMenuItem;
    Levels1: TMenuItem;
    Custom1: TMenuItem;
    Clear1: TMenuItem;
    New1: TMenuItem;
    opencustomfile1: TMenuItem;
    Editcustomfile1: TMenuItem;
    Savecustomfile1: TMenuItem;
    BySubject1: TMenuItem;
    ByTimeslot1: TMenuItem;
    ClashMatrix1: TMenuItem;
    StudentInput1: TMenuItem;
    BlockClashes1: TMenuItem;
    TeacherClashes1: TMenuItem;
    RoomClashes1: TMenuItem;
    TeacherFree1: TMenuItem;
    RoomsFree1: TMenuItem;
    TeacherTimes1: TMenuItem;
    SubjectTimes1: TMenuItem;
    PopupMenu1: TPopupMenu;
    All22: TMenuItem;
    LoadYear2: TMenuItem;
    LoadYear3: TMenuItem;
    Version1: TMenuItem;
    GroupofTeachers1: TMenuItem;
    Margins1: TMenuItem;
    Size1: TMenuItem;
    mniStudentN2: TMenuItem;
    Panel5: TPanel;
    N13: TMenuItem;
    N14: TMenuItem;
    Selection1: TMenuItem;
    Textfilein1: TMenuItem;
    ExportasTextfile1: TMenuItem;
    Reloadstudentdata1: TMenuItem;
    Select2: TMenuItem;
    Sort1: TMenuItem;
    N15: TMenuItem;
    grp01: TMenuItem;
    grp11: TMenuItem;
    grp21: TMenuItem;
    grp31: TMenuItem;
    grp41: TMenuItem;
    grp51: TMenuItem;
    grp61: TMenuItem;
    grp71: TMenuItem;
    grp81: TMenuItem;
    grp91: TMenuItem;
    N16: TMenuItem;
    grp02: TMenuItem;
    grp12: TMenuItem;
    grp22: TMenuItem;
    grp32: TMenuItem;
    grp42: TMenuItem;
    grp52: TMenuItem;
    grp62: TMenuItem;
    grp72: TMenuItem;
    grp82: TMenuItem;
    grp92: TMenuItem;
    N17: TMenuItem;
    GoSurfing1: TMenuItem;
    Hintsandtips1: TMenuItem;
    N18: TMenuItem;
    CreateBackup1: TMenuItem;
    RestorefromBackup1: TMenuItem;
    Panel4: TPanel;
    Panel6: TPanel;
    Blocks3: TMenuItem;
    Toolbars1: TMenuItem;
    General1: TMenuItem;
    Timetable4: TMenuItem;
    Blocking1: TMenuItem;
    PrintDialog: TPrintDialog;
    grp101: TMenuItem;
    grp111: TMenuItem;
    grp121: TMenuItem;
    grp131: TMenuItem;
    grp141: TMenuItem;
    grp151: TMenuItem;
    grp102: TMenuItem;
    grp112: TMenuItem;
    grp122: TMenuItem;
    grp132: TMenuItem;
    grp142: TMenuItem;
    grp152: TMenuItem;
    Transfer1: TMenuItem;
    Transfer3: TMenuItem;
    Transfer2: TMenuItem;
    mniFileCASES21: TMenuItem;
    ActionManager1: TActionManager;
    ActionImages: TImageList;
    DoPrintPreview: TAction;
    PrintPreview1: TMenuItem;
    MainPrint: TAction;
    CopyWin: TAction;
    FilePrintSetup1: TFilePrintSetup;
    OpenSuWnd: TAction;
    OpenTeWnd: TAction;
    OpenRoWnd: TAction;
    OpenRollWnd: TAction;
    OpenFacWnd: TAction;
    OpenHouseWnd: TAction;
    OpenTimesWnd: TAction;
    NextView: TAction;
    SetFont: TAction;
    Prefs: TAction;
    SelectDlg: TAction;
    Edit1: TMenuItem;
    Copy1: TMenuItem;
    NewData: TAction;
    TtSave: TAction;
    ShowInfoWin: TAction;
    ShowBlocksWin: TAction;
    ShowSubjectList: TAction;
    ShowTimetable: TAction;
    ShowStudList: TAction;
    ShowStudTt: TAction;
    ShowTeachTt: TAction;
    ShowRoomTt: TAction;
    ShowSubTt: TAction;
    CascadeWins: TAction;
    TtBuild: TAction;
    TeacherList1: TMenuItem;
    StudFree1: TMenuItem;
    StudentClashes1: TMenuItem;
    NextView1: TMenuItem;
    User1: TMenuItem;
    Info2: TMenuItem;
    Changepassword1: TMenuItem;
    Logonasadifferentuser1: TMenuItem;
    N22: TMenuItem;
    Showusers1: TMenuItem;
    Adduser1: TMenuItem;
    Edituser1: TMenuItem;
    Deleteuser1: TMenuItem;
    N23: TMenuItem;
    Autoloadtime1: TMenuItem;
    Savedefaultdisplaysettings1: TMenuItem;
    Setcurrentdatadirectoryasdefault1: TMenuItem;
    Timer1: TTimer;
    TransferStud: TMenuItem;
    InUse2: TMenuItem;
    CustomA1: TMenuItem;
    SaveDisplay1: TMenuItem;
    OpenDisplay1: TMenuItem;
    N19: TMenuItem;
    Timer2: TTimer;
    Worksheet1: TMenuItem;
    Worksheet2: TMenuItem;
    Worksheet3: TMenuItem;
    ShowWorksheet: TAction;
    HelpRouter1: THelpRouter;
    WhatsThis1: TWhatsThis;
    stbTimeChart: TStatusBar;
    mniFileImportFamilyList: TMenuItem;
    StudentInput2: TMenuItem;
    MnuTools: TMenuItem;
    mniToolsImportSubjects: TMenuItem;
    mniFileCases21Export: TMenuItem;
    mniFileCASES21Import: TMenuItem;
    mniStudentN3: TMenuItem;
    mniStudentHealth: TMenuItem;
    grp161: TMenuItem;
    grp171: TMenuItem;
    grp181: TMenuItem;
    grp191: TMenuItem;
    grp162: TMenuItem;
    grp172: TMenuItem;
    grp182: TMenuItem;
    grp192: TMenuItem;
    mniFileCloseAll: TMenuItem;
    mniHelpSystem: TMenuItem;
    mniHElpSysytemPackUpData: TMenuItem;
    mniUserClearUserAccessLocks: TMenuItem;
    mniFileCASES21ViewExportData: TMenuItem;
    mniFileRemoveTimetable: TMenuItem;
    mniFileBackupRestoreData: TMenuItem;
    mniFileVASS: TMenuItem;
    mniFileVASSStudentChoicesExport: TMenuItem;
    mniFileVASSStudentExport: TMenuItem;
    mnuTrackEnrolments1: TMenuItem;
    mnuWebTC: TMenuItem;
    StudentChoices1: TMenuItem;
    WebTCSCExport: TMenuItem;
    Import1: TMenuItem;
    Action1: TAction;
    FilePrintSetup2: TAction;
    CheckforUpdates1: TMenuItem;
    ActionImagesNew: TImageList;
    ListTagNames1: TMenuItem;
    DataExport1: TMenuItem;
    ASSExport1: TMenuItem;
    SynergeticExport1: TMenuItem;

    procedure FormCreate(Sender: TObject);

    procedure ShowHint(Sender: TObject);
    procedure FileOpen(Sender: TObject);
    procedure FilePrintSetup(Sender: TObject);
    procedure FileExit(Sender: TObject);
    procedure WindowTile(Sender: TObject);
    procedure WindowArrange(Sender: TObject);
    procedure HelpContents(Sender: TObject);
    procedure HelpAbout(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TileVertical1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FileMenuClick(Sender: TObject);
    procedure AddStudent1Click(Sender: TObject);
    procedure ChangeStudent1Click(Sender: TObject);
    procedure DeleteStudent1Click(Sender: TObject);
    procedure YearSubjects1Click(Sender: TObject);
    procedure Years1Click(Sender: TObject);
    procedure Days1Click(Sender: TObject);
    procedure TimeSlots1Click(Sender: TObject);
    procedure WindowMenuClick(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure Timetable2Click(Sender: TObject);
    procedure Student1Click(Sender: TObject);
    procedure ByTimeslot1Click(Sender: TObject);
    procedure SaveAsClick(Sender: TObject);
    procedure ReverttoSaved1Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure opencustomfile1Click(Sender: TObject);
    procedure CommonData1Click(Sender: TObject);
    procedure ClearChoices1Click(Sender: TObject);
    procedure ClashHelp1Click(Sender: TObject);
    procedure BlockClashes1Click(Sender: TObject);
    procedure TeacherClashes1Click(Sender: TObject);
    procedure RoomClashes1Click(Sender: TObject);
    procedure TeacherFree1Click(Sender: TObject);
    procedure RoomsFree1Click(Sender: TObject);
    procedure TeacherTimes1Click(Sender: TObject);
    procedure SubjectTimes1Click(Sender: TObject);
    procedure GroupofTeachers1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure ClashMatrix1Click(Sender: TObject);
    procedure Version1Click(Sender: TObject);
    procedure Levels1Click(Sender: TObject);
    procedure Margins1Click(Sender: TObject);
    procedure Student2Click(Sender: TObject);
    procedure Teacher3Click(Sender: TObject);
    procedure Room3Click(Sender: TObject);
    procedure Editcustomfile1Click(Sender: TObject);
    procedure Savecustomfile1Click(Sender: TObject);
    procedure Custom1Click(Sender: TObject);
    procedure DisplayStudentInput(Sender: TObject);
    procedure Promote1Click(Sender: TObject);
    procedure Size1Click(Sender: TObject);
    procedure DisplayClick(Sender: TObject);
    procedure Textfilein1Click(Sender: TObject);
    procedure ExportasTextfile1Click(Sender: TObject);
    procedure Reloadstudentdata1Click(Sender: TObject);
    procedure Select2Click(Sender: TObject);
    procedure Sort1Click(Sender: TObject);
    procedure All22Click(Sender: TObject);
    procedure grp02Click(Sender: TObject);
    procedure GoSurfing1Click(Sender: TObject);
    procedure Hintsandtips1Click(Sender: TObject);
    procedure CreateBackup1Click(Sender: TObject);
    procedure RestorefromBackup1Click(Sender: TObject);
    procedure Blocks3Click(Sender: TObject);
    procedure Panel6DockOver(Sender: TObject; Source: TDragDockObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
    procedure Toolbars1Click(Sender: TObject);
    procedure General1Click(Sender: TObject);
    procedure Timetable4Click(Sender: TObject);
    procedure Blocking1Click(Sender: TObject);
    procedure Panel4DockDrop(Sender: TObject; Source: TDragDockObject; X,
      Y: Integer);
    procedure Panel6DockDrop(Sender: TObject; Source: TDragDockObject; X,
      Y: Integer);
    procedure Panel4DockOver(Sender: TObject; Source: TDragDockObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
    procedure Transfer1Click(Sender: TObject);
    procedure Transfer2Click(Sender: TObject);
    procedure ExportCASES21Data(Sender: TObject);
    procedure ImportCASES21Data(Sender: TObject);
    procedure DoPrintPreviewExecute(Sender: TObject);
    procedure MainPrintExecute(Sender: TObject);
    procedure MainPrintUpdate(Sender: TObject);
    procedure DoPrintPreviewUpdate(Sender: TObject);
    procedure CopyWinExecute(Sender: TObject);
    procedure CopyWinUpdate(Sender: TObject);
    procedure OpenSuWndExecute(Sender: TObject);
    procedure OpenTeWndExecute(Sender: TObject);
    procedure OpenRoWndExecute(Sender: TObject);
    procedure OpenRollWndExecute(Sender: TObject);
    procedure OpenFacWndExecute(Sender: TObject);
    procedure OpenHouseWndExecute(Sender: TObject);
    procedure OpenTimesWndExecute(Sender: TObject);
    procedure NextViewExecute(Sender: TObject);
    procedure NextViewUpdate(Sender: TObject);
    procedure SetFontExecute(Sender: TObject);
    procedure PrefsExecute(Sender: TObject);
    procedure SelectDlgExecute(Sender: TObject);
    procedure NewDataExecute(Sender: TObject);
    procedure TtSaveExecute(Sender: TObject);
    procedure ShowInfoWinExecute(Sender: TObject);
    procedure ShowBlocksWinExecute(Sender: TObject);
    procedure ShowSubjectListExecute(Sender: TObject);
    procedure ShowTimetableExecute(Sender: TObject);
    procedure ShowStudListExecute(Sender: TObject);
    procedure ShowStudTtExecute(Sender: TObject);
    procedure ShowTeachTtExecute(Sender: TObject);
    procedure ShowRoomTtExecute(Sender: TObject);
    procedure ShowSubTtExecute(Sender: TObject);
    procedure CascadeWinsExecute(Sender: TObject);
    procedure TeacherList1Click(Sender: TObject);
    procedure StudentClashes1Click(Sender: TObject);
    procedure StudFree1Click(Sender: TObject);
    procedure Info2Click(Sender: TObject);
    procedure Changepassword1Click(Sender: TObject);
    procedure Logonasadifferentuser1Click(Sender: TObject);
    procedure Showusers1Click(Sender: TObject);
    procedure Adduser1Click(Sender: TObject);
    procedure Edituser1Click(Sender: TObject);
    procedure Deleteuser1Click(Sender: TObject);
    procedure Autoloadtime1Click(Sender: TObject);
    procedure Setcurrentdatadirectoryasdefault1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure User1Click(Sender: TObject);
    procedure Savedefaultdisplaysettings1Click(Sender: TObject);
    procedure Transfer3Click(Sender: TObject);
    procedure TransferStudClick(Sender: TObject);
    procedure InUse2Click(Sender: TObject);
    procedure WebUpdate1Click(Sender: TObject);
    procedure CustomA1Click(Sender: TObject);
    procedure OpenDisplay1Click(Sender: TObject);
    procedure SaveDisplay1Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure TagSelect1Click(Sender: TObject);
    procedure Worksheet2Click(Sender: TObject);
    procedure ShowWorksheetExecute(Sender: TObject);
    procedure ImportFamilyList(Sender: TObject);
    procedure CheckForUpdates(Sender: TObject);
    procedure ImportSubjects(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    //procedure FormDblClick(Sender: TObject);
    procedure DisplayHealthConditions(Sender: TObject);
    procedure CloseAllWindows(Sender: TObject);
    procedure DisplaySplitSubjectConversion(Sender: TObject);
    procedure ArchiveData(Sender: TObject);
    procedure ClearUserAccessLocks(Sender: TObject);
    procedure ViewCASES21ExportData(Sender: TObject);
    procedure DisplayRemoveTimetable(Sender: TObject);
    procedure ExportVASSStudent(Sender: TObject);
    procedure ExportVASSStudentChoices(Sender: TObject);
//    procedure ConvertTo7(Sender: TObject);
    procedure TASSExport1Click(Sender: TObject);
    procedure mnuTrackEnrolments1Click(Sender: TObject);
    procedure WebTCSCExportClick(Sender: TObject);
    procedure FilePrintSetup1PrinterSetupDialogClose(Sender: TObject);
    procedure Import1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ListTagNames1Click(Sender: TObject);
    procedure SynergeticExport1Click(Sender: TObject);
  private
    function RefreshTtableToolbar: Boolean;
  public
    function GetCustomFile: Boolean;
    procedure SetupUserMenus;
  end;

var
  MainForm: TMainForm;

implementation

uses
  tcommon,TCload,shellapi,TcInfo,prefer,CodeView,addstud,edstud,delstud,
  groupsel,subyr,cnfgyear,cnfgday,ttsize,ttable,subbsdlg,block1,
  subbysub,subbyslt,studlist,studttab,stuttdlg,ttvers,Cnfglev,margins,
  fndtedlg,fndrodlg,fndstdlg,promodlg,tcommon2,bckupdlg,stcommon, Tagdlg,
  {below only added for popup2}
  teachtt,roomtt,subjcttt,cnfgblck,clashhlp,blkclash,teclash,roclash, tefree,rofree,
  tetimes,subtimes,grpofte,clmatrix,clmatsel,edcustom, stinput,stindlg,clipbrd,
  sortgrp,hints,InUse,tttoolbarwin, gentool, blcktool,PrintPreviewForm,SuWnd,TeWnd,
  RoWnd,RollClassWnd,FacWnd, HouseWnd, TimesWnd,TeList,tcommon5,Edpasswd,Adduser,
  Eduser, Deluser, Autoload,Entry,Search, Delyrsub,Movesub,CustomOutput,EditTime,
  Showuser, wsToolbarwin, Worksheet, uAMGFamily, WebUpdate, ImportCases21, uAMGTeacher,
  uAMGClassSubject, Student, OLE2, uAMGHealthCondition, HealthCondition, OpenFile,
  uAMGConst, uAMGSubject, CASES21ImportOptions, SplitSubjectsConvertor, uAMGCommon,
  AbZipper, LoadProgress, ExportToTASS, ExportToCASES21, CASES21ExportDataView, RemoveTimetable,
  VASSStudentExport, VASSStudentChoicesExport, Teacher, MRUList,
  {ZConnection,} WebTC, ListTagNames, SynergeticExport;

var
 i: integer;
 dbgStr: string;


{$R *.DFM}
//{$R vistaAdm.RES}

procedure TMainForm.FormCreate(Sender: TObject);
var
  AConvertMenuItem : TMenuItem;
  i : Integer;
begin
  for i := 1to ParamCount do
    if paramstr(i) = '/DevMode' then
      JimsDevMode := true;

  randomize;
  XML_USERS:= TXML_USERS.create(USER_PASSWORD_XML_FILE);
  Application.OnHint := ShowHint;
  HelpContext:=1;
  mainform.caption:=mainform.caption+' - '+school;
  application.hintcolor:=clAqua;
  {init panels}
  self.windowstate:=wsMaximized;
  updateCustomMenus;
  //mniHelpCheckForUpdates.Visible := False;
  CheckForUpdates1.Visible := False;
  mniHelpSystem.Visible := False;
  Teachers := TAMGTeachers.Create;
  ClassSubjects := TAMGClassSubjects.Create;
  PendingClassSubjects := TAMGClassSubjects.Create;
  FamilyClashes := TAMGFamilyClashes.Create;
  Students := TAMGStudents.Create;
  Parents := TAMGParents.Create;
  HealthConditions := TAMGHealthConditions.Create;
  StudentHealthConditions := TAMGStudentHealthConditions.Create;
  Tags := TAMGTags.Create;
  Subjects := TAMGSubjects.Create;
  FMRU := TMRUList.Create;
  FMRU.MaxItems := 3;

{$IFDEF Debug}
//  AConvertMenuItem := TMenuItem.Create(MainMenu);
//  AConvertMenuItem.Caption := 'Convert to V7';
//  AConvertMenuItem.Name := 'mainmenuconvert7';
//  AConvertMenuItem.OnClick := ConvertTo7;
//  MainMenu.Items.Add(AConvertMenuItem);

  mnuWebTC.Visible := true;
{$ENDIF}

// #994
  if (usrPassLevel <> utTime) and (usrPassLevel <> utSuper) then
  begin
    InUse2.Enabled := false;
  end;
end;

//procedure TMainForm.FormDblClick(Sender: TObject);
//var
//  lFrmTeacher: TFrmTeacher;
//begin
{  lFrmTeacher := TFrmTeacher.Create(Application);
  try
    lFrmTeacher.ShowModal;
  finally
    FreeAndnil(lFrmTeacher);
  end;
}
{
var
  lFrmStudent: TFrmStudent;
begin
  lFrmStudent := TFrmStudent.Create(Application);
  try
    lFrmStudent.ShowModal;
  finally
    FreeAndnil(lFrmStudent);
  end;}
//end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  if Assigned(Teachers) then
    FreeAndNil(Teachers);
  if Assigned(ClassSubjects) then
    FreeAndNil(ClassSubjects);
  if Assigned(PendingClassSubjects) then
    FreeAndNil(PendingClassSubjects);
  if Assigned(FamilyClashes) then
    FreeAndNil(FamilyClashes);
  if Assigned(Students) then
    FreeAndNil(Students);
  if Assigned(Parents) then
    FreeAndNil(Parents);
  if Assigned(HealthConditions) then
    FreeAndNil(HealthConditions);
  if Assigned(StudentHealthConditions) then
    FreeAndNil(StudentHealthConditions);
  if Assigned(Tags) then
    FreeAndNil(Tags);
  if Assigned(Subjects) then
    FreeAndNil(Subjects);
  if Assigned(FMRU) then
    FreeAndNil(FMRU);
  XML_USERS.Free;
end;

procedure TMainForm.ShowHint(Sender: TObject);
var _DataDirText: string;
    _DataDirTextWidth: integer;
begin
  if Trim(Application.Hint) = '' then // Manits #1493
  begin
    _DataDirText := 'Current data directory is: ' + Directories.datadir+'  ';

    _DataDirTextWidth := getTextWidthOnLabel(_DataDirText,mainform.stbTimeChart.Font);
    if _DataDirTextWidth > stbTimeChart.Panels[0].Width then
      _DataDirText := 'Data directory is: ' + Directories.datadir+'  ';

    _DataDirTextWidth := getTextWidthOnLabel(_DataDirText,mainform.stbTimeChart.Font);
    if _DataDirTextWidth > stbTimeChart.Panels[0].Width then
      _DataDirText := 'Data directory: ' + Directories.datadir+'  ';

    _DataDirTextWidth := getTextWidthOnLabel(_DataDirText,mainform.stbTimeChart.Font);
    if _DataDirTextWidth > stbTimeChart.Panels[0].Width then
      _DataDirText := 'Data: ' + Directories.datadir+'  ';

    _DataDirTextWidth := getTextWidthOnLabel(_DataDirText,mainform.stbTimeChart.Font);
    if _DataDirTextWidth > stbTimeChart.Panels[0].Width then
      stbTimeChart.Panels[0].Alignment:= taRightJustify
    else
      stbTimeChart.Panels[0].Alignment:= taLeftJustify;
    stbTimeChart.Panels[0].Text := _DataDirText;
  end
  else
  begin
    stbTimeChart.Panels[0].Alignment:= taLeftJustify;
    stbTimeChart.Panels[0].Text := Application.Hint;
  end;
end;

procedure TMainForm.FileOpen(Sender: TObject);
var
  tmpStr,tmpExt:  string;
  oldttfile:        string;
  msg:     string;
  //lFrmOpenFile: TFrmOpenFile;
  //lTTFileName: string;
begin
 oldttfile:=FileNames.LoadedTimeTable;
 if SaveTTCancel then exit;
 OpenDialog.Title:='Load Timetable';
 OpenDialog.HelpContext:=3;
 OpenDialog.Filter:='Timetable|*'+XMLHelper.getTTW_EXTENSION('',JustTheExtension);
 OpenDialog.InitialDir:=Directories.datadir;
 OpenDialog.filename:='';
 OpenDialog.defaultext:='ttw';
 OpenDialog.options:=[ofFileMustExist,ofHideReadOnly,ofPathMustExist];
  {lFrmOpenFile := TFrmOpenFile.Create(Application);
  try
    lFrmOpenFile.Title := 'Load Timetable';
    lFrmOpenFile.FileType := AMG_TIMATABLE;
    lFrmOpenFile.InitialDir := DataDir;
    lFrmOpenFile.ShowModal;
    lTTFileName := lFrmOpenFile.SelectedFile
  finally
    FreeAndNil(lFrmOpenFile);
  end;}


 if OpenDialog.Execute then
  if FileExists(OpenDialog.Filename) then
  begin
    tmpExt:=ExtractFileExt(OpenDialog.Filename);   //lTTFileName
    tmpext:=uppercase(trim(tmpext));
    if ((tmpExt<>XMLHelper.getTTW_EXTENSION('',JustTheExtension)) and (tmpExt<>'.TT')) then
    begin
      msg:='The file '+endline+'<'+ opendialog.filename + '>'+endline+' is NOT a ';    //lTTFileName
      msg:=msg+'TimeChart Timetable file.';
      messagedlg(msg,mtError,[mbOK],0);
      exit;
    end;

    UseNewTTWTimetable:=not(tmpext='.TT');
    tmpStr:=ExtractFileName(OpenDialog.Filename);     //lTTFileName
    FileNames.LoadedTimeTable:=RemoveExtension(tmpStr);
    tmpStr:= OpenDialog.Filename;    //lTTFileName;
    Directories.timedir:=GetDirName(tmpStr);
    getTTable; CheckClassOnTt;
    alterTimeFlag:=True;  AlterWSflag:=True;
    SetTimeCell;
    SetDays;
    updateStatusPanel;
    if wnFlag[wnTtable]=false then TtableWinSelect else Ttablewin.InitTTWin;
    if wnFlag[wnWorksheet] then Worksheetwin.InitWSwin;

    UpdateTimeTableWins;
    UpdateWindow(wnInfo);  UpdateWindow(wnTimes);
    if (usrPassLevel<>utTime) and (usrPassLevel<>utSuper) then
    begin
      if (usrPassLevel<>utGen) then LogMeOn;
      exit; {no need to check for access}
    end;
    tmpStr:=FileNames.LoadedTimeTable;
    FileNames.LoadedTimeTable:=oldttfile;
    if not(fEntryDlgUp or fSearchReplaceDlgUp) then CheckAccessRights(utTime,16,false);
    if ttAccess and (fEntryDlgUp or fSearchReplaceDlgUp) and (FileNames.LoadedTimeTable<>tmpStr) then
    begin {close old tt file access and get new}
      CheckAccessRights(utTime,16,false);
      FileNames.LoadedTimeTable:=tmpStr;CheckAccessRights(utTime,16,true);
    end;
    FileNames.LoadedTimeTable:=tmpStr;
    LogMeOn;
   end;
end;

procedure TMainForm.FilePrintSetup(Sender: TObject);
begin
 if PrintSetupDialog.Execute then
 begin
    if (Printer.Orientation = poLandscape) then
    begin
      XML_DISPLAY.FIsLandscape := integer(True);
//      ShowMessAGE('Landscape');
    end else begin
      XML_DISPLAY.FIsLandscape := integer(false);
//      ShowMessage('Portrait');
    end;

 end;
end;

procedure TMainForm.FilePrintSetup1PrinterSetupDialogClose(Sender: TObject);
begin
 if (Printer.Orientation = poLandscape) then
 begin
   XML_DISPLAY.FIsLandscape := integer(True);
//   ShowMessAGE('Landscape');
 end else begin
   XML_DISPLAY.FIsLandscape := integer(false);
//   ShowMessage('Portrait');
 end;

end;

procedure TMainForm.FileExit(Sender: TObject);
begin
 Close;
end;

procedure TMainForm.WindowTile(Sender: TObject);
begin
 Tilemode:=tbHorizontal;
 Tile;
end;

procedure TMainForm.WindowArrange(Sender: TObject);
begin
 ArrangeIcons;
end;

procedure TMainForm.HelpContents(Sender: TObject);
begin
 HelpRouter1.HelpContent;
end;

procedure TMainForm.HelpAbout(Sender: TObject);
begin
 about.show;
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
 // #994
  if (usrPassLevel <> utTime) and (usrPassLevel <> utSuper) then
  begin
    InUse2.Enabled := false;
  end;

end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
 i,winCount:    integer;
 msg:  string;
 msgret:      word;
begin
 if XML_DISPLAY.OKquitcheck then
  begin
   msg:='Exit Time Chart.'+endline+endline;
   msg:=msg+'Are you sure you want to Quit ?';
   msgret:=messagedlg(msg,mtConfirmation,[mbYes,mbNo],0);
   if msgret=mrNo then
    begin
     action:=caNone; {don't allow close}
     exit;    {cancel quit as in mac}
    end;
  end;  {if OKquitcheck}
{check save flags first}
 if SaveBlocksCancel then
  begin
   action:=caNone; {don't allow close}
   exit;
  end;

 if SaveTTCancel then
  begin
   action:=caNone; {don't allow close}
   exit;
  end;

 removeDormantLocks;
 if usrPassBKUP then
  if XML_DISPLAY.OKbackup then
   begin
    backup_action:=1; {backup}
    BackupDataDlg:=TBackupDataDlg.create(self);   {allocate dlg}
    BackupDataDlg.showmodal;
    BackupDataDlg.free;
   end;

 if RollMarkerFlg then CheckRollMarkerExport;

{continue exit}
 try
  winCount:=mdiChildCount;
  screen.cursor:=crHourglass;
   try
    XML_DISPLAY.winOrderNum:=0;
    if winCount>0 then
     for i:=1 to winCount do
      begin
       inc(XML_DISPLAY.winOrderNum);
       XML_DISPLAY.winOrder[XML_DISPLAY.winOrderNum]:=ActiveMdiChild.tag;
       ActiveMdiChild.close;
       ActiveMdiChild.free;
      end;
    {check for floating toolbars}
    if fgGenToolbar then
     begin
      inc(XML_DISPLAY.winOrderNum);
      XML_DISPLAY.winOrder[XML_DISPLAY.winOrderNum]:=gentoolbarwin.tag;
      gentoolbarwin.close;
     end;
    saveWinDisplay;    {save settings and window pos's}
   finally
    screen.cursor:=crDefault;
   end; {try}

 except;
 end;
 LogMeOff(usrPassDir, UsrPassID);
end;

procedure TMainForm.TileVertical1Click(Sender: TObject);
begin
 Tilemode:=tbVertical;
 Tile;
end;

procedure TMainForm.Close1Click(Sender: TObject);
begin
 if mdiChildCount>0 then ActiveMdiChild.close;
end;

procedure TMainForm.CloseAllWindows(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to mdiChildCount -1 do
  begin
    Application.ProcessMessages;
    ActiveMdiChild.close;
  end;
end;

procedure TMainForm.FormResize(Sender: TObject);
var _TextWidth: integer;
begin
  try
    stbTimeChart.Panels[0].Width := Trunc(9 * (stbTimeChart.ClientWidth / 32));  //9
    stbTimeChart.Panels[1].Width := Trunc(8 * (stbTimeChart.ClientWidth / 32));  //14
    stbTimeChart.Panels[2].Width := Trunc(6 * (stbTimeChart.ClientWidth / 32));
    stbTimeChart.Panels[3].Width := stbTimeChart.ClientWidth - stbTimeChart.Panels[0].Width - stbTimeChart.Panels[1].Width - stbTimeChart.Panels[2].Width;
    updateStatusPanel;
  except;
  end;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
   // #994
  if (usrPassLevel <> utTime) and (usrPassLevel <> utSuper) then
  begin
    InUse2.Enabled := false;
  end;

end;

procedure TMainForm.FileMenuClick(Sender: TObject);
begin
  if mdiChildCount>0 then
  begin
    Close1.Enabled := True;
    mniFileCloseAll.Enabled := True;
    print1.Enabled := True;
    ExportasTextfile1.Enabled := True;
  end
  else
  begin
    Close1.Enabled := False;
    mniFileCloseAll.Enabled := False;
    print1.enabled := False;
    ExportasTextfile1.Enabled := False;
  end;
  mniFileRemoveTimetable.Enabled := GetTtableToRemove(Directories.DataDir);
end;

procedure TMainForm.AddStudent1Click(Sender: TObject);
begin
  if TooMany('students', XML_STUDENTS.numstud, nmbrStudents) then Exit;
  if CheckAccessRights(utStud, 35, True) then
  begin
    addstuddlg := Taddstuddlg.Create(Application);   {allocate dlg}
    addstuddlg.ShowModal;
    addstuddlg.Free;    {release dlg}
    CheckAccessRights(utStud, 35, False);
    About.RefreshStudents;
  end;
end;

procedure TMainForm.ChangeStudent1Click(Sender: TObject);
begin
 if NoStuds then Exit;
 if CheckAccessRights(utStud, 36, True) then
  begin
    edstuddlg := Tedstuddlg.Create(Application);   {allocate dlg}
    edstuddlg.finish.tag:=1; {changing stud}
    edstuddlg.showmodal;
    edstuddlg.free;   {release dlg}
    CheckAccessRights(utStud, 36, False);
    About.RefreshStudents;
  end;
end;

procedure TMainForm.CheckForUpdates(Sender: TObject);
begin
  //WebUpdateDlg := TWebUpdateDlg.Create(Application);
  //try
    //WebUpdateDlg.CheckForOnlineUpdate;
    //if not WebUpdateDlg.CurrentlyOnline then
    //  MessageDlg('Please make sure you are connected to the Internet and try again.', mtError, [mbOK], 0)
    //else if not WebUpdateDlg.IsUpdateAvailable then
      MessageDlg('Please check your online Support Plan account at www.timechart.com.au for available updates.', mtInformation, [mbOK], 0);
  //finally
  //  FreeAndNil(WebUpdateDlg);
  //end;
end;

procedure TMainForm.DeleteStudent1Click(Sender: TObject);
begin
  if NoStuds then Exit;
  if CheckAccessRights(utStud, 36, True) then
  begin
    delstuddlg := Tdelstuddlg.Create(Application);    {allocate dlg}
    delstuddlg.ShowModal;
    delstuddlg.free;   {release dlg}
    CheckAccessRights(utStud, 36, False);
    About.RefreshStudents;
  end;
end;

procedure TMainForm.YearSubjects1Click(Sender: TObject);
begin
 subyearwinSelect;
end;

procedure TMainForm.Years1Click(Sender: TObject);
begin
 if CheckAccessRights(utTime,16,true) then
  begin
   configyeardlg:=Tconfigyeardlg.create(self); {allocate dlg}
   configyeardlg.showmodal;
   configyeardlg.free;  {release dlg}
   if not(saveTimeFlag) then CheckAccessRights(utTime,16,false)
  end;
end;

procedure TMainForm.Days1Click(Sender: TObject);
begin
 if CheckAccessRights(utTime,16,true) then
  begin
   configDaydlg:=TconfigDaydlg.create(self); {allocate dlg}
   configDaydlg.showmodal;
   configDaydlg.free;  {release dlg}
   if not(saveTimeFlag) then CheckAccessRights(utTime,16,false)
  end;
end;

procedure TMainForm.TimeSlots1Click(Sender: TObject);
begin
 if CheckAccessRights(utTime,16,true) then
  begin
   AllotDlg:=TAllotDlg.create(self); {allocate dlg}
   AllotDlg.showmodal;
   AllotDlg.free;  {release dlg}
   if not(saveTimeFlag) then CheckAccessRights(utTime,16,false)
  end;
end;

procedure TMainForm.WindowMenuClick(Sender: TObject);
begin
 info1.checked:=wnFlag[wnInfo];
 TickCodeSubMenu(Codes1);
 yearSubjects1.checked:=wnFlag[wnGroupSub];
 blocks1.checked:=wnFlag[wnBlock];
 timetable1.checked:=wnFlag[wnTtable];
 worksheet3.Checked:=wnFlag[wnWorksheet];
 bySubject1.checked:=wnFlag[wnSubjectList];
 byTimeslot1.checked:=wnFlag[wnTimeList];
 studentlist1.checked:=wnFlag[wnStudentList];
 studenttimetable1.checked:=wnFlag[wnStudentTt];
 TeacherList1.Checked:=wnFlag[wnTeList];
 StudentClashes1.Checked:=wnFlag[wnStBlClash];
 StudFree1.Checked:=wnFlag[wnStFRee];
 teacher1.checked:=wnFlag[wnTeacherTt];
 room1.checked:=wnFlag[wnRoomTt];
 subject1.checked:=wnFlag[wnSubjectTt];
 clashhelp1.checked:=wnFlag[wnCHelp];
 blockclashes1.checked:=wnFlag[wnBlockClashes];
 teacherclashes1.checked:=wnFlag[wnTeClash];
 roomclashes1.checked:=wnFlag[wnRoClash];
 teacherfree1.checked:=wnFlag[wnTeFree];
 roomsfree1.checked:=wnFlag[wnRoFree];
 teachertimes1.checked:=wnFlag[wnTeTimes];
 subjecttimes1.checked:=wnFlag[wnSuTimes];
 groupofteachers1.checked:=wnFlag[wnGroupTe];
 clashmatrix1.checked:=wnFlag[wnCmatrix];
 studentinput1.checked:=wnFlag[wnStInput];
end;

procedure TMainForm.Clear1Click(Sender: TObject);
begin
 clearcustom;
end;

procedure TMainForm.Timetable2Click(Sender: TObject);
begin
 timetable3.checked:=wnFlag[wnTtable];
 worksheet1.Checked:=wnFlag[wnWorksheet];
end;

procedure TMainForm.Student1Click(Sender: TObject);
var
 HasStuds: boolean;
begin
 yearSubjects2.checked:=wnFlag[wnGroupSub];
 blocks2.checked:=wnFlag[wnBlock];
 HasStuds:=(XML_STUDENTS.numstud>0);
 group1.enabled:=HasStuds;
 changestudent1.enabled:=HasStuds;
 deletestudent1.enabled:=HasStuds;
 commondata1.enabled:=HasStuds;
 clearchoices1.enabled:=HasStuds;
// TagSelect1.Enabled:=HasStuds;
 if usrPassLevel=utGen then Textfilein1.enabled:=false;
end;

procedure TMainForm.ByTimeslot1Click(Sender: TObject);
begin
 SubjectbyTimeSlotwinSelect;
end;

procedure TMainForm.SaveAsClick(Sender: TObject);
var
 tmpStr,oldttfile:  string;
 oldaccess:    boolean;
begin         {set ttfile then call saveTTable as in save}
 if (usrPassLevel<>utTime) and (usrPassLevel<>utSuper) then
  begin
   showRestrictedMsg;  exit;
  end;

 if CheckAccessRights(utTime,16,true) then
  begin
   oldttfile:=FileNames.LoadedTimeTable;
   oldaccess:=ttaccess;
   SaveDialog.Title:='Save Timetable';
   SaveDialog.Options:=SaveDialog.Options+[ofNoChangeDir];
   SaveDialog.HelpContext:=6;
   SaveDialog.Filter:='Timetable|*'+XMLHelper.getTTW_EXTENSION('',JustTheExtension);
   SaveDialog.InitialDir:=Directories.datadir;
   SaveDialog.filename:=FileNames.LoadedTimeTable;
   SaveDialog.defaultext:='ttw';
   if SaveDialog.Execute then
   begin
     CheckForMouldyData(16);
     tmpStr:=ExtractFileName(SaveDialog.Filename);
     FileNames.LoadedTimeTable:=RemoveExtension(tmpStr);
     tmpStr:=SaveDialog.Filename;
     Directories.timedir:=Directories.datadir; {only save to data directory}
     if FileNames.LoadedTimeTable<>oldttfile then
      begin
       chdir(Directories.datadir);
       if fileexists(FileNames.LoadedTimeTable+XMLHelper.getTTW_EXTENSION('',JustTheExtension)) then
        begin
         if not CheckTTAccess(16,true) then
          begin FileNames.LoadedTimeTable:=oldttfile; exit; end;  {exit without saving, keep old access}
        end;
      end;
     saveTTable;
     SaveDialog.Options:=SaveDialog.Options-[ofNoChangeDir];
     if oldAccess and (FileNames.LoadedTimeTable<>oldttfile) then
      begin
       tmpStr:=FileNames.LoadedTimeTable;
       FileNames.LoadedTimeTable:=oldttfile;
       FileNames.LoadedTimeTable:=tmpStr;
      end;

     SetTTtitle;
     UpdateWindow(wnInfo);
     RefreshTtableToolbar;
     updateStatusPanel;
   end;
  end;
end;

procedure TMainForm.ReverttoSaved1Click(Sender: TObject);
begin
 if saveTimeFlag and (usrPassLevel>utGen) then
  begin {wasn't saved clear lock and flag}
   saveTimeFlag:=false;
   if ttAccess then CheckAccessRights(utTime,16,false);
  end;

 getTTable;
 SetTimeCell;
 SetDays;
 updateStatusPanel;
 UpdateTimeTableWins;
 UpdateWindow(wnInfo);
 UpdateWindow(wnTimes);
 if wnFlag[wnTtable]=false then TtableWinSelect else Ttablewin.InitTTWin;
end;

procedure editcustominformation;
begin
 EditCustomInfo:=TEditCustomInfo.create(application);   {allocate dlg}
 EditCustomInfo.showmodal;
 EditCustomInfo.free;               {release dlg}
end;

procedure TMainForm.New1Click(Sender: TObject);
begin
 if clearcustom then
  begin
   custom:=''; {no name}
   UpdateWindow(wnInfo);
   editcustominformation
  end;
end;

function TMainForm.GetCustomFile:boolean;
var
 s    : string;
 fname: string;
begin
 result:=false;
 opendialog.title:='Load Custom Information';
 opendialog.HelpContext:=22;
 opendialog.defaultext:='CUS';
 opendialog.filename:= custom;
 opendialog.filter:='Custom Files | *.CUS';
 opendialog.initialdir:= Directories.datadir;
 if opendialog.execute then
  begin
   fname:=opendialog.filename;
   s:=Extractfilename(fname);
   custom:=RemoveExtension(s);
   ReadCustom;
   UpdateWindow(wnInfo);
   result:=true;
  end; {if execute}
end;

procedure TMainForm.opencustomfile1Click(Sender: TObject);
begin
 if GetCustomFile then editcustominformation;
end;

procedure TMainForm.CommonData1Click(Sender: TObject);
begin
 if NoStuds then exit;
 if CheckAccessRights(utStud,36,true) then
  begin
   edstuddlg:=tedstuddlg.create(self);   {allocate dlg}
   edstuddlg.finish.tag:=2; {common dat to stud}
   edstuddlg.showmodal;
   edstuddlg.free;   {release dlg}
   CheckAccessRights(utStud,36,false)
  end;
end;

{
procedure TMainForm.ConvertTo7(Sender: TObject);
var
  FBConnection : TZConnection;
  FBTable: TZTable;
  FBHealth: TZTable;
  FBSequence : TZSequence;
  i,j:integer;
  HC : TAMGHealthConditions;
  SH : TAMGStudentHealthConditions;
  SHC: TAMGStudentHealthCondition;
  FBHLookup : TZTable;
  TT_ID: integer;
  TTDG_ID: integer;
  FndDayGroup: array [0..20] of boolean;
  p: Integer;
  l: Integer;
  d: integer;
  y: integer;
  IntPoint:      tpIntPoint;
  su,te,ro:       smallint;
  X7DG:  array[0..100] of integer;
  X7DAY: array[0..100] of integer;
  X7TS:  array[0..100,0..100] of integer;
  X7YR:  array[0..100] of integer;
  X7TSDG:array[0..100] of integer;
  WSStream: TStream;
  wstNum,wstDays: smallint;
begin
  FBConnection := TZConnection.Create(self);
  FBConnection.HostName := '127.0.0.1';
  FBConnection.User := 'amig';
  FBConnection.Password := 'amig';
  FBConnection.Protocol := 'firebird-2.1';
  FBConnection.Database := 'C:\AMIG7\Data\amig.fdb';
  //FBConnection.Protocol := 'mssql';
  //FBConnection.Database := 'C:\AMIG7\Data\amig.fdb';
  FBConnection.Connect;

  FBTable := TZTable.Create(self);
  FBTable.Connection := FBConnection;

  FBSequence := TZSequence.Create(self);
  FBSequence.Connection := FBConnection;

//
//  // Faculty
//  FBTable.TableName := 'Faculty';
//  FBTable.Active := true;
//  while not(FBTable.Eof) do
//  begin
//    FBTable.Delete;
//  end;
//  for i:= 1 to FacNum do
//  begin
//    FBTable.Insert;
//    FBTable.FieldByName('Id').AsInteger := i;
//    FBTable.FieldByName('Name').AsString := facName[i];
//    FBTable.Post;
//  end;
//  FBTable.Active := false;
//
//  // Duty
//  FBTable.Tablename := 'Duty';
//  FBTable.Active := true;
//  while not(FBTable.Eof) do
//  begin
//    FBTable.Delete;
//  end;
//  for i:= 1  to NumCodes[1] do
//  begin
//    for j:=  0 to 2 do
//    begin
//      if DutyCode[i,j] <> '' then
//      begin
//        FBTable.Insert;
//        FBTable.FieldByName('id').AsString := DutyCode[i,j];
//        try
//          FBtable.Post;
//        except
//          FBTable.Cancel;
//        end;
//      end;
//    end;
//  end;
//  FBTable.Active := false;
//
//  // Teacher
//  FBTable.TableName := 'Teacher';
//  FBTable.Active := true;
//  while not(FBTable.Eof) do
//  begin
//    FBTable.Delete;
//  end;
//  for i:= 1 to NumCodes[1] do
//  begin
//    if (copy(tecode[i,0],1,2)<>'00') then
//    begin
//      FBTable.Insert;
//      FBTable.FieldByName('Id').AsInteger := i;
//      FBTable.FieldByName('Code').AsString := tecode[i,0];
//      FBTable.FieldByName('Name').AsString := tename[i,0];
//      FBTable.FieldByName('IsTeacher').AsString := 'T';
//      FBTable.Post;
//    end;
//  end;
//  FBTable.Active := false;
//
//  // Teacher_Faculty
//  FBTable.TableName := 'Teacher_Faculty';
//  FBTable.Active := true;
//  while not(FBTable.Eof) do
//  begin
//    FBTable.Delete;
//  end;
//  for i:= 1 to NumCodes[1] do
//  begin
//    if (copy(tecode[i,0],1,2)<>'00') then
//    begin
//      for j:=  1 to 4 do
//      begin
//        if tFaculty[i,j] > 0 then
//        begin
//          FBTable.Insert;
//          FBTable.FieldByName('Teacher_Id').AsInteger := i;
//          FBTable.FieldByName('Faculty_Id').AsInteger := tFaculty[i,j];
//          FBTable.Post;
//        end;
//      end;
//    end;
//  end;
//  FBTable.Active := false;
//
//  // Teacher_Duty
//  FBTable.TableName := 'Teacher_Duty';
//  FBTable.Active := true;
//  while not(FBTable.Eof) do
//  begin
//    FBTable.Delete;
//  end;
//  for i:= 1 to NumCodes[1] do
//  begin
//    if (copy(tecode[i,0],1,2)<>'00') then
//    begin
//      for j:=  0 to 2 do
//      begin
//        if DutyCode[i,j] <> '' then
//        begin
//          FBTable.Insert;
//          FBTable.FieldByName('Teacher_Id').AsInteger := i;
//          FBTable.FieldByName('Duty_Id').AsString := DutyCode[i,j];
//          FBTable.FieldByName('Load').AsFloat := DutyLoad[i,j];
//          FBTable.Post;
//        end;
//      end;
//    end;
//  end;
//  FBTable.Active := false;
//
//  // House
//  FBTable.TableName := 'House';
//  FBTable.Active := true;
//  while not(FBTable.Eof) do
//  begin
//    FBTable.Delete;
//  end;
//  for i:= 1 to housecount do
//  begin
//    FBTable.Insert;
//    FBTable.FieldByName('Id').AsInteger := i;
//    FBTable.FieldByName('Name').AsString := HouseName[i];
//    //FBTable.FieldByName('IsTeacher').AsString := 'T';
//    FBTable.Post;
//  end;
//  FBTable.Active := false;
//
//  // Roll Class
//  FBTable.TableName := 'RollClass';
//  FBTable.Active := true;
//  while not(FBTable.Eof) do
//  begin
//    FBTable.Delete;
//  end;
//  for i:= 1 to classnum do
//  begin
//    FBTable.Insert;
//    FBTable.FieldByName('Id').AsInteger := i;
//    FBTable.FieldByName('Name').AsString := ClassCode[i];
//    //FBTable.FieldByName('IsTeacher').AsString := 'T';
//    FBTable.Post;
//  end;
//  FBTable.Active := false;
//
//  // Room
//  FBTable.TableName := 'Room';
//  FBTable.Active := true;
//  while not(FBTable.Eof) do
//  begin
//    FBTable.Delete;
//  end;
//  for i:= 1 to NumCodes[2] do
//  begin
//    FBTable.Insert;
//    FBTable.FieldByName('Id').AsInteger := i;
//    FBTable.FieldByName('Code').AsString := tecode[i,1];
//    FBTable.FieldByName('Name').AsString := tename[i,1];
//    FBTable.FieldByName('Size').AsInteger := rosize[i];
//    FBTable.FieldByName('AssignType').AsInteger := rotype[i];
//    FBTable.FieldByName('Assign_Id').AsInteger := rassign[i];
//    FBTable.Post;
//  end;
//  FBTable.Active := false;
//
//  // Room_Faculty
//  FBTable.TableName := 'Room_Faculty';
//  FBTable.Active := true;
//  while not(FBTable.Eof) do
//  begin
//    FBTable.Delete;
//  end;
//  for i:= 1 to NumCodes[2] do
//  begin
//    //if (copy(tecode[i,0],1,2)<>'00') then
//    //begin
//      for j:=  1 to 3 do
//      begin
//        if RFaculty[i,j] > 0 then
//        begin
//          FBTable.Insert;
//          FBTable.FieldByName('Teacher_Id').AsInteger := i;
//          FBTable.FieldByName('Faculty_Id').AsInteger := rFaculty[i,j];
//          FBTable.Post;
//        end;
//      end;
//    //end;
//  end;
//  FBTable.Active := false;
//
//  // Subject
//  FBTable.TableName := 'Subject';
//  FBTable.Active := true;
//  while not(FBTable.Eof) do
//  begin
//    FBTable.Delete;
//  end;
//  for i:= 1 to NumCodes[0] do
//  begin
//    if (copy(subcode[i],1,2)<>'00') then
//    begin
//      FBTable.Insert;
//      FBTable.FieldByName('Id').AsInteger := i;
//      FBTable.FieldByName('Code').AsString := SubCode[i];
//      FBTable.FieldByName('Name').AsString := Subname[i];
//      FBTable.FieldByName('ReportCode').AsString := SubReportCode[i];
//      FBTable.FieldByName('ReportName').AsString := SubReportName[i];
//      FBTable.Post;
//    end;
//  end;
//  FBTable.Active := false;
//
//  // Student
//  FBTable.TableName := 'Student';
//  FBTable.Active := true;
//  while not(FBTable.Eof) do
//  begin
//    FBTable.Delete;
//  end;
//  for i:= 1 to numstud do
//  begin
//    //if (copy(subcode[i],1,2)<>'00') then
//    //begin
//      FBTable.Insert;
//      FBTable.FieldByName('Id').AsInteger := i;
//      FBTable.FieldByName('surname').AsString := stud[i].stname;
//      FBTable.FieldByName('firstname').AsString := stud[i].first;
//      FBTable.FieldByName('sex').AsString := stud[i].Sex;
//      FBTable.FieldByName('studentid').AsString := stud[i].ID;
//      FBTable.FieldByName('studentid2').AsString := studID2[i];
//      FBTable.FieldByName('rollclass_id').AsInteger := stud[i].tcClass;
//      FBTable.FieldByName('year_id').AsInteger := stud[i].TcYear;
//      FBTable.FieldByName('house_id').AsInteger := stud[i].House;
//      FBTable.FieldByName('tutor_id').AsInteger := stud[i].tutor;
//      FBTable.FieldByName('home_id').AsInteger := stud[i].home;
//      FBTable.FieldByName('HealthSupportPlan').AsInteger := 0;
//      FBTable.Post;
//    //end;
//  end;
//  FBTable.Active := false;
//
//  // Years
//  FBTable.TableName := 'Years';
//  FBTable.Active := true;
//  while not(FBTable.Eof) do
//  begin
//    FBTable.Delete;
//  end;
//  for i:= 0 to yr do
//  begin
//    //if (copy(subcode[i],1,2)<>'00') then
//    //begin
//      FBTable.Insert;
//      FBTable.FieldByName('Id').AsInteger := i;
//      FBTable.FieldByName('name').AsString := yearname[i];
//      FBTable.Post;
//    //end;
//  end;
//  FBTable.Active := false;
//
//  // Tags
//  FBTable.TableName := 'Tags';
//  FBTable.Active := true;
//  while not(FBTable.Eof) do
//  begin
//    FBTable.Delete;
//  end;
//  for i:= 1 to nmbrTags do
//  begin
//    //if (copy(subcode[i],1,2)<>'00') then
//    //begin
//      FBTable.Insert;
//      FBTable.FieldByName('Id').AsInteger := i;
//      FBTable.FieldByName('code').AsString := TagCode[i];//'Tag '+intTostr(i);
//      FBTable.FieldByName('name').AsString := TagName[i];//'Tag '+intTostr(i);
//      FBTable.Post;
//    //end;
//  end;
//  FBTable.Active := false;
//
//  // Student_Tags
//  FBTable.TableName := 'Student_Tags';
//  FBTable.Active := true;
//  while not(FBTable.Eof) do
//  begin
//    FBTable.Delete;
//  end;
//  for i:= 1 to numstud do
//  begin
//    for j:=1 to nmbrTags do
//    begin
//      if (bool((1 shl (j-1)) and Stud[i].tctag)) then
//      begin
//        FBTable.Insert;
//        FBTable.FieldByName('Student_Id').AsInteger := i;
//        FBTable.FieldByName('Tag_id').AsInteger := j;
//        FBTable.Post;
//      end;
//    end;
//  end;
//  FBTable.Active := false;
//
//  // Student_Choices
//  FBTable.TableName := 'Student_Choices';
//  FBTable.Active := true;
//  while not(FBTable.Eof) do
//  begin
//    FBTable.Delete;
//  end;
//  for i:= 1 to numstud do
//  begin
//    for j:=1 to nmbrChoices do
//    begin
//      if ((Stud[i].Choices[j]>0) and (Stud[i].Choices[j]<=numCodes[0])) then
//      begin
//        FBTable.Insert;
//        FBTable.FieldByName('Student_Id').AsInteger := i;
//        FBTable.FieldByName('Choice_id').AsInteger := Stud[i].Choices[j];
//        FBTable.Post;
//      end;
//    end;
//  end;
//  FBTable.Active := false;
//
//  // Health Conditions
//  FBTable.TableName := 'HealthCondition';
//  FBTable.Active := true;
//  while not(FBTable.Eof) do
//  begin
//    FBTable.Delete;
//  end;
//  HC := TAMGHealthConditions.Create;
//  HC.RefreshFromFile;
//  for i:= 0 to HC.Count -1 do
//  begin
//    //if (copy(subcode[i],1,2)<>'00') then
//    //begin
//      FBTable.Insert;
//      FBTable.FieldByName('Id').AsInteger := i;
//      FBTable.FieldByName('Code').AsString := TAMGHealthCondition(HC.Items[i]).Code;
//      FBTable.FieldByName('name').AsString := TAMGHealthCondition(HC.Items[i]).ConditionName;
//      FBTable.FieldByName('desc').AsString := TAMGHealthCondition(HC.Items[i]).ConditionDescription;
//      FBTable.FieldByName('web').AsString := TAMGHealthCondition(HC.Items[i]).ConditionWebURL;
//      FBTable.Post;
//    //end;
//  end;
//  FBTable.Active := false;
//  HC.Free;
//
//  // Student_Health
//  FBTable.TableName := 'Student';
//  FBTable.Active := true;
//  FBHealth := TZTable.Create(self);
//  FBHealth.Connection := FBConnection;
//  FBHealth.TableName := 'Student_Health';
//  FBHealth.Active := true;
//
//  FBHLookup := TZTable.Create(self);
//  FBHLookup.Connection := FBConnection;
//  FBHLookup.Tablename := 'HealthCondition';
//  FBHLookup.Active := true;
//
//  while not(FBHealth.Eof) do
//  begin
//    FBHealth.Delete;
//  end;
//  SH := TAMGStudentHealthConditions.Create;
//  SH.RefreshFromFile;
//  for j:=0 to SH.Count - 1 do
//  begin
//    SHC := TAMGStudentHealthCondition(SH.Items[j]);
//    if FBTable.Locate('StudentId',SHC.StudentCode,[]) then
//    begin
//      FBTable.Edit;
//      if SHC.HasHealthSupportPlan then
//      begin
//        FBTable.FieldByName('HealthSupportPlan').AsInteger := 1;
//      end else begin
//        FBTable.FieldByName('HealthSupportPlan').AsInteger := 0;
//      end;
//      FBTable.FieldByName('KeySupportPerson').AsString := SHC.KeySuportPerson;
//      FBTable.FieldByName('EmergencyContactName').AsString := SHC.EmergencyContact;
//      FBTable.FieldByName('EmergencyContactNumber').AsString := SHC.EmergencyContactNo;
//      FBTable.FieldByName('HealthInfoOther').AsString := SHC.OtherRelevantInfo;
//      FBTable.Post;
//
//      // Find This Health COndition by Code
//      if FBHLookup.Locate('Code',SHC.HealthConditionCode,[loCaseInsensitive]) then
//      begin
//        FBHealth.Insert;
//        FBHealth.FieldByName('Student_Id').AsInteger := FBTable.FieldByName('id').AsInteger;
//        FBHealth.FieldByName('Health_id').AsInteger := FBHLookup.FieldByName('id').AsInteger;
//        FBHealth.FieldByName('Notes').AsString := SHC.StudentHealthNote;
//        FBHealth.Post;
//      end;
//    end;
//  end;
//  FBTable.Active := false;
//  FBHealth.Active := false;

  // Timetable
  FBTable.TableName := 'Timetable';
  FBSequence.SequenceName := 'GEN_TIMETABLE_ID';
  FBtable.Sequence := FBSequence;
  FBTable.SequenceField := 'id';
  FBTable.Active := true;
  while not(FBTable.Eof) do
  begin
    FBTable.Delete;
  end;
  FBTable.Insert;
  //FBTable.FieldByName('Id').AsInteger := 1;
  FBTable.FieldByName('name').AsString := ttVersion;
  FBTable.FieldByName('timeslotunit').AsInteger := tslotunit;
  FBTable.FieldByName('yeartitle').AsString := yearTitle;
  FBTable.FieldByName('yearshort').AsString := yearShort;

  FBtable.FieldByName('days').AsInteger := days;
  FBTable.FieldByName('periods').AsInteger := periods;
  FBtable.FieldByname('years').AsInteger := years;
  FBTable.FieldByname('LevelMax').AsInteger := LevelMax;
  FBTable.FieldByname('dl').AsInteger := dl;
  FBTable.FieldByname('pl').AsInteger := pl;
  FBTable.FieldByname('yl').AsInteger := yl;
  FBTable.FieldByname('ll').AsInteger := ll;
  FBTable.FieldByname('hd').AsInteger := hd;
  FBTable.FieldByname('hp').AsInteger := hp;
  FBTable.FieldByname('hy').AsInteger := hy;
  FBTable.FieldByname('hl').AsInteger := hl;
  FBTable.FieldByname('nd').AsInteger := nd;
  FBTable.FieldByname('np').AsInteger := np;
  FBTable.FieldByname('ny').AsInteger := ny;
  FBTable.FieldByname('nl').AsInteger := nl;
  if (WSeWarn) then
  begin
    FBTable.FieldByname('wsewarn').AsInteger := 1;
  end else begin
    FBTable.FieldByname('wsewarn').AsInteger := 0;
  end;
  if (WSmWarn) then
  begin
    FBTable.FieldByname('wsmwarn').AsInteger := 1;
  end else begin
    FBTable.FieldByname('wsmwarn').AsInteger := 0;
  end;
  if (warn) then
  begin
    FBTable.FieldByname('warn').AsInteger := 1;
  end else begin
    FBTable.FieldByname('warn').AsInteger := 0;
  end;
  FBTable.FieldByname('arrow').AsInteger := arrow;
  FBTable.FieldByname('box').AsInteger := box;

  try
    WSStream := FBTable.CreateBlobStream(FBTable.FieldByName('ws') as TBlobField,bmwrite);
    WSStream.Write(wsMultNum,4);
    wsMainSize:=szWScell*years*(levelprint+2);
    for i:=0 to wsMultNum do
    begin
      WSStream.Write(wsOne[i],2);
      WSStream.Write(wsTwo[i],2);
      WSStream.Write(wsThree[i],2);
    end;

    wstNum:=years+nmbrWSTspecials-1; wstDays:=days-1;  //write targets
    WSStream.Write(wstNum,2);
    WSStream.Write(wstDays,2);
    for i:=-1 to wstNum do
      for j:=0 to wstDays do
      begin
        WSStream.Write(wstSingle[i,j],4);
        WSStream.Write(wstDouble[i,j],4);
        WSStream.Write(wstTriple[i,j],4);
      end;
    WSStream.Write(wsBlocks,2);  //write worksheet
    WSStream.Write(wsMainSize,2);
    for i:=1 to wsBlocks do
      WSStream.Write(WSMain[i][0],wsMainSize);
  finally
    WSStream.Free;
  end;

    FBTable.Post;
  TT_ID := FBTable.FieldByName('id').AsInteger;
  FBTable.Active := false;

  // TTDayGroup
  FBTable.TableName := 'TTDayGroup';
  FBSequence.SequenceName := 'GEN_TTDAYGROUP_ID';
  FBtable.Sequence := FBSequence;
  FBTable.SequenceField := 'id';
  FBTable.Active := true;
  while not(FBTable.Eof) do
  begin
    FBTable.Delete;
  end;
  for i:= 1 to numDayGroups do
  begin
    FBTable.Insert;
    //FBTable.FieldByName('Id').AsInteger := i;
    FBTable.FieldByName('name').AsString := 'Day Group '+IntToStr(i);
    FBTable.FieldByName('tt_id').AsInteger := TT_ID;
    FBTable.Post;
    X7DG[i] := FBTable.FieldByName('id').AsInteger;
  end;
  FBTable.Active := false;

  // TTDay
  FBTable.TableName := 'TTDay';
  FBSequence.SequenceName := 'GEN_TTDAY_ID';
  FBtable.Sequence := FBSequence;
  FBTable.SequenceField := 'id';
  FBTable.Active := true;
  while not(FBTable.Eof) do
  begin
    FBTable.Delete;
  end;
  for i:= 1 to days do
  begin
    FBTable.Insert;
    //FBTable.FieldByName('Id').AsInteger := i;
    FBTable.FieldByName('name').AsString := DayName[i-1];
    FBTable.FieldByName('ttdaygroup_id').AsInteger := X7DG[DayGroup[i-1]];
    FBTable.FieldByName('sortorder').AsInteger := i;
    FBTable.Post;
    X7DAY[i] := FBTable.FieldByName('id').AsInteger;
  end;
  FBTable.Active := false;

  // TTTimeslot
  FBTable.TableName := 'TTTimeslot';
  FBSequence.SequenceName := 'GEN_TTTIMESLOT_ID';
  FBtable.Sequence := FBSequence;
  FBTable.SequenceField := 'id';
  FBTable.Active := true;
  while not(FBTable.Eof) do
  begin
    FBTable.Delete;
  end;
  for i:= 0 to 20 do
  begin
    FndDayGroup[i] := false;
    X7TSDG[i] := 0;
  end;
  for i:= 1 to days do
  begin
    if not(FndDayGroup[DayGroup[i-1]]) then
    begin
      for j:= 1 to Periods do
      begin
        FBTable.Insert;
        //FBTable.FieldByName('Id').AsInteger := 0;
        FBTable.FieldByName('ttdaygroup_id').AsInteger := X7DG[DayGroup[i-1]];
        FBTable.FieldByName('name').AsString := tsName[i-1,j-1];
        FBTable.FieldByName('code').AsString := tsCode[i-1,j-1];
        FBTable.FieldByName('unit').AsFloat := tsAllot[i-1,j-1];
        FBTable.FieldByName('starttime').AsDateTime := tsStart[i-1,j-1];
        FBTable.FieldByName('endtime').AsDateTime := tsEnd[i-1,j-1];
        FBTable.Post;
        FndDayGroup[DayGroup[i-1]] := true;
        X7TS[i,j] := FBTable.FieldByname('id').AsInteger;
        X7TSDG[DayGroup[i-1]] := i;
      end;
    end else begin
      for j := 1 to Periods do
      begin
        X7TS[i,j] := X7TS[X7TSDG[DayGroup[i-1]],j];
      end;
    end;
  end;
  FBTable.Active := false;

 // TTClash
  FBTable.TableName := 'TTClash';
  FBTable.Sequence := nil;
  FBTable.SequenceField := '';
  FBTable.Active := true;
  while not(FBTable.Eof) do
  begin
    FBTable.Delete;
  end;
  for i:= 1 to days do
  begin
    for j := 1 to periods do
    begin
      FBTable.Insert;
      FBTable.FieldByName('day_id').AsInteger := X7DAY[i];
      FBTable.FieldByName('timeslot_id').AsInteger := X7TS[i,j];
      FBTable.FieldByName('tclash').AsInteger := tclash[i-1,j-1];
      FBTable.FieldByName('rclash').AsInteger := rclash[i-1,j-1];
      FBTable.FieldByName('fclash').AsInteger := fclash[i-1,j-1];
      FBTable.Post;
    end;
  end;
  FBTable.Active := false;

 // TTYear
  FBTable.TableName := 'TTYear';
  FBSequence.SequenceName := 'GEN_TTYEAR_ID';
  FBTable.Sequence := FBSequence;
  FBTable.SequenceField := 'id';
  FBTable.Active := true;
  while not(FBTable.Eof) do
  begin
    FBTable.Delete;
  end;
  for i:= 0 to yr do
  begin
    //if (copy(subcode[i],1,2)<>'00') then
    //begin
      FBTable.Insert;
      //FBTable.FieldByName('Id').AsInteger := i;
      FBTable.FieldByName('name').AsString := yearname[i];
      FBTable.FieldByName('tt_id').AsInteger := TT_ID;
      FBTable.FieldByName('levels').AsInteger := level[i];
      FBTable.FieldByName('blocks').AsInteger := Blocks[i];
      FBTable.Post;
      X7YR[i] := FBTable.FieldByName('id').asinteger;
    //end;
  end;
  FBTable.Active := false;

  // TTData
  FBTable.TableName := 'TTdata';
  FBTable.Sequence := nil;
  FBTable.SequenceField := '';
  FBTable.Active := true;
  while not(FBTable.Eof) do
  begin
    FBTable.Delete;
  end;
  for d:= 0 to days-1 do
  begin
    for p := 0 to periods - 1 do
    begin
    //if (copy(subcode[i],1,2)<>'00') then
    //begin
      for y := 0 to yr do
      begin
        for l := 0 to level[y] - 1 do
        begin
          IntPoint:=FNT(d,p,y,l,0);
          //sByte:=FNTByte(d,p,y,l,6)^;
          //cByte:=FNTByte(d,p,y,l,7)^;
          su:=IntPoint^; inc(IntPoint);
          te:=IntPoint^; inc(IntPoint);
          ro:=IntPoint^;
          //flgDouble:=((sByte and 1)=1);
          //blockNumber:=FNgetBlockNumber(d,p,y,l);
          //flgTclash:=((cByte and 8)=8);
          //flgRclash:=((cByte and 16)=16);
          FBTable.Insert;
          //FBTable.FieldByName('Id').AsInteger := i;
          FBTable.FieldByName('ttday_id').AsInteger := X7DAY[d+1];
          FBTable.FieldByName('tttimeslot_id').AsInteger := X7TS[d+1,p+1];
          FBTable.FieldByName('ttyear_id').AsInteger := X7YR[y];//y+1;
          FBTable.FieldByName('levelnum').AsInteger := l+1;
          if su>LabelBase then //label
          begin
            su:=su-labelbase;
            if (su<=Lnum) then
            begin
              FBTable.FieldByName('label').AsString :=TcLabel[su];
            end;
          end else begin
            FBTable.FieldByName('subject_id').AsInteger := su;
            FBTable.FieldByName('teacher_id').AsInteger := te;
            FBTable.FieldByName('room_id').AsInteger := ro;
          end;
          FBTable.Post;
        end;
      end;
    end;
  end;
  FBTable.Active := false;

 // TTYear
  FBTable.TableName := 'TTRollClass';
  FBSequence.SequenceName := '';
  FBTable.Sequence := nil;
  FBTable.SequenceField := '';
  FBTable.Active := true;
  while not(FBTable.Eof) do
  begin
    FBTable.Delete;
  end;
  for i:= 0 to yr do
  begin
    for j := 1 to nmbrLevels do
    begin
      FBTable.Insert;
      //FBTable.FieldByName('Id').AsInteger := i;
      FBTable.FieldByName('year_id').AsInteger := X7YR[i];
      FBTable.FieldByName('level_id').AsInteger := j;
      FBTable.FieldByName('ClassShown').AsInteger := ClassShown[j,i];
      FBTable.Post;
    end;
  end;
  FBTable.Active := false;

  ShowMessage('Done');

end;
}

procedure TMainForm.ClearChoices1Click(Sender: TObject);
var
 msg:     string;
 i,j,k:       integer;
begin
 if CheckAccessRights(utStud,36,true) then
  begin
   msg:='All student Choices for the current group will be removed.'+endline;
   msg:=msg+'Click the ''Yes'' button to confirm.';
   if messagedlg(msg,mtWarning,[mbYes,mbNo],0)=mrYes then
    begin    {only if pressed yes}
     for i:=1 to groupnum do
      begin
       j:=StGroup[i];
       for k:=1 to nmbrchoices do XML_STUDENTS.Stud[j].Choices[k]:=0;
       SaveStudFlag:=true;
       StudYearFlag[XML_STUDENTS.Stud[j].tcYear]:=true;
      end; {for i}

     try
      screen.cursor:=crHourglass;
      SaveAllStudentYears;
      UpdateStudCalcs;
     finally
      screen.cursor:=crDefault;
     end;

    end;
   CheckAccessRights(utStud,36,false);
  end;
end;

procedure TMainForm.ClashHelp1Click(Sender: TObject);
begin
 ClashHelpwinSelect;
end;

procedure TMainForm.BlockClashes1Click(Sender: TObject);
begin
 BlockClasheswinSelect;
end;

procedure TMainForm.TeacherClashes1Click(Sender: TObject);
begin
 TeacherClasheswinSelect;
end;

procedure TMainForm.RoomClashes1Click(Sender: TObject);
begin
 RoomClasheswinSelect;
end;

procedure TMainForm.TeacherFree1Click(Sender: TObject);
begin
 TeachersFreewinSelect;
end;

procedure TMainForm.RoomsFree1Click(Sender: TObject);
begin
 RoomsFreewinSelect;
end;

procedure TMainForm.TeacherTimes1Click(Sender: TObject);
begin
 TeacherTimeswinSelect;
end;

procedure TMainForm.SubjectTimes1Click(Sender: TObject);
begin
 SubjectTimeswinSelect;
end;

procedure TMainForm.SynergeticExport1Click(Sender: TObject);
begin
  FrmSynergeticExport:=TFrmSynergeticExport.create(self); //mantis- 1606
   FrmSynergeticExport.showmodal;
   FrmSynergeticExport.free;
end;

procedure TMainForm.GroupofTeachers1Click(Sender: TObject);
begin
 GroupofTeacherswinSelect;
end;

procedure TMainForm.PopupMenu1Popup(Sender: TObject);
begin
 all22.enabled:=(XML_STUDENTS.numstud>0);
end;

procedure TMainForm.ClashMatrix1Click(Sender: TObject);
begin
 clashmatrixWinSelect;
end;

procedure TMainForm.Version1Click(Sender: TObject);
begin
 if CheckAccessRights(utTime,16,true) then
  begin
   versiondlg:=Tversiondlg.create(self); {allocate dlg}
   versiondlg.showmodal;
   versiondlg.free;  {release dlg}
   if not(saveTimeFlag) then CheckAccessRights(utTime,16,false)
  end;
end;

procedure TMainForm.ViewCASES21ExportData(Sender: TObject);
var
  lFrmCASES21ExportDataView: TFrmCASES21ExportDataView;
begin
  lFrmCASES21ExportDataView := TFrmCASES21ExportDataView.Create(Application);
  try
    lFrmCASES21ExportDataView.ShowModal;
  finally
    FreeAndnIl(lFrmCASES21ExportDataView);
  end;
end;

procedure TMainForm.Levels1Click(Sender: TObject);
begin
 if CheckAccessRights(utTime,16,true) then
  begin
   ConfigureLevels:=TConfigureLevels.create(self); {allocate dlg}
   ConfigureLevels.showmodal;
   ConfigureLevels.free;  {release dlg}
   if not(saveTimeFlag) then CheckAccessRights(utTime,16,false)
  end;
end;

procedure TMainForm.ListTagNames1Click(Sender: TObject);    //---- mantis-0727
begin
 StudentTagsSelect;
end;

procedure TMainForm.Margins1Click(Sender: TObject);
begin
 pmargins:=Tpmargins.create(self);   {allocate dlg}
 pmargins.showmodal;
 pmargins.free;
end;

procedure TMainForm.mnuTrackEnrolments1Click(Sender: TObject);
begin
  CustomOutput.OberonTrackChoices;
end;

procedure TMainForm.Student2Click(Sender: TObject);
begin
 findStudentdlg:=TfindStudentdlg.create(self);   {allocate dlg}
 findStudentdlg.showmodal;
 findStudentdlg.free;               {release dlg}
end;

procedure TMainForm.Teacher3Click(Sender: TObject);
begin
 findteacherdlg:=Tfindteacherdlg.create(self);   {allocate dlg}
 findteacherdlg.showmodal;
 findteacherdlg.free;               {release dlg}
end;

procedure TMainForm.Room3Click(Sender: TObject);
begin
 findroomdlg:=Tfindroomdlg.create(self);   {allocate dlg}
 findroomdlg.showmodal;
 findroomdlg.free;               {release dlg}
end;

procedure TMainForm.Editcustomfile1Click(Sender: TObject);
begin
 editcustominformation;
end;

procedure TMainForm.Savecustomfile1Click(Sender: TObject);
var
 f    : textfile;
 s    : string;
 i    : smallint;
 fname: string;
begin
 if usrPassLevel=utGen then
  begin
   showRestrictedMsg;  exit;
  end;
 savedialog.title:='Save Custom Information';
 savedialog.HelpContext:=24;
 savedialog.defaultext:='CUS';
 savedialog.filename:=custom;
 savedialog.filter:='Custom Files | *.CUS';
 savedialog.initialdir:=Directories.datadir;
 if savedialog.execute then
  begin
   fname:=savedialog.filename;
   XML_DISPLAY.customFileLoad:=fname;
   try
    try
     doAssignFile(f,fname);
     rewrite(f);
     str(AddNum,s); writeln(f,s);
     if (AddNum>0) then
      for i:=1 to AddNum do
       begin
        str(customTab[i],s); writeln(f,s);
        writeln(f,Add[i]);
       end;
    finally
     closefile(f)
    end;
   except
   end;
   s:=Extractfilename(fname);
   custom:=RemoveExtension(s);
   UpdateWindow(wnInfo);
  end;
end;

procedure TMainForm.Custom1Click(Sender: TObject);
begin
 savecustomfile1.enabled:=(addnum>0);
 clear1.enabled:=(addnum>0);
end;

procedure TMainForm.DisplaySplitSubjectConversion(Sender: TObject);
var
  lFrmSplitSubjectConv: TFrmSplitSubjectConv;
begin
  lFrmSplitSubjectConv := TFrmSplitSubjectConv.Create(Application);
  try
    lFrmSplitSubjectConv.ShowModal;
  finally
    FreeAndNil(lFrmSplitSubjectConv);
  end;
end;

procedure TMainForm.DisplayStudentInput(Sender: TObject);
begin
 StudentInputWinSelect;
end;

procedure TMainForm.Promote1Click(Sender: TObject);
begin
 if CheckAccessRights(utTime,37,true) then
  begin
   promotestudentdlg:=Tpromotestudentdlg.create(self); {allocate dlg}
   promotestudentdlg.showmodal;
   promotestudentdlg.free;  {release dlg}
   CheckAccessRights(utTime,37,false)
  end;
end;

procedure TMainForm.Size1Click(Sender: TObject);
begin
 if CheckAccessRights(utTime,16,true) then
  begin
   ttsizedlg:=TttsizeDlg.create(self); {allocate dlg}
   ttsizedlg.showmodal;
   ttsizedlg.free;  {release dlg}
   if not(saveTimeFlag) then CheckAccessRights(utTime,16,false)
  end;
end;

procedure TMainForm.DisplayClick(Sender: TObject);
var
 wintag:  integer;
begin
 selection1.visible:=false;
 if mdichildcount=0 then exit;
 wintag:=activemdichild.tag;
 case wintag of
  wnSucode,wnTecode,wnRocode: selection1.caption:='&View ...';
  wnTtable: selection1.caption:='Print &Selection ...';
  wnInfo,wnRClassCode,wnFac,wnHouse,wnTimes,wnBlock: selection1.caption:='';
   else selection1.caption:='&Selection ...';
 end;
 case wintag of
  wnSucode,wnTecode,wnRocode,wnFindStud,
  wnSubjectList,wnTimeList,wnStudentList,wnStudentTt,wnTeList,wnTtable,wnTeClash,
  wnRoClash,wnTeFree,wnRoFree,wnTeTimes,wnSuTimes,wnGroupTe,wnTeacherTt,
  wnRoomTt,wnSubjectTt,wnCmatrix,wnStInput,wnBlockClashes,wnCHelp:
     begin
      selection1.visible:=true;
     end;
 end; {case}
end;

procedure TMainForm.DisplayHealthConditions(Sender: TObject);
var
  lFrmHealthCondition: TFrmHealthCondition;
begin
  lFrmHealthCondition := TFrmHealthCondition.Create(Application);
  try
    lFrmHealthCondition.HasAccess := usrPassLevel <> utGen;
    lFrmHealthCondition.ShowModal;
  finally
    FreeAndNil(lFrmHealthCondition);
  end;
end;

procedure TMainForm.DisplayRemoveTimetable(Sender: TObject);
var
  lFrmRemoveTimetable: TFrmRemoveTimetable;
begin
  if (usrPassLevel = utTime) or (usrPassLevel = utSuper)then
  begin
    lFrmRemoveTimetable := TFrmRemoveTimetable.Create(Application);
    try
      lFrmRemoveTimetable.TimetableInUse := FileNames.CurentTimeTable;
      lFrmRemoveTimetable.ShowModal;
    finally
      FreeAndNil(lFrmRemoveTimetable);
      RefreshTtableToolbar;
    end;
  end
  else
  begin
    ShowRestrictedMsg;
    Exit;
  end;
end;

procedure TMainForm.Textfilein1Click(Sender: TObject);
begin
 if usrPassLevel=utGen then
  begin
   showRestrictedMsg;  exit;
  end;
 getStudentText2;
end;



procedure TMainForm.ExportasTextfile1Click(Sender: TObject);
var
 winNum:  integer;
begin
 if (usrPassLevel=utGen) and (activeMDIchild.tag <> 13) then   // Allow General user to export student data
  begin
   showRestrictedMsg;  exit;
  end;
 if mdichildcount=0 then exit;
 winNum:=activeMDIchild.tag;
 TextExportWindow(winNum);
end;

function TMainForm.RefreshTtableToolbar: Boolean;
begin
  Result := False;
  if Assigned(TtableToolbarWin) then
    TtableToolbarWin.RefreshInUse;
  if Assigned(Ttablewin) and Ttablewin.Showing then
    if Assigned(TtableToolbarWin) then
      TtableToolbarWin.Refresh;
  Result := True;
end;

procedure TMainForm.Reloadstudentdata1Click(Sender: TObject);
var
 i: integer;
 msg: string;
 msgret:      word;
begin
 countSubsInBlock;
 if saveBlockFlag and (subsinblock>0) then
  begin
   msg:='Reloading the student data will clear the blocks.'+endline+endline;
   msg:=msg+'Are you sure you want to Proceed ?';
   msgret:=messagedlg(msg,mtConfirmation,[mbYes,mbNo],0);
   if msgret=mrNo then exit;
  end;
 screen.cursor:=crHourglass;
 XML_STUDENTS.numStud:=0;
 for i:=0 to years_minus_1 do StudentQuickStreamLoad(i);

 if Length(XML_STUDENTS.Stud) > 0 then
    begin
      for i:=0 to nmbrstudents do
      begin
        studID2[i]:='';      //clear array
        studEmail[i]:='';
      end;
      for i:=0 to years_minus_1 do StudentID2Load(i);
      BuildSTUDNew;
      for i := 0 to years_minus_1 do StudentID2LoadNew(i);

    end;

 sortStudents;   {maintain sort after sep. years}
 initBlockdata;
 UpdateStudCalcs;
 screen.cursor:=crDefault;
 CheckAccessRights(utStud,36,false); //release studs if necess.
 CheckAccessRights(utBlock,40,false); //release blocks if necess.
end;

procedure TMainForm.ClearUserAccessLocks(Sender: TObject);
begin
  if MessageDlg(AMG_CLEAR_ACCESS_LOCKS_MSG, mtConfirmation, mbYesNo, 0) = mrYes then
    CheckAccessFile;
end;

procedure TMainForm.Select2Click(Sender: TObject);
begin
  groupseldlg := Tgroupseldlg.Create(self);   {allocate dlg}
  try
    groupseldlg.ShowModal;
  finally
    FreeAndNil(groupseldlg);    {release dlg}
  end;
end;

procedure TMainForm.Sort1Click(Sender: TObject);
begin
 sortChangeFlag:=false;
 SortGroupDlg:=TSortGroupDlg.create(self);   {allocate dlg}
 SortGroupDlg.showmodal;
 SortGroupDlg.free;    {release dlg}
end;

procedure TMainForm.All22Click(Sender: TObject);
begin
  groupseldlg := Tgroupseldlg.Create(self);   {allocate dlg}
  try
    groupseldlg.ShowModal;
  finally
    FreeAndNil(groupseldlg);    {release dlg}
  end;
end;

procedure TMainForm.grp02Click(Sender: TObject);
var
  i: Integer;
begin
  cookCustomGroup(GOSmenu[(sender as TMenuItem).tag]);
  for i := 0 to (Sender as TMenuItem).Parent.Count - 1 do
    (Sender as TMenuItem).Parent.Items[i].Checked := False;
  (Sender as TMenuItem).Checked := True;
end;

procedure TMainForm.GoSurfing1Click(Sender: TObject);
begin
 ShellExecute(0, Nil, PChar('http://www.timechart.com.au/'), Nil, Nil, SW_SHOWNORMAL);
end;

procedure TMainForm.Hintsandtips1Click(Sender: TObject);
begin
 Hintsdlg:=THintsdlg.create(self);   {allocate dlg}
 Hintsdlg.showmodal;
 Hintsdlg.free;    {release dlg}
end;

procedure TMainForm.CreateBackup1Click(Sender: TObject);
begin
 if (usrPasslevel=utGen) then
  begin
   showRestrictedMsg;
   exit;
  end;
 if usrPassBKUP then
  begin
   backup_action:=1; {backup}
   BackupDataDlg:=TBackupDataDlg.create(self);   {allocate dlg}
   BackupDataDlg.showmodal;
   BackupDataDlg.free;
   end
  else showRestrictedMsg;
end;

procedure TMainForm.RestorefromBackup1Click(Sender: TObject);
begin
 if (usrPasslevel=utGen) then
  begin
   showRestrictedMsg;
   exit;
  end;
 if usrPassBKUP then
  begin
   if CheckAccessRights(utTime,42,true) then
    begin
     backup_action:=2; {restore}
     BackupDataDlg:=TBackupDataDlg.create(self);   {allocate dlg}
     BackupDataDlg.showmodal;
     BackupDataDlg.free;
     CheckAccessRights(utTime,42,false)
    end;
  end
 else showRestrictedMsg;
end;

procedure TMainForm.Blocks3Click(Sender: TObject);
begin
 if CheckAccessRights(utTime,16,true) then
  begin
   Configureblocks:=TConfigureblocks.create(self); {allocate dlg}
   Configureblocks.showmodal;
   Configureblocks.free;  {release dlg}
   if not(saveTimeFlag) then CheckAccessRights(utTime,16,false)
  end;
end;

procedure TMainForm.Panel6DockOver(Sender: TObject;
  Source: TDragDockObject; X, Y: Integer; State: TDragState;
  var Accept: Boolean);
var
 aa: smallint;
begin
 aa:=(source.control as tform).tag;
 if (aa=wnGenTool) then accept:=true else accept:=false;
end;

procedure TMainForm.Toolbars1Click(Sender: TObject);
begin
 timetable4.checked:=fgTTtoolbar;
 general1.checked:=fgGenToolbar;
 blocking1.checked:=fgBlockToolbar;
 Worksheet2.Checked:=fgWStoolbar;
 //timetable4.visible:=wnFlag[wnTtable];
 blocking1.visible:=wnFlag[wnBlock];
 Worksheet2.Visible:=wnFlag[wnWorksheet];
end;

procedure TMainForm.General1Click(Sender: TObject);
begin
 if not(fgGenToolbar) then gentoolbarSelect
   else gentoolbarwin.close;
end;

procedure TMainForm.Timetable4Click(Sender: TObject);
begin
 {if not(wnFlag[wnTtable]) then exit;
 if not(fgTTtoolbar) then tttoolbarSelect
   else TtableToolbarWin.close;}
end;

procedure TMainForm.Blocking1Click(Sender: TObject);
begin
 if not(wnFlag[wnBlock]) then exit;
 if not(fgBlockToolbar) then blocktoolbarSelect
   else blocktoolbarwin.close;
end;

procedure TMainForm.ArchiveData(Sender: TObject);
// this is usful for emailing data
var
  AbZipper: TAbZipper;
  lFileList: TStringList;
  i: Integer;
  lFrmLoadProgress: TFrmLoadProgress;
  lProgress: Integer;
  lPrevProgress: Integer;
  lFileName: LPCTSTR;
begin
  lFileList := TStringList.Create;
  try
    FindFiles('*.*', faAnyFile, lFileList, True);
    AbZipper:= TAbZipper.Create(Self);
    lFrmLoadProgress := TFrmLoadProgress.Create(Application);
    lFrmLoadProgress.Title := AMG_ARCHIVING_DATA;
    try
      lFrmLoadProgress.Show;
      AbZipper.FileName := Directories.ProgDir + '\' + AMG_DATA_ZIP_FILE;
      Application.ProcessMessages;
      lFileName := PChar(AbZipper.FileName);
      if FileExists(lFileName) then
      begin
        AbZipper.DeleteFiles('*.*');
        Application.ProcessMessages;
      end;

      lProgress := 0;
      lPrevProgress := 0;
      for i := 0 to lFileList.Count - 1 do
      begin
        AbZipper.AddFiles(lFileList.Strings[i], faAnyFile);
        if i > 0 then
          lProgress := Round(i * (100 / lFileList.Count));
        lFrmLoadProgress.UpdateProgress(lProgress - lPrevProgress, 'Adding ' + lFileList.Strings[i] + ' to the archive...', 10);
        lPrevProgress := lProgress;
      end;
      lFrmLoadProgress.UpdateProgress(lProgress - lPrevProgress, AMG_FILES_ARCHIVING_COMPLETE_MSG, 50);
      Application.ProcessMessages;
      if FileExists(AbZipper.FileName) then
        MessageDlg('Data has been archived in file ' + AMG_DATA_ZIP_FILE + ' and stored in: ' + #10#13 + Directories.ProgDir, mtInformation, [mbOK], 0)
      else
        MessageDlg(AMG_DATA_FAILED_TO_ARCHIVE_MSG, mtInformation, [mbOK], 0);
    finally
      AbZipper.CloseArchive;
      AbZipper.Save;
      FreeAndNil(AbZipper);
    end;
  finally
    FreeAndNil(lFrmLoadProgress);
    FreeAndNil(lFileList);
  end;
end;

procedure TMainForm.TASSExport1Click(Sender: TObject);
var
  lFrmExportTASS: TFrmExportTASS;
begin
  if not UserIsGeneric then
  begin
    lFrmExportTASS := TFrmExportTASS.Create(Application);
    try
      lFrmExportTASS.ShowModal;
    finally
      FreeAndNil(lFrmExportTASS);
    end;
  end;

end;

procedure TMainForm.Panel4DockDrop(Sender: TObject;
  Source: TDragDockObject; X, Y: Integer);
begin
 panel4.height:=panel4.height+(source.control as tform).clientheight;
 XML_DISPLAY.fgGenToolbarDock:=1;
end;

procedure TMainForm.Panel6DockDrop(Sender: TObject;
  Source: TDragDockObject; X, Y: Integer);
begin
 panel6.height:=panel6.height+(source.control as tform).clientheight;
 XML_DISPLAY.fgGenToolbarDock:=2;
end;

procedure TMainForm.Panel4DockOver(Sender: TObject;
  Source: TDragDockObject; X, Y: Integer; State: TDragState;
  var Accept: Boolean);
var
 aa: smallint;
begin
 aa:=(source.control as tform).tag;
 accept:=(aa=wnGenTool);
end;

procedure TMainForm.Transfer1Click(Sender: TObject);
begin
 TextExportWindow(wnUserExport1);
end;

procedure TMainForm.Transfer2Click(Sender: TObject);
begin
 TextExportWindow(wnUserExport2);
end;

procedure TMainForm.ExportCASES21Data(Sender: TObject);
var
  lFrmExportCASES21: TFrmExportCASES21;
begin
  if not UserIsGeneric then
  begin
    lFrmExportCASES21 := TFrmExportCASES21.Create(Application);
    try
      if lFrmExportCASES21.ShowModal = mrOk then
      begin
        About.DEETdumpOut(lFrmExportCASES21.ExcludeNonTimetabledChoices, lFrmExportCASES21.Cases21Spec);
      end;
    finally
      FreeAndNil(lFrmExportCASES21)
    end;
  end;
end;

procedure TMainForm.ExportVASSStudent(Sender: TObject);
var
  lFrmVASSStudentExport: TFrmVASSStudentExport;
begin
  lFrmVASSStudentExport := TFrmVASSStudentExport.Create(Application);
  try
    lFrmVASSStudentExport.ShowModal;
  finally
    FreeAndNil(lFrmVASSStudentExport);
  end;
end;

procedure TMainForm.ExportVASSStudentChoices(Sender: TObject);
var
  lFrmVASSStudentChoicesExport: TFrmVASSStudentChoicesExport;
begin
  lFrmVASSStudentChoicesExport := TFrmVASSStudentChoicesExport.Create(Application);
  try
    lFrmVASSStudentChoicesExport.ShowModal;
  finally
    FreeAndNil(lFrmVASSStudentChoicesExport);
  end;
end;

procedure TMainForm.Import1Click(Sender: TObject);
var
  filter: string;
  title:  string;
begin
  // Get the filename to import from OpenDialog
  filter := OpenDialog.Filter;
  title := OpenDialog.Title;
  OpenDialog.filter := 'CSV files | *.csv';
  OpenDialog.Title := 'Import Student Choices';
  if OpenDialog.Execute then
  begin
    // Import
    WebTC.SCImport(OpenDialog.FileName);
  end;
  OpenDialog.Filter := filter;
  OpenDialog.Title  := title;
end;

procedure TMainForm.ImportCASES21Data(Sender: TObject);
var
  lCurrentDir: string;
  lFrmImportCases21: TFrmImportCases21;
  lFrmCASES21ImportOptions: TFrmCASES21ImportOptions;
begin
  if not UserIsGeneric then
  begin
    lFrmCASES21ImportOptions := TFrmCASES21ImportOptions.Create(Application);
    try
      if lFrmCASES21ImportOptions.ShowModal = mrOK then
      begin
        lFrmImportCases21 := TFrmImportCases21.Create(Application);
        lFrmImportCases21.ImportStudentOK := lFrmCASES21ImportOptions.ImportStudentOK;
        lFrmImportCases21.ImportTeacherOK := lFrmCASES21ImportOptions.ImportTeacherOK;
        lFrmImportCases21.ImportSubjectOK := lFrmCASES21ImportOptions.ImportSubjectOK;
        lFrmImportCases21.ImportRoomOK := lFrmCASES21ImportOptions.ImportRoomOK;
        lCurrentDir := GetCurrentDir;
        try
          ChDir(Directories.DataDir);
          if lFrmImportCases21.ShowModal = mrOk then
            getCodes;
        finally
          SetCurrentDir(lCurrentDir);
        end;
      end; // if
    finally
      FreeAndNil(lFrmImportCases21);
    end;
  end;
end;

procedure TMainForm.DoPrintPreviewExecute(Sender: TObject);
begin
 FIsPPLandscape := Bool(XML_DISPLAY.FIsLandscape);
 PreviewWin:=activeMDIchild.tag;
 PrntPreviewForm:=TPrntPreviewForm.create(self);   {allocate dlg}
 PrntPreviewForm.WindowState:=wsMaximized;
 PrntPreviewForm.showmodal;
 XML_DISPLAY.FIsLandscape := Integer(FIsPPLandscape);
 PrntPreviewForm.free;               {release dlg}
end;

procedure TMainForm.MainPrintExecute(Sender: TObject);
var
 winNum: smallint;
 Saved8087CW: word;
begin
 Saved8087CW:=Default8087CW;
 try
  Set8087CW(Default8087CW or $3f);  // turn off floating point exception
   try
    winNum:=activeMDIchild.tag;
    printOurWindow(winNum);

    FIsPPLandscape := Bool(XML_DISPLAY.FIsLandscape);
   except
   end;
 finally
  Set8087CW(Saved8087CW); // restore default value
 end;
end;

procedure TMainForm.MainPrintUpdate(Sender: TObject);
begin
 mainprint.Enabled:=(mdiChildCount>0);
end;

procedure TMainForm.DoPrintPreviewUpdate(Sender: TObject);
begin
 DoPrintPreview.Enabled:=(mdiChildCount>0);
end;

procedure TMainForm.CopyWinExecute(Sender: TObject);
var
 winNum: smallint;
begin
 if mdichildcount=0 then exit;
 winNum:=activeMDIchild.tag;
 CopyExportWindow(winNum);
end;

procedure TMainForm.CopyWinUpdate(Sender: TObject);
begin
 CopyWin.Enabled:=(mdiChildCount>0);
end;

procedure TMainForm.OpenSuWndExecute(Sender: TObject);
begin
 SuCodeWinSelect;
end;

procedure TMainForm.OpenTeWndExecute(Sender: TObject);
begin
 TeCodeWinSelect;
end;

procedure TMainForm.OpenRoWndExecute(Sender: TObject);
begin
 RoCodeWinSelect;
end;

procedure TMainForm.OpenRollWndExecute(Sender: TObject);
begin
 RollClassWinSelect;
end;

procedure TMainForm.OpenFacWndExecute(Sender: TObject);
begin
 FacWinSelect;
end;

procedure TMainForm.OpenHouseWndExecute(Sender: TObject);
begin
 HouseWinSelect;
end;

procedure TMainForm.OpenTimesWndExecute(Sender: TObject);
begin
 TimesWinSelect;
end;

procedure TMainForm.NextViewExecute(Sender: TObject);
begin
 if activemdichild is TDrawWin then
  TDrawWin(activemdichild).ChangeView;
end;

procedure TMainForm.NextViewUpdate(Sender: TObject);
begin
 NextView.Enabled:=(activemdichild is TDrawWin) and (XML_DISPLAY.winViewMax[activemdichild.tag]>0)
end;

procedure TMainForm.SetFontExecute(Sender: TObject);
begin
 fontDialog1.options:=[fdForceFontExist];
 fontDialog1.font.assign(XML_DISPLAY.tcfont);
 if fontDialog1.execute  then
  try {ensure cursor restored}
   XML_DISPLAY.tcfont.assign(mainform.fontDialog1.font);
   screen.cursor:=crHourglass;
   getfontwidths; AlterTimeFlag:=True;  AlterWSflag:=true;
   updateAllwins;
  finally
   screen.cursor:=crDefault;
  end;
end;

procedure TMainForm.SetupUserMenus;
begin
  //mniHelpCheckForUpdates.Visible := usrPassLevel = utSuper;
  CheckForUpdates1.Visible := usrPassLevel = utSuper;

  mniHelpSystem.Visible := (usrPassLevel = utSuper) or (usrPassLevel = utTime);
  mniFileImportFamilyList.Enabled := (usrPassLevel = utSuper) or (usrPassLevel = utTime);

  // cases export activation
  mniFileCASES21.Visible := Cases21Flag and (usrPasslevel > utGen);
  mniFileVASS.Visible := mniFileCASES21.Visible;
  MainForm.mniFileCASES21.Enabled := usrPassLevel <> utGen;

  User1Click(Self);
end;

procedure TMainForm.PrefsExecute(Sender: TObject);
begin
 prefdlg:=Tprefdlg.create(self);   {allocate dlg}
 prefdlg.showmodal;
 prefdlg.free;               {release dlg}
end;

procedure TMainForm.SelectDlgExecute(Sender: TObject);
var
 wintag:  integer;
begin
 if mdichildcount=0 then exit;
 wintag:=activeMDIchild.tag;
 case wintag of
  wnSucode: SuWindow.View1Click(activemdichild);
  wnTecode: TeWindow.View1Click(activemdichild);
  wnRocode: RoWindow.View1Click(activemdichild);
  wnSubjectList: subbysubjectwin.subject2Click(activemdichild);
  wnTimeList: subbytimeslotwin.timeslot2Click(activemdichild);
  wnStudentList: studentlistwin.selection1Click(activemdichild);
  wnStudentTt: sttable.selection2Click(activemdichild);
  wnTtable: ttablewin.selection1Click(activemdichild);
  wnCmatrix: cmatwin.MenuItem3Click(activemdichild);
  wnStInput: Stuinput.Selection2Click(activemdichild);
  wnCHelp: ClashHelp.selection1Click(activemdichild);
  wnBlockClashes: BlockClashesWin.Selection2Click(activemdichild);
  wnTeClash: TeacherClashes.Selection2Click(activemdichild);
  wnRoClash: RoomClashes.Selection2Click(activemdichild);
  wnTeFree: TeachersFree.Selection2Click(activemdichild);
  wnRoFree: RoomsFree.Selection2Click(activemdichild);
  wnTeTimes: TeacherTimes.Selection2Click(activemdichild);
  wnSuTimes: SubjectTimes.Selection2Click(activemdichild);
  wnGroupTe: GroupofTeachers.Selection2Click(activemdichild);
  wnTeacherTt: tettable.selection2Click(activemdichild);
  wnRoomTt: rottable.selection2Click(activemdichild);
  wnSubjectTt: suttable.selection2Click(activemdichild);
  wnTeList:TeListWin.Selection1Click(activemdichild);
 end; {case}
end;

procedure clearStudListBoxSelections;
begin
 XML_DISPLAY.StudentTtSelection[0]:=0;
 XML_DISPLAY.StudentInputSelection[0]:=0;
 ListStudentSelection[0]:=0;
end;

procedure TMainForm.NewDataExecute(Sender: TObject);
var
 msg,olddir,newdir:   string;
 okForGeneralUsr: bool;
 f:            file;
 tmpDir:       string[100];
begin
 olddir:=Directories.datadir;
 if SaveTTCancel then exit;
 if SaveBlocksCancel then exit;

 if getdirdlg.showmodal<>mrOK then exit;
 newdir:=Directories.datadir;
 if usrPassLevel=utGen then {prevent general user going to faulty dir}
  begin
   chdir(Directories.datadir);
   okForGeneralUsr:=true;
   if not(fileexists('SUBCODE.DAT')) then okForGeneralUsr:=false;
   if okForGeneralUsr then
   try
    try
     doAssignFile(f,'SUBCODE.DAT');
     filemode:=fmOpenRead+fmShareDenyNone;
     reset(f,1);
     if filesize(f)=0 then okForGeneralUsr:=false;
    finally
     closefile(f);
    end;
   if okForGeneralUsr then
    begin
     if not(fileexists('TECODE.DAT')) then okForGeneralUsr:=false;
     if okForGeneralUsr then
      begin
       try
        doAssignFile(f,'TECODE.DAT');
        filemode:=fmOpenRead+fmShareDenyNone;
        reset(f,1);
        if filesize(f)=0 then okForGeneralUsr:=false;
       finally
        closefile(f);
       end;
     if okForGeneralUsr then
      begin
       if not(fileexists('ROOMS.DAT')) then okForGeneralUsr:=false;
       if okForGeneralUsr then
        try
         doAssignFile(f,'ROOMS.DAT');
         filemode:=fmOpenRead+fmShareDenyNone;
         reset(f,1);
         if filesize(f)=0 then okForGeneralUsr:=false;
        finally
         closefile(f);
        end;
      end;
    end;
   end;
  except
  end;
  if not(okForGeneralUsr) then
   begin
    msg:='The directory '+Directories.datadir+endline;
    msg:=msg+'Does NOT contain useful Time Chart data.'+endline+endline;
    msg:=msg+'No valid Subject, Teacher or Room data was found.';
    messagedlg(msg,mtError,[mbOK],0);
    Directories.dataDir:=tmpDir;
    exit;
   end;
  end; {if usrPassLevel=utGen }

 Directories.datadir:=olddir;    {switch to previous data dir for RollMarker files}
 if RollMarkerFlg then CheckRollMarkerExport;  //dump out before switching
 Directories.datadir:=newdir;

 removeDormantLocks;  {any still left}
 try
  clearStudListBoxSelections; {clear stud sels}
  screen.cursor:=crHourglass;
  Directories.blockdir:=Directories.datadir;  {set tc dirs}
  Directories.textdir:=Directories.datadir;
  Directories.timedir:=Directories.datadir;

  chdir(Directories.datadir); {ensure default name is used for new dirs if cur name not there}
  if ((not(fileexists(FileNames.LoadedTimeTable+XMLHelper.getTTW_EXTENSION('',JustTheExtension)))) and (not(fileexists(FileNames.LoadedTimeTable+'.TT')))) then
   FileNames.LoadedTimeTable:='TTABLE';

  firstLoad;
  CheckSelections;

  UpdateAllWins;
  if fgTTtoolbar and (Assigned(TtableToolbarWin)) then
    TtableToolbarWin.OnShow(Self);
 finally
  screen.cursor:=crDefault;
 end; {try}
end;

procedure TMainForm.TtSaveExecute(Sender: TObject);
begin
 if (usrPassLevel<>utTime) and (usrPassLevel<>utSuper) then
  begin
   showRestrictedMsg;  exit;
  end;

 if CheckAccessRights(utTime,16,true) then
  begin
   if Directories.timedir<>Directories.datadir then SaveAsClick(Sender) else saveTTable;
   About.RefreshObjects;
  end;
end;

procedure TMainForm.ShowInfoWinExecute(Sender: TObject);
begin
 infoWinSelect;
end;

procedure TMainForm.ShowBlocksWinExecute(Sender: TObject);
begin
 BlockwinSelect;
end;

procedure TMainForm.ShowSubjectListExecute(Sender: TObject);
begin
 SubListWinSelect;
end;

procedure TMainForm.ShowTimetableExecute(Sender: TObject);
begin
 TtableWinSelect;
end;

procedure TMainForm.ShowStudListExecute(Sender: TObject);
begin
 StudentListwinSelect;
end;

procedure TMainForm.ShowStudTtExecute(Sender: TObject);
begin
 studentTtablewinSelect;
end;

procedure TMainForm.ShowTeachTtExecute(Sender: TObject);
begin
 teachTtablewinSelect;
end;

procedure TMainForm.ShowRoomTtExecute(Sender: TObject);
begin
 roomTtablewinSelect;
end;

procedure TMainForm.ShowSubTtExecute(Sender: TObject);
begin
 subjectTtablewinSelect;
end;

procedure TMainForm.CascadeWinsExecute(Sender: TObject);
begin
 Cascade;
end;

procedure TMainForm.TeacherList1Click(Sender: TObject);
begin
 TeacherListwinSelect;
end;

procedure TMainForm.StudentClashes1Click(Sender: TObject);
begin
 StBlockClashWinSelect;
end;

procedure TMainForm.StudFree1Click(Sender: TObject);
begin
 StudFreeWinSelect;
end;

procedure TMainForm.ImportFamilyList(Sender: TObject);
var
  lFamilies: TAMGFamilies;
begin
  OpenDialog.Title:='Load Family list';
  //OpenDialog.HelpContext := 3;
  OpenDialog.Filter := 'Family file|*.csv';
  OpenDialog.InitialDir := Directories.datadir;
  OpenDialog.defaultext := '*.csv';
  OpenDialog.options := [ofFileMustExist, ofHideReadOnly, ofPathMustExist];
  if OpenDialog.Execute then
  begin
    lFamilies := TAMGFamilies.Create;
    lFamilies.SMSFileName := OpenDialog.FileName;
    try
      lFamilies.ImportFromSMSFile;
    finally
      FreeAndNil(lFamilies);
    end;

  end;
end;

procedure TMainForm.ImportSubjects(Sender: TObject);
var
  lFileName: string;
begin
  OpenDialog.Title:='Load Subject list';
  //OpenDialog.HelpContext := 3;
  OpenDialog.Filter := 'Text File|*.txt';
  OpenDialog.InitialDir := Directories.datadir;
  OpenDialog.defaultext := '*.txt';
  OpenDialog.options := [ofFileMustExist, ofHideReadOnly, ofPathMustExist];
  if OpenDialog.Execute then
  begin
    lFileName := OpenDialog.FileName;
    LoadSubjectsFromFile(lFileName);
  end;
end;

procedure TMainForm.Info2Click(Sender: TObject);
begin
 showPassLevel;
end;

procedure TMainForm.Changepassword1Click(Sender: TObject);
begin
 if (usrPasslevel=utGen) then
  begin
   showRestrictedMsg;
   exit;
  end;

 edpassworddlg:=Tedpassworddlg.create(application);   {allocate dlg}
 edpassworddlg.showmodal;
 edpassworddlg.free;               {release dlg}
end;

procedure TMainForm.Logonasadifferentuser1Click(Sender: TObject);
var
  i:       integer;
  tmpstr,tmpstrB:   string;
  oldUserPassID,oldUserPassDir: string;
  oldusrPasslevel: smallint;
  lCurrentDir: string;
begin
 oldUserPassID:=usrPassID;  oldUserPassDir:=usrPassDir;

 if SaveBlocksCancel then exit;
 if SaveTTCancel then exit;

 if usrpasslevel>utGen then OldusrPasslevel:=usrPasslevel
   else OldusrPasslevel:=-1;

 for i := 1 to MDIChildCount do
   SaveWinPos(Self.MDIChildren[i - 1]);
 saveWinDisplay;
 if Checkpassword = lsLogin then
 begin
   SetupUserMenus;
   CloseAllWindows(nil);
 end;
  Transfer1.Enabled := (usrPassLevel = utSuper) or (usrPassLevel = utTime);

 if ((usrPasslevel=utGen) and (OldusrPasslevel=-1)) then exit; {no need to reload, general to general}
 //if (OldusrPasslevel<>usrPassrecord) then
 begin
  try
   tmpStr:=usrPassID;  usrPassID:=OldUserPassID;    {temp restore to old user}
   tmpstrB:=usrPassDir; usrPassDir:=oldUserPassDir;
   i:=usrPasslevel;   usrPasslevel:=OldusrPasslevel;

   if fEntryDlgUp then EntryDlg.Close;
   if fSearchReplaceDlgUp then SearchDlg.Close;
   if fRemSubyrDlgUp then delyrsubdlg.Close;
   if fMoveSubDlgUp then MoveSubDlg.Close;

   removeDormantLocks;
   LogMeOff(oldUserPassDir, oldUserPassID);
   usrPassID:=tmpStr;   usrPasslevel:=i;  usrPassDir:=tmpstrB;  {return to new user}

   clearStudListBoxSelections; {clear stud sels}
   screen.cursor:=crHourglass;
   Directories.blockdir:=Directories.datadir;  {set tc dirs}
   Directories.textdir:=Directories.datadir;
   Directories.timedir:=Directories.datadir;

   chdir(Directories.datadir); {ensure default name is used for new dirs if cur name not there}
   if ((not(fileexists(FileNames.LoadedTimeTable+XMLHelper.getTTW_EXTENSION('',JustTheExtension)))) and (not(fileexists(FileNames.LoadedTimeTable+'.TT')))) then
    FileNames.LoadedTimeTable:='TTABLE';
   firstLoad;
   lCurrentDir := GetCurrentDir;
   SetCurrentDir(usrPassDir);
   try
     FMRU.RefreshFromFile;
   finally
     SetCurrentDir(lCurrentDir);
   end;
   WinShow;
   CheckSelections;

   UpdateAllWins;
  finally
   screen.cursor:=crDefault;
  end; {try}
 end;

end;

procedure TMainForm.Showusers1Click(Sender: TObject);
begin
 if usrPasslevel<>utSuper then exit;
 if wnFlag[wnShowUsers] then ShowUsersWin.show
  else ShowUsersWin:=tShowUsersWin.create(application);
end;

procedure TMainForm.Adduser1Click(Sender: TObject);
begin
 if CheckAccessRights(utSuper,38,true) then
  begin
   AddNewUserDlg:=TAddNewUserDlg.create(application);   {allocate dlg}
   AddNewUserDlg.showmodal;
   AddNewUserDlg.free;               {release dlg}
   CheckAccessRights(utSuper,38,false)
  end;
end;

procedure TMainForm.Edituser1Click(Sender: TObject);
begin
 if CheckAccessRights(utSuper,38,true) then
  begin
   EditUserDlg:=TEditUserDlg.create(application);   {allocate dlg}
   EditUserDlg.showmodal;
   EditUserDlg.free;               {release dlg}
   CheckAccessRights(utSuper,38,false)
  end;
end;

procedure TMainForm.Deleteuser1Click(Sender: TObject);
begin
 if CheckAccessRights(utSuper,38,true) then
  begin
   DeleteUserDlg:=TDeleteUserDlg.create(application);   {allocate dlg}
   DeleteUserDlg.showmodal;
   DeleteUserDlg.free;               {release dlg}
   CheckAccessRights(utSuper,38,false)
  end;
end;

procedure TMainForm.Autoloadtime1Click(Sender: TObject);
begin
 if CheckAccessRights(utBlock,38,true) then
  begin
   autoloaddlg:=Tautoloaddlg.create(application);   {allocate dlg}
   autoloaddlg.showmodal;
   autoloaddlg.free;               {release dlg}
   CheckAccessRights(utBlock,38,false)
  end;
end;

procedure TMainForm.Setcurrentdatadirectoryasdefault1Click(Sender: TObject);
var
  F: Textfile;
  lCurrDir: string;
  lOkToChange: Boolean;
  lIsMain: Boolean;
  i: Integer;

  procedure SaveDirValues;
  begin
    doAssignFile(F,'DIR.SYS');
    try
      Rewrite(F);
      Writeln(F, Directories.progdir);
      Writeln(F, Directories.datadir);
      if lIsMain then
        Writeln(F, Directories.RMExportDir);
      Writeln(F, DOSscreenmem);
    finally
      CloseFile(F);
    end;
  end;
begin
  if usrPasslevel <> utSuper then
    Exit;
  if UserRecordsCount > 1 then
    lOkToChange := MessageDlg('Setting the current data directory as Default will affect all the Time Chart users.' + #10#13 + 'Are you sure you want to proceed? ', mtError, mbYesNo, 0) = mrYes
  else
    lOkToChange := True;

  if lOkToChange then
  begin
    lCurrDir := GetCurrentDir;
    try
      try
        ChDir(Directories.progdir);
        lIsMain := True;
        SaveDirValues;
        lIsMain := False;
         for i := 1 to UserRecordsCount do
         begin
           usrPassDir := passUserDir[i];
           ChDir(usrPassDir);
           SaveDirValues;
         end;
      except
      end;
    finally
      ChDir(lCurrDir);
    end;
  end;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
 if not(loadFinished) then exit; //NOT during load
 if HaveDataLock then exit;
 inc(MouldAge);
 if MouldAge>=MouldyDataCheckTime then
  begin
   CheckForMouldyData2;
   MouldAge:=0;
  end;
end;

procedure TMainForm.User1Click(Sender: TObject);
begin
  if (usrPasslevel=utSuper) then {supervisor only}
  begin
    n15.visible:=true; n16.visible:=true; mniStudentN2.Visible := True;
    adduser1.visible:=true; edituser1.Visible := True;
    deleteuser1.Visible := True;
    showusers1.Visible := True;
    autoloadtime1.Visible :=true;
    mniUserClearUserAccessLocks.Visible := True;
    Savedefaultdisplaysettings1.Visible := True;
    Setcurrentdatadirectoryasdefault1.Visible := True;
  end
  else
  begin
    n15.visible:=false; n16.visible:=false; mniStudentN2.visible := False;
    adduser1.visible:=false; edituser1.visible := False;
    deleteuser1.visible := False;
    showusers1.Visible := False;
    autoloadtime1.Visible := False;
    mniUserClearUserAccessLocks.Visible := False;
    Savedefaultdisplaysettings1.Visible := False;
    Setcurrentdatadirectoryasdefault1.Visible := False;
  end;
 {general cannot change password but can log on again as diff user}
 Changepassword1.visible:=(usrPassLevel>utGen);
end;

procedure TMainForm.Savedefaultdisplaysettings1Click(Sender: TObject);
var
   i,j: Integer;
  procedure getDEFDatadir; {read in def DIR.SYS }
  var
    F: Textfile;
    tmpStr: String[szDirName];
  begin
    Directories.defDataDir:='';
    try
      try
        chdir(Directories.progdir);
        doAssignFile(F,'DIR.SYS');
        filemode:=fmOpenRead+fmShareDenyNone;
        reset(F);
        Readln(F,tmpStr);
        Readln(F,Directories.defDataDir);
      finally
        CloseFile(F);
      end;
    except
    end;
  end;

begin
 if usrPasslevel<>utSuper then exit;
 j:=mdichildCount;
 if j>0 then
  for i:=1 to j do
   saveWinpos(mainform.mdichildren[i-1]);
 try
  getDEFDatadir;
  chdir(Directories.defDataDir);
  saveDisplayFile(OLD_DISPLAY_FILE);
  chdir(Directories.DataDir);
 except
 end;
end;

procedure TMainForm.Transfer3Click(Sender: TObject);
begin
 TextExportWindow(wnUserExport3);
end;

procedure TMainForm.TransferStudClick(Sender: TObject);
begin
TextExportWindow(wnUserExportStud);
end;

procedure TMainForm.InUse2Click(Sender: TObject);
begin
// #994 - Only specified users can do this
  if (usrPassLevel = utTime) or (usrPassLevel = utSuper)then
  begin

    SpecifyCurTtableDlg := TSpecifyCurTtableDlg.Create(Application);   {allocate dlg}
    try
      SpecifyCurTtableDlg.ShowModal;
    finally
      FreeAndNil(SpecifyCurTtableDlg);
      if Assigned(Ttablewin) and Ttablewin.Showing then
        if Assigned(TtableToolbarWin) then
          TtableToolbarWin.OnShow(Self);
    end;
  //end else begin
  //  ShowRestrictedMsg;
  end;
end;

procedure TMainForm.WebTCSCExportClick(Sender: TObject);
begin
  WebTC.SCExport;
end;

procedure TMainForm.WebUpdate1Click(Sender: TObject);
begin
 ShellExecute(0, Nil, PChar('http://www.amig.com.au/updates.html'),
     Nil, Nil, SW_SHOWNORMAL);
end;

procedure TMainForm.CustomA1Click(Sender: TObject);
begin
 case CustomerIDnum of
  cnOberon: CustomOutput.OberonTrackChoices;
 end;
end;

procedure CloseTCwindows;
var
 i,winCount:    integer;
begin
 try
  winCount:=mainform.mdiChildCount;
  if winCount>0 then
   for i:=1 to winCount do
    begin
     mainform.ActiveMdiChild.close;
     mainform.ActiveMdiChild.free;
    end;
  if fgGenToolbar then gentoolbarwin.close;

 except;
 end;
end;

procedure TMainForm.OpenDisplay1Click(Sender: TObject);
var
 s,fname: string;
 code: integer;
begin
 opendialog.title:='Load Display Settings';
 opendialog.HelpContext:=367;
 opendialog.defaultext:='TCD';
 opendialog.filename:='';
 opendialog.filter:='Display Files | *.TCD';
 opendialog.initialdir:= Directories.datadir;
 opendialog.options:=[ofFileMustExist,ofHideReadOnly,ofPathMustExist];
 if opendialog.execute then
  try
   fname:=opendialog.filename;
   s:=Extractfilename(fname);
   DisFile:=RemoveExtension(s);
   CloseTCwindows;
   loadDisplayFile(s);
   SetPshowmax;
   for code:=0 to 2 do sortCodes(code);
   yearFormToggle;
   getFontWidths;
   CheckSelections;
   winshow;
  except
  end; {if execute}
end;

procedure TMainForm.SaveDisplay1Click(Sender: TObject);
var
 s,fname    : string;
 i: integer;
begin
 if usrPassLevel=utGen then
  begin
   showRestrictedMsg;  exit;
  end;
 savedialog.title:='Save Display Settings';
 savedialog.HelpContext:=366;
 savedialog.defaultext:='TCD';
 savedialog.filename:=DisFile;
 savedialog.filter:='Display Files | *.TCD';
 savedialog.initialdir:=Directories.datadir;
 if savedialog.execute then
  begin
   fname:=savedialog.filename;
   XML_DISPLAY.winOrderNum:=mdiChildCount;
   if XML_DISPLAY.winOrderNum>0 then
    for i:=0 to XML_DISPLAY.winOrderNum-1 do
     begin
      XML_DISPLAY.winOrder[i+1]:=mdiChildren[i].Tag;
      saveWinpos(mdiChildren[i]);
     end;
   if fgGenToolbar then
    begin
     inc(XML_DISPLAY.winOrderNum);
     XML_DISPLAY.winOrder[XML_DISPLAY.winOrderNum]:=wnGenTool;
    end;
   saveDisplayFile(fname);
   s:=Extractfilename(fname);
   DisFile:=RemoveExtension(s);
   UpdateWindow(wnInfo);
  end;
end;

procedure TMainForm.Timer2Timer(Sender: TObject);
begin
 if loadFinished then UpdateToolBar;
end;

procedure TMainForm.TagSelect1Click(Sender: TObject);
begin
 if NoStuds then exit;
 if CheckAccessRights(utStud,36,true) then
  begin
   if CheckAccessRights(utStud,5,true) then
    begin
     TagDialog:=tTagDialog.create(self);
     TagDialog.showmodal;
     TagDialog.free;   {release dlg}
     CheckAccessRights(utStud,5,false);
    end;
   CheckAccessRights(utStud,36,false)
  end;
end;

procedure TMainForm.Worksheet2Click(Sender: TObject);
begin
  if not(wnFlag[wnWorksheet]) then
    exit;
  if not(fgWStoolbar) then
    WStoolbarSelect
  else
    WorkSheetToolbar.close;
end;

procedure TMainForm.ShowWorksheetExecute(Sender: TObject);
begin
 WorksheetWinSelect;
end;

initialization
 FileNames:= TFileNames.Create;
 Directories:= TDirectories.Create;
 CF_AMIG_Student_Data := RegisterClipBoardFormat('CF_AMIG_Student_Data');
 CF_AMIG_Timetable_Data := RegisterClipBoardFormat('CF_AMIG_Timetable_Data');
 CF_AMIG_Block_Data := RegisterClipBoardFormat('CF_AMIG_Block_Data');

 PrinterOn:=false; PreviewOn:=false; TextFileOut:=false; CopyOut:=false;

 for i:=1 to nmbrWindows do
  begin
   winView[i]:=0;  XML_DISPLAY.winViewMax[i]:=0;
   wnFlag[i]:=false;
   XML_DISPLAY.winPos[i].height:=0;
  end;
 XML_DISPLAY.winViewMax[wnSucode]:=1;
 XML_DISPLAY.winViewMax[wnTecode]:=1;
 XML_DISPLAY.winViewMax[wnRocode]:=1;
 XML_DISPLAY.winViewMax[wnFac]:=1;
 XML_DISPLAY.winViewMax[wnGroupSub]:=1;
 XML_DISPLAY.winViewMax[wnTeFree]:=2;
 XML_DISPLAY.winViewMax[wnRoFree]:=2;
 XML_DISPLAY.winViewMax[wnTeTimes]:=2;
 XML_DISPLAY.winViewMax[wnStInput]:=5;
 XML_DISPLAY.winViewMax[wnStudentList]:=1;
 XML_DISPLAY.winViewMax[wnBlockClashes]:=3;
 XML_DISPLAY.winViewMAx[wnShowUsers]:=1;
 XML_DISPLAY.winViewMax[wnTeacherTt]:=1;
 XML_DISPLAY.winViewMax[wnRoomTt]:=1;
 XML_DISPLAY.winViewMax[wnStudentTt]:=1;
 XML_DISPLAY.winViewMax[wnGroupTe]:=3;

 dbgStr:='';

 UseNewTTWTimetable:=true;
  CoInitialize(nil);
finalization
  CoUnInitialize;
  FileNames.free;
  Directories.Free;


end.


