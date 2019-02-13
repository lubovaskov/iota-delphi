unit DIOTA.Model.Signature;

interface

uses
  System.Classes;

type
  TSignature = class
  private
    FSignatureFragments: TStrings;
    FAddress: String;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    property Address: String read FAddress write FAddress;
    property SignatureFragments: TStrings read FSignatureFragments write FSignatureFragments;
  end;

implementation

{ TSignature }

constructor TSignature.Create;
begin
  FSignatureFragments := TStringList.Create;
end;

destructor TSignature.Destroy;
begin
  FSignatureFragments.Free;
  inherited;
end;

end.
