# -*- coding: utf-8 -*-
"""[E20260826-ASINSREQ] v2 — 앵커를 원문에서 동적 추출"""
import io, json, pathlib, sys, re
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
MARK = "   --[E20260826-ASINSREQ]"

def gate_line(anchor_sub, count_expect=1):
    """anchor_sub 를 포함하는 라인 원문(개행 미포함) 추출"""
    idx = src.find(anchor_sub)
    assert idx > 0, anchor_sub
    s = src.rfind("\n", 0, idx) + 1
    e = src.find("\n", idx)
    return src[s:e]

# ① DELETE 외부 IN — 라인 단위 치환 (유일성 라인 원문으로 확보)
l1 = gate_line("DELETE FROM SCM_MGR.DM_PLN_MKT_FCST A")
# 그 다음 WHERE 라인
i1 = src.find(l1)
w1s = src.find("\n", i1) + 1
w1e = src.find("\n", w1s)
w1 = src[w1s:w1e]
assert "IN ('MKT_FCST', 'VMI_In_Req')" in w1, w1
old1 = l1 + "\n" + w1
assert src.count(old1) == 1
new1 = l1 + "\n" + w1.replace("IN ('MKT_FCST', 'VMI_In_Req')", "IN ('MKT_FCST', 'VMI_In_Req', 'AS_In_Req')") + MARK + " W/S AS_In_Req 입력 개방 (AS-IS 저장은 메저 무필터 — 파리티)"
edits.append({"old": old1, "new": new1})

# ② DELETE 내부 IN (B.MEASURE) — 유일 라인
cands = [m.start() for m in re.finditer(r"AND B\.MEASURE IN \('MKT_FCST', 'VMI_In_Req'\)", src)]
assert len(cands) == 1, len(cands)
s2 = src.rfind("\n", 0, cands[0]) + 1
e2 = src.find("\n", cands[0])
old2 = src[s2:e2]
assert src.count(old2) == 1
new2 = old2.replace("IN ('MKT_FCST', 'VMI_In_Req')", "IN ('MKT_FCST', 'VMI_In_Req', 'AS_In_Req')") + MARK
edits.append({"old": old2, "new": new2})

# ③ MERGE 게이트 — 'DIV81DEL' 주석 달린 AND 라인 위의 WHERE M.MEASURE
cands = [m.start() for m in re.finditer(r"WHERE M\.MEASURE IN \('MKT_FCST', 'VMI_In_Req'\)", src)]
assert len(cands) == 1, len(cands)
s3 = src.rfind("\n", 0, cands[0]) + 1
e3 = src.find("\n", cands[0])
old3 = src[s3:e3]
assert src.count(old3) == 1
new3 = old3.replace("IN ('MKT_FCST', 'VMI_In_Req')", "IN ('MKT_FCST', 'VMI_In_Req', 'AS_In_Req')") + MARK
edits.append({"old": old3, "new": new3})

# ④ 81 수요 이력 IN — 'MKT_FCST', 'VMI_In_Req'); 형 (세미콜론) — DMF0082 저장 내 유일성 확인
cands = [m.start() for m in re.finditer(r"WHERE MEASURE IN \('MKT_FCST', 'VMI_In_Req'\);", src)]
assert len(cands) == 1, len(cands)
s4 = src.rfind("\n", 0, cands[0]) + 1
e4 = src.find("\n", cands[0])
old4 = src[s4:e4]
assert src.count(old4) == 1
new4 = old4.replace("IN ('MKT_FCST', 'VMI_In_Req');", "IN ('MKT_FCST', 'VMI_In_Req', 'AS_In_Req');") + MARK + " 이력 동반 (AS-IS 무필터 파리티)"
edits.append({"old": old4, "new": new4})

out = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0082_XLSBATCH_20260825\edits_asinsreq.json")
out.write_text(json.dumps(edits, ensure_ascii=False, indent=1), encoding="utf-8")
print("edits %d건 생성" % len(edits))
for e in edits:
    print("  -", e["old"].strip()[:90], flush=True)
