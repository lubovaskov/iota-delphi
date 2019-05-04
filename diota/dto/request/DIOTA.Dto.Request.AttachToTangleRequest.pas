unit DIOTA.Dto.Request.AttachToTangleRequest;

interface

uses
  System.Classes,
  REST.Client,
  System.JSON.Builders,
  DIOTA.IotaAPIClasses;

type
  TAttachToTangleRequest = class(TIotaAPIRequest)
  private
    FTrunkTransaction: String;
    FBranchTransaction: String;
    FMinWeightMagnitude: Integer;
    FTrytes: TStrings;
  protected
    function GetCommand: String; override;
    function BuildRequestBody(JsonBuilder: TJSONCollectionBuilder.TPairs): TJSONCollectionBuilder.TPairs; override;
  public
    constructor Create(ARESTClient: TCustomRESTClient; ATimeout: Integer; ATrunkTransaction: String; ABranchTransaction: String; AMinWeightMagnitude: Integer; ATrytes: TStrings); reintroduce; virtual;
  end;

implementation

{ TAttachToTangleRequest }

constructor TAttachToTangleRequest.Create(ARESTClient: TCustomRESTClient; ATimeout: Integer; ATrunkTransaction, ABranchTransaction: String; AMinWeightMagnitude: Integer; ATrytes: TStrings);
begin
  inherited Create(ARESTClient, ATimeout);
  FTrunkTransaction := ATrunkTransaction;
  FBranchTransaction := ABranchTransaction;
  FMinWeightMagnitude := AMinWeightMagnitude;
  FTrytes := ATrytes;
end;

function TAttachToTangleRequest.GetCommand: String;
begin
  Result := 'attachToTangle';
end;

function TAttachToTangleRequest.BuildRequestBody(JsonBuilder: TJSONCollectionBuilder.TPairs): TJSONCollectionBuilder.TPairs;
var
  AElements: TJSONCollectionBuilder.TElements;
  ATryte: String;
begin
  JsonBuilder
    .Add('trunkTransaction', FTrunkTransaction)
    .Add('branchTransaction', FBranchTransaction)
    .Add('minWeightMagnitude', FMinWeightMagnitude);

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
