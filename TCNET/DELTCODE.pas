unit Deltcode;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, TimeChartGlobals, GlobalToTcAndTcextra,
  XML.DISPLAY, XML.TEACHERS;

type
  Tdeltcodedlg = class(TForm)
    finish: TBitBtn;
    delete: TBitBtn;
    BitBtn3: TBitBtn;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Edit1: TEdit;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label6: TLabel;
    FacLabel1: TLabel;
    Label10: TLabel;
    FacLabel3: TLabel;
    Label8: TLabel;
    FacLabel2: TLabel;
    FacLabel4: TLabel;
    Label26: TLabel;
    btnNextTe: TButton;
    btnPreviousTe: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DeleteTeacher(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GoNext(Sender: TObject);
    procedure GoPrevious(Sender: TObject);
  private
    FSelTeacher: Integer;
    myTe: Integer;
    needUpdate: Boolean;
    procedure ShowTeacher;
    procedure Restore;
    procedure Restore1;
    procedure SetButtons;
  end;

var
  deltcodedlg: Tdeltcodedlg;

implementation

uses
  tcommon, DlgCommon, tcommon2, TeWnd;

{$R *.DFM}

procedure Tdeltcodedlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action:=caFree;
  if needUpdate then
  begin
    UpdateSub(1);  {update teacher data files}
  end;
end;

procedure Tdeltcodedlg.Restore;
begin
  label13.Caption:=inttostr(codeCount[1]);
  myTe := CodePoint[FSelTeacher, 1];
  if FSelTeacher > 0 then
  begin
    Edit1.Text := Trim(XML_TEACHERS.TeCode[myTe, 0]);
    Label3.Caption := Trim(XML_TEACHERS.TeName[myTe, 0]);
  end
  else
  begin
    Edit1.Text := '';
    Label3.Caption := '';
  end;

  if Edit1.Visible and Edit1.Enabled then
    Edit1.setfocus;
end;

procedure Tdeltcodedlg.Restore1;
begin
 label3.caption:=''; label5.caption:=''; FacLabel1.caption:='';
 FacLabel2.caption:='';  FacLabel3.caption:=''; FacLabel4.caption:='';
 label20.caption:='';  label21.caption:=''; label22.caption:='';
 label23.caption:='';  label24.caption:=''; label25.caption:='';
end;

procedure Tdeltcodedlg.DeleteTeacher(Sender: TObject);
var
  codeStr: string;
begin
  if NoCodesAvail(codeCount[1],'Teacher Codes') then exit;
  if NoCode(codeStr,edit1) then exit;
  if CodeNotFound(myTe,1,edit1) then exit;
  needUpdate:=true;
  XML_TEACHERS.TeCode[myTe,0]:=StringPad(lenCodes[1],48);
  XML_TEACHERS.TeName[myTe,0]:='';
  if (TeWindow.selcode=myTe) then TeWindow.selcode:=-1; {cancel selection}

  XML_TEACHERS.Load[myTe]:=-1;
  XML_TEACHERS.Tfaculty[myTe,1]:=-1;  XML_TEACHERS.Tfaculty[myTe,2]:=0;
  XML_TEACHERS.Tfaculty[myTe,3]:=0;   XML_TEACHERS.Tfaculty[myTe,4]:=0;
  if myTe=Numcodes[1] then dec(NumCodes[1]);

  sortCodes(1);

  {update font widths if necessary}
  getCodeFontWidths(1);
  getTeDutyCodeFontWidths;
  TeWindow.UpdateWin;
  UpdateWindow(wnInfo);

  rangeCheckCodeSels(XML_DISPLAY.tettselection,1);
  rangeCheckCodeSels(XML_DISPLAY.ttPrntSelTeachg,1);
  rangeCheckSubSels(XML_DISPLAY.GrpOfTeSelSubg);
  rangeCheckCodeSels(XML_DISPLAY.TeFreeSelect,1);
  rangeCheckCodeSels(XML_DISPLAY.TeTimesSelect,1);
  rangeCheckCodeSels(XML_DISPLAY.TeListSelection,1);
  if winView[wnFac]>0 then UpdateWindow(wnFac);
  UpdateTimeTableWins;

  if FSelTeacher > CodeCount[1] then
    Dec(FSelTeacher);
  Restore;
end;

procedure Tdeltcodedlg.SetButtons;
begin
  btnNextTe.Enabled := FSelTeacher < CodeCount[1];
  btnPreviousTe.Enabled := FSelTeacher > 1;
  Delete.Enabled := myTe > 0;
end;

procedure Tdeltcodedlg.showteacher;
var
 s:  string;
begin
 label3.caption:=XML_TEACHERS.TeName[myTe,0];
 checkTeFaculty(XML_TEACHERS.Tfaculty[myTe,1],XML_TEACHERS.Tfaculty[myTe,2],XML_TEACHERS.Tfaculty[myTe,3],XML_TEACHERS.Tfaculty[myTe,4]);
 if XML_TEACHERS.Tfaculty[myTe,1]=-1 then FacLabel1.caption:='*' else FacLabel1.caption:=facName[XML_TEACHERS.Tfaculty[myTe,1]];
 FacLabel2.caption:=facName[XML_TEACHERS.Tfaculty[myTe,2]];
 FacLabel3.caption:=facName[XML_TEACHERS.Tfaculty[myTe,3]];
 FacLabel4.caption:=facName[XML_TEACHERS.Tfaculty[myTe,4]];

 s:='';  if XML_TEACHERS.Load[myTe]<0 then s:=inttostr(periods*days);
 if XML_TEACHERS.Load[myTe]>0 then s:=inttostr(XML_TEACHERS.Load[myTe]);
 label5.caption:=s;
 label20.caption:=trim(XML_TEACHERS.DutyCode[myTe,0]);
 label22.caption:=trim(XML_TEACHERS.DutyCode[myTe,1]);
 label24.caption:=trim(XML_TEACHERS.DutyCode[myTe,2]);
 if XML_TEACHERS.DutyLoad[myTe,0]<>0 then
  begin
   str(XML_TEACHERS.DutyLoad[myTe,0]:4:2,s);  label21.caption:=s;
  end
   else label21.caption:='';
 if XML_TEACHERS.DutyLoad[myTe,1]<>0 then
  begin
   str(XML_TEACHERS.DutyLoad[myTe,1]:4:2,s);  label23.caption:=s;
  end
   else label23.caption:='';
 if XML_TEACHERS.DutyLoad[myTe,2]<>0 then
  begin
   str(XML_TEACHERS.DutyLoad[myTe,2]:4:2,s);  label25.caption:=s;
  end else label25.caption:='';
end;

procedure Tdeltcodedlg.FormActivate(Sender: TObject);
begin
 {init here}
 ensureSizeForFont(tform(deltcodedlg));
 edit1.maxlength:=lencodes[1];
 needUpdate:=false;
 label13.caption:=inttostr(codeCount[1]);

 if (TeWindow.SelCode > 0) then
   FSelTeacher := TeWindow.SelCode
 else
   FSelTeacher := 0;
 if FSelTeacher > 0 then
  begin
   myTe := codepoint[FSelTeacher, 1];
   edit1.Text := TrimRight(XML_TEACHERS.tecode[myTe,0]);
   showteacher;
  end
 else restore;
end;

procedure Tdeltcodedlg.Edit1Change(Sender: TObject);
var
 codeStr:       string;
begin
 {change check here}
 codeStr:=TrimRight(edit1.text);
 myTe:=checkCode(1,codeStr);
 if myTe>0 then showteacher else restore1;
 SetButtons;
end;

procedure Tdeltcodedlg.FormCreate(Sender: TObject);
begin
 TopCentre(self);
end;

procedure Tdeltcodedlg.GoNext(Sender: TObject);
begin
  if FSelTeacher <= codeCount[1] then
  begin
    Inc(FSelTeacher);
    Restore;
  end;
end;

procedure Tdeltcodedlg.GoPrevious(Sender: TObject);
begin
  Dec(FSelTeacher);
  if FSelTeacher < 1 then
    FSelTeacher := 1;
  Restore;
end;

end.
