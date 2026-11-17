# -*- coding: utf-8 -*-
# SCP0024 Production Plan Fix — Material (plan.csv no 14) : P_SCP0024_GET_PROD_PLAN_FIX 동적 SQL 2곳(날짜 칸 없음 분기 / PIVOT 분기)
#   SCP_ANL_PRODUCTION_PLAN_FIX A.ITEM_ID IN (…) 유지, 컬럼 쪽 UPPER 추가. 입력은 이미 UPPER(V_ITEM_ID := UPPER(RTRIM(P_ITEM_ID)) → :B_ITEM1/:B_ITEM2) → 입력 쪽 변경 없음.
#   동적 SQL 문자열 안의 식이라 표시 주석은 문자열 밖, 해당 줄 바로 위에 따로 넣는다(결과 줄 수 +2). 문자열 뒤 맞춤 공백 7칸을 줄여 '|| CHR(10)' 위치 유지.
# 유지: 같은 꼴의 Site·Line·Electrode Type 조건(콤보 조건, 대상 아님) / P_FIX_HIST*·저장 프로시저(A.ITEM_ID = B.P_ITEM_ID 등 저장 행 키) / 'ALL' 처리 없음(빈값 = 조건 없음) 그대로
# LOWER: SCP_ANL_PRODUCTION_PLAN_FIX.ITEM_ID 소문자 0건 / 전체 667,897건 (2026-11-13 10:40:42)
RX = [(r"^(\s+)(\|\| '\s+OR )A\.ITEM_ID IN \(SELECT SB\.COLUMN_VALUE' {7}",
       r"\1/* 2026.11.13 조회조건 대소문자 무시 : 아래 줄 A.ITEM_ID 를 대문자로 비교 */\n\1\2UPPER(A.ITEM_ID) IN (SELECT SB.COLUMN_VALUE'", 2)]
P = 'PKG_SCP0024.P_SCP0024_GET_PROD_PLAN_FIX'
B = {'P_DIVISION_ID': '82', 'P_OPERATION_GROUP': 'A', 'P_SCM_SITE_ID': None, 'P_LINE_ID': None, 'P_ELECTRODE_TYPE': None,
     'P_FROM_YYYYMMDD': '20261101', 'P_TO_YYYYMMDD': '20261231', 'P_DEBUG_MODE': 'F'}
# 날짜 칸 없음 분기(V_COL_IN IS NULL) = 기간에 달력 일자가 없을 때만 타는 분기라 결과 행이 있을 수 없다(조회 기간 조건이 같이 걸림) → 동적 SQL 실행 오류 여부만 확인(0행)
B0 = dict(B, P_FROM_YYYYMMDD='20261231', P_TO_YYYYMMDD='20261101')
TESTS = [
    dict(proc=P, vary='P_ITEM_ID', key=[], base=B, values=[
        ('same:empty', None),
        ('eq:code:upper', 'EAE1592F1-01-A01'), ('eq:code:lower', 'eae1592f1-01-a01'),
        ('eq:multi:upper', 'EAE1592F1-01-A01, EAP0620N5-01'), ('eq:multi:lower', 'eae1592f1-01-a01, eap0620n5-01'),
    ]),
    dict(proc=P, vary='P_ITEM_ID', key=[], base=B0, values=[
        ('same:empty-nocal', None),
        ('eq:code-nocal:upper', 'EAE1592F1-01-A01'), ('eq:code-nocal:lower', 'eae1592f1-01-a01'),
    ]),
]
