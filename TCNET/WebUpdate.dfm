object WebUpdateDlg: TWebUpdateDlg
  Left = 168
  Top = 172
  HelpContext = 392
  BorderStyle = bsDialog
  Caption = 'Network Time Chart Update Check'
  ClientHeight = 267
  ClientWidth = 487
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label11: TLabel
    Left = 16
    Top = 203
    Width = 304
    Height = 13
    Caption = 'Click the '#39'Yes'#39' button to update your Time Chart now.'
    Visible = False
  end
  object Label4: TLabel
    Left = 271
    Top = 235
    Width = 82
    Height = 13
    Caption = '&Update Check'
    FocusControl = ComboBox1
  end
  object Yes: TBitBtn
    Left = 101
    Top = 229
    Width = 75
    Height = 25
    Hint = 'Open up the download page in a browser window.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    Visible = False
    OnClick = DoUpdate
    Kind = bkYes
  end
  object Later: TBitBtn
    Left = 16
    Top = 229
    Width = 75
    Height = 24
    Hint = 'Don'#39't download any update.'
    Cancel = True
    Caption = '&Later'
    ModalResult = 7
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    Visible = False
    NumGlyphs = 2
  end
  object OK: TBitBtn
    Left = 66
    Top = 229
    Width = 75
    Height = 25
    TabOrder = 2
    Visible = False
    Kind = bkOK
  end
  object GroupBox1: TGroupBox
    Left = 15
    Top = 16
    Width = 457
    Height = 87
    Caption = 'New Time Chart update available from www.amig.com.au'
    TabOrder = 3
    object Label1: TLabel
      Left = 13
      Top = 43
      Width = 148
      Height = 13
      Caption = 'You are currently running '
    end
    object Label16: TLabel
      Left = 158
      Top = 43
      Width = 256
      Height = 13
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 147
      Top = 21
      Width = 294
      Height = 13
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label6: TLabel
      Left = 15
      Top = 21
      Width = 135
      Height = 13
      Caption = 'Download available for '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 15
      Top = 63
      Width = 296
      Height = 13
      Caption = 'A current support plan is needed to use this update.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Visible = False
    end
  end
  object GroupBox2: TGroupBox
    Left = 15
    Top = 113
    Width = 457
    Height = 73
    Caption = 'Support Plan'
    TabOrder = 4
    object Label13: TLabel
      Left = 12
      Top = 24
      Width = 181
      Height = 13
      AutoSize = False
      Caption = 'Your Support Plan is valid until'
    end
    object Label15: TLabel
      Left = 11
      Top = 47
      Width = 340
      Height = 13
      Caption = 'This update is provided under your Time Chart Support Plan'
    end
    object Label14: TLabel
      Left = 193
      Top = 24
      Width = 256
      Height = 13
      AutoSize = False
      Caption = 'Label14'
    end
  end
  object ComboBox1: TComboBox
    Left = 359
    Top = 231
    Width = 97
    Height = 21
    Hint = 'Set period between checks for updates'
    Style = csDropDownList
    ItemHeight = 0
    TabOrder = 5
  end
  object IdHTTP1: TIdHTTP
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 199
    Top = 224
  end
  object IdAntiFreeze1: TIdAntiFreeze
    Left = 240
    Top = 224
  end
end
