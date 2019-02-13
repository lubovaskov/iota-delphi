unit DIOTA.Pow.Kerl;

interface

uses
  DIOTA.Pow.ICurl,
  DIOTA.Pow.JCurl,
  DIOTA.Utils.Pair,
  DIOTA.Pow.SpongeFactory,
  keccak_n;

type
  TSHA3_384_Hash = array[0..47] of Byte;

  TKerl = class(TJCurl)
  private
    const
      HASH_LENGTH = Integer(243);
      BIT_HASH_LENGTH = Integer(384);
      BYTE_HASH_LENGTH = Integer(BIT_HASH_LENGTH div 8);
      RADIX = Integer(3);
      MAX_TRIT_VALUE = Integer((RADIX - 1) div 2);
      MIN_TRIT_VALUE = Integer(-MAX_TRIT_VALUE);
      BYTE_LENGTH = Integer(48);
      INT_LENGTH = Integer(BYTE_LENGTH div 4);
    class var
      HALF_3: TArray<Integer>;
    var
      FKeccak: keccak_n.TSpongeState;

      byte_state: TSHA3_384_Hash;
      trit_state: TArray<Integer>;
    class function ToUnsignedLong(i: Integer): Int64;
    class function ToUnsignedInt(x: Shortint): Integer;
    class function Sum(toSum: TArray<Integer>): Integer;
    class procedure BigintNot(var base: TArray<Integer>);
    class function BigintAdd(var base: TArray<Integer>; const rh: Integer): Integer; overload;
    class function BigintAdd(const lh: TArray<Integer>; const rh: TArray<Integer>): TArray<Integer>; overload;
    class function BigintCmp(const lh: TArray<Integer>; const rh: TArray<Integer>): Integer;
    class function BigintSub(const lh: TArray<Integer>; const rh: TArray<Integer>): TArray<Integer>;
    class function FullAdd(const ia: Integer; const ib: Integer; const carry: Boolean): TPair<Integer, Boolean>;
  public
    class constructor Initialize;
    constructor Create;
    class function ConvertTritsToBytes(const trits: TArray<Integer>): RawByteString;
    class function ConvertBytesToTrits(const bytes: TSHA3_384_Hash): TArray<Integer>;
    function Reset: ICurl; override;
    function Absorb(const trits: TArray<Integer>; offset: Integer; length: Integer): ICurl; override;
    procedure Squeeze(var trits: TArray<Integer>; const offset: Integer; const len: Integer); overload; override;
    procedure Squeeze(var trits: TArray<Integer>); overload; override;
    function Clone: ICurl; override;
  end;

implementation

uses
  System.SysUtils;

{ TKerl }

class constructor TKerl.Initialize;
begin
  HALF_3 := [Integer($a5ce8964), Integer($9f007669), Integer($1484504f), Integer($3ade00d9), Integer($0c24486e),
             Integer($50979d57), Integer($79a4c702), Integer($48bbae36), Integer($a9f6808b), Integer($aa06a805),
             Integer($a87fabdf), Integer($5e69ebef)];
end;

constructor TKerl.Create;
begin
  inherited Create(TSpongeFactory.Mode.CURLP81);
  keccak_n.Init(FKeccak, 384);
  SetLength(trit_state, HASH_LENGTH);
end;

class function TKerl.ToUnsignedLong(i: Integer): Int64;
begin
  Result := i and $FFFFFFFF;
end;

class function TKerl.ToUnsignedInt(x: Shortint): Integer;
begin
  Result := x and $FF;
end;

class function TKerl.Sum(toSum: TArray<Integer>): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to High(toSum) do
    Inc(Result, toSum[i]);
end;

class function TKerl.ConvertTritsToBytes(const trits: TArray<Integer>): RawByteString;
var
  ABase: TArray<Integer>;
  i, j: Integer;
  ASize: Integer;
  sz: Integer;
  ACarry: Integer;
  v: Int64;
  ABytes: TArray<Shortint>;

  function ContainsOnlyMinusOne(intArray: TArray<Integer>): Boolean;
  var k: Integer;
  begin
    Result := Length(intArray) > 0;
    if Result then
      for k := 0 to High(intArray) do
        if intArray[k] <> -1 then
          begin
            Result := False;
            Break;
          end;
  end;

begin
  if Length(trits) <> TKerl.HASH_LENGTH then
    raise Exception.Create('Input trits length must be ' + IntToStr(TKerl.HASH_LENGTH) + ' in length');

  SetLength(ABase, INT_LENGTH);

  if ContainsOnlyMinusOne(trits) then
    begin
      for i := 0 to High(HALF_3) do
        ABase[i] := HALF_3[i];
      BigintNot(ABase);
      BigintAdd(ABase, 1);
    end
  else
    begin
      ASize := INT_LENGTH;
      for i := TKerl.HASH_LENGTH - 2 downto 0 do
        begin
          // Multiply by radix
          sz := ASize;
          ACarry := 0;
          for j := 0 to sz - 1 do
            begin
              // full_mul
              v := TKerl.ToUnsignedLong(ABase[j]) * TKerl.toUnsignedLong(RADIX) + TKerl.toUnsignedLong(ACarry);
              ACarry := Integer((v shr (SizeOf(Integer)*8)) and $FFFFFFFF);
              ABase[j] := Integer(v and $FFFFFFFF);
            end;

          if ACarry > 0 then
            begin
              ABase[sz] := ACarry;
              Inc(ASize);
            end;

          // Add
          sz := BigintAdd(ABase, trits[i] + 1);
          if sz > ASize then
            ASize := sz;
        end;

      if Sum(ABase) <> 0 then
        begin
          if BigintCmp(HALF_3, ABase) <= 0 then
            // base is >= HALF_3.
            // just do base - HALF_3
            ABase := BigintSub(ABase, HALF_3)
          else
            begin
              // we don't have a wrapping sub.
              // so we need to be clever.
              ABase := BigintSub(HALF_3, ABase);
              BigintNot(ABase);
              BigintAdd(ABase, 1);
            end;
        end;
    end;

  SetLength(ABytes, BYTE_LENGTH);
  for i := 0 to INT_LENGTH - 1 do
    begin
      ABytes[i * 4 + 0] := Shortint((ABase[INT_LENGTH - 1 - i] and $FF000000) shr 24);
      ABytes[i * 4 + 1] := Shortint((ABase[INT_LENGTH - 1 - i] and $00FF0000) shr 16);
      ABytes[i * 4 + 2] := Shortint((ABase[INT_LENGTH - 1 - i] and $0000FF00) shr 8);
      ABytes[i * 4 + 3] := Shortint((ABase[INT_LENGTH - 1 - i] and $000000FF) shr 0);
    end;

  SetString(Result, PAnsiChar(Pointer(ABytes)), Length(ABytes));
end;

class function TKerl.ConvertBytesToTrits(const bytes: TSHA3_384_Hash): TArray<Integer>;
var
  ABase: TArray<Integer>;
  i, j: Integer;
  AValue: Integer;
  AFlipTrits: Boolean;
  ARemainder: Integer;
  lhs, rhs: Int64;
begin
  if Length(bytes) <> BYTE_LENGTH then
    raise Exception.Create('Input base must be ' + IntToStr(BYTE_LENGTH) + ' in length');

  SetLength(ABase, INT_LENGTH);
  SetLength(Result, 243);
  Result[TKerl.HASH_LENGTH - 1] := 0;

  for i := 0 to INT_LENGTH - 1 do
    begin
      ABase[INT_LENGTH - 1 - i] := TKerl.ToUnsignedInt(bytes[i * 4]) shl 24;
      ABase[INT_LENGTH - 1 - i] := ABase[INT_LENGTH - 1 - i] or (TKerl.ToUnsignedInt(bytes[i * 4 + 1]) shl 16);
      ABase[INT_LENGTH - 1 - i] := ABase[INT_LENGTH - 1 - i] or (TKerl.ToUnsignedInt(bytes[i * 4 + 2]) shl 8);
      ABase[INT_LENGTH - 1 - i] := ABase[INT_LENGTH - 1 - i] or (TKerl.ToUnsignedInt(bytes[i * 4 + 3]));
    end;

  if BigintCmp(ABase, HALF_3) = 0 then
    begin
      AValue := 0;
      if ABase[0] > 0 then
        AValue := -1
      else
      if ABase[0] < 0 then
        AValue := 1;

      for i := 0 to TKerl.HASH_LENGTH - 1 do
        Result[i] := AValue;
    end
  else
    begin
      AFlipTrits := False;
      // See if we have a positive or negative two's complement number.
      if (TKerl.ToUnsignedLong(ABase[INT_LENGTH - 1]) shr 31) <> 0 then
        begin
          // negative value.
          BigintNot(ABase);
          if BigintCmp(ABase, HALF_3) > 0 then
            begin
              ABase := BigintSub(ABase, HALF_3);
              AFlipTrits := True;
            end
          else
            begin
              BigintAdd(ABase, 1);
              ABase := BigintSub(HALF_3, ABase);
            end;
        end
      else
        // positive. we need to shift right by HALF_3
        ABase := BigintAdd(HALF_3, ABase);

      for i := 0 to TKerl.HASH_LENGTH - 1 do
        begin
          //div_rem
          ARemainder := 0;
          for j := INT_LENGTH - 1 downto 0 do
            begin
              lhs := (TKerl.ToUnsignedLong(ARemainder) shl 32) or TKerl.ToUnsignedLong(ABase[j]);
              rhs := TKerl.ToUnsignedLong(RADIX);

              ABase[j] := lhs div rhs;
              ARemainder := lhs mod rhs;
            end;

          Result[i] := ARemainder - 1;
        end;

      if AFlipTrits then
        for i := 0 to High(Result) do
          Result[i] := -Result[i];
    end;
end;

class procedure TKerl.BigintNot(var base: TArray<Integer>);
var
  i: Integer;
begin
  for i := 0 to High(base) do
    base[i] := not base[i];
end;

class function TKerl.BigintAdd(var base: TArray<Integer>; const rh: Integer): Integer;
var
  ARes: TPair<Integer, Boolean>;
begin
  ARes := FullAdd(base[0], rh, False);
  try
    base[0] := ARes.Low;

    Result := 1;
    while ARes.Hi do
      begin
        FreeAndNil(ARes);
        ARes := FullAdd(base[Result], 0, True);
        base[Result] := ARes.Low;
        Inc(Result);
      end;
  finally
    if Assigned(Ares) then
      ARes.Free;
  end;
end;

class function TKerl.BigintAdd(const lh: TArray<Integer>; const rh: TArray<Integer>): TArray<Integer>;
var
  ACarry: Boolean;
  ARet: TPair<Integer, Boolean>;
  i: Integer;
begin
  SetLength(Result, INT_LENGTH);
  ACarry := False;

  for i := 0 to INT_LENGTH - 1 do
    begin
      ARet := FullAdd(lh[i], rh[i], ACarry);
      try
        Result[i] := ARet.Low;
        ACarry := ARet.Hi;
      finally
        ARet.Free;
      end;
    end;

  if ACarry then
    raise Exception.Create('Exceeded max value.');
end;

class function TKerl.BigintCmp(const lh, rh: TArray<Integer>): Integer;
var
  i: Integer;

  function Compare(A: Int64; B: Int64): Integer;
  begin
    if A > B then
      Result := 1
    else
    if A < B then
      Result := -1
    else
      Result := 0;
  end;

begin
  for i := INT_LENGTH - 1 downto 0 do
    begin
      Result := Compare(TKerl.ToUnsignedLong(lh[i]), TKerl.ToUnsignedLong(rh[i]));
      if Result <> 0 then
        Break;
    end;
end;

class function TKerl.BigintSub(const lh: TArray<Integer>; const rh: TArray<Integer>): TArray<Integer>;
var
  ANoBorrow: Boolean;
  ARet: TPair<Integer, Boolean>;
  i: Integer;
begin
  SetLength(Result, INT_LENGTH);
  ANoBorrow:= True;
  for i := 0 to INT_LENGTH - 1 do
    begin
      ARet := FullAdd(lh[i], not rh[i], ANoBorrow);
      try
        Result[i] := ARet.Low;
        ANoBorrow := ARet.Hi;
      finally
        ARet.Free;
      end;
    end;

  if not ANoBorrow then
    raise Exception.Create('noborrow');
end;

class function TKerl.FullAdd(const ia: Integer; const ib: Integer; const carry: Boolean): TPair<Integer, Boolean>;
var
  a: Int64;
  b: Int64;
  v: Int64;
  l: Int64;
  r: Int64;
  ACarry1: Boolean;
  ACarry2: Boolean;
begin
  a := TKerl.ToUnsignedLong(ia);
  b := TKerl.ToUnsignedLong(ib);
  v := a + b;
  l := v shr 32;
  r := v and $FFFFFFFF;
  ACarry1 := l <> 0;

  if carry then
    v := r + 1;

  l := (v shr 32) and $FFFFFFFF;
  r := v and $FFFFFFFF;
  ACarry2 := l <> 0;

  Result := TPair<Integer, Boolean>.Create(Integer(r), ACarry1 or ACarry2);
end;

function TKerl.Reset: ICurl;
begin
  keccak_n.Init(FKeccak, 384);

  Result := Self;
end;

function TKerl.Absorb(const trits: TArray<Integer>; offset: Integer; length: Integer): ICurl;
var
  AOffset: Integer;
  ALength: Integer;
  i: Integer;
  bytes: RawByteString;
begin
  if (length mod 243) <> 0 then
    raise Exception.Create('Illegal length: ' + IntToStr(length));

  AOffset := offset;
  ALength := length;
  repeat
    //copy trits[offset:offset+length]
    for i := 0 to HASH_LENGTH - 1 do
      trit_state[i] := trits[i + AOffset];

    //convert to bits
    trit_state[HASH_LENGTH - 1] := 0;
    bytes := ConvertTritsToBytes(trit_state);

    //run keccak
    keccak_n.Update(FKeccak, Pointer(bytes), System.Length(bytes)*8);

    Inc(AOffset, HASH_LENGTH);
    Dec(ALength, HASH_LENGTH);
  until ALength <= 0;

  Result := Self;
end;

procedure TKerl.Squeeze(var trits: TArray<Integer>; const offset: Integer; const len: Integer);
var
  AOffset: Integer;
  ALength: Integer;
  i: Integer;
begin
  if (len mod 243) <> 0 then
    raise Exception.Create('Illegal length: ' + IntToStr(len));

  AOffset := offset;
  ALength := len;
  repeat
    keccak_n.Final(FKeccak, @byte_state);
    keccak_n.Init(FKeccak, 384);

    //convert to trits
    trit_state := ConvertBytesToTrits(byte_state);

    //copy with offset
    trit_state[HASH_LENGTH - 1] := 0;
    for i := 0 to HASH_LENGTH - 1 do
      trits[i + AOffset] := trit_state[i];

    //calculate hash again
    for i := High(byte_state) downto 0 do
      byte_state[i] := byte_state[i] xor $FF;

    keccak_n.Update(FKeccak, @byte_state, System.Length(byte_state)*8);

    Inc(AOffset, HASH_LENGTH);
    Dec(ALength, HASH_LENGTH);
  until ALength <= 0;
end;

procedure TKerl.Squeeze(var trits: TArray<Integer>);
begin
  Squeeze(trits, 0, Length(trits));
end;

function TKerl.Clone: ICurl;
begin
  Result := TKerl.Create;
end;

end.
