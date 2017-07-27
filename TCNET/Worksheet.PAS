unit Worksheet;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, grids, StdCtrls, Menus, TimeChartGlobals,ClassDefs, XML.UTILS,
  GlobalToTcAndTcextra, XML.DISPLAY, XML.TEACHERS;

type
  TWorksheetwin = class(TForm)
    Panel1                               : TPanel;
    StringGrid1                          : TStringGrid;
    Label1                               : TLabel;
    Label2                               : TLabel;
    Image1                               : TImage;
    PopupMenu1                           : TPopupMenu;
    N1                                   : TMenuItem;
    PrintSetup1                          : TMenuItem;
    Print1                               : TMenuItem;
    MainMenu1                            : TMainMenu;
    Timetable1                           : TMenuItem;
    Configure1                           : TMenuItem;
    Version1                             : TMenuItem;
    Years1                               : TMenuItem;
    Days1                                : TMenuItem;
    TimeSlots1                           : TMenuItem;
    Levels1                              : TMenuItem;
    Timetable2                           : TMenuItem;
    N2                                   : TMenuItem;
    Entries1                             : TMenuItem;
    Build1                               : TMenuItem;
    Multiples1: TMenuItem;
    BlockClashes1                        : TMenuItem;
    Clear1                               : TMenuItem;
    Alter1                               : TMenuItem;
    SwapBlocks1                          : TMenuItem;
    SwapTeachers1                        : TMenuItem;
    SwapRooms1                           : TMenuItem;
    Entries2                             : TMenuItem;
    ClashHelp2                           : TMenuItem;
    Multiple2: TMenuItem;
    Build2                               : TMenuItem;
    Alter2                               : TMenuItem;
    ShowSubjectTimetable1                : TMenuItem;
    ShowTeacherTimetable1                : TMenuItem;
    ShowRoomTimetable1                   : TMenuItem;
    ShowClassTimetable1                  : TMenuItem;
    Size1                                : TMenuItem;
    Edit1                                : TMenuItem;
    Cut1                                 : TMenuItem;
    Copy1                                : TMenuItem;
    Paste1                               : TMenuItem;
    Delete1                              : TMenuItem;
    Panel2                               : TPanel;
    Panel3                               : TPanel;
    Panel4                               : TPanel;
    Panel5                               : TPanel;
    Blocks1                              : TMenuItem;
    RollClasses1                         : TMenuItem;
    N4                                   : TMenuItem;
    N5                                   : TMenuItem;
    SelectAll1                           : TMenuItem;
    InUse1: TMenuItem;
    Worksheet1: TMenuItem;
    TargetTimes1: TMenuItem;
    N6: TMenuItem;
    N3: TMenuItem;
    Undo1: TMenuItem;
    Redo1: TMenuItem;
    lblMultipleValue: TLabel;
    BlockClashes2: TMenuItem;
    mniTeacherLoadonWorksheet1: TMenuItem;
    popWorksheetN1: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; Col, Row: longint; var
                                    CanSelect: boolean);
    procedure StringGrid1DrawCell(Sender: TObject; Col, Row: longint; Rect: TRect;
                                  state: TGridDrawState);
    procedure StringGrid1TopLeftChanged(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StringGrid1MouseDown(Sender: TObject; Button: TMouseButton; Shift:
                                   TShiftState; X, y: integer);
    procedure Version1Click(Sender: TObject);
    procedure Years1Click(Sender: TObject);
    procedure Days1Click(Sender: TObject);
    procedure TimeSlots1Click(Sender: TObject);
    procedure Levels1Click(Sender: TObject);
    procedure StringGrid1KeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure Entries1Click(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure SwapBlocks1Click(Sender: TObject);
    procedure SwapTeachers1Click(Sender: TObject);
    procedure SwapRooms1Click(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure Build1Click(Sender: TObject);
    procedure Alter1Click(Sender: TObject);
    procedure Timetable1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure ShowSubjectTimetable1Click(Sender: TObject);
    procedure ShowTeacherTimetable1Click(Sender: TObject);
    procedure ShowRoomTimetable1Click(Sender: TObject);
    procedure ShowClassTimetable1Click(Sender: TObject);
    procedure Size1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Cut1Click(Sender: TObject);
    procedure PasteData(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure Blocks1Click(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure Panel3DockOver(Sender: TObject; Source: TDragDockObject; X, y: integer;
                             state: TDragState; var Accept: boolean);
    procedure Panel2DockOver(Sender: TObject; Source: TDragDockObject; X, y: integer;
                             state: TDragState; var Accept: boolean);
    procedure Panel2DockDrop(Sender: TObject; Source: TDragDockObject; X, y: integer);
    procedure Panel3DockDrop(Sender: TObject; Source: TDragDockObject; X, y: integer);
    procedure RollClasses1Click(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure SelectAll1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure InUse1Click(Sender: TObject);
    procedure Undo1Click(Sender: TObject);
    procedure Redo1Click(Sender: TObject);
    procedure Multiples1Click(Sender: TObject);
    procedure TargetTimes1Click(Sender: TObject);
    procedure BlockClashes2Click(Sender: TObject);
    procedure DisplayTeacherLoadOnWorksheet(Sender: TObject);
    procedure DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure DropSubject(Sender, Source: TObject; X, Y: Integer);
    procedure FormShow(Sender: TObject);
  private
    procedure ShowCurrentCell;
    procedure copyWStextToClipboard;
    procedure ClearWStext(doPush: boolean);
    procedure GetSelection(var x1,x2,y1,y2: smallint);
    procedure parseClipWSText;
    function GetSelectedTeacher: Integer;
  public
    procedure updateWSClashBar;
    procedure InitWSwin;
    procedure restoreWSselection;
  end;

function FindWSrow(y,L:byte): integer;
procedure BringIntoView;
procedure wsMoveSelect(moveType: byte);
procedure WSclash;
procedure WSclashtotal;
{
AM's list

TCE Ideas
(a) Work ahead - base on calendar, if no file create a new one based
on date.
(b) lock timetable cycle to calendar so timetable day automatically
selected
(d) create an event that can be applied to one or more days, teachers
and students involved so can automate changes and know which students
are left behind
(e) web based interface
(f) html formatted emails of daily extras list.



}

var
  Worksheetwin: TWorksheetwin;

procedure workSheetPrint;
procedure workSheetText;

implementation

uses
  main, tcommon, printers, ttprnsel, block1, wsEntry, Boxop, TeacherLoadOnWS,
  ttbClash, Build, wsAlter, tcommon2, clipbrd, showclas, TTundo, uAMGCommon,
  tcommon5, InUse, wsToolbarwin, wsMultiple, wsTarget;

{$R *.DFM}

 type TPrintWorksheetWin=class(TPrintDrawWin)
  public
   procedure head; override;
   procedure SetTabs; override;
   procedure PrintWorksheet;
 end;

 type TOutWorksheetWin=class(TOutputWin)
  public
   procedure head; override;
   procedure OutWorksheet;
 end;

type
  tpteon = array [0..nmbrteachers, 0..nmbrPeriods] of integer;

var
  PrintWorksheetWin:    TPrintWorksheetWin;
  OutWorksheetWin:     TOutWorksheetWin;
  doubleclick     : bool;
  drawingInProcess: bool;
  drawingWSclashBar : bool;
  controlkeyFlg   : bool=false;
  scalingGridCellsFlag: wordbool=false;


function FindWSrow(y,L:byte): integer;
var
 i,count: integer;
begin
 count:=1;
 if y<years_minus_1 then
  for i:=years_minus_1 downto y+1 do
   inc(count,level[i]+1);
 inc(count,L);
 Result:=count
end;

procedure wsCalc(wsrow,wscol:  smallint);
var
 i,j,k,n:         smallint;
begin
 k:=0; n:=0;
 wscalcB:=wscol;
 j:=0;
 for i:=years_minus_1 downto 0 do
 begin
  inc(j,Level[i]+1);
  if j>=wsrow then
  begin
   k:=i;
   n:=Level[i]-(j-wsrow);
   break;
  end;
 end;
 wscalcY:=k;
 wscalcL:=n;
end;

procedure TWorksheetwin.restoreWSselection;
var
 j:     smallint;
 curSelection:        TgridRect;
begin
 j:=findWSrow(wsy,wsl);
 case wsBox of
  bxCell: begin {cell}
       CurSelection.left:=wsb;     CurSelection.right:=wsb;
       j:=findWSrow(wsy,wsl);
       CurSelection.top:=j;     CurSelection.bottom:=j;
       stringgrid1.selection:=CurSelection;
      end;
   bxLevel: begin {level}
       CurSelection.left:=0;     CurSelection.right:=stringgrid1.colcount;
       CurSelection.top:=j;     CurSelection.bottom:=j;
       stringgrid1.selection:=CurSelection;
      end;
   bxYear: begin {year}
       CurSelection.left:=0;     CurSelection.right:=stringgrid1.colcount;
       j:=findWSrow(wsy,0);
       CurSelection.top:=j;     CurSelection.bottom:=j+level[wsy];
       stringgrid1.selection:=CurSelection;
      end;
   bxYrTime: begin {year timeslot}
       CurSelection.left:=wsb;    CurSelection.right:=wsb;
       j:=findWSrow(wsy,0);
       CurSelection.top:=j;     CurSelection.bottom:=j+level[ny];
       stringgrid1.selection:=CurSelection;
      end;
   bxTime: begin {timeslot/period}
       CurSelection.left:=wsb;     CurSelection.right:=wsb;
       CurSelection.top:=0;     CurSelection.bottom:=stringgrid1.rowcount;
       stringgrid1.selection:=CurSelection;
      end;
   bxBlock: begin end; {block}
   bxAll: begin
       CurSelection.left:=0;     CurSelection.right:=stringgrid1.colcount;
       CurSelection.top:=0;     CurSelection.bottom:=stringgrid1.rowcount;
       stringgrid1.selection:=CurSelection;
      end;
 end; {case}
 ShowCurrentCell;
end;

procedure BringIntoView;
var
  TRow,LCol,CurRow,CurCol,ShowCols,ShowRows,MaxRows,MaxCols: integer;
begin
 with Worksheetwin.StringGrid1 do
  begin
   MaxRows:=RowCount-1;  MaxCols:=ColCount-1;
   ShowCols:=VisibleColCount;
   if ShowCols<1 then ShowCols:=1;
   if ShowCols>MaxCols then ShowCols:=MaxCols;
   ShowRows:=VisibleRowCount;
   if ShowRows>MaxRows then ShowRows:=MaxRows;
   if ShowRows < 1 then ShowRows := 1;
   TRow:=TopRow; LCol:=wsB1;  {current top row & left col}
   CurRow:=FindWSrow(wsy,wsl); CurCol:=wsb;  {current position}
   if CurRow>RowCount then CurRow:=RowCount;
   if CurCol>ColCount then CurCol:=ColCount;

   if (CurCol>(LCol+ShowCols-1)) and (CurCol<(LCol+ShowCols+1)) then
      LCol:=CurCol-ShowCols+1;
   if (CurCol>LCol+ShowCols) then LCol := CurCol;
   if CurCol<LCol then LCol:=CurCol;
   if LCol<1 then LCol:=1;
   if LCol>ColCount-ShowCols then LCol:=ColCount-ShowCols;

   if (CurRow>(TRow+ShowRows-2)) and (CurRow<(TRow+ShowRows+1)) then
      TRow:=CurRow-ShowRows+2;
   if (CurRow>TRow+ShowRows) then TRow:=CurRow;
   if CurRow<TRow then TRow:=CurRow;
   if (TRow=CurRow) and (wsl=1) then dec(TRow);
   if TRow<1 then TRow:=1;
   if TRow>RowCount-ShowRows then TRow:=RowCount-ShowRows;
   wsCalc(TRow,LCol);
   wsb1:=wsCalcB; wsY1:=wsCalcY; wsL1:=wsCalcL;
   LeftCol:=LCol;
   TopRow:=TRow;
   Worksheetwin.ShowCurrentCell;
  end;
end;

procedure WSclashtotal;
var
 b: integer;
begin
 wsTclashTot:=0;
 wsRclashTot:=0;
 for b:=1 to nmbrBlocks do
 begin
  inc(wsTclashTot,wsTclash[b]);
  inc(wsRclashTot,wsRclash[b])
 end;
end;

procedure WSclash;
var
  b: integer;
begin
 try
  for b:=1 to nmbrblocks do wsBlockClash(b);
  WSclashtotal;
 except
  dbgi:=111;
 end;
end;

procedure TWorksheetwin.updateWSClashBar;
var
 b,i          : integer;
 blankwidth     : integer;
 theight        : integer;
 localx         : integer;
 basex          : integer;
 aRect          : TRect;
 tmpcanvasbitmap: Tbitmap;
 GridSpaceUsed  : integer;
begin
 if drawingWSclashBar then exit;
 drawingWSclashBar:=true;
 Image1.width:=width;
 Image1.height:=canvas.textheight('Ag')*2;
 {ensure canvas on image resizes so shove an image into it}
 tmpcanvasbitmap:=Tbitmap.Create;
 tmpcanvasbitmap.width:=Image1.width;
 tmpcanvasbitmap.height:=Image1.height;
 Image1.Picture.graphic:=tmpcanvasbitmap;
 tmpcanvasbitmap.Free;
 {restore font}
 RenewFont(Image1.canvas);
 aRect.top:=0; aRect.bottom:=Image1.height; aRect.left:=0;
 aRect.right:=Image1.width;
 Image1.canvas.brush.color:=FontColorPair[cpWorksheet,2];//clSilver;
 Image1.canvas.fillrect(aRect);
 blankwidth:=Image1.canvas.textwidth(' ');
 theight:=Image1.canvas.textheight('Ag');
 with StringGrid1 do
  begin
   if LeftCol<1 then LeftCol:=1;
   wsCalc(TopRow,LeftCol);
   b:=wsCalcB;
   basex:=ColWidths[0];
   inc(basex,gridLineWidth*2)
  end; {with Stringgrid1}
 WSclashtotal;
 Image1.canvas.font.color:=FontColorPair[cpTeach,1];
 Image1.canvas.textout(0,0,'T:'+IntToStr(wsTclashTot));
 Image1.canvas.font.color:=FontColorPair[cpRoom,1];
 Image1.canvas.textout(0,theight,'R:'+IntToStr(wsRclashTot));
 GridSpaceUsed:=0;
 for i:=StringGrid1.LeftCol to (StringGrid1.ColCount-1) do
  begin
   inc(GridSpaceUsed,StringGrid1.ColWidths[i]);
   if GridSpaceUsed>=StringGrid1.clientwidth then break;
  end;
 i:=0;
 while (basex<GridSpaceUsed) do
  begin
   localx:=basex+blankwidth*2+fwCodeBlank[0];
   Image1.canvas.font.color:=FontColorPair[cpTeach,1];
   Image1.canvas.textout(localx,0,IntToStr(wsTclash[b]));
   localx:=localx+blankwidth+fwCodeBlank[1];
   Image1.canvas.font.color:=FontColorPair[cpRoom,1];
   Image1.canvas.textout(localx,theight,IntToStr(wsRclash[b]));
   inc(basex,StringGrid1.ColWidths[StringGrid1.LeftCol+i]);
   inc(i);
   inc(basex,StringGrid1.gridLineWidth);
   inc(b);
  end; {while}
 drawingWSclashBar:=false
end;

procedure TWorksheetwin.InitWSwin;
var
 i,j:       smallint;
 y:         smallint;
 blankwidth:     smallint;
 topgap:         smallint;
 w4,colwidthmax:    smallint;
 rowheightmax:   smallint;
 curposCoord:    TgridCoord;
 curTgridRect:   TgridRect;
begin
 caption:='Worksheet  Version:'+Version+'  File:'+FileNames.LoadedTimeTable;
 worksheetWin.Font.Assign(XML_DISPLAY.tcFont);
 lblMultipleValue.Font.Assign(XML_DISPLAY.tcFont);
 lblMultipleValue.Font.Color:=clMaroon;
 RenewFont(canvas);
 RenewFont(stringgrid1.canvas);
 RenewFont(image1.canvas);

 blankwidth:=canvas.textwidth(' ');
 topgap:=blankwidth div 2;
 scalingGridCellsFlag:=true;
 with StringGrid1 do
  begin
   Colcount:=fixedcols+wsBlocks;
   if Colcount>(nmbrBlocks+1) then Colcount:=(nmbrBlocks+1);
   {set colwidths}
   colwidthmax:=canvas.textwidth(yearshort+'    ')+fwYearname;
   //check for class width in columns
   i:=canvas.textwidth('   ')+fwClass;
   if (i>colwidthmax) then colwidthmax:=i;
   colwidths[0]:=colwidthmax+4;
   colwidthmax:=1+fwCodeBlank[0]+fwCodeBlank[1]+fwCodeBlank[2]+blankwidth*4;
   w4:=canvas.textwidth(' Block:99 ');
   if w4>colwidthmax then colwidthmax:=w4;

   for i:=1 to (colcount-1) do colwidths[i]:=colwidthmax;
   j:=years;
   for i:=0 to years_minus_1 do inc(j,Level[i]);
   RowCount:=fixedrows+j;

   rowheightmax:=canvas.textheight('Ag')+topgap*2;
   for i:=0 to (rowCount-1) do StringGrid1.rowheights[i]:=rowheightmax;
   scalingGridCellsFlag:=false;

   if XML_DISPLAY.winpos[wnWorksheet].height>0 then
    begin
     scalingGridCellsFlag:=true;  {prevent topleftchange event-triggered code}
     leftcol:=wsB1; {restore col}
     y:=findWSrow(wsy1,wsl1);
     if (wsy1=wsy) and (wsl=wsl1) and (wsl=1) then dec(y);
     toprow:=y;  {restore row, 1 fixed row}
     scalingGridCellsFlag:=false;
     {restore selection}
     curposCoord.y:=findWSrow(wsy,wsl);
     curposCoord.x:=wsb;
     curTgridRect.topleft:=curposCoord;
     curTgridRect.bottomright:=curposCoord;
     { MUST assign entire record at once - but can read individual record fields}
     selection:=curTgridRect;
    end  {if winPos[wnWorksheet].height>0}
   else {init selection}
    begin
     curposCoord.x:=1;
     curposCoord.y:=2;
     curTgridRect.topleft:=curposCoord;
     curTgridRect.bottomright:=curposCoord;
     Stringgrid1.selection:=curTgridRect;
    end;
  end;
 panel1.height:=rowheightmax;
 label1.top:=0;
 label1.left:=panel1.clientwidth-label1.width;
 label2.top:=0;
 label2.left:=blankwidth div 2;
 label2.caption:='Top :'+yearshort+' '+yearname[years_minus_1]+' Lev:1 ';
 AlterWSflag:=false;
 UpdateWSclashbar;
 repaint;
 restoreWSselection;
end;

procedure TWorksheetwin.FormClose(Sender: TObject; var Action: TCloseAction);
var
  tmprect: TRect;
begin
 XML_DISPLAY.fgReshowWStoolbar:=fgWStoolbar;
 if fgWStoolbar then
  begin
   if (panel2.dockclientcount=1) or (panel3.dockclientcount=1) then
    begin
     tmprect.left:=XML_DISPLAY.winpos[wnWsTool].left;
     tmprect.top:=XML_DISPLAY.winpos[wnWsTool].top;
     tmprect.bottom:=tmprect.top+XML_DISPLAY.winpos[wnWsTool].height;
     tmprect.right:=tmprect.left+XML_DISPLAY.winpos[wnWsTool].width;
     WorkSheetToolbar.ManualFloat(tmprect);
    end;
   inc(XML_DISPLAY.winOrderNum);
   XML_DISPLAY.winOrder[XML_DISPLAY.winOrderNum]:=wnWsTool;
   WorkSheetToolbar.close;
  end;

 Action:=cafree;
 wnFlag[wnWorksheet]:=false; {need to create on next request}
 savewinpos(Self);
 if fwsEntryDlgUp then {release dlg if still up}
  begin
   wsEntrydlg.Free;
   fwsEntryDlgUp:=false
  end;
 if fwsMultDlgUp then {release dlg if still up}
  begin
   wsMultipleDlg.Free;
   fwsMultDlgUp:=false
  end;

end;

procedure TWorksheetwin.FormActivate(Sender: TObject);
begin
 Cut1.ShortCut:=ShortCut(word('X'),[ssCtrl]);
 Copy1.ShortCut:=ShortCut(word('C'),[ssCtrl]);
 Paste1.ShortCut:=ShortCut(word('V'),[ssCtrl]);
 Delete1.ShortCut:=ShortCut(46,[]);
 mainform.CopyWin.ShortCut:=ShortCut(word('C'),[ssCtrl]);
 if loadFinished and wnFlag[wnWorksheet] then updateWSClashBar;
 // #994
  if (usrPassLevel <> utTime) and (usrPassLevel <> utSuper) then
  begin
    InUse1.Enabled := false;
  end;
end;

procedure CheckWSdlgs;
begin
 if fwsEntryDlgUp then setwsEntryDlg;
 if fwsMultDlgUp then setwsMultipleDlg;
end;

procedure TWorksheetwin.ShowCurrentCell;
var
 mult: smallint;
begin
 case wsBox of
  bxCell: Label1.caption:='['+yearShort+' '+ Yearname[wsy]+
             ' Lev:'+IntToStr(wsl)+' Blk:'+IntToStr(wsb)+']  ';
  bxLevel: Label1.caption:='['+yearShort+' '+Yearname[wsy]+
               ' Lev:'+IntToStr(wsl)+']  ';
  bxYear: Label1.caption:='['+yearShort+' '+Yearname[wsy]+']  ';
  bxYrTime: Label1.caption:='['+yearShort+' '+Yearname[wsy]+
               ' Blk:'+IntToStr(wsb)+']  ';
  bxTime: Label1.caption:='[Blk:'+IntToStr(wsb)+']  ';
  bxBlock: Label1.caption:='['+yearShort+' '+Yearname[wsy]+
                ' Lev:'+IntToStr(wsl)+' Blk:'+IntToStr(wsb)+']  ';
 end;
 Label1.left:=Panel1.clientwidth-Label1.width;

 if wsBox=bxCell then
  begin
   mult:=FNws(wsb,wsy,wsl,8)^;
   if (mult>=0) and (mult<=wsMultNum) then
      lblMultipleValue.Caption:='Mult.'+wsMultName(mult);
  end
 else lblMultipleValue.Caption:='';
 lblMultipleValue.Left := (panel1.ClientWidth - lblMultipleValue.Width) div 2;

 if (blockclashesoldyear<>wsy) then
  begin
   UpdateWindow(wnBlockClashes);
   blockclashesoldyear:=wsy;
  end;
 CheckWSdlgs;
end;

procedure TWorksheetwin.StringGrid1SelectCell(Sender: TObject; Col, Row: longint;
              var CanSelect: boolean);
begin
 if controlkeyFlg then exit; {prevent cell selection changing on ctrl key press}
 wsCalc(Row,Col);
 wsb:=wsCalcB;  wsy:=wsCalcY; wsl:=wsCalcL;
 ShowCurrentCell;
 Worksheetwin.repaint;
 CheckWSdlgs;
end;

procedure TWorksheetwin.StringGrid1DrawCell(Sender: TObject; Col,
  Row: Longint; Rect: TRect; State: TGridDrawState);
var
 b,y,l:       smallint;
 i,su,te,ro:       smallint;// added to match ttable
 x:                 integer;
 IntPoint:      tpIntPoint;// added to match ttable
 tmpStr:            string;
 localx,localy,localWide:     integer;
 blankwidth,topgap:        integer;
 CellType:            integer; // added to match ttable
 flgDouble:    boolean; {first 3 bits of 7th byte}
 blockNumber:                  smallint; {last 5 bits of 7th byte}
 flgTclash,flgRclash:          boolean; {4th & 5th (vals 8 &16) bits of 8th byte}
 sByte,cByte:                  byte;
 aRect:                        Trect; {for aligning highlights}
 fontHeight:                   integer;


   procedure Setbrush;
   var
    myCol: Tcolor;
   begin
    if gdSelected in State then myCol:=FontColorHiLitePair[cpWorkSheet,1]
     else myCol:=FontColorHiLitePair[cpWorkSheet,2];
    StringGrid1.Canvas.Brush.Color:=myCol;
   end;

   procedure fcolor(col1: smallint);
   begin
    stringgrid1.canvas.font.color:=FontColorPair[col1,1]; {main color}
    stringgrid1.canvas.brush.color:=FontColorPair[col1,2];
   end;

   procedure topColor(col1:smallint);
   begin
    stringgrid1.canvas.font.color:=FontColorPair[col1,1]; {main color}
    SetBrush;
   end;

   Procedure OutString;
   begin
    aRect.left:=localx; aRect.Right:=aRect.Left+localWide;
    stringGrid1.canvas.fillrect(aRect);
    stringgrid1.canvas.TextOut(localx,localy,tmpStr);
   end;

begin
 x:=years;
 for i:=years_minus_1 downto 0 do inc(x,Level[i]);
 if (row>x) then exit; {bottom max}
 if (col>wsBlocks) then exit; {right max}
 wsCalc(row,col);
 b:=wsCalcB; y:=wsCalcY;  l:=wsCalcL;

 blankwidth:=stringgrid1.canvas.textwidth(' ');
 fontHeight:=stringgrid1.canvas.textheight('Ag');
 localx:=rect.left+blankwidth;
 topgap:=blankwidth div 2; localy:=rect.top+topgap;

 CellType:=0;
 if (col=0) and (row>0) then CellType:=1;
 if (row=0) and (col>0) then CellType:=2;
 if (col>0) and (row>0) then CellType:=3;

 if CellType=1 then  {yearname or roll class code}
  begin
   fcolor(cpWorksheet);
   if l=0 then
    begin
     tmpStr:=yearshort+' '+yearname[y];
    end
   else
    begin
     tmpStr:=ClassCode[ClassShown[l,y]];
     localx:=rect.right-stringgrid1.canvas.textwidth(tmpStr)-blankwidth;
    end;
   stringgrid1.canvas.TextOut(localx,localy,tmpStr);
  end;

 if CellType=2 then  {block numbers}
  begin
   fcolor(cpWorksheet);
   tmpStr:='Block:'+inttostr(b);
   localx:=(rect.left+rect.Right-stringgrid1.canvas.textwidth(tmpStr)) div 2;
   stringgrid1.canvas.TextOut(localx,localy,tmpStr);
  end;

 if (Col>0) and (Row>0) then
  begin
   SetBrush;
   StringGrid1.Canvas.FillRect(Rect);
  end;

 if (CellType=3) and (l>0) then {timetable entry}   // skip for now
  begin
   aRect.top:=localy; aRect.bottom:=aRect.top+fontHeight;
   IntPoint:=FNws(b,y,l,0);
   sByte:=FNwsByte(b,y,l,6)^;
   cByte:=FNwsByte(b,y,l,7)^;
   su:=IntPoint^; inc(IntPoint);
   te:=IntPoint^; inc(IntPoint);
   ro:=IntPoint^;
   flgDouble:=((sByte and 1)=1);
   blockNumber:=FNgetWSblockNumber(b,y,l);
   flgTclash:=((cByte and 8)=8);
   flgRclash:=((cByte and 16)=16);
   if su>LabelBase then {label}
    begin
     TopColor(cpNormal);  tmpStr:='';
     su:=su-labelbase;
     if (su<=Lnum) then tmpStr:=TcLabel[su];
     localWide:=stringgrid1.canvas.textwidth(tmpStr);
     OutString;
    end
   else
    begin {normal entry}
     tmpStr:='';   {subject code}
     if ((su>0) and (su<=numcodes[0])) then tmpStr:=Subcode[su];
     if (su=0) then tmpStr:=copy('____________',1,lencodes[0]);
     if (flgDouble and (blockNumber>0)) then fcolor(cpDoubleBlock) {double subject block}
      else if flgDouble then TopColor(cpDouble)
       else if (blockNumber>0) then fcolor(cpTTblock)
        else  TopColor(cpSub);
     localWide:=fwCode[0];
     OutString;
     tmpStr:='';   {teacher code}
     if ((te>0) and (te<=numcodes[1])) then tmpStr:=XML_TEACHERS.tecode[te,0];
     if (te=0) then tmpStr:=copy('---------------',1,lencodes[1]);
     if flgTclash then fcolor(cpTclash) else TopColor(cpTeach);
     localx:=localx+fwCodeBlank[0]+blankwidth;
     localWide:=fwCode[1];
     OutString;
     tmpStr:='';   {room code}
     if ((ro>0) and (ro<=numcodes[2])) then tmpStr:=XML_TEACHERS.tecode[ro,1];
     if (ro=0) then tmpStr:=copy('...............',1,lencodes[2]);
     if flgRclash then fcolor(cpRclash) else TopColor(cpRoom);
     localx:=localx+fwCodeBlank[1]+blankwidth;
     localWide:=fwCode[2];
     OutString;
    end;
  end; {CellType=3}
 if ((row=stringgrid1.toprow) and (col=stringgrid1.leftcol)) then   {only once per paint}
  UpdateWSclashBar;
end;

procedure TWorksheetwin.StringGrid1TopLeftChanged(Sender: TObject);
var
 L: integer;
begin
 {prevent multiple repaints as topleft changes as colwidth and rowheight change}
 if scalingGridCellsFlag then exit;
 wsCalc(StringGrid1.TopRow, StringGrid1.LeftCol);
 wsB1:=wsCalcB;  wsY1:=wsCalcY; wsL1:=wsCalcL;
 L:=wsL1; if L<1 then L:=1; {no zero level}
 Label2.caption := 'Top :'+yearShort+' '+Yearname[wsY1]+
                    ' Lev:'+IntToStr(L)+'  ';
 updateWSClashBar;
end;

procedure TWorksheetwin.FormResize(Sender: TObject);
var
  a: Integer;
begin
  a := StringGrid1.canvas.textwidth('  ');
  Label1.left:=Panel1.clientwidth-StringGrid1.canvas.textwidth(Label1.caption);
  if Label1.Left < lblMultipleValue.Left + lblMultipleValue.width + a then
    Label1.Left := lblMultipleValue.Left + lblMultipleValue.width + a;

  lblMultipleValue.Left := (panel1.ClientWidth - lblMultipleValue.Width) div 2;
  if lblMultipleValue.Left < Label2.Left + Label2.Width + a then
    lblMultipleValue.Left := Label2.left + Label2.Width + a;
  updateWSClashBar;
end;

procedure TWorksheetwin.FormShow(Sender: TObject);
begin
 // #994
  if (usrPassLevel <> utTime) and (usrPassLevel <> utSuper) then
  begin
    InUse1.Enabled := false;
  end;

end;

procedure TWorksheetwin.FormCreate(Sender: TObject);
begin
 drawingInProcess:=false;
 drawingWSclashBar:=false;
 Label1.caption:='';
 lblMultipleValue.Caption := '';
 setWindowDefaults(Self,wnWorksheet);
 doubleclick:=false;
 panel1.Color:=FontColorPair[cpWorksheet,2];
 panel2.Color:=FontColorPair[cpWorksheet,2];
 panel3.Color:=FontColorPair[cpWorksheet,2];
 panel4.Color:=FontColorPair[cpWorksheet,2];
 panel5.Color:=FontColorPair[cpWorksheet,2];
 StringGrid1.FixedColor:=FontColorPair[cpWorksheet,2];

  if XML_DISPLAY.fgReshowWStoolbar then
    WStoolbarSelect;
  if fgWStoolbar then
  try
   case XML_DISPLAY.fgWStoolbarDock of {restore docked toolbar}
    1: WorkSheetToolbar.ManualDock(panel2);
    2: WorkSheetToolbar.ManualDock(panel3);
   end; {case}
  except
  end;
// #994
  if (usrPassLevel <> utTime) and (usrPassLevel <> utSuper) then
  begin
    InUse1.Enabled := false;
  end;
end;

procedure TWorksheetwin.StringGrid1MouseDown(Sender: TObject; Button: TMouseButton;
              Shift: TShiftState; X, y: integer);
var
  aRow,aCol: Longint;
  b,k,n: Integer;
  curSelection: TGridRect;
begin
  controlkeyFlg := False;
  if doubleclick then
  begin
    doubleclick:=false;
    Exit;
  end;
  Worksheetwin.repaint;
  StringGrid1.mousetocell(X,y,aCol,aRow);
  if (aCol >= 0 ) and (aRow >= 0) then
  begin
    wsCalc(aRow,aCol);
    b := wsCalcB;
    k := wsCalcY;
    n := wsCalcL;

    wsBox := bxCell;
    if (aCol=0) and (aRow<1) then wsBox:=bxAll;
    if (aCol>0) and (aRow=0) then wsBox:=bxTime;
    if (aCol=0) and (aRow>0) and (n=0) then wsBox:=bxYear;
    if (aCol=0) and (aRow>0) and (n>0) then wsBox:=bxLevel;
    if (aCol>0) and (n=0) then wsBox:=bxYrTime;

    case wsBox of
    bxAll: begin
            curSelection.left:=aCol;
            curSelection.right:=StringGrid1.ColCount;
            curSelection.top:=0;
            curSelection.bottom:=StringGrid1.RowCount;
            wsb:=1;
            wsy:=years_minus_1;
            wsl:=1;
           end;
    bxTime: begin
             curSelection.left:=aCol;
             curSelection.right:=aCol;
             curSelection.top:=aRow;
             curSelection.bottom:=StringGrid1.RowCount;
             wsb:=b;
             wsy:=k;
             wsl:=1;
            end;
    bxYear: begin
             curSelection.left:=aCol;
             curSelection.right:=StringGrid1.ColCount;
             curSelection.top:=aRow;
             curSelection.bottom:=aRow+level[k];
             wsb:=1;
             wsy:=k;
             wsl:=1;
            end;
    bxLevel: begin
              curSelection.left:=aCol;
              curSelection.right:=StringGrid1.ColCount;
              curSelection.top:=aRow;
              curSelection.bottom:=aRow;
              wsb:=1;  wsy:=k;  wsl:=n;
             end;
    bxYrTime: begin
               curSelection.left:=aCol;
               curSelection.right:=aCol;
               curSelection.top:=aRow;
               curSelection.bottom:=aRow+level[k];
               wsb:=b;
               wsy:=k;
               wsl:=1;
              end;
    bxCell: begin
             curSelection.left:=aCol;
             curSelection.right:=aCol;
             curSelection.top:=aRow;
             curSelection.bottom:=aRow;
             wsb:=b;
             wsy:=k;
             wsl:=n;
            end;
    end; {case}
    StringGrid1.selection := curSelection;
    ShowCurrentCell;
  end;
end;

procedure TWorksheetwin.Version1Click(Sender: TObject);
begin
  mainform.Version1Click(Self)
end;

procedure TWorksheetwin.Years1Click(Sender: TObject);
begin
  mainform.Years1Click(Self)
end;

procedure TWorksheetwin.Days1Click(Sender: TObject);
begin
  mainform.Days1Click(Self)
end;

procedure TWorksheetwin.TimeSlots1Click(Sender: TObject);
begin
  mainform.TimeSlots1Click(Self)
end;

procedure TWorksheetwin.Levels1Click(Sender: TObject);
begin
  mainform.Levels1Click(Self)
end;

procedure wsMoveSelect(moveType: byte);
begin
 if moveType=0 then exit;{none}
 case moveType of
  1: begin {right}
      if (wsb=wsBlocks) then exit; {already on right}
      inc(wsb);
     end;
  2: begin {left}
      if (wsb=1) then exit;
      dec(wsb);
     end;
  3: begin {down}
      if (wsy=0) and (wsl=level[wsy]) then exit;
      inc(wsl);
      if wsl > level[wsy] then
       begin
         dec(wsy);
         wsl:=1
       end;
     end;
  4: begin {up}
      if (wsy=years_minus_1) and (wsl=1) then exit;
      dec(wsl);
      if wsl < 1 then
       begin
         inc(wsy);
         wsl:=level[wsy]
       end;
     end;
 end; {case}
end;

procedure TWorksheetwin.StringGrid1KeyDown(Sender: TObject; var Key: word; Shift:
                                        TShiftState);
var
 Srect   : TgridRect;
 Row,Col  : integer;
 dochange: bool;
begin
 dochange := false;
 controlkeyFlg := false; {prevent cell selection changing on ctrl key press}
 case Key of
  VK_RETURN: begin
              StringGrid1DblClick(Self);
              exit
             end;
  VK_CONTROL: controlkeyFlg:=true;
  vk_up: begin
          Key:=0;
          if (wsl>1) or (wsy<years_minus_1) then
           begin
            dochange:=true;
            wsMoveSelect(4)
           end;
         end;
  vk_down: begin
            Key:=0;
            if (wsy>0) or (wsl<level[wsy]) then
             begin
              dochange:=true;
              wsMoveSelect(3)
             end;
           end;

  vk_home: begin
            Key:=0;
            dochange:=true;
            wsb:=1; wsy:=years_minus_1; wsl:=1;
           end;
  vk_prior: begin
             Key:=0;
             if (wsy<>years_minus_1) then
              begin
               dochange:=true;
               inc(wsy);
               if wsy>years_minus_1 then wsy:=years_minus_1;
               wsl:=1; wsY1:=wsy; wsL1:=1;
               Row:= FindWSrow(wsY1,wsL1);
               dec(Row); StringGrid1.TopRow:=Row
              end;
            end;
  vk_next: begin
            Key:=0;
            if (wsy<>0) then
             begin
              dochange:=true;
              dec(wsy);
              wsl:=1; wsY1:=wsy; wsL1:=1;
              Row:=FindWSrow(wsY1,wsL1);
              dec(Row);  StringGrid1.TopRow:=Row
             end;
           end;
  190: begin {> key}
        Key:=0;
        if (wsBlocks-wsb)>5 then
         begin
          dochange:=true;
          inc(wsb,5)
         end;
       end;
  188: begin {< key}
        Key:=0;
        if wsb>5 then
         begin
          dochange:=true;
          dec(wsb,5)
         end;
       end;
  end; {case}
 if dochange then
  begin
   Row:=FindWSrow(wsy,wsl);
   Col:=wsb;
   Srect.top:=Row; Srect.left:=Col;
   Srect.bottom:=Row;  Srect.right:=Col;
   StringGrid1.selection:=Srect;
   wsBox:= bxCell;
   BringIntoView;
   CheckWSdlgs;
  end;
end;

procedure TWorksheetwin.Entries1Click(Sender: TObject);
begin
 if CheckAccessRights(utTime,16,true) then
  begin
   if not (fwsEntryDlgUp) then {create if needed}
     wsEntrydlg:=Twsentrydlg.Create(Self); {allocate dlg}
  wsEntrydlg.show
 end;
end;

procedure TWorksheetwin.StringGrid1DblClick(Sender: TObject);
begin
 doubleclick := true;
 if ((wsBox=bxLevel) or (wsBox=bxYear)) then RollClasses1Click(self)
  else Entries1Click(Self);
end;

Procedure OpenTtClashDlg(mytag: integer);
begin
 if CheckAccessRights(utTime,16,true) then
  begin
   ttclashdlg:=Tttclashdlg.Create(application); {allocate dlg}
   ttclashdlg.tag:=mytag;
   ttclashdlg.ShowModal;
   ttclashdlg.Free;
   if not(saveTimeFlag) then CheckAccessRights(utTime,16,false)
  end;
end;

procedure TWorksheetwin.SwapBlocks1Click(Sender: TObject);
begin
 OpenTtClashDlg(1);
end;

procedure TWorksheetwin.SwapTeachers1Click(Sender: TObject);
begin
 OpenTtClashDlg(2);
end;

procedure TWorksheetwin.SwapRooms1Click(Sender: TObject);
begin
 OpenTtClashDlg(3);
end;

procedure TWorksheetwin.Clear1Click(Sender: TObject);
var
  Msg: string;
begin
 if CheckAccessRights(utTime,16,true) then
  begin
   Msg:='CLEAR ALL ENTRIES from the Worksheet?';
   if messagedlg(Msg,mtWarning,[mbyes,mbno],0)<>mrYes then
    begin
     if not(saveTimeFlag) then CheckAccessRights(utTime,16,false);
     exit;
    end;
   pushAllWSstack(utWSclear);  //push whole worksheet
   ClearWorksheet;
   UpdateWSwins;
   SaveTimeFlag:=true;
  end;
end;

procedure TWorksheetwin.Build1Click(Sender: TObject);
begin
 if CheckAccessRights(utTime,16,true) then
  begin
   BuildDlg:=TBuildDlg.Create(Self); {allocate dlg}
   BuildDlg.ShowModal;
   BuildDlg.Free;
   if not(saveTimeFlag) then CheckAccessRights(utTime,16,false)
 end;
end;


{
========================                                          ===============
========================                                          ===============
------------------------ PRINT ROUTINE FOR MAIN TIMETABLE FOLLOWS --------------
========================                                          ===============
========================                                          ===============
}

procedure TPrintWorksheetWin.head;
begin
 UnderlineOn;
 printwl('Worksheet');
 printw(PageCount);
 UnderlineOff;
 x:=0; y:=y+PrnttxtHeight;
end;

procedure TPrintWorksheetWin.SetTabs;
var
 i,tab1: integer;
begin
 SetLength(PrntTabs,3);
 tab1:=PrintCanvas.textwidth(yeartitle)+2*prntblankwidth;
 i:=PrintCanvas.textwidth(yearshort)+2*prntblankwidth+fwprntyearname;
 if i>tab1 then tab1:=i;
 if fwprntclass>tab1 then tab1:=fwprntclass;
 PrntTabs[1]:=tab1;
end;

procedure TPrintWorksheetWin.printWorksheet;
var
 yyear,L: integer;
 ttspace1,tab1,ygap,endx:          integer;
 tab2,fitcnt,fitpages,fitstart:     integer;
 fitI,fitI1,fitI2,cNum: integer;
 wsPrintContinue:               boolean;

    Procedure drawHline;
    begin
     inc(y,ygap); drawmyline(0,y,endx,y); inc(y,ygap);
    end;

    procedure drawVlines;
    var
     i: integer;
    begin
     drawmyline(0,y-prnttxtheight-ygap,0,y+ygap);
     for i:=0 to cNum do
      drawmyline(tab1+i*ttspace1,y-prnttxtheight-ygap,tab1+i*ttspace1,y+ygap);
    end;

    procedure wsHead;
    var
     i,k,l:     integer;
     astr: string;
    begin
     drawHline;
     printw(' '+yeartitle);
     k:=ttspace1 div 2;
     for i:=fitI1 to fitI2 do
      begin
       astr:='Block:'+inttostr(i);
       L:=PrintCanvas.textwidth(astr) div 2;
       x:=tab1+(i-fitI1+1)*ttspace1-k-L;
       printw(astr);
      end; {for i}
     newline;
     drawVlines;
     drawHline;
    end;

    procedure endWSpage;
    begin
     drawmyline(0,y+ygap+prnttxtheight,endx,y+ygap+prnttxtheight); {close off}
     startnewpage;
     header;
     wsHead;
     wsPrintContinue:=true;
    end;


    procedure Worksheetprint1;
    var
     i,a1:                  integer;
     aFnt,bFnt:            tpintpoint;
     code,b:                integer;
     tmpStr,cstr:                    string;

    begin
     if ((L=1) or (wsPrintContinue)) then
      begin
       if wsPrintContinue then y:=y-prnttxtheight;
       wsPrintContinue:=false;
       printw(' '+yearshort+' '+yearname[yyear]);
       newline;
      end;
     printw(' '+ClassCode[ClassShown[l,yyear]]);
     for b:=fitI1 to fitI2 do
      begin
       aFnt:=FNws(b,yyear,l,0);
        tab2:=prntblankwidth;
        for code:=0 to 2 do
        begin
         x:=tab1+(b-fitI1)*ttspace1+tab2;
         bfnt:=afnt;
         inc(bfnt,code);
         a1:=bfnt^;
         if ((code=0) and (a1>=LabelBase)) then
         begin
          cstr:=tclabel[a1-LabelBase];
          trimLabelToFit(cstr,PrintCanvas,(ttspace1-2*prntblankwidth));
          printw(' '+cstr);
          break;
         end
         else
          begin
           tmpstr:=FNsub(a1,code);
           case code of
            0:fcolor(cpSub);
            1:fcolor(cpTeach);
            2:fcolor(cpRoom);
           end;
           printw(' '+tmpstr); fcolor(cpNormal);
          end;
         inc(tab2,fwprntcode[code]+prntblankwidth);
        end; {code}
       drawmyline(0,y-(prnttxtheight)-ygap,0,y+ygap+prnttxtheight);
       for i:=0 to cNum do
         drawmyline(tab1+i*ttspace1,y-(prnttxtheight)-ygap,tab1+i*ttspace1,y+ygap+prnttxtheight);
       if (y+4*PrnttxtHeight)>(PrintPageHeight-2*prntTxtHeight) then endWSpage;
      end; {for b}
      newline;
    end;
begin
 ygap:=PrnttxtHeight div 5;
 tab1:=PrntTabs[1];
 ttspace1:=4*prntblankwidth+fwprntcode[0]+fwprntcode[1]+fwprntcode[2];
 fitcnt:=(PrintPageWidth-prntHmargin-PrntTabs[1]) div ttspace1;
 if fitcnt<1 then fitcnt:=1;
 fitpages:=wsBlocks div fitcnt;
 if (wsBlocks mod fitcnt)>0 then inc(fitpages);
 fitstart:=1;

 for fitI:=1 to fitpages do
  begin
   fitI1:=fitstart+((fitI-1)*fitcnt);
   fitI2:=fitI1+fitcnt-1;
   if fitI2>wsBlocks then fitI2:=wsBlocks;
   cNum:=fitI2-fitI1+1;   endx:=tab1+cNum*ttspace1;
   wsPrintContinue:=false;
   if fitI>1 then
    begin
     startnewpage;
     header;
    end;
   wsHead;
   for yyear:=years_minus_1 downto 0 do
    if XML_DISPLAY.pyear[yyear] then
     begin
      for L:=1 to level[yyear] do Worksheetprint1;
      drawHline;
     end;
  end; {for fitI}
 newline;

end;

procedure workSheetPrint;
begin
 PrintWorksheetWin:=TPrintWorksheetWin.create;
 with PrintWorksheetWin do
  try
   PrintHead;
   printWorksheet;
   printCustomAddon;
  finally
   PrintWorksheetWin.Free;
  end;
end;

{
========================                                          ===============
========================                                          ===============
------------------------    END OF MAIN TIMETABLE PRINT ROUTINE   --------------
========================                                          ===============
========================                                          ===============
}


procedure TOutWorksheetWin.head;
begin
 printLine(['Worksheet']);
end;

procedure TOutWorksheetWin.OutWorksheet;
  procedure printWorksheet;
  var
   yyear,L: integer;


    procedure wsHead;
    var
     i:     integer;
    begin
     printw(' '+Yeartitle); printc('');
     for i:=1 to wsBlocks do
       begin
        printc('Block:'+inttostr(i)); printc(''); printc('');
       end;
     newline;
    end;

    procedure Worksheetprint1;
    var
     b,a1:                  integer;
     aFnt,bFnt:            tpintpoint;
     code:                integer;
     tmpStr,cstr:                    string;

    begin
    if (L=1) then
     begin
      printw(yeartitle+' '+yearname[yyear]);
      newline;
     end;
      printw(ClassCode[ClassShown[l,yyear]]);
     for b:=1 to wsBlocks do
      begin
       aFnt:=FNws(b,yyear,l,0);
        for code:=0 to 2 do
        begin
         bfnt:=afnt;
         inc(bfnt,code);
         a1:=bfnt^;
         if ((code=0) and (a1>LabelBase)) then
         begin
          cstr:=tclabel[a1-LabelBase];
          printc(cstr); printc(''); printc('');
          break;
         end
         else
          begin
           tmpstr:=FNsub(a1,code);
           printc(tmpstr);
          end;
        end; {code}
      end; {for b}
      newline;
    end;

begin
 wsHead;
 for yyear:=years_minus_1 downto 0 do
  if XML_DISPLAY.pyear[yyear] then
   for L:=1 to level[yyear] do Worksheetprint1;
  newline;
end;

begin
 printWorksheet;
 printCustomAddon;
end;

procedure workSheetText;
begin
 OutWorksheetWin:=TOutWorksheetWin.create;
 with OutWorksheetWin do
  try
   Header;
   OutWorksheet;
  finally
   OutWorksheetWin.Free;
  end;
end;



{
========================                                          ===============
========================                                          ===============
------------------------    END OF MAIN TIMETABLE text ROUTINE   --------------
========================                                          ===============
========================                                          ===============
}

procedure TWorksheetwin.Alter1Click(Sender: TObject);
begin
 if CheckAccessRights(utTime,16,true) then
  begin
   wsAlterDlg:=TwsAlterDlg.Create(Self); {allocate dlg}
   wsAlterDlg.ShowModal;
   wsAlterDlg.Free;
   if not(saveTimeFlag) then CheckAccessRights(utTime,16,false)
  end;
end;

procedure TWorksheetwin.Timetable1Click(Sender: TObject);
begin
 Years1.caption:='&'+yearTitle+'s ...';
end;

function SubIsOnTT(var d3,p3,su: smallint):boolean;
var
 d,p: smallint;
begin
 result:=false;
 for d:=0 to days-1 do
  for p:=0 to Tlimit[d]-1 do
   if su=FNT(d,p,wsy,wsl,0)^ then
    begin
     result:=true;
     d3:=d; p3:=p;
     break;
    end
end;

procedure TWorksheetwin.PopupMenu1Popup(Sender: TObject);
var
 aFnt: tpIntPoint;
 s,t,r,d,p: smallint;
begin
 ShowSubjectTimetable1.visible:=false;
 ShowTeacherTimetable1.visible:=false;
 ShowRoomTimetable1.visible:=false;
 ShowClassTimetable1.visible:=false;
 if wsBox=bxCell then
  begin
   aFnt:=FNws(wsb,wsy,wsl,0);
   s:=aFnt^;
   inc(aFnt);
   t:=aFnt^;
   inc(aFnt);
   r:=aFnt^;
   if ((s>0) and (s<=LabelBase)) then if SubIsOnTT(d,p,s) then
    ShowSubjectTimetable1.visible:=true;
   ShowTeacherTimetable1.visible:=(t>0);
   ShowRoomTimetable1.visible:=(r>0);
  end;
 if wsBox=bxLevel then
  begin
   ShowClassTimetable1.visible:=(ClassCode[ClassShown[wsl,wsy]]>'')
  end;
end;

procedure TWorksheetwin.ShowSubjectTimetable1Click(Sender: TObject);
var
 su,d,p: smallint;
begin
 if wsBox=bxCell then
  begin
   su:=FNws(wsb,wsy,wsl,0)^;
   if ((su>0) and (su<=LabelBase)) then
    if SubIsOnTT(d,p,su) then
     begin
      XML_DISPLAY.subttlistVals[1]:=wsy;
      XML_DISPLAY.subttlistVals[2]:=wsl;
      XML_DISPLAY.subttlistVals[3]:=d;
      XML_DISPLAY.subttlistVals[4]:=p;
      XML_DISPLAY.subttlistSelection:=1;
      subjectTtablewinSelect;
      UpdateWindow(wnSubjectTt)
     end;
  end;
end;

procedure TWorksheetwin.ShowTeacherTimetable1Click(Sender: TObject);
var
  te: integer;
begin
 if wsBox = bxCell then
  begin
   te:=FNWS(wsb,wsy,wsl,2)^;
   if te>0 then
    begin
     XML_DISPLAY.TeTtSelection[0]:=1;
     XML_DISPLAY.TeTtSelection[1]:=te; {selection}
     XML_DISPLAY.tettlistVals[3]:=0; {fac}
     XML_DISPLAY.tettseltype:=2; {selection}
     winView[wnTeacherTt]:=1; {weekly}
     teachTtablewinSelect;
     UpdateWindow(wnTeacherTt);
    end;
  end;
end;

procedure TWorksheetwin.ShowRoomTimetable1Click(Sender: TObject);
var
 r: integer;
begin
 if wsBox = bxCell then
  begin
   r:=FNws(wsb,wsy,wsl,4)^;
   if r>0 then
    begin
     XML_DISPLAY.RoTtSelection[0]:=1;
     XML_DISPLAY.RoTtSelection[1]:=r; {selection}
     XML_DISPLAY.rottlistVals[3]:=0; {fac}
     XML_DISPLAY.rottseltype:=2; {selection}
     winView[wnRoomTt]:=1; {weekly}
     roomTtablewinSelect;
     UpdateWindow(wnRoomTt)
    end;
  end;
end;

procedure TWorksheetwin.ShowClassTimetable1Click(Sender: TObject);
begin
 if ClassCode[ClassShown[wsl, wsy]] > '' then
  begin
   XML_DISPLAY.subttlistVals[1]:=wsy;
   XML_DISPLAY.subttlistVals[2]:=wsl;
   XML_DISPLAY.subttlistVals[3]:=nd;
   XML_DISPLAY.subttlistVals[4]:=np; {period}
   XML_DISPLAY.subttlistSelection:=3;
   subjectttablewinSelect;
   UpdateWindow(wnSubjectTt)
  end;
end;

procedure TWorksheetwin.Size1Click(Sender: TObject);
begin
  mainform.Size1Click(Self)
end;

function TWorksheetwin.GetSelectedTeacher: Integer;
var
  lSeceletdTe: Integer;
begin
  lSeceletdTe := -1;
  try
    lSeceletdTe := FNWS(wsb, wsy, wsl, 2)^;
  finally
    Result := lSeceletdTe;
  end;
end;

procedure TWorksheetwin.GetSelection(var x1,x2,y1,y2: smallint);
begin
 with StringGrid1 do
  begin
   x1:=selection.left;  if x1<1 then x1:=1;
   x2:=selection.right; if x2<1 then x2:=1;
   if x2>(ColCount-1) then x2:=ColCount-1;
   y1:=selection.top;   if y1<2 then y1:=2;
   y2:=selection.bottom;   if y2<2 then y2:=2;
  end;
end;

procedure TWorksheetwin.copyWStextToClipboard;
var
 i,j,x1,x2,y1,y2,m      : smallint;
 aFnt   : tpIntPoint;
 tmpStr,tmpstr2: string;
begin
 studText:='';  genText:='';
 GetSelection(x1,x2,y1,y2);
 for i:=y1 to y2 do
  begin
   for j:=x1 to x2 do
    begin
     wsCalc(i,j);
     aFnt:=FNWS(wsCalcB,wsCalcY,wsCalcL,0);
     m:=aFnt^; tmpStr:=''; tmpstr2:='';
     if ((m>LabelBase) and ((m-LabelBase)<=nmbrLabels)) then
      begin
       tmpStr:=TcLabel[m-LabelBase]+ht+ht;
       tmpstr2:=tmpstr2+ht
      end
     else
      begin
       if ((m>0) and (m<=NumCodes[0])) then tmpStr:=SubCode[m];
       inc(aFnt); m:=aFnt^; tmpStr:=tmpStr+ht;
       if ((m>0) and (m<=NumCodes[1])) then tmpStr:=tmpStr+XML_TEACHERS.tecode[m,0];
       inc(aFnt); m:=aFnt^; tmpStr:=tmpStr+ht;
       if ((m>0) and (m<=NumCodes[2])) then tmpStr:=tmpStr+XML_TEACHERS.tecode[m,1];
       inc(aFnt); m:=aFnt^; tmpstr2:=tmpstr2+ht+IntToStr(m)
      end;
     if not(wsCalcL=0) then
      begin {nothing for level 0}
       if not (j=x1) then
        begin
         genText:=genText+ht;
         studText:=studText+ht
        end;
       genText:=genText+tmpStr;
       studText:=studText+tmpStr+tmpstr2
      end;
    end; {for j}
   if not (wsCalcL=0) then
    begin {nothing for level 0}
     if (i<>y2) then
      begin
       genText:=genText+endline;
       studText:=studText+endline
      end;
    end;
  end; {for i}
 genText:=genText+chr(0);
 studText:=studText+chr(0);
 copyTextToClipboard(cfTtable)
end;

procedure TWorksheetwin.ClearWStext(doPush: boolean);
var
 i,j,x1,x2,y1,y2: smallint;
begin
 GetSelection(x1,x2,y1,y2);
 for i:=y1 to y2 do
  for j:=x1 to x2 do
   begin
    wsCalc(i,j);
    if doPush then PushWScell(wsCalcB,wsCalcY,wsCalcL);
    FNWS(wsCalcB,wsCalcY,wsCalcL,0)^:=0; {sub}
    FNWS(wsCalcB,wsCalcY,wsCalcL,2)^:=0; {te}
    FNWS(wsCalcB,wsCalcY,wsCalcL,4)^:=0; {ro}
    FNWS(wsCalcB,wsCalcY,wsCalcL,6)^:=0; {flags}
    WSFclash[wsCalcB]:=1;
   end; {for j}
 SaveTimeFlag := true;
 WSclash;
 UpdateWSwins;
end;

procedure TWorksheetwin.Copy1Click(Sender: TObject);
begin
  copyWStextToClipboard;
end;

procedure TWorksheetwin.Cut1Click(Sender: TObject);
begin
 if CheckAccessRights(utTime,16,true) then
  begin
   copyWStextToClipboard;
   PushTtStackStart(utWScut);
   ClearWStext(True);
   RebuildLabels;
  end;
end;

procedure TWorksheetwin.parseClipWSText;
var
 i,j,x1,y1    : smallint;
 su,te,ro,flg : smallint;
 sbyte,Nblock: byte;
begin
 suMissedCnt:=0; teMissedCnt:=0; roMissedCnt:=0;
 with StringGrid1 do
  begin
   x1:=selection.left;  if x1<1 then x1:=1;
   y1:=selection.top;   if y1<2 then y1:=2;
   i:=y1; j:=x1;
   if Clipboard.HasFormat(CF_AMIG_Block_Data) then
    begin
     getTextFromClipboard(CF_AMIG_Block_Data);
     while genText <> '' do
      begin
       getClipBlkCell(su);
       if (i<=RowCount-1) and (j<=ColCount-1) then
        begin
         wsCalc(i,j);
         if wsCalcL=0 then begin inc(i); wsCalc(i,j); end;
         FNWS(wsCalcB,wsCalcY,wsCalcL,0)^:=su; {sub}
         WSFclash[wsCalcB]:=1;
        end;
       inc(j);
       if GotCr then begin inc(i); j:=x1; end; //next line - step down
      end;
    end
   else
    begin
     customPaste:=Clipboard.HasFormat(CF_AMIG_Timetable_Data);
     if customPaste then getTextFromClipboard(CF_AMIG_Timetable_Data);
     while genText<>'' do
      begin
       flg:=0;
       getClipCell(su,te,ro,flg);
       if (i<=RowCount-1) and (j<=ColCount-1) then
        begin
         wsCalc(i,j);
         if wsCalcL=0 then begin inc(i); wsCalc(i,j); end;
         FNWS(wsCalcB,wsCalcY,wsCalcL,0)^:=su; {sub}
         FNWS(wsCalcB,wsCalcY,wsCalcL,2)^:=te; {te}
         FNWS(wsCalcB,wsCalcY,wsCalcL,4)^:=ro; {ro}
         FNWS(wsCalcB,wsCalcY,wsCalcL,6)^:=flg; {flags}
         Nblock:=FNgetWSblockNumber(wsCalcB,wsCalcY,wsCalcL);
         if Nblock>0 then Nblock:=wsCalcB; {set to worksheet block}
         sByte:=FNWSByte(wsCalcB,wsCalcY,wsCalcL,6)^;
         {keep share flag, clear double and fix flags}
         if ((sByte and 2)=2) then sByte:=2 else sByte:=0;
         FNwsByte(wsCalcB,wsCalcY,wsCalcL,6)^:=Sbyte;
         FNputWSblockNumber(wsCalcB,wsCalcY,wsCalcL,Nblock);
         WSFclash[wsCalcB]:=1;
        end;
       inc(j);
       if GotCr then begin inc(i); j:=x1; end; //next line - step down
      end; {while genText<>''}
    end;
  end; {with stringGrid1}
 CheckPasteMsg;
 SaveTimeFlag:=true;
 WSclash;
 UpdateWSwins;
 screen.cursor := crDefault;
end;

procedure TWorksheetwin.PasteData(Sender: TObject);
begin
 if ((usrPassLevel<>utTime) and (usrPassLevel<>utSuper)) then
  begin
   showRestrictedMsg;
   exit;
  end;
 if CheckAccessRights(utTime,16,true) then
  begin
   if not (Clipboard.HasFormat(CF_TEXT)) then exit;
   getTextFromClipboard(CF_TEXT); {get clip text}
   pushAllWSstack(utWSpaste);
   if not (Clipboard.HasFormat(CF_AMIG_Block_Data)) then
     ClearWStext(false); {don't clear it for copy from blocks}
   parseClipWSText;
   RebuildLabels;
 end;
end;

procedure TWorksheetwin.Edit1Click(Sender: TObject);
begin
 paste1.enabled:=GetClipStatus(wnTtable);
 Undo1.Enabled:=(ttUndoPtr>0);
 Redo1.Enabled:=(ttUndoPtr<ttUndoMax);
 Undo1.Hint:=UndoHint;
 Redo1.Hint:=RedoHint;
end;

procedure TWorksheetwin.Delete1Click(Sender: TObject);
begin
 if CheckAccessRights(utTime,16,true) then
  begin
   PushTtStackStart(utWSdelete);
   ClearWStext(true);
   RebuildLabels;
  end;
end;

procedure TWorksheetwin.DisplayTeacherLoadOnWorksheet(Sender: TObject);
var
  lFrmTeacherLoadOnWS: TFrmTeacherLoadOnWS;
begin
  lFrmTeacherLoadOnWS := TFrmTeacherLoadOnWS.Create(Application);
  try
    lFrmTeacherLoadOnWS.SelectedTeacher := GetSelectedTeacher;
    lFrmTeacherLoadOnWS.PrintTeacherLoadOnWS(otScreen);
  finally
    FreeAndNil(lFrmTeacherLoadOnWS);
  end;
end;

procedure TWorksheetwin.DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := True;
end;

procedure TWorksheetwin.DropSubject(Sender, Source: TObject; X, Y: Integer);
var
  lCol: Integer;
  lRow: Integer;
begin
  StringGrid1.MouseToCell(X, Y, lCol, lRow );
  StringGrid1.Col := lCol;
  StringGrid1.Row := lRow;
  PasteData(Self);
end;

procedure TWorksheetwin.BlockClashes2Click(Sender: TObject);
begin
 BlockClasheswinSelect;
end;

procedure TWorksheetwin.Blocks1Click(Sender: TObject);
begin
  mainform.Blocks3Click(Self)
end;

procedure TWorksheetwin.FormDeactivate(Sender: TObject);
begin
 Cut1.ShortCut:=ShortCut(0,[]);
 Copy1.ShortCut:=ShortCut(0,[]);
 Paste1.ShortCut:=ShortCut(0,[]);
 Delete1.ShortCut:=ShortCut(0,[])
end;

procedure TWorksheetwin.Panel3DockOver(Sender: TObject; Source: TDragDockObject; X,
                                    y: integer; state: TDragState; var Accept:
                                    boolean);
var
 aa: smallint;
begin
 aa:=(Source.control as TForm).tag;
 Accept:=(aa=wnWsTool);
end;

procedure TWorksheetwin.Panel2DockOver(Sender: TObject; Source: TDragDockObject; X,
                                    y: integer; state: TDragState; var Accept:
                                    boolean);
var
 aa: smallint;
begin
 aa:=(Source.control as TForm).tag;
 Accept:=(aa=wnWsTool);
end;

procedure TWorksheetwin.Panel2DockDrop(Sender: TObject; Source: TDragDockObject; X,
                                    y: integer);
begin
 Panel2.height:=Panel2.height+(Source.control as TForm).clientheight;
 XML_DISPLAY.fgWStoolbarDock:=1;
end;

procedure TWorksheetwin.Panel3DockDrop(Sender: TObject; Source: TDragDockObject; X,
                                    y: integer);
begin
 Panel3.height:=Panel3.height+(Source.control as TForm).clientheight;
 XML_DISPLAY.fgWStoolbarDock:=2;
end;

procedure TWorksheetwin.RollClasses1Click(Sender: TObject);
begin
 if CheckAccessRights(utTime,16,true) then
  begin
   ClassesShowDlg:=TClassesShowDlg.Create(Self); {allocate dlg}
   ClassesShowDlg.ShowModal;
   ClassesShowDlg.Free;{release dlg}
   if not(saveTimeFlag) then CheckAccessRights(utTime,16,false)
 end;
end;

procedure TWorksheetwin.StringGrid1Click(Sender: TObject);
begin
  controlkeyFlg := false
end;

procedure TWorksheetwin.SelectAll1Click(Sender: TObject);
var
 curSelection: TgridRect;
begin
 curSelection.left:=0;
 curSelection.right:=StringGrid1.ColCount;
 curSelection.top:=0;
 curSelection.bottom:=StringGrid1.RowCount;
 StringGrid1.selection:=curSelection;
 wsb:=1;
 wsy:=0;
 wsl:=1;
 wsBox:=bxAll;
 ShowCurrentCell
end;

procedure TWorksheetwin.FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
 if Key=VK_CONTROL then Key:=0
  // only doing this to prevent selection change when day, period, level or
  // whole Worksheet selected.
end;

procedure TWorksheetwin.InUse1Click(Sender: TObject);
begin
 mainform.InUse2Click(Self);
end;

{
Worksheet structure:

(a) each block b has its own memory section wsMain[b]

(b) 12 bytes per cell, first 8 bytes as for timetable, 2 bytes
 points to frequency information, 2 bytes spare.

 (c) target times defined, but used in Build rather than attached
to worksheet entries; broad definitions using bitmaps for each day
(more comprehensive than current) to define allowed times for singles,
doubles and triples.  Use build time slot map (using time slot codes)
for each category and save each day as 4 byte integer bit map

(d) no provision yet for alternate teachers, team teacher, alternate
rooms

(e) frequency information, defined separately.  Named using frequencies
eg 5 means 5 singles; 4-1 means 4 singles, 1 double;
 3-0-1 means 3 singles, 0 doubles, 3 singles

 (f) frequency definition attached to worksheet entries in
defined scope

Worksheet toolbar - icon for block clashes window instead of teachers free, etc


}

procedure TWorksheetwin.Undo1Click(Sender: TObject);
begin
 ttChangeUndo;
end;

procedure TWorksheetwin.Redo1Click(Sender: TObject);
begin
 ttChangeRedo;
end;

procedure TWorksheetwin.Multiples1Click(Sender: TObject);
begin
 if CheckAccessRights(utTime,16,true) then
  begin
   if not (fwsMultDlgUp) then {only create if not exist !!}
    begin
     wsMultipledlg:=TwsMultipledlg.Create(Self); {allocate dlg}
     fwsMultDlgUp:=true
    end;
  wsMultipledlg.show
 end;
end;

procedure TWorksheetwin.TargetTimes1Click(Sender: TObject);
begin
 if CheckAccessRights(utTime,16,true) then
  begin
   wsTargetDlg:=TwsTargetDlg.Create(Self); {allocate dlg}
   wsTargetDlg.ShowModal;
   wsTargetDlg.Free;
   if not(saveTimeFlag) then CheckAccessRights(utTime,16,false)
 end;
end;

end.


