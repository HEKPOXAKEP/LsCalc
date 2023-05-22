unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Placemnt, DatMod1, PicClip, RXCtrls, StdCtrls, Buttons,
  LsGroupBox, ActnList, Menus, RxMenus;

type
  TfmMain = class(TForm)
    panMain: TPanel;
    imgLogo: TImage;
    panLcd: TPanel;
    panLcdY: TPanel;
    pboxLcdY: TPaintBox;
    panLcdX: TPanel;
    pboxLcdX: TPaintBox;
    panLcdRes: TPanel;
    pboxLcdRes: TPaintBox;
    fsMain: TFormStorage;
    pclipDigits: TPicClip;
    pclipLetters: TPicClip;
    grpBasic: TLsGroupBox;
    sbtn0: TRxSpeedButton;
    sbtn1: TRxSpeedButton;
    sbtn4: TRxSpeedButton;
    sbtn7: TRxSpeedButton;
    sbtn8: TRxSpeedButton;
    sbtn5: TRxSpeedButton;
    sbtn2: TRxSpeedButton;
    sbtn3: TRxSpeedButton;
    sbtn6: TRxSpeedButton;
    sbtn9: TRxSpeedButton;
    sbtnSign: TRxSpeedButton;
    sbtnDot: TRxSpeedButton;
    sbtnDiv: TRxSpeedButton;
    sbtnMul: TRxSpeedButton;
    sbtnSub: TRxSpeedButton;
    sbtnAdd: TRxSpeedButton;
    sbtnMod: TRxSpeedButton;
    sbtnAnd: TRxSpeedButton;
    sbtnOr: TRxSpeedButton;
    sbtnXor: TRxSpeedButton;
    sbtnNot: TRxSpeedButton;
    sbtnLsh: TRxSpeedButton;
    sbtnRnd: TRxSpeedButton;
    sbtnRsh: TRxSpeedButton;
    sbtnEval: TRxSpeedButton;
    actsMain: TActionList;
    actCut: TAction;
    pclipDots: TPicClip;
    sbtnA: TRxSpeedButton;
    sbtnB: TRxSpeedButton;
    sbtnC: TRxSpeedButton;
    sbtnD: TRxSpeedButton;
    sbtnE: TRxSpeedButton;
    sbtnF: TRxSpeedButton;
    pclipCalcMode: TPicClip;
    panHDigits: TPanel;
    sbtnBS: TRxSpeedButton;
    panCalcMode: TPanel;
    sbtnCmDec: TRxSpeedButton;
    sbtnCmHex: TRxSpeedButton;
    sbtnCmOct: TRxSpeedButton;
    sbtnCmBin: TRxSpeedButton;
    sbtnSqrt: TRxSpeedButton;
    sbtnPerc: TRxSpeedButton;
    sbtn1divX: TRxSpeedButton;
    sbtnXpow2: TRxSpeedButton;
    sbtnClrX: TRxSpeedButton;
    sbtnInitEditor: TRxSpeedButton;
    sbtnYexchX: TRxSpeedButton;
    panOpCode: TPanel;
    lblY: TLabel;
    lblX: TLabel;
    lblR: TLabel;
    pumLcd: TRxPopupMenu;
    pmiCut: TMenuItem;
    pmiCopy: TMenuItem;
    pmiPaste: TMenuItem;
    actCopy: TAction;
    actPaste: TAction;
    procedure FormCreate(Sender: TObject);
    procedure panMainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure panMainMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure panMainMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pboxLcdPaint(Sender: TObject);
    procedure sbtnDigitClick(Sender: TObject);
    procedure sbtnHDigitClick(Sender: TObject);
    procedure sbtnDotClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure sbtnBSClick(Sender: TObject);
    procedure sbtnCalcModeClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure sbtnYexchXClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure sbtnClrXClick(Sender: TObject);
    procedure sbtnInitEditorClick(Sender: TObject);
    procedure sbtnEvalClick(Sender: TObject);
    procedure panLcdResize(Sender: TObject);
    procedure sbtnOpClick(Sender: TObject);
    procedure sbtnSignClick(Sender: TObject);
    procedure actCutExecute(Sender: TObject);
    procedure actCopyExecute(Sender: TObject);
    procedure actPasteExecute(Sender: TObject);
    procedure pboxLcdYMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    FMoving:boolean;
    FOldX,FOldY:integer;
    FRegs:array[Low(tCalcReg)..High(tCalcReg)] of string;
    FCalcMode:tCalcMode;   // Dec|Hex|Oct|Bin
    FFirstChr:boolean;
    FEditing:boolean;
    FHasDot:boolean;
    FOpCode:tOpCode;
    // ---
    procedure LoadChrs;
    procedure SetWndRoundRect(w:tWinControl; c:integer);
    procedure InitEditor;
    procedure ClearRegs;
    procedure EnableHDigits(b:boolean);
    procedure SetCalcMode(cm:tCalcMode);
    procedure RegsToDouble(var x,y,r:double);
    procedure DoubleToRegs(x,y,r:double; cm:tCalcMode); 
    procedure RefreshLcd;
    procedure ChkDigitButtons;
    // ---
    procedure DoDiv;
    procedure DoMul;
    procedure DoSub;
    procedure DoAdd;
    procedure DoNot;
    procedure DoAnd;
    procedure DoOr;
    procedure DoXor;
    procedure DoMod;
    procedure DoRnd;
    procedure DoShl;
    procedure DoShr;
    procedure DoSqrt;
    procedure DoXpow2;
    procedure DoPerc;
    procedure Do1divX;
  public
    procedure CreateParams(var Params:tCreateParams); override;
  end;

var
  fmMain: TfmMain;

implementation

uses
 ClipBrd;

{$R *.DFM}

procedure TfmMain.CreateParams(var Params: tCreateParams);
begin
 inherited CreateParams(Params);
 {with Params do
  Style:=Style and not WS_Caption;}
end;

procedure TfmMain.FormCreate(Sender: TObject);
var
 i:integer;

begin
 // set INI file name for Man Form Storage
 fsMain.IniFileName:=dm1.fIni.FileName;

 // load fonts for Lcds
 LoadChrs;

 // set colors for Lcd
 pboxLcdY.Color:=dm1.fIni.ReadColor(secMain,keyLcdClr,DefLcdClr);
 pboxLcdX.Color:=pboxLcdY.Color;
 pboxLcdRes.Color:=pboxLcdX.Color;

 // make round corners of some wnds
 //SetWndRoundRect(Self,LcdRoundCorners {MainRoundCorners});
 //SetWndRoundRect(panMain,LcdRoundCorners {MainRoundCorners});
 //SetWndRoundRect(panLcd,LcdRoundCorners);

 // read prev calc mode
 i:=dm1.fIni.ReadInteger(secMain,keyCalcMode,-1);
 if (i <ord(Low(tCalcMode))) or (i >ord(High(tCalcMode))) then begin
  for i:=0 to panCalcMode.ControlCount-1 do
   if tRxSpeedButton(panCalcMode.Controls[i]).Down then begin
    FCalcMode:=tCalcMode(i);
    break;
   end;
 end
 else
  FCalcMode:=tCalcMode(i);

 // check digit buttons (0..9 and a..f) to correspond current calc mode
 ChkDigitButtons;

 // clear X,Y,Res regs
 InitEditor;
end;

procedure TfmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action:=caFree;
end;

procedure TfmMain.SetWndRoundRect(w:tWinControl; c:integer);
var
 hNewRgn:hRgn;

begin
 // create new round-rect rgn
 hNewRgn:=CreateRoundRectRgn(0,0,w.Width,w.Height,c,c);
 if hNewRgn =0 then begin
  MessageDlg(Format(SErrCreateRoundRect,[w.Name]),mtWarning,[mbOk],0);
  exit;
 end;

 // set new wnd rgn
 if SetWindowRgn(w.Handle,hNewRgn,true) =0 then
  MessageDlg(Format(SErrSetWindowRgn,[w.Name]),mtWarning,[mbOk],0);
end;

procedure TfmMain.panMainMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 if (Button =mbLeft) and (Shift =[ssLeft]) then begin
  FOldX:=X; FOldY:=Y;
  FMoving:=true;
 end;
end;

procedure TfmMain.panLcdResize(Sender: TObject);
begin
 SetWndRoundRect(Sender as tWinControl,LcdRoundCorners);
end;

procedure TfmMain.panMainMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
 if FMoving then begin
  Left:=Left+X-FOldX;
  Top:=Top+Y-FOldY;
 end;
end;

procedure TfmMain.panMainMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 if (Button =mbLeft) and FMoving then
  FMoving:=false;
end;

procedure TfmMain.pboxLcdPaint(Sender: TObject);
var
 i,x,c:integer;
 r:tCalcReg;

begin
 with Sender as tPaintBox do begin
  Canvas.FillRect(Rect(0,0,Width,Height));
  x:=Width-(LcdRtMargin+pclipCalcMode.Width);
  r:=tCalcReg(Tag-toCalcRegs);
  for i:=Length(FRegs[r]) downto 1 do begin
   c:=ord(LowerCase(FRegs[r][i])[1]);

   case c of
    $2c,$2e: begin   // dot, comma
     pclipDots.Draw(Canvas,x-pclipDots.Width,1,ord(c =$2c));
     Dec(x,pclipDots.Width);
    end;

    $20: Dec(x,pclipDots.Width);   // space

    $2d: begin       // minus sign
     pclipDigits.Draw(Canvas,x-pclipDigits.Width,1,10);
     Dec(x,pclipDigits.Width);
    end;

    $30..$39: begin  // digits
     pclipDigits.Draw(Canvas,x-pclipDigits.Width,1,c-$30);
     Dec(x,pclipDigits.Width);
    end;

    $61..$7a: begin  // letters [a..z]
     pclipLetters.Draw(Canvas,x-pclipLetters.Width,1,c-$61);
     Dec(x,pclipLetters.Width);
    end;
   end; (*CASE*)
  end; (*FOR i*)

  case Tag of
   toCalcRegs: lblY.Caption:=FRegs[regY];
   toCalcRegs+1: lblX.Caption:=FRegs[regX];
   toCalcRegs+2: lblR.Caption:=FRegs[regR];
  end;

  // draw calcmode char
  if FCalcMode =cmDec then begin
   if not FHasDot then
    pclipDots.Draw(Canvas,Width-(LcdRtMargin+pclipDots.Width),1,0);
  end
  else
   pclipCalcMode.Draw(Canvas,Width-(LcdRtMargin+pclipCalcMode.Width),1,ord(FCalcMode)-1);
 end; (*WITH Sender*)
end;

procedure TfmMain.sbtnDigitClick(Sender: TObject);
var
 b:boolean;

begin
 if not Assigned(Sender) then begin
  MessageDlg(Format(SSenderIsNil,['sbtnDigitClick()']),mtWarning,[mbOk],0);
  exit;
 end;

 if not (Sender is tRxSpeedButton) then begin
  MessageDlg(Format(SUnexpectedSender,[Sender.ClassName,'tRxSpeedButton','sbtnDigitClick()']),
             mtWarning,[mbOk],0);
  exit;
 end;

 if not FEditing then InitEditor;

 b:=true;

 with Sender as tRxSpeedButton do
  if FFirstChr then begin
   // first char
   if Caption <>'0' then begin
    FRegs[regX]:=Caption;
    FFirstChr:=false;
   end
   else
    b:=false;
  end
  else
   // NOT a first char
   FRegs[regX]:=FRegs[regX]+Caption;

 // refresh X lcd
 if b then pboxLcdX.Refresh;
end;

procedure TfmMain.sbtnHDigitClick(Sender: TObject);
var
 b:boolean;

begin
 if not Assigned(Sender) then begin
  MessageDlg(Format(SSenderIsNil,['sbtnHDigitClick()']),mtWarning,[mbOk],0);
  exit;
 end;

 if not (Sender is tRxSpeedButton) then begin
  MessageDlg(Format(SUnexpectedSender,[Sender.ClassName,'tRxSpeedButton','sbtnHDigitClick']),
             mtWarning,[mbOk],0);
  exit;
 end;

 if not FEditing then InitEditor;

 b:=true;

 with Sender as tRxSpeedButton do
  if Length(FRegs[regX]) <16 then begin
   if FFirstChr then begin
    FFirstChr:=false;
    FRegs[regX]:=Caption;
   end
   else
    FRegs[regX]:=FRegs[regX]+Caption;
  end
  else
   b:=false;

 // refresh X lcd
 if b then pboxLcdX.Refresh;
end;

procedure TfmMain.sbtnSignClick(Sender: TObject);
begin
 //
end;

procedure TfmMain.sbtnDotClick(Sender: TObject);
begin
 if (FCalcMode <>cmDec) or FHasDot then exit;

 FRegs[regX]:=FRegs[regX]+'.';
 FHasDot:=true;

 // refresh LCDs
 RefreshLcd;
end;

procedure TfmMain.sbtnBSClick(Sender: TObject);
begin
 if Length(FRegs[regX]) =1 then begin
  // only one char in X
  FRegs[regX]:='0';
  FFirstChr:=true;
 end
 else begin
  // more than one char in X
  if FRegs[regX][Length(FRegs[regX])] ='.' then FHasDot:=false;
  Delete(FRegs[regX],Length(FRegs[regX]),1);
  FFirstChr:=FRegs[regX] ='0';
 end;

 // refresh LCDs
 RefreshLcd;
end;

procedure TfmMain.InitEditor;
begin
 ClearRegs;

 FHasDot:=false;
 FFirstChr:=true;
 FEditing:=true;
 FOpCode:=opNone;

 RefreshLcd;
end;

procedure TfmMain.ClearRegs;
begin
 FRegs[regY]:='0'; FRegs[regX]:='0'; Fregs[regR]:='0';
end;

procedure TfmMain.LoadChrs;
var
 h:tHandle;
 fn:string;

begin
 fn:=dm1.fIni.ReadString(secMain,keyLcdChrs,'lcd.dll');
 h:=LoadLibrary(pChar(fn));
 if h =0 then begin
  MessageDlg(Format(SysErrorMessage(GetLastError)+#13' (%s)',[fn]),mtError,[mbOk],0);
  PostMessage(Handle,WM_Close,0,0);
  exit;
 end;

 try
  pclipDigits.LoadBitmapRes(h,sDigits);
  pclipLetters.LoadBitmapRes(h,sLetters);
  pclipDots.LoadBitmapRes(h,sDots);
  pclipCalcMode.LoadBitmapRes(h,sCalcMode);
 finally
  FreeLibrary(h);
 end; (*TRY*)
end;

procedure TfmMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
 case Key of
  #8: sbtnBSClick(Sender);  // Backspace

  #13,'=': sbtnEvalClick(Sender);  // Enter

  #27: sbtnInitEditorClick(Sender);  // Esc

  '.': if FCalcMode =cmDec then sbtnDotClick(Sender);

  '0'..'9': sbtnDigitClick(FindComponent(Format('sbtn%s',[Key])));

  'A'..'F','a'..'f': if FCalcMode =cmHex then
   sbtnHDigitClick(FindComponent(Format('sbtn%s',[Key])));

  'X','x': sbtnYexchXClick(Sender);

  // --- operations

 else
  messagedlg(IntToHex(ord(key),4),mtinformation,[mbok],0);
 end; (*CASE Key*)

 Key:=#0;
end;

procedure TfmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 case Key of
  //VK_Back: sbtnBSClick(Self);

  VK_Delete: sbtnClrXClick(Self);
 end; (*CASE Key*)
end;

procedure TfmMain.sbtnCalcModeClick(Sender: TObject);
begin
 // sub 1100 because Tag contains a HelpContext
 SetCalcMode(tCalcMode(tRxSpeedButton(Sender).Tag-toCalcMode));
end;

procedure TfmMain.SetCalcMode(cm:tCalcMode);
var
 x,y,r:double;

begin
 if cm =FCalcMode then exit;

 // convert from old Calc Mode into double
 RegsToDouble(x,y,r);

 // convert from double into new Calc Mode
 DoubleToRegs(x,y,r,cm);

 // set new calc mode
 FCalcMode:=cm;
 // store current calc mode in INI config file
 dm1.fIni.WriteInteger(secMain,keyCalcMode,ord(cm));
 // refresh lcd
 RefreshLcd;
 // check digit buttons (0..9 and a..f) to correspond current calc mode
 ChkDigitButtons;
end;

procedure TfmMain.RegsToDouble(var x,y,r:double);
begin
 case FCalcMode of
  cmDec: begin
   y:=StrToFloat(FRegs[regY]);
   x:=StrToFloat(FRegs[regX]);
   r:=StrToFloat(FRegs[regR]);
  end;

  cmHex: begin
   y:=StrToInt64('$'+FRegs[regY]);
   x:=StrToInt64('$'+FRegs[regX]);
   r:=StrToInt64('$'+FRegs[regR]);
  end;

  cmOct: begin
   y:=OctToInt(FRegs[regY]);
   x:=OctToInt(FRegs[regX]);
   r:=OctToInt(FRegs[regR]);
  end;

  cmBin: begin
   y:=BinToInt(FRegs[regY]);
   x:=BinToInt(FRegs[regX]);
   r:=BinToInt(FRegs[regR]);
  end;
 end; (*CASE FcalcMode*)
end;

procedure TfmMain.DoubleToRegs(x,y,r:double; cm:tCalcMode);
begin
 case cm of
  cmDec: begin
   FRegs[regY]:=Format('%g',[y]);  //IntToStr(y);
   FRegs[regX]:=Format('%g',[x]);  //IntToStr(x);
   FRegs[regR]:=Format('%g',[r]);  //IntToStr(r);
  end;

  cmHex: begin
   FRegs[regY]:=Format('%x',[trunc(y)]);
   FRegs[regX]:=Format('%x',[trunc(x)]);
   FRegs[regR]:=Format('%x',[trunc(r)]);
  end;

  cmOct: begin
   FRegs[regY]:=IntToOct(trunc(y));
   FRegs[regX]:=IntToOct(trunc(x));
   FRegs[regR]:=IntToOct(trunc(r));
  end;

  cmBin: begin
   FRegs[regY]:=IntToBin(trunc(y));
   FRegs[regX]:=IntToBin(trunc(x));
   FRegs[regR]:=IntToBin(trunc(r));
  end;
 end; (*CASE cm*)

 FHasDot:=(cm in [cmHex..cmBin]) or (Pos('.',FRegs[regX]) <>0);
end;

procedure TfmMain.RefreshLcd;
begin
 if Visible then begin
  pboxLcdY.Refresh;
  pboxLcdX.Refresh;
  pboxLcdRes.Refresh;
 end;
end;

procedure TfmMain.ChkDigitButtons;
begin
 sbtn2.Enabled:=FCalcMode <>cmBin;
 sbtn3.Enabled:=FCalcMode <>cmBin;
 sbtn4.Enabled:=FCalcMode <>cmBin;
 sbtn5.Enabled:=FCalcMode <>cmBin;
 sbtn6.Enabled:=FCalcMode <>cmBin;
 sbtn7.Enabled:=FCalcMode <>cmBin;
 sbtn8.Enabled:=FCalcMode <cmOct;
 sbtn9.Enabled:=FCalcMode <cmOct;
 sbtnDot.Enabled:=FCalcMode =cmDec;
 // ---
 EnableHDigits(FCalcMode =cmHex);
end;

procedure TfmMain.EnableHDigits(b: boolean);
var
 i:integer;

begin
 for i:=0 to panHDigits.ControlCount-1 do
  with panHDigits.Controls[i] as tRxSpeedButton do
   Enabled:=b;
end;

procedure TfmMain.sbtnYexchXClick(Sender: TObject);
{ exchange X <-> Y }
var
 s:string;

begin
 s:=FRegs[regY];
 FRegs[regY]:=FRegs[regX];
 FRegs[regX]:=s;

 RefreshLcd;
end;

procedure TfmMain.sbtnClrXClick(Sender: TObject);
{ clear reg X }
begin
 FRegs[regX]:='0';

 FHasDot:=false;
 FFirstChr:=true;
 FEditing:=true;

 RefreshLcd;
end;

procedure TfmMain.sbtnInitEditorClick(Sender: TObject);
begin
 InitEditor;
end;

procedure TfmMain.pboxLcdYMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 if (Button =mbRight) and (Shift =[]) then begin
  actsMain.Tag:=tPaintBox(Sender).Tag;
  pumLcd.Popup(X,Y);
 end;
end;

procedure TfmMain.actCutExecute(Sender: TObject);
begin
 actCopyExecute(Sender);

 FRegs[tCalcReg(actsMain.Tag-toCalcRegs)]:='0';

 FHasDot:=false;
 FFirstChr:=true;
 FEditing:=true;
end;

procedure TfmMain.actCopyExecute(Sender: TObject);
begin
 Clipboard.AsText:=FRegs[tCalcReg(actsMain.Tag-toCalcRegs)];
end;

procedure TfmMain.actPasteExecute(Sender: TObject);
begin
 //
end;

procedure TfmMain.sbtnOpClick(Sender: TObject);
begin
 FOpCode:=tOpCode(tRxSpeedButton(Sender).Tag-toOpCode);
end;

procedure TfmMain.sbtnEvalClick(Sender: TObject);
begin
 if FOpCode =opNone then exit;

 case FOpCode of
  opDiv: DoDiv;
  opMul: DoMul;
  opSub: DoSub;
  opAdd: DoAdd;
  opNot: DoNot;
  opAnd: DoAnd;
  opOr: DoOr;
  opXor: DoXor;
  opMod: DoMod;
  opRnd: DoRnd;
  opLsh: DoShl;
  opRsh: DoShr;
  opSqrt: DoSqrt;
  opXpow2: DoXpow2;
  opPerc: DoPerc;
  op1divX: Do1divX;
 end; (*CASE OpCode*)
end;

procedure TfmMain.Do1divX;
begin

end;

procedure TfmMain.DoAdd;
begin

end;

procedure TfmMain.DoAnd;
begin

end;

procedure TfmMain.DoDiv;
begin

end;

procedure TfmMain.DoRnd;
begin

end;

procedure TfmMain.DoMod;
begin

end;

procedure TfmMain.DoMul;
begin

end;

procedure TfmMain.DoNot;
begin

end;

procedure TfmMain.DoOr;
begin

end;

procedure TfmMain.DoPerc;
begin

end;

procedure TfmMain.DoShl;
begin

end;

procedure TfmMain.DoShr;
begin

end;

procedure TfmMain.DoSqrt;
begin

end;

procedure TfmMain.DoSub;
begin

end;

procedure TfmMain.DoXor;
begin

end;

procedure TfmMain.DoXpow2;
begin

end;

end.

