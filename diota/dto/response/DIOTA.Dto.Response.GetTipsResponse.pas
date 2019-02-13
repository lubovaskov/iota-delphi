unit DIOTA.Dto.Response.GetTipsResponse;

interface

uses
  DIOTA.IotaAPIClasses;

type
  TGetTipsResponse = class(TIotaAPIResponse)
  private
    FHashes: TArray<String>;
    function GetHashes(Index: Integer): String;
    function GetHashesCount: Integer;
  public
    constructor Create(AHashes: TArray<String>); reintroduce; virtual;
    property HashesCount: Integer read GetHashesCount;
    property Hashes[Index: Integer]: String read GetHashes;
  end;

implementation

{ TGetTipsResponse }

constructor TGetTipsResponse.Create(AHashes: TArray<String>);
begin
  inherited Create;
  FHashes := AHashes;
end;

function TGetTipsResponse.GetHashes(Index: Integer): String;
begin
  Result := FHashes[Index];
end;

function TGetTipsResponse.GetHashesCount: Integer;
begin
  Result := Length(FHashes);
end;

end.
