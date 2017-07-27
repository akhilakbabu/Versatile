unit ClassWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls,TcLoad,ClassDefs,printers;

type
  TClassWindow = class(TCodeWin)
    PopupMenu1: TPopupMenu;
    add2: TMenuItem;
    Change2: TMenuItem;
    Delete2: TMenuItem;
    N6: TMenuItem;
    Timetable1: TMenuItem;
    View2: TMenuItem;
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
    ShowClasses1: TMenuItem;
    N4: TMenuItem;
    View1: TMenuItem;
    Codelengths1: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure Codes1Click(Sender: TObject);
    procedure View1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure PaintItem(i:integer;SelFlag:boolean); override;
    procedure SetTabs; override;
    procedure PaintHead; override;    
  end;

 procedure SuCodePrint;
 procedure SuCodeOut;


 var
  ClassWindow: TClassWindow;

implementation
 uses main,CodeView,tcommon,tcommon2;
{$R *.dfm}

 type TPrintSuWin=class(TPrintCodeWin)
  public
   procedure head; override;
   procedure SetTabs; override;
 end;

 type TOutSuWin=class(TOutCodeWin)
  public
   procedure head; override;
   function CodeToPrint(i:integer):string; override;
 end;


const
 mycode=0;
var
 PrintSuWin:    TPrintSuWin;
 OutSuWin:      TOutSuWin;

procedure TClassWindow.setTabs;
begin
 setlength(Tabs,3);
 TotalCodes:=codenum[mycode];
 headwidth:=canvas.textwidth('Subject Codes: 99  Sort: Name  Code length: 8 ');
 CodeWidth:=fwCode[mycode]+blankWidth;
 CalcScreenCodeFit;
                  
 maxTab(1,Codewidth,'Code');
 maxTab(2,fwCodename[mycode],'Name ');
 case winView[wnTecode] of
  0: maxW:=CodeWidth*CodeFit;  {codes}
  1: maxW:=Tabs[2]+blankwidth;
 end; {case}
end;

procedure TClassWindow.PaintItem(i:integer;SelFlag:boolean);
var
 k:    integer;
begin
 k:=codepoint[i,mycode];
 case winView[wnSucode] of
   0: printw(subcode[k]);  {codes only}
   1: begin  {code + name}
        printw(subcode[k]);
        x:=Tabs[1]; printw(Subname[k]);
      end;
  end;
 fcolor(codecolor);
end;

procedure TClassWindow.PaintHead;
begin
 codeColor:=cpSub; {subject}
 {Headings}
  printw2('Subject Codes: ',inttostr(TotalCodes));
  printw2('  Sort: ',sortname[sorttype[mycode]]);
  printw2('  Code Length: ',inttostr(lencodes[mycode]));
  newline;
  if TotalCodes>0 then
    case winView[wnTecode] of
     1: begin  {code + name}
          fcolor(cpNormal); printwl('Code ');
          x:=Tabs[1]; printw('Name');
        end;

    end;
  newline;
end;

procedure TClassWindow.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action:= caFree;
end;

procedure TClassWindow.FormCreate(Sender: TObject);
begin
 tag:=wnSuCode;
 setWindowDefaults(self,wnSuCode);
end;

procedure TClassWindow.FormActivate(Sender: TObject);
begin
 DoubleClick:=false;
end;

procedure TClassWindow.PopupMenu1Popup(Sender: TObject);
begin
 view2.enabled:=(TotalCodes>0);
end;

procedure TClassWindow.Codes1Click(Sender: TObject);
var
 hascodes:  boolean;
begin
  hascodes:=(TotalCodes>0);
  view1.enabled:=hascodes;
end;

procedure TPrintSuWin.SetTabs;
begin
 setlength(PrntTabs,3);
 TotalCodes:=codenum[mycode];
 CodeWidth:=fwPrntCode[mycode]+prntBlankwidth;
 maxTab(1,Codewidth,'Code');
 maxTab(2,fwPrntCodename[mycode],'Name ');
 case winView[wnSucode] of
 0: CalcPrintCodeFit;  {codes}
 1: codefit:=1;
 end;
end;

procedure TPrintSuWin.head;
begin
 codeColor:=cpSub;
 UnderlineOn;
 printw2('Subject Codes: ',inttostr(codenum[mycode]));
 printw2('  Sort: ',sortname[sorttype[mycode]]);
 printw2('  Code Length: ',inttostr(lencodes[mycode]));
 printw(PageCount);
 UnderlineOff;
 x:=0; y:=y+PrnttxtHeight;
 fcolor(cpNormal);
 if winView[wnSucode]=1 then
   begin {codes + name}
     printwl('Code ');
     x:=prntTabs[1]; printw('Name');
    end;
 x:=0; y:=y+PrnttxtHeight;
end;



procedure SuCodePrint;
var
 i,k: integer;
begin
 PrintSuWin:=TPrintSuWin.Create;
 with PrintSuWin do
  try
   PrintHead;
   if TotalCodes<=0 then exit;
   for i:=1 to TotalCodes do
    begin
     k:=codepoint[i,mycode];
     case winView[wnSucode] of
      0: begin
          printw(Subcode[k]);
          x:=(i mod codefit)*CodeWidth;
          if (i mod codefit)=0 then newline;
         end;
      1: begin
          printw(Subcode[k]);
          x:=prntTabs[1]; printw(subname[k]);
          newline;
         end;

     end;  {case}
    end;  {for i  to totalcodes}
    newline;
   printCustomAddon;
  finally; {with PrintTeWin}
   PrintSuWin.Free;
  end;
end; {main print}


procedure TOutSuWin.head;
begin
 printLine(['Subject Codes: ',inttostr(codenum[mycode]),' Sort: ',sortname[sorttype[mycode]],
     ' Code Length: ',inttostr(lencodes[mycode])]);
 newline;
  case winView[wnSucode] of
   1: begin {codes + name}
       printLine(['Code ','Name']);
      end;
  end; {case}
 newline;
end;

function TOutSuWin.CodeToPrint(i:integer):string;
begin
 result:=Subcode[codepoint[i,mycode]];
end;


procedure SuCodeOut;
var
 i,k: integer;

begin
 OutSuWin:=TOutSuWin.Create;
 with OutSuWin do
  try
   Setup(codenum[mycode]);
   if TotalCodes<=0 then exit;
   for i:=1 to TotalCodes do
    begin
     k:=codepoint[i,mycode];
     case winView[wnSucode] of
      0: PrintCode(i);
      1: printLine([subcode[k,0],subname[k,0]]);
     end;  {case}
    end;  {for i  to totalcodes}
    newline;
   printCustomAddon;
  finally; {with OutTeWin}
   OutSuWin.Free;
  end;
end; {main text output}



procedure TClassWindow.View1Click(Sender: TObject);
var
 oldshow,oldsort,myselect,i: smallint;
begin
 oldshow:=winView[wnSucode];
 oldsort:=sorttype[mycode];
 ViewCodeDialog:=TViewCodeDialog.create(self); {allocate dlg}
 ViewCodeDialog.Tag:=wnSucode;
 viewCodeDialog.showmodal;
 viewCodeDialog.free;
 myselect:=0;
 if sorttype[mycode]<>oldsort then
  begin
   if selCode>0 then myselect:=codepoint^[selCode,mycode];
   sortcodes(mycode);
   for i:=1 to codenum[mycode] do
    if codepoint^[i,mycode]=myselect then
      begin
       selCode:=i;
       break;
      end;
  end;
  if (sorttype[mycode]<>oldsort) or (oldshow<>winView[wnSucode]) then UpdateWin;
end;

end.
