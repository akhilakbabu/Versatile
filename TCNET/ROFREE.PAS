unit Rofree;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Menus, TimeChartGlobals,ClassDefs, GlobalToTcAndTcextra,
  XML.DISPLAY, XML.TEACHERS;

type
  TRoomsFree = class(TDrawWin)
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
  protected
    procedure SetTabs; override;private
  private
   chrwidth:  integer;
   locblankwidth:      integer;
   count,subfit:         integer;
   len,len1,dx: integer;
   ygap:                 integer;
   procedure freesbytimeslot;
   procedure freeRlist;
   procedure Rofrees;
  end;

procedure roomsfreeprint;
procedure RoomsFreetext;

var
  RoomsFree: TRoomsFree;


implementation
uses tcommon,main,rfreedlg,printers,tcommon2;
{$R *.DFM}

 type TPrintRfreeWin=class(TPrintDrawWin)
  public
   procedure head; override;
   procedure SetTabs; override;
  private
   count,subfit:         integer;
   len,len1,dx,chrwidth: integer;
   NewHeading:        boolean;
   ygap,d: smallint;
   chrw,chrw2:                        integer;
   locblankwidth:      integer;
  procedure freesbytimeslot;
  procedure showheader;
  procedure freeRlist;
  procedure rofrees;
  procedure RoFreesHead;
 end;

 type TOutRfreeWin=class(TOutputwin)
  public
   procedure head; override;
  private
   count:         integer;
  procedure freesByTimeslot;
  procedure showheader;
  procedure freeRlist;
  procedure RoFrees;
 end;

const
 mycode=2;

var
  PrintRfreeWin: TPrintRfreeWin;
  OutRfreeWin: TOutRfreeWin;
  pestrt,peend: integer;
  dstrt,dfin:      integer;
  RoLoadInt: array[0..nmbrteachers] of integer;
  RoFound: array[0..nmbrteachers] of integer;
  RoOn: array[0..nmbrteachers,0..nmbrperiods] of integer;
  tmpRange:     longint;
  Dayheight:       array[0..nmbrDays] of integer;


procedure TRoomsFree.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 XML_DISPLAY.Roomsfreeshow1:=winView[wnRoFree]+1;
 action:=caFree;
end;

Function RoomInFac(j:smallint):boolean;
begin
 result:=RoomInAnyFac(j,XML_DISPLAY.roomsfreefac);
end;

procedure calculateloads;
var
 aFnt,bFnt: tpintpoint;
 i,d,p,y,l: integer;
 su,ro: integer;
begin
 for i:=1 to numcodes[2] do RoLoadInt[i]:=0;
 for D:=0 to days-1 do
  for P:=1 to tlimit[d] do
  begin
   for i:=1 to numcodes[2] do RoFound[i]:=0;
   for Y:=0 to years_minus_1 do
   begin
    aFnt:=FNT(D,P-1,Y,0,4);
    for L:=1 to level[Y] do
    begin
     inc(aFnt,4);
     ro:=aFnt^;
     if bool(ro) then
     begin
      bFnt:=aFnt; dec(bFnt,2);
      su:=bFnt^;
      if ((su<>subNA) and (RoFound[ro]=0)) then
      begin
       inc(RoLoadInt[ro]);
       RoFound[ro]:=-1;
      end;
     end;  {if ro}
    end; {for l}
   end; {for y}
  end; {for p}
end;

procedure GetTimeLimits(d:integer);
var
 p: integer;
begin
 if XML_DISPLAY.roomsfreeperiod<1 then
  begin
   pestrt:=1;
   peend:=tlimit[d];
  end
 else
  begin
   p:=XML_DISPLAY.roomsfreeperiod;
   if p>Tlimit[d] then p:=Tlimit[d];
   pestrt:=p; peend:=p;
  end;
end;


procedure TRoomsFree.SetTabs;
var
 k,d,p,yearY,l,maxx: integer;
 aFnt:            tpintpoint;
 dayheightstart:  integer;
 tmpInt,i,j,a,freeend:          integer;
begin
 SetLength(Tabs,5); ygap:=5;
 calculateloads;
 if XML_DISPLAY.roomsfreeday=-1 then begin dstrt:=0; dfin:=days-1; end
  else begin dstrt:=XML_DISPLAY.roomsfreeday; dfin:=XML_DISPLAY.roomsfreeday; end;
 case winView[wnRoFree] of
  0: begin
      Tabs[0]:=fwperiodname+2*blankwidth;
      dx:=fwcode[2]+2*blankwidth+2*canvas.textwidth('99');
      tmpInt:=trunc(screen.width*0.9);
      subfit:= (tmpInt-Tabs[0]) div dx;
      if subfit=0 then subfit:=1;
      Tabs[2]:=Tabs[0]+dx*subfit;
      MaxW:=Tabs[2]+2*hmargin;
      maxx:=5*txtheight;
      for d:=dstrt to dfin do
       begin
        dayheightstart:=maxx;
        maxx:=maxx+txtheight+ygap;
        GetTimeLimits(d);
        for p:=pestrt to peend do
         if XML_DISPLAY.TsOn[d,p-1] then
          begin
           count:=0;
           for k:=1 to numcodes[2] do RoFound[k]:=0;
           for yearY:=0 to years_minus_1 do
            begin
             aFnt:=FNT(d,p-1,yearY,0,4);
             for L:=1 to level[yearY] do
              begin
               inc(aFnt,4);
               j:=aFNt^;
               if (j>0) and (j<=numcodes[2]) then RoFound[j]:=-1;
              end; {for L}
            end; {for yearY}
           maxx:=maxx+txtheight;
           for k:=1 to codeCount[2] do
            begin
             J:=codepoint[K,2];
             if RoomInFac(j)
               then if RoFound[j]=0 then
                begin
                 inc(count);
                 if count>subfit then
                  begin
                   count:=1; maxx:=maxx+txtheight;
                  end;
                end;
            end; {for k}
           if count+1>subfit then maxx:=maxx+txtheight;
           maxx:=maxx+2*ygap;
          end; {if TsOn[d,p-1]}
        maxx:=maxx+2*txtheight;
        dayheight[d]:=maxx-dayheightstart;
       end; {for D}
       MaxH:=maxx
     end;
  2: begin
      chrwidth:=fwTsCode;
      locblankwidth:=canvas.textwidth(' ');
      dx:=periods*chrwidth+2*locblankwidth;
      Tabs[0]:=0;
      MaxTab(1,fwcode[2],'Room');
      MaxTab(2,days*dx,'');
      MaxTab(3,chrwidth*4,'Total ');
      MaxTab(4,chrwidth*4,'Free ');
      MaxW:=Tabs[4]+2*hmargin;
      if XML_DISPLAY.roomsfreeshow2=2 then
        freeend:=XML_DISPLAY.RoomsFreeSelection[0]
       else
         freeend:=codeCount[2];
      a:=0;
      for i:=1 to freeend do
       begin
        if XML_DISPLAY.roomsfreeshow2=2 then
            j:=XML_DISPLAY.RoomsFreeSelection[i]
         else j:=codepoint[i,2];
        if RoomInFac(j) then inc(a);
       end;
      MaxH:=(8+a)*txtheight+(5+2*a)*ygap;
     end;
 end; {case}
end;

procedure TRoomsFree.FormCreate(Sender: TObject);
begin
 setWindowDefaults(self,wnRoFree);
 winView[wnRoFree]:=XML_DISPLAY.roomsfreeshow1-1;
end;

procedure TRoomsFree.Selection2Click(Sender: TObject);
begin
 Roomsfreedlg:=TRoomsfreedlg.create(self);   
 Roomsfreedlg.showmodal;
 Roomsfreedlg.free;
end;


procedure TRoomsFree.freesbytimeslot;
var
 k,y2,d,p,yearY,l: integer;
 j: smallint;
 aFnt:            tpintpoint;
 astr: string;

    procedure showRoomFreecode(J: integer);
    var
     aStr,bStr: string;
     adjust: integer;
    begin
     aStr:=trim(XML_TEACHERS.tecode[J,1]);
     if copy(aStr,1,2)<>'00' then
     begin
      bStr:=inttostr(RoLoadInt[J]);
      len:=canvas.textwidth(aStr+' '+bStr+' ');
      adjust:=len+blankwidth-dx;
      if ((Tabs[1]>Tabs[0]) and (Tabs[1]+len>Tabs[2])) then
      begin
       Tabs[1]:=Tabs[0];
       newline;
      end;
      x:=Tabs[1];
      fcolor(cpRoom);
      printwl(aStr+' ');
      fcolor(cpNormal);
      printwl(bStr+' ');
      inc(count);
      inc(Tabs[1],dx);
      if adjust>0 then inc(Tabs[1],adjust);
     end;
    end;

begin
 for d:=dstrt to dfin do
  begin
   if (y+dayheight[d])<TopCutoff then
    begin
     inc(y,dayheight[d]);
     continue;
    end;
   if XML_DISPLAY.roomsfreefac>0 then
        printwl(facname[XML_DISPLAY.roomsfreefac]+' ');
   printw('Rooms Free - '+dayname[D]);
   newline;
   drawmyline(x,y+txtheight,x+Tabs[2],y+txtheight);  y2:=y+txtheight;
   newline; inc(y,ygap-txtheight);
   GetTimeLimits(d);
   for p:=pestrt to peend do
    if XML_DISPLAY.TsOn[d,p-1] then
     begin
      count:=0;
      for k:=1 to numcodes[2] do RoFound[k]:=0;
      for yearY:=0 to years_minus_1 do
       begin
        aFnt:=FNT(d,p-1,yearY,0,4);
        for L:=1 to level[yearY] do
         begin
          inc(aFnt,4);
          j:=aFNt^;
          if (j>0) and (j<=numcodes[2]) then RoFound[j]:=-1;
         end; {for L}
       end; {for yearY}
      Tabs[1]:=Tabs[0];
      newline;
      printw(' '+TimeSlotName[d,P-1]);
      x:=Tabs[0];
      for k:=1 to codeCount[2] do
       begin
        J:=codepoint[K,2];
        if RoomInFac(j) then if RoFound[j]=0 then showRoomfreecode(J);
       end; {for k}
      aStr:='Total: '+inttostr(count);
      len:=canvas.textwidth(aStr);
      if Tabs[1]+len>Tabs[2] then
       begin
        newline;
        Tabs[1]:=Tabs[0];
        x:=Tabs[0];
       end;
      x:=Tabs[1];
      printw(aStr);
      newline; inc(y,ygap-txtheight);
      drawmyline(x,y+txtheight,x,y2);
      drawmyline(x+Tabs[0]-blankwidth,y+txtheight,x+Tabs[0]-blankwidth,y2);
      drawmyline(x+Tabs[2],y+txtheight,x+Tabs[2],y2);
      drawmyline(x,y+txtheight,x+Tabs[2],y+txtheight); y2:=y+txtheight;
      newline; inc(y,ygap-txtheight);
      if y>bottomCutoff then break;
     end; {if TsOn[d,p-1]}
   if y>bottomCutoff then break;
   newline; newline;
  end; {for D}
end;


procedure FindRoInTime(d,p,j:integer; var found,NAfound: boolean);
var
 aFnt,bFnt: tpintpoint;
 l,yeary:         integer;
begin
 found:=false; NAfound:=false;
 for yearY:=0 to years_minus_1 do
  begin
   aFnt:=FNT(d,p,yeary,0,0);
   for l:=1 to level[yeary] do
    begin
     inc(aFnt,4);
     bFnt:=aFnt; inc(bFnt,2);
     if bFnt^=j then
      begin
       found:=true;
       if bool(subNA) then
         if subNA=aFnt^ then NAfound:=true;
       break;
      end;
    end; {for l}
   if bool(found) then break;
  end; {for yearY}
end;


procedure TRoomsFree.freeRlist;
label
 freeRlistday;
var
 astr:  string;
 d,p,k,j:     integer;
 freet: integer;
 oktoshow,found,NAfound: boolean;
 freeend:      integer;
begin
 fcolor(cpNormal);
 if (XML_DISPLAY.roomsfreefac>0) then
  printwl(facname[XML_DISPLAY.roomsfreefac]+' ');
 printw('Rooms Free');
 newline;
 if codeCount[mycode]=0 then
 begin
  printw('No Rooms entered.');
  exit;
 end;
 if ((XML_DISPLAY.roomsfreeshow2=2) and (XML_DISPLAY.RoomsFreeSelection[0]=0)) then
 begin
  printw('No Rooms selected.');
  exit;
 end;
  inc(y,ygap); drawmyline(x,y,x+Tabs[4],y);
  drawmyline(x,y,x,y+txtheight+ygap*2);
  drawmyline(Tabs[1],y,Tabs[1],y+txtheight+ygap*2);
  drawmyline(Tabs[2],y,Tabs[2],y+txtheight+ygap*2);
  drawmyline(Tabs[3],y,Tabs[3],y+txtheight+ygap*2);
  drawmyline(Tabs[4],y,Tabs[4],y+txtheight+ygap*2);
  drawmyline(x,y+txtheight+ygap*2,x+Tabs[4],y+txtheight+ygap*2);
  inc(y,ygap);
  for d:=0 to days-1 do
   drawmyline(Tabs[1]+d*dx,y-ygap,Tabs[1]+d*dx,y+txtheight+ygap);
 x:=x+locblankwidth;
 printw('Room');
 for d:=0 to days-1 do
 begin
  x:=Tabs[1]+dx*d+locblankwidth;
  astr:=dayname[d];
freeRlistday:
  len:=length(astr);
  len1:=canvas.textwidth(astr);
  if ((len1>1) and ((len1+locblankwidth)>dx)) then
  begin
   astr:=copy(astr,1,len-1);
   goto freeRlistday;
  end;
  printw(astr);
 end; {for d}
 x:=Tabs[2]+locblankwidth; printw('Total');
 x:=Tabs[3]+locblankwidth; printw('Free');
 newline;
    inc(y,ygap); drawmyline(x,y,x+Tabs[4],y);
    drawmyline(x,y,x,y+txtheight+ygap*2);
    drawmyline(Tabs[1],y,Tabs[1],y+txtheight+ygap*2);
    drawmyline(Tabs[2],y,Tabs[2],y+txtheight+ygap*2);
    drawmyline(Tabs[3],y,Tabs[3],y+txtheight+ygap*2);
    drawmyline(Tabs[4],y,Tabs[4],y+txtheight+ygap*2);
    drawmyline(x,y+txtheight+ygap*2,x+Tabs[4],y+txtheight+ygap*2);
    inc(y,ygap);
    for d:=0 to days-1 do
     drawmyline(Tabs[1]+d*dx,y-ygap,Tabs[1]+d*dx,y+txtheight+ygap);
 for d:=0 to days-1 do
  for p:=0 to tlimit[d]-1 do
   begin
    x:=Tabs[1]+d*dx+chrwidth*(p)+locblankwidth;
    printw(tsCode[d,p]);
   end; {for p}
 newline;
 inc(y,ygap); drawmyline(x,y,x+Tabs[4],y);
 if XML_DISPLAY.roomsfreeshow2=2 then
  freeend:=XML_DISPLAY.RoomsFreeSelection[0]
 else
   freeend:=codeCount[mycode];
 for k:=1 to freeend do
 begin
  if y>bottomCutoff then break;
  fcolor(cpNormal);
  if XML_DISPLAY.roomsfreeshow2=2 then j:=XML_DISPLAY.RoomsFreeSelection[k]
   else j:=codepoint[k,2];
  count:=0; freet:=0; 
  oktoshow:=RoomInFac(j);
  if oktoshow and ((y+txtheight+2*ygap)<TopCutoff) then
   begin
    inc(y,txtheight+2*ygap);
    continue;
   end;
  if oktoshow then
   begin
    drawmyline(x,y,x,y+txtheight+ygap*2);
    drawmyline(Tabs[1],y,Tabs[1],y+txtheight+ygap*2);
    drawmyline(Tabs[2],y,Tabs[2],y+txtheight+ygap*2);
    drawmyline(Tabs[3],y,Tabs[3],y+txtheight+ygap*2);
    drawmyline(Tabs[4],y,Tabs[4],y+txtheight+ygap*2);
    drawmyline(x,y+txtheight+ygap*2,x+Tabs[4],y+txtheight+ygap*2);
    inc(y,ygap);
    x:=(Tabs[1] div 2)-(canvas.textwidth(XML_TEACHERS.tecode[j,1]) div 2);
    fcolor(cpRoom);
    printw(XML_TEACHERS.tecode[j,1]); fcolor(cpNormal);
    for d:=0 to days-1 do
    begin
     drawmyline(Tabs[1]+d*dx,y-ygap,Tabs[1]+d*dx,y+txtheight+ygap);
     for p:=0 to tlimit[d]-1 do
     begin
      x:=Tabs[1]+chrwidth*(p)+d*dx+locblankwidth;
      FindRoInTime(d,p,j,found,NAfound);
      if not(found) then
      begin
       freet:=freet+1;
       fcolor(cpBlockClash);
       printwl('_');  fcolor(cpNormal);
      end
      else
       begin
        if NAfound then printwl('N')
        else
         begin
          inc(count);
          printwl(tsCode[d,p]);
         end;
       end;
     end; {for p}
    end; {for d}

    x:=Tabs[3]-(self.canvas.textwidth(inttostr(count))+locblankwidth);
    printw(inttostr(count));
    astr:=inttostr(freet);
    x:=Tabs[4]-(canvas.textwidth(astr)+locblankwidth);
    printw(astr);
    newline;
    inc(y,ygap);
   end;
 end; {for K}
end;

procedure TRoomsFree.Rofrees;
var
 i,p,a,d,p1,ro,l,f,c:     integer;
 ropoint,roprint:      tpPeriodData;
 yearY:                integer;
 aFnt,bFnt:            tpintpoint;
 found,doroprint,lineprinted: integer;
 chrw,chrw2:                        integer;
 yp1,yp2:                     integer;
 cc:                          integer;


      procedure nextRoom;
      begin
       a:=0;
       while a=0 do
       begin
        inc(ropoint[p]);
        ro:=ropoint[p];
        a:=0;
        if ropoint[p]>codeCount[2] then exit;
        if ((tlimit[d]-RoOn[ro,0])=p1) and (RoOn[ro,p]=0) then a:=ro;
        if (ro=0) or (ord(XML_TEACHERS.tecode[ro,1][1])=48) then a:=0;
       end;
      end; {end local proc}

      procedure roprintproc;
      var
       p,al:       integer;
       astr:    string;
      begin
       newline;
       inc(y,ygap); drawmyline(x,y,x+chrw2+chrw*(tlimit[d]),y); inc(y,ygap);
       printwl(' Times');
       for p:=0 to tlimit[d]-1 do
        begin
         astr:=copy(TimeSlotName[d,p],1,7);
         al:=canvas.textwidth(astr) div 2;
         x:=chrw2+chrw*p+(chrw div 2)-al;
         printw(astr);
        end; {for p}
       drawmyline(0,y-ygap,0,y+txtheight+ygap);
       for p:=0 to tlimit[d] do
        drawmyline(chrw2+chrw*p,y-ygap,chrw2+chrw*p,y+txtheight+ygap);
       newline;
       inc(y,ygap); drawmyline(0,y,chrw2+chrw*tlimit[d],y);
      end; {end local proc}


begin    {start of main proc}
 fcolor(cpNormal);   lineprinted:=0;
 chrw:=canvas.textwidth('W')*(lencodes[2]+2);
 chrw2:=canvas.textwidth(' Times ');
 tmpRange:=chrw2+chrw*(periods)+2*hmargin;
 roomsfree.horzscrollbar.range:=tmpRange;

 for d:=dstrt to dfin do
 begin
  for i:=1 to numcodes[mycode] do
   for p:=0 to periods do RoOn[i,p]:=0;

  for p:=1 to tlimit[d] do
   for yearY:=0 to years_minus_1 do
   begin
    l:=0;
    aFnt:=FNT(d,p-1,yearY,l,0);
    for L:=1 to level[yearY] do
    begin
     inc(aFnt,4); bfnt:=afnt; inc(bfnt,2);
     ro:=bfnt^;
     if RoOn[ro,p]=0 then
     begin
      inc(RoOn[ro,p]);
      inc(RoOn[ro,0]);
     end;
    end; {for L}
   end; {for yearY}
  f:=chrw2+chrw*(tlimit[d]);
  c:=1;
  inc(y,ygap);
  printw('Rooms Free - '+dayname[d]);
  newline;
  roprintproc;
  for p1:=tlimit[d] downto 1 do
  begin
   yp1:=y;
   drawmyline(x,y,x+chrw2+chrw*(tlimit[d]),y); inc(y,ygap);
   for p:=0 to periods do
    ropoint[p]:=0;
   x:=(chrw2 div 2)-canvas.textwidth('W');
   printw(inttostr(p1));
   cc:=0;
   for i:=1 to codeCount[mycode] do
   begin
    found:=0;
    lineprinted:=0;
    for p:=1 to tlimit[d] do
    begin
     nextroom;
     roprint[p]:=a;
     if a>0 then found:=-1;
    end; {for p}
    if bool(found) then
    begin
     for p:=1 to tlimit[d] do
     begin
      if roprint[p]>0 then
      begin
       fcolor(cpRoom);
       x:=chrw2+chrw*(p-1)+(chrw div 2)-(canvas.textwidth(XML_TEACHERS.tecode[roprint[p],1]) div 2);
       printw(XML_TEACHERS.tecode[roprint[p],1]);  fcolor(cpNormal);
       lineprinted:=-1;
       cc:=1;
      end;
     end; {for p}
     x:=f;
     newline;
    end {if found}
    else
     begin
      break;
     end; {not found}
   end; {for i}
   if not(bool(lineprinted)) then
   begin
    if cc=0 then newline;
   end; {not lineprinted}
   inc(y,ygap);
   yp2:=y; drawmyline(x,y,x+chrw2+chrw*(tlimit[d]),y);
   drawmyline(0,yp1,0,yp2);
   for p:=1 to (tlimit[d]+1) do
    drawmyline(chrw2+chrw*(p-1),yp1,chrw2+chrw*(p-1),yp2);
  end; {for p1}
 end; {for d}
end;


procedure TRoomsFree.FormPaint(Sender: TObject);
begin
 fcolor(cpNormal);
 case winView[wnRoFree] of
  0: freesbytimeslot;
  1: begin
      rofrees;
      vertscrollbar.range:=y+Vscroll+3*txtHeight;
     end;
  2: freeRlist;
 end; {case}
end;


{------------------ print procs follow ---------------------------------------------}

procedure TPrintRfreeWin.head;
begin
 fcolor(cpNormal);
 UnderlineOn;
 printwl('Rooms Free');
 printw(PageCount);
 UnderlineOff;
 x:=0; y:=y+2*PrnttxtHeight;
 if mypagenumber>1 then
  case winView[wnRoFree] of
   0: if not(newheading) then drawmyline(x,y-ygap,x+PrntTabs[2],y-ygap);
   1: if not(newheading) then begin rofreesHead; inc(y,ygap); end;
   2: showheader;
 end; {case}
end;

procedure TPrintRfreeWin.showheader;
label freeRlistday;
var
 d,p: integer;
 astr: string;
begin
 inc(y,ygap); drawmyline(x,y,x+PrntTabs[4],y);
 drawmyline(x,y,x,y+prnttxtheight+ygap*2);
 drawmyline(PrntTabs[1],y,PrntTabs[1],y+prnttxtheight+ygap*2);
 drawmyline(PrntTabs[2],y,PrntTabs[2],y+prnttxtheight+ygap*2);
 drawmyline(PrntTabs[3],y,PrntTabs[3],y+prnttxtheight+ygap*2);
 drawmyline(PrntTabs[4],y,PrntTabs[4],y+prnttxtheight+ygap*2);
 drawmyline(x,y+prnttxtheight+ygap*2,x+PrntTabs[4],y+prnttxtheight+ygap*2);
 inc(y,ygap);
 for d:=0 to days-1 do
  drawmyline(PrntTabs[1]+d*dx,y-ygap,PrntTabs[1]+d*dx,y+prnttxtheight+ygap);
 x:=x+locblankwidth;
 printw('Room');
 for d:=0 to days-1 do
  begin
   x:=PrntTabs[1]+dx*d+locblankwidth;
   astr:=dayname[d];
   freeRlistday:
   len:=length(astr);
   len1:=PrintCanvas.textwidth(astr);
   if ((len1>1) and ((len1+locblankwidth)>dx)) then
    begin
     astr:=copy(astr,1,len-1);
     goto freeRlistday;
    end;
   printw(astr);
  end; {for d}
  x:=PrntTabs[2]+locblankwidth; printw('Total');
  x:=PrntTabs[3]+locblankwidth; printw('Free');
  x:=0; y:=y+prnttxtheight;
  inc(y,ygap); drawmyline(x,y,x+PrntTabs[4],y);
  drawmyline(x,y,x,y+prnttxtheight+ygap*2);
  drawmyline(PrntTabs[1],y,PrntTabs[1],y+prnttxtheight+ygap*2);
  drawmyline(PrntTabs[2],y,PrntTabs[2],y+prnttxtheight+ygap*2);
  drawmyline(PrntTabs[3],y,PrntTabs[3],y+prnttxtheight+ygap*2);
  drawmyline(PrntTabs[4],y,PrntTabs[4],y+prnttxtheight+ygap*2);
  drawmyline(x,y+prnttxtheight+ygap*2,x+PrntTabs[4],y+prnttxtheight+ygap*2);
  inc(y,ygap);
  for d:=0 to days-1 do
   drawmyline(PrntTabs[1]+d*dx,y-ygap,PrntTabs[1]+d*dx,y+prnttxtheight+ygap);
  for d:=0 to days-1 do
   for p:=0 to tlimit[d]-1 do
    begin
     x:=PrntTabs[1]+d*dx+chrwidth*(p)+locblankwidth;
     printw(tsCode[d,p]);
    end; {for p}
  x:=0; y:=y+prnttxtheight;
  inc(y,ygap); drawmyline(x,y,x+PrntTabs[4],y);
 end;

procedure TPrintRfreeWin.SetTabs;
var
 tmpInt:          integer;
begin
 SetLength(PrntTabs,5);
 ygap:=prnttxtheight div 5;
 case winView[wnRoFree] of
  0: begin
      PrntTabs[0]:=fwprntperiodname+2*prntblankwidth;
      dx:=fwprntcode[2]+2*prntblankwidth+2*PrintCanvas.textwidth('99');
      tmpInt:=trunc(PrintPagewidth*0.9)-prntHmargin;
      subfit:= (tmpInt-PrntTabs[0]) div dx;
      if subfit=0 then subfit:=1;
      PrntTabs[2]:=PrntTabs[0]+dx*subfit;
     end;
  2: begin
      chrwidth:=fwprntTsCode;
      locblankwidth:=PrintCanvas.textwidth(' ');
      dx:=periods*chrwidth+2*locblankwidth;
      MaxTab(1,fwcode[1],'Room');
      MaxTab(2,days*dx,'');
      MaxTab(3,chrwidth*4,'Total ');
      MaxTab(4,chrwidth*4,'Free ');
     end;
 end; {case}
end;


procedure TPrintRfreeWin.freesbytimeslot;
var
 k,p,d1,yearY,l: integer;
 j: smallint;
 astr: string;
 aFnt:            tpintpoint;

    procedure showRoomfreecode(J: integer);
    var
     aStr,bStr: string;
     adjust: integer;
    begin
     aStr:=trim(XML_TEACHERS.tecode[J,1]);
     if copy(aStr,1,2)<>'00' then
     begin
      bStr:=inttostr(RoLoadInt[J]);
      len:=PrintCanvas.textwidth(aStr+' '+bStr+' ');
      adjust:=len+prntblankwidth-dx;
      if ((PrntTabs[1]>PrntTabs[0]) and (PrntTabs[1]+len>PrntTabs[2])) then
      begin
       PrntTabs[1]:=PrntTabs[0];
       x:=0; inc(y,ygap);
       drawmyline(x,y-2*ygap,x,y+prnttxtheight);
       drawmyline(x+PrntTabs[0]-prntblankwidth,y-2*ygap,x+PrntTabs[0]-prntblankwidth,y+prnttxtheight);
       drawmyline(x+PrntTabs[2],y-2*ygap,x+PrntTabs[2],y+prnttxtheight);
       x:=0; inc(y,ygap);
       newline;
      end;
      x:=PrntTabs[1]; fcolor(cpRoom); printwl(aStr+' ');
      fcolor(cpNormal); printwl(bStr+' ');
      inc(count);
      inc(PrntTabs[1],dx);
      if adjust>0 then inc(PrntTabs[1],adjust);
     end;
    end;

begin
 newheading:=true;
 for d1:=dstrt to dfin do
  begin
   d:=d1;
   if XML_DISPLAY.roomsfreefac>0 then printwl(facname[XML_DISPLAY.roomsfreefac]+' ');
   printw(dayname[D]);
   newline;
   inc(y,ygap); newheading:=false;
   GetTimeLimits(d);
   for p:=pestrt to peend do
    if XML_DISPLAY.TsOn[d,p-1] then
     begin
      drawmyline(x,y+prnttxtheight,x+PrntTabs[2],y+prnttxtheight);
      newline; inc(y,ygap-prnttxtheight);
      count:=0;
      for k:=1 to numcodes[mycode] do RoFound[k]:=0;
      for yearY:=0 to years_minus_1 do
       begin
        aFnt:=FNT(d,p-1,yearY,0,4);
        for L:=1 to level[yearY] do
         begin
          inc(aFnt,4);
          j:=aFNt^;
          if (j>0) and (j<=numcodes[mycode]) then RoFound[j]:=-1;
         end; {for L}
       end; {for yearY}
      PrntTabs[1]:=PrntTabs[0];
      newline;
      printw(' '+TimeSlotName[d,P-1]);
      x:=PrntTabs[0];
      for k:=1 to codeCount[mycode] do
       begin
        J:=codepoint[K,mycode];
        if RoomInFac(j) then if RoFound[j]=0 then showRoomfreecode(J);
       end; {for k}
      aStr:='Total: '+inttostr(count);
      len:=PrintCanvas.textwidth(aStr);
      if PrntTabs[1]+len>PrntTabs[2] then
       begin
        x:=0; inc(y,ygap);
        drawmyline(x,y-2*ygap,x,y+prnttxtheight);
        drawmyline(x+PrntTabs[0]-prntblankwidth,y-2*ygap,x+PrntTabs[0]-prntblankwidth,y+prnttxtheight);
        drawmyline(x+PrntTabs[2],y-2*ygap,x+PrntTabs[2],y+prnttxtheight);
        newline;
        PrntTabs[1]:=PrntTabs[0];
        x:=PrntTabs[0];
       end;
      x:=PrntTabs[1];
      printw(aStr);
      x:=0; inc(y,ygap);
      drawmyline(x,y-2*ygap,x,y+prnttxtheight);
      drawmyline(x+PrntTabs[0]-prntblankwidth,y-2*ygap,x+PrntTabs[0]-prntblankwidth,y+prnttxtheight);
      drawmyline(x+PrntTabs[2],y-2*ygap,x+PrntTabs[2],y+prnttxtheight);
      drawmyline(x,y+prnttxtheight,x+PrntTabs[2],y+prnttxtheight);
     end; {if TsOn[d,p-1]}
   newheading:=true;
   newline; newline;
   printCustomAddon;
   if (XML_DISPLAY.formfeed or (y>(PrintPageHeight-6*prnttxtheight))) and (d<dfin) then
        begin  startnewPage; PrintHead; end
       else  newline;
  end; {for D}
end;

procedure TPrintRfreeWin.freeRlist;
var
 astr:  string;
 d1,p,k:     integer;
 found,NAfound: boolean;
 j:         smallint;
 freestrt,freeend:      integer;
 freet: integer;

begin
 if (XML_DISPLAY.roomsfreefac>0) then
  begin
   printwl(facname[XML_DISPLAY.roomsfreefac]+' ');
   printw('Rooms Free');
   newline;
  end;
 if codeCount[mycode]=0 then
 begin
  printw('No Rooms entered.');
  exit;
 end;
 if ((XML_DISPLAY.roomsfreeshow2=2) and (XML_DISPLAY.RoomsFreeSelection[0]=0)) then
 begin
  printw('No Rooms selected.');
  exit;
 end;
 showheader;
 freestrt:=1;
 if XML_DISPLAY.roomsfreeshow2=2 then
  freeend:=XML_DISPLAY.RoomsFreeSelection[0]
 else
   freeend:=codeCount[mycode];
 for k:=freestrt to freeend do
 begin
  if XML_DISPLAY.roomsfreeshow2=2 then
        j:=XML_DISPLAY.RoomsFreeSelection[k]
   else j:=codepoint[k,mycode];
  count:=0; freet:=0;
  if RoomInFac(j) then
   begin
    drawmyline(x,y,x,y+prnttxtheight+ygap*2);
    drawmyline(PrntTabs[1],y,PrntTabs[1],y+prnttxtheight+ygap*2);
    drawmyline(PrntTabs[2],y,PrntTabs[2],y+prnttxtheight+ygap*2);
    drawmyline(PrntTabs[3],y,PrntTabs[3],y+prnttxtheight+ygap*2);
    drawmyline(PrntTabs[4],y,PrntTabs[4],y+prnttxtheight+ygap*2);
    drawmyline(x,y+prnttxtheight+ygap*2,x+PrntTabs[4],y+prnttxtheight+ygap*2);
    inc(y,ygap);
    x:=(PrntTabs[1] div 2)-(PrintCanvas.textwidth(XML_TEACHERS.tecode[j,1]) div 2);
    fcolor(cpRoom); printw(XML_TEACHERS.tecode[j,1]); fcolor(cpNormal);
    for d1:=0 to days-1 do
    begin
     d:=d1;
     drawmyline(PrntTabs[1]+d*dx,y-ygap,PrntTabs[1]+d*dx,y+prnttxtheight+ygap);
     for p:=0 to tlimit[d]-1 do
     begin
      x:=PrntTabs[1]+chrwidth*(p)+d*dx+locblankwidth;
      FindRoInTime(d,p,j,found,NAfound);
      if not(found) then
      begin
       inc(freet);
       fcolor(cpBlockClash);
       printwl('_');  fcolor(cpNormal);
      end
      else
       begin
        if NAfound then printwl('N')
        else
         begin
          inc(count);
          printwl(tsCode[d,p]);
         end;
       end;
     end; {for p}
    end; {for d}
    x:=PrntTabs[3]-(PrintCanvas.textwidth(inttostr(count))+locblankwidth);
    printw(inttostr(count));
    astr:=inttostr(freet);
    x:=PrntTabs[4]-(PrintCanvas.textwidth(astr)+locblankwidth);
    printw(astr);
    newline;
    inc(y,ygap);
   end;

 end; {for K}
 printCustomAddon;
end;

procedure TPrintRfreeWin.RoFreesHead;
var
 p,al:       integer;
 astr:    string;
begin
 newline;
 inc(y,ygap); drawmyline(x,y,x+chrw2+chrw*(tlimit[d]),y); inc(y,ygap);
 printwl(' Times');
 for p:=0 to tlimit[d]-1 do
  begin
   astr:=copy(TimeSlotName[d,p],1,7);
   al:=PrintCanvas.textwidth(astr) div 2;
   x:=chrw2+chrw*p+(chrw div 2)-al;
   printw(astr);
  end; {for p}
 drawmyline(0,y-ygap,0,y+prnttxtheight+ygap);
 for p:=0 to tlimit[d] do
  drawmyline(chrw2+chrw*p,y-ygap,chrw2+chrw*p,y+prnttxtheight+ygap);
 newline;
 inc(y,ygap); drawmyline(0,y,chrw2+chrw*tlimit[d],y);
end; {end local proc}

procedure TPrintRfreeWin.rofrees;
var
 i,p,d1,a,p1,ro,l,f,c:     integer;
 ropoint,roprint:      array[0..nmbrperiods] of integer;
 yearY:                integer;
 aFnt,bFnt:            tpintpoint;
 found,doroprint,lineprinted: integer;
 yp1,yp2:                     integer;
 cc:                          integer;
 pestrt,peend: integer;


      procedure nextRoom;
      begin
       a:=0;
       while a=0 do
       begin
        inc(ropoint[p]);
        ro:=ropoint[p];
        a:=0;
        if ropoint[p]>codeCount[2] then exit;
        if ((tlimit[d]-RoOn[ro,0])=p1) and (RoOn[ro,p]=0) then a:=ro;
        if (ro=0) or (ord(XML_TEACHERS.tecode[ro,1][1])=48) then a:=0;
       end;
      end; {end local proc}




begin    {start of main proc}
 lineprinted:=0;
 chrw:=PrintCanvas.textwidth('W')*(lencodes[1]+2);
 chrw2:=PrintCanvas.textwidth(' Times ');
 for d1:=dstrt to dfin do
 begin
  d:=d1; newheading:=false;
  for i:=1 to numcodes[mycode] do
   for p:=0 to periods do
    RoOn[i,p]:=0;
    pestrt:=1;
    peend:=tlimit[d];
  for p:=pestrt to peend do
   for yearY:=0 to years_minus_1 do
   begin
    l:=0;
    aFnt:=FNT(d,p-1,yearY,l,0);
    for L:=1 to level[yearY] do
    begin
     inc(aFnt,4); bfnt:=afnt; inc(bfnt,2);
     ro:=bfnt^;
     if RoOn[ro,p]=0 then
     begin
      inc(RoOn[ro,p]);
      inc(RoOn[ro,0]);
     end;
    end; {for L}
   end; {for yearY}
  f:=chrw2+chrw*(tlimit[d]);
  c:=1;
  inc(y,ygap);
  printw(dayname[d]);
  newline;
  RoFreesHead;
  for p1:=peend downto pestrt do
  begin
   drawmyline(x,y,x+chrw2+chrw*(tlimit[d]),y); inc(y,ygap);
   for p:=0 to periods do
    ropoint[p]:=0;
   x:=(chrw2 div 2)-PrintCanvas.textwidth('W');
   printw(inttostr(p1));
   cc:=0;
   for i:=1 to codeCount[mycode] do
   begin
    found:=0;
    lineprinted:=0;
    for p:=pestrt to peend do
    begin
     nextRoom;
     roprint[p]:=a;
     if a>0 then found:=-1;
    end; {for p}
    if bool(found) then
    begin
     for p:=pestrt to peend do
     begin
      if roprint[p]>0 then
      begin
       x:=chrw2+chrw*(p-1)+(chrw div 2)-(PrintCanvas.textwidth(XML_TEACHERS.tecode[roprint[p],1]) div 2);
       fcolor(cpRoom); printw(XML_TEACHERS.tecode[roprint[p],1]); fcolor(cpNormal);
       lineprinted:=-1;
       cc:=1;
      end;
     end; {for p}
     x:=f;
     drawmyline(0,y-ygap,0,y+ygap+prnttxtheight);
     for p:=pestrt to (peend+1) do
      drawmyline(chrw2+chrw*(p-1),y-ygap,chrw2+chrw*(p-1),y+ygap+prnttxtheight);
     newline;
    end {if found}
    else
     begin
      break;
     end; {not found}
   end; {for i}
   if not(bool(lineprinted)) then
   begin
    if cc=0 then newline;
   end; {not lineprinted}
   if cc=0 then
   begin
     drawmyline(0,y-ygap-prnttxtheight,0,y+ygap);
     for p:=pestrt to (peend+1) do
      drawmyline(chrw2+chrw*(p-1),y-ygap-prnttxtheight,chrw2+chrw*(p-1),y+ygap);
   end;
   inc(y,ygap);
   drawmyline(x,y,x+chrw2+chrw*(tlimit[d]),y);
  end; {for p1}
  printCustomAddon;
  newheading:=true;
  if (XML_DISPLAY.formfeed or (y>(PrintPageHeight-6*prnttxtheight))) and (d<dfin) then
        begin  startnewPage; PrintHead; end
       else  newline;
 end; {for d}
end;

procedure RoomsFreeprint;
begin
 PrintRfreeWin:=TPrintRfreeWin.create;
 with PrintRfreeWin do
  try
   PrintHead;
   case winView[wnRoFree] of
    0: freesbytimeslot;
    1: rofrees;
    2: freeRlist;
   end; {case}
  finally
   PrintRfreeWin.Free;
  end;
end;

procedure TOutRfreeWin.head;
begin
 printw('Rooms Free');
 newline; newline;
end;

procedure TOutRfreeWin.freesbytimeslot;
var
 k,d,p,yearY,l: integer;
 j: smallint;
 astr: string;
 aFnt:            tpintpoint;

    procedure showRoomfreecode(J: integer);
    var
     aStr,bStr: string;
    begin
     aStr:=trim(XML_TEACHERS.tecode[J,1]);
     if copy(aStr,1,2)<>'00' then
     begin
      bStr:=inttostr(RoLoadInt[J]);
      printc(aStr);
      printc(bStr);
      inc(count);
     end;
    end;


begin
 for d:=dstrt to dfin do
  begin
   if XML_DISPLAY.Roomsfreefac>0 then
        printw(facname[XML_DISPLAY.Roomsfreefac]+' ');
   printw(dayname[D]);
   newline;
   GetTimeLimits(d);
   for p:=pestrt to peend do
    if XML_DISPLAY.TsOn[d,p-1] then
     begin
      newline;
      count:=0;
      for k:=1 to numcodes[2] do RoFound[k]:=0;
      for yearY:=0 to years_minus_1 do
       begin
        aFnt:=FNT(d,p-1,yearY,0,4);
        for L:=1 to level[yearY] do
         begin
          inc(aFnt,4);
          j:=aFNt^;
          if (j>0) and (j<=numcodes[2]) then RoFound[j]:=-1;
         end; {for L}
       end; {for yearY}
      newline;
      printw(TimeSlotName[d,P-1]);
      for k:=1 to codeCount[mycode] do
       begin
        J:=codepoint[K,mycode];
        if RoomInFac(j) then if RoFound[j]=0 then showRoomfreecode(J);
       end; {for k}
      aStr:='Total: '+inttostr(count);
      printw(aStr);
     end; {for Ip}
   newline; newline;
   printCustomAddon;
   newline;
  end; {for D}
end;

procedure TOutRfreeWin.freeRlist;
var
 astr:  string;
 d,p,k,j:     integer;
 found,NAfound: boolean;
 freet: integer;
 freestrt,freeend:      integer;
begin
 if (XML_DISPLAY.Roomsfreefac>0) then
  begin
   printw(facname[XML_DISPLAY.Roomsfreefac]+' ');
   printw('Rooms Free');
   newline;
  end;
 if codeCount[mycode]=0 then
 begin
  printw('No Rooms entered.');
  exit;
 end;
 if ((XML_DISPLAY.Roomsfreeshow2=2) and (XML_DISPLAY.RoomsFreeSelection[0]=0)) then
 begin
  printw('No Rooms selected.');
  exit;
 end;
 showheader;
 freestrt:=1;
 if XML_DISPLAY.Roomsfreeshow2=2 then
  freeend:=XML_DISPLAY.RoomsFreeSelection[0]
 else
   freeend:=codeCount[mycode];
 for k:=freestrt to freeend do
 begin
  if XML_DISPLAY.Roomsfreeshow2=2 then j:=XML_DISPLAY.RoomsFreeSelection[k]
   else j:=codepoint[k,mycode];
  count:=0; freet:=0;
  if RoomInFac(j) then
   begin
    printw(XML_TEACHERS.tecode[j,1]);
    for d:=0 to days-1 do
    begin
     astr:='';
     for p:=0 to tlimit[d]-1 do
     begin
      FindRoInTime(d,p,j,found,NAfound);
      if not(found) then
      begin
       inc(freet);
       astr:=astr+'_';
      end
      else
       begin
        if NAfound then astr:=astr+'N'
        else
         begin
          inc(count);
          astr:=astr+tsCode[d,p];
         end;
       end;
     end; {for p}
     printc(astr);
    end; {for d}
    printc(inttostr(count));
    printc(inttostr(freet));
    newline;
   end;
 end; {for K}
 printCustomAddon;
end;

procedure TOutRfreeWin.Rofrees;
var
 i,p,a,d,p1,ro,l:     integer;
 ropoint,roprint:      array[0..nmbrperiods] of integer;
 yearY:                integer;
 aFnt,bFnt:            tpintpoint;
 found,lineprinted: integer;
 cc:                          integer;
 pestrt,peend: integer;


      procedure nextRoom;
      begin
       a:=0;
       while a=0 do
       begin
        inc(ropoint[p]);
        ro:=ropoint[p];
        a:=0;
        if ropoint[p]>codeCount[2] then exit;
        if ((tlimit[d]-RoOn[ro,0])=p1) and (RoOn[ro,p]=0) then a:=ro;
        if (ro=0) or (ord(XML_TEACHERS.tecode[ro,1][1])=48) then a:=0;
       end;
      end; {end local proc}

      procedure teprintproc;
      var
       p:       integer;
       astr:    string;
      begin
       newline;
       printw('Times');
       for p:=0 to tlimit[d]-1 do
        begin
         astr:=copy(TimeSlotName[d,p],1,7);
         printc(astr);
        end; {for p}
       newline;
      end; {end local proc}


begin    {start of main proc}
 lineprinted:=0;
 for d:=dstrt to dfin do
 begin
  for i:=1 to numcodes[mycode] do
   for p:=0 to periods do
    RoOn[i,p]:=0;
    pestrt:=1;
    peend:=tlimit[d];
  for p:=pestrt to peend do
   for yearY:=0 to years_minus_1 do
   begin
    l:=0;
    aFnt:=FNT(d,p-1,yearY,l,0);
    for L:=1 to level[yearY] do
    begin
     inc(aFnt,4); bfnt:=afnt; inc(bfnt,2);
     ro:=bfnt^;
     if RoOn[ro,p]=0 then
     begin
      inc(RoOn[ro,p]);
      inc(RoOn[ro,0]);
     end;
    end; {for L}
   end; {for yearY}
  printw(dayname[d]);
  newline;
  teprintproc;
  for p1:=peend downto pestrt do
  begin
   for p:=0 to periods do
    ropoint[p]:=0;
   printw(inttostr(p1));
   cc:=0;
   for i:=1 to codeCount[2] do
   begin
    found:=0;
    lineprinted:=0;
    for p:=pestrt to peend do
    begin
     nextRoom;
     roprint[p]:=a;
     if a>0 then found:=-1;
    end; {for p}
    if bool(found) then
    begin
     for p:=pestrt to peend do
     begin
      if roprint[p]>0 then
      begin
       printc(XML_TEACHERS.tecode[roprint[p],1]);
       lineprinted:=-1;
       cc:=1;
      end;
     end; {for p}
     newline;
    end {if found}
    else
     begin
      break;
     end; {not found}
   end; {for i}
   if not(bool(lineprinted)) then
   begin
    if cc=0 then newline;
   end; {not lineprinted}
  end; {for p1}
  printCustomAddon;
  newline;
 end; {for d}
end;

procedure TOutRfreeWin.showheader;
var
 d,p: integer;
 astr: string;
begin
 printw('Room');
 for d:=0 to days-1 do printc(dayname[d]);
 printc('Total');
 printc('Free');
 newline;
 for d:=0 to days-1 do
  begin
   astr:='';
   for p:=0 to tlimit[d]-1 do astr:=astr+tsCode[d,p];
   printc(astr);
  end;
 newline;
end;

procedure RoomsFreetext;
begin
 OutRfreeWin:=TOutRfreeWin.create;
 with OutRfreeWin do
  try
   Header;
   case winView[wnRoFree] of
    0: freesbytimeslot;
    1: Rofrees;
    2: freeRlist;
   end; 
  finally
   OutRfreeWin.Free;
  end;
end;



end.
