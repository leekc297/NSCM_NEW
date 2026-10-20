# PKG_SCP0100 이식 메모

프로시저 3개. 각 프로시저 끝의 /* ASIS … */ 원문을 Oracle 로 옮기고 블록을 지운다. O_RC 수는 As-is 최상위 SELECT 수에서 추정 — FE 플랜(e2e_plan.json procs)과 맞춘다.

- P_SCP0100_GET_SHEET_CALENDAR_3SPAN: 첫 결과셋 컬럼(As-is 실측 6): COLUMN_NAME(nvarchar(9)), COLUMN_LABEL_NAME(nvarchar(30)), SMALL_CLASS_LABEL_NAME(nvarchar(30)), LARGE_CLASS_LABEL_NAME(nvarchar(30)), DAY_CODE(nvarchar(8)), SORT_ORDER_NO(nvarchar(10))
- P_SCP0100_GET_SITE: 첫 결과셋 컬럼(As-is 실측 2): CODE(nvarchar(30)), NAME(nvarchar(30))
- P_SCP0100_GET_PLAN_DATE: 임시테이블 #TMP_PLAN → GTT(03_GTT) 또는 WITH 절/컬렉션으로
