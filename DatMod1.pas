unit DatMod1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RxIni;

const
  PID='LAGODROM Calculator';
  VID='Version 0.01.01/a0505';
  CID='Copyright 2007-2023 LAGODROM Solutions Ltd.';
  // ---
  MainRoundCorners=17;
  LcdRoundCorners=8;
  // ---
  DefLcdClr=$00BCC2B8;
  LcdRtMargin=5;

type
  tCalcMode=(cmDec,cmHex,cmOct,cmBin);
  tCalcReg=(regY,regX,regR);

  // op codes
  tOpCode=(
    opNone,
    // ---
    opDiv,
    opMul,
    opSub,
    opAdd,
    // ---
    opNot,
    opAnd,
    opOr,
    opXor,
    // ---
    opMod,
    opRnd,      // round(X)
    opLsh,
    opRsh,
    // ---
    opSqrt,     // square root of X
    opXpow2,    // X^2
    opPerc,     // X percents from Y
    op1divX     // 1/X
  );

const
  // ini file sections & keys
  secMain='Main';
    keyLcdChrs='Lcd Chrs';
    keyLcdClr='Lcd Color';
    keyCalcMode='Calc Mode';
    keyHelpFile='Help File';

  // chars DLL (lcd.dll) resource names
  sDigits='Digits';
  sLetters='Letters';
  sDots='Dots';
  sCalcMode='CalcMode';

  // Tag property offsets
  toCalcMode=1100;
  toOpCode=1200;
  toCalcRegs=2000;

  // calc mode bases
  CalcModeBase:array[Low(tCalcMode)..High(tCalcMode)] of byte=(10,16,8,2);

type
  Tdm1 = class(TDataModule)
    procedure dm1Create(Sender: TObject);
    procedure dm1Destroy(Sender: TObject);
  private
    { Private declarations }
  public
    fIni:tRxIniFile;
  end;

function IntToOct(ii:int64):string;
{ convert II into octal string }

function OctToInt(const s:string):int64;
{ convert octal string into int64 }

function IntToBin(ii:int64):string;
{ convert II into binary string }

function BinToInt(const s:string):int64;
{ convert binary string into int64 }

function IntToStrX(ii:int64; x:byte):string;
{ convert II into string by base X }

var
  dm1: Tdm1;

// --- resource strings ---
resourcestring
  SSenderIsNil='Sender is NIL in %s';
  SUnexpectedSender='Sender is %s instead of %s in %s';
  SErrCreateRoundRect='Error in CreateRoundRectRgn(%s)';
  SErrSetWindowRgn='Error in SetWindowRgn(%s)';

implementation

{$R *.DFM}

const
  OctDigits:array[0..7] of char='01234567';

function IntToOct(ii:int64):string;
begin
  if ii =0 then
    Result:='0'
  else begin
    Result:='';

    while ii <>0 do begin
      Result:=OctDigits[ii and 7]+Result;
      ii:=ii shr 3;
    end; (*WHILE ii*)
  end;
end;

function OctToInt(const s:string):int64;
var
  i:integer;

begin
  Result:=0;

  if (s <>'') and (s <>'0') then
    for i:=1 to Length(s) do
      Result:=Result*8+(ord(s[i])-48);
end;

function IntToBin(ii:int64):string;
begin
  if ii =0 then
    Result:='0'
  else begin
    Result:='';

    while ii <>0 do begin
      Result:=OctDigits[ii and 1]+Result;
      ii:=ii shr 1;
    end; (*WHILE ii*)
  end;
end;

function BinToInt(const s:string):int64;
var
  i:integer;

begin
  Result:=0;

  if (s <>'') and (s <>'0') then
    for i:=1 to Length(s) do
      Result:=(Result shl 1)+(ord(s[i])-48);
end;

function IntToStrX(ii:int64; x:byte):string;
var
  c:integer;

begin
  if ii =0 then
    Result:='0'
  else begin
    Result:='';

    while ii >0 do begin
      c:=ii mod x;

      if c >9 then c:=c+55
      else c:=c+48;

      Result:=chr(c)+Result;

      ii:=ii div x;
    end; (*WHILE ii*)
  end;
end;

(*** Tdm1 ***)

procedure Tdm1.dm1Create(Sender: TObject);
begin
  // init access to INI config file
  fIni:=tRxIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));

  // set decimal separator to '.' (dot)
  DecimalSeparator:='.';
end;

procedure Tdm1.dm1Destroy(Sender: TObject);
begin
  if Assigned(fIni) then fIni.Free;
end;

end.
