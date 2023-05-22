program LsCalc;

uses
  Forms,
  Main in 'Main.pas' {fmMain},
  DatMod1 in 'DatMod1.pas' {dm1: TDataModule};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(Tdm1, dm1);
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
