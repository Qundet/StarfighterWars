unit objects;
Uses Graph3D, Timers;

var
  gamePoints: integer;
  warheads: set of Object3D;
  flame: Object3D;
  gameOver: boolean;
  d: real;
  
//Класс истребителя
type
  StarFighter = class
  private
    laserColor: GColor;
    laserX,laserY,laserZ: real;
    isFire: boolean;
  public
    ship : Group3D;
    t: Timer;
    hp, fireInt, direction: integer;
    speed: real;
    
    //Выстрел
    procedure fire;
    var
      laser1,laser2: Object3D;
    begin
      if isFire = true then exit;
      t.Start;

      isFire:= true;
      laser1 := Rectangle3D(
        ship.Position.X-laserX, ship.Position.Y-laserY*direction, laserZ,
        2, 0.05,
        V3D(0, 0, 1),
        V3D(ship.Position.X, -100, 0),
        Materials.Emissive(laserColor)
      );

      laser2 := laser1.Clone;
      laser2.Position := P3D(ship.Position.X+laserX, ship.Position.Y-laserY*direction, laserZ);
      
      laser1.AnimMoveBy(laser1.Position.X, direction*200 + random(-20,20), laser1.Position.Z, 2).WhenCompleted(
      procedure -> begin
        laser1.Destroy;
        Exclude(warheads, laser1);
      end
      ).Begin;
      
      laser2.AnimMoveBy(laser2.Position.X, direction*200 + random(-20,20), laser2.Position.Z, 2).WhenCompleted(
      procedure -> begin
        laser2.Destroy;
        Exclude(warheads, laser2);
      end
      ).Begin;
      
      laser1.Direction:= V3D(0,direction,0);
      laser2.Direction:= V3D(0,direction,0);
      
      Include(warheads, laser1);
      Include(warheads, laser2);
      
    end;
        
    constructor Create(aFilePath: string; aFireInt, aHp: integer; aSpeed, aLaserX,aLaserY,aLaserZ,aZ,aScl: real; aLaserColor: GColor);
    begin
      fireInt:= aFireInt;
      hp:= aHp;
      speed:= aSpeed;
      laserColor:=  aLaserColor;
      laserX:= aLaserX;
      laserY:= aLaserY;
      laserZ:= aLaserZ;
      ship:= Group(FileModel3D(0,0,aZ,'data/Ships/'+aFilePath, nil));
      ship.Z:=aZ;
      ship.Scale(aScl);
      ship.Rotate(OrtX, 90);
      ship.Rotate(OrtY, 180);      
      direction:= 1;
      t := new Timer(fireInt, procedure -> isFire := false);
    end;

  end;
  
  
var
  player: StarFighter;
  enemyObjects: set of StarFighter;


///Анимация пламени из двигателей
///X_Wing
function X_WingFlame(s: StarFighter): Group3D;
begin
  var flame:= Ellipsoid(s.ship.X-0.285, s.ship.Y+1.3, s.ship.Z+0.215,0.06,0.3,0.06,Materials.Emissive(Colors.DarkOrange)); 
  var flame1 := flame.Clone;
  var flame2 := flame.Clone;
  var flame3 := flame.Clone;
  flame1.X*=-1;
  flame2.Z*=-1;
  flame3.X*=-1;
  flame3.Z*=-1;
  flame.AnimScaleY(1.15, 0.1).AutoReverse.Forever.Begin;
  flame1.AnimScaleY(1.15, 0.1).AutoReverse.Forever.Begin;
  flame2.AnimScaleY(1.15, 0.1).AutoReverse.Forever.Begin;
  flame3.AnimScaleY(1.15, 0.1).AutoReverse.Forever.Begin;
  var g := Group(flame,flame1,flame2,flame3);
  Result:= g;
end;

//Ships
///TieFighter
function TieFighter:StarFighter;
begin
  Result:=StarFighter.Create('TieFighter/TIE Fighter.obj', 600, 10, 0.02, 0.1, -1.5, -0.2, -0.8, 0.1, GColor.FromRgb(255,0,0));
end;
///TiePhantom
function TiePhantom:StarFighter;
begin
  Result:=StarFighter.Create('TiePhantom/TiePhantom.obj', 400, 16, 0.025, 0.35, -2, -0.2, 0, 1.7, GColor.FromRgb(255,0,50));
end;
///TieDefender
function TieDefender:StarFighter;
begin
  Result:=StarFighter.Create('TieDefender/TieDefender.obj', 300, 24, 0.04, 0.6, -2, -0.2, 0, 1.7, GColor.FromRgb(255,0,255));
end;
///X_WingV1
function X_WingV1:StarFighter;
var
  s: StarFighter;
begin
  s:= StarFighter.Create('X-WingV1/3fkpgcyatyc6.obj', 500, 50, 0.03, 0.9, -1.6, 0.35, 0, 0.4, GColor.FromRgb(0,255,0));
  //Анимация пламени из двигателя
  var g := X_WingFlame(s);
  s.ship.AddChild(g);
  s.ship.Items[1].Position:= s.ship.Items[0].Position + P3D(0, 0, -6.5);
  s.ship.Items[1].Rotate(OrtX, 90);
  s.ship.Items[1].Scale(2.5);
  Result:=s;
end;
///X_WingV2
function X_WingV2:StarFighter;
begin
  var s:=StarFighter.Create('X-WingV2/3fkpgcyatyc6.obj', 300, 64, 0.035, 0.9, -1.6, 0.35, 0, 0.4, GColor.FromRgb(255,50,0));
  //Анимация пламени из двигателя
  var g := X_WingFlame(s);
  s.ship.AddChild(g);
  s.ship.Items[1].Position:= s.ship.Items[0].Position + P3D(0, 0, -6.5);
  s.ship.Items[1].Rotate(OrtX, 90);
  s.ship.Items[1].Scale(2.5);
  Result:=s;
end;
///W_Wing
function W_Wing:StarFighter;
begin
  Result:=StarFighter.Create('W-Wing/Sketchfab_2019_12_23_19_28_57.obj', 300, 80, 0.03, 1, -2, 0, 0, 0.5, GColor.FromRgb(0,255,0));
end;
///Arc170
function Arc170:StarFighter;
begin
  Result:=StarFighter.Create('W-Wing/Sketchfab_2019_12_23_19_28_57.obj', 300, 80, 0.03, 1, -2, 0, 0, 0.5, GColor.FromRgb(0,255,0));
end;
///Falcon
function Falcon:StarFighter;
begin
  Result:=StarFighter.Create('FalconMillennium/Halcon_Milenario.obj', 500, 100, 0.02, 0.8, -4, 0.2, 0, 0.0055, GColor.FromRgb(100,200,255));
end;


///Астероиды
var asts: set of Object3D;
procedure AsteroidField;
begin
 
  for var i:=1 to 10 do
    asts += [FileModel3D(random(-20,20),random(-300,-200),0,'data/WorldObjects/Asteroids/'+random(0,4)+'.obj', nil).Scale(0.2)];
 
  foreach var a in asts do
  begin
    a.AnimRotate(V3D(1, random(0,1), random(0,1)), 360, random(1,10)).Forever.Begin;
    a.AnimMoveByY(300, random(3,15)).WhenCompleted(() ->
    begin
      a.Destroy;
      Exclude(asts, a);
    end).Begin;
  end;

end;

///Новая волна врагов
procedure enemyWave;
begin
  for var i:=1 to random(2,5) do
    enemyObjects += [TiePhantom];      
end;


//Анимации
///Уничтожение коробля(взрыв)
procedure explosion(ship: Object3D);
begin
  ship.Destroy;
  var s:= Sphere(ship.X, ship.Y, 0, 0.1, Materials.Emissive(GColor.FromRgb(255,180,0)));
  s.BackMaterial := Materials.Diffuse(Colors.Transparent);
  s.AnimScale(12, 0.2).AccelerationRatio(0, 100).AutoReverse.WhenCompleted(s.Destroy).Begin;
end;

///Анимация попадания
procedure hitAnim(p: Point3D);
begin
  var s:= Sphere(p.X, p.Y, 0, 0.1, Materials.Emissive(GColor.FromRgb(255,180,0)));
  s.BackMaterial := Materials.Diffuse(Colors.Transparent);
  s.AnimScale(4, 0.1).AutoReverse.WhenCompleted(s.Destroy).Begin;
end;
  
  
end.