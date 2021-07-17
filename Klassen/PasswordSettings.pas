unit PasswordSettings;

interface

type
  TPasswordSettings = record
    Length: Integer = 16;
    IncludeSymbols: Boolean = false;
    class function GetWithDefault: TPasswordSettings;
  end;

implementation

{ TPasswordSettings }

class function TPasswordSettings.GetWithDefault: TPasswordSettings;
begin
  result.Length := 16;
  result.IncludeSymbols := false;
end;

end.
