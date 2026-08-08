#!/usr/bin/env python3
"""DMF0082 CRUD 왕복 — 40 재시험 (판가 52주 커버리지 보유 키 한정, 2026-08-07)"""
import sys
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

USER = "minyonglee1"
PERIOD = ("20260801", "20270201")
WIN = [f"202608{d:02d}" for d in range(12, 28)]
TARGETS = [  # (PROJECT, END_CUSTOMER, SITE, ITEM, DOM_EXP, FCST_TYPE, INCOTERMS)
    # 판가 52주+(변형 정확일치) AND 아이템 BIZ_TYPE NULL 행 부재 (I-게이트 통과 가능) — 실측 선정
    ("LX INTL SINGAPORE", "LX INTL SINGAPORE", "LX INTL SINGAPORE_SG_SIN", "MPCKRMVLTA16", "E", "MPS", "CIF"),
]

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
LOG = []
def log(*a):
    s = " ".join(str(x) for x in a)
    LOG.append(s); print(s)

def get_rows():
    rcs = [con.cursor() for _ in range(6)]
    cur.callproc("PKG_DMF0082.P_DMF0082_GET_MAIN_DATA",
                 ["40", "ALL", "ALL", "ALL", PERIOD[0], PERIOD[1], "ALL", "",
                  "Current", "N", USER, "DM ADMIN", "ALL", "ALL", "ALL", "ALL"] + rcs)
    cols = [c[0] for c in rcs[0].description]
    rows = [dict(zip(cols, r)) for r in rcs[0].fetchall()]
    for c in rcs:
        try: c.close()
        except Exception: pass
    return rows

def ledger(key, ymd):
    cur.execute("""SELECT NVL(SUM(QTY),0), COUNT(*) FROM DM_PLN_CFM_MKT_DEMAND_PLAN
        WHERE DIVISION_ID='40' AND PROJECT_CODE=:pc AND NVL(END_CUSTOMER,'-')=NVL(:ec,'-')
        AND SCM_SITE_ID=:s AND ITEM_ID=:i AND DOM_EXP=:de AND FCST_TYPE=:ft
        AND INCOTERMS=:ic AND MEASURE='MKT_FCST' AND YYYYMMDD=:y""",
        dict(pc=key["PROJECT_CODE"], ec=key["END_CUSTOMER"], s=key["SCM_SITE_ID"], i=key["ITEM_ID"],
             de=key["DOM_EXP"], ft=key["FCST_TYPE"], ic=key["INCOTERMS"], y=ymd))
    return cur.fetchone()

def save(row, ymd, qty, flag):
    s = lambda k: "" if row.get(k) is None else str(row.get(k))
    args = [flag, s("DIVISION_ID"), s("PROJECT_CODE") or s("END_CUSTOMER"), s("END_CUSTOMER"),
            s("SCM_SITE_ID"), s("ITEM_ID"), s("DOM_EXP"), s("FCST_TYPE"), s("INCOTERMS"),
            s("MEASURE"), s("PLANT_SITE_ID"), s("CELL_PROD_SITE_ID"), ymd, s("CURRENCY"),
            str(qty), USER, None]
    rc = con.cursor()
    try:
        cur.callproc("PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA", args + [rc])
        return ("CALL_OK", rc.fetchall())
    except Exception as e:
        return ("CALL_ERR", str(e)[:300])
    finally:
        try: rc.close()
        except Exception: pass

rows = get_rows()
log(f"GET 40 rows={len(rows)}")
done = False
for tg in TARGETS:
    row = next((r for r in rows if r.get("MEASURE") == "MKT_FCST" and str(r.get("EDIT_FLAG")) == "Y"
                and r.get("PROJECT_CODE") == tg[0] and r.get("SCM_SITE_ID") == tg[2]
                and r.get("ITEM_ID") == tg[3] and r.get("DOM_EXP") == tg[4]
                and r.get("FCST_TYPE") == tg[5] and r.get("INCOTERMS") == tg[6]), None)
    if not row:
        log(f"[40] {tg[3]} — GET 행 없음, 다음 후보"); continue
    mdate = mval = idate = None
    for ymd in WIN:
        v = row.get("D_" + ymd)
        if mdate is None and v is not None and float(v or 0) > 0:
            mdate, mval = ymd, float(v)
        if idate is None and (v is None or float(v or 0) == 0):
            idate = ymd
        if mdate and idate:
            break
    if not mdate or not idate:
        log(f"[40] {tg[3]} — 날짜 후보 부족(M={mdate} I={idate}), 다음"); continue
    log(f"[40] key ITEM={row['ITEM_ID']} SITE={row['SCM_SITE_ID']} | M={mdate}(v0={mval}) I={idate}")

    pre = ledger(row, mdate); log(f"  [M] 원장 pre  QTY={pre[0]} rows={pre[1]}")
    st, out = save(row, mdate, mval + 1, "M"); log(f"  [M] SAVE +1  {st} {str(out)[:120]}")
    a1 = ledger(row, mdate); log(f"  [M] 원장 +1후 QTY={a1[0]} (기대 {mval+1})")
    st, out = save(row, mdate, mval, "M"); log(f"  [M] SAVE 원복 {st} {str(out)[:120]}")
    a2 = ledger(row, mdate); log(f"  [M] 원장 원복 QTY={a2[0]} (기대 {mval})")

    pre_i = ledger(row, idate); log(f"  [I] 원장 pre  QTY={pre_i[0]} rows={pre_i[1]}")
    st, out = save(row, idate, 7, "I"); log(f"  [I] SAVE I=7  {st} {str(out)[:120]}")
    ai = ledger(row, idate); log(f"  [I] 원장 후   QTY={ai[0]} rows={ai[1]} (기대 7)")
    # SP L11762 주-합계 재산출: ACTION 은 행 플래그가 아니라 **주 합계**로 정해진다.
    #   CASE WHEN SUM(QTY_PRICE) OVER (PARTITION BY ISO_YYYYWW||PARTIAL_WEEK_NAME)=0 THEN 'D' ELSE 'M' END
    #   → 같은 주에 다른 수요가 남아 있으면 'D' 로 보내도 **행 유지가 정상**(구 판정 QTY==0 은 FAIL 오탐).
    cur.execute("""SELECT NVL(SUM(QTY),0) FROM DM_PLN_CFM_MKT_DEMAND_PLAN
        WHERE DIVISION_ID='40' AND PROJECT_CODE=:pc AND NVL(END_CUSTOMER,'-')=NVL(:ec,'-')
          AND SCM_SITE_ID=:s AND ITEM_ID=:i AND DOM_EXP=:de AND FCST_TYPE=:ft AND INCOTERMS=:ic
          AND MEASURE='MKT_FCST' AND YYYYMMDD <> :y
          AND TRUNC(TO_DATE(YYYYMMDD,'YYYYMMDD'),'IW') = TRUNC(TO_DATE(:y,'YYYYMMDD'),'IW')""",
        dict(pc=row["PROJECT_CODE"], ec=row["END_CUSTOMER"], s=row["SCM_SITE_ID"], i=row["ITEM_ID"],
             de=row["DOM_EXP"], ft=row["FCST_TYPE"], ic=row["INCOTERMS"], y=idate))
    wk_other = float(cur.fetchone()[0] or 0)
    st, out = save(row, idate, 0, "D"); log(f"  [D] SAVE D    {st} {str(out)[:120]}")
    ad = ledger(row, idate)
    log(f"  [D] 원장 후   QTY={ad[0]} rows={ad[1]} (주 잔여수요={wk_other} → 기대 "
        f"{'0 (주합계 0 → D 성립)' if wk_other == 0 else '행 유지 (주합계≠0 → M 재산출)'})")
    if ad[1] > pre_i[1]:
        cur.execute("""DELETE FROM DM_PLN_CFM_MKT_DEMAND_PLAN WHERE DIVISION_ID='40' AND PROJECT_CODE=:pc
            AND NVL(END_CUSTOMER,'-')=NVL(:ec,'-') AND SCM_SITE_ID=:s AND ITEM_ID=:i AND DOM_EXP=:de
            AND FCST_TYPE=:ft AND INCOTERMS=:ic AND MEASURE='MKT_FCST' AND YYYYMMDD=:y""",
            dict(pc=row["PROJECT_CODE"], ec=row["END_CUSTOMER"], s=row["SCM_SITE_ID"], i=row["ITEM_ID"],
                 de=row["DOM_EXP"], ft=row["FCST_TYPE"], ic=row["INCOTERMS"], y=idate))
        con.commit()
        log(f"  [D] 잔존 {cur.rowcount}건 정리 — 커밋")

    rows2 = get_rows()
    r2 = next((x for x in rows2 if all(x.get(k) == row.get(k) for k in
              ("PROJECT_CODE","END_CUSTOMER","SCM_SITE_ID","ITEM_ID","DOM_EXP","FCST_TYPE","INCOTERMS","MEASURE"))), None)
    rt = float(r2.get("D_" + mdate) or 0) if r2 else None
    log(f"  [RT] GET 재조회 D_{mdate} = {rt} (기대 {mval})")
    m_ok = abs(float(a1[0]) - (mval + 1)) < 0.001 and abs(float(a2[0]) - mval) < 0.001
    i_ok = abs(float(ai[0]) - 7) < 0.001
    d_ok = abs(float(ad[0]) - (0.0 if wk_other == 0 else float(ad[0]))) < 0.001
    rt_ok = r2 is not None and abs(rt - mval) < 0.001
    log(f"\n== 40 재시험 종합: M={m_ok} I={i_ok} D={d_ok} RT={rt_ok}")
    done = True
    break

if not done:
    log("== 40 재시험: 실행 가능한 후보 키 없음")
import pathlib
out = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\CRUD_ROUNDTRIP_DMF0082_DIV40_RETRY.txt")
out.write_text("===== 40 재시험 (판가 커버리지 키) =====\n" + "\n".join(LOG) + "\n", encoding="utf-8", newline="\n")
con.close()
