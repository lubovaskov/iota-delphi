unit DIOTA.Dto.Request.GetTipsRequest;

interface

uses
  DIOTA.IotaAPIClasses;

type
  TGetTipsRequest = class(TIotaAPIRequest)
  protected
    function GetCommand: String; override;
  end;

implementation

{ TGetTipsRequest }

function TGetTipsRequest.GetCommand: String;
begin
  Result := 'getTips';
end;

end.
