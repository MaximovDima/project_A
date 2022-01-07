unit frmProfile;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TProfileForm = class(TForm)
    lblName: TLabel;
    edtName: TEdit;
    btnOk: TButton;
    btnCancel: TButton;
    lblTeamName: TLabel;
    edtTeamName: TEdit;
    lblScheme: TLabel;
    edtScheme: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  public
    function Execute: Boolean;
  end;

implementation

{$R *.dfm}

{ TProfileForm }

function TProfileForm.Execute: Boolean;
begin
  Result := ShowModal = mrOK;
end;

procedure TProfileForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = mrOk then
  begin
    btnOk.SetFocus;
    if SameStr('', edtName.Text) then
      raise Exception.Create('Необходимо задать имя профиля!');
    if SameStr('', edtTeamName.Text) then
      raise Exception.Create('Необходимо задать имя команды!');
    if SameStr('', edtScheme.Text) then
      raise Exception.Create('Необходимо задать схему!');
  end;
end;

end.
