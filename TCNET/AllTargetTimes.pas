unit AllTargetTimes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, NiceGrid, StdCtrls, TimeChartGlobals,GlobalToTcAndTcextra, XML.TEACHERS;

type
  TFrmShowAllTargetTimes = class(TForm)
    grdAllTragetTimes: TNiceGrid;
    lblTargets: TLabel;
    chkOverwrite: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure RefreshTimeSlots(Sender: TObject);
  private
    myTarget: Integer;
    Bbox,Nblock,l1,l2,byr1,byr2:  integer;
    tegroup, sugroup, rogroup:  array of smallint;
    TeGrpShare,RoGrpShare: array of boolean;
    Ntegroup,Nsugroup,Nrogroup:  integer;
    CanCopy: Boolean;
    bb,by,bl:  integer;
    bl1,bl2: array[0..nmbrYears] of Integer;
    myMult: Integer;
    Nentries, Navail, Nselect, NentrySelect: integer;
    CheckPer: tpFclash;
    CopyRect: TRect;
    Mblock: Integer;
    FLevel: Integer;
    procedure GetTargetTimes;
    procedure Restore(const ResetMult: Boolean);
    procedure ShowCopy;
    procedure DisplayTime(const d, p, y: Integer; TsColour: Tcolor);
    function HasTarget(const d, p, pTargetYr: Integer): Boolean;
    function IsValidPos: Boolean;
    procedure CalcBuildLevels;
    procedure GetYearLevels(const myY: Integer);
    procedure SetMultiples;
  end;

var
  FrmShowAllTargetTimes: TFrmShowAllTargetTimes;

const
  bsCell = 0;  {build scope cell}
  bsYrBlock = 1;
  bsBlock = 2;


implementation

uses
  TCommon, TCommon2;

{$R *.dfm}

procedure TFrmShowAllTargetTimes.CalcBuildLevels;
var
  IntPoint:      tpIntPoint;
  y,l:             integer;
  su,te,ro:      integer;
  bl1, bl2: array[0..nmbrYears] of integer;
begin
 for y := 0 to years_minus_1 do
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
 //byr1:=by; byr2:=by; {one year}
 if Bbox=bsBlock then
  begin
   //byr1:=0; byr2:=yr; {all years}
  end;
end;

procedure TFrmShowAllTargetTimes.DisplayTime(const d, p, y: Integer; TsColour: Tcolor);
begin
  //image1.canvas.font.color := TsColour;
  //if TsColour<>clBlack then
    //image1.canvas.font.style := (image1.canvas.font.style+[fsUnderline]);
  //image1.canvas.textout(ptab[p],2+15*d,tsCode[d,p]);
  //image1.canvas.font.style := (image1.canvas.font.style-[fsUnderline]);
  grdAllTragetTimes[p + 1, d + 1 + (y * Days) + y] := tsCode[d, p];
end;

procedure TFrmShowAllTargetTimes.FormShow(Sender: TObject);
var
  s:      string;
begin
  //firstStart:=true;
  {if wsBox=bxYrTime then
    BuildScope.ItemIndex:=1
  else if wsBox=bxTime then
    BuildScope.ItemIndex:=2
  else
    BuildScope.ItemIndex:=0;
  Bbox:=BuildScope.ItemIndex;}

  //WarnBox.checked:=Warn;
  //label3.caption:='&'+Yeartitle;
  //label5.font.color:=FontColorPair[cpSub,1];
  //label6.font.color:=FontColorPair[cpTeach,1];
  //label7.font.color:=FontColorPair[cpRoom,1];
  //FillComboBlocks(Combobox2);
  //FillComboMult(ComboBox4);
  //combobox4.ItemIndex:=0;
  //FillComboTarget(ComboBox5);
  //FillComboYears(false,ComboBox1);
  //FillComboYears(false,ComboBox3);
  //overWritebox.checked:=abOverwrite;
  by:=wsy; bl:=wsl; bb:=wsb;
  //AddDouble:=false;
  s:='';
  //Myear:=-1;
  //abSingle:=1;
  myMult:=-1;
  if by<years_minus_1 then
  begin
    s:=yearname[years_minus_1];
    //Myear:=yr;
  end;
  fillchar(CheckPer,sizeof(CheckPer),chr(0));
  //fillchar(AutoPer,sizeof(AutoPer),chr(0));
  fillchar(Sugroup,sizeof(Sugroup),chr(0));
  fillchar(tegroup,sizeof(tegroup),chr(0));
  fillchar(Rogroup,sizeof(Rogroup),chr(0));


  myTarget := by;
  //ComboBox5.ItemIndex:=by+1;
  GetTargetTimes;
  Restore(True);
  SetMultiples;

  myTarget := by;  //ComboBox5.ItemIndex - 1;
  Restore(False);
end;

procedure TFrmShowAllTargetTimes.GetTargetTimes;
var
  d, p: Integer;
  lCount: Integer;
  lRect: TRect;
  X1, X2, Y1, Y2: Integer;
  y: Integer;
begin
  lCount := 0;
  grdAllTragetTimes.Clear;
  for y := 0 to years_minus_1 do
  begin
    for d := 0 to Days - 1 do
    begin
      for p := 0 to Tlimit[d] - 1 do
      begin
        if p >= grdAllTragetTimes.ColCount -1 then
        begin
          if HasTarget(d, p, y) then
            Inc(lCount);
          grdAllTragetTimes.ColCount := grdAllTragetTimes.ColCount + 1;
        end;
      end;
      grdAllTragetTimes.RowCount := grdAllTragetTimes.RowCount + 1;
      grdAllTragetTimes[0, D + 1 + (y * Days) + y] := DayName[D];
    end;
    grdAllTragetTimes.MergeCells(0, (y * Days) + y, 5, (y * Days) + y, 'Year ' + YearName[y]);
    lblTargets.Caption := 'Target Times: ' + IntToStr(lCount);
    grdAllTragetTimes.RowCount := grdAllTragetTimes.RowCount + 1;
  end;
end;

procedure TFrmShowAllTargetTimes.GetYearLevels(const myY: Integer);
begin
  case Bbox of
    bsCell:
    begin
      l1:=bl;
      l2:=bl;
    end;
    bsYrBlock,bsBlock:
    begin
      l1 := bl1[myY];
      l2:=bl2[myY];
    end;
  end;
end;

function TFrmShowAllTargetTimes.HasTarget(const d, p, pTargetYr: Integer): Boolean;
begin
  Result := (wstSingle[pTargetYr, d] and (1 shl p)) <> 0;
end;

function TFrmShowAllTargetTimes.IsValidPos: Boolean;
begin
  Result := True;
  if (bb<1) or (bb>wsBlocks) then result:=false;
  if bBox=0 then if (bl<1) or (bl>level[by]) then result:=false;
end;

procedure TFrmShowAllTargetTimes.RefreshTimeSlots(Sender: TObject);
begin
  GetTargetTimes;
  Restore(False);
end;

procedure TFrmShowAllTargetTimes.Restore(const ResetMult: Boolean);
var
  IntPoint: tpIntPoint;
  s: string;
  l,i,myY: Integer;
  su,te,ro,newMult: Smallint;
  ShareFlg: Boolean;
  lLongestLength: Integer;
begin
  lLongestLength := GetLongestLength;
  Ntegroup:=0; Nsugroup:=0; Nrogroup:=0; newMult:=-1;
  SetLength(TeGrpShare,2);  SetLength(RoGrpShare,2);
  l1:=0; l2:=0; Cancopy:=False; Nblock:=0;
  if IsValidPos then
  begin      // ^- check on valid position
    CalcBuildLevels;
    for myY:= years_minus_1 downto 0 do           //byr2     byr1
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
              //if newMult<>myMult then    //ToDo
                //Combobox4.ItemIndex := wsOrder[newMult];
            end;
          end;
          if (te>0) then
          begin
            Inc(Ntegroup);
            SetLength(tegroup, Ntegroup + 2);
            tegroup[Ntegroup] := te;
            SetLength(TeGrpShare, Ntegroup + 2);
          end;
          if (ro > 0) then
          begin
            Inc(Nrogroup);
            SetLength(Rogroup, Nrogroup + 2);
            Rogroup[Nrogroup] := ro;
            SetLength(RoGrpShare, Nrogroup + 2);
          end;
          TeGrpShare[Ntegroup] := ShareFlg and (te > 0);
          RoGrpShare[Nrogroup] := ShareFlg and (ro > 0);
          i := FNgetWSblockNumber(bb,by,l);
          if Nblock = 0 then Nblock := i;
        end; //for l
    end; //for myY
  end; //if valid pos
  //Combobox2.ItemIndex := Combobox2.Items.IndexOf(IntToStr(bb));
  //Combobox1.ItemIndex := Combobox1.Items.IndexOf(yearname[by]);
  if (bl>0) and (bl<=level[by]) then
    FLevel := bl;
  s:='';
  if (Nsugroup=0) and (Ntegroup=0) and (Nrogroup=0) then
    s:='No codes at this position'
  else
    CanCopy:=True;
  if Nsugroup>0 then
  begin
    for i:=1 to Nsugroup do    //Subject list
      s := s + Trim(subcode[Sugroup[i]]) + ' ' + GetSpacesToAlign(Trim(subcode[Sugroup[i]]), lLongestLength);
    end;
  s:='';
  if Ntegroup>0 then
    for i:=1 to Ntegroup do    //Teacher list
      s := s + Trim(XML_TEACHERS.tecode[tegroup[i],0]) + ' ' + GetSpacesToAlign(Trim(XML_TEACHERS.tecode[tegroup[i],0]), lLongestLength);;
  //if (bl<1) or (bl>level[by]) then
  if Nrogroup>0 then   //Room list
    for i:=1 to Nrogroup do
      s := s + Trim(XML_TEACHERS.tecode[Rogroup[i],1]) + ' ' + GetSpacesToAlign(Trim(XML_TEACHERS.tecode[RoGroup[i],1]), lLongestLength);;
  if Nblock > 0 then    //Block #
  begin
    s:=inttostr(Nblock);
    Mblock:=Nblock;
  end;
  ShowCopy;
  //label16.Caption:=inttostr(Nentries);
  //label18.Caption:=inttostr(Navail);
  //label20.Caption:=inttostr(Nselect);
  //label22.Caption:=inttostr(NentrySelect);
end;

procedure TFrmShowAllTargetTimes.SetMultiples;
begin
  //GetMultIndex(myMult,Combobox4);
  //abSingle:=wsOne[myMult];
  //abDouble:=wsTwo[myMult];
  //abTriple:=wsThree[myMult];
end;

procedure TFrmShowAllTargetTimes.ShowCopy;
var
  d,p,y,y2,l: Integer;
  empty, found, HasShare, gotSub: Boolean;
  IntPoint: tpIntPoint;
  allthere,te,ro,j: Smallint;
  s,i: Integer;
  lYear: Integer;
begin
  Nentries:=0;
  Navail:=0;
  Nselect:=0;
  NentrySelect:=0;
  if not CanCopy then Exit;
  for lYear := 0 to years_minus_1 do
  for d := 0 to Days - 1 do
    for p := 0 to Tlimit[d]-1 do
    begin
      CheckPer[d,p]:=0;
      if not(HasTarget(d, p, lYear)) then Continue;
      empty := True;
      for y2 := years_minus_1 downto 0 do        //byr2       byr1
      begin
        GetYearLevels(y2);
        for l := l1 to l2 do
          if FNT(d,p,y2,l,0)^>0 then
          begin
            empty := False;
            Break;
          end;
      end;
      allthere := 0;
      if Nsugroup > 0 then
        for s := 1 to Nsugroup do
        begin
          gotSub := False;
          for y2 := years_minus_1 downto 0 do    //byr2   byr1
          begin
            GetYearLevels(y2);
            for l := l1 to l2 do
              if FNT(d, p, y2, l, 0)^ = Sugroup[s] then
              begin
                Inc(allthere);
                gotSub := True;
                Break;
              end;
            if gotSub then
              Break;
          end;   //for
        end;  //for
      found := False;
      //lYear := 0;
      for y := 0 to years_minus_1 do
      begin
        GetYearLevels(y);
        for l:=1 to level[y] do
        begin
          if ((Bbox=bsBlock) or (y=by)) and (l>=l1) and (l<=l2) then Continue;
          Intpoint:=FNT(d,p,y,l,2);
          te:=Intpoint^;
          inc(Intpoint); ro:=Intpoint^;
          inc(Intpoint); j:=intpoint^; HasShare:=((j and 2)=2);
          if (ro=0) and (te=0) then Continue;
          if (te>0) and (Ntegroup>0) then
          for i:=1 to Ntegroup do
            if te=tegroup[i] then if not(TeGrpShare[i] and HasShare) then
            begin
              found := True;
              Break;
            end;
          if (ro>0) and (Nrogroup>0) and not(found) then
            for i:=1 to Nrogroup do
              if ro=Rogroup[i] then if not(RoGrpShare[i] and HasShare) then
              begin
                found := True;
                Break;
              end;
        end; //for l
        if found then Break;
      end; //for y
      if (allthere = Nsugroup) and (Nsugroup > 0) then CheckPer[d, p] := 1;
        if (empty or chkOverwrite.Checked) and not(found) and (CheckPer[d,p]<>1) then     //if empty and
        begin
          CheckPer[d,p] := 2;
          Inc(Navail);
          DisplayTime(d, p, lYear, clBlack);
        end;
      if (allthere = Nsugroup) and (Nsugroup > 0) then
      begin
        CheckPer[d,p] := 1;
        Inc(Nentries);
        DisplayTime(d, p, lYear, clRed);
      end;
    end; // for p
end;

end.
