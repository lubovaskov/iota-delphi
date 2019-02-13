unit DIOTA.Utils.Signing;

interface

uses
  DIOTA.Pow.ICurl,
  DIOTA.Pow.SpongeFactory,
  DIOTA.Model.Bundle;

type
  TSigning = class
  private
    FCurl: ICurl;
    function GetICurlObject(mode: TSpongeFactory.Mode): ICurl;
  public
    constructor Create; overload; virtual;
    constructor Create(curl: ICurl); overload; virtual;

    {
     * Returns the sub-seed trits given a seed and an index
     * @param inSeed the seed
     * @param index the index
     * @return the sub-seed
    }
    function Subseed(inSeed: TArray<Integer>; index: Integer): TArray<Integer>;
    {
     * Generates the key which is needed as a part of address generation.
     * Used in @link #digests(int[])
     * Calculates security based on <code>inSeed length / key length</code>
     *
     * @param inSeed    Tryte-encoded seed. It should be noted that this seed is not transferred.
     * @param index     Key index for the address
     * @return The key
     * @throws ArgumentException is thrown when the specified security level is not valid
     * @throws ArgumentException is thrown when inSeed length is not dividable by 3
     * @throws ArgumentException is thrown when index is below 1
    }
    function Key(inSeed: TArray<Integer>; index: Integer): TArray<Integer>; overload;
    {
     * Generates the key which is needed as a part of address generation.
     * Used in @link #digests(int[])
     *
     * @param inSeed    Tryte-encoded seed. It should be noted that this seed is not transferred.
     * @param index     Key index for the address
     * @param security  Security level to be used for the private key / address. Can be 1, 2 or 3.
     * @return The key
     * @throws ArgumentException is thrown when the specified security level is not valid
     * @throws ArgumentException is thrown when inSeed length is not dividable by 3
     * @throws ArgumentException is thrown when index is below 1
    }
    function Key(inSeed: TArray<Integer>; index: Integer; security: Integer): TArray<Integer>; overload;
    {
     * Address generates the address trits from the given digests.
     * @param digests the digests
     * @return the address trits
    }
    function Address(digests: TArray<Integer>): TArray<Integer>;
    {
     * Digests hashes each segment of each key fragment 26 times and returns them.
     * @param key the key trits
     * @return the digests
     * @throws ArgumentException if the security level is invalid
    }
    function Digests(key: TArray<Integer>): TArray<Integer>;
    {
     *
     * @param normalizedBundleFragment
     * @param signatureFragment
     * @return The digest
    }
    function Digest(normalizedBundleFragment: TArray<Integer>; signatureFragment: TArray<Integer>): TArray<Integer>;
    function SignatureFragment(normalizedBundleFragment: TArray<Integer>; keyFragment: TArray<Integer>): TArray<Integer>;
    function ValidateSignatures(signedBundle: IBundle; inputAddress: String): Boolean; overload;
    function ValidateSignatures(expectedAddress: String; signatureFragments: TArray<String>; bundleHash: String): Boolean; overload;
    {
     * Normalizes the given bundle hash, with resulting digits summing to zero.
     * It returns a slice with the tryte decimal representation without any 13/M values.
     * @param bundleHash the bundle hash
     * @return the normalized bundle hash in trits
    }
    function NormalizedBundle(bundleHash: String): TArray<Integer>;
  end;

implementation

uses
  System.Classes,
  System.SysUtils,
  System.Math,
  DIOTA.Pow.JCurl,
  DIOTA.Utils.Constants,
  DIOTA.Utils.InputValidator,
  DIOTA.Utils.Converter,
  DIOTA.Model.Transaction;

{ TSigning }

constructor TSigning.Create;
begin
  Create(nil);
end;

constructor TSigning.Create(curl: ICurl);
begin
  if Assigned(curl) then
    FCurl := curl
  else
    FCurl := TSpongeFactory.Create(TSpongeFactory.Mode.KERL);
end;

function TSigning.Subseed(inSeed: TArray<Integer>; index: Integer): TArray<Integer>;
var
  i, j: Integer;
begin
  if index < 0 then
    raise Exception.Create(INVALID_INDEX_INPUT_ERROR);

  Result := Copy(inSeed, 0, Length(inSeed));

  {
   *
   * index 0 = [0,0,0,1,0,-1,0,1,1,0,-1,1,-1,0]
   * index 1 = [1,0,0,1,0,-1,0,1,1,0,-1,1,-1,0]
   * index 2 = [-1,1,0,1,0,-1,0,1,1,0,-1,1,-1,0]
   * index 3 = [0,1,0,1,0,-1,0,1,1,0,-1,1,-1,0]
  }

  // Derive subseed.
  for i := 0 to index - 1 do
    for j := 0 to High(Result) do
      begin
        Result[j] := Result[j] + 1;
        if Result[j] > 1 then
          Result[j] := -1
        else
          Break;
      end;
end;

function TSigning.Key(inSeed: TArray<Integer>; index: Integer): TArray<Integer>;
begin
  Result := Key(inSeed, index, Floor(Length(inSeed) / KEY_LENGTH));
end;

function TSigning.Key(inSeed: TArray<Integer>; index: Integer; security: Integer): TArray<Integer>;
var
  ASeed: TArray<Integer>;
  ACurl: ICurl;
  ABuffer: TArray<Integer>;
  AOffset: Integer;
  i, j: Integer;
  ASecurity: Integer;
begin
  if not TInputValidator.isValidSecurityLevel(security) then
    raise Exception.Create(INVALID_SECURITY_LEVEL_INPUT_ERROR);

  if (Length(inSeed) mod 3) <> 0 then
    raise Exception.Create(INVALID_SEED_INPUT_ERROR);

  ASeed := Subseed(inSeed, index);

  ACurl := GetICurlObject(TSpongeFactory.Mode.KERL);
  ACurl.Reset;
  ACurl.Absorb(ASeed, 0, Length(ASeed));
  // seed[0..HASH_LENGTH] contains subseed
  ACurl.Squeeze(ASeed, 0, Length(ASeed));
  ACurl.Reset;
  // absorb subseed
  ACurl.Absorb(ASeed, 0, Length(ASeed));

  SetLength(Result, security * TJCurl.HASH_LENGTH * 27);
  SetLength(ABuffer, Length(ASeed));
  AOffset := 0;
  ASecurity := security;

  while ASecurity > 0 do
    begin
      for i := 0 to 26 do
        begin
          ACurl.Squeeze(ABuffer, 0, Length(ASeed));
          for j := 0 to TJCurl.HASH_LENGTH - 1 do
            Result[j + AOffset] := ABuffer[j];
          Inc(AOffset, TJCurl.HASH_LENGTH);
        end;
      Dec(ASecurity);
    end;
end;

function TSigning.Address(digests: TArray<Integer>): TArray<Integer>;
var
  ACurl: ICurl;
begin
  SetLength(Result, TJCurl.HASH_LENGTH);
  ACurl := GetICurlObject(TSpongeFactory.Mode.KERL);
  ACurl.Reset;
  ACurl.Absorb(digests);
  ACurl.Squeeze(Result);
end;

function TSigning.Digests(key: TArray<Integer>): TArray<Integer>;
var
  ASecurity: Integer;
  AKeyFragment: TArray<Integer>;
  ACurl: ICurl;
  i, j, k, l: Integer;
begin
  ASecurity := Floor(Length(key) / KEY_LENGTH);
  if not TInputValidator.IsValidSecurityLevel(ASecurity) then
    raise Exception.Create(INVALID_SECURITY_LEVEL_INPUT_ERROR);

  SetLength(Result, ASecurity * TJCurl.HASH_LENGTH);
  SetLength(AKeyFragment, KEY_LENGTH);

  ACurl := GetICurlObject(TSpongeFactory.Mode.KERL);
  for i := 0 to Floor(Length(key) / KEY_LENGTH) - 1 do
    begin
      for j := 0 to KEY_LENGTH - 1 do
        AKeyFragment[j] := key[i * KEY_LENGTH + j];

      for k := 0 to 26 do
        for l := 0 to 25 do
          ACurl.Reset
            .Absorb(AKeyFragment, k * TJCurl.HASH_LENGTH, TJCurl.HASH_LENGTH)
            .Squeeze(AKeyFragment, k * TJCurl.HASH_LENGTH, TJCurl.HASH_LENGTH);

      ACurl.Reset;
      ACurl.Absorb(AKeyFragment, 0, Length(AKeyFragment));
      ACurl.Squeeze(Result, i * TJCurl.HASH_LENGTH, TJCurl.HASH_LENGTH);
    end;
end;

function TSigning.Digest(normalizedBundleFragment, signatureFragment: TArray<Integer>): TArray<Integer>;
var
  ACurl: ICurl;
  i, j: Integer;
begin
  FCurl.Reset;
  ACurl := GetICurlObject(TSpongeFactory.Mode.KERL);

  for i := 0 to 26 do
    begin
      Result := Copy(signatureFragment, i * TJCurl.HASH_LENGTH, TJCurl.HASH_LENGTH);

      for j := normalizedBundleFragment[i] + 12 downto 0 do
        begin
          ACurl.Reset;
          ACurl.Absorb(Result);
          ACurl.Squeeze(Result);
        end;
      FCurl.Absorb(Result);
    end;
  FCurl.Squeeze(Result);
end;

function TSigning.SignatureFragment(normalizedBundleFragment, keyFragment: TArray<Integer>): TArray<Integer>;
var
  i, j: Integer;
begin
  Result := Copy(keyFragment, 0, Length(keyFragment));

  for i := 0 to 26 do
    for j := 0 to 12 - normalizedBundleFragment[i] do
      FCurl.Reset
        .Absorb(Result, i * TJCurl.HASH_LENGTH, TJCurl.HASH_LENGTH)
        .Squeeze(Result, i * TJCurl.HASH_LENGTH, TJCurl.HASH_LENGTH);
end;

function TSigning.ValidateSignatures(signedBundle: IBundle; inputAddress: String): Boolean;
var
  ABundleHash: String;
  ATrx: ITransaction;
  ASignatureFragments: TStringList;
  i: Integer;
  ASignatureFragment: String;
begin
  ASignatureFragments := TStringList.Create;
  try
    for i := 0 to signedBundle.Transactions.Count - 1 do
      begin
        ATrx := signedBundle.Transactions[i];

        if ATrx.Address = inputAddress then
          begin
            ABundleHash := ATrx.Bundle;

            // if we reached remainder bundle
            ASignatureFragment := ATrx.SignatureFragments;
            if TInputValidator.IsNinesTrytes(ASignatureFragment, Length(ASignatureFragment)) then
              Break;
          end;
        ASignatureFragments.Add(ASignatureFragment);
      end;
    Result := ValidateSignatures(inputAddress, ASignatureFragments.ToStringArray, ABundleHash);
  finally
    ASignatureFragments.Free;
  end;
end;

function TSigning.ValidateSignatures(expectedAddress: String; signatureFragments: TArray<String>; bundleHash: String): Boolean;
var
  ANormalizedBundleFragments: TArray<TArray<Integer>>;
  ANormalizedBundleHash: TArray<Integer>;
  i, j: Integer;
  ADigests: TArray<Integer>;
  ADigestBuffer: TArray<Integer>;
begin
  SetLength(ANormalizedBundleFragments, 3);
  ANormalizedBundleHash := NormalizedBundle(bundleHash);

  // Split hash into 3 fragments
  for i := 0 to 2 do
    ANormalizedBundleFragments[i] := Copy(ANormalizedBundleHash, i * 27, 27);

  // Get digests
  SetLength(ADigests, Length(signatureFragments) * TJCurl.HASH_LENGTH);

  for i := 0 to High(signatureFragments) do
    begin
      ADigestBuffer := Digest(ANormalizedBundleFragments[i mod 3], TConverter.Trits(signatureFragments[i]));
      for j := 0 to TJCurl.HASH_LENGTH - 1 do
        ADigests[i * TJCurl.HASH_LENGTH + j] := ADigestBuffer[j];
    end;
  Result := expectedAddress = TConverter.Trytes(Address(ADigests));
end;

function TSigning.GetICurlObject(mode: TSpongeFactory.Mode): ICurl;
begin
  Result := TSpongeFactory.create(mode);
end;

function TSigning.NormalizedBundle(bundleHash: String): TArray<Integer>;
var
  i, j: Integer;
  ASum: Int64;
begin
  SetLength(Result, 81);
  for i := 0 to 2 do
    begin
      ASum := 0;
      for j := 0 to 26 do
        begin
          Result[i * 27 + j] := TConverter.Value(TConverter.Trits(bundleHash[i * 27 + j + 1]));
          Inc(ASum, Result[i * 27 + j]);
        end;

      if ASum >= 0 then
        while ASum > 0 do
          begin
            Dec(ASum);
            for j := 0 to 26 do
              if Result[i * 27 + j] > -13 then
                begin
                  Result[i * 27 + j] := Result[i * 27 + j] - 1;
                  Break;
                end;
          end
      else
        while ASum < 0 do
          begin
            Inc(ASum);
            for j := 0 to 26 do
              if Result[i * 27 + j] < 13 then
                begin
                  Result[i * 27 + j] := Result[i * 27 + j] + 1;
                  Break;
                end;
          end;
    end;
end;

end.
