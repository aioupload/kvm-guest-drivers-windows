@echo off

set SYS_FILE_NAME=vioscsi

for %%A in (Win8 Win7 Wlh Wnet) do for %%B in (32 64) do call :%%A_%%B
goto :eof 

:buildsys
call buildOne.bat %1 %2
goto :eof

:packsys
call packOne.bat %1 %2 %SYS_FILE_NAME%
goto :eof

:buildpack
call :buildsys %1 %2
call :packsys %1 %2
set BUILD_OS=
set BUILD_ARC=
goto :eof

:create2012H
echo #define _NT_TARGET_MAJ %_NT_TARGET_MAJ%
echo #define _NT_TARGET_MIN %_NT_TARGET_MIN%
echo #define _MAJORVERSION_ %_MAJORVERSION_%
echo #define _MINORVERSION_ %_MINORVERSION_%
goto :eof


:BuildUsing2012
if "%_NT_TARGET_VERSION%"=="" set _NT_TARGET_VERSION=0x602
if "%_BUILD_MAJOR_VERSION_%"=="" set _BUILD_MAJOR_VERSION_=101
if "%_BUILD_MINOR_VERSION_%"=="" set _BUILD_MINOR_VERSION_=58000
if "%_RHEL_RELEASE_VERSION_%"=="" set _RHEL_RELEASE_VERSION_=61
set STAMPINF_VERSION=%_NT_TARGET_MAJ%.%_RHEL_RELEASE_VERSION_%.%_BUILD_MAJOR_VERSION_%.%_BUILD_MINOR_VERSION_% 

set _MAJORVERSION_=%_BUILD_MAJOR_VERSION_%
set _MINORVERSION_=%_BUILD_MINOR_VERSION_%
set /a _NT_TARGET_MAJ="(%_NT_TARGET_VERSION% >> 8) * 10 + (%_NT_TARGET_VERSION% & 255)"
set _NT_TARGET_MIN=%_RHEL_RELEASE_VERSION_%

call :create2012H  > vioscsi-2012.h
call ..\tools\callVisualStudio.bat 11 vioscsi.vcxproj /Rebuild "%~1" /Out %2
del vioscsi-2012.h
goto :eof

:WIN8_32
setlocal
set BUILD_OS=Win8
set BUILD_ARC=x86
set INF2CAT_PATH=

if "%_BUILD_MAJOR_VERSION_%"=="" set _BUILD_MAJOR_VERSION_=101
if "%_BUILD_MINOR_VERSION_%"=="" set _BUILD_MINOR_VERSION_=58000
if "%_RHEL_RELEASE_VERSION_%"=="" set _RHEL_RELEASE_VERSION_=61
set /a _NT_TARGET_MAJ="(%_NT_TARGET_VERSION% >> 8) * 10 + (%_NT_TARGET_VERSION% & 255)"
set STAMPINF_VERSION=%_NT_TARGET_MAJ%.%_RHEL_RELEASE_VERSION_%.%_BUILD_MAJOR_VERSION_%.%_BUILD_MINOR_VERSION_% 

if exist Install\win8\x86 rmdir Install\win8\x86 /s /q
call :BuildUsing2012 "Win8 Release|Win32" buildfre_win8_x86.log
call packOne.bat %BUILD_OS% %BUILD_ARC% %SYS_FILE_NAME%
endlocal
goto :eof

:WIN8_64
setlocal
set BUILD_OS=Win8
set BUILD_ARC=x64
set INF2CAT_PATH=

if exist Install\win8\amd64 rmdir Install\win8\amd64 /s /q
call :BuildUsing2012 "Win8 Release|x64" buildfre_win8_amd64.log
call packOne.bat %BUILD_OS% %BUILD_ARC% %SYS_FILE_NAME%
endlocal
goto :eof

:WIN7_32
set BUILD_OS=Win7
set BUILD_ARC=x86
call :buildpack %BUILD_OS% %BUILD_ARC%
goto :eof

:WIN7_64
set BUILD_OS=Win7
set BUILD_ARC=x64
call :buildpack %BUILD_OS% %BUILD_ARC%
goto :eof

:WLH_32
set BUILD_OS=Wlh
set BUILD_ARC=x86
call :buildpack %BUILD_OS% %BUILD_ARC%
goto :eof

:WLH_64
set BUILD_OS=Wlh
set BUILD_ARC=x64
call :buildpack %BUILD_OS% %BUILD_ARC%
goto :eof

:WNET_64
set BUILD_OS=Wnet
set BUILD_ARC=x64
call :buildpack %BUILD_OS% %BUILD_ARC%
goto :eof


:WNET_32
set BUILD_OS=Wnet
set BUILD_ARC=x86
call :buildpack %BUILD_OS% %BUILD_ARC%
goto :eof
