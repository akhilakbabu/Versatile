unit Tetimes;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Menus, StdCtrls, TimeChartGlobals,ClassDefs, GlobalToTcAndTcextra,
  XML.DISPLAY, XML.TEACHERS, XML.STUDENTS;

type
  TTeacherTimes = class(TDrawWin)
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
  private
    myLev1:         smallint;
    procedure printteachtimes(yeary: smallint;var count1: integer);
    procedure PrintOffset(b:smallint; tab:integer);
  end;

var
  TeacherTimes: TTeacherTimes;

   
procedure TeacherTimesPrint;
procedure TeacherTimestext;


implementation
uses tcommon,main,printers,tetimdlg,tcommon2;
{$R *.DFM}

type TPrintTeTimesWin=class(TPrintDrawWin)
  public
   procedure head; override;
   procedure SetTabs; override;
  private
    myLev1:         smallint;
   procedure printteachtimes(yeary: smallint;var count1: integer);
   procedure PrintOffset(b:smallint; tab:integer);
 end;

 type TOutTeTimesWin=class(TOutputwin)
  public
   procedure head; override;
  private
    myLev1:         smallint;
    FirstOneflg:    boolean;
    procedure printteachtimes(yeary,i: smallint;var count1: integer);
 end;


var
 PrintTeTimesWin:  TPrintTeTimesWin;
 OutTeTimesWin:   TOutTeTimesWin;
 pfree:             tpSubData;
 TeCount,TeSub,teline:          tpTeData;
 maxx1c:            longint;
 lcnt:              integer;
 subcount : double;


procedure calcvertrange_teacherperiod;
var
 ystart,yend:         integer;
 i,j,k,v:             integer;
 yeary,l:           integer;
 count,count1,dutycount:           integer;
 num:                   integer;
 astr:                  string;

  procedure tcount1;
  var
   d,p,sub,te:         integer;
   aFnt:   tpintpoint;
  begin
   for d:=0 to days-1 do
    for p:=1 to tlimit[d] do
     begin
      aFnt:=FNT(d,p-1,yeary,l,2);
      te:=aFnt^;
      if te>0 then
       begin
        dec(aFnt);
        sub:=aFnt^;
        if (sub<>subNA) then
        begin
         if TeSub[te]=0 then TeSub[te]:=sub;
         if (TeSub[te]>0) and (TeSub[te]<>sub) then TeSub[te]:=-1;
        end;
       end; {if (te>0)}
     end; {for p}
  end;

begin
 ystart:=0; yend:=years_minus_1;  count1:=0;
 if (winView[wnTeTimes]=2) and (XML_DISPLAY.teachertimesyear<>years) then
  begin
   ystart:=XML_DISPLAY.teachertimesyear; yend:=XML_DISPLAY.teachertimesyear;
  end;

 for i:=0 to nmbrteachers do TeCount[i]:=0;
 for i:=0 to nmbrteachers do TeLine[i]:=0;

 for yeary:=ystart to yend do
  begin
   if classInYear[yeary] then
    for l:=1 to level[yeary] do
     begin
      for j:=0 to nmbrteachers do TeSub[j]:=0;
      tcount1;
      for i:=1 to numcodes[1] do begin
       if TeSub[i]>0 then inc(TeCount[i]);
       if TeSub[i]<0 then
        begin
         ClearTeDoSub;
         tcount(yeary,i,l);
         for j:=1 to numcodes[0] do if TeDoSub[j]>0 then inc(TeCount[i]);
        end;
      end; {i}
     end {for l}
   else {not classInYear[yeary]}
    begin
     for j:=0 to nmbrteachers do TeSub[j]:=0;
     for l:=1 to level[yeary] do tcount1;
     for i:=1 to numcodes[1] do begin
       if TeSub[i]>0 then inc(TeCount[i]);
       if TeSub[i]<0 then
        begin
         ClearTeDoSub;
         for l:=1 to level[yeary] do tcount(yeary,i,l);
         for j:=1 to numcodes[0] do if TeDoSub[j]>0 then inc(TeCount[i]);
        end;
      end; {i}
    end;
  end; {yeary}

 for i:=0 to nmbrSubjects do pfree[i]:=0;

 if XML_DISPLAY.teachertimesshow2=2 then num:=XML_DISPLAY.TeTimesSelect[0]
  else num:=codeCount[1];
 count:=0;  lcnt:=3; maxx1c:=3;
 for k:=1 to num do
  begin
   if XML_DISPLAY.teachertimesshow2<>2 then
      i:=codepoint[k,1]
   else
      i:=XML_DISPLAY.TeTimesSelect[k];
   if not(TeachInAnyFac(i,XML_DISPLAY.teachertimesfac)) then continue;
   aStr:=copy(XML_TEACHERS.tecode[i,0],1,2);
   if (i=0) or (aStr='00') or ((TeCount[i]=0) and (winView[wnTeTimes]=2))
     then continue;
   inc(count); pfree[count]:=i;
   dutycount:=0;
   for v:=0 to 2 do
    if (trim(XML_TEACHERS.DutyCode[i,v])<>'') then inc(dutycount);
   case winView[wnTeTimes] of
    0: count1:=2+((dutycount+TeCount[i]+lcnt-1) div lcnt);
    1: count1:=2+dutycount+TeCount[i];
    2: count1:=(TeCount[i]+lcnt-1) div lcnt
   end; {case}
   TeLine[count]:=maxx1c;
   inc(maxx1c,count1);
  end; {k}
  pfree[0]:=count;
  inc(maxx1c,3);
end;



procedure TTeacherTimes.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 XML_DISPLAY.teachertimesshow1:=winView[wnTeTimes]+1;
 action:=caFree;
end;

procedure TTeacherTimes.FormCreate(Sender: TObject);
begin
 setWindowDefaults(self,wnTeTimes);
 winView[wnTeTimes]:=XML_DISPLAY.teachertimesshow1-1;
end;

procedure TTeacherTimes.Selection2Click(Sender: TObject);
begin
 Teachertimesdlg:=TTeachertimesdlg.create(self);   {allocate dlg}
 Teachertimesdlg.showmodal;
 Teachertimesdlg.free;
end;

procedure TTeacherTimes.SetTabs;
var
 i: integer;
begin
 calculateloads;
 SetLength(Tabs,12); //was 10   mantis-0181
 headwidth:=canvas.textwidth('Teacher Loads - Summary ');
 Tabs[1]:=fwcode[1]+blankwidth*3+fwcodename[1];
 Tabs[4]:=canvas.textwidth(yearshort+': ')+fwyearname+blankwidth*3+fwclass+fwcode[0];
 Tabs[2]:=Tabs[1]+Tabs[4];
 Tabs[3]:=Tabs[1]+Tabs[4]*2;
 i:=TeacherTimes.canvas.textwidth('Code');
 if fwcode[1]>i then i:=fwcode[1];
 Tabs[0]:=i+blankwidth;
 Tabs[5]:=canvas.textwidth('99 ')+blankwidth*3+fwclass+fwcode[0];

 if winView[wnTeTimes]=1 then
  begin
   MaxTab(2,fwcode[0],'Subject');
   MaxTab(3,fwyearname,yeartitle);
   MaxTab(4,fwclass,'Class');
   MaxTab(5,0,genderLong[0]);  {MaxTab(5,0,'Males')}
   MaxTab(6,0,genderLong[1]);  { MaxTab(6,0,'Females')}
   MaxTab(7,0,genderLong[2]);  { MaxTab(7,0,'Unspecified')}  //mantis-0181
   MaxTab(8,0,'Stud.');    //was 7   mantis-0181
   MaxTab(9,0,'Times');    //was 8   mantis-0181
   MaxTab(10,0,'Alloted ');  //was 9  mantis-0181
 //  MaxTab(11,0,'Periods/Room ');  //  mantis-0181 .b
  end;
 case winView[wnTeTimes] of
  0: MaxW:=Tabs[1]+hmargin*2+(6*Tabs[4]);
  1: MaxW:=(longint(hmargin)*2)+longint(Tabs[11])  //was Tabs[9]  mantis-0181  .b
       +TeacherTimes.canvas.textwidth('/99 ');
  2: MaxW:=longint(Tabs[1])+(longint(hmargin)*2)+(longint(lcnt)*longint(Tabs[5]));
 end; {case}
 if XML_DISPLAY.teachertimesfac>0 then
    headwidth:=headwidth+canvas.textwidth(' - '+facname[XML_DISPLAY.teachertimesfac]);

 {calc vert range}
 maxx1c:=4;
 calcvertrange_teacherperiod;
 maxH:=maxx1c*txtheight;
end;


procedure TTeacherTimes.PrintOffset(b:smallint; tab:integer);
var
 aStr: string;
 inset: integer;
begin
 Inset:=canvas.textwidth('999');
 astr:=inttostr(b);
 x:=tab+Inset-canvas.textwidth(aStr); printw(astr);
end;

procedure TTeacherTimes.printteachtimes(yeary: smallint;var count1: integer);
var
 j,a:   integer;
 aStr:          string;
 mycount,YearUse: integer;

begin
  // subcount:=0;
   
 if winView[wnTeTimes]=1 then
 begin
  for j:=1 to numcodes[0] do
  begin
   a:=TeDoSub[j];
   if a>0 then
   begin
    fcolor(cpSub); x:=Tabs[1]; printwl(SubCode[j]);
    fcolor(cpClass); x:=Tabs[2]; printwl(yearname[yeary]);
    x:=Tabs[3];
    if classInYear[yeary] then printwl(ClassCode[ClassShown[myLev1,yeary]]);
    fcolor(cpNormal);
    YearUse:=yeary;if XML_DISPLAY.MatchAllYears then YearUse:=-1;
    if SuMale[j,YearUse]>0 then PrintOffset(SuMale[j,YearUse],Tabs[4]);
    if SuFemale[j,YearUse]>0 then PrintOffset(SuFemale[j,YearUse],Tabs[5]);
    if SuUnspecified[j,YearUse]>0 then PrintOffset(SuUnspecified[j,YearUse],Tabs[6]);  //mantis-0181
      mycount:=SuMale[j,YearUse]+SuFemale[j,YearUse]+SuUnspecified[j,YearUse]; //mantis-0181
    if mycount>0 then PrintOffset(mycount,Tabs[7]);   //was Tabs[6]  mantis-0181
    PrintOffset(a,Tabs[8]);     //was Tabs[7] mantis-0181
    str(TeAllot[j]:6:2,aStr);

    if SubWillcount[j]='N' then   //Mantis-1295
    begin
        subcount   := subcount+StrToFloat(aStr) ;
        aStr :='0.00';
    end ;

    x:=Tabs[10]-self.canvas.textwidth(aStr);    //was Tabs[9]  mantis-0181
    printwl(aStr);
    fcolor(cpBlockClash);
    if TeShare[j]=-1 then printwl(' shared');
    fcolor(cpNormal);
    newline;
   end; {if a>0}
  end; {for j}
 end
 else
  begin
   for j:=1 to numcodes[0] do
   begin
    a:=TeDoSub[j];
    if a>0 then
    begin
     fcolor(cpClass);
     if (((count1 mod lcnt)=0) and (count1<>0)) then
      begin
       count1:=0;
       newline;
      end;
     if winView[wnTeTimes]<2 then
     begin
      x:=Tabs[1]+count1*Tabs[4];
      printwl(yearshort+' '+yearname[yeary]+' ');
     end
     else
      x:=Tabs[1]+count1*Tabs[5];
     aStr:=trim(ClassCode[ClassShown[myLev1,yeary]]);
     if (classInYear[yeary] and (aStr>'')) then printwl(aStr+' ');
     fcolor(cpSub);
     printwl(SubCode[j]);
     fcolor(cpNormal);
     printwl(' '+inttostr(a)+'   '); inc(count1);

     //-----------Mantis-1295
     str(TeAllot[j]:6:2,aStr);
    if SubWillcount[j]='N' then
    begin
        subcount   := subcount+StrToFloat(aStr) ;
        aStr :='0.00';
    end ;
     //-----------Mantis-1295
    end; {if a>0}
   end; {for j}
 end;
end;




procedure TTeacherTimes.FormPaint(Sender: TObject);
var
 kstart:          integer;
 lcnt:  integer;
 found:                bool;
  ystart,yend,y2:        integer;
  ldt:                   double;
  i,k,v:                 integer;
  yeary,l:               integer;
  shared:                integer;
  count1:                integer;
  tmpStr:                string;
  num:                   integer;

begin
 fcolor(cpNormal);
 lcnt:=3;
 ystart:=0; yend:=years_minus_1;
  case winView[wnTeTimes] of
   0: printwl('Teacher Loads - Summary ');
   1: begin
       printw('Code'); x:=Tabs[0];
       printw('Name'); x:=Tabs[1];
       printw('Subject'); x:=Tabs[2];
       printw(yeartitle); x:=Tabs[3];
       printw('Class'); x:=Tabs[4];
       printw(genderLong[0]); {printw('Males');} x:=Tabs[5];
       printw(genderLong[1]); {printw('Females');} x:=Tabs[6];
       printw(genderLong[2]); {printw('Unspecified');} x:=Tabs[7];  // mantis-0181


       printw('Stud.'); x:=Tabs[8]; //was Tabs[7]  mantis-0181
       printw('Times');
       tmpstr:=TslotUnitName[TslotUnit];
       x:=Tabs[10]-canvas.textwidth(tmpstr); printwl(tmpstr);  //was Tabs[9]  mantis-0181
    //   x:=Tabs[11]-canvas.textwidth('Periods/Room.');// mantis-0181
    //   printw('   Periods/Room.'); // mantis-0181
      end;
   2: begin
       if XML_DISPLAY.teachertimesyear=years then
       begin
        printwl('Teachers in All '+yeartitle+'s ');
        ystart:=0; yend:=years_minus_1;
       end
       else
        begin
         printwl(yeartitle+' '+yearname[XML_DISPLAY.teachertimesyear]+' Teachers ');
         ystart:=XML_DISPLAY.teachertimesyear; yend:=XML_DISPLAY.teachertimesyear;
        end;
      end;
  end; {case}
  if XML_DISPLAY.teachertimesfac>0 then printw(' - '+facname[XML_DISPLAY.teachertimesfac]);
  newline;  newline;
  num:=pfree[0];
  kstart:=1;
  if num>1 then
   for k:=1 to num do
    begin
     y2:=(txtHeight*TeLine[k])-Vscroll;
     if (y2<-txtHeight) then
      begin
       y:=y2; kstart:=k;
      end
     else break;
    end;

  for k:=kstart to num do
  begin
   if y>BottomCutoff then break;
   i:=pfree[k];
   if (i=0) then continue;
   begin
   subcount:=0;//mantis-190
   TeDoSub[0]:=0;
   fcolor(cpTeach);
   printwl(XML_TEACHERS.tecode[i,0]+'  ');
   x:=Tabs[0];
   printwl(XML_TEACHERS.TeName[i,0]);
   x:=Tabs[1];
   fcolor(cpNormal);
   count1:=0;
   for yeary:=ystart to yend do
    begin
     if classInYear[yeary] then
      for l:=1 to level[yeary] do
       begin
        myLev1:=l;
        ClearTeDoSub;
        tcount(yeary,i,l);
        printteachtimes(yeary,count1);
       end {for l}
     else {not classInYear[yeary]}
      begin
       ClearTeDoSub;

       for l:=1 to level[yeary] do tcount(yeary,i,l);
       printteachtimes(yeary,count1);

      end;
    end; {for yeary}
   if winView[wnTeTimes]=2 then newline;
   if winView[wnTeTimes]<2 then
   begin
    found:=false;
    for v:=0 to 2 do
     if trim(XML_TEACHERS.DutyCode[i,v])>'' then found:=true;
    ldt:=0; {double}
    if (found) then
     begin
      fcolor(cpNormal);
      if winView[wnTeTimes]=0 then
       begin
        for v:=0 to 2 do
         begin
          if (trim(XML_TEACHERS.DutyCode[i,v])<>'') then
           begin
            x:=Tabs[1]+count1*Tabs[4];
            printwl('Duty'+chr(49+v)+': '+XML_TEACHERS.DutyCode[i,v]);
            str(XML_TEACHERS.DutyLoad[i,v]:6:2,tmpStr);
            printwl(tmpstr);
            ldt:=ldt+XML_TEACHERS.DutyLoad[i,v];
            inc(count1);
            if (((count1 mod lcnt)=0) and (count1<>0)) then
             begin
              count1:=0;  newline;
             end
            else
              printwl('    ');
           end;
         end; {for v}
       end
     else   {not winView[wnTeTimes]=0}
      if winView[wnTeTimes]=1 then {not for=2}
      begin
       for v:=0 to 2 do
       begin
        if trim(XML_TEACHERS.DutyCode[i,v])<>'' then
        begin
         x:=Tabs[1];
         printwl('Duty'+chr(49+v)+': '+XML_TEACHERS.DutyCode[i,v]);
         str(XML_TEACHERS.DutyLoad[i,v]:6:2,tmpStr);
         x:=Tabs[10]-self.canvas.textwidth(tmpstr);  // was Tabs[9] mantis-0181
         printwl(tmpstr);
         ldt:=ldt+XML_TEACHERS.DutyLoad[i,v];
         newline;
        end;
       end;
      end;
    end; {if found}
    shared:=TeDoSub[0]-Teaching[i];

    if winView[wnTeTimes]=0 then
    begin
     if count1<>0 then newline;
     x:=Tabs[1];
     printwl('Total time slots '+inttostr(Teaching[i])+'  Load: ');
    // str((TeLoad[i]+ldt):6:2,tmpstr);
       str((TeLoad[i]-subcount+ldt):6:2,tmpstr);  //mantis-1295

     printwl(tmpstr+'/'+inttostr(XML_TEACHERS.Load[i]));
     if shared>1 then tmpstr:='classes' else tmpstr:='class';
     if shared>0 then
      begin
       fcolor(cpBlockClash);
       printw('  '+inttostr(shared)+' shared '+tmpstr);
       fcolor(cpNormal);
      end;
     newline;
    end
    else
     begin
      if shared>1 then tmpstr:='classes' else tmpstr:='class';
      if shared>0 then
       begin
        fcolor(cpBlockClash);
        printw(inttostr(shared)+' shared '+tmpstr);
        fcolor(cpNormal);
       end;
      x:=Tabs[5]-blankwidth*3;
      printwl('Totals ');
      PrintOffset(Teaching[i],Tabs[8]);  // was Tabs[7] mantis-0181

    //  TeLoad[i] :=TeLoad[i]-subcount;

      str((TeLoad[i]-subcount+ldt):6:2,tmpstr);

     // str((TeLoad[i]-subcount):6:2,tmpstr);  //mantis-1295

      x:=Tabs[10]-canvas.textwidth(tmpstr);  //was Tabs[9]  mantis-0181
      printwl(tmpstr);
      printw('/'+inttostr(XML_TEACHERS.Load[i]));
      newline;
     end;
    newline;
   end;
  end;
 end; {for k}
 printw('Teachers: '+inttostr(num));
end;

{----------------------- printing procs follow --------------------------------------}


procedure TPrintTeTimesWin.head;
var
 tmpstr:string;
begin
 fcolor(cpNormal);
 UnderlineOn;
 printwl('Teacher Loads');
 if XML_DISPLAY.teachertimesfac>0 then printw(' - '+facname[XML_DISPLAY.teachertimesfac]);
 printw(PageCount);
 UnderlineOff;
 x:=0; y:=y+2*PrnttxtHeight;

 case winView[wnTeTimes] of
  0: printwl('Summary');
  1: begin
      printw('Code'); x:=PrntTabs[0];
      printw('Name'); x:=PrntTabs[1];
      printw('Subject'); x:=PrntTabs[2];
      printw(yeartitle); x:=PrntTabs[3];
      printw('Class'); x:=PrntTabs[4];
      printw(genderLong[0]); {printw('Males');} x:=PrntTabs[5];
      printw(genderLong[1]); {printw('Females');} x:=PrntTabs[6];
      printw('Stud.'); x:=PrntTabs[7];
      printw('Times');
      tmpstr:=TslotUnitName[TslotUnit];
      x:=PrntTabs[9]-PrintCanvas.textwidth(tmpstr); printwl(tmpstr);
     end;
  2: begin
      if XML_DISPLAY.teachertimesyear=years then
       printwl('Teachers in All '+yeartitle+'s ')
      else
       printwl(yeartitle+' '+yearname[XML_DISPLAY.teachertimesyear]+' Teachers');
    end;
 end; {case}
  x:=0; y:=y+2*PrnttxtHeight;
end;



procedure TPrintTeTimesWin.SetTabs;
var
 i: integer;
begin
 SetLength(PrntTabs,10);
 PrntTabs[1]:=fwprntcode[1]+blankwidth*3+fwprntcodename[1];
 PrntTabs[4]:=PrintCanvas.textwidth(yearshort+': ')+fwprntyearname
    +prntblankwidth*3+fwprntclass+fwprntcode[0];
 PrntTabs[2]:=PrntTabs[1]+PrntTabs[4];
 PrntTabs[3]:=PrntTabs[1]+PrntTabs[4]*2;
 i:=PrintCanvas.textwidth('Code');
 if fwprntcode[1]>i then i:=fwprntcode[1];
 PrntTabs[0]:=i+prntblankwidth;
 PrntTabs[5]:=PrintCanvas.textwidth('99 ')+prntblankwidth*3+fwprntclass+fwprntcode[0];
 if winView[wnTeTimes]=1 then
  begin
   MaxTab(2,fwprntcode[0],'Subject');
   MaxTab(3,fwprntyearname,yeartitle);
   MaxTab(4,fwprntclass,'Class');
   MaxTab(5,0,genderLong[0]{'Males'});
   MaxTab(6,0,genderLong[1]{'Females'});
   MaxTab(7,0,'Stud.');
   MaxTab(8,0,'Times');
   MaxTab(9,0,'Alloted ');
  end;
end;

procedure TPrintTeTimesWin.PrintOffset(b:smallint; tab:integer);
var
 aStr: string;
 Inset:         integer;
begin
 Inset:=PrintCanvas.textwidth('999');
 astr:=inttostr(b);
 x:=tab+Inset-PrintCanvas.textwidth(aStr); printw(astr);
end;


procedure TPrintTeTimesWin.printteachtimes(yeary: smallint;var count1: integer);
var
 j,a:   integer;
 aStr:          string;
 mycount,YearUse: integer;
begin
 if winView[wnTeTimes]=1 then
 begin
  for j:=1 to numcodes[0] do
  begin
   a:=TeDoSub[j];
   if a>0 then
   begin
    fcolor(cpSub); x:=PrntTabs[1]; printwl(SubCode[j]);
    fcolor(cpClass); x:=PrntTabs[2]; printwl(yearname[yeary]);
    x:=PrntTabs[3];
    if classInYear[yeary] then printwl(ClassCode[ClassShown[myLev1,yeary]]);
    fcolor(cpNormal);

    YearUse:=yeary;if XML_DISPLAY.MatchAllYears then YearUse:=-1;
    if SuMale[j,YearUse]>0 then PrintOffset(SuMale[j,YearUse],PrntTabs[4]);
    if SuFemale[j,YearUse]>0 then PrintOffset(SuFemale[j,YearUse],PrntTabs[5]);
     mycount:=SuMale[j,YearUse]+SuFemale[j,YearUse];
    if mycount>0 then PrintOffset(mycount,PrntTabs[6]);
    PrintOffset(a,PrntTabs[7]);
    str(TeAllot[j]:6:2,aStr);
    x:=PrntTabs[9]-PrintCanvas.textwidth(aStr);
    printwl(aStr);
    fcolor(cpBlockClash);
    if TeShare[j]=-1 then printwl(' shared');
    fcolor(cpNormal);
    newline;
   end; {if a>0}
  end; {for j}
 end
 else
  begin
   for j:=1 to numcodes[0] do
   begin
    a:=TeDoSub[j];
    if a>0 then
    begin
     fcolor(cpClass);
     if (((count1 mod lcnt)=0) and (count1<>0)) then
      begin
       count1:=0;
       newline;
      end;
     if winView[wnTeTimes]<2 then
     begin
      x:=PrntTabs[1]+count1*PrntTabs[4];
      printwl(yearshort+' '+yearname[yeary]+' ');
     end
     else
      x:=PrntTabs[1]+count1*PrntTabs[5];
     aStr:=trim(ClassCode[ClassShown[myLev1,yeary]]);
     if (classInYear[yeary] and (aStr>'')) then printwl(aStr+' ');
     fcolor(cpSub);
     printwl(SubCode[j]);
     fcolor(cpNormal);
     printwl(' '+inttostr(a)+'   '); inc(count1);
    end; {if a>0}
   end; {for j}
 end;
end;


procedure TeacherTimesPrint;
var
 lcnt:    integer;
 found:   bool;
 m,ystart,yend:     integer;
 ldt:               double;
 i,k,v:             integer;
 yeary,l:           integer;
 shared:            integer;
 count1:            integer;
 tmpStr:            string;
 num:               integer;
begin
 PrintTeTimesWin:=TPrintTeTimesWin.create;
 with PrintTeTimesWin do
  try
   PrintHead;
   lcnt:=3;
   m:=0; ystart:=0; yend:=years_minus_1;
   if winView[wnTeTimes]=2 then
    begin
     if XML_DISPLAY.teachertimesyear=years then
      begin
       ystart:=0; yend:=years_minus_1;
      end
      else
       begin
        ystart:=XML_DISPLAY.teachertimesyear; yend:=XML_DISPLAY.teachertimesyear;
       end;
    end;

   num:=pfree[0];
   if num>0 then
   for k:=1 to num do
   begin
    i:=pfree[k];
    if i=0 then continue;
    begin
     TeDoSub[0]:=0;
     inc(m);  fcolor(cpTeach);
     printwl(XML_TEACHERS.tecode[i,0]+'  ');
     x:=PrntTabs[0]; printwl(XML_TEACHERS.TeName[i,0]);
     x:=PrntTabs[1]; fcolor(cpNormal);
     count1:=0;
     for yeary:=ystart to yend do
     begin
      if classInYear[yeary] then
      begin
       for l:=1 to level[yeary] do
       begin
        myLev1:=l;
        ClearTeDoSub;
        tcount(yeary,i,l);
        printteachtimes(yeary,count1);
       end; {for l}
      end
      else {not classInYear[yeary]}
       begin
        ClearTeDoSub;
        for l:=1 to level[yeary] do tcount(yeary,i,l);
        printteachtimes(yeary,count1);
       end;
     end; {for yeary}
     if winView[wnTeTimes]=2 then newline;
     if winView[wnTeTimes]<2 then
     begin
      found:=false;
      for v:=0 to 2 do
       if trim(XML_TEACHERS.DutyCode[i,v])>'' then found:=true;
      ldt:=0; {double}
      if (found) then
      begin
       if winView[wnTeTimes]=0 then
       begin
        for v:=0 to 2 do
        begin
         if (trim(XML_TEACHERS.DutyCode[i,v])<>'') then
         begin
          if (((count1 mod lcnt)=0) and (count1<>0)) then
           begin
            count1:=0;  newline;
           end;
          x:=PrntTabs[1]+count1*PrntTabs[4];
          printwl('Duty'+chr(49+v)+': '+XML_TEACHERS.DutyCode[i,v]);
          str(XML_TEACHERS.DutyLoad[i,v]:6:2,tmpStr);
          printwl(tmpstr+'    ');
          ldt:=ldt+XML_TEACHERS.DutyLoad[i,v];
          inc(count1);
         end;
        end;
       end
       else   {not winView[wnTeTimes]=0}
        if winView[wnTeTimes]=1 then {not for=2}
        begin
         for v:=0 to 2 do
         begin
          if trim(XML_TEACHERS.DutyCode[i,v])<>'' then
          begin
           x:=PrntTabs[1];
           printwl('Duty'+chr(49+v)+': '+XML_TEACHERS.DutyCode[i,v]);
           str(XML_TEACHERS.DutyLoad[i,v]:6:2,tmpStr);
           x:=PrntTabs[9]-PrintCanvas.textwidth(tmpstr);
           printwl(tmpstr);
           ldt:=ldt+XML_TEACHERS.DutyLoad[i,v];
           newline;
          end;
         end;
        end;
      end; {if found}
      shared:=TeDoSub[0]-Teaching[i];
      if winView[wnTeTimes]=0 then
      begin
       if count1<>0 then newline;
       x:=PrntTabs[1];
       printwl('Total time slots '+inttostr(Teaching[i])+'  Load: ');
       str((TeLoad[i]+ldt):6:2,tmpstr);
       printwl(tmpstr+'/'+inttostr(XML_TEACHERS.Load[i]));
       if shared>1 then tmpstr:='classes' else tmpstr:='class';
       if shared>0 then
        begin
         fcolor(cpBlockClash);
         printw('  '+inttostr(shared)+' shared '+tmpstr);
         fcolor(cpNormal);
        end;
       newline;
      end
      else
       begin
        if shared>1 then tmpstr:='classes' else tmpstr:='class';
        if shared>0 then
          printw(inttostr(shared)+' shared '+tmpstr);
        x:=PrntTabs[5]-prntblankwidth*3;
        printwl('Totals ');
        PrintOffset(Teaching[i],PrntTabs[7]);
        str((TeLoad[i]+ldt):6:2,tmpstr);
        x:=PrntTabs[9]-PrintCanvas.textwidth(tmpstr);
        printwl(tmpstr);
        printw('/'+inttostr(XML_TEACHERS.Load[i]));
        newline;
       end;
      newline;

     end;
    end; {end next block for k}

  {ensure room enough for next teacher}

    if (y+((TeLine[k+1]-TeLine[k])*PrnttxtHeight))>
            (PrintPageHeight-2*prntTxtHeight) then
     begin  startnewPage; PrintHead; end
   end; {for k}
   printw('Teachers: '+inttostr(m));
   newline;
   printCustomAddon;
  finally
   PrintTeTimesWin.Free;
  end;
end;



procedure TTeacherTimes.FormDblClick(Sender: TObject);
begin
 selection2click(self);
end;

procedure TOutTeTimesWin.head;
begin
 printw('Teacher Loads');
 if XML_DISPLAY.teachertimesfac>0 then printw(' - '+facname[XML_DISPLAY.teachertimesfac]);
 newline; newline;
 case winView[wnTeTimes] of
  0: printLine(['Summary']);
  1: PrintLine(['Code','Name','Subject',yeartitle,'Class',genderLong[0]{'Males'},genderLong[1]{'Females'},'Stud.',
        'Times',TslotUnitName[TslotUnit]]);
  2: if XML_DISPLAY.teachertimesyear=years then
       printLine(['Teachers in All '+yeartitle+'s '])
      else
       printLine([yeartitle+' '+yearname[XML_DISPLAY.teachertimesyear]+' Teachers']);
 end; {case}
 newline;
end;

procedure TOutTeTimesWin.printteachtimes(yeary,i: smallint;var count1: integer);
var
 j,a:   integer;
 aStr:          string;
 mycount,YearUse: integer;
begin
 if winView[wnTeTimes]=1 then
 begin
  for j:=1 to numcodes[0] do
  begin
   a:=TeDoSub[j];
   if a>0 then
   begin
    if not(FirstOneflg) then
     begin
      if OberonShow then
       begin
        printw(XML_TEACHERS.tecode[i,0]);
        printc(XML_TEACHERS.TeName[i,0]);
       end
      else printc('');
     end;
    FirstOneflg:=false;
    printc(SubCode[j]);
    printc(yearname[yeary]);
    aStr:=''; if classInYear[yeary] then  aStr:=ClassCode[ClassShown[myLev1,yeary]];
    printc(aStr);

    YearUse:=yeary;if XML_DISPLAY.MatchAllYears then YearUse:=-1;
    aStr:=''; if SuMale[j,YearUse]>0 then aStr:=inttostr(SuMale[j,YearUse]);
    printc(aStr);
    aStr:=''; if SuFemale[j,YearUse]>0 then aStr:=inttostr(SuFemale[j,YearUse]);
    printc(aStr);
    mycount:=SuMale[j,YearUse]+SuFemale[j,YearUse];
    printc(inttostr(mycount));
    printc(inttostr(a));
    str(TeAllot[j]:6:2,aStr);
    printc(aStr);
     aStr:=''; if TeShare[j]=-1 then aStr:=' shared';
    printc(aStr);
    newline;
   end; {if a>0}
  end; {for j}
 end
 else
  begin
   for j:=1 to numcodes[0] do
   begin
    a:=TeDoSub[j];
    if a>0 then
    begin
     if (((count1 mod lcnt)=0) and (count1<>0)) then
      begin
       count1:=0;
       newline;
      end;
     if winView[wnTeTimes]<2 then
     begin
      if not(FirstOneflg) then printc('');
      FirstOneflg:=false;
      printc(yearshort+' '+yearname[yeary]+' ');
     end
     else
     aStr:=trim(ClassCode[ClassShown[myLev1,yeary]]);
     if (classInYear[yeary] and (aStr>'')) then printc(aStr+' ') else printc('');
     printc(SubCode[j]);
     printc(' '+inttostr(a)+'   '); inc(count1);
    end; {if a>0}
   end; {for j}
 end;
end;

procedure TeacherTimestext;
var
 lcnt:    integer;
 found:   bool;
 m,ystart,yend:     integer;
 ldt:               double;
 i,k,v:             integer;
 yeary,l:           integer;
 shared:            integer;
 count1:            integer;
 tmpStr:            string;
 num:               integer;
begin
 OutTeTimesWin:=TOutTeTimesWin.create;
 with OutTeTimesWin do
  try
   Header;
   lcnt:=3;
   m:=0; ystart:=0; yend:=years_minus_1;
   if winView[wnTeTimes]=2 then
    begin
     if XML_DISPLAY.teachertimesyear=years then
       begin
        ystart:=0; yend:=years_minus_1;
       end
      else
       begin
        ystart:=XML_DISPLAY.teachertimesyear;
        yend:=XML_DISPLAY.teachertimesyear;
       end;
    end;
   num:=pfree[0];
   if num>0 then
    for k:=1 to num do
     begin
      i:=pfree[k];
      if i=0 then continue;
      TeDoSub[0]:=0;      FirstOneflg:=true;
      inc(m);
      printw(XML_TEACHERS.tecode[i,0]);
      printc(XML_TEACHERS.TeName[i,0]);
      count1:=0;
      for yeary:=ystart to yend do
       begin
         if classInYear[yeary] then
          begin
           for l:=1 to level[yeary] do
            begin
             myLev1:=l;
             ClearTeDoSub;
             tcount(yeary,i,l);
             printteachtimes(yeary,i,count1);
            end; {for l}
          end
         else {not classInYear[yeary]}
          begin
           ClearTeDoSub;
           for l:=1 to level[yeary] do tcount(yeary,i,l);
           printteachtimes(yeary,i,count1);
          end;
       end; {for yeary}
      if winView[wnTeTimes]=2 then newline;
      if winView[wnTeTimes]<2 then
       begin
        found:=false;
        for v:=0 to 2 do
         if trim(XML_TEACHERS.DutyCode[i,v])>'' then found:=true;
        ldt:=0; {double}
        if (found) then
         begin
          if winView[wnTeTimes]=0 then
           begin
            for v:=0 to 2 do
             begin
              if (trim(XML_TEACHERS.DutyCode[i,v])<>'') then
               begin
                printc('Duty'+chr(49+v)+': '+XML_TEACHERS.DutyCode[i,v]);
                str(XML_TEACHERS.DutyLoad[i,v]:6:2,tmpStr);
                printc(tmpstr);
                ldt:=ldt+XML_TEACHERS.DutyLoad[i,v];
                inc(count1);
                if (((count1 mod lcnt)=0) and (count1<>0)) then
                 begin
                  count1:=0;  newline;
                 end
                else printc('');
               end;
             end;
           end
          else   {not winView[wnTeTimes]=0}
           if winView[wnTeTimes]=1 then {not for=2}
            for v:=0 to 2 do
             if trim(XML_TEACHERS.DutyCode[i,v])<>'' then
              begin
               str(XML_TEACHERS.DutyLoad[i,v]:6:2,tmpStr);
               PrintLine(['','','Duty'+chr(49+v)+': '+XML_TEACHERS.DutyCode[i,v],'','','','','','',tmpstr]);
               ldt:=ldt+XML_TEACHERS.DutyLoad[i,v];
              end;
         end; {if found}
      shared:=TeDoSub[0]-Teaching[i];
      if winView[wnTeTimes]=0 then
      begin
       if count1<>0 then newline;
       printc('');
       printc('Total time slots '+inttostr(Teaching[i])+'  Load: ');
       str((TeLoad[i]+ldt):6:2,tmpstr);
       printc(tmpstr+'/'+inttostr(XML_TEACHERS.Load[i]));
       if shared>1 then tmpstr:='classes' else tmpstr:='class';
       if shared>0 then
         printc('  '+inttostr(shared)+' shared '+tmpstr);
       newline;
      end
      else
       begin
         if OberonShow then
         begin
           printw(XML_TEACHERS.TeCode[i,0]);
           printc(XML_TEACHERS.TeName[i,0]);
         end;
        if shared>1 then tmpstr:='classes' else tmpstr:='class';
        if shared>0 then
          printc(inttostr(shared)+' shared '+tmpstr)
        else
          printc('');
        printc(''); printc(''); printc(''); printc(''); printc('');
        printw('Totals '); printc('');
        printc(inttostr(Teaching[i]));
        str((TeLoad[i]+ldt):6:2,tmpstr);
        printc(tmpstr);
        printc('/'+inttostr(XML_TEACHERS.Load[i]));
        newline;
       end;
      newline;
     end; {end next block for k}
    end; {for k}
   printw('Teachers: '+inttostr(m));
   newline;
   printCustomAddon;
  finally
   OutTeTimesWin.Free;
  end;
end;



end.
