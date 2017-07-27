unit XML.TEACHERS;

interface
uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Dialogs, SysUtils,Messages,  OXmlPDOM, clipBrd, OXmlUtils, TimeChartGlobals,
  XML.UTILS, GlobalToTcAndTcextra;

type
  TXML_TEACHERS = class
      tecode: array [0..nmbrteachers, 0..1] of String[szTeCode];
      tename: array [0..nmbrteachers, 0..1] of String[szTeName];
      Load:  tpTeData;  // array [0..nmbrteachers] of smallint;
      Tfaculty:  array [0..nmbrteachers, 1..nmbrTeFacs] of smallint;
      RoSize:  tpTeData;   // array [0..nmbrteachers] of smallint;
      Rfaculty:  array [0..nmbrteachers, 1..3] of smallint;
      DutyLoad: array [0..nmbrteachers, 0..2] of double;
      DutyCode: array [0..nmbrteachers, 0..2] of String[szDutyCode];
  end;

var
  XML_TEACHERS: TXML_TEACHERS;

implementation

initialization
  XML_TEACHERS:= TXML_TEACHERS.Create;

finalization
  XML_TEACHERS.free;


end.
