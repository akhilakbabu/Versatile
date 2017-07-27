object TimesWindow: TTimesWindow
  Left = 225
  Top = 263
  HelpContext = 156
  Caption = 'Times'
  ClientHeight = 253
  ClientWidth = 567
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  Menu = MainMenu1
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  Position = poDefault
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 31
    Top = 76
    object Change2: TMenuItem
      Caption = 'Change ...'
      HelpContext = 87
      Hint = 'Change or set code'
      ShortCut = 13
      OnClick = Change1Click
    end
    object N7: TMenuItem
      Caption = '-'
    end
    object Print2: TMenuItem
      Action = MainForm.MainPrint
    end
    object PrintSetup2: TMenuItem
      Action = MainForm.DoPrintPreview
    end
    object Exportastextfile1: TMenuItem
      Action = MainForm.CopyWin
    end
  end
  object MainMenu1: TMainMenu
    Left = 100
    Top = 136
    object Codes1: TMenuItem
      Caption = '&Codes'
      GroupIndex = 75
      HelpContext = 211
      Hint = 'The Codes Menu'
      OnClick = Codes1Click
      object SelectCode1: TMenuItem
        Caption = '&Select Code'
        HelpContext = 211
        Hint = 'Select a Code Window'
        object Subject1: TMenuItem
          Action = MainForm.OpenSuWnd
        end
        object Teacher1: TMenuItem
          Action = MainForm.OpenTeWnd
        end
        object Room1: TMenuItem
          Action = MainForm.OpenRoWnd
        end
        object Class1: TMenuItem
          Action = MainForm.OpenRollWnd
        end
        object Faculty1: TMenuItem
          Action = MainForm.OpenFacWnd
        end
        object House1: TMenuItem
          Action = MainForm.OpenHouseWnd
        end
        object Times1: TMenuItem
          Action = MainForm.OpenTimesWnd
        end
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object Change1: TMenuItem
        Caption = '&Change ...'
        HelpContext = 87
        Hint = 'Change a code'
        ShortCut = 13
        OnClick = Change1Click
      end
    end
  end
end
