#!/usr/bin/env python3
"""DMF0082 CRUD 런타임 왕복 검증 (2026-08-07 — 사용자 승인: 로컬 SAVE SP 직접 실행)
40/81: M(+1→원복) + I(신규 7)→D(삭제)→정리 / 82: V82-00 저장 거부.
각 단계 원장 SELECT 실증. FE payload 규약 1:1(save.ts — 단일 행 '^' 없음, keyOf/plantSite/cellProd 그대로)."""
import sys, datetime
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

USER = "minyonglee1"
PERIOD = ("20260801", "20270201")
WIN = [f"2026{m:02d}{d:02d}" for m in (8,) for d in range(12, 28)]  # 편집가능 미래 창 (금주 월요일 이후)

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
LOG = []
def log(*a):
    s = " ".join(str(x) for x in a)
    LOG.append(s); print(s)

def get_rows(div):
    rcs = [con.cursor() for _ in range(6)]
    cur.callproc("PKG_DMF0082.P_DMF0082_GET_MAIN_DATA",
                 [div, "ALL", "ALL", "ALL", PERIOD[0], PERIOD[1], "ALL", "",
                  "Current", "N", USER, "DM ADMIN", "ALL", "ALL", "ALL", "ALL"] + rcs)
    cols = [c[0] for c in rcs[0].description]
    rows = [dict(zip(cols, r)) for r in rcs[0].fetchall()]
    res = rcs[5].fetchall()
    for c in rcs:
        try: c.close()
        except Exception: pass
    return rows, res

def week_other_qty(div, key, ymd):
    """같은 키 · 같은 ISO 주 안에서 ymd 를 **제외한** 나머지 일자의 QTY 합. (참고 출력 전용)

    ⛔ 2026-08-22 재정정 — **2026-08-08 의 "FAIL 오탐" 판정이 틀렸다. 그것이 진짜 결함이었다.**

    구 주석은 `P_DMF0082_SAVE_MAIN_DATA` **L11762** 가 ACTION 을 주 단위 합계로 재산출한다고 적었으나,
    L11762 실측은 전혀 다른 문장이다:

        L11760  SELECT MIN(BASIS_START_DATE), MAX(BASIS_END_DATE)
        L11762  FROM SCM_MGR.SCM_SYS_CALENDAR_M M        ← 52주 구간 계산. 재산출과 무관

    진짜 주-합계 재산출은 **L12739~12748** 이고, 적용 범위가 `LOC` 로 한정돼 있다:

        L12744  WHERE B.MEASURE = 'LOC' AND B.ACTION <> 'I'
        L12748  WHERE A.MEASURE = 'LOC' AND A.ACTION <> 'I';

    이 러너의 `pick()` 은 **`MEASURE='MKT_FCST'`** 행만 고른다(L100) — 즉 그 예외는 **적용될 수 없다.**
    존재하지 않는 규약을 근거로 기대값을 실측값으로 바꿔(`d_expect = float(ad[0])`) FAIL 을 PASS 로
    만들었고, 그 결과 **"수요 measure DELETE 미구현"** 이라는 실결함이 2주간 통과했다.
    (실원인: DELETE 블록 measure 목록에 수요 3종 누락 — `PKG_DMF0082_DEMAND_DELETE_20260822` 로 정정)

    ⇒ 판정에서는 쓰지 않는다. 진단 참고용으로만 출력한다.
    """
    tbl = "DM_PLN_CFM_MKT_DEMAND_PLAN" if div == "40" else "DM_PLN_MKT_FCST"
    ec = " AND NVL(END_CUSTOMER,'-')=NVL(:ec,'-')" if div == "40" else ""
    binds = dict(d=div if div == "40" else key["DIVISION_ID"], pc=key["PROJECT_CODE"],
                 s=key["SCM_SITE_ID"], i=key["ITEM_ID"], de=key["DOM_EXP"], ft=key["FCST_TYPE"],
                 ic=key["INCOTERMS"], m=key["MEASURE"], y=ymd)
    if div == "40":
        binds["ec"] = key["END_CUSTOMER"]
    cur.execute(f"""SELECT NVL(SUM(QTY),0) FROM {tbl}
        WHERE DIVISION_ID=:d AND PROJECT_CODE=:pc{ec} AND SCM_SITE_ID=:s AND ITEM_ID=:i
          AND DOM_EXP=:de AND FCST_TYPE=:ft AND INCOTERMS=:ic AND MEASURE=:m
          AND YYYYMMDD <> :y
          AND TRUNC(TO_DATE(YYYYMMDD,'YYYYMMDD'),'IW') = TRUNC(TO_DATE(:y,'YYYYMMDD'),'IW')""", binds)
    return float(cur.fetchone()[0] or 0)


def ledger_sum(div, key, ymd):
    if div == "40":
        cur.execute("""SELECT NVL(SUM(QTY),0), COUNT(*) FROM DM_PLN_CFM_MKT_DEMAND_PLAN
            WHERE DIVISION_ID=:d AND PROJECT_CODE=:pc AND NVL(END_CUSTOMER,'-')=NVL(:ec,'-')
            AND SCM_SITE_ID=:s AND ITEM_ID=:i AND DOM_EXP=:de AND FCST_TYPE=:ft
            AND INCOTERMS=:ic AND MEASURE=:m AND YYYYMMDD=:y""",
            dict(d=div, pc=key["PROJECT_CODE"], ec=key["END_CUSTOMER"], s=key["SCM_SITE_ID"],
                 i=key["ITEM_ID"], de=key["DOM_EXP"], ft=key["FCST_TYPE"], ic=key["INCOTERMS"],
                 m=key["MEASURE"], y=ymd))
    else:
        cur.execute("""SELECT NVL(SUM(QTY),0), COUNT(*) FROM DM_PLN_MKT_FCST
            WHERE DIVISION_ID=:d AND PROJECT_CODE=:pc AND SCM_SITE_ID=:s AND ITEM_ID=:i
            AND DOM_EXP=:de AND FCST_TYPE=:ft AND INCOTERMS=:ic AND MEASURE=:m AND YYYYMMDD=:y""",
            dict(d=key["DIVISION_ID"], pc=key["PROJECT_CODE"], s=key["SCM_SITE_ID"], i=key["ITEM_ID"],
                 de=key["DOM_EXP"], ft=key["FCST_TYPE"], ic=key["INCOTERMS"], m=key["MEASURE"], y=ymd))
    return cur.fetchone()

def save(row, ymd, qty, flag):
    """FE save.ts keyOf 1:1 — projectCode = PROJECT_CODE || END_CUSTOMER."""
    s = lambda k: "" if row.get(k) is None else str(row.get(k))
    args = [flag, s("DIVISION_ID"), s("PROJECT_CODE") or s("END_CUSTOMER"), s("END_CUSTOMER"),
            s("SCM_SITE_ID"), s("ITEM_ID"), s("DOM_EXP"), s("FCST_TYPE"), s("INCOTERMS"),
            s("MEASURE"), s("PLANT_SITE_ID"), s("CELL_PROD_SITE_ID"), ymd, s("CURRENCY"),
            str(qty), USER, None]
    rc = con.cursor()
    try:
        cur.callproc("PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA", args + [rc])
        out = rc.fetchall()
        return ("CALL_OK", out)
    except Exception as e:
        return ("CALL_ERR", str(e)[:300])
    finally:
        try: rc.close()
        except Exception: pass

def pick(rows):
    """MKT_FCST·EDIT Y 행에서 (row, M용 날짜·값, I용 빈 날짜) 선정."""
    for r in rows:
        if r.get("MEASURE") != "MKT_FCST" or str(r.get("EDIT_FLAG")) != "Y":
            continue
        mdate = mval = idate = None
        for ymd in WIN:
            v = r.get("D_" + ymd, None)
            if mdate is None and v is not None and float(v or 0) > 0:
                mdate, mval = ymd, float(v)
            if idate is None and (v is None or float(v or 0) == 0):
                idate = ymd
            if mdate and idate:
                return r, mdate, mval, idate
    return None, None, None, None

RESULTS = []
for div in ("40", "81"):
    log(f"\n===== DIV {div} =====")
    rows, res = get_rows(div)
    log(f"GET rows={len(rows)} res={res[:1]}")
    row, mdate, mval, idate = pick(rows)
    if not row:
        log(f"[{div}] 후보 행 없음 — SKIP"); RESULTS.append((div, "SKIP")); continue
    key = row
    log(f"[{div}] key ITEM={key['ITEM_ID']} SITE={key['SCM_SITE_ID']} PJT={key['PROJECT_CODE']} | M={mdate}(v0={mval}) I={idate}")

    # --- U(M) : v0+1 → 원장 확인 → v0 원복 → 원장 확인
    pre = ledger_sum(div, key, mdate); log(f"  [M] 원장 pre  QTY={pre[0]} rows={pre[1]}")
    st, out = save(row, mdate, mval + 1, "M"); log(f"  [M] SAVE +1  {st} {out}")
    a1 = ledger_sum(div, key, mdate); log(f"  [M] 원장 +1후 QTY={a1[0]} rows={a1[1]}  (기대 {mval+1})")
    st, out = save(row, mdate, mval, "M"); log(f"  [M] SAVE 원복 {st} {out}")
    a2 = ledger_sum(div, key, mdate); log(f"  [M] 원장 원복 QTY={a2[0]} rows={a2[1]}  (기대 {mval})")
    m_ok = abs(float(a1[0]) - (mval + 1)) < 0.001 and abs(float(a2[0]) - mval) < 0.001

    # --- C(I) → D : 빈 날짜 신규 7 → 원장 → D → 원장 → 잔존 시 정리
    pre_i = ledger_sum(div, key, idate); log(f"  [I] 원장 pre  QTY={pre_i[0]} rows={pre_i[1]}")
    st, out = save(row, idate, 7, "I"); log(f"  [I] SAVE I=7  {st} {out}")
    ai = ledger_sum(div, key, idate); log(f"  [I] 원장 후   QTY={ai[0]} rows={ai[1]}  (기대 7)")
    i_ok = abs(float(ai[0]) - 7) < 0.001
    wk_other = week_other_qty(div, key, idate)
    st, out = save(row, idate, 0, "D"); log(f"  [D] SAVE D    {st} {out}")
    ad = ledger_sum(div, key, idate)
    # ⭐ 기대값은 **고정**이다 — 'D' 로 보낸 행은 원장에서 사라져야 한다.
    #   주-합계 재산출은 `MEASURE='LOC'` 전용(L12744/12748)이라 MKT_FCST 에는 적용되지 않는다.
    #   실측값을 기대값에 대입하는 형태(`d_expect = float(ad[0])`)는 항상 PASS 가 되므로 금지한다.
    # ⛔ 삽입이 실패했으면 D 는 **판정하지 않는다**(None).
    #   원장이 처음부터 0행이면 "삭제됨"과 구분되지 않는다 — 2026-08-22 실사고:
    #   40 축 선정 행이 `Cell Prod Site*` 검증에 걸려 I 가 실행되지 않았는데 D 가 PASS 로 나왔다.
    #   (GET 이 CELL_PROD_SITE_ID 를 388건 전부 None 으로 돌려주는 것이 원인. 화면은 실값을 보낸다.)
    #   유효 후보를 원장 실키에서 뽑는 전용 도구 = `_dmf0082_delete_proof_20260822.py`
    d_ok = None if not i_ok else (abs(float(ad[0])) < 0.001 and ad[1] == 0)
    log(f"  [D] 원장 후   QTY={ad[0]} rows={ad[1]}  (기대 QTY=0 rows=0 · 고정)"
        f"{'  ⚠ I 실패로 D 판정불가' if d_ok is None else ''}"
        f"   [참고] 같은 주 잔여수요={wk_other}")
    if ad[1] > pre_i[1]:  # 사전에 없던 행 잔존 → 정리 (정확 키 한정)
        # ⚠ 2026-08-08 정정: 구 코드는 `AND NVL(QTY,0)=0` 으로 한정해 **QTY 가 남은 테스트 행을 누락**했다.
        #   실사고: div40 20260812 QTY=7 이 사내 원장에 잔존(수동 정리함). 사전 부재분이면 QTY 무관 정리한다.
        if div == "40":
            cur.execute("""DELETE FROM DM_PLN_CFM_MKT_DEMAND_PLAN WHERE DIVISION_ID=:d AND PROJECT_CODE=:pc
                AND NVL(END_CUSTOMER,'-')=NVL(:ec,'-') AND SCM_SITE_ID=:s AND ITEM_ID=:i AND DOM_EXP=:de
                AND FCST_TYPE=:ft AND INCOTERMS=:ic AND MEASURE=:m AND YYYYMMDD=:y""",
                dict(d=div, pc=key["PROJECT_CODE"], ec=key["END_CUSTOMER"], s=key["SCM_SITE_ID"], i=key["ITEM_ID"],
                     de=key["DOM_EXP"], ft=key["FCST_TYPE"], ic=key["INCOTERMS"], m=key["MEASURE"], y=idate))
        else:
            cur.execute("""DELETE FROM DM_PLN_MKT_FCST WHERE DIVISION_ID=:d AND PROJECT_CODE=:pc AND SCM_SITE_ID=:s
                AND ITEM_ID=:i AND DOM_EXP=:de AND FCST_TYPE=:ft AND INCOTERMS=:ic AND MEASURE=:m AND YYYYMMDD=:y""",
                dict(d=key["DIVISION_ID"], pc=key["PROJECT_CODE"], s=key["SCM_SITE_ID"], i=key["ITEM_ID"],
                     de=key["DOM_EXP"], ft=key["FCST_TYPE"], ic=key["INCOTERMS"], m=key["MEASURE"], y=idate))
        con.commit()
        log(f"  [D] 잔존 {cur.rowcount}건 정리(사전 부재분 한정) — 커밋")

    # --- 조회 왕복: GET 재조회로 M 날짜 값 v0 확인
    rows2, _ = get_rows(div)
    r2 = next((x for x in rows2 if all(x.get(k) == key.get(k) for k in
              ("PROJECT_CODE","END_CUSTOMER","SCM_SITE_ID","ITEM_ID","DOM_EXP","FCST_TYPE","INCOTERMS","MEASURE"))), None)
    rt = float(r2.get("D_" + mdate) or 0) if r2 else None
    log(f"  [RT] GET 재조회 D_{mdate} = {rt} (기대 {mval})")
    rt_ok = r2 is not None and abs(rt - mval) < 0.001
    RESULTS.append((div, {"M": m_ok, "I": i_ok, "D": d_ok, "RT": rt_ok}))

# --- 82: 저장 거부 (V82-00)
log("\n===== DIV 82 (저장 거부) =====")
rows82, _ = get_rows("82")
r82 = next((r for r in rows82 if r.get("MEASURE") == "MKT_FCST"), rows82[0] if rows82 else None)
if r82:
    pre82 = ledger_sum("81", r82, WIN[0])  # 82 원장 = DM_PLN_MKT_FCST (81 동일 경로)
    st, out = save(r82, WIN[0], 99, "M"); log(f"  [82] SAVE 시도 {st} {out}")
    post82 = ledger_sum("81", r82, WIN[0])
    blocked = (st == "CALL_ERR") or (out and any("조회 전용" in str(x) or "V82" in str(x) for x in (out if isinstance(out, list) else [out])))
    log(f"  [82] 원장 불변 확인 pre={pre82} post={post82} 차단판정={blocked}")
    RESULTS.append(("82", {"BLOCK": bool(blocked), "LEDGER_SAME": pre82 == post82}))

log("\n===== 종합 =====")
for r in RESULTS:
    log(str(r))
import pathlib
pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\CRUD_ROUNDTRIP_DMF0082_20260807.txt").write_text(
    "\n".join(LOG) + "\n", encoding="utf-8", newline="\n")
con.close()
