# PKG_SCP0096 이식 메모

프로시저 3개. 각 프로시저 끝의 /* ASIS … */ 원문을 Oracle 로 옮기고 블록을 지운다. O_RC 수는 As-is 최상위 SELECT 수에서 추정 — FE 플랜(e2e_plan.json procs)과 맞춘다.

- P_DM0003_GET_BUCKET_TYPE_CODE: 첫 결과셋 컬럼(As-is 실측 2): CODE(nvarchar(100)), NAME(nvarchar(100))
- P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP: 임시테이블 #TBLDYNAMICPIVOT_SCP0096 → GTT(03_GTT) 또는 WITH 절/컬렉션으로 / 동적 SQL(sp_executesql) → EXECUTE IMMEDIATE 또는 정적 분기
- P_SCP0009_GET_SHEET_CALENDAR_3SPAN: 첫 결과셋 컬럼(As-is 실측 6): COLUMN_NAME(nvarchar(10)), COLUMN_LABEL_NAME(nvarchar(30)), SMALL_CLASS_LABEL_NAME(nvarchar(30)), LARGE_CLASS_LABEL_NAME(nvarchar(30)), DAY_CODE(nvarchar(3)), SORT_ORDER_NO(nvarchar(10))
