"""[E20261006-ITEMGT] 82 사업부 실제 저장 전체 경로 검증 — Sales Plan 동기화까지 포함 (사용자 승인 2026-10-06 "사내오라클에서는 실제 저장 구현하고 실행해도 됩니다")

  · 수정 전 = 검증용 복제 PKG_DMF0003_TB (10-02 원문 = 뷰 직접 조회판, 동기화 호출 그대로 — 운영 패키지의 동기화 프로시저를 부른다)
  · 수정 후 = 운영 패키지 PKG_DMF0003 (임시테이블판) 그대로
  · 입력 키 = 원장(DM_PLN_MKT_FCST · DM_PLN_CFM_MKT_DEMAND_PLAN · DM_PLN_SALES_PLAN)에 행이 하나도 없는 82 키 (상품·전극 = RTF_SYS_RP 생성 대상) — 호출 직전 COUNT=0 assert
  · 저장하면 82 사업부 Sales Plan 계획구간 전체가 MKT FCST 기준으로 다시 만들어진다(화면 저장과 같은 동작).
    테스트 키 밖 Sales Plan 은 저장 전·후 (행수, 수량 합) 지문으로 변동 여부를 본다.
  · 정리 = 테스트 키의 행 전부 삭제(세 원장) → 0행 재확인. 이력(_H)은 감사 기록으로 잔존.
복제 패키지는 검증 전용 임시 객체라 FRESH-GATE 대상 아님 — SPEC 은 ALL_SOURCE 에서 지금 읽는다.
  python t04_e2e_82_full.py
"""
import sys, os, re, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import build_apply as B
import t03_e2e_82 as T

TB = "PKG_DMF0003_TB"
T.TABLES = ["DM_PLN_MKT_FCST", "DM_PLN_CFM_MKT_DEMAND_PLAN", "DM_PLN_SALES_PLAN"]
CAND = T.CAND.replace("ORDER BY RTF_TARGET", """  AND NOT EXISTS (SELECT 1 FROM SCM_MGR.DM_PLN_SALES_PLAN F WHERE F.DIVISION_ID=SI.DIVISION_ID AND F.PROJECT_CODE=SI.PROJECT_CODE AND F.SCM_SITE_ID=SI.SCM_SITE_ID AND F.ITEM_ID=SI.ITEM_ID)
ORDER BY RTF_TARGET""")
OTHERS = """SELECT COUNT(*), NVL(SUM(QTY), 0), COUNT(DISTINCT MEASURE) FROM SCM_MGR.DM_PLN_SALES_PLAN
            WHERE DIVISION_ID = '82' AND NOT (PROJECT_CODE = :b AND SCM_SITE_ID = :c AND ITEM_ID = :e)"""


def q(cur, sql, **b):
    cur.execute(sql, **b)
    return cur.fetchall()


def make_clone(cur):
    base = open(os.path.join(B.HERE, "_unguarded_base_body.txt"), encoding="utf-8").read()
    assert B.md5(base) == B.BASE_MD5
    assert not q(cur, "SELECT 1 FROM all_objects WHERE owner='SCM_MGR' AND object_name=:n", n=TB), TB + " 이미 존재"
    cur.execute("SELECT text FROM all_source WHERE owner='SCM_MGR' AND name='PKG_DMF0003' AND type='PACKAGE' ORDER BY line")
    spec = "".join(r[0] for r in cur)

    def rename(src, is_body):
        head = r'PACKAGE\s+BODY\s+"?PKG_DMF0003"?' if is_body else r'PACKAGE\s+"?PKG_DMF0003"?'
        new, n = re.subn(head, ("PACKAGE BODY " if is_body else "PACKAGE ") + TB, src, count=1)
        assert n == 1
        new, n = re.subn(r"END\s+PKG_DMF0003\s*;\s*$", "END " + TB + ";", new.rstrip(), count=1)
        assert n == 1
        return new
    cur.execute("CREATE OR REPLACE " + rename(spec, False))
    cur.execute("CREATE OR REPLACE " + rename(base, True))
    print(TB, q(cur, "SELECT object_type, status FROM all_objects WHERE owner='SCM_MGR' AND object_name=:n ORDER BY 1", n=TB), flush=True)


def by_measure(s, C, t):
    i = C[t].index("MEASURE")
    out = {}
    for r in s[t]:
        out[r[i]] = out.get(r[i], 0) + 1
    return out


def main():
    report = {"runs": []}
    with B.connect() as con:
        cur = con.cursor()
        try:
            now = B.read_source(cur)
            assert B.MARK in now["src"] and B.OLD_MARK not in now["src"], "운영 패키지가 임시테이블판이 아님"
            make_clone(cur)
            start, ymd = q(cur, "SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS'), TO_CHAR(NEXT_DAY(TRUNC(SYSDATE),'MONDAY'),'YYYYMMDD') FROM DUAL")[0]
            C = {t: T.cols(cur, t) for t in T.TABLES}
            cands = [c for c in q(cur, CAND) if c[5] == "Y"]
            print("start", start, "date", ymd, "candidates", len(cands), flush=True)
            for c in cands:
                key = tuple(c[:4])
                sib = q(cur, T.SIB, a=key[0], c=key[2])
                if not sib:
                    continue
                attr = tuple(sib[0])
                fto = None if c[4] == "N" else "SMF"
                pre = T.count(cur, key)
                assert all(v == 0 for v in pre.values()), pre     # 호출 직전 세 원장 COUNT=0
                oth0 = q(cur, OTHERS, b=key[1], c=key[2], e=key[3])[0]
                r_old, t_old = T.save(cur, TB, key, attr, ymd, fto)
                rec = {"key": list(key), "attr": list(attr), "fcst_type_used": fto or attr[1], "old": r_old, "sec_old": t_old, "others_before": list(map(str, oth0))}
                if not r_old or r_old[0] != "0":
                    con.rollback()
                    assert all(v == 0 for v in T.count(cur, key).values())
                    print("  skip", key, "|", (r_old or ["", ""])[1][:90].replace("\n", " "), flush=True)
                    report["runs"].append(rec)
                    continue
                s_old = T.snap(cur, key, C)
                oth1 = q(cur, OTHERS, b=key[1], c=key[2], e=key[3])[0]
                T.cleanup(con, cur, key)
                r_new, t_new = T.save(cur, "PKG_DMF0003", key, attr, ymd, fto)
                s_new = T.snap(cur, key, C) if r_new and r_new[0] == "0" else None
                oth2 = q(cur, OTHERS, b=key[1], c=key[2], e=key[3])[0]
                con.rollback()
                T.cleanup(con, cur, key)
                same = (s_new == s_old)
                rec.update(new=r_new, sec_new=t_new, identical=same,
                           mkt_fcst_old=by_measure(s_old, C, "DM_PLN_MKT_FCST"), mkt_fcst_new=(by_measure(s_new, C, "DM_PLN_MKT_FCST") if s_new else None),
                           sales_plan_old=by_measure(s_old, C, "DM_PLN_SALES_PLAN"), sales_plan_new=(by_measure(s_new, C, "DM_PLN_SALES_PLAN") if s_new else None),
                           others_after_old=list(map(str, oth1)), others_after_new=list(map(str, oth2)), left_after_cleanup=T.count(cur, key))
                if not same:
                    rec["old_rows"], rec["new_rows"] = s_old, s_new
                print("  RUN", key, "| 전:", r_old, t_old, "| 후:", r_new, t_new, flush=True)
                print("      MKT FCST 메저별 행수 전:", rec["mkt_fcst_old"], "후:", rec["mkt_fcst_new"], flush=True)
                print("      Sales Plan 메저별 행수 전:", rec["sales_plan_old"], "후:", rec["sales_plan_new"], "| 세 원장 동일:", same, flush=True)
                print("      테스트 키 밖 82 Sales Plan (행수, 수량합, 메저수) 저장 전:", oth0, "/ 수정 전 저장 후:", oth1, "/ 수정 후 저장 후:", oth2, flush=True)
                print("      정리 후 잔존:", rec["left_after_cleanup"], flush=True)
                report["runs"].append(rec)
                break
            report.update(start=start, date=ymd)
        finally:
            con.rollback()
            if q(cur, "SELECT 1 FROM all_objects WHERE owner='SCM_MGR' AND object_name=:n AND object_type='PACKAGE'", n=TB):
                cur.execute("DROP PACKAGE SCM_MGR." + TB)
            print("복제 패키지 잔존", q(cur, "SELECT COUNT(*) FROM all_objects WHERE owner='SCM_MGR' AND object_name=:n", n=TB)[0][0], flush=True)
    json.dump(report, open(os.path.join(B.HERE, "_test_e2e_82_full.json"), "w", encoding="utf-8"), indent=1, ensure_ascii=False)


if __name__ == "__main__":
    main()
