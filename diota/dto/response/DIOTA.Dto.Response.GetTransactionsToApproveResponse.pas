unit DIOTA.Dto.Response.GetTransactionsToApproveResponse;

interface

uses
  DIOTA.IotaAPIClasses;

type
  TGetTransactionsToApproveResponse = class(TIotaAPIResponse)
  private
    FTrunkTransaction: String;
    FBranchTransaction: String;
  public
    constructor Create(ATrunkTransaction: String; ABranchTransaction: String); reintroduce; virtual;
    property TrunkTransaction: String read FTrunkTransaction;
    property BranchTransaction: String read FBranchTransaction;
  end;

implementation

{ TGetTransactionsToApproveResponse }

constructor TGetTransactionsToApproveResponse.Create(ATrunkTransaction, ABranchTransaction: String);
begin
  inherited Create;
  FTrunkTransaction := ATrunkTransaction;
  FBranchTransaction := ABranchTransaction;
end;

end.
