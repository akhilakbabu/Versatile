unit Block1;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, Grids, StdCtrls, Menus,TimeChartGlobals,ClassDefs, XML.UTILS,
  GlobalToTcAndTcextra, XML.DISPLAY, XML.STUDENTS;

type
  TBlockwin = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    StringGrid1: TStringGrid;
    Image1: TImage;
    MainMenu1: TMainMenu;
    Blocks1: TMenuItem;
    SetBlocks1: TMenuItem;
    ClearBlocks1: TMenuItem;
    N1: TMenuItem;
    Load1: TMenuItem;
    Save1: TMenuItem;
    Copy1: TMenuItem;
    Create1: TMenuItem;
    N2: TMenuItem;
    MoveSubjects1: TMenuItem;
    Move1: TMenuItem;
    Swap1: TMenuItem;
    ReOrderChoices1: TMenuItem;
    Sort1: TMenuItem;
    SplitSubject1: TMenuItem;
    AutoAllocation1: TMenuItem;
    ExcludeSubjects1: TMenuItem;
    FixSubjects1: TMenuItem;
    LinkSubjects1: TMenuItem;
    ClashHelp1: TMenuItem;
    ExchangeBlocks1: TMenuItem;
    Label3: TLabel;
    Segregate1: TMenuItem;
    PopupMenu1: TPopupMenu;
    MoveSubject1: TMenuItem;
    SplitSubject2: TMenuItem;
    AutoAllocation2: TMenuItem;
    ExcludeSubjects2: TMenuItem;
    FixSubjects2: TMenuItem;
    ClashHelp2: TMenuItem;
    Clear1: TMenuItem;
    Load2: TMenuItem;
    Save2: TMenuItem;
    N3: TMenuItem;
    Print1: TMenuItem;
    PrinterSetup1: TMenuItem;
    Exportastextfile1: TMenuItem;
    CopytexttoClipboard1: TMenuItem;
    Edit1: TMenuItem;
    Cut1: TMenuItem;
    Copy2: TMenuItem;
    Paste1: TMenuItem;
    Delete1: TMenuItem;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    N4: TMenuItem;
    SelectAll1: TMenuItem;
    ClassSizes1: TMenuItem;
    PasteSubject1: TMenuItem;
    mniBlockShowTeachers: TMenuItem;
    N5: TMenuItem;
    popSearch: TMenuItem;
    mniBlockFind: TMenuItem;
    minBlockCopyToWorksheet: TMenuItem;
    mniBlocksN1: TMenuItem;
    popBlocksExchangeBlocks: TMenuItem;
    popBlocksInfo: TMenuItem;
    popBlocksInfoStudentClashes: TMenuItem;
    popBlocksInfoStudentsFree: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; Col, Row: Longint;
      Rect: TRect; State: TGridDrawState);
    procedure Load1Click(Sender: TObject);
    procedure StringGrid1TopLeftChanged(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure SetBlocks1Click(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure ClearBlocks1Click(Sender: TObject);
    procedure Blocks1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure CopyToWorksheet(Sender: TObject);
    procedure Move1Click(Sender: TObject);
    procedure Swap1Click(Sender: TObject);
    procedure ReOrderChoices1Click(Sender: TObject);
    procedure Sort1Click(Sender: TObject);
    procedure SplitSubject1Click(Sender: TObject);
    procedure AutoAllocation1Click(Sender: TObject);
    procedure LinkSubjects1Click(Sender: TObject);
    procedure ExcludeSubjects1Click(Sender: TObject);
    procedure FixSubjects1Click(Sender: TObject);
    procedure DisplayExchangeBlocks(Sender: TObject);
    procedure Segregate1Click(Sender: TObject);
    procedure ClashHelp1Click(Sender: TObject);
    procedure Create1Click(Sender: TObject);
    procedure Panel1DblClick(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure Image1DblClick(Sender: TObject);
    procedure Label3DblClick(Sender: TObject);
    procedure Exportastextfile1Click(Sender: TObject);
    procedure CopytexttoClipboard1Click(Sender: TObject);
    procedure StringGrid1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Copy2Click(Sender: TObject);
    procedure Cut1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure Panel4DockOver(Sender: TObject; Source: TDragDockObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
    procedure Panel7DockOver(Sender: TObject; Source: TDragDockObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
    procedure Panel4DockDrop(Sender: TObject; Source: TDragDockObject; X,
      Y: Integer);
    procedure Panel7DockDrop(Sender: TObject; Source: TDragDockObject; X,
      Y: Integer);
    procedure StringGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure StringGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SelectAll1Click(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure ClassSizes1Click(Sender: TObject);
    procedure PasteSelectedSubjectFromGroupSubject(Sender: TObject);
    procedure ShowTeachers(Sender: TObject);
    procedure Search(Sender: TObject);
    procedure CopyToFromTimetable(Sender: TObject);
    procedure StringGrid1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure DisplayStudentClashes(Sender: TObject);
    procedure DisplayStudentsFree(Sender: TObject);
  private
    FIsBlockLoaded: Boolean;
    FBlockYear: Smallint;
    FActiveSubNo: Integer;
    procedure InitBlockWin;
    procedure ManualFixSub;
    procedure SetTopLabel;
    procedure LoadBlockfile;
  public
    TabsDo: boolean;
    procedure LoadBlock;
    procedure updateClashStatusBar;
    property IsBlockLoaded: Boolean read FIsBlockLoaded write FIsBlockLoaded;
    property ActiveSubNo: Integer read FActiveSubNo write FActiveSubNo;
    procedure MoveFocusUp1;
  end;

  procedure settop;
  procedure checkfix;
  function findblock(subnum:integer;var sublevel: integer): integer;
  procedure blockchange(subnum,toblock:integer);

  procedure checklink;
  procedure SaveBlock;
  procedure blockswinprint;
  procedure blockswintext;
  procedure loadBlock2;  //no msgs

var
  Blockwin: TBlockwin;
  doubleclick: bool;


implementation

uses
  tcommon,stcommon,main,setblock,copyblck,movesub,swapsub,splitsub, autoaloc,
  linksub,exsub,fixsub,swapblck,segregat,stclash,printers,create, tcommon2,
  clipbrd, blcktool,tcommon5,SubClassSize, BlockTeachers, SUBBYSUB, Subbsdlg,
  uAMGClassSubject, SearchBlocks, CopyblockToTT, ComCtrls, uAMGConst;

{$R *.DFM}

type TPrintBlockWin=class(TPrintDrawWin)
  public
   procedure head; override;
   procedure SetTabs; override;
 end;

 type TOutBlockWin=class(TOutputwin)
  public
   procedure head; override;
 end;

var
 PrintBlockWin: TPrintBlockWin;
 OutBlockWin: TOutBlockWin;

procedure checklink;
var
 i:  integer;
begin
 linknum:=0;
 for i:=1 to codeCount[0] do
  if link[codepoint[i,0]]<>0 then inc(linknum);
end;

procedure checkfix;
var
 i:  integer;
begin
 FixCount:=0;
 for i:=1 to XML_DISPLAY.blocknum do
   inc(fixcount,fix[i]);
end;

function findblock(subnum:integer;var sublevel: integer): integer;
 var
  i,j:  integer;
begin
findblock:=0;
for i:=1 to XML_DISPLAY.blocknum do
 if Sheet[i,0]>0 then
  for j:=1 to Sheet[i,0] do
   if Sheet[i,j]=Subnum then
   begin
    findblock:=i;
    sublevel:=j;
    break;
   end;
end;

procedure blockchange(subnum,toblock:integer);
var
 fromblock,yearpos,sublevel: integer;
 a,j,locate:                 integer;
begin
fromblock:=findblock(subnum,sublevel);
yearpos:=GsubXref[subnum];
if yearpos=0 then
begin
 addSubToGroupSubs(subnum);
 XrefGroupSubs;
 yearpos:=GsubXref[subnum];
end;
if fromblock=0 then
    Blocktop[yearpos]:=0
  else
   begin
    Sheet[fromblock,sublevel]:=0;
    a:=Sheet[fromblock,0];
    if a>0 then dec(a); Sheet[fromblock,0]:=a;
    if fix[fromblock]>=sublevel then dec(fix[fromblock]);
    checkfix;
    if sublevel<XML_DISPLAY.blocklevel then
     begin
      for j:=sublevel to XML_DISPLAY.blocklevel-1 do
        Sheet[fromblock,j]:=Sheet[fromblock,j+1];
      Sheet[fromblock,XML_DISPLAY.blocklevel]:=0;
     end
      else Sheet[fromblock,XML_DISPLAY.blocklevel]:=0;
   end;
if toblock=0 then
    Blocktop[yearpos]:=Subnum
   else
    begin
     locate:=0;
     for j:=1 to levelprint do
     if Sheet[toblock,j]=0 then
       begin
         Sheet[toblock,j]:=Subnum;
         locate:=j;
         Sheet[toblock,0]:=Sheet[toblock,0]+1;
         break;
       end;
     if locate>XML_DISPLAY.blocklevel then XML_DISPLAY.blocklevel:=locate;
    end;
end;

procedure loadBlock2;  //no msgs
var
 f:       file;
 i,j:      integer;
 count:   integer;
 A,B,blockyear:     smallint;
 strA:    string;
begin
 {init link & excludes to zero}
 linknum:=0; excludenum:=0;
 CheckCurrentYear;
 for j:=1 to nmbrsubjects do
  begin
   link[j]:=0; exclude[j]:=0;
  end;
 try
  try
   doAssignFile(f,blockfile+'.blk');
   filemode:=fmOpenRead+fmShareDenyNone;
   reset(f,1);
   FileAge(blockfile+'.blk',NEW_DateChecks[40]);
   blockread(f,blockyear,2);
   blockread(f,XML_DISPLAY.blocknum,2);
   IntRange(XML_DISPLAY.blocknum,0,nmbrBlocks);

   blockread(f,XML_DISPLAY.blocklevel,2);
   FixCount:=0;
   for i:=1 to GroupSubs[0] do
     blocktop[i]:=GroupSubs[i];
   wipeBlocks;
   for i:=1 to XML_DISPLAY.blocknum do
    begin
     blockread(f,Sheet[i,0],2);
     blockread(f,Fix[i],2);  A:=Sheet[i,0];
     inc(FixCount,Fix[i]);
     if A>0 then
      begin
       count:=0;
       for j:=1 to A do
        begin
         blockread(f,B,2);
         strA:=copy(SubCode[B],1,2);
         if ((strA<>'00') and (b>0) and (b<=NumCodes[0])) then
         begin
          inc(count);  inc(subsinblock);
          Sheet[i,count]:=B;
          blocktop[GsubXref[b]]:=0;
         end;
        end;  {for j}
       Sheet[i,0]:=count;
      end; {if A>0}
    end; {for i}

    {now read added link & exclude data}
    try
     blockread(f,linknum,2);
       IntRange(linknum,0,nmbrSubjects);
     if linknum>0 then
      for j:=1 to (linknum div 2) do
      begin
       blockread(f,A,2); blockread(f,B,2);
        IntRange(A,0,nmbrSubjects);
        IntRange(B,0,nmbrSubjects);
       if ((A<>0) and (B<>0)
           and (trim(subcode[A])>'') and (trim(subcode[B])>'')) then
       begin
        link[A]:=B; link[B]:=A;
       end;
      end;

     blockread(f,excludenum,2);
       IntRange(excludenum,0,nmbrSubjects);
     if excludenum>0 then
      for j:=1 to excludenum do
       blockread(f,exclude[j],2);
    except

    end;

  finally
   closefile(f);
  end;
 except

 end;
 blockday:='';
 if subsinblock>0 then blockload:=1;
 if XML_DISPLAY.blocklevel>levelprint then
    XML_DISPLAY.blocklevel:=levelprint;
 Lblock:=1; Hblock:=XML_DISPLAY.blocknum;
end;

procedure TBlockwin.LoadBlock;
var
  f:       file;
  i,j:      smallint;
  msg:     string;
  count:   integer;
  A,B:     smallint;
  strA:    string;
  AmtTrans: Integer;
 begin
 {init link & excludes to zero}
 linknum:=0; excludenum:=0;
 for j:=1 to nmbrsubjects do
 begin
  link[j]:=0; exclude[j]:=0;
 end;
 try
  try
   doAssignFile(f,blockfile+'.blk');
   filemode:=fmOpenRead+fmShareDenyNone;
   reset(f,1);
   blockread(f, FBlockYear,2);
   checkCurrentYear;
   if ((FBlockYear<>-1) and (currentyear<>-1) and (FBlockYear<>currentyear)) then
    begin
     msg:=yeartitle+' '+yearname[FBlockYear]+' file.'+endline;
     msg:=msg+'Load Anyway ?';
     if messagedlg(msg, mtConfirmation, [mbyes,mbno,mbcancel], 0)<>mrYes then exit;
    end;


   blockread(f,XML_DISPLAY.blocknum,2);
   IntRange(XML_DISPLAY.blocknum,2,nmbrBlocks);

   blockread(f,XML_DISPLAY.blocklevel,2);
   FixCount:=0;
   for i:=1 to GroupSubs[0] do
     Blocktop[i]:=GroupSubs[i];
   wipeBlocks;
   for i:=1 to XML_DISPLAY.blocknum do
    begin
     blockread(f,Sheet[i,0],2);
     blockread(f,Fix[i],2);  A:=Sheet[i,0];
     inc(FixCount,Fix[i]);
     if A>0 then
      begin
       count:=0;
       for j:=1 to A do
        begin
         blockread(f,B,2);
         strA:=copy(SubCode[B],1,2);
         if ((strA<>'00') and (b>0) and (b<=NumCodes[0])) then
         begin
          inc(count);  inc(subsinblock);
          Sheet[i,count]:=B;
          Blocktop[GsubXref[b]]:=0;
         end;
        end;  {for j}
       Sheet[i,0]:=count;
      end; {if A>0}
    end; {for i}

    {now read added link & exclude data}
    try
     blockread(f, linknum, 2, AmtTrans);
       IntRange(linknum,0,nmbrSubjects);
     if linknum>0 then
      for j:=1 to (linknum div 2) do
      begin
       blockread(f,A,2); blockread(f,B,2);
        IntRange(A,0,nmbrSubjects);
        IntRange(B,0,nmbrSubjects);
       if ((A<>0) and (B<>0)
           and (trim(SubCode[A])>'') and (trim(SubCode[B])>'')) then
       begin
        link[A]:=B; link[B]:=A;
       end;
      end;

     blockread(f, excludenum, 2, AMTTrans);
       IntRange(excludenum,0,nmbrSubjects);
     if excludenum>0 then
      for j:=1 to excludenum do
       blockread(f, exclude[j], 2);
     blockread(f,XML_DISPLAY.MaxClassSize,2, AmtTrans);
     IntRange(XML_DISPLAY.MaxClassSize,1,nmbrStudents);
     for i:=1 to nmbrSubjects do SubStMax[i]:=XML_DISPLAY.MaxClassSize;
     blockread(f,a,2, AmtTrans); SubStMaxPoint[0]:=a;
     if a>0 then
       for i:=1 to a do
       begin
         blockread(f, j, 2, AmtTrans);
         blockread(f, SubStMax[j], 2, AmtTrans);
       end;
    except

    end;
    Blockwin.IsBlockLoaded := True;
  finally
   closefile(f);
  end;
 except

 end;
 dbgi:=ioresult;   // clear flag if set for error
 blockday:='';
 SetClassSizePoint;
 if subsinblock>0 then blockload:=1;
 if XML_DISPLAY.blocklevel>levelprint then
    XML_DISPLAY.blocklevel:=levelprint;
 Lblock:=1;
 Hblock:=XML_DISPLAY.blocknum;
end;

procedure TBlockwin.loadBlockfile;
var
 strA:    string;
begin
 countSubsInBlock;
 if SaveBlocksCancel then exit;

 mainForm.opendialog.defaultext:='BLK';
 mainForm.opendialog.filename:='';
 mainform.OpenDialog.HelpContext:=59;
 mainForm.opendialog.filter:='Block Files|*.BLK';
 mainForm.opendialog.initialdir:=Directories.blockdir;
 mainForm.opendialog.title:='Load Block File';
 mainForm.opendialog.options:=[ofFileMustExist,ofHideReadOnly,ofPathMustExist];
 if mainForm.opendialog.Execute then
  begin
   strA:= mainForm.opendialog.FileName;
   blockfile:=ExtractFilename(strA);
   Directories.blockdir:=GetDirName(strA);
   blockfile:=RemoveExtension(blockfile);
   loadblock;
  end;
end;


procedure TBlockwin.UpdateClashStatusBar;
var
 i,localx,basex:      integer;
 localx1, localx2: integer;
 aRect:                 trect;
 tmpcanvasbitmap:       Tbitmap;
// j,a,k,i2, num, per:            integer;
 fitI,fitI1,fitI2:               integer;
 studclash:                        integer;
 tmpflag,tmpblock:  array[0..nmbrblocks] of integer;

 procedure CalcFooter;
 var
   num,i,a,j,per,i2,k:integer;
 begin
    {-------------calc clashes----------------}
   fitI1:=1;//fitstart+((fitI-1)*fitcnt);
   fitI2:=XML_DISPLAY.blocknum;//fitI1+fitcnt-1;
   for i:=fitI1 to fitI2 do
   begin
    tmpflag[i]:=0;
    tmpblock[i]:=0;
   end; {for i}
   for per:=fitI1 to fitI2 do
   begin
    num:=Sheet[per,0];
    for i2:=1 to groupnum do
    begin
     i:=StGroup[i2];
     studclash:=0;
     for j:=1 to chmax do
     begin
      a:=XML_STUDENTS.Stud[i].choices[j];
      if a=0 then continue;
      for k:=1 to num do
      begin
       if a=Sheet[per,k] then inc(studclash);
      end; {for k}
     end; {for j}
     if bool(studclash) then
     begin
      inc(tmpblock[per]);
      if studclash>1 then inc(tmpflag[per]);
     end;
    end; {for i2}
   end; {for per}
  end;

begin
 if not(wnFlag[wnBlock]) then exit;
 {bitmap insertion in canvas below is needed for repaint on resize event}
 {dispite align bottom on image, image not increasing width with form - if you want something done}
 image1.width:=width;
 {ensure canvas on image resizes so shove an image into it}
 tmpcanvasbitmap:=Tbitmap.create;
 tmpcanvasbitmap.width:=image1.width;
 tmpcanvasbitmap.height:=image1.height;
 image1.picture.graphic:=tmpcanvasbitmap;
 tmpcanvasbitmap.free;
 {after canvas finally resized, its forgotten what the font is -restore it}
 RenewFont(image1.canvas);
 aRect.top:=0; aRect.bottom:=image1.height;
 aRect.left:=0; aRect.right:=image1.width;
 image1.canvas.brush.color:=clSilver;
 image1.canvas.fillrect(aRect);
 CalculateBlockClashes;
 CalcFooter;
 basex:=0;
 inc(basex,stringgrid1.gridLineWidth*2);
 image1.canvas.font.color:=FontColorPair[cpNormal,1];
 image1.canvas.textout(0,0,'Clash Total='+inttostr(BlockClashes[0]));
 image1.canvas.textout(0,txtHeight+10,'In');
 image1.canvas.textout(0,(2*txtHeight)+20,'Free');
 i:=0;
 while ((i<XML_DISPLAY.blocknum) and ((stringgrid1.leftcol+i)<nmbrblocks)) do
  begin
   localx:=(basex+(stringgrid1.colwidths[stringgrid1.leftcol+i] div 2)
           -(image1.canvas.textwidth(inttostr(BlockClashes[i+1])) div 2));;
   localx1:=(basex+(stringgrid1.colwidths[stringgrid1.leftcol+i] div 2)
           -(image1.canvas.textwidth(inttostr(tmpBlock[i+1])) div 2));;
   localx2:=(basex+(stringgrid1.colwidths[stringgrid1.leftcol+i] div 2)
           -(image1.canvas.textwidth(inttostr(groupnum-tmpBlock[i+1])) div 2));;
   image1.canvas.font.color:=FontColorPair[cpNormal,1];
   inc(basex,stringgrid1.colwidths[stringgrid1.leftcol+i]);
   inc(i);
   try
    image1.canvas.textout(localx,txtheight,inttostr(BlockClashes[stringgrid1.leftcol+i]));
    image1.canvas.textout(localx1,(2*txtheight)+10,inttostr(tmpBlock[stringgrid1.leftcol+i]));
    image1.canvas.textout(localx2,(3*txtheight)+20,inttostr(groupnum-tmpBlock[stringgrid1.leftcol+i]));
   except
   end;
   inc(basex,stringgrid1.gridLineWidth);
  end;  {while}
end;



procedure TBlockwin.FormClose(Sender: TObject; var Action: TCloseAction);
var
 tmprect: trect;
begin
 XML_DISPLAY.fgReshowBlockToolbar:=fgBlockToolbar;
 if fgBlockToolbar then
  begin
   if (panel4.dockclientcount=1) or (panel7.dockclientcount=1) then
    begin
     tmprect.left:=XML_DISPLAY.winpos[wnBlTool].left;
     tmprect.top:=XML_DISPLAY.winpos[wnBlTool].top;
     tmprect.bottom:=tmprect.top+XML_DISPLAY.winpos[wnBlTool].height;
     tmprect.right:=tmprect.left+XML_DISPLAY.winpos[wnBlTool].width;
     blocktoolbarwin.ManualFloat(tmprect);
    end;
   inc(XML_DISPLAY.winOrderNum);
   XML_DISPLAY.winOrder[XML_DISPLAY.winOrderNum]:=wnBlTool;
   blocktoolbarwin.close;
  end;

 Action:=caFree;
 saveWinpos(self);
 wnFlag[wnBlock]:=false;
 if fMoveSubDlgUp then
  begin
   MoveSubDlg.free;
   fMoveSubDlgUp:=false;
  end;
end;

procedure TBlockwin.FormActivate(Sender: TObject);
begin
 cut1.ShortCut:=ShortCut(Word('X'),[ssCtrl]);
 copy2.ShortCut:=ShortCut(Word('C'),[ssCtrl]);
 paste1.ShortCut:=ShortCut(Word('V'),[ssCtrl]);
 delete1.shortcut:=shortcut(46,[]);
 mainform.CopyWin.ShortCut:=ShortCut(word('C'),[ssCtrl]);
 if needClashMatrixRecalc then CalculateClashmatrix;
 FIsBlockLoaded := Sheet[1,0] > 0;  // When the block window is opened with blocks loaded
                                      
end;

procedure TBlockwin.StringGrid1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  CopytexttoClipboard1Click(nil);
end;

procedure TBlockwin.StringGrid1DrawCell(Sender: TObject; Col, Row: Longint;
  Rect: TRect; State: TGridDrawState);
var
 k:                integer;
 tmpStr:           string;
 localx,localy:    integer;
 blankwidth:       integer;
 topgap:           integer;
 oldbrushColor:    Tcolor;
 aRect:            Trect; {for aligning highlights}

   procedure Setbrush;
   var
    myCol: Tcolor;
   begin
    if gdSelected in State then myCol:=FontColorHiLitePair[cpBlocks,1]
     else myCol:=FontColorHiLitePair[cpBlocks,2];
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


begin
 if (row>XML_DISPLAY.blocklevel) then exit; {bottom max}
 if (col>(XML_DISPLAY.blocknum-1)) then exit; {right max}
 blankwidth:=stringgrid1.canvas.textwidth(' ');
 topgap:=blankwidth div 2;
 oldBrushColor:=stringgrid1.canvas.brush.color;

 if (Row>0) then
  begin
   SetBrush;
   StringGrid1.Canvas.FillRect(Rect);
  end;

 if row=0 then
  begin     {fixed top}
   fcolor(cpInfoHead);
   tmpStr:='Block: '+inttostr(col+1);
   localx:=((rect.right+rect.left) div 2)-(stringgrid1.canvas.textwidth(tmpStr) div 2);
   stringgrid1.canvas.TextOut(localx,rect.top+topgap,tmpStr);
  end
 else  {main grid data}
  begin
   if (row<=Sheet[col+1,0]) then
   begin
    k:=Sheet[col+1,row];
    tmpStr:=SubCode[k];
    localx:=rect.left+blankwidth;
    localy:=rect.top+topgap;
    if row<=fix[col+1] then fColor(cpDoubleBlock)
     else TopColor(cpSub);
    aRect.left:=localx; aRect.top:=localy;
    aRect.right:=rect.right-blankwidth;
    aRect.bottom:=localy+Txtheight;
    stringgrid1.canvas.fillrect(aRect);
    stringgrid1.canvas.TextOut(localx,localy,tmpStr);

    tmpStr:=inttoStr(GroupSubCount[GsubXref[k]]);
    localx:=rect.right-blankwidth-stringgrid1.canvas.textwidth(tmpStr);
    stringgrid1.canvas.TextOut(localx,localy,tmpStr);
   end;  {if (row<=Sheet[col+1,0]) }
  end;
 stringgrid1.canvas.brush.color:=oldBrushColor;

 if wnFlag[wnBlock] then //only if blockwin there
  if ((row=stringgrid1.toprow) and (col=stringgrid1.leftcol)) then  {only once per paint}
   updateClashStatusBar;
end;

procedure TBlockwin.Load1Click(Sender: TObject);
begin
 loadBlockfile;
 updateBlockWindow;
 saveBlockFlag:=false;
 if ((grouptype=9) or (grouptype=10)) then {block clashes & free in block}
  begin
   REselectgroup;
   UpdateWindow(wnStudentList);
   updateStatusPanel;
  end;
end;

procedure TBlockwin.StringGrid1TopLeftChanged(Sender: TObject);
begin
 if wnFlag[wnBlock] then UpdateClashStatusBar;
end;

procedure TBlockwin.FormResize(Sender: TObject);
begin
 if wnFlag[wnBlock] then UpdateClashStatusBar;
end;

procedure TBlockwin.SetBlocks1Click(Sender: TObject);
begin
 if CheckAccessRights(utBlock,40,true) then
  begin
   setblocksdlg:=Tsetblocksdlg.create(self);  {allocate dlg}
   setblocksdlg.showmodal;
   setblocksdlg.free;   {release dlg}
   if not(saveBlockFlag) then CheckAccessRights(utBlock,40,false)
  end;
end;

procedure settop;
var
 i,j,sub,num: integer;
begin
 for i:=1 to GroupSubs[0] do Blocktop[i]:=GroupSubs[i];
 XrefGroupSubs;
 for i:=1 to XML_DISPLAY.blocknum do
  begin
   num:=Sheet[i,0];
   if num>0 then
    for j:=1 to num do
     begin
      sub:=Sheet[i,j];
      if (sub>0) and (sub<=numCodes[0]) then
        Blocktop[GsubXref[sub]]:=0;
     end;
  end;
end;


procedure checkblocks;
var
 b1,l1,a6,a7: integer;
begin
 if XML_DISPLAY.blocklevel>levelprint then
      XML_DISPLAY.blocklevel:=levelprint;
 for b1:=1 to XML_DISPLAY.blocknum do
  begin
   a6:=0;
   for l1:=1 to XML_DISPLAY.blocklevel do
    begin
     a7:=Sheet[b1,l1];
     if (a7>0) and (a7<=NumCodes[0]) then
      begin
       inc(a6); Sheet[b1,a6]:=a7;
      end;
    end; {l1}
   Sheet[b1,0]:=a6;
   if fix[b1]>a6 then fix[b1]:=a6;
   if a6<XML_DISPLAY.blocklevel then
     for l1:=a6+1 to XML_DISPLAY.blocklevel do Sheet[b1,l1]:=0;
  end; {b1}
 checkfix;
end;

procedure TBlockwin.InitBlockWin;
var
 i,j:              integer;
 blankwidth:       integer;
 colwidthmax:      integer;
 rowheightmax:     integer;
 tmpcanvasbitmap:  Tbitmap;
begin
 font.assign(XML_DISPLAY.tcfont);
 stringgrid1.canvas.font.assign(XML_DISPLAY.tcfont);
 blankwidth:=stringgrid1.canvas.textwidth(' ');
 stringgrid1.Colcount:=XML_DISPLAY.blocknum;
 colwidthmax:=stringgrid1.canvas.textwidth('Block '+inttostr(stringgrid1.Colcount));
 j:=fwCode[0]+blankwidth+stringgrid1.canvas.textwidth(inttostr(XML_STUDENTS.numstud));
 if (j>colwidthmax) then colwidthmax:=j;
 for i:=0 to (stringgrid1.colcount-1) do stringgrid1.colwidths[i]:=colwidthmax;
 stringgrid1.RowCount:=XML_DISPLAY.blocklevel+1;
 rowheightmax:=Txtheight+blankwidth;
 for i:=0 to (XML_DISPLAY.blocklevel) do StringGrid1.rowheights[i]:=rowheightmax;
 panel1.height:=rowheightmax;
 panel2.height:=rowheightmax*5-blankwidth;
 image1.width:=width;
 {ensure canvas on image resizes so shove an image into it}
 tmpcanvasbitmap:=Tbitmap.create;
 tmpcanvasbitmap.width:=image1.width;
 tmpcanvasbitmap.height:=panel2.height;
 image1.picture.graphic:=tmpcanvasbitmap;
 tmpcanvasbitmap.free;
 {after canvas finally resized, its forgotten what the font is -restore it}
 RenewFont(image1.canvas);
 SetTopLabel;
 label3.top:=0;
 label3.left:=blankwidth div 2;
 checkblocks;
end;

procedure TBlockwin.SetTopLabel;
begin
  Label3.Caption := 'Subjects: ' + IntToStr(GroupSubs[0])
                  + '   Blocks: ' + IntToStr(XML_DISPLAY.blocknum)
                  + '   Levels: '+ IntToStr(XML_DISPLAY.blockLevel)
                  + '   Fixed: ' + IntToStr(fixcount)
                  + '   Students: '+ IntToStr(GroupNum);
end;


procedure TBlockwin.ShowTeachers(Sender: TObject);
var
  lBlockTeachers: TFrmBlockTeachers;
begin
  lBlockTeachers := TFrmBlockTeachers.Create(Application);
  try
    lBlockTeachers.Blocks := XML_DISPLAY.BlockNum;
    lBlockTeachers.Levels := StringGrid1.RowCount;
    lBlockTeachers.ShowModal;
  finally
    FreeAndNil(lBlockTeachers);
  end;
end;

procedure TBlockwin.FormCreate(Sender: TObject);
begin
 setWindowDefaults(self,wnBlock);
 doubleclick:=false;
 if XML_DISPLAY.fgReshowBlockToolbar then BlockToolbarSelect;
 if fgBlockToolbar then
  case XML_DISPLAY.fgBlockToolbarDock of
   1: try  {restore docked toolbar}
       blocktoolbarwin.ManualDock(panel4);
      except
      end;
   2: try
       blocktoolbarwin.ManualDock(panel7);
      except
      end;
  end; {case}
end;

procedure TBlockwin.FormPaint(Sender: TObject);
begin
 if needClashMatrixRecalc then CalculateClashmatrix;
 if tabsDo then InitBlockWin;
 tabsDo:=false;
end;



procedure TBlockwin.ClearBlocks1Click(Sender: TObject);
var
  i,j,A:      integer;
begin
 countsubsinblock;
 BlockLoad:=0;
 if subsinblock=0 then exit;
 for i:=1 to nmbrBlocks do
   for j:=1 to XML_DISPLAY.blocklevel do
     if j>fix[i] then
       begin
        Sheet[i,0]:=fix[i];
        A:=GsubXref[Sheet[i,j]];
        Blocktop[A]:=GroupSubs[A];
        Sheet[i,j]:=0;
       end;
 UpdateBlockWindow;
 FIsBlockLoaded := False;
end;

procedure TBlockwin.Blocks1Click(Sender: TObject);
var
 HasSubs: boolean;
begin
 countSubsInBlock;
 HasSubs:=(subsinblock>0);  {pop up on right}
 ClearBlocks1.Enabled:=HasSubs;  Clear1.Enabled:=HasSubs;
 Save1.Enabled:=HasSubs;         Save2.Enabled:=HasSubs;
 ReOrderChoices1.Enabled:=HasSubs;
 Sort1.Enabled:=HasSubs;
 ClashHelp1.Enabled:=HasSubs;    ClashHelp2.Enabled:=HasSubs;
 ExchangeBlocks1.Enabled := HasSubs;
 popBlocksExchangeBlocks.Enabled := HasSubs;
 Copy1.Enabled:=HasSubs;
 minBlockCopyToWorksheet.Enabled := Copy1.Enabled;
 popSearch.Enabled := Copy1.Enabled;
 mniBlockFind.Enabled := Copy1.Enabled;

 HasSubs:=(GroupSubs[0]>0);
 Create1.Enabled:=HasSubs;
 Swap1.Enabled:=HasSubs;
 ExcludeSubjects1.Enabled:=HasSubs;    ExcludeSubjects2.Enabled:=HasSubs;
 FixSubjects1.Enabled:=HasSubs;        FixSubjects2.Enabled:=HasSubs;
 LinkSubjects1.Enabled:=HasSubs;
 SplitSubject1.Enabled:=HasSubs;       SplitSubject2.Enabled:=HasSubs;
 AutoAllocation1.Enabled:=HasSubs;     AutoAllocation2.Enabled:=HasSubs;
 Segregate1.Enabled:=HasSubs;
 mniBlockShowTeachers.Visible := FIsBlockLoaded;
end;

procedure SaveBlock;
var
 f:       file;
 i,j,a:      smallint;
 fname:     string;
 order:      array[0..nmbrsubjects] of bool;
begin
 if (usrPassLevel=utGen) or (usrPassLevel=utStud) then exit;
 try
  try
   CheckCurrentYear;
   chdir(Directories.blockdir);
   fname:=blockfile+'.blk';
   doAssignFile(f,fname);
   rewrite(f,1);
   blockwrite(f,currentyear,2);
   blockwrite(f,XML_DISPLAY.blocknum,2);
   blockwrite(f,XML_DISPLAY.blocklevel,2);
   for i:=1 to XML_DISPLAY.blocknum do
    begin
     blockwrite(f,Sheet[i,0],2);
     blockwrite(f,Fix[i],2);  A:=Sheet[i,0];
     if A>0 then
        for j:=1 to A do blockwrite(f,Sheet[i,j],2);
    end;

   for i:=1 to nmbrsubjects do order[i]:=true;
      {now write added link & exclude data}
   blockwrite(f,linknum,2);
   if linknum>0 then
    for i:=1 to codeCount[0] do
     begin
      j:=codepoint[i,0];
      if (link[j]<>0) and order[j] then
       begin
        blockwrite(f,j,2);
        blockwrite(f,link[j],2);
        order[link[j]]:=false;
       end;
     end; {for i}

   blockwrite(f,excludenum,2);
   if excludenum>0 then
    for j:=1 to excludenum do blockwrite(f,exclude[j],2);
   blockwrite(f,XML_DISPLAY.MaxClassSize,2); a:=SubStMaxPoint[0];
   blockwrite(f,a,2);
   if a>0 then
    for i:=1 to a do
     begin
      j:=SubStMaxPoint[i];
      blockwrite(f,j,2); blockwrite(f,SubStMax[j],2);
     end;
    ClassSubjects.SaveToFile;
  finally
   Closefile(f);
  end;
 except
 end;
 if SaveStudFlag then SaveAllStudentYears; {if students changed}
 if SaveSubsFlag then updatesub(0);
 SaveBlockFlag:=False;
 blockload:=1;
 CheckAccessRights(utBlock,41,false);
 updateBlockWindow;
end;

procedure TBlockwin.Save1Click(Sender: TObject);
var
  lMsg: string;
  lBlockYearName: string;
  lOkToSave: Boolean;
  lYearTitle: string;
begin
  lOkToSave := False;
  CheckCurrentYear;
  if CurrentYear = FBlockYear then
  begin
    lOkToSave := True;
  end
  else
  begin
    lYearTitle := LowerCase(YearTitle);
    lBlockYearName := Trim(YearName[FBlockYear]);
    if lBlockYearName = '' then
      lBlockYearName := AMG_UNKNOWN;
    if CurrentYear = -1 then
      lYearTitle := '';
    lMsg := 'Current group is ' + lYearTitle + ' ' + YearName[CurrentYear] + ' group.' + #10#13#10#13 + 'Are you sure you want to save the file as ' + lYearTitle + ' ' + YearName[CurrentYear] + '?';
    if MessageDlg(lMsg, mtConfirmation, mbYesNo, 0) = mrYes then
      lOkToSave := True;
  end;
  if lOkToSave then
    if CheckAccessRights(utBlock, 40, True) then SaveBlocksAsShow;
end;

procedure TBlockwin.CopyToWorksheet(Sender: TObject);
begin
 if CheckAccessRights(utBlock,40,true) then
  begin
   copyblockdlg:=Tcopyblockdlg.create(self);  {allocate dlg}
   copyblockdlg.showmodal;
   copyblockdlg.free;   {release dlg}
  end;
 if not(saveBlockFlag) then CheckAccessRights(utBlock,40,false)
end;

procedure TBlockwin.Move1Click(Sender: TObject);
begin
 if CheckAccessRights(utBlock,40,true) then
  begin
   if not(fMoveSubDlgUp) then
    begin
     movesubdlg:=Tmovesubdlg.create(self);  {allocate dlg}
     fMoveSubDlgUp:=true;
    end;
   movesubdlg.show;
  end;
end;

//#86 - Add this to help move the focused cell
procedure TBlockwin.MoveFocusUp1;
var
  i: integer;
begin
  i:=StringGrid1.Row;
  dec(i);
  StringGrid1.Row := i;
end;

procedure TBlockwin.Swap1Click(Sender: TObject);
begin
 if CheckAccessRights(utBlock,40,true) then
  begin
   swapsubdlg:=Tswapsubdlg.create(self);  {allocate dlg}
   swapsubdlg.showmodal;
   swapsubdlg.free;   {release dlg}
   if not(saveBlockFlag) then CheckAccessRights(utBlock,40,false)
  end;
end;

procedure TBlockwin.ReOrderChoices1Click(Sender: TObject);
var
 msg:                  string;
 clashcount,excluded,nosubs:  smallint;
 i,j,k,l,k5,ii:           smallint;
 ab,asub:              smallint;
 clashflag,overflow,HasSubInBlock:   bool;
 store:                array[1..nmbrchoices*2] of smallint;   // was 60
 SubBlock: array of smallint;
 altered:              bool;
begin
 countsubsinblock;
 if subsinblock=0 then exit;
 if CheckAccessRights(utBlock,41,true) then
 begin
  SetLength(SubBlock,2+NumCodes[0]);
  for i:=0 to NumCodes[0] do SubBlock[i]:=0;
  for i:=1 to XML_DISPLAY.blocknum do
   if Sheet[i,0]>0 then
    for j:=1 to Sheet[i,0] do
     begin
      asub:=Sheet[i,j];
      if (asub>0) and (asub<=NumCodes[0]) then SubBlock[asub]:=i;
     end;
  clashcount:=0; excluded:=0; altered:=false; nosubs:=0;
  screen.cursor:=crHourglass;
  for ii:=1 to groupnum do
   begin
//  for k:=1 to 60 do store[k]:=0;
  for k:=1 to (nmbrchoices*2) do store[k]:=0;
    ab:=1;
    i:=StGroup[ii];
    HasSubInBlock:=false;
    for j:=1 to chmax do
     begin
      asub:=XML_STUDENTS.Stud[i].Choices[j];
       if (asub>0) and (asub<=NumCodes[0]) then
        if SubBlock[asub]>0 then HasSubInBlock:=true;
     end;
    if not(HasSubInBlock) then
     begin
      inc(nosubs);
      continue;
     end;
    clashflag:=false;
    for j:=1 to chmax do
     begin
       asub:=XML_STUDENTS.Stud[i].Choices[j];
       if asub>0 then
         begin
          for k:=1 to XML_DISPLAY.blocknum do
           begin
            for l:=1 to XML_DISPLAY.blocklevel do
              if (asub=Sheet[k,l]) and (store[k]=0) then
                begin
                 store[k]:=asub;
                 asub:=0;
                 if k<>j then
                 begin
                      altered:=true; SaveStudFlag:=true; saveBlockFlag:=true;
                      StudYearFlag[XML_STUDENTS.Stud[i].tcYear]:=true;
                 end;
                 break;
                end;
            if asub=0 then break;
           end;
          if asub>0 then
            begin
             store[ab+XML_DISPLAY.blocknum]:=asub;
             inc(ab);
             if Blocktop[GsubXref[asub]]=0 then clashflag:=true;
            end;
         end; {if as>0}
     end; {j}
     overflow:=false;
     for K5:=nmbrchoices+1 to (nmbrchoices*2) do    // was 60 now nmbrchoices*2
      if store[k5]>0 then
        begin
         overflow:=true;
         break;
        end;
     if overflow then inc(excluded)
       else for j:=1 TO nmbrchoices do
            XML_STUDENTS.Stud[i].Choices[j]:=store[j];
     if clashflag then inc(clashcount);
   end; { i}
  countchmax;
  if altered then UpdateStudWins;
  screen.cursor:=crDefault;
  msg:='Re-ordering of choices completed.'+endline;
  if excluded>0 then msg:=msg+inttostr(excluded)+' students excluded.'+endline;
  if clashcount>0 then msg:=msg+inttostr(clashcount)+' students with clashes.'+endline;
  if nosubs>0 then msg:=msg+inttostr(nosubs)+' students with no subjects in blocks.'+endline;
  if altered then
   begin
    msg:=msg+'Save new order of choices for '+groupname+'?';
    if messagedlg(msg,mtConfirmation,[mbYes,mbNo],0)=mrYes then
     begin
      SaveAllStudentYears;
      if SaveSubsFlag then updatesub(0);
     end
    else SaveStudFlag:=True;
   end
  else
   begin
    msg:=msg+'Student choices were already in order.';
    messagedlg(msg,mtInformation,[mbOK],0);
   end;

  if not(saveBlockFlag) then CheckAccessRights(utBlock,41,false);
 end;
end;

procedure TBlockwin.Search(Sender: TObject);
var
  lFrmSearchBlocks: TFrmSearchBlocks;
begin
  lFrmSearchBlocks := TFrmSearchBlocks.Create(Application);
  try
    lFrmSearchBlocks.ShowModal;
  finally
    FreeAndNil(lFrmSearchBlocks);
  end;
end;

procedure TBlockwin.Sort1Click(Sender: TObject);
var
 sortflag,swaps:     bool;
 b,numb,n1:          integer;
 i,j,l,Asub,temp:    integer;
begin
 sortflag:=false;
 for b:=1 to XML_DISPLAY.blocknum do
  begin
   numb:=Sheet[b,0];
   n1:=numb;
   if numb>0 then
    begin
     n1:=0;
     for i:= 1 to numb do
       begin
        Asub:=Sheet[b,i];
        if Asub<>0 then
          begin
            inc(n1);
            Sheet[b,n1]:=Asub;
          end;
       end; {i}
      Sheet[b,0]:=n1;
      if n1<>numb then sortflag:=true;
      if fix[b]>n1 then fix[b]:=n1;
      numb:=n1-fix[b];
    end; {numb>0}
   if numb>1 then
    begin
      for i:=fix[b]+1 to n1-1 do
       begin
        swaps:=false;
        for j:=fix[b]+1 to fix[b]+n1-i do
         begin
          l:=j+1;
          if SubCode[Sheet[b,l]]<SubCode[Sheet[b,j]] then
            begin
             temp:=Sheet[b,l];
             Sheet[b,l]:=Sheet[b,j];
             Sheet[b,j]:=temp;
             sortflag:=true;
             swaps:=true;
            end; {if}
         end; {j}
        if swaps=false then break;
       end; {i}
    end; {numb>1}
  end; {b}
 if sortflag then
  begin
   if (usrPassLevel=utTime) or (usrPassLevel=3) or (usrPassLevel=utSuper)
       then SaveBlockFlag:=True;
   updateBlockWindow;
  end;
end;


procedure TBlockwin.SplitSubject1Click(Sender: TObject);
begin
 if CheckAccessRights(utBlock,41,true) then   {block}
  begin
   if CheckAccessRights(utBlock,6,true) then    {subs}
    begin
     splitsubdlg:=Tsplitsubdlg.create(self);  {allocate dlg}
     splitsubdlg.showmodal;
     splitsubdlg.free;   {release dlg}
     if saveSubsFlag then updatesub(0); {save subs before release lock}
     CheckAccessRights(utBlock,6,false);
    end;
   if not(saveBlockFlag) then CheckAccessRights(utBlock,41,false);
  end;
end;

procedure TBlockwin.AutoAllocation1Click(Sender: TObject);
begin
 if CheckAccessRights(utBlock,40,true) then
  begin
   autoallocdlg:=Tautoallocdlg.create(self);  {allocate dlg}
   autoallocdlg.showmodal;
   autoallocdlg.free;   {release dlg}
   if not(saveBlockFlag) then CheckAccessRights(utBlock,40,false)
  end;
end;

procedure TBlockwin.LinkSubjects1Click(Sender: TObject);
begin
 if CheckAccessRights(utBlock,40,true) then
  begin
   linksubdlg:=Tlinksubdlg.create(self);  {allocate dlg}
   linksubdlg.showmodal;
   linksubdlg.free;   {release dlg}
   if not(saveBlockFlag) then CheckAccessRights(utBlock,40,false)
  end;
end;

procedure TBlockwin.ExcludeSubjects1Click(Sender: TObject);
begin
 if CheckAccessRights(utBlock,40,true) then
  begin
   excludesubdlg:=Texcludesubdlg.create(self);  {allocate dlg}
   excludesubdlg.showmodal;
   excludesubdlg.free;   {release dlg}
   if not(saveBlockFlag) then CheckAccessRights(utBlock,40,false)
  end;
end;

procedure TBlockwin.FixSubjects1Click(Sender: TObject);
begin
 if CheckAccessRights(utBlock,40,true) then
  begin
   Fixsubdlg:=Tfixsubdlg.create(self);  {allocate dlg}
   Fixsubdlg.SubjectNo := FActiveSubNo;
   Fixsubdlg.showmodal;
   Fixsubdlg.free;   {release dlg}
   if not(saveBlockFlag) then CheckAccessRights(utBlock,40,false)
  end;
end;

procedure TBlockwin.DisplayExchangeBlocks(Sender: TObject);
begin
 if CheckAccessRights(utBlock,40,true) then
  begin
   ExchangeBlockdlg:=TExchangeBlockdlg.create(self);  {allocate dlg}
   ExchangeBlockdlg.showmodal;
   ExchangeBlockdlg.free;   {release dlg}
   if not(saveBlockFlag) then CheckAccessRights(utBlock,40,false)
  end;
end;

procedure TBlockwin.DisplayStudentClashes(Sender: TObject);
begin
   StBlockClashWinSelect;
end;

procedure TBlockwin.DisplayStudentsFree(Sender: TObject);
begin
   StudFreeWinSelect;
end;

procedure TBlockwin.Segregate1Click(Sender: TObject);
begin
 if CheckAccessRights(utBlock,41,true) then
  begin
   Segregatedlg:=TSegregatedlg.create(self);  {allocate dlg}
   Segregatedlg.showmodal;
   Segregatedlg.free;   {release dlg}
   if not(saveBlockFlag) then CheckAccessRights(utBlock,41,false);
  end;
end;

procedure TBlockwin.ClashHelp1Click(Sender: TObject);
begin
 if CheckAccessRights(utBlock,41,true) then
  begin
   StClashHelpDlg:=TStClashHelpDlg.create(self);  {allocate dlg}
   StClashHelpDlg.showmodal;
   StClashHelpDlg.free;   {release dlg}
   if not(saveBlockFlag) then CheckAccessRights(utBlock,41,false);
  end;
end;



{-----------------------  printing procs follow    ---------------------------}

procedure TPrintBlockWin.head;
var
 s: string;
begin
 UnderlineOn;
 Case BlockLoad of
  0: s:='(None)';
  1: s:='File: '+Blockfile;
  2: s:='from '+Blockday;
  3: s:='(New)'
 end;
 checkCurrentYear;
 printwl('Blocks - ');
 if (CurrentYear<>-1) then printwl(yeartitle+' '+yearname[Currentyear]);
 printwl('    '+s);
 printw(PageCount);
 UnderlineOff;
 x:=0; y:=y+2*PrnttxtHeight;
end;

procedure TPrintBlockWin.SetTabs;
begin
 SetLength(PrntTabs,3);
 PrntTabs[1]:=fwprntcode[0]+Printcanvas.textwidth(inttostr(XML_STUDENTS.numstud))+prntblankwidth*3;
 PrntTabs[2]:=PrintCanvas.textwidth('Students with clashes ');
end;


procedure blockswinprint;
var
 temp:        integer;
 s:            string;
 minlev,i2,k,per:            integer;
 place,a,i,j,i6,num,fitI,fitI1,fitI2:               integer;
 studclash:                        integer;
 fitcnt,fitpages,fitstart,fitcntYr:        integer;
 t1:                               integer;
 tmpflag,tmpblock:  array[0..nmbrblocks] of integer;
begin
 PrintBlockWin:=TPrintBlockWin.create;
 with PrintBlockWin do
  try
   PrintHead;
   fcolor(cpnormal);
   {fitcnt=number of blocks that fit across printed page}
   fitcnt:=(PrintPageWidth-prntHmargin-PrntTabs[2]) div PrntTabs[1];
   fitcntYr:=(PrintPageWidth-prntHmargin) div PrntTabs[1];
   if fitcnt<1 then fitcnt:=1;
   if fitcntYr<1 then fitcntYr:=1;
   fitpages:=XML_DISPLAY.blocknum div fitcnt;
   if (XML_DISPLAY.blocknum mod fitcnt)>0 then inc(fitpages);
   fitstart:=1;

   if not(bool(blockload)) then exit;
   t1:=0;
   {-------------print year subjects----------------}
   (*for i:=1 to GroupSubs[0] do
   begin
    place:=Blocktop[i];
    a:=GroupSubCount[GsubXref[place]];
    if place>0 then
    begin
     inc(t1);
     if t1>fitcntYr then
     begin
      t1:=1;
      newline;
     end;
     x:=PrntTabs[1]*(t1-1);
     printw(SubCode[place]);
     x:=x+fwprntcode[0]+prntblankwidth;
     printw(inttostr(a));
    end;
   end; {for i}
   newline;
   drawmyline(x,y+(PrnttxtHeight div 2),x+((blocknum+2)*PrntTabs[1]),y+(PrnttxtHeight div 2));*)
   newline;
   {-------------work out how many rows----------------}
   minlev:=1;
   for i:=1 to XML_DISPLAY.blocknum do
    for j:=1 to XML_DISPLAY.blocklevel do
    begin
     if Sheet[i,j]>0 then if j>minlev then minlev:=j;
    end;
  for fitI:=1 to fitpages do
  begin
   fitI1:=fitstart+((fitI-1)*fitcnt);
   fitI2:=fitI1+fitcnt-1;
   if fitI2>XML_DISPLAY.blocknum then
      fitI2:=XML_DISPLAY.blocknum;
   if fitI=1 then
    begin
     {-------------print block header row----------------}
     x:=PrntTabs[2]-PrintCanvas.textwidth('Blocks ');
     printwl('Blocks');
     for i6:=fitI1 to fitI2 do
     begin
      x:=PrntTabs[2]+PrntTabs[1]*(i6-fitI1)+(PrntTabs[1] div 2);
      x:=x-(PrintCanvas.textwidth('b '+inttostr(i6)) div 2)-prntblankwidth;
      printw('b '+inttostr(i6));
     end; {for i6}
     {-------------print block rows----------------}
     newline;  newline;
     x:=PrntTabs[2]-PrintCanvas.textwidth('Subjects ');
     printwl('Subjects');
    end;
   for j:=1 to minlev do
   begin
    if j=1 then newline;
    if (y=(prntVmargin+prnttxtheight)) then {repeat headers}
    begin
     x:=PrntTabs[2]-PrintCanvas.textwidth('Blocks ');
     printwl('Blocks');
     for i6:=fitI1 to fitI2 do
     begin
      x:=PrntTabs[2]+PrntTabs[1]*(i6-fitI1)+(PrntTabs[1] div 2);
      x:=x-(PrintCanvas.textwidth('b '+inttostr(i6)) div 2)-prntblankwidth;
      printw('b '+inttostr(i6));
     end; {for i6}
     {-------------print block rows----------------}
     newline;  newline;
     x:=PrntTabs[2]-PrintCanvas.textwidth('Subjects (Cont.) ');
     printwl('Subjects (Cont.)');
    end;
    for i:=fitI1 to fitI2 do
    begin
     a:=Sheet[i,j];
     if a>0 then
     begin
      x:=PrntTabs[2]+PrntTabs[1]*(i-fitI1);
      printw(SubCode[a]);
      x:=x+fwprntcode[0]+prntblankwidth;
      printw(inttostr(GroupSubCount[GsubXref[a]]));
     end;
    end; {for i}
    newline;

   end; {for j}
   {-------------calc clashes----------------}
   for i:=fitI1 to fitI2 do
   begin
    tmpflag[i]:=0;
    tmpblock[i]:=0;
   end; {for i}
   for per:=fitI1 to fitI2 do
   begin
    num:=Sheet[per,0];
    for i2:=1 to groupnum do
    begin
     i:=StGroup[i2];
     studclash:=0;
     for j:=1 to chmax do
     begin
      a:=XML_STUDENTS.Stud[i].choices[j];
      if a=0 then continue;
      for k:=1 to num do
      begin
       if a=Sheet[per,k] then inc(studclash);
      end; {for k}
     end; {for j}
     if bool(studclash) then
     begin
      inc(tmpblock[per]);
      if studclash>1 then inc(tmpflag[per]);
     end;
    end; {for i2}
   end; {for per}
   {-------------print clash and count rows----------------}
   newline;
   x:=PrntTabs[2]-PrintCanvas.textwidth('Clashes ');
   printwl('Clashes');
   for i:=fitI1 to fitI2 do
   begin
    x:=PrntTabs[2]+PrntTabs[1]*(i-fitI1);
    x:=x+fwprntcode[0]-PrintCanvas.textwidth(inttostr(blockclashes[i]));
    printwl(inttostr(blockclashes[i]));
   end; {for i}
   newline; newline;
   x:=PrntTabs[2]-PrintCanvas.textwidth('Subject count ');
   printwl('Subject count');
   for i:=fitI1 to fitI2 do
   begin
    x:=PrntTabs[2]+PrntTabs[1]*(i-fitI1);
    x:=x+fwprntcode[0]-PrintCanvas.textwidth(inttostr(Sheet[i,0]));
    printwl(inttostr(Sheet[i,0]));
   end; {for i}
   newline;
   x:=PrntTabs[2]-PrintCanvas.textwidth('Students in block ');
   printwl('Students in block');
   for i:=fitI1 to fitI2 do
   begin
    x:=PrntTabs[2]+PrntTabs[1]*(i-fitI1);
    x:=x+fwprntcode[0]-PrintCanvas.textwidth(inttostr(tmpblock[i]));
    printwl(inttostr(tmpblock[i]));
   end; {for i}
   newline;
   x:=PrntTabs[2]-PrintCanvas.textwidth('Students with clashes ');
   printwl('Students with clashes');
   for i:=fitI1 to fitI2 do
   begin
    x:=PrntTabs[2]+PrntTabs[1]*(i-fitI1);
    x:=x+fwprntcode[0]-PrintCanvas.textwidth(inttostr(tmpflag[i]));
    printwl(inttostr(tmpflag[i]));
   end; {for i}
   newline;
   x:=PrntTabs[2]-PrintCanvas.textwidth('Students free ');
   printwl('Students free');
   for i:=fitI1 to fitI2 do
   begin
    x:=PrntTabs[2]+PrntTabs[1]*(i-fitI1);
    x:=x+fwprntcode[0]-PrintCanvas.textwidth(inttostr(groupnum-tmpblock[i]));
    printwl(inttostr(groupnum-tmpblock[i]));
   end; {for i}
   newline;

   if (fitI<>fitPages) then startnewpage;
  end; {for fitI}
   newline;
   printCustomAddon;
  finally
   PrintBlockWin.Free;
  end;
end;




procedure TBlockwin.Create1Click(Sender: TObject);
begin
 if CheckAccessRights(utBlock,41,true) then   {block}
  begin
   if CheckAccessRights(utBlock,6,true) then  {subs}
    begin
     createdlg:=Tcreatedlg.create(self);  {allocate dlg}
     createdlg.showmodal;
     createdlg.free;   {release dlg}
     if saveSubsFlag then updatesub(0); {save subs before release lock}
     CheckAccessRights(utBlock,6,false);
    end;
   if not(saveBlockFlag) then CheckAccessRights(utBlock,41,false);
  end;
end;

procedure TBlockwin.Panel1DblClick(Sender: TObject);
begin
 move1click(self);
end;

procedure TBlockwin.StringGrid1DblClick(Sender: TObject);
begin
 doubleclick:=true;
 move1click(self);
end;

procedure TBlockwin.Image1DblClick(Sender: TObject);
begin
 move1click(self);
end;

procedure TBlockwin.Label3DblClick(Sender: TObject);
begin
 move1click(self);
end;

procedure TBlockwin.Exportastextfile1Click(Sender: TObject);
begin
 TextExportWindow(self.tag);
end;

procedure TOutBlockWin.head;
var
 s: string;
begin
 CheckCurrentYear;
 Case BlockLoad of
   0: s:='(None)';
   1: s:='File: '+Blockfile;
   2: s:='from '+Blockday;
   3: s:='(New)'
 end;
 printw('Blocks ');
 if currentyear<>-1 then printw('- '+yeartitle+' '+yearname[currentyear]);
 printw('    '+s);
 newline; newline;
end;


procedure blockswintext;
var
 minlev,i2,k,per:            integer;
 place,a,i,j,i6,num:               integer;
 studclash:                        integer;
 t1:                               integer;
 tmpflag,tmpblock:  array[0..nmbrblocks] of integer;
begin
 OutBlockWin:=TOutBlockWin.create;
 with OutBlockWin do
  try
   Header;
   if not(bool(blockload)) then exit;
   t1:=0;
   for i:=1 to GroupSubs[0] do
    begin
     place:=Blocktop[i];
     a:=GroupSubCount[GsubXref[place]];
     if place>0 then
      begin
       inc(t1);
       if t1>9 then
        begin
         t1:=1;
         newline;
        end;
       printc(SubCode[place]);
       printc(inttostr(a));
      end;
    end; {for i}
   newline; newline;
   minlev:=1;
   for i:=1 to XML_DISPLAY.blocknum do
    for j:=1 to XML_DISPLAY.blocklevel do
     begin
       if Sheet[i,j]>0 then if j>minlev then minlev:=j;
      end;
   for i6:=1 to XML_DISPLAY.blocknum do
     begin
      printc('b '); printc(inttostr(i6));
     end; {for i6}
   newline;  newline;
   for j:=1 to minlev do
    begin
     for i:=1 to XML_DISPLAY.blocknum do
      begin
       a:=Sheet[i,j];
       if a>0 then
       begin
        printc(SubCode[a]);
        printc(inttostr(GroupSubCount[GsubXref[a]]));
       end
       else
        begin printc(''); printc(''); end;
      end; {for i}
     newline;
    end; {for j}
   for i:=1 to XML_DISPLAY.blocknum do
    begin
     tmpflag[i]:=0;
     tmpblock[i]:=0;
    end; {for i}
   for per:=1 to XML_DISPLAY.blocknum do
    begin
     num:=Sheet[per,0];
     for i2:=1 to groupnum do
      begin
       i:=StGroup[i2];
       studclash:=0;
       for j:=1 to chmax do
        begin
         a:=XML_STUDENTS.Stud[i].choices[j];
         if a=0 then continue;
         for k:=1 to num do
          begin
           if a=Sheet[per,k] then inc(studclash);
          end; {for k}
        end; {for j}
       if bool(studclash) then
        begin
         inc(tmpblock[per]);
         if studclash>1 then inc(tmpflag[per]);
        end;
      end; {for i2}
    end; {for per}
   newline;
   for i:=1 to XML_DISPLAY.blocknum do
    begin
     printc(inttostr(blockclashes[i]));
    end; {for i}
   printc('Clashes');
   newline; newline;
   for i:=1 to XML_DISPLAY.blocknum do
    begin
     printc(inttostr(tmpblock[i]));
    end; {for i}
   printc('Students in block');
   newline;
   for i:=1 to XML_DISPLAY.blocknum do
    begin
     printc(inttostr(tmpflag[i]));
    end; {for i}
   printc('Students with clashes');
   newline;
   for i:=1 to XML_DISPLAY.blocknum do
    begin
     printc(inttostr(groupnum-tmpblock[i]));
    end; {for i}
   printc('Students free');
   newline;
   printCustomAddon;
  finally
   OutBlockWin.Free;
  end;

end;


function getCellText(row,col: smallint):string;
var
 k:   smallint;
begin
 result:=''+ht+'';
 if (row>XML_DISPLAY.blocklevel) then exit; {bottom max}
 if (col>(XML_DISPLAY.blocknum-1)) then exit; {right max}
 if row=0 then
 begin     {fixed top}
  result:='Block: '+inttostr(col+1)+ht;
 end
 else  {main grid data}
  begin
   if (row<=Sheet[col+1,0]) then
   begin
    k:=Sheet[col+1,row];
    result:=SubCode[k]+ht+inttoStr(GroupSubCount[GsubXref[k]]);
   end;  {if (row<=Sheet[col+1,0]) }
  end;
end;

procedure copyBLOCKtextToClipboard;
var
 i,j,x1,x2,y1,y2: smallint;
begin
 studText:=''; genText:='';
 x1:=Blockwin.stringgrid1.selection.left;     if x1<0 then x1:=0;
 x2:=Blockwin.stringgrid1.selection.right;    if x2<0 then x2:=0;
 y1:=Blockwin.stringgrid1.selection.top;      if y1<1 then y1:=1;
 y2:=Blockwin.stringgrid1.selection.bottom;   if y2<1 then y2:=1;
 for i:=y1 to y2 do
 begin
  for j:=x1 to x2 do
  begin
   if not(j=x1) then genText:=genText+ht;
   genText:=genText+getCellText(i,j);
  end; {for j}
  if (i<>y2) then genText:=genText+endline;
 end; {for i}
 genText:=genText+chr(0);
 studText:=copy(genText,1,length(genText));
 copyTextToClipboard(cfBlock);
end;



procedure TBlockwin.CopytexttoClipboard1Click(Sender: TObject);
begin
 copyBLOCKtextToClipboard;
end;

procedure TBlockwin.CopyToFromTimetable(Sender: TObject);
var
  lFrmCopyBlockToTT: TFrmCopyBlockToTT;
begin
  lFrmCopyBlockToTT := TFrmCopyBlockToTT.Create(Application);
  try
    lFrmCopyBlockToTT.ShowModal;
  finally
    FreeAndNil(lFrmCopyBlockToTT);
  end;
end;

procedure TBlockwin.StringGrid1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
 aRow,aCol:   longint;
 curSelection:        TgridRect;
 i,j:                 integer;
begin
  if doubleclick then
  begin
    doubleclick:=false;
    exit;
  end;
  blockwin.repaint;
  stringgrid1.mousetocell(x,y,aCol,aRow);

  {whole block}
  if aRow=0 then {block}
  begin
   CurSelection.left:=aCol;     CurSelection.right:=aCol;
   CurSelection.top:=1;     CurSelection.bottom:=XML_DISPLAY.blocklevel;
   stringgrid1.selection:=CurSelection;
  end;

   i:=stringgrid1.selection.Left+1; j:=stringgrid1.selection.Top;
   if (i>0) and (i<=XML_DISPLAY.blocknum) then
    if (j>0) and (j<=Sheet[i,0]) then
    begin
      {update movesubdlg if up}
      if fMoveSubDlgUp then
      begin
        //MoveSubDlg.Edit1.Text:=SubCode[Sheet[i,j]];

        //Update the combo box and related fields with the current selection
        MoveSubDlg.cboMoveSubjectSubject.ItemIndex := MoveSubDlg.cboMoveSubjectSubject.Items.IndexOf(SubCode[Sheet[i,j]]);

        MoveSubDlg.label3.caption:=inttostr(i);
        MoveSubDlg.label5.caption:=Subname[Sheet[i,j]];
        MoveSubDlg.update;
        FActiveSubNo := Sheet[i, j];
      end;{if fMoveSubDlgUp}
      FActiveSubNo := Sheet[i, j];
    end;

  if Button = mbLeft then
  with Sender as TStringGrid do
  begin
    if (StringGrid1.Row <= StringGrid1.RowCount) and (StringGrid1.Col <= StringGrid1.ColCount) then
      BeginDrag(False);
  end;
end;

procedure TBlockwin.Copy2Click(Sender: TObject);
begin
 copyBLOCKtextToClipboard;
end;

procedure parseClipBlockText;
var
 i,j,x1,y1: smallint;
 su:          smallint;
 msg:         string;

  procedure getBlkClip;
  var
   ss: string;
  begin
   GotCr:=false; su:=0; ss:=GetNextClipStr;
   su:=checkcode(0,ss);
   if ((Clipboard.HasFormat(CF_AMIG_Block_Data)) or  {skip subject count or teacher code}
     (Clipboard.HasFormat(CF_AMIG_Timetable_Data))) then ss:=GetNextClipStr;

   if Clipboard.HasFormat(CF_AMIG_Timetable_Data) then  ss:=GetNextClipStr; {skip room code}
  end;

begin
 x1:=Blockwin.stringgrid1.selection.left;     if x1<0 then x1:=0;
 y1:=Blockwin.stringgrid1.selection.top;      if y1<1 then y1:=1;
 j:=y1; i:=x1+1;  msg:='';
 while genText<>'' do
 begin
  getBlkClip;
  if subISAlreadyinBlock(su,i) then
  begin
   if msg='' then msg:=SubCode[su]+' was not pasted to block '+inttostr(i)
    +' as it was already in that block';
  end
  else
   begin
    if (i<=XML_DISPLAY.blocknum) and (j<=XML_DISPLAY.blocklevel) then
     Sheet[i,j]:=su; {sub}
   end;
  inc(i);
  if GotCr then begin inc(j); i:=x1+1; end;
 end;
 if msg>'' then
 begin
  msg:='Some subjects were NOT pasted,'+endline+'For example, '+endline+msg;
  messagedlg(msg,mtInformation,[mbOK],0);
 end;
 checkblocks;  {update Sheet[1,0] counts}
 countsubsinblock;
 if (usrPassLevel=utTime) or (usrPassLevel=utBlock) or (usrPassLevel=utSuper)
       then SaveBlockFlag:=True;
 UpdateBlockWindow;
end;

procedure wipeBlockTextCells;
var
 i,j,x1,x2,y1,y2: smallint;
begin
 x1:=Blockwin.stringgrid1.selection.left;     if x1<0 then x1:=0;
 x2:=Blockwin.stringgrid1.selection.right;    if x2<0 then x2:=0;
 y1:=Blockwin.stringgrid1.selection.top;      if y1<1 then y1:=1;
 y2:=Blockwin.stringgrid1.selection.bottom;   if y2<1 then y2:=1;
 x1:=x1+1; x2:=x2+1; {zero based}
 for i:=y1 to y2 do
 begin
  for j:=x1 to x2 do
  begin
   Sheet[j,i]:=0;
  end;{for j}
 end; {for i}
end;

procedure  ClearBLOCKtext;
begin
 wipeBlockTextCells;
 checkblocks;  {update Sheet[1,0] counts}
 countsubsinblock;
 if (usrPassLevel=utTime) or (usrPassLevel=utBlock) or (usrPassLevel=utSuper)
       then SaveBlockFlag:=True;
 UpdateBlockWindow;
end;


procedure TBlockwin.Cut1Click(Sender: TObject);
begin
 if CheckAccessRights(utBlock,40,true) then
  begin
   copyBLOCKtextToClipboard;
   ClearBLOCKtext;
  end;
end;

procedure TBlockwin.Delete1Click(Sender: TObject);
begin
 if CheckAccessRights(utBlock,40,true) then ClearBLOCKtext;
end;

procedure TBlockwin.Paste1Click(Sender: TObject);
begin
 if ((usrPassLevel<>utTime) and (usrPassLevel<>utSuper) and (usrPassLevel<>utBlock)) then
  begin
   showRestrictedMsg;
   exit;
  end;
 if CheckAccessRights(utBlock,40,true) then
  begin
   if not(Clipboard.HasFormat(CF_TEXT)) then exit;
   getTextFromClipboard(CF_TEXT); {get clip text}
   wipeBlockTextCells;
   parseClipBlockText;
  end;
end;

procedure TBlockwin.PasteSelectedSubjectFromGroupSubject(Sender: TObject);
begin
  parseClipBlockText;
end;

procedure TBlockwin.FormDeactivate(Sender: TObject);
begin
 cut1.ShortCut:=ShortCut(0,[]);
 copy2.ShortCut:=ShortCut(0,[]);
 paste1.ShortCut:=ShortCut(0,[]);
 delete1.shortcut:=shortcut(0,[]);
 mainform.CopyWin.ShortCut:=ShortCut(0,[]);
end;

procedure TBlockwin.Panel4DockOver(Sender: TObject;
  Source: TDragDockObject; X, Y: Integer; State: TDragState;
  var Accept: Boolean);
var
 aa: smallint;
begin
aa:=(source.control as tform).tag;
accept:=(aa=wnBlTool);
end;

procedure TBlockwin.Panel7DockOver(Sender: TObject;
  Source: TDragDockObject; X, Y: Integer; State: TDragState;
  var Accept: Boolean);
var
 aa: smallint;
begin
aa:=(source.control as tform).tag;
accept:=(aa=wnBlTool);
end;

procedure TBlockwin.Panel4DockDrop(Sender: TObject;
  Source: TDragDockObject; X, Y: Integer);
begin
 panel4.height:=panel4.height+(source.control as tform).clientheight;
 XML_DISPLAY.fgBlockToolbarDock:=1;
end;

procedure TBlockwin.Panel7DockDrop(Sender: TObject;
  Source: TDragDockObject; X, Y: Integer);
begin
 panel7.height:=panel7.height+(source.control as tform).clientheight;
 XML_DISPLAY.fgBlockToolbarDock:=2;
end;

procedure TBlockwin.ManualFixSub;
var
 SRect: TGridRect;
 i,j,jj,sub1,fromBlock,sublevel:   integer;
begin
 Sub1:=0; fromblock:=0; sublevel:=0;
 SRect:=StringGrid1.Selection;
 i:=SRect.Left+1; j:=SRect.Top;
 if (i>0) and (i<=XML_DISPLAY.blocknum) then
  if (j>0) and (j<=Sheet[i,0]) then
   begin
    Sub1:=Sheet[i,j];  {base it on top left}
    fromblock:=i; sublevel:=j;
   end;
 if (fromBlock=0) or (Sub1=0) then exit; {no subject selection found}
 if (sublevel<=fix[fromBlock]) then {unfix subject}
  begin
   dec(fix[fromBlock]);
   if sublevel<(fix[fromBlock]+1) then
    for j:=sublevel to fix[fromBlock] do
     swapint(Sheet[fromBlock,j],Sheet[fromBlock,j+1]);
  end
 else {fix subject}
  begin
   if sublevel>fix[fromBlock] then
    for jj:=sublevel-1 downto fix[fromBlock]+1 do
     swapint(Sheet[fromBlock,jj],Sheet[fromBlock,jj+1]);
   inc(fix[fromBlock]);
  end;
 checkfix;  settop;
 Repaint;  stringgrid1.repaint;  SetTopLabel;
 if (usrPassLevel=utTime) or (usrPassLevel=utBlock) or (usrPassLevel=utSuper)
       then SaveBlockFlag:=True;
end;

procedure TBlockwin.StringGrid1KeyPress(Sender: TObject; var Key: Char);
begin
 if uppercase(key)='F' then ManualFixSub;
end;

procedure TBlockwin.StringGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 case key of
  VK_RETURN : Move1Click(self);
 end;
end;

procedure TBlockwin.SelectAll1Click(Sender: TObject);
var
 curSelection:        TgridRect;
begin
 CurSelection.left:=0;
 CurSelection.right:=stringgrid1.colcount;
 CurSelection.top:=1;
 CurSelection.bottom:=XML_DISPLAY.blocklevel;
 stringgrid1.selection:=CurSelection;
end;

procedure TBlockwin.Edit1Click(Sender: TObject);
begin
 paste1.enabled:=GetClipStatus(wnBlock);
end;

procedure TBlockwin.ClassSizes1Click(Sender: TObject);
begin
 SetSubSizeDlg:=TsetSubSizeDlg.create(self);  {allocate dlg}
 SetSubSizeDlg.showmodal;
 SetSubSizeDlg.free;   {release dlg}
end;

end.
