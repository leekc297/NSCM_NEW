#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""No.45 / No.49 재현 — 요구 원문 데이터셋 그대로 SAVE SP 호출 후 **무조건 ROLLBACK**.

안전 근거: P_DMF0082_SAVE_MAIN_DATA 본문에 COMMIT 0건(ALL_SOURCE 실측 2026-08-14).
          따라서 명시 ROLLBACK 으로 원장 변경이 남지 않는다. (검증 실패 시엔 애초에 RAISE 로 미기록.)
"""
import sys, io, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

cur.execute("SELECT TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON'),'YYYYMMDD') FROM DUAL")
NEXT_MON = cur.fetchone()[0]
print(f"# 차주 월요일 = {NEXT_MON}\n")

# 요구 원문 데이터셋 확인
for label, item, cust, site in (
    ("No.45", "MPCKRMVLTA16", "LX INTL SINGAPORE", "LX INTL SINGAPORE_SG_SIN"),
    ("No.49", "MCSS22561-C1", "NT", "BYD Electronics_CN_SZX"),
):
    cur.execute(
        """SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SITE_ITEM
           WHERE DIVISION_ID='40' AND PROJECT_CODE=:c AND SCM_SITE_ID=:s AND ITEM_ID=:i
           AND VALID_YN='Y' AND (SALES_PLAN_ADJUST_YN='Y' OR SALES_PLAN_ADJUST_YN IS NULL)""",
        {"c": cust, "s": site, "i": item},
    )
    print(f"  [{label}] SITE_ITEM(52주 게이트 INNER JOIN 대상) = {cur.fetchone()[0]}행")


def save(tag, rows):
    """rows = [(measure, fcst_type, currency, qty), ...] — '^' bulk 로 이어 붙인다."""
    def j(i):
        return "^".join(str(r[i]) for r in rows)

    out = con.cursor()
    args = [
        "^".join("I" for _ in rows),            # active_flag
        j(4),                                    # division
        j(5), j(5),                              # project_code, end_customer
        j(6),                                    # scm_site_id
        j(7),                                    # item_id
        "^".join("E" for _ in rows),             # dom_exp
        j(1),                                    # fcst_type
        "^".join("CIF" for _ in rows),           # incoterms
        j(0),                                    # measure
        "^".join("-" for _ in rows),             # plant_site_id
        "^".join("Common" for _ in rows),        # cell_prod_site_id
        "^".join(NEXT_MON for _ in rows),        # yyyymmdd
        j(2),                                    # currency
        j(3),                                    # qty
        "minyonglee1",
        "^".join("-" for _ in rows),             # as_from_site
        out,
    ]
    try:
        cur.callproc("SCM_MGR.PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA", args)
        res = out.fetchall()
        cols = [c[0] for c in out.description]
        print(f"\n## {tag} → 호출 성공(=차단 안 됨)")
        for r in res:
            print("   " + " | ".join(f"{cols[i]}={r[i]}" for i in range(len(cols))))
    except Exception as e:
        msg = str(e).replace("\n", " ⏎ ")
        print(f"\n## {tag} → 차단됨(RAISE)\n   {msg[:900]}")
    finally:
        con.rollback()


# No.45 : MKT_FCST 수량만 (판가 미입력) — 요구 = "애초에 저장 불가여야 함"
save(
    "No.45  MKT_FCST=777 / Unit Price 미입력 (FCST Type=MPS 'Mass')",
    [("MKT_FCST", "MPS", "", "777", "40", "LX INTL SINGAPORE", "LX INTL SINGAPORE_SG_SIN", "MPCKRMVLTA16")],
)

# No.49 : 수량 + 판가 둘 다 입력 (FCST Type=SPF) — 요구 = "미입력 팝업이 뜨면 안 됨"
save(
    "No.49  MKT_FCST=777 + LOC=777 (FCST Type=SPF 'Spare Parts(FREE)')",
    [
        ("MKT_FCST", "SPF", "", "777", "40", "NT", "BYD Electronics_CN_SZX", "MCSS22561-C1"),
        ("LOC", "SPF", "USD", "777", "40", "NT", "BYD Electronics_CN_SZX", "MCSS22561-C1"),
    ],
)

# 대조군 : 수량 + 판가 둘 다 입력 (FCST Type=MPS, 52주 게이트 대상)
save(
    "대조군 MKT_FCST=777 + LOC=777 (FCST Type=MPS — 52주 게이트 대상)",
    [
        ("MKT_FCST", "MPS", "", "777", "40", "LX INTL SINGAPORE", "LX INTL SINGAPORE_SG_SIN", "MPCKRMVLTA16"),
        ("LOC", "MPS", "USD", "777", "40", "LX INTL SINGAPORE", "LX INTL SINGAPORE_SG_SIN", "MPCKRMVLTA16"),
    ],
)

con.rollback()
con.close()
print("\n[rollback] 원장 변경 없음")
