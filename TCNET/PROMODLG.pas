unit Promodlg;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, TimeChartGlobals,GlobalToTcAndTcextra, XML.DISPLAY,
  XML.STUDENTS;

type
  Tpromotestudentdlg = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    GroupBox2: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    OKbutton: TBitBtn;
    Cancelbutton: TBitBtn;
    Helpbutton: TBitBtn;
    procedure OKbuttonClick(Sender: TObject);
    procedure CancelbuttonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  end;

var
  promotestudentdlg: Tpromotestudentdlg;

implementation
uses tcload,tcommon,tcommon2,stcommon;
{$R *.DFM}

procedure promotestudents;
var
 msg:         string;
 i,j:         integer;

     procedure wipestudents;
     var
      i,k:                    integer;
     begin
       SubSexCountFlg:=true;
       for i:=1 to XML_STUDENTS.numstud do
        for k:=1 to nmbrChoices do
            XML_STUDENTS.Stud[i].choices[k]:=0; //clear choices
     end;

begin  {main proc for promote studs}
 if years=1 then
  begin
   msg:='Only 1 '+yeartitle+' - can''t promote!';
   messagedlg(msg,mtError,[mbOK],0);
  end;
 j:=XML_STUDENTS.numstud;
 for i:=j downto 1 do  //remove students in highest year
   if XML_STUDENTS.Stud[i].TcYear=years_minus_1 then removeStudent(i);
 j:=XML_STUDENTS.numstud;
 for i:=j downto 1 do inc(XML_STUDENTS.Stud[i].TcYear);  //increment year
 SaveStudFlag:=true;
 for j:=years_minus_1 downto 0 do StudYearFlag[j]:=true;
 if XML_DISPLAY.clearstudentchoicesflag then wipestudents;
 SaveAllStudentYears;
end;


procedure Tpromotestudentdlg.OKbuttonClick(Sender: TObject);
begin
 XML_DISPLAY.clearstudentchoicesflag:=radiobutton2.checked;
 try
  screen.cursor:=crHourglass;
  promotestudents;
  initBlockdata;
  UpdateStudCalcs;
 finally
  screen.cursor:=crDefault;
 end;
 close;
end;

procedure Tpromotestudentdlg.CancelbuttonClick(Sender: TObject);
begin
 close;
end;

procedure Tpromotestudentdlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 action:=cafree;
end;

procedure Tpromotestudentdlg.FormCreate(Sender: TObject);
begin
 radiobutton2.checked:=XML_DISPLAY.clearstudentchoicesflag;
 OKbutton.hint:='Promote all students to the next '+yeartitle;
end;

end.
