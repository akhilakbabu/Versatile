unit Autoaloc;

interface

uses SysUtils,WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, Dialogs, ExtCtrls,TimeChartGlobals, GlobalToTcAndTcextra, XML.DISPLAY;
type
  TAutoAllocDlg = class(TForm)
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Finish: TBitBtn;
    NewBtn1: TBitBtn;
    ClearBtn: TBitBtn;
    ShuffleBtn: TBitBtn;
    AllocateBtn: TBitBtn;
    HelpBtn: TBitBtn;
    CheckBox1: TCheckBox;
    procedure FormActivate(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
    procedure AllocateBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure NewBtn1Click(Sender: TObject);
    procedure ShuffleBtnClick(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    procedure Restore;
  end;

var
  AutoAllocDlg: TAutoAllocDlg;

implementation

{$R *.DFM}
uses tcommon,DlgCommon,stcommon, block1,subyr;
var
 quickshuffle,shuffleflag,shuffledone,exitshuffle,doingshuffle: bool;

procedure TAutoAllocDlg.Restore;
begin
 label9.caption:='';
 label10.caption:='';
 label8.caption:=inttostr(BlockClashes[0]);
 countSubsInBlock;
 exitshuffle:=false;
 doingshuffle:=false;
 ShuffleBtn.enabled:=((subsinblock>Fixcount) and (BlockClashes[0]>0));
 Clearbtn.enabled:=(subsinblock>Fixcount)
end;



procedure TAutoAllocDlg.FormActivate(Sender: TObject);
begin
 Lblock:=1; Hblock:=XML_DISPLAY.blocknum;
 Edit1.Text:=inttostr(Lblock);
 Edit2.Text:=inttostr(Hblock);
 Label2.Caption:=inttostr(Fixcount);
 label7.caption:=inttostr(excludenum);
 checkbox1.Checked:=FastShuffleFlg;
 ShuffleBtn.tag:=0;
 Edit1.SetFocus;
 Restore;
end;

procedure TAutoAllocDlg.CheckBox1Click(Sender: TObject);
begin
 FastShuffleFlg:=checkbox1.Checked;
end;

procedure TAutoAllocDlg.ClearBtnClick(Sender: TObject);
begin
  if doingshuffle then exit; {shuffle in operation}
  Blockwin.ClearBlocks1Click(Self);
  restore;
end;

procedure TAutoAllocDlg.AllocateBtnClick(Sender: TObject);
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
   maxclash:=10000; per:=p; minlev:=0; minp:=0;
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
     StClash[i]:=0;
    end;
  end;


begin
 fullblocks:=0;
 fillchar(StClash,sizeof(StClash),chr(0));
 fillchar(order,sizeof(order),chr(0));
 if not(blockrange(edit1,edit2)) then exit;
 label9.caption:='Automatic allocation..';
 for i:=1 to GroupSubs[0] do
  begin
   StClash[i]:=0;
   for j:=1 to GroupSubs[0] do
    if i<>j then inc(StClash[i],FNcm(i,j));
  end;
 if excludenum>0 then
   for i:=1 to excludenum do StClash[GsubXref[exclude[i]]]:=-1;
 for i:=1 to GroupSubs[0] do
   if GroupSubCount[i]=0 then StClash[i]:=-1;
 for p:=1 to XML_DISPLAY.blocknum do
   for j:=1 to XML_DISPLAY.blocklevel do
    begin
     a:=Sheet[p,j];
     if a>0 then StClash[GsubXref[a]]:=-1;
    end;
 leftout:=0;     {leftout was called exclude}
 for i:=1 to GroupSubs[0] do
   if StClash[i]=-1 then inc(leftout);
 for i:=1 to GroupSubs[0] do
  begin
   big:=0; pos:=0;
   for j:=1 to GroupSubs[0] do
     if StClash[j]>=big then
       begin
        big:=StClash[j];
        pos:=j;
       end;
   order[i]:=pos;
   StClash[pos]:=-1;
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
       StClash[i]:=0;
       inc(p);
       if p>Hblock then p:=random(Hblock+1-Lblock)+Lblock;
      end; {got}
    end; {i}
   for i:=1 to s do
    if StClash[i]<>0 then least;
   for i:=1 to s do
    if StClash[i]<>0 then inc(fullblocks);
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
 restore;
end;

procedure TAutoAllocDlg.FormCreate(Sender: TObject);
begin
 topcentre(self);
end;

procedure shuffle;
var
 clashmin,sub1,sub2,sub3:  integer;
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
  AutoAllocDlg.label8.caption:=inttostr(BlockClashes[0])+'     ';
  AutoAllocDlg.label8.refresh;
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
 AutoAllocDlg.label9.caption:='Shuffling subjects..';
 AutoAllocDlg.label9.refresh;
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
     if (sub1<1) or (sub1>NumCodes[0]) or
            (GroupSubCount[GsubXref[sub1]]=0) then continue;
     CalculateBlockClashes;
     if BlockClashes[0]=0 then break;
     AutoAllocDlg.label10.caption:=subcode[Sheet[b1,l1]];
     AutoAllocDlg.label10.refresh;
     for b2:=Lblock to Hblock do
      begin
       if b2=b1 then continue;
       Application.ProcessMessages;
       if exitshuffle then exit;
       for l2:=1 to levelprint do
        begin
         if (l2<=fix[b2]) then continue;
         sub2:=Sheet[b2,l2];
         if (sub2>0) and (GroupSubCount[GsubXref[sub2]]=0) then continue;
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
               sub3:=Sheet[b3,l3];
               if (sub3>0) and (GroupSubCount[GsubXref[sub3]]=0) then continue;
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

procedure TAutoAllocDlg.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
 allowNumericInputOnly(key);
end;

procedure TAutoAllocDlg.NewBtn1Click(Sender: TObject);
begin
 if doingshuffle then exit; {shuffle in operation}
 countSubsInBlock;
 if (subsinblock>Fixcount) then Blockwin.ClearBlocks1Click(Self);
 AllocateBtnClick(self);
 countSubsInBlock;
 if ((subsinblock>Fixcount) and (BlockClashes[0]>0)) then ShuffleBtnClick(self);
 restore;
end;

procedure TAutoAllocDlg.ShuffleBtnClick(Sender: TObject);
begin
 if (ShuffleBtn.tag=0) and doingshuffle then exit; {other shuffle in operation}
 if ShuffleBtn.tag=1 then
  begin
   exitshuffle:=true;
   exit;
  end;
 if not(blockrange(edit1,edit2)) then exit;
 quickshuffle:=false; shuffledone:=false;
 doingshuffle:=true;
 ShuffleBtn.caption:='Halt Shuffle';
 ShuffleBtn.refresh;
 ShuffleBtn.tag:=1;
 if not(FastShuffleFlg) then
  repeat
   shuffle;
  until not(shuffleflag);
 quickshuffle:=true;
 repeat
  shuffle;
 until not(shuffleflag);
 {only if needed}
 if shuffledone then
  begin
   UpdateBlockWindow;
   SaveBlockFlag:=True;
   BlockLoad:=3;
  end
 else
  CalculateBlockClashes;
 restore;
 ShuffleBtn.tag:=0;
 ShuffleBtn.caption:='Shuffle';
end;

end.
