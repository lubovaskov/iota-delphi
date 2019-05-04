unit DIOTA.Utils.InputValidator;

interface

uses
  System.Classes,
  Generics.Collections,
  DIOTA.Model.Transfer,
  DIOTA.Model.Input;

type
  {
   * This class provides methods to validate the parameters of different iota API methods.
   *
  }
  TInputValidator = class
  public
    {
     * Determines whether the specified string is a isSeed.
     *
     * @param seed The seed to validate.
     * @return <code>true</code> if the specified string is a seed; otherwise, <code>false</code>.
    }
    class function IsSeed(ASeed: String): Boolean;
    {
     * Determines whether the specified string is an address.
     * Address must contain a checksum to be valid
     *
     * @param address The address to validate.
     * @return <code>true</code> if the specified string is an address; otherwise, <code>false</code>.
    }
    class function IsAddress(address: String): Boolean;
    {
     * According to the following issue:
     * https://github.com/iotaledger/trinity-wallet/issues/866
     *
     * This is because Curl addresses always are with a 0 trit on the end
     * So we validate if we actually send to a proper address, to prevent having to double spent
     *
     * @param address The trytes to check
     * @return <code>true</code> if the specified trytes end with 0, otherwise <code>false</code>.
    }
    class function HasTrailingZeroTrit(trytes: String): Boolean;
    {
     * Determines whether the specified string is an address without checksum.
     *
     * @param address The address to validate.
     * @return <code>true</code> if the specified string is an address; otherwise, <code>false</code>.
    }
    class function IsAddressWithoutChecksum(address: String): Boolean;
    {
     * Determines whether the specified addresses are valid.
     * Addresses must contain a checksum to be valid.
     *
     * @param addresses The address list to validate.
     * @return <code>true</code> if the specified addresses are valid; otherwise, <code>false</code>.
    }
    class function IsAddressesCollectionValid(const addresses: TStrings): Boolean;
    {
     * Determines whether the specified addresses are valid.
     * Addresses must contain a checksum to be valid.
     *
     * @param addresses The address array to validate.
     * @return <code>true</code> if the specified addresses are valid; otherwise, <code>false</code>.
    }
    class function IsAddressesArrayValid(addresses: TArray<String>): Boolean;
    {
     * Checks whether the specified address is an address and throws and exception if the address is invalid.
     * Addresses must contain a checksum to be valid.
     *
     * @param address The address to validate.
     * @return <code>true</code> if the specified string is an address; otherwise, <code>false</code>.
     * @throws ArgumentException when the specified input is not valid.
    }
    class function CheckAddress(address: String): Boolean;
    {
     * Checks whether the specified address is an address without checksum
     * and throws and exception if the address is invalid.
     *
     * @param address The address to validate.
     * @return <code>true</code> if the specified string is an address; otherwise, <code>false</code>.
     * @throws ArgumentException when the specified input is not valid.
    }
    class function CheckAddressWithoutChecksum(address: String): Boolean;
    {
     * Determines whether the specified string contains only characters from the trytes alphabet
     * @param trytes The trytes to validate.
     * @return <code>true</code> if the specified trytes are trytes, otherwise <code>false</code>.
    }
    class function IsTrytes(trytes: String): Boolean;
    {
     * Determines whether the specified string contains only characters from the trytes alphabet.
     *
     * @param trytes The trytes to validate.
     * @param length The length.
     * @return <code>true</code> if the specified trytes are trytes and have the correct size, otherwise <code>false</code>.
    }
    class function IsTrytesOfExactLength(trytes: String; length: Integer): Boolean;
    {
     * Determines whether the specified string contains only characters from the trytes alphabet
     * and has a maximum (including) of the provided length
     * @param trytes The trytes to validate.
     * @param maxLength The length.
     * @return <code>true</code> if the specified trytes are trytes and have the correct size, otherwise <code>false</code>.
    }
    class function IsTrytesOfMaxLength(trytes: String; maxLength: Integer): Boolean;
    {
     * Determines whether the specified string consist only of '9'.
     *
     * @param trytes The trytes to validate.
     * @return <code>true</code> if the specified string consist only of '9'; otherwise, <code>false</code>.
    }
    class function IsEmptyTrytes(trytes: String): Boolean;
    {
     * Determines whether the specified string consist only of '9'.
     *
     * @param trytes The trytes to validate.
     * @param length The length.
     * @return <code>true</code> if the specified string consist only of '9'; otherwise, <code>false</code>.
    }
    class function IsNinesTrytes(const trytes: String; const length: Integer): Boolean;
    {
     * Determines whether the specified string represents a signed integer.
     *
     * @param value The value to validate.
     * @return <code>true</code> the specified string represents an integer value; otherwise, <code>false</code>.
    }
    class function IsValue(const value: String): Boolean;
    {
     * Deprecated due to ambigue function name, please switch to @link #areTransactionTrytes
     * Determines whether the specified string array contains only trytes of a transaction length
     * @param trytes The trytes array to validate.
     * @return <code>true</code> if the specified array contains only valid trytes otherwise, <code>false</code>.
    }
    class function IsArrayOfTrytes(trytes: TArray<String>): Boolean; deprecated;
    {
     * Determines whether the specified array contains only valid hashes.
     *
     * @param hashes The hashes array to validate.
     * @return <code>true</code> the specified array contains only valid hashes; otherwise, <code>false</code>.
    }
    class function IsArrayOfHashes(hashes: TArray<String>): Boolean;
    {
     * Determines whether the specified transfers are valid.
     *
     * @param transfers The transfers list to validate.
     * @return <code>true</code> if the specified transfers are valid; otherwise, <code>false</code>.
     * @throws ArgumentException when the specified input is not valid.
    }
    class function IsTransfersCollectionValid(const transfers: TList<ITransfer>): Boolean;
    {
     * Determines whether the specified transfer is valid.
     *
     * @param transfer The transfer to validate.
     * @return <code>true</code> if the specified transfer is valid; otherwise, <code>false</code>.
    }
    class function IsValidTransfer(const transfer: ITransfer): Boolean;
    {
     * Checks if the tags are valid.
     *
     * @param tags The tags to validate.
     * @return <code>true</code> if the specified tags are valid; otherwise, <code>false</code>.
    }
    class function AreValidTags(tags: TArray<String>): Boolean;
    {
     * Checks if the tag is valid.
     *
     * @param tag The tag to validate.
     * @return <code>true</code> if the specified tag is valid; otherwise, <code>false</code>.
    }
    class function IsValidTag(tag: String): Boolean;
    {
     * Checks if the inputs are valid.
     *
     * @param inputs The inputs to validate.
     * @return <code>true</code> if the specified inputs are valid; otherwise, <code>false</code>.
    }
    class function AreValidInputsList(inputs: TList<IInput>): Boolean;
    {
     * Checks if the inputs are valid.
     *
     * @param inputs The inputs to validate.
     * @return <code>true</code> if the specified inputs are valid; otherwise, <code>false</code>.
    }
    class function AreValidInputs(inputs: TArray<IInput>): Boolean;
    {
     * Checks if the input is valid.
     *
     * @param input The input to validate.
     * @return <code>true</code> if the specified input is valid; otherwise, <code>false</code>.
    }
    class function IsValidInput(input: IInput): Boolean;
    {
     * Checks if the seed is valid.
     *
     * @param seed The input to validate.
     * @return <code>true</code> if the specified input is valid; otherwise, <code>false</code>.
    }
    class function IsValidSeed(seed: String): Boolean;
    {
     * Checks if input is correct hashes.
     *
     * @param hashes The hashes list to validate.
     * @return <code>true</code> if the specified hashes are valid; otherwise, <code>false</code>.
    }
    class function IsHashes(hashes: TStrings): Boolean;
    {
     * Checks if input is correct hash.
     *
     * @param hash The hash to validate.
     * @return <code>true</code> if the specified hash are valid; otherwise, <code>false</code>.
    }
    class function IsHash(hash: String): Boolean;
    {
     * Checks if the uris are valid.
     *
     * @param uris The uris to validate.
     * @return <code>true</code> if the specified uris are valid; otherwise, <code>false</code>.
    }
    class function AreValidUris(uris: TArray<String>): Boolean;
    {
     * Checks if the uri is valid.
     *
     * @param uri The uri to validate.
     * @return <code>true</code> if the specified uri is valid; otherwise, <code>false</code>.
    }
    class function IsValidUri(uri: String): Boolean;
    {
      * Determines whether the specified string array contains only trytes of a transaction length
      * @param trytes The trytes array to validate.
      * @return <code>true</code> if the specified array contains only valid trytes otherwise, <code>false</code>.
    }
    class function AreTransactionTrytes(trytes: TArray<String>): Boolean;
    {
     * Checks if attached trytes if last 241 trytes are non-zero
     *
     * @param trytes The trytes.
     * @return <code>true</code> if the specified trytes are valid; otherwise, <code>false</code>.
    }
    class function IsArrayOfAttachedTrytes(trytes: TArray<String>): Boolean;
    {
     * Checks if the security level is valid
     * @param level the level
     * @return <code>true</code> if the level is between 1 and 3(inclusive); otherwise, <code>false</code>.
    }
    class function IsValidSecurityLevel(level: Integer): Boolean;
  end;

implementation

uses
  System.SysUtils,
  System.StrUtils,
  System.RegularExpressions,
  DIOTA.Utils.Constants,
  DIOTA.Utils.Converter;

{ TInputValidator }

class function TInputValidator.IsSeed(ASeed: String): Boolean;
begin
  Result := (Length(ASeed) <= SEED_LENGTH) and IsTrytes(ASeed);
end;

class function TInputValidator.IsAddress(address: String): Boolean;
begin
  Result := (Length(address) = ADDRESS_LENGTH_WITH_CHECKSUM) and IsTrytes(address);
end;

class function TInputValidator.HasTrailingZeroTrit(trytes: String): Boolean;
var
  ATrits: TArray<Integer>;
begin
  ATrits := TConverter.Trits(trytes);
  Result := ATrits[High(ATrits)] = 0;
end;

class function TInputValidator.IsAddressWithoutChecksum(address: String): Boolean;
begin
  Result := IsTrytesOfExactLength(address, ADDRESS_LENGTH_WITHOUT_CHECKSUM);
end;

class function TInputValidator.IsAddressesCollectionValid(const addresses: TStrings): Boolean;
var
  address: String;
begin
  Result := True;
  for address in addresses do
    if not CheckAddress(address) then
      begin
        Result := False;
        Break;
      end;
end;

class function TInputValidator.IsAddressesArrayValid(addresses: TArray<String>): Boolean;
var
  address: String;
begin
  Result := True;
  for address in addresses do
    if not CheckAddress(address) then
      begin
        Result := False;
        Break;
      end;
end;

class function TInputValidator.CheckAddress(address: String): Boolean;
begin
  Result := True;
  if not IsAddress(address) then
    raise Exception.Create(INVALID_ADDRESSES_INPUT_ERROR);
end;

class function TInputValidator.CheckAddressWithoutChecksum(address: String): Boolean;
begin
  Result := True;
  if not IsTrytesOfExactLength(address, ADDRESS_LENGTH_WITHOUT_CHECKSUM) then
    raise Exception.Create(INVALID_ADDRESSES_INPUT_ERROR);
end;

class function TInputValidator.IsTrytes(trytes: String): Boolean;
begin
  Result := IsTrytesOfExactLength(trytes, 0);
end;

class function TInputValidator.IsTrytesOfExactLength(trytes: String; length: Integer): Boolean;
begin
  if length < 0 then
    Result := False
  else
    Result := TRegEx.IsMatch(trytes, '^[A-Z9]{' + IfThen(length = 0, '0,', IntToStr(length)) + '}$');
end;

class function TInputValidator.IsTrytesOfMaxLength(trytes: String; maxLength: Integer): Boolean;
begin
  if Length(trytes) > maxLength then
    Result := False
  else
    Result := IsTrytesOfExactLength(trytes, 0);
end;

class function TInputValidator.IsEmptyTrytes(trytes: String): Boolean;
begin
  Result := IsNinesTrytes(trytes, 0);
end;

class function TInputValidator.IsNinesTrytes(const trytes: String;const length: Integer): Boolean;
begin
  Result := TRegEx.IsMatch(trytes, '^[9]{' + IfThen(length = 0, '0,', IntToStr(length)) + '}$');
end;

class function TInputValidator.IsValue(const value: String): Boolean;
var
  i: Integer;
begin
  Result := TryStrToInt(value, i);
end;

class function TInputValidator.IsArrayOfTrytes(trytes: TArray<String>): Boolean;
var
  tryte: String;
begin
  Result := True;
  for tryte in trytes do
    // Check if correct 2673 trytes
    if not IsTrytesOfExactLength(tryte, TRANSACTION_SIZE) then
      begin
        Result := False;
        Break;
      end;
end;

class function TInputValidator.IsArrayOfHashes(hashes: TArray<String>): Boolean;
var
  hash: String;
begin
  if Length(hashes) = 0 then
    Result := False
  else
    begin
      Result := True;
      for hash in hashes do
        if not IsHash(hash) then
          begin
            Result := False;
            Break;
          end;
    end;
end;

class function TInputValidator.IsTransfersCollectionValid(const transfers: TList<ITransfer>): Boolean;
var
  transfer: ITransfer;
begin
  // Input validation of transfers object
  if (not Assigned(transfers)) or (transfers.Count = 0) then
    raise Exception.Create(INVALID_TRANSFERS_INPUT_ERROR)
  else
    begin
      Result := True;
      for transfer in transfers do
        if not IsValidTransfer(transfer) then
          begin
            Result := False;
            Break;
          end;
    end;
end;

class function TInputValidator.IsValidTransfer(const transfer: ITransfer): Boolean;
begin
  if not Assigned(transfer) then
    Result := False
  else
  if not IsAddress(transfer.Address) then
    Result := False
  else
  // Check if message is correct trytes encoded of any length
  if not IsTrytesOfExactLength(transfer.Message, Length(transfer.Message)) then
    Result := False
  else
  // Check if tag is correct trytes encoded and not longer than 27 trytes
    Result := IsValidTag(transfer.Tag);
end;

class function TInputValidator.AreValidTags(tags: TArray<String>): Boolean;
var
  tag: String;
begin
  // Input validation of tags
  if Length(tags) = 0 then
    Result := False
  else
    begin
      Result := True;
      for tag in tags do
        if not IsValidTag(tag) then
          begin
            Result := False;
            Break;
          end;
    end;
end;

class function TInputValidator.IsValidTag(tag: String): Boolean;
begin
  Result := (Length(tag) <= TAG_LENGTH) and IsTrytes(tag);
end;

class function TInputValidator.AreValidInputs(inputs: TArray<IInput>): Boolean;
var
  input: IInput;
begin
  // Input validation of input objects
  if Length(inputs)= 0 then
    Result := False
  else
    begin
      Result := True;
      for input in inputs do
        if not IsValidInput(input) then
          begin
            Result := False;
            Break;
          end;
    end;
end;

class function TInputValidator.AreValidInputsList(inputs: TList<IInput>): Boolean;
begin
  Result := AreValidInputs(inputs.ToArray);
end;

class function TInputValidator.IsValidInput(input: IInput): Boolean;
begin
  if not Assigned(input) then
    Result := False
  else
  if not IsAddress(input.Address) then
    Result := False
  else
  if input.KeyIndex < 0 then
    Result := False
  else
    Result := IsValidSecurityLevel(input.Security);
end;

class function TInputValidator.IsValidSeed(seed: String): Boolean;
begin
  if Length(seed) > SEED_LENGTH then
    Result := False
  else
    Result := IsTrytes(seed);
end;

class function TInputValidator.IsHashes(hashes: TStrings): Boolean;
var
  hash: String;
begin
  if (not Assigned(hashes)) or (hashes.Count = 0) then
    Result := False
  else
     begin
       Result := True;
       for hash in hashes do
         if not IsHash(hash) then
           begin
             Result := False;
             Break;
           end;
     end;
end;

class function TInputValidator.IsHash(hash: String): Boolean;
begin
  // Check if address with checksum
  if Length(hash) = ADDRESS_LENGTH_WITH_CHECKSUM then
    Result := IsTrytesOfExactLength(hash, 0) //We already checked length
  else
    Result := IsTrytesOfExactLength(hash, ADDRESS_LENGTH_WITHOUT_CHECKSUM);
end;

class function TInputValidator.AreValidUris(uris: TArray<String>): Boolean;
var
  uri: String;
begin
  if Length(uris) = 0 then
    Result := False
  else
     begin
       Result := True;
       for uri in uris do
         if not IsValidUri(uri) then
           begin
             Result := False;
             Break;
           end;
     end;
end;

class function TInputValidator.IsValidUri(uri: String): Boolean;
var
  protocol: String;
begin
  if Length(uri) < 7 then
    Result := False
  else
    begin
      protocol := Copy(uri, 1, 6);
      if (protocol <> 'tcp://') and (protocol <> 'udp://') then
        Result := False
      else
        Result := True; //ValidateURI(uri); //TODO: Find a function that validates a URI
    end;
end;

class function TInputValidator.AreTransactionTrytes(trytes: TArray<String>): Boolean;
var
  tryteValue: String;
begin
  Result := True;
  for tryteValue in trytes do
    // Check if correct 2673 trytes
    if not IsTrytesOfExactLength(tryteValue, TRANSACTION_SIZE) then
      begin
        Result := False;
        Break;
      end;
end;

class function TInputValidator.IsArrayOfAttachedTrytes(trytes: TArray<String>): Boolean;
var
  tryteValue: String;
  lastTrytes: String;
begin
  Result := True;
  for tryteValue in trytes do
    // Check if correct 2673 trytes
    if not IsTrytesOfExactLength(tryteValue, TRANSACTION_SIZE) then
      begin
        Result := False;
        Break;
      end
    else
      begin
        lastTrytes := Copy(tryteValue, 1, TRANSACTION_SIZE - (3 * 81));
        if IsNinesTrytes(lastTrytes, Length(lastTrytes)) then
          begin
            Result := False;
            Break;
          end;
      end;
end;

class function TInputValidator.IsValidSecurityLevel(level: Integer): Boolean;
begin
  Result := (level >= MIN_SECURITY_LEVEL) and (level <= MAX_SECURITY_LEVEL);
end;

end.
