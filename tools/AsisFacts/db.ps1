<#
  2단계: As-is MSSQL 카탈로그·메타 추출 → 화면별 Pack 재생성
  접속정보: asisfacts.json 의 db.envFile (기본 C:\Projects\NSCM\.env.asis 의 ASIS_DB_*)
  비밀번호는 출력/로그에 남기지 않으며, SELECT 만 실행합니다 (SP 실행 없음).
  사용:  powershell -NoProfile -ExecutionPolicy Bypass -File db.ps1
#>
$ErrorActionPreference = "Stop"
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$cfg = Join-Path $here "asisfacts.json"
$exe = Join-Path $here "_bin\AsisFacts.dll"
dotnet build (Join-Path $here "AsisFacts.csproj") -c Release -o (Join-Path $here "_bin") | Select-String "error|Build succeeded"
if ($LASTEXITCODE -ne 0) { Write-Host "빌드 실패" -ForegroundColor Red; exit 1 }
dotnet $exe db --config $cfg
if ($LASTEXITCODE -ne 0) { Write-Host "DB 추출 실패" -ForegroundColor Red; exit 1 }
dotnet $exe pack --config $cfg
if ($LASTEXITCODE -ne 0) { Write-Host "화면 Pack 실패" -ForegroundColor Red; exit 1 }
$conf = Get-Content $cfg -Raw -Encoding UTF8 | ConvertFrom-Json
Write-Host "완료: $($conf.outDir)\db  /  화면별: $($conf.outDir)\screens" -ForegroundColor Green
