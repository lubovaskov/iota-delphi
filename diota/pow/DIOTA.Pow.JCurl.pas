unit DIOTA.Pow.JCurl;

interface

uses
  DIOTA.Pow.ICurl,
  DIOTA.Utils.Pair,
  DIOTA.Pow.SpongeFactory;

type
  {
   * (c) 2016 Come-from-Beyond
   *
   * TJCurl belongs to the sponge function family.
  }
  TJCurl = class(TInterfacedObject, ICurl)
  private
    var
      numberOfRounds: Integer;
      stateLow: TArray<Int64>;
      stateHigh: TArray<Int64>;
      scratchpad: TArray<Integer>;
      state: TArray<Integer>;
    class var
      TRUTH_TABLE: TArray<Integer>;
  public
    const
      HASH_LENGTH = Integer(243);
  private
    const
      STATE_LENGTH = Integer(3 * HASH_LENGTH);
      NUMBER_OF_ROUNDSP81 = Integer(81);
      NUMBER_OF_ROUNDSP27 = Integer(27);
    constructor Create; overload;
    procedure DoSet;
    procedure PairTransform;
  public
    class constructor Initialize;
    constructor Create(mode: TSpongeFactory.Mode); overload; virtual;
    constructor Create(pair: Boolean; mode: TSpongeFactory.Mode); overload; virtual;
    {
     * Absorbs the specified trits.
     *
     * @param trits  The trits.
     * @param offset The offset to start from.
     * @param length The length.
     * @return The ICurl instance (used for method chaining).
    }
    function Absorb(const trits: TArray<Integer>; offset: Integer; length: Integer): ICurl; overload; virtual;
    {
     * Absorbs the specified trits.
     *
     * @param trits The trits.
     * @return The ICurl instance (used for method chaining).
    }
    function Absorb(const trits: TArray<Integer>): ICurl; overload;
    {
     * Transforms this instance.
     *
     * @return The ICurl instance (used for method chaining).
    }
    function Transform: ICurl;
    {
     * Resets this state.
     *
     * @return The ICurl instance (used for method chaining).
    }
    function Reset: ICurl; overload; virtual;
    function Reset(pair: Boolean): ICurl; overload;
    {
     * Squeezes the specified trits.
     *
     * @param trits  The trits.
     * @param offset The offset to start from.
     * @param length The length.
     * @return The squeezes trits.
    }
    procedure Squeeze(var trits: TArray<Integer>; const offset: Integer; const length: Integer); overload; virtual;
    procedure Squeeze(var trits: TArray<Integer>); overload; virtual;
    {
     * Gets the states.
     *
     * @return The state.
    }
    function GetState: TArray<Integer>;
    {
     * Sets the state.
     *
     * @param state The states.
    }
    procedure SetState(state: TArray<Integer>);

    procedure Absorb(const pair: TPair<TArray<Int64>, TArray<Int64>>; offset: Integer; length: Integer); overload;
    function Squeeze(const pair: TPair<TArray<Int64>, TArray<Int64>>; offset: Integer; length: Integer): TPair<TArray<Int64>, TArray<Int64>>; overload;
    {
     * Clones this instance.
     *
     * @return A new instance.
    }
    function Clone: ICurl; virtual;
  end;

implementation

uses
  System.SysUtils,
  System.Math,
  DIOTA.Utils.Converter;

{ TJCurl }

class constructor TJCurl.Initialize;
begin
  TRUTH_TABLE := [1, 0, -1, 2, 1, -1, 0, 2, -1, 1, 0];
end;

constructor TJCurl.Create;
begin
  SetLength(scratchpad, STATE_LENGTH);
end;

constructor TJCurl.Create(mode: TSpongeFactory.Mode);
begin
  Create(False, mode);
end;

constructor TJCurl.Create(pair: Boolean; mode: TSpongeFactory.Mode);
begin
  Create;
  case mode of
    TSpongeFactory.Mode.CURLP27:
      numberOfRounds := NUMBER_OF_ROUNDSP27;
    TSpongeFactory.Mode.CURLP81:
      numberOfRounds := NUMBER_OF_ROUNDSP81;
    else
      raise Exception.Create('Only Curl-P-27 and Curl-P-81 are supported.');
  end;

  if pair then
    begin
      SetLength(stateHigh, STATE_LENGTH);
      SetLength(stateLow, STATE_LENGTH);
      state := [];
    end
  else
    begin
      SetLength(state, STATE_LENGTH);
      stateHigh := [];
      stateLow := [];
    end;
end;

function TJCurl.Absorb(const trits: TArray<Integer>; offset: Integer; length: Integer): ICurl;
var
  AOffset: Integer;
  ALength: Integer;
  i: Integer;
begin
  AOffset := offset;
  ALength := length;
  repeat
    for i := 0 to IfThen(ALength < HASH_LENGTH, ALength, HASH_LENGTH) - 1 do
      state[i] := trits[AOffset + i];

    Transform;
    Inc(AOffset, HASH_LENGTH);
    Dec(ALength, HASH_LENGTH);
  until ALength <= 0;

  Result := Self;
end;

function TJCurl.Absorb(const trits: TArray<Integer>): ICurl;
begin
  Result := Absorb(trits, 0, Length(trits));
end;

function TJCurl.Transform: ICurl;
var
  AScratchpadIndex: Integer;
  APrevScratchpadIndex: Integer;
  i: Integer;
  ARound: Integer;
  AStateIndex: Integer;
begin
  AScratchpadIndex := 0;
  for ARound := 0 to numberOfRounds - 1 do
    begin
      for i := 0 to STATE_LENGTH - 1 do
        scratchpad[i] := state[i];

      for AStateIndex := 0 to STATE_LENGTH - 1 do
        begin
          APrevScratchpadIndex := AScratchpadIndex;
          if AScratchpadIndex < 365 then
            Inc(AScratchpadIndex, 364)
          else
            Dec(AScratchpadIndex, 365);
          state[AStateIndex] := TRUTH_TABLE[scratchpad[APrevScratchpadIndex] + (scratchpad[AScratchpadIndex] shl 2) + 5];
        end;
    end;

  Result := Self;
end;

function TJCurl.Reset: ICurl;
begin
  if Length(state) > 0 then
    FillChar(state[0], Length(state), 0);
  Result := Self;
end;

function TJCurl.Reset(pair: Boolean): ICurl;
begin
  if pair then
    DoSet
  else
    Reset;

  Result := Self;
end;

procedure TJCurl.Squeeze(var trits: TArray<Integer>; const offset: Integer; const length: Integer);
var
  AOffset: Integer;
  ALength: Integer;
  i: Integer;
begin
  AOffset := offset;
  ALength := length;
  repeat
    for i := 0 to IfThen(ALength < HASH_LENGTH, ALength, HASH_LENGTH) - 1 do
      trits[i + AOffset] := state[i];

    Transform;
    Inc(AOffset, HASH_LENGTH);
    Dec(ALength, HASH_LENGTH);
  until ALength <= 0;
end;

procedure TJCurl.Squeeze(var trits: TArray<Integer>);
begin
  Squeeze(trits, 0, Length(trits));
end;

function TJCurl.GetState: TArray<Integer>;
begin
  Result := state;
end;

procedure TJCurl.SetState(state: TArray<Integer>);
begin
  Self.state := state;
end;

procedure TJCurl.DoSet;
begin
  if Length(stateLow) > 0 then
    FillChar(stateLow[0], Length(stateLow), TConverter.HIGH_LONG_BITS);
  if Length(stateHigh) > 0 then
    FillChar(stateHigh[0], Length(stateHigh), TConverter.HIGH_LONG_BITS);
end;

procedure TJCurl.PairTransform;
var
  ACurlScratchpadLow: TArray<Int64>;
  ACurlScratchpadHigh: TArray<Int64>;
  ACurlScratchpadIndex: Integer;
  ACurlStateIndex: Integer;
  ARound: Integer;
  alpha, beta, gamma, delta: Int64;
  i: Integer;
begin
  SetLength(ACurlScratchpadLow, STATE_LENGTH);
  SetLength(ACurlScratchpadHigh, STATE_LENGTH);
  ACurlScratchpadIndex := 0;
  for ARound := numberOfRounds - 1 downto 0 do
    begin
      for i := 0 to STATE_LENGTH - 1 do
        ACurlScratchpadLow[i] := stateLow[i];
      for i := 0 to STATE_LENGTH - 1 do
        ACurlScratchpadHigh[i] := stateHigh[i];
      for ACurlStateIndex := 0 to STATE_LENGTH - 1 do
        begin
          alpha := ACurlScratchpadLow[ACurlScratchpadIndex];
          beta :=  ACurlScratchpadHigh[ACurlScratchpadIndex];
          if ACurlScratchpadIndex < 365 then
            Inc(ACurlScratchpadIndex, 364)
          else
            Dec(ACurlScratchpadIndex, 365);
          gamma := ACurlScratchpadHigh[ACurlScratchpadIndex];
          delta := (alpha or (not gamma)) and (ACurlScratchpadLow[ACurlScratchpadIndex] xor beta);
          stateLow[ACurlStateIndex] := not delta;
          stateHigh[ACurlStateIndex] := (alpha xor gamma) or delta;
        end;
    end;
end;

procedure TJCurl.Absorb(const pair: TPair<TArray<Int64>, TArray<Int64>>; offset: Integer; length: Integer);
var
  i: Integer;
  AOffset: Integer;
  ALength: Integer;
begin
  AOffset := offset;
  ALength := length;
  repeat
    for i := 0 to IfThen(ALength < HASH_LENGTH, ALength, HASH_LENGTH) - 1 do
      stateLow[i] := pair.Low[i + AOffset];
    for i := 0 to IfThen(ALength < HASH_LENGTH, ALength, HASH_LENGTH) - 1 do
      stateHigh[i] := pair.Hi[i + AOffset];
    PairTransform;
    Inc(AOffset, HASH_LENGTH);
    Dec(ALength, HASH_LENGTH);
  until ALength <= 0;
end;

function TJCurl.Squeeze(const pair: TPair<TArray<Int64>, TArray<Int64>>; offset: Integer; length: Integer): TPair<TArray<Int64>, TArray<Int64>>;
var
  i: Integer;
  AOffset: Integer;
  ALength: Integer;
  ALow, AHi: TArray<Int64>;
begin
  AOffset := offset;
  ALength := length;
  ALow := pair.Low;
  AHi := pair.Hi;
  repeat
    for i := 0 to IfThen(ALength < HASH_LENGTH, ALength, HASH_LENGTH) - 1 do
      ALow[i + AOffset] := stateLow[i];
    for i := 0 to IfThen(ALength < HASH_LENGTH, ALength, HASH_LENGTH) - 1 do
      AHi[i + AOffset] := stateHigh[i];

    PairTransform;
    Inc(AOffset, HASH_LENGTH);
    Dec(ALength, HASH_LENGTH);
  until ALength <= 0;

  Result := TPair<TArray<Int64>, TArray<Int64>>.Create(ALow, AHi);
end;

function TJCurl.Clone: ICurl;
begin
  Result := TJCurl.Create(TSpongeFactory.Mode.CURLP81);
end;

end.
