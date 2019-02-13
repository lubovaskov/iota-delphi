unit DIOTA.Dto.Response.RemoveNeighborsResponse;

interface

uses
  DIOTA.IotaAPIClasses;

type
  TRemoveNeighborsResponse = class(TIotaAPIResponse)
  private
    FRemovedNeighbors: Integer;
  public
    constructor Create(ARemovedNeighbors: Integer); reintroduce; virtual;
    property RemovedNeighbors: Integer read FRemovedNeighbors;
  end;

implementation

{ TRemoveNeighborsResponse }

constructor TRemoveNeighborsResponse.Create(ARemovedNeighbors: Integer);
begin
  inherited Create;
  FRemovedNeighbors := ARemovedNeighbors;
end;

end.
