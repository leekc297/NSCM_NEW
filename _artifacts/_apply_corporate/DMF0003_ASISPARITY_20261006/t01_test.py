"""[E20261006-ASISPARITY] 수정 전/후 비교 테스트 (원장 무변경 방식)

A. 저장 SP 호출 비교 — 같은 입력으로 수정 전(복제 패키지 PKG_DMF0003_TB = 적용 전 백업본)과 수정 후(PKG_DMF0003) 호출.
   입력은 "대표 SHIP-TO 가 없는 사이트" 행만 쓴다 → 수정 후에도 BOM 다음의 SHIP-TO 검증에서 반드시 중단되어
   원장에 쓰지 않는다 (SHIP-TO 검증 이전 구간에는 실제 테이블 DML 이 없다 — 원문 확인). 호출마다 ROLLBACK.
B. RTF_SYS_RP 삭제/생성 4문장 건수 비교 — 현재 DB 원문에서 문장을 뽑아 SELECT COUNT 로 바꿔 실행 (가드 포함 = 수정 후 /
   가드 줄 제거 = 수정 전). 입력 GT 는 세션 전용 임시 테이블에만 적재하고 ROLLBACK.

  python t01_test.py clone | cases | rtf | drop
복제 패키지 원문 = 00_BACKUP (착수 시 ALL_SOURCE 조회본, _fresh_state.json md5 일치 확인) — FRESH-GATE 대상 아님(검증 전용 임시 객체).
"""
import sys, os, re, json, hashlib, datetime
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import build_apply as B
import oracledb

HERE = B.HERE
CLONE = "PKG_DMF0003_TB"
FT = None   # 3차 실행: 단가 검증 제외 Fcst Type(SMF) 으로 덮어써 뒤 검증까지 도달
USER_ID = "minyonglee1"
OUT = os.path.join(HERE, "_test_result.json")


def q(cur, sql, **b):
    cur.execute(sql, **b)
    return cur.fetchall()


def clone():
    base = open(os.path.join(HERE, "_base_body.txt"), encoding="utf-8").read()
    st = json.load(open(os.path.join(HERE, "_fresh_state.json")))
    assert hashlib.md5(base.encode("utf-8")).hexdigest() == st["md5"], "백업본 md5 불일치"
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

CASES = {
    # ③ BOM 없음 (활성 P/H 품목)
    "BOM": ("BOM does not exist", SEL + """
          AND NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_BOM_ENG_SN X WHERE X.DIVISION_ID = SI.DIVISION_ID AND X.PARENT_ITEM_ID = SI.ITEM_ID)
          AND EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_ITEM_SN K WHERE K.DIVISION_ID = SI.DIVISION_ID AND K.ITEM_ID = SI.ITEM_ID
                         AND K.ITEM_TYPE IN ('P','H') AND K.ACTIVE_FLAG = 'Y')
          AND ROWNUM <= 60"""),
    # ① 81 환산정보 — Cell/Module/Pack 품목인데 CELL_PER_CAR 없음
    "81_CELLCAR": ("does not exist", SEL + """
          AND NVL(SI.CELL_PER_CAR, 0) = 0
          AND EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_ITEM_SN K WHERE K.DIVISION_ID = SI.DIVISION_ID AND K.ITEM_ID = SI.ITEM_ID
                         AND (K.ITEM_CLASS_NAME LIKE '%Cell%' OR K.ITEM_CLASS_NAME LIKE '%Module%' OR K.ITEM_CLASS_NAME LIKE '%Pack%'))
          AND ROWNUM <= 60"""),
    # ② 81 항목 — CELL_PER_CAR 는 있으나 Kwh/Cell(ATTRIBUTE8) 없음, 제품(P)
    "81_KWH": ("Sales Site Project Model", SEL + """
          AND NVL(SI.CELL_PER_CAR, 0) > 0 AND SI.ATTRIBUTE8 IS NULL
          AND EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_ITEM_SN K WHERE K.DIVISION_ID = SI.DIVISION_ID AND K.ITEM_ID = SI.ITEM_ID
                         AND K.ITEM_TYPE = 'P')
          AND ROWNUM <= 60"""),
}
PLAN = [("BOM", "40"), ("BOM", "81"), ("81_CELLCAR", "81"), ("81_KWH", "81")]   # 82 BOM 은 1차 실행(_test_result_run1.json)에서 확인


def call(cur, pkg, row, ymd):
    d, prj, site, item, dom, ft, inco, plant = row
    rc1, rc = cur.var(oracledb.DB_TYPE_CURSOR), cur.var(oracledb.DB_TYPE_CURSOR)
    args = ["M", d, prj, site, item, dom or "E", FT or ft or "FCST", inco or "FOB", "MKT_FCST", plant or "-", ymd, "1", USER_ID, "ALL", "W", None, rc1, rc]
    cur.callproc(f"SCM_MGR.{pkg}.P_DMF0003_SAVE_MKT_FCST", args)
    res = rc.getvalue().fetchall()
    cur.connection.rollback()
    return [str(x) for x in res[0]] if res else None


def fingerprint(cur, row):
    return q(cur, """SELECT COUNT(*), NVL(SUM(QTY),0), TO_CHAR(MAX(LAST_UPDATE_DATE),'YYYY-MM-DD HH24:MI:SS') FROM SCM_MGR.DM_PLN_MKT_FCST
                     WHERE DIVISION_ID=:a AND PROJECT_CODE=:b AND SCM_SITE_ID=:c AND ITEM_ID=:e""", a=row[0], b=row[1], c=row[2], e=row[3])[0]


def cases():
    out = []
    with B.connect() as con:
        cur = con.cursor()
        t0 = q(cur, "SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS'), TO_CHAR(NEXT_DAY(TRUNC(SYSDATE),'MONDAY'),'YYYYMMDD') FROM DUAL")[0]
        start, ymd = t0
        print("start", start, "test date", ymd)
        for name, div in PLAN:
            target, sql = CASES[name]
            raw = q(cur, sql, d=div)
            cands = []
            for r in raw:   # 원장에 같은 키의 MKT_FCST 행이 있는 후보 우선 (실제 쓰이는 DOM_EXP·INCOTERMS 등 사용)
                at = q(cur, ATTR, a=r[0], b=r[1], c=r[2], e=r[3])
                cands.append(tuple(r) + (tuple(at[0]) if at else (None, None, None, None)))
            cands.sort(key=lambda r: r[4] is None)
            cands = cands[:10]
            print(f"\n[{name} / {div}] 후보 {len(cands)}")
            done = 0
            for row in cands:
                # 안전 조건 재확인: 대표 SHIP-TO 없음 (수정 후에도 SHIP-TO 검증에서 반드시 중단)
                assert q(cur, "SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SITE_CUSTOMER WHERE DIVISION_ID=:a AND SCM_SITE_ID=:b AND VALID_YN='Y' AND REP_YN='Y'",
                         a=row[0], b=row[2])[0][0] == 0
                fp0 = fingerprint(cur, row)
                before = call(cur, CLONE, row, ymd)
                hit = bool(before) and target in before[1] and "SHIP-TO" not in before[1]
                rec = {"case": name, "div": div, "key": list(row[:4]), "before": before, "target_hit": hit}
                if hit:
                    after = call(cur, "PKG_DMF0003", row, ymd)
                    fp1 = fingerprint(cur, row)
                    rec.update(after=after, ledger_before=list(fp0), ledger_after=list(fp1), ledger_same=(fp0 == fp1))
                    assert after and after[0] != "0", "수정 후 호출이 성공(저장)으로 끝남 — 즉시 확인 필요"
                    done += 1
                print("  ", rec["key"], "| 전:", (before or [""])[1][:70] if before else None, "| 후:", (rec.get("after") or ["", ""])[1][:70])
                out.append(rec)
                if done >= 2:
                    break
        touched = q(cur, "SELECT COUNT(*) FROM SCM_MGR.DM_PLN_MKT_FCST WHERE LAST_UPDATE_DATE >= TO_DATE(:s,'YYYY-MM-DD HH24:MI:SS') AND (LAST_UPDATED_BY = :u OR CREATED_BY = :u)",
                    s=start, u=USER_ID)[0][0]
        print("\n테스트 계정으로 테스트 시작 이후 변경된 원장 행:", touched)
    json.dump({"start": start, "date": ymd, "ledger_rows_touched": touched, "cases": out}, open(OUT, "w", encoding="utf-8"), indent=1, ensure_ascii=False)


def rtf():
    with B.connect() as con:
        cur = con.cursor()
        src = B.read_source(cur)["src"].split("\n")
        g = [i for i, l in enumerate(src) if l.startswith(B.GUARD_SQL)]
        assert len(g) == 4
        stmts = []
        for gi in g:
            end = next(i for i in range(gi, gi + 60) if src[i].rstrip().endswith(");"))
            if src[gi - 2].strip().startswith("DELETE FROM SCM_MGR.DM_PLN_MKT_FCST"):
                head, kind = "SELECT COUNT(*) FROM SCM_MGR.DM_PLN_MKT_FCST", "삭제"
                body = src[gi - 1:end + 1]
            else:
                assert src[gi - 2].strip() == "FROM   SCM_MGR.DM_PLN_MKT_FCST A", src[gi - 2]
                head, kind = "SELECT COUNT(*) FROM SCM_MGR.DM_PLN_MKT_FCST A", "생성"
                body = src[gi - 1:end + 1]
            label = src[gi].split("-- ")[-1].replace(" 미수행", "")
            txt_after = head + "\n" + "\n".join(body)
            txt_before = head + "\n" + "\n".join(l for l in body if not l.startswith(B.GUARD_SQL))
            fix = lambda t: re.sub(r"\bPLAN_START_YYYYMMDD\b", ":ps", t).rstrip().rstrip(";")
            stmts.append((label, fix(txt_before), fix(txt_after)))
        ps = q(cur, "SELECT TO_CHAR(NEXT_DAY(TRUNC(SYSDATE),'MONDAY') - 7,'YYYYMMDD') FROM DUAL")[0][0]
        res = []
        for div, where in (("82", "FCST_TYPE <> 'RMA'"), ("40", "FCST_TYPE = 'RMA'"), ("40", "FCST_TYPE <> 'RMA'"), ("81", "1 = 1")):
            cur.execute("DELETE FROM SCM_MGR.GT_DMF3_RESULTS")
            cur.execute(f"""INSERT INTO SCM_MGR.GT_DMF3_RESULTS (V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_PLANT_SITE_ID, V_ACTIVE_FLAG, V_YYYYMMDD, V_QTY)
                            SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, 'M', :ps, 1 FROM (
                              SELECT DISTINCT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
                              FROM SCM_MGR.DM_PLN_MKT_FCST WHERE MEASURE = 'MKT_FCST' AND DIVISION_ID = :d AND YYYYMMDD BETWEEN :ps AND TO_CHAR(TO_DATE(:ps,'YYYYMMDD') + 6,'YYYYMMDD') AND {where})   /* 입력 표본 = 당주에 MKT_FCST 가 있는 키 */
                            WHERE ROWNUM <= 3000""", d=div, ps=ps)
            keys = cur.rowcount
            row = {"div": div, "input": where, "keys": keys}
            for label, sb, sa in stmts:
                row[label] = [q(cur, sb, ps=ps)[0][0], q(cur, sa, ps=ps)[0][0]]
            con.rollback()
            print(row)
            res.append(row)
        json.dump({"plan_start": ps, "rows": res}, open(os.path.join(HERE, "_test_rtf.json"), "w", encoding="utf-8"), indent=1, ensure_ascii=False)


def cases3():
    """3차: 단가 검증 제외 Fcst Type 'SMF' 사용 + SALES_PLAN_ADJUST_YN 조건 해제 — 81 항목 검증·40 BOM 검증 도달용"""
    global FT, PLAN
    FT = "SMF"
    for k, (t, sql) in list(CASES.items()):
        CASES[k] = (t, sql.replace("AND SI.SALES_PLAN_ADJUST_YN = 'N'", "AND 1 = 1"))
    PLAN = [("BOM", "40"), ("81_KWH", "81")]
    cases()

if __name__ == "__main__":
    {"clone": clone, "cases": cases, "cases3": cases3, "rtf": rtf, "drop": drop}[sys.argv[1]]()
