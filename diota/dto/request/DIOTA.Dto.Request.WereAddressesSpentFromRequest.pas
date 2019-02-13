unit DIOTA.Dto.Request.WereAddressesSpentFromRequest;

interface

uses
  System.Classes,
  REST.Client,
  System.JSON.Builders,
  DIOTA.IotaAPIClasses;

type
  TWereAddressesSpentFromRequest = class(TIotaAPIRequest)
  private
    FAddresses: TStrings;
  protected
    function GetCommand: String; override;
    function BuildRequestBody(JsonBuilder: TJSONCollectionBuilder.TPairs): TJSONCollectionBuilder.TPairs; override;
  public
    constructor Create(ARESTClient: TCustomRESTClient; AAddresses: TStrings); reintroduce; virtual;
  end;

implementation

{ TWereAddressesSpentFromRequest }

constructor TWereAddressesSpentFromRequest.Create(ARESTClient: TCustomRESTClient; AAddresses: TStrings);
begin
  inherited Create(ARESTClient);
  FAddresses := AAddresses;
end;

function TWereAddressesSpentFromRequest.GetCommand: String;
begin
  Result := 'wereAddressesSpentFrom';
end;

function TWereAddressesSpentFromRequest.BuildRequestBody(JsonBuilder: TJSONCollectionBuilder.TPairs): TJSONCollectionBuilder.TPairs;
var
  AElements: TJSONCollectionBuilder.TElements;
  AAddress: String;
begin
  if Assigned(FAddresses) then
    begin
      AElements := JsonBuilder.BeginArray('addresses');
      for AAddress in FAddresses do
        AElements := AElements.Add(AAddress);
      AElements.EndArray;
    end;

  Result := JsonBuilder;
end;

end.
