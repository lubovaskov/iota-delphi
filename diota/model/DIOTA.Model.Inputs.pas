unit DIOTA.Model.Inputs;

interface

uses
  Generics.Collections,
  DIOTA.Model.Input;

type
  TInputs = class
  private
    FTotalBalance: Int64;
    FInputsList: TList<IInput>;
  public
    constructor Create(AInputsList: TList<IInput>; ATotalBalance: Int64); virtual;
    property InputsList: TList<IInput> read FInputsList write FInputsList;
    property TotalBalance: Int64 read FTotalBalance write FTotalBalance;
  end;

implementation

{ TInputs }

constructor TInputs.Create(AInputsList: TList<IInput>; ATotalBalance: Int64);
begin
  FInputsList := AInputsList;
  FTotalBalance := ATotalBalance;
end;

end.
