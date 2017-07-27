object Worksheetwin: TWorksheetwin
  Left = 411
  Top = 185
  HelpContext = 372
  Caption = 'Worksheet'
  ClientHeight = 525
  ClientWidth = 531
  Color = clSilver
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  FormStyle = fsMDIChild
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = True
  PopupMenu = PopupMenu1
  Position = poDefault
  ShowHint = True
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDeactivate = FormDeactivate
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 465
    Width = 531
    Height = 50
    Align = alBottom
    ExplicitTop = 265
  end
  object TLabel
    Left = 58
    Top = 120
    Width = 5
    Height = 13
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 531
    Height = 19
    Align = alTop
    BevelOuter = bvNone
    Color = clSkyBlue
    ParentBackground = False
    TabOrder = 0
    object lblMultipleValue: TLabel
      Left = 232
      Top = 1
      Width = 90
      Height = 13
      Alignment = taCenter
      Caption = 'lblMultipleValue'
      ParentShowHint = False
      ShowHint = False
    end
    object Label2: TLabel
      Left = 2
      Top = 3
      Width = 23
      Height = 13
      Caption = 'Top'
    end
    object Label1: TLabel
      Left = 337
      Top = 3
      Width = 39
      Height = 13
      Caption = 'Label1'
    end
  end
  object StringGrid1: TStringGrid
    Left = 41
    Top = 25
    Width = 448
    Height = 440
    HelpContext = 372
    Align = alClient
    BorderStyle = bsNone
    Ctl3D = True
    DefaultRowHeight = 14
    FixedColor = 16573144
    RowCount = 7
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goTabs, goThumbTracking]
    ParentCtl3D = False
    ParentShowHint = False
    ShowHint = False
    TabOrder = 1
    OnClick = StringGrid1Click
    OnDblClick = StringGrid1DblClick
    OnDragDrop = DropSubject
    OnDragOver = DragOver
    OnDrawCell = StringGrid1DrawCell
    OnKeyDown = StringGrid1KeyDown
    OnMouseDown = StringGrid1MouseDown
    OnSelectCell = StringGrid1SelectCell
    OnTopLeftChanged = StringGrid1TopLeftChanged
    ColWidths = (
      64
      64
      64
      64
      64)
    RowHeights = (
      14
      14
      14
      14
      14
      14
      14)
  end
  object Panel2: TPanel
    Tag = 1111
    Left = 0
    Top = 19
    Width = 531
    Height = 6
    Align = alTop
    AutoSize = True
    BevelInner = bvLowered
    Color = clSkyBlue
    DockSite = True
    ParentBackground = False
    TabOrder = 2
    OnDockDrop = Panel2DockDrop
    OnDockOver = Panel2DockOver
  end
  object Panel3: TPanel
    Tag = 1112
    Left = 0
    Top = 515
    Width = 531
    Height = 10
    Align = alBottom
    AutoSize = True
    BevelInner = bvLowered
    DockSite = True
    TabOrder = 3
    OnDockDrop = Panel3DockDrop
    OnDockOver = Panel3DockOver
  end
  object Panel4: TPanel
    Left = 0
    Top = 25
    Width = 41
    Height = 440
    Align = alLeft
    AutoSize = True
    BevelInner = bvLowered
    TabOrder = 4
  end
  object Panel5: TPanel
    Left = 489
    Top = 25
    Width = 42
    Height = 440
    Align = alRight
    AutoSize = True
    BevelInner = bvLowered
    TabOrder = 5
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 312
    Top = 152
    object Entries2: TMenuItem
      Caption = 'Entries...'
      HelpContext = 387
      Hint = 'Change timetable entries'
      OnClick = Entries1Click
    end
    object Build2: TMenuItem
      Caption = 'Build...'
      HelpContext = 104
      Hint = 'Build timetable'
      OnClick = Build1Click
    end
    object Multiple2: TMenuItem
      Caption = 'Multiples...'
      HelpContext = 385
      Hint = 'Copy, Move, Swap or Clear entries'
      OnClick = Multiples1Click
    end
    object ClashHelp2: TMenuItem
      Caption = 'Target times...'
      HelpContext = 386
      Hint = 'Show clash free times'
      OnClick = TargetTimes1Click
    end
    object Alter2: TMenuItem
      Caption = 'Alter...'
      HelpContext = 389
      Hint = 'Add or delete levels'
      OnClick = Alter1Click
    end
    object BlockClashes2: TMenuItem
      Caption = 'Block Clashes'
      HelpContext = 178
      OnClick = BlockClashes2Click
    end
    object mniTeacherLoadonWorksheet1: TMenuItem
      Caption = 'Teacher Load on Worksheet...'
      OnClick = DisplayTeacherLoadOnWorksheet
    end
    object popWorksheetN1: TMenuItem
      Caption = '-'
    end
    object ShowSubjectTimetable1: TMenuItem
      Caption = 'Subject Timetable'
      HelpContext = 198
      Hint = 'Show subject timetable'
      Visible = False
      OnClick = ShowSubjectTimetable1Click
    end
    object ShowTeacherTimetable1: TMenuItem
      Caption = 'Teacher Timetable'
      HelpContext = 194
      Hint = 'Show teacher weekly timetable'
      Visible = False
      OnClick = ShowTeacherTimetable1Click
    end
    object ShowRoomTimetable1: TMenuItem
      Caption = 'Room Timetable'
      HelpContext = 196
      Hint = 'Show room weekly timetable'
      Visible = False
      OnClick = ShowRoomTimetable1Click
    end
    object ShowClassTimetable1: TMenuItem
      Caption = 'Class Timetable'
      HelpContext = 198
      Hint = 'Show class weekly timetable'
      Visible = False
      OnClick = ShowClassTimetable1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Print1: TMenuItem
      Action = MainForm.MainPrint
    end
    object PrintSetup1: TMenuItem
      Action = MainForm.DoPrintPreview
    end
  end
  object MainMenu1: TMainMenu
    Left = 169
    Top = 151
    object Edit1: TMenuItem
      Caption = '&Edit'
      GroupIndex = 50
      HelpContext = 236
      Hint = 'The Edit menu'
      OnClick = Edit1Click
      object Undo1: TMenuItem
        Caption = 'Undo'
        HelpContext = 368
        ImageIndex = 52
        ShortCut = 16474
        OnClick = Undo1Click
      end
      object Redo1: TMenuItem
        Caption = 'Redo'
        HelpContext = 368
        ImageIndex = 53
        ShortCut = 24666
        OnClick = Redo1Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Cut1: TMenuItem
        Bitmap.Data = {
          FE000000424DFE00000000000000760000002800000010000000110000000100
          04000000000088000000CE0E0000C40E00001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
          7777777744777777777777747747744777777774774747747777777477474774
          7777777744474774777777777747444777777777774047777777777777707777
          7777777777000777777777777707077777777777700700777777777770777077
          7777777770777077777777777077707777777777777777777777777777777777
          7777}
        Caption = 'Cu&t'
        HelpContext = 237
        ImageIndex = 54
        ShortCut = 16472
        OnClick = Cut1Click
      end
      object Copy1: TMenuItem
        Bitmap.Data = {
          A6020000424DA60200000000000036000000280000000F0000000D0000000100
          18000000000070020000CE0E0000C40E00000000000000000000BFBFBFBFBFBF
          BFBFBFBFBFBFBFBFBFBFBFBF7F00007F00007F00007F00007F00007F00007F00
          007F00007F0000000000BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF7F0000FF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F0000000000BFBFBFBFBFBF
          BFBFBFBFBFBFBFBFBFBFBFBF7F0000FFFFFF0000000000000000000000000000
          00FFFFFF7F00000000000000000000000000000000000000000000007F0000FF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F0000000000000000FFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF7F0000FFFFFF0000000000000000000000000000
          00FFFFFF7F0000000000000000FFFFFF0000000000000000000000007F0000FF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F0000000000000000FFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF7F0000FFFFFF000000000000FFFFFF7F00007F00
          007F00007F0000000000000000FFFFFF0000000000000000000000007F0000FF
          FFFFFFFFFFFFFFFFFFFFFF7F0000FFFFFF7F0000BFBFBF000000000000FFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF7F0000FFFFFFFFFFFFFFFFFFFFFFFF7F00007F00
          00BFBFBFBFBFBF000000000000FFFFFF000000000000FFFFFF0000007F00007F
          00007F00007F00007F00007F0000BFBFBFBFBFBFBFBFBF000000000000FFFFFF
          FFFFFFFFFFFFFFFFFF000000FFFFFF000000BFBFBFBFBFBFBFBFBFBFBFBFBFBF
          BFBFBFBFBFBFBF000000000000FFFFFFFFFFFFFFFFFFFFFFFF000000000000BF
          BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF000000000000000000
          000000000000000000000000BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
          BFBFBFBFBFBFBF000000}
        Caption = '&Copy'
        HelpContext = 238
        ImageIndex = 55
        ShortCut = 16451
        OnClick = Copy1Click
      end
      object Paste1: TMenuItem
        Bitmap.Data = {
          36010000424D3601000000000000760000002800000011000000100000000100
          040000000000C0000000CE0E0000C40E00001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
          7777700000007777774444444444700000007000004FFFFFFFF4700000000838
          384F444444F4700000000383834FFFFFFFF4700000000838384F444F44447000
          00000383834FFFFF4F47700000000838384FFFFF447770000000038383444444
          4077700000000838383838383077700000000380000000088077700000000880
          7777770830777000000003830B00B083807770000000700000BB000007777000
          0000777770000777777770000000777777777777777770000000}
        Caption = '&Paste'
        HelpContext = 239
        ImageIndex = 56
        ShortCut = 16470
        OnClick = PasteData
      end
      object Delete1: TMenuItem
        Bitmap.Data = {
          DE000000424DDE0000000000000076000000280000000D0000000D0000000100
          04000000000068000000CE0E0000C40E00001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00797777777777
          9000999777777777700099997777777970007999777777977000779997777997
          7000777999779977700077779999977770007777799977777000777799999777
          7000777999779977700079999777799770009999777777997000999777777777
          9000}
        Caption = '&Delete'
        HelpContext = 240
        ShortCut = 46
        OnClick = Delete1Click
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object SelectAll1: TMenuItem
        Caption = 'Select All'
        HelpContext = 241
        OnClick = SelectAll1Click
      end
    end
    object Timetable1: TMenuItem
      Caption = '&Timetable'
      GroupIndex = 130
      HelpContext = 81
      Hint = 'The Timetable Menu'
      OnClick = Timetable1Click
      object InUse1: TMenuItem
        Caption = '&In Use ...'
        HelpContext = 364
        Hint = 'Specify timetable currently in use'
        OnClick = InUse1Click
      end
      object Configure1: TMenuItem
        Caption = '&Configure'
        HelpContext = 83
        Hint = 'Configure sub-menu'
        object Version1: TMenuItem
          Caption = '&Version ...'
          HelpContext = 84
          Hint = 'Set timetable version'
          OnClick = Version1Click
        end
        object Years1: TMenuItem
          Caption = '&Years ...'
          HelpContext = 85
          Hint = 'Set number and names of years'
          OnClick = Years1Click
        end
        object Days1: TMenuItem
          Caption = '&Days ...'
          HelpContext = 86
          Hint = 'Set number and names of days'
          OnClick = Days1Click
        end
        object TimeSlots1: TMenuItem
          Caption = '&Time Slots ...'
          HelpContext = 87
          Hint = 'Set number and names of time slots'
          OnClick = TimeSlots1Click
        end
        object Levels1: TMenuItem
          Caption = '&Levels ...'
          HelpContext = 88
          Hint = 'Set number of levels for each year'
          OnClick = Levels1Click
        end
        object Blocks1: TMenuItem
          Caption = 'Blocks ...'
          HelpContext = 310
          Hint = 'Set the number of blocks for each year'
          OnClick = Blocks1Click
        end
        object Size1: TMenuItem
          Caption = '&Size ...'
          HelpContext = 231
          Hint = 'Set timetable size'
          OnClick = Size1Click
        end
      end
      object Timetable2: TMenuItem
        Action = MainForm.ShowTimetable
      end
      object Worksheet1: TMenuItem
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Entries1: TMenuItem
        Caption = 'Worksheet E&ntries ...'
        HelpContext = 387
        Hint = 'Enter data onto worksheet'
        ImageIndex = -39
        ShortCut = 16453
        OnClick = Entries1Click
      end
      object Multiples1: TMenuItem
        Caption = '&Multiples...'
        HelpContext = 385
        Hint = 'Multiples required on timetable'
        ImageIndex = 57
        ShortCut = 115
        OnClick = Multiples1Click
      end
      object TargetTimes1: TMenuItem
        Caption = 'Target Times ...'
        HelpContext = 386
        Hint = 'Available time slots'
        ImageIndex = 58
        ShortCut = 116
        OnClick = TargetTimes1Click
      end
      object Build1: TMenuItem
        Caption = '&Build ...'
        HelpContext = 104
        Hint = 'Build the timetable'
        ImageIndex = 59
        ShortCut = 114
        OnClick = Build1Click
      end
      object N6: TMenuItem
        Caption = '-'
        HelpContext = 111
      end
      object BlockClashes1: TMenuItem
        Caption = 'B&lock Clashes'
        HelpContext = 215
        Hint = 'Block Clashes sub-menu'
        object SwapBlocks1: TMenuItem
          Caption = 'Swap Blocks'
          HelpContext = 115
          Hint = 'Swap Blocks to minimise clashes'
          OnClick = SwapBlocks1Click
        end
        object SwapTeachers1: TMenuItem
          Caption = 'Swap Teachers'
          HelpContext = 116
          Hint = 'Swap teachers in split subjects'
          OnClick = SwapTeachers1Click
        end
        object SwapRooms1: TMenuItem
          Caption = 'Swap Rooms'
          HelpContext = 117
          Hint = 'Swap rooms for split subjects'
          OnClick = SwapRooms1Click
        end
      end
      object Clear1: TMenuItem
        Caption = 'Cl&ear worksheet'
        HelpContext = 407
        Hint = 'Clear ALL entries from worksheet'
        OnClick = Clear1Click
      end
      object RollClasses1: TMenuItem
        Caption = 'Roll Classes'
        HelpContext = 304
        Hint = 'Set how Roll classes show on the timetable'
        ImageIndex = -48
        OnClick = RollClasses1Click
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object Alter1: TMenuItem
        Caption = '&Alter worksheet...'
        HelpContext = 389
        Hint = 'Add or remove levels from worksheet'
        ImageIndex = -49
        ShortCut = 117
        OnClick = Alter1Click
      end
    end
  end
end
