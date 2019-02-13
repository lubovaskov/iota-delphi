unit DIOTA.Utils.IotaUnitConverter;

interface

uses
  DIOTA.Utils.IotaUnits;

type
  TIotaUnitConverter = class
  private
    class function ConvertUnits(amount: Int64; toUnit: IIotaUnit): Int64; overload;
    class function CreateAmountWithUnitDisplayText(amountInUnit: Double; iotaUnit: IIotaUnit; extended: Boolean): String;
  public
    class function ConvertUnits(amount: Int64; fromUnit: IIotaUnit; toUnit: IIotaUnit): Int64; overload;
    class function ConvertRawIotaAmountToDisplayText(amount: Int64; extended: Boolean): String;
    class function ConvertAmountTo(amount: Int64; target: IIotaUnit): Double;
    class function CreateAmountDisplayText(amountInUnit: Double; iotaUnit: IIotaUnit; extended: Boolean): String;
    class function FindOptimalIotaUnitToDisplay(amount: Int64): IIotaUnit;
  end;

implementation

uses
  System.Math,
  System.SysUtils;

{ TIotaUnitConverter }

class function TIotaUnitConverter.ConvertUnits(amount: Int64; toUnit: IIotaUnit): Int64;
begin
  Result := amount div Round(Power(10, toUnit.GetValue));
end;

class function TIotaUnitConverter.ConvertUnits(amount: Int64; fromUnit: IIotaUnit; toUnit: IIotaUnit): Int64;
begin
  Result := ConvertUnits(amount * Round(Power(10, fromUnit.GetValue)), toUnit);
end;

class function TIotaUnitConverter.ConvertRawIotaAmountToDisplayText(amount: Int64; extended: Boolean): String;
var
  AUnit: IIotaUnit;
begin
  AUnit := FindOptimalIotaUnitToDisplay(amount);
  Result := CreateAmountWithUnitDisplayText(ConvertAmountTo(amount, AUnit), AUnit, extended);
end;

class function TIotaUnitConverter.ConvertAmountTo(amount: Int64; target: IIotaUnit): Double;
begin
  Result := amount / Power(10, target.GetValue);
end;

class function TIotaUnitConverter.CreateAmountWithUnitDisplayText(amountInUnit: Double; iotaUnit: IIotaUnit; extended: Boolean): String;
begin
  Result := CreateAmountDisplayText(amountInUnit, iotaUnit, extended) + ' ' + iotaUnit.GetUnit;
end;

class function TIotaUnitConverter.CreateAmountDisplayText(amountInUnit: Double; iotaUnit: IIotaUnit; extended: Boolean): String;
var
  AFormat: String;
begin
  if extended then
    AFormat := '##0.##################'
  else
    AFormat := '##0.##';

  if iotaUnit.EqualTo(TIotaUnits.IOTA) then
    Result := IntToStr(Round(amountInUnit))
  else
    Result := FormatFloat(AFormat, amountInUnit);
end;

class function TIotaUnitConverter.FindOptimalIotaUnitToDisplay(amount: Int64): IIotaUnit;
var
  ALength: Integer;
begin
  ALength := Length(IntToStr(Abs(amount)));
  if (ALength >= 1) and (ALength <= 3) then
    Result := TIotaUnits.IOTA
  else
  if (ALength > 3) and (ALength <= 6) then
    Result := TIotaUnits.KILO_IOTA
  else
  if (ALength > 6) and (ALength <= 9) then
    Result := TIotaUnits.MEGA_IOTA
  else
  if (ALength > 9) and (ALength <= 12) then
    Result := TIotaUnits.GIGA_IOTA
  else
  if (ALength > 12) and (ALength <= 15) then
    Result := TIotaUnits.TERA_IOTA
  else
  if (ALength > 15) and (ALength <= 18) then
    Result := TIotaUnits.PETA_IOTA
  else
    Result := TIotaUnits.IOTA;
end;

end.
