Unit gameInterface;
Uses Graph3D;
uses Objects;

var
  logo: RectangleT;
  buttons: array[1..5] of TextT;
  menuAction: string;

///Игровой интерфейс
var
  hudHealth: RectangleT;
  gamePointsBoard: TextT;
procedure drawHud;
begin;
  hudHealth := Rectangle3D(7, 0, 8, 2, 0.2, -Camera.LookDirection,OrtX, DiffuseMaterial(Colors.Brown));
  Rectangle3D(7, -0.01, 8, 2.05, 0.25, -Camera.LookDirection,OrtX, DiffuseMaterial(Colors.White));
  gamePointsBoard:= Text3D(-7,0,8,' 00000 ',0.4);
  gamePointsBoard.Rotate(OrtX, 20);
end;

///Меню
procedure drawMenu();
var r: Group3D;
begin
  Camera.Position:= P3D(-4,0,11);
  Camera.LookDirection:= V3D(10,0,0);
  Camera.AddDownForce(1.6);
  logo.Destroy;
  logo := Rectangle3D(10,0,1.4,1.5,4, -OrtX,OrtY,ImageMaterial('data/WorldObjects/logo.png'));
  logo.Rotate(Camera.LookDirection, -90);
  //Кнопки
  buttons[1] := Text3D(40,0,-0.5,'Continue',0.6);
  buttons[2]:= Text3D(40,0,-2,'New game',0.6);
  buttons[3]:= Text3D(40,0,-3.5,'Surviving',0.6);
  buttons[4]:= Text3D(40,0,-5,'About game',0.6);  
  buttons[5]:= Text3D(40,0,-6.5,'Exit',0.6);

  for var i:=1 to 5 do
  begin
    buttons[i].Color:= Colors.Yellow;
    buttons[i].Rotate(OrtZ, 90);
  end;
  //Рамка
  r:= Group(
    Rectangle3D(41, 0, 0.7, 5, 0.15,-OrtX,OrtY, Materials.Diffuse(Colors.Yellow)),
    Rectangle3D(41, 0, -0.7, 5, 0.15,-OrtX,OrtY, Materials.Diffuse(Colors.Yellow))
    );
  r.Z:= buttons[1].Z;
  
  OnMouseDown += (x,y,mb) ->
    for var i:=1 to 5 do
      if FindNearestObject(x,y) = buttons[i] then
      begin
        case i of
          1: menuAction:='continue';
          2: menuAction:='newgame';
          5: Window.Close;
        end;
        for var k:=1 to 5 do buttons[k].Destroy;
        r.Destroy;
      end;
      
  OnMouseMove += (x,y,mb)->
    for var i:=1 to 5 do
      if FindNearestObject(x,y) = buttons[i] then
        r.Z := buttons[i].Z;
  
end;

///Заставка
procedure intro;
begin  
  Camera.Position:= P3D(-4,0,11);
  Camera.LookDirection:= V3D(10,0,0);
  Lights.AddDirectionalLight(Colors.White, Camera.LookDirection);
  
  logo := Rectangle3D(-2,0,11,1.5,4, -OrtX,OrtY,ImageMaterial('data/WorldObjects/logo.png'));
  logo.Rotate(Camera.LookDirection, -90);
  logo.AnimMoveBy(Camera.LookDirection.X*20,Camera.LookDirection.Y*20,Camera.LookDirection.Z*20, 5).AccelerationRatio(1000,0).WhenCompleted(drawMenu).Begin;

end;

///Конец игры
procedure drawResults;
begin
  Lights.AddDirectionalLight(Colors.White, Camera.LookDirection);
  var txt := Text3D(40,0,0,'0'+gamePoints,0.6);
  txt.Color:= Colors.Yellow;
  txt.Rotate(OrtZ, 90);
//  var s:= Sphere(40,0,0,10, Materials.Emissive(Colors.Red));
end;


end.
