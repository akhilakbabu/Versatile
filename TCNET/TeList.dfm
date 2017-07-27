object TeListWin: TTeListWin
  Left = 211
  Top = 168
  HelpContext = 351
  Caption = 'Teacher List Window'
  ClientHeight = 316
  ClientWidth = 342
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
  OnDblClick = Selection1Click
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object PopupMenu1: TPopupMenu
    Images = MainForm.ActionImages
    OnPopup = PopupMenu1Popup
    Left = 42
    Top = 44
    object Selection1: TMenuItem
      Caption = '&Selection ...'
      HelpContext = 351
      Hint = 'Open Selection dialogue'
      ImageIndex = 9
      ShortCut = 16471
      OnClick = Selection1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
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
