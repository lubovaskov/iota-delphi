unit DIOTA.Model.Transfer;

interface

type
  ITransfer = interface
    ['{1E8AE714-FEE1-4A68-8DDD-854B7E7B53E8}']
    function GetAddress: String;
    function GetValue: Int64;
    function GetMessage: String;
    function GetTag: String;

    procedure SetAddress(AAddress: String);

    property Address: String read GetAddress write SetAddress;
    property Value: Int64 read GetValue;
    property Message: String read GetMessage;
    property Tag: String read GetTag;
  end;

  TTransferBuilder = class
  private
    FAddress: String;
    FValue: Int64;
    FMessage: String;
    FTag: String;
  public
    class function CreateTransfer(AAddress: String; AValue: Int64; AMessage: String; ATag: String): ITransfer;

    function SetAddress(AAddress: String): TTransferBuilder;
    function SetValue(AValue: Int64): TTransferBuilder;
    function SetMessage(AMessage: String): TTransferBuilder;
    function SetTag(ATag: String): TTransferBuilder;

    function Build: ITransfer;
  end;

implementation

type
  TTransfer = class(TInterfacedObject, ITransfer)
  private
    FAddress: String;
    FValue: Int64;
    FMessage: String;
    FTag: String;
    function GetAddress: String;
    function GetValue: Int64;
    function GetMessage: String;
    function GetTag: String;
    procedure SetAddress(AAddress: String);
  public
    constructor Create(AAddress: String; AValue: Int64; AMessage: String; ATag: String);
  end;

{ TTransferBuilder }

class function TTransferBuilder.CreateTransfer(AAddress: String; AValue: Int64; AMessage: String; ATag: String): ITransfer;
begin
  Result := TTransfer.Create(AAddress, AValue, AMessage, ATag);
end;

function TTransferBuilder.Build: ITransfer;
begin
  Result := TTransfer.Create(FAddress, FValue, FMessage, FTag);
end;

function TTransferBuilder.SetAddress(AAddress: String): TTransferBuilder;
begin
  FAddress := AAddress;
  Result := Self;
end;

function TTransferBuilder.SetMessage(AMessage: String): TTransferBuilder;
begin
  FMessage := AMessage;
  Result := Self;
end;

function TTransferBuilder.SetTag(ATag: String): TTransferBuilder;
begin
  FTag := ATag;
  Result := Self;
end;

function TTransferBuilder.SetValue(AValue: Int64): TTransferBuilder;
begin
  FValue := AValue;
  Result := Self;
end;

{ TTransfer }

constructor TTransfer.Create(AAddress: String; AValue: Int64; AMessage: String; ATag: String);
begin
  FAddress := AAddress;
  FValue := AValue;
  FMessage := AMessage;
  FTag := ATag;
end;

function TTransfer.GetAddress: String;
begin
  Result := FAddress;
end;

function TTransfer.GetMessage: String;
begin
  Result := FMessage;
end;

function TTransfer.GetTag: String;
begin
  Result := FTag;
end;

function TTransfer.GetValue: Int64;
begin
  Result := FValue;
end;

procedure TTransfer.SetAddress(AAddress: String);
begin
  FAddress := AAddress;
end;

end.
