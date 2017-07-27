unit XML.UTILS;

interface
uses OXmlPDOM, SysUtils, Graphics, Forms;

const
  ATTRIBUTE_X = 'X';
  ATTRIBUTE_Y = 'Y';

  szDirName = 100;
  szUserDirName=128;


function writeToNode(_Root:PXMLNode; _name: string; _value: string; runStringCleaner: boolean):PXMLNode;  overload;
function writeToNode(_Root:PXMLNode; _name: string; _value: single):PXMLNode;  overload;
function writeToNode(_Root:PXMLNode; _name: string; _value: integer):PXMLNode;  overload;
function writeToNode(_Root:PXMLNode; _name: string; _value: wordbool):PXMLNode; overload;

function writeToAttribute(_Node:PXMLNode; _name: string; _value: integer):PXMLNode;  overload;
function writeToAttribute(_Node:PXMLNode; _name: string; _value: wordbool):PXMLNode; overload;
function writeToAttribute(_Node:PXMLNode; _name: string; _value: string):PXMLNode; overload;
function writeToAttribute(_Node:PXMLNode; _name: string; _value: TFontStyles):PXMLNode; overload;
function writeToAttribute(_Node:PXMLNode; _name: string; _value: TWindowState):PXMLNode; overload;

function writeNodeIndexValues(_Node:PXMLNode;_name: string; _index, _value: integer):PXMLNode;    overload;
function writeNodeIndexValues(_Node:PXMLNode;_name: string; _index: integer; _value: wordbool):PXMLNode;    overload;


procedure doAssignFile(var F: file; FileName: string);   overload;
procedure doAssignFile(var F: Textfile; FileName: string); overload;

type
  TFileNames = class
  private

    FTimeTable: string;
    FCurentTimeTable: string;

    function getTimeTable: string;
    procedure setTimeTable(_value: string);

    function getCurentTimeTable: string;
    procedure setCurentTimeTable(_value: string);

    function getTimeTableInuseDataFile: string;
  public
    //Actual Name of the TimeTable in use (ie. value read from  TimeTableInuseDataFile
    property  CurentTimeTable: string read  getCurentTimeTable write  setCurentTimeTable;

    // normally can be same as CurentTimeTableName except when have opened different timetable
    property LoadedTimeTable: String read getTimeTable write setTimeTable;

    // Name of the file where the  TimeTableInuseName is saved
    property  CurentTimeTableConfiguration: string read getTimeTableInuseDataFile;
  end;

  {names of directories}
  TDirectories = class
    // loads from DIR.SYS in application directory
    //  First line is progdir second is datdire
    // D:\amig\Source\TCNET
    // C:\TimeChartJim\20y1
    private
      fdatadir: String;
      Fprogdir: string;
      function GetDataDir: string;
      procedure SetDataDir(_value: string);
      function GetProgDir: string;
      procedure SetProgDir(_value: string);
    public
        UsersDir: String[szDirName];
        blockdir: String[szDirName];
        textdir: String[szDirName];
        timedir: String[szDirName];
        browsedir: String[szDirName];
        RMExportDir: string;
        userDir:      String[szUserDirName];
        defDataDir:   String[szDirName];
        property datadir: String read GetDataDir write SetDataDir;
        property progdir: String read GetProgDir write SetProgDir;
    end;


var FileNames: TFileNames;
    Directories: TDirectories;

implementation



function writeNodeIndexValues(_Node:PXMLNode;_name: string; _index: integer; _value: wordbool):PXMLNode;    overload;
begin
  _name:= uppercase(_name);
   Result := _Node.AddChild(_name);
  Result.SetAttribute('INDEX', IntToStr(_index));
  Result.SetAttribute('VALUE', IntToStr(Byte(_value)));
end;


function writeNodeIndexValues(_Node:PXMLNode; _name: string;_index, _value: integer):PXMLNode;  overload;
begin
  _name:= uppercase(_name);
   Result := _Node.AddChild(_name);
  Result.SetAttribute('INDEX', IntToStr(_index));
  Result.SetAttribute('VALUE', IntToStr(_value));
end;

function writeToAttribute(_Node:PXMLNode; _name: string; _value: TWindowState):PXMLNode; overload;
begin
  _name:= uppercase(_name);
  _Node.SetAttribute(_name, IntToStr(Byte(_value)));
  Result := _Node
end;


function writeToAttribute(_Node:PXMLNode; _name: string; _value: TFontStyles):PXMLNode; overload;
begin
  _name:= uppercase(_name);
  _Node.SetAttribute(_name, IntToStr(Byte(_value)));
  Result := _Node
end;


function writeToAttribute(_Node:PXMLNode; _name: string; _value: string):PXMLNode; overload;
begin
  _name:= uppercase(_name);
  _Node.SetAttribute(_name, _value);
  Result := _Node
end;


function writeToAttribute(_Node:PXMLNode; _name: string; _value: integer):PXMLNode;  overload;
begin
  _name:= uppercase(_name);
  _Node.SetAttribute(_name, IntToStr(_value));
  Result := _Node
end;

function writeToAttribute(_Node:PXMLNode; _name: string; _value: wordbool):PXMLNode; overload;
begin
  _name:= uppercase(_name);
  _Node.SetAttribute(_name, IntToStr(Byte(_value)));
  Result := _Node
end;

function  StringCleaner(s: string): string;
var i: integer;
begin
    Result:= '';
    for i := 1 to Length(s) do begin
        if (s[i] >= ' ') and   (s[i] <= '~') then
            REsult:= Result + s[i];
    end;
end;

function writeToNode(_Root:PXMLNode; _name: string; _value: string; runStringCleaner: boolean):PXMLNode;  overload;
begin
  _name:= uppercase(_name);
  if runStringCleaner then begin
     _value:= StringCleaner(_value);
     _value := trim(_value);
  end;
  Result := _Root.AddChild(_name);//add child to root node
  Result.SetAttribute('VALUE', _value);
end;


function writeToNode(_Root:PXMLNode; _name: string; _value: single):PXMLNode;  overload;
begin
  _name:= uppercase(_name);
  Result := _Root.AddChild(_name);//add child to root node
  Result.SetAttribute('VALUE', FloatToStr(_value));
end;


function writeToNode(_Root:PXMLNode; _name: string; _value: wordbool):PXMLNode; overload;
begin
  _name:= uppercase(_name);
  Result := _Root.AddChild(_name);//add child to root node
  Result.SetAttribute('VALUE', IntToStr(Byte(_value)));
end;


function writeToNode(_Root:PXMLNode; _name: string; _value: integer):PXMLNode;  overload;
begin
  _name:= uppercase(_name);
  Result := _Root.AddChild(_name);//add child to root node
  Result.SetAttribute('VALUE', IntToStr(_value));
end;

procedure doAssignFile(var F: file; FileName: string);  overload;
begin
   system.AssignFile(F, FileName);
end;

procedure doAssignFile(var F: Textfile; FileName: string); overload;
begin
   system.AssignFile(F, FileName);
end;


function TFileNames.getTimeTableInuseDataFile: string;
begin
  Result := 'TTinUse.DAT';
end;

function TFileNames.getCurentTimeTable: string;
begin
   Result := FCurentTimeTable;
end;

function TFileNames.getTimeTable: string;
begin
    Result := FTimeTable;
end;

procedure TFileNames.setCurentTimeTable(_value: string);
begin
  if FCurentTimeTable = _value  then
      Exit;
  FCurentTimeTable :=  _value;
end;

function TDirectories.GetDataDir: string;
begin
   Result := fDataDir;
end;

function TDirectories.GetProgDir: string;
begin
   Result := Fprogdir;
end;

procedure TDirectories.SetDataDir(_value: string);
begin
   fDataDir :=  _value;
end;


procedure TDirectories.SetProgDir(_value: string);
begin
   Fprogdir :=  _value;
end;

procedure TFileNames.setTimeTable(_value: string);
begin
    if FTimeTable = _value  then
      Exit;
    FTimeTable :=  _value;
end;




end.
