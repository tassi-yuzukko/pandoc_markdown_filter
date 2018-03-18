@echo off

rem param1: markdownファイルのパス
rem param2: 出力パス
rem param3: cssファイル名

if "%1"=="" (
  echo ERROR : Needs Filename.
  exit /b 1
)

if "%2"=="" (
  echo ERROR : Needs Output Path.
  exit /b 1
)

if not "%3"=="" (
  rem 第３引数はcssだけ許可
  if not "%~x3"==".css" (
    echo ERROR : Arg3 is neet to css filename.
    exit /b 1
  )
  set CSS=-c %3
)

rem markdownファイルのパスから拡張子を取り除く
for /f %%i in ('echo %1') do set FILE=%%~ni


pandoc %1 -o %2\\%FILE%.html --self-contained -t html5 %CSS% -F pandoc-plantuml-filter.cmd --metadata pagetitle="%FILE%"
