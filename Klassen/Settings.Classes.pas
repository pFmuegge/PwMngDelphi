unit Settings.Classes;

interface

uses
  FileHelper,
  PasswordSettings,
  System.SysUtils,
  System.iniFiles;

type
  TSettings = record
  private
    function GetPath: string;
  public
    Password: TPasswordSettings;
    Theme: string;

    procedure WriteDefaultConfig(AForceWrite: Boolean);
    procedure WriteIni;
    procedure ReadFromIni;
  end;

const
  _INI_FILENAME = 'settings.ini';

implementation

{ TSettings }

function TSettings.GetPath: string;
begin
  Exit(TFileHelper.GetPath + _INI_FILENAME);
end;

procedure TSettings.ReadFromIni;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(GetPath);
  try
    Password.Length := IniFile.ReadInteger('Passwords', 'Length', 16);
    Password.IncludeSymbols := IniFile.ReadBool('Passwords',
      'IncludeSymbols', False);
    Theme := IniFile.ReadString('General', 'Theme', 'Windows');
  finally
    FreeAndNil(IniFile);
  end;
end;

procedure TSettings.WriteDefaultConfig(AForceWrite: Boolean);
var
  IniFile: TIniFile;
begin
  if FileExists(GetPath) and not AForceWrite then
    Exit;

  IniFile := TIniFile.Create(GetPath);
  try
    IniFile.WriteInteger('Passwords', 'Length', 16);
    IniFile.WriteBool('Passwords', 'IncludeSymbols', False);
    IniFile.WriteString('General', 'Theme', 'Windows');

    IniFile.UpdateFile;
  finally
    FreeAndNil(IniFile);
  end;

end;

procedure TSettings.WriteIni;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(GetPath);
  try
    IniFile.WriteString('General', 'Theme', Theme);
    IniFile.WriteInteger('Passwords', 'Length', Password.Length);
    IniFile.WriteBool('Passwords', 'IncludeSymbols', Password.IncludeSymbols);

    IniFile.UpdateFile;
  finally
    FreeAndNil(IniFile);
  end;
end;

end.
