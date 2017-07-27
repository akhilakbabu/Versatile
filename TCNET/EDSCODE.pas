unit Edscode;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, TimeChartGlobals;

type
  Tedscodedlg = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    finish: TBitBtn;
    update: TBitBtn;
    BitBtn3: TBitBtn;
    Label7: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Edit4: TEdit;
    Label10: TLabel;
    Edit5: TEdit;
    cboSubject: TComboBox;
    lblSelectSubject: TLabel;
    CheckBox1: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure UpdateSubject(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RefreshSubjectSelection(Sender: TObject);
  private
    Procedure Restore;
    Procedure Restore1;
    procedure ShowSub;
    procedure RefreshSubjectList;
  end;

var
  edscodedlg: Tedscodedlg;

implementation

uses
  SuWnd,tcommon,DlgCommon,main, TCLoad;

{$R *.DFM}

var
 MySu: integer;
 needUpdate:   bool;

procedure Tedscodedlg.ShowSub;
begin
 label5.caption:=Subname[MySu];
 edit3.text:=trimRight(SubCode[MySu]);
 edit2.text:=Subname[MySu];
 edit4.Text:=SubReportCode[MySu];
 edit5.Text:=SubReportName[MySu];
 if Trim(SubWillCount[MySu])='Y' then  //---- mantis-1295
  CheckBox1.Checked :=True
 else
  CheckBox1.Checked :=False ;
//  CheckBox1.Caption :=  SubWillCount[MySu];
end;

procedure Tedscodedlg.RefreshSubjectList;
var
  i: Integer;
begin
  cboSubject.Clear;
  for i := 1 to CodeCount[0] do
    cboSubject.Items.AddObject(Trim(SubCode[CodePoint[i, 0]]), TObject(codepoint[i, 0]));
  {for i := 1 to numCodes[code] do
  begin
   cboSubject.Items.AddObject(UpperCase(FNsub(i,code)), TObject(FNsub(i, code)));
  end;}
end;

procedure Tedscodedlg.RefreshSubjectSelection(Sender: TObject);
var
  lSubject: Integer;
begin
  if cboSubject.ItemIndex > -1 then
  begin
    lSubject := Integer(cboSubject.Items.Objects[cboSubject.ItemIndex]);
    Edit1.Text := TrimRight(SubCode[lSubject]);
    MySu := lSubject;
    ShowSub;
  end;
end;

procedure Tedscodedlg.Restore;
begin
 edit1.text:='';
 restore1;
 //edit1.setfocus;
  if cboSubject.Visible and cboSubject.Enabled then
    cboSubject.SetFocus;
end;

procedure Tedscodedlg.Restore1;
begin
 label5.caption:='';
 edit2.text:=''; edit3.text:=''; edit4.text:=''; edit5.text:='';
end;

procedure Tedscodedlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if needUpdate then updateSub(0); {update subject data files}
end;

procedure CheckSubyearOrder(MySu: integer);
var
 i,foundpos,newpos: integer;

 procedure swapyrpos(i: integer);
 begin
  SwapInt(GroupSubs[i],GroupSubs[i+1]);
  SwapInt(GroupSubCount[i],GroupSubCount[i+1]);
 end;

begin
  foundpos:=GsubXref[MySu];
  if foundpos>0 then
  begin
   newpos:=GroupSubs[0];
   for i:=1 to GroupSubs[0] do
    if (SubCode[MySu]<SubCode[GroupSubs[i]]) and (i<>foundpos) then
      begin
       newpos:=i;
       break;
      end;
   if newpos>foundpos then dec(newpos);
   if foundpos<newpos then for i:=foundpos to newpos-1 do swapyrpos(i);
   if foundpos>newpos then for i:=foundpos-1 downto newpos do swapyrpos(i);

  end;
 XrefGroupSubs;
end;

procedure Tedscodedlg.UpdateSubject(Sender: TObject);
var
 codeStr:       string;
 codeStrNEW:    string;
 tmpStr:        string;
 tmpint:        integer;
 tmpSubwillcount: string;  //---- mantis-1295
begin
 if NoCode(codeStr,edit1) then exit;
 if CodeNotFound(mySu,0,edit1) then exit;
 if NoNewCode(codeStrNew,edit3) then exit;
 if CodeAlreadyUsed(CodeStrNew,mySu,0,edit3) then exit;
 if CodeZero(codeStrNew,edit3) then exit;
 tmpstr:=uppercase(trim(codeStr));
 if tmpStr='NA' then
 begin
  ShowMsg('Not Available code can''t be changed',edit1);
  exit; {return to editing}
 end;

 if uppercase(trim(codeStrNEW))='NA' then subNA:=MySu;

 codeStrNEW:=TrimRight(codeStrNEW);    //CodeAlreadyUsed calls validateCode  which adds the string padding that we don't want

 SubCode[MySu]:=codeStrNEW;   {update new vals.}
 tmpStr:=TrimRight(edit2.text);
 Subname[MySu]:=tmpStr;
 //------------ mantis-1295-------------
If  Checkbox1.Checked   then
 tmpSubwillcount := 'Y'
else
  tmpSubwillcount := 'N' ;

 if NumSubRepCodes>0 then
  begin
   SubReportCode[MySu]:=trim(edit4.text);
   SubReportName[MySu]:=trim(edit5.text);
  end
 else
  begin
   SubReportCode[MySu]:=Subcode[MySu];
   SubReportName[MySu]:=Subname[MySu];
//   SubReportName[MySu]:=Subname[MySu];
  end;

 //---- mantis-1295
 if CheckBox1.Checked =true then
   SubWillCount[MySu]:='Y'
 else
   SubWillCount[MySu]:='N' ;


 needUpdate:=true;
 sortCodes(0);

 CheckSubyearOrder(MySu);

 {update font widths if necessary}
 tmpint:=mainform.canvas.textwidth(codestrNEW);
 if tmpint>fwCode[0] then fwCode[0]:=tmpint;
 if tmpint>fwCodeBlank[0]then fwCodeBlank[0]:=tmpint;
 tmpint:=mainform.canvas.textwidth(tmpStr);
 if tmpint>fwCodename[0] then fwCodename[0]:=tmpint;
 tmpint:=mainform.canvas.textwidth(SubReportCode[MySu]);
 if tmpint>fwReportCode then fwReportCode:=tmpint;
 tmpint:=mainform.canvas.textwidth(SubReportName[MySu]);
 if tmpint>fwReportName then fwReportName:=tmpint;

 UpdateAllWins;
 Restore;

   if needUpdate then
  begin
    updatesub(0); {update subject data files}
    GetSubjectCodes;
    if cboSubject.ItemIndex < cboSubject.Items.count then
    begin
      cboSubject.ItemIndex := cboSubject.ItemIndex + 1;
      RefreshSubjectSelection(Self);
    end;
  end;
end;

procedure Tedscodedlg.FormActivate(Sender: TObject);
begin
 {init here}
 edit1.maxlength:=lencodes[0]; edit3.maxlength:=lencodes[0];
 edit2.maxlength:=snSize;
 edit4.maxlength:=LenSubRepCode;  edit5.maxlength:=LenSubRepName;
 needUpdate:=false;
 label6.caption:=inttostr(codeCount[0]);
 RefreshSubjectList;
 if SuWindow.selcode>0 then
 begin
  MySu:=codepoint[SuWindow.selcode,0];
  edit1.text:=TrimRight(SubCode[MySu]);
  //ShowSub;
  cboSubject.iTemIndex := cboSubject.Items.IndexOf(Edit1.Text);
  cboSubject.OnChange(Self);
  if Subwillcount[MySu]='Y' then
   CheckBox1.Checked := True;
 end
 else restore;
 //edit1.setfocus;
end;


procedure Tedscodedlg.Edit1Change(Sender: TObject);
var
 codeStr:       string;
begin
 {change check here}
 codeStr:=TrimRight(edit1.text);
 MySu:=checkCode(0,codeStr);
 if MySu>0 then ShowSub else restore1;
 {check for 'NA' }
 codeStr:=TrimRight(codeStr);
 if codeStr='NA' then
 begin
  edit2.text:='Not Available';
  edit2.enabled:=false;
  edit3.text:='NA';
  edit3.enabled:=false;
 end
 else
  begin
   edit2.enabled:=true;
   edit3.enabled:=true;
  end;
end;

procedure Tedscodedlg.FormCreate(Sender: TObject);
begin
 TopCentre(self);
 if (NumSubRepCodes>0) then
  begin
   label8.visible:=true;
   label9.visible:=true;
   label10.visible:=true;
   edit4.visible:=true;
   edit5.visible:=true;
  end;
end;

end.
