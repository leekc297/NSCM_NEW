#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0044_etc_read_plan_apply.py — ETC 조회 원천을 저장 대상표로 통일 (2026-08-11)

## 요구사항 (사용자 확정)
"ETC 에서 수정/저장했으면 ETC 에서 조회되어야 한다" / "AS-IS 와 동일한 TABLE 에 저장하고 조회되도록".

## 실측 근거
- ETC **저장** = `P_DMF0044_SAVE_SALES_PLAN_REPORT_C` → `DM_PLN_SALES_PLAN_REPORT_C` MERGE
  (AS-IS `.cs:656` 동일 / AS-IS SP L152889 동일. **`ETC_REPORT_C` 쓰기 DML 은 AS-IS 전체 0건**)
- ETC **조회** = `DM_PLN_SALES_ETC_REPORT_C` (AS-IS L146491 동일)
  ⇒ 읽는 표 ≠ 쓰는 표 라서 저장값이 화면에 영원히 안 보인다(AS-IS 도 동일 증상).
- 저장은 정상 동작 확인: payload 8건 ↔ 원장 8행 1:1 (DATA_TYPE='2').

## 조치
ETC 분기(`IF P_DATA_TYPE <> '1'`)의 원천을 **저장 대상표로 통일**한다.
    FROM DM_PLN_SALES_ETC_REPORT_C R  →  FROM DM_PLN_SALES_PLAN_REPORT_C R
    WHERE ... 에 AND R.DATA_TYPE = '2' 추가
`DATA_TYPE='2'` 필터는 AS-IS 에 없는 구문이지만, AS-IS 는 ETC 전용 표를 읽어 필터가 불필요했던 것이다.
원천을 공용표로 바꾼 이상 **동등성 유지를 위해 필수**(없으면 Cutoff 행이 ETC 화면에 섞인다).

### Cutoff 분기는 손대지 않는다 (사용자 지시)
AS-IS Cutoff 분기 WHERE (L146394~146397) 에 `DATA_TYPE` 필터가 **없음**을 원문으로 확인 —
프로시저 전체에서 DATA_TYPE 은 EDIT_FLAG 판정(L146348) 에만 쓰인다. 따라서 추가하지 않는다.

### 컬럼 재매핑 — Cutoff 분기(같은 표를 읽는 검증된 식)를 이식
`ETC_REPORT_C` 에만 있던 컬럼은 PLAN 기준 식으로 바꾼다. 전부 Cutoff 분기 L1358~1400 원문과 동일:
    END_CUSTOMER    R.END_CUSTOMER            → CASE(81%+REPORT_BP) / NVL(ST.END_CUSTOMER,'')
    BIZ_TYPE_NAME40 R.BIZ_TYPE                → NVL 계열 R.FORECAST_INFO_BIZ_TYPE / SINGLE.…
    CELL_MODEL_INFO R.CELL_MODEL_INFO         → R.FORECAST_INFO_CELL_MODEL
    COUNTRY_CODE    R.COUNTRY_CODE            → ST.COUNTRY
    SOLDTO_CODE     R.SOLDTO_CODE             → CS.SOLDTO_CODE
    SOLDTO/SHIPTO_COUNTRY R.…                 → SUBSTR(CS.SOLDTO_CODE/SHIPTO_CODE,1,2)
    ITEM_USE        R.ITEM_USE                → CASE(LK3.SEGMENT2) / SUBSTR(PROJECT_CODE,1,1)
    PROJECT_NAME    NVL(LK3.SEGMENT3, PJT.…)  → PJT.PROJECT_NAME  (LK3 의미가 바뀌므로)
    CELL_PROD_SITE  '' 고정                    → NVL(LK4.ATTRIBUTE1,'')  (PLAN 에 실컬럼 존재)
    LK3 조인        DM_ETC_PROJECT(SEGMENT2)  → DM_ITEM_USE_EX(SEGMENT1)  ← Cutoff 와 통일
    LK4 조인        없음                       → 신설 (SP_CELL_PROD_SITE)
`R.ATTRIBUTE3` / `R.PRODUCT_DETAILS` / `R.APPLICATION` / `R.APPLICATION_GR` / `R.CUST_GROUP_DTL`
은 양쪽 표에 모두 존재하므로 그대로 둔다.
GROUP BY 는 바뀐 SELECT 식과 1:1로 맞춘다(Oracle 문법상 필수).

사용: python dmf0044_etc_read_plan_apply.py --dump / --patch / --deploy
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
BACKUP = OUT / "BACKUP_PKG_DMF0044_BODY_pre_etcread_20260811.sql"
PATCHED = OUT / "PKG_DMF0044_BODY_ETCREAD_20260811.sql"
MARK = "ETCREAD 2026-08-11"

SLICE_START = "    IF P_DATA_TYPE <> '1' THEN\n"
SLICE_END = "\n    END IF;\n"

# (old, new, 설명) — 전부 ETC 분기 슬라이스 안에서 정확히 1회여야 한다
EDITS = [
    # ── SELECT 목록 ────────────────────────────────────────────────────────
    (", NVL(R.END_CUSTOMER, '') AS END_CUSTOMER",
     ", CASE WHEN R.DIVISION_ID LIKE '81%' AND R.CUTOFF_TYPE LIKE 'REPORT_BP%' THEN R.END_CUST_REPORT\n"
     "                   ELSE NVL(ST.END_CUSTOMER, '') END AS END_CUSTOMER"
     "  /* ETCREAD 2026-08-11: PLAN 표엔 END_CUSTOMER 없음 — Cutoff 분기 식 이식 */",
     "END_CUSTOMER"),

    (", R.BIZ_TYPE AS BIZ_TYPE,",
     ", CASE WHEN R.FORECAST_INFO_BIZ_TYPE IS NOT NULL THEN R.FORECAST_INFO_BIZ_TYPE\n"
     "                   ELSE SINGLE.FORECAST_INFO_BIZ_TYPE END AS BIZ_TYPE_NAME40,"
     "  /* ETCREAD: 구 BIZ_TYPE(ETC 전용 컬럼) → PLAN 의 FORECAST_INFO_BIZ_TYPE */",
     "BIZ_TYPE → BIZ_TYPE_NAME40"),

    ("NVL(R.CELL_MODEL_INFO, '') AS CELL_MODEL_INFO",
     "NVL(R.FORECAST_INFO_CELL_MODEL, '') AS CELL_MODEL_INFO  /* ETCREAD */",
     "CELL_MODEL_INFO"),

    ("DISPLAY_SEQ2, R.COUNTRY_CODE, R.SOLDTO_CODE",
     "DISPLAY_SEQ2, ST.COUNTRY, CS.SOLDTO_CODE  /* ETCREAD: PLAN 표엔 없음 → 조인에서 */",
     "COUNTRY_CODE / SOLDTO_CODE"),

    ("NVL(LK3.SEGMENT3, PJT.PROJECT_NAME) AS PROJECT_NAME",
     "PJT.PROJECT_NAME AS PROJECT_NAME  /* ETCREAD: LK3 룩업이 DM_ITEM_USE_EX 로 바뀌어 SEGMENT3 무의미 */",
     "PROJECT_NAME"),

    (", NVL(R.SOLDTO_COUNTRY, '') AS SOLDTOCOUNTRY, NVL(R.SHIPTO_COUNTRY, '') AS SHIPTOCOUNTRY",
     ", NVL(SUBSTR(CS.SOLDTO_CODE, 1, 2), '') AS SOLDTOCOUNTRY\n"
     "            , NVL(SUBSTR(CS.SHIPTO_CODE, 1, 2), '') AS SHIPTOCOUNTRY  /* ETCREAD */",
     "SOLDTO/SHIPTO_COUNTRY"),

    (", NVL(R.ITEM_USE, '') AS ITEM_USE",
     ", CASE WHEN LK3.SEGMENT1 IS NOT NULL THEN LK3.SEGMENT2\n"
     "                   ELSE NVL(SUBSTR(R.PROJECT_CODE, 1, 1), '') END AS ITEM_USE  /* ETCREAD */",
     "ITEM_USE"),

    (", '' AS CELL_PROD_SITE",
     ", NVL(LK4.ATTRIBUTE1, '') AS CELL_PROD_SITE  /* ETCREAD: PLAN 에 실컬럼 존재 — Cutoff 식 이식 */",
     "CELL_PROD_SITE"),

    # ── FROM / JOIN ───────────────────────────────────────────────────────
    ("        FROM DM_PLN_SALES_ETC_REPORT_C R\n",
     "        -- ETCREAD 2026-08-11: 저장 대상표와 통일 (저장=SAVE_SALES_PLAN_REPORT_C → PLAN_REPORT_C).\n"
     "        --   기존엔 ETC_REPORT_C 를 읽어 저장값이 화면에 반영되지 않았다(AS-IS 도 동일 증상).\n"
     "        FROM DM_PLN_SALES_PLAN_REPORT_C R\n",
     "FROM 원천 교체"),

    ("        LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK3 ON R.PROJECT_CODE = LK3.SEGMENT2"
     " AND LK3.LOOKUP_TYPE = 'DM_ETC_PROJECT' AND LK3.SEGMENT1 = R.DIVISION_ID\n",
     "        -- ETCREAD 2026-08-11: 원천이 PLAN 이므로 LK3 를 Cutoff 분기와 동일 룩업으로 통일\n"
     "        LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK3 ON R.PROJECT_CODE = LK3.SEGMENT1"
     " AND LK3.LOOKUP_TYPE = 'DM_ITEM_USE_EX'\n"
     "        LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK4 ON R.CELL_PROD_SITE = LK4.SEGMENT1"
     " AND LK4.LOOKUP_TYPE = 'SP_CELL_PROD_SITE'  /* ETCREAD: 신설 */\n",
     "LK3 룩업 교체 + LK4 신설"),

    # ── WHERE ─────────────────────────────────────────────────────────────
    ("            AND R.VERSION_NO = P_SP_VERSION_NO\n        GROUP BY\n",
     "            AND R.VERSION_NO = P_SP_VERSION_NO\n"
     "            -- ETCREAD 2026-08-11: 공용표로 바뀌었으므로 ETC(DATA_TYPE='2') 만 취한다.\n"
     "            --   AS-IS 는 ETC 전용 표를 읽어 이 필터가 불필요했다(동등성 유지 목적).\n"
     "            AND R.DATA_TYPE = '2'\n        GROUP BY\n",
     "WHERE DATA_TYPE='2'"),

    # ── GROUP BY (SELECT 식과 1:1) ────────────────────────────────────────
    ("            , R.BIZ_TYPE, R.APPLICATION_GR, R.PRODUCT_DETAILS\n",
     "            , CASE WHEN R.FORECAST_INFO_BIZ_TYPE IS NOT NULL THEN R.FORECAST_INFO_BIZ_TYPE\n"
     "                   ELSE SINGLE.FORECAST_INFO_BIZ_TYPE END\n"
     "            , R.APPLICATION_GR, R.PRODUCT_DETAILS\n",
     "GROUP BY BIZ_TYPE"),

    ("            , R.CELL_MODEL_INFO ",
     "            , R.FORECAST_INFO_CELL_MODEL ",
     "GROUP BY CELL_MODEL_INFO"),

    ("            , LK2.DISPLAY_SEQ, R.COUNTRY_CODE, R.SOLDTO_CODE, NVL(LK3.SEGMENT3, PJT.PROJECT_NAME)\n",
     "            , LK2.DISPLAY_SEQ, ST.COUNTRY, CS.SOLDTO_CODE, PJT.PROJECT_NAME\n",
     "GROUP BY COUNTRY/SOLDTO/PROJECT_NAME"),

    ("            , R.END_CUSTOMER\n",
     "            , CASE WHEN R.DIVISION_ID LIKE '81%' AND R.CUTOFF_TYPE LIKE 'REPORT_BP%' THEN R.END_CUST_REPORT\n"
     "                   ELSE NVL(ST.END_CUSTOMER, '') END\n",
     "GROUP BY END_CUSTOMER"),

    ("            , R.SOLDTO_COUNTRY, R.SHIPTO_COUNTRY\n",
     "            , SUBSTR(CS.SOLDTO_CODE, 1, 2), SUBSTR(CS.SHIPTO_CODE, 1, 2)\n",
     "GROUP BY SOLDTO/SHIPTO_COUNTRY"),

    ("            , SI.ATTRIBUTE9, R.ITEM_USE\n",
     "            , SI.ATTRIBUTE9\n"
     "            , CASE WHEN LK3.SEGMENT1 IS NOT NULL THEN LK3.SEGMENT2\n"
     "                   ELSE NVL(SUBSTR(R.PROJECT_CODE, 1, 1), '') END\n",
     "GROUP BY ITEM_USE"),

    ("            , LU.ATTRIBUTE4    -- LOOKUP 26.03.20\n        ;\n",
     "            , LU.ATTRIBUTE4    -- LOOKUP 26.03.20\n"
     "            , LK4.ATTRIBUTE1   -- ETCREAD 2026-08-11 (CELL_PROD_SITE 식 대응)\n        ;\n",
     "GROUP BY LK4"),
]


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


def etc_slice(text):
    i = text.index(SLICE_START)
    j = text.index(SLICE_END, i)
    return i, j + len(SLICE_END)


def cmd_dump():
    OUT.mkdir(parents=True, exist_ok=True)
    body = live_body()
    BACKUP.write_text(body, encoding="utf-8")
    print("[dump] %s (%d 행)" % (BACKUP, len(body.splitlines())))
    if MARK in body:
        print("  ⛔ 마커 이미 존재"); return 1
    a, b = etc_slice(body)
    sl = body[a:b]
    print("  ETC 분기 슬라이스: %d bytes / %d 행" % (len(sl), sl.count("\n")))
    bad = 0
    for old, _new, desc in EDITS:
        n = sl.count(old)
        ok = n == 1
        bad += 0 if ok else 1
        print("  %-34s 슬라이스 내 %d회 (기대 1)%s" % (desc, n, "" if ok else "  ⛔"))
    print("  → 불일치 %d건 %s" % (bad, "✅" if bad == 0 else "⛔ 패치 금지"))
    return 1 if bad else 0


def cmd_patch():
    if not BACKUP.is_file():
        sys.exit("[error] 백업 부재 — --dump 선행")
    orig = BACKUP.read_text(encoding="utf-8")
    a, b = etc_slice(orig)
    head, sl, tail = orig[:a], orig[a:b], orig[b:]

    new_sl = sl
    for old, new, desc in EDITS:
        n = new_sl.count(old)
        if n != 1:
            sys.exit("[error] %s — 슬라이스 내 %d회 (기대 1). 중단" % (desc, n))
        new_sl = new_sl.replace(old, new, 1)
        print("  적용 %s" % desc)

    text = head + new_sl + tail

    # 무결성 1 — ETC 분기 밖은 바이트 동일
    a2, b2 = etc_slice(text)
    if text[:a2] != head or text[b2:] != tail:
        sys.exit("[error] ETC 분기 밖이 변경됨 — 중단")
    print("  ✅ ETC 분기 밖 바이트 동일 — 부수 변경 0")

    # 무결성 2 — 카운트 검사
    # ⚠ 전체 본문 기준으로 세면 안 된다 — ETC_REPORT_C 는 MOBILE_REPORT_CREATE 등
    #   다른 프로시저가 정당하게 쓴다(전체 12회). 원천 관련 검사는 **ETC 분기 슬라이스 한정**.
    a4, b4 = etc_slice(text)
    s4 = text[a4:b4]
    for s, exp, desc in [
        ("FROM DM_PLN_SALES_ETC_REPORT_C", 0, "구 원천 잔존(ETC 분기)"),
        ("FROM DM_PLN_SALES_PLAN_REPORT_C R", 1, "신 원천(ETC 분기)"),
        ("AND R.DATA_TYPE = '2'", 1, "DATA_TYPE 필터(ETC 분기)"),
        ("'DM_ETC_PROJECT'", 0, "구 LK3 룩업 잔존(ETC 분기)"),
        ("LK4.LOOKUP_TYPE = 'SP_CELL_PROD_SITE'", 1, "LK4 조인(ETC 분기)"),
    ]:
        got = s4.count(s)
        if got != exp:
            sys.exit("[error] %s = %d (기대 %d) — 중단" % (desc, got, exp))
        print("  ✅ %-26s %d" % (desc, got))

    checks = [
        ("FROM DM_PLN_SALES_PLAN_REPORT_C R", 2, "PLAN 원천 전체(Cutoff+ETC)"),
        ("TUNE-V 2026-08-10", 2, "선행 TUNE-V"),
        ("TUNE-J 2026-08-10", 9, "선행 TUNE-J"),
        ("TUNE-S 2026-08-10", 1, "선행 TUNE-S"),
    ]
    for s, exp, desc in checks:
        got = text.count(s)
        if got != exp:
            sys.exit("[error] %s = %d (기대 %d) — 중단" % (desc, got, exp))
        print("  ✅ %-26s %d" % (desc, got))

    # 무결성 3 — ETC 분기에 ETC 전용 컬럼 참조가 남아있지 않은가
    a3, b3 = etc_slice(text)
    s3 = text[a3:b3]
    import re as _re
    # ⚠ 단순 in 검사는 R.BIZ_TYPE 가 R.BIZ_TYPE_NAME40 등 더 긴 이름에 걸린다 → 단어 경계 사용
    for col in ("END_CUSTOMER", "CELL_MODEL_INFO", "BIZ_TYPE", "COUNTRY_CODE",
                "SOLDTO_CODE", "SOLDTO_COUNTRY", "SHIPTO_COUNTRY", "ITEM_USE"):
        pat = _re.compile(r'\bR\.' + col + r'\b')
        hits = [m for m in pat.finditer(s3)]
        if hits:
            for m in hits[:3]:
                ctx = s3[max(0, m.start() - 90):m.start() + 60].replace("\n", " ⏎ ")
                print("    잔존 문맥: ...%s..." % ctx)
            sys.exit("[error] ETC 분기에 PLAN 표에 없는 컬럼 참조 잔존: R.%s (%d건) — 중단"
                     % (col, len(hits)))
    print("  ✅ ETC 분기 내 PLAN 미존재 컬럼 참조 0건")

    PATCHED.write_text(text, encoding="utf-8")
    print("[patch] %s (%d행, 원본 %d행)" % (PATCHED, len(text.splitlines()), len(orig.splitlines())))
    return 0


def cmd_deploy():
    import oracledb

    if not PATCHED.is_file():
        sys.exit("[error] 배포본 부재 — --patch 선행")
    sql = PATCHED.read_text(encoding="utf-8").rstrip().rstrip("/").rstrip()
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 120")
        cur.execute(sql)
        cur.execute("""SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS
                        WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0044' ORDER BY 1""")
        for r in cur.fetchall():
            print("  %-14s %s" % r)
        cur.execute("""SELECT LINE, POSITION, TEXT FROM ALL_ERRORS
                        WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' ORDER BY SEQUENCE""")
        errs = cur.fetchall()
        for e in errs:
            print("  ⛔ L%s:%s %s" % e)
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
