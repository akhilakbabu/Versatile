unit Edtcode;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, TimeChartGlobals, ComCtrls, XML.TEACHERS;

type
  Tedtcodedlg = class(TForm)
    update: TBitBtn;
    finish: TBitBtn;
    BitBtn3: TBitBtn;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    edtTeacherCode: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label16: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label18: TLabel;
    cboFaculty1: TComboBox;
    cboFaculty2: TComboBox;
    cboFaculty3: TComboBox;
    cboFaculty4: TComboBox;
    btnPreviousTe: TButton;
    btnNextTe: TButton;
    edtTeacherName: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure UpdateTeacher(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure edtTeacherCodeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit7KeyPress(Sender: TObject; var Key: Char);
    procedure Edit9KeyPress(Sender: TObject; var Key: Char);
    procedure GoPrevious(Sender: TObject);
    procedure GoNext(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    myTe: Integer;
    needUpdate: Bool;
    FTeacherNo: Integer;
    procedure ShowTeacher;
    procedure Restore;
    procedure Restore1;
    function ValidateData: Boolean;
    function TeacherAlreadyUsed(var CodeStrNew: string; myCode, Code: Integer): Boolean;
    procedure ChangeTeacher(const pStatus: Integer);
  end;

var
  edtcodedlg: Tedtcodedlg;

implementation

uses
  tcommon,DlgCommon,main,Tewnd;

{$R *.DFM}

procedure Tedtcodedlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if needUpdate then updateSub(1); {update teacher data files}
end;

procedure Tedtcodedlg.Restore;
begin
  edtTeacherCode.Text := '';
  Restore1;
  if edtTeacherCode.Visible and edtTeacherCode.Enabled then
    edtTeacherCode.SetFocus;
end;

procedure Tedtcodedlg.restore1;
begin
  edtTeacherName.Clear;
  edit2.text:=''; edit3.text:='';
  edit7.text:=''; edit8.text:=''; edit9.text:=''; edit10.text:=''; edit11.text:='';
  edit12.text:=''; edit13.text:='';
end;

procedure Tedtcodedlg.ShowTeacher;
var
 s: string;
  i: Integer;
begin
 edtTeacherName.Text := XML_TEACHERS.TeName[myTe,0];
 edit2.text:=XML_TEACHERS.TeName[myTe,0];
 s:=XML_TEACHERS.tecode[myTe,0];
 edit3.text:=TrimRight(s);
 checkTeFaculty(XML_TEACHERS.Tfaculty[myTe,1],XML_TEACHERS.Tfaculty[myTe,2],XML_TEACHERS.Tfaculty[myTe,3],XML_TEACHERS.Tfaculty[myTe,4]);
 if XML_TEACHERS.Load[myTe]=-1 then edit7.text:=inttostr(WeekMaxLoad)
  else
   begin
    if XML_TEACHERS.Load[myTe]<>0 then edit7.text:=inttostr(XML_TEACHERS.Load[myTe])
     else edit7.text:='';
   end;

 edit8.text:=trim(XML_TEACHERS.DutyCode[myTe,0]);
 edit10.text:=trim(XML_TEACHERS.DutyCode[myTe,1]);
 edit12.text:=trim(XML_TEACHERS.DutyCode[myTe,2]);
 if XML_TEACHERS.DutyLoad[myTe,0]<>0 then
  begin
   str(XML_TEACHERS.DutyLoad[myTe,0]:4:2,s);  edit9.text:=s;
  end
   else edit9.text:='';
 if XML_TEACHERS.DutyLoad[myTe,1]<>0 then
  begin
   str(XML_TEACHERS.DutyLoad[myTe,1]:4:2,s);  edit11.text:=s;
  end
   else edit11.text:='';
 if XML_TEACHERS.DutyLoad[myTe,2]<>0 then
  begin
   str(XML_TEACHERS.DutyLoad[myTe,2]:4:2,s);  edit13.text:=s;
  end
   else edit13.text:='';

  cboFaculty1.Clear;
  cboFaculty2.Clear;
  cboFaculty3.Clear;
  cboFaculty4.Clear;
  for i := 1 to FacNum do
  begin
    cboFaculty1.Items.Add(FacName[i]);
    cboFaculty2.Items.Add(FacName[i]);
    cboFaculty3.Items.Add(FacName[i]);
    cboFaculty4.Items.Add(FacName[i]);
  end;
  if XML_TEACHERS.Tfaculty[myTe,1]=-1 then
    cboFaculty1.Text := '*'
  else
    cboFaculty1.ItemIndex := cboFaculty1.Items.IndexOf(FacName[XML_TEACHERS.Tfaculty[myTe, 1]]);
  cboFaculty2.ItemIndex := cboFaculty2.Items.IndexOf(FacName[XML_TEACHERS.Tfaculty[myTe, 2]]);
  cboFaculty3.ItemIndex := cboFaculty3.Items.IndexOf(FacName[XML_TEACHERS.Tfaculty[myTe, 3]]);
  cboFaculty4.ItemIndex := cboFaculty4.Items.IndexOf(FacName[XML_TEACHERS.Tfaculty[myTe, 4]]);
  edtTeacherCode.SetFocus;

end;

function Tedtcodedlg.TeacherAlreadyUsed(var CodeStrNew: string; myCode, Code: Integer): Boolean;
var
  codePlaceNew: Integer;
  msg,tmpStr: string;
begin
  Result := False;
  codePlaceNew := CheckCode(code, codeStrNew);
  if ((codePlaceNew>0) and (myCode <> codePlaceNew)) then  {code already in use}
  begin
    tmpStr := FNsubname(codePlaceNEW,code);
    Result := True;
  end;
end;

procedure Tedtcodedlg.UpdateTeacher(Sender: TObject);
var
 codeStr:       string;
 codeStrNEW:    string;
 msg:           string;
 i:             integer;
 tmpLoad:       array[1..3] of double;
 tmpCode:       array[1..3] of string[szDutyCode];
 tmpFacName:    array[1..nmbrTeFacs] of string[szFacName];
 tmpFac:        array[1..nmbrTeFacs] of smallint;
 tmpInt:        integer;
 erCode:        integer;
begin
  if ValidateData then
  begin
    msg:='';
    if NoCode(codeStr, edtTeacherCode) then exit;
    if CodeNotFound(myTe,1, edtTeacherCode) then exit;
    if NoNewCode(codeStrNew,edit3) then exit;
    if CodeAlreadyUsed(CodeStrNew,myTe,1,edit3) then exit;
    if CodeZero(codeStrNew,edit3) then exit;

    val(edit9.text,tmpLoad[1],erCode);
    val(edit11.text,tmpLoad[2],erCode);
    val(edit13.text,tmpLoad[3],erCode);
    tmpCode[1]:=trim(edit8.text);
    tmpCode[2]:=trim(edit10.text);
    tmpCode[3]:=trim(edit12.text);
    for i:=1 to 3 do
    begin
      if tmpLoad[i]<0 then
      begin
        msg:='Duty Loads cannot be less than 0.';
        msg:=msg+endline+'Check the value for the '+nth[i]+ ' Duty Load.';
        messagedlg(msg,mtError,[mbOK],0);
        case i of
         1: edit8.setfocus;
         2: edit10.setfocus;
         3: edit12.setfocus;
        end;
        exit;
      end
      else
      begin
        if ((tmpCode[i]='') and (tmpLoad[i]>0)) then
        begin
          msg:='A Duty Load must have an accompanying Duty Code.';
          msg:=msg+endline+'Enter a code for the '+nth[i]+' Duty Code.';
          messagedlg(msg,mtError,[mbOK],0);
          case i of
           1: edit9.setfocus;
           2: edit11.setfocus;
           3: edit13.setfocus;
          end;
          Exit;
        end;
      end  {if}
    end; {for}

    tmpInt:=IntFromEdit(edit7);
    if tmpInt<0 then
    begin
      ShowMsg('Load cannot be less than 0.',edit7);
      exit;
    end;

    tmpFacName[1] := Trim(cboFaculty1.Text);
    tmpFacName[2] := Trim(cboFaculty2.Text);
    tmpFacName[3] := Trim(cboFaculty3.Text);
    tmpFacName[4] := Trim(cboFaculty4.Text);
    for i:=1 to nmbrTeFacs do
    begin
    tmpFac[i]:=CheckFaculty(tmpFacName[i]);
    if ((tmpFac[i]=0) and (tmpFacName[i]<>'')) then
    begin
     msg:='Check the name entered for the '+nth[i]+' faculty.';
     messagedlg(msg,mtError,[mbOK],0);
     case i of
      1: cboFaculty1.SetFocus;
      2: cboFaculty2.SetFocus;
      3: cboFaculty3.SetFocus;
      4: cboFaculty4.SetFocus;
     end;
     exit;
    end;
    end;
    checkTeFaculty(tmpFac[1],tmpFac[2],tmpFac[3],tmpFac[4]);

    {still here? then assign the new teacher to vars.}
    XML_TEACHERS.tecode[myTe,0]:=codestrNEW;  {set new code}
    XML_TEACHERS.TeName[myTe,0]:=trim(edit2.text);  {update name}
    for i:=1 to 3 do
    begin
      XML_TEACHERS.DutyLoad[myTe,(i-1)]:=tmpLoad[i];
      XML_TEACHERS.DutyCode[myTe,(i-1)]:=tmpCode[i];
    end;
    for i:=1 to nmbrTeFacs do XML_TEACHERS.Tfaculty[myTe,i]:=tmpFac[i];
    XML_TEACHERS.Load[myTe]:=tmpInt;

    needUpdate:=true;
    sortCodes(1);

    {update font widths if necessary}
    getCodeFontWidths(1);
    getTeDutyCodeFontWidths;
    TeWindow.updateWin;

    if winView[wnFac]>0 then UpdateWindow(wnFac);
    UpdateTimeTableWins;
    GoNext(nil);
  end;
end;

procedure Tedtcodedlg.GoPrevious(Sender: TObject);
begin
  ChangeTeacher(-1);
end;

procedure Tedtcodedlg.GoNext(Sender: TObject);
begin
  ChangeTeacher(1);
end;

procedure Tedtcodedlg.ChangeTeacher(const pStatus: Integer);
var
  lCode: string;
begin
  case pStatus of
    1:        //  Next
    begin
      if FTeacherNo <= CodeCount[1] then
      begin
        Inc(FTeacherNo);
        lCode := Trim(XML_TEACHERS.TeCode[CodePoint[FTeacherNo, 1], 0]);
        if lCode <> '' then
        begin
          Edit3.Text := lCode;
          edtTeacherCode.Text := lCode;
        end
        else
          Dec(FTeacherNo);
      end;
    end;
    -1:  // Previous
    begin
      if FTeacherNo > 1 then           //myTe
      begin
        Dec(FTeacherNo);
        lCode := Trim(XML_TEACHERS.TeCode[CodePoint[FTeacherNo, 1], 0]);
        if lCode <> '' then
        begin
          Edit3.Text := lCode;
          edtTeacherCode.Text := lCode;
        end
        else
          Inc(FTeacherNo);
      end;
    end;
  end;  // case
end;

function Tedtcodedlg.ValidateData: Boolean;
var
  lMsg: string;
begin
  lMsg := '';
  Result := True;
  if (Trim(cboFaculty2.Text) <> '') and (UpperCase(cboFaculty2.Text) = UpperCase(cboFaculty1.Text)) then
    lMsg := cboFaculty2.Text + ' is already selected as Faculty 1. %1'
  else if (Trim(cboFaculty3.Text) <> '') and (UpperCase(cboFaculty3.Text) = UpperCase(cboFaculty2.Text)) then
    lMsg := cboFaculty3.Text + ' is already selected as Faculty 2. %1'
  else if (Trim(cboFaculty3.Text) <> '') and (UpperCase(cboFaculty3.Text) = UpperCase(cboFaculty1.Text)) then
    lMsg := cboFaculty3.Text + ' is already selected as Faculty 1. %1'
  else if (Trim(cboFaculty4.Text) <> '') and (UpperCase(cboFaculty4.Text) = UpperCase(cboFaculty3.Text)) then
    lMsg := cboFaculty4.Text + ' is already selected as Faculty 3. %1'
  else if (Trim(cboFaculty4.Text) <> '') and (UpperCase(cboFaculty4.Text) = UpperCase(cboFaculty2.Text)) then
    lMsg := cboFaculty4.Text + ' is already selected as Faculty 2. %1'
  else if (Trim(cboFaculty4.Text) <> '') and (UpperCase(cboFaculty4.Text) = UpperCase(cboFaculty1.Text)) then
    lMsg := cboFaculty4.Text + ' is already selected as Faculty 1. %1';

  if lMsg <> '' then
  begin
    lMsg := Format(lMsg, ['Please change selection.']);
    MessageDlg(lMsg, mtInformation, [mbOK], 0);
    Result := False;
  end;
end;

procedure Tedtcodedlg.FormActivate(Sender: TObject);
var
  s: string;
begin
 //init here
 edtTeacherCode.MaxLength := lencodes[1]; edit3.maxlength:=lencodes[1];
 edit2.maxlength:=szTeName;
 edit7.maxlength:=6;
 cboFaculty1.MaxLength := szFacName;
 cboFaculty2.MaxLength := szFacName;
 cboFaculty3.MaxLength := szFacName;
 cboFaculty4.MaxLength := szFacName;
 edit8.maxlength:=szDutyCode; edit9.maxlength:=4;
 edit10.maxlength:=szDutyCode; edit11.maxlength:=4;
 edit12.maxlength:=szDutyCode; edit13.maxlength:=4;
 needUpdate:=false;
 label15.caption:=inttostr(codeCount[1]);
 if TeWindow.selcode>0 then
  begin
   myTe:=codepoint[TeWindow.selcode,1];
   s:=XML_TEACHERS.tecode[myTe,0];
   FTeacherNo := TeWindow.selcode;
   edtTeacherCode.Text := TrimRight(s);
   ShowTeacher;
  end
 else
   Restore;
end;

procedure Tedtcodedlg.edtTeacherCodeChange(Sender: TObject);
var
  codeStr: string;
begin
 //change check here
  codeStr := TrimRight(edtTeacherCode.Text);
  myTe := checkCode(1, codeStr);
  if Trim(codeStr) <> '' then
  begin
    ShowTeacher;
    btnNextTe.Enabled := FteacherNo < CodeCount[1];
    btnPreviousTe.Enabled := FTeacherNo > 1;
  end
  else
    Restore1;
end;

procedure Tedtcodedlg.FormCreate(Sender: TObject);
begin
  topcentre(self);
end;

procedure Tedtcodedlg.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = 110 ) and (ssCtrl in Shift) then  //VK_RIGHT
    btnNextTe.Click;
  if (Key = 112) and (ssCtrl in Shift) then
    btnPreviousTe.Click;
end;

procedure Tedtcodedlg.Edit7KeyPress(Sender: TObject; var Key: Char);
begin
  allowNumericInputOnly(key);
end;

procedure Tedtcodedlg.Edit9KeyPress(Sender: TObject; var Key: Char);
begin
  allowDecimalInputOnly(key);
end;

end.
