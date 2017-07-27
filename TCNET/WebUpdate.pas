unit WebUpdate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Winsock, ComCtrls, Buttons,
  IdAntiFreezeBase, IdAntiFreeze, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, XML.UTILS, XML.DISPLAY;

type
  TWebUpdateDlg = class(TForm)
    Yes: TBitBtn;
    Later: TBitBtn;
    Label11: TLabel;
    OK: TBitBtn;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label16: TLabel;
    GroupBox2: TGroupBox;
    Label13: TLabel;
    Label15: TLabel;
    Label14: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    ComboBox1: TComboBox;
    IdHTTP1: TIdHTTP;
    IdAntiFreeze1: TIdAntiFreeze;
    procedure DoUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FIsUpdateAvailable: Boolean;
    FCurrentlyOnline: Boolean;
    function GetInetFile(const pFileToDownload, pDestFile: string): Boolean;
    function CheckFeatures: Boolean;
  public
    procedure CheckForOnlineUpdate;
    property IsUpdateAvailable: Boolean read FIsUpdateAvailable write FIsUpdateAvailable;
    property CurrentlyOnline: Boolean read FCurrentlyOnline write FCurrentlyOnline default False;
  end;

var
  WebUpdateDlg: TWebUpdateDlg;

implementation

uses
  Wininet, tcload, TimeChartGlobals, tcommon, tcommon2, shellapi, dateutils, ABZipTyp,
  AbZipper, uAMGCommon, LoadProgress, uAMGConst, NewFeatures;

{$R *.dfm}

var
 UpdateAvailableOnline: boolean=false;
 FileOnNet: string='http://www.amig.com.au/download/Updates/TC6NET/TCNET.TMP';
 LocalFileName: string='TCNET.TMP';
 ApplicationType: string='Network Time Chart 6';

function FNIsInternetConnected: Boolean;
const
 INTERNET_USES_MODEM=1;
 INTERNET_USES_LAN=2;
 INTERNET_USES_PROXY=4;
var
 dwConnectionTypes:DWORD;
begin
 dwConnectionTypes:=INTERNET_USES_MODEM+INTERNET_USES_LAN+INTERNET_USES_PROXY;
 result:=InternetGetConnectedState(@dwConnectionTypes,0);
end;

function TWebUpdateDlg.GetInetFile(const pFileToDownload, pDestFile: string): Boolean;
var
 DownloadFile: string;
 stream_2 : TMemoryStream ;
begin
 try
  result:=false;
  DownloadFile := pDestFile;
  if (Directories.progdir[length(Directories.progdir)]<>'\') then DownloadFile:='\'+DownloadFile;
  DownloadFile:=Directories.progdir+DownloadFile;
  stream_2 := TMemoryStream.Create;
  try
   IdHTTP1.Get(pFileToDownload, stream_2);
  except
  end;
  stream_2.SaveToFile(DownloadFile);
  stream_2.Free;
  if fileexists(DownloadFile)then result:=true;
 except
  result:=false;
 end;
end;

function TWebUpdateDlg.CheckFeatures: Boolean;
var
  lFrmNewFeatures: TFrmNewFeatures;
begin
  Result := False;
  if GetInetFile('http://www.amig.com.au/download/Updates/TC6NET/TCRM.TMP', 'TCRM.txt') then
  begin
    lFrmNewFeatures := TFrmNewFeatures.Create(Application);
    try
      lFrmNewFeatures.RMFile := Directories.ProgDir + '\TCRM.txt';
      Result := lFrmNewFeatures.ShowModal = mrOK;
    finally
      FreeAndNil(lFrmNewFeatures);
    end;
  end;
  //else
end;

procedure TWebUpdateDlg.CheckForOnlineUpdate;
var
  astr,bstr: string;
  NewUpdateStr: ShortString;
  NewUpdateYear,NewUpdateMonth,NewUpdateDay: ShortString;
  LatestAvailUpdate: TDateTime;
  Source: ShortString;
  i: Integer;
  zz,yy: Integer;
  tmpStr: string;
  chkAppStr,
  chkVersionStr: string;
  chkFileSize: Longint;
begin
  if not(FCurrentlyOnline) then
    Exit;
  if GetInetFile(FileOnNet, LocalFileName) then
  begin   //able to download small checkFile
    LastUpdateCheck := Now;   // update checked date - don't check again for another week.
    updatebackupfile; {store LastUpdateCheck}
    UpdateAvailableOnline := False;
    Source:=GetEncryptStr(LocalFileName,'@ª¹ß NZVT FLFGRZF¶±GP5.3 Argjbex¿¾´·©Nhthfg 2004º°');
    DeleteFile(LocalFileName);
    if Source>'' then
    begin
      i := Pos(endline, Source);
      chkAppStr := Copy(Source,1,i-1);
      Source := Copy(Source,i+2,length(Source));

      i := Pos(endline, Source);
      chkVersionStr := Copy(Source,1,i-1);
      Source := Copy(Source,i+2,length(Source));

      i := Pos(endline,Source);
      tmpStr := Copy(Source,1,i-1);
      Source := Copy(Source,i+2,length(Source));
      chkFileSize := StrToIntDef(Trim(tmpStr),0);

      NewUpdateStr := Copy(Source,1,length(Source));
      tmpStr := NewUpdateStr;

      //def date of update Feb 27 2004
      NewUpdateYear := Copy(tmpStr,1,4);
      tmpStr := Copy(tmpStr,6,length(tmpStr));
      zz := Pos('/',tmpStr);
      NewUpdateMonth:=copy(tmpStr,1,zz-1);
      yy := Pos('\',tmpStr);
      NewUpdateDay:=copy(tmpStr,zz+1,(yy-(zz+1)));

      yy := Pos('\',NewUpdateStr);
      NewUpdateStr := Copy(NewUpdateStr, 1, yy-1);

      LatestAvailUpdate:=EncodeDate(
      strtointdef(NewUpdateYear,2004),
      strtointdef(NewUpdateMonth,2),
      strtointdef(NewUpdateDay,27));
      FIsUpdateAvailable := False;
      if chkAppStr = ApplicationType then
        if (chkVersionStr>TCvers) then
          if (UpdateReleaseDate<LatestAvailUpdate) then  //newer version avail
          begin
            FIsUpdateAvailable := True;
            astr := FormatDateTime('  d mmmm yyyy  ', LatestAvailUpdate);
            bstr := Copy(chkVersionStr, 8, Length(chkVersionStr));
            label3.Caption := bstr+astr + '('+inttostr(chkFileSize div 1024) + ' KBytes)';
            astr := FormatDateTime('  d mmmm yyyy  ', UpdateReleaseDate);
            bstr := copy(TCvers,8,Length(TCvers));
            label16.Caption:=bstr+astr;
            astr := FormatDateTime(' d mmmm yyyy  ', SupportExpiryKeyCheckDate);
            label14.Caption := astr;
           //on support plan?
            if (LatestAvailUpdate<=SupportExpiryKeyCheckDate) then
            begin
              Later.Visible := True;
              Yes.Visible := True;
              Label11.Visible := True;
            end
            else
            begin
              Label13.Caption := 'Your Support Plan expiry date -';
              label15.Caption := AMG_RENEW_SUPPORT_PLAN_MSG;
              label2.Visible := True;
              ok.Visible := True;
            end;
            WebUpdateDlg.ShowModal;
          end;  //if
    end; //if

    ChDir(Directories.datadir);
  end; {if getWebUpdate>0 then}
end;

procedure TWebUpdateDlg.DoUpdate(Sender: TObject);
var
  lFrmLoadProgress: TFrmLoadProgress;
  i: Integer;
  lDestFile: string;
  lUserAllowed: Boolean;
  lHelpFile: string;
  lDestHFile: string;
begin
  // open webpage in browser
  //ShellExecute(0, Nil, PChar('http://www.amig.com.au/updates.html'), Nil, Nil, SW_SHOWNORMAL);
  lHelpFile := 'TCH.tmp';
  if FileExists(AMG_UPDATER) then
  begin
    DeleteFile(AMG_UPDATER);
    Application.ProcessMessages;
  end;
  if MessageDlg(AMG_CHECK_FEATURES_MSG, mtConfirmation, mbYesNo, 0) = mrYes then
     lUserAllowed := CheckFeatures
  else
    lUserAllowed := True;
  if lUserAllowed and (MessageDlg(AMG_UPDATE_CONFIRMATION_MSG, mtConfirmation, mbOKCancel, 0) = mrOk) then
  begin
    Self.Hide;
    lFrmLoadProgress := TFrmLoadProgress.Create(Application);
    try
      lFrmLoadProgress.Title := AMG_TIME_CHART_UPDATE;
      lFrmLoadProgress.Show;
      lDestFile := Directories.ProgDir + '\TC6NET.tmp';
      lDestHFile := Directories.ProgDir + '\' + lHelpFile;
    lFrmLoadProgress.UpdateProgress(20, 'Downloading Time Chart updates...', 500);    //Give the user chance to read the messages
      if DownloadFile('http://www.amig.com.au/download/Updates/TC6NET/TCU.tmp', Directories.ProgDir + '\' + AMG_UPDATER) then
      begin
        if DownloadFile('http://www.amig.com.au/download/Updates/TC6NET/TC6NET.tmp', lDestFile) then
        begin
          if DownloadFile('http://www.amig.com.au/download/Updates/TC6NET/' + lHelpFile, lDestHFile) then
          begin
            for i := 1 to 10 do  // Simulate progress
              lFrmLoadProgress.UpdateProgress(6, AMG_WAIT_WHILE_UPDATING_MSG, 250);
            lFrmLoadProgress.UpdateProgress(10, AMG_RESTARTING_TIME_CHART, 800);
            Application.Terminate;
            ExecWait(AMG_UPDATER, ExtractFilePath(Application.ExeName), '', True);
            lFrmLoadProgress.UpdateProgress(10, AMG_RESTARTING_TIME_CHART, 800);
          end;
        end
        else
        begin
          lFrmLoadProgress.UpdateProgress(80, AMG_UPDATES_NOT_FOUND_MSG, 6000);
        end;
      end
      else
      begin
        lFrmLoadProgress.UpdateProgress(80, AMG_UPDATER_NOT_FOUND_MSG, 6000);
      end;

    finally
      FreeAndNil(lFrmLoadProgress);
    end;
  end;
end;

procedure TWebUpdateDlg.FormCreate(Sender: TObject);
begin
 try
  combobox1.Clear;
  combobox1.items.add('None');  combobox1.items.add('7 days');
  combobox1.items.add('14 days');combobox1.items.add('1 month');
  combobox1.items.add('2 months');
  combobox1.ItemIndex:=XML_DISPLAY.OnlineUpdateCheck;
  FCurrentlyOnline := FNIsInternetConnected;
 except
  FCurrentlyOnline := False;
 end;
end;

procedure TWebUpdateDlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 XML_DISPLAY.OnlineUpdateCheck:=combobox1.ItemIndex;
 action:=caFree;
end;

end.
