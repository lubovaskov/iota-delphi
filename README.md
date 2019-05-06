<img src="img/iota_black.png" width="80" height="80">

# IOTA Delphi client library

[![License][license-badge]][license]
[![IOTA IRI compatibility][iota-iri-badge]][iota-iri]
[![IOTA API coverage][iota-api-badge]][iota-api]

This is an unofficial Delphi client library for IOTA, which allows you to do the following:
* Create transactions
* Sign transactions
* Generate addresses
* Interact with an IRI node

This is beta software, so there may be performance and stability issues.
Please report any issues in our [issue tracker](https://github.com/lubovaskov/iota-delphi/issues/new).

|Table of contents|
|:----|
| [Prerequisites](#prerequisites)
| [Setting up the library](#setting-up-the-library)|
| [Getting started](#getting-started) |
| [Supporting the project](#supporting-the-project)|
| [License](#license)

## Prerequisites

* Delphi XE6 or newer

## Setting up the library

* Download and copy the `diota` folder to your projects folder.
* Add the following paths to the Search path of your project:
```diota
diota\utils
diota\pow
diota\model
diota\libs\keccak
diota\dto\request
diota\dto\response
```

## Getting Started

This example shows you how to create and send a transaction to an IRI node by calling the [`SendTransfer`](diota/DIOTA.IotaAPI#IIotaAPI.SendTransfer) method.

```delphi
uses
  System.Generics.Collections,
  DIOTA.IotaAPI,
  DIOTA.Utils.TrytesConverter,
  DIOTA.Model.Input,
  DIOTA.Model.Transfer,
  DIOTA.Dto.Response.SendTransferResponse,
  DIOTA.Dto.Response.GetBalancesAndFormatResponse;

var
  IotaAPI: IIotaAPI;
  Seed: String;
  Address: String;
  Value: Int64;
  TransactionMessage: String;
  Tag: String;
  Security: Integer;
  Depth: Integer;
  MinWeightMagnitude: Integer;
  RemainderAddress: String;
  Inputs: TList<IInput>;
  InputsRes: TGetBalancesAndFormatResponse;
  Transfers: TList<ITransfer>;
  Transfer: ITransfer;
  TransfersRes: TSendTransferResponse;  
  
begin
  IotaAPI := IotaAPIBuilder  // replace with your IRI node
    .Protocol('https')
    .Host('trinity.iota-tangle.io')
    .Port(14265)
    .Timeout(5000)
    .Build;

  // The seed must be truly random & 81-trytes long.
  Seed := '<SENDER SEED>';

  // Recipient address, must not have been spent from
  Address := '<RECIPIENT ADDRESS>';

  // An unspent sender address that will receive the remaining IOTAs, if any
  RemainderAddress := '<REMAINDER ADDRESS>';

  // Transaction value in IOTA, may be 0
  Value := 1;

  // Optional transaction message
  TransactionMessage := TTrytesConverter.AsciiToTrytes('DIOTA9MESSAGE');

  // Optional transaction tag
  Tag := 'DIOTA9TAG';

  //security level (1, 2 or 3)
  Security := 2;

  // Depth or how far to go for tip selection entry point
  Depth := 9;

  // Difficulty of Proof-of-Work required to attach the transaction to tangle.
  // Minimum value on mainnet & spamnet is `14`, `9` on devnet and other testnets.
  MinWeightMagnitude := 14;

  if Value > 0 then
    begin
      // Get a list of sender addresses to take IOTAs from
      InputsRes := IotaAPI.GetInputs(Seed, Security, 0, 10, Value, nil);
      try
        Inputs := InputsRes.InputsList;
      finally
        InputsRes.Free;
      end;
    end
  else
    Inputs := nil;

  // Create a new transfer to the recepient address using the supplied parameters
  Transfer := TTransferBuilder.CreateTransfer(Address, Value, TransactionMessage, Tag);

  // List of transfers which defines transaction recipients, value transferred in IOTAs and transaction messages
  Transfers := TList<ITransfer>.Create;
  try
    Transfers.Add(Transfer);
    // Prepare the bundle, sign and send it
    TransfersRes := IotaAPI.SendTransfer(Seed, Security, Depth, MinWeightMagnitude, Transfers, Inputs, RemainderAddress, True, True, nil);
    try
      if Assigned(TransfersRes) then
        ShowMessage('Successful transactions: ' + IntToStr(TransfersRes.SuccessfullyCount))
      else
        ShowMessage('Error sending transfers!');
    finally
      TransfersRes.Free;
    end;
  finally
    Transfers.Free;
    if Assigned(Inputs) then
      Inputs.Free;
  end;
end;
```

## Supporting the project

If the IOTA Delphi client library has been useful to you and you feel like contributing, consider posting a [bug report](https://github.com/lubovaskov/iota-delphi/issues/new), [feature request](https://github.com/lubovaskov/iota-delphi/issues/new),    [pull request](https://github.com/lubovaskov/iota-delphi/pulls/) or a donation to address
`TGLRUQBV9QOCHYVXLRKMFMBURXOMXMJMBIWDZZNFKWLU9TGNNWH9AJM9K9BSKVDNFUA9LNTTCNODDICYXZZCJODNKC`

## License

The MIT license can be found [here](LICENSE).

[license]: https://raw.githubusercontent.com/lubovaskov/iota-delphi/master/LICENSE
[license-badge]: https://img.shields.io/badge/license-MIT-blue.svg
[iota-iri]: https://github.com/iotaledger/iri/tree/v1.5.5
[iota-iri-badge]: https://img.shields.io/badge/IOTA%20IRI%20compatibility-v1.5.5-blue.svg
[iota-api]: https://iota.readme.io/reference
[iota-api-badge]: https://img.shields.io/badge/IOTA%20API%20coverage-15/15%20commands-green.svg
