# ============================================================================
# v8 — _sqlplus_originals 원본 복원 + 3자리 접두어만 (변환 X)
# 작성: 2026-06-04
# 사용자 요청: "_sqlplus_originals 파일의 원본으로 복원 + 실행 순서대로 3자리 접두어"
#
# 동작:
#   1. 4 deploy 폴더 × 3 subfolder 의 v7 canonical (010_~ 등) 모두 삭제
#   2. _sqlplus_originals/ 안의 모든 .sql 파일을 parent subfolder 로 이동
#      (원본 SQL*Plus + _DBeaver 짝꿍 모두 복원)
#   3. parent 의 .sql 파일들을 alphabetical 순으로 정렬 후 3자리 접두어 (010, 020, ...)
#   4. _sqlplus_originals/ 빈 폴더 제거
#   5. 내용 변환 일체 안 함 (원본 100% 보존)
# ============================================================================

$ErrorActionPreference = 'Continue'

$root = 'C:\Projects\NSCM\_artifacts\_deploy_packages'
$deployFolders = @('DMF0008_deploy_2026-06-02', 'DMF0043_deploy_2026-06-02', 'DMF0043_01_deploy_2026-06-02', 'DMF0072_deploy_2026-06-02')

$totalDeleted = 0
$totalRestored = 0
$totalPrefixed = 0

foreach ($df in $deployFolders) {
    Write-Host "`n========== $df ==========" -ForegroundColor Cyan
    $dfPath = Join-Path $root $df
    foreach ($sub in @('02_DB_Meta_SQL', '03_SP_PKG', '04_Verify')) {
        $subPath = Join-Path $dfPath $sub
        if (-not (Test-Path $subPath)) { continue }

        $archivePath = Join-Path $subPath '_sqlplus_originals'

        # Step 1: v7 canonical (3-digit prefix) 모두 삭제
        $canonicals = Get-ChildItem -Path $subPath -Filter '*.sql' -File | Where-Object { $_.Name -match '^\d{3}_' }
        foreach ($c in $canonicals) {
            Remove-Item -Path $c.FullName -Force
            $totalDeleted++
        }

        # Step 2: archive 원본 모두 parent 로 이동
        if (Test-Path $archivePath) {
            $originals = Get-ChildItem -Path $archivePath -Filter '*.sql' -File
            foreach ($o in $originals) {
                $dest = Join-Path $subPath $o.Name
                Move-Item -Path $o.FullName -Destination $dest -Force
                $totalRestored++
            }
            # 빈 archive 폴더 제거
            $remaining = Get-ChildItem -Path $archivePath -ErrorAction SilentlyContinue
            if (-not $remaining) {
                Remove-Item -Path $archivePath -Force
            }
        }

        # Step 3: alphabetical 순으로 3자리 접두어 부여 (변환 X)
        $files = Get-ChildItem -Path $subPath -Filter '*.sql' -File | Sort-Object Name
        $seq = 0
        foreach ($f in $files) {
            $seq += 10
            $newName = ('{0:D3}_{1}' -f $seq, $f.Name)
            $newPath = Join-Path $subPath $newName
            Rename-Item -Path $f.FullName -NewName $newName -Force
            $totalPrefixed++
            Write-Host ("  {0,-65}" -f $newName)
        }
    }
}

Write-Host ("`n=== 완료: {0} v7 canonical 삭제, {1} 원본 복원, {2} 접두어 부여 ===" -f $totalDeleted, $totalRestored, $totalPrefixed) -ForegroundColor Green
