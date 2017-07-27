object DM: TDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 178
  Width = 304
  object qryMain: TADOQuery
    Connection = dbConn
    Parameters = <>
    SQL.Strings = (
      'SELECT * FROM Choice')
    Left = 144
    Top = 64
  end
  object dbConn: TADOConnection
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=sql@dm1n;Persist Security Info=True' +
      ';User ID=sa;Initial Catalog=AMIG;Data Source=MICHAELNEW;Use Proc' +
      'edure for Prepare=1;Auto Translate=True;Packet Size=4096;Worksta' +
      'tion ID=MICHAELNEW;Initial File Name=C:\Data\Database\AMIG.mdf;U' +
      'se Encryption for Data=False;Tag with column collation when poss' +
      'ible=False'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 96
    Top = 64
  end
  object qrySub: TADOQuery
    Connection = dbConn
    Parameters = <>
    SQL.Strings = (
      'SELECT * FROM Choice')
    Left = 200
    Top = 64
  end
end
