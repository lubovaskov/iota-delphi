unit DIOTA.Dto.Response.FindTransactionsResponse;

interface

uses
  System.Classes,
  DIOTA.IotaAPIClasses;

type
  TFindTransactionsResponse = class(TIotaAPIResponse)
  private
    FHashes: TArray<String>;
    function GetHashes(Index: Integer): String;
    function GetHashesCount: Integer;
  public
    constructor Create(AHashes: TArray<String>); reintroduce; virtual;
    function HashesList: TStringList;
    property HashesCount: Integer read GetHashesCount;
    property Hashes[Index: Integer]: String read GetHashes;
  end;

implementation

{ TFindTransactionsResponse }

constructor TFindTransactionsResponse.Create(AHashes: TArray<String>);
begin
  inherited Create;
  FHashes := AHashes;
end;

function TFindTransactionsResponse.GetHashes(Index: Integer): String;
begin
  Result := FHashes[Index];
end;

function TFindTransactionsResponse.GetHashesCount: Integer;
begin
  if Assigned(FHashes) then
    Result := Length(FHashes)
  else
    Result := 0;
end;

function TFindTransactionsResponse.HashesList: TStringList;
var
  AHash: String;
begin
  Result := TStringList.Create;
  for AHash in FHashes do
    Result.Add(AHash);
end;

end.
