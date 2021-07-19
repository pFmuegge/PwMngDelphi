unit SettingsForm;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Settings.Classes,
  System.UITypes;

type
  TfrmSettings = class(TForm)
    cmbThemes: TComboBox;
    lblTheme: TLabel;
    btnOk: TButton;
    chkSym: TCheckBox;
    edtLength: TEdit;
    lblLength: TLabel;
    lblSym: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    class procedure Run;
  end;

var
  frmSettings: TfrmSettings;
  Settings: TSettings;

implementation

{$R *.dfm}

procedure TfrmSettings.btnOkClick(Sender: TObject);
begin
  if Settings.Theme <> cmbThemes.Items[cmbThemes.ItemIndex] then
    MessageDlg('Themes sind erst nach einem Neustart verändert!', mtInformation,
      [mbOk], 0, mbOk);

  Settings.Theme := cmbThemes.Items[cmbThemes.ItemIndex];
  Settings.Password.Length := StrToInt(edtLength.Text);
  Settings.Password.IncludeSymbols := chkSym.Checked;

  Settings.WriteIni;
  Close;
end;

procedure TfrmSettings.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := CAFree;
  frmSettings := nil;
end;

procedure TfrmSettings.FormCreate(Sender: TObject);
begin
  cmbThemes.ItemIndex := cmbThemes.Items.IndexOf(Settings.Theme);
  edtLength.Text := Settings.Password.Length.ToString;
  chkSym.Checked := Settings.Password.IncludeSymbols;
end;

class procedure TfrmSettings.Run;
begin
  if not Assigned(frmSettings) then
  begin
    frmSettings := TfrmSettings.Create(nil);
    frmSettings.ShowModal;
  end
  else
    frmSettings.BringToFront;
end;

end.
