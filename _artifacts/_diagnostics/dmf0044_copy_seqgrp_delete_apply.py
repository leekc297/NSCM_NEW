#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0044_copy_seqgrp_delete_apply.py — COPY(실적 포함) PK 충돌 + DELETE ETC 고아행 정정 (2026-08-10)

사용자 지시: *"copy 실적 포함 미해결분, delete 도 해결해주세요."*

────────────────────────────────────────────────────────────────────────────
## 결함 ① COPY(실적 포함) — ORA-00001 PK_DM_PLN_SALES_ETC_REPORT_C (L9055)

PK = (VERSION_NO, DIVISION_ID, **DATA_SEQ**, MEASURE, YYYYMMDD)

L9086~9091 이 DATA_SEQ 를 **재채번**한다:

    DENSE_RANK() OVER (ORDER BY <속성 33컬럼>) AS DATA_SEQ

두 원천을 UNION ALL 로 합치기 때문(계획구간 = P_VERSION_NO / 실적구간 = 룩업 `DM_SR_ETC_VERSION`
지정 버전)에 **같은 엔티티를 한 SEQ 로 병합**하려는 의도다. 그런데 재채번 키에 **원본 DATA_SEQ 가 없다.**

### 실측 확증 (읽기 전용, division 40)
- 계획 `R_S_20260128_V002_C`(YYYYMMDD > 20260810) + 실적 `R_S_20250417_V001`(<= 20260810) = **9,418행**
- 재채번 후 (DATA_SEQ, MEASURE, YYYYMMDD) **중복 4건**
- 중복 8행의 정체: **전부 실적 원천 한 버전 안**의 `DATA_SEQ 94` vs `207`.
  33개 속성이 **완전히 동일**하고 **QTY 만 다르다**(예 SalesAmt_KRW 69,402,760 vs 403,987,362).
  ⇒ 재채번이 두 행을 한 SEQ 로 뭉개 PK 가 깨진다.

### 정정 — 병합 의도는 유지하면서 유일성 확보
각 원천 브랜치에서 **버전 내부 한정** 순번을 만든다:

    DENSE_RANK() OVER (PARTITION BY <속성 33컬럼> ORDER BY DATA_SEQ) AS SEQ_GRP

그리고 바깥 재채번 키 끝에 `SEQ_GRP` 를 붙인다.
- 속성이 유일한 행 → 양 브랜치 모두 `SEQ_GRP=1` ⇒ **기존과 동일하게 교차버전 병합** ✅
- 한 버전 안에서 속성이 겹치는 행 → 1/2 로 갈라져 **각자 SEQ** ⇒ PK 충돌 소멸 ✅

⚠ AS-IS(MSSQL) 원본 SP 텍스트는 저장소에 없다(`_artifacts` 전수 확인). 위 처방은
   **Oracle 측 데이터 의미**로 판정한 것이며, 유일 행의 산출물은 기존과 100% 동일하다
   (달라지는 건 지금은 아예 실패하는 모호 행뿐).

────────────────────────────────────────────────────────────────────────────
## 결함 ② DELETE — `DM_PLN_SALES_ETC_REPORT_C` 고아행

L7316 `IF p_action_type = 'D'` 블록이 지우는 대상은 3표뿐이다:
`DM_PLN_SALES_PLAN_REPORT_C` / `DM_PLN_BP_FCST_REPORT_C` / `DM_PLN_SALES_REPORT_EXCHANGE_C`.
**`DM_PLN_SALES_ETC_REPORT_C` 가 빠져 있다**(기타매출 테이블 분리 [PJ2024-50611] 이후 누락).

실측(2026-08-10): DELETE 실행 후 PLAN 0 / EXCHANGE 0 인데 **ETC 10,650행 잔존**.
버전은 SEND_YN='D' 로 논리삭제되므로 이 행들은 영구 고아가 되고,
같은 VERSION_NO 가 재사용되면 PK 충돌 원인이 된다.

⇒ 동일 조건 DELETE 1줄 추가.

사용: python dmf0044_copy_seqgrp_delete_apply.py --dump / --patch / --deploy
"""
import argparse
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

ROOT = pathlib.Path(__file__).resolve().parents[2]
OUT = ROOT / "_artifacts" / "_apply_corporate"
BACKUP = OUT / "BACKUP_PKG_DMF0044_BODY_pre_seqgrp_20260810.sql"
PATCHED = OUT / "PKG_DMF0044_BODY_SEQGRP_20260810.sql"

GUARD_MARKS = {
    "AUTHUNION 2026-08-09": 1,
    "20260805 MERGE-ON 파리티 복원": 1,
    "PIVOTSEL 2026-08-10": 1,
    "PRODUCTDETAIL 2026-08-10": 2,
    "M.CALC_YN = '-'": 12,
    "RPTGRP-STUB 2026-08-10": 14,
    "NVL(d_Result_Date, '-')": 14,
}

TUPLE = ("DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, CUST_REPORT, SOLDTO_CODE, SOLDTO_CUST_REPORT"
         ", PRODUCT_DETAILS, CELL_MODEL_INFO, BIZ_TYPE, APPLICATION_GR, APPLICATION, COUNTRY_CODE"
         ", PRODUCT_GROUP, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE"
         ", INCOTERMS, PLANT_SITE_ID, CURRENCY, COMPANY_ID"
         ", ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7"
         ", ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10")

T8 = "\t" * 8
T7 = "\t" * 7
SEQ_GRP_LINE = (
    T8 + "-- SEQGRP 2026-08-10: 같은 버전 안에서 속성이 동일하고 원본 DATA_SEQ 만 다른 행을 구분한다.\n"
    + T8 + "--   (유일 행은 전부 1 이므로 교차버전 병합 동작은 그대로 유지된다)\n"
    + T8 + ", DENSE_RANK() OVER (PARTITION BY " + TUPLE + " ORDER BY DATA_SEQ) AS SEQ_GRP\n"
)

# ── hunk 1: 계획구간 브랜치 (P_VERSION_NO) ──────────────────────────────
H1_OLD = (T8 + ", DEPARTMENT_NAME, DEPT_NAME\n"
          + T7 + "FROM DM_PLN_SALES_ETC_REPORT_C A\n"
          + T7 + "WHERE A.DIVISION_ID = P_DIVISION_ID\n"
          + T8 + "AND A.VERSION_NO = P_VERSION_NO\n")
H1_NEW = (T8 + ", DEPARTMENT_NAME, DEPT_NAME\n" + SEQ_GRP_LINE
          + T7 + "FROM DM_PLN_SALES_ETC_REPORT_C A\n"
          + T7 + "WHERE A.DIVISION_ID = P_DIVISION_ID\n"
          + T8 + "AND A.VERSION_NO = P_VERSION_NO\n")

# ── hunk 2: 실적구간 브랜치 (V_MAX_ETC_RESULT_VERSION_NO) ───────────────
H2_OLD = (T8 + ", DEPARTMENT_NAME, DEPT_NAME\n"
          + T7 + "FROM DM_PLN_SALES_ETC_REPORT_C A\n"
          + T7 + "WHERE A.DIVISION_ID = P_DIVISION_ID\n"
          + T8 + "AND A.VERSION_NO = V_MAX_ETC_RESULT_VERSION_NO\n")
H2_NEW = (T8 + ", DEPARTMENT_NAME, DEPT_NAME\n" + SEQ_GRP_LINE
          + T7 + "FROM DM_PLN_SALES_ETC_REPORT_C A\n"
          + T7 + "WHERE A.DIVISION_ID = P_DIVISION_ID\n"
          + T8 + "AND A.VERSION_NO = V_MAX_ETC_RESULT_VERSION_NO\n")

# ── hunk 3: 바깥 재채번 키에 SEQ_GRP 추가 (") AS DATA_SEQ" 는 본문에 1회) ──
H3_OLD = "\t" * 10 + " ) AS DATA_SEQ\n"
H3_NEW = ("\t" * 9 + ", SEQ_GRP  -- SEQGRP 2026-08-10\n" + "\t" * 10 + " ) AS DATA_SEQ\n")

# ── hunk 4: DELETE 분기에 ETC 테이블 추가 ──────────────────────────────
T3 = "\t" * 3
H4_OLD = (T3 + "DELETE FROM DM_PLN_SALES_REPORT_EXCHANGE_C WHERE DIVISION_ID = p_division_id"
          " AND VERSION_NO = p_version_no;\n")
H4_NEW = (T3 + "DELETE FROM DM_PLN_SALES_REPORT_EXCHANGE_C WHERE DIVISION_ID = p_division_id"
          " AND VERSION_NO = p_version_no;\n"
          + T3 + "-- ETCDEL 2026-08-10: 기타매출 테이블([PJ2024-50611] 분리) 누락분 — 고아행 방지\n"
          + T3 + "DELETE FROM DM_PLN_SALES_ETC_REPORT_C WHERE DIVISION_ID = p_division_id"
          " AND VERSION_NO = p_version_no;\n")

HUNKS = [("계획구간 SEQ_GRP", H1_OLD, H1_NEW, 1),
         ("실적구간 SEQ_GRP", H2_OLD, H2_NEW, 1),
         ("재채번 키 + SEQ_GRP", H3_OLD, H3_NEW, 1),
         ("DELETE ETC 추가", H4_OLD, H4_NEW, 1)]

NEW_MARKS = {"SEQGRP 2026-08-10": 3, "ETCDEL 2026-08-10": 1}


def live_body():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044'
                        AND TYPE='PACKAGE BODY' ORDER BY LINE""")
        rows = cur.fetchall()
    if not rows:
        sys.exit("[error] PACKAGE BODY 없음")
    return "CREATE OR REPLACE " + "".join(r[0] for r in rows).lstrip()


def cmd_dump():
    OUT.mkdir(parents=True, exist_ok=True)
    body = live_body()
    BACKUP.write_text(body, encoding="utf-8")
    print("[dump] %s (%d 행)" % (BACKUP, len(body.splitlines())))
    for name, old, _new, n in HUNKS:
        got = body.count(old)
        print("  hunk '%s' 앵커 %d (기대 %d)%s" % (name, got, n, "" if got == n else "  ⚠"))
    for m, n in GUARD_MARKS.items():
        got = body.count(m)
        print("  선행 마커 '%s' = %d (기대 %d)%s" % (m, got, n, "" if got == n else "  ⚠"))
    return 0


def cmd_patch():
    if not BACKUP.is_file():
        sys.exit("[error] 백업 부재 — --dump 선행")
    text = BACKUP.read_text(encoding="utf-8")
    base_lines = len(text.splitlines())
    if "SEQGRP 2026-08-10" in text and "ETCDEL 2026-08-10" in text:
        print("  이미 적용됨 — skip(멱등)")
    else:
        for name, old, new, n in HUNKS:
            got = text.count(old)
            if got != n:
                sys.exit("[error] hunk '%s' 앵커 %d건 (기대 %d) — 손대지 않음" % (name, got, n))
            text = text.replace(old, new)
            print("  hunk '%s' 적용" % name)
    for m, n in NEW_MARKS.items():
        if text.count(m) != n:
            sys.exit("[error] 신규 마커 '%s' = %d (기대 %d) — 중단" % (m, text.count(m), n))
    for m, n in GUARD_MARKS.items():
        if text.count(m) != n:
            sys.exit("[error] 선행 마커 '%s' 소실 (%d≠%d) — 중단" % (m, text.count(m), n))
    added = len(text.splitlines()) - base_lines
    if added != 9:  # SEQ_GRP 주석2+본문1 ×2브랜치 = 6, 재채번 키 1, DELETE 주석1+본문1 = 2
        sys.exit("[error] 추가 행수 %d (기대 9) — 중단" % added)
    PATCHED.write_text(text, encoding="utf-8")
    print("[patch] %s (%d행, +%d)" % (PATCHED, len(text.splitlines()), added))
    print("  신규 마커 SEQGRP×3 / ETCDEL×1 ✅ / 선행 마커 7종 유지 ✅ / 추가 9행 ✅")
    return 0


def cmd_deploy():
    import oracledb

    if not PATCHED.is_file():
        sys.exit("[error] 배포본 부재 — --patch 선행")
    sql = PATCHED.read_text(encoding="utf-8").rstrip().rstrip("/").rstrip()
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 60")
        cur.execute(sql)
        cur.execute("""SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS
                        WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0044' ORDER BY 1""")
        for r in cur.fetchall():
            print("  %-14s %s" % (r[0], r[1]))
        cur.execute("""SELECT LINE, POSITION, TEXT FROM ALL_ERRORS
                        WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' ORDER BY SEQUENCE""")
        errs = cur.fetchall()
        for e in errs:
            print("  ⛔ L%s:%s %s" % (e[0], e[1], e[2]))
        for m, n in list(NEW_MARKS.items()):
            cur.execute("""SELECT NVL(SUM(REGEXP_COUNT(TEXT, :m)),0) FROM ALL_SOURCE
                            WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'""",
                        {"m": m})
            got = cur.fetchone()[0]
            print("  마커 '%s' = %d (기대 %d)%s" % (m, got, n, "" if got == n else "  ⛔"))
    return 1 if errs else 0


def main():
    ap = argparse.ArgumentParser()
    for f in ("dump", "patch", "deploy"):
        ap.add_argument("--" + f, action="store_true")
    a = ap.parse_args()
    if a.dump:
        sys.exit(cmd_dump())
    if a.patch:
        sys.exit(cmd_patch())
    if a.deploy:
        sys.exit(cmd_deploy())
    ap.error("--dump / --patch / --deploy 중 하나 필요")


if __name__ == "__main__":
    main()
