#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
A6_scp0013_phaseA_meta_register.py
===============================================================================
SCP0013 (Production Plan Line) Phase A 사내 메타 등록 — 멱등(idempotent).

축 (선례: 56_sys0013_add_menu_dynamic_query.sql 4축 + DMF0003 BTN/API 관례):
  (1) SCM_ADM_MNU_M           : Supply(Lv1) / Supply_Plan(Lv2) / SCP0013(Lv3) — 트리 신설
                                (2026-07-13 실측: SCP/Supply 트리 전무. 관례값은 Demand 트리 실측 복사)
  (2) SCM_ADM_MSG_M           : MNU 키(Supply/Supply Plan 부재 시 MNU00003/MNU00013 + 신규 leaf 키)
                                + LBL00767~773(7) + MSG00673~674(2) + MSG_API 9키 — 각 3 lang
  (3) SCM_ADM_API_M           : SCP0013_Line_{9 BTN} → API_URL='SCP0013_GET_PRODUCTION_PLAN_LINEBY'
                                (⚠️ SP 는 현재 INVALID — A5 handoff. 버튼 표시용 배선은 무해)
  (4) SCM_ADM_MNU_BTN_MPG_M   : SHT_NM='Line' × 9 BTN (SEARCH/EXCEL/SORT/FILTER +
                                MEASURE_SELECT/NEW/FIX/UNFIX/LOAD_PERCENT)
  (5) USER_GR_MNU_MPG_M       : DMF0003 메뉴권한 보유 그룹 → SCP0013 복사
  (6) USER_GR_MNU_BTN_MPG_M   : 위 그룹 × 9 BTN 생성
  (미포함) SCM_ADM_PROC_M     : SP Oracle 변환 후 positional 확정 시 등록 (A5 handoff §4-5)
  (미포함) SHEET_COLUMNS/MEASURE: 기존 이관분 존재(Line 27행 / LINE 6행) — 무변경

전 INSERT: DDL NOT NULL 전수 검증(스크립트 선두 assert) + 감사컬럼 'admin' + NOT EXISTS 멱등.
실행: python A6_scp0013_phaseA_meta_register.py --apply   (없으면 dry-run)
"""
import sys

import oracledb

APPLY = "--apply" in sys.argv

SP_MAIN = "SCP0013_GET_PRODUCTION_PLAN_LINEBY"
BTNS = ["SEARCH", "EXCEL", "SORT", "FILTER", "MEASURE_SELECT", "NEW", "FIX", "UNFIX", "LOAD_PERCENT"]

# i18n 신규 (사내 MAX 실측 2026-07-13: LBL00766 / MSG00672 → 신규 채번. KO=EN 통일).
NEW_MSGS = [
    ("LBL00767", "LBL", "Nick Name"),
    ("LBL00768", "LBL", "Seq"),
    ("LBL00769", "LBL", "Line Assign"),
    ("LBL00770", "LBL", "NEW"),
    ("LBL00771", "LBL", "Fix"),
    ("LBL00772", "LBL", "Unfix"),
    ("LBL00773", "LBL", "Load%"),
    ("MSG00673", "MSG", "해당 기능은 후속 단계에서 적용 예정입니다."),
    ("MSG00674", "MSG", "조회는 SP 변환 적용 후 활성화됩니다."),
]


def connect():
    last = None
    for kw in (dict(service_name="OCGSCMD_P01"), dict(sid="ESSCMD")):
        try:
            dsn = oracledb.makedsn(host="121.162.245.167", port=2521, **kw)
            return oracledb.connect(user="SCM_MGR", password="!SCMroqkf2026", dsn=dsn)
        except Exception as e:
            last = e
    raise last


conn = connect()
cur = conn.cursor()


def notnull_cols(table):
    cur.execute(
        """SELECT COLUMN_NAME FROM USER_TAB_COLUMNS
            WHERE TABLE_NAME=:t AND NULLABLE='N' AND DATA_DEFAULT IS NULL""", t=table)
    return {r[0] for r in cur.fetchall()}


# ── 0. DDL NOT NULL 전수 검증 (anti-simplification §1.4) ─────────────────────
INSERT_COLS = {
    "SCM_ADM_MNU_M": {"MNU_ID", "UPPR_MNU_ID", "MNU_URL", "MNU_MSG_ID", "MNU_DESC",
                      "SORT_ORD", "MNU_LV_NO", "MNU_TP_CD", "UNIT_TP_CD", "USE_YN",
                      "CREATED_BY", "CREATION_DATE", "LAST_UPDATED_BY", "LAST_UPDATE_DATE"},
    "SCM_ADM_MSG_M": {"MSG_ID", "LANG_CD", "MSG_NM", "MSG_TP_CD", "USE_YN",
                      "CREATED_BY", "CREATION_DATE", "LAST_UPDATED_BY", "LAST_UPDATE_DATE"},
    "SCM_ADM_API_M": {"API_ID", "API_TP_CD", "API_MSG_ID", "API_URL", "USE_YN",
                      "CREATED_BY", "CREATION_DATE", "LAST_UPDATED_BY", "LAST_UPDATE_DATE"},
    "SCM_ADM_MNU_BTN_MPG_M": {"MNU_ID", "SHT_NM", "MNU_BTN_CD", "API_ID", "USE_YN",
                              "CREATED_BY", "CREATION_DATE", "LAST_UPDATED_BY", "LAST_UPDATE_DATE"},
    "SCM_ADM_USER_GR_MNU_MPG_M": {"USER_GR_ID", "MNU_ID", "USE_YN",
                                  "CREATED_BY", "CREATION_DATE", "LAST_UPDATED_BY", "LAST_UPDATE_DATE"},
    "SCM_ADM_USER_GR_MNU_BTN_MPG_M": {"USER_GR_ID", "MNU_ID", "SHT_NM", "MNU_BTN_CD", "USE_YN",
                                      "CREATED_BY", "CREATION_DATE", "LAST_UPDATED_BY", "LAST_UPDATE_DATE"},
}
print("== 0. DDL NOT NULL 검증 ==")
for tbl, cols in INSERT_COLS.items():
    nn = notnull_cols(tbl)
    missing = nn - cols
    print(f"  {tbl:32} NOT NULL={len(nn):2} / 누락={sorted(missing) if missing else '없음'}")
    assert not missing, f"{tbl}: INSERT 컬럼셋에 NOT NULL 누락 {missing}"

# ── 0b. 관례 실측 — Demand 트리 (Lv1/Lv2/leaf 의 TP/UNIT/LV 값 복사 기준) ────
print("\n== 0b. Demand 트리 관례 실측 ==")
cur.execute("""SELECT MNU_ID, UPPR_MNU_ID, MNU_URL, MNU_MSG_ID, SORT_ORD, MNU_LV_NO, MNU_TP_CD, UNIT_TP_CD
 FROM SCM_ADM_MNU_M WHERE MNU_ID IN ('Demand','Demand_Plan','DMF0048') ORDER BY MNU_LV_NO""")
ref = {r[0]: r for r in cur.fetchall()}
for k, v in ref.items():
    print("  ", v)
assert "Demand" in ref and "Demand_Plan" in ref and "DMF0048" in ref, "관례 기준 행 부재"
lv1_tp, lv1_unit = ref["Demand"][6], ref["Demand"][7]
lv2_tp, lv2_unit = ref["Demand_Plan"][6], ref["Demand_Plan"][7]
leaf_tp, leaf_unit = ref["DMF0048"][6], ref["DMF0048"][7]

# Lv1 SORT_ORD = 기존 Lv0(UPPR NULL) MAX+1
cur.execute("SELECT NVL(MAX(SORT_ORD),0)+1 FROM SCM_ADM_MNU_M WHERE UPPR_MNU_ID IS NULL")
lv1_sort = cur.fetchone()[0]

# MNU 키 — Supply/Supply Plan 은 locale 기존 키(MNU00003/MNU00013) 사용, DB 존재 여부만 확인.
#   leaf 신규 키 = MSG_M MNU 키 MAX+1 실측.
cur.execute("""SELECT NVL(MAX(TO_NUMBER(SUBSTR(MSG_ID,4))),0)+1 FROM SCM_ADM_MSG_M
 WHERE REGEXP_LIKE(MSG_ID,'^MNU[0-9]{5}$')""")
mnu_next = int(cur.fetchone()[0])
LEAF_MNU_KEY = f"MNU{mnu_next:05d}"
print(f"\n  leaf MNU 키 채번: {LEAF_MNU_KEY} / Lv1 SORT_ORD: {lv1_sort}")

MENUS = [
    # (MNU_ID, UPPR, URL, MSG_ID, DESC, SORT, LV, TP, UNIT)
    ("Supply", None, "supply", "MNU00003", "Supply", lv1_sort, ref["Demand"][5], lv1_tp, lv1_unit),
    ("Supply_Plan", "Supply", "supply-plan", "MNU00013", "Supply Plan", 1, ref["Demand_Plan"][5], lv2_tp, lv2_unit),
    ("SCP0013", "Supply_Plan", "production-plan-line", LEAF_MNU_KEY, "Production Plan Line", 1,
     ref["DMF0048"][5], leaf_tp, leaf_unit),
]

MENU_MSGS = [
    ("MNU00003", "MNU", "Supply"),
    ("MNU00013", "MNU", "Supply Plan"),
    (LEAF_MNU_KEY, "MNU", "Production Plan Line"),
]

API_ROWS = [(f"SCP0013_Line_{b}", "PROC", f"MSG_API_SCP0013_LINE_{b}", SP_MAIN) for b in BTNS]
API_MSGS = [(f"MSG_API_SCP0013_LINE_{b}", "MSG",
             {"SEARCH": "Search", "EXCEL": "Excel", "SORT": "Sort", "FILTER": "Filter",
              "MEASURE_SELECT": "Measure", "NEW": "NEW", "FIX": "Fix", "UNFIX": "Unfix",
              "LOAD_PERCENT": "Load%"}[b]) for b in BTNS]

counts = {}

# ── 1. MNU_M ────────────────────────────────────────────────────────────────
n = 0
for mnu_id, uppr, url, msg_id, desc, sort_ord, lv, tp, unit in MENUS:
    cur.execute("SELECT COUNT(*) FROM SCM_ADM_MNU_M WHERE MNU_ID=:m", m=mnu_id)
    if cur.fetchone()[0]:
        print(f"  = MNU_M {mnu_id} 존재 (skip)")
        continue
    n += 1
    if APPLY:
        cur.execute("""INSERT INTO SCM_ADM_MNU_M
            (MNU_ID, UPPR_MNU_ID, MNU_URL, MNU_MSG_ID, MNU_DESC, SORT_ORD, MNU_LV_NO,
             MNU_TP_CD, UNIT_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
            VALUES (:1,:2,:3,:4,:5,:6,:7,:8,:9,'Y','admin',SYSDATE,'admin',SYSDATE)""",
                    [mnu_id, uppr, url, msg_id, desc, sort_ord, lv, tp, unit])
counts["MNU_M"] = n

# ── 2. MSG_M (MNU 3 + LBL/MSG 9 + API 9 — 각 3 lang, 멱등) ──────────────────
n = 0
for msg_id, tp, text in MENU_MSGS + NEW_MSGS + API_MSGS:
    for lang in ("KO", "EN", "CN"):
        cur.execute("SELECT COUNT(*) FROM SCM_ADM_MSG_M WHERE MSG_ID=:m AND LANG_CD=:l", m=msg_id, l=lang)
        if cur.fetchone()[0]:
            continue
        n += 1
        if APPLY:
            cur.execute("""INSERT INTO SCM_ADM_MSG_M
                (MSG_ID, LANG_CD, MSG_NM, MSG_DESC, MSG_TP_CD, USE_YN,
                 CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
                VALUES (:1,:2,:3,:4,:5,'Y','admin',SYSDATE,'admin',SYSDATE)""",
                        [msg_id, lang, text, text, tp])
counts["MSG_M(3lang)"] = n

# ── 3. API_M ────────────────────────────────────────────────────────────────
n = 0
for api_id, tp, msg_id, url in API_ROWS:
    cur.execute("SELECT COUNT(*) FROM SCM_ADM_API_M WHERE API_ID=:a", a=api_id)
    if cur.fetchone()[0]:
        continue
    n += 1
    if APPLY:
        cur.execute("""INSERT INTO SCM_ADM_API_M
            (API_ID, API_TP_CD, API_MSG_ID, API_URL, USE_YN,
             CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
            VALUES (:1,:2,:3,:4,'Y','admin',SYSDATE,'admin',SYSDATE)""",
                    [api_id, tp, msg_id, url])
counts["API_M"] = n

# ── 4. BTN_MPG (SHT_NM='Line' — AS-IS SpdSheet 원본) ────────────────────────
n = 0
for b in BTNS:
    cur.execute("""SELECT COUNT(*) FROM SCM_ADM_MNU_BTN_MPG_M
        WHERE MNU_ID='SCP0013' AND SHT_NM='Line' AND MNU_BTN_CD=:b""", b=b)
    if cur.fetchone()[0]:
        continue
    n += 1
    if APPLY:
        cur.execute("""INSERT INTO SCM_ADM_MNU_BTN_MPG_M
            (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN,
             CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
            VALUES ('SCP0013','Line',:1,:2,'Y','admin',SYSDATE,'admin',SYSDATE)""",
                    [b, f"SCP0013_Line_{b}"])
counts["BTN_MPG"] = n

# ── 5. USER_GR 메뉴 권한 — DMF0003 보유 그룹 복사 (Supply/Supply_Plan/SCP0013 3메뉴) ──
n = 0
for target in ("Supply", "Supply_Plan", "SCP0013"):
    if APPLY:
        cur.execute("""INSERT INTO SCM_ADM_USER_GR_MNU_MPG_M
            (USER_GR_ID, MNU_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
            SELECT u.USER_GR_ID, :t, u.USE_YN, 'admin', SYSDATE, 'admin', SYSDATE
              FROM SCM_ADM_USER_GR_MNU_MPG_M u
             WHERE u.MNU_ID='DMF0003'
               AND NOT EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_MNU_MPG_M e
                                WHERE e.USER_GR_ID=u.USER_GR_ID AND e.MNU_ID=:t)""", t=target)
        n += cur.rowcount
    else:
        cur.execute("""SELECT COUNT(*) FROM SCM_ADM_USER_GR_MNU_MPG_M u
             WHERE u.MNU_ID='DMF0003'
               AND NOT EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_MNU_MPG_M e
                                WHERE e.USER_GR_ID=u.USER_GR_ID AND e.MNU_ID=:t)""", t=target)
        n += cur.fetchone()[0]
counts["USER_GR_MNU"] = n

# ── 6. USER_GR 버튼 권한 — 위 그룹 × 9 BTN ──────────────────────────────────
if APPLY:
    cur.execute(f"""INSERT INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M
        (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        SELECT g.USER_GR_ID, 'SCP0013', 'Line', b.BTN, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
          FROM (SELECT DISTINCT USER_GR_ID FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID='DMF0003') g
          CROSS JOIN (SELECT COLUMN_VALUE BTN FROM TABLE(SYS.ODCIVARCHAR2LIST({','.join("'"+b+"'" for b in BTNS)}))) b
         WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M e
                            WHERE e.USER_GR_ID=g.USER_GR_ID AND e.MNU_ID='SCP0013'
                              AND e.SHT_NM='Line' AND e.MNU_BTN_CD=b.BTN)""")
    counts["USER_GR_BTN"] = cur.rowcount
else:
    cur.execute("SELECT COUNT(DISTINCT USER_GR_ID) FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID='DMF0003'")
    counts["USER_GR_BTN"] = cur.fetchone()[0] * len(BTNS)

print(f"\n{'=' * 20} {'APPLY' if APPLY else 'DRY-RUN'} {'=' * 20}")
for k, v in counts.items():
    print(f"  {k:14}: {v}")
print(f"  leaf MNU 키   : {LEAF_MNU_KEY}  (locale json 3종 + generated-keys 에 동일 키 등록 의무)")

if APPLY:
    conn.commit()
    print("COMMIT 완료")
else:
    conn.rollback()
    print("dry-run — 변경 없음. 적용: --apply")

cur.close()
conn.close()
