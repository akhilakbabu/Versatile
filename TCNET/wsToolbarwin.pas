unit wsToolbarwin;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, ExtCtrls, ComCtrls, ToolWin, TimeChartGlobals, AdvToolBar, XML.DISPLAY;

type
  TWorkSheetToolbar = class(TForm)
    wsToolBar2: TPanel;
    wsEntryBtn2: TSpeedButton;
    MultipleBtn2: TSpeedButton;
    ttBuildBtn2: TSpeedButton;
    TargetBtn2: TSpeedButton;
    ttSwapBlockBtn2: TSpeedButton;
    TeSwapBtn2: TSpeedButton;
    RoSwapBtn2: TSpeedButton;
    ttAlterBtn2: TSpeedButton;
    ttClassBtn2: TSpeedButton;
    ttOpenBtn2: TSpeedButton;
    ttSaveBtn2: TSpeedButton;
    BclashBtn2: TSpeedButton;
    TeLoadBtn2: TSpeedButton;
    Undo2: TSpeedButton;
    Redo2: TSpeedButton;
    ttWinBtn2: TSpeedButton;
    wsToolBar: TPanel;
    AdvToolBar1: TAdvToolBar;
    ttOpenBtn: TAdvToolBarButton;
    ttSaveBtn: TAdvToolBarButton;
    ttWinBtn: TAdvToolBarButton;
    BclashBtn: TAdvToolBarButton;
    TeLoadBtn: TAdvToolBarButton;
    MultipleBtn: TAdvToolBarButton;
    TargetBtn: TAdvToolBarButton;
    ttBuildBtn: TAdvToolBarButton;
    ttSwapBlockBtn: TAdvToolBarButton;
    TeSwapBtn: TAdvToolBarButton;
    RoSwapBtn: TAdvToolBarButton;
    Undo: TAdvToolBarButton;
    Redo: TAdvToolBarButton;
    AdvToolBarSeparator1: TAdvToolBarSeparator;
    AdvToolBarSeparator2: TAdvToolBarSeparator;
    AdvToolBarSeparator3: TAdvToolBarSeparator;
    AdvToolBarSeparator4: TAdvToolBarSeparator;
    AdvToolBarSeparator5: TAdvToolBarSeparator;
    AdvToolBarSeparator6: TAdvToolBarSeparator;
    AdvToolBarSeparator7: TAdvToolBarSeparator;
    AdvToolBarSeparator8: TAdvToolBarSeparator;
    AdvToolBarSeparator9: TAdvToolBarSeparator;
    AdvToolBarSeparator10: TAdvToolBarSeparator;
    AdvToolBarSeparator11: TAdvToolBarSeparator;
    AdvToolBarSeparator12: TAdvToolBarSeparator;
    AdvToolBarSeparator13: TAdvToolBarSeparator;
    procedure wsEntryBtn2Click(Sender: TObject);
    procedure ttBuildBtn2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ttSwapBlockBtn2Click(Sender: TObject);
    procedure TeSwapBtn2Click(Sender: TObject);
    procedure RoSwapBtn2Click(Sender: TObject);
    procedure ttAlterBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ttOpenBtn2Click(Sender: TObject);
    procedure ttSaveBtn2Click(Sender: TObject);
    procedure ttClassBtn2Click(Sender: TObject);
    procedure TeLoadBtn2Click(Sender: TObject);
    procedure Undo2Click(Sender: TObject);
    procedure Redo2Click(Sender: TObject);
    procedure BclashBtn2Click(Sender: TObject);
    procedure ttWinBtn2Click(Sender: TObject);
    procedure MultipleBtn2Click(Sender: TObject);
    procedure TargetBtn2Click(Sender: TObject);
  public
    procedure SetStatus;
  end;

var
  WorkSheetToolbar: TWorkSheetToolbar;

implementation
uses tcommon,main,printers,tcommon2,Worksheet, TTundo, Ttable;
{$R *.DFM}

{
worksheet flags defined:
 fwsEntryDlgUp 
fgWStoolbar
fgReshowWStoolbar
fgWStoolbarDock
wnWsTool
}



procedure TWorkSheetToolbar.SetStatus;
begin
 ttSaveBtn.enabled:=saveTimeFlag;
 Undo.Enabled:=(ttUndoPtr>0);
 Redo.Enabled:=(ttUndoPtr<ttUndoMax);
 Undo.Hint:=UndoHint;
 Redo.Hint:=RedoHint;
end;


procedure TWorkSheetToolbar.wsEntryBtn2Click(Sender: TObject);
begin
 Worksheetwin.entries1Click(self);
end;

procedure TWorkSheetToolbar.ttBuildBtn2Click(Sender: TObject);
begin
 Worksheetwin.build1Click(self);
end;

procedure TWorkSheetToolbar.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 savewinpos(self);
 fgWStoolbar:=false;
 action:=cafree;
end;

procedure TWorkSheetToolbar.ttSwapBlockBtn2Click(Sender: TObject);
begin
 Worksheetwin.swapblocks1Click(self);
end;

procedure TWorkSheetToolbar.TeSwapBtn2Click(Sender: TObject);
begin
 Worksheetwin.swapteachers1Click(self);
end;

procedure TWorkSheetToolbar.RoSwapBtn2Click(Sender: TObject);
begin
 Worksheetwin.swaprooms1Click(self);
end;

procedure TWorkSheetToolbar.ttAlterBtn2Click(Sender: TObject);
begin
 Worksheetwin.alter1Click(self);
end;

procedure TWorkSheetToolbar.FormCreate(Sender: TObject);
begin
 setWindowDefaults(self,wnTtTool);
 fgWStoolbar:=true;
 if wnFlag[wnWorksheet] then
  case XML_DISPLAY.fgWStoolbarDock of {restore docked toolbar}
   1: try
       manualdock(Worksheetwin.Panel2)
      except
      end;
   2: try
       manualdock(Worksheetwin.Panel3)
      except
      end;
  end; {case}
end;

procedure TWorkSheetToolbar.ttOpenBtn2Click(Sender: TObject);
begin
 MainForm.FileOpen(Sender);
end;

procedure TWorkSheetToolbar.ttSaveBtn2Click(Sender: TObject);
begin
 MainForm.TtSaveExecute(Sender);
end;

procedure TWorkSheetToolbar.ttClassBtn2Click(Sender: TObject);
begin
 Ttablewin.RollClasses1Click(Sender);
end;

procedure TWorkSheetToolbar.TeLoadBtn2Click(Sender: TObject);
begin
 TeacherTimeswinSelect;
end;

procedure TWorkSheetToolbar.Undo2Click(Sender: TObject);
begin
 Worksheetwin.Undo1Click(self);
end;

procedure TWorkSheetToolbar.Redo2Click(Sender: TObject);
begin
 Worksheetwin.Redo1Click(self);
end;

procedure TWorkSheetToolbar.BclashBtn2Click(Sender: TObject);
begin
 BlockClasheswinSelect;
end;

procedure TWorkSheetToolbar.ttWinBtn2Click(Sender: TObject);
begin
 TtableWinSelect;
end;

procedure TWorkSheetToolbar.MultipleBtn2Click(Sender: TObject);
begin
 Worksheetwin.Multiples1Click(self);
end;

procedure TWorkSheetToolbar.TargetBtn2Click(Sender: TObject);
begin
 Worksheetwin.TargetTimes1Click(self);
end;

end.


