#

# 16/12/2020 - ops_function.ps1 - Version 1.0

#

 

 

#

# Begin - get environment variables

#

 

$_msg_debug = $env:msg_debug

$_msg_info = $env:msg_info

$_msg_error = $env:msg_error

$_msg_exec = $env:msg_exec

$_msg_warning = $env:msg_warning

$_msg_success = $env:msg_success

 

#

# End - get environment variables

#

 

Function ExitScript($_ExitCode)

{

fct_trace("$_msg_info - End script with Code Status : $_ExitCode")

Exit $_ExitCode

}

 

Function fct_trace($_MessageToWrite)

{

$_Date=(get-date -format "yyyyMMdd")

$_Time=(get-date -format "HHmmss")

Write-Host $_Date $_Time (Get-Item $PSCommandPath).Name $_MessageToWrite

}

 

Function DateDiff($StartDateTime, $TimeOut)

{

$_DeltaTime = [math]::Round($TimeOut - (New-TimeSpan -Start (Get-date -Date $StartDateTime) -End (Get-Date)).TotalSeconds)

Return $_DeltaTime

}

