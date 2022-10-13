Unit handlers;

Uses Graph3D;
uses objects, gameInterface;

///Обработчик попаданий
procedure hitHandler;
begin
  foreach var obj in warheads do
  begin
    if (abs(obj.Y - player.ship.Y) <= 1) and (abs(obj.X - player.ship.X) <= 1.5) then
    begin
      hudHealth.Length -= d;
      hudHealth.X += d / 2;
      player.hp -= 2;
      hitAnim(P3D(obj.X, obj.Y, 0));
      obj.Destroy;
      Exclude(warheads, obj);
    end;
    foreach var e in enemyObjects do
      if (abs(obj.Y - e.ship.Y) <= 1) and (abs(obj.X - e.ship.X) <= 1.5) and (obj.Direction.Y = -1) then
      begin
        hitAnim(P3D(obj.X, obj.Y, 0));
        obj.Destroy;
        Exclude(warheads, obj);
        e.hp -= 2;
      end;
   end;
end;

///Обработчик уничтожений
procedure desHandler;
begin
  if player.hp < 1 then
  begin
    hudHealth.Destroy;
    explosion(player.ship);
    gameOver:= true;
  end;
  
  foreach var e in enemyObjects do
    if e.hp < 1 then
    begin
      explosion(e.ship);
      Exclude(enemyObjects, e);
      gamePoints += 100;
      var s: string;
      Str(gamePoints, s);
      gamePointsBoard.Text := ' '+(5-s.Length)*'0'+s+' '
    end;
end;

///Обработчик столкновений
procedure collisionHandler;
begin
  
  foreach var a in asts do
  begin
    if (abs(a.X - player.ship.X) <= 2) and (abs(a.Y - player.ship.Y) <= 1) then
    begin
      hitAnim(P3D(a.X,a.Y,0));
      hudHealth.Length -= d;
      hudHealth.X += d / 2;
      player.hp -= 2;
      Exclude(asts, a);
    end;
  end;
  
end;

///Конец игры
procedure gameOver();
begin
  Object3DList.ForEach(obj -> begin
    obj.Destroy;
  end);
  foreach var s in enemyObjects do
  begin
    s.ship.Destroy;
    Exclude(enemyObjects, s);
  end;
end;

  
end.