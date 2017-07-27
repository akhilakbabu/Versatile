unit Subtimes;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Menus, TimeChartGlobals,ClassDefs,GlobalToTcAndTcextra,
  XML.DISPLAY;

type
  TSubjectTimes = class(TDrawWin)
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
  end;

var
  SubjectTimes: TSubjectTimes;

procedure SubjectTimesprint;
procedure SubjectTimesText;


implementation
uses tcommon,main,printers,sutimdlg,tcommon2;
{$R *.DFM}

 type TPrintSuTimesWin=class(TPrintDrawWin)
  public
   procedure head; override;
   procedure SetTabs; override;
  private
   procedure subjectperiod;
 end;

 type TOutSuTimesWin=class(TOutputwin)
  public
   procedure head; override;
  private
   procedure subjectperiod;
 end;

var
 PrintSuTimesWin: TPrintSuTimesWin;
 OutSuTimesWin:  TOutSuTimesWin;
 pfree:             tpSubData;


procedure TSubjectTimes.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 action:=caFree;
end;

procedure TSubjectTimes.FormCreate(Sender: TObject);
begin
 setWindowDefaults(self,wnSuTimes);
 fillchar(pfree,sizeof(pfree),chr(0));
end;

procedure TSubjectTimes.Selection2Click(Sender: TObject);
begin
 Subjecttimesdlg:=TSubjecttimesdlg.create(self);   {allocate dlg}
 Subjecttimesdlg.showmodal;
 Subjecttimesdlg.free;
end;

procedure clearfree;
begin
 fillchar(pfree,sizeof(pfree),chr(0));
end;


procedure TSubjectTimes.SetTabs;
begin
 SetLength(Tabs,3);
 Tabs[1]:=fwcode[0]+canvas.textwidth(' 99W');
 Tabs[2]:=fwClass+canvas.textwidth('  :');
end;

procedure TSubjectTimes.FormPaint(Sender: TObject);

var
 astr:            string;
 i:            integer;
 maxx:                          integer;
 maxxc,maxxlc:                   integer;
 count:                             integer;
 


procedure subjectperiod;
var
 ystart,yend:         integer;
 i,j,a:             integer;
 yeary:           integer;
 aFnt:             tpintpoint;
 num:                   integer;
 infac:                 bool;


   procedure slevel;
   var
    l,d,p,a,i,k:       integer;
    maxxc2:                 integer;
   begin
    maxxc:=0;
    for l:=1 to level[yeary] do
    begin
     if trim(ClassCode[ClassShown[l,yeary]])='' then continue;
     clearfree;
     count:=0;   maxxc2:=0;
     for d:=0 to days-1 do
      for p:=1 to tlimit[d] do
      begin
       aFnt:=FNT(d,p-1,yeary,l,0);
       a:=afnt^;
       if a<=LabelBase then
       begin
        aStr:=copy(SubCode[a],1,2);
        if aStr<>'NA' then
        begin
         infac:=findsubinfac(XML_DISPLAY.subjecttimesfac,a);
         if ((a>0) and infac) then
         begin
          inc(pfree[a]);
          inc(count);
         end;
        end;
       end;
      end; {for p}
     if count=0 then continue;
     fcolor(cpClass);
     printwl(ClassCode[ClassShown[l,yeary]]+': ');
     j:=0;
     k:=numcodes[0];
     for i:=1 to k do
     begin
      a:=pfree[i];
      if a>0 then
      begin
       fcolor(cpSub);
       x:=Tabs[2]+Tabs[1]*j;
       inc(j);
       printw(SubCode[i]);
       x:=x+fwcode[0]+blankwidth;
       fcolor(cpNormal);   inc(maxxc2);
       printw(inttostr(a));
      end;
     end; {for i}
     x:=Tabs[2]+Tabs[1]*j;
     printw('Total '+inttostr(count));
     newline; inc(maxxlc); 
     if maxxc2>maxxc then maxxc:=maxxc2;
    end; {for l}
    newline; inc(maxxlc); 
    i:=Tabs[2]+maxxc*Tabs[1]+hmargin*2+subjecttimes.canvas.textwidth('totals :99');
    if i>maxx then maxx:=i;
   end;


    procedure scount;
    var
     d,p,b,l:         integer;
     aFnt:   tpintpoint;
     aStr:        string;
    begin
     count:=0;
     for d:=0 to days-1 do
      for p:=1 to tlimit[d] do
      begin
       l:=0;
       aFnt:=FNT(d,p-1,yeary,l,0);
       for l:=1 to level[yeary] do
       begin
        inc(aFnt,4);
        b:=aFnt^;
        if b<=LabelBase then
        begin
         aStr:=copy(SubCode[b],1,2);
         if aStr<>'NA' then
         begin
          infac:=findsubinfac(XML_DISPLAY.subjecttimesfac,b);
          if ((b>0) and infac) then
          begin
           inc(pfree[b]);
           inc(count);
          end;
         end;
        end;
       end; {for l}
      end; {for p}
    end;


begin
 fcolor(cpNormal); maxx:=0;
 printw('Subject Times');
 if XML_DISPLAY.subjecttimesyear=years then
 begin
  ystart:=0; yend:=years_minus_1;
 end
 else
  begin
   ystart:=XML_DISPLAY.subjecttimesyear;
   yend:=XML_DISPLAY.subjecttimesyear;
  end;
 maxxc:=0;
 for yeary:=ystart to yend do
 begin
  newline;  inc(maxxlc);
  printw('Year '+yearname[yeary]); newline;  inc(maxxlc);
  clearfree;
  slevel; clearfree;
  scount;
  if count=0 then
  begin
   printw('No subjects');
   newline;  inc(maxxlc);
   continue;
  end;
  maxxc:=0;
  num:=0;
  i:=numcodes[0];
  for j:=1 to i do
  begin
   a:=pfree[j];
   if a>0 then
   begin
    fcolor(cpSub);
    x:=Tabs[1]*num;
    printw(SubCode[j]);
    fcolor(cpNormal);
    x:=x+fwcode[0]+(blankwidth div 2);
    printw(inttostr(a)); inc(num);
    if ((num mod 10)=0) then
    begin
     num:=0;
     newline;   inc(maxxlc);
    end;
   end;
  end; {for j}
  if num>maxxc then maxxc:=num+1;
  newline;  inc(maxxlc);
  printw('Total '+inttostr(count));
  newline; newline;   inc(maxxlc,2);
 end; {for yeary}
 i:=Tabs[1]*10+2*hmargin;
 if i>maxx then maxx:=i;
 i:=subjecttimes.canvas.textwidth('No subjects')+Tabs[2]+2*hmargin;
 if i>maxx then maxx:=i;
 subjecttimes.horzscrollbar.range:=maxx;
 maxx:=integer(txtheight)*(maxxlc+2);
 if maxx>maxwinscrollrange then maxx:=maxwinscrollrange;
 subjecttimes.vertscrollbar.range:=maxx;
end;



begin
 maxxlc:=0;
 fcolor(cpNormal);
 for i:=1 to numcodes[0] do pfree[i]:=i;
 subjectperiod;
end;


{------------------------- printing procs follow ----------------------------------}


procedure TPrintSuTimesWin.head;
begin
 UnderlineOn;
 printwl('Subject Times');
 printw(PageCount);
 UnderlineOff;
 x:=0; y:=y+PrnttxtHeight;
end;

procedure TPrintSuTimesWin.SetTabs;
begin
 SetLength(PrntTabs,3);
 PrntTabs[1]:=fwprntcode[0]+PrintCanvas.textwidth(' 99W');
 PrntTabs[2]:=fwprntClass+PrintCanvas.textwidth('  :');
end;


procedure TPrintSuTimesWin.subjectperiod;
var
 ystart,yend:         integer;
 i,j,a:             integer;
 yeary:           integer;
 aFnt:             tpintpoint;
 num:                   integer;
 infac:                 bool;
 astr:            string;
 count:                             integer;


   procedure slevel;
   var
    l,d,p,a,i,k:       integer;
   begin
    for l:=1 to level[yeary] do
    begin
     if trim(ClassCode[ClassShown[l,yeary]])='' then continue;
     clearfree;
     count:=0;  
     for d:=0 to days-1 do
      for p:=1 to tlimit[d] do
      begin
       aFnt:=FNT(d,p-1,yeary,l,0);
       a:=afnt^;
       if a<=LabelBase then
       begin
        aStr:=copy(SubCode[a],1,2);
        if aStr<>'NA' then
        begin
         infac:=findsubinfac(XML_DISPLAY.subjecttimesfac,a);
         if ((a>0) and infac) then
         begin
          inc(pfree[a]);
          inc(count);
         end;
        end;
       end;
      end; {for p}
     if count=0 then continue;
     fcolor(cpClass);
     printwl(ClassCode[ClassShown[l,yeary]]+': ');
     j:=0;
     k:=numcodes[0];
     for i:=1 to k do
     begin
      a:=pfree[i];

      if a>0 then
      begin
       x:=PrntTabs[2]+PrntTabs[1]*j;
       inc(j); fcolor(cpSub);
       printw(SubCode[i]);
       x:=x+fwprntcode[0]+prntblankwidth;  fcolor(cpNormal);
       printw(inttostr(a));
      end;
     end; {for i}
     x:=PrntTabs[2]+PrntTabs[1]*j; fcolor(cpNormal);
     printw('Total '+inttostr(count));
     newline;
    end; {for l}
    newline;
   end;




    procedure scount;
    var
     d,p,b,l:         integer;
     aFnt:   tpintpoint;
     aStr:        string;
    begin
     count:=0;
     for d:=0 to days-1 do
      for p:=1 to tlimit[d] do
      begin
       l:=0;
       aFnt:=FNT(d,p-1,yeary,l,0);
       for l:=1 to level[yeary] do
       begin
        inc(aFnt,4);
        b:=aFnt^;
        if b<=LabelBase then
        begin
         aStr:=copy(SubCode[b],1,2);
         if aStr<>'NA' then
         begin
          infac:=findsubinfac(XML_DISPLAY.subjecttimesfac,b);
          if ((b>0) and infac) then
          begin
           inc(pfree[b]);
           inc(count);
          end;
         end;
        end;
       end; {for l}
      end; {for p}
    end;




begin
 if XML_DISPLAY.subjecttimesyear=years then
 begin
  ystart:=0; yend:=years_minus_1;
 end
 else
  begin
   ystart:=XML_DISPLAY.subjecttimesyear;
   yend:=XML_DISPLAY.subjecttimesyear;
  end;
 for yeary:=ystart to yend do
 begin
  newline;
  printw('Year '+yearname[yeary]); newline;
  clearfree;
  slevel; clearfree;
  scount;
  if count=0 then
  begin
   printw('No subjects');
   newline; continue;
  end;
  num:=0;
  i:=numcodes[0];
  for j:=1 to i do
  begin
   a:=pfree[j];
   if a>0 then
   begin
    x:=PrntTabs[1]*num;  fcolor(cpSub);
    printw(SubCode[j]);
    x:=x+fwprntcode[0]+(prntblankwidth div 2); fcolor(cpNormal);
    printw(inttostr(a)); inc(num);
    if ((num mod 10)=0) then
    begin
     num:=0;
     newline;
    end;
   end;
  end; {for j}
  newline; fcolor(cpNormal);
  printw('Total '+inttostr(count));
  newline; newline; 
 end; {for yeary}
end;


procedure SubjectTimesprint;
var
 i:        integer;
begin
 PrintSuTimesWin:=TPrintSuTimesWin.create;
 with PrintSuTimesWin do
  try
   PrintHead;
   fcolor(cpnormal);
   for i:=1 to numcodes[0] do pfree[i]:=i;
   subjectperiod;
   newline;
   printCustomAddon;
  finally
   PrintSuTimesWin.Free;
  end;
end;


procedure TSubjectTimes.FormDblClick(Sender: TObject);
begin
 selection2click(self);
end;

procedure TOutSuTimesWin.head;
begin
 printLine(['Subject Times']);
end;

procedure TOutSuTimesWin.subjectperiod;
var
 ystart,yend:         integer;
 i,j,a:             integer;
 yeary:           integer;
 aFnt:             tpintpoint;
 num:                   integer;
 infac:                 bool;
 count:                             integer;

  
 

   procedure slevel;
   var
    l,d,p,a,i,k:       integer;
    astr:            string;
   begin
    for l:=1 to level[yeary] do
    begin
     if trim(ClassCode[ClassShown[l,yeary]])='' then continue;
     clearfree;
     count:=0;
     for d:=0 to days-1 do
      for p:=1 to tlimit[d] do
      begin
       aFnt:=FNT(d,p-1,yeary,l,0);
       a:=afnt^;
       if a<=LabelBase then
       begin
        aStr:=copy(SubCode[a],1,2);
        if aStr<>'NA' then
        begin
         infac:=findsubinfac(XML_DISPLAY.subjecttimesfac,a);
         if ((a>0) and infac) then
         begin
          inc(pfree[a]);
          inc(count);
         end;
        end;
       end;
      end; {for p}
     if count=0 then continue;
     printw(ClassCode[ClassShown[l,yeary]]); printc(': ');
     j:=0;
      k:=numcodes[0];
     for i:=1 to k do
     begin
      a:=pfree[i];

      if a>0 then
      begin
       inc(j);
       printc(SubCode[i]);
       printc(inttostr(a));
      end;
     end; {for i}
     printc('Total '); printc(inttostr(count));
     newline;
    end; {for l}
    newline;
   end;




    procedure scount;
    var
     d,p,b,l:         integer;
     aFnt:   tpintpoint;
     aStr:        string;
    begin
     count:=0;
     for d:=0 to days-1 do
      for p:=1 to tlimit[d] do
      begin
       l:=0;
       aFnt:=FNT(d,p-1,yeary,l,0);
       for l:=1 to level[yeary] do
       begin
        inc(aFnt,4);
        b:=aFnt^;
        if b<=LabelBase then
        begin
         aStr:=copy(SubCode[b],1,2);
         if aStr<>'NA' then
         begin
          infac:=findsubinfac(XML_DISPLAY.subjecttimesfac,b);
          if ((b>0) and infac) then
          begin
           inc(pfree[b]);
           inc(count);
          end;
         end;
        end;
       end; {for l}
      end; {for p}
    end;




begin
 printw('Subject Times');
 if XML_DISPLAY.subjecttimesyear=years then
 begin
  ystart:=0; yend:=years_minus_1;
 end
 else
  begin
   ystart:=XML_DISPLAY.subjecttimesyear;
   yend:=XML_DISPLAY.subjecttimesyear;
  end;
 for yeary:=ystart to yend do
 begin
  newline;
  printw('Year '+yearname[yeary]); newline;
  clearfree;
  slevel; clearfree;
  scount;
  if count=0 then
  begin
   printw('No subjects');
   newline; continue;
  end;
  num:=0; 
  i:=numcodes[0];
  for j:=1 to i do
  begin
   a:=pfree[j];
   if a>0 then
   begin
    printc(SubCode[j]);
    printc(inttostr(a)); inc(num);
    if ((num mod 10)=0) then
    begin
     num:=0;
     newline;
    end;
   end;
  end; {for j}
  newline;
  printc('Total '); printc(inttostr(count));
  newline; newline;
 end; {for yeary}

end;


procedure SubjectTimesText;
var
 i:        integer;
begin
 OutSuTimesWin:=TOutSuTimesWin.create;
 with OutSuTimesWin do
  try
   Header;
   for i:=1 to numcodes[0] do pfree[i]:=i;
   subjectperiod;
   printCustomAddon;
  finally
   OutSuTimesWin.Free;
  end;

end;


end.
