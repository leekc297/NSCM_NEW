-- [E20260908-LOCPRECISION] 단가(LOC) 소수 절단 정정 (사용자 신고 2026-09-08).
--   증상: Excel Upload 로 올린 단가 523.621 이 원장에 523.62 로 저장 — 월별 값이 뭉개짐.
--   원인: 중간 GTT `GT_DMF0082_FCST_PRICE_DAILY` 의 금액/수량 컬럼이 NUMBER(23,2).
--         원장 SCM_MST_FUTURE_PRICE.PRICE = NUMBER(30,10)
--         GT_PRDM1_T_MAIN.QTY_PRICE       = NUMBER(30,10)
--         ⇒ 중간 GTT 만 (23,2) 로 좁아 소수 3자리 이하가 반올림된다.
--   요구: 단가는 **소수점 이하 3자리까지 입력 가능**해야 함 (사용자 명시 2026-09-08).
--   조치: 표준 NUMBER(30,10) 로 통일 (메모리 룰 '수량/금액 NUMBER(30,10) 표준').
--         수량 경로(MKT_FCST 등)는 정수라 확장해도 무해 — 축소가 아니므로 기존 데이터 손실 없음.
ALTER TABLE SCM_MGR.GT_DMF0082_FCST_PRICE_DAILY MODIFY (MONTHLY_QTY NUMBER(30,10));
ALTER TABLE SCM_MGR.GT_DMF0082_FCST_PRICE_DAILY MODIFY (WEEKLY_QTY  NUMBER(30,10));
ALTER TABLE SCM_MGR.GT_DMF0082_FCST_PRICE_DAILY MODIFY (DAILY_QTY   NUMBER(30,10));
