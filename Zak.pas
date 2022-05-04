unit Zak;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TZakForm = class(TForm)
    TakBtn: TButton;
    NieBtn: TButton;
    Label1: TLabel;
    Bevel1: TBevel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ZakForm: TZakForm;

implementation

uses Budz;

{$R *.DFM}


end.
