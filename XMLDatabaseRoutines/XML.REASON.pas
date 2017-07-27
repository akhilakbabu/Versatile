unit XML.REASON;

interface
uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Dialogs, SysUtils,Messages,TCEglobals, OXmlPDOM, clipBrd, OXmlUtils, XML.UTILS;

const
   REASONS_XML_FILE = 'REASON.XML';

procedure saveReasons_xml;
procedure getReasons_xml;

implementation

procedure saveReasons_xml;
var
  _XML: IXMLDocument;
  _Root, _AbsenceNode, _Attribute, _Node: PXMLNode;
  i: integer;
begin
    chdir(Directories.datadir);
    _XML := CreateXMLDoc('REASONS', True);//create XML doc with root node named "root"   
    _XML.WriterSettings.IndentType := itIndent;
    _Root := _XML.DocumentElement;
    for i:=1 to nmbrReasons do  begin
        if (trim(Abcode[i]) <> '') then begin
          _AbsenceNode := _Root.AddChild('ABSENCE');//add child to root node
          _AbsenceNode.SetAttribute('CODE', Abcode[i]);//set attribute value
          _AbsenceNode.SetAttribute('TEXT', Absent[i]);//set attribute value
        end;
    end;
    for i:=1 to nmbrReasons do  begin
        if (trim(Cover[i]) <> '') then begin
          _AbsenceNode := _Root.AddChild('COVER');//add child to root node
          _AbsenceNode.SetAttribute('ID', IntToStr(i));//set attribute value
          _AbsenceNode.SetAttribute('TEXT', Cover[i]);//set attribute value
        end;
    end;
    _XML.SaveToFile(REASONS_XML_FILE);//save XML document
    //getReasons_xml;
end;


procedure getReasons_xml;
var
  _XML: IXMLDocument;
  _Root, _AbsenceNode, _Attribute, _Node: PXMLNode;
  i, _AbCodeIdx, _CoverIdx: integer;
begin
    chdir(Directories.datadir);
    Abcode[0]:='oth';
    Absent[0]:='(Other reason)';
    _XML := CreateXMLDoc('REASONS', True);
    _XML.LoadFromFile(REASONS_XML_FILE);//load XML document
    _Root := _XML.DocumentElement;//save the root into local variable
    _Node := nil;
    _AbCodeIdx := 1;
    _CoverIdx := 1;
    while _Root.GetNextChild(_Node) do
    begin
       if _Node.NodeName ='ABSENCE' then  begin
          _Attribute:= Nil;
          while _Node.GetNextAttribute(_Attribute) do begin
            if _Attribute.NodeName = 'CODE'  then Abcode[_AbCodeIdx] := _Attribute.NodeValue;
            if _Attribute.NodeName = 'TEXT'  then Absent[_AbCodeIdx] := _Attribute.NodeValue;
          end;
          inc(_AbCodeIdx);
        end;
        _Attribute := nil;
        if _Node.NodeName ='COVER' then  begin
          while _Node.GetNextAttribute(_Attribute) do begin
           // if _Attribute.NodeName = 'ID'  then Abcode[_AbCodeIdx] := _Attribute.NodeValue;
            if _Attribute.NodeName = 'TEXT'  then Cover[_CoverIdx] := _Attribute.NodeValue;
          end;
          inc(_CoverIdx);
        end;
    end;
end;


end.
