@echo off
SetLocal EnableDelayedExpansion
chcp 1252 > Nul
::o trecho abaixo pede para quem executar o codigo o acesso administrador
net session >nul 2>&1 || (powershell start -verb runas '%~0' &exit /b)

::aqui setamos onde queremos que o windows encontre o arquivo hosts 
::obs é um caminho padrão em todas as maquinas
set hosts=C:\Windows\System32\drivers\etc\hosts

::se existrir um hosts temporario deletar
if /i exist "%host%.temp" del /q /f /a "%host%.temp"


::aqui criamos um MENU para o usuario escolher o que quer
::a linha abaixo é reponsavel por chamar  menu 
::equivalente a uma function em javascript
:MenuPrincipal
cls
echo.
echo Claudio S.S. - TI J23 -  11 99495 3116
echo.
echo O que deseja fazer?
echo.
echo  (B)loquear site
echo  (D)esbloquear site
echo  (V)er Lista de sites bloqueados
echo  (S)air
echo.
set /p "Pergunta=Informe a letra entre parenteses: "

::bem intuitivo o codigo abaixo a meu ver
IF /i "%Pergunta%"=="b" goto :Bloquear
IF /i "%Pergunta%"=="d" goto :Desbloquear
IF /i "%Pergunta%"=="v" goto :Lista
IF /i "%Pergunta%"=="s" (exit) else (goto :MenuPrincipal)

::aqui chamamos a funcao lista
:Lista
cls
echo.
echo  Lista de sites bloqueados: 
echo.
for /F "tokens=1,2" %%a in (%hosts%) do (
set Linha=%%a
if /i not "!Linha:~0,1!"=="#" echo  %%b
)
echo.
pause
goto :MenuPrincipal

::aqui chamamos a função de bloquear sites
:Bloquear
set Pergunta=
cls
echo.
set /p "Pergunta=Informe o site a ser bloqueado: "
If not Defined Pergunta goto :MenuPrincipal
echo 127.0.0.1 %Pergunta%>>"%hosts%"
goto :Lista

::aqui chamamos a funcao de desbloquear sites
:Desbloquear
set Pergunta=
cls
echo.
set /p "Pergunta=Informe o site a ser desbloqueado: "
If not Defined Pergunta goto :MenuPrincipal
for /f "Delims=" %%a in ('type "%hosts%" ^|find /i "%Pergunta%"') do (
for /F "Delims=" %%b in (%hosts%) do (
set Linha=%%b
If /i not "%%a"=="%%b" echo %%b>>"%hosts%.temp"
)
)
del /f /q /a "%hosts%"
ren "%hosts%.temp" "hosts"

goto :Lista
