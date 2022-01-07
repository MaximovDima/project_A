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

    //�������� �� ������������� �������
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

    //������ ������������
    property UserInfo: TUserInfo read FUserInfo write FUserInfo;
    //������ � �������
    property Team: TTeam read FTeam write FTeam;

    //�������� ������
    procedure Load;
    //���������� ������
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
  //�������� �� ��������� ������
  //���� ��� ����� ������ ��������
  UserInfo.Name := '����������';
  Team.Name := 'FC Manchester City';
  Team.SchemeName := '4-3-3';
end;

procedure TData.Save;
begin
  //���������� ������
end;

end.
