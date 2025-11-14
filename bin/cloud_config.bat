@echo off
setlocal enabledelayedexpansion

REM Установка путей
set "LISTS_DIR=%~dp0\lists\custom"
set "OUTPUT_DIR=%~dp0\lists\hosts"
set "HOSTS_FILE=%OUTPUT_DIR%\zapret-hosts.txt"
set "IPSET_FILE=%OUTPUT_DIR%\zapret-ipset.txt"

REM Создание выходной директории, если её нет
if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

REM Очистка старых файлов
echo. > "%HOSTS_FILE%"
echo. > "%IPSET_FILE%"

echo Сканирование папки %LISTS_DIR%...
echo.

REM Поиск всех уникальных имен в list-*.txt файлах
set "file_names="
set "counter=0"

for /r "%LISTS_DIR%" %%f in (list-*.txt) do (
    set "filename=%%~nf"
    set "filename=!filename:list-=!"
    
    REM Проверяем, есть ли уже такое имя в списке
    set "found=0"
    for %%n in (!file_names!) do if "%%n"=="!filename!" set "found=1"
    
    if !found!==0 (
        set /a counter+=1
        set "file_names=!file_names! !filename!"
        set "name_!counter!=!filename!"
        echo !counter!. !filename!
    )
)

echo.
set /p choice="Введите номера файлов через пробел (например: 1 2 3 15) или 'all' для всех: "

REM Обработка выбора пользователя
set "selected_files="

if /i "!choice!"=="all" (
    echo Выбраны все файлы
    for /l %%i in (1,1,!counter!) do (
        set "selected_files=!selected_files! !name_%%i!"
    )
) else (
    for %%c in (!choice!) do (
        for /l %%i in (1,1,!counter!) do (
            if "%%c"=="%%i" (
                set "selected_files=!selected_files! !name_%%i!"
                echo Выбран: !name_%%i!
            )
        )
    )
)

echo.
echo Объединяются файлы конфигураций: !selected_files!
echo.

REM Объединение файлов
for %%s in (!selected_files!) do (
    echo Обработка: %%s
    
    REM Объединение list-*.txt файлов
    set "list_files_found=0"
    for /r "%LISTS_DIR%" %%f in (list-*%%s*.txt) do (
        set "list_files_found=1"
        echo   Добавление hosts из: %%~nxf
        type "%%f" >> "%HOSTS_FILE%"
        echo. >> "%HOSTS_FILE%"
    )
    if !list_files_found!==0 echo   Файлы list-*%%s*.txt не найдены
    
    REM Объединение ipset-*.txt файлов
    set "ipset_files_found=0"
    for /r "%LISTS_DIR%" %%f in (ipset-*%%s*.txt) do (
        set "ipset_files_found=1"
        echo   Добавление ipset из: %%~nxf
        type "%%f" >> "%IPSET_FILE%"
        echo. >> "%IPSET_FILE%"
    )
    if !ipset_files_found!==0 echo   Файлы ipset-*%%s*.txt не найдены
    echo.
)

echo.
echo Объединение завершено!
echo Файл hosts: %HOSTS_FILE%
echo Файл ipset: %IPSET_FILE%
echo.

REM Показать статистику
for /f %%A in ('find /c /v "" ^< "%HOSTS_FILE%" 2^>nul') do set "hosts_count=%%A"
for /f %%A in ('find /c /v "" ^< "%IPSET_FILE%" 2^>nul') do set "ipset_count=%%A"

echo Статистика:
echo Записей в zapret-hosts.txt: !hosts_count!
echo Записей в zapret-ipset.txt: !ipset_count!

pause