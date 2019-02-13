unit DIOTA.Model.Transaction;

interface

uses
  DIOTA.Pow.ICurl;

type
  ITransaction = interface(IEquatable<TObject>)
    ['{E7304064-EE17-4530-8381-F83A5672A443}']
    function Equals(AObject: TObject): Boolean;
    {
     * Converts the transaction to the corresponding trytes representation
    }
    function ToTrytes: String;
    {
     * Checks if the current index is 0
     * @return if this is a tail transaction
    }
    function IsTailTransaction: Boolean;

    function GetAttachmentTimestampLowerBound: Int64;
    function GetAttachmentTimestampUpperBound: Int64;
    function GetHash: String;
    function GetSignatureFragments: String;
    function GetAddress: String;
    function GetValue: Int64;
    function GetTag: String;
    function GetTimestamp: Int64;
    function GetCurrentIndex: Int64;
    function GetLastIndex: Int64;
    function GetBundle: String;
    function GetTrunkTransaction: String;
    function GetBranchTransaction: String;
    function GetNonce: String;
    function GetPersistence: Boolean;
    function GetObsoleteTag: String;
    function GetAttachmentTimestamp: Int64;

    procedure SetAttachmentTimestampLowerBound(AAttachmentTimestampLowerBound: Int64);
    procedure SetAttachmentTimestampUpperBound(AAttachmentTimestampUpperBound: Int64);
    procedure SetHash(AHash: String);
    procedure SetSignatureFragments(ASignatureFragments: String);
    procedure SetAddress(AAddress: String);
    procedure SetValue(AValue: Int64);
    procedure SetTag(ATag: String);
    procedure SetTimestamp(ATimestamp: Int64);
    procedure SetCurrentIndex(ACurrentIndex: Int64);
    procedure SetLastIndex(ALastIndex: Int64);
    procedure SetBundle(ABundle: String);
    procedure SetTrunkTransaction(ATrunkTransaction: String);
    procedure SetBranchTransaction(ABranchTransaction: String);
    procedure SetNonce(ANonce: String);
    procedure SetPersistence(APersistence: Boolean);
    procedure SetObsoleteTag(AObsoleteTag: String);
    procedure SetAttachmentTimestamp(AAttachmentTimestamp: Int64);

    property AttachmentTimestampLowerBound: Int64 read GetAttachmentTimestampLowerBound;
    property AttachmentTimestampUpperBound: Int64 read GetAttachmentTimestampUpperBound;
    property Hash: String read GetHash;
    property SignatureFragments: String read GetSignatureFragments;
    property Address: String read GetAddress;
    property Value: Int64 read GetValue;
    property Tag: String read GetTag;
    property Timestamp: Int64 read GetTimestamp;
    property CurrentIndex: Int64 read GetCurrentIndex;
    property LastIndex: Int64 read GetLastIndex;
    property Bundle: String read GetBundle;
    property TrunkTransaction: String read GetTrunkTransaction;
    property BranchTransaction: String read GetBranchTransaction;
    property Nonce: String read GetNonce;
    property Persistence: Boolean read GetPersistence;
    property ObsoleteTag: String read GetObsoleteTag;
    property AttachmentTimestamp: Int64 read GetAttachmentTimestamp;
  end;

  TTransactionBuilder = class
  private
    FCustomCurl: ICurl;
    FHash: String;
    FSignatureFragments: String;
    FAddress: String;
    FValue: Int64;
    FObsoleteTag: String;
    FTimestamp: Int64;
    FCurrentIndex: Int64;
    FLastIndex: Int64;
    FBundle: String;
    FTrunkTransaction: String;
    FBranchTransaction: String;
    FNonce: String;
    FPersistence: Boolean;
    FAttachmentTimestamp: Int64;
    FTag: String;
    FAttachmentTimestampLowerBound: Int64;
    FAttachmentTimestampUpperBound: Int64;
  public
    function SetCustomCurl(ACustomCurl: ICurl): TTransactionBuilder;
    function SetHash(AHash: String): TTransactionBuilder;
    function SetSignatureFragments(ASignatureFragments: String): TTransactionBuilder;
    function SetAddress(AAddress: String): TTransactionBuilder;
    function SetValue(AValue: Int64): TTransactionBuilder;
    function SetObsoleteTag(AObsoleteTag: String): TTransactionBuilder;
    function SetTimestamp(ATimestamp: Int64): TTransactionBuilder;
    function SetCurrentIndex(ACurrentIndex: Int64): TTransactionBuilder;
    function SetLastIndex(ALastIndex: Int64): TTransactionBuilder;
    function SetBundle(ABundle: String): TTransactionBuilder;
    function SetTrunkTransaction(ATrunkTransaction: String): TTransactionBuilder;
    function SetBranchTransaction(ABranchTransaction: String): TTransactionBuilder;
    function SetNonce(ANonce: String): TTransactionBuilder;
    function SetPersistence(APersistence: Boolean): TTransactionBuilder;
    function SetAttachmentTimestamp(AAttachmentTimestamp: Int64): TTransactionBuilder;
    function SetTag(ATag: String): TTransactionBuilder;
    function SetAttachmentTimestampLowerBound(AAttachmentTimestampLowerBound: Int64): TTransactionBuilder;
    function SetAttachmentTimestampUpperBound(AAttachmentTimestampUpperBound: Int64): TTransactionBuilder;
    function FromTrytes(ATrytes: String): TTransactionBuilder;

    function Build: ITransaction;
  end;

implementation

uses
  System.SysUtils,
  System.StrUtils,
  DIOTA.Utils.Constants,
  DIOTA.Utils.Converter,
  DIOTA.Utils.InputValidator,
  DIOTA.Pow.SpongeFactory;

type
  TTransaction = class(TInterfacedObject, ITransaction)
  private
    //FCustomCurl: ICurl;
    FHash: String;
    FSignatureFragments: String;
    FAddress: String;
    FValue: Int64;
    FObsoleteTag: String;
    FTimestamp: Int64;
    FCurrentIndex: Int64;
    FLastIndex: Int64;
    FBundle: String;
    FTrunkTransaction: String;
    FBranchTransaction: String;
    FNonce: String;
    FPersistence: Boolean;
    FAttachmentTimestamp: Int64;
    FTag: String;
    FAttachmentTimestampLowerBound: Int64;
    FAttachmentTimestampUpperBound: Int64;
  public
    constructor Create(ASignatureFragments: String; ACurrentIndex: Int64; ALastIndex: Int64; ANonce: String; AHash: String; AObsoleteTag: String;
                       ATimestamp: Int64; ATrunkTransaction: String; ABranchTransaction: String; AAddress: String; AValue: Int64; ABundle: String;
                       ATag: String; AAttachmentTimestamp: Int64; AAttachmentTimestampLowerBound: Int64; AAttachmentTimestampUpperBound: Int64); virtual;

    function Equals(AObject: TObject): Boolean; override;
    {
     * Converts the transaction to the corresponding trytes representation
    }
    function ToTrytes: String;
    {
     * Checks if the current index is 0
     * @return if this is a tail transaction
    }
    function IsTailTransaction: Boolean;

    function GetAttachmentTimestampLowerBound: Int64;
    function GetAttachmentTimestampUpperBound: Int64;
    function GetHash: String;
    function GetSignatureFragments: String;
    function GetAddress: String;
    function GetValue: Int64;
    function GetTag: String;
    function GetTimestamp: Int64;
    function GetCurrentIndex: Int64;
    function GetLastIndex: Int64;
    function GetBundle: String;
    function GetTrunkTransaction: String;
    function GetBranchTransaction: String;
    function GetNonce: String;
    function GetPersistence: Boolean;
    function GetObsoleteTag: String;
    function GetAttachmentTimestamp: Int64;

    procedure SetAttachmentTimestampLowerBound(AAttachmentTimestampLowerBound: Int64);
    procedure SetAttachmentTimestampUpperBound(AAttachmentTimestampUpperBound: Int64);
    procedure SetHash(AHash: String);
    procedure SetSignatureFragments(ASignatureFragments: String);
    procedure SetAddress(AAddress: String);
    procedure SetValue(AValue: Int64);
    procedure SetTag(ATag: String);
    procedure SetTimestamp(ATimestamp: Int64);
    procedure SetCurrentIndex(ACurrentIndex: Int64);
    procedure SetLastIndex(ALastIndex: Int64);
    procedure SetBundle(ABundle: String);
    procedure SetTrunkTransaction(ATrunkTransaction: String);
    procedure SetBranchTransaction(ABranchTransaction: String);
    procedure SetNonce(ANonce: String);
    procedure SetPersistence(APersistence: Boolean);
    procedure SetObsoleteTag(AObsoleteTag: String);
    procedure SetAttachmentTimestamp(AAttachmentTimestamp: Int64);
  end;

{ TTransactionBuilder }

function TTransactionBuilder.Build: ITransaction;
begin
  Result := TTransaction.Create(
    FSignatureFragments,
    FCurrentIndex,
    FLastIndex,
    FNonce,
    FHash,
    FObsoleteTag,
    FTimestamp,
    FTrunkTransaction,
    FBranchTransaction,
    FAddress,
    FValue,
    FBundle,
    IfThen((FTag = '') or (FTag.CountChar('9') = Length(FTag)), FObsoleteTag, FTag),
    FAttachmentTimestamp,
    FAttachmentTimestampLowerBound,
    FAttachmentTimestampUpperBound);
end;

function TTransactionBuilder.FromTrytes(ATrytes: String): TTransactionBuilder;
var
  ATransactionTrits: TArray<Integer>;
  AHash: TArray<Integer>;
  ACurl: ICurl;
begin
  if (ATrytes <> '') and TInputValidator.IsNinesTrytes(Copy(ATrytes, 2280, 16), 16) then
    begin
      ATransactionTrits := TConverter.trits(ATrytes);
      SetLength(AHash, HASH_LENGTH_TRITS);
      ACurl := TSpongeFactory.Create(TSpongeFactory.Mode.CURLP81);
      // generate the correct transaction hash
      ACurl.Reset;
      ACurl.Absorb(ATransactionTrits, 0, Length(ATransactionTrits));
      ACurl.Squeeze(AHash, 0, Length(AHash));

      FHash := TConverter.trytes(AHash);
      FSignatureFragments := Copy(ATrytes, 1, MESSAGE_LENGTH);
      FAddress := Copy(ATrytes, MESSAGE_LENGTH + 1, ADDRESS_LENGTH_WITHOUT_CHECKSUM);
      FValue := TConverter.longValue(Copy(ATransactionTrits, 6804, 33));
      FObsoleteTag := Copy(ATrytes, 2296, TAG_LENGTH);
      FTimestamp := TConverter.longValue(Copy(ATransactionTrits, 6966, 27));
      FCurrentIndex := TConverter.longValue(Copy(ATransactionTrits, 6993, 27));
      FLastIndex := TConverter.longValue(Copy(ATransactionTrits, 7020, 27));
      FBundle := Copy(ATrytes, 2350, ADDRESS_LENGTH_WITHOUT_CHECKSUM);
      FTrunkTransaction := Copy(ATrytes, 2431, ADDRESS_LENGTH_WITHOUT_CHECKSUM);
      FBranchTransaction := Copy(ATrytes, 2512, ADDRESS_LENGTH_WITHOUT_CHECKSUM);
      FTag := Copy(ATrytes, 2593, TAG_LENGTH);
      FAttachmentTimestamp := TConverter.longValue(Copy(ATransactionTrits, 7857, 27));
      FAttachmentTimestampLowerBound := TConverter.longValue(Copy(ATransactionTrits, 7884, 27));
      FAttachmentTimestampUpperBound := TConverter.longValue(Copy(ATransactionTrits, 7911, 27));
      FNonce := Copy(ATrytes, 2647, 27);
    end;
  Result := Self;
end;

function TTransactionBuilder.SetAddress(AAddress: String): TTransactionBuilder;
begin
  FAddress := AAddress;
  Result := Self;
end;

function TTransactionBuilder.SetAttachmentTimestamp(AAttachmentTimestamp: Int64): TTransactionBuilder;
begin
  FAttachmentTimestamp := AAttachmentTimestamp;
  Result := Self;
end;

function TTransactionBuilder.SetAttachmentTimestampLowerBound(AAttachmentTimestampLowerBound: Int64): TTransactionBuilder;
begin
  FAttachmentTimestampLowerBound := AAttachmentTimestampLowerBound;
  Result := Self;
end;

function TTransactionBuilder.SetAttachmentTimestampUpperBound(AAttachmentTimestampUpperBound: Int64): TTransactionBuilder;
begin
  FAttachmentTimestampUpperBound := AAttachmentTimestampUpperBound;
  Result := Self;
end;

function TTransactionBuilder.SetBranchTransaction(ABranchTransaction: String): TTransactionBuilder;
begin
  FBranchTransaction := ABranchTransaction;
  Result := Self;
end;

function TTransactionBuilder.SetBundle(ABundle: String): TTransactionBuilder;
begin
  FBundle := ABundle;
  Result := Self;
end;

function TTransactionBuilder.SetCurrentIndex(ACurrentIndex: Int64): TTransactionBuilder;
begin
  FCurrentIndex := ACurrentIndex;
  Result := Self;
end;

function TTransactionBuilder.SetCustomCurl(ACustomCurl: ICurl): TTransactionBuilder;
begin
  FCustomCurl := ACustomCurl;
  Result := Self;
end;

function TTransactionBuilder.SetHash(AHash: String): TTransactionBuilder;
begin
  FHash := AHash;
  Result := Self;
end;

function TTransactionBuilder.SetLastIndex(ALastIndex: Int64): TTransactionBuilder;
begin
  FLastIndex := ALastIndex;
  Result := Self;
end;

function TTransactionBuilder.SetNonce(ANonce: String): TTransactionBuilder;
begin
  FNonce := ANonce;
  Result := Self;
end;

function TTransactionBuilder.SetObsoleteTag(AObsoleteTag: String): TTransactionBuilder;
begin
  FObsoleteTag := AObsoleteTag;
  Result := Self;
end;

function TTransactionBuilder.SetPersistence(APersistence: Boolean): TTransactionBuilder;
begin
  FPersistence := APersistence;
  Result := Self;
end;

function TTransactionBuilder.SetSignatureFragments(ASignatureFragments: String): TTransactionBuilder;
begin
  FSignatureFragments := ASignatureFragments;
  Result := Self;
end;

function TTransactionBuilder.SetTag(ATag: String): TTransactionBuilder;
begin
  FTag := ATag;
  Result := Self;
end;

function TTransactionBuilder.SetTimestamp(ATimestamp: Int64): TTransactionBuilder;
begin
  FTimestamp := ATimestamp;
  Result := Self;
end;

function TTransactionBuilder.SetTrunkTransaction(ATrunkTransaction: String): TTransactionBuilder;
begin
  FTrunkTransaction := ATrunkTransaction;
  Result := Self;
end;

function TTransactionBuilder.SetValue(AValue: Int64): TTransactionBuilder;
begin
  FValue := AValue;
  Result := Self;
end;

{ TTransaction }

constructor TTransaction.Create(ASignatureFragments: String; ACurrentIndex, ALastIndex: Int64; ANonce, AHash, AObsoleteTag: String; ATimestamp: Int64;
                                ATrunkTransaction, ABranchTransaction, AAddress: String; AValue: Int64; ABundle, ATag: String;
                                AAttachmentTimestamp, AAttachmentTimestampLowerBound, AAttachmentTimestampUpperBound: Int64);
begin
  FHash := AHash;
  if AObsoleteTag = '' then
    FObsoleteTag := ATag
  else
    FObsoleteTag := AObsoleteTag;
  FSignatureFragments := ASignatureFragments;
  FAddress := AAddress;
  FValue := AValue;
  FTimestamp := ATimestamp;
  FCurrentIndex := ACurrentIndex;
  FLastIndex := ALastIndex;
  FBundle := ABundle;
  FTrunkTransaction := ATrunkTransaction;
  FBranchTransaction := ABranchTransaction;
  FTag := ATag;
  FAttachmentTimestamp := AAttachmentTimestamp;
  FAttachmentTimestampLowerBound := AAttachmentTimestampLowerBound;
  FAttachmentTimestampUpperBound := AAttachmentTimestampUpperBound;
  FNonce := ANonce;
end;

function TTransaction.Equals(AObject: TObject): Boolean;
var
  ATransaction: ITransaction;
begin
  Result := Assigned(ATransaction) and Supports(AObject, ITransaction, ATransaction) and (ATransaction.Hash = GetHash);
end;

function TTransaction.ToTrytes: String;
var
  AValueTrits: TArray<Integer>;
  ATimestampTrits: TArray<Integer>;
  ACurrentIndexTrits: TArray<Integer>;
  ALastIndexTrits: TArray<Integer>;
  AAttachmentTimestampTrits: TArray<Integer>;
  AAttachmentTimestampLowerBoundTrits: TArray<Integer>;
  AAttachmentTimestampUpperBoundTrits: TArray<Integer>;
begin
  AValueTrits := TConverter.Trits(FValue, 81);
  ATimestampTrits := TConverter.Trits(FTimestamp, 27);
  ACurrentIndexTrits := TConverter.Trits(FCurrentIndex, 27);
  ALastIndexTrits := TConverter.Trits(FLastIndex, 27);
  AAttachmentTimestampTrits := TConverter.Trits(FAttachmentTimestamp, 27);
  AAttachmentTimestampLowerBoundTrits := TConverter.Trits(FAttachmentTimestampLowerBound, 27);
  AAttachmentTimestampUpperBoundTrits := TConverter.Trits(FAttachmentTimestampUpperBound, 27);

  Result := FSignatureFragments
            + FAddress
            + TConverter.trytes(AValueTrits)
            + FObsoleteTag
            + TConverter.trytes(ATimestampTrits)
            + TConverter.trytes(ACurrentIndexTrits)
            + TConverter.trytes(ALastIndexTrits)
            + FBundle
            + FTrunkTransaction
            + FBranchTransaction
            + IfThen(FTag = '', FObsoleteTag, FTag)
            + TConverter.trytes(AAttachmentTimestampTrits)
            + TConverter.trytes(AAttachmentTimestampLowerBoundTrits)
            + TConverter.trytes(AAttachmentTimestampUpperBoundTrits)
            + FNonce;
end;

function TTransaction.IsTailTransaction: Boolean;
begin
  Result := FCurrentIndex = 0;
end;

function TTransaction.GetAddress: String;
begin
  Result := FAddress;
end;

function TTransaction.GetAttachmentTimestamp: Int64;
begin
  Result := FAttachmentTimestamp;
end;

function TTransaction.GetAttachmentTimestampLowerBound: Int64;
begin
  Result := FAttachmentTimestampLowerBound;
end;

function TTransaction.GetAttachmentTimestampUpperBound: Int64;
begin
  Result := FAttachmentTimestampUpperBound;
end;

function TTransaction.GetBranchTransaction: String;
begin
  Result := FBranchTransaction;
end;

function TTransaction.GetBundle: String;
begin
  Result := FBundle;
end;

function TTransaction.GetCurrentIndex: Int64;
begin
  Result := FCurrentIndex;
end;

function TTransaction.GetHash: String;
begin
  Result := FHash;
end;

function TTransaction.GetLastIndex: Int64;
begin
  Result := FLastIndex;
end;

function TTransaction.GetNonce: String;
begin
  Result := FNonce;
end;

function TTransaction.GetObsoleteTag: String;
begin
  Result := FObsoleteTag;
end;

function TTransaction.GetPersistence: Boolean;
begin
  Result := FPersistence;
end;

function TTransaction.GetSignatureFragments: String;
begin
  Result := FSignatureFragments;
end;

function TTransaction.GetTag: String;
begin
  Result := FTag;
end;

function TTransaction.GetTimestamp: Int64;
begin
  Result := FTimestamp;
end;

function TTransaction.GetTrunkTransaction: String;
begin
  Result := FTrunkTransaction;
end;

function TTransaction.GetValue: Int64;
begin
  Result := FValue;
end;

procedure TTransaction.SetAddress(AAddress: String);
begin
  FAddress:= AAddress;
end;

procedure TTransaction.SetAttachmentTimestamp(AAttachmentTimestamp: Int64);
begin
  FAttachmentTimestamp:= AAttachmentTimestamp;
end;

procedure TTransaction.SetAttachmentTimestampLowerBound(AAttachmentTimestampLowerBound: Int64);
begin
  FAttachmentTimestampLowerBound:= AAttachmentTimestampLowerBound;
end;

procedure TTransaction.SetAttachmentTimestampUpperBound(AAttachmentTimestampUpperBound: Int64);
begin
  FAttachmentTimestampUpperBound:= AAttachmentTimestampUpperBound;
end;

procedure TTransaction.SetBranchTransaction(ABranchTransaction: String);
begin
  FBranchTransaction:= ABranchTransaction;
end;

procedure TTransaction.SetBundle(ABundle: String);
begin
  FBundle:= ABundle;
end;

procedure TTransaction.SetCurrentIndex(ACurrentIndex: Int64);
begin
  FCurrentIndex:= ACurrentIndex;
end;

procedure TTransaction.SetHash(AHash: String);
begin
  FHash:= AHash;
end;

procedure TTransaction.SetLastIndex(ALastIndex: Int64);
begin
  FLastIndex:= ALastIndex;
end;

procedure TTransaction.SetNonce(ANonce: String);
begin
  FNonce:= ANonce;
end;

procedure TTransaction.SetObsoleteTag(AObsoleteTag: String);
begin
  FObsoleteTag:= AObsoleteTag;
end;

procedure TTransaction.SetPersistence(APersistence: Boolean);
begin
  FPersistence:= APersistence;
end;

procedure TTransaction.SetSignatureFragments(ASignatureFragments: String);
begin
  FSignatureFragments:= ASignatureFragments;
end;

procedure TTransaction.SetTag(ATag: String);
begin
  FTag:= ATag;
end;

procedure TTransaction.SetTimestamp(ATimestamp: Int64);
begin
  FTimestamp:= ATimestamp;
end;

procedure TTransaction.SetTrunkTransaction(ATrunkTransaction: String);
begin
  FTrunkTransaction:= ATrunkTransaction;
end;

procedure TTransaction.SetValue(AValue: Int64);
begin
  FValue:= AValue;
end;

end.
