Unit control;

Uses Graph3D;
uses objects;

var
  mr, mf: integer;
  rotated: boolean;
  
///Управление кораблем
procedure shipControl();
begin

  //Обработка нажатий
  OnKeyDown := k ->
  begin
    case k of
      Key.Space: player.fire;
      Key.A:
      begin
        mr := 1;
        if not(rotated) then
        begin
          player.ship.AnimRotate(OrtZ, -10, 0.2).Begin;
          rotated:= true;
        end;
      end;
      Key.D:
      begin
        mr := -1;
        if not(rotated) then
        begin
          player.ship.AnimRotate(OrtZ, 10, 0.2).Begin;
          rotated:= true;
        end;
      end;
      Key.W: mf := -1;
      Key.S: mf := 1;
    end;
  end;
  //Обработка отжатий
  OnKeyUp := k ->
  begin
    case k of
      Key.A:
      begin
        mr:= 0;
        if rotated then
        begin
          player.ship.AnimRotate(OrtZ, 10, 0.2).Begin;
          rotated:= false;
        end;
      end;
      Key.D:
      begin
        mr:= 0;
        if rotated then
        begin
          player.ship.AnimRotate(OrtZ, -10, 0.2).Begin;
          rotated:= false;
        end;
      end;
      Key.W: mf := 0;
      Key.S: mf := 0;
    end;
  end;

  if (player.ship.X+player.speed*mr < -8) or (player.ship.X+player.speed*mr > 8) then
    mr:=0;

  if (player.ship.Y+player.speed*mf < -50) or (player.ship.Y+player.speed*mf > 0) then
    mf:=0;

  player.ship.MoveByX(player.speed*mr);
  player.ship.MoveByY(player.speed*mf);
  
end;

end.