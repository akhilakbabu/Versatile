�
 TCLASHHELPDLG 0  TPF0TClashHelpDlgClashHelpDlgLeft� TopGHelpContext� ActiveControlOKBtnBorderStylebsDialogCaptionClash Help SelectionClientHeight"ClientWidthyColor	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold OldCreateOrder	PositionpoScreenCenter
OnActivateFormActivateOnCreate
FormCreate
DesignSizey" PixelsPerInch`
TextHeight TLabelLabel10Left
Top� Width� HeightAutoSizeFont.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  TLabelLabel13LeftTopdWidth!HeightCaptionBlock  TLabelLabel14Left@TopdWidthHeightCaption30  TBitBtnOKBtnLeft�TopWidthKHeightHint Show Clash Help for your entriesAnchorsakRightakBottom Caption&OKParentShowHintShowHint	TabOrder OnClick
OKBtnClickKindbkOKMarginSpacing�	IsControl	  TBitBtn	CancelBtnLeft�TopWidthKHeightHintExit from the dialogueAnchorsakRightakBottom Caption&CancelParentShowHintShowHint	TabOrderKindbkCancelMarginSpacing�	IsControl	  TBitBtnHelpBtnLeft&TopWidthKHeightAnchorsakRightakBottom TabOrderKindbkHelpMarginSpacing�	IsControl	  	TGroupBox	GroupBox1LeftTopWidth�Height{CaptionPositionTabOrder TLabelLabel3LeftTopWidthHeightCaption&YearFocusControl	ComboBox1  TLabelLabel4LeftsTopWidth HeightCaption&LevelFocusControlEdit2  TLabelLabel1LeftTopWidthHeightCaption&DayFocusControl	ComboBox2  TLabelLabel2Left� TopWidthHeightCaption&Time  TEditEdit2LefttTopWidthHeightHintEnter level of timetableAutoSize	MaxLengthParentShowHintShowHint	TabOrderText99OnChangeEdit2Change
OnKeyPressEdit1KeyPress  	TComboBox	ComboBox1LeftTopWidthfHeight
ItemHeight 	MaxLength
ParentShowHintShowHint	TabOrderText	ComboBox1OnChangeComboBox1Change  	TComboBox	ComboBox2LeftTopWidthuHeightHintSelect day of timetable
ItemHeight 	MaxLengthParentShowHintShowHint	TabOrder Text	ComboBox1OnChangeComboBox2Change  	TComboBox	ComboBox3Left� TopWidthuHeightHintSelect time slot
ItemHeight TabOrderText	ComboBox3OnChangeComboBox3ChangeOnEnterComboBox3Enter  TEditedtSubjectListLeftTop7Width�HeightHintTeachersTabStopAutoSizeColor	clBtnFaceFont.CharsetANSI_CHARSET
Font.ColorclBlackFont.Height�	Font.NameCourier New
Font.Style 
ParentFontReadOnly	TabOrderTextSubjectsOnMouseEnterRefreshHint  TEditedtTeacherListLeftTopMWidth�HeightHintTeachersTabStopAutoSizeColor	clBtnFaceFont.CharsetANSI_CHARSET
Font.ColorclBlackFont.Height�	Font.NameCourier New
Font.Style 
ParentFontReadOnly	TabOrderTextTeachersOnMouseEnterRefreshHint  TEditedtRoomsListLeftTopcWidth�HeightHintRoomsTabStopAutoSizeColor	clBtnFaceFont.CharsetANSI_CHARSET
Font.ColorclBlackFont.Height�	Font.NameCourier New
Font.Style 
ParentFontReadOnly	TabOrderTextRoomsOnMouseEnterRefreshHint   TRadioGroup
ClashScopeLeft�TopWidthgHeightiHintSelect scope of entriesCaptionScopeItems.Strings&Cell&BlockYr&/Time SlotC&ustom ParentShowHintShowHint	TabOrderOnClickClashScopeClick  TRadioGroup	ClashTypeLeftTopWidthZHeightSHintSelect type of helpCaptionHelp ForItems.Strings	T&eachers&RoomsB&oth ParentShowHintShowHint	TabOrderOnClickClashTypeClick  	TGroupBox	GroupBox2LeftTop� WidthkHeight{CaptionCustom SelectionTabOrder TLabelLabel8Left
TopWidth0HeightCaptionTeacher  TLabelLabel9LeftTopDWidth!HeightCaptionRoom    