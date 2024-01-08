unit Captcha.Intf;

interface

uses Captcha.Contract, Captcha.Impl;

type

  ICaptcha = Captcha.Contract.ICaptcha;

  TCaptchaUtils = class
  public
    class function New: ICaptcha;
  end;

implementation

{ TCaptcha }

class function TCaptchaUtils.New: ICaptcha;
begin
  Result := TCaptcha.Create;
end;

end.
