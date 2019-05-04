unit DIOTA.Utils.SeedRandomGenerator;

interface

type
  TSeedRandomGenerator = class
  public
    class function GenerateNewSeed: String;
  end;

implementation

uses
  {SynCrypto,} DIOTA.Utils.Constants;

{ TSeedRandomGenerator }

class function TSeedRandomGenerator.GenerateNewSeed: String;
var
  i: Integer;
begin
  Randomize;
  for i := 1 to SEED_LENGTH do
    Result := Result + TRYTE_ALPHABET[Random(Length(TRYTE_ALPHABET)) {TAESPRNG.Main.Random32(Length(TRYTE_ALPHABET))} + 1];
end;

end.
