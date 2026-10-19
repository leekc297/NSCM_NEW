"""[E20261006-ITEMGT] 검증 스크립트 (원장 무변경 방식)

  python t01_test.py load    # 적재 구문 단독 실행 — 사업부별 건수·소요시간, 뷰(활성) 대비 품목 집합·컬럼값 비교 (세션 임시테이블만, ROLLBACK)
  python t01_test.py clone   # 비교용 복제 패키지 PKG_DMF0003_TB 생성 = 10-02 원문(뷰 직접 조회판)
  python t01_test.py cases   # 저장 SP 호출 비교 — 검증 3종 (대표 SHIP-TO 없는 사이트 입력 → 반드시 중단, 호출마다 ROLLBACK)
  python t01_test.py cases3  # 〃 단가 검증 제외 Fcst Type(SMF) 으로 뒤 검증까지 도달
  python t01_test.py rtf     # RTF_SYS_RP 삭제/생성 4문장 대상 건수 — 뷰 기준 vs 임시테이블 기준 (조회만)
  python t01_test.py drop    # 복제 패키지 삭제

복제 패키지 원문 = _unguarded_base_body.txt (build 시 현재 DB 원문에서 ASISPARITY 삽입분만 제거한 것 · md5 == BASE_MD5 확인).
검증 전용 임시 객체라 FRESH-GATE 대상 아님 — SPEC 은 ALL_SOURCE 에서 지금 읽는다.
"""
import sys, os, re, json, time
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import build_apply as B
import oracledb

HERE = B.HERE
CLONE = "PKG_DMF0003_TB"
FT = None
USER_ID = "minyonglee1"
COLS = ["ITEM_NAME", "ITEM_CLASS", "ITEM_CLASS_NAME", "NICK_NAME", "ITEM_TYPE", "MATERIAL_CLASS_NAME", "ITEM_UOM", "SPEC", "MDM_PROJECT_NAME",
        "MIN_CAPACITY", "FORECAST_INFO_BIZ_TYPE", "FORECAST_INFO_PRODUCT_GROUP", "FORECAST_INFO_CELL_MODEL", "FORECAST_INFO_CELL_PACK_COUNT",
        "FORECAST_INFO_SPEC", "FORECAST_INFOR_VERSION", "ACTIVE_FLAG", "CELL_TYPE", "ENERGE", "CELL_QUANTITY", "SCP_EXTRA_SPEC"]


def q(cur, sql, **b):
    cur.execute(sql, **b)
    return cur.fetchall()


def load_stmts(src=None):
    """적재 4문장 — src 가 있으면 DB 원문에서, 없으면 빌더 상수에서"""
    if src is None:
        txt = B.LOAD_BLOCK
    else:
        txt = src[src.index(B.LOAD_START):src.index(B.LOAD_END)]
    body = "\n".join(l for l in txt.split("\n") if not l.strip().startswith("--"))
    st = [s.strip() for s in body.split(";") if s.strip()]
    assert len(st) == 4 and all(s.startswith("INSERT INTO SCM_MGR.GT_DMF3_ITEM_SINGLE_") for s in st), [s[:50] for s in st]
    return st


def clear(cur):
    for g in B.GTS + ["GT_DMF3_RESULTS", "GT_DMF3_ITEM_SINGLE_V"]:
        cur.execute("DELETE FROM SCM_MGR." + g)


def load():
    out = []
    with B.connect() as con:
        cur = con.cursor()
        cur.execute("ALTER SESSION SET optimizer_dynamic_sampling = 2")
        src = B.read_source(cur)["src"]
        st = load_stmts(src if B.MARK in src else None)
        print("적재 구문 출처:", "DB 원문" if B.MARK in src else "빌더(적용 전)")
        for div in ("40", "82", "81", "11", "81_UC"):
            clear(cur)
            cur.execute("""INSERT INTO SCM_MGR.GT_DMF3_RESULTS (V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_PLANT_SITE_ID, V_ACTIVE_FLAG, V_YYYYMMDD, V_QTY)
                           VALUES (:d, '-', '-', '-', '-', '-', '-', '-', 'M', '20991231', 1)""", d=div)
            t0 = time.time()
            cnt = []
            for s in st:
                cur.execute(s)
                cnt.append(cur.rowcount)
            sec = round(time.time() - t0, 2)
            view_y = q(cur, "SELECT COUNT(*) FROM SCM_MGR.DM_MST_ITEM_SINGLE_V WHERE DIVISION_ID = :d AND ACTIVE_FLAG = 'Y'", d=div)[0][0]
            view_all = q(cur, "SELECT COUNT(*) FROM SCM_MGR.DM_MST_ITEM_SINGLE_V WHERE DIVISION_ID = :d", d=div)[0][0]
            only_gt = q(cur, """SELECT COUNT(*) FROM SCM_MGR.GT_DMF3_ITEM_SINGLE_V_ALL G WHERE NOT EXISTS
                                (SELECT 1 FROM SCM_MGR.DM_MST_ITEM_SINGLE_V V WHERE V.DIVISION_ID = G.DIVISION_ID AND V.ITEM_ID = G.ITEM_ID AND V.ACTIVE_FLAG = 'Y' AND V.DIVISION_ID = :d)""", d=div)[0][0]
            only_view = q(cur, """SELECT COUNT(*) FROM SCM_MGR.DM_MST_ITEM_SINGLE_V V WHERE V.DIVISION_ID = :d AND V.ACTIVE_FLAG = 'Y' AND NOT EXISTS
                                  (SELECT 1 FROM SCM_MGR.GT_DMF3_ITEM_SINGLE_V_ALL G WHERE G.DIVISION_ID = V.DIVISION_ID AND G.ITEM_ID = V.ITEM_ID)""", d=div)[0][0]
            dup = q(cur, "SELECT COUNT(*) FROM (SELECT 1 FROM SCM_MGR.GT_DMF3_ITEM_SINGLE_V_ALL GROUP BY DIVISION_ID, ITEM_ID HAVING COUNT(*) > 1)")[0][0]
            sel = ", ".join(f"SUM(CASE WHEN DECODE(TO_CHAR(G.{c}), TO_CHAR(V.{c}), 0, 1) = 1 THEN 1 ELSE 0 END)" for c in COLS)
            diff = q(cur, f"""SELECT {sel} FROM SCM_MGR.GT_DMF3_ITEM_SINGLE_V_ALL G JOIN SCM_MGR.DM_MST_ITEM_SINGLE_V V
                              ON V.DIVISION_ID = G.DIVISION_ID AND V.ITEM_ID = G.ITEM_ID WHERE V.DIVISION_ID = :d""", d=div)[0]
            rec = {"div": div, "rows_ORI_A_B_VALL": cnt, "seconds": sec, "view_active": view_y, "view_all": view_all,
                   "only_in_gt": only_gt, "only_in_view_active": only_view, "dup_keys": dup,
                   "column_value_diff": {c: int(n) for c, n in zip(COLS, diff) if n}}
            print(rec)
            out.append(rec)
            con.rollback()
        clear(cur)
        con.commit()
    json.dump(out, open(os.path.join(HERE, "_test_load.json"), "w", encoding="utf-8"), indent=1, ensure_ascii=False)


def clone():
    base = open(os.path.join(HERE, "_unguarded_base_body.txt"), encoding="utf-8").read()
    assert B.md5(base) == B.BASE_MD5, "기준본 md5 불일치"
    with B.connect() as con:
        cur = con.cursor()
        assert not q(cur, "SELECT 1 FROM all_objects WHERE owner='SCM_MGR' AND object_name=:n", n=CLONE), "복제 패키지 이미 존재"
        cur.execute("SELECT text FROM all_source WHERE owner='SCM_MGR' AND name='PKG_DMF0003' AND type='PACKAGE' ORDER BY line")
        spec = "".join(r[0] for r in cur)

        def rename(src, body):
            head = r'PACKAGE\s+BODY\s+"?PKG_DMF0003"?' if body else r'PACKAGE\s+"?PKG_DMF0003"?'
            new, n = re.subn(head, ("PACKAGE BODY " if body else "PACKAGE ") + CLONE, src, count=1)
            assert n == 1
            new, n = re.subn(r"END\s+PKG_DMF0003\s*;\s*$", "END " + CLONE + ";", new.rstrip(), count=1)
            assert n == 1
            return new
        cur.execute("CREATE OR REPLACE " + rename(spec, False))
        cur.execute("CREATE OR REPLACE " + rename(base, True))
        print(q(cur, "SELECT object_type, status FROM all_objects WHERE owner='SCM_MGR' AND object_name=:n ORDER BY 1", n=CLONE),
              "errors", q(cur, "SELECT COUNT(*) FROM all_errors WHERE owner='SCM_MGR' AND name=:n", n=CLONE)[0][0])


def drop():
    with B.connect() as con:
        cur = con.cursor()
        cur.execute("DROP PACKAGE SCM_MGR." + CLONE)
        print("dropped", q(cur, "SELECT COUNT(*) FROM all_objects WHERE owner='SCM_MGR' AND object_name=:n", n=CLONE)[0][0])


NOSHIP = """NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_SITE_CUSTOMER X WHERE X.DIVISION_ID = SI.DIVISION_ID
                         AND X.SCM_SITE_ID = SI.SCM_SITE_ID AND X.VALID_YN = 'Y' AND X.REP_YN = 'Y')"""
SEL = """SELECT SI.DIVISION_ID, SI.PROJECT_CODE, SI.SCM_SITE_ID, SI.ITEM_ID
         FROM SCM_MGR.SCM_MST_SITE_ITEM SI WHERE SI.DIVISION_ID = :d AND SI.VALID_YN = 'Y' AND SI.PROJECT_CODE <> '-'
           AND SI.SALES_PLAN_ADJUST_YN = 'N' /* 단가 검증 제외 대상 — 그 뒤 검증까지 도달시키기 위함 */ AND """ + NOSHIP
ATTR = """SELECT DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID FROM SCM_MGR.DM_PLN_MKT_FCST
          WHERE DIVISION_ID=:a AND PROJECT_CODE=:b AND SCM_SITE_ID=:c AND ITEM_ID=:e AND MEASURE='MKT_FCST' AND FCST_TYPE <> 'RMA' AND ROWNUM = 1"""
ACTIVE = "EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_ITEM_SN K WHERE K.DIVISION_ID = SI.DIVISION_ID AND K.ITEM_ID = SI.ITEM_ID AND K.ACTIVE_FLAG = 'Y'"

CASES = {
    # BOM 없음 (활성 P/H 품목)
    "BOM": ("BOM does not exist", SEL + """
          AND NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_BOM_ENG_SN X WHERE X.DIVISION_ID = SI.DIVISION_ID AND X.PARENT_ITEM_ID = SI.ITEM_ID)
          AND """ + ACTIVE + """ AND K.ITEM_TYPE IN ('P','H'))
          AND ROWNUM <= 60"""),
    # 81 환산정보 — Cell/Module/Pack 품목인데 CELL_PER_CAR 없음
    "81_CELLCAR": ("does not exist", SEL + """
          AND NVL(SI.CELL_PER_CAR, 0) = 0
          AND """ + ACTIVE + """ AND (K.ITEM_CLASS_NAME LIKE '%Cell%' OR K.ITEM_CLASS_NAME LIKE '%Module%' OR K.ITEM_CLASS_NAME LIKE '%Pack%'))
          AND ROWNUM <= 60"""),
    # 81 항목 — CELL_PER_CAR 는 있으나 Kwh/Cell(ATTRIBUTE8) 없음, 제품(P)
    "81_KWH": ("Sales Site Project Model", SEL + """
          AND NVL(SI.CELL_PER_CAR, 0) > 0 AND SI.ATTRIBUTE8 IS NULL
          AND """ + ACTIVE + """ AND K.ITEM_TYPE = 'P')
          AND ROWNUM <= 60"""),
}
PLAN = [("BOM", "82"), ("BOM", "40"), ("BOM", "81"), ("81_CELLCAR", "81"), ("81_KWH", "81")]
OUT = os.path.join(HERE, "_test_cases.json")


def call(cur, pkg, row, ymd):
    d, prj, site, item, dom, ft, inco, plant = row
    rc1, rc = cur.var(oracledb.DB_TYPE_CURSOR), cur.var(oracledb.DB_TYPE_CURSOR)
    args = ["M", d, prj, site, item, dom or "E", FT or ft or "FCST", inco or "FOB", "MKT_FCST", plant or "-", ymd, "1", USER_ID, "ALL", "W", None, rc1, rc]
    t0 = time.time()
    cur.callproc(f"SCM_MGR.{pkg}.P_DMF0003_SAVE_MKT_FCST", args)
    res = rc.getvalue().fetchall()
    cur.connection.rollback()
    return ([str(x) for x in res[0]] if res else None), round(time.time() - t0, 2)


def fingerprint(cur, row):
    return q(cur, """SELECT COUNT(*), NVL(SUM(QTY),0), TO_CHAR(MAX(LAST_UPDATE_DATE),'YYYY-MM-DD HH24:MI:SS') FROM SCM_MGR.DM_PLN_MKT_FCST
                     WHERE DIVISION_ID=:a AND PROJECT_CODE=:b AND SCM_SITE_ID=:c AND ITEM_ID=:e""", a=row[0], b=row[1], c=row[2], e=row[3])[0]


def cases():
    out = []
    with B.connect() as con:
        cur = con.cursor()
        assert q(cur, "SELECT COUNT(*) FROM all_objects WHERE owner='SCM_MGR' AND object_name=:n AND status='VALID'", n=CLONE)[0][0] == 2, "복제 패키지 필요"
        start, ymd = q(cur, "SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS'), TO_CHAR(NEXT_DAY(TRUNC(SYSDATE),'MONDAY'),'YYYYMMDD') FROM DUAL")[0]
        print("start", start, "test date", ymd)
        for name, div in PLAN:
            target, sql = CASES[name]
            raw = q(cur, sql, d=div)
            cands = []
            for r in raw:
                at = q(cur, ATTR, a=r[0], b=r[1], c=r[2], e=r[3])
                cands.append(tuple(r) + (tuple(at[0]) if at else (None, None, None, None)))
            cands.sort(key=lambda r: r[4] is None)
            cands = cands[:10]
            print(f"\n[{name} / {div}] 후보 {len(cands)}")
            done = 0
            for row in cands:
                # 안전 조건 재확인: 대표 SHIP-TO 없음 (어느 판이든 SHIP-TO 검증에서 반드시 중단 → 원장 무기록)
                assert q(cur, "SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SITE_CUSTOMER WHERE DIVISION_ID=:a AND SCM_SITE_ID=:b AND VALID_YN='Y' AND REP_YN='Y'",
                         a=row[0], b=row[2])[0][0] == 0
                fp0 = fingerprint(cur, row)
                before, tb = call(cur, CLONE, row, ymd)
                hit = bool(before) and target in before[1] and "SHIP-TO" not in before[1]
                rec = {"case": name, "div": div, "key": list(row[:4]), "before": before, "sec_before": tb, "target_hit": hit}
                if hit:
                    after, ta = call(cur, "PKG_DMF0003", row, ymd)
                    fp1 = fingerprint(cur, row)
                    rec.update(after=after, sec_after=ta, same_result=(before == after), ledger_same=(fp0 == fp1))
                    assert after and after[0] != "0", "수정 후 호출이 성공(저장)으로 끝남 — 즉시 확인 필요"
                    done += 1
                print("  ", rec["key"], "| 전:", (before or ["", ""])[1][:60].replace("\n", " "), f"({tb}s)",
                      "| 후:", (rec.get("after") or ["", ""])[1][:60].replace("\n", " "), f"({rec.get('sec_after')}s)", "| 동일:", rec.get("same_result"))
                out.append(rec)
                if done >= 2:
                    break
        touched = q(cur, "SELECT COUNT(*) FROM SCM_MGR.DM_PLN_MKT_FCST WHERE LAST_UPDATE_DATE >= TO_DATE(:s,'YYYY-MM-DD HH24:MI:SS') AND (LAST_UPDATED_BY = :u OR CREATED_BY = :u)",
                    s=start, u=USER_ID)[0][0]
        print("\n테스트 계정으로 테스트 시작 이후 변경된 원장 행:", touched)
    json.dump({"start": start, "date": ymd, "ledger_rows_touched": touched, "cases": out}, open(OUT, "w", encoding="utf-8"), indent=1, ensure_ascii=False)


def cases3():
    """단가 검증 제외 Fcst Type 'SMF' 사용 + SALES_PLAN_ADJUST_YN 조건 해제 — 81 항목 검증·40 BOM 검증 도달용"""
    global FT, PLAN, OUT
    FT = "SMF"
    for k, (t, sql) in list(CASES.items()):
        CASES[k] = (t, sql.replace("AND SI.SALES_PLAN_ADJUST_YN = 'N'", "AND 1 = 1"))
    PLAN = [("BOM", "82"), ("BOM", "40"), ("BOM", "81"), ("81_KWH", "81")]
    OUT = os.path.join(HERE, "_test_cases3.json")
    cases()


def rtf():
    with B.connect() as con:
        cur = con.cursor()
        cur.execute("ALTER SESSION SET optimizer_dynamic_sampling = 2")
        full = B.read_source(cur)["src"]
        assert B.MARK in full, "적용 후 실행"
        src = full.split("\n")
        st = load_stmts(full)
        g = [i for i, l in enumerate(src) if B.GT_ALL + " ITEM" in l]
        assert len(g) == 4
        stmts = []
        for gi in g:
            end = next(i for i in range(gi, gi + 60) if src[i].rstrip().endswith(");"))
            d = max((i for i in range(gi - 14, gi) if src[i].strip().startswith("DELETE FROM SCM_MGR.DM_PLN_MKT_FCST")), default=None)
            s = max((i for i in range(gi - 14, gi) if src[i].strip() == "FROM   SCM_MGR.DM_PLN_MKT_FCST A"), default=None)
            assert (d is None) != (s is None), (gi, d, s)
            if d is not None:
                head, kind, a = "SELECT COUNT(*) FROM SCM_MGR.DM_PLN_MKT_FCST", "삭제", d
            else:
                head, kind, a = "SELECT COUNT(*) FROM SCM_MGR.DM_PLN_MKT_FCST A", "생성", s
            body = "\n".join(src[a + 1:end + 1])
            rma = "RMA" if re.search(r"V_FCST_TYPE\s*=\s*'RMA'", body) else "상품·전극"
            fix = lambda t: re.sub(r"\bPLAN_START_YYYYMMDD\b", ":ps", head + "\n" + t).rstrip().rstrip(";")
            stmts.append((f"{rma} RTF_SYS_RP {kind}", fix(body.replace(B.GT_ALL, B.VIEW)), fix(body)))
        ps = q(cur, "SELECT TO_CHAR(NEXT_DAY(TRUNC(SYSDATE),'MONDAY') - 7,'YYYYMMDD') FROM DUAL")[0][0]
        res = []
        for div, where in (("82", "FCST_TYPE <> 'RMA'"), ("40", "FCST_TYPE = 'RMA'"), ("40", "FCST_TYPE <> 'RMA'"), ("81", "1 = 1")):
            clear(cur)
            cur.execute(f"""INSERT INTO SCM_MGR.GT_DMF3_RESULTS (V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_PLANT_SITE_ID, V_ACTIVE_FLAG, V_YYYYMMDD, V_QTY)
                            SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, 'M', :ps, 1 FROM (
                              SELECT DISTINCT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
                              FROM SCM_MGR.DM_PLN_MKT_FCST WHERE MEASURE = 'MKT_FCST' AND DIVISION_ID = :d AND YYYYMMDD BETWEEN :ps AND TO_CHAR(TO_DATE(:ps,'YYYYMMDD') + 6,'YYYYMMDD') AND {where})   /* 입력 표본 = 당주에 MKT_FCST 가 있는 키 */
                            WHERE ROWNUM <= 3000""", d=div, ps=ps)
            keys = cur.rowcount
            for s in st:
                cur.execute(s)
            inactive = q(cur, """SELECT COUNT(*) FROM SCM_MGR.GT_DMF3_RESULTS R WHERE NOT EXISTS
                                 (SELECT 1 FROM SCM_MGR.GT_DMF3_ITEM_SINGLE_V_ALL G WHERE G.DIVISION_ID = R.V_DIVISION_ID AND G.ITEM_ID = R.V_ITEM_ID)""")[0][0]
            row = {"div": div, "input": where, "keys": keys, "keys_item_not_active": inactive}
            for label, sv, sg in stmts:
                t0 = time.time(); nv = q(cur, sv, ps=ps)[0][0]; tv = round(time.time() - t0, 2)
                t0 = time.time(); ng = q(cur, sg, ps=ps)[0][0]; tg = round(time.time() - t0, 2)
                row[label] = {"view": nv, "gt": ng, "sec_view": tv, "sec_gt": tg}
            con.rollback()
            print(row)
            res.append(row)
        clear(cur)
        con.commit()
        json.dump({"plan_start": ps, "rows": res}, open(os.path.join(HERE, "_test_rtf.json"), "w", encoding="utf-8"), indent=1, ensure_ascii=False)


if __name__ == "__main__":
    {"load": load, "clone": clone, "cases": cases, "cases3": cases3, "rtf": rtf, "drop": drop}[sys.argv[1]]()
