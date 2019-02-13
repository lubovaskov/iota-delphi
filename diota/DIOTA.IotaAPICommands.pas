unit DIOTA.IotaAPICommands;

interface

type
  IIOTAAPICommand = interface
    ['{976C0E47-F554-4EB3-BCDF-1F8C84B56569}']
    function GetCommand: String;
  end;

  TIOTAAPICommands = class
  private
    class function GetGET_NODE_INFO: IIOTAAPICommand; static;
    class function GetGET_NEIGHBORS: IIOTAAPICommand; static;
    class function GetADD_NEIGHBORS: IIOTAAPICommand; static;
    class function GetREMOVE_NEIGHBORS: IIOTAAPICommand; static;
    class function GetGET_TIPS: IIOTAAPICommand; static;
    class function GetFIND_TRANSACTIONS: IIOTAAPICommand; static;
    class function GetGET_TRYTES: IIOTAAPICommand; static;
    class function GetGET_INCLUSIONS_STATES: IIOTAAPICommand; static;
    class function GetGET_BALANCES: IIOTAAPICommand; static;
    class function GetGET_TRANSACTIONS_TO_APPROVE: IIOTAAPICommand; static;
    class function GetATTACH_TO_TANGLE: IIOTAAPICommand; static;
    class function GetINTERRUPT_ATTACHING_TO_TANGLE: IIOTAAPICommand; static;
    class function GetBROADCAST_TRANSACTIONS: IIOTAAPICommand; static;
    class function GetSTORE_TRANSACTIONS: IIOTAAPICommand; static;
    class function GetCHECK_CONSISTENCY: IIOTAAPICommand; static;
    class function GetWERE_ADDRESSES_SPENT_FROM: IIOTAAPICommand; static;
  public
    class property GET_NODE_INFO: IIOTAAPICommand read GetGET_NODE_INFO;
    class property GET_NEIGHBORS: IIOTAAPICommand read GetGET_NEIGHBORS;
    class property ADD_NEIGHBORS: IIOTAAPICommand read GetADD_NEIGHBORS;
    class property REMOVE_NEIGHBORS: IIOTAAPICommand read GetREMOVE_NEIGHBORS;
    class property GET_TIPS: IIOTAAPICommand read GetGET_TIPS;
    class property FIND_TRANSACTIONS: IIOTAAPICommand read GetFIND_TRANSACTIONS;
    class property GET_TRYTES: IIOTAAPICommand read GetGET_TRYTES;
    class property GET_INCLUSIONS_STATES: IIOTAAPICommand read GetGET_INCLUSIONS_STATES;
    class property GET_BALANCES: IIOTAAPICommand read GetGET_BALANCES;
    class property GET_TRANSACTIONS_TO_APPROVE: IIOTAAPICommand read GetGET_TRANSACTIONS_TO_APPROVE;
    class property ATTACH_TO_TANGLE: IIOTAAPICommand read GetATTACH_TO_TANGLE;
    class property INTERRUPT_ATTACHING_TO_TANGLE: IIOTAAPICommand read GetINTERRUPT_ATTACHING_TO_TANGLE;
    class property BROADCAST_TRANSACTIONS: IIOTAAPICommand read GetBROADCAST_TRANSACTIONS;
    class property STORE_TRANSACTIONS: IIOTAAPICommand read GetSTORE_TRANSACTIONS;
    class property CHECK_CONSISTENCY: IIOTAAPICommand read GetCHECK_CONSISTENCY;
    class property WERE_ADDRESSES_SPENT_FROM: IIOTAAPICommand read GetWERE_ADDRESSES_SPENT_FROM;
  end;

implementation

type
  TIOTAAPICommand = class(TInterfacedObject, IIOTAAPICommand)
  private
    FCommand: String;
  public
    constructor Create(command: String);
    function GetCommand: String;
  end;

{ TIOTAAPICommands }

class function TIOTAAPICommands.GetADD_NEIGHBORS: IIOTAAPICommand;
begin
  Result := TIOTAAPICommand.Create('addNeighbors');
end;

class function TIOTAAPICommands.GetATTACH_TO_TANGLE: IIOTAAPICommand;
begin
  Result := TIOTAAPICommand.Create('attachToTangle');
end;

class function TIOTAAPICommands.GetBROADCAST_TRANSACTIONS: IIOTAAPICommand;
begin
  Result := TIOTAAPICommand.Create('broadcastTransactions');
end;

class function TIOTAAPICommands.GetCHECK_CONSISTENCY: IIOTAAPICommand;
begin
  Result := TIOTAAPICommand.Create('checkConsistency');
end;

class function TIOTAAPICommands.GetFIND_TRANSACTIONS: IIOTAAPICommand;
begin
  Result := TIOTAAPICommand.Create('findTransactions');
end;

class function TIOTAAPICommands.GetGET_BALANCES: IIOTAAPICommand;
begin
  Result := TIOTAAPICommand.Create('getBalances');
end;

class function TIOTAAPICommands.GetGET_INCLUSIONS_STATES: IIOTAAPICommand;
begin
  Result := TIOTAAPICommand.Create('getInclusionStates');
end;

class function TIOTAAPICommands.GetGET_NEIGHBORS: IIOTAAPICommand;
begin
  Result := TIOTAAPICommand.Create('getNeighbors');
end;

class function TIOTAAPICommands.GetGET_NODE_INFO: IIOTAAPICommand;
begin
  Result := TIOTAAPICommand.Create('getNodeInfo');
end;

class function TIOTAAPICommands.GetGET_TIPS: IIOTAAPICommand;
begin
  Result := TIOTAAPICommand.Create('getTips');
end;

class function TIOTAAPICommands.GetGET_TRANSACTIONS_TO_APPROVE: IIOTAAPICommand;
begin
  Result := TIOTAAPICommand.Create('getTransactionsToApprove');
end;

class function TIOTAAPICommands.GetGET_TRYTES: IIOTAAPICommand;
begin
  Result := TIOTAAPICommand.Create('getTrytes');
end;

class function TIOTAAPICommands.GetINTERRUPT_ATTACHING_TO_TANGLE: IIOTAAPICommand;
begin
  Result := TIOTAAPICommand.Create('interruptAttachingToTangle');
end;

class function TIOTAAPICommands.GetREMOVE_NEIGHBORS: IIOTAAPICommand;
begin
  Result := TIOTAAPICommand.Create('removeNeighbors');
end;

class function TIOTAAPICommands.GetSTORE_TRANSACTIONS: IIOTAAPICommand;
begin
  Result := TIOTAAPICommand.Create('storeTransactions');
end;

class function TIOTAAPICommands.GetWERE_ADDRESSES_SPENT_FROM: IIOTAAPICommand;
begin
  Result := TIOTAAPICommand.Create('wereAddressesSpentFrom');
end;

{ TIOTAAPICommand }

constructor TIOTAAPICommand.Create(command: String);
begin
  FCommand := command;
end;

function TIOTAAPICommand.GetCommand: String;
begin
  Result := FCommand;
end;

end.
