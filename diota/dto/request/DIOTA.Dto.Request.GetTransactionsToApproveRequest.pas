unit DIOTA.Dto.Request.GetTransactionsToApproveRequest;

interface

uses
  System.Classes,
  REST.Client,
  System.JSON.Builders,
  DIOTA.IotaAPIClasses;

type
  TGetTransactionsToApproveRequest = class(TIotaAPIRequest)
  private
    FDepth: Integer;
    FReference: String;
  protected
    function GetCommand: String; override;
    function BuildRequestBody(JsonBuilder: TJSONCollectionBuilder.TPairs): TJSONCollectionBuilder.TPairs; override;
  public
    constructor Create(ARESTClient: TCustomRESTClient; ATimeout: Integer; ADepth: Integer; AReference: String); reintroduce; virtual;
  end;

implementation

{ TGetTransactionsToApproveRequest }

constructor TGetTransactionsToApproveRequest.Create(ARESTClient: TCustomRESTClient; ATimeout: Integer; ADepth: Integer; AReference: String);
begin
  inherited Create(ARESTClient, ATimeout);
  FDepth := ADepth;
  FReference := AReference;
end;

function TGetTransactionsToApproveRequest.GetCommand: String;
begin
  Result := 'getTransactionsToApprove';
end;

function TGetTransactionsToApproveRequest.BuildRequestBody(JsonBuilder: TJSONCollectionBuilder.TPairs): TJSONCollectionBuilder.TPairs;
begin
  Result := JsonBuilder.Add('depth', FDepth);
  if FReference <> '' then
    Result.Add('reference', FReference);
end;

end.
