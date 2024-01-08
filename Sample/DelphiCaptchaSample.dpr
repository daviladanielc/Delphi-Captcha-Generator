program DelphiCaptchaSample;

uses
  Vcl.Forms,
  uPrin in 'uPrin.pas' {frmPrin},
  Captcha.Contract in '..\src\Captcha.Contract.pas',
  Captcha.Enum in '..\src\Captcha.Enum.pas',
  Captcha.Impl in '..\src\Captcha.Impl.pas',
  Captcha.Intf in '..\src\Captcha.Intf.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown:= True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrin, frmPrin);
  Application.Run;
end.
