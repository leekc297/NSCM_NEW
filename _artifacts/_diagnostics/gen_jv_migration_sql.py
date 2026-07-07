#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""asis_jv_data.json → SYS0014 JV Planner 실데이터 이관 SQL 생성 (컬럼 추가 없음, 데이터만).
대상: SCM_ADM_USER_M(11) + SCM_ADM_USER_GR_MPG_M(11) + TB_FX_USERGROUPAUTHEXTENTION(17 J auth).
모두 WHERE NOT EXISTS 멱등. JV_PLANT 은 TB_FX_USERGROUPAUTHEXTENTION.JV_PLANT_ID(기존 컬럼)에 적재."""
import json, pathlib

d = json.load(open(pathlib.Path(__file__).resolve().parent/'asis_jv_data.json', encoding='utf-8'))
def q(v):
    if v is None or v == '': return 'NULL'
    return "'" + str(v).replace("'", "''") + "'"
def qnn(v, default='-'):  # NOT NULL 컬럼: 빈값이면 default
    if v is None or v == '': v = default
    return "'" + str(v).replace("'", "''") + "'"

L = []
L.append("-- SYS0014 JV Planner 실데이터 이관 (2026-06-26) — 컬럼 추가 없이 데이터만 (사용자: TABLE COLUMN 추가 금지)")
L.append("-- 멱등: 전부 WHERE NOT EXISTS. JV_PLANT = TB_FX_USERGROUPAUTHEXTENTION.JV_PLANT_ID(기존 컬럼).")
L.append("")

L.append("-- 1) user master (11) — 이름 표시용 (AS-IS TB_FX_User 실데이터)")
for u in d['users']:
    uid=q(u['UserID']); nm=qnn(u['UserName']); en=q(u['UserName_E']); em=q(u['Email']); dp=q(u['Dept_ID'])
    L.append(
"INSERT INTO SCM_MGR.SCM_ADM_USER_M (USER_ID,USER_NM,USER_ENG_NM,USER_EML,DEPT_ID,ACNT_LOK_YN,TMZ_CD,USE_YN,PERM_KEP_CNC_YN,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE) "
f"SELECT {uid},{nm},{en},{em},{dp},'Y','AS054','Y','N','jv_migration',SYSDATE,'jv_migration',SYSDATE FROM DUAL "
f"WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_M WHERE USER_ID={uid});")
L.append("")

L.append("-- 2) group-user mapping (11) — JV Planner 그룹 사용자 (AS-IS TB_FX_UserGroupInfo)")
for m in d['mapping']:
    uid=q(m['UserID']); use=qnn(m['UseYN'], 'Y')
    L.append(
"INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MPG_M (USER_GR_ID,USER_ID,USE_YN,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE) "
f"SELECT 'JV Planner',{uid},{use},'jv_migration',SYSDATE,'jv_migration',SYSDATE FROM DUAL "
f"WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M WHERE USER_GR_ID='JV Planner' AND USER_ID={uid});")
L.append("")

L.append("-- 3) J auth 17 (DIVISION + JV_PLANT) → TB_FX_USERGROUPAUTHEXTENTION (JV_PLANT_ID 기존 컬럼)")
for a in d['auth']:
    uid=q(a['UserID']); code=q(a['Code']); jv=q(a['JV_PLANT_ID'])
    L.append(
"INSERT INTO SCM_MGR.TB_FX_USERGROUPAUTHEXTENTION (GROUPID,USERID,AUTHTYPE,CODE,PRNTCODE,REGTUSERID,REGTDATETIME,UPDATEUSERID,UPDATEDATETIME,JV_PLANT_ID) "
f"SELECT 'JV Planner',{uid},'J',{code},'-','jv_migration',SYSDATE,'jv_migration',SYSDATE,{jv} FROM DUAL "
f"WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.TB_FX_USERGROUPAUTHEXTENTION WHERE GROUPID='JV Planner' AND USERID={uid} AND AUTHTYPE='J' AND CODE={code});")
L.append("")
L.append("COMMIT;")

out = pathlib.Path("C:/Projects/NSCM/_artifacts/_deploy_packages/SYS0014/03_META/08_JV_PLANNER_DATA_MIGRATION.sql")
out.write_text("\n".join(L), encoding='utf-8')
print("rows:", len(d['users']),"users +",len(d['mapping']),"mappings +",len(d['auth']),"auth")
print("-> wrote", out, "(", len(L), "lines )")
