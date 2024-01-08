unit Captcha.Contract;

interface

uses
  Vcl.Graphics, System.Classes, Vcl.imaging.jpeg;

type

  ICaptcha = interface
    ['{252431A4-5A4A-4954-880E-622D83F7D3B3}']
    /// <summary>
    /// Generates a captcha with letters and numbers: aB34c3
    /// </summary>
    function Alphanumeric: ICaptcha;
    /// <summary>
    ///  Generates the captcha and stores it within a TMemoryStream in the standard TBitmap format of the image
    /// </summary>
    function Build: ICaptcha;
    /// <summary>
    ///  Generates an easily understandable image.
    /// </summary>
    function Easy: ICaptcha;
    /// <summary>
    /// Changes the default font settings of the captcha upon generation.
    /// </summary>
    function Font(const AName: String; Const ASize: integer; const AColor: TColor): ICaptcha;
    /// <summary>
    ///   Returns the text generated in the captcha.
    /// </summary>
    function GetTextCaptcha: string;
    /// <summary>
    ///  "Generates a more challenging-to-understand image."
    /// </summary>
    function Hard: ICaptcha;
    function LetterLowerCase: ICaptcha;
    function LetterMixed: ICaptcha;
    /// <summary>
    ///   Specifies that a captcha will be generated using only letters
    /// </summary>
    function Letters: ICaptcha;
    function LetterUpperCase: ICaptcha;
    function Moderate: ICaptcha;
    /// <summary>
    ///   Specifies that a captcha will be generated using only numbers
    /// </summary>
    function Numbers: ICaptcha;
    /// <summary>
    /// Sets the background color of the captcha image. PLEASE pay attention to the color of the letters.
    /// </summary>
    function SetBackgroundColor(const Value: TColor):ICaptcha;
    /// <summary>
    /// Sets the height of the captcha image.
    /// </summary>
    function SetHeigth(const Value: integer): ICaptcha;
    /// <summary>
    /// Sets the length of the captcha image.
    /// </summary>
    function SetLength(const Value: integer): ICaptcha;
    /// <summary>
    /// Sets the width of the captcha image.
    /// </summary>
    function SetWidth(const Value: integer): ICaptcha;
    /// <summary>
    /// Returns the generated image in bitmap format converted to base 64
    /// </summary>
    function ToBase64: String;
    /// <summary>
    ///   Returns an object of the generated captcha to bitmap format;
    /// </summary>
    function ToBitmap: Vcl.Graphics.TBitmap;
    /// <summary>
    ///   Returns an object of the generated captcha to JPEG format;
    /// </summary>
    function ToJPEG: TJPEGimage;
    /// <summary>
    ///   Returns an object of the generated captcha to MemoryStream format;
    /// </summary>
    function ToStream: TMemoryStream;
    function Validate(const AText: string): boolean;
  end;

implementation

end.
