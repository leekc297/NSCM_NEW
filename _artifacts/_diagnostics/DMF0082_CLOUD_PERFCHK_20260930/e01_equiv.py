# -*- coding: utf-8 -*-
"""GET_MAIN_DATA 결과 6커서 전행 SHA 채취 — 적용 전/후 동등성 (사내 ZIOUI1 · 매 회 ROLLBACK).

매트릭스 = 사용자 2 (minyonglee1 = LOC 1개 / k0101 = CUST_FCST 포함 9개) × division 40·81·82 × Current.
사용: python e01_equiv.py <tag>            → e01_<tag>.json 저장 (before / after …)
      python e01_equiv.py diff [A] [B]     → e01_A vs e01_B 비교 (기본 before after)
주의: e01_before_raw.json / e01_after_raw.json = 정규화 도입 전 채취본 (O_RC3 시각·O_RC4 동순위 순서 포함)
"""
import io, sys, json, time, hashlib, pathlib, datetime
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent))
from ora import conn_info
import oracledb

TAG = sys.argv[1] if len(sys.argv) > 1 else "before"
if TAG == "diff":
    ta = sys.argv[2] if len(sys.argv) > 2 else "before"
    tb = sys.argv[3] if len(sys.argv) > 3 else "after"
    a = json.loads((HERE / f"e01_{ta}.json").read_text(encoding="utf-8"))
    b = json.loads((HERE / f"e01_{tb}.json").read_text(encoding="utf-8"))
    fail = 0
    for k in a:
        same = a[k]["sha"] == b[k]["sha"]
        fail += not same
        print(f"{k:22} {'PASS' if same else 'FAIL'}  rows {a[k]['rows']} → {b[k]['rows']}  "
              f"SP {a[k]['sp']:.2f}s → {b[k]['sp']:.2f}s  fetch {a[k]['fetch']:.2f}s → {b[k]['fetch']:.2f}s")
    print(f"\nFAIL {fail} / {len(a)}")
    sys.exit(0)

today = datetime.date.today()
frm = today.replace(day=1)
m = frm.month - 1 + 6
to = datetime.date(frm.year + m // 12, m % 12 + 1, 1) - datetime.timedelta(days=1)
u, p, d = conn_info()
cn = oracledb.connect(user=u, password=p, dsn=d)
cn.call_timeout = 1800000
cur = cn.cursor()
cur.execute("SELECT ARGUMENT_NAME, IN_OUT FROM USER_ARGUMENTS WHERE PACKAGE_NAME='PKG_DMF0082'"
            " AND OBJECT_NAME='P_DMF0082_GET_MAIN_DATA' AND DATA_LEVEL=0 ORDER BY POSITION")
ARGS = cur.fetchall()
out = {}
for user in ("minyonglee1", "k0101"):
    for div in ("40", "81", "82"):
        P = {"P_DIVISION_ID": div, "P_TEAM_ID": "ALL", "P_CUSTOMER": "ALL", "P_BIZ_TYPE": "ALL",
             "P_FROM_YYYYMMDD": frm.strftime("%Y%m%d"), "P_TO_YYYYMMDD": to.strftime("%Y%m%d"),
             "P_SCM_SITE_ID": "ALL", "P_ITEM_ID": None, "P_VERSION_TYPE": "Current", "P_QTY_YN": "N",
             "P_CREATED_BY": user, "P_USER_GROUP": "ADMIN", "P_PLANT_SITE_ID": "ALL",
             "P_PROJECT_CODE": "ALL", "P_OWNER": "ALL", "P_SENDER_CODE": "ALL"}
        ins, outs = [], []
        for a_, io_ in ARGS:
            (ins.append(P[a_]) if io_ == "IN" else outs.append(cn.cursor()))
        t0 = time.time()
        cur.callproc("PKG_DMF0082.P_DMF0082_GET_MAIN_DATA", ins + outs)
        t1 = time.time()
        shas, rows = [], []
        for i, oc in enumerate(outs):
            try:
                data = oc.fetchall()
            except oracledb.Error:
                data = []
            # 정규화 2종 (기존 동작 — 비교 대상 아님): O_RC3 TODAY_TIME = 조회 시각(HHMI) 제외 /
            #   O_RC4 = ORDER BY MEASURE 동순위(SCM_FCST 요일 2행) 순서 비결정 → 정렬 비교. 그 외 커서는 행 순서까지 비교.
            if i == 2:
                data = [r[:2] for r in data]
            if i == 3:
                data = sorted(data, key=lambda r: tuple("" if v is None else str(v) for v in r))
            txt = "\n".join("|".join("" if v is None else str(v) for v in r) for r in data)
            shas.append(hashlib.sha256(txt.encode()).hexdigest()[:16]); rows.append(len(data))
        t2 = time.time()
        cn.rollback()
        k = f"{user}/{div}"
        out[k] = {"sha": shas, "rows": rows, "sp": t1 - t0, "fetch": t2 - t1}
        print(f"{k:22} SP {t1 - t0:6.2f}s fetch {t2 - t1:5.2f}s rows {rows}")
(HERE / f"e01_{TAG}.json").write_text(json.dumps(out, ensure_ascii=False, indent=1), encoding="utf-8")
cn.close()
