# -*- coding: utf-8 -*-
"""사내오라클(ZIOUI1) E2E 실저장 잔존 복원 (2026-11-07 · 6화면 PoC diff 실측으로 발견)
대상(AS-IS DEV MSSQL 원값과 다르고 LAST_UPDATED/UPDATE_USER 가 E2E 계정 minyonglee1 인 행 — diff/*.csv 불일치 셀 그대로):
  1) SCP_ANL_LONG_TERM_STOCK (SCP0084) MEMO 3행 — AS-IS '' ↔ TO-BE 'test2'/'testX'/'test3' (UPDATE_USER_ID=minyonglee1 · 20261106 152033 / 20261107 015444)
     원인: 검사기 결함 T131(가로 가상화 DOM 순번→컬럼 오인)로 원복 저장이 LEVEL_2_NAME 을 겨냥해 실패 → 'testX' 잔존(이전 실행 'test2'·'test3' 도 동일 경로)
  2) SCP_OPMZ_PRECEDE_SAFETY_STOCK_DAY (SCP0127) VALID_YN 1행 — AS-IS 'N' ↔ TO-BE 'Y' (minyonglee1 2026-11-03 14:22:22 · EE|AZ00-E|PG0057|COATING|APCCA3565A|MAX|20260511|20991231)
절차(hook #152 §1-6 메타/데이터 동일): 적용 전 대상 행 현재값 재조회·CSV 백업(00_BACKUP) → 기대 현재값과 다르면 중단 → UPDATE → 재조회 확인 → 99_RESTORE(원복) SQL 기록
  python _artifacts/_apply_corporate/E2E_RESIDUE_RESTORE_20261107/restore_residue.py [--dry-run]
"""
import csv, datetime, os, sys
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn')); import dbconn
DRY = '--dry-run' in sys.argv

# (설명, 조회 SQL, 기대 현재값 dict, UPDATE SQL, 바인드)
OPS = [
    ('SCP0084 MEMO AJRJR1212A/GRM00', "SELECT MEMO, UPDATE_USER_ID, UPDATE_DATE, UPDATE_TIME FROM SCM_MGR.SCP_ANL_LONG_TERM_STOCK WHERE YYYYMM='202609' AND PLANT_ID='AZ00' AND DIVISION_ID='40' AND ITEM_ID='AJRJR1212A' AND CHARG='DUMMY' AND DEVALUATION_AGE='GRM00'",
     {'MEMO': 'test2', 'UPDATE_USER_ID': 'minyonglee1'},
     "UPDATE SCM_MGR.SCP_ANL_LONG_TERM_STOCK SET MEMO = NULL WHERE YYYYMM='202609' AND PLANT_ID='AZ00' AND DIVISION_ID='40' AND ITEM_ID='AJRJR1212A' AND CHARG='DUMMY' AND DEVALUATION_AGE='GRM00' AND MEMO='test2'"),
    ('SCP0084 MEMO AJRJR1212A/GRM01', "SELECT MEMO, UPDATE_USER_ID, UPDATE_DATE, UPDATE_TIME FROM SCM_MGR.SCP_ANL_LONG_TERM_STOCK WHERE YYYYMM='202609' AND PLANT_ID='AZ00' AND DIVISION_ID='40' AND ITEM_ID='AJRJR1212A' AND CHARG='DUMMY' AND DEVALUATION_AGE='GRM01'",
     {'MEMO': 'testX', 'UPDATE_USER_ID': 'minyonglee1'},
     "UPDATE SCM_MGR.SCP_ANL_LONG_TERM_STOCK SET MEMO = NULL WHERE YYYYMM='202609' AND PLANT_ID='AZ00' AND DIVISION_ID='40' AND ITEM_ID='AJRJR1212A' AND CHARG='DUMMY' AND DEVALUATION_AGE='GRM01' AND MEMO='testX'"),
    ('SCP0084 MEMO AJRJR1266A/GRM00', "SELECT MEMO, UPDATE_USER_ID, UPDATE_DATE, UPDATE_TIME FROM SCM_MGR.SCP_ANL_LONG_TERM_STOCK WHERE YYYYMM='202609' AND PLANT_ID='AZ00' AND DIVISION_ID='40' AND ITEM_ID='AJRJR1266A' AND CHARG='DUMMY' AND DEVALUATION_AGE='GRM00'",
     {'MEMO': 'test3', 'UPDATE_USER_ID': 'minyonglee1'},
     "UPDATE SCM_MGR.SCP_ANL_LONG_TERM_STOCK SET MEMO = NULL WHERE YYYYMM='202609' AND PLANT_ID='AZ00' AND DIVISION_ID='40' AND ITEM_ID='AJRJR1266A' AND CHARG='DUMMY' AND DEVALUATION_AGE='GRM00' AND MEMO='test3'"),
    ('SCP0127 VALID_YN APCCA3565A/MAX', "SELECT VALID_YN, LAST_UPDATED_BY, TO_CHAR(LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI:SS') LAST_UPDATE_DATE FROM SCM_MGR.SCP_OPMZ_PRECEDE_SAFETY_STOCK_DAY WHERE DIVISION_ID='EE' AND SCM_SITE_ID='AZ00-E' AND OPMZ_PLAN_GR_ID='PG0057' AND STAGE='COATING' AND ITEM_ID='APCCA3565A' AND VALUE_TYPE='MAX' AND FROM_YYYYMMDD='20260511' AND TO_YYYYMMDD='20991231'",
     {'VALID_YN': 'Y', 'LAST_UPDATED_BY': 'minyonglee1'},
     "UPDATE SCM_MGR.SCP_OPMZ_PRECEDE_SAFETY_STOCK_DAY SET VALID_YN = 'N' WHERE DIVISION_ID='EE' AND SCM_SITE_ID='AZ00-E' AND OPMZ_PLAN_GR_ID='PG0057' AND STAGE='COATING' AND ITEM_ID='APCCA3565A' AND VALUE_TYPE='MAX' AND FROM_YYYYMMDD='20260511' AND TO_YYYYMMDD='20991231' AND VALID_YN='Y'"),
]


def main():
    cfg = dbconn.load_cfg(); print('DB:', dbconn.describe('tobe', cfg))
    cx = dbconn.connect('tobe', cfg); cur = cx.cursor()
    now = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    bdir = os.path.join(HERE, '00_BACKUP'); os.makedirs(bdir, exist_ok=True)
    bak = open(os.path.join(bdir, f'residue_before_{now[:10].replace("-", "")}.csv'), 'a', encoding='utf-8', newline=''); w = csv.writer(bak)
    plan = []
    for desc, sel, expect, upd in OPS:
        cur.execute(sel); cols = [d[0] for d in cur.description]; rows = cur.fetchall()
        for r in rows: w.writerow([now, desc] + list(r))
        if len(rows) != 1:
            print(f'[중단] {desc}: 대상 행 {len(rows)}건(1건이어야 함)'); cx.rollback(); return 2
        cur_v = dict(zip(cols, rows[0]))
        bad = {k: (cur_v.get(k), v) for k, v in expect.items() if str(cur_v.get(k)) != v}
        if bad:
            print(f'[중단] {desc}: 현재값이 기대와 다름 {bad} — 재조회 후 판단'); cx.rollback(); return 2
        print(f'{desc}: 현재 {cur_v} → {upd.split(" SET ")[1].split(" WHERE ")[0]}'); plan.append((desc, upd, sel))
    bak.close()
    if DRY:
        print(f'[DRY] {len(plan)}건 적용 생략 · 백업 {bdir}'); cx.rollback(); cx.close(); return 0
    for desc, upd, sel in plan:
        cur.execute(upd); print(f'UPDATE {desc}: {cur.rowcount}행')
        if cur.rowcount != 1: print('[중단] 1행이 아님 → ROLLBACK'); cx.rollback(); return 2
    cx.commit()
    for desc, upd, sel in plan:
        cur.execute(sel); print(f'확인 {desc}:', cur.fetchall())
    open(os.path.join(HERE, 'APPLIED_OPERATIONS.md'), 'a', encoding='utf-8').write(f"\n## {now} 적용(ZIOUI1)\n" + ''.join(f"- {d}\n  `{u}`\n" for d, u, _ in plan))
    cx.close(); return 0


if __name__ == '__main__':
    sys.exit(main())
