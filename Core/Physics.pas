unit Physics;

interface

  function PointInCircle(AXCircle, AYCircle, ARCircle, APX, APY: Double): Boolean;
  procedure GetXValuesByCircle(AXCircle, AYCircle, ARCircle, AY: Double;
    var MinOutPutValue: Double; var MaxOutPutValue: Double);
  procedure GetYValuesByCircle(AXCircle, AYCircle, ARCircle, AX: Double;
    var MinOutPutValue: Double; var MaxOutPutValue: Double);
  function GetXCircleByTurn(AXCirlce, ARadius: Double; ATurn: Integer): Double;

implementation

  function PointInCircle(AXCircle, AYCircle, ARCircle, APX, APY: Double): Boolean;
  begin
    Result := ((APX - AXCircle) * (APX - AXCircle)) + ((APY - AYCircle) * (APY - AyCircle)) < (ARCircle * ARCircle);
  end;

  procedure GetXValuesByCircle(AXCircle, AYCircle, ARCircle, AY: Double;
    var MinOutPutValue: Double; var MaxOutPutValue: Double);
  var
    vDelta: Double;
  begin
    vDelta := Sqrt(abs((ARCircle * ARCircle) - ((AY - AYCircle) * (AY - AYCircle))));
    MaxOutPutValue := AXCircle + vDelta;
    MinOutPutValue := AXCircle - vDelta;
  end;

  procedure GetYValuesByCircle(AXCircle, AYCircle, ARCircle, AX: Double;
    var MinOutPutValue: Double; var MaxOutPutValue: Double);
  var
    vDelta: Double;
  begin
    vDelta := Sqrt(abs((ARCircle * ARCircle) - ((AX - AXCircle) * (AX - AXCircle))));
    MaxOutPutValue := AYCircle + vDelta;
    MinOutPutValue := AYCircle - vDelta;
  end;

  {function GetYByX(AX: Double): Double;
  var
    I, vIndex0, vIndex1: Integer;
  begin
    if AX <= PointList[0].X then
      Exit(PointList[0].Y);
    if AX >= PointList[PointList.Count - 1].X then
      Exit(PointList[PointList.Count - 1].Y);

    vIndex0 := 0;
    vIndex1 := 0;
    for I := 0 to PointList.Count - 1 do
      if PointList[I].X > AX then
      begin
        vIndex1 := I;
        vIndex0 := I - 1;
        Break;
      end;
    Result := PointList[vIndex0].Y +
      (((PointList[vIndex1].Y - PointList[vIndex0].Y)*(AX - PointList[vIndex0].X))
        /((PointList[vIndex1]).X - PointList[vIndex0].X));
  end; }

  function GetXCircleByTurn(AXCirlce, ARadius: Double; ATurn: Integer): Double;
  var
    vDelta: Double;
  begin
    vDelta := ARadius / 6;
    Result := 0;
    case ATurn of
        0: Result := AXCirlce;
        6: Result := AXCirlce + ARadius;
        12: Result := AXCirlce;
        18: Result := AXCirlce - ARadius;
      else
      begin
        if (ATurn > 0) and (ATurn < 6) then
          Result := AXCirlce + ATurn * vDelta
        else if (ATurn > 6) and (ATurn < 12) then
          Result := AXCirlce + ARadius - (ATurn - 6) * vDelta
        else if (ATurn > 12) and (ATurn < 18) then
          Result := AXCirlce - (ATurn - 12) * vDelta
        else if (ATurn > 18) and (ATurn < 24) then
          Result := AXCirlce - ARadius + (ATurn - 18) * vDelta
      end;
    end;
  end;

end.
