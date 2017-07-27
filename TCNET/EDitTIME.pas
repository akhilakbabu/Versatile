unit EditTime;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, ComCtrls, Grids,TimeChartGlobals, Menus, SHFolder, XML.UTILS, GlobalToTcAndTcextra;

type
  TAllotDlg = class(TForm)
    pgcTimeSlot: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet3: TTabSheet;
    Label1: TLabel;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    Label6: TLabel;
    grdTimeSlot: TStringGrid;
    Label44: TLabel;
    ComboBox1: TComboBox;
    Memo1: TMemo;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    Label62: TLabel;
    SlotUnits1: TRadioGroup;
    update: TBitBtn;
    pnlButtons: TPanel;
    finish: TBitBtn;
    BitBtn1: TBitBtn;
    pmnTimeSlot: TPopupMenu;
    popDelete: TMenuItem;
    cmbType: TComboBox;
    N1: TMenuItem;
    SaveToFile1: TMenuItem;
    LoadFromFile1: TMenuItem;
    Insert1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure myDayColourPress(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TabSheet3Exit(Sender: TObject);
    procedure RefreshTimeSlots(Sender: TObject);
    procedure SetTimeSlots(Sender: TObject);
    procedure SlotUnits1Click(Sender: TObject);
    procedure DeleteTimeSlot(Sender: TObject);
    procedure SetGridSelection(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FilterEntryData(Sender: TObject; var Key: Char);
    procedure cmbTypeChange(Sender: TObject);
    procedure cmbTypeExit(Sender: TObject);
    procedure grdTimeSlotSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure btnSaveToFileClick(Sender: TObject);
    procedure btnLoadFromFileClick(Sender: TObject);
    procedure InsertTimeSlot(Sender: TObject);
  private
    SaveLoadFileName: string;
    procedure Fillgrid;
    procedure configGrid;
    procedure DeleteRow(pGrid: TStringGrid; aRow: Integer);
    procedure InsertRow(pGrid: TStringGrid; aRow: Integer);
    function CountRowsUsed(pGrid:TStringGrid): Integer;
  end;


var
  AllotDlg: TAllotDlg;

implementation

uses tcommon,TTundo,TimesWnd,tcload, Main,tcommon2,DlgCommon;

{$R *.dfm}

var
 inLoad,timechange: boolean;
 MyDayGroup,Dgroup:   smallint;
 DayCheck:              array[1..nmbrDays] of Tcheckbox;
 DayCol:       array[1..nmbrDays] of Tpanel;
 DayBtn:                array[1..nmbrDays] of TBitBtn;
 DayImage:   array[1..nmbrDays] of Timage;
 usingResources:        boolean;
 dayuse,tmpTslotUnit:    smallint;
 tmpSlotUnitMain,tmpSlotUnitDec: smallint;
 tmptsStart,tmptsEnd:  array[0..nmbrperiods] of TDateTime;


function FontGroupColour(i: integer): Tcolor;
begin
 result:=clBlack;
 case i of
  2: result:=clRed;
  3: result:=clGreen;
  4: result:=clMaroon;
  5: result:=clBlue;
  6: result:=clPurple;
  7: result:=clOlive;
  8: result:=clTeal;
  9: result:=clFuchsia;
 end;
end;

function showGroupColour(i: integer): Tcolor;
begin
 result:=clBtnFace;
 case i of
  1: result:=$00DDFFFF;
  2: result:=$00C6C6FF;
  3: result:=$00DDFFDD;
  4: result:=$00B0D8FF;
  5: result:=$00FFFFDF;
  6: result:=$00FFC1FF;
  7: result:=$009FFF9F;
  8: result:=$0062B0FF;
  9: result:=$00FFFFAC;
  10: result:=$008C8CFF;
  11: result:=$0013FFFF;
  12: result:=$00E4AD76;
  13: result:=$004575F1;
  14: result:=$0015FF15;
  15: result:=$00FF0FFF;
 end;
end;

procedure TAllotDlg.Fillgrid;
var
 i,j:  integer;
 astr:  string;
begin
 dayuse:=dg[MyDayGroup,1];
 longtimeformat:='h:mmam/pm';
 for i:=1 to nmbrperiods do grdTimeSlot.cells[0,i]:='  '+inttostr(i);
 for i:=1 to Tlimit[dayuse] do
  begin
   grdTimeSlot.cells[1,i]:=TimeSlotName[dayuse,i-1];
   grdTimeSlot.cells[2,i]:=tsCode[dayuse,i-1];
   str(tsAllot[dayuse,i-1]:tmpSlotUnitMain:tmpSlotUnitDec,astr);
   grdTimeSlot.cells[3,i]:=trim(astr);
   grdTimeSlot.cells[4,i]:=TimeToStr(tsStart[dayuse,i-1]);
   grdTimeSlot.cells[5,i]:=TimeToStr(tsEnd[dayuse,i-1]);
   grdTimeSlot.Cells[6,i]:=IntToStr(tsType[dayuse,i-1]);
  end;
 for i:=Tlimit[dayuse]+1 to nmbrPeriods do  {clear rest of grid}
  for j:=1 to 5 do grdTimeSlot.cells[j,i]:='';
end;

procedure GroupArrayCalc;
begin
 DayGroupCalc;
 if MyDayGroup>numDayGroups then MyDayGroup:=numDayGroups;
 dayuse:=dg[MyDayGroup,1];
end;

procedure TAllotDlg.cmbTypeChange(Sender: TObject);
begin
  grdTimeslot.Cells[grdTimeslot.Col, grdTimeslot.Row] :=
    IntToStr(cmbType.ItemIndex);
  cmbType.Visible := False;
  grdTimeslot.SetFocus;
end;

procedure TAllotDlg.cmbTypeExit(Sender: TObject);
begin
  grdTimeslot.Cells[grdTimeslot.Col, grdTimeslot.Row] :=
    IntToStr(cmbType.ItemIndex);
  cmbType.Visible  := False;
  grdTimeslot.SetFocus;
end;

procedure TAllotDlg.configGrid;
var
 i,k,m: integer;
begin
 GroupArrayCalc;
 label59.caption:=inttostr(numDayGroups);
 grdTimeSlot.rowcount:=nmbrPeriods+1;  //allow for max num to be able to add them in
 grdTimeSlot.colcount:=7;
 grdTimeSlot.cells[0,0]:='Time Slot';
 m:=canvas.textwidth('Time Slot');
 grdTimeSlot.ColWidths[0]:=m;

 grdTimeSlot.cells[1,0]:=' Name';
 m:=canvas.textwidth(' Name  ');
 if fwperiodname>m then m:=fwperiodname;
 grdTimeSlot.ColWidths[1]:=m;

 grdTimeSlot.cells[2,0]:='Code';
 m:=canvas.textwidth('Code ');
 grdTimeSlot.ColWidths[2]:=m;

 grdTimeSlot.cells[3,0]:=TslotUnitName[tmpTslotUnit];
 m:=canvas.TextWidth(TslotUnitName[tmpTslotUnit]);
 i:=canvas.TextWidth('9999.99 ');
 if i>m then m:=i;
 grdTimeSlot.ColWidths[3]:=m;

 grdTimeSlot.cells[4,0]:='Start time';
 m:=canvas.textwidth('Start time');
 i:=canvas.TextWidth('12:59 AM ');
 if i>m then m:=i;
 grdTimeSlot.ColWidths[4]:=m;

 grdTimeSlot.cells[5,0]:='End time';
 m:=canvas.textwidth('End time');
 if i>m then m:=i;
 grdTimeSlot.ColWidths[5]:=m;

 grdTimeSlot.cells[6,0]:='Type';
 m:=canvas.textwidth('Type');
 //if i>m then m:=i;
 grdTimeSlot.ColWidths[6]:=m;


 fillgrid;

 Memo1.clear; {deal with memo}
 if (numDayGroups>1) and (numDayGroups<days) then //fill memo with days legend
  for i:=1 to numDayGroups do
  begin
    Memo1.lines.append('Day Group '+inttostr(i)+':');
    for k:=1 to dg[i,0] do Memo1.lines.append('     '+dayname[dg[i,k]]);
    Memo1.lines.append('______________________');
    memo1.visible:=true
  end
  else
    memo1.visible:=false;

 combobox1.clear;
 if (numDayGroups>1) and (numDayGroups<days) then
  for i:=1 to numDayGroups do combobox1.Items.add('Day Group '+inttostr(i));
 if (numDayGroups=days) then
    for i:=1 to numDayGroups do combobox1.Items.add(dayname[i-1]);
 combobox1.itemindex:=MyDayGroup-1;
 if numDayGroups>1 then
    begin combobox1.visible:=true; label44.visible:=true; label57.visible:=false; end
   else begin combobox1.visible:=false; label44.visible:=false; label57.visible:=true; end;
end;

procedure TAllotDlg.DeleteRow(pGrid: TStringGrid; aRow: Integer);
var
  i, j: Integer;
begin
  //Delete a given row in a string grid
  with pGrid do
  begin
    for i := aRow to RowCount-2 do
      for j := 0 to ColCount-1 do
        Cells[j, i] := Cells[j, i+1];
    RowCount := RowCount - 1
  end;
end;



function TAllotDlg.CountRowsUsed(pGrid:TStringGrid): Integer;
var
  _row, _col: Integer;
begin
  with pGrid do
  begin
    Result := 0;
    for _row:= 0 to RowCount-1 do
      if Trim(Cells[0,_row]) <> ''  then
        Result := _row
      else
        Exit;
  end;

end;

procedure TAllotDlg.InsertTimeSlot(Sender: TObject);
var _CurrentRow: integer;
begin
     InsertRow(grdTimeSlot, grdTimeSlot.Row);
end;


procedure TAllotDlg.InsertRow(pGrid: TStringGrid; aRow: Integer);
var
  _row, _col: Integer;
begin
  if CountRowsUsed(pGrid) >= nmbrPeriods+1 then
  begin
     MessageDlg('All available time slots have been assigned.'+#13+
                'Insert Time Slot: CANCELLED', mtInformation, [mbOK], 0);
     Exit;
  end;
  if MessageDlg('Insert a time slot at current position. Are you sure you want to continue?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;
  //Insert a given row in a string grid
  // Column 0  has to be renumbered
  with pGrid do
  begin
    for _row:= RowCount-2 downto aRow do
      for _col := 0 to ColCount-1 do
        Cells[_col, _row+1] := Cells[_col, _row];
    for _col := 0 to ColCount-1 do
      Cells[_col, _row+1] := '';
    for _row:= 1 to RowCount-1 do
      Cells[0, _row] := inttostr(_row);
  end;
end;

procedure TAllotDlg.DeleteTimeSlot(Sender: TObject);
begin
 // if MessageDlg('Deleting a time slot causes the corresponding time slot in the time table to be cleared. Are you sure you want to continue?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
 //   Exit;
  //begin
    //ShuffleTimeTable(grdTimeSlot.Row)
    DeleteRow(grdTimeSlot, grdTimeSlot.Row);
 //end;
end;

Procedure DoTimeUpdate;
var
 i: integer;
 maxPeriods: smallint;
begin
 MaxPeriods:=0;
 for i:=0 to days-1 do if tlimit[i]>MaxPeriods then MaxPeriods:=tlimit[i];
 CalcWeekMaxLoad;
 CheckResize(years,days,MaxPeriods);
 ConfigureTimetable(days,MaxPeriods,years,ttmainformat);
 initTtUndoStack;
 getTsNameFontWidths;
 UpdateAllWins;
 timechange:=false;
 saveTimeFlag:=true;
end;

procedure SetDayColour(i: integer);
var
 MyRect: Trect;
begin
 DayImage[i].Canvas.Brush.Color:=showGroupColour(DayGroup[i-1]);
 DayImage[i].Canvas.font.Color:=FontGroupColour(DayGroup[i-1]);
 DayImage[i].Canvas.font.Style:=[fsBold];
 MyRect.Left:=DayImage[i].Left;
 MyRect.Top:=DayImage[i].Top;
 MyRect.Right:=MyRect.Left+DayImage[i].Width;
 MyRect.Bottom:=MyRect.Top+DayImage[i].Height;
 DayImage[i].Canvas.FillRect(MyRect);
 DayImage[i].Canvas.TextOut(5,2,inttostr(DayGroup[i-1]));
end;

procedure colourResults2;
var
 i: integer;
begin
 for i:=1 to days do
  begin
   SetDayColour(i);
   DayCheck[i].checked:=false;
   DayCheck[i].color:=showGroupColour(DayGroup[i-1]);
   DayCheck[i].Font.Color:=FontGroupColour(DayGroup[i-1]);
  end;
 if timechange then DoTimeUpdate;
 AllotDlg.label59.caption:=inttostr(numDayGroups);
end;

procedure ChangeDayGroup(myday,newDayGroup: integer);
var
 j,oldDayGroup,oldNumDayGroups,day1:     integer;
begin
 oldNumDayGroups:=NumDayGroups;
 oldDayGroup:=DayGroup[myday];
 DayGroup[myday]:=newDayGroup;
 if (oldDayGroup<>newDayGroup) and (dg[newDayGroup,0]>0) then {joining an existing group}
  begin
   day1:=dg[newDayGroup,1];
   for j:=0 to Tlimit[day1]-1 do
    begin
     TimeSlotName[myday,j]:=TimeSlotName[day1,j];
     tsCode[myday,j]:=tsCode[day1,j];
     tsAllot[myday,j]:=tsAllot[day1,j];
     tsStart[myday,j]:=tsStart[day1,j];
     tsEnd[myday,j]:=tsEnd[day1,j];
    end;
   Tlimit[myday]:=Tlimit[day1];
   timechange:=true;
  end;
 DayGroupCalc;
 if oldNumDayGroups<>NumDayGroups then timechange:=true;
end;

procedure TAllotDlg.myDayColourPress(Sender: TObject);
var
 i: integer;
begin
 if sender is Tbitbtn then
  begin
   Dgroup:=Tbitbtn(Sender).tag;
   for i:=1 to days do
    if DayCheck[i].checked then ChangeDayGroup(i-1,Dgroup);
   colourResults2;
  end;
end;

procedure TAllotDlg.FormCreate(Sender: TObject);
var
 i: integer;
 s: string;
begin
 SaveLoadFileName := GetSpecialFolderPath(CSIDL_COMMON_DOCUMENTS)+'\TimeSlotGrid.txt';
 timechange:=false;
 tmpTslotUnit:=TslotUnit;
 SlotUnits1.ItemIndex:=tmpTslotUnit;
 tmpSlotUnitMain:=SlotUnitMain;
 tmpSlotUnitDec:=SlotUnitDec;
 for i:=1 to days do
  begin
    DayBtn[i]:=tBitBtn.create(application);
    if i<10 then s:='&'+inttostr(i) else s:='1&0';
    DayBtn[i].caption:='&'+inttostr(i);
    DayBtn[i].hint:='Assign selected days to group '+inttostr(i);
    DayBtn[i].parent:=TabSheet3;
    DayBtn[i].tag:=i;
    DayBtn[i].Font.Color:=FontGroupColour(i);
    DayBtn[i].width:=20;  DayBtn[i].height:=20;
    DayBtn[i].top:=177;  DayBtn[i].left:=21*i+13;
    DayBtn[i].onClick:=myDayColourPress;

    DayCol[i]:=tpanel.create(application);
    DayCol[i].Font.Name:='ms san serif';  DayCol[i].Font.Style:=[];
    DayCol[i].hint:='Select days to assign to a group';
    DayCol[i].tag:=i; DayCol[i].AutoSize:=false;
    DayCol[i].parent:=TabSheet3;
    DayCol[i].Font.Color:=FontGroupColour(DayGroup[i-1]);
    DayCol[i].width:=20;  DayCol[i].height:=18;
    DayCol[i].top:=25+24*((i-1) mod 5);  DayCol[i].left:=11+135*((i-1)div 5);

    DayImage[i]:=timage.Create(application);
    DayImage[i].Parent:=DayCol[i];
    DayImage[i].Align:=alClient;
    SetDayColour(i);

    DayCheck[i]:=tcheckbox.create(application);
    DayCheck[i].caption:=Dayname[i-1];
    DayCheck[i].hint:='Select days to assign to a group';
    DayCheck[i].tag:=i;
    DayCheck[i].parent:=TabSheet3;
    DayCheck[i].color:=showGroupColour(DayGroup[i-1]);
    DayCheck[i].Font.Color:=FontGroupColour(DayGroup[i-1]);
    DayCheck[i].width:=100;  DayCheck[i].height:=13;
    DayCheck[i].top:=27+24*((i-1) mod 5);  DayCheck[i].left:=31+135*((i-1)div 5);
  end;
  Dgroup:=1;
  usingResources:=true;
  inLoad:=true;
  MyDayGroup:=1;
  grdTimeSlot.DefaultColWidth:=90;
  pgcTimeSlot.activepage:=TabSheet1;
  inLoad:=false;
end;

procedure TAllotDlg.grdTimeSlotSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
var
  R: TRect;
  i: integer;
begin
  if (ACol = 6) and (ARow <> 0) then
  begin
    R := grdTimeSlot.CellRect(ACol, ARow);
    R.Left := R.Left + grdTimeSlot.Left;
    R.Right := R.Right + grdTimeSlot.Left;
    R.Top := R.Top + grdTimeSlot.Top;
    R.Bottom := R.Bottom + grdTimeSlot.Top;
    with cmbType do
    begin
      try
        I := StrToInt(grdTimeSlot.Cells[ACol,ARow]);
      except
        I := 0;
      end;
      ItemIndex := i;
      R.Left := R.Left - 60;
      Left := R.Left + 1;
      Top := R.Top + 1;
      Width := (R.Right + 1) - R.Left;
      Height := (R.Bottom + 1) - R.Top;
      Visible := True;
      SetFocus;
    end;
  end;
  CanSelect := True;
end;


procedure TAllotDlg.FilterEntryData(Sender: TObject; var Key: Char);
begin
  if (Key = '''') or (Key = '"') then   //No opostrophy or double qoute
    Key := Chr(0);
end;

procedure TAllotDlg.SetGridSelection(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  lCol, lRow: Integer;
begin
  grdTimeSlot.MouseToCell(X, Y, lCol, lRow);
  if lRow <> grdTimeSlot.RowCount then
  begin
    if lCol = 0 then
    begin
      grdTimeSlot.Options := grdTimeSlot.Options + [goRowSelect];
      grdTimeSlot.Options := grdTimeSlot.Options - [goEditing];
      grdTimeSlot.Row := lRow;
    end
    else
    begin
      grdTimeSlot.Options := grdTimeSlot.Options + [goEditing];
      grdTimeSlot.Options := grdTimeSlot.Options - [goRowSelect];
    end;
  end;
  grdTimeSlot.Refresh;
end;

procedure TAllotDlg.BitBtn4Click(Sender: TObject);
var
 i:  integer;
begin
 for i:=1 to days do ChangeDayGroup(i-1,1);
 colourResults2;
end;

procedure TAllotDlg.BitBtn5Click(Sender: TObject);
var
 i:  integer;
begin
 for i:=1 to days do ChangeDayGroup(i-1,i);
 colourResults2;
end;

procedure TAllotDlg.btnLoadFromFileClick(Sender: TObject);
var
 f:          TextFile;
  iTmp, i, k: Integer;
  strTemp:    String;
begin
  if MessageDlg('Replace this configuration with previously saved settings?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    exit;
  AssignFile(f, SaveLoadFileName);
  Reset(f);
  with grdTimeSlot do
  begin
    // Get number of columns
    Readln(f, iTmp);
    ColCount := iTmp;
    // Get number of rows
    Readln(f, iTmp);
    RowCount := iTmp;
    // loop through cells & fill in values
    for i := 0 to ColCount - 1 do
      for k := 0 to RowCount - 1 do
      begin
        Readln(f, strTemp);
        Cells[i, k] := strTemp;
      end;
  end;
  CloseFile(f);
end;

procedure TAllotDlg.btnSaveToFileClick(Sender: TObject);
var
  f:    TextFile;
  i, k: Integer;
begin
  if MessageDlg('Save this configuration for latter use?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    exit;
  doAssignFile(f, SaveLoadFileName);
  Rewrite(f);
  with grdTimeSlot do
  begin
    // Write number of Columns/Rows
    Writeln(f, ColCount);
    Writeln(f, RowCount);
    // loop through cells
    for i := 0 to ColCount - 1 do
      for k := 0 to RowCount - 1 do
        Writeln(F, Cells[i, k]);
  end;
  CloseFile(F);
end;


procedure TAllotDlg.FormActivate(Sender: TObject);
begin
 configGrid;
end;

procedure TAllotDlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
 i:     integer;
begin
 if usingResources then   {can call close even after closeed it seems}
  begin
   usingResources:=false;
   AllotDlg.hide; {prevent seeing controls beeing removed -slows things down a lot}
   for i:=1 to days do
    begin
     DayBtn[i].Free;
     DayCol[i].Free;
     DayCheck[i].Free;
    end;
  end;
 if wnFlag[wnTimes] then TimesWindow.UpdateWin;
end;

procedure TAllotDlg.TabSheet3Exit(Sender: TObject);
begin
 configGrid;
end;

procedure TAllotDlg.RefreshTimeSlots(Sender: TObject);
var
 getindex: integer;
begin
 getindex:=1+ComboBox1.ItemIndex;
 if (getindex>0) and (getindex<>MyDayGroup) then
  begin
   MyDayGroup:=getindex;
   fillGrid;
  end;
end;

procedure TAllotDlg.SetTimeSlots(Sender: TObject);
var
 i,d,p,tmpTlimit: smallint;
 sss,msg:     string;
 dd:      double;
 SRect: TGridRect;
 erCode:   integer;
 j: Integer;

 procedure SetGrid(c,r: smallint);
 begin
  SRect.Top:=r; SRect.Left:=c;
  SRect.Bottom:=r; SRect.Right:=c;
  grdTimeSlot.Selection:=SRect;
  grdTimeSlot.SetFocus;
 end;

begin  {validate}
 //determine max number of periods set by checking names
 tmpTlimit:=0;
 for p:=nmbrPeriods downto 1 do             
  begin
   sss:=grdTimeSlot.cells[1,p];
   if trim(sss)>'' then
    begin
     tmpTlimit:=p;
     break;
    end;
   end;

 if ((tmpTlimit<2) or (tmpTlimit>nmbrPeriods)) then
  begin
   msg:='Invalid number of time slots. '+endline;
   msg:=msg+'Enter a name for at least two time slots.';
   messagedlg(msg,mtError,[mbOK],0);
   SetGrid(1,1);
   exit;
  end;

// prevent discontinuous set of timeslots used by flagging blank periodnames as invalid
 if tmpTlimit>0 then
  for p:=tmpTlimit downto 1 do   {prevent empty periodnames from discontinuous sets}
   begin
    sss:=trim(grdTimeSlot.cells[1,p]);
    if (length(sss)=0) then
     begin
      msg:='Invalid Period Name. '+chr(10);
      msg:=msg+'Period Names cannot be left blank.';
      messagedlg(msg,mtError,[mbOK],0);
      SetGrid(1,p);
      exit;
     end;
   end;
{check time slot codes}
  if tmpTlimit>0 then
  for p:=tmpTlimit downto 1 do
    begin
      sss := trim(grdTimeSlot.cells[2,p]);
      if (length(sss)<>1) then
      begin
        msg:='Enter single character code';
        messagedlg(msg,mtError,[mbOK],0);
        SetGrid(2,p);
        exit;
      end
      else
      begin
        for j := p downto 1 do
        begin
          if sss = Trim(grdTimeSlot.Cells[2, j -1]) then
          begin
            MessageDlg('code ' + sss + ' is duplicate. Try another code.', mtError, [mbOK], 0);
            grdTimeSlot.Col := 2;
            grdTimeSlot.Row := p;
            Exit;
          end;
        end;
      end;
   end;
{check time allotments}
 if tmpTlimit>0 then
  for p:=tmpTlimit downto 1 do
   begin
    sss:=grdTimeSlot.cells[3,p];
    val(sss,dd,erCode);
    if ((dd<0) or (dd>5000)) then
     begin
      msg:='Enter allotment from 0 to 5000!';
      messagedlg(msg,mtError,[mbOK],0);
      SetGrid(3,p);
      exit;
     end;
   end;

{check start times}
 if tmpTlimit>0 then
  for p:=tmpTlimit downto 1 do
   try
    sss:=grdTimeSlot.cells[4,p];
    tmptsStart[p]:=StrToTime(sss);
   except
    on EConvertError do
     begin
      msg:='Enter start time!';
      messagedlg(msg,mtError,[mbOK],0);
      SetGrid(4,p);
      exit;
     end;
   end;
{check end times}
 if tmpTlimit>0 then
  for p:=tmpTlimit downto 1 do
   try
    sss:=grdTimeSlot.cells[5,p];
    tmptsEnd[p]:=StrToTime(sss);
    if (tmptsEnd[p] = 0) and (tmptsStart[p] > 0.5) and (tmptsStart[p] < 1) then
      tmptsEnd[p] := 1; // this is to handle 12:00am scenario
   except
    on EConvertError do
     begin
      msg:='Enter end time!';
      messagedlg(msg,mtError,[mbOK],0);
      SetGrid(5,p);
      exit;
     end;
   end;
{check end time not <= start time}
 if tmpTlimit>0 then
  for p:=tmpTlimit downto 1 do
   if tmptsEnd[p]<=tmptsStart[p] then
    begin
     msg:='End time should be later than Start time!';
     messagedlg(msg,mtError,[mbOK],0);
     SetGrid(5,p);
     exit;
    end;
// no errors, so insert data
 d:=dg[MyDayGroup,1];
 if tmpTlimit<tlimit[d] then
  begin
   Msg:='Reducing the number of time slots will lose entries after time slot '
    + inttostr(tmpTlimit)+'.'+cr+
    'There is no Undo from this operation.  Continue?';
   if messagedlg(Msg,mtWarning,[mbyes,mbno],0)<>mrYes then exit;
  end;

 for i:=1 to dg[MyDayGroup,0] do
  begin
   d:=dg[MyDayGroup,i];
   tlimit[d]:=tmpTlimit;
   for p:=1 to tlimit[d] do  {get values}
    begin
     sss:=grdTimeSlot.cells[1,p];
     TimeSlotName[d,p-1]:=trim(sss);
     sss:=grdTimeSlot.cells[2,p];
     tsCode[d,p-1]:=trim(sss);
     sss:=grdTimeSlot.cells[3,p];
     val(sss,dd,erCode);
     tsAllot[d,p-1]:=dd;
     tsStart[d,p-1]:=tmptsStart[p];
     tsEnd[d,p-1]:=tmptsEnd[p];
     try
       tsType[d,p-1]:=StrToInt(grdTimeSlot.cells[6,p]);
     except
       tsType[d,p-1]:=0;
     end;
    end;
  end; {for i}

 TslotUnit:=SlotUnits1.ItemIndex;
 if TslotUnit=0 then
   begin SlotUnitDec:=0; SlotUnitMain:=5; end
    else begin SlotUnitDec:=2; SlotUnitMain:=6; end;

 DoTimeUpdate;
end;

procedure TAllotDlg.SlotUnits1Click(Sender: TObject);
begin
 if tmpTslotUnit<>SlotUnits1.ItemIndex then
  begin
   tmpTslotUnit:=SlotUnits1.ItemIndex;
   if tmpTslotUnit=0 then
   begin tmpSlotUnitDec:=0; tmpSlotUnitMain:=5; end
    else begin tmpSlotUnitDec:=2; tmpSlotUnitMain:=6; end;
   grdTimeSlot.cells[3,0]:=TslotUnitName[tmpTslotUnit];
   grdTimeSlot.ColWidths[3]:=canvas.TextWidth(TslotUnitName[tmpTslotUnit]+'  ');
  end;
end;

end.
