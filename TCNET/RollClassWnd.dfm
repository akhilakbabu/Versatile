object RollClassWindow: TRollClassWindow
  Left = 327
  Top = 190
  HelpContext = 149
  Caption = 'Roll Class Codes'
  ClientHeight = 273
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
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 31
    Top = 74
    object add2: TMenuItem
      Caption = 'Add ...'
      HelpContext = 150
      Hint = 'Add a new code'
      ShortCut = 45
      OnClick = Add1Click
    end
    object Change2: TMenuItem
      Caption = 'Change ...'
      HelpContext = 314
      Hint = 'Change or set code'
      ShortCut = 13
      OnClick = Change1Click
    end
    object Delete2: TMenuItem
      Caption = 'Delete ...'
      HelpContext = 315
      Hint = 'Delete a code'
      ShortCut = 46
      OnClick = Delete1Click
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object Timetable1: TMenuItem
      Caption = 'Class Timetable'
      HelpContext = 198
      Hint = 'Show weekly timetable'
      Visible = False
      OnClick = Timetable1Click
    end
    object CodeLengths2: TMenuItem
      Caption = 'Code Lengths ...'
      HelpContext = 316
      Hint = 'Set maximum code length'
      OnClick = Codelengths1Click
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
      object Add1: TMenuItem
        Caption = '&Add ...'
        HelpContext = 150
        Hint = 'Add a new code'
        ShortCut = 45
        OnClick = Add1Click
      end
      object Change1: TMenuItem
        Caption = '&Change ...'
        HelpContext = 314
        Hint = 'Change a code'
        ShortCut = 13
        OnClick = Change1Click
      end
      object Delete1: TMenuItem
        Caption = '&Delete ...'
        HelpContext = 315
        Hint = 'Delete a code'
        ShortCut = 46
        OnClick = Delete1Click
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object Codelengths1: TMenuItem
        Caption = 'Code &Lengths ...'
        HelpContext = 316
        Hint = 'Set length of code'
        OnClick = Codelengths1Click
      end
    end
  end
end
