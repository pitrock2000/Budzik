unit Al;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls;

type
  TAlForm = class(TForm)
    OKBtn: TButton;
    Bevel1: TBevel;
    InfoText: TStaticText;
    procedure OKBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AlForm: TAlForm;

implementation

uses Budz;

{$R *.DFM}

procedure TAlForm.OKBtnClick(Sender: TObject);
begin
  BudzApp.Player1.Stop;
  BudzApp.Player1.Rewind;
  BudzApp.Position:=poScreenCenter;
  BudzApp.Show;
  PlayMin:=False;
  WaveSetVolume(VolOld,VolOld);
  BudzApp.Timer4.Enabled:=False;
end;


end.
