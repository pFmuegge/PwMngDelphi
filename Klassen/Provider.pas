unit Provider;

interface

type
  TProvider = class(Tobject)
  private
    FName: string;
    FWebSite: string;
  public
    property Name: string read FName write FName;
    property Link: string read FWebSite write FWebSite;
    constructor create(AName, ALink: string);
  end;

implementation

{ TProvider }

constructor TProvider.create(AName, ALink: string);
begin
  FName := AName;
  FWebSite := ALink;
end;

end.
