unit DIOTA.Utils.Converter;

interface

uses
  //System.SysUtils,
  Generics.Collections;

type
  {
   * This class provides a set of utility methods to are used to convert between different formats.
  }
  TConverter = class
  private
    const
      RADIX = Integer(3);
      MAX_TRIT_VALUE = Integer((RADIX - 1) div 2);
      MIN_TRIT_VALUE = Integer(-MAX_TRIT_VALUE);
      NUMBER_OF_TRITS_IN_A_BYTE = Integer(5);
      NUMBER_OF_TRITS_IN_A_TRYTE = Integer(3);
    class var
      BYTE_TO_TRITS_MAPPINGS: array[0..242] of TArray<Integer>;
      TRYTE_TO_TRITS_MAPPINGS: array[0..26] of TArray<Integer>;
  public
    const
      HIGH_INTEGER_BITS = Integer($FFFFFFFF);
      HIGH_LONG_BITS = Int64($FFFFFFFFFFFFFFFF);
    class constructor Initialize;
    class procedure Increment(var trits: TArray<Integer>; const size: Integer);
    class function Bytes(const trits: TArray<Integer>; const offset: Integer; const size: Integer): TArray<Shortint>; overload;
    class function Bytes(const trits: TArray<Integer>): TArray<Shortint>; overload;
    class procedure GetTrits(const bytes: TArray<Shortint>; var trits: TArray<Integer>);
    class function ConvertToIntArray(integers: TList<Integer>): TArray<Integer>;
    class function Trits(const trytes: String; length: Integer): TArray<Integer>; overload;
    class function Trits(const trytes: Int64; length: Integer): TArray<Integer>; overload;
    class function TritsString(const trytes: String): TArray<Integer>; deprecated;
    class function Trits(const trytes: Int64): TArray<Integer>; overload;
    class function Trits(const trytes: String): TArray<Integer>; overload;
    class function CopyTrits(const input: String; var destination: TArray<Integer>): TArray<Integer>;
    class function Trytes(const trits: TArray<Integer>; const offset: Integer; const size: Integer): String; overload;
    class function Trytes(const trits: TArray<Integer>): String; overload;
    class function TryteValue(const trits: TArray<Integer>; const offset: Integer): Integer;
    class function Value(const trits: TArray<Integer>): Integer;
    class function FromValue(value: Integer): TArray<Integer>;
    class function LongValue(const trits: TArray<Integer>): Int64;
  end;

implementation

uses
  System.Math,
  DIOTA.Utils.Constants;

{ TConverter }

class constructor TConverter.Initialize;
var
  i, j: Integer;
  trits: TArray<Integer>;
begin
  SetLength(trits, NUMBER_OF_TRITS_IN_A_BYTE);
  FillChar(trits[0], Length(trits), 0);

  for i := Low(BYTE_TO_TRITS_MAPPINGS) to High(BYTE_TO_TRITS_MAPPINGS) do
    begin
      SetLength(BYTE_TO_TRITS_MAPPINGS[i], NUMBER_OF_TRITS_IN_A_BYTE);
      for j := Low(BYTE_TO_TRITS_MAPPINGS[i]) to High(BYTE_TO_TRITS_MAPPINGS[i]) do
        BYTE_TO_TRITS_MAPPINGS[i][j] := trits[j];
      Increment(trits, NUMBER_OF_TRITS_IN_A_BYTE);
    end;

  for i := Low(TRYTE_TO_TRITS_MAPPINGS) to High(TRYTE_TO_TRITS_MAPPINGS) do
    begin
      SetLength(TRYTE_TO_TRITS_MAPPINGS[i], NUMBER_OF_TRITS_IN_A_TRYTE);
      for j := Low(TRYTE_TO_TRITS_MAPPINGS[i]) to High(TRYTE_TO_TRITS_MAPPINGS[i]) do
        TRYTE_TO_TRITS_MAPPINGS[i][j] := trits[j];
      Increment(trits, NUMBER_OF_TRITS_IN_A_TRYTE);
    end;
end;

class function TConverter.Bytes(const trits: TArray<Integer>; const offset, size: Integer): TArray<Shortint>;
var
  i, j: Integer;
  AValue: Integer;
  ABoundary: Integer;
begin
  SetLength(Result, (size + NUMBER_OF_TRITS_IN_A_BYTE - 1) div NUMBER_OF_TRITS_IN_A_BYTE);
  for i := Low(Result) to High(Result) do
    begin
      AValue := 0;
      if (size - i * NUMBER_OF_TRITS_IN_A_BYTE) < 5 then
        ABoundary := size - i * NUMBER_OF_TRITS_IN_A_BYTE
      else
        ABoundary := NUMBER_OF_TRITS_IN_A_BYTE;

      for j := ABoundary - 1 downto 0 do
        AValue := AValue * RADIX + trits[offset + i * NUMBER_OF_TRITS_IN_A_BYTE + j];

      Result[i] := AValue;
    end;
end;

class function TConverter.Bytes(const trits: TArray<Integer>): TArray<Shortint>;
begin
  Result := Bytes(trits, 0, Length(trits));
end;

class procedure TConverter.GetTrits(const bytes: TArray<Shortint>; var trits: TArray<Integer>);
var
  AOffset: Integer;
  i, j: Integer;
  ASourceIndex: Integer;
  ALength: Integer;
begin
  AOffset := 0;
  i := 0;
  while (i < Length(bytes)) and (AOffset < Length(trits)) do
    begin
      if bytes[i] < 0 then
        ASourceIndex := bytes[i] + Length(BYTE_TO_TRITS_MAPPINGS)
      else
        ASourceIndex := bytes[i];

      if (Length(trits) - AOffset) < NUMBER_OF_TRITS_IN_A_BYTE then
        ALength := Length(trits) - AOffset
      else
        ALength := NUMBER_OF_TRITS_IN_A_BYTE;

      for j := 0 to ALength - 1 do
        trits[AOffset + j] := BYTE_TO_TRITS_MAPPINGS[ASourceIndex][j];

      Inc(AOffset, NUMBER_OF_TRITS_IN_A_BYTE);
      Inc(i);
    end;

  while AOffset < Length(trits) do
    begin
      trits[AOffset] := 0;
      Inc(AOffset);
    end;
end;

class function TConverter.ConvertToIntArray(integers: TList<Integer>): TArray<Integer>;
begin
  Result := integers.ToArray;
end;

class function TConverter.Trits(const trytes: String; length: Integer): TArray<Integer>;
var
  i: Integer;
  Res: TArray<Integer>;
begin
  SetLength(Result, length);
  FillChar(Result[0], System.Length(Result), 0);
  Res := Trits(trytes);
  for i := 0 to Min(length, System.Length(Res)) - 1 do
    Result[i] := Res[i];
end;

class function TConverter.Trits(const trytes: Int64; length: Integer): TArray<Integer>;
var
  i: Integer;
  Res: TArray<Integer>;
begin
  SetLength(Result, length);
  FillChar(Result[0], System.Length(Result), 0);
  Res := Trits(trytes);
  for i := 0 to Min(length, System.Length(Res)) - 1 do
    Result[i] := Res[i];
end;

class function TConverter.TritsString(const trytes: String): TArray<Integer>;
begin
  Result := Trits(trytes);
end;

class function TConverter.Trits(const trytes: Int64): TArray<Integer>;
var
  trits: TList<Integer>;
  AAbsoluteValue: Int64;
  APosition: Integer;
  ARemainder: Integer;
  i: Integer;
begin
  trits := TList<Integer>.Create;
  try
    AAbsoluteValue := Abs(trytes);
    APosition := 0;
    while AAbsoluteValue > 0 do
      begin
        ARemainder := Integer(AAbsoluteValue mod RADIX);
        AAbsoluteValue := AAbsoluteValue div RADIX;

        if ARemainder > MAX_TRIT_VALUE then
          begin
            ARemainder := MIN_TRIT_VALUE;
            Inc(AAbsoluteValue);
          end;

        trits.Insert(APosition, ARemainder);
        Inc(APosition);
      end;

    if trytes < 0 then
      for i := 0 to trits.Count - 1 do
        trits[i] := -trits[i];

    Result := ConvertToIntArray(trits);
  finally
    trits.Free;
  end;
end;

class function TConverter.Trits(const trytes: String): TArray<Integer>;
var
  i, j: Integer;
begin
  SetLength(Result, 3 * Length(trytes));
  FillChar(Result[0], Length(Result)*SizeOf(Result), 0);
  for i := 0 to Length(trytes) - 1 do
    for j := 0 to NUMBER_OF_TRITS_IN_A_TRYTE - 1 do
      Result[i * NUMBER_OF_TRITS_IN_A_TRYTE + j] := TRYTE_TO_TRITS_MAPPINGS[Pos(trytes[i + 1], TRYTE_ALPHABET) - 1][j];
end;

class function TConverter.CopyTrits(const input: String; var destination: TArray<Integer>): TArray<Integer>;
var
  i: Integer;
  AIndex: Integer;
begin
  for i := 0 to Length(input) - 1 do
    begin
      AIndex := Pos(input[i + 1], TRYTE_ALPHABET) - 1;
      destination[i * 3] := TRYTE_TO_TRITS_MAPPINGS[AIndex][0];
      destination[i * 3 + 1] := TRYTE_TO_TRITS_MAPPINGS[AIndex][1];
      destination[i * 3 + 2] := TRYTE_TO_TRITS_MAPPINGS[AIndex][2];
    end;
  Result := destination;
end;

class function TConverter.Trytes(const trits: TArray<Integer>; const offset, size: Integer): String;
var
  i, j: Integer;
begin
  Result := '';
  for i := 0 to (size + NUMBER_OF_TRITS_IN_A_TRYTE - 1) div NUMBER_OF_TRITS_IN_A_TRYTE - 1 do
    begin
      j := trits[offset + i * 3] + trits[offset + i * 3 + 1] * 3 + trits[offset + i * 3 + 2] * 9;
      if j < 0 then
        j := j + Length(TRYTE_ALPHABET);
      Result := Result + TRYTE_ALPHABET[j + 1];
    end;
end;

class function TConverter.Trytes(const trits: TArray<Integer>): String;
begin
  Result := Trytes(trits, 0, Length(trits));
end;

class function TConverter.TryteValue(const trits: TArray<Integer>; const offset: Integer): Integer;
begin
  Result := trits[offset] + trits[offset + 1] * 3 + trits[offset + 2] * 9;
end;

class function TConverter.Value(const trits: TArray<Integer>): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := High(trits) downto 0 do
    Result := Result * 3 + trits[i];
end;

class function TConverter.FromValue(value: Integer): TArray<Integer>;
var
  i, j: Integer;
  AAbsoluteValue: Integer;
  ARemainder: Integer;
begin
  if Value = 0 then
    begin
      SetLength(Result, 1);
      Result[0] := 0;
    end
  else
    begin
      SetLength(Result, Integer(1 + Floor(Ln(2 * Max(1, Abs(value))) / Ln(3))));
      FillChar(Result[0], Length(Result), 0);
      i := 0;
      AAbsoluteValue := Abs(value);
      while AAbsoluteValue > 0 do
        begin
          ARemainder := AAbsoluteValue mod RADIX;
          AAbsoluteValue := Integer(Floor(AAbsoluteValue / RADIX));
          if ARemainder > MAX_TRIT_VALUE then
            begin
              ARemainder := MIN_TRIT_VALUE;
              Inc(AAbsoluteValue);
            end;
          Result[i] := ARemainder;
          Inc(i);
        end;

      if value < 0 then
        for j := 0 to High(Result) do
          Result[j] := -Result[j];
    end;
end;

class function TConverter.LongValue(const trits: TArray<Integer>): Int64;
var
  i: Integer;
begin
  Result := 0;
  for i := High(trits) downto 0 do
    Result := Result * 3 + trits[i];
end;

class procedure TConverter.Increment(var trits: TArray<Integer>; const size: Integer);
var
  i: Integer;
begin
  for i := 0 to size - 1 do
    begin
      trits[i] := trits[i] + 1;
      if trits[i] > TConverter.MAX_TRIT_VALUE then
        trits[i] := TConverter.MIN_TRIT_VALUE
      else
        Break;
    end;
end;

end.
