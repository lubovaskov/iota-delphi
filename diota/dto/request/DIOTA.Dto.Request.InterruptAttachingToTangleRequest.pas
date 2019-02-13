unit DIOTA.Dto.Request.InterruptAttachingToTangleRequest;

interface

uses
  DIOTA.IotaAPIClasses;

type
  TInterruptAttachingToTangleRequest = class(TIotaAPIRequest)
  protected
    function GetCommand: String; override;
  end;

implementation

{ TInterruptAttachingToTangleRequest }

function TInterruptAttachingToTangleRequest.GetCommand: String;
begin
  Result := 'interruptAttachingToTangle';
end;

end.
