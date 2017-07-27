unit blcktool;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, ExtCtrls, TimeChartGlobals, AdvToolBar, StdCtrls, XML.DISPLAY;

type
  Tblocktoolbarwin = class(TForm)
    TtableToolBar2: TPanel;
    OpenBlockBtn2: TSpeedButton;
    SaveBlockBtn2: TSpeedButton;
    CopyBlocksBtn2: TSpeedButton;
    CreateBlocksBtn2: TSpeedButton;
    MoveSubBtn2: TSpeedButton;
    FixSubBtn2: TSpeedButton;
    SwapSubBtn2: TSpeedButton;
    LinkSubBtn2: TSpeedButton;
    SplitSubBtn2: TSpeedButton;
    AllocBtn2: TSpeedButton;
    ExcludeSubBtn2: TSpeedButton;
    SegregateBtn2: TSpeedButton;
    ClashHelpBtn2: TSpeedButton;
    SortSubBtn2: TSpeedButton;
    ReOrderBtn2: TSpeedButton;
    ExchangeBtn2: TSpeedButton;
    TtableToolBar: TPanel;
    AdvToolBar1: TAdvToolBar;
    OpenBlockBtn: TAdvToolBarButton;
    SaveBlockBtn: TAdvToolBarButton;
    CopyBlocksBtn: TAdvToolBarButton;
    CreateBlocksBtn: TAdvToolBarButton;
    MoveSubBtn: TAdvToolBarButton;
    SwapSubBtn: TAdvToolBarButton;
    ReOrderBtn: TAdvToolBarButton;
    SortSubBtn: TAdvToolBarButton;
    ClashHelpBtn: TAdvToolBarButton;
    SplitSubBtn: TAdvToolBarButton;
    AllocBtn: TAdvToolBarButton;
    ExcludeSubBtn: TAdvToolBarButton;
    LinkSubBtn: TAdvToolBarButton;
    FixSubBtn: TAdvToolBarButton;
    ExchangeBtn: TAdvToolBarButton;
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
    AdvToolBarSeparator14: TAdvToolBarSeparator;
    AdvToolBarSeparator15: TAdvToolBarSeparator;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OpenBlockBtn2Click(Sender: TObject);
    procedure SaveBlockBtn2Click(Sender: TObject);
    procedure CopyBlocksBtn2Click(Sender: TObject);
    procedure CreateBlocksBtn2Click(Sender: TObject);
    procedure MoveSubBtn2Click(Sender: TObject);
    procedure SwapSubBtn2Click(Sender: TObject);
    procedure ReOrderBtn2Click(Sender: TObject);
    procedure SortSubBtn2Click(Sender: TObject);
    procedure ClashHelpBtn2Click(Sender: TObject);
    procedure SplitSubBtn2Click(Sender: TObject);
    procedure AllocBtn2Click(Sender: TObject);
    procedure ExcludeSubBtn2Click(Sender: TObject);
    procedure LinkSubBtn2Click(Sender: TObject);
    procedure FixSubBtn2Click(Sender: TObject);
    procedure SegregateBtn2Click(Sender: TObject);
    procedure ExchangeBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  public
    procedure SetStatus;
  end;

var
  blocktoolbarwin: Tblocktoolbarwin;

implementation
uses tcommon,StCommon,main,printers,tcommon2,ttable, Block1;
{$R *.DFM}




procedure Tblocktoolbarwin.SetStatus;
var
 HasSubs: boolean;
begin
 countSubsInBlock;  HasSubs:=(subsinblock>0);
 if subsinblock=0 then SaveBlockBtn.enabled:=false
   else SaveBlockBtn.enabled:=SaveBlockFlag;
 ReOrderBtn.enabled:=HasSubs;  SortSubBtn.enabled:=HasSubs;
 ClashHelpBtn.enabled:=HasSubs; ExchangeBtn.enabled:=HasSubs;

 HasSubs:=(GroupSubs[0]>0);
 CreateBlocksBtn.Enabled:=HasSubs;
 SwapSubBtn.Enabled:=HasSubs;  SplitSubBtn.Enabled:=HasSubs;
 AllocBtn.Enabled:=HasSubs;    ExcludeSubBtn.Enabled:=HasSubs;
 LinkSubBtn.Enabled:=HasSubs;  FixSubBtn.Enabled:=HasSubs;
 // SegregateBtn.Enabled:=HasSubs; -- Button has been removed
end;


procedure Tblocktoolbarwin.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 savewinpos(self);
 fgBlockToolbar:=false;
 action:=cafree;
end;

procedure Tblocktoolbarwin.OpenBlockBtn2Click(Sender: TObject);
begin
 Blockwin.load1Click(Self);
end;

procedure Tblocktoolbarwin.SaveBlockBtn2Click(Sender: TObject);
begin
 Blockwin.save1Click(Self);
end;

procedure Tblocktoolbarwin.CopyBlocksBtn2Click(Sender: TObject);
begin
  Blockwin.CopyToWorksheet(Self);
end;

procedure Tblocktoolbarwin.CreateBlocksBtn2Click(Sender: TObject);
begin
 Blockwin.create1Click(Self);
end;

procedure Tblocktoolbarwin.MoveSubBtn2Click(Sender: TObject);
begin
 Blockwin.move1Click(Self);
end;

procedure Tblocktoolbarwin.SwapSubBtn2Click(Sender: TObject);
begin
 Blockwin.swap1Click(Self);
end;

procedure Tblocktoolbarwin.ReOrderBtn2Click(Sender: TObject);
begin
 Blockwin.reorderchoices1Click(Self);
end;

procedure Tblocktoolbarwin.SortSubBtn2Click(Sender: TObject);
begin
 Blockwin.sort1Click(Self);
end;

procedure Tblocktoolbarwin.ClashHelpBtn2Click(Sender: TObject);
begin
 Blockwin.clashhelp1Click(Self);
end;

procedure Tblocktoolbarwin.SplitSubBtn2Click(Sender: TObject);
begin
 Blockwin.splitsubject1Click(Self);
end;

procedure Tblocktoolbarwin.AllocBtn2Click(Sender: TObject);
begin
 Blockwin.autoallocation1Click(Self);
end;

procedure Tblocktoolbarwin.ExcludeSubBtn2Click(Sender: TObject);
begin
 Blockwin.excludesubjects1Click(Self);
end;

procedure Tblocktoolbarwin.LinkSubBtn2Click(Sender: TObject);
begin
 Blockwin.LinkSubjects1Click(Self);
end;

procedure Tblocktoolbarwin.FixSubBtn2Click(Sender: TObject);
begin
 Blockwin.fixSubjects1Click(Self);
end;

procedure Tblocktoolbarwin.SegregateBtn2Click(Sender: TObject);
begin
 Blockwin.segregate1Click(Self);
end;

procedure Tblocktoolbarwin.ExchangeBtn2Click(Sender: TObject);
begin
  Blockwin.DisplayExchangeBlocks(Self);
end;

procedure Tblocktoolbarwin.FormCreate(Sender: TObject);
begin
 setWindowDefaults(self,wnBlTool);
 fgBlockToolbar:=true;
 if wnFlag[wnBlock] then
  case XML_DISPLAY.fgBlockToolbarDock of
   1: try  {restore docked toolbar}
       ManualDock(Blockwin.Panel4);
      except
      end;
   2: try
       ManualDock(Blockwin.Panel7);
      except
      end;
  end; {case}
end;

end.
