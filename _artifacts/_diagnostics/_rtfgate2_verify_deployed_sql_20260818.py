#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_rtfgate2_verify_deployed_sql_20260818.py — **배포본 SQL 원문** 실행 검증

앞선 검증(_rtfgate2_verify_20260818.py)은 산식을 '재작성'해 돌렸기 때문에 GET 측 컬럼명 캡처
버그(ATTRIBUTE1 이 DM_MST_VERSION 컬럼으로 잡힘)를 놓쳤다. 이번에는 ALL_SOURCE 에서 실제 배포된
문장을 그대로 떼어내 바인드만 바꿔 실행한다.

  G  GET  : EDIT_AUTH_RTF_SYS_RP 산출문 원문 — division × 사용자별 카운트
  S  SAVE : 저장 게이트 EXISTS 원문 — GTT 에 RTF 행을 세션 한정으로 적재해 판정
"""
import re
import sys
import time

import oracledb

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")

DIVISIONS = ["40", "81", "81_UC", "81_HD", "81_HG", "81_HM", "81_ST"]
USERS = ["minyonglee1"]


def fetch_body(cur):
    cur.execute(
        """SELECT LINE, TEXT FROM ALL_SOURCE
            WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0021' AND TYPE='PACKAGE BODY'
            ORDER BY LINE"""
    )
    return {ln: tx for ln, tx in cur.fetchall()}


def extract(lines, start_pred, end_pred):
    """start_pred 를 만족하는 첫 줄부터 end_pred 를 만족하는 줄까지 원문 추출"""
    keys = sorted(lines)
    s = next(k for k in keys if start_pred(lines[k]))
    e = next(k for k in keys if k >= s and end_pred(lines[k]))
    return s, e, "".join(lines[k] for k in range(s, e + 1))


def main():
    import ora

    u, p, d = ora.conn_info()
    con = None
    for _ in range(10):
        try:
            con = oracledb.connect(user=u, password=p, dsn=d)
            break
        except Exception:  # noqa: BLE001
            time.sleep(10)
    if con is None:
        raise SystemExit("접속 실패")
    cur = con.cursor()
    lines = fetch_body(cur)

    # ── G: GET 측 원문 ────────────────────────────────────────────────────────
    s, e, get_sql = extract(
        lines,
        lambda t: "[RTFGATE2-FIX 2026-08-18]" in t,
        lambda t: t.rstrip().endswith("= 1);"),
    )
    # 앞줄의 SELECT COUNT(1)/INTO 를 되살려 독립 실행형으로 만든다
    get_sql = "SELECT COUNT(1) AS AUTH_CNT\n" + re.sub(
        r"^.*?FROM SCM_ADM_LOOKUP_MASTER_DETAIL L", "FROM SCM_ADM_LOOKUP_MASTER_DETAIL L",
        get_sql, flags=re.S
    )
    get_sql = get_sql.rstrip().rstrip(";")
    get_sql = (get_sql.replace("p_userinfo", ":u1")
                      .replace("p_created_by", ":u2")
                      .replace("v_p_program_id", "'DMF0021'")
                      .replace("p_division_id", ":dv"))
    print(f"[G] 배포본 GET 문 원문 추출 (L{s}~L{e})\n{'=' * 105}")
    print("DIVISION | USER | AUTH_CNT | 판정")
    print("-" * 105)
    for dv in DIVISIONS:
        for us in USERS:
            cur.execute(get_sql, {"u1": us, "u2": us, "dv": dv})
            cnt = cur.fetchone()[0]
            print(f"{dv} | {us} | {cnt} | {'편집가능(Y)' if cnt > 0 else '편집불가(N)'}")

    # ── S: SAVE 측 원문 ───────────────────────────────────────────────────────
    s2, e2, save_sql = extract(
        lines,
        lambda t: t.lstrip().startswith("SELECT 1 INTO v_max_cnt FROM DUAL")
        and any("[RTFGATE2 2026-08-18] RTF[R+P]" in lines[k] for k in range(1, 1)),
        lambda t: False,
    ) if False else (None, None, None)

    # SAVE 블록은 마커 라인 기준으로 잡는다
    keys = sorted(lines)
    mk = next(k for k in keys if "[RTFGATE2 2026-08-18] RTF[R+P]" in lines[k])
    st = next(k for k in keys if k > mk and lines[k].lstrip().startswith("SELECT 1 INTO v_max_cnt"))
    en = next(k for k in keys if k > st and lines[k].rstrip().endswith(");"))
    save_sql = "".join(lines[k] for k in range(st, en + 1))
    save_sql = save_sql.replace("SELECT 1 INTO v_max_cnt FROM DUAL", "SELECT 1 AS BLOCKED FROM DUAL")
    save_sql = save_sql.rstrip().rstrip(";")

    print(f"\n[S] 배포본 SAVE 게이트 원문 추출 (L{st}~L{en}) — GTT 세션 적재 후 판정")
    print("=" * 105)
    cur.execute("""SELECT COLUMN_NAME, NULLABLE FROM ALL_TAB_COLUMNS
                    WHERE OWNER='SCM_MGR' AND TABLE_NAME='GT_F021_SALES_PLAN'
                      AND NULLABLE='N' ORDER BY COLUMN_ID""")
    notnull = [r[0] for r in cur.fetchall()]
    print(f"GTT NOT NULL 컬럼: {notnull or '(없음)'}")

    for dv in DIVISIONS[:2]:
        cur.execute("DELETE FROM GT_F021_SALES_PLAN")
        cur.execute(
            "INSERT INTO GT_F021_SALES_PLAN (V_MEASURE, V_DIVISION_ID, V_CREATED_BY) "
            "VALUES ('RTF_SYS_RP', :dv, :us)",
            {"dv": dv, "us": USERS[0]},
        )
        cur.execute(save_sql)
        row = cur.fetchone()
        print(f"{dv} | RTF 저장행 1건 → {'차단(MSG01001)' if row else '통과(저장허용)'}")
    con.rollback()

    cur.close()
    con.close()


if __name__ == "__main__":
    main()
