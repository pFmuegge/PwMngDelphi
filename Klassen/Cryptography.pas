unit Cryptography;

interface

uses
  System.Classes, System.SysUtils;

type
  TCrypter = class
  private
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    function encrypt(AText: string): string;
    function decrypt(AText: string): string;
  end;

implementation

{ TCrypter }

{ TCrypter }

constructor TCrypter.Create(AOwner: TComponent);
begin

end;

function TCrypter.decrypt(AText: string): string;
begin
end;

destructor TCrypter.Destroy;
begin
  inherited;
end;

function TCrypter.encrypt(AText: string): string;
begin
end;

end.
