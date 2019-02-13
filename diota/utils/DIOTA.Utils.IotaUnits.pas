unit DIOTA.Utils.IotaUnits;

interface

type
  IIotaUnit = interface
    ['{9EE2D8E9-E0FB-41D3-9D30-F18FFC3F8BEF}']
    function GetUnit: String;
    function GetValue: Int64;
    function EqualTo(iotaUnit: IIotaUnit): Boolean;
  end;

  TIotaUnits = class
  private
    class function GetIOTA: IIotaUnit; static;
    class function GetKILO_IOTA: IIotaUnit; static;
    class function GetGIGA_IOTA: IIotaUnit; static;
    class function GetMEGA_IOTA: IIotaUnit; static;
    class function GetPETA_IOTA: IIotaUnit; static;
    class function GetTERA_IOTA: IIotaUnit; static;
  public
    class property IOTA: IIotaUnit read GetIOTA;
    class property KILO_IOTA: IIotaUnit read GetKILO_IOTA;
    class property MEGA_IOTA: IIotaUnit read GetMEGA_IOTA;
    class property GIGA_IOTA: IIotaUnit read GetGIGA_IOTA;
    class property TERA_IOTA: IIotaUnit read GetTERA_IOTA;
    class property PETA_IOTA: IIotaUnit read GetPETA_IOTA;
  end;

implementation

type
  TIotaUnit = class(TInterfacedObject, IIotaUnit)
  private
    FUnitName: String;
    FValue: Int64;
  public
    constructor Create(unitName: String; value: Int64);
    function GetUnit: String;
    function GetValue: Int64;
    function EqualTo(iotaUnit: IIotaUnit): Boolean;
  end;

{ TIotaUnits }

class function TIotaUnits.GetIOTA: IIotaUnit;
begin
  Result := TIotaUnit.Create('i', 0);
end;

class function TIotaUnits.GetKILO_IOTA: IIotaUnit;
begin
  Result := TIotaUnit.Create('Ki', 3);
end;

class function TIotaUnits.GetMEGA_IOTA: IIotaUnit;
begin
  Result := TIotaUnit.Create('Mi', 6);
end;

class function TIotaUnits.GetGIGA_IOTA: IIotaUnit;
begin
  Result := TIotaUnit.Create('Gi', 9);
end;

class function TIotaUnits.GetTERA_IOTA: IIotaUnit;
begin
  Result := TIotaUnit.Create('Ti', 12);
end;

class function TIotaUnits.GetPETA_IOTA: IIotaUnit;
begin
  Result := TIotaUnit.Create('Pi', 15);
end;

{ TIotaUnit }

constructor TIotaUnit.Create(unitName: String; value: Int64);
begin
  FUnitName := unitName;
  FValue := value;
end;

function TIotaUnit.GetUnit: String;
begin
  Result := FUnitName;
end;

function TIotaUnit.GetValue: Int64;
begin
  Result := FValue;
end;

function TIotaUnit.EqualTo(iotaUnit: IIotaUnit): Boolean;
begin
  Result := (GetUnit = iotaUnit.GetUnit) and (GetValue = iotaUnit.GetValue);
end;

end.
