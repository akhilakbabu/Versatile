unit VASSStudentExport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, BaseGrid, ExtCtrls, ComCtrls, AdvObj, AdvGrid, XML.UTILS,
  XML.DISPLAY;

type
  TFrmVASSStudentExport = class(TForm)
    pnlControls: TPanel;
    pnlVASSExport: TPanel;
    pnlButtons: TPanel;
    btnClose: TButton;
    btnRefresh: TButton;
    lblCourseType: TLabel;
    edtDEETSchoolCode: TEdit;
    lblDEETSchoolCode: TLabel;
    edtVCAASchoolCode: TEdit;
    lblVCAASchoolCode: TLabel;
    btnExport: TButton;
    cboCourseType: TComboBox;
    prbVASSExport: TProgressBar;
    cboDelimiter: TComboBox;
    lblPrompot: TLabel;
    grdVASSStudent: TAdvStringGrid;
    edtGroup: TEdit;
    procedure RefreshVASSExportData(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ExportVASSData(Sender: TObject);
  private
    function IsValidEntry: Boolean;
    procedure EnableControls(const pEnable: Boolean);
  end;


(* Specs
No  FIELD	                    LENGTH	            DETAILS
--------------------------------------------------------------------------------------------------------------------------------------------------
1	Course Type	                3 chars	            Mandatory. Can be ‘VCE’ or ‘PDO’ (Personal Details Only)
2	DEET School Code	          10 chars(maximum)	  Mandatory if VCAA School Code is blank.
                                                  Mark as text in Excel to preserve the leading zero.
3	VCAA School Code	          5 chars	            Mandatory if DEET School Code is blank.
                                                  Mark as text in Excel to preserve the leading zero.
4	Student Number	            9 chars	            Optional.  Alphanumeric.  If entered it must be a valid student number.
5	External Student Identifier	12 chars(maximum)   Optional.  Alphanumeric. If included it can be used to identify the student instead of the Student Number in the Amend Student import
6	Family Name	                25 chars(maximum)	  Mandatory.  Can only contain alphabetic, hyphen, apostrophes and single spaces and must contain at least one character.
7	First Name	                15 chars(maximum)	  Mandatory.  Can only contain alphabetic, hyphen, apostrophes and single spaces and must contain at least one character.
8	Second Name	                15 chars(maximum)	  Not mandatory.  Can only contain alphabetic, hyphen, apostrophes and single spaces.
9	Salutation	                4 chars(maximum)    Must be MR, MRS, MS or MISS.
10	Address Line 1	          25 chars(maximum)	  The address to which end of year results are sent.
11	Address Line 2	          25 chars(maximum)	  Not mandatory.  The address to which end of year results are sent.
12	Suburb	                  30 chars(maximum)   Mandatory.  Alphabetic only.  The Australia Post accepted format is used: suburb name followed by East, North, South and West, e.g. Kew East and not East Kew.
13	State/Country	            17 chars(maximum)	  Optional if the postcode is a valid Australian postcode.  Must be present if the postcode is ****.
14	Postcode	                4 chars	            Mandatory for Australian addresses.  Use **** for overseas addresses.
15	Phone No.	                15 chars(maximum)   Can contain numbers, hyphens and spaces.  Not mandatory. Must contain only one telephone number.
16	Date of Birth	            10 chars	          Must be in DD/MM/YYYY format, numeric and forward slash only.
                                                  Mark as text in Excel to preserve format.
17	Gender	                  1 char	            Must be F or M.
18	Year Level	              2 chars(maximum)	  Must be in the range: 7 to 12.
19	Home Group	              3 chars(maximum)	  Must be alphanumeric.
20	Previous Surname	        25 chars(maximum)   Not mandatory.  Can only contain alphabetic, hyphen, apostrophes and single spaces and must contain at least one character.
21	Previous First Name	      15 chars(maximum)   Not mandatory.  Can only contain alphabetic, hyphen, apostrophes and single spaces and must contain at least one character.
22	Previous Second Name	    15 chars(maximum)   Not mandatory.  Can only contain alphabetic, hyphen, apostrophes and single spaces.
23	General Declaration	      1 character	        Must be ‘Y’ or ‘N’.  If ‘N’ the student will not be imported.
                                                  This field is not reported on the database.
24	Victorian Student Number	9 chars	            Not mandatory.  If entered it must be the correct Victorian Student Number for the student.
*)


var
  FrmVASSStudentExport: TFrmVASSStudentExport;

implementation

uses
  uAMGStudent, uAMGConst, TimeChartGlobals, StCommon;

{$R *.dfm}

procedure TFrmVASSStudentExport.EnableControls(const pEnable: Boolean);
begin
  btnRefresh.Enabled := pEnable;
  btnExport.Enabled := pEnable;
end;

procedure TFrmVASSStudentExport.ExportVASSData(Sender: TObject);
var
  lList: TStringList;
  i: Integer;
  j: Integer;
  lDelimiter: Char;
  lRowStr: string;
begin
  prbVASSExport.Position := 0;
  lList := TStringList.Create;
  EnableControls(False);
  try
    prbVASSExport.Visible := True;
    if cboDelimiter.ItemIndex = 0 then
      lDelimiter := Chr(9)
    else
      lDelimiter := AMG_PIPE;
    for i := 1 to grdVASSStudent.RowCount do
    begin
      lRowStr := '';
      for j := 1 to grdVASSStudent.ColCount - 1 do
        lRowStr := lRowStr + grdVASSStudent.Cells[j, i] + lDelimiter;
      lList.Add(lRowStr);
      prbVASSExport.Position := Round(i * 100 / grdVASSStudent.RowCount);
      Sleep(1);
      Application.ProcessMessages;
    end;
    lList.SaveToFile(Directories.DataDir + '\' + AMG_VASS_STUDENT_EXPORT_FILE);
    MessageDlg(Format(AMG_DATA_EXPORTED_AS_MSG + #10#13 + AMG_MISSING_DATA_MSG, [Directories.DataDir, AMG_VASS_STUDENT_EXPORT_FILE]), mtInformation, [mbOK], 0);
  finally
    FreeAndNil(lList);
    btnRefresh.Enabled := True;
  end;
end;

procedure TFrmVASSStudentExport.FormShow(Sender: TObject);
var
  lSelected: string;
  lStudTotal: Integer;
begin
  grdVASSStudent.ColWidths[0] := 40;
  grdVASSStudent.ColWidths[1] := 75;
  grdVASSStudent.Cells[1, 0] := 'Course Type';
  grdVASSStudent.ColWidths[2] := 120;
  grdVASSStudent.Cells[2, 0] := 'DEET School Code';
  grdVASSStudent.ColWidths[3] := 120;
  grdVASSStudent.Cells[3, 0] := 'VCAA School Code';
  grdVASSStudent.ColWidths[4] := 90;
  grdVASSStudent.Cells[4, 0] := 'Student Number';
  grdVASSStudent.ColWidths[5] := 160;
  grdVASSStudent.Cells[5, 0] := 'External Student Identifier';
  grdVASSStudent.ColWidths[6] := 120;
  grdVASSStudent.Cells[6, 0] := 'Family Name';
  grdVASSStudent.ColWidths[7] := 120;
  grdVASSStudent.Cells[7, 0] := 'First Name';
  grdVASSStudent.ColWidths[8] := 90;
  grdVASSStudent.Cells[8, 0] := 'Second Name';
  grdVASSStudent.ColWidths[9] := 65;
  grdVASSStudent.Cells[9, 0] := 'Salutation';
  grdVASSStudent.ColWidths[10] := 90;
  grdVASSStudent.Cells[10, 0] := 'Address Line 1';
  grdVASSStudent.ColWidths[11] := 90;
  grdVASSStudent.Cells[11, 0] := 'Address Line 2';
  grdVASSStudent.ColWidths[12] := 80;
  grdVASSStudent.Cells[12, 0] := 'Suburb';
  grdVASSStudent.ColWidths[13] := 100;
  grdVASSStudent.Cells[13, 0] := 'State/Country';
  grdVASSStudent.ColWidths[14] := 80;
  grdVASSStudent.Cells[14, 0] := 'Postcode';
  grdVASSStudent.ColWidths[15] := 80;
  grdVASSStudent.Cells[15, 0] := 'Phone No.';
  grdVASSStudent.ColWidths[16] := 80;
  grdVASSStudent.Cells[16, 0] := 'Date Of Birth';
  grdVASSStudent.ColWidths[17] := 50;
  grdVASSStudent.Cells[17, 0] := 'Gender';
  grdVASSStudent.ColWidths[18] := 70;
  grdVASSStudent.Cells[18, 0] := 'Year Level';
  grdVASSStudent.ColWidths[19] := 80;
  grdVASSStudent.Cells[19, 0] := 'Home Group';
  grdVASSStudent.ColWidths[20] := 120;
  grdVASSStudent.Cells[20, 0] := 'Previous Surname';
  grdVASSStudent.ColWidths[21] := 120;
  grdVASSStudent.Cells[21, 0] := 'Previous First Name';
  grdVASSStudent.ColWidths[22] := 120;
  grdVASSStudent.Cells[22, 0] := 'Previous Second Name';
  grdVASSStudent.ColWidths[23] := 120;
  grdVASSStudent.Cells[23, 0] := 'General Declaration';
  grdVASSStudent.ColWidths[24] := 160;
  grdVASSStudent.Cells[24, 0] := 'Victorian Student Number';

  case XML_DISPLAY.StudListType of
    1:
    begin
      lSelected := 'Selection';
      lStudTotal := ListStudentSelection[0];
    end;
    2:
    begin
      lSelected := GroupName;
      if UpperCase(lSelected) = 'ALL' then
        lStudTotal := Length(StPointer) -1
      else
        lStudTotal := GroupNum;
    end;
  end;
  edtGroup.Text := 'Group/Selection: ' + lSelected + '  Total: ' + IntToStr(lStudTotal);
end;

function TFrmVASSStudentExport.IsValidEntry: Boolean;
begin
  Result := True;
  if (Trim(edtDEETSchoolCode.Text) = '') and (Trim(edtVCAASchoolCode.Text) = '') then
  begin
    MessageDlg('DEET School Code and VCAA School Code are both blank. Please enter either of these and try again. ', mtInformation, [mbOK], 0);
    Result := False;
  end;
end;

procedure TFrmVASSStudentExport.RefreshVASSExportData(Sender: TObject);
var
  i: Integer;
  lStudent: TAMGStudent;
  lCount : Integer;
begin
  if IsValidEntry then
  begin
    EnableControls(False);
    try
      grdVASSStudent.RowCount := 2;
      lCount := 1;
      for i := 0 to Students.Count - 1 do
      begin
        if IsStudentInGroup(TAMGStudent(Students.Items[i]).ID) then
        begin
          grdVASSStudent.Cells[0, lCount] := IntToStr(lCount);
          lStudent := TAMGStudent(Students.Items[i]);
          grdVASSStudent.Cells[1, lCount] := cboCourseType.Text;
          grdVASSStudent.Cells[2, lCount] := Trim(edtDEETSchoolCode.Text);
          grdVASSStudent.Cells[3, lCount] := Trim(edtVCAASchoolCode.Text);
          grdVASSStudent.Cells[4, lCount] := '';                              //Optional
          grdVASSStudent.Cells[5, lCount] := lStudent.Code;
          grdVASSStudent.Cells[6, lCount] := lStudent.StName ;
          grdVASSStudent.Cells[7, lCount] := lStudent.First;
          grdVASSStudent.Cells[8, lCount] := '';                              //Optional
          if UpperCase(lStudent.Sex) = 'M' then
            grdVASSStudent.Cells[9, lCount] := 'MR'
          else
            grdVASSStudent.Cells[9, lCount] :='MISS';
          grdVASSStudent.Cells[10, lCount] := AMG_NOT_PROVIDED;
          grdVASSStudent.Cells[11, lCount] := '';                              //Optional
          grdVASSStudent.Cells[12, lCount] := AMG_NOT_PROVIDED;
          grdVASSStudent.Cells[13, lCount] := '';                              //Optional
          grdVASSStudent.Cells[14, lCount] := '****';
          grdVASSStudent.Cells[15, lCount] := '';                              //Optional
          grdVASSStudent.Cells[16, lCount] := 'DD/MM/YYYY';
          grdVASSStudent.Cells[17, lCount] := lStudent.Sex;
          grdVASSStudent.Cells[18, lCount] := YearName[lStudent.StudYear];
          grdVASSStudent.Cells[19, lCount] := ClassCode[lStudent.TcClass];
          grdVASSStudent.Cells[20, lCount] := '';                              //Optional
          grdVASSStudent.Cells[21, lCount] := '';                              //Optional
          grdVASSStudent.Cells[22, lCount] := '';                              //Optional
          grdVASSStudent.Cells[23, lCount] := 'Y';
          grdVASSStudent.Cells[24, lCount] := Copy(lStudent.Code2, 1, 9);
          grdVASSStudent.RowCount := grdVASSStudent.RowCount + 1;
          Inc(lCount);
        end;
      end;
      prbVASSExport.Visible := False;
    finally
      EnableControls(True);
    end;
  end;
end;

end.
