unit FlexiPaste;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, TimeChartGlobals, XML.DISPLAY;

type
  TFlexiPasteDlg = class(TForm)
    CancelPaste: TBitBtn;
    OkPaste: TBitBtn;
    Help: TBitBtn;
    IDstudentsOpt: TRadioGroup;
    SubChoicesOpt: TRadioGroup;
    StudFieldsOpt: TRadioGroup;
    CheckBox1: TCheckBox;
    chkClearAllExistingStudents: TCheckBox;
    lblDeleteStudentsMsg: TLabel;
    procedure OkPasteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure IDstudentsOptClick(Sender: TObject);
    procedure WarnUserOfDeletingStudents(Sender: TObject);
  private
    FIsDeleteOK: Boolean;
  public
    property IsDeleteOK: Boolean read FIsDeleteOK write FIsDeleteOK;
  end;

var
  FlexiPasteDlg: TFlexiPasteDlg;

implementation

{$R *.dfm}

procedure TFlexiPasteDlg.OkPasteClick(Sender: TObject);
begin
 XML_DISPLAY.StudPasteID:=IDstudentsOpt.itemindex;
 XML_DISPLAY.StudPasteSub:=SubChoicesOpt.itemindex;
 XML_DISPLAY.StudPasteFields:=StudFieldsOpt.itemindex;
 XML_DISPLAY.StudPasteAddSub:=CheckBox1.Checked;
end;

procedure TFlexiPasteDlg.WarnUserOfDeletingStudents(Sender: TObject);
var
  lUserAccept: Boolean;
begin
  try
    if chkClearAllExistingStudents.Checked then
    begin
      lUserAccept := MessageDlg('This Options will delete all the existing students before adding the new data. Are you sure you want to keep this option?', mtWarning, [mbYes, mbNo], 0) = mrYes;
      FIsDeleteOK := lUserAccept;
      lblDeleteStudentsMsg.Visible := lUserAccept;
    end
    else
    begin
      FIsDeleteOK := False;
      lblDeleteStudentsMsg.Visible := False;
    end;
  finally
    if not lUserAccept then
    begin
      chkClearAllExistingStudents.Checked := False;
    end;

  end;
end;

procedure TFlexiPasteDlg.FormCreate(Sender: TObject);
begin
 IDstudentsOpt.itemindex:=XML_DISPLAY.StudPasteID;
 SubChoicesOpt.itemindex:=XML_DISPLAY.StudPasteSub;
 StudFieldsOpt.itemindex:=XML_DISPLAY.StudPasteFields;
 CheckBox1.Checked:=XML_DISPLAY.StudPasteAddSub;
end;

procedure TFlexiPasteDlg.IDstudentsOptClick(Sender: TObject);
begin
 StudFieldsOpt.Enabled:=(IDstudentsOpt.itemindex<>2);
end;

end.
