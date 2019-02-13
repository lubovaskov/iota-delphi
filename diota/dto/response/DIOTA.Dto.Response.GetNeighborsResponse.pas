unit DIOTA.Dto.Response.GetNeighborsResponse;

interface

uses
  DIOTA.IotaAPIClasses,
  DIOTA.Model.Neighbor;

type
  TGetNeighborsResponse = class(TIotaAPIResponse)
  private
    FNeighbors: TArray<TNeighbor>;
    function GetNeighborsCount: Integer;
    function GetNeighbors(Index: Integer): TNeighbor;
  public
    constructor Create(ANeighbors: TArray<TNeighbor>); reintroduce; virtual;
	property NeighborsCount: Integer read GetNeighborsCount;
    property Neighbors[Index: Integer]: TNeighbor read GetNeighbors;
  end;

implementation

{ TGetNeighborsResponse }

constructor TGetNeighborsResponse.Create(ANeighbors: TArray<TNeighbor>);
begin
  inherited Create;
  FNeighbors := ANeighbors;
end; 

function TGetNeighborsResponse.GetNeighbors(Index: Integer): TNeighbor;
begin
  Result := FNeighbors[Index];
end;

function TGetNeighborsResponse.GetNeighborsCount: Integer;
begin
  Result := Length(FNeighbors);
end;

end.
