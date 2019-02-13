unit DIOTA.Dto.Response.AttachToTangleResponse;

interface

uses
  System.Classes,
  DIOTA.IotaAPIClasses;

type
  TAttachToTangleResponse = class(TIotaAPIResponse)
  private
    FTrytes: TArray<String>;
    function GetTrytes(Index: Integer): String;
    function GetTrytesCount: Integer;
  public
    constructor Create(ATrytes: TArray<String>); reintroduce; virtual;
    function TrytesList: TStringList;
    property TrytesCount: Integer read GetTrytesCount;
    property Trytes[Index: Integer]: String read GetTrytes;
  end;

implementation

{ TAttachToTangleResponse }

constructor TAttachToTangleResponse.Create(ATrytes: TArray<String>);
begin
  inherited Create;
  FTrytes := ATrytes;
end;

function TAttachToTangleResponse.GetTrytes(Index: Integer): String;
begin
  Result := FTrytes[Index];
end;

function TAttachToTangleResponse.GetTrytesCount: Integer;
begin
  Result := Length(FTrytes);
end;

function TAttachToTangleResponse.TrytesList: TStringList;
var
  ATryte: String;
begin
  Result := TStringList.Create;
  for ATryte in FTrytes do
    Result.Add(ATryte);
end;

end.
