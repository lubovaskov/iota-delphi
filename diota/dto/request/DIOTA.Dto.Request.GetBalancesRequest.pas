unit DIOTA.Dto.Request.GetBalancesRequest;

interface

uses
  REST.Client,
  System.JSON.Builders,
  DIOTA.IotaAPIClasses;

type
  TGetBalancesRequest = class(TIotaAPIRequest)
  private
    FThreshold: Integer;
    FAddresses: TArray<String>;
    FTips: TArray<String>;
  protected
    function GetCommand: String; override;
    function BuildRequestBody(JsonBuilder: TJSONCollectionBuilder.TPairs): TJSONCollectionBuilder.TPairs; override;
  public
    constructor Create(ARESTClient: TCustomRESTClient; ATimeout: Integer; AThreshold: Integer; AAddresses, ATips: TArray<String>); reintroduce; virtual;
  end;

implementation

{ TGetBalancesRequest }

constructor TGetBalancesRequest.Create(ARESTClient: TCustomRESTClient; ATimeout: Integer; AThreshold: Integer; AAddresses, ATips: TArray<String>);
begin
  inherited Create(ARESTClient, ATimeout);
  FThreshold := AThreshold;
  FAddresses := AAddresses;
  FTips := ATips;
end;

function TGetBalancesRequest.GetCommand: String;
begin
  Result := 'getBalances';
end;

function TGetBalancesRequest.BuildRequestBody(JsonBuilder: TJSONCollectionBuilder.TPairs): TJSONCollectionBuilder.TPairs;
var
  AElements: TJSONCollectionBuilder.TElements;
  AAddress: String;
begin
  AElements := JsonBuilder.BeginArray('addresses');

  for AAddress in FAddresses do
    AElements := AElements.Add(AAddress);

  Result := AElements
    .EndArray
    .Add('threshold', FThreshold);
end;

end.
