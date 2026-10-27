-- 화면 정합검증 CRUD 실제 저장(사용자 지시 2026-10-23 "CRUD 테스트 시 실제 저장") 이 사내 ZIOUI1 에 만든 테스트 행 정리
--   생성: 2026-10-23 22:48:51 · minyonglee1 · BOD_ID 20945 (Div 40 · HQ06-A → CN00254300_40-P · DAP · Route 740)
--   BOD 화면은 저장된 행을 화면에서 삭제할 수 없어(AS-IS DeleteButton = 신규행만) DB 에서 정리한다.
--   대상 = BOD_ID 20945 한 건과 그 저장이 연쇄 생성한 이력·아이템(ITEM 346건 전부 BOD_ID 20945, 생성 22:48:53 — 다른 BOD 의 ITEM 생성 0건 확인)
--   백업 = Doc/verify/SCP0007/cleanup_backup_bod20945_*.csv (삭제 전 SELECT 결과)
--   주의: SCP_MST_BOD_H 의 BOD_ID 20945 는 2건 — HISTORY_SEQ 25823(cialcho 2026-09-18, Div 82)은 과거 동일 BOD_ID 이력이라 보존, 25841 만 삭제
--   적용 결과(2026-10-23): ITEM 346 · H 1 · BOD 1 삭제 COMMIT → 잔존 BOD 0 · ITEM 0 · H 1(25823)
DELETE FROM SCP_MST_BOD_ITEM WHERE BOD_ID = 20945 AND CREATION_DATE >= TO_DATE('2026-10-23 22:48:00', 'YYYY-MM-DD HH24:MI:SS');
DELETE FROM SCP_MST_BOD_H    WHERE BOD_ID = 20945 AND HISTORY_SEQ = 25841 AND CREATED_BY = 'minyonglee1';
DELETE FROM SCP_MST_BOD      WHERE BOD_ID = 20945 AND CREATED_BY = 'minyonglee1' AND CREATION_DATE >= TO_DATE('2026-10-23 22:48:00', 'YYYY-MM-DD HH24:MI:SS');
COMMIT;

-- ── 2차(2026-10-23 23:44 저장분) BOD_ID 20950 · 마커 REMARKS(ATTRIBUTE6)='E2E_10231442' · ITEM 0건 ──
--   백업 = cleanup_backup_bod20950_*.csv · 결과: H 1 · BOD 1 삭제 COMMIT
DELETE FROM SCP_MST_BOD_H WHERE BOD_ID = '20950' AND CREATED_BY = 'minyonglee1' AND ATTRIBUTE6 = 'E2E_10231442';
DELETE FROM SCP_MST_BOD   WHERE BOD_ID = '20950' AND CREATED_BY = 'minyonglee1' AND ATTRIBUTE6 = 'E2E_10231442';
COMMIT;
