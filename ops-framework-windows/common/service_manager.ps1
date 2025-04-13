#

# 16/12/2020 - service_manager.ps1 - Version 1.0

#

 

. $env:appli_path\common\ops_functions.ps1

 

$_ServiceToManage = ""

$_Id_ProcessService = 0

$_TimeWait = 5

$_CptLoop = 0

$_ActionToDo = ""

$_TimeOut = 30

 

$_ReturnCode_ParameterNotSpecified = 1

$_ReturnCode_ServiceToManageNotFound = 2

$_ReturnCode_ParameterValueWrong = 3

$_ReturnCode_ParameterValueNotSpecified = 4

$_ReturnCode_ParameterNumericValueExpected = 5

$_ReturnCode_ParameterUnknownParameter = 6

$_ReturnCode_Success = 0

$_ReturnCode_Failure = 999

 

#

# Begin - Functions

#

 

Function Usage

{

Write-Host "usage:"

Write-Host "$((Get-Item $PSCommandPath).Name) -ActionToDo<:| ><Start|Stop> -ServiceName<:| ><Service Name> [-Timeout<:| ><Timeout Value in seconds)] [-TimeWait<:| ><TimeWait Value in seconds>]"

Write-host ""

Write-Host "Parameters"

Write-Host "----------"

Write-Host ""

Write-Host "-ActionToDo (Mandatory) - Start|Stop : To start or stop a service"

Write-Host "-ServiceName (Mandatory) - Service Name on which to perform the action"

Write-Host ""

Write-Host "-Timeout (optional) - value for timeout in seconds if action to do not respond in a timely fashion  - Default value : 30 seconds"

Write-Host "-TimeWait (Optional) -value for time wait in seconds in loop - Default value : 30 seconds"

Write-Host ""

Write-Host "example"

Write-Host "-------"

Write-Host "$((Get-Item $PSCommandPath).Name) -ActionToDo:Start -ServiceName:ServiceName -Timeout:60 -TimeWait:10"

Write-Host ""

Write-Host ""

}

Function ServiceExist($_ServiceName)

{

If (Get-Service $_ServiceName -ErrorAction SilentlyContinue) {

  Return $True

} Else {

  Return $False

}

}

Function GetInfoService($_ServiceName)

{

$_ServiceProperties = (Get-WmiObject -Class Win32_Service -Property StartMode -Filter "Name = '$_ServiceName'")

$_ServiceName = Get-Service $_ServiceName

fct_trace("$_msg_info - Service Status : $($_ServiceName.Status)")

fct_trace("$_msg_info - Display Name : $($_ServiceName.DisplayName)")

fct_trace("$_msg_info - Startup Type : $($_ServiceProperties.StartMode)")

Return $_ServiceName

}

 

Function GetProcessIDFromService($_ServiceName)

{

$_Id_Tmp = (Get-WmiObject -Class Win32_Service -Filter "Name = '$_ServiceName'").ProcessID

Return $_Id_Tmp

}

 

Function StopService($_ServiceName)

{

$_ExitLoopStopSvc = $False

$_StartDateTimeStopService = (Get-Date)

$_Id_ProcessService = GetProcessIDFromService($_ServiceName)

fct_trace("$_msg_info - Service Process ID : $_Id_ProcessService")

Stop-Service -Name $_ServiceName -NoWait

fct_trace("$_msg_info - Stop request done")

Do

 {

  If ((Get-Process -Id $_Id_ProcessService -ErrorAction SilentlyContinue).Id) {

   $_CptLoop++

   fct_trace("$_msg_info - Service Process ID $_Id_ProcessService running")

   fct_trace("$_msg_info - Wait $_TimeWait Seconds (Pass $_CptLoop) for the process to stop.")

   Start-Sleep -Seconds $_TimeWait

   If ((DateDiff -StartDateTime $_StartDateTimeStopService  -TimeOut $_TimeOut) -le 0) {

    fct_trace("$_msg_error - Timeout ($_TimeOut) exceeded.")

    $_CodeRetourStopService = $False

                  $_ExitLoopStopSvc = $True

   }

  }

  Else {

   $_ServiceTMP = GetInfoService($_ServiceName)

   $_CodeRetourStopService = $True

   $_ExitLoopStopSvc = $True

  }

}

While (-Not $_ExitLoopStopSvc)

Return $_CodeRetourStopService

}

 

Function StartService($_ServiceName)

{

  $_ExitLoopStartSvc = $False

  $_StartDateTimeStartService = (Get-Date)

  Start-Service -Name $_ServiceName

  $_ServiceTMP = GetInfoService($_ServiceToManage)

  Do

  {

    If ($_ServiceTmp.Status -ne "Running") {

      $_CptLoop++

      fct_trace("$_msg_info - Wait $_TimeWait Seconds (Pass $_CptLoop) for the process to start.")

      Start-Sleep -Seconds $_TimeWait

      If ((DateDiff -StartDateTime $_StartDateTimeStartService  -TimeOut $_TimeOut) -le 0) {

        fct_trace("$_msg_error - Timeout ($_TimeOut) exceeded.")

        $_CodeRetourStartService = $False

        $_ExitLoopStartSvc = $True

      }

    }

    Else {

      $_Id_ProcessService = GetProcessIDFromService($_ServiceName)

      fct_trace("$_msg_info - Service Process ID : $_Id_ProcessService")

      $_CodeRetourStartService = $True

      $_ExitLoopStartSvc = $True

    }

  }

  While (-Not $_ExitLoopStartSvc)

  Return $_CodeRetourStartService

}

 

#

# End Functions

#

 

#

# Begin - Check parameters

#

 

if ($args.count -eq 0) {

  fct_trace("$_msg_error - Parameters NOT specified")

  Usage

  ExitScript($_ReturnCode_ParameterNotSpecified)

}

else {

  $_CptArg = 0

  $_ExitLoopPara = $False

  Do

  {

    $_Para_Key = ($args[$_CptArg].ToString()).ToLower()

    If ($_Para_Key.Substring(($_Para_Key.Length - 1),1) -eq ":") {$_Para_Key = $_Para_Key.Substring(0,($_Para_Key.Length - 1))}

    switch ($_Para_Key)

    {

      "-actiontodo"

      {

        $_CptArg++

        if ($_CptArg -gt $args.count) {

          fct_trace("$_msg_error - Value parameter NOT specified ")

          usage

          ExitScript($_ReturnCode_ParameterValueNotSpecified)

        }

        $_Para_Value = ($args[$_CptArg].ToString()).ToLower()

        if (($_Para_Value -ne "start") -and ($_Para_Value -ne "stop")) {

          fct_trace("$_msg_error - incorrect parameter value `"$_Para_Value`" ")

          usage

          ExitScript($_ReturnCode_ParameterValueWrong)

        }

        else {

          $_ActionToDo = $_Para_Value

        }

      }

      "-servicename"

      {

        $_CptArg++

        if ($_CptArg -gt $args.count) {

          fct_trace("$_msg_error - Value parameter NOT specified ")

          usage

          ExitScript($_ReturnCode_ParameterValueNotSpecified)

        }

        $_ServiceToManage = $args[$_CptArg].ToString()

      }

      "-timeout"

      {

        $_CptArg++

        if ($_CptArg -gt $args.count) {

          fct_trace("$_msg_error - Value parameter NOT specified ")

          usage

          ExitScript($_ReturnCode_ParameterValueNotSpecified)

        }

        $_Para_Value = $args[$_CptArg]

        if ($_Para_Value -match "^\d+$") {

          $_TimeOut = $_Para_Value

        }

        else {

          fct_trace("$_msg_error - Numeric value for Timeout expected `"$_Para_Value`"")         

          usage

          ExitScript($_ReturnCode_ParameterNumericValueExpected)

        }

      }

      "-timewait"

      {

        $_CptArg++

        if ($_CptArg -gt $args.count) {

          fct_trace("$_msg_error - Value parameter NOT specified ")

          usage

          ExitScript($_ReturnCode_ParameterValueNotSpecified)

        }

        $_Para_Value = $args[$_CptArg]

        if ($_Para_Value -match "^\d+$") {

          $_TimeWait = $_Para_Value

        }

        else {

          fct_trace("$_msg_error - Numeric value for Timeout expected `"$_Para_Value`"")         

          usage

          ExitScript($_ReturnCode_ParameterNumericValueExpected)

        }

      }

      default

      {

        fct_trace("$_msg_error - Unknown parameter `"$_Para_Key`"")

        usage

        ExitScript($_ReturnCode_ParameterUnknownParameter)

      }

    }

    $_CptArg++

    if ($_CptArg -eq $args.count) {$_ExitLoopPara = $True}

  }

  While (-Not $_ExitLoopPara)

  if ($_ActionToDo -eq "") {

    fct_trace("$_msg_error - Parameter `"-ActionToDo`" expected")         

    usage

    ExitScript($_ReturnCode_ParameterNotSpecified)   

  }

  if ($_ServiceToManage -eq "") {

    fct_trace("$_msg_error - Parameter `"-ServiceName`" expected")         

    usage

    ExitScript($_ReturnCode_ParameterNotSpecified)   

  }

}

 

#

# End - Check parameters

#

 

# Write-host "`$_ServiceToManage : $_ServiceToManage"

# Write-Host "`$_ActionToDo : $_ActionToDo"

# Write-Host "`$_TimeOut : $_TimeOut"

# Write-Host "`$_TimeWait : $_TimeWait"

 

# ExitScript(999)

 

 

 

 

If ( -Not (ServiceExist($_ServiceToManage)) ) {

fct_trace("$_msg_error - Service $_ServiceToManage not found")

ExitScript($_ReturnCode_ServiceToManageNotFound)

}

 

 

 

Switch ($_ActionToDo)

{

  "start"

  {

    $_ServiceTMP = GetInfoService($_ServiceToManage)

    If ($_ServiceTMP.Status -eq "Running") {

      fct_trace("$_msg_warning - service $_ServiceToManage already started")

      ExitScript($_ReturnCode_success)

    }

                  Else {

                    If (StartService($_ServiceToManage)) {

        fct_trace("$_msg_success - Start service $_ServiceToManage")

        ExitScript($_ReturnCode_Success)

      }

      Else {

        fct_trace("$_msg_error - Start service $_ServiceToManage failed")

        ExitScript($_ReturnCode_Failure)

      }

    }

  }

  "stop"

  {

    $_ServiceTMP = GetInfoService($_ServiceToManage)

    If (($_ServiceTMP.Status -eq "Running") -or ($_ServiceTMP.Status -eq "Paused") -or ($_ServiceTMP.Status -eq "StartPending") -or ($_ServiceTMP.Status -eq "StopPending")) {

      If (StopService($_ServiceToManage)) {

        fct_trace("$_msg_success - Stop service $_ServiceToManage")

        ExitScript($_ReturnCode_Success)

      }

      Else {

        fct_trace("$_msg_error - Stop service $_ServiceToManage failed")

        ExitScript($_ReturnCode_Failure)

      }

    }

    Else {

      If ($_ServiceTMP.Status -eq "Stopped") {

        fct_trace("$_msg_info - Service $_ServiceToManage already stopped")

                      ExitScript($_ReturnCode_Success)

                    }

                    Else {

                      fct_trace("$_msg_error - Unmanaged status")

                      ExitScript($_ReturnCode_Failure)

                    }

    }

  }

}

