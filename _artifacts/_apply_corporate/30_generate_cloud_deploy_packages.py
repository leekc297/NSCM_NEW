#!/usr/bin/env python3
"""
DMF0008 + DMF0043_01 변경분 클라우드 배포 SQL 생성.

DMF0008 변경 내역 (2026-06-11):
  1) PROC_M signature fix:
     - DMF0008_GET_EDI_MST_SUMMARY (6→8 args, fromYyyymmdd/toYyyymmdd/o_rc3 추가)
     - DMF0008_GET_EDI_MST_REPAIR (7→9 args, fromYyyymmdd/toYyyymmdd 추가)
     - DMF0008_GET_SALES_SITE (8→5 args, sesUserId/menuId/o_rc1 제거)
  2) PROC_M BE auto-fill 키 통일: menuId → mnuId (3 SP)
  3) SP body fix:
     - DMF0008_GET_EDI_MST_SUMMARY (NVL NULL → NVL 'N', 2곳)
     - DMF0008_GET_EDI_MST_REPAIR (NVL NULL → NVL 'N' 7곳 + bare != 'Y' → NVL wrap 4곳)

DMF0043_01 변경 내역 (2026-06-11):
  SP body 5축 fix:
     - PRODUCT_GROUP '' → 'N' (Option A — 사내 schema dropped column)
     - UF_FX_STRING_SPLIT → inline TRIM(SUBSTR/INSTR) (PL/SQL context switch 제거)
     - ORDER BY A. → ORDER BY (Oracle UNION ALL ORDER BY 호환)
     - INSERT /*+ APPEND */ + SELECT /*+ LEADING/USE_HASH/DYNAMIC_SAMPLING */ 힌트
     - JOIN 에서 PRODUCT_GROUP 매칭 제거 (cloud data 활용)

출력:
  _artifacts/_deploy_packages/DMF0008/01_SP_BODY/
    070_DMF0008_GET_EDI_MST_SUMMARY_Body.sql
    071_DMF0008_GET_EDI_MST_REPAIR_Body.sql
  _artifacts/_deploy_packages/DMF0008/03_META/
    130_DMF0008_PROC_M_2026-06-11_fix.sql
  _artifacts/_deploy_packages/DMF0008/_README_2026-06-11_DEPLOY.md

  _artifacts/_deploy_packages/DMF0043/01_SP_BODY/
    050_DMF0043_GET_CONTRIBUTION_SALES_LIST_Body.sql
  _artifacts/_deploy_packages/DMF0043/_README_2026-06-11_DMF0043_01_DEPLOY.md
"""
import datetime
from pathlib import Path
import oracledb

CONN = dict(user="SCM_MGR", password="!SCMroqkf2026",
            dsn=oracledb.makedsn(host="121.162.245.167", port=2521, sid="ESSCMD"))

ROOT = Path("C:/Projects/NSCM/_artifacts/_deploy_packages")
DMF0008_SP = ROOT / "DMF0008/01_SP_BODY"
DMF0008_META = ROOT / "DMF0008/03_META"
DMF0043_SP = ROOT / "DMF0043/01_SP_BODY"
DMF0043_SP.mkdir(parents=True, exist_ok=True)
DMF0008_SP.mkdir(parents=True, exist_ok=True)
DMF0008_META.mkdir(parents=True, exist_ok=True)


def fetch_sp_body(conn, name):
    cur = conn.cursor()
    cur.execute(
        "SELECT TEXT FROM USER_SOURCE WHERE NAME=:n AND TYPE='PROCEDURE' ORDER BY LINE",
        n=name,
    )
    body = "".join(r[0] or "" for r in cur.fetchall())
    cur.close()
    return body


def main():
    ts_iso = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    conn = oracledb.connect(**CONN)
    try:
        # ============================================================
        # DMF0008 — SP body 2 + PROC_M 3
        # ============================================================
        for sp_name, fname, change_note in [
            (
                "DMF0008_GET_EDI_MST_SUMMARY",
                "070_DMF0008_GET_EDI_MST_SUMMARY_Body.sql",
                "NVL(EXCEPTION_FLAG, NULL) → NVL(EXCEPTION_FLAG, 'N') (2곳)\n"
                "--   사고: AS-IS MSSQL ISNULL(x, '') → Oracle NVL(x, NULL) 잘못 변환 → NULL row 모두 ELSE 0 처리\n"
                "--   결과: 정상/정비/예외 카운트 모두 0 표시\n"
                "--   메모리: feedback_isnull_to_nvl_null_handling",
            ),
            (
                "DMF0008_GET_EDI_MST_REPAIR",
                "071_DMF0008_GET_EDI_MST_REPAIR_Body.sql",
                "NVL(EXCEPTION_FLAG, NULL) → NVL(.., 'N') (7곳) +\n"
                "--   bare EXCEPTION_FLAG != 'Y' → NVL(.., 'N') != 'Y' wrap (4곳)\n"
                "--   사고: line 153 의 SUM(CASE WHEN STATUS_CODE IN ('U','E') AND EXCEPTION_FLAG != 'Y' THEN 1) STATUS_CODE_\n"
                "--   에서 NULL flag row 가 ELSE 0 → SUM=0 → 'STATUS_CODE_ > 0' 필터 fail → 정비필요(flag=4) 0 rows\n"
                "--   메모리: feedback_isnull_to_nvl_null_handling + feedback_sp_no_fake_extraction",
            ),
        ]:
            body = fetch_sp_body(conn, sp_name)
            if not body:
                print(f"[FAIL] {sp_name} not found")
                continue
            header = (
                f"-- ========================================================================\n"
                f"-- Deploy: {sp_name}\n"
                f"-- Source: 사내 Oracle (121.162.245.167:2521:ESSCMD) SCM_MGR @ {ts_iso}\n"
                f"-- Target: 클라우드 Oracle 의 동일 schema\n"
                f"-- ========================================================================\n"
                f"-- 변경 내역 (2026-06-11 DMF0008 정상/정비/예외 카운트 0 silent fail 진단 후):\n"
                f"--   {change_note}\n"
                f"-- ========================================================================\n"
                f"-- 실행 방법:\n"
                f"--   1) 본 파일을 그대로 실행 (CREATE OR REPLACE 가 기존 SP 갱신)\n"
                f"--   2) STATUS=VALID 확인:\n"
                f"--      SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME='{sp_name}';\n"
                f"--   3) 조회 결과 카운트 검증 (DMF0008 화면 → BMW 등 sender 의 정상/정비/예외 모두 > 0)\n"
                f"-- ========================================================================\n\n"
                f"CREATE OR REPLACE "
            )
            (DMF0008_SP / fname).write_text(header + body + "\n", encoding="utf-8")
            print(f"[OK] {fname} ({len(body)} chars)")

        # DMF0008 PROC_M 통합 fix SQL
        proc_m_sql = (DMF0008_META / "130_DMF0008_PROC_M_2026-06-11_fix.sql")
        proc_m_sql.write_text(
            f"""-- ========================================================================
-- Deploy: DMF0008 PROC_M signature 정합 fix (2026-06-11)
-- Source: 사내 Oracle @ {ts_iso}
-- ========================================================================
-- 변경 사유:
--   1) SP signature (8/9/5 args) 와 PROC_M (6/7/8 args) 불일치 →
--      BE 호출 시 ORA-06550 PLS-00306 (인수 갯수 잘못)
--      → 사용자 "SQL error" 신고
--   2) BE auto-fill 키 menuId 가 NULL 전달 → SP 의
--      PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(p_user_id, p_menu_id) 권한 조인 실패 → 0 rows
--      → 올바른 키 = mnuId (BE 가 자동 채움)
--
-- 영향 SP (3종):
--   - DMF0008_GET_EDI_MST_SUMMARY     (6 → 8 args)
--   - DMF0008_GET_EDI_MST_REPAIR      (7 → 9 args)
--   - DMF0008_GET_SALES_SITE          (8 → 5 args)
--   - DMF0008_GET_SALES_SITE_PROJECT_MODEL (menuId → mnuId)
--   - DMF0008_GET_UPDATE_HISTORY (이미 mnuId — fix 무관)
--
-- 메모리: feedback_proc_meta_mandatory + feedback_proc_meta_must_match_sp_signature
-- hook  : proc-meta-signature-match
-- ========================================================================

-- BLOCK 1: SUMMARY PROC_M
DELETE FROM SCM_ADM_PROC_M WHERE PROC_NM = 'DMF0008_GET_EDI_MST_SUMMARY';
INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('DMF0008_GET_EDI_MST_SUMMARY', 'fromYyyymmdd',    'VARCHAR',     'IN',  1, 'admin', SYSDATE, 'admin', SYSDATE);
INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('DMF0008_GET_EDI_MST_SUMMARY', 'toYyyymmdd',      'VARCHAR',     'IN',  2, 'admin', SYSDATE, 'admin', SYSDATE);
INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('DMF0008_GET_EDI_MST_SUMMARY', 'divisionId',      'VARCHAR',     'IN',  3, 'admin', SYSDATE, 'admin', SYSDATE);
INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('DMF0008_GET_EDI_MST_SUMMARY', 'sesUserId',       'VARCHAR',     'IN',  4, 'admin', SYSDATE, 'admin', SYSDATE);
INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('DMF0008_GET_EDI_MST_SUMMARY', 'mnuId',           'VARCHAR',     'IN',  5, 'admin', SYSDATE, 'admin', SYSDATE);
INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('DMF0008_GET_EDI_MST_SUMMARY', 'o_rc1',           'CURSOR',      'OUT', 6, 'admin', SYSDATE, 'admin', SYSDATE);
INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('DMF0008_GET_EDI_MST_SUMMARY', 'o_rc3',           'CURSOR',      'OUT', 7, 'admin', SYSDATE, 'admin', SYSDATE);
INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('DMF0008_GET_EDI_MST_SUMMARY', 'O_RESULT_CURSOR', 'PROC_RESULT', 'OUT', 8, 'admin', SYSDATE, 'admin', SYSDATE);

-- BLOCK 2: REPAIR PROC_M
DELETE FROM SCM_ADM_PROC_M WHERE PROC_NM = 'DMF0008_GET_EDI_MST_REPAIR';
INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('DMF0008_GET_EDI_MST_REPAIR', 'divisionId',      'VARCHAR',     'IN',  1, 'admin', SYSDATE, 'admin', SYSDATE);
INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('DMF0008_GET_EDI_MST_REPAIR', 'fromYyyymmdd',    'VARCHAR',     'IN',  2, 'admin', SYSDATE, 'admin', SYSDATE);
INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('DMF0008_GET_EDI_MST_REPAIR', 'toYyyymmdd',      'VARCHAR',     'IN',  3, 'admin', SYSDATE, 'admin', SYSDATE);
INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('DMF0008_GET_EDI_MST_REPAIR', 'senderName',      'VARCHAR',     'IN',  4, 'admin', SYSDATE, 'admin', SYSDATE);
INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('DMF0008_GET_EDI_MST_REPAIR', 'flag',            'VARCHAR',     'IN',  5, 'admin', SYSDATE, 'admin', SYSDATE);
INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('DMF0008_GET_EDI_MST_REPAIR', 'sesUserId',       'VARCHAR',     'IN',  6, 'admin', SYSDATE, 'admin', SYSDATE);
INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('DMF0008_GET_EDI_MST_REPAIR', 'mnuId',           'VARCHAR',     'IN',  7, 'admin', SYSDATE, 'admin', SYSDATE);
INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('DMF0008_GET_EDI_MST_REPAIR', 'o_rc1',           'CURSOR',      'OUT', 8, 'admin', SYSDATE, 'admin', SYSDATE);
INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('DMF0008_GET_EDI_MST_REPAIR', 'O_RESULT_CURSOR', 'PROC_RESULT', 'OUT', 9, 'admin', SYSDATE, 'admin', SYSDATE);

-- BLOCK 3: GET_SALES_SITE PROC_M
DELETE FROM SCM_ADM_PROC_M WHERE PROC_NM = 'DMF0008_GET_SALES_SITE';
INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('DMF0008_GET_SALES_SITE', 'divisionId',      'VARCHAR',     'IN',  1, 'admin', SYSDATE, 'admin', SYSDATE);
INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('DMF0008_GET_SALES_SITE', 'soldTo',          'VARCHAR',     'IN',  2, 'admin', SYSDATE, 'admin', SYSDATE);
INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('DMF0008_GET_SALES_SITE', 'shipTo',          'VARCHAR',     'IN',  3, 'admin', SYSDATE, 'admin', SYSDATE);
INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('DMF0008_GET_SALES_SITE', 'scmSiteId',       'VARCHAR',     'IN',  4, 'admin', SYSDATE, 'admin', SYSDATE);
INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('DMF0008_GET_SALES_SITE', 'O_RESULT_CURSOR', 'PROC_RESULT', 'OUT', 5, 'admin', SYSDATE, 'admin', SYSDATE);

-- BLOCK 4: BE auto-fill 키 통일 (menuId → mnuId, 잔존 3건 일괄)
UPDATE SCM_ADM_PROC_M SET COL_NM = 'mnuId'
 WHERE PROC_NM LIKE 'DMF0008%' AND COL_NM = 'menuId';

COMMIT;

-- BLOCK 5: 검증 (모든 GET SP 의 SP signature 와 PROC_M 정합 = 0 row 의무)
SELECT a.OBJECT_NAME, a.arg_cnt sig_args, NVL(p.proc_m_cnt,0) proc_m_args,
       a.arg_cnt - NVL(p.proc_m_cnt,0) diff
  FROM (SELECT OBJECT_NAME, COUNT(*) arg_cnt FROM USER_ARGUMENTS
         WHERE OBJECT_NAME LIKE 'DMF0008%' AND PACKAGE_NAME IS NULL
         GROUP BY OBJECT_NAME) a
  LEFT JOIN (SELECT PROC_NM, COUNT(*) proc_m_cnt FROM SCM_ADM_PROC_M
              WHERE PROC_NM LIKE 'DMF0008%'
              GROUP BY PROC_NM) p ON a.OBJECT_NAME = p.PROC_NM
 WHERE a.OBJECT_NAME LIKE '%GET%' AND a.arg_cnt != NVL(p.proc_m_cnt,0)
 ORDER BY a.OBJECT_NAME;
-- 결과 0 row 의무.

SELECT PROC_NM, COL_NM FROM SCM_ADM_PROC_M
 WHERE PROC_NM LIKE 'DMF0008%' AND COL_NM = 'menuId';
-- 결과 0 row 의무.
""",
            encoding="utf-8",
        )
        print(f"[OK] {proc_m_sql.name}")

        # DMF0008 README
        dmf0008_readme = ROOT / "DMF0008" / "_README_2026-06-11_DEPLOY.md"
        dmf0008_readme.write_text(
            f"""# DMF0008 보완 클라우드 적용 패키지 — 2026-06-11

> 본 패키지는 2026-06-11 작업분. 기존 (`_README_2026-06-10_DEPLOY.md`) 의 추가 보완.

## 사고 + Fix 요약

| # | 사고 | Root cause | Fix |
|---|---|---|---|
| 1 | DMF0008 조회 시 `ORA-06550 PLS-00306 인수 갯수 잘못` | SP signature 변경 (오늘 SP body 업데이트로 sig 변경) ↔ PROC_M 옛 sig 잔존 | PROC_M 3 SP (SUMMARY/REPAIR/GET_SALES_SITE) 재구성 |
| 2 | Summary 조회 SQL 정상 / 데이터 0 rows | BE auto-fill `menuId` 키 = NULL 전달 → SP 의 `PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(p_user_id, NULL)` 권한 조인 실패 | PROC_M.COL_NM `menuId` → `mnuId` (BE 자동 채움 키, 3 SP) |
| 3 | Summary 정상/정비/예외 카운트 모두 0 (실 데이터 있음에도) | inner SELECT 의 `NVL(EXCEPTION_FLAG, NULL) != 'Y'` → NULL!= 'Y' = UNKNOWN → CASE THEN 1 ELSE 0 = 0 | SUMMARY/REPAIR SP body 의 `NVL(.., NULL)` → `NVL(.., 'N')` |
| 4 | Repair 의 정비필요 (flag=4) 더블클릭 시 0 rows | line 153 `SUM(CASE WHEN ... AND EXCEPTION_FLAG != 'Y' THEN 1) STATUS_CODE_` bare 패턴 (NVL 미적용) → NULL flag 모두 0 → SUM=0 → `STATUS_CODE_ > 0` 필터 fail | REPAIR SP body bare `!= 'Y'` → `NVL(.., 'N') != 'Y'` (4곳) |

## 배포 파일

| 파일 | 내용 |
|---|---|
| `01_SP_BODY/070_DMF0008_GET_EDI_MST_SUMMARY_Body.sql` | SUMMARY SP body (NVL fix 적용본) |
| `01_SP_BODY/071_DMF0008_GET_EDI_MST_REPAIR_Body.sql` | REPAIR SP body (NVL fix + bare != 'Y' fix 적용본) |
| `03_META/130_DMF0008_PROC_M_2026-06-11_fix.sql` | PROC_M 3 SP 재구성 + menuId → mnuId 통일 + 검증 SELECT |

## 적용 순서

### Phase 1: PROC_M 메타 갱신
1. `03_META/130_DMF0008_PROC_M_2026-06-11_fix.sql` 실행
2. BLOCK 5 검증 SELECT 2건 모두 `0 row` 확인 의무

### Phase 2: SP body 갱신
1. `01_SP_BODY/070_DMF0008_GET_EDI_MST_SUMMARY_Body.sql` 실행
2. `01_SP_BODY/071_DMF0008_GET_EDI_MST_REPAIR_Body.sql` 실행
3. 두 SP 모두 `STATUS=VALID` 확인 의무

### Phase 3: 실 데이터 검증
1. DMF0008 화면 진입 → div=81 자동 선택
2. 조회 → Summary BMW 의 정상/정비/예외 각 행 > 0 표시 확인
3. BMW SUCCESS 셀 더블클릭 → Repair grid 96 rows
4. BMW GSCM_MASTER_DATA (정비필요) 셀 더블클릭 → Repair grid 54 rows
5. Sales Site / SSPM dblClick 동작 정상 확인

## 합격 기준

| Phase | 기준 |
|---|---|
| 1 | PROC_M 검증 SELECT 2건 모두 0 row |
| 2 | 2 SP 모두 STATUS=VALID |
| 3 | BMW 의 4 단계 (Summary 조회 / 정상 더블클릭 / 정비필요 더블클릭 / SSPM dblClick) 모두 데이터 표시 |

## 룰 보강 (별도 git commit — cloud 무관)

- `Doc/_rules_v2/hooks/sp-no-fake-data-extraction.md` 신규 hook — PKG/SP 가짜 구현 절대 금지 (NVL NULL / bare != 'Y' / DUMMY cursor 등 18 패턴 검출)
- 메모리 `feedback_sp_no_fake_extraction.md` 신규

## 변경 이력

| 일자 | 변경 |
|---|---|
| 2026-06-05 | 초기 패키지 (`README.md`) |
| 2026-06-10 오전 | PROC_M O_RESULT_CURSOR boost + FE 4 grid 분리 (`_README_2026-06-10_PATCH.md`) |
| 2026-06-10 오후 | 6 사고 종합 fix + SHEET_COLUMNS NULL flag fix (`_README_2026-06-10_DEPLOY.md`) |
| **2026-06-11** | **PROC_M signature 정합 + menuId→mnuId + NVL EXCEPTION_FLAG fix (본 README)** |
""",
            encoding="utf-8",
        )
        print(f"[OK] {dmf0008_readme.name}")

        # ============================================================
        # DMF0043_01 — SP body 1 (V1 최종본)
        # ============================================================
        sp_name = "DMF0043_GET_CONTRIBUTION_SALES_LIST"
        body = fetch_sp_body(conn, sp_name)
        if body:
            header = (
                f"-- ========================================================================\n"
                f"-- Deploy: {sp_name} (DMF0043_01 ContributeView)\n"
                f"-- Source: 사내 Oracle @ {ts_iso}\n"
                f"-- Target: 클라우드 Oracle 의 동일 schema\n"
                f"-- ========================================================================\n"
                f"-- 변경 내역 (2026-06-11 ContributeView 조회 silent 0 rows + 속도 사고 누적 해결):\n"
                f"--\n"
                f"--   1) PRODUCT_GROUP 하드코딩 '' → 'N' (3 곳: line 387/471/680 + GROUP BY 427/503/716)\n"
                f"--      사유: 사내 schema 의 SCM_MST_SITE_ITEM.REPORT_GROUP3 dropped → SP 가\n"
                f"--            '' AS PRODUCT_GROUP 하드코딩. FE handleSave 는 NOT NULL 회피 위해 'N'\n"
                f"--            저장. LEFT JOIN SITE_ITEM.PG = RATIO.PG 의 '' vs 'N' 매치 0건 →\n"
                f"--            모든 셀 NULL. 둘 다 'N' 으로 통일.\n"
                f"--      메모리: feedback_dropped_column_get_save_alignment\n"
                f"--\n"
                f"--   2) UF_FX_STRING_SPLIT (PIPELINED PL/SQL 함수) → inline TRIM(SUBSTR/INSTR)\n"
                f"--      사유: AS-IS MSSQL STRING_SPLIT (inline TVF) → Oracle UF_FX_STRING_SPLIT\n"
                f"--            (PL/SQL PIPELINED) 잘못 변환. row 마다 SQL→PL/SQL context switch +\n"
                f"--            collection allocation → 분 단위 지연. 동일 첫 token 추출을 inline\n"
                f"--            native scalar 로 구현: TRIM(SUBSTR(s, 1, NVL(NULLIF(INSTR(s, ','), 0) - 1, LENGTH(s))))\n"
                f"--      hook: sp-no-fake-data-extraction §1.3 #15\n"
                f"--\n"
                f"--   3) UNION ALL 끝 ORDER BY A.col → ORDER BY col (alias 제거)\n"
                f"--      사유: MSSQL UNION ALL 끝 ORDER BY A.YYYYMM 등 alias 참조 허용. Oracle\n"
                f"--            UNION ALL 의 ORDER BY 는 컬럼명/position 만 허용 (table alias 불가)\n"
                f"--            → ORA-00904 → 기존 EXCEPTION 핸들러 silent SELECT NULL DUMMY 로\n"
                f"--            fallback → BE 가 빈 cursor 받아 \"데이터 없음\" 표시.\n"
                f"--            ORDER BY 의 'A.' prefix 제거.\n"
                f"--      hook: sp-no-fake-data-extraction §1.3 #18\n"
                f"--\n"
                f"--   4) INSERT /*+ APPEND */ + SELECT /*+ LEADING(A) USE_HASH(I)(SC)(B)(C)(TEAM)\n"
                f"--                               DYNAMIC_SAMPLING(A 10) */ 힌트 추가\n"
                f"--      사유: GT_DMF0043_PLAN_REPORT_C (GTT) 통계 부재로 CBO CARDINALITY=1 추정\n"
                f"--            → NESTED LOOPS 5단계 × 36K rows × 2ms db file sequential read ≈ 분 단위\n"
                f"--            → HASH JOIN 강제 + DYNAMIC_SAMPLING 으로 실 통계 수집 유도\n"
                f"--\n"
                f"--   5) DTL INNER JOIN 의 PRODUCT_GROUP 매칭 조건 제거 (Option B)\n"
                f"--      사유: 사내 SITE_ITEM 의 PG 하드코딩 'N' 이라 cloud import 데이터 (원통형/\n"
                f"--            파우치형/각형/초소형/버튼) 와 JOIN 매치 0. PG 조건 제거하여 cloud\n"
                f"--            data 모두 활용 (사용자 결정 2026-06-11). PG 컬럼은 SITE_ITEM 의 'N'\n"
                f"--            label 그대로 표시 (사내 schema 에서 어차피 dropped column)\n"
                f"--\n"
                f"-- 추가 동봉 — 사내 인덱스 (이미 사내 적용 — 클라우드 측 미존재 시 등록 권장):\n"
                f"--   - IDX01_DM_MST_CONTRIBUTE_RATIO_DTL (VER_SEQ + 6 join keys + YYYYMM) COMPRESS 4\n"
                f"--   - IDX_DM_PLN_SALES_PLAN_REPORT_C_VMD (VERSION_NO, MEASURE, DIVISION_ID, YYYYMMDD)\n"
                f"--   - FBI_SCM_MST_SITE_ITEM_OWNER_TOKEN1 (REGEXP_SUBSTR(OWNER, '[^,]+', 1, 1))\n"
                f"--\n"
                f"-- ========================================================================\n"
                f"-- 실행 방법:\n"
                f"--   1) 본 파일 그대로 실행 (CREATE OR REPLACE)\n"
                f"--   2) STATUS=VALID 확인\n"
                f"--   3) 실 데이터 검증 (DMF0043_01 진입 → R_S_20260128_V002_C / Year 2024 → 데이터 표시)\n"
                f"-- ========================================================================\n\n"
                f"CREATE OR REPLACE "
            )
            (DMF0043_SP / "050_DMF0043_GET_CONTRIBUTION_SALES_LIST_Body.sql").write_text(
                header + body + "\n", encoding="utf-8"
            )
            print(f"[OK] 050_DMF0043_GET_CONTRIBUTION_SALES_LIST_Body.sql ({len(body)} chars)")

        # DMF0043_01 README
        dmf0043_readme = ROOT / "DMF0043" / "_README_2026-06-11_DMF0043_01_DEPLOY.md"
        dmf0043_readme.write_text(
            f"""# DMF0043_01 (ContributeView) 보완 클라우드 적용 패키지 — 2026-06-11

> DMF0043 의 1번째 sub-screen (Contribute View — 기여매출 목록 조회). 메인 화면 DMF0043 와 별개.

## 사고 + Fix 요약

| # | 사고 | Root cause | Fix |
|---|---|---|---|
| 1 | 조회 시 "데이터 없음" 표시 (silent) | EXCEPTION 핸들러가 v_sql_text 의 ORA-00904 를 catch 후 빈 cursor (`SELECT NULL AS DUMMY FROM DUAL WHERE 1=0`) 로 fallback → BE 가 정상 응답으로 인식 | EXCEPTION 핸들러 silent fail 대신 _DEBUG_VSQL 진단 테이블 사용 + ORDER BY A. 패턴 정정 |
| 2 | ORDER BY A.YYYYMM, ..., A.DM_BIZ_TYPE → ORA-00904 | Oracle UNION ALL 의 끝 ORDER BY 는 table alias 불가 (MSSQL 에서는 허용) | v_orderby 구성에서 'A.' prefix 제거 |
| 3 | 조회 5+ 분 hang | UF_FX_STRING_SPLIT (PIPELINED PL/SQL) 가 36K plan row × row 마다 context switch + collection allocation. CARDINALITY=1 (GTT 통계 부재) 로 NESTED LOOPS 5단계 | inline TRIM(SUBSTR(I.OWNER, 1, NVL(NULLIF(INSTR(I.OWNER, ','), 0) - 1, LENGTH(I.OWNER)))) + LEADING/USE_HASH/DYNAMIC_SAMPLING 힌트 |
| 4 | SAVE 후 cell NULL 표시 | SITE_ITEM 의 PG = '' (사내 schema dropped column 회피) vs RATIO 의 PG 실값 → LEFT JOIN 0 match | PRODUCT_GROUP 하드코딩 '' → 'N' (FE save default 와 align). 추가 cloud data 활용 위해 INNER JOIN 의 PG 조건 제거 |

## 배포 파일

| 파일 | 내용 |
|---|---|
| `01_SP_BODY/050_DMF0043_GET_CONTRIBUTION_SALES_LIST_Body.sql` | SP body (5축 fix 통합본) |

## 적용 순서

1. 백업: `SELECT DBMS_METADATA.GET_DDL('PROCEDURE','DMF0043_GET_CONTRIBUTION_SALES_LIST') FROM DUAL;`
2. 본 파일 실행 (CREATE OR REPLACE)
3. STATUS=VALID 확인
4. 실 데이터 검증 — DMF0043_01 진입 → Year=2024 + Version popup 의 Period 시작 2026-01-01 이전 → R_S_20260128_V002_C 선택 → 조회 → 데이터 표시 + 빠른 응답

## 합격 기준

| 항목 | 기준 |
|---|---|
| STATUS | VALID |
| 응답 시간 | 수십 초 이내 (이전 5+ 분 → HASH JOIN + DYNAMIC_SAMPLING) |
| Row 수 | 조회 row 수 > 0 (cloud 데이터 활용으로 풍부) |

## 추가 동봉 (필요 시) — 사내 적용된 인덱스

본 SP 의 성능 fix 와 별개로 사내 Oracle 측에 다음 3 인덱스 적용:

| 인덱스 | 컬럼 | 효과 |
|---|---|---|
| IDX01_DM_MST_CONTRIBUTE_RATIO_DTL | VER_SEQ + 6 join keys + YYYYMM (COMPRESS 4) | DTL JOIN 의 INDEX RANGE SCAN |
| IDX_DM_PLN_SALES_PLAN_REPORT_C_VMD | VERSION_NO, MEASURE, DIVISION_ID, YYYYMMDD | PK 16-col 우회 |
| FBI_SCM_MST_SITE_ITEM_OWNER_TOKEN1 | REGEXP_SUBSTR(OWNER, '[^,]+', 1, 1) | (이 SP 에서는 직접 안 씀 — 다른 SP 호환) |

> 클라우드 측 동일 인덱스 부재 시 추가 등록 권장. 본 패키지에 별도 SQL 미포함 — DBA 결정 사항.

## 룰 보강

- `Doc/_rules_v2/hooks/sp-no-fake-data-extraction.md` — DUMMY cursor / NVL NULL / bare != 'Y' / ORDER BY A. / UF_FX_STRING_SPLIT / SUBSTR pos=0 등 18 패턴 절대 금지
- 메모리 `feedback_sp_no_fake_extraction.md` / `feedback_dropped_column_get_save_alignment.md`

## 변경 이력

| 일자 | 변경 |
|---|---|
| 2026-06-11 | **본 패키지 초기 작성** (DMF0043_01 silent 0 rows + 속도 사고 종합 fix) |
""",
            encoding="utf-8",
        )
        print(f"[OK] {dmf0043_readme.name}")
        return 0
    finally:
        conn.close()


if __name__ == "__main__":
    import sys
    sys.exit(main())
