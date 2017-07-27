 unit gentool;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, ExtCtrls, TimeChartGlobals, AdvToolBar, ImgList, AdvToolBarStylers, AdvMenus,
  XML.UTILS,XML.DISPLAY;

type
  Tgentoolbarwin = class(TForm)
    Toolbar2: TPanel;
    ttWinBtn2: TSpeedButton;
    studttBtn2: TSpeedButton;
    TeachTtBtn2: TSpeedButton;
    RoomTtBtn2: TSpeedButton;
    SubTtBtn2: TSpeedButton;
    InfoBtn2: TSpeedButton;
    BlockWinBtn2: TSpeedButton;
    GroupBtn2: TSpeedButton;
    FontBtn2: TSpeedButton;
    CascadeBtn2: TSpeedButton;
    TileBtn2: TSpeedButton;
    PrefBtn2: TSpeedButton;
    viewBtn2: TSpeedButton;
    NewDataBtn2: TSpeedButton;
    CutBtn2: TSpeedButton;
    CopyBtn2: TSpeedButton;
    PasteBtn2: TSpeedButton;
    DelBtn: TSpeedButton;
    PrintBtn2: TSpeedButton;
    StudListBtn2: TSpeedButton;
    SelectBtn2: TSpeedButton;
    PreviewBtn2: TSpeedButton;
    SubListBtn2: TSpeedButton;
    ttLinkBtn2: TSpeedButton;
    GrpSubBtn2: TSpeedButton;
    Toolbar: TPanel;
    AdvToolBar1: TAdvToolBar;
    viewBtn: TAdvToolBarButton;
    SelectBtn: TAdvToolBarButton;
    PrintBtn: TAdvToolBarButton;
    PreviewBtn: TAdvToolBarButton;
    PrefBtn: TAdvToolBarButton;
    AdvToolBarSeparator1: TAdvToolBarSeparator;
    StudListBtn: TAdvToolBarButton;
    GrpSubBtn: TAdvToolBarButton;
    SubListBtn: TAdvToolBarButton;
    BlockWinBtn: TAdvToolBarButton;
    ttWinBtn: TAdvToolBarButton;
    studttBtn: TAdvToolBarButton;
    TeachTtBtn: TAdvToolBarButton;
    InfoBtn: TAdvToolBarButton;
    AdvToolBarSeparator2: TAdvToolBarSeparator;
    NewDataBtn: TAdvToolBarButton;
    FontBtn: TAdvToolBarButton;
    ttLinkBtn: TAdvToolBarButton;
    GroupBtn: TAdvToolBarButton;
    AdvToolBarSeparator3: TAdvToolBarSeparator;
    CutBtn: TAdvToolBarButton;
    CopyBtn: TAdvToolBarButton;
    PasteBtn: TAdvToolBarButton;
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
    AdvToolBarSeparator14: TAdvToolBarSeparator;
    AdvToolBarSeparator15: TAdvToolBarSeparator;
    AdvToolBarSeparator16: TAdvToolBarSeparator;
    AdvToolBarSeparator17: TAdvToolBarSeparator;
    AdvToolBarSeparator18: TAdvToolBarSeparator;
    AdvToolBarSeparator19: TAdvToolBarSeparator;
    AdvToolBarSeparator20: TAdvToolBarSeparator;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ttWinBtn2Click(Sender: TObject);
    procedure studttBtn2Click(Sender: TObject);
    procedure TeachTtBtn2Click(Sender: TObject);
    procedure RoomTtBtn2Click(Sender: TObject);
    procedure SubTtBtn2Click(Sender: TObject);
    procedure BlockWinBtn2Click(Sender: TObject);
    procedure NewDataBtn2Click(Sender: TObject);
    procedure FontBtn2Click(Sender: TObject);
    procedure CascadeBtn2Click(Sender: TObject);
    procedure TileBtn2Click(Sender: TObject);
    procedure GroupBtn2Click(Sender: TObject);
    procedure InfoBtn2Click(Sender: TObject);
    procedure PrefBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CutBtn2Click(Sender: TObject);
    procedure CopyBtn2Click(Sender: TObject);
    procedure PasteBtn2Click(Sender: TObject);
    procedure DelBtnClick(Sender: TObject);
    procedure SelectBtn2Click(Sender: TObject);
    procedure StudListBtn2Click(Sender: TObject);
    procedure viewBtn2Click(Sender: TObject);
    procedure PrintBtn2Click(Sender: TObject);
    procedure PreviewBtn2Click(Sender: TObject);
    procedure SubListBtn2Click(Sender: TObject);
    procedure ttLinkBtn2Click(Sender: TObject);
    procedure GrpSubBtn2Click(Sender: TObject);
  public
    Procedure SetStatus;
  end;

var
  gentoolbarwin: Tgentoolbarwin;

implementation
uses tcommon,main,printers,tcommon2,ttable, Groupsel,
  Prefer, Studlist, Block1,Worksheet;
{$R *.DFM}


procedure Tgentoolbarwin.SetStatus;
var
 winnum: smallint;
 ok:         wordbool;
begin
 winnum:=0;
 if (mainform.mdichildcount>0) and (Assigned(MainForm.ActiveMDIChild)) then
   winnum:=mainform.activemdichild.tag;
 viewbtn.Enabled:=(winnum>0) and (XML_DISPLAY.winViewMax[winnum]>0);
 case winnum of
   wnFindStud,wnSubjectList,wnTimeList,wnStudentList,wnStInput,wnStudentTt,wnTtable,
   wnTeClash,wnRoClash,wnTeFree,wnCHelp,wnBlockClashes,wnTeList,
   wnRoFree,wnTeTimes,wnSuTimes,wnGroupTe,wnTeacherTt,
   wnRoomTt,wnSubjectTt,wnCmatrix: SelectBtn.enabled:=true
  else SelectBtn.enabled:=false;
 end; {case}

 PrintBtn.enabled:=(winnum>0);
 PreviewBtn.enabled:=(winnum>0);
 CopyBtn.enabled:=(winnum>0);
 ok:=GetClipStatus(winnum);

 try
  case winnum of
   wnBlock,wnTtable,wnWorksheet:
     begin
      CutBtn.enabled:=true;
      PasteBtn.enabled:=ok;
      DelBtn.enabled:=true;
     end;
   wnStudentList:
     begin
      PasteBtn.enabled:=ok;
      DelBtn.enabled:=false;
      CutBtn.enabled:=false;
     end;
   else
    begin
     CutBtn.enabled:=false;
     PasteBtn.enabled:=false;
     DelBtn.enabled:=false;
    end;
  end;
 except
 end;

end;



procedure Tgentoolbarwin.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 savewinpos(self);
 fgGenToolbar:=false;
 action:=cahide;
end;

procedure Tgentoolbarwin.ttLinkBtn2Click(Sender: TObject);
begin
  Ttablewin.LinkwindowsMitem1Click(Sender);
  ttLinkBtn.down:=XML_DISPLAY.EntrySelectionLink;
end;

procedure Tgentoolbarwin.ttWinBtn2Click(Sender: TObject);
begin
 TtableWinSelect;
end;

procedure Tgentoolbarwin.studttBtn2Click(Sender: TObject);
begin
 studentTtablewinSelect;
end;

procedure Tgentoolbarwin.TeachTtBtn2Click(Sender: TObject);
begin
 teachTtablewinSelect;
end;

procedure Tgentoolbarwin.RoomTtBtn2Click(Sender: TObject);
begin
 roomTtablewinSelect;
end;

procedure Tgentoolbarwin.SubTtBtn2Click(Sender: TObject);
begin
 subjectTtablewinSelect;
end;

procedure Tgentoolbarwin.BlockWinBtn2Click(Sender: TObject);
begin
 BlockwinSelect;
end;

procedure Tgentoolbarwin.NewDataBtn2Click(Sender: TObject);
begin
 mainform.NewDataExecute(Sender);
end;

procedure Tgentoolbarwin.FontBtn2Click(Sender: TObject);
begin
 MainForm.SetFontExecute(sender);
end;

procedure Tgentoolbarwin.CascadeBtn2Click(Sender: TObject);
begin
 mainform.Cascade;
end;

procedure Tgentoolbarwin.TileBtn2Click(Sender: TObject);
begin
 if VertTile then mainform.Tilemode:=tbVertical else mainform.Tilemode:=tbHorizontal;
 VertTile:=not(VertTile);
 mainform.Tile;
end;

procedure Tgentoolbarwin.GroupBtn2Click(Sender: TObject);
begin
 mainform.Select2Click(self);
end;

procedure Tgentoolbarwin.GrpSubBtn2Click(Sender: TObject);
begin
  mainform.YearSubjects1.Click;
end;

procedure Tgentoolbarwin.InfoBtn2Click(Sender: TObject);
begin
 infoWinSelect;
end;

procedure Tgentoolbarwin.PrefBtn2Click(Sender: TObject);
begin
 mainform.PrefsExecute(self);
end;

procedure Tgentoolbarwin.FormCreate(Sender: TObject);
begin
 setWindowDefaults(self,wnGenTool);
 NewDataBtn.hint:='Current data directory is:'+Directories.datadir;
 fgGenToolbar:=true;
 if not(loadFinished) then exit;
 case XML_DISPLAY.fgGenToolbarDock of {dock toolbar}
  1:  manualdock(mainform.Panel4);
  2:  manualdock(mainform.panel6);
 end;  {case} 
end;

procedure Tgentoolbarwin.CutBtn2Click(Sender: TObject);
var
 winNum: smallint;
begin
 winNum:=Mainform.activeMDIchild.tag;
 case winNum of
  wnBlock:  blockwin.cut1Click(self);
  wnTtable: Ttablewin.cut1Click(self);
  wnWorksheet: Worksheetwin.Cut1Click(self);
 end; {case}
end;

procedure Tgentoolbarwin.CopyBtn2Click(Sender: TObject);
var
 winNum: smallint;
begin
 winNum:=Mainform.activeMDIchild.tag;
 case winNum of
  wnBlock: blockwin.copy2Click(self);
  wnTtable: Ttablewin.copy1Click(self);
  wnWorksheet: Worksheetwin.Copy1Click(self);
  else
   mainform.CopyWinExecute(self);
 end; {case}
end;

procedure Tgentoolbarwin.PasteBtn2Click(Sender: TObject);
var
 winNum: smallint;
begin
 winNum:=Mainform.activeMDIchild.tag;
 case winNum of
  wnBlock: blockwin.paste1Click(self);
  wnStudentList: StudentListWin.paste1Click(self);
  wnTtable: Ttablewin.paste1Click(self);
  wnWorksheet: Worksheetwin.PasteData(self);
 end; {case}
end;

procedure Tgentoolbarwin.DelBtnClick(Sender: TObject);
var
 winNum: smallint;
begin
 winNum:=Mainform.activeMDIchild.tag;
 case winNum of
  wnBlock: blockwin.delete1Click(self);
  wnTtable: Ttablewin.delete1Click(self);
  wnWorksheet: Worksheetwin.Delete1Click(self);
 end; {case}
end;

procedure Tgentoolbarwin.SelectBtn2Click(Sender: TObject);
begin
 MainForm.SelectDlgExecute(Sender);
end;

procedure Tgentoolbarwin.StudListBtn2Click(Sender: TObject);
begin
 StudentListwinSelect;
end;

procedure Tgentoolbarwin.viewBtn2Click(Sender: TObject);
begin
 MainForm.NextViewExecute(Self);
end;

procedure Tgentoolbarwin.PrintBtn2Click(Sender: TObject);
begin
 MainForm.MainPrintExecute(self);
end;

procedure Tgentoolbarwin.PreviewBtn2Click(Sender: TObject);
begin
 MainForm.DoPrintPreviewExecute(self);
end;

procedure Tgentoolbarwin.SubListBtn2Click(Sender: TObject);
begin
 SubListWinSelect;
end;

end.
