unit Delclass;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, TimeChartGlobals,GlobalToTcAndTcextra,
  XML.STUDENTS;

type
  TDelclassDlg = class(TForm)
    Label7: TLabel;
    Label8: TLabel;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    finish: TBitBtn;
    update: TBitBtn;
    BitBtn3: TBitBtn;
    ComboBox1: TComboBox;
    Label1: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure updateClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ComboBox1Change(Sender: TObject);
  end;

var
  DelclassDlg: TDelclassDlg;

implementation
uses tcommon,tcommon2,DlgCommon,StCommon,RollClassWnd,main,tcommon5;
{$R *.DFM}

var
 updateflag: bool;


procedure setDropList;
var
 i:       integer;
begin
 with DelclassDlg do
 begin
  combobox1.clear;

  if RollClassPoint[0]>0 then
   for i:=1 to RollClassPoint[0] do
    combobox1.items.add(ClassCode[RollClassPoint[i]]);
 end;
end;

procedure TDelclassDlg.FormActivate(Sender: TObject);
var
  nm: Integer;
begin
  setDropList;
  combobox1.maxlength:=LenClassCodes;
  updateflag:=false;
  label8.caption:=inttostr(RollClassPoint[0]);
  nm:=RollClassWindow.selcode;
  if (nm>0) and (nm<=nmbrClass) then
  begin
   ComboBox1.ItemIndex := ComboBox1.Items.indexOf(Trim(ClassCode[RollClassPoint[nm]]));
   if ComboBox1.Enabled and ComboBox1.Visible then
     ComboBox1.SetFocus;
  end
  else
  begin
    ComboBox1.ItemIndex := -1;
  end;

  ComboBox1Change(combobox1);
end;

procedure TDelclassDlg.FormCreate(Sender: TObject);
begin
 TopCentre(self);
end;

procedure TDelclassDlg.updateClick(Sender: TObject);
var
 z,i:       integer;
 msg: string;
 nm:      integer;
 YearChange:   array[0..nmbryears] of boolean;
begin
 nm:=FindRollClasscode(combobox1.text);
 if ((nm<1) or (nm>classnum)) then
 begin
  ComboMsg('No class selected',combobox1);
  exit;
 end;

  for i:=0 to nmbryears do YearChange[i]:=false;
// Check if can get access to years needed
 for i:=1 to XML_STUDENTS.numstud do   {check years needed to change}
    if (XML_STUDENTS.Stud[i].TcClass=nm) then
        YearChange[XML_STUDENTS.Stud[i].tcYear]:=true;

 msg:='';
 for i:=0 to years_minus_1 do
  if YearChange[i] then
   if not(CheckUserYearPassAccess(i)) then   //not already locked
     if CheckUserYearPassRights(i) then  //has got rights to change year
      begin  //attempt to dynamically add lock to year
       if not(CheckPriorYearAccess4(i,true)) then
          exit; //msg already shown in access fn if needed
      end
     else
      begin
       msg:='Class code '+ ClassCode[nm]+' is used in '+yeartitle+' '+yearname[i]+endline
        +'You do NOT have access to change '+yeartitle+' '+yearname[i]+' student data';
       messagedlg(msg,mtError,[mbOK],0);
       combobox1.setfocus;
       exit; {return to editing}
      end;

 ClassCode[nm]:='';

// loop through studs and reset class code

 for i:=1 to XML_STUDENTS.numstud do
  if (XML_STUDENTS.Stud[i].TcClass=nm) then
   begin
    XML_STUDENTS.Stud[i].TcClass:=0;
    SaveStudFlag:=true;
    StudYearFlag[XML_STUDENTS.Stud[i].tcYear]:=true;    
   end;

 REselectGroup;
 updateRollClassPoint;
 label8.caption:=inttostr(RollClassPoint[0]);

 z:=combobox1.itemindex;
 setDropList;
 if z>(combobox1.items.count-1) then
  combobox1.itemindex:=(combobox1.items.count-1)
 else
  combobox1.itemindex:=z;
 updateflag:=true;
 fwClass:=getClassFontWidths(mainform.canvas);
 RollClassWindow.UpdateWin;
 UpdateAllWins;

 combobox1.setfocus;
end;

procedure TDelclassDlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 action:=caFree;
 if updateflag then updateclass;
 if SaveStudFlag then SaveAllStudentYears;
end;



procedure TDelclassDlg.ComboBox1Change(Sender: TObject);
var
 i,j,cc:    integer;
 tmps: string;
begin
 tmps:=combobox1.text;
 cc:=FindRollClasscode(tmps);
 if cc=0 then
  begin
   label1.caption:='Enter Roll Class';
  end
 else {calc and show stud count for class}
  begin
   j:=0;
   for i:=1 to XML_STUDENTS.numstud do if (cc=XML_STUDENTS.Stud[i].TcClass) then inc(j);
   label1.caption:=inttostr(j)+' Students';
  end;
end;

end.
