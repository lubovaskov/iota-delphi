unit DIOTA.Model.Bundle;

interface

uses
  System.Classes,
  Generics.Collections,
  DIOTA.Model.Transaction,
  DIOTA.Pow.ICurl;

type
  {
   * This class represents a Bundle, a set of transactions.
   *
  }
  IBundle = interface(IComparable)
    ['{8EDE8F67-4FC0-4345-9470-1C4BC4198488}']
    {
     * Compares the current object with another object of the same type.
     *
     * @param Obj An object to compare with this object.
     * @return A value that indicates the relative order of the objects being compared.
     *         The return value has the following meanings:
     *         Value Meaning Less than zero This object is less than the parameter.
     *         Zero This object is equal to other.
     *         Greater than zero This object is greater than other.
    }
    function CompareTo(Obj: TObject): Integer;
    {
     * Adds a bundle entry.
     *
     * @param signatureMessageLength Length of the signature message.
     * @param address                The address.
     * @param value                  The value.
     * @param tag                    The tag.
     * @param timestamp              The timestamp.
    }
    procedure AddEntry(signatureMessageLength: Integer; address: String; value: Int64; tag: String; timestamp: Int64);
    {
     * Finalizes the bundle using the specified curl implementation,
     *
     * @param customCurl The custom curl.
    }
    procedure Finalize(customCurl: ICurl);
    {
     * Adds the trytes.
     *
     * @param signatureFragments The signature fragments.
    }
    procedure AddTrytes(signatureFragments: TStrings);
    {
     * Normalized the bundle.
     *
     * @param bundleHash The bundle hash.
     * @return normalizedBundle A normalized bundle hash.
    }
    function NormalizedBundle(bundleHash: String): TArray<Integer>;

    function GetTransactions: TList<ITransaction>;

    property Transactions: TList<ITransaction> read GetTransactions;
  end;

  TBundleBuilder = class
  private
    FTransactions: TArray<ITransaction>;
  public
    class function CreateBundle(ATransactions: TArray<ITransaction> = nil): IBundle; static;

    function SetTransactions(ATransactions: TArray<ITransaction>): TBundleBuilder;

    function Build: IBundle;
  end;

implementation

uses
  System.Math,
  System.SysUtils,
  System.StrUtils,
  DIOTA.Pow.SpongeFactory,
  DIOTA.Utils.Converter,
  DIOTA.Utils.Signing;

type
  TBundle = class(TInterfacedObject, IBundle)
  private
    FTransactions: TList<ITransaction>;
  public
    const
      EMPTY_HASH = '999999999999999999999999999999999999999999999999999999999999999999999999999999999';
    constructor Create(ATransactions: TArray<ITransaction> = nil); virtual;
    destructor Destroy; override;
    function CompareTo(Obj: TObject): Integer;
    procedure AddEntry(signatureMessageLength: Integer; address: String; value: Int64; tag: String; timestamp: Int64);
    procedure Finalize(customCurl: ICurl);
    procedure AddTrytes(signatureFragments: TStrings);
    function NormalizedBundle(bundleHash: String): TArray<Integer>;

    function GetTransactions: TList<ITransaction>;
  end;

{ TBundleBuilder }

class function TBundleBuilder.CreateBundle(ATransactions: TArray<ITransaction> = nil): IBundle;
begin
  Result := TBundle.Create(ATransactions);
end;

function TBundleBuilder.Build: IBundle;
begin
  Result := TBundle.Create(FTransactions);
end;

function TBundleBuilder.SetTransactions(ATransactions: TArray<ITransaction>): TBundleBuilder;
begin
  FTransactions := ATransactions;
  Result := Self;
end;

{ TBundle }

constructor TBundle.Create(ATransactions: TArray<ITransaction> = nil);
var
  ATransaction: ITransaction;
begin
  inherited Create;
  FTransactions := TList<ITransaction>.Create;
  if Assigned(ATransactions) then
    for ATransaction in ATransactions do
      FTransactions.Add(ATransaction);
end;

destructor TBundle.Destroy;
begin
  FTransactions.Free;
  inherited;
end;

procedure TBundle.AddEntry(signatureMessageLength: Integer; address: String; value: Int64; tag: String; timestamp: Int64);
var
  i: Integer;
  ABuilder: TTransactionBuilder;
begin
  if not Assigned(FTransactions) then
    FTransactions := TList<ITransaction>.Create;

  for i := 0 to signatureMessageLength - 1 do
    begin
      ABuilder := TTransactionBuilder.Create;
      try
        FTransactions.Add(
          ABuilder
          .SetAddress(address)
          .SetValue(IfThen(i = 0, value, 0))
          .SetTag(tag)
          .SetTimestamp(timestamp)
          .Build);
      finally
        ABuilder.Free;
      end;
    end;
end;

procedure TBundle.Finalize(customCurl: ICurl);
var
  ACurl: ICurl;
  ANormalizedBundleValue: TArray<Integer>;
  AHash: TArray<Integer>;
  AObsoleteTagTrits: TArray<Integer>;
  AHashInTrytes: String;
  AValid: Boolean;
  ATransaction: ITransaction;
  AFoundValue: Boolean;
  ANBundleValue: Integer;
  AValueTrits: TArray<Integer>;
  ATimestampTrits: TArray<Integer>;
  ACurrentIndex: Integer;
  ACurrentIndexTrits: TArray<Integer>;
  ALastIndexTrits: TArray<Integer>;
  T: TArray<Integer>;
begin
  SetLength(AHash, 243);
  SetLength(AObsoleteTagTrits, 81);

  if Assigned(customCurl) then
    ACurl := customCurl
  else
    ACurl := TSpongeFactory.Create(TSpongeFactory.Mode.KERL);

  repeat
    ACurl.Reset;

    ACurrentIndex := 0;
    for ATransaction in FTransactions do
      begin
        AValueTrits := TConverter.Trits(ATransaction.Value, 81);
        ATimestampTrits := TConverter.Trits(ATransaction.Timestamp, 27);
        ATransaction.SetCurrentIndex(ACurrentIndex);
        ACurrentIndexTrits := TConverter.Trits(ATransaction.CurrentIndex, 27);
        ATransaction.SetLastIndex(FTransactions.Count - 1);
        ALastIndexTrits := TConverter.Trits(ATransaction.LastIndex, 27);
        T := TConverter.Trits(
               ATransaction.Address +
               TConverter.Trytes(AValueTrits) +
               ATransaction.ObsoleteTag +
               TConverter.Trytes(ATimestampTrits) +
               TConverter.Trytes(ACurrentIndexTrits) +
               TConverter.Trytes(ALastIndexTrits));

        ACurl.Absorb(T, 0, System.Length(T));

        Inc(ACurrentIndex);
      end;

    ACurl.Squeeze(AHash, 0, System.Length(AHash));
    AHashInTrytes := TConverter.Trytes(AHash);
    ANormalizedBundleValue := NormalizedBundle(AHashInTrytes);

    AFoundValue := False;
    for ANBundleValue in ANormalizedBundleValue do
      if ANBundleValue = 13 then
        begin
          AFoundValue := True;
          AObsoleteTagTrits := TConverter.Trits(FTransactions[0].ObsoleteTag);
          TConverter.Increment(AObsoleteTagTrits, 81);
          FTransactions[0].SetObsoleteTag(TConverter.Trytes(AObsoleteTagTrits));
        end;

    AValid := not AFoundValue;

  until AValid;

  for ATransaction in FTransactions do
    ATransaction.SetBundle(AHashInTrytes);
end;

procedure TBundle.AddTrytes(signatureFragments: TStrings);
var
  AEmptySignatureFragment: String;
  ATransaction: ITransaction;
  i: Integer;
begin
  AEmptySignatureFragment := AEmptySignatureFragment.PadRight(2187, '9');
  i := 0;
  for ATransaction in FTransactions do
    begin
      // Fill empty signatureMessageFragment
      if (i < signatureFragments.Count) and (signatureFragments[i] <> '') then
        ATransaction.SetSignatureFragments(signatureFragments[i])
      else
        ATransaction.SetSignatureFragments(AEmptySignatureFragment);
      // Fill empty trunkTransaction
      ATransaction.SetTrunkTransaction(EMPTY_HASH);
      // Fill empty branchTransaction
      ATransaction.SetBranchTransaction(EMPTY_HASH);

      ATransaction.SetAttachmentTimestamp(999999999);
      ATransaction.SetAttachmentTimestampLowerBound(999999999);
      ATransaction.SetAttachmentTimestampUpperBound(999999999);

      // Fill empty nonce
      ATransaction.SetNonce(DupeString('9', 27));

      Inc(i);
    end;
end;

function TBundle.NormalizedBundle(bundleHash: String): TArray<Integer>;
var
  ASigning: TSigning;
begin
  ASigning := TSigning.Create;
  try
    Result := ASigning.NormalizedBundle(bundleHash);
  finally
    ASigning.Free;
  end;
end;

function TBundle.CompareTo(Obj: TObject): Integer;
begin
  if Assigned(FTransactions) and (FTransactions.Count > 0) and Assigned((Obj as TBundle).FTransactions) and ((Obj as TBundle).FTransactions.Count > 0) then
    Result := CompareValue(FTransactions[0].AttachmentTimestamp, (Obj as TBundle).FTransactions[0].AttachmentTimestamp)
  else
    Result := 0;
end;

function TBundle.GetTransactions: TList<ITransaction>;
begin
  Result := FTransactions;
end;

end.
