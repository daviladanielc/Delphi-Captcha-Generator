unit uPrin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.imaging.jpeg, Clipbrd,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Captcha.Intf, Vcl.Buttons, System.ImageList, Vcl.ImgList, Winapi.ShellAPI;

type

  TLabeledEditorHelper = class helper for TLabeledEdit
  public
    function ToInteger: Integer;
  end;

  TfrmPrin = class(TForm)
    pnl1: TPanel;
    grpBitmap: TGroupBox;
    grpJPEG: TGroupBox;
    grpMemoryStream: TGroupBox;
    imgBitmap: TImage;
    imgJPEG: TImage;
    btnSaveStream: TButton;
    btnNewNumber: TButton;
    btnReload: TButton;
    edtValidate: TEdit;
    btnNewLetters: TButton;
    btnNewAlpha: TButton;
    lbledtLength: TLabeledEdit;
    rgOptions: TRadioGroup;
    rgDifficulty: TRadioGroup;
    btnBase64: TButton;
    dlgFont1: TFontDialog;
    il1: TImageList;
    Button1: TButton;
    lbledtWidth: TLabeledEdit;
    lbledtHeigth: TLabeledEdit;
    lblValidate: TLabel;
    dlgSave1: TSaveDialog;
    btn1: TButton;
    clrbx1: TColorBox;
    lbl1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnNewNumberClick(Sender: TObject);
    procedure btnNewLettersClick(Sender: TObject);
    procedure btnNewAlphaClick(Sender: TObject);
    procedure btnReloadClick(Sender: TObject);
    procedure edtValidateExit(Sender: TObject);
    procedure btnSaveStreamClick(Sender: TObject);
    procedure btnBase64Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
    procedure SetCaptchaDefaults;
  public
    { Public declarations }
    FCaptcha: ICaptcha;
  end;

var
  frmPrin: TfrmPrin;

implementation

{$R *.dfm}

procedure TfrmPrin.btn1Click(Sender: TObject);
begin
  ShowMessage(FCaptcha.GetTextCaptcha);
end;

procedure TfrmPrin.btnBase64Click(Sender: TObject);
begin
  Clipboard.AsText := FCaptcha.ToBase64;
  Application.MessageBox('Copied to clipboard.', 'Captcha',
    MB_OK + MB_ICONINFORMATION);

end;

procedure TfrmPrin.btnNewAlphaClick(Sender: TObject);
var
  LJpeg: TJPEGImage;
  LBitMap: TBitmap;
begin
  SetCaptchaDefaults;

  case rgDifficulty.ItemIndex of
    0:
      FCaptcha.Easy;
    1:
      FCaptcha.Moderate;
    2:
      FCaptcha.Hard;
  end;

  case rgOptions.ItemIndex of
    0:
      FCaptcha.LetterUpperCase;
    1:
      FCaptcha.LetterLowerCase;
    2:
      FCaptcha.LetterMixed;
  end;

  FCaptcha.Alphanumeric.Build;
  try
    LJpeg := FCaptcha.ToJPEG;
    // Results an TJPEGImage and it's your responsability to relasead from the memory.
    LBitMap := FCaptcha.ToBitmap; // Same
    imgJPEG.Picture.Assign(LJpeg);
    imgBitmap.Picture.Assign(LBitMap);
  finally
    LJpeg.Free;
    LBitMap.Free;
  end;
end;

procedure TfrmPrin.btnNewLettersClick(Sender: TObject);
var
  LJpeg: TJPEGImage;
  LBitMap: TBitmap;
begin
  SetCaptchaDefaults;

  case rgDifficulty.ItemIndex of
    0:
      FCaptcha.Easy;
    1:
      FCaptcha.Moderate;
    2:
      FCaptcha.Hard;
  end;

  case rgOptions.ItemIndex of
    0:
      FCaptcha.LetterUpperCase;
    1:
      FCaptcha.LetterLowerCase;
    2:
      FCaptcha.LetterMixed;
  end;
  { you can use like this:
    FCaptcha.SetWidth
    .SetLegth
    .SetHeigth
    .Font()
    .Easy
    .Letters
    .LetterMixed
    .Build;
    or

    LJpeg:= FCaptcha.SetWidth
    .SetLegth
    .SetHeigth
    .Font()
    .Easy
    .Letters.
    .LettersMixed
    .ToJPEG;
  }

  FCaptcha.Letters.Build;
  try
    LJpeg := FCaptcha.ToJPEG;
    // Results an TJPEGImage and it's your responsability to relasead from the memory.
    LBitMap := FCaptcha.ToBitmap; // Same
    imgJPEG.Picture.Assign(LJpeg);
    imgBitmap.Picture.Assign(LBitMap);
  finally
    LJpeg.Free;
    LBitMap.Free;
  end;
end;

procedure TfrmPrin.btnNewNumberClick(Sender: TObject);
var
  LJpeg: TJPEGImage;
  LBitMap: TBitmap;
begin
  SetCaptchaDefaults;
  // hey this is just a sample
  case rgDifficulty.ItemIndex of
    0:
      FCaptcha.Easy;
    1:
      FCaptcha.Moderate;
    2:
      FCaptcha.Hard;
  end;

  FCaptcha.Numbers.Build;
  { you can use like this:
    FCaptcha.SetWidth
    .SetLegth
    .SetHeigth
    .Font()
    .Easy
    .Numbers
    .Build
    or

    LJpeg:= FCaptcha.SetWidth
    .SetLegth
    .SetHeigth
    .Font()
    .Easy
    .Numbers
    .Build
    .ToJPEG;
  }

  try
    LJpeg := FCaptcha.ToJPEG;
    // Results an TJPEGImage and it's your responsability to relasead from the memory.
    LBitMap := FCaptcha.ToBitmap; // Same
    imgJPEG.Picture.Assign(LJpeg);
    imgBitmap.Picture.Assign(LBitMap);
  finally
    LJpeg.Free;
    LBitMap.Free;
  end;
end;

procedure TfrmPrin.btnReloadClick(Sender: TObject);
var
  LJpeg: TJPEGImage;
  LBitMap: TBitmap;
begin
  FCaptcha.Build; // to refresh just call the build;
  try
    LJpeg := FCaptcha.ToJPEG;
    // Results an TJPEGImage and it's your responsability to relasead from the memory.
    LBitMap := FCaptcha.ToBitmap; // Same
    imgJPEG.Picture.Assign(LJpeg);
    imgBitmap.Picture.Assign(LBitMap);
  finally
    LJpeg.Free;
    LBitMap.Free;
  end;
end;

procedure TfrmPrin.btnSaveStreamClick(Sender: TObject);
var
  LStream: TMemoryStream;
begin
  if (dlgSave1.Execute) and (dlgSave1.FileName <> '') then
  begin
    try
      LStream:= TCaptchaUtils
                 .New
                   .Alphanumeric
                   .SetHeigth(80)
                   .SetWidth(200)
                   .SetLength(10)
                   .LetterMixed
                   .Moderate
                   .Build
                   .ToStream;
      LStream.SaveToFile(dlgSave1.FileName);
      if FileExists(dlgSave1.FileName) then
      begin
        Application.MessageBox('Sucess!!', 'Captcha',
          MB_OK + MB_ICONINFORMATION);
        ShellExecute(Handle, 'open',  pchar(dlgSave1.FileName), nil, nil, SW_SHOWNORMAL) ;
      end;

    finally
      LStream.Free;
    end;

  end;
end;

procedure TfrmPrin.Button1Click(Sender: TObject);
begin
  dlgFont1.Execute();
end;

procedure TfrmPrin.edtValidateExit(Sender: TObject);
begin
  if edtValidate.Text = '' then
    Exit;

  if FCaptcha.Validate(edtValidate.Text) then
  begin
    MessageDlg('Match!', mtInformation, [mbOk], 0);
    edtValidate.SetFocus;
  end
  else
  begin
    MessageDlg('Invalid!', mtError, [mbOk], 0);
    edtValidate.SetFocus;
  end;

end;

procedure TfrmPrin.FormCreate(Sender: TObject);
begin
  FCaptcha := TCaptchaUtils.New; // its an interface
end;

procedure TfrmPrin.SetCaptchaDefaults;
begin
  FCaptcha.SetHeigth(lbledtHeigth.ToInteger).SetWidth(lbledtWidth.ToInteger)
    .SetLength(lbledtLength.ToInteger).Font(dlgFont1.Font.Name,
    dlgFont1.Font.Size, dlgFont1.Font.Color).SetBackgroundColor
    (clrbx1.Selected);
end;

{ TLabeledEditorHelper }

function TLabeledEditorHelper.ToInteger: Integer;
begin

  Result := StrToIntDef(Self.Text, 0);

end;

end.
