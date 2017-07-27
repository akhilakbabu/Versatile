unit showclas;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Grids, Dialogs, TimeChartGlobals,GlobalToTcAndTcextra,
  XML.DISPLAY;


type
  TClassesShowDlg = class(TForm)
    GroupBox1: TGroupBox;
    ListBox1: TListBox;
    StringGrid1: TStringGrid;
    BitBtn1: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    finish: TBitBtn;
    BitBtn3: TBitBtn;
    allocate: TBitBtn;
    ComboBox1: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure finishClick(Sender: TObject);
    procedure AddAvailableRollClass(Sender: TObject);
    procedure RemoveRollClass(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StringGrid1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure updateLevelLabel;
    procedure SetClassGrid;
    procedure DisplayClassesWithOutTeacherOrRoom;
  end;

type
  tpteon = array [0..nmbrteachers, 0..nmbrPeriods] of integer;

var
  ClassesShowDlg: TClassesShowDlg;

implementation
uses tcommon,tcommon2,DlgCommon,TTundo;
{$R *.DFM}

var
 tmpClassShown:       tpClassShown;
 tmpFlag: bool;

procedure TClassesShowDlg.updateLevelLabel;
var
 m: smallint;
begin
 m:=stringgrid1.selection.top;
 label4.caption:='Level '+inttostr(m);
end;

procedure TClassesShowDlg.SetClassGrid;
var
 m,yy: integer;
begin
 yy:=combobox1.ItemIndex;
 stringgrid1.rowcount:=(Level[yy]+1);
 stringgrid1.cells[0,0]:=yearshort+' '+yearname[yy];
 for m:=1 to level[yy] do
  begin
   if tmpClassShown[m,yy]>0 then
    stringgrid1.cells[0,m]:='  '+ClassCode[tmpClassShown[m,yy]]
   else stringgrid1.cells[0,m]:='';
  end; {for m}
end;

procedure TClassesShowDlg.FormCreate(Sender: TObject);
var
 i,j:     integer;
begin
 tmpFlag:=false;    label4.caption:='';
 fillchar(tmpClassShown,sizeof(tmpClassShown),chr(0));
 label1.caption:='For '+yeartitle+':';
 for i:=0 to years_minus_1 do
  for j:=1 to nmbrlevels do
   tmpClassShown[j,i]:=ClassShown[j,i];

 listbox1.clear;
 if RollClassPoint[0]>0 then
  for j:=1 to RollClassPoint[0] do
   listbox1.items.add(ClassCode[RollClassPoint[j]]);
 FillComboYears(false,ComboBox1);
 combobox1.itemindex:=ny;
end;

procedure TClassesShowDlg.FormShow(Sender: TObject);
{var
  IntPoint: tpIntPoint;
  su,te,ro: Smallint;
  tmpStr: string;
  d, p, y, l: Smallint;
  lRollClass: string;
  lPrevRollClass: string;}
begin
  {for y :=0 to yr do
    for l :=1 to nmbrlevels do
    begin
      lRollClass := ClassCode[tmpClassShown[l, y]];
      //ClassCode[ClassShown[ttcalcL, ttcalcY]];
      for d := 0 to days - 1 do
        for p := 0 to Periods - 1 do
        begin
          if lRollClass <> '' then
          begin
            IntPoint := FNT(d,p,y,l,0);
            su := IntPoint^;
            Inc(IntPoint);
            te := IntPoint^;
            Inc(IntPoint);
            ro := IntPoint^;
            tmpStr := tecode[te,0];
            if tmpStr <> '' then
            begin
              tmpStr := tecode[ro,1];
              if (tmpStr = '') and (lRollClass <> lPrevRollClass) then
              begin
                lsbClassesWithTeRo.Items.Add(lRollClass);
                lPrevRollClass := lRollClass;
              end;
            end;
          end;
        end;
    end;
  DisplayClassesWithOutTeacherOrRoom;}
end;

procedure TClassesShowDlg.BitBtn5Click(Sender: TObject);
var
 i,j: integer;
begin
 {clear from tt - show none}
 for i:=years_minus_1 downto 0 do
  begin
   for j:=1 to nmbrLevels do tmpClassShown[j,i]:=0;
   tmpClassShown[0,i]:=0;
  end;
 SetClassGrid;
 tmpFlag:=True;
end;

procedure TClassesShowDlg.ComboBox1Change(Sender: TObject);
begin
 SetClassGrid;
 updateLevelLabel;
end;

procedure TClassesShowDlg.DisplayClassesWithOutTeacherOrRoom;
var
  astr: string;
  strtday,finday: integer;
  strtyear,finyear: integer;
  d,yyear,L: integer;
  i: integer;

  procedure ttableprint1;
  var
   p,a1:  integer;
   aFnt,bFnt: tpintpoint;
   code: integer;
   tmpStr,cstr: string;
   lClassCode: string;
  begin
   if (L=1) then
   begin
     yearname[yyear];
   end;
   lClassCode := ClassCode[ClassShown[l, yyear]];
   for p := 1 to tlimit[d] do
    if XML_DISPLAY.TsOn[d,p-1] then
    begin
     aFnt := FNT(d,p-1,yyear,l,0);
     //if ttselect(aFnt) then {no selection, or subg teg rog or fac - 2,3,4 or 5}
     begin
       for code := 0 to 2 do
       begin
         bfnt := afnt;
         Inc(bfnt, code);
         a1 := bfnt^;
         if ((code = 0) and (a1 > LabelBase)) then
         begin
           cstr := tclabel[a1 - LabelBase];
           Break;
         end
         else
         begin
           tmpstr := FNsub(a1, code);
         end;
       end; {code}
     end; {if found}
     {inc(j); }
    end; {if TsOn[d,p-1]}
  end;
begin
  strtday:=0;
  finday:=days-1;
  if ((XML_DISPLAY.ttprntselyear=-1) or (XML_DISPLAY.ttPrntType=0)) then {all years or main tt}
  begin
     strtyear:=years-1;
     finyear:=0;
  end
  else
  begin
     strtyear:=XML_DISPLAY.ttprntselyear;
     finyear:=XML_DISPLAY.ttprntselyear;
  end;
  for d:=strtday to finday do
  begin
    if not(XML_DISPLAY.Dprint[d+1]) then continue;
    if strtday<>finday then
    begin
      astr:=dayname[d];
    end;

    for i:=1 to tlimit[d] do
      if XML_DISPLAY.TsOn[d,i-1] then
      begin
        TimeSlotName[d,i-1];
      end;

    for yyear := strtyear downto finyear do
    begin
     if XML_DISPLAY.pyear[yyear] then
     begin
      for L := 1 to level[yyear] do
      begin
       ttableprint1;
      end; {for L}
     end;
    end; {for yyear}

    if XML_DISPLAY.ttPrntType=0 then {main and not year ttable so page break}
    begin
      if d <> finday then
      begin
       L:=0;
       for i:=d+1 to finday do
        if XML_DISPLAY.Dprint[i+1] then
        begin
          L:=1;
          break;
        end;
      end;
    end;
   end; {for d}
end;

procedure TClassesShowDlg.finishClick(Sender: TObject);
var
 i,j: integer;
begin
 PushClassShown;
 for i:=years_minus_1 downto 0 do
  for j:=1 to nmbrlevels do
   ClassShown[j,i]:=tmpClassShown[j,i];
 if tmpFlag then SaveTimeFlag:=true;
 UpdateTimeTableWins;
end;

procedure TClassesShowDlg.AddAvailableRollClass(Sender: TObject);
var
  i,yy,m: Integer;
begin
  yy := ComboBox1.ItemIndex;
  if listbox1.itemindex = -1 then
  begin
    MessageDlg('No class selected.', mtError, [mbOK], 0);
    Exit;
  end;
  i := listbox1.itemindex+1;
  m := stringgrid1.Selection.Top;
  tmpClassShown[m,yy] := RollClassPoint[i];
  SetClassGrid;
  tmpFlag := True;
end;

procedure TClassesShowDlg.RemoveRollClass(Sender: TObject);
var
  yy,m: Integer;
begin
  yy := ComboBox1.ItemIndex;
  m := StringGrid1.Selection.Top;
  if m = 0 then
  begin
    MessageDlg('No level selected.', mtError, [mbOK], 0);
    Exit;
  end;
  tmpClassShown[m,yy] := 0;
  SetClassGrid;
  tmpFlag := True;
end;

procedure TClassesShowDlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 action:=cafree;
end;

procedure TClassesShowDlg.StringGrid1Click(Sender: TObject);
begin
 updateLevelLabel;
end;

procedure TClassesShowDlg.FormActivate(Sender: TObject);
var
 myRect: TGridRect;
begin
 ComboBox1Change(self);
 myRect.Left:=1;
 myRect.Top:=nl;
 myRect.Right:=1;
 myRect.Bottom:=nl;
 stringgrid1.selection:=myRect;
 if (ny>0) and (ny<=years_minus_1) then ComboBox1.itemindex:=ny;
 updateLevelLabel;
end;

end.

