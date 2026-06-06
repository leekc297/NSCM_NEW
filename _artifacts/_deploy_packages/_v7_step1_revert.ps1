# ============================================================================
# v7 Step 1 — 4 deploy 폴더 원복 (최초 파일로 복원)
# 작성: 2026-06-04
# 사용자 요청: "최초의 파일로 원복해주세요"
#
# 동작:
#   1. 4 deploy 폴더 (DMF0008/0043/0043_01/0072) 의 02/03/04 subfolder 순회
#   2. 각 subfolder 의 010_~ 등 canonical (3-digit prefix) 파일 삭제
#   3. _sqlplus_originals/ 안의 모든 .sql 파일을 parent subfolder 로 이동 (덮어쓰기)
#   4. 빈 _sqlplus_originals/ 폴더 삭제
#   5. v1~v6 변환 스크립트 (_dbeaver_*.ps1) 도 삭제
# ============================================================================

$ErrorActionPreference = 'Continue'
$root = 'C:\Projects\NSCM\_artifacts\_deploy_packages'
$deployFolders = @('DMF0008_deploy_2026-06-02', 'DMF0043_deploy_2026-06-02', 'DMF0043_01_deploy_2026-06-02', 'DMF0072_deploy_2026-06-02')

$totalDeleted = 0
$totalRestored = 0

foreach ($df in $deployFolders) {
    Write-Host "`n========== $df ==========" -ForegroundColor Cyan
    $dfPath = Join-Path $root $df
    foreach ($sub in @('02_DB_Meta_SQL', '03_SP_PKG', '04_Verify')) {
        $subPath = Join-Path $dfPath $sub
        if (-not (Test-Path $subPath)) { continue }
        $archivePath = Join-Path $subPath '_sqlplus_originals'

        # canonical 파일 (3-digit prefix) 삭제
        $canonicals = Get-ChildItem -Path $subPath -Filter '*.sql' -File | Where-Object { $_.Name -match '^\d{3}_' }
        foreach ($c in $canonicals) {
            Remove-Item -Path $c.FullName -Force
            $totalDeleted++
        }

        # archive 원본 → parent subfolder 로 복원
        if (Test-Path $archivePath) {
            $originals = Get-ChildItem -Path $archivePath -Filter '*.sql' -File
            foreach ($o in $originals) {
                $dest = Join-Path $subPath $o.Name
                Move-Item -Path $o.FullName -Destination $dest -Force
                $totalRestored++
                Write-Host ("  RESTORED: {0}" -f $o.Name)
            }
            # 빈 archive 폴더 삭제
            $remaining = Get-ChildItem -Path $archivePath -ErrorAction SilentlyContinue
            if (-not $remaining) {
                Remove-Item -Path $archivePath -Force
                Write-Host ("  REMOVED:  _sqlplus_originals/ (empty)") -ForegroundColor DarkGray
            }
        }
    }
}

# v1~v6 변환 스크립트 정리 (v7_* 만 유지)
$oldScripts = Get-ChildItem -Path $root -Filter '_dbeaver_*.ps1' -File
foreach ($s in $oldScripts) {
    Remove-Item -Path $s.FullName -Force
    Write-Host ("`nDELETED old script: {0}" -f $s.Name) -ForegroundColor DarkYellow
}

Write-Host ("`n=== 원복 완료: {0} canonical 삭제, {1} 원본 복원 ===" -f $totalDeleted, $totalRestored) -ForegroundColor Green
