unit DIOTA.Dto.Request.AddNeighborsRequest;

interface

uses
  System.Classes,
  REST.Client,
  System.JSON.Builders,
  DIOTA.IotaAPIClasses;

type
  TAddNeighborsRequest = class(TIotaAPIRequest)
  private
    FUris: TStrings;
  protected
    function GetCommand: String; override;
    function BuildRequestBody(JsonBuilder: TJSONCollectionBuilder.TPairs): TJSONCollectionBuilder.TPairs; override;
  public
    constructor Create(ARESTClient: TCustomRESTClient; AUris: TStrings); reintroduce; virtual;
  end;

implementation

{ TAddNeighborsRequest }

constructor TAddNeighborsRequest.Create(ARESTClient: TCustomRESTClient; AUris: TStrings);
begin
  inherited Create(ARESTClient);
  FUris := AUris;
end;

function TAddNeighborsRequest.GetCommand: String;
begin
  Result := 'addNeighbors';
end;

function TAddNeighborsRequest.BuildRequestBody(JsonBuilder: TJSONCollectionBuilder.TPairs): TJSONCollectionBuilder.TPairs;
var
  AElements: TJSONCollectionBuilder.TElements;
  AUri: String;
begin
  AElements := JsonBuilder.BeginArray('uris');

  for AUri in FUris do
    AElements := AElements.Add(AUri);

  AElements.EndArray;

  Result := JsonBuilder;
end;

end.
