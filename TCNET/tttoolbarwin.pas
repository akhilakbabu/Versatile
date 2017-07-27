unit tttoolbarwin;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, ExtCtrls, ComCtrls, ToolWin, TimeChartGlobals, StdCtrls, AdvToolBar, XML.TTABLE,
  XML.UTILS, XML.DISPLAY;

type
  TTtableToolbarWin = class(TForm)
    TtableToolBar2: TPanel;
    ttEntryBtn2: TSpeedButton;
    ttClashHelpBtn2: TSpeedButton;
    ttMoveBtn2: TSpeedButton;
    ttSolveBtn2: TSpeedButton;
    RoomFillBtn2: TSpeedButton;
    RoStripBtn2: TSpeedButton;
    WorksheetBtn2: TSpeedButton;
    HomeBtn2: TSpeedButton;
    ttGoToBtn2: TSpeedButton;
    ttSearchBtn2: TSpeedButton;
    ttAlterBtn: TSpeedButton;
    ttClassBtn2: TSpeedButton;
    ttOpenBtn2: TSpeedButton;
    ttSaveBtn2: TSpeedButton;
    ttLinkBtn2: TSpeedButton;
    TeFreeBtn2: TSpeedButton;
    RoFreeBtn2: TSpeedButton;
    TeLoadBtn2: TSpeedButton;
    Undo2: TSpeedButton;
    Redo2: TSpeedButton;
    ttBuildBtn2: TSpeedButton;
    Toolbar: TPanel;
    TtableToolbar: TAdvToolBar;
    ttOpenBtn: TAdvToolBarButton;
    ttSaveBtn: TAdvToolBarButton;
    WorksheetBtn: TAdvToolBarButton;
    TeFreeBtn: TAdvToolBarButton;
    RoFreeBtn: TAdvToolBarButton;
    TeLoadBtn: TAdvToolBarButton;
    ttBuildBtn: TAdvToolBarButton;
    ttClashHelpBtn: TAdvToolBarButton;
    ttMoveBtn: TAdvToolBarButton;
    ttSolveBtn: TAdvToolBarButton;
    RoomFillBtn: TAdvToolBarButton;
    RoStripBtn: TAdvToolBarButton;
    AdvToolBarSeparator2: TAdvToolBarSeparator;
    HomeBtn: TAdvToolBarButton;
    ttGoToBtn: TAdvToolBarButton;
    ttSearchBtn: TAdvToolBarButton;
    ttClassBtn: TAdvToolBarButton;
    ttLinkBtn: TAdvToolBarButton;
    Undo: TAdvToolBarButton;
    Redo: TAdvToolBarButton;
    AdvToolBarSeparator1: TAdvToolBarSeparator;
    AdvToolBarSeparator3: TAdvToolBarSeparator;
    lblInuse: TLabel;
    cboTimeTableInuse: TComboBox;
    AdvToolBarSeparator4: TAdvToolBarSeparator;
    lblTimeTable: TLabel;
    AdvToolBarSeparator5: TAdvToolBarSeparator;
    AdvToolBarSeparator6: TAdvToolBarSeparator;
    AdvToolBarSeparator7: TAdvToolBarSeparator;
    AdvToolBarSeparator8: TAdvToolBarSeparator;
    AdvToolBarSeparator9: TAdvToolBarSeparator;
    AdvToolBarSeparator10: TAdvToolBarSeparator;
    AdvToolBarSeparator11: TAdvToolBarSeparator;
    AdvToolBarSeparator12: TAdvToolBarSeparator;
    AdvToolBarSeparator13: TAdvToolBarSeparator;
    AdvToolBarSeparator14: TAdvToolBarSeparator;
    AdvToolBarSeparator15: TAdvToolBarSeparator;
    AdvToolBarSeparator16: TAdvToolBarSeparator;
    AdvToolBarSeparator17: TAdvToolBarSeparator;
    AdvToolBarSeparator18: TAdvToolBarSeparator;
    AdvToolBarSeparator19: TAdvToolBarSeparator;
    procedure ttEntryBtn2Click(Sender: TObject);
    procedure ttClashHelpBtn2Click(Sender: TObject);
    procedure ttMoveBtn2Click(Sender: TObject);
    procedure ttSolveBtn2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure HomeBtn2Click(Sender: TObject);
    procedure ttGoToBtn2Click(Sender: TObject);
    procedure ttSearchBtn2Click(Sender: TObject);
    procedure ttAlterBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ttOpenBtn2Click(Sender: TObject);
    procedure ttSaveBtn2Click(Sender: TObject);
    procedure ttClassBtn2Click(Sender: TObject);
    procedure ttLinkBtn2Click(Sender: TObject);
    procedure TeFreeBtn2Click(Sender: TObject);
    procedure RoFreeBtn2Click(Sender: TObject);
    procedure TeLoadBtn2Click(Sender: TObject);
    procedure Undo2Click(Sender: TObject);
    procedure Redo2Click(Sender: TObject);
    procedure WorksheetBtn2Click(Sender: TObject);
    procedure RoomFillBtn2Click(Sender: TObject);
    procedure RoStripBtn2Click(Sender: TObject);
    procedure RefreshTimeTable(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ttBuildBtn2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormEndDock(Sender, Target: TObject; X, Y: Integer);
  public
    procedure SetStatus;
    procedure RefreshInUse;
  end;

var
  TtableToolbarWin: TTtableToolbarWin;

implementation

uses
  tcommon,main,printers,tcommon2,ttable,TTundo, InUse;
{$R *.DFM}

procedure TTtableToolbarWin.SetStatus;
begin
  if Assigned(TtableToolbarWin) then     //and TtableToolbarWin.Active
  begin
    ttSaveBtn.enabled:=saveTimeFlag;
    ttLinkBtn.down:=XML_DISPLAY.EntrySelectionLink;
    if XML_DISPLAY.EntrySelectionLink then ttLinkBtn.hint:='Unlink windows from timetable'
     else ttLinkBtn.hint:='Link windows to timetable';
    Undo.Enabled:=(ttUndoPtr>0);
    Redo.Enabled:=(ttUndoPtr<ttUndoMax);
    Undo.Hint:=UndoHint;
    Redo.Hint:=RedoHint;
  end;
end;

procedure TTtableToolbarWin.ttEntryBtn2Click(Sender: TObject);
begin
 Ttablewin.entries1Click(self);
end;

procedure TTtableToolbarWin.ttClashHelpBtn2Click(Sender: TObject);
begin
 Ttablewin.clashhelp1Click(self);
end;

procedure TTtableToolbarWin.ttMoveBtn2Click(Sender: TObject);
begin
 Ttablewin.box1Click(self);
end;

procedure TTtableToolbarWin.ttSolveBtn2Click(Sender: TObject);
begin
 Ttablewin.solve1Click(self);
end;

procedure TTtableToolbarWin.FormActivate(Sender: TObject);
begin
 // #994
  if (usrPassLevel <> utTime) and (usrPassLevel <> utSuper) then
  begin
    cboTimeTableInUse.Enabled := false;
  end;

end;

procedure TTtableToolbarWin.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 savewinpos(self);
 fgTTtoolbar:=false;
 action:=cafree;
end;

procedure TTtableToolbarWin.HomeBtn2Click(Sender: TObject);
begin
 Ttablewin.home1Click(self);
end;

procedure TTtableToolbarWin.ttGoToBtn2Click(Sender: TObject);
begin
 Ttablewin.goto1Click(self);
end;

procedure TTtableToolbarWin.ttSearchBtn2Click(Sender: TObject);
begin
 Ttablewin.searchreplace1Click(self);
end;

procedure TTtableToolbarWin.ttAlterBtnClick(Sender: TObject);
begin
 Ttablewin.alter1Click(self);
end;

procedure TTtableToolbarWin.ttBuildBtn2Click(Sender: TObject);
begin
  TTableWin.Build1Click(self);
end;

procedure TTtableToolbarWin.FormCreate(Sender: TObject);
const
  Test : Integer = 57;
begin
 setWindowDefaults(self,wnTtTool);
 fgTTtoolbar:=true;
 try
   if wnFlag[wnTtable] then
    case XML_DISPLAY.fgTTtoolbarDock of {restore docked toolbar}
     1: try
         manualdock(ttableWin.Panel2)
        except
        end;
     2: try
         manualdock(ttableWin.Panel3)
        except
        end;
    end; {case}
 except
 end;
 // #994
  if (usrPassLevel <> utTime) and (usrPassLevel <> utSuper) then
  begin
    cboTimeTableInUse.Enabled := false;
  end;

  lblTimeTable.Caption := UpperCase(FileNames.CurentTimeTable);
end;

procedure TTtableToolbarWin.FormEndDock(Sender, Target: TObject; X, Y: Integer);
begin
  self.Align := alTop;
end;

procedure TTtableToolbarWin.FormPaint(Sender: TObject);
{var
  lSpecifyCurTtable: TSpecifyCurTtableDlg;
  i: Integer;}
begin
  {lSpecifyCurTtable := TSpecifyCurTtableDlg.Create(Application);
  try
    cboTimeTableInuse.Clear;
    for i := 0 to lSpecifyCurTtable.ComboBox1.Items.Count - 1 do
      cboTimeTableInuse.Items.Add(lSpecifyCurTtable.ComboBox1.Items[i]);
      cboTimeTableInuse.Text := lSpecifyCurTtable.ComboBox1.Text;
  finally
    FreeAndNil(lSpecifyCurTtable);
    cboTimeTableInuse.Items.IndexOf(TtInUseName)
  end;}
end;

procedure TTtableToolbarWin.FormShow(Sender: TObject);
begin
  RefreshInUse;
 // #994
  if (usrPassLevel <> utTime) and (usrPassLevel <> utSuper) then
  begin
    cboTimeTableInUse.Enabled := false;
  end;
end;

procedure TTtableToolbarWin.ttOpenBtn2Click(Sender: TObject);
begin
 MainForm.FileOpen(Sender);
end;

procedure TTtableToolbarWin.ttSaveBtn2Click(Sender: TObject);
begin
 MainForm.TtSaveExecute(Sender);
end;

procedure TTtableToolbarWin.ttClassBtn2Click(Sender: TObject);
begin
 Ttablewin.RollClasses1Click(Sender);
end;

procedure TTtableToolbarWin.ttLinkBtn2Click(Sender: TObject);
begin
 Ttablewin.LinkwindowsMitem1Click(Sender);
 ttLinkBtn.down:=XML_DISPLAY.EntrySelectionLink;
end;

procedure TTtableToolbarWin.TeFreeBtn2Click(Sender: TObject);
begin
 TeachersFreewinSelect;
end;

procedure TTtableToolbarWin.RoFreeBtn2Click(Sender: TObject);
begin
 RoomsFreewinSelect;
end;

procedure TTtableToolbarWin.TeLoadBtn2Click(Sender: TObject);
begin
 TeacherTimeswinSelect;
end;

procedure TTtableToolbarWin.Undo2Click(Sender: TObject);
begin
 Ttablewin.Undo1Click(self);
end;

procedure TTtableToolbarWin.Redo2Click(Sender: TObject);
begin
 Ttablewin.Redo1Click(self);
end;

procedure TTtableToolbarWin.RefreshInUse;
var
  fsRec:         Tsearchrec;
  FROMdir1,ttwName: string;
  i: smallint;
begin
  cboTimeTableInuse.clear;
  fsrec.name:='';
  FROMdir1:=Directories.datadir; if FROMdir1[length(FROMdir1)]<>'\' then FROMdir1:=FROMdir1+'\';
  findfirst(FROMdir1+'*'+XMLHelper.getTTW_EXTENSION('',JustTheExtension),faArchive,fsRec);
  while (fsRec.name>'') do
  begin
    ttwName:=uppercase(fsrec.name);
    ttwName:=copy(ttwName,1,pos(XMLHelper.getTTW_EXTENSION('',JustTheExtension),ttwName)-1);  //just the filename - no extension
    cboTimeTableInuse.AddItem(ttwName, nil);

    if findnext(fsRec)<>0 then fsrec.name:='';
  end; {while}
  SysUtils.findclose(fsRec);
  if trim(uppercase(FileNames.CurentTimeTable))>'' then
    if cboTimeTableInuse.items.Count>0 then
    begin
      i:= cboTimeTableInuse.Items.IndexOf(FileNames.CurentTimeTable);
      Application.ProcessMessages;
      if i>-1 then cboTimeTableInuse.ItemIndex:=i;
   end;
end;

procedure TTtableToolbarWin.RefreshTimeTable(Sender: TObject);
var
 OldTtInUseName,astr: string;
 k: smallint;
 f: file;
begin
// #994
  if (usrPassLevel <> utTime) and (usrPassLevel <> utSuper) then
  begin

   astr:=uppercase(trim(cboTimeTableInuse.Text));
   OldTtInUseName:=FileNames.CurentTimeTable;
   chdir(Directories.datadir);
   if fileexists(astr+XMLHelper.getTTW_EXTENSION('',JustTheExtension)) then FileNames.CurentTimeTable:=astr;
   if trim(FileNames.CurentTimeTable)='' then FileNames.CurentTimeTable:='Ttable';
   if (UpperCase(FileNames.CurentTimeTable)<>UpperCase(OldTtInUseName)) then
    begin
     RollMarkerExport1:=true;
     RollMarkerExport2:=true;
    end;
   try
    try
     doAssignFile(f,FileNames.CurentTimeTableConfiguration);
     rewrite(f,1);
     blockwrite(f,TtInUseNum,2);
     k:=length(FileNames.CurentTimeTable);
     blockwrite(f,k,2);
     if k>0 then blockwrite(f,FileNames.CurentTimeTable[1],k);
     k:=0;
     blockwrite(f,k,2);
    finally
     closefile(f);
    end;
   except
   end;
  end;
{var
  lSpecifyCurTtable: TSpecifyCurTtableDlg;
  i: Integer;
begin
  lSpecifyCurTtable := TSpecifyCurTtableDlg.Create(Application);
  try
    lSpecifyCurTtable.ComboBox1.ItemIndex := cboTimeTableInuse.ItemIndex;
    lSpecifyCurTtable.updateClick(nil);
  finally
    FreeAndNil(lSpecifyCurTtable);
  end;}
end;

procedure TTtableToolbarWin.WorksheetBtn2Click(Sender: TObject);
begin
 WorksheetWinSelect;
end;

procedure TTtableToolbarWin.RoomFillBtn2Click(Sender: TObject);
begin
 Ttablewin.RoomFill1Click(self);
end;

procedure TTtableToolbarWin.RoStripBtn2Click(Sender: TObject);
begin
 Ttablewin.RoomStrip1Click(self);
end;

end.


