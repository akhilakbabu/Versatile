unit Fixsub;

interface

uses SysUtils,WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, Dialogs,TimeChartGlobals,GlobalToTcAndTcextra, XML.DISPLAY;

type
  TFixSubDlg = class(TForm)
    HelpBtn: TBitBtn;
    SetBtn: TBitBtn;
    AddBtn: TBitBtn;
    RemoveBtn: TBitBtn;
    ClearBtn: TBitBtn;
    Finish: TBitBtn;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label2: TLabel;
    Edit2: TEdit;
    cboFixSubjectsSubject: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FindBlockDetails(Sender: TObject);
    procedure AddBtnClick(Sender: TObject);
    procedure SetBtnClick(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
    procedure RemoveBtnClick(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
  private
    FSubjectNo: Integer;
  public
    property SubjectNo: Integer read FSubjectNo write FSubjectNo;
  end;

var
  FixSubDlg: TFixSubDlg;

implementation

{$R *.DFM}
uses tcommon,StCommon,DlgCommon,block1,subyr;
var
 Sub1,fromblock,toblock,sublevel,yearpos:  integer;

procedure restore;
begin
  countsubsinblock;
  Sub1:=0;
  fromblock:=0;
  toblock:=0;
  sublevel:=0;
  yearpos:=0;
  if Fixcount = 0 then
  begin
    FixSubDlg.RemoveBtn.Enabled:=false;
    FixSubDlg.ClearBtn.Enabled:=False;
  end
  else
  begin
    FixSubDlg.RemoveBtn.Enabled:=true;
    FixSubDlg.ClearBtn.Enabled:=true;
  end;
  if subsinblock=0 then
    FixSubDlg.SetBtn.Enabled := False
  else
    FixSubDlg.SetBtn.Enabled := True;
  //FixSubDlg.Edit1.text:='';
  FixSubDlg.cboFixSubjectsSubject.ItemIndex := -1;
  FixsubDlg.Label5.Caption := IntToStr(Fixcount);
  //FixSubDlg.Edit1.setfocus;
  if FixSubDlg.cboFixSubjectsSubject.Visible and FixSubDlg.cboFixSubjectsSubject.Enabled then
    FixSubDlg.cboFixSubjectsSubject.SetFocus;
end;

procedure TFixSubDlg.FormCreate(Sender: TObject);
begin
 topcentre(self);
end;

procedure TFixSubDlg.FormShow(Sender: TObject);
var
  j: Integer;
begin
  //Edit1.Maxlength:=lencodes[0];
  Edit2.Maxlength := 2;
  Restore;
  for j := 1 to codeCount[0] do
    cboFixSubjectsSubject.Items.Add(subcode[codepoint[j, 0]]);
  cboFixSubjectsSubject.ItemIndex := cboFixSubjectsSubject.Items.IndexOf(SubCode[FSubjectNo]);
  FindBlockDetails(sender);
end;

procedure TFixSubDlg.FindBlockDetails(Sender: TObject);
var
  codeStr: string;
  codePlace: Integer;
begin
  {change check here}
  //codeStr := Trim(edit1.text);
  CodeStr := cboFixSubjectsSubject.Text;
  codePlace := checkCode(0, codestr);
  yearpos := findsubyear(codePlace);
  if yearpos > 0 then
  begin
    Sub1 := codePlace;
    label3.caption := Subname[Sub1];
    fromblock := findblock(Sub1,sublevel);
    if fromblock > 0 then
      edit2.text := IntToStr(fromblock);
  end
  else
  begin
    Sub1 := 0;
    label3.Caption := '';
    fromblock := 0;
  end;
end;

procedure TFixSubDlg.AddBtnClick(Sender: TObject);
var
 msg:   String;
 j:       integer;
 selectedsub: integer;
begin
  if Sub1=0 then
  begin
    //ShowMsg('Enter subject to fix',edit1);
    MessageDlg('Enter subject to fix', mtError, [mbOK], 0);
    if cboFixSubjectsSubject.Visible and cboFixSubjectsSubject.Enabled then
    begin
      cboFixSubjectsSubject.SetFocus;
      cboFixSubjectsSubject.SelectAll;
    end;
    Exit;
  end;
  toblock:=IntFromEdit(edit2);
  msg:='';
  if (toblock=fromblock) and (toblock>0) and (sublevel<=fix[toblock]) then
    msg:=Subcode[Sub1]+' is already fixed in block '+inttostr(toblock);
  if (toblock<1) or (toblock>XML_DISPLAY.blocknum) then
    msg:='Enter block number in the range 1 to '+inttostr(XML_DISPLAY.blocknum)
  else if (toblock>0) and (fromblock<>toblock) and (Sheet[toblock,0]>=levelprint) then
    msg:='No room in block '+inttostr(toblock)+' to move '+Subcode[Sub1];
  if msg>'' then
  begin
    ShowMsg(msg,edit2);
    Exit;
  end;
  //#86 - remember which subject (from the combo box)
  selectedsub := cboFixSubjectsSubject.ItemIndex;
  if fromblock<>toblock then blockchange(Sub1,toblock);
  toblock:=findblock(Sub1,sublevel);
  if sublevel>fix[toblock] then
    for j:=sublevel-1 downto fix[toblock]+1 do  begin
      swapint(Sheet[toblock,j],Sheet[toblock,j+1]);
      BlockWin.MoveFocusUp1;
    end;
  inc(fix[toblock]);
  checkfix;
  restore;
  settop;
  updateBlockWindow;
  SaveBlockFlag:=True;
  //#86 - reset combobox from the subject that was remembered
  cboFixSubjectsSubject.ItemIndex := selectedsub;
  FindBlockDetails(sender);
end;

procedure TFixSubDlg.SetBtnClick(Sender: TObject);
var
 j:  integer;
begin
 for j:=1 to XML_DISPLAY.blocknum do
  fix[j]:=Sheet[j,0];
 checkfix;
 restore;
 settop;
 updateBlockWindow;
 SaveBlockFlag:=True;
end;

procedure TFixSubDlg.ClearBtnClick(Sender: TObject);
var
 j:  integer;
begin
 for j:=1 to XML_DISPLAY.blocknum do
  fix[j]:=0;
 checkfix;
 restore;
 settop;
 updateBlockWindow;
 SaveBlockFlag:=True;
end;

procedure TFixSubDlg.RemoveBtnClick(Sender: TObject);
var
 j:       integer;
 selectedsub: integer;
begin
 if Sub1=0 then
  begin
   //ShowMsg('Enter fixed subject to remove',edit1);
    MessageDlg('Enter fixed subject to remove', mtError, [mbOK], 0);
    if cboFixSubjectsSubject.Visible and cboFixSubjectsSubject.Enabled then
    begin
      cboFixSubjectsSubject.SetFocus;
      cboFixSubjectsSubject.SelectAll;
    end;
    Exit;
  end;
  if (fromblock=0) or (fix[fromblock]<sublevel) then
  begin
    //ShowMsg(subcode[Sub1]+' is not fixed',edit1);
    MessageDlg(subcode[Sub1] + ' is not fixed', mtError, [mbOK], 0);
    if cboFixSubjectsSubject.Visible and cboFixSubjectsSubject.Enabled then
    begin
      cboFixSubjectsSubject.SetFocus;
      cboFixSubjectsSubject.SelectAll;
    end;
    Exit;
  end;
  //#86 - remember which subject (from the combo box)
  selectedsub := cboFixSubjectsSubject.ItemIndex;
  Dec(fix[fromblock]);
  checkfix;
  if sublevel<(fix[fromblock]+1) then
    for j:=sublevel to fix[fromblock] do
      swapint(Sheet[fromblock,j],Sheet[fromblock,j+1]);
  restore;
  settop;
  updateBlockWindow;
  SaveBlockFlag:=True;
  //#86 - reset combobox from the subject that was remembered
  cboFixSubjectsSubject.ItemIndex := selectedsub;
  FindBlockDetails(sender);
end;

procedure TFixSubDlg.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
 allowNumericInputOnly(key);
end;

end.

