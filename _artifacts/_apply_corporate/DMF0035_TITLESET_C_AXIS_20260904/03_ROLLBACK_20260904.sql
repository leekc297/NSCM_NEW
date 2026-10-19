-- DMF0035 'C' 축 정정 원복 — [E20260904-TSCAXIS] 2026-09-04
--
-- ① PKG 원복 : 00_BACKUP_PKG_DMF0035_BODY_20260904.sql 을 그대로 실행 (사내 라이브 원문 스냅샷)
-- ② 데이터 원복 : 아래 DELETE — 02 이행으로 **새로 생긴 복사분만** 지운다.
--    판정 기준 = 원본 축('mktFcstWaterfall')에 같은 (USER_ID, COLUMN_NAME) 이 있는 행.
--    ⚠ 원본 축은 02 에서 손대지 않았으므로 이 DELETE 후 상태 = 이행 전과 동일.
--    ⚠ 이행 이후 사용자가 새 축에 **직접 저장**한 행도 같은 조건에 걸릴 수 있다 —
--       그 경우 원복은 "이행 전 상태로 되돌린다" 는 의도대로 동작한다(사용자 재설정 필요).

DELETE FROM SCM_MGR.SCM_MST_TITLESET_USER T
 WHERE T.PROGRAM_ID = 'DMF0035'
   AND T.SHEET_NAME = 'Mkt Fcst Waterfall'
   AND T.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
   AND EXISTS ( SELECT 1
                  FROM SCM_MGR.SCM_MST_TITLESET_USER S
                 WHERE S.USER_ID    = T.USER_ID
                   AND S.PROGRAM_ID = 'DMF0035'
                   AND S.SHEET_NAME = 'mktFcstWaterfall'
                   AND S.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
                   AND S.COLUMN_NAME = T.COLUMN_NAME );

COMMIT;
