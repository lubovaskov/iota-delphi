unit DIOTA.Dto.Response.ReplayBundleResponse;

interface

uses
  System.Classes,
  DIOTA.IotaAPIClasses;

type
  TReplayBundleResponse = class(TIotaAPIResponse)
  private
    FSuccessfully: TArray<Boolean>;
    function GetSuccessfully(Index: Integer): Boolean;
    function GetSuccessfullyCount: Integer;
  public
    constructor Create(ASuccessfully: TArray<Boolean>); reintroduce; virtual;
    property SuccessfullyCount: Integer read GetSuccessfullyCount;
    property Successfully[Index: Integer]: Boolean read GetSuccessfully;
    property SuccessfullyArray: TArray<Boolean> read FSuccessfully;
  end;

implementation

{ TReplayBundleResponse }

constructor TReplayBundleResponse.Create(ASuccessfully: TArray<Boolean>);
begin
  inherited Create;
  FSuccessfully := ASuccessfully;
end;

function TReplayBundleResponse.GetSuccessfully(Index: Integer): Boolean;
begin
  Result := FSuccessfully[Index];
end;

function TReplayBundleResponse.GetSuccessfullyCount: Integer;
begin
  if Assigned(FSuccessfully) then
    Result := Length(FSuccessfully)
  else
    Result := 0;
end;

end.
