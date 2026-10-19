"""[E20261006-ASISDELTA] 수정 전/후 비교 테스트 — 원장 무변경 방식 (모든 DML 은 ROLLBACK, 종료 시 원장 지문 대조)

  python t01_test.py rma     # ① RMA RTF 예외항목 비교 조건 — 적용 전·후 어느 때나 실행 가능
  python t01_test.py nsd     # ② NN Mapping I/F 호출 분리 — 적용 후에만 실행 (적용 전 원문은 매핑 반영 프로시저를 실제 호출함)

① 방식: 지금 DB 원문(ALL_SOURCE)에서 SP 의 실제 문장(RMA 삭제 · RMA 생성 · 예외항목 수집)을 그대로 뽑아
   PL/SQL 변수만 바인드로 바꿔 실행한다. 수정 전 문장 = 조건 줄만 옛 것으로 되돌린 것, 수정 후 문장 = 새 조건 줄.
   사내 원장에는 이번 주 이후 40 사업부 RMA 행이 없으므로 기준일(당주 월요일) 바인드를 RMA 행이 있는 과거 주로 준다.
   SP 전체 실행은 하지 않는다 — 본문에 DBMS_STATS(암시 COMMIT)가 있어 40 사업부 RTF 원장을 통째로 다시 만든다.
"""
import sys, os, re, json, time
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import build_apply as B
import oracledb

HERE = B.HERE
DIV = "40"
MEAS = "SCM_FCST"          # [PJ2025-50188] 40 사업부 기준수요 메저 (SP L1343-1347)
PS = "20250811"            # 시험 기준일(월요일) — 40 RMA 기준수요 행이 있는 구간(2025-08-15 ~ 2026-08-31)의 시작 주
KEYC = ["DIVISION_ID", "PROJECT_CODE", "SCM_SITE_ID", "ITEM_ID", "DOM_EXP", "FCST_TYPE", "INCOTERMS", "PLANT_SITE_ID"]
BIND = {"C_SCP_DIVISION_ID": ":cscp", "C_DIVISION_ID": ":cdiv", "C_PLAN_START_YYYYMMDD": ":cps",
        "V_PLAN_START_YYYYMMDD": ":vps", "V_MEASURE": ":vm", "P_DIVISION_ID": ":pdiv"}


def q(cur, sql, **b):
    cur.execute(sql, **b)
    return cur.fetchall()


def binds(sql):
    use = {"cscp": DIV, "cdiv": DIV, "cps": PS, "vps": PS, "vm": MEAS, "pdiv": DIV}
    return {k: v for k, v in use.items() if re.search(r":" + k + r"\b", sql)}


def bindify(txt):
    for k, v in BIND.items():
        txt = re.sub(r"\b" + k + r"\b", v, txt)
    return txt.rstrip().rstrip(";")


def stmt_from(lines, start, what):
    end = next(i for i in range(start, start + 80) if lines[i].rstrip().endswith(";"))
    return lines[start:end + 1]


def extract(src):
    L = src.split("\n")
    one = B.one
    a = one(L, lambda l: l.strip() == "/* RMA 처리 C20200518-000359 */", "RMA 생성 앵커")
    i0 = next(i for i in range(a, a + 6) if L[i].strip() == "INSERT INTO DM_PLN_MKT_FCST")
    ins = stmt_from(L, i0, "RMA 생성")
    assert sum(l.strip() == "UNION ALL" for l in ins) == 1
    cond = [i for i, l in enumerate(ins) if l in (B.BAL_OLD, B.BAL_NEW)]
    assert len(cond) == 2, cond
    as_db = "\n".join(ins)
    old = list(ins); old[cond[0]] = B.BAL_OLD
    new = list(ins); new[cond[0]] = B.BAL_NEW
    d = one(L, lambda l: l.strip() == "/* RMA 수정 C20200518-000359 */", "RMA 삭제 앵커")
    assert L[d + 1].strip() == "DELETE FROM DM_PLN_MKT_FCST"
    dele = stmt_from(L, d + 1, "RMA 삭제")
    c = one(L, lambda l: l.strip() == "IF V_SP_CUTOFF_FLAG = 'Y' THEN", "예외항목 수집 앵커")
    assert L[c + 1].strip() == "IF P_DIVISION_ID = '40' THEN"
    e = next(i for i in range(c + 2, c + 60) if L[i].strip() == "ELSE")
    coll = [s for s in "\n".join(L[c + 2:e]).split(";") if "INSERT INTO GT_PRDM2_RTF_EXCEPTION_ITEM" in s]
    assert len(coll) == 2

    def arms(st):
        u = next(i for i, l in enumerate(st) if l.strip() == "UNION ALL")
        s = next(i for i, l in enumerate(st) if l.strip().startswith("SELECT A.DIVISION_ID"))
        return bindify("\n".join(st[s:u])), bindify("\n".join(st[u + 1:]))
    return {"as_db": as_db, "old_txt": "\n".join(old), "new_txt": "\n".join(new),
            "ins_old": bindify("\n".join(old)), "ins_new": bindify("\n".join(new)),
            "arm_old": arms(old), "arm_new": arms(new), "delete": bindify("\n".join(dele)), "collect": [bindify(s) for s in coll]}


def rows(cur, sel):
    """arm SELECT 결과 — 앞 11컬럼(키·메저·일자·수량)만 비교 (뒤 4컬럼은 SYSTEM/SYSDATE)."""
    return sorted(tuple(r[:11]) for r in q(cur, sel, **binds(sel)))


def gt_set(cur, items):
    cur.execute("DELETE FROM SCM_MGR.GT_PRDM2_RTF_EXCEPTION_ITEM")
    for key, meas in items:
        cur.execute("INSERT INTO SCM_MGR.GT_PRDM2_RTF_EXCEPTION_ITEM (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE,"
                    " INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID, MEASURE) VALUES (:1,:2,:3,:4,:5,:6,:7,:8,'-',:9)", list(key) + [meas])


LEDGER = """SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY,
                   CREATED_BY, TO_CHAR(CREATION_DATE,'YYYYMMDDHH24MISS'), LAST_UPDATED_BY, TO_CHAR(LAST_UPDATE_DATE,'YYYYMMDDHH24MISS')
            FROM SCM_MGR.DM_PLN_MKT_FCST WHERE DIVISION_ID = :d AND FCST_TYPE = 'RMA' ORDER BY 1,2,3,4,5,6,7,8,9,10"""


def ledger(cur):
    return [tuple(r) for r in q(cur, LEDGER, d=DIV)]


def keyof(r):
    return tuple(r[:7]) + (r[8],)           # KEYC 순서 (MEASURE 제외, PLANT_SITE_ID 포함)


def run_pair(cur, X, variant, items):
    """실제 원장에 RMA 삭제 → RMA 생성 문장을 실행하고 결과 상태를 읽은 뒤 반드시 ROLLBACK."""
    con = cur.connection
    try:
        gt_set(cur, items)
        cur.execute(X["delete"], **binds(X["delete"]))
        deleted = cur.rowcount
        sql = X["ins_" + variant]
        try:
            cur.execute(sql, **binds(sql))
            return {"deleted": deleted, "inserted": cur.rowcount, "error": None, "state": ledger(cur)}
        except oracledb.DatabaseError as e:
            return {"deleted": deleted, "inserted": None, "error": str(e).split("\n")[0][:160], "state": None}
    finally:
        con.rollback()


def rma():
    res = {"plan_start_bind": PS, "division": DIV, "measure": MEAS, "checks": []}
    ok = lambda name, cond, detail="": (res["checks"].append({"check": name, "pass": bool(cond), "detail": detail}),
                                        print(("PASS " if cond else "FAIL ") + name, detail))
    with B.connect() as con:
        cur = con.cursor()
        base_src = B.read_source(cur, B.BAL)
        applied = B.MARK in base_src["src"]
        res.update(db_last_ddl=base_src["last_ddl"], db_status=base_src["status"], applied=applied)
        print("DB 원문", base_src["last_ddl"], base_src["status"], "적용됨" if applied else "적용 전")
        X = extract(base_src["src"])
        ok("C0 DB 원문의 RMA 생성 문장 == " + ("수정 후" if applied else "수정 전") + " 문장",
           X["as_db"] == (X["new_txt"] if applied else X["old_txt"]))
        ok("C0 수정 전·후 문장 차이 = 조건 1줄", sum(a != b for a, b in zip(X["old_txt"].split("\n"), X["new_txt"].split("\n"))) == 1
           and len(X["old_txt"].split("\n")) == len(X["new_txt"].split("\n")))
        ok("C0 RTF_PR arm 문장 무변경", X["arm_old"][1] == X["arm_new"][1])
        led0 = ledger(cur)
        res["ledger_rows_before"] = len(led0)

        # ── A1 예외항목 없음 (Sales Plan Cutoff 없는 평상 주) ─────────────────────────────
        gt_set(cur, [])
        b1o, b1n = rows(cur, X["arm_old"][0]), rows(cur, X["arm_new"][0])
        b2 = rows(cur, X["arm_new"][1])
        keys = sorted({keyof(r) for r in b1n})
        res["candidates"] = {"rows": len(b1n), "keys": [list(k) for k in keys]}
        ok("A1 예외항목 0건: RTF_SYS_RP 생성 대상 수정 전 == 수정 후", b1o == b1n, f"{len(b1o)}행 / {len(b1n)}행 · 키 {len(keys)}")
        ok("A1 시험 데이터 실존 (생성 대상 > 0)", len(b1n) > 0 and len(keys) >= 2, f"{len(b1n)}행")
        con.rollback()

        # ── A2 SP 의 실제 예외항목 수집 문장 그대로 (기준일 = 시험 기준일) ────────────────
        gt_set(cur, [])
        for s in X["collect"]:
            cur.execute(s, **binds(s))
        gt = q(cur, "SELECT MEASURE, FCST_TYPE, COUNT(*) FROM SCM_MGR.GT_PRDM2_RTF_EXCEPTION_ITEM GROUP BY MEASURE, FCST_TYPE ORDER BY 1,2")
        a2o, a2n = rows(cur, X["arm_old"][0]), rows(cur, X["arm_new"][0])
        res["A2_collected"] = [list(g) for g in gt]
        exc = {tuple(r) for r in q(cur, "SELECT " + ",".join(KEYC) + " FROM SCM_MGR.GT_PRDM2_RTF_EXCEPTION_ITEM WHERE MEASURE = 'RTF_SYS_RP'")}
        ok("A2 실제 수집 문장: 수정 후 결과 = 수정 전 − (RTF_SYS_RP 예외 키의 행), 추가 0",
           set(a2n) <= set(a2o) and all(keyof(r) in exc for r in set(a2o) - set(a2n)) and not any(keyof(r) in exc for r in a2n),
           f"수집 {gt} · 수정 전 {len(a2o)}행 → 수정 후 {len(a2n)}행")
        con.rollback()

        # ── A3 사용자가 RTF_SYS_RP 를 수정한 RMA 키 1건 (모의) ────────────────────────────
        have = {keyof(r) for r in led0 if r[7] == "RTF_SYS_RP" and r[9] >= PS}
        k1 = next(k for k in keys if k in have)                 # 원장에 RTF_SYS_RP 행이 있는 키
        k1rows = [r for r in b1n if keyof(r) == k1]
        gt_set(cur, [(k1, "RTF_SYS_RP")])
        a3o, a3n = rows(cur, X["arm_old"][0]), rows(cur, X["arm_new"][0])
        a3p_o, a3p_n = rows(cur, X["arm_old"][1]), rows(cur, X["arm_new"][1])
        res["A3_key"] = list(k1)
        ok("A3 수정 전: 예외 키도 그대로 생성 대상 (옛 조건은 항상 불일치)", a3o == b1o, f"{len(a3o)}행")
        ok("A3 수정 후: 예외 키 행만 제외, 나머지 동일", sorted(a3n + k1rows) == b1n and len(k1rows) > 0,
           f"{len(b1n)}행 → {len(a3n)}행 (제외 {len(k1rows)}행)")
        ok("A3 RTF_PR arm: 수정 전 == 수정 후 == 예외 없을 때 (AS-IS 운영과 같이 무변경)", a3p_o == a3p_n == b2, f"{len(a3p_n)}행")
        con.rollback()

        # ── A4 예외항목이 RTF_PR 뿐인 키 → RTF_SYS_RP arm 은 제외하지 않음 (AS-IS 리터럴 비교 그대로) ──
        gt_set(cur, [(k1, "RTF_PR")])
        ok("A4 예외항목 MEASURE=RTF_PR 만: 수정 후 RTF_SYS_RP 생성 대상 변화 없음", rows(cur, X["arm_new"][0]) == b1n)
        gt_set(cur, [(k1, "RTF"), (k1, "RTF_SCP")])
        ok("A4 예외항목 MEASURE=RTF/RTF_SCP 만: 수정 후 RTF_SYS_RP 생성 대상 변화 없음", rows(cur, X["arm_new"][0]) == b1n)
        con.rollback()

        # ── A5 실제 원장에 삭제 → 생성 실행 후 ROLLBACK ───────────────────────────────────
        proj = lambda st: sorted(r[:11] for r in st)             # 키·메저·일자·수량
        n_o, n_n = run_pair(cur, X, "old", []), run_pair(cur, X, "new", [])
        res["A5_none"] = {v: {k: r[k] for k in ("deleted", "inserted", "error")} for v, r in (("old", n_o), ("new", n_n))}
        ok("A5-a 예외항목 0건: 삭제→생성 오류 없음 · 수정 전/후 결과 원장 동일",
           not n_o["error"] and not n_n["error"] and proj(n_o["state"]) == proj(n_n["state"])
           and (n_o["deleted"], n_o["inserted"]) == (n_n["deleted"], n_n["inserted"]),
           f"삭제 {n_n['deleted']} · 생성 {n_n['inserted']}")
        s_o, s_n = run_pair(cur, X, "old", [(k1, "RTF_SYS_RP")]), run_pair(cur, X, "new", [(k1, "RTF_SYS_RP")])
        res["A5_sysrp"] = {v: {k: r[k] for k in ("deleted", "inserted", "error")} for v, r in (("old", s_o), ("new", s_n))}
        ok("A5-b 예외 키(RTF_SYS_RP): 수정 전 = 보존된 행을 다시 INSERT → 오류", bool(s_o["error"]), str(s_o["error"]))
        keep0 = [r for r in led0 if keyof(r) == k1 and r[7] == "RTF_SYS_RP" and r[9] >= PS]
        if s_n["error"]:
            ok("A5-b 예외 키(RTF_SYS_RP): 수정 후 오류 없음", False, s_n["error"])
        else:
            keep1 = [r for r in s_n["state"] if keyof(r) == k1 and r[7] == "RTF_SYS_RP" and r[9] >= PS]
            ok("A5-b 예외 키(RTF_SYS_RP): 수정 후 오류 없음 · 수정된 행 그대로 보존(감사 컬럼 포함)", keep0 == keep1 and len(keep0) > 0,
               f"보존 {len(keep1)}행 · 삭제 {s_n['deleted']} · 생성 {s_n['inserted']}")
            oth = lambda st: sorted(r[:11] for r in st if not (keyof(r) == k1 and r[7] == "RTF_SYS_RP"))
            ok("A5-b 예외 키 외 나머지 원장 = 예외 없을 때 결과와 동일", oth(s_n["state"]) == oth(n_n["state"]))
            src = {(keyof(r), r[9]): r[10] for r in s_n["state"] if r[7] == MEAS and r[9] >= PS}
            gen = {(keyof(r), r[9]): r[10] for r in s_n["state"] if r[7] == "RTF_SYS_RP" and r[9] >= PS and keyof(r) != k1}
            ok("A5-b 그 외 키의 RTF_SYS_RP 수량 == 기준수요 수량 (일자별)", gen == {k: v for k, v in src.items() if k[0] != k1} and len(gen) > 0,
               f"{len(gen)}행")
        r_o = run_pair(cur, X, "old", [(k1, "RTF_SYS_RP"), (k1, "RTF_PR")])
        r_n = run_pair(cur, X, "new", [(k1, "RTF_SYS_RP"), (k1, "RTF_PR")])
        res["A5_sysrp_pr"] = {v: {k: r[k] for k in ("deleted", "inserted", "error")} for v, r in (("old", r_o), ("new", r_n))}
        print("INFO A5-c 예외 키에 RTF_SYS_RP + RTF_PR 둘 다 (SP 수집 결과 형태): 수정 전 →", r_o["error"] or "오류 없음",
              "| 수정 후 →", r_n["error"] or "오류 없음")

        # ── 종료: 원장·GT 무변경 확인 ─────────────────────────────────────────────────────
        con.rollback()
        cur.execute("DELETE FROM SCM_MGR.GT_PRDM2_RTF_EXCEPTION_ITEM")
        con.commit()                                            # 세션 임시테이블 비우기만 (원장 DML 없음)
        ok("Z 원장(40 RMA 전 행·전 컬럼) 시험 전 == 시험 후", ledger(cur) == led0, f"{len(led0)}행")
    res["all_pass"] = all(c["pass"] for c in res["checks"])
    out = os.path.join(HERE, "_test_rma_" + ("after" if applied else "before") + ".json")
    json.dump(res, open(out, "w", encoding="utf-8"), indent=1, ensure_ascii=False, default=str)
    print("ALL PASS" if res["all_pass"] else "FAILED", "→", os.path.basename(out))


# ══ ② NN Mapping I/F 호출 분리 ═════════════════════════════════════════════════════════════════
TEST_IF = "ZZ_TEST_ASISDELTA_20261006"
FP = {"매핑 마스터 DM_CUST_MODEL_MAPPING_M": "SELECT COUNT(*), TO_CHAR(MAX(LAST_UPDATE_DATE),'YYYYMMDDHH24MISS') FROM SCM_MGR.DM_CUST_MODEL_MAPPING_M",
      "I/F 테이블 XIF_CUST_DEMAND_MAPPING_MST_R": "SELECT TRANSFER_FLAG, COUNT(*), TO_CHAR(MAX(TRANSFER_DATE),'YYYYMMDDHH24MISS') FROM SCM_MGR.XIF_CUST_DEMAND_MAPPING_MST_R_SN GROUP BY TRANSFER_FLAG ORDER BY 1",
      "Call Off 품목 DM_DNM_EDI_CALLOFF_ITEM": "SELECT COUNT(*) FROM SCM_MGR.DM_DNM_EDI_CALLOFF_ITEM"}
LOGQ = """SELECT LOG_TYPE, LOG_MESSAGE, DESCRIPTION FROM SCM_MGR.SCM_SYS_LOG_BATCH
          WHERE PROGRAM_NAME = :p AND CREATION_DATE >= TO_DATE(:s,'YYYY-MM-DD HH24:MI:SS') ORDER BY CREATION_DATE, EVENT_DATE"""


def nsd():
    res = {"checks": []}
    ok = lambda name, cond, detail="": (res["checks"].append({"check": name, "pass": bool(cond), "detail": str(detail)}),
                                        print(("PASS " if cond else "FAIL ") + name, detail))
    with B.connect() as con:
        cur = con.cursor()
        s = B.read_source(cur, B.NSD)
        assert B.MARK in s["src"], "적용 전에는 실행 금지 — 적용 전 원문은 PR_DM_CUST_MODEL_MAPPING_IF('ERP') 를 실제 호출한다"
        live = [l for l in s["src"].split("\n") if not l.lstrip().startswith("--")]
        ok("N0 상태 VALID · 컴파일 오류 0", s["status"] == "VALID" and
           q(cur, "SELECT COUNT(*) FROM all_errors WHERE owner='SCM_MGR' AND name=:n", n=B.NSD)[0][0] == 0, s["last_ddl"])
        ok("N0 실행 코드에 PR_DM_CUST_MODEL_MAPPING_IF 호출·'호출 START/END' 로그 없음",
           not any("PR_DM_CUST_MODEL_MAPPING_IF" in l for l in live if "V_PROGRAM_NAME" not in l and not l.lstrip().startswith(("/*", "*"))))
        dep = q(cur, "SELECT referenced_name FROM all_dependencies WHERE owner='SCM_MGR' AND name=:n AND referenced_owner='SCM_MGR' ORDER BY 1", n=B.NSD)
        ok("N0 의존 객체에서 PR_DM_CUST_MODEL_MAPPING_IF 빠짐", ("PR_DM_CUST_MODEL_MAPPING_IF",) not in dep, [d[0] for d in dep])
        args = q(cur, "SELECT argument_name, in_out, data_type FROM all_arguments WHERE owner='SCM_MGR' AND object_name=:n AND package_name IS NULL ORDER BY position", n=B.NSD)
        ok("N0 인자 무변경 (O_RESULT_CURSOR OUT 1개)", args == [("O_RESULT_CURSOR", "OUT", "REF CURSOR")], args)
        fp0 = {k: q(cur, v) for k, v in FP.items()}
        assert q(cur, "SELECT COUNT(*) FROM SCM_MGR.XIF_CUST_DEMAND_MAPPING_MST_R_SN WHERE IF_SEQ = :i", i=TEST_IF)[0][0] == 0, "시험 IF_SEQ 가 이미 존재"

        def call():
            rc = cur.var(oracledb.DB_TYPE_CURSOR)
            cur.callproc("SCM_MGR." + B.NSD, [rc])
            return [tuple(r) for r in rc.getvalue().fetchall()]

        # ── N1 수신 0건 호출 ──────────────────────────────────────────────────────────────
        t1 = q(cur, "SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL")[0][0]
        r1 = call()
        con.rollback()
        log1 = q(cur, LOGQ, p=B.NSD, s=t1)
        res["N1"] = {"result": r1, "log": [list(x) for x in log1]}
        ok("N1 수신 0건: 결과 S / SUCCESS", r1 == [("S", "SUCCESS")], r1)
        ok("N1 로그 5건 = START · I/F COUNT · 적재 START · 적재 · END (같은 초 기록이라 순서 무관 비교 · 호출 START/END 없음 · ERROR 없음)",
           sorted(x[0] for x in log1) == sorted(["START", "APPEND", "APPEND", "APPEND", "END"]) and not any("호출" in (x[1] or "") for x in log1),
           [(x[0], x[1]) for x in log1])

        # ── N2 수신 1건 호출 (시험 전용 IF_SEQ — 기존 행과 겹치지 않음) → I/F 적재 확인 후 ROLLBACK ──
        time.sleep(2)                                           # 로그 시각이 초 단위라 N1 과 조회 구간을 분리
        t2 = q(cur, "SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL")[0][0]
        cur.execute("""INSERT INTO SCM_MGR.GT_ET_CUST_DEMAND_MAPPING (SCM_IF_NR, SEQ, VKORG, VTWEG, SPART, KUNAG, KUNWE, ABLAD, KNREF, KDMAT, MATNR, DATAB, DATBI)
                       VALUES (:i, 1, 'ZZZZ', 'ZZ', '81', 'ZZTEST', 'ZZTEST', 'ZZ', 'ZZ', 'ZZ_TEST_MAT', 'ZZ_TEST_ITEM', '20260101', '99991231')""", i=TEST_IF)
        r2 = call()
        got = q(cur, "SELECT IF_SEQ, SEQ, ERP_SA_ORG_ID, DIVISION_ID, CUST_MATERIAL_CODE, ITEM_ID, VALID_FROM_DATE, VALID_TO_DATE, TRANSFER_FLAG"
                     " FROM SCM_MGR.XIF_CUST_DEMAND_MAPPING_MST_R_SN WHERE IF_SEQ = :i", i=TEST_IF)
        mid = q(cur, FP["매핑 마스터 DM_CUST_MODEL_MAPPING_M"])
        con.rollback()
        left = q(cur, "SELECT COUNT(*) FROM SCM_MGR.XIF_CUST_DEMAND_MAPPING_MST_R_SN WHERE IF_SEQ = :i", i=TEST_IF)[0][0]
        log2 = q(cur, LOGQ, p=B.NSD, s=t2)
        res["N2"] = {"result": r2, "xif_row": [list(g) for g in got], "log": [list(x) for x in log2], "left_after_rollback": left}
        ok("N2 수신 1건: 결과 S / SUCCESS", r2 == [("S", "SUCCESS")], r2)
        ok("N2 I/F 테이블에 1행 적재 · TRANSFER_FLAG = 'N' (매핑 반영 미수행 = JOB 대기 상태)",
           got == [(TEST_IF, 1, "ZZZZ", "81", "ZZ_TEST_MAT", "ZZ_TEST_ITEM", "20260101", "99991231", "N")], got)
        ok("N2 호출 직후 매핑 마스터 무변경 (같은 트랜잭션 안)", mid == fp0["매핑 마스터 DM_CUST_MODEL_MAPPING_M"], mid)
        ok("N2 로그: 적재 건수 1 · 호출 START/END 없음 · ERROR 없음",
           sorted(x[0] for x in log2) == sorted(["START", "APPEND", "APPEND", "APPEND", "END"]) and not any("호출" in (x[1] or "") for x in log2)
           and any((x[2] or "").strip().endswith(": 1") and "적재" in (x[1] or "") for x in log2), [(x[1], x[2]) for x in log2])
        ok("N2 ROLLBACK 후 시험 행 0건 (SP 가 COMMIT 하지 않음)", left == 0, left)

        # ── 종료: 원장 무변경 ────────────────────────────────────────────────────────────
        fp1 = {k: q(cur, v) for k, v in FP.items()}
        for k in FP:
            ok("Z " + k + " 시험 전 == 시험 후", fp0[k] == fp1[k], fp1[k])
        res["log_rows_written"] = len(log1) + len(log2)
        job = q(cur, "SELECT job_name, enabled, state, repeat_interval, DBMS_LOB.SUBSTR(job_action, 200, 1) FROM all_scheduler_jobs "
                     "WHERE owner='SCM_MGR' AND UPPER(job_action) LIKE '%PR_DM_CUST_MODEL_MAPPING_IF%'")
        res["job"] = [list(map(str, j)) for j in job]
        ok("J 분리된 JOB 등록됨 (JOB_PR_DM_CUST_MODEL_MAPPING_IF → PR_DM_CUST_MODEL_MAPPING_IF('ERP'))",
           any(j[0] == "JOB_PR_DM_CUST_MODEL_MAPPING_IF" and "PR_DM_CUST_MODEL_MAPPING_IF('ERP')" in str(j[4]) for j in job), job)
    res["all_pass"] = all(c["pass"] for c in res["checks"])
    json.dump(res, open(os.path.join(HERE, "_test_nsd_after.json"), "w", encoding="utf-8"), indent=1, ensure_ascii=False, default=str)
    print("ALL PASS" if res["all_pass"] else "FAILED")


if __name__ == "__main__":
    {"rma": rma, "nsd": nsd}[sys.argv[1]]()
