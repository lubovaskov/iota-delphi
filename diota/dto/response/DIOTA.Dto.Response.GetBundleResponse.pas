unit DIOTA.Dto.Response.GetBundleResponse;

interface

uses
  Generics.Collections,
  DIOTA.IotaAPIClasses,
  DIOTA.Model.Transaction;

type
  TGetBundleResponse = class(TIotaAPIResponse)
  private
    FTransactions: TArray<ITransaction>;
    function GetTransactions(Index: Integer): ITransaction;
    function GetTransactionsCount: Integer;
  public
    constructor Create(ATransactions: TArray<ITransaction>); reintroduce; virtual;
    function TransactionsList: TList<ITransaction>;
    property TransactionsCount: Integer read GetTransactionsCount;
    property Transactions[Index: Integer]: ITransaction read GetTransactions;
    property TransactionsArray: TArray<ITransaction> read FTransactions;
  end;

implementation

{ TGetBundleResponse }

constructor TGetBundleResponse.Create(ATransactions: TArray<ITransaction>);
begin
  inherited Create;
  FTransactions := ATransactions;
end;

function TGetBundleResponse.GetTransactions(Index: Integer): ITransaction;
begin
  Result := FTransactions[Index];
end;

function TGetBundleResponse.GetTransactionsCount: Integer;
begin
  if Assigned(FTransactions) then
    Result := Length(FTransactions)
  else
    Result := 0;
end;

function TGetBundleResponse.TransactionsList: TList<ITransaction>;
var
  ATransaction: ITransaction;
begin
  Result := TList<ITransaction>.Create;
  if Assigned(FTransactions) then
  for ATransaction in FTransactions do
    Result.Add(ATransaction);
end;

end.
