object ClassWindow: TClassWindow
  Left = 152
  Top = 199
  Caption = 'Subject Codes'
  ClientHeight = 249
  ClientWidth = 559
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 31
    Top = 74
    object add2: TMenuItem
      Caption = 'Add ...'
      Hint = 'Add a new code'
    end
    object Change2: TMenuItem
      Caption = 'Change ...'
      Hint = 'Change or set code'
    end
    object Delete2: TMenuItem
      Caption = 'Delete ...'
      Hint = 'Delete a code'
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object Timetable1: TMenuItem
      Caption = 'Timetable'
      Hint = 'Show weekly timetable'
      Visible = False
    end
    object View2: TMenuItem
      Caption = 'View ...'
      Hint = 'Change window view'
      OnClick = View1Click
    end
    object CodeLengths2: TMenuItem
      Caption = 'Code Lengths ...'
      Hint = 'Set maximum code length'
    end
    object N7: TMenuItem
      Caption = '-'
    end
    object Print2: TMenuItem
      Caption = 'Print ...'
      HelpContext = 9
      Hint = 'Print code window'
    end
    object PrintSetup2: TMenuItem
      Caption = 'Print Setup ...'
      HelpContext = 10
      Hint = 'Configure Printer settings'
    end
    object Exportastextfile1: TMenuItem
      Caption = 'Export as text file ...'
      Hint = 'Output textfile'
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
          Caption = '&Subject'
          HelpContext = 129
          Hint = 'Show Subject Codes window'
        end
        object Teacher1: TMenuItem
          Caption = '&Teacher'
          HelpContext = 136
          Hint = 'Show Teacher Codes window'
        end
        object Room1: TMenuItem
          Caption = '&Room'
          HelpContext = 143
          Hint = 'Show Room Codes window'
        end
        object Class1: TMenuItem
          Caption = 'Roll &Class'
          HelpContext = 150
          Hint = 'Show class codes window'
        end
        object Faculty1: TMenuItem
          Caption = '&Faculty'
          HelpContext = 152
          Hint = 'Show faculty codes window'
        end
        object House1: TMenuItem
          Caption = '&House'
          HelpContext = 154
          Hint = 'Show house codes window'
        end
        object Times1: TMenuItem
          Caption = 'T&imes'
          HelpContext = 156
          Hint = 'Show time allotment window'
        end
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object Add1: TMenuItem
        Caption = '&Add ...'
        Hint = 'Add a new code'
      end
      object Change1: TMenuItem
        Caption = '&Change ...'
        Hint = 'Change a code'
      end
      object Delete1: TMenuItem
        Caption = '&Delete ...'
        Hint = 'Delete a code'
      end
      object ShowClasses1: TMenuItem
        Caption = 'Show Classes ...'
        Visible = False
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object View1: TMenuItem
        Caption = '&View ...'
        Hint = 'Change view or sort of codes'
        ShortCut = 16471
        OnClick = View1Click
      end
      object Codelengths1: TMenuItem
        Caption = 'Code &Lengths ...'
        Hint = 'Set length of code'
      end
    end
  end
end
