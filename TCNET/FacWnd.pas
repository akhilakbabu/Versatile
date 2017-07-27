unit FacWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls,ClassDefs,printers,TimeChartGlobals, XML.TEACHERS;

type
  TFacultyWindow = class(TCodeWin)
    PopupMenu1: TPopupMenu;
    Change2: TMenuItem;
    N6: TMenuItem;
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
    popFacultyDelete: TMenuItem;
    Delete1: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Change1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure Codes1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure DeleteFaculty(Sender: TObject);
  private
    facLines,facTop:     array[1..1+nmbrFaculty] of smallint;
    curtab:              array[0..2] of smallint;
    suPerLine,TePerLine,roPerLine: smallint;
  protected
    procedure PaintItem(i:integer;SelFlag:boolean); override;
    procedure PaintItemFull(i:integer;SelFlag:boolean); override;
    procedure SetTabs; override;
    procedure PaintHead; override;
    procedure CalcItemPosition(i:integer); override;
    procedure MouseDown(Button: TMouseButton;Shift: TShiftState; X1, Y1: Integer); override;
                                   {used to select a code}
  end;

 procedure FaCodePrint;
 procedure FaCodeOut;

var
  FacultyWindow: TFacultyWindow;

implementation

uses
  main, tcommon, tcommon2, edfac2, tcommon5, SuWnd, RoWnd, TeWnd;

{$R *.dfm}

type
  TPrintFaWin=class(TPrintCodeWin)
  public
    procedure head; override;
    procedure SetTabs; override;
  private
    facLines:     array[1..1+nmbrFaculty] of smallint;
    curtab:              array[0..2] of integer;
    suPerLine,TePerLine,roPerLine: smallint;
 end;

type
  TOutFaWin=class(TOutCodeWin)
  public
    procedure head; override;
    function CodeToPrint(i:integer):string; override;
 end;

var
 PrintFaWin:    TPrintFaWin;
 OutFaWin:      TOutFaWin;

procedure TFacultyWindow.MouseDown(Button: TMouseButton;Shift: TShiftState; X1, Y1: Integer);
var
 xx,yy,i:  integer;
 newselcode: integer;
begin
 if doubleclick then
  begin
   doubleclick:=false;
   exit;
  end;
 newselcode:=0;
 if winView[tag]=0 then
  begin
   xx:=((x1-Hmargin+Hscroll) div CodeWidth)+1;
   if (xx>Codefit) then xx:=Codefit;
   yy:=((y1-yHead) div txtHeight);
   newselcode:=xx+yy*Codefit;
  end
 else  {not winView[tag]=0}
  begin
   if facNum>0 then
    for i:=1 to facNum do
     if ((y1-yHead)>=(FacTop[i]*txtHeight)) and ((y1-yHead)<(FacTop[i+1]*txtHeight))
      then
       begin
        newselcode:=i;
        break;
       end;
  end;
 if (y1+Vscroll)<=(yHead) then newselcode:=0;
 if ((newselcode>0) and (newselcode<=TotalCodes)
      and (newselcode<>selCode)) then
  begin
   if selCode>0 then
    begin
     canvas.fillrect(selbox);
     PaintItemFull(selcode,false);
    end;
   selCode:=newselcode;
   PaintItemFull(selcode,true);
  end;
end;

procedure TFacultyWindow.CalcItemPosition(i:integer);
begin
 if winView[tag]=0 then
  begin
   x:=((i-1) mod codefit)*CodeWidth;
   y:=yHead + ((i-1) div codefit)*txtHeight;
   newrect.left:=x+Hmargin-Hscroll;
   newrect.right:=newrect.left+CodeWidth-blankWidth;
   newrect.top:=y; newrect.bottom:=y+TxtHeight;
  end
 else
  begin
   x:=0; y:=yHead +facTop[i]*txtHeight;
   newrect.left:=x+Hmargin-Hscroll;
   newrect.right:=newrect.left+maxW;
   newrect.top:=y; newrect.bottom:=y+TxtHeight*FacLines[i];
  end;
end;

procedure TFacultyWindow.setTabs;
var
 fsMax,ftMax,frMax,fHeightTot:      smallint;
 fsLines,ftLines,frLines,f1,m,j,k,l: smallint;

   function CodesPerLine(mycode: smallint): smallint;
   var
    myCodeFit,tmpInt: smallint;
   begin
    tmpInt:=trunc(screen.width*0.9);
    curTab[mycode]:= Tabs[1]+canvas.textwidth(codeNameCap[mycode]+'s: ');
    myCodeFit:=(tmpInt-Hmargin-curTab[mycode]) div (fwCode[mycode]+blankWidth);
    if myCodeFit<minCodeFit then myCodeFit:=minCodeFit;
    if myCodeFit=0 then myCodeFit:=1;
    result:=mycodefit;
   end;

begin
 setlength(Tabs,3);
 TotalCodes:=facNum;
 headwidth:=canvas.textwidth('Faculties: 999  ');
 Tabs[1]:=canvas.textwidth(inttostr(facNum)+': ');
 CodeWidth:=Tabs[1]+fwFaculty+blankWidth;
 //CodeFit:= trunc(screen.width*0.9) div CodeWidth;
 if CodeWidth <> 0 then
   CodeFit := Trunc(Self.Width - HMargin) div CodeWidth
 else
   CodeFit := 1;

 if CodeFit>TotalCodes then CodeFit:=TotalCodes;
 if Codefit=0 then Codefit:=1;

 fsMax:=0; ftMax:=0; frMax:=0; fHeightTot:=0;
 fsLines:=0;  ftLines:=0; frLines:=0;
 case winView[wnFac] of
  0: begin
      maxW:=Hmargin+CodeWidth*CodeFit;  {codes}
      maxH:=txtheight*((TotalCodes div CodeFit)+5)
     end;
  1: begin
      suPerLine:=CodesPerLine(0);
      tePerLine:=CodesPerLine(1);
      roPerLine:=CodesPerLine(2);
      facTop[1]:=0;
       for j:=1 to facNum do  {calc no. of lines needed}
        begin
         if facName[j]>'' then
          begin
           if facCount[j]>fsMax then fsMax:=facCount[j]; {get max fac subs}
           fsLines:=facCount[j] div suPerLine;
           if (facCount[j] mod suPerLine)>0 then inc(fsLines); {check for partial lines}
           if fsLines=0 then fsLines:=1;   {no. of fac sub lines}
           f1:=0;    {teachers}
           for k:=1 to codeCount[1] do
            begin
             m:=codepoint[k,1];
             if TeachInAnyFac(m,j) then inc(f1);
            end; {for k}
           if f1>ftMax then ftMax:=f1;
           ftLines:=f1 div tePerLine;
           if (f1 mod tePerLine)>0 then  inc(ftLines); {check for partial lines}
           if ftLines=0 then ftLines:=1;  {no. of fac teach lines}
           f1:=0;   {rooms}
           for k:=1 to codeCount[2] do
            begin
             m:=codepoint[k,2];
             if RoomInAnyFac(m,j) then inc(f1);
            end; {for k}
           if f1>frMax then frMax:=f1;
           frLines:=f1 div roPerLine;
           if (f1 mod roPerLine)>0 then inc(frLines); {check for partial lines}
           if frLines=0 then frLines:=1;  {no. of fac room lines}
          end; {if facName[j]>''}
         facLines[j]:=1+fsLines+ftLines+frLines;
         facTop[j+1]:=facTop[j]+facLines[j];
         inc(fHeightTot,facLines[j]);   {no. lines for fac subs}
        end;   {for j}

       if suPerLine>fsMax then m:=fsMax else m:=suPerLine;
       k:=Tabs[1]+canvas.textwidth('Subjects: ')+(m*(fwCode[0]+blankwidth));
       if tePerLine>ftMax then m:=ftMax else m:=tePerLine;
       l:=Tabs[1]+canvas.textwidth('Teachers: ')+(m*(fwCode[1]+blankwidth));
       if l>k then k:=l;
       if roPerLine>frMax then m:=frMax else m:=roPerLine;
       l:=Tabs[1]+canvas.textwidth('Rooms: ')+(m*(fwCode[2]+blankwidth));
       if l>k then k:=l;
       maxW:=Hmargin+k;
       if maxW<headwidth then maxW:=headwidth;
       maxH:=(fHeightTot+5)*txtHeight;
     end;
 end; {case}
end;

procedure TFacultyWindow.PaintItemFull(i:integer;SelFlag:boolean);
begin
 CalcItemPosition(i);
 if ((y+faclines[i]*TxtHeight)<topCutoff) or (y>bottomCutoff) then exit;
 if selFlag then HighlightBox(newrect);
 PaintItem(i,SelFlag);
end;

procedure TFacultyWindow.PaintItem(i:integer;SelFlag:boolean);
var
 k,f1,f3:    integer;
begin
 case winView[wnFac] of
  0: printw(inttostr(i)+': '+facName[i]);  {codes only}
  1: begin  {code + name}
      topcolor(cpFac);
      printw(inttostr(i)+': ');
      x:=Tabs[1]; printw(facName[i]); newline;
      topcolor(cpNormal);
      x:=Tabs[1]; printw(codeNameCap[0]+'s: ');  {subjects}
      k:=0; topcolor(cpSub);
      if facCount[i]>0 then
       for f1:=1 to facCount[i] do
        begin
         x:=curTab[0]+k*(fwCode[0]+blankwidth);
         if k=suPerLine then
          begin
           k:=0;
           newline;
           if y>bottomCutoff then exit; {no printing past range}
          end;
         inc(k);
         if facSubs[i,f1]>=0 then
           printw(SubCode[facSubs[i,f1]]+' ')
          else
           printw(copy(SubCode[abs(facSubs[i,f1])],1,lencodes[0]-1)+'* ');
        end;  {for f1}
      if (x>0) then newline;
      topcolor(cpNormal);
      x:=Tabs[1]; printw(codeNameCap[1]+'s: ');  {teachers}
      k:=0; topcolor(cpTeach);
      for f1:=1 to codeCount[1] do
       begin
        x:=curTab[1]+k*(fwCode[1]+blankwidth);
        f3:=codepoint[f1,1];
        if TeachInAnyFac(f3,i) then
         begin
          if k=tePerLine then
           begin
            k:=0;
            newline;
            if y>bottomCutoff then exit; {no printing past range}
           end;
          inc(k);
          printw(XML_TEACHERS.TeCode[f3,0]+' ');
         end; {if TeachInAnyFac(f3,i)}
       end; {for f1}
      if (x>0) then newline;
      topcolor(cpNormal);
      x:=Tabs[1]; printw(codeNameCap[2]+'s: ');  {rooms}
      k:=0; topcolor(cpRoom);
      for f1:=1 to codeCount[2] do
       begin
        x:=curTab[2]+k*(fwCode[2]+blankwidth);
        f3:=codepoint[f1,2];
        if RoomInAnyFac(f3,i) then
         begin
          if k=roPerLine then
           begin
            k:=0;
            newline;
            if y>bottomCutoff then exit; {no printing past range}
           end;
          inc(k);
          printw(XML_TEACHERS.TeCode[f3,1]+' ');
         end; {if RoomInAnyFac(f3,i)}
       end; {for f1}
      if (x>0) then newline;
     end;  {winView[wnFac]=1}
 end;  {case}
 fcolor(codecolor);
end;

procedure TFacultyWindow.PaintHead;
begin
 codeColor:=cpFac; {Faculty}
 {Headings}
 printw2('Faculties: ',inttostr(TotalCodes));
 newline;
 newline;
end;

procedure TFacultyWindow.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action:= caFree;
end;

procedure TFacultyWindow.FormCreate(Sender: TObject);
begin
 setWindowDefaults(self,wnFac);
end;

procedure TFacultyWindow.FormResize(Sender: TObject);
begin
  Self.SetTabs;
  Refresh;
end;

procedure TPrintFaWin.SetTabs;
var
 fsLines,ftLines,frLines,f1,m,j,k: smallint;

   function CodesPerLine(mycode: smallint): integer;
   var
    myCodeFit,tmpInt: integer;
   begin
    tmpInt:=trunc(PrintPageWidth*0.9)-prntHmargin;
    curTab[mycode]:= PrntTabs[1]+PrintCanvas.textwidth(codeNameCap[mycode]+'s: ');
    myCodeFit:=(tmpInt-curTab[mycode]) div (fwprntCode[mycode]+prntblankwidth);
    if myCodeFit=0 then myCodeFit:=1;
    result:=mycodefit;
   end;

begin
 setlength(PrntTabs,3);
 TotalCodes:=facNum;
 PrntTabs[1]:=PrintCanvas.textwidth(inttostr(facNum)+': ');
 CodeWidth:=PrntTabs[1]+fwprntFaculty+prntblankwidth;

 fsLines:=0;  ftLines:=0; frLines:=0;
 case winView[wnFac] of
  0: CalcPrintCodeFit;
  1: begin
      suPerLine:=CodesPerLine(0);
      tePerLine:=CodesPerLine(1);
      roPerLine:=CodesPerLine(2);
      for j:=1 to facNum do  {calc no. of lines needed}
       begin
        if facName[j]>'' then
         begin
          fsLines:=facCount[j] div suPerLine;
          if (facCount[j] mod suPerLine)>0 then inc(fsLines); {check for partial lines}
          if fsLines=0 then fsLines:=1;   {no. of fac sub lines}
          f1:=0;    {teachers}
          for k:=1 to codeCount[1] do
           begin
            m:=codepoint[k,1];
            if TeachInAnyFac(m,j) then inc(f1);
           end;
          ftLines:=f1 div tePerLine;
          if (f1 mod tePerLine)>0 then  inc(ftLines); {check for partial lines}
          if ftLines=0 then ftLines:=1;  {no. of fac teach lines}
          f1:=0;   {rooms}
          for k:=1 to codeCount[2] do
           begin
            m:=codepoint[k,2];
            if RoomInAnyFac(m,j) then inc(f1);
           end; {for k}
          frLines:=f1 div roPerLine;
          if (f1 mod roPerLine)>0 then inc(frLines); {check for partial lines}
          if frLines=0 then frLines:=1;  {no. of fac room lines}
         end; {if facName[j]>''}
        facLines[j]:=1+fsLines+ftLines+frLines;
       end;   {for j}
     end;
 end; {case}

end;

procedure TPrintFaWin.head;
begin
 codeColor:=cpFac;
 UnderlineOn;
 printw2('Faculties: ',inttostr(Totalcodes));
 printw(PageCount);
 UnderlineOff;
 x:=0; y:=y+2*PrnttxtHeight;
end;

procedure FaCodePrint;
var
 i,k,f1,f3: integer;
begin
 PrintFaWin:=TPrintFaWin.Create;
 with PrintFaWin do
  try
   PrintHead;
   if TotalCodes<=0 then exit;
   for i:=1 to TotalCodes do
    begin
     case winView[wnFac] of
      0: begin
          printw(inttostr(i)+': '+facName[i]);
          x:=(i mod codefit)*CodeWidth;
          if (i mod codefit)=0 then newline;
         end;
      1: begin
          fcolor(cpFac);
          printw(inttostr(i)+': ');
          x:=PrntTabs[1]; printw(facName[i]); newline;
          fcolor(cpNormal);
          x:=PrntTabs[1]; printw(codeNameCap[0]+'s: ');  {subjects}
          k:=0; fcolor(cpSub);
          if facCount[i]>0 then
            for f1:=1 to facCount[i] do
             begin
              x:=curTab[0]+k*(fwprntCode[0]+prntblankwidth);
              inc(k);
               if facSubs[i,f1]>=0 then
                printw(SubCode[facSubs[i,f1]]+' ')
               else
                printw(copy(SubCode[abs(facSubs[i,f1])],1,lencodes[0]-1)+'* ');
              if k=suPerLine then begin k:=0; newline; end;
             end;  {for f1}
          if (x>0) then newline;
          fcolor(cpNormal);
          x:=PrntTabs[1]; printw(codeNameCap[1]+'s: ');  {teachers}
          k:=0; fcolor(cpTeach);
          for f1:=1 to codeCount[1] do
           begin
            x:=curTab[1]+k*(fwprntCode[1]+prntblankwidth);
            f3:=codepoint[f1,1];
            if TeachInAnyFac(f3,i) then
             begin
              inc(k);
              printw(XML_TEACHERS.TeCode[f3,0]+' ');
              if k=tePerLine then begin k:=0; newline; end;
             end;
           end; {for f1}
          if (x>0) then newline;
          fcolor(cpNormal);
          x:=PrntTabs[1]; printw(codeNameCap[2]+'s: ');  {rooms}
          k:=0; fcolor(cpRoom);
          for f1:=1 to codeCount[2] do
           begin
            x:=curTab[2]+k*(fwprntCode[2]+prntblankwidth);
            f3:=codepoint[f1,2];
            if RoomInAnyFac(f3,i) then
             begin
              inc(k);
              printw(XML_TEACHERS.TeCode[f3,1]+' ');
              if k=roPerLine then begin k:=0; newline; end;
             end; {if RoomInAnyFac(f3,i)}
           end; {for f1}
          if (x>0) then newline;
          if (i<Totalcodes) then
            if (y+PrnttxtHeight)>(PrintPageHeight-FacLines[i+1]*prntTxtHeight) then
             begin
              StartNewPage;
              Header;
             end;
         end; {case 1:}

     end;  {case}
    end;  {for i  to totalcodes}
    newline;
   printCustomAddon;
  finally; {with PrintTeWin}
   PrintFaWin.Free;
  end;
end; {main print}


procedure TOutFaWin.head;
begin
 printLine(['Faculties: ',inttostr(FacNum)]);
 newline;
  case winView[wnFac] of
   1: printLine(['Code ','Name']); {codes + name}
  end; {case}
 newline;
end;

function TOutFaWin.CodeToPrint(i:integer):string;
begin
 result:=inttostr(i)+': '+facName[i];
end;

procedure FaCodeOut;
var
 i,j,k,f1,f3: integer;
begin
 OutFaWin:=TOutFaWin.Create;
 with OutFaWin do
  try
   Setup(FacNum);
   if TotalCodes<=0 then exit;
   for i:=1 to TotalCodes do
    begin
     case winView[wnFac] of
      0: PrintCode(i);
      1: begin
          printw(inttostr(i)+': '); printc(facName[i]); newline;
          printw(codeNameCap[0]+'s: ');  {subjects}
          k:=0; j:=0;
          if facCount[i]>0 then
            for f1:=1 to facCount[i] do
             begin
              inc(k); inc(j);
               if facSubs[i,f1]>=0 then
                printc(SubCode[facSubs[i,f1]]+' ')
               else
                printc(copy(SubCode[abs(facSubs[i,f1])],1,lencodes[0]-1)+'* ');
              if k=codefit then begin k:=0; newline; end;
             end;  {for f1}
          if (k>0) or (j=0) then newline;
          printw(codeNameCap[1]+'s: ');  {teachers}
          k:=0; j:=0;
          for f1:=1 to codeCount[1] do
           begin
            f3:=codepoint[f1,1];
            if TeachInAnyFac(f3,i) then
             begin
              inc(k); inc(j);
              printc(XML_TEACHERS.TeCode[f3,0]+' ');
              if k=codefit then begin k:=0; newline; end;
             end;
           end; {for f1}
          if (k>0) or (j=0) then newline;
          printw(codeNameCap[2]+'s: ');  {rooms}
          k:=0; j:=0;
          for f1:=1 to codeCount[2] do
           begin
            f3:=codepoint[f1,2];
            if RoomInAnyFac(f3,i) then
             begin
              inc(k);  inc(j);
              printc(XML_TEACHERS.TeCode[f3,1]+' ');
              if k=codefit then begin k:=0; newline; end;
             end; {if RoomInAnyFac(f3,i)}
           end; {for f1}
          if (k>0) or (j=0) then newline;
         end {case 1:}
     end;  {case}
    end;  {for i  to totalcodes}
    newline;
   printCustomAddon;
  finally; {with OutTeWin}
   OutFaWin.Free;
  end;
end; {main text output}

procedure TFacultyWindow.Change1Click(Sender: TObject);
begin
 if CheckAccessRights(utTime,14,true) then
 begin
  EditFac2:=TEditFac2.create(self);   {allocate dlg}
  EditFac2.showmodal;
  EditFac2.free;
  CheckAccessRights(utTime,14,false);
 end;
end;

procedure TFacultyWindow.PopupMenu1Popup(Sender: TObject);
begin
 change2.Visible:=(usrPasslevel>utGen);
 N6.Visible:=(usrPasslevel>utGen);
end;

procedure TFacultyWindow.Codes1Click(Sender: TObject);
begin
 TickCodeSubMenu(SelectCode1);
 change1.Visible:=(usrPasslevel>utGen);
 N5.Visible:=(usrPasslevel>utGen);
end;

procedure TFacultyWindow.DeleteFaculty(Sender: TObject);
var
  lMSg: string;
  lFacCount: Integer;
  i: Integer;
  k: Integer;
begin
  lMSg := Format('Are you sure you want to delete %s faculty?', [FacName[SelCode]]);
  if MessageDlg(lMSg, mtConfirmation, mbYesNo, 0) = mrYes then
  begin
    FacName[SelCode] := '';
    for i := 1 to nmbrRooms do
    begin
      if i = SelCode then
      begin
        XML_TEACHERS.Rfaculty[i, 1] := -1;
        XML_TEACHERS.Rfaculty[i, 2] := -1;
        XML_TEACHERS.Rfaculty[i, 3] := -1;
      end;
    end;

    for i:= 1 to nmbrTeachers do
      for k := 1 to nmbrTeFacs do
        if XML_TEACHERS.TFaculty[i, k] = SelCode then
          XML_TEACHERS.TFaculty[i, k] := -1;
    for lFacCount := 1 to facCount[SelCode] do
      FacSubs[SelCode, lFacCount] := 0;
    FacCount[SelCode] := 0;
    Dec(FacNum);

    if Self.SelCode = FacNum then
      Dec(Self.SelCode);
    updateFaculty;
    FormResize(nil);
    if Assigned(SuWindow) then
      SuWindow.Refresh;
    if Assigned(RoWindow) then
      RoWindow.Refresh;
    if Assigned(TeWindow) then
      TeWindow.Refresh;

    UpdateWindow(wnInfo);
    Application.ProcessMessages;
  end;
end;

end.
