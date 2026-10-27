"""[E20261027-DMF0082LASTUPD] 조회 SP 전후 비교 (조회 프로시저만 호출 · Column Set 행은 같은 세션 INSERT 후 ROLLBACK — 커밋 없음)

  python test_before_after.py before   # 적용 전 결과 저장
  python test_before_after.py after    # 적용 후 결과를 적용 전과 비교

변형 = Column Set 그대로(BASE) / + LAST_UPDATED_BY(BY) / + LAST_UPDATE_DATE(DATE) / + 둘 다(BOTH)
기대 (적용 후)
  1. BASE 는 적용 전과 완전히 같다 (두 컬럼 미선택 = 로직 미실행).
  2. BY · DATE · BOTH 는 줄 수 = BASE, 두 컬럼을 뺀 내용(키 + 메저 값) = BASE.
  3. 두 컬럼 값 = 키별 '수정일 최대 행' 의 값 — 정답은 적용 전 BOTH 결과(키 × 수정일 × 수정자로 갈라진 줄)에서
     키마다 수정일 MAX, 그 수정일 줄들의 수정자 MAX 로 독립 계산한다.
"""
import sys, os, pickle, hashlib
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
SNAP = os.path.join(HERE, "_before.pkl")
LU = ("LAST_UPDATED_BY", "LAST_UPDATE_DATE")
VARIANTS = {"BASE": (), "BY": ("LAST_UPDATED_BY",), "DATE": ("LAST_UPDATE_DATE",), "BOTH": LU}
SORTNO = {"LAST_UPDATED_BY": 350, "LAST_UPDATE_DATE": 340}   # SHEET_COLUMNS 메타 순번
PROCS = ["P_DMF0082_GET_MAIN_DATA", "P_DMF0082_GET_MAIN_DATA_CURRENT"]
# (사업부, 시작일, 종료일, 고객, Sales Site, 사용자들)
CASES = [("81", "20260701", "20261231", "ALL", "HKMC_KR_ASA", ["minyonglee1", "k0101"]),
         ("82", "20260701", "20261231", "ALL", "NextEra_US_PHX", ["minyonglee1"]),
         ("40", "20260701", "20270331", "acer", "acer_CN_CKG", ["minyonglee1", "k0101"])]


def is_measure(c):
    return c == "QTY" or c[:2] in ("D_", "W_", "M_")


def call(cur, proc, div, f, t, user, cust, site):
    args = [div, "ALL", cust, "ALL", f, t, site, "", "Current", "N", user, "ADMIN", "ALL", "ALL", "ALL", "ALL"]
    outs = [cur.var(oracledb.DB_TYPE_CURSOR) for _ in range(6)]
    cur.callproc("SCM_MGR.PKG_DMF0082." + proc, args + outs)
    c = outs[0].getvalue()
    cols = [x[0] for x in c.description]
    rows = c.fetchall()
    r = outs[5].getvalue().fetchall() if outs[5].getvalue() else None
    return cols, rows, r


def digest(cols, rows, drop=()):
    idx = [i for i, c in enumerate(cols) if c not in drop]
    names = [cols[i] for i in idx]
    order = sorted(range(len(names)), key=lambda i: names[i])
    h = sorted(hashlib.md5(repr(tuple(r[idx[i]] for i in order)).encode()).hexdigest() for r in rows)
    return tuple(sorted(names)), hashlib.md5("".join(h).encode()).hexdigest()


def keyed(cols, rows):
    """키(두 컬럼 · 메저 제외 컬럼, 이름순) → [(date, by)]"""
    kn = sorted(c for c in cols if c not in LU and not is_measure(c))
    ki = [cols.index(c) for c in kn]
    di = cols.index("LAST_UPDATE_DATE") if "LAST_UPDATE_DATE" in cols else None
    bi = cols.index("LAST_UPDATED_BY") if "LAST_UPDATED_BY" in cols else None
    out = {}
    for r in rows:
        out.setdefault(tuple(r[i] for i in ki), []).append((r[di] if di is not None else None, r[bi] if bi is not None else None))
    return out


def blank(v):
    return v is None or str(v).strip() == ""


def expected(pairs):
    """수정일 MAX(빈값 최하위) → 그 수정일 줄들의 수정자 MAX(None 최하위)"""
    dates = [d for d, _ in pairs if not blank(d)]
    if dates:
        md = max(dates)
        cand = [b for d, b in pairs if d == md]
    else:
        md = None
        cand = [b for _, b in pairs]
    nb = [b for b in cand if b is not None]
    return md, (max(nb) if nb else None)


def main():
    mode = sys.argv[1]
    u, p, d = conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM dual")
    print("DB", d, cur.fetchone(), "mode", mode, flush=True)
    cur.execute("SELECT COUNT(*) FROM all_source WHERE owner='SCM_MGR' AND name='PKG_DMF0082' AND type='PACKAGE BODY' AND text LIKE '%E20261027-DMF0082LASTUPD%'")
    marker = cur.fetchone()[0]
    if (mode == "before") != (marker == 0):
        sys.exit(f"ABORT: mode={mode} 인데 BODY 마커 {marker}곳")
    res = {}
    for proc in PROCS:
        for div, f, t, cust, site, users in CASES:
            for usr in users:
                cur.execute("SELECT COUNT(*) FROM SCM_MGR.SCM_MST_TITLESET_USER WHERE PROGRAM_ID='DMF0082' AND USER_ID=:u "
                            "AND USER_INQUIRY_COLUMN_TYPE_CODE='C' AND COLUMN_NAME IN ('LAST_UPDATED_BY','LAST_UPDATE_DATE')", u=usr)
                if cur.fetchone()[0]:
                    sys.exit(f"ABORT: {usr} Column Set 에 이미 두 컬럼 존재 — BASE 기준 불가")
                for vn, add in VARIANTS.items():
                    for c in add:
                        cur.execute("INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER (USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE, COLUMN_NAME,"
                                    " SORT_ORDER_NO, SUB_TOTAL_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)"
                                    " VALUES (:u, 'DMF0082', 'FcstNPrice', 'C', :c, :s, 'N', 'admin', SYSDATE, 'admin', SYSDATE)",
                                    u=usr, c=c, s=SORTNO[c])
                    cols, rows, rc = call(cur, proc, div, f, t, usr, cust, site)
                    con.rollback()   # Column Set 테스트 행 · 임시 테이블 모두 되돌림
                    res[(proc, div, usr, vn)] = {"cols": cols, "n": len(rows), "full": digest(cols, rows),
                                                 "nolu": digest(cols, rows, LU), "keyed": keyed(cols, rows), "rc": rc}
                    print(f"  {proc[11:]:22s} {div} {usr:12s} {vn:4s} rows {len(rows):6d} cols {len(cols)} result {rc}", flush=True)
    cur.execute("SELECT COUNT(*) FROM SCM_MGR.SCM_MST_TITLESET_USER WHERE PROGRAM_ID='DMF0082' AND USER_INQUIRY_COLUMN_TYPE_CODE='C' "
                "AND COLUMN_NAME IN ('LAST_UPDATED_BY','LAST_UPDATE_DATE')")
    print("잔존 테스트 Column Set 행 (0 이어야 함):", cur.fetchone()[0])
    if mode == "before":
        pickle.dump(res, open(SNAP, "wb"))
        print("BEFORE SAVED", len(res))
        for k in res:
            if k[3] == "BOTH":
                b = res[k[:3] + ("BASE",)]
                print(f"  [적용 전 증상] {k[0][11:]:22s} {k[1]} {k[2]:12s} BASE {b['n']} 줄 → BOTH {res[k]['n']} 줄")
        return
    bef = pickle.load(open(SNAP, "rb"))
    fail = 0
    for proc in PROCS:
        for div, f, t, cust, site, users in CASES:
            for usr in users:
                k0 = (proc, div, usr)
                base_b, base_a = bef[k0 + ("BASE",)], res[k0 + ("BASE",)]
                ok = base_a["full"] == base_b["full"] and base_a["n"] == base_b["n"]
                fail += not ok
                print("PASS" if ok else "FAIL", f"| {proc[11:]:22s} | {div} | {usr:12s} | BASE | rows {base_b['n']} → {base_a['n']} | 적용 전과 동일")
                oracle = {kk: expected(v) for kk, v in bef[k0 + ("BOTH",)]["keyed"].items()}
                keys_ok = set(oracle) == set(base_a["keyed"])
                for vn in ("BY", "DATE", "BOTH"):
                    a = res[k0 + (vn,)]
                    same = a["n"] == base_a["n"] and a["nolu"] == base_a["full"]
                    bad = 0
                    for kk, pairs in a["keyed"].items():
                        if len(pairs) != 1 or kk not in oracle:
                            bad += 1
                            continue
                        dv, bv = pairs[0]
                        ed, eb = oracle[kk]
                        if "LAST_UPDATE_DATE" in VARIANTS[vn] and not ((blank(dv) and ed is None) or dv == ed):
                            bad += 1
                        elif "LAST_UPDATED_BY" in VARIANTS[vn] and bv != eb:
                            bad += 1
                    ok = same and bad == 0 and keys_ok
                    fail += not ok
                    print("PASS" if ok else "FAIL", f"| {proc[11:]:22s} | {div} | {usr:12s} | {vn:4s} | rows 적용전 {bef[k0 + (vn,)]['n']} → 적용후 {a['n']} (BASE {base_a['n']})"
                          f" | 키·메저=BASE {same} | 두 컬럼 값 불일치 키 {bad}/{len(a['keyed'])} | 정답 키집합=BASE {keys_ok}")
    print("RESULT", "PASS" if fail == 0 else f"FAIL {fail}")
    sys.exit(0 if fail == 0 else 1)


if __name__ == "__main__":
    main()
