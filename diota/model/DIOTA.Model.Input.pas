unit DIOTA.Model.Input;

interface

type
  IInput = interface
    ['{3BB2AB80-1BF0-4A3A-8EB9-DD4CD698ED57}']
    function GetAddress: String;
    function GetBalance: Int64;
    function GetKeyIndex: Integer;
    function GetSecurity: Integer;

    procedure SetBalance(AValue: Int64);

    property Address: String read GetAddress;
    property Balance: Int64 read GetBalance write SetBalance;
    property KeyIndex: Integer read GetKeyIndex;
    property Security: Integer read GetSecurity;
  end;

  TInputBuilder = class
  private
    FAddress: String;
    FBalance: Int64;
    FKeyIndex: Integer;
    FSecurity: Integer;
  public
    {
     * Initializes a new instance of the Input class.
     *
     * @param address with checksum
     * @param balance
     * @param keyIndex
     * @param security
    }
    class function CreateInput(AAddress: String; ABalance: Int64; AKeyIndex: Integer; ASecurity: Integer): IInput; static;

    function SetAddress(AAddress: String): TInputBuilder;
    function SetBalance(ABalance: Int64): TInputBuilder;
    function SetKeyIndex(AKeyIndex: Integer): TInputBuilder;
    function SetSecurity(ASecurity: Integer): TInputBuilder;

    function Build: IInput;
  end;

implementation

type
  TInput = class(TInterfacedObject, IInput)
  private
    FAddress: String;
    FBalance: Int64;
    FKeyIndex: Integer;
    FSecurity: Integer;
    function GetAddress: String;
    function GetBalance: Int64;
    function GetKeyIndex: Integer;
    function GetSecurity: Integer;

    procedure SetBalance(AValue: Int64);
  public
    constructor Create(AAddress: String; ABalance: Int64; AKeyIndex: Integer; ASecurity: Integer); virtual;
  end;

{ TInputBuilder }

class function TInputBuilder.CreateInput(AAddress: String; ABalance: Int64; AKeyIndex, ASecurity: Integer): IInput;
begin
  Result := TInput.Create(AAddress, ABalance, AKeyIndex, ASecurity);
end;

function TInputBuilder.Build: IInput;
begin
  Result := TInput.Create(FAddress, FBalance, FKeyIndex, FSecurity);
end;

function TInputBuilder.SetAddress(AAddress: String): TInputBuilder;
begin
  FAddress := AAddress;
  Result := Self;
end;

function TInputBuilder.SetBalance(ABalance: Int64): TInputBuilder;
begin
  FBalance := ABalance;
  Result := Self;
end;

function TInputBuilder.SetKeyIndex(AKeyIndex: Integer): TInputBuilder;
begin
  FKeyIndex := AKeyIndex;
  Result := Self;
end;

function TInputBuilder.SetSecurity(ASecurity: Integer): TInputBuilder;
begin
  FSecurity := ASecurity;
  Result := Self;
end;

{ TInput }

constructor TInput.Create(AAddress: String; ABalance: Int64; AKeyIndex: Integer; ASecurity: Integer);
begin
  FAddress := AAddress;
  FBalance := ABalance;
  FKeyIndex := AKeyIndex;
  FSecurity := ASecurity;
end;

function TInput.GetAddress: String;
begin
  Result := FAddress;
end;

function TInput.GetBalance: Int64;
begin
  Result := FBalance;
end;

function TInput.GetKeyIndex: Integer;
begin
  Result := FKeyIndex;
end;

function TInput.GetSecurity: Integer;
begin
  Result := FSecurity;
end;

procedure TInput.SetBalance(AValue: Int64);
begin
  FBalance := AValue;
end;

end.
