# 사내오라클(ZIOUI1) 적용 기록 — SCP0016 컬럼 개인화 초기화 (2026-11-07)

| 항목 | 값 |
|---|---|
| 지시 | 사용자 2026-11-07 "3-2 개인화 삭제" |
| 대상 | `SCM_MST_TITLESET_USER` USER_ID=minyonglee1 · PROGRAM_ID=SCP0016 · SHEET_NAME='Waterfall Shipment Plan' · TYPE 'C' 19행(2026-11-02 17:57:57 생성 · Team(DEPT_NAME_KO) 제외 · To Site 5번째) |
| 절차 | hook #152 §6: 적용 직전 재조회 19행 = 백업 19행 확인 → DELETE → COMMIT |
| 적용 시각 | 2026-11-07 00:11:56 |
| 검증 | 삭제 후 C 행 0 · 같은 계정 SCP0016 잔여 행(측정값 M) 8 — 다음 화면 오픈 시 `PR_GET_SHEET_COLUMN_LIST` 가 DEFAULT_FLAG='Y' 기본 21행(Team 포함)을 재적재 |
| 백업·원복 | `00_BACKUP/SCM_MST_TITLESET_USER_minyonglee1_SCP0016_C.csv` · `00_BACKUP/99_RESTORE_titleset_minyonglee1.sql` |
