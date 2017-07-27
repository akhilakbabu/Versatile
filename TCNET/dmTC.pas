unit dmTC;

interface

uses
  SysUtils, Classes, ADODB, DB, uAMGDBCoord;

type
  TDM = class(TDataModule)
    qryMain: TADOQuery;
    dbConn: TADOConnection;
    qrySub: TADOQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    FCurrentDir: string;
    FCurrentDBFile: string;
    procedure SetCurrentDir(const Value: string);
  public
    property CurrentDir: string read FCurrentDir write SetCurrentDir;
  end;

var
  DM: TDM;

implementation

{$R *.dfm}

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  {if not Assigned(DBCoord) then
    DBCoord := TDBCoord.Create;
  DBCoord.qryMain := Self.qryMain;
  DBCoord.qrySub := Self.qrySub;
  FCurrentDBFile := 'C:\Data\Database\AMIG.mdf';}
end;

procedure TDM.SetCurrentDir(const Value: string);
begin
  {FCurrentDir := Value;
  dbConn.Close;
  try
    dbConn.ConnectionString := StringReplace(dbConn.ConnectionString, FCurrentDBFile, FCurrentDir + '\AMIG.mdf', [rfIgnoreCase]);
    FCurrentDBFile := FCurrentDir + '\AMIG.mdf';
  finally
    dbConn.Close;  //for now    //dbConn.Open;
  end;}
end;

end.

end.
