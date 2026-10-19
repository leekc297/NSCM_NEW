"""[E20261006-ITEMGT] 82 사업부 실제 저장 왕복 검증 — 뷰 직접 조회판 vs 임시테이블판

82 저장은 끝에서 P_DMF0003_MKT_FCST_SALES_PLAN_SYNC 를 불러 82 사업부 DM_PLN_SALES_PLAN 계획구간 전체를 지우고 다시 만든다(키 한정 아님).
타인 데이터를 건드리지 않도록 **검증용 복제 패키지 2개에서 그 호출 1줄만 뺀 채** 저장을 실행한다 (이번 변경은 그 프로시저를 건드리지 않는다).
  · PKG_DMF0003_TB = 10-02 원문(뷰 직접 조회판, _unguarded_base_body.txt · md5 확인)
  · PKG_DMF0003_TN = 지금 DB 원문(임시테이블판, ALL_SOURCE 에서 지금 읽음)
검증 전용 임시 객체라 FRESH-GATE 대상 아님 — 운영 패키지 PKG_DMF0003 은 건드리지 않는다.

원칙: 입력 키 = 원장(DM_PLN_MKT_FCST · DM_PLN_CFM_MKT_DEMAND_PLAN)에 행이 하나도 없는 82 키 — 호출 직전 COUNT=0 assert.
      상품·전극(RTF_SYS_RP 생성 대상) 품목 우선. 정리 = 그 키의 행 전부 삭제 → 0행 재확인. 이력(_H)은 감사 기록으로 잔존.
  python t03_e2e_82.py
"""
import sys, os, re, json, time
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import build_apply as B
import oracledb

USER_ID = "minyonglee1"
TB, TN = "PKG_DMF0003_TB", "PKG_DMF0003_TN"
TABLES = ["DM_PLN_MKT_FCST", "DM_PLN_CFM_MKT_DEMAND_PLAN"]
KEYW = "DIVISION_ID=:a AND PROJECT_CODE=:b AND SCM_SITE_ID=:c AND ITEM_ID=:e"
SYNC_LINE = "        PKG_DMF0003.P_DMF0003_MKT_FCST_SALES_PLAN_SYNC(V_DIVISION_ID, V_CREATED_BY, V_R_CURSOR);"
SYNC_OFF = "        NULL;  /* 검증용 복제: Sales Plan 동기화(82 사업부 전체 재생성) 미호출 */"

CAND = """
SELECT SI.DIVISION_ID, SI.PROJECT_CODE, SI.SCM_SITE_ID, SI.ITEM_ID, SI.SALES_PLAN_ADJUST_YN
     , CASE WHEN EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_ITEM_SN K WHERE K.DIVISION_ID=SI.DIVISION_ID AND K.ITEM_ID=SI.ITEM_ID AND K.ACTIVE_FLAG='Y'
                            AND (K.ITEM_TYPE IN ('Q','R') OR K.SCP_OPERATION_GROUP = 'E')) THEN 'Y' ELSE 'N' END AS RTF_TARGET
FROM SCM_MGR.SCM_MST_SITE_ITEM SI
WHERE SI.DIVISION_ID = '82' AND SI.VALID_YN = 'Y' AND SI.PROJECT_CODE <> '-'
  AND NVL(SI.SALES_COMPANY, '-') <> '-' AND NVL(SI.SALES_PLANT, '-') <> '-'
  AND EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_SITE_CUSTOMER X WHERE X.DIVISION_ID=SI.DIVISION_ID AND X.SCM_SITE_ID=SI.SCM_SITE_ID AND X.VALID_YN='Y' AND X.REP_YN='Y' AND X.SHIPTO_CODE IS NOT NULL)
  AND EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_ITEM_SN K WHERE K.DIVISION_ID=SI.DIVISION_ID AND K.ITEM_ID=SI.ITEM_ID AND K.ACTIVE_FLAG='Y')
  AND NOT EXISTS (SELECT 1 FROM SCM_MGR.DM_PLN_MKT_FCST F WHERE F.DIVISION_ID=SI.DIVISION_ID AND F.PROJECT_CODE=SI.PROJECT_CODE AND F.SCM_SITE_ID=SI.SCM_SITE_ID AND F.ITEM_ID=SI.ITEM_ID)
  AND NOT EXISTS (SELECT 1 FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN F WHERE F.DIVISION_ID=SI.DIVISION_ID AND F.PROJECT_CODE=SI.PROJECT_CODE AND F.SCM_SITE_ID=SI.SCM_SITE_ID AND F.ITEM_ID=SI.ITEM_ID)
ORDER BY RTF_TARGET DESC, CASE WHEN SI.SALES_PLAN_ADJUST_YN = 'N' THEN 0 ELSE 1 END
FETCH FIRST 60 ROWS ONLY
"""
SIB = """SELECT DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID FROM SCM_MGR.DM_PLN_MKT_FCST
         WHERE DIVISION_ID=:a AND SCM_SITE_ID=:c AND MEASURE='MKT_FCST' AND FCST_TYPE <> 'RMA' AND ROWNUM = 1"""


def q(cur, sql, **b):
    cur.execute(sql, **b)
    return cur.fetchall()


def make_clones(cur):
    base = open(os.path.join(B.HERE, "_unguarded_base_body.txt"), encoding="utf-8").read()
    assert B.md5(base) == B.BASE_MD5
    now = B.read_source(cur)["src"]
    assert B.MARK in now and B.OLD_MARK not in now
    cur.execute("SELECT text FROM all_source WHERE owner='SCM_MGR' AND name='PKG_DMF0003' AND type='PACKAGE' ORDER BY line")
    spec = "".join(r[0] for r in cur)
    for name, body in ((TB, base), (TN, now)):
        assert not q(cur, "SELECT 1 FROM all_objects WHERE owner='SCM_MGR' AND object_name=:n", n=name), name + " 이미 존재"
        assert body.count(SYNC_LINE) == 1
        body = body.replace(SYNC_LINE, SYNC_OFF)

        def rename(src, is_body):
            head = r'PACKAGE\s+BODY\s+"?PKG_DMF0003"?' if is_body else r'PACKAGE\s+"?PKG_DMF0003"?'
            new, n = re.subn(head, ("PACKAGE BODY " if is_body else "PACKAGE ") + name, src, count=1)
            assert n == 1
            new, n = re.subn(r"END\s+PKG_DMF0003\s*;\s*$", "END " + name + ";", new.rstrip(), count=1)
            assert n == 1
            return new
        cur.execute("CREATE OR REPLACE " + rename(spec, False))
        cur.execute("CREATE OR REPLACE " + rename(body, True))
        print(name, q(cur, "SELECT object_type, status FROM all_objects WHERE owner='SCM_MGR' AND object_name=:n ORDER BY 1", n=name),
              "errors", q(cur, "SELECT COUNT(*) FROM all_errors WHERE owner='SCM_MGR' AND name=:n", n=name)[0][0], flush=True)


def drop_clones(cur):
    for name in (TB, TN):
        if q(cur, "SELECT 1 FROM all_objects WHERE owner='SCM_MGR' AND object_name=:n AND object_type='PACKAGE'", n=name):
            cur.execute("DROP PACKAGE SCM_MGR." + name)
    print("복제 패키지 잔존", q(cur, "SELECT COUNT(*) FROM all_objects WHERE owner='SCM_MGR' AND object_name IN (:a, :b)", a=TB, b=TN)[0][0], flush=True)


def cols(cur, t):
    return [r[0] for r in q(cur, "SELECT column_name FROM all_tab_columns WHERE owner='SCM_MGR' AND table_name=:t "
                                 "AND column_name NOT IN ('CREATION_DATE','LAST_UPDATE_DATE') ORDER BY column_id", t=t)]


def count(cur, key):
    return {t: q(cur, f"SELECT COUNT(*) FROM SCM_MGR.{t} WHERE {KEYW}", a=key[0], b=key[1], c=key[2], e=key[3])[0][0] for t in TABLES}


def snap(cur, key, C):
    out = {}
    for t in TABLES:
        rows = q(cur, f"SELECT {', '.join(C[t])} FROM SCM_MGR.{t} WHERE {KEYW}", a=key[0], b=key[1], c=key[2], e=key[3])
        out[t] = sorted([[None if v is None else str(v) for v in r] for r in rows], key=lambda r: [x or "" for x in r])
    return out


def cleanup(con, cur, key):
    for t in TABLES:
        cur.execute(f"DELETE FROM SCM_MGR.{t} WHERE {KEYW}", a=key[0], b=key[1], c=key[2], e=key[3])
    con.commit()
    left = count(cur, key)
    assert all(v == 0 for v in left.values()), left
    return left


def save(cur, pkg, key, attr, ymd, ft_override=None):
    rc1, rc = cur.var(oracledb.DB_TYPE_CURSOR), cur.var(oracledb.DB_TYPE_CURSOR)
    dom, ft, inco, plant = attr
    args = ["I", key[0], key[1], key[2], key[3], dom, ft_override or ft, inco, "MKT_FCST", plant, ymd, "7", USER_ID, "ALL", "W", None, rc1, rc]
    t0 = time.time()
    cur.callproc(f"SCM_MGR.{pkg}.P_DMF0003_SAVE_MKT_FCST", args)
    res = rc.getvalue().fetchall()
    return ([str(x) for x in res[0]] if res else None), round(time.time() - t0, 2)


def measures(s, C):
    i = C["DM_PLN_MKT_FCST"].index("MEASURE")
    out = {}
    for r in s["DM_PLN_MKT_FCST"]:
        out[r[i]] = out.get(r[i], 0) + 1
    return out


def main():
    report = {"runs": []}
    with B.connect() as con:
        cur = con.cursor()
        try:
            make_clones(cur)
            sp0 = q(cur, "SELECT COUNT(*), TO_CHAR(MAX(LAST_UPDATE_DATE),'YYYY-MM-DD HH24:MI:SS') FROM SCM_MGR.DM_PLN_SALES_PLAN WHERE DIVISION_ID = '82'")[0]
            start, ymd = q(cur, "SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS'), TO_CHAR(NEXT_DAY(TRUNC(SYSDATE),'MONDAY'),'YYYYMMDD') FROM DUAL")[0]
            C = {t: cols(cur, t) for t in TABLES}
            cands = q(cur, CAND)
            print("start", start, "date", ymd, "candidates", len(cands), "RTF 대상 후보", sum(1 for c in cands if c[5] == "Y"), flush=True)
            ok = 0
            for c in cands:
                key = tuple(c[:4])
                sib = q(cur, SIB, a=key[0], c=key[2])
                if not sib:
                    continue
                attr = tuple(sib[0])
                fto = None if c[4] == "N" else "SMF"
                pre = count(cur, key)
                assert all(v == 0 for v in pre.values()), pre     # 호출 직전 원장 COUNT=0
                r_old, t_old = save(cur, TB, key, attr, ymd, fto)
                rec = {"key": list(key), "rtf_target": c[5], "attr": list(attr), "fcst_type_used": fto or attr[1], "old": r_old, "sec_old": t_old}
                if not r_old or r_old[0] != "0":
                    con.rollback()
                    assert all(v == 0 for v in count(cur, key).values())
                    print("  skip", key, "|", (r_old or ["", ""])[1][:90].replace("\n", " "), flush=True)
                    report["runs"].append(rec)
                    continue
                s_old = snap(cur, key, C)
                cleanup(con, cur, key)
                r_new, t_new = save(cur, TN, key, attr, ymd, fto)
                s_new = snap(cur, key, C) if r_new and r_new[0] == "0" else None
                con.rollback()
                cleanup(con, cur, key)
                same = (s_new == s_old)
                rec.update(new=r_new, sec_new=t_new, identical=same, measures_old=measures(s_old, C),
                           measures_new=(measures(s_new, C) if s_new else None), left_after_cleanup=count(cur, key))
                if not same:
                    rec["old_rows"], rec["new_rows"] = s_old, s_new
                print("  RUN", key, "RTF대상", c[5], "| 전:", r_old, t_old, "| 후:", r_new, t_new, "| 메저별 행수 전:", rec["measures_old"], "후:", rec["measures_new"],
                      "| 동일:", same, "| 정리 후 잔존:", rec["left_after_cleanup"], flush=True)
                report["runs"].append(rec)
                ok += 1
                if ok >= 3:
                    break
            sp1 = q(cur, "SELECT COUNT(*), TO_CHAR(MAX(LAST_UPDATE_DATE),'YYYY-MM-DD HH24:MI:SS') FROM SCM_MGR.DM_PLN_SALES_PLAN WHERE DIVISION_ID = '82'")[0]
            report.update(start=start, date=ymd, sales_plan_82_before=list(sp0), sales_plan_82_after=list(sp1))
            print("82 Sales Plan (행수, 최종수정) 전:", sp0, "후:", sp1, flush=True)
        finally:
            con.rollback()
            drop_clones(cur)
    json.dump(report, open(os.path.join(B.HERE, "_test_e2e_82.json"), "w", encoding="utf-8"), indent=1, ensure_ascii=False)


if __name__ == "__main__":
    main()
