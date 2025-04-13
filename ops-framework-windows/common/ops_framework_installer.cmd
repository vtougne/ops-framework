off

 

Setlocal EnableDelayedExpansion

call %~dp0\..\common\set_env.cmd %~dp0%~n0

 

!fct_set_date_time!

set backup_file_list=!appli_path!\ops\backup_file_list_!date_num!_!time_num!.txt

set backup_file_zip=!appli_path!\ops\backup_file_list_!date_num!_!time_num!.zip

 

if exist !backup_file_list! del /q !backup_file_list!

 

for /f %%a in ('dir /b !appli_path!\scripts ^| findstr /r "^^!appli_env_letter_u!....-[0-9][0-9][0-9][A-Za-z]-[0-9][0-9][0-9][A-Za-z].bat$"') do (

  set existing_wrapper_name=%%a

  findstr /c:"tws_wrapper windows v" !appli_path!\scripts\!existing_wrapper_name!>nul

  if !errorlevel! == 0 (

                fc !appli_path!\scripts\tws_wrapper.bat !appli_path!\scripts\!existing_wrapper_name!>nul

                if not !errorlevel! == 0 (

                  echo !appli_path!\scripts\!existing_wrapper_name!>>!backup_file_list!

                )

  )

)

 

if not exist !backup_file_list! !fct_trace! !msg_info! nothing to change, exiting && exit /b 0

 

echo debug zip cmd : %fct_exec% %zip% a -tzip !backup_file_zip! @!backup_file_list!

%fct_exec% %zip% a -tzip !backup_file_zip! @!backup_file_list! || exit /b 5

 

for /f %%a in ('type !backup_file_list!') do (

  set existing_wrapper_name=%%a

  !fct_exec! copy /y !appli_path!\scripts\tws_wrapper.bat !existing_wrapper_name! || exit /b 3

)

 

