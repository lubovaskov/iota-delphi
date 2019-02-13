unit DIOTA.Dto.Response.GetAccountDataResponse;

interface

uses
  System.Classes,
  Generics.Collections,
  DIOTA.IotaAPIClasses,
  DIOTA.Model.Bundle,
  DIOTA.Model.Input;

type
  TGetAccountDataResponse = class(TIotaAPIResponse)
  private
    FAddresses: TArray<String>;
    FTransferBundle: TArray<IBundle>;
    FInputs: TArray<IInput>;
    FBalance: Int64;
    function GetAddresses(Index: Integer): String;
    function GetAddressesCount: Integer;
    function GetTransferBundle(Index: Integer): IBundle;
    function GetTransferBundleCount: Integer;
    function GetInputs(Index: Integer): IInput;
    function GetInputsCount: Integer;
  public
    constructor Create(AAddresses: TArray<String>; ATransferBundle: TArray<IBundle>; AInputs: TArray<IInput>; ABalance: Int64); reintroduce; virtual;
    function AddressesList: TStringList;
    function TransfersList: TList<IBundle>;
    function InputsList: TList<IInput>;
    property AddressesCount: Integer read GetAddressesCount;
    property Addresses[Index: Integer]: String read GetAddresses;
    property AddressesArray: TArray<String> read FAddresses;
    property TransferBundleCount: Integer read GetTransferBundleCount;
    property TransferBundle[Index: Integer]: IBundle read GetTransferBundle;
    property TransferBundleArray: TArray<IBundle> read FTransferBundle;
    property InputsCount: Integer read GetInputsCount;
    property Inputs[Index: Integer]: IInput read GetInputs;
    property InputsArray: TArray<IInput> read FInputs;
    property Balance: Int64 read FBalance;
  end;

implementation

{ TGetAccountDataResponse }

constructor TGetAccountDataResponse.Create(AAddresses: TArray<String>; ATransferBundle: TArray<IBundle>; AInputs: TArray<IInput>; ABalance: Int64);
begin
  inherited Create;
  FAddresses := AAddresses;
  FTransferBundle := ATransferBundle;
  FInputs := AInputs;
  FBalance := ABalance;
end;

function TGetAccountDataResponse.GetAddresses(Index: Integer): String;
begin
  Result := FAddresses[Index];
end;

function TGetAccountDataResponse.GetAddressesCount: Integer;
begin
  if Assigned(FAddresses) then
    Result := Length(FAddresses)
  else
    Result := 0;
end;

function TGetAccountDataResponse.AddressesList: TStringList;
var
  AAddress: String;
begin
  Result := TStringList.Create;
  for AAddress in FAddresses do
    Result.Add(AAddress);
end;

function TGetAccountDataResponse.GetInputs(Index: Integer): IInput;
begin
  Result := FInputs[Index];
end;

function TGetAccountDataResponse.GetInputsCount: Integer;
begin
  if Assigned(FInputs) then
    Result := Length(FInputs)
  else
    Result := 0;
end;

function TGetAccountDataResponse.InputsList: TList<IInput>;
var
  AInput: IInput;
begin
  Result := TList<IInput>.Create;
  for AInput in FInputs do
    Result.Add(AInput);
end;

function TGetAccountDataResponse.GetTransferBundle(Index: Integer): IBundle;
begin
  Result := FTransferBundle[Index];
end;

function TGetAccountDataResponse.GetTransferBundleCount: Integer;
begin
  if Assigned(FTransferBundle) then
    Result := Length(FTransferBundle)
  else
    Result := 0;
end;

function TGetAccountDataResponse.TransfersList: TList<IBundle>;
var
  ATransferBundle: IBundle;
begin
  Result := TList<IBundle>.Create;
  for ATransferBundle in FTransferBundle do
    Result.Add(ATransferBundle);
end;

end.
