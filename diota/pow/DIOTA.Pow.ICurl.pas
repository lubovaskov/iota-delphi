unit DIOTA.Pow.ICurl;

interface

type
  {
  This interface abstracts the curl hashing algorithm.
  }
  ICurl = interface
    {
     * Absorbs the specified trits.
     *
     * @param trits  The trits.
     * @param offset The offset to start from.
     * @param length The length.
     * @return The ICurl instance (used for method chaining).
    }
    function Absorb(const trits: TArray<Integer>; offset: Integer; length: Integer): ICurl; overload;

    {
     * Absorbs the specified trits.
     *
     * @param trits The trits.
     * @return The ICurl instance (used for method chaining).
    }
    function Absorb(const trits: TArray<Integer>): ICurl; overload;

    {
     * Squeezes the specified trits.
     *
     * @param trits  The trits.
     * @param offset The offset to start from.
     * @param length The length.
     * @return The squeezed trits.
    }
    procedure Squeeze(var trits: TArray<Integer>; const offset: Integer; const length: Integer); overload;

    {
     * Squeezes the specified trits.
     *
     * @param trits The trits.
     * @return The squeezed trits.
    }
    procedure Squeeze(var trits: TArray<Integer>); overload;

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
    function Reset: ICurl;

    {
     * Gets or sets the state.
     *
     * @return The stae.
    }
    function GetState: TArray<Integer>;

    {
     * Sets or sets the state.
     *
     * @param state The state.
    }
    procedure SetState(state: TArray<Integer>);

    {
     * Clones this instance.
     *
     * @return A new instance.
    }
    function Clone: ICurl;
  end;

implementation

end.
