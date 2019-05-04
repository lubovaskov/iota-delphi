unit DIOTA.Utils.Checksum;

interface

type
  {
   * This class defines utility methods to add/remove the checksum to/from an address.
  }
  TChecksum = class
  private
    class function RemoveChecksumFromAddress(addressWithChecksum: String): String;
    class function CalculateChecksum(address: String): String;
  public
    {
     * Adds the checksum to the specified address.
     *
     * @param address The address without checksum.
     * @return The address with the appended checksum.
     * @throws ArgumentException is thrown when the specified address is not a valid address, or already has a checksum.
    }
    class function AddChecksum(address: String): String;
    {
     * Remove the checksum to the specified address.
     *
     * @param address The address with checksum.
     * @return The address without checksum.
     * @throws ArgumentException is thrown when the specified address is not an address with checksum.
    }
    class function RemoveChecksum(address: String): String;
    {
     * Determines whether the specified address with checksum has a valid checksum.
     *
     * @param addressWithChecksum The address with checksum.
     * @return <code>true</code> if the specified address with checksum has a valid checksum [the specified address with checksum]; otherwise, <code>false</code>.
     * @throws ArgumentException is thrown when the specified address is not an valid address.
    }
    class function IsValidChecksum(addressWithChecksum: String): Boolean;
    {
     * Check if specified address is an address with checksum.
     *
     * @param address The address to check.
     * @return <code>true</code> if the specified address is with checksum ; otherwise, <code>false</code>.
     * @throws ArgumentException is thrown when the specified address is not an valid address.
    }
    class function IsAddressWithChecksum(address: String): Boolean;
    {
     * Check if specified address is an address without checksum.
     *
     * @param address The address to check.
     * @return <code>true</code> if the specified address is without checksum ; otherwise, <code>false</code>.
     * @throws ArgumentException is thrown when the specified address is not an valid address.
    }
    class function IsAddressWithoutChecksum(address: String): Boolean;
  end;

implementation

uses
  System.SysUtils,
  DIOTA.Utils.Constants,
  DIOTA.Utils.InputValidator,
  DIOTA.Utils.Converter,
  DIOTA.Pow.ICurl,
  DIOTA.Pow.JCurl,
  DIOTA.Pow.SpongeFactory;

{ TChecksum }

class function TChecksum.AddChecksum(address: String): String;
begin
  TInputValidator.CheckAddressWithoutChecksum(address);
  Result := address + CalculateChecksum(address);
end;

class function TChecksum.RemoveChecksum(address: String): String;
begin
  if IsAddressWithChecksum(address) then
    Result := RemoveChecksumFromAddress(address)
  else
  if IsAddressWithoutChecksum(address) then
    Result := address
  else
    raise Exception.Create(INVALID_ADDRESSES_INPUT_ERROR);
end;

class function TChecksum.RemoveChecksumFromAddress(addressWithChecksum: String): String;
begin
  Result := Copy(addressWithChecksum, 1, ADDRESS_LENGTH_WITHOUT_CHECKSUM);
end;

class function TChecksum.IsValidChecksum(addressWithChecksum: String): Boolean;
var
  addressWithoutChecksum: String;
begin
  addressWithoutChecksum := RemoveChecksum(addressWithChecksum);
  Result := addressWithChecksum = (addressWithoutChecksum + CalculateChecksum(addressWithoutChecksum));
end;

class function TChecksum.IsAddressWithChecksum(address: String): Boolean;
begin
  Result := TInputValidator.CheckAddress(address);
end;

class function TChecksum.IsAddressWithoutChecksum(address: String): Boolean;
begin
  Result := TInputValidator.CheckAddressWithoutChecksum(address);
end;

class function TChecksum.CalculateChecksum(address: String): String;
var
  ACurl: ICurl;
  AChecksumTrits: TArray<Integer>;
  AAddressTrits: TArray<Integer>;
  AChecksumTrytes: String;
begin
  ACurl := TSpongeFactory.Create(TSpongeFactory.Mode.KERL);
  ACurl.Reset;
  AAddressTrits := TConverter.trits(address);
  ACurl.Absorb(AAddressTrits);
  SetLength(AChecksumTrits, TJCurl.HASH_LENGTH);
  ACurl.Squeeze(AChecksumTrits);
  AChecksumTrytes := TConverter.Trytes(AChecksumTrits);
  Result := Copy(AChecksumTrytes, 73, 9);
end;

end.
