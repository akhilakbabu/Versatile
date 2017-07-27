object FlexiPasteQueryDlg: TFlexiPasteQueryDlg
  Left = 215
  Top = 246
  HelpContext = 317
  Caption = 'Student Paste Query'
  ClientHeight = 139
  ClientWidth = 327
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 9
    Top = 11
    Width = 116
    Height = 15
    AutoSize = False
    Caption = 'Unknown data field:'
  end
  object Label2: TLabel
    Left = 125
    Top = 11
    Width = 190
    Height = 15
    AutoSize = False
    Caption = 'Label2'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object Label3: TLabel
    Left = 9
    Top = 77
    Width = 82
    Height = 13
    Caption = 'Subject name:'
  end
  object Label4: TLabel
    Left = 9
    Top = 36
    Width = 265
    Height = 30
    AutoSize = False
    Caption = 
      'If this is a subject code, you can add it now.  Enter the subjec' +
      't name in the field below.'
    WordWrap = True
  end
  object CancelPaste: TBitBtn
    Left = 161
    Top = 106
    Width = 75
    Height = 25
    Hint = 'Ignore the field'
    Caption = 'Skip'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    Kind = bkCancel
  end
  object OkPaste: TBitBtn
    Left = 78
    Top = 106
    Width = 75
    Height = 25
    Hint = 'Create the Subject Code and continue'
    Caption = 'Add'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    Kind = bkOK
  end
  object Help: TBitBtn
    Left = 244
    Top = 106
    Width = 75
    Height = 25
    Hint = 'What do I do now?'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    Kind = bkHelp
  end
  object Edit1: TEdit
    Left = 102
    Top = 73
    Width = 213
    Height = 21
    Hint = 'Enter subject name'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
  end
end
