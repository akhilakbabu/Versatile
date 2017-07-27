unit Clashhlp;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Menus, TimeChartGlobals,ClassDefs, GlobalToTcAndTcextra,
  XML.DISPLAY, XML.TEACHERS;

type
  TClashHelp = class(TDrawWin)
    PopupMenu1: TPopupMenu;
    Selection2: TMenuItem;
    N2: TMenuItem;
    PrintSetup1: TMenuItem;
    Print1: TMenuItem;
    Exportastextfile1: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure selection1Click(Sender: TObject);
  protected
    procedure SetTabs; override;
  end;

var
  ClashHelp: TClashHelp;

procedure ClashHelpPrint;
procedure ClashHelptext;

implementation
uses tcommon,ttable,printers,chelp,main,tcommon2;

type TPrintChelpWin=class(TPrintDrawWin)
  public
   procedure head; override;
   procedure SetTabs; override;
 end;

 type TOutChelpWin=class(TOutputwin)
  public
   procedure head; override;
 end;

{$R *.DFM}
var
 PrintChelpWin: TPrintChelpWin;
 OutChelpWin:  TOutChelpWin;
 Nblock,l1,l2,num:  integer;
 TeGroup, RoGroup:  tplevelsub;
 Ntegroup, Nrogroup:  integer;
 CheckPer:       tpFclash;
 Canshow:           bool;



function GroupSwaps(d,p: integer): bool;
var
 te1,te2,ro1,ro2: integer;
 y,l,la:          integer;
 IntPoint:        tpIntPoint;
 found:           bool;
begin
 found:=false;
 for l:=l1 to l2 do
  begin
   Intpoint:=FNT(d,p,chy,l,2);
   te1:=Intpoint^; inc(Intpoint); ro1:=Intpoint^;
   if XML_DISPLAY.chType=0 then ro1:=0;
   if XML_DISPLAY.chType=1 then te1:=0;
   for y:=0 to years_minus_1 do
    begin
     for la:=1 to level[y] do
      begin
       Intpoint:=FNT(chd,chp,y,la,2);
       te2:=Intpoint^; inc(Intpoint); ro2:=Intpoint^;
       if ((te1>0) and (te1=te2)) or ((ro1>0) and (ro1=ro2)) then found:=true;
       if found then break;
      end;
     if found then break;
    end; {y}
   if found then break;
  end; {l}
 result:=not(found);
end;

procedure ClashFree; {clash free times - store in checkper }
var
 d,p,y,l,i:     integer;
 te,ro:         integer;
 found:         bool;
 IntPoint:      tpIntPoint;
begin
 for d:=0 to days-1 do
  begin
   CheckPer[d,0]:=0;
   for p:=0 to Tlimit[d]-1 do
    begin
     found:=false;
     for y:=0 to years_minus_1 do
      begin
       for l:=1 to level[y] do
        begin
         Intpoint:=FNT(d,p,y,l,2);
         te:=Intpoint^; inc(Intpoint); ro:=Intpoint^;
         if (te=0) and (ro=0) then continue;
         if Ntegroup>0 then
          for i:=1 to Ntegroup do
           if (te>0) and (te=TeGroup[i]) then
            begin
             found:=true;
             break;
            end;
         if Nrogroup>0 then
          for i:=1 to Nrogroup do
           if (ro>0) and (ro=RoGroup[i]) then
            begin
             found:=true;
             break;
            end;
         if found then break;
        end;{l}
       if found then break;
      end; {y}
     if not(found) then
      begin
       num:=CheckPer[d,0]+1; CheckPer[d,0]:=num;
       CheckPer[d,num]:=p+1;
       if XML_DISPLAY.chScope<3 then if groupswaps(d,p) then CheckPer[d,num]:=-(p+1);
      end;
    end; {p}
  end; {d}
end;

procedure TClashHelp.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 action:=caFree;
end;

procedure TClashHelp.SetTabs;
var
 te,ro,i,l:             smallint;
 IntPoint:          tpIntPoint;
 maxx2: integer;
 tmpStr: string;
begin
 MaxH:=(days+7)*txtheight;
 maxW:=0;
  case XML_DISPLAY.chtype of
   0:  maxW:=canvas.textwidth('Show Clash Help for Teachers Only')+(2*hmargin);
   1:  maxW:=canvas.textwidth('Show Clash Help for Rooms Only')+(2*hmargin);
   2:  maxW:=canvas.textwidth('Show Clash Help for Teachers and Rooms')+(2*hmargin);
  end; {case}
  tmpstr:=Day[chd]+'  Time: '+inttostr(chp+1)+'  '+yearshort+' '+yearname[chy]+' ';
  case XML_DISPLAY.chScope of
   0: tmpstr:=tmpstr+'Level '+inttostr(chl);
   1: tmpstr:=tmpstr+'Block '+inttostr(Nblock);
  end;
 maxx2:=canvas.textwidth(tmpstr)+(2*hmargin);
 if maxx2>maxW then maxW:=maxx2;

 Ntegroup:=0; Nrogroup:=0;
 l1:=0; l2:=0; Canshow:=False; Nblock:=0;
 if ((chl>0) and (chl<=level[chy]) and (chp>=0) and (chp<=Tlimit[chd])) or (XML_DISPLAY.chScope=3) then
  begin      { ^- check on valid position}
   Case XML_DISPLAY.chScope of
    0: begin  {cell}
        l1:=chl; l2:=chl;
       end;
    1: GetBlockLevels(chd,chp,chy,chl,l1,l2);  {block}
    2: begin              {yr/time}
        l1:=1; l2:=level[chy];
       end;
    3: for i:=1 to 8 do
         begin
          if (chTegroup[i]>0) and (XML_DISPLAY.chType<>1) then
           begin
            inc(Ntegroup); TeGroup[Ntegroup]:=chTegroup[i];
           end;
          if (chrogroup[i]>0) and (XML_DISPLAY.chType<>0)then
           begin
            inc(Nrogroup); RoGroup[Nrogroup]:=chRogroup[i];
           end;
         end;
   end;
   if (l1>0) then
    for l:=l1 to l2 do
     begin
      Intpoint:=FNT(chd,chp,chy,l,2);
      te:=Intpoint^;
      if (te>0) and (XML_DISPLAY.chType<>1) then
       begin
        inc(Ntegroup); TeGroup[Ntegroup]:=te;
       end;
      inc(Intpoint); ro:=Intpoint^;
      if (ro>0) and (XML_DISPLAY.chType<>0) then
       begin
        inc(Nrogroup); RoGroup[Nrogroup]:=ro;
       end;
      i:=FNgetBlockNumber(chd,chp,chy,l);
      if Nblock=0 then Nblock:=i;
     end;
  end; {if valid pos}
 if ((XML_DISPLAY.chtype=0) and (Ntegroup>0)) or ((XML_DISPLAY.chtype=1) and (Nrogroup>0)) or
    ((XML_DISPLAY.chtype=2) and ((Ntegroup+Nrogroup)>0)) then CanShow:=true;
end;


procedure TClashHelp.FormPaint(Sender: TObject);
var
  num: Integer;
  i,d: Integer;
begin
 fcolor(cpNormal);

 if CanShow=False then
  begin
   printw('No teacher or room codes selected');
   exit;
  end;
 ClashFree; fcolor(cpTeach);
 if Ntegroup>0 then
  for i:=1 to Ntegroup do
   printwl(XML_TEACHERS.tecode[TeGroup[i],0]+' ');
 newline;  fcolor(cpRoom);
 if Nrogroup>0 then
  for i:=1 to Nrogroup do
   printwl(XML_TEACHERS.tecode[RoGroup[i],1]+' ');
 newline; newline; fcolor(cpNormal);
 printwl('Show Clash Help for ');
 case XML_DISPLAY.chType of
  0: printw('Teachers Only');
  1: printw('Rooms Only');
  2: printw('Teachers and Rooms');
 end;
 newline;
 if XML_DISPLAY.chScope<3 then
  begin
   printwl(Day[chd]+'  Time: '+inttostr(chp+1)+'  '+yearshort+' '+yearname[chy]+' ');
   case XML_DISPLAY.chScope of
   0: printw('Level '+inttostr(chl));
   1: printw('Block '+inttostr(Nblock));
   end;
  end
 else
  printw('Custom selection');
 newline; newline;
 for d:=0 to days-1 do
  begin
   printw(day[d] + '  '); x:=fwday+blankwidth;
   num:=CheckPer[d,0];
   if num=0 then printw('(none)')
    else
     for i:=1 to num do
      begin
       if CheckPer[d,i] < 0 then
        begin
         canvas.font.color:=clRed;
         canvas.font.style:=canvas.font.style+[fsUnderline];
        end;
       printwl(tsCode[d,(abs(CheckPer[d,i]))-1]);
       canvas.font.color:=clBlack;
       canvas.font.style:=canvas.font.style-[fsUnderline];
       printwl('   ');
      end;
   newline;
  end;
end;

procedure TClashHelp.FormCreate(Sender: TObject);
var
 i,j: integer;
begin
 setWindowDefaults(self,wnCHelp);
 for i:=0 to nmbrLevels do
  begin TeGroup[i]:=0; RoGroup[i]:=0; end;
 for i:=0 to nmbrDays do
  for j:=0 to nmbrPeriods do
   CheckPer[i,j]:=0;
end;

procedure TClashHelp.selection1Click(Sender: TObject);
begin
 ClashHelpDlg:=TClashHelpDlg.create(self);   {allocate dlg}
 ClashHelpDlg.showmodal;
 ClashHelpDlg.free;
end;



{---------------------- printing procs follow --------------------------------------}

procedure TPrintChelpWin.head;
begin
 fcolor(cpNormal);
 UnderlineOn;
 printwl('Clash Help');
 printw(PageCount);
 UnderlineOff;
 x:=0; y:=y+2*PrnttxtHeight;
end;



procedure TPrintChelpWin.SetTabs;
begin
{nothing to do here}
end;

procedure ClashHelpPrint;
var
 num:     integer;
 i,d:       integer;

begin
 PrintChelpWin:=TPrintChelpWin.create;
 with PrintChelpWin do
  try
   PrintHead;
   if CanShow=False then
    begin
     printw('No teacher or room codes selected');
     exit;
    end;
   ClashFree; fcolor(cpTeach);
   if Ntegroup>0 then
    for i:=1 to Ntegroup do
     printwl(XML_TEACHERS.tecode[TeGroup[i],0]+' ');
   newline;  fcolor(cpRoom);
   if Nrogroup>0 then
    for i:=1 to Nrogroup do
     printwl(XML_TEACHERS.tecode[RoGroup[i],1]+' ');
   newline; newline; fcolor(cpNormal);
   printwl('Show Clash Help for ');
   case XML_DISPLAY.chType of
    0: printw('Teachers Only');
    1: printw('Rooms Only');
    2: printw('Teachers and Rooms');
   end;
   newline;
   if XML_DISPLAY.chScope<3 then
    begin
     printwl(Day[chd]+'  Time: '+inttostr(chp+1)+'  '+yearshort+' '+yearname[chy]+' ');
     case XML_DISPLAY.chScope of
     0: printw('Level '+inttostr(chl));
     1: printw('Block '+inttostr(Nblock));
     end;
    end
   else
    printw('Custom selection');
   newline; newline;
   for d:=0 to days-1 do
    begin
     printw(day[d]); x:=prnthmargin+fwprntday+prntblankwidth;
     num:=CheckPer[d,0];
     if num=0 then printw('(none)')
      else
       for i:=1 to num do
        begin
         if CheckPer[d,i]<0 then
          begin
           PrintCanvas.font.color:=clRed;
           PrintCanvas.font.style:=PrintCanvas.font.style+[fsUnderline];
          end;
         printwl(tsCode[d,(abs(CheckPer[d,i]))-1]);
         PrintCanvas.font.color:=clBlack;
         PrintCanvas.font.style:=PrintCanvas.font.style-[fsUnderline];
         printwl('   ');
        end;
     newline;
    end;
   newline;
   printCustomAddon;
  finally
   PrintChelpWin.Free;
  end;
end;

procedure TOutChelpWin.head;
begin
 printw('Clash Help');
 newline; newline;
end;

procedure ClashHelptext;
var
 num:     integer;
 i,d:       integer;
begin
 OutChelpWin:=TOutChelpWin.create;
 with OutChelpWin do
  try
   Header;
   if CanShow=False then
    begin
     printw('No teacher or room codes selected');
     exit;
    end;
   ClashFree;
   if Ntegroup>0 then
    for i:=1 to Ntegroup do
     if i=1 then printw(XML_TEACHERS.tecode[TeGroup[i],0])
      else printc(XML_TEACHERS.tecode[TeGroup[i],0]);
   newline;
   if Nrogroup>0 then
    for i:=1 to Nrogroup do
     if i=1 then printw(XML_TEACHERS.tecode[RoGroup[i],1])
      else printc(XML_TEACHERS.tecode[RoGroup[i],1]);
   newline;
   printw('Show Clash Help for ');
   case XML_DISPLAY.chType of
    0: printw('Teachers Only');
    1: printw('Rooms Only');
    2: printw('Teachers and Rooms');
   end;
   newline;
   if XML_DISPLAY.chScope<3 then
    begin
     printw(Day[chd]+'  Time: '+inttostr(chp+1)+'  '+yearshort+' '+yearname[chy]+' ');
     case XML_DISPLAY.chScope of
     0: printw('Level '+inttostr(chl));
     1: printw('Block '+inttostr(Nblock));
     end;
    end
   else
    printw('Custom selection');
   newline; newline;
   for d:=0 to days-1 do
    begin
     printw(day[d]);
     num:=CheckPer[d,0];
     if num=0 then printc('(none)')
      else
       for i:=1 to num do
        begin
         printc(tsCode[d,(abs(CheckPer[d,i]))-1]);
        end;
     newline;
    end;
   newline;
   printCustomAddon;
  finally
   OutChelpWin.Free;
  end;
end;





end.



