"""SYS0012 (Auth Approval) 런타임 동작 진단 — 사내 Oracle 직접 query (read-only).

목적:
  사용자 보고: "Approve / Reject 메시지는 나오는데 실제 처리되지 않습니다."
  → BE 200 OK + onSuccess 실행 (toast 표시) 하지만 SCM_MST_AUTH_REQUEST UPDATE 0 row.

진단 가설 (확률 분석):
  A. (40%) `r.REQUEST_ID` undefined — BE 응답 키 mismatch (ApprovalRow.REQUEST_ID vs 실제 응답 키)
  B. (30%) 사내 메타 (BTN_MPG_M / API_M / PROC_M) 미적용 → BE 매핑 fail (silent OK)
  C. (20%) SP body (P_SYS0012_APPROVE/REJECT) 미배포 또는 다른 버전 → composite_key 매칭 fail
  D. (10%) SCM_MST_AUTH_REQUEST 의 GROUP_ID/DIVISION_ID/PLANT_ID NULL 처리 — Oracle NULL concatenation 으로 composite key mismatch

본 스크립트 read-only — 8 진단 query 실행 + 결과 보고. fix 별도 PR.

진단 항목:
  Q1. BTN_MPG_M (SYS0012) — APPROVE/REJECT/SEARCH/RETRIEVE 등 BTN_CD 인벤토리
  Q2. API_M (API_SYS0012_*) — SP URL 매핑
  Q3. PROC_M (P_SYS0012_*) — parameter 시그니처
  Q4. USER_OBJECTS (P_SYS0012_*) — SP 존재 + 상태 (VALID/INVALID)
  Q5. USER_SOURCE (P_SYS0012_APPROVE/REJECT) — body 의 JSON_TABLE PATH ($[*] vs $.data[*])
  Q6. ALL_SYNONYMS (SCMD_APP.P_SYS0012_*) — 시노님 존재
  Q7. SCM_MST_AUTH_REQUEST 의 APPROVAL_RESULT='REQUESTING' 또는 NULL 인 sample row 5개 + composite key
  Q8. 사내에 deploy artifact 가 적용된 직후 row update 흔적 (LAST_UPDATE_DATE 최근)
"""
import os, sys
import oracledb

sys.stdout.reconfigure(line_buffering=True)

u = os.getenv("NSCM_ORA_USER"); p = os.getenv("NSCM_ORA_PASS"); d = os.getenv("NSCM_ORA_DSN")
assert u and p and d, "NSCM_ORA_USER/PASS/DSN required"

conn = oracledb.connect(user=u, password=p, dsn=d)
cur = conn.cursor()
print(f"[ connected ] {d}")

# Q1. BTN_MPG_M
print("\n[ Q1 ] SCM_ADM_MNU_BTN_MPG_M (MNU_ID='SYS0012'):")
cur.execute(
    "SELECT SHT_NM, MNU_BTN_CD, API_ID, USE_YN "
    "FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='SYS0012' "
    "ORDER BY SHT_NM, MNU_BTN_CD"
)
btn_rows = cur.fetchall()
if not btn_rows:
    print("  ⚠ row 0 — BE 매핑 fail 확정 (가설 B)")
else:
    for sht, btn, api, use in btn_rows:
        print(f"  {sht} / {btn} / {api} / USE={use}")

# Q2. API_M
print("\n[ Q2 ] SCM_ADM_API_M (API_ID LIKE 'API_SYS0012_%' OR 'API_SCM0009_%'):")
cur.execute(
    "SELECT API_ID, API_TP_CD, API_URL "
    "FROM SCM_MGR.SCM_ADM_API_M "
    "WHERE API_ID LIKE 'API_SYS0012\\_%' ESCAPE '\\' "
    "   OR API_ID LIKE 'API_SCM0009\\_%' ESCAPE '\\' "
    "ORDER BY API_ID"
)
api_rows = cur.fetchall()
if not api_rows:
    print("  ⚠ row 0 — API_M 미적용 (가설 B)")
else:
    for api_id, tp, url in api_rows:
        print(f"  {api_id} / {tp} / {url}")

# Q3. PROC_M
print("\n[ Q3 ] SCM_ADM_PROC_M (PROC_NM LIKE 'P_SYS0012_%' OR 'P_SCM0009_%'):")
cur.execute(
    "SELECT PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD "
    "FROM SCM_MGR.SCM_ADM_PROC_M "
    "WHERE PROC_NM LIKE 'P_SYS0012\\_%' ESCAPE '\\' "
    "   OR PROC_NM LIKE 'P_SCM0009\\_%' ESCAPE '\\' "
    "ORDER BY PROC_NM, SORT_ORD"
)
proc_rows = cur.fetchall()
if not proc_rows:
    print("  ⚠ row 0 — PROC_M 미적용 (가설 B)")
else:
    for proc, col, tp, dtp, sort in proc_rows:
        print(f"  {proc} / {col} / {tp} / {dtp} / sort={sort}")

# Q4. USER_OBJECTS (사내 schema SCM_MGR)
print("\n[ Q4 ] ALL_OBJECTS (P_SYS0012_* / P_SCM0009_*) 존재 + 상태:")
cur.execute(
    "SELECT OWNER, OBJECT_NAME, OBJECT_TYPE, STATUS, "
    "       TO_CHAR(LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI') AS LAST_DDL "
    "FROM ALL_OBJECTS "
    "WHERE OBJECT_NAME LIKE 'P_SYS0012\\_%' ESCAPE '\\' "
    "   OR OBJECT_NAME LIKE 'P_SCM0009\\_%' ESCAPE '\\' "
    "ORDER BY OWNER, OBJECT_NAME"
)
obj_rows = cur.fetchall()
if not obj_rows:
    print("  ⚠ SP 미배포 (가설 C) — deploy artifact 04_PKG_SP/*.sql 적용 필요")
else:
    for owner, name, tp, status, last in obj_rows:
        mark = "✓" if status == "VALID" else "✗"
        print(f"  {mark} {owner}.{name} / {tp} / {status} / last DDL: {last}")

# Q5. USER_SOURCE — JSON_TABLE PATH
print("\n[ Q5 ] ALL_SOURCE — P_SYS0012_APPROVE/REJECT 의 JSON_TABLE PATH:")
cur.execute(
    "SELECT NAME, LINE, TEXT FROM ALL_SOURCE "
    "WHERE NAME IN ('P_SYS0012_APPROVE','P_SYS0012_REJECT') "
    "  AND (UPPER(TEXT) LIKE '%JSON_TABLE%' OR UPPER(TEXT) LIKE '%[*]%') "
    "ORDER BY NAME, LINE"
)
src_rows = cur.fetchall()
if not src_rows:
    print("  ⚠ SP 미배포 또는 JSON_TABLE 미사용 (가설 C)")
else:
    for name, line, text in src_rows:
        path_hint = ""
        if "'$[*]'" in str(text):
            path_hint = " ← $[*] (top-level array — BE wrap 시 fail)"
        elif "$.data[*]" in str(text):
            path_hint = " ← $.data[*] (BE wrap 정합 — OK)"
        print(f"  {name} L{line}: {str(text).rstrip()}{path_hint}")

# Q6. SYNONYMS
print("\n[ Q6 ] ALL_SYNONYMS (SCMD_APP.P_SYS0012_*):")
cur.execute(
    "SELECT OWNER, SYNONYM_NAME, TABLE_OWNER, TABLE_NAME "
    "FROM ALL_SYNONYMS "
    "WHERE SYNONYM_NAME LIKE 'P_SYS0012\\_%' ESCAPE '\\' "
    "ORDER BY OWNER, SYNONYM_NAME"
)
syn_rows = cur.fetchall()
if not syn_rows:
    print("  ⚠ SYNONYMS 0 — SCMD_APP 가 SP 호출 fail 가능 (가설 B/C)")
else:
    for owner, sn, towner, tname in syn_rows:
        print(f"  {owner}.{sn} → {towner}.{tname}")

# Q7. SCM_MST_AUTH_REQUEST sample row + composite key 생성 trace
print("\n[ Q7 ] SCM_MST_AUTH_REQUEST sample row (APPROVAL_RESULT='REQUESTING' 또는 NULL, 5개):")
cur.execute(
    "SELECT * FROM ( "
    "  SELECT USER_ID, GROUP_ID, DIVISION_ID, PLANT_ID, APPROVAL_RESULT, "
    "         (USER_ID || ':' || GROUP_ID || ':' || DIVISION_ID || ':' || PLANT_ID) AS REQUEST_ID_COMPUTED, "
    "         TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI') AS REQUEST_DATE, "
    "         TO_CHAR(LAST_UPDATE_DATE, 'YYYY-MM-DD HH24:MI') AS LAST_UPDATE_DATE "
    "  FROM SCM_MGR.SCM_MST_AUTH_REQUEST "
    "  WHERE NVL(APPROVAL_RESULT, 'REQUESTING') IN ('REQUESTING','') "
    "  ORDER BY CREATION_DATE DESC "
    ") WHERE ROWNUM <= 5"
)
sample = cur.fetchall()
if not sample:
    print("  ⚠ 'REQUESTING' 상태 row 0 — 모두 이미 처리되었거나 데이터 부재")
else:
    for r in sample:
        print(f"  USER={r[0]} GROUP={r[1]} DIV={r[2]} PLANT={r[3]} STATUS={r[4]}")
        print(f"    REQUEST_ID 추정값: '{r[5]}'")
        print(f"    REQUEST_DATE={r[6]} / LAST_UPDATE={r[7]}")

# Q8. 최근 24시간 UPDATE 흔적
print("\n[ Q8 ] SCM_MST_AUTH_REQUEST 최근 24시간 LAST_UPDATE_DATE 카운트:")
cur.execute(
    "SELECT COUNT(*) FROM SCM_MGR.SCM_MST_AUTH_REQUEST "
    "WHERE LAST_UPDATE_DATE > SYSDATE - 1"
)
recent = cur.fetchone()[0]
print(f"  {recent} row")
if recent == 0:
    print("  → APPROVE/REJECT 가 실제 UPDATE 안 함 (가설 A/D 확인)")
else:
    print("  → UPDATE 시도 row 있음. composite_key 매칭 확인 필요")

# 종합
print("\n" + "=" * 60)
print("[ 종합 진단 ]")
print(f"  Q1 BTN_MPG_M : {len(btn_rows)} row (기대 ≥ 3)")
print(f"  Q2 API_M     : {len(api_rows)} row (기대 ≥ 3 — SYS0012 신규 또는 SCM0009 legacy)")
print(f"  Q3 PROC_M    : {len(proc_rows)} row (기대 ≥ 11 — 3 SP × N param)")
print(f"  Q4 SP 존재   : {len(obj_rows)} object (기대 ≥ 3)")
print(f"  Q5 SP body   : {len(src_rows)} JSON_TABLE 관련 line")
print(f"  Q6 SYNONYMS  : {len(syn_rows)} (기대 ≥ 3)")
print(f"  Q7 sample    : {len(sample)} row")
print(f"  Q8 최근 UPDATE: {recent} row")

print("\n[ 권고 ]")
if len(btn_rows) < 3 or len(api_rows) < 3 or len(proc_rows) < 9:
    print("  → 메타 미적용. SYS0012_v1_full deploy 적용 후 BE 재시작 필요 (가설 B)")
elif len(obj_rows) < 3 or any(s != "VALID" for _, _, _, s, _ in obj_rows):
    print("  → SP 미배포 또는 INVALID. 04_PKG_SP/*.sql 재컴파일 필요 (가설 C)")
elif any("'$[*]'" in str(t) for _, _, t in src_rows):
    print("  → SP body 의 JSON_TABLE PATH = '$[*]'. BE 가 {data:[...]} wrap 시 매칭 fail 가능. fix 필요 (가설 C 변형)")
elif len(sample) > 0 and recent == 0:
    print("  → SP 호출됐으나 UPDATE 0 row. composite_key (USER_ID:GROUP_ID:DIVISION_ID:PLANT_ID) 매칭 fail.")
    print("    → FE 의 r.REQUEST_ID 값을 확인 의무 (DevTools Network 또는 React DevTools 로 SP payload trace) (가설 A)")
else:
    print("  → 모든 메타 정합. FE 측 payload trace 필요 (가설 A — REQUEST_ID 키 mismatch)")

conn.close()
print(f"\n[ done ] SYS0012 진단 완료 — read-only.")
