# Claude Code PreToolUse hook — DB MODE 에서 FE·BE 소스 수정 차단 (2026-11-02 신설)
#
# Input  : stdin JSON {"tool_name":"Write|Edit|MultiEdit|NotebookEdit|Bash|PowerShell","tool_input":{...}}
# Output : stderr 사유 + exit 2 (차단 → Claude 가 사유를 읽고 가이드로 전환)
# 단일 원천: tools/Harness/harness.json repairScope (DB_ONLY = DB MODE · DB_FE = UI/DB MODE)
#            Vibe_Manager 환경설정 🧭 작업 모드 또는 tools/Harness/verify/set_scope.py 로 변경
# 시험   : 환경변수 NSCM_HARNESS_JSON 으로 설정 파일 경로 지정
# 한계   : Bash 는 명령 문자열만 본다. cd 후 상대경로 쓰기나 스크립트 내부 쓰기는 잡지 못한다.
#          설정을 읽지 못하면 판정 불가로 통과한다.

$ErrorActionPreference = 'Stop'
try { [Console]::InputEncoding = [Text.Encoding]::UTF8; [Console]::OutputEncoding = [Text.Encoding]::UTF8 } catch { }

try {
  $cfgPath = if ($env:NSCM_HARNESS_JSON) { $env:NSCM_HARNESS_JSON } else { Join-Path $PSScriptRoot '..\..\tools\Harness\harness.json' }
  $scope = ([IO.File]::ReadAllText($cfgPath) | ConvertFrom-Json).repairScope
} catch {
  exit 0
}
if ($scope -ne 'DB_ONLY') { exit 0 }

try {
  $payload = [Console]::In.ReadToEnd() | ConvertFrom-Json
} catch {
  exit 0
}

$tool = [string]$payload.tool_name
$hit = $null
$src = 'nscm-(fe|be)[/\\]'

if ($tool -match '^(Write|Edit|MultiEdit|NotebookEdit)$') {
  $path = [string]$payload.tool_input.file_path
  if (-not $path) { $path = [string]$payload.tool_input.notebook_path }
  if ($path -match "(^|[/\\])$src") { $hit = $path }
}
elseif ($tool -match '^(Bash|PowerShell)$') {
  $cmd = [string]$payload.tool_input.command
  $patterns = @(
    # 리다이렉트 대상이 FE·BE
    ">>?\s*[`"']?[^\s`"'|;&]*$src",
    # 쓰기·삭제 명령의 인자가 FE·BE
    "(?i)(\bsed\s+(-[a-z]*\s+)*-[a-z]*i|\bperl\s+-[a-z]*i|\btee\b|\brm\b|\bmv\b|\bdel\b|\btruncate\b|\bRemove-Item\b|\bMove-Item\b|\bRename-Item\b|\bSet-Content\b|\bAdd-Content\b|\bOut-File\b|\bNew-Item\b)[^|;&]*$src",
    # 복사의 마지막 인자(대상)가 FE·BE
    "(?i)\b(cp|Copy-Item)\b[^|;&]*\s[`"']?[^\s`"'|;&]*$src[^\s`"'|;&]*[`"']?\s*($|[|;&])",
    # FE·BE 저장소의 작업 트리를 바꾸는 git 명령
    "(?i)\bgit\s+-C\s+[`"']?[^\s`"']*nscm-(fe|be)[^\s`"']*[`"']?\s+(checkout|restore|apply|reset|clean|merge|pull|stash|rm|mv|am|cherry-pick|rebase)\b"
  )
  foreach ($re in $patterns) { if ($cmd -match $re) { $hit = $cmd; break } }
}

if (-not $hit) { exit 0 }

$shown = if ($hit.Length -gt 200) { $hit.Substring(0, 200) + '...' } else { $hit }
[Console]::Error.WriteLine("[check-work-mode] 차단 — 현재 작업 모드 = DB MODE (tools/Harness/harness.json repairScope=DB_ONLY). FE(nscm-fe)·BE(nscm-be) 는 직접 수정하지 않습니다.`n대상: $shown`n조치: DB 객체·META 로 해결하고, FE·BE 수정이 필요한 항목은 가이드(파일:라인 · 변경 전/후 · 이유 · 검증법)를 Doc/verify/<화면ID>/FE_GUIDE_<YYYYMMDD_HHMM>.md 에 남기세요. 직접 수정이 필요하면 사용자가 환경설정 작업 모드를 UI/DB MODE 로 바꿉니다.")
exit 2
