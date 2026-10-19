<#
  화면별 Fact Pack 만 다시 생성 (scan 결과 재사용, 수 초)
  사용:  powershell -NoProfile -ExecutionPolicy Bypass -File pack.ps1            # 전체 화면
         powershell -NoProfile -ExecutionPolicy Bypass -File pack.ps1 DMF0021    # 지정 화면
#>
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
dotnet (Join-Path $here "_bin\AsisFacts.dll") pack --config (Join-Path $here "asisfacts.json") @args
