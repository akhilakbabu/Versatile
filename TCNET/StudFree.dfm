object StudFreeWin: TStudFreeWin
  Left = 329
  Top = 143
  HelpContext = 350
  Caption = 'Students Free in Block'
  ClientHeight = 302
  ClientWidth = 339
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = True
  PopupMenu = PopupMenu1
  Position = poDefault
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PopupMenu1: TPopupMenu
    Images = MainForm.ActionImages
    OnPopup = PopupMenu1Popup
    Left = 58
    Top = 44
    object ChangeStudent1: TMenuItem
      Caption = 'Change Student ...'
      HelpContext = 47
      ShortCut = 13
      OnClick = ChangeStudent1Click
    end
    object StudentTimetable1: TMenuItem
      Caption = 'Student Timetable'
      HelpContext = 171
      Hint = 'Show Student Timetable'
      ImageIndex = 45
      OnClick = StudentTimetable1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Print1: TMenuItem
      Action = MainForm.MainPrint
    end
    object PrintSetup1: TMenuItem
      Action = MainForm.DoPrintPreview
    end
    object Copy2: TMenuItem
      Action = MainForm.CopyWin
    end
  end
end
