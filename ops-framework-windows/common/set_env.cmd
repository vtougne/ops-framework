(

  @echo off

  set ops_exec_mode=user

) else (

  set ops_exec_mode=batch

)

 

if %ops_exec_mode% == user (

  set script_name_full_path=%~dp0%~n0%~x0

) else (

  set script_name_full_path=%*

)

 

set appli_env=%script_name_full_path:~3,4%

if /i "%appli_env%"=="devl" ( set appli_env=devl&&set appli_env_u=DEVL&&set appli_env_letter=d&&set appli_env_letter_u=D&&Goto :Main )

if /i "%appli_env%"=="intg" ( set appli_env=intg&&set appli_env_u=INTG&&set appli_env_letter=i&&set appli_env_letter_u=I&Goto :Main )

if /i "%appli_env%"=="pprd" ( set appli_env=pprd&&set appli_env_u=PPRD&&set appli_env_letter=t&&set appli_env_letter_u=T&&Goto :Main )

if /i "%appli_env%"=="prod" ( set appli_env=prod&&set appli_env_u=PROD&&set appli_env_letter=p&&set appli_env_letter_u=P&&Goto :Main )

 

echo [ERROR   ] working on an unkown path in e:\devl, e:\intg, e:\pprd, E:\prod

exit /b 2

 

:Main

 

::Dynamics variables reloaded each times if set_end.cmd is called

set appli_code=%script_name_full_path:~8,4%

for /f %%a in ('powershell ^(echo %appli_code%^).ToUpper^(^)') do set appli_code_u=%%a

for /f %%a in ('powershell ^(echo %appli_code%^).ToLower^(^)') do set appli_code=%%a

REM for /f %%a in ('powershell (echo %appli_code%).ToLower) do set appli_code=%%a

 

REM set appli_code_u=%appli_code%

set appli_path=%script_name_full_path:~0,12%

set common_path=%appli_path%\common

set specific_env_file=%appli_path%\par\%appli_code%_env.cmd

 

set appli_drive_letter=%appli_path:~0,1%

 

 

set fct_set_date_time=call %common_path%\fct_set_date_time.cmd

set fct_trace=call %common_path%\fct_trace.cmd

set fct_exec=call %common_path%\fct_exec.cmd

 

 

::Default variable value that might be over loaded

if not defined msg_debug set msg_debug=[DEBUG   ]

if not defined msg_info set msg_info=[INFO    ]

if not defined msg_error set msg_error=[ERROR   ]

if not defined msg_exec set msg_exec=[EXEC    ]

if not defined msg_warning set msg_warning=[WARNING ]

if not defined msg_success set msg_success=[SUCCESS ]

if not defined zip_path set zip_path="C:\Program Files\7-Zip"

if not defined zip set zip="%zip_path:"=%\7z.exe"

if not defined ops_bin_path set ops_bin_path=e:\ops_bin

if not defined archive_path set archive_path=!appli_path!\data\archive

 

chcp 1252>nul

 

if %appli_env%==prod (

  set default_mail_smtp_server=vip.stmp.somewhere

) else (

  set default_mail_smtp_server=vip.stmp.somewhere_helse

)

 

 

if not defined mail_smtp_server set mail_smtp_server=%default_mail_smtp_server%

 

 

 

set shadow_file=%appli_drive_letter%:\%appli_env%\.%appli_env_letter%_%appli_code%_shadow.txt

if not exist %shadow_file% Goto :bypass_shadow

 

for /f "tokens=*" %%a in ('type %shadow_file%') do (

  set %%a

)

 

 

:bypass_shadow

%fct_set_date_time%

 

 

if /i exist %specific_env_file% call %specific_env_file%

 

set caller=%~n1

 

 

if %ops_exec_mode% == user (

echo the variables below are set for you

echo.

set | findstr /r "^appli_ ^mail_ ^msg_ ^shadow_file ^fct_"

 

