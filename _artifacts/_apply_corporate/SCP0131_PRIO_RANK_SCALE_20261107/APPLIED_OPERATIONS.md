
## 2026-11-07 07:40:05 적용(ZIOUI1)
- SCM_MST_SHEET_COLUMNS PROGRAM_ID='SCP0131' AND SHEET_NAME='Sales Site Priority' AND COLUMN_NAME='PRIO_RANK': DATA_SCALE_NUMBER NULL → '0'
  `UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS SET DATA_SCALE_NUMBER = '0', LAST_UPDATED_BY = 'minyonglee1', LAST_UPDATE_DATE = SYSDATE WHERE PROGRAM_ID='SCP0131' AND SHEET_NAME='Sales Site Priority' AND COLUMN_NAME='PRIO_RANK' AND DATA_SCALE_NUMBER IS NULL`
- 원복: 99_RESTORE_PRIO_RANK_scale.sql · 백업 00_BACKUP/sheet_columns_PRIO_RANK.before.csv

## 2026-11-07 14:18:13 원복(ZIOUI1) — DATA_SCALE_NUMBER '0' → NULL
- 사유: chain6b v7 D1 V-90126e36 신규행 PRIO_RANK 편집기 'Number expected' 오류(화면 editLock.ts:43 기본값 '' ↔ InputNumber) · 컬럼 프로브 중단
- 전: ('SCP0131', 'Sales Site Priority', 'PRIO_RANK', 0, 'minyonglee1', '2026-11-07 07:40:05') · 후: ('SCP0131', 'Sales Site Priority', 'PRIO_RANK', None, 'minyonglee1', '2026-11-07 14:18:13')
- 후속: FE 가이드 Doc/gen/SCP0131/H13_E1_FE_GUIDE.md §2 갱신(신규행 기본값 null + 메타 0 동시 적용) · 클라우드 패키지 30_META 에서 PRIO_RANK scale 제거
