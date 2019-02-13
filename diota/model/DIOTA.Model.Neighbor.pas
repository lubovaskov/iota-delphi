unit DIOTA.Model.Neighbor;

interface

type
  TNeighbor = class
  private
    FConnectionType: String;
    FNumberOfRandomTransactionRequests: Integer;
    FNumberOfInvalidTransactions: Integer;
    FNumberOfSentTransactions: Integer;
    FNumberOfNewTransactions: Integer;
    FAddress: String;
    FNumberOfAllTransactions: Integer;
  public
    constructor Create(address: String; numberOfAllTransactions: Integer; numberOfInvalidTransactions: Integer; numberOfNewTransactions: Integer;
                       numberOfRandomTransactionRequests: Integer; numberOfSentTransactions: Integer; connectionType: String); virtual;
    property Address: String read FAddress;
    property NumberOfAllTransactions: Integer read FNumberOfAllTransactions;
    property NumberOfInvalidTransactions: Integer read FNumberOfInvalidTransactions;
    property NumberOfNewTransactions: Integer read FNumberOfNewTransactions;
    property NumberOfRandomTransactionRequests: Integer read FNumberOfRandomTransactionRequests;
    property NumberOfSentTransactions: Integer read FNumberOfSentTransactions;
    property ConnectionType: String read FConnectionType;
  end;

implementation

{ TNeighbor }

constructor TNeighbor.Create(address: String; numberOfAllTransactions: Integer; numberOfInvalidTransactions: Integer; numberOfNewTransactions: Integer;
                             numberOfRandomTransactionRequests: Integer; numberOfSentTransactions: Integer; connectionType: String);
begin
  FAddress := address;
  FNumberOfAllTransactions := numberOfAllTransactions;
  FNumberOfInvalidTransactions := numberOfInvalidTransactions;
  FNumberOfNewTransactions := numberOfNewTransactions;
  FNumberOfRandomTransactionRequests := numberOfRandomTransactionRequests;
  FNumberOfSentTransactions := numberOfSentTransactions;
  FConnectionType := connectionType;
end;

end.
