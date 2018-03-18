@echo off
rem 変数に％だけでなく！を使えるようにする
setlocal enabledelayedexpansion

rem param1: ドキュメントのルートフォルダー
rem param2: 出力先フォルダー
rem param3: plantuml変換用作業フォルダ(pandoc_markdown2html.batがあるところ)
rem param4: cssファイル名

if "%1"=="" (
  echo ERROR : Needs Filename.
  exit /b 1
)

if "%2"=="" (
  echo ERROR : Needs Output Path.
  exit /b 1
)

if "%3"=="" (
  echo ERROR : Needs Plantuml Working Path.
  exit /b 1
)

set OUT_DIR=%2
set PUML_DIR=%3
if not "%4"=="" (
  rem 第4引数はcssだけ許可
  if not "%~x4"==".css" (
    echo ERROR : Arg4 is neet to css filename.
    exit /b 1
  )
  set CSS=-c %~f4
)

pushd %1
set BASE_DIR=%CD%

call :STRLEN %BASE_DIR%
set BASE_DIR_LEN=%len%

echo BASE_DIR: %BASE_DIR%
echo BASE_DIR_LEN: %BASE_DIR_LEN%

rem スタート
call :FIND_FOLDERS
popd

exit /b

:FIND_FOLDERS
call :PANDOC_MARKDOWN
for /d %%i in (*) do (
  rem %CD%は、カレントディレクトリらしいです
  rem echo ☆%CD%\%%i
  pushd %%i
  call :FIND_FOLDERS
  popd
)
exit /b

:PANDOC_MARKDOWN
for %%i in (*.md) do (
  echo ★%CD%\%%i
  
  rem 出力先フォルダ名を取得
  rem ルートフォルダから現在のフォルダまでの差分名
  set MAKE_DIR=
  set MAKE_DIR=%OUT_DIR%!CD:~%BASE_DIR_LEN%!
  
  rem 出力先にフォルダを作成
  rem 既に存在する場合のエラー抑制
  mkdir !MAKE_DIR! > NUL 2>&1
  
  rem htmlファイルを出力先へ出力
  pandoc %%i -o !MAKE_DIR!\\%%~ni.html --self-contained -t html5 %CSS% --metadata pagetitle="%%~ni"
  
  rem plantuml出力フォルダへ移動
  move !MAKE_DIR!\\%%~ni.html %PUML_DIR%\\%%~ni.html
  pushd %PUML_DIR%
  call .\pandoc_markdown2html.bat %%~ni.html .\
  popd
  move %PUML_DIR%\\%%~ni.html !MAKE_DIR!\\%%~ni.html
)
exit /b

:STRLEN
set str=%1
set len=0
:LOOP
if not "%str%"=="" (
    set str=%str:~1%
    set /a len=%len%+1
    goto :LOOP
)

exit /b
