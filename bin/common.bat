@echo off
call %*
goto :eof

:commonConf
if "x%COMMON_CONF%" == "x" (
   set "COMMON_CONF=%DIRNAME%common.conf.bat"
) else (
   if not exist "%COMMON_CONF%" (
       echo Config file not found "%COMMON_CONF%"
   )
)
if exist "%COMMON_CONF%" (
   call "%COMMON_CONF%" %*
)
goto :eof

:setModularJdk
    "%JAVA%" --add-modules=java.se -version >nul 2>&1 && (set MODULAR_JDK=true) || (set MODULAR_JDK=false)
goto :eof

:setDefaultModularJvmOptions
  call :setModularJdk
  if "!MODULAR_JDK!" == "true" (
    echo "%~1" | findstr /I "\-\-add\-modules" > nul
    if errorlevel == 1 (
      rem Set default modular jdk options
      set "DEFAULT_MODULAR_JVM_OPTIONS=!DEFAULT_MODULAR_JVM_OPTIONS! --add-exports=java.base/sun.nio.ch=ALL-UNNAMED"
      set "DEFAULT_MODULAR_JVM_OPTIONS=!DEFAULT_MODULAR_JVM_OPTIONS! --add-exports=jdk.unsupported/sun.misc=ALL-UNNAMED"
      set "DEFAULT_MODULAR_JVM_OPTIONS=!DEFAULT_MODULAR_JVM_OPTIONS! --add-exports=jdk.unsupported/sun.reflect=ALL-UNNAMED"
    ) else (
      set "DEFAULT_MODULAR_JVM_OPTIONS="
    )
  )
goto:eof
