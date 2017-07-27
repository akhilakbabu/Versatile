unit tttoolbarwin;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, ExtCtrls, ComCtrls, ToolWin, TimeChartGlobals, StdCtrls, ImgList, AdvToolBar;

type
  TTtableToolbarWin = class(TForm)
    TtableToolBar: TPanel;
    ttEntryBtn: TSpeedButton;
    ttClashHelpBtn: TSpeedButton;
    ttMoveBtn: TSpeedButton;
    ttSolveBtn: TSpeedButton;
    RoomFillBtn: TSpeedButton;
    RoStripBtn: TSpeedButton;
    WorksheetBtn: TSpeedButton;
    HomeBtn: TSpeedButton;
    ttGoToBtn: TSpeedButton;
    ttSearchBtn: TSpeedButton;
    ttAlterBtn: TSpeedButton;
    ttClassBtn: TSpeedButton;
    ttOpenBtn: TSpeedButton;
    ttSaveBtn: TSpeedButton;
    ttLinkBtn: TSpeedButton;
    TeFreeBtn: TSpeedButton;
    RoFreeBtn: TSpeedButton;
    TeLoadBtn: TSpeedButton;
    Undo: TSpeedButton;
    Redo: TSpeedButton;
    cboTimeTableInuse: TComboBox;
    lblInuse: TLabel;
    ttBuildBtn: TSpeedButton;
    SpeedButton1: TSpeedButton;
    AdvToolBar1: TAdvToolBar;
    AdvToolBarButton2: TAdvToolBarButton;
    AdvToolBarSeparator1: TAdvToolBarSeparator;
    AdvToolBarButton1: TAdvToolBarButton;
    procedure ttEntryBtnClick(Sender: TObject);
    procedure ttClashHelpBtnClick(Sender: TObject);
    procedure ttMoveBtnClick(Sender: TObject);
    procedure ttSolveBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure HomeBtnClick(Sender: TObject);
    procedure ttGoToBtnClick(Sender: TObject);
    procedure ttSearchBtnClick(Sender: TObject);
    procedure ttAlterBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ttOpenBtnClick(Sender: TObject);
    procedure ttSaveBtnClick(Sender: TObject);
    procedure ttClassBtnClick(Sender: TObject);
    procedure ttLinkBtnClick(Sender: TObject);
    procedure TeFreeBtnClick(Sender: TObject);
    procedure RoFreeBtnClick(Sender: TObject);
    procedure TeLoadBtnClick(Sender: TObject);
    procedure UndoClick(Sender: TObject);
    procedure RedoClick(Sender: TObject);
    procedure WorksheetBtnClick(Sender: TObject);
    procedure RoomFillBtnClick(Sender: TObject);
    procedure RoStripBtnClick(Sender: TObject);
    procedure RefreshTimeTable(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ttBuildBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
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
    ttLinkBtn.down:=EntrySelectionLink;
    if EntrySelectionLink then ttLinkBtn.hint:='Unlink windows from timetable'
     else ttLinkBtn.hint:='Link windows to timetable';
    Undo.Enabled:=(ttUndoPtr>0);
    Redo.Enabled:=(ttUndoPtr<ttUndoMax);
    Undo.Hint:=UndoHint;
    Redo.Hint:=RedoHint;
  end;
end;

procedure TTtableToolbarWin.ttEntryBtnClick(Sender: TObject);
begin
 Ttablewin.entries1Click(self);
end;

procedure TTtableToolbarWin.ttClashHelpBtnClick(Sender: TObject);
begin
 Ttablewin.clashhelp1Click(self);
end;

procedure TTtableToolbarWin.ttMoveBtnClick(Sender: TObject);
begin
 Ttablewin.box1Click(self);
end;

procedure TTtableToolbarWin.ttSolveBtnClick(Sender: TObject);
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

procedure TTtableToolbarWin.HomeBtnClick(Sender: TObject);
begin
 Ttablewin.home1Click(self);
end;

procedure TTtableToolbarWin.ttGoToBtnClick(Sender: TObject);
begin
 Ttablewin.goto1Click(self);
end;

procedure TTtableToolbarWin.ttSearchBtnClick(Sender: TObject);
begin
 Ttablewin.searchreplace1Click(self);
end;

procedure TTtableToolbarWin.ttAlterBtnClick(Sender: TObject);
begin
 Ttablewin.alter1Click(self);
end;

procedure TTtableToolbarWin.ttBuildBtnClick(Sender: TObject);
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
    case fgTTtoolbarDock of {restore docked toolbar}
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

procedure TTtableToolbarWin.ttOpenBtnClick(Sender: TObject);
begin
 MainForm.FileOpen(Sender);
end;

procedure TTtableToolbarWin.ttSaveBtnClick(Sender: TObject);
begin
 MainForm.TtSaveExecute(Sender);
end;

procedure TTtableToolbarWin.ttClassBtnClick(Sender: TObject);
begin
 Ttablewin.RollClasses1Click(Sender);
end;

procedure TTtableToolbarWin.ttLinkBtnClick(Sender: TObject);
begin
 Ttablewin.LinkwindowsMitem1Click(Sender);
 ttLinkBtn.down:=EntrySelectionLink;
end;

procedure TTtableToolbarWin.TeFreeBtnClick(Sender: TObject);
begin
 TeachersFreewinSelect;
end;

procedure TTtableToolbarWin.RoFreeBtnClick(Sender: TObject);
begin
 RoomsFreewinSelect;
end;

procedure TTtableToolbarWin.TeLoadBtnClick(Sender: TObject);
begin
 TeacherTimeswinSelect;
end;

procedure TTtableToolbarWin.UndoClick(Sender: TObject);
begin
 Ttablewin.Undo1Click(self);
end;

procedure TTtableToolbarWin.RedoClick(Sender: TObject);
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
  FROMdir1:=datadir; if FROMdir1[length(FROMdir1)]<>'\' then FROMdir1:=FROMdir1+'\';
  findfirst(FROMdir1+'*'+XMLConversionHelper.OLD_TTW,faArchive,fsRec);
  while (fsRec.name>'') do
  begin
    ttwName:=uppercase(fsrec.name);
    ttwName:=copy(ttwName,1,pos(XMLConversionHelper.OLD_TTW,ttwName)-1);  //just the filename - no extension
    cboTimeTableInuse.AddItem(ttwName, nil);

    if findnext(fsRec)<>0 then fsrec.name:='';
  end; {while}
  SysUtils.findclose(fsRec);
  if trim(uppercase(TtInUseName))>'' then
    if cboTimeTableInuse.items.Count>0 then
    begin
      i:= cboTimeTableInuse.Items.IndexOf(TtInUseName);
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
   OldTtInUseName:=TtInUseName;
   chdir(datadir);
   if fileexists(astr+XMLConversionHelper.OLD_TTW) then TtInUseName:=astr;
   if trim(TtInUseName)='' then TtInUseName:='Ttable';
   if (UpperCase(TtInUseName)<>UpperCase(OldTtInUseName)) then
    begin
     RollMarkerExport1:=true;
     RollMarkerExport2:=true;
    end;
   try
    try
     doAssignFile(f,InuseDataFile);
     rewrite(f,1);
     blockwrite(f,TtInUseNum,2);
     k:=length(TtInUseName);
     blockwrite(f,k,2);
     if k>0 then blockwrite(f,TtInUseName[1],k);
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

procedure TTtableToolbarWin.WorksheetBtnClick(Sender: TObject);
begin
 WorksheetWinSelect;
end;

procedure TTtableToolbarWin.RoomFillBtnClick(Sender: TObject);
begin
 Ttablewin.RoomFill1Click(self);
end;

procedure TTtableToolbarWin.RoStripBtnClick(Sender: TObject);
begin
 Ttablewin.RoomStrip1Click(self);
end;

end.


