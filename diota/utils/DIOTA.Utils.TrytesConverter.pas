unit DIOTA.Utils.TrytesConverter;

interface

type
  //This class allows to convert between ASCII and tryte encoded strings.
  TTrytesConverter = class
  public
    {
     * Conversion of ASCII encoded bytes to trytes.
     * Input is a string (can be stringified JSON object), return value is Trytes
     *
     * How the conversion works:
     * 2 Trytes === 1 Byte
     * There are a total of 27 different tryte values: 9ABCDEFGHIJKLMNOPQRSTUVWXYZ
     *
     * 1. We get the decimal value of an individual ASCII character
     * 2. From the decimal value, we then derive the two tryte values by basically calculating the tryte equivalent (e.g. 100 === 19 + 3 * 27)
     * a. The first tryte value is the decimal value modulo 27 (27 trytes)
     * b. The second value is the remainder (decimal value - first value), divided by 27
     * 3. The two values returned from Step 2. are then input as indices into the available values list ('9ABCDEFGHIJKLMNOPQRSTUVWXYZ') to get the correct tryte value
     *
     *
     * EXAMPLE
     *
     * Lets say we want to convert the ASCII character "Z".
     * 1. 'Z' has a decimal value of 90.
     * 2. 90 can be represented as 9 + 3 * 27. To make it simpler:
     * a. First value: 90 modulo 27 is 9. This is now our first value
     * b. Second value: (90 - 9) / 27 is 3. This is our second value.
     * 3. Our two values are now 9 and 3. To get the tryte value now we simply insert it as indices into '9ABCDEFGHIJKLMNOPQRSTUVWXYZ'
     * a. The first tryte value is '9ABCDEFGHIJKLMNOPQRSTUVWXYZ'[9] === "I"
     * b. The second tryte value is '9ABCDEFGHIJKLMNOPQRSTUVWXYZ'[3] === "C"
     * Our tryte pair is "IC"
     *
     * @param inputString The input String.
     * @return The ASCII char "Z" is represented as "IC" in trytes.
    }
    class function AsciiToTrytes(AInputString: String): String;

    {
     * Converts Trytes of even length to an ASCII string.
     * Reverse operation from the asciiToTrytes
     * 2 Trytes == 1 Byte
     * @param inputTrytes the trytes we want to convert
     * @return an ASCII string or null when the inputTrytes are uneven
     * @throws ArgumentException When the trytes in the string are an odd number
    }
    class function TrytesToAscii(AInputTrytes: String): String;
  end;

implementation

uses
  System.SysUtils,
  DIOTA.Utils.Constants;

{ TTrytesConverter }

class function TTrytesConverter.AsciiToTrytes(AInputString: String): String;
var
  i: Integer;
  AChar: Char;
  AFirstValue: Integer;
  ASecondValue: Integer;
begin
  Result := '';
  for i:= 1 to Length(AInputString) do
    begin
      AChar := AInputString[i];

      // If not recognizable ASCII character, replace with space
      if Ord(AChar) > 255 then
        AChar := #32;

      AFirstValue := Ord(AChar) mod 27;
      ASecondValue := (Ord(AChar) - AFirstValue) div 27;

      Result := Result + TRYTE_ALPHABET[AFirstValue + 1] + TRYTE_ALPHABET[ASecondValue + 1];
    end;
end;

class function TTrytesConverter.TrytesToAscii(AInputTrytes: String): String;
var
  i: Integer;
  AFirstValue: Integer;
  ASecondValue: Integer;
begin
  Result := '';
  // If input length is odd, return empty string
  if (Length(AInputTrytes) mod 2) = 0 then
    raise Exception.Create('Odd amount of trytes supplied')
  else
    begin
      i := 1;
      while (i < Length(AInputTrytes)) do
        begin
          AFirstValue := Pos(AInputTrytes[i], TRYTE_ALPHABET) - 1;
          ASecondValue := Pos(AInputTrytes[i + 1], TRYTE_ALPHABET) - 1;

          Result := Result + Chr(AFirstValue + ASecondValue * 27);

          Inc(i, 2);
        end;
    end;
end;

end.
