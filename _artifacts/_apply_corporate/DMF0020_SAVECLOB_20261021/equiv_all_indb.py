"""패치 후 _ALL 을 DB 안 익명 블록에서 CLOB 변수로 호출(BE CLOB 바인드와 같은 IN CLOB 경로) → 세션 GTT 스냅샷을 수정 전 스냅샷(T4a, 원문 SP)과 대조."""
import sys, json, pathlib
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb
sys.path.insert(0, str(pathlib.Path(__file__).parent))
import test_saveclob as T
p17, n = T.edge_payload()
lit = lambda v: "'" + v.replace("'", "''") + "'"
decl = "".join(f"    c{i} CLOB := {lit(v)};\n" for i, v in enumerate(p17, 1))
blk = f"""DECLARE
{decl}    rc1 SYS_REFCURSOR; rc SYS_REFCURSOR; v_code VARCHAR2(100); v_msg VARCHAR2(4000); v_evt VARCHAR2(4000);
BEGIN
    SCM_MGR.PKG_DMF0020.P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL({', '.join(f'c{i}' for i in range(1, 18))}, rc1, rc);
    FETCH rc INTO v_code, v_msg, v_evt; CLOSE rc;
    :res := v_code || '|' || v_msg || '|' || v_evt;
END;"""
u, p, d = conn_info(); con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
cur.execute("SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0020' AND TEXT LIKE '%E20261021-DMF0020SAVECLOB%'"); print("patch markers", cur.fetchone()[0])
res = cur.var(str); cur.execute(blk, res=res)
rows = T.snap_gtt(cur, "GT_FCSV_RESULTS_MST")
pre = json.loads((T.SNAP / "T4a_all_gtt_snapshot.json").read_text(encoding="utf-8"))
post_res = res.getvalue().split("|")
print("result pre ", pre["result"]); print("result post", [post_res])
print(f"GTT rows pre={len(pre['rows'])} post={len(rows)} →", "PASS 완전 일치" if pre["rows"] == rows and pre["result"] == [post_res] else "FAIL")
if pre["rows"] != rows:
    print([(a, b) for a, b in zip(pre["rows"], rows) if a != b][:5])
con.rollback()
