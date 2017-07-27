object FrmStudentClashes: TFrmStudentClashes
  Left = 0
  Top = 0
  Caption = 'Student Clashes'
  ClientHeight = 304
  ClientWidth = 643
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object grdStudentClashes: TNiceGrid
    Left = 0
    Top = 0
    Width = 643
    Height = 304
    Cursor = 101
    ColCount = 3
    RowCount = 0
    HeaderColor = clScrollBar
    HeaderFont.Charset = DEFAULT_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -11
    HeaderFont.Name = 'Tahoma'
    HeaderFont.Style = []
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    FitToWidth = True
    ReadOnly = True
    Columns = <
      item
        Title = 'Student Name'
        Width = 200
        VertAlign = vaTop
        CanResize = False
        ReadOnly = True
      end
      item
        Title = 'ID'
        Width = 80
        VertAlign = vaTop
        CanResize = False
        ReadOnly = True
      end
      item
        Title = 'Subject List'
        Width = 324
        VertAlign = vaTop
        ReadOnly = True
      end>
    GutterKind = gkNumber
    GutterWidth = 35
    GutterFont.Charset = DEFAULT_CHARSET
    GutterFont.Color = clWindowText
    GutterFont.Height = -11
    GutterFont.Name = 'Tahoma'
    GutterFont.Style = []
    ShowFooter = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Align = alClient
    TabOrder = 0
    ExplicitHeight = 224
  end
end
