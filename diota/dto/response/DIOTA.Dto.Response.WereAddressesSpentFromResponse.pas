unit DIOTA.Dto.Response.WereAddressesSpentFromResponse;

interface

uses
  DIOTA.IotaAPIClasses;

type
  TWereAddressesSpentFromResponse = class(TIotaAPIResponse)
  private
    FStates: TArray<Boolean>;
    function GetStates(Index: Integer): Boolean;
    function GetStatesCount: Integer;
  public
    constructor Create(AStates: TArray<Boolean>); reintroduce; virtual;
    property StatesCount: Integer read GetStatesCount;
    property States[Index: Integer]: Boolean read GetStates;
    property StatesArray: TArray<Boolean> read FStates;
  end;

implementation

{ TWereAddressesSpentFromResponse }

constructor TWereAddressesSpentFromResponse.Create(AStates: TArray<Boolean>);
begin
  inherited Create;
  FStates := AStates;
end;

function TWereAddressesSpentFromResponse.GetStates(Index: Integer): Boolean;
begin
  Result := FStates[Index];
end;

function TWereAddressesSpentFromResponse.GetStatesCount: Integer;
begin
  Result := Length(FStates);
end;

end.
