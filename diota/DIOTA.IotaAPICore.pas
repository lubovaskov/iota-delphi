unit DIOTA.IotaAPICore;

interface

uses
  System.Classes,
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
  {
   *
   * This class provides access to the Iota core API
   * Handles direct methods with the connected node(s), and does basic verification
   *
  }
  IIotaAPICore = interface
    ['{D998F72E-CC33-48C9-92DD-DC4242BFAE64}']
    function GetProtocol: String;
    function GetHost: String;
    function GetPort: Integer;
    function GetTimeout: Integer;
    {
     * Returns information about this node.
     *
     * @return @link GetNodeInfoResponse
     * @throws ArgumentException
    }
    function GetNodeInfo: TGetNodeInfoResponse;
    {
     * Returns the set of neighbors you are connected with, as well as their activity statistics (or counters).
     * The activity counters are reset after restarting IRI.
     *
     * @return @link GetNeighborsResponse
     * @throws ArgumentException
    }
    function GetNeighbors: TGetNeighborsResponse;
    {
     * Temporarily add a list of neighbors to your node.
     * The added neighbors will not be available after restart.
     * Add the neighbors to your config file
     * or supply them in the <tt>-n</tt> command line option if you want to add them permanently.
     *
     * The URI (Unique Resource Identification) for adding neighbors is:
     * <b>udp://IPADDRESS:PORT</b>
     *
     * @param uris list of neighbors to add
     * @return @link AddNeighborsResponse
     * @throws ArgumentException
    }
    function AddNeighbors(AUris: TStrings): TAddNeighborsResponse;
    {
     * Temporarily removes a list of neighbors from your node.
     * The added neighbors will be added again after relaunching IRI.
     * Remove the neighbors from your config file or make sure you don't supply them in the -n command line option if you want to keep them removed after restart.
     *
     * The URI (Unique Resource Identification) for removing neighbors is:
     * <b>udp://IPADDRESS:PORT</b>
     *
     * @param uris The URIs of the neighbors we want to remove.
     * @return @link RemoveNeighborsResponse
     * @throws ArgumentException
    }
    function RemoveNeighbors(AUris: TStrings): TRemoveNeighborsResponse;
    {
     * Returns all tips currently known by this node.
     *
     * @return @link GetTipsResponse
     * @throws ArgumentException
    }
    function GetTips: TGetTipsResponse;
    {
     * <p>
     * Find the transactions which match the specified input and return.
     * All input values are lists, for which a list of return values (transaction hashes), in the same order, is returned for all individual elements.
     * The input fields can either be <tt>bundles</tt>, <tt>addresses</tt>, <tt>tags</tt> or <tt>approvees</tt>.
     * </p>
     *
     * Using multiple of these input fields returns the intersection of the values.
     * Can error if the node found more transactions than the max transactions send amount
     *
     * @param addresses Array of hashes from addresses, must contain checksums
     * @param tags Array of tags
     * @param approvees Array of transaction hashes
     * @param bundles Array of bundle hashes
     * @return @link FindTransactionResponse
     * @throws ArgumentException
    }
    function FindTransactions(AAddresses: TStrings; ATags: TStrings; AApprovees: TStrings; ABundles: TStrings): TFindTransactionsResponse;
    {
     * Find the transactions by addresses with checksum
     *
     * @param addresses An array of addresses, must contain checksums
     * @return @link FindTransactionResponse
     * @throws ArgumentException
    }
    function FindTransactionsByAddresses(AAddresses: TStrings): TFindTransactionsResponse;
    {
     * Find the transactions by bundles
     *
     * @param bundles An array of bundles.
     * @return @link FindTransactionResponse
     * @throws ArgumentException
    }
    function FindTransactionsByBundles(ABundles: TStrings): TFindTransactionsResponse;
    {
     * Find the transactions by approvees
     *
     * @param approvees An array of approveess.
     * @return @link FindTransactionResponse
     * @throws ArgumentException
    }
    function FindTransactionsByApprovees(AApprovees: TStrings): TFindTransactionsResponse;
    {
     * Find the transactions by tags
     *
     * @param digests A List of tags.
     * @return @link FindTransactionResponse
     * @throws ArgumentException
    }
    function FindTransactionsByDigests(ADigests: TStrings): TFindTransactionsResponse;
    {
     * <p>
     * Get the inclusion states of a set of transactions.
     * This is for determining if a transaction was accepted and confirmed by the network or not.
     * You can search for multiple tips (and thus, milestones) to get past inclusion states of transactions.
     * </p>
     * <p>
     * This API call returns a list of boolean values in the same order as the submitted transactions.
     * Boolean values will be <tt>true</tt> for confirmed transactions, otherwise <tt>false</tt>.
     * </p>
     *
     * @param transactions Array of transactions you want to get the inclusion state for.
     * @param tips Array of tips (including milestones) you want to search for the inclusion state.
     * @return @link GetInclusionStateResponse
     * @throws ArgumentException when a transaction hash is invalid
     * @throws ArgumentException when a tip is invalid
     * @throws ArgumentException
    }
    function GetInclusionStates(ATransactions: TStrings; ATips: TStrings): TGetInclusionStatesResponse;
    {
     * Returns the raw transaction data (trytes) of a specific transaction.
     * These trytes can then be easily converted into the actual transaction object.
     * You can use @link Transaction#Transaction(String) for conversion to an object.
     *
     * @param hashes The transaction hashes you want to get trytes from.
     * @return @link GetTrytesResponse
     * @throws ArgumentException when a transaction hash is invalid
     * @throws ArgumentException
    }
    function GetTrytes(AHashes: TStrings): TGetTrytesResponse;
    {
     * Tip selection which returns <tt>trunkTransaction</tt> and <tt>branchTransaction</tt>.
     * The input value <tt>depth</tt> determines how many milestones to go back for finding the transactions to approve.
     * The higher your <tt>depth</tt> value, the more work you have to do as you are confirming more transactions.
     * If the <tt>depth</tt> is too large (usually above 15, it depends on the node's configuration) an error will be returned.
     * The <tt>reference</tt> is an optional hash of a transaction you want to approve.
     * If it can't be found at the specified <tt>depth</tt> then an error will be returned.
     *
     * @param depth Number of bundles to go back to determine the transactions for approval.
     * @param reference Hash of transaction to start random-walk from.
     *                  This used to make sure the tips returned reference a given transaction in their past.
     *                  Can be <t>null</t>.
     * @return @link GetTransactionsToApproveResponse
     * @throws ArgumentException
    }
    function GetTransactionsToApprove(ADepth: Integer; AReference: String): TGetTransactionsToApproveResponse; overload;
    {
     * Tip selection which returns <tt>trunkTransaction</tt> and <tt>branchTransaction</tt>.
     * The input value <tt>depth</tt> determines how many milestones to go back for finding the transactions to approve.
     * The higher your <tt>depth</tt> value, the more work you have to do as you are confirming more transactions.
     * If the <tt>depth</tt> is too large (usually above 15, it depends on the node's configuration) an error will be returned.
     * The <tt>reference</tt> is an optional hash of a transaction you want to approve.
     * If it can't be found at the specified <tt>depth</tt> then an error will be returned.
     *
     * @param depth Number of bundles to go back to determine the transactions for approval.
     * @return @link GetTransactionsToApproveResponse
    }
    function GetTransactionsToApprove(ADepth: Integer): TGetTransactionsToApproveResponse; overload;
    {
     * <p>
     * Calculates the confirmed balance, as viewed by the latest solid milestone.
     * In addition to the balances, it also returns the referencing <tt>milestone</tt>,
     * and the index with which the confirmed balance was determined.
     * The balances are returned as a list in the same order as the addresses were provided as input.
     * </p>
     *
     * @param threshold The confirmation threshold, should be set to 100.
     * @param addresses The list of addresses you want to get the confirmed balance from. Must contain the checksum.
     * @return @link GetBalancesResponse
     * @throws ArgumentException
    }
    function GetBalances(AThreshold: Integer; AAddresses: TStrings): TGetBalancesResponse; overload;
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
     * @param threshold The confirmation threshold between 0 and 100(inclusive).
     *                  Should be set to 100 for getting balance by counting only confirmed transactions.
     * @param addresses The addresses where we will find the balance for. Must contain the checksum.
     * @param tips The tips to find the balance through. Can be <t>null</t>
     * @return @link GetBalancesResponse
     * @throws ArgumentException The the request was considered wrong in any way by the node
    }
    function GetBalances(AThreshold: Integer; AAddresses: TStrings; ATips: TStrings): TGetBalancesResponse; overload;
    {
     * Check if a list of addresses was ever spent from, in the current epoch, or in previous epochs.
     *
     * @param addresses List of addresses to check if they were ever spent from. Must contain the checksum.
     * @return @link WereAddressesSpentFromResponse
     * @throws ArgumentException when an address is invalid
     * @throws ArgumentException
    }
    function WereAddressesSpentFrom(AAddresses: TStrings): TWereAddressesSpentFromResponse;
    {
     * Checks the consistency of the subtangle formed by the provided tails.
     *
     * @param tails The tails describing the subtangle.
     * @return @link CheckConsistencyResponse
     * @throws ArgumentException when a tail hash is invalid
     * @throws ArgumentException
    }
    function CheckConsistency(ATails: TStrings): TCheckConsistencyResponse;
    {
     * <p>
     * Prepares the specified transactions (trytes) for attachment to the Tangle by doing Proof of Work.
     * You need to supply <tt>branchTransaction</tt> as well as <tt>trunkTransaction</tt>.
     * These are the tips which you're going to validate and reference with this transaction.
     * These are obtainable by the <tt>getTransactionsToApprove</tt> API call.
     * </p>
     * <p>
     * The returned value is a different set of tryte values which you can input into
     * <tt>broadcastTransactions</tt> and <tt>storeTransactions</tt>.
     * </p>
     * The last 243 trytes of the return value consist of the following:
     * <ul>
     * <li><code>trunkTransaction</code></li>
     * <li><code>branchTransaction</code></li>
     * <li><code>nonce</code></li>
     * </ul>
     * These are valid trytes which are then accepted by the network.
     * @param trunkTransaction A reference to an external transaction (tip) used as trunk.
     *                         The transaction with index 0 will have this tip in its trunk.
     *                         All other transactions reference the previous transaction in the bundle (Their index-1).
     *
     * @param branchTransaction A reference to an external transaction (tip) used as branch.
     *                          Each Transaction in the bundle will have this tip as their branch, except the last.
     *                          The last one will have the branch in its trunk.
     * @param minWeightMagnitude The amount of work we should do to confirm this transaction.
     *                           Each 0-trit on the end of the transaction represents 1 magnitude.
     *                           A 9-tryte represents 3 magnitudes, since a 9 is represented by 3 0-trits.
     *                           Transactions with a different minWeightMagnitude are compatible.
     * @param trytes The list of trytes to prepare for network attachment, by doing proof of work.
     * @return @link GetAttachToTangleResponse
     * @throws ArgumentException when a trunk or branch hash is invalid
     * @throws ArgumentException when the provided transaction trytes are invalid
     * @throws ArgumentException
    }
    function AttachToTangle(ATrunkTransaction: String; ABranchTransaction: String; AMinWeightMagnitude: Integer; ATrytes: TStrings): TAttachToTangleResponse;
    {
     * Interrupts and completely aborts the <tt>attachToTangle</tt> process.
     *
     * @return @link InterruptAttachingToTangleResponse
     * @throws ArgumentException
    }
    function InterruptAttachingToTangle: TInterruptAttachingToTangleResponse;
    {
     * Broadcast a list of transactions to all neighbors.
     * The trytes to be used for this call should be valid, attached transaction trytes.
     * These trytes are returned by <tt>attachToTangle</tt>, or by doing proof of work somewhere else.
     *
     * @param trytes The list of transaction trytes to broadcast
     * @return @link BroadcastTransactionsResponse
     * @throws ArgumentException when the provided transaction trytes are invalid
     * @throws ArgumentException
    }
    function BroadcastTransactions(ATrytes: TStrings): TBroadcastTransactionsResponse;
    {
     * Stores transactions in the local storage.
     * The trytes to be used for this call should be valid, attached transaction trytes.
     * These trytes are returned by <tt>attachToTangle</tt>, or by doing proof of work somewhere else.
     *
     * @param trytes Transaction data to be stored.
     * @return @link StoreTransactionsResponse
     * @throws ArgumentException
    }
    function StoreTransactions(ATrytes: TStrings): TStoreTransactionsResponse;
    property Protocol: String read GetProtocol;
    property Host: String read GetHost;
    property Port: Integer read GetPort;
    property Timeout: Integer read GetTimeout;
  end;

  IIotaAPICoreBuilder = interface
    ['{28B2CA46-E6A1-4725-9C52-5FE637D6AB97}']
    function Protocol(AProtocol: String): IIotaAPICoreBuilder;
    function Host(AHost: String): IIotaAPICoreBuilder;
    function Port(APort: Integer): IIotaAPICoreBuilder;
    function Timeout(ATimeout: Integer): IIotaAPICoreBuilder;
    function LocalPow(ALocalPow: IIotaLocalPow): IIotaAPICoreBuilder;
    function Build: IIotaAPICore;
    function GetProtocol: String;
    function GetHost: String;
    function GetPort: Integer;
    function GetTimeout: Integer;
    function GetLocalPow: IIotaLocalPow;
  end;

  function IotaAPICoreBuilder: IIotaAPICoreBuilder;

implementation

uses
  DIOTA.IotaAPICoreImpl;

function IotaAPICoreBuilder: IIotaAPICoreBuilder;
begin
  Result := TIotaAPICoreBuilder.Create;
end;

end.
