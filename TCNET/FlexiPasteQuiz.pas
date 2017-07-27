unit FlexiPasteQuiz;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TFlexiPasteQueryDlg = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    CancelPaste: TBitBtn;
    OkPaste: TBitBtn;
    Help: TBitBtn;
    Label3: TLabel;
    Edit1: TEdit;
    Label4: TLabel;
  end;

var
  FlexiPasteQueryDlg: TFlexiPasteQueryDlg;

implementation

{$R *.dfm}

end.
