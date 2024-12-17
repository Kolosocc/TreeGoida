@echo off
:: Отключаем Ctrl+C и Ctrl+Break
setlocal enabledelayedexpansion

:: Изменяем размер консольного окна на минимальный рабочий размер (80x25)
mode con: cols=16 lines=1

:: Если nircmd установлен и доступен, запускаем скрытый запуск скрипта
nircmd exec hide "C:\path\to\your_script.bat"

:: === Настройка глубины и количества папок ===
set /a depth=2
set /a folders=3

:: === Проверка корректности ввода ===
echo %depth%|findstr /r "^[0-9][0-9]*$" >nul || (
    echo Ошибка: Глубина должна быть числом.
    exit /b
)
echo %folders%|findstr /r "^[0-9][0-9]*$" >nul || (
    echo Ошибка: Количество папок должно быть числом.
    exit /b
)

:: === Создание корневой папки и вызов функции ===
set "basePath=TreeRoot"
if not exist %basePath% mkdir %basePath%
echo Создание дерева папок с глубиной %depth% и максимум %folders% папок на каждом уровне...

call :create_tree "%basePath%" %depth% %folders%

:: === Автозапуск: перезапуск скрипта в новом окне и завершение текущего ===
start "" "%~dpnx0"
exit

:: === Функция создания дерева папок ===
:create_tree
setlocal enabledelayedexpansion
set "currentPath=%~1"
set /a currentDepth=%2
set /a maxFolders=%3

if %currentDepth% LEQ 0 exit /b

for /L %%i in (1,1,%maxFolders%) do (
    set "newFolder=!currentPath!\Folder_%%i"
    if not exist "!newFolder!" mkdir "!newFolder!"

    :: Создание файла Goida.txt только в папке Folder_1
    if "%%i"=="1" (
        echo Гойда-гойда, Братья-братья > "!newFolder!\Goida.txt"
    )

    :: Рекурсивный вызов для создания вложенных папок
    set /a newFolders=%maxFolders%-1
    if !newFolders! GTR 0 (
        call :create_tree "!newFolder!" !currentDepth!-1 !newFolders!
    )
)
endlocal
exit /b
