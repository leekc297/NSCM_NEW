# -*- coding: utf-8 -*-
"""[E20260826-INSMEAS81] DM_UI_EDITABLE_MEASURE 81 계열 Insert 후보 등재
   정본(MKT_FCST_MEASURE) × 저장 SP 81 게이트(MKT_FCST/VMI_In_Req) 교집합:
   - 전 6 division: MKT_FCST (INSERT Y / 'MKT FCST[R+P]')
   - 81/81_UC: VMI_In_Req (INSERT N — 정본 파리티, 콤보 미표시·목록 보존)
   AS_In_Req/TMM_FCST 보류 — 저장 SP 81 MERGE 게이트 밖(silent no-op)·TMM 승인 게이트 미이식."""
import io, sys, pathlib
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace", line_buffering=True)
import oracledb
from ora import conn_info

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

# 40 원행 SEQ 실측 (파리티)
cur.execute("""SELECT SEGMENT3, DISPLAY_SEQ FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
    WHERE LOOKUP_TYPE='DM_UI_EDITABLE_MEASURE' AND SEGMENT1='DMF0082' AND SEGMENT2='40'""")
seq40 = dict(cur.fetchall())
print("40 SEQ:", seq40, flush=True)
seq_mkt = seq40.get("MKT_FCST", 401)
seq_vmi = seq40.get("VMI_In_Req", 403)

DIVS_ALL = ["81", "81_UC", "81_HM", "81_ST", "81_HD", "81_HG"]
rows = []
for dv in DIVS_ALL:
    rows.append((dv, "MKT_FCST", "MKT FCST[R+P]", "Y", "Y", "ALL", seq_mkt))
for dv in ("81", "81_UC"):
    rows.append((dv, "VMI_In_Req", "VMI-In Request[R+P]", "N", "Y", "Y", seq_vmi))

MERGE = """MERGE INTO SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL T
USING (SELECT 'DM_UI_EDITABLE_MEASURE' LT, 'DMF0082' S1, :dv S2, :ms S3, :nm S4, '-' S5 FROM DUAL) S
ON (T.LOOKUP_TYPE=S.LT AND T.SEGMENT1=S.S1 AND T.SEGMENT2=S.S2 AND T.SEGMENT3=S.S3 AND T.SEGMENT4=S.S4 AND T.SEGMENT5=S.S5)
WHEN MATCHED THEN UPDATE SET T.ATTRIBUTE1=:a1, T.ATTRIBUTE2=:a2, T.ATTRIBUTE3=:a3, T.DISPLAY_SEQ=:sq,
    T.VALID_YN='Y', T.DESCRIPTION='E20260826-INSMEAS81 Insert 후보 (MKT_FCST_MEASURE 정본 x 저장게이트 교집합)',
    T.LAST_UPDATED_BY='admin', T.LAST_UPDATE_DATE=SYSDATE
WHEN NOT MATCHED THEN INSERT (LOOKUP_TYPE, SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5,
    DISPLAY_SEQ, VALID_YN, DESCRIPTION, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3,
    CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES ('DM_UI_EDITABLE_MEASURE', 'DMF0082', :dv, :ms, :nm, '-', :sq, 'Y',
    'E20260826-INSMEAS81 Insert 후보 (MKT_FCST_MEASURE 정본 x 저장게이트 교집합)', :a1, :a2, :a3,
    'admin', SYSDATE, 'admin', SYSDATE)"""

sqls = []
for dv, ms, nm, a1, a2, a3, sq in rows:
    cur.execute(MERGE, dv=dv, ms=ms, nm=nm, a1=a1, a2=a2, a3=a3, sq=sq)
    lit = MERGE
    for k, v in (("(:dv", "('" + dv + "'"), (":dv,", "'" + dv + "',")):
        pass
    sqls.append((dv, ms, nm, a1, a2, a3, sq))
con.commit()
print("MERGE %d행 적용·커밋" % len(rows), flush=True)

# 검증 ① 룩업 상태
cur.execute("""SELECT SEGMENT2, SEGMENT3, ATTRIBUTE1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
    WHERE LOOKUP_TYPE='DM_UI_EDITABLE_MEASURE' AND SEGMENT1='DMF0082' AND SEGMENT2 LIKE '81%'
    ORDER BY SEGMENT2, SEGMENT3""")
for r in cur: print("  룩업:", r, flush=True)

# 검증 ② 콤보 실행 (81, non-VMI 사이트 / VMI 사이트)
cur.execute("SELECT SQL_DTL_CTN FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID='FcstPriceEditMeasure'")
lob = cur.fetchone()[0]
base = lob.read() if hasattr(lob, "read") else str(lob)
for site_desc, site in (("non-VMI(Audi_SK_BTS)", "Audi_SK_BTS"), ("빈 사이트", " ")):
    q = base.replace("@divisionId", "'81'").replace("@scmSiteId", "'" + site + "'").replace("@bucketType", "'W'")
    cur.execute(q)
    print("  콤보(81, %s):" % site_desc, [(r[0], r[1]) for r in cur.fetchall()], flush=True)

# 검증 ③ Excel Form 회귀 — 폼 WT_MEASURE 는 SEGMENT3='LOC' 한정 필터 (행 불변 확인)
cur.execute("""SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
    WHERE LOOKUP_TYPE='DM_UI_EDITABLE_MEASURE' AND SEGMENT1='DMF0082' AND SEGMENT3='LOC'
      AND SEGMENT2 LIKE '81%' AND ATTRIBUTE1='Y' AND VALID_YN='Y'""")
print("  폼 LOC 축(불변 기대 6):", cur.fetchone()[0], flush=True)
con.close()

# 이관 SQL 26_
lit_rows = []
for dv, ms, nm, a1, a2, a3, sq in rows:
    lit = (MERGE.replace(":dv", "'" + dv + "'").replace(":ms", "'" + ms + "'")
                .replace(":nm", "'" + nm + "'").replace(":a1", "'" + a1 + "'")
                .replace(":a2", "'" + a2 + "'").replace(":a3", "'" + a3 + "'")
                .replace(":sq", str(sq)))
    lit_rows.append(lit + ";")
hdr = """-- DMF0082_CLOUD_20260826_PENDING / DM_UI_EDITABLE_MEASURE 81 계열 Insert 후보 등재 (멱등 MERGE 8행)
-- [E20260826-INSMEAS81] 81 Insert 콤보에 LOC 만 보이던 결손 정정 (사용자 신고 2026-08-26).
--   범위 = 정본(MKT_FCST_MEASURE) x 저장 SP 81 게이트(MKT_FCST/VMI_In_Req) 교집합:
--   전 6 division MKT_FCST(INSERT Y) + 81/81_UC VMI_In_Req(INSERT N — 정본 파리티).
--   AS_In_Req/TMM_FCST 미등재 — 저장 SP 81 MERGE 게이트 밖(silent no-op 방지)·TMM 승인 게이트 미이식.
"""
out = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_deploy_packages\DMF0082_CLOUD_20260826_PENDING\A_DB\26_LOOKUP_INSMEAS81.sql")
out.write_text(hdr + "\n\n".join(lit_rows) + "\nCOMMIT;\n", encoding="utf-8")
print("26_ 이관 SQL 생성:", out.name, flush=True)
