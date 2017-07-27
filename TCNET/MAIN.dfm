object MainForm: TMainForm
  Left = 260
  Top = 249
  HelpContext = 391
  Caption = 'Network TimeChart'
  ClientHeight = 478
  ClientWidth = 774
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  FormStyle = fsMDIForm
  KeyPreview = True
  Menu = MainMenu
  OldCreateOrder = True
  PopupMenu = PopupMenu1
  Position = poScreenCenter
  ShowHint = True
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel5: TPanel
    Left = 0
    Top = 0
    Width = 774
    Height = 4
    Align = alTop
    TabOrder = 0
  end
  object Panel4: TPanel
    Tag = 3331
    Left = 0
    Top = 4
    Width = 774
    Height = 13
    HelpContext = 1
    Align = alTop
    AutoSize = True
    BevelInner = bvLowered
    DockSite = True
    TabOrder = 1
    OnDockDrop = Panel4DockDrop
    OnDockOver = Panel4DockOver
  end
  object Panel6: TPanel
    Tag = 3332
    Left = 0
    Top = 450
    Width = 774
    Height = 9
    HelpContext = 1
    Align = alBottom
    AutoSize = True
    BevelInner = bvLowered
    DockSite = True
    TabOrder = 2
    OnDockDrop = Panel6DockDrop
    OnDockOver = Panel6DockOver
  end
  object stbTimeChart: TStatusBar
    Left = 0
    Top = 459
    Width = 774
    Height = 19
    Panels = <
      item
        Text = 'Message'
        Width = 200
      end
      item
        Text = 'No of Students'
        Width = 150
      end
      item
        Text = 'Version'
        Width = 200
      end
      item
        Text = 'User Access Details'
        Width = 150
      end>
  end
  object MainMenu: TMainMenu
    Images = ActionImagesNew
    Left = 279
    Top = 47
    object FileMenu: TMenuItem
      Caption = '&File'
      HelpContext = 2
      Hint = 'The File menu'
      OnClick = FileMenuClick
      object FileOpenItem: TMenuItem
        Bitmap.Data = {
          DE000000424DDE000000000000007600000028000000100000000D0000000100
          0400000000006800000000000000000000001000000010000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00000000000007
          777700333333333077770B033333333307770FB03333333330770BFB03333333
          33070FBFB000000000000BFBFBFBFB0777770FBFBFBFBF0777770BFB00000007
          7777700077777777000777777777777770077777777707770707777777777000
          7777}
        Caption = '&Open timetable...'
        HelpContext = 3
        Hint = 'Open a timetable file'
        ImageIndex = 6
        ShortCut = 16463
        OnClick = FileOpen
      end
      object Save1: TMenuItem
        Action = TtSave
        Bitmap.Data = {
          EE000000424DEE0000000000000076000000280000000F0000000F0000000100
          0400000000007800000000000000000000001000000010000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
          7770700000000000007003300000077030700330000007703070033000000770
          3070033000000000307003333333333330700330000000033070030777777770
          3070030777777770307003077777777030700307777777703070030777777770
          007003077777777070700000000000000070}
        Caption = '&Save timetable'
      end
      object SaveAs: TMenuItem
        Caption = 'Save &As timetable...'
        HelpContext = 6
        Hint = 'Save the timetable as..'
        ShortCut = 16449
        OnClick = SaveAsClick
      end
      object ReverttoSaved1: TMenuItem
        Caption = '&Revert to Saved'
        HelpContext = 7
        Hint = 'Reload timetable'
        OnClick = ReverttoSaved1Click
      end
      object mniFileRemoveTimetable: TMenuItem
        Caption = '&Remove Timetable...'
        Hint = 'Delete a timetable. Use with care.'
        OnClick = DisplayRemoveTimetable
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Close1: TMenuItem
        Caption = '&Close'
        HelpContext = 4
        Hint = 'Close the active window'
        ShortCut = 16499
        OnClick = Close1Click
      end
      object mniFileCloseAll: TMenuItem
        Caption = 'Close A&ll'
        OnClick = CloseAllWindows
      end
      object N8: TMenuItem
        Caption = '-'
      end
      object NewData1: TMenuItem
        Action = NewData
        Bitmap.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000010000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00770000000077
          7777770FFFFFF0777777CC0FFFFFF0777777CF0FFFFFF0777777CF0777777077
          7777CF00000000770000CCCCCCCC77770FF0CCCCCCCC77700000777777777707
          7777777777000077CCCC7777770FF000CCCC777777000077CCCC777777777707
          777777777777777000007777777777770FF07777777777770000}
        Caption = '&New Data...'
      end
      object ExportasTextfile1: TMenuItem
        Caption = 'Export as &Text file...'
        HelpContext = 232
        Hint = 'Output textfile'
        OnClick = ExportasTextfile1Click
      end
      object Transfer3: TMenuItem
        Caption = 'Transfer 1...'
        Visible = False
        OnClick = Transfer3Click
      end
      object mniFileCASES21: TMenuItem
        Caption = 'CASES21 (Maze)'
        Visible = False
        object mniFileCASES21Import: TMenuItem
          Caption = '&Import...'
          OnClick = ImportCASES21Data
        end
        object mniFileCases21Export: TMenuItem
          Caption = '&Export...'
          OnClick = ExportCASES21Data
        end
        object mniFileCASES21ViewExportData: TMenuItem
          Caption = 'View Export Data...'
          OnClick = ViewCASES21ExportData
        end
      end
      object mniFileVASS: TMenuItem
        Caption = '&VASS'
        object mniFileVASSStudentExport: TMenuItem
          Caption = '&Student Export...'
          OnClick = ExportVASSStudent
        end
        object mniFileVASSStudentChoicesExport: TMenuItem
          Caption = 'Student &Choices Export...'
          OnClick = ExportVASSStudentChoices
        end
      end
      object mniFileImportFamilyList: TMenuItem
        Caption = 'Import Family List'
        Visible = False
        OnClick = ImportFamilyList
      end
      object mnuWebTC: TMenuItem
        Caption = 'WebTC'
        object StudentChoices1: TMenuItem
          Caption = 'Student Choices'
          object WebTCSCExport: TMenuItem
            Caption = 'Export'
            OnClick = WebTCSCExportClick
          end
          object Import1: TMenuItem
            Caption = 'Import'
            OnClick = Import1Click
          end
        end
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object Print1: TMenuItem
        Action = MainPrint
        Bitmap.Data = {
          E6000000424DE6000000000000007600000028000000100000000E0000000100
          0400000000007000000000000000000000001000000010000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00770000000000
          0777707777777770707700000000000007070777777BBB770007077777788877
          0707000000000000077007777777777070707000000000070700770FFFFFFFF0
          70707770F00000F000077770FFFFFFFF077777770F00000F077777770FFFFFFF
          F0777777700000000077}
        Caption = '&Print...'
      end
      object PrintSetup1: TMenuItem
        Action = FilePrintSetup2
        ImageIndex = -2
      end
      object PrintPreview1: TMenuItem
        Action = DoPrintPreview
        Caption = 'P&rint Preview...'
        Hint = 'Print preview for top window'
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object mniFileBackupRestoreData: TMenuItem
        Caption = 'Backup / Restore Data'
        object CreateBackup1: TMenuItem
          Caption = 'Backup...'
          HelpContext = 219
          Hint = 'This could come in handy ...'
          OnClick = CreateBackup1Click
        end
        object RestorefromBackup1: TMenuItem
          Caption = 'Restore from Backup...'
          HelpContext = 235
          Hint = 'Lucky we made a backup ...'
          OnClick = RestorefromBackup1Click
        end
      end
      object N18: TMenuItem
        Caption = '-'
      end
      object FileExitItem: TMenuItem
        Caption = 'E&xit'
        HelpContext = 11
        Hint = 'Exit Time Chart'
        ShortCut = 32883
        OnClick = FileExit
      end
    end
    object Edit1: TMenuItem
      Caption = '&Edit'
      GroupIndex = 50
      HelpContext = 236
      Hint = 'The Edit menu'
      object Copy1: TMenuItem
        Action = CopyWin
        Hint = 'Copy to window to clipboard'
      end
    end
    object Display: TMenuItem
      Caption = '&Display'
      GroupIndex = 100
      HelpContext = 12
      Hint = 'The Display Menu'
      OnClick = DisplayClick
      object Font1: TMenuItem
        Action = SetFont
        Bitmap.Data = {
          E6000000424DE60000000000000076000000280000000B0000000E0000000100
          0400000000007000000000000000000000001000000010000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777770
          0000777778187770000077777717777000007777771787700000777777111770
          0000777777178770000075787717787000007857771111700000775777777770
          0000775777777770000075557777777000007757777777700000775877777770
          00007775577777700000}
        Caption = '&Font...'
      end
      object Preferences1: TMenuItem
        Action = Prefs
        Bitmap.Data = {
          36010000424D3601000000000000760000002800000012000000100000000100
          040000000000C000000000000000000000001000000010000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00700000000000
          0000070000000BFBFBFBFBFBFBFBF00000000FBF0FBFBFB0BFB0B00000000BF0
          00FBFBFB0B0BF00000000F00B00FBFBFB0BFB00000000BFBFB00FBFB0B0BF000
          00000FBFBFB00FB0BFB0B00000000BFB0BFBFBFBFBFBF00000000FB000BFBFBF
          BFBFB00000000B00F00BFBFBFBFBF00000000FBFBF00BFBFBFBFB00000000BFB
          FBF00BFBFBFBF00000000FBFBFBFBFBFBFBFB00000000000000BFBFBFBFBF000
          00000FBFBFB00000000007000000700000077777777777000000}
        Caption = '&Preferences...'
      end
      object Margins1: TMenuItem
        Caption = '&Margins...'
        HelpContext = 18
        Hint = 'Set Margins and Date stamp'
        ShortCut = 16461
        OnClick = Margins1Click
      end
      object Custom1: TMenuItem
        Caption = '&Custom'
        HelpContext = 38
        Hint = 'The Custom sub-menu'
        OnClick = Custom1Click
        object Clear1: TMenuItem
          Caption = '&Clear'
          HelpContext = 20
          Hint = 'Clear Custom Information'
          OnClick = Clear1Click
        end
        object New1: TMenuItem
          Caption = '&New...'
          HelpContext = 21
          Hint = 'New Custom Information'
          OnClick = New1Click
        end
        object opencustomfile1: TMenuItem
          Caption = '&Open...'
          HelpContext = 22
          Hint = 'Open Custom File'
          OnClick = opencustomfile1Click
        end
        object Editcustomfile1: TMenuItem
          Caption = '&Edit...'
          HelpContext = 23
          Hint = 'Edit Custom Information'
          ShortCut = 49217
          OnClick = Editcustomfile1Click
        end
        object Savecustomfile1: TMenuItem
          Caption = '&Save...'
          HelpContext = 24
          Hint = 'Save Custom File'
          OnClick = Savecustomfile1Click
        end
      end
      object N19: TMenuItem
        Caption = '-'
      end
      object OpenDisplay1: TMenuItem
        Caption = 'Open Display...'
        HelpContext = 366
        Hint = 'Open display file'
        OnClick = OpenDisplay1Click
      end
      object SaveDisplay1: TMenuItem
        Caption = 'Save Display...'
        HelpContext = 365
        Hint = 'Save display file'
        OnClick = SaveDisplay1Click
      end
      object N13: TMenuItem
        Caption = '-'
      end
      object Toolbars1: TMenuItem
        Caption = 'Toolbars '
        HelpContext = 242
        Hint = 'Toolbars sub-menu'
        OnClick = Toolbars1Click
        object General1: TMenuItem
          Caption = 'General'
          HelpContext = 243
          Hint = 'General Toolbar'
          ShortCut = 16433
          OnClick = General1Click
        end
        object Timetable4: TMenuItem
          Caption = 'Timetable'
          HelpContext = 265
          Hint = 'Timetable Toolbar'
          ShortCut = 16434
          Visible = False
          OnClick = Timetable4Click
        end
        object Blocking1: TMenuItem
          Caption = 'Blocking'
          HelpContext = 286
          Hint = 'Blocking Toolbar'
          ShortCut = 16435
          OnClick = Blocking1Click
        end
        object Worksheet2: TMenuItem
          Caption = 'Worksheet'
          HelpContext = 378
          ShortCut = 16436
          OnClick = Worksheet2Click
        end
      end
      object N14: TMenuItem
        Caption = '-'
        GroupIndex = 5
      end
      object Selection1: TMenuItem
        Action = SelectDlg
        Caption = '&Selection...'
        GroupIndex = 5
      end
      object NextView1: TMenuItem
        Action = NextView
        GroupIndex = 5
        ImageIndex = -10
      end
    end
    object User1: TMenuItem
      Caption = 'User'
      GroupIndex = 100
      HelpContext = 39
      Hint = 'The User Menu'
      OnClick = User1Click
      object Info2: TMenuItem
        Caption = '&Info...'
        HelpContext = 40
        Hint = 'Info on current access'
        OnClick = Info2Click
      end
      object Changepassword1: TMenuItem
        Caption = 'Change &password...'
        HelpContext = 35
        Hint = 'Change your password'
        OnClick = Changepassword1Click
      end
      object Logonasadifferentuser1: TMenuItem
        Caption = '&Log on as a different user...'
        HelpContext = 41
        Hint = 'Change access level'
        OnClick = Logonasadifferentuser1Click
      end
      object N22: TMenuItem
        Caption = '-'
      end
      object Showusers1: TMenuItem
        Caption = '&Show users'
        HelpContext = 42
        Hint = 'Show network users'
        OnClick = Showusers1Click
      end
      object Adduser1: TMenuItem
        Caption = '&Add user...'
        HelpContext = 329
        Hint = 'Add a new user'
        OnClick = Adduser1Click
      end
      object Edituser1: TMenuItem
        Caption = '&Edit user...'
        HelpContext = 36
        Hint = 'Change an existing user'
        OnClick = Edituser1Click
      end
      object Deleteuser1: TMenuItem
        Caption = 'Delete &user...'
        HelpContext = 33
        Hint = 'Delete a user'
        OnClick = Deleteuser1Click
      end
      object N23: TMenuItem
        Caption = '-'
      end
      object Autoloadtime1: TMenuItem
        Caption = '&Autoload time...'
        HelpContext = 32
        Hint = 'Set autoload time'
        OnClick = Autoloadtime1Click
      end
      object mniUserClearUserAccessLocks: TMenuItem
        Caption = 'Clear User Access Locks'
        OnClick = ClearUserAccessLocks
      end
      object Savedefaultdisplaysettings1: TMenuItem
        Caption = 'Save default &display settings'
        HelpContext = 102
        Hint = 'Save display settings for general access'
        OnClick = Savedefaultdisplaysettings1Click
      end
      object Setcurrentdatadirectoryasdefault1: TMenuItem
        Caption = 'Set &current data directory as default'
        HelpContext = 155
        Hint = 'Set data directory for general access'
        OnClick = Setcurrentdatadirectoryasdefault1Click
      end
    end
    object Find1: TMenuItem
      Caption = 'F&ind'
      GroupIndex = 110
      HelpContext = 25
      Hint = 'The Find Menu'
      object Student2: TMenuItem
        Caption = '&Student...'
        HelpContext = 26
        Hint = 'Find a student'
        ShortCut = 32817
        OnClick = Student2Click
      end
      object Teacher3: TMenuItem
        Caption = '&Teacher...'
        HelpContext = 27
        Hint = 'Find a teacher'
        ShortCut = 32818
        OnClick = Teacher3Click
      end
      object Room3: TMenuItem
        Caption = '&Room...'
        HelpContext = 28
        Hint = 'Find a room'
        ShortCut = 32819
        OnClick = Room3Click
      end
    end
    object Student1: TMenuItem
      Caption = '&Student'
      GroupIndex = 120
      HelpContext = 29
      Hint = 'The Student Menu'
      OnClick = Student1Click
      object Reloadstudentdata1: TMenuItem
        Caption = 'Reload student data'
        HelpContext = 30
        Hint = 'Revert data in memory to that last saved'
        OnClick = Reloadstudentdata1Click
      end
      object N9: TMenuItem
        Caption = '-'
      end
      object YearSubjects2: TMenuItem
        Caption = 'Group &Subjects'
        HelpContext = 52
        Hint = 'Open Group Subjects window'
        ShortCut = 49241
        OnClick = YearSubjects1Click
      end
      object Blocks2: TMenuItem
        Action = ShowBlocksWin
      end
      object N10: TMenuItem
        Caption = '-'
      end
      object Group1: TMenuItem
        Caption = '&Group'
        HelpContext = 408
        Hint = 'The Group sub-menu'
        object Select2: TMenuItem
          Caption = 'Select...'
          HelpContext = 34
          ImageIndex = 42
          OnClick = Select2Click
        end
        object Sort1: TMenuItem
          Caption = 'Sort...'
          HelpContext = 43
          OnClick = Sort1Click
        end
        object N16: TMenuItem
          Caption = '-'
        end
        object grp02: TMenuItem
          Tag = 1
          Caption = 'grp0'
          HelpContext = 406
          OnClick = grp02Click
        end
        object grp12: TMenuItem
          Tag = 2
          Caption = 'grp1'
          HelpContext = 406
          OnClick = grp02Click
        end
        object grp22: TMenuItem
          Tag = 3
          Caption = 'grp2'
          HelpContext = 406
          OnClick = grp02Click
        end
        object grp32: TMenuItem
          Tag = 4
          Caption = 'grp3'
          HelpContext = 406
          OnClick = grp02Click
        end
        object grp42: TMenuItem
          Tag = 5
          Caption = 'grp4'
          HelpContext = 406
          OnClick = grp02Click
        end
        object grp52: TMenuItem
          Tag = 6
          Caption = 'grp5'
          HelpContext = 406
          OnClick = grp02Click
        end
        object grp62: TMenuItem
          Tag = 7
          Caption = 'grp6'
          HelpContext = 406
          OnClick = grp02Click
        end
        object grp72: TMenuItem
          Tag = 8
          Caption = 'grp7'
          HelpContext = 406
          OnClick = grp02Click
        end
        object grp82: TMenuItem
          Tag = 9
          Caption = 'grp8'
          HelpContext = 406
          OnClick = grp02Click
        end
        object grp92: TMenuItem
          Tag = 10
          Caption = 'grp9'
          HelpContext = 406
          OnClick = grp02Click
        end
        object grp102: TMenuItem
          Tag = 11
          Caption = 'grp10'
          HelpContext = 406
          OnClick = grp02Click
        end
        object grp112: TMenuItem
          Tag = 12
          Caption = 'grp11'
          HelpContext = 406
          OnClick = grp02Click
        end
        object grp122: TMenuItem
          Tag = 13
          Caption = 'grp12'
          HelpContext = 406
          OnClick = grp02Click
        end
        object grp132: TMenuItem
          Tag = 14
          Caption = 'grp13'
          HelpContext = 406
          OnClick = grp02Click
        end
        object grp142: TMenuItem
          Tag = 15
          Caption = 'grp14'
          HelpContext = 406
          OnClick = grp02Click
        end
        object grp152: TMenuItem
          Tag = 16
          Caption = 'grp15'
          HelpContext = 406
          OnClick = grp02Click
        end
        object grp162: TMenuItem
          Caption = 'grp16'
          OnClick = grp02Click
        end
        object grp172: TMenuItem
          Caption = 'grp17'
          OnClick = grp02Click
        end
        object grp182: TMenuItem
          Caption = 'grp18'
          OnClick = grp02Click
        end
        object grp192: TMenuItem
          Caption = 'grp19'
          OnClick = grp02Click
        end
      end
      object StudentInput2: TMenuItem
        Caption = '&Student Input'
        HelpContext = 169
        Hint = 'Student Input window'
        ShortCut = 49222
        OnClick = DisplayStudentInput
      end
      object AddStudent1: TMenuItem
        Caption = '&Add Student...'
        HelpContext = 44
        Hint = 'Add a new student'
        ShortCut = 16457
        OnClick = AddStudent1Click
      end
      object ChangeStudent1: TMenuItem
        Caption = '&Change Student...'
        HelpContext = 47
        Hint = 'Change a student'#39's data'
        ShortCut = 16458
        OnClick = ChangeStudent1Click
      end
      object DeleteStudent1: TMenuItem
        Caption = '&Delete Student...'
        HelpContext = 48
        Hint = 'Delete a student'
        OnClick = DeleteStudent1Click
      end
      object CommonData1: TMenuItem
        Caption = 'C&ommon Data...'
        HelpContext = 49
        Hint = 'Add common data to students'
        OnClick = CommonData1Click
      end
      object ListTagNames1: TMenuItem
        Caption = 'Student Tag'
        OnClick = ListTagNames1Click
      end
      object ClearChoices1: TMenuItem
        Caption = 'Cl&ear Choices'
        HelpContext = 50
        Hint = 'Clear students'#39' subject choices'
        OnClick = ClearChoices1Click
      end
      object N11: TMenuItem
        Caption = '-'
      end
      object Promote1: TMenuItem
        Caption = '&Promote...'
        HelpContext = 51
        Hint = 'Promote students to the next year'
        OnClick = Promote1Click
      end
      object mniStudentN2: TMenuItem
        Caption = '-'
      end
      object mniStudentHealth: TMenuItem
        Caption = '&Health...'
        Hint = 'Student Welfare'
        OnClick = DisplayHealthConditions
      end
      object mniStudentN3: TMenuItem
        Caption = '-'
      end
      object Textfilein1: TMenuItem
        Caption = 'Import Text file...'
        HelpContext = 305
        Hint = 'Import student data from text file'
        OnClick = Textfilein1Click
      end
      object TransferStud: TMenuItem
        Caption = 'Transfer...'
        HelpContext = 353
        Hint = 'Transfer student data to text file'
        OnClick = TransferStudClick
      end
      object Transfer1: TMenuItem
        Caption = 'Transfer 1...'
        Visible = False
        OnClick = Transfer1Click
      end
      object Transfer2: TMenuItem
        Caption = 'Transfer 2...'
        Visible = False
        OnClick = Transfer2Click
      end
      object CustomA1: TMenuItem
        Caption = 'Custom A'
        Visible = False
        OnClick = CustomA1Click
      end
      object mnuTrackEnrolments1: TMenuItem
        Caption = 'Track Enrolments ...'
        OnClick = mnuTrackEnrolments1Click
      end
    end
    object Timetable2: TMenuItem
      Caption = '&Timetable'
      GroupIndex = 130
      HelpContext = 81
      Hint = 'The Timetable Menu'
      OnClick = Timetable2Click
      object InUse2: TMenuItem
        Caption = '& In Use...'
        HelpContext = 364
        Hint = 'Set timetable currently in use'
        OnClick = InUse2Click
      end
      object Configure1: TMenuItem
        Caption = '&Configure'
        HelpContext = 83
        Hint = 'The Configure sub-menu'
        object Version1: TMenuItem
          Caption = '&Version...'
          HelpContext = 84
          Hint = 'Set timetable version'
          OnClick = Version1Click
        end
        object Years1: TMenuItem
          Caption = '&Years...'
          HelpContext = 85
          Hint = 'Set and name years'
          OnClick = Years1Click
        end
        object Days1: TMenuItem
          Caption = '&Days...'
          HelpContext = 86
          Hint = 'Set and name days'
          OnClick = Days1Click
        end
        object TimeSlots1: TMenuItem
          Caption = '&Time Slots...'
          HelpContext = 87
          Hint = 'Set and name time slots'
          OnClick = TimeSlots1Click
        end
        object Levels1: TMenuItem
          Caption = '&Levels...'
          HelpContext = 88
          Hint = 'Set the number of levels for each year'
          OnClick = Levels1Click
        end
        object Blocks3: TMenuItem
          Caption = '&Blocks...'
          HelpContext = 310
          Hint = 'Set the number of blocks for each year'
          OnClick = Blocks3Click
        end
        object Size1: TMenuItem
          Caption = '&Size...'
          HelpContext = 231
          Hint = 'Set timetable size'
          Visible = False
          OnClick = Size1Click
        end
      end
      object Timetable3: TMenuItem
        Action = ShowTimetable
      end
      object Worksheet1: TMenuItem
        Action = ShowWorksheet
      end
    end
    object WindowMenu: TMenuItem
      Caption = '&Window'
      GroupIndex = 150
      HelpContext = 126
      Hint = 'The Window menu'
      OnClick = WindowMenuClick
      object Info1: TMenuItem
        Action = ShowInfoWin
      end
      object Codes1: TMenuItem
        Caption = 'Co&des'
        HelpContext = 126
        Hint = 'The Codes sub-menu'
        object House1: TMenuItem
          Action = OpenHouseWnd
          ShortCut = 49201
        end
        object Subject2: TMenuItem
          Action = OpenSuWnd
          Hint = 'Subject Codes window'
          ShortCut = 49202
        end
        object Faculty1: TMenuItem
          Action = OpenFacWnd
          ShortCut = 49203
        end
        object Teacher2: TMenuItem
          Action = OpenTeWnd
          Hint = 'Teacher Codes Window'
          ShortCut = 49204
        end
        object Room2: TMenuItem
          Action = OpenRoWnd
          ShortCut = 49205
        end
        object Class1: TMenuItem
          Action = OpenRollWnd
          Hint = 'Roll class codes window'
          ShortCut = 49206
        end
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object YearSubjects1: TMenuItem
        Caption = '&Group Subjects'
        HelpContext = 52
        Hint = 'Year subjects window'
        ShortCut = 49241
        OnClick = YearSubjects1Click
      end
      object Blocks1: TMenuItem
        Action = ShowBlocksWin
      end
      object SubjectList1: TMenuItem
        Caption = 'Sub&ject List'
        HelpContext = 126
        Hint = 'Subject list sub-menu'
        object BySubject1: TMenuItem
          Action = ShowSubjectList
        end
        object ByTimeslot1: TMenuItem
          Caption = 'By &Time slot'
          HelpContext = 161
          Hint = 'Subject list by time slot'
          ShortCut = 49221
          OnClick = ByTimeslot1Click
        end
      end
      object StudentList1: TMenuItem
        Action = ShowStudList
      end
      object TeacherList1: TMenuItem
        Caption = 'Te&acher List'
        HelpContext = 351
        Hint = 'Teacher Subject List window'
        ShortCut = 49224
        OnClick = TeacherList1Click
      end
      object BlockInfo1: TMenuItem
        Caption = 'Bl&ock Info'
        HelpContext = 126
        Hint = 'Block info sub-menu'
        object StudentClashes1: TMenuItem
          Caption = 'Student &Clashes'
          HelpContext = 349
          Hint = 'Student Clashes window'
          ShortCut = 49240
          OnClick = StudentClashes1Click
        end
        object StudFree1: TMenuItem
          Caption = 'Students &Free'
          HelpContext = 350
          Hint = 'Students Free in Blocks window'
          ShortCut = 49242
          OnClick = StudFree1Click
        end
        object StudentInput1: TMenuItem
          Caption = '&Student Input'
          HelpContext = 169
          Hint = 'Student Input window'
          ShortCut = 49222
          OnClick = DisplayStudentInput
        end
        object ClashMatrix1: TMenuItem
          Caption = 'Clash &Matrix'
          HelpContext = 166
          Hint = 'Clash Matrix window'
          ShortCut = 49229
          OnClick = ClashMatrix1Click
        end
      end
      object StudentTimetable1: TMenuItem
        Action = ShowStudTt
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object Timetable1: TMenuItem
        Action = ShowTimetable
      end
      object Worksheet3: TMenuItem
        Action = ShowWorksheet
      end
      object ClashHelp1: TMenuItem
        Caption = 'Clash &Help'
        HelpContext = 175
        Hint = 'Timetable Clash Help window'
        ShortCut = 49219
        OnClick = ClashHelp1Click
      end
      object TimetableInfo1: TMenuItem
        Caption = 'Ti&metable Info'
        HelpContext = 126
        Hint = 'Timetable info sub-menu'
        object BlockClashes1: TMenuItem
          Caption = '&Block Clashes'
          HelpContext = 178
          Hint = 'Block Clashes window'
          ImageIndex = 36
          ShortCut = 49218
          OnClick = BlockClashes1Click
        end
        object TeacherClashes1: TMenuItem
          Caption = '&Teacher Clashes'
          HelpContext = 179
          Hint = 'Teacher clashes window'
          ShortCut = 49226
          OnClick = TeacherClashes1Click
        end
        object RoomClashes1: TMenuItem
          Caption = '&Room Clashes'
          HelpContext = 181
          Hint = 'Room clashes window'
          ShortCut = 49227
          OnClick = RoomClashes1Click
        end
        object TeacherFree1: TMenuItem
          Caption = 'Teachers &Free'
          HelpContext = 184
          Hint = 'Teachers free window'
          ImageIndex = 29
          ShortCut = 49230
          OnClick = TeacherFree1Click
        end
        object RoomsFree1: TMenuItem
          Caption = 'R&ooms Free'
          HelpContext = 186
          Hint = 'Rooms free window'
          ImageIndex = 31
          ShortCut = 49231
          OnClick = RoomsFree1Click
        end
        object TeacherTimes1: TMenuItem
          Caption = 'T&eacher Loads'
          HelpContext = 188
          Hint = 'Teacher Loads window'
          ImageIndex = 34
          ShortCut = 49238
          OnClick = TeacherTimes1Click
        end
        object SubjectTimes1: TMenuItem
          Caption = '&Subject Times'
          HelpContext = 189
          Hint = 'Subject Time window'
          ShortCut = 49233
          OnClick = SubjectTimes1Click
        end
        object GroupofTeachers1: TMenuItem
          Caption = '&Group of Teachers'
          HelpContext = 191
          Hint = 'Group of Teachers window'
          ShortCut = 49223
          OnClick = GroupofTeachers1Click
        end
      end
      object Teacher1: TMenuItem
        Action = ShowTeachTt
      end
      object Room1: TMenuItem
        Action = ShowRoomTt
        ImageIndex = -15
      end
      object Subject1: TMenuItem
        Action = ShowSubTt
        ImageIndex = -17
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object WindowTileItem: TMenuItem
        Caption = 'Tile Hori&zontal'
        HelpContext = 199
        Hint = 'Tile all windows'
        OnClick = WindowTile
      end
      object TileVertical1: TMenuItem
        Caption = 'Tile &Vertical'
        HelpContext = 199
        Hint = 'Tile all windows'
        OnClick = TileVertical1Click
      end
      object WindowCascadeItem: TMenuItem
        Action = CascadeWins
        ImageIndex = -22
      end
      object WindowArrangeItem: TMenuItem
        Caption = '&Arrange All'
        HelpContext = 199
        Hint = 'Arrange minimized windows'
        OnClick = WindowArrange
      end
    end
    object DataExport1: TMenuItem
      Caption = 'Data Export'
      GroupIndex = 150
      object ASSExport1: TMenuItem
        Caption = 'TASS Export'
        OnClick = TASSExport1Click
      end
      object SynergeticExport1: TMenuItem
        Caption = 'Synergetic Export'
        OnClick = SynergeticExport1Click
      end
    end
    object MnuTools: TMenuItem
      Caption = 'Tools'
      GroupIndex = 150
      Visible = False
      object mniToolsImportSubjects: TMenuItem
        Caption = 'Import &Subjects'
        OnClick = ImportSubjects
      end
    end
    object HelpMenu: TMenuItem
      Caption = '&Help'
      GroupIndex = 200
      HelpContext = 209
      Hint = 'The Help Menu'
      object HelpContentsItem: TMenuItem
        Bitmap.Data = {
          EE000000424DEE000000000000007600000028000000100000000F0000000100
          0400000000007800000000000000000000001000000010000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777700077
          777777777005580777777770055FF780777770055FF007780777855FF0055077
          807785F00555550778078005553B55507780855555535555070775F55555BB55
          5007775F555553BB55077775F55535BB555077775F55BBB55500777775F55555
          00777777775F550077777777777550777777}
        Caption = '&Contents'
        HelpContext = 209
        Hint = 'Display the help contents screen'
        OnClick = HelpContents
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object CheckforUpdates1: TMenuItem
        Caption = 'Check for Updates'
        OnClick = CheckForUpdates
      end
      object Hintsandtips1: TMenuItem
        Caption = 'Hints and tips...'
        HelpContext = 209
        Hint = 'I didn'#39't know that ...'
        OnClick = Hintsandtips1Click
      end
      object GoSurfing1: TMenuItem
        Caption = 'AMIG &Website'
        HelpContext = 209
        Hint = 'Go surfing at www.amig.com.au'
        OnClick = GoSurfing1Click
      end
      object mniHelpSystem: TMenuItem
        Caption = 'System'
        object mniHElpSysytemPackUpData: TMenuItem
          Caption = 'Archive Data'
          OnClick = ArchiveData
        end
      end
      object N17: TMenuItem
        Caption = '-'
      end
      object HelpAboutItem: TMenuItem
        Bitmap.Data = {
          F6000000424DF60000000000000076000000280000000E000000100000000100
          0400000000008000000000000000000000001000000010000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777707
          77007777777770077700778888880B08770070000000FF0087000FFFBFBFBFFF
          08000FBFFF44FFBF08000FFFBFFFBFFF08000FBFFF48FFBF08000FFFBF847FFF
          08000FBFFFB848BF08000FFF48FF44FF08000FBF44B744BF08000FFF744447FF
          08000FBFFFBFFFBF08000FFFBFFFBFFF07007000000000007700}
        Caption = '&About...'
        HelpContext = 209
        Hint = 'About Time Chart..'
        OnClick = HelpAbout
      end
    end
  end
  object OpenDialog: TOpenDialog
    HelpContext = 3
    Filter = 'Timetable|*.tt'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofFileMustExist]
    Title = 'Load Timetable'
    Left = 336
    Top = 75
  end
  object SaveDialog: TSaveDialog
    HelpContext = 5
    Filter = 'Timetable|*.tt'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist]
    Title = 'Save Timetable'
    Left = 364
    Top = 75
  end
  object PrintSetupDialog: TPrinterSetupDialog
    HelpContext = 10
    Left = 280
    Top = 76
  end
  object FontDialog1: TFontDialog
    HelpContext = 13
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = []
    Left = 393
    Top = 75
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 307
    Top = 47
    object LoadYear3: TMenuItem
      Caption = 'Reload student data'
      HelpContext = 30
      Hint = 'Revert data in memory to that last saved'
      OnClick = Reloadstudentdata1Click
    end
    object LoadYear2: TMenuItem
      Caption = '-'
      ShortCut = 16473
    end
    object All22: TMenuItem
      Caption = 'Select group ...'
      HelpContext = 33
      Hint = 'Define custom group'
      OnClick = All22Click
    end
    object N15: TMenuItem
      Caption = '-'
      OnClick = AddStudent1Click
    end
    object grp01: TMenuItem
      Tag = 1
      Caption = 'grp0'
      OnClick = grp02Click
    end
    object grp11: TMenuItem
      Tag = 2
      Caption = 'grp1'
      OnClick = grp02Click
    end
    object grp21: TMenuItem
      Tag = 3
      Caption = 'grp2'
      OnClick = grp02Click
    end
    object grp31: TMenuItem
      Tag = 4
      Caption = 'grp3'
      OnClick = grp02Click
    end
    object grp41: TMenuItem
      Tag = 5
      Caption = 'grp4'
      OnClick = grp02Click
    end
    object grp51: TMenuItem
      Tag = 6
      Caption = 'grp5'
      OnClick = grp02Click
    end
    object grp61: TMenuItem
      Tag = 7
      Caption = 'grp6'
      OnClick = grp02Click
    end
    object grp71: TMenuItem
      Tag = 8
      Caption = 'grp7'
      OnClick = grp02Click
    end
    object grp81: TMenuItem
      Tag = 9
      Caption = 'grp8'
      OnClick = grp02Click
    end
    object grp91: TMenuItem
      Tag = 10
      Caption = 'grp9'
      OnClick = grp02Click
    end
    object grp101: TMenuItem
      Tag = 11
      Caption = 'grp10'
      OnClick = grp02Click
    end
    object grp111: TMenuItem
      Tag = 12
      Caption = 'grp11'
      OnClick = grp02Click
    end
    object grp121: TMenuItem
      Tag = 13
      Caption = 'grp12'
      OnClick = grp02Click
    end
    object grp131: TMenuItem
      Tag = 14
      Caption = 'grp13'
      OnClick = grp02Click
    end
    object grp141: TMenuItem
      Tag = 15
      Caption = 'grp14'
      OnClick = grp02Click
    end
    object grp151: TMenuItem
      Tag = 16
      Caption = 'grp15'
      OnClick = grp02Click
    end
    object grp161: TMenuItem
      Tag = 17
      Caption = 'grp16'
      OnClick = grp02Click
    end
    object grp171: TMenuItem
      Tag = 18
      Caption = 'grp17'
      OnClick = grp02Click
    end
    object grp181: TMenuItem
      Tag = 19
      Caption = 'grp18'
      OnClick = grp02Click
    end
    object grp191: TMenuItem
      Tag = 20
      Caption = 'grp19'
      OnClick = grp02Click
    end
  end
  object PrintDialog: TPrintDialog
    HelpContext = 9
    Left = 308
    Top = 75
  end
  object ActionManager1: TActionManager
    Images = ActionImages
    Left = 393
    Top = 47
    StyleName = 'XP Style'
    object FilePrintSetup1: TFilePrintSetup
      Category = 'File'
      Caption = 'Print Set&up...'
      Dialog.OnClose = FilePrintSetup1PrinterSetupDialogClose
      HelpContext = 10
      Hint = 'Print Setup'
      ImageIndex = 2
    end
    object DoPrintPreview: TAction
      Category = 'File'
      Caption = 'P&rint Preview ...'
      HelpContext = 348
      HelpType = htContext
      Hint = 'Print Preview for top window'
      ImageIndex = 0
      ShortCut = 16465
      OnExecute = DoPrintPreviewExecute
      OnUpdate = DoPrintPreviewUpdate
    end
    object MainPrint: TAction
      Category = 'File'
      Caption = '&Print ...'
      HelpContext = 9
      HelpType = htContext
      Hint = 'Print top window'
      ImageIndex = 1
      ShortCut = 16464
      OnExecute = MainPrintExecute
      OnUpdate = MainPrintUpdate
    end
    object CopyWin: TAction
      Category = 'Edit'
      Caption = '&Copy'
      HelpContext = 238
      HelpType = htContext
      Hint = 'Copy top window to clipboard'
      ImageIndex = 4
      ShortCut = 16451
      OnExecute = CopyWinExecute
      OnUpdate = CopyWinUpdate
    end
    object OpenSuWnd: TAction
      Category = 'Codes'
      Caption = '&Subject'
      HelpContext = 129
      HelpType = htContext
      Hint = 'Subject codes window'
      ShortCut = 49201
      OnExecute = OpenSuWndExecute
    end
    object OpenTeWnd: TAction
      Category = 'Codes'
      Caption = '&Teacher'
      HelpContext = 136
      HelpType = htContext
      Hint = 'Teacher codes window'
      ShortCut = 49202
      OnExecute = OpenTeWndExecute
    end
    object OpenRoWnd: TAction
      Category = 'Codes'
      Caption = '&Room'
      HelpContext = 143
      HelpType = htContext
      Hint = 'Room codes window'
      ShortCut = 49203
      OnExecute = OpenRoWndExecute
    end
    object OpenRollWnd: TAction
      Category = 'Codes'
      Caption = 'Roll &Class'
      HelpContext = 149
      HelpType = htContext
      Hint = 'Roll Class codes window'
      ShortCut = 49204
      OnExecute = OpenRollWndExecute
    end
    object OpenFacWnd: TAction
      Category = 'Codes'
      Caption = '&Faculty'
      HelpContext = 152
      HelpType = htContext
      Hint = 'Faculties window'
      ShortCut = 49205
      OnExecute = OpenFacWndExecute
    end
    object OpenHouseWnd: TAction
      Category = 'Codes'
      Caption = '&House'
      HelpContext = 154
      HelpType = htContext
      Hint = 'Houses window'
      ShortCut = 49206
      OnExecute = OpenHouseWndExecute
    end
    object OpenTimesWnd: TAction
      Category = 'Codes'
      Caption = 'T&imes'
      HelpContext = 156
      HelpType = htContext
      Hint = 'Time Allotments window'
      ShortCut = 49207
      OnExecute = OpenTimesWndExecute
    end
    object SetFont: TAction
      Category = 'Display'
      Caption = '&Font ...'
      HelpContext = 13
      HelpType = htContext
      Hint = 'Select a Font Style and Size'
      ImageIndex = 7
      ShortCut = 16454
      OnExecute = SetFontExecute
    end
    object Prefs: TAction
      Category = 'Display'
      Caption = '&Preferences ...'
      HelpContext = 14
      HelpType = htContext
      Hint = 'Set preferences'
      ImageIndex = 8
      ShortCut = 49232
      OnExecute = PrefsExecute
    end
    object NextView: TAction
      Category = 'Display'
      Caption = 'Next &View'
      HelpContext = 244
      HelpType = htContext
      Hint = 'Show next view for top window'
      ImageIndex = 10
      OnExecute = NextViewExecute
      OnUpdate = NextViewUpdate
    end
    object SelectDlg: TAction
      Category = 'Display'
      Caption = '&Selection ...'
      HelpContext = 319
      HelpType = htContext
      Hint = 'Selection Dialogue for top window'
      ImageIndex = 9
      ShortCut = 16471
      OnExecute = SelectDlgExecute
    end
    object NewData: TAction
      Category = 'File'
      Caption = '&New Data ...'
      HelpContext = 8
      HelpType = htContext
      Hint = 'Load all new data'
      ImageIndex = 3
      ShortCut = 16462
      OnExecute = NewDataExecute
    end
    object TtSave: TAction
      Category = 'File'
      Caption = '&Save'
      HelpContext = 5
      HelpType = htContext
      Hint = 'Save the timetable'
      ImageIndex = 26
      ShortCut = 16467
      OnExecute = TtSaveExecute
    end
    object ShowInfoWin: TAction
      Category = 'Window'
      Caption = '&Info'
      HelpContext = 127
      HelpType = htContext
      Hint = 'Information window'
      ImageIndex = 25
      ShortCut = 49225
      OnExecute = ShowInfoWinExecute
    end
    object ShowBlocksWin: TAction
      Category = 'Window'
      Caption = '&Blocks'
      HelpContext = 157
      HelpType = htContext
      Hint = 'Blocks window'
      ImageIndex = 27
      ShortCut = 16450
      OnExecute = ShowBlocksWinExecute
    end
    object ShowSubjectList: TAction
      Category = 'Window'
      Caption = 'By &Subject'
      HelpContext = 160
      HelpType = htContext
      Hint = 'Subject list'
      ImageIndex = 24
      ShortCut = 49220
      OnExecute = ShowSubjectListExecute
    end
    object ShowStudList: TAction
      Category = 'Window'
      Caption = 'Student &List'
      HelpContext = 163
      HelpType = htContext
      Hint = 'Student list window'
      ImageIndex = 11
      ShortCut = 49228
      OnExecute = ShowStudListExecute
    end
    object ShowTimetable: TAction
      Category = 'Window'
      Caption = '&Timetable'
      HelpContext = 90
      HelpType = htContext
      Hint = 'Main timetable window'
      ImageIndex = 13
      ShortCut = 16468
      OnExecute = ShowTimetableExecute
    end
    object ShowStudTt: TAction
      Category = 'Window'
      Caption = '&Student Timetable'
      HelpContext = 171
      HelpType = htContext
      Hint = 'Student timetable window'
      ImageIndex = 14
      ShortCut = 49235
      OnExecute = ShowStudTtExecute
    end
    object ShowTeachTt: TAction
      Category = 'Window'
      Caption = 'T&eacher'
      HelpContext = 194
      HelpType = htContext
      Hint = 'Teacher timetable window'
      ImageIndex = 16
      ShortCut = 49236
      OnExecute = ShowTeachTtExecute
    end
    object ShowRoomTt: TAction
      Category = 'Window'
      Caption = '&Room'
      HelpContext = 196
      HelpType = htContext
      Hint = 'Room timetable window'
      ImageIndex = 15
      ShortCut = 49234
      OnExecute = ShowRoomTtExecute
    end
    object ShowSubTt: TAction
      Category = 'Window'
      Caption = 'S&ubject'
      HelpContext = 198
      HelpType = htContext
      Hint = 'Subject timetable window'
      ImageIndex = 17
      ShortCut = 49237
      OnExecute = ShowSubTtExecute
    end
    object CascadeWins: TAction
      Category = 'Window'
      Caption = '&Cascade'
      HelpContext = 199
      HelpType = htContext
      Hint = 'Cascade all windows'
      ImageIndex = 22
      OnExecute = CascadeWinsExecute
    end
    object TtBuild: TAction
      Category = 'Timetable'
      Caption = 'Build ...'
      HelpContext = 104
      HelpType = htContext
      Hint = 'Build timetable'
      ImageIndex = 28
      ShortCut = 114
    end
    object ShowWorksheet: TAction
      Category = 'Window'
      Caption = 'Worksheet'
      HelpContext = 372
      Hint = 'Worksheet window'
      ImageIndex = 41
      ShortCut = 49239
      OnExecute = ShowWorksheetExecute
    end
    object Action1: TAction
      Caption = 'Action1'
    end
    object FilePrintSetup2: TAction
      Category = 'File'
      Caption = 'Print Set&up...'
      HelpContext = 10
      Hint = 'Print Setup'
      ImageIndex = 2
      OnExecute = FilePrintSetup
    end
  end
  object ActionImages: TImageList
    Left = 364
    Top = 47
    Bitmap = {
      494C010134003600F40010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      000000000000360000002800000040000000E0000000010020000000000000E0
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000848484000000000084848400848484000000000000000000000000008484
      8400848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C6DEC6000000
      000000000000000000000000000000000000A5A5A50000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000A5A5A5000000000000000000000000000000
      000000000000C6DEC60000000000000000000000000000000000FF000000FF00
      0000848484000000000000000000848484008484840084848400000000000000
      0000848484008484840000000000000000000000000000000000000000000000
      0000000000000000000000000000848484000000000084848400000000008484
      8400000000008484840000000000000000000000000000000000A5A5A5000000
      000084848400000000000000000000000000C6DEC60000000000000000000000
      0000000000000000000000000000C6DEC600C6DEC60000000000000000000000
      0000000000000000000000000000C6DEC6000000000000000000000000008484
      840000000000A5A5A50000000000000000000000000000000000000000000000
      0000848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C6DEC60000000000A5A5A5000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C6DEC6000000000000000000C6DEC600000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A5A5A50000000000C6DEC6000000000000000000FF000000FF00
      0000848484000000000084848400848484000000000084848400848484008484
      8400000000000000000000000000000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000000000000000
      00000000000000000000000000000000000000000000C6DEC600000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000042424200A5A5A5000000000000000000A5A5A500424242000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C6DEC600000000000000000000000000000000000000
      0000848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A5A5A500000000000000
      00000000000000000000C6DEC6000000000000000000C6DEC60000000000A5A5
      A500000000000000000000000000000000000000000000000000000000000000
      0000A5A5A50000000000C6DEC6000000000000000000C6DEC600000000000000
      00000000000000000000A5A5A500000000000000000000000000FF000000FF00
      0000848484000000000084848400848484008484840000000000000000008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000008484840000000000848484000000000084848400848484000000
      0000848484000000000000000000000000000000000000000000848484000000
      000000000000A5A5A50000000000C6DEC6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C6DEC60000000000A5A5A5000000
      0000000000008484840000000000000000000000000000000000000000000000
      0000848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400000000004221210000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000422121000000
      0000848484000000000000000000000000000000000000000000848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008484840000000000000000000000000000000000000000000000
      0000000000008484840084848400848484008484840084848400848484008484
      8400848484008484840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F7CEA5000000
      8400000084000000840000008400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F7CEA500000084000000
      8400000084000000840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      00000000000000000000000000000000FF000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F7CEA500000084000000
      8400000084000000840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000FF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000FF0000008484
      8400848484000000000000000000000000008484840084848400848484008484
      8400FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000008400000084000000
      8400000084000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000FF000000FF000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C6C6C600C6C6C600FF0000008484
      84008484840084848400FFFFFF00000000000000000084848400848484008484
      8400FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000008484000084840000000084000000
      8400F7CEA5000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000840000008400
      000084000000840000008400000000000000000000000000000000000000FFFF
      FF0000FF000000FF000000FF0000000000000000000000000000000000000000
      000000000000000000000000000000000000C6C6C600C6C6C600FF0000008484
      84008484840084848400FFFFFF00000000000000000084848400848484008484
      8400FF0000000000FF00FF000000FF0000000000000000000000000000000000
      0000000000000000000084840000848400008484000084840000848400008484
      00000000000000000000000000000000000000000000FFFF0000840000008400
      00000000000000000000000000000000000000000000FFFF0000FF000000FF00
      0000FF000000FF0000008400000000000000000000000000000000000000FFFF
      FF0000FF000000FF000000FF000000FF00000000000000000000000000000000
      000000000000000000000000000000000000C6C6C600C6C6C600FF0000008484
      8400848484008484840000000000000000000000000084848400848484008484
      8400FF00000000FFFF0000FFFF00FF0000000000000000000000000000000000
      0000000000008484000084840000848400008484000084840000848400008484
      00000000000000000000000000000000000000000000FF000000FF0000008400
      0000840000000000000000000000000000000000000000000000FFFF0000FF00
      0000FF000000FF0000008400000000000000000000000000000000000000FFFF
      FF0000FF000000FF000000FF000000FF000000FF000000000000000000000000
      000000000000000000000000000000000000C6C6C600C6C6C600FF0000008484
      8400848484008484840000000000000000000000000084848400848484008484
      8400FF00000000FFFF0000FFFF00000084000000000000000000000000008484
      0000848400008484000084840000848400008484000084840000848400008484
      00000000000000000000000000000000000000000000FFFF0000FF000000FF00
      000084000000840000008400000084000000840000008400000084000000FF00
      0000FF000000FF0000008400000000000000000000000000000000000000FFFF
      FF0000FF000000FF000000FF000000FF000000FF000000000000000000000000
      000000000000000000000000000000000000C6C6C60084848400FF0000008484
      8400848484008484840000000000000000000000000084848400848484008484
      8400FF0000000000000000000000000084000000000000000000848400008484
      0000848400008484000084840000848400008484000084840000848400008484
      0000000000000000000000000000000000000000000000000000FFFF0000FF00
      0000FF00000000000000FF00000000000000FF000000FF000000FF000000FF00
      0000FFFF0000FF0000008400000000000000000000000000000000000000FFFF
      FF0000FF000000FF000000FF000000FF000000FF000000000000000000000000
      00000000000000000000000000000000000084848400FF000000000000008484
      8400848484008484840084848400848484008484840084848400848484008400
      0000C6C6C6000000000000000000000084000000000084840000848400008484
      0000848400008484000084840000848400008484000084840000848400008484
      000000000000000000000000000000000000000000000000000000000000FFFF
      0000FFFF0000FF000000FF000000FF000000FF000000FF000000FF000000FFFF
      000000000000FFFF00000000000000000000000000000000000000000000FFFF
      FF0000FF000000FF000000FF000000FF00000000000000000000000000000000
      000000000000000000000000000000000000C6C6C60084848400FF0000000000
      FF0084848400848484008484840084848400848484008484840084000000C6C6
      C600FF000000FF00000084000000FF0000008484000084840000848400008484
      0000848400008484000084840000848400008484000084840000848400008484
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000FF000000FF000000FF0000000000000000000000000000000000000000
      000000000000000000000000000000000000C6C6C600C6C6C60084848400FF00
      0000000000008484840084848400848484008484840084000000C6C6C600FF00
      0000FF000000FF000000FF000000C6C6C6000000000084840000848400008484
      0000848400008484000084840000848400008484000084840000848400008484
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000FF000000FF000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C6C6C600C6C6C600C6C6C6008484
      8400FF00000000000000848484008484840084000000FFFFFF00FF000000FF00
      00000000000084000000C6C6C600C6C6C6000000000000000000848400008484
      0000848400008484000084840000848400008484000084840000848400000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000FF00000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C6C6C600C6C6C600C6C6C600C6C6
      C60084848400FF0000000000000084848400FFFFFF00FF000000FF0000008484
      840000000000C6C6C600C6C6C600C6C6C6000000000000000000000000000000
      0000848400008484000084840000848400008484000084840000848400000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C60084848400FF000000FFFFFF00FF000000FF000000000000008484
      840000000000C6C6C600C6C6C600C6C6C6000000000000000000000000000000
      0000000000000000000084840000848400008484000084840000848400000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600FF000000FF000000FF000000FF000000000000008484
      840000000000C6C6C600C6C6C600C6C6C6000000000000000000000000000000
      0000000000000000000000000000000000008484000084840000848400000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600000000008484
      840000000000C6C6C600C6C6C600C6C6C6000000000000000000000000000000
      0000000000000000000000000000C6C6C6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000084E7E70042C6E700F7FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000002142000000
      000000000000000000000000000084848400F7FFFF0000000000000000000000
      0000000000000000000000000000000000000000000084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008484840084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004200
      C6004200C6004200C6004200C6000000000000000000000000000000000042C6
      E70042C6E700008400000084000042C6E7000000000000000000000000000000
      0000008400000084000000840000000000000000000000000000424200000000
      0000000000000000000000000000C6C6C60000000000F7FFFF00000000000000
      000000000000F7FFFF0000000000F7FFFF000000000084848400000000000000
      00000000000084848400FF000000FF000000FF000000FF000000848484000000
      0000000000000000000084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004200
      C6000063E7000063E7004200C6000000000000000000F7FFFF0042C6E70042A5
      E700008400000084000042A5E70042A5E70084C6E70000000000000000000000
      0000008400000084000000840000008400000000000000000000F7FFFF000000
      000000000000000000000000000000000000F7FFFF0000000000000000000000
      0000F7FFFF000000000000000000000000000000000084848400000000000000
      00000000000084848400FF000000FF000000FF000000FF000000848484000000
      0000000000000000000084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004200
      C6000063E7000063E7004200C6000000000000000000F7FFFF0042C6E7000084
      00000084000084C6E70084C6E70084C6E70084A5E700F7FFFF00000000000000
      00000084000000840000008400000084000000000000F7FFFF00000000008484
      840042000000C6C6C60000000000F7FFFF0000000000F7FFFF0000000000F7FF
      FF00000000000000000000000000F7FFFF000000000084848400000000000000
      00000000000084848400FF000000FF000000FF000000FF000000848484000000
      0000000000000000000084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004200
      C6004200C6004200C6004200C6000000000084C6E70084C6E700008400000084
      0000008400000084000042A5E7004284E7004284E70042C6E700000000000000
      0000008400000084000000840000008400000000000000000000000000000000
      00008463C600844263008442E700C6C6A5000000000000000000F7FFFF000000
      0000000000000000000000000000000000000000000084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008484840084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000084C6E700008400000084000042A5
      E70042A5E70000840000008400000084000000840000008400004284E7000000
      00000084000000840000008400000000000000000000F7FFFF00000000000000
      0000000000008442C600FF00FF00C600E70084A5C600F7FFFF00000000000000
      000000000000F7FFFF0000000000F7FFFF000000000084848400FF00FF00FF00
      FF00FF00FF008484840000000000000000000000000000000000848484008484
      0000848400008484000084848400000000000000000000000000C684C600C684
      C600C684C6000000000000000000000000000000000000000000000000004200
      C6004200C6004200C6004200C60000000000C6DEC600008400000084000042C6
      E70042C6E7000084000042C6E70042A5E70042A5E70042A5E70042A5E70042A5
      E70000840000008400000000000000000000F7FFFF0000000000000000000000
      00000000000084C66300C600E700FF00FF00C600E7008463C600000000000000
      0000F7FFFF0000000000F7FFFF00000000000000000084848400FF00FF00FF00
      FF00FF00FF008484840000000000000000000000000000000000848484008484
      0000848400008484000084848400000000000000000000000000C684C600C684
      C600C684C6000000000000000000000000000000000000000000000000004200
      C6000063E7000063E7004200C600000000000000000084C6E700008400000084
      000042A5E7000084000042A5E70042A5E70042A5E70042A5E70042A5E70042A5
      E7000084000000000000000000000000000000000000F7FFFF0000000000F7FF
      FF0000000000F7FFFF008463A500FF00FF00FF00FF00C600E700C6A5C6000000
      000000000000F7FFFF0000000000F7FFFF000000000084848400FF00FF00FF00
      FF00FF00FF008484840000000000000000000000000000000000848484008484
      0000848400008484000084848400000000000000000000000000C684C600C684
      C600C684C6000000000000000000000000000000000000000000000000004200
      C6000063E7000063E7004200C60000000000000000000000000084C6E7000084
      0000008400000084000084C6E70084C6E70084C6E70084C6E70084C6E70084C6
      E700000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C6A5E7008442C600FF00FF00FF00FF008400A50084C6
      C600000000000000000000000000000000000000000084848400FF00FF00FF00
      FF00FF00FF008484840000000000000000000000000000000000848484008484
      0000848400008484000084848400000000000000000000000000C684C600C684
      C600C684C6000000000000000000000000000000000000000000000000004200
      C6004200C6004200C6004200C6000000000000000000000000000000000084C6
      E70084C6E70084C6E70084C6E70084C6E700C6DEC60000000000000000000000
      00000000000000000000000000000000000000000000F7FFFF0000000000F7FF
      FF0000000000F7FFFF000000000084E7E7008463C600FF00FF00C600C6008442
      A500000000000000000000000000F7FFFF000000000084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008484840084848400000000000000000000000000C684C600C684
      C600C684C6000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000F7FF
      FF0084E7E700C6C6C600C6DEC600C6DEC6000000000000000000000000000000
      000000000000000000000000000000000000F7FFFF0000000000000000000000
      0000F7FFFF0000000000F7FFFF0000000000C6A5E700C663A5008400E700C600
      E700C642A5000000000000000000000000000000000084848400000000000000
      00000000000084848400FF000000FF000000FF000000FF000000848484000000
      0000000000000000000084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004200
      C6004200C6004200C6004200C600000000000000000000000000000000000000
      0000C6A54200C6A54200C6DEC600000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F7FFFF0000000000F7FF
      FF0000000000F7FFFF0000000000F7FFFF0000000000F7FFFF008463A500C600
      E700FF00FF008463C60000000000F7FFFF000000000084848400000000000000
      00000000000084848400FF000000FF000000FF000000FF000000848484000000
      0000000000000000000084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004200
      C6000063E7000063E7004200C60000000000000000000000000000000000C6A5
      4200C6A54200F7FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F7FFFF000000
      000000000000000000000000000000000000F7FFFF00000000000000000084C6
      C600C600C600FF00FF00C6A5E700000000000000000084848400000000000000
      00000000000084848400FF000000FF000000FF000000FF000000848484000000
      0000000000000000000084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004200
      C6000063E7000063E7004200C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F7FFFF0000000000F7FF
      FF0000000000F7FFFF0000000000F7FFFF0000000000F7FFFF00000000000000
      000000000000FF00FF008442C600F7FFFF000000000084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008484840084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004200
      C6004200C6004200C6004200C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F7FFFF0000000000F7FFFF000000
      0000F7FFFF00000000000000000000000000F7FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484000000000000008400000084
      00000000000000FF000000FF0000000000008484000084840000000000000084
      00000084000000000000848400008484000000000000F7FFFF00F7FFFF00F7FF
      FF0000000000F7FFFF00000000000000000000000000F7FFFF00F7FFFF000000
      0000F7FFFF00F7FFFF00F7FFFF00000000000000000000000000000000000000
      0000000000000000000000000000C6C6C6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484000000000000008400000084
      00000000000000FF000000FF0000000000008484000084840000000000000084
      000000840000000000008484000084840000F7FFFF0000000000F7FFFF00F7FF
      FF0000000000C6A5A50042210000422100004200000042212100C684A500F7FF
      FF0000000000F7FFFF0000000000000000000000000000000000002142000000
      000000000000000000000000000084848400F7FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484000000000000008400000084
      00000000000000FF000000FF0000000000008484000084840000000000000084
      000000840000000000008484000084840000000000000000000000000000F7FF
      FF00420000008421210042000000420000004200000042000000420021004200
      0000C6C6C6000000000000000000000000000000000000000000424200000000
      0000000000000000000000000000C6C6C60000000000F7FFFF00000000000000
      000000000000F7FFFF0000000000F7FFFF000000000084000000840000008400
      00008400000084000000840000000000000000000000FF000000FF0000000000
      0000FF000000FF00000000000000000000008484000000000000008400000084
      00000000000000FF000000FF0000000000000000000000000000000000000084
      0000008400000000000084840000848400000000000000000000F7FFFF004200
      00008421210042000000F7FFFF000000000000000000F7FFFF00420000004200
      210042214200F7FFFF00F7FFFF00000000000000000000000000F7FFFF000000
      000000000000000000000000000000000000F7FFFF0000000000000000000000
      0000F7FFFF000000000000000000000000000000000084000000840000008400
      00008400000084000000840000008400000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000000000008484000000000000008400000084
      00000000000000FF000000FF0000000000000000000000000000000000000084
      00000084000000000000848400008484000000000000F7FFFF00F7CEA5004200
      00004200000000000000C6A5A5004200000042000000C6A5A500F7FFFF004221
      210042000000C6A5A500000000000000000000000000F7FFFF00000000004263
      63004200000084A5A50000000000F7FFFF0000000000F7FFFF0000000000F7FF
      FF00000000000000000000000000F7FFFF000000000084000000840000000000
      00000000000084000000840000008400000000000000FF000000FF000000FF00
      000000000000FF000000FF000000FF0000008484000000000000008400000084
      00000000000000FF000000FF0000000000000000000000000000000000000084
      00000084000000000000848400008484000000000000F7FFFF00420000004221
      000000000000C684840042212100F7CEA500F7FFFF0042002100C6A5A500F7FF
      FF004200000084212100F7CEA500000000000000000000000000000000000000
      00008463C600FF000000C6426300C6C6C6000000000000000000F7FFFF000000
      0000000000000000000000000000000000000000000084000000840000000000
      00000000000000000000840000008400000000000000FF000000FF0000000000
      00000000000000000000FF000000FF0000008484000000000000008400000084
      00000000000000FF000000FF0000000000000000000000000000000000000084
      0000008400000000000000000000000000000000000000000000422121004200
      00000000000042212100F7FFFF004200210042002100F7FFFF0042000000F7FF
      FF008421210042210000F7CEA5000000000000000000F7FFFF00000000000000
      000000000000C6004200F7CEA500C6420000C6A56300F7FFFF00000000000000
      000000000000F7FFFF0000000000F7FFFF000000000084000000840000000000
      00000000000000000000840000008400000000000000FF000000FF0000000000
      00000000000000000000FF000000FF0000008484000000000000008400000084
      00000000000000FF000000FF0000000000000000000000000000000000000084
      00000084000000000000000000000000000000000000F7FFFF00F7FFFF00F7FF
      FF00F7FFFF00F7FFFF00F7FFFF004200210042002100F7FFFF00420000000000
      000042000000422100000000000000000000F7FFFF0000000000000000000000
      000000000000A5A5A500C6420000FFFF0000C6420000C6636300F7FFFF000000
      0000F7FFFF0000000000F7FFFF00000000000000000084000000840000008400
      00008400000084000000840000000000000000000000FF000000FF000000FF00
      000000000000FF000000FF000000FF0000008484000000000000000000000000
      00000000000000FF000000FF0000000000000000000000000000000000000084
      000000840000000000000000000000000000F7FFFF0000000000F7FFFF004221
      A5000021C6000021A5004221A500F7FFFF00F7FFFF0084212100C6848400F7FF
      FF00842121004200000000000000F7FFFF0000000000F7FFFF0000000000F7FF
      FF0000000000F7FFFF00C663420084630000FFFF0000C6420000C6A563000000
      000000000000F7FFFF0000000000F7FFFF000000000084000000840000008400
      00008400000084000000840000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000000000008484000000000000000000000000
      00000000000000FF000000FF0000000000000000000000000000000000000084
      00000084000000000000000000000000000000000000F7FFFF00F7FFFF00C6A5
      E7000021C6000021C6004221A500F7FFFF0084214200C684A500F7FFFF004200
      000042000000C6A5C600F7FFFF00F7FFFF000000000000000000000000000000
      00000000000000000000C6A5E70084636300C6630000FFFF0000FF00000084C6
      E700000000000000000000000000000000000000000084000000840000000000
      00000000000084000000840000000000000000000000FF000000FF0000000000
      0000FF000000FF00000000000000000000008484000000000000000000000000
      00000000000000FF000000FF0000000000000000000000000000000000000084
      00000084000000000000000000000000000000000000F7FFFF00C6A5E7000021
      C6000021E7000021C6004242A500C6A5E700F7FFFF00F7FFFF00420000004221
      210042002100F7FFFF00F7FFFF00F7FFFF0000000000F7FFFF0000000000F7FF
      FF0000000000F7FFFF0000000000C6A5E70084A5630084630000FFFF0000C600
      6300000000000000000000000000F7FFFF000000000084000000840000000000
      00000000000084000000840000000000000000000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000004284000021
      A5000042C60084C6E70000218400F7FFFF004200210042212100420000004200
      0000F7FFFF000000000000000000F7FFFF00F7FFFF0000000000000000000000
      0000F7FFFF0000000000F7FFFF0000000000C6A5E70084A54200C6840000FFFF
      0000C642A500F7FFFF0000000000000000000000000084000000840000008400
      00008400000084000000840000000000000000000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F7FFFF00F7FFFF004242
      8400C6DEC600F7FFFF00F7FFFF00C6DEC6004221210000000000C6A5A500F7FF
      FF00F7FFFF0000000000F7FFFF00F7FFFF0000000000F7FFFF0000000000F7FF
      FF0000000000F7FFFF0000000000F7FFFF0000000000F7FFFF00C6634200C642
      0000FFFF0000C642630000000000F7FFFF000000000084000000840000008400
      00008400000084000000000000000000000000000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F7FFFF00F7FFFF00F7FF
      FF00F7FFFF00F7FFFF00F7FFFF00F7FFFF00F7FFFF00F7FFFF00000000000000
      0000F7FFFF00F7FFFF00F7FFFF00F7FFFF000000000000000000F7FFFF000000
      000000000000000000000000000000000000F7FFFF00000000000000000084C6
      E70084634200C6A50000F7CEA500000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000F7FF
      FF00F7FFFF00F7FFFF0000000000F7FFFF00F7FFFF00F7FFFF00000000000000
      000000000000F7FFFF00F7FFFF00F7FFFF0000000000F7FFFF0000000000F7FF
      FF0000000000F7FFFF0000000000F7FFFF0000000000F7FFFF00000000000000
      000000000000FF000000C6426300F7FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F7FFFF00F7FFFF000000
      0000F7FFFF00F7FFFF0000000000F7FFFF00F7FFFF00F7FFFF00000000000000
      0000F7FFFF00F7FFFF00F7FFFF00F7FFFF00F7FFFF0000000000F7FFFF000000
      0000F7FFFF00000000000000000000000000F7FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0084848400FFFFFF00FFFFFF00FFFFFF008484
      8400000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF00FF000000FF0000000000FF00000000000000
      0000000000000000000000000000000000008484840084000000FF0000008400
      0000848484008484840000000000848484008484840084848400848484008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008400000084
      0000000000000000000000000000000000000000000084848400848484008484
      8400848484008484840000000000848484008484840084848400848484008484
      8400000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF0000000000000000000000000084000000FF000000FF000000FF00
      0000000000008484840000000000000000000000000000000000848484008484
      8400848484008484840084848400848484000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000008400000084
      000000FF000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0084848400FFFFFF00FFFFFF00FFFFFF008484
      84000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF00FF000000FF0000000000FF000000FF000000
      FF000000FF000000FF000000000000000000848484000000840000008400FF00
      0000FF0000008400000000000000000000000000000000000000000000000000
      0000848484008484840084848400848484000000000000000000000000000000
      00000000000000000000000000000000000084000000008400000084000000FF
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF008484
      84000000000000000000000000000000000000000000000000000000FF00FFFF
      FF000000FF000000FF000000FF00FF000000FF0000000000FF000000FF00FFFF
      FF000000FF000000FF0000000000000000000000000000000000848484000000
      84000000840000008400FF000000FF000000FF000000FF000000840000008484
      8400FFFFFF000000000000000000FFFFFF000000000000000000000000000000
      000000000000000000000000000000000000840000000084000000FF00000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF0000000000FFFFFF008484
      840000000000000000000000000000000000000000000000FF000000FF000000
      FF00FFFFFF00FFFFFF000000FF00FF000000FF000000FFFFFF00FFFFFF000000
      FF000000FF000000FF0000000000000000000000000000000000000000008484
      8400000084000000840000008400FF000000FF000000FF000000FF0000008484
      840000000000FFFFFF0000FFFF00000000000000000000000000000000000000
      000000000000000000000000000084000000008400000084000000FF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000848484000000000000FFFF00000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF00FFFFFF00FFFFFF00FF000000FF000000FF0000000000FF000000
      FF000000FF000000FF000000FF0000000000000000000000000000000000FF00
      0000848484008484840000008400FF000000FF000000FF000000FF0000008400
      00000000000000FFFF0000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000840000000084000000840000000000000000
      0000000000000000000000000000000000000000000084840000848400008484
      00008484000084840000000000008484840084848400FFFFFF00000000008484
      840000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF000000FF00FFFFFF00FF000000FF000000FF000000FF0000000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      000000000000000000008484840000008400000084000000840000008400FF00
      00000000000000FFFF0000FFFF00000000000000000000000000000000000000
      0000840000008400000084000000008400000084000000840000000000000000
      0000000000000000000000000000000000000000000084840000848400008484
      000084840000FFFF00000000000084848400FFFFFF00FFFFFF0000FFFF000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF00FF000000FF000000FF000000FFFFFF00FFFFFF00FF000000FF0000000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000084000000840000008400000084000000
      000000FFFF00FFFFFF0000FFFF00FFFFFF000000000000000000000000000000
      000000FF000000FF000000FF000000FF00000084000000FF0000000000000000
      00000000000000000000000000000000000000000000FFFF000084840000FFFF
      000084840000FFFF0000000000008484840084848400848484000000000000FF
      FF00FFFFFF00000000000000000000000000000000000000FF000000FF000000
      FF00FF000000FF000000FF000000FF000000FF000000FF000000FF0000000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      00000000000000000000000000000000840000008400000084000000840000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000008400
      000000FF0000008400000084000000FF000000FF000000000000000000000000
      0000000000000000000000000000000000000000000084840000848400008484
      000084840000FFFF00000000000084848400FFFFFF00FFFFFF00FFFFFF008484
      8400FFFFFF00FFFFFF000000000000000000000000000000FF000000FF000000
      FF00FF000000FF000000FF000000FF000000FF000000FF000000FF0000000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000FFFF00FFFFFF000000000000000000000000008400
      0000008400000084000000840000008400000084000000FF0000000000000000
      00000000000000000000000000000000000000000000FFFF000084840000FFFF
      000084840000FFFF00000000000084848400FFFFFF00FFFFFF00FFFFFF008484
      840084848400000000000000000000000000000000000000FF000000FF000000
      FF00FFFFFF00FF000000FF000000FF000000FF000000FF000000FFFFFF000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF000000000000000000000000008400
      0000008400000084000000840000008400000084000000FF0000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF0000000000FFFF000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF0000000000FFFFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000000000FFFFFF000000000000000000000000008400
      0000008400000084000000840000008400000084000000FF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFF000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00000000000000000000000000000000000000
      000000FF0000008400000084000000FF000000FF000084000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFF000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FF000000FF000000FF000000FF00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FF000000FF
      000000FF000000FF000000000000FF000000FF000000FF000000FF000000FFFF
      0000FFFF0000FFFF0000FFFF0000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FFFF0000FF000000FFFF0000FFFF
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000008400000084000000840000000084000000FF000000
      840000000000000000000000000000000000000000000000000000FF000000FF
      000000FF000000FF000000000000FF000000FF000000FF000000FF000000FFFF
      0000FFFF0000FFFF0000FFFF0000000000000000000000000000000000000000
      00000000000000000000FFFF0000FFFF0000FF000000FFFF0000FF000000FF00
      0000000000000000000000000000000000000000000000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000840000008400000084000000840000000084000000
      840000000000000000000000000000000000FFFF0000FFFF0000FFFF0000FFFF
      0000000000000000000000000000000000000000000000FF000000FF000000FF
      000000FF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000FFFF
      0000000000000000000000000000000000000000000000FF000000FF000000FF
      000000FF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000FFFFFF0000FF
      FF00000000000000000000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084848400FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      000000000000000000000000000000000000000000000000000000FFFF00FFFF
      FF000000000000FFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084848400FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      000000000000000000000000000000000000C6C6C6000000000000FF000000FF
      000000FF000000FF000000000000FF000000FF000000FF000000FF000000FFFF
      0000FFFF0000FFFF0000FFFF0000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF0000FFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00000000000000000000000000C6C6C60000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000000000000000000000000000000000000000000000FF
      FF0000FFFF00FFFFFF0000FFFF0000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00000000000000000000000000C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C6000000000000000000000000000000
      0000000000000000000000FF000000FF00000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000FFFFFF0000FFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00000000000000000000000000C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF0000FFFF00FFFFFF0000FFFF0000FF
      FF00FFFFFF000000000000000000000000000000000000000000FFFFFF00FFFF
      FF000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000FFFFFF00000000000000000000000000C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0000FFFF00FFFFFF0000FFFF00FFFFFF00FFFF
      FF0000FFFF00FFFFFF0000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      0000FFFFFF00000000000000000000000000C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF0000FFFF00FFFFFF0000FFFF0000FF
      FF00FFFFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      0000FFFFFF00000000000000000000000000C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF00FFFFFF0000FFFF00FFFFFF00FFFF
      FF0000FFFF00FFFFFF00FFFFFF0000FFFF000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      0000FFFFFF00000000000000000000000000C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C6000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF00000000000000000000000000FFFF
      FF0000FFFF00FFFFFF0000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      000000000000000000000000000000000000C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C6000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF00FFFFFF0000FFFF0000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      000000000000000000000000000000000000C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C6000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      000000000000000000000000000000000000C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFF0000FFFFFF00FFFF
      000084840000FFFFFF00FFFF0000FFFF00008484000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000000000000000000000000000000000000000000000848400008484000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000084840000000000000000000000000000000000FFFFFF00FFFF0000FFFF
      FF0084840000FFFF0000FFFFFF00FFFFFF008484000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000848400008484000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000084840000000000000000000000000000000000FFFF0000FFFFFF00FFFF
      000084840000FFFFFF00FFFF0000FFFF00008484000000000000848400000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000848400008484000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000084840000000000000000000000000000000000FFFF0000FFFFFF00FFFF
      00008484000000000000FFFF0000FFFF00008484000000000000848400000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000848400008484000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000084840000000000000000000000000000000000FFFFFF00FFFF0000FFFF
      FF00848400008484000000000000000000000000000000000000848400000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000848400008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      84000084840000000000000000000000000000000000FFFF0000FFFFFF00FFFF
      0000848400008484000000000000848400008484000084840000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000848400008484000000
      0000000000000000000000000000000000000000000000000000000000000084
      8400008484000000000000000000000000000000000000000000FFFFFF00FFFF
      FF0084840000848400000000000084840000FFFF000084840000848400000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000008484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF0084840000848400000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000008484000000000000000000000000000000000000000000000000000000
      0000FFFF00008484000000000000FFFF0000FFFF000084840000848400000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000008484000000000000000000000000000000000000000000000000000000
      0000FFFF0000FFFFFF00FFFF0000FFFFFF00FFFFFF00FFFF0000848400000000
      0000848484008484000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000008484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      840084840000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400FFFFFF00FFFF000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084848400FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60084848400C6C6C600C6C6C60084848400C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000840000008400000084000000840000008400
      0000840000008400000084000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60084848400C6C6C600C6C6C60084848400C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60084848400C6C6C600C6C6C60084848400C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00840000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60084848400C6C6C600C6C6C60084848400C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00840000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60084848400C6C6C600C6C6C60084848400C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00000000000000000000000000000000008400
      0000840000008400000084000000840000008400000084000000840000008400
      0000840000008400000084000000840000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60084848400C6C6C600C6C6C60084848400C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00000000000000000000000000000000008400
      0000FFFFFF00FFFFFF0084000000840000008400000084000000840000008400
      00008400000084000000FFFFFF00840000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60084848400C6C6C600C6C6C60084848400C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00000000000000000000000000000000008400
      0000FFFFFF00FFFFFF0084000000840000008400000084000000840000008400
      0000840000008400000084000000840000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60084848400C6C6C600C6C6C60084848400C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000008400
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00840000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60084848400C6C6C600C6C6C60084848400C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000840000008400000084000000840000008400
      0000840000008400000084000000000000000000000084000000840000008400
      0000840000008400000084000000840000008400000084000000840000008400
      0000840000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60084848400C6C6C600C6C6C60084848400C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000FFFFFF008400
      000084000000840000008400000084000000840000008400000084000000FFFF
      FF00840000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60084848400C6C6C600C6C6C60084848400C6C6C6000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000084000000FFFFFF008400
      0000840000008400000084000000840000008400000084000000840000008400
      0000840000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60084848400C6C6C600C6C6C60084848400C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000008400
      0000840000008400000084000000840000008400000084000000840000008400
      0000000000000000000000000000000000000000000084000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00840000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60084848400C6C6C600C6C6C60084848400C6C6C6000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000084000000840000008400
      0000840000008400000084000000840000008400000084000000840000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60084848400C6C6C600C6C6C60084848400C6C6C6000000
      0000000000000000000000000000000000000000000084000000840000008400
      0000840000008400000084000000840000008400000084000000000000000000
      0000000000000000000000000000000000000000000084000000840000008400
      00008400000084000000840000008400000084000000FFFFFF00840000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60084848400C6C6C600C6C6C60084848400C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000840000008400
      0000840000008400000084000000840000008400000084000000840000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60084848400C6C6C600C6C6C60084848400C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FF00000000000000000000000000000000000000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008484840000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FF00000000000000000000000000000000000000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484008484840000000000000000000000000000000000000000000000
      000000FFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FF00000000000000000000000000000000000000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF000000000000000000000000008484
      8400FFFFFF0000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      0000000000000000000000000000000000008484840000000000000000000000
      000000FF00000000000000000000000000000000000000FFFF0000FFFF000000
      0000000000000000000000000000000000008484840000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF0000FFFF008484
      840000FFFF0000000000FFFFFF00FFFFFF0000FFFF00000000000000000000FF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      0000000000008484840000000000848484000000000000000000000000000000
      000000FF00000000000000000000000000000000000000FFFF0000FFFF000000
      0000000000008484840000000000848484000000000000000000000000000000
      00000000000000000000000000000000000000FFFF00FFFFFF00FFFFFF0000FF
      FF00FFFFFF00FFFFFF000000000000FFFF000084840000000000FFFFFF00FFFF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00008484000000
      0000000000000000000084848400000000008484840000000000000000000000
      000000FF000000000000000000000000000000000000FFFFFF00008484000000
      0000000000000000000084848400000000008484840000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF0000FFFF00FFFF
      FF0000FFFF0000FFFF00FFFFFF000084840000000000FFFFFF0000FFFF0000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FFFF0000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      00000000000000000000000000000000000000000000000000000000000000FF
      000000FF000000FF000000000000000000000000000000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF0000000000FFFF
      FF0000000000000000000000000000FFFF0000FFFF00FFFFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000848484000000
      0000FF000000FFFF0000FFFF0000FFFF0000FFFF0000FF000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF000000
      000000000000000000000000000000000000000000000000000000FF000000FF
      000000FF000000FF000000FF000000000000000000000000000000FFFF000000
      00000000000000000000000000000000000000000000000000000000000000FF
      000000FF000000FF0000000000000000000000FFFF00FFFFFF00000000000000
      000000000000FFFFFF0000FFFF00FFFFFF00FFFFFF0000FFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FFFF0000FF000000FF000000FF000000000000008400
      000084000000000000000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000848484000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000848484000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF00000000000000
      0000FFFFFF0000FFFF00FFFFFF0000FFFF0000FFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000848484008484
      84000000000000000000FF000000000000000000000000000000000000008400
      000084000000000000000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF0084848400000000008484840000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF0084848400000000008484840000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF0000FFFF00FFFF
      FF0000FFFF0000FFFF00FFFFFF0000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484000000000084848400000000008484840000000000848484008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000848484000000000084848400000000008484840000000000848484008484
      84000000000000000000000000000000000000FFFF00FFFFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF0084848400000000008484840000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084848400848484000000000084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084848400848484000000000084848400000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF0000FFFF00FFFF
      FF0000FFFF0000000000848484008484840000FFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF0000FFFF00FFFF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF00FFFFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFF00000000
      00000000000000000000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000FFFF00000000
      00000000000000FF000000000000000000000000000000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF0000000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF0000000000000000000000000000000000000000FFFF000000
      0000000000008484840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FF000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF0000000000000000000000000000000000000000FFFF000000
      0000000000008484840000000000848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      00000000000000000000000000000000000084848400000000000000000000FF
      000000FF000000FF000000000000000000000000000000FFFF0000FFFF000000
      00000000000000000000000000000000000084848400000000000000000000FF
      000000FF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000000
      0000000000000000000084848400000000008484840000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      00000000000084848400000000008484840000000000000000000000000000FF
      00000000000000000000FFFF0000000000000000000000FFFF0000FFFF000000
      00000000000084848400000000008484840000000000000000000000000000FF
      000000FF000000FF000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF000000
      0000000000008484840000000000848484000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00008484000000
      0000000000000000000084848400000000008484840000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00008484000000
      0000000000000000000084848400000000008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF00000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      00000000000000000000000000000000000000000000000000000000000000FF
      00000000000000000000FFFF0000000000000000000000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000848484000000000084848400000000000000
      000000000000000000000000000000000000000000000000000000FFFF000000
      00000000000000000000000000000000000000000000000000000000000000FF
      000000FF000000FF00000000000000000000000000000000000000FFFF000000
      00000000000000000000000000000000000000000000000000000000000000FF
      000000FF000000FF00000000000000000000000000000000FF00000000000000
      000000000000000000000000FF00000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF0084848400000000008484840000000000848484008484
      840000000000000000000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000848484000000000000000000FFFF00000000
      00000000000000000000FFFF000000000000000000000000000000FFFF000000
      0000000000000000000000000000848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484000000000084848400000000008484840000000000848484008484
      840000000000000000000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF0084848400000000008484840000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF0084848400000000008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084848400848484000000000084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484000000000084848400000000008484840000000000848484008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000848484000000000084848400000000008484840000000000848484008484
      8400000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C6C6C60000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084848400848484000000000084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084848400848484000000000084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF00000000000000FF0000000000000000000000000000000000C6C6
      C600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF00FFFFFF0000FF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF00FFFFFF0000FFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000424221004242210042422100424221004242
      21004242210042422100C6C6C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      8400000084000000FF00000084000000FF000000FF00000084000000FF000000
      00000000000000000000000000000000000000000000FFFFFF0000FFFF00FFFF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF000000000000FF
      FF0000FFFF000000000000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000C6C6C6000000000000000000000000000000
      000000000000A5A5A500A5A5A500C6C6C6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      84000000FF000000FF00000084000000FF000000FF00000084000000FF000000
      FF00000084000000840000000000000000000000000000FFFF00FFFFFF000000
      000000000000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF000000
      00000000000000FFFF00FFFFFF00000000000000000000000000000000000000
      000000000000C6DEC600A5A5A500000000004221210042636300846363004263
      63004242630000000000C6C6C600C6C6C6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000084000000
      840000008400000084000000FF0000008400000084000000FF00000084000000
      84000000FF0000008400000000000000000000000000FFFFFF00000000000000
      00000000000000000000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF0000FFFF00FFFFFF0000FFFF0000000000FFFFFF0000000000000000000000
      000000000000A5A5A50000000000846363008484840084A5A50084848400A5A5
      A500848484000000000042426300C6C6C6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000084000000FF00000084000000FF000000FF00000084000000FF000000
      FF00000084000000FF0000000000000000000000000000FFFF00FFFFFF0000FF
      FF0000FFFF000000000000000000FFFFFF0000FFFF00FFFFFF0000FFFF000000
      00000000000000FFFF00FFFFFF000000000000000000C6DEC600FFFFFF000000
      00000000000000000000C6C6C6008484A500A5A5A500C6C6C60084A5C600C6C6
      C600C6C6C6004263630042212100A5A5A5000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000000
      0000FFFFFF0000008400000084000000FF000000FF00000084000000FF000000
      FF00000084000000FF00000084000000000000000000FFFFFF0000FFFF00FFFF
      FF00FFFFFF0000FFFF000000000000000000FFFFFF0000FFFF000000000000FF
      FF0000FFFF000000000000FFFF00000000000000000000000000C6C6C6000000
      0000000000000000000000000000C6C6C600C6DEC60000000000C6C6C600C6C6
      C600C6C6C6004263630000000000C6C6C6000000000000000000000000000000
      0000000000000000000000FF0000FFFFFF0000000000000000000000000000FF
      0000FFFFFF0000FF000000000000000000000000000000000000008484000000
      0000FFFFFF00000084000000FF0000008400000084000000FF00000084000000
      84000000FF000000840000008400000000000000000000FFFF00FFFFFF0000FF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF00FFFFFF0000FFFF00FFFFFF00000000000000000000000000000000000000
      00000000000000000000FFFFFF0084848400C6DEC600C6C6C600FFFFFF004263
      6300FFFFFF00C6C6C60000000000C6C6C6000000000000000000000000000000
      00000000000000FF0000FFFFFF0000FF000000FF00000000000000000000FFFF
      FF0000FF0000FFFFFF00000000000000000000000000000000000000000000FF
      FF00000000000000FF00000084000000FF000000FF00000084000000FF000000
      FF00000084000000FF00000084000000000000000000FFFFFF0000FFFF000000
      00000000000000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF0000FFFF00FFFFFF0000FFFF0000000000FFFFFF00C6DEC600000000000000
      000000000000A5A5A5000000000084636300FFFFFF0042424200000000000000
      00000000000000000000A5A5A500000000000000000000000000000000000000
      00000000000000FF0000FFFFFF0000FF000000FF00000000000000000000FFFF
      FF0000FF0000FFFFFF0000000000000000000000000000000000000084000000
      84000000FF000000FF00000084000000FF000000FF00000084000000FF000000
      FF00000084000000FF0000008400000000000000000000FFFF00000000000000
      0000000000000000000000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF00FFFFFF0000FFFF00FFFFFF0000000000000000000000000000000000C6DE
      C60000000000C6DEC6000000000042424200FFFFFF0000000000424263000000
      0000C6A5C6000000000000000000FFFFFF000000000000000000000000000000
      0000000000000000000000FF0000FFFFFF0000000000000000000000000000FF
      0000FFFFFF0000FF0000000000000000000000000000000084000000FF00FFFF
      FF0000000000000084000000FF0000008400000084000000FF00000084000000
      84000000FF0000008400000000000000000000000000FFFFFF0000FFFF00FFFF
      FF00FFFFFF00000000000000000000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF0000FFFF00FFFFFF0000FFFF0000000000FFFFFF0000000000000000000000
      000000000000000000000000000042212100FFFFFF0000000000000000000000
      0000002142000021420000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000008400FFFFFF00FFFF
      FF000000FF000000000000000000000000000000000000000000000000000000
      FF00000084000000FF0000000000000000000000000000FFFF00FFFFFF0000FF
      FF0000FFFF00FFFFFF00000000000000000000FFFF00FFFFFF0000FFFF00FFFF
      FF00FFFFFF0000FFFF00FFFFFF0000000000FFFFFF0000000000C6C6C600C6DE
      C60084A5A500000000008484A50042212100FFFFFF00424242000000000084A5
      C6004242A5004242A50000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF00FFFF
      FF00000000000000840000008400000000000000000000000000000000000000
      FF000000840000008400000000000000000000000000FFFFFF0000FFFF00FFFF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF0000FFFF00FFFFFF0000FFFF0000000000FFFFFF0000000000C6C6C600C6C6
      C600C6DEC600000000008484A50042214200FFFFFF00424263000021420084A5
      C6004242C6004242A50000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000084000000
      840000008400000084000084840000000000000084000000FF00000084000000
      8400000084000000840000000000000000000000000000000000000000000000
      0000000000000000000000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF00FFFFFF0000FFFF00FFFFFF0000000000FFFFFF0000000000C6C6C600C6C6
      C600C6C6C60000000000A5A5A5004263630084636300424263000021420084A5
      C6004263A5004263C60000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000008400000084000000848400000000000000840000008400000084000000
      84000000000000000000000000000000000000000000FFFFFF0000FFFF00FFFF
      FF00FFFFFF0000FFFF0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FF00008484
      8400848484000000000000000000008484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FF0000008400008484
      8400008400000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400000084008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000840000008400000084000000840000008400
      0000840000008400000084000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000084000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF008400000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000084000000
      0000848484000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000FFFFFF000000000000000000000000000000
      000000000000FFFFFF008400000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000008484000084840000848400008484000084840000848400008484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000084000000
      8400000084000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF008400000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF0000FFFF000084840000848400008484000084840000848400008484000084
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000084000000
      00008484840000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0084000000FFFFFF000000000000000000000000000000
      000000000000FFFFFF008400000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000000000000000000000FF
      FF00FFFFFF000000000000848400008484000084840000848400008484000084
      8400008484000000000000000000000000000000000000000000000000000000
      0000000000008400840000000000848484000000000000000000000084000000
      00000000000084848400000000000000000000000000FFFFFF00000000000000
      0000000000000000000084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF008400000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF0000FFFF0000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008484840084008400000000000000000000000000000084000000
      84000000840000008400000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0084000000FFFFFF000000000000000000FFFFFF008400
      000084000000840000008400000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF0000FFFF0000FFFF00FFFFFF0000FFFF0000FFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084008400000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000000000000000000084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF008400
      0000FFFFFF00840000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000000000000000000000FF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084008400000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF008400
      000084000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008400840084008400840084000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF000000000084000000840000008400000084000000840000008400
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084008400000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084008400848484000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000840084008400840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C6000000
      0000C6C6C6000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF00000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000008484840000000000000000008484
      84000000000000000000000000000000000000000000C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C60000FFFF0000FFFF0000FFFF00C6C6C600C6C6
      C600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000848484000000000000000000FFFF00008484
      84008484840000000000000000000000000000000000C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600848484008484840084848400C6C6C600C6C6
      C60000000000C6C6C60000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C600C6C6C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF0000000000000000000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000000000FFFF000000000000000000008484
      84000000000000000000000000000000000000000000C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C6000000
      0000C6C6C60000000000C6C6C600000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000084848400FFFF0000FFFF0000000000008484
      8400848484000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C6C6
      C60000000000C6C6C60000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000008484840000000000000000008484
      840000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000C6C6C60000000000C6C6C600000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF00000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF0000000000000000000000
      0000FF000000FF000000FF000000FF00000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF00000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000E00000000100010000000000000700000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFFFFFFFFFFFFF8001F001FFFFFFFF
      B7FDF6FDFFFFFFFF84E5F7FDFFFFFFFFB7FDF7FDDF7FFEFB8631F6A9C77E7EE3
      B7FDFFFF4F8181F2848D803FDFC3C3FB87FD803F9FE187F9B7FDFFFF9D83C1B9
      846DF295CA3BDC53B7FDF7FDE0FFFF078001F001FFFFFFFFBFFDF7FDFFFFFFFF
      8001F001FFFFFFFFFFFFFFFFFFFFFFFFFFC1FFFFFFFFFFFFFF83FFFFE7FFDE1F
      FF83FFFFE3FF4400FF87FFFFE1FF0000FF07FFC1E0FF0000FC0F8F81E07F0000
      F80F87C1E03F0000E00F8001E01F0000C00FC001E03F0000800FE00BE07F0000
      000FF81FE0FF0000800FFFFFE1FF0000C01FFFFFE3FF0000F01FFFFFE7FF0000
      FC1FFFFFFFFF0000FF1FFFFFFFFF0000C0FFFFFFFFFFF8FFC07F8001FFE1E0F1
      C0BAB81DFF018070C377B81DFF618030A2AEB81DFF610030F0DF8001837F0011
      B83A83C182610003783583C180618007A81A83C18001C00FFC0F83C18061E07F
      AA0E8001827FE0FF7507B81D8361F1FFAA82B81DFF61E3FFDF61B81DFF01FFFF
      AAB88001FFE1FFFF577FFFFFFFFFFFFFFFFF49248B91C0FFFFFF4924480BC07F
      FFFF4924E007C0BA819349E4C181C377808149E48403A2AE988849E48801F0DF
      9C9C49E7C801B83A9C9C49E780137815818879E74002A81A818179E78000FC0F
      999379E78000AA0E999FFFFFC0067503819FFFFF8004AA82839FFFFF8030DF61
      FFFFFFFFE238AAB8FFFFFFFF9230577FFFFFFFFF800FFE7FFFFFFFFF800FFC3F
      020FFFCF800FE00703C0FF87800FC00301F0FF0F800FC003C006FF1F800F8003
      E009FE1F822F8001E00AFE3F800F8001FC09F03F80078001FE10F03F80038001
      FE01E07F80038003FFE0E03F80038003FF00E03F81FDC003FE82E03FB1FFE007
      FF49F03F81FFF01FFFFFF0FF83FFFFFF8000F807BFFFF8078000F8079FFFF807
      0F03FC0F8DFFFC0F0F03FC0F89FFFC0F0000FC0F81FFFC0F0000F003C0FFF003
      0000E003C07FE0030078E003C04FE00300008803E803880300008803F8018803
      0000F803F800F8030000F803FC00F8030000F807FE60F8070000F80FFE61F80F
      0000F80FFFE3F80F0000FE7FFFE3FE7FC007FFFFFFFFFFFF8003FFFFFFFF80FF
      BFF3F80F8003803FBFF3F80F0063801FB033FE3F0063801FBFF3FE3F0063801F
      B033FE3F0003801FBFF3FE3F0003801FB033FC3F0003801FBFF3FE3F1FE3C01F
      B133FFFF1FE3E01BBFF3FFFF1FE3F013BFF3FE3F1FE3FFE1AAABFE3F1FE3FFE1
      D557FFFF1FEBFFF3EAAFFFFF0003FFFFF81FFFFFFC00FFFFF81FF800FC00FFFF
      F81FFBFCFC00FE7FF81FFBFCFC00FE7FF81FFBFCE000FE7FF81FFBFCE000FE7F
      F81F1BFCE000FE7FF81F7800E007FE7FF81F78008007FE7FF81F78008007FE7F
      F81F60078007FE7FF81F6007801FFE7FF81F001F801FFE7FF81F001F801FFE7F
      F81F001F801FFFFFF81FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE3FFC1FFF3FFFF
      9FE39FC1FFC3FFFF9FE39FCFF003FFFF83E383CF000380018063804F0007BFFD
      9063904F0007BDFD9063904F000FB83D90419041201F903D818081C1001FB825
      8E418E41001F8DE5807F807F001FBFFD90019001001F8001E407E407003FFFFF
      F81FF81F007FFFFFFFFFFFFF01FFFFFFF7E7FFFFFFFFFFFFF7F99FFFFFC1FFC9
      F7E99FFF9FC19FC9F7B183E39FF99FC9F7D1800383F983C1F451900780418041
      F85B900790419041F947900F904F9041F8BF81C790419041F9FFC63381C181C1
      B9FF800D8E418E41F7FFD001807F807FF7DFE40790019001E77FF91FE407E407
      E5EFFFFFF81FF81FEFFFFFFFFFFFFFFF8001FE00FFFFF81F0000FE01FFFFE007
      0000FE00FFFFC0030000F800FFFFC00300007800FFFFF00300009800FCE3D000
      0000DA40F863D0000000F800F801E80000003829B001C0000000EA06A8638801
      00000000DCE387E100000000FFFFC8E300000000FFFFC10300000000FFFFF10F
      00010000FFFFC27F83FF0000FFFF877FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8F
      FC01C007FFFFFFDFFC01C007C01FFFD7FC01C007C01FFFC70001C007C007FFD7
      0001C007C003FADB0001C007C003F9C30001C007C01FFDFF0003C007C01FFDFF
      0007C007E7E3F8FF000FC007FF6BFDFF00FFC00FFF9FFCFF01FFC01FFFFFFE7F
      03FFC03FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8007C03F000CC007BFF7C03F
      00088003A017003F00010001ACD7003F00630001AFD71FBF00C30001AFD70030
      01EB0000AFD300F0016B0000AFC000E000238000A380FFDF0067C000AFC0FC30
      000FE001A1D3FC00000FE007AFD7FC30000FF007A017FFDF005FF003BFF7FFE0
      003FF8038007FFF0007FFFFFFFFFFFF000000000000000000000000000000000
      000000000000}
  end
  object Timer1: TTimer
    Interval = 60000
    OnTimer = Timer1Timer
    Left = 479
    Top = 47
  end
  object Timer2: TTimer
    Interval = 200
    OnTimer = Timer2Timer
    Left = 336
    Top = 47
  end
  object HelpRouter1: THelpRouter
    HelpType = htHTMLhelp
    ShowType = stMain
    CHMPopupTopics = 'CSHelp.txt'
    ValidateID = False
    Left = 450
    Top = 47
  end
  object WhatsThis1: TWhatsThis
    Active = True
    F1Action = goContext
    Options = [wtMenuRightClick, wtNoContextHelp, wtNoContextMenu, wtInheritFormContext]
    PopupCaption = 'What'#39's this?'
    PopupHelpContext = 0
    Left = 421
    Top = 47
  end
  object ActionImagesNew: TImageList
    Left = 276
    Top = 111
    Bitmap = {
      494C01013C005400F80010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000000001000001002000000000000000
      0100000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E7D6AD00FFDE
      9C00FFDE9C00FFDE9400FFD69400FFD69400F7CE9400EFD6B500A58C6300BDA5
      8C00D6BDAD00EFE7E7000000000000000000000000005A5AEF007373FF000808
      A5000000000008DEF70010E7FF00009CC60000000000F7CE5200FFD66300B57B
      00000000000052E7C6005AEFCE00009463000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000B5B5C600315A9400426B9C004A73A500527BAD005A84
      B500637BAD00DEE7EF0000000000000000000000000000000000E7D6AD00FFDE
      A500FFDE9C00FFDE9C00FFDE9C00FFDE9400F7CE9400F7E7CE00CEAD8400A584
      6300BDA58C00D6C6B5000000000000000000000000005252EF006B6BFF000808
      A5000000000008D6F70010E7FF00009CC60000000000F7CE4A00FFD66300B57B
      00000000000052E7C6005AEFCE0000946300000000000000000039394200529C
      9C0084FFFF0084FFFF007BFFFF007BFFFF007BFFFF007BFFFF007BFFFF007BFF
      FF007BFFFF007BFFFF007BFFFF00000000000000000000000000000000000000
      00000000000000000000B5ADBD002163A5003173AD004284BD00528CC600639C
      D600637BAD008C9CC600F7F7FF00000000000000000000000000E7D6B500FFDE
      AD00FFDEA500FFDEA500FFDE9C00FFDE9C00F7CE9400FFF7DE00FFE7C600CEAD
      8400A58C6300C6AD9C000000000000000000000000004A4AEF006363FF000808
      A5000000000008D6F70010E7FF00009CC60000000000F7C64A00FFD65A00B57B
      0000000000004AE7BD005AEFCE00009463000000000000000000F7F7F700394A
      52008CFFFF0084FFFF0084FFFF007BFFFF007BFFFF007BFFFF007BFFFF007BFF
      FF007BFFFF007BFFFF007BFFFF00000000000000000000000000000000000000
      00000000000000000000B5B5C600316BAD00427BB5004A8CC6005A94CE0063A5
      D600637BAD00C6DEFF008C9CBD00000000000000000000000000E7D6B500FFE7
      AD00FFE7AD00FFDEA500FFDEA500FFDEA500F7CE9400FFFFEF00FFF7DE00F7E7
      CE00EFD6B500C6AD9C000000000000000000000000004A4AEF005252FF000808
      A5000000000008D6F70008DEFF00009CC60000000000F7C64200FFCE5A00B57B
      0000000000004AE7BD005AEFCE00009463000000000000000000CECECE00394A
      52009CFFFF0010AD4A008CFFFF0084FFFF007BFFFF007BFFFF007BFFFF007BFF
      FF007BFFFF007BFFFF007BFFFF00000000000000000000000000000000000000
      00008CA5C600F7F7FF00C6BDCE003973B5004A84BD005A94CE006B9CD60073B5
      E7006384AD00BDDEF700A5C6EF008C9CBD000000000000000000E7D6BD00FFE7
      B500FFE7B500FFE7AD00FFE7AD00FFDEA500F7CE9400F7CE9400F7CE9400F7CE
      9400F7CE9400C6AD9C000000000000000000000000004242EF005252FF000808
      A5000000000000CEEF0008DEFF00009CC60000000000F7BD4200FFCE5200B57B
      0000000000004ADEBD0052EFC6000094630000000000000000002129310084E7
      EF0010AD4A009CFFFF0010AD4A008CFFFF0084FFFF0021638400216384002163
      8400216384007BFFFF007BFFFF000000000000000000F7F7FF00EFEFF7008CA5
      C600A5C6EF0094B5DE00ADADBD00427BB5005294CE00639CD60073ADE7007BAD
      E700A5949C009CA5BD00B5E7FF0084ADD6000000000000000000E7D6BD00FFE7
      BD00FFE7BD00FFE7B500FFE7B500FFE7AD00FFDEAD00FFDEA500FFDEA500FFDE
      9C00FFDE9C00C6AD9C000000000000000000000000004242EF004A4AFF000808
      A5000000000000CEEF0008DEFF00009CC60000000000F7BD3900FFC64A00B57B
      00000000000042DEB5004AE7C6000094630000000000000000001821290094F7
      F700B5FFFF00A5FFFF009CFFFF0010AD4A008CFFFF0084FFFF0084FFFF007BFF
      FF007BFFFF007BFFFF007BFFFF000000000000000000C6C6D600395A8C00B5D6
      EF00C6EFFF009CADCE008C312900635273004A7BBD0063A5DE00638CC6008463
      7300AD5A5200A5524200948CA5008CA5C6000000000000000000E7DEC600FFEF
      C600FFEFC600FFE7BD00FFE7BD00A59C7B00FFE7B500FFE7AD00FFDEAD00FFDE
      A500FFDEA500C6AD9C00000000000000000000000000ADADFF00ADADFF000808
      A5000000000000CEEF0008DEFF00009CC60000000000F7B53100FFC64200B57B
      00000000000039DEB5004AE7BD00009463000000000000000000394242006B94
      9400BDFFFF00B5FFFF00ADFFFF00A5FFFF009CFFFF0094FFFF008CFFFF0084FF
      FF0084FFFF007BFFFF007BFFFF000000000000000000B5BDCE0042639400E7FF
      FF008CA5C6008C393100C64A2100846B7B00315A94007B424200315A94007B4A
      5A00AD392100C65A3900A5311800DEC6C6000000000000000000E7DEC600FFEF
      CE00FFEFCE00FFEFC600B5D68C0039731800A59C7B00FFE7B500FFE7AD00FFE7
      AD00FFDEA500C6AD9C0000000000000000000000000000000000000000000000
      00000000000000C6EF0008D6FF00009CC60000000000EFB52900FFBD3900B57B
      00000000000031D6AD0042E7BD00009463000000000000000000FFFFFF003139
      4200CEFFFF0010AD4A00BDFFFF00ADFFFF00A5FFFF009CFFFF0094FFFF008CFF
      FF0084FFFF0084FFFF007BFFFF0000000000EFF7F7006384B5004A639C008C9C
      BD00D6DEE7008C312900AD422900315A94009C636300AD4A3900315A9400315A
      9400CE5A3100BD5231008C312900000000000000000000000000E7DED600FFF7
      E700FFF7E700B5DE9C0031AD31004AB54A0039731800ADA57B00FFE7B500FFE7
      B500FFE7AD00C6AD9C0000000000000000000000000000000000000000000000
      00000000000000C6EF0000D6FF00009CC60000000000EFAD2900FFBD3900B57B
      00000000000031D6AD0039E7B500009463000000000000000000C6C6C6004252
      520010AD4A00CEFFFF0010AD4A00BDFFFF00B5FFFF0021638400216384002163
      8400216384008CFFFF0084FFFF0000000000EFF7F7005A8CB500426B9C008C9C
      BD0000000000DEC6C600315A9400B5422900D6A59400D6A59C00BD522900315A
      9400AD4A39008C312900EFE7E700000000000000000000000000E7E7D600FFF7
      EF00B5DEA50031AD310063DE63004AB54A0029AD290039731800ADA58400FFE7
      BD00FFE7B500C6AD9C0000000000000000000000000000000000000000000000
      000000000000ADF7FF00ADF7FF00009CC60000000000EFAD2100FFBD3100B57B
      00000000000029D6A50031E7B50000946300000000000000000021293100ADDE
      DE00DEFFFF00D6FFFF00CEFFFF0010AD4A00BDFFFF00B5FFFF00ADFFFF00A5FF
      FF009CFFFF0094FFFF008CFFFF000000000000000000ADB5CE0042639400D6E7
      EF000000000000000000CEB5BD008C312900A5A5AD00A5A5BD008C423900315A
      94008C312900EFE7E70000000000000000000000000000000000E7E7DE00FFFF
      EF0031AD310031AD310063DE63004AB54A0029AD29003973180039731800FFEF
      CE00FFE7BD00C6AD9C0000000000000000000000000000000000000000000000
      000000000000FFFFFF00000000000000000000000000EFAD2100F7B53100B57B
      00000000000029D6A50031DEAD0000946300000000000000000021293100E7FF
      FF00E7FFFF00E7FFFF00DEFFFF00D6FFFF00CEFFFF00C6FFFF00BDFFFF00B5FF
      FF00A5FFFF009CFFFF0094FFFF000000000000000000BDC6D60063739C000000
      0000000000000000000000000000B5BDD6005A8CB5008CC6EF005A8CB500FFFF
      FF00000000000000000000000000000000000000000000000000E7E7DE00FFFF
      F700FFFFEF00FFFFEF005AD65A0042D6420010A51000A5B58C00FFF7DE00FFF7
      DE00FFEFCE00C6AD9C0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000EFAD2100F7B53100B57B
      00000000000021D69C0029DEAD00009463000000000000000000313942007B94
      9400E7FFFF0010AD4A00E7FFFF00DEFFFF00D6FFFF00CEFFFF00C6FFFF00BDFF
      FF00B5FFFF00ADFFFF00A5FFFF000000000000000000C6C6D6006B7BA5000000
      00000000000000000000FFFFFF00638CB500E7F7FF00C6E7FF00638CB500EFEF
      F700000000000000000000000000000000000000000000000000E7E7DE00FFFF
      F700FFFFF700FFFFEF006BE76B0042D6420029B52900ADBD9400FFF7E700FFF7
      DE00FFF7D600C6AD9C0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFE7AD00FFE7AD00B57B
      00000000000021CE9C0029DEAD00009463000000000000000000FFFFFF004A5A
      5A0010AD4A00E7FFFF0010AD4A00E7FFFF002163840021638400D6FFFF000000
      00000000000000000000000000000000000073736B006B6B6B00636363006B6B
      6300E7DEE70000000000ADA5DE001018CE00004AFF00004AFF00316BB5009CB5
      C600000000000000000000000000000000000000000000000000E7E7DE00FFFF
      F700FFFFF700FFFFF7006BE76B0042D6420039BD3900B5BD9C00FFF7E700FFF7
      E700FFF7E700C6AD9C0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000021CE9C0029DEAD00009463000000000000000000ADADAD004A52
      5A00E7FFFF00E7FFFF00E7FFFF0010AD4A00E7FFFF00E7FFFF00DEFFFF000000
      00007BFFFF00DEFFFF000000000000000000000000006B6B6B006B6B6B006B6B
      6B00C6C6C600000000001018CE00426BE7001852E7000029E7001018CE00BDBD
      DE00000000000000000000000000000000000000000000000000E7E7DE00ADBD
      9400527B1800527B1800527B180039BD39007BE77B00B5BD9C00E7E7D600E7E7
      D600E7DED6000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A5FFE700A5FFE70000946300000000000000000021293100BDF7
      F700E7FFFF00E7FFFF00E7FFFF00E7FFFF00E7FFFF00E7FFFF00E7FFFF000000
      0000EFFFFF0000000000000000000000000000000000EFEFEF00E7E7E700E7E7
      E700FFFFFF0000000000EFE7F700295AEF00006BFF00004AFF002131E700F7EF
      F700000000000000000000000000000000000000000000000000000000000000
      0000BDCEAD00527B180039BD39007BE77B00DEFFDE0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000B5A5E700394AE7003942E700BDADE7000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F7EFEF00B5734A009439
      0000B5734A00F7EFE70000000000000000000000000000000000F7EFEF00B573
      4A0094390000B5734A00EFE7DE00000000000000000000000000000000000000
      0000E7E7E70063636300636363006363630063635A00635A5A00635A5A00635A
      5A0063635A005252520052525200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B57B52008C310000A55A
      3100A5521800BD844A00FFF7EF000000000000000000FFF7F700BD844200A552
      0800A56331008C310000B57B5200000000000000000000000000FFFFFF00FFFF
      FF00DEDEDE0052525200FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00E7DE
      D600E7DED600D6C6B500525252000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A55A2100AD5A00000000
      0000CE945200B5732900C68C52000000000000000000C68C5200B5730000CE94
      420000000000AD5A0800A55A1800000000000000000000000000000000000000
      0000E7E7E70052525200B5B5B5008C8C8C009494940094949400949494009494
      94008C8C8C00BDB5AD0052525200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CE9C6300C67B0000F7E7
      A50000000000CE943900AD5A0800FFF7F700FFFFFF00AD5A0000CE9418000000
      0000FFEFB500C67B0000CE9C630000000000000000004A4A4A005A5A5A005A5A
      5A00BDBDBD0052525200FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00E7DE
      D600E7DED600D6CEC60052525200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D6942900E7A5
      0000F7E7B500D6943100A5520000F7EFE700FFF7EF00A5520000D6942900F7E7
      B500E7A50800D6942100FFFFFF00000000000000000052525200BDBDBD00D6D6
      D600ADADA50052525200BDBDBD00949494009C9C9C009C9C9C009C9C9C009C9C
      9C0094949400C6C6BD005252520000000000000000001818AD001818AD001818
      AD001818AD001818AD001818AD001818AD0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004AA521004AA521004AA521004AA5
      21004AA521004AA521004AA52100000000000000000000000000E7BD7300DEA5
      1800C6841800CE8C3100A5521000FFF7F700FFFFFF00A5520800C68C3100C684
      2100DEA51800E7BD730000000000000000000000000052525200D6D6D600A5A5
      A5008C8C8C0052525200FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00D6CEC6005252520000000000000000001818AD002939F700314A
      EF00314AEF00294AEF001818AD0000000000FFFFFF0000000000000000000000
      000000000000FFFFFF00C6CEEF00CED6EF009CC68C0000000000FFFFFF000000
      000000000000000000000000000000000000C6DEB5004AA521005AB55A005AB5
      5A005AB55A005AB55A004AA5210000000000000000000000000000000000DEB5
      7300CE944A00BD844A00A56B4200D6D6D600D6DEDE00AD6B4A00BD844A00CE94
      4A00DEB573000000000000000000000000000000000052525200DEDEDE00D6D6
      D600ADADAD0052525200C6C6C600A5A5A500A5A5A500A5A5A500A5A5A500A5A5
      A5009CA59C00CECECE005252520000000000000000001818AD002121EF002931
      EF002939EF002939EF002931BD005A63D600ADB5EF00D6D6F700D6DEF700CED6
      F7009494BD005252CE003131BD00EFEFFF004A9C18004A9C1800C6DEB5000000
      0000CEE7C600DEEFD600DEEFD600C6DEB5004A9C18004AA521005AB55A0042AD
      390042AD31005AB55A004AA52100FFFFFF000000000000000000000000000000
      000000000000B5735200D6CEC600A5A5A500A5A5A500DED6D600B57B5A000000
      0000000000000000000000000000000000000000000052525200CECECE00A5A5
      A5008C8C8C0052525200FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00DEDEDE005252520000000000000000001818AD002110E7002121
      EF002931EF002939EF002131EF002929DE002931CE002931BD003131BD002931
      BD002929C6003131BD00D6D6F700000000009CC68C005AB55A004A9C18004A9C
      18004AA521004AA521004AA521004AA521004AA521005AB55A004AA5310042A5
      310042AD31005AB55A004AA52100000000000000000000000000000000000000
      000000000000000000009C9C9C00EFEFEF00DEDEDE009C9C9C00000000000000
      0000000000000000000000000000000000000000000052525200E7E7E700EFEF
      EF00BDBDBD0052525200C6C6C600A5A5A500A5A5A500A5A5A500FFFFFF00FFFF
      FF00FFFFFF00B5B5B5005252520000000000000000001818AD002931E7004263
      E7003952EF003952EF00394AEF003952EF00314AE7003142E7003142DE002939
      CE003142C600B5BDEF0000000000FFFFFF00000000004A9C18005AB55A0063A5
      31005AB55A005AB55A005AB55A005AB55A005AB55A0052A5420052AD42005AB5
      5A005AB55A005AB55A004AA52100000000000000000000000000000000000000
      000000000000F7F7F700A5A5A500EFEFEF00DEDEDE00A5A5A500EFEFEF000000
      0000000000000000000000000000000000000000000052525200C6C6C6008C8C
      8C007B7B7B005252520000000000000000000000000000000000000000008484
      7B0084847B0084847B005252520000000000000000001818AD001818AD003131
      BD00525AD6004263E7004263EF00425AE700425AE7004252DE003942CE003131
      BD00ADBDE70000000000000000000000000000000000000000004A9C18005AB5
      5A0063A5310063A5310063A5390063A5390063A5420063A542005AB55A005AB5
      5A004AA521004AA521004AA52100000000000000000000000000000000000000
      0000000000009C9C9C00F7F7F700DEDEDE00DEDEDE00F7F7F7009C9C9C000000
      0000000000000000000000000000000000000000000052525200E7E7E700EFEF
      EF00C6C6C6005A5A5A0000000000000000000000000000000000000000008484
      7B00CECEC6005A5A5A00FFFFFF0000000000000000001818AD0000000000FFFF
      FF00ADADE700525ACE003131BD003131BD003131BD003942C600737BD600D6DE
      F700000000000000000000000000000000000000000000000000000000004A9C
      18005AB55A005AB55A005AB55A005AB55A005AB55A004AA5210084B56300CEE7
      C60000000000D6E7CE004AA52100000000000000000000000000000000000000
      0000EFEFEF00A5A5A500EFEFEF00ADADAD00ADADAD00F7F7F700C6C6C600EFEF
      EF00000000000000000000000000000000000000000052525200C6C6C6008484
      84007373730052525200B5B5B500B5B5B500BDBDBD00B5B5B500BDBDBD008484
      7B0052525200FFFFFF000000000000000000000000000000000000000000FFFF
      FF000000000000000000F7F7FF00DEE7F700D6DEF700E7EFF700000000000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      0000B5D6A50094C6840063A542006BAD4A009CC68400B5D6A500E7EFDE000000
      0000000000000000000000000000000000000000000000000000000000000000
      00009C9C9C00F7F7F700A5A5A5000000000000000000ADADAD00F7F7F7009C9C
      9C00000000000000000000000000000000000000000052525200EFEFEF00FFFF
      FF00F7F7F7004A4A4A005A5A5A005A5A5A005252520052525200525252005A5A
      5A00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000F7F7
      F700A5A5A500F7F7F700ADADAD000000000000000000ADADAD00F7F7F700A5A5
      A500EFEFEF000000000000000000000000000000000052525200F7F7F7000000
      0000000000000000000000000000EFEFEF0084847B00E7DED6005A5A5A000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000A5A5
      A500F7F7F700ADADAD0000000000000000000000000000000000ADADAD00F7F7
      F700A5A5A5000000000000000000000000000000000052525200E7E7E700F7F7
      F700F7F7F700F7F7F700F7F7F700DEDEDE0084847B005A5A5A00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000DEDE
      DE00A5A5A500000000000000000000000000000000000000000000000000ADAD
      AD00DEDEDE000000000000000000000000000000000052525200525252005252
      5200525252005252520052525200525252004A4A4A0000000000FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000848484000000000084848400848484000000000000000000000000008484
      8400848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C6DEC6000000
      000000000000000000000000000000000000A5A5A50000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000A5A5A5000000000000000000000000000000
      000000000000C6DEC60000000000000000000000000000000000FF000000FF00
      0000848484000000000000000000848484008484840084848400000000000000
      0000848484008484840000000000000000000000000000000000000000000000
      0000000000000000000000000000848484000000000084848400000000008484
      8400000000008484840000000000000000000000000000000000A5A5A5000000
      000084848400000000000000000000000000C6DEC60000000000000000000000
      0000000000000000000000000000C6DEC600C6DEC60000000000000000000000
      0000000000000000000000000000C6DEC6000000000000000000000000008484
      840000000000A5A5A50000000000000000000000000000000000000000000000
      0000848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C6DEC60000000000A5A5A5000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C6DEC6000000000000000000C6DEC600000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A5A5A50000000000C6DEC6000000000000000000FF000000FF00
      0000848484000000000084848400848484000000000084848400848484008484
      8400000000000000000000000000000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000000000000000
      00000000000000000000000000000000000000000000C6DEC600000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000042424200A5A5A5000000000000000000A5A5A500424242000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C6DEC600000000000000000000000000000000000000
      0000848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A5A5A500000000000000
      00000000000000000000C6DEC6000000000000000000C6DEC60000000000A5A5
      A500000000000000000000000000000000000000000000000000000000000000
      0000A5A5A50000000000C6DEC6000000000000000000C6DEC600000000000000
      00000000000000000000A5A5A500000000000000000000000000FF000000FF00
      0000848484000000000084848400848484008484840000000000000000008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000008484840000000000848484000000000084848400848484000000
      0000848484000000000000000000000000000000000000000000848484000000
      000000000000A5A5A50000000000C6DEC6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C6DEC60000000000A5A5A5000000
      0000000000008484840000000000000000000000000000000000000000000000
      0000848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400000000004221210000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000422121000000
      0000848484000000000000000000000000000000000000000000848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008484840000000000000000000000000000000000000000000000
      0000000000008484840084848400848484008484840084848400848484008484
      8400848484008484840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F7CEA5000000
      8400000084000000840000008400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F7CEA500000084000000
      8400000084000000840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      00000000000000000000000000000000FF000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F7CEA500000084000000
      8400000084000000840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000FF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000FF0000008484
      8400848484000000000000000000000000008484840084848400848484008484
      8400FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000008400000084000000
      8400000084000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000FF000000FF000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C6C6C600C6C6C600FF0000008484
      84008484840084848400FFFFFF00000000000000000084848400848484008484
      8400FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000008484000084840000000084000000
      8400F7CEA5000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000840000008400
      000084000000840000008400000000000000000000000000000000000000FFFF
      FF0000FF000000FF000000FF0000000000000000000000000000000000000000
      000000000000000000000000000000000000C6C6C600C6C6C600FF0000008484
      84008484840084848400FFFFFF00000000000000000084848400848484008484
      8400FF0000000000FF00FF000000FF0000000000000000000000000000000000
      0000000000000000000084840000848400008484000084840000848400008484
      00000000000000000000000000000000000000000000FFFF0000840000008400
      00000000000000000000000000000000000000000000FFFF0000FF000000FF00
      0000FF000000FF0000008400000000000000000000000000000000000000FFFF
      FF0000FF000000FF000000FF000000FF00000000000000000000000000000000
      000000000000000000000000000000000000C6C6C600C6C6C600FF0000008484
      8400848484008484840000000000000000000000000084848400848484008484
      8400FF00000000FFFF0000FFFF00FF0000000000000000000000000000000000
      0000000000008484000084840000848400008484000084840000848400008484
      00000000000000000000000000000000000000000000FF000000FF0000008400
      0000840000000000000000000000000000000000000000000000FFFF0000FF00
      0000FF000000FF0000008400000000000000000000000000000000000000FFFF
      FF0000FF000000FF000000FF000000FF000000FF000000000000000000000000
      000000000000000000000000000000000000C6C6C600C6C6C600FF0000008484
      8400848484008484840000000000000000000000000084848400848484008484
      8400FF00000000FFFF0000FFFF00000084000000000000000000000000008484
      0000848400008484000084840000848400008484000084840000848400008484
      00000000000000000000000000000000000000000000FFFF0000FF000000FF00
      000084000000840000008400000084000000840000008400000084000000FF00
      0000FF000000FF0000008400000000000000000000000000000000000000FFFF
      FF0000FF000000FF000000FF000000FF000000FF000000000000000000000000
      000000000000000000000000000000000000C6C6C60084848400FF0000008484
      8400848484008484840000000000000000000000000084848400848484008484
      8400FF0000000000000000000000000084000000000000000000848400008484
      0000848400008484000084840000848400008484000084840000848400008484
      0000000000000000000000000000000000000000000000000000FFFF0000FF00
      0000FF00000000000000FF00000000000000FF000000FF000000FF000000FF00
      0000FFFF0000FF0000008400000000000000000000000000000000000000FFFF
      FF0000FF000000FF000000FF000000FF000000FF000000000000000000000000
      00000000000000000000000000000000000084848400FF000000000000008484
      8400848484008484840084848400848484008484840084848400848484008400
      0000C6C6C6000000000000000000000084000000000084840000848400008484
      0000848400008484000084840000848400008484000084840000848400008484
      000000000000000000000000000000000000000000000000000000000000FFFF
      0000FFFF0000FF000000FF000000FF000000FF000000FF000000FF000000FFFF
      000000000000FFFF00000000000000000000000000000000000000000000FFFF
      FF0000FF000000FF000000FF000000FF00000000000000000000000000000000
      000000000000000000000000000000000000C6C6C60084848400FF0000000000
      FF0084848400848484008484840084848400848484008484840084000000C6C6
      C600FF000000FF00000084000000FF0000008484000084840000848400008484
      0000848400008484000084840000848400008484000084840000848400008484
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000FF000000FF000000FF0000000000000000000000000000000000000000
      000000000000000000000000000000000000C6C6C600C6C6C60084848400FF00
      0000000000008484840084848400848484008484840084000000C6C6C600FF00
      0000FF000000FF000000FF000000C6C6C6000000000084840000848400008484
      0000848400008484000084840000848400008484000084840000848400008484
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000FF000000FF000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C6C6C600C6C6C600C6C6C6008484
      8400FF00000000000000848484008484840084000000FFFFFF00FF000000FF00
      00000000000084000000C6C6C600C6C6C6000000000000000000848400008484
      0000848400008484000084840000848400008484000084840000848400000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000FF00000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C6C6C600C6C6C600C6C6C600C6C6
      C60084848400FF0000000000000084848400FFFFFF00FF000000FF0000008484
      840000000000C6C6C600C6C6C600C6C6C6000000000000000000000000000000
      0000848400008484000084840000848400008484000084840000848400000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C60084848400FF000000FFFFFF00FF000000FF000000000000008484
      840000000000C6C6C600C6C6C600C6C6C6000000000000000000000000000000
      0000000000000000000084840000848400008484000084840000848400000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600FF000000FF000000FF000000FF000000000000008484
      840000000000C6C6C600C6C6C600C6C6C6000000000000000000000000000000
      0000000000000000000000000000000000008484000084840000848400000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600000000008484
      840000000000C6C6C600C6C6C600C6C6C6000000000000000000000000000000
      0000000000000000000000000000C6C6C6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00009C9C9C00C6C6C600FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000084E7E70042C6E700F7FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000002142000000
      000000000000000000000000000084848400F7FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C6C6C600ADADAD00D6D6D600CECECE00EFEFEF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004200
      C6004200C6004200C6004200C6000000000000000000000000000000000042C6
      E70042C6E700008400000084000042C6E7000000000000000000000000000000
      0000008400000084000000840000000000000000000000000000424200000000
      0000000000000000000000000000C6C6C60000000000F7FFFF00000000000000
      000000000000F7FFFF0000000000F7FFFF000000000000000000000000000000
      0000FFFFFF00D6D6D60000000000FFFFFF00DEDEDE0084C6EF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004200
      C6000063E7000063E7004200C6000000000000000000F7FFFF0042C6E70042A5
      E700008400000084000042A5E70042A5E70084C6E70000000000000000000000
      0000008400000084000000840000008400000000000000000000F7FFFF000000
      000000000000000000000000000000000000F7FFFF0000000000000000000000
      0000F7FFFF000000000000000000000000007B7B7B007B7B7B007B7B7B007B7B
      7B00DEDEDE00CECECE00FFFFFF000000000039ADFF0039ADFF009CD6FF00EFEF
      EF008C8C8C007B7B7B007B7B7B007B7B7B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004200
      C6000063E7000063E7004200C6000000000000000000F7FFFF0042C6E7000084
      00000084000084C6E70084C6E70084C6E70084A5E700F7FFFF00000000000000
      00000084000000840000008400000084000000000000F7FFFF00000000008484
      840042000000C6C6C60000000000F7FFFF0000000000F7FFFF0000000000F7FF
      FF00000000000000000000000000F7FFFF007B7B7B00DEBD7B00000000000000
      0000EFD6A500EFEFEF00DEDEDE0039ADFF0039ADFF0039ADFF0039ADFF009CD6
      FF000000000000000000000000007B7B7B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004200
      C6004200C6004200C6004200C6000000000084C6E70084C6E700008400000084
      0000008400000084000042A5E7004284E7004284E70042C6E700000000000000
      0000008400000084000000840000008400000000000000000000000000000000
      00008463C600844263008442E700C6C6A5000000000000000000F7FFFF000000
      0000000000000000000000000000000000007B7B7B00DEBD7B00DEBD7B00DEBD
      7B00DEBD7B00EFEFEF0084C6EF0039ADFF0039ADFF0039ADFF0039ADFF0039AD
      FF009CD6FF0000000000000000007B7B7B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000084C6E700008400000084000042A5
      E70042A5E70000840000008400000084000000840000008400004284E7000000
      00000084000000840000008400000000000000000000F7FFFF00000000000000
      0000000000008442C600FF00FF00C600E70084A5C600F7FFFF00000000000000
      000000000000F7FFFF0000000000F7FFFF007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B008C8C8C00EFEFEF009CD6FF0039ADFF0039ADFF0039ADFF0039AD
      FF0039ADFF00DEB57B00EFEFEF008C8C8C000000000000000000C684C600C684
      C600C684C6000000000000000000000000000000000000000000000000004200
      C6004200C6004200C6004200C60000000000C6DEC600008400000084000042C6
      E70042C6E7000084000042C6E70042A5E70042A5E70042A5E70042A5E70042A5
      E70000840000008400000000000000000000F7FFFF0000000000000000000000
      00000000000084C66300C600E700FF00FF00C600E7008463C600000000000000
      0000F7FFFF0000000000F7FFFF00000000007B7B7B00DEBD7B00000000000000
      0000DEBD7B007B7B7B0000000000000000009CD6FF0039ADFF0039ADFF0039AD
      FF0073948400B5730000DEB57B00EFEFEF000000000000000000C684C600C684
      C600C684C6000000000000000000000000000000000000000000000000004200
      C6000063E7000063E7004200C600000000000000000084C6E700008400000084
      000042A5E7000084000042A5E70042A5E70042A5E70042A5E70042A5E70042A5
      E7000084000000000000000000000000000000000000F7FFFF0000000000F7FF
      FF0000000000F7FFFF008463A500FF00FF00FF00FF00C600E700C6A5C6000000
      000000000000F7FFFF0000000000F7FFFF007B7B7B00DEBD7B00DEBD7B00DEBD
      7B00DEBD7B007B7B7B000000000000000000000000009CD6FF0039ADFF007394
      8400B5730000B57300007B637B0094A5FF000000000000000000C684C600C684
      C600C684C6000000000000000000000000000000000000000000000000004200
      C6000063E7000063E7004200C60000000000000000000000000084C6E7000084
      0000008400000084000084C6E70084C6E70084C6E70084C6E70084C6E70084C6
      E700000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C6A5E7008442C600FF00FF00FF00FF008400A50084C6
      C600000000000000000000000000000000007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B008C8C8C00EFEFEF00DEB57B00B573
      0000B57300007B637B003152FF003152FF000000000000000000C684C600C684
      C600C684C6000000000000000000000000000000000000000000000000004200
      C6004200C6004200C6004200C6000000000000000000000000000000000084C6
      E70084C6E70084C6E70084C6E70084C6E700C6DEC60000000000000000000000
      00000000000000000000000000000000000000000000F7FFFF0000000000F7FF
      FF0000000000F7FFFF000000000084E7E7008463C600FF00FF00C600C6008442
      A500000000000000000000000000F7FFFF007B7B7B00DEBD7B00000000000000
      0000DEBD7B007B7B7B0000000000000000000000000000000000EFEFEF00DEB5
      7B007B637B003152FF003152FF005273FF000000000000000000C684C600C684
      C600C684C6000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000F7FF
      FF0084E7E700C6C6C600C6DEC600C6DEC6000000000000000000000000000000
      000000000000000000000000000000000000F7FFFF0000000000000000000000
      0000F7FFFF0000000000F7FFFF0000000000C6A5E700C663A5008400E700C600
      E700C642A5000000000000000000000000007B7B7B00DEBD7B00DEBD7B00DEBD
      7B00DEBD7B007B7B7B00000000000000000000000000000000008C8C8C000000
      000094A5FF003152FF005273FF00E7EFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004200
      C6004200C6004200C6004200C600000000000000000000000000000000000000
      0000C6A54200C6A54200C6DEC600000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F7FFFF0000000000F7FF
      FF0000000000F7FFFF0000000000F7FFFF0000000000F7FFFF008463A500C600
      E700FF00FF008463C60000000000F7FFFF007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B008C8C
      8C00EFEFEF0000000000F7F7F700B5B5B5000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004200
      C6000063E7000063E7004200C60000000000000000000000000000000000C6A5
      4200C6A54200F7FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F7FFFF000000
      000000000000000000000000000000000000F7FFFF00000000000000000084C6
      C600C600C600FF00FF00C6A5E700000000007B7B7B00DEBD7B00D6B57B009C94
      7B00B5A57B007B7B7B00DEBD7B000000000000000000DEBD7B007B7B7B00DEBD
      7B000000000000000000DEBD7B007B7B7B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004200
      C6000063E7000063E7004200C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F7FFFF0000000000F7FF
      FF0000000000F7FFFF0000000000F7FFFF0000000000F7FFFF00000000000000
      000000000000FF00FF008442C600F7FFFF007B7B7B00B5A57B009C947B00D6B5
      7B00DEBD7B007B7B7B00DEBD7B00DEBD7B00DEBD7B00DEBD7B007B7B7B00DEBD
      7B00DEBD7B00DEBD7B00DEBD7B007B7B7B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004200
      C6004200C6004200C6004200C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F7FFFF0000000000F7FFFF000000
      0000F7FFFF00000000000000000000000000F7FFFF0000000000000000000000
      0000000000000000000000000000000000007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484000000000000008400000084
      00000000000000FF000000FF0000000000008484000084840000000000000084
      00000084000000000000848400008484000000000000F7FFFF00F7FFFF00F7FF
      FF0000000000F7FFFF00000000000000000000000000F7FFFF00F7FFFF000000
      0000F7FFFF00F7FFFF00F7FFFF00000000000000000000000000000000000000
      0000000000000000000000000000C6C6C6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484000000000000008400000084
      00000000000000FF000000FF0000000000008484000084840000000000000084
      000000840000000000008484000084840000F7FFFF0000000000F7FFFF00F7FF
      FF0000000000C6A5A50042210000422100004200000042212100C684A500F7FF
      FF0000000000F7FFFF0000000000000000000000000000000000002142000000
      000000000000000000000000000084848400F7FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484000000000000008400000084
      00000000000000FF000000FF0000000000008484000084840000000000000084
      000000840000000000008484000084840000000000000000000000000000F7FF
      FF00420000008421210042000000420000004200000042000000420021004200
      0000C6C6C6000000000000000000000000000000000000000000424200000000
      0000000000000000000000000000C6C6C60000000000F7FFFF00000000000000
      000000000000F7FFFF0000000000F7FFFF000000000084000000840000008400
      00008400000084000000840000000000000000000000FF000000FF0000000000
      0000FF000000FF00000000000000000000008484000000000000008400000084
      00000000000000FF000000FF0000000000000000000000000000000000000084
      0000008400000000000084840000848400000000000000000000F7FFFF004200
      00008421210042000000F7FFFF000000000000000000F7FFFF00420000004200
      210042214200F7FFFF00F7FFFF00000000000000000000000000F7FFFF000000
      000000000000000000000000000000000000F7FFFF0000000000000000000000
      0000F7FFFF000000000000000000000000000000000084000000840000008400
      00008400000084000000840000008400000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000000000008484000000000000008400000084
      00000000000000FF000000FF0000000000000000000000000000000000000084
      00000084000000000000848400008484000000000000F7FFFF00F7CEA5004200
      00004200000000000000C6A5A5004200000042000000C6A5A500F7FFFF004221
      210042000000C6A5A500000000000000000000000000F7FFFF00000000004263
      63004200000084A5A50000000000F7FFFF0000000000F7FFFF0000000000F7FF
      FF00000000000000000000000000F7FFFF000000000084000000840000000000
      00000000000084000000840000008400000000000000FF000000FF000000FF00
      000000000000FF000000FF000000FF0000008484000000000000008400000084
      00000000000000FF000000FF0000000000000000000000000000000000000084
      00000084000000000000848400008484000000000000F7FFFF00420000004221
      000000000000C684840042212100F7CEA500F7FFFF0042002100C6A5A500F7FF
      FF004200000084212100F7CEA500000000000000000000000000000000000000
      00008463C600FF000000C6426300C6C6C6000000000000000000F7FFFF000000
      0000000000000000000000000000000000000000000084000000840000000000
      00000000000000000000840000008400000000000000FF000000FF0000000000
      00000000000000000000FF000000FF0000008484000000000000008400000084
      00000000000000FF000000FF0000000000000000000000000000000000000084
      0000008400000000000000000000000000000000000000000000422121004200
      00000000000042212100F7FFFF004200210042002100F7FFFF0042000000F7FF
      FF008421210042210000F7CEA5000000000000000000F7FFFF00000000000000
      000000000000C6004200F7CEA500C6420000C6A56300F7FFFF00000000000000
      000000000000F7FFFF0000000000F7FFFF000000000084000000840000000000
      00000000000000000000840000008400000000000000FF000000FF0000000000
      00000000000000000000FF000000FF0000008484000000000000008400000084
      00000000000000FF000000FF0000000000000000000000000000000000000084
      00000084000000000000000000000000000000000000F7FFFF00F7FFFF00F7FF
      FF00F7FFFF00F7FFFF00F7FFFF004200210042002100F7FFFF00420000000000
      000042000000422100000000000000000000F7FFFF0000000000000000000000
      000000000000A5A5A500C6420000FFFF0000C6420000C6636300F7FFFF000000
      0000F7FFFF0000000000F7FFFF00000000000000000084000000840000008400
      00008400000084000000840000000000000000000000FF000000FF000000FF00
      000000000000FF000000FF000000FF0000008484000000000000000000000000
      00000000000000FF000000FF0000000000000000000000000000000000000084
      000000840000000000000000000000000000F7FFFF0000000000F7FFFF004221
      A5000021C6000021A5004221A500F7FFFF00F7FFFF0084212100C6848400F7FF
      FF00842121004200000000000000F7FFFF0000000000F7FFFF0000000000F7FF
      FF0000000000F7FFFF00C663420084630000FFFF0000C6420000C6A563000000
      000000000000F7FFFF0000000000F7FFFF000000000084000000840000008400
      00008400000084000000840000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000000000008484000000000000000000000000
      00000000000000FF000000FF0000000000000000000000000000000000000084
      00000084000000000000000000000000000000000000F7FFFF00F7FFFF00C6A5
      E7000021C6000021C6004221A500F7FFFF0084214200C684A500F7FFFF004200
      000042000000C6A5C600F7FFFF00F7FFFF000000000000000000000000000000
      00000000000000000000C6A5E70084636300C6630000FFFF0000FF00000084C6
      E700000000000000000000000000000000000000000084000000840000000000
      00000000000084000000840000000000000000000000FF000000FF0000000000
      0000FF000000FF00000000000000000000008484000000000000000000000000
      00000000000000FF000000FF0000000000000000000000000000000000000084
      00000084000000000000000000000000000000000000F7FFFF00C6A5E7000021
      C6000021E7000021C6004242A500C6A5E700F7FFFF00F7FFFF00420000004221
      210042002100F7FFFF00F7FFFF00F7FFFF0000000000F7FFFF0000000000F7FF
      FF0000000000F7FFFF0000000000C6A5E70084A5630084630000FFFF0000C600
      6300000000000000000000000000F7FFFF000000000084000000840000000000
      00000000000084000000840000000000000000000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000004284000021
      A5000042C60084C6E70000218400F7FFFF004200210042212100420000004200
      0000F7FFFF000000000000000000F7FFFF00F7FFFF0000000000000000000000
      0000F7FFFF0000000000F7FFFF0000000000C6A5E70084A54200C6840000FFFF
      0000C642A500F7FFFF0000000000000000000000000084000000840000008400
      00008400000084000000840000000000000000000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F7FFFF00F7FFFF004242
      8400C6DEC600F7FFFF00F7FFFF00C6DEC6004221210000000000C6A5A500F7FF
      FF00F7FFFF0000000000F7FFFF00F7FFFF0000000000F7FFFF0000000000F7FF
      FF0000000000F7FFFF0000000000F7FFFF0000000000F7FFFF00C6634200C642
      0000FFFF0000C642630000000000F7FFFF000000000084000000840000008400
      00008400000084000000000000000000000000000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F7FFFF00F7FFFF00F7FF
      FF00F7FFFF00F7FFFF00F7FFFF00F7FFFF00F7FFFF00F7FFFF00000000000000
      0000F7FFFF00F7FFFF00F7FFFF00F7FFFF000000000000000000F7FFFF000000
      000000000000000000000000000000000000F7FFFF00000000000000000084C6
      E70084634200C6A50000F7CEA500000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000F7FF
      FF00F7FFFF00F7FFFF0000000000F7FFFF00F7FFFF00F7FFFF00000000000000
      000000000000F7FFFF00F7FFFF00F7FFFF0000000000F7FFFF0000000000F7FF
      FF0000000000F7FFFF0000000000F7FFFF0000000000F7FFFF00000000000000
      000000000000FF000000C6426300F7FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F7FFFF00F7FFFF000000
      0000F7FFFF00F7FFFF0000000000F7FFFF00F7FFFF00F7FFFF00000000000000
      0000F7FFFF00F7FFFF00F7FFFF00F7FFFF00F7FFFF0000000000F7FFFF000000
      0000F7FFFF00000000000000000000000000F7FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0084848400FFFFFF00FFFFFF00FFFFFF008484
      8400000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF00FF000000FF0000000000FF00000000000000
      0000000000000000000000000000000000008484840084000000FF0000008400
      0000848484008484840000000000848484008484840084848400848484008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008400000084
      0000000000000000000000000000000000000000000084848400848484008484
      8400848484008484840000000000848484008484840084848400848484008484
      8400000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF0000000000000000000000000084000000FF000000FF000000FF00
      0000000000008484840000000000000000000000000000000000848484008484
      8400848484008484840084848400848484000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000008400000084
      000000FF000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0084848400FFFFFF00FFFFFF00FFFFFF008484
      84000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF00FF000000FF0000000000FF000000FF000000
      FF000000FF000000FF000000000000000000848484000000840000008400FF00
      0000FF0000008400000000000000000000000000000000000000000000000000
      0000848484008484840084848400848484000000000000000000000000000000
      00000000000000000000000000000000000084000000008400000084000000FF
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF008484
      84000000000000000000000000000000000000000000000000000000FF00FFFF
      FF000000FF000000FF000000FF00FF000000FF0000000000FF000000FF00FFFF
      FF000000FF000000FF0000000000000000000000000000000000848484000000
      84000000840000008400FF000000FF000000FF000000FF000000840000008484
      8400FFFFFF000000000000000000FFFFFF000000000000000000000000000000
      000000000000000000000000000000000000840000000084000000FF00000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF0000000000FFFFFF008484
      840000000000000000000000000000000000000000000000FF000000FF000000
      FF00FFFFFF00FFFFFF000000FF00FF000000FF000000FFFFFF00FFFFFF000000
      FF000000FF000000FF0000000000000000000000000000000000000000008484
      8400000084000000840000008400FF000000FF000000FF000000FF0000008484
      840000000000FFFFFF0000FFFF00000000000000000000000000000000000000
      000000000000000000000000000084000000008400000084000000FF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000848484000000000000FFFF00000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF00FFFFFF00FFFFFF00FF000000FF000000FF0000000000FF000000
      FF000000FF000000FF000000FF0000000000000000000000000000000000FF00
      0000848484008484840000008400FF000000FF000000FF000000FF0000008400
      00000000000000FFFF0000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000840000000084000000840000000000000000
      0000000000000000000000000000000000000000000084840000848400008484
      00008484000084840000000000008484840084848400FFFFFF00000000008484
      840000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF000000FF00FFFFFF00FF000000FF000000FF000000FF0000000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      000000000000000000008484840000008400000084000000840000008400FF00
      00000000000000FFFF0000FFFF00000000000000000000000000000000000000
      0000840000008400000084000000008400000084000000840000000000000000
      0000000000000000000000000000000000000000000084840000848400008484
      000084840000FFFF00000000000084848400FFFFFF00FFFFFF0000FFFF000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF00FF000000FF000000FF000000FFFFFF00FFFFFF00FF000000FF0000000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000084000000840000008400000084000000
      000000FFFF00FFFFFF0000FFFF00FFFFFF000000000000000000000000000000
      000000FF000000FF000000FF000000FF00000084000000FF0000000000000000
      00000000000000000000000000000000000000000000FFFF000084840000FFFF
      000084840000FFFF0000000000008484840084848400848484000000000000FF
      FF00FFFFFF00000000000000000000000000000000000000FF000000FF000000
      FF00FF000000FF000000FF000000FF000000FF000000FF000000FF0000000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      00000000000000000000000000000000840000008400000084000000840000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000008400
      000000FF0000008400000084000000FF000000FF000000000000000000000000
      0000000000000000000000000000000000000000000084840000848400008484
      000084840000FFFF00000000000084848400FFFFFF00FFFFFF00FFFFFF008484
      8400FFFFFF00FFFFFF000000000000000000000000000000FF000000FF000000
      FF00FF000000FF000000FF000000FF000000FF000000FF000000FF0000000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000FFFF00FFFFFF000000000000000000000000008400
      0000008400000084000000840000008400000084000000FF0000000000000000
      00000000000000000000000000000000000000000000FFFF000084840000FFFF
      000084840000FFFF00000000000084848400FFFFFF00FFFFFF00FFFFFF008484
      840084848400000000000000000000000000000000000000FF000000FF000000
      FF00FFFFFF00FF000000FF000000FF000000FF000000FF000000FFFFFF000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF000000000000000000000000008400
      0000008400000084000000840000008400000084000000FF0000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF0000000000FFFF000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF0000000000FFFFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000000000FFFFFF000000000000000000000000008400
      0000008400000084000000840000008400000084000000FF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFF000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00000000000000000000000000000000000000
      000000FF0000008400000084000000FF000000FF000084000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFF000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FF000000FF000000FF000000FF00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FF000000FF
      000000FF000000FF000000000000FF000000FF000000FF000000FF000000FFFF
      0000FFFF0000FFFF0000FFFF0000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FFFF0000FF000000FFFF0000FFFF
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000008400000084000000840000000084000000FF000000
      840000000000000000000000000000000000000000000000000000FF000000FF
      000000FF000000FF000000000000FF000000FF000000FF000000FF000000FFFF
      0000FFFF0000FFFF0000FFFF0000000000000000000000000000000000000000
      00000000000000000000FFFF0000FFFF0000FF000000FFFF0000FF000000FF00
      0000000000000000000000000000000000000000000000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000840000008400000084000000840000000084000000
      840000000000000000000000000000000000FFFF0000FFFF0000FFFF0000FFFF
      0000000000000000000000000000000000000000000000FF000000FF000000FF
      000000FF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000FFFF
      0000000000000000000000000000000000000000000000FF000000FF000000FF
      000000FF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000FFFFFF0000FF
      FF00000000000000000000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084848400FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      000000000000000000000000000000000000000000000000000000FFFF00FFFF
      FF000000000000FFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084848400FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      000000000000000000000000000000000000C6C6C6000000000000FF000000FF
      000000FF000000FF000000000000FF000000FF000000FF000000FF000000FFFF
      0000FFFF0000FFFF0000FFFF0000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF0000FFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00000000000000000000000000C6C6C60000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000000000000000000000000000000000000000000000FF
      FF0000FFFF00FFFFFF0000FFFF0000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00000000000000000000000000C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C6000000000000000000000000000000
      0000000000000000000000FF000000FF00000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000FFFFFF0000FFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00000000000000000000000000C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF0000FFFF00FFFFFF0000FFFF0000FF
      FF00FFFFFF000000000000000000000000000000000000000000FFFFFF00FFFF
      FF000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000FFFFFF00000000000000000000000000C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0000FFFF00FFFFFF0000FFFF00FFFFFF00FFFF
      FF0000FFFF00FFFFFF0000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      0000FFFFFF00000000000000000000000000C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF0000FFFF00FFFFFF0000FFFF0000FF
      FF00FFFFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      0000FFFFFF00000000000000000000000000C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF00FFFFFF0000FFFF00FFFFFF00FFFF
      FF0000FFFF00FFFFFF00FFFFFF0000FFFF000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      0000FFFFFF00000000000000000000000000C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C6000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF00000000000000000000000000FFFF
      FF0000FFFF00FFFFFF0000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      000000000000000000000000000000000000C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C6000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF00FFFFFF0000FFFF0000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      000000000000000000000000000000000000C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C6000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      000000000000000000000000000000000000C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000DECEBD00A5735A007B39180073290000732900007B391800A5735A00DECE
      BD000000000000000000000000000000000000000000FFFFFF00FFF7EF00F7EF
      E700F7EFE700F7EFE700F7EFE700F7EFE700F7EFE700F7EFE700F7EFE700F7EF
      E700F7EFE700F7EFE700F7EFE700FFF7EF000000000000000000000000000000
      000000000000000000005A3118005A3118005A31180000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFF7F700A573
      5200732900009C420000B54A0000C6520000BD4A0000B54A00009C3900007329
      0000A5735200FFF7F7000000000000000000000000009C8C7B00422100004221
      0000422100004221000042210000422100004221000042210000422100004221
      000042210000522100009C846B00F7EFE7000000000000000000000000000000
      00005A3118005A311800BD842100FFCE8C00AD6308005A3118005A3118000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFF7F7008C5231008C39
      0000C65A0000CE5A0000CE5A0000CE5A0000CE5A0000CE5A0000CE520000BD4A
      00008C3100008C523100FFF7F70000000000000000004A210000522900004A21
      0000FFE7A500FFE7A500FFDE9400FFD67B00F7CE6300F7C64200F7BD3100F7B5
      21004A210000C6BDAD004A210000F7EFE70000000000000000008C4208008C42
      08009C522100BD842100BD842100FFCE8C00AD630800AD630800AD6308005A31
      18005A3118000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A57352008C420000CE63
      0000CE630000CE630000CE630000BDCEDE00BDCEDE00CE630000CE5A0000CE5A
      0000C65200008C310000A573520000000000000000004A210000000000004A21
      0000E7E7E700E7E7E700E7E7E700E7E7E700E7E7E700E7E7E700E7E7E700E7E7
      E7004A210000000000004A210000F7EFE7008C4208008C420800D68C2900FFDE
      8C009C522100BD842100BD842100FFCE8C00AD630800AD630800AD6308005A31
      1800FFCE8C005A3118005A311800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DECEBD007B390000C6630000CE6B
      0800CE6B0800D66B0800D6730800C6D6DE00C6D6DE00CE6B0800CE630000CE63
      0000CE5A0000C652000073290000DECEBD00000000004A2100008C5210004A21
      0000FFE7A500FFE7A500FFDE9400FFD67B00F7CE6300F7C64200F7BD3100F7B5
      21004A2100008C5210004A210000F7EFE7008C420800D68C2900E7AD3900FFDE
      8C009C522100BD842100FFCE8C00FFCE8C00FFCE8C00AD630800AD6308009442
      0800FFCE8C00A55A0800A55A08005A3118000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000AD7B5A00A5520000CE6B0800D673
      0800D6730800DE7B0800DE7B0800C6D6E700C6D6E700D6730800CE6B0800CE63
      0800CE630000CE5A00009C420000A5735A00000000004A2100008C5210004A21
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF004A2100008C5210004A210000F7EFE7008C420800EFB54200E7AD3900FFDE
      8C009C522100FFCE8C009C5221009C5221009C522100FFCE8C00FFCE8C009442
      0800FFCE8C00A55A0800A55A08005A3118000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000844A1800BD630800D6730800DE7B
      0800E77B0800E7840800E7840000CED6E700CED6E700DE7B0800D6730800D66B
      0800CE630000CE5A0000B55200007B391800000000004A2100008C5210004A21
      0000F7B52100F7B52100F7B52100F7B52100F7B52100F7B52100F7B52100F7B5
      21004A2100008C5210004A210000F7EFE7008C420800EFB54200FFDE8C00FFDE
      8C009C5221009C522100BD7B18009C522100BD7B18009C5221009C5221009442
      0800FFCE8C00A55A0800A55A08005A3118000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007B390000CE730800E77B0800FF9C
      1800FFAD3100FFB54200FFBD4200DEE7F700DEE7F700FFA52900FF9C1800FF8C
      0800E77B0800CE630800C65A000073290000000000004A2100009C6B39004A21
      0000FFE7A500FFE7A500FFDE9400FFD67B00F7CE6300F7C64200F7BD3100F7B5
      21004A2100008C5210004A210000F7EFE7008C420800FFDE8C009C5221009C52
      21005A311800BD7B1800BD842100FFE7CE00AD630800BD7B1800BD7B18009442
      08008C310000A55A0800A55A08005A3118000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007B420000CE730800FFAD4200FFBD
      5200FFBD4A00FFBD4200FFBD4200DEEFF700DEEFF700FFAD2900FF9C1800FF94
      1000FF840800E7730800C65A000073290000000000004A210000A57B42004A21
      00004A2100004A2100004A2100004A2100004A2100004A2100004A2100004A21
      00004A2100008C5210004A210000F7EFE700B56B31009C522100F7D65A00FFE7
      6B005A311800BD842100BD842100FFE7CE00AD630800AD630800AD6308005A31
      1800FFE7A5008C3100008C3100005A3118000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000084521800C6731000FFB54200FFBD
      4A00FFC64200FFC64200FFC63900FFBD3100FFB52900FFAD2100FF9C1000FF94
      0800F7840800E7730800BD5A000084421800000000004A210000A57B4200A57B
      4200A57B4200A5734200A57339009C7339009C7339009C7339009C733100946B
      29008C5A18008C5210004A210000F7EFE700B56B3100F7D65A00FFE76B00FFE7
      6B005A311800BD842100BD842100FFE7CE00BD7B2100AD630800AD6308005A31
      1800FFE7A500C6841800C68418008C3100000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000AD8C6300AD631000FFA51800FFBD
      4200FFBD3900FFC63900FFCE3100DEEFFF00DEEFFF00FFAD1800FF9C0800FF8C
      0800EF840800D6730800A5520000A57B5A00000000004A210000A57B42004221
      000052290000D6D6CE00D6D6CE00D6D6CE00D6D6CE00D6D6CE00D6D6CE006B39
      00009C7329008C5A18004A210000F7EFE700B56B3100FFE76B00FFE76B00FFFF
      A5005A311800BD842100FFCE8C00FFE7CE00FFCE8C00BD7B2100AD6308005A31
      1800FFE7A500C6841800C6841800A55A10000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DED6C600945A2100EF8C0800FFB5
      3100FFBD3100FFC63100FFC62900E7EFFF00E7EFFF00FFA51000FF9C0800F78C
      0800E77B0800D67310008C521800DECEBD00000000004A210000A57B42004221
      00005A310000FFFFFF00E7E7E700E7E7E7004221000052290000E7E7E7006B39
      0000A57B39008C5A21004A210000F7F7EF00B56B3100FFE76B00FFFFA500B56B
      3100B5732100FFCE8C00E79C2900E79C2900E79C2900FFCE8C00FFCE8C005A31
      1800FFE7A500C6841800C6841800A55A10000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000AD845A00BD843900FFAD
      2100FFB52100FFBD2900FFBD2100FFB51800FFAD1000FFA50000F7940800EF84
      0800FF8C1000B5733900A57B520000000000000000004A210000AD844A004221
      000063310000FFFFFF00EFEFEF00EFEFEF004221000052290000EFEFEF006B39
      0000A57B3900946329004A210000FFFFF700B56B3100F7AD4200B56B3100F7AD
      4200FFD67300B5732100B5732100E79C2900E79C2900B5732100B5732100FFD6
      7300A55A1000C6841800C6841800A55A10000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFF7F7009C6B3900C68C
      3900FFC66300FFC64A00FFBD3100FFAD1800FFA51000FFA51800FFAD3900FFB5
      5A00BD7B390094633100FFF7F70000000000000000004A210000B58C52004221
      000063310000FFFFFF00FFFFFF00FFFFFF004221000042210000FFFFFF006B39
      0000AD8442004A210000FFFFF700FFFFFF00B56B3100B56B3100EFA53100F7AD
      4200B56B1800FFD67300FFD67300B5732100B5732100FFD67300FFD67300E79C
      2900E79C2900A55A1000A55A1000A55A10000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFF7F700AD84
      5A0094632900D6A55200FFCE8C00FFE7AD00FFE7B500F7CE8C00D69C52008C5A
      2100A57B5200FFF7F7000000000000000000000000004A210000C68C2900C68C
      2900C68C2900FFFFFF000000000000000000000000000000000000000000C68C
      2900C68C2900FFFFFF00FFFFFF00000000000000000000000000B56B3100B56B
      3100B5732100B5732100B5732100FFD67300FFD67300B5732100B5732100B573
      2100DE942100DE942100EFAD5200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000E7D6C600AD8C63008C5A21007B4A08007B4A08008C5A2100AD8C6300DECE
      C600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000BD842100BD842100BD842100BD842100BD842100BD842100BD842100BD84
      2100000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60084848400C6C6C600C6C6C60084848400C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000840000008400000084000000840000008400
      0000840000008400000084000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60084848400C6C6C600C6C6C60084848400C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60084848400C6C6C600C6C6C60084848400C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00840000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60084848400C6C6C600C6C6C60084848400C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00840000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60084848400C6C6C600C6C6C60084848400C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00000000000000000000000000000000008400
      0000840000008400000084000000840000008400000084000000840000008400
      0000840000008400000084000000840000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60084848400C6C6C600C6C6C60084848400C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00000000000000000000000000000000008400
      0000FFFFFF00FFFFFF0084000000840000008400000084000000840000008400
      00008400000084000000FFFFFF00840000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60084848400C6C6C600C6C6C60084848400C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00000000000000000000000000000000008400
      0000FFFFFF00FFFFFF0084000000840000008400000084000000840000008400
      0000840000008400000084000000840000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60084848400C6C6C600C6C6C60084848400C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000008400
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00840000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60084848400C6C6C600C6C6C60084848400C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000840000008400000084000000840000008400
      0000840000008400000084000000000000000000000084000000840000008400
      0000840000008400000084000000840000008400000084000000840000008400
      0000840000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60084848400C6C6C600C6C6C60084848400C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000FFFFFF008400
      000084000000840000008400000084000000840000008400000084000000FFFF
      FF00840000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60084848400C6C6C600C6C6C60084848400C6C6C6000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000084000000FFFFFF008400
      0000840000008400000084000000840000008400000084000000840000008400
      0000840000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60084848400C6C6C600C6C6C60084848400C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000008400
      0000840000008400000084000000840000008400000084000000840000008400
      0000000000000000000000000000000000000000000084000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00840000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60084848400C6C6C600C6C6C60084848400C6C6C6000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000084000000840000008400
      0000840000008400000084000000840000008400000084000000840000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60084848400C6C6C600C6C6C60084848400C6C6C6000000
      0000000000000000000000000000000000000000000084000000840000008400
      0000840000008400000084000000840000008400000084000000000000000000
      0000000000000000000000000000000000000000000084000000840000008400
      00008400000084000000840000008400000084000000FFFFFF00840000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60084848400C6C6C600C6C6C60084848400C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000840000008400
      0000840000008400000084000000840000008400000084000000840000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60084848400C6C6C600C6C6C60084848400C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000ADAD
      E7002129AD002121AD002121AD001821AD001821AD00CEC6BD001821AD001821
      AD001821AD001821AD001821AD001821AD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000ADADE7001821
      AD00FFFFF700FFFFE700FFFFDE00FFFFDE00FFFFD6001821AD00FFFFE700FFFF
      DE00FFFFDE00FFFFDE00FFFFDE002929B5000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000ADADE7001821AD00FFFF
      F700FFFFDE00FFD69C00FFE7AD00FFF7C600F7E7AD00FFEFBD00FFDE9C00FFD6
      9C00FFE7AD00FFFFDE002929B500ADADE7000000000000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008484840000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000731800001821AD00FFFFEF00FFFF
      FF00FFFFE700F7EFD600FFF7D600F7CE8400FFF7D600FFFFDE00FFFFD600FFFF
      D600FFFFDE002929B500ADADE700000000000000000000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484008484840000000000000000000000000000000000000000000000
      000000FFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007B2100006B4A6B00FFFFE700FFFF
      EF00EFD6AD000021420084846B00DEBD8400FFE7B500FFDEA500FFDE9C00FFFF
      D6002929B500ADADE70000000000000000000000000000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF000000000000000000000000008484
      8400FFFFFF0000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000009C421800C66B4200B56B3100FFFF
      8C00DE8C4A00BD7B4A00002142007B3921008431180000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      0000000000000000000000000000000000008484840000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF0000FFFF008484
      840000FFFF0000000000FFFFFF00FFFFFF0000FFFF00000000000000000000FF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C6947B00D6846300DE843900FFFF
      9400FFEF7B007B1800007318000000214200AD73630000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      0000000000008484840000000000848484000000000000000000000000000000
      00000000000000000000000000000000000000FFFF00FFFFFF00FFFFFF0000FF
      FF00FFFFFF00FFFFFF000000000000FFFF000084840000000000FFFFFF00FFFF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D6B5AD00C6AD7300B5DE
      CE00BDE7CE00B58C630094423100E7CEC6000021420000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00008484000000
      0000000000000000000084848400000000008484840000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF0000FFFF00FFFF
      FF0000FFFF0000FFFF00FFFFFF000084840000000000FFFFFF0000FFFF0000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FFFF0000FF000000FF000000FF000000000000000000
      00000000000000000000000000000000000000000000000000009CCEF7006BB5
      EF0063B5F7007BB5DE0000000000000000000000000000214200000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF0000000000FFFF
      FF0000000000000000000000000000FFFF0000FFFF00FFFFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000848484000000
      0000FF000000FFFF0000FFFF0000FFFF0000FFFF0000FF000000000000000000
      00000000000000000000000000000000000000000000BDDEFF009CCEFF008CC6
      FF007BBDFF003963840000000000000000000000000000000000002142000000
      000000000000000000000000000000000000000000000000000000FFFF000000
      00000000000000000000000000000000000000000000000000000000000000FF
      000000FF000000FF0000000000000000000000FFFF00FFFFFF00000000000000
      000000000000FFFFFF0000FFFF00FFFFFF00FFFFFF0000FFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FFFF0000FF000000FF000000FF000000000000008400
      00008400000000000000000000000000000000000000ADD6FF009CCEFF008CBD
      FF007BB5F7005294D60031526300000000000000000000000000000000000021
      420000000000000000000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000848484000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF00000000000000
      0000FFFFFF0000FFFF00FFFFFF0000FFFF0000FFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000848484008484
      84000000000000000000FF000000000000000000000000000000000000008400
      000084000000000000000000000000000000ADADB5004A6B7B005294C6003963
      730039637B005AADE70000214200C6CED6000000000000000000000000000000
      00006B7B8C00000000000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF0084848400000000008484840000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF0000FFFF00FFFF
      FF0000FFFF0000FFFF00FFFFFF0000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E7E7E7004A84AD005AA5E7004A8C
      B5004A7B9C004A84AD0000214200526B7B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484000000000084848400000000008484840000000000848484008484
      84000000000000000000000000000000000000FFFF00FFFFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF0084848400000000008484840000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000008314A0010314A000829
      4A0008294A00214A6B0008314A0010314A000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084848400848484000000000084848400000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF0000FFFF00FFFF
      FF0000FFFF0000000000848484008484840000FFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000005A7B8C0031526B00395A
      730018395A00214A6B0008314A00214252000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF0000FFFF00FFFF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000527384000831
      4A00002942000829420010314A00E7E7EF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF00FFFFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000005242630052426300524263005242
      6300524263005242630052426300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000F7F7F700FFFFFF000000000000000000947BCE008C7BCE00947BCE00947B
      CE00947BCE009484CE009484CE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F7F7EF00FF9C4A00FF9C
      4A00FF9C4A00FF9C4A00FF9C4A00423129004231290042312900423129004231
      2900423129004231290000000000000000000000000000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E7D6C600BD9452009C5A0000A56B
      1000BD945200EFE7D600000000000000000000000000FF9C4A00FF9C4A00FFB5
      6B00FFBD7300FFCE8400F7C69400394A3100394A3100394A3100394A3100394A
      3100394A31000000000000000000000000000000000000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF0000000000000000000000000000009C5A00009C5A00009C5A
      00009C5A00009C5A00009C5A00009C5A0000C68C3100FFFFDE00FFDEAD00FFE7
      BD00FFFFDE00B57B3100E7D6C6000000000000000000FF9C4A00FFA55A00FFBD
      7300FFCE8400FFDE9400FFE794006B8452006B8452006B8452006B8452006B84
      52006B84520000000000F7FFFF00000000000000000000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FF000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF0000000000000000000000000000009C5A0000000000000000
      0000000000009C5A000000000000B57B3100FFFFF70000000000000000000000
      000000000000D6CECE00B57B31000000000000000000FF9C4A00FFA55A00FFC6
      7B00FFD68C00FFBD8400FFFFAD00FFFFAD001052FF001052FF001052FF001052
      FF001052FF001052FF00FFFFFF00000000000000000000FFFF0000FFFF000000
      00000000000000000000000000000000000084848400000000000000000000FF
      000000FF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009C5A00009C5A00009C5A
      00009C5A00009C5A00009C5A0000DEA54A000000000000000000EFEFF700B5BD
      C600ADB5B500F7EFE700C68C3100EFE7D6000000000000000000FF9C4A00FFBD
      7300FFD68C00FFB56B009C9CB5009C9CB5002173FF002173FF002173FF002173
      FF002173FF001052FF0000000000000000000000000000FFFF0000FFFF000000
      00000000000084848400000000008484840000000000000000000000000000FF
      000000FF000000FF000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009C5A0000000000000000
      0000000000009C5A0000000000009C5A0000FFEFCE000000000073737B00A5A5
      AD0000000000FFEFCE009C5A0000E7D6C600000000000000000000000000FF9C
      4A00FF9C4A00C6AD9C00185A9400425A8400CE9C8400FFFFF700000000000000
      00000000000000000000000000000000000000000000FFFFFF00008484000000
      0000000000000000000084848400000000008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF00000000000000000000000000000000000000
      000000000000000000000000000000000000000000009C5A00009C5A00009C5A
      00009C5A00009C5A00009C5A0000DEA54A000000000000000000B5BDC6007373
      7B00FFFFFF0000000000D69C3900FFF7F7000000000000000000000000000000
      0000F7F7EF00738CA500396B9C004273B5005A8CC600F7FFFF00000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009C5A0000000000000000
      0000000000009C5A000000000000AD732100FFEFCE0000000000000000009494
      9C00E7E7EF00FFE7BD00C69C6300000000000000000000000000000000000000
      0000000000008CA5C6004A8CD6005294DE005294DE00B5CEEF00000000000000
      000000000000000000000000000000000000000000000000000000FFFF000000
      00000000000000000000000000000000000000000000000000000000000000FF
      000000FF000000FF00000000000000000000000000000000FF00000000000000
      000000000000000000000000FF00000000000000000000000000000000000000
      000000000000000000000000000000000000000000009C5A00009C5A00009C5A
      00009C5A00009C5A00009C5A00009C5A00009C5A0000EFB57300C68C3100E7AD
      5A00EFB573009C5A0000FFF7F700000000000000000000000000000000000000
      0000CED6E700528CD60063A5E70073B5EF0073B5EF00A5CEF700000000000000
      000000000000000000000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009C5A0000000000000000
      0000000000009C5A00000000000000000000000000009C5A0000C68C31000000
      0000000000009C5A000000000000000000000000000000000000000000000000
      000063739C003963A5007BBDEF008CC6EF0094CEF700BDDEF700000000000000
      000000000000000000000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF0084848400000000008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      000000000000000000000000000000000000000000009C5A00009C5A00009C5A
      00009C5A00009C5A00009C5A00009C5A00009C5A00009C5A00009C5A00009C5A
      00009C5A00009C5A00000000000000000000000000000000000000000000FFFF
      FF0021428C00104AAD0073ADF700B5E7FF00B5E7FF00B5DEFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484000000000084848400000000008484840000000000848484008484
      8400000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C6C6C60000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF005284D600186BE7002984FF007BB5FF0073B5EF007BBDFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084848400848484000000000084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF00000000000000FF0000000000000000000000000000000000C6C6
      C600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000DEE7FF007B9CD600528CE700427BCE006394D600E7F7FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000AD843900AD7B2900E7DE
      C600BD945200DEC6A50000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D6D6D6001800
      0000180000001800000010000000180000001800000018000000180000001800
      0000180000004242420000000000000000000000000000000000000000000000
      00000000000000000000EFE7D600AD7B2900BD8C42009C6B08009C6B08009C6B
      08009C6B0800BD8C420000000000000000000000000000000000000000000000
      0000000000000000000000000000424221004242210042422100424221004242
      21004242210042422100C6C6C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D6D6D6001008
      08003121210042313100523131004A2121004210100031000000310000004200
      0000310800004242420000000000000000000000000000000000000000000000
      00000000000000000000E7D6B500A56B0800A56B0800A56B0800A56B0800A56B
      0800A56B0800A56B0800BD944A00DECEA5000000000000000000000000000000
      0000000000000000000000000000C6C6C6000000000000000000000000000000
      000000000000A5A5A500A5A5A500C6C6C6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D6D6D6003129
      29006B5A5A006B5A5A006B5252005A4242004A29290039181800310808004218
      1000392110007B7B7B0000000000000000000000000000000000000000000000
      000000000000F7EFE700CEAD7300A56B0800A56B0800CEA56300EFDEC600E7D6
      B500AD731800A56B0800A56B0800C69C52000000000000000000000000000000
      000000000000C6DEC600A5A5A500000000004221210042636300846363004263
      63004242630000000000C6C6C600C6C6C6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D6D6D6003131
      3100847B7B007B7B7B00736B6B00635A5A004A42420031292900291818004229
      180031291800CECECE0000000000000000000000000000000000000000000000
      000000000000D6B57300AD730800AD730800BD8C390000000000000000000000
      0000E7D6B500AD730800AD730800EFDEC600FFFFFF0000000000000000000000
      000000000000A5A5A50000000000846363008484840084A5A50084848400A5A5
      A500848484000000000042426300C6C6C6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400949494009C9494008C8C8C00737373005A5A5A0042424200292921002921
      1800847B7B000000000000000000000000000000000000000000000000000000
      000000000000F7EFE700BD842900AD730800C69C4A0000000000000000000000
      0000EFDEC600AD730800AD730800BD84290000000000C6DEC600FFFFFF000000
      00000000000000000000C6C6C6008484A500A5A5A500C6C6C60084A5C600C6C6
      C600C6C6C6004263630042212100A5A5A5000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000DEDEDE00949494009C9C9C008C8C8C006B6B6B00525252008C8C8C00D6D6
      D600000000000000000000000000000000000000000000000000000000000000
      000000000000FFF7F700BD8C2900B57B0800BD841800F7E7D600000000000000
      0000D6AD6B00B57B0800B57B0800C69439000000000000000000C6C6C6000000
      0000000000000000000000000000C6C6C600C6DEC60000000000C6C6C600C6C6
      C600C6C6C6004263630000000000C6C6C6000000000000000000000000000000
      0000000000000000000000FF0000FFFFFF0000000000000000000000000000FF
      0000FFFFFF0000FF000000000000000000000000000000000000000000000000
      000000000000ADB5C60094A5C6007B8C9C00525A6300BDBDBD00000000000000
      0000000000000000000000000000000000000000000000000000BDEFFF000000
      000063CEFF00BDCECE00BD7B0800BD7B0800BD7B0800BD841800CE9C4A00C694
      3900BD7B0800BD7B0800CE9C4A00000000000000000000000000000000000000
      00000000000000000000FFFFFF0084848400C6DEC600C6C6C600FFFFFF004263
      6300FFFFFF00C6C6C60000000000C6C6C6000000000000000000000000000000
      00000000000000FF0000FFFFFF0000FF000000FF00000000000000000000FFFF
      FF0000FF0000FFFFFF0000000000000000000000000000000000000000000000
      0000D6E7FF00B5CEFF00B5CEFF00ADCEF7008CB5E700DEE7E700000000000000
      00000000000000000000000000000000000000000000BDEFFF0000ADFF0021BD
      FF0000ADFF0031BDFF005AB5CE00A5AD8400BD7B0800BD7B0800BD7B0800BD7B
      0800BD7B0800BD7B0800C68C290000000000FFFFFF00C6DEC600000000000000
      000000000000A5A5A5000000000084636300FFFFFF0042424200000000000000
      00000000000000000000A5A5A500000000000000000000000000000000000000
      00000000000000FF0000FFFFFF0000FF000000FF00000000000000000000FFFF
      FF0000FF0000FFFFFF0000000000000000000000000000000000000000000000
      0000BDD6FF00BDD6F700B5CEF700A5C6EF009CBDEF007B9CBD00F7F7F7000000
      0000000000000000000000000000000000009CE7FF0042C6FF0000B5FF0031BD
      FF0042C6FF0010B5FF0000B5FF007BBDCE00BD7B0800C6942900C6942900BD7B
      0800DEBD7B00EFD6B500F7E7D60000000000000000000000000000000000C6DE
      C60000000000C6DEC6000000000042424200FFFFFF0000000000424263000000
      0000C6A5C6000000000000000000FFFFFF000000000000000000000000000000
      0000000000000000000000FF0000FFFFFF0000000000000000000000000000FF
      0000FFFFFF0000FF00000000000000000000000000000000000000000000F7FF
      FF00BDD6F700BDD6F700B5CEF700ADC6EF0094BDE7007BADDE00BDBDC6000000
      00000000000000000000000000000000000042CEFF0000B5FF0063D6FF000000
      000000000000CEF7FF0010BDFF0021BDFF00ADCECE00FFF7F700F7EFE700DEBD
      7B00F7EFE700000000000000000000000000FFFFFF0000000000000000000000
      000000000000000000000000000042212100FFFFFF0000000000000000000000
      0000002142000021420000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E7EF
      FF00C6D6F700BDD6F700B5D6EF00ADCEEF00A5C6E700638CAD0031313100CECE
      CE00B5ADAD00CECECE00000000000000000073DEFF0000BDFF00BDEFFF000000
      0000000000000000000042CEFF0000BDFF009CE7FF0000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000C6C6C600C6DE
      C60084A5A500000000008484A50042212100FFFFFF00424242000000000084A5
      C6004242A5004242A50000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000005A5A5A00C6C6
      C600A5BDDE00C6DEF700BDD6EF00B5CEE7006B7B8C0010080800000000003929
      29004A393900DED6D600000000000000000000BDFF0000BDFF00ADEFFF000000
      0000000000000000000031CEFF0010C6FF00EFFFFF0000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000C6C6C600C6C6
      C600C6DEC600000000008484A50042214200FFFFFF00424263000021420084A5
      C6004242C6004242A50000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000847B7B00CECE
      CE00524A4A003931310031212100291010002100000018000000080000002918
      1800B5ADAD00000000000000000000000000DEFFFF0000C6FF0010C6FF00ADEF
      FF00BDF7FF0063DEFF0000C6FF0000C6FF00ADEFFF0000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000C6C6C600C6C6
      C600C6C6C60000000000A5A5A5004263630084636300424263000021420084A5
      C6004263A5004263C60000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000948C8C00DED6
      D600635252006B4A4A005A3131004A2121003108080010000000181010007B6B
      6B00000000000000000000000000000000000000000010CEFF0000C6FF0000C6
      FF0000C6FF0000C6FF0031D6FF00000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A59C9C004A39
      390039292900423131004A29290031181800211818002921210052424200F7F7
      F7000000000000000000000000000000000000000000DEFFFF00EFFFFF0000C6
      FF0063DEFF0073E7FF008CE7FF00000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000DED6
      D600E7E7E700CECECE009C949400948C8C006B6363004A393900DED6D6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000E7E7E70063636300636363006363630063635A00635A5A00635A5A00635A
      5A0063635A005252520052525200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF0018181800FFFFFF0000000000FFFFFF00000000000000
      0000FFFFFF000808080008080800080808000000000000000000FFFFFF00FFFF
      FF00DEDEDE0052525200FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00E7DE
      D600E7DED600D6C6B50052525200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B5B5B500B5B5B500B5B5
      B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5
      B500B5B5B500D6D6D6000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0018181800FFFFFF0000000000FFFFFF00000000000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      0000E7E7E70052525200B5B5B5008C8C8C009494940094949400949494009494
      94008C8C8C00BDB5AD0052525200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6D6D60000527B0000527B000052
      7B0000527B0000527B0000527B0000527B0000527B0000527B0000527B000052
      7B0000527B00B5B5B500D6D6D60000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0018181800FFFFFF0000000000FFFFFF00000000000000
      0000FFFFFF00000000000000000000000000000000004A4A4A005A5A5A005A5A
      5A00BDBDBD0052525200FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00E7DE
      D600E7DED600D6CEC6005252520000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000884A5001084A50084FFFF0042E7
      FF0042E7FF0042E7FF0042E7FF0042E7FF0042E7FF0042E7FF0042E7FF0042E7
      FF002184A50000527B00B5B5B50000000000AD735A00B57B5A00BD7B5A00D684
      5200E7BDA500FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000052525200BDBDBD00D6D6
      D600ADADA50052525200BDBDBD00949494009C9C9C009C9C9C009C9C9C009C9C
      9C0094949400C6C6BD005252520000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000884A5001084A5005AF7FF0084FF
      FF005AF7FF005AF7FF005AF7FF005AF7FF005AF7FF005AF7FF005AF7FF005AEF
      FF0021ADDE00085A7300B5B5B5000000000094310000B5420000C64A0000B54A
      0000A57B6B0063210000C6520000AD521800BDA59400FFFFFF00D6D6D600A563
      3900C6520800DE631000B552180094634A000000000052525200D6D6D600A5A5
      A5008C8C8C0052525200FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00D6CEC6005252520000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000884A500188CB50029B5CE0084FF
      FF0063FFFF0063FFFF0063FFFF0063FFFF0063FFFF0063FFFF0063FFFF0063FF
      FF0018BDFF000884A500B5B5B500D6D6D600732900007B290000843108007B29
      0000B58C7B00FFFFFF0063210000B5846300FFFFFF00FFFFFF00FFFFFF00C6BD
      B500BD4A0000CE52000063210000FFFFFF000000000052525200DEDEDE00D6D6
      D600ADADAD0052525200C6C6C600A5A5A500A5A5A500A5A5A500A5A5A500A5A5
      A5009CA59C00CECECE005252520000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000884A50021B5E700108CAD008CFF
      FF0073FFFF0073FFFF0073FFFF0073FFFF0073FFFF0073FFFF0073FFFF0073FF
      FF0031C6F70042BDCE0000527B00B5B5B50094422900A5524A00AD5A4A009C4A
      3900B5847300FFFFFF00632100009C522900FFF7EF00FFFFFF00FFFFFF00B58C
      7300BD4A0000AD52210063210000FFFFFF000000000052525200CECECE00A5A5
      A5008C8C8C0052525200FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00DEDEDE005252520000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000884A5004ADEFF000884A5006BFF
      FF0084FFFF0084FFFF0084FFFF0084FFFF0084FFFF0084FFFF0084FFFF0084FF
      FF0031CEFF007BFFFF00085A7300B5B5B5004A5A1800638C3100639439005A84
      29008C947300FFFFFF00DED6CE0063210000944A2900A55A310094523100A54A
      1000AD42000063210000FFFFFF00FFFFFF000000000052525200E7E7E700EFEF
      EF00BDBDBD0052525200C6C6C600A5A5A500A5A5A500A5A5A500FFFFFF00FFFF
      FF00FFFFFF00B5B5B5005252520000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000884A50063DEFF000884A50052BD
      DE000000000000000000F7FFFF00000000000000000000000000000000000000
      000063FFFF000000000008637B00B5B5B500007B000000AD000000BD000000B5
      000073A57300FFFFFF00FFFFFF00632100008C421800C69C7B00A56B4A009439
      00009439000063210000FFFFFF00FFFFF7000000000052525200C6C6C6008C8C
      8C007B7B7B005252520000000000000000000000000000000000000000008484
      7B0084847B0084847B005252520000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000884A50063FFFF0029C6EF000884
      A5000884A5000884A5000884A5000884A5000884A5000884A5000884A5000884
      A5000884A5000884A500086B8C00B5B5B50000420000005A000000630000005A
      000073947300FFFFFF00FFFFFF00632100008C523100FFFFFF00B59484008C31
      000063210000E7E7E700FFFFFF00FFFFFF000000000052525200E7E7E700EFEF
      EF00C6C6C6005A5A5A0000000000000000000000000000000000000000008484
      7B00CECEC6005A5A5A00FFFFFF0000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000884A50084FFFF006BFFFF006BFF
      FF006BFFFF006BFFFF006BFFFF00000000000000000000000000000000000000
      00000884A500085A7300D6D6D60000000000216B1800428C39004A9439003184
      2900739C7300FFFFFF00FFFFFF006321000073311800C6B5AD00945A42007B29
      000063210000FFFFFF00FFFFFF00FFFFFF000000000052525200C6C6C6008484
      84007373730052525200B5B5B500B5B5B500BDBDBD00B5B5B500BDBDBD008484
      7B0052525200FFFFFF000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000884A5000000000084FFFF0084FF
      FF0084FFFF0084FFFF00000000000884A5000884A5000884A5000884A5000884
      A5000884A500D6D6D60000000000000000000831520018427B00214284001839
      730073849400FFFFFF00FFFFFF00FFFFFF00632100007B422900733118006321
      000063210000FFFFFF00FFFFFF00FFFFFF000000000052525200EFEFEF00FFFF
      FF00F7F7F7004A4A4A005A5A5A005A5A5A005252520052525200525252005A5A
      5A0000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      00000000000000000000000000000000000000000000188CB500000000000000
      000000000000000000000884A500D6D6D6000000000000000000000000000000
      0000000000000000000000000000000000000000AD000000C6000000D6000000
      CE007373C600FFFFFF00FFFFFF00FFFFFF00632100007B3910008C4A29006321
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000052525200F7F7F7000000
      0000000000000000000000000000EFEFEF0084847B00E7DED6005A5A5A000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000188CB500188C
      B500188CB500188CB500D6D6D600000000000000000000000000000000000000
      00000000000000000000000000000000000000007B0000007B00000084000000
      84007373B500FFFFFF00FFFFFF00FFFFFF0063210000BD846B00D69C7B006321
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000052525200E7E7E700F7F7
      F700F7F7F700F7F7F700F7F7F700DEDEDE0084847B005A5A5A00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000212994003942A500424AA5003139
      9C00737BBD00FFFFFF00FFFFFF00FFFFFF00FFFFFF006321000063210000DECE
      CE00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000052525200525252005252
      5200525252005252520052525200525252004A4A4A0000000000FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004A52AD00737BD6007B84DE005A6B
      CE008484BD00FFFFFF00FFFFFF00FFFFFF00FFFFFF006321000063210000F7EF
      EF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000949494009494
      9400949494009494940094949400949494009494940094949400949494009494
      9400949494009494940000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000EFCECE00DE73
      7B00F7424A00F7637B00FFADCE00FFA5B500FF736B00FF524A00FF393100EF39
      4200F7737B00F7D6D6000000000000000000000000000000000000000000AD9C
      94008C7B7B008C7B7B008C7B7B008C7B7B008C7B7B008C7B7B008C7B7B008C7B
      7B008C847B00084263000000100084A5B50000000000F7F7F70094949400E7E7
      E700E7E7E700E7E7E700E7E7E700E7E7E700E7E7E700E7E7E700E7E7E700E7E7
      E700E7E7E70094949400F7F7F700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000BD393900EF21
      0800FF945200FFE7A500FFF7B500FFDE9400FFBD7300FF9C4A00FF843100FF63
      1800EF210800BD42420000000000000000007B84840039424A0000000000DEC6
      BD00000000000000000000000000000000000000000000000000000000000000
      000008426300000010006BD6FF0031739C0000000000949C9400E7E7E7009C94
      9400E7E7E700E7E7E700E7E7E700E7E7E700E7E7E700E7E7E700E7E7E700E7E7
      E70094949400E7E7E700949C9400FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000EF210800FF73
      2900FFB56300FFE79C00FFF7B500FFDE9400FFBD7B00FFA55A00FF9C4200FF94
      3900FF631800E721080000000000000000006B737B00C6C6C600000000006B6B
      6300737373005A525200524A42005252420052524200524A42005A5252000842
      6300000010006BD6FF0031739C006B737B00949C9400E7E7E700E7E7E700949C
      94009C9494009C9494009C9494009C9494009494940094949400949494009494
      9400949C9400E7E7E700E7E7E700949C94000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F7210000FF6B
      2900FF8C4A00FFE79C00FFE7AD00FFDE9400FFAD7300FF945200FF8C3900FF8C
      3900FF631800F72100000000000000000000949CA500DEDEDE00DEDEDE00DEDE
      DE0084847B008C7B6300C6B59400DECEB500DECEB500C6B594008C7B63003939
      31006B6B730031739C0000A54200949CA500949C9400E7E7E700E7E7E700E7E7
      E700E7E7E700E7E7E700E7E7E700E7E7E700E7E7E700E7E7E700E7E7E700E7E7
      E700E7E7E700E7E7E700E7E7E700949C94000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000EF180800FF39
      1800FF5A3900FFAD8400F7CE9C00FFAD7B00FF8C6300FF6B3900FF5A3100FF4A
      2900FF391000EF2108000000000000000000ADADB500EFEFEF00EFEFEF00BDB5
      AD00948C7300DEDECE00EFEFEF00EFEFEF00EFEFEF00EFEFEF00DEDECE008C84
      6B004A6B7B00EFEFEF00EFEFEF00ADADB500949C9400E7E7E700E7E7E700E7E7
      E700EFB51800EFB51800EFB51800EFB51800EFB51800EFB51800EFB51800EFB5
      1800E7E7E700E7E7E700E7E7E700949C94000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000DE181000FF52
      2100FFA55A00FFE79C00FFF7B500FFDE9400FFBD7B00FFA55200FF944200FF73
      3100FF421000D61810000000000000000000BDC6C600F7FFFF00735A39007B73
      5A006B5A39005A4218008C7B5200B5A58C00B5A58C008C7B52005A4218006B5A
      39007B735A00735A3900F7FFFF00BDC6C600949C9400E7E7E700E7E7E700EFB5
      1800F7C60000F7BD0000F7BD0000F7BD0000F7BD0000F7BD0000F7BD0000F7BD
      0000F7C60000E7E7E700E7E7E700949C94000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000F7210800FF73
      2900FFAD5A00FFE79C00FFF7B500FFD69400FFBD7300FFA55200FF944200FF94
      3900FF631800EF2108000000000000000000C6CED600000000007B6331008C7B
      6300AD843900C6843100C6843100C6843100C6843100C6843100C6843100AD84
      39008C7B63007B63310000000000C6CED600949C9400E7E7E700E7E7E700D69C
      1000BD8C1000B5840800BD840800BD840800BD840800BD840800BD840000BD84
      0800D69C0000E7E7E700E7E7E700949C94000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000F7210800FF6B
      2900FFA55A00FFCE8C00FFE7AD00FFC68400FFAD7300FF945200FF8C3900FF8C
      3100FF631800F72100000000000000000000CED6D60000000000A57B42008C7B
      6B00B59C7B00FFDEA500FFDEA500FFDEA500FFDEA500FFDEA500FFDEA500B59C
      7B008C7B6B00A57B420000000000CED6D60000000000949C9400E7E7E700A58C
      31007B7B730094949C009494940094949400949494009494940094949400949C
      9400A58C3100E7E7E700949C9400000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000EF210800FF42
      1800FF5A4A00FF948400F7ADAD00F7948400FF736300FF634200FF4A2900FF4A
      2900FF391000E72108000000000000000000CECED600F7F7F700C69439008C73
      5A00423121005A422100000000008C6B42008C6B4200000000005A4221004231
      21008C735A00C6943900F7F7F700CECED600FFFFFF0000000000949C94008C73
      3900949C9400000000000000000000000000000000000000000000000000949C
      9400846B2900949C940000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000E7180800FF4A
      1800FF945A00FFDE9400FFF7B500FFD68C00FFBD7B00FFA55A00FF8C4200FF73
      3100FF391000DE1808000000000000000000DEDEDE00BDC6C600C68C3100B59C
      8C00736B5A004A4A42005A52520000000000000000005A5252004A4A4200736B
      5A0094847B00C68C3100BDC6C600DEDEDE000000000000000000FFFFFF00FFFF
      FF00949C9400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00949C
      940000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000F7210800FF73
      2900FFAD5A00FFE79C00FFF7B500FFDE9400FFBD7B00FFA55A00FF9C4200FF94
      3900FF631800EF2108000000000000000000000000000000000000000000CEB5
      AD00BDB5A500736B5A004A42420042423900424239004A424200736B5A00BDB5
      A5009C8C84000000000000000000000000000000000000000000000000000000
      0000949C9400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000949C
      9400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000EF210000FF63
      1800FF8C4A00FFB58400FFDEAD00FFBD9400FF9C7300FF844A00FF732900FF6B
      2100FF521000EF2100000000000000000000000000000000000000000000CEB5
      AD00FFFFEF00D6BDAD00A5947B008C7B6B008C7B6B00A5947B00D6BDAD00FFFF
      EF009C8C8C000000000000000000000000000000000000000000000000000000
      0000949C9400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000949C
      9400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F7180800FF63
      4200FF847300FFA59400FFC6AD00FFBDA500FFAD9400FF9C7B00FF846B00FF6B
      5200FF523100F71808000000000000000000000000000000000000000000CEBD
      B50000000000FFDECE00FFDECE00FFDECE00FFDECE00FFDECE00FFDECE000000
      00009C8C8C000000000000000000000000000000000000000000000000000000
      0000949C94000000000000000000000000000000000000000000F7F7F700949C
      9400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF847B00FFC6
      8C00FFCE9400FFD69400FFD69400FFDE9400FFDE9400FFD69400FFD69400FFCE
      8C00FFB57B00F75242000000000000000000000000000000000000000000D6BD
      B500000000000000000000000000000000000000000000000000000000000000
      00009C948C000000000000000000000000000000000000000000000000000000
      0000949C9400EFEFEF00EFEFEF00EFEFEF00EFEFEF00EFEFEF00DEDEDE00949C
      9400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFA56300FF84
      3900FFA55A00FFBD6B00FFC67B00FFC67B00FFC67B00FFBD7300FFB56B00FFAD
      5A00FF732900FF8442000000000000000000000000000000000000000000D6BD
      B500D6BDB500D6BDB500D6BDB500D6BDB500D6BDB500D6BDB500D6BDB500D6BD
      B500BDA5A5000000000000000000000000000000000000000000000000000000
      0000949C9400949C9400949C9400949C9400949C9400949C9400949C94000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFF7EF00FFAD
      8C00FF845A00FF522900FF391000FF390800FF420800FF521000FF522900FF7B
      5200FF947B00FFEFDE000000000000000000424D3E000000000000003E000000
      2800000040000000000100000100010000000000000800000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000C0038888C000FC03C0038888C000FC01
      C0038888C000FC01C0038888C000F000C0038888C0008000C0038888C0008000
      C0038888C0008000C003F888C0000001C003F888C0000801C003F888C0008C03
      C003FB88C0009E0FC003FF88C0009C0FC003FF88C000040FC003FFF8C001840F
      C007FFF8C003840FF07FFFFFC007FE1FFFFFFFFF83C1F001FFFFFFFF8181C001
      83FFFFFF9189F001FFFFFFFF88118001FFFDFFFFC00180018087FF01C0038001
      81785F01E007800180001000F81F800180010001FC3F800180028001F81F83E1
      8007C001F81F83E1A00FE009F00F8003EC37F01FF18F800FFFEFFFFFE1879E1F
      FE7FFFFFE3C7803FFFFFFFFFE7E7804FFFFFFFFFFFFFFFFF8001F001FFFFFFFF
      B7FDF6FDFFFFFFFF84E5F7FDFFFFFFFFB7FDF7FDDF7FFEFB8631F6A9C77E7EE3
      B7FDFFFF4F8181F2848D803FDFC3C3FB87FD803F9FE187F9B7FDFFFF9D83C1B9
      846DF295CA3BDC53B7FDF7FDE0FFFF078001F001FFFFFFFFBFFDF7FDFFFFFFFF
      8001F001FFFFFFFFFFFFFFFFFFFFFFFFFFC1FFFFFFFFFFFFFF83FFFFE7FFDE1F
      FF83FFFFE3FF4400FF87FFFFE1FF0000FF07FFC1E0FF0000FC0F8F81E07F0000
      F80F87C1E03F0000E00F8001E01F0000C00FC001E03F0000800FE00BE07F0000
      000FF81FE0FF0000800FFFFFE1FF0000C01FFFFFE3FF0000F01FFFFFE7FF0000
      FC1FFFFFFFFF0000FF1FFFFFFFFF0000C0FFF1FFFFFFF8FFC07FF07FFFE1E0F1
      C0BAF23FFF018070C3770100FF618030A2AE300EFF610030F0DF0006837F0011
      B83A0000826100037835330080618007A81A03808001C00FFC0F00008061E07F
      AA0E33C0827FE0FF750703D08361F1FFAA820004FF61E3FFDF61018CFF01FFFF
      AAB80000FFE1FFFF577F0000FFFFFFFFFFFF49248B91C0FFFFFF4924480BC07F
      FFFF4924E007C0BA819349E4C181C377808149E48403A2AE988849E48801F0DF
      9C9C49E7C801B83A9C9C49E780137815818879E74002A81A818179E78000FC0F
      999379E78000AA0E999FFFFFC0067503819FFFFF8004AA82839FFFFF8030DF61
      FFFFFFFFE238AAB8FFFFFFFF9230577FFFFFFFFF800FFE7FFFFFFFFF800FFC3F
      020FFFCF800FE00703C0FF87800FC00301F0FF0F800FC003C006FF1F800F8003
      E009FE1F822F8001E00AFE3F800F8001FC09F03F80078001FE10F03F80038001
      FE01E07F80038003FFE0E03F80038003FF00E03F81FDC003FE82E03FB1FFE007
      FF49F03F81FFF01FFFFFF0FF83FFFFFF8000F807BFFFF8078000F8079FFFF807
      0F03FC0F8DFFFC0F0F03FC0F89FFFC0F0000FC0F81FFFC0F0000F003C0FFF003
      0000E003C07FE0030078E003C04FE00300008803E803880300008803F8018803
      0000F803F800F8030000F803FC00F8030000F807FE60F8070000F80FFE61F80F
      0000F80FFFE3F80F0000FE7FFFE3FE7FC007F00F8000FC7F8003C0038000F01F
      BFF380018000C007BFF3800180000001B033000080000000BFF3000080000000
      B033000080000000BFF3000080000000B033000080000000BFF3000080000000
      B133000080000000BFF3000080000000BFF3800180000000AAAB800180000000
      D557C00383E1C001EAAFF00FFFFFF00FF81FFFFFFC00FFFFF81FF800FC00FFFF
      F81FFBFCFC00FE7FF81FFBFCFC00FE7FF81FFBFCE000FE7FF81FFBFCE000FE7F
      F81F1BFCE000FE7FF81F7800E007FE7FF81F78008007FE7FF81F78008007FE7F
      F81F60078007FE7FF81F6007801FFE7FF81F001F801FFE7FF81F001F801FFE7F
      F81F001F801FFFFFF81FFFFFFFFFFFFFE000FFFFFFFFFFFFC000FFC1FFF3FFFF
      80009FC1FFC3FFFF00019FCFF003FFFF000383CF00038001007F804F0007BFFD
      007F904F0007BDFD807F904F000FB83DC3BF9041201F903D83DF81C1001FB825
      81EF8E41001F8DE500F7807F001FBFFD00FF9001001F800180FFE407003FFFFF
      80FFF81F007FFFFFC0FFFFFF01FFFFFFF7E7FFFFFF01FFFFF7F9FFFFF301FFC9
      F7E9FFFF80039FC9F7B1FF0380079FC9F7D18001800583C1F451BA7980018041
      F85B80C0C0039041F947BA48E03F9041F8BF80C4F03F9041F9FFBA61F83F81C1
      B9FF8001F03F8E41F7FFBB9BF03F807FF7DF8003E03F9001E77FFFFFE03FE407
      E5EFFFFFF03FF81FEFFFFFFFFFFFFFFFFF83FE00FFFFC003FC03FE01FFFFC003
      FC00FE00FFFFC003F800F800FFFFC003F8707800FFFFE007F8709800FCE3F00F
      F830DA40F863F83FD001F800F801F03F80013829B001F01F0001EA06A863E01F
      18070000DCE3E0031C7F0000FFFFC0031C7F0000FFFFC007007F0000FFFFC00F
      81FF0000FFFFC00F81FF0000FFFFE01FF001FFFFFFFFE000C001FFFF80030000
      F001C007000100008001C007000100008001C007000100008001C00700000000
      8001C007000000008001C007000000008001C0070DF4000083E1C00700000000
      83E1C00701F100008003C00742030000800FC00FBCFF00009E1FC01FC1FF0000
      803FC03FFFFF0000804FFFFFFFFF0000FFFF40028007C003E0008001BFF7C003
      0FF08000A017C00300000000ACD7C00300000000AFD7C00300000000AFD7C003
      00000000AFD3C00340020000AFC0C00340028001A380C003024047E3AFC0C003
      0180C00BA1D3C003E007F02FAFD7C003E007F02FA017C003E817F7CFBFF7C003
      EFF7F00F8007C003E007F01FFFFFC00300000000000000000000000000000000
      000000000000}
  end
end
