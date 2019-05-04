unit DIOTA.Dto.Request.GetInclusionStatesRequest;

interface

uses
  System.Classes,
  REST.Client,
  System.JSON.Builders,
  DIOTA.IotaAPIClasses;

type
  TGetInclusionStatesRequest = class(TIotaAPIRequest)
  private
    FTransactions: TStrings;
    FTips: TStrings;
  protected
    function GetCommand: String; override;
    function BuildRequestBody(JsonBuilder: TJSONCollectionBuilder.TPairs): TJSONCollectionBuilder.TPairs; override;
  public
    constructor Create(ARESTClient: TCustomRESTClient; ATimeout: Integer; ATransactions, ATips: TStrings); reintroduce; virtual;
  end;

implementation

{ TGetInclusionStatesRequest }

constructor TGetInclusionStatesRequest.Create(ARESTClient: TCustomRESTClient; ATimeout: Integer; ATransactions, ATips: TStrings);
begin
  inherited Create(ARESTClient, ATimeout);
  FTransactions := ATransactions;
  FTips := ATips;
end;

function TGetInclusionStatesRequest.GetCommand: String;
begin
  Result := 'getInclusionStates';
end;

function TGetInclusionStatesRequest.BuildRequestBody(JsonBuilder: TJSONCollectionBuilder.TPairs): TJSONCollectionBuilder.TPairs;
var
  AElements: TJSONCollectionBuilder.TElements;
  ATransaction: String;
  ATip: String;
begin
  if Assigned(FTransactions) then
    begin
      AElements := JsonBuilder.BeginArray('transactions');
      for ATransaction in FTransactions do
        AElements := AElements.Add(ATransaction);
      AElements.EndArray;
    end;

  if Assigned(FTips) then
    begin
      AElements := JsonBuilder.BeginArray('tips');
      for ATip in FTips do
        AElements := AElements.Add(ATip);
      AElements.EndArray;
    end;

  Result := JsonBuilder;
end;

end.
