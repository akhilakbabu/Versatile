object FlexiPasteDlg: TFlexiPasteDlg
  Left = 280
  Top = 22
  HelpContext = 317
  BorderStyle = bsDialog
  Caption = 'Paste Student Data'
  ClientHeight = 195
  ClientWidth = 375
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    375
    195)
  PixelsPerInch = 96
  TextHeight = 13
  object lblDeleteStudentsMsg: TLabel
    Left = 9
    Top = 133
    Width = 158
    Height = 26
    Caption = 'All existing students will be cleared.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
    WordWrap = True
  end
  object CancelPaste: TBitBtn
    Left = 208
    Top = 163
    Width = 75
    Height = 25
    Hint = 'Exit without pasting'
    Anchors = [akRight, akBottom]
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    Kind = bkCancel
  end
  object OkPaste: TBitBtn
    Left = 126
    Top = 163
    Width = 75
    Height = 25
    Hint = 'Paste using the selected settings'
    Anchors = [akRight, akBottom]
    Caption = 'Paste'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnClick = OkPasteClick
    Kind = bkOK
  end
  object Help: TBitBtn
    Left = 291
    Top = 163
    Width = 75
    Height = 25
    Hint = 'What do I do now?'
    Anchors = [akRight, akBottom]
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    Kind = bkHelp
  end
  object IDstudentsOpt: TRadioGroup
    Left = 9
    Top = 8
    Width = 175
    Height = 100
    Hint = 
      'Specify which fields to use to uniquely identify individual stud' +
      'ents'
    Caption = 'Identify Students using'
    ItemIndex = 2
    Items.Strings = (
      'Student ID'
      'Student name and year'
      'All Student fields')
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnClick = IDstudentsOptClick
  end
  object SubChoicesOpt: TRadioGroup
    Left = 193
    Top = 8
    Width = 172
    Height = 100
    Hint = 'How to deal with newly imported subject choices'
    Caption = 'Current subject choices'
    ItemIndex = 0
    Items.Strings = (
      'Replace'
      'Add new choices')
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
  end
  object StudFieldsOpt: TRadioGroup
    Left = 8
    Top = 166
    Width = 96
    Height = 25
    Hint = 
      'How to deal with other student fields such as year, gender, roll' +
      'class, home room and tutor once the student is identified'
    Caption = 'Current student fields'
    ItemIndex = 1
    Items.Strings = (
      'Update from new'
      'Keep (no change)')
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    Visible = False
  end
  object CheckBox1: TCheckBox
    Left = 193
    Top = 117
    Width = 153
    Height = 17
    Hint = 'Tick to add new subjects from your pasted data'
    Caption = 'Add unknown subjects'
    TabOrder = 6
  end
  object chkClearAllExistingStudents: TCheckBox
    Left = 9
    Top = 117
    Width = 174
    Height = 17
    Caption = 'Clear All Existing Students'
    TabOrder = 7
    Visible = False
    OnClick = WarnUserOfDeletingStudents
  end
end
