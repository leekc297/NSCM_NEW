"""[E20261026-DMF0082-MKTAMTAUDIT] 적용 전/후 실호출 비교 — 조회 전용(커밋 없음)

  python verify_mktamt_audit.py before   # verify_before.json
  python verify_mktamt_audit.py after    # verify_after.json + before 비교

화면 컬럼 원천 (원문 확인)
  GET_MAIN_DATA         : 최종 = GT_DMF0082_MF_SP.CREATE_DATE → LAST_UPDATE_DATE / .LAST_UPDATED_BY (본문 5281)
  GET_MAIN_DATA_CURRENT : 최종 = GTT_TEMPFCSTNPRICE.CREATE_DATE → LAST_UPDATE_DATE / .LAST_UPDATED_BY (본문 10273)
  → 사용자 컬럼 설정(titleset)에 두 컬럼이 없어도 이 세션 GTT 값으로 화면 값을 판정할 수 있다 (titleset 무변경).

판정
  ① 금액 메저(MKT_AMT_KRW/LOC) 행의 CREATE_DATE·LAST_UPDATED_BY — before 공란 → after 전 행 채움
  ② 회귀 0 — 결과 커서(O_RC1) 전 행·전 컬럼 해시 before == after (감사 컬럼은 titleset 미포함이라 출력에 없음)
             + 금액 외 메저 GTT 행의 두 컬럼 해시 before == after
"""
import sys, os, io, json, hashlib, datetime
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
DIV = "81"
USERS = [("eunah.koo", "DM Planner"),   # titleset 에 MKT_AMT_KRW·MKT_AMT_LOC 보유 (사내 실측)
         ("minyonglee1", "ADMIN")]      # 금액 메저 미선택 — 회귀 확인용

u, p, d = conn_info()
cn = oracledb.connect(user=u, password=p, dsn=d)
cn.call_timeout = 1800000
cur = cn.cursor()

today = datetime.date.today()
frm = today.replace(day=1)
m = frm.month - 1 + 6
to = datetime.date(frm.year + m // 12, m % 12 + 1, 1) - datetime.timedelta(days=1)
FRM, TO = frm.strftime("%Y%m%d"), to.strftime("%Y%m%d")


def latest(vtype):
    cur.execute("SELECT MAX(VERSION_NO) KEEP (DENSE_RANK LAST ORDER BY YYYYMMDD) FROM DM_MST_VERSION WHERE DIVISION_ID=:d AND VERSION_TYPE=:t", d=DIV, t=vtype)
    r = cur.fetchone()
    return r[0] if r else None


vers = [v for v in (latest("MF_W"), latest("SF_W")) if v]
SCEN = [("P_DMF0082_GET_MAIN_DATA", "Current", "GT_DMF0082_MF_SP"),
        ("P_DMF0082_GET_MAIN_DATA_CURRENT", "Current", "GTT_TEMPFCSTNPRICE")]
# ⚠ Current+MF/SF 버전 조회는 수정 전 원본에서도 MF 금액 arm(본문 2715 INSERT, DM_PLN_SALES_PLAN_C) 이 30분 초과(DPY-4024)
#   → 실호출 비교에서 제외. MF/SF 2개 arm 은 verify_version_arm.py(원천 집계 단독 실행)로 검증.


def run(proc, ver, user, grp, gtt):
    outs = [cn.cursor() for _ in range(6)]
    args = [DIV, "ALL", "ALL", "ALL", FRM, TO, "ALL", None, ver, "N", user, grp, "ALL", "ALL", "ALL", "ALL"]
    cur.callproc(f"SCM_MGR.PKG_DMF0082.{proc}", args + outs)
    oc = outs[0]
    oc.arraysize = 5000
    rows = oc.fetchall() if oc.description else []
    h_out = hashlib.sha256("\n".join(sorted(repr(tuple(r)) for r in rows)).encode()).hexdigest()[:16]
    for o in outs:
        try: o.close()
        except Exception: pass
    # 같은 세션 GTT — 금액 행 / 그 외 행
    cur.execute(f"""SELECT MEASURE, COUNT(*) N
                         , SUM(CASE WHEN CREATE_DATE IS NOT NULL AND LAST_UPDATED_BY IS NOT NULL THEN 1 ELSE 0 END) N_FILLED
                         , TO_CHAR(MAX(CREATE_DATE),'YYYY-MM-DD HH24:MI:SS'), MAX(LAST_UPDATED_BY)
                      FROM SCM_MGR.{gtt} WHERE MEASURE IN ('MKT_AMT_KRW','MKT_AMT_LOC') GROUP BY MEASURE ORDER BY 1""")
    amt = [list(r) for r in cur.fetchall()]
    cur.execute(f"""SELECT MEASURE, TO_CHAR(CREATE_DATE,'YYYYMMDDHH24MISS'), LAST_UPDATED_BY FROM SCM_MGR.{gtt}
                     WHERE MEASURE NOT IN ('MKT_AMT_KRW','MKT_AMT_LOC')""")
    other = cur.fetchall()
    h_other = hashlib.sha256("\n".join(sorted(repr(tuple(r)) for r in other)).encode()).hexdigest()[:16]
    cn.rollback()
    return {"out_rows": len(rows), "out_hash": h_out, "gtt_amt": amt, "gtt_other_rows": len(other), "gtt_other_hash": h_other}


mode = sys.argv[1] if len(sys.argv) > 1 else "before"
res = {}
print(f"DIV={DIV} 기간 {FRM}~{TO} 버전 {vers}")
for user, grp in USERS:
    for proc, ver, gtt in SCEN:
        k = f"{user}|{proc}|{ver}"
        s = run(proc, ver, user, grp, gtt)
        res[k] = s
        print(f"[{mode}] {k}: 출력 {s['out_rows']}행 해시 {s['out_hash']} · 금액행(GTT) {s['gtt_amt']} · 그 외 {s['gtt_other_rows']}행 해시 {s['gtt_other_hash']}")
json.dump(res, open(os.path.join(HERE, f"verify_{mode}.json"), "w", encoding="utf-8"), ensure_ascii=False, indent=1)
if mode == "after" and os.path.exists(os.path.join(HERE, "verify_before.json")):
    b = json.load(open(os.path.join(HERE, "verify_before.json"), encoding="utf-8"))
    ok = True
    for k, a in res.items():
        bb = b.get(k)
        reg = bool(bb) and bb["out_rows"] == a["out_rows"] and bb["out_hash"] == a["out_hash"] \
              and bb["gtt_other_rows"] == a["gtt_other_rows"] and bb["gtt_other_hash"] == a["gtt_other_hash"]
        fixed = all(r[1] == r[2] for r in a["gtt_amt"])
        b_fill = [r[2] for r in bb["gtt_amt"]] if bb else "-"
        ok &= reg and fixed
        print(f"  {'PASS' if reg and fixed else 'FAIL'} {k}: 회귀0={reg} · 금액행 채움 before {b_fill} → after {[f'{r[2]}/{r[1]}' for r in a['gtt_amt']]}")
    print("RESULT:", "ALL PASS" if ok else "FAIL 있음")
cn.close()
