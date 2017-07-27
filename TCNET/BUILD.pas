unit Build;

interface

uses SysUtils, WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, TabNotBk, Dialogs, ComCtrls, TimeChartGlobals, GlobalToTcAndTcextra,
  XML.DISPLAY, XML.TEACHERS;

type
  TBuildDlg = class(TForm)
    HelpBtn: TBitBtn;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label1: TLabel;
    Label5: TLabel;
    Edit2: TEdit;
    Finish: TBitBtn;
    CopyBtn: TBitBtn;
    ClearBtn: TBitBtn;
    ComboBox1: TComboBox;
    Label6: TLabel;
    Label7: TLabel;
    ComboBox2: TComboBox;
    Style1: TTabbedNotebook;
    Label20: TLabel;
    Label17: TLabel;
    AutoBtn: TButton;
    OverWriteBox: TCheckBox;
    Label11: TLabel;
    Label12: TLabel;
    ComboBox3: TComboBox;
    Edit6: TEdit;
    MatchBtn: TButton;
    BuildScope: TRadioGroup;
    Label15: TLabel;
    Label16: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Panel1: TPanel;
    Image1: TImage;
    Label21: TLabel;
    Label22: TLabel;
    ResetBtn: TBitBtn;
    WarnBox: TCheckBox;
    LabelMsg1: TLabel;
    Label2: TLabel;
    ComboBox4: TComboBox;
    Label8: TLabel;
    ComboBox5: TComboBox;
    Label9: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BuildScopeClick(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure OverWriteBoxClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure AutoBtnClick(Sender: TObject);
    procedure CopyBtnClick(Sender: TObject);
    procedure MatchBtnClick(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure Edit6Change(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure WarnBoxClick(Sender: TObject);
    procedure ComboBox5Change(Sender: TObject);
    procedure ComboBox4Change(Sender: TObject);
    procedure RefreshHint(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
  private
    procedure Restore(resetMult:boolean);
    procedure ShowCopy;
    procedure DoSelect(d,p: integer);
    procedure SetButtons;
    procedure SetAutoBtn;
    procedure SetMatchBtn;
    procedure DrawTime(d,p: integer;TsColour: Tcolor);
    procedure GetTargetTimes;
    procedure SetMultiples;
    procedure CopyBlock;
    procedure Checkunit;
  end;

var
  BuildDlg: TBuildDlg;


implementation

{$R *.DFM}
uses tcommon,DlgCommon,ttable,tcommon2,TTundo, AllTargetTimes;

const
 bsCell=0;  {build scope cell}
 bsYrBlock=1;
 bsBlock=2;

var
 Bbox,Nblock,l1,l2,byr1,byr2:  integer;
 bl1,bl2: array[0..nmbrYears] of integer;
 tegroup, sugroup, rogroup:  array of smallint;
 TeGrpShare,RoGrpShare: array of boolean;
 ptab:    tpPeriodData;
 Aorder:  array[0..nmbrDays] of smallint;
 Adone:   array[0..nmbrDays] of bool;
 Ntegroup,Nsugroup,Nrogroup:  integer;
 CanCopy,firstStart,AddDouble: boolean;
 bb,by,bl:  integer;
 myMult,myTarget: integer;
 Nentries,Navail,Nselect,NentrySelect: integer;
 CheckPer:       tpFclash;
 AutoPer:   tpFclash;
 CopyRect:   TRect;
 Mblock,Myear:  integer;
 fb,fy,fl:       integer;
 td,tp,ty,tl:       integer;
 Bflag,Fflag:    bool;
 CopyOp:               integer;
 Optype:               String;
 CopyStop:             bool;
 abSingle,abDouble,abTriple    : smallint;


function HasTarget(d,p: integer):boolean;
begin
 result:=(wstSingle[myTarget,d] and (1 shl p))<>0;
end;

function HasDouble(d,p: integer):boolean;
begin
 result:=(wstDouble[myTarget,d] and (1 shl p))<>0;
end;

function HasTriple(d,p: integer):boolean;
begin
 result:=(wstTriple[myTarget,d] and (1 shl p))<>0;
end;

procedure TBuildDlg.GetTargetTimes;
var
 d,p,count:  integer;
begin
 count:=0;
 for d:=0 to days-1 do
  for p:=0 to Tlimit[d]-1 do
   if HasTarget(d,p) then inc(count);
 label9.Caption:='Target times '+inttostr(count);
end;

procedure TBuildDlg.SetAutoBtn;
begin
 AutoBtn.Enabled:=(CanCopy and (Navail>0) and ((abSingle+abDouble+abTriple)>0))
end;

procedure TBuildDlg.SetMatchBtn;
begin
 MatchBtn.Enabled:=(CanCopy and (Navail>0) and (Myear>0) and (Mblock>0) and
    (Mblock<=nmbrBlocks) and (Myear<>by));
end;

procedure TBuildDlg.SetButtons;
begin
 if firststart then exit;
 CopyBtn.Enabled:=(CanCopy and (Nselect>0));
 ResetBtn.Enabled:=(CanCopy and ((Nselect>0) or (NentrySelect>0)));
 ClearBtn.Enabled:=(CanCopy and (NentrySelect>0));
 SetAutoBtn;
 SetMatchBtn;
end;

procedure TBuildDlg.DrawTime(d,p: integer;TsColour: Tcolor);
begin
 image1.canvas.font.color:=TsColour;
 if TsColour<>clBlack then
      image1.canvas.font.style:=(image1.canvas.font.style+[fsUnderline]);
 image1.canvas.textout(ptab[p],2+15*d,tsCode[d,p]);
 image1.canvas.font.style:=(image1.canvas.font.style-[fsUnderline]);
end;

procedure GetYearLevels(myY: integer);
begin
 Case Bbox of
  bsCell: begin l1:=bl; l2:=bl; end;
  bsYrBlock,bsBlock:
   begin l1:=bl1[myY]; l2:=bl2[myY]; end;
 end;
end;

procedure TBuildDlg.ShowCopy;
var
 d,p,y,y2,l:  integer;
 empty,found,HasShare,gotSub: bool;
 IntPoint:      tpIntPoint;
 allthere,te,ro,j:  smallint;
 s,i:  integer;
begin
 Nentries:=0; Navail:=0; Nselect:=0; NentrySelect:=0;
 image1.canvas.fillrect(CopyRect);
 if CanCopy=false then exit;
 for d:=0 to days-1 do
  for p:=0 to Tlimit[d]-1 do
   begin
    CheckPer[d,p]:=0;
    if not(HasTarget(d,p)) then continue;
    empty:=true;
    for y2:=byr2 downto byr1 do
     begin
      GetYearLevels(y2);
      for l:=l1 to l2 do
       if FNT(d,p,y2,l,0)^>0 then
        begin
         empty:=false;
         break;
        end;
     end;
    allthere:=0;
    if Nsugroup>0 then
     for s:=1 to Nsugroup do
      begin
       gotSub:=false;
       for y2:=byr2 downto byr1 do
        begin
         GetYearLevels(y2);
         for l:=l1 to l2 do
          if FNT(d,p,y2,l,0)^=Sugroup[s] then
           begin
            inc(allthere); gotSub:=true; break;
           end;
         if gotSub then break;
        end;
      end;
    found:=false;
    for y:=0 to years_minus_1 do
     begin
      GetYearLevels(y);
      for l:=1 to level[y] do
      begin
       if ((Bbox=bsBlock) or (y=by)) and (l>=l1) and (l<=l2) then continue;
       Intpoint:=FNT(d,p,y,l,2); te:=Intpoint^;
       inc(Intpoint); ro:=Intpoint^;
       inc(Intpoint); j:=intpoint^; HasShare:=((j and 2)=2);
       if (ro=0) and (te=0) then continue;
       if (te>0) and (Ntegroup>0) then
        for i:=1 to Ntegroup do
         if te=tegroup[i] then if not(TeGrpShare[i] and HasShare) then
          begin
           found:=true; break;
          end;
       if (ro>0) and (Nrogroup>0) and not(found) then
        for i:=1 to Nrogroup do
         if ro=Rogroup[i] then if not(RoGrpShare[i] and HasShare) then
          begin
           found:=true; break;
          end;
      end; {l}
      if found then break;
     end; {y}
    if (allthere=Nsugroup) and (Nsugroup>0) then CheckPer[d,p]:=1;
    if (empty or XML_DISPLAY.abOverwrite) and not(found) and (CheckPer[d,p]<>1) then
     begin
      CheckPer[d,p]:=2;
      inc(Navail);
      DrawTime(d,p,clBlack);
     end;
    if (allthere=Nsugroup) and (Nsugroup>0) then
     begin
      CheckPer[d,p]:=1;
      inc(Nentries);
      DrawTime(d,p,clRed);
     end;
   end; {p}
end;


procedure CalcBuildLevels;
var
 IntPoint:      tpIntPoint;
 y,l:             integer;
 su,te,ro:      integer;
begin
 for y:=0 to years_minus_1 do
  begin
   bl1[y]:=0; bl2[y]:=0;
   for l:=1 to level[y] do
    begin
     Intpoint:=FNws(bb,y,l,0);
     su:=Intpoint^;
     inc(Intpoint); te:=Intpoint^;
     inc(Intpoint); ro:=Intpoint^;
     if (su>0) or (te>0) or (ro>0) then
      begin
       if bl1[y]=0 then bl1[y]:=l;
       bl2[y]:=l;
      end;
    end; {for l}
  end; {for y}
 byr1:=by; byr2:=by; {one year}
 if Bbox=bsBlock then
  begin
   byr1:=0; byr2:=years_minus_1; {all years}
  end;
end;

procedure TBuildDlg.SetMultiples;
begin
 GetMultIndex(myMult,Combobox4);
 abSingle:=wsOne[myMult];
 abDouble:=wsTwo[myMult];
 abTriple:=wsThree[myMult];
end;


function ValidPos: boolean;
begin
 result:=true;
 if (bb<1) or (bb>wsBlocks) then result:=false;
 if bBox=0 then if (bl<1) or (bl>level[by]) then result:=false;
end;


procedure TBuildDlg.Restore(resetMult:boolean);
var
  IntPoint: tpIntPoint;
  s: string;
  l,i,myY: Integer;
  su,te,ro,newMult: smallint;
  ShareFlg: boolean;
  lLongestLength: Integer;
begin
 lLongestLength := GetLongestLength;
 Ntegroup:=0; Nsugroup:=0; Nrogroup:=0; newMult:=-1;
 SetLength(TeGrpShare,2);  SetLength(RoGrpShare,2);
 l1:=0; l2:=0; Cancopy:=False; Nblock:=0;
 if ValidPos then
  begin      { ^- check on valid position}
   CalcBuildLevels;
   for myY:=byr2 downto byr1 do
    begin
     GetYearLevels(myY);
     if (l1>0) then
      for l:=l1 to l2 do
       begin
        Intpoint:=FNws(bb,myY,l,0);
        su:=Intpoint^;
        inc(Intpoint); te:=Intpoint^;
        inc(Intpoint); ro:=Intpoint^;
        inc(Intpoint); i:=Intpoint^; ShareFlg:=((i and 2)=2);
        if (su>0) and (su<=LabelBase) then
         begin
          inc(Nsugroup); SetLength(Sugroup,Nsugroup+2);
          Sugroup[Nsugroup]:=su;
          if (newMult=-1) and ResetMult then
           begin
            inc(Intpoint); newMult:=Intpoint^;
            if newMult<>myMult then Combobox4.ItemIndex:=wsOrder[newMult];
           end;
         end;
        if (te>0) then
         begin
          inc(Ntegroup); SetLength(tegroup,Ntegroup+2);
          tegroup[Ntegroup]:=te;
          SetLength(TeGrpShare,Ntegroup+2);
         end;
        if (ro>0) then
         begin
          inc(Nrogroup); SetLength(Rogroup,Nrogroup+2);
          Rogroup[Nrogroup]:=ro;  SetLength(RoGrpShare,Nrogroup+2);
         end;
        TeGrpShare[Ntegroup]:=ShareFlg and (te>0);
        RoGrpShare[Nrogroup]:=ShareFlg and (ro>0);
        i:=FNgetWSblockNumber(bb,by,l);
        if Nblock=0 then Nblock:=i;
       end; {for l}
   end; {for myY}
  end; {if valid pos}
 Combobox2.ItemIndex := Combobox2.Items.IndexOf(IntToStr(bb));
 Combobox1.ItemIndex := Combobox1.Items.IndexOf(yearname[by]);
 if (bl>0) and (bl<=level[by]) then edit2.text:=inttostr(bl);
 s:='';
 if (Nsugroup=0) and (Ntegroup=0) and (Nrogroup=0) then
   s:='No codes at this position' else CanCopy:=True;
 if Nsugroup>0 then
  begin
   for i:=1 to Nsugroup do
    s := s + Trim(subcode[Sugroup[i]]) + ' ' + GetSpacesToAlign(Trim(subcode[Sugroup[i]]), lLongestLength);
   end;
 label5.Caption:=s; s:='';
 if Ntegroup>0 then
  for i:=1 to Ntegroup do
    s := s + Trim(XML_TEACHERS.tecode[tegroup[i],0]) + ' ' + GetSpacesToAlign(Trim(XML_TEACHERS.tecode[tegroup[i],0]), lLongestLength);;
 label6.Caption:=s;
 if (bl<1) or (bl>level[by]) then
  begin
   label6.Caption:='Enter level in range 1-'+inttostr(level[by]);
   edit2.Setfocus; Edit2.SelectAll;
  end;
 s:='';
 if Nrogroup>0 then
  for i:=1 to Nrogroup do
    s := s + Trim(XML_TEACHERS.tecode[Rogroup[i],1]) + ' ' + GetSpacesToAlign(Trim(XML_TEACHERS.tecode[RoGroup[i],1]), lLongestLength);;
 label7.Caption:=s;
 if Nblock>0 then
  begin
   s:=inttostr(Nblock);
   Mblock:=Nblock;
  end;
 Edit6.text:=s;
 showCopy;
 label16.Caption:=inttostr(Nentries);
 label18.Caption:=inttostr(Navail);
 label20.Caption:=inttostr(Nselect);
 label22.Caption:=inttostr(NentrySelect);
 SetButtons;
end;



procedure TBuildDlg.FormCreate(Sender: TObject);
var
 s:      string;
begin
 firstStart:=true;
 if wsBox=bxYrTime then BuildScope.ItemIndex:=1
  else if wsBox=bxTime then BuildScope.ItemIndex:=2
   else BuildScope.ItemIndex:=0;
 Bbox:=BuildScope.ItemIndex;

 WarnBox.checked:=Warn;
 label3.caption:='&'+Yeartitle;
 label5.font.color:=FontColorPair[cpSub,1];
 label6.font.color:=FontColorPair[cpTeach,1];
 label7.font.color:=FontColorPair[cpRoom,1];
 FillComboBlocks(Combobox2);
 FillComboMult(ComboBox4);
 combobox4.ItemIndex:=0;
 FillComboTarget(ComboBox5);
 SetPtabs(ptab,image1.Canvas);
 copyrect.left:=ptab[0]-1; copyrect.right:=image1.width;
 copyrect.top:=0; copyrect.bottom:=3+15*days;
 FillComboYears(false,ComboBox1);
 FillComboYears(false,ComboBox3);
 Combobox1.Hint:='Select '+Yeartitle+' of timetable';
 Combobox3.Hint:='Select '+Yeartitle+' to match blocks to';
 overWritebox.checked:=XML_DISPLAY.abOverwrite;
 by:=wsy; bl:=wsl; bb:=wsb;   AddDouble:=false;
 s:=''; Myear:=-1;   abSingle:=1;   myMult:=-1;
 if by<years_minus_1 then
  begin
   s:=yearname[years_minus_1];
   Myear:=years_minus_1;
  end;
 combobox3.ItemIndex := combobox3.Items.IndexOf(s);
 Edit6.text:='';   LabelMsg1.Caption:='';
 fillchar(CheckPer,sizeof(CheckPer),chr(0));
 fillchar(AutoPer,sizeof(AutoPer),chr(0));
 fillchar(Sugroup,sizeof(Sugroup),chr(0));
 fillchar(tegroup,sizeof(tegroup),chr(0));
 fillchar(Rogroup,sizeof(Rogroup),chr(0));
end;

procedure TBuildDlg.FormDblClick(Sender: TObject);
//var
  //lFrmShowAllTargertTimes: TFrmShowAllTargertTimes;
begin
  {
  lFrmShowAllTargertTimes := TFrmShowAllTargertTimes.Create(Application);
  try
    lFrmShowAllTargertTimes.ShowModal;
  finally
    FreeAndNil(lFrmShowAllTargertTimes);
  end;}
end;

procedure TBuildDlg.FormActivate(Sender: TObject);
begin
 firstStart:=true;
 myTarget:=by; ComboBox5.ItemIndex:=by+1;
 GetTargetTimes;
 Restore(true);
 SetMultiples;
 firstStart:=false;
 SetButtons;
end;

procedure TBuildDlg.BuildScopeClick(Sender: TObject);
var
 oldScope,newTarget: integer;
begin
 if FirstStart then exit;
 oldScope:=Bbox;  newTarget:=myTarget;
 if Bbox<>BuildScope.ItemIndex then
  begin
   Bbox:=BuildScope.ItemIndex;
   if Bbox=bsBlock then newTarget:=-1;
   if oldScope=bsBlock then newTarget:=by;
   Restore(false);
  end;
 if newTarget<>myTarget then Combobox5.ItemIndex:=newTarget+1;
end;

procedure TBuildDlg.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
 allowNumericInputOnly(key);
end;

procedure TBuildDlg.OverWriteBoxClick(Sender: TObject);
begin
 if FirstStart then exit;
 XML_DISPLAY.abOverwrite:=OverWritebox.checked;
 restore(false);
end;

procedure TBuildDlg.ComboBox1Change(Sender: TObject);
var
 found,oldyear:  integer;
begin
 if FirstStart then exit;
 oldyear:=by;
 found:=findYear(ComboBox1.text);
 if found>=0 then by:=found;
 if oldyear<>by then
  begin
   if Bbox<>bsBlock then Combobox5.ItemIndex:=by+1;
   restore(true);
  end;
end;

procedure TBuildDlg.Edit2Change(Sender: TObject);
var
 oldlevel:  integer;
begin
 if FirstStart then exit;
 oldlevel:=bl;
 bl:=IntFromEdit(edit2);
 if (oldlevel<>bl) and (Bbox=bsCell) then restore(true);
end;

procedure TBuildDlg.ComboBox2Change(Sender: TObject);
var
 posb,oldBlock:  integer;
begin
 oldBlock:=bb;
 if FirstStart then exit;
 posb:=findWSblock(ComboBox2.text,LabelMsg1);
 if posb>0 then bb:=posb;
 if bb<>oldBlock then restore(true);
end;

procedure TBuildDlg.DoSelect(d,p: integer);
var
 i:      integer;
 Srect:  Trect;
begin
 if CanCopy=false then exit;
 Srect.left:=ptab[p]-1; Srect.right:= ptab[p+1]-2;
 Srect.top:= 3+15*d; Srect.bottom:=Srect.top+15;
 i:=CheckPer[d,p];
 if i=1 then DrawTime(d,p,clNavy);
 invertrect(image1.canvas.handle,Srect);
 if i=-1 then DrawTime(d,p,clRed);
 image1.repaint;
 case i of
   1: inc(NentrySelect);
  -1: dec(NentrySelect);
   2: inc(Nselect);
  -2: dec(Nselect);
 end;
 CheckPer[d,p]:=-i;
 label20.Caption:=inttostr(Nselect);
 label22.Caption:=inttostr(NentrySelect);
 SetButtons;
end;



procedure TBuildDlg.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
 d,p,i:  integer;
begin
 if (x<(ptab[0]-1)) or (x>ptab[periods]) or (y>(3+15*days)) then exit;
 d:= (y-3) div 15;
 p:=0;
 for i:=0 to periods-1 do
  if x>(ptab[i]-1) then p:=i;
 if p<0 then p:=0; if p>=periods then p:=periods-1;
 if d<0 then d:=0; if d>=days then d:=days-1;
 if CheckPer[d,p]=0 then exit; {not relevant}
 DoSelect(d,p);
end;


procedure SortAuto(count: integer; Atemp: array of integer);
var
 i,j,a,b,min,same,end1:  integer;
begin
 if count<2 then exit;
 for i:=1 to count-1 do
  begin
   min:=Atemp[Aorder[i]];
   for j:=i+1 to count do
    begin
     a:=Atemp[Aorder[j]];
     if a<min then
      begin
       min:=a;
       swapint(Aorder[i],Aorder[j]);
      end;
    end; {j}
  end; {i}
 for i:=1 to count-1 do
  begin
   same:=Atemp[Aorder[i]];
   end1:=i;
   for j:=i+1 to count do
    begin
     if Atemp[Aorder[j]]=same then end1:=j else break;
    end; {j}
   if end1>i then
    begin
     a:=i-1; b:=1+end1-i;
     for j:= i to end1 do swapint(Aorder[j],Aorder[1+a+random(b)]);
    end;
  end; {i}
end;

procedure AutoTriples(var Tneed: integer);
var
 d,p,tp,triplecount,count,i: integer;
 Atriple: array[0..nmbrdays] of integer;
 cycle,j1,a,apos,begin1,got:  integer;
label
 TripleCycle;
begin
 for d:=0 to days-1 do
  begin
   Atriple[d]:=0;
   triplecount:=0;
   for p:=0 to Tlimit[d]-1 do
    begin
     AutoPer[d,p]:=0;
     if CheckPer[d,p]=2 then
      begin
       if triplecount>0 then inc(triplecount)
        else if HasTriple(d,p) then triplecount:=1;
       if triplecount=3 then
        begin
         inc(Atriple[d]);
         AutoPer[d,p-2]:=3;
         triplecount:=0;
        end; {triplecount=3}
      end {CheckPer[d,p]=2}
     else
      triplecount:=0;
    end; {p}
  end; {d}
 count:=0;
 for d:=0 to days-1 do
  if Atriple[d]>0 then
   begin
    inc(count);
    Aorder[count]:=d;
   end;
 if count=0 then exit;
 SortAuto(count,Atriple);
 j1:=0; if abTriple<count then j1:=count-abTriple;
 for i:=1 to abTriple do
  begin
   cycle:=0;
  TripleCycle:
   inc(j1); inc(cycle);
   if j1>count then j1:=1;
   d:=Aorder[j1];
   if (cycle<=count) and (Atriple[d]=0) then goto TripleCycle;
   if cycle>count then break;
   a:=Atriple[d]; apos:=1; if a>1 then apos:=1+random(a);
   begin1:=-1; got:=0;
   for p:=0 to Tlimit[d]-1 do
    begin
     if AutoPer[d,p]=3 then
      begin
       inc(got);
       if (got=apos) then begin1:=p else continue;
      end;
    end; {p}
   if begin1=-1 then goto TripleCycle;
   for tp:=begin1 to begin1+2 do
    begin
     Builddlg.DoSelect(d,tp);
     AutoPer[d,tp]:=0;
    end;
   if Atriple[d]>0 then dec(Atriple[d]);
   if Tneed>0 then dec(Tneed);
   Adone[d]:=true;
  end; {i}
end;

procedure AutoDoubles(var Dneed: integer);
var
 d,p,tp,doublecount,count,i: integer;
 Adouble: array[0..nmbrdays] of integer;
 firstcycle,cycle,j1,a,apos,begin1,got:  integer;
label
 DoubleCycle;
begin
 for d:=0 to days-1 do
  begin
   Adouble[d]:=0;
   doublecount:=0;
   for p:=0 to Tlimit[d]-1 do
    begin
     AutoPer[d,p]:=0;
     if CheckPer[d,p]=2 then
      begin
       if doublecount>0 then
        begin
         inc(Adouble[d]);
         AutoPer[d,p-1]:=2;
         doublecount:=0;
        end
        else if HasDouble(d,p) then doublecount:=1;
      end {CheckPer[d,p]=2}
     else
      doublecount:=0;
    end; {p}
  end; {d}
 count:=0;
 for d:=0 to days-1 do
  if Adouble[d]>0 then
   begin
    inc(count);
    Aorder[count]:=d;
   end;
 if count=0 then exit;
 SortAuto(count,Adouble);
 firstcycle:=0;
 j1:=0; if abDouble<count then j1:=count-abDouble;
 for i:=1 to abDouble do
  begin
   cycle:=0;
  DoubleCycle:
   inc(j1); inc(firstcycle);
   if j1>count then j1:=1;
   if firstcycle>count then inc(cycle);
   d:=Aorder[j1];
   if (cycle<=count) and (Adouble[d]=0) then goto DoubleCycle;
   if cycle>count then break;
   a:=Adouble[d]; apos:=1; if a>1 then apos:=1+random(a);
   begin1:=-1; got:=0;
   for p:=0 to Tlimit[d]-1 do
    begin
     if AutoPer[d,p]=2 then
      begin
       inc(got);
       if (got=apos) then begin1:=p else continue;
      end;
    end; {p}
   if begin1=-1 then goto DoubleCycle;
   for tp:=begin1 to begin1+1 do
    begin
     Builddlg.DoSelect(d,tp);
     AutoPer[d,tp]:=0;
    end;
   if Adouble[d]>0 then dec(Adouble[d]);
   if Dneed>0 then dec(Dneed);
   Adone[d]:=true;
  end; {i}
end;

procedure AutoSingles(var Sneed: integer);
var
 d,p,count,i: integer;
 lastperiod:     bool;
 Asingle: array[0..nmbrdays] of integer;
 firstcycle,cycle,j1,a,apos,begin1,got:  integer;
label
 SingleCycle;
begin
 for d:=0 to days-1 do
  begin
   Asingle[d]:=0;
   for p:=0 to Tlimit[d]-1 do
    begin
     AutoPer[d,p]:=0;
     if CheckPer[d,p]=2 then
      begin
       inc(Asingle[d]);
       AutoPer[d,p]:=1;
      end
    end; {p}
  end; {d}
 count:=0;
 for d:=0 to days-1 do
  if Asingle[d]>0 then
   begin
    inc(count);
    Aorder[count]:=d;
   end;
 if count=0 then exit;
 SortAuto(count,Asingle);
 lastperiod:=false;
 firstcycle:=0;
 j1:=0; if abSingle<count then j1:=count-abSingle;
 for i:=1 to abSingle do
  begin
   cycle:=0;
  SingleCycle:
   inc(j1); inc(firstcycle);
   if j1>count then j1:=1;
   if firstcycle>count then inc(cycle);
   d:=Aorder[j1];
   if (cycle<=count) and (Asingle[d]=0) then goto SingleCycle;
   if (firstcycle<=count) and Adone[d] then goto SingleCycle;
   if cycle>count then break;
   a:=Asingle[d]; apos:=1; if a>1 then apos:=1+random(a);
   begin1:=-1; got:=0;
   for p:=0 to Tlimit[d]-1 do
    if AutoPer[d,p]=1 then
      begin
       inc(got);
       if (got=apos) then begin1:=p;
      end;
   if lastperiod and (begin1=Tlimit[d]-1) and (Asingle[d]>1) then
    begin
     a:=Asingle[d]; apos:=1+random(a-1);
     begin1:=-1; got:=0;
     for p:=0 to Tlimit[d]-1 do
      if AutoPer[d,p]=1 then
        begin
         inc(got);
         if got=apos then begin1:=p;
        end;
    end;
   if begin1=-1 then goto SingleCycle;
   if begin1=Tlimit[d]-1 then lastperiod:=true;
   Builddlg.DoSelect(d,begin1);
   AutoPer[d,begin1]:=0;
   if Asingle[d]>0 then dec(Asingle[d]);
   if Sneed>0 then dec(Sneed);
   Adone[d]:=true;
  end; {i}
end;

procedure TBuildDlg.AutoBtnClick(Sender: TObject);
var
 Sneed,Dneed,Tneed,TotNeed,i:  integer;
 msg: string;
begin
 TotNeed:=abTriple*3+abDouble*2+abSingle;
 Sneed:=abSingle; Dneed:=abDouble; Tneed:=abTriple;
 if TotNeed=0 then exit;
 restore(false); {set selection back to 0}
 for i:=0 to days do Adone[i]:=false;
 if abTriple>0 then AutoTriples(Tneed);
 if abDouble>0 then AutoDoubles(Dneed);
 if abSingle>0 then AutoSingles(Sneed);
 msg:='';
 if Sneed>0 then msg:='Singles set: '+inttostr(abSingle-Sneed)+'/'+
  inttostr(abSingle);
 if Dneed>0 then
  begin
   if msg>'' then msg:=msg+endline;
   msg:=msg+'Doubles set: '+inttostr(abDouble-Dneed)+'/'+
  inttostr(abDouble);
  end;
 if Tneed>0 then
  begin
   if msg>'' then msg:=msg+endline;
   msg:=msg+'Triples set: '+inttostr(abTriple-Tneed)+'/'+
  inttostr(abTriple);
  end;
 if msg>'' then messagedlg(msg,mtInformation,[mbOK],0);
end;


procedure TBuildDlg.Checkunit;
var
 Sbyte2: byte;
 Fix1:  bool;
 Nblock1: byte;
begin
 Sbyte2:=FNTByte(td,tp,ty,tl,6)^;
 Nblock1:=FNgetWSblockNumber(fb,fy,fl);
 if copyop<>3 then
  begin
   if (Nblock1>0) and (Bbox=bsCell) then Bflag:=True;
  end;
 if Copyop=0 then exit;
 Fix1:=((sByte2 and 4)=4);
 Nblock1:=FNgetBlockNumber(td,tp,ty,tl);
 if Fix1 then Fflag:=true;
 if (Nblock1>0) and (Bbox=bsCell) then Bflag:=True;
end;

procedure CheckBox;
var
 msg,location: string;
begin
 CopyStop:=false;
 location:='on '+day[td]+': '+inttostr(tp+1);
 if Fflag then
  begin
   msg:='One or more entries '+location+' are fixed - can''t '+optype;
   messagedlg(msg,mtWarning,[mbOK],0);
   CopyStop:=true;
   exit;
  end;
 if not(warn) then exit;
 if Bflag then
  begin
   if OpCheck(' in cell '+location,'block',Optype) then CopyStop:=true;
   if CopyStop then exit;
  end;
end;


Procedure DoUnit;
var
 A,B,C:  tpIntPoint;
 Lplace,Lplace1:   integer;
 Sbyte: byte;

 procedure ClearLabel;
 begin
  Lplace:=A^; if Lplace<=LabelBase then exit;
  Lplace:=Lplace-LabelBase;
  TcLabel[Lplace]:='';
  if Lplace=Lnum then dec(Lnum);
  if Lnum<0 then Lnum:=0;
 end;

 procedure NewLabel;
 begin
  Lplace1:=B^; if Lplace1<=LabelBase then exit;
  Lplace1:=Lplace1-LabelBase;
  Lplace:=FindLabel; if Lplace=0 then exit;
  B^:=Lplace+LabelBase;
  TcLabel[Lplace]:=TcLabel[Lplace1];
 end;

begin
 if(Copyop=0) and (tp<Tlimit[td]) then  {clear}
  begin
   PushCell(td,tp,ty,tl);
   A:=FNT(td,tp,ty,tl,0);
   ClearLabel; A^:=0;
   inc(A); A^:=0; inc(A); A^:=0; inc(A); A^:=0;
  end;
 if (CopyOp>0) and ((Bbox=bsYrBlock) or (Bbox=bsBlock)) then
  if (fb>wsBlocks) OR (tp>=Tlimit[td]) then exit;
 if (CopyOp=1) or (CopyOp=3) then
  begin
   PushCell(td,tp,ty,tl);
   A:=FNT(td,tp,ty,tl,0);
   ClearLabel;
  end;
 if (CopyOp=3) then {copy}
  begin
  C:=FNws(fb,fy,fl,0); B:=FNT(td,tp,ty,tl,0); B^:=C^; NewLabel;
  inc(B); inc(C); B^:=C^;
  inc(B); inc(C); B^:=C^;
  inc(B); inc(C); B^:=C^;
  if AddDouble then
   begin
    Sbyte:=FNTByte(td,tp,ty,tl,6)^;
    Sbyte:=Sbyte or 1;
    FNTByte(td,tp,ty,tl,6)^:=Sbyte;
   end;
  end;
 Fclash[td,tp]:=1;
end;

procedure TBuildDlg.CopyBlock;
var
 xxfl,y2: integer;
begin
 Bflag:=false; Fflag:=False;
 for y2:=byr2 downto byr1 do
  begin
   GetYearLevels(y2);
   fy:=y2; ty:=y2;
   for xxfl:=l1 to l2 do
    begin
     fl:=xxfl;
     tl:=fl;
     CheckUnit;
    end;
  end;
 CheckBox;
 if CopyStop then exit;
 for y2:=byr2 downto byr1 do
  begin
   GetYearLevels(y2);
   for xxfl:=l1 to l2 do
    begin
     fl:=xxfl; tl:=fl;
     fy:=y2; ty:=fy;
     DoUnit;
    end;
  end;
end;


procedure TBuildDlg.CopyBtnClick(Sender: TObject);
var
 xxtd,xxtp: integer;
begin
 Copyop:=3; Optype:='Copy'; fb:=bb;
 PushTtStackStart(utBuildCopy);
 for xxtd:=0 to days-1 do
  for xxtp:=0 to Tlimit[xxtd]-1 do
  begin
   td:=xxtd; tp:=xxtp;  AddDouble:=false;
   if CheckPer[td,tp]=-2 then
    begin
     if (tp<(Tlimit[td]-1)) then if CheckPer[td,tp+1]=-2 then AddDouble:=true;
     if (tp>0) then if CheckPer[td,tp-1]=-2 then AddDouble:=true;
     copyblock;
     AddDouble:=false;
    end;
  end;
 restore(false);
 ttclash;
 UpdateTimetableWins;
 SaveTimeFlag:=True;
end;

procedure TBuildDlg.MatchBtnClick(Sender: TObject);
var
 d,p,l:   integer;
 found:   bool;
begin
 for d:=0 to days-1 do
  for p:=0 to Tlimit[d]-1 do
   if CheckPer[d,p]<0 then DoSelect(d,p);
 for d:=0 to days-1 do
  for p:=0 to Tlimit[d]-1 do
   begin
    if CheckPer[d,p]<>2 then continue;
    found:=false;
    for l:=1 to level[Myear] do
     begin
      if Mblock=FNgetBlockNumber(d,p,Myear,l) then found:=true;
     end;
    if found then DoSelect(d,p);
   end;
 if Nselect=0 then messagedlg('No matches found',mtInformation,[mbOK],0);
end;

procedure TBuildDlg.ComboBox3Change(Sender: TObject);
begin
  Myear := findYear(ComboBox3.text);
  if Myear > 0 then
   ComboBox3.ItemIndex := ComboBox3.Items.IndexOf(yearname[Myear]);
  if firstStart then
    Exit;
  SetMatchBtn;
end;

procedure TBuildDlg.Edit6Change(Sender: TObject);
begin
 Mblock:=IntFromEdit(edit6);
 if firstStart then exit;
 SetMatchBtn;
end;

procedure TBuildDlg.ClearBtnClick(Sender: TObject);
var
  xxfd,xxfp: integer;
begin
  fb := bb;
  CopyOp := 0;
  Optype := 'Clear';
  PushTtStackStart(utBuildClear);
  for xxfd := 0 to days-1 do
    for xxfp := 0 to Tlimit[xxfd]-1 do
    begin
      td:=xxfd; tp:=xxfp;
      if CheckPer[td,tp]=-1 then
        copyblock;
    end;
  restore(False);
  ttclash;
  UpdateTimetableWins;
  SaveTimeFlag := True;
end;

procedure TBuildDlg.RefreshHint(Sender: TObject);
begin
  TLabel(Sender).Hint := TLabel(Sender).Caption;
end;

procedure TBuildDlg.ResetBtnClick(Sender: TObject);
begin
 Restore(false);
end;

procedure TBuildDlg.WarnBoxClick(Sender: TObject);
begin
 warn:=WarnBox.checked;
end;

procedure TBuildDlg.ComboBox5Change(Sender: TObject);
begin
 myTarget:=ComboBox5.ItemIndex-1;
 GetTargetTimes;
 restore(false);
end;

procedure TBuildDlg.ComboBox4Change(Sender: TObject);
begin
 SetMultiples;
end;

end.
