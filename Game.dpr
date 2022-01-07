program Game;

uses
  Forms,
  frmMain in 'Forms\frmMain.pas' {MainForm},
  Painter in 'Drawing\Painter.pas' {Painter},
  GamePlay in 'Core\GamePlay.pas',
  Physics in 'Core\Physics.pas',
  DrwShapeClasses in 'Drawing\DrwShapeClasses.pas',
  Scene in 'Core\Scene.pas',
  FootBallModel in 'Model\FootBallModel.pas',
  FootBallObjects in 'Model\FootBallObjects.pas',
  frmProfile in 'Forms\frmProfile.pas' {ProfileForm},
  Data in 'Core\Data.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, FMainForm);
  Application.Run;
end.
