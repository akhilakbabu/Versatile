unit WebTC;

interface

  uses
    Classes,Dialogs, TimeChartGlobals, SysUtils, XML.UTILS, XML.STUDENTS;

  procedure SCExport;
  procedure SCImport(fname: string);

implementation

  uses
    TCommon, Stcommon;

  // Import StudentChoices.csv from the webtc subdirectory (by default)
  procedure SCImport(fname: string);
  var
     i,j: integer;
     csvData : TStringList;
     row: string;
     rowdata : TStringList;
     Id : integer;
     LastId : integer;
     Choice : integer;
     Subj_Id : integer;
     Fld_Stud:string;
     Fld_Subj:string;
  begin
     LastId := 0;
     rowData := TStringList.create;
     csvData := TStringList.Create;
     csvData.LoadFromFile(fname);
     for i:= 0 to csvData.Count - 1 do
     begin
       // Process each selection
       row := csvData[i];
       rowData.Delimiter := ',';
       rowData.DelimitedText := row;
       if (row <> '') then
       begin
         Fld_Stud := rowData[0];
         Fld_Subj := rowData[2];
         // Find Student By Id
         Id := findStudentByID(Fld_Stud);
         if Id>0 then
         begin
           if Id <> LastId then
           begin
             Choice := 1;
             for j:= 1 to nmbrchoices do
             begin
               XML_STUDENTS.Stud[Id].Choices[j] := 0;
               SaveStudFlag:=true;
               StudYearFlag[XML_STUDENTS.Stud[Id].tcYear]:=true;
             end;
           end;
           // Find Subject
           Subj_Id := 0;
           for j := 1 to NumCodes[0] do
           begin
             if trim(SubCode[j]) = Fld_Subj then
             begin
               Subj_Id := j;
               break;
             end;
           end;
           if Subj_Id > 0 then
           begin
             XML_STUDENTS.Stud[Id].Choices[Choice] := Subj_Id;
             inc(Choice);
           end;
           LastId := Id;
         end;
       end;
     end;
     csvData.Free;
     rowData.Free;
     SaveAllStudentYears;
     ShowMessage('Import Done');
  end;


  // Export all the required files into a subdirectory (WebTC-SC)
  procedure SCExport;
  var
    csvData : TStringList;
    strData : string;
    i: integer;
    csvName: string;
  begin
    // Years
    {
    csvname := datadir+'\webtc';
    ForceDirectories(csvname);
    csvname := csvname + '\SCYear.csv';
    csvData := TStringList.Create;
      strData := 'Id';
      strData := strData + ',';
      strData := strData + 'Year';
      strData := strData + ',';
      strData := strData + 'Use Blocks';
      strData := strData + ',';
      strData := strData + 'Is Active';
      strData := strData + ',';
      strData := strData + 'Closing Date';
      strData := strData + ',';
      strData := strData + 'Number of Choices';
      csvData.Add(strData);
    for i:= 0 to yr do
    begin
      strData := IntToStr(i);
      strData := strData + ',';
      strData := strData + yearname[i];
      strData := strData + ',';
      strData := strData + intToStr(0);      // Use Blocks
      strData := strData + ',';
      strData := strData + intToStr(0);      // Is Active
      strData := strData + ',';
      strData := strData + '';               // Closing Date
      strData := strData + ',';
      strData := strData + intToStr(0);      // Number of Choices
      csvData.Add(strData);
    end;
    csvData.SaveToFile(csvname);
    csvData.Free;
    }
    // Subjects
    csvname := Directories.datadir+'\webtc';
    ForceDirectories(csvname);
    csvname := csvname + '\SCYear.csv';
    csvData := TStringList.Create;
    for i:= 0 to NumCodes[0] do
    begin
      if (copy(subcode[i],1,2)<>'00') then
      begin
        //strData := IntToStr(i);
        //strData := strData + ',';
        strData := strData + SubCode[i];
        strData := strData + ',';
        strData := strData + SubName[i];
        csvData.Add(strData);
      end;
    end;
    csvData.SaveToFile(csvname);

   ShowMessage('Exports - Done - see '+csvname);
 end;

end.
