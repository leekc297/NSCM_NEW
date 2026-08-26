# -*- coding: utf-8 -*-
"""AS_In_Req 룩업 등재(81/81_UC — 정본 축) + 콤보 3분기 검증 + 이관물 동기"""
import io, sys, pathlib
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace", line_buffering=True)
import oracledb
from ora import conn_info

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

MERGE = """MERGE INTO SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL T
USING (SELECT 'DM_UI_EDITABLE_MEASURE' LT, 'DMF0082' S1, :dv S2, 'AS_In_Req' S3, 'AS In Request[R+P]' S4, '-' S5 FROM DUAL) S
ON (T.LOOKUP_TYPE=S.LT AND T.SEGMENT1=S.S1 AND T.SEGMENT2=S.S2 AND T.SEGMENT3=S.S3 AND T.SEGMENT4=S.S4 AND T.SEGMENT5=S.S5)
WHEN MATCHED THEN UPDATE SET T.ATTRIBUTE1='Y', T.ATTRIBUTE2='Y', T.ATTRIBUTE3='ALL', T.DISPLAY_SEQ=403,
    T.VALID_YN='Y', T.DESCRIPTION='E20260826-ASINSREQ W/S AS_In_Req Insert 개방 (MKT_FCST_MEASURE 81 정본 INSERT Y)',
    T.LAST_UPDATED_BY='admin', T.LAST_UPDATE_DATE=SYSDATE
WHEN NOT MATCHED THEN INSERT (LOOKUP_TYPE, SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5,
    DISPLAY_SEQ, VALID_YN, DESCRIPTION, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3,
    CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES ('DM_UI_EDITABLE_MEASURE', 'DMF0082', :dv, 'AS_In_Req', 'AS In Request[R+P]', '-', 403, 'Y',
    'E20260826-ASINSREQ W/S AS_In_Req Insert 개방 (MKT_FCST_MEASURE 81 정본 INSERT Y)', 'Y', 'Y', 'ALL',
    'admin', SYSDATE, 'admin', SYSDATE)"""
for dv in ("81", "81_UC"):
    cur.execute(MERGE, dv=dv)
con.commit()
print("룩업 등재 2행 (81/81_UC) 커밋", flush=True)

# AS_SITE_PLANT 81 등재 사이트 1개 실측 (콤보 3분기용)
cur.execute("""SELECT SEGMENT1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
    WHERE LOOKUP_TYPE='AS_SITE_PLANT' AND VALID_YN='Y' AND SEGMENT3='81' AND ROWNUM=1""")
r = cur.fetchone()
as_site = r[0] if r else None
print("AS 사이트 샘플:", as_site, flush=True)

cur.execute("SELECT SQL_DTL_CTN FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID='FcstPriceEditMeasure'")
lob = cur.fetchone()[0]
base = lob.read() if hasattr(lob, "read") else str(lob)
cases = [("미입력", " "), ("고객향(Audi_SK_BTS)", "Audi_SK_BTS")]
if as_site:
    cases.append(("비축향(AS: %s)" % as_site, as_site))
for desc, site in cases:
    q = base.replace("@divisionId", "'81'").replace("@scmSiteId", "'" + site + "'").replace("@bucketType", "'W'")
    cur.execute(q)
    print("  콤보(81, %s): %s" % (desc, [rr[0] for rr in cur.fetchall()]), flush=True)

# 폼 LOC 축 회귀
cur.execute("""SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
    WHERE LOOKUP_TYPE='DM_UI_EDITABLE_MEASURE' AND SEGMENT1='DMF0082' AND SEGMENT3='LOC'
      AND SEGMENT2 LIKE '81%' AND ATTRIBUTE1='Y' AND VALID_YN='Y'""")
print("폼 LOC 축(6 기대):", cur.fetchone()[0], flush=True)

# 이관물: 26_ 에 AS_In_Req 2행 append + BODY 재덤프(마커 17종)
p26 = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_deploy_packages\DMF0082_CLOUD_20260826_PENDING\A_DB\26_LOOKUP_INSMEAS81.sql")
t26 = p26.read_text(encoding="utf-8")
if "ASINSREQ" not in t26:
    lit = []
    for dv in ("81", "81_UC"):
        lit.append(MERGE.replace(":dv", "'" + dv + "'") + ";")
    t26 = t26.replace("-- [E20260826-INSMEAS81]", "-- [E20260826-INSMEAS81 + E20260826-ASINSREQ]")
    t26 = t26.rstrip() + "\n\n-- [E20260826-ASINSREQ] W/S AS_In_Req Insert 개방 (BODY 저장 게이트 4지점과 동시 배포)\n" + "\n\n".join(lit) + "\nCOMMIT;\n"
    p26.write_text(t26, encoding="utf-8")
    print("26_ 확장 (AS_In_Req 2행)", flush=True)

cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082'
               AND TYPE='PACKAGE BODY' ORDER BY LINE""")
src = "".join(t for (t,) in cur if t is not None)
con.close()
root = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_deploy_packages\DMF0082_CLOUD_20260826_PENDING")
bp = root / "A_DB" / "02_PKG_DMF0082_BODY.sql"
old = bp.read_text(encoding="utf-8")
banner = old[:old.find("CREATE OR REPLACE")]
banner = banner.replace("2026-08-26 v2", "2026-08-26 v3").replace("마커 16종", "마커 17종")
banner = banner.replace("/ E20260826-CUSTSUBR 1", "/ E20260826-CUSTSUBR 1 / E20260826-ASINSREQ 4")
bp.write_text(banner + "CREATE OR REPLACE " + src.rstrip() + "\n/\n", encoding="utf-8")
print("02 BODY(v3): ASINSREQ=%d" % src.count("E20260826-ASINSREQ"), flush=True)

vp = root / "A_DB" / "90_VERIFY.sql"
v = vp.read_text(encoding="utf-8")
v = v.replace("  SELECT 'E20260826-CUSTSUBR', 1 FROM DUAL)",
              "  SELECT 'E20260826-CUSTSUBR', 1 FROM DUAL UNION ALL\n  SELECT 'E20260826-ASINSREQ', 4 FROM DUAL)")
v = v.replace("마커 16종", "마커 17종")
vp.write_text(v, encoding="utf-8")
print("90_VERIFY 17종", flush=True)

lp = pathlib.Path(r"C:\Projects\NSCM\Doc\단위테스트_보완대상\보완요청_원장.md")
t = lp.read_text(encoding="utf-8")
anchor = "\ucf64\ubcf4 \uc2e4\ud589(81)=MKT FCST[R+P]+LOC\u00b7Excel Form LOC \ucd95 \ubd88\ubcc0(6)\u00b7\uba71\ub4f1 |"
assert t.count(anchor) == 1
row = ("\n| REQ:CHAT-20260826-7 | \ub300\ud654 \uc9c0\uc815 2026-08-26 | 81 AS_In_Req = DM Planner(W/S) \uc785\ub825 \uac00\ub2a5 \ucc98\ub9ac (AS-IS \ub85c\uc9c1 \ud655\uc778) | DMF0082 "
       "| EV:_artifacts/_apply_corporate/DMF0082_XLSBATCH_20260825/edits_asinsreq.json::E20260826-ASINSREQ | VERIFIED | Y | N "
       "| AS-IS \uc2e4\uce21: DMF0003 \uc800\uc7a5\uc740 \uba54\uc800 \ubb34\ud544\ud130(\ud589\ubcc4 DELETE+INSERT) \u2014 AS_In_Req \uc800\uc7a5\ub428. DMF0082 \uacb0\uc190=81 DELETE/MERGE/\uc774\ub825 \uac8c\uc774\ud2b8 3\uc9c0\uc810 IN('MKT_FCST','VMI_In_Req') + \ub8e9\uc5c5 \ubbf8\ub4f1\uc7ac. "
       "\uc815\uc815=\uac8c\uc774\ud2b8 4\uc9c0\uc810 AS_In_Req \ucd94\uac00 + DM_UI_EDITABLE_MEASURE 81/81_UC \ub4f1\uc7ac(\uc815\ubcf8 MKT_FCST_MEASURE 81\u00b781_UC INSERT Y \ucd95 \uadf8\ub300\ub85c). "
       "W/S \uad8c\ud55c \uac8c\uc774\ud2b8\ub294 \uae30\uc874 \uc644\ube44: FE isAsMeasureAllowed(wsPlannerYn)\uac00 \ud6c4\ubcf4\uc5d0\uc11c \uc81c\uac70\u00b7SP MEASRULE W/S EXISTS\u00b7\uc800\uc7a5 Incoterms/AS FROM SITE \uac80\uc99d \uc774\ubbf8 \uc774\uc2dd. "
       "\uac80\uc99d: \ucf64\ubcf4 3\ubd84\uae30(\ubbf8\uc785\ub825/\uace0\uac1d\ud5a5/\ube44\ucd95\ud5a5) \uc2e4\ud589\u00b7\ud3fc LOC \ucd95 \ubd88\ubcc0\u00b7VALID. BOD\u00b7\uc218\uc9d1 \uac8c\uc774\ud2b8\ub294 AS-IS \ub3d9\uc77c\ud558\uac8c MKT/VMI \ud55c\uc815 \uc720\uc9c0(\ud30c\ub9ac\ud2f0) |")
t = t.replace(anchor, anchor + row)
lp.write_text(t, encoding="utf-8")
print("원장 REQ-7 등재", flush=True)
