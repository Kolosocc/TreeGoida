@echo off
setlocal enabledelayedexpansion

:: Запрашиваем глубину и количество папок на каждом уровне
set /a depth=40
set /a folders=10

:: Проверка на корректность ввода (только числа)
echo %depth%|findstr /r "^[0-9][0-9]*$" >nul || (
    echo Ошибка: Глубина должна быть числом.
    pause
    exit /b
)
echo %folders%|findstr /r "^[0-9][0-9]*$" >nul || (
    echo Ошибка: Количество папок должно быть числом.
    pause
    exit /b
)

:: Начинаем создание дерева
echo Создание дерева папок с глубиной %depth% и максимум %folders% папок на каждом уровне...

set "basePath=TreeRoot"
mkdir %basePath%

call :create_tree "%basePath%" %depth% %folders%

echo Дерево папок успешно создано.
pause
exit /b

:: Рекурсивная функция для создания дерева папок
:create_tree
setlocal enabledelayedexpansion
set "currentPath=%~1"
set /a currentDepth=%2
set /a maxFolders=%3

:: Выход из рекурсии
if %currentDepth% LEQ 0 exit /b

:: Создание папок на текущем уровне
for /L %%i in (1,1,%maxFolders%) do (
    set "newFolder=!currentPath!\Folder_%%i"
    mkdir "!newFolder!"
    
    :: Если папка Folder_1, создаём файл Goida.txt и записываем текст
    if "Folder_%%i"=="Folder_1" (
        echo Гойда-гойда, Братья-братья > "!newFolder!\Goida.txt"
    )
    
    :: Рекурсивный вызов функции с уменьшенной глубиной и числом папок
    set /a newFolders=%maxFolders%-1
    if !newFolders! GTR 0 (
        call :create_tree "!newFolder!" !currentDepth!-1 !newFolders!
    )
)
endlocal
exit /b
