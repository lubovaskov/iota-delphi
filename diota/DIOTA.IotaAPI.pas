unit DIOTA.IotaAPI;

interface

uses
  System.Classes,
  Generics.Collections,
  DIOTA.IotaAPICore,
  DIOTA.Pow.ICurl,
  DIOTA.IotaLocalPow,
  DIOTA.Model.Bundle,
  DIOTA.Model.Transaction,
  DIOTA.Model.Transfer,
  DIOTA.Model.Input,
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
  IIotaAPI = interface(IIotaAPICore)
    ['{7AB39A01-7614-4641-9B51-B2D132DBE4B7}']
    {
     * <p>
     * Generates a new address from a seed and returns the remainderAddress.
     * This is either done deterministically, or by providing the index of the new remainderAddress.
     * </p>
     * Deprecated - Use the new functions @link #getNextAvailableAddress, @link #getAddressesUnchecked and @link #generateNewAddresses
     *
     * @param seed      Tryte-encoded seed. It should be noted that this seed is not transferred.
     * @param security  Security level to be used for the private key / address. Can be 1, 2 or 3.
     * @param index     Key index to start search from. If the index is provided, the generation of the address is not deterministic.
     * @param checksum  Adds 9-tryte address checksum. Checksums are required for all API calls.
     * @param total     Total number of addresses to generate.
     * @param returnAll If <code>true</code>, it returns all addresses which were deterministically generated (until findTransactions returns null).
     * @return @link GetNewAddressResponse
     * @throws ArgumentException is thrown when the specified input is not valid.
    }
    function GetNewAddress(const ASeed: String; const ASecurity: Integer; AIndex: Integer; AChecksum: Boolean; ATotal: Integer; AReturnAll: Boolean): TGetNewAddressesResponse; deprecated;
    {
     * Checks all addresses until the first unspent address is found. Starts at index 0.
     * @param seed      Tryte-encoded seed. It should be noted that this seed is not transferred.
     * @param security  Security level to be used for the private key / address. Can be 1, 2 or 3.
     * @param checksum  Adds 9-tryte address checksum. Checksums are required for all API calls.
     * @return @link GetNewAddressResponse
     * @throws ArgumentException When the seed is invalid
     * @throws ArgumentException When the security level is wrong.
    }
    function GetNextAvailableAddress(ASeed: String; ASecurity: Integer; AChecksum: Boolean): TGetNewAddressesResponse; overload;
    {
     * Checks all addresses until the first unspent address is found.
     * @param seed      Tryte-encoded seed. It should be noted that this seed is not transferred.
     * @param security  Security level to be used for the private key / address. Can be 1, 2 or 3.
     * @param checksum  Adds 9-tryte address checksum. Checksums are required for all API calls.
     * @param index     Key index to start search from.
     * @return @link GetNewAddressResponse
     * @throws ArgumentException When the seed is invalid
     * @throws ArgumentException When the security level is wrong.
    }
    function GetNextAvailableAddress(ASeed: String; ASecurity: Integer; AChecksum: Boolean; AIndex: Integer): TGetNewAddressesResponse; overload;
    {
     * Generates new addresses, meaning addresses which were not spend from, according to the connected node.
     * Starts at index 0, untill <code>amount</code> of unspent addresses are found.
     * @param seed      Tryte-encoded seed. It should be noted that this seed is not transferred.
     * @param security  Security level to be used for the private key / address. Can be 1, 2 or 3.
     * @param checksum  Adds 9-tryte address checksum. Checksums are required for all API calls.
     * @param amount    Total number of addresses to generate.
     * @return @link GetNewAddressResponse
     * @throws ArgumentException When the seed is invalid
     * @throws ArgumentException When the security level is wrong.
     * @throws ArgumentException When the amount is negative
    }
    function GenerateNewAddresses(ASeed: String; ASecurity: Integer; AChecksum: Boolean; AAmount: Integer): TGetNewAddressesResponse; overload;
    {
     * Generates new addresses, meaning addresses which were not spend from, according to the connected node.
     * Stops when <code>amount</code> of unspent addresses are found,starting from <code>index</code>
     * @param seed      Tryte-encoded seed. It should be noted that this seed is not transferred.
     * @param security  Security level to be used for the private key / address. Can be 1, 2 or 3.
     * @param checksum  Adds 9-tryte address checksum. Checksums are required for all API calls.
     * @param index     Key index to start search from.
     * @param amount    Total number of addresses to generate.
     * @return @link GetNewAddressResponse
     * @throws ArgumentException When the seed is invalid
     * @throws ArgumentException When the security level is wrong.
     * @throws ArgumentException When index plus the amount are below 0
    }
    function GenerateNewAddresses(ASeed: String; ASecurity: Integer; AChecksum: Boolean; AIndex: Integer; AAmount: Integer): TGetNewAddressesResponse; overload;
    {
     * Generates new addresses, meaning addresses which were not spend from, according to the connected node.
     * Stops when <code>amount</code> of unspent addresses are found,starting from <code>index</code>
     * @param seed      Tryte-encoded seed. It should be noted that this seed is not transferred.
     * @param security  Security level to be used for the private key / address. Can be 1, 2 or 3.
     * @param checksum  Adds 9-tryte address checksum. Checksums are required for all API calls.
     * @param index     Key index to start search from.
     * @param amount    Total number of addresses to generate.
     *                  If this is set to 0, we will generate until the first unspent address is found, and stop.
     *                  If amount is negative, we count back from index.
     * @param addSpendAddresses If <code>true</code>, it returns all addresses, even those who were determined to be spent from
     * @return @link GetNewAddressResponse
     * @throws ArgumentException When the seed is invalid
     * @throws ArgumentException When the security level is wrong.
     * @throws ArgumentException When index plus the amount are below 0
    }
    function GenerateNewAddresses(ASeed: String; ASecurity: Integer; AChecksum: Boolean; AIndex: Integer; AAmount: Integer; AAddSpendAddresses: Boolean): TGetNewAddressesResponse; overload;
    {
     * Generates <code>amount</code> of addresses, starting from <code>index</code>
     * This does not mean that these addresses are safe to use (unspent)
     * @param seed      Tryte-encoded seed. It should be noted that this seed is not transferred.
     * @param security  Security level to be used for the private key / address. Can be 1, 2 or 3.
     * @param checksum  Adds 9-tryte address checksum. Checksums are required for all API calls.
     * @param index     Key index to start search from. The generation of the address is not deterministic.
     * @param amount    Total number of addresses to generate.
     * @return @link GetNewAddressResponse
     * @throws ArgumentException is thrown when the specified input is not valid.
    }
    function GetAddressesUnchecked(ASeed: String; ASecurity: Integer; AChecksum: Boolean; AIndex: Integer; AAmount: Integer): TGetNewAddressesResponse;
    {
     * Finds all the bundles for all the addresses based on this seed and security.
     *
     * @param seed            Tryte-encoded seed. It should be noted that this seed is not transferred.
     * @param security        Security level to be used for the private key / address. Can be 1, 2 or 3.
     * @param start           Starting key index, must be at least 0.
     * @param end             Ending key index, must be bigger then <t>start</t>
     * @param inclusionStates If <code>true</code>, it also gets the inclusion states of the transfers.
     * @return @link GetTransferResponse
     * @throws ArgumentException when <t>start<t> and <t>end<t> are more then 500 apart
     * @throws ArgumentException Invalid security index
     * @throws IllegalStateException When the seed is invalid
    }
    function GetTransfers(ASeed: String; ASecurity: Integer; AStart: Integer; AEnd: Integer; AInclusionStates: Boolean): TGetTransfersResponse;
    {
     * Internal function to get the formatted bundles of a list of addresses.
     *
     * @param addresses       Array of addresses.
     * @param inclusionStates If <code>true</code>, it also gets the inclusion state of each bundle.
     * @return All the transaction bundles for the addresses
     * @throws ArgumentException When the addresses are invalid
     * @throws IllegalStateException When inclusion state/confirmed could not be determined (<t>null</t> returned)
    }
    function BundlesFromAddresses(AAddresses: TStrings; AInclusionStates: Boolean): TArray<IBundle>;
    {
     * Wrapper method: stores and broadcasts the specified trytes.
     *
     * @param trytes The trytes.
     * @return @link BroadcastTransactionsResponse
     * @throws ArgumentException is thrown when the specified <t>trytes</t> is not valid.
     * @throws ArgumentException If @link #storeTransactions(String...) fails
     * @see #storeTransactions(String...)
     * @see #broadcastTransactions(String...)
    }
    function StoreAndBroadcast(ATrytes: TStrings): TBroadcastTransactionsResponse;
    {
     * Wrapper method: Gets transactions to approve, attaches to Tangle, broadcasts and stores.
     *
     * @param trytes             The transaction trytes
     * @param depth              The depth for getting transactions to approve
     * @param minWeightMagnitude The minimum weight magnitude for doing proof of work
     * @param reference          Hash of transaction to start random-walk from
     *                           This is used to make sure the tips returned reference a given transaction in their past.
     *                           This can be <t>null</t>, in that case the latest milestone is used as a reference.
     * @return Sent @link Transaction objects.
     * @throws ArgumentException is thrown when invalid trytes is provided.
     * @see #broadcastTransactions(String...)
     * @see #attachToTangle(String, String, Integer, String...)
     * @see #storeAndBroadcast(String...)
    }
    function SendTrytes(ATrytes: TStrings; ADepth: Integer; AMinWeightMagnitude: Integer; AReference: String): TList<ITransaction>;
    {
     * Wrapper function: get trytes and turns into @link Transaction objects.
     * Gets the trytes and transaction object from a list of transaction hashes.
     *
     * @param hashes The hashes of the transactions we want to get the transactions from
     * @return @link Transaction objects.
     * @throws ArgumentException if hashes is not a valid array of hashes
     * @see #getTrytes(String...)
    }
    function FindTransactionsObjectsByHashes(AHashes: TStrings): TList<ITransaction>;
    {
     * Wrapper function: Finds transactions, gets trytes and turns it into @link Transaction objects.
     *
     * @param addresses The addresses we should get the transactions for, must contain checksums
     * @return @link Transaction objects.
     * @throws ArgumentException if addresses is not a valid array of hashes
     * @see #findTransactionsByAddresses(String...)
     * @see #findTransactionsObjectsByHashes
    }
    function FindTransactionObjectsByAddresses(AAddresses: TStrings): TList<ITransaction>;
    {
     * Wrapper function: Finds transactions, gets trytes and turns it into @link Transaction objects.
     *
     * @param tags The tags the transactions we search for have
     * @return Transactions.
    }
    function FindTransactionObjectsByTag(ATags: TStrings): TList<ITransaction>;
    {
     * Wrapper function: Finds transactions, gets trytes and turns it into @link Transaction objects.
     *
     * @param approvees The transaction hashes of which we want to approvers
     * @return @link Transaction objects.
     * @throws ArgumentException if addresses is not a valid array of hashes
     * @see #findTransactionsByApprovees
    }
    function FindTransactionObjectsByApprovees(AApprovees: TStrings): TList<ITransaction>;
    {
     * Wrapper function: Finds transactions, gets trytes and turns it into @link Transaction objects.
     *
     * @param bundles The bundles for which we will get all its transactions
     * @return @link Transaction objects.
     * @throws ArgumentException if addresses is not a valid array of hashes
     * @see #findTransactionsByBundles
    }
    function FindTransactionObjectsByBundle(ABundles: TStrings): TList<ITransaction>;
    {
     * Prepares transfer by generating bundle, finding and signing inputs.
     *
     * @param seed           The tryte-encoded seed. It should be noted that this seed is not transferred.
     * @param security       Security level to be used for the private key / address. Can be 1, 2 or 3.
     * @param transfers      List of transfer objects.
     *                       If the total value of the transfers is 0, no signing is performed.
     * @param remainder      If defined, this address will be used for sending the remainder value (of the inputs) to.
     *                       Otherwise, then next available address is used (if the transfer value is over 0)
     * @param inputs         The inputs used for this transfer
     * @param tips           The starting points we walk back from to find the balance of the addresses, can be <t>null</t>
     * @param validateInputs Whether or not to validate the balances of the provided inputs
     *                       If no validation is required
     * @return Returns a list of the trytes of each bundle.
     * @throws ArgumentException If the seed is invalid
     * @throws ArgumentException If the security level is wrong.
     * @throws IllegalStateException If the transfers are not all valid
     * @throws IllegalStateException If there is not enough balance in the inputs
    }
    function PrepareTransfers(ASeed: String; ASecurity: Integer; ATransfers: TList<ITransfer>; ARemainder: String;
                              AInputs: TList<IInput>; ATips: TList<ITransaction>; AValidateInputs: Boolean): TStringList;
    {
     * Gets the inputs of a seed
     *
     * @param seed            Tryte-encoded seed. It should be noted that this seed is not transferred.
     * @param security        Security level to be used for the private key / address. Can be 1, 2 or 3.
     * @param start           Starting key index, must be at least 0.
     * @param end             Ending key index, must be bigger then <t>start</t>
     * @param threshold       Minimum balance required.
     * @param tips            The starting points we walk back from to find the balance of the addresses, can be <t>null</t>
     * @return @link GetBalancesAndFormatResponse
     * @throws ArgumentException If the seed is invalid
     * @throws ArgumentException If the security level is wrong.
     * @throws ArgumentException when <t>start<t> and <t>end<t> are more then 500 apart
     * @see #getBalanceAndFormat(List, List, long, int, StopWatch, int)
    }
    function GetInputs(ASeed: String; ASecurity: Integer; AStart: Integer; AEnd: Integer; AThreshold: Int64; const ATips: TStrings): TGetBalancesAndFormatResponse;
    {
     * Gets the balances and formats the output.
     *
     * @param addresses The addresses.
     * @param tips      The starting points we walk back from to find the balance of the addresses, can be <t>null</t>
     * @param threshold Min balance required.
     * @param start     Starting key index.
     * @param stopWatch the stopwatch. If you pass <t>null</t>, a new one is created.
     * @param security  Security level to be used for the private key / address. Can be 1, 2 or 3.
     * @return @link GetBalancesAndFormatResponse
     * @throws ArgumentException is thrown when the specified security level is not valid.
    }
    function GetBalanceAndFormat(AAddresses: TStrings; ATips: TStrings; AThreshold: Int64; AStart: Integer; ASecurity: Integer): TGetBalancesAndFormatResponse;
    {
     * Gets the associated bundle transactions of a single transaction.
     * Does validation of signatures, total sum as well as bundle order.
     *
     * @param transaction The transaction hash
     * @return @link GetBundleResponse
     * @throws ArgumentException if the transaction hash is invalid
     * @throws ArgumentException if the bundle is invalid or not found
    }
    function GetBundle(ATransaction: String): TGetBundleResponse;
    {
     * Similar to getTransfers, just that it returns additional account data
     *
     * @param seed            Tryte-encoded seed. It should be noted that this seed is not transferred.
     * @param security        Security level to be used for the private key / address. Can be 1, 2 or 3.
     * @param index           Key index to start search from. If the index is provided, the generation of the address is not deterministic.
     * @param checksum        Adds 9-tryte address checksum. Checksum is required for all API calls.
     * @param total           Total number of addresses to generate.
     * @param returnAll       If <code>true</code>, it returns all addresses which were deterministically generated (until findTransactions returns null).
     * @param start           Starting key index, must be at least 0.
     * @param end             Ending key index, must be bigger then <t>start</t>
     * @param inclusionStates If <code>true</code>, it gets the inclusion states of the transfers.
     * @param threshold       Minimum balance required.
     * @return @link GetAccountDataResponse
     * @throws ArgumentException when the specified security level is not valid.
     * @throws ArgumentException when <t>start<t> and <t>end<t> are invalid
     * @see #getTransfers(String, int, Integer, Integer, Boolean)
    }
    function GetAccountData(ASeed: String; ASecurity: Integer; AIndex: Integer; AChecksum: Boolean; ATotal: Integer; AReturnAll: Boolean; AStart: Integer; AEnd: Integer;
                            AInclusionStates: Boolean; AThreshold: Int64): TGetAccountDataResponse;
    {
     * Check if a list of addresses was ever spent from, in the current epoch, or in previous epochs.
     * Addresses must have a checksum.
     *
     * @param addresses the addresses to check
     * @return list of address boolean checks
     * @throws ArgumentException when an address is invalid
    }
    function CheckWereAddressSpentFrom(AAddresses: TStrings): TArray<Boolean>; overload;
    {
     * Check if an addresses was ever spent from, in the current epoch, or in previous epochs.
     * Addresses must have a checksum.
     *
     * @param address the address to check
     * @return <t>true</t> if it was spent, otherwise <t>false</t>
     * @throws ArgumentException when the address is invalid
    }
    function CheckWereAddressSpentFrom(AAddress: String): Boolean; overload;
    {
     * Replays a transfer by doing Proof of Work again.
     * This will make a new, but identical transaction which now also can be approved.
     * If any of the replayed transactions gets approved, the others stop getting approved.
     *
     * @param tailTransactionHash The hash of tail transaction.
     * @param depth               The depth for getting transactions to approve
     * @param minWeightMagnitude  The minimum weight magnitude for doing proof of work
     * @param reference           Hash of transaction to start random-walk from.
     *                            This is used to make sure the tips returned reference a given transaction in their past.
     *                            Can be <t>null</t>, in that case the latest milestone is used as a reference.
     * @return @link ReplayBundleResponse
     * @throws ArgumentException when the <t>tailTransactionHash</t> is invalid
     * @throws ArgumentException when the bundle is invalid or not found
     * @see #sendTrytes(String[], int, int, String)
    }
    function ReplayBundle(ATailTransactionHash: String; ADepth: Integer; AMinWeightMagnitude: Integer; AReference: String): TReplayBundleResponse;
    {
     * Wrapper function: runs getNodeInfo and getInclusionStates
     * Uses the latest milestone as tip
     *
     * @param hashes The hashes.
     * @return @link GetInclusionStateResponse
     * @throws ArgumentException when one of the hashes is invalid
     * @see #getNodeInfo()
     * @see #getInclusionStates(String[], String[])
    }
    function GetLatestInclusion(AHashes: TStrings): TGetInclusionStatesResponse;
    {
     * Wrapper function: Runs prepareTransfers, as well as attachToTangle.
     * We then broadcasts this and and store the transactions on the node.
     *
     * @param seed               The tryte-encoded seed. It should be noted that this seed is not transferred.
     * @param security           Security level to be used for the private key / address. Can be 1, 2 or 3.
     * @param depth              The depth for getting transactions to approve
     * @param minWeightMagnitude The minimum weight magnitude for doing proof of work
     * @param transfers          List of @link Transfer objects.
     * @param inputs             List of @link Input used for funding the transfer.
     * @param remainderAddress   If defined, this remainderAddress will be used for sending the remainder value (of the inputs) to.
     *                           When this is not defined, but a remaining exists, the next free address is used.
     * @param validateInputs     Whether or not to validate the balances of the provided inputs.
     * @param validateInputAddresses  Whether or not to validate if the destination address is already use.
     *                                If a key reuse is detect or it's send to inputs.
     * @param tips               The starting points we walk back from to find the balance of the addresses
     *                           If multiple tips are supplied, only the first tip is used for @link #getTransactionsToApprove(Integer, String)
     * @return @link SendTransferResponse
     * @throws ArgumentException If the seed is invalid
     * @throws ArgumentException If the security level is wrong.
     * @throws ArgumentException When <t>validateInputAddresses</t> is </t>true</t>, if validateTransfersAddresses has an error.
     * @throws IllegalStateException If the transfers are not all valid
     * @throws IllegalStateException If there is not enough balance in the inputs to supply to the transfers
     * @see #prepareTransfers(String, int, List, String, List, List, boolean)
     * @see #sendTrytes(String[], int, int, String)
     * @see #validateTransfersAddresses(String, int, List)
    }
    function SendTransfer(ASeed: String; ASecurity: Integer; ADepth: Integer; AMinWeightMagnitude: Integer; ATransfers: TList<ITransfer>; AInputs: TList<IInput>;
                          ARemainderAddress: String; AValidateInputs: Boolean; AValidateInputAddresses: Boolean; ATips: TList<ITransaction>): TSendTransferResponse;
    {
     * Traverses the Bundle by going down the trunkTransactions until the bundle hash of the transaction changes.
     * In case the input transaction hash is not a tail, we return an error.
     *
     * @param trunkTx    Hash of a trunk or a tail transaction of a bundle.
     * @param bundleHash The bundle hash. Should be <t>null</t>, and will use the transactions bundle hash
     * @param bundle     @link Bundle to be populated by traversing.
     * @return Transaction objects.
     * @throws ArgumentException when <t>trunkTx</t> is invalid, or has no transactions
     * @throws ArgumentException when a transaction in the bundle has no reference to the bundle
     * @throws ArgumentException when the first transaction in the bundle is not a tail
    }
    function TraverseBundle(ATrunkTx: String; ABundleHash: String; ABundle: IBundle): IBundle;
    {
     * Prepares transfer by generating the bundle with the corresponding cosigner transactions.
     * Does not contain signatures.
     *
     * @param securitySum      The sum of security levels used by all co-signers.
     * @param inputAddress     Input address with checksum
     * @param remainderAddress Has to be generated by the cosigners before initiating the transfer, can be null if fully spent.
     * @param transfers        List of @link Transfer we want to make using the inputAddress
     * @return All the @link Transaction objects in this newly created transfer
     * @throws ArgumentException when an address is invalid.
     * @throws ArgumentException when the security level is wrong.
     * @throws IllegalStateException when a transfer fails because their is not enough balance to perform the transfer.
     * @throws IllegalStateException When a <t>remainderAddress</t> is required, but not supplied
     * @throws RuntimeException When the total value from the transfers is not 0
    }
    function InitiateTransfer(ASecuritySum: Integer; AInputAddress: String; ARemainderAddress: String; const ATransfers: TList<ITransfer>): TList<ITransaction>; overload;
    {
     * Prepares transfer by generating the bundle with the corresponding cosigner transactions.
     * Does not contain signatures.
     *
     * @param securitySum      The sum of security levels used by all co-signers.
     * @param inputAddress     Input address with checksum
     * @param remainderAddress Has to be generated by the cosigners before initiating the transfer, can be null if fully spent.
     * @param transfers        List of @link Transfer we want to make using the inputAddress
     * @param tips             The starting points for checking if the balance of the input address contains enough to make this transfer
     *                         This can be <t>null</t>
     * @return All the @link Transaction objects in this newly created transfer
     * @throws ArgumentException when an address is invalid.
     * @throws ArgumentException when the security level is wrong.
     * @throws IllegalStateException when a transfer fails because their is not enough balance to perform the transfer.
     * @throws IllegalStateException When a <t>remainderAddress</t> is required, but not supplied
     * @throws RuntimeException When the total value from the transfers is not 0
    }
    function InitiateTransfer(ASecuritySum: Integer; AInputAddress: String; ARemainderAddress: String; const ATransfers: TList<ITransfer>; ATips: TList<ITransaction>): TList<ITransaction>; overload;
    {
     * Prepares transfer by generating the bundle with the corresponding cosigner transactions.
     * Does not contain signatures.
     *
     * @param securitySum      The sum of security levels used by all co-signers.
     * @param inputAddress     Input address with checksum
     * @param remainderAddress Has to be generated by the cosigners before initiating the transfer, can be null if fully spent.
     * @param transfers        List of @link Transfer we want to make using the unputAddresses
     * @param testMode         If were running unit tests, set to true to bypass total value check
     * @return All the @link Transaction objects in this newly created transfer
     * @throws ArgumentException when an address is invalid.
     * @throws ArgumentException when the security level is wrong.
     * @throws IllegalStateException when a transfer fails because their is not enough balance to perform the transfer.
     * @throws IllegalStateException When a <t>remainderAddress</t> is required, but not supplied
     * @throws RuntimeException When the total value from the transfers is not 0
    }
    function InitiateTransfer(ASecuritySum: Integer; AInputAddress: String; ARemainderAddress: String; ATransfers: TList<ITransfer>; ATestMode: Boolean): TList<ITransaction>; overload;
    {
     * Prepares transfer by generating the bundle with the corresponding cosigner transactions.
     * Does not contain signatures.
     *
     * @param securitySum      The sum of security levels used by all co-signers.
     * @param inputAddress     Input address with checksum
     * @param remainderAddress Has to be generated by the cosigners before initiating the transfer, can be null if fully spent.
     * @param transfers        List of @link Transfer we want to make using the unputAddresses
     * @param tips             The starting points for checking if the balance of the input address contains enough to make this transfer
     *                         This can be <t>null</t>
     * @param testMode         If were running unit tests, set to true to bypass total value check
     * @return All the @link Transaction objects in this newly created transfer
     * @throws ArgumentException when an address is invalid.
     * @throws ArgumentException when the security level is wrong.
     * @throws IllegalStateException when a transfer fails because their is not enough balance to perform the transfer.
     * @throws IllegalStateException When a <t>remainderAddress</t> is required, but not supplied
     * @throws RuntimeException When the total value from the transfers is not 0
    }
    function InitiateTransfer(ASecuritySum: Integer; AInputAddress: String; ARemainderAddress: String; ATransfers: TList<ITransfer>; ATips: TList<ITransaction>; ATestMode: Boolean): TList<ITransaction>; overload;
    {
     * <p>
     * Validates the supplied transactions with seed and security.
     * This will check for correct input/output and key reuse
     * </p>
     * <p>
     * In order to do this we will generate all addresses for this seed which are currently in use.
     * Address checksums will be regenerated and these addresses will be looked up, making this an expensive method call.
     * </p>
     * If no error is thrown, the transaction trytes are using correct addresses.
     * This will not validate transaction fields.
     *
     * @param seed     The tryte-encoded seed. It should be noted that this seed is not transferred.
     * @param security Security level to be used for the private key / address. Can be 1, 2 or 3.
     * @param trytes   List of transaction trytes.
     * @throws ArgumentException when we are sending to our own input addresses
     * @throws ArgumentException when we try to remove funds from an address that is not an input
     * @throws ArgumentException when we are sending from an address we have already used for sending
    }
    procedure ValidateTransfersAddresses(ASeed: String; ASecurity: Integer; ATrytes: TStrings);
    {
     * Uses input, and adds to the bundle, untill <t>totalValue</t> is reached.
     * If there is a remainder left on the last input, a remainder transfer is added.
     *
     * @param seed               The tryte-encoded seed. It should be noted that this seed is not transferred.
     * @param security           Security level to be used for the private key / address. Can be 1, 2 or 3.
     * @param inputs             List of inputs used for funding the transfer.
     * @param bundle             The @link Bundle to be populated.
     * @param tag                The tag to add to each bundle entry (input and remainder)
     * @param totalValue         The total value of the desired transaction
     * @param remainderAddress   The address used for sending the remainder value (of the last input).
     *                           If this is <t>null</t>, @link #getNextAvailableAddress(String, int, boolean) is used.
     * @param signatureFragments The signature fragments (message), used for signing.
     *                           Should be 2187 characters long, can be padded with 9s.
     * @return A list of signed inputs to be used in a transaction
     * @throws ArgumentException When the seed is invalid
     * @throws ArgumentException When the security level is wrong.
     * @throws IllegalStateException When the inputs do not contain enough balance to reach </t>totalValue</t>.
     * @see IotaAPIUtils#signInputsAndReturn
     * @see #getNextAvailableAddress(String, int, boolean)
    }
    function AddRemainder(ASeed: String; ASecurity: Integer; AInputs: TList<IInput>; ABundle: IBundle; ATag: String; ATotalValue: Int64; ARemainderAddress: String;
                          ASignatureFragments: TStrings): TStringList;
    {
     * Checks if a transaction hash is promotable
     *
     * @param tail the @link Transaction we want to promote
     * @return <t>true</t> if it is, otherwise <t>false</t>
     * @throws ArgumentException when we can't get the consistency of this transaction
     * @see #checkConsistency(String...)
    }
    function IsPromotable(ATail: ITransaction): Boolean; overload;
    {
     * Checks if a transaction hash is promotable
     *
     * @param tail the @link Transaction hash we want to check
     * @return <t>true</t> if it is, otherwise <t>false</t>
     * @throws ArgumentException when we can't get the consistency of this transaction
     * or when the transaction is not found
     * @see #checkConsistency(String...)
    }
    function IsPromotable(ATail: String): Boolean; overload;
    {
     * Attempts to promote a transaction using a provided bundle and, if successful, returns the promoting Transactions.
     * This is done by creating another transaction which points to the tail.
     * This will effectively double the chances of the transaction to be picked, and this approved.
     *
     * @param tail bundle tail to promote, cannot be <t>null</t>
     * @param depth depth for getTransactionsToApprove
     * @param minWeightMagnitude minWeightMagnitude to use for Proof-of-Work
     * @param bundle the @link Bundle to attach for promotion
     * @return List of the bundle @link Transactions made with the attached transaction trytes
     * @throws ArgumentException When the bundle has no transaction
     * @throws ArgumentException When <t>depth</t> or <t>minWeightMagnitude</t> is lower than 0
     * @throws ArgumentException When the <t>tail</t> hash is invalid
     * @throws NotPromotableException When the transaction is not promotable
     * @see #checkConsistency(String...)
     * @see #getTransactionsToApprove(Integer, String)
     * @see #attachToTangle(String, String, Integer, String...)
     * @see #storeAndBroadcast(String...)
    }
    function PromoteTransaction(ATail: String; ADepth: Integer; AMinWeightMagnitude: Integer; ABundle: IBundle): TList<ITransaction>;
  end;

  IIotaAPIBuilder = interface(IIotaAPICoreBuilder)
    ['{0FD7664D-54ED-45C5-9BB7-248D4B3E99FC}']
    function Protocol(AProtocol: String): IIotaAPIBuilder;
    function Host(AHost: String): IIotaAPIBuilder;
    function Port(APort: Integer): IIotaAPIBuilder;
    function Timeout(ATimeout: Integer): IIotaAPIBuilder;
    function LocalPow(ALocalPow: IIotaLocalPow): IIotaAPIBuilder;
    function WithCustomCurl(ACurl: ICurl): IIotaAPIBuilder;
    function Build: IIotaAPI;
    function GetCustomCurl: ICurl;
  end;

  function IotaAPIBuilder: IIotaAPIBuilder;

implementation

uses
  DIOTA.IotaAPIImpl;

function IotaAPIBuilder: IIotaAPIBuilder;
begin
  Result := TIotaAPIBuilder.Create;
end;

end.
