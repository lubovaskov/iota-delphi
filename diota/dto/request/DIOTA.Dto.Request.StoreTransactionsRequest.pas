unit DIOTA.Dto.Request.StoreTransactionsRequest;

interface

uses
  System.Classes,
  REST.Client,
  System.JSON.Builders,
  DIOTA.IotaAPIClasses;

type
  TStoreTransactionsRequest = class(TIotaAPIRequest)
  private
    FTrytes: TStrings;
  protected
    function GetCommand: String; override;
    function BuildRequestBody(JsonBuilder: TJSONCollectionBuilder.TPairs): TJSONCollectionBuilder.TPairs; override;
  public
    constructor Create(ARESTClient: TCustomRESTClient; ATrytes: TStrings); reintroduce; virtual;
  end;

implementation

{ TStoreTransactionsRequest }

constructor TStoreTransactionsRequest.Create(ARESTClient: TCustomRESTClient; ATrytes: TStrings);
begin
  inherited Create(ARESTClient);
  FTrytes := ATrytes;
end;

function TStoreTransactionsRequest.GetCommand: String;
begin
  Result := 'storeTransactions';
end;

function TStoreTransactionsRequest.BuildRequestBody(JsonBuilder: TJSONCollectionBuilder.TPairs): TJSONCollectionBuilder.TPairs;
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
