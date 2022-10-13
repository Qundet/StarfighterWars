Unit presetActions;

Uses Graph3D;
uses objects;


procedure firefight(obj: Object3D; d:shortint);
begin
  if abs(obj.X) > 10 then
  begin
    obj.AnimMoveByX(5*(-sign(obj.X)), 2.5).WhenCompleted(procedure -> firefight(obj, d*-1)).Begin;
    exit;  
  end;
  
  var n := random(1, 6);
  obj.AnimMoveByX(n*d, n*0.5).WhenCompleted(procedure -> firefight(obj, d*-1)).Begin;
//  sleep(random(1000, 2000));
end;

procedure meetAnimation(sf: StarFighter; dis: integer);
begin
  sf.ship.AnimMoveByY(dis * sf.Direction, 2).AccelerationRatio(0,100).Begin;
  firefight(sf.ship, 1);
  sleep(random(500, 2000));
end;


end.