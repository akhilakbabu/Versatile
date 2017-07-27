object FrmVASSStudentExport: TFrmVASSStudentExport
  Left = 0
  Top = 0
  Caption = 'VASS Student Export'
  ClientHeight = 636
  ClientWidth = 942
  Color = clBtnFace
  Constraints.MinHeight = 220
  Constraints.MinWidth = 350
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
  object pnlControls: TPanel
    Left = 0
    Top = 0
    Width = 942
    Height = 121
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 1241
    DesignSize = (
      942
      121)
    object lblCourseType: TLabel
      Left = 15
      Top = 21
      Width = 61
      Height = 13
      Caption = 'Course Type'
    end
    object lblDEETSchoolCode: TLabel
      Left = 15
      Top = 48
      Width = 87
      Height = 13
      Caption = 'DEET School Code'
    end
    object lblVCAASchoolCode: TLabel
      Left = 15
      Top = 74
      Width = 89
      Height = 13
      Caption = 'VCAA School Code'
    end
    object lblPrompot: TLabel
      Left = 295
      Top = 21
      Width = 143
      Height = 13
      Caption = 'Select the output file delimiter'
    end
    object btnRefresh: TButton
      Left = 859
      Top = 94
      Width = 65
      Height = 21
      Anchors = [akTop, akRight]
      Caption = '&Refresh'
      Default = True
      TabOrder = 4
      OnClick = RefreshVASSExportData
      ExplicitLeft = 1158
    end
    object edtDEETSchoolCode: TEdit
      Left = 109
      Top = 45
      Width = 92
      Height = 21
      CharCase = ecUpperCase
      MaxLength = 10
      TabOrder = 1
    end
    object edtVCAASchoolCode: TEdit
      Left = 109
      Top = 71
      Width = 52
      Height = 21
      CharCase = ecUpperCase
      MaxLength = 5
      TabOrder = 2
    end
    object cboCourseType: TComboBox
      Left = 109
      Top = 18
      Width = 52
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 0
      Text = 'VCE'
      Items.Strings = (
        'VCE'
        'PDO')
    end
    object cboDelimiter: TComboBox
      Left = 445
      Top = 18
      Width = 60
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 3
      Text = 'Tab'
      Items.Strings = (
        'Tab'
        'Pipe (|)')
    end
    object edtGroup: TEdit
      Left = 295
      Top = 44
      Width = 210
      Height = 21
      TabStop = False
      BorderStyle = bsNone
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 5
      Text = 'Current Group:'
    end
  end
  object pnlVASSExport: TPanel
    Left = 0
    Top = 121
    Width = 942
    Height = 474
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object grdVASSStudent: TAdvStringGrid
      Left = 0
      Top = 0
      Width = 942
      Height = 474
      Cursor = crDefault
      Align = alClient
      ColCount = 25
      DefaultColWidth = 80
      DefaultRowHeight = 18
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goRowSelect]
      ScrollBars = ssBoth
      TabOrder = 0
      GridFixedLineColor = clNone
      ActiveCellFont.Charset = DEFAULT_CHARSET
      ActiveCellFont.Color = clWindowText
      ActiveCellFont.Height = -11
      ActiveCellFont.Name = 'Tahoma'
      ActiveCellFont.Style = [fsBold]
      ActiveCellColor = 9758459
      ActiveCellColorTo = 1414638
      AutoThemeAdapt = True
      ControlLook.FixedGradientFrom = 13627626
      ControlLook.FixedGradientTo = 9224369
      ControlLook.FixedGradientHoverFrom = clGray
      ControlLook.FixedGradientHoverTo = clWhite
      ControlLook.FixedGradientDownFrom = clGray
      ControlLook.FixedGradientDownTo = clSilver
      ControlLook.ControlStyle = csWinXP
      ControlLook.DropDownHeader.Font.Charset = DEFAULT_CHARSET
      ControlLook.DropDownHeader.Font.Color = clWindowText
      ControlLook.DropDownHeader.Font.Height = -11
      ControlLook.DropDownHeader.Font.Name = 'Tahoma'
      ControlLook.DropDownHeader.Font.Style = []
      ControlLook.DropDownHeader.Visible = True
      ControlLook.DropDownHeader.Buttons = <>
      ControlLook.DropDownFooter.Font.Charset = DEFAULT_CHARSET
      ControlLook.DropDownFooter.Font.Color = clWindowText
      ControlLook.DropDownFooter.Font.Height = -11
      ControlLook.DropDownFooter.Font.Name = 'Tahoma'
      ControlLook.DropDownFooter.Font.Style = []
      ControlLook.DropDownFooter.Visible = True
      ControlLook.DropDownFooter.Buttons = <>
      Filter = <>
      FilterDropDown.Font.Charset = DEFAULT_CHARSET
      FilterDropDown.Font.Color = clWindowText
      FilterDropDown.Font.Height = -11
      FilterDropDown.Font.Name = 'Tahoma'
      FilterDropDown.Font.Style = []
      FilterDropDownClear = '(All)'
      FixedColWidth = 80
      FixedRowHeight = 18
      FixedFont.Charset = DEFAULT_CHARSET
      FixedFont.Color = clWindowText
      FixedFont.Height = -11
      FixedFont.Name = 'Tahoma'
      FixedFont.Style = [fsBold]
      FloatFormat = '%.2f'
      Grouping.HeaderColor = 8569007
      Grouping.HeaderColorTo = 4487779
      Grouping.HeaderTextColor = clWhite
      Grouping.HeaderUnderline = True
      Grouping.HeaderLineColor = clGray
      Grouping.SummaryColor = 15004146
      Grouping.SummaryColorTo = 11197146
      Grouping.SummaryLineColor = clGray
      PrintSettings.DateFormat = 'dd/mm/yyyy'
      PrintSettings.Font.Charset = DEFAULT_CHARSET
      PrintSettings.Font.Color = clWindowText
      PrintSettings.Font.Height = -11
      PrintSettings.Font.Name = 'Tahoma'
      PrintSettings.Font.Style = []
      PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
      PrintSettings.FixedFont.Color = clWindowText
      PrintSettings.FixedFont.Height = -11
      PrintSettings.FixedFont.Name = 'Tahoma'
      PrintSettings.FixedFont.Style = []
      PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
      PrintSettings.HeaderFont.Color = clWindowText
      PrintSettings.HeaderFont.Height = -11
      PrintSettings.HeaderFont.Name = 'Tahoma'
      PrintSettings.HeaderFont.Style = []
      PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
      PrintSettings.FooterFont.Color = clWindowText
      PrintSettings.FooterFont.Height = -11
      PrintSettings.FooterFont.Name = 'Tahoma'
      PrintSettings.FooterFont.Style = []
      PrintSettings.PageNumSep = '/'
      SearchFooter.Color = 13627626
      SearchFooter.ColorTo = 9224369
      SearchFooter.FindNextCaption = 'Find &next'
      SearchFooter.FindPrevCaption = 'Find &previous'
      SearchFooter.Font.Charset = DEFAULT_CHARSET
      SearchFooter.Font.Color = clWindowText
      SearchFooter.Font.Height = -11
      SearchFooter.Font.Name = 'Tahoma'
      SearchFooter.Font.Style = []
      SearchFooter.HighLightCaption = 'Highlight'
      SearchFooter.HintClose = 'Close'
      SearchFooter.HintFindNext = 'Find next occurrence'
      SearchFooter.HintFindPrev = 'Find previous occurrence'
      SearchFooter.HintHighlight = 'Highlight occurrences'
      SearchFooter.MatchCaseCaption = 'Match case'
      SearchFooter.SearchColumn = 6
      SearchFooter.Visible = True
      SelectionColor = 9758459
      SelectionColorTo = 1414638
      ShowDesignHelper = False
      Version = '5.8.0.1'
      ExplicitWidth = 1241
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 595
    Width = 942
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitLeft = 40
    ExplicitTop = 611
    ExplicitWidth = 1027
    DesignSize = (
      942
      41)
    object btnClose: TButton
      Left = 861
      Top = 8
      Width = 70
      Height = 24
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'C&lose'
      ModalResult = 2
      TabOrder = 1
      ExplicitLeft = 1160
    end
    object btnExport: TButton
      Left = 784
      Top = 8
      Width = 70
      Height = 24
      Anchors = [akRight, akBottom]
      Caption = 'E&xport'
      Enabled = False
      TabOrder = 0
      OnClick = ExportVASSData
      ExplicitLeft = 1083
    end
    object prbVASSExport: TProgressBar
      Left = 136
      Top = 11
      Width = 506
      Height = 17
      Anchors = [akLeft, akRight, akBottom]
      Smooth = True
      TabOrder = 2
      Visible = False
      ExplicitWidth = 805
    end
  end
end
