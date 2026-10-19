"""[E20261006-ASISPARITY] DMF0044 / DMF0049 수정 전·후 비교 테스트 (원장 무변경 방식)

복제 패키지 4개로 수정 전(TB = 적용 전 백업 원문) / 수정 후(TA = 적용본)를 같은 입력으로 호출해 비교한다.
  PKG_DMF0044_TB · PKG_DMF0044_TA · PKG_DMF0049_TB · PKG_DMF0049_TA
복제본은 원문에서 아래 3가지만 바꾼다 (그 외 한 글자도 같음 — verify 단계에서 실제 적용본과 대조).
  ① 패키지 이름  ② 단독 줄 `COMMIT;` → `NULL;` (원장에 확정되지 않게)  ③ `PKG_DMF0044.` 호출 → 같은 종류 복제본
모든 호출은 끝에 ROLLBACK 하고, ROLLBACK 전에 **다른 접속**에서 원장이 그대로인지 확인한다(=중간 COMMIT 없음 증명).
로그 프로시저(PR_DM_SYS_LOG_BATCH · PR_SCM_SYS_LOG_BATCH)는 자율 트랜잭션이라 로그 행만 남는다.

  python t01_test.py clone      # 복제 패키지 생성 (적용 전에 실행 가능)
  python t01_test.py t44        # DMF0044 Transfer 비교
  python t01_test.py t49        # DMF0049 저장 비교
  python t01_test.py verify     # 적용 후: 실제 패키지 원문 == TA 복제 원문(①②③ 제외) + 실제 패키지 무변경 경로 호출
  python t01_test.py drop       # 복제 패키지 삭제
복제 원문 = build 시 조회한 ALL_SOURCE 기준본(_base_*.txt, _fresh_state.json md5 일치 확인) — FRESH-GATE 대상 아님(검증 전용 임시 객체).
"""
import sys, os, re, json, hashlib, time
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import build_apply as B
import oracledb

HERE = B.HERE
USER_ID = "minyonglee1"
DIV = "40"
V_NULL = "R_S_20260604_V001"          # DEPARTMENT_NAME NULL 24행 보유 (SEND_YN='N')
V_REG = os.environ.get("ASISPARITY_V_REG", "")   # 회귀용 정상 버전 (없으면 자동 선정)
V_SENT = "R_S_20260604_V002_C"       # 전송 완료(SEND_YN='Y') 버전 — Cancel/재전송 회귀용
FAKE_ITEM = "ZZ_ASISPARITY_T1"
TABLES = ["DM_MDF_VERSION", "DM_PLN_SALES_ETC_REPORT_C", "DM_PLN_SALES_PLAN_REPORT_C", "DM_MOBILE_REPORT_DEPT",
          "DM_MOBILE_REPORT_PRODUCT", "DM_MOBILE_REPORT_EXCHANGE_RATE", "DM_PLN_SALES_ETC_REPORT_H"]
NOCOMMIT = "NULL; /*TEST-NOCOMMIT*/"
COMMITS = {"PKG_DMF0044": 14, "PKG_DMF0049": 2}
SELFREF = {"PKG_DMF0044": 3, "PKG_DMF0049": 1}


def q(cur, sql, **b):
    cur.execute(sql, **b)
    return cur.fetchall()


def clone_name(pkg, kind):
    return pkg + "_" + kind


def to_clone(src, pkg, kind, body=True):
    cn = clone_name(pkg, kind)
    head = (r'PACKAGE\s+BODY\s+"?%s"?' if body else r'PACKAGE\s+"?%s"?') % pkg
    new, n = re.subn(head, ("PACKAGE BODY " if body else "PACKAGE ") + cn, src, count=1)
    assert n == 1
    new, n = re.subn(r"END\s+%s\s*;\s*$" % pkg, "END " + cn + ";", new.rstrip(), count=1)
    assert n == 1
    if body:
        new, n = re.subn(r"(?m)^(\s*)COMMIT;[ \t]*$", r"\1" + NOCOMMIT, new)
        assert n == COMMITS[pkg], (pkg, "COMMIT", n)
        assert not re.search(r"(?mi)^[^-\n/*]*\bCOMMIT\b\s*;", new), pkg + ": 남은 COMMIT 실행문"
        n = new.count("PKG_DMF0044.")
        assert n == SELFREF[pkg], (pkg, "self-ref", n)
        new = new.replace("PKG_DMF0044.", "PKG_DMF0044_" + kind + ".")
    return new


def base_src(pkg):
    src = open(os.path.join(HERE, f"_base_{pkg}.txt"), encoding="utf-8").read()
    st = json.load(open(os.path.join(HERE, "_fresh_state.json")))
    assert hashlib.md5(src.encode("utf-8")).hexdigest() == st[pkg]["md5"], pkg + " 백업본 md5 불일치"
    return src


def clone():
    with B.connect() as con:
        cur = con.cursor()
        for pkg in B.PKGS:
            base = base_src(pkg)
            new = B.TRANSFORM[pkg](base)
            B.check(pkg, base, new)
            spec = "".join(r[0] for r in q(cur, "SELECT text FROM all_source WHERE owner='SCM_MGR' AND name=:n AND type='PACKAGE' ORDER BY line", n=pkg))
            for kind, src in (("TB", base), ("TA", new)):
                cn = clone_name(pkg, kind)
                assert not q(cur, "SELECT 1 FROM all_objects WHERE owner='SCM_MGR' AND object_name=:n", n=cn), cn + " 이미 존재"
                cur.execute("CREATE OR REPLACE " + to_clone(spec, pkg, kind, body=False))
                cur.execute("CREATE OR REPLACE " + to_clone(src, pkg, kind))
        for pkg in B.PKGS:      # 0049 복제본이 0044 복제본을 참조 — 전부 만든 뒤 재컴파일·확인
            for kind in ("TB", "TA"):
                cn = clone_name(pkg, kind)
                cur.execute(f"ALTER PACKAGE SCM_MGR.{cn} COMPILE BODY")
                print(cn, q(cur, "SELECT object_type, status FROM all_objects WHERE owner='SCM_MGR' AND object_name=:n ORDER BY 1", n=cn),
                      "errors", q(cur, "SELECT COUNT(*) FROM all_errors WHERE owner='SCM_MGR' AND name=:n", n=cn)[0][0])


def drop():
    with B.connect() as con:
        cur = con.cursor()
        for pkg in B.PKGS:
            for kind in ("TB", "TA"):
                cn = clone_name(pkg, kind)
                if q(cur, "SELECT 1 FROM all_objects WHERE owner='SCM_MGR' AND object_name=:n AND object_type='PACKAGE'", n=cn):
                    cur.execute("DROP PACKAGE SCM_MGR." + cn)
        print("남은 복제 객체", q(cur, "SELECT object_name, object_type FROM all_objects WHERE owner='SCM_MGR' AND REGEXP_LIKE(object_name,'^PKG_DMF00(44|49)_T[AB]$')"))


# ── 지문: 표·버전별 (행 수, 컬럼별 해시 합). dates=False 면 일시 컬럼 제외(수정 전/후 결과 비교용) ─────────────
_cols = {}


def cols(cur, table, dates):
    key = (table, dates)
    if key not in _cols:
        rows = q(cur, "SELECT column_name, data_type FROM all_tab_columns WHERE owner='SCM_MGR' AND table_name=:t ORDER BY column_id", t=table)
        assert rows, table
        _cols[key] = [c for c, t in rows if dates or not (t == "DATE" or t.startswith("TIMESTAMP"))]
    return _cols[key]


def fp(cur, table, ver, dates=True, extra=""):
    cs = cols(cur, table, dates)
    expr = " + ".join(f"ORA_HASH({c}, 4294967295, {i + 1})" for i, c in enumerate(cs))
    r = q(cur, f"SELECT COUNT(*), NVL(SUM({expr}), 0) FROM SCM_MGR.{table} WHERE DIVISION_ID = :d AND VERSION_NO = :v {extra}", d=DIV, v=ver)[0]
    return [int(r[0]), int(r[1])]


def fp_all(cur, ver, dates=True):
    return {t: fp(cur, t, ver, dates) for t in TABLES}


def call44(cur, kind, ver, action, div=DIV):
    rc = cur.var(oracledb.DB_TYPE_CURSOR)
    t0 = time.time()
    pkg = "PKG_DMF0044" if kind == "REAL" else clone_name("PKG_DMF0044", kind)
    cur.callproc(f"SCM_MGR.{pkg}.P_DMF0044_MOBILE_REPORT_CREATE", [div, ver, "REPORT_SP_W_E", action, USER_ID, rc])
    res = rc.getvalue().fetchall()
    return (str(res[0][0]) if res else None), round(time.time() - t0, 1)


def pick_reg(cur):
    """회귀용 정상 버전 — 2026-10-06 버전별 집계 조회로 선정 (40 · SEND_YN='N' · 부서명/팀명 NULL 0 · 12,559행 · 2026-06-10 이후 미변경)"""
    v = V_REG or "R_S_20260610_V001"
    r = q(cur, """SELECT COUNT(*), SUM(CASE WHEN DEPARTMENT_NAME IS NULL OR DEPT_NAME IS NULL THEN 1 ELSE 0 END)
                  FROM SCM_MGR.DM_PLN_SALES_ETC_REPORT_C WHERE DIVISION_ID = :d AND VERSION_NO = :v""", d=DIV, v=v)[0]
    assert r[0] > 0 and r[1] == 0, (v, r)
    return v


class Guard:
    """호출 전 원장 지문(다른 접속 기준) 기록 → ROLLBACK 전·후 다른 접속에서 동일 확인"""

    def __init__(self, con2, ver):
        self.c2, self.ver = con2.cursor(), ver
        self.before = fp_all(self.c2, ver)

    def check(self, when):
        now = fp_all(self.c2, self.ver)
        assert now == self.before, f"!!! 원장 변경 감지 ({when}) {self.ver}: " + json.dumps({t: [self.before[t], now[t]] for t in TABLES if now[t] != self.before[t]})
        return True


def run44(cur, con2, kind, ver, action, prep=None, inspect=None):
    g = Guard(con2, ver)
    if prep:
        prep(cur)
    rec = {"kind": kind, "version": ver, "action": action}
    try:
        msg, sec = call44(cur, kind, ver, action)
        rec.update(msg=msg, sec=sec)
        rec["in_session"] = fp_all(cur, ver, dates=False)          # 호출 직후(미확정) 결과 — 일시 컬럼 제외
        if inspect:
            rec["inspect"] = inspect(cur, ver)
        rec["no_commit_before_rollback"] = g.check("ROLLBACK 전")
    except oracledb.DatabaseError as e:
        rec["error"] = str(e)[:600]
    finally:
        cur.connection.rollback()
    rec["ledger_same_after"] = g.check("ROLLBACK 후")
    rec["ledger"] = g.before
    print(json.dumps({k: rec[k] for k in rec if k not in ("in_session", "ledger")}, ensure_ascii=False))
    return rec


def inspect_transfer(cur, ver):
    return {
        "SEND_YN": q(cur, "SELECT SEND_YN FROM SCM_MGR.DM_MDF_VERSION WHERE DIVISION_ID=:d AND VERSION_NO=:v", d=DIV, v=ver)[0][0],
        "ETC_rows": q(cur, "SELECT COUNT(*) FROM SCM_MGR.DM_PLN_SALES_ETC_REPORT_C WHERE DIVISION_ID=:d AND VERSION_NO=:v", d=DIV, v=ver)[0][0],
        "ETC_DEPARTMENT_NAME_null": q(cur, "SELECT COUNT(*) FROM SCM_MGR.DM_PLN_SALES_ETC_REPORT_C WHERE DIVISION_ID=:d AND VERSION_NO=:v AND DEPARTMENT_NAME IS NULL", d=DIV, v=ver)[0][0],
        "RPT_type2_rows": q(cur, "SELECT COUNT(*) FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C WHERE DIVISION_ID=:d AND VERSION_NO=:v AND DATA_TYPE='2'", d=DIV, v=ver)[0][0],
        "RPT_type2_DEPARTMENT_NAME_dash": q(cur, "SELECT COUNT(*) FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C WHERE DIVISION_ID=:d AND VERSION_NO=:v AND DATA_TYPE='2' AND DEPARTMENT_NAME='-'", d=DIV, v=ver)[0][0],
        "MOBILE_DEPT": q(cur, "SELECT COUNT(*) FROM SCM_MGR.DM_MOBILE_REPORT_DEPT WHERE DIVISION_ID=:d AND VERSION_NO=:v", d=DIV, v=ver)[0][0],
        "MOBILE_PRODUCT": q(cur, "SELECT COUNT(*) FROM SCM_MGR.DM_MOBILE_REPORT_PRODUCT WHERE DIVISION_ID=:d AND VERSION_NO=:v", d=DIV, v=ver)[0][0],
        "MOBILE_EXRATE": q(cur, "SELECT COUNT(*) FROM SCM_MGR.DM_MOBILE_REPORT_EXCHANGE_RATE WHERE DIVISION_ID=:d AND VERSION_NO=:v", d=DIV, v=ver)[0][0],
    }


def null_dept_name(ver):
    def prep(cur):   # 미확정 UPDATE 1행 — 같은 접속 안에서만 보인다 (ROLLBACK 으로 소멸)
        cur.execute("""UPDATE SCM_MGR.DM_PLN_SALES_ETC_REPORT_C SET DEPT_NAME = NULL
                       WHERE ROWID = (SELECT MIN(ROWID) FROM SCM_MGR.DM_PLN_SALES_ETC_REPORT_C WHERE DIVISION_ID=:d AND VERSION_NO=:v)""", d=DIV, v=ver)
        assert cur.rowcount == 1
    return prep


def t44(kinds=("TB", "TA"), out="_test_dmf0044.json"):
    res = []
    with B.connect() as con, B.connect() as con2:
        cur = con.cursor()
        vreg = pick_reg(cur)
        print("회귀 버전", vreg, "/ DEPARTMENT_NAME NULL 버전", V_NULL)
        for v, yn in ((vreg, "N"), (V_NULL, "N"), (V_SENT, "Y")):
            assert q(cur, "SELECT SEND_YN FROM SCM_MGR.DM_MDF_VERSION WHERE DIVISION_ID=:d AND VERSION_NO=:v", d=DIV, v=v)[0][0] == yn, v
        plan = [
            ("A1 DEPT_NAME NULL(임시 1행) → 문구", vreg, "T", null_dept_name(vreg), None),
            ("A2 DEPARTMENT_NAME NULL 버전 Transfer", V_NULL, "T", None, inspect_transfer),
            ("A3 정상 버전 Transfer (회귀)", vreg, "T", None, inspect_transfer),
            ("A4 정상 버전 Cancel 시도 (SEND_YN=N → 기존 검증 문구, 회귀)", vreg, "C", None, None),
            ("A6 전송 완료 버전 Cancel (회귀)", V_SENT, "C", None, inspect_transfer),
            ("A7 전송 완료 버전 재 Transfer (회귀)", V_SENT, "T", None, inspect_transfer),
        ]
        for name, ver, action, prep, insp in plan:
            print("\n[" + name + "]")
            row = {"case": name}
            for k in kinds:
                row[k] = run44(cur, con2, k, ver, action, prep, insp)
            if len(kinds) == 2:
                row["same_msg"] = row["TB"].get("msg") == row["TA"].get("msg")
                row["same_result"] = row["TB"].get("in_session") == row["TA"].get("in_session")
                print("   전/후 문구 동일:", row["same_msg"], "| 전/후 결과 데이터 동일:", row["same_result"])
            res.append(row)
        # A5 버전 없음 — 기존 검증 회귀
        print("\n[A5 없는 버전 → 기존 검증 문구 (회귀)]")
        row = {"case": "A5 없는 버전"}
        for k in kinds:
            msg, sec = call44(cur, k, "ZZ_NO_SUCH_VERSION", "T")
            con.rollback()
            row[k] = {"msg": msg}
            print("  ", k, msg)
        res.append(row)
    json.dump(res, open(os.path.join(HERE, out), "w", encoding="utf-8"), indent=1, ensure_ascii=False)


# ── DMF0049 저장 ─────────────────────────────────────────────────────────────────────────────────────────────
P49 = ["active_flag", "result_month", "division_id", "version_no", "data_seq", "department_id", "department_edit_flag", "department_name",
       "dept_id", "cust_report", "end_cust_report", "soldto_code", "soldto_cust_report", "product_group", "item_id", "product_details",
       "currency", "company_id", "biz_type", "application_gr", "application", "country_code", "project_code", "scm_site_id", "fcst_type",
       "item_use", "soldto_country", "shipto_country", "end_customer", "etc_descr", "cell_model_info", "cell_model", "measure", "yyyymmdd",
       "qty", "created_by"]


def template(cur, ver):
    """실제 원장 한 세트의 식별값을 그대로 쓰되 ITEM_ID 만 시험용 값으로 바꾼다 (원장에 없는 키 — 호출 전 COUNT=0 확인)"""
    cur.execute("""SELECT DEPARTMENT_ID, DEPT_ID, CUST_REPORT, END_CUST_REPORT, SOLDTO_CODE, SOLDTO_CUST_REPORT, PRODUCT_GROUP, PRODUCT_DETAILS,
                          CURRENCY, BIZ_TYPE, APPLICATION_GR, APPLICATION, COUNTRY_CODE, PROJECT_CODE, SCM_SITE_ID, FCST_TYPE, ITEM_USE,
                          SOLDTO_COUNTRY, SHIPTO_COUNTRY, END_CUSTOMER, CELL_MODEL_INFO, SUBSTR(YYYYMMDD,1,6)
                   FROM SCM_MGR.DM_PLN_SALES_ETC_REPORT_C WHERE DIVISION_ID=:d AND VERSION_NO=:v AND MEASURE='SalesAmt_LOC'
                     AND DEPARTMENT_ID IS NOT NULL AND DEPT_ID IS NOT NULL AND CURRENCY IS NOT NULL AND ROWNUM = 1""", d=DIV, v=ver)
    r = cur.fetchone()
    assert r, "템플릿 행 없음"
    keys = ["department_id", "dept_id", "cust_report", "end_cust_report", "soldto_code", "soldto_cust_report", "product_group", "product_details",
            "currency", "biz_type", "application_gr", "application", "country_code", "project_code", "scm_site_id", "fcst_type", "item_use",
            "soldto_country", "shipto_country", "end_customer", "cell_model_info", "yyyymmdd"]
    t = {k: ("" if v is None else str(v)) for k, v in zip(keys, r)}
    t.update(active_flag="I", result_month="", division_id=DIV, version_no=ver, data_seq="", department_edit_flag="true", department_name="",
             item_id=FAKE_ITEM, etc_descr="", cell_model="", created_by=USER_ID)
    return t


def payload(t, company_ids):
    """FE buildBulkPayload 와 같은 규약 — 행별 값을 '^' 로 연결 (끝 구분자 없음). 행 = 회사코드 × 메저 2종"""
    rows = []
    for c in company_ids:
        for m, qty in (("SalesAmt_KRW", "1000.000"), ("SalesAmt_LOC", "1.000")):
            r = dict(t)
            r.update(company_id=c, measure=m, qty=qty)
            rows.append(r)
    return ["^".join(r[k] for r in rows) for k in P49]


def call49(cur, kind, args):
    rc = cur.var(oracledb.DB_TYPE_CURSOR)
    pkg = "PKG_DMF0049" if kind == "REAL" else clone_name("PKG_DMF0049", kind)
    t0 = time.time()
    cur.callproc(f"SCM_MGR.{pkg}.P_DMF0049_SAVE_SALES_ETC_REPORT_C", args + [rc])
    res = rc.getvalue().fetchall()
    return (str(res[0][0]) if res else None), round(time.time() - t0, 1)


SAVED = """SELECT COMPANY_ID, COMPANY_NAME, MEASURE, YYYYMMDD, QTY, DEPARTMENT_NAME, DEPT_NAME, CREATED_BY,
                  DENSE_RANK() OVER (ORDER BY DATA_SEQ) AS SET_NO
           FROM SCM_MGR.DM_PLN_SALES_ETC_REPORT_C WHERE DIVISION_ID=:d AND VERSION_NO=:v AND ITEM_ID=:i ORDER BY COMPANY_ID, MEASURE"""


def run49(cur, con2, kind, ver, args):
    g = Guard(con2, ver)
    assert q(cur, "SELECT COUNT(*) FROM SCM_MGR.DM_PLN_SALES_ETC_REPORT_C WHERE VERSION_NO=:v AND DIVISION_ID=:d AND ITEM_ID=:i", v=ver, d=DIV, i=FAKE_ITEM)[0][0] == 0, "시험 키가 원장에 이미 있음"
    rec = {"kind": kind}
    try:
        msg, sec = call49(cur, kind, args)
        rec.update(msg=msg, sec=sec)
        rec["saved_rows"] = [[None if x is None else str(x) for x in r] for r in q(cur, SAVED, d=DIV, v=ver, i=FAKE_ITEM)]
        rec["hist_rows"] = q(cur, "SELECT COUNT(*) FROM SCM_MGR.DM_PLN_SALES_ETC_REPORT_H WHERE DIVISION_ID=:d AND VERSION_NO=:v AND ITEM_ID=:i", d=DIV, v=ver, i=FAKE_ITEM)[0][0]
        rec["no_commit_before_rollback"] = g.check("ROLLBACK 전")
    except oracledb.DatabaseError as e:
        rec["error"] = str(e)[:600]
    finally:
        cur.connection.rollback()
    rec["ledger_same_after"] = g.check("ROLLBACK 후")
    assert q(cur, "SELECT COUNT(*) FROM SCM_MGR.DM_PLN_SALES_ETC_REPORT_C WHERE VERSION_NO=:v AND DIVISION_ID=:d AND ITEM_ID=:i", v=ver, d=DIV, i=FAKE_ITEM)[0][0] == 0
    print("  ", kind, "|", rec.get("msg") or rec.get("error"), "| 저장 행", len(rec.get("saved_rows", [])), "| 이력", rec.get("hist_rows"))
    for r in rec.get("saved_rows", []):
        print("       ", r)
    return rec


def t49(kinds=("TB", "TA"), out="_test_dmf0049.json"):
    res = []
    with B.connect() as con, B.connect() as con2:
        cur = con.cursor()
        ver = pick_reg(cur)
        assert q(cur, "SELECT SEND_YN FROM SCM_MGR.DM_MDF_VERSION WHERE DIVISION_ID=:d AND VERSION_NO=:v", d=DIV, v=ver)[0][0] == "N"
        t = template(cur, ver)
        old = [r[0] for r in q(cur, "SELECT DISTINCT OLD_VALUE1 FROM SCM_MGR.NERP_CONV_MASTER WHERE CODETYPE='COMPANY_ID'")]
        look = [r[0] for r in q(cur, "SELECT SEGMENT1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE='DM_COMPANY'")]
        old_in = sorted(c for c in old if c in look)[0]          # 구코드 + 회사명 룩업 있음
        old_out = sorted(c for c in old if c not in look)[0]      # 구코드 + 회사명 룩업 없음
        cur_code = sorted(c for c in look if c not in old)[0]     # 현행 코드
        print("버전", ver, "| 구코드(룩업 있음)", old_in, "| 구코드(룩업 없음)", old_out, "| 현행 코드", cur_code, "| 월", t["yyyymmdd"])
        plan = [("B1 구코드(회사명 룩업 있음) 신규 저장", [old_in]), ("B2 구코드(회사명 룩업 없음) 신규 저장", [old_out]),
                ("B3 현행 코드 신규 저장 (회귀)", [cur_code]), ("B4 현행+구코드 2세트 한 번에 저장", [cur_code, old_in])]
        for name, cs in plan:
            print("\n[" + name + "] COMPANY_ID =", cs)
            row = {"case": name, "company": cs}
            for k in kinds:
                row[k] = run49(cur, con2, k, ver, payload(t, cs))
            if len(kinds) == 2:
                row["same_msg"] = row["TB"].get("msg") == row["TA"].get("msg")
                row["same_rows"] = row["TB"].get("saved_rows") == row["TA"].get("saved_rows")
                print("   전/후 문구 동일:", row["same_msg"], "| 전/후 저장 결과 동일:", row["same_rows"])
            res.append(row)
    json.dump(res, open(os.path.join(HERE, out), "w", encoding="utf-8"), indent=1, ensure_ascii=False)


def verify():
    """적용 후 — ① 실제 패키지 원문이 시험한 TA 복제본과 같은 코드인지 ② 실제 패키지의 무변경(검증 반환) 경로 호출"""
    out = {}
    with B.connect() as con, B.connect() as con2:
        cur = con.cursor()
        for pkg in B.PKGS:
            real = B.read_source(cur, pkg)
            ta = "".join(r[0] for r in q(cur, "SELECT text FROM all_source WHERE owner='SCM_MGR' AND name=:n AND type='PACKAGE BODY' ORDER BY line", n=clone_name(pkg, "TA")))
            same = to_clone(real["src"], pkg, "TA").rstrip() == ta.rstrip()
            out[pkg] = {"last_ddl": real["last_ddl"], "status": real["status"], "real_equals_tested_clone": same,
                        "marks": real["src"].count(B.MARK)}
            print(pkg, out[pkg])
            assert same and real["status"] == "VALID" and real["src"].count(B.MARK) == B.MARKS[pkg]
        vreg = pick_reg(cur)
        print("\n[실제 PKG_DMF0044 — DEPT_NAME NULL(임시 1행) → 문구]")
        out["real_A1"] = run44(cur, con2, "REAL", vreg, "T", null_dept_name(vreg), None)
        print("\n[실제 PKG_DMF0044 — Cancel 시도 / 없는 버전 (기존 검증)]")
        out["real_A4"] = run44(cur, con2, "REAL", vreg, "C", None, None)
        msg, _ = call44(cur, "REAL", "ZZ_NO_SUCH_VERSION", "T")
        con.rollback()
        out["real_A5"] = msg
        print("  ", msg)
        out["invalid_objects"] = q(cur, "SELECT object_name, object_type FROM all_objects WHERE owner='SCM_MGR' AND status='INVALID' AND object_name LIKE 'PKG_DMF00%'")
        print("INVALID PKG_DMF00*:", out["invalid_objects"])
    json.dump(out, open(os.path.join(HERE, "_test_verify.json"), "w", encoding="utf-8"), indent=1, ensure_ascii=False, default=str)


if __name__ == "__main__":
    {"clone": clone, "t44": t44, "t49": t49, "verify": verify, "drop": drop}[sys.argv[1]]()
