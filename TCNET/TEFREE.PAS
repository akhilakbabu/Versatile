unit Tefree;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Menus, TimeChartGlobals,ClassDefs, StCommon, GlobalToTcAndTcextra,
  XML.DISPLAY, XML.TEACHERS;

type
  TTeachersFree = class(TDrawWin)
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
    procedure SetTabs; override;
  private
   chrwidth:  integer;
   locblankwidth:      integer;
   count,subfit:         integer;
   len,len1,dx: integer;
   ygap:                 integer;
   procedure freesbytimeslot;
   procedure freetlist;
   procedure tefrees;
  end;

procedure TeachersFreeprint;
procedure TeachersFreetext;


var
  TeachersFree: TTeachersFree;

implementation
uses tcommon,main,tfreedlg,printers,tcommon2;
{$R *.DFM}
const
 mycode=1;

type TPrintTfreeWin=class(TPrintDrawWin)
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
  procedure freetlist;
  procedure tefrees;
  procedure TeFreesHead;
 end;

 type TOutTfreeWin=class(TOutputwin)
  public
   procedure head; override;
  private
   count:         integer;
  procedure freesbytimeslot;
  procedure showheader;
  procedure freetlist;
  procedure tefrees;
 end;


var
  PrintTfreeWin:  TPrintTfreeWin;
  OutTfreeWin: TOutTfreeWin;
  pestrt,peend: integer;
  dstrt,dfin:      integer;
  TeLoadInt: array[0..nmbrteachers] of integer;
  TeFound:   array[0..nmbrteachers] of integer;
  TeOn: array[0..nmbrteachers,0..nmbrperiods] of integer;
  tmpRange:     longint;
  Dayheight:       array[0..nmbrDays] of integer;


Function TeachInFac(j:smallint):boolean;
begin
 result:=TeachInAnyFac(j,XML_DISPLAY.teachersfreefac);
end;


procedure calculateloads;
var
 aFnt,bFnt: tpintpoint;
 i,d,p,y,l: integer;
 su,te: integer;
begin
 for i:=1 to numcodes[1] do TeLoadInt[i]:=0;
 for D:=0 to days-1 do
  for P:=1 to tlimit[d] do
  begin
   for i:=1 to numcodes[1] do TeFound[i]:=0;
   for Y:=0 to years_minus_1 do
   begin
    aFnt:=FNT(D,P-1,Y,0,2);
    for L:=1 to level[Y] do
    begin
     inc(aFnt,4);
     te:=aFnt^;
     if bool(te) then
     begin
      bFnt:=aFnt; dec(bFnt);
      su:=bFnt^;
      if ((su<>subNA) and (TeFound[te]=0)) then
      begin
       inc(TeLoadInt[te]);
       TeFound[te]:=-1;
      end;
     end;  {if te}
    end; {for l}
   end; {for y}
  end; {for p}
end;

procedure GetTimeLimits(d:integer);
var
 p: integer;
begin
 if XML_DISPLAY.TeFreePeriod<1 then
  begin
   pestrt:=1;
   peend:=tlimit[d];
  end
 else
  begin
   p:=XML_DISPLAY.TeFreePeriod;
   if p>Tlimit[d] then p:=Tlimit[d];
   pestrt:=p; peend:=p;
  end;
end;


procedure TTeachersFree.SetTabs;
var
 k,d,p,yearY,l,maxx: integer;
 aFnt:            tpintpoint;
 dayheightstart:  integer;
 tmpInt,i,j,a,freeend:          integer;
begin
 SetLength(Tabs,7); ygap:=5;
 calculateloads;
 if XML_DISPLAY.teachersfreeday=-1 then begin
      dstrt:=0;
      dfin:=days-1;
 end
 else begin
   dstrt:=XML_DISPLAY.teachersfreeday;
    dfin:=XML_DISPLAY.teachersfreeday; end;
 case winView[wnTeFree] of
  0: begin
      Tabs[0]:=fwperiodname+2*blankwidth;
      dx:=fwcode[1]+2*blankwidth+2*canvas.textwidth('99');
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
           for k:=1 to numcodes[1] do TeFound[k]:=0;
           for yearY:=0 to years_minus_1 do
            begin
             aFnt:=FNT(d,p-1,yearY,0,2);
              for L:=1 to level[yearY] do
               begin
                inc(aFnt,4);
                j:=aFNt^;
                if (j>0) and (j<=numcodes[1]) then TeFound[j]:=-1;
               end; {for L}
            end; {for yearY}
           maxx:=maxx+txtheight;
           for k:=1 to codeCount[1] do
            begin
             J:=codepoint[K,1];
             if TeachInFac(j)
              then if TeFound[j]=0 then
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
      MaxTab(1,fwcode[1],'Teacher');
      MaxTab(2,days*dx,'');
      MaxTab(3,0,'Times ');
      MaxTab(4,0,'Duties ');
      MaxTab(5,0,'Alloted ');
      MaxTab(6,chrwidth*4,'Free ');
      MaxW:=Tabs[6]+2*hmargin;
      if XML_DISPLAY.teachersfreeshow2=2 then
        freeend:=XML_DISPLAY.TeFreeSelect[0]
       else
         freeend:=codeCount[1];
      a:=0;
      for i:=1 to freeend do
       begin
        if XML_DISPLAY.teachersfreeshow2=2 then j:=XML_DISPLAY.TeFreeSelect[i]
         else j:=codepoint[i,1];
        if TeachInFac(j) then inc(a);
       end;
      MaxH:=(8+a)*txtheight+(5+2*a)*ygap;
     end;
 end; {case}
end;

procedure TTeachersFree.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 XML_DISPLAY.teachersfreeshow1:=winView[wnTeFree]+1;
 action:=caFree;
end;

procedure TTeachersFree.FormCreate(Sender: TObject);
begin
 setWindowDefaults(self,wnTeFree);
 winView[wnTeFree]:=XML_DISPLAY.teachersfreeshow1-1;
end;

procedure TTeachersFree.Selection2Click(Sender: TObject);
begin
 Teachersfreedlg:=TTeachersfreedlg.create(self);   {allocate dlg}
 Teachersfreedlg.showmodal;
 Teachersfreedlg.free;
end;


procedure TTeachersFree.freesbytimeslot;
var
 k,y2,d,p,yearY,l: integer;
 j: smallint;
 aFnt:            tpintpoint;
 astr: string;

    procedure showteacherfreecode(J: integer);
    var
     aStr,bStr: string;
     adjust: integer;
    begin
     aStr:=trim(XML_TEACHERS.tecode[J,0]);
     if copy(aStr,1,2)<>'00' then
     begin
      bStr:=inttostr(TeLoadInt[J]);
      len:=canvas.textwidth(aStr+' '+bStr+' ');
      adjust:=len+blankwidth-dx;
      if ((Tabs[1]>Tabs[0]) and (Tabs[1]+len>Tabs[2])) then
      begin
       Tabs[1]:=Tabs[0];
       newline;
      end;
      x:=Tabs[1];
      fcolor(cpTeach);
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
   if XML_DISPLAY.teachersfreefac>0 then printwl(facname[XML_DISPLAY.teachersfreefac]+' ');
   printw('Teachers Free - '+day[D]);
   newline;
   drawmyline(x,y+txtheight,x+Tabs[2],y+txtheight);  y2:=y+txtheight;
   newline; inc(y,ygap-txtheight);
   GetTimeLimits(d);
   for p:=pestrt to peend do
    if XML_DISPLAY.TsOn[d,p-1] then
     begin
      count:=0;
      for k:=1 to numcodes[1] do TeFound[k]:=0;
      for yearY:=0 to years_minus_1 do
       begin
        aFnt:=FNT(d,p-1,yearY,0,2);
        for L:=1 to level[yearY] do
         begin
          inc(aFnt,4);
          j:=aFNt^;
          if (j>0) and (j<=numcodes[1]) then TeFound[j]:=-1;
         end; {for L}
       end; {for yearY}
      Tabs[1]:=Tabs[0];
      newline;
      printw(' '+TimeSlotName[D,P-1]);
      x:=Tabs[0];
      for k:=1 to codeCount[1] do
       begin
        J:=codepoint[K,1];
        if TeachInFac(j) then if TeFound[j]=0 then showteacherfreecode(J);
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

procedure FindTeInTime(d,p,j:integer; var found,NAfound: boolean);
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
     bFnt:=aFnt; inc(bFnt);
     if bFnt^=j then
      begin
       found:=true;
       if bool(subNA) then
        if subNA=aFnt^ then NAfound:=true;
       break;
      end;
    end; {for l}
   if found then break;
  end; {for yearY}
end;


procedure TTeachersFree.freetlist;
label
 freetlistday;
var
 astr:  string;
 d,p,k,v,j:     integer;
 allotcnt,freet,dutyld,total: double;
 oktoshow,found,NAfound,found2: boolean;
 freeend:      integer;
 ro,sc,teyear,lev, yrCnt, te, gotyear: integer;

 function TeacherHasClasses: boolean;
 var
   l,m: integer;
 begin
   Result := true;
   if XML_DISPLAY.teachersfreeshow2 <> 3 then
     exit
   else
   begin
     for l:=0 to days-1 do
       for m:=0 to tlimit[l]-1 do
       begin
         GetTeachTtItem(sc,ro,teYear,Lev,j,l,m);
         if teYear = XML_DISPLAY.teFreeYear then
           exit;
       end;
   end;
   Result := false;
 end;

begin
 fcolor(cpNormal);
 if (XML_DISPLAY.teachersfreefac>0) then
  printwl(facname[XML_DISPLAY.teachersfreefac]+' ');
 printw('Teachers Free');
 newline;
 if codeCount[mycode]=0 then
 begin
  printw('No Teachers entered.');
  exit;
 end;
 if ((XML_DISPLAY.teachersfreeshow2=2) and (XML_DISPLAY.TeFreeSelect[0]=0)) then
 begin
  printw('No Teachers selected.');
  exit;
 end;
  inc(y,ygap);
  if XML_DISPLAY.teachersfreeshow2 <> 3 then drawmyline(x,y,x+Tabs[6],y)
  else drawmyline(x,y,x+Tabs[4],y);
  drawmyline(x,y,x,y+txtheight+ygap*2);
  drawmyline(Tabs[1],y,Tabs[1],y+txtheight+ygap*2);
  drawmyline(Tabs[2],y,Tabs[2],y+txtheight+ygap*2);
  drawmyline(Tabs[3],y,Tabs[3],y+txtheight+ygap*2);
  drawmyline(Tabs[4],y,Tabs[4],y+txtheight+ygap*2);
  if XML_DISPLAY.teachersfreeshow2 <> 3 then
  begin
    drawmyline(Tabs[5],y,Tabs[5],y+txtheight+ygap*2);
    drawmyline(Tabs[6],y,Tabs[6],y+txtheight+ygap*2);
  end;
  if XML_DISPLAY.teachersfreeshow2 <> 3 then drawmyline(x,y+txtheight+ygap*2,x+Tabs[6],y+txtheight+ygap*2)
  else drawmyline(x,y+txtheight+ygap*2,x+Tabs[4],y+txtheight+ygap*2);
  inc(y,ygap);
  for d:=0 to days-1 do
   drawmyline(Tabs[1]+d*dx,y-ygap,Tabs[1]+d*dx,y+txtheight+ygap);
 x:=x+locblankwidth;
 printw('Teacher');
 for d:=0 to days-1 do
 begin
  x:=Tabs[1]+dx*d+locblankwidth;
  astr:=dayname[d];
freetlistday:
  len:=length(astr);
  len1:=canvas.textwidth(astr);
  if ((len1>1) and ((len1+locblankwidth)>dx)) then
  begin
   astr:=copy(astr,1,len-1);
   goto freetlistday;
  end;
  printw(astr);
 end; {for d}
 if XML_DISPLAY.teachersfreeshow2 <> 3 then
 begin
   x:=Tabs[2]+locblankwidth; printw('Times');
   x:=Tabs[3]+locblankwidth; printw('Duties');
   x:=Tabs[4]+locblankwidth; printw('Alloted');
   x:=Tabs[5]+locblankwidth; printw('Free');
 end
 else
 begin
   x:=Tabs[2]+locblankwidth; printw('Times');
   x:=Tabs[3]+locblankwidth; printw('Total');
 end;
 newline;
  if XML_DISPLAY.teachersfreeshow2 <> 3 then
  begin
    inc(y,ygap); drawmyline(x,y,x+Tabs[6],y);
    drawmyline(x,y,x,y+txtheight+ygap*2);
    drawmyline(Tabs[1],y,Tabs[1],y+txtheight+ygap*2);
    drawmyline(Tabs[2],y,Tabs[2],y+txtheight+ygap*2);
    drawmyline(Tabs[3],y,Tabs[3],y+txtheight+ygap*2);
    drawmyline(Tabs[4],y,Tabs[4],y+txtheight+ygap*2);
    drawmyline(Tabs[5],y,Tabs[5],y+txtheight+ygap*2);
    drawmyline(Tabs[6],y,Tabs[6],y+txtheight+ygap*2);
    drawmyline(x,y+txtheight+ygap*2,x+Tabs[6],y+txtheight+ygap*2);
    inc(y,ygap);
  end
  else
  begin
    inc(y,ygap); drawmyline(x,y,x+Tabs[4],y);
    drawmyline(x,y,x,y+txtheight+ygap*2);
    drawmyline(Tabs[2],y,Tabs[2],y+txtheight+ygap*2);
    drawmyline(Tabs[3],y,Tabs[3],y+txtheight+ygap*2);
    drawmyline(Tabs[4],y,Tabs[4],y+txtheight+ygap*2);
    drawmyline(x,y+txtheight+ygap*2,x+Tabs[4],y+txtheight+ygap*2);
    inc(y,ygap);
  end;
    for d:=0 to days-1 do
     drawmyline(Tabs[1]+d*dx,y-ygap,Tabs[1]+d*dx,y+txtheight+ygap);
 for d:=0 to days-1 do
  for p:=0 to tlimit[d]-1 do
   begin
    x:=Tabs[1]+d*dx+chrwidth*(p)+locblankwidth;
    printw(tsCode[d,p]);
   end; {for p}
 newline;
 inc(y,ygap);
 if XML_DISPLAY.teachersfreeshow2 <> 3 then drawmyline(x,y,x+Tabs[6],y)
 else drawmyline(x,y,x+Tabs[4],y);
 if XML_DISPLAY.teachersfreeshow2=2 then
  freeend:=XML_DISPLAY.TeFreeSelect[0]
 else
   freeend:=codeCount[1];
 for k:=1 to freeend do
 begin
  if y>bottomCutoff then break;
  fcolor(cpNormal);
  if XML_DISPLAY.teachersfreeshow2=2then
      j:=XML_DISPLAY.TeFreeSelect[k]
   else j:=codepoint[k,1];
  count:=0; freet:=0; allotcnt:=0;yrCnt:=0;total:=0;
  oktoshow:=TeachInFac(j);
  if oktoshow and ((y+txtheight+2*ygap)<TopCutoff) then
   begin
    inc(y,txtheight+2*ygap);
    continue;
   end;
  if oktoshow then
   begin
    if not TeacherHasClasses then
      continue;
      
    if XML_DISPLAY.teachersfreeshow2 <> 3 then
    begin
      drawmyline(x,y,x,y+txtheight+ygap*2);
      drawmyline(Tabs[1],y,Tabs[1],y+txtheight+ygap*2);
      drawmyline(Tabs[2],y,Tabs[2],y+txtheight+ygap*2);
      drawmyline(Tabs[3],y,Tabs[3],y+txtheight+ygap*2);
      drawmyline(Tabs[4],y,Tabs[4],y+txtheight+ygap*2);
      drawmyline(Tabs[5],y,Tabs[5],y+txtheight+ygap*2);
      drawmyline(Tabs[6],y,Tabs[6],y+txtheight+ygap*2);
      drawmyline(x,y+txtheight+ygap*2,x+Tabs[6],y+txtheight+ygap*2);
      inc(y,ygap);
    end
    else
    begin
      drawmyline(x,y,x,y+txtheight+ygap*2);
      drawmyline(Tabs[2],y,Tabs[2],y+txtheight+ygap*2);
      drawmyline(Tabs[3],y,Tabs[3],y+txtheight+ygap*2);
      drawmyline(Tabs[4],y,Tabs[4],y+txtheight+ygap*2);
      drawmyline(x,y+txtheight+ygap*2,x+Tabs[4],y+txtheight+ygap*2);
      inc(y,ygap);
    end;

    x:=(Tabs[1] div 2)-(canvas.textwidth(XML_TEACHERS.tecode[j,0]) div 2);
    fcolor(cpTeach);
    printw(XML_TEACHERS.tecode[j,0]); fcolor(cpNormal);
    for d:=0 to days-1 do
    begin
     drawmyline(Tabs[1]+d*dx,y-ygap,Tabs[1]+d*dx,y+txtheight+ygap);
     for p:=0 to tlimit[d]-1 do
     begin
      x:=Tabs[1]+chrwidth*(p)+d*dx+locblankwidth;
      FindTeInTime(d,p,j,found,NAfound);
      if not(found) then
      begin
       freet:=freet+tsAllot[d,p];
       fcolor(cpBlockClash);
       // if teachersfreeshow2 <> 3 then
       printwl('_');  fcolor(cpNormal);
      end
      else
       begin
        if NAfound then printwl('N')
        else
         begin
          inc(count);
          allotcnt:=allotcnt+tsAllot[d,p];
          if XML_DISPLAY.teachersfreeshow2 <> 3 then
            printwl(tsCode[d,p])
          else
          begin
            GetTeachTtItem(sc,ro,teYear,Lev,j,d,p);
            if teYear = XML_DISPLAY.teFreeYear then
            begin
//              if MatchAllYears then
//              begin
//                fcolor(cpBlockClash);
//                printwl(tsCode[d,p]);
//                Inc(yrCnt);
//                total := total - 1;
//                fcolor(cpNormal);
//              end
                printwl(tsCode[d,p]);
                Inc(yrCnt);
                total := total + tsAllot[d,p];
            end // teYear = teFreeYear
            else
            begin
             // fix for empty time slots
             if XML_DISPLAY.teachersfreeshow2 = 3 then
             begin
               fcolor(cpBlockClash);
               printwl('_');  fcolor(cpNormal);
             end;
            end;
          end;
         end;
       end;
     end; {for p}
    end; {for d}
    dutyld:=0;
    for v:=0 to 2 do
     if (trim(XML_TEACHERS.DutyCode[j,v])<>'') then dutyld:=dutyld+XML_TEACHERS.DutyLoad[j,v];
    allotcnt:=allotcnt+dutyld;
    freet:=XML_TEACHERS.Load[j]-allotcnt;
    if freet<0 then freet:=0;
    if XML_DISPLAY.teachersfreeshow2 <> 3 then
    begin
      x:=Tabs[3]-(self.canvas.textwidth(inttostr(count))+locblankwidth);
      printw(inttostr(count));
      str(dutyld:4:1,astr);
      x:=Tabs[4]-(canvas.textwidth(astr)+locblankwidth);
      printw(astr);
      str(allotcnt:4:1,astr);
      x:=Tabs[5]-(canvas.textwidth(astr)+locblankwidth);
      printw(astr);
      str(freet:4:1,astr);
      x:=Tabs[6]-(canvas.textwidth(astr)+locblankwidth);
      printw(astr);
      newline;
      inc(y,ygap);
    end
    else
    begin
      x:=Tabs[3]-(self.canvas.textwidth(inttostr(yrCnt))+locblankwidth);
      printw(inttostr(yrCnt));
      str(total:4:1,astr);
      x:=Tabs[4]-(self.canvas.textwidth(astr)+locblankwidth);
      printw(astr);
      newline;
      inc(y,ygap);
    end;
   end;
 end; {for K}
end;

procedure TTeachersFree.tefrees;
var
 i,p,a,d,p1,te,l,f,c:     integer;
 tepoint,teprint:      tpPeriodData;
 yearY:                integer;
 aFnt,bFnt:            tpintpoint;
 found,doteprint,lineprinted: integer;
 chrw,chrw2:                        integer;
 yp1,yp2:                     integer;
 cc:                          integer;


      procedure nextteacher;
      begin
       a:=0;
       while a=0 do
       begin
        inc(tepoint[p]);
        te:=tepoint[p];
        a:=0;
        if tepoint[p]>codeCount[1] then exit;
        if ((tlimit[d]-TeOn[te,0])=p1) and (TeOn[te,p]=0) then a:=te;
        if (te=0) or (ord(XML_TEACHERS.tecode[te,0][1])=48) then a:=0;
       end;
      end; {end local proc}

      procedure teprintproc;
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
        al:=self.canvas.textwidth(astr) div 2;
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
 chrw:=canvas.textwidth('W')*(lencodes[1]+2);
 chrw2:=canvas.textwidth(' Times ');
 tmpRange:=chrw2+chrw*(periods)+2*hmargin;
 teachersfree.horzscrollbar.range:=tmpRange;

 for d:=dstrt to dfin do
 begin
  for i:=1 to numcodes[mycode] do
   for p:=0 to periods do TeOn[i,p]:=0;

  for p:=1 to tlimit[d] do
   for yearY:=0 to years_minus_1 do
   begin
    l:=0;
    aFnt:=FNT(d,p-1,yearY,l,0);
    for L:=1 to level[yearY] do
    begin
     inc(aFnt,4); bfnt:=afnt; inc(bfnt);
     te:=bfnt^;
     if TeOn[te,p]=0 then
     begin
      inc(TeOn[te,p]);
      inc(TeOn[te,0]);
     end;
    end; {for L}
   end; {for yearY}
  f:=chrw2+chrw*(tlimit[d]);
  c:=1;
  inc(y,ygap);
  printw('Teachers Free - '+dayname[d]);
  newline;
  teprintproc;
  for p1:=tlimit[d] downto 1 do
  begin
   yp1:=y;
   drawmyline(x,y,x+chrw2+chrw*(tlimit[d]),y); inc(y,ygap);
   for p:=0 to periods do
    tepoint[p]:=0;
   x:=(chrw2 div 2)-self.canvas.textwidth('W');
   printw(inttostr(p1));
   cc:=0;
   for i:=1 to codeCount[1] do
   begin
    found:=0;
    lineprinted:=0;
    for p:=1 to tlimit[d] do
    begin
     nextteacher;
     teprint[p]:=a;
     if a>0 then found:=-1;
    end; {for p}
    if bool(found) then
    begin
     for p:=1 to tlimit[d] do
     begin
      if teprint[p]>0 then
      begin
       fcolor(cpTeach);
       x:=chrw2+chrw*(p-1)+(chrw div 2)-(canvas.textwidth(XML_TEACHERS.tecode[teprint[p],0]) div 2);
       printw(XML_TEACHERS.tecode[teprint[p],0]);  fcolor(cpNormal);
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


procedure TTeachersFree.FormPaint(Sender: TObject);
begin
 fcolor(cpNormal);
 case winView[wnTeFree] of
  0: freesbytimeslot;
  1: begin
      tefrees;
      vertscrollbar.range:=y+Vscroll+3*txtHeight;
     end;
  2: freetlist;
 end; {case}
end;


{ ------------------------- print procs follow -----------------------------------}

procedure TPrintTfreeWin.head;
begin
 fcolor(cpNormal);
 UnderlineOn;
 printwl('Teachers Free');
 printw(PageCount);
 UnderlineOff;
 x:=0; y:=y+2*PrnttxtHeight;
 if mypagenumber>1 then
  case winView[wnTeFree] of
   0: if not(newheading) then drawmyline(x,y-ygap,x+PrntTabs[2],y-ygap);
   1: if not(newheading) then begin tefreesHead; inc(y,ygap); end;
   2: showheader;
 end; {case}
end;

procedure TPrintTfreeWin.showheader;
label freetlistday;
var
 d,p: integer;
 astr: string;
begin
 inc(y,ygap); drawmyline(x,y,x+PrntTabs[6],y);
 drawmyline(x,y,x,y+prnttxtheight+ygap*2);
 drawmyline(PrntTabs[1],y,PrntTabs[1],y+prnttxtheight+ygap*2);
 drawmyline(PrntTabs[2],y,PrntTabs[2],y+prnttxtheight+ygap*2);
 drawmyline(PrntTabs[3],y,PrntTabs[3],y+prnttxtheight+ygap*2);
 drawmyline(PrntTabs[4],y,PrntTabs[4],y+prnttxtheight+ygap*2);
 drawmyline(PrntTabs[5],y,PrntTabs[5],y+prnttxtheight+ygap*2);
 drawmyline(PrntTabs[6],y,PrntTabs[6],y+prnttxtheight+ygap*2);
 drawmyline(x,y+prnttxtheight+ygap*2,x+PrntTabs[6],y+prnttxtheight+ygap*2);
 inc(y,ygap);
 for d:=0 to days-1 do
  drawmyline(PrntTabs[1]+d*dx,y-ygap,PrntTabs[1]+d*dx,y+prnttxtheight+ygap);
 x:=x+locblankwidth;
 printw('Teacher');
 for d:=0 to days-1 do
  begin
   x:=PrntTabs[1]+dx*d+locblankwidth;
   astr:=dayname[d];
   freetlistday:
   len:=length(astr);
   len1:=PrintCanvas.textwidth(astr);
   if ((len1>1) and ((len1+locblankwidth)>dx)) then
    begin
     astr:=copy(astr,1,len-1);
     goto freetlistday;
    end;
   printw(astr);
  end; {for d}
  x:=PrntTabs[2]+locblankwidth; printw('Times');
  x:=PrntTabs[3]+locblankwidth; printw('Duties');
  x:=PrntTabs[4]+locblankwidth; printw('Alloted');
  x:=PrntTabs[5]+locblankwidth; printw('Free');
  x:=0; y:=y+prnttxtheight;
  inc(y,ygap); drawmyline(x,y,x+PrntTabs[6],y);
  drawmyline(x,y,x,y+prnttxtheight+ygap*2);
  drawmyline(PrntTabs[1],y,PrntTabs[1],y+prnttxtheight+ygap*2);
  drawmyline(PrntTabs[2],y,PrntTabs[2],y+prnttxtheight+ygap*2);
  drawmyline(PrntTabs[3],y,PrntTabs[3],y+prnttxtheight+ygap*2);
  drawmyline(PrntTabs[4],y,PrntTabs[4],y+prnttxtheight+ygap*2);
  drawmyline(PrntTabs[5],y,PrntTabs[5],y+prnttxtheight+ygap*2);
  drawmyline(PrntTabs[6],y,PrntTabs[6],y+prnttxtheight+ygap*2);
  drawmyline(x,y+prnttxtheight+ygap*2,x+PrntTabs[6],y+prnttxtheight+ygap*2);
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
  inc(y,ygap); drawmyline(x,y,x+PrntTabs[6],y);
 end;

procedure TPrintTfreeWin.SetTabs;
var
 tmpInt:          integer;
begin
 SetLength(PrntTabs,7);
 ygap:=prnttxtheight div 5;
 case winView[wnTeFree] of
  0: begin
      PrntTabs[0]:=fwprntperiodname+2*prntblankwidth;
      dx:=fwprntcode[1]+2*prntblankwidth+2*PrintCanvas.textwidth('99');
      tmpInt:=trunc(PrintPagewidth*0.9)-prntHmargin;
      subfit:= (tmpInt-PrntTabs[0]) div dx;
      if subfit=0 then subfit:=1;
      PrntTabs[2]:=PrntTabs[0]+dx*subfit;
     end;
  2: begin
      chrwidth:=fwprntTsCode;
      locblankwidth:=PrintCanvas.textwidth(' ');
      dx:=periods*chrwidth+2*locblankwidth;
      MaxTab(1,fwcode[1],'Teacher');
      MaxTab(2,days*dx,'');
      MaxTab(3,0,'Times ');
      MaxTab(4,0,'Duties ');
      MaxTab(5,0,'Alloted ');
      MaxTab(6,chrwidth*4,'Free ');
     end;
 end; {case}
end;


procedure TPrintTfreeWin.freesbytimeslot;
var
 k,p,d1,yearY,l: integer;
 j: smallint;
 astr: string;
 aFnt:            tpintpoint;

    procedure showteacherfreecode(J: integer);
    var
     aStr,bStr: string;
     adjust: integer;
    begin
     aStr:=trim(XML_TEACHERS.tecode[J,0]);
     if copy(aStr,1,2)<>'00' then
     begin
      bStr:=inttostr(TeLoadInt[J]);
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
      x:=PrntTabs[1]; fcolor(cpTeach); printwl(aStr+' ');
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
   if XML_DISPLAY.teachersfreefac>0 then
        printwl(facname[XML_DISPLAY.teachersfreefac]+' ');
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
      for k:=1 to numcodes[1] do TeFound[k]:=0;
      for yearY:=0 to years_minus_1 do
       begin
        aFnt:=FNT(d,p-1,yearY,0,2);
        for L:=1 to level[yearY] do
         begin
          inc(aFnt,4);
          j:=aFNt^;
          if (j>0) and (j<=numcodes[1]) then TeFound[j]:=-1;
         end; {for L}
       end; {for yearY}
      PrntTabs[1]:=PrntTabs[0];
      newline;
      printw(' '+TimeSlotName[d,P-1]);
      x:=PrntTabs[0];
      for k:=1 to codeCount[1] do
       begin
        J:=codepoint[K,1];
        if TeachInFac(j) then if TeFound[j]=0 then showteacherfreecode(J);
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

procedure TPrintTfreeWin.freetlist;
var
 astr:  string;
 d1,p,k,v:     integer;
 found,NAfound: boolean;
 j:         smallint;
 freestrt,freeend:      integer;
 allotcnt,freet,dutyld: double;

begin
 if (XML_DISPLAY.teachersfreefac>0) then
  begin
   printwl(facname[XML_DISPLAY.teachersfreefac]+' ');
   printw('Teachers Free');
   newline;
  end;
 if codeCount[mycode]=0 then
 begin
  printw('No Teachers entered.');
  exit;
 end;
 if ((XML_DISPLAY.teachersfreeshow2=2) and (XML_DISPLAY.TeFreeSelect[0]=0)) then
 begin
  printw('No Teachers selected.');
  exit;
 end;
 showheader;
 freestrt:=1;
 if XML_DISPLAY.teachersfreeshow2=2 then
  freeend:=XML_DISPLAY.TeFreeSelect[0]
 else
   freeend:=codeCount[1];
 for k:=freestrt to freeend do
 begin
  if XML_DISPLAY.teachersfreeshow2=2 then j:=XML_DISPLAY.TeFreeSelect[k]
   else j:=codepoint[k,mycode];
  count:=0; freet:=0; allotcnt:=0;
  if TeachInFac(j) then
   begin
    drawmyline(x,y,x,y+prnttxtheight+ygap*2);
    drawmyline(PrntTabs[1],y,PrntTabs[1],y+prnttxtheight+ygap*2);
    drawmyline(PrntTabs[2],y,PrntTabs[2],y+prnttxtheight+ygap*2);
    drawmyline(PrntTabs[3],y,PrntTabs[3],y+prnttxtheight+ygap*2);
    drawmyline(PrntTabs[4],y,PrntTabs[4],y+prnttxtheight+ygap*2);
    drawmyline(PrntTabs[5],y,PrntTabs[5],y+prnttxtheight+ygap*2);
    drawmyline(PrntTabs[6],y,PrntTabs[6],y+prnttxtheight+ygap*2);
    drawmyline(x,y+prnttxtheight+ygap*2,x+PrntTabs[6],y+prnttxtheight+ygap*2);
    inc(y,ygap);
    x:=(PrntTabs[1] div 2)-(PrintCanvas.textwidth(XML_TEACHERS.tecode[j,0]) div 2);
    fcolor(cpTeach); printw(XML_TEACHERS.tecode[j,0]); fcolor(cpNormal);
    for d1:=0 to days-1 do
    begin
     d:=d1;
     drawmyline(PrntTabs[1]+d*dx,y-ygap,PrntTabs[1]+d*dx,y+prnttxtheight+ygap);
     for p:=0 to tlimit[d]-1 do
     begin
      x:=PrntTabs[1]+chrwidth*(p)+d*dx+locblankwidth;
      FindTeInTime(d,p,j,found,NAfound);
      if not(found) then
      begin
       freet:=freet+tsAllot[d,p];
       fcolor(cpBlockClash);
       printwl('_');  fcolor(cpNormal);
      end
      else
       begin
        if NAfound then printwl('N')
        else
         begin
          inc(count);
          allotcnt:=allotcnt+tsAllot[d,p];
          printwl(tsCode[d,p]);
         end;
       end;
     end; {for p}
    end; {for d}
    dutyld:=0;
    for v:=0 to 2 do
     if (trim(XML_TEACHERS.DutyCode[j,v])<>'') then dutyld:=dutyld+XML_TEACHERS.DutyLoad[j,v];
    allotcnt:=allotcnt+dutyld;
    freet:=XML_TEACHERS.Load[j]-allotcnt;
    if freet<0 then freet:=0;
    x:=PrntTabs[3]-(PrintCanvas.textwidth(inttostr(count))+locblankwidth);
    printw(inttostr(count));
    str(dutyld:4:1,astr);
    x:=PrntTabs[4]-(PrintCanvas.textwidth(astr)+locblankwidth);
    printw(astr);
    str(allotcnt:4:1,astr);
    x:=PrntTabs[5]-(PrintCanvas.textwidth(astr)+locblankwidth);
    printw(astr);
    str(freet:4:1,astr);
    x:=PrntTabs[6]-(PrintCanvas.textwidth(astr)+locblankwidth);
    printw(astr);
    newline;
    inc(y,ygap);
   end;

 end; {for K}
 printCustomAddon;
end;

procedure TPrintTfreeWin.TeFreesHead;
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

procedure TPrintTfreeWin.tefrees;
var
 i,p,d1,a,p1,te,l,f,c:     integer;
 tepoint,teprint:      array[0..nmbrperiods] of integer;
 yearY:                integer;
 aFnt,bFnt:            tpintpoint;
 found,doteprint,lineprinted: integer;
 yp1,yp2:                     integer;
 cc:                          integer;
 pestrt,peend: integer;


      procedure nextteacher;
      begin
       a:=0;
       while a=0 do
       begin
        inc(tepoint[p]);
        te:=tepoint[p];
        a:=0;
        if tepoint[p]>codeCount[1] then exit;
        if ((tlimit[d]-TeOn[te,0])=p1) and (TeOn[te,p]=0) then a:=te;
        if (te=0) or (ord(XML_TEACHERS.tecode[te,0][1])=48) then a:=0;
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
    TeOn[i,p]:=0;
    pestrt:=1;
    peend:=tlimit[d];
  for p:=pestrt to peend do
   for yearY:=0 to years_minus_1 do
   begin
    l:=0;
    aFnt:=FNT(d,p-1,yearY,l,0);
    for L:=1 to level[yearY] do
    begin
     inc(aFnt,4); bfnt:=afnt; inc(bfnt);
     te:=bfnt^;
     if TeOn[te,p]=0 then
     begin
      inc(TeOn[te,p]);
      inc(TeOn[te,0]);
     end;
    end; {for L}
   end; {for yearY}
  f:=chrw2+chrw*(tlimit[d]);
  c:=1;
  inc(y,ygap);
  printw(dayname[d]);
  newline;
  TeFreesHead;
  for p1:=peend downto pestrt do
  begin
   drawmyline(x,y,x+chrw2+chrw*(tlimit[d]),y); inc(y,ygap);
   for p:=0 to periods do
    tepoint[p]:=0;
   x:=(chrw2 div 2)-PrintCanvas.textwidth('W');
   printw(inttostr(p1));
   cc:=0;
   for i:=1 to codeCount[1] do
   begin
    found:=0;
    lineprinted:=0;
    for p:=pestrt to peend do
    begin
     nextteacher;
     teprint[p]:=a;
     if a>0 then found:=-1;
    end; {for p}
    if bool(found) then
    begin
     for p:=pestrt to peend do
     begin
      if teprint[p]>0 then
      begin
       x:=chrw2+chrw*(p-1)+(chrw div 2)-(PrintCanvas.textwidth(XML_TEACHERS.tecode[teprint[p],0]) div 2);
       fcolor(cpTeach); printw(XML_TEACHERS.tecode[teprint[p],0]); fcolor(cpNormal);
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

procedure TeachersFreeprint;
begin
 PrintTfreeWin:=TPrintTfreeWin.create;
 with PrintTfreeWin do
  try
   PrintHead;
   case winView[wnTeFree] of
    0: freesbytimeslot;
    1: tefrees;
    2: freetlist;
   end; {case}
  finally
   PrintTfreeWin.Free;
  end;
end;

procedure TOutTfreeWin.head;
begin
 printw('Teachers Free');
 newline; newline;
end;

procedure TOutTfreeWin.freesbytimeslot;
var
 k,d,p,yearY,l: integer;
 j: smallint;
 astr: string;
 aFnt:            tpintpoint;

    procedure showteacherfreecode(J: integer);
    var
     aStr,bStr: string;
    begin
     aStr:=trim(XML_TEACHERS.tecode[J,0]);
     if copy(aStr,1,2)<>'00' then
     begin
      bStr:=inttostr(TeLoadInt[J]);
      printc(aStr);
      printc(bStr);
      inc(count);
     end;
    end;


begin
 for d:=dstrt to dfin do
  begin
   if XML_DISPLAY.teachersfreefac>0 then
        printw(facname[XML_DISPLAY.teachersfreefac]+' ');
   printw(dayname[D]);
   newline;
   GetTimeLimits(d);
   for p:=pestrt to peend do
    if XML_DISPLAY.TsOn[d,p-1] then
     begin
      newline;
      count:=0;
      for k:=1 to numcodes[1] do TeFound[k]:=0;
      for yearY:=0 to years_minus_1 do
       begin
        aFnt:=FNT(d,p-1,yearY,0,2);
        for L:=1 to level[yearY] do
         begin
          inc(aFnt,4);
          j:=aFNt^;
          if (j>0) and (j<=numcodes[1]) then TeFound[j]:=-1;
         end; {for L}
       end; {for yearY}
      newline;
      printw(TimeSlotName[d,P-1]);
      for k:=1 to codeCount[1] do
       begin
        J:=codepoint[K,1];
        if TeachInFac(j) then if TeFound[j]=0 then showteacherfreecode(J);
       end; {for k}
      aStr:='Total: '+inttostr(count);
      printw(aStr);
     end; {if TsOn[d,p-1]}
   newline; newline;
   printCustomAddon;
   newline;
  end; {for D}
end;

procedure TOutTfreeWin.freetlist;
var
 astr:  string;
 d,p,k,v,j:     integer;
 found,NAfound: boolean;
 allotcnt,freet,dutyld: double;
 freestrt,freeend:      integer;
begin
 if (XML_DISPLAY.teachersfreefac>0) then
  begin
   printw(facname[XML_DISPLAY.teachersfreefac]+' ');
   printw('Teachers Free');
   newline;
  end;
 if codeCount[mycode]=0 then
 begin
  printw('No Teachers entered.');
  exit;
 end;
 if ((XML_DISPLAY.teachersfreeshow2=2) and (XML_DISPLAY.TeFreeSelect[0]=0)) then
 begin
  printw('No Teachers selected.');
  exit;
 end;
 showheader;
 freestrt:=1;
 if XML_DISPLAY.teachersfreeshow2=2 then
  freeend:=XML_DISPLAY.TeFreeSelect[0]
 else
   freeend:=codeCount[mycode];
 for k:=freestrt to freeend do
 begin
  if XML_DISPLAY.teachersfreeshow2=2 then
      j:=XML_DISPLAY.TeFreeSelect[k]
   else j:=codepoint[k,1];
  count:=0; freet:=0; allotcnt:=0;
  if TeachInFac(j) then
   begin
    printw(XML_TEACHERS.tecode[j,0]);
    for d:=0 to days-1 do
    begin
     astr:='';
     for p:=0 to tlimit[d]-1 do
     begin
      FindTeInTime(d,p,j,found,NAfound);
      if not(found) then
      begin
       freet:=freet+tsAllot[d,p];
       astr:=astr+'_';
      end
      else
       begin
        if NAfound then astr:=astr+'N'
        else
         begin
          inc(count);
          allotcnt:=allotcnt+tsAllot[d,p];
          astr:=astr+tsCode[d,p];
         end;
       end;
     end; {for p}
     printc(astr);
    end; {for d}
    dutyld:=0;
    for v:=0 to 2 do
     if (trim(XML_TEACHERS.DutyCode[j,v])<>'') then dutyld:=dutyld+XML_TEACHERS.DutyLoad[j,v];
    allotcnt:=allotcnt+dutyld;
    freet:=XML_TEACHERS.Load[j]-allotcnt;
    if freet<0 then freet:=0;
    printc(inttostr(count));
      str(dutyld:4:1,astr);
    printc(astr);
     str(allotcnt:4:1,astr);
    printc(astr);
    str(freet:4:1,astr);
    printc(astr);
    newline;
   end;
 end; {for K}
 printCustomAddon;
end;

procedure TOutTfreeWin.tefrees;
var
 i,p,a,d,p1,te,l:     integer;
 tepoint,teprint:      array[0..nmbrperiods] of integer;
 yearY:                integer;
 aFnt,bFnt:            tpintpoint;
 found,lineprinted: integer;
 cc:                          integer;
 pestrt,peend: integer;


      procedure nextteacher;
      begin
       a:=0;
       while a=0 do
       begin
        inc(tepoint[p]);
        te:=tepoint[p];
        a:=0;
        if tepoint[p]>codeCount[1] then exit;
        if ((tlimit[d]-TeOn[te,0])=p1) and (TeOn[te,p]=0) then a:=te;
        if (te=0) or (ord(XML_TEACHERS.tecode[te,0][1])=48) then a:=0;
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
    TeOn[i,p]:=0;
    pestrt:=1;
    peend:=tlimit[d];
  for p:=pestrt to peend do
   for yearY:=0 to years_minus_1 do
   begin
    l:=0;
    aFnt:=FNT(d,p-1,yearY,l,0);
    for L:=1 to level[yearY] do
    begin
     inc(aFnt,4); bfnt:=afnt; inc(bfnt);
     te:=bfnt^;
     if TeOn[te,p]=0 then
     begin
      inc(TeOn[te,p]);
      inc(TeOn[te,0]);
     end;
    end; {for L}
   end; {for yearY}
  printw(dayname[d]);
  newline;
  teprintproc;
  for p1:=peend downto pestrt do
  begin
   for p:=0 to periods do
    tepoint[p]:=0;
   printw(inttostr(p1));
   cc:=0;
   for i:=1 to codeCount[1] do
   begin
    found:=0;
    lineprinted:=0;
    for p:=pestrt to peend do
    begin
     nextteacher;
     teprint[p]:=a;
     if a>0 then found:=-1;
    end; {for p}
    if bool(found) then
    begin
     for p:=pestrt to peend do
     begin
      if teprint[p]>0 then
      begin
       printc(XML_TEACHERS.tecode[teprint[p],0]);
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

procedure TOutTfreeWin.showheader;
var
 d,p: integer;
 astr: string;
begin
 printw('Teacher');
 for d:=0 to days-1 do printc(dayname[d]);
 printc('Times');
 printc('Duties');
 printc('Alloted');
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

procedure TeachersFreetext;
begin
 OutTfreeWin:=TOutTfreeWin.create;
 with OutTfreeWin do
  try
   Header;
   case winView[wnTeFree] of
    0: freesbytimeslot;
    1: tefrees;
    2: freetlist;
   end; {case}
  finally
   OutTfreeWin.Free;
  end;

end;




end.
