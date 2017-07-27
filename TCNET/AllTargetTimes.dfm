object FrmShowAllTargetTimes: TFrmShowAllTargetTimes
  Left = 0
  Top = 0
  Caption = 'All Targert Times'
  ClientHeight = 644
  ClientWidth = 337
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  DesignSize = (
    337
    644)
  PixelsPerInch = 96
  TextHeight = 13
  object lblTargets: TLabel
    Left = 98
    Top = 8
    Width = 37
    Height = 13
    Caption = 'Targets'
  end
  object grdAllTragetTimes: TNiceGrid
    Left = 8
    Top = 27
    Width = 321
    Height = 602
    Cursor = 101
    ColCount = 1
    RowCount = 1
    DefRowHeight = 16
    DefColWidth = 40
    HeaderFont.Charset = DEFAULT_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -11
    HeaderFont.Name = 'Tahoma'
    HeaderFont.Style = []
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    Columns = <
      item
        Title = 'Day'
        Width = 80
      end>
    GutterFont.Charset = DEFAULT_CHARSET
    GutterFont.Color = clWindowText
    GutterFont.Height = -11
    GutterFont.Name = 'Tahoma'
    GutterFont.Style = []
    ShowFooter = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    ExplicitWidth = 437
    ExplicitHeight = 262
  end
  object chkOverwrite: TCheckBox
    Left = 176
    Top = 4
    Width = 113
    Height = 17
    BiDiMode = bdRightToLeft
    Caption = 'Overwrite Entries'
    ParentBiDiMode = False
    TabOrder = 1
    OnClick = RefreshTimeSlots
  end
end
