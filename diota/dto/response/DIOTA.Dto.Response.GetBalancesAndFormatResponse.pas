unit DIOTA.Dto.Response.GetBalancesAndFormatResponse;

interface

uses
  Generics.Collections,
  DIOTA.IotaAPIClasses,
  DIOTA.Model.Input;

type
  TGetBalancesAndFormatResponse = class(TIotaAPIResponse)
  private
    FInputs: TArray<IInput>;
    FTotalBalance: Int64;
    function GetInputs(Index: Integer): IInput;
    function GetInputsCount: Integer;
  public
    constructor Create(AInputs: TArray<IInput>; ATotalBalance: Int64); reintroduce; virtual;
    function InputsList: TList<IInput>;
    property Inputs[Index: Integer]: IInput read GetInputs;
    property InputsCount: Integer read GetInputsCount;
    property InputsArray: TArray<IInput> read FInputs;
    property TotalBalance: Int64 read FTotalBalance;
  end;

implementation

{ TGetBalancesAndFormatResponse }

constructor TGetBalancesAndFormatResponse.Create(AInputs: TArray<IInput>; ATotalBalance: Int64);
begin
  inherited Create;
  FInputs := AInputs;
  FTotalBalance := ATotalBalance;
end;

function TGetBalancesAndFormatResponse.GetInputs(Index: Integer): IInput;
begin
  Result := FInputs[Index];
end;

function TGetBalancesAndFormatResponse.GetInputsCount: Integer;
begin
  Result := Length(FInputs);
end;

function TGetBalancesAndFormatResponse.InputsList: TList<IInput>;
var
  AInput: IInput;
begin
  Result := TList<IInput>.Create;
  for AInput in FInputs do
    Result.Add(AInput);
end;

end.
