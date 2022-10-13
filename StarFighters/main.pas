Uses Graph3D, Timers;
uses objects, levels, gameInterface;

var
  Space: SphereT;

procedure setGameCamera;
begin
  Camera.Position:= P3D(0, 21, 10);
  Camera.LookDirection := V3D(0, -20, -6);
end;

procedure setMenuCamera;
begin
  Camera.Position:= P3D(-4,0,11);
  Camera.LookDirection:= V3D(10,0,0);
  Camera.AddDownForce(1.6);
end;

procedure clearWorld;
begin
  Object3DList.ForEach(obj -> begin obj.Destroy end);
end;

///Продолжить игру
procedure gameContinue;
var
  results: text;
  currentLvl: integer;
begin
  assign(results, 'results.txt');
  reset(results);
  Read(results,currentLvl);
  Close(results);
  drawHud;
  case currentLvl of
    1: level_1;
    2: level_2;
  end;
end;

///Начать новую игру
procedure newGame;
var
  results: text;
begin
  assign(results, 'results.txt');
  rewrite(results);
  write(results,1);
  Close(results);
  drawHud;
  level_1;  
end;

procedure whileMenu;
begin  
  
  while menuAction = '' do
  begin
    //pass
  end;

  setGameCamera;
  clearWorld;
  Space.Destroy;

  case menuAction of
    'continue':gameContinue;
    'newgame':newGame;
  end;

  menuAction:='';
  hudHealth.Destroy;
  gamePointsBoard.Destroy;

  Space := Sphere(0,0,0,1000);
  Space.BackMaterial := ImageMaterial('data/Maps/spacemap3.jpg',0.2,0.2);
  drawMenu;
  whileMenu;

end;

Begin

  Window.SetPos(0,0);
  Window.Maximize;       
  View3D.CameraMode:= CameraMode.WalkAround;
  View3D.HideAll;
  
  Space := Sphere(0,0,0,1000);
  Space.BackMaterial := ImageMaterial('data/Maps/spacemap3.jpg',0.2,0.2);

  intro;
  whileMenu;
end.