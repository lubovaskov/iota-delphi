unit DIOTA.IotaAPIClasses;

interface

uses
  REST.Client,
  System.JSON.Builders;

type
  TIotaAPIResponse = class
  public
    constructor Create; virtual;
  end;

  TIotaAPIRequest = class
  private
    FRequest: TRESTRequest;
    FResponse: TRESTResponse;
  protected
    function GetCommand: String; virtual; abstract;
    function BuildRequestBody(JsonBuilder: TJSONCollectionBuilder.TPairs): TJSONCollectionBuilder.TPairs; virtual;
  public
    constructor Create(ARESTClient: TCustomRESTClient); virtual;
    destructor Destroy; override;
    function Execute<TResult: TIotaAPIResponse, constructor>: TResult;
  end;

implementation

uses
  REST.Types,
  REST.Json.Types,
  REST.Json;

{ TIotaAPIRequest }

constructor TIotaAPIRequest.Create(ARESTClient: TCustomRESTClient);
begin
  FRequest := TRESTRequest.Create(nil);
  FRequest.SynchronizedEvents:= False;
  FRequest.Timeout := 5000;
  FRequest.Method := rmPOST;
  FRequest.Params.AddHeader('X-IOTA-API-Version', '1.4.1');
  FRequest.Params.AddHeader('Content-Type', 'application/json');
  FRequest.Params.AddHeader('User-Agent', 'DIOTA-API wrapper');
  FRequest.Client := ARESTClient;

  FResponse:= TRESTResponse.Create(nil);
  FRequest.Response := FResponse;
end;

destructor TIotaAPIRequest.Destroy;
begin
  FResponse.Free;
  FRequest.Free;
  inherited;
end;

function TIotaAPIRequest.Execute<TResult>: TResult;
var
  JsonBuilder: TJSONObjectBuilder;
begin
  JsonBuilder := TJSONObjectBuilder.Create(FRequest.Body.JSONWriter);
  try
    BuildRequestBody(JsonBuilder.BeginObject.Add('command', GetCommand)).EndObject;
  finally
    JsonBuilder.Free;
  end;

  FRequest.Execute;

  if Assigned(FResponse.JSONValue) then
    Result := TJson.JsonToObject<TResult>(FResponse.JSONValue.ToJSON)
  else
    Result := nil;
end;

function TIotaAPIRequest.BuildRequestBody(JsonBuilder: TJSONCollectionBuilder.TPairs): TJSONCollectionBuilder.TPairs;
begin
  Result := JsonBuilder;
end;

{ TIotaAPIResponse }

constructor TIotaAPIResponse.Create;
begin
  //
end;

end.
