unit Blkclash;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Menus,TimeChartGlobals,ClassDefs,GlobalToTcAndTcextra,
  XML.TEACHERS;

type
  TBlockClashesWin = class(TDrawWin)
    PopupMenu1: TPopupMenu;
    Selection2: TMenuItem;
    N2: TMenuItem;
    PrintSetup1: TMenuItem;
    Print1: TMenuItem;
    Exportastextfile1: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Selection2Click(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
  protected
    procedure SetTabs; override;
  end;

procedure BlockClashesprint;
procedure BlockClashestext;

var
  BlockClashesWin: TBlockClashesWin;

implementation
uses tcommon,main,bclshdlg,printers,tcommon2;
{$R *.DFM}

 type TPrintBclashWin=class(TPrintDrawWin)
  public
   procedure head; override;
   procedure SetTabs; override;
  private
   teblock,roblock:   tpTeData;
   procedure BlockClashesSummary;
   procedure ClashDetails;
   procedure blocklines(gaps: bool);
 end;

 type TOutBclashWin=class(TOutputwin)
  public
   procedure head; override;
  private
   teblock,roblock:   tpTeData;
   procedure BlockClashesSummary;
   procedure ClashDetails;
   procedure blocklines(gaps: bool);
 end;

var
 PrintBclashWin: TPrintBclashWin;
 OutBclashWin: TOutBclashWin;
 BlockMax:  array[0..nmbryears] of integer;

procedure TBlockClashesWin.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 action:=caFree;
end;

procedure maximumblocks;
var
 Y1,B,L1:            integer;
 su,te,ro:        integer;
 aFnt:             tpintpoint;
begin
 for Y1:=0 to years_minus_1 do
  begin
   blockmax[Y1]:=0;
   for B:=1 to blocks[Y1] do
    for L1:=1 to level[Y1] do
     begin
      aFnt:=FNws(B,Y1,L1,0);
      su:=aFnt^;  inc(aFnt);
      te:=aFnt^;  inc(aFnt);
      ro:=aFnt^;
      if ((su>0) or (te>0) or (ro>0)) then blockmax[Y1]:=B;
     end; {for L1}
  end; {for Y1}
end;



procedure TBlockClashesWin.SetTabs;
begin
 maximumblocks;
end;



function checkBlock(b1,b2,y1: integer): bool;
var
 L1,L2:        integer;
 aFnt:            tpIntpoint;
 te1,te2,ro1,ro2: integer;
 found:           bool;
begin
 found:=false;
 for L2:=1 to level[wsy] do
 begin
  aFnt:=FNws(b2,wsy,L2,2);
  te2:=aFnt^;
  inc(aFnt); ro2:=aFnt^;
  for L1:=1 to level[Y1] do
  begin
   aFnt:=FNws(b1,Y1,L1,2);
   te1:=aFnt^;
   inc(aFnt);    ro1:=aFnt^;
   if (((te2>0) and (te2=te1)) or ((ro2>0) and (ro2=ro1))) then
   begin
    found:=true; break;
   end;
  end; {for L1}
  if found then break;
 end; {for L2}
 result:=found;
end;




procedure TBlockClashesWin.FormPaint(Sender: TObject);
var
 B2,Y1,B1:                      integer;
 te1,te2,ro1,ro2:               integer;
 teBlock,roBlock:               tpTeData;
 teblockflag,roblockflag:       bool;
 found:                         bool;
 count:                         integer;
 line1,line2,line3,lineyr:      array[0..nmbryears] of integer;


procedure blockClashesSummary;
var
 b1,b2,y1:                    integer;
 scrolltemp,scrolltemp2:      longint;
begin
 count:=0; fcolor(cpNormal);
 printw('Block Clashes for '+yeartitle+' '+yearname[wsy]);
 newline; newline;
 printw(yearshort+' '+yearname[wsy]);
 for b2:=1 to blocks[wsy] do
 begin
  x:=fwyearname+canvas.textwidth(yearshort)+blankwidth*2+B2*(blankwidth*2);
  printw(inttostr(B2));
 end; {for B2}
 newline;
 for y1:=years_minus_1 downto 0 do
 begin
  if (Y1<>wsy) then
  begin
   fcolor(cpNormal);
   printw(yearshort+' '+yearname[Y1]);
   newline;
   inc(count,2+blocks[Y1]);
   for b1:=1 to blocks[Y1] do
   begin
    fcolor(cpNormal);
    x:=fwyearname+self.canvas.textwidth(yearshort)+blankwidth;
    printw(inttostr(B1));
    for b2:=1 to blocks[wsy] do
    begin
     x:=fwyearname+self.canvas.textwidth(yearshort)+blankwidth*2+B2*(blankwidth*2);
     if checkblock(b1,b2,y1) then
     begin
      fcolor(cpBlockClash);
      printw('X');
     end
     else
      begin
       fcolor(cpNormal);
       printw('-');
      end;
    end; {for B2}
    newline;
   end; {for B1}
  end;
  newline;
 end; {for Y1}
 fcolor(cpBlockClash);
 printwl('X ');
 fcolor(cpNormal);
 printw('shows a clash between blocks');
 newline;

 scrolltemp:=(7+longint(count))*longint(txtheight);
 if scrolltemp>maxWinScrollRange then scrolltemp:=maxWinScrollRange;
 self.vertscrollbar.range:=scrolltemp;

 scrolltemp:=self.canvas.textwidth('Block Clashes for '+yeartitle+' '+yearname[wsy])+hmargin*2;
 scrolltemp2:=self.canvas.textwidth('X shows a clash between blocks')+hmargin*2;
 if scrolltemp2>scrolltemp then scrolltemp:=scrolltemp2;
 scrolltemp2:=fwyearname+self.canvas.textwidth(yearshort)+blankwidth*2
     +blocks[wsy]*(blankwidth*2)+hmargin*2;
 if scrolltemp2>scrolltemp then scrolltemp:=scrolltemp2;
 if scrolltemp>maxWinScrollRange then scrolltemp:=maxWinScrollRange;
 self.horzscrollbar.range:=scrolltemp;
end;

procedure checkBlockDetails;
var
 L1,L2,i:      integer;
 aFnt:            tpIntpoint;
begin
 found:=false;
 for i:=0 to nmbrTeachers do
 begin
  teBlock[i]:=0; roBlock[i]:=0;
 end; {for i}
 teblockflag:=false; roblockflag:=false;
 for L2:=1 to level[Y1] do
 begin
  aFnt:=FNws(b2,Y1,L2,2);
  te2:=aFnt^;
  inc(aFnt);   ro2:=aFnt^;
  for L1:=1 to level[wsy] do
  begin
   aFnt:=FNws(b1,wsy,L1,2);
   te1:=aFnt^;
   inc(aFnt);    ro1:=aFnt^;
   if ((te2>0) and (te2=te1)) then
   begin
    found:=true; teblockflag:=true; teBlock[te2]:=-1;
   end;
   if ((ro2>0) and (ro2=ro1)) then
   begin
    found:=true; roblockflag:=true; roBlock[ro2]:=-1;
   end;
  end; {for L1}
 end; {for L2}
end;


procedure clashDetails;
var
 BB1,BB2,YY1,i: integer;
 count1,count2:   integer;
 maxX,curX:            integer;
 scrolltemp,scrolltemp2: longint;
begin
 fcolor(cpNormal);  count:=0;    maxX:=0;
 printw('Block Clash Details for '+yeartitle+' '+yearname[wsy]);
 newline;   newline;
 for BB1:=1 to blocks[wsy] do
 begin
  B1:=BB1;    count1:=0;   fcolor(cpNormal);
  printw('Block '+inttostr(B1)+' '+yeartitle+' '+yearname[wsy]+' clashes:');
  for YY1:=years_minus_1 downto 0 do
  begin
   Y1:=YY1;     count2:=0;
   if (Y1<>wsy) then
    for BB2:=1 to blocks[wsy] do
    begin
     B2:=BB2;
     checkblockdetails;
     if found then
     begin
     inc(count);
      if count1=0 then
      begin
       newline; inc(count1); inc(count);
      end;
      if count2=0 then
      begin
       inc(x,blankwidth*3); fcolor(cpNormal);
       printw(yearshort+' '+yearname[Y1]);
       inc(count2);
      end;
      x:=self.canvas.textwidth(yearshort)+fwyearname+blankwidth*4;
      fcolor(cpNormal);
      printw('Block '+inttostr(B2));
      x:=self.canvas.textwidth(yearshort)+fwyearname+blankwidth*4
         +self.canvas.textwidth('Block 99   ');
      curx:=self.canvas.textwidth(yearshort)+fwyearname+blankwidth*4;
      curx:=curx+self.canvas.textwidth('Block 99   ');
      if teblockflag then
      begin
       fcolor(cpNormal);
       printwl('Teachers: '); fcolor(cpTeach);
       inc(curx,self.canvas.textwidth('Teachers: '));
       for i:=1 to numcodes[1] do
        if bool(teBlock[i]) then
        begin
          printwl(XML_TEACHERS.tecode[i,0]+' ');
          inc(curx,fwcode[1]+blankwidth);
        end;
      end;
      if roblockflag then
      begin
       fcolor(cpNormal);
       printwl('Rooms: '); fcolor(cpRoom);
       inc(curx,self.canvas.textwidth('Rooms: '));
       for i:=1 to numcodes[2] do
        if bool(roBlock[i]) then
        begin
         printwl(XML_TEACHERS.tecode[i,1]+' ');
         inc(curx,fwcode[2]+blankwidth);
        end;
      end;
      if curx>maxX then maxX:=curx;
      newline;
     end; {if found}
    end; {for BB2}
   if count2>0 then
   begin
    newline;
    inc(count);
   end;
  end; {for YY1}
 end; {for BB1}

 scrolltemp:=(4+longint(count)+longint(blocks[wsy]))*longint(txtheight);
 if scrolltemp>maxWinScrollRange then scrolltemp:=maxWinScrollRange;
 self.vertscrollbar.range:=scrolltemp;

  scrolltemp:=self.canvas.textwidth('Block Clash Details for '+yeartitle+' '+yearname[wsy{currentyear}])+hmargin*2;
  scrolltemp2:=self.canvas.textwidth('Block '+inttostr(B1)+' '+yeartitle+' '+yearname[wsy{currentyear}]+' clashes:')+hmargin*2;
  if scrolltemp2>scrolltemp then scrolltemp:=scrolltemp2;
  scrolltemp2:=maxX+hmargin*2;
  if scrolltemp2>scrolltemp then scrolltemp:=scrolltemp2;
  if scrolltemp>maxWinScrollRange then scrolltemp:=maxWinScrollRange;

 self.horzscrollbar.range:=scrolltemp;
end;



procedure blocklines(gaps: bool);
var
 tab1,tab2,tab3:    integer;
 Iy,j,k:      integer;
 lineclash:   integer;
 teclash,roclash:     integer;
 Y1,B1:            integer;
 aFnt,bFnt:             tpintpoint;
 shareP,shareP1:                integer;
 doprint,lastprint,firstprint:          bool;
 blank:                                 integer;
 NewlineFlg:                           bool;
 join1,join2,join3:                    string[20];
 tmpstr:                               string;
 blevel,count1,counttot:               integer;
 scrolltemp,scrolltemp2:               longint;



    procedure lineshead;
    var
     Iy:      integer;
    begin
     tab2:=self.canvas.textwidth('Block 10 ');
     j:=tab2+5*blankwidth;
     k:=fwyearname+self.canvas.textwidth(yearshort)+blankwidth;
     if k>j then j:=k;
     tab1:=j;  tab3:=tab1-tab2+blankwidth;
     for Iy:=1 to years do
     begin
      x:=tab1*(Iy-1); fcolor(cpNormal);
      printw(yearshort+yearname[lineyr[Iy]]);
     end; {for Iy}
     newline;
    end;




    procedure printline;
    var
     Iy,Y3,Ib1:      integer;
     aStr:                  string;
     stp:                   integer;
    begin
     if firstprint then
     begin
      for Iy:=1 to years do
       line2[Iy]:=line1[Iy];
      firstprint:=false;
     end;
     if (lastprint=false) then doprint:=false;
     for Iy:=1 to years do
     begin
      Y3:=lineyr[Iy];
      if ((line2[Iy]<>line1[Iy]) and (line1[Iy]<=blocks[Y3]) and (line2[Iy]<=blocks[Y3])) then
       doprint:=true;
     end; {for Iy}
     if doprint then
     begin
      blank:=0; newlineFlg:=true;
      for Iy:=1 to years do
      begin
       if ((Iy>1) or (count1=0)) then
       begin
        if ((line2[Iy]>0) and (line2[iy]<=blockmax[lineyr[Iy]])) then
        begin
         if Iy>2 then
         begin
          if bool(blank) then
          begin
           for Ib1:=1 to blank do
           begin
            stp:=tab3+tab2;
            drawmyline(x,y+(txtheight div 2),x+stp,y+(txtheight div 2));
            inc(x,stp);
           end;
           blank:=0; astr:='';
           if newlineFlg=false then
           begin
           if line2[Iy-1]>9 then
            begin
             drawmyline(x,y+(txtheight div 2),x+tab3,y+(txtheight div 2));
             inc(x,tab3);
            end
            else
             begin
              stp:=tab3+blankwidth;
              drawmyline(x,y+(txtheight div 2),x+stp,y+(txtheight div 2));
              inc(x,stp);
             end;
           end;
          end
           else {not blank}
            begin
             if line2[Iy-1]>9 then
             begin
              drawmyline(x,y+(txtheight div 2),x+tab3,y+(txtheight div 2));
              inc(x,tab3);
             end
             else
              begin
               stp:=tab3+blankwidth;
               drawmyline(x,y+(txtheight div 2),x+stp,y+(txtheight div 2));
               inc(x,stp);
              end;
            end;
         end; {Iy>2}
         x:=tab1*(Iy-1);
         printwl('Block '+inttostr(line2[Iy]));
         if Iy>1 then newlineFlg:=false;
        end
        else
         begin
          inc(blank);
          if Iy=2 then x:=tab1*(Iy-1);
         end;    {if ((line2[Iy]>0) and (line2[iy]<=blockmax[lineyr[Iy]])) }
       end {if ((Iy<>1) or (count1<=0))}
      end; {for Iy}
      blank:=0;
      newline;
      inc(count1);

      for Iy:=1 to years do
      begin
       line3[Iy]:=line2[Iy];
       line2[Iy]:=line1[Iy];
      end; {for Iy}
     end; {if doprint}
    end;


    procedure lineclashproc;
    var
     I1,L1,T1,T2,R1,R2:   integer;
     I2,L2,Y2,b1,b2:                  integer;
    begin
     lineclash:=0; teclash:=0; roclash:=0;
     for I1:=1 to years do
     begin
      b1:=line1[I1];
      if (b1<>0) then
      begin
       Y1:=lineyr[I1];
       if (b1<=blockmax[Y1]) then
       begin
        for L1:=1 to level[Y1] do
        begin
         aFnt:=FNws(b1,Y1,L1,2); T1:=aFnt^;
         inc(aFnt); R1:=aFnt^;
         inc(aFnt); shareP:=(2 and aFnt^);
         if ((T1<>0) or (R1<>0)) then
         begin
          for I2:=I1 to years do
          begin
           b2:=line1[I2];
           if (b2<>0) then
           begin
            Y2:=lineyr[I2];
            if (b2<=blockmax[Y2]) then
            begin
             for L2:=1 to level[Y2] do
             begin
              if ((Y2<>Y1) or (L2>L1)) then
              begin
               bFnt:=FNWS(b2,Y2,L2,2);
               T2:=bFnt^;  inc(bFnt);
               R2:=bFnt^;  inc(bFnt);
               shareP1:=(2 and bFnt^);
               if ((bool(shareP)=false) or (bool(shareP1)=false)) then
               begin
                if ((T1>0) and (T1=T2)) then inc(teclash);
                if ((R1>0) and (R1=R2)) then inc(roclash);
               end;
              end;
             end; {for L2}
            end; {if b4<=blockmax[Y2}
           end; {if b4<>0}
          end; {for I2}

         end;  {if ((T1<>0) or (R1<>0))}
        end; {for l1}
       end; {if b3<=blockmax[Y1]}
      end; {if b3<>0}
     end; {for I1}
     lineclash:=teclash+roclash;
    end;

    procedure getlines;
    var
     ggaps:   integer;
    label getlines1;
    begin
     blevel:=2; lastprint:=false;  firstprint:=true;
    getlines1:
     if y>bottomcutoff then exit;
     inc(line1[blevel]);
     if gaps then ggaps:=1 else ggaps:=0;
     if ((line1[blevel]>(ggaps+blockmax[lineyr[blevel]])) and (blevel=2)) then
     begin
      lastprint:=true; printline; exit;
     end;
     if (line1[blevel]>(ggaps+blockmax[lineyr[blevel]])) then
     begin
      line1[blevel]:=0; dec(blevel); goto getlines1;
     end;
     lineclashproc;
     if ((lineclash=0) and (blevel=years)) then
      printline;
     if ((lineclash=0) and (blevel<years)) then inc(blevel);
     goto getlines1;
    end;


begin
 join1:=stringpadchr(13,'-');
 join2:=copy(join1,1,3);
 join3:=copy(join1,1,4);

 if blockmax[wsy]=0 then
 begin
  printw(' No blocks in current year.');
  newline;
  exit;
 end;
 lineyr[1]:=wsy;  count:=1;
 for Iy:=years_minus_1 downto 0 do
  if Iy<>wsy then
  begin
   inc(count);  lineyr[count]:=Iy;
  end;
 tmpStr:='Block Lines with No Clashes - '+yeartitle+' '+yearname[wsy];
 if gaps then tmpStr:=tmpStr+' (with gaps)'
  else tmpstr:=tmpStr+' (no gaps)';
 printw(tmpStr);
 newline;
 lineshead;  counttot:=5;
 for B1:=1 to blockmax[wsy] do
 begin
  count1:=0;
  line1[1]:=B1; line2[1]:=B1;
  for Iy:=2 to years do
  begin
   line2[Iy]:=0; line1[Iy]:=0;
  end; {for Iy}
  for Iy:=0 to years do
  begin
   line3[Iy]:=0;
  end; {for Iy}
  getlines;
  if (count1=0) then printw('Block '+inttostr(B1)+' (no lines)');
  newline;
  inc(counttot,count1+1);
 end; {for B1}
  scrolltemp:=longint(counttot)*longint(txtheight);
  if scrolltemp>maxWinScrollRange then scrolltemp:=maxWinScrollRange;

 self.vertscrollbar.range:=scrolltemp;
  scrolltemp:=longint(blockmax[wsy])*longint(tab1)+longint(hmargin)*2;
  scrolltemp2:=self.canvas.textwidth(tmpstr);
  if scrolltemp<scrolltemp2 then scrolltemp:=scrolltemp2;
  if scrolltemp>maxWinScrollRange then scrolltemp:=maxWinScrollRange;

 self.horzscrollbar.range:=scrolltemp;
end;


begin
 fillchar(teBlock,sizeof(teBlock),chr(0));
 fillchar(roBlock,sizeof(roBlock),chr(0));
 try
  screen.cursor:=crHourglass;  {wrap in hourglass cursor for long paint}
  fcolor(cpNormal);
  case winView[wnBlockClashes] of
    0: blockClashesSummary;
    1: clashdetails;
    2: blocklines(false);
    3: blocklines(true);
  end; {case}
 finally
  screen.cursor:=crDefault;
 end;

end;



procedure TBlockClashesWin.FormCreate(Sender: TObject);
begin
 setWindowDefaults(self,wnBlockClashes);
 blockclashesoldyear:=-1;
end;

procedure TBlockClashesWin.Selection2Click(Sender: TObject);
begin
 blockclashesdlg:=Tblockclashesdlg.create(self);   {allocate dlg}
 blockclashesdlg.showmodal;
 blockclashesdlg.free;
end;

{-----------------    -print procs follow-   ------------------------}

procedure TPrintBclashWin.head;
begin
 UnderlineOn;
  case winView[wnBlockClashes] of
    0: printwl('Block Clashes for '+yeartitle+' '+yearname[wsy]);
    1: printwl('Block Clash Details for '+yeartitle+' '+yearname[wsy]);
    2: printwl('Block Lines with No Clashes - '+yeartitle+' '+yearname[wsy]+' (no gaps)');
    3: printwl('Block Lines with No Clashes - '+yeartitle+' '+yearname[wsy]+' (with gaps)');
   end; {case}
 printw(PageCount);
 UnderlineOff;
 x:=0; y:=y+2*PrnttxtHeight;
end;

procedure TPrintBclashWin.SetTabs;
begin
// SetLength(PrntTabs,6);
// MaxTab(1,PrintCanvas.textwidth('FormFeed: OFF  '),DateStr+'  ');
end;

procedure TPrintBclashWin.clashDetails;
var
 B1,BB1,B2,BB2,Y1,YY1,i: integer;
 count1,count2:   integer;
 found: boolean;
 teblockflag,roblockflag:       bool;
 te1,te2,ro1,ro2: integer;

    procedure checkBlockDetails;
    var
     L1,L2,i:      integer;
     aFnt:            tpIntpoint;
    begin
     found:=false;
     for i:=0 to nmbrTeachers do
     begin
      teBlock[i]:=0; roBlock[i]:=0;
     end; {for i}
     teblockflag:=false; roblockflag:=false;
     for L2:=1 to level[Y1] do
     begin
      aFnt:=FNws(b2,Y1,L2,2);
      te2:=aFnt^;
      inc(aFnt);   ro2:=aFnt^;
      for L1:=1 to level[wsy] do
      begin
       aFnt:=FNws(b1,wsy,L1,2);
       te1:=aFnt^;
       inc(aFnt);    ro1:=aFnt^;
       if ((te2>0) and (te2=te1)) then
       begin
        found:=true; teblockflag:=true; teBlock[te2]:=-1;
       end;
       if ((ro2>0) and (ro2=ro1)) then
       begin
        found:=true; roblockflag:=true; roBlock[ro2]:=-1;
       end;
      end; {for L1}
     end; {for L2}
    end;

begin
 for BB1:=1 to blocks[wsy] do
 begin
  B1:=BB1;    count1:=0;
  printw('Block '+inttostr(B1)+' '+yeartitle+' '+yearname[wsy]+' clashes:');
  for YY1:=years_minus_1 downto 0 do
  begin
   Y1:=YY1;     count2:=0;
   if (Y1<>wsy) then
    for BB2:=1 to blocks[wsy] do
    begin
     B2:=BB2;
     checkblockdetails;
     if found then
     begin
      if count1=0 then begin newline; inc(count1) end;
      if count2=0 then
      begin
       inc(x,prntblankwidth*3);
       printw(yearshort+' '+yearname[Y1]);
       inc(count2);
      end;
      x:=PrintCanvas.textwidth(yearshort)+fwprntyearname+prntblankwidth*4;
      printw('Block '+inttostr(B2));
      x:=PrintCanvas.textwidth(yearshort)+fwprntyearname+prntblankwidth*4
         +PrintCanvas.textwidth('Block 99   ');
      if teblockflag then
      begin
       printwl('Teachers: ');
       for i:=1 to numcodes[1] do
        if bool(teBlock[i]) then
        begin
          fcolor(cpTeach);
          printwl(XML_TEACHERS.tecode[i,0]+' '); fcolor(cpNormal);
        end;
      end;
      if roblockflag then
      begin
       printwl('Rooms: ');
       for i:=1 to numcodes[2] do
        if bool(roBlock[i]) then
        begin
         fcolor(cpRoom);
         printwl(XML_TEACHERS.tecode[i,1]+' '); fcolor(cpNormal);
        end;
      end;
      newline;
     end; {if found}
    end; {for BB2}
   if count2>0 then newline;
  end; {for YY1}
 end; {for BB1}
end;



procedure TPrintBclashWin.blockClashesSummary;
var
 B1,BB1,BB2,Y1,YY1,B2: integer;
begin
 printw(yearshort+' '+yearname[wsy]);
 for BB2:=1 to blocks[wsy] do
 begin
  B2:=BB2;
  x:=fwyearname+PrintCanvas.textwidth(yearshort)+prntblankwidth*2+B2*(prntblankwidth*2);
  printw(inttostr(B2));
 end; {for B2}
 newline;
 for YY1:=years_minus_1 downto 0 do
 begin
  Y1:=YY1;
  if (Y1<>wsy) then
  begin
   printw(yearshort+' '+yearname[Y1]);
   newline;
   for BB1:=1 to blocks[Y1] do
   begin
    B1:=BB1;   
    x:=fwyearname+PrintCanvas.textwidth(yearshort)+prntblankwidth;
    fcolor(cpNormal);
    printw(inttostr(B1));
    for BB2:=1 to blocks[wsy] do
    begin
     B2:=BB2;
     x:=fwyearname+PrintCanvas.textwidth(yearshort)+prntblankwidth*2+B2*(prntblankwidth*2);
     if checkblock(b1,b2,y1) then
     begin
      fcolor(cpBlockClash);
      printw('X');
     end
     else
      begin
       fcolor(cpNormal);
       printw('-');
      end;
    end; {for B2}
    newline;
   end; {for B1}
  end;
  newline;
 end; {for Y1}
 printwl('X ');
 printw('shows a clash between blocks');
 newline;
end;


procedure TPrintBclashWin.blocklines(gaps: bool);
var
 tab1,tab2,tab3:    integer;
 Iy,j,k,count:      integer;
 lineclash:   integer;
 teclash,roclash:     integer;
 Y1,B1:            integer;
 aFnt,bFnt:             tpintpoint;
 shareP,shareP1:                integer;
 doprint,lastprint,firstprint:          bool;
 blank:             integer;
 NewlineFlg:                           bool;
 join1,join2,join3:                    string[20];
 blevel,count1:               integer;
 line1,line2,line3,lineyr:      array[0..nmbryears] of integer;

    procedure lineshead;
    var
     Iy:      integer;
    begin
     tab2:=PrintCanvas.textwidth('Block 10 ');
     j:=tab2+5*prntblankwidth;
     k:=fwyearname+PrintCanvas.textwidth(yearshort)+prntblankwidth;
     if k>j then j:=k;
     tab1:=j;  tab3:=tab1-tab2+prntblankwidth;
     for Iy:=1 to years do
     begin
      x:=tab1*(Iy-1);
      printw(yearshort+yearname[lineyr[Iy]]);
     end; {for Iy}
     newline;
    end;



    procedure printline;
    var
     Iy,Y3,Ib1:      integer;
     aStr:                  string;
     stp:                   integer;
    begin
     if firstprint then
     begin
      for Iy:=1 to years do
       line2[Iy]:=line1[Iy];
      firstprint:=false;
     end;
     if (lastprint=false) then doprint:=false;
     for Iy:=1 to years do
     begin
      Y3:=lineyr[Iy];
      if ((line2[Iy]<>line1[Iy]) and (line1[Iy]<=blocks[Y3]) and (line2[Iy]<=blocks[Y3])) then
       doprint:=true;
     end; {for Iy}
     if doprint then
     begin
      blank:=0; newlineFlg:=true;
      for Iy:=1 to years do
      begin
       if ((Iy>1) or (count1=0)) then
       begin
        if ((line2[Iy]>0) and (line2[iy]<=blockmax[lineyr[Iy]])) then
        begin
         if Iy>2 then
         begin
          if bool(blank) then
          begin
           for Ib1:=1 to blank do
           begin
            stp:=tab3+tab2;
            drawmyline(x,y+(prnttxtheight div 2),x+stp,y+(prnttxtheight div 2));
            inc(x,stp);
           end;
           blank:=0; astr:='';
           if newlineFlg=false then
           begin
           if line2[Iy-1]>9 then
            begin
             drawmyline(x,y+(prnttxtheight div 2),x+tab3,y+(prnttxtheight div 2));
             inc(x,tab3);
            end
            else
             begin
              stp:=tab3+prntblankwidth;
              drawmyline(x,y+(prnttxtheight div 2),x+stp,y+(prnttxtheight div 2));
              inc(x,stp);
             end;
           end;
          end
           else {not blank}
            begin
             if line2[Iy-1]>9 then
             begin
              drawmyline(x,y+(prnttxtheight div 2),x+tab3,y+(prnttxtheight div 2));
              inc(x,tab3);
             end
             else
              begin
               stp:=tab3+prntblankwidth;
               drawmyline(x,y+(prnttxtheight div 2),x+stp,y+(prnttxtheight div 2));
               inc(x,stp);
              end;
            end;
         end; {Iy>2}
         x:=tab1*(Iy-1);
         printwl('Block '+inttostr(line2[Iy]));
         if Iy>1 then newlineFlg:=false;
        end
        else  { not  ((line2[Iy]>0) and (line2[iy]<=blockmax[lineyr[Iy]])) }
         begin
          inc(blank);
          if Iy=2 then x:=tab1*(Iy-1);
         end;    {if ((line2[Iy]>0) and (line2[iy]<=blockmax[lineyr[Iy]])) }
       end {if ((Iy<>1) or (count1<=0))}
      end; {for Iy}
      blank:=0;
      newline;
      inc(count1);
      for Iy:=1 to years do
      begin
       line3[Iy]:=line2[Iy];
       line2[Iy]:=line1[Iy];
      end; {for Iy}
     end; {if doprint}
    end;


    procedure lineclashproc;
    var
     I1,L1,T1,T2,R1,R2:   integer;
     I2,L2,Y2,b1,b2:                  integer;
    begin
     lineclash:=0; teclash:=0; roclash:=0;
     for I1:=1 to years do
     begin
      b1:=line1[I1];
      if (b1<>0) then
      begin
       Y1:=lineyr[I1];
       if (b1<=blockmax[Y1]) then
       begin
        for L1:=1 to level[Y1] do
        begin
         aFnt:=FNws(b1,Y1,L1,2);
         T1:=aFnt^; inc(aFnt); R1:=aFnt^;
         inc(aFnt); shareP:=(2 and aFnt^);
         if ((T1<>0) or (R1<>0)) then
         begin
          for I2:=I1 to years do
          begin
           b2:=line1[I2];
           if (b2<>0) then
           begin
            Y2:=lineyr[I2];
            if (b2<=blockmax[Y2]) then
            begin
             for L2:=1 to level[Y2] do
             begin
              if ((Y2<>Y1) or (L2>L1)) then
              begin
               bFnt:=FNws(b2,Y2,L2,2);
               T2:=bFnt^; inc(bFnt); R2:=bFnt^;
               inc(bFnt); shareP1:=(2 and bFnt^);
               if ((bool(shareP)=false) or (bool(shareP1)=false)) then
               begin
                if ((T1>0) and (T1=T2)) then inc(teclash);
                if ((R1>0) and (R1=R2)) then inc(roclash);
               end;
              end;
             end; {for L2}
            end; {if b2<=blockmax[Y2}
           end; {if b2<>0}
          end; {for I2}

         end;  {if ((T1<>0) or (R1<>0))}
        end; {for l1}
       end; {if b1<=blockmax[Y1]}
      end; {if b1<>0}
     end; {for I1}
     lineclash:=teclash+roclash;
    end;

    procedure getlines;
    var
     ggaps:   integer;
    label getlines1;
    begin
     blevel:=2; lastprint:=false;  firstprint:=true;
    getlines1:
     inc(line1[blevel]);
     if gaps then ggaps:=1 else ggaps:=0;
     if ((line1[blevel]>(ggaps+blockmax[lineyr[blevel]])) and (blevel=2)) then
     begin
      lastprint:=true; printline; exit;
     end;
     if (line1[blevel]>(ggaps+blockmax[lineyr[blevel]])) then
     begin
      line1[blevel]:=0; dec(blevel); goto getlines1;
     end;
     lineclashproc;
     if ((lineclash=0) and (blevel=years)) then
      printline;
     if ((lineclash=0) and (blevel<years)) then inc(blevel);
     goto getlines1;
    end;


begin
 join1:=stringpadchr(13,'-');
 join2:=copy(join1,1,3);
 join3:=copy(join1,1,4);
 if blockmax[wsy]=0 then
 begin
  printw(' No blocks in current year.');
  newline;
  exit;
 end;
 lineyr[1]:=wsy;  count:=1;
 for Iy:=years_minus_1 downto 0 do
  if Iy<>wsy then
  begin
   inc(count);  lineyr[count]:=Iy;
  end;
 lineshead;
 for B1:=1 to blockmax[wsy] do
 begin
  count1:=0;
  line1[1]:=B1; line2[1]:=B1;
  for Iy:=2 to years do
  begin
   line2[Iy]:=0; line1[Iy]:=0;
  end; {for Iy}
  for Iy:=0 to years do
  begin
   line3[Iy]:=0;
  end; {for Iy}
  getlines;
  if (count1=0) then printw('Block '+inttostr(B1)+' (no lines)');
  newline;
 end; {for B1}

end;



procedure BlockClashesprint;
begin
 PrintBclashWin:=TPrintBclashWin.create;
 with PrintBclashWin do
  try
   fillchar(teBlock,sizeof(teBlock),chr(0));
   fillchar(roBlock,sizeof(roBlock),chr(0));
   PrintHead;
   fcolor(cpnormal);
   case winView[wnBlockClashes] of
    0: blockClashesSummary;
    1: clashdetails;
    2: blocklines(false);
    3: blocklines(true);
   end; {case}
   printCustomAddon;
  finally
   PrintBclashWin.Free;
  end;
end;




procedure TBlockClashesWin.FormDblClick(Sender: TObject);
begin
 blockclashesdlg:=Tblockclashesdlg.create(self);   {allocate dlg}
 blockclashesdlg.showmodal;
 blockclashesdlg.free;
end;

procedure TOutBclashWin.head;
begin
  case winView[wnBlockClashes] of
    0: printw('Block Clashes for '+yeartitle+' '+yearname[wsy]);
    1: printw('Block Clash Details for '+yeartitle+' '+yearname[wsy]);
    2: printw('Block Lines with No Clashes - '+yeartitle+' '+yearname[wsy]+' (no gaps)');
    3: printw('Block Lines with No Clashes - '+yeartitle+' '+yearname[wsy]+' (with gaps)');
   end; {case}
 newline;newline;
end;


procedure TOutBclashWin.blockClashesSummary;
var
 B1,BB1,B2,BB2,Y1,YY1: integer;
begin
 printw(yearshort+' '+yearname[wsy]);
 for BB2:=1 to blocks[wsy] do
 begin
  B2:=BB2;
  printc(inttostr(B2));
 end; {for B2}
 newline;
 for YY1:=years_minus_1 downto 0 do
 begin
  Y1:=YY1;
  if (Y1<>wsy) then
  begin
   printw(yearshort+' '+yearname[Y1]);
   newline;
   for BB1:=1 to blocks[Y1] do
   begin
    B1:=BB1;   
    printc(inttostr(B1));
    for BB2:=1 to blocks[wsy] do
    begin
     B2:=BB2;
     if checkblock(b1,b2,y1) then printc('X') else printc('-');
    end; {for B2}
    newline;
   end; {for B1}
  end;
  newline;
 end; {for Y1}
 printw('X ');
 printw('shows a clash between blocks');
 newline;
end;

procedure TOutBclashWin.clashDetails;
var
 B1,BB1,B2,BB2,Y1,YY1,i: integer;
 count1,count2:   integer;
 found: boolean;
 teblockflag,roblockflag:       bool;
 te1,te2,ro1,ro2: integer;

    procedure checkBlockDetails;
    var
     L1,L2,i:      integer;
     aFnt:            tpIntpoint;
    begin
     found:=false;
     for i:=0 to nmbrTeachers do
     begin
      teBlock[i]:=0; roBlock[i]:=0;
     end; {for i}
     teblockflag:=false; roblockflag:=false;
     for L2:=1 to level[Y1] do
     begin
      aFnt:=FNws(b2,Y1,L2,2);
      te2:=aFnt^;
      inc(aFnt);   ro2:=aFnt^;
      for L1:=1 to level[wsy] do
      begin
       aFnt:=FNws(b1,wsy,L1,2);
       te1:=aFnt^;
       inc(aFnt);    ro1:=aFnt^;
       if ((te2>0) and (te2=te1)) then
       begin
        found:=true; teblockflag:=true; teBlock[te2]:=-1;
       end;
       if ((ro2>0) and (ro2=ro1)) then
       begin
        found:=true; roblockflag:=true; roBlock[ro2]:=-1;
       end;
      end; {for L1}
     end; {for L2}
    end;

begin
 for BB1:=1 to blocks[wsy] do
 begin
  B1:=BB1;    count1:=0;  
  printw('Block '+inttostr(B1)+' '+yeartitle+' '+yearname[wsy]+' clashes:');
  for YY1:=years_minus_1 downto 0 do
  begin
   Y1:=YY1;     count2:=0;
   if (Y1<>wsy) then
    for BB2:=1 to blocks[wsy] do
    begin
     B2:=BB2;
     checkblockdetails;
     if found then
     begin
      if count1=0 then
      begin
       newline; inc(count1); 
      end;
      if count2=0 then
      begin
       printw(yearshort+' '+yearname[Y1]);
       inc(count2);
      end;
      printc('Block '+inttostr(B2));
      if teblockflag then
      begin
       printc('Teachers: ');
       for i:=1 to numcodes[1] do
        if bool(teBlock[i]) then
        begin
          printc(XML_TEACHERS.tecode[i,0]+' ');
        end;
      end;
      if roblockflag then
      begin
       printc('Rooms: ');
       for i:=1 to numcodes[2] do
        if bool(roBlock[i]) then
        begin
         printc(XML_TEACHERS.tecode[i,1]+' ');
        end;
      end;
      newline;
     end; {if found}
    end; {for BB2}
   if count2>0 then
   begin
    newline;
   end;
  end; {for YY1}
 end; {for BB1}
end;


procedure TOutBclashWin.blocklines(gaps: bool);
var
 Iy:      integer;
 lineclash:   integer;
 teclash,roclash:     integer;
 Y1,B1:            integer;
 aFnt,bFnt:             tpintpoint;
 shareP,shareP1:                integer;
 doprint,lastprint,firstprint:          bool;
 blank,count:                                 integer;
 NewlineFlg:                           bool;
 join1,join2,join3:                    string[20];
 blevel,count1:               integer;
 line1,line2,line3,lineyr:      array[0..nmbryears] of integer;



    procedure lineshead;
    var
     Iy:      integer;
    begin
     for Iy:=1 to years do
     begin
      printc(yearshort+yearname[lineyr[Iy]]);
     end; {for Iy}
     newline;
    end;


    procedure printline;
    var
     Iy,Y3,Ib1:      integer;
     aStr:                  string;
    begin
     if firstprint then
     begin
      for Iy:=1 to years do
       line2[Iy]:=line1[Iy];
      firstprint:=false;
     end;
     if (lastprint=false) then doprint:=false;
     for Iy:=1 to years do
     begin
      Y3:=lineyr[Iy];
      if ((line2[Iy]<>line1[Iy]) and (line1[Iy]<=blocks[Y3]) and (line2[Iy]<=blocks[Y3])) then
       doprint:=true;
     end; {for Iy}
     if doprint then
     begin
      blank:=0; newlineFlg:=true;
      for Iy:=1 to years do
      begin
       if ((Iy>1) or (count1=0)) then
       begin
        if ((line2[Iy]>0) and (line2[iy]<=blockmax[lineyr[Iy]])) then
        begin
         if Iy>2 then
         begin
          if bool(blank) then
          begin
           for Ib1:=1 to blank do
           begin
            printc('______');
           end;
           blank:=0; astr:='';
           if newlineFlg=false then
           begin
           if line2[Iy-1]>9 then
            begin
             printc('______');
            end
            else
             begin
              printc('______');
             end;
           end;
          end
           else {not blank}
            begin
             if line2[Iy-1]>9 then
             begin
              printc('______');
             end
             else
              begin
               printc('______');
              end;
            end;
         end; {Iy>2}
         printc('Block '+inttostr(line2[Iy]));
         if Iy>1 then newlineFlg:=false;
        end
        else  { not  ((line2[Iy]>0) and (line2[iy]<=blockmax[lineyr[Iy]])) }
         begin
          inc(blank);
         end;    {if ((line2[Iy]>0) and (line2[iy]<=blockmax[lineyr[Iy]])) }
       end {if ((Iy<>1) or (count1<=0))}
      end; {for Iy}
      blank:=0;
      newline;
      inc(count1);
      for Iy:=1 to years do
      begin
       line3[Iy]:=line2[Iy];
       line2[Iy]:=line1[Iy];
      end; {for Iy}
     end; {if doprint}
    end;


    procedure lineclashproc;
    var
     I1,L1,T1,T2,R1,R2:   integer;
     I2,L2,Y2,b1,b2:                  integer;
    begin
     lineclash:=0; teclash:=0; roclash:=0;
     for I1:=1 to years do
     begin
      b1:=line1[I1];
      if (b1<>0) then
      begin
       Y1:=lineyr[I1];
       if (b1<=blockmax[Y1]) then
       begin
        for L1:=1 to level[Y1] do
        begin
         aFnt:=FNws(b1,Y1,L1,2); T1:=aFnt^;
         inc(aFnt); R1:=aFnt^;
         inc(aFnt); shareP:=(2 and aFnt^);
         if ((T1<>0) or (R1<>0)) then
         begin
          for I2:=I1 to years do
          begin
           b2:=line1[I2];
           if (b2<>0) then
           begin
            Y2:=lineyr[I2];
            if (b2<=blockmax[Y2]) then
            begin
             for L2:=1 to level[Y2] do
             begin
              if ((Y2<>Y1) or (L2>L1)) then
              begin
               bFnt:=FNWS(b2,Y2,L2,2);
               T2:=bFnt^;  inc(bFnt);
               R2:=bFnt^;  inc(bFnt);
               shareP1:=(2 and bFnt^);
               if ((bool(shareP)=false) or (bool(shareP1)=false)) then
               begin
                if ((T1>0) and (T1=T2)) then inc(teclash);
                if ((R1>0) and (R1=R2)) then inc(roclash);
               end;
              end;
             end; {for L2}
            end; {if B<=blockmax[Y2}
           end; {if B<>0}
          end; {for I2}

         end;  {if ((T1<>0) or (R1<>0))}
        end; {for l1}
       end; {if B<=blockmax[Y1]}
      end; {if B<>0}
     end; {for I1}
     lineclash:=teclash+roclash;
    end;

    procedure getlines;
    var
     ggaps:   integer;
    label getlines1;
    begin
     blevel:=2; lastprint:=false;  firstprint:=true;
    getlines1:
     inc(line1[blevel]);
     if gaps then ggaps:=1 else ggaps:=0;
     if ((line1[blevel]>(ggaps+blockmax[lineyr[blevel]])) and (blevel=2)) then
     begin
      lastprint:=true; printline; exit;
     end;
     if (line1[blevel]>(ggaps+blockmax[lineyr[blevel]])) then
     begin
      line1[blevel]:=0; dec(blevel); goto getlines1;
     end;
     lineclashproc;
     if ((lineclash=0) and (blevel=years)) then
      printline;
     if ((lineclash=0) and (blevel<years)) then inc(blevel);
     goto getlines1;
    end;


begin
 join1:=stringpadchr(13,'-');
 join2:=copy(join1,1,3);
 join3:=copy(join1,1,4);
 if blockmax[wsy]=0 then
 begin
  printw(' No blocks in current year.');
  newline;
  exit;
 end;
 lineyr[1]:=wsy;  count:=1;
 for Iy:=years_minus_1 downto 0 do
  if Iy<>wsy then
  begin
   inc(count);  lineyr[count]:=Iy;
  end;

 lineshead;
 for B1:=1 to blockmax[wsy] do
 begin
  count1:=0;
  line1[1]:=B1; line2[1]:=B1;
  for Iy:=2 to years do
  begin
   line2[Iy]:=0; line1[Iy]:=0;
  end; {for Iy}
  for Iy:=0 to years do
  begin
   line3[Iy]:=0;
  end; {for Iy}
  getlines;
  if (count1=0) then printw('Block '+inttostr(B1)+' (no lines)');
  newline;
 end; {for B1}

end;


procedure BlockClashestext;
begin
 OutBclashWin:=TOutBclashWin.create;
 with OutBclashWin do
  try
   Header;
   case winView[wnBlockClashes] of
    0: blockClashesSummary;
    1: clashdetails;
    2: blocklines(false);
    3: blocklines(true);
   end; {case}
   printCustomAddon;
  finally
   OutBclashWin.Free;
  end;

end;





end.

