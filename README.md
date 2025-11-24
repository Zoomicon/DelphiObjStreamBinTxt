# DelphiObjStreamBinTxt

Toggle Delphi Object Stream file between Binary and Text formats

## Usage

`DelphiObjStreamBinTxt.exe inputfile [outputfile]`

## Function

Detects whether inputfile is in Binary or Text form of Delphi Object Stream format
and outputs the alternative form.

Can convert both .dfm (VCL) and .fmx (FireMonkey) stored forms/frames but also any similarly persisted Delphi VCL or FMX component.

This also includes FMX styles (.style files), but not VCL styles (.vcf) which seem to use some custom format instead.

## Alternatives

Delphi intallation includes a CONVERT.EXE utility where you specify the format to convert to (not toggle it like this utility does).

That utility can also recurse subdirectories. With this utility you'd need to use a FOR loop from the command-line or from batch file.

For reference, Delphi's CONVERT utility usage is:

```
convert.exe [-i] [-s] [-t | -b] [-e[file ext]] <filespec(s) | @filelist>
  -i  Convert files in-place (output overwrites input)
  -s  Recurse subdirectories
  -t  Convert to text
  -b  Convert to binary
  -e[File Ext]
```
