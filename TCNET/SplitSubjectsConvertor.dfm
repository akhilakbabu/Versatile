object FrmSplitSubjectConv: TFrmSplitSubjectConv
  Left = 0
  Top = 0
  Caption = 'Split Subject Convertor'
  ClientHeight = 510
  ClientWidth = 593
  Color = clBtnFace
  Constraints.MinHeight = 200
  Constraints.MinWidth = 300
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lsbSubject: TListBox
    Left = 0
    Top = 25
    Width = 153
    Height = 444
    Align = alLeft
    Columns = 1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clFuchsia
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    TabOrder = 0
    OnClick = DisplaySpliSubjects
  end
  object lsvSplit: TListView
    Left = 153
    Top = 25
    Width = 440
    Height = 444
    Align = alClient
    Columns = <
      item
        Caption = 'Subject'
        Width = 120
      end
      item
        Caption = 'Subject Name'
        Width = 230
      end
      item
        Caption = 'Class Num.'
        Width = 68
      end>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clFuchsia
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    SortType = stText
    TabOrder = 1
    ViewStyle = vsReport
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 469
    Width = 593
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      593
      41)
    object btnClose: TButton
      Left = 511
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'C&lose'
      Default = True
      ModalResult = 2
      TabOrder = 0
    end
  end
  object pnlPrompt: TPanel
    Left = 0
    Top = 0
    Width = 593
    Height = 25
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    DesignSize = (
      593
      25)
    object lblSubjectCode: TLabel
      Left = 44
      Top = 6
      Width = 64
      Height = 13
      Caption = 'Subject Code'
    end
    object lblSubjectSplits: TLabel
      Left = 215
      Top = 6
      Width = 378
      Height = 13
      Alignment = taCenter
      Anchors = [akLeft, akRight]
      AutoSize = False
      Caption = 'Subject Splits'
      ExplicitWidth = 428
    end
  end
end
