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
  System.IOUtils,
  Vcl.Clipbrd,
  PasswordSettings,
  SettingsForm,
  Vcl.ComCtrls,
  Vcl.ToolWin;

type
  TfrmPwMng = class(TForm)
    mmMain: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    N2: TMenuItem;
    lstAccounts: TListBox;
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
    Einstellungen1: TMenuItem;
    tray: TTrayIcon;
    pmTray: TPopupMenu;
    Showme1: TMenuItem;
    Beenden1: TMenuItem;
    tlb1: TToolBar;
    btnNew: TToolButton;
    btnEdit: TToolButton;
    btnSave: TToolButton;
    btnCancel: TToolButton;
    btnDelete: TToolButton;
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
    procedure btnGeneratePasswordClick(Sender: TObject);
    procedure Einstellungen1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure trayDblClick(Sender: TObject);
    procedure Showme1Click(Sender: TObject);
    procedure Beenden1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FWillGeneratePassword: Boolean;
    FPrevWindowState: TWindowState;
    FEditMode: TDataMode;
    FListWasEdited: Boolean;
    FAccounts: TObjectList<TAccount>;
    FCurrentAccount: TAccount;
    procedure AlterAccount;
    procedure DeleteAccount;
    procedure ToggleControls;
    procedure LoadEditsFromAccount;
    procedure UpdateList;
    procedure ClearEdits;
  end;

var
  frmPwMng: TfrmPwMng;

implementation

{$R *.dfm}

procedure TfrmPwMng.Einstellungen1Click(Sender: TObject);
begin
  TfrmSettings.Run;
end;

procedure TfrmPwMng.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmPwMng.PfadzurSicherungffnen1Click(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open', 'explorer.exe',
    PChar(TFileHelper.GetPath), nil, SW_NORMAL);
end;

procedure TfrmPwMng.Showme1Click(Sender: TObject);
begin
  show;
  WindowState := wsNormal;
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

procedure TfrmPwMng.trayDblClick(Sender: TObject);
begin
  Showme1.Click;
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
    ('Liste speichern? Ungespeicherte ?nderungen gehen sonst verloren',
    mtConfirmation, mbYesNo, 0, mbYes) = mrYes) then
  begin
    TFileHelper.WriteAccounts(FAccounts);
  end;
end;

procedure TfrmPwMng.FormCreate(Sender: TObject);
begin
  FWillGeneratePassword := False;

  FAccounts := TObjectList<TAccount>.Create(true);
  FEditMode := dmBrowse;

  TFileHelper.ReadAccounts(FAccounts);
  UpdateList;
end;

procedure TfrmPwMng.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FAccounts);
end;

procedure TfrmPwMng.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift = [ssCtrl]) and (Key = vkAdd) then // New
  begin
    if btnNew.Enabled then
      btnNew.Click;
  end
  else if (Key = vkF2) then // Edit
  begin
    if btnEdit.Enabled then
      btnEdit.Click;
  end
  else if (Shift = [ssCtrl]) and (Key = vkS) then // save
  begin
    if btnSave.Enabled then
      btnSave.Click;
  end
  else if (Shift = [ssCtrl]) and (Key = vkZ) then // Cancel
  begin
    if btnCancel.Enabled then
      btnCancel.Click;
  end
  else if (Shift = [ssCtrl]) and (Key = vkDelete) then // Delete
  begin
    if btnDelete.Enabled then
      btnDelete.Click
  end;
end;

procedure TfrmPwMng.FormResize(Sender: TObject);
var
  StateChange: Boolean;
begin

  // did the WindowState actually change?
  StateChange := FPrevWindowState <> WindowState;
  if StateChange and (WindowState = wsMinimized) then
  begin
    hide;
    tray.Visible := true;
  end
  else if StateChange and (WindowState in [wsNormal, wsMaximized]) then
  begin
    show;
    tray.Visible := False;
  end;

  if tray.Visible then
    tray.ShowBalloonHint;

  // Set the new WindowsState so it can be used in the next call of this event
  FPrevWindowState := WindowState;
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

procedure TfrmPwMng.Beenden1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmPwMng.btnCancelClick(Sender: TObject);
begin
  if FEditMode = dmInsert then
  begin
    FCurrentAccount := FAccounts[FAccounts.Count - 1];
    lstAccounts.ItemIndex := FAccounts.Count - 1;
  end;

  FEditMode := dmBrowse;
  ToggleControls;
  chkShowPassword.Enabled := true;
  chkShowPassword.Checked := False;
  edPassword.Text := FCurrentAccount.Password.getPassword(False);
  LoadEditsFromAccount;
end;

procedure TfrmPwMng.btnCopyPasswordClick(Sender: TObject);
begin
  if FAccounts.Count > 0 then
    Clipboard.AsText := FCurrentAccount.getPassword(true);
end;

procedure TfrmPwMng.btnDeleteClick(Sender: TObject);
begin
  if MessageDlg('Datensatz wirklich l?schen?', mtWarning, mbYesNo, 0, mbNo) = mrYes
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
  edPassword.Text := FCurrentAccount.Password.getPassword(true);
  chkShowPassword.Checked := true;
  chkShowPassword.Enabled := False;
end;

procedure TfrmPwMng.btnGeneratePasswordClick(Sender: TObject);
var
  rps: TPasswordSettings;
begin
  rps := Settings.Password;
  if FEditMode in _EditModes then
  begin
    FCurrentAccount.Password.generateNewPassword(rps);
    edPassword.Text := FCurrentAccount.getPassword(true);
  end;

end;

procedure TfrmPwMng.btnNewClick(Sender: TObject);
begin
  // init
  FEditMode := dmInsert;
  ToggleControls;
  ClearEdits;

  // create a new account as the current account
  FCurrentAccount := TAccount.Create('', '', '', '', '');

  lstAccounts.Items.Add(FCurrentAccount.Provider.Name);
  FListWasEdited := true;
end;

procedure TfrmPwMng.btnSaveClick(Sender: TObject);
begin
  AlterAccount;

  if FEditMode = dmInsert then
  begin
    // add the account to the list
    FAccounts.Add(FCurrentAccount);
    // update the listbox
    UpdateList;

    // CurrentAccount changes while updating the list because of the selected index
    FCurrentAccount := FAccounts.Last;

    // fill the edits with the data (updatelist overwrites it)
    LoadEditsFromAccount;
  end;

  // select the current account in the listbox
  lstAccounts.ItemIndex := FAccounts.IndexOf(FCurrentAccount);

  FEditMode := dmBrowse;
  chkShowPassword.Enabled := true;
  chkShowPassword.Checked := False;
  edPassword.Text := FCurrentAccount.Password.getPassword(False);
  ToggleControls;
end;

procedure TfrmPwMng.chkShowPasswordClick(Sender: TObject);
begin
  if FAccounts.Count > 0 then
  begin
    edPassword.Text := FCurrentAccount.getPassword(chkShowPassword.Checked);
  end;
end;

procedure TfrmPwMng.ClearEdits;
begin
  edProviderName.Text := string.empty;
  edURL.Text := string.empty;
  edMail.Text := string.empty;
  edUsername.Text := string.empty;
  edPassword.Text := string.empty;
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
