unit RoWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls,TimeChartGlobals,ClassDefs,printers, XML.DISPLAY, XML.TEACHERS;

type
  TRoWindow = class(TCodeWin)
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
    N4: TMenuItem;
    View1: TMenuItem;
    Codelengths1: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure Codes1Click(Sender: TObject);
    procedure View1Click(Sender: TObject);
    procedure Add1Click(Sender: TObject);
    procedure Change1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure Codelengths1Click(Sender: TObject);
    procedure Timetable1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
  protected
    procedure PaintItem(i:integer;SelFlag:boolean); override;
    procedure SetTabs; override;
    procedure PaintHead; override;
    function MyCodePoint(i:integer): integer; override;
  end;

 procedure RoCodePrint;
 procedure RoCodeOut;


 var
  RoWindow: TRoWindow;

implementation
 uses main,CodeView,tcommon,tcommon2,DlgCommon,
      addrcode,edrcode,delrcode,codelen,tcommon5;
{$R *.dfm}

 type TPrintRoWin=class(TPrintCodeWin)
  public
   procedure head; override;
   procedure SetTabs; override;
 end;

 type TOutRoWin=class(TOutCodeWin)
  public
   procedure head; override;
   function CodeToPrint(i:integer):string; override;
 end;


const
 mycode=2;
var
 PrintRoWin:    TPrintRoWin;
 OutRoWin:      TOutRoWin;
 AssignCol: integer;

function TRoWindow.MyCodePoint(i:integer): integer;
begin
 result:=codepoint[i,mycode];
end;


procedure TRoWindow.setTabs;
var
 j: integer;
begin
 setlength(Tabs,9);
 TotalCodes:=codeCount[mycode];
 headwidth:=canvas.textwidth('Room Codes: 99  Sort: Name  Code length: 8 ');
 CodeWidth:=fwCode[mycode]+blankWidth;
 CalcScreenCodeFit;

 maxTab(1,Codewidth,'Code');
 maxTab(2,fwCodename[mycode],'Name ');
 case winView[wnRocode] of
  0: maxW:=CodeWidth*CodeFit;  {codes}
  1: begin
      maxTab(3,0,'Capacity ');
      j:=fwCode[0]; if fwCode[1]>j then j:=fwCode[1];
      if fwFaculty>j then j:=fwFaculty;
      maxTab(4,j,'Timetable ');
      for j:=5 to 7 do maxTab(j,fwFaculty,'');
      maxW:=Tabs[7]+blankwidth;
      Tabs[8]:=maxW;
     end;
 end; {case}
 RedoSelection;
end;

function AssignShow(k: integer): string;
var
 s: string;
begin
 s:=''; AssignCol:=cpRoom;
 case Rotype[k] of
  0: begin s:='None'; AssignCol:=cpClass; end;
  1: begin s:=wildSub(Rassign[k]); AssignCol:=cpSub; end;
  2: begin s:=XML_TEACHERS.TeCode[Rassign[k],0]; AssignCol:=cpTeach; end;
  3: begin s:=FacName[Rassign[k]];  AssignCol:=cpFac; end;
  4: begin s:='Timetable'; AssignCol:=cpNormal; end;
 end;
 result:=s;
end;

procedure TRoWindow.PaintItem(i:integer;SelFlag:boolean);
var
 k,tmpInt:    integer;
 s:    string;
begin
 k:=codepoint[i,mycode];
 case winView[wnRocode] of
   0: printw(XML_TEACHERS.tecode[k,1]);  {codes only}
   1: begin  {code + name}
       topcolor(codecolor);
       printw(XML_TEACHERS.tecode[k,1]);
       x:=Tabs[1]; printw(XML_TEACHERS.Tename[k,1]);
       s:=inttostr(XML_TEACHERS.RoSize[k]);
       x:=Tabs[2]+canvas.textwidth('Sizw')-canvas.textwidth(s);
       printw(s);
       x:=Tabs[3];  s:=AssignShow(k);
       topcolor(AssignCol); printw(s); topcolor(cpFac);
       x:=Tabs[4]; s:=getfacname(XML_TEACHERS.Rfaculty[k,1]); printw(s);
       x:=Tabs[5]; tmpInt:= XML_TEACHERS.Rfaculty[k,2];
       if(tmpInt>0) then printw(getfacName(tmpInt));
       x:=Tabs[6]; tmpInt:= XML_TEACHERS.Rfaculty[k,3];
       if(tmpInt>0) then printw(getfacName(tmpInt));
      end;
  end;
 fcolor(codecolor);
end;

procedure TRoWindow.PaintHead;
begin
 codeColor:=cpRoom;
 printw2('Room Codes: ',inttostr(TotalCodes));
 printw2('  Sort: ',sortname[XML_DISPLAY.sorttype[mycode]]);
 printw2('  Code Length: ',inttostr(lencodes[mycode]));
 newline;
 if TotalCodes>0 then
   case winView[wnRocode] of
    1: begin  {code + name}
        fcolor(cpNormal); printwl('Code ');
        x:=Tabs[1]; printw('Name');
        x:=Tabs[2]; printw('Capacity');
        x:=Tabs[3]; printw('Assign');
        x:=Tabs[4]; printw('Faculties');
       end;

   end;
 newline;
end;

procedure TRoWindow.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action:= caFree;
end;

procedure TRoWindow.FormCreate(Sender: TObject);
begin
 setWindowDefaults(self,wnRoCode);
end;

procedure TRoWindow.FormResize(Sender: TObject);
begin
  Self.SetTabs;
  Refresh;
end;

procedure TRoWindow.PopupMenu1Popup(Sender: TObject);
var
 hascodes:  boolean;
begin
 add2.enabled:=(TotalCodes<nmbrTeachers);
 hascodes:=(TotalCodes>0);
 change2.enabled:=hascodes;
 delete2.enabled:=hascodes;
 view2.enabled:=hascodes;
 timetable1.visible:=(selcode>0);

 add2.Visible:=(usrPasslevel>utGen);
 change2.Visible:=(usrPasslevel>utGen);
 delete2.Visible:=(usrPasslevel>utGen);
 codelengths2.Visible:=(usrPasslevel>utGen);
end;

procedure TRoWindow.Codes1Click(Sender: TObject);
var
 hascodes:  boolean;
begin
 TickCodeSubMenu(SelectCode1);
 hascodes:=(TotalCodes>0);
 add1.enabled:=(TotalCodes<nmbrTeachers);
 change1.enabled:=hascodes;
 delete1.enabled:=hascodes;
 view1.enabled:=hascodes;

 add1.Visible:=(usrPasslevel>utGen);
 change1.Visible:=(usrPasslevel>utGen);
 delete1.Visible:=(usrPasslevel>utGen);
 codelengths1.Visible:=(usrPasslevel>utGen);
end;

procedure TPrintRoWin.SetTabs;
var
 j: integer;
begin
 setlength(PrntTabs,9);
 TotalCodes:=codeCount[mycode];
 CodeWidth:=fwPrntCode[mycode]+prntBlankwidth;
 maxTab(1,Codewidth,'Code');
 maxTab(2,fwPrntCodename[mycode],'Name ');
 case winView[wnRocode] of
 0: CalcPrintCodeFit;  {codes}
 1: begin
     codefit:=1;
     maxTab(3,0,'Capacity ');
     j:=fwPrntCode[0]; if fwPrntCode[1]>j then j:=fwPrntCode[1];
      if fwPrntFaculty>j then j:=fwPrntFaculty;
      maxTab(4,j,'Timetable ');
     for j:=5 to 7 do maxTab(j,fwPrntFaculty,'');
    end;
 end;
end;

procedure TPrintRoWin.head;
begin
 codeColor:=cpRoom;
 UnderlineOn;
 printw2('Room Codes: ',inttostr(codeCount[mycode]));
 printw2('  Sort: ',sortname[XML_DISPLAY.sorttype[mycode]]);
 printw2('  Code Length: ',inttostr(lencodes[mycode]));
 printw(PageCount);
 UnderlineOff;
 x:=0; y:=y+PrnttxtHeight;
 fcolor(cpNormal);
 if winView[wnRocode]=1 then
   begin {codes + name}
     printwl('Code ');
     x:=prntTabs[1]; printw('Name');
     x:=prntTabs[2]; printw('Capacity');
     x:=prntTabs[3]; printw('Assign');
     x:=prntTabs[4]; printw('Faculties');
   end;
 x:=0; y:=y+PrnttxtHeight;
 fcolor(codecolor);
end;



procedure RoCodePrint;
var
 i,k,tmpInt: integer;
 s: string;
begin
 PrintRoWin:=TPrintRoWin.Create;
 with PrintRoWin do
  try
   PrintHead;
   if TotalCodes<=0 then exit;
   for i:=1 to TotalCodes do
    begin
     k:=codepoint[i,mycode];
     case winView[wnRocode] of
      0: begin
          printw(XML_TEACHERS.tecode[k,1]);
          x:=(i mod codefit)*CodeWidth;
          if (i mod codefit)=0 then newline;
         end;
      1: begin
          fcolor(codecolor); printw(XML_TEACHERS.tecode[k,1]);
          x:=prntTabs[1]; printw(XML_TEACHERS.tename[k,1]);
          s:=inttostr(XML_TEACHERS.RoSize[k]);
          x:=prntTabs[2]+PrintCanvas.textwidth('Size')-PrintCanvas.textwidth(s);
          printw(s);
          x:=prntTabs[3];  s:=AssignShow(k);
          fcolor(AssignCol); printw(s); fcolor(cpFac);
          x:=prntTabs[4]; s:=getfacname(XML_TEACHERS.Rfaculty[k,1]); printw(s);
          x:=prntTabs[5]; tmpInt:= XML_TEACHERS.Rfaculty[k,2];
           if(tmpInt>0) then printw(getfacName(tmpInt));
          x:=prntTabs[6]; tmpInt:= XML_TEACHERS.Rfaculty[k,3];
           if(tmpInt>0) then printw(getfacName(tmpInt));
          newline;
         end;

     end;  {case}
    end;  {for i  to totalcodes}
    newline;
   printCustomAddon;
  finally; {with PrintTeWin}
   PrintRoWin.Free;
  end;
end; {main print}


procedure TOutRoWin.head;
begin
 printLine(['Room Codes: ',inttostr(codeCount[mycode]),' Sort: ',sortname[XML_DISPLAY.sorttype[mycode]],
     ' Code Length: ',inttostr(lencodes[mycode])]);
 newline;
  case winView[wnRocode] of
   1: begin {codes + name}
       printLine(['Code ','Name','Capacity','Assign','Faculties']);
      end;
  end; 
 newline;
end;

function TOutRoWin.CodeToPrint(i:integer):string;
begin
 result:=XML_TEACHERS.tecode[codepoint[i,mycode],1];
end;


procedure RoCodeOut;
var
 i,k,tmpInt: integer;
 s: string;
begin
 OutRoWin:=TOutRoWin.Create;
 with OutRoWin do
  try
   Setup(codeCount[mycode]);
   if TotalCodes<=0 then exit;
   for i:=1 to TotalCodes do
    begin
     k:=codepoint[i,mycode];
     case winView[wnRocode] of
      0: PrintCode(i);
      1: begin
          printw(XML_TEACHERS.tecode[k,1]);
          printc(XML_TEACHERS.tename[k,1]);
          s:=inttostr(XML_TEACHERS.RoSize[k]); printc(s);
          s:=AssignShow(k);  printc(s);
          s:=getfacname(XML_TEACHERS.Rfaculty[k,1]);printc(s);
          s:=''; tmpInt:= XML_TEACHERS.Rfaculty[k,2]; if(tmpInt>0) then s:=getfacName(tmpInt);
          printc(s);
          s:=''; tmpInt:= XML_TEACHERS.Rfaculty[k,3]; if(tmpInt>0) then s:=getfacName(tmpInt);
          printc(s);
          newline;
         end;
     end;  {case}
    end;  {for i  to totalcodes}
    newline;
   printCustomAddon;
  finally; {with OutTeWin}
   OutRoWin.Free;
  end;
end; {main text output}



procedure TRoWindow.View1Click(Sender: TObject);
begin
 if ChangeCodeView(wnRocode,mycode) then UpdateWin;
end;

procedure TRoWindow.Add1Click(Sender: TObject);
begin
 if TooMany('room codes',codeCount[2],nmbrRooms) then exit;
 if CheckAccessRights(utTime,2,true) then
  begin
   addrcodedlg:=Taddrcodedlg.create(self); {allocate dlg}
   addrcodedlg.showmodal;
   addrcodedlg.free;  {release dlg}
  end;
 CheckAccessRights(utTime,2,false);
end;

procedure TRoWindow.Change1Click(Sender: TObject);
begin
 if CheckAccessRights(utTime,2,true) then
 begin
  if NoCodesAvail1(mycode) then exit;
  edrcodedlg:=Tedrcodedlg.create(self);  {allocate dlg}
  edrcodedlg.showmodal;
  edrcodedlg.free;    {release dlg}
  CheckAccessRights(utTime,2,false);
 end;
end;

procedure TRoWindow.Delete1Click(Sender: TObject);
begin
 if CheckAccessRights(utTime,2,true) then
  begin
   if NoCodesAvail(codeCount[mycode],'Room codes') then exit;
   delrcodedlg:=Tdelrcodedlg.create(self);  {allocate dlg}
   delrcodedlg.showmodal;
   delrcodedlg.free;    {release dlg}
   CheckAccessRights(utTime,2,false);
  end;
end;

procedure TRoWindow.Codelengths1Click(Sender: TObject);
begin
 if CheckAccessRights(utTime,2,true) then
 begin
  codelendlg:=Tcodelendlg.create(self);   {allocate dlg}
  codelendlg.tag:=tag;
  codelendlg.showmodal;
  codelendlg.free;   {release dlg}
  CheckAccessRights(utTime,2,false);
 end;  
end;

procedure TRoWindow.Timetable1Click(Sender: TObject);
begin
 XML_DISPLAY.rottselection[0]:=1;
 XML_DISPLAY.rottselection[1]:=codepoint[selcode,2];  {selection}
 XML_DISPLAY.rottlistvals[3]:=0;    {fac}
 XML_DISPLAY.rottseltype:=2; {selection}
 winView[wnRoomTt]:=1; {weekly}
 roomttablewinselect;
 UpdateWindow(wnRoomTt);
end;

end.
