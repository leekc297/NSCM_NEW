#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""SYS0014 i18n(SCM_ADM_MSG_M) MERGE 생성. 기존 5키 DB 덤프 + LBL00653(User Info, DB 미존재 신규) 3언어 추가."""
import os, pathlib, oracledb
USER=os.environ['NSCM_ORA_USER']; DSN=os.environ['NSCM_ORA_DSN']; PWD=os.environ['NSCM_ORA_PASS']
OUT = pathlib.Path("C:/Projects/NSCM/_artifacts/_deploy_packages/SYS0014_CLOUD_20260626/02_DB_META/08_i18n_MSG.sql")
cn=oracledb.connect(user=USER,password=PWD,dsn=DSN); cur=cn.cursor()

KEYS=['MNU_SYS0014','MNU00056','LBL00357','LBL00641','LBL00642']
cur.execute("""SELECT MSG_ID, LANG_CD, MSG_NM, MSG_DESC, MSG_TP_CD, USE_YN
               FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID IN ({})""".format(
               ",".join(f"'{k}'" for k in KEYS)))
rows=[list(r) for r in cur.fetchall()]
# LBL00658 (User Info) — LBL00653 이 클라우드 점유 → LBL00658 사용. LBL 컨벤션 복제, 3언어.
tp = next((r[4] for r in rows if r[0].startswith('LBL')), 'LBL')
for lang,val in [('KO','User Info'),('EN','User Info'),('CN','用户信息')]:
    rows.append(['LBL00658', lang, val, val, tp, 'Y'])

def q(v):
    if v is None or v=='': return 'NULL'
    return "'" + str(v).replace("'","''") + "'"

src=[]
for r in rows:
    mid,lang,nm,desc,tp_,use = r
    src.append(f"  SELECT {q(mid)} MSG_ID, {q(lang)} LANG_CD, {q(nm)} MSG_NM, {q(desc)} MSG_DESC, "
               f"{q(tp_)} MSG_TP_CD, {q(use or 'Y')} USE_YN FROM DUAL")
sql=f"""-- SYS0014 i18n (SCM_ADM_MSG_M) — MERGE INTO (멱등). 기존 5키 + LBL00658(User Info, DB 신규).
-- ⚠️ LBL00653 은 클라우드 점유 → User Info = LBL00658 사용. KEY: MSG_ID, LANG_CD. 대상: {len(rows)} 행
MERGE INTO SCM_MGR.SCM_ADM_MSG_M T
USING (
{chr(10).join(s+(' UNION ALL' if i<len(src)-1 else '') for i,s in enumerate(src))}
) S
ON (T.MSG_ID=S.MSG_ID AND T.LANG_CD=S.LANG_CD)
WHEN MATCHED THEN UPDATE SET T.MSG_NM=S.MSG_NM, T.MSG_DESC=S.MSG_DESC, T.MSG_TP_CD=S.MSG_TP_CD,
  T.USE_YN=S.USE_YN, T.LAST_UPDATED_BY='jv_migration', T.LAST_UPDATE_DATE=SYSDATE
WHEN NOT MATCHED THEN INSERT (MSG_ID, LANG_CD, MSG_NM, MSG_DESC, MSG_TP_CD, USE_YN,
  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  VALUES (S.MSG_ID, S.LANG_CD, S.MSG_NM, S.MSG_DESC, S.MSG_TP_CD, S.USE_YN,
  'admin', SYSDATE, 'admin', SYSDATE);
COMMIT;
"""
OUT.write_text(sql, encoding='utf-8')
print(f"08_i18n_MSG.sql: {len(rows)} rows (5 keys DB + LBL00653 x3 신규)")
