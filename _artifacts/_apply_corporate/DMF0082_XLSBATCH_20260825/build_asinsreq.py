# -*- coding: utf-8 -*-
"""[E20260826-ASINSREQ] 81 AS_In_Req 입력 개방 — 저장 게이트 3지점 + 이력 (AS-IS 무필터 파리티)"""
import io, json, pathlib, sys
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace", line_buffering=True)
import oracledb
from ora import conn_info

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082'
               AND TYPE='PACKAGE BODY' ORDER BY LINE""")
src = "".join(t for (t,) in cur if t is not None)
con.close()

edits = []

def add(old, new):
    assert src.count(old) == 1, "not unique (%d): %s" % (src.count(old), old[:80].replace("\n", "\\n"))
    edits.append({"old": old, "new": new})

# ① 81 삭제 DELETE — 외부/내부 IN 2곳 (한 문장이라 통짜 치환)
add("""        DELETE FROM SCM_MGR.DM_PLN_MKT_FCST A
        WHERE A.MEASURE IN ('MKT_FCST', 'VMI_In_Req')
          AND EXISTS (
              SELECT 1
              FROM SCM_MGR.GT_PRDM1_T_MAIN B
              WHERE B.ACTION = 'D'
                AND B.MEASURE IN ('MKT_FCST', 'VMI_In_Req')""",
    """        DELETE FROM SCM_MGR.DM_PLN_MKT_FCST A
        WHERE A.MEASURE IN ('MKT_FCST', 'VMI_In_Req', 'AS_In_Req')   --[E20260826-ASINSREQ] W/S AS_In_Req 입력 개방 (AS-IS 저장은 메저 무필터 — 파리티)
          AND EXISTS (
              SELECT 1
              FROM SCM_MGR.GT_PRDM1_T_MAIN B
              WHERE B.ACTION = 'D'
                AND B.MEASURE IN ('MKT_FCST', 'VMI_In_Req', 'AS_In_Req')""")

# ② 81 MERGE 게이트
add("""                    FROM SCM_MGR.GT_PRDM1_T_MAIN M
                    WHERE M.MEASURE IN ('MKT_FCST', 'VMI_In_Req')
                      AND NVL(M.ACTION, 'X') <> 'D')""",
    """                    FROM SCM_MGR.GT_PRDM1_T_MAIN M
                    WHERE M.MEASURE IN ('MKT_FCST', 'VMI_In_Req', 'AS_In_Req')   --[E20260826-ASINSREQ]
                      AND NVL(M.ACTION, 'X') <> 'D')""")

# ③ 81 수요 이력
add("""        FROM SCM_MGR.GT_PRDM1_T_MAIN
        WHERE MEASURE IN ('MKT_FCST', 'VMI_In_Req');
    END IF;  --[DIV81] 수요 이력 분기""",
    """        FROM SCM_MGR.GT_PRDM1_T_MAIN
        WHERE MEASURE IN ('MKT_FCST', 'VMI_In_Req', 'AS_In_Req');   --[E20260826-ASINSREQ] 이력도 동반 (AS-IS 무필터 파리티)
    END IF;  --[DIV81] 수요 이력 분기""")

out = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0082_XLSBATCH_20260825\edits_asinsreq.json")
out.write_text(json.dumps(edits, ensure_ascii=False, indent=1), encoding="utf-8")
print("edits %d건 생성" % len(edits))
