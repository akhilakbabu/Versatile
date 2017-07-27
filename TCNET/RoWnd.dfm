object RoWindow: TRoWindow
  Left = 225
  Top = 263
  HelpContext = 143
  Caption = 'Room Codes'
  ClientHeight = 293
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
      Caption = '&Add ...'
      HelpContext = 144
      Hint = 'Add a new code'
      ShortCut = 45
      OnClick = Add1Click
    end
    object Change2: TMenuItem
      Caption = 'C&hange ...'
      HelpContext = 145
      Hint = 'Change or set code'
      ShortCut = 13
      OnClick = Change1Click
    end
    object Delete2: TMenuItem
      Caption = '&Delete ...'
      HelpContext = 146
      Hint = 'Delete a code'
      ShortCut = 46
      OnClick = Delete1Click
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object Timetable1: TMenuItem
      Caption = 'Room &Timetable'
      HelpContext = 196
      Hint = 'Show weekly timetable'
      Visible = False
      OnClick = Timetable1Click
    end
    object View2: TMenuItem
      Caption = '&View ...'
      HelpContext = 147
      Hint = 'Change window view'
      ShortCut = 16471
      OnClick = View1Click
    end
    object CodeLengths2: TMenuItem
      Caption = 'Code &Lengths ...'
      HelpContext = 148
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
        end
        object Teacher1: TMenuItem
        end
        object Room1: TMenuItem
        end
        object Class1: TMenuItem
        end
        object Faculty1: TMenuItem
        end
        object House1: TMenuItem
        end
        object Times1: TMenuItem
        end
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object Add1: TMenuItem
        Caption = '&Add ...'
        HelpContext = 144
        Hint = 'Add a new code'
        ShortCut = 45
        OnClick = Add1Click
      end
      object Change1: TMenuItem
        Caption = '&Change ...'
        HelpContext = 145
        Hint = 'Change a code'
        ShortCut = 13
        OnClick = Change1Click
      end
      object Delete1: TMenuItem
        Caption = '&Delete ...'
        HelpContext = 146
        Hint = 'Delete a code'
        ShortCut = 46
        OnClick = Delete1Click
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object View1: TMenuItem
        Caption = '&View ...'
        HelpContext = 147
        Hint = 'Change view or sort of codes'
        ShortCut = 16471
        OnClick = View1Click
      end
      object Codelengths1: TMenuItem
        Caption = 'Code &Lengths ...'
        HelpContext = 148
        Hint = 'Set length of code'
        OnClick = Codelengths1Click
      end
    end
  end
end
