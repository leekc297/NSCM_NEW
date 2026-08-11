#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0042_auth_combo_probe.py — 그리드 셀 콤보 '권한판(*Auth)' 이식 타당성 실측 (2026-08-09, 읽기 전용)

배경: AS-IS DMF0042 InsertRow 는 셀 콤보에 **권한 필터판**을 붙인다(L1233·L1248·L1252).
      TO-BE 메타는 비권한판을 쓴다. 전환 여부는 hook #117 §5.10 /
      memory feedback_edit_display_combo_dualization 판정식으로 **실측 후** 결정한다:

        원장에 남은 값 중 편집 후보(권한판) 밖에 있는 건수 > 0  → 메타 교체 금지 (표시 파손)
                                                        = 0  → 교체 허용

측정 2축:
  (A) 계정별 권한판 vs 비권한판 **행수** — 권한판이 0행이면 그 계정은 콤보가 통째로 빈다.
  (B) 원장(DM_PLN_BP_FCST) 값 중 권한판 후보 밖 건수 — >0 이면 CODE→NAME 표시가 raw 코드로 깨진다.
"""
import pathlib
import re
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

# ui_http_e2e.ROSTER 와 동일 (권한별 공식 계정) + primary
ACCOUNTS = [
    ("minyonglee1", "primary"),
    ("hongjae.kim", "40 DM Admin"), ("eunah.koo", "40 DM Planner"),
    ("yooah.chung", "40 DM Viewer"), ("dodae", "40 SCP Planner"),
    ("jiwon.park", "81 DM Admin"), ("bpark416", "81 DM Planner"),
    ("jaehyeok", "81 DM Planner (W/S)"), ("park6151", "81 DM Viewer"),
    ("wonqthanq", "82 DM Admin"), ("ys_cho", "82 DM Planner"),
    ("miyeong.lee", "82 DM Planner (W/S)"), ("yeonjusung", "82 DM Viewer"),
]

# (권한판, 비권한판, 원장 컬럼) — 원장 컬럼은 division 슬롯 무관 공통명
PAIRS = [
    ("EndCustomerByDivisionDeptAuth", "EndCustomerByDivisionDept", "END_CUSTOMER"),
    ("TeambyDivisionAuth", "DeptId", "DEPT_ID"),
    ("SiteByEndCustomerAuth", "SiteByEndCustomer", "SCM_SITE_ID"),
]


def combo_sql(cur, sql_id):
    cur.execute("SELECT SQL_DTL_CTN FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID = :s", {"s": sql_id})
    r = cur.fetchone()
    if not r:
        return None
    return r[0].read() if hasattr(r[0], "read") else str(r[0])


def bind(sql, user):
    """@토큰 치환 — BE makeComboQuery 와 동일한 raw 치환. 미지 토큰은 '' (BE 규약)."""
    sql = sql.replace("@sesUserId", "'%s'" % user).replace("@sesLangCd", "'KO'")
    sql = re.sub(r"@\w+", "''", sql)
    return sql


def main():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        sqls = {}
        for a, b, _ in PAIRS:
            for sid in (a, b):
                if sid not in sqls:
                    sqls[sid] = combo_sql(cur, sid)

        print("== (A) 계정별 행수 — 권한판 / 비권한판 ==")
        header = "%-14s %-22s" % ("USER", "ROLE") + "".join("  %-34s" % a for a, _, _ in PAIRS)
        print(header)
        print("-" * len(header))
        zero_hits = []
        for user, role in ACCOUNTS:
            cells = []
            for a, b, _col in PAIRS:
                na = nb = -1
                for sid, tgt in ((a, "a"), (b, "b")):
                    try:
                        cur.execute("SELECT COUNT(*) FROM (%s)" % bind(sqls[sid], user))
                        n = cur.fetchone()[0]
                    except Exception:
                        n = -1
                    if tgt == "a":
                        na = n
                    else:
                        nb = n
                if na == 0:
                    zero_hits.append((user, role, a))
                cells.append("%10s / %-10s" % (na, nb))
            print("%-14s %-22s" % (user, role) + "".join("  %-34s" % c for c in cells))

        print()
        if zero_hits:
            print("⛔ 권한판 0행 계정 — 이 계정은 해당 셀 콤보가 **통째로 빈다**:")
            for usr, role, sid in zero_hits:
                print("   · %-14s (%-22s) %s" % (usr, role, sid))
        else:
            print("✅ 권한판 0행 계정 없음")

        print()
        print("== (B) 원장 값 중 권한판 후보 밖 건수 (primary=minyonglee1 기준) ==")
        print("   판정: >0 → 메타 교체 금지(표시 파손) / =0 → 교체 허용")
        for a, _b, col in PAIRS:
            try:
                cur.execute(
                    """SELECT COUNT(*) FROM SCM_MGR.DM_PLN_BP_FCST F
                        WHERE NVL(TRIM(F.%s),'-') <> '-'
                          AND F.%s NOT IN (SELECT CODE FROM (%s))"""
                    % (col, col, bind(sqls[a], "minyonglee1"))
                )
                outside = cur.fetchone()[0]
            except Exception as e:  # noqa: BLE001
                print("   %-32s 측정 실패: %s" % (a, str(e)[:90]))
                continue
            cur.execute(
                "SELECT COUNT(*) FROM SCM_MGR.DM_PLN_BP_FCST F WHERE NVL(TRIM(F.%s),'-') <> '-'" % col
            )
            total = cur.fetchone()[0]
            verdict = "⛔ 교체 금지" if outside > 0 else "✅ 교체 허용"
            pct = (outside * 100.0 / total) if total else 0
            print("   %-32s %s  후보밖 %d / 원장 %d (%.1f%%)  [%s]"
                  % (a, col, outside, total, pct, verdict))


if __name__ == "__main__":
    main()
