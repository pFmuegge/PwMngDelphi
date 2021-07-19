program PwMng;

uses
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  MainForm in 'MainForm.pas' {frmPwMng} ,
  Account in 'Klassen\Account.pas',
  Password in 'Klassen\Password.pas',
  Provider in 'Klassen\Provider.pas',
  DataMode in 'Klassen\DataMode.pas',
  FileHelper in 'Klassen\FileHelper.pas',
  PasswordSettings in 'Klassen\PasswordSettings.pas',
  Settings.Classes in 'Klassen\Settings.Classes.pas',
  SettingsForm in 'SettingsForm.pas' {frmSettings};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;

  // Config Stuff
  SettingsForm.Settings.WriteDefaultConfig(false);
  SettingsForm.Settings.ReadFromIni;

  // Set the Theme
  TStyleManager.TrySetStyle(SettingsForm.Settings.Theme);

  Application.CreateForm(TfrmPwMng, frmPwMng);
  Application.Run;

end.
