unit DIOTA.Utils.Multisig;

interface

uses
  DIOTA.Pow.ICurl,
  DIOTA.Utils.Signing,
  DIOTA.Model.Bundle;

type
  TMultisig = class
  private
    FCurl: ICurl;
    FSigningInstance: TSigning;
  public
    {
     * Initializes a new instance of the Multisig class.
    }
    constructor Create(customCurl: ICurl); overload; virtual;
    {
     * Initializes a new instance of the Multisig class.
    }
    constructor Create; overload; virtual;
    destructor Destroy; override;
    {
     * @param seed     Tryte-encoded seed. It should be noted that this seed is not transferred.
     * @param security Secuirty level of private key / seed.
     * @param index    Key index to start search from. If the index is provided, the generation of the address is not deterministic.
     * @return trytes
     * @throws ArgumentException is thrown when the specified security level is not valid.
    }
    function GetDigest(seed: String; security: Integer; index: Integer): String;
    {
     * Initiates the generation of a new multisig address or adds the key digest to an existing one
     *
     * @param digestTrytes
     * @param curlStateTrytes
     * @return trytes.
    }
    function AddAddressDigest(digestTrytes: String; curlStateTrytes: String): String;
    {
     * Gets the key value of a seed
     *
     * @param seed  Tryte-encoded seed. It should be noted that this seed is not transferred
     * @param index Key index to start search from. If the index is provided, the generation of the address is not deterministic.
     * @return trytes.
     * @throws ArgumentException is thrown when the specified security level is not valid.
    }
    function GetKey(seed: String; index: Integer; security: Integer): String;
    {
     * Generates a new address
     *
     * @param curlStateTrytes
     * @return address
    }
    function FinalizeAddress(curlStateTrytes: String): String;
    {
     * Validates  a generated multisig address
     *
     * @param multisigAddress
     * @param digests
     * @return <t>true</t> if the digests turn into multiSigAddress, otherwise <t>false</t>
    }
    function ValidateAddress(multisigAddress: String; digests: TArray<TArray<Integer>>): Boolean;
    {
     * Adds the cosigner signatures to the corresponding bundle transaction
     *
     * @param bundleToSign
     * @param inputAddress
     * @param keyTrytes
     * @return Returns bundle trytes.
    }
    function AddSignature(bundleToSign: IBundle; inputAddress: String; keyTrytes: String): IBundle;
  end;

implementation

uses
  DIOTA.Pow.SpongeFactory,
  DIOTA.Utils.Converter,
  DIOTA.Utils.Constants,
  DIOTA.Utils.InputValidator;

{ TMultisig }

constructor TMultisig.Create(customCurl: ICurl);
begin
  FCurl := customCurl;
  FCurl.Reset;
  FSigningInstance := TSigning.Create(FCurl.Clone);
end;

constructor TMultisig.Create;
begin
  Create(TSpongeFactory.Create(TSpongeFactory.Mode.KERL));
end;

destructor TMultisig.Destroy;
begin
  FCurl := nil;
  FSigningInstance.Free;
  inherited;
end;

function TMultisig.GetDigest(seed: String; security, index: Integer): String;
var
  AKey: TArray<Integer>;
begin
  AKey := FSigningInstance.Key(TConverter.Trits(seed, 243), index, security);
  Result := TConverter.trytes(FSigningInstance.Digests(AKey));
end;

function TMultisig.AddAddressDigest(digestTrytes, curlStateTrytes: String): String;
var
  ADigest: TArray<Integer>;
  ACurlState: TArray<Integer>;
begin
  ADigest := TConverter.Trits(digestTrytes, Length(digestTrytes) * 3);

  // If curlStateTrytes is provided, convert into trits
  // else use empty state and initiate the creation of a new address
  if curlStateTrytes <> '' then
    ACurlState := TConverter.Trits(curlStateTrytes, Length(digestTrytes) * 3)
  else
    SetLength(ACurlState, Length(digestTrytes) * 3);

  // initialize Curl with the provided state
  FCurl.SetState(ACurlState);
  // absorb the key digest
  FCurl.Absorb(ADigest);

  Result := TConverter.Trytes(FCurl.GetState);
end;

function TMultisig.GetKey(seed: String; index, security: Integer): String;
begin
  Result := TConverter.Trytes(FSigningInstance.Key(TConverter.Trits(seed, 81 * security), index, security));
end;

function TMultisig.FinalizeAddress(curlStateTrytes: String): String;
var
  ACurlState: TArray<Integer>;
  AAddressTrits: TArray<Integer>;
begin
  ACurlState := TConverter.Trits(curlStateTrytes);

  // initialize Curl with the provided state
  FCurl.SetState(ACurlState);

  SetLength(AAddressTrits, 243);
  FCurl.Squeeze(AAddressTrits);

  // Convert trits into trytes and return the address
  Result := TConverter.Trytes(AAddressTrits);
end;

function TMultisig.ValidateAddress(multisigAddress: String; digests: TArray<TArray<Integer>>): Boolean;
var
  AKeyDigest: TArray<Integer>;
  AAddressTrits: TArray<Integer>;
begin
  // initialize Curl with the provided state
  FCurl.Reset();

  for AKeyDigest in digests do
    FCurl.Absorb(AKeyDigest);

  SetLength(AAddressTrits, 243);
  FCurl.Squeeze(AAddressTrits);

  // Convert trits into trytes and return the address
  Result := TConverter.Trytes(AAddressTrits) = multisigAddress;
end;

function TMultisig.AddSignature(bundleToSign: IBundle; inputAddress, keyTrytes: String): IBundle;
var
  ASecurity: Integer;
  AKey: TArray<Integer>;
  ANumSignedTxs: Integer;
  i, j: Integer;
  ABundleHash: String;
  AFirstFragment: TArray<Integer>;
  ANormalizedBundleFragments: TArray<TArray<Integer>>;
  ANormalizedBundleHash: TArray<Integer>;
  AFirstBundleFragment: TArray<Integer>;
  AFirstSignedFragment: TArray<Integer>;
  ANextFragment: TArray<Integer>;
  ANextBundleFragment: TArray<Integer>;
  ANextSignedFragment: TArray<Integer>;
begin
  // Get the security used for the private key
  // 1 security level = 2187 trytes
  ASecurity := (Length(keyTrytes) div MESSAGE_LENGTH);

  // convert private key trytes into trits
  AKey := TConverter.Trits(keyTrytes);

  // First get the total number of already signed transactions
  // use that for the bundle hash calculation as well as knowing
  // where to add the signature
  ANumSignedTxs := 0;

  for i := 0 to bundleToSign.Transactions.Count - 1 do
    if bundleToSign.Transactions[i].Address = inputAddress then
      // If transaction is already signed, increase counter
      if not TInputValidator.IsNinesTrytes(bundleToSign.Transactions[i].SignatureFragments, Length(bundleToSign.Transactions[i].SignatureFragments)) then
        Inc(ANumSignedTxs)
      else
        // Else sign the transactions
        begin
          ABundleHash := bundleToSign.Transactions[i].Bundle;

          //  First 6561 trits for the firstFragment
          AFirstFragment := Copy(AKey, 0, 6561);

          //  Get the normalized bundle hash
          SetLength(ANormalizedBundleFragments, 3);
          ANormalizedBundleHash := bundleToSign.NormalizedBundle(ABundleHash);

          // Split hash into 3 fragments
          for j := 0 to 2 do
            ANormalizedBundleFragments[j] := Copy(ANormalizedBundleHash, j * 27, 27);

          //  First bundle fragment uses 27 trytes
          AFirstBundleFragment := ANormalizedBundleFragments[ANumSignedTxs mod 3];

          //  Calculate the new signatureFragment with the first bundle fragment
          AFirstSignedFragment := FSigningInstance.SignatureFragment(AFirstBundleFragment, AFirstFragment);

          //  Convert signature to trytes and assign the new signatureFragment
          bundleToSign.Transactions[i].SetSignatureFragments(TConverter.Trytes(AFirstSignedFragment));

          for j := 1 to ASecurity - 1 do
            begin
              //  Next 6561 trits for the firstFragment
              ANextFragment := Copy(AKey, 6561 * j, 6561);

              //  Use the next 27 trytes
              ANextBundleFragment := ANormalizedBundleFragments[(ANumSignedTxs + j) mod 3];

              //  Calculate the new signatureFragment with the first bundle fragment
              ANextSignedFragment := FSigningInstance.SignatureFragment(ANextBundleFragment, ANextFragment);

              //  Convert signature to trytes and add new bundle entry at i + j position
              // Assign the signature fragment
              bundleToSign.Transactions[i + j].SetSignatureFragments(TConverter.Trytes(ANextSignedFragment));
            end;

          Break;
        end;

  Result := bundleToSign;
end;

end.
