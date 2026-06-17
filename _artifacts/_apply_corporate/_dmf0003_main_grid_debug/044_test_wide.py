"""Broad test — 다양한 division + 기간 측 W27 분리 확인"""
import os
import oracledb

with oracledb.connect(user=os.environ["NSCM_ORA_USER"],
                      password=os.environ["NSCM_ORA_PASS"],
                      dsn=os.environ["NSCM_ORA_DSN"]) as con:
    cur = con.cursor()
    for div in ['40', '81', '82', '83', '84', '85', '88']:
        for (start, end, label) in [
            ('20250101', '20251231', '2025년'),
            ('20260101', '20261231', '2026년'),
            ('20250622', '20250712', '2025년 W27'),
        ]:
            rc1 = cur.var(oracledb.CURSOR)
            rc2 = cur.var(oracledb.CURSOR)
            try:
                cur.callproc("SCM_MGR.DMF0020_GET_SCM_MST_FUTURE_PRICE", [
                    div,'ALL','ALL','ALL','ALL','ALL','ALL','ALL','ALL',
                    start, end, 'ALL','minyonglee1','ALL','ALL','N','N','ALL',
                    rc1, rc2,
                ])
                cs = rc1.getvalue()
                if not cs: continue
                cols = [d[0] for d in cs.description]
                w_cols = sorted([c for c in cols if c.startswith('W_')])
                rows = cs.fetchall()
                if len(rows) > 0 or len(w_cols) > 0:
                    # 월 변경 주 column 측 검출 — 0701, 0801, 0901 등 측 시작
                    monthly_first = [c for c in w_cols if c.endswith('01') and not c.endswith('0101')]
                    print(f"  div={div} {label} ({start}~{end}): rows={len(rows)}, W_cols={len(w_cols)}, month-start={monthly_first[:5]}")
            except Exception as e:
                print(f"  div={div} {label}: FAIL {str(e)[:100]}")
