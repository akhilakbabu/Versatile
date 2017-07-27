unit Sutimdlg;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, TimeChartGlobals,GlobalToTcAndTcextra,
  XML.DISPLAY;

type
  TSubjectTimesdlg = class(TForm)
    GroupBox2: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label12: TLabel;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    OKbutton: TBitBtn;
    Cancelbutton: TBitBtn;
    Helpbutton: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OKbuttonClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox1Enter(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox2Enter(Sender: TObject);
  end;

var
  SubjectTimesdlg: TSubjectTimesdlg;

implementation
uses tcommon,DlgCommon;
{$R *.DFM}

var
 duringload: bool;
 MyYear,MyFac: smallint;

procedure TSubjectTimesdlg.FormCreate(Sender: TObject);
begin
 duringload:=true;   label12.caption:='';
 label2.caption:='&'+yeartitle;
 FillComboYears(true,ComboBox1);
 FillComboFaculty(true,combobox2);
 if XML_DISPLAY.subjecttimesyear=years then combobox1.itemindex:=0
  else combobox1.itemindex:=XML_DISPLAY.subjecttimesyear+1;
 combobox2.itemindex:=XML_DISPLAY.subjecttimesfac;
 MyYear:=XML_DISPLAY.subjecttimesyear;
 MyFac:=XML_DISPLAY.subjecttimesfac;
 duringload:=false;
end;

procedure TSubjectTimesdlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 action:=cafree;
end;

procedure TSubjectTimesdlg.OKbuttonClick(Sender: TObject);
begin
 if myYear=-1 then
  begin
   ComboMsg('Check '+yeartitle,combobox1);
   exit;
  end;
 XML_DISPLAY.subjecttimesyear:=myYear;
 XML_DISPLAY.subjecttimesfac:=combobox2.itemindex;
 close;
 UpdateWindow(wnSuTimes);
end;

procedure TSubjectTimesdlg.ComboBox1Change(Sender: TObject);
begin
 if duringload then exit;
 myYear:=FindComboAllYear(Combobox1,label12);
end;

procedure TSubjectTimesdlg.ComboBox1Enter(Sender: TObject);
begin
 ComboBox1Change(Sender);
 ComboBox1.selectall;
end;

procedure TSubjectTimesdlg.ComboBox2Change(Sender: TObject);
begin
 label12.caption:='';
 if trim(combobox2.text)='' then MyFac:=0
  else MyFac:=findfaculty(ComboBox2.text,label12);
end;

procedure TSubjectTimesdlg.ComboBox2Enter(Sender: TObject);
begin
 ComboBox2Change(Sender);
 ComboBox2.selectall;
end;

end.
