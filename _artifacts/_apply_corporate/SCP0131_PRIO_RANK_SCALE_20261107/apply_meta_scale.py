# -*- coding: utf-8 -*-
"""사내오라클(ZIOUI1) 메타 보완 — SCM_MST_SHEET_COLUMNS SCP0131 / Sales Site Priority / PRIO_RANK DATA_SCALE_NUMBER NULL → '0' (2026-11-07 · CheckList v6 E1 V-637991ac)
결함: Priority 셀에 '1.5' 가 그대로 들어간다(E2E 11-07 04:14). AS-IS cell_rules(SpreadInfo NumberCellType 기본 DecimalPlaces=0)는 정수만 허용.
      TO-BE 공용 columnMapping.ts:89-95 는 메타 DATA_SCALE_NUMBER 가 NULL 이면 "제한 없는 기본 편집기", 0 이면 InputNumber(n0 · 정수만) — AS-IS 메타도 NULL 이지만 AS-IS 프레임워크 기본값이 0 이라 동작이 다르다.
보완(DB 객체 우선 · DB MODE · 공용 컴포넌트 수정 금지): 이 컬럼의 메타 DATA_SCALE_NUMBER 를 '0' 으로 두어 AS-IS 동작(정수만)을 재현한다. 공용 기본값(NULL→0) 변경은 FE 가이드로 별도 기록.
절차(hook #152 §1-6): 대상 행 현재값 재조회·백업 → 기대값(NULL) 확인 → UPDATE → 재조회 → 99_RESTORE SQL
  python _artifacts/_apply_corporate/SCP0131_PRIO_RANK_SCALE_20261107/apply_meta_scale.py [--dry-run]
"""
import csv, datetime, os, sys
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn')); import dbconn
DRY = '--dry-run' in sys.argv
KEY = "PROGRAM_ID='SCP0131' AND SHEET_NAME='Sales Site Priority' AND COLUMN_NAME='PRIO_RANK'"
SEL = f"SELECT PROGRAM_ID, SHEET_NAME, COLUMN_NAME, DIVISION_ID, DATA_SCALE_NUMBER, CELL_CONTROL_OBJECT_TYPE_CODE, LAST_UPDATED_BY, TO_CHAR(LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI:SS') FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE {KEY}"
UPD = f"UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS SET DATA_SCALE_NUMBER = '0', LAST_UPDATED_BY = 'minyonglee1', LAST_UPDATE_DATE = SYSDATE WHERE {KEY} AND DATA_SCALE_NUMBER IS NULL"


def main():
    cfg = dbconn.load_cfg(); print('DB:', dbconn.describe('tobe', cfg))
    cx = dbconn.connect('tobe', cfg); cur = cx.cursor()
    now = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    bdir = os.path.join(HERE, '00_BACKUP'); os.makedirs(bdir, exist_ok=True)
    cur.execute(SEL); cols = [d[0] for d in cur.description]; rows = cur.fetchall()
    with open(os.path.join(bdir, 'sheet_columns_PRIO_RANK.before.csv'), 'a', encoding='utf-8', newline='') as f:
        w = csv.writer(f); w.writerow(['fetched_at'] + cols); [w.writerow([now] + list(r)) for r in rows]
    print(f'대상 행 {len(rows)}:', rows)
    if len(rows) != 1 or rows[0][4] is not None:
        print('[중단] 대상 1행·DATA_SCALE_NUMBER NULL 이어야 함'); cx.rollback(); return 2
    open(os.path.join(HERE, '99_RESTORE_PRIO_RANK_scale.sql'), 'w', encoding='utf-8').write(f"-- 원복(2026-11-07 적용 전 값 NULL) · 실행 전 현재값 확인\nUPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS SET DATA_SCALE_NUMBER = NULL WHERE {KEY} AND DATA_SCALE_NUMBER = '0';\nCOMMIT;\n")
    if DRY:
        print('[DRY] 적용 생략'); cx.rollback(); cx.close(); return 0
    cur.execute(UPD); print('UPDATE', cur.rowcount, '행')
    if cur.rowcount != 1: print('[중단] 1행이 아님 → ROLLBACK'); cx.rollback(); return 2
    cx.commit(); cur.execute(SEL); print('확인:', cur.fetchall())
    open(os.path.join(HERE, 'APPLIED_OPERATIONS.md'), 'a', encoding='utf-8').write(f"\n## {now} 적용(ZIOUI1)\n- SCM_MST_SHEET_COLUMNS {KEY}: DATA_SCALE_NUMBER NULL → '0'\n  `{UPD}`\n- 원복: 99_RESTORE_PRIO_RANK_scale.sql · 백업 00_BACKUP/sheet_columns_PRIO_RANK.before.csv\n")
    cx.close(); return 0


if __name__ == '__main__':
    sys.exit(main())
