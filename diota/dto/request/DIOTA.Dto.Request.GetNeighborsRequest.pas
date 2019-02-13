unit DIOTA.Dto.Request.GetNeighborsRequest;

interface

uses
  DIOTA.IotaAPIClasses;

type
  TGetNeighborsRequest = class(TIotaAPIRequest)
  protected
    function GetCommand: String; override;
  end;

implementation

{ TGetNeighborsRequest }

function TGetNeighborsRequest.GetCommand: String;
begin
  Result := 'getNeighbors';
end;

end.
