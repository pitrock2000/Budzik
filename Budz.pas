unit Budz;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ExtCtrls, Spin, MPlayer, Al, Zak,
  ComCtrls,MMSystem ;

type
  TBudzApp = class(TForm)
    AlarmGrp: TGroupBox;
    OKBtn: TButton;
    WylBtn: TButton;
    Timer2: TTimer;
    AktCzasGrp: TGroupBox;
    CzasLbl: TLabel;
    Timer1: TTimer;
    Player1: TMediaPlayer;
    LabelPP: TLabel;
    OpenDialog1: TOpenDialog;
    ZapiszBtn: TButton;
    PageControl1: TPageControl;
    Standardowe: TTabSheet;
    Zaawansowane: TTabSheet;
    Label0: TLabel;
    Nr1Box: TCheckBox;
    Nr2Box: TCheckBox;
    Nr3Box: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit1Info: TEdit;
    Edit2Info: TEdit;
    Edit3Info: TEdit;
    SpinEdit1G: TSpinEdit;
    SpinEdit2G: TSpinEdit;
    SpinEdit3G: TSpinEdit;
    SpinEdit1M: TSpinEdit;
    SpinEdit2M: TSpinEdit;
    SpinEdit3M: TSpinEdit;
    Label4: TLabel;
    NosB1: TCheckBox;
    NosB2: TCheckBox;
    NosB3: TCheckBox;
    Label5: TLabel;
    LoopB1: TCheckBox;
    LoopB2: TCheckBox;
    LoopB3: TCheckBox;
    Label7: TLabel;
    LabelS1: TLabel;
    LabelS2: TLabel;
    LabelS3: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label6: TLabel;
    CresB1: TCheckBox;
    CresB2: TCheckBox;
    CresB3: TCheckBox;
    LabelA1: TLabel;
    LabelA2: TLabel;
    LabelA3: TLabel;
    Label16: TLabel;
    SpinEditMin: TSpinEdit;
    MinBox: TCheckBox;
    ZmienSygnal: TButton;
    LabelMin: TLabel;
    LabelWer: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Timer3: TTimer;
    Bevel4: TBevel;
    Timer4: TTimer;
    Timer5: TTimer;
    procedure Nr1BoxClick(Sender: TObject);
    procedure Nr2BoxClick(Sender: TObject);
    procedure Nr3BoxClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure WylBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ZmienSygnalClick(Sender: TObject);
    procedure SpinEdit1MExit(Sender: TObject);
    procedure SpinEdit2MExit(Sender: TObject);
    procedure SpinEdit3MExit(Sender: TObject);
    procedure SpinEdit1MChange(Sender: TObject);
    procedure ZapiszBtnClick(Sender: TObject);
    procedure SpinEdit1GChange(Sender: TObject);
    procedure Edit1InfoChange(Sender: TObject);
    procedure SpinEdit2GChange(Sender: TObject);
    procedure SpinEdit2MChange(Sender: TObject);
    procedure Edit2InfoChange(Sender: TObject);
    procedure SpinEdit3GChange(Sender: TObject);
    procedure SpinEdit3MChange(Sender: TObject);
    procedure Edit3InfoChange(Sender: TObject);
    procedure Player1Notify(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure NosB1Click(Sender: TObject);
    procedure NosB2Click(Sender: TObject);
    procedure NosB3Click(Sender: TObject);
    procedure LoopB1Click(Sender: TObject);
    procedure LoopB2Click(Sender: TObject);
    procedure LoopB3Click(Sender: TObject);
    procedure MyOnMinimize(Sender: TObject);
    procedure MyOnRestore(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure MinBoxClick(Sender: TObject);
    procedure Timer4Timer(Sender: TObject);
    procedure Timer5Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BudzApp: TBudzApp;
  PlayMin: Boolean;
  Vol,VolOld,DeltaVoL: Byte;

procedure WaveSetVolume(LVol,RVol:Byte);
procedure WaveGetVolume(var LVol:Byte;var RVol:Byte);

implementation

{$R *.DFM}

type TypUstawRec=record
                   Aktywny: Boolean;
                   godz,min: Integer;
                   Info: String[31];
                   NoSound,Loop,Cres: Boolean;
                   Syg: String[130];
                 end;
var
  UstawRec: TypUstawRec;
  plik: file of TypUstawRec;
  s1,s2,s3: String[130];
  LiczMin: Word;

procedure WaveSetVolume(LVol,RVol:Byte);
begin
 WaveOutSetVolume(WAVE_MAPPER,Integer(((LVol shl 8) or (RVol shl 24))));
end;

procedure WaveGetVolume(var LVol:Byte;var RVol:Byte);
var Vol: Integer;
begin
 WaveOutGetVolume(WAVE_MAPPER,@Vol);
 LVol:=Hi(Vol);
 RVol:=Vol shr 24;
end;

procedure Zapisz;
begin
  SetCurrentDir(ExtractFileDir(Application.ExeName));
  AssignFile(plik,'Budz.dat');
  Rewrite(plik);
  with UstawRec do
    with BudzApp do begin
      Aktywny:=Nr1Box.Checked;
      godz:=SpinEdit1G.Value;
      min:=SpinEdit1M.Value;
      Info:=Edit1Info.Text;
      NoSound:=NosB1.Checked;
      Loop:=LoopB1.Checked;
      Cres:=CresB1.Checked;
      Syg:=s1;
      Write(plik,UstawRec);
        Aktywny:=Nr2Box.Checked;
        godz:=SpinEdit2G.Value;
        min:=SpinEdit2M.Value;
        Info:=Edit2Info.Text;
        NoSound:=NosB2.Checked;
        Loop:=LoopB2.Checked;
        Cres:=CresB2.Checked;
        Syg:=s2;
        Write(plik,UstawRec);
          Aktywny:=Nr3Box.Checked;
          godz:=SpinEdit3G.Value;
          min:=SpinEdit3M.Value;
          Info:=Edit3Info.Text;
          NoSound:=NosB3.Checked;
          Loop:=LoopB3.Checked;
          Cres:=CresB3.Checked;
          Syg:=s3;
          Write(plik,UstawRec);
    end;
  CloseFile(plik);
end;

procedure Wczytaj;
begin
  AssignFile(plik,'Budz.dat');
  Reset(plik);
  with UstawRec do
    with BudzApp do begin
      Read(plik,UstawRec);
      Nr1Box.Checked:=Aktywny;
      SpinEdit1G.Value:=godz;
      SpinEdit1M.Value:=min;
      Edit1Info.Text:=Info;
      NosB1.Checked:=NoSound;
      LoopB1.Checked:=Loop;
      CresB1.Checked:=Cres;
      s1:=Syg;
        Read(plik,UstawRec);
        Nr2Box.Checked:=Aktywny;
        SpinEdit2G.Value:=godz;
        SpinEdit2M.Value:=min;
        Edit2Info.Text:=Info;
        NosB2.Checked:=NoSound;
        LoopB2.Checked:=Loop;
        CresB2.Checked:=Cres;
        s2:=Syg;
          Read(plik,UstawRec);
          Nr3Box.Checked:=Aktywny;
          SpinEdit3G.Value:=godz;
          SpinEdit3M.Value:=min;
          Edit3Info.Text:=Info;
          NosB3.Checked:=NoSound;
          LoopB3.Checked:=Loop;
          CresB3.Checked:=Cres;
          s3:=Syg;
    end;
  CloseFile(plik);
end;

procedure TBudzApp.MyOnMinimize(Sender: TObject);
begin
  Timer1.Enabled:=False;
end;

procedure TBudzApp.MyOnRestore(Sender: TObject);
begin
  Timer1.Enabled:=True;
end;

procedure TBudzApp.Nr1BoxClick(Sender: TObject);
begin
  if Nr1Box.Checked then LabelA1.Font.Color:=clGreen
  else  LabelA1.Font.Color:=clMaroon;
  SpinEdit1G.Enabled:=not SpinEdit1G.Enabled;
  SpinEdit1M.Enabled:=not SpinEdit1M.Enabled;
  Edit1Info.Enabled:=not Edit1Info.Enabled;
  ZapiszBtn.Enabled:=true;
end;

procedure TBudzApp.Nr2BoxClick(Sender: TObject);
begin
  if Nr2Box.Checked then LabelA2.Font.Color:=clGreen
  else  LabelA2.Font.Color:=clMaroon;
  SpinEdit2G.Enabled:=not SpinEdit2G.Enabled;
  SpinEdit2M.Enabled:=not SpinEdit2M.Enabled;
  Edit2Info.Enabled:=not Edit2Info.Enabled;
  ZapiszBtn.Enabled:=true;
end;

procedure TBudzApp.Nr3BoxClick(Sender: TObject);
begin
  if Nr3Box.Checked then LabelA3.Font.Color:=clGreen
  else  LabelA3.Font.Color:=clMaroon;
  SpinEdit3G.Enabled:=not SpinEdit3G.Enabled;
  SpinEdit3M.Enabled:=not SpinEdit3M.Enabled;
  Edit3Info.Enabled:=not Edit3Info.Enabled;
  ZapiszBtn.Enabled:=true;
end;

procedure TBudzApp.OKBtnClick(Sender: TObject);
begin
  Application.Minimize;
end;

procedure TBudzApp.Timer1Timer(Sender: TObject);
begin
  CzasLbl.Caption:=TimeToStr(Time);
end;

procedure TBudzApp.Timer2Timer(Sender: TObject);
var
  h,m,s,ss: Word;
begin
  DecodeTime(Time,h,m,s,ss);
  if Nr1Box.Checked
  and (h=SpinEdit1G.Value) and (m=SpinEdit1M.Value) and (s=0)
  then begin
    if not NosB1.Checked then begin
      if CresB1.Checked then begin
        WaveGetVolume(VolOld,VolOld);
        Vol:=VolOld div 2;
        DeltaVol:=Vol div 10;
        WaveSetVolume(Vol,Vol);
        Timer5.Enabled:=True;
      end;
      Player1.FileName:=s1;
      Player1.Open;
      Player1.Play;
      Timer4.Enabled:=True;
    end;
    BudzApp.Top:=Screen.Height;
    Application.Restore;
    BudzApp.Hide;
    AlForm.InfoText.Caption:=Edit1Info.Text;
    if not AlForm.Visible then AlForm.ShowModal;
  end;
  if Nr2Box.Checked
  and (h=SpinEdit2G.Value) and (m=SpinEdit2M.Value) and (s=0)
  then begin
    if not NosB2.Checked then begin
      if CresB2.Checked then begin
        WaveGetVolume(VolOld,VolOld);
        Vol:=VolOld div 2;
        DeltaVol:=Vol div 10;
        WaveSetVolume(Vol,Vol);
        Timer5.Enabled:=True;
      end;
      Player1.FileName:=s2;
      Player1.Open;
      Player1.Play;
      Timer4.Enabled:=True;
    end;
    BudzApp.Top:=Screen.Height;
    Application.Restore;
    BudzApp.Hide;
    AlForm.InfoText.Caption:=Edit2Info.Text;
    if not AlForm.Visible then AlForm.ShowModal;
  end;
  if Nr3Box.Checked
  and (h=SpinEdit3G.Value) and (m=SpinEdit3M.Value) and (s=0)
  then begin
    if not NosB3.Checked then begin
      if CresB3.Checked then begin
        WaveGetVolume(VolOld,VolOld);
        Vol:=VolOld div 2;
        DeltaVol:=Vol div 10;
        WaveSetVolume(Vol,Vol);
        Timer5.Enabled:=True;
      end;
      Player1.FileName:=s3;
      Player1.Open;
      Player1.Play;
      Timer4.Enabled:=True;
    end;
    BudzApp.Top:=Screen.Height;
    Application.Restore;
    BudzApp.Hide;
    AlForm.InfoText.Caption:=Edit3Info.Text;
    if AlForm.Visible=false then AlForm.ShowModal;
  end;
  if MinBox.Checked and (LiczMin=SpinEditMin.Value)
  then begin
    WaveGetVolume(VolOld,VolOld);
    Vol:=VolOld div 2;
    DeltaVol:=Vol div 10;
    WaveSetVolume(Vol,Vol);
    Timer5.Enabled:=True;
    PlayMin:=True;
    Player1.FileName:=s1;
    Player1.Open;
    Player1.Play;
    LiczMin:=0;
    MinBox.Checked:=False;
    Timer3.Enabled:=False;
    Timer4.Enabled:=True;
    BudzApp.Top:=Screen.Height;
    Application.Restore;
    BudzApp.Hide;
    AlForm.InfoText.Caption:='- - -   M i n u t n i k   - - -';
    if not AlForm.Visible then AlForm.ShowModal;
  end;
end;

procedure TBudzApp.FormCreate(Sender: TObject);
var
  h,m,s,ss: Word;
begin
  Application.OnMinimize:=MyOnMinimize;
  Application.OnRestore:=MyOnRestore;
  if FileExists('Budz.dat') then begin
    Wczytaj;
    LabelS1.Caption:=ExtractFileName(s1);
    LabelS2.Caption:=ExtractFileName(s2);
    LabelS3.Caption:=ExtractFileName(s3);
  end else begin
    DecodeTime(Time,h,m,s,ss);
    SpinEdit1G.Value:=h;
    SpinEdit1M.Value:=m;
    SpinEdit2G.Value:=h;
    SpinEdit2M.Value:=m;
    SpinEdit3G.Value:=h;
    SpinEdit3M.Value:=m;
    s1:=ExpandFileName(Player1.FileName);
    s2:=ExpandFileName(Player1.FileName);
    s3:=ExpandFileName(Player1.FileName);
  end;
  with SpinEdit1M do
    if Value < 10 then Text:='0' + IntToStr(Value);
  with SpinEdit2M do
    if Value < 10 then Text:='0' + IntToStr(Value);
  with SpinEdit3M do
    if Value < 10 then Text:='0' + IntToStr(Value);
  if FileExists('Budz.dat') then ZapiszBtn.Enabled:=false;
  PageControl1.ActivePage:=Standardowe;
  LiczMin:=0;
  PlayMin:=False;
end;

procedure TBudzApp.WylBtnClick(Sender: TObject);
begin
  ZakForm.ShowModal;
  if ZakForm.ModalResult=mrOk then
  Application.Terminate;
end;

procedure TBudzApp.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ZakForm.ShowModal;
  if ZakForm.ModalResult=mrOk then
    Action:=caFree
  else Action:=caNone;
end;


procedure TBudzApp.ZmienSygnalClick(Sender: TObject);
begin
  if OpenDialog1.Execute then begin
    s1:=OpenDialog1.FileName;
    LabelS1.Caption:=ExtractFileName(s1);
    s2:=s1;
    LabelS2.Caption:=LabelS1.Caption;
    s3:=s1;
    LabelS3.Caption:=LabelS1.Caption;
    ZapiszBtn.Enabled:=true;
  end;
end;

procedure TBudzApp.SpinEdit1MExit(Sender: TObject);
begin
  if SpinEdit1M.Value<10 then
     SpinEdit1M.Text:='0'+IntToStr(SpinEdit1M.Value);
end;

procedure TBudzApp.SpinEdit2MExit(Sender: TObject);
begin
  if SpinEdit2M.Value<10 then
     SpinEdit2M.Text:='0'+IntToStr(SpinEdit2M.Value);
end;

procedure TBudzApp.SpinEdit3MExit(Sender: TObject);
begin
  if SpinEdit3M.Value<10 then
     SpinEdit3M.Text:='0'+IntToStr(SpinEdit3M.Value);
end;

procedure TBudzApp.SpinEdit1MChange(Sender: TObject);
begin
  ZapiszBtn.Enabled:=true; 
end;

procedure TBudzApp.ZapiszBtnClick(Sender: TObject);
begin
  Zapisz;
  ZapiszBtn.Enabled:=false;
end;

procedure TBudzApp.SpinEdit1GChange(Sender: TObject);
begin
  ZapiszBtn.Enabled:=true;
end;

procedure TBudzApp.Edit1InfoChange(Sender: TObject);
begin
  ZapiszBtn.Enabled:=true;
end;

procedure TBudzApp.SpinEdit2GChange(Sender: TObject);
begin
  ZapiszBtn.Enabled:=true;
end;

procedure TBudzApp.SpinEdit2MChange(Sender: TObject);
begin
  ZapiszBtn.Enabled:=true;
end;

procedure TBudzApp.Edit2InfoChange(Sender: TObject);
begin
  ZapiszBtn.Enabled:=true;
end;

procedure TBudzApp.SpinEdit3GChange(Sender: TObject);
begin
  ZapiszBtn.Enabled:=true;
end;

procedure TBudzApp.SpinEdit3MChange(Sender: TObject);
begin
  ZapiszBtn.Enabled:=true;
end;

procedure TBudzApp.Edit3InfoChange(Sender: TObject);
begin
  ZapiszBtn.Enabled:=true;
end;

procedure TBudzApp.Player1Notify(Sender: TObject);
begin
  if Player1.NotifyValue=nvSuccessful then begin
    if LoopB1.Checked and (s1=Player1.FileName)
    or LoopB2.Checked and (s2=Player1.FileName)
    or LoopB3.Checked and (s3=Player1.FileName)
    or PlayMin
    then Player1.Play
  end else Player1.Rewind;
end;

procedure TBudzApp.Button1Click(Sender: TObject);
begin
  OpenDialog1.FileName:=s1;
  if OpenDialog1.Execute then begin
    s1:=OpenDialog1.FileName;
    LabelS1.Caption:=ExtractFileName(s1);
  end
end;

procedure TBudzApp.Button2Click(Sender: TObject);
begin
  OpenDialog1.FileName:=s2;
  if OpenDialog1.Execute then begin
    s2:=OpenDialog1.FileName;
    LabelS2.Caption:=ExtractFileName(s2);
  end
end;

procedure TBudzApp.Button3Click(Sender: TObject);
begin
  OpenDialog1.FileName:=s3;
  if OpenDialog1.Execute then begin
    s3:=OpenDialog1.FileName;
    LabelS3.Caption:=ExtractFileName(s3);
  end
end;

procedure TBudzApp.NosB1Click(Sender: TObject);
begin
  LoopB1.Enabled:=not LoopB1.Enabled;
  CresB1.Enabled:=not CresB1.Enabled;
  ZapiszBtn.Enabled:=true;
end;

procedure TBudzApp.NosB2Click(Sender: TObject);
begin
  LoopB2.Enabled:=not LoopB2.Enabled;
  CresB2.Enabled:=not CresB2.Enabled;
  ZapiszBtn.Enabled:=true;
end;

procedure TBudzApp.NosB3Click(Sender: TObject);
begin
  LoopB3.Enabled:=not LoopB3.Enabled;
  CresB3.Enabled:=not CresB3.Enabled;
  ZapiszBtn.Enabled:=true;
end;

procedure TBudzApp.LoopB1Click(Sender: TObject);
begin
  ZapiszBtn.Enabled:=true;
end;

procedure TBudzApp.LoopB2Click(Sender: TObject);
begin
  ZapiszBtn.Enabled:=true;
end;

procedure TBudzApp.LoopB3Click(Sender: TObject);
begin
  ZapiszBtn.Enabled:=true;
end;

procedure TBudzApp.Timer3Timer(Sender: TObject);
begin
  Inc(LiczMin);
end;

procedure TBudzApp.MinBoxClick(Sender: TObject);
begin
  if MinBox.Checked then begin
    Timer3.Enabled:=True;
    LabelMin.Font.Color:=clGreen
  end else begin
    Timer3.Enabled:=False;
    LiczMin:=0;
    LabelMin.Font.Color:=clMaroon;
  end;
end;

procedure TBudzApp.Timer4Timer(Sender: TObject);
begin
  Player1.Stop;
  Player1.Rewind;
  PlayMin:=False;
  WaveSetVolume(VolOld,VolOld);
  Timer4.Enabled:=False;
end;

procedure TBudzApp.Timer5Timer(Sender: TObject);
var  V: Word;
begin
  V:=Vol;
  Inc(V,DeltaVol);
  if V>VolOld then begin
    V:=VolOld;
    Timer5.Enabled:=False;
  end;
  Vol:=V;
  WaveSetVolume(Vol,Vol);
end;

end.
