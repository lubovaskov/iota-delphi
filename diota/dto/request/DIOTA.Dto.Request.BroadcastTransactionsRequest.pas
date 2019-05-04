unit DIOTA.Dto.Request.BroadcastTransactionsRequest;

interface

uses
  System.Classes,
  REST.Client,
  System.JSON.Builders,
  DIOTA.IotaAPIClasses;

type
  TBroadcastTransactionsRequest = class(TIotaAPIRequest)
  private
    FTrytes: TStrings;
  protected
    function GetCommand: String; override;
    function BuildRequestBody(JsonBuilder: TJSONCollectionBuilder.TPairs): TJSONCollectionBuilder.TPairs; override;
  public
    constructor Create(ARESTClient: TCustomRESTClient; ATimeout: Integer; ATrytes: TStrings); reintroduce; virtual;
  end;

implementation

{ TBroadcastTransactionsRequest }

constructor TBroadcastTransactionsRequest.Create(ARESTClient: TCustomRESTClient; ATimeout: Integer; ATrytes: TStrings);
begin
  inherited Create(ARESTClient, ATimeout);
  FTrytes := ATrytes;
end;

function TBroadcastTransactionsRequest.GetCommand: String;
begin
  Result := 'broadcastTransactions';
end;

function TBroadcastTransactionsRequest.BuildRequestBody(JsonBuilder: TJSONCollectionBuilder.TPairs): TJSONCollectionBuilder.TPairs;
var
  AElements: TJSONCollectionBuilder.TElements;
  ATryte: String;
begin
  if Assigned(FTrytes) then
    begin
      AElements := JsonBuilder.BeginArray('trytes');
      for ATryte in FTrytes do
        AElements := AElements.Add(ATryte);
      AElements.EndArray;
    end;

  Result := JsonBuilder;
end;

end.
