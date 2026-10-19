# -*- coding: utf-8 -*-
"""[E20261006-ASISDELTA] PKG_DMF0022 워터폴 조회 결과 캡처·비교 (조회 SP 호출 — 원장 변경 없음)

사용: python t22_capture.py BEFORE | AFTER      # 케이스별 rc1 전행 덤프
비교: python t22_capture.py --cmp BEFORE AFTER
  · 82 사업부 = 전행 일치여야 한다 (이번 변경은 81% 만 대상)
  · 81% 사업부     = CELL_PROD_SITE_ID / FROM_SITE_ID 값과 그에 따른 행 분리만 달라져야 한다 (수량 합계 동일)

조회 계정 = 'Sales Plan Waterfall' 메저 설정이 이미 있는 계정 (없으면 SP 가 기본 설정 행을 넣는다 — 호출 전 assert).
"""
import decimal, hashlib, io, json, os, sys, time

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace", line_buffering=True)
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")

HERE = os.path.dirname(os.path.abspath(__file__))
USER = "minyonglee1"
VER = "SP_W_20260827_V001"
FROM_D, NOW_D, TO_D = "20260803", "20261005", "20270328"
# 변경식은 DIVISION_ID 가 81 로 시작할 때만 값이 달라진다 ('40' = 전·후 모두 참, '82' = 전·후 모두 거짓).
#   → 81 계열 전·후 비교가 본 검증이고, 82 는 불변 확인용 1건만 둔다.
#   (40 은 논리상 불변 · 2026-10-06 사내 DB 디스크 읽기 지연으로 1케이스 10분 초과 → 케이스 축소)
CASES = [("C1 div82 CURRENT", "82", "CURRENT"),
         ("C2 div81_UC CUR+SP_W", "81_UC", "CURRENT," + VER),
         ("C3 div81 CURRENT", "81", "CURRENT"),
         ("C4 div81 SP_W", "81", VER)]
SITE_COLS = ("CELL_PROD_SITE_ID", "FROM_SITE_ID")


def cell(v):
    if v is None:
        return None
    if isinstance(v, decimal.Decimal):
        return format(v.normalize(), "f")
    return str(v)


def capture(tag):
    import oracledb
    from ora import conn_info
    u, p, d = conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()
    cur.execute("SELECT COUNT(*) FROM SCM_MGR.SCM_MST_TITLESET_USER WHERE PROGRAM_ID='DMF0035' "
                "AND SHEET_NAME='Sales Plan Waterfall' AND USER_INQUIRY_COLUMN_TYPE_CODE='M' AND USER_ID=:u", u=USER)
    assert cur.fetchone()[0] > 0, "조회 계정에 메저 설정 없음 — SP 가 기본 행을 넣게 되므로 중단"
    out = {}
    for label, div, ver in CASES:
        o = [con.cursor() for _ in range(3)]
        t0 = time.time()
        cur.callproc("SCM_MGR.PKG_DMF0022.P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL", [
            div, "ALL", "ALL", "ALL", "", "", "ALL", FROM_D, NOW_D, TO_D,
            USER, "ALL", "ALL", "", "N", "N", ver, "MONTHLY", "", "ADMIN", USER, "DMF0035"] + o)
        c = o[0]
        cols = [x[0] for x in c.description]
        rows = [[cell(v) for v in r] for r in c.fetchall()]
        rows.sort(key=lambda r: json.dumps(r, ensure_ascii=False))
        res = [cell(v) for v in o[2].fetchone()]
        out[label] = {"cols": cols, "rows": rows, "result": res}
        print(f"[{tag}] {label:22s} 행수={len(rows):7d} 컬럼수={len(cols):3d} 결과={res} {time.time()-t0:6.1f}s")
        con.rollback()
    json.dump(out, open(os.path.join(HERE, f"cap22_{tag}.json"), "w", encoding="utf-8"), ensure_ascii=False)
    con.close()


def num(v):
    try:
        return decimal.Decimal(v)
    except Exception:
        return None


def compare(a, b):
    A = json.load(open(os.path.join(HERE, f"cap22_{a}.json"), encoding="utf-8"))
    B = json.load(open(os.path.join(HERE, f"cap22_{b}.json"), encoding="utf-8"))
    ok = True
    summary = {}
    for label, div, _ in CASES:
        ra, rb = A[label], B[label]
        same_cols = ra["cols"] == rb["cols"]
        ha = hashlib.md5(json.dumps(ra["rows"], ensure_ascii=False).encode()).hexdigest()
        hb = hashlib.md5(json.dumps(rb["rows"], ensure_ascii=False).encode()).hexdigest()
        ident = same_cols and ha == hb
        line = f"{label:22s} 행수 {len(ra['rows']):7d} → {len(rb['rows']):7d}  컬럼 {'동일' if same_cols else '상이'}  "
        info = {"rows_before": len(ra["rows"]), "rows_after": len(rb["rows"]), "identical": ident}
        if not div.startswith("81"):
            ok &= ident
            print(line + ("전행 일치 PASS" if ident else "⚠ 불일치 FAIL (40/82 는 달라지면 안 됨)"))
        else:
            # 81%: 사이트 컬럼을 뺀 나머지 컬럼의 값별 합계(숫자 컬럼)가 같아야 한다
            cols = ra["cols"]
            site_idx = [i for i, c in enumerate(cols) if c in SITE_COLS]
            meas_i = cols.index("MEASURE") if "MEASURE" in cols else None

            def agg(rows):
                tot = {}
                for r in rows:
                    for i, v in enumerate(r):
                        n = num(v)
                        if n is None or i in site_idx:
                            continue
                        k = (r[meas_i] if meas_i is not None else "", cols[i])
                        tot[k] = tot.get(k, decimal.Decimal(0)) + n
                return tot
            # 합계 비교는 수량 메저만 (단가·평균 메저는 행이 나뉘면 합이 달라지는 것이 정상)
            ta, tb = agg(ra["rows"]), agg(rb["rows"])
            diff_keys = sorted(k for k in set(ta) | set(tb) if ta.get(k) != tb.get(k))
            diff_meas = sorted({k[0] for k in diff_keys})
            site_vals_a = sorted({r[i] or "" for r in ra["rows"] for i in site_idx})
            site_vals_b = sorted({r[i] or "" for r in rb["rows"] for i in site_idx})
            info.update(site_cols=[cols[i] for i in site_idx], site_before=site_vals_a, site_after=site_vals_b,
                        sum_diff_measures=diff_meas)
            print(line + ("전행 일치(변화 없음)" if ident else "변경 있음"))
            print(f"     사이트 컬럼 {[cols[i] for i in site_idx]}  값 종류 {site_vals_a} → {site_vals_b}")
            print(f"     합계가 달라진 메저: {diff_meas if diff_meas else '없음'}")
            if not same_cols:
                ok = False
        summary[label] = info
    json.dump(summary, open(os.path.join(HERE, f"cmp22_{a}_{b}.json"), "w", encoding="utf-8"), ensure_ascii=False, indent=1)
    print("\n40/82 불변 검증:", "PASS" if ok else "FAIL")
    return ok


if __name__ == "__main__":
    if sys.argv[1] == "--cmp":
        sys.exit(0 if compare(sys.argv[2], sys.argv[3]) else 1)
    capture(sys.argv[1])
