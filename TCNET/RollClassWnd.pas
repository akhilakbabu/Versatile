unit RollClassWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls,TimeChartGlobals,ClassDefs,printers,GlobalToTcAndTcextra,
  XML.DISPLAY;

type
  TRollClassWindow = class(TCodeWin)
    PopupMenu1: TPopupMenu;
    add2: TMenuItem;
    Change2: TMenuItem;
    Delete2: TMenuItem;
    N6: TMenuItem;
    Timetable1: TMenuItem;
    CodeLengths2: TMenuItem;
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
    Add1: TMenuItem;
    Change1: TMenuItem;
    Delete1: TMenuItem;
    N4: TMenuItem;
    Codelengths1: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Add1Click(Sender: TObject);
    procedure Change1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure Codelengths1Click(Sender: TObject);
    procedure Timetable1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure Codes1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
  protected
    procedure PaintItem(i:integer;SelFlag:boolean); override;
    procedure SetTabs; override;
    procedure PaintHead; override;
    function MyCodePoint(i:integer): integer; override;
  end;

 procedure RollCodePrint;
 procedure RollCodeOut;


 var
  RollClassWindow: TRollClassWindow;

implementation
 uses main,tcommon,tcommon2,addclass,edclass,delclass,lenclass,showclas,tcommon5;
{$R *.dfm}

 type TPrintRollWin=class(TPrintCodeWin)
  public
   procedure head; override;
   procedure SetTabs; override;
 end;

 type TOutRollWin=class(TOutCodeWin)
  public
   procedure head; override;
   function CodeToPrint(i:integer):string; override;
 end;

var
 PrintRollWin:    TPrintRollWin;
 OutRollWin:      TOutRollWin;


function ClassIsOnTtable(cc: integer):wordbool;
var
 i,j: integer;
begin
  result:=false;
  for i:=years_minus_1 downto 0 do
   for j:=1 to nmbrlevels do
    if ClassShown[j,i]=cc then
    begin
     result:=true; break;
    end;
end;


function TRollClassWindow.MyCodePoint(i:integer): integer;
begin
 result:=RollClassPoint[i];
end;


procedure TRollClassWindow.setTabs;
begin
 setlength(Tabs,3);
 TotalCodes:=RollClassPoint[0];
 headwidth:=canvas.textwidth('Roll Class Codes: 99   Code length: 8 ');
 CodeWidth:=fwClass+blankWidth;
 CalcScreenCodeFit;
 maxW:=CodeWidth*CodeFit;
 ReDoSelection;
end;

procedure TRollClassWindow.PaintItem(i:integer;SelFlag:boolean);
begin
 printw(ClassCode[RollClassPoint[i]]);
 fcolor(codecolor);
end;

procedure TRollClassWindow.PaintHead;
begin
 codeColor:=cpClass; {subject}
 {Headings}
  printw2('Roll Class Codes: ',inttostr(TotalCodes));
  printw2('  Code Length: ',inttostr(LenClassCodes));
  newline;
  newline;
end;

procedure TRollClassWindow.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action:= caFree;
end;

procedure TRollClassWindow.FormCreate(Sender: TObject);
begin
 setWindowDefaults(self,wnRClassCode);
end;

procedure TRollClassWindow.FormResize(Sender: TObject);
begin
  Self.SetTabs;
  Refresh;
end;

procedure TPrintRollWin.SetTabs;
begin
 setlength(PrntTabs,3);
 TotalCodes:=RollClassPoint[0];
 CodeWidth:=fwPrntClass+prntBlankwidth;
 CalcPrintCodeFit;
end;

procedure TPrintRollWin.head;
begin
 codeColor:=cpClass;
 fcolor(cpNormal);
 UnderlineOn;
 printw2('Roll Class Codes: ',inttostr(TotalCodes));
 printw2('  Code Length: ',inttostr(LenClassCodes));
 printw(PageCount);
 UnderlineOff;
 x:=0; y:=y+2*PrnttxtHeight;
 fcolor(codeColor);
end;



procedure RollCodePrint;
var
 i: integer;
begin
 PrintRollWin:=TPrintRollWin.Create;
 with PrintRollWin do
  try
   PrintHead;
   if TotalCodes<=0 then exit;
   for i:=1 to TotalCodes do
    begin
     printw(ClassCode[RollClassPoint[i]]);
     x:=(i mod codefit)*CodeWidth;
     if (i mod codefit)=0 then newline;
    end;  {for i}
    newline;
   printCustomAddon;
  finally; {with PrintTeWin}
   PrintRollWin.Free;
  end;
end; {main print}


procedure TOutRollWin.head;
begin
 printLine(['Roll Class Codes: ',inttostr(Totalcodes),
     ' Code Length: ',inttostr(LenClassCodes)]);
 newline;
 newline;
end;

function TOutRollWin.CodeToPrint(i:integer):string;
begin
 result:=ClassCode[RollClassPoint[i]];
end;


procedure RollCodeOut;
var
 i: integer;

begin
 OutRollWin:=TOutRollWin.Create;
 with OutRollWin do
  try
   Setup(RollClassPoint[0]);
   if TotalCodes<=0 then exit;
   for i:=1 to TotalCodes do PrintCode(i);
   newline;
   printCustomAddon;
  finally; {with OutTeWin}
   OutRollWin.Free;
  end;
end; {main text output}



procedure TRollClassWindow.Add1Click(Sender: TObject);
begin
 if TooMany('roll class codes',RollClassPoint[0],nmbrClass) then exit;
 if CheckAccessRights(utStud,4,true) then
  begin
   AddclassDlg:=TAddclassDlg.create(self); {allocate dlg}
   AddclassDlg.showmodal;
   AddclassDlg.free;  {release dlg}
  end;
 CheckAccessRights(utStud,4,false);
end;

procedure TRollClassWindow.Change1Click(Sender: TObject);
begin
 if CheckAccessRights(utStud,4,true) then
 begin
  edclassdlg:=Tedclassdlg.create(self);  {allocate dlg}
  edclassdlg.showmodal;
  edclassdlg.free;  {release dlg}
  CheckAccessRights(utStud,4,false);
 end;
end;

procedure TRollClassWindow.Delete1Click(Sender: TObject);
begin
 if CheckAccessRights(utStud,4,true) then
 begin
  DelclassDlg:=TDelclassDlg.create(self);  {allocate dlg}
  DelclassDlg.showmodal;
  DelclassDlg.free;    {release dlg}
  CheckAccessRights(utStud,4,false);
 end;
end;

procedure TRollClassWindow.Codelengths1Click(Sender: TObject);
begin
 if CheckAccessRights(utTime,4,true) then
 begin
  lenClassDlg:=TlenClassDlg.create(self);   {allocate dlg}
  lenClassDlg.tag:=tag;
  lenClassDlg.showmodal;
  lenClassDlg.free;   {release dlg}
  CheckAccessRights(utTime,4,false);
 end;
end;

procedure TRollClassWindow.Timetable1Click(Sender: TObject);
var
 i,j,year1,level1,myclass: integer;
begin
 myclass:=RollClassPoint[selcode];
 year1:=0;level1:=1;
 if ClassIsOnTtable(myclass) then
  begin
   for i:=years_minus_1 downto 0 do
    for j:=1 to nmbrlevels do
     if ClassShown[j,i]=myclass then
      begin
       year1:=i; level1:=j; break;
      end;
    XML_DISPLAY.subttlistselection:=3; {class tt}
    XML_DISPLAY.subttlistvals[1]:=year1;
    XML_DISPLAY.subttlistvals[2]:=level1;
    subjectTtablewinSelect;
    UpdateWindow(wnSubjectTt);
   end;
end;

procedure TRollClassWindow.PopupMenu1Popup(Sender: TObject);
var
 hascodes:  boolean;
begin
 add2.enabled:=(TotalCodes<nmbrTeachers);
 hascodes:=(TotalCodes>0);
 change2.enabled:=hascodes;
 delete2.enabled:=hascodes;
 timetable1.visible:=ClassIsOnTtable(RollClassPoint[selcode]);

 add2.Visible:=(usrPasslevel>utGen);
 change2.Visible:=(usrPasslevel>utGen);
 delete2.Visible:=(usrPasslevel>utGen);
 codelengths2.Visible:=(usrPasslevel>utGen);
end;

procedure TRollClassWindow.Codes1Click(Sender: TObject);
var
 hascodes:  boolean;
begin
 TickCodeSubMenu(SelectCode1);
 hascodes:=(TotalCodes>0);
 add1.enabled:=(TotalCodes<nmbrTeachers);
 change1.enabled:=hascodes;
 delete1.enabled:=hascodes;


 add1.Visible:=(usrPasslevel>utGen);
 change1.Visible:=(usrPasslevel>utGen);
 delete1.Visible:=(usrPasslevel>utGen);
 codelengths1.Visible:=(usrPasslevel>utGen);
end;

end.
