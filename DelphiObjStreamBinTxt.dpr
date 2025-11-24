//Title: DelphiObjStreamBinTxt
//Description: Toggle Delphi Object Stream file between Binary and Text formats
//Usage: DelphiObjStreamBinTxt inputfile [outputfile]
//Author: George Birbilis / Zoomicon.com

program DelphiObjStreamBinTxt;

{$APPTYPE CONSOLE}

uses
  {$IF DEFINED(MSWINDOWS)}
  Winapi.Windows, //to avoid [dcc32 Hint] H2443 Inline function 'RenameFile' has not been expanded because unit 'Winapi.Windows' is not specified in USES list
  {$ENDIF}
  System.Classes,
  System.SysUtils; //for TBytes, SameText, FileExists, fmOpenRead, fmShareDenyWrite, DeleteFile, RenameFile //MUST DEFINE AFTER Winapi.Windows

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
  Writeln('Usage: DelphiObjStreamBinTxt inputfile [outputfile]');
  Writeln('Toggle Delphi Object Stream file between Binary and Text formats');
end;

var
  InputFile, OutputFile: string;
  InputStream, OutputStream: TFileStream;

begin
  if (ParamCount >= 1) then
    InputFile := ParamStr(1);

  if (ParamCount >= 2) then
    OutputFile := ParamStr(2)
  else
    OutputFile := InputFile + '.tmp';

  if ParamCount not in [1,2] then
  begin
    ShowUsage;
    ExitCode := ERR_USAGE;
    Exit;
  end;

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

    if (ParamCount = 1) then //no outputfile given, replace inputfile
    begin
      DeleteFile(InputFile);
      RenameFile(OutputFile, InputFile);
    end;
  finally
    InputStream.Free;
    OutputStream.Free;
  end;
end.

