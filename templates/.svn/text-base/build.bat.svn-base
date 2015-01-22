@echo off
setlocal
set _I=%0
set _R=ret1
set _D=\
goto getpath
:ret1
set CFGFILE=%1
IF NOT "%CFGFILE%"=="-d" GOTO T1
set CFGFILE=package.cfg
set DEBUG=-d
GOTO doit
:T1
IF "%CFGFILE%"=="" GOTO T2
set DEBUG=%2
GOTO doit
:T2
set CFGFILE=package.cfg
goto doit

rem      :getpath -- figure out directory from a file with path
:getpath
set _I=%_I:"=%
:getpath_l
set _T=%_I:~-1,1%
if %_T%X==%_D%X goto getpath_d
if X%_I%==X goto getpath_d
set _I=%_I:~0,-1%
goto getpath_l
:getpath_d
goto %_R%


:doit
perl %DEBUG% %_I%autosub -c %CFGFILE% -c %_I%system.cfg -d . -x ~ %_I%templates

