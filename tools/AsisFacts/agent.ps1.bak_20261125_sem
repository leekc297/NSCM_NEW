<#
  Agent: 화면 Fact Pack → 분석서 5종(analysis/source_links/web_components/oracle_migration/tobe_design) + 건수 게이트
  사용:  powershell -NoProfile -ExecutionPolicy Bypass -File agent.ps1 DMF0021                      # Claude Code 로그인(claude -p)
         powershell -NoProfile -ExecutionPolicy Bypass -File agent.ps1 DMF0021 DMF0052 -Driver api  # ANTHROPIC_API_KEY
         powershell -NoProfile -ExecutionPolicy Bypass -File agent.ps1 DMF0021 -Driver dry          # 프롬프트만 생성
  결과:  Doc\asisfacts\agent\<화면ID>\*.md (분석서 5종 + business_analysis/screen_design/unit_test), _gate.csv (summary/summary2/total), _prompt*.txt, _response*.md
         powershell -NoProfile -ExecutionPolicy Bypass -File agent.ps1 DMF0052 -Phase docs   # 1차 분석서는 그대로 두고 문서 3종만 생성
#>
$ErrorActionPreference = "Stop"
$Driver = "claude-cli"; $Model = "claude-opus-5-5"; $Phase = "all"; $Ids = @()
for ($i = 0; $i -lt $args.Count; $i++) {
  switch ($args[$i]) {
    "-Driver" { $Driver = $args[++$i] }
    "-Model"  { $Model  = $args[++$i] }
    "-Phase"  { $Phase  = $args[++$i] }   # all | analysis | docs (docs = 1차 분석서 재사용, 문서 3종만)
    default   { $Ids += $args[$i] }
  }
}
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$cfg = Join-Path $here "asisfacts.json"
$exe = Join-Path $here "_bin\AsisFacts.dll"
dotnet build (Join-Path $here "AsisFacts.csproj") -c Release -o (Join-Path $here "_bin") | Select-String "error|Build succeeded"
if ($LASTEXITCODE -ne 0) { Write-Host "빌드 실패" -ForegroundColor Red; exit 1 }
if ($Ids.Count -eq 0) { Write-Host "화면ID 를 지정하세요"; exit 1 }
& dotnet $exe agent @Ids --driver $Driver --model $Model --phase $Phase --config $cfg
$rc = $LASTEXITCODE
# 문서 Excel 묶음(사람이 보는 사본) — MD 는 그대로. 실패해도 agent 결과에는 영향 없음 (2026-10-19)
if ($rc -eq 0 -and $Driver -ne 'dry') { try { & python (Join-Path $here "..\Docs\md2xlsx.py") @Ids } catch { Write-Host "Excel 묶음 실패: $_" -ForegroundColor Yellow } }
exit $rc
