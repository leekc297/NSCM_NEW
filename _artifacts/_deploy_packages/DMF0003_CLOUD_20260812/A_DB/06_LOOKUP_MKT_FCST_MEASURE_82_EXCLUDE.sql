-- ============================================================================
-- DMF0003 — 통합테스트 사전점검 1st No.52 조치 (2026-08-12)
--   "신규 행 Insert 후 Measure 선택 가능한 항목": 82 Div 편집 콤보에서
--   BNPIn(삭제 요청) + 입력 불가 3종(RTF_SYS_RP/VMI_In_Plan/VMI_Inv) 제거.
--   요구 잔여 목록 = MKT_FCST_RP / VMI_In_Req / AS_In_Req (요구서 원문 1:1).
--
-- 기법: 행 삭제 아님 — ATTRIBUTE2='Y' 제외 마킹.
--   근거: CMBO 'MktFcstEditMeasure' SQL 이 NVL(ATTRIBUTE2,'N') <> 'Y' 제외 조건을
--   가짐(81 TMM_FCST 선례와 동일). 소비자 전수 실측(2026-08-12):
--     · CMBO MktFcstEditMeasure — ATTRIBUTE2 소비(제외 반영) ← 의도 효과
--     · PKG_DMF0003 GET(EDIT_FLAG M1 조인) — SEGMENT5/VALID_YN 만 소비 → 불변
--       (기존 BNPIn 행 등의 편집 정책은 건드리지 않음)
--     · UP_FX_GETCOMMONDATALIST_DM — 동명 변수일 뿐(FCST_PRICE_EDIT_MEASURE 분기) → 무관
-- 멱등: 재실행 시 0행 갱신.
-- ============================================================================
UPDATE SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
   SET ATTRIBUTE2       = 'Y',
       LAST_UPDATED_BY  = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE LOOKUP_TYPE = 'MKT_FCST_MEASURE'
   AND SEGMENT1    = '82'
   AND VALID_YN    = 'Y'
   AND SEGMENT2 IN ('BNPIn', 'RTF_SYS_RP', 'VMI_In_Plan', 'VMI_Inv')
   AND NVL(ATTRIBUTE2, 'N') <> 'Y';

COMMIT;

-- 검증 — 기대: AS_In_Req / MKT_FCST_RP / VMI_In_Req 3행
SELECT SEGMENT2 AS EDIT_MEASURE
  FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
 WHERE LOOKUP_TYPE = 'MKT_FCST_MEASURE'
   AND SEGMENT1    = '82'
   AND VALID_YN    = 'Y'
   AND NVL(ATTRIBUTE2, 'N') <> 'Y'
 ORDER BY SEGMENT2;
