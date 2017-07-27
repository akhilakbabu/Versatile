unit VASSStudentChoicesExport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, BaseGrid, ExtCtrls, ComCtrls, AdvObj, AdvGrid, XML.UTILS,
  XML.DISPLAY;

type
  TFrmVASSStudentChoicesExport = class(TForm)
    pnlControls: TPanel;
    pnlVASSExport: TPanel;
    pnlButtons: TPanel;
    btnClose: TButton;
    btnRefresh: TButton;
    edtDEETSchoolCode: TEdit;
    lblDEETSchoolCode: TLabel;
    edtVCAASchoolCode: TEdit;
    lblVCAASchoolCode: TLabel;
    btnExport: TButton;
    prbVASSExport: TProgressBar;
    cboDelimiter: TComboBox;
    lblPrompot: TLabel;
    edtGroup: TEdit;
    grdVASSStudentChoices: TAdvStringGrid;
    lblPrompt: TLabel;
    procedure RefreshVASSExportData(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ExportVASSData(Sender: TObject);
  private
    function IsValidEntry: Boolean;
    procedure EnableControls(const pEnable: Boolean);
    function SubjectCodeFromComposite(const lCompCode: string): string;
  end;


(* This epxort is only for those who use 1S, 2S, 3S asa start of Subject Code in TC and needs to be trimmed for the export purpose.
No  FIELD	                        LENGTH	            DETAILS
--------------------------------------------------------------------------------------------------------------------------------------------------
1	DEET School Code	              10 chars(maximum)	  Mandatory if VCAA School Code is blank.
                                                      Mark as text in Excel to preserve the leading zero.
2	VCAA School Code	              5 chars	            Mandatory if DEET School Code is blank.
                                                      Mark as text in Excel to preserve the leading zero.
3	Student Number	                9 chars	            Optional.  Alphanumeric.  If entered it must be a valid student number.
4	External Student Identifier	    12 chars(maximum)   Optional.  Alphanumeric. If included it can be used to identify the student instead of the Student Number in the Amend Student import
5	Family Name	                    25 chars(maximum)	  Mandatory.  Can only contain alphabetic, hyphen, apostrophes and single spaces and must contain at least one character.
6	First Name	                    15 chars(maximum)	  Mandatory.  Can only contain alphabetic, hyphen, apostrophes and single spaces and must contain at least one character.
7	Second Name	                    15 chars(maximum)	  Not mandatory.  Can only contain alphabetic, hyphen, apostrophes and single spaces.
8	Unit Code	                      15 chars            Mandatory
9 Class Code	                    02 chars            Mandatory
10 DEET Assessing School Code	    10 chars(maximum)	  Mandatory if VCAA School Code is blank.
                                                      Mark as text in Excel to preserve the leading zero.
11 VCAA Assessing School Code	    5 chars	            Mandatory if DEET School Code is blank.
                                                      Mark as text in Excel to preserve the leading zero.
12	Focus Area	                  03 chars        	  Not mandatory.
*)


var
  FrmVASSStudentChoicesExport: TFrmVASSStudentChoicesExport;

implementation

uses
  uAMGStudent, uAMGConst, TimeChartGlobals, uAMGCommon, StrUtils, StCommon;

{$R *.dfm}

procedure TFrmVASSStudentChoicesExport.EnableControls(const pEnable: Boolean);
begin
  btnRefresh.Enabled := pEnable;
  btnExport.Enabled := pEnable;
end;

procedure TFrmVASSStudentChoicesExport.ExportVASSData(Sender: TObject);
var
  lList: TStringList;
  i: Integer;
  j: Integer;
  lDelimiter: Char;
  lRowStr: string;
begin
  prbVASSExport.Position := 0;
  EnableControls(False);
  lList := TStringList.Create;
  try
    prbVASSExport.Visible := True;
    if cboDelimiter.ItemIndex = 0 then
      lDelimiter := Chr(9)
    else
      lDelimiter := AMG_PIPE;
    for i := 1 to grdVASSStudentChoices.RowCount do
    begin
      lRowStr := '';
      for j := 1 to grdVASSStudentChoices.ColCount - 1 do
        lRowStr := lRowStr + grdVASSStudentChoices.Cells[j, i] + lDelimiter;
      lList.Add(lRowStr);
      prbVASSExport.Position := Round(i  * 100 / grdVASSStudentChoices.RowCount);
      Application.ProcessMessages;
    end;
    lList.SaveToFile(Directories.DataDir + '\' + AMG_VASS_STUDENT_CHOICES_EXPORT_FILE);
    MessageDlg(Format(AMG_DATA_EXPORTED_AS_MSG, [Directories.DataDir, AMG_VASS_STUDENT_CHOICES_EXPORT_FILE]), mtInformation, [mbOK], 0);
  finally
    btnRefresh.Enabled := True;
    FreeAndNil(lList);
  end;
end;

procedure TFrmVASSStudentChoicesExport.FormShow(Sender: TObject);
var
  lStudTotal: Integer;
  lSelected: string;
begin
  grdVASSStudentChoices.ColWidths[0] := 40;
  grdVASSStudentChoices.ColWidths[1] := 120;
  grdVASSStudentChoices.Cells[1, 0] := 'DEET School Code';
  grdVASSStudentChoices.ColWidths[2] := 120;
  grdVASSStudentChoices.Cells[2, 0] := 'VCAA School Code';
  grdVASSStudentChoices.ColWidths[3] := 90;
  grdVASSStudentChoices.Cells[3, 0] := 'Student Number';
  grdVASSStudentChoices.ColWidths[4] := 160;
  grdVASSStudentChoices.Cells[4, 0] := 'External Student Identifier';
  grdVASSStudentChoices.ColWidths[5] := 120;
  grdVASSStudentChoices.Cells[5, 0] := 'Family Name';
  grdVASSStudentChoices.ColWidths[6] := 120;
  grdVASSStudentChoices.Cells[6, 0] := 'First Name';
  grdVASSStudentChoices.ColWidths[7] := 90;
  grdVASSStudentChoices.Cells[7, 0] := 'Second Name';
  grdVASSStudentChoices.ColWidths[8] := 65;
  grdVASSStudentChoices.Cells[8, 0] := 'Unit Code';
  grdVASSStudentChoices.ColWidths[9] := 70;
  grdVASSStudentChoices.Cells[9, 0] := 'Class Code';
  grdVASSStudentChoices.ColWidths[10] := 160;
  grdVASSStudentChoices.Cells[10, 0] := 'DEET Assessing School Code';
  grdVASSStudentChoices.ColWidths[11] := 160;
  grdVASSStudentChoices.Cells[11, 0] := 'VCAA Assessing School Code';
  grdVASSStudentChoices.ColWidths[12] := 80;
  grdVASSStudentChoices.Cells[12, 0] := 'Focus Area';
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

function TFrmVASSStudentChoicesExport.IsValidEntry: Boolean;
begin
  Result := True;
  if (Trim(edtDEETSchoolCode.Text) = '') and (Trim(edtVCAASchoolCode.Text) = '') then
  begin
    MessageDlg('DEET School Code and VCAA School Code are both blank. Please enter either of these and try again. ', mtInformation, [mbOK], 0);
    Result := False;
  end;
end;

procedure TFrmVASSStudentChoicesExport.RefreshVASSExportData(Sender: TObject);
var
  i: Integer;
  j: Integer;
  lStudent: TAMGStudent;
  lSubject: string;
  lClassCode: string;
  lCount: Integer;

  function GetFirstNameFromComposite(const pName: string): string;
  var
    lLDelimPos: Integer;
    lRDelimPos: Integer;
    lStr: string;
  begin
    Result := pName;
    lLDelimPos := Pos('(', pName);
    if lLDelimPos <> 0 then
    begin
      lRDelimPos := Pos(')', pName);
      lStr := Copy(pName, lLDelimPos, lRDelimPos);
      Result := StringReplace(pName, lStr, '', [rfReplaceAll, rfIgnoreCase])
    end;
  end;

  function GetSecondNameFromComposite(const pName: string): string;
  var
    lLDelimPos: Integer;
    lRDelimPos: Integer;
  begin
    Result := '';
    lLDelimPos := Pos('(', pName);
    if lLDelimPos <> 0 then
    begin
      lRDelimPos := Pos(')', pName);
      if lRDelimPos = 0 then
        lRDelimPos := Length(pName);

      Result := Trim(Copy(pName, lLDelimPos + 1, lRDelimPos - lLDelimPos - 1));
    end;
  end;

begin
  if IsValidEntry then
  begin
    EnableControls(False);
    try
      grdVASSStudentChoices.RowCount := 2;
      lCount := 1;
      for i := 0 to Students.Count - 1 do
      begin
        if IsStudentInGroup(TAMGStudent(Students.Items[i]).ID) then
        begin
          lStudent := TAMGStudent(Students.Items[i]);
          for j := 0 to lStudent.Choices.Count -1 do
          begin
            lSubject := SubCode[TAMGChoice(lStudent.Choices.Items[j]).Sub];
            lSubject := Trim(lSubject);
            // Note: The following 2 lines have been removed to accommodate mantis #1410
            
            //if (UpperCase(Copy(lSubject, 1, 2)) <> '2S') and (UpperCase(Copy(lSubject, 1, 2)) <> '3S') then
            //  lSubject := '';  //Ignore the subject

            lSubject := SubjectCodeFromComposite(lSubject);
            if lSubject <> '' then
            begin
              grdVASSStudentChoices.Cells[0, lCount] := IntToStr(lCount);
              grdVASSStudentChoices.Cells[1, lCount] := Trim(edtDEETSchoolCode.Text);
              grdVASSStudentChoices.Cells[2, lCount] := Trim(edtVCAASchoolCode.Text);
              grdVASSStudentChoices.Cells[3, lCount] := '';                              //Optional
              grdVASSStudentChoices.Cells[4, lCount] := lStudent.Code;
              grdVASSStudentChoices.Cells[5, lCount] := lStudent.StName;
              grdVASSStudentChoices.Cells[6, lCount] := GetFirstNameFromComposite(lStudent.First);
              grdVASSStudentChoices.Cells[7, lCount] := GetSecondNameFromComposite(lStudent.First);
              //Very special case
              if (UpperCase(lSubject) = 'EN011EA') or
                 (UpperCase(lSubject) = 'EN011EB') or
                 (UpperCase(lSubject) = 'EN012EA') or
                 (UpperCase(lSubject) = 'EN012EB') then
              begin
                lClassCode := Copy(lSubject, Length(lSubject) - 1, 2);
                //RightStr(lSubject, 2);
                lSubject := Copy(lSubject, 1, Length(lSubject) -2);
              end
              else
              begin
                lClassCode := Copy(lSubject, Length(lSubject), 1);
                if IsAlphabetic(lClassCode) then
                  lSubject := Copy(lSubject, 1, Length(lSubject) -1)
                else
                  lClassCode := '';
              end;
              grdVASSStudentChoices.Cells[8, lCount] := lSubject;
              grdVASSStudentChoices.Cells[9, lCount] := lClassCode;
              grdVASSStudentChoices.Cells[10, lCount] := '';                           //Optional
              grdVASSStudentChoices.Cells[11, lCount] := Trim(edtVCAASchoolCode.Text);
              grdVASSStudentChoices.Cells[12, lCount] := '';                           //Optional
              grdVASSStudentChoices.RowCount := grdVASSStudentChoices.RowCount + 1;
              Inc(lCount);
            end;
          end;  // for
        end;  // if
      end; // for
    finally
      prbVASSExport.Visible := False;
      EnableControls(True);
    end;
  end;
end;

function TFrmVASSStudentChoicesExport.SubjectCodeFromComposite(const lCompCode: string): string;
//Remove an extra part been added to the code such as 1S, 2S or 3S
begin
  if (Copy(lCompCode, 1, 2) = '1S') or
     (Copy(lCompCode, 1, 2) = '2S') or
     (Copy(lCompCode, 1, 2) = '3S') then
    Result := Trim(Copy(lCompCode, 3, Length(lCompCode)))
  else
    Result := Trim(lCompCode);
end;

end.
