unit DIOTA.IotaLocalPow;

interface

type
   IIotaLocalPoW = interface
      function PerformPoW(trytes: String; minWeightMagnitude: Integer): String;
   end;

implementation

end.
