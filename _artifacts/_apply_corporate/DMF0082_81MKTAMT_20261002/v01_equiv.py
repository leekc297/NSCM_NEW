# -*- coding: utf-8 -*-
"""[E20261002-DMF0082-81MKTAMT] 조회 결과 적용 전/후 대조 (사내 ZIOUI1 · 조회 전용 · 매 회 ROLLBACK).

P_DMF0082_GET_MAIN_DATA / P_DMF0082_GET_MAIN_DATA_CURRENT 의 전 커서 전 행을 저장하고 전/후를 행 단위로 비교한다.
기대: 40·82 = 전 커서 동일 / 81 = MKT_AMT_KRW·MKT_AMT_LOC 를 선택한 사용자만 그 두 메저 행이 변하고(계획구간 값 추가) 나머지는 동일.
사용: python v01_equiv.py cap <tag>      → v01_<tag>.pkl
      python v01_equiv.py diff <A> <B>
"""
import io, sys, time, pickle, pathlib, datetime, collections
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
from ora import conn_info
import oracledb

MODE = sys.argv[1]
AMT = ("MKT_AMT_KRW", "MKT_AMT_LOC")


def norm(v):
    return "" if v is None else str(v)


if MODE == "diff":
    def load(tag):
        o = {}
        for f in sorted((HERE / f"v01_{tag}").glob("*.pkl")):
            o.update(pickle.loads(f.read_bytes()))
        return o
    A, B = load(sys.argv[2]), load(sys.argv[3])
    bad = 0
    for k in A:
        if k not in B:
            print(f"{k:44} (후 채취 없음)"); continue
        for ci, ((ca, ra), (cb, rb)) in enumerate(zip(A[k]["cur"], B[k]["cur"])):
            if ci == 2:   # O_RC3: 조회 시각 포함 — 앞 2컬럼만
                ra, rb = [r[:2] for r in ra], [r[:2] for r in rb]
            ma = collections.Counter(tuple(norm(v) for v in r) for r in ra)
            mb = collections.Counter(tuple(norm(v) for v in r) for r in rb)
            only_a, only_b = ma - mb, mb - ma
            if ca != cb:
                print(f"{k:44} RC{ci+1} ❌ 컬럼 구성 변경"); bad += 1; continue
            if not only_a and not only_b:
                print(f"{k:44} RC{ci+1} 동일  rows {len(ra)}")
                continue
            mi = ca.index("MEASURE") if "MEASURE" in ca else None
            ms_a = collections.Counter(r[mi] if mi is not None else "?" for r in only_a.elements())
            ms_b = collections.Counter(r[mi] if mi is not None else "?" for r in only_b.elements())
            other = [m for m in list(ms_a) + list(ms_b) if m not in AMT]
            flag = "변경(MKT_AMT 만)" if not other else "❌ 타 메저 변경"
            bad += bool(other)
            print(f"{k:44} RC{ci+1} {flag}  rows {len(ra)} → {len(rb)}  사라진 행 {dict(ms_a)}  생긴 행 {dict(ms_b)}")
        print(f"{'':44} SP {A[k]['sp']:.2f}s → {B[k]['sp']:.2f}s")
    print(f"\n예상 밖 변경 {bad}")
    sys.exit(0)

TAG = sys.argv[2]
today = datetime.date.today()
frm = today.replace(day=1)
m = frm.month - 1 + 6
to = datetime.date(frm.year + m // 12, m % 12 + 1, 1) - datetime.timedelta(days=1)
u, p, d = conn_info()
cn = oracledb.connect(user=u, password=p, dsn=d)
cn.call_timeout = 1800000
cur = cn.cursor()


def args_of(proc):
    cur.execute("SELECT ARGUMENT_NAME, IN_OUT FROM USER_ARGUMENTS WHERE PACKAGE_NAME='PKG_DMF0082' AND OBJECT_NAME=:1 AND DATA_LEVEL=0 ORDER BY POSITION", [proc])
    return cur.fetchall()


cur.execute("""SELECT MAX(V.VERSION_NO) FROM DM_MST_VERSION V WHERE V.DIVISION_ID='81' AND V.VERSION_TYPE='MF_W'
                 AND EXISTS (SELECT 1 FROM DM_PLN_MKT_FCST_C C WHERE C.DIVISION_ID='81' AND C.VERSION_NO=V.VERSION_NO AND ROWNUM=1)""")
MF_VER = cur.fetchone()[0]
print("MF 버전:", MF_VER, " 기간:", frm, "~", to, flush=True)

CASES = [("P_DMF0082_GET_MAIN_DATA", "minyonglee1", "40", "Current"),     # 회귀: LOC 1개 선택
         ("P_DMF0082_GET_MAIN_DATA", "minyonglee1", "81", "Current"),
         ("P_DMF0082_GET_MAIN_DATA", "k0101", "81", "Current"),           # 회귀: 9개 선택 · 금액 미선택
         ("P_DMF0082_GET_MAIN_DATA", "eunah.koo", "40", "Current"),       # 금액 선택 사용자 — 40 무변경
         ("P_DMF0082_GET_MAIN_DATA", "eunah.koo", "81", "Current"),       # ★ 대상
         ("P_DMF0082_GET_MAIN_DATA", "eunah.koo", "82", "Current"),       # 82 무변경
         ("P_DMF0082_GET_MAIN_DATA", "eunah.koo", "81_UC", "Current"),    # ★ 81 계열
         ("P_DMF0082_GET_MAIN_DATA", "yooah.chung", "81", "Current"),     # ★ KRW 금액만 선택
         ("P_DMF0082_GET_MAIN_DATA", "eunah.koo", "81", MF_VER),          # ★ 컷오프(MF)
         ("P_DMF0082_GET_MAIN_DATA_CURRENT", "eunah.koo", "81", "CURRENT"),  # ★ CURRENT 프로시저
         ("P_DMF0082_GET_MAIN_DATA_CURRENT", "eunah.koo", "40", "CURRENT")]
ONLY = sys.argv[3:]   # 선택 실행: 케이스 번호(0-base)
(HERE / f"v01_{TAG}").mkdir(exist_ok=True)
for ci_, (proc, user, div, ver) in enumerate(CASES):
    if ONLY and str(ci_) not in ONLY:
        continue
    cf = HERE / f"v01_{TAG}" / f"{ci_:02d}.pkl"
    if cf.exists():
        print(f"{ci_:02d} 이미 채취됨 — skip", flush=True)
        continue
    P = {"P_DIVISION_ID": div, "P_TEAM_ID": "ALL", "P_CUSTOMER": "ALL", "P_BIZ_TYPE": "ALL",
         "P_FROM_YYYYMMDD": frm.strftime("%Y%m%d"), "P_TO_YYYYMMDD": to.strftime("%Y%m%d"),
         "P_SCM_SITE_ID": "ALL", "P_ITEM_ID": None, "P_VERSION_TYPE": ver, "P_QTY_YN": "N",
         "P_CREATED_BY": user, "P_USER_GROUP": "ADMIN", "P_PLANT_SITE_ID": "ALL",
         "P_PROJECT_CODE": "ALL", "P_OWNER": "ALL", "P_SENDER_CODE": "ALL"}
    ins, outs = [], []
    for a_, io_ in args_of(proc):
        (ins.append(P[a_]) if io_ == "IN" else outs.append(cn.cursor()))
    k = f"{proc.replace('P_DMF0082_GET_', '')}/{user}/{div}/{ver}"
    t0 = time.time()
    try:
        cur.callproc("PKG_DMF0082." + proc, ins + outs)
    except oracledb.Error as e:
        print(f"{k:44} 호출 오류: {str(e)[:150]}", flush=True)
        cn.rollback()
        continue
    t1 = time.time()
    cs = []
    for oc in outs:
        try:
            rows = oc.fetchall()
            cols = [c[0] for c in oc.description]
        except oracledb.Error:
            rows, cols = [], []
        cs.append((cols, rows))
    cn.rollback()
    cf.write_bytes(pickle.dumps({k: {"cur": cs, "sp": t1 - t0}}))
    c1, r1 = cs[0]
    amt = sum(1 for r in r1 if "MEASURE" in c1 and r[c1.index("MEASURE")] in AMT)
    print(f"{k:44} SP {t1 - t0:6.2f}s rows {[len(r) for _, r in cs]}  RC1 MKT_AMT 행 {amt}", flush=True)
cn.close()
