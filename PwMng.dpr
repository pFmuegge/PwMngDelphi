program PwMng;

uses
  Vcl.Forms,
  MainForm in 'MainForm.pas' {frmPwMng},
  Account in 'Klassen\Account.pas',
  Password in 'Klassen\Password.pas',
  Provider in 'Klassen\Provider.pas',
  DataMode in 'Klassen\DataMode.pas',
  Vcl.Themes,
  Vcl.Styles,
  FileHelper in 'Klassen\FileHelper.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10 SlateGray');
  Application.CreateForm(TfrmPwMng, frmPwMng);
  Application.Run;
end.
