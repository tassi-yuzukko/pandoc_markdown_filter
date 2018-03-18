@echo off

rem param1: markdownファイル名
rem param2: cssファイル名

if "%1"=="" (
  echo ERROR : Needs Filename.
  exit /b 1
)

if not "%2"=="" (
  rem 第２引数はcssだけ許可
  if not "%~x2"==".css" (
    echo ERROR : Arg2 is neet to css filename.
    exit /b 1
  )
  set CSS=-c %2
)

rem ファイル名から拡張子を取り除く
for /f %%i in ('echo %1') do set FILE=%%~ni

pandoc %1 -o %FILE%.html --self-contained -t html5 %CSS% -F pandoc-plantuml-filter.cmd --metadata pagetitle="%FILE%"
