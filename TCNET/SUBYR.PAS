unit Subyr;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Menus, StdCtrls, ExtCtrls,TimeChartGlobals,ClassDefs, XML.DISPLAY, XML.STUDENTS;

type
  TSubyearwin = class(TCodeWin)
    MainMenu1: TMainMenu;
    YearSubMenu: TMenuItem;
    Replace1: TMenuItem;
    Remove1: TMenuItem;
    popupmenu1: TPopupMenu;
    Replace2: TMenuItem;
    Remove2: TMenuItem;
    N6: TMenuItem;
    PrintSetup2: TMenuItem;
    Print2: TMenuItem;
    showSublist1: TMenuItem;
    Exportastextfile1: TMenuItem;
    popCopySubject: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Replace2Click(Sender: TObject);
    procedure Remove2Click(Sender: TObject);
    procedure popupmenu1Popup(Sender: TObject);
    procedure YearSubMenuClick(Sender: TObject);
    procedure showSublist1Click(Sender: TObject);
    procedure CopySubjectToClipboard(Sender: TObject);
    procedure FormResize(Sender: TObject);
   protected
    procedure PaintItem(i:integer;SelFlag:boolean); override;
    procedure SetTabs; override;
    procedure PaintHead; override;
  private
    function CalcFormCodeFit: Integer;
  end;

  procedure Subyearprint;
  procedure SubyearOut;

var
  Subyearwin:           TSubyearwin;


implementation
uses main,tcommon,DlgCommon,StCommon,delyrsub,repyrsub,printers,
     margins,tcommon2,tcommon5;

type TPrintGrSubsWin=class(TPrintCodeWin)
  public
   procedure head; override;
   procedure SetTabs; override;
 end;

 type TOutGrSubsWin=class(TOutCodeWin)
  public
   procedure head; override;
   function CodeToPrint(i:integer):string; override;
 end;

const
 mycode=0;

var
  PrintGrSubsWin: TPrintGrSubsWin;
  OutGrSubsWin:  TOutGrSubsWin;
  NumSubYearDisp,countdigits: smallint;
  tabN,PrntTabN: integer;
{$R *.DFM}


procedure updateSubYearDisp;
var
 i,j:       smallint;
begin
 j:=0;
 for i:=1 to GroupSubs[0] do
  if BlockTop[i]>0 then
  begin
   inc(j);
   SubYearDisp[j]:=i;
  end;
 NumSubYearDisp:=j;
end;



procedure TSubyearwin.setTabs;
begin
 setlength(Tabs,5);
 updateSubYearDisp;
 CountGroupSubs;
 TotalCodes:=NumSubYearDisp;
 caption:='Group Subjects'+GroupCaption;
 headwidth:=canvas.textwidth('Not allocated:2000     In blocks:2000     Total:2000 ');
 CodeWidth:=fwCode[mycode]+canvas.textwidth(inttostr(groupnum))+3*blankWidth;
 CalcFormCodeFit;
 countdigits:=2;
 if groupnum>99 then countdigits:=3;
 if groupnum>999 then countdigits:=4;
 tabN:=canvas.textwidth('9999');
 maxTab(1,Codewidth,'Code');
 maxTab(2,fwCodename[mycode],'Name ');
 maxTab(3,0,'Count');
 maxTab(4,0,'Maximum');
 case winView[wnGroupSub] of
  0: maxW:=CodeWidth*CodeFit;  {codes}
  1: maxW:=Tabs[4]+blankwidth;
 end; {case}
end;

procedure TSubyearwin.PaintItem(i:integer;SelFlag:boolean);
var
 j,k,MyMax:    integer;
 mycount: string;

      procedure AdjustPrint(n:integer);
      begin
       x:=x+tabN-canvas.textwidth(inttostr(n));
       printw(inttostr(n));
      end;

begin
 j:=SubYearDisp[i];
 k:=GroupSubs[j];
 str(GroupSubCount[j]:countdigits,mycount);
 case winView[wnGroupSub] of
   0: begin
       printwl(subcode[k]);
       topcolor(cpFac);
       printw(mycount);
      end;
   1: begin  {code + name}
        printw(subcode[k]);
        x:=Tabs[1]; printw(Subname[k]);
        MyMax:=GetClassMax(k);
        if (MyMax<GroupsubCount[j])then topcolor(cpDouble) else topcolor(cpFac);
        x:=Tabs[2]; AdjustPrint(GroupsubCount[j]);  topcolor(cpFac);
        x:=Tabs[3]; AdjustPrint(MyMax);
      end;
  end;
 fcolor(codecolor);
end;

procedure TSubyearwin.PaintHead;
begin
 codeColor:=cpSub; {subject}
 printw2('Not allocated:',inttostr(TotalCodes));
 printw2('     In blocks:',inttostr(GroupSubs[0]-TotalCodes));
 printw2('     Total:',inttostr(GroupSubs[0]));
 newline;
  if TotalCodes>0 then
    case winView[wnGroupSub] of
     1: begin  {code + name}
          fcolor(cpNormal); printwl('Code ');
          x:=Tabs[1]; printw('Name');
          x:=Tabs[2]; printw('Count');
          x:=Tabs[3]; printw('Maximum');
        end;
    end;
  newline;
end;

function TSubyearwin.CalcFormCodeFit: Integer;
//This routine needs to be inlined later with CalcScreenCodeFit routine
var
  tmpInt: Integer;
begin
  if CodeWidth > 0 then
  begin
    tmpInt := Trunc(Self.Clientwidth);
    CodeFit := tmpInt div CodeWidth;
    if CodeFit > TotalCodes then
      CodeFit := TotalCodes;
    if Codefit = 0 then Codefit := 1;
    if winView[tag] > 0 then
      Codefit := 1;
    maxH := txtheight * ((TotalCodes div CodeFit) + 5)
  end;
end;

procedure TSubyearwin.CopySubjectToClipboard(Sender: TObject);
var
  aStr: string;

  function GetStr(pInt: Integer): string;
  var
    j, k: Integer;
    mycount: string;
  begin
    j := SubYearDisp[pInt];
    k := GroupSubs[j];
    str(GroupSubCount[j]:4, mycount);
    Result := Subcode[k] + ' ' + mycount;
  end;
begin
  aStr := GetStr(Subyearwin.selcode);
  genText := aStr + Chr(0);
end;

procedure TSubyearwin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action:=caFree;
 if fRemSubyrDlgUp then {release dlg if still up}
 begin
  delyrsubdlg.free;
  fRemSubyrDlgUp:=false;
 end;
end;


procedure TSubyearwin.FormCreate(Sender: TObject);
begin
 setWindowDefaults(self,wnGroupSub);
end;

procedure TSubyearwin.Replace2Click(Sender: TObject);
begin
 if CheckAccessRights(utStud,36,true) then
 begin
  repysdlg:=Trepysdlg.create(self);   {allocate dlg}
  repysdlg.showmodal;
  repysdlg.free;   {release dlg}
  CheckAccessRights(utStud,36,false);
 end;
end;


procedure TSubyearwin.Remove2Click(Sender: TObject);
begin
 if CheckAccessRights(utStud,36,true) then
  begin
   if NoCodesAvail(GroupSubs[0],'Group Subject Codes') then exit;
   if not(fRemSubyrDlgUp) then
    begin
     delyrsubdlg:=Tdelyrsubdlg.create(self);   {allocate dlg}
     fRemSubyrDlgUp:=true;
    end;
   delyrsubdlg.caption:='Remove Group Subject'+GroupCaption;
   delyrsubdlg.show;
  end;
end;

procedure TSubyearwin.popupmenu1Popup(Sender: TObject);
var
 hascodes: boolean;
begin
 hascodes:=(GroupSubs[0]>0);
 replace2.Enabled:=hascodes;
 remove2.Enabled:=hascodes;
 showsublist1.visible:=(GroupSubCount[selcode]>0);
end;

procedure TSubyearwin.FormResize(Sender: TObject);
begin
  //CalcFormCodeFit;
  Self.SetTabs;
  Self.Refresh;
end;

{------------- printing routines ----------------------------}


procedure TPrintGrSubsWin.SetTabs;
begin
 setlength(PrntTabs,5);
 TotalCodes:=NumSubYearDisp;
 CodeWidth:=fwPrntCode[mycode]+Printcanvas.textwidth(inttostr(XML_STUDENTS.numstud)+' ')+blankWidth;
 PrntTabN:=Printcanvas.textwidth('9999');
 maxTab(1,Codewidth,'Code');
 maxTab(2,fwPrntCodename[mycode],'Name ');
 maxTab(3,0,'Count');
 maxTab(4,0,'Maximum');
 case winView[wnGroupSub] of
  0: CalcPrintCodeFit;  {codes}
  1: codefit:=1;
 end;
end;

procedure TPrintGrSubsWin.head;
begin
 codeColor:=cpSub;
 UnderlineOn;
 printw('Group Subjects'+GroupCaption);
 x:=0; y:=y+PrnttxtHeight;
 printw2('Not allocated:',inttostr(TotalCodes));
 printw2('     In blocks:',inttostr(GroupSubs[0]-TotalCodes));
 printw2('     Total:',inttostr(GroupSubs[0]));
 printw(PageCount);
 UnderlineOff;
 x:=0; y:=y+PrnttxtHeight;
 fcolor(cpNormal);
 if TotalCodes>0 then
  if winView[wnGroupSub]=1 then
   begin {codes + name}
     fcolor(cpNormal); printwl('Code ');
     x:=prntTabs[1]; printw('Name');
     x:=prntTabs[2]; printw('Count');
     x:=prntTabs[3]; printw('Maximum');
    end;
 x:=0; y:=y+PrnttxtHeight;
end;


procedure Subyearprint;
var
 i,j,k,MyMax: integer;
 mycount: string;

     procedure AdjustPrint(n:integer);
      begin
       with PrintGrSubsWin do
        begin
         x:=x+PrntTabN-PrintCanvas.textwidth(inttostr(n));
         printw(inttostr(n));
        end;
      end;

begin
 PrintGrSubsWin:=TPrintGrSubsWin.Create;
 with PrintGrSubsWin do
  try
   PrintHead;
   if TotalCodes<=0 then exit;
   for i:=1 to TotalCodes do
    begin
     j:=SubYearDisp[i];
     k:=GroupSubs[j];
     str(GroupSubCount[j]:countdigits,mycount);
     case winView[wnGroupSub] of
      0: begin
          printwl(Subcode[k]);
          fcolor(cpFac); printw(mycount);
          x:=(i mod codefit)*CodeWidth;
          if (i mod codefit)=0 then newline;
         end;
      1: begin
          printw(Subcode[k]);
          x:=prntTabs[1]; printw(subname[k]);
          MyMax:=GetClassMax(k);
          if (MyMax<GroupsubCount[j])then fcolor(cpDouble) else fcolor(cpFac);
          x:=prntTabs[2]; AdjustPrint(GroupsubCount[j]);  fcolor(cpFac);
          x:=prntTabs[3]; AdjustPrint(GetClassMax(k));
          newline;
         end;
     end;  {case}
     fcolor(codecolor);
    end;  {for i  to totalcodes}
    newline;
   printCustomAddon;
  finally; {with PrintGrSubsWin}
   PrintGrSubsWin.Free;
  end;
end; {main print}



procedure TSubyearwin.YearSubMenuClick(Sender: TObject);
begin
 replace1.enabled:=(GroupSubs[0]>0);
 remove1.enabled:=replace1.enabled;
end;

procedure TSubyearwin.showSublist1Click(Sender: TObject);
begin
 if selcode>0 then
 begin
  XML_DISPLAY.SubListType:=2;
  XML_DISPLAY.sublistRanges[-2]:=GroupSubs[SubYearDisp[self.selcode]];
  XML_DISPLAY.sublistRanges[-1]:=GroupSubs[SubYearDisp[self.selcode]];
  XML_DISPLAY.sublistRanges[0]:=0;
  XML_DISPLAY.sublistfacnum:=0;
  SubListWinSelect;
  UpdateWindow(wnSubjectList);
 end;
end;


procedure TOutGrSubsWin.head;
begin
 printLine(['Group Subjects'+GroupCaption]);
 printLine(['Not allocated: ',inttostr(NumSubYearDisp),'In blocks: ',inttostr(GroupSubs[0]-NumSubYearDisp),
     'Total: ',inttostr(GroupSubs[0])]);
 newline;
  case winView[wnGroupSub] of
   1: begin {codes + name}
       printLine(['Code ','Name','Count','Maximum']);
      end;
  end; {case}
 newline;
end;

function TOutGrSubsWin.CodeToPrint(i:integer):string;
var
 j,k: integer;
 mycount: string;
begin
 j:=SubYearDisp[i];
 k:=GroupSubs[j];
 str(GroupSubCount[j]:4,mycount);
 result:=Subcode[k]+' '+mycount;
end;

procedure SubyearOut;
var
 i,j,k: integer;
 mycount,mymax: string;
begin
 OutGrSubsWin:=TOutGrSubsWin.Create;
 with OutGrSubsWin do
  try
   Setup(codeCount[mycode]);
   if NumSubYearDisp<=0 then exit;
   for i:=1 to NumSubYearDisp do
    begin
     j:=SubYearDisp[i];
     k:=GroupSubs[j];
     mycount:=inttostr(GroupSubCount[j]);
     mymax:=inttostr(GetClassMax(k));
     str(GroupSubCount[j]:4,mycount);
     case winView[wnGroupSub] of
      0: PrintCode(i);
      1: printLine([subcode[k],subname[k],mycount,mymax]);
     end;  {case}
    end;  {for i  to totalcodes}
    newline;
   printCustomAddon;
  finally; {with OutGrSubsWin}
   OutGrSubsWin.Free;
  end;
end; {main text output}


end.

