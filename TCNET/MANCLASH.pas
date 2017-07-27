unit Manclash;

interface

uses SysUtils,WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, Dialogs,TimeChartGlobals, XML.DISPLAY, XML.STUDENTS;

type
  TManClashDlg = class(TForm)
    HelpBtn: TBitBtn;
    ScrollBox1: TScrollBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Finish: TBitBtn;
    EnterBtn: TBitBtn;
    Image1: TImage;
    previous: TBitBtn;
    next: TBitBtn;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure nextClick(Sender: TObject);
    procedure previousClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure EnterBtnClick(Sender: TObject);
    procedure Image1DblClick(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure resetDlg;
    procedure getsolution;
    procedure NextStep;
    procedure prevStep;
    procedure enterSolution;
    procedure showsolution;
    procedure showclashes;
    procedure showstudent;
    procedure setManClashTabs;
  end;

var
  ManClashDlg: TManClashDlg;

implementation

{$R *.DFM}
uses tcommon,DlgCommon,stcommon,block1,subyr,Stclash;
var
 sTlocate,sTprevious,sTnext,st:  integer;  {positions in groupnum}
 Bitmap1:     Tbitmap;
 xtab,numtab,clSelect: integer;
 Hmargin,txtheight:  integer;
 SelectRect:           Trect;
 doubleclick:          bool;
 SolInvert:       array[0..nmbrBlocks] of bool;

procedure TManClashDlg.FormCreate(Sender: TObject);
begin
 Bitmap1:=Tbitmap.Create;
 Hmargin:=self.canvas.textwidth('AA');
 txtHeight:=self.canvas.textheight('A');
 doubleclick:=false;
end;

function getnext: integer;
 var
  found,Balancedo,Clashdo:  bool;
  i,locate:      integer;
begin
 found:=false;
 locate:=sTlocate;
 repeat
  inc(locate);
  if locate>groupnum then break;
  i:=StGroup[locate];
  Balancedo:=(XML_DISPLAY.Balanceflag=1);
  if ((sexbalance=1) and (XML_STUDENTS.Stud[i].sex=genderShort[0]{'M'})) or ((sexbalance=2) and (XML_STUDENTS.Stud[i].sex=genderShort[1]{'F'}))
     then balancedo:=false;
  clashdo:=false;
  if XML_DISPLAY.balanceflag=0 then if hasstudentclash(i) then clashdo:=true;
  if balancedo or clashdo then found:=true;
 until found or (locate>groupnum);
 if found then result:=locate else result:=0;
end;

function getprevious: integer;
 var
  found,Balancedo,Clashdo:  bool;
  i,locate:      integer;
begin
 found:=false;
 locate:=sTlocate;
 repeat
  dec(locate);
  if locate<=0 then break;
  i:=StGroup[locate];
  Balancedo:=(XML_DISPLAY.Balanceflag=1);
  if ((sexbalance=1) and (XML_STUDENTS.Stud[i].sex=genderShort[0]{'M'}))
    or ((sexbalance=2) and (XML_STUDENTS.Stud[i].sex=genderShort[1]{'F'}))
      then balancedo:=false;
  clashdo:=false;
  if XML_DISPLAY.balanceflag=0 then if hasstudentclash(i) then clashdo:=true;
  if balancedo or clashdo then found:=true;
 until found or (locate<=0);
 if found then result:=locate else result:=0;
end;

procedure TManClashDlg.showstudent;
var
 NameRect: Trect;
 x,y,j,su,p,k:      integer;
 invertflag:        bool;
 str:      string;
begin
 {show name and original choices}
 NameRect.top:=28; Namerect.Left:=8; NameRect.Bottom:=58; NameRect.Right:=533;
 canvas.font.color:=clblack;
 canvas.brush.color:=clBtnFace;
 canvas.fillrect(NameRect);
 x:=10;y:=30;
 hasstudentclash(st);
 for j:=1 to blnum1 do
  begin
   if j=7 then begin x:=10; y:=y+txtHeight; end;
   su:=BlClash[0,j]; invertflag:=false;
   for p:=1 to XML_DISPLAY.blocknum do
    begin
     if not(BlInvert[p]) then continue;
     for k:=1 to Sheet[p,0] do
      if su=Sheet[p,k] then
       begin
        invertflag:=true;
        break;
       end;
    end;
   if invertflag then
    begin
     canvas.font.style:=(canvas.font.style+[fsUnderline]);
     canvas.font.color:=clred;
    end
   else
    begin
     canvas.font.style:=(canvas.font.style-[fsUnderline]);
     canvas.font.color:=clblack;
    end;
   su:=BlClash[0,j];
   str:=subcode[su]+' '+inttostr(GroupSubCount[GsubXref[su]]);
   canvas.textout(x,y,str);
   x:=x+canvas.textwidth(str)+blankwidth;
  end;
 canvas.font.style:=(canvas.font.style-[fsUnderline]);
end;

procedure TManClashDlg.setManClashTabs;
var
 maxH,maxW:           integer;
begin
 xtab:=fwCode[0]+image1.canvas.textwidth('999 ')+blankWidth;
 numtab:=image1.canvas.textwidth('50: ');
 maxW:=Hmargin+numtab+(blnum1*xtab);
 maxH:=txtheight*(MyBlSolution+2);
 Bitmap1.width:= maxW;
 Bitmap1.height:=maxH;
 Bitmap1.canvas.brush.color:=clWhite;
 Bitmap1.canvas.floodfill(0,0,clWhite,fsBorder);
 image1.Picture.Graphic:=Bitmap1;
 image1.canvas.brush.color:=clWhite;
 image1.canvas.pen.color:=clBlack;
 scrollbox1.VertScrollbar.Range:=maxH;
 scrollbox1.HorzScrollbar.Range:=maxW;
end;

procedure SolutionClashes(i: smallint);
var
 p,j,k,studclash,num,a:  smallint;
begin
 for p:=1 to XML_DISPLAY.blocknum do
  begin
   SolInvert[p]:=false;
   studclash:=0; num:=Sheet[p,0];
   if (num<2) then continue;
   for j:=1 to blnum1 do
    begin
     a:=BlClash[i,j];
     if a=0 then continue;
     for k:=1 to num do
      begin
       if a=Sheet[p,k] then inc(studclash);
       if studclash>1 then
        begin
         SolInvert[p]:=true;
         break;
        end;
      end; {k}
     if SolInvert[p] then break;
    end;{j}
  end; {p}
end;

function CheckChoiceForClash(i,sub: smallint): bool;
var
 p,k:    smallint;
begin
 result:=false;
 if sub=0 then exit;
 for p:=1 to XML_DISPLAY.blocknum do
  begin
   if not(SolInvert[p]) then continue; {no clashes in this block}
   for k:=1 to Sheet[p,0] do
    if sub=Sheet[p,k] then  {subject is in block with a clash}
     begin
      result:=true;
      break;
     end;
  end; {p}
end;

procedure TManClashDlg.showclashes;
var
 i,j,k,su,a1:    integer;
 x,y:        integer;
 str:        string;
begin
 if MyBlSolution=0 then exit;
 y:=txtHeight;
 for k:=1 to MyBlSolution do
  begin
   i:=ClashOrder[k];
   str:=inttostr(k)+':';
   image1.canvas.textout(Hmargin,y,str);
   if BlPartial then SolutionClashes(i);
    for j:=1 to blnum1 do
     begin
      x:=Hmargin+numtab+(j-1)*xtab;
      su:=BlClash[i,j];
      a1:=GroupSubCount[GsubXref[su]];
      if su<>BlClash[0,j] then inc(a1);
      str:=subcode[su]+' '+inttostr(a1);

      if BlPartial then if CheckChoiceForClash(i,su)
        then image1.Canvas.font.color:=clred;
      image1.canvas.textout(x,y,str);
      image1.Canvas.font.color:=clblack;
     end;
    y:=y+txtHeight;
   end; {i}
  if clSelect>0 then
     begin
      SelectRect.top:=txtHeight*clSelect+1;
      SelectRect.bottom:=SelectRect.top+txtHeight;
      SelectRect.left:=2;
      SelectRect.right:= scrollbox1.HorzScrollbar.Range;
      invertrect(image1.canvas.handle,SelectRect);
     end;
end;

procedure TManClashDlg.showsolution;
begin
 Label4.caption:=XML_STUDENTS.Stud[st].stname+' '+XML_STUDENTS.Stud[st].first;
 Label2.caption:=inttostr(MyBlSolution);
 if BlPartial then label1.Caption:='Part Clash Alternatives'
   else label1.Caption:='Clash Free Alternatives';
 showstudent;
 setManClashTabs;
 clSelect:=0;
 if MyBlSolution>0 then
  begin
   clSelect:=1;
   showclashes;
  end;
end;

procedure TManClashDlg.resetDlg;
begin
 EnterBtn.Enabled:=((sTlocate>0) and (stlocate<=groupnum) and (MyBlSolution>0));
 Previous.Enabled:=((sTprevious>0) and (stprevious<=groupnum));
 next.Enabled:=((sTnext>0) and (stnext<=groupnum));
 showsolution;
 if MyBlSolution>0 then
  begin
   edit1.text:='1';
   edit1.setfocus;
   edit1.SelectAll;
  end
 else edit1.text:='';
end;

procedure RemoveDuplicates;
var
 i,j,k,a: integer;
 IsDuplicate:  array[0..nmbrSolutions] of boolean;
 different: boolean;
begin
 for i:=1 to nmbrSolutions do IsDuplicate[i]:=false;
 for i:=1 to MyBlSolution-1 do
  if not(IsDuplicate[i]) then
   for j:=i+1 to MyBlSolution do
    if not(IsDuplicate[j]) then
     begin
      different:=false;
      for k:=1 to blnum1 do
       if BlClash[i,k]<>BlClash[j,k] then
        begin
         different:=true;
         break;
        end;
      if not(different) then IsDuplicate[j]:=true;
     end;
 a:=1;
 for i:=2 to MyBlSolution do
  if not(IsDuplicate[i]) then
   begin
    inc(a);
    for k:=1 to blnum1 do
     BlClash[a,k]:=BlClash[i,k];
   end;
 MyBlSolution:=a;
end;



procedure TManClashDlg.getsolution;
begin
 st:=StGroup[sTlocate];
 StClashHelpDlg.label5.caption:='Student '+inttostr(st)+'..   ';
 StClashHelpDlg.label5.refresh;
 getStclashes(st);
 if MyBlSolution>1 then
  begin
   RemoveDuplicates;
   WeightSolutions(st);
  end;
 resetDlg;
end;

procedure TManClashDlg.FormActivate(Sender: TObject);
begin
 sTlocate:=0;
 sTprevious:=0;
 sTnext:=getnext;
 sTlocate:=sTnext;
 sTnext:=getnext;
 getsolution;
end;

procedure TManClashDlg.nextStep;
begin
 sTlocate:=sTnext;
 sTnext:=getnext;
 sTprevious:=getprevious;
 getsolution;
end;

procedure TManClashDlg.nextClick(Sender: TObject);
begin
 nextStep;
end;

procedure TManClashDlg.prevStep;
begin
 sTlocate:=stPrevious;
 sTnext:=getnext;
 sTprevious:=getprevious;
 getsolution;
end;

procedure TManClashDlg.previousClick(Sender: TObject);
begin
 prevStep;
end;

procedure TManClashDlg.FormPaint(Sender: TObject);
begin
 showstudent;
end;

procedure TManClashDlg.Image1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
 ylocate:  integer;
begin
 if doubleclick then
  begin
   doubleclick:=false;
   exit;
  end;
 ylocate:=(y div txtHeight);
 if (ylocate=clSelect) or (ylocate<1) or (ylocate>MyBlSolution) then exit;
 if clSelect>0 then invertrect(image1.canvas.handle,SelectRect);
 SelectRect.top:=txtHeight*ylocate+1;
 SelectRect.bottom:=SelectRect.top+txtHeight;
 SelectRect.left:=2;
 SelectRect.right:= scrollbox1.HorzScrollbar.Range;
 invertrect(ManClashDlg.image1.canvas.handle,SelectRect);
 clSelect:=ylocate;
 image1.repaint;
 Edit1.text:=inttostr(clSelect);
 edit1.setfocus;
 edit1.SelectAll;
end;

procedure TManClashDlg.enterSolution;
var
 msg:  string;
 getsol:  integer;
begin
 getsol:=IntFromEdit(edit1);
 if (getsol<1) or (getsol>MyBlSolution) then
  begin
   ShowMsg('Enter solution number between 1 and '+inttostr(MyBlSolution),edit1);
   exit;
  end;
 newchoice(getsol,st);
 if clashflag then
  begin
   SaveStudFlag:=True;
   SaveBlockFlag:=True;
   BlockLoad:=3;
   CalculateClashmatrix;
   CountGroupSubs;
   UpdateStudWins;
   StClashHelpDlg.Label4.caption:=inttostr(BlockClashes[0]);
  end;
 if (BlockClashes[0]=0) and (XML_DISPLAY.Balanceflag=0) then
  begin
   msg:='No more clashes to solve';
   messagedlg(msg,mtInformation,[mbOK],0);
   ManClashDlg.close;
   exit;
  end;
 if sTnext>0 then nextStep;
 if (sTnext=0) then
  begin
   if XML_DISPLAY.Balanceflag=0 then prevStep else getsolution;
  end;
end;

procedure TManClashDlg.EnterBtnClick(Sender: TObject);
begin
 EnterSolution;

end;

procedure TManClashDlg.Image1DblClick(Sender: TObject);
begin
 doubleclick:=true;
 EnterSolution;
end;

procedure TManClashDlg.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
 allowNumericInputOnly(key);
end;

procedure TManClashDlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 Bitmap1.Free;
 action:=cafree;
end;

end.
