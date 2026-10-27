<#
.SYNOPSIS
  DMF0082 저장 페이로드(JSON) → Oracle SQL Developer 에서 F5 로 실행 가능한 재실행 .sql 파일 생성기 (대용량 대응)

.DESCRIPTION
  입력 JSON = 화면 저장 시 BE /{mnuId}/{shtNm}/{mnuBtnCd}/call-proc 로 보낸 Request Payload.
    · 브라우저 DevTools > Network > call-proc 요청 > Payload > "View source" 전체 복사 → 파일 저장
    · 또는 SCM_MGR.SCM_COM_SQL_LOG.PARAMS 값 (절단 "(truncated" 꼬리표가 없을 때만)
  키 = SCM_ADM_PROC_M 등록 COL_NM 17종 (activeFlag … asFromSite). p_active_flag 식 SP 파라미터명도 수용. 대소문자 무시.
  각 값은 '^' 로 이어진 긴 문자열이므로 CLOB 임시 LOB 에 ChunkSize 글자씩 DBMS_LOB.WRITEAPPEND 로 적재한다
  (PL/SQL 문자열 리터럴 32,767 바이트 한도 회피 → 크기 제한 없음).

.EXAMPLE
  powershell -ExecutionPolicy Bypass -File .\Make-Dmf0082ReplaySql.ps1 -InputJson .\dmf0082_save_payload.json
  powershell -ExecutionPolicy Bypass -File .\Make-Dmf0082ReplaySql.ps1 -InputJson .\payload.json -OutSql C:\temp\replay.sql -ChunkSize 1500

.NOTES
  생성된 .sql 은 실제 저장 SP(내부 COMMIT)를 호출한다. 운영/사내 DB 에서는 승인 절차 후에만 실행.
  작성 2026-10-21 · 기준 = PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA (IN 17 CLOB + O_RESULT_CURSOR)
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)] [string] $InputJson,
    [string] $OutSql = "",
    [int]    $ChunkSize = 2000,
    [string] $Procedure = "SCM_MGR.PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA",
    [string] $CreatedByOverride = ""
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $InputJson)) { throw "입력 파일 없음: $InputJson" }
if ($OutSql -eq "") {
    $stamp  = Get-Date -Format "yyyyMMdd_HHmmss"
    $OutSql = Join-Path (Split-Path -Parent (Resolve-Path -LiteralPath $InputJson)) "DMF0082_SAVE_REPLAY_$stamp.sql"
}

# ---------------------------------------------------------------- 1. JSON 적재
$raw = [System.IO.File]::ReadAllText((Resolve-Path -LiteralPath $InputJson), [System.Text.Encoding]::UTF8)
$raw = $raw.Trim()
# BE 로그 PARAMS 절단 꼬리표 차단
if ($raw -match '\.\.\.\(truncated, total=\d+\)\s*$') {
    throw "PARAMS 가 4,000자에서 절단된 로그입니다. 전체 페이로드(DevTools Payload)를 입력으로 주세요."
}
try { $obj = $raw | ConvertFrom-Json } catch { throw "JSON 파싱 실패: $($_.Exception.Message)" }

# SP 파라미터 순서(시그니처) ↔ 수용 키 후보
$paramSpec = @(
    @{ sp = "p_active_flag";       keys = @("activeFlag",      "p_active_flag") },
    @{ sp = "p_division_id";       keys = @("divisionId",      "p_division_id") },
    @{ sp = "p_project_code";      keys = @("projectCode",     "p_project_code") },
    @{ sp = "p_end_customer";      keys = @("endCustomer",     "p_end_customer") },
    @{ sp = "p_scm_site_id";       keys = @("scmSiteId",       "p_scm_site_id") },
    @{ sp = "p_item_id";           keys = @("itemId",          "p_item_id") },
    @{ sp = "p_dom_exp";           keys = @("domExp",          "p_dom_exp") },
    @{ sp = "p_fcst_type";         keys = @("fcstType",        "p_fcst_type") },
    @{ sp = "p_incoterms";         keys = @("incoterms",       "p_incoterms") },
    @{ sp = "p_measure";           keys = @("measure",         "p_measure") },
    @{ sp = "p_plant_site_id";     keys = @("plantSite",       "plantSiteId", "p_plant_site_id") },
    @{ sp = "p_cell_prod_site_id"; keys = @("cellProdSiteId",  "p_cell_prod_site_id") },
    @{ sp = "p_yyyymmdd";          keys = @("yyyymmdd",        "p_yyyymmdd") },
    @{ sp = "p_currency";          keys = @("currency",        "p_currency") },
    @{ sp = "p_qty";               keys = @("qty",             "p_qty") },
    @{ sp = "p_created_by";        keys = @("createdBy",       "p_created_by") },
    @{ sp = "p_as_from_site";      keys = @("asFromSite",      "p_as_from_site") }
)

# 페이로드 루트에 activeFlag 가 없으면 한 단계 아래 객체(params / body / data 등)에서 찾는다
function Find-Container($o) {
    if ($null -eq $o) { return $null }
    foreach ($p in $o.PSObject.Properties) {
        if ($p.Name -ieq "activeFlag" -or $p.Name -ieq "p_active_flag") { return $o }
    }
    foreach ($p in $o.PSObject.Properties) {
        $v = $p.Value
        if ($v -is [System.Management.Automation.PSCustomObject]) {
            $r = Find-Container $v
            if ($null -ne $r) { return $r }
        } elseif ($v -is [string] -and $v.TrimStart().StartsWith("{")) {   # HAR postData.text 등 문자열 JSON
            try { $r = Find-Container ($v | ConvertFrom-Json); if ($null -ne $r) { return $r } } catch {}
        }
    }
    return $null
}
$src = Find-Container $obj
if ($null -eq $src) { throw "activeFlag(또는 p_active_flag) 키를 찾지 못했습니다. call-proc Request Payload 인지 확인하세요." }

function Get-Val($o, [string[]] $keys) {
    foreach ($k in $keys) {
        foreach ($p in $o.PSObject.Properties) {
            if ($p.Name -ieq $k) {
                if ($null -eq $p.Value) { return $null }
                return [string] $p.Value
            }
        }
    }
    return $null   # 키 자체가 없음 → NULL 전달
}

# ---------------------------------------------------------------- 2. 값 수집
$values = [ordered]@{}
foreach ($s in $paramSpec) { $values[$s.sp] = Get-Val $src $s.keys }

if ($CreatedByOverride -ne "") { $values["p_created_by"] = $CreatedByOverride }

$missingCore = @()
foreach ($s in $paramSpec) {
    if ($s.sp -ne "p_as_from_site" -and $null -eq $values[$s.sp]) { $missingCore += $s.sp }
}
if ($missingCore.Count -gt 0) {
    Write-Warning ("페이로드에 없는 키(NULL 전달): " + ($missingCore -join ", "))
}

$af = $values["p_active_flag"]
$rowCount = if ([string]::IsNullOrEmpty($af)) { 0 } else { ([regex]::Matches($af, '\^')).Count + 1 }
$createdBy = $values["p_created_by"]
$createdById = if ($null -ne $createdBy -and $createdBy.Contains("^")) { $createdBy.Substring(0, $createdBy.IndexOf("^")) } else { $createdBy }

# ---------------------------------------------------------------- 3. PL/SQL 생성
function Esc([string] $s) {
    # 작은따옴표 → 두 개, CR/LF 는 CHR() 연결로 (리터럴 깨짐 방지)
    $s = $s.Replace("'", "''")
    $s = $s.Replace("`r", "'||CHR(13)||'").Replace("`n", "'||CHR(10)||'")
    return $s
}

$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine("/*==============================================================================================")
[void]$sb.AppendLine(" * DMF0082 저장 재실행 스크립트 (자동 생성)")
[void]$sb.AppendLine(" * 생성시각 : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')")
[void]$sb.AppendLine(" * 입력     : $InputJson")
[void]$sb.AppendLine(" * SP       : $Procedure")
[void]$sb.AppendLine(" * rows     : $rowCount  (p_active_flag 의 '^' 구분 토큰 수)")
[void]$sb.AppendLine(" * created  : $createdById")
[void]$sb.AppendLine(" * 실행     : Oracle SQL Developer 에서 열고 F5(스크립트 실행) · DBMS Output 탭 ON")
[void]$sb.AppendLine(" * ⚠ 실제 저장 SP 호출(내부 COMMIT · _H 이력 추가). 운영/사내 DB 는 승인 후에만.")
[void]$sb.AppendLine(" *==============================================================================================*/")
[void]$sb.AppendLine("SET DEFINE OFF")
[void]$sb.AppendLine("SET SERVEROUTPUT ON SIZE UNLIMITED")
[void]$sb.AppendLine("DECLARE")
foreach ($s in $paramSpec) { [void]$sb.AppendLine("    $($s.sp.PadRight(22)) CLOB;") }
[void]$sb.AppendLine("    o_rc                   SYS_REFCURSOR;")
[void]$sb.AppendLine("    v_code                 VARCHAR2(10);")
[void]$sb.AppendLine("    v_msg                  VARCHAR2(4000);")
[void]$sb.AppendLine("    v_evt                  VARCHAR2(4000);")
[void]$sb.AppendLine("    v_t0                   TIMESTAMP;")
[void]$sb.AppendLine("    PROCEDURE ap(c IN OUT NOCOPY CLOB, s IN VARCHAR2) IS")
[void]$sb.AppendLine("    BEGIN IF s IS NOT NULL THEN DBMS_LOB.WRITEAPPEND(c, LENGTH(s), s); END IF; END ap;")
[void]$sb.AppendLine("BEGIN")

foreach ($s in $paramSpec) {
    $name = $s.sp
    $val  = $values[$name]
    if ($null -eq $val) {
        [void]$sb.AppendLine("    -- $name : 페이로드에 없음 → NULL")
        continue
    }
    [void]$sb.AppendLine("    DBMS_LOB.CREATETEMPORARY($name, TRUE);")
    $len = $val.Length
    $pos = 0
    while ($pos -lt $len) {
        $take  = [Math]::Min($ChunkSize, $len - $pos)
        $chunk = $val.Substring($pos, $take)
        [void]$sb.AppendLine("    ap($name, '$(Esc $chunk)');")
        $pos += $take
    }
    if ($len -eq 0) { [void]$sb.AppendLine("    -- $name : 빈 문자열") }
}

[void]$sb.AppendLine("")
[void]$sb.AppendLine("    DBMS_OUTPUT.PUT_LINE('rows=' || (REGEXP_COUNT(p_active_flag, '\^') + 1) || ' / created_by=' || DBMS_LOB.SUBSTR(p_created_by, 100, 1));")
[void]$sb.AppendLine("    v_t0 := SYSTIMESTAMP;")
[void]$sb.AppendLine("    $Procedure(")
$i = 0
foreach ($s in $paramSpec) {
    $sep = if ($i -eq 0) { "          " } else { "        , " }
    [void]$sb.AppendLine("$sep$($s.sp.PadRight(22)) => $($s.sp)")
    $i++
}
[void]$sb.AppendLine("        , O_RESULT_CURSOR        => o_rc")
[void]$sb.AppendLine("    );")
[void]$sb.AppendLine("    FETCH o_rc INTO v_code, v_msg, v_evt;")
[void]$sb.AppendLine("    CLOSE o_rc;")
[void]$sb.AppendLine("    DBMS_OUTPUT.PUT_LINE('RESULT_CODE=' || v_code || ' / RESULT_MSG=' || v_msg || ' / EVENT=' || v_evt);")
[void]$sb.AppendLine("    DBMS_OUTPUT.PUT_LINE('elapsed=' || TO_CHAR(SYSTIMESTAMP - v_t0));")
foreach ($s in $paramSpec) {
    if ($null -ne $values[$s.sp]) { [void]$sb.AppendLine("    IF DBMS_LOB.ISTEMPORARY($($s.sp)) = 1 THEN DBMS_LOB.FREETEMPORARY($($s.sp)); END IF;") }
}
[void]$sb.AppendLine("EXCEPTION WHEN OTHERS THEN")
[void]$sb.AppendLine("    DBMS_OUTPUT.PUT_LINE('ERROR ' || SQLCODE || ' : ' || SUBSTR(SQLERRM, 1, 3000));")
[void]$sb.AppendLine("    DBMS_OUTPUT.PUT_LINE(SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 3000));")
[void]$sb.AppendLine("    RAISE;")
[void]$sb.AppendLine("END;")
[void]$sb.AppendLine("/")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("-- 사후 확인: SP 로그 최신 5행")
[void]$sb.AppendLine("SELECT LOG_TYPE, LOG_COUNT, LOG_MESSAGE, DESCRIPTION, SQL_ERR_MSG, CREATED_BY, TO_CHAR(CREATION_DATE,'YYYY-MM-DD HH24:MI:SS') AS CREATION_DATE")
[void]$sb.AppendLine("FROM (SELECT * FROM SCM_MGR.SCM_SYS_LOG_BATCH WHERE PROGRAM_NAME = 'PKG_DMF0082' ORDER BY CREATION_DATE DESC, EVENT_DATE DESC)")
[void]$sb.AppendLine("WHERE ROWNUM <= 5;")

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($OutSql, $sb.ToString(), $utf8NoBom)

$fi = Get-Item -LiteralPath $OutSql
Write-Host "생성 완료 : $($fi.FullName)"
Write-Host ("  rows={0}  created_by={1}  size={2:N0} bytes  chunk={3}" -f $rowCount, $createdById, $fi.Length, $ChunkSize)
foreach ($s in $paramSpec) {
    $v = $values[$s.sp]
    $l = if ($null -eq $v) { "NULL" } else { $v.Length }
    Write-Host ("  {0,-22} len={1}" -f $s.sp, $l)
}
