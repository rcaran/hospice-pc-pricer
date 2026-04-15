@ECHO OFF
rem CLS 
echo.
echo ************************************************************************
echo * Compile a GnuCOBOL .DLL program - by Arnold Trembley, 2021-06-30,    *
echo * with contributions from Simon Sobisch and Mark Manning.              *
echo * This .CMD file will install non-persistent GnuCOBOL Environment      *
echo * Variables and PATH for Windows XP and higher, then compile the       *
echo * COBOL source program passed as the initial parameter:  "gcx cobdump" *
echo * NOTE:  This .CMD file is designed to be executed in the directory    *
echo * where the GnuCOBOL compiler is installed.  On Successful completion  *
echo * .DLL and .LST files will be created for the COBOL source program.    *
echo ************************************************************************

set cur_prog=%~n1
set cur_ext=%~x1
rem
rem	What happens if no extension is given?
rem
if [%cur_ext%] == [] (
  rem echo.
  rem echo.========================================================================
  rem echo There is NO extension - Figuring it out
  if exist .\%cur_prog%.cob set cur_ext=.cob
  if exist .\%cur_prog%.cbl set cur_ext=.cbl
  rem echo.========================================================================
  rem echo.
)

rem Delete .dll and .lst temp files from any previous curprog compile 
if exist %temp%\%1.dll erase %temp%\%1.dll 
if exist %temp%\%1.lst erase %temp%\%1.lst

REM pause 
rem CALL the "set_env.cmd" script to set GnuCOBOL environment variables
echo call %~dp0\set_env.cmd
call %~dp0\set_env.cmd

if exist .\%cur_prog%%cur_ext% goto COMPILECOB 

echo.
echo COBOL source code file %cur_prog%%cur_ext%  
echo NOT FOUND in this directory.  
echo NO compilation will occur. 
exit /b 1 

rem goto ALLDONE

:COMPILECOB
echo.
echo Compile the Free-form "%1" program as executable DLL program (-m),
echo enable most warnings (-Wall), with no binary truncation (-fnotrunc) 
echo. 
echo cobc.exe -m -Wall -F -fnotrunc -Xref -T %temp%\%cur_prog%.lst -o %temp%\%cur_prog%.dll %cur_prog%%cur_ext%  
echo. 
cobc.exe -m -Wall -F -fnotrunc -Xref -T %temp%\%cur_prog%.lst -o %temp%\%cur_prog%.dll %cur_prog%%cur_ext%  
echo.
echo GnuCOBOL Compile Returncode = %errorlevel%
GOTO ALLDONE

:ALLDONE
rem copy .dll and .lst files to local folder
if exist %temp%\%cur_prog%.dll copy %temp%\%cur_prog%.dll .\
if exist %temp%\%cur_prog%.lst copy %temp%\%cur_prog%.lst .\

rem delete temporary .dll and .lst files 
if exist %temp%\%cur_prog%.dll erase %temp%\%cur_prog%.dll 
if exist %temp%\%cur_prog%.lst erase %temp%\%cur_prog%.lst

echo.
