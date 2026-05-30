# Windows Task Scheduler 등록 (1회)
#   - Task 이름: NSCM_Daily_Backup
#   - 매일 02:00 backup-all.ps1 -ScheduledMode 실행
#   - 로그아웃 상태에서도 동작 (S4U)
#   - 실패 시 10분 간격 최대 3회 재시도
#
# 사용법:
#   .\install-backup-schedule.ps1                    # 등록 (관리자 권한 필요)
#   .\install-backup-schedule.ps1 -Uninstall         # 제거
#   .\install-backup-schedule.ps1 -At "03:00AM"      # 시간 변경
#   .\install-backup-schedule.ps1 -DryRun            # 명령만 출력

[CmdletBinding()]
param(
  [string]$TaskName = "NSCM_Daily_Backup",
  [string]$At = "02:00AM",
  [string]$ScriptPath = "C:\Projects\NSCM\_artifacts\local-docker-oracle\backup-all.ps1",
  [switch]$Uninstall,
  [switch]$DryRun
)

$ErrorActionPreference = "Stop"

function Write-Step($msg) { Write-Host "`n=== $msg ===" -ForegroundColor Cyan }
function Write-OK($msg)   { Write-Host "  [OK]   $msg"  -ForegroundColor Green }
function Write-Warn2($msg){ Write-Host "  [WARN] $msg"  -ForegroundColor Yellow }
function Write-Fail($msg) { Write-Host "  [FAIL] $msg"  -ForegroundColor Red }

# 관리자 확인
$identity = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $identity.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
  Write-Warn2 "관리자 권한이 아닙니다. ScheduledTask 등록 권한이 없을 수 있습니다."
  Write-Host "    재실행: PowerShell 을 [관리자 권한] 으로 열고 다시 실행하세요." -ForegroundColor Yellow
}

# Uninstall
if ($Uninstall) {
  Write-Step "UNINSTALL"
  $existing = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
  if ($existing) {
    if ($DryRun) {
      Write-Host "  [DRY] Unregister-ScheduledTask -TaskName $TaskName -Confirm:`$false"
    } else {
      Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
      Write-OK "Task '$TaskName' 제거 완료"
    }
  } else {
    Write-Warn2 "Task '$TaskName' 부재 — 제거 불필요"
  }
  exit 0
}

# 기존 task 확인
Write-Step "PRE-CHECK"
if (-not (Test-Path $ScriptPath)) {
  Write-Fail "ScriptPath 부재: $ScriptPath"
  exit 1
}
Write-OK "Script: $ScriptPath"

$existing = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
if ($existing) {
  Write-Warn2 "Task '$TaskName' 이미 존재 — 덮어씌움"
  if (-not $DryRun) {
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
  }
}

# Task 정의
Write-Step "REGISTER"
$action = New-ScheduledTaskAction `
  -Execute "powershell.exe" `
  -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$ScriptPath`" -ScheduledMode"

$trigger = New-ScheduledTaskTrigger -Daily -At $At

# S4U: 사용자 비밀번호 없이 로그아웃 상태에서도 실행 가능
$principal = New-ScheduledTaskPrincipal `
  -UserId "$env:USERDOMAIN\$env:USERNAME" `
  -LogonType S4U `
  -RunLevel Highest

$settings = New-ScheduledTaskSettingsSet `
  -StartWhenAvailable `
  -DontStopOnIdleEnd `
  -RestartCount 3 `
  -RestartInterval (New-TimeSpan -Minutes 10) `
  -ExecutionTimeLimit (New-TimeSpan -Hours 3) `
  -MultipleInstances IgnoreNew

if ($DryRun) {
  Write-Host "  [DRY] Register-ScheduledTask -TaskName $TaskName -Action <powershell.exe -NoProfile ...> -Trigger <Daily at $At> -Principal <S4U $env:USERNAME> -Settings <RestartCount=3>"
  exit 0
}

try {
  Register-ScheduledTask `
    -TaskName $TaskName `
    -Action $action `
    -Trigger $trigger `
    -Principal $principal `
    -Settings $settings `
    -Description "NSCM 모노레포 자동 백업 (소스 + FE node_modules + Oracle expdp)" | Out-Null
  Write-OK "Task '$TaskName' 등록 완료 (매일 $At)"

  # 등록 검증
  $task = Get-ScheduledTask -TaskName $TaskName
  Write-Host "    State: $($task.State)"
  Write-Host "    Trigger: Daily at $At"
  Write-Host ""
  Write-Host "[검증 명령]" -ForegroundColor Yellow
  Write-Host "  Get-ScheduledTask -TaskName $TaskName"
  Write-Host "  Get-ScheduledTask -TaskName $TaskName | Get-ScheduledTaskInfo"
  Write-Host "  Start-ScheduledTask -TaskName $TaskName    # 수동 즉시 실행 테스트"
  Write-Host ""
  Write-Host "[제거 명령]" -ForegroundColor Yellow
  Write-Host "  .\install-backup-schedule.ps1 -Uninstall"
} catch {
  Write-Fail "등록 실패: $_"
  exit 1
}

exit 0
