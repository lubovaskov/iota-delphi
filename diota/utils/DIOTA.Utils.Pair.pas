unit DIOTA.Utils.Pair;

interface

type
  TPair<S, T> = class
  private
    FHi: T;
    FLow: S;
  public
    constructor Create(k: S; v: T); virtual;
    property Low: S read FLow write FLow;
    property Hi: T read FHi write FHi;
  end;

implementation

{ TPair<S, T> }

constructor TPair<S, T>.Create(k: S; v: T);
begin
  FLow := k;
  FHi := v;
end;

end.
