"""SCP0100 클라우드 이관(DB 만) 패키지 — 사내 ZIOUI1 리허설 실행기

  python run_rehearsal.py            → 기본 순서: 00 → 30 → 31 → 30 → 31(멱등) → 90 → 99 → 30 → 31 → 90 + 끝 상태 대조 + INSERT 경로 트랜잭션 시험
  python run_rehearsal.py 00_PRECHECK_CLOUD.sql 90_VERIFY.sql   → 지정 파일만

접속 = SCM_MGR (클라우드 적용 계정과 같은 소유자 세션 — ALL_TAB_PRIVS 가시성 동일). 비밀번호는 .env.asis 의 TOBE_DB_PASS 와 같다(사내 규약).
SQL*Plus 형식 파일을 문장 단위로 실행 — PL/SQL 블록은 '/' 단독 줄까지 · 일반 SQL 은 ';' 까지 · '--' 주석 줄 건너뜀.
결과는 _rehearsal_out/NN_<파일>.out.txt 에 남기고, 끝 상태(값 서명·행수·PKG md5)를 _build_facts.json 과 대조한다.
사내 원본 행(CREATED_BY <> 'admin')은 99 가 지우지 않으므로 INSERT 경로는 트랜잭션 안에서(DELETE → MERGE/INSERT → 대조 → ROLLBACK) 시험한다 — 커밋 없음.
"""
import sys, os, json, hashlib, datetime
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
A_DB = os.path.join(HERE, "A_DB")
OUT = os.path.join(HERE, "_rehearsal_out")
FACTS = json.load(open(os.path.join(HERE, "_build_facts.json"), encoding="utf-8"))
SC_COLS = ["PROGRAM_ID","SHEET_NAME","COLUMN_NAME","COLUMN_LABEL_NAME","SORT_ORDER_NO","DATA_SORT_METHOD_CODE","SMALL_CLASS_LABEL_NAME",
           "LARGE_CLASS_LABEL_NAME","FIXED_FLAG","COLUMN_WIDTH","CELL_CONTROL_OBJECT_TYPE_CODE","CELL_COMBO_DATA_TYPE","DATA_SCALE_NUMBER",
           "DATA_MAX_LENGTH","HORIZONTAL_ALIGN_CODE","UPPERCASE_APPLY_FLAG","VISIBLE_FLAG","DIVISION_ID","DEFAULT_FLAG","USER_SELECTABLE_FLAG",
           "VALID_YN","ATTRIBUTE1","ATTRIBUTE2","ATTRIBUTE3","ATTRIBUTE4","ATTRIBUTE5","ATTRIBUTE6","ATTRIBUTE7","ATTRIBUTE8","ATTRIBUTE9",
           "ATTRIBUTE10","INPUT_TP_CD"]
MSG_COLS = ["MSG_ID", "LANG_CD", "MSG_NM", "MSG_DESC", "MSG_TP_CD", "USE_YN"]
DEFAULT_SEQ = ["00_PRECHECK_CLOUD.sql", "30_META_SHEET_COLUMNS_PLAN_TYPE.sql", "31_MSG_LBL_SCP0100.sql",
               "30_META_SHEET_COLUMNS_PLAN_TYPE.sql", "31_MSG_LBL_SCP0100.sql", "90_VERIFY.sql",
               "99_ROLLBACK.sql", "30_META_SHEET_COLUMNS_PLAN_TYPE.sql", "31_MSG_LBL_SCP0100.sql", "90_VERIFY.sql"]


def md5(s):
    return hashlib.md5(s.encode("utf-8")).hexdigest()


def split(txt):
    stmts, buf, plsql = [], [], False
    for line in txt.split("\n"):
        s = line.strip()
        if not buf:
            if not s or s.startswith("--") or s.upper().startswith(("SET ", "COLUMN ")):
                continue
            plsql = s.upper().startswith(("DECLARE", "BEGIN"))
        if plsql:
            if s == "/":
                stmts.append("\n".join(buf)); buf = []
            else:
                buf.append(line)
        else:
            buf.append(line)
            if s.endswith(";"):
                stmts.append("\n".join(buf).rstrip().rstrip(";")); buf = []
    assert not buf, "끝나지 않은 문장: " + "\n".join(buf)[:200]
    return stmts


def run_file(cur, fname, seq):
    txt = open(os.path.join(A_DB, fname), encoding="utf-8").read()
    lines, errors, dml = [], 0, []
    for st in split(txt):
        try:
            cur.execute(st)
            if cur.description:
                cols = [c[0] for c in cur.description]
                rows = cur.fetchall()
                lines.append(" | ".join(cols))
                for r in rows:
                    lines.append(" | ".join("" if v is None else str(v) for v in r))
                lines.append(f"({len(rows)} rows)")
            else:
                head = st.strip().split()[0].upper()
                if head in ("MERGE", "INSERT", "DELETE", "UPDATE"):
                    dml.append((head, cur.rowcount)); lines.append(f"{head} rowcount={cur.rowcount}")
                else:
                    lines.append(f"{head} OK")
        except oracledb.DatabaseError as e:
            errors += 1
            lines.append("ERROR " + str(e).replace("\n", " / "))
        lines.append("")
    os.makedirs(OUT, exist_ok=True)
    path = os.path.join(OUT, f"{seq:02d}_{fname[:-4]}.out.txt")
    open(path, "w", encoding="utf-8", newline="\n").write("\n".join(lines))
    print(f"== {seq:02d} {fname}  errors={errors}  dml={dml}")
    for l in lines:
        if l.startswith(("ERROR", "P5", "P8", "P10", "V1", "V2", "V4", "V6", "V7", "R1")) or "rowcount" in l:
            print("  ", l[:200])
    return errors, dml


def snapshot(cur):
    cur.execute("SELECT %s FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='SCP0100' AND COLUMN_NAME='PLAN_TYPE' ORDER BY SHEET_NAME" % ",".join(SC_COLS))
    pt = [["" if v is None else str(int(v) if isinstance(v, float) and v.is_integer() else v) for v in r] for r in cur.fetchall()]
    cur.execute("SELECT %s FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID IN ('LBL01163','LBL01167') ORDER BY MSG_ID, LANG_CD" % ",".join(MSG_COLS))
    lb = [["" if v is None else str(v) for v in r] for r in cur.fetchall()]
    cur.execute("SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='SCP0100'")
    sc_cnt = cur.fetchone()[0]
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_SCP0100' AND TYPE='PACKAGE BODY' ORDER BY LINE")
    body = md5("".join(r[0] for r in cur.fetchall()))
    cur.execute("SELECT CREATED_BY, LAST_UPDATED_BY, TO_CHAR(LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI:SS') FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='SCP0100' AND COLUMN_NAME='PLAN_TYPE' ORDER BY SHEET_NAME")
    audit = cur.fetchall()
    return {"plan_type_sig": md5(json.dumps(pt, ensure_ascii=False)), "lbl_sig": md5(json.dumps(lb, ensure_ascii=False)),
            "sheet_columns_cnt": sc_cnt, "plan_type_cnt": len(pt), "lbl_cnt": len(lb), "pkg_body_md5": body, "plan_type_audit": audit}


def insert_path_trial(con, cur):
    """사내 원본 행을 지우지 않고 INSERT 경로를 증명: 트랜잭션 안에서 DELETE → 30/31 DML → 값 대조 → ROLLBACK (커밋 없음)."""
    before = snapshot(cur)
    cur.execute("DELETE FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='SCP0100' AND COLUMN_NAME='PLAN_TYPE'")
    d1 = cur.rowcount
    cur.execute("DELETE FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID IN ('LBL01163','LBL01167')")
    d2 = cur.rowcount
    ins = []
    for fname in ("30_META_SHEET_COLUMNS_PLAN_TYPE.sql", "31_MSG_LBL_SCP0100.sql"):
        for st in split(open(os.path.join(A_DB, fname), encoding="utf-8").read()):
            head = st.strip().split()[0].upper()
            if head in ("MERGE", "INSERT"):
                cur.execute(st); ins.append(cur.rowcount)
    mid = snapshot(cur)
    cur.execute("SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='SCP0100' AND COLUMN_NAME='PLAN_TYPE' AND CREATED_BY='admin'")
    admin_rows = cur.fetchone()[0]
    con.rollback()
    after = snapshot(cur)
    res = {"deleted": [d1, d2], "inserted_rowcounts": ins, "values_equal_after_insert": mid["plan_type_sig"] == before["plan_type_sig"] and mid["lbl_sig"] == before["lbl_sig"],
           "admin_marked_rows_in_trial": admin_rows, "restored_after_rollback": after == before}
    print("== INSERT 경로 트랜잭션 시험(커밋 없음):", res)
    assert res["values_equal_after_insert"] and res["restored_after_rollback"] and sum(ins) == 9 and admin_rows == 3, "INSERT 경로 시험 실패"
    return res


def main():
    u, p, d = conn_info()
    user = os.environ.get("REHEARSAL_USER", "SCM_MGR")
    con = oracledb.connect(user=user, password=p, dsn=d)
    cur = con.cursor()
    cur.execute("ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS'")
    cur.execute("SELECT SYS_CONTEXT('USERENV','SESSION_USER'), SYS_CONTEXT('USERENV','DB_NAME'), SYS_CONTEXT('USERENV','SERVER_HOST'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM dual")
    who = cur.fetchone()
    print("DB", d, who)
    os.makedirs(OUT, exist_ok=True)
    s0 = snapshot(cur)
    print("== 시작 상태:", {k: v for k, v in s0.items() if k != "plan_type_audit"})
    assert s0["plan_type_sig"] == FACTS["signatures"]["plan_type_rows"] and s0["lbl_sig"] == FACTS["signatures"]["lbl_rows"] and s0["pkg_body_md5"] == FACTS["signatures"]["pkg_body_md5"], \
        "FRESH-GATE 실패: 빌드 시점(_build_facts.json)과 현재 사내 원문이 다르다 — build_package.py 재실행"
    seq = sys.argv[1:] or DEFAULT_SEQ
    summary = {"db": d, "session": who, "started": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"), "steps": [], "start_state": s0}
    total_err = 0
    for i, f in enumerate(seq, 1):
        err, dml = run_file(cur, f, i)
        total_err += err
        summary["steps"].append({"seq": i, "file": f, "errors": err, "dml": dml})
    s1 = snapshot(cur)
    summary["end_state"] = s1
    summary["end_equals_start"] = (s1 == s0)
    summary["end_equals_build_facts"] = (s1["plan_type_sig"] == FACTS["signatures"]["plan_type_rows"] and s1["lbl_sig"] == FACTS["signatures"]["lbl_rows"] and s1["pkg_body_md5"] == FACTS["signatures"]["pkg_body_md5"])
    print("== 끝 상태 == 시작 상태:", summary["end_equals_start"], "| == 빌드 실측:", summary["end_equals_build_facts"], "| 오류 합계:", total_err)
    if not sys.argv[1:]:
        summary["insert_path_trial"] = insert_path_trial(con, cur)
    summary["finished"] = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    summary["total_errors"] = total_err
    json.dump(summary, open(os.path.join(OUT, "_summary.json"), "w", encoding="utf-8"), ensure_ascii=False, indent=1, default=str)
    con.close()
    sys.exit(1 if total_err else 0)


if __name__ == "__main__":
    main()
