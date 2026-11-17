# -*- coding: utf-8 -*-
"""SCP0104 사용자의견 DB 보완 — 데이터·메타 (2026-11-17)
  python apply_data.py --check   현재값 조회만
  python apply_data.py --apply   적용(대상 행 현재값 재조회 → 기대값과 같을 때만 · 멱등)

① 상위 메뉴 Capa Plan 폴더 권한: 하위 6개 화면(SCP0104~0108·0114) 권한 그룹 중 폴더 권한이 없는 7개 그룹 추가
   (사용자 확정 11-17 Q13 · 다른 폴더 Supply_Plan 등은 하위 권한 그룹 = 폴더 권한 그룹)
② SOP 그리드 컬럼 정렬 번호 = AS-IS SCM_MST_SHEET_COLUMNS (사용자 확정 11-17 Q9)
   SOP_ASSEMBLY.ELTR_LN_TP_CD 200→150 · SOP_ASSEMBLY.SOP_DT 200→190 · SOP_ELTR.SOP_DT 200→170
되돌리기: logs/data_before.json 의 값으로 UPDATE · 추가한 권한 행 DELETE(USER_GR_ID 7개 · MNU_ID='Capa Plan')
"""
import sys, os, json, datetime
sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
import dbconn
HERE = os.path.dirname(os.path.abspath(__file__))
mode = sys.argv[1]
USER = 'minyonglee1'
GROUPS = ['CAPA Planner', 'FP Planner', 'FP Viewer', 'SCM PI Admin', 'SCM Viewer', 'SCP Planner', 'SCP Tester']
META = [('SOP_ASSEMBLY', 'ELTR_LN_TP_CD', 200, 150), ('SOP_ASSEMBLY', 'SOP_DT', 200, 190), ('SOP_ELTR', 'SOP_DT', 200, 170)]
con = dbconn.connect('tobe', write=(mode == '--apply'))
cur = con.cursor()
now = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')


def snap():
    cur.execute("SELECT USER_GR_ID, USE_YN FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID='Capa Plan' ORDER BY 1")
    perm = cur.fetchall()
    cur.execute("SELECT DISTINCT USER_GR_ID FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE USE_YN='Y' AND MNU_ID IN (SELECT MNU_ID FROM SCM_ADM_MNU_M WHERE UPPR_MNU_ID='Capa Plan') ORDER BY 1")
    child = [r[0] for r in cur.fetchall()]
    meta = []
    for sh, col, _, _ in META:
        cur.execute("SELECT COUNT(*), MIN(SORT_ORDER_NO), MAX(SORT_ORDER_NO) FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='SCP0104' AND SHEET_NAME=:s AND COLUMN_NAME=:c", s=sh, c=col)
        meta.append((sh, col) + tuple(cur.fetchone()))
    return dict(perm=perm, child_groups=child, meta=meta)


s0 = snap()
print('[%s] %s' % (now, mode))
print(' Capa Plan 폴더 권한', s0['perm'])
print(' 하위 화면 권한 그룹', s0['child_groups'])
print(' 메타', s0['meta'])
if mode == '--apply':
    os.makedirs(os.path.join(HERE, 'logs'), exist_ok=True)
    p = os.path.join(HERE, 'logs', 'data_before.json')
    if not os.path.exists(p):
        json.dump(dict(at=now, **s0), open(p, 'w', encoding='utf-8'), ensure_ascii=False, default=str, indent=1)
    have = {g for g, _ in s0['perm']}
    add = [g for g in GROUPS if g not in have and g in s0['child_groups']]
    for g in add:
        cur.execute("INSERT INTO SCM_ADM_USER_GR_MNU_MPG_M (USER_GR_ID, MNU_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) "
                    "SELECT :g, 'Capa Plan', 'Y', :u, SYSDATE, :u, SYSDATE FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE USER_GR_ID=:g AND MNU_ID='Capa Plan')", g=g, u=USER)
        print('  권한 추가', g, cur.rowcount)
    for sh, col, old, new in META:
        cur.execute("UPDATE SCM_MST_SHEET_COLUMNS SET SORT_ORDER_NO=:n, LAST_UPDATED_BY=:u, LAST_UPDATE_DATE=SYSDATE "
                    "WHERE PROGRAM_ID='SCP0104' AND SHEET_NAME=:s AND COLUMN_NAME=:c AND SORT_ORDER_NO=:o", n=new, u=USER, s=sh, c=col, o=old)
        print('  메타', sh, col, old, '→', new, cur.rowcount)
    con.commit()
    s1 = snap()
    print(' 적용 후 폴더 권한', s1['perm'])
    print(' 적용 후 메타', s1['meta'])
    json.dump(dict(at=datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'), **s1), open(os.path.join(HERE, 'logs', 'data_after.json'), 'w', encoding='utf-8'), ensure_ascii=False, default=str, indent=1)
