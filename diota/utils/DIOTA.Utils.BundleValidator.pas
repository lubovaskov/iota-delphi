unit DIOTA.Utils.BundleValidator;

interface

uses
  DIOTA.Model.Bundle,
  DIOTA.Pow.ICurl,
  DIOTA.Pow.SpongeFactory;

type
  TBundleValidator = class
  public
    {
     * Validates all signatures of a bundle
     * @param bundle the bundle
     * @param customCurl
     * @return true if all signatures are valid. Otherwise false
    }
    class function ValidateSignatures(bundle: IBundle; customCurl: ICurl): Boolean;
    {
     * Checks if a bundle is syntactically valid.
     * Validates signatures and overall structure
     * @param bundle the bundle to verify
     * @return true if the bundle is valid.
     * @throws ArgumentException if there is an error with the bundle
    }
    class function IsBundle(bundle: IBundle): Boolean; overload;
    {
     * Checks if a bundle is syntactically valid.
     * Validates signatures and overall structure
     * @param bundle the bundle to verify
     * @param customCurlMode
     * @return true if the bundle is valid.
     * @throws ArgumentException if there is an error with the bundle
    }
    class function IsBundle(bundle: IBundle; customCurlMode: TSpongeFactory.Mode): Boolean; overload;
  end;

implementation

uses
  System.Classes,
  System.SysUtils,
  DIOTA.Utils.Constants,
  DIOTA.Utils.Signing,
  DIOTA.Utils.Converter,
  DIOTA.Model.Transaction,
  DIOTA.Pow.JCurl;

{ TBundleValidator }

class function TBundleValidator.ValidateSignatures(bundle: IBundle; customCurl: ICurl): Boolean;
var
  i, j: Integer;
  ATrx: ITransaction;
  AOtherTrx: ITransaction;
  AFragments: TStringList;
  ASigning: TSigning;
begin
  Result := True;
  for i := 0 to bundle.Transactions.Count - 1 do
    begin
      ATrx:= bundle.Transactions[i];

      // check whether input transaction
      if ATrx.Value >= 0 then
        Continue;

      AFragments := TStringList.Create;
      try
        AFragments.Add(ATrx.SignatureFragments);

        // find the subsequent txs containing the remaining signature
        // message fragments for this input transaction
        for j := i to bundle.Transactions.Count - 2 do
          begin
            AOtherTrx := bundle.Transactions[j + 1];
            if (AOtherTrx.Value <> 0) or (AOtherTrx.Address <> ATrx.Address) then
              Continue;
            AFragments.Add(AOtherTrx.SignatureFragments);
          end;

        ASigning := TSigning.Create(customCurl);
        try
          if not ASigning.ValidateSignatures(ATrx.Address, AFragments.ToStringArray, ATrx.Bundle) then
            begin
              Result := False;
              Break;
            end;
        finally
          ASigning.Free;
        end;
      finally
        AFragments.Free;
      end;
    end;
end;

class function TBundleValidator.IsBundle(bundle: IBundle): Boolean;
begin
  Result := IsBundle(bundle, TSpongeFactory.Mode.KERL);
end;

class function TBundleValidator.IsBundle(bundle: IBundle; customCurlMode: TSpongeFactory.Mode): Boolean;
var
  ACurl: ICurl;
  i, j: Integer;
  ATotalSum: Integer;
  ALastIndex: Integer;
  ATrx, ATrx2: ITransaction;
  ATrxTrits: TArray<Integer>;
  AFragments: TStringList;
  ASigning: TSigning;
  ABundleHashTrits: TArray<Integer>;
begin
  Result := True;
  ACurl := TSpongeFactory.Create(customCurlMode);
  ATotalSum := 0;
  ALastIndex := bundle.Transactions.Count - 1;

  for i := 0 to bundle.Transactions.Count - 1 do
    begin
      ATrx := bundle.Transactions[i];
      Inc(ATotalSum, ATrx.Value);

      if ATrx.CurrentIndex <> i then
        raise Exception.Create(INVALID_BUNDLE_ERROR);

      if ATrx.LastIndex <> ALastIndex then
        raise Exception.Create(INVALID_BUNDLE_ERROR);

      ATrxTrits := TConverter.Trits(Copy(ATrx.ToTrytes, 2188, 162));
      ACurl.Absorb(ATrxTrits);

      // continue if output or signature tx
      if ATrx.Value >= 0 then
        Continue;

      // here we have an input transaction (negative value)
      AFragments := TStringList.Create;
      try
        AFragments.Add(ATrx.SignatureFragments);

        // find the subsequent txs containing the remaining signature
        // message fragments for this input transaction
        for j := i to bundle.Transactions.Count - 2 do
          begin
            ATrx2 := bundle.Transactions[j + 1];

             // check if the tx is part of the input transaction
             if (ATrx.Address = ATrx2.Address) and (ATrx2.Value = 0) then
               // append the signature message fragment
               AFragments.Add(ATrx2.SignatureFragments);
          end;

        ASigning := TSigning.Create(ACurl.Clone);
        try
          if not ASigning.ValidateSignatures(ATrx.Address, AFragments.ToStringArray, ATrx.Bundle) then
            raise Exception.Create(INVALID_SIGNATURES_ERROR);
        finally
          ASigning.Free;
        end;
      finally
        AFragments.Free;
      end;
    end;

  // sum of all transaction must be 0
  if ATotalSum <> 0 then
    raise Exception.Create(INVALID_BUNDLE_SUM_ERROR);

  SetLength(ABundleHashTrits, TJCurl.HASH_LENGTH);
  ACurl.Squeeze(ABundleHashTrits, 0, TJCurl.HASH_LENGTH);
  if TConverter.Trytes(ABundleHashTrits) <> bundle.Transactions[0].Bundle then
    raise Exception.Create(INVALID_BUNDLE_HASH_ERROR);
end;

end.
