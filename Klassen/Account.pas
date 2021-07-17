unit Account;

interface

uses
  System.SysUtils,
  Password,
  Provider;

type
  TAccount = class
  private
    FPassword: TPassword;
    FMail: string;
    FUsername: string;
    FProvider: TProvider;
  public
    Property Mail: string read FMail write FMail;
    property Username: string read FUsername write FUsername;
    property Provider: TProvider read FProvider write FProvider;
    property Password: TPassword read FPassword;

    function toString: string; reintroduce;

    function getPassword(ARevealed: boolean): string;
    procedure setPassword(ANewPassword: string);

    constructor create(AUsername, AMail, APassword, AProviderName,
      AProviderLink: string);
    constructor createFromLoad(AUsername, AMail, APassword, AProviderName,
      AProviderLink: string);

    destructor Destroy; override;
  end;

implementation

{ TAccount }

constructor TAccount.create(AUsername, AMail, APassword, AProviderName,
  AProviderLink: string);
begin
  FUsername := AUsername;
  FMail := AMail;
  FProvider := TProvider.create(AProviderName, AProviderLink);
  FPassword := TPassword.create(APassword);
end;

constructor TAccount.createFromLoad(AUsername, AMail, APassword, AProviderName,
  AProviderLink: string);
begin
  FUsername := AUsername;
  FMail := AMail;
  FProvider := TProvider.create(AProviderName, AProviderLink);
  FPassword := TPassword.create(APassword, true);
end;

destructor TAccount.Destroy;
begin
  FreeAndNil(FPassword);
  FreeAndNil(FProvider);
  inherited;
end;

function TAccount.getPassword(ARevealed: boolean): string;
begin
  result := FPassword.getPassword(ARevealed);
end;

procedure TAccount.setPassword(ANewPassword: string);
begin
  FPassword.Password := ANewPassword;
end;

function TAccount.toString: string;
begin
  result := FProvider.Name;
  result := result + ';' + FProvider.Link;
  result := result + ';' + FUsername;
  result := result + ';' + FMail;
  result := result + ';' + FPassword.Password;
end;

end.
