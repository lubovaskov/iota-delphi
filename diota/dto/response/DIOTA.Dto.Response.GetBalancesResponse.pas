unit DIOTA.Dto.Response.GetBalancesResponse;

interface

uses
  Generics.Collections,
  DIOTA.IotaAPIClasses;

type
  TGetBalancesResponse = class(TIotaAPIResponse)
  private
    FBalances: TArray<Int64>;
    FReferences: TArray<String>;
    FMilestoneIndex: Integer;
    function GetBalances(Index: Integer): Int64;
    function GetBalancesCount: Integer;
    function GetReferences(Index: Integer): String;
    function GetReferencesCount: Integer;
  public
    constructor Create(ABalances: TArray<Int64>; AReferences: TArray<String>; AMilestoneIndex: Integer); reintroduce; virtual;
    function BalancesArray: TArray<Int64>;
    function BalancesList: TList<Int64>;
    property Balances[Index: Integer]: Int64 read GetBalances;
    property BalancesCount: Integer read GetBalancesCount;
    property References[Index: Integer]: String read GetReferences;
    property ReferencesCount: Integer read GetReferencesCount;
    property MilestoneIndex: Integer read FMilestoneIndex;
  end;

implementation

{ TGetBalancesResponse }

constructor TGetBalancesResponse.Create(ABalances: TArray<Int64>; AReferences: TArray<String>; AMilestoneIndex: Integer);
begin
  inherited Create;
  FBalances := ABalances;
  FReferences := AReferences;
  FMilestoneIndex := AMilestoneIndex;
end;

function TGetBalancesResponse.GetBalances(Index: Integer): Int64;
begin
  Result := FBalances[Index];
end;

function TGetBalancesResponse.GetBalancesCount: Integer;
begin
  Result := Length(FBalances);
end;

function TGetBalancesResponse.GetReferences(Index: Integer): String;
begin
  Result := FReferences[Index];
end;

function TGetBalancesResponse.GetReferencesCount: Integer;
begin
  Result := Length(FReferences);
end;

function TGetBalancesResponse.BalancesArray: TArray<Int64>;
begin
  Result := FBalances;
end;

function TGetBalancesResponse.BalancesList: TList<Int64>;
var
  ABalance: Int64;
begin
  Result := TList<Int64>.Create;
  for ABalance in FBalances do
    Result.Add(ABalance);
end;

end.
