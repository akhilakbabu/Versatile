unit HouseWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls,TimeChartGlobals,ClassDefs,printers;

type
  THouseWindow = class(TCodeWin)
    PopupMenu1: TPopupMenu;
    Change2: TMenuItem;
    N7: TMenuItem;
    Print2: TMenuItem;
    PrintSetup2: TMenuItem;
    Exportastextfile1: TMenuItem;
    MainMenu1: TMainMenu;
    Codes1: TMenuItem;
    SelectCode1: TMenuItem;
    Subject1: TMenuItem;
    Teacher1: TMenuItem;
    Room1: TMenuItem;
    Class1: TMenuItem;
    Faculty1: TMenuItem;
    House1: TMenuItem;
    Times1: TMenuItem;
    N5: TMenuItem;
    Change1: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Change1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure Codes1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
  protected
    procedure PaintItem(i:integer;SelFlag:boolean); override;
    procedure SetTabs; override;
    procedure PaintHead; override;    
  end;

 procedure HoCodePrint;
 procedure HoCodeOut;


 var
  HouseWindow: THouseWindow;

implementation
 uses main,tcommon,tcommon2,edhouse,tcommon5;
{$R *.dfm}

 type TPrintHoWin=class(TPrintCodeWin)
  public
   procedure head; override;
   procedure SetTabs; override;
 end;

 type TOutHoWin=class(TOutCodeWin)
  public
   procedure head; override;
   function CodeToPrint(i:integer):string; override;
 end;


var
 PrintHoWin:    TPrintHoWin;
 OutHoWin:      TOutHoWin;

procedure THouseWindow.setTabs;
begin
 setlength(Tabs,3);
 TotalCodes:=HouseCount;
 headwidth:=canvas.textwidth('Houses: 999  ');
 CodeWidth:=canvas.textwidth(inttostr(HouseCount)+': ')+fwHouse+blankWidth;
 //CodeFit:= trunc(screen.width*0.9) div CodeWidth;
  if CodeWidth <> 0 then
    CodeFit := Trunc(Self.Width - HMargin) div CodeWidth
  else
    CodeFit := 1;
 if CodeFit>TotalCodes then CodeFit:=TotalCodes;
 if Codefit=0 then Codefit:=1;
 maxW:=Hmargin+CodeWidth*CodeFit;
 maxH:=txtheight*((TotalCodes div CodeFit)+5)
end;

procedure THouseWindow.PaintItem(i:integer;SelFlag:boolean);
begin
 printw(inttostr(i)+': '+HouseName[i]);
 fcolor(codecolor);
end;

procedure THouseWindow.PaintHead;
begin
 codeColor:=cpHouse;
 {Headings}
  printw2('Houses: ',inttostr(TotalCodes));
  newline;
  newline;
end;

procedure THouseWindow.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action:= caFree;
end;

procedure THouseWindow.FormCreate(Sender: TObject);
begin
 setWindowDefaults(self,wnHouse);
end;

procedure THouseWindow.FormResize(Sender: TObject);
begin
  Self.SetTabs;
  Refresh;
end;

procedure TPrintHoWin.SetTabs;
begin
 setlength(PrntTabs,3);
 TotalCodes:=HouseCount;
 CodeWidth:=PrintCanvas.textwidth(inttostr(HouseCount)+': ')+fwprntHouse+prntblankWidth;
 CalcPrintCodeFit;
end;

procedure TPrintHoWin.head;
begin
 codeColor:=cpHouse;
 UnderlineOn;
 printw2('Houses: ',inttostr(TotalCodes));
 printw(PageCount);
 UnderlineOff;
 x:=0; y:=y+PrnttxtHeight;
end;



procedure HoCodePrint;
var
 i: integer;
begin
 PrintHoWin:=TPrintHoWin.Create;
 with PrintHoWin do
  try
   PrintHead;
   if TotalCodes<=0 then exit;
   for i:=1 to TotalCodes do
    begin
     printw(inttostr(i)+': '+HouseName[i]);
     x:=(i mod codefit)*CodeWidth;
     if (i mod codefit)=0 then newline;
    end;  {for i  to totalcodes}
    newline;
   printCustomAddon;
  finally; {with PrintTeWin}
   PrintHoWin.Free;
  end;
end; {main print}


procedure TOutHoWin.head;
begin
 printLine(['Houses: ',inttostr(HouseCount)]);
 newline;
end;

function TOutHoWin.CodeToPrint(i:integer):string;
begin
 result:=inttostr(i)+': '+HouseName[i];
end;


procedure HoCodeOut;
var
 i: integer;

begin
 OutHoWin:=TOutHoWin.Create;
 with OutHoWin do
  try
   Setup(HouseCount);
   if TotalCodes<=0 then exit;
   for i:=1 to TotalCodes do PrintCode(i);
    newline;
   printCustomAddon;
  finally; {with OutTeWin}
   OutHoWin.Free;
  end;
end; {main text output}



procedure THouseWindow.Change1Click(Sender: TObject);
begin
 if CheckAccessRights(utStud,3,true) then
 begin
  edhousedlg:=Tedhousedlg.create(self);   {allocate dlg}
  edhousedlg.showmodal;
  edhousedlg.free;   {release dlg}
  CheckAccessRights(utStud,3,false);
 end;
end;

procedure THouseWindow.PopupMenu1Popup(Sender: TObject);
begin
 change2.Visible:=(usrPasslevel>utGen);
 N7.Visible:=(usrPasslevel>utGen);
end;

procedure THouseWindow.Codes1Click(Sender: TObject);
begin
 TickCodeSubMenu(SelectCode1);
 change1.Visible:=(usrPasslevel>utGen);
 N5.Visible:=(usrPasslevel>utGen);
end;

end.
