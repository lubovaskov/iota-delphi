unit DIOTA.Dto.Request.RemoveNeighborsRequest;

interface

uses
  System.Classes,
  REST.Client,
  System.JSON.Builders,
  DIOTA.IotaAPIClasses;

type
  TRemoveNeighborsRequest = class(TIotaAPIRequest)
  private
    FUris: TStrings;
  protected
    function GetCommand: String; override;
    function BuildRequestBody(JsonBuilder: TJSONCollectionBuilder.TPairs): TJSONCollectionBuilder.TPairs; override;
  public
    constructor Create(ARESTClient: TCustomRESTClient; ATimeout: Integer; AUris: TStrings); reintroduce; virtual;
  end;

implementation

{ TRemoveNeighborsRequest }

constructor TRemoveNeighborsRequest.Create(ARESTClient: TCustomRESTClient; ATimeout: Integer; AUris: TStrings);
begin
  inherited Create(ARESTClient, ATimeout);
  FUris := AUris;
end;

function TRemoveNeighborsRequest.GetCommand: String;
begin
  Result := 'removeNeighbors';
end;

function TRemoveNeighborsRequest.BuildRequestBody(JsonBuilder: TJSONCollectionBuilder.TPairs): TJSONCollectionBuilder.TPairs;
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
