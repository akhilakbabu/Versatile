object ClassesShowDlg: TClassesShowDlg
  Left = 318
  Top = 118
  HelpContext = 304
  BorderStyle = bsDialog
  Caption = 'Roll classes shown on timetable'
  ClientHeight = 356
  ClientWidth = 430
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  OldCreateOrder = True
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    430
    356)
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 2
    Width = 419
    Height = 315
    TabOrder = 3
    object Label1: TLabel
      Left = 13
      Top = 16
      Width = 51
      Height = 13
      Caption = 'For year:'
    end
    object Label2: TLabel
      Left = 224
      Top = 50
      Width = 185
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'Timetable view'
    end
    object Label3: TLabel
      Left = 15
      Top = 50
      Width = 150
      Height = 13
      Caption = 'Available Roll class codes'
    end
    object Label4: TLabel
      Left = 208
      Top = 18
      Width = 39
      Height = 13
      Caption = 'Label4'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object ListBox1: TListBox
      Left = 13
      Top = 67
      Width = 155
      Height = 240
      Hint = 'Select a class code to show on the timetable'
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      OnDblClick = AddAvailableRollClass
    end
    object StringGrid1: TStringGrid
      Left = 222
      Top = 67
      Width = 185
      Height = 240
      Hint = 'This shows what will appear on the timetable'
      ColCount = 2
      DefaultRowHeight = 18
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goColSizing, goTabs, goRowSelect, goThumbTracking]
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = StringGrid1Click
      OnDblClick = RemoveRollClass
    end
    object BitBtn1: TBitBtn
      Left = 180
      Top = 126
      Width = 30
      Height = 25
      Hint = 'Add class code to selected level'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = AddAvailableRollClass
      Glyph.Data = {
        D2070000424DD20700000000000036040000280000002A000000150000000100
        0800000000009C030000CE0E0000C40E00000001000000000000000000008080
        8000000080000080800000800000808000008000000080008000408080004040
        0000FF80000080400000FF00400000408000FFFFFF00C0C0C0000000FF0000FF
        FF0000FF0000FFFF0000FF000000FF00FF0080FFFF0080FF0000FFFF8000FF80
        80008000FF004080FF00C0DCC000F0CAA6000000BF0000BF000000BFBF00BF00
        0000BF00BF00BFBF00003F5F3F003F5F5F003F5F7F003F5F9F003F5FBF003F5F
        DF003F5FFF003F7F3F003F7F5F003F7F7F003F7F9F003F7FBF003F7FDF003F7F
        FF003F9F3F003F9F5F003F9F7F003F9F9F003F9FBF003F9FDF003F9FFF003FBF
        3F003FBF5F003FBF7F003FBF9F003FBFBF003FBFDF003FBFFF003FDF3F003FDF
        5F003FDF7F003FDF9F003FDFBF003FDFDF003FDFFF003FFF3F003FFF5F003FFF
        7F003FFF9F003FFFBF003FFFDF003FFFFF005F3F3F005F3F5F005F3F7F005F3F
        9F005F3FBF005F3FDF005F3FFF005F5F3F005F5F5F005F5F7F005F5F9F005F5F
        BF005F5FDF005F5FFF005F7F3F005F7F5F005F7F7F005F7F9F005F7FBF005F7F
        DF005F7FFF005F9F3F005F9F5F005F9F7F005F9F9F005F9FBF005F9FDF005F9F
        FF005FBF3F005FBF5F005FBF7F005FBF9F005FBFBF005FBFDF005FBFFF005FDF
        3F005FDF5F005FDF7F005FDF9F005FDFBF005FDFDF005FDFFF005FFF3F005FFF
        5F005FFF7F005FFF9F005FFFBF005FFFDF005FFFFF007F3F3F007F3F5F007F3F
        7F007F3F9F007F3FBF007F3FDF007F3FFF007F5F3F007F5F5F007F5F7F007F5F
        9F007F5FBF007F5FDF007F5FFF007F7F3F007F7F5F007F7F7F007F7F9F007F7F
        BF007F7FDF007F7FFF007F9F3F007F9F5F007F9F7F007F9F9F007F9FBF007F9F
        DF007F9FFF007FBF3F007FBF5F007FBF7F007FBF9F007FBFBF007FBFDF007FBF
        FF007FDF3F007FDF5F007FDF7F007FDF9F007FDFBF007FDFDF007FDFFF007FFF
        3F007FFF5F007FFF7F007FFF9F007FFFBF007FFFDF007FFFFF009F3F3F009F3F
        5F009F3F7F009F3F9F009F3FBF009F3FDF009F3FFF009F5F3F009F5F5F009F5F
        7F009F5F9F009F5FBF009F5FDF009F5FFF009F7F3F009F7F5F009F7F7F009F7F
        9F009F7FBF009F7FDF009F7FFF009F9F3F009F9F5F009F9F7F009F9F9F009F9F
        BF009F9FDF009F9FFF009FBF3F009FBF5F009FBF7F009FBF9F009FBFBF009FBF
        DF009FBFFF009FDF3F009FDF5F009FDF7F009FDF9F009FDFBF009FDFDF009FDF
        FF009FFF3F009FFF5F009FFF7F009FFF9F009FFFBF009FFFDF009FFFFF00BF3F
        3F00BF3F5F00BF3F7F00BF3F9F00BF3FBF00BF3FDF00BF3FFF00BF5F3F00BF5F
        5F00BF5F7F00BF5F9F00BF5FBF00BF5FDF00BF5FFF00BF7F3F00BF7F5F00BF7F
        7F00BF7F9F00BF7FBF00BF7FDF00BF7FFF00BF9F3F00BF9F5F00BF9F7F00BF9F
        9F00BF9FBF00BF9FDF00BF9FFF00BFBF3F00BFBF5F00BFBF7F000F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F00000F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F00000F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F00000F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F00000F0F0F0F0F0F04040F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F01010F0F0F0F0F0F0F0F0F0F0F0F0F00000F0F0F0F0F0F0404040F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0101010F0F0F0F0F0F0F0F0F0F0F0F
        00000F0F0F0F0F0F120404040F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F050101
        010F0F0F0F0F0F0F0F0F0F0F00000F0F0F0F0F0F12120404040F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F050101010F0F0F0F0F0F0F0F0F0F00000F0F0F0F0F0F
        0F12120404040F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F050101010F0F0F0F0F
        0F0F0F0F00000F0F0F0F0F0F0F0F12120404040F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F050101010F0F0F0F0F0F0F0F00000F0F0F0F0F0F0F12120404040F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F050101010F0F0F0F0F0F0F0F0F00000F0F
        0F0F0F0F12120404040F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F050101010F0F
        0F0F0F0F0F0F0F0F00000F0F0F0F0F0F120404040F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F050101010F0F0F0F0F0F0F0F0F0F0F00000F0F0F0F0F0F0404040F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0101010F0F0F0F0F0F0F0F0F0F0F0F
        00000F0F0F0F0F0F04040F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F01010F
        0F0F0F0F0F0F0F0F0F0F0F0F00000F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F00000F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F00000F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F00000F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F00000F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F00000F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0000}
      NumGlyphs = 2
    end
    object BitBtn4: TBitBtn
      Left = 180
      Top = 159
      Width = 30
      Height = 25
      Hint = 'Remove class code from selected level'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = RemoveRollClass
      Glyph.Data = {
        D2070000424DD20700000000000036040000280000002A000000150000000100
        0800000000009C030000CE0E0000C40E00000001000000000000000000008080
        8000000080000080800000800000808000008000000080008000408080004040
        0000FF80000080400000FF00400000408000FFFFFF00C0C0C0000000FF0000FF
        FF0000FF0000FFFF0000FF000000FF00FF0080FFFF0080FF0000FFFF8000FF80
        80008000FF004080FF00C0DCC000F0CAA6000000BF0000BF000000BFBF00BF00
        0000BF00BF00BFBF00003F5F3F003F5F5F003F5F7F003F5F9F003F5FBF003F5F
        DF003F5FFF003F7F3F003F7F5F003F7F7F003F7F9F003F7FBF003F7FDF003F7F
        FF003F9F3F003F9F5F003F9F7F003F9F9F003F9FBF003F9FDF003F9FFF003FBF
        3F003FBF5F003FBF7F003FBF9F003FBFBF003FBFDF003FBFFF003FDF3F003FDF
        5F003FDF7F003FDF9F003FDFBF003FDFDF003FDFFF003FFF3F003FFF5F003FFF
        7F003FFF9F003FFFBF003FFFDF003FFFFF005F3F3F005F3F5F005F3F7F005F3F
        9F005F3FBF005F3FDF005F3FFF005F5F3F005F5F5F005F5F7F005F5F9F005F5F
        BF005F5FDF005F5FFF005F7F3F005F7F5F005F7F7F005F7F9F005F7FBF005F7F
        DF005F7FFF005F9F3F005F9F5F005F9F7F005F9F9F005F9FBF005F9FDF005F9F
        FF005FBF3F005FBF5F005FBF7F005FBF9F005FBFBF005FBFDF005FBFFF005FDF
        3F005FDF5F005FDF7F005FDF9F005FDFBF005FDFDF005FDFFF005FFF3F005FFF
        5F005FFF7F005FFF9F005FFFBF005FFFDF005FFFFF007F3F3F007F3F5F007F3F
        7F007F3F9F007F3FBF007F3FDF007F3FFF007F5F3F007F5F5F007F5F7F007F5F
        9F007F5FBF007F5FDF007F5FFF007F7F3F007F7F5F007F7F7F007F7F9F007F7F
        BF007F7FDF007F7FFF007F9F3F007F9F5F007F9F7F007F9F9F007F9FBF007F9F
        DF007F9FFF007FBF3F007FBF5F007FBF7F007FBF9F007FBFBF007FBFDF007FBF
        FF007FDF3F007FDF5F007FDF7F007FDF9F007FDFBF007FDFDF007FDFFF007FFF
        3F007FFF5F007FFF7F007FFF9F007FFFBF007FFFDF007FFFFF009F3F3F009F3F
        5F009F3F7F009F3F9F009F3FBF009F3FDF009F3FFF009F5F3F009F5F5F009F5F
        7F009F5F9F009F5FBF009F5FDF009F5FFF009F7F3F009F7F5F009F7F7F009F7F
        9F009F7FBF009F7FDF009F7FFF009F9F3F009F9F5F009F9F7F009F9F9F009F9F
        BF009F9FDF009F9FFF009FBF3F009FBF5F009FBF7F009FBF9F009FBFBF009FBF
        DF009FBFFF009FDF3F009FDF5F009FDF7F009FDF9F009FDFBF009FDFDF009FDF
        FF009FFF3F009FFF5F009FFF7F009FFF9F009FFFBF009FFFDF009FFFFF00BF3F
        3F00BF3F5F00BF3F7F00BF3F9F00BF3FBF00BF3FDF00BF3FFF00BF5F3F00BF5F
        5F00BF5F7F00BF5F9F00BF5FBF00BF5FDF00BF5FFF00BF7F3F00BF7F5F00BF7F
        7F00BF7F9F00BF7FBF00BF7FDF00BF7FFF00BF9F3F00BF9F5F00BF9F7F00BF9F
        9F00BF9FBF00BF9FDF00BF9FFF00BFBF3F00BFBF5F00BFBF7F000F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F00000F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F00000F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F00000F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F00000F0F0F0F0F0F0F0F0F0F0F04040F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F01010F0F0F0F0F0F0F0F00000F0F0F0F0F0F0F0F0F0F
        0404040F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0101010F0F0F0F0F0F0F0F
        00000F0F0F0F0F0F0F0F0F040404120F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        010101050F0F0F0F0F0F0F0F00000F0F0F0F0F0F0F0F04040412120F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F0F010101050F0F0F0F0F0F0F0F0F00000F0F0F0F0F0F
        0F04040412120F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F010101050F0F0F0F0F0F
        0F0F0F0F00000F0F0F0F0F0F04040412120F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F010101050F0F0F0F0F0F0F0F0F0F0F00000F0F0F0F0F0F0F04040412120F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F010101050F0F0F0F0F0F0F0F0F0F00000F0F
        0F0F0F0F0F0F04040412120F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F010101050F
        0F0F0F0F0F0F0F0F00000F0F0F0F0F0F0F0F0F040404120F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F010101050F0F0F0F0F0F0F0F00000F0F0F0F0F0F0F0F0F0F
        0404040F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0101010F0F0F0F0F0F0F0F
        00000F0F0F0F0F0F0F0F0F0F0F04040F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F01010F0F0F0F0F0F0F0F00000F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F00000F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F00000F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F00000F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F00000F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F00000F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0000}
      NumGlyphs = 2
    end
    object BitBtn5: TBitBtn
      Left = 180
      Top = 193
      Width = 30
      Height = 25
      Hint = 'Remove all class codes'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = BitBtn5Click
      Glyph.Data = {
        D2070000424DD20700000000000036040000280000002A000000150000000100
        0800000000009C030000CE0E0000C40E00000001000000000000000000008080
        8000000080000080800000800000808000008000000080008000408080004040
        0000FF80000080400000FF00400000408000FFFFFF00C0C0C0000000FF0000FF
        FF0000FF0000FFFF0000FF000000FF00FF0080FFFF0080FF0000FFFF8000FF80
        80008000FF004080FF00C0DCC000F0CAA6000000BF0000BF000000BFBF00BF00
        0000BF00BF00BFBF00003F5F3F003F5F5F003F5F7F003F5F9F003F5FBF003F5F
        DF003F5FFF003F7F3F003F7F5F003F7F7F003F7F9F003F7FBF003F7FDF003F7F
        FF003F9F3F003F9F5F003F9F7F003F9F9F003F9FBF003F9FDF003F9FFF003FBF
        3F003FBF5F003FBF7F003FBF9F003FBFBF003FBFDF003FBFFF003FDF3F003FDF
        5F003FDF7F003FDF9F003FDFBF003FDFDF003FDFFF003FFF3F003FFF5F003FFF
        7F003FFF9F003FFFBF003FFFDF003FFFFF005F3F3F005F3F5F005F3F7F005F3F
        9F005F3FBF005F3FDF005F3FFF005F5F3F005F5F5F005F5F7F005F5F9F005F5F
        BF005F5FDF005F5FFF005F7F3F005F7F5F005F7F7F005F7F9F005F7FBF005F7F
        DF005F7FFF005F9F3F005F9F5F005F9F7F005F9F9F005F9FBF005F9FDF005F9F
        FF005FBF3F005FBF5F005FBF7F005FBF9F005FBFBF005FBFDF005FBFFF005FDF
        3F005FDF5F005FDF7F005FDF9F005FDFBF005FDFDF005FDFFF005FFF3F005FFF
        5F005FFF7F005FFF9F005FFFBF005FFFDF005FFFFF007F3F3F007F3F5F007F3F
        7F007F3F9F007F3FBF007F3FDF007F3FFF007F5F3F007F5F5F007F5F7F007F5F
        9F007F5FBF007F5FDF007F5FFF007F7F3F007F7F5F007F7F7F007F7F9F007F7F
        BF007F7FDF007F7FFF007F9F3F007F9F5F007F9F7F007F9F9F007F9FBF007F9F
        DF007F9FFF007FBF3F007FBF5F007FBF7F007FBF9F007FBFBF007FBFDF007FBF
        FF007FDF3F007FDF5F007FDF7F007FDF9F007FDFBF007FDFDF007FDFFF007FFF
        3F007FFF5F007FFF7F007FFF9F007FFFBF007FFFDF007FFFFF009F3F3F009F3F
        5F009F3F7F009F3F9F009F3FBF009F3FDF009F3FFF009F5F3F009F5F5F009F5F
        7F009F5F9F009F5FBF009F5FDF009F5FFF009F7F3F009F7F5F009F7F7F009F7F
        9F009F7FBF009F7FDF009F7FFF009F9F3F009F9F5F009F9F7F009F9F9F009F9F
        BF009F9FDF009F9FFF009FBF3F009FBF5F009FBF7F009FBF9F009FBFBF009FBF
        DF009FBFFF009FDF3F009FDF5F009FDF7F009FDF9F009FDFBF009FDFDF009FDF
        FF009FFF3F009FFF5F009FFF7F009FFF9F009FFFBF009FFFDF009FFFFF00BF3F
        3F00BF3F5F00BF3F7F00BF3F9F00BF3FBF00BF3FDF00BF3FFF00BF5F3F00BF5F
        5F00BF5F7F00BF5F9F00BF5FBF00BF5FDF00BF5FFF00BF7F3F00BF7F5F00BF7F
        7F00BF7F9F00BF7FBF00BF7FDF00BF7FFF00BF9F3F00BF9F5F00BF9F7F00BF9F
        9F00BF9FBF00BF9FDF00BF9FFF00BFBF3F00BFBF5F00BFBF7F000F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F00000F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F00000F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F00000F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F00000F0F0F0F0F0F0F0F04040F0F0F0F0F04040F0F0F0F0F
        0F0F0F0F0F0F0F01010F0F0F0F0F01010F0F0F0F00000F0F0F0F0F0F0F040404
        0F0F0F0F0404040F0F0F0F0F0F0F0F0F0F0F0101010F0F0F0F0101010F0F0F0F
        00000F0F0F0F0F0F040404120F0F0F040404120F0F0F0F0F0F0F0F0F0F010101
        050F0F0F010101050F0F0F0F00000F0F0F0F0F04040412120F0F04040412120F
        0F0F0F0F0F0F0F0F010101050F0F0F010101050F0F0F0F0F00000F0F0F0F0404
        0412120F0F04040412120F0F0F0F0F0F0F0F0F010101050F0F0F010101050F0F
        0F0F0F0F00000F0F0F04040412120F0F04040412120F0F0F0F0F0F0F0F0F0101
        01050F0F0F010101050F0F0F0F0F0F0F00000F0F0F0F04040412120F0F040404
        12120F0F0F0F0F0F0F0F0F010101050F0F0F010101050F0F0F0F0F0F00000F0F
        0F0F0F04040412120F0F04040412120F0F0F0F0F0F0F0F0F010101050F0F0F01
        0101050F0F0F0F0F00000F0F0F0F0F0F040404120F0F0F040404120F0F0F0F0F
        0F0F0F0F0F010101050F0F0F010101050F0F0F0F00000F0F0F0F0F0F0F040404
        0F0F0F0F0404040F0F0F0F0F0F0F0F0F0F0F0101010F0F0F0F0101010F0F0F0F
        00000F0F0F0F0F0F0F0F04040F0F0F0F0F04040F0F0F0F0F0F0F0F0F0F0F0F01
        010F0F0F0F0F01010F0F0F0F00000F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F00000F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F00000F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F00000F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F00000F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F00000F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0000}
      NumGlyphs = 2
    end
    object ComboBox1: TComboBox
      Left = 71
      Top = 14
      Width = 115
      Height = 21
      Hint = 'Select year to work with'
      Style = csDropDownList
      ItemHeight = 0
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnChange = ComboBox1Change
    end
  end
  object finish: TBitBtn
    Left = 177
    Top = 325
    Width = 75
    Height = 25
    Hint = 'Exit from dialogue'
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnClick = finishClick
    Kind = bkOK
  end
  object BitBtn3: TBitBtn
    Left = 345
    Top = 325
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    TabOrder = 2
    Kind = bkHelp
  end
  object allocate: TBitBtn
    Left = 261
    Top = 325
    Width = 75
    Height = 25
    Hint = 'Ignore changes'
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      333333333333333333333333000033338833333333333333333F333333333333
      0000333911833333983333333388F333333F3333000033391118333911833333
      38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
      911118111118333338F3338F833338F3000033333911111111833333338F3338
      3333F8330000333333911111183333333338F333333F83330000333333311111
      8333333333338F3333383333000033333339111183333333333338F333833333
      00003333339111118333333333333833338F3333000033333911181118333333
      33338333338F333300003333911183911183333333383338F338F33300003333
      9118333911183333338F33838F338F33000033333913333391113333338FF833
      38F338F300003333333333333919333333388333338FFF830000333333333333
      3333333333333333333888330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
end