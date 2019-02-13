unit DIOTA.Utils.StopWatch;

interface

type
  TStopWatch = class
  private
    FStartTime: Int64;
    FRunning: Boolean;
    FCurrentTime: Int64;
  public
    constructor Create;
    procedure ReStart;
    function Stop: TStopWatch;
    procedure Pause;
    procedure Resume;
    {
     * Elapsed time in milliseconds.
     *
     * @return The elapsed time in milliseconds.
    }
    function GetElapsedTimeMili: Int64;
    {
     * Elapsed time in seconds.
     *
     * @return The elapsed time in seconds.
    }
    function GetElapsedTimeSecs: Int64;
    {
     * Elapsed time in minutes.
     *
     * @return The elapsed time in minutes.
    }
    function GetElapsedTimeMin: Int64;
    {
     * Elapsed time in hours.
     *
     * @return The elapsed time in hours.
    }
    function GetElapsedTimeHour: Int64;
  end;

implementation

uses
  System.SysUtils,
  System.DateUtils;

{ TStopWatch }

constructor TStopWatch.Create;
begin
  FStartTime := MilliSecondsBetween(Now, 0);
  FRunning := True;
  FCurrentTime := 0;
end;

procedure TStopWatch.ReStart;
begin
  FStartTime := MilliSecondsBetween(Now, 0);
  FRunning := True;
end;

function TStopWatch.Stop: TStopWatch;
begin
  FRunning := False;
  Result := Self;
end;

procedure TStopWatch.Pause;
begin
  FRunning := false;
  FCurrentTime := MilliSecondsBetween(Now, 0) - FStartTime;
end;

procedure TStopWatch.Resume;
begin
  FRunning := True;
  FStartTime := MilliSecondsBetween(Now, 0) - FCurrentTime;
end;

function TStopWatch.GetElapsedTimeMili: Int64;
begin
  if FRunning then
    Result := (MilliSecondsBetween(Now, 0) - FStartTime)
  else
    Result := 0;
end;

function TStopWatch.GetElapsedTimeSecs: Int64;
begin
  if FRunning then
    Result := (MilliSecondsBetween(Now, 0) - FStartTime) div 1000
  else
    Result := 0;
end;

function TStopWatch.GetElapsedTimeMin: Int64;
begin
  if FRunning then
    Result := (MilliSecondsBetween(Now, 0) - FStartTime) div 1000 div 60
  else
    Result := 0;
end;

function TStopWatch.GetElapsedTimeHour: Int64;
begin
  if FRunning then
    Result := (MilliSecondsBetween(Now, 0) - FStartTime) div 1000 div 3600
  else
    Result := 0;
end;

end.
