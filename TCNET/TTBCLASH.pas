unit Ttbclash;

interface

uses SysUtils, WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, Dialogs, TimeChartGlobals,GlobalToTcAndTcextra;

type
  TttclashDlg = class(TForm)
    OKBtn: TBitBtn;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
  private
    procedure SwapTTBlocks;
    procedure TeacherSwaps;
  end;

//Don't use fixed or doubles in worksheet


var
  ttclashDlg: TttclashDlg;

implementation

{$R *.DFM}
uses tcommon,ttable,TTundo,tcommon2,DlgCommon,worksheet;

var
 blockmax,blevel:    array[0..nmbryears] of smallint;
 blmax,crosscount,wsCode:       smallint;
 fb, fy, fl:       smallint;
 tb, ty, tl:       smallint;
 DoingCalc,HaltCalc:   bool;





Procedure DoSwapUnit;
var
 B,C:  tpIntPoint;
 Swapint:   smallint;
begin
 C:=FNws(fb,fy,fl,0); B:=FNws(tb,ty,tl,0);
 Swapint:=B^; B^:=C^; C^:=Swapint;
 inc(B); inc(C); Swapint:=B^; B^:=C^; C^:=Swapint;
 inc(B); inc(C); Swapint:=B^; B^:=C^; C^:=Swapint;
 inc(B); inc(C); Swapint:=B^; B^:=C^; C^:=Swapint;
 inc(B); inc(C); Swapint:=B^; B^:=C^; C^:=Swapint;
 inc(B); inc(C); Swapint:=B^; B^:=C^; C^:=Swapint;
 WSFclash[tb]:=1;
 WSFclash[fb]:=1;
end;


procedure CopyYrTime;
var
 fli: integer;
begin
 ty:=fy;
 for fli:=1 to level[fy] do
  begin
   fl:=fli; //set global
   tl:=fl;
  end;
 for fli:=1 to level[fy] do
  begin
   fl:=fli; //set global
   tl:=fl;
   DoSwapUnit;
  end;
end;

procedure MaximumBlocks;
var
 y,l,b:  integer;
 su,te,ro:                 integer;
 aFnt:  tpIntPoint;
begin
 blmax:=0;
 for y:=0 to years_minus_1 do
  begin
   blockmax[y]:=0; blevel[y]:=0;
   for b:= 1 to blocks[y] do
    for l:=1 to level[y] do
     begin
      aFnt:=FNws(b,y,l,0);
      su:=aFnt^;  inc(aFnt);
      te:=aFnt^;  inc(aFnt);
      ro:=aFnt^;
      if (su>0) or (te>0) or (ro>0) then
       begin
        blockmax[y]:=b;
        if l>blevel[y] then blevel[y]:=l;
       end; {if}
     end; {l}
   if blockmax[y]>blmax then blmax:=blockmax[y];
  end; {y}
end;

procedure convert(count: smallint; var d: smallint; var p: smallint);
var
 i: smallint;
begin
 d:=0; p:=-1; i:=count;
 while i>Tlimit[d] do
  begin
   dec(i,Tlimit[d]);
   inc(d);
  end;
 inc(p,i);
end;

procedure SwapClashUpdate;
var
 b: smallint;
begin
 for b:=1 to blmax do wsBlockClash(b);
 WSclashtotal;
end;

function SwapClashes: integer;
var
 b,clcount: smallint;
begin
 SwapClashUpdate;
 clcount:=0;
 for b:=1 to blmax do
   inc(clcount,wsTclash[b]+wsRclash[b]);
 result:=clcount;
end;

procedure TttclashDlg.SwapTTBlocks;
var
  swapclash,swapclash1,swapclash2: smallint;
  msg: string;
  b1,b2,fyi: smallint;

begin
 swapclash:=SwapClashes;
 msg:='';
 if swapclash=0 then msg:=' No teacher or room clashes. ';
 if blMax<2 then msg:=' Not enough blocks entered to swap. ';
 if msg<>'' then
  begin
   label1.caption:=msg;
   OKBtn.ModalResult:=mrOK;
   exit;
  end;
 pushWSstack(1,0,1,blmax,years_minus_1,levelsUsed,utSwapBlock);
 OKBtn.Caption:='Halt';
 OKBtn.Refresh;
 DoingCalc:=True;
 repeat
  swapclash2:=swapclash;
  if swapclash=0 then break;
  for fyi:=0 to years_minus_1 do
   begin
    fy:=fyi;      //set global
    if (fy=wsy) or (blockmax[fy]=0) then continue;
    label1.caption:='Checking blocks in '+yeartitle+' '+yearname[fy]+' ...';
    label1.refresh;
    for b1:=1 to blmax-1 do
     begin
      fb:=b1;
      for b2:=b1+1 to blmax do
       begin
        tb:=b2;
        swapclash1:=swapclash;
        if (wsTclash[fb]>0) or (wsRclash[fb]>0) or
            (wsTclash[tb]>0) or (wsRclash[tb]>0) then
         begin
          copyYrTime;
          swapclash:=SwapClashes;
          if swapclash>=swapclash1 then
           begin
            copyYrTime;
            swapclash:=SwapClashes;
           end
          else updateWSwindow;
          Application.ProcessMessages;
          if HaltCalc then
           begin
            swapclash:=0;
            break;
           end;
         end; {if}
        if swapclash=0 then break;
       end; {b2}
      if swapclash=0 then break;
     end; {b1}
    if swapclash=0 then break;
   end; {y4}
 until (swapclash=0) or (swapclash=swapclash2);
 if HaltCalc then msg:='Block Swaps halted' else msg:='Block Swaps completed';
 label1.caption:=msg;
 OKBtn.Caption:='OK';
 OKBtn.ModalResult:=mrOK;
 OKBtn.Refresh;
 SaveTimeFlag:=True;
 UpdateWSwins;
end;


function CheckTeacherBlock: bool;
var
 te1,te2,fli,tli: integer;
begin
 result:=false;
 for fli:=1 to level[fy] do
  begin
   fl:=fli; //set global
   te1:=FNws(fb,fy,fl,2*wsCode)^;
   for tli:=1 to level[ty] do
    begin
     tl:=tli; //set global
     te2:=FNws(tb,ty,tl,2*wsCode)^;
     if (te2>0) and (te1=te2) then
      begin
       result:=true;
       break;
      end;
    end; {tl}
   if result then break;
  end; {fl}
end;


procedure DoCrosscount;
var
 b1,b2,tyi: integer;
begin
 CrossCount:=0;
 for tyi:=years_minus_1 downto 0 do
  begin
   ty:=tyi;  //set global
   if ty=fy then continue;
   for b1:=1 to blocks[ty] do
    begin
     tb:=b1;;
     for b2:=1 to blocks[fy] do
      begin
       fb:=b2;
       if CheckTeacherBlock then inc(crosscount);
      end;
    end; {b1}
  end; {ty}
end;

procedure TttclashDlg.TeacherSwaps;
var
 msg,sub1code,sub2code:  string;
 b1,b2:                  smallint;
 d1,p1,d2,p2,l5,l6:      smallint;
 sub1,teach1,sub2,teach2: smallint;
 te_there:                bool;
 crosscount2,clash2,clash3,fyi:  smallint;

 procedure SwapTeacher;
 begin
  FNws(b1,fy,l5,2*wsCode)^:=teach2;
  FNws(b2,fy,l6,2*wsCode)^:=teach1;
  wsFclash[b1]:=1; wsFclash[b2]:=1;
  SwapInt(teach1,teach2);
 end;

begin
 if wsCode=1 then msg:='Teacher' else msg:='Room';
 msg:='Swap '+msg+'s in Blocks';
 GroupBox1.caption:=msg;
 GroupBox1.refresh;
 if blMax<2 then
  begin
   label1.caption:=' Not enough blocks entered to swap. ';
   OKBtn.ModalResult:=mrOK;
   exit;
  end; 

 OKBtn.Caption:='Halt';
 OKBtn.Refresh;
 DoingCalc:=True;
 pushWSstack(1,0,1,blmax,years_minus_1,levelsUsed,utSwapBlock+wsCode);
 for fyi:=0 to years_minus_1 do
  begin
   fy:=fyi;  //set global
   if blockmax[fy]=0 then continue;
   DoCrossCount;
   for b1:=1 to blocks[fy] do
    begin
     label1.caption:='Checking '+
        yeartitle+' '+yearname[fy]+' Block '+inttostr(b1)+' ...';
     label1.refresh;
     for l5:=1 to level[fy] do
      begin
       sub1:=FNws(b1,fy,l5,0)^;
       teach1:= FNws(b1,fy,l5,2*wsCode)^;
       if (sub1=0) or (sub1>LabelBase) or (teach1=0) then continue;
       sub1code:=copy(Subcode[sub1],1,lencodes[0]-1);
       for b2:=b1+1 to blmax do
        begin
         te_there:=false;
         for l6:=1 to level[fy] do
          begin
           teach2:=FNws(b2,fy,l6,0)^;
           if teach2=teach1 then
            begin
             te_there:=true;
             break;
            end;
          end; {l6}
         if te_there then continue;
         for l6:=1 to level[fy] do
          begin
           sub2:=FNws(b2,fy,l6,0)^;
           teach2:=FNws(b2,fy,l6,2*wsCode)^;
           if (sub2=0) or (sub2>LabelBase) then continue;
           sub2code:=copy(Subcode[sub2],1,lencodes[0]-1);
           if sub1code=sub2code then
            begin
             Docrosscount;
             crosscount2:=crosscount;
             clash2:=wsTclash[b1]+wsRclash[b1]+wsTclash[b2]+wsRclash[b2];
             SwapTeacher;
             SwapClashUpdate;
             Docrosscount;
             clash3:=wsTclash[b1]+wsRclash[b1]+wsTclash[b2]+wsRclash[b2];
             if (clash3<clash2) or ((clash3=clash2) and (crosscount<crosscount2)) then
              updateWSWindow
             else
              begin
               SwapTeacher;
               SwapClashUpdate;
              end;

            end;  {sub1code=sub2code}
           Application.ProcessMessages;
           if HaltCalc then crosscount:=0;
           if crosscount=0 then break;
          end; {l6}
         if crosscount=0 then break;
        end; {b2}
       if crosscount=0 then break;
      end; {l5}
     if crosscount=0 then break;
    end; {b1}
   if HaltCalc then break;
  end; {fyi}
 if wsCode=1 then msg:='Teacher' else msg:='Room';
 if HaltCalc then msg:=msg+' Swaps halted' else msg:=msg+' Swaps completed';
 label1.caption:=msg;
 OKBtn.Caption:='OK';
 OKBtn.ModalResult:=mrOK;
 OKBtn.Refresh;
 UpdateWSwins;
 SaveTimeFlag:=True;
end;



procedure TttclashDlg.FormActivate(Sender: TObject);
begin
 DoingCalc:=False;
 HaltCalc:=False;
 MaximumBlocks;
 case tag of
  1: begin
      GroupBox1.caption:='Swap Blocks';
      GroupBox1.refresh;
      Swapttblocks;
     end;
  2: begin
      wsCode:=1;
      TeacherSwaps;
     end;
  3: begin
      wsCode:=2;
      TeacherSwaps;
     end;
 end; {case}

end;

procedure TttclashDlg.OKBtnClick(Sender: TObject);
begin
 if DoingCalc then HaltCalc:=True;
end;

end.
