@echo off
setlocal enabledelayedexpansion
set input="%~1"

@echo "demuxing sfd"
%cd%\bin\mpegdemux\mpegdemux.exe -d -b audio_##.aix -s 0xc0-0xcf %input%
%cd%\bin\mpegdemux\mpegdemux.exe -d -s 0xe0 %input% %~n1.m1v

@echo "converting audio"
for %%f in (*.aix) do (
    if "%%~xf"==".aix" %cd%\bin\vgmstream\vgmstream-cli.exe %%f
)

set file1=
set file2=
set count=0

for %%f in (*.wav) do (
    set /a count+=1
    if !count! == 1 set file1=%%f
    if !count! == 2 set file2=%%f
)

 
%cd%\bin\ffmpeg\bin\ffmpeg.exe -i %input% -i !file1! -i !file2! -i %~n1.m1v -map_metadata 0 -map 1:a -map 2:a -map 3:v -c copy %~n1.avi

@echo cleanup
for %%f in (*.wav) do (
    del %%f
)
for %%f in (*.aix) do (
    del %%f
)
del %~n1.m1v

@pause