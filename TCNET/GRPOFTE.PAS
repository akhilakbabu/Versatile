unit Grpofte;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Menus, TimeChartGlobals,ClassDefs,GlobalToTcAndTcextra,
  XML.DISPLAY,XML.TEACHERS;

type
  TGroupofTeachers = class(TDrawWin)
    PopupMenu1: TPopupMenu;
    Selection2: TMenuItem;
    N2: TMenuItem;
    PrintSetup1: TMenuItem;
    Print1: TMenuItem;
    Exportastextfile1: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure Selection2Click(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
  protected
    procedure SetTabs; override;
  end;

var
  GroupofTeachers: TGroupofTeachers;

procedure groupofteachersprint;
procedure groupofteacherstext;


implementation
uses tcommon,main,grptedlg,printers,tcommon2;
{$R *.DFM}

 type TPrintGroupOfTeWin=class(TPrintDrawWin)
  public
   procedure head; override;
   procedure SetTabs; override;
  private
   procedure GoTshow;
   procedure showteachertime;
 end;

 type TOutGroupOfTeWin=class(TOutputwin)
  public
   procedure head; override;
  private
   procedure GoTshow;
   procedure showteachertime;
 end;

var
 PrintGroupOfTeWin: TPrintGroupOfTeWin;
 OutGroupOfTeWin: TOutGroupOfTeWin;
 tefree:           tpTeData;
 tefound:          tpTeData;
 freecheck:        tpTeData;
 num,linecount:    integer;
 GoThead:          string;

procedure TGroupofTeachers.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 action:=caFree;
end;

procedure TGroupofTeachers.FormCreate(Sender: TObject);
begin
 setWindowDefaults(self,wnGroupTe);
 fillchar(tefree,sizeof(tefree),chr(0));
 fillchar(tefound,sizeof(tefound),chr(0));
 fillchar(freecheck,sizeof(freecheck),chr(0));
end;

procedure CountTefound;
var
 i:        integer;
begin
 num:=0;
 for i:=1 to codeCount[1] do
  if bool(tefound[codepoint[i,1]]) then
  begin
   inc(num); tefree[num]:=codepoint[i,1];
  end;
end;

procedure GoTclassCalc;
var
 L1,L2:   integer;
 su,te:  integer;
 d,p,L: integer;
 afnt: tpintpoint;
 tmpstr:    string;
begin
 fillchar(tefound,sizeof(tefound),chr(0));
 fillchar(tefree,sizeof(tefree),chr(0));
 if XML_DISPLAY.grpofteyear<0 then
    XML_DISPLAY.grpofteyear:=0;
 if XML_DISPLAY.grpofteclass>level[XML_DISPLAY.grpofteyear] then
      XML_DISPLAY.grpofteclass:=0;

 if XML_DISPLAY.grpofteclass<=0 then {all}
  begin
   L1:=1; L2:=level[XML_DISPLAY.grpofteyear];
   tmpstr:='all classes';
  end
 else
  begin
    L1:=XML_DISPLAY.grpofteclass;
    L2:=XML_DISPLAY.grpofteclass;
    if trim(ClassCode[ClassShown[XML_DISPLAY.grpofteclass,XML_DISPLAY.grpofteyear]])<>'' then
      tmpstr:=ClassCode[ClassShown[XML_DISPLAY.grpofteclass,XML_DISPLAY.grpofteyear]]
     else
      tmpstr:='Level '+inttostr(XML_DISPLAY.grpofteclass);
  end;
 GoThead:='Teachers in '+yeartitle+' '+yearname[XML_DISPLAY.grpofteyear]+' '+tmpstr;
  for d:=0 to days-1 do
   for p:=1 to tlimit[d] do
   begin
    fillchar(freecheck,sizeof(freecheck),chr(0));
    for L:=L1 to L2 do
    begin
     aFnt:=FNT(d,p-1,XML_DISPLAY.grpofteyear,L,0);
     su:=aFnt^; inc(aFnt); te:=aFnt^;
     IF ((freecheck[te]=0) AND (su>0) AND (su<=LabelBase) AND (su<>subNA)) THEN
     begin
      inc(tefound[te]); freecheck[te]:=1;
     end;
    end; {for L}
   end; {for p}
 CountTefound; linecount:=num;
end;

procedure GoTsubCalc;
var
 yy,y1,y2,L,subI:       integer;
 d,p:                    integer;
 su,te:             integer;
 afnt,bfnt:       tpintpoint;
 tmpstr:  string;
begin
 if XML_DISPLAY.grpofteyear=0 then {all}
  begin
   tmpstr:='All '+yeartitle+'s';
   y1:=0; y2:=years_minus_1;
  end
 else
  begin
   tmpstr:=yeartitle+' '+yearname[XML_DISPLAY.grpofteyear-1];
   y1:=XML_DISPLAY.grpofteyear-1; y2:=XML_DISPLAY.grpofteyear-1;
  end;
 GoThead:='Teachers in '+tmpstr;
 fillchar(tefound,sizeof(tefound),chr(0));
 fillchar(tefree,sizeof(tefree),chr(0));
 for subI:=1 to XML_DISPLAY.GrpOfTeSelSubg[0] do
  begin
   for d:=0 to days-1 do
    for p:=1 to tlimit[d] do
    begin
     fillchar(freecheck,sizeof(freecheck),chr(0));
     for yy:=y1 to y2 do
     begin
      afnt:=FNT(d,p-1,yy,0,0);
      for L:=1 to level[yy] do
      begin
       inc(afnt,4);
       su:=afnt^; bfnt:=afnt; inc(bfnt); te:=bfnt^;
       if ((su>0) and (su<=numcodes[0]) and (su<>subNA) and (freecheck[te]=0)) then
        if (su=XML_DISPLAY.GrpOfTeSelSubg[subI]) then
        begin
         inc(tefound[te]); freecheck[te]:=1;
        end;
      end; {for L}
     end; {for yy}
    end; {for p}
   end; {for subI}
  CountTefound; linecount:=num+4;
end;


procedure GoTfacCalc;
var
 i,su,te:     integer;
 y1,y2,yy,L,d,p:   integer;
 tmpstr:  string;
 afnt,bfnt:      tpintpoint;
begin
 fillchar(tefound,sizeof(tefound),chr(0));
 fillchar(tefree,sizeof(tefree),chr(0));

 if XML_DISPLAY.grpofteyear=0 then
 begin
  tmpstr:='All '+yeartitle+'s'; y1:=0; y2:=years_minus_1;
 end
 else
  begin
   tmpstr:=yeartitle+' ' +yearname[XML_DISPLAY.grpofteyear-1];
   y1:=XML_DISPLAY.grpofteyear-1; y2:=XML_DISPLAY.grpofteyear-1;
  end;
 GoThead:='Teachers in '+tmpstr;
 if XML_DISPLAY.grpoftefac=0 then GoThead:=GoThead+' '+'All faculties'
  else if (XML_DISPLAY.grpoftefac>0) then GoThead:=GoThead+' '+facname[XML_DISPLAY.grpoftefac];

 for d:=0 to days-1 do
  for p:=1 to tlimit[d] do
  begin
   fillchar(freecheck,sizeof(freecheck),chr(0));
   for yy:=y1 to y2 do
   begin
    aFnt:=FNT(d,p-1,yy,0,0);
    for L:=1 to level[yy] do
    begin
     inc(aFnt,4);
     su:=aFnt^; bFnt:=aFnt; inc(bFnt); te:=bFnt^;
     if (su>0) and (su<=LabelBase) and (su<>subNA) and (freecheck[te]=0) then
     begin
      inc(tefound[te]); freecheck[te]:=1;
     end;
    end; {for L}
   end; {for yy}
  end; {for p}

 for i:=1 to numcodes[1] do
  if not(TeachInAnyFac(i,XML_DISPLAY.grpoftefac)) then tefound[i]:=0;
 CountTefound;  linecount:=num;
end;

procedure checktimes(d:integer);
var
 su,te,p,yy,L,i:           integer;
 afnt,bfnt:                tpintpoint;
begin
 fillchar(tefound,sizeof(tefound),chr(0));
 fillchar(tefree,sizeof(tefree),chr(0));
 for p:=1 to tlimit[d] do
  begin
   fillchar(freecheck,sizeof(freecheck),chr(0));
   for yy:=0 to years_minus_1 do
   begin
    afnt:=FNT(d,p-1,yy,0,0);
    for L:=1 to level[yy] do
    begin
     inc(aFnt,4);
     su:=aFnt^; bFnt:=aFnt; inc(bFnt); te:=bFnt^;
     if ((su>0) and (su<=LabelBase) and (su<>subNA) and (freecheck[te]=0)) then
     begin
      freecheck[te]:=1; inc(tefound[te]);
     end;
    end; {for L}
   end; {for yy}
  end; {for p}
 num:=0;
 for i:=1 to codeCount[1] do
  if (tefound[codepoint[i,1]]>=XML_DISPLAY.grpoftetimes) then
  begin
   inc(num); tefree[num]:=codepoint[i,1];
  end;
end;

procedure GoTtimeCalc;
var
 d,d1,d2:       integer;
begin
 if XML_DISPLAY.grpofteday=0 then
 begin
  d1:=0; d2:=days-1;
 end
 else
  begin
   d1:=XML_DISPLAY.grpofteday-1; d2:=XML_DISPLAY.grpofteday-1;
  end;
 linecount:=0;
 GoThead:='Teachers in  with '+inttostr(XML_DISPLAY.grpoftetimes)+' or more times';
 for d:=d1 to d2 do
 begin
  checktimes(d);
  inc(linecount,num+3);
 end; {for d}
end;

procedure TGroupofTeachers.SetTabs;
var
 scrolltemp2: integer;
begin
 SetLength(Tabs,4);
 Tabs[1]:=fwcode[1]+blankwidth;
 Tabs[2]:=fwcode[1]+fwcodename[1]+blankwidth*2;
 Tabs[3] := Tabs[2] + blankwidth * 3;
  case winView[wnGroupTe] of
  0: GoTclassCalc;
  1: GoTsubCalc;
  2: GoTfacCalc;
  3: GoTtimeCalc;
 end; {case}
 MaxH:=(linecount+8)*txtheight;
 MaxW:=Tabs[2]+canvas.textwidth('9999')+hmargin*2;
 scrolltemp2:= canvas.textwidth(GoThead)+hmargin*2;
 if winView[wnGroupTe]=3 then inc(scrolltemp2,fwDay);
 if scrolltemp2>MaxW then MaxW:=scrolltemp2;
end;

procedure TGroupofTeachers.FormPaint(Sender: TObject);
    procedure GoTshow;
    var
     i,sublinecount: integer;
     lTempList: TStringList;
     j: Integer;
     //lCount: Integer;
    begin
     sublinecount:=0;
     if num=0 then
     begin
      printw('No teachers in selected group');
      exit;
     end;
     printw(GoThead); newline;
     if winView[wnGroupTe]=1 then
      begin
       if (XML_DISPLAY.GrpOfTeSelSubg[0]=codeCount[0]) then
           printwl('All subjects')
         else
           begin
             PrintWl('Group subjects:');
             NewLine;
             for i:=1 to XML_DISPLAY.GrpOfTeSelSubg[0] do
              begin
               printw(SubCode[XML_DISPLAY.GrpOfTeSelSubg[i]]+' ');
               inc(x,fwcode[0]+blankwidth);
               if (x>(8*(fwcode[0]+blankwidth))) then
               begin
                newline;
                inc(sublinecount);
                if sublinecount>4 then break;
               end;
              end; {for i}
           end;
         if x>0 then newline;
      end;

     for i:=1 to num do
     begin
      fColor(cpTeach);
      printwl(XML_TEACHERS.tecode[tefree[i],0]);
      x:=Tabs[1];
      printwl(XML_TEACHERS.TeName[tefree[i],0]);
      x:=Tabs[2];
      fColor(cpNormal);
      printwl(inttostr(tefound[tefree[i]]));
      case winView[wnGroupTe] of
        1:  //Subject selection
        begin
          x := Tabs[3];
          fColor(cpSub);
          lTempList := GetTeacherSubjects(tefree[i]);
          //lCount := 0;
          for j := 0 to lTempList.Count - 1 do
          begin
            {if lCount >= 10  then
            begin
              NewLine;
              lCount := 0;
              x := Tabs[3];
            end;}
            PrintW(lTempList.Strings[j]);
            x := x + Self.Canvas.TextWidth(lTempList.Strings[j] + '  ');
            //Inc(lCount);
          end;
          FreeAndNil(lTempList);
        end;
      end;
      NewLine;
      if y>bottomCutoff then break;
     end; {for i}
     fColor(cpNormal);
     printw('Teachers: '+inttostr(num));
    end;


    procedure showteachertime;
    var
     d,d1,d2,i:       integer;
     tmpstr:  string;
    begin
     if XML_DISPLAY.grpofteday=0 then
     begin
      d1:=0; d2:=days-1;
     end
     else
      begin
       d1:=XML_DISPLAY.grpofteday-1; d2:=XML_DISPLAY.grpofteday-1;
      end;
     for d:=d1 to d2 do
     begin
      checktimes(d);
      tmpstr:='Teachers in '+dayname[d]+' with '+inttostr(XML_DISPLAY.grpoftetimes)+' or more times';
      printw(tmpstr);     newline;
      if num=0 then
      begin
       printw('No teachers');
       newline;
       newline;
      end
      else
       begin
        for i:=1 to num do
        begin
         fcolor(cpTeach);
         printw(XML_TEACHERS.tecode[tefree[i],0]);
         x:=fwcode[1]+blankwidth;
         printw(XML_TEACHERS.TeName[tefree[i],0]);
         x:=fwcode[1]+fwcodename[1]+blankwidth*2;
         fcolor(cpNormal);
         printw(inttostr(tefound[tefree[i]]));
         newline;
        end; {for i}
        printw('Teachers: '+inttostr(num));
        newline;newline;
       end;
     end; {for d}
    end;
begin
 fcolor(cpNormal);
 if winView[wnGroupTe]<>3 then GoTshow else showteachertime;
end;

procedure TGroupofTeachers.Selection2Click(Sender: TObject);
begin
 groupofteachersdlg:=Tgroupofteachersdlg.create(self);   {allocate dlg}
 groupofteachersdlg.showmodal;
 groupofteachersdlg.free;
end;

{------------------------- printing procs follow ---------------------------------}

procedure TPrintGroupOfTeWin.head;
begin
 UnderlineOn;
 printwl('Group of Teachers');
 printw(PageCount);
 UnderlineOff;
 x:=0; y:=y+PrnttxtHeight;
end;

procedure TPrintGroupOfTeWin.SetTabs;
begin
 SetLength(PrntTabs, 4);
 PrntTabs[1]:=fwprntcode[1]+prntblankwidth;
 PrntTabs[2]:=fwprntcode[1]+fwprntcodename[1]+prntblankwidth*2;
 PrntTabs[3] := PrntTabs[2] + PrntBlankWidth * 3;
end;

procedure TPrintGroupOfTeWin.GoTshow;
var
  i: Integer;
  tei,tej: smallint;
  lTempList: TStringList;
  j: Integer;
  lCount: Integer;
begin
 if num=0 then
 begin
  printw('No teachers in selected group');
  exit;
 end;
 printw(GoThead); newline;
 if winView[wnGroupTe]=1 then
  begin
   tej:=PrintPagewidth-prnthmargin-fwyearname;
   tej:=tej-PrintCanvas.textwidth('Teachers in year ');
   tej:=tej div fwprntcode[0];
   tei:=0;
   if (XML_DISPLAY.GrpOfTeSelSubg[0]=codeCount[0]) then
       printwl('All subjects')
     else
      begin
       for i:=1 to XML_DISPLAY.GrpOfTeSelSubg[0] do
       begin
        printwl(' '+SubCode[XML_DISPLAY.GrpOfTeSelSubg[i]]);
        inc(tei);
        if tei>=tej then
        begin
         newline;  tei:=0;
        end;
       end;
      end;
   if x>0 then newline;
  end;

 for i:=1 to num do
 begin
  printwl(XML_TEACHERS.tecode[tefree[i],0]);
  x:=PrntTabs[1];
  printwl(XML_TEACHERS.TeName[tefree[i],0]);
  x:=PrntTabs[2];
  printwl(inttostr(tefound[tefree[i]]));

  case winView[wnGroupTe] of
    1:  //Subject selection
    begin
      x := PrntTabs[3];
      lTempList := GetTeacherSubjects(tefree[i]);
      lCount := 0;
      for j := 0 to lTempList.Count - 1 do
      begin
        if lCount >= 10  then
        begin
          NewLine;
          lCount := 0;
          x := PrntTabs[3];
        end;
        PrintW(lTempList.Strings[j]);
        Inc(lCount);
        x := PrntTabs[3] + lCount *(fwPrntCode[0] + PrntBlankWidth);
      end;
      FreeAndNil(lTempList);
    end;
  end;
  NewLine;
 end; {for i}
 printw('Teachers: '+inttostr(num));
end;

procedure TPrintGroupOfTeWin.showteachertime;
var
 d,d1,d2,i:       integer;
 tmpstr:  string;
begin
 if XML_DISPLAY.grpofteday=0 then
 begin
  d1:=0; d2:=days-1;
 end
 else
  begin
   d1:=XML_DISPLAY.grpofteday-1; d2:=XML_DISPLAY.grpofteday-1;
  end;
 for d:=d1 to d2 do
 begin
  checktimes(d);
  tmpstr:='Teachers in '+dayname[d]+' with '+inttostr(XML_DISPLAY.grpoftetimes)+' or more times';
  printw(tmpstr);     newline;
  if num=0 then
  begin
   printw('No teachers');
   newline;
   newline;
  end
  else
  begin
    for i:=1 to num do
    begin
      printw(XML_TEACHERS.tecode[tefree[i],0]);
      x:=fwprntcode[1]+prntblankwidth;
      printw(XML_TEACHERS.TeName[tefree[i],0]);
      x:=fwprntcode[1]+fwprntcodename[1]+prntblankwidth*2;
      printw(inttostr(tefound[tefree[i]]));
      NewLine;
    end; {for i}
    printw('Teachers: '+inttostr(num));
    newline;newline;
   end;
 end; {for d}
end;

procedure groupofteachersprint;
begin
 PrintGroupOfTeWin:=TPrintGroupOfTeWin.create;
 with PrintGroupOfTeWin do
  try
   PrintHead;
   fcolor(cpnormal);
   if winView[wnGroupTe]<>3 then GoTshow else showteachertime;
   newline;
   printCustomAddon;
  finally
   PrintGroupOfTeWin.Free;
  end;
end;

procedure TGroupofTeachers.FormDblClick(Sender: TObject);
begin
 groupofteachersdlg:=Tgroupofteachersdlg.create(self);   {allocate dlg}
 groupofteachersdlg.showmodal;
 groupofteachersdlg.free;
end;

procedure TOutGroupOfTeWin.head;
begin
 printLine(['Group of Teachers']);
end;

procedure TOutGroupOfTeWin.GoTshow;
var
  i: integer;
  lTempList: TStringList;
  j: Integer;
begin
 if num=0 then
 begin
  printw('No teachers in selected group');
  exit;
 end;

 printc(GoThead);     newline;
 for i:=1 to num do
 begin
  printc(XML_TEACHERS.tecode[tefree[i],0]);
  printc(XML_TEACHERS.TeName[tefree[i],0]);
  printc(inttostr(tefound[tefree[i]]));
  case winView[wnGroupTe] of
    1:  //Subject selection
    begin
      lTempList := GetTeacherSubjects(tefree[i]);
      for j := 0 to lTempList.Count - 1 do
      begin
        PrintC(lTempList.Strings[j]);
      end;
      FreeAndNil(lTempList);
    end;
  end;
  NewLine;
 end; {for i}
 printc('Teachers: '); printc(inttostr(num));
end;

procedure TOutGroupOfTeWin.showteachertime;
var
 d,d1,d2,i:       integer;
 tmpstr:  string;

begin
 if XML_DISPLAY.grpofteday=0 then
 begin
  d1:=0; d2:=days-1;
 end
 else
  begin
   d1:=XML_DISPLAY.grpofteday-1; d2:=XML_DISPLAY.grpofteday-1;
  end;
 for d:=d1 to d2 do
 begin
  checktimes(d);
  tmpstr:='Teachers in '+dayname[d]+' with '+inttostr(XML_DISPLAY.grpoftetimes)+' or more times';
  printc(tmpstr);     newline;
  if num=0 then
  begin
   printc('No teachers');
   newline;
   newline;
  end
  else
   begin
    for i:=1 to num do
    begin
     printc(XML_TEACHERS.tecode[tefree[i],0]);
     printc(XML_TEACHERS.TeName[tefree[i],0]);
     printc(inttostr(tefound[tefree[i]]));
     newline;
    end; {for i}
    printc('Teachers: '); printc(inttostr(num));
    newline;newline;
   end;
 end; {for d}
end;

procedure groupofteacherstext;
begin
 OutGroupOfTeWin:=TOutGroupOfTeWin.create;
 with OutGroupOfTeWin do
  try
   Header;
   if winView[wnGroupTe]<>3 then GoTshow else showteachertime;
   printCustomAddon;
  finally
   OutGroupOfTeWin.Free;
  end;
end;

end.


