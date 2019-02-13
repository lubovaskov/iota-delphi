unit DIOTA.Dto.Request.GetTrytesRequest;

interface

uses
  System.Classes,
  REST.Client,
  System.JSON.Builders,
  DIOTA.IotaAPIClasses;

type
  TGetTrytesRequest = class(TIotaAPIRequest)
  private
    FHashes: TStrings;
  protected
    function GetCommand: String; override;
    function BuildRequestBody(JsonBuilder: TJSONCollectionBuilder.TPairs): TJSONCollectionBuilder.TPairs; override;
  public
    constructor Create(ARESTClient: TCustomRESTClient; AHashes: TStrings); reintroduce; virtual;
  end;

implementation

{ TGetTrytesRequest }

constructor TGetTrytesRequest.Create(ARESTClient: TCustomRESTClient; AHashes: TStrings);
begin
  inherited Create(ARESTClient);
  FHashes := AHashes;
end;

function TGetTrytesRequest.GetCommand: String;
begin
  Result := 'getTrytes';
end;

function TGetTrytesRequest.BuildRequestBody(JsonBuilder: TJSONCollectionBuilder.TPairs): TJSONCollectionBuilder.TPairs;
var
  AElements: TJSONCollectionBuilder.TElements;
  AHash: String;
begin
  if Assigned(FHashes) then
    begin
      AElements := JsonBuilder.BeginArray('hashes');
      for AHash in FHashes do
        AElements := AElements.Add(AHash);
      AElements.EndArray;
    end;

  Result := JsonBuilder;
end;

end.
