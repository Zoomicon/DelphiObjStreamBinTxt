//Title: DelphiObjStreamBinTxt
//Description: Toggle Delphi Object Stream file between Binary and Text formats
//Usage: DelphiObjStreamBinTxt inputfile outputfile
//Author: George Birbilis / Zoomicon.com

program DelphiObjStreamBinTxt;

{$APPTYPE CONSOLE}

uses
  System.Classes,
  System.SysUtils;

const
  ERR_USAGE = 1;
  ERR_FILE_NOT_FOUND = 2;
  ERR_UNKNOWN_FORMAT = 3;

function IsBinaryFormat(Input: TStream): Boolean;
var
  Signature: Word;
begin
  Result := False;
  if Input.Size >= 2 then
  begin
    Input.Position := 0;
    Input.Read(Signature, SizeOf(Signature));
    Result := Signature = $FFFE;
    Input.Position := 0;
  end;
end;

function IsTextFormat(Input: TStream): Boolean;
var
  Buffer: TBytes;
begin
  Result := False;
  SetLength(Buffer, 6); // 'object' = 6 characters
  if Input.Size >= Length(Buffer) then
  begin
    Input.Position := 0;
    Input.Read(Buffer, Length(Buffer));
    Result := SameText(TEncoding.Default.GetString(Buffer), 'object');
    Input.Position := 0;
  end;
end;

procedure ShowUsage;
begin
  Writeln('Usage: DelphiObjStreamBinTxt inputfile outputfile');
  Writeln('Toggle Delphi Object Stream file between Binary and Text formats');
end;

var
  InputFile, OutputFile: string;
  InputStream, OutputStream: TFileStream;

begin
  if ParamCount <> 2 then
  begin
    ShowUsage;
    ExitCode := ERR_USAGE;
    Exit;
  end;

  InputFile := ParamStr(1);
  OutputFile := ParamStr(2);

  if not FileExists(InputFile) then
  begin
    Writeln('Error: Input file not found');
    ExitCode := ERR_FILE_NOT_FOUND;
    Exit;
  end;

  InputStream := TFileStream.Create(InputFile, fmOpenRead or fmShareDenyWrite);
  OutputStream := TFileStream.Create(OutputFile, fmCreate);
  try
    if IsBinaryFormat(InputStream) then
      ObjectBinaryToText(InputStream, OutputStream)
    else if IsTextFormat(InputStream) then
      ObjectTextToBinary(InputStream, OutputStream)
    else
    begin
      Writeln('Error: Unknown format — expected Delphi binary or text object stream');
      ExitCode := ERR_UNKNOWN_FORMAT;
    end;
  finally
    InputStream.Free;
    OutputStream.Free;
  end;
end.

