unit DIOTA.Pow.SpongeFactory;

interface

uses
  DIOTA.Pow.ICurl;

type
  TSpongeFactory = class abstract

  public
    type
      Mode = (CURLP81, CURLP27, KERL);
    class function Create(mode: Mode): ICurl;
  end;

implementation

uses
  DIOTA.Pow.JCurl,
  DIOTA.Pow.Kerl;

{ TSpongeFactory }

class function TSpongeFactory.Create(mode: Mode): ICurl;
begin
  case mode of
    CURLP81:
      Result := TJCurl.Create(mode);
    CURLP27:
      Result := TJCurl.Create(mode);
    KERL:
      Result := TKerl.Create
    else
      Result := nil;
  end;
end;

end.
