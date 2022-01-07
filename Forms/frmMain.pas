unit frmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Painter, GamePlay, Menus, ComCtrls, ActnList, StdCtrls,
  Buttons, Data;

type

  TMainForm = class;

  TApp = class
  strict private
    FWindow: TMainForm;
    FRegime: String;
    FData: TData;
//    FEngine: TEngine;
  public
    constructor Create;
    destructor Destroy;

    //������ �� �����
    property Window: TMainForm read FWindow write FWindow;
    //���������� �����
    property Regime: String read FRegime write FRegime;
    //��������� ������
    property Data: TData read FData write FData;

    //������ ����������
    function Start(AWindow: TMainForm): Boolean;
    //�������� ������������� ������������
    function UserExist: Boolean;
    //�������� ������
    procedure SyncWindow;
    //�������� ������ ������������
    function EditUser(AIsNew: Boolean): Boolean;
    //��������� ������
    procedure SetRegime(ARegime: String);
  end;

  TMainForm = class(TForm)
    Panel: TPanel;
    MainMenu: TMainMenu;
    Setting: TMenuItem;
    Stat: TMenuItem;
    Training: TMenuItem;
    Match: TMenuItem;
    pcMain: TPageControl;
    tsSettings: TTabSheet;
    tsStat: TTabSheet;
    tsTraining: TTabSheet;
    tsMatch: TTabSheet;
    ActionList: TActionList;
    actSetRegime: TAction;
    lblName: TLabel;
    btnEditProfile: TButton;
    PaintBox: TPaintBox;
    lblTeamName: TLabel;
    lblScheme: TLabel;
    edtUserName: TEdit;
    edtTeamName: TEdit;
    edtScheme: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure actSetRegimeExecute(Sender: TObject);
    procedure btnEditProfileClick(Sender: TObject);
  private
    Painter: TfrmPainter;
  end;

var
  FMainForm: TMainForm;
  App: TApp;

implementation

uses
  frmProfile;

{$R *.dfm}

procedure TMainForm.actSetRegimeExecute(Sender: TObject);
begin
  App.SetRegime(TMenuItem(Sender).Name);
end;

procedure TMainForm.btnEditProfileClick(Sender: TObject);
begin
  App.EditUser(False);
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  Game.DoStop;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  App := TApp.Create;
  if App.Start(Self) then
  begin
    App.SetRegime('Setting');
    Show;
  end
  else
    Application.Terminate;
{  //�������� �����������
  Painter := TfrmPainter.Create(Self);
  Painter.Init(Panel);
  //�������� � ������������� ����
  Game := InitGame(Panel.Width, Panel.Height);
  //����������� �����������
  Game.InitDrwManager(Painter);
  //��������� ���������� ���������
  Game.LoadLayer(ltBack);
//  Game.UpdateFrame;    }
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
//  Game.Free;
  App.Free;
end;

{ TApp }

constructor TApp.Create;
begin
  Data := TData.Create;
end;

function TApp.EditUser(AIsNew: Boolean): Boolean;
begin
  with TProfileForm.Create(nil) do
  try
    if not AIsNew then
    begin
      edtName.Text := Data.UserInfo.Name;
      edtTeamName.Text := Data.Team.Name;
      edtScheme.Text := Data.Team.SchemeName;
    end;
    Result := Execute;
    if Result then
    begin
      Data.UserInfo.Name := edtName.Text;
      Data.Team.Name := edtTeamName.Text;
      Data.Team.SchemeName := edtScheme.Text;
      SyncWindow;
    end;
  finally
    Free;
  end;
end;

destructor TApp.Destroy;
begin
  Data.Free;
end;

procedure TApp.SyncWindow;
begin
  Window.edtUserName.Text := Data.UserInfo.Name;
  Window.edtTeamName.Text := Data.Team.Name;
  Window.edtScheme.Text := Data.Team.SchemeName;
end;

procedure TApp.SetRegime(ARegime: String);
var
  vTabSheet: TTabSheet;
begin
  Regime := ARegime;
  if SameStr(ARegime, 'Setting') then
    vTabSheet := Window.tsSettings
  else if SameStr(ARegime, 'Stat') then
    vTabSheet := Window.tsStat
  else if SameStr(ARegime, 'Training') then
    vTabSheet := Window.tsTraining
  else if SameStr(ARegime, 'Match') then
    vTabSheet := Window.tsMatch;

  Window.pcMain.ActivePage := vTabSheet;
end;

function TApp.Start(AWindow: TMainForm): Boolean;
begin
  Result := True;
  //�������� ������ �� ������� ����
  Window := AWindow;
  //���� ������� ����������, ��������� ���, ����� ���������� ��� �������
  if UserExist then
    SyncWindow
  else
    Result := EditUser(True);
end;

function TApp.UserExist: Boolean;
begin
  Data.Load;
  Result := not Data.UserInfo.IsEmpty;
end;

end.
