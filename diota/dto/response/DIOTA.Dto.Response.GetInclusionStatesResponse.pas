unit DIOTA.Dto.Response.GetInclusionStatesResponse;

interface

uses
  DIOTA.IotaAPIClasses;

type
  TGetInclusionStatesResponse = class(TIotaAPIResponse)
  private
    FStates: TArray<Boolean>;
    function GetStates(Index: Integer): Boolean;
    function GetStatesCount: Integer;
  public
    constructor Create(AStates: TArray<Boolean>); reintroduce; virtual;
    property StatesCount: Integer read GetStatesCount;
    property States[Index: Integer]: Boolean read GetStates;
  end;

implementation

{ TGetInclusionStatesResponse }

constructor TGetInclusionStatesResponse.Create(AStates: TArray<Boolean>);
begin
  inherited Create;
  FStates := AStates;
end;

function TGetInclusionStatesResponse.GetStates(Index: Integer): Boolean;
begin
  Result := FStates[Index];
end;

function TGetInclusionStatesResponse.GetStatesCount: Integer;
begin
  if Assigned(FStates) then
    Result := Length(FStates)
  else
    Result := 0;
end;

end.
