{���������������������������������������������}
{�   ����� ��� ����� 䠩�� � �ଠ� BMP   �}
{���������������������������������������������}
{�     Copyright (C) 2003 ���ࣨ� ���殢     �}
{�         e-mail: george_grg@mail.ru        �}
{���������������������������������������������}

unit
  BMPWrite;

interface

{ ��������� 䠩�� }
type
  bmpFileHeader = record
    Typ     : Word;        { �������� }
    Size    : Longint;     { ����� 䠩�� � ����� }
    Res     : Longint;     { ��१�ࢨ஢��� }
    OffBits : Longint;     { ���饭�� ����ࠦ���� � ����� (118) }
  end;

{ ���ଠ樮��� ��������� }
type
  bmpInfoHeader = record
    Size         : Longint;     { ����� ��������� � ����� (40) }
    Width        : Longint;     { ��ਭ� ����ࠦ���� (� �窠�) }
    Height       : Longint;     { ���� ����ࠦ���� (� �窠�) }
    Planes       : Word;        { ��᫮ ���᪮�⥩ (1) }
    BitCount     : Word;        { ��㡨�� 梥� (��� �� ���) (8) }
    Compression  : Longint;     { ��� ������ᨨ (0 - ���) }
    SizeImage    : Longint;     { ������ ����ࠦ���� � ����� }
    Xppm         : Longint;     { ��ਧ��⠫쭮� ࠧ�襭��    }
                                {   (�祪 �� ���� - ���筮 0) }
    Yppm         : Longint;     { ���⨪��쭮� ࠧ�襭��      }
                                {   (�祪 �� ���� - ���筮 0) }
    ClrUsed      : Longint;     { ��᫮ 梥⮢                        }
                                {   (�᫨ ���ᨬ��쭮 �����⨬�� - 0) }
    ClrImportant : Longint;     { ��᫮ �᭮���� 梥⮢ }
  end;

{ ����� ��������� 䠩�� }
type
  bmpHdrPtr = ^bmpHeader;
  bmpHeader = record
    F: bmpFileHeader;                   { ��������� 䠩�� }
    I: bmpInfoHeader;                   { ���ଠ樮��� ��������� }
    P: array[0..15, 0..3] of Byte;      { ������ ������� }
  end;

{ ������ ��������� BMP-䠩�� }
procedure WriteBMPHeader(Header: bmpHdrPtr; FileName: String);

{ ������ 4-bit ����ࠦ���� � BMP-䠩� }
procedure WriteBMPFile(FileName: String);

implementation

uses
  Graph;

procedure Abort(Message: String);
begin
  CloseGraph;
  WriteLn(Message);
  Halt;
end;

procedure WriteBMPHeader(Header: bmpHdrPtr; FileName: String);
var
  bmpFile: File;
begin
  Assign(bmpFile, FileName);
  {$I-} ReWrite(bmpFile, 1); {$I+}
  if IOResult <> 0 then
    Abort('�訡�� �� ᮧ����� BMP-䠩��');
  BlockWrite(bmpFile, Header^, SizeOf(Header^));
  Close(bmpFile);
end;


procedure WriteBMPFile(FileName: String);
var
  F: File;
  Width, ImgBufSize, LnBufSize, segImgBuf, ofsImgBuf, segLnBuf, ofsLnBuf,
  GlobalOffset, Y, Offset, BitPos: Word;
  ImageBuf, LineBuf: Pointer;
  Pos, bSrc, bDst: Byte;
  PixNum: Word;     { ����� �窨 (�� 0 �� N-1) }
  BitNum: Byte;     { ������ ��� � 梥� (�� 0 �� 3) }

procedure UpdateHeader;

{ ������ }
const
  Palette: array[0..15, 0..2] of Byte = (
    { Black        �  0 � ����            } (  0,   0,   0),
    { Blue         �  1 � �����             } ( 64,  64,  64),
    { Green        �  2 � ������           } (  0,   0, 128),
    { Cyan         �  3 � ����              } ( 64,  64, 255),
    { Red          �  4 � ����           } (  0, 128,   0),
    { Magenta      �  5 � �����⮢�        } ( 64, 255,  64),
    { Brown        �  6 � ���筥��        } (  0,  64, 128),
    { LightGray    �  7 � ���⫮-���      } ( 64, 255, 255),
    { DarkGray     �  8 � �����-���       } (128,   0,   0),
    { LightBlue    �  9 � ���⫮-ᨭ��      } (255,  64,  64),
    { LightGreen   � 10 � ���⫮-������    } (128,   0, 128),
    { LightCyan    � 11 � ���⫮-樠�       } (255,  64, 255),
    { LightRed     � 12 � ���⫮-����    } (128, 128,   0),
    { LightMagenta � 13 � ���⫮-䨮��⮢� } (255, 255,  64),
    { Yellow       � 14 � �����            } (128, 128, 128),
    { White        � 15 � ����             } (255, 255, 255)
  );

var
  Header: bmpHdrPtr;
  Color: Byte;

begin
  GetMem(Header, SizeOf(bmpHeader));

  with Header^.F do
  begin
    Typ     := $4D42;
    Size    := $FFFF;
    OffBits := 118;
  end;

  with Header^.I do
  begin
    Size         := 40;
    Width        := 640;
    Height       := 480;
    Planes       := 1;
    BitCount     := 4;
    Compression  := 0;
    SizeImage    := Size - Header^.F.OffBits;
    Xppm         := 0;
    Yppm         := 0;
    ClrUsed      := 0;
    ClrImportant := 0;
  end;

  for Color := 0 to 15 do
  begin
    Header^.P[Color, 0] := Palette[Color, 0];
    Header^.P[Color, 1] := Palette[Color, 1];
    Header^.P[Color, 2] := Palette[Color, 2];
    Header^.P[Color, 3] := 0;
  end;

  WriteBMPHeader(Header, FileName);

  FreeMem(Header, SizeOf(bmpHeader));
end;

{ �஢����, ��⠭����� �� � "1" ��� � ����樨 Pos }
function GetBit(B, Pos: Byte): Boolean;
begin
  GetBit := Odd(B shr Pos);
end;

{ ��⠭����� ��� Pos � "1" }
procedure SetBit(var B: Byte; Pos: Byte);
begin
  B := B or (1 shl Pos);
end;

{ ��⠭����� ��� Pos � "0" }
procedure ClrBit(var B: Byte; Pos: Byte);
begin
  if GetBit(B, Pos) then
    B := B xor (1 shl Pos);
end;

{ �������� ���⠬� ����訥 � ���訥 4 ��� }
function SwapBits(B: Byte): Byte;
var
  Temp, Pos: Byte;
begin
  Temp := 0;
  for Pos := 0 to 3 do
    if GetBit(B, Pos) then
      SetBit(Temp, Pos + 4);
  for Pos := 4 to 7 do
    if GetBit(B, Pos) then
      SetBit(Temp, Pos - 4);
  SwapBits := Temp;
end;

begin
  UpdateHeader;

  Assign(F, FileName);
  {$I-} Reset(F, 1); {$I+}
  if IOResult <> 0 then
    Abort('�訡�� �� ����� ����ࠦ���� � BMP-䠩�');
  Seek(F, FileSize(F));

  Width := GetMaxX;

  ImgBufSize := ImageSize(0, 0, Width, 0);
  GetMem(ImageBuf, ImgBufSize);
  if ImageBuf = nil then
    Abort('�訡�� ��।������ ����� - ImageBuf');
  segImgBuf := Seg(ImageBuf^);
  ofsImgBuf := Ofs(ImageBuf^) + 4;

  LnBufSize := Width div 2;
  if Width mod 2 <> 0 then
    Inc(LnBufSize);
  GetMem(LineBuf, LnBufSize);
  if LineBuf = nil then
    Abort('�訡�� ��।������ ����� - LineBuf');
  segLnBuf := Seg(LineBuf^);
  ofsLnBuf := Ofs(LineBuf^);

  GlobalOffset := ((Width div 8) + 1) * 8;

  for Y := GetMaxY downto 0 do
  begin
    GetImage(0, Y, Width, Y, ImageBuf^);

    Offset := 0;

    Pos := 0;
    for PixNum := 0 to Width do
    begin
      for BitNum := 0 to 3 do
      begin
        BitPos := GlobalOffset * BitNum + PixNum;
        bSrc := Mem[segImgBuf:ofsImgBuf + BitPos div 8];
        if GetBit(bSrc, 7 - BitPos mod 8) then
          SetBit(bDst, Pos)
        else
          ClrBit(bDst, Pos);
        Inc(Pos);
      end;
      if Pos > 7 then
      begin
        Mem[segLnBuf:ofsLnBuf + Offset] := SwapBits(bDst);
        Inc(Offset);
        Pos := 0;
      end;
    end;
    if Pos = 4 then
    begin
      for Pos := 4 to 7 do
        ClrBit(bDst, Pos);
      Mem[segLnBuf:ofsLnBuf + Offset] := SwapBits(bDst);
    end;

    BlockWrite(F, LineBuf^, LnBufSize);
  end;

  FreeMem(ImageBuf, ImgBufSize);
  FreeMem(LineBuf, LnBufSize);

  Close(F);
end;

end.