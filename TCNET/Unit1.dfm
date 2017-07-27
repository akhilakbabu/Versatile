object Form1: TForm1
  Left = 316
  Top = 264
  BorderStyle = bsDialog
  Caption = 'Insert School Name - Network Time Chart 6'
  ClientHeight = 148
  ClientWidth = 649
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 293
    Width = 63
    Height = 13
    Caption = 'pass phrase: '
  end
  object Label2: TLabel
    Left = 5
    Top = 5
    Width = 64
    Height = 13
    Caption = 'School Name'
  end
  object Label3: TLabel
    Left = 7
    Top = 47
    Width = 65
    Height = 13
    Caption = 'Version String'
  end
  object Label4: TLabel
    Left = 5
    Top = 89
    Width = 75
    Height = 13
    Caption = 'Version Number'
  end
  object Label5: TLabel
    Left = 81
    Top = 316
    Width = 32
    Height = 13
    Caption = 'Label5'
  end
  object Label8: TLabel
    Left = 381
    Top = 283
    Width = 32
    Height = 13
    Alignment = taCenter
    Caption = 'Label8'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label9: TLabel
    Left = 139
    Top = 174
    Width = 32
    Height = 13
    Caption = 'Label9'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label10: TLabel
    Left = 383
    Top = 264
    Width = 32
    Height = 13
    Caption = 'Label9'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label17: TLabel
    Left = 16
    Top = 173
    Width = 78
    Height = 13
    Caption = 'Working Area'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label18: TLabel
    Left = 360
    Top = 181
    Width = 65
    Height = 13
    Caption = 'Check Sum'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label14: TLabel
    Left = 310
    Top = 121
    Width = 205
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label15: TLabel
    Left = 87
    Top = 1
    Width = 506
    Height = 16
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label6: TLabel
    Left = 187
    Top = 43
    Width = 94
    Height = 13
    Caption = 'Support Expiry Date'
  end
  object Label7: TLabel
    Left = 300
    Top = 46
    Width = 191
    Height = 13
    AutoSize = False
    Caption = 'Label7'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label16: TLabel
    Left = 315
    Top = 61
    Width = 195
    Height = 13
    Caption = '(creates TCNET.DAT in current directory)'
  end
  object Label13: TLabel
    Left = 330
    Top = 77
    Width = 161
    Height = 13
    Caption = '(also created TCCNET.DAT)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBackground
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
  object Edit1: TEdit
    Left = 83
    Top = 288
    Width = 169
    Height = 21
    Enabled = False
    TabOrder = 0
    Text = #169'Ncevy 2009'#170#185#176#191' NZVT FLFGRZF'#182'@'#177'GP6.0 Argjbex'#190#180#183#186#223
  end
  object Edit2: TEdit
    Left = 5
    Top = 21
    Width = 494
    Height = 21
    TabOrder = 1
    Text = 'SYDNEY SECONDARY COLLEGE-BLACKWATTLE BAY CAMPUS'
    OnChange = Edit2Change
  end
  object Edit3: TEdit
    Left = 7
    Top = 63
    Width = 169
    Height = 21
    Enabled = False
    TabOrder = 2
    Text = 'Network Time Chart 2000'
  end
  object Edit4: TEdit
    Left = 5
    Top = 105
    Width = 169
    Height = 21
    Enabled = False
    TabOrder = 3
    Text = '60'
  end
  object Memo5: TMemo
    Left = 10
    Top = 191
    Width = 335
    Height = 87
    Lines.Strings = (
      'Memo5')
    ScrollBars = ssVertical
    TabOrder = 4
    OnChange = Memo5Change
  end
  object Memo6: TMemo
    Left = 360
    Top = 205
    Width = 249
    Height = 49
    Lines.Strings = (
      'Memo6')
    ScrollBars = ssVertical
    TabOrder = 5
  end
  object BitBtn7: TBitBtn
    Left = 185
    Top = 112
    Width = 118
    Height = 29
    Caption = 'Make Key File'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    OnClick = BitBtn7Click
    Glyph.Data = {
      F2010000424DF201000000000000760000002800000024000000130000000100
      0400000000007C01000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333334433333
      3333333333388F3333333333000033334224333333333333338338F333333333
      0000333422224333333333333833338F33333333000033422222243333333333
      83333338F3333333000034222A22224333333338F33F33338F33333300003222
      A2A2224333333338F383F3338F33333300003A2A222A222433333338F8333F33
      38F33333000034A22222A22243333338833333F3338F333300004222A2222A22
      2433338F338F333F3338F3330000222A3A2224A22243338F3838F338F3338F33
      0000A2A333A2224A2224338F83338F338F3338F300003A33333A2224A2224338
      333338F338F3338F000033333333A2224A2243333333338F338F338F00003333
      33333A2224A2233333333338F338F83300003333333333A2224A333333333333
      8F338F33000033333333333A222433333333333338F338F30000333333333333
      A224333333333333338F38F300003333333333333A223333333333333338F8F3
      000033333333333333A3333333333333333383330000}
    NumGlyphs = 2
  end
  object Button1: TButton
    Left = 358
    Top = 92
    Width = 75
    Height = 25
    Caption = 'Validate'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 7
    OnClick = Button1Click
  end
  object DateTimePicker1: TDateTimePicker
    Left = 188
    Top = 58
    Width = 105
    Height = 21
    Date = 36331.464655960600000000
    Time = 36331.464655960600000000
    Color = clYellow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 8
    OnChange = DateTimePicker1Change
  end
  object BitBtn1: TBitBtn
    Left = 193
    Top = 84
    Width = 25
    Height = 23
    Caption = '6'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 9
    OnClick = BitBtn1Click
  end
  object BitBtn2: TBitBtn
    Left = 222
    Top = 84
    Width = 25
    Height = 23
    Caption = '12'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 10
    OnClick = BitBtn2Click
  end
  object BitBtn3: TBitBtn
    Left = 251
    Top = 84
    Width = 25
    Height = 23
    Caption = '18'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 11
    OnClick = BitBtn3Click
  end
  object Panel1: TPanel
    Left = 526
    Top = 22
    Width = 103
    Height = 119
    Hint = 'Only enter if customised'
    BevelInner = bvLowered
    Color = clSkyBlue
    TabOrder = 12
    object Label11: TLabel
      Left = 18
      Top = 51
      Width = 70
      Height = 13
      Hint = 'Only enter if customised'
      Caption = 'Customer ID'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label12: TLabel
      Left = 12
      Top = 6
      Width = 83
      Height = 47
      AutoSize = False
      Caption = '     Only if CUSTOMISED'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object Edit5: TEdit
      Left = 20
      Top = 67
      Width = 67
      Height = 21
      Hint = 'Only enter if customised'
      TabOrder = 0
    end
    object Cases21ExportNeeded: TCheckBox
      Left = 16
      Top = 95
      Width = 83
      Height = 17
      Hint = 'Only enter if customised'
      Caption = 'CASES 21'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
    end
  end
  object MainMenu1: TMainMenu
    Left = 482
    Top = 266
    object Make1: TMenuItem
      Caption = 'Make'
      object InitialiseString1: TMenuItem
        Caption = 'Initialise String'
        OnClick = InitialiseString1Click
      end
      object Combineinfo1: TMenuItem
        Caption = 'Pad String'
        OnClick = Combineinfo1Click
      end
      object CalcChecksum1: TMenuItem
        Caption = 'Calc Checksum'
        OnClick = CalcChecksum1Click
      end
      object AddChecksum1: TMenuItem
        Caption = 'Add Checksum'
        OnClick = AddChecksum1Click
      end
      object Encrypt1: TMenuItem
        Caption = 'Encrypt'
        OnClick = Encrypt1Click
      end
      object Savefile1: TMenuItem
        Caption = 'Save file'
        OnClick = Savefile1Click
      end
    end
    object Verify1: TMenuItem
      Caption = 'Verify'
      object LoadFile1: TMenuItem
        Caption = 'Load File'
        OnClick = LoadFile1Click
      end
      object Decrypt1: TMenuItem
        Caption = 'Decrypt'
        OnClick = Decrypt1Click
      end
      object GetMessage1: TMenuItem
        Caption = 'Get Message'
        OnClick = GetMessage1Click
      end
      object Validate1: TMenuItem
        Caption = 'Validate'
        OnClick = Validate1Click
      end
    end
  end
end
