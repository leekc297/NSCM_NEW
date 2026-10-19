"""[E20261006-ITEMGT] 성공 경로(실제 저장) 왕복 검증 — 수정 전(복제 PKG_DMF0003_TB = 뷰 직접 조회판) vs 수정 후(PKG_DMF0003 = 임시테이블판)

원칙 (사내 E2E 규칙):
  · 입력 키 = 원장(DM_PLN_MKT_FCST · DM_PLN_CFM_MKT_DEMAND_PLAN)에 행이 하나도 없는 (사업부, 프로젝트, 사이트, 품목) — 호출 직전 COUNT=0 assert
  · 사업부 81 만 사용 — 저장 후반부가 82 는 Sales Plan 동기화, 40 은 매출금액 재계산을 추가로 부르므로 제외.
    81 저장 = DM_PLN_MKT_FCST(+_H) 기록 + 밸런스(CALL, 대상 키 한정: DM_PLN_MKT_FCST · DM_PLN_CFM_MKT_DEMAND_PLAN)
  · 정리 = 사전 스냅샷(0행)과의 차집합 = 그 키의 행 전부 삭제 → 0행 재확인. 이력(_H)은 감사 기록으로 잔존.
  · 같은 키로 수정 전 → 정리 → 수정 후 → 정리, 두 결과(감사 일시 제외 전 컬럼)를 비교.

  python t02_e2e.py
"""
import sys, os, json, time
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import build_apply as B
import t01_test as T
import oracledb

USER_ID = "minyonglee1"
TABLES = ["DM_PLN_MKT_FCST", "DM_PLN_CFM_MKT_DEMAND_PLAN"]
KEYW = "DIVISION_ID=:a AND PROJECT_CODE=:b AND SCM_SITE_ID=:c AND ITEM_ID=:e"

CAND = """
SELECT SI.DIVISION_ID, SI.PROJECT_CODE, SI.SCM_SITE_ID, SI.ITEM_ID, SI.SALES_PLAN_ADJUST_YN
FROM SCM_MGR.SCM_MST_SITE_ITEM SI
WHERE SI.DIVISION_ID = '81' AND SI.VALID_YN = 'Y' AND SI.PROJECT_CODE <> '-'
  AND NVL(SI.CELL_PER_CAR, 0) > 0
  AND REGEXP_LIKE(SI.ATTRIBUTE8, '^[0-9.]+$') AND TO_NUMBER(SI.ATTRIBUTE8) > 0
  AND SI.ATTRIBUTE10 IN (SELECT SEGMENT2 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE='CELL_TYPE_INFO' AND SEGMENT1 LIKE '81%' AND VALID_YN='Y')
  AND EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_SITE_CUSTOMER X WHERE X.DIVISION_ID=SI.DIVISION_ID AND X.SCM_SITE_ID=SI.SCM_SITE_ID AND X.VALID_YN='Y' AND X.REP_YN='Y' AND X.SHIPTO_CODE IS NOT NULL)
  AND EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_BOM_ENG_SN X WHERE X.DIVISION_ID=SI.DIVISION_ID AND X.PARENT_ITEM_ID=SI.ITEM_ID)
  AND EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_ITEM_SN K WHERE K.DIVISION_ID=SI.DIVISION_ID AND K.ITEM_ID=SI.ITEM_ID AND K.ACTIVE_FLAG='Y')
  AND NOT EXISTS (SELECT 1 FROM SCM_MGR.DM_PLN_MKT_FCST F WHERE F.DIVISION_ID=SI.DIVISION_ID AND F.PROJECT_CODE=SI.PROJECT_CODE AND F.SCM_SITE_ID=SI.SCM_SITE_ID AND F.ITEM_ID=SI.ITEM_ID)
  AND NOT EXISTS (SELECT 1 FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN F WHERE F.DIVISION_ID=SI.DIVISION_ID AND F.PROJECT_CODE=SI.PROJECT_CODE AND F.SCM_SITE_ID=SI.SCM_SITE_ID AND F.ITEM_ID=SI.ITEM_ID)
  AND ROWNUM <= 40
ORDER BY CASE WHEN SI.SALES_PLAN_ADJUST_YN = 'N' THEN 0 ELSE 1 END
"""
# 같은 사업부·사이트의 기존 원장 행에서 실제 쓰이는 DOM_EXP·FCST_TYPE·INCOTERMS·PLANT_SITE 를 빌린다
SIB = """SELECT DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID FROM SCM_MGR.DM_PLN_MKT_FCST
         WHERE DIVISION_ID=:a AND SCM_SITE_ID=:c AND MEASURE='MKT_FCST' AND FCST_TYPE <> 'RMA' AND ROWNUM = 1"""


def q(cur, sql, **b):
    cur.execute(sql, **b)
    return cur.fetchall()


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
    args = ["I", key[0], key[1], key[2], key[3], dom, ft_override or ft, inco, "MKT_FCST", plant, ymd, "1", USER_ID, "ALL", "W", None, rc1, rc]
    t0 = time.time()
    cur.callproc(f"SCM_MGR.{pkg}.P_DMF0003_SAVE_MKT_FCST", args)
    res = rc.getvalue().fetchall()
    return ([str(x) for x in res[0]] if res else None), round(time.time() - t0, 2)


def main():
    report = {"runs": []}
    with B.connect() as con:
        cur = con.cursor()
        assert q(cur, "SELECT COUNT(*) FROM all_objects WHERE owner='SCM_MGR' AND object_name=:n AND status='VALID'", n=T.CLONE)[0][0] == 2, "복제 패키지 필요 (t01_test.py clone)"
        start, ymd = q(cur, "SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS'), TO_CHAR(NEXT_DAY(TRUNC(SYSDATE),'MONDAY'),'YYYYMMDD') FROM DUAL")[0]
        C = {t: cols(cur, t) for t in TABLES}
        cands = q(cur, CAND)
        print("start", start, "date", ymd, "candidates", len(cands), flush=True)
        ok = 0
        for c in cands:
            key = tuple(c[:4])
            sib = q(cur, SIB, a=key[0], c=key[2])
            if not sib:
                continue
            attr = tuple(sib[0])
            fto = None if c[4] == "N" else "SMF"   # 단가 검증 제외 대상이 아니면 제외 Fcst Type 사용
            pre = count(cur, key)
            assert all(v == 0 for v in pre.values()), pre     # 호출 직전 원장 COUNT=0
            r_old, t_old = save(cur, T.CLONE, key, attr, ymd, fto)
            rec = {"key": list(key), "attr": list(attr), "fcst_type_used": fto or attr[1], "old": r_old, "sec_old": t_old}
            if not r_old or r_old[0] != "0":
                con.rollback()
                assert all(v == 0 for v in count(cur, key).values())
                print("  skip", key, "|", (r_old or ["", ""])[1][:90].replace("\n", " "), flush=True)
                report["runs"].append(rec)
                continue
            print("  old saved", key, r_old, t_old, flush=True)
            s_old = snap(cur, key, C)
            cleanup(con, cur, key)
            r_new, t_new = save(cur, "PKG_DMF0003", key, attr, ymd, fto)
            s_new = snap(cur, key, C) if r_new and r_new[0] == "0" else None
            con.rollback()
            cleanup(con, cur, key)
            same = (s_new == s_old)
            rec.update(new=r_new, sec_new=t_new, rows_old={t: len(v) for t, v in s_old.items()},
                       rows_new=({t: len(v) for t, v in s_new.items()} if s_new else None), identical=same,
                       measures_old=sorted({r[C["DM_PLN_MKT_FCST"].index("MEASURE")] for r in s_old["DM_PLN_MKT_FCST"]}),
                       measures_new=(sorted({r[C["DM_PLN_MKT_FCST"].index("MEASURE")] for r in s_new["DM_PLN_MKT_FCST"]}) if s_new else None),
                       left_after_cleanup=count(cur, key))
            if not same:
                rec["old_rows"], rec["new_rows"] = s_old, s_new
            print("  RUN", key, "| 전:", r_old, t_old, "| 후:", r_new, t_new, "| 행수 전/후:", rec["rows_old"], rec["rows_new"], "| 동일:", same,
                  "| 정리 후 잔존:", rec["left_after_cleanup"], flush=True)
            report["runs"].append(rec)
            ok += 1
            if ok >= 2:
                break
        # 테스트 키 밖 영향 확인 — 테스트 계정으로 시작 이후 바뀐 행
        report["other_rows_touched_by_test_user"] = {
            t: q(cur, f"SELECT COUNT(*) FROM SCM_MGR.{t} WHERE LAST_UPDATE_DATE >= TO_DATE(:s,'YYYY-MM-DD HH24:MI:SS') AND (LAST_UPDATED_BY=:u OR CREATED_BY=:u)", s=start, u=USER_ID)[0][0]
            for t in TABLES}
        report["start"], report["date"] = start, ymd
        print("테스트 계정으로 시작 이후 남아 있는 원장 행:", report["other_rows_touched_by_test_user"])   # 이력(_H) 건수는 전체 스캔이 10분 이상 걸려 세지 않음
    json.dump(report, open(os.path.join(B.HERE, "_test_e2e.json"), "w", encoding="utf-8"), indent=1, ensure_ascii=False)


if __name__ == "__main__":
    main()
