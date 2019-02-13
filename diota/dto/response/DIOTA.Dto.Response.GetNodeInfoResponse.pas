unit DIOTA.Dto.Response.GetNodeInfoResponse;

interface

uses
  DIOTA.IotaAPIClasses;

type
  TGetNodeInfoResponse = class(TIotaAPIResponse)
  private
    FFeatures: TArray<String>;
    FLatestMilestoneIndex: Integer;
    FJreVersion: String;
    FJreFreeMemory: Int64;
    FTransactionsToRequest: Integer;
    FLatestSolidSubtangleMilestone: String;
    FJreAvailableProcessors: Integer;
    FJreMaxMemory: Int64;
    FTips: Integer;
    FTime: Int64;
    FLatestMilestone: String;
    FPacketsQueueSize: Integer;
    FJreTotalMemory: Int64;
    FNeighbors: Integer;
    FLatestSolidSubtangleMilestoneIndex: Integer;
    FAppVersion: String;
    FAppName: String;
    FMilestoneStartIndex: Integer;
    FCoordinatorAddress: String;
    function GetFeatures(Index: Integer): String;
    function GetFeaturesCount: Integer;
  public
    constructor Create(AAppName: String); reintroduce; overload; virtual;
    constructor Create(AAppName, AAppVersion, AJreVersion: String; AJreAvailableProcessors: Integer; AJreFreeMemory, AJreMaxMemory, AJreTotalMemory: Int64;
                       ALatestMilestone: String; ALatestMilestoneIndex: Integer; ALatestSolidSubtangleMilestone: String; ALatestSolidSubtangleMilestoneIndex: Integer;
                       AMilestoneStartIndex: Integer; ANeighbors, APacketsQueueSize: Integer; ATime: Int64; ATips, ATransactionsToRequest: Integer;
                       AFeatures: TArray<String>; ACoordinatorAddress: String); reintroduce; overload; virtual;
    //Name of the IOTA software you're currently using. (IRI stands for IOTA Reference Implementation)
    property AppName: String read FAppName;
    //The version of the IOTA software this node is running.
    property AppVersion: String read FAppVersion;
    //The JRE version this node runs on
    property JreVersion: String read FJreVersion;
    //Available cores for JRE on this node.
    property JreAvailableProcessors: Integer read FJreAvailableProcessors;
    //The amount of free memory in the Java Virtual Machine.
    property JreFreeMemory: Int64 read FJreFreeMemory;
    //The maximum amount of memory that the Java virtual machine will attempt to use.
    property JreMaxMemory: Int64 read FJreMaxMemory;
    //The total amount of memory in the Java virtual machine.
    property JreTotalMemory: Int64 read FJreTotalMemory;
    //The hash of the latest transaction that was signed off by the coordinator.
    property LatestMilestone: String read FLatestMilestone;
    //Index of the @link #latestMilestone
    property LatestMilestoneIndex: Integer read FLatestMilestoneIndex;
    {
     * The hash of the latest transaction which is solid and is used for sending transactions.
     * For a milestone to become solid, your local node must approve the subtangle of coordinator-approved transactions,
     *  and have a consistent view of all referenced transactions.
    }
    property LatestSolidSubtangleMilestone: String read FLatestSolidSubtangleMilestone;
    //Index of the @link #latestSolidSubtangleMilestone
    property LatestSolidSubtangleMilestoneIndex: Integer read FLatestSolidSubtangleMilestoneIndex;
    //The start index of the milestones.
    //This index is encoded in each milestone transaction by the coordinator
    property MilestoneStartIndex: Integer read FMilestoneStartIndex;
    //Number of neighbors this node is directly connected with.
    property Neighbors: Integer read FNeighbors;
    //The amount of transaction packets which are currently waiting to be broadcast.
    property PacketsQueueSize: Integer read FPacketsQueueSize;
    //The difference, measured in milliseconds, between the current time and midnight, January 1, 1970 UTC
    property Time: Int64 read FTime;
    //Number of tips in the network
    property Tips: Integer read FTips;
    {
     * When a node receives a transaction from one of its neighbors,
     * this transaction is referencing two other transactions t1 and t2 (trunk and branch transaction).
     * If either t1 or t2 (or both) is not in the node's local database,
     * then the transaction hash of t1 (or t2 or both) is added to the queue of the "transactions to request".
     * At some point, the node will process this queue and ask for details about transactions in the
     *  "transaction to request" queue from one of its neighbors.
     * This number represents the amount of "transaction to request"
    }
    property TransactionsToRequest: Integer read FTransactionsToRequest;
    //Every node can have features enabled or disabled.
    //This list will contain all the names of the features of a node as specified in {@link Feature}.
    property Features[Index: Integer]: String read GetFeatures;
    property FeaturesCount: Integer read GetFeaturesCount;
    //The address of the Coordinator being followed by this node.
    property CoordinatorAddress: String read FCoordinatorAddress;
  end;

implementation

{ TGetNodeInfoResponse }

constructor TGetNodeInfoResponse.Create(AAppName, AAppVersion, AJreVersion: String; AJreAvailableProcessors: Integer; AJreFreeMemory,
  AJreMaxMemory, AJreTotalMemory: Int64; ALatestMilestone: String; ALatestMilestoneIndex: Integer; ALatestSolidSubtangleMilestone: String;
  ALatestSolidSubtangleMilestoneIndex, AMilestoneStartIndex, ANeighbors, APacketsQueueSize: Integer; ATime: Int64; ATips, ATransactionsToRequest: Integer;
  AFeatures: TArray<String>; ACoordinatorAddress: String);
begin
  inherited Create;
  FAppName := AAppName;
  FAppVersion := AAppVersion;
  FJreVersion := AJreVersion;
  FJreAvailableProcessors := FJreAvailableProcessors;
  FJreFreeMemory := AJreFreeMemory;
  FJreMaxMemory := AJreMaxMemory;
  FJreTotalMemory := AJreTotalMemory;
  FLatestMilestone := ALatestMilestone;
  FLatestMilestoneIndex := ALatestMilestoneIndex;
  FLatestSolidSubtangleMilestone := ALatestSolidSubtangleMilestone;
  FLatestSolidSubtangleMilestoneIndex := ALatestSolidSubtangleMilestoneIndex;
  FMilestoneStartIndex := AMilestoneStartIndex;
  FNeighbors := ANeighbors;
  FPacketsQueueSize := APacketsQueueSize;
  FTime := ATime;
  FTips := ATips;
  FTransactionsToRequest := ATransactionsToRequest;
  FFeatures := AFeatures;
  FCoordinatorAddress := ACoordinatorAddress;
end;

constructor TGetNodeInfoResponse.Create(AAppName: String);
begin
  FAppName := AAppName;
end;

function TGetNodeInfoResponse.GetFeatures(Index: Integer): String;
begin
  Result := FFeatures[Index];
end;

function TGetNodeInfoResponse.GetFeaturesCount: Integer;
begin
  Result := Length(FFeatures);
end;

end.
