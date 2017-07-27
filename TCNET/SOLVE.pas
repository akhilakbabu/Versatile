unit Solve;

interface

uses SysUtils, WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, Dialogs, TimeChartGlobals,GlobalToTcAndTcextra, XML.DISPLAY, XML.TEACHERS;
  
type
  TSolveDlg = class(TForm)
    HelpBtn: TBitBtn;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Edit2: TEdit;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    SolveScope: TRadioGroup;
    Finish: TBitBtn;
    FindBtn: TBitBtn;
    NextBtn: TBitBtn;
    SolveBtn: TBitBtn;
    Panel1: TPanel;
    Image1: TImage;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    ComboBox5: TComboBox;
    ComboBox3: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure SolveScopeClick(Sender: TObject);
    procedure FindBtnClick(Sender: TObject);
    procedure NextBtnClick(Sender: TObject);
    procedure SolveBtnClick(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure ComboBox5Change(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure ComboBox3Enter(Sender: TObject);
  private
    procedure restore;
    procedure ShowSolution;
  end;

var
  SolveDlg: TSolveDlg;

implementation

{$R *.DFM}

uses tcommon,TTundo,DlgCommon,ttable,tcommon2;

var
 bd, bp, by, bl, Ebox:  integer;
 firstStart,DoingSearch,ExitSearch: bool;
 Nblock,l1,l2:  integer;
 myTarget: integer;
 tegroup, sugroup, rogroup, tesolve, roSolve:  tplevelsub;
 entry,flag,todo,socheck:            tpFclash;
 Ntegroup,Nsugroup,Nrogroup,Ntesolve, Nrosolve:  integer;
 Solution,sLevel,sGnum,nextD,nextP,sublevel:       integer;
 Scm:   array[0..25000] of byte;
 SmoveD,SmoveP:  array[0..10] of integer;
 SolveRect:   TRect;

procedure TSolveDlg.restore;
var
 IntPoint:      tpIntPoint;
 s:             string;
 l,i:             integer;
 su,te,ro:      integer;
begin
 Ntegroup:=0; Nsugroup:=0; Nrogroup:=0;
 DoingSearch:=false; ExitSearch:=false;
 l1:=0; l2:=0; Nblock:=0;
 if ((bl>0) and (bl<=level[by]) and (bp>=0) and (bp<=Tlimit[bd])) or (XML_DISPLAY.chScope=3) then
  begin      { ^- check on valid position}
   Case Ebox of
    0: begin  {cell}
        l1:=bl; l2:=bl;
       end;
    1: GetBlockLevels(bd,bp,by,bl,l1,l2);  {block}
    2: begin              {yr/time}
        l1:=1; l2:=level[by];
       end;
   end;
   if (l1>0) then
    for l:=l1 to l2 do
     begin
      Intpoint:=FNT(bd,bp,by,l,0);
      su:=Intpoint^;
      if (su>0) and (su<=LabelBase) then
       begin
        inc(Nsugroup); Sugroup[Nsugroup]:=su;
       end;
      inc(Intpoint); te:=Intpoint^;
      if (te>0) then
       begin
        inc(Ntegroup); Tegroup[Ntegroup]:=te;
       end;
      inc(Intpoint); ro:=Intpoint^;
      if (ro>0) then
       begin
        inc(Nrogroup); Rogroup[Nrogroup]:=ro;
       end;
      i:=FNgetBlockNumber(bd,bp,by,l);
      if Nblock=0 then Nblock:=i;
     end;
  end; {if valid pos}
 Combobox2.text:=day[bd];
 Combobox1.text:=yearname[by];
 if (bp>=0) and (bp<Tlimit[bd]) then combobox3.ItemIndex:=bp;
 if (bl>0) and (bl<=level[by]) then edit2.text:=inttostr(bl);
 s:='';
 if (Nsugroup=0) and (Ntegroup=0) and (Nrogroup=0) then
   s:='No codes at this position';
 if Nsugroup>0 then
  begin
   for i:=1 to Nsugroup do
    s:=s+trim(subcode[Sugroup[i]])+' ';
   end
  else if (l1=0) and (l2=0) and (Ebox=1) then s:='No block number at this position';
 label5.Caption:=s; s:='';
 if Ntegroup>0 then
  for i:=1 to Ntegroup do
    s:=s+trim(XML_TEACHERS.tecode[Tegroup[i],0])+' ';
 label6.Caption:=s;
 if (bl<1) or (bl>level[by]) then
  begin
   label6.Caption:='Enter level in range 1-'+inttostr(level[by]);
   edit2.Setfocus; Edit2.SelectAll;
  end;
 s:='';
 if Nrogroup>0 then
  for i:=1 to Nrogroup do
    s:=s+trim(XML_TEACHERS.tecode[Rogroup[i],1])+' ';
 label7.Caption:=s;
 if (bp<0) or (bp>=Tlimit[bd]) then
  begin
   label7.Caption:='Enter time slot in range 1-'+inttostr(Tlimit[bd]);
   combobox3.Setfocus; combobox3.SelectAll;
  end;
 label10.Caption:=inttostr(Nblock);
 if (Ntegroup>0) or (Nrogroup>0) then Findbtn.Enabled:=true
   else Findbtn.Enabled:=false;
 NextBtn.Enabled:=False;
 SolveBtn.Enabled:=False;
 Image1.canvas.fillrect(SolveRect);
 Label8.Caption:='';
end;

procedure TSolveDlg.FormCreate(Sender: TObject);
begin
 firstStart:=true;
 if box=bxBlock then SolveScope.ItemIndex:=1
  else if box=bxYrTime then SolveScope.ItemIndex:=2
   else SolveScope.ItemIndex:=0;
 Ebox:=SolveScope.ItemIndex;
 label3.caption:='&'+Yeartitle;
 label5.font.color:=FontColorPair[cpSub,1];
 label6.font.color:=FontColorPair[cpTeach,1];
 label7.font.color:=FontColorPair[cpRoom,1];
 FillComboYears(false,ComboBox1);
 FillComboDays(false,ComboBox2);
 FillComboTimeSlots(false,nd,combobox3);
 FillComboTarget(ComboBox5);
 by:=ny; bl:=nl; bd:=nd; bp:=np;
 solverect.left:=0; solverect.right:=image1.width;
 solverect.top:=0; solverect.bottom:=image1.height;
 image1.canvas.brush.color:=clBtnFace;
 fillchar(Sugroup,sizeof(Sugroup),chr(0));
 fillchar(Tegroup,sizeof(Tegroup),chr(0));
 fillchar(Rogroup,sizeof(Rogroup),chr(0));
 fillchar(TeSolve,sizeof(TeSolve),chr(0));
 fillchar(roSolve,sizeof(roSolve),chr(0));
 fillchar(entry,sizeof(entry),chr(0));
 fillchar(flag,sizeof(flag),chr(0));
 fillchar(todo,sizeof(todo),chr(0));
 fillchar(socheck,sizeof(socheck),chr(0));
end;

procedure TSolveDlg.FormActivate(Sender: TObject);
begin
 firstStart:=true;
 myTarget:=by;
 comboBox5.ItemIndex:=by+1;
 Restore;
 firstStart:=false;
end;

procedure TSolveDlg.ComboBox2Change(Sender: TObject);
var
 found,oldday:  integer;
begin
 oldday:=0;
 if FirstStart then exit;
 if ChangeDayCombo(bd,Combobox2,combobox3) then ComboBox3Change(Sender);
 found:=findDay(ComboBox2.text);
 if found>=0 then bd:=found;
 if bd<>oldday then restore;
end;

procedure TSolveDlg.ComboBox1Change(Sender: TObject);
var
 found,oldyear:  integer;
begin
 if FirstStart then exit;
 oldyear:=by;
 found:=findYear(ComboBox1.text);
 if found>=0 then by:=found;
 if oldyear<>by then
  begin
   Combobox5.ItemIndex:=by+1;
   restore;
  end;
end;

procedure TSolveDlg.Edit2Change(Sender: TObject);
var
 oldlevel:  integer;
begin
 if FirstStart then exit;
 oldlevel:=bl;
 bl:=IntFromEdit(edit2);
 if (oldlevel<>bl) and (Ebox<>2) then restore;
end;

procedure TSolveDlg.SolveScopeClick(Sender: TObject);
begin
if FirstStart then exit;
 if Ebox<>SolveScope.ItemIndex then
  begin
   Ebox:=SolveScope.ItemIndex;
   Restore;
  end;
end;

function ScmPos(d5,p5,d6,p6: integer): integer;
begin
 result:=(2250*d5)+(150*p5)+(15*d6)+p6;
end;

procedure CheckDuplicates(d,p: integer);
var
 d1,p1,l,te,ro,j:           integer;
 tesolve1,rosolve1: integer;
 missing,found:       bool;
begin
 for d1:=d to days-1 do
  for p1:=0 to Tlimit[d1]-1 do
   begin
    if (d1=d) and (p1<=p) then continue;
    if entry[d1,p1]<>0 then continue;
    missing:=false; tesolve1:=0; rosolve1:=0;
    if Ntesolve>0 then
     begin
      for l:=l1 to l2 do
       begin
        te:=FNT(d1,p1,by,l,2)^;
        if te>0 then
         begin
          found:=false;
          for j:=1 to Ntesolve do
            if te=TeSolve[j] then
             begin
              found:=true;
              break;
             end;
          if found then inc(tesolve1) else missing:=true;
         end; {te>0}
        if missing then break;
       end; {l}
     end; {Ntesolve>0}
    if (not(missing)) and (Nrosolve>0) then
     begin
      for l:=l1 to l2 do
       begin
        ro:=FNT(d1,p1,by,l,4)^;
        if ro>0 then
         begin
          found:=false;
          for j:=1 to Nrosolve do
            if ro=roSolve[j] then
             begin
              found:=true;
              break;
             end;
          if found then inc(rosolve1) else missing:=true;
         end; {ro>0}
        if missing then break;
       end; {l}
     end; {Nrosolve>0}
    if (not(missing)) and (tesolve1=Ntesolve) and (Nrosolve=rosolve1)
      then entry[d1,p1]:=sGnum;
   end {p1}
end;

procedure SolveClashMatrix(d5,p5: integer);
var
 i,y,l,te,ro,d1,p1: integer;
 sGnum1,myblock:        integer;
 IntPoint:      tpIntPoint;
 found,flgdouble,flgfix:         bool;
 Sbyte:         byte;
begin
 sGnum:=entry[d5,p5];
 if sGnum>0 then
  begin
   Ntesolve:=0; Nrosolve:=0;
   for l:=l1 to l2 do
    begin
     IntPoint:=FNT(d5,p5,by,l,2); te:=IntPoint^;
     inc(IntPoint); ro:=IntPoint^;
     if (te>0) then
      begin
       inc(Ntesolve); TeSolve[Ntesolve]:=te;
      end;
     if (ro>0) then
      begin
       inc(Nrosolve); roSolve[Nrosolve]:=ro;
      end;
    end;{l}
   for d1:=0 to days-1 do
    begin
     for p1:=0 to Tlimit[d1]-1 do
      begin
       sGnum1:=entry[d1,p1];
       if sGnum=sGnum1 then
        begin
         Scm[ScmPos(d5,p5,d1,p1)]:=3;
         continue;
        end;       
       found:=false;
       for l:=l1 to l2 do
        begin
         Sbyte:=FNTbyte(d1,p1,by,l,6)^;
         myblock:=FNgetBlockNumber(d1,p1,by,l);
         flgDouble:=((sByte and 1)=1);
         flgFix:=((sByte and 4)=4);
         if flgDouble or flgFix or ((myblock>0) and (Ebox=0)) then
          begin
           found:=true;
           break;
          end;
        end; {l}
       if found then
        begin
         Scm[ScmPos(d5,p5,d1,p1)]:=1;
         continue;
        end;
       for y:=0 to years_minus_1 do
        begin
         for l:=1 to level[y] do
          begin
           if (y=by) and (l>=l1) and (l<=l2) then continue;
           IntPoint:=FNT(d1,p1,y,l,2); te:=IntPoint^;
           inc(IntPoint); ro:=IntPoint^;
           if Ntesolve>0 then
            for i:=1 to Ntesolve do
             if te=TeSolve[i] then
              begin
               found:=true;
               break;
              end;
           if Nrosolve>0 then
            for i:=1 to Nrosolve do
             if ro=roSolve[i] then
              begin
               found:=true;
               break;
              end;
           if found then
            begin
             Scm[ScmPos(d5,p5,d1,p1)]:=2;
             break;
            end;
          end; {l}
         if found then break;
        end; {y}
      end; {p1}
    end; {d1}
  end; {sGnum>0}
 todo[d5,p5]:=0;
end;

function SolveClash(d5,p5,d6,p6: integer): integer;
var
 myclash: byte;
begin
 if todo[d5,p5]<>0 then SolveClashMatrix(d5,p5);
 myclash:=Scm[ScmPos(d5,p5,d6,p6)];
 result:=myclash;
end;

function NoTarget(d,p: integer):boolean;
begin
 result:=(wstSingle[myTarget,d] and (1 shl p))=0;
end;



procedure CheckSolveSwap(firstTry: bool);
var
 i,d,p:  integer;
 done,gotsolution: bool;
begin
 solution:=0; done:=false;
 if firsttry then begin
   sublevel:=1;
   for i:=1 to 10 do begin
    SmoveD[i]:=0; SmoveP[i]:=0;
   end; {i}
   SmoveD[0]:=bd; SmoveP[0]:=bp;
   SmoveP[1]:=-1; d:=0; p:=-1;
  end
 else begin
  d:=nextD; p:=nextP;
 end; {firstTry}
 repeat
  inc(p);
  if p=Tlimit[d] then begin
   inc(d); p:=0;
  end;
  if (d<days) and (flag[d,p]<>0) then continue;
  if noTarget(d,p) then continue;
  if ((d>=days) and (sublevel=1)) or (solution=100) then break;
  if (d>=days) then begin  {move up solve level}
   dec(sublevel);
   d:=SmoveD[sublevel];
   p:=SmoveP[sublevel];
   flag[d,p]:=0 ;
   continue;
  end;
  if SolveClash(SmoveD[sublevel-1],SmoveP[sublevel-1],d,p)<>0 then continue;
  gotsolution:=false; SmoveD[sublevel]:=d;
  SmoveP[sublevel]:=p; Slevel:=sublevel;
  if (entry[d,p]=0) or ((d=bd) and (p=bp)) then gotsolution:=true;
  if gotsolution then begin
   inc(solution); nextD:=d; nextP:=p; break;
  end;
  if sublevel<10 then  begin
   flag[d,p]:=-1;
   inc(sublevel);  {step down solve}
   d:=0; p:=-1;
  end;
  Application.ProcessMessages;
  if ExitSearch then break;
 until done;
end;

function SolveCheckDouble(d1,p1,d2,p2: integer): bool;
var
 found:    bool;
 l,d,p,su,i: integer;
 count1,count2,a1,a2: integer;

 function SolveCount: integer;
 var
  count,p: integer;
 begin
  count:=0;
  for p:=0 to Tlimit[d2]-1 do
   if socheck[d2,p]=su then inc(count);
  result:=count;
 end;

begin
 found:=false; result:=false;
 for l:=l1 to l2 do begin
  su:=FNT(d1,p1,by,l,0)^;
  if (su=0) or (su>LabelBase) then continue;
  for p:=0 to Tlimit[d2]-1 do begin
   if (p<>p2) then if su=FNT(d2,p,by,l,0)^ then begin
    found:=true; break;
   end;
  end; {p}
  if found then break;
 end; {l}
 if not(found) then exit;
 for l:=l1 to l2 do begin
  su:=FNT(d1,p1,by,l,0)^;
  for d:=0 to days-1 do
   for p:=0 to Tlimit[d]-1 do
    socheck[d,p]:=FNT(d,p,by,l,0)^;
  count1:=SolveCount;
  a1:=socheck[SmoveD[0],SmoveP[0]];
  for i:=1 to Slevel do begin
   a2:=socheck[SmoveD[i],SmoveP[i]];
   socheck[SmoveD[i],SmoveP[i]]:=a1; a1:=a2;
  end; {i}
  count2:=SolveCount;
  if (count2>count1) and (count1>0) then begin
   result:=true; break;
  end;
 end; {l}
end;

procedure TSolveDlg.ShowSolution;
var
 i,d1,p1,d2,p2,su: integer;
 a: string;
begin
 Image1.canvas.fillrect(SolveRect);
 if solution=0 then
  begin
   image1.canvas.textout(2,2,'No solution found');
   NextBtn.Enabled:=False;
   SolveBtn.Enabled:=False;
   exit;
  end;
 NextBtn.Enabled:=True;
 SolveBtn.Enabled:=True;
 for i:=1 to Slevel do
  begin
   d1:=SmoveD[i-1]; p1:=SmoveP[i-1]; d2:=SmoveD[i]; p2:=SmoveP[i];
   su:=FNT(d1,p1,by,l1,0)^;  a:='';
   if su>LabelBase then a:=Tclabel[su-LabelBase]+' '
     else if su>0 then a:=subcode[su]+' ';
   su:=FNT(d1,p1,by,l1,2)^; if su>0 then a:=a+XML_TEACHERS.tecode[su,0]+' ';
   su:=FNT(d1,p1,by,l1,4)^; if su>0 then a:=a+XML_TEACHERS.tecode[su,1]+' ';
   a:=a+day[d1]+':'+tsCode[d1,p1]+' >> '+ day[d2]+':'+tsCode[d2,p2];
   if SolveCheckDouble(d1,p1,d2,p2) then a:=a+' *';
   image1.canvas.textout(2,2+15*(i-1),a);
  end;
end;

procedure TSolveDlg.FindBtnClick(Sender: TObject);
var
 msg:    string;
 i,l,d,p,te,ro:      integer;
 Sbyte:  byte;
 IntPoint:      tpIntPoint;
begin
 if DoingSearch then begin
  ExitSearch:=true;
  exit;
 end;
 Solution:=0; msg:='';
 for l:=l1 to l2 do
  begin
   Sbyte:=FNTbyte(bd,bp,by,l,6)^;
   if (sByte and 1)=1 then msg:='part of a double';
   if (sByte and 4)=4 then msg:='fixed';
  end;
 if (Nblock>0) and (Ebox=0) then msg:='part of a block';
 if msg>'' then
  begin
   msg:='This entry is '+msg;
   messagedlg(msg,mtError,[mbOK],0);
   exit;
  end;
 for d:=0 to days-1 do
  for p:=0 to Tlimit[d]-1 do begin
   entry[d,p]:=0; flag[d,p]:=0; todo[d,p]:=-1;
  end;
 for i:=0 to 25000 do Scm[i]:=0;
 sGnum:=0;
 for d:=0 to days-1 do
  for p:=0 to Tlimit[d]-1 do
   begin
    Ntesolve:=0;Nrosolve:=0;
    if entry[d,p]>0 then continue;
    for l:=l1 to l2 do
     begin
      IntPoint:=FNT(d,p,by,l,2); te:=IntPoint^;
      inc(IntPoint); ro:=IntPoint^;
      if te>0 then
       begin
        inc(Ntesolve); TeSolve[Ntesolve]:=te;
       end;
      if ro>0 then
       begin
        inc(Nrosolve); roSolve[Nrosolve]:=ro;
       end;
     end; {l}
    if (Ntesolve>0) or (Nrosolve>0) THEN
     begin
      inc(sGnum);entry[d,p]:=sGnum;
      CheckDuplicates(d,p);
     end;
   end; {p}
 DoingSearch:=true;
 FindBtn.Caption:='Halt';  FindBtn.Refresh;
 SolveClash(bd,bp,0,0);
 CheckSolveSwap(True);
 DoingSearch:=false; FindBtn.Caption:='Find';
 if ExitSearch then begin
   Label8.Caption:='Find Halted';
   Solution:=0;
  end
 else Label8.Caption:='Find completed';
 ShowSolution; ExitSearch:=false;
end;

procedure TSolveDlg.NextBtnClick(Sender: TObject);
begin
 if DoingSearch then begin
  ExitSearch:=true;
  exit;
 end;
 DoingSearch:=true;
 NextBtn.Caption:='Halt';  NextBtn.Refresh;
 CheckSolveSwap(False);
 DoingSearch:=false; NextBtn.Caption:='Next';
 if ExitSearch then begin
   Label8.Caption:='Next Halted';
   Solution:=0;
  end
 else Label8.Caption:='Next completed';
 ShowSolution; ExitSearch:=false;
end;

procedure TSolveDlg.SolveBtnClick(Sender: TObject);
var
 B,C:  tpIntPoint;
 Swapint,fl,i:   integer;
begin
 PushTtStackStart(utSolve);
 for i:=0 to Slevel do
  begin
   if (i=Slevel) then
    if (SmoveP[0]=SmoveP[Slevel]) and (SmoveD[0]=SmoveD[Slevel])
     then continue;
   for fl:=l1 to l2 do PushCell(SmoveD[i],SmoveP[i],by,fl);
  end;
 for i:=Slevel downto 1 do begin
  if (i=1) then if (SmoveP[0]=SmoveP[Slevel]) and (SmoveD[0]=SmoveD[Slevel]) then continue;
  for fl:=l1 to l2 do begin
   C:=FNT(SmoveD[i-1],SmoveP[i-1],by,fl,0);
   B:=FNT(SmoveD[i],SmoveP[i],by,fl,0);
   Swapint:=B^; B^:=C^; C^:=Swapint;
   inc(B); inc(C); Swapint:=B^; B^:=C^; C^:=Swapint;
   inc(B); inc(C); Swapint:=B^; B^:=C^; C^:=Swapint;
   inc(B); inc(C); Swapint:=B^; B^:=C^; C^:=Swapint;
  end;
  Fclash[SmoveD[i-1],SmoveP[i-1]]:=1;
  Fclash[SmoveD[i],SmoveP[i]]:=1;
 end;
 restore;
 ttclash;
 UpdateTimetableWins;
 SaveTimeFlag:=True;
 Label8.Caption:='Solve completed';
end;

procedure TSolveDlg.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
 allowNumericInputOnly(key);
end;

procedure TSolveDlg.ComboBox5Change(Sender: TObject);
var
 oldtarget: integer;
begin
 oldtarget:=myTarget;
 myTarget:=ComboBox5.ItemIndex-1;
 if myTarget<>oldtarget then restore;
end;

procedure TSolveDlg.ComboBox3Change(Sender: TObject);
var
 oldperiod:  integer;
begin
 if FirstStart then exit;
 oldperiod:=bp;
 bp:=combobox3.ItemIndex;
 combobox3.SelectAll;
 if bp<>oldperiod then restore;
end;

procedure TSolveDlg.ComboBox3Enter(Sender: TObject);
begin
 ComboBox3.SelectAll;
end;

end.

