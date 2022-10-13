Unit levels;

Uses Graph3D, Timers;
uses objects, control, handlers, presetActions;

///Уровень 1
procedure level_1;
begin
  
  var Space := Sphere(0,-1000,0,1000);
  Space.BackMaterial := ImageMaterial('data/Maps/spacemap3.jpg',0.2,0.2);
  Space.AnimMoveByY(2000, 180).WhenCompleted(() -> begin player.hp:=0; end).Begin;
  Space.ScaleY(2);
  
  Lights.AddDirectionalLight(Colors.Black, Camera.LookDirection);
  
  player:= X_WingV1;
  player.ship.Rotate(OrtY, 180);
  player.direction:= -1;
  player.ship.Y:= 5;
  player.ship.X:= 0;
  
  d:= 2 / (player.hp / 2);
  sleep(2000);
  player.ship.AnimMoveByY(-5, 2).AccelerationRatio(0, 100).Begin;
  sleep(2000);
    
  var w := 2;
  
  //Главный цикл
  while (player.hp > 0) do
  begin
    
    shipControl;
    Invoke(hitHandler);
    Invoke(desHandler);
    
    foreach var e in enemyObjects do
      if (e.direction <> -1)and (random(1,50) = 1) then
        e.fire;
      
    if (enemyObjects = []) and (w < 5) then
    begin
      
      for var i:=1 to w do
      begin
        if w = 4 then
          enemyObjects += [TieFighter,TiePhantom]
        else
          enemyObjects += [TieFighter,TieFighter];
          foreach var e in enemyObjects do
          begin
            e.ship.Y:= -250;
            e.ship.X:=random(-10, 10);
          end;
      end;
      
      foreach var s in enemyObjects do
      begin
        meetAnimation(s, random(150, 220));
      end;
      
      w+=1;
    end
    else if enemyObjects = [] then
      break;
    
    sleep(5);
  end;
  
  foreach var s in enemyObjects do
  begin
    s.ship.Destroy;
    Exclude(enemyObjects, s);
  end;
  Space.Destroy;
end;


///Уровень 2
procedure level_2;
var
  gameEnd:boolean;
begin
  
  var Space := Sphere(0,-500,0,1000);
  Space.BackMaterial := ImageMaterial('data/Maps/spacemap2.jpg',0.2,0.2);
  Space.AnimMoveByY(1000, 150).WhenCompleted(() -> begin gameEnd := true end).Begin;
  Space.Rotate(OrtX, 20);
  
  Lights.AddDirectionalLight(Colors.Black, Camera.LookDirection);
  
  player:= X_WingV2;
  player.ship.Rotate(OrtY, 180);
  player.direction:= -1;
  player.ship.Y:= 5;
  player.ship.X:= 0;
  
  d:= 2 / (player.hp / 2);
  sleep(2000);
  player.ship.AnimMoveByY(-5, 2).AccelerationRatio(0, 100).Begin;
  sleep(2000);
  
  var t := new Timer(30000, () -> begin
  foreach var s in enemyObjects do
  begin
    meetAnimation(s, random(150, 220));
    Exclude(enemyObjects, s);
    s.ship.Destroy;
  end;
  enemyWave;
  foreach var e in enemyObjects do
  begin
    e.ship.Y:= -250;
    e.ship.X:=random(-10, 10);
  end;
  foreach var s in enemyObjects do
    meetAnimation(s, random(150, 220));
  end);
  
  t.Start;
  
  //Главный цикл
  while (player.hp > 0) and (gameEnd = false) do
  begin
    
    Invoke(shipControl);
    Invoke(hitHandler);
    Invoke(desHandler);
    Invoke(collisionHandler);
    
    if asts = [] then
      Invoke(AsteroidField);
    
    if enemyObjects <> [] then
    begin        
      foreach var e in enemyObjects do
        if (e.direction <> -1)and (random(1,50) = 1) then
          e.fire;  
    end;
    
    sleep(5);
  end;
  
  foreach var s in enemyObjects do
  begin
    s.ship.Destroy;
    Exclude(enemyObjects, s);
  end;
  
  foreach var a in asts do
  begin
    a.Destroy;
    Exclude(asts, a);
  end;  
  
  Space.Destroy;
end;


end.