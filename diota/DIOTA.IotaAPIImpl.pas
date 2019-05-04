unit DIOTA.IotaAPIImpl;

interface

uses
  System.Classes,
  Generics.Collections,
  DIOTA.IotaAPI,
  DIOTA.IotaAPICoreImpl,
  DIOTA.IotaLocalPow,
  DIOTA.Pow.ICurl,
  DIOTA.Model.Bundle,
  DIOTA.Model.Transaction,
  DIOTA.Model.Input,
  DIOTA.Model.Transfer,
  DIOTA.Dto.Response.GetNewAddressesResponse,
  DIOTA.Dto.Response.GetTransfersResponse,
  DIOTA.Dto.Response.BroadcastTransactionsResponse,
  DIOTA.Dto.Response.GetBalancesAndFormatResponse,
  DIOTA.Dto.Response.GetBundleResponse,
  DIOTA.Dto.Response.GetAccountDataResponse,
  DIOTA.Dto.Response.ReplayBundleResponse,
  DIOTA.Dto.Response.GetInclusionStatesResponse,
  DIOTA.Dto.Response.SendTransferResponse;

type
  TIotaAPI = class(TIotaAPICore, IIotaAPI)
  private
    FCustomCurl: ICurl;
    function IsAboveMaxDepth(AAttachmentTimestamp: Int64): Boolean;
  public
    constructor Create(ABuilder: IIotaAPIBuilder); reintroduce; virtual;
    function GetNewAddress(const ASeed: String; const ASecurity: Integer; AIndex: Integer; AChecksum: Boolean; ATotal: Integer; AReturnAll: Boolean): TGetNewAddressesResponse; deprecated;
    function GetNextAvailableAddress(ASeed: String; ASecurity: Integer; AChecksum: Boolean): TGetNewAddressesResponse; overload;
    function GetNextAvailableAddress(ASeed: String; ASecurity: Integer; AChecksum: Boolean; AIndex: Integer): TGetNewAddressesResponse; overload;
    function GenerateNewAddresses(ASeed: String; ASecurity: Integer; AChecksum: Boolean; AAmount: Integer): TGetNewAddressesResponse; overload;
    function GenerateNewAddresses(ASeed: String; ASecurity: Integer; AChecksum: Boolean; AIndex: Integer; AAmount: Integer): TGetNewAddressesResponse; overload;
    function GenerateNewAddresses(ASeed: String; ASecurity: Integer; AChecksum: Boolean; AIndex: Integer; AAmount: Integer; AAddSpendAddresses: Boolean): TGetNewAddressesResponse; overload;
    function GetAddressesUnchecked(ASeed: String; ASecurity: Integer; AChecksum: Boolean; AIndex: Integer; AAmount: Integer): TGetNewAddressesResponse;
    function GetTransfers(ASeed: String; ASecurity: Integer; AStart: Integer; AEnd: Integer; AInclusionStates: Boolean): TGetTransfersResponse;
    function BundlesFromAddresses(AAddresses: TStrings; AInclusionStates: Boolean): TArray<IBundle>;
    function StoreAndBroadcast(ATrytes: TStrings): TBroadcastTransactionsResponse;
    function SendTrytes(ATrytes: TStrings; ADepth: Integer; AMinWeightMagnitude: Integer; AReference: String): TList<ITransaction>;
    function FindTransactionsObjectsByHashes(AHashes: TStrings): TList<ITransaction>;
    function FindTransactionObjectsByAddresses(AAddresses: TStrings): TList<ITransaction>;
    function FindTransactionObjectsByTag(ATags: TStrings): TList<ITransaction>;
    function FindTransactionObjectsByApprovees(AApprovees: TStrings): TList<ITransaction>;
    function FindTransactionObjectsByBundle(ABundles: TStrings): TList<ITransaction>;
    function PrepareTransfers(ASeed: String; ASecurity: Integer; ATransfers: TList<ITransfer>; ARemainder: String;
                              AInputs: TList<IInput>; ATips: TList<ITransaction>; AValidateInputs: Boolean): TStringList;
    function GetInputs(ASeed: String; ASecurity: Integer; AStart: Integer; AEnd: Integer; AThreshold: Int64; const ATips: TStrings): TGetBalancesAndFormatResponse;
    function GetBalanceAndFormat(AAddresses: TStrings; ATips: TStrings; AThreshold: Int64; AStart: Integer; ASecurity: Integer): TGetBalancesAndFormatResponse;
    function GetBundle(ATransaction: String): TGetBundleResponse;
    function GetAccountData(ASeed: String; ASecurity: Integer; AIndex: Integer; AChecksum: Boolean; ATotal: Integer; AReturnAll: Boolean; AStart: Integer; AEnd: Integer;
                            AInclusionStates: Boolean; AThreshold: Int64): TGetAccountDataResponse;
    function CheckWereAddressSpentFrom(AAddresses: TStrings): TArray<Boolean>; overload;
    function CheckWereAddressSpentFrom(AAddress: String): Boolean; overload;
    function ReplayBundle(ATailTransactionHash: String; ADepth: Integer; AMinWeightMagnitude: Integer; AReference: String): TReplayBundleResponse;
    function GetLatestInclusion(AHashes: TStrings): TGetInclusionStatesResponse;
    function SendTransfer(ASeed: String; ASecurity: Integer; ADepth: Integer; AMinWeightMagnitude: Integer; ATransfers: TList<ITransfer>; AInputs: TList<IInput>;
                          ARemainderAddress: String; AValidateInputs: Boolean; AValidateInputAddresses: Boolean; ATips: TList<ITransaction>): TSendTransferResponse;
    function TraverseBundle(ATrunkTx: String; ABundleHash: String; ABundle: IBundle): IBundle;
    function InitiateTransfer(ASecuritySum: Integer; AInputAddress: String; ARemainderAddress: String; const ATransfers: TList<ITransfer>): TList<ITransaction>; overload;
    function InitiateTransfer(ASecuritySum: Integer; AInputAddress: String; ARemainderAddress: String; const ATransfers: TList<ITransfer>; ATips: TList<ITransaction>): TList<ITransaction>; overload;
    function InitiateTransfer(ASecuritySum: Integer; AInputAddress: String; ARemainderAddress: String; ATransfers: TList<ITransfer>; ATestMode: Boolean): TList<ITransaction>; overload;
    function InitiateTransfer(ASecuritySum: Integer; AInputAddress: String; ARemainderAddress: String; ATransfers: TList<ITransfer>; ATips: TList<ITransaction>; ATestMode: Boolean): TList<ITransaction>; overload;
    procedure ValidateTransfersAddresses(ASeed: String; ASecurity: Integer; ATrytes: TStrings);
    function AddRemainder(ASeed: String; ASecurity: Integer; AInputs: TList<IInput>; ABundle: IBundle; ATag: String; ATotalValue: Int64; ARemainderAddress: String;
                          ASignatureFragments: TStrings): TStringList;
    function IsPromotable(ATail: ITransaction): Boolean; overload;
    function IsPromotable(ATail: String): Boolean; overload;
    function PromoteTransaction(ATail: String; ADepth: Integer; AMinWeightMagnitude: Integer; ABundle: IBundle): TList<ITransaction>;
  end;

  TIotaAPIBuilder = class(TIotaAPICoreBuilder, IIotaAPIBuilder)
  private
    FCustomCurl: ICurl;
  public
    constructor Create; virtual;
    function Protocol(AProtocol: String): IIotaAPIBuilder;
    function Host(AHost: String): IIotaAPIBuilder;
    function Port(APort: Integer): IIotaAPIBuilder;
    function Timeout(ATimeout: Integer): IIotaAPIBuilder;
    function LocalPow(ALocalPow: IIotaLocalPow): IIotaAPIBuilder;
    function WithCustomCurl(ACurl: ICurl): IIotaAPIBuilder;
    function Build: IIotaAPI;
    function GetCustomCurl: ICurl;
  end;

implementation

uses
  System.SysUtils,
  System.Math,
  System.DateUtils,
  System.Threading,
  DIOTA.Pow.SpongeFactory,
  DIOTA.Utils.Constants,
  DIOTA.Utils.InputValidator,
  DIOTA.Utils.BundleValidator,
  DIOTA.Utils.IotaAPIUtils,
  DIOTA.Utils.Checksum,
  DIOTA.Dto.Response.FindTransactionsResponse,
  DIOTA.Dto.Response.GetTransactionsToApproveResponse,
  DIOTA.Dto.Response.AttachToTangleResponse,
  DIOTA.Dto.Response.GetTrytesResponse,
  DIOTA.Dto.Response.GetBalancesResponse,
  DIOTA.Dto.Response.WereAddressesSpentFromResponse,
  DIOTA.Dto.Response.GetNodeInfoResponse,
  DIOTA.Dto.Response.CheckConsistencyResponse;

{ TIotaAPIBuilder }

constructor TIotaAPIBuilder.Create;
begin
  FCustomCurl := TSpongeFactory.Create(TSpongeFactory.Mode.KERL);
  FTimeout := 5000;
end;

function TIotaAPIBuilder.Protocol(AProtocol: String): IIotaAPIBuilder;
begin
  Result := inherited Protocol(AProtocol) as IIotaAPIBuilder;
end;

function TIotaAPIBuilder.Host(AHost: String): IIotaAPIBuilder;
begin
  Result := inherited Host(AHost) as IIotaAPIBuilder;
end;

function TIotaAPIBuilder.Port(APort: Integer): IIotaAPIBuilder;
begin
  Result := inherited Port(APort) as IIotaAPIBuilder;
end;

function TIotaAPIBuilder.Timeout(ATimeout: Integer): IIotaAPIBuilder;
begin
  Result := inherited Timeout(ATimeout) as IIotaAPIBuilder;
end;

function TIotaAPIBuilder.LocalPow(ALocalPow: IIotaLocalPow): IIotaAPIBuilder;
begin
  Result := inherited LocalPow(ALocalPow) as IIotaAPIBuilder;
end;

function TIotaAPIBuilder.WithCustomCurl(ACurl: ICurl): IIotaAPIBuilder;
begin
  FCustomCurl := ACurl;
  Result := Self;
end;

function TIotaAPIBuilder.Build: IIotaAPI;
begin
  Result := TIotaAPI.Create(Self);
end;

function TIotaAPIBuilder.GetCustomCurl: ICurl;
begin
  Result := FCustomCurl;
end;

{ TIotaAPI }

constructor TIotaAPI.Create(ABuilder: IIotaAPIBuilder);
begin
  inherited Create(ABuilder);
  FCustomCurl := ABuilder.GetCustomCurl;
end;

function TIotaAPI.GetNewAddress(const ASeed: String; const ASecurity: Integer; AIndex: Integer; AChecksum: Boolean; ATotal: Integer; AReturnAll: Boolean): TGetNewAddressesResponse;
begin
  // If total number of addresses to generate is supplied, simply generate
  // and return the list of all addresses
  if ATotal <> 0 then
    Result := GetAddressesUnchecked(ASeed, ASecurity, AChecksum, AIndex, ATotal)
  else
    // If !returnAll return only the last address that was generated
    Result := GenerateNewAddresses(ASeed, ASecurity, AChecksum, AIndex, 1, AReturnAll);
end;

function TIotaAPI.GetNextAvailableAddress(ASeed: String; ASecurity: Integer; AChecksum: Boolean): TGetNewAddressesResponse;
begin
  Result := GenerateNewAddresses(ASeed, ASecurity, AChecksum, 0, 1, False);
end;

function TIotaAPI.GetNextAvailableAddress(ASeed: String; ASecurity: Integer; AChecksum: Boolean; AIndex: Integer): TGetNewAddressesResponse;
begin
  Result := GenerateNewAddresses(ASeed, ASecurity, AChecksum, AIndex, 1, False);
end;

function TIotaAPI.GenerateNewAddresses(ASeed: String; ASecurity: Integer; AChecksum: Boolean; AAmount: Integer): TGetNewAddressesResponse;
begin
  Result := GenerateNewAddresses(ASeed, ASecurity, AChecksum, 0, AAmount, False);
end;

function TIotaAPI.GenerateNewAddresses(ASeed: String; ASecurity: Integer; AChecksum: Boolean; AIndex, AAmount: Integer): TGetNewAddressesResponse;
begin
  Result := GenerateNewAddresses(ASeed, ASecurity, AChecksum, 0, AAmount, False);
end;

function TIotaAPI.GenerateNewAddresses(ASeed: String; ASecurity: Integer; AChecksum: Boolean; AIndex, AAmount: Integer; AAddSpendAddresses: Boolean): TGetNewAddressesResponse;
var
  AllAddresses: TStringList;
  i: Integer;
  ANumUnspentFound: Integer;
  ANewAddressList: TStringList;
  ANewAddress: String;
  AResponse: TFindTransactionsResponse;
begin
  if not TInputValidator.IsValidSeed(ASeed) then
    raise Exception.Create(INVALID_SEED_INPUT_ERROR);

  if not TInputValidator.IsValidSecurityLevel(ASecurity) then
    raise Exception.Create(INVALID_SECURITY_LEVEL_INPUT_ERROR);

  if (AIndex + AAmount) < 0 then
    raise Exception.Create(INVALID_INPUT_ERROR);

  AllAddresses := TStringList.Create;
  ANewAddressList := TStringList.Create;
  try
    ANumUnspentFound := 0;
    i := AIndex;
    while ANumUnspentFound < AAmount do
      begin
        ANewAddress := TIotaAPIUtils.NewAddress(ASeed, ASecurity, i, AChecksum, FCustomCurl.Clone);

        if AChecksum then
          ANewAddressList.Text := ANewAddress
        else
          ANewAddressList.Text := TChecksum.AddChecksum(ANewAddress);

        AResponse := FindTransactionsByAddresses(ANewAddressList);
        try
          if AResponse.HashesCount = 0 then
            begin
              //Unspent address, if we ask for 0, we dont need to add it
              if AAmount <> 0 then
                AllAddresses.Add(ANewAddress);
              Inc(ANumUnspentFound);
            end
          else
          if AAddSpendAddresses then
            //Spend address, were interested anyways
            AllAddresses.Add(ANewAddress);
        finally
          AResponse.Free;
        end;

        Inc(i);
      end;

    Result := TGetNewAddressesResponse.Create(AllAddresses.ToStringArray);
  finally
    ANewAddressList.Free;
    AllAddresses.Free;
  end;
end;

function TIotaAPI.GetAddressesUnchecked(ASeed: String; ASecurity: Integer; AChecksum: Boolean; AIndex, AAmount: Integer): TGetNewAddressesResponse;
var
  AllAddresses: TStringList;
  i: Integer;
begin
  if not TInputValidator.IsValidSeed(ASeed) then
    raise Exception.Create(INVALID_SEED_INPUT_ERROR);

  AllAddresses := TStringList.Create;
  try
    for i := AIndex to AIndex + AAmount - 1 do
      AllAddresses.Add(TIOTAAPIUtils.NewAddress(ASeed, ASecurity, i, AChecksum, FCustomCurl.Clone));
    Result := TGetNewAddressesResponse.Create(AllAddresses.ToStringArray);
  finally
    AllAddresses.Free;
  end;
end;

function TIotaAPI.GetTransfers(ASeed: String; ASecurity, AStart, AEnd: Integer; AInclusionStates: Boolean): TGetTransfersResponse;
var
  AGnr: TGetNewAddressesResponse;
  ABundles: TArray<IBundle>;
  AAddressesList: TStringList;
begin
  // validate seed
  if not TInputValidator.IsValidSeed(ASeed) then
    raise Exception.Create(INVALID_SEED_INPUT_ERROR);

  if (AStart < 0) or (AStart > AEnd) or (AEnd > (AStart + 500)) then
    raise Exception.Create(INVALID_INPUT_ERROR);

  if not TInputValidator.IsValidSecurityLevel(ASecurity) then
    raise Exception.Create(INVALID_SECURITY_LEVEL_INPUT_ERROR);

  AGnr := GetNewAddress(ASeed, ASecurity, AStart, True, AEnd, True);
  if Assigned(AGnr) and (AGnr.AddressesCount > 0) then
    begin
      AAddressesList := AGnr.AddressesList;
      try
        ABundles := BundlesFromAddresses(AAddressesList, AInclusionStates);
      finally
        AAddressesList.Free;
      end;
      Result := TGetTransfersResponse.Create(ABundles);
    end
  else
    Result := TGetTransfersResponse.Create([]);
end;

function TIotaAPI.BundlesFromAddresses(AAddresses: TStrings; AInclusionStates: Boolean): TArray<IBundle>;
var
  ATrxs: TList<ITransaction>;
  ATailTransactions: TStringList;
  ANonTailBundleHashes: TStringList;
  ATrx: ITransaction;
  ABundleObjects: TList<ITransaction>;
  AThreadFinalBundles: TThreadList<IBundle>;
  AFinalBundles: TList<IBundle>;
  AGisr: TGetInclusionStatesResponse;
  AFinalInclusionStates: TGetInclusionStatesResponse;
  j: Integer;
begin
  ATailTransactions := TStringList.Create;
  ANonTailBundleHashes := TStringList.Create;
  AThreadFinalBundles := TThreadList<IBundle>.Create;
  try
    ATrxs := FindTransactionObjectsByAddresses(AAddresses);
    try
      for ATrx in ATrxs do
        // Sort tail and nonTails
        if ATrx.CurrentIndex = 0 then
          ATailTransactions.Add(ATrx.Hash)
        else
        if ANonTailBundleHashes.IndexOf(ATrx.Bundle) < 0 then
          ANonTailBundleHashes.Add(ATrx.Bundle);
    finally
      ATrxs.Free;
    end;

    ABundleObjects := FindTransactionObjectsByBundle(ANonTailBundleHashes);
    try
      for ATrx in ABundleObjects do
        // Sort tail and nonTails
        if (ATrx.CurrentIndex = 0) and (ATailTransactions.IndexOf(ATrx.Hash) < 0) then
          ATailTransactions.Add(ATrx.Hash);
    finally
      ABundleObjects.Free;
    end;

    // If inclusionStates, get the confirmation status
    // of the tail transactions, and thus the bundles
    AGisr := nil;
    if (ATailTransactions.Count > 0) and AInclusionStates then
      begin
        AGisr := GetLatestInclusion(ATailTransactions);
        if (not Assigned(AGisr)) or (AGisr.StatesCount = 0) then
          raise Exception.Create(GET_INCLUSION_STATE_RESPONSE_ERROR);
      end;

    AFinalInclusionStates := AGisr;
    TParallel.For(0, ATailTransactions.Count - 1,
      procedure(i: Integer)
      var
        ABundleResponse: TGetBundleResponse;
        AGbr: IBundle;
        ABundleList: TList<ITransaction>;
        AThisInclusion: Boolean;
        ATransaction: ITransaction;
      begin
        //try
          ABundleResponse := GetBundle(ATailTransactions[i]);
          ABundleList := ABundleResponse.TransactionsList;
          try
            with TBundleBuilder.Create do
              begin
                AGbr := SetTransactions(ABundleList.ToArray).Build;
                Free;
              end;
            if AGbr.Transactions.Count > 0 then
              begin
                if AInclusionStates then
                  begin
                    if Assigned(AFinalInclusionStates) then
                      AThisInclusion := AFinalInclusionStates.States[i]
                    else
                      AThisInclusion := False;
                    for ATransaction in AGbr.Transactions do
                      ATransaction.SetPersistence(AThisInclusion);
                  end;
                AThreadFinalBundles.Add(AGbr);
              end;
          finally
            ABundleList.Free;
            ABundleResponse.Free;
          end;

        //except
          //log.warn(Constants.GET_BUNDLE_RESPONSE_ERROR);
        //end;
      end);

    AFinalBundles := AThreadFinalBundles.LockList;
    try
      AFinalBundles.Sort;
      SetLength(Result, AFinalBundles.Count);
      for j := 0 to AFinalBundles.Count - 1 do
        with TBundleBuilder.Create do
          begin
            Result[j] := SetTransactions(AFinalBundles[j].Transactions.ToArray).Build;
            Free;
          end;
    finally
      AThreadFinalBundles.UnLockList;
    end;
  finally
    ATailTransactions.Free;
    ANonTailBundleHashes.Free;
    AThreadFinalBundles.Free;
  end;
end;

function TIotaAPI.StoreAndBroadcast(ATrytes: TStrings): TBroadcastTransactionsResponse;
begin
  if not TInputValidator.IsArrayOfAttachedTrytes(ATrytes.ToStringArray) then
    raise Exception.Create(INVALID_TRYTES_INPUT_ERROR);

  StoreTransactions(ATrytes).Free;
  Result := BroadcastTransactions(ATrytes);
end;

function TIotaAPI.SendTrytes(ATrytes: TStrings; ADepth, AMinWeightMagnitude: Integer; AReference: String): TList<ITransaction>;
var
  ATxs: TGetTransactionsToApproveResponse;
  ARes: TAttachToTangleResponse;
  AResTrytes: TStringList;
  i: Integer;
  AResSB: TBroadcastTransactionsResponse;
begin
  Result := TList<ITransaction>.Create;

  ATxs := GetTransactionsToApprove(ADepth, AReference);
  try
    // attach to tangle - do pow
    ARes := AttachToTangle(ATxs.TrunkTransaction, ATxs.BranchTransaction, AMinWeightMagnitude, ATrytes);
    AResTrytes := ARes.TrytesList;
    try
      AResSB := StoreAndBroadcast(AResTrytes);
      try
        for i := 0 to ARes.TrytesCount - 1 do
          with TTransactionBuilder.Create do
            try
              Result.Add(FromTrytes(ARes.Trytes[i]).Build);
            finally
              Free;
            end;
      finally
        AResSB.Free;
      end;
    finally
      AResTrytes.Free;
      ARes.Free;
    end;
  finally
    ATxs.Free;
  end;
end;

function TIotaAPI.FindTransactionsObjectsByHashes(AHashes: TStrings): TList<ITransaction>;
var
  ATrytesResponse: TGetTrytesResponse;
  i: Integer;
begin
  if not TInputValidator.IsArrayOfHashes(AHashes.ToStringArray) then
    raise Exception.Create(INVALID_HASHES_INPUT_ERROR);

  ATrytesResponse := GetTrytes(AHashes);
  try
    Result := TList<ITransaction>.Create;
    for i := 0 to ATrytesResponse.TrytesCount - 1 do
      with TTransactionBuilder.Create do
        try
          Result.Add(FromTrytes(ATrytesResponse.Trytes[i]).Build);
        finally
          Free;
        end;
  finally
    ATrytesResponse.Free;
  end;
end;

function TIotaAPI.FindTransactionObjectsByAddresses(AAddresses: TStrings): TList<ITransaction>;
var
  AFtr: TFindTransactionsResponse;
  AHashesList: TStringList;
begin
  AFtr := FindTransactionsByAddresses(AAddresses);
  try
    if (not Assigned(AFtr)) or (AFtr.HashesCount = 0) then
      Result := TList<ITransaction>.Create
    else
      // get the transaction objects of the transactions
      begin
        AHashesList := AFtr.HashesList;
        try
          Result := FindTransactionsObjectsByHashes(AHashesList);
        finally
          AHashesList.Free;
        end;
      end;
  finally
    AFtr.Free;
  end;
end;

function TIotaAPI.FindTransactionObjectsByTag(ATags: TStrings): TList<ITransaction>;
var
  AFtr: TFindTransactionsResponse;
  AHashesList: TStringList;
begin
  AFtr := FindTransactionsByDigests(ATags);
  try
    if (not Assigned(AFtr)) or (AFtr.HashesCount = 0) then
      Result := TList<ITransaction>.Create
    else
      // get the transaction objects of the transactions
      begin
        AHashesList := AFtr.HashesList;
        try
          Result := FindTransactionsObjectsByHashes(AHashesList);
        finally
          AHashesList.Free;
        end;
      end;
  finally
    AFtr.Free;
  end;
end;

function TIotaAPI.FindTransactionObjectsByApprovees(AApprovees: TStrings): TList<ITransaction>;
var
  AFtr: TFindTransactionsResponse;
  AHashesList: TStringList;
begin
  AFtr := FindTransactionsByApprovees(AApprovees);
  try
    if (not Assigned(AFtr)) or (AFtr.HashesCount = 0) then
      Result := TList<ITransaction>.Create
    else
      // get the transaction objects of the transactions
      begin
        AHashesList := AFtr.HashesList;
        try
          Result := FindTransactionsObjectsByHashes(AHashesList);
        finally
          AHashesList.Free;
        end;
      end;
  finally
    AFtr.Free;
  end;
end;

function TIotaAPI.FindTransactionObjectsByBundle(ABundles: TStrings): TList<ITransaction>;
var
  AFtr: TFindTransactionsResponse;
  AHashesList: TStringList;
begin
  AFtr := FindTransactionsByBundles(ABundles);
  try
    if (not Assigned(AFtr)) or (AFtr.HashesCount = 0) then
      Result := TList<ITransaction>.Create
    else
      // get the transaction objects of the transactions
      begin
        AHashesList := AFtr.HashesList;
        try
          Result := FindTransactionsObjectsByHashes(AHashesList);
        finally
          AHashesList.Free;
        end;
      end;
  finally
    AFtr.Free;
  end;
end;

function TIotaAPI.PrepareTransfers(ASeed: String; ASecurity: Integer; ATransfers: TList<ITransfer>; ARemainder: String;
                                   AInputs: TList<IInput>; ATips: TList<ITransaction>; AValidateInputs: Boolean): TStringList;
var
  ABundle: IBundle;
  ASignatureFragments: TStringList;
  ATotalValue: Int64;
  ATag: String;
  ATransfer: ITransfer;
  ASignatureMessageLength: Integer;
  AMsgCopy: String;
  AFragment: String;
  ATimestamp: Int64;
  ANewInputs: TGetBalancesAndFormatResponse;
  AInputsList: TList<IInput>;
  AInputsAddresses: TStringList;
  AInput: IInput;
  ATipHashes: TStringList;
  ATrx: ITransaction;
  ABalancesResponse: TGetBalancesResponse;
  ABalances: TArray<Int64>;
  AConfirmedInputs: TList<IInput>;
  ATotalBalance: Int64;
  i: Integer;
  AThisBalance: Int64;
  ABundleTrytes: TList<String>;
begin
  // validate seed
  if not TInputValidator.IsValidSeed(ASeed) then
    raise Exception.Create(INVALID_SEED_INPUT_ERROR);

  if not TInputValidator.IsValidSecurityLevel(ASecurity) then
    raise Exception.Create(INVALID_SECURITY_LEVEL_INPUT_ERROR);

  if (ARemainder <> '') and (not TInputValidator.CheckAddress(ARemainder)) then
    raise Exception.Create(INVALID_ADDRESSES_INPUT_ERROR);

  // Input validation of transfers object
  if not TInputValidator.IsTransfersCollectionValid(ATransfers) then
    raise Exception.Create(INVALID_TRANSFERS_INPUT_ERROR);

  if Assigned(AInputs) and (not TInputValidator.AreValidInputsList(AInputs)) then
    raise Exception.Create(INVALID_ADDRESSES_INPUT_ERROR);

  Result := nil;

  // Create a new bundle
  ABundle := TBundleBuilder.CreateBundle;
  ASignatureFragments := TStringList.Create;
  try
    ATotalValue := 0;
    ATag := '';

    //  Iterate over all transfers, get totalValue
    //  and prepare the signatureFragments, message and tag
    for ATransfer in ATransfers do
      begin
        // remove the checksum of the address
        ATransfer.Address := TChecksum.RemoveChecksum(ATransfer.Address);

        ASignatureMessageLength := 1;

        // If message longer than 2187 trytes, increase signatureMessageLength (add 2nd transaction)
        if Length(ATransfer.Message) > MESSAGE_LENGTH then
          begin
            // Get total length, message / maxLength (2187 trytes)
            ASignatureMessageLength := ASignatureMessageLength + Floor(Length(ATransfer.Message) / MESSAGE_LENGTH);

            AMsgCopy := ATransfer.Message;

            // While there is still a message, copy it
            while AMsgCopy <> '' do
              begin
                AFragment := Copy(AMsgCopy, 1, MESSAGE_LENGTH);
                AMsgCopy := Copy(AMsgCopy, MESSAGE_LENGTH + 1, Length(AMsgCopy));

                // Pad remainder of fragment
                AFragment := AFragment.PadRight(MESSAGE_LENGTH, '9');

                ASignatureFragments.Add(AFragment);
              end;
          end
        else
          begin
            // Else, get single fragment with 2187 of 9's trytes
            AFragment := ATransfer.Message;

            if Length(AFragment) < MESSAGE_LENGTH then
              AFragment := AFragment.PadRight(MESSAGE_LENGTH, '9');

            ASignatureFragments.Add(AFragment);
          end;

        ATag := ATransfer.Tag;

        // pad for required 27 tryte length
        if Length(ATag) < TAG_LENGTH then
          ATag := ATag.PadRight(TAG_LENGTH, '9');

        // get current timestamp in seconds
        ATimestamp := DateTimeToUnix(TTimeZone.Local.ToUniversalTime(Now));//SecondsBetween(, 0);

        // Add first entry to the bundle
        ABundle.AddEntry(ASignatureMessageLength, ATransfer.Address, ATransfer.Value, ATag, ATimestamp);

        // Sum up total value
        ATotalValue := ATotalValue + ATransfer.Value;
      end;

    // Get inputs if we are sending tokens
    if ATotalValue <> 0 then
      begin
        for ATransfer in ATransfers do
          if not TInputValidator.HasTrailingZeroTrit(ATransfer.Address) then
            raise Exception.Create(INVALID_ADDRESSES_INPUT_ERROR);

        //  Case 1: user provided inputs
        //  Validate the inputs by calling getBalances
        if Assigned(AInputs) and (AInputs.Count > 0) then
          begin
            if not AValidateInputs then
              begin
                Result := AddRemainder(ASeed, ASecurity, AInputs, ABundle, ATag, ATotalValue, ARemainder, ASignatureFragments);
                Exit;
              end;

            // Get list of addresses of the provided inputs
            AInputsAddresses := TStringList.Create;
            try
              for AInput in AInputs do
                AInputsAddresses.Add(AInput.Address);

              if Assigned(ATips) then
                begin
                  ATipHashes := TStringList.Create;
                  try
                    for ATrx in ATips do
                      ATipHashes.Add(ATrx.Hash);
                  finally
                    ATipHashes.Free;
                  end;
                end
              else
                ATipHashes := nil;

              ABalancesResponse := GetBalances(100, AInputsAddresses, ATipHashes);
              AConfirmedInputs := TList<IInput>.Create;
              try
                ABalances := ABalancesResponse.BalancesArray;
                ATotalBalance := 0;
                for i := 0 to High(ABalances) do
                  begin
                    AThisBalance := ABalances[i];
                    // If input has balance, add it to confirmedInputs
                    if AThisBalance > 0 then
                      begin
                        ATotalBalance := ATotalBalance + AThisBalance;
                        AInputs[i].Balance := AThisBalance;
                        AConfirmedInputs.Add(AInputs[i]);

                        // if we've already reached the intended input value, break out of loop
                        if ATotalBalance >= ATotalValue then
                          Break;
                      end;
                  end;
                // Return not enough balance error
                if ATotalValue > ATotalBalance then
                  raise Exception.Create(NOT_ENOUGH_BALANCE_ERROR);

                Result := AddRemainder(ASeed, ASecurity, AConfirmedInputs, ABundle, ATag, ATotalValue, ARemainder, ASignatureFragments);
              finally
                AConfirmedInputs.Free;
                ABalancesResponse.Free;
              end;
            finally
              AInputsAddresses.Free;
            end;
          end
        else
        //  Case 2: Get inputs deterministically
        //
        //  If no inputs provided, derive the addresses from the seed and
        //  confirm that the inputs exceed the threshold
          begin
            ANewInputs := GetInputs(ASeed, ASecurity, 0, 0, ATotalValue, nil);
            AInputsList := ANewInputs.InputsList;
            try
              // If inputs with enough balance
              Result := AddRemainder(ASeed, ASecurity, AInputsList, ABundle, ATag, ATotalValue, ARemainder, ASignatureFragments);
            finally
              AInputsList.Free;
              ANewInputs.Free;
            end;
          end;
      end
    else
      begin
        // If no input required, don't sign and simply finalize the bundle
        ABundle.Finalize(FCustomCurl.Clone);
        ABundle.AddTrytes(ASignatureFragments);

        ABundleTrytes := TList<String>.Create;
        try
          for ATrx in ABundle.Transactions do
            ABundleTrytes.Add(ATrx.ToTrytes);
          ABundleTrytes.Reverse;
          Result := TStringList.Create;
          for i := 0 to ABundleTrytes.Count - 1 do
            Result.Add(ABundleTrytes[i]);
        finally
          ABundleTrytes.Free;
        end;
      end;
  finally
    ASignatureFragments.Free;
  end;
end;

function TIotaAPI.GetInputs(ASeed: String; ASecurity, AStart, AEnd: Integer; AThreshold: Int64; const ATips: TStrings): TGetBalancesAndFormatResponse;
var
  AAllAddresses: TStringList;
  i: Integer;
  AAddress: String;
  ARes: TGetNewAddressesResponse;
  AResAddresses: TStringList;
begin
  // validate the seed
  if not TInputValidator.IsValidSeed(ASeed) then
    raise Exception.Create(INVALID_SEED_INPUT_ERROR);

  if not TInputValidator.IsValidSecurityLevel(ASecurity) then
    raise Exception.Create(INVALID_SECURITY_LEVEL_INPUT_ERROR);

  // If start value bigger than end, return error
  // or if difference between end and start is bigger than 500 keys
  if (AStart < 0) or (AStart > AEnd) or (AEnd > (AStart + 500)) then
    raise Exception.Create(INVALID_INPUT_ERROR);

  //  Case 1: start and end
  //
  //  If start and end is defined by the user, simply iterate through the keys
  //  and call getBalances
  if AEnd <> 0 then
    begin
      AAllAddresses := TStringList.Create;
      try
        for i := AStart to AEnd - 1 do
          begin
            AAddress := TIotaAPIUtils.NewAddress(ASeed, ASecurity, i, True, FCustomCurl.Clone);
            AAllAddresses.Add(AAddress);
          end;
        Result := GetBalanceAndFormat(AAllAddresses, ATips, AThreshold, AStart, ASecurity);
      finally
        AAllAddresses.Free;
      end;
    end
  else
    //  Case 2: iterate till threshold or till end
    //
    //  Either start from index: 0 or start (if defined) until threshold is reached.
    //  Calls getNewAddress and deterministically generates and returns all addresses
    //  We then do getBalance, format the output and return it
    begin
      ARes := GenerateNewAddresses(ASeed, ASecurity, True, AStart, AThreshold, True);
      AResAddresses := ARes.AddressesList;
      try
        Result := GetBalanceAndFormat(AResAddresses, ATips, AThreshold, AStart, ASecurity);
      finally
        AResAddresses.Free;
        ARes.Free;
      end;
    end;
end;

function TIotaAPI.GetBalanceAndFormat(AAddresses, ATips: TStrings; AThreshold: Int64; AStart, ASecurity: Integer): TGetBalancesAndFormatResponse;
var
  ARes: TGetBalancesResponse;
  ABalances: TList<Int64>;
  AThresholdReached: Boolean;
  ATotalBalance: Int64;
  AInputs: TList<IInput>;
  i: Integer;
  ABalance: Int64;
begin
  if not TInputValidator.IsValidSecurityLevel(ASecurity) then
    raise Exception.Create(INVALID_SECURITY_LEVEL_INPUT_ERROR);

  ARes := GetBalances(100, AAddresses, ATips);
  ABalances := ARes.BalancesList;
  try
    // If threshold defined, keep track of whether reached or not
    // else set default to true
    AThresholdReached := AThreshold = 0;
    ATotalBalance := 0;

    AInputs := TList<IInput>.Create;
    try
      for i := 0 to AAddresses.Count - 1 do
        begin
          ABalance := ABalances[i];
          if ABalance > 0 then
            begin
              AInputs.Add(TInputBuilder.CreateInput(AAddresses[i], ABalance, AStart + i, ASecurity));
              // Increase totalBalance of all aggregated inputs
              ATotalBalance := ATotalBalance + ABalance;

              if (not AThresholdReached) and (ATotalBalance >= AThreshold) then
                begin
                  AThresholdReached := True;
                  Break;
                end;
            end;
        end;

      if AThresholdReached then
        Result := TGetBalancesAndFormatResponse.Create(AInputs.ToArray, ATotalBalance)
      else
        begin
          Result := nil;
          raise Exception.Create(NOT_ENOUGH_BALANCE_ERROR);
        end;
    finally
      AInputs.Free;
    end;
  finally
    ABalances.Free;
    ARes.Free;
  end;
end;

function TIotaAPI.GetBundle(ATransaction: String): TGetBundleResponse;
var
  ABundle: IBundle;
begin
  if not TInputValidator.isHash(ATransaction) then
    raise Exception.Create(INVALID_HASHES_INPUT_ERROR);

  ABundle := TraverseBundle(ATransaction, '', TBundleBuilder.CreateBundle);
  if not Assigned(ABundle) then
    raise Exception.Create(INVALID_BUNDLE_ERROR);

  if not TBundleValidator.IsBundle(ABundle) then
    raise Exception.Create(INVALID_BUNDLE_ERROR);

  Result := TGetBundleResponse.Create(ABundle.Transactions.ToArray);
end;

function TIotaAPI.GetAccountData(ASeed: String; ASecurity, AIndex: Integer; AChecksum: Boolean; ATotal: Integer; AReturnAll: Boolean; AStart,
                                 AEnd: Integer; AInclusionStates: Boolean; AThreshold: Int64): TGetAccountDataResponse;
var
  AGna: TGetNewAddressesResponse;
  AGtr: TGetTransfersResponse;
  AGbr: TGetBalancesAndFormatResponse;
begin
  if not TInputValidator.IsValidSecurityLevel(ASecurity) then
    raise Exception.Create(INVALID_SECURITY_LEVEL_INPUT_ERROR);

  if (AStart < 0) or (AStart > AEnd) or (AEnd > (AStart + 1000)) then
    raise Exception.Create(INVALID_INPUT_ERROR);

  AGna := GetNewAddress(ASeed, ASecurity, AIndex, AChecksum, ATotal, AReturnAll);
  AGtr := GetTransfers(ASeed, ASecurity, AStart, AEnd, AInclusionStates);
  AGbr := GetInputs(ASeed, ASecurity, AStart, AEnd, AThreshold, nil);
  try
    Result := TGetAccountDataResponse.Create(AGna.AddressesArray, AGtr.TransfersArray, AGbr.InputsArray, AGbr.TotalBalance);
  finally
    AGbr.Free;
    AGtr.Free;
    AGna.Free;
  end;
end;

function TIotaAPI.CheckWereAddressSpentFrom(AAddresses: TStrings): TArray<Boolean>;
var
  ARes: TWereAddressesSpentFromResponse;
begin
  ARes := WereAddressesSpentFrom(AAddresses);
  try
    Result := ARes.StatesArray;
  finally
    ARes.Free;
  end;
end;

function TIotaAPI.CheckWereAddressSpentFrom(AAddress: String): Boolean;
var
  ASpentAddresses: TStringList;
begin
  ASpentAddresses := TStringList.Create;
  try
    ASpentAddresses.Add(AAddress);
    Result := CheckWereAddressSpentFrom(ASpentAddresses)[0];
  finally
    ASpentAddresses.Free;
  end;
end;

function TIotaAPI.ReplayBundle(ATailTransactionHash: String; ADepth, AMinWeightMagnitude: Integer; AReference: String): TReplayBundleResponse;
var
  i: Integer;
  ABundleResponse: TGetBundleResponse;
  ABundleTrytesList: TList<String>;
  ATransactionsList: TList<ITransaction>;
  ATrx: ITransaction;
  ATrxs: TList<ITransaction>;
  ABundleTrytes: TStringList;
  ASuccessful: TArray<Boolean>;
  ARes: TFindTransactionsResponse;
  ABundleList: TStringList;
begin
  if not TInputValidator.IsHash(ATailTransactionHash) then
    raise Exception.Create(INVALID_TAIL_HASH_INPUT_ERROR);

  ABundleTrytesList := TList<String>.Create;
  try
    ABundleResponse := GetBundle(ATailTransactionHash);
    ATransactionsList := ABundleResponse.TransactionsList;
    try
      for ATrx in ATransactionsList do
        ABundleTrytesList.Add(ATrx.ToTrytes);
      ABundleTrytesList.Reverse;

      ABundleTrytes := TStringList.Create;
      try
        for i := 0 to ABundleTrytesList.Count - 1 do
          ABundleTrytes.Add(ABundleTrytesList[i]);

        ATrxs := SendTrytes(ABundleTrytes, ADepth, AMinWeightMagnitude, AReference);
        try
          SetLength(ASuccessful, ATrxs.Count);
          for i := 0 to ATrxs.Count - 1 do
            begin
              ABundleList := TStringList.Create;
              ABundleList.Add(ATrxs[i].Bundle);
              ARes := FindTransactionsByBundles(ABundleList);
              try
                ASuccessful[i] := ARes.HashesCount > 0;
              finally
                ARes.Free;
                ABundleList.Free;
              end;
            end;
        finally
          ATrxs.Free;
        end;

        Result := TReplayBundleResponse.Create(ASuccessful);
      finally
        ABundleTrytes.Free;
      end;
    finally
      ATransactionsList.Free;
      ABundleResponse.Free;
    end;
  finally
    ABundleTrytesList.Free;
  end;
end;

function TIotaAPI.GetLatestInclusion(AHashes: TStrings): TGetInclusionStatesResponse;
var
  AGetNodeInfoResponse: TGetNodeInfoResponse;
  ALatestMilestone: TStringList;
begin
  AGetNodeInfoResponse := GetNodeInfo;
  ALatestMilestone := TStringList.Create;
  try
    ALatestMilestone.Add(AGetNodeInfoResponse.LatestSolidSubtangleMilestone);
    Result := GetInclusionStates(AHashes, ALatestMilestone);
  finally
    ALatestMilestone.Free;
    AGetNodeInfoResponse.Free;
  end;
end;

function TIotaAPI.SendTransfer(ASeed: String; ASecurity, ADepth, AMinWeightMagnitude: Integer; ATransfers: TList<ITransfer>; AInputs: TList<IInput>; ARemainderAddress: String;
                               AValidateInputs, AValidateInputAddresses: Boolean; ATips: TList<ITransaction>): TSendTransferResponse;
var
  ATrytes: TStringList;
  AReference: String;
  ATrxs: TList<ITransaction>;
  ASuccessful: TArray<Boolean>;
  i: Integer;
  ARes: TFindTransactionsResponse;
  ABundleList: TStringList;
begin
  ATrytes := PrepareTransfers(ASeed, ASecurity, ATransfers, ARemainderAddress, AInputs, ATips, AValidateInputs);
  try
    if AValidateInputAddresses then
      ValidateTransfersAddresses(ASeed, ASecurity, ATrytes);

    if Assigned(ATips) and (ATips.Count > 0) then
      AReference := ATips[0].Hash
    else
      AReference := '';

    ATrxs := SendTrytes(ATrytes, ADepth, AMinWeightMagnitude, AReference);
    try
      SetLength(ASuccessful, ATrxs.Count);
      for i := 0 to ATrxs.Count - 1 do
        begin
          ABundleList := TStringList.Create;
          try
            ABundleList.Add(ATrxs[i].Bundle);
            ARes := FindTransactionsByBundles(ABundleList);
            try
              ASuccessful[i] := ARes.HashesCount > 0;
            finally
              ARes.Free;
            end;
          finally
            ABundleList.Free;
          end;
        end;

      Result := TSendTransferResponse.Create(ATrxs.ToArray, ASuccessful);
    finally
      ATrxs.Free;
    end;
  finally
    ATrytes.Free;
  end;
end;

function TIotaAPI.TraverseBundle(ATrunkTx, ABundleHash: String; ABundle: IBundle): IBundle;
var
  AGtr: TGetTrytesResponse;
  AHashes: TStringList;
  ATrx: ITransaction;
  AHash: String;
  ANewTrunkTx: String;
begin
  Result := nil;
  AHash := ABundleHash;

  AHashes := TStringList.Create;
  try
    AHashes.Add(ATrunkTx);
    AGtr := GetTrytes(AHashes);
    if Assigned(AGtr) then
      try
        if AGtr.TrytesCount = 0 then
          raise Exception.Create(INVALID_BUNDLE_ERROR);

        with TTransactionBuilder.Create do
          try
            ATrx := FromTrytes(AGtr.Trytes[0]).Build;
          finally
            Free;
          end;

        if ATrx.Bundle = '' then
          raise Exception.Create(INVALID_TRYTES_INPUT_ERROR);

        // If first transaction to search is not a tail, return error
        if (AHash = '') and (ATrx.CurrentIndex <> 0) then
          raise Exception.Create(INVALID_TAIL_HASH_INPUT_ERROR);

        // If no bundle hash, define it
        if AHash = '' then
          AHash := ATrx.Bundle;

        // If different bundle hash, return with bundle
        if AHash <> ATrx.Bundle then
          Result := ABundle
        else
        // If only one bundle element, return
        if (ATrx.LastIndex = 0) and (ATrx.CurrentIndex = 0) then
          Result := TBundleBuilder.CreateBundle([ATrx])
        else
          begin
            // Define new trunkTransaction for search
            ANewTrunkTx := ATrx.TrunkTransaction;

            // Add transaction object to bundle
            ABundle.Transactions.Add(ATrx);

            // Continue traversing with new trunkTx
            Result := TraverseBundle(ANewTrunkTx, AHash, ABundle);
          end;
      finally
        AGtr.Free;
      end
    else
      raise Exception.Create(GET_TRYTES_RESPONSE_ERROR);
  finally
    AHashes.Free;
  end;
end;

function TIotaAPI.InitiateTransfer(ASecuritySum: Integer; AInputAddress, ARemainderAddress: String; const ATransfers: TList<ITransfer>): TList<ITransaction>;
begin
  Result := InitiateTransfer(ASecuritySum, AInputAddress, ARemainderAddress, ATransfers, nil, False);
end;

function TIotaAPI.InitiateTransfer(ASecuritySum: Integer; AInputAddress, ARemainderAddress: String; const ATransfers: TList<ITransfer>; ATips: TList<ITransaction>): TList<ITransaction>;
begin
  Result := InitiateTransfer(ASecuritySum, AInputAddress, ARemainderAddress, ATransfers, ATips, False);
end;

function TIotaAPI.InitiateTransfer(ASecuritySum: Integer; AInputAddress, ARemainderAddress: String; ATransfers: TList<ITransfer>; ATestMode: Boolean): TList<ITransaction>;
begin
  Result := InitiateTransfer(ASecuritySum, AInputAddress, ARemainderAddress, ATransfers, nil, ATestMode);
end;

function TIotaAPI.InitiateTransfer(ASecuritySum: Integer; AInputAddress, ARemainderAddress: String; ATransfers: TList<ITransfer>; ATips: TList<ITransaction>; ATestMode: Boolean): TList<ITransaction>;
var
  ABundle: IBundle;
  ATotalValue: Int64;
  ASignatureFragments: TStringList;
  ATag: String;
  ATransfer: ITransfer;
  ASignatureMessageLength: Integer;
  AMsgCopy: String;
  AFragment: String;
  ATimestamp: Int64;
  ATipHashes: TStringList;
  ABalancesResponse: TGetBalancesResponse;
  ATx: ITransaction;
  AInputAddressList: TStringList;
  ATotalBalance: Int64;
  i: Integer;
begin
  if ASecuritySum < MIN_SECURITY_LEVEL then
    raise Exception.Create(INVALID_SECURITY_LEVEL_INPUT_ERROR);

  // validate input address
  if not TInputValidator.IsAddress(AInputAddress) then
    raise Exception.Create(INVALID_ADDRESSES_INPUT_ERROR);

  // validate remainder address
  if (ARemainderAddress <> '') and (not TInputValidator.IsAddress(ARemainderAddress)) then
    raise Exception.Create(INVALID_ADDRESSES_INPUT_ERROR);

  // Input validation of transfers object
  if not TInputValidator.IsTransfersCollectionValid(ATransfers) then
    raise Exception.Create(INVALID_TRANSFERS_INPUT_ERROR);

  // Create a new bundle
  ABundle := TBundleBuilder.CreateBundle;
  ASignatureFragments := TStringList.Create;
  try
    ATotalValue := 0;
    ATag := '';

    //  Iterate over all transfers, get totalValue
    //  and prepare the signatureFragments, message and tag
    for ATransfer in ATransfers do
      begin
        // remove the checksum of the address
        ATransfer.Address := TChecksum.RemoveChecksum(ATransfer.Address);

        ASignatureMessageLength := 1;

        // If message longer than 2187 trytes, increase signatureMessageLength (add next transaction)
        if Length(ATransfer.Message) > MESSAGE_LENGTH then
          begin
            // Get total length, message / maxLength (2187 trytes)
            ASignatureMessageLength := ASignatureMessageLength + Floor(Length(ATransfer.Message) / MESSAGE_LENGTH);

            AMsgCopy := ATransfer.Message;

            // While there is still a message, copy it
            while AMsgCopy <> '' do
              begin
                AFragment := Copy(AMsgCopy, 1, MESSAGE_LENGTH);
                AMsgCopy := Copy(AMsgCopy, MESSAGE_LENGTH + 1, Length(AMsgCopy));

                 // Pad remainder of fragment
                 AFragment := AFragment.PadRight(MESSAGE_LENGTH, '9');

                 ASignatureFragments.Add(AFragment);
              end;
          end
        else
          begin
            // Else, get single fragment with 2187 of 9's trytes
            AFragment := ATransfer.Message;
            if Length(ATransfer.Message) < MESSAGE_LENGTH then
              AFragment := AFragment.PadRight(MESSAGE_LENGTH, '9');
          end;

        ATag := ATransfer.Tag;

        // pad for required 27 tryte length
        if Length(ATransfer.Tag) < TAG_LENGTH then
          ATag := ATag.PadRight(TAG_LENGTH, '9');

        // get current timestamp in seconds
        ATimestamp := DateTimeToUnix(TTimeZone.Local.ToUniversalTime(Now));

        // Add first entry to the bundle
        ABundle.AddEntry(ASignatureMessageLength, ATransfer.Address, ATransfer.Value, ATag, ATimestamp);
        // Sum up total value
        ATotalValue := ATotalValue + ATransfer.Value;
      end;

    // Get inputs if we are sending tokens
    if ATotalValue <> 0 then
      begin
        for ATransfer in ATransfers do
          if not TInputValidator.HasTrailingZeroTrit(ATransfer.Address) then
            raise Exception.Create(INVALID_ADDRESSES_INPUT_ERROR);

        AInputAddressList := TStringList.Create;
        try
          AInputAddressList.Add(AInputAddress);
          if Assigned(ATips) then
            begin
              ATipHashes := TStringList.Create;
              try
                for ATx in ATips do
                  ATipHashes.Add(ATx.Hash);
                ABalancesResponse := GetBalances(100, AInputAddressList, ATipHashes);
              finally
                ATipHashes.Free;
              end
            end
          else
            ABalancesResponse := GetBalances(100, AInputAddressList, nil);
        finally
          AInputAddressList.Free;
        end;

        ATotalBalance := 0;
        try
          for i := 0 to ABalancesResponse.BalancesCount - 1 do
            ATotalBalance := ATotalBalance + ABalancesResponse.Balances[i];
        finally
          ABalancesResponse.Free;
        end;

        // get current timestamp in seconds
        ATimestamp := DateTimeToUnix(TTimeZone.Local.ToUniversalTime(Now));

        // bypass the balance checks during unit testing
        //TODO: remove this uglyness
        if ATestMode then
          ATotalBalance := ATotalBalance + 1000;

        if ATotalBalance > 0 then
          // Add input as bundle entry
          // Only a single entry, signatures will be added later
          ABundle.AddEntry(ASecuritySum, TChecksum.RemoveChecksum(AInputAddress), -ATotalBalance, ATag, ATimestamp);

        // Return not enough balance error
        if ATotalValue > ATotalBalance then
          raise Exception.Create(NOT_ENOUGH_BALANCE_ERROR);

        // If there is a remainder value
        // Add extra output to send remaining funds to
        if ATotalBalance > ATotalValue then
          begin
            // Remainder bundle entry if necessary
            if ARemainderAddress = '' then
              raise Exception.Create(NO_REMAINDER_ADDRESS_ERROR);

            ABundle.AddEntry(1, ARemainderAddress, ATotalBalance - ATotalValue, ATag, ATimestamp);
          end;

        ABundle.Finalize(TSpongeFactory.Create(TSpongeFactory.Mode.CURLP81));
        ABundle.AddTrytes(ASignatureFragments);
        Result := TList<ITransaction>.Create;
        for i := 0 to ABundle.Transactions.Count - 1 do
          Result.Add(ABundle.Transactions[i]);
      end
    else
      raise Exception.Create(INVALID_VALUE_TRANSFER_ERROR);
  finally
    ASignatureFragments.Free;
  end;
end;

procedure TIotaAPI.ValidateTransfersAddresses(ASeed: String; ASecurity: Integer; ATrytes: TStrings);
var
  ATrxStr: String;
  ATransaction: ITransaction;
  AInputTransactions: TList<ITransaction>;
  AAddresses: TStringList;
  AInputAddresses: TStringList;
  ARes: TFindTransactionsResponse;
  AHashes: TStringList;
  ATransactions: TList<ITransaction>;
  AGna: TGetNewAddressesResponse;
  AGbr: TGetBalancesAndFormatResponse;
  AInput: IInput;
  AGnaAddresses: TStringList;
begin
  AInputTransactions := TList<ITransaction>.Create;
  AAddresses := TStringList.Create;
  AInputAddresses := TStringList.Create;
  try
    for ATrxStr in ATrytes do
      begin
        with TTransactionBuilder.Create do
          try
            ATransaction := FromTrytes(ATrxStr).Build;
          finally
            Free;
          end;
        AAddresses.Add(TChecksum.AddChecksum(ATransaction.Address));
        AInputTransactions.Add(ATransaction);
      end;

    ARes := FindTransactionsByAddresses(AAddresses);
    try
      if ARes.HashesCount > 0 then
        begin
          AHashes := ARes.HashesList;
          try
            ATransactions := FindTransactionsObjectsByHashes(AHashes);
            try
              AGna := GenerateNewAddresses(ASeed, ASecurity, True, 0, 0, False);
              AGnaAddresses := AGna.AddressesList;
              try
                AGbr := GeTInputs(ASeed, ASecurity, 0, 0, 0, nil);
                try
                  for AInput in AGbr.InputsArray do
                    AInputAddresses.Add(TChecksum.AddChecksum(AInput.Address));

                  //check if send to input
                  for ATransaction in AInputTransactions do
                    if ATransaction.Value > 0 then
                      if AInputAddresses.IndexOf(ATransaction.Address) >= 0 then
                        raise Exception.Create(SEND_TO_INPUTS_ERROR)
                      else
                      if not TInputValidator.HasTrailingZeroTrit(ATransaction.Address) then
                        raise Exception.Create(INVALID_ADDRESSES_INPUT_ERROR);

                  for ATransaction in ATransactions do
                    begin
                      //check if destination address is already in use
                      if (ATransaction.Value < 0) and (AInputAddresses.IndexOf(ATransaction.Address) < 0) then
                        raise Exception.Create(SENDING_TO_USED_ADDRESS_ERROR);

                      //check if key reuse
                      if (ATransaction.Value < 0) and (AGnaAddresses.IndexOf(ATransaction.Address) >= 0) then
                        raise Exception.Create(PRIVATE_KEY_REUSE_ERROR);
                    end;
                finally
                  AGbr.Free;
                end;
              finally
                AGnaAddresses.Free;
                AGna.Free;
              end;
            finally
              ATransactions.Free;
            end;
          finally
            AHashes.Free;
          end;
        end;
    finally
      ARes.Free;
    end;
  finally
    AInputTransactions.Free;
    AAddresses.Free;
    AInputAddresses.Free;
  end;
end;

function TIotaAPI.AddRemainder(ASeed: String; ASecurity: Integer; AInputs: TList<IInput>; ABundle: IBundle; ATag: String; ATotalValue: Int64; ARemainderAddress: String;
                               ASignatureFragments: TStrings): TStringList;
var
  ATotalTransferValue: Int64;
  i: Integer;
  AThisBalance: Int64;
  ATimestamp: Int64;
  ARemainder: Int64;
  ARes: TGetNewAddressesResponse;
begin
  // validate seed
  if not TInputValidator.IsValidSeed(ASeed) then
    raise Exception.Create(INVALID_SEED_INPUT_ERROR);

  if (ARemainderAddress <> '') and (not TInputValidator.CheckAddress(ARemainderAddress)) then
    raise Exception.Create(INVALID_ADDRESSES_INPUT_ERROR);

  if not TInputValidator.IsValidSecurityLevel(ASecurity) then
    raise Exception.Create(INVALID_SECURITY_LEVEL_INPUT_ERROR);

  if not TInputValidator.AreValidInputsList(AInputs) then
    raise Exception.Create(INVALID_INPUT_ERROR);

  ATotalTransferValue := ATotalValue;
  for i := 0 to AInputs.Count - 1 do
    begin
      AThisBalance := AInputs[i].Balance;
      ATimestamp := DateTimeToUnix(TTimeZone.Local.ToUniversalTime(Now));

      // Add input as bundle entry
      ABundle.AddEntry(ASecurity, TChecksum.RemoveChecksum(AInputs[i].Address), -AThisBalance, ATag, ATimestamp);
      // If there is a remainder value
      // Add extra output to send remaining funds to
      if AThisBalance >= ATotalTransferValue then
        begin
          ARemainder := AThisBalance - ATotalTransferValue;

          // If user has provided remainder address
          // Use it to send remaining funds to
          if (ARemainder > 0) and (ARemainderAddress <> '') then
            // Remainder bundle entry
            ABundle.AddEntry(1, TChecksum.RemoveChecksum(ARemainderAddress), ARemainder, ATag, ATimestamp)
          else
          if ARemainder > 0 then
            // Generate a new Address by calling getNewAddress
            begin
              ARes := GetNextAvailableAddress(ASeed, ASecurity, False);
              // Remainder bundle entry
              ABundle.AddEntry(1, ARes.Addresses[0], ARemainder, ATag, ATimestamp);
            end;

          // Final function for signing inputs
          Result := TIotaAPIUtils.SignInputsAndReturn(ASeed, AInputs, ABundle, ASignatureFragments, FCustomCurl.Clone);
          Exit;
        end
      else
        // If multiple inputs provided, subtract the totalTransferValue by
        // the inputs balance
        ATotalTransferValue := ATotalTransferValue - AThisBalance;
    end;

  raise Exception.Create(NOT_ENOUGH_BALANCE_ERROR);
end;

function TIotaAPI.IsPromotable(ATail: ITransaction): Boolean;
var
  AConsistencyResponse: TCheckConsistencyResponse;
  ALowerBound: Int64;
  ATails: TStringList;
begin
  ALowerBound := ATail.AttachmentTimestamp;
  ATails := TStringList.Create;
  try
    ATails.Add(ATail.Hash);
    AConsistencyResponse := CheckConsistency(ATails);
    try
      Result := AConsistencyResponse.State and IsAboveMaxDepth(ALowerBound);
    finally
      AConsistencyResponse.Free;
    end;
  finally
    ATails.Free;
  end;
end;

function TIotaAPI.IsPromotable(ATail: String): Boolean;
var
  ATransaction: TGetTrytesResponse;
  AHashes: TStringList;
  ATrx: ITransaction;
begin
  Result := False;
  AHashes := TStringList.Create;
  try
    AHashes.Add(ATail);
    ATransaction := GetTrytes(AHashes);
    try
      if ATransaction.TrytesCount = 0 then
        raise Exception.Create(TRANSACTION_NOT_FOUND);

      with TTransactionBuilder.Create do
        try
          ATrx := FromTrytes(ATransaction.Trytes[0]).Build;
        finally
          Free;
        end;

      Result := IsPromotable(ATrx);
    finally
      ATransaction.Free;
    end;
  finally
    AHashes.Free;
  end;
end;

function TIotaAPI.IsAboveMaxDepth(AAttachmentTimestamp: Int64): Boolean;
begin
  // Check against future timestamps
  Result := (AAttachmentTimestamp < DateTimeToUnix(TTimeZone.Local.ToUniversalTime(Now))) and
      {
       * Check if transaction wasn't issued before last 6 milestones
       * Without a coo, technically there is no limit for promotion on the network.
       * But old transactions are less likely to be selected in tipselection
       * This means that the higher maxdepth, the lower the use of promoting is.
       * 6 was picked by means of "observing" nodes for their most popular depth, and 6 was the "edge" of popularity.
       *
       * Milestones are being issued every ~2mins
       *
       * The 11 is  calculated like this:
       * 6 milestones is the limit, so 5 milestones are used, each 2 minutes each totaling 10 minutes.
       * Add 1 minute delay for propagating through the network of nodes.
       *
       * That's why its 11 and not 10 or 12 (*60*1000)
      }
      ((DateTimeToUnix(TTimeZone.Local.ToUniversalTime(Now)) - AAttachmentTimestamp) < 11 * 60 * 1000);
end;

function TIotaAPI.PromoteTransaction(ATail: String; ADepth, AMinWeightMagnitude: Integer; ABundle: IBundle): TList<ITransaction>;
var
  AConsistencyResponse: TCheckConsistencyResponse;
  ATransactionsToApprove: TGetTransactionsToApproveResponse;
  ARes: TAttachToTangleResponse;
  ATrytes: TStringList;
  ATrx: ITransaction;
  ATrytesList: TStringList;
  i: Integer;
  ATails: TStringList;
begin
  if (not Assigned(ABundle)) or (ABundle.Transactions.Count = 0) then
    raise Exception.Create(EMPTY_BUNDLE_ERROR);

  if ADepth < 0 then
    raise Exception.Create(INVALID_DEPTH_ERROR);

  if AMinWeightMagnitude <= 0 then
    raise Exception.Create(INVALID_WEIGHT_MAGNITUDE_ERROR);

  ATails := TStringList.Create;
  try
    ATails.Add(ATail);
    AConsistencyResponse := CheckConsistency(ATails);
    try
      if not AConsistencyResponse.State then
        raise Exception.Create(AConsistencyResponse.Info);
    finally
      AConsistencyResponse.Free;
    end;
  finally
    ATails.Free;
  end;

  ATransactionsToApprove := GetTransactionsToApprove(ADepth, ATail);
  ATrytes := TStringList.Create;
  try
    for ATrx in ABundle.Transactions do
      ATrytes.Add(ATrx.ToTrytes);
    ARes := AttachToTangle(ATransactionsToApprove.TrunkTransaction, ATransactionsToApprove.BranchTransaction, AMinWeightMagnitude, ATrytes);
    ATrytesList := ARes.TrytesList;
    try try
      StoreAndBroadcast(ATrytesList).Free;
    except
      Result := TList<ITransaction>.Create;
      Exit;
    end;
    finally
      ATrytesList.Free;
      ARes.Free;
    end;

    Result := TList<ITransaction>.Create;
    for i :=  0 to ARes.TrytesCount - 1 do
      begin
        with TTransactionBuilder.Create do
          try
            ATrx := FromTrytes(ARes.Trytes[i]).Build;
          finally
            Free;
          end;
        Result.Add(ATrx);
      end;
  finally
    ATrytes.Free;
    ATransactionsToApprove.Free;
  end;
end;

end.
