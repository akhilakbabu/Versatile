unit InUse;

interface
 {$WARN UNIT_PLATFORM OFF}
 {$WARN SYMBOL_PLATFORM OFF}

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, XML.TTABLE, XML.UTILS;

type
  TSpecifyCurTtableDlg = class(TForm)
    Bevel1: TBevel;
    Label1: TLabel;
    ComboBox1: TComboBox;
    finish: TBitBtn;
    update: TBitBtn;
    BitBtn3: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure updateClick(Sender: TObject);
  end;

var
  SpecifyCurTtableDlg: TSpecifyCurTtableDlg;

implementation

uses TimeChartGlobals;

{$R *.dfm}

procedure TSpecifyCurTtableDlg.FormCreate(Sender: TObject);
var
 fsRec:         Tsearchrec;
 FROMdir1,ttwName: string;
 i: smallint;
begin
 combobox1.clear;
 fsrec.name:='';
 FROMdir1:=Directories.datadir; if FROMdir1[length(FROMdir1)]<>'\' then FROMdir1:=FROMdir1+'\';
 findfirst(FROMdir1+'*'+XMLHelper.getTTW_EXTENSION('',JustTheExtension),faArchive,fsRec);
 while (fsRec.name>'') do
  begin
   ttwName:=uppercase(fsrec.name);
   ttwName:=copy(ttwName,1,pos(XMLHelper.getTTW_EXTENSION('',JustTheExtension),ttwName)-1);  //just the filename - no extension
   combobox1.Items.Add(ttwName);

   if findnext(fsRec)<>0 then fsrec.name:='';
  end; {while}
 SysUtils.findclose(fsRec);
 if trim(uppercase(FileNames.CurentTimeTable))>'' then
// combobox1.Text:=TtInUseName;

 if combobox1.items.Count>0 then
  begin
   i:=combobox1.Items.IndexOf(FileNames.CurentTimeTable);
   if i>-1 then combobox1.ItemIndex:=i;
  end;
end;

procedure TSpecifyCurTtableDlg.updateClick(Sender: TObject);
var
 OldTtInUseName,astr: string;
 k: smallint;
 f: file;
begin
 astr:=uppercase(trim(combobox1.Text));
 OldTtInUseName:=FileNames.CurentTimeTable;
 chdir(Directories.datadir);
 if fileexists(XMLHelper.getTTW_EXTENSION(astr,checkExists)) then
    FileNames.CurentTimeTable:=astr;
 if trim(FileNames.CurentTimeTable)='' then FileNames.CurentTimeTable:='Ttable';
 if (UpperCase(FileNames.CurentTimeTable)<>UpperCase(OldTtInUseName)) then
  begin
   RollMarkerExport1:=true;
   RollMarkerExport2:=true;
  end;
 try
  try
   doAssignFile(f,FileNames.CurentTimeTableConfiguration);
   rewrite(f,1);
   blockwrite(f,TtInUseNum,2);
   k:=length(FileNames.CurentTimeTable);
   blockwrite(f,k,2);
   if k>0 then blockwrite(f,FileNames.CurentTimeTable[1],k);
   k:=0;
   blockwrite(f,k,2);
  finally
   closefile(f);
  end;
 except
 end;


end;

end.
