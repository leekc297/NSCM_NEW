# -*- coding: utf-8 -*-
"""클라우드 자가치유 통합 GTT 스크립트 생성 (00C).
 - PART A: body 가 참조하는 비(非)리네임 GTT 전체 → CREATE (-955 skip). 00A 가 드롭한 것 복구.
 - PART B: 리네임 GT_DMF0003_* 40종 → DROP(후) CREATE. 잘못된 스키마 자가치유.
 모든 DDL = 사내 라이브 GET_DDL (권위 스키마). 대상 = body 실참조 GTT 전수.
"""
import io, os, re, oracledb
BASE = os.path.dirname(os.path.abspath(__file__))
conn = oracledb.connect(user=os.environ["NSCM_ORA_USER"], password=os.environ["NSCM_ORA_PASS"], dsn=os.environ["NSCM_ORA_DSN"])
cur = conn.cursor()
for p in ("SEGMENT_ATTRIBUTES","STORAGE","TABLESPACE"):
    cur.execute(f"BEGIN DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'{p}',false); END;")

# body 참조 GTT 전수
cur.execute("SELECT text FROM user_source WHERE name='PKG_DMF0003' AND type='PACKAGE BODY'")
refs=set()
for (t,) in cur.fetchall():
    for m in re.findall(r'GT_[A-Z0-9_]+', (t or "").upper()):
        if len(m) > 8 and not m.endswith('_'):  # 접두 노이즈(GT_GGET_ 등) 제외
            refs.add(m)

# 실제 존재하는 GTT 만 (사내). 리네임 40 은 GT_DMF0003_ 로 이미 존재.
cur.execute("SELECT table_name, temporary FROM user_tables")
alltab = {r[0]: r[1] for r in cur.fetchall()}
renamed = sorted(n for n in refs if n.startswith("GT_DMF0003_") and alltab.get(n)=='Y')
nonren  = sorted(n for n in refs if not n.startswith("GT_DMF0003_") and alltab.get(n)=='Y')
print("PART B 리네임:", len(renamed), "| PART A 비리네임:", len(nonren))

def ddl_of(name):
    cur.execute("SELECT DBMS_METADATA.GET_DDL('TABLE', :n, 'SCM_MGR') FROM DUAL", n=name)
    return cur.fetchone()[0].read().strip().rstrip(";")

out = []
out.append("-- =====================================================================\n")
out.append("-- 00C_GTT_CLOUD_FULL_DMF0003.sql — 클라우드 자가치유 통합 GTT (2026-07-23)\n")
out.append("-- PART A: 비리네임 GTT 복구(-955 skip) / PART B: 리네임 GT_DMF0003_* DROP후 CREATE(스키마 교정)\n")
out.append("-- 모든 DDL=사내 라이브 정의. body(02) 실행 '전' 에 본 파일 먼저 실행.\n")
out.append("-- ⚠ PART B DROP 시 ORA-14452(사용중) → BE(WAS) 재기동 후 본 파일부터 재실행.\n")
out.append("-- =====================================================================\nSET SERVEROUTPUT ON\n\n")

out.append("-- ============ PART A: 비리네임 GTT 복구 (CREATE, 기존재 -955 skip) ============\n")
for n in nonren:
    d = ddl_of(n)
    out.append(f"-- {n}\nBEGIN\n  EXECUTE IMMEDIATE q'[{d}]';\n  DBMS_OUTPUT.PUT_LINE('CREATED : {n}');\nEXCEPTION WHEN OTHERS THEN\n  IF SQLCODE=-955 THEN DBMS_OUTPUT.PUT_LINE('SKIP(-955): {n}'); ELSE RAISE; END IF;\nEND;\n/\n")

out.append("\n-- ============ PART B: 리네임 GTT DROP후 CREATE (스키마 교정) ============\n")
for n in renamed:
    src = n.replace("GT_DMF0003_MFCP_","GT_MFCP_").replace("GT_DMF0003_SAVEPK_","GT_SAVEPK_").replace("GT_DMF0003_","GT_GGET_")
    d = ddl_of(src).replace(src, n)  # 원본 라이브 DDL 을 신명칭으로
    out.append(
        f"-- {src} -> {n}\nBEGIN\n"
        f"  BEGIN EXECUTE IMMEDIATE 'DROP TABLE \"SCM_MGR\".\"{n}\"';\n"
        f"  EXCEPTION WHEN OTHERS THEN\n"
        f"    IF SQLCODE=-942 THEN NULL;\n"
        f"    ELSIF SQLCODE=-14452 THEN RAISE_APPLICATION_ERROR(-20001,'{n} 사용중(ORA-14452) — BE 재기동 후 본 파일부터 재실행');\n"
        f"    ELSE RAISE; END IF;\n  END;\n"
        f"  EXECUTE IMMEDIATE q'[{d}]';\n  DBMS_OUTPUT.PUT_LINE('REBUILT : {n}');\nEND;\n/\n")

with io.open(os.path.join(BASE,"00C_GTT_CLOUD_FULL_DMF0003.sql"),"w",encoding="utf-8",newline="") as f:
    f.write("".join(out))
print("written 00C. PART A:", len(nonren), "PART B:", len(renamed))
print("nonren:", nonren)
print("renamed count:", len(renamed))
