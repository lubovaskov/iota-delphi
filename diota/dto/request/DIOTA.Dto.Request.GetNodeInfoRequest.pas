unit DIOTA.Dto.Request.GetNodeInfoRequest;

interface

uses
  DIOTA.IotaAPIClasses;

type
  TGetNodeInfoRequest = class(TIotaAPIRequest)
  protected
    function GetCommand: String; override;
  end;

implementation

{ TGetNodeInfoRequest }

function TGetNodeInfoRequest.GetCommand: String;
begin
  Result := 'getNodeInfo';
end;

end.
