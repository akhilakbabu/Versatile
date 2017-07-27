unit Student;
//This is a prototype for future student list
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdvToolBar, Menus, AdvMenus, ExtCtrls, Grids, AdvToolBarStylers,
  XML.TEACHERS;

type
  TFrmStudent = class(TForm)
    grdStudent: TStringGrid;
    PopupMenu1: TPopupMenu;
    pnlCpontrols: TPanel;
    AdvToolBarOfficeStyler1: TAdvToolBarOfficeStyler;
    AdvToolBarPager1: TAdvToolBarPager;
    AdvToolBarPager11: TAdvPage;
    AdvToolBarPager12: TAdvPage;
    AdvToolBarPager13: TAdvPage;
    AdvToolBar1: TAdvToolBar;
    AdvToolBarButton1: TAdvToolBarButton;
    AdvToolBarButton2: TAdvToolBarButton;
    AdvToolBarButton4: TAdvToolBarButton;
    AdvToolBarButton5: TAdvToolBarButton;
    AdvToolBarButton6: TAdvToolBarButton;
    AdvToolBarSeparator1: TAdvToolBarSeparator;
    AdvToolBarButton7: TAdvToolBarButton;
    AdvToolBarButton8: TAdvToolBarButton;
    AdvToolBarButton9: TAdvToolBarButton;
    AdvToolBarButton10: TAdvToolBarButton;
    AdvToolBarSeparator2: TAdvToolBarSeparator;
    AdvToolBarButton11: TAdvToolBarButton;
    AdvToolBarSeparator3: TAdvToolBarSeparator;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure AlignText(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure DisplayChangeStudent(Sender: TObject);
    procedure ChangeStudent(Sender: TObject);
    procedure DisplayAddStudent(Sender: TObject);
    procedure DisplayCommonData(Sender: TObject);
    procedure DisplayDeleteStudent(Sender: TObject);
    procedure DoClearStudentChoices(Sender: TObject);
  private
    function RefreshStudentList: Boolean;
  public
    { Public declarations }
  end;

var
  FrmStudent: TFrmStudent;

implementation

{$R *.dfm}

uses
  uAMGStudent, TimeChartGlobals, uAMGCommon, Main;

procedure TFrmStudent.AlignText(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  if ARow = 0 then
  begin
    DisplayGridText(grdStudent, Rect, grdStudent.Cells[ACol, ARow], taCenter);
  end;
end;

procedure TFrmStudent.ChangeStudent(Sender: TObject);
begin
  DisplayChangeStudent(Self);
end;

procedure TFrmStudent.DisplayAddStudent(Sender: TObject);
begin
  mainform.AddStudent1Click(Self);
end;

procedure TFrmStudent.DisplayChangeStudent(Sender: TObject);
begin
   mainform.ChangeStudent1Click(Self);
end;

procedure TFrmStudent.DisplayCommonData(Sender: TObject);
begin
  mainform.CommonData1Click(Self);
end;

procedure TFrmStudent.DisplayDeleteStudent(Sender: TObject);
begin
  mainform.DeleteStudent1Click(Self);
end;

procedure TFrmStudent.DoClearStudentChoices(Sender: TObject);
begin
  MainForm.ClearChoices1Click(self);
end;

procedure TFrmStudent.FormCreate(Sender: TObject);
begin
  grdStudent.ColWidths[0] := 18;
  grdStudent.ColWidths[1] := 150;
  grdStudent.ColWidths[2] := 150;
  grdStudent.ColWidths[3] := 40;
  grdStudent.ColWidths[4] := 40;
  grdStudent.ColWidths[5] := 70;
  grdStudent.ColWidths[6] := 50;
  grdStudent.ColWidths[7] := 100;
  grdStudent.ColWidths[8] := 140;
  grdStudent.ColWidths[9] := 140;
  grdStudent.Cells[1, 0] := 'Surname';
  grdStudent.Cells[2, 0] := 'First Name';
  grdStudent.Cells[3, 0] := 'Year';
  grdStudent.Cells[4, 0] := 'Sex';
  grdStudent.Cells[5, 0] := 'ID';
  grdStudent.Cells[6, 0] := 'Roll Class';
  grdStudent.Cells[7, 0] := 'House';
  grdStudent.Cells[8, 0] := 'Tutor';
  grdStudent.Cells[9, 0] := 'Home';
  grdStudent.Cells[10, 0] := 'Tag';
  grdStudent.Cells[11, 0] := 'Subject';
  grdStudent.Cells[12, 0] := 'Subject';
  grdStudent.Cells[13, 0] := 'Subject';
  grdStudent.Cells[14, 0] := 'Subject';
  grdStudent.Cells[15, 0] := 'Subject';
  grdStudent.Cells[16, 0] := 'Subject';
  grdStudent.Cells[17, 0] := 'Subject';
  grdStudent.Cells[18, 0] := 'Subject';
end;

procedure TFrmStudent.FormShow(Sender: TObject);
begin
  RefreshStudentList;
end;

function TFrmStudent.RefreshStudentList: Boolean;
var
  i: Integer;
  lStudent: TAMGStudent;
  j: Integer;
begin
  Result := False;
  grdStudent.RowCount := 2;
  for i := 0 to Students.Count -1 do
  begin
    lStudent := TAMGStudent(Students.Items[i]);
    grdStudent.Cells[1, i + 1] := lStudent.StName;
    grdStudent.Cells[2, i + 1] := lStudent.First;
    grdStudent.Cells[3, i + 1] := YearName[lStudent.StudYear];
    grdStudent.Cells[4, i + 1] := lStudent.Sex;
    grdStudent.Cells[5, i + 1] := lStudent.Code;
    grdStudent.Cells[6, i + 1] := ClassCode[lStudent.TcClass];
    grdStudent.Cells[7, i + 1] := HouseName[lStudent.House];
    grdStudent.Cells[8, i + 1] := XML_TEACHERS.TeName[lStudent.Tutor, 0];
    grdStudent.Cells[9, i + 1] := XML_TEACHERS.TeName[lStudent.Home, 1];
    grdStudent.Cells[10, i + 1] := TagName[lStudent.Tag];
    for j := 0 to lStudent.Choices.Count - 1 do
    begin
      grdStudent.Cells[10 + j + 1, i + 1] := SubCode[TAMGChoice(lStudent.Choices.Items[j]).Sub];
    end;
    grdStudent.RowCount := grdStudent.RowCount + 1;
  end;
  Result := True;
end;

end.
