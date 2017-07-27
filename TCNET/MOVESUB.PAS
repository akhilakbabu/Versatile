unit Movesub;

interface

uses SysUtils,WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls,Dialogs,Grids,TimeChartGlobals, GlobalToTcAndTcextra, XML.DISPLAY;

type
  TMoveSubDlg = class(TForm)
    MoveBtn: TBitBtn;
    HelpBtn: TBitBtn;
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Edit2: TEdit;
    Label5: TLabel;
    Finish: TBitBtn;
    CopyBtn: TBitBtn;
    Step: TBitBtn;
    cboMoveSubjectSubject: TComboBox;
    procedure FindBlockDetails(Sender: TObject);
    procedure MoveBtnClick(Sender: TObject);
    procedure CopyBtnClick(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FinishClick(Sender: TObject);
    procedure StepClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure Restore;
  end;

var
  MoveSubDlg: TMoveSubDlg;

implementation

{$R *.DFM}

uses tcommon,DlgCommon,block1,subyr,tcommon2,tcommon5;

var
  sub1,fromblock,toblock,sublevel:  integer;
  yearpos:       integer;

procedure TMoveSubDlg.Restore;
begin
  Sub1:=0; fromblock:=0; toblock:=0;
  //Edit1.Text:='';
  cboMoveSubjectSubject.ItemIndex := -1;
  Edit2.Text := '';
  label3.Caption := '';
  label5.Caption := '';
  //Edit1.SetFocus;
  if cboMoveSubjectSubject.Visible and cboMoveSubjectSubject.Enabled then
    cboMoveSubjectSubject.SetFocus;
end;

procedure TMoveSubDlg.FindBlockDetails(Sender: TObject);
var
 codeStr: string;
 codePlace: Integer;
begin
  {change check here}
  //codeStr:=trim(edit1.text);
  codeStr := Trim(cboMoveSubjectSubject.Text);
  codePlace := checkCode(0, codestr);
  if codePlace > 0 then
  begin
   Sub1 := codePlace;
   label5.Caption := Subname[Sub1];
   fromblock := findblock(Sub1, sublevel);
   label3.Caption := IntToStr(fromblock);
  end
  else
  begin
    Sub1 := 0;
    label5.Caption := '';
    fromblock := 0;
    label3.caption := '';
  end;
end;

procedure TMoveSubDlg.MoveBtnClick(Sender: TObject);
var
 msg,s:   String;
 k: smallint;
 NewBlock: integer;
begin
  //Set Sub1 to 0 here to force it to use the Subject from the combo box
  Sub1:=0;
  if Sub1=0 then
  begin
   //s:=trim(edit1.text);
   s := Trim(cboMoveSubjectSubject.Text);
   k := checkCode(0, s);
   addSubToGroupSubs(k);
   sub1 := k;
   fromblock := 0;
  end;
  toblock := IntFromEdit(edit2);
  msg := '';
  // Added the check for <>0 to finalise the fix for #7 ie. let it move off to block 0 then back onto 1 again
  if ((toblock = fromblock) and (toblock <> 0)) then
    msg := SubCode[Sub1] + ' is already in block ' + IntToStr(fromblock);
  if (toblock<0) or (toblock>XML_DISPLAY.blocknum) then
    msg := 'Enter block number in the range 0 to ' + IntToStr(XML_DISPLAY.blocknum)
  else if (toblock > 0) and (Sheet[toblock,0] >= levelprint) then
    msg := 'No room in block '+inttostr(toblock)+' to move '+SubCode[Sub1];
  if msg > '' then
  begin
    ShowMsg(msg,edit2);
    Exit;
  end;
  NewBlock := toblock;
  blockchange(Sub1,toblock);
  restore;
  settop;
  updateBlockWindow;
  label3.Caption := inttostr(NewBlock);
  SaveBlockFlag:=True;
end;


procedure TMoveSubDlg.CopyBtnClick(Sender: TObject);
var
 msg:   String;
 locate,j:   integer;
begin
 if Sub1=0 then
  begin
    //ShowMsg('Enter subject to copy',edit1);
    MessageDlg('Enter subject to copy', mtError, [mbOK], 0);
    if cboMoveSubjectSubject.Visible and cboMoveSubjectSubject.Enabled then
    begin
      cboMoveSubjectSubject.SetFocus;
      cboMoveSubjectSubject.SelectAll;
    end;
    Exit;
  end;
  toblock := IntFromEdit(edit2);
  msg := '';
  if (toblock=fromblock) then
    msg := 'Cannot copy '+SubCode[Sub1]+' to same block ';
  if (toblock < 1) or (toblock > XML_DISPLAY.blocknum) then
    msg := 'Enter block number in the range 1 to ' + IntToStr(XML_DISPLAY.blocknum)
   else if (toblock>0) and (Sheet[toblock,0]>=levelprint) then
     msg := 'No room in block ' + IntToStr(toblock)+' to copy ' + SubCode[Sub1];
  if msg > '' then
  begin
    ShowMsg(msg,edit2);
    Exit;
  end;
  if fromblock=0 then
    Blocktop[yearpos]:=0;
  locate:=0;
  for j:=1 to levelprint do
    if Sheet[toblock,j]=0 then
    begin
      Sheet[toblock,j]:=Sub1;
      locate:=j;
      Sheet[toblock,0]:=Sheet[toblock,0]+1;
      break;
    end;
  if locate>XML_DISPLAY.blocklevel then XML_DISPLAY.blocklevel:=locate;
  restore;
  settop;
  updateBlockWindow;
  SaveBlockFlag:=True;
end;

procedure TMoveSubDlg.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
 allowNumericInputOnly(key);
end;

procedure TMoveSubDlg.FormCreate(Sender: TObject);
begin
  topcentre(self);
  //edit1.text:='';
  cboMoveSubjectSubject.ItemIndex := -1;
  edit2.text:='';
  label3.caption:='';
  label5.caption:='';
end;

procedure TMoveSubDlg.FormShow(Sender: TObject);
var
  SRect: TGridRect;
  i, j: Integer;
begin
  //Edit1.Maxlength := lencodes[0];
  Edit2.Maxlength := 2;
  SRect := BlockWin.StringGrid1.Selection;
  i := SRect.Left + 1;
  j := SRect.Top;
  //edit1.SetFocus;
  if cboMoveSubjectSubject.Visible and cboMoveSubjectSubject.Enabled then
    cboMoveSubjectSubject.SetFocus;
  if (i > 0) and (i <= XML_DISPLAY.blocknum) then
    if (j > 0) and (j <= Sheet[i, 0]) then
    begin
      Sub1 := Sheet[i, j];
      //Edit1.Text := SubCode[Sub1];
      fromblock := i;
      label3.caption := IntToStr(i);
      label5.caption := Subname[Sub1];
      Edit2.SetFocus;
    end;
  for j := 1 to codeCount[0] do
    cboMoveSubjectSubject.Items.Add(subcode[codepoint[j, 0]]);
  cboMoveSubjectSubject.ItemIndex := cboMoveSubjectSubject.Items.IndexOf(SubCode[Sub1]);
end;

procedure TMoveSubDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 action:=cafree; fMoveSubDlgUp:=false;
 if ((usrPassLevel=utTime) or (usrPassLevel=utSuper) or (usrPassLevel=3)) then
  if not(saveBlockFlag) then CheckAccessRights(utBlock,40,false)
end;

procedure TMoveSubDlg.FinishClick(Sender: TObject);
begin
 close;
end;

procedure TMoveSubDlg.StepClick(Sender: TObject);
var
 i:       smallint;
 msg,s:     string;
begin
  i:=strtointdef(label3.caption,-1);
  if i>-1 then
  begin
    inc(i);
    if i>XML_DISPLAY.blocknum then
      i:=0;
    edit2.text := IntToStr(i);
    //s := edit1.text;
    s := cboMoveSubjectSubject.Text;
    MoveBtnClick(MoveBtn);
    //edit1.text:=s;
    cboMoveSubjectSubject.Text := s;
    //edit1.setfocus;
    //edit1.selectall;
    if cboMoveSubjectSubject.Visible and cboMoveSubjectSubject.Enabled then
    begin
      cboMoveSubjectSubject.SetFocus;
      cboMoveSubjectSubject.SelectAll;
    end;
  end
  else
  begin
    msg := 'No subject selected';
    messagedlg(msg, mtError, [mbOK], 0);
  end;
end;

end.


