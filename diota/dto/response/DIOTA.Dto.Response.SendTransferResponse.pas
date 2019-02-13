unit DIOTA.Dto.Response.SendTransferResponse;

interface

uses
  System.Classes,
  Generics.Collections,
  DIOTA.Model.Transaction,
  DIOTA.IotaAPIClasses;

type
  TSendTransferResponse = class(TIotaAPIResponse)
  private
    FTransactions: TArray<ITransaction>;
    FSuccessfully: TArray<Boolean>;
    function GetTransactions(Index: Integer): ITransaction;
    function GetTransactionsCount: Integer;
    function GetSuccessfully(Index: Integer): Boolean;
    function GetSuccessfullyCount: Integer;
  public
    constructor Create(ATransactions: TArray<ITransaction>; ASuccessfully: TArray<Boolean>); reintroduce; virtual;
    function TransactionsList: TList<ITransaction>;
    property TransactionsCount: Integer read GetTransactionsCount;
    property Transactions[Index: Integer]: ITransaction read GetTransactions;
    property TransactionsArray: TArray<ITransaction> read FTransactions;
    property SuccessfullyCount: Integer read GetSuccessfullyCount;
    property Successfully[Index: Integer]: Boolean read GetSuccessfully;
    property SuccessfullyArray: TArray<Boolean> read FSuccessfully;
  end;

implementation

{ TSendTransferResponse }

constructor TSendTransferResponse.Create(ATransactions: TArray<ITransaction>; ASuccessfully: TArray<Boolean>);
begin
  inherited Create;
  FTransactions := ATransactions;
  FSuccessfully := ASuccessfully;
end;

function TSendTransferResponse.GetSuccessfully(Index: Integer): Boolean;
begin
  Result := FSuccessfully[Index];
end;

function TSendTransferResponse.GetSuccessfullyCount: Integer;
begin
  if Assigned(FSuccessfully) then
    Result := Length(FSuccessfully)
  else
    Result := 0;
end;

function TSendTransferResponse.GetTransactions(Index: Integer): ITransaction;
begin
  Result := FTransactions[Index];
end;

function TSendTransferResponse.GetTransactionsCount: Integer;
begin
  if Assigned(FTransactions) then
    Result := Length(FTransactions)
  else
    Result := 0;
end;

function TSendTransferResponse.TransactionsList: TList<ITransaction>;
var
  ATransaction: ITransaction;
begin
  Result := TList<ITransaction>.Create;
  for ATransaction in FTransactions do
    Result.Add(ATransaction);
end;

end.
