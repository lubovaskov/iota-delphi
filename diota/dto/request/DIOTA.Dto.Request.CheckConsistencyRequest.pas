unit DIOTA.Dto.Request.CheckConsistencyRequest;

interface

uses
  System.Classes,
  REST.Client,
  System.JSON.Builders,
  DIOTA.IotaAPIClasses;

type
  TCheckConsistencyRequest = class(TIotaAPIRequest)
  private
    FTails: TStrings;
  protected
    function GetCommand: String; override;
    function BuildRequestBody(JsonBuilder: TJSONCollectionBuilder.TPairs): TJSONCollectionBuilder.TPairs; override;
  public
    constructor Create(ARESTClient: TCustomRESTClient; ATimeout: Integer; ATails: TStrings); reintroduce; virtual;
  end;

implementation

{ TCheckConsistencyRequest }

constructor TCheckConsistencyRequest.Create(ARESTClient: TCustomRESTClient; ATimeout: Integer; ATails: TStrings);
begin
  inherited Create(ARESTClient, ATimeout);
  FTails := ATails;
end;

function TCheckConsistencyRequest.GetCommand: String;
begin
  Result := 'checkConsistency';
end;

function TCheckConsistencyRequest.BuildRequestBody(JsonBuilder: TJSONCollectionBuilder.TPairs): TJSONCollectionBuilder.TPairs;
var
  AElements: TJSONCollectionBuilder.TElements;
  ATail: String;
begin
  if Assigned(FTails) then
    begin
      AElements := JsonBuilder.BeginArray('tails');
      for ATail in FTails do
        AElements := AElements.Add(ATail);
      AElements.EndArray;
    end;

  Result := JsonBuilder;
end;

end.
