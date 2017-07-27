unit Ttable;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, grids, StdCtrls, Menus, TimeChartGlobals,ClassDefs, XML.UTILS,
  GlobalToTcAndTcextra, XML.DISPLAY, XML.TEACHERS;

type
  TTtablewin = class(TForm)
    Panel1                               : TPanel;
    StringGrid1                          : TStringGrid;
    Label1                               : TLabel;
    Label2                               : TLabel;
    Image1                               : TImage;
    PopupMenu1                           : TPopupMenu;
    Selection1                           : TMenuItem;
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
    Box1                                 : TMenuItem;
    ClashHelp1                           : TMenuItem;
    Solve1                               : TMenuItem;
    Clear1                               : TMenuItem;
    N3                                   : TMenuItem;
    Home1                                : TMenuItem;
    Goto1                                : TMenuItem;
    SearchReplace1                       : TMenuItem;
    Alter1                               : TMenuItem;
    Entries2                             : TMenuItem;
    Goto2                                : TMenuItem;
    SearchandReplace1                    : TMenuItem;
    Solve2                               : TMenuItem;
    ClashHelp2                           : TMenuItem;
    Box2                                 : TMenuItem;
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
    TeachersFree1                        : TMenuItem;
    RoomsFree1                           : TMenuItem;
    Panel2                               : TPanel;
    Panel3                               : TPanel;
    Panel4                               : TPanel;
    Panel5                               : TPanel;
    Blocks1                              : TMenuItem;
    RollClasses1                         : TMenuItem;
    N4                                   : TMenuItem;
    LinkwindowsMitem1: TMenuItem;
    N5                                   : TMenuItem;
    SelectAll1                           : TMenuItem;
    InUse1: TMenuItem;
    N6: TMenuItem;
    Redo1: TMenuItem;
    Undo1: TMenuItem;
    WorkSheet1: TMenuItem;
    RoomFill1: TMenuItem;
    RoomStrip1: TMenuItem;
    popTTableN1: TMenuItem;
    popTTableCopy: TMenuItem;
    mniTimetableStatistics: TMenuItem;
    mniTimetableN1: TMenuItem;
    StudentClashes1: TMenuItem;
    Build1: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StringGrid1SelectCell(Sender: TObject; Col, Row: longint; var
                                    CanSelect: boolean);
    procedure StringGrid1DrawCell(Sender: TObject; Col, Row: longint; Rect: TRect;
                                  state: TGridDrawState);
    procedure StringGrid1TopLeftChanged(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StringGrid1MouseDown(Sender: TObject; Button: TMouseButton; Shift:
                                   TShiftState; X, y: integer);
    procedure Selection1Click(Sender: TObject);
    procedure Version1Click(Sender: TObject);
    procedure Years1Click(Sender: TObject);
    procedure Days1Click(Sender: TObject);
    procedure TimeSlots1Click(Sender: TObject);
    procedure Levels1Click(Sender: TObject);
    procedure StringGrid1KeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure Entries1Click(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure Home1Click(Sender: TObject);
    procedure Box1Click(Sender: TObject);
    procedure Goto1Click(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure Alter1Click(Sender: TObject);
    procedure SearchReplace1Click(Sender: TObject);
    procedure Solve1Click(Sender: TObject);
    procedure ClashHelp1Click(Sender: TObject);
    procedure Timetable1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure ShowSubjectTimetable1Click(Sender: TObject);
    procedure ShowTeacherTimetable1Click(Sender: TObject);
    procedure ShowRoomTimetable1Click(Sender: TObject);
    procedure ShowClassTimetable1Click(Sender: TObject);
    procedure Size1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Cut1Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure TeachersFree1Click(Sender: TObject);
    procedure RoomsFree1Click(Sender: TObject);
    procedure Blocks1Click(Sender: TObject);
    procedure Panel3DockOver(Sender: TObject; Source: TDragDockObject; X, y: integer;
                             state: TDragState; var Accept: boolean);
    procedure Panel2DockOver(Sender: TObject; Source: TDragDockObject; X, y: integer;
                             state: TDragState; var Accept: boolean);
    procedure Panel2DockDrop(Sender: TObject; Source: TDragDockObject; X, y: integer);
    procedure Panel3DockDrop(Sender: TObject; Source: TDragDockObject; X, y: integer);
    procedure RollClasses1Click(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure LinkwindowsMitem1Click(Sender: TObject);
    procedure SelectAll1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure InUse1Click(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure Undo1Click(Sender: TObject);
    procedure Redo1Click(Sender: TObject);
    procedure RoomFill1Click(Sender: TObject);
    procedure RoomStrip1Click(Sender: TObject);
    procedure ExportAsSpecialTextFile(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure StringGrid1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure StringGrid1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure CopyDataWithinTimeTable(Sender: TObject);
    procedure ShowTimetableStatistics(Sender: TObject);
    procedure ShowStudentSubjectClashes(Sender: TObject);
    procedure Build1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  public
    procedure UpdateTTclashBar;
    procedure InitTTWin;
    procedure restoreTTselection;
  private
    procedure ShowCurrentCell;
    procedure copyTTtextToClipboard;
    procedure ClearTTtext(doPush: boolean);
    procedure GetSelection(var x1,x2,y1,y2: smallint);
    procedure pasteClipTTtext;
    procedure SetColumnWidth;
  end;

procedure BringIntoView;
procedure MoveSelect(moveType: byte);
procedure ttclash;
procedure clashtotal;
procedure checkLinkedWins;

var
  Ttablewin: TTtablewin;

procedure maintimetableprint;
procedure MainTimeTableText(const pIncludeRC: Boolean = False; const pIsSpecial: Boolean = False);

implementation

uses
  main, tcommon, printers, ttprnsel, block1, Entry, Boxop, TtGoTo,
  ttbClash, Build, Alter, Search, Solve, Chelp, tcommon2, clipbrd, showclas,
  tttoolbarwin, tcommon5, TTundo, StripRooms, CopyTT, TimetableStatistics, StudentClashes;

{$R *.DFM}

 type TPrintTtableWin=class(TPrintDrawWin)
  public
   procedure head; override;
   procedure SetTabs; override;
   procedure PrintTtable;
 end;

  type TOutTtableWin=class(TOutputWin)
  private
    FIsSpecial: Boolean;
    FIncludeRC: Boolean;
  public
    procedure head; override;
    procedure OutTtable;
    procedure GenericTimetabletext;
    property IsSpecial: Boolean read FIsSpecial write FIsSpecial default False;
    property IncludeRC: Boolean read FIncludeRC write FIncludeRC default False;
 end;

type
  tpteon = array [0..nmbrteachers, 0..nmbrPeriods] of integer;

var
  PrintTtableWin:    TPrintTtableWin;
  OutTtableWin:     TOutTtableWin;
  TeachOn:          tpteon;
  doubleclick     : bool;
  drawingInProcess: bool;
  drawingClashBar : bool;
  controlkeyFlg   : bool;
  scalingGridCellsFlag          : wordbool;


procedure TTtablewin.restoreTTselection;
var
 j:     smallint;
 curSelection:        TgridRect;
begin
   case box of
   bxCell: begin {cell}
       j:=findcol(nd,np);
       CurSelection.left:=j;     CurSelection.right:=j;
       j:=findrow(ny,nl);
       CurSelection.top:=j;     CurSelection.bottom:=j;
       stringgrid1.selection:=CurSelection;
      end;
   bxLevel: begin {level}
       CurSelection.left:=0;     CurSelection.right:=stringgrid1.colcount;
       j:=findrow(ny,nl);
       CurSelection.top:=j;     CurSelection.bottom:=j;
       stringgrid1.selection:=CurSelection;
      end;
   bxYear: begin {year}
       CurSelection.left:=0;     CurSelection.right:=stringgrid1.colcount;
       j:=findrow(ny,0);
       CurSelection.top:=j;     CurSelection.bottom:=j+level[ny];
       stringgrid1.selection:=CurSelection;
      end;
   bxYrTime: begin {year timeslot}
       j:=findcol(nd,np);
       CurSelection.left:=j;    CurSelection.right:=j;
       j:=findrow(ny,0);
       CurSelection.top:=j;     CurSelection.bottom:=j+level[ny];
       stringgrid1.selection:=CurSelection;
      end;
   bxTime: begin {timeslot/period}
       j:=findcol(nd,np);
       CurSelection.left:=j;     CurSelection.right:=j;
       CurSelection.top:=1;     CurSelection.bottom:=stringgrid1.rowcount;
       stringgrid1.selection:=CurSelection;
      end;
   bxBlock: begin end; {block}
   bxDay: begin {day}
       j:=findcol(nd,0);
       CurSelection.left:=j;     CurSelection.right:=j+tlimit[nd]-1;
       CurSelection.top:=0;     CurSelection.bottom:=stringgrid1.rowcount;
       stringgrid1.selection:=CurSelection;
      end;
  end; {case}
 ShowCurrentCell;
end;

procedure ClearTeachOn;
var
 i,p: integer;
begin
 for i:=0 to nmbrteachers do
   for p:=0 to nmbrperiods do
    Teachon[i,p]:=0;
end;

procedure checkLinkedWins;
var
 s,t,r,i,j: smallint;
 aFnt: tpIntPoint;
begin
 s:=0;  t:=0;  r:=0;
 {te's free}
 if wnFlag[wnTeFree] then
  begin
   XML_DISPLAY.teachersfreeshow1:=1;
   XML_DISPLAY.teachersfreeshow2:=1;
   XML_DISPLAY.teachersfreeday:=nd;
   XML_DISPLAY.TeFreePeriod:=np+1;
   UpdateWindow(wnTeFree)
  end;
 {ro's free}
 if wnFlag[wnRoFree] then
  begin
   XML_DISPLAY.roomsfreeshow1:=1;
   XML_DISPLAY.roomsfreeshow2:=1;
   XML_DISPLAY.roomsfreeday:=nd;
   XML_DISPLAY.roomsfreePeriod:=np+1;
   UpdateWindow(wnRoFree)
  end;
  {get sub,te,ro}
 if box = bxCell then
  begin
   s:=FNT(nd,np,ny,nl,0)^;
   t:=FNT(nd,np,ny,nl,2)^;
   r:=FNT(nd,np,ny,nl,4)^
  end;
 {sub tt}
 if wnFlag[wnSubjectTt] then
  begin
   if ((nl=0) or ((s<=NumCodes[0]) and (s>0))) then //only for valid sub code
    begin
     if s<labelBase then
      begin
       XML_DISPLAY.subttlistVals[1]:=ny;
       XML_DISPLAY.subttlistVals[2]:=nl;
       XML_DISPLAY.subttlistVals[3]:=nd;
       XML_DISPLAY.subttlistVals[4]:=np;
       XML_DISPLAY.subttlistSelection:=1;
       if nl=0 then
        begin //year timeslot
         XML_DISPLAY.subttlistSelection:=2; //year timeslot
         subttGroupCnt:=0;
         for i:=0 to level[XML_DISPLAY.subttlistVals[1]] do
          begin
           aFnt:=FNT(XML_DISPLAY.subttlistVals[3],XML_DISPLAY.subttlistVals[4],XML_DISPLAY.subttlistVals[1],i,0);
           j:=aFnt^;
           if ((j>0) and (j<=LabelBase)) then
            begin
             inc(subttGroupCnt);
             XML_DISPLAY.SubTtGroup[subttGroupCnt]:=j;
            end;
          end; {for i}
         if bool(subttGroupCnt) then {only if some subs were there}
          begin
           subjectTtablewinSelect;
           UpdateWindow(wnSubjectTt);
          end;
        end
       else   //normal cell
        begin
         subttGroupCnt:=1;
         XML_DISPLAY.SubTtGroup[1]:=s;
        end;
       UpdateWindow(wnSubjectTt)
      end;
    end;
  end;
 {te tt}
 if wnFlag[wnTeacherTt] then
  begin
   if ((t<=NumCodes[1]) and (t>0)) then //only for valid te code
    begin
     if winView[wnTeacherTt]=0 then {daily}
      begin
       XML_DISPLAY.tettlistVals[4]:=nd;
       XML_DISPLAY.tettlistVals[5]:=nd;
      end;
     XML_DISPLAY.tettseltype:=2;
     XML_DISPLAY.TeTtSelection[0]:=1;
     XML_DISPLAY.TeTtSelection[1]:=t;
     UpdateWindow(wnTeacherTt);
    end;
  end;
 {ro tt}
 if wnFlag[wnRoomTt] then
  begin
   if ((r<=NumCodes[2]) and (r>0)) then //only for valid ro code
    begin
     if winView[wnRoomTt]=0 then {daily}
      begin
       XML_DISPLAY.rottlistVals[4]:=nd;
       XML_DISPLAY.rottlistVals[5]:=nd
      end;
     XML_DISPLAY.rottseltype:=2;
     XML_DISPLAY.RoTtSelection[0]:=1;
     XML_DISPLAY.RoTtSelection[1]:=r;
     UpdateWindow(wnRoomTt)
    end;
  end;
 {sub by sub}
 if wnFlag[wnSubjectList] then
  begin
   if ((s<=NumCodes[0]) and (s>0)) then //only for valid sub code
    begin
     if s<LabelBase then
      begin
       XML_DISPLAY.SubListType:=2;
       XML_DISPLAY.sublistRanges[-1]:=s;
       XML_DISPLAY.sublistRanges[-2]:=s;
       UpdateWindow(wnSubjectList);
      end;
    end;
  end;
 {sub by time slot}
 if wnFlag[wnTimeList] then
  begin
   XML_DISPLAY.sublistday:=nd;
   XML_DISPLAY.sublistYear:=ny;
   XML_DISPLAY.sublisttime1:=np;
   XML_DISPLAY.sublisttime2:=np;
   UpdateWindow(wnTimeList);
  end;
 {te clashes}
 if wnFlag[wnTeClash] then UpdateWindow(wnTeClash);
 {ro clashes}
 if wnFlag[wnRoClash] then UpdateWindow(wnRoClash);
 {te loads}
 if wnFlag[wnTeTimes] then
  begin
   if ((t<=NumCodes[1]) and (t>0)) then //only for valid te code
    begin
     XML_DISPLAY.teachertimesshow1:=2;
     winView[wnTeTimes]:=1;
     XML_DISPLAY.teachertimesshow2:=2;
     XML_DISPLAY.TeTimesSelect[0]:=1;
     XML_DISPLAY.TeTimesSelect[1]:=t;
     UpdateWindow(wnTeTimes)
    end;
  end;
 {sub times}
 if wnflag[wnSuTimes] then
  begin
   XML_DISPLAY.subjecttimesyear:=ny;
   UpdateWindow(wnSuTimes)
  end;
 {clash help}
 if wnFlag[wnCHelp] then
  begin
   chd:=nd; chp:=np; chy:=ny; chl:=nl;
   XML_DISPLAY.chScope:=0;
   XML_DISPLAY.chType:=2;
   UpdateWindow(wnCHelp)
  end;
end;

procedure ttCalc(ttrow,ttcol:  smallint);
var
 i,j,k,n:         smallint;
begin
 j:=0;  i:=0;   k:=0; n:=0;
 while (j<ttcol) do
  begin
   inc(j,tlimit[i]);
   inc(i);
   if j>=ttcol then break;
  end;
 if i>0 then dec(i);
 ttcalcD:=i;
 ttcalcP:=(ttcol-(j-tlimit[i]))-1;
 j:=1;
 for i:=years_minus_1 downto 0 do
  begin
   inc(j,Level[i]+1);
   if j>=ttrow then
    begin
     k:=i;
     n:=Level[i]-(j-ttrow);
     break;
    end;
  end;
 ttcalcY:=k;
 ttcalcL:=n;
end;

procedure BringIntoView;
var
  TRow,LCol,CurRow,CurCol,ShowCols,ShowRows,MaxRows,MaxCols: integer;
begin
 with Ttablewin.StringGrid1 do
  begin
   MaxRows:=RowCount-2;  MaxCols:=ColCount-1;
   ShowCols:=VisibleColCount;
   if ShowCols<1 then ShowCols:=1;
   if ShowCols>MaxCols then ShowCols:=MaxCols;
   ShowRows:=VisibleRowCount;
   if ShowRows>MaxRows then ShowRows:=MaxRows;
   if ShowRows < 1 then ShowRows := 1;
   TRow:=FindRow(yl,ll); LCol:=FindCol(dl,pl);  {current top row & left col}
   CurRow:=FindRow(ny,nl); CurCol:=FindCol(nd,np);  {current position}
   if CurRow>RowCount then CurRow:=RowCount;
   if CurCol>ColCount then CurCol:=ColCount;

   if (CurCol>(LCol+ShowCols-1)) and (CurCol<(LCol+ShowCols+1)) then
      LCol:=CurCol-ShowCols+1;
   if (CurCol>LCol+ShowCols) then LCol := CurCol;
   if CurCol<LCol then LCol:=CurCol;
   if LCol < 1 then LCol := 1;
   if LCol > ColCount-ShowCols then LCol:=ColCount-ShowCols;

   if (CurRow>(TRow+ShowRows-2)) and (CurRow<(TRow+ShowRows+1)) then
      TRow:=CurRow-ShowRows+2;
   if (CurRow>TRow+ShowRows) then TRow:=CurRow;
   if CurRow < TRow then TRow := CurRow;
   if (TRow=CurRow) and (nl=1) then dec(TRow);
   if TRow < 2 then TRow := 2;
   if TRow>RowCount-ShowRows+1 then TRow:=RowCount-ShowRows+1;
   ttCalc(TRow, LCol);
   dl := ttcalcD; pl := ttcalcP; yl := ttcalcY; ll := ttcalcL;
   LeftCol := LCol;
   TopRow := TRow;
   Ttablewin.ShowCurrentCell;
  end;
end;

procedure ttclash;
var
 d,p: integer;
begin
 for d:=0 to days-1 do
  for p:=0 to Tlimit[d]-1 do tsClash(d,p);
 clashtotal;
end;

procedure clashtotal;
var
 i,j: integer;
begin
 TclashTot:=0;
 RclashTot:=0;
 for i:=0 to days-1 do
  for j:=0 to periods-1 do
   begin
    inc(TclashTot,Tclash[i,j]);
    inc(RclashTot,Rclash[i,j])
   end;
end;

procedure TTtablewin.UpdateTTclashBar;
var
 p,d,i          : integer;
 blankwidth     : integer;
 theight        : integer;
 localx         : integer;
 basex          : integer;
 aRect          : TRect;
 tmpcanvasbitmap: Tbitmap;
 GridSpaceUsed  : integer;
begin
 if drawingClashBar then exit;
 drawingClashBar:=true;
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
 aRect.top:=0; aRect.bottom:=Image1.height;  aRect.left:=0;
 aRect.right:=Image1.width;
 Image1.canvas.brush.color:=clSilver;
 Image1.canvas.fillrect(aRect);
 blankwidth:=Image1.canvas.textwidth(' ');
 theight:=Image1.canvas.textheight('Ag');
 with StringGrid1 do
  begin
   if LeftCol<1 then LeftCol:=1;
   ttCalc(TopRow,LeftCol);
   p:=ttcalcP; d:=ttcalcD;
   basex:=ColWidths[0];
   inc(basex,gridLineWidth*2);
  end; {with Stringgrid1}
 clashtotal;
 Image1.canvas.font.color:=FontColorPair[cpTeach,1];
 Image1.canvas.textout(0,0,'T:'+IntToStr(TclashTot));
 Image1.canvas.font.color:=FontColorPair[cpRoom,1];
 Image1.canvas.textout(0,theight,'R:'+IntToStr(RclashTot));
 GridSpaceUsed:=0;
 for i:= StringGrid1.LeftCol to (StringGrid1.ColCount-1) do
  begin
   inc(GridSpaceUsed,StringGrid1.ColWidths[i]);
   if GridSpaceUsed>=StringGrid1.clientwidth then break;
  end;
 i:=0;
 while (basex<GridSpaceUsed) do
  begin
   localx:=basex+blankwidth*2+fwCodeBlank[0];
   Image1.canvas.font.color:=FontColorPair[cpTeach,1];
   Image1.canvas.textout(localx,0,IntToStr(Tclash[d,p]));
   localx:=localx+blankwidth+fwCodeBlank[1];
   Image1.canvas.font.color:=FontColorPair[cpRoom,1];
   Image1.canvas.textout(localx,theight,IntToStr(Rclash[d,p]));
   inc(basex,StringGrid1.ColWidths[StringGrid1.LeftCol+i]);
   inc(i);
   inc(basex,StringGrid1.gridLineWidth);
   inc(p);
   if (p>=Tlimit[d]) then
    begin
     p:=0; inc(d)
    end;
   if (d>=days) then break
  end; {while (basex<stringgrid1.clientwidth) }
 drawingClashBar:=false;
end;

procedure TTtablewin.InitTTWin;
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
 caption:='Timetable  Version:'+Version+'  File:'+FileNames.LoadedTimeTable;
 ttableWin.Font.Assign(XML_DISPLAY.tcFont);
 RenewFont(Canvas);
 RenewFont(stringgrid1.canvas);
 RenewFont(image1.canvas);

 blankwidth:=canvas.textwidth(' ');
 topgap:=blankwidth div 2;
 scalingGridCellsFlag:=true;
 with StringGrid1 do
  begin
   j:=0;
   for i:=0 to days-1 do inc(j,tlimit[i]);
   Colcount:=fixedcols+j;
   {set colwidths}
   colwidthmax:=canvas.textwidth(yearshort+'    ')+fwYearname;
   //check for class width in columns
   i:=canvas.textwidth('   ')+fwClass;
   if (i>colwidthmax) then colwidthmax:=i;
   colwidths[0]:=colwidthmax+4;
   colwidthmax:=1+fwCodeBlank[0]+fwCodeBlank[1]+fwCodeBlank[2]+blankwidth*4;
   w4:=(fwDayname+canvas.textwidth(':99 '));
   if w4>colwidthmax then colwidthmax:=w4;

   for i:=1 to (colcount-1) do colwidths[i]:=colwidthmax;
   j:=years;
   for i:=0 to years_minus_1 do inc(j,Level[i]);
   RowCount:=fixedrows+j;

   rowheightmax:=canvas.textheight('Ag')+topgap*2;
   for i:=0 to (rowCount-1) do rowheights[i]:=rowheightmax;
   scalingGridCellsFlag:=false;

   if XML_DISPLAY.winpos[wnTtable].height>0 then
    begin
     scalingGridCellsFlag:=true;  {prevent topleftchange event-triggered code}
     leftcol:=findcol(dl,pl); {restore col}
     y:=findrow(yl,ll);
     if (yl=ny) and (nl=ll) and (nl=1) then dec(y);
     toprow:=y;  {restore row, 2 fixed rows}
     scalingGridCellsFlag:=false;
     {restore selection}
     curposCoord.y:=findrow(ny,nl);
     curposCoord.x:=findcol(nd,np);
     curTgridRect.topleft:=curposCoord;
     curTgridRect.bottomright:=curposCoord;
     { MUST assign entire record at once - but can read individual record fields}
     selection:=curTgridRect;
    end  {if winPos[wnTtable].height>0}
   else {init selection}
    begin
     curposCoord.x:=1;
     curposCoord.y:=3;
     curTgridRect.topleft:=curposCoord;
     curTgridRect.bottomright:=curposCoord;
     selection:=curTgridRect;
    end;
  end;
 panel1.height:=rowheightmax;
 label1.top:=0;
 label1.left:=panel1.clientwidth-label1.width;
 label2.top:=0;
 label2.left:=blankwidth div 2;
 label2.caption:='Top: '+yearshort+'  '+yearname[years_minus_1]+'   Lev: 1 ';
 alterTimeFlag:=false;
 UpdateTTclashBar;
 repaint;
 restoreTTselection;
end;

procedure TTtablewin.FormActivate(Sender: TObject);
begin
  Cut1.ShortCut:=ShortCut(word('X'),[ssCtrl]);
  Copy1.ShortCut:=ShortCut(word('C'),[ssCtrl]);
  Paste1.ShortCut:=ShortCut(word('V'),[ssCtrl]);
  Delete1.ShortCut:=ShortCut(46,[]);
  mainform.CopyWin.ShortCut:=ShortCut(word('C'),[ssCtrl]);
  if loadFinished and wnFlag[wnTtable] then UpdateTTclashBar;
  SetColumnWidth;
 // #994
  if (usrPassLevel <> utTime) and (usrPassLevel <> utSuper) then
  begin
    InUse1.Enabled := false;
  end;
end;

procedure TTtablewin.FormClose(Sender: TObject; var Action: TCloseAction);
var
 tmprect: TRect;
begin
 XML_DISPLAY.fgReshowTTtoolbar:=fgTTtoolbar;
 if fgTTtoolbar then
  begin
   if (panel2.dockclientcount=1) or (panel3.dockclientcount=1) then
    begin
     tmprect.left:=XML_DISPLAY.winpos[wnTtTool].left;
     tmprect.top:=XML_DISPLAY.winpos[wnTtTool].top;
     tmprect.bottom:=tmprect.top+XML_DISPLAY.winpos[wnTtTool].height;
     tmprect.right:=tmprect.left+XML_DISPLAY.winpos[wnTtTool].width;
     TtableToolbarWin.ManualFloat(tmprect);
    end;
   inc(XML_DISPLAY.winOrderNum);
   XML_DISPLAY.winOrder[XML_DISPLAY.winOrderNum]:=wnTtTool;
   TtableToolbarWin.close;
  end;

 Action:=cafree;
 wnFlag[wnTtable]:=false; {need to create on next request}
 savewinpos(Self);
 if fEntryDlgUp then {release dlg if still up}
  begin
   Entrydlg.Free;
   fEntryDlgUp:=false
  end;
 if fSearchReplaceDlgUp then {release dlg if still up}
  begin
   SearchDlg.Free;
   fSearchReplaceDlgUp:=false
  end;
end;

procedure TTtablewin.ShowCurrentCell;
begin
 case box of
  bxCell: Label1.caption:='['+yearShort+' '+ Yearname[ny]+
             '  Lev: '+IntToStr(nl)+'  '+day[nd]+': '+IntToStr(np+1)+']  ';
  bxLevel: Label1.caption:='['+yearShort+' '+Yearname[ny]+
               '  Lev: '+IntToStr(nl)+']   ';
  bxYear: Label1.caption:='['+yearShort+' '+Yearname[ny]+']  ';
  bxYrTime: Label1.caption:='['+yearShort+' '+Yearname[ny]+' '+
                 day[nd]+':'+IntToStr(np+1)+']  ';
  bxTime: Label1.caption:='['+' '+ day[nd]+': '+IntToStr(np+1)+']  ';
  bxBlock: Label1.caption:='['+yearShort+' '+Yearname[ny]+
                '  Lev: '+IntToStr(nl)+'  '+day[nd]+': '+IntToStr(np+1)+']  ';
  bxDay: Label1.caption:='['+day[nd]+']  ';
 end;
 Label1.left:=Panel1.clientwidth-Label1.width;
 if XML_DISPLAY.tcCurPeriodOnly then UpdateWindow(wnTeClash); {only if for cur per only}
 if XML_DISPLAY.rcCurPeriodOnly then UpdateWindow(wnRoClash); {selected on dlgs}
 if XML_DISPLAY.EntrySelectionLink then checkLinkedWins;
 if fEntryDlgUp then setEntryDlgPosExt;
end;

procedure TTtablewin.StringGrid1SelectCell(Sender: TObject; Col, Row: longint;
              var CanSelect: boolean);
begin
 if controlkeyFlg then exit; {prevent cell selection changing on ctrl key press}
 ttCalc(Row,Col);
 np:=ttcalcP; nd:=ttcalcD;  ny:=ttcalcY;  nl:=ttcalcL;
 ShowCurrentCell;
 Ttablewin.repaint;
 if fEntryDlgUp then if nl>0 then setEntryDlgPosExt;

 if fSearchReplaceDlgUp then
  begin
    SearchDlg.ComboBox1.text:=Yearname[ny];
    SearchDlg.Edit1.text:=IntToStr(nl);
    SearchDlg.ComboBox2.text:=day[nd];
    SearchDlg.combobox3.ItemIndex:=np;
    SearchDlg.update
  end;
end;

procedure TTtablewin.StringGrid1DragDrop(Sender, Source: TObject; X, Y: Integer);
var
  lCol: Integer;
  lRow: Integer;
begin
  StringGrid1.MouseToCell(X, Y, lCol, lRow );
  StringGrid1.Col := lCol;
  StringGrid1.Row := lRow;
  Paste1Click(Self);
end;

procedure TTtablewin.StringGrid1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept := True;
end;

procedure TTtablewin.StringGrid1DrawCell(Sender: TObject; Col,
  Row: Longint; Rect: TRect; State: TGridDrawState);
var
 d,p,y,l:       smallint;
 i,su,te,ro:       smallint;
 x:                 integer;
 IntPoint:      tpIntPoint;
 tmpStr:            string;
 localx,localy,localWide:     integer;
 blankwidth,topgap:        integer;
 CellType:            integer;
 flgDouble:    boolean; {first 3 bits of 7th byte}
 blockNumber:                  smallint; {last 5 bits of 7th byte}
 flgTclash,flgRclash:          boolean; {4th & 5th (vals 8 &16) bits of 8th byte}
 sByte,cByte:                  byte;
 aRect:                        Trect; {for aligning highlights}
 fontHeight:                   integer;
 tlimitTotal:                  integer;

   procedure Setbrush;
   var
    myCol: Tcolor;
   begin
    if gdSelected in State then myCol:=FontColorHiLitePair[cpTtable,1]
     else myCol:=FontColorHiLitePair[cpTtable,2];
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
 x:=years+1;     {plus 1 for period name row}
 for i:=years_minus_1 downto 0 do inc(x,Level[i]);
 if (row>x) then exit; {bottom max}
 tlimitTotal:=0;
 for i:=0 to days-1 do inc(tlimitTotal,tlimit[i]);
 if (col>tlimitTotal) then exit; {right max}

 ttcalc(row,col);
 p:=ttcalcP;  d:=ttcalcD;  y:=ttcalcY; l:=ttcalcL;

 blankwidth:=stringgrid1.canvas.textwidth(' ');
 fontHeight:=stringgrid1.canvas.textheight('Ag');
 localx:=rect.left+blankwidth;
 topgap:=blankwidth div 2; localy:=rect.top+topgap;

 CellType:=0;
 if (col=0) and (row>1) then CellType:=1;
 if (row<2) and (col>0) then CellType:=2;
 if (col>0) and (row>1) then CellType:=3;

 if CellType=1 then  {yearname or roll class code}
  begin
   fcolor(cpInfoHead);
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

 if CellType=2 then  {time slot names}
  begin
   fcolor(cpInfoHead);
   if row=0 then tmpStr:=Day[d]+':'+inttostr(p+1) else tmpStr:=TimeSlotName[d,p];
   localx:=(rect.left+rect.Right-stringgrid1.canvas.textwidth(tmpStr)) div 2;
   stringgrid1.canvas.TextOut(localx,localy,tmpStr);
  end;

 if (Col>0) and (Row>1) then
  begin
   SetBrush;
   StringGrid1.Canvas.FillRect(Rect);
  end;

 if (CellType=3) and (l>0) then {timetable entry}
  begin
   aRect.top:=localy; aRect.bottom:=aRect.top+fontHeight;
   IntPoint:=FNT(d,p,y,l,0);
   sByte:=FNTByte(d,p,y,l,6)^;
   cByte:=FNTByte(d,p,y,l,7)^;
   su:=IntPoint^; inc(IntPoint);
   te:=IntPoint^; inc(IntPoint);
   ro:=IntPoint^;
   flgDouble:=((sByte and 1)=1);
   blockNumber:=FNgetBlockNumber(d,p,y,l);
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
  UpdateTTclashBar;
end;

procedure TTtablewin.StringGrid1TopLeftChanged(Sender: TObject);
var
 L: integer;
begin
 {prevent multiple repaints as topleft changes as colwidth and rowheight change}
 if scalingGridCellsFlag then exit;
 ttCalc(StringGrid1.TopRow, StringGrid1.LeftCol);
 pl:=ttcalcP; dl:=ttcalcD; yl:=ttcalcY; ll:=ttcalcL;
 L:=ll;
 if L<1 then L:=1; {no zero level}
 Label2.caption:='Top :'+yearShort+' '+Yearname[yl]+
    ' Lev:'+IntToStr(L)+'  ';
 UpdateTTclashBar;
end;

procedure TTtablewin.FormResize(Sender: TObject);
var
 a: integer;
begin
 a:=StringGrid1.canvas.textwidth('  ');
 Label1.left:=Panel1.clientwidth-StringGrid1.canvas.textwidth(Label1.caption);
 if Label1.left<Label2.left+Label2.width+a then
  Label1.left:=Label2.left+Label2.width+a;
 UpdateTTclashBar;
end;

procedure TTtablewin.FormShow(Sender: TObject);
begin
   // #994
  if (usrPassLevel <> utTime) and (usrPassLevel <> utSuper) then
  begin
    InUse1.Enabled := false;
  end;

end;

procedure TTtablewin.FormCreate(Sender: TObject);
begin
 drawingInProcess:=false;
 drawingClashBar:=false;
 Label1.caption:='';
 setWindowDefaults(Self,wnTtable);
 doubleclick:=false;
 //if fgReshowTTtoolbar then
 tttoolbarSelect;
 if fgTTtoolbar then
  try
   case XML_DISPLAY.fgTTtoolbarDock of {restore docked toolbar}
    1: TtableToolbarWin.ManualDock(panel2);
    2: TtableToolbarWin.ManualDock(panel3);
   end; {case}
  except
  end;
// #994
  if (usrPassLevel <> utTime) and (usrPassLevel <> utSuper) then
  begin
    InUse1.Enabled := false;
  end;
end;

procedure TTtablewin.StringGrid1MouseDown(Sender: TObject; Button: TMouseButton;
              Shift: TShiftState; X, y: integer);
var
 aRow, aCol: longint;
 p, d, k, n: integer;
 curSelection: TgridRect;
 i, j: integer;
begin
  StringGrid1.MouseToCell(X, y, aCol, aRow);
  if (aRow <> -1) and (aCol <> -1) then
  begin
    controlkeyFlg := False;
    if doubleclick then
    begin
      doubleclick := False;
      Exit;
    end;
    Ttablewin.Repaint;
    ttCalc(aRow, aCol);
    p := ttcalcP; d := ttcalcD; k := ttcalcY; n := ttcalcL;

    box:=bxCell;
    if (aCol=0) and (aRow<2) then box:=bxAll;
    if (aCol>0) and (aRow=0) then box:=bxDay;
    if (aCol>0) and (aRow=1) then box:=bxTime;
    if (aCol=0) and (aRow>1) and (n=0) then box:=bxYear;
    if (aCol=0) and (aRow>1) and (n>0) then box:=bxLevel;
    if (aCol>0) and (n=0) then box:=bxYrTime;

    case box of
     bxAll: begin
             curSelection.left:=aCol; curSelection.right:=StringGrid1.ColCount;
             curSelection.top:=0;     curSelection.bottom:=StringGrid1.RowCount;
             nd:=0; np:=0; ny:=0; nl:=1;
            end;
     bxDay: begin
             j:=1; for i:=0 to d-1 do inc(j,Tlimit[i]);
             curSelection.left:=j;   curSelection.right:=j+Tlimit[d]-1;
             curSelection.top:=aRow; curSelection.bottom:=StringGrid1.RowCount;
             nd:=d; np:=0; ny:=k; nl:=1;
            end;
     bxTime: begin
              curSelection.left:=aCol; curSelection.right:=aCol;
              curSelection.top:=aRow;  curSelection.bottom:=StringGrid1.RowCount;
              nd:=d; np:=p; ny:=k; nl:=1;
             end;
     bxYear: begin
              curSelection.left:=aCol;  curSelection.right:=StringGrid1.ColCount;
              curSelection.top:=aRow;   curSelection.bottom:=aRow+level[k];
              nd:=0; np:=0; ny:=k; nl:=1;
             end;
     bxLevel: begin
               curSelection.left:=aCol; curSelection.right:=StringGrid1.ColCount;
               curSelection.top:=aRow;  curSelection.bottom:=aRow;
               nd:=0; np:=0; ny:=k; nl:=n;
              end;
     bxYrTime: begin
                curSelection.left:=aCol;  curSelection.right:=aCol;
                curSelection.top:=aRow;   curSelection.bottom:=aRow+level[k];
                nd:=d; np:=p; ny:=k; nl:=1;
               end;
     bxCell: begin
              curSelection.left:=aCol;  curSelection.right:=aCol;
              curSelection.top:=aRow;   curSelection.bottom:=aRow;
              nd:=d; np:=p; ny:=k; nl:=n;
             end;
    end; {case}
    StringGrid1.Selection := curSelection;
    ShowCurrentCell;
  end;
end;

procedure TTtablewin.Selection1Click(Sender: TObject);
begin
 ttprintselectiondlg:=Tttprintselectiondlg.Create(Self); {allocate dlg}
 ttprintselectiondlg.ShowModal;
 ttprintselectiondlg.Free
end;

procedure TTtablewin.SetColumnWidth;
var
  p, d: Integer;
  lColIdx: Integer;
  lColWidthMax: Integer;

  function RefreshColWidth: Integer;
  var
   i,j:       smallint;
   blankwidth:     smallint;
   topgap:         smallint;
   w4,colwidthmax:    smallint;
  begin
   blankwidth:=canvas.textwidth(' ');
   topgap:=blankwidth div 2;
   with StringGrid1 do
    begin
     j:=0;
     for i:=0 to days-1 do inc(j,tlimit[i]);
     Colcount:=fixedcols+j;
     {set colwidths}
     colwidthmax:=canvas.textwidth(yearshort+'    ')+fwYearname;
     //check for class width in columns
     i:=canvas.textwidth('   ')+fwClass;
     if (i>colwidthmax) then colwidthmax:=i;
     colwidths[0]:=colwidthmax+4;
     colwidthmax:=1+fwCodeBlank[0]+fwCodeBlank[1]+fwCodeBlank[2]+blankwidth*4;
     w4:=(fwDayname+canvas.textwidth(':99 '));
     if w4>colwidthmax then colwidthmax:=w4;

     for i:=1 to (colcount-1) do colwidths[i]:=colwidthmax;
    end;
    Result := colwidthmax;
  end;

  function GetNormalColWidth: Integer;
  var
    i: Integer;
    lWidth: Integer;
  begin
    lWidth := 0;
    for i := 0 to StringGrid1.ColCount - 1 do
    begin
      if lWidth < StringGrid1.ColWidths[i] then
        lWidth := StringGrid1.ColWidths[i];
    end;
    Result := lWidth;
  end;

  function IsEmptyColumns(const pPer, pDay: Integer): Boolean;
  var
    y,l: Integer;
    te,ro, lSub: Integer;
    lFound: Boolean;
    IntPoint: tpIntPoint;
  begin
    lFound := False;
    for y:=0 to years_minus_1 do
    begin
       for l:=1 to level[y] do
       begin
         Intpoint := FNT(pDay, pPer, y, l, 2);
         te:=Intpoint^;
         Inc(Intpoint);
         ro:=Intpoint^;
         Inc(Intpoint);
         lSub := Intpoint^;
         if (te=0) and (ro=0) then continue;
         if (lSub > 0) or (te > 0) or (ro > 0) then
         begin
           lFound := True;
         end;
       end;{l}
       if lFound then Break;
    end; {y}
    Result := not lFound;
  end;
begin
  lColWidthMax := RefreshColWidth;
  lColIdx := 1;
  for D :=0 to days-1 do
  begin
    for p := 0 to tlimit[d] -1 do
    begin
      Inc(lColIdx);
      if lColIdx <= StringGrid1.ColCount  then
        if IsEmptyColumns(p, D) then
          StringGrid1.ColWidths[lColIdx -1] := 70  // Make sure the sizes are accurate
        else
          StringGrid1.ColWidths[lColIdx -1] := lColWidthMax;
    end;
  end;
end;

procedure TTtablewin.Version1Click(Sender: TObject);
begin
 mainform.Version1Click(Self)
end;

procedure TTtablewin.Years1Click(Sender: TObject);
begin
 mainform.Years1Click(Self)
end;

procedure TTtablewin.Days1Click(Sender: TObject);
begin
 mainform.Days1Click(Self)
end;

procedure TTtablewin.TimeSlots1Click(Sender: TObject);
begin
 mainform.TimeSlots1Click(Self)
end;

procedure TTtablewin.Levels1Click(Sender: TObject);
begin
 mainform.Levels1Click(Self)
end;

procedure MoveSelect(moveType: byte);
begin
 if moveType=0 then exit;{none}
 case moveType of
  1: begin {right}
      if (nd=days-1) and (np=Tlimit[nd]-1) then exit; {already on right}
      inc(np);
      if (np >= Tlimit[nd]) then
       begin
         np:=0;
         inc(nd)
       end;
     end;
  2: begin {left}
      if (nd=0) and (np=0) then exit;
      if (np=0) then
       begin
        dec(nd); np:=Tlimit[nd]-1;
       end else dec(np);
     end;
  3: begin {down}
      if (ny=0) and (nl=level[ny]) then exit;
      inc(nl);
      if nl > level[ny] then
       begin
         dec(ny);
         nl:=1
       end;
     end;
  4: begin {up}
      if (ny=years_minus_1) and (nl=1) then exit;
      dec(nl);
      if nl < 1 then
       begin
         inc(ny);
         nl:=level[ny]
       end;
     end;
 end; {case}
end;

procedure TTtablewin.StringGrid1KeyDown(Sender: TObject; var Key: word; Shift:
                                        TShiftState);
var
 Srect   : TgridRect;
 Row,Col  : integer;
 dochange: bool;
begin
 dochange:=false;
 controlkeyFlg:=false; {prevent cell selection changing on ctrl key press}
 case Key of
  VK_RETURN: begin
              StringGrid1DblClick(Self);
              exit
             end;
  VK_CONTROL: controlkeyFlg:=true;
  vk_up: begin
          Key:=0;
          if (nl>1) or (ny<years_minus_1) then
           begin
            dochange:=true;
            MoveSelect(4)
           end;
          end;
  vk_down: begin
            Key:=0;
            if (ny>0) or (nl<level[ny]) then
             begin
              dochange:=true;
              MoveSelect(3)
             end;
           end;
  vk_home: begin
            Key:=0;
            dochange:=true;
            nd:=hd; np:=hp; ny:=hy; nl:=hl
           end;
  vk_prior: begin
             Key:=0;
             if (ny<>years_minus_1) then
              begin
               dochange:=true;
               inc(ny);
               if ny>years_minus_1 then ny:=years_minus_1;
               nl:=1; yl:=ny; ll:=1;
               Row:=FindRow(yl,ll);
               dec(Row); StringGrid1.TopRow:=Row
              end;
            end;
  vk_next: begin
            Key:=0;
            if (ny<>0) then
             begin
              dochange:=true;
              dec(ny);
              nl:=1; yl:=ny; ll:=1;
              Row:=FindRow(yl,ll);
              dec(Row);  StringGrid1.TopRow:=Row
             end;
           end;
  190: begin {> key}
        Key:=0;
        if nd<days-1 then
         begin
          dochange:=true;
          inc(nd)
         end;
       end;
  188: begin {< key}
        Key:=0;
        if nd>0 then
         begin
          dochange:=true;
          dec(nd)
         end;
       end;
 end; {case}
 if dochange then
  begin
   Row:=FindRow(ny,nl);
   Col:=FindCol(nd,np);
   Srect.top:=Row;  Srect.left:=Col;
   Srect.bottom:=Row; Srect.right:=Col;
   StringGrid1.selection:=Srect;
   box:=bxCell;
   BringIntoView;
   if fEntryDlgUp then if nl>0 then setEntryDlgPosExt;

   if fSearchReplaceDlgUp then
    begin
     SearchDlg.ComboBox1.text:=Yearname[ny];
     SearchDlg.Edit1.text:=IntToStr(nl);
     SearchDlg.ComboBox2.text:=day[nd];
     SearchDlg.ComboBox3.ItemIndex:=np;
     SearchDlg.update
    end;
  end;
end;

procedure TTtablewin.ExportAsSpecialTextFile(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  lGenericTtable: Boolean;
begin
  if (Key = Ord('S')) and (ssShift in Shift) then
  begin
    lGenericTtable := XML_DISPLAY.GenericTtableFlag;
    if not XML_DISPLAY.GenericTtableFlag then
    begin
      XML_DISPLAY.GenericTtableFlag := True;
    end;
    try
      if MessageDlg('Time Chart will export the time table in a special format file. Are you sure you want to proceed?', mtConfirmation, mbYesNo, 0) = mrYes then
        try
          MainTimeTableText(False, True);
        finally
          OutTtableWin.IsSpecial := False;
          OutTtableWin.IncludeRC := False;
        end;
    finally
      XML_DISPLAY.GenericTtableFlag := lGenericTtable;
    end;
  end
  else if (Key = Ord('R')) and (ssShift in Shift) then
  begin
    lGenericTtable := XML_DISPLAY.GenericTtableFlag;
    if not XML_DISPLAY.GenericTtableFlag then
    begin
      XML_DISPLAY.GenericTtableFlag := True;
    end;
    try
      try
        MainTimeTableText(True, False);
      finally
        OutTtableWin.IsSpecial := False;
        OutTtableWin.IncludeRC := False;
      end;
    finally
      XML_DISPLAY.GenericTtableFlag := lGenericTtable;
    end;
  end;
end;

procedure TTtablewin.Entries1Click(Sender: TObject);
begin
if CheckAccessRights(utTime,16,true) then
 begin
  if not (fEntryDlgUp) then {only create if doesnt exist !!}
   begin
    Entrydlg:=Tentrydlg.Create(Self); {allocate dlg}
    fEntryDlgUp:=true
   end;
  Entrydlg.show
 end;
end;


procedure TTtablewin.StringGrid1DblClick(Sender: TObject);
begin
 doubleclick := true;
 if ((box=bxLevel) or (box=bxYear)) then RollClasses1Click(self)
  else Entries1Click(Self);
end;


procedure TTtablewin.Home1Click(Sender: TObject);
var
 Srect   : TgridRect;
 Row,Col : integer;
 dochange: bool;
begin
 dochange:=((nd<>hd) or (ny<>hy) or (nl<>hl) or (np<>hp));
 nd:=hd; np:=hp; ny:=hy; nl:=hl;
 if dochange then
  begin
   Row:=FindRow(ny,nl); Col:=FindCol(nd,np);
   Srect.top:=Row;   Srect.left:=Col;
   Srect.bottom:=Row; Srect.right:=Col;
   StringGrid1.selection := Srect
  end;
 BringIntoView;
end;



procedure TTtablewin.Box1Click(Sender: TObject);
begin
 if CheckAccessRights(utTime,16,true) then
  begin
   Boxdlg:=Tboxdlg.Create(Self); {allocate dlg}
   Boxdlg.ShowModal;
   Boxdlg.Free;
   if not(saveTimeFlag) then CheckAccessRights(utTime,16,false)
  end;
end;


procedure TTtablewin.Build1Click(Sender: TObject);
begin
// if CheckAccessRights(utTime,16,true) then
//  begin
//   BuildDlg:=TBuildDlg.Create(Self); {allocate dlg}
//   BuildDlg.ShowModal;
//   BuildDlg.Free;
//   if not(saveTimeFlag) then CheckAccessRights(utTime,16,false)
// end;
  CopyDataWithinTimeTable(self);
end;

procedure TTtablewin.Goto1Click(Sender: TObject);
begin
 Gotodlg:=TGotodlg.Create(Self); {allocate dlg}
 Gotodlg.ShowModal;
 Gotodlg.Free
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


procedure TTtablewin.Clear1Click(Sender: TObject);
var
  Msg: string;
  i  : integer;
begin
 if CheckAccessRights(utTime,16,true) then
  begin
   Msg:='CLEAR ALL ENTRIES from the WHOLE TIMETABLE?';
   if messagedlg(Msg,mtWarning,[mbyes,mbno],0)<>mrYes then
    begin
     if not(saveTimeFlag) then CheckAccessRights(utTime,16,false);
     exit;
    end;
   pushAllTtStack(utClear);  //push whole ttable
   for i:=0 to days-1 do fillchar(ttMain[i]^,sizeof(ttMain[i]^),chr(0));
   fillchar(Tclash,sizeof(Tclash),chr(0));
   fillchar(Rclash,sizeof(Rclash),chr(0));
   fillchar(Fclash,sizeof(Fclash),chr(0));
   ttclash; Lnum:=0;
   UpdateTimetableWins;
   SaveTimeFlag:=true;
  end;
end;



{
------------------------ PRINT ROUTINE FOR MAIN TIMETABLE FOLLOWS --------------
}


function ttselect(aFnt:tpIntPoint): boolean;
var
 i  : integer;
 bFnt : tpIntPoint;
 sub,place: smallint;
begin
 Result:=false;
 bFnt:=aFnt;
 sub:=bFnt^;
 if (XML_DISPLAY.ttprntseltype<=1) or (sub>LabelBase) then
  begin
   Result:=true;
   exit
  end;
 inc(bFnt,(XML_DISPLAY.ttprntseltype-2));
 place:=bFnt^;
 case XML_DISPLAY.ttprntseltype of
  2: for i:=1 to XML_DISPLAY.ttPrntSelSubg[0] do  {sub}
      if sub=XML_DISPLAY.ttPrntSelSubg[i] then
       begin
        result:=true; break;
       end;
  3: for i:=1 to XML_DISPLAY.ttPrntSelTeachg[0] do  {te}
      if place=XML_DISPLAY.ttPrntSelTeachg[i] then
       begin
        result:=true; break;
       end;
  4: for i:=1 to XML_DISPLAY.ttPrntSelRoomg[0] do  {ro}
      if place=XML_DISPLAY.ttPrntSelRoomg[i] then
       begin
        result:=true; break;
       end;
  5: if sub>0 then result:=FindSubInFac(XML_DISPLAY.ttPrntFac,sub);
 end; {case}
end;


procedure TPrintTtableWin.head;
begin
 UnderlineOn;
 printwl('Timetable');
 printw(PageCount);
 UnderlineOff;
 x:=0; y:=y+PrnttxtHeight;
end;


procedure TPrintTtableWin.SetTabs;
var
 i,tab1: integer;
begin
 SetLength(PrntTabs,3);
 tab1:=PrintCanvas.textwidth(' Time: ');
 i:=PrintCanvas.textwidth(yearshort)+2*prntblankwidth+fwprntyearname;
 if i>tab1 then tab1:=i;
 if fwprntclass>tab1 then tab1:=fwprntclass;
 if XML_DISPLAY.tfreeshow then
 begin
  i:=PrintCanvas.textwidth('Teachers')+2*prntblankwidth;
  if i>tab1 then tab1:=i;
 end;
 if XML_DISPLAY.rfreeshow then
 begin
  i:=PrintCanvas.textwidth('Rooms')+2*prntblankwidth;
  if i>tab1 then tab1:=i;
 end;
 PrntTabs[1]:=tab1;
end;


procedure TPrintTtableWin.printttable;
var
 found:                boolean;
 astr:    string;
 strtday,finday: integer;
 strtyear,finyear: integer;
 d,yyear,L: integer;
 i,ttspace1,tab1,ygap:          integer;
 lineprinted:                   integer;
 tab2,fitcnt,fitpages,fitstart:     integer;
 fitI,fitI1,fitI2,cNum,endx: integer;
 numperiodsshown:               integer;
 ttprintcontinue,mainformat,firstDay:   boolean;

    Procedure drawHline;
    begin
     inc(y,ygap); drawmyline(0,y,endx,y); inc(y,ygap);
    end;

    procedure drawVlines(ydown:smallint);
    var
     i: integer;
    begin
     drawmyline(0,y-prnttxtheight-ygap,0,y+ygap+ydown);
     for i:=0 to cNum do
      drawmyline(tab1+i*ttspace1,y-prnttxtheight-ygap,tab1+i*ttspace1,y+ygap+ydown);
    end;

   procedure ttPrintTSnames;
   var
    i,i1,k,l:     integer;
   begin
    drawHline;
    printw(' Time:');
    k:=ttspace1 div 2;
    for i1:=fitI1 to fitI2 do
     begin
      i:=tsShow[d,i1];
      L:=PrintCanvas.textwidth(TimeSlotName[d,i]) div 2;
      x:=tab1+(i1-fitI1+1)*ttspace1-k-L;
      printw(TimeSlotName[d,i]);
     end;
    newline; drawVlines(0); drawHline;
   end;


    procedure PartHead;
    begin
     if mainformat then astr:='Main Daily Timetable - '+dayname[d]
     else
       astr:=yeartitle+' '+yearname[XML_DISPLAY.ttprntselyear]+' Timetable - '+dayname[d];
     printw(astr);
     newline;
     ttPrintTSnames;
    end;

    procedure newTTpage;
    begin
     startnewpage;
     header; PartHead;
    end;

    function CheckStartPage: boolean;
    begin
     if (y+4*PrnttxtHeight)>(PrintPageHeight-2*prntTxtHeight) then
      begin
       drawmyline(0,y+ygap+prnttxtheight,endx,y+ygap+prnttxtheight); {close off}
       newTTpage;
       result:=true;
       ttPrintContinue:=true;
      end
     else result:=false;
    end;


   procedure ttablefree;
   var
    i,i1,p,yyear2,L,line,tnum,a,k:       integer;
    tepoint:      array[0..nmbrperiods] of integer;
    astr:         string;
    te:           integer;
    afnt:    tpintpoint;

      procedure nextttableteacher;
      begin
       a:=0;
       while (a=0) do
        begin
         inc(tepoint[p]);
         te:=codepoint[tepoint[p],code];
         astr:=copy(XML_TEACHERS.tecode[te,code-1],1,2); a:=0;
         if tepoint[p]>codeCount[code] then exit;
         if TeachOn[te,p]=0 then
          begin
           a:=te;
           if ((code=1) and (XML_TEACHERS.load[te]=0)) then a:=0;
          end;
         if ((te=0) or (astr='00')) then a:=0;
        end; {while}
      end;


   begin
    for i:=1 to nmbrteachers do
     for p:=0 to nmbrperiods do TeachOn[i,p]:=0;

    for i1:=fitI1 to fitI2 do
     begin
      p:=tsShow[d,i1]+1;
      for yyear2:=0 to years_minus_1 do
       begin
        aFnt:=FNT(d,p-1,yyear2,0,2*code);
        for L:=1 to level[yyear2] do
         begin
          inc(aFnt,4);
          te:=aFnt^;
          inc(TeachOn[te,P]);
          inc(TeachOn[te,0]);
         end; {for L}
       end; {for yyear2}
     end; {for i1}
    for p:=0 to periods do tepoint[p]:=0;
    case code of
     1: printw(' Teachers');
     2: printw(' Rooms');
    end; {case}
    line:=1;
    tnum:=(ttspace1-prntblankwidth) div (prntblankwidth+fwprntcode[code]);
    for i:=1 to numcodes[code] do
     begin
      found:=false;
      if line=2 then
       begin
        printw(' Free');
        inc(line);
       end;

      for i1:=fitI1 to fitI2 do
       begin
        p:=tsShow[d,i1]+1;
        for k:=1 to tnum do
         begin
          nextttableteacher;
          if a>0 then
           begin
            x:=tab1+(i1-fitI1)*ttspace1+((k-1)*(fwprntcode[code]+prntblankwidth))
             +((ttspace1-((fwprntcode[code]+prntblankwidth)*tnum)) div 2);
            if code=1 then fcolor(cpTeach) else if code=2 then fcolor(cpRoom);
            printw(FNsub(a,code));  fcolor(cpNormal);
            found:=true;
           end;
         end; {for k}
       end; {for i1}
      drawVlines(prnttxtheight); {do vert lines as we go and close of at end with continued next header}
      if CheckStartPage then
       begin
        case code of
         1: printw(' Teachers');
         2: printw(' Rooms');
        end; {case}
        line:=1;
       end;
      newline;
      inc(line);
      if not(found) then break;
     end; {for i}
    end;

    procedure ttableprint1;
    var
     i,i1,p,a1:                  integer;
     aFnt,bFnt:            tpintpoint;
     code:                integer;
     tmpStr,cstr:                    string;
     lRClashFlg: Boolean;
     lTClashFlg: Boolean;
     cByte: Byte;
    begin
     lineprinted:=0;
     if ((L=1) or (ttprintcontinue)) then
     begin
      if ttprintcontinue then y:=y-prnttxtheight;
      ttprintcontinue:=false;
      printw(' '+yearshort+' '+yearname[yyear]);
      newline;
     end;
     printw(' '+ClassCode[ClassShown[l,yyear]]);
     for i1:=fitI1 to fitI2 do
      begin
       p:=tsShow[d,i1];
       aFnt:=FNT(d,p,yyear,l,0);
       if ttselect(aFnt) then {no selection, or subg teg rog or fac - 2,3,4 or 5}
       begin
        tab2:=prntblankwidth;
        for code:=0 to 2 do
        begin
         x:=tab1+(i1-fitI1)*ttspace1+tab2;
         bfnt:=afnt;
         inc(bfnt,code);
         a1:=bfnt^;
         if ((code=0) and (a1>=LabelBase)) then
         begin
          cstr:=tclabel[a1-LabelBase];
          trimLabelToFit(cstr,PrintTtableWin.PrintCanvas,(ttspace1-2*prntblankwidth));
          printw(' '+cstr);
          break;
         end
         else
          begin
           tmpstr:=FNsub(a1,code);
           case code of
            0:fcolor(cpSub);
            1:
            begin
              cByte := FNTByte(d, p, yyear, l, 7)^;
              lTClashFlg := ((cByte and 8) = 8);
              if lTClashFlg then  //higlight teacher clash
                fcolor(cpTclash)
              else
              fcolor(cpTeach);
            end;
            2:
            begin
              cByte := FNTByte(d, p, yyear, l, 7)^;
              lRClashFlg := ((cByte and 16) = 16);
              if lRClashFlg then  //higlight room clash
                fcolor(cpRclash)
              else
                fcolor(cpRoom);
            end;
           end;
           printw(' '+tmpstr); fcolor(cpNormal);
          end;
         inc(tab2,fwprntcode[code]+prntblankwidth);
        end; {code}
       end; {if found}
       drawmyline(0,y-(prnttxtheight*(1))-ygap,0,y+ygap+prnttxtheight);
       for i:=0 to cNum do
         drawmyline(tab1+i*ttspace1,y-(prnttxtheight*(1))-ygap,tab1+i*ttspace1,y+ygap+prnttxtheight);
       CheckStartPage;
      end; {for i1}
      newline;
      lineprinted:=-1;
    end;

begin
 ygap:=PrnttxtHeight div 5;    tab1:=PrntTabs[1];
 ClearTeachon; SetPshowMax;
 strtday:=0;  FirstDay:=true;
 finday:=days-1;
 if ((XML_DISPLAY.ttprntselyear=-1) or (XML_DISPLAY.ttPrntType=0)) then {all years or main tt}
  begin
   strtyear:=years-1;
   finyear:=0; mainformat:=true;
  end
 else
  begin
   strtyear:=XML_DISPLAY.ttprntselyear;
   finyear:=XML_DISPLAY.ttprntselyear; mainformat:=false;
  end;
 ttspace1:=4*prntblankwidth+fwprntcode[0]+fwprntcode[1]+fwprntcode[2];
 for d:=strtday to finday do
  begin
   if not(XML_DISPLAY.Dprint[d+1]) then continue;
   {calculate loop limits}
   numperiodsshown:=tsShowMaxDay[d];
   fitcnt:=(PrintPageWidth-prntHmargin-PrntTabs[1]) div ttspace1;
   if fitcnt<1 then fitcnt:=1;
   fitpages:=numperiodsshown div fitcnt;
   if (numperiodsshown mod fitcnt)>0 then inc(fitpages);
   fitstart:=1;

   for fitI:=1 to fitpages do
    begin
     fitI1:=fitstart+((fitI-1)*fitcnt);
     fitI2:=fitI1+fitcnt-1;
     if fitI2>numperiodsshown then fitI2:=numperiodsshown;
     cNum:=fitI2-fitI1+1;  endx:=tab1+cNum*ttspace1;
     ttprintcontinue:=false;
     if firstDay then parthead
      else
       begin
        if mainformat or ((y+10*PrnttxtHeight)>(PrintPageHeight-2*prntTxtHeight))
           then newTTpage else partHead;
       end;
     firstDay:=false;
     for yyear:=strtyear downto finyear do
      begin
       if XML_DISPLAY.pyear[yyear] then
        begin
         for L:=1 to level[yyear] do ttableprint1;
         drawHline;
        end;

       if yyear=finyear then if XML_DISPLAY.tfreeshow then
        begin
         code:=1;  ttablefree;
         drawHline;
        end;
       if yyear=finyear then if XML_DISPLAY.rfreeshow then
        begin
         code:=2;  ttablefree;
         drawHline;
        end;
      end; {for yyear}
     newline;
    end; {for fitI}
  end; {for d}
end;



procedure maintimetableprint;
begin
 PrintTtableWin:=TPrintTtableWin.create;
 with PrintTtableWin do
  try
   PrintHead;
   printttable;
   printCustomAddon;
  finally
   PrintTtableWin.Free;
  end;
end;



{ ----------- TEXT OUT ------------------ }


procedure TOutTtableWin.head;
begin
 printLine(['Timetable']);
end;


procedure TOutTtableWin.OutTtable;
var
 j:            integer;
 found:                boolean;


procedure printttable;
var
 astr:    string;
 strtday,finday: integer;
 strtyear,finyear: integer;
 d,yyear,L: integer;
 i:          integer;
 lineprinted:                   integer;


    procedure ttPrintTSnames;
    var
     i:     integer;
    begin
     printw('Time:'); printc('');
     for i:=1 to tlimit[d] do
      if XML_DISPLAY.TsOn[d,i-1] then
       begin
        printc(TimeSlotName[d,i-1]); printc(''); printc('');
       end;
     newline;
    end;


     procedure ttablefree;
      var
       i,p,yyear2,L,line,tnum,a,k:       integer;
       tepoint:      array[0..nmbrperiods] of integer;
       astr:         string;
       te:           integer;
       afnt:    tpintpoint;

         procedure nextttableteacher;
         begin
          a:=0;
          while (a=0) do
          begin
           inc(tepoint[p]);
           te:=codepoint[tepoint[p],code];
           astr:=copy(XML_TEACHERS.tecode[te,code-1],1,2); a:=0;
           if tepoint[p]>codeCount[code] then exit;
           if Teachon[te,p]=0 then
           begin
            a:=te;
            if ((code=1) and (XML_TEACHERS.load[te]=0)) then a:=0;
           end;
           if ((te=0) or (astr='00')) then a:=0;
          end; {while}
         end;

      begin
       for i:=1 to nmbrteachers do
        for p:=0 to nmbrperiods do
         Teachon[i,p]:=0;
       for p:=1 to tlimit[d] do
        if XML_DISPLAY.TsOn[d,p-1] then
        begin
         for yyear2:=0 to years_minus_1 do
         begin
          aFnt:=FNT(d,p-1,yyear2,0,2*code);
          for L:=1 to level[yyear2] do
          begin
           inc(aFnt,4);
           te:=aFnt^;
           inc(Teachon[te,P]);
           inc(Teachon[te,0]);
          end; {for L}
         end; {for yyear2}
        end; {if TsOn[d,p-1]}
       for p:=0 to periods do
        tepoint[p]:=0;
       case code of
        1: printw(' Teachers');
        2: printw(' Rooms');
       end; {case}
       line:=1;
       tnum:=1;
       for i:=1 to numcodes[code] do
       begin
        found:=false;
        if line=2 then
        begin
         printw(' Free');
         inc(line);
        end;
        j:=0;
        for p:=1 to tlimit[d] do
         if XML_DISPLAY.TsOn[d,p-1] then
         begin
          for k:=1 to tnum do
          begin
           nextttableteacher;
           if a>0 then
            begin
             printc(FNsub(a,code)); printc(''); printc('');
             found:=true;
            end
           else begin printc('');printc('');printc(''); end;
          end; {for k}
          inc(j);
         end; {if TsOn[d,p-1]}

        newline;
        inc(line);
        if not(found) then break;
       end; {for i}
      end;


    procedure ttableprint1;
    var
     p,a1:                  integer;
     aFnt,bFnt:            tpintpoint;
     code:                integer;
     tmpStr,cstr:                    string;

    begin
     lineprinted:=0;
     if (L=1) then
     begin
      printw(yeartitle+' '+yearname[yyear]);
      newline;
     end;
     printw(ClassCode[ClassShown[l,yyear]]);
     for p:=1 to tlimit[d] do
      if XML_DISPLAY.TsOn[d,p-1] then
      begin
       aFnt:=FNT(d,p-1,yyear,l,0);
       if ttselect(aFnt) then {no selection, or subg teg rog or fac - 2,3,4 or 5}
       begin
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
       end; {if found}
       {inc(j); }
      end; {if TsOn[d,p-1]}
      newline;
      lineprinted:=-1;
    end;


begin
 strtday:=0;
 finday:=days-1;
 if ((XML_DISPLAY.ttprntselyear=-1) or (XML_DISPLAY.ttPrntType=0)) then {all years or main tt}
 begin
  strtyear:=years-1;
  finyear:=0;
 end
 else
  begin
   strtyear:=XML_DISPLAY.ttprntselyear;
   finyear:=XML_DISPLAY.ttprntselyear;
  end;
 for d:=strtday to finday do
 begin
  if not(XML_DISPLAY.Dprint[d+1]) then continue;
  if strtday<>finday then
  begin
   newline;
   astr:=dayname[d];
   printw(astr);
   newline;  newline; newline;
  end;
  ttPrintTSnames;
  for yyear:=strtyear downto finyear do
  begin
   if XML_DISPLAY.pyear[yyear] then
   begin
    for L:=1 to level[yyear] do
    begin
     ttableprint1;
    end; {for L}
   end;

   if yyear=finyear then if XML_DISPLAY.tfreeshow then
   begin
    code:=1;  ttablefree;
   end;
   if yyear=finyear then if XML_DISPLAY.rfreeshow then
   begin
    code:=2;  ttablefree;
   end;

  end; {for yyear}
  newline;
  if XML_DISPLAY.ttPrntType=0 then {main and not year ttable so page break}
  begin
    if d<>finday then
    begin
     L:=0;
     for i:=d+1 to finday do
      if XML_DISPLAY.Dprint[i+1] then
      begin
       L:=1; break;
      end;
    end;
  end;
 end; {for d}
end;



begin
 ClearTeachOn;
 printttable;
 printCustomAddon;
end;


procedure TOutTtableWin.GenericTimetabletext;
var
  D,P,Y,L,sub,te,ro: Integer;
  aFnt: tpIntPoint;
  lTempList: TStringList;
  lFileName: string;
  //lDay: Integer;
  i: Integer;
  //j: Integer;
  lDayUse: Integer;
  tmpstr: string;


  {function GetGroupArray: Integer;
  var
    lDayGroup: Integer;
  begin
    Result := 0;
    DayGroupCalc;
    if lDayGroup >numDayGroups then
      lDayGroup := numDayGroups;
    Result := dg[lDayGroup,1];
  end;}

begin
  lTEmpLIst := TStringList.Create;
  try
    for D:=0 to days-1 do
     for P:=0 to periods-1 do
       for Y:=0 to years_minus_1 do
         for L:=1 to level[Y] do
         begin
           aFnt:=FNT(D,P,Y,L,0);
           sub:=aFnt^; inc(aFnt);
           te:=aFnt^; inc(aFnt);
           ro:=aFnt^;
            if ((sub<=LabelBase) and ((sub>0) or (te>0) or (ro>0))) then
           begin
             if (XML_DISPLAY.pyear[Y] and XML_DISPLAY.dprint[D+1] and XML_DISPLAY.TsOn[d,p]) then
             begin
               if not FIsSpecial then
               begin
                 if not FIncludeRC then
                   PrintLine([IntToStr(D+1), IntToStr(P+1), Trim(Subcode[sub]), Trim(yearname[Y]), Trim(XML_TEACHERS.tecode[te,0]), Trim(XML_TEACHERS.tecode[ro,1])])
                 else
                   lTEmpList.Add(IntToStr(D + 1) + ',' +
                                 IntToStr(P + 1) + ',' +
                                 Trim(Subcode[Sub]) + ',' +
                                 Trim(YearName[Y]) + ',' +
                                 Trim(XML_TEACHERS.TeCode[Te, 0]) + ',' +
                                 Trim(XML_TEACHERS.tecode[Ro, 1]) + ',' +
                                 ClassCode[ClassShown[L, Y]]);
               end;
             end;
           end;
         end;
    if not IsSpecial and IncludeRC then
    begin
      lFileName := Directories.DataDir + '\' + FileNames.CurentTimeTable + 'WithClass.TXT';
      lTempList.SaveToFile(lFileName);
      MessageDlg('Timetable export file has been created as ' + lFileName, mtInformation, [mbOK], 0);
    end
    else if IsSpecial and not IncludeRC then
    begin
      //The two exports have been separated for performance reason.
      lTempList.Add('cycle_day_index' + Chr(9) + 'period_short_name' + Chr(9) + 'class_code' + Chr(9) + 'room_code' + Chr(9) + 'teacher_short_name');
      lDayUse := dg[i,1];
      tmpstr:='';
      for D:=0 to days-1 do
        for P:=0 to periods -1 do
         for Y:= years_minus_1 downto 0 do
           for L:=1 to level[Y] do
           begin
             tmpstr := TimeSlotName[D, p];
             aFnt:=FNT(D,p,Y,L,0);
             sub:=aFnt^; inc(aFnt);
             te:=aFnt^; inc(aFnt);
             ro:=aFnt^;
             if ((sub<=LabelBase) and ((sub>0) or (te>0) or (ro>0))) then
             begin
               if (XML_DISPLAY.pyear[Y] and XML_DISPLAY.dprint[D + 1] and XML_DISPLAY.TsOn[d,p]) then
               begin
                   //lDay := GetGroupArray;
                   lTempList.Add(IntToStr(D + 1) + Chr(9) +
                                 tmpStr + Chr(9) +
                                 Trim(Subcode[sub]) + Chr(9) +
                                 Trim(XML_TEACHERS.tecode[ro,1]) + Chr(9) +
                                 Trim(XML_TEACHERS.tecode[te, 0]));
               end; //if disp settings
             end;
           end; // for
      lFileName := Directories.DataDir + '\' + FileNames.CurentTimeTable + 'Special.TXT';
      lTempList.SaveToFile(lFileName);
      MessageDlg('The new file has been created as ' + lFileName, mtInformation, [mbOK], 0);
    end;
  finally
    FreeAndNil(lTempList);
  end;

end;

procedure MainTimeTableText(const pIncludeRC: Boolean = False; const pIsSpecial: Boolean = False);
begin
 OutTtableWin := TOutTtableWin.Create;
 OutTtableWin.IsSpecial := pIsSpecial;
 OutTtableWin.IncludeRC := pIncludeRC;
 with OutTtableWin do
  try
   if XML_DISPLAY.GenericTtableFlag then
     GenericTimetabletext
   else
   begin
     Header;
     Outttable;
   end;
  finally
    OutTtableWin.Free;
  end;
end;

procedure TTtablewin.Alter1Click(Sender: TObject);
begin
 if CheckAccessRights(utTime,16,true) then
  begin
   AlterDlg:=TAlterDlg.Create(Self); {allocate dlg}
   AlterDlg.ShowModal;
   AlterDlg.Free;
   if not(saveTimeFlag) then CheckAccessRights(utTime,16,false)
  end;
end;

procedure TTtablewin.SearchReplace1Click(Sender: TObject);
begin
 if CheckAccessRights(utTime,16,true) then
  begin
   if not (fSearchReplaceDlgUp) then
    begin
     SearchDlg:=TSearchDlg.Create(Self); {allocate dlg}
     fSearchReplaceDlgUp:=true
    end;
   SearchDlg.show
 end;
end;

procedure TTtablewin.Solve1Click(Sender: TObject);
begin
 if CheckAccessRights(utTime,16,true) then
  begin
   Solvedlg:=TSolvedlg.Create(Self); {allocate dlg}
   Solvedlg.ShowModal;
   Solvedlg.Free;
   if not(saveTimeFlag) then CheckAccessRights(utTime,16,false)
 end;
end;

procedure TTtablewin.ClashHelp1Click(Sender: TObject);
begin
 ClashHelpDlg:=TClashHelpDlg.Create(Self); {allocate dlg}
 ClashHelpDlg.ShowModal;
 ClashHelpDlg.Free
end;

procedure TTtablewin.Timetable1Click(Sender: TObject);
begin
 Years1.caption:='&'+yearTitle+'s ...';
 if XML_DISPLAY.EntrySelectionLink then
   LinkwindowsMitem1.caption:='Unlink windows from Timetable'
 else
   LinkwindowsMitem1.caption:='Link windows to Timetable'
end;

procedure TTtablewin.PopupMenu1Popup(Sender: TObject);
var
  aFnt: tpIntPoint;
  s,t,r,i: integer;
  HasSub: boolean;
begin
 ShowSubjectTimetable1.visible:=false;
 ShowTeacherTimetable1.visible:=false;
 ShowRoomTimetable1.visible:=false;
 ShowClassTimetable1.visible:=false;
 if box=bxCell then
  begin
   aFnt:=FNT(nd,np,ny,nl,0);
   s:=aFnt^; inc(aFnt);
   t:=aFnt^; inc(aFnt);
   r:=aFnt^;
   ShowSubjectTimetable1.visible:=((s>0) and (s<=LabelBase)); {avoid call on labels}
   ShowTeacherTimetable1.visible:= ((t>0) and (s<=LabelBase));
   ShowRoomTimetable1.visible:=((r>0) and (s<=LabelBase))
  end;
 if box = bxLevel then
  ShowClassTimetable1.visible:=(ClassCode[ClassShown[nl,ny]]>'');
 if box=bxYrTime then
  begin
   HasSub:=false;
   for i:=1 to level[ny] do {see if any subs present}
    begin
     aFnt:=FNT(nd,np,ny,i,0);  s:=aFnt^;
     if ((s>0) and (s<=LabelBase)) then
      begin
       HasSub:=true;
       break
      end;
    end; {for i}
   ShowSubjectTimetable1.visible:=HasSub;
  end;
end;

procedure TTtablewin.ShowStudentSubjectClashes(Sender: TObject);
var
  lFrmStudentClashes: TFrmStudentClashes;
begin
  lFrmStudentClashes := TFrmStudentClashes.Create(Application);
  try
    lFrmStudentClashes.ShowModal;
  finally
    FreeAndNil(lFrmStudentClashes);
  end;
end;

procedure TTtablewin.ShowSubjectTimetable1Click(Sender: TObject);
var
 aFnt: tpIntPoint;
 i,j: integer;
begin
 if box=bxCell then
  begin
   XML_DISPLAY.subttlistVals[1]:=ny;
   XML_DISPLAY.subttlistVals[2]:=nl;
   XML_DISPLAY.subttlistVals[3]:=nd;
   XML_DISPLAY.subttlistVals[4]:=np; {period}
   XML_DISPLAY.subttlistSelection := 1;
   aFnt:=FNT(nd,np,ny,nl,0);
   j:=aFnt^;
   if ((j>0) and (j<=LabelBase)) then
    begin
     subttGroupCnt:=1;
     XML_DISPLAY.SubTtGroup[1]:=j;
     subjectTtablewinSelect;
     UpdateWindow(wnSubjectTt)
    end
  end;
 if box=bxYrTime then
  begin
   XML_DISPLAY.subttlistVals[1]:=ny;
   XML_DISPLAY.subttlistVals[2]:=nl;
   XML_DISPLAY.subttlistVals[3]:=nd;
   XML_DISPLAY.subttlistVals[4]:=np; {period}
   XML_DISPLAY.subttlistSelection:=2;
   subttGroupCnt:=0;
   for i:=0 to level[ny] do
    begin
     aFnt:=FNT(nd,np,ny,i,0);
     j:=aFnt^;
     if ((j>0) and (j<=LabelBase)) then
      begin
       inc(subttGroupCnt);
       XML_DISPLAY.SubTtGroup[subttGroupCnt]:=j
      end;
    end; {for i}
   if bool(subttGroupCnt) then {only if some subs were there}
    begin
     subjectTtablewinSelect;
     UpdateWindow(wnSubjectTt);
    end;
  end;
end;

procedure TTtablewin.ShowTeacherTimetable1Click(Sender: TObject);
var
 te: integer;
begin
 if box=bxCell then
  begin
   te:=FNT(nd,np,ny,nl,2)^;
   if te>0 then
    begin
     XML_DISPLAY.TeTtSelection[0]:=1;
     XML_DISPLAY.TeTtSelection[1]:=te; {selection}
     XML_DISPLAY.tettlistVals[3]:=0; {fac}
     XML_DISPLAY.tettseltype:=2; {selection}
     if winView[wnTeacherTt]=0 then {daily}
      begin
       XML_DISPLAY.tettlistVals[4]:=nd;
       XML_DISPLAY.tettlistVals[5]:=nd
      end;
     teachTtablewinSelect;
     UpdateWindow(wnTeacherTt);
    end;
  end;
end;

procedure TTtablewin.ShowTimetableStatistics(Sender: TObject);
var
  lFrmTimetableStatistics: TFrmTimetableStatistics;
begin
  lFrmTimetableStatistics := TFrmTimetableStatistics.Create(Application);
  try
    lFrmTimetableStatistics.ShowModal;
  finally
    FreeAndNil(lFrmTimetableStatistics);
  end;
end;

procedure TTtablewin.ShowRoomTimetable1Click(Sender: TObject);
var
 r: integer;
begin
 if box=bxCell then
  begin
   r:=FNT(nd,np,ny,nl,4)^;
   if r>0 then
    begin
     XML_DISPLAY.RoTtSelection[0]:=1;
     XML_DISPLAY.RoTtSelection[1]:=r; {selection}
     XML_DISPLAY.rottlistVals[3]:=0; {fac}
     XML_DISPLAY.rottseltype:=2; {selection}
     if winView[wnRoomTt]=0 then {daily}
      begin
       XML_DISPLAY.rottlistVals[4]:=nd;
       XML_DISPLAY.rottlistVals[5]:=nd
      end;
     roomTtablewinSelect;
     UpdateWindow(wnRoomTt)
    end;
  end;
end;

procedure TTtablewin.ShowClassTimetable1Click(Sender: TObject);
begin
 if ClassCode[ClassShown[nl,ny]]>'' then
  begin
   XML_DISPLAY.subttlistVals[1]:=ny;
   XML_DISPLAY.subttlistVals[2]:=nl;
   XML_DISPLAY.subttlistVals[3]:=nd;
   XML_DISPLAY.subttlistVals[4]:=np; {period}
   XML_DISPLAY.subttlistSelection:=3;
   subjectTtablewinSelect;
   UpdateWindow(wnSubjectTt)
  end;
end;

procedure TTtablewin.Size1Click(Sender: TObject);
begin
 mainform.Size1Click(Self)
end;

procedure TTtablewin.GetSelection(var x1,x2,y1,y2: smallint);
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

procedure TTtablewin.copyTTtextToClipboard;
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
     ttCalc(i,j);
     aFnt:=FNT(ttcalcD,ttcalcP,ttcalcY,ttcalcL,0);
     m:=aFnt^; tmpStr:='';  tmpstr2:='';
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
     if not(ttcalcL=0) then
      begin {nothing for level 0}
       if not(j=x1) then
        begin
         genText:=genText+ht;
         studText:=studText+ht
        end;
       genText:= genText+tmpStr;
       studText:= studText+tmpStr+tmpstr2
      end;
    end; {for j}
   if not (ttcalcL=0) then {nothing for level 0}
    if (i<>y2) then
     begin
      genText:=genText+endline;
      studText:=studText+endline
     end;
  end; {for i}
 genText:=genText+chr(0);
 studText:=studText+chr(0);
 copyTextToClipboard(cfTtable)
end;

procedure TTtablewin.Copy1Click(Sender: TObject);
begin
 copyTTtextToClipboard;
end;

procedure TTtablewin.CopyDataWithinTimeTable(Sender: TObject);
var
  lFrmCopyTT: TFrmCopyTT;
begin
  lFrmCopyTT := TFrmCopyTT.Create(Application);
  try
    lFrmCopyTT.ShowModal;
  finally
    FreeAndNil(lFrmCopyTT);
  end;
end;

procedure TTtablewin.ClearTTtext(doPush: boolean);
var
 i,j,x1,x2,y1,y2: smallint;
begin
 GetSelection(x1,x2,y1,y2);
 for i:=y1 to y2 do
  for j:=x1 to x2 do
   begin
    ttCalc(i,j);
    if doPush then PushCell(ttcalcD,ttcalcP,ttcalcY,ttcalcL);
    FNT(ttcalcD,ttcalcP,ttcalcY,ttcalcL,0)^:=0; {sub}
    FNT(ttcalcD,ttcalcP,ttcalcY,ttcalcL,2)^:=0; {te}
    FNT(ttcalcD,ttcalcP,ttcalcY,ttcalcL,4)^:=0; {ro}
    FNT(ttcalcD,ttcalcP,ttcalcY,ttcalcL,6)^:=0; {flags}
    Fclash[ttcalcD,ttcalcP]:=1;
   end; {for j}
 SaveTimeFlag := true;
 ttclash;
 UpdateTimetableWins;
end;

procedure TTtablewin.Cut1Click(Sender: TObject);
begin
 if CheckAccessRights(utTime,16,true) then
  begin
   copyTTtextToClipboard;
   PushTtStackStart(utCut);
   ClearTTtext(true);
   RebuildLabels;
  end;
end;

procedure TTtablewin.pasteClipTTtext;
var
 i,j,x1,y1    : smallint;
 su,te,ro,flg : smallint;
begin
 suMissedCnt:=0; teMissedCnt:=0; roMissedCnt:=0;
 with StringGrid1 do
  begin
   x1:=selection.left; if x1<1 then x1:=1;
   y1:=selection.top; if y1<2 then y1:=2;
   i:=y1; j:=x1;
   if Clipboard.HasFormat(CF_AMIG_Block_Data) then
    begin
     getTextFromClipboard(CF_AMIG_Block_Data);
     while genText <> '' do
      begin
       getClipBlkCell(su);
       if (i<=RowCount-1) and (j<=ColCount-1) then
        begin
         ttCalc(i,j);
         if ttcalcL=0 then begin inc(i); ttCalc(i,j); end;
         FNT(ttcalcD,ttcalcP,ttcalcY,ttcalcL,0)^:=su; {sub}
         Fclash[ttcalcD,ttcalcP]:=1;
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
         ttCalc(i,j);
         if ttcalcL=0 then begin inc(i); ttCalc(i,j); end;
         FNT(ttcalcD,ttcalcP,ttcalcY,ttcalcL,0)^:=su; {sub}
         FNT(ttcalcD,ttcalcP,ttcalcY,ttcalcL,2)^:=te; {te}
         FNT(ttcalcD,ttcalcP,ttcalcY,ttcalcL,4)^:=ro; {ro}
         FNT(ttcalcD,ttcalcP,ttcalcY,ttcalcL,6)^:=flg; {flags}
         Fclash[ttcalcD,ttcalcP]:=1;
        end;
       inc(j);
       if GotCr then begin inc(i); j:=x1; end; //next line - step down
      end; {while genText<>''}
    end;
  end; {with stringGrid1}
 CheckPasteMsg;
 SaveTimeFlag:=true;
 ttclash;
 UpdateTimetableWins;
end;

procedure TTtablewin.Paste1Click(Sender: TObject);
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
   pushAllTtStack(utPaste);
   if not (Clipboard.HasFormat(CF_AMIG_Block_Data)) then
     ClearTTtext(false); {don't clear it for copy from blocks}
   pasteClipTTtext;
   RebuildLabels;
 end;
end;

procedure TTtablewin.Edit1Click(Sender: TObject);
begin
 paste1.enabled:=GetClipStatus(wnTtable);
 Undo1.Enabled:=(ttUndoPtr>0);
 Redo1.Enabled:=(ttUndoPtr<ttUndoMax);
 Undo1.Hint:=UndoHint;
 Redo1.Hint:=RedoHint;
end;

procedure TTtablewin.Delete1Click(Sender: TObject);
begin
 if CheckAccessRights(utTime,16,true) then
  begin
   PushTtStackStart(utDelete);
   ClearTTtext(true);
   RebuildLabels;
  end;
end;

procedure TTtablewin.TeachersFree1Click(Sender: TObject);
begin
 if box=bxCell then
  begin
   XML_DISPLAY.teachersfreeshow1:=1;
   XML_DISPLAY.teachersfreeday:=nd;
   XML_DISPLAY.TeFreePeriod:=np+1;
   teachersFreeWinSelect;
   UpdateWindow(wnTeFree)
  end;
end;

procedure TTtablewin.RoomsFree1Click(Sender: TObject);
begin
 if box=bxCell then
  begin
   XML_DISPLAY.roomsfreeshow1:=1;
   XML_DISPLAY.roomsfreeday:=nd;
   XML_DISPLAY.roomsfreePeriod:=np+1;
   roomsFreeWinSelect;
   UpdateWindow(wnRoFree)
  end;
end;

procedure TTtablewin.Blocks1Click(Sender: TObject);
begin
 mainform.Blocks3Click(Self)
end;

procedure TTtablewin.Panel3DockOver(Sender: TObject; Source: TDragDockObject; X,
                                    y: integer; state: TDragState; var Accept:
                                    boolean);
var
 aa: smallint;
begin
 aa:=(Source.control as TForm).tag;
 Accept:=(aa=wnTtTool);
end;

procedure TTtablewin.Panel2DockOver(Sender: TObject; Source: TDragDockObject; X,
                                    y: integer; state: TDragState; var Accept:
                                    boolean);
var
 aa: smallint;
begin
 aa:=(Source.control as TForm).tag;
 Accept:=(aa=wnTtTool);
end;

procedure TTtablewin.Panel2DockDrop(Sender: TObject; Source: TDragDockObject; X,
                                    y: integer);
begin
 Panel2.height:=Panel2.height+(Source.control as TForm).clientheight;
 XML_DISPLAY.fgTTtoolbarDock:=1;
end;

procedure TTtablewin.Panel3DockDrop(Sender: TObject; Source: TDragDockObject; X,
                                    y: integer);
begin
 Panel3.height:=Panel3.height+(Source.control as TForm).clientheight;
 XML_DISPLAY.fgTTtoolbarDock:=2;
end;

procedure TTtablewin.RollClasses1Click(Sender: TObject);
begin
 if CheckAccessRights(utTime,16,true) then
  begin
   ClassesShowDlg:=TClassesShowDlg.Create(Self); {allocate dlg}
   ClassesShowDlg.ShowModal;
   ClassesShowDlg.Free;{release dlg}
   if not(saveTimeFlag) then CheckAccessRights(utTime,16,false)
 end;
end;

procedure TTtablewin.StringGrid1Click(Sender: TObject);
begin
 controlkeyFlg:=false
end;

procedure TTtablewin.LinkwindowsMitem1Click(Sender: TObject);
begin
 XML_DISPLAY.EntrySelectionLink:=not(XML_DISPLAY.EntrySelectionLink);
 if XML_DISPLAY.EntrySelectionLink then
  begin
   XML_DISPLAY.tcCurPeriodOnly:=true;
   XML_DISPLAY.rcCurPeriodOnly:=true
  end;
 if XML_DISPLAY.EntrySelectionLink then checkLinkedWins
end;

procedure TTtablewin.SelectAll1Click(Sender: TObject);
var
 curSelection: TgridRect;
begin
 curSelection.left:=0;
 curSelection.right:=StringGrid1.ColCount;
 curSelection.top:=0;
 curSelection.bottom:=StringGrid1.RowCount;
 StringGrid1.selection:=curSelection;
 nd:=0;  np:=0;  ny:=0;  nl:=1;
 box:=7;
 ShowCurrentCell
end;

procedure TTtablewin.FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
 if Key=VK_CONTROL then Key:=0
 // only doing this to prevent selection change when day, period, level or
 // whole ttable selected.
end;

procedure TTtablewin.InUse1Click(Sender: TObject);
begin
 mainform.InUse2Click(Self);
end;

procedure TTtablewin.FormDeactivate(Sender: TObject);
begin
 Cut1.ShortCut:=ShortCut(0,[]);
 Copy1.ShortCut:=ShortCut(0,[]);
 Paste1.ShortCut:=ShortCut(0,[]);
 Delete1.ShortCut:=ShortCut(0,[]);
 mainform.CopyWin.ShortCut:=ShortCut(0,[]);
end;

procedure TTtablewin.Undo1Click(Sender: TObject);
begin
 ttChangeUndo;
end;

procedure TTtablewin.Redo1Click(Sender: TObject);
begin
 ttChangeRedo;
end;

procedure OpenFillRooms;
begin
 StripRoomsDlg := TStripRoomsDlg.Create(application);
 StripRoomsDlg.ShowModal;
 StripRoomsDlg.Free;
end;

procedure TTtablewin.RoomFill1Click(Sender: TObject);
begin
 if CheckAccessRights(utTime,16,true) then
  begin
   fillRoom_action:=1; {fill rooms}
   OpenFillRooms;
   if not(saveTimeFlag) then CheckAccessRights(utTime,16,false)
 end;
end;

procedure TTtablewin.RoomStrip1Click(Sender: TObject);
begin
 if CheckAccessRights(utTime,16,true) then
  begin
   fillRoom_action:=2; {strip rooms}
   OpenFillRooms;
   if not(saveTimeFlag) then CheckAccessRights(utTime,16,false)
 end;
end;

initialization
 scalingGridCellsFlag:=false;
 controlkeyFlg:=false

end.
