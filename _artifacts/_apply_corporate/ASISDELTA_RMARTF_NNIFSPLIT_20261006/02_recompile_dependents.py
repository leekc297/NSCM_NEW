"""[E20261006-ASISDELTA] 적용 후 재컴파일 — 원문 변경 없음 (ALTER ... COMPILE 만)
  대상: 이번 변경 프로시저의 직접 호출처 2 + 분리된 JOB 의 대상 프로시저 1
  python 02_recompile_dependents.py
"""
import sys, os, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import build_apply as B

TARGETS = ["PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE_BATCH", "PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING", "PR_DM_CUST_MODEL_MAPPING_IF"]
out = []
with B.connect() as con:
    cur = con.cursor()
    for n in TARGETS:
        b = B.read_source(cur, n)
        if b["status"] == "INVALID":
            try:
                cur.execute(f'ALTER PROCEDURE SCM_MGR."{n}" COMPILE')
            except Exception as e:      # 컴파일 오류는 all_errors 로 확인
                print("  compile raised:", str(e).split("\n")[0])
        a = B.read_source(cur, n)
        cur.execute("SELECT line, text FROM all_errors WHERE owner='SCM_MGR' AND name=:n ORDER BY sequence", n=n)
        errs = cur.fetchall()
        rec = {"name": n, "before": [b["status"], b["last_ddl"]], "after": [a["status"], a["last_ddl"]],
               "source_unchanged": a["md5"] == b["md5"], "errors": errs}
        print(rec)
        out.append(rec)
json.dump(out, open(os.path.join(B.HERE, "_recompile_result.json"), "w", encoding="utf-8"), indent=1, ensure_ascii=False)
