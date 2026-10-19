"""[E20261006-ASISDELTA] 2차(#005~#007) 테스트 — "3줄 추가 전과 후의 실행 결과가 같다" 를 확인 (원장 DML 전부 ROLLBACK)

  python t02_test.py        # 적용 전: 추가 전 = DB 원문 / 추가 후 = 빌드 결과.  적용 후: 추가 전 = 3줄 뺀 것 / 추가 후 = DB 원문

대상 문장 = RMA 생성 2문장 (DM_PLN_MKT_FCST · DM_PLN_CFM_MKT_DEMAND_PLAN), 짝이 되는 RMA 삭제 2문장.
예외항목 상황 = 없음 / 키별 RTF_SYS_RP / RTF_PR / 둘 다 / RTF·RTF_SCP.  기준일 바인드는 t01 과 같다(40 RMA 행이 있는 과거 주).
"""
import sys, os, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import build_apply as B
import build_apply2 as B2
import t01_test as T
import oracledb

HERE = B.HERE
TABS = {"MKT": ("DM_PLN_MKT_FCST", "/* RMA 처리 C20200518-000359 */", "/* RMA 수정 C20200518-000359 */"),
        "CFM": ("DM_PLN_CFM_MKT_DEMAND_PLAN", "/* RMA 처리 (DM_PLN_CFM_MKT_DEMAND_PLAN) */", "/* RMA */")}


def extract(src):
    L = src.split("\n")
    out = {}
    for k, (tab, a_ins, a_del) in TABS.items():
        a = B.one(L, lambda l: l.strip() == a_ins, k + " 생성 앵커")
        i0 = next(i for i in range(a, a + 6) if L[i].strip() == "INSERT INTO " + tab)
        ins = T.stmt_from(L, i0, k)
        s = next(i for i, l in enumerate(ins) if l.strip().startswith("SELECT A.DIVISION_ID"))
        d = B.one(L, lambda l: l.strip() == a_del, k + " 삭제 앵커")
        assert L[d + 1].strip() == "DELETE FROM " + tab
        out[k] = {"insert": T.bindify("\n".join(ins)), "select": T.bindify("\n".join(ins[s:])),
                  "delete": T.bindify("\n".join(T.stmt_from(L, d + 1, k))), "raw": "\n".join(ins)}
    return out


def state(cur, tab):
    return sorted(tuple(map(str, r)) for r in T.q(cur, f"SELECT * FROM SCM_MGR.{tab} WHERE DIVISION_ID = :d AND FCST_TYPE = 'RMA'", d=T.DIV))


def gt_set(cur, items):
    cur.execute("DELETE FROM SCM_MGR.GT_PRDM2_RTF_EXCEPTION_ITEM")
    for key, meas in items:          # key = 8컬럼 + CELL_PROD_SITE_ID
        cur.execute("INSERT INTO SCM_MGR.GT_PRDM2_RTF_EXCEPTION_ITEM (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE,"
                    " INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID, MEASURE) VALUES (:1,:2,:3,:4,:5,:6,:7,:8,:9,:10)", list(key) + [meas])


def sel(cur, sql):
    n = 13 if "END_CUSTOMER" in sql else 11           # 뒤 4컬럼(SYSTEM/SYSDATE) 제외
    return sorted(tuple(r[:n]) for r in T.q(cur, sql, **T.binds(sql)))


def pair(cur, X, tab, items):
    try:
        gt_set(cur, items)
        cur.execute(X["delete"], **T.binds(X["delete"]))
        deleted = cur.rowcount
        try:
            cur.execute(X["insert"], **T.binds(X["insert"]))
            # 생성 행의 CREATION_DATE/LAST_UPDATE_DATE 는 실행 시각(SYSDATE)이라 비교에서 제외 → 키·수량·작성자만
            st = sorted(tuple(map(str, r)) for r in T.q(cur, f"""SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS,
                        MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, LAST_UPDATED_BY{', END_CUSTOMER, CELL_PROD_SITE_ID' if 'CFM' in tab else ''}
                        FROM SCM_MGR.{tab} WHERE DIVISION_ID = :d AND FCST_TYPE = 'RMA'""", d=T.DIV))
            return (deleted, cur.rowcount if False else len(st), None, st)
        except oracledb.DatabaseError as e:
            return (deleted, None, str(e).split("\n")[0][:90], None)
    finally:
        cur.connection.rollback()


def main():
    res = {"checks": []}
    ok = lambda name, cond, detail="": (res["checks"].append({"check": name, "pass": bool(cond), "detail": str(detail)}),
                                        print(("PASS " if cond else "FAIL ") + name, detail))
    with B.connect() as con:
        cur = con.cursor()
        db = B.read_source(cur, B.BAL)
        applied = all(a in db["src"] for a in B2.ADD.values())
        if applied:
            post = db["src"]
            pre = "\n".join(l for l in post.split("\n") if l not in B2.ADD.values())
        else:
            pre, post = db["src"], B2.transform(db["src"])
        res.update(applied=applied, db_last_ddl=db["last_ddl"], db_status=db["status"])
        print("DB 원문", db["last_ddl"], db["status"], "2차 적용됨" if applied else "2차 적용 전")
        P, N = extract(pre), extract(post)
        diff = [l for l in post.split("\n") if l not in pre.split("\n")]
        ok("C 추가 전·후 원문 차이 = 삽입 3줄뿐", sorted(diff) == sorted(B2.ADD.values()) and len(post.split("\n")) == len(pre.split("\n")) + 3)
        ok("C 삭제 2문장 무변경", all(P[k]["delete"] == N[k]["delete"] for k in TABS))
        led0 = {k: state(cur, TABS[k][0]) for k in TABS}

        keys = sorted({tuple(r) for r in T.q(cur, """SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID,
                        NVL(CELL_PROD_SITE_ID,'-') FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN
                        WHERE DIVISION_ID = :d AND FCST_TYPE = 'RMA' AND MEASURE = :m AND YYYYMMDD >= :p""", d=T.DIV, m=T.MEAS, p=T.PS)})
        res["keys"] = [list(k) for k in keys]
        scen = [("예외 없음", [])]
        for n, k in enumerate(keys, 1):
            scen += [(f"키{n} RTF_SYS_RP", [(k, "RTF_SYS_RP")]), (f"키{n} RTF_PR", [(k, "RTF_PR")]),
                     (f"키{n} RTF_SYS_RP+RTF_PR", [(k, "RTF_SYS_RP"), (k, "RTF_PR")]), (f"키{n} RTF+RTF_SCP", [(k, "RTF"), (k, "RTF_SCP")])]
        scen += [("전 키 RTF_SYS_RP+RTF_PR", [(k, m) for k in keys for m in ("RTF_SYS_RP", "RTF_PR")])]
        ok("시험 데이터 실존", len(keys) >= 2, f"키 {len(keys)} · 상황 {len(scen)}")

        rows = []
        for name, items in scen:
            for k in TABS:
                gt_set(cur, items)
                a, b = sel(cur, P[k]["select"]), sel(cur, N[k]["select"])
                con.rollback()
                pa, pb = pair(cur, P[k], TABS[k][0], items), pair(cur, N[k], TABS[k][0], items)
                same_sel, same_run = a == b, pa == pb
                rows.append({"scenario": name, "table": k, "select_rows": [len(a), len(b)], "select_same": same_sel,
                             "run_before": list(pa[:3]), "run_after": list(pb[:3]), "run_same": same_run})
                print(("PASS " if same_sel and same_run else "FAIL ") + f"{name:<26} {k}  생성대상 {len(a)}→{len(b)}  "
                      f"삭제→생성 전[{pa[0]},{pa[2] or 'OK'}] 후[{pb[0]},{pb[2] or 'OK'}]")
        res["scenarios"] = rows
        ok("S 모든 상황에서 생성 대상 행 집합 추가 전 == 추가 후", all(r["select_same"] for r in rows), f"{len(rows)}건")
        ok("S 모든 상황에서 삭제→생성 실행 결과(오류 여부·결과 원장) 추가 전 == 추가 후", all(r["run_same"] for r in rows), f"{len(rows)}건")
        ok("S 예외 없음: 두 테이블 모두 오류 없이 실행", all(r["run_after"][2] is None for r in rows if r["scenario"] == "예외 없음"))

        con.rollback()
        cur.execute("DELETE FROM SCM_MGR.GT_PRDM2_RTF_EXCEPTION_ITEM")
        con.commit()                                  # 세션 임시테이블 비우기만
        for k in TABS:
            ok(f"Z 원장 {TABS[k][0]} (40 RMA 전 행·전 컬럼) 시험 전 == 시험 후", state(cur, TABS[k][0]) == led0[k], f"{len(led0[k])}행")
    res["all_pass"] = all(c["pass"] for c in res["checks"])
    out = os.path.join(HERE, "_test2_" + ("after" if applied else "before") + ".json")
    json.dump(res, open(out, "w", encoding="utf-8"), indent=1, ensure_ascii=False, default=str)
    print("ALL PASS" if res["all_pass"] else "FAILED", "→", os.path.basename(out))


if __name__ == "__main__":
    main()
