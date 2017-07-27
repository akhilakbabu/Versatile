object FrmOpenFile: TFrmOpenFile
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  BorderWidth = 5
  Caption = 'FrmOpenFile'
  ClientHeight = 369
  ClientWidth = 524
  Color = clBtnFace
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
  object dlbOpenFile: TDirectoryListBox
    Left = 0
    Top = 27
    Width = 225
    Height = 279
    Align = alLeft
    FileList = flbOpenFile
    ItemHeight = 16
    TabOrder = 0
  end
  object flbOpenFile: TFileListBox
    Left = 225
    Top = 27
    Width = 299
    Height = 279
    Align = alClient
    FileType = [ftDirectory, ftNormal]
    ItemHeight = 16
    Mask = '*.TTW'
    ShowGlyphs = True
    TabOrder = 1
    OnClick = UpdateFileName
    OnDblClick = SelectAndClose
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 524
    Height = 27
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object lblLookIn: TLabel
      Left = 15
      Top = 8
      Width = 37
      Height = 13
      Caption = 'Look in:'
    end
    object dcbOpenFile: TDriveComboBox
      Left = 58
      Top = 5
      Width = 167
      Height = 19
      BevelKind = bkTile
      DirList = dlbOpenFile
      TabOrder = 0
      OnChange = UpdateDrive
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 306
    Width = 524
    Height = 63
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    DesignSize = (
      524
      63)
    object lblFileName: TLabel
      Left = 15
      Top = 12
      Width = 49
      Height = 13
      Caption = 'File &name:'
      FocusControl = edtFileName
    end
    object lblFilesOfType: TLabel
      Left = 15
      Top = 39
      Width = 63
      Height = 13
      Caption = 'Files of type:'
    end
    object btnOpen: TButton
      Left = 448
      Top = 9
      Width = 75
      Height = 24
      Anchors = [akRight, akBottom]
      Caption = 'Open'
      ModalResult = 1
      TabOrder = 0
      OnClick = SelectFile
    end
    object btnCancel: TButton
      Left = 448
      Top = 36
      Width = 75
      Height = 24
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Cancel'
      Default = True
      ModalResult = 2
      TabOrder = 1
    end
    object edtFileName: TEdit
      Left = 109
      Top = 9
      Width = 241
      Height = 21
      TabOrder = 2
    end
    object edtFilesOfType: TEdit
      Left = 109
      Top = 36
      Width = 241
      Height = 21
      ReadOnly = True
      TabOrder = 3
    end
  end
end
