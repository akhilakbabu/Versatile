unit SuWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls,TimeChartGlobals,ClassDefs,printers, XML.DISPLAY;

type
  TSuWindow = class(TCodeWin)
    PopupMenu1: TPopupMenu;
    add2: TMenuItem;
    Change2: TMenuItem;
    Delete2: TMenuItem;
    N6: TMenuItem;
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
    N4: TMenuItem;
    View1: TMenuItem;
    Codelengths1: TMenuItem;
    ReportCodes1: TMenuItem;
    popSubjectBulkRename: TMenuItem;
    popSubjectBulkRenamePop: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure Codes1Click(Sender: TObject);
    procedure View1Click(Sender: TObject);
    procedure Add1Click(Sender: TObject);
    procedure Change1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure Codelengths1Click(Sender: TObject);
    procedure ReportCodes1Click(Sender: TObject);
    procedure BulkRenameSubjects(Sender: TObject);
    procedure FormResize(Sender: TObject);
  protected
    procedure PaintItem(i:integer;SelFlag:boolean); override;
    procedure SetTabs; override;
    procedure PaintHead; override;
    function MyCodePoint(i:integer): integer; override;
  end;

 procedure SuCodePrint;
 procedure SuCodeOut;

 var
  SuWindow: TSuWindow;

implementation

uses
  main,CodeView,tcommon,tcommon2,addscode,edscode,delscode,codelen,tcommon5,
  SubReportLen, DlgCommon, BulkRenameSubjects;

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




function TSuWindow.MyCodePoint(i:integer): integer;
begin
 result:=codepoint[i,mycode];
end;



procedure TSuWindow.setTabs;
begin
 setlength(Tabs,5);
 TotalCodes:=codeCount[mycode];
 headwidth:=canvas.textwidth('Subject Codes: 99  Sort: Name  Code length: 10 ');
 CodeWidth:=fwCode[mycode]+blankWidth;
 CalcScreenCodeFit;
 if NumSubRepCodes=0 then
    XML_DISPLAY.winViewMax[wnSucode]:=1
 else
    XML_DISPLAY.winViewMax[wnSucode]:=2;
 if WinView[wnSucode]>XML_DISPLAY.winViewMax[wnSucode] then WinView[wnSucode]:=XML_DISPLAY.winViewMax[wnSucode];
 maxTab(1,Codewidth,'Code');
 maxTab(2,fwCodename[mycode],'Name ');
 maxTab(3,fwReportCode,'Report Code ');
 maxTab(4,fwReportName,'Report Name ');
 case winView[wnSucode] of
  0: maxW:=CodeWidth*CodeFit;  {codes}
  1: maxW:=Tabs[2]+blankwidth;
  2: maxW:=Tabs[4]+blankwidth;
 end; {case}
 RedoSelection;
end;

procedure TSuWindow.PaintItem(i:integer;SelFlag:boolean);
var
 k:    integer;
begin
 k:=codepoint[i,mycode];
 case winView[wnSucode] of
   0: printw(subcode[k]);  {codes only}
   1: begin  {code + name}
        printw(subcode[k]);
        x:=Tabs[1]; printw(Subname[k]);
        x:=Tabs[2]; printw(GetSubjectFaculties(k));
      end;
   2: begin
        printw(subcode[k]);
        x:=Tabs[1]; printw(Subname[k]);
        x:=Tabs[2]; printw(SubReportCode[k]);
        x:=Tabs[3]; printw(SubReportName[k]);
        x:=Tabs[4]; printw(GetSubjectFaculties(k));
      end;
  end;
 fcolor(codecolor);
end;

procedure TSuWindow.PaintHead;
begin
 codeColor:=cpSub; {subject}
 {Headings}
  printw2('Subject Codes: ',inttostr(TotalCodes));
  printw2('  Sort: ',sortname[XML_DISPLAY.sorttype[mycode]]);
  printw2('  Code Length: ',inttostr(lencodes[mycode]));
  newline;
  if TotalCodes>0 then
    case winView[wnSucode] of
     1: begin  {code + name}
          fcolor(cpNormal); printwl('Code ');
          x:=Tabs[1]; printw('Name');
          x := Tabs[2]; printw('Faculties');
        end;
     2: begin  {code + name + report codes}
          fcolor(cpNormal); printwl('Code ');
          x:=Tabs[1]; printw('Name');
          x:=Tabs[2]; printw('Report Code');
          x:=Tabs[3]; printw('Report Name');
          x := Tabs[4]; printw('Faculties');
        end;
    end;
  newline;
end;

procedure TSuWindow.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action:= caFree;
end;

procedure TSuWindow.FormCreate(Sender: TObject);
begin
 setWindowDefaults(self,wnSuCode);
end;

procedure TSuWindow.FormResize(Sender: TObject);
begin
  Self.SetTabs;
  Refresh;
end;

procedure TSuWindow.PopupMenu1Popup(Sender: TObject);
begin
 view2.enabled:=(TotalCodes>0);
 add2.Enabled:= codeCount[mycode]<nmbrSubjects;
 delete2.Enabled:=(TotalCodes>0);
 change2.Enabled:=(TotalCodes>0);

 add2.Visible:=(usrPasslevel>utGen);
 change2.Visible:=(usrPasslevel>utGen);
 delete2.Visible:=(usrPasslevel>utGen);
 codelengths2.Visible:=(usrPasslevel>utGen);

end;

procedure TSuWindow.Codes1Click(Sender: TObject);
var
 hascodes:  boolean;
begin
  TickCodeSubMenu(SelectCode1);
  hascodes:=(TotalCodes>0);
  view1.enabled:=hascodes;
  add1.Enabled:=codeCount[mycode]<nmbrSubjects;
  delete1.enabled:=hascodes;
  change1.enabled:=hascodes;


 add1.Visible:=(usrPasslevel>utGen);
 change1.Visible:=(usrPasslevel>utGen);
 delete1.Visible:=(usrPasslevel>utGen);
 codelengths1.Visible:=(usrPasslevel>utGen);
 ReportCodes1.Visible:=(usrPasslevel>utGen);
end;

procedure TPrintSuWin.SetTabs;
begin
 setlength(PrntTabs,5);
 TotalCodes:=codeCount[mycode];
 CodeWidth:=fwPrntCode[mycode]+prntBlankwidth;
 maxTab(1,Codewidth,'Code');
 maxTab(2,fwPrntCodename[mycode],'Name ');
 maxTab(3,fwPrntReportCode,'Report Code ');
 maxTab(4,fwPrntReportName,'Report Name ');
 case winView[wnSucode] of
  0: CalcPrintCodeFit;  {codes}
  1,2: codefit:=1;
 end;
end;

procedure TPrintSuWin.head;
begin
 codeColor:=cpSub;
 UnderlineOn;
 printw2('Subject Codes: ',inttostr(codeCount[mycode]));
 printw2('  Sort: ',sortname[XML_DISPLAY.sorttype[mycode]]);
 printw2('  Code Length: ',inttostr(lencodes[mycode]));
 printw(PageCount);
 UnderlineOff;
 x:=0; y:=y+PrnttxtHeight;
 fcolor(cpNormal);
 case winView[wnSucode] of
   1:begin {codes + name}
      printwl('Code ');
      x:=prntTabs[1]; printw('Name');
     end;
    2:begin {report}
       printwl('Code ');
       x:=prntTabs[1]; printw('Name');
       x:=prntTabs[2]; printw('Report Code');
       x:=prntTabs[3]; printw('Report Name');
      end;
  end; {case}
 x:=0; y:=y+PrnttxtHeight;
 fcolor(codecolor);
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
          x := prntTabs[2]; printw(GetSubjectFaculties(k));
          newline;
         end;
      2: begin
           printw(subcode[k]);
           x:=prntTabs[1]; printw(Subname[k]);
           x:=prntTabs[2]; printw(SubReportCode[k]);
           x:=prntTabs[3]; printw(SubReportName[k]);
           x := prntTabs[4]; printw(GetSubjectFaculties(k));
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
 printLine(['Subject Codes: ',inttostr(codeCount[mycode]),' Sort: ',sortname[XML_DISPLAY.sorttype[mycode]],
     ' Code Length: ',inttostr(lencodes[mycode])]);
 newline;
  case winView[wnSucode] of
   1: printLine(['Code ','Name']);
   2: printLine(['Code ','Name','Report Code','Report Name']);
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
   Setup(codeCount[mycode]);
   if TotalCodes<=0 then exit;
   for i:=1 to TotalCodes do
    begin
     k:=codepoint[i,mycode];
     case winView[wnSucode] of
      0: PrintCode(i);
      1: printLine([subcode[k],subname[k], GetSubjectFaculties(k)]);
      2: printLine([subcode[k],subname[k],SubReportCode[k],SubReportName[k], GetSubjectFaculties(k)]);
     end;  {case}
    end;  {for i  to totalcodes}
    newline;
   printCustomAddon;
  finally; {with OutTeWin}
   OutSuWin.Free;
  end;
end; {main text output}

procedure TSuWindow.View1Click(Sender: TObject);
begin
 if ChangeCodeView(wnSucode,mycode) then UpdateWin;
end;

procedure TSuWindow.Add1Click(Sender: TObject);
begin
 if TooMany('subject codes',codeCount[0],nmbrSubjects) then exit;
 if CheckAccessRights(utStud,6,true) then
  begin
   addscodedlg:=Taddscodedlg.create(self); {allocate dlg}
   addscodedlg.showmodal;
   addscodedlg.free;  {release dlg}
  end;
 CheckAccessRights(utStud,6,false);
end;

procedure TSuWindow.BulkRenameSubjects(Sender: TObject);
var
  lFrmBulkRenameSubjects: TFrmBulkRenameSubjects;
begin
  lFrmBulkRenameSubjects := TFrmBulkRenameSubjects.Create(Application);
  try
    lFrmBulkRenameSubjects.SubjectToRename := Trim(SubCode[CodePoint[SelCode, MyCode]]);
    lFrmBulkRenameSubjects.ShowModal;
  finally
    FreeAndnil(lFrmBulkRenameSubjects);
  end;
end;

procedure TSuWindow.Change1Click(Sender: TObject);
begin
 if CheckAccessRights(utStud,6,true) then
  begin
   if NoCodesAvail1(mycode) then exit;
   edscodedlg:=Tedscodedlg.create(self);   {allocate dlg}
   edscodedlg.showmodal;
   edscodedlg.free;   {release dlg}
   CheckAccessRights(utStud,6,false);
  end;
end;

procedure TSuWindow.Delete1Click(Sender: TObject);
begin
 if CheckAccessRights(utStud,6,true) then
  begin
   if CheckAccessRights(utStud,14,true) then
    begin
     if NoCodesAvail(codeCount[mycode],'Subject codes') then exit;
     delscodedlg:=Tdelscodedlg.create(self);   {allocate dlg}
     delscodedlg.showmodal;
     delscodedlg.free;   {release dlg}
     CheckAccessRights(utStud,14,false)
    end;
   CheckAccessRights(utStud,6,false)
  end;
end;

procedure TSuWindow.Codelengths1Click(Sender: TObject);
begin
 if CheckAccessRights(utTime,6,true) then
   begin
    codelendlg:=Tcodelendlg.create(self);   {allocate dlg}
    codelendlg.tag:=wnSucode;
    codelendlg.showmodal;
    codelendlg.free;   {release dlg}
    CheckAccessRights(utTime,6,false)
   end;
end;

procedure TSuWindow.ReportCodes1Click(Sender: TObject);
begin
 if CheckAccessRights(utStud,6,true) then
  begin
   SubReportLendlg:=TSubReportLendlg.create(self);   {allocate dlg}
   SubReportLendlg.showmodal;
   SubReportLendlg.free;   {release dlg}
   CheckAccessRights(utStud,6,false);
  end;
end;

end.
