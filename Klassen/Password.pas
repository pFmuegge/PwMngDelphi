unit Password;

interface

uses
  System.SysUtils,
  LbClass;

type
  TPassword = class(TObject)
  private
    FPassword: string;
    FCrypt: TLbBlowfish;
    function encrypt(APassword: string): string;
    function decrypt(APassword: string): string;
    procedure setPassword(ANewPassword: string);
  public
    property Password: string read FPassword write setPassword;
    function getPassword(ARevealed: boolean): string;
    constructor create(APassword: string; AIsEncrypted: boolean = false);
    destructor Destroy; override;
    procedure generateNewPassword(ALength: Integer; AWithSymbols: boolean);
  end;

implementation

{ TPassword }

constructor TPassword.create(APassword: string; AIsEncrypted: boolean);
begin
  if not Assigned(FCrypt) then
    FCrypt := TLbBlowfish.create(nil);
  FCrypt.Encoding := TEncoding.Ansi;
  FCrypt.CipherMode := cmCBC;

  if AIsEncrypted then
    FPassword := APassword
  else
    FPassword := encrypt(APassword);

end;

function TPassword.decrypt(APassword: string): string;
begin
  Result := FCrypt.DecryptString(APassword);
end;

destructor TPassword.Destroy;
begin
  FreeAndNil(FCrypt);
  inherited;
end;

function TPassword.encrypt(APassword: string): string;
begin
  Result := FCrypt.EncryptString(APassword);
end;

procedure TPassword.generateNewPassword(ALength: Integer;
  AWithSymbols: boolean);
const
  _CHARS_BIG = 'ABCDEFGHJIKLMNOPQRSTUVWXYZ';
  _CHARS_LIL = 'abcdefghijklmnopqrstuvwxyz';
  _CHARS_NUM = '0123456789';
  _CHARS_SYM = '.,-?!/[]{}§$%()=';
var
  chars: string;
  output: string;
begin
  Randomize;
  output := string.empty;

  chars := _CHARS_BIG + _CHARS_LIL + _CHARS_NUM;
  if AWithSymbols then
    chars := chars + _CHARS_SYM;

  while output.length < ALength do
  begin
    output := output + chars[Random(chars.length) + 1];
  end;

  FPassword := encrypt(output);
end;

function TPassword.getPassword(ARevealed: boolean): string;
begin
  if ARevealed then
    Result := decrypt(FPassword)
  else
    Result := FPassword;
end;

procedure TPassword.setPassword(ANewPassword: string);
begin
  FPassword := encrypt(ANewPassword);
end;

end.
