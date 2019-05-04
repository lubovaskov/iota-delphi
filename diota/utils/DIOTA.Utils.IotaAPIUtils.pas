unit DIOTA.Utils.IotaAPIUtils;

interface

uses
  System.Classes,
  Generics.Collections,
  DIOTA.Model.Input,
  DIOTA.Model.Bundle,
  DIOTA.Pow.ICurl;

type
  {
   * Client Side computation service.
  }
  TIOTAAPIUtils = class
  public
    {
     * Generates a new address
     *
     * @param seed     The tryte-encoded seed. It should be noted that this seed is not transferred.
     * @param security The secuirty level of private key / seed.
     * @param index    The index to start search from. If the index is provided, the generation of the address is not deterministic.
     * @param checksum The adds 9-tryte address checksum
     * @param curl     The curl instance.
     * @return An String with address.
     * @throws ArgumentException is thrown when the specified input is not valid.
    }
    class function NewAddress(seed: String; security: Integer; index: Integer; checksum: Boolean; curl: ICurl): String;
    {
     * Finalizes and signs the bundle transactions.
     * Bundle and inputs are assumed correct.
     *
     * @param seed The tryte-encoded seed. It should be noted that this seed is not transferred.
     * @param inputs
     * @param bundle The bundle
     * @param signatureFragments
     * @param curl The curl instance.
     * @return list of transaction trytes in the bundle
     * @throws ArgumentException When the seed is invalid
    }
    class function SignInputsAndReturn(seed: String; inputs: TList<IInput>; bundle: IBundle;
                                       signatureFragments: TStrings; curl: ICurl): TStringList;
  end;

implementation

uses
  System.SysUtils,
  DIOTA.Utils.Constants,
  DIOTA.Utils.InputValidator,
  DIOTA.Utils.Signing,
  DIOTA.Utils.Converter,
  DIOTA.Utils.Checksum,
  DIOTA.Model.Transaction;

{ TIOTAAPIUtils }

class function TIOTAAPIUtils.NewAddress(seed: String; security, index: Integer; checksum: Boolean; curl: ICurl): String;
var
  ASigning: TSigning;
  AKey: TArray<Integer>;
  ADigests: TArray<Integer>;
  AAddressTrits: TArray<Integer>;
begin
  if not TInputValidator.IsValidSecurityLevel(security) then
    raise Exception.Create(INVALID_SECURITY_LEVEL_INPUT_ERROR);

  ASigning := TSigning.Create(curl);
  try
    AKey := ASigning.Key(TConverter.Trits(seed), index, security);
    ADigests := ASigning.Digests(AKey);
    AAddressTrits := ASigning.Address(ADigests);
  finally
    ASigning.Free;
  end;

  Result := TConverter.Trytes(AAddressTrits);
  if checksum then
    Result := TChecksum.AddChecksum(Result);
end;

class function TIOTAAPIUtils.SignInputsAndReturn(seed: String; inputs: TList<IInput>; bundle: IBundle;
                                                 signatureFragments: TStrings; curl: ICurl): TStringList;
var
  i, j: Integer;
  AThisAddress: String;
  AKeyIndex: Integer;
  AKeySecurity: Integer;
  ABundleHash: String;
  AKey: TArray<Integer>;
  ANormalizedBundleHash: TArray<Integer>;
  AInput: IInput;
  AHashPart: Integer;
  AKeyFragment: TArray<Integer>;
  ABundleFragment: TArray<Integer>;
  ASignedFragment: TArray<Integer>;
begin
  if not TInputValidator.IsValidSeed(seed) then
    raise Exception.Create(INVALID_SEED_INPUT_ERROR);

  if not TInputValidator.AreValidInputsList(inputs) then
    raise Exception.Create(INVALID_INPUT_ERROR);

  bundle.Finalize(curl);
  bundle.AddTrytes(signatureFragments);

  //  SIGNING OF INPUTS
  //
  //  Here we do the actual signing of the inputs
  //  Iterate over all bundle transactions, find the inputs
  //  Get the corresponding private key and calculate the signatureFragment
  for i := bundle.Transactions.Count - 1 downto 0 do
    begin
      if bundle.Transactions[i].Value < 0 then
        begin
          AThisAddress := bundle.Transactions[i].Address;

          // Get the corresponding keyIndex of the address
          AKeyIndex := 0;
          AKeySecurity := 0;
          for AInput in inputs do
            if TChecksum.RemoveChecksum(AInput.Address) = AThisAddress then
              begin
                AKeyIndex := AInput.KeyIndex;
                AKeySecurity := AInput.Security;
              end;

          ABundleHash := bundle.Transactions[i].Bundle;

          // Get corresponding private key of address
          with TSigning.Create(curl) do
            begin
              AKey := Key(TConverter.Trits(seed), AKeyIndex, AKeySecurity);
              Free;
            end;

          //  Get the normalized bundle hash
          ANormalizedBundleHash := bundle.NormalizedBundle(ABundleHash);

          // for each security level, add signature
          for j := 0 to AKeySecurity - 1 do
            begin
              AHashPart := j mod 3;

              //  Add parts of signature for bundles with same address
              if bundle.Transactions[i + j].Address = AThisAddress then
                begin
                  // Use 6562 trits starting from j*6561
                  AKeyFragment := Copy(AKey, 6561 * j, 6561);

                  // The current part of the bundle hash
                  ABundleFragment := Copy(ANormalizedBundleHash, 27 * AHashPart, 27);

                  //  Calculate the new signature
                  with TSigning.Create(curl) do
                    begin
                      ASignedFragment := SignatureFragment(ABundleFragment, AKeyFragment);
                      Free;
                    end;

                  //  Convert signature to trytes and assign it again to this bundle entry
                  bundle.Transactions[i + j].SetSignatureFragments(TConverter.Trytes(ASignedFragment));
                end
              else
                raise Exception.Create('Inconsistent security-level and transactions');
            end;
        end;
    end;

  Result := TStringList.Create;
  for i := bundle.Transactions.Count - 1 downto 0 do
    // Convert all bundle entries into trytes
    Result.Add(bundle.Transactions[i].ToTrytes);
end;

end.
