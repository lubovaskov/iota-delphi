unit DIOTA.IotaAPICoreImpl;

interface

uses
  System.Classes,
  REST.Client,
  IPPeerClient,
  DIOTA.IotaAPICore,
  DIOTA.IotaLocalPow,
  DIOTA.Dto.Response.GetNodeInfoResponse,
  DIOTA.Dto.Response.GetNeighborsResponse,
  DIOTA.Dto.Response.AddNeighborsResponse,
  DIOTA.Dto.Response.RemoveNeighborsResponse,
  DIOTA.Dto.Response.GetTipsResponse,
  DIOTA.Dto.Response.FindTransactionsResponse,
  DIOTA.Dto.Response.GetInclusionStatesResponse,
  DIOTA.Dto.Response.GetTrytesResponse,
  DIOTA.Dto.Response.GetTransactionsToApproveResponse,
  DIOTA.Dto.Response.GetBalancesResponse,
  DIOTA.Dto.Response.WereAddressesSpentFromResponse,
  DIOTA.Dto.Response.CheckConsistencyResponse,
  DIOTA.Dto.Response.AttachToTangleResponse,
  DIOTA.Dto.Response.InterruptAttachingToTangleResponse,
  DIOTA.Dto.Response.BroadcastTransactionsResponse,
  DIOTA.Dto.Response.StoreTransactionsResponse;

type
  TIotaAPICore = class(TInterfacedObject, IIotaAPICore)
  private
    FRestClient: TRESTClient;
    FProtocol: String;
    FHost: String;
    FPort: Integer;
    FLocalPow: IIotaLocalPow;
    function GetProtocol: String;
    function GetHost: String;
    function GetPort: Integer;
    {
     * <p>
     * Calculates the confirmed balance, as viewed by the specified <tt>tips</tt>.
     * If you do not specify the referencing <tt>tips</tt>,
     * the returned balance is based on the latest confirmed milestone.
     * In addition to the balances, it also returns the referencing <tt>tips</tt> (or milestone),
     * as well as the index with which the confirmed balance was determined.
     * The balances are returned as a list in the same order as the addresses were provided as input.
     * </p>
     *
     * @param AConfirmationThreshold The confirmation threshold between 0 and 100(inclusive).
     *                               Should be set to 100 for getting balance by counting only confirmed transactions.
     * @param addresses The addresses where we will find the balance for.
     * @param tips The optional tips to find the balance through.
     * @return @link GetBalancesResponse
     * @throws ArgumentException The the request was considered wrong in any way by the node
     * @throws ArgumentException
    }
    function GetBalances(AConfirmationThreshold: Integer; AAddresses: TArray<String>; ATips: TArray<String>): TGetBalancesResponse; overload;
  public
    constructor Create(ABuilder: IIotaAPICoreBuilder); virtual;
    destructor Destroy; override;

    function GetNodeInfo: TGetNodeInfoResponse;
    function GetNeighbors: TGetNeighborsResponse;
    function AddNeighbors(AUris: TStrings): TAddNeighborsResponse;
    function RemoveNeighbors(AUris: TStrings): TRemoveNeighborsResponse;
    function GetTips: TGetTipsResponse;
    function FindTransactions(AAddresses: TStrings; ATags: TStrings; AApprovees: TStrings; ABundles: TStrings): TFindTransactionsResponse;
    function FindTransactionsByAddresses(AAddresses: TStrings): TFindTransactionsResponse;
    function FindTransactionsByBundles(ABundles: TStrings): TFindTransactionsResponse;
    function FindTransactionsByApprovees(AApprovees: TStrings): TFindTransactionsResponse;
    function FindTransactionsByDigests(ADigests: TStrings): TFindTransactionsResponse;
    function GetInclusionStates(ATransactions: TStrings; ATips: TStrings): TGetInclusionStatesResponse;
    function GetTrytes(AHashes: TStrings): TGetTrytesResponse;
    function GetTransactionsToApprove(ADepth: Integer; AReference: String): TGetTransactionsToApproveResponse; overload;
    function GetTransactionsToApprove(ADepth: Integer): TGetTransactionsToApproveResponse; overload;
    function GetBalances(AConfirmationThreshold: Integer; AAddresses: TStrings): TGetBalancesResponse; overload;
    function GetBalances(AConfirmationThreshold: Integer; AAddresses: TStrings; ATips: TStrings): TGetBalancesResponse; overload;
    function WereAddressesSpentFrom(AAddresses: TStrings): TWereAddressesSpentFromResponse;
    function CheckConsistency(ATails: TStrings): TCheckConsistencyResponse;
    function AttachToTangle(ATrunkTransaction: String; ABranchTransaction: String; AMinWeightMagnitude: Integer; ATrytes: TStrings): TAttachToTangleResponse;
    function InterruptAttachingToTangle: TInterruptAttachingToTangleResponse;
    function BroadcastTransactions(ATrytes: TStrings): TBroadcastTransactionsResponse;
    function StoreTransactions(ATrytes: TStrings): TStoreTransactionsResponse;
  end;

  TIotaAPICoreBuilder = class(TInterfacedObject, IIotaAPICoreBuilder)
  protected
    FProtocol: String;
    FHost: String;
    FPort: Integer;
    FLocalPow: IIotaLocalPow;
  public
    function Protocol(AProtocol: String): IIotaAPICoreBuilder;
    function Host(AHost: String): IIotaAPICoreBuilder;
    function Port(APort: Integer): IIotaAPICoreBuilder;
    function LocalPow(ALocalPow: IIotaLocalPow): IIotaAPICoreBuilder;
    function Build: IIotaAPICore;
    function GetProtocol: String;
    function GetHost: String;
    function GetPort: Integer;
    function GetLocalPow: IIotaLocalPow;
  end;

implementation

uses
  System.SysUtils,
  System.DateUtils,
  DIOTA.Utils.Constants,
  DIOTA.Utils.Checksum,
  DIOTA.Utils.InputValidator,
  DIOTA.Model.Transaction,
  DIOTA.IotaAPIClasses,
  DIOTA.Dto.Request.GetNodeInfoRequest,
  DIOTA.Dto.Request.GetNeighborsRequest,
  DIOTA.Dto.Request.AddNeighborsRequest,
  DIOTA.Dto.Request.RemoveNeighborsRequest,
  DIOTA.Dto.Request.GetTipsRequest,
  DIOTA.Dto.Request.FindTransactionsRequest,
  DIOTA.Dto.Request.GetInclusionStatesRequest,
  DIOTA.Dto.Request.GetTrytesRequest,
  DIOTA.Dto.Request.GetTransactionsToApproveRequest,
  DIOTA.Dto.Request.GetBalancesRequest,
  DIOTA.Dto.Request.WereAddressesSpentFromRequest,
  DIOTA.Dto.Request.CheckConsistencyRequest,
  DIOTA.Dto.Request.AttachToTangleRequest,
  DIOTA.Dto.Request.InterruptAttachingToTangleRequest,
  DIOTA.Dto.Request.BroadcastTransactionsRequest,
  DIOTA.Dto.Request.StoreTransactionsRequest, System.StrUtils;

{ TIotaAPICoreBuilder }

function TIotaAPICoreBuilder.Protocol(AProtocol: String): IIotaAPICoreBuilder;
begin
  FProtocol := AProtocol;
  Result := Self;
end;

function TIotaAPICoreBuilder.Host(AHost: String): IIotaAPICoreBuilder;
begin
  FHost := AHost;
  Result := Self;
end;

function TIotaAPICoreBuilder.Port(APort: Integer): IIotaAPICoreBuilder;
begin
  FPort := APort;
  Result := Self;
end;

function TIotaAPICoreBuilder.LocalPow(ALocalPow: IIotaLocalPow): IIotaAPICoreBuilder;
begin
  FLocalPow := ALocalPow;
  Result := Self;
end;

function TIotaAPICoreBuilder.Build: IIotaAPICore;
begin
  Result := TIotaAPICore.Create(Self);
end;

function TIotaAPICoreBuilder.GetProtocol: String;
begin
  Result := FProtocol;
end;

function TIotaAPICoreBuilder.GetHost: String;
begin
  Result := FHost;
end;

function TIotaAPICoreBuilder.GetPort: Integer;
begin
  Result := FPort;
end;

function TIotaAPICoreBuilder.GetLocalPow: IIotaLocalPow;
begin
  Result := FLocalPow;
end;

{ TIotaAPICore }

constructor TIotaAPICore.Create(ABuilder: IIotaAPICoreBuilder);
begin
  FProtocol := ABuilder.GetProtocol;
  FHost := ABuilder.GetHost;
  FPort := ABuilder.GetPort;
  FLocalPow := ABuilder.GetLocalPow;

  FRESTClient := TRESTClient.Create(FProtocol + '://' + FHost + ':' + IntToStr(FPort));
  FRESTClient.Accept:= 'application/json';
  FRESTClient.AcceptCharset:= 'UTF-8';
end;

destructor TIotaAPICore.Destroy;
begin
  FRESTClient.Free;
  inherited;
end;

function TIotaAPICore.GetProtocol: String;
begin
  Result := FProtocol;
end;

function TIotaAPICore.GetHost: String;
begin
  Result := FHost;
end;

function TIotaAPICore.GetPort: Integer;
begin
  Result := FPort;
end;

function TIotaAPICore.GetNodeInfo: TGetNodeInfoResponse;
var
  ARequest: TGetNodeInfoRequest;
begin
  ARequest:= TGetNodeInfoRequest.Create(FRESTClient);
  try
    Result := ARequest.Execute<TGetNodeInfoResponse>;
  finally
    ARequest.Free;
  end;
end;

function TIotaAPICore.GetNeighbors: TGetNeighborsResponse;
var
  ARequest: TGetNeighborsRequest;
begin
  ARequest:= TGetNeighborsRequest.Create(FRESTClient);
  try
    Result := ARequest.Execute<TGetNeighborsResponse>;
  finally
    ARequest.Free;
  end;
end;

function TIotaAPICore.AddNeighbors(AUris: TStrings): TAddNeighborsResponse;
var
  ARequest: TAddNeighborsRequest;
begin
  ARequest:= TAddNeighborsRequest.Create(FRESTClient, AUris);
  try
    Result := ARequest.Execute<TAddNeighborsResponse>;
  finally
    ARequest.Free;
  end;
end;

function TIotaAPICore.RemoveNeighbors(AUris: TStrings): TRemoveNeighborsResponse;
var
  ARequest: TRemoveNeighborsRequest;
begin
  ARequest:= TRemoveNeighborsRequest.Create(FRESTClient, AUris);
  try
    Result := ARequest.Execute<TRemoveNeighborsResponse>;
  finally
    ARequest.Free;
  end;
end;

function TIotaAPICore.GetTips: TGetTipsResponse;
var
  ARequest: TGetTipsRequest;
begin
  ARequest:= TGetTipsRequest.Create(FRESTClient);
  try
    Result := ARequest.Execute<TGetTipsResponse>;
  finally
    ARequest.Free;
  end;
end;

function TIotaAPICore.FindTransactions(AAddresses, ATags, AApprovees, ABundles: TStrings): TFindTransactionsResponse;
var
  ARequest: TFindTransactionsRequest;
begin
  ARequest:= TFindTransactionsRequest.Create(FRESTClient, AAddresses, ATags, AApprovees, ABundles);
  try
    Result := ARequest.Execute<TFindTransactionsResponse>;
  finally
    ARequest.Free;
  end;
end;

function TIotaAPICore.FindTransactionsByAddresses(AAddresses: TStrings): TFindTransactionsResponse;
var
  AAddressesWithoutChecksum: TStringList;
  AAddress: String;
begin
  AAddressesWithoutChecksum := TStringList.Create;
  try
    for AAddress in AAddresses do
      AAddressesWithoutChecksum.Add(TChecksum.RemoveChecksum(AAddress));

    Result := FindTransactions(AAddressesWithoutChecksum, nil, nil, nil);
  finally
    AAddressesWithoutChecksum.Free;
  end;
end;

function TIotaAPICore.FindTransactionsByApprovees(AApprovees: TStrings): TFindTransactionsResponse;
begin
  Result := FindTransactions(nil, nil, AApprovees, nil);
end;

function TIotaAPICore.FindTransactionsByBundles(ABundles: TStrings): TFindTransactionsResponse;
begin
  Result := FindTransactions(nil, nil, nil, ABundles);
end;

function TIotaAPICore.FindTransactionsByDigests(ADigests: TStrings): TFindTransactionsResponse;
begin
  Result := FindTransactions(nil, ADigests, nil, nil);
end;

function TIotaAPICore.GetInclusionStates(ATransactions, ATips: TStrings): TGetInclusionStatesResponse;
var
  ARequest: TGetInclusionStatesRequest;
begin
  if not TInputValidator.IsArrayOfHashes(ATransactions.ToStringArray) then
    raise Exception.Create(INVALID_HASHES_INPUT_ERROR);

  if not TInputValidator.IsArrayOfHashes(ATips.ToStringArray) then
    raise Exception.Create(INVALID_HASHES_INPUT_ERROR);

  ARequest:= TGetInclusionStatesRequest.Create(FRESTClient, ATransactions, ATips);
  try
    Result := ARequest.Execute<TGetInclusionStatesResponse>;
  finally
    ARequest.Free;
  end;
end;

function TIotaAPICore.GetTrytes(AHashes: TStrings): TGetTrytesResponse;
var
  ARequest: TGetTrytesRequest;
begin
  if not TInputValidator.IsArrayOfHashes(AHashes.ToStringArray) then
    raise Exception.Create(INVALID_HASHES_INPUT_ERROR);

  ARequest:= TGetTrytesRequest.Create(FRESTClient, AHashes);
  try
    Result := ARequest.Execute<TGetTrytesResponse>;
  finally
    ARequest.Free;
  end;
end;

function TIotaAPICore.GetTransactionsToApprove(ADepth: Integer; AReference: String): TGetTransactionsToApproveResponse;
var
  ARequest: TGetTransactionsToApproveRequest;
begin
  ARequest:= TGetTransactionsToApproveRequest.Create(FRESTClient, ADepth, AReference);
  try
    Result := ARequest.Execute<TGetTransactionsToApproveResponse>;
  finally
    ARequest.Free;
  end;
end;

function TIotaAPICore.GetTransactionsToApprove(ADepth: Integer): TGetTransactionsToApproveResponse;
begin
  Result := GetTransactionsToApprove(ADepth, '');
end;

function TIotaAPICore.GetBalances(AConfirmationThreshold: Integer; AAddresses: TStrings): TGetBalancesResponse;
begin
  Result := GetBalances(AConfirmationThreshold, AAddresses, nil);
end;

function TIotaAPICore.GetBalances(AConfirmationThreshold: Integer; AAddresses, ATips: TStrings): TGetBalancesResponse;
var
  AAddressesWithoutChecksum: TStringList;
  AAddress: String;
begin
  AAddressesWithoutChecksum := TStringList.Create;
  try
    for AAddress in AAddresses do
      AAddressesWithoutChecksum.Add(TChecksum.RemoveChecksum(AAddress));

    if Assigned(ATips) then
      Result := GetBalances(AConfirmationThreshold, AAddressesWithoutChecksum.ToStringArray, ATips.ToStringArray)
    else
      Result := GetBalances(AConfirmationThreshold, AAddressesWithoutChecksum.ToStringArray, nil);
  finally
    AAddressesWithoutChecksum.Free;
  end;
end;

function TIotaAPICore.GetBalances(AConfirmationThreshold: Integer; AAddresses, ATips: TArray<String>): TGetBalancesResponse;
var
  ARequest: TGetBalancesRequest;
begin
  ARequest:= TGetBalancesRequest.Create(FRESTClient, AConfirmationThreshold, AAddresses, ATips);
  try
    Result := ARequest.Execute<TGetBalancesResponse>;
  finally
    ARequest.Free;
  end;
end;

function TIotaAPICore.WereAddressesSpentFrom(AAddresses: TStrings): TWereAddressesSpentFromResponse;
var
  ARequest: TWereAddressesSpentFromRequest;
begin
  if not TInputValidator.IsAddressesArrayValid(AAddresses.ToStringArray) then
    raise Exception.Create(INVALID_HASHES_INPUT_ERROR);

  ARequest:= TWereAddressesSpentFromRequest.Create(FRESTClient, AAddresses);
  try
    Result := ARequest.Execute<TWereAddressesSpentFromResponse>;
  finally
    ARequest.Free;
  end;
end;

function TIotaAPICore.CheckConsistency(ATails: TStrings): TCheckConsistencyResponse;
var
  ARequest: TCheckConsistencyRequest;
begin
  if not TInputValidator.IsArrayOfHashes(ATails.ToStringArray) then
    raise Exception.Create(INVALID_HASHES_INPUT_ERROR);

  ARequest:= TCheckConsistencyRequest.Create(FRESTClient, ATails);
  try
    Result := ARequest.Execute<TCheckConsistencyResponse>;
  finally
    ARequest.Free;
  end;
end;

function TIotaAPICore.AttachToTangle(ATrunkTransaction, ABranchTransaction: String; AMinWeightMagnitude: Integer; ATrytes: TStrings): TAttachToTangleResponse;
var
  ARequest: TAttachToTangleRequest;
  AResultTrytes: TArray<String>;
  APreviousTransaction: String;
  i: Integer;
  ATxnTrytes: String;
  ATrBuilder: TTransactionBuilder;
begin
  if not TInputValidator.IsHash(ATrunkTransaction) then
    raise Exception.Create(INVALID_HASHES_INPUT_ERROR);

  if not TInputValidator.IsHash(ABranchTransaction) then
    raise Exception.Create(INVALID_HASHES_INPUT_ERROR);

  if not TInputValidator.AreTransactionTrytes(ATrytes.ToStringArray) then
    raise Exception.Create(INVALID_TRYTES_INPUT_ERROR);

  if Assigned(FLocalPoW) then
    begin
      SetLength(AResultTrytes, ATrytes.Count);
      APreviousTransaction := '';
      for i := 0 to ATrytes.Count - 1 do
        begin
          ATrBuilder := TTransactionBuilder.Create;
          try
            ATxnTrytes := ATrBuilder
              .FromTrytes(ATrytes[i])
              .SetTrunkTransaction(IfThen(APreviousTransaction = '', ATrunkTransaction, APreviousTransaction))
              .SetBranchTransaction(IfThen(APreviousTransaction = '', ABranchTransaction, ATrunkTransaction))
              .SetAttachmentTimestamp(DateTimeToUnix(TTimeZone.Local.ToUniversalTime(Now)))
              .SetAttachmentTimestampLowerBound(0)
              .SetAttachmentTimestampUpperBound(3812798742493)
              .Build
              .ToTrytes;
          finally
            ATrBuilder.Free;
          end;

          AResultTrytes[i] := FLocalPow.PerformPoW(ATxnTrytes, AMinWeightMagnitude);

          with TTransactionBuilder.Create do
            try
              APreviousTransaction := FromTrytes(AResultTrytes[i]).Build.Hash;
            finally
              Free;
            end;
        end;
      Result := TAttachToTangleResponse.Create(AResultTrytes);
    end
  else
    begin
      ARequest:= TAttachToTangleRequest.Create(FRESTClient, ATrunkTransaction, ABranchTransaction, AMinWeightMagnitude, ATrytes);
      try
        Result := ARequest.Execute<TAttachToTangleResponse>;
      finally
        ARequest.Free;
      end;
    end;
end;

function TIotaAPICore.InterruptAttachingToTangle: TInterruptAttachingToTangleResponse;
var
  ARequest: TInterruptAttachingToTangleRequest;
begin
  ARequest:= TInterruptAttachingToTangleRequest.Create(FRESTClient);
  try
    Result := ARequest.Execute<TInterruptAttachingToTangleResponse>;
  finally
    ARequest.Free;
  end;
end;

function TIotaAPICore.BroadcastTransactions(ATrytes: TStrings): TBroadcastTransactionsResponse;
var
  ARequest: TBroadcastTransactionsRequest;
begin
  if not TInputValidator.IsArrayOfAttachedTrytes(ATrytes.ToStringArray) then
    raise Exception.Create(INVALID_ATTACHED_TRYTES_INPUT_ERROR);

  ARequest:= TBroadcastTransactionsRequest.Create(FRESTClient, ATrytes);
  try
    Result := ARequest.Execute<TBroadcastTransactionsResponse>;
  finally
    ARequest.Free;
  end;
end;

function TIotaAPICore.StoreTransactions(ATrytes: TStrings): TStoreTransactionsResponse;
var
  ARequest: TStoreTransactionsRequest;
begin
  if not TInputValidator.IsArrayOfAttachedTrytes(ATrytes.ToStringArray) then
    raise Exception.Create(INVALID_ATTACHED_TRYTES_INPUT_ERROR);

  ARequest:= TStoreTransactionsRequest.Create(FRESTClient, ATrytes);
  try
    Result := ARequest.Execute<TStoreTransactionsResponse>;
  finally
    ARequest.Free;
  end;
end;

end.
