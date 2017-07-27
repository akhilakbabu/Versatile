unit Create;

interface

uses SysUtils,WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, Dialogs,TimeChartGlobals,GlobalToTcAndTcextra, XML.DISPLAY, XML.STUDENTS;

type
  TCreateDlg = class(TForm)
    CreateBtn: TBitBtn;
    HelpBtn: TBitBtn;
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Finish: TBitBtn;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label9: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;

    procedure FormCreate(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit4KeyPress(Sender: TObject; var Key: Char);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
    procedure CreateBtnClick(Sender: TObject);
  private
    procedure SolveClashByClassChange;
  end;

var
  CreateDlg: TCreateDlg;

implementation

{$R *.DFM}
uses
  tcommon,DlgCommon,stcommon,block1,subyr, uAMGClassSubject;

var
 BLfile:  string;
 numcombine,numtries: integer;
 combine:  tpYearData;
 joinflag,quickshuffle,shuffleflag,shuffledone: bool;
 ClashFlag, ExitMake,Iflag,finalbalance,DoingCreate: bool;
 splitSu,splitSuMaxSize:              integer;  {split subject}
 SpClassnum,clsize:      integer;  {number of splits and size of each split}
 split:  array[0..30] of integer;    {array of split subjects}
 I2start,I2end: integer;

procedure balance; forward;

procedure ShowClashes;
begin
 CreateDlg.label15.Caption:=inttostr(BlockClashes[0]);
 CreateDlg.label15.refresh;
end;

procedure TCreateDlg.FormCreate(Sender: TObject);
var
 a,b: string;
begin
 edit1.text:=inttostr(XML_DISPLAY.BLsolution);
 edit2.text:=inttostr(XML_DISPLAY.BLtries);
 edit3.text:=inttostr(XML_DISPLAY.MaxClassSize);
 a:=copy(yeartitle,1,1);
 CheckCurrentYear;
 if currentyear<>-1 then b:=copy(yearname[currentyear],1,2)
   else b:='All';
 if pos(' ',b)>0 then b:=inttostr(currentyear+7);
 BLfile:=groupname+'TRY';
 if ((GOSrecipe.NumSteps=1)
     and (GOSrecipe.steps[1].slct=1)) then
       BLfile:=a+b+'TRY';



 edit4.text:=BLfile;
 label9.visible:=false; label10.visible:=false; label11.visible:=false;
 label7.visible:=false; label8.visible:=false;
 label12.Caption:=''; label14.Caption:=''; label16.Caption:='';
 label13.caption:=''; label15.Caption:='';
 label5.Caption:='';  label6.caption:='';
 DoingCreate:=false;
 TopCentre(self);
 if needClashMatrixRecalc then CalculateClashmatrix;
end;

procedure TCreateDlg.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
 allowNumericInputOnly(key);
end;

procedure TCreateDlg.Edit4KeyPress(Sender: TObject; var Key: Char);
begin
 if pos(key,' .,<>\|:;[]+=?/*^')>0 then key:=chr(0);
end;

procedure TCreateDlg.Edit1Change(Sender: TObject);
begin
 XML_DISPLAY.BLsolution:=IntFromEdit(edit1);
end;

procedure TCreateDlg.Edit2Change(Sender: TObject);
begin
 XML_DISPLAY.BLtries:=IntFromEdit(edit2);
end;

procedure TCreateDlg.Edit4Change(Sender: TObject);
var
 s: string;
begin
 s:=trim(edit4.text);
 BLfile:=s;
end;


procedure join(splitSu: integer);
var
 i,i2,j,k,place:  integer;
 sub,sub2:       string;
 fromblock,sublevel,subnum: integer;
 SpClassnum1: integer;
begin
 SpClassnum1:=0;
 sub:=SubCode[splitSu];
 SetLength(sub,Length(sub)-1);
 for i:=1 to 26 do
  begin
   Sub2:=Sub+chr(64+i);
   place:=checkGrSub(Sub2);
   if (place>0) and (GroupSubCount[place]>0) then
    begin
     inc(SpClassnum1);
     split[SpClassnum1]:=place;
    end;
   if SpClassnum1>=20 then break;
  end;
 if SpClassnum1=0 then exit;
 joinflag:=true;
 for k:=1 to SpClassnum1 do
  begin
   GroupSubCount[split[k]]:=0;
   subnum:=GroupSubs[split[k]];
   fromblock:=findblock(subnum,sublevel);
   if (fromblock>0) and (sublevel>fix[fromblock]) then blockchange(subnum,0);
  end; {k}
 for i2:=1 to groupnum do
  begin
   i:=StGroup[i2];
   for j:=1 to chmax do
    for k:=1 to SpClassnum1 do
     if XML_STUDENTS.Stud[i].Choices[j]=GroupSubs[split[k]] then
      begin
       XML_STUDENTS.Stud[i].Choices[j]:=splitSu;
       SaveStudFlag:=true;  saveBlockFlag:=True;
       StudYearFlag[XML_STUDENTS.Stud[i].tcYear]:=true;
       inc(GroupSubCount[GsubXref[splitSu]]);
       break;
      end;
  end;
end;


procedure DoCombine;
var
 place2:  integer;
begin
 if numcombine=0 then exit;
 Createdlg.label5.caption:='Combining Split subjects';
 Createdlg.label5.refresh;
 Createdlg.label6.caption:='';ShowClashes;
 Createdlg.label6.refresh;
 joinflag:=false;
 for place2:=1 to numcombine do begin
  Join(combine[place2]);
  Application.ProcessMessages;
  if exitMake then break;
 end; {place2}
 if joinflag then
  begin
   settop;
   CalculateClashmatrix;
   UpdateStudWins; {or update block and subyear windows}
   SaveStudFlag:=True;
   SaveBlockFlag:=True; ShowClashes;
   BlockLoad:=3;
  end
end;

procedure DoAuto;
 var
  i,j,p,a,s,per,lev:    integer;
  leftout,big,pos,fullblocks:    integer;
  stclash,order:  tpYearData;
  got:            bool;
  msg:            string;

 function periodclash: integer;
   var
    a,b,k,sum: integer;
   begin
    sum:=0; result:=0;
    if lev<2 then exit;
    a:=Sheet[per,lev];
    for k:=1 to lev-1 do
     begin
      b:=Sheet[per,k];
      sum:=sum+FNcm(GsubXref[a],GsubXref[b]);
     end;
    result:=sum;
 end;

 procedure putin;
  var
   j: integer;
  begin
   got:=false; per:=p;
   for j:=Lblock to Hblock do
    begin
     lev:=Sheet[per,0]+1;
     if lev<=XML_DISPLAY.blocklevel then
      begin
       Sheet[per,lev]:=GroupSubs[order[i]];
       if periodclash=0 then
        begin
         got:=true;
         Sheet[per,0]:=lev;
         Blocktop[order[i]]:=0;
         break;
        end;
      end; {if lev}
     Sheet[per,lev]:=0;
     inc(per); if per>Hblock then per:=Lblock;
    end;  {j}
  end;


 procedure least;
  var
   j,maxclash:  integer;
   leveltemp,percl: integer;
   minp,minlev: integer;
  begin
   maxclash:=10000; per:=p;    minlev:=0; minp:=0;
   leveltemp:=XML_DISPLAY.blocklevel;
   if leveltemp<levelprint then inc(leveltemp);
   for j:=Lblock to Hblock do
    begin
     lev:=Sheet[per,0]+1;
     if lev<=leveltemp then
      begin
       Sheet[per,lev]:=GroupSubs[order[i]];
       percl:=periodclash;
       if percl<maxclash then
        begin
         maxclash:=percl; minp:=per; minlev:=lev;
        end;
      end; {lev<=leveltemp}
     Sheet[per,lev]:=0;
     inc(per); if per>Hblock then per:=Lblock;
    end; {j}
   if maxclash<10000 then
    begin
     Sheet[minp,minlev]:=GroupSubs[order[i]];
     Blocktop[order[i]]:=0;
     Sheet[minp,0]:=minlev;
     if minlev>XML_DISPLAY.blocklevel then XML_DISPLAY.blocklevel:=minlev;
     stclash[i]:=0;
    end;
  end;


begin
 fullblocks:=0;
 fillchar(stclash,sizeof(stclash),chr(0));
 fillchar(order,sizeof(order),chr(0));
 CreateDlg.label5.caption:='Automatic allocation..';
 CreateDlg.label5.refresh;
 CreateDlg.label6.caption:='';
 CreateDlg.label6.refresh; ShowClashes;
 for i:=1 to GroupSubs[0] do
  begin
   stclash[i]:=0;
   for j:=1 to GroupSubs[0] do
    if i<>j then inc(stclash[i],FNcm(i,j));
  end;
 if excludenum>0 then
   for i:=1 to excludenum do stclash[GsubXref[exclude[i]]]:=-1;
 for i:=1 to GroupSubs[0] do
   if (GroupSubCount[i]=0) or (GroupSubCount[i]>GetClassMax(GroupSubs[i]))
      then stclash[i]:=-1;
 for p:=1 to XML_DISPLAY.blocknum do
   for j:=1 to XML_DISPLAY.blocklevel do
    begin
     a:=Sheet[p,j];
     if a>0 then stclash[GsubXref[a]]:=-1;
    end;
 leftout:=0;     {leftout = exclude}
 for i:=1 to GroupSubs[0] do
   if stclash[i]=-1 then inc(leftout);
 for i:=1 to GroupSubs[0] do
  begin
   big:=0; pos:=0;
   for j:=1 to GroupSubs[0] do
     if stclash[j]>=big then
       begin
        big:=stclash[j];
        pos:=j;
       end;
   order[i]:=pos;
   stclash[pos]:=-1;
  end;
 s:=GroupSubs[0]-leftout;
 p:=Lblock;
 if s>0 then
  begin
   for i:=1 to s do
    begin
     putin;
     if got then
      begin
       stclash[i]:=0;
       inc(p);
       if p>Hblock then p:=random(Hblock+1-Lblock)+Lblock;
      end; {got}
    end; {i}
   for i:=1 to s do
    if stclash[i]<>0 then least;
   for i:=1 to s do
    if stclash[i]<>0 then inc(fullblocks);
   if fullblocks>0 then
    begin
     msg:=inttostr(fullblocks)+ ' subjects not allocated.'
          +endline+'Blocks are full.';
     messagedlg(msg,mtError,[mbOK],0);
    end;
   settop;
   UpdateBlockWindow;
   SaveBlockFlag:=True;
   BlockLoad:=3;
  end; {s>0}
end;


procedure ClearBlocks;
begin
 Blockwin.ClearBlocks1Click(Createdlg);
end;

procedure shuffle;
var
 clashmin,sub1:  integer;
 b1,l1,b2,l2,b3,l3:        integer;
 swapdone,clash2:   bool;

 procedure keepswap;
 var
  a1,i:  integer;
 begin
  clashmin:=BlockClashes[0];
  shuffleflag:=true; swapdone:=true; shuffledone:=true;
  a1:=Sheet[b1,0];
  if Sheet[b1,l1]=0 then
    if a1>l1 then
      begin
       for i:=l1+1 to a1 do
        swapint(Sheet[b1,i],Sheet[b1,i-1]);
       Sheet[b1,0]:=a1-1;
      end;
  a1:=Sheet[b2,0];
  if Sheet[b2,l2]>0 then if l2>a1 then Sheet[b2,0]:=l2;
  if l2>XML_DISPLAY.blocklevel then
      XML_DISPLAY.blocklevel:=l2;
  CalculateBlockClashes; clashmin:=BlockClashes[0];
  UpdateBlockWindow;
  if Iflag then begin
   balance;
   inc(I2start,10); if I2start>=groupnum then I2start:=1;
   I2end:=I2start+10; if I2end>groupnum then I2end:=groupnum;
   CreateDlg.label5.caption:='Shuffling subjects..';
   CreateDlg.label5.refresh;
   CreateDlg.label6.caption:='';
   CreateDlg.label6.refresh; ShowClashes;
  end;
 end;

 procedure keepswap2;
 var
  a1,i:  integer;
 begin
  clash2:=true;
  a1:=Sheet[b2,0];
  if Sheet[b2,l2]=0 then
    if a1>l2 then
      begin
       for i:=l2+1 to a1 do
        swapint(Sheet[b2,i],Sheet[b2,i-1]);
        Sheet[b2,0]:=a1-1;
      end;
  a1:=Sheet[b3,0];
  if Sheet[b3,l3]>0 then if l3>a1 then Sheet[b3,0]:=l3;
  keepswap;
 end;

begin
 CreateDlg.label5.caption:='Shuffling subjects..';
 CreateDlg.label5.refresh;
 CreateDlg.label6.caption:='';
 CreateDlg.label6.refresh; ShowClashes;
 CalculateBlockClashes;
 clashmin:=BlockClashes[0];
 shuffleflag:=false; swapdone:=false;
 for b1:=Lblock to Hblock do
  begin
   for l1:=1 to levelprint do
    begin
     if l1<=fix[b1] then continue;
     sub1:=Sheet[b1,l1];
     if sub1=0 then break;
     if (sub1<1) or (sub1>NumCodes[0]) then continue;
     CalculateBlockClashes;
     if BlockClashes[0]=0 then break;
     CreateDlg.label6.caption:=SubCode[Sheet[b1,l1]];
     CreateDlg.label6.refresh; ShowClashes;
     for b2:=Lblock to Hblock do
      begin
       if b2=b1 then continue;
       Application.ProcessMessages;
       if exitMake then exit;
       for l2:=1 to levelprint do
        begin
         if (l2<=fix[b2]) then continue;
         if ((l2>1) and (Sheet[b2,l2-1]=0)) then break;
         swapint(Sheet[b1,l1],Sheet[b2,l2]);
         if l2>Sheet[b2,0] then Sheet[b2,0]:=l2;
         CalculateBlockClashes;
         if quickshuffle and (BlockClashes[0]<clashmin) then
          begin
           KeepSwap;
           break;
          end;
         clash2:=false;
         if not(quickshuffle) then
          begin
           for b3:=Lblock to Hblock do
            begin
             if (b3=b2) or (b3=b1) then continue;
             for l3:=1 to levelprint do
              begin
               if (l3<=fix[b3]) or ((l3>1) and (Sheet[b3,l3-1]=0)) then continue;
               swapint(Sheet[b2,l2],Sheet[b3,l3]);
               if l3>Sheet[b3,0] then Sheet[b3,0]:=l3;
               CalculateBlockClashes;
               if BlockClashes[0]<clashmin then
                 begin
                  keepswap2;
                  break;
                 end
                else
                 begin
                  swapint (Sheet[b2,l2],Sheet[b3,l3]);
                  if Sheet[b3,l3]=0 then dec(Sheet[b3,0]);
                 end;
              end; {l3}
             if clash2 then break;
            end; {b3}
          end; {slow shuffle}
         if not(clash2) then
          begin
           swapint(Sheet[b1,l1],Sheet[b2,l2]);
           if Sheet[b2,l2]=0 then dec(Sheet[b2,0]);
          end;
        end; {l2}
       if swapdone then
        begin
         swapdone:=false;
         break;
        end;
      end; {b2}
     if BlockClashes[0]=0 then break;
    end; {l1}
   if BlockClashes[0]=0 then break;
  end; {b1}
end;  {shuffle}

procedure SlowShuffle;
begin
 quickshuffle:=false; shuffledone:=false;
 repeat
  shuffle;
 until not(shuffleflag);
 quickshuffle:=true;
 repeat
  shuffle;
 until not(shuffleflag);
 CreateDlg.label6.caption:=''; CreateDlg.label6.refresh;
 {only if needed}
 if shuffledone then
  begin
   UpdateBlockWindow;
   SaveBlockFlag:=True;
   BlockLoad:=3;
  end
 else
  CalculateBlockClashes;
end;



procedure getsplits(splitpos: integer);
var
  splitnum:  integer; {number of students in split subject}
  count,i:         integer;
  Sub2:            string;
  place:           integer;
  changeflag:      bool;
  fromblock,sublevel:        integer;
  lSubjectCode: string;
label
 labela;
begin
 changeflag:=false;
 splitnum:=GroupSubCount[splitpos];
 SpClassnum:=(splitnum+splitSuMaxSize-1) div splitSuMaxSize;
 if SpClassnum <> 0 then
   clsize := 1 +(splitnum-1) div SpClassnum
 else
   clsize := 1;
 if SpClassnum>20 then exit;
 count:=1;
 for i:=1 to SpClassnum do
  begin
   labela:
    Sub2:=SubCode[splitSu];
    lSubjectCode := Trim(Sub2);
    SetLength(Sub2,Length(Sub2)-1);
    Sub2:=Sub2+chr(64+count); inc(count);
    place:=checkGrSub(Sub2);
    if place=0 then
     begin
      newsub(Sub2,splitSu);
      changeflag:=true;
     end;
    if toomanysubs then break;
    // Add the split to class subject list
    if Cases21Flag then
      PendingClassSubjects.AddClassSubject(lSubjectCode, Sub2);
    place:=checkGrSub(Sub2);
    split[i]:=place;
    if GroupSubCount[place]>0 then goto labela;
    Blocktop[place]:=0;
  end; {for i}
 if toomanysubs then exit;
  if Cases21Flag then
  begin
    PendingClassSubjects.RemoveClassSubject(lSubjectCode);
  end;
 fromblock:=findblock(splitSu,sublevel);
 if fromblock>0 then blockchange(splitSu,0);
 XrefGroupSubs;
 place:=GsubXref[SplitSu];
 GroupSubCount[place]:=0;
 Blocktop[place]:=splitSu;
 if changeflag then CalculateClashmatrix;
end;

Procedure Split1(splitpos: integer);
begin
 splitSu:=splitpos; splitSuMaxSize:=GetClassMax(splitSu);
 getsplits(GsubXref[SplitSu]);
 if (SpClassnum>20) or toomanysubs then exit;
 CreateDlg.label6.caption:='Splitting '+SubCode[splitSu]+'...';
 CreateDlg.label6.refresh;
 splitLinks(SplitSu,SpClassnum,Split);
 horsplit(Splitsu,clsize,SpClassnum,split);
 CalculateClashmatrix; ShowClashes;
end;


procedure CheckSplit;
var
 i,place: integer;
 found,SplitNeeded:  bool;
begin
 CreateDlg.label5.Caption:='Splitting into different blocks';
 CreateDlg.label5.refresh;
 CreateDlg.label6.caption:='';
 CreateDlg.label6.refresh; ShowClashes;
 if numtries=1 then
  begin
   numcombine:=0;
   SplitNeeded:=false;
   for i:=1 to GroupSubs[0] do
    if GroupSubCount[i]>GetClassMax(GroupSubs[i]) then SplitNeeded:=true;
   if not(SplitNeeded) then exit;
   for place:=1 to GroupSubs[0] do
   begin
    found:=false;
    if excludenum>0 then for i:=1 to excludenum do
     if GroupSubs[place]=exclude[i] then found:=true;
    if not(found) and (GroupSubCount[place]>GetClassMax(GroupSubs[place])) then
    begin
     SplitSu:=GroupSubs[place];
     inc(numcombine);
     combine[numcombine]:=SplitSu;
    end;
   end; {place}

   if (numcombine>0) then
    for i:=1 TO numcombine do
    begin
     SplitSu:=combine[i];
     Split1(SplitSu);
    end;
  end
 else
  begin
   if (numcombine>0) then
    for i:=1 TO numcombine do
    begin
     SplitSu:=combine[i];
     Split1(SplitSu);
    end;
  end; {else}
 settop;
 UpdateStudWins;
 SaveStudFlag:=True; {or set during split}
 SaveBlockFlag:=True;
 BlockLoad:=3;
end;



procedure newchoice(Sol,st: integer);
var
 j,k,a,a1: integer;
begin
 k:=ClashOrder[Sol];
 for j:=1 to chmax do
  begin
   a:=BlClash[0,j]; a1:=BlClash[k,j];
   if a<>a1 then
    begin
     dec(GroupSubCount[GsubXref[a]]);
     inc(GroupSubCount[GsubXref[a1]]);
    end;
   XML_STUDENTS.Stud[st].Choices[j]:=BlClash[k,j];
   SaveStudFlag:=true;  saveBlockFlag:=true;
   StudYearFlag[XML_STUDENTS.Stud[st].tcYear]:=true;
  end;
 clashflag:=true;
end;


procedure balance;
var
 i2,i:  integer;
begin
 CountGroupSubs;
 clashflag:=false;
 CreateDlg.label5.Caption:='Balance students';
 CreateDlg.label5.refresh;
 CreateDlg.label6.caption:='';
 CreateDlg.label6.refresh; ShowClashes;
 for i2:=I2start to I2end do
  begin
   i:=StGroup[i2];
   CreateDlg.label6.caption:='Student '+inttostr(i)+'..   ';
   CreateDlg.label6.refresh; ShowClashes;
   getStclashes(i);
   if MyBlSolution>0 then newchoice(1,i);
   if not(finalbalance) then Application.ProcessMessages;
   if ExitMake then break;
  end; {i2}
 if clashflag then
  begin
   SaveStudFlag:=True;
   SaveBlockFlag:=True;
   BlockLoad:=3;
   CountGroupSubs;
   CalculateClashmatrix;
   UpdateStudWins;
  end;
end;

procedure RandomPut(Mput: integer);
var
 count,i,toblock: integer;
 stclash:  tpYearData;
begin
 CreateDlg.label5.Caption:='Allocating subjects..';
 CreateDlg.label5.refresh;
 CreateDlg.label6.caption:='';
 CreateDlg.label6.refresh; ShowClashes;
 fillchar(stclash,sizeof(stclash),chr(0));
 for i:=1 to GroupSubs[0] do stclash[i]:=0;
 if excludenum>0 then
   for i:=1 to excludenum do stclash[GsubXref[exclude[i]]]:=-1;
 for i:=1 to GroupSubs[0] do
  begin
   if (GroupSubCount[i]=0) or (Blocktop[i]=0) or (stclash[i]<>0)
       or ((Mput<>0) and (GroupSubCount[i]>GetClassMax(GroupSubs[i]))) then continue;
   count:=0;
   repeat
    toblock:=random(Hblock+1-Lblock)+Lblock;;
    inc(count)
   until (count>=100) or (Sheet[toblock,0]<levelprint);
   if count>=100 then continue;
   blockchange(GroupSubs[i],toblock);
   Application.ProcessMessages;
   if ExitMake then break;
  end; {i}
  settop;
  SaveBlockFlag:=True;
  BlockLoad:=3;
  UpdateStudWins;
end;

procedure Create1;
 begin
  DoCombine; if ExitMake then exit;
  DoAuto;  if ExitMake then exit;
  SlowShuffle; if ExitMake then exit;
  CheckSplit; if ExitMake then exit;
  Balance;
 end;

procedure Create2;
begin
 RandomPut(0); if ExitMake then exit;
 SlowShuffle; if ExitMake then exit;
 Balance;     if ExitMake then exit;
 SlowShuffle;
end;

procedure Create3;
begin
 RandomPut(0); if ExitMake then exit;
 Balance;     if ExitMake then exit;
 SlowShuffle; if ExitMake then exit;
 Balance;
end;

procedure Create4;
begin
 DoCombine; if ExitMake then exit;
 RandomPut(-1); if ExitMake then exit;
 SlowShuffle; if ExitMake then exit;
 CheckSplit; if ExitMake then exit;
 Balance;
end;

procedure Create5;
begin
 RandomPut(0); if ExitMake then exit;
 Iflag:=true; I2start:=1; I2end:=10;
 if I2end>groupnum then I2end:=groupnum;
 SlowShuffle; Iflag:=false; I2start:=1; I2end:=groupnum;
 if ExitMake then exit;
 balance;
end;

procedure MakeBlocks;
var
 i:     integer;
 clashnum,checknum:        array[0..100] of longint;
 numsolution, Itries, BestTry: integer;
 BestClashes:  longint;
 Bestfile:  string;
 ni:  integer;

 procedure SaveMake;
 var
  checkDig,MaxClash: longint;
  b,a,i,Dosave: integer;
  unique: bool;
 begin
  countsubsinblock;
  if subsinblock=0 then exit;
  CalculateBlockClashes;
  checkDig:=0;
  for b:=1 to XML_DISPLAY.blocknum do begin
   a:=Sheet[b,0];
   if a>0 then for i:=1 to a do CheckDig:=CheckDig+(b*Sheet[b,i]);
  end;
  Dosave:=0;
  if numsolution>0 then
   begin
    unique:=true;
    for i:=1 to numsolution do
     if (checknum[i]=checkDig) and (clashnum[i]=BlockClashes[0]) then unique:=false;
    if unique then begin
     maxclash:=0;
     for i:=1 to XML_DISPLAY.BLsolution do
      if clashnum[i]>maxclash then begin
       maxclash:=clashnum[i]; dosave:=i;
      end;
     if BlockClashes[0]>maxclash then Dosave:=0;
     if numsolution<XML_DISPLAY.BLsolution then begin
      inc(numsolution); dosave:=numsolution;
     end;
    end; {if unique}
   end
  else
   begin
    numsolution:=1; Dosave:=1;
   end;
  if Dosave=0 then exit;
  blockfile:=BLfile+inttostr(Dosave);
  if BlockClashes[0]<BestClashes then begin
   BestClashes:=BlockClashes[0]; BestTry:=NumTries;
   BestFile:=blockfile;
  end;
  CreateDlg.label5.Caption:='Saving blocks';
  CreateDlg.label5.refresh;
  CreateDlg.label6.Caption:='Solution '+inttostr(Dosave);
  CreateDlg.label6.refresh; ShowClashes;
  SaveBlock;
 end;


begin
 if DoingCreate then begin
  ExitMake:=true;
  exit;
 end;
 with CreateDlg do begin
  label9.visible:=true; label10.visible:=true;
  label15.visible:=true;
  label11.visible:=true;
  label7.visible:=true; label8.visible:=true;
  label12.Caption:='';  label14.Caption:='';
  label16.Caption:='';
  CreateBtn.Caption:='Halt Create';
  CreateBtn.refresh;
 end;
 BestClashes:=2000000; BestTry:=0; BestFile:='';
 DoingCreate:=true;
 for i:=1 to XML_DISPLAY.BLsolution do clashnum[i]:=0;
 numsolution:=0; numcombine:=0; ExitMake:=false; finalbalance:=false;
 for ni:=1 to XML_DISPLAY.BLtries do
 begin
  numtries:=ni;     //for loop var needs to be local
  CreateDlg.label13.Caption:=inttostr(numtries);
  if BestTry>0 then
  begin
   CreateDlg.label12.Caption:=inttostr(BestTry);
   CreateDlg.label14.Caption:=inttostr(BestClashes);
   CreateDlg.label16.Caption:=BestFile;
  end;
  CreateDlg.refresh;
  Iflag:=false; I2start:=1; I2end:=groupnum;
  Itries:=numtries mod 5;
  ClearBlocks;

  case Itries of
   0: Create5;
   1: Create1;
   2: Create2;
   3: Create3;
   4: Create4;
  end;
  if ExitMake then break else SaveMake;
 end; {numtries}
 DoingCreate:=false;
 CreateDlg.CreateBtn.Caption:='Create Blocks';
 CreateDlg.CreateBtn.refresh;
 CreateDlg.label7.visible:=false; CreateDlg.label8.visible:=false;
 CreateDlg.label15.visible:=false; CreateDlg.label13.Caption:='';
 if numsolution>0 then
  begin
   blockfile:=bestfile;
   Blockwin.LoadBlock;
   finalbalance:=true;
   balance;
   CreateDlg.label5.Caption:='Solutions found: '+inttostr(numsolution);
   CreateDlg.label6.Caption:='File '+blockfile+' loaded';
   SaveBlock;
  end
 else
  begin
   CreateDlg.label5.Caption:='Solution halted';
   CreateDlg.label6.Caption:='';
  end;
end;

procedure TCreateDlg.CreateBtnClick(Sender: TObject);
var
 a:     smallint;
 msg: string;
begin
 if InvalidEntry(XML_DISPLAY.BLsolution,1,100,'solutions set',edit1) then exit;
 msg:='';
 if XML_DISPLAY.BLtries<1 then msg:='No tries set';
 if XML_DISPLAY.BLtries<XML_DISPLAY.BLsolution then msg:='Tries are less than Solutions';
 if msg>'' then begin
  ShowMsg(msg,Edit2);
  exit;
 end;
 if BLfile='' then
  begin
   ShowMsg('File name is needed',edit4);
   exit;
  end;
 if InvalidEntry(a,1,nmbrStudents,'maximum class size set',edit3) then exit;
 SetDefaultClassSize(a);
 MakeBlocks;
 //SolveClashByClassChange;
end;

procedure TCreateDlg.SolveClashByClassChange;
//This routine can be used to eliminate clashes if changing Roll Class makes
//a difference, however it slows down block creation
var
  i: Integer;
  j: Integer;
  lTempList: TStringList;
  lCurrClass: Integer;
begin
  lTempList := TStringList.Create;
  try
    lTempList.Sorted := True;
    lTempList.Duplicates := dupIgnore;
    for i := 1 to XML_STUDENTS.NumStud do
    begin
      lTempList.Add(IntToStr(XML_STUDENTS.Stud[i].TcYear) + '=' + IntToStr(XML_STUDENTS.Stud[i].tcClass));
    end;
    for i := 1 to XML_STUDENTS.NumStud do
    begin
      if HasStudentClash(i) then
      begin
        for j := 0 to lTempList.Count - 1 do
        begin
          lCurrClass := XML_STUDENTS.Stud[i].TcClass;
          if (lTempList.Names[j] = IntToStr(XML_STUDENTS.Stud[i].TcYear)) and (lTempList.Values[lTempList.Names[j]] <> IntToStr(XML_STUDENTS.Stud[i].tcClass)) then
          begin
            XML_STUDENTS.Stud[i].TcClass := StrToInt(Trim(lTempList.Values[lTempList.Names[j]]));
            MakeBlocks;
            if not HasStudentClash(i) then
              Break;
          end;
        end;
      end;
    end;
  finally
    FreeAndNil(lTempList);
  end;
end;


end.

