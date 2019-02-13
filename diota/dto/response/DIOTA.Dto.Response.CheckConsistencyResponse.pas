unit DIOTA.Dto.Response.CheckConsistencyResponse;

interface

uses
  DIOTA.IotaAPIClasses;

type
  TCheckConsistencyResponse = class(TIotaAPIResponse)
  private
    FState: Boolean;
    FInfo: String;
  public
    constructor Create(AState: Boolean; AInfo: String); reintroduce; virtual;
    property State: Boolean read FState;
    {
     * If state is false, this provides information on the cause of the inconsistency.
     * @return the information of the state of the tail transactions
    }
    property Info: String read FInfo;
  end;

implementation

{ TCheckConsistencyResponse }

constructor TCheckConsistencyResponse.Create(AState: Boolean; AInfo: String);
begin
  inherited Create;
  FState := AState;
  FInfo := AInfo;
end;

end.
