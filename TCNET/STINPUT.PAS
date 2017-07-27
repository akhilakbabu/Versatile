unit Stinput;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Menus, ExtCtrls, StBarC, StdCtrls, TimeChartGlobals,
  ClassDefs, XML.DISPLAY, XML.TEACHERS, XML.STUDENTS;

type
  TStuinput = class(TListWin)
    PopupMenu1: TPopupMenu;
    Selection2: TMenuItem;
    N2: TMenuItem;
    PrintSetup1: TMenuItem;
    Print1: TMenuItem;
    Exportastextfile1: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Selection2Click(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
   protected
    procedure SetTabs; override;
    procedure GetLists; override;
    procedure GetListContents(i: integer); override;
   private
    barboxsz:            integer;
    StHeight,lineLen,HeadHeight: integer;
    CodeFit: smallint;
    procedure PrintSections;
    procedure PrintBarCodes;
    procedure printx(a: string);
    procedure displayStudent(i: integer);
    procedure printform(stI: integer);
    procedure PrintFormHead(stI: integer);
    procedure ListHead(i:integer);
  end;
var
  Stuinput: TStuinput;

procedure Stuinputprint;
procedure Stuinputtext;

implementation
uses tcommon,StCommon,main,stindlg,printers,tcommon2;
{$R *.DFM}

type TPrintStInputWin=class(TPrintListWin)
  public
   procedure head; override;
   procedure SetTabs; override;
   procedure GetLists; override;
   procedure GetListContents(i: integer); override;
  private
   vlines,DescLines: integer;
   barboxsz:            integer;
   StHeight,lineLen,HeadHeight: integer;
   CodeFit: smallint;
   procedure PrintSections;
   procedure PrintBarCodes;
   procedure printx(a: string);
   procedure displayStudent(i: integer);
   procedure printform(stI: integer);
   procedure PrintFormHead(stI: integer);
   procedure ListHead(i:integer);
 end;

 type TOutStInputWin=class(TOutListWin)
  public
   procedure head; override;
   procedure GetLists; override;
   procedure GetListContents(i: integer); override;
  private
   procedure PrintSections;
   procedure PrintFormHead(stI: integer);
   procedure printform(stI: integer);
   procedure ListHead(i:integer);
 end;

var
 PrintStInputWin: TPrintStInputWin;
 OutStInputWin: TOutStInputWin;
 UseBarCodes: Boolean;



procedure TStuinput.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 XML_DISPLAY.StudentInputShow1:=winView[wnStInput];
 action:=cafree;
 StBarCode1.Free;
end;

procedure TStuinput.FormCreate(Sender: TObject);
begin
 setWindowDefaults(self,wnStInput);
 winView[wnStInput]:=XML_DISPLAY.StudentInputShow1;
 rangeCheckStudSels(XML_DISPLAY.StudentInputSelection);
 BarcodeMake;
end;

procedure TStuinput.Selection2Click(Sender: TObject);
begin
 studentinputdlg:=Tstudentinputdlg.create(self);   {allocate dlg}
 studentinputdlg.showmodal;
 studentinputdlg.free;
end;

procedure TStuinput.ListHead(i:integer);
begin
 fcolor(cpNormal);
  newline; newline;
 case XML_DISPLAY.StudentInputShow2 of
  1:printw('Selected Students');
  2:printw('Student Group '+GroupCaption);
  3:printw('Class '+ClassCode[ListSet[i]]);
  4:printw('House '+HouseName[ListSet[i]]);
  5:printw('Tutor '+XML_TEACHERS.TeCode[ListSet[i],0]+' '+XML_TEACHERS.TeName[ListSet[i],0]);
  6:printw('Room '+XML_TEACHERS.TeCode[ListSet[i],1]+' '+XML_TEACHERS.TeName[ListSet[i],1]);
 end;
 newline; newline;
end;


procedure TStuinput.SetTabs;
var
 i,vlines,tmpInt: integer;
 j: integer;
begin
 caption:='Student Input '+GroupCaption;
 UseBarCodes:=winView[wnStInput]=1;
 SetLength(Tabs,6);
 GetLists;
 CalcTabStField;
 HeadHeight:=0;
 headwidth:=fwStname+TabStField;
 if XML_DISPLAY.sTID then inc(headwidth,2*StBarCode1.width+fwID);
 lineLen:=canvas.textwidth('Enter Subject Selection (First '); {length of lines}
 tmpInt:=trunc(screen.width*0.95);
 vlines:=7+(1+XML_DISPLAY.StInputPref1)*XML_DISPLAY.double_print;
 if XML_DISPLAY.StInputPref2>0 then inc(vlines,1+(1+XML_DISPLAY.StInputPref2)*XML_DISPLAY.double_print);
 case winView[wnStInput] of
  1: begin
      vlines:=9;
      i:=txtheight*2;
      if fwcode[0]>i then i:=fwcode[0];
      Tabs[1]:=i+blankwidth;
      i:=StBarCode1.width;
      if fwcodename[0]>i then i:=fwcodename[0];
      Tabs[2]:=i+blankwidth;
      Tabs[3]:=Tabs[1]; {gap}
      Tabs[4]:=Tabs[1]+Tabs[2]+Tabs[3];
      Tabs[5]:=StBarCode1.width;
      Codefit:=tmpInt div Tabs[4];
      if Codefit<1 then Codefit:=1;
      for j:=1 to OfferSections do
       begin
        if OfferDesc[j]>'' then inc(vlines);
        i:=OfferSubs[j,0] div codefit;
        if (OfferSubs[j,0] mod codefit)>0 then inc(i);
        inc(vlines,i*4+3);
       end;
     end;
  2,3: begin
      if winView[wnStInput]=2 then
       begin
        Tabs[1]:=blankwidth+fwcode[0];
        codefit:=(tmpint-fwcode[0]) div Tabs[1];
       end
      else
       begin
        Tabs[1]:=blankwidth+fwcodename[0];
        codefit:=tmpint div Tabs[1];
       end;
      if codefit<1 then codefit:=1;
      for j:=1 to OfferSections do
       begin
        i:=OfferSubs[j,0] div codefit;
        if ((OfferSubs[j,0] mod codefit)>0) or (OfferSubs[j,0]=0) then inc(i);
        inc(vlines,i+2);
        if OfferDesc[j]>'' then inc(vlines);
       end;
      inc(vlines);
     end;
  4: begin
      vlines:=3;
      HeadHeight:=4*txtHeight;
     end;

 end; {case}
 StHeight:=vlines*txtHeight; {height for one student}
 {do equivalent of CalcArrayTops}
 TotalCount:=0;
 for i:=1 to NumOfLists do inc(TotalCount,ListSize[i]);
 ListTop[1]:=txtHeight;
 if NumofLists>1 then
   for i:=2 to NumofLists do ListTop[i]:=ListTop[i-1]+HeadHeight+ListSize[i-1]*StHeight;
 MaxH:=TotalCount*StHeight+4*TxtHeight+NumOfLists*HeadHeight;
 MaxW:=tmpInt;
end;

Procedure GeneralListContents(i,size,myset:integer;var Contents: array of integer);
var
 j,count: integer;
begin
 count:=0;
 if Size=0 then exit;
 case XML_DISPLAY.StudentInputShow2 of
  1: for j:=1 to size do
        Contents[j]:=XML_DISPLAY.StudentInputSelection[j];
  2: for j:=1 to size do Contents[j]:=StPointer[j];
  3: for j:=1 to GroupNum do
       if XML_STUDENTS.Stud[StPointer[j]].TcClass=myset then
          begin inc(count); Contents[count]:=StPointer[j]; end;
  4: for j:=1 to GroupNum do
       if XML_STUDENTS.Stud[StPointer[j]].house=myset then
          begin inc(count); Contents[count]:=StPointer[j]; end;
  5: for j:=1 to GroupNum do
       if XML_STUDENTS.Stud[StPointer[j]].tutor=myset then
          begin inc(count); Contents[count]:=StPointer[j]; end;
  6: for j:=1 to GroupNum do
       if XML_STUDENTS.Stud[StPointer[j]].home=myset then
          begin inc(count); Contents[count]:=StPointer[j]; end;
 end;{case}
end;


procedure TStuinput.GetListContents(i:integer);
begin
 SetLength(ListContents,ListSize[i]+1);
 GeneralListContents(i,ListSize[i],ListSet[i],ListContents);
end;


procedure TStuinput.GetLists;
var
 i,i2,kk,myVal: integer;
 verify,InUse:  tpTeData;

  procedure AddInUse(j:integer);
  begin
    if bool(verify[j]) then
      begin
       inc(kk);
       InUse[kk]:=j;
      end;
  end;

begin
 for i:=0 to nmbrTeachers do begin verify[i]:=0; InUse[i]:=0; end;
 kk:=0;  myVal:=0;
 if XML_DISPLAY.StudentInputShow2>2 then
   begin
    case XML_DISPLAY.StudentInputShow2 of
      3: myVal:=XML_DISPLAY.StInputClass;
      4: myVal:=XML_DISPLAY.StInputHouse;
      5: myVal:=XML_DISPLAY.StInputTutor;
      6: myVal:=XML_DISPLAY.StInputRoom;
     end; {case}
    for i:=1 to groupnum do
    begin
     i2:=StPointer[i];
     case XML_DISPLAY.StudentInputShow2 of
      3: inc(verify[XML_STUDENTS.Stud[i2].Tcclass]);
      4: inc(verify[XML_STUDENTS.Stud[i2].house]);
      5: inc(verify[XML_STUDENTS.Stud[i2].tutor]);
      6: inc(verify[XML_STUDENTS.Stud[i2].home]);
     end; {case}
    end; {for i}
    case XML_DISPLAY.StudentInputShow2 of
     3: for i:=1 to classnum do AddInUse(RollClassPoint[i]);
     4: for i:=1 to HouseCount do AddInUse(i);
     5: for i:=1 to codeCount[1] do AddInUse(codepoint[i,1]);
     6: for i:=1 to codeCount[2] do AddInUse(codepoint[i,2]);
    end; {case}

 end; {if StudentInputShow2>2 }
 NumOfLists:=1; SetArraySizes;
 case XML_DISPLAY.StudentInputShow2 of
  1: ListSize[1]:=XML_DISPLAY.StudentInputSelection[0];
  2: ListSize[1]:=GroupNum;
  3..6: if myVal=0 then
      begin
       NumOfLists:=kk; SetArraySizes;
       if kk>0 then for i:=1 to kk do
         begin
           ListSize[i]:=verify[InUse[i]];
           ListSet[i]:=InUse[i];
         end;
      end
       else
        begin
         ListSet[1]:=MyVal;
         ListSize[1]:=verify[MyVal];
        end;
 end;{case}
end;





procedure TStuinput.printBarCodes;
var
 aStr:          string;
 i,j,k,place,count,offset,offset1,x1,y1,oldx:          longint;
 ar:                   trect;
begin
try
 offset1:=fwcodename[0] div 2;
 for k:=1 to OfferSections do
  if OfferSubs[k,0]>0 then
   begin
    printwl(OfferTitle[k]); newline; y1:=y;  count:=0;
    if OfferDesc[k]>'' then begin printx(OfferDesc[k]); newline; end;
    if y<(y1+2*txtHeight) then newline;
    for j:=1 to OfferSubs[k,0] do
     begin
      inc(count);
      place:=OfferSubs[k,j];
      aStr:=copy(SubCode[place],1,lencodes[0]-1);
      printw(SubCode[place]);
      barboxsz:=txtheight*2;
      drawmyline(x,y+txtheight*1,x+barboxsz,y+txtheight*1);
      drawmyline(x+barboxsz,y+txtheight*1,x+barboxsz,y+txtheight*3);
      drawmyline(x,y+txtheight*3,x+barboxsz,y+txtheight*3);
      drawmyline(x,y+txtheight*1,x,y+txtheight*3);
      offset:=canvas.TextWidth(Subname[place]) div 2;
      x1:=offset1-offset; if x1<0 then x1:=0;
      oldx:=x;
      inc(x,Tabs[1]+x1);
      printw(Subname[place]);
      x:=oldx+Tabs[1];
      ar.top:=y+txtheight; ar.bottom:=y+3*txtheight;
      ar.left:=x+hmargin-hscroll; ar.right:=ar.left+Tabs[2];
      StBarCode1.code:=RpadString(SubCode[place],lencodes[0]);
      StBarCode1.paintToCanvas(Stuinput.canvas,ar);
      inc(x,Tabs[2]+Tabs[3]);
      if (count mod codefit)=0 then
        begin
         count:=0;
         for i:=1 to 4 do newline;
        end;
     end; {for j}
    if count >0 then for i:=1 to 4 do newline;
   end; {if OfferSubs[k,0]>0}
 except
 end;
end;

procedure TStuinput.PrintSections;
var
 i,j,place,count:            integer;
 astr: string;
begin
 printw('Subjects Offered:');  newline;
 for i:=1 to OfferSections do
  begin
   count:=0;
   fcolor(cpNormal);
   printwl(OfferTitle[i]); newline;
   if OfferDesc[i]>'' then begin printwl(OfferDesc[i]); newline; end;
   if OfferSubs[i,0]>0 then
    for j:=1 to OfferSubs[i,0] do
     begin
      place:=OfferSubs[i,j];
      if place>0 then
       begin
        inc(count);
        fcolor(cpSub);
        if winView[wnStInput]=2 then astr:=SubCode[place] else astr:=Subname[place];
        printw(astr+' ');
        inc(x,Tabs[1]);
        if (count mod codefit)=0 then
         begin newline; count:=0; end;
       end;
     end; {for j}
  if (count>0) or (OfferSubs[i,0]=0) then newline;
  newline;
 end; {for i}
end;



procedure TStuinput.printx(a: string);
var
 a1,i,j:         smallint;
 b,c:                 string;
begin
 j:=trunc(screen.width*0.95);
 b:=a;
 while (b>'') do
 begin
  a1:=self.canvas.textwidth(b);
  if a1<=j  then
  begin
   printw(b); b:='';
  end
  else
   begin
    for i:=length(b) downto 1 do
    begin
     if ord(b[i])=32 then {look for space}
     begin
      c:=copy(b,1,i-1);
      a1:=self.canvas.textwidth(c);
      if a1<=j  then
      begin
       printw(c);  newline;
       b:=copy(b,i+1,length(b));   break;
      end;
     end;
    end; {for i}

   end;
 end; {while}
 newline;
end;

procedure TStuinput.displayStudent(i: integer);
begin
 if XML_DISPLAY.double_space then newline;
 ShowStudentName(i);
 if XML_DISPLAY.sTID then ShowIDbarcode(i,false);
end;

procedure TStuinput.PrintFormHead(stI: integer);
begin
 printw('Student Selection Sheet');   {line 1}
 newline;
 fcolor(cpStList);
 displaystudent(stI); newline;         {line 2}
 fcolor(cpNormal);
 if useBarcodes then newline;
end;

procedure TStuinput.printform(stI: integer);
var
 j:     integer;
begin
 fcolor(cpNormal);
 if winView[wnStInput]=4 then
  begin
   displaystudent(stI); newline;
   exit;
  end;
 PrintFormHead(stI);
  case winView[wnStInput] of
   0: ; {nothing}
   1: printBarCodes;
   2,3: PrintSections;
  end; {case}
 fcolor(cpNormal);
 newline;

 if not(useBarcodes) then
  begin
    printwl('Enter Subject Selection ');
    if XML_DISPLAY.StInputPref2>0 then printw('(First Preferences)');
    newline; newline;
    if XML_DISPLAY.double_space then newline;
    for j:=1 to XML_DISPLAY.StInputPref1 do
     begin
      drawmyline(x,y,x+lineLen,y); newline;
      if XML_DISPLAY.double_space then newline;
     end; {for j}
    newline;
    if XML_DISPLAY.StInputPref2>0 then
     begin
      printw('Second Preferences'); newline; newline;
      if XML_DISPLAY.double_space then newline;
      for j:=1 to XML_DISPLAY.StInputPref2 do
       begin
        drawmyline(x,y,x+lineLen,y); newline;
        if XML_DISPLAY.double_space then newline;
       end; {for j}
      newline;
     end;
  end;
end;


procedure TStuinput.FormPaint(Sender: TObject);
var
 i,j,k:            integer;

begin
 studentpointerset;
 settabs;
 StBarCode1.font.assign(XML_DISPLAY.tcfont);
 fcolor(cpNormal); {main headings etc -black}
 if TotalCount=0 then
   begin
    printw('No students selected.');
    exit;
   end;
 for i:=1 to NumOfLists do
  if ListSize[i]>0 then
   begin
    GetListContents(i);
    fcolor(cpNormal);
    if winView[wnStInput]=4 then ListHead(i);
    for j:=1 to ListSize[i] do
     begin
      k:=ListContents[j];
      y:=ListTop[i]+HeadHeight+(j-1)*StHeight-Vscroll;
      if (y+StHeight)<(-2*TxtHeight) then
       begin
        inc(y,StHeight);
        continue;
       end;
      printform(k);
      if y>bottomCutoff then exit; {no printing past range}
     end;
   end;
end;

{======================                        ==================================}
{---------------------- printing procs follow -----------------------------------}
{======================                        ==================================}


procedure TPrintStInputWin.head;
begin
 if not(DoHeader) then exit;
 UnderlineOn;
 printwl('Student Input '+GroupCaption);
 printw(PageCount);
 UnderlineOff;
 x:=0; y:=y+2*PrnttxtHeight;
 fcolor(cpNormal);
end;

procedure TPrintStInputWin.GetLists;
var
 i: integer;
begin
 NumOfLists:=Stuinput.NumOfLists;
 SetArraySizes;
 if NumOfLists>0 then
  for i:=1 to NumOfLists do
   begin
    ListSize[i]:=Stuinput.ListSize[i];
    ListSet[i]:=Stuinput.ListSet[i];
   end;
end;

procedure TPrintStInputWin.GetListContents(i: integer);
begin
 SetLength(ListContents,ListSize[i]+1);
 GeneralListContents(i,ListSize[i],ListSet[i],ListContents);
end;

procedure TPrintStInputWin.ListHead(i:integer);
begin
 fcolor(cpNormal);
 if not(DoHeader) then exit;
 newline;
 case XML_DISPLAY.StudentInputShow2 of
  1:printw('Selected Students');
  2:printw('Student Group '+GroupCaption);
  3:printw('Class '+ClassCode[ListSet[i]]);
  4:printw('House '+HouseName[ListSet[i]]);
  5:printw('Tutor '+XML_TEACHERS.TeCode[ListSet[i],0]+' '+XML_TEACHERS.TeName[ListSet[i],0]);
  6:printw('Room '+XML_TEACHERS.TeCode[ListSet[i],1]+' '+XML_TEACHERS.TeName[ListSet[i],1]);
 end;
 newline; newline;
end;


procedure TPrintStInputWin.SetTabs;
var
 i,tmpInt: integer;
 j: integer;
begin
 SetLength(PrntTabs,6);
 GetLists;
 CalcTabStField;
 HeadHeight:=0;
 tmpInt:=trunc(PrintPageWidth*0.9)-prntHmargin;
 lineLen:=PrintCanvas.textwidth('Enter Subject Selection (First '); {length of lines}
 vlines:=7+(1+XML_DISPLAY.StInputPref1)*XML_DISPLAY.double_print;
 if XML_DISPLAY.StInputPref2>0 then inc(vlines,1+(1+XML_DISPLAY.StInputPref2)*XML_DISPLAY.double_print);
 case winView[wnStInput] of
  1: begin
      vlines:=9;
      i:=prnttxtheight*2;
      if fwprntcode[0]>i then i:=fwprntcode[0];
      if i<2*PrntTxtHeight then i:=2*PrntTxtHeight;
      PrntTabs[1]:=i+prntblankwidth;
      i:=StBarCode1.width;
      if fwprntcodename[0]>i then i:=fwprntcodename[0];
      PrntTabs[2]:=i+prntblankwidth;
      PrntTabs[3]:=PrntTabs[1]; {gap}
      PrntTabs[4]:=PrntTabs[1]+PrntTabs[2]+5*prntblankwidth{ was PrntTabs[3] instead of 5*prntblankwidth};
      PrntTabs[5]:=StBarCode1.width;
      Codefit:=tmpInt div PrntTabs[4];
      if Codefit<1 then Codefit:=1;
      for j:=1 to OfferSections do
       begin
        if OfferDesc[j]>'' then inc(vlines);
        i:=OfferSubs[j,0] div codefit;
        if (OfferSubs[j,0] mod codefit)>0 then inc(i);
        inc(vlines,i*4+3);
       end;
     end;
  2,3: begin
      if winView[wnStInput]=2 then PrntTabs[1]:=prntblankwidth+fwprntcode[0]
       else PrntTabs[1]:=prntblankwidth+fwprntcodename[0];
      codefit:=tmpint div PrntTabs[1];
      if codefit<1 then codefit:=1;
      for j:=1 to OfferSections do
       begin
        i:=OfferSubs[j,0] div codefit;
        if ((OfferSubs[j,0] mod codefit)>0) or (OfferSubs[j,0]=0) then inc(i);
        inc(vlines,i+2);
        if OfferDesc[j]>'' then inc(vlines);
       end;
      inc(vlines);
     end;
  4: begin
      vlines:=3;
      HeadHeight:=4*prnttxtheight;
     end;
 end; {case}
 StHeight:=vlines*prnttxtheight; {height for one student}
 {do equivalent of CalcArrayTops}
 TotalCount:=0;
 for i:=1 to NumOfLists do inc(TotalCount,ListSize[i]);
end;



procedure TPrintStInputWin.printBarCodes;
var
 aStr:          string;
 i,j,k,place,count,offset,offset1,x1,oldx:          longint;
 ar:                   trect;
begin
try
 offset1:=fwprntcodename[0] div 2;
 for k:=1 to OfferSections do
  if OfferSubs[k,0]>0 then
   begin
    printwl(OfferTitle[k]); newline;  DescLines:=0;  count:=0;
    if OfferDesc[k]>'' then begin printx(OfferDesc[k]); newline; end;
    if DescLines<2 then newline;
    for j:=1 to OfferSubs[k,0] do
     begin
      inc(count);
      place:=OfferSubs[k,j];
      aStr:=copy(SubCode[place],1,lencodes[0]-1);
      printw(SubCode[place]);
      barboxsz:=PrntTxtheight*2;
      drawmyline(x,y+PrntTxtheight*1,x+barboxsz,y+PrntTxtheight*1);
      drawmyline(x+barboxsz,y+PrntTxtheight*1,x+barboxsz,y+PrntTxtheight*3);
      drawmyline(x,y+PrntTxtheight*3,x+barboxsz,y+PrntTxtheight*3);
      drawmyline(x,y+PrntTxtheight*1,x,y+PrntTxtheight*3);
      offset:=PrintCanvas.TextWidth(Subname[place]) div 2;
      x1:=offset1-offset; if x1<0 then x1:=0;
      oldx:=x;
      inc(x,PrntTabs[1]+x1);
      printw(Subname[place]);
      x:=oldx+PrntTabs[1];
      ar.top:=y+PrntTxtheight; ar.bottom:=y+3*PrntTxtheight;
      ar.left:=x+prntHmargin; ar.right:=ar.Left+PrntTabs[2];;
      StBarCode1.code:=RpadString(SubCode[place],lencodes[0]);
      StBarCode1.paintToCanvas(PrintCanvas,ar);
      inc(x,PrntTabs[2]+PrntTabs[3]);
      if (count mod codefit)=0 then
        begin
         count:=0;
         inc(y,3*PrntTxtheight); newline;
        end;
     end; {for j}
    if count >0 then for i:=1 to 4 do newline;
   end; {if OfferSubs[k,0]>0}
 except
 end;
end;

procedure TPrintStInputWin.PrintSections;
var
 i,j,place,count:            integer;
 astr: string;
begin
 printw('Subjects Offered:');  newline;
 for i:=1 to OfferSections do
  begin
   count:=0;
   fcolor(cpNormal);
   printwl(OfferTitle[i]); newline;
   if OfferDesc[i]>'' then begin printwl(OfferDesc[i]); newline; end;
   if OfferSubs[i,0]>0 then
    for j:=1 to OfferSubs[i,0] do
     begin
      place:=OfferSubs[i,j];
      if place>0 then
       begin
        inc(count);
        fcolor(cpSub);
        if winView[wnStInput]=2 then astr:=SubCode[place] else astr:=Subname[place];
        printw(astr+' ');
        inc(x,PrntTabs[1]);
        if (count mod codefit)=0 then
         begin newline; count:=0; end;
       end;
     end; {for j}
  if (count>0) or (OfferSubs[i,0]=0) then newline;
  newline;
 end; {for i}
end;



procedure TPrintStInputWin.printx(a: string);
var
 a1,i,j:         smallint;
 b,c:                 string;
begin
 j:=trunc(PrintPageWidth*0.9)-prntHmargin;
 b:=a; DescLines:=1;
 newline;
 while (b>'') do
 begin
  a1:=PrintCanvas.textwidth(b);
  if a1<=j  then
  begin
   printw(b); b:='';
  end
  else
   begin
    for i:=length(b) downto 1 do
    begin
     if ord(b[i])=32 then {look for space}
     begin
      c:=copy(b,1,i-1);
      a1:=PrintCanvas.textwidth(c);
      if a1<=j  then
      begin
       printw(c);  newline;  inc(DescLines);
       b:=copy(b,i+1,length(b));   break;
      end;
     end;
    end; {for i}

   end;
 end; {while}
 newline;
end;

procedure TPrintStInputWin.displayStudent(i: integer);
begin
 if XML_DISPLAY.double_space then newline;
 ShowStudentName(i);
 if XML_DISPLAY.sTID then printIDbarcode(i);
end;


procedure TPrintStInputWin.PrintFormHead(stI: integer);
begin
 if DoHeader then
  begin
   printw('Student Selection Sheet');   {line 1}
   newline;
  end;
 fcolor(cpStList);
 displaystudent(stI); newline;         {line 2}
 fcolor(cpNormal);
 if useBarcodes then newline;
end;

procedure TPrintStInputWin.printform(stI: integer);
var
 j:     integer;
begin
 fcolor(cpNormal);
 if winView[wnStInput]=4 then
  begin
   displaystudent(stI);
   inc(y,3*PrntTxtHeight); newline;
   exit;
  end;
 PrintFormHead(stI);
  case winView[wnStInput] of
   0: ; {nothing}
   1: printBarCodes;
   2,3: PrintSections;
  end; {case}
 fcolor(cpNormal);
 newline;

 if not(useBarcodes) then
  begin
    printwl('Enter Subject Selection ');
    if XML_DISPLAY.StInputPref2>0 then printw('(First Preferences)');
    newline; newline;
    if XML_DISPLAY.double_space then newline;
    for j:=1 to XML_DISPLAY.StInputPref1 do
     begin
      drawmyline(x,y,x+lineLen,y); newline;
      if XML_DISPLAY.double_space then newline;
     end; {for j}
    newline;
    if XML_DISPLAY.StInputPref2>0 then
     begin
      printw('Second Preferences'); newline; newline;
      if XML_DISPLAY.double_space then newline;
      for j:=1 to XML_DISPLAY.StInputPref2 do
       begin
        drawmyline(x,y,x+lineLen,y); newline;
        if XML_DISPLAY.double_space then newline;
       end; {for j}
      newline;
     end;
  end;  {not(useBarcodes)}
end;

procedure StuInputPrint;
var
 i,j,k: integer;
begin
 PrintStInputWin:=TPrintStInputWin.Create;
 with PrintStInputWin do
  try
   DoHeader:=XML_DISPLAY.StHeadShow;
   BarcodeMake;
   PrintHead;
   if TotalCount=0 then
    begin
     printw('No students selected.');
     exit;
    end;
   for i:=1 to NumOfLists do
    if ListSize[i]>0 then
     begin
      GetListContents(i);
      fcolor(cpNormal);
      if winView[wnStInput]=4 then ListHead(i);
      for j:=1 to ListSize[i] do
       begin
        k:=ListContents[j];
        printform(k);
        if winView[wnStInput]<4 then
         begin
          PrintCustomAddon;
          if (XML_DISPLAY.formfeed or ((y+StHeight)>(PrintPageHeight-4*prntTxtHeight)))
              and ((i<NumOfLists) or (j<ListSize[i])) then
           begin
            StartNewPage;
            Header;
           end
          else begin inc(y,3*prntTxtHeight); newline; end;
         end;
       end; {for j}
      if winView[wnStInput]=4 then {list}
       begin
        if XML_DISPLAY.formfeed or (i=NumOfLists) then PrintCustomAddon;
        if (XML_DISPLAY.formfeed or ((y+StHeight)>(PrintPageHeight-4*prntTxtHeight)))
            and (i<NumOfLists) then
         begin
          StartNewPage;
          Header;
         end
        else begin inc(y,3*prntTxtHeight); newline; end;
       end;
     end; {for i}
   stbarcode1.Free;  
  finally; {with PrintTeWin}
   PrintStInputWin.Free;
  end;
end; {main print}


procedure TStuinput.FormDblClick(Sender: TObject);
begin
 selection2click(self);
end;


procedure TOutStInputWin.head;
begin
 if DoHeader then printLine(['Student Input '+GroupCaption]);
end;

procedure TOutStInputWin.GetLists;
var
 i: integer;
begin
 NumOfLists:=Stuinput.NumOfLists;
 SetArraySizes;
 if NumOfLists>0 then
  for i:=1 to NumOfLists do
   begin
    ListSize[i]:=Stuinput.ListSize[i];
    ListSet[i]:=Stuinput.ListSet[i];
   end;
 TotalCount:=Stuinput.TotalCount;
end;

procedure TOutStInputWin.GetListContents(i: integer);
begin
 SetLength(ListContents,ListSize[i]+1);
 GeneralListContents(i,ListSize[i],ListSet[i],ListContents);
end;



procedure TOutStInputWin.PrintSections;
var
 i,j,place,count:            integer;
 astr: string;
begin
 printw('Subjects Offered:');  newline;
 for i:=1 to OfferSections do
  begin
   printw(OfferTitle[i]); newline;  count:=0;
   if OfferDesc[i]>'' then begin printw(OfferDesc[i]); newline; end;
   if OfferSubs[i,0]>0 then
    for j:=1 to OfferSubs[i,0] do
     begin
      place:=OfferSubs[i,j];
      if place>0 then
       begin
        inc(count);
        if winView[wnStInput]=2 then astr:=SubCode[place] else astr:=Subname[place];
        if count=1 then printw(astr) else printc(astr);
       end;
     end; {for j}
  newline;
 end; {for i}
end;



procedure TOutStInputWin.printform(stI: integer);
var
 j:     integer;
begin
 if winView[wnStInput]=4 then
  begin
   ShowStudentName(stI); newline;
   exit;
  end;
 PrintFormHead(stI);
  case winView[wnStInput] of
   0: ; {nothing}
   2,3: PrintSections;
  end; {case}
 newline;
 if not(useBarcodes) then
  begin
    printw('Enter Subject Selection ');
    if XML_DISPLAY.StInputPref2>0 then printc('(First Preferences)');
    newline; newline;
    for j:=1 to XML_DISPLAY.StInputPref1 do
     begin
      printw('_________________'); newline;
      if XML_DISPLAY.double_space then newline;
     end; {for j}
    newline;
    if XML_DISPLAY.StInputPref2>0 then
     begin
      printw('Second Preferences'); newline; newline;
      if XML_DISPLAY.double_space then newline;
      for j:=1 to XML_DISPLAY.StInputPref2 do
       begin
        printw('_________________'); newline;
        if XML_DISPLAY.double_space then newline;
       end; {for j}
      newline;
     end;
  end;  {not(useBarcodes)}
end;

procedure TOutStInputWin.PrintFormHead(stI: integer);
begin
 printLine(['Student Selection Sheet']);
 ShowStudentName(stI); newline;
 if useBarcodes then newline;
end;

procedure TOutStInputWin.ListHead(i:integer);
begin
 if not(DoHeader) then exit;
 newline;
 case XML_DISPLAY.StudentInputShow2 of
  1:printw('Selected Students');
  2:printw('Student Group '+GroupCaption);
  3:printw('Class '+ClassCode[ListSet[i]]);
  4:printw('House '+HouseName[ListSet[i]]);
  5:printw('Tutor '+XML_TEACHERS.TeCode[ListSet[i],0]+' '+XML_TEACHERS.TeName[ListSet[i],0]);
  6:printw('Room '+XML_TEACHERS.TeCode[ListSet[i],1]+' '+XML_TEACHERS.TeName[ListSet[i],1]);
 end;
 newline; newline;
end;


procedure Stuinputtext;
var
 i,j,k:        integer;
begin
 OutStInputWin:=TOutStInputWin.create;
 with OutStInputWin do
  try
   DoHeader:=XML_DISPLAY.StHeadShow;
   GetLists;
   Header;
   if TotalCount=0 then
    begin
     printw('No students selected.');
     exit;
    end;
   for i:=1 to NumOfLists do
    if ListSize[i]>0 then
     begin
      GetListContents(i);
      if winView[wnStInput]=4 then ListHead(i);
      for j:=1 to ListSize[i] do
       begin
        k:=ListContents[j];
        printform(k);
        if winView[wnStInput]<4 then begin PrintCustomAddon; newline; end;
       end; {for j}
      if winView[wnStInput]=4 then PrintCustomAddon;{list}
     end; {for i}
  finally
   OutStInputWin.Free;
  end;
end;






end.
