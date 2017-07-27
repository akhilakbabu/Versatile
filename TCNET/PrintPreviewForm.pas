unit PrintPreviewForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ToolWin, ComCtrls, ActnList, ImgList, StdCtrls, Buttons, WinSpool,
  ExtCtrls,Printers, TimeChartGlobals, XML.DISPLAY;

type
  TPrntPreviewForm = class(TForm)
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ppActionList: TActionList;
    PreviewPrint: TAction;
    ImageList2: TImageList;
    PreviewSetupPage: TAction;
    ToolButton7: TToolButton;
    Label1: TLabel;
    PageEdit: TEdit;
    Label2: TLabel;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ComboBox1: TComboBox;
    ToolButton13: TToolButton;
    Button1: TButton;
    ToolButton14: TToolButton;
    Helpbutton: TBitBtn;
    ScrollBox1: TScrollBox;
    Panel1: TPanel;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ToolButton8Click(Sender: TObject);
    procedure ToolButton9Click(Sender: TObject);
    procedure ToolButton7Click(Sender: TObject);
    procedure ToolButton6Click(Sender: TObject);
    procedure ToolButton11Click(Sender: TObject);
    procedure ToolButton12Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PreviewSetupPageExecute(Sender: TObject);
    procedure PreviewPrintExecute(Sender: TObject);
    procedure PageEditKeyPress(Sender: TObject; var Key: Char);
    procedure Button2Click(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel1Exit(Sender: TObject);
  private
    FirstActivation: Boolean;
    function GetTotalPages: Integer;
    function GetPageWidth: Integer;
    function GetPageHeight: Integer;
    procedure BeginDoc;
    procedure EndDoc;
    procedure CreatePages;
    procedure FirstPreview;
    procedure ChangePreview;
    procedure SetZoomButtons;
    procedure UpdateZoom;
    procedure ReshowPage;
    procedure SetInitialPaper;
    procedure ShowPage;
  public
    procedure NewPage;
    property TotalPages: Integer read GetTotalPages;
    property PageWidth: Integer read GetPageWidth;
    property PageHeight: Integer read GetPageHeight;
  end;

var
  PrntPreviewForm: TPrntPreviewForm;
  ppCanvas: Tcanvas;
  FIsPPLandscape: Boolean;

implementation
uses tcommon, Main,DlgCommon;
{$R *.dfm}
{$R Preview.RES}


const
 crHand = 10;     crGrab = 11;
 zoomrange: array[0..6] of integer = (25,50,75,100,150,200,300);
 MagicNumber: LongInt = $50502D4B;
 SInvalidPreviewFile  = '%s'+#10#13#10#13+'File does not contain valid preview data.';

 {AM - Using screen pixels
 Paper size is not quite right - getting one less subject code,
  two less students

 }

type
  EInvalidPreviewFile = class(Exception);

type
  TPreviewState = (psReady, psCreating, psPrinting);
  TZoomState = (zsZoomOther, zsZoomToWidth, zsZoomToHeight, zsZoomToFit);

  TMetaFileList = class(TObject)
  private
    FStream: TStream;
    FRecords: TList;
    FMetaFile: TMetaFile;
    FUseTempFile: Boolean;
    FTempFile: string;
    function GetCount: Integer;
    function GetItems(Index: Integer): TMetaFile;
    procedure SetUseTempFile(Value: Boolean);
    function CreateMetaFileStream: TStream;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function Add(AMetaFile: TMetaFile): Integer;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TMetaFile read GetItems; default;
    property UseTempFile: Boolean read FUseTempFile write SetUseTempFile;
  end;


var
 ppZoom: integer=100;
 ppCanScrollHorz,ppCanScrollVert,PrinterInstalled: Boolean;
 ppState: TPreviewState;
 PaperWidth,PaperHeight,ppClientWidth,ppClientHeight: integer;
 ppOrientation: TPrinterOrientation;
 ppGutter: integer;
 ppZoomState: TZoomState;
 ppPages: TMetaFileList;
 FOldMousePos,OldScrollPos: TPoint;
 FCurrentPage: Integer;
 MetaFile: TMetafile;
 PanelWmargin,PanelHmargin: integer;
 ScrnPixInch: integer;

function GetTemporaryFileName: string;
var
 TempPath: array[0..255] of Char;
 TempFile: array[0..255] of Char;
begin
 GetTempPath(SizeOf(TempPath), TempPath);
 GetTempFileName(TempPath, 'TMP', 0, TempFile);
 Result:= StrPas(TempFile);
end;



procedure OutOfMemory;
begin
  raise EOutOfMemory.Create('Not enough memory to create a new page');
end;



procedure GetPrinterParameters;
var
 PrnPixInchX,PrnPixInchY: integer;
begin
 PrinterInstalled:=Printer.Printers.Count>0;
 if PrinterInstalled then
  if not Printer.Printing then
   begin
    ppOrientation:=Printer.Orientation;
    PrnPixInchX:=GetDeviceCaps(Printer.Handle,LOGPIXELSX);
    PrnPixInchY:=GetDeviceCaps(Printer.Handle,LOGPIXELSY);
    PaperHeight:=MulDiv(Printer.PageHeight,ScrnPixInch,PrnPixInchY);
    PaperWidth:=MulDiv(Printer.PageWidth,ScrnPixInch,PrnPixInchX);
   end;
end;



constructor TMetaFileList.Create;
begin
  inherited Create;
  FUseTempFile := True;
  FRecords := TList.Create;
  FTempFile := EmptyStr;
  FMetaFile := nil;
  FStream := nil;
end;

destructor TMetaFileList.Destroy;
begin
  Clear;
  FRecords.Free;
  inherited Destroy;
end;

procedure TMetaFileList.Clear;
begin
  FRecords.Clear;
  if Assigned(FStream) then
  begin
    FStream.Free;
    FStream := nil;
    if FUseTempFile and FileExists(FTempFile) then
      DeleteFile(FTempFile);
  end;
  if Assigned(FMetaFile) then
  begin
    FMetaFile.Free;
    FMetaFile := nil;
  end;
end;

function TMetaFileList.Add(AMetaFile: TMetaFile): Integer;
var
  Offset: LongInt;
begin
  if not Assigned(FStream) then
    FStream := CreateMetaFileStream;
  FStream.Seek(0, soFromEnd);
  Offset := FStream.Position;
  AMetaFile.SaveToStream(FStream);
  Result := FRecords.Add(Pointer(Offset));
end;



function TMetaFileList.GetCount: Integer;
begin
  Result := FRecords.Count;
end;

function TMetaFileList.GetItems(Index: Integer): TMetaFile;
begin
  if not Assigned(FMetaFile) then
    FMetaFile := TMetaFile.Create;
  if (Index >= 0) and (Index < FRecords.Count) then
  begin
    FStream.Seek(LongInt(FRecords[Index]), soFromBeginning);
    FMetaFile.LoadFromStream(FStream);
  end
  else
  begin
    FMetaFile.Clear;
  end;
  Result := FMetaFile;
end;

procedure TMetaFileList.SetUseTempFile(Value: Boolean);
var
  NewStream: TStream;
begin
  if FUseTempFile <> Value then
  begin
    FUseTempFile := Value;
    if Assigned(FStream) then
    begin
      NewStream := CreateMetaFileStream;
      NewStream.CopyFrom(FStream, 0);
      FStream.Free;
      FStream := NewStream;
      if not FUseTempFile and FileExists(FTempFile) then
      begin
        DeleteFile(FTempFile);
        FTempFile := EmptyStr;
      end;
    end;
  end;
end;

function TMetaFileList.CreateMetaFileStream: TStream;
begin
  if FUseTempFile then
  begin
    FTempFile := GetTemporaryFileName;
    Result := TFileStream.Create(FTempFile, fmCreate or fmShareExclusive)
  end
  else
    Result := TMemoryStream.Create;
end;




procedure SetUseTempFile(Value: Boolean);
begin
  ppPages.UseTempFile := Value;
end;

function GetTotalPages: Integer;
begin
  Result := ppPages.Count;
end;

function TPrntPreviewForm.GetPageWidth: Integer;
begin
 Result:=PaperWidth;
end;

function TPrntPreviewForm.GetPageHeight: Integer;
begin
 Result:=PaperHeight;
end;



procedure CreateMetaFileCanvas;
begin
 Metafile:=TMetafile.Create;
 MetaFile.Width:=PaperWidth;
 MetaFile.Height:=PaperHeight;
 ppCanvas:=TMetafileCanvas.Create(Metafile, 0);
 if ppCanvas.Handle = 0 then
  begin
   MetaFile.Free;
   OutOfMemory;
  end;
 SetMapMode(ppCanvas.Handle, MM_ANISOTROPIC);
 SetWindowExtEx(ppCanvas.Handle, PaperWidth, PaperHeight, nil);
 SetViewPortExtEx(ppCanvas.Handle,PaperWidth, PaperHeight, nil);
 ppCanvas.Font.Assign(PreviewFont);
end;

procedure CloseMetaFileCanvas;
begin
  ppCanvas.Free;
  ppCanvas := nil;
  if MetaFile.Handle = 0 then
  begin
    MetaFile.Free;
    OutOfMemory;
  end;
end;

procedure Clear;
begin
  ppPages.Clear;
  ppState := psReady;
  FCurrentPage := 0;
end;

procedure TPrntPreviewForm.BeginDoc;
begin
  if ppState <> psCreating then
  begin
    Clear;
    ppState := psCreating;
    NewPage;
  end;
end;

procedure TPrntPreviewForm.EndDoc;
begin
  if ppState = psCreating then
  begin
    CloseMetaFileCanvas;
    try
      ppPages.Add(MetaFile);
    finally
      MetaFile.Free;
    end;
    if FCurrentPage = 0 then
    begin
      FCurrentPage := 1;
    end;
    ppState := psReady;
  end;
end;

procedure TPrntPreviewForm.NewPage;
begin
  if ppState = psCreating then
  begin
    if Assigned(ppCanvas) then
    begin
      CloseMetaFileCanvas;
      try
        ppPages.Add(MetaFile);
      finally
        MetaFile.Free;
      end;
      if FCurrentPage = 0 then
      begin
        FCurrentPage := 1;
      end;
    end;
    CreateMetaFileCanvas;
  end;
end;




procedure TPrntPreviewForm.ShowPage;
var
  W, H: Integer;
  Bitmap: TBitmap;
  MetaFile: TMetaFile;
begin
 if (FCurrentPage>=1) and (FCurrentPage<=TotalPages) then
  begin
   MetaFile:=TMetaFile(ppPages[FCurrentPage-1]);
   W:=Image1.Width;
   H:=Image1.Height;
   Bitmap:=TBitmap.Create;
   try
    Bitmap.Width:=W;  Bitmap.Height:=H;
    Bitmap.Canvas.StretchDraw(Rect(0,0,W,H),MetaFile);
    Bitmap.PixelFormat:=pf24bit;
    BitBlt(Image1.Canvas.Handle,0,0,W,H,
               Bitmap.Canvas.Handle, 0, 0, SRCCOPY);
   finally
    Bitmap.Free;
   end;
  end;
 Image1.Invalidate;  Panel1.Invalidate;
end;

procedure TPrntPreviewForm.ReshowPage;
begin
 SetInitialPaper;
 ShowPage;
end;

procedure TPrntPreviewForm.SetInitialPaper;
var
 PR: TRect;
begin
 with Image1.Canvas do
  begin
    PR.Left:=0; PR.Right:=Image1.Width;
    PR.Top:=0;  PR.Bottom:=Image1.Height;
    Pen.Mode := pmCopy;
    Brush.Style := bsSolid;
    Brush.Color := clWhite;
    FillRect(PR);
  end;
 PrntPreviewForm.Image1.Repaint;
end;


procedure TPrntPreviewForm.UpdateZoom;
var
 PVleft,PVtop: integer;
 PercentX, PercentY: LongInt;  {ZoomPos}
 Width2,Height2: Integer;
 sbHpos,sbVpos,sbHmax,sbVmax:  integer;

 Procedure CalcZoom;
  begin
   ppZoom:=MulDiv(Width2,100,PaperWidth);
  end;

begin
 if csLoading in ComponentState then Exit;
 sbHpos:=ScrollBox1.HorzScrollbar.Position;
 sbHmax:=ScrollBox1.HorzScrollBar.Range;
 sbVpos:=ScrollBox1.VertScrollbar.Position;
 sbVmax:=ScrollBox1.VertScrollbar.Range;
 Width2:=ppClientWidth;
 Height2:=ppClientHeight;
 PercentX:=0; PercentY:=0;
 try
  if sbHmax>ppClientWidth then
        PercentX:=sbHpos*100 div (sbHmax-ppClientWidth);
  if sbVmax>ppClientHeight then
        PercentY:=sbVpos*100 div (sbVmax-ppClientHeight);
 except
  PercentX:=0;  PercentY:=0;
 end;

 ScrollBox1.HorzScrollBar.Position := 0;
 ScrollBox1.VertScrollBar.Position := 0;
 try
  case ppZoomState of
   zsZoomOther:
    begin
     Width2:=MulDiv(PaperWidth,ppZoom,100);
     Height2:=MulDiv(PaperHeight,ppZoom,100);
    end;
   zsZoomToWidth:
    begin
     Width2:=ppClientWidth;
     Height2:=MulDiv(PaperHeight,Width2,PaperWidth);
    end;
   zsZoomToHeight:
    begin
     Height2:=ppClientHeight;
     Width2:=MulDiv(PaperWidth,Height2,PaperHeight);
    end;
   zsZoomToFit:
    begin
     if (ppClientHeight>ppClientWidth) then
      begin
       Width2:=ppClientWidth;
       Height2:=MulDiv(PaperHeight,Width2,PaperWidth);
      end
     else
      begin
       Height2 := ppClientHeight;
       Width2:=MulDiv(PaperWidth,Height2,PaperHeight);
      end;
    end;
  end;

 ppCanScrollHorz:=(Width2>ppClientWidth);
 ppCanScrollVert:=(Height2>ppClientHeight);
 if ppCanScrollVert or ppCanScrollHorz then
   image1.Cursor:=crHand else image1.Cursor:=crDefault;

 if ppCanScrollHorz then PVleft:=0
   else PVleft:=(ppClientWidth-Width2) div 2;

 if ppCanScrollVert then PVtop:=0
    else  PVtop:=(ppClientHeight-Height2) div 2;

 Panel1.Top:=PVtop;
 Panel1.Left:=PVleft;
 Panel1.Height:=Height2+panelHmargin;
 Panel1.Width:=Width2+PanelWmargin;
 Image1.Height:=Height2;
 Image1.Width:=Width2;

 if ppCanScrollHorz then
  ScrollBox1.HorzScrollbar.Position:=PercentX*(ScrollBox1.HorzScrollBar.Range-ppClientWidth) div 100;  {ZoomPos}

 if ppCanScrollVert then
  ScrollBox1.VertScrollbar.Position:=PercentY*(ScrollBox1.VertScrollBar.Range-ppClientHeight) div 100;  {ZoomPos}

 finally
  CalcZoom;
 end;
end;


function TPrntPreviewForm.GetTotalPages: Integer;
begin
  Result := ppPages.Count;
end;





procedure TPrntPreviewForm.SetZoomButtons;
begin
 ToolButton12.Enabled := (ppZoom >25);
 ToolButton11.Enabled := (ppZoom <300);
end;

procedure SetPaperSizes;
begin
 ScrnPixInch:=Screen.PixelsPerInch;
 ppGutter := 60; {default gutter - 6mm}
 // start with A4 paper 21cm X 29.7 cm
 PaperWidth:=MulDiv((2100-2*ppGutter),ScrnPixInch,254);
 PaperHeight:=MulDiv((2970-2*ppGutter),ScrnPixInch,254);
 if FIsPPLandscape then
   ppOrientation := poLandscape
 else
   ppOrientation := poPortrait;
 Printer.Orientation := ppOrientation;
 GetPrinterParameters;
 prntHmargin:=MulDiv(trunc(100*XML_DISPLAY.prntLeftMargin),ScrnPixInch,254);
 prntVmargin:=MulDiv(trunc(100*XML_DISPLAY.prntTopMargin),ScrnPixInch,254);

 
end;



procedure GetZoom(zmIndex: integer);
begin
 ppZoomState:=zsZoomOther;
 case zmIndex of
   0: ppZoom := 25;
   1: ppZoom := 50;
   2: ppZoom := 75;
   3: ppZoom := 100;
   4: ppZoom := 150;
   5: ppZoom := 200;
   6: ppZoom := 300;
   7: ppZoomState := zsZoomToWidth;
   8: ppZoomState := zsZoomToHeight;
   9: ppZoomState := zsZoomToFit;
 end;
end;


procedure TPrntPreviewForm.FormCreate(Sender: TObject);
begin
 ComboBox1.ItemIndex := XML_DISPLAY.PreviewLastZoom;
 GetZoom(XML_DISPLAY.PreviewLastZoom);
 FirstActivation := True;
 PreviewOn:=True;
 ppState := psReady;
 Previewfont:=tfont.create;
 Previewfont.assign(XML_DISPLAY.tcfont);
 ppPages := TMetaFileList.Create;
end;

function SetPageSizes:boolean;
var
 mywidth,myheight: integer;
 PrnPixInchX,PrnPixInchY: integer;
 MarginLeft: integer;
 MarginTop: integer;
 PrintAreaHorz: integer;
 PrintAreaVert: integer;
 PhysWidth: integer;
 PhysHeight: integer;
begin
 result:=false;
 if not PrinterInstalled then exit;
 if ppOrientation<>Printer.Orientation then result:=True;
 ppOrientation:=Printer.Orientation;
 PrnPixInchX:=GetDeviceCaps(Printer.Handle,LOGPIXELSX);
 PrnPixInchY:=GetDeviceCaps(Printer.Handle,LOGPIXELSY);
 MarginLeft := GetDeviceCaps(Printer.Handle, PHYSICALOFFSETX);
 //ShowMessage(inttostr(MarginLeft));
 MarginTop := GetDeviceCaps(Printer.Handle, PHYSICALOFFSETY);
 //ShowMessage(inttostr(MarginTop));
 PrintAreaHorz := GetDeviceCaps(Printer.Handle, HORZRES);
 PrintAreaVert := GetDeviceCaps(Printer.Handle, VERTRES);
 PhysWidth := GetDeviceCaps(Printer.Handle, PHYSICALWIDTH);
 PhysHeight := GetDeviceCaps(Printer.Handle, PHYSICALHEIGHT);

 myheight:=MulDiv((Printer.PageHeight),ScrnPixInch,PrnPixInchY);
 mywidth:=MulDiv((Printer.PageWidth),ScrnPixInch,PrnPixInchX);

 myheight:=MulDiv((PhysHeight),ScrnPixInch,PrnPixInchY);
 mywidth:=MulDiv((PhysWidth),ScrnPixInch,PrnPixInchX);

 myheight:=MulDiv((PrintAreaVert-(MarginTop*2)),ScrnPixInch,PrnPixInchY);
 mywidth:=MulDiv((PrintAreaHorz-MarginLeft),ScrnPixInch,PrnPixInchX);

 if (PaperHeight<>myheight) or (PaperWidth<>mywidth) then result:=true;
 PaperHeight:=myheight;
 PaperWidth:=mywidth;
end;

procedure TPrntPreviewForm.FormActivate(Sender: TObject);
begin
 if not(FirstActivation) then exit;
 PanelWmargin:=panel1.Width-Image1.Width;
 PanelHmargin:=panel1.Height-Image1.Height;
 ppClientWidth:=ScrollBox1.ClientWidth-PanelWmargin;
 ppClientHeight:=ScrollBox1.ClientHeight-PanelHmargin;
 SetPaperSizes;
 FirstActivation := False;
 SetPageSizes;
 CreatePages;
end;



procedure TPrntPreviewForm.CreatePages;
begin
 Caption := 'Creating pages...';
 Randomize;
 BeginDoc;
 getPrntFontWidths(ppCanvas);
 printOurWindowDetail(PreviewWin);
 EndDoc;
 FirstPreview;
 ChangePreview;
 { If there's any installed printer on the system, we permit printing. }
 ToolButton2.Enabled:=PrinterInstalled;
 ToolButton1.Enabled:=PrinterInstalled;
 ActiveControl := ScrollBox1;
 Caption := setprintertitle(PreviewWin);
end;

procedure TPrntPreviewForm.FirstPreview;
begin
 Panel1.Height:=3*PaperHeight+panelHmargin;
 Panel1.Width:=3*PaperWidth+PanelWmargin;
 Image1.Height:=3*PaperHeight;
 Image1.Width:=3*PaperWidth;
 ShowPage;
 ScrollBox1.Visible:=true;
 ppClientWidth:=ScrollBox1.ClientWidth-PanelWmargin;
 ppClientHeight:=ScrollBox1.ClientHeight-PanelHmargin;
 UpdateZoom;
 SetInitialPaper;
end;

procedure TPrntPreviewForm.ChangePreview;
begin
 if FCurrentPage <> 0 then
  begin
   PageEdit.Text:=inttostr(FCurrentPage);
   Label2.Caption := Format('of %d',[TotalPages]);
   Label2.Update;
   ToolButton6.Enabled := (FCurrentPage > 1);
   ToolButton7.Enabled := (FCurrentPage > 1);
   ToolButton8.Enabled := (FCurrentPage < TotalPages);
   ToolButton9.Enabled := (FCurrentPage < TotalPages);
  end
 else
  PageEdit.Text:='';
 ReshowPage;
end;

procedure TPrntPreviewForm.ComboBox1Change(Sender: TObject);
begin
 GetZoom(Combobox1.ItemIndex);
 if XML_DISPLAY.PreviewLastZoom<>ComboBox1.ItemIndex then
  begin
   SetZoomButtons;
   UpdateZoom;
   ShowPage;
   XML_DISPLAY.PreviewLastZoom:=ComboBox1.ItemIndex;
  end;
end;

procedure TPrntPreviewForm.ToolButton8Click(Sender: TObject);
begin
 if (FCurrentPage<TotalPages) then
  begin
   inc(FCurrentPage);
   ChangePreview;
  end;
end;

procedure TPrntPreviewForm.ToolButton9Click(Sender: TObject);
begin
 if FCurrentPage<TotalPages then
  begin
   FCurrentPage:=TotalPages;
   ChangePreview;
  end;
end;

procedure TPrntPreviewForm.ToolButton7Click(Sender: TObject);
begin
 if FCurrentPage>1 then
  begin
   dec(FCurrentPage);
   ChangePreview;
  end;
end;

procedure TPrntPreviewForm.ToolButton6Click(Sender: TObject);
begin
 if FCurrentPage>1 then
  begin
   FCurrentPage:=1;
   ChangePreview;
  end;
end;

procedure TPrntPreviewForm.ToolButton11Click(Sender: TObject);
var
 i,oldZoom,oldindex: integer;
begin
 oldZoom:=ppZoom;
 oldIndex:=0;
 for i:=0 to 6 do if oldzoom>=zoomrange[i] then oldIndex:=i;
  if oldIndex<6 then
   begin
    combobox1.ItemIndex:=oldIndex+1;
    ComboBox1Change(Self);
   end;
end;

procedure TPrntPreviewForm.ToolButton12Click(Sender: TObject);
var
 i,oldZoom,oldindex: integer;
begin
 oldZoom:=ppZoom;
 oldIndex:=6;
 for i:=6 downto 0 do if oldzoom<=zoomrange[i] then oldIndex:=i;
  if oldIndex>0 then
   begin
    combobox1.ItemIndex:=oldIndex-1;
    ComboBox1Change(Self);
   end;
end;

procedure TPrntPreviewForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 XML_DISPLAY.PreviewLastZoom:=ComboBox1.ItemIndex;
 PreviewOn:=false;
 PreviewFont.Free;
 ppPages.Free;
end;

procedure TPrntPreviewForm.PreviewSetupPageExecute(Sender: TObject);
begin
  if Mainform.PrintSetupDialog.execute then
  if SetPageSizes then CreatePages;
  FIsPPLandscape := ppOrientation = poLandscape;
end;

procedure TPrntPreviewForm.PreviewPrintExecute(Sender: TObject);
begin
 printOurWindow(PreviewWin);
 ActiveControl := ScrollBox1;
end;

procedure TPrntPreviewForm.PageEditKeyPress(Sender: TObject; var Key: Char);
var
 mypage: integer;
begin
 if key=chr(13) then
  begin
   mypage:=IntFromEdit(PageEdit);
   if (mypage>0) and (mypage<=TotalPages)
     and (mypage<>FCurrentPage) then
       begin
        FCurrentPage:=mypage;
        ActiveControl := ScrollBox1;
        pageEdit.SelectAll;
        PageEdit.SetFocus;
       end;
  end;
end;



procedure TPrntPreviewForm.Button2Click(Sender: TObject);
begin
Application.HelpCommand(HELP_CONTEXT,136);
end;

procedure TPrntPreviewForm.Image1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 FOldMousePos.X:=X+panel1.Left;
 FOldMousePos.Y:=Y+panel1.Top;
 OldScrollPos.X:=ScrollBox1.HorzScrollBar.Position;
 OldScrollPos.Y:=ScrollBox1.VertScrollBar.Position;
 if ssLeft in Shift then
  if ppCanScrollVert or ppCanScrollHorz then Screen.Cursor:=crGrab;
end;

procedure TPrntPreviewForm.Image1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
 Delta: TPoint;
 X1,Y1,X2,Y2: integer;
begin
 Delta.X := X+panel1.left - FOldMousePos.X;
 X1:=ScrollBox1.HorzScrollBar.Position;
 X2:=ScrollBox1.HorzScrollBar.Range;
 Delta.Y := Y+panel1.Top - FOldMousePos.Y;
 Y1:=ScrollBox1.VertScrollBar.Position;
 Y2:=ScrollBox1.VertScrollBar.Range;

 if ssLeft in Shift then
  begin
   if ((Delta.X<0) and (X1<X2)) or ((Delta.X>0) and (X1>0)) then
     ScrollBox1.HorzScrollBar.Position:=OldScrollPos.X-Delta.X;
   if ((Delta.Y<0) and (Y1<Y2)) or ((Delta.Y>0) and (Y1>0)) then
     ScrollBox1.VertScrollBar.Position:=OldScrollPos.Y-Delta.Y;
  end;
end;


procedure TPrntPreviewForm.Image1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 Screen.Cursor:=crDefault;
 if ppCanScrollVert or ppCanScrollHorz then Image1.Cursor:=crHand;
end;

procedure TPrntPreviewForm.Panel1Exit(Sender: TObject);
begin
 Screen.Cursor:=crDefault;
end;

initialization
  Screen.Cursors[crHand] := LoadCursor(hInstance, 'CURSOR_HAND');
  Screen.Cursors[crGrab] := LoadCursor(hInstance, 'CURSOR_GRAB');
end.
