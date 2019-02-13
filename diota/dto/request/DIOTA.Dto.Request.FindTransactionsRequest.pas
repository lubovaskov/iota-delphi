unit DIOTA.Dto.Request.FindTransactionsRequest;

interface

uses
  System.Classes,
  REST.Client,
  System.JSON.Builders,
  DIOTA.IotaAPIClasses;

type
  TFindTransactionsRequest = class(TIotaAPIRequest)
  private
    FAddresses: TStrings;
    FTags: TStrings;
    FApprovees: TStrings;
    FBundles: TStrings;
  protected
    function GetCommand: String; override;
    function BuildRequestBody(JsonBuilder: TJSONCollectionBuilder.TPairs): TJSONCollectionBuilder.TPairs; override;
  public
    constructor Create(ARESTClient: TCustomRESTClient; AAddresses, ATags, AApprovees, ABundles: TStrings); reintroduce; virtual;
  end;

implementation

{ TFindTransactionsRequest }

constructor TFindTransactionsRequest.Create(ARESTClient: TCustomRESTClient; AAddresses, ATags, AApprovees, ABundles: TStrings);
begin
  inherited Create(ARESTClient);
  FAddresses := AAddresses;
  FTags := ATags;
  FApprovees := AApprovees;
  FBundles := ABundles;
end;

function TFindTransactionsRequest.GetCommand: String;
begin
  Result := 'findTransactions';
end;

function TFindTransactionsRequest.BuildRequestBody(JsonBuilder: TJSONCollectionBuilder.TPairs): TJSONCollectionBuilder.TPairs;
var
  AElements: TJSONCollectionBuilder.TElements;
  AAddress: String;
  ATag: String;
  AApprovee: String;
  ABundle: String;
begin
  if Assigned(FAddresses) then
    begin
      AElements := JsonBuilder.BeginArray('addresses');
      for AAddress in FAddresses do
        AElements := AElements.Add(AAddress);
      AElements.EndArray;
    end;

  if Assigned(FTags) then
    begin
      AElements := JsonBuilder.BeginArray('tags');
      for ATag in FTags do
        AElements := AElements.Add(ATag);
      AElements.EndArray;
    end;

  if Assigned(FApprovees) then
    begin
      AElements := JsonBuilder.BeginArray('approvees');
      for AApprovee in FApprovees do
        AElements := AElements.Add(AApprovee);
      AElements.EndArray;
    end;

  if Assigned(FBundles) then
    begin
      AElements := JsonBuilder.BeginArray('bundles');
      for ABundle in FBundles do
        AElements := AElements.Add(ABundle);
      AElements.EndArray;
    end;

  Result := JsonBuilder;
end;

end.
