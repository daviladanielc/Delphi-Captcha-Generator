unit Captcha.Impl;

interface

uses Vcl.Graphics, System.Classes, System.SysUtils, System.NetEncoding,
  Winapi.Messages, Captcha.Contract, Captcha.Enum, Vcl.imaging.jpeg;

type

  ECaptchaBuildError = class(Exception)
  public
    constructor Create(const Msg: string); overload;
  end;

  TCaptcha = class(TInterfacedObject, ICaptcha)
  private
    FBackgroundColor: TColor;
    FCaptchaText: String;
    FCaptchaType: TCaptchaType;
    FCustomText: String;
    FDifficulty: TDifficulty;
    FFontColor: TColor;
    FFontName: string;
    FFontSize: integer;
    FHeight: integer;
    FImageStream: TMemoryStream;
    FLength: integer;
    FLetterCase: TLetterCase;
    FWidth: integer;
    function GenerateCaptcha: String;
  public
    constructor Create;
    destructor Destroy; override;
    function Alphanumeric: ICaptcha;
    function Build: ICaptcha;
    function Easy: ICaptcha;
    function Font(const AName: String; Const ASize: integer;
      const AColor: TColor): ICaptcha;
    function GetTextCaptcha: string;
    function Hard: ICaptcha;
    function LetterLowerCase: ICaptcha;
    function LetterMixed: ICaptcha;
    function Letters: ICaptcha;
    function LetterUpperCase: ICaptcha;
    function Moderate: ICaptcha;
    function Numbers: ICaptcha;
    function SetCustomCaptcha(const ACustomCaptcha: String): ICaptcha;
    function SetBackgroundColor(const Value: TColor):ICaptcha;
    function SetHeigth(const Value: integer): ICaptcha;
    function SetLength(const Value: integer): ICaptcha;
    function SetWidth(const Value: integer): ICaptcha;
    function ToBase64: String;
    function ToBitmap: Vcl.Graphics.TBitmap;
    function ToJPEG: TJPEGimage;
    function ToStream: TMemoryStream;
    function Validate(const AText: string): boolean;
  end;

implementation

uses
  Winapi.Windows;

{ TCaptcha }

function TCaptcha.Alphanumeric: ICaptcha;
begin
  Result := Self;
  FCaptchaType := ctAlphaNumeric;
end;

function TCaptcha.Build: ICaptcha;
var
  i, x, y: integer;
  LDifficultyDots: integer;
  LDifficultyLines: integer;
  LBitmap: Vcl.Graphics.TBitmap;
begin
  Result := Self;
  FImageStream.Clear;
  LDifficultyDots := 0;
  LDifficultyLines := 0;
  try
    if FCustomText = '' then
      FCaptchaText := GenerateCaptcha
    else
      FCaptchaText := FCustomText;

    case FDifficulty of
      dcEasy:
        begin
          LDifficultyDots := 100;
          LDifficultyLines := 10;
        end;
      dcModerate:
        begin
          LDifficultyDots := 300;
          LDifficultyLines := 20;
        end;
      dcHard:
        begin
          LDifficultyDots := 500;
          LDifficultyLines := 30;
        end;
    end;

    LBitmap := Vcl.Graphics.TBitmap.Create;
    try
      LBitmap.Width := FWidth;
      LBitmap.Height := FHeight;

      // Calculates the initial position to center the text
      x := (FWidth - LBitmap.Canvas.TextWidth(FCaptchaText)) div 2;
      y := (FHeight - LBitmap.Canvas.TextHeight(FCaptchaText)) div 2;

      // Applies the font before drawing the text
      LBitmap.Canvas.Font.Size := FFontSize;
      LBitmap.Canvas.Font.Name := FFontName;
      LBitmap.Canvas.Font.Color := FFontColor;

      // Set the background color
      LBitmap.Canvas.Brush.Color := FBackgroundColor;
      LBitmap.Canvas.Brush.Style:= bsSolid;
      LBitmap.Canvas.FillRect(Rect(0, 0, LBitmap.Width, LBitmap.Height));

      // Draws the text on the image
      LBitmap.Canvas.TextOut(x, y, FCaptchaText);

      // Adds noise to the image (random dots).
      for i := 1 to LDifficultyDots do
      begin
        x := Random(FWidth);
        y := Random(FHeight);
        LBitmap.Canvas.Pixels[x, y] := clBlack;
      end;

      // Adds random lines to the image
      for i := 1 to LDifficultyLines do
      begin
        LBitmap.Canvas.Pen.Color := RGB(Random(256), Random(256), Random(256));
        LBitmap.Canvas.MoveTo(Random(FWidth), Random(FHeight));
        LBitmap.Canvas.LineTo(Random(FWidth), Random(FHeight));
      end;

      LBitmap.SaveToStream(FImageStream);
      FImageStream.Position := 0;
    finally
      LBitmap.Free;
    end;
  except
    on E: Exception do
      ECaptchaBuildError.Create(E.Message);
  end;

end;

constructor TCaptcha.Create;
begin
  FCustomText := '';
  FDifficulty := dcEasy;
  FCaptchaType := ctAlphaNumeric;
  FLetterCase := lcUppercase;
  FWidth := 200;
  FHeight := 80;
  FLength := 6;
  FBackgroundColor:= clWhite;
  FImageStream := TMemoryStream.Create;
end;

destructor TCaptcha.Destroy;
begin
  FImageStream.Free;
  inherited;
end;

function TCaptcha.Easy: ICaptcha;
begin
  Result := Self;
  FDifficulty := dcEasy;
end;

function TCaptcha.Font(const AName: String; Const ASize: integer;
  const AColor: TColor): ICaptcha;
begin
  Result := Self;
  FFontName := AName;
  FFontColor := AColor;
  FFontSize := ASize;
end;

function TCaptcha.GenerateCaptcha: String;
var
  i: integer;
begin
  for i := 1 to FLength do
  begin
    case FCaptchaType of
      ctLetters:
        Result := Result + Chr(65 + Random(26));
      ctNumbers:
        Result := Result + IntToStr(Random(10));
      ctAlphaNumeric:
        if Random(2) = 0 then
          Result := Result + Chr(65 + Random(26))
        else
          Result := Result + IntToStr(Random(10));
    end;
  end;

  case FLetterCase of
    lcUppercase:
      Result := Result.ToUpper;
    lcLowercase:
      Result := Result.ToLower;
    lcMixed:
      begin
        for i := 1 to Length(Result) do
        begin
          if Random(2) = 0 then
            Result[i] := UpperCase(Result[i])[1]
          else
            Result[i] := LowerCase(Result[i])[1];
        end;
      end;
  end;
end;

function TCaptcha.GetTextCaptcha: string;
begin
  Result := FCaptchaText;
end;

function TCaptcha.Hard: ICaptcha;
begin
  Result := Self;
  FDifficulty := dcHard;
end;

function TCaptcha.Letters: ICaptcha;
begin
  Result := Self;
  FCaptchaType := ctLetters;
end;

function TCaptcha.LetterLowerCase: ICaptcha;
begin
  Result := Self;
  FLetterCase := lcLowercase;
end;

function TCaptcha.LetterMixed: ICaptcha;
begin
  Result := Self;
  FLetterCase := lcMixed;
end;

function TCaptcha.Moderate: ICaptcha;
begin
  Result := Self;
  FDifficulty := dcModerate;
end;

function TCaptcha.Numbers: ICaptcha;
begin
  Result := Self;
  FCaptchaType := ctNumbers;
end;

function TCaptcha.SetBackgroundColor(const Value: TColor): ICaptcha;
begin
  Result:= Self;
  FBackgroundColor:= Value;
end;

function TCaptcha.SetCustomCaptcha(const ACustomCaptcha: String): ICaptcha;
begin
  Result := Self;
  FCustomText := ACustomCaptcha;
end;

function TCaptcha.SetHeigth(const Value: integer): ICaptcha;
begin
  Result := Self;
  FHeight := Value;
end;

function TCaptcha.SetLength(const Value: integer): ICaptcha;
begin
  Result := Self;
  FLength := Value;
end;

function TCaptcha.SetWidth(const Value: integer): ICaptcha;
begin
  Result := Self;
  FWidth := Value;
end;

function TCaptcha.ToBase64: String;
var
  LInput: TBytesStream;
  LOutput: TStringStream;
  LEncoding: TBase64Encoding;
begin
  LInput := TBytesStream.Create;
  try
    FImageStream.SaveToStream(LInput);
    LInput.Position := 0;
    LOutput := TStringStream.Create('', TEncoding.ASCII);
    try
      LEncoding := TBase64Encoding.Create(0);
      try
        LEncoding.Encode(LInput, LOutput);
        Result := LOutput.DataString;
      finally
        LEncoding.Free;
      end;
    finally
      LOutput.Free;
    end;
  finally
    LInput.Free;
  end;
end;

function TCaptcha.ToBitmap: Vcl.Graphics.TBitmap;
var
  LBitmap: Vcl.Graphics.TBitmap;
  LStream: TMemoryStream;
begin
  try
    LBitmap := Vcl.Graphics.TBitmap.Create;
    LStream := Self.ToStream;
    LBitmap.LoadFromStream(LStream);
    Result := LBitmap;
  finally
    LStream.Free;
  end;

end;

function TCaptcha.ToJPEG: TJPEGimage;
var
  LStream: TMemoryStream;
  LBitmap: Vcl.Graphics.TBitmap;
begin
  LBitmap := Self.ToBitmap;
  try
    Result := TJPEGimage.Create;
    Result.Assign(LBitmap);
  finally
    LBitmap.Free;
  end;
end;

function TCaptcha.ToStream: TMemoryStream;
begin
  Result := TMemoryStream.Create;
  Result.LoadFromStream(FImageStream);
  Result.Position := 0;
end;

function TCaptcha.LetterUpperCase: ICaptcha;
begin
  Result := Self;
  FLetterCase := lcUppercase;
end;

function TCaptcha.Validate(const AText: string): boolean;
begin
  Result := (AText.Trim = FCaptchaText);
end;

{ ECaptchaBuildError }

constructor ECaptchaBuildError.Create(const Msg: string);
begin
  Inherited Create(Msg);
end;

end.
