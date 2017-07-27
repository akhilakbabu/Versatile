unit TeWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls,TimeChartGlobals,ClassDefs, GlobalToTcAndTcextra,
  XML.DISPLAY, XML.TEACHERS;

type
  TTeWindow = class(TCodeWin)
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
    Timetable1: TMenuItem;
    procedure SelectCode1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure View1Click(Sender: TObject);
    procedure Add1Click(Sender: TObject);
    procedure Change1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure Codelengths1Click(Sender: TObject);
    procedure Codes1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure Timetable1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
  protected
    function MyCodePoint(i:integer): integer; override;
    procedure PaintItem(i:integer;SelFlag:boolean); override;
    procedure SetTabs; override;
    procedure PaintHead; override;
  end;


  procedure TeCodePrint;
  procedure TeCodeOut;
var
  TeWindow: TTeWindow;

implementation
 uses main,CodeView,addtcode,edtcode,deltcode,codelen,tcommon,tcommon2,DlgCommon,
      tcommon5, TETIMES;

{$R *.dfm}

 type TPrintTeWin=class(TPrintCodeWin)
  public
   procedure head; override;
   procedure SetTabs; override;
 end;

 type TOutTeWin=class(TOutCodeWin)
  public
   procedure head; override;
   function CodeToPrint(i:integer):string; override;
 end;

const
 mycode=1;
var
 PrintTeWin:    TPrintTeWin;
 OutTeWin:     TOutTeWin;

function TTeWindow.MyCodePoint(i:integer): integer;
begin
 result:=codepoint[i,mycode];
end;

procedure TTeWindow.setTabs;
var
 j:          integer;
begin
 setlength(Tabs,16);
 TotalCodes:=codeCount[mycode];
 headwidth:=canvas.textwidth('Teacher Codes: 99  Sort: Name  Code length: 8 ');
 CodeWidth:=fwCode[mycode]+blankWidth;
 CalcScreenCodeFit;

 maxTab(1,Codewidth,'Code');
 maxTab(2,fwCodename[mycode],'Name ');
 case winView[wnTecode] of
  0: maxW:=CodeWidth*CodeFit;  {codes}
  1: begin  {code + name}
      maxTab(3,0,'32000');
      for j:=4 to 7 do maxTab(j,fwFaculty,'');
      for j:=0 to 2 do
       begin {j}
        maxTab(8+j*2,fwTeDutyCode,'');
        maxTab(9+j*2,fwTeDutyLoad,'');
       end; {j}
      maxW:=Tabs[13]+blankwidth;
      Tabs[14]:=maxW;
     end;
 end; {case}
 ReDoSelection;
end;

procedure TTeWindow.PaintItem(i:integer;SelFlag:boolean);
var
 s: string;
 tmpInt,j,k:    integer;
begin
 k:=codepoint[i,mycode];

 case winView[wnTecode] of
   0: printw(XML_TEACHERS.tecode[k,0]);  {codes only}
   1: begin  {code + name}
       printw(XML_TEACHERS.tecode[k,0]);
       x:=Tabs[1]; printw(XML_TEACHERS.tename[k,0]);
       if XML_TEACHERS.Load[k]<0 then s:=inttostr(periods*days) else s:=inttostr(XML_TEACHERS.Load[k]);
       x:=Tabs[2]+canvas.textwidth('Load')-canvas.textwidth(s);
       printw(s);  topcolor(cpFac);
       for j:=1 to nmbrTeFacs do
        begin
         x:=Tabs[2+j];
         tmpInt:= XML_TEACHERS.Tfaculty[k,j];
         s:=getfacname(tmpInt);
         if (j=1) or (tmpInt>0) then printw(s);
        end;
       if not(SelFlag) then topcolor(codecolor);
       for j:=0 to 2 do
        begin
         x:=Tabs[7+2*j];
         if trim(XML_TEACHERS.dutycode[k,j])='' then printw('-') else printw(XML_TEACHERS.dutycode[k,j]);
         x:=Tabs[9+2*j]-Blankwidth;
         if XML_TEACHERS.dutyload[k,j]=0 then
          begin
           s:='0';
           x:=x- self.canvas.textwidth('0.0');
          end
         else
          begin
           str(XML_TEACHERS.dutyload[k,j]:4:1,s);  {leaves leading blanks}
           s:=trim(s);
           x:=x-self.canvas.textwidth(s);
          end;
         printw(s);
        end; {for j}
      end;

  end;
 fcolor(codecolor);
end;

procedure TTeWindow.PaintHead;
begin
 codeColor:=cpTeach; {teacher}
 {Headings}
  printw2('Teacher Codes: ',inttostr(TotalCodes));
  printw2('  Sort: ',sortname[XML_DISPLAY.sorttype[mycode]]);
  printw2('  Code Length: ',inttostr(lencodes[mycode]));
  newline;
  if TotalCodes>0 then
    case winView[wnTecode] of
     1: begin  {code + name}
          fcolor(cpNormal); printwl('Code ');
          x:=Tabs[1]; printw('Name');
          x:=Tabs[2]; printw('Load');
          x:=Tabs[3]; printw('Faculties');
          x:=Tabs[7]; printw('Duty Codes & Loads');
        end;
    end;
  newline;
end;

procedure TTeWindow.SelectCode1Click(Sender: TObject);
begin
 TickCodeSubMenu(SelectCode1);
end;

procedure TTeWindow.FormCreate(Sender: TObject);
begin
 setWindowDefaults(self,wnTeCode);
end;

procedure TTeWindow.FormResize(Sender: TObject);
begin
  Self.SetTabs;
  Refresh;
end;

procedure TTeWindow.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action:= caFree;
end;

procedure TTeWindow.View1Click(Sender: TObject);
begin
  if ChangeCodeView(wnTecode,mycode) then
  begin
    UpdateWin;
    if Assigned(TeacherTimes) then
       TeacherTimes.UpdateWin;
  end;
end;

procedure TTeWindow.Add1Click(Sender: TObject);
begin
 if TooMany('teacher codes',codeCount[1],nmbrTeachers) then exit;
 if CheckAccessRights(utTime,1,true) then
  begin
   addtcodedlg:=Taddtcodedlg.create(self); {allocate dlg}
   addtcodedlg.showmodal;
   addtcodedlg.free;  {release dlg}
  end;
 CheckAccessRights(utTime,1,false);
end;

procedure TTeWindow.Change1Click(Sender: TObject);
begin
 if CheckAccessRights(utTime,1,true) then
 begin
  if NoCodesAvail1(mycode) then exit;
  edtcodedlg:=Tedtcodedlg.create(self);    {allocate dlg}
  edtcodedlg.showmodal;
  edtcodedlg.free;     {release dlg}
  CheckAccessRights(utTime,1,false);
 end;
end;

procedure TTeWindow.Delete1Click(Sender: TObject);
begin
 if CheckAccessRights(utTime,1,true) then
  begin
   if NoCodesAvail(codeCount[mycode],'Teacher codes') then exit;
   deltcodedlg:=Tdeltcodedlg.create(self);  {allocate dlg}
   deltcodedlg.showmodal;
   deltcodedlg.free;   {release dlg}
   CheckAccessRights(utTime,1,false);
  end;
end;

procedure TTeWindow.Codelengths1Click(Sender: TObject);
begin
 if CheckAccessRights(utTime,1,true) then
 begin
  codelendlg:=Tcodelendlg.create(self);   {allocate dlg}
  codelendlg.tag:=tag;
  codelendlg.showmodal;
  codelendlg.free;   {release dlg}
  CheckAccessRights(utTime,1,false);
 end;
end;

procedure TTeWindow.Codes1Click(Sender: TObject);
var
 hascodes:  boolean;
begin
 TickCodeSubMenu(SelectCode1);
 add1.enabled:=(TotalCodes<nmbrTeachers);
 hascodes:=(TotalCodes>0);
 change1.enabled:=hascodes;
 delete1.enabled:=hascodes;
 view1.enabled:=hascodes;

 add1.Visible:=(usrPasslevel>utGen);
 change1.Visible:=(usrPasslevel>utGen);
 delete1.Visible:=(usrPasslevel>utGen);
 codelengths1.Visible:=(usrPasslevel>utGen);
end;

procedure TTeWindow.PopupMenu1Popup(Sender: TObject);
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

procedure TTeWindow.Timetable1Click(Sender: TObject);
begin
 XML_DISPLAY.tettselection[0]:=1;
 XML_DISPLAY.tettselection[1]:=codepoint[selcode,1];  {selection}
 XML_DISPLAY.tettlistvals[3]:=0;    {fac}
 XML_DISPLAY.tettseltype:=2; {selection}
 winView[wnTeacherTt]:=1; {weekly}
 teachttablewinselect;
 UpdateWindow(wnTeacherTt);
end;

procedure TPrintTeWin.SetTabs;
var
 j:          integer;
begin   {start of setprntTabs}
 setlength(PrntTabs,16);
 TotalCodes:=codeCount[mycode];
 CodeWidth:=fwPrntCode[mycode]+prntBlankwidth;
 maxTab(1,Codewidth,'Code');
 maxTab(2,fwPrntCodename[mycode],'Name ');
 case winView[wnTecode] of
 0: CalcPrintCodeFit;  {codes}
 1: begin  {code + name}
     codefit:=1;
     maxTab(3,0,'32000');
     for j:=4 to 7 do maxTab(j,fwPrntFaculty,'');
     for j:=0 to 2 do
      begin {j}
       maxTab(8+j*2,fwPrntTeDutyCode,'');
       maxTab(9+j*2,fwPrntTeDutyLoad,'');
      end; {j}
    end;
 end;
end;

procedure TPrintTeWin.head;
begin
 UnderlineOn;
 codeColor:=cpTeach; {teacher}
 printw2('Teacher Codes: ',inttostr(codeCount[mycode]));
 printw2('  Sort: ',sortname[XML_DISPLAY.sorttype[mycode]]);
 printw2('  Code Length: ',inttostr(lencodes[mycode]));
 printw(PageCount);
 UnderlineOff;
 x:=0; y:=y+PrnttxtHeight;
 fcolor(cpNormal);
  case winView[wnTecode] of
   1: begin {codes + name}
       printwl('Code ');
       x:=prntTabs[1]; printw('Name');
       x:=prntTabs[2]; printw('Load');
       x:=prntTabs[3]; printw('Faculties');
       x:=prntTabs[7]; printw('Duty Codes & Loads');
      end;

  end; {case}
 x:=0; y:=y+PrnttxtHeight;
end;

procedure TeCodePrint;
var
 s:            string;
 i,j,k,tmpInt: integer;

begin
 PrintTeWin:=TPrintTeWin.Create;
 with PrintTeWin do
  try
   PrintHead;
   if TotalCodes<=0 then exit;
   for i:=1 to TotalCodes do
    begin
     fcolor(codecolor);
     k:=codepoint[i,mycode];
     case winView[wnTecode] of
      0: begin
          printw(XML_TEACHERS.tecode[k,0]);
          x:=(i mod codefit)*CodeWidth;
          if (i mod codefit)=0 then newline;
         end;
      1: begin
          printw(XML_TEACHERS.tecode[k,0]);
          x:=prntTabs[1]; printw(XML_TEACHERS.tename[k,0]);
          if XML_TEACHERS.Load[k]<0 then s:=inttostr(periods*days) else s:=inttostr(XML_TEACHERS.Load[k]);
          x:=prntTabs[2]+PrintCanvas.textwidth('Load')-PrintCanvas.textwidth(s);
          printw(s);  fcolor(cpFac);
          for j:=1 to nmbrTeFacs do
           begin
            x:=prntTabs[2+j];
            tmpInt:= XML_TEACHERS.Tfaculty[k,j];
            s:=getfacname(tmpInt);
            if (j=1) or (tmpInt>0) then printw(s);
           end;
          fcolor(codecolor);
          for j:=0 to 2 do
           begin
            x:=prntTabs[7+2*j];
            if trim(XML_TEACHERS.dutycode[k,j])='' then printw('-') else printw(XML_TEACHERS.dutycode[k,j]);
            x:=prntTabs[9+2*j]-prntBlankwidth;
            if XML_TEACHERS.dutyload[k,j]=0 then
             begin
               s:='0';
               x:=x-PrintCanvas.textwidth('0.0');
             end
            else
             begin
               str(XML_TEACHERS.dutyload[k,j]:4:1,s);  {leaves leading blanks}
               s:=trim(s);
               x:=x-PrintCanvas.textwidth(s);
              end;
            printw(s);
           end; {for j}
          newline;
         end;

     end;  {case}
    end;  {for i  to totalcodes}
    newline;
   printCustomAddon;
  finally; {with PrintTeWin}
   PrintTeWin.Free;
  end;
end; {main print}

procedure TOutTeWin.head;
begin
 printLine(['Teacher Codes: ',inttostr(codeCount[mycode]),' Sort: ',sortname[XML_DISPLAY.sorttype[mycode]],
     ' Code Length: ',inttostr(lencodes[mycode])]);
 newline;
  case winView[wnTecode] of
   1: begin {codes + name}
       printLine(['Code ','Name','Load','Faculties','','','','Duty Codes & Loads']);
      end;
  end; {case}
 newline;
end;

function TOutTeWin.CodeToPrint(i:integer):string;
begin
 result:=XML_TEACHERS.tecode[codepoint[i,mycode],0];
end;

procedure TeCodeOut;
var
 s:            string;
 i,j,k,tmpInt: integer;

begin
 OutTeWin:=TOutTeWin.Create;
 with OutTeWin do
  try
   Setup(codeCount[mycode]);
   if TotalCodes<=0 then exit;
   for i:=1 to TotalCodes do
    begin
     k:=codepoint[i,mycode];
     case winView[wnTecode] of
      0: PrintCode(i);
      1: begin
          printw(XML_TEACHERS.tecode[k,0]);
          printc(XML_TEACHERS.tename[k,0]);
          if XML_TEACHERS.Load[k]<0 then s:=inttostr(periods*days) else s:=inttostr(XML_TEACHERS.Load[k]);
          printc(s);
          for j:=1 to nmbrTeFacs do
           begin
            tmpInt:= XML_TEACHERS.Tfaculty[k,j];
            s:='';
            if (j=1) or (tmpInt>0) then s:=getfacname(tmpInt);
            printc(s);
           end;
          for j:=0 to 2 do
           begin
            if trim(XML_TEACHERS.dutycode[k,j])='' then printc('-') else printc(XML_TEACHERS.dutycode[k,j]);
            if XML_TEACHERS.dutyload[k,j]=0 then s:='0'
            else
             begin
               str(XML_TEACHERS.dutyload[k,j]:4:1,s);  {leaves leading blanks}
               s:=trim(s);
              end;
            printc(s);
           end; {for j}
          newline;
         end;

     end;  {case}
    end;  {for i  to totalcodes}
    newline;
   printCustomAddon;
  finally; {with OutTeWin}
   OutTeWin.Free;
  end;
end; {main text output}

end.
