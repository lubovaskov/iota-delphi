unit DIOTA.Dto.Response.GetTrytesResponse;

interface

uses
  DIOTA.IotaAPIClasses;

type
  TGetTrytesResponse = class(TIotaAPIResponse)
  private
    FTrytes: TArray<String>;
    function GetTrytes(Index: Integer): String;
    function GetTrytesCount: Integer;
  public
    constructor Create(ATrytes: TArray<String>); reintroduce; virtual;
    property TrytesCount: Integer read GetTrytesCount;
    property Trytes[Index: Integer]: String read GetTrytes;
  end;

implementation

{ TGetTrytesResponse }

constructor TGetTrytesResponse.Create(ATrytes: TArray<String>);
begin
  inherited Create;
  FTrytes := ATrytes;
end;

function TGetTrytesResponse.GetTrytes(Index: Integer): String;
begin
  Result := FTrytes[Index];
end;

function TGetTrytesResponse.GetTrytesCount: Integer;
begin
  Result := Length(FTrytes);
end;

end.
