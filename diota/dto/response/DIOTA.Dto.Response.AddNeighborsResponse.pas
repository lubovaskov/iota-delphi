unit DIOTA.Dto.Response.AddNeighborsResponse;

interface

uses
  DIOTA.IotaAPIClasses;

type
  TAddNeighborsResponse = class(TIotaAPIResponse)
  private
    FAddedNeighbors: Integer;
  public
    constructor Create(AAddedNeighbors: Integer); reintroduce; virtual;
    property AddedNeighbors: Integer read FAddedNeighbors;
  end;

implementation

{ TAddNeighborsResponse }

constructor TAddNeighborsResponse.Create(AAddedNeighbors: Integer);
begin
  inherited Create;
  FAddedNeighbors := AAddedNeighbors;
end;

end.
