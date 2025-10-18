@echo off
chcp 1252 > nul
setlocal enabledelayedexpansion

:: Verificar privilegios de administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo +================================================+
    echo ^|                      ERRO                       ^|
    echo +================================================+
    echo ^|  Este script precisa ser executado como Admin   ^|
    echo ^|  Por favor, execute como administrador         ^|
    echo +================================================+
    pause
    exit /b 1
)

:MENU

set "pos=0"
set "dir=1"
set "max=20"
set "progresso=0"
set "carregamento_completo=0"
color 02

:loop
cls
set "espaco="
for /L %%i in (1,1,%pos%) do set "espaco=!espaco! "

:: Parte superior com logo animado
echo +========================================================================================================+
echo "                                                                              
echo "!espaco!   ___    __    ____  __   __   __      ___  ___   _______  __   __   __    __  
echo "!espaco!  \   \  /  \  /   / |  | |  \ |  |    |   \/   | |   ____||  \ |  | |  |  |  | 
echo "!espaco!   \   \/    \/   /  |  | |   \|  |    |  \  /  | |  |__   |   \|  | |  |  |  | 
echo "!espaco!    \            /   |  | |  . `  |    |  |\/|  | |   __|  |  . `  | |  |  |  | 
echo "!espaco!     \    /\    /    |  | |  |\   |    |  |  |  | |  |____ |  |\   | |  `--'  | 
echo "!espaco!      \__/  \__/     |__| |__| \__|    |__|  |__| |_______||__| \__|  \______/  
echo "                                                                              
echo "   
echo +========================================================================================================+

:: Barra de progresso
if !carregamento_completo! equ 0 (
    echo "                                                                     
    echo "                                                                     
    echo "                                                                     
    echo "                                                                     
    echo "    [!barra!] !progresso!%%  										   
    
) else (
    :: Se o carregamento estiver completo, sai do loop de animação
    goto menu
)

:: Movimento horizontal
if !dir! equ 1 (
    set /a pos+=1
    if !pos! geq %max% set "dir=0"
) else (
    set /a pos-=1
    if !pos! leq 0 set "dir=1"
)

:: Atualização da barra de progresso
set /a progresso+=2
if !progresso! gtr 100 (
    set "carregamento_completo=1"
)

set "barra="
set /a "barsize=progresso/2"
for /L %%i in (1,1,!barsize!) do set "barra=!barra!="
for /L %%i in (!barsize!,1,50) do set "barra=!barra! "

ping -n 1 localhost >nul
goto loop

:menu
cls
color F0
echo +========================================================================================================+
echo "
echo "!espaco!   ___    __    ____  __   __   __      ___  ___   _______  __   __   __    __  								
echo "!espaco!  \###\  /##\  /###/ |**| |@@\ |@@|    ||||\/|||| |$$$$$$$||&&\ |&&| |##|  |##| 
echo "!espaco!   \###\/####\/###/  |**| |@@@\|@@|    |||\||/||| |$$|__   |&&&\|&&| |##|  |##| 
echo "!espaco!    \############/   |**| |@@.@@@@|    ||||\/|||| |$$$$$|  |&&.&`&&| |##|  |##|
echo "!espaco!     \####/\####/    |**| |@@|\@@@|    ||||  |||| |$$$____ |&&|\&&&| |##`--'##| 
echo "!espaco!      \__/  \__/     |**| |__| \__|    |__|  |__| |$$$$$$$||&&| \&&|  \______/  
echo "                                                                              
echo "
echo +========================================================================================================+
echo "                                                                              
echo "                1. Nova instalacao                                            
echo "                2. Implantar Imagem                                           
echo "                3. Captura de Imagem                                          
echo "                4. Fazer backup                                               
echo "                5. Extrair Drivers                                            
echo "                6. Recuperacao                                                
echo "                7. Limpeza                                                    
echo "                0. Sair                                                       
echo "                                                                              
echo +========================================================================================================+




set /p opcao="Digite sua opcao (1-7): "

if "%opcao%"=="1" goto :INSTALL
if "%opcao%"=="2" goto :DEPLOY
if "%opcao%"=="3" goto :CAPTURE
if "%opcao%"=="4" goto :BACKUP
if "%opcao%"=="5" goto :DRIVERS
if "%opcao%"=="6" goto :RECOVERY
if "%opcao%"=="7" goto :CLEAR
goto :MENU

:INSTALL
call :installation_section
goto :MENU

:DEPLOY
call :deploy_image_menu
goto :MENU

:CAPTURE
call :capture_image_menu
goto :MENU

:BACKUP
call :backup_section
goto :MENU

:DRIVERS
call :drivers_section
goto :MENU

:CLEAR
call :clear_section
goto :MENU



:clear_section

@echo off
setlocal EnableDelayedExpansion
title Limpeza de Disco 
color 0A

REM Cria diretório de logs se não existir
if not exist "%~dp0logs" md "%~dp0logs"

REM Cria arquivo de log com data e hora
set LOGFILE=%~dp0logs\cleanup_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%.log
echo Iniciando limpeza em %date% %time% > %LOGFILE%


@echo off
cls
color 02
echo +==============================================================================+ 
echo "                                                                              "
echo "              ____    _         _         ____   _                        	"
echo "             |  _ \  (_)  ___  | | __    / ___| | |   ___    __ _   _ __  	"
echo "             | | | | | | / __| | |/ /   | |     | |  / _ \  / _` | | '_ \ 	"
echo "             | |_| | | | \__ \ |   <    | |___  | | |  __/ | (_| | | | | |	"
echo "             |____/  |_| |___/ |_|\_\    \____| |_|  \___|  \__,_| |_| |_|	"
echo "                                                                              "
echo +==============================================================================+ 

:: Solicitar ao usuário que escolha o disco
set /p DISCO=Digite a letra do disco que deseja limpar (ex: C): 
if not exist %DISCO%:\ (
    echo Disco invalido! >> %LOGFILE%
    echo Disco invalido! Pressione qualquer tecla para tentar novamente...
    pause > nul
    goto :clear_section
)

echo.
echo ATENCAO: Todos os arquivos temporarios do disco %DISCO%: serao removidos!
echo Deseja continuar? (S/N)
choice /c SN /n
if errorlevel 2 goto :clear_section

echo.
echo Iniciando processo de limpeza... >> %LOGFILE%
echo Iniciando processo de limpeza...
echo.

REM Limpeza da pasta de Pré-busca
echo Limpando arquivos de Pré-busca... >> %LOGFILE%
echo Limpando arquivos de Pré-busca...
takeown /A /R /D Y /F "%DISCO%:\Windows\Prefetch\*" 2>> %LOGFILE%
icacls "%DISCO%:\Windows\Prefetch\*" /grant administradores:F /T /C 2>> %LOGFILE%
del /s /q "%DISCO%:\Windows\Prefetch\*" 2>> %LOGFILE%

REM Limpeza dos Pontos de Restauração
echo Limpando pontos de restauração antigos... >> %LOGFILE%
echo Limpando pontos de restauração antigos...
vssadmin delete shadows /for=%DISCO%: /oldest /quiet 2>> %LOGFILE%


:: Limpeza da Lixeira
echo Esvaziando a Lixeira... >> %LOGFILE%
echo Esvaziando a Lixeira...
rd /s /q "%DISCO%:\$Recycle.Bin" 2>> %LOGFILE%


REM ******************** WINDOWS ********************
echo Limpando arquivos temporarios do Windows... >> %LOGFILE%
echo Limpando arquivos temporarios do Windows...

REM Procura e limpa os arquivos temporários de todos os usuários
for /d %%x in ("%DISCO%:\*") do (
    if exist "%%x\AppData\Local\Temp" (
        echo Processando perfil: %%~nx >> %LOGFILE%
        echo Limpando temporarios do perfil: %%~nx
        
        takeown /A /R /D Y /F "%%x\AppData\Local\Temp\" 2>> %LOGFILE%
        icacls "%%x\AppData\Local\Temp\" /grant administradores:F /T /C 2>> %LOGFILE%
        rmdir /s /q "%%x\AppData\Local\Temp\" 2>> %LOGFILE%
        md "%%x\AppData\Local\Temp\" 2>> %LOGFILE%
        
        REM Cache do Windows
        takeown /A /R /D Y /F "%%x\AppData\Local\Microsoft\Windows\*" 2>> %LOGFILE%
        icacls "%%x\AppData\Local\Microsoft\Windows\*" /grant administradores:F /T /C 2>> %LOGFILE%
        del "%%x\AppData\Local\Microsoft\Windows\WebCache\*.log" /s /q 2>> %LOGFILE%
        del "%%x\AppData\Local\Microsoft\Windows\SettingSync\*.log" /s /q 2>> %LOGFILE%
        del "%%x\AppData\Local\Microsoft\Windows\Explorer\ThumbCacheToDelete\*.tmp" /s /q 2>> %LOGFILE%
        rmdir /s /q "%%x\AppData\Local\Microsoft\Windows\INetCache" 2>> %LOGFILE%
        
        REM Navegadores
        REM Edge
        takeown /A /R /D Y /F "%%x\AppData\Local\Microsoft\Edge\*" 2>> %LOGFILE%
        icacls "%%x\AppData\Local\Microsoft\Edge\*" /grant administradores:F /T /C 2>> %LOGFILE%
        rmdir /q /s "%%x\AppData\Local\Microsoft\Edge\User Data\Default\Cache" 2>> %LOGFILE%
		rmdir /q /s "%%x\AppData\Local\Microsoft\Edge\User Data\Default\Service Worker\Database" 2>> %LOGFILE%
		rmdir /q /s "%%x\AppData\Local\Microsoft\Edge\User Data\Default\Service Worker\CacheStorage" 2>> %LOGFILE%
		rmdir /q /s "%%x\AppData\Local\Microsoft\Edge\User Data\Default\Service Worker\ScriptCache" 2>> %LOGFILE%
		rmdir /q /s "%%x\AppData\Local\Microsoft\Edge\User Data\Default\GPUCache" 2>> %LOGFILE%
		rmdir /q /s "%%x\AppData\Local\Microsoft\Edge\User Data\GrShaderCache\GPUCache" 2>> %LOGFILE%
		rmdir /q /s "%%x\AppData\Local\Microsoft\Edge\User Data\ShaderCache\GPUCache" 2>> %LOGFILE%
		rmdir /s /q "%%x\AppData\Local\Microsoft\Edge\User Data\Default\History" 2>> %LOGFILE%
		rmdir /s /q "%%x\AppData\Local\Microsoft\Edge\User Data\Default\Cookies" 2>> %LOGFILE%
        
        REM Chrome
        takeown /A /R /D Y /F "%%x\AppData\Local\Google\Chrome\*" 2>> %LOGFILE%
        icacls "%%x\AppData\Local\Google\Chrome\*" /grant administradores:F /T /C 2>> %LOGFILE%
        rmdir /q /s "%%x\AppData\Local\Google\Chrome\User Data\Default\Cache" 2>> %LOGFILE%
		rmdir /q /s "%%x\AppData\Local\Google\Chrome\User Data\Default\Service Worker\Database" 2>> %LOGFILE%
		rmdir /q /s "%%x\AppData\Local\Google\Chrome\User Data\Default\Service Worker\CacheStorage" 2>> %LOGFILE%
		rmdir /q /s "%%x\AppData\Local\Google\Chrome\User Data\Default\Service Worker\ScriptCache" 2>> %LOGFILE%
		rmdir /q /s "%%x\AppData\Local\Google\Chrome\User Data\Default\GPUCache" 2>> %LOGFILE%
		rmdir /q /s "%%x\AppData\Local\Google\Chrome\User Data\Default\Storage\ext" 2>> %LOGFILE%
		rmdir /s /q "%%x\AppData\Local\Google\Chrome\User Data\Default\History" 2>> %LOGFILE%
		rmdir /s /q "%%x\AppData\Local\Google\Chrome\User Data\Default\Cookies" 2>> %LOGFILE%
        
        REM Firefox
		set "parentfolder=%%x\AppData\Local\Mozilla\Firefox\Profiles"
        takeown /A /R /D Y /F "%%x\AppData\Local\Mozilla\Firefox\*" 2>> %LOGFILE%
        icacls "%%x\AppData\Local\Mozilla\Firefox\*" /grant administradores:F /T /C 2>> %LOGFILE%
        rmdir /s /q "%%x\AppData\Local\Mozilla\Firefox\Profiles\*.default*\cache2" 2>> %LOGFILE%
		REM Percorre todos os perfis padrão do Firefox no sistema
		for /d %%a in ("%parentfolder%\*.default-release") do (
		rmdir /q /s "%%a\cache2\entries" 2>> %LOGFILE%
		rmdir /q /s "%%a\startupCache" 2>> %LOGFILE%
		rmdir /q /s "%%a\jumpListCache" 2>> %LOGFILE%
		rmdir /q /s "%%a\offlineCache" 2>> %LOGFILE%
		rmdir /q /s "%%a\saved-telemetry-pings" 2>> %LOGFILE%
		rmdir /q /s "%%a\thumbnails" 2>> %LOGFILE%
)

		:: Firefox - Histórico e Cookies
		for /d %%a in ("%%x\AppData\Roaming\Mozilla\Firefox\Profiles\*.default-release") do (
		rmdir /s /q "%%a\cookies.sqlite" 2>> %LOGFILE%
		rmdir /s /q "%%a\places.sqlite" 2>> %LOGFILE%
)
        
        REM Brave
        takeown /A /R /D Y /F "%%x\AppData\Local\BraveSoftware\*" 2>> %LOGFILE%
        icacls "%%x\AppData\Local\BraveSoftware\*" /grant administradores:F /T /C 2>> %LOGFILE%
        rmdir /q /s "%%x\AppData\Local\BraveSoftware\Brave-Browser\User Data\Default\Cache" 2>> %LOGFILE%
		rmdir /q /s "%%x\AppData\Local\BraveSoftware\Brave-Browser\User Data\Default\Service Worker\Database" 2>> %LOGFILE%
		rmdir /q /s "%%x\AppData\Local\BraveSoftware\Brave-Browser\User Data\Default\Service Worker\CacheStorage" 2>> %LOGFILE%
		rmdir /q /s "%%x\AppData\Local\BraveSoftware\Brave-Browser\User Data\Default\Service Worker\ScriptCache" 2>> %LOGFILE%
		rmdir /q /s "%%x\AppData\Local\BraveSoftware\Brave-Browser\User Data\Default\GPUCache" 2>> %LOGFILE%
		rmdir /s /q "%%x\AppData\Local\BraveSoftware\Brave-Browser\User Data\Default\History" 2>> %LOGFILE%
        rmdir /s /q "%%x\AppData\Local\BraveSoftware\Brave-Browser\User Data\Default\Cookies" 2>> %LOGFILE%
        
        REM Vivaldi
        takeown /A /R /D Y /F "%%x\AppData\Local\Vivaldi\*" 2>> %LOGFILE%
        icacls "%%x\AppData\Local\Vivaldi\*" /grant administradores:F /T /C 2>> %LOGFILE%
		rmdir /q /s "%%x\AppData\Local\Vivaldi\User Data\Default\Cache" 2>> %LOGFILE%
		rmdir /q /s "%%x\AppData\Local\Vivaldi\User Data\Default\Service Worker\Database" 2>> %LOGFILE%
		rmdir /q /s "%%x\AppData\Local\Vivaldi\User Data\Default\Service Worker\CacheStorage" 2>> %LOGFILE%
		rmdir /q /s "%%x\AppData\Local\Vivaldi\User Data\Default\Service Worker\ScriptCache" 2>> %LOGFILE%
		rmdir /q /s "%%x\AppData\Local\Vivaldi\User Data\Default\GPUCache" 2>> %LOGFILE%
		rmdir /s /q "%%x\AppData\Local\Vivaldi\User Data\Default\History" 2>> %LOGFILE%
		rmdir /s /q "%%x\AppData\Local\Vivaldi\User Data\Default\Cookies" 2>> %LOGFILE%
    )
)

REM Limpeza do Windows\Temp
echo Limpando Windows\Temp... >> %LOGFILE%
echo Limpando Windows\Temp...
takeown /A /R /D Y /F "%DISCO%:\Windows\Temp\*" 2>> %LOGFILE%
icacls "%DISCO%:\Windows\Temp\*" /grant administradores:F /T /C 2>> %LOGFILE%
rmdir /s /q "%DISCO%:\Windows\Temp" 2>> %LOGFILE%
md "%DISCO%:\Windows\Temp" 2>> %LOGFILE%

REM Limpeza de Logs do Windows
echo Limpando logs do Windows... >> %LOGFILE%
echo Limpando logs do Windows...
takeown /A /R /D Y /F "%DISCO%:\Windows\Logs\*" 2>> %LOGFILE%
icacls "%DISCO%:\Windows\Logs\*" /grant administradores:F /T /C 2>> %LOGFILE%
del "%DISCO%:\Windows\Logs\CBS\*.log" /s /q 2>> %LOGFILE%
del "%DISCO%:\Windows\Logs\*.log" /s /q 2>> %LOGFILE%

takeown /A /R /D Y /F "%DISCO%:\Windows\inf\*.log" 2>> %LOGFILE%
icacls "%DISCO%:\Windows\inf\*.log" /grant administradores:F /T /C 2>> %LOGFILE%
del "%DISCO%:\Windows\inf\*.log" /s /q 2>> %LOGFILE%

takeown /A /R /D Y /F "%DISCO%:\Windows\Microsoft.NET\*.log" 2>> %LOGFILE%
icacls "%DISCO%:\Windows\Microsoft.NET\*.log" /grant administradores:F /T /C 2>> %LOGFILE%
del "%DISCO%:\Windows\Microsoft.NET\*.log" /s /q 2>> %LOGFILE%


echo.
echo Limpando arquivos do Windows Update e versoes anteriores... >> %LOGFILE%
echo Limpando arquivos do Windows Update e versoes anteriores...

REM Windows Update Cleanup
 
net stop wuauserv 2>> %LOGFILE%
rmdir /s /q "%DISCO%:\Windows\SoftwareDistribution\Download" 2>> %LOGFILE%
md "%DISCO%:\Windows\SoftwareDistribution\Download" 2>> %LOGFILE%
net start wuauserv 2>> %LOGFILE%

REM Limpeza de logs de atualização
takeown /A /R /D Y /F "%DISCO%:\Windows\Logs\WindowsUpdate\*" 2>> %LOGFILE%
icacls "%DISCO%:\Windows\Logs\WindowsUpdate\*" /grant administradores:F /T /C 2>> %LOGFILE%
del /f /s /q "%DISCO%:\Windows\Logs\WindowsUpdate\*" 2>> %LOGFILE%

REM Versões anteriores do Windows (pasta Windows.old)
if exist "%DISCO%:\Windows.old" (
    echo Removendo pasta Windows.old... >> %LOGFILE%
    echo Removendo pasta Windows.old...
    takeown /A /R /D Y /F "%DISCO%:\Windows.old\*" 2>> %LOGFILE%
    icacls "%DISCO%:\Windows.old\*" /grant administradores:F /T /C 2>> %LOGFILE%
    rmdir /s /q "%DISCO%:\Windows.old" 2>> %LOGFILE%
)

REM Limpeza de arquivos temporários de instalação
takeown /A /R /D Y /F "%DISCO%:\Windows\WinSxS\Backup\*" 2>> %LOGFILE%
icacls "%DISCO%:\Windows\WinSxS\Backup\*" /grant administradores:F /T /C 2>> %LOGFILE%
del /f /s /q "%DISCO%:\Windows\WinSxS\Backup\*" 2>> %LOGFILE%

REM Limpeza de arquivos de componentes do Windows
takeown /A /R /D Y /F "%DISCO%:\Windows\WinSxS\ManifestCache\*" 2>> %LOGFILE%
icacls "%DISCO%:\Windows\WinSxS\ManifestCache\*" /grant administradores:F /T /C 2>> %LOGFILE%
del /f /s /q "%DISCO%:\Windows\WinSxS\ManifestCache\*" 2>> %LOGFILE%




@echo off
cls
color 17
echo +==============================================================================+ 
echo "																				"
echo "        __   _           _         _                  _                       "
echo "	 	 / _| (_)  _ __   (_)  ___  | |__     ___    __| |						"
echo "		| |_  | | | '_ \  | | / __| | '_ \   / _ \  / _` |                      "
echo "		|  _| | | | | | | | | \__ \ | | | | |  __/ | (_| |						"
echo "		|_|   |_| |_| |_| |_| |___/ |_| |_|  \___|  \__,_|						"
echo "																				"
echo +==============================================================================+ 

echo Limpeza concluída. Verifique o arquivo de log em: %LOGFILE%
echo Limpeza concluída em %date% %time% >> %LOGFILE%
echo.
echo Deseja limpar outro disco? (S/N)
choice /c SN /n
if errorlevel 2 goto :exit_script
if errorlevel 1 goto :clear_section

:exit_script
echo Programa finalizado em %date% %time% >> %LOGFILE%
echo Programa finalizado.
pause
exit


:RECOVERY
@echo off
cls
color 20
echo +====================================================================================+ 
echo "			__      __  _            ___                                  		
echo "			\ \    / / (_)  _ _     | _ \  ___   __   ___  __ __  ___   _ _ 	
echo "			 \ \/\/ /  | | | ' \    |   / / -_) / _| / _ \ \ V / / -_) | '_| 	
echo "			  \_/\_/   |_| |_||_|   |_|_\ \___| \__| \___/  \_/  \___| |_|   	
echo "																				
echo +===================================================================================="
echo "										
echo " 1. Reparacao do Windows				
echo " 2. Reparacao de inicializacao		
echo "										
echo +=======================================+ 

choice /c 12 /n /m "Digite sua opcao (1-2): "
if errorlevel 2 goto :boot_repair
if errorlevel 1 goto :windows_repair


@echo off
setlocal enabledelayedexpansion

:windows_repair

@echo off
cls
color 20
echo +====================================================================================+ 
echo "			__      __  _            ___                                  		
echo "			\ \    / / (_)  _ _     | _ \  ___   __   ___  __ __  ___   _ _ 	
echo "			 \ \/\/ /  | | | ' \    |   / / -_) / _| / _ \ \ V / / -_) | '_| 	
echo "			  \_/\_/   |_| |_||_|   |_|_\ \___| \__| \___/  \_/  \___| |_|   	
echo "																				
echo +===================================================================================="
echo +================================================+
echo ^| Digite a letra da unidade do Windows (ex.: C): ^|
echo +================================================+

set /p "drive_letter="
if "%drive_letter%"=="" goto :windows_repair

:: Adicionar : se não existir
if not "%drive_letter:~1,1%"==":" set "drive_letter=%drive_letter%:"

:: Verificar se a unidade existe e contém Windows
if not exist "%drive_letter%\Windows\System32" (
    cls
    echo +================================================+
    echo ^|                    ERRO                         ^|
    echo +================================================+
    echo ^| Sistema Windows nao encontrado em %drive_letter% ^|
    echo +================================================+
    pause
    goto :windows_repair
)

:: Criar diretório e arquivo de log
set "logs_dir=%~dp0logs"
if not exist "!logs_dir!" mkdir "!logs_dir!"

:: Corrigir o formato da data e hora para nome do arquivo
for /f "tokens=1-4 delims=/ " %%a in ('date /t') do set datestr=%%d%%b%%a
for /f "tokens=1-2 delims=: " %%a in ('time /t') do set timestr=%%a%%b
set "repair_log=!logs_dir!\repair_!datestr!_!timestr!.txt"


@echo off
cls
color 20																			
echo +==============================================================================+
echo "  ___                                      _               
echo " | _ \  ___   __   ___  __ __  ___   _ _  (_)  _ _    __ _ 
echo " |   / / -_) / _| / _ \ \ V / / -_) | '_| | | | ' \  / _` |
echo " |_|_\ \___| \__| \___/  \_/  \___| |_|   |_| |_||_| \__, |
echo "                                                     |___/ 
echo +==============================================================================+

:: Definir página de código para UTF-8
chcp 65001 >nul


:: Verificar se é a unidade do sistema atual
if /i "%drive_letter%"=="%SystemDrive%" (
    echo Executando SFC e DISM em modo online...
    echo Iniciando SFC em modo online: %date% %time% > "!repair_log!"
    sfc /scannow >> "!repair_log!" 2>&1
    echo Iniciando DISM em modo online: %date% %time% >> "!repair_log!"
    DISM /Online /Cleanup-Image /RestoreHealth >> "!repair_log!" 2>&1
) else (
    echo Executando SFC e DISM em modo offline...
    echo Iniciando SFC em modo offline: %date% %time% > "!repair_log!"
    sfc /scannow /offbootdir="%drive_letter%" /offwindir="%drive_letter%\Windows" >> "!repair_log!" 2>&1
    echo Iniciando DISM em modo offline: %date% %time% >> "!repair_log!"
    DISM /Image:"%drive_letter%" /Cleanup-Image /RestoreHealth >> "!repair_log!" 2>&1
)

echo +================================================+
echo ^|         Reparacao Concluida                    ^|
echo ^| Log salvo em: !repair_log!                     ^|
echo +================================================+

pause
goto :MENU


:boot_repair
cls
echo +================================================+
echo ^|        Reparacao de Inicializacao               ^|
echo +================================================+
echo ^| Digite a letra da unidade do Windows (ex.: C): ^|
echo +================================================+

set /p "drive_letter="
if "%drive_letter%"=="" goto :boot_repair

:: Adicionar : se não existir
if not "%drive_letter:~1,1%"==":" set "drive_letter=%drive_letter%:"

:: Criar diretório e arquivo de log para boot repair
set "boot_log=!logs_dir!\boot_repair_!datestr!_!timestr!.txt"

:: Executar comandos de reparo de inicialização
echo Executando reparo de inicialização em %drive_letter%...
echo Iniciando reparo de inicialização: %date% %time% > "!boot_log!"
bootrec /fixmbr >> "!boot_log!" 2>&1
bootrec /fixboot >> "!boot_log!" 2>&1
bootrec /scanos >> "!boot_log!" 2>&1
bootrec /rebuildbcd >> "!boot_log!" 2>&1

echo +================================================+
echo ^|     Reparacao de Inicializacao Concluida       ^|
echo ^| Log salvo em: !boot_log!                       ^|
echo +================================================+

pause
goto :MENU

:deploy_image_menu
@echo off
cls
color 1F
echo +==============================================================================+
echo "  _______   _______  ______    __        ______   ____    ____ 
echo " |       \ |   ____||   _  \  |  |      /  __  \  \   \  /   / 
echo " |  .--.  ||  |__   |  |_)  | |  |     |  |  |  |  \   \/   /  
echo " |  |  |  ||   __|  |   ___/  |  |     |  |  |  |   \_    _/   
echo " |  '--'  ||  |____ |  |      |  `----.|  `--'  |     |  |     
echo " |_______/ |_______|| _|      |_______| \______/      |__|
echo +==============================================================================+
echo +==============================================================================+
echo ^| Deseja implantar uma imagem do Windows?        ^|
echo ^|                                                ^|
echo ^| [S] Sim - Implantar imagem                     ^|
echo ^| [N] Nao - Continuar sem implantar              ^|
echo ^|                                                ^|
echo +================================================+

set /p "choice=Digite sua escolha (S/N): "
if /i "%choice%"=="N" goto :skip_deploy
if /i not "%choice%"=="S" goto :deploy_image_menu



:: Configurar diretório temporário e logs
set "tempdir=%~dp0temp"
set "deploy_log=%~dp0logs\deploy_%date:~-4,4%%date:~-7,2%%date:~-10,2%_%time:~0,2%%time:~3,2%.log"
if not exist "%~dp0logs" mkdir "%~dp0logs"
if not exist "%tempdir%" mkdir "%tempdir%"

echo ============================================ > "%deploy_log%"
echo Inicio da Implantacao: %date% %time% >> "%deploy_log%"
echo ============================================ >> "%deploy_log%"

:: Verificar existência da imagem
if not exist "%~dp0Windows_Image\install.wim" (
    echo ERRO: Arquivo de imagem nao encontrado!
    echo ERRO: Imagem nao encontrada >> "%deploy_log%"
    pause
    goto :deploy_end
)

:list_disks
cls
echo +================================================+
echo ^|              Discos Disponiveis                ^|
echo +================================================+
echo.
:: Listar discos disponíveis
echo list disk | diskpart
echo.
echo +================================================+

:: Selecionar disco
set /p "disknum=Digite o numero do disco para instalacao: "
echo Disco selecionado: %disknum% >> "%deploy_log%"

:: Confirmar seleção
echo.
echo AVISO: Todo o conteudo do disco %disknum% sera apagado!
set /p "confirm=Tem certeza que deseja continuar? (S/N): "
if /i not "%confirm%"=="S" goto :list_disks

cls
echo +================================================+
echo ^|         Preparando Disco %disknum%              ^|
echo +================================================+

:: Criar script de limpeza
echo select disk %disknum% > "%tempdir%\clean.txt"
echo clean >> "%tempdir%\clean.txt"
echo convert gpt >> "%tempdir%\clean.txt"

:: Executar limpeza inicial
echo.
echo Limpando disco...
diskpart /s "%tempdir%\clean.txt" >> "%deploy_log%" 2>&1

:: Criar script de particionamento
(
echo select disk %disknum%
echo create partition efi size=260
echo format quick fs=fat32 label="System" override
echo assign letter=S noerr
echo create partition msr size=128
echo create partition primary size=800
echo format quick fs=ntfs label="Recovery" override
echo assign letter=R noerr
echo set id="de94bba4-06d1-4d40-a16a-bfd50179d6ac"
echo gpt attributes=0x8000000000000001
echo create partition primary
echo format quick fs=ntfs label="Windows" override
echo assign letter=W noerr
) > "%tempdir%\partitions.txt"

:: Executar particionamento
echo.
echo Criando particoes...
diskpart /s "%tempdir%\partitions.txt" >> "%deploy_log%" 2>&1

:: Verificar resultado
if errorlevel 1 (
    echo +================================================+
    echo ^|                    ERRO                         ^|
    echo +================================================+
    echo ^|                                                ^|
    echo ^|  Falha ao particionar o disco                  ^|
    echo ^|  Tentando metodo alternativo...                ^|
    echo ^|                                                ^|
    echo +================================================+
    
    timeout /t 5
    
    :: Tentar novamente com pausa entre operações
    diskpart /s "%tempdir%\clean.txt" >> "%deploy_log%" 2>&1
    timeout /t 5
    diskpart /s "%tempdir%\partitions.txt" >> "%deploy_log%" 2>&1
    
    if errorlevel 1 (
        echo +================================================+
        echo ^|              ERRO CRITICO                      ^|
        echo +================================================+
        echo ^|                                                ^|
        echo ^|  Falha persistente ao particionar o disco      ^|
        echo ^|                                                ^|
        echo +================================================+
        echo ERRO CRITICO: Falha no particionamento mesmo apos segunda tentativa >> "%deploy_log%"
        pause
        goto :deploy_error
    )
)

@echo off
cls
color 1F
echo +==============================================================================+
echo "    _                   _          _               
echo "   /_\    _ __   _ __  | |  _  _  (_)  _ _    __ _ 
echo "  / _ \  | '_ \ | '_ \ | | | || | | | | ' \  / _` |
echo " /_/ \_\ | .__/ | .__/ |_|  \_, | |_| |_||_| \__, |
echo "         |_|    |_|         |__/             |___/
echo +==============================================================================+
echo ^|                                                ^|
echo ^| Aplicando imagem ao disco...                   ^|
echo ^| Este processo pode demorar varios minutos      ^|
echo ^|                                                ^|
echo +================================================+

:: Aplicar imagem
dism /Apply-Image /ImageFile:"%~dp0Windows_Image\install.wim" /Index:1 /ApplyDir:W:\ /CheckIntegrity >> "%deploy_log%" 2>&1
if %errorlevel% neq 0 (
    echo ERRO: Falha ao aplicar a imagem
    echo ERRO: Falha ao aplicar a imagem >> "%deploy_log%"
    goto :deploy_error
)

:config_winre
:: Configurar WinRE
set "logfile=%~dp0winre_setup.log"
echo %date% %time% - Iniciando configuracao do WinRE >> "%logfile%"

echo ========================================
echo Configurando ambiente de recuperacao do Windows...
echo ========================================
echo %date% %time% - Iniciando criacao de diretorios >> "%logfile%"

:: Criar diretórios necessários
if not exist "R:\Recovery" (
    mkdir "R:\Recovery"
    echo Criando diretorio R:\Recovery...
    echo %date% %time% - Diretorio R:\Recovery criado >> "%logfile%"
)
if not exist "R:\Recovery\WindowsRE" (
    mkdir "R:\Recovery\WindowsRE"
    echo Criando diretorio R:\Recovery\WindowsRE...
    echo %date% %time% - Diretorio R:\Recovery\WindowsRE criado >> "%logfile%"
)

:: Procurar winre.wim em locais alternativos
set "winre_found=0"
set "winre_source="
echo %date% %time% - Iniciando busca por winre.wim >> "%logfile%"

:: Verificar no local padrão
echo Procurando WinRE no local padrao...
if exist "W:\Windows\System32\Recovery\winre.wim" (
    set "winre_source=W:\Windows\System32\Recovery\winre.wim"
    set "winre_found=1"
    echo WinRE encontrado no local padrao
    echo %date% %time% - WinRE encontrado em W:\Windows\System32\Recovery\winre.wim >> "%logfile%"
    goto :copy_winre
)

:: Procurar winre.wim no diretório do script
echo Procurando WinRE no diretorio do script...
if exist "%~dp0Windows_Image\winre.wim" (
    set "winre_source=%~dp0Windows_Image\winre.wim"
    set "winre_found=1"
    echo WinRE encontrado no diretorio do script
    echo %date% %time% - WinRE encontrado em %~dp0Windows_Image\winre.wim >> "%logfile%"
    goto :copy_winre
)

:copy_winre
if "%winre_found%"=="1" (
    echo ========================================
    echo WinRE encontrado em: %winre_source%
    echo Copiando WinRE...
    echo %date% %time% - Iniciando copia do WinRE >> "%logfile%"
    copy "%winre_source%" "R:\Recovery\WindowsRE\winre.wim" /y
    if errorlevel 1 (
        echo ERRO: Falha ao copiar WinRE
        echo %date% %time% - ERRO: Falha ao copiar WinRE >> "%logfile%"
        goto :erro
    )
    
    :: Registrar WinRE
    if exist "W:\Windows\System32\reagentc.exe" (
        echo ========================================
        echo Registrando WinRE...
        echo %date% %time% - Iniciando registro do WinRE >> "%logfile%"
        W:\Windows\System32\reagentc.exe /setreimage /path R:\Recovery\WindowsRE /target W:\Windows
        if errorlevel 1 (
            echo AVISO: Falha ao registrar WinRE
            echo %date% %time% - AVISO: Falha ao registrar WinRE >> "%logfile%"
        ) else (
            echo WinRE registrado com sucesso
            echo %date% %time% - WinRE registrado com sucesso >> "%logfile%"
        )
    )
    
    echo WinRE configurado com sucesso
    echo %date% %time% - WinRE configurado com sucesso >> "%logfile%"
) else (
    echo AVISO: Arquivo WinRE nao encontrado
    echo %date% %time% - AVISO: WinRE nao encontrado >> "%logfile%"
    echo O sistema pode funcionar sem WinRE, mas algumas funcoes de recuperacao
    echo podem nao estar disponiveis.
    echo.
    choice /c SN /m "Deseja continuar mesmo sem WinRE"
    if errorlevel 2 goto :erro
)


:: Configurar boot
echo ========================================
echo Configurando boot UEFI...
echo %date% %time% - Iniciando configuracao do boot UEFI >> "%logfile%"
bcdboot W:\Windows /s S: /f UEFI /l pt-br

if errorlevel 1 (
    echo ERRO: Falha ao configurar boot
    echo %date% %time% - ERRO: Falha ao configurar boot >> "%logfile%"
    goto :erro
)

echo %date% %time% - Boot UEFI configurado com sucesso >> "%logfile%"
pause
goto :MENU



:capture_image_menu
@echo off
cls
color 57
echo +==================================================================================+
echo "   ___                 _                          ___                             
echo "  / __|  __ _   _ __  | |_   _  _   _ _   ___    |_ _|  _ __    __ _   __ _   ___ 
echo " | (__  / _` | | '_ \ |  _| | || | | '_| / -_)    | |  | '  \  / _` | / _` | / -_)
echo "  \___| \__,_| | .__/  \__|  \_,_| |_|   \___|   |___| |_|_|_| \__,_| \__, | \___|
echo "               |_|                                                    |___/ 			   
echo +==================================================================================+
echo ^|                                                ^|
echo ^| Deseja criar uma imagem do Windows instalado?  ^|
echo ^|                                                ^|
echo ^| [S] Sim - Capturar imagem                      ^|
echo ^| [N] Nao - Continuar sem capturar               ^|
echo ^|                                                ^|
echo +================================================+

set /p "choice=Digite sua escolha (S/N): "
if /i "%choice%"=="N" goto :skip_capture
if /i not "%choice%"=="S" goto :capture_image_menu

:: Detectar ambiente Windows PE
cls
if exist X:\Windows\System32 (
    set "ambiente=offline"
) else (
    set "ambiente=online"
)

echo +================================================+
echo ^|           Ambiente Detectado                    ^|
echo +================================================+
echo ^|                                                ^|
if "%ambiente%"=="offline" (
    echo ^| Modo: Offline (Windows PE^)                    ^|
) else (
    echo ^| Modo: Online (Windows Normal^)                 ^|
)
echo ^|                                                ^|
echo +================================================+


:start_capture
setlocal EnableDelayedExpansion

:: Criar diretório para logs
if not exist "%~dp0logs" mkdir "%~dp0logs"

:: Iniciar log com cabeçalho
set "capture_log=%~dp0logs\capture_%date:~-4,4%%date:~-7,2%%date:~-10,2%_%time:~0,2%%time:~3,2%.log"
echo ============================================ > "%capture_log%"
echo Inicio da Captura: %date% %time% >> "%capture_log%"
echo ============================================ >> "%capture_log%"

:get_source_drive
cls
echo +================================================+
echo ^|            Selecao da Unidade Fonte            ^|
echo +================================================+
echo ^|                                                ^|
echo ^| Digite a letra da unidade do Windows:          ^|
echo ^| Exemplo: C                                     ^|
echo ^|                                                ^|
echo +================================================+

set /p "source_drive="
echo Unidade informada: %source_drive% >> "%capture_log%"

:: Validar entrada
if "%source_drive%"=="" (
    echo ERRO: Nenhuma unidade informada >> "%capture_log%"
    goto :get_source_drive
)

:: Normalizar letra da unidade
set "source_drive=%source_drive:~0,1%:"
echo Unidade normalizada: %source_drive% >> "%capture_log%"

:: Verificar Windows
if not exist "%source_drive%\Windows" (
    echo ERRO: Windows nao encontrado em %source_drive% >> "%capture_log%"
    echo.
    echo ERRO: Windows nao encontrado em %source_drive%
    pause
    goto :get_source_drive
)

:: Criar pasta para imagem
md "%~dp0Windows_Image" 2>nul

@echo off
cls
color 57
echo +==================================================================================+
echo "   ___                 _                  _                           
echo "  / __|  __ _   _ __  | |_   _  _   _ _  (_)  _ _    __ _             
echo " | (__  / _` | | '_ \ |  _| | || | | '_| | | | ' \  / _` |  _   _   _ 
echo "  \___| \__,_| | .__/  \__|  \_,_| |_|   |_| |_||_| \__, | (_) (_) (_)
echo "               |_|                                  |___/             
echo +==================================================================================+
echo ^|                                                ^|
echo ^| Origem: %source_drive%                         ^|
echo ^| Destino: %~dp0Windows_Image\install.wim        ^|
echo ^|                                                ^|
echo ^| Aguarde, este processo pode demorar...        ^|
echo ^|                                                ^|
echo +================================================+

echo Iniciando captura da imagem... >> "%capture_log%"

:: Comando DISM otimizado para captura offline
dism /Capture-Image /ImageFile:"%~dp0Windows_Image\install.wim" /CaptureDir:"%source_drive%" /Name:"WindowsImage" /Compress:fast

rem Comando referencia dism /Capture-Image /ImageFile:"C:\Users\User\Desktop\script\Windows_Image\install.wim" /CaptureDir:W:\ /Name:"WindowsImage" /Compress:fast


:: Verificar se o arquivo WIM foi criado e tem tamanho adequado
if exist "%~dp0Windows_Image\install.wim" (
    for %%I in ("%~dp0Windows_Image\install.wim") do set "file_size=%%~zI"
    if !file_size! GTR 1000000 (
        echo Captura concluida com sucesso >> "%capture_log%"
        
@echo off
cls
color 57
echo +==============================================================================+ 
echo "																				"
echo "        __   _           _         _                  _                       "
echo "	 	 / _| (_)  _ __   (_)  ___  | |__     ___    __| |						"
echo "		| |_  | | | '_ \  | | / __| | '_ \   / _ \  / _` |                      "
echo "		|  _| | | | | | | | | \__ \ | | | | |  __/ | (_| |						"
echo "		|_|   |_| |_| |_| |_| |___/ |_| |_|  \___|  \__,_|						"
echo "																				"
echo +==============================================================================+ 
        echo ^|                                                ^|
        echo ^| Imagem capturada com sucesso!                  ^|
        echo ^| Arquivo: %~dp0Windows_Image\install.wim        ^|
        echo ^|                                                ^|
        echo +================================================+
        pause
        goto :capture_end
    )
)

echo ERRO: Falha na captura >> "%capture_log%"
cls
echo +================================================+
echo ^|                    ERRO                         ^|
echo +================================================+
echo ^|                                                ^|
echo ^| Falha ao capturar a imagem.                   ^|
echo ^| Verifique:                                    ^|
echo ^| - Se o Windows nao esta em uso                ^|
echo ^| - Se ha espaco suficiente no disco            ^|
echo ^| - Se tem permissoes de administrador          ^|
echo ^|                                                ^|
echo ^| Log detalhado em: %capture_log%               ^|
echo ^|                                                ^|
echo +================================================+
pause
goto :capture_error

:capture_end
echo ============================================ >> "%capture_log%"
echo Fim da Captura: %date% %time% >> "%capture_log%"
echo ============================================ >> "%capture_log%"
endlocal
goto :MENU

:capture_error
echo Processo interrompido por erro >> "%capture_log%"
goto :capture_end





:drivers_section
@echo off
cls
color 80
echo +================================================================================================+
echo "  ___          _                       ___         _                       _     _              
echo " |   \   _ _  (_) __ __  ___   _ _    | __| __ __ | |_   _ _   __ _   __  | |_  (_)  ___   _ _  
echo " | |) | | '_| | | \ V / / -_) | '_|   | _|  \ \ / |  _| | '_| / _` | / _| |  _| | | / _ \ | ' \ 
echo " |___/  |_|   |_|  \_/  \___| |_|     |___| /_\_\  \__| |_|   \__,_| \__|  \__| |_| \___/ |_||_|
echo "                                                                                               
echo +================================================================================================+
echo +================================================+
echo ^|                                                ^|
echo ^| Deseja extrair drivers antes da instalacao?    ^|
echo ^|                                                ^|
echo ^| [S] Sim - Extrair drivers                      ^|
echo ^| [N] Nao - Continuar sem extrair                ^|
echo ^|                                                ^|
echo +================================================+

choice /c SN /m "Digite sua escolha"
if errorlevel 2 goto :skip_drivers
if errorlevel 1 goto :extract_drivers

:extract_drivers
:: Detectar ambiente Windows PE
if exist X:\Windows\System32 (
    set "IS_WINPE=1"
    :: Em WinPE, usar caminhos relativos ao script
    set "temp_drivers=%~dp0Temp_Drivers"
    set "final_drivers=%~dp0Drivers_Extraidos"
) else (
    set "IS_WINPE=0"
    :: Em Windows normal, usar caminhos absolutos
    set "temp_drivers=C:\Temp_Drivers"
    set "final_drivers=%~dp0Drivers_Extraidos"
)

:: Criar diretórios necessários com verificação de erro
if not exist "%temp_drivers%" (
    md "%temp_drivers%" 2>nul
    if errorlevel 1 (
        echo ERRO: Nao foi possivel criar diretorio temporario
        pause
        goto :drivers_section
    )
)

if not exist "%final_drivers%" (
    md "%final_drivers%" 2>nul
    if errorlevel 1 (
        echo ERRO: Nao foi possivel criar diretorio final
        pause
        goto :drivers_section
    )
)

:: Criar subdiretório para extração temporária
if not exist "%temp_drivers%\temp_extract" (
    md "%temp_drivers%\temp_extract" 2>nul
)

:drive_select
cls
echo +================================================+
echo ^|         Selecione a Unidade Fonte              ^|
echo +================================================+
echo ^|                                                ^|
echo ^| Digite a letra da unidade do Windows:          ^|
echo ^| Exemplo: C, D, E, F, G, H, etc.               ^|
echo ^|                                                ^|
echo +================================================+

:: Capturar letra da unidade
set /p "drive_letter="

:: Remover espaços e validar entrada
set "drive_letter=%drive_letter: =%"
if "%drive_letter%"=="" goto :drive_select

:: Adicionar : se não existir
if not "%drive_letter:~1,1%"==":" set "drive_letter=%drive_letter%:"

:: Verificar se a unidade existe e contém Windows
if not exist "%drive_letter%\Windows\System32\DriverStore\FileRepository" (
    cls
    color 0C
    echo +================================================+
    echo ^|                    ERRO                         ^|
    echo +================================================+
    echo ^|                                                ^|
    echo ^| Sistema Windows nao encontrado em %drive_letter%    ^|
    echo ^| Verifique a unidade e tente novamente          ^|
    echo ^|                                                ^|
    echo +================================================+
    pause
    color 0B
    goto :drive_select
)

cls
echo +================================================+
echo ^|         Extraindo Drivers - Aguarde            ^|
echo +================================================+
echo ^|                                                ^|
echo ^| Origem: %drive_letter%\Windows\System32\DriverStore ^|
echo ^| Destino Temporario: %temp_drivers%             ^|
echo ^| Destino Final: %final_drivers%                 ^|
echo ^|                                                ^|
echo ^| Extraindo arquivos...                          ^|
echo ^|                                                ^|
echo +================================================+

:: Criar arquivo de log para drivers
set "driver_log=%temp_drivers%\driver_extract_log.txt"
echo Extracao iniciada em: %date% %time% > "%driver_log%"

:: Método de extração em duas etapas
if "%IS_WINPE%"=="1" (
    echo Executando em ambiente Windows PE >> "%driver_log%"
    :: Copiar direto para o destino final em WinPE
    xcopy "%drive_letter%\Windows\System32\DriverStore\FileRepository\*.*" "%final_drivers%" /s /e /h /i /y >> "%driver_log%" 2>&1
) else (
    echo Executando em ambiente Windows normal >> "%driver_log%"
    :: Tentar DISM primeiro
    dism /online /export-driver /destination:"%temp_drivers%\temp_extract" >> "%driver_log%" 2>&1
    
    if errorlevel 1 (
        :: Se DISM falhar, usar xcopy
        xcopy "%drive_letter%\Windows\System32\DriverStore\FileRepository\*.*" "%temp_drivers%\temp_extract\" /s /e /h /i /y >> "%driver_log%" 2>&1
    )
    
    :: Mover para destino final
    xcopy "%temp_drivers%\temp_extract\*.*" "%final_drivers%\" /s /e /h /i /y >> "%driver_log%" 2>&1
)

:: Verificar resultado da extração
dir /s /b "%final_drivers%\*.inf" >nul 2>&1
if not errorlevel 1 (
   
@echo off
cls
color 80
echo +==============================================================================+ 
echo "																				"
echo "        __   _           _         _                  _                       "
echo "	 	 / _| (_)  _ __   (_)  ___  | |__     ___    __| |						"
echo "		| |_  | | | '_ \  | | / __| | '_ \   / _ \  / _` |                      "
echo "		|  _| | | | | | | | | \__ \ | | | | |  __/ | (_| |						"
echo "		|_|   |_| |_| |_| |_| |___/ |_| |_|  \___|  \__,_|						"
echo "																				"
echo +==============================================================================+ 
    echo ^|                                                ^|
    echo ^| Drivers extraidos com sucesso!                 ^|
	
    for /f %%i in ('dir /s /b "%final_drivers%\*.inf" ^| find /c /v ""') do (
        echo ^| Total de drivers: %%i                          ^|
    )
    echo ^|                                                ^|
    echo +================================================+
    echo.
    echo Log salvo em: %~dp0driver_extract_log.txt
    
    :: Copiar log para pasta final
    copy "%driver_log%" "%~dp0driver_extract_log.txt" >nul
    
    pause
    color 0B
) else (
    cls
    color 0C
    echo +================================================+
    echo ^|                    ERRO                         ^|
    echo +================================================+
    echo ^|                                                ^|
    echo ^| Nenhum driver foi extraido                     ^|
    echo ^| Verifique o arquivo de log para mais detalhes  ^|
    echo ^|                                                ^|
    echo +================================================+
    pause
    color 0B
)

:: Limpar diretório temporário se não estiver em WinPE
if "%IS_WINPE%"=="0" (
    rd /s /q "%temp_drivers%" 2>nul
)

goto :MENU


:: Seção de Backup
:backup_section
setlocal enabledelayedexpansion
@echo off
cls
color 90
echo +================================================================================================+
echo "  ______        ___        ______  __  ___  __    __   ______   
echo " |   _  \      /   \      /      ||  |/  / |  |  |  | |   _  \  
echo " |  |_)  |    /  ^  \    |  ,----'|  '  /  |  |  |  | |  |_)  | 
echo " |   _  <    /  /_\  \   |  |     |    <   |  |  |  | |   ___/  
echo " |  |_)  |  /  _____  \  |  `----.|  .  \  |  `--'  | |  |      
echo " |______/  /__/     \__\  \______||__|\__\  \______/  | _|     
echo +================================================================================================+
echo ^|                                                ^|
echo ^| Deseja fazer backup dos arquivos dos usuarios? ^|
echo ^|                                                ^|
echo ^| [S] Sim - Fazer backup                         ^|
echo ^| [N] Nao - Continuar sem backup                 ^|
echo ^|                                                ^|
echo +================================================+

choice /c SN /m "Digite sua escolha"
if errorlevel 2 goto :skip_backup_section
if errorlevel 1 (
    if exist X:\Windows\System32 (
        set "IS_WINPE=1"
        set "temp_backup=X:\Temp_Backup"
    ) else (
        set "IS_WINPE=0"
        set "temp_backup=C:\Temp_Backup"
    )

    :: Criar diretório final para backup
    set "final_backup=%~dp0Backup_Usuarios"
    if not exist "!final_backup!" mkdir "!final_backup!"

    :: Verificar se a letra da unidade foi definida
    if not defined drive_letter (
        :get_backup_drive
        cls
        echo +================================================+
        echo ^|         Selecione a Unidade Fonte              ^|
        echo +================================================+
        echo ^|                                                ^|
        echo ^| Digite a letra da unidade do Windows:          ^|
        echo ^| Exemplo: C, D, E, F, G, H, etc.               ^|
        echo ^|                                                ^|
        echo +================================================+

        set /p "drive_letter="
        if "!drive_letter!"=="" goto :get_backup_drive
        
        :: Adicionar : se não existir
        if not "!drive_letter:~1,1!"==":" set "drive_letter=!drive_letter!:"

        :: Verificar se é uma unidade válida com Windows
        if not exist "!drive_letter!\Users" (
            echo ERRO: Diretorio de usuarios nao encontrado em !drive_letter!
            pause
            goto :get_backup_drive
        )
    )

    :: Criar diretório temporário
    if not exist "!temp_backup!" mkdir "!temp_backup!"

    :: Criar log do backup
    set "backup_log=!temp_backup!\backup_log.txt"
    echo Backup iniciado em: %date% %time% > "!backup_log!"

    echo.
    echo +================================================+
    echo ^|             Iniciando Backup                    ^|
    echo +================================================+
    echo ^|                                                ^|
    echo ^| Origem: !drive_letter!\Users                   ^|
    echo ^| Destino: !final_backup!                        ^|
    echo ^|                                                ^|
    echo +================================================+

    :: Arrays de pastas para backup
    set "folders[0]=Desktop"
    set "folders[1]=Documents"
    set "folders[2]=Downloads"
    set "folders[3]=Pictures"
    set "folders[4]=Music"
    set "folders[5]=Videos"
    set "folders[6]=Favorites"

    :: Processar cada usuário
    for /d %%u in ("!drive_letter!\Users\*") do (
        if not "%%~nxu"=="Public" if not "%%~nxu"=="Default User" if not "%%~nxu"=="Default" (
            echo.
            echo Processando usuario: %%~nxu
            
            :: Criar diretório para o usuário
            if not exist "!temp_backup!\%%~nxu" mkdir "!temp_backup!\%%~nxu"

            :: Processar cada pasta
            for %%f in (0 1 2 3 4 5 6) do (
                if exist "%%u\!folders[%%f]!" (
                    echo Copiando !folders[%%f]!...
                    xcopy "%%u\!folders[%%f]!" "!temp_backup!\%%~nxu\!folders[%%f]!" /E /H /I /Y >> "!backup_log!" 2>&1
                )
            )
        )
    )

    :: Mover do diretório temporário para o destino final
    echo.
    echo Movendo arquivos para destino final...
    xcopy "!temp_backup!\*" "!final_backup!" /E /H /I /Y >> "!backup_log!" 2>&1

    :: Limpar diretório temporário
    rd /s /q "!temp_backup!" 2>nul

   @echo off
	cls
	color 90
	echo +==============================================================================+ 
	echo "																				"
	echo "        __   _           _         _                  _                       "
	echo "	 	 / _| (_)  _ __   (_)  ___  | |__     ___    __| |						"
	echo "		| |_  | | | '_ \  | | / __| | '_ \   / _ \  / _` |                      "
	echo "		|  _| | | | | | | | | \__ \ | | | | |  __/ | (_| |						"
	echo "		|_|   |_| |_| |_| |_| |___/ |_| |_|  \___|  \__,_|						"
	echo "																				"
	echo +==============================================================================+ 
    echo ^|                                                ^|
    echo ^| Os arquivos foram salvos em:                   ^|
    echo ^| !final_backup!                                 ^|
    echo ^|                                                ^|
    echo +================================================+
    
    :: Mover log para destino final
    move "!backup_log!" "%~dp0backup_log.txt" >nul 2>&1
    
    pause
)

:skip_backup_section
endlocal
goto :MENU

:installation_section

:: Limpar tela e mostrar cabeçalho
cls
echo +================================================+
echo ^|      Script de Instalacao Windows - v%ver%      ^|
echo +================================================+
echo ^|                                                ^|
echo ^|  Iniciando processo de instalacao...           ^|
echo ^|                                                ^|
echo +================================================+

:: Listar discos
echo.
echo +================================================+
echo ^|           Discos Disponiveis                   ^|
echo +================================================+
echo ^|                                                ^|
echo ^|  Obtendo informacoes dos discos...            ^|
echo ^|                                                ^|
echo +------------------------------------------------+

:: Executar diskpart e formatar saída
(
    echo list disk
) | diskpart

echo.
echo +================================================+
echo ^|           Selecao do Disco                     ^|
echo +================================================+
echo ^|                                                ^|
echo ^|  Digite o numero do disco para instalacao      ^|
echo ^|  ou pressione Q para sair                      ^|
echo ^|                                                ^|
echo +================================================+

set /p "disknum=Digite sua escolha: "
if /i "%disknum%"=="Q" goto :fim

:: Confirmacao
echo.
echo +================================================+
echo ^|                   ATENCAO                      ^|
echo +================================================+
echo ^|                                                ^|
echo ^|  Todo o conteudo do disco %disknum% sera apagado!  ^|
echo ^|                                                ^|
echo +================================================+

set /p "confirm=Tem certeza que deseja continuar? (S/N): "
if /i not "%confirm%"=="S" goto :fim

:: Criar script do diskpart
echo.
echo +================================================+
echo ^|         Preparando Disco %disknum%                ^|
echo +================================================+

:: Criar diretório temporário se não existir
if not exist "%tempdir%" mkdir "%tempdir%"

:: Primeiro script - Limpeza inicial
echo select disk %disknum% > "%tempdir%\clean.txt"
echo clean >> "%tempdir%\clean.txt"
echo convert gpt >> "%tempdir%\clean.txt"

:: Executar limpeza inicial
echo.
echo Limpando disco...
diskpart /s "%tempdir%\clean.txt"

:: Segundo script - Criar partições
(
echo select disk %disknum%
echo create partition efi size=260
echo format quick fs=fat32 label="System" override
echo assign letter=S noerr
echo create partition msr size=128
echo create partition primary size=800
echo format quick fs=ntfs label="Recovery" override
echo assign letter=R noerr
echo set id="de94bba4-06d1-4d40-a16a-bfd50179d6ac"
echo gpt attributes=0x8000000000000001
echo create partition primary
echo format quick fs=ntfs label="Windows" override
echo assign letter=W noerr
) > "%tempdir%\partitions.txt"

:: Executar particionamento
echo.
echo Criando particoes...
diskpart /s "%tempdir%\partitions.txt"

:: Verificar resultado
if errorlevel 1 (
    echo +================================================+
    echo ^|                    ERRO                         ^|
    echo +================================================+
    echo ^|                                                ^|
    echo ^|  Falha ao particionar o disco                  ^|
    echo ^|  Tentando metodo alternativo...                ^|
    echo ^|                                                ^|
    echo +================================================+
    
    timeout /t 5
    
    :: Tentar novamente com pausa entre operações
    diskpart /s "%tempdir%\clean.txt"
    timeout /t 5
    diskpart /s "%tempdir%\partitions.txt"
    
    if errorlevel 1 (
        echo +================================================+
        echo ^|              ERRO CRITICO                      ^|
        echo +================================================+
        echo ^|                                                ^|
        echo ^|  Falha persistente ao particionar o disco      ^|
        echo ^|                                                ^|
        echo +================================================+
        goto :erro
    )
)

:: Procurar install.wim
echo.
echo Procurando arquivo install.wim...
set "wimfile="
for %%d in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist "%%d:\sources\install.wim" (
        set "wimfile=%%d:\sources\install.wim"
        echo Install.wim encontrado em: %%d:\sources\
        goto :wimfound
    )
)

echo ERRO: Arquivo install.wim nao encontrado!
goto :erro

:wimfound
:: Listar índices disponíveis
echo.
echo +================================================+
echo ^|         Informacoes da Imagem Windows          ^|
echo +================================================+
echo ^|                                                ^|
echo ^|  Arquivo encontrado: %wimfile%                 ^|
echo ^|                                                ^|
echo +================================================+

:: Executar DISM e mostrar informações diretamente
echo.
echo +------------------------------------------------+
echo ^|              Indices Disponiveis               ^|
echo +------------------------------------------------+
echo ^|                                                ^|
dism /get-wiminfo /wimfile:"%wimfile%"
echo ^|                                                ^|
echo +------------------------------------------------+

:: Solicitar índice
echo.
echo +================================================+
echo ^|            Selecao da Versao                   ^|
echo +================================================+
echo ^|                                                ^|
echo ^|  Digite o numero do indice correspondente      ^|
echo ^|  a versao do Windows que deseja instalar       ^|
echo ^|                                                ^|
echo +================================================+

set /p "image_index=Digite sua escolha (1-9): "
if %image_index% lss 1 goto :index_input
if %image_index% gtr 9 goto :index_input

:: Aplicar imagem

@echo off
cls
color 1F
echo +==============================================================================+
echo "    _                   _          _               
echo "   /_\    _ __   _ __  | |  _  _  (_)  _ _    __ _ 
echo "  / _ \  | '_ \ | '_ \ | | | || | | | | ' \  / _` |
echo " /_/ \_\ | .__/ | .__/ |_|  \_, | |_| |_||_| \__, |
echo "         |_|    |_|         |__/             |___/
echo +==============================================================================+
echo ^|                                                ^|
echo ^| Aplicando imagem ao disco...                   ^|
echo ^| Este processo pode demorar varios minutos      ^|
echo ^|                                                ^|
echo +==================================================+
echo ^|                                                ^|
echo ^|  Origem: %wimfile%                             ^|
echo ^|  Indice: %image_index%                         ^|
echo ^|  Destino: W:\                                  ^|
echo ^|                                                ^|
echo ^|  Este processo pode demorar varios minutos...  ^|
echo ^|                                                ^|
echo +================================================+

:: Verificar se o diretório de destino existe
if not exist W:\ (
    echo.
    echo +================================================+
    echo ^|                    ERRO                         ^|
    echo +================================================+
    echo ^|                                                ^|
    echo ^|  Unidade W:\ nao encontrada                    ^|
    echo ^|  Verifique se o disco foi particionado         ^|
    echo ^|  corretamente.                                 ^|
    echo ^|                                                ^|
    echo +================================================+
    goto :erro
)

:: Aplicar a imagem
dism /apply-image /imagefile:"%wimfile%" /index:%image_index% /applydir:W:\ /verify

if errorlevel 1 (
    echo.
    echo +================================================+
    echo ^|                    ERRO                         ^|
    echo +================================================+
    echo ^|                                                ^|
    echo ^|  Falha ao aplicar a imagem do Windows          ^|
    echo ^|  Verifique:                                    ^|
    echo ^|  - Se o arquivo WIM esta integro               ^|
    echo ^|  - Se ha espaco suficiente no disco            ^|
    echo ^|  - Se o indice selecionado e valido           ^|
    echo ^|                                                ^|
    echo +================================================+
    goto :erro
)

:: Verificar instalação
if not exist "W:\Windows" (
    echo.
    echo +================================================+
    echo ^|                    ERRO                         ^|
    echo +================================================+
    echo ^|                                                ^|
    echo ^|  Falha na aplicacao da imagem                  ^|
    echo ^|  Diretorio Windows nao encontrado              ^|
    echo ^|                                                ^|
    echo +================================================+
    goto :erro
)

:: CompactOS
echo.
echo +================================================+
echo ^|              Compact OS                        ^|
echo +================================================+
echo ^|                                                ^|
echo ^|  O Compact OS pode reduzir o espaco usado     ^|
echo ^|  pelo Windows em ate 40%%, mas pode afetar    ^|
echo ^|  levemente o desempenho do sistema.           ^|
echo ^|                                                ^|
echo +================================================+

choice /c SN /m "Deseja habilitar o Compact OS"
if errorlevel 2 goto :skip_compact
if errorlevel 1 (
    echo.
    echo +------------------------------------------------+
    echo ^|  Habilitando Compact OS...                     ^|
    echo +------------------------------------------------+
    W:\Windows\System32\compact.exe /compactOS:always
)

:skip_compact


:: Instalação de drivers
echo.
echo +================================================+
echo ^|         Verificacao e Instalacao de Drivers     ^|
echo +================================================+
echo.

:: Redefinir o diretório de drivers para garantir o caminho correto
set "driverdir=%~dp0Drivers_Extraidos"

:: Verificar existência do diretório de drivers
echo Verificando drivers em: "%driverdir%"
if not exist "%driverdir%" (
    echo.
    echo +------------------------------------------------+
    echo ^|                    ERRO                         ^|
    echo +------------------------------------------------+
    echo ^|                                                ^|
    echo ^|  Diretorio de drivers nao encontrado em:       ^|
    echo ^|  %driverdir%                                   ^|
    echo ^|                                                ^|
    echo ^|  Execute a extracao de drivers primeiro.       ^|
    echo ^|                                                ^|
    echo +------------------------------------------------+
    goto :driver_end
)

:: Contar drivers disponíveis
set "driver_count=0"
for /f "delims=" %%A in ('dir /b /s "%driverdir%\*.inf" 2^>nul ^| find /c /v ""') do set "driver_count=%%A"

if %driver_count% equ 0 (
    echo.
    echo +------------------------------------------------+
    echo ^|                    ERRO                         ^|
    echo +------------------------------------------------+
    echo ^|                                                ^|
    echo ^|  Nenhum driver INF encontrado no diretorio     ^|
    echo ^|  Verifique se os drivers foram extraidos       ^|
    echo ^|  corretamente em: %driverdir%                  ^|
    echo ^|                                                ^|
    echo +------------------------------------------------+
    goto :driver_end
)

:: Mostrar informações e confirmar instalação
echo.
echo +------------------------------------------------+
echo ^|              Drivers Encontrados               ^|
echo +------------------------------------------------+
echo ^|                                                ^|
echo ^|  Total de drivers: %driver_count%              ^|
echo ^|                                                ^|
echo ^|  Origem: "%driverdir%"                         ^|
echo ^|  Destino: W:\Windows                           ^|
echo ^|                                                ^|
echo +------------------------------------------------+

choice /c SN /m "Deseja instalar os drivers agora"
if errorlevel 2 goto :driver_end

:: Perguntar sobre instalação forçada de drivers não assinados
echo.
echo +================================================+
echo ^|         Configuracao da Instalacao             ^|
echo +================================================+
echo ^|                                                ^|
echo ^|  Alguns drivers podem nao estar assinados.     ^|
echo ^|  Deseja forcar a instalacao destes drivers?    ^|
echo ^|                                                ^|
echo ^|  S = Sim (Usar /forceunsigned)                ^|
echo ^|  N = Nao (Modo padrao)                        ^|
echo ^|                                                ^|
echo +================================================+

choice /c SN /m "Forcar instalacao de drivers nao assinados"
if errorlevel 2 (
    set "force_unsigned="
) else (
    set "force_unsigned=/forceunsigned"
)

:: Iniciar instalação
echo.
echo +================================================+
echo ^|         Instalando Drivers na Imagem           ^|
echo +================================================+
echo ^|                                                ^|
echo ^|  Este processo pode demorar varios minutos     ^|
echo ^|  Por favor, aguarde...                         ^|
echo ^|                                                ^|
if defined force_unsigned (
    echo ^|  Modo: Forcando drivers nao assinados          ^|
) else (
    echo ^|  Modo: Instalacao padrao                       ^|
)
echo ^|                                                ^|
echo +================================================+

:: Criar log da instalação
set "driver_install_log=%~dp0driver_install_log.txt"
echo Instalacao iniciada em: %date% %time% > "%driver_install_log%"
echo Quantidade de drivers: %driver_count% >> "%driver_install_log%"
echo Diretorio origem: "%driverdir%" >> "%driver_install_log%"
echo Modo de instalacao: %force_unsigned% >> "%driver_install_log%"
echo. >> "%driver_install_log%"

:: Tentar instalação com DISM
echo Instalando drivers via DISM...
echo Instalando drivers via DISM... >> "%driver_install_log%"
if defined force_unsigned (
    dism /image:W:\ /add-driver /driver:"%driverdir%" /recurse /forceunsigned >> "%driver_install_log%" 2>&1
) else (
    dism /image:W:\ /add-driver /driver:"%driverdir%" /recurse >> "%driver_install_log%" 2>&1
)

:: Verificar resultado da instalação
if %errorlevel% equ 0 (
    echo.
    echo +================================================+
    echo ^|         Drivers Instalados com Sucesso!         ^|
    echo +================================================+
    
    echo.
    echo Obtendo lista de drivers instalados...
    echo. >> "%driver_install_log%"
    echo Lista de drivers instalados: >> "%driver_install_log%"
    echo ================================ >> "%driver_install_log%"
    dism /image:W:\ /get-drivers >> "%driver_install_log%" 2>&1
    
    :: Contar drivers instalados
    for /f "tokens=2 delims=:" %%a in ('dism /image:W:\ /get-drivers ^| find /c "Published Name"') do (
        set "installed_count=%%a"
        echo Total de drivers instalados: !installed_count!
    )
) else (
    echo.
    echo +================================================+
    echo ^|              ERRO na Instalacao                 ^|
    echo +================================================+
    echo ^|                                                ^|
    echo ^|  Codigo de erro: %errorlevel%                  ^|
    echo ^|                                                ^|
    echo ^|  Possiveis causas:                            ^|
    echo ^|  - Drivers incompativeis                       ^|
    echo ^|  - Problemas de permissao                      ^|
    echo ^|  - Erro no DISM                               ^|
    if not defined force_unsigned (
        echo ^|  - Drivers nao assinados                       ^|
    )
    echo ^|                                                ^|
    echo +================================================+
)

:driver_end
echo.
echo +================================================+
echo ^|              Resumo da Operacao                ^|
echo +================================================+
echo ^|                                                ^|
echo ^|  Log detalhado salvo em:                       ^|
echo ^|  %driver_install_log%                          ^|
echo ^|                                                ^|
echo +================================================+
echo.
pause


:: Criar diretórios necessários
echo.
echo Criando diretorios de configuracao...
if not exist "W:\Windows\Setup\Scripts\" mkdir "W:\Windows\Setup\Scripts\"

:: Criar SetupComplete.cmd
echo Criando script de configuracao pos-instalacao...
(
echo @echo off

echo :: Desativar hibernacao
echo powercfg -h off

echo :: Configurar arquivo de pagina
echo wmic computersystem where name="%%computername%%" set AutomaticManagedPagefile=False
echo wmic pagefileset where name="C:\\pagefile.sys" set InitialSize=1024,MaximumSize=4096

echo :: Remover arquivos desnecessarios
echo del /f /s /q C:\hiberfil.sys
echo del /f /s /q C:\pagefile.sys

echo :: Otimizar servicos
echo sc config "SysMain" start= disabled
echo sc config "WSearch" start= disabled

echo :: Limpar arquivos temporarios
echo del /f /s /q C:\Windows\Temp\*.*
echo del /f /s /q C:\Users\*\AppData\Local\Temp\*.*

echo :: Otimizar desempenho
echo powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
echo reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f

echo :: Criar script de otimizacao na area de trabalho publica
echo echo @echo off ^> "C:\Users\Public\Desktop\Otimizacao_Windows.bat"
echo echo chcp 1252 ^> nul ^>^> "C:\Users\Public\Desktop\Otimizacao_Windows.bat"
echo echo setlocal enabledelayedexpansion ^>^> "C:\Users\Public\Desktop\Otimizacao_Windows.bat"
echo echo. ^>^> "C:\Users\Public\Desktop\Otimizacao_Windows.bat"
echo echo :: Verificar privilegios de administrador ^>^> "C:\Users\Public\Desktop\Otimizacao_Windows.bat"
echo echo net session ^>nul 2^>^&1 ^>^> "C:\Users\Public\Desktop\Otimizacao_Windows.bat"
echo echo if %%errorlevel%% neq 0 ^( ^>^> "C:\Users\Public\Desktop\Otimizacao_Windows.bat"
echo echo     color 0C ^>^> "C:\Users\Public\Desktop\Otimizacao_Windows.bat"
echo echo     echo. ^>^> "C:\Users\Public\Desktop\Otimizacao_Windows.bat"
echo echo     echo ERRO: Este script precisa ser executado como Administrador! ^>^> "C:\Users\Public\Desktop\Otimizacao_Windows.bat"
echo echo     echo Por favor, clique com botao direito no script e selecione "Executar como administrador" ^>^> "C:\Users\Public\Desktop\Otimizacao_Windows.bat"
echo echo     echo. ^>^> "C:\Users\Public\Desktop\Otimizacao_Windows.bat"
echo echo     pause ^>^> "C:\Users\Public\Desktop\Otimizacao_Windows.bat"
echo echo     exit /b 1 ^>^> "C:\Users\Public\Desktop\Otimizacao_Windows.bat"
echo echo ^) ^>^> "C:\Users\Public\Desktop\Otimizacao_Windows.bat"
echo echo. ^>^> "C:\Users\Public\Desktop\Otimizacao_Windows.bat"
echo echo cls ^>^> "C:\Users\Public\Desktop\Otimizacao_Windows.bat"
echo echo echo ================================================ ^>^> "C:\Users\Public\Desktop\Otimizacao_Windows.bat"
echo echo echo           Script de Otimizacao Windows ^>^> "C:\Users\Public\Desktop\Otimizacao_Windows.bat"
echo echo echo ================================================ ^>^> "C:\Users\Public\Desktop\Otimizacao_Windows.bat"
echo echo echo. ^>^> "C:\Users\Public\Desktop\Otimizacao_Windows.bat"
echo echo echo Iniciando processo de otimizacao... ^>^> "C:\Users\Public\Desktop\Otimizacao_Windows.bat"
echo echo. ^>^> "C:\Users\Public\Desktop\Otimizacao_Windows.bat"
echo echo echo Fase 1: Limpeza de componentes do Windows... ^>^> "C:\Users\Public\Desktop\Otimizacao_Windows.bat"
echo echo Dism /Online /Cleanup-Image /SPSuperseded ^>^> "C:\Users\Public\Desktop\Otimizacao_Windows.bat"
echo echo. ^>^> "C:\Users\Public\Desktop\Otimizacao_Windows.bat"
echo echo echo Fase 2: Limpando componentes... ^>^> "C:\Users\Public\Desktop\Otimizacao_Windows.bat"
echo echo Dism /online /cleanup-image /startcomponentcleanup ^>^> "C:\Users\Public\Desktop\Otimizacao_Windows.bat"
echo echo. ^>^> "C:\Users\Public\Desktop\Otimizacao_Windows.bat"
echo echo echo Fase 3: Reset da base de componentes... ^>^> "C:\Users\Public\Desktop\Otimizacao_Windows.bat"
echo echo Dism /Online /Cleanup-Image /StartComponentCleanup /ResetBase ^>^> "C:\Users\Public\Desktop\Otimizacao_Windows.bat"
echo echo. ^>^> "C:\Users\Public\Desktop\Otimizacao_Windows.bat"
echo echo echo Fase 4: Executando limpeza de disco... ^>^> "C:\Users\Public\Desktop\Otimizacao_Windows.bat"
echo echo cleanmgr /sagerun:1 ^>^> "C:\Users\Public\Desktop\Otimizacao_Windows.bat"
echo echo. ^>^> "C:\Users\Public\Desktop\Otimizacao_Windows.bat"
echo echo echo ================================================ ^>^> "C:\Users\Public\Desktop\Otimizacao_Windows.bat"
echo echo echo             Otimizacao Concluida! ^>^> "C:\Users\Public\Desktop\Otimizacao_Windows.bat"
echo echo echo ================================================ ^>^> "C:\Users\Public\Desktop\Otimizacao_Windows.bat"
echo echo echo. ^>^> "C:\Users\Public\Desktop\Otimizacao_Windows.bat"
echo echo pause ^>^> "C:\Users\Public\Desktop\Otimizacao_Windows.bat"

echo exit
) > "W:\Windows\Setup\Scripts\SetupComplete.cmd"

:: Verificar autounattend.xml
echo.
echo Procurando arquivo autounattend.xml...
set "found_unattend=0"
for %%d in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist "%%d:\autounattend.xml" (
        echo Arquivo autounattend.xml encontrado em %%d:\
        if not exist "W:\Windows\Panther" mkdir "W:\Windows\Panther"
        copy "%%d:\autounattend.xml" "W:\Windows\Panther\autounattend.xml"
        copy "%%d:\autounattend.xml" "W:\Windows\Panther\Unattend.xml"
        set "found_unattend=1"
        goto :config_winre
    )
)


:config_winre
:: Configurar WinRE
echo.
echo Configurando ambiente de recuperacao do Windows...

:: Criar diretórios necessários
if not exist "R:\Recovery" mkdir "R:\Recovery"
if not exist "R:\Recovery\WindowsRE" mkdir "R:\Recovery\WindowsRE"

:: Procurar winre.wim em locais alternativos
set "winre_found=0"
set "winre_source="

:: Verificar no local padrão
if exist "W:\Windows\System32\Recovery\winre.wim" (
    set "winre_source=W:\Windows\System32\Recovery\winre.wim"
    set "winre_found=1"
    goto :copy_winre
)

:: Procurar na mídia de instalação
for %%d in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist "%%d:\sources\boot.wim" (
        set "winre_source=%%d:\sources\boot.wim"
        set "winre_found=1"
        goto :copy_winre
    )
)

:copy_winre
if "%winre_found%"=="1" (
    echo WinRE encontrado em: %winre_source%
    echo Copiando WinRE...
    copy "%winre_source%" "R:\Recovery\WindowsRE\winre.wim" /y
    if errorlevel 1 (
        echo ERRO: Falha ao copiar WinRE
        goto :erro
    )
    
    :: Registrar WinRE
    if exist "W:\Windows\System32\reagentc.exe" (
        echo Registrando WinRE...
        W:\Windows\System32\reagentc.exe /setreimage /path R:\Recovery\WindowsRE /target W:\Windows
        if errorlevel 1 (
            echo AVISO: Falha ao registrar WinRE
        ) else (
            echo WinRE registrado com sucesso
        )
    )
    
    echo WinRE configurado com sucesso
) else (
    echo AVISO: Arquivo WinRE nao encontrado
    echo O sistema pode funcionar sem WinRE, mas algumas funcoes de recuperacao
    echo podem nao estar disponiveis.
    echo.
    choice /c SN /m "Deseja continuar mesmo sem WinRE"
    if errorlevel 2 goto :erro
)

:: Configurar boot
echo.
echo Configurando boot UEFI...
bcdboot W:\Windows /s S: /f UEFI /l pt-br

if errorlevel 1 (
    echo ERRO: Falha ao configurar boot
    goto :erro
)



:restore_backup
echo.
echo ================================================
echo         Restauracao do Backup de Usuarios
echo ================================================
echo.

:: Verificar se existe backup para restaurar
set "backupdir=%~dp0Backup_Usuarios"
if not exist "!backupdir!" (
    echo ERRO: Diretorio de backup nao encontrado em:
    echo !backupdir!
    goto :skip_restore
)

echo Deseja restaurar os arquivos do backup para a nova instalacao?
choice /c SN /m "Digite S para restaurar ou N para continuar"
if errorlevel 2 goto :skip_restore
if errorlevel 1 (
    :: Criar log da restauração
    set "restore_log=%~dp0restore_log.txt"
    echo Restauracao iniciada em: %date% %time% > "!restore_log!"
    
    echo.
    echo Iniciando restauracao dos arquivos...
    echo.
    
    :: Processar cada pasta de usuário no backup
    for /d %%u in ("!backupdir!\*") do (
        set "username=%%~nxu"
        
        echo.
        echo ========================================
        echo Restaurando usuario: !username!
        echo ========================================
        echo.
        
        :: Verificar se o usuário já existe na nova instalação
        if not exist "W:\Users\!username!" (
            echo Criando diretorio para usuario !username!...
            mkdir "W:\Users\!username!"
        )
        
        :: Arrays de pastas para restauração
        set "folders[0]=Desktop"
        set "folders[1]=Documents"
        set "folders[2]=Downloads"
        set "folders[3]=Pictures"
        set "folders[4]=Music"
        set "folders[5]=Videos"
        set "folders[6]=Favorites"
        
        :: Processar cada pasta
        for %%f in (0 1 2 3 4 5 6) do (
            set "source_path=!backupdir!\!username!\!folders[%%f]!"
            set "dest_path=W:\Users\!username!\!folders[%%f]!"
            
            if exist "!source_path!" (
                echo.
                echo Restaurando !folders[%%f]!...
                echo Origem: !source_path!
                echo Destino: !dest_path!
                echo.
                
                echo Restauracao de !folders[%%f]! iniciada: %time% >> "!restore_log!"
                
                :: Comando Robocopy corrigido com parâmetros adequados
                robocopy "!source_path!" "!dest_path!" /E /COPY:DAT /DCOPY:DAT /R:1 /W:1 /MT:8 /NP /NFL /NDL /NC /NS /NJS /NJH
                
                if !errorlevel! LEQ 1 (
                    echo Restauracao de !folders[%%f]! concluida com sucesso >> "!restore_log!"
                ) else (
                    echo AVISO: Possivel problema na restauracao de !folders[%%f]! ^(Codigo: !errorlevel!^) >> "!restore_log!"
                )
            ) else (
                echo Pasta !folders[%%f]! nao encontrada no backup para !username!
                echo Pasta !folders[%%f]! nao encontrada no backup para !username! >> "!restore_log!"
            )
        )
        
        echo Usuario !username! processado >> "!restore_log!"
        echo ---------------------------------------- >> "!restore_log!"
    )
    
    :: Mostrar resumo da restauração
    echo.
    echo ================================================
    echo            Resumo da Restauracao
    echo ================================================
    echo.
    echo Restauracao concluida!
    echo Log detalhado salvo em: !restore_log!
    echo.
    pause
)

:skip_restore

echo.
echo Instalacao concluida com sucesso!
goto :fim


echo.
echo Instalacao concluida com sucesso!
goto :fim

:erro
echo.
echo Ocorreu um erro durante a instalacao.
echo Verifique o arquivo de log: %logfile%
pause
goto :cleanup

:fim
echo.
echo Finalizando instalacao...
echo O sistema sera reiniciado em 10 segundos...
goto :MENU

:cleanup
if exist "%tempdir%" rd /s /q "%tempdir%"
echo Log salvo em: %logfile%
echo.

endlocal
exit /b

rem final