program TestPostal;

uses
  Vcl.Forms,
  Test in 'Test.pas' {PostalTester};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TPostalTester, PostalTester);
  Application.Run;

end.
