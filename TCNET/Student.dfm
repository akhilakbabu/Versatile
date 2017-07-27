object FrmStudent: TFrmStudent
  Left = 0
  Top = 0
  Caption = 'Student List'
  ClientHeight = 778
  ClientWidth = 1446
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object grdStudent: TStringGrid
    Left = 0
    Top = 69
    Width = 1446
    Height = 709
    Align = alClient
    ColCount = 20
    DefaultRowHeight = 18
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goRowSelect]
    ParentFont = False
    TabOrder = 0
    OnDblClick = ChangeStudent
    OnDrawCell = AlignText
  end
  object pnlCpontrols: TPanel
    Left = 0
    Top = 28
    Width = 1446
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
  end
  object AdvToolBarPager1: TAdvToolBarPager
    Left = 0
    Top = 0
    Width = 1446
    Height = 28
    ActivePage = AdvToolBarPager11
    CaptionButtons = [cbClose, cbMinimize, cbMaximize]
    TabGroups = <>
    TabSettings.EndMargin = 0
    Persistence.Location = plRegistry
    Persistence.Enabled = False
    PageLeftMargin = 0
    PageRightMargin = 0
    OptionPicture.Data = {
      424DA20400000000000036040000280000000900000009000000010008000000
      00006C0000000000000000000000000100000000000000000000000080000080
      000000808000800000008000800080800000C0C0C000C0DCC000F0CAA6000020
      400000206000002080000020A0000020C0000020E00000400000004020000040
      400000406000004080000040A0000040C0000040E00000600000006020000060
      400000606000006080000060A0000060C0000060E00000800000008020000080
      400000806000008080000080A0000080C0000080E00000A0000000A0200000A0
      400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0200000C0
      400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0200000E0
      400000E0600000E0800000E0A00000E0C00000E0E00040000000400020004000
      400040006000400080004000A0004000C0004000E00040200000402020004020
      400040206000402080004020A0004020C0004020E00040400000404020004040
      400040406000404080004040A0004040C0004040E00040600000406020004060
      400040606000406080004060A0004060C0004060E00040800000408020004080
      400040806000408080004080A0004080C0004080E00040A0000040A0200040A0
      400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0200040C0
      400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0200040E0
      400040E0600040E0800040E0A00040E0C00040E0E00080000000800020008000
      400080006000800080008000A0008000C0008000E00080200000802020008020
      400080206000802080008020A0008020C0008020E00080400000804020008040
      400080406000804080008040A0008040C0008040E00080600000806020008060
      400080606000806080008060A0008060C0008060E00080800000808020008080
      400080806000808080008080A0008080C0008080E00080A0000080A0200080A0
      400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0200080C0
      400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0200080E0
      400080E0600080E0800080E0A00080E0C00080E0E000C0000000C0002000C000
      4000C0006000C0008000C000A000C000C000C000E000C0200000C0202000C020
      4000C0206000C0208000C020A000C020C000C020E000C0400000C0402000C040
      4000C0406000C0408000C040A000C040C000C040E000C0600000C0602000C060
      4000C0606000C0608000C060A000C060C000C060E000C0800000C0802000C080
      4000C0806000C0808000C080A000C080C000C080E000C0A00000C0A02000C0A0
      4000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C02000C0C0
      4000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000FF0000FF
      000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FDFDFDFDFDFFFFFFFF00
      0000FDFDFDFDE3E3E3E3FF000000FDE3FFFDFDE3E3E3FF000000FDE3FFFDFDE3
      E3E3FF000000FDE3FFFDE3FFFDE3FD000000FDE3FFFDFDFDFDFDFD000000FDE3
      FFFFFFFFFFFDFD000000FDE3E3E3E3E3E3FDFD000000FDFDFDFDFDFDFDFDFD00
      0000}
    OptionDisabledPicture.Data = {
      424DA20400000000000036040000280000000900000009000000010008000000
      00006C0000000000000000000000000100000000000000000000000080000080
      000000808000800000008000800080800000C0C0C000C0DCC000F0CAA6000020
      400000206000002080000020A0000020C0000020E00000400000004020000040
      400000406000004080000040A0000040C0000040E00000600000006020000060
      400000606000006080000060A0000060C0000060E00000800000008020000080
      400000806000008080000080A0000080C0000080E00000A0000000A0200000A0
      400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0200000C0
      400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0200000E0
      400000E0600000E0800000E0A00000E0C00000E0E00040000000400020004000
      400040006000400080004000A0004000C0004000E00040200000402020004020
      400040206000402080004020A0004020C0004020E00040400000404020004040
      400040406000404080004040A0004040C0004040E00040600000406020004060
      400040606000406080004060A0004060C0004060E00040800000408020004080
      400040806000408080004080A0004080C0004080E00040A0000040A0200040A0
      400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0200040C0
      400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0200040E0
      400040E0600040E0800040E0A00040E0C00040E0E00080000000800020008000
      400080006000800080008000A0008000C0008000E00080200000802020008020
      400080206000802080008020A0008020C0008020E00080400000804020008040
      400080406000804080008040A0008040C0008040E00080600000806020008060
      400080606000806080008060A0008060C0008060E00080800000808020008080
      400080806000808080008080A0008080C0008080E00080A0000080A0200080A0
      400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0200080C0
      400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0200080E0
      400080E0600080E0800080E0A00080E0C00080E0E000C0000000C0002000C000
      4000C0006000C0008000C000A000C000C000C000E000C0200000C0202000C020
      4000C0206000C0208000C020A000C020C000C020E000C0400000C0402000C040
      4000C0406000C0408000C040A000C040C000C040E000C0600000C0602000C060
      4000C0606000C0608000C060A000C060C000C060E000C0800000C0802000C080
      4000C0806000C0808000C080A000C080C000C080E000C0A00000C0A02000C0A0
      4000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C02000C0C0
      4000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000FF0000FF
      000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FDFDFDFDFDFFFFFFFF00
      0000FDFDFDFD07070707FF000000FD07FFFDFD070707FF000000FD07FFFDFD07
      0707FF000000FD07FFFD07FFFD07FD000000FD07FFFDFDFDFDFDFD000000FD07
      FFFFFFFFFFFDFD000000FD070707070707FDFD000000FDFDFDFDFDFDFDFDFD00
      0000}
    TabOrder = 3
    TabStop = True
    object AdvToolBarPager11: TAdvPage
      Left = 4
      Top = 53
      Width = 1438
      Height = -30
      Caption = 'AdvToolBarPager11'
    end
    object AdvToolBarPager12: TAdvPage
      Left = 4
      Top = 53
      Width = 1438
      Height = -30
      Caption = 'AdvToolBarPager12'
    end
    object AdvToolBarPager13: TAdvPage
      Left = 4
      Top = 53
      Width = 1438
      Height = -30
      Caption = 'AdvToolBarPager13'
    end
    object AdvToolBar1: TAdvToolBar
      AlignWithMargins = True
      Left = 0
      Top = 0
      Width = 1385
      Height = 26
      AllowFloating = True
      AutoPositionControls = False
      AutoSize = False
      Locked = True
      Caption = '`'
      CaptionFont.Charset = DEFAULT_CHARSET
      CaptionFont.Color = clWindowText
      CaptionFont.Height = -11
      CaptionFont.Name = 'Tahoma'
      CaptionFont.Style = []
      CompactImageIndex = -1
      ShowClose = False
      FullSize = True
      TextAutoOptionMenu = 'Student List Toolbar'
      TextOptionMenu = 'Options'
      ToolBarStyler = AdvToolBarOfficeStyler1
      ParentStyler = False
      ParentOptionPicture = True
      ParentShowHint = False
      ToolBarIndex = -1
      object AdvToolBarButton1: TAdvToolBarButton
        Left = 8
        Top = 0
        Width = 33
        Height = 26
        Appearance.CaptionFont.Charset = DEFAULT_CHARSET
        Appearance.CaptionFont.Color = clWindowText
        Appearance.CaptionFont.Height = -11
        Appearance.CaptionFont.Name = 'Tahoma'
        Appearance.CaptionFont.Style = []
        Caption = 'Copy'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Position = daTop
        ShowCaption = True
        Version = '3.5.3.2'
      end
      object AdvToolBarButton2: TAdvToolBarButton
        Left = 51
        Top = 0
        Width = 35
        Height = 26
        Appearance.CaptionFont.Charset = DEFAULT_CHARSET
        Appearance.CaptionFont.Color = clWindowText
        Appearance.CaptionFont.Height = -11
        Appearance.CaptionFont.Name = 'Tahoma'
        Appearance.CaptionFont.Style = []
        Caption = 'Paste'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Position = daTop
        ShowCaption = True
        Version = '3.5.3.2'
      end
      object AdvToolBarButton4: TAdvToolBarButton
        Left = 120
        Top = 0
        Width = 27
        Height = 26
        Appearance.CaptionFont.Charset = DEFAULT_CHARSET
        Appearance.CaptionFont.Color = clWindowText
        Appearance.CaptionFont.Height = -11
        Appearance.CaptionFont.Name = 'Tahoma'
        Appearance.CaptionFont.Style = []
        Caption = 'Add'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Position = daTop
        ShowCaption = True
        Version = '3.5.3.2'
        OnClick = DisplayAddStudent
      end
      object AdvToolBarButton5: TAdvToolBarButton
        Left = 162
        Top = 0
        Width = 45
        Height = 26
        Appearance.CaptionFont.Charset = DEFAULT_CHARSET
        Appearance.CaptionFont.Color = clWindowText
        Appearance.CaptionFont.Height = -11
        Appearance.CaptionFont.Name = 'Tahoma'
        Appearance.CaptionFont.Style = []
        Caption = 'Change'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Position = daTop
        ShowCaption = True
        Version = '3.5.3.2'
        OnClick = DisplayChangeStudent
      end
      object AdvToolBarButton6: TAdvToolBarButton
        Left = 226
        Top = 0
        Width = 39
        Height = 26
        Appearance.CaptionFont.Charset = DEFAULT_CHARSET
        Appearance.CaptionFont.Color = clWindowText
        Appearance.CaptionFont.Height = -11
        Appearance.CaptionFont.Name = 'Tahoma'
        Appearance.CaptionFont.Style = []
        Caption = 'Delete'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Position = daTop
        ShowCaption = True
        Version = '3.5.3.2'
        OnClick = DisplayDeleteStudent
      end
      object AdvToolBarSeparator1: TAdvToolBarSeparator
        Left = 266
        Top = 0
        Width = 10
        Height = 26
        LineColor = clBtnShadow
      end
      object AdvToolBarButton7: TAdvToolBarButton
        Left = 287
        Top = 0
        Width = 75
        Height = 26
        Appearance.CaptionFont.Charset = DEFAULT_CHARSET
        Appearance.CaptionFont.Color = clWindowText
        Appearance.CaptionFont.Height = -11
        Appearance.CaptionFont.Name = 'Tahoma'
        Appearance.CaptionFont.Style = []
        Caption = 'Common Data'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Position = daTop
        ShowCaption = True
        Version = '3.5.3.2'
        OnClick = DisplayCommonData
      end
      object AdvToolBarButton8: TAdvToolBarButton
        Left = 374
        Top = 0
        Width = 73
        Height = 26
        Appearance.CaptionFont.Charset = DEFAULT_CHARSET
        Appearance.CaptionFont.Color = clWindowText
        Appearance.CaptionFont.Height = -11
        Appearance.CaptionFont.Name = 'Tahoma'
        Appearance.CaptionFont.Style = []
        Caption = 'Clear Choices'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Position = daTop
        ShowCaption = True
        Version = '3.5.3.2'
        OnClick = DoClearStudentChoices
      end
      object AdvToolBarButton9: TAdvToolBarButton
        Left = 460
        Top = 0
        Width = 95
        Height = 26
        Appearance.CaptionFont.Charset = DEFAULT_CHARSET
        Appearance.CaptionFont.Color = clWindowText
        Appearance.CaptionFont.Height = -11
        Appearance.CaptionFont.Name = 'Tahoma'
        Appearance.CaptionFont.Style = []
        Caption = 'Student Timetable'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Position = daTop
        ShowCaption = True
        Version = '3.5.3.2'
      end
      object AdvToolBarButton10: TAdvToolBarButton
        Left = 573
        Top = 0
        Width = 30
        Height = 26
        Appearance.CaptionFont.Charset = DEFAULT_CHARSET
        Appearance.CaptionFont.Color = clWindowText
        Appearance.CaptionFont.Height = -11
        Appearance.CaptionFont.Name = 'Tahoma'
        Appearance.CaptionFont.Style = []
        Caption = 'Print'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Position = daTop
        ShowCaption = True
        Version = '3.5.3.2'
      end
      object AdvToolBarSeparator2: TAdvToolBarSeparator
        Left = 557
        Top = 0
        Width = 10
        Height = 26
        LineColor = clBtnShadow
      end
      object AdvToolBarButton11: TAdvToolBarButton
        Left = 612
        Top = 0
        Width = 71
        Height = 26
        Appearance.CaptionFont.Charset = DEFAULT_CHARSET
        Appearance.CaptionFont.Color = clWindowText
        Appearance.CaptionFont.Height = -11
        Appearance.CaptionFont.Name = 'Tahoma'
        Appearance.CaptionFont.Style = []
        Caption = 'Print Preview'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Position = daTop
        ShowCaption = True
        Version = '3.5.3.2'
      end
      object AdvToolBarSeparator3: TAdvToolBarSeparator
        Left = 92
        Top = 0
        Width = 10
        Height = 26
        LineColor = clBtnShadow
      end
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 696
    Top = 304
  end
  object AdvToolBarOfficeStyler1: TAdvToolBarOfficeStyler
    Style = bsOffice2007Luna
    BorderColor = 14141623
    BorderColorHot = 14731181
    ButtonAppearance.Color = 13627626
    ButtonAppearance.ColorTo = 9224369
    ButtonAppearance.ColorChecked = 9229823
    ButtonAppearance.ColorCheckedTo = 5812223
    ButtonAppearance.ColorDown = 5149182
    ButtonAppearance.ColorDownTo = 9556991
    ButtonAppearance.ColorHot = 13432063
    ButtonAppearance.ColorHotTo = 9556223
    ButtonAppearance.BorderDownColor = 3693887
    ButtonAppearance.BorderHotColor = 3693887
    ButtonAppearance.BorderCheckedColor = 3693887
    ButtonAppearance.CaptionFont.Charset = DEFAULT_CHARSET
    ButtonAppearance.CaptionFont.Color = clWindowText
    ButtonAppearance.CaptionFont.Height = -11
    ButtonAppearance.CaptionFont.Name = 'Tahoma'
    ButtonAppearance.CaptionFont.Style = []
    CaptionAppearance.CaptionColor = 15915714
    CaptionAppearance.CaptionColorTo = 15784385
    CaptionAppearance.CaptionTextColor = 11168318
    CaptionAppearance.CaptionBorderColor = clHighlight
    CaptionAppearance.CaptionColorHot = 16769224
    CaptionAppearance.CaptionColorHotTo = 16772566
    CaptionAppearance.CaptionTextColorHot = 11168318
    CaptionFont.Charset = DEFAULT_CHARSET
    CaptionFont.Color = clWindowText
    CaptionFont.Height = -11
    CaptionFont.Name = 'Tahoma'
    CaptionFont.Style = []
    ContainerAppearance.LineColor = clBtnShadow
    ContainerAppearance.Line3D = True
    Color.Color = 15587527
    Color.ColorTo = 16181721
    Color.Direction = gdVertical
    Color.Mirror.Color = 15984090
    Color.Mirror.ColorTo = 15785680
    Color.Mirror.ColorMirror = 15587784
    Color.Mirror.ColorMirrorTo = 16510428
    ColorHot.Color = 16773606
    ColorHot.ColorTo = 16444126
    ColorHot.Direction = gdVertical
    ColorHot.Mirror.Color = 16642021
    ColorHot.Mirror.ColorTo = 16576743
    ColorHot.Mirror.ColorMirror = 16509403
    ColorHot.Mirror.ColorMirrorTo = 16510428
    CompactGlowButtonAppearance.BorderColor = 14727579
    CompactGlowButtonAppearance.BorderColorHot = 15193781
    CompactGlowButtonAppearance.BorderColorDown = 12034958
    CompactGlowButtonAppearance.BorderColorChecked = 12034958
    CompactGlowButtonAppearance.Color = 15653832
    CompactGlowButtonAppearance.ColorTo = 16178633
    CompactGlowButtonAppearance.ColorChecked = 14599853
    CompactGlowButtonAppearance.ColorCheckedTo = 13544844
    CompactGlowButtonAppearance.ColorDisabled = 15921906
    CompactGlowButtonAppearance.ColorDisabledTo = 15921906
    CompactGlowButtonAppearance.ColorDown = 14599853
    CompactGlowButtonAppearance.ColorDownTo = 13544844
    CompactGlowButtonAppearance.ColorHot = 16250863
    CompactGlowButtonAppearance.ColorHotTo = 16246742
    CompactGlowButtonAppearance.ColorMirror = 15586496
    CompactGlowButtonAppearance.ColorMirrorTo = 16245200
    CompactGlowButtonAppearance.ColorMirrorHot = 16247491
    CompactGlowButtonAppearance.ColorMirrorHotTo = 16246742
    CompactGlowButtonAppearance.ColorMirrorDown = 16766645
    CompactGlowButtonAppearance.ColorMirrorDownTo = 13014131
    CompactGlowButtonAppearance.ColorMirrorChecked = 16766645
    CompactGlowButtonAppearance.ColorMirrorCheckedTo = 13014131
    CompactGlowButtonAppearance.ColorMirrorDisabled = 11974326
    CompactGlowButtonAppearance.ColorMirrorDisabledTo = 15921906
    CompactGlowButtonAppearance.GradientHot = ggVertical
    CompactGlowButtonAppearance.GradientMirrorHot = ggVertical
    CompactGlowButtonAppearance.GradientDown = ggVertical
    CompactGlowButtonAppearance.GradientMirrorDown = ggVertical
    CompactGlowButtonAppearance.GradientChecked = ggVertical
    DockColor.Color = 15587527
    DockColor.ColorTo = 16445929
    DockColor.Direction = gdHorizontal
    DockColor.Steps = 128
    DragGripStyle = dsNone
    FloatingWindowBorderColor = 14922381
    FloatingWindowBorderWidth = 1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    GlowButtonAppearance.BorderColor = 14727579
    GlowButtonAppearance.BorderColorHot = 10079963
    GlowButtonAppearance.BorderColorDown = 4548219
    GlowButtonAppearance.BorderColorChecked = 4548219
    GlowButtonAppearance.Color = 15653832
    GlowButtonAppearance.ColorTo = 16178633
    GlowButtonAppearance.ColorChecked = 11918331
    GlowButtonAppearance.ColorCheckedTo = 7915518
    GlowButtonAppearance.ColorDisabled = 15921906
    GlowButtonAppearance.ColorDisabledTo = 15921906
    GlowButtonAppearance.ColorDown = 7778289
    GlowButtonAppearance.ColorDownTo = 4296947
    GlowButtonAppearance.ColorHot = 15465983
    GlowButtonAppearance.ColorHotTo = 11332863
    GlowButtonAppearance.ColorMirror = 15586496
    GlowButtonAppearance.ColorMirrorTo = 16245200
    GlowButtonAppearance.ColorMirrorHot = 5888767
    GlowButtonAppearance.ColorMirrorHotTo = 10807807
    GlowButtonAppearance.ColorMirrorDown = 946929
    GlowButtonAppearance.ColorMirrorDownTo = 5021693
    GlowButtonAppearance.ColorMirrorChecked = 10480637
    GlowButtonAppearance.ColorMirrorCheckedTo = 5682430
    GlowButtonAppearance.ColorMirrorDisabled = 11974326
    GlowButtonAppearance.ColorMirrorDisabledTo = 15921906
    GlowButtonAppearance.GradientHot = ggVertical
    GlowButtonAppearance.GradientMirrorHot = ggVertical
    GlowButtonAppearance.GradientDown = ggVertical
    GlowButtonAppearance.GradientMirrorDown = ggVertical
    GlowButtonAppearance.GradientChecked = ggVertical
    GroupAppearance.BorderColor = 12763842
    GroupAppearance.Color = 15851212
    GroupAppearance.ColorTo = 14213857
    GroupAppearance.ColorMirror = 14213857
    GroupAppearance.ColorMirrorTo = 10871273
    GroupAppearance.Font.Charset = DEFAULT_CHARSET
    GroupAppearance.Font.Color = clWindowText
    GroupAppearance.Font.Height = -11
    GroupAppearance.Font.Name = 'Tahoma'
    GroupAppearance.Font.Style = []
    GroupAppearance.Gradient = ggVertical
    GroupAppearance.GradientMirror = ggVertical
    GroupAppearance.TextColor = 9126421
    GroupAppearance.CaptionAppearance.CaptionColor = 15915714
    GroupAppearance.CaptionAppearance.CaptionColorTo = 15784385
    GroupAppearance.CaptionAppearance.CaptionTextColor = 11168318
    GroupAppearance.CaptionAppearance.CaptionColorHot = 16769224
    GroupAppearance.CaptionAppearance.CaptionColorHotTo = 16772566
    GroupAppearance.CaptionAppearance.CaptionTextColorHot = 11168318
    GroupAppearance.PageAppearance.BorderColor = 12763842
    GroupAppearance.PageAppearance.Color = 14086910
    GroupAppearance.PageAppearance.ColorTo = 16382457
    GroupAppearance.PageAppearance.ColorMirror = 16382457
    GroupAppearance.PageAppearance.ColorMirrorTo = 16382457
    GroupAppearance.PageAppearance.Gradient = ggVertical
    GroupAppearance.PageAppearance.GradientMirror = ggVertical
    GroupAppearance.PageAppearance.ShadowColor = 12888726
    GroupAppearance.PageAppearance.HighLightColor = 16644558
    GroupAppearance.TabAppearance.BorderColor = 10534860
    GroupAppearance.TabAppearance.BorderColorHot = 10534860
    GroupAppearance.TabAppearance.BorderColorSelected = 10534860
    GroupAppearance.TabAppearance.BorderColorSelectedHot = 10534860
    GroupAppearance.TabAppearance.BorderColorDisabled = clNone
    GroupAppearance.TabAppearance.BorderColorDown = clNone
    GroupAppearance.TabAppearance.Color = clBtnFace
    GroupAppearance.TabAppearance.ColorTo = clWhite
    GroupAppearance.TabAppearance.ColorSelected = 10412027
    GroupAppearance.TabAppearance.ColorSelectedTo = 12249340
    GroupAppearance.TabAppearance.ColorDisabled = clNone
    GroupAppearance.TabAppearance.ColorDisabledTo = clNone
    GroupAppearance.TabAppearance.ColorHot = 14542308
    GroupAppearance.TabAppearance.ColorHotTo = 16768709
    GroupAppearance.TabAppearance.ColorMirror = clWhite
    GroupAppearance.TabAppearance.ColorMirrorTo = clWhite
    GroupAppearance.TabAppearance.ColorMirrorHot = 14016477
    GroupAppearance.TabAppearance.ColorMirrorHotTo = 10736609
    GroupAppearance.TabAppearance.ColorMirrorSelected = 12249340
    GroupAppearance.TabAppearance.ColorMirrorSelectedTo = 13955581
    GroupAppearance.TabAppearance.ColorMirrorDisabled = clNone
    GroupAppearance.TabAppearance.ColorMirrorDisabledTo = clNone
    GroupAppearance.TabAppearance.Font.Charset = DEFAULT_CHARSET
    GroupAppearance.TabAppearance.Font.Color = clWindowText
    GroupAppearance.TabAppearance.Font.Height = -11
    GroupAppearance.TabAppearance.Font.Name = 'Tahoma'
    GroupAppearance.TabAppearance.Font.Style = []
    GroupAppearance.TabAppearance.Gradient = ggRadial
    GroupAppearance.TabAppearance.GradientMirror = ggRadial
    GroupAppearance.TabAppearance.GradientHot = ggVertical
    GroupAppearance.TabAppearance.GradientMirrorHot = ggVertical
    GroupAppearance.TabAppearance.GradientSelected = ggVertical
    GroupAppearance.TabAppearance.GradientMirrorSelected = ggVertical
    GroupAppearance.TabAppearance.GradientDisabled = ggVertical
    GroupAppearance.TabAppearance.GradientMirrorDisabled = ggVertical
    GroupAppearance.TabAppearance.TextColor = 9126421
    GroupAppearance.TabAppearance.TextColorHot = 9126421
    GroupAppearance.TabAppearance.TextColorSelected = 9126421
    GroupAppearance.TabAppearance.TextColorDisabled = clWhite
    GroupAppearance.TabAppearance.ShadowColor = 15255470
    GroupAppearance.TabAppearance.HighLightColor = 16775871
    GroupAppearance.TabAppearance.HighLightColorHot = 16643309
    GroupAppearance.TabAppearance.HighLightColorSelected = 6540536
    GroupAppearance.TabAppearance.HighLightColorSelectedHot = 12451839
    GroupAppearance.TabAppearance.HighLightColorDown = 16776144
    GroupAppearance.ToolBarAppearance.BorderColor = 13423059
    GroupAppearance.ToolBarAppearance.BorderColorHot = 13092807
    GroupAppearance.ToolBarAppearance.Color.Color = 15530237
    GroupAppearance.ToolBarAppearance.Color.ColorTo = 16382457
    GroupAppearance.ToolBarAppearance.Color.Direction = gdHorizontal
    GroupAppearance.ToolBarAppearance.ColorHot.Color = 15660277
    GroupAppearance.ToolBarAppearance.ColorHot.ColorTo = 16645114
    GroupAppearance.ToolBarAppearance.ColorHot.Direction = gdHorizontal
    PageAppearance.BorderColor = 14922381
    PageAppearance.Color = 15984090
    PageAppearance.ColorTo = 15785680
    PageAppearance.ColorMirror = 15587784
    PageAppearance.ColorMirrorTo = 16774371
    PageAppearance.Gradient = ggVertical
    PageAppearance.GradientMirror = ggVertical
    PageAppearance.ShadowColor = 12888726
    PageAppearance.HighLightColor = 16644558
    PagerCaption.BorderColor = 15780526
    PagerCaption.Color = 15525858
    PagerCaption.ColorTo = 15590878
    PagerCaption.ColorMirror = 15524312
    PagerCaption.ColorMirrorTo = 15723487
    PagerCaption.Gradient = ggVertical
    PagerCaption.GradientMirror = ggVertical
    PagerCaption.TextColor = 11168318
    PagerCaption.TextColorExtended = 7958633
    PagerCaption.Font.Charset = DEFAULT_CHARSET
    PagerCaption.Font.Color = clWindowText
    PagerCaption.Font.Height = -13
    PagerCaption.Font.Name = 'Tahoma'
    PagerCaption.Font.Style = []
    QATAppearance.BorderColor = 14005146
    QATAppearance.Color = 16050142
    QATAppearance.ColorTo = 15653065
    QATAppearance.FullSizeBorderColor = 13476222
    QATAppearance.FullSizeColor = 15584690
    QATAppearance.FullSizeColorTo = 15386026
    RightHandleColor = 14668485
    RightHandleColorTo = 14731181
    RightHandleColorHot = 13891839
    RightHandleColorHotTo = 7782911
    RightHandleColorDown = 557032
    RightHandleColorDownTo = 8182519
    TabAppearance.BorderColor = clNone
    TabAppearance.BorderColorHot = 15383705
    TabAppearance.BorderColorSelected = 14922381
    TabAppearance.BorderColorSelectedHot = 6343929
    TabAppearance.BorderColorDisabled = clNone
    TabAppearance.BorderColorDown = clNone
    TabAppearance.Color = clBtnFace
    TabAppearance.ColorTo = clWhite
    TabAppearance.ColorSelected = 16709360
    TabAppearance.ColorSelectedTo = 16445929
    TabAppearance.ColorDisabled = clWhite
    TabAppearance.ColorDisabledTo = clSilver
    TabAppearance.ColorHot = 14542308
    TabAppearance.ColorHotTo = 16768709
    TabAppearance.ColorMirror = clWhite
    TabAppearance.ColorMirrorTo = clWhite
    TabAppearance.ColorMirrorHot = 14016477
    TabAppearance.ColorMirrorHotTo = 10736609
    TabAppearance.ColorMirrorSelected = 16445929
    TabAppearance.ColorMirrorSelectedTo = 16181984
    TabAppearance.ColorMirrorDisabled = clWhite
    TabAppearance.ColorMirrorDisabledTo = clSilver
    TabAppearance.Font.Charset = DEFAULT_CHARSET
    TabAppearance.Font.Color = clWindowText
    TabAppearance.Font.Height = -11
    TabAppearance.Font.Name = 'Tahoma'
    TabAppearance.Font.Style = []
    TabAppearance.Gradient = ggVertical
    TabAppearance.GradientMirror = ggVertical
    TabAppearance.GradientHot = ggRadial
    TabAppearance.GradientMirrorHot = ggVertical
    TabAppearance.GradientSelected = ggVertical
    TabAppearance.GradientMirrorSelected = ggVertical
    TabAppearance.GradientDisabled = ggVertical
    TabAppearance.GradientMirrorDisabled = ggVertical
    TabAppearance.TextColor = 9126421
    TabAppearance.TextColorHot = 9126421
    TabAppearance.TextColorSelected = 9126421
    TabAppearance.TextColorDisabled = clGray
    TabAppearance.ShadowColor = 15255470
    TabAppearance.HighLightColor = 16775871
    TabAppearance.HighLightColorHot = 16643309
    TabAppearance.HighLightColorSelected = 6540536
    TabAppearance.HighLightColorSelectedHot = 12451839
    TabAppearance.HighLightColorDown = 16776144
    TabAppearance.BackGround.Color = 16767935
    TabAppearance.BackGround.ColorTo = clNone
    TabAppearance.BackGround.Direction = gdHorizontal
    Left = 728
    Top = 304
  end
end
