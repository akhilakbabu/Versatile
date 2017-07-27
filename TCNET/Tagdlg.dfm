object TagDialog: TTagDialog
  Left = 643
  Top = 267
  HelpContext = 369
  BorderStyle = bsDialog
  Caption = 'Student Tag Selection Dialog'
  ClientHeight = 356
  ClientWidth = 434
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    434
    356)
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 434
    Height = 315
    Align = alTop
    TabOrder = 0
    object Label3: TLabel
      Left = 12
      Top = 66
      Width = 51
      Height = 13
      Caption = '&Students'
      FocusControl = ListBox1
    end
    object Label4: TLabel
      Left = 221
      Top = 66
      Width = 100
      Height = 13
      Caption = 'Stud&ents with tag'
      FocusControl = ListBox2
    end
    object Label7: TLabel
      Left = 223
      Top = 292
      Width = 39
      Height = 13
      Caption = 'Label7'
    end
    object Label6: TLabel
      Left = 12
      Top = 292
      Width = 39
      Height = 13
      Caption = 'Label6'
    end
    object TagEdit1: TLabeledEdit
      Left = 38
      Top = 22
      Width = 23
      Height = 21
      Hint = 'Set number of sections'
      EditLabel.Width = 23
      EditLabel.Height = 13
      EditLabel.Caption = '&Tag'
      LabelPosition = lpLeft
      ReadOnly = True
      TabOrder = 0
      Text = '1'
    end
    object UpDown1: TUpDown
      Left = 61
      Top = 22
      Width = 18
      Height = 21
      Hint = 'Select tag number'
      Associate = TagEdit1
      Min = 1
      Max = 16
      Position = 1
      TabOrder = 1
      TabStop = True
      OnClick = RefreshTag
    end
    object CodeEdit1: TLabeledEdit
      Left = 120
      Top = 22
      Width = 25
      Height = 21
      EditLabel.Width = 30
      EditLabel.Height = 13
      EditLabel.Caption = '&Code'
      LabelPosition = lpLeft
      TabOrder = 2
    end
    object NameEdit1: TLabeledEdit
      Left = 192
      Top = 22
      Width = 162
      Height = 21
      EditLabel.Width = 33
      EditLabel.Height = 13
      EditLabel.Caption = '&Name'
      LabelPosition = lpLeft
      ReadOnly = True
      TabOrder = 3
    end
    object ListBox2: TListBox
      Left = 221
      Top = 82
      Width = 168
      Height = 207
      Hint = 'Click to select students, Double Click to move a student'
      ItemHeight = 13
      Items.Strings = (
        'WWWWWWWW'
        'WWWWWWWW'
        '')
      MultiSelect = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      OnDblClick = BitBtn1Click
    end
    object ListBox1: TListBox
      Left = 12
      Top = 82
      Width = 168
      Height = 207
      Hint = 'Click to select students, Double Click to move a student'
      ItemHeight = 13
      Items.Strings = (
        'WWWWWWWW'
        'WWWWWWWW')
      MultiSelect = True
      TabOrder = 4
      OnDblClick = BitBtn3Click
    end
    object BitBtn1: TBitBtn
      Left = 185
      Top = 133
      Width = 30
      Height = 24
      Hint = 'Remove selected teachers'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      OnClick = BitBtn1Click
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
    object BitBtn2: TBitBtn
      Left = 185
      Top = 160
      Width = 30
      Height = 24
      Hint = 'Remove all teachers'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
      OnClick = BitBtn2Click
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
    object BitBtn3: TBitBtn
      Left = 185
      Top = 188
      Width = 30
      Height = 24
      Hint = 'Add selected teachers'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 8
      OnClick = BitBtn3Click
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
      Left = 185
      Top = 216
      Width = 30
      Height = 24
      Hint = 'Add all teachers'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 9
      OnClick = BitBtn4Click
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
        0F0F0F0F0F0F0F0F00000F0F0F04040F0F0F0F0F04040F0F0F0F0F0F0F0F0F0F
        0F0F01010F0F0F0F0F01010F0F0F0F0F0F0F0F0F00000F0F0F0404040F0F0F0F
        0404040F0F0F0F0F0F0F0F0F0F0F0101010F0F0F0F0101010F0F0F0F0F0F0F0F
        00000F0F0F120404040F0F0F120404040F0F0F0F0F0F0F0F0F0F050101010F0F
        0F050101010F0F0F0F0F0F0F00000F0F0F12120404040F0F12120404040F0F0F
        0F0F0F0F0F0F0F050101010F0F0F050101010F0F0F0F0F0F00000F0F0F0F1212
        0404040F0F12120404040F0F0F0F0F0F0F0F0F0F050101010F0F0F050101010F
        0F0F0F0F00000F0F0F0F0F12120404040F0F12120404040F0F0F0F0F0F0F0F0F
        0F050101010F0F0F050101010F0F0F0F00000F0F0F0F12120404040F0F121204
        04040F0F0F0F0F0F0F0F0F0F050101010F0F0F050101010F0F0F0F0F00000F0F
        0F12120404040F0F12120404040F0F0F0F0F0F0F0F0F0F050101010F0F0F0501
        01010F0F0F0F0F0F00000F0F0F120404040F0F0F120404040F0F0F0F0F0F0F0F
        0F0F050101010F0F0F050101010F0F0F0F0F0F0F00000F0F0F0404040F0F0F0F
        0404040F0F0F0F0F0F0F0F0F0F0F0101010F0F0F0F0101010F0F0F0F0F0F0F0F
        00000F0F0F04040F0F0F0F0F04040F0F0F0F0F0F0F0F0F0F0F0F01010F0F0F0F
        0F01010F0F0F0F0F0F0F0F0F00000F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
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
    object UpBtn: TBitBtn
      Left = 395
      Top = 164
      Width = 30
      Height = 24
      Hint = 'Move selected students up'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 10
      OnClick = UpBtnClick
      Glyph.Data = {
        D2070000424DD20700000000000036040000280000002A000000150000000100
        0800000000009C030000C40E0000C40E00000001000000000000000000008080
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
        0F0F0F0F0F0F0F0F00000F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F00000F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        00000F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F0F0F00000F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F00000F0F0F0F0404
        12120F0F0F121204040F0F0F0F0F0F0F0F0F0F0101050F0F0F0F0F0501010F0F
        0F0F0F0F00000F0F0F0F04040412120F12120404040F0F0F0F0F0F0F0F0F0F01
        0101050F0F0F050101010F0F0F0F0F0F00000F0F0F0F0F040404121212040404
        0F0F0F0F0F0F0F0F0F0F0F0F010101050F050101010F0F0F0F0F0F0F00000F0F
        0F0F0F0F040404120404040F0F0F0F0F0F0F0F0F0F0F0F0F0F01010105010101
        0F0F0F0F0F0F0F0F00000F0F0F0F0F0F0F04040404040F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F01010101010F0F0F0F0F0F0F0F0F00000F0F0F0F0F0F0F0F0404
        040F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0101010F0F0F0F0F0F0F0F0F0F
        00000F0F0F0F0F0F0F0F0F040F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        010F0F0F0F0F0F0F0F0F0F0F00000F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F00000F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F00000F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F00000F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F00000F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F00000F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0000}
      Layout = blGlyphTop
      NumGlyphs = 2
    end
    object DnBtn: TBitBtn
      Left = 395
      Top = 192
      Width = 30
      Height = 24
      Hint = 'Move selected students down'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 11
      OnClick = DnBtnClick
      Glyph.Data = {
        D2070000424DD20700000000000036040000280000002A000000150000000100
        0800000000009C030000C40E0000C40E00000001000000000000000000008080
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
        0F0F0F0F0F0F0F0F00000F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F00000F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        00000F0F0F0F0F0F0F0F0F040F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        010F0F0F0F0F0F0F0F0F0F0F00000F0F0F0F0F0F0F0F0404040F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F0F0101010F0F0F0F0F0F0F0F0F0F00000F0F0F0F0F0F
        0F04040404040F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F01010101010F0F0F0F0F
        0F0F0F0F00000F0F0F0F0F0F040404120404040F0F0F0F0F0F0F0F0F0F0F0F0F
        0F010101050101010F0F0F0F0F0F0F0F00000F0F0F0F0F040404121212040404
        0F0F0F0F0F0F0F0F0F0F0F0F010101050F050101010F0F0F0F0F0F0F00000F0F
        0F0F04040412120F12120404040F0F0F0F0F0F0F0F0F0F010101050F0F0F0501
        01010F0F0F0F0F0F00000F0F0F0F040412120F0F0F121204040F0F0F0F0F0F0F
        0F0F0F0101050F0F0F0F0F0501010F0F0F0F0F0F00000F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        00000F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F0F0F00000F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F00000F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F00000F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F00000F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F00000F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F00000F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
        0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0000}
      Layout = blGlyphTop
      NumGlyphs = 2
    end
    object btnEditTag: TButton
      Left = 361
      Top = 22
      Width = 64
      Height = 21
      Caption = '&Edit Tag'
      TabOrder = 12
      OnClick = RenameTag
    end
  end
  object Finish: TBitBtn
    Left = 270
    Top = 324
    Width = 75
    Height = 25
    Hint = 'Exit from dialogue'
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'C&lose'
    ModalResult = 2
    TabOrder = 1
    Glyph.Data = {
      BE060000424DBE06000000000000360400002800000024000000120000000100
      0800000000008802000000000000000000000001000000000000000000000000
      BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000C0DCC000F0CA
      A600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F0FBFF00A4A0A000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00030404040406
      0303030303040404040303030303FFFFFFFF030303030303FFFFFFFF03030303
      FAFAFA0403030303030302FA040303030303F8F80303FF0303030303F8F803FF
      030303030302FA0406030303030302FA0403030303030303F803FF0303030303
      03F803FF030303030302FA02040303030306FA060603030303030303F80303FF
      03030303F803FF03030303030303FAFA040603030602FA040303030303030303
      03F803FF030303F80303FF0303030303030306FAFA04040602FA040603030303
      0303030303F80303FFFFF80303FF03030303030303030302FAFA020202040603
      03030303030303030303F80303030303FF030303030303030303030306FAFAFA
      020206040603030303030303030303F803030303FFF8FFFF0303030304040404
      0606FAFA040306FA04030303030303F8FFFFFFF8F80303FF03F803FF03030303
      06FAFA020406FA02040306FA04030303030303F8F80303FFF80303FF03F803FF
      03030303030306FA0204FAFA040402FA040303030303030303F80303FF0303FF
      FFF803FF0303030303030303FA02FAFA02FAFA0403030303030303030303F803
      030303030303FF030303030303030303030202FAFAFA04030303030303030303
      030303F80303030303FF0303030303030303030303030202FA04030303030303
      0303030303030303F8030303FF0303030303030303030303030404FA04030303
      03030303030303030303030303F803FF0303030303030303030303030306FA02
      04030303030303030303030303030303F80303FF030303030303030303030303
      0306FAFA04030303030303030303030303030303F80303FF0303030303030303
      03030303030306060603030303030303030303030303030303F8F8F803030303
      0303}
    NumGlyphs = 2
  end
  object EnterBtn: TBitBtn
    Left = 189
    Top = 324
    Width = 75
    Height = 25
    Hint = 'Add selected students to selected Tag group'
    Anchors = [akRight, akBottom]
    Caption = '&Update'
    Default = True
    TabOrder = 2
    OnClick = EnterBtnClick
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333330000333333333333333333333333F33333333333
      00003333344333333333333333377F3333333333000033334224333333333333
      337337F3333333330000333422224333333333333733337F3333333300003342
      222224333333333373333337F3333333000034222A22224333333337F337F333
      7F33333300003222A3A2224333333337F3737F337F33333300003A2A333A2224
      33333337F73337F337F33333000033A33333A222433333337333337F337F3333
      0000333333333A222433333333333337F337F33300003333333333A222433333
      333333337F337F33000033333333333A222433333333333337F337F300003333
      33333333A222433333333333337F337F00003333333333333A22433333333333
      3337F37F000033333333333333A223333333333333337F730000333333333333
      333A333333333333333337330000333333333333333333333333333333333333
      0000}
    Margin = 2
    NumGlyphs = 2
    Spacing = -1
    IsControl = True
  end
  object HelpBtn: TBitBtn
    Left = 352
    Top = 324
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    TabOrder = 3
    Kind = bkHelp
    Margin = 2
    Spacing = -1
    IsControl = True
  end
end