unit Data;

interface

uses
  StrUtils, SysUtils;

type
  TUserInfo = class
  strict private
    FName: String;
  public
    property Name: String read FName write FName;

    //Проверка на существование профиля
    function IsEmpty: Boolean;
  end;

  TTeam = class
  strict private
    FName: String;
    FSchemeName: String;
  public
    property Name: String read FName write FName;
    property SchemeName: String read FSchemeName write FSchemeName;
  end;

  TData = class
  strict private
    FUserInfo: TUserInfo;
    FTeam: TTeam;
  public
    constructor Create;

    //Данные пользователя
    property UserInfo: TUserInfo read FUserInfo write FUserInfo;
    //Данные о команде
    property Team: TTeam read FTeam write FTeam;

    //Загрузка данных
    procedure Load;
    //Сохранение данных
    procedure Save;
  end;

implementation

{ TApp.TData }

constructor TData.Create;
begin
  UserInfo := TUserInfo.Create;
  Team := TTeam.Create;
end;

function TUserInfo.IsEmpty: Boolean;
begin
  Result := SameStr('', Name);
end;

procedure TData.Load;
begin
  //Загрузка из источника данных
  //пока что будет стоять заглушка
  UserInfo.Name := 'Тренеришка';
  Team.Name := 'FC Manchester City';
  Team.SchemeName := '4-3-3';
end;

procedure TData.Save;
begin
  //Сохранение данных
end;

end.
