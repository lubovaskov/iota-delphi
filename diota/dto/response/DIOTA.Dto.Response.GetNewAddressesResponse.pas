unit DIOTA.Dto.Response.GetNewAddressesResponse;

interface

uses
  System.Classes,
  DIOTA.IotaAPIClasses;

type
  TGetNewAddressesResponse = class(TIotaAPIResponse)
  private
    FAddresses: TArray<String>;
    function GetAddresses(Index: Integer): String;
    function GetAddressesCount: Integer;
  public
    constructor Create(AAddresses: TArray<String>); reintroduce; virtual;
    function AddressesList: TStringList;
    property AddressesCount: Integer read GetAddressesCount;
    property Addresses[Index: Integer]: String read GetAddresses;
    property AddressesArray: TArray<String> read FAddresses;
  end;

implementation

{ TGetNewAddressesResponse }

constructor TGetNewAddressesResponse.Create(AAddresses: TArray<String>);
begin
  inherited Create;
  FAddresses := AAddresses;
end;

function TGetNewAddressesResponse.GetAddresses(Index: Integer): String;
begin
  Result := FAddresses[Index];
end;

function TGetNewAddressesResponse.GetAddressesCount: Integer;
begin
  if Assigned(FAddresses) then
    Result := Length(FAddresses)
  else
    Result := 0;
end;

function TGetNewAddressesResponse.AddressesList: TStringList;
var
  AAddress: String;
begin
  Result := TStringList.Create;
  for AAddress in FAddresses do
    Result.Add(AAddress);
end;

end.
