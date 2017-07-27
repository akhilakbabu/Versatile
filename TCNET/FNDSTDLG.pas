unit Fndstdlg;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, TimeChartGlobals, XML.DISPLAY, XML.TEACHERS,
  XML.STUDENTS;

type
  TFindStudentDlg = class(TForm)
    GroupBox1: TGroupBox;
    lblStudent: TLabel;
    lblStudentName: TLabel;
    Edit1: TEdit;
    Nextbutton: TBitBtn;
    Cancelbutton: TBitBtn;
    Helpbutton: TBitBtn;
    ComboBox1: TComboBox;
    Label3: TLabel;
    Okbutton: TBitBtn;
    lblYearName: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    previousButton: TBitBtn;
    lblHomeRoomCaption: TLabel;
    lblHomeRoom: TLabel;
    lblTutorCaption: TLabel;
    lbltutor: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure RefreshStudentDetails(Sender: TObject);
    procedure OKbuttonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure NextbuttonClick(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure previousButtonClick(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    procedure SFbuttonSet;
  end;

var
  FindStudentDlg: TFindStudentDlg;


implementation

uses
  tcommon, findstud, tcommon2, DlgCommon;

{$R *.DFM}

var
 SFpos, SFpoint, SFyear,SFmax:  integer;
 SFfound:       boolean;
 MyStPointer: array of integer;

procedure MakeStArray;
var
 i,j: integer;
begin
 SFmax:=0;
 if XML_DISPLAY.UseGroupFindStud then
  begin
   for i:=1 to groupnum do
    begin
     j:=StGroup[i];
     if (XML_STUDENTS.Stud[j].tcyear=SFyear) or (SFyear=-1)
       then begin inc(SFmax); MyStPointer[SFmax]:=j; end;
    end;
  end
 else
  begin
   for i:=1 to XML_STUDENTS.numstud do
    begin
     if (XML_STUDENTS.Stud[i].tcyear=SFyear) or (SFyear=-1)
       then begin inc(SFmax); MyStPointer[SFmax]:=i; end;
    end;
  end;
 SFpoint:=0;
 if SFpos>0 then
  for i:=1 to SFmax do
   if MyStPointer[i]=SFpos then begin SFpoint:=i; break end;
end;

procedure TFindStudentDlg.SFbuttonSet;
begin
 previousbutton.enabled:=(SFpoint>1);
 nextbutton.enabled:=(SFpoint<SFmax);
 OKbutton.enabled:=SFfound;
end;

procedure TFindStudentDlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 action:=caFree;
end;

procedure TFindStudentDlg.FormCreate(Sender: TObject);
begin
 edit1.text:='';
 setLength(MyStPointer,XML_STUDENTS.numstud+1);
 label3.caption:='&'+Yeartitle;
 SFpos:=0; SFyear:=-1; SFpoint:=0;SFfound:=false;
 checkbox1.checked:=XML_DISPLAY.MatchAllYears;
 checkbox2.checked:=XML_DISPLAY.UseGroupFindStud;
 FillComboYears(true,ComboBox1);
 combobox1.itemindex:=0; {default to all}
 MakeStArray;
end;

procedure TFindStudentDlg.RefreshStudentDetails(Sender: TObject);
var
 astr,s: string;
 i,j,len: integer;
begin
 SFfound:=false; SFpoint:=0; SFpos:=0;
 s:=trim(edit1.text); len:=Length(s);
 s:=uppercase(s);
 if s>'' then
  for j:=1 to SFmax do
    begin
      i:=MyStPointer[j];
      astr:=uppercase(XML_STUDENTS.Stud[i].stname+' '+XML_STUDENTS.Stud[i].first);
      astr:=copy(astr,1,len);
      if s=astr then begin SFfound:=true; SFpoint:=j; SFpos:=i; break; end;
     end;
 if SFfound then
  begin
   lblStudentName.Caption := XML_STUDENTS.Stud[SFpos].stname+' '+XML_STUDENTS.Stud[SFpos].first;
   lblHomeRoom.Caption := GetStudentHomeRoom(SFpos);
   lblTutor.Caption := XML_TEACHERS.TeName[XML_STUDENTS.Stud[SFpos].Tutor, 0];
   lblYearName.Caption := Yeartitle+' '+yearname[XML_STUDENTS.Stud[SFpos].TcYear];
  end
  else lblStudentName.Caption := 'Enter Student Name';
 SFbuttonSet;
end;

procedure TFindStudentDlg.OKbuttonClick(Sender: TObject);
begin
 if SFfound then
  begin
   studfindnum:=SFpos;
   findstudentwinselect;
   UpdateWindow(wnFindStud);
   close;
   findstudent.setfocus;
  end
 else ShowMsg('No Student selected',edit1);
end;

procedure TFindStudentDlg.FormActivate(Sender: TObject);
begin
 Combobox1.Hint:='Select '+Yeartitle+' to search';
 lblYearName.Caption := '';
 lblHomeRoom.Caption := '';
 lbltutor.Caption := '';
 lblStudentName.Caption := 'Enter Student Name';
 SFbuttonSet;
end;

procedure TFindStudentDlg.ComboBox1Change(Sender: TObject);
var
 oldyear: integer;
 astr: string;
begin
 oldyear:=SFyear;
 astr:=combobox1.Text;
 SFyear:=findyear(astr);
 if SFyear<>oldyear then
  begin
   MakeStArray;
   SFbuttonSet;
  end;
end;

procedure TFindStudentDlg.NextbuttonClick(Sender: TObject);
begin
  if SFpoint<SFmax then
  begin
   inc(SFpoint); SFfound:=true;
   SFpos:=MyStPointer[SFpoint];
   lblStudentName.Caption := XML_STUDENTS.Stud[SFpos].stname+' '+XML_STUDENTS.Stud[SFpos].first;
   lblHomeRoom.Caption := GetStudentHomeRoom(SFpos);
   lblTutor.Caption := XML_TEACHERS.TeName[XML_STUDENTS.Stud[SFpos].Tutor, 0];
   lblYearName.Caption := Yeartitle+' '+yearname[XML_STUDENTS.Stud[SFpos].TcYear];
   SFbuttonSet;
  end;
end;

procedure TFindStudentDlg.CheckBox2Click(Sender: TObject);
begin
 XML_DISPLAY.UseGroupFindStud:=checkbox2.checked;
 MakeStArray;
end;

procedure TFindStudentDlg.previousButtonClick(Sender: TObject);
begin
  if SFpoint>1 then
  begin
   dec(SFpoint); SFfound:=true;
   SFpos:=MyStPointer[SFpoint];
   lblStudentName.Caption := XML_STUDENTS.Stud[SFpos].stname+' '+XML_STUDENTS.Stud[SFpos].first;
   lblHomeRoom.Caption := GetStudentHomeRoom(SFpos);
   lblTutor.Caption := XML_TEACHERS.TeName[XML_STUDENTS.Stud[SFpos].Tutor, 0];
   lblYearName.Caption := Yeartitle+' '+yearname[XML_STUDENTS.Stud[SFpos].TcYear];
   SFbuttonSet;
  end;
end;

procedure TFindStudentDlg.CheckBox1Click(Sender: TObject);
begin
 XML_DISPLAY.MatchAllYears:=checkbox1.checked;
end;

end.
