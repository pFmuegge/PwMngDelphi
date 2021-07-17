unit MainForm;

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
  Vcl.ExtCtrls,
  Vcl.Menus,
  System.Generics.Collections,
  Account,
  System.UITypes,
  DataMode,
  FileHelper,
  Winapi.ShellAPI,
  System.IOUtils, Vcl.Clipbrd;

type
  TfrmPwMng = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    N2: TMenuItem;
    lstAccounts: TListBox;
    btnNew: TButton;
    btnEdit: TButton;
    btnCancel: TButton;
    btnSave: TButton;
    btnDelete: TButton;
    Panel1: TPanel;
    Panel2: TPanel;
    edProviderName: TLabeledEdit;
    edURL: TLabeledEdit;
    edUsername: TLabeledEdit;
    edMail: TLabeledEdit;
    edPassword: TLabeledEdit;
    chkShowPassword: TCheckBox;
    btnGeneratePassword: TButton;
    PfadzurSicherungffnen1: TMenuItem;
    btnCopyPassword: TButton;
    procedure Exit1Click(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure lstAccountsClick(Sender: TObject);
    procedure PfadzurSicherungffnen1Click(Sender: TObject);
    procedure chkShowPasswordClick(Sender: TObject);
    procedure btnCopyPasswordClick(Sender: TObject);
  private
    FEditMode: TDataMode;
    FListWasEdited: Boolean;
    FAccounts: TObjectList<TAccount>;
    FCurrentAccount: TAccount;
    procedure NewAccount;
    procedure AlterAccount;
    procedure DeleteAccount;
    procedure ToggleControls;
    procedure LoadEditsFromAccount;
    procedure UpdateList;
  end;

var
  frmPwMng: TfrmPwMng;

implementation

{$R *.dfm}

procedure TfrmPwMng.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmPwMng.NewAccount;
var
  lAccount: TAccount;
begin
  lAccount := TAccount.Create(edUsername.Text, edMail.Text, edPassword.Text,
    edProviderName.Text, edURL.Text);
  FCurrentAccount := lAccount;
  FAccounts.Add(lAccount);
  lstAccounts.Items.Add(lAccount.Provider.Name);
  FListWasEdited := true;
end;

procedure TfrmPwMng.PfadzurSicherungffnen1Click(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open', 'explorer.exe',
    PChar(TPath.GetHomePath + '\PwMng\'), nil, SW_NORMAL);
end;

procedure TfrmPwMng.ToggleControls;
var
  lIsEditMode: Boolean;
  lHasData: Boolean;
begin
  lHasData := FAccounts.Count > 0;
  lIsEditMode := FEditMode in _EditModes;

  btnNew.Enabled := not lIsEditMode;
  btnEdit.Enabled := not lIsEditMode and lHasData;
  btnDelete.Enabled := not lIsEditMode and lHasData;
  btnSave.Enabled := lIsEditMode;
  btnCancel.Enabled := lIsEditMode;
  btnGeneratePassword.Enabled := lIsEditMode;

  edUsername.Enabled := lIsEditMode;
  edMail.Enabled := lIsEditMode;
  edProviderName.Enabled := lIsEditMode;
  edURL.Enabled := lIsEditMode;
  edPassword.Enabled := lIsEditMode;
  lstAccounts.Enabled := not lIsEditMode;
end;

procedure TfrmPwMng.UpdateList;
var
  i: Integer;
  oldIndex: Integer;
begin
  if lstAccounts.Items.Count > 0 then
    oldIndex := lstAccounts.ItemIndex
  else
    oldIndex := -1;

  lstAccounts.Clear;
  if FAccounts.Count = 0 then
    exit;
  for i := 0 to FAccounts.Count - 1 do
  begin
    lstAccounts.Items.Add(FAccounts[i].Provider.Name);
  end;

  if oldIndex > -1 then
  begin
    while oldIndex > lstAccounts.Count - 1 do
      Dec(oldIndex);

    lstAccounts.ItemIndex := oldIndex;
  end
  else
    lstAccounts.ItemIndex := 0;

  FCurrentAccount := FAccounts[lstAccounts.ItemIndex];
  LoadEditsFromAccount;
  ToggleControls;
end;

// -----------------------------------------------------------------------------------
{$REGION 'FORM_EVENTS'}

procedure TfrmPwMng.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if FEditMode <> dmBrowse then
  begin
    MessageDlg('Daten befinden sich noch im Editmode!', mtError, [mbOk], 0);
    CanClose := False;
  end;

  if FListWasEdited and (FAccounts.Count > 0) and
    (MessageDlg
    ('Liste speichern? Ungespeicherte Änderungen gehen sonst verloren',
    mtConfirmation, mbYesNo, 0, mbYes) = mrYes) then
  begin
    TFileHelper.WriteAccounts(FAccounts);
  end;
end;

procedure TfrmPwMng.FormCreate(Sender: TObject);
begin
  FAccounts := TObjectList<TAccount>.Create(true);
  FEditMode := dmBrowse;

  TFileHelper.ReadAccounts(FAccounts);
  UpdateList;
end;

procedure TfrmPwMng.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FAccounts);
end;

procedure TfrmPwMng.LoadEditsFromAccount;
begin
  if FAccounts.Count > 0 then
  begin
    edUsername.Text := FCurrentAccount.Username;
    edMail.Text := FCurrentAccount.Mail;
    edProviderName.Text := FCurrentAccount.Provider.Name;
    edURL.Text := FCurrentAccount.Provider.Link;
    edPassword.Text := FCurrentAccount.getPassword(chkShowPassword.Checked);
  end
  else
  begin
    edUsername.Text := string.empty;
    edMail.Text := string.empty;
    edProviderName.Text := string.empty;
    edURL.Text := string.empty;
    edPassword.Text := string.empty;
  end;
end;

procedure TfrmPwMng.lstAccountsClick(Sender: TObject);
begin
  if FAccounts.Count > 0 then
  begin
    if FCurrentAccount <> FAccounts.Items[lstAccounts.ItemIndex] then
    begin
      FCurrentAccount := FAccounts.Items[lstAccounts.ItemIndex];
      LoadEditsFromAccount;
    end;
  end;
end;

{$ENDREGION}
// -----------------------------------------------------------------------------------
{$REGION 'BUTTON_EVENTS'}

procedure TfrmPwMng.AlterAccount;
begin
  FCurrentAccount.Username := edUsername.Text;
  FCurrentAccount.Mail := edMail.Text;
  FCurrentAccount.Provider.Name := edProviderName.Text;
  FCurrentAccount.Provider.Link := edPassword.Text;

  if edPassword.Text <> FCurrentAccount.getPassword(true) then
    FCurrentAccount.setPassword(edPassword.Text);
  FListWasEdited := true;
end;

procedure TfrmPwMng.btnCancelClick(Sender: TObject);
begin
  FEditMode := dmBrowse;
  ToggleControls;
  LoadEditsFromAccount;
end;

procedure TfrmPwMng.btnCopyPasswordClick(Sender: TObject);
begin
  if FAccounts.Count > 0 then  
  Clipboard.AsText := FCurrentAccount.getPassword(true);
end;

procedure TfrmPwMng.btnDeleteClick(Sender: TObject);
begin
  if MessageDlg('Datensatz wirklich löschen?', mtWarning, mbYesNo, 0, mbNo) = mrYes
  then
  begin
    DeleteAccount;
    FEditMode := dmBrowse;
    LoadEditsFromAccount;
    ToggleControls;
  end;
end;

procedure TfrmPwMng.btnEditClick(Sender: TObject);
begin
  FEditMode := dmEdit;
  ToggleControls;
end;

procedure TfrmPwMng.btnNewClick(Sender: TObject);
begin
  FEditMode := dmInsert;
  ToggleControls;
end;

procedure TfrmPwMng.btnSaveClick(Sender: TObject);
begin
  if FEditMode = dmInsert then
    NewAccount
  else if FEditMode = dmEdit then
    AlterAccount
  else
    System.SysUtils.Abort;
  lstAccounts.ItemIndex := FAccounts.IndexOf(FCurrentAccount);
  FEditMode := dmBrowse;
  ToggleControls;
end;

procedure TfrmPwMng.chkShowPasswordClick(Sender: TObject);
begin
  if FAccounts.Count > 0 then
  begin
    edPassword.Text := FCurrentAccount.getPassword(chkShowPassword.Checked);
  end;
end;

procedure TfrmPwMng.DeleteAccount;
var
  index: Integer;
begin
  index := FAccounts.IndexOf(FCurrentAccount);
  lstAccounts.Items.Delete(index);
  FAccounts.Remove(FCurrentAccount);

  TFileHelper.WriteAccounts(FAccounts);

  if index >= FAccounts.Count then
    index := FAccounts.Count - 1;

  if index >= 0 then
  begin
    FCurrentAccount := FAccounts[index];
    lstAccounts.ItemIndex := index;
  end;
end;
{$ENDREGION}

initialization

{$IFDEF DEBUG}
  System.ReportMemoryLeaksOnShutdown := true;
{$ENDIF}

end.
