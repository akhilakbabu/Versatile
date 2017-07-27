unit Clmatrix;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Menus, TimeChartGlobals,ClassDefs,XML.DISPLAY;

type
  Tcmatwin = class(TDrawWin)
    PopupMenu1: TPopupMenu;
    Selection2: TMenuItem;
    N2: TMenuItem;
    PrintSetup1: TMenuItem;
    Print1: TMenuItem;
    Exportastextfile1: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MenuItem3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  protected
    procedure SetTabs; override;
  end;

var
  cmatwin: Tcmatwin;

procedure clmatrixprint;
procedure clmatrixtext;

implementation
uses tcommon,clmatsel,main,stcommon,printers,tcommon2;
{$R *.DFM}

 type TPrintCmatrixWin=class(TPrintDrawWin)
  public
   procedure head; override;
   procedure SetTabs; override;
 end;

 type TOutCmatrixWin=class(TOutputwin)
  public
   procedure head; override;
 end;

var
 PrintCmatrixWin: TPrintCmatrixWin;
 OutCmatrixWin:  TOutCmatrixWin;



procedure Tcmatwin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 action:=caFree;
end;

procedure Tcmatwin.MenuItem3Click(Sender: TObject);
begin
 cmatsel:=Tcmatsel.create(self);   {allocate dlg}
 cmatsel.showmodal;
 cmatsel.free;
end;

procedure Tcmatwin.FormCreate(Sender: TObject);
var
i: integer;
begin
 setWindowDefaults(self,wnCmatrix);
 if XML_DISPLAY.ClashMatrixSelection[0]=-1 then  {all from init}
 begin
  XML_DISPLAY.ClashMatrixSelection[0]:=GroupSubs[0];
  for i:=1 to GroupSubs[0] do
   XML_DISPLAY.ClashMatrixSelection[i]:=GroupSubs[i];
 end;
 if needClashMatrixRecalc then CalculateClashmatrix;
end;

procedure Tcmatwin.SetTabs;
begin
 caption:='Clash Matrix '+GroupCaption;
 SetLength(Tabs,2);
 MaxTab(1,fwcode[0],'999 ');
 MaxW:=longint(XML_DISPLAY.ClashMatrixSelection[0]+1)*Tabs[1]+Hmargin*2;
 MaxH:=longint(XML_DISPLAY.ClashMatrixSelection[0]+3)*txtheight;
end;


procedure Tcmatwin.FormPaint(Sender: TObject);
var
 s:            string;
 i,j:            integer;
begin
 if needClashMatrixRecalc then CalculateClashmatrix;
 fcolor(cpNormal);
 if XML_DISPLAY.ClashMatrixSelection[0]>0 then
  begin
   for i:=0 to XML_DISPLAY.ClashMatrixSelection[0] do
    begin
     for j:=0 to XML_DISPLAY.ClashMatrixSelection[0] do
      begin
       x:=j*(Tabs[1]);
       if (i=0) and (j=0) then continue;
       if (i=0) or (j=0) then  {print subject code}
        begin
         fcolor(cpSub);
         if i=0 then s:=trim(SubCode[XML_DISPLAY.ClashMatrixSelection[j]])
          else s:=SubCode[XML_DISPLAY.ClashMatrixSelection[i]];
        end
       else
        begin {i>0 and j>0 print number}
         if (i=j) then
          begin
           fcolor(cpStList);
           s:=inttostr(GroupSubCount[GsubXref[XML_DISPLAY.ClashMatrixSelection[i]]]);
          end
         else
          begin {i<>j}
           fcolor(cpNormal);
           s:=inttostr(FNcm(GsubXref[XML_DISPLAY.ClashMatrixSelection[i]],GsubXref[XML_DISPLAY.ClashMatrixSelection[j]]));
           end;
        end;
       if j>0 then x:=x+Tabs[1]-canvas.textwidth(s);
       printw(s);   fcolor(cpNormal);
      end; {for j}
     newline;
     if y>bottomCutoff then break;{exit;}
    end; {for i}
  end
 else
  begin
   printw('No subjects selected.');
  end;
 newline;
end;


{--------------------print procs follow------------------------}


procedure TPrintCmatrixWin.head;
begin
 UnderlineOn;
 printwl('Clash Matrix'+GroupCaption);
 printw(PageCount);
 UnderlineOff;
 x:=0; y:=y+2*PrnttxtHeight;
end;

procedure TPrintCmatrixWin.SetTabs;
begin
 SetLength(PrntTabs,3);
 MaxTab(1,fwprntcode[0],'999 ');
 PrntTabs[2]:=fwprntcode[0]+2*prntblankwidth;
end;

procedure clmatrixprint;
var
 s:            string;
 i,j,ii,fitcnt: integer;
 fitstep,fitpages,fitstart:            integer;
begin
 PrintCmatrixWin:=TPrintCmatrixWin.create;
 with PrintCmatrixWin do
  try
   PrintHead;
   fcolor(cpnormal);
   fitcnt:=(PrintPageWidth-prntHmargin-PrntTabs[2]-3*prntblankwidth) div PrntTabs[1];
   if fitcnt<1 then fitcnt:=1;
   if (XML_DISPLAY.ClashMatrixSelection[0]<=fitcnt) then fitpages:=1
     else
      begin
       fitpages:=(XML_DISPLAY.ClashMatrixSelection[0] div fitcnt);
       if (XML_DISPLAY.ClashMatrixSelection[0] mod fitcnt)>0 then inc(fitpages);
      end;
    fitstart:=0;
    fitstep:=fitcnt;
    for ii:=1 to fitpages do
     begin
      if ii>1 then PrintHead;
      if XML_DISPLAY.ClashMatrixSelection[0]>0 then
       begin
        for i:=0 to XML_DISPLAY.ClashMatrixSelection[0] do
         begin
          for j:=fitstart to fitstart+fitstep do
           begin
            if (i>XML_DISPLAY.ClashMatrixSelection[0]) then continue;
            if (j>XML_DISPLAY.ClashMatrixSelection[0]) then continue;
            if j=fitstart then x:=0
             else x:=PrntTabs[2]+(j-fitstart)*(PrntTabs[1]);

            if i=0 then
             begin
               if j>fitstart then
                 begin
                  fcolor(cpSub);
                  s:=trim(SubCode[XML_DISPLAY.ClashMatrixSelection[j]]);
                  x:=x-PrintCanvas.textwidth(s);
                  printw(s); fcolor(cpNormal);
                 end;
             end
            else if j=fitstart then
             begin
              fcolor(cpSub);
              if i>0 then printw(SubCode[XML_DISPLAY.ClashMatrixSelection[i]]);
              fcolor(cpNormal);
             end
            else if i=j then
              begin
               s:=inttostr(GroupSubCount[GsubXref[XML_DISPLAY.ClashMatrixSelection[i]]]);
               x:=x-PrintCanvas.textwidth(s);
               printw(s);
              end
             else
              begin
               s:=inttostr(FNcm(GsubXref[XML_DISPLAY.ClashMatrixSelection[i]],GsubXref[XML_DISPLAY.ClashMatrixSelection[j]]));
               x:=x-PrintCanvas.textwidth(s);
               printw(s);
              end;
           end; {for j}
          newline;
          if y=(prntVmargin+3*prnttxtheight) then {redo headers}
           begin
            for j:=(fitstart+1) to fitstart+fitstep do
             begin
              x:=prnthmargin+PrntTabs[2]+(j-fitstart)*(PrntTabs[1]);
              fcolor(cpSub);
              s:=trim(SubCode[XML_DISPLAY.ClashMatrixSelection[j]]);
              x:=x-PrintCanvas.textwidth(s);
              printw(s);  fcolor(cpNormal);
             end; {for j}
            newline;
           end; {if need new headers}
         end; {for i}
       end
      else
       begin
        printw('No subjects selected.');
       end;
      inc(fitstart,fitcnt{+1});
      fitstep:=fitcnt{+1};
      if (fitstart>XML_DISPLAY.ClashMatrixSelection[0]) then break;
      if (ii<>fitpages) then startnewpage; {not after last page}
    end; {for ii}
   newline;
   printCustomAddon;
  finally
   PrintCmatrixWin.Free;
  end;
end;



{---------------main text proc follows------------------------}

procedure TOutCmatrixWin.head;
begin
 printw('Clash Matrix'+GroupCaption);
 newline; newline;
end;


procedure clmatrixtext;
var
 i,j:        integer;
 s:            string;
begin
 OutCmatrixWin:=TOutCmatrixWin.create;
 with OutCmatrixWin do
  try
   Header;
   if XML_DISPLAY.ClashMatrixSelection[0]>0 then
     begin
      for i:=0 to XML_DISPLAY.ClashMatrixSelection[0] do
       begin
        for j:=0 to XML_DISPLAY.ClashMatrixSelection[0] do
         begin
          if i=0 then
           begin
            if j>0 then
             begin
              s:=SubCode[XML_DISPLAY.ClashMatrixSelection[j]];
              printc(s);
             end;
           end
          else if j=0 then
           begin
            if i>0 then printw(SubCode[XML_DISPLAY.ClashMatrixSelection[i]])
           end
           else if i=j then
            begin
             s:=inttostr(GroupSubCount[GsubXref[XML_DISPLAY.ClashMatrixSelection[i]]]);
             printc(s);
            end
           else
            begin
             s:=inttostr(FNcm(GsubXref[XML_DISPLAY.ClashMatrixSelection[i]],GsubXref[XML_DISPLAY.ClashMatrixSelection[j]]));
             printc(s);
            end;
         end; {for j}
        newline;
       end; {for i}
     end
    else
     begin
      printw('No subjects selected.');
     end;
   newline;
   printCustomAddon;
  finally
   OutCmatrixWin.Free;
  end;

end;


end.
