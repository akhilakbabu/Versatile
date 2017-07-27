unit XML.USERS;

interface
uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Dialogs, SysUtils,Messages,  OXmlPDOM, clipBrd, OXmlUtils, TimeChartGlobals,
  XML.UTILS, GlobalToTcAndTcextra;


const
   USER_PASSWORD_XML_FILE = 'TCWP52.XML';   //UserPasswordFilename='TCWP52.DAT';
   EXTRAS_USER_PASSWORD_XML_FILE = 'TCEWP52.XML';

type
  TXML_USERS = class
  private
    fdataFile: string;
    Encrypted: bytebool;
  public
    function DataFile: string;
    procedure saveUserPasswords_xml(_datadir: string);
    procedure getUserPasswords_xml(_datadir: string);
    function FindIdexUserPassword(_passID, _password: string) : integer;
    function FindIdexPassword(_password: string) : integer;
    constructor create(_dataFile: string); reintroduce; virtual;
  end;


var
  passID:    array[0..nmbrUsers] of string; //  Mantis-01618 ;[szPassID];
  password:  array[0..nmbrUsers] of string[szPassword];
  passlevel: array[0..nmbrUsers] of smallint;
  passUserDir: array[0..nmbrUsers] of string[szUserDirName];
  passyear:  array[0..nmbrUsers] of smallint;
  passBKUP:  array[0..nmbrUsers] of boolean;

  XML_USERS: TXML_USERS;


implementation
uses Tcommon5;




constructor TXML_USERS.create(_dataFile: string);
begin
  fdataFile:= _dataFile;
  Encrypted := True;
end;

function TXML_USERS.DataFile: string;
begin
  Result:= fdataFile;
end;

function TXML_USERS.FindIdexPassword(_password: string) : integer;
var i: integer;
begin
  for i:= 1 to  UserRecordsCount do
  begin
    if password[i] = _password then
    begin
      result:= i;
     // showmessage(_password);
      exit;
    end;
  end;
   result:= -1;
end;


function TXML_USERS.FindIdexUserPassword(_passID, _password: string) : integer;
var i: integer;
begin
  for i:= 1 to  UserRecordsCount do
  begin
    if passID[i] <> _passID then
      continue;
    if password[i] <> _password then
      continue;
    result:= i;
    exit;
  end;
   result:= -1;
end;

const intDefKey = -967283;


function String2Hex(const Buffer: Ansistring): string;
begin
  SetLength(result, 2*Length(Buffer));
  BinToHex(@Buffer[1], @result[1], Length(Buffer));
end;

function Hex2Dec(const data: ansistring): byte;
var
  nH1, nH2: byte;
begin
  if data[1] in ['0' .. '9'] then
    nH1 := strtoint(data[1])
  else
    nH1 := 9 + ord(data[1]) - 64;
  if data[2] in ['0' .. '9'] then
    nH2 := strtoint(data[2])
  else
    nH2 := 9 + ord(data[2]) - 64;
  Result := nH1 * 16 + nH2;
end;

function HexStrToStr(const HexStr: ansistring): ansistring;
var
  BufStr: ansistring;
  LenHex: Integer;
  x, y: Integer;
begin
  LenHex := Length(HexStr) div 2;
  x := 1;
  y := 0;
  while y <> LenHex do
  begin
    Inc(y);
    BufStr := BufStr + Chr(Hex2Dec(HexStr[x] + HexStr[x + 1]));
    Inc(x, 2);
  end;
  Result := BufStr;
end;

function Crypt(const strText: string): string;
var
  i: integer;
  strResult: string;
begin
  strResult := strText;
  RandSeed := intDefKey;
  for i := 1 to Length(strText) do
    strResult[i] := Chr(Ord(strResult[i]) xor Random(255));
  Crypt := String2Hex(strResult);
end;



function Decrypt(strText: string): string;
var
  i: integer;
  strResult: string;
begin
  strText :=  HexStrToStr(strText);
  strResult := strText;
  RandSeed := intDefKey;
  for i := 1 to Length(strText) do
    strResult[i] := Chr(Ord(strResult[i]) xor Random(255));
  // deciphers the string
  Decrypt := strResult;
end;

procedure TXML_USERS.getUserPasswords_xml(_datadir: string);
var
  _XML: IXMLDocument;
  _Root, _UserNode, _Attribute, _Node: PXMLNode;
  i, _AbCodeIdx, _CoverIdx: integer;
begin
    chdir(_datadir);
    if not fileExists(fdataFile) then
      Exit;
    Encrypted := True; // by default unless set otherwise in file
    UserRecordsCount := 0;
    _XML := CreateXMLDoc('USERS', True);
    _XML.LoadFromFile(fdataFile);//load XML document
    _Root := _XML.DocumentElement;//save the root into local variable
    _Node := nil;
    while _Root.GetNextChild(_Node) do
    begin
       if _Node.NodeName ='USER' then  begin
          _Attribute:= Nil;
          Inc(UserRecordsCount);
          while _Node.GetNextAttribute(_Attribute) do begin
            if _Attribute.NodeName = 'PASSLEVEL'  then passlevel[UserRecordsCount] := StrToIntDef(_Attribute.NodeValue,0);
            if _Attribute.NodeName = 'PASSYEAR'  then passyear[UserRecordsCount] := StrToIntDef(_Attribute.NodeValue,0);
            if _Attribute.NodeName = 'PASSWORD'  then passWord[UserRecordsCount] := _Attribute.NodeValue;
            if _Attribute.NodeName = 'PASSID'  then passID[UserRecordsCount] := _Attribute.NodeValue;
            if _Attribute.NodeName = 'PASSUSERDIR'  then passUserDir[UserRecordsCount] := _Attribute.NodeValue;
            if _Attribute.NodeName = 'PASSBACKUP'  then byte(passBKUP[UserRecordsCount]) := StrToIntDef(_Attribute.NodeValue,0);
          end;
        end;
        if _Node.NodeName ='SETTINGS' then  begin
          _Attribute:= Nil;
          while _Node.GetNextAttribute(_Attribute) do begin
            if _Attribute.NodeName = 'Encypted'  then Byte(Encrypted) := StrToIntDef(_Attribute.NodeValue,0);
          end;
        end;
    end;
    if Encrypted then
      for i:=1 to UserRecordsCount do
      begin
        passWord[i]:=trim(Decrypt(passWord[i]));
        passID[i]:=trim(Decrypt(passID[i]));
        passUserDir[i]:=trim((passUserDir[i]));   // Decrypt Mantis-01618
      end;
      //for i:=1 to UserRecordsCount do
      //begin
      // showmessage(passID[i]+' '+ passUserDir[i]);
      //end;
    saveUserPasswords_xml(_datadir);

end;

(*
<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<USERS>
  <USER PASSLEVEL="6" PASSYEAR="-1" PASSWORD="BG" PASSID="BG" PASSUSERDIR="D:\_bryan\DATA\20y1" PASSBACKUP="1"/>
  <USER PASSLEVEL="2" PASSYEAR="-1" PASSWORD="GB" PASSID="GB" PASSUSERDIR="D:\amig\Source\TCNET\Users\Student1" PASSBACKUP="1"/>
  <USER PASSLEVEL="1" PASSYEAR="-1" PASSWORD="AG" PASSID="AG" PASSUSERDIR="D:\amig\Source\TCNET\Users\Blocks1" PASSBACKUP="1"/>
  <USER PASSLEVEL="2" PASSYEAR="1" PASSWORD="DP" PASSID="DP" PASSUSERDIR="D:\amig\Source\TCNET\Users\Student2" PASSBACKUP="1"/>
</USERS>
*)


procedure TXML_USERS.saveUserPasswords_xml(_datadir: string);
var
  _XML: IXMLDocument;
  _Root, _UserNode, _Attribute, _Node: PXMLNode;
  i: integer;
  _forcedEncryption: boolean;
begin
    chdir(_datadir);
    _forcedEncryption := Encrypted or true;
  //  _forcedEncryption:= False;    //  Mantis-01618
    _XML := CreateXMLDoc('USERS', True);//create XML doc with root node named "root"
    _XML.WriterSettings.IndentType := itIndent;
    _Root := _XML.DocumentElement;
    _UserNode := _Root.AddChild('SETTINGS');//add child to root node
    _UserNode.SetAttribute('Encypted', IntToStr(Byte(_forcedEncryption)));       //IntToStr(Byte(WSeWarn))
    for i:=1 to UserRecordsCount do  begin
        _UserNode := _Root.AddChild('USER');//add child to root node
        _UserNode.SetAttribute('PASSLEVEL', IntToSTr(passlevel[i]));
        _UserNode.SetAttribute('PASSYEAR', IntToSTr(passyear[i]));
        if _forcedEncryption then begin
          _UserNode.SetAttribute('PASSWORD', Crypt(passWord[i]));
          _UserNode.SetAttribute('PASSID', Crypt(passID[i]));
         _UserNode.SetAttribute('PASSUSERDIR', (passUserDir[i]));    //was Crypt  Mantis-01618
        end
        else begin
          _UserNode.SetAttribute('PASSWORD', passWord[i]);
          _UserNode.SetAttribute('PASSID', passID[i]);
          _UserNode.SetAttribute('PASSUSERDIR', passUserDir[i]);
        end;
        _UserNode.SetAttribute('PASSBACKUP', IntToStr(byte(passBKUP[i])));
    end;
    _XML.SaveToFile(fdataFile);//save XML document
end;


end.
