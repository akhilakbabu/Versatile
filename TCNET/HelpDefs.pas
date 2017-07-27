{=====================================================================
  Copyright 1993-1996 by Teletech Systems, Inc. All rights reserved


This source code may not be distributed in part or as a whole without
express written permission from Teletech Systems.
=====================================================================}
unit HelpDefs;
interface



{ To add help to your application, add the statement
  
  Application.Helpfile := 'Tc5win.hlp';
  
  to your project startup file (*.DPR).
  
  [F1] key help will work automatically, if you allowed HelpWriter to 
  update your code. }
{=====================================================================
 List of Context IDs for <Tc5win>
 =====================================================================}
 const
      Hlp_Time_Chart = 1;    {Main Help Window}
      Hlp_File_ = 2;    {Main Help Window}
      Hlp_Display_ = 12;    {Main Help Window}
      Hlp_Find_ = 25;    {Main Help Window}
      Hlp_Student_ = 29;    {Main Help Window}
      Hlp_Timetable_ = 81;    {Main Help Window}
      Hlp_Window_ = 126;    {Main Help Window}
      Hlp_Help_ = 209;    {Main Help Window}
      Hlp_Reload_student = 30;    {Main Help Window}
      Hlp_x_ = 325;    {Main Help Window}
      Hlp_Select_group = 33;    {Main Help Window}
      Hlp_x_1 = 335;    {Main Help Window}
      Hlp_1_ = 345;    {Main Help Window}
      Hlp_2_ = 355;    {Main Help Window}
      Hlp_3_ = 365;    {Main Help Window}
      Hlp_4_ = 375;    {Main Help Window}
      Hlp_5_ = 385;    {Main Help Window}
      Hlp_6_ = 395;    {Main Help Window}
      Hlp_7_ = 405;    {Main Help Window}
      Hlp_8_ = 415;    {Main Help Window}
      Hlp_9_ = 425;    {Main Help Window}
      Hlp_10_ = 435;    {Main Help Window}
      Hlp_11_ = 445;    {Main Help Window}
      Hlp_12_ = 455;    {Main Help Window}
      Hlp_13_ = 465;    {Main Help Window}
      Hlp_14_ = 475;    {Main Help Window}
      Hlp_15_ = 485;    {Main Help Window}
      Hlp_16_ = 495;    {Main Help Window}
      Hlp_Blocks_Window = 157;    {Main Help Window}
      Hlp_Edit_ = 610;    {Main Help Window}
      Hlp_Blocks_ = 56;    {Main Help Window}
      Hlp_Move_Subjectxxx = 63;    {Main Help Window}
      Hlp_Split_Subjectxxx = 67;    {Main Help Window}
      Hlp_Auto_Allocationxxx = 68;    {Main Help Window}
      Hlp_Exclude_Subjectsxxx = 69;    {Main Help Window}
      Hlp_Fix_Subjectsxxx = 70;    {Main Help Window}
      Hlp_Clash_Helpxxx = 72;    {Main Help Window}
      Hlp_Clear_ = 58;    {Main Help Window}
      Hlp_Loadxxx_ = 59;    {Main Help Window}
      Hlp_Savexxx_ = 60;    {Main Help Window}
      Hlp_x_2 = 620;    {Main Help Window}
      Hlp_Printxxx_ = 9;    {Main Help Window}
      Hlp_Print_Setup = 10;    {Main Help Window}
      Hlp_Export_as = 630;    {Main Help Window}
      Hlp_Copy_text = 640;    {Main Help Window}
      Hlp_Set_New = 8;    {Main Help Window}
      Hlp_Codes_ = 650;    {Main Help Window}
      Hlp_Codes_1 = 211;    {Main Help Window}
      Hlp_Add_xxx = 810;    {Main Help Window}
      Hlp_Change_xxx = 820;    {Main Help Window}
      Hlp_Delete_xxx = 830;    {Main Help Window}
      Hlp_x_3 = 840;    {Main Help Window}
      Hlp_Timetable_1 = 850;    {Main Help Window}
      Hlp_View_xxx = 860;    {Main Help Window}
      Hlp_Code_Lengths = 870;    {Main Help Window}
      Hlp_Show_Classes = 880;    {Main Help Window}
      Hlp_x_4 = 890;    {Main Help Window}
      Hlp_Print_xxx = 9;    {Main Help Window}
      Hlp_Print_Setup1 = 10;    {Main Help Window}
      Hlp_Export_as1 = 900;    {Main Help Window}
      Hlp_Dialog_ = 910;    {Main Help Window}
      Hlp_Add_Subject = 131;    {Main Help Window}
      Hlp_Change_Teacher = 139;    {Main Help Window}
      Hlp_Add_Room = 144;    {Main Help Window}
      Hlp_Add_Teacher = 138;    {Main Help Window}
      Hlp_Change_Subject = 132;    {Main Help Window}
      Hlp_Change_Room = 145;    {Main Help Window}
      Hlp_Delete_Subject = 133;    {Main Help Window}
      Hlp_Delete_Teacher = 140;    {Main Help Window}
      Hlp_Delete_Room = 146;    {Main Help Window}
      Hlp_codelendlg_ = 920;    {Main Help Window}
      Hlp_Change_Roll = 314;    {Main Help Window}
      Hlp_Change_Houses = 153;    {Main Help Window}
      Hlp_Change_Times = 155;    {Main Help Window}
      Hlp_Preferences_ = 14;    {Main Help Window}
      Hlp_Select_Group1 = 32;    {Main Help Window}
      Hlp_Configure_Years = 85;    {Main Help Window}
      Hlp_Configure_Days = 86;    {Main Help Window}
      Hlp_Configure_Time = 87;    {Main Help Window}
      Hlp_Time_Table = 90;    {Main Help Window}
      Hlp_Entries_xxx = 99;    {Main Help Window}
      Hlp_Build_xxx = 104;    {Main Help Window}
      Hlp_Move_xxx = 111;    {Main Help Window}
      Hlp_Clash_Help = 112;    {Main Help Window}
      Hlp_Solve_xxx = 113;    {Main Help Window}
      Hlp_Search_and = 122;    {Main Help Window}
      Hlp_Go_to = 121;    {Main Help Window}
      Hlp_Alter_xxx = 123;    {Main Help Window}
      Hlp_Subject_Timetable = 198;    {Main Help Window}
      Hlp_Teacher_Timetable = 194;    {Main Help Window}
      Hlp_Room_Timetable = 196;    {Main Help Window}
      Hlp_Class_Timetable = 198;    {Main Help Window}
      Hlp_Teachers_Free = 2910;    {Main Help Window}
      Hlp_Rooms_Free = 2920;    {Main Help Window}
      Hlp_x_5 = 2930;    {Main Help Window}
      Hlp_Print_Selection = 2940;    {Main Help Window}
      Hlp_Print_xxx1 = 2950;    {Main Help Window}
      Hlp_Print_Setup2 = 2960;    {Main Help Window}
      Hlp_Export_as2 = 2970;    {Main Help Window}
      Hlp_Edit_1 = 2980;    {Main Help Window}
      Hlp_Timetable_2 = 81;    {Main Help Window}
      Hlp_Window_Display = 127;    {Main Help Window}
      Hlp_Print_xxx2 = 9;    {Main Help Window}
      Hlp_Print_Setup3 = 10;    {Main Help Window}
      Hlp_Export_as3 = 3010;    {Main Help Window}
      Hlp_Set_Blocks = 57;    {Main Help Window}
      Hlp_Copy_Blocks = 61;    {Main Help Window}
      Hlp_Move_Subject = 3020;    {Main Help Window}
      Hlp_Split_Subject = 3030;    {Main Help Window}
      Hlp_Swap_Subjects = 64;    {Main Help Window}
      Hlp_Automatic_Allocation = 3040;    {Main Help Window}
      Hlp_Link_subjects = 71;    {Main Help Window}
      Hlp_Clash_Help1 = 3050;    {Main Help Window}
      Hlp_Timetable_Entries = 3060;    {Main Help Window}
      Hlp_Timetable_Entriesx = 101;    {Main Help Window}
      Hlp_Timetable_Entriesx1 = 100;    {Main Help Window}
      Hlp_Timetable_Entriesx2 = 103;    {Main Help Window}
      Hlp_Timetable_Entriesx3 = 102;    {Main Help Window}
      Hlp_Blocks_Clash = 73;    {Main Help Window}
      Hlp_Exclude_Subjects = 3070;    {Main Help Window}
      Hlp_Set_Timetable = 84;    {Main Help Window}
      Hlp_Configure_Levels = 88;    {Main Help Window}
      Hlp_Exchange_Blocks = 80;    {Main Help Window}
      Hlp_Printer_margins = 18;    {Main Help Window}
      Hlp_Go_to1 = 3080;    {Main Help Window}
      Hlp_Teacher_Clashes = 179;    {Main Help Window}
      Hlp_Selection_xxx = 180;    {Main Help Window}
      Hlp_x_6 = 4710;    {Main Help Window}
      Hlp_Print_xxx3 = 9;    {Main Help Window}
      Hlp_Print_Setup4 = 10;    {Main Help Window}
      Hlp_Export_as4 = 4720;    {Main Help Window}
      Hlp_Find_Room = 28;    {Main Help Window}
      Hlp_Find_Student = 26;    {Main Help Window}
      Hlp_Find_Teacher = 27;    {Main Help Window}
      Hlp_Edit_Custom = 23;    {Main Help Window}
      Hlp_Clear_1 = 5110;    {Main Help Window}
      Hlp_New_xxx = 5120;    {Main Help Window}
      Hlp_Open_xxx = 5130;    {Main Help Window}
      Hlp_Save_xxx = 5140;    {Main Help Window}
      Hlp_Clash_Help2 = 5150;    {Main Help Window}
      Hlp_Timetable_Print = 173;    {Main Help Window}
      Hlp_About_ = 5160;    {Main Help Window}
      Hlp_Clash_Help3 = 175;    {Main Help Window}
      Hlp_Selection_xxx1 = 112;    {Main Help Window}
      Hlp_x_7 = 5510;    {Main Help Window}
      Hlp_Print_xxx4 = 9;    {Main Help Window}
      Hlp_Print_Setup5 = 10;    {Main Help Window}
      Hlp_Export_as5 = 5520;    {Main Help Window}
      Hlp_Teachers_Free1 = 183;    {Main Help Window}
      Hlp_Teachers_Free2 = 184;    {Main Help Window}
      Hlp_Selection_xxx2 = 183;    {Main Help Window}
      Hlp_x_8 = 5710;    {Main Help Window}
      Hlp_Print_xxx5 = 9;    {Main Help Window}
      Hlp_Print_Setup6 = 10;    {Main Help Window}
      Hlp_Export_as6 = 5720;    {Main Help Window}
      Hlp_Rooms_Free1 = 186;    {Main Help Window}
      Hlp_Selection_xxx3 = 185;    {Main Help Window}
      Hlp_x_9 = 5810;    {Main Help Window}
      Hlp_Print_xxx6 = 9;    {Main Help Window}
      Hlp_Print_Setup7 = 10;    {Main Help Window}
      Hlp_Export_as7 = 5820;    {Main Help Window}
      Hlp_Rooms_Free2 = 5830;    {Main Help Window}
      Hlp_Promote_Students = 51;    {Main Help Window}
      Hlp_Student_List = 163;    {Main Help Window}
      Hlp_Selection_xxx4 = 164;    {Main Help Window}
      Hlp_x_10 = 6110;    {Main Help Window}
      Hlp_Group_ = 31;    {Main Help Window}
      Hlp_Add_Student = 44;    {Main Help Window}
      Hlp_Change_Student = 47;    {Main Help Window}
      Hlp_Delete_Student = 48;    {Main Help Window}
      Hlp_Common_Data = 49;    {Main Help Window}
      Hlp_Clear_Choices = 50;    {Main Help Window}
      Hlp_Student_Timetable = 171;    {Main Help Window}
      Hlp_x_11 = 6120;    {Main Help Window}
      Hlp_Print_xxx7 = 9;    {Main Help Window}
      Hlp_Print_Setup8 = 10;    {Main Help Window}
      Hlp_Export_as8 = 6130;    {Main Help Window}
      Hlp_Copy_Text1 = 6140;    {Main Help Window}
      Hlp_Edit_2 = 6150;    {Main Help Window}
      Hlp_Create_Blocks = 62;    {Main Help Window}
      Hlp_Block_Clashes = 177;    {Main Help Window}
      Hlp_Block_Clashes1 = 178;    {Main Help Window}
      Hlp_Selection_xxx5 = 177;    {Main Help Window}
      Hlp_x_12 = 6410;    {Main Help Window}
      Hlp_Print_xxx8 = 9;    {Main Help Window}
      Hlp_Print_Setup9 = 10;    {Main Help Window}
      Hlp_Export_as9 = 6420;    {Main Help Window}
      Hlp_Clash_Matrix = 166;    {Main Help Window}
      Hlp_Selection_xxx6 = 167;    {Main Help Window}
      Hlp_x_13 = 6510;    {Main Help Window}
      Hlp_Print_xxx9 = 9;    {Main Help Window}
      Hlp_Print_Setup10 = 10;    {Main Help Window}
      Hlp_Export_as10 = 6520;    {Main Help Window}
      Hlp_Clash_Matrix1 = 6530;    {Main Help Window}
      Hlp_Subject_List = 159;    {Main Help Window}
      Hlp_Teacher_Loads = 188;    {Main Help Window}
      Hlp_Selection_xxx7 = 187;    {Main Help Window}
      Hlp_x_14 = 6810;    {Main Help Window}
      Hlp_Print_xxx10 = 9;    {Main Help Window}
      Hlp_Print_Setup11 = 10;    {Main Help Window}
      Hlp_Export_as11 = 6820;    {Main Help Window}
      Hlp_Teacher_Loads1 = 6830;    {Main Help Window}
      Hlp_Subject_Times = 189;    {Main Help Window}
      Hlp_Selection_xxx8 = 190;    {Main Help Window}
      Hlp_x_15 = 7010;    {Main Help Window}
      Hlp_Print_xxx11 = 9;    {Main Help Window}
      Hlp_Print_Setup12 = 10;    {Main Help Window}
      Hlp_Export_as12 = 7020;    {Main Help Window}
      Hlp_Subject_Times1 = 7030;    {Main Help Window}
      Hlp_Group_of = 191;    {Main Help Window}
      Hlp_Selection_xxx9 = 192;    {Main Help Window}
      Hlp_x_16 = 7210;    {Main Help Window}
      Hlp_Print_xxx12 = 9;    {Main Help Window}
      Hlp_Print_Setup13 = 10;    {Main Help Window}
      Hlp_Export_as13 = 7220;    {Main Help Window}
      Hlp_Group_of1 = 7230;    {Main Help Window}
      Hlp_Room_Timetable1 = 7240;    {Main Help Window}
      Hlp_Selection_xxx10 = 195;    {Main Help Window}
      Hlp_x_17 = 7410;    {Main Help Window}
      Hlp_Print_xxx13 = 9;    {Main Help Window}
      Hlp_Print_Setup14 = 10;    {Main Help Window}
      Hlp_Export_as14 = 7420;    {Main Help Window}
      Hlp_Room_Timetable2 = 7430;    {Main Help Window}
      Hlp_Teacher_Timetable1 = 7440;    {Main Help Window}
      Hlp_Selection_xxx11 = 193;    {Main Help Window}
      Hlp_x_18 = 7610;    {Main Help Window}
      Hlp_Print_xxx14 = 9;    {Main Help Window}
      Hlp_Print_Setup15 = 10;    {Main Help Window}
      Hlp_Export_as15 = 7620;    {Main Help Window}
      Hlp_Teacher_Timetable2 = 7630;    {Main Help Window}
      Hlp_Student_Timetable1 = 7640;    {Main Help Window}
      Hlp_Selection_xxx12 = 172;    {Main Help Window}
      Hlp_x_19 = 7810;    {Main Help Window}
      Hlp_Print_xxx15 = 9;    {Main Help Window}
      Hlp_Print_Setup16 = 10;    {Main Help Window}
      Hlp_Export_as16 = 7820;    {Main Help Window}
      Hlp_Student_List1 = 7830;    {Main Help Window}
      Hlp_Student_Timetable2 = 7840;    {Main Help Window}
      Hlp_Backup_Data = 219;    {Main Help Window}
      Hlp_Find_Student1 = 7850;    {Main Help Window}
      Hlp_Selection_xxx13 = 8210;    {Main Help Window}
      Hlp_x_20 = 8220;    {Main Help Window}
      Hlp_Print_xxx16 = 9;    {Main Help Window}
      Hlp_Print_Setup17 = 10;    {Main Help Window}
      Hlp_Export_as17 = 8230;    {Main Help Window}
      Hlp_Room_Clashes = 181;    {Main Help Window}
      Hlp_Selection_xxx14 = 182;    {Main Help Window}
      Hlp_x_21 = 8310;    {Main Help Window}
      Hlp_Print_xxx17 = 9;    {Main Help Window}
      Hlp_Print_Setup18 = 10;    {Main Help Window}
      Hlp_Export_as18 = 8320;    {Main Help Window}
      Hlp_Subject_Timetable1 = 8330;    {Main Help Window}
      Hlp_Selection_xxx15 = 197;    {Main Help Window}
      Hlp_x_22 = 8410;    {Main Help Window}
      Hlp_Print_xxx18 = 9;    {Main Help Window}
      Hlp_Print_Setup19 = 10;    {Main Help Window}
      Hlp_Export_as19 = 8420;    {Main Help Window}
      Hlp_SubByTimeSlotWin_ = 161;    {Main Help Window}
      Hlp_Selection_xxx16 = 162;    {Main Help Window}
      Hlp_x_23 = 8510;    {Main Help Window}
      Hlp_Print_xxx19 = 9;    {Main Help Window}
      Hlp_Print_Setup20 = 10;    {Main Help Window}
      Hlp_Export_as20 = 8520;    {Main Help Window}
      Hlp_SubBySubjectWin_ = 160;    {Main Help Window}
      Hlp_Selection_xxx17 = 159;    {Main Help Window}
      Hlp_x_24 = 8610;    {Main Help Window}
      Hlp_Print_xxx20 = 9;    {Main Help Window}
      Hlp_Print_Setup21 = 10;    {Main Help Window}
      Hlp_Export_as21 = 8620;    {Main Help Window}
      Hlp_Subject_Timetable2 = 8630;    {Main Help Window}
      Hlp_Change_Faculty = 151;    {Main Help Window}
      Hlp_Browse_ = 8640;    {Main Help Window}
      Hlp_addstuddlg_ = 8650;    {Main Help Window}
      Hlp_Delete_Student1 = 8660;    {Main Help Window}
      Hlp_delyrsubdlg_ = 55;    {Main Help Window}
      Hlp_Replace_Year = 54;    {Main Help Window}
      Hlp_Group_Subjects = 52;    {Main Help Window}
      Hlp_Group_Subjects1 = 212;    {Main Help Window}
      Hlp_Replace_xxx = 54;    {Main Help Window}
      Hlp_Remove_xxx = 55;    {Main Help Window}
      Hlp_Subject_List1 = 160;    {Main Help Window}
      Hlp_x_25 = 9410;    {Main Help Window}
      Hlp_Print_xxx21 = 9;    {Main Help Window}
      Hlp_Print_Setup22 = 10;    {Main Help Window}
      Hlp_Export_as22 = 9420;    {Main Help Window}
      Hlp_Change_Student1 = 9430;    {Main Help Window}
      Hlp_Alter_Timetable = 9440;    {Main Help Window}
      Hlp_Search_and1 = 9450;    {Main Help Window}
      Hlp_Block_Clashes2 = 114;    {Main Help Window}
      Hlp_Build_ = 9460;    {Main Help Window}
      Hlp_Buildx_Clear = 106;    {Main Help Window}
      Hlp_Buildx_Style1 = 109;    {Main Help Window}
      Hlp_Buildx_Reset = 108;    {Main Help Window}
      Hlp_Buildx_Warn = 107;    {Main Help Window}
      Hlp_Move_Entries = 9470;    {Main Help Window}
      Hlp_Solve_Clashes = 9480;    {Main Help Window}
      Hlp_Student_Input = 169;    {Main Help Window}
      Hlp_Selection_xxx18 = 170;    {Main Help Window}
      Hlp_x_26 = 10210;    {Main Help Window}
      Hlp_Print_xxx22 = 9;    {Main Help Window}
      Hlp_Print_Setup23 = 10;    {Main Help Window}
      Hlp_Export_as23 = 10220;    {Main Help Window}
      Hlp_Student_Input1 = 10230;    {Main Help Window}
      Hlp_Size_of = 231;    {Main Help Window}
      Hlp_Text_settings = 305;    {Main Help Window}
      Hlp_Add_Roll = 150;    {Main Help Window}
      Hlp_Delete_Roll = 315;    {Main Help Window}
      Hlp_Class_Code = 316;    {Main Help Window}
      Hlp_Roll_classes = 304;    {Main Help Window}
      Hlp_Sort_Group = 10240;    {Main Help Window}
      Hlp_Goup_menus = 41;    {Main Help Window}
      Hlp_Hints_and = 10250;    {Main Help Window}
      Hlp_Restore_data = 235;    {Main Help Window}
      Hlp_Configure_blocks = 310;    {Main Help Window}
      Hlp_Timetable_Toolbar = 265;    {Main Help Window}
      Hlp_Timetable_Toolbarx = 30;    {Main Help Window}
      Hlp_Blocking_toolbar = 286;    {Main Help Window}
      Hlp_Blocking_toolbarx = 30;    {Main Help Window}
      Hlp_General_toolbar = 243;    {Main Help Window}
      Hlp_General_toolbarx = 30;    {Main Help Window}
      Hlp_Segregate_Subjects = 79;    {Main Help Window}
      Hlp_Change_Times1 = 10260;    {Main Help Window}
      Hlp_View_times = 10270;    {Main Help Window}
      Hlp_x_27 = 12110;    {Main Help Window}
      Hlp_x_28 = 12120;    {Main Help Window}
      Hlp_x_29 = 12130;    {Main Help Window}
      Hlp_x_30 = 12140;    {Main Help Window}
      Hlp_x_31 = 12150;    {Main Help Window}
      Hlp_x_32 = 12160;    {Main Help Window}
      Hlp_x_33 = 12170;    {Main Help Window}
      Hlp_x_34 = 12180;    {Main Help Window}
      Hlp_x_35 = 12190;    {Main Help Window}
      Hlp_x_36 = 12200;    {Main Help Window}
      Hlp_x_37 = 12210;    {Main Help Window}
      Hlp_x_38 = 12220;    {Main Help Window}
      Hlp_x_39 = 12230;    {Main Help Window}
      Hlp_x_40 = 12240;    {Main Help Window}
      Hlp_x_41 = 12250;    {Main Help Window}
      Hlp_x_42 = 12260;    {Main Help Window}
      Hlp_x_43 = 12270;    {Main Help Window}
      Hlp_x_44 = 12280;    {Main Help Window}
      Hlp_x_45 = 12290;    {Main Help Window}
      Hlp_x_46 = 12300;    {Main Help Window}
      Hlp_x_47 = 12410;    {Main Help Window}
      Hlp_x_48 = 12420;    {Main Help Window}
      Hlp_x_49 = 12430;    {Main Help Window}
      Hlp_x_50 = 12610;    {Main Help Window}
      Hlp_x_51 = 12620;    {Main Help Window}
      Hlp_x_52 = 14610;    {Main Help Window}
      Hlp_x_53 = 14620;    {Main Help Window}
      Hlp_x_54 = 14630;    {Main Help Window}
      Hlp_x_55 = 14640;    {Main Help Window}
      Hlp_About_1 = 14650;    {Main Help Window}
      Hlp_x_56 = 17810;    {Main Help Window}
      Hlp_Block_Clashes3 = 17820;    {Main Help Window}
      Hlp_Hints_and1 = 17830;    {Main Help Window}
 {Glossary definitions}


implementation

end.

