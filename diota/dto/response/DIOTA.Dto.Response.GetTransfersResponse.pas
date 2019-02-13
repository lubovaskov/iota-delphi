unit DIOTA.Dto.Response.GetTransfersResponse;

interface

uses
  DIOTA.IotaAPIClasses,
  DIOTA.Model.Bundle;

type
  TGetTransfersResponse = class(TIotaAPIResponse)
  private
    FTransfers: TArray<IBundle>;
    function GetTransfers(Index: Integer): IBundle;
    function GetTransfersCount: Integer;
  public
    constructor Create(ATransfers: TArray<IBundle>); reintroduce; overload; virtual;
    property TransfersCount: Integer read GetTransfersCount;
    property Transfers[Index: Integer]: IBundle read GetTransfers;
    property TransfersArray: TArray<IBundle> read FTransfers;
  end;

implementation

{ TGetTransfersResponse }

constructor TGetTransfersResponse.Create(ATransfers: TArray<IBundle>);
begin
  inherited Create;
  FTransfers := ATransfers;
end;

function TGetTransfersResponse.GetTransfers(Index: Integer): IBundle;
begin
  Result := FTransfers[Index];
end;

function TGetTransfersResponse.GetTransfersCount: Integer;
begin
  Result := Length(FTransfers);
end;

end.
