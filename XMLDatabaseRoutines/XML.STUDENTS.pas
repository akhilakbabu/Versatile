unit XML.STUDENTS;

interface
uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Dialogs, SysUtils,Messages,  OXmlPDOM, clipBrd, OXmlUtils, TimeChartGlobals,
  XML.UTILS, GlobalToTcAndTcextra;

type
  tpStudRec = record
  private
    fSex: string;
    function getSex: string;
    function getValidSex: boolean;
    procedure writeSex(_value: string);
  public
    stname: string[szStName];
    first: string[szStName];
    Choices: array [0..nmbrchoices] of smallint;
    ID: string[szID];
    tcClass: smallint;
    TcYear: smallint; {new 5.0}
    House: smallint;
    tutor: smallint;
    home: smallint;
    TcTag: word;
    strRecord: smallint;
    property Sex: string read  getSex write writeSex;
    property ValidSexHasBeenSelected: boolean read getValidSex;
  end;

  TXML_STUDENTS = class
  private
    fNumStud: smallint;
    procedure setNumStud(_value: smallint);
    function getNumStud: smallint;
  public
    Stud: array of tpStudRec;
    procedure saveToFile(_datadir: string);
    property NumStud: smallint read getNumStud write setNumStud;
  end;

var
  XML_STUDENTS: TXML_STUDENTS;

  genderShort: array[0..2] of string[1]=('M','F','X');
  genderLong: array[0..2] of string=('Male','Female','Unspecified');

function genderGetLongNameFromShort(_short: string): string;
function keyIsInGenderShort(_key: char): boolean;
function getGenderPrompt: string;


implementation


function getGenderPrompt: string;
var i: integer;
begin
    Result:= 'Please check the sex, enter ';
    for i := low(genderShort) to high(genderShort) do
        Result:= Result +  genderShort[i]+' for ' +  genderLong[i] + 'and ';
    delete (Result,length(Result)-3,255);
    Result := trim(Result) + '.';
end;

function genderGetLongNameFromShort(_short: string): string;
begin
    Result:= '';
    if length(_short) < 1 then
      exit;
    if _short[1] = genderShort[0] then result:= genderLong[0];
    if _short[1] = genderShort[1] then result:= genderLong[1];
    if _short[1] = genderShort[2] then result:= genderLong[2];
end;

function keyIsInGenderShort(_key: char): boolean;
var i: integer;
begin
    Result:= True;
    for i := low(genderShort) to high(genderShort) do
        if _key = genderShort[i] then
          Exit;
    Result := false;
end;

{ tpStudRec }

function tpStudRec.getSex: string;
begin
   if length(fSex) > 0 then
      result := fSex[1]
   else
      result:= '';
end;

function tpStudRec.getValidSex: boolean;
var i: integer;
begin
    if length(fSex) < 1 then begin
      result := False;
      exit;
    end;

    Result:= True;
    for i := low(genderShort) to high(genderShort) do
      if fSex[1] = genderShort[i] then
          Exit;
    Result := false;
end;


procedure tpStudRec.writeSex(_value: string);
begin
    fSex:= _value;
end;

{ TXML_STUDENTS }

function TXML_STUDENTS.getNumStud: smallint;
begin
    result:= fNumStud;
end;

procedure TXML_STUDENTS.saveToFile(_datadir: string);
var i: integer;
  _XML: IXMLDocument;
  _Root, _Attribute, _Node: PXMLNode;
  x,y, MaxDay, d: integer;
  _fileName, _TempLabel: string;
  _WideString: WideString;
  tempPointer2: pointer;
  f: file;
begin
  _fileName:='STUDENTS.XML';
  chdir(Directories.datadir);
  _XML := CreateXMLDoc('STUDENTS', True);
  _XML.WriterSettings.IndentType := itIndent;
  _Root := _XML.DocumentElement;
  for i := 1 to NumStud do begin
    _Node := _Root.AddChild('STUDENT');
    _Node.SetAttribute('stname', Stud[i].stname);
    _Node.SetAttribute('first', Stud[i].first);
    _Node.SetAttribute('Choices', 'array [0..nmbrchoices] of smallint');
    _Node.SetAttribute('ID', Stud[i].ID);
    _Node.SetAttribute('tcClass', IntToStr(Stud[i].tcClass));
    _Node.SetAttribute('TcYear', IntToStr(Stud[i].TcYear));
    _Node.SetAttribute('House', IntToStr(Stud[i].House));
    _Node.SetAttribute('tutor', IntToStr(Stud[i].tutor));
    _Node.SetAttribute('home', IntToStr(Stud[i].home));
    _Node.SetAttribute('TcTag', IntToStr(Stud[i].TcTag));
    _Node.SetAttribute('strRecord', IntToStr(Stud[i].strRecord));
    _Node.SetAttribute('Sex', Stud[i].sex);
  end;
  _XML.SaveToFile(_fileName);
end;

procedure TXML_STUDENTS.setNumStud(_value: smallint);
begin
   fNumStud:=  _value;
end;

initialization
  XML_STUDENTS:= TXML_STUDENTS.create;

finalization
  XML_STUDENTS.free;


end.
