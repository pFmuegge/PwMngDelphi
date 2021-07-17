unit FileHelper;

interface

uses
  System.Generics.Collections,
  Account,
  System.Classes,
  System.SysUtils,
  System.IOUtils;

type
  TFileHelper = class
  private const
{$IFDEF DEBUG}
    _FILENAME = 'debug.lst';
{$ELSE}
    _FILENAME = 'data.lst';
{$ENDIF}
    _FORMAT = '%0:s;%1:s;%2:s;%3:s;%4:s';

  public
    class function GetPath: string;
    class procedure ReadAccounts(var AAccountList: TObjectList<TAccount>);
    class procedure WriteAccounts(var AAccountList: TObjectList<TAccount>);
  end;

implementation

{ TFileHelper }

class function TFileHelper.GetPath: string;
begin
  result := TPath.GetHomePath + '\PwMng\';
end;

class procedure TFileHelper.ReadAccounts(var AAccountList
  : TObjectList<TAccount>);
var
  lines: TStringList;
  line: string;
  linesplit: TArray<string>;
  newAccount: TAccount;
  path: string;
begin
  path := GetPath;
  if not FileExists(path + _FILENAME) then
  begin
    Exit;
  end;
  try
    lines := TStringList.Create;
    try
      lines.LoadFromFile(path + _FILENAME);

      AAccountList.Clear;
      for line in lines do
      begin
        linesplit := line.split([';']);
        newAccount := TAccount.CreateFromLoad(linesplit[2], linesplit[3],
          linesplit[4], linesplit[0], linesplit[1]);
        AAccountList.Add(newAccount);
      end;
    finally
      FreeAndNil(lines);
    end;
  except
    on E: Exception do
      raise Exception.Create
        ('Beim Laden der Account-Daten ist ein Fehler aufgetreten: ' +
        E.Message);
  end;
end;

class procedure TFileHelper.WriteAccounts(var AAccountList
  : TObjectList<TAccount>);
var
  Account: TAccount;
  lines: TStringList;
  path: string;
begin
  path := GetPath;
  lines := TStringList.Create;
  try
    for Account in AAccountList do
    begin
      lines.Add(Account.toString);
    end;

    if not DirectoryExists(path) then
      ForceDirectories(path);

    lines.SaveToFile(path + _FILENAME);
  finally
    FreeAndNil(lines);
  end;
end;

end.
