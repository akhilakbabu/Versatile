object TrackChoicesDlg: TTrackChoicesDlg
  Left = 182
  Top = 183
  BorderStyle = bsDialog
  Caption = 'Track Student Enrolments'
  ClientHeight = 304
  ClientWidth = 528
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 14
    Top = 12
    Width = 81
    Height = 13
    Caption = 'Calendar Year'
    FocusControl = DateTimePicker1
  end
  object Label3: TLabel
    Left = 12
    Top = 150
    Width = 261
    Height = 13
    AutoSize = False
    Caption = '&Years for Enrolment Tracking files:'
  end
  object DateTimePicker1: TDateTimePicker
    Left = 101
    Top = 8
    Width = 186
    Height = 21
    Date = 38217.600647881900000000
    Time = 38217.600647881900000000
    TabOrder = 0
  end
  object RadioGroup1: TRadioGroup
    Left = 8
    Top = 48
    Width = 277
    Height = 73
    Caption = 'Semester'
    Columns = 2
    ItemIndex = 1
    Items.Strings = (
      'Semester &1'
      'Semester &2'
      'Semester &3'
      'Semester &4')
    TabOrder = 1
  end
  object BitBtn1: TBitBtn
    Left = 359
    Top = 270
    Width = 75
    Height = 25
    Caption = '&OK'
    TabOrder = 2
    OnClick = BitBtn1Click
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 441
    Top = 270
    Width = 75
    Height = 25
    Caption = '&Cancel'
    TabOrder = 3
    Kind = bkCancel
  end
end
