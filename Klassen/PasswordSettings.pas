unit PasswordSettings;

interface

type
  TPasswordSettings = record
    Length: Integer;
    IncludeSymbols: Boolean;
    class function GetWithDefault: TPasswordSettings; static;
  end;

implementation

{ TPasswordSettings }

class function TPasswordSettings.GetWithDefault: TPasswordSettings;
begin
  result.Length := 16;
  result.IncludeSymbols := false;
end;

end.
