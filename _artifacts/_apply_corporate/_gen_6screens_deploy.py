#!/usr/bin/env python3
"""6 화면 클라우드 이관 패키지 일괄 생성."""
import os, shutil, oracledb

SCREENS = {
    'SYS0010': {'fe_path': 'nscm-fe/features/admin/src/pages/lookup',                 'name': 'Lookup'},
    'SYS0011': {'fe_path': 'nscm-fe/features/authority/src/pages/auth-request',       'name': 'Auth Request'},
    'SYS0012': {'fe_path': 'nscm-fe/features/authority/src/pages/auth-approval',      'name': 'Auth Approval'},
    'SYS0013': {'fe_path': 'nscm-fe/features/admin/src/pages/dynamic-query',          'name': 'Dynamic Query'},
    'SYS0014': {'fe_path': 'nscm-fe/features/admin/src/pages/group-user',             'name': 'Group User'},
    'SYS0015': {'fe_path': 'nscm-fe/features/admin/src/pages/program',                'name': 'Program'},
}
BASE = 'C:/Projects/NSCM/_artifacts/_deploy_packages'
os.chdir('C:/Projects/NSCM')

def esc(s):
    """SQL 문자열 escape (single quote 이스케이프)."""
    if s is None:
        return None
    return s.replace("'", "''")

conn = oracledb.connect(user='SCM_MGR', password='!SCMroqkf2026', dsn='121.162.245.167:2521/ESSCMD')
cur = conn.cursor()

for mid, info in SCREENS.items():
    DEPLOY = f'{BASE}/{mid}_v1_full'
    for sub in ('01_FE', '03_META', '04_PKG_SP'):
        os.makedirs(f'{DEPLOY}/{sub}', exist_ok=True)

    # 1) FE 복사
    fe_dst = f"{DEPLOY}/01_FE/{os.path.basename(info['fe_path'])}"
    shutil.rmtree(fe_dst, ignore_errors=True)
    shutil.copytree(info['fe_path'], fe_dst)

    # 2) MNU + i18n
    cur.execute("SELECT MNU_ID, UPPR_MNU_ID, MNU_URL, MNU_MSG_ID, MNU_DESC FROM SCM_ADM_MNU_M WHERE MNU_ID=:m", m=mid)
    mr = cur.fetchone()
    with open(f'{DEPLOY}/03_META/01_MNU_i18n.sql', 'w', encoding='utf-8') as f:
        if mr:
            mnu_desc = esc(mr[4] or info['name'])
            f.write(f"-- {mid} {info['name']} 메뉴 등록\n")
            f.write(f"MERGE INTO SCM_ADM_MNU_M t USING (SELECT '{mid}' MNU_ID FROM DUAL) s ON (t.MNU_ID=s.MNU_ID)\n")
            f.write(f" WHEN MATCHED THEN UPDATE SET MNU_DESC='{mnu_desc}', UPPR_MNU_ID='{mr[1]}', MNU_URL='{mr[2]}', LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE\n")
            f.write(f" WHEN NOT MATCHED THEN INSERT (MNU_ID, UPPR_MNU_ID, MNU_URL, MNU_MSG_ID, MNU_DESC, SORT_ORD, MNU_LV_NO, MNU_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)\n")
            f.write(f"   VALUES ('{mid}','{mr[1]}','{mr[2]}','{mr[3] or f'MNU_{mid}'}','{mnu_desc}', 1, 3, 'SCREEN','Y','admin',SYSDATE,'admin',SYSDATE);\n")
        # i18n KO/EN/CN
        cur.execute("SELECT LANG_CD, MSG_NM FROM SCM_ADM_MSG_M WHERE MSG_ID=:m ORDER BY LANG_CD", m=f'MNU_{mid}')
        for lang, msg in cur.fetchall():
            msg_e = esc(msg)
            f.write(f"\nMERGE INTO SCM_ADM_MSG_M t USING (SELECT 'MNU_{mid}' MSG_ID, '{lang}' LANG_CD FROM DUAL) s ON (t.MSG_ID=s.MSG_ID AND t.LANG_CD=s.LANG_CD)\n")
            f.write(f" WHEN MATCHED THEN UPDATE SET MSG_NM='{msg_e}', LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE\n")
            f.write(f" WHEN NOT MATCHED THEN INSERT (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)\n")
            f.write(f"   VALUES ('MNU_{mid}','{lang}','{msg_e}','MENU','Y','admin',SYSDATE,'admin',SYSDATE);\n")
        f.write("\nCOMMIT;\n")

    # 3) SHEET_COLUMNS
    cur.execute(
        "SELECT SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, COLUMN_WIDTH, INPUT_TP_CD, CELL_CONTROL_OBJECT_TYPE_CODE, "
        "ATTRIBUTE1, ATTRIBUTE2, SORT_ORDER_NO, HORIZONTAL_ALIGN_CODE, FIXED_FLAG, VISIBLE_FLAG "
        "FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID=:m ORDER BY SHEET_NAME, SORT_ORDER_NO", m=mid)
    cols = cur.fetchall()
    sheets = sorted(set(r[0] for r in cols))
    with open(f'{DEPLOY}/03_META/02_SHEET_COLUMNS.sql', 'w', encoding='utf-8') as f:
        f.write(f"-- {mid} SHEET_COLUMNS ({len(sheets)} sheets / {len(cols)} cols)\n")
        for sht in sheets:
            f.write(f"DELETE FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='{mid}' AND SHEET_NAME='{sht}';\n")
        for r in cols:
            a1 = "'" + esc(r[6]) + "'" if r[6] else 'NULL'
            a2 = "'" + esc(r[7]) + "'" if r[7] else 'NULL'
            ctrl = "'" + esc(r[5]) + "'" if r[5] else 'NULL'
            inp = "'" + esc(r[4]) + "'" if r[4] else 'NULL'
            lbl = esc(r[2] or r[1])
            f.write(f"INSERT INTO SCM_MST_SHEET_COLUMNS (PROGRAM_ID, SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, COLUMN_WIDTH, INPUT_TP_CD, CELL_CONTROL_OBJECT_TYPE_CODE, ATTRIBUTE1, ATTRIBUTE2, SORT_ORDER_NO, HORIZONTAL_ALIGN_CODE, FIXED_FLAG, VISIBLE_FLAG, VALID_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) ")
            f.write(f"VALUES ('{mid}','{r[0]}','{r[1]}','{lbl}',{r[3] or 100},{inp},{ctrl},{a1},{a2},{r[8] or 1},'{r[9] or 'C'}','{r[10] or 'N'}','{r[11] or 'Y'}','Y','admin',SYSDATE,'admin',SYSDATE);\n")
        f.write("COMMIT;\n")

    # 4) MNU_BTN_MPG
    cur.execute("SELECT SHT_NM, MNU_BTN_CD, API_ID FROM SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID=:m ORDER BY SHT_NM, MNU_BTN_CD", m=mid)
    btns = cur.fetchall()
    with open(f'{DEPLOY}/03_META/03_MNU_BTN_MPG.sql', 'w', encoding='utf-8') as f:
        f.write(f"-- {mid} buttons ({len(btns)})\n")
        for r in btns:
            f.write(f"MERGE INTO SCM_ADM_MNU_BTN_MPG_M t USING (SELECT '{mid}' MNU_ID, '{r[0]}' SHT_NM, '{r[1]}' MNU_BTN_CD FROM DUAL) s\n")
            f.write(f"   ON (t.MNU_ID=s.MNU_ID AND t.SHT_NM=s.SHT_NM AND t.MNU_BTN_CD=s.MNU_BTN_CD)\n")
            f.write(f" WHEN MATCHED THEN UPDATE SET API_ID='{r[2]}', USE_YN='Y', LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE\n")
            f.write(f" WHEN NOT MATCHED THEN INSERT (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)\n")
            f.write(f"   VALUES ('{mid}','{r[0]}','{r[1]}','{r[2]}','Y','admin',SYSDATE,'admin',SYSDATE);\n")
        f.write("COMMIT;\n")

    # 5) API_M — MNU_BTN_MPG_M 의 API_ID 기준 추출 (LIKE prefix 패턴 불충분, 예: SYS0013 → API_SCM0005_*)
    api_ids = sorted(set(b[2] for b in btns if b[2]))
    if api_ids:
        ph = ','.join([f':v{i}' for i in range(len(api_ids))])
        binds = dict((f'v{i}', v) for i, v in enumerate(api_ids))
        cur.execute(f"SELECT API_ID, API_TP_CD, API_MSG_ID, API_URL FROM SCM_ADM_API_M WHERE API_ID IN ({ph}) ORDER BY API_ID", binds)
        apis = cur.fetchall()
    else:
        apis = []
    with open(f'{DEPLOY}/03_META/04_API_M.sql', 'w', encoding='utf-8') as f:
        f.write(f"-- {mid} APIs ({len(apis)})\n")
        for r in apis:
            f.write(f"MERGE INTO SCM_ADM_API_M t USING (SELECT '{r[0]}' API_ID FROM DUAL) s ON (t.API_ID=s.API_ID)\n")
            f.write(f" WHEN MATCHED THEN UPDATE SET API_TP_CD='{r[1]}', API_MSG_ID='{r[2]}', API_URL='{r[3]}', USE_YN='Y', LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE\n")
            f.write(f" WHEN NOT MATCHED THEN INSERT (API_ID, API_TP_CD, API_MSG_ID, API_URL, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)\n")
            f.write(f"   VALUES ('{r[0]}','{r[1]}','{r[2]}','{r[3]}','Y','admin',SYSDATE,'admin',SYSDATE);\n")
        f.write("COMMIT;\n")

    # 6) PROC_M
    sps = sorted(set(a[3] for a in apis if a[3]))
    with open(f'{DEPLOY}/03_META/05_PROC_M.sql', 'w', encoding='utf-8') as f:
        f.write(f"-- {mid} PROC_M ({len(sps)} SPs)\n")
        for sp in sps:
            cur.execute("SELECT COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD FROM SCM_ADM_PROC_M WHERE PROC_NM=:p ORDER BY SORT_ORD", p=sp)
            rs = cur.fetchall()
            if rs:
                f.write(f"\nDELETE FROM SCM_ADM_PROC_M WHERE PROC_NM='{sp}';\n")
                for c in rs:
                    f.write(f"INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('{sp}','{c[0]}','{c[1]}','{c[2]}',{c[3]},'admin',SYSDATE,'admin',SYSDATE);\n")
        f.write("\nCOMMIT;\n")

    # 7) USER_GR
    with open(f'{DEPLOY}/03_META/06_USER_GR_BTN.sql', 'w', encoding='utf-8') as f:
        f.write(f"-- {mid} 사용자 그룹 권한 (minyonglee1 그룹 동적 복사)\n")
        f.write("INSERT INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)\n")
        f.write("SELECT DISTINCT u.USER_GR_ID, b.MNU_ID, b.SHT_NM, b.MNU_BTN_CD, 'Y', 'admin', SYSDATE, 'admin', SYSDATE\n")
        f.write("  FROM SCM_ADM_MNU_BTN_MPG_M b\n")
        f.write("  CROSS JOIN (SELECT DISTINCT USER_GR_ID FROM SCM_ADM_USER_GR_MPG_M WHERE USER_ID='minyonglee1') u\n")
        f.write(f" WHERE b.MNU_ID='{mid}'\n")
        f.write("   AND NOT EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M e\n")
        f.write("                    WHERE e.USER_GR_ID=u.USER_GR_ID AND e.MNU_ID=b.MNU_ID AND e.SHT_NM=b.SHT_NM AND e.MNU_BTN_CD=b.MNU_BTN_CD);\n")
        f.write("COMMIT;\n")

    # 8) SP body
    standalone = [s for s in sps if not s.startswith('PKG_')]
    pkgs = sorted(set(s.split('.')[0] for s in sps if s.startswith('PKG_')))
    sp_n = 0
    for sp_name in standalone:
        cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME=:n AND TYPE='PROCEDURE' ORDER BY LINE", n=sp_name)
        body = ''.join(r[0] for r in cur.fetchall())
        if body:
            with open(f'{DEPLOY}/04_PKG_SP/{sp_name}.sql', 'w', encoding='utf-8') as f:
                f.write('ALTER SESSION SET DDL_LOCK_TIMEOUT=120;\nCREATE OR REPLACE ' + body + '\n/\nSHOW ERRORS;\n')
            sp_n += 1
    for pkg in pkgs:
        cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME=:n AND TYPE='PACKAGE' ORDER BY LINE", n=pkg)
        spec = ''.join(r[0] for r in cur.fetchall())
        if spec:
            with open(f'{DEPLOY}/04_PKG_SP/{pkg}_SPEC.sql', 'w', encoding='utf-8') as f:
                f.write('CREATE OR REPLACE ' + spec + '\n/\nSHOW ERRORS;\n')
            sp_n += 1
        cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME=:n AND TYPE='PACKAGE BODY' ORDER BY LINE", n=pkg)
        body = ''.join(r[0] for r in cur.fetchall())
        if body:
            with open(f'{DEPLOY}/04_PKG_SP/{pkg}_BODY.sql', 'w', encoding='utf-8') as f:
                f.write('ALTER SESSION SET DDL_LOCK_TIMEOUT=120;\nCREATE OR REPLACE ' + body + '\n/\nSHOW ERRORS;\n')
            sp_n += 1

    # 9) README
    with open(f'{DEPLOY}/00_README.md', 'w', encoding='utf-8') as f:
        f.write(f"# {mid} {info['name']} — 클라우드 이관 패키지 v1 full\n\n")
        f.write(f"생성일: 2026-06-12\n작성자: minyonglee1\n범위: {mid} ({info['name']}) 전체 파일\n\n")
        f.write("## 1. 변경 요약\n\n")
        f.write("- UI 동적 속성관리 (master hook) 적용: store staticColumns + fetchStaticColumns + Grid prop + Search refetch\n")
        f.write("- FE source: " + info['fe_path'].replace('nscm-fe/','') + "\n\n")
        f.write("## 2. 폴더 구조\n\n```\n")
        f.write(f"{mid}_v1_full/\n├─ 00_README.md\n├─ 01_FE/{os.path.basename(info['fe_path'])}/\n")
        f.write("├─ 03_META/\n│  ├─ 01_MNU_i18n.sql\n│  ├─ 02_SHEET_COLUMNS.sql\n")
        f.write("│  ├─ 03_MNU_BTN_MPG.sql\n│  ├─ 04_API_M.sql\n│  ├─ 05_PROC_M.sql\n│  └─ 06_USER_GR_BTN.sql\n")
        f.write("└─ 04_PKG_SP/\n```\n\n")
        f.write("## 3. 적용 순서\n\n### Step 1. FE 복사\n```bash\ncd nscm-fe/\n")
        fe_parent = os.path.dirname(info['fe_path']).replace('nscm-fe/','')
        f.write(f"cp -r /path/01_FE/{os.path.basename(info['fe_path'])}  {fe_parent}/\npnpm type-check && pnpm build\n```\n\n")
        f.write("### Step 2. SP body 컴파일\n```sql\n@04_PKG_SP/*.sql\n```\n\n")
        f.write("### Step 3. DB 메타\n```sql\n@03_META/01_MNU_i18n.sql\n@03_META/02_SHEET_COLUMNS.sql\n@03_META/03_MNU_BTN_MPG.sql\n@03_META/04_API_M.sql\n@03_META/05_PROC_M.sql\n@03_META/06_USER_GR_BTN.sql\n```\n\n")
        f.write("### Step 4. BE 재기동\n\n### Step 5. 화면 검증\n\n")
        f.write("## 4. 참조 룰\n\n")
        f.write("- master hook: `Doc/_rules_v2/hooks/ui-dynamic-property-management.md`\n")
        f.write("- column 메타: `Doc/_rules_v2/hooks/ui-category-setup-column-meta.md`\n")
        f.write("- button: `Doc/_rules_v2/hooks/menu-button-dynamic-fetch.md`\n")
        f.write("- 클라우드 type-check: `Doc/_rules_v2/hooks/fe-cloud-type-lint-readiness.md`\n")

    # 10) zip
    parent = os.path.dirname(DEPLOY)
    base = os.path.basename(DEPLOY)
    zip_path = f'{parent}/{base}.zip'
    if os.path.exists(zip_path):
        os.remove(zip_path)
    shutil.make_archive(f'{parent}/{base}', 'zip', parent, base)
    sz = os.path.getsize(zip_path) / 1024
    print(f'[{mid}] cols={len(cols)} btns={len(btns)} apis={len(apis)} sps={sp_n} ({sz:.1f} KB) → {base}.zip')

conn.close()
print('\nALL 6 packages generated.')
