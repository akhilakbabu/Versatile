object prefdlg: Tprefdlg
  Left = 434
  Top = 196
  HelpContext = 14
  ActiveControl = OKBtn
  BorderStyle = bsDialog
  Caption = 'Preferences'
  ClientHeight = 328
  ClientWidth = 592
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  OldCreateOrder = True
  Position = poScreenCenter
  ShowHint = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ButtonPanel: TPanel
    Left = 507
    Top = 0
    Width = 85
    Height = 307
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 0
    object Label12: TLabel
      Left = 21
      Top = 208
      Width = 47
      Height = 29
      Alignment = taCenter
      AutoSize = False
      Caption = 'Colour Printer'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Visible = False
      WordWrap = True
    end
    object Label13: TLabel
      Left = 18
      Top = 144
      Width = 53
      Height = 13
      Caption = 'Formfeed'
    end
    object OKBtn: TBitBtn
      Left = 4
      Top = 20
      Width = 75
      Height = 25
      Hint = 'Set preferences'
      Caption = 'O&K'
      Default = True
      TabOrder = 0
      OnClick = SavePreferences
      Glyph.Data = {
        BE060000424DBE06000000000000360400002800000024000000120000000100
        0800000000008802000000000000000000000001000000010000000000000000
        80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
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
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00030303030303
        0303030303030303030303030303030303030303030303030303030303030303
        03030303030303030303030303030303030303030303FF030303030303030303
        03030303030303040403030303030303030303030303030303F8F8FF03030303
        03030303030303030303040202040303030303030303030303030303F80303F8
        FF030303030303030303030303040202020204030303030303030303030303F8
        03030303F8FF0303030303030303030304020202020202040303030303030303
        0303F8030303030303F8FF030303030303030304020202FA0202020204030303
        0303030303F8FF0303F8FF030303F8FF03030303030303020202FA03FA020202
        040303030303030303F8FF03F803F8FF0303F8FF03030303030303FA02FA0303
        03FA0202020403030303030303F8FFF8030303F8FF0303F8FF03030303030303
        FA0303030303FA0202020403030303030303F80303030303F8FF0303F8FF0303
        0303030303030303030303FA0202020403030303030303030303030303F8FF03
        03F8FF03030303030303030303030303FA020202040303030303030303030303
        0303F8FF0303F8FF03030303030303030303030303FA02020204030303030303
        03030303030303F8FF0303F8FF03030303030303030303030303FA0202020403
        030303030303030303030303F8FF0303F8FF03030303030303030303030303FA
        0202040303030303030303030303030303F8FF03F8FF03030303030303030303
        03030303FA0202030303030303030303030303030303F8FFF803030303030303
        030303030303030303FA0303030303030303030303030303030303F803030303
        0303030303030303030303030303030303030303030303030303030303030303
        0303}
      Margin = 2
      NumGlyphs = 2
      Spacing = -1
      IsControl = True
    end
    object CancelBtn: TBitBtn
      Left = 4
      Top = 82
      Width = 75
      Height = 25
      Hint = 'Exit from dialogue'
      Cancel = True
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 1
      Glyph.Data = {
        BE060000424DBE06000000000000360400002800000024000000120000000100
        0800000000008802000000000000000000000001000000010000000000000000
        80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
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
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00030303030303
        0303030303030303030303030303030303030303030303030303030303030303
        0303F8F80303030303030303030303030303030303FF03030303030303030303
        0303030303F90101F80303030303F9F80303030303030303F8F8FF0303030303
        03FF03030303030303F9010101F8030303F90101F8030303030303F8FF03F8FF
        030303FFF8F8FF030303030303F901010101F803F901010101F80303030303F8
        FF0303F8FF03FFF80303F8FF030303030303F901010101F80101010101F80303
        030303F8FF030303F8FFF803030303F8FF030303030303F90101010101010101
        F803030303030303F8FF030303F803030303FFF80303030303030303F9010101
        010101F8030303030303030303F8FF030303030303FFF8030303030303030303
        030101010101F80303030303030303030303F8FF0303030303F8030303030303
        0303030303F901010101F8030303030303030303030303F8FF030303F8030303
        0303030303030303F90101010101F8030303030303030303030303F803030303
        F8FF030303030303030303F9010101F8010101F803030303030303030303F803
        03030303F8FF0303030303030303F9010101F803F9010101F803030303030303
        03F8030303F8FF0303F8FF03030303030303F90101F8030303F9010101F80303
        03030303F8FF0303F803F8FF0303F8FF03030303030303F9010303030303F901
        0101030303030303F8FFFFF8030303F8FF0303F8FF0303030303030303030303
        030303F901F903030303030303F8F80303030303F8FFFFFFF803030303030303
        03030303030303030303030303030303030303030303030303F8F8F803030303
        0303030303030303030303030303030303030303030303030303030303030303
        0303}
      Margin = 2
      NumGlyphs = 2
      Spacing = -1
      IsControl = True
    end
    object HelpBtn: TBitBtn
      Left = 4
      Top = 113
      Width = 75
      Height = 25
      TabOrder = 2
      Kind = bkHelp
      Margin = 2
      Spacing = -1
      IsControl = True
    end
    object ColourChkBox: TCheckBox
      Left = 35
      Top = 236
      Width = 19
      Height = 13
      Hint = 'Check to print in colour'
      Checked = True
      State = cbChecked
      TabOrder = 3
      Visible = False
    end
    object CheckBox13: TCheckBox
      Left = 34
      Top = 162
      Width = 21
      Height = 13
      Hint = 'Print each list on new page'
      TabOrder = 4
    end
    object btnDefaultSettings: TBitBtn
      Left = 4
      Top = 51
      Width = 75
      Height = 25
      Caption = '&Default'
      TabOrder = 5
      OnClick = SetPreferencesToDefault
    end
  end
  object Notebook: TNotebook
    Left = 0
    Top = 0
    Width = 507
    Height = 307
    Align = alClient
    PageIndex = 1
    TabOrder = 2
    IsControl = True
    object TPage
      Left = 0
      Top = 0
      Caption = 'Timetable '
      IsControl = True
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 507
        Height = 257
        Align = alTop
        Caption = 'Timetable'
        TabOrder = 0
        IsControl = True
        object Label4: TLabel
          Left = 10
          Top = 46
          Width = 106
          Height = 13
          Caption = 'Time Slots Shown:'
        end
        object Label6: TLabel
          Left = 10
          Top = 21
          Width = 23
          Height = 13
          Caption = '&Day'
          FocusControl = ComboBox2
        end
        object DayLabel1: TLabel
          Left = 168
          Top = 21
          Width = 61
          Height = 13
          Caption = 'DayLabel1'
        end
        object YearClass1: TRadioGroup
          AlignWithMargins = True
          Left = 6
          Top = 208
          Width = 494
          Height = 37
          BiDiMode = bdLeftToRight
          Caption = 'Show Year/Roll Class'
          Columns = 5
          Items.Strings = (
            '&Either'
            'Ye&ar'
            '&Roll Class'
            '&Stud. Count'
            '&None')
          ParentBiDiMode = False
          TabOrder = 3
        end
        object ComboBox2: TComboBox
          Left = 43
          Top = 17
          Width = 115
          Height = 21
          Style = csDropDownList
          ItemHeight = 0
          TabOrder = 0
          OnChange = ComboBox2Change
        end
        object Button7: TButton
          Left = 122
          Top = 42
          Width = 45
          Height = 21
          Hint = 'Tick all time slots'
          Caption = 'A&ll'
          TabOrder = 1
          OnClick = Button7Click
        end
        object Button8: TButton
          Left = 180
          Top = 42
          Width = 45
          Height = 21
          Hint = 'Clear all time slots'
          Caption = 'N&one'
          TabOrder = 2
          OnClick = Button8Click
        end
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Print Timetable '
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox7: TGroupBox
        Left = 4
        Top = 0
        Width = 501
        Height = 300
        Caption = 'Print Timetable'
        TabOrder = 0
        IsControl = True
        object Label2: TLabel
          Left = 8
          Top = 16
          Width = 75
          Height = 13
          Caption = 'Days Shown:'
        end
        object Label3: TLabel
          Left = 8
          Top = 103
          Width = 79
          Height = 13
          Caption = 'Years Shown:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object CheckBox9: TCheckBox
          Left = 8
          Top = 252
          Width = 141
          Height = 13
          Hint = 'Show Teachers free at bottom of main timetable'
          Caption = 'Show &Teachers Free'
          TabOrder = 4
        end
        object CheckBox10: TCheckBox
          Left = 8
          Top = 275
          Width = 125
          Height = 13
          Hint = 'Show Rooms free at bottom of main timetable'
          Caption = 'Show &Rooms Free'
          TabOrder = 5
        end
        object Button5: TButton
          Left = 99
          Top = 13
          Width = 45
          Height = 21
          Hint = 'Tick all days'
          Caption = '&All'
          TabOrder = 0
          OnClick = Button5Click
        end
        object Button6: TButton
          Left = 157
          Top = 13
          Width = 45
          Height = 21
          Hint = 'Clear all days'
          Caption = '&None'
          TabOrder = 1
          OnClick = Button6Click
        end
        object Button3: TButton
          Left = 99
          Top = 100
          Width = 45
          Height = 21
          Hint = 'Tick all years'
          Caption = 'A&ll'
          TabOrder = 2
          OnClick = Button3Click
        end
        object Button4: TButton
          Left = 157
          Top = 100
          Width = 45
          Height = 21
          Hint = 'Clear all years'
          Caption = 'N&one'
          TabOrder = 3
          OnClick = Button4Click
        end
        object GroupBox3: TGroupBox
          Left = 156
          Top = 250
          Width = 338
          Height = 44
          Caption = 'Weekly Timetables'
          TabOrder = 6
          object Label5: TLabel
            Left = 8
            Top = 22
            Width = 81
            Height = 13
            Caption = 'Print per page'
            FocusControl = MaskEdit1
          end
          object MaskEdit1: TMaskEdit
            Left = 92
            Top = 18
            Width = 21
            Height = 20
            Hint = 'Enter number of weekly timetables printed per page'
            AutoSize = False
            EditMask = '99;1; '
            MaxLength = 2
            TabOrder = 0
            Text = '  '
            OnKeyPress = MaskEdit1KeyPress
          end
          object SelectDaysChkBox: TCheckBox
            Left = 125
            Top = 20
            Width = 92
            Height = 17
            Caption = 'Select Days'
            TabOrder = 1
          end
          object ttStartChkBox: TCheckBox
            Left = 222
            Top = 20
            Width = 109
            Height = 17
            Caption = 'Start/end times'
            TabOrder = 2
          end
        end
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Student '
      IsControl = True
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox2: TGroupBox
        Left = 4
        Top = 13
        Width = 499
        Height = 276
        Caption = 'Student Lists'
        TabOrder = 0
        IsControl = True
        object Label1: TLabel
          Left = 12
          Top = 26
          Width = 80
          Height = 13
          Caption = 'Fields Shown:'
        end
        object CheckBox1: TCheckBox
          Left = 14
          Top = 63
          Width = 97
          Height = 17
          Hint = 'Check to show students'#39' gender'
          Caption = '&Sex'
          TabOrder = 1
        end
        object CheckBox2: TCheckBox
          Left = 14
          Top = 143
          Width = 97
          Height = 17
          Hint = 'Check to show students'#39' class'
          Caption = 'Roll C&lass'
          TabOrder = 5
        end
        object CheckBox3: TCheckBox
          Left = 14
          Top = 163
          Width = 97
          Height = 17
          Hint = 'Check to show students'#39' house'
          Caption = 'Ho&use'
          TabOrder = 6
        end
        object CheckBox4: TCheckBox
          Left = 14
          Top = 83
          Width = 97
          Height = 17
          Hint = 'Check to show students'#39' ID'
          Caption = '&ID'
          TabOrder = 2
        end
        object CheckBox5: TCheckBox
          Left = 14
          Top = 183
          Width = 97
          Height = 17
          Hint = 'Check to show students'#39' tutor'
          Caption = '&Tutor'
          TabOrder = 7
        end
        object CheckBox6: TCheckBox
          Left = 14
          Top = 203
          Width = 97
          Height = 17
          Hint = 'Check to show students'#39' home room'
          Caption = 'H&ome Room'
          TabOrder = 8
        end
        object CheckBox7: TCheckBox
          Left = 344
          Top = 51
          Width = 103
          Height = 16
          Hint = 'Show subject choices aligned in blocks'
          Caption = 'Blocks Shown'
          TabOrder = 15
        end
        object CheckBox8: TCheckBox
          Left = 344
          Top = 71
          Width = 125
          Height = 16
          Caption = '&Double Space lists'
          TabOrder = 16
        end
        object CheckBox12: TCheckBox
          Left = 344
          Top = 91
          Width = 103
          Height = 16
          Hint = 'Underline subject choices which clash'
          Caption = 'Sho&w Clashes'
          TabOrder = 17
        end
        object CheckBox24: TCheckBox
          Left = 14
          Top = 44
          Width = 97
          Height = 17
          Hint = 'Check to show students'#39' year'
          Caption = '&Year'
          TabOrder = 0
        end
        object CheckBox29: TCheckBox
          Left = 344
          Top = 111
          Width = 113
          Height = 16
          Hint = 'Print heading - Student list and Student Input windows'
          Caption = '&Print Heading'
          TabOrder = 18
        end
        object MatchAllChkBox: TCheckBox
          Left = 344
          Top = 32
          Width = 111
          Height = 16
          Hint = 
            'If not selected, teacher and room seeks are restricted to studen' +
            'ts year on timetable'
          Caption = 'M&atch all years'
          TabOrder = 14
        end
        object ListStyle1: TRadioGroup
          Left = 163
          Top = 26
          Width = 130
          Height = 106
          Caption = 'List Style'
          Items.Strings = (
            '&Name Only'
            'Other Sub&jects'
            'Fo&rm with boxes'
            'Form with lin&es')
          TabOrder = 12
        end
        object GenderOrder1: TRadioGroup
          Left = 163
          Top = 149
          Width = 130
          Height = 106
          Hint = 'Set gender order for student list windows'
          Caption = 'Gender Order'
          Items.Strings = (
            '&Both Sexes'
            '&Females First'
            '&Males First')
          TabOrder = 13
          TabStop = True
        end
        object CheckBox11: TCheckBox
          Left = 14
          Top = 223
          Width = 97
          Height = 17
          Hint = 'Check to show students'#39' home room'
          Caption = 'Ta&gs'
          TabOrder = 9
        end
        object Button2: TButton
          Left = 66
          Top = 252
          Width = 45
          Height = 21
          Hint = 'Clear all student fields'
          Caption = 'None'
          TabOrder = 11
          OnClick = Button2Click
        end
        object Button1: TButton
          Left = 15
          Top = 252
          Width = 45
          Height = 21
          Hint = 'Tick all student fields'
          Caption = 'All'
          TabOrder = 10
          OnClick = Button1Click
        end
        object CheckBox28: TCheckBox
          Left = 14
          Top = 103
          Width = 97
          Height = 17
          Hint = 'Check to show students'#39' ID'
          Caption = 'ID2'
          TabOrder = 3
          Visible = False
        end
        object chkEmail: TCheckBox
          Left = 14
          Top = 123
          Width = 97
          Height = 17
          Hint = 'Check to show students'#39' ID'
          Caption = 'Email'
          TabOrder = 4
          Visible = False
        end
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'General '
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox4: TGroupBox
        Left = 4
        Top = 7
        Width = 499
        Height = 287
        Caption = 'General '
        TabOrder = 0
        IsControl = True
        object CheckBox14: TCheckBox
          Left = 10
          Top = 31
          Width = 99
          Height = 13
          Hint = 'Show/Hide Floating Hints'
          Caption = '&Floating Hints'
          TabOrder = 0
        end
        object CheckBox15: TCheckBox
          Left = 10
          Top = 54
          Width = 119
          Height = 17
          Hint = 'Backup dialogue is only shown on closing if this is selected.'
          Caption = '&Backup dialogue'
          TabOrder = 1
        end
        object GroupBox10: TGroupBox
          Left = 140
          Top = 11
          Width = 352
          Height = 268
          Caption = 'Text Import/Export'
          TabOrder = 3
          object Label9: TLabel
            Left = 8
            Top = 24
            Width = 50
            Height = 13
            Caption = '&Subjects'
            FocusControl = Edit7
          end
          object GroupBox11: TGroupBox
            Left = 8
            Top = 170
            Width = 336
            Height = 91
            Caption = '&Import text file'
            TabOrder = 2
            object CheckBox17: TCheckBox
              Left = 8
              Top = 21
              Width = 83
              Height = 17
              Hint = 'Import students first name'
              Caption = 'First Name'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
            end
            object CheckBox18: TCheckBox
              Left = 8
              Top = 44
              Width = 77
              Height = 17
              Hint = 'Import students Roll Class'
              Caption = 'Roll Class'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 4
            end
            object CheckBox19: TCheckBox
              Left = 186
              Top = 44
              Width = 63
              Height = 17
              Hint = 'Import students tutor'
              Caption = 'Tutor'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 6
            end
            object CheckBox20: TCheckBox
              Left = 104
              Top = 44
              Width = 69
              Height = 17
              Hint = 'Import students house'
              Caption = 'House'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 5
            end
            object CheckBox21: TCheckBox
              Left = 261
              Top = 44
              Width = 61
              Height = 17
              Hint = 'Import students home room'
              Caption = 'Home'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 7
            end
            object CheckBox22: TCheckBox
              Left = 186
              Top = 21
              Width = 81
              Height = 17
              Hint = 'Import students sex'
              Caption = 'Sex'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 2
            end
            object CheckBox23: TCheckBox
              Left = 261
              Top = 21
              Width = 81
              Height = 17
              Hint = 'Import students ID'
              Caption = 'ID'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 3
            end
            object CheckBox25: TCheckBox
              Left = 104
              Top = 21
              Width = 81
              Height = 17
              Hint = 'Import students year'
              Caption = 'Year'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 1
            end
            object CheckBox16: TCheckBox
              Left = 8
              Top = 67
              Width = 127
              Height = 17
              Hint = 'Add to or replace existing students'
              Caption = 'Replace S&tudents'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clRed
              Font.Height = -12
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 8
            end
          end
          object GroupBox12: TGroupBox
            Left = 8
            Top = 47
            Width = 336
            Height = 120
            Caption = '&Export text file'
            TabOrder = 1
            object Label7: TLabel
              Left = 15
              Top = 23
              Width = 56
              Height = 13
              Caption = 'Separator'
            end
            object Label8: TLabel
              Left = 15
              Top = 52
              Width = 50
              Height = 13
              Caption = 'Delimiter'
            end
            object Label10: TLabel
              Left = 194
              Top = 22
              Width = 60
              Height = 13
              Caption = 'Timetable:'
            end
            object Edit1: TEdit
              Left = 76
              Top = 18
              Width = 29
              Height = 21
              MaxLength = 3
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              Text = 'Edit1'
            end
            object Edit2: TEdit
              Left = 76
              Top = 48
              Width = 29
              Height = 21
              MaxLength = 3
              ParentShowHint = False
              ShowHint = True
              TabOrder = 1
              Text = 'Edit2'
            end
            object RadioButton1: TRadioButton
              Left = 194
              Top = 41
              Width = 111
              Height = 17
              Caption = '&Match printout'
              Checked = True
              TabOrder = 2
              TabStop = True
            end
            object RadioButton2: TRadioButton
              Left = 194
              Top = 60
              Width = 103
              Height = 17
              Caption = '&Generic'
              TabOrder = 3
            end
            object rgpFileExtention: TRadioGroup
              Left = 15
              Top = 78
              Width = 138
              Height = 35
              Caption = 'File Extension'
              Columns = 2
              ItemIndex = 0
              Items.Strings = (
                '.TXT'
                '.CSV')
              TabOrder = 4
            end
          end
          object Edit7: TEdit
            Left = 64
            Top = 20
            Width = 39
            Height = 21
            Hint = 'Number of subject choices to import/export'
            Enabled = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            Text = 'Edit7'
          end
        end
        object CheckBox26: TCheckBox
          Left = 10
          Top = 78
          Width = 115
          Height = 17
          Hint = 'Yes/No check on closing is only shown if this is selected.'
          Caption = 'Exit &verify'
          TabOrder = 2
        end
        object CheckBox27: TCheckBox
          Left = 10
          Top = 101
          Width = 130
          Height = 17
          Hint = 'Autoload current custom file at start'
          Caption = '&Reload custom info'
          TabOrder = 4
        end
        object RadioGroup1: TRadioGroup
          Left = 12
          Top = 182
          Width = 121
          Height = 97
          Caption = 'Subject choices'
          ItemIndex = 0
          Items.Strings = (
            'Use separator'
            'Use space'
            'Separate record')
          TabOrder = 5
          Visible = False
        end
      end
    end
  end
  object TabSet: TTabSet
    Left = 0
    Top = 307
    Width = 592
    Height = 21
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    TabHeight = 2
    Tabs.Strings = (
      'Timetable '
      'Print Timetable '
      'Student '
      'General ')
    TabIndex = 0
    OnClick = TabSetClick
  end
end
