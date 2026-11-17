# -*- coding: utf-8 -*-
# SSP0023 Shipment Plan(Electrode) — Material / Requestor / Lot ID : 비교 형태(IN·=) 유지, 컬럼·입력 양쪽 UPPER (plan.csv no 61~64)
# RX1 Material(P_ITEM_ID) 18곳 : <별칭>.ITEM_ID IN (SELECT UPPER(TRIM(COLUMN_VALUE)) …) → UPPER(<별칭>.ITEM_ID) IN (…) — 입력 쪽은 이미 UPPER(TRIM)
#   GET_SHIPMENT_PLAN 11 · GET_SHIPMENT_PLAN_DETAIL 3(현재 기준 2 + 과거 기준 1) · GET_SHIPMENT_PLAN_DETAIL_EXCEL 1(엑셀용 — plan 범위 밖, 같은 식이라 포함)
#   · GET_SHIPMENT_PLAN_RESULT 1 · GET_SHIPMENT_PLAN_STOCK_DETAIL 2(계획 시작일 있음/없음 두 문장)
# RX2 Lot ID(P_LOT_ID) 2곳 : STOCK_DETAIL A.LOT_ID = UPPER(TRIM(P_LOT_ID)) → UPPER(A.LOT_ID) = … (단건 '=' 유지)
# RX3·RX4 Requestor(P_REQUESTOR) 4곳 : GET_SHIPMENT_PLAN_DETAIL 두 갈래의 사용자 원장 SA.USER_NM / SA.USER_ID 대 입력 비교만 양쪽 UPPER.
#   바깥 XA.REQUESTOR IN (원장에서 꺼낸 USER_ID) 는 ID 대 ID 비교라 유지. 이 조건은 P_DBL_FLAG <> 'Y'(조회) 갈래 안에만 있다.
# 유지: Model/Nickname(P_MODEL_ID · P_NICK_NAME) 분기 — MODEL_ID/ITEM_ID IN (UPPER(TRIM(…)) FROM STRING_SPLIT(P_MODEL_ID|P_NICK_NAME)) · FN_GET_ITEM_LIKE_CONDITION
#       · V_NICK_ITEM (한 줄에 FROM 까지 있는 식이라 RX1 의 (?! FROM) 로 제외) · P_FROM_SITE IN 식(담당 행 아님)
#       · 저장·삭제·업로드 프로시저 · '--' 주석 줄(옛 TB_FX_USER 식, 옛 = 비교)
#   Material 식은 DETAIL 의 조회·더블클릭(P_DBL_FLAG='Y') 공용 문장 안에 있어 따로 떼지 않고 함께 바뀐다(같은 P_ITEM_ID 조회조건 인자).
# LOWER(2026-11-13 10:30~10:32 실측, 소문자 포함 건수 / 전체):
#   SCM_ADM_USER_M.USER_NM 1571/8612 · SCM_ADM_USER_M.USER_ID 4495/8612 · SSP_ANL_BOH_CUTOFF_EE.ITEM_ID 0/536242
#   SSP_ANL_SHIP_PLAN_EE.ITEM_ID 0/9196016 · SSP_ANL_SHIP_CONFIRM.ITEM_ID 11/476866 · SSP_ANL_SHIP_REQ_EE.ITEM_ID 0/10298
#   SSP_ANL_SHIP_PLAN_ALL.ITEM_ID 1/7765437 · SSP_ANL_STOCK_EE_C.ITEM_ID 0/21819423 · SSP_ANL_STOCK_EE_C.LOT_ID 0/21819423
#   RESULT 인라인 뷰 원천: SCM_DNM_EXFACTORY_RESULT.ITEM_ID 0/912895 · SSP_DNM_SHIP_RESULT_OWMS.ITEM_ID 0/16617746 · SSP_DNM_SHIP_RETURN_OWMS.ITEM_ID 0/22336
#   GT_0023_PLAN_ITEM.ITEM_ID(프로시저 안에서 채우는 임시 테이블) — 미측정(세션 밖에서는 빈 테이블)
RX = [
    (r"\bOR (\w+\.ITEM_ID) IN \(SELECT UPPER\(TRIM\(COLUMN_VALUE\)\)(?! FROM)", r"OR UPPER(\1) IN (SELECT UPPER(TRIM(COLUMN_VALUE))", 18),
    (r"\bOR (A\.LOT_ID) = UPPER\(TRIM\(P_LOT_ID\)\)", r"OR UPPER(\1) = UPPER(TRIM(P_LOT_ID))", 2),
    (r"\bWHERE (SA\.USER_NM) IN \(SELECT COLUMN_VALUE\b", r"WHERE UPPER(\1) IN (SELECT UPPER(COLUMN_VALUE)", 2),
    (r"\bWHERE (SA\.USER_ID) IN \(SELECT COLUMN_VALUE\b", r"WHERE UPPER(\1) IN (SELECT UPPER(COLUMN_VALUE)", 2),
]
K = 'PKG_SSP0023.'
CHK = {'P_NON_CHK': 'Y', 'P_MY_MODEL_CHK': 'N', 'P_DELEGATEE_CHK': 'N', 'P_PART_LEADER_CHK': 'N', 'P_TEAM_LEADER_CHK': 'N'}
COM = dict(CHK, P_FROM_SITE='ALL', P_MODEL_ID='ALL', P_NICK_NAME='ALL', P_USER_ID='minyonglee1', P_PROGRAM_ID='SSP0023',
           P_SHEET_NAME='Shipment Plan(Electrode)', P_REAL_FLAG='Y', P_LANGUAGE='EN', P_DBL_FLAG='N')
B_PLAN = dict(COM, P_DIVISION_ID='40', P_COMPANY_ID='NJ00', P_PLAN_START_YYYYMMDD='20261010', P_FROM_YYYYMMDD='20261010', P_TO_YYYYMMDD='20261107')
B_DTL = dict(COM, P_DIVISION_ID='40', P_COMPANY_ID='HQ00', P_PLAN_START_YYYYMMDD='20261010', P_FROM_YYYYMMDD='20260901', P_TO_YYYYMMDD='20261231')
B_DTL_OLD = dict(COM, P_REAL_FLAG='N', P_DIVISION_ID='40', P_COMPANY_ID='HQ00', P_PLAN_START_YYYYMMDD='20261009', P_FROM_YYYYMMDD='20261009', P_TO_YYYYMMDD='20261129')
B_RES = {'P_DIVISION_ID': '40', 'P_FROM_SITE': 'ALL', 'P_FROM_YYYYMMDD': '20260901', 'P_TO_YYYYMMDD': '20261231', 'P_TYPE': None, 'P_USER_ID': 'minyonglee1',
         'P_COMPANY_ID': 'HQ00', 'P_MYMODELCHK': 'N', 'P_PARTLEADERCHK': 'N', 'P_TEAMLEADERCHK': 'N', 'P_DELEGATEECHK': 'N', 'P_NONCHK': 'Y',
         'P_REAL_FLAG': 'Y', 'P_PLAN_START_YYYYMMDD': '20261010'}
B_STK = dict(COM, P_DIVISION_ID='40', P_COMPANY_ID='NJ00', P_PLAN_START_YYYYMMDD='20261010')
B_STK2 = dict(B_STK, P_PLAN_START_YYYYMMDD=None)                    # 계획 시작일 없는 갈래(2번째 문장) — 전체 일자를 읽으므로 품목·Lot 로 좁힌다
IT40 = [('same:empty', None), ('same:ALL', 'ALL'), ('eq:code:upper', 'APCCA1450A'), ('eq:code:lower', 'apcca1450a'),
        ('eq:multi:upper', 'APCCA1450A, APCAN1991A'), ('eq:multi:lower', 'apcca1450a,apcan1991a')]
TESTS = [
    dict(proc=K + 'P_SSP0023_GET_SHIPMENT_PLAN', vary='P_ITEM_ID', key=[], base=B_PLAN, values=IT40),
    dict(proc=K + 'P_SSP0023_GET_SHIPMENT_PLAN_DETAIL', vary='P_ITEM_ID', key=[], base=B_DTL, values=[
        ('same:empty', None), ('same:ALL', 'ALL'), ('eq:code:upper', 'APCCA3122A'), ('eq:code:lower', 'apcca3122a'),
        ('eq:multi:upper', 'APCCA3122A,APCAN1650A'), ('eq:multi:lower', 'apcca3122a,apcan1650a')]),
    dict(proc=K + 'P_SSP0023_GET_SHIPMENT_PLAN_DETAIL', vary='P_REQUESTOR', key=[], base=B_DTL, values=[
        ('same:empty', None),
        ('eq:id:lower', 'eunjung_heo'), ('eq:id:upper', 'EUNJUNG_HEO'),                       # 원장 USER_ID 소문자 — 수정 전 대문자 입력은 확정분(CONFIRM)이 빠져 111행(요청분만), 소문자 244행
        ('same:name', '허은정'),
        ('eq:multi:lower', 'eunjung_heo,youju3'), ('eq:multi:upper', 'EUNJUNG_HEO,YOUJU3')]),
    dict(proc=K + 'P_SSP0023_GET_SHIPMENT_PLAN_DETAIL', vary='P_ITEM_ID', key=[], base=B_DTL_OLD, values=[
        ('same:old:empty', None), ('eq:oldcode:upper', 'APCCA3122A'), ('eq:oldcode:lower', 'apcca3122a'),
        ('eq:oldmulti:upper', 'APCCA3122A,APCAN1650A'), ('eq:oldmulti:lower', 'apcca3122a,apcan1650a')]),
    dict(proc=K + 'P_SSP0023_GET_SHIPMENT_PLAN_DETAIL', vary='P_REQUESTOR', key=[], base=B_DTL_OLD, values=[
        # 과거 기준 원천 SSP_ANL_SHIP_PLAN_ALL.REQUESTOR 는 '허은정(eunjung_heo)' 표시 문자열이라 ID 대 ID 바깥 비교에서 0행(수정 전후 같음 — 실행 오류 여부만 확인)
        ('same:old:empty', None), ('eq:oldid:lower', 'eunjung_heo'), ('eq:oldid:upper', 'EUNJUNG_HEO')]),
    dict(proc=K + 'P_SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL', vary='P_ITEM_ID', key=[], base=B_PLAN, values=IT40),
    dict(proc=K + 'P_SSP0023_GET_SHIPMENT_PLAN_RESULT', vary='P_ITEM_ID', key=[], base=B_RES, values=[
        ('same:empty', None), ('same:ALL', 'ALL'), ('eq:code:upper', 'APCCA3122A'), ('eq:code:lower', 'apcca3122a'),
        ('eq:multi:upper', 'APCCA3122A,APCAN1650A'), ('eq:multi:lower', 'apcca3122a,apcan1650a')]),
    dict(proc=K + 'P_SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL', vary='P_ITEM_ID', key=[], base=B_STK, values=[
        ('same:empty', None), ('same:ALL', 'ALL'), ('eq:code:upper', 'APCAN2778A'), ('eq:code:lower', 'apcan2778a'),
        ('eq:multi:upper', 'APCAN2778A,APCCS0948A'), ('eq:multi:lower', 'apcan2778a,apccs0948a')]),
    dict(proc=K + 'P_SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL', vary='P_LOT_ID', key=[], base=B_STK, values=[
        ('same:empty', None), ('same:ALL', 'ALL'), ('eq:code:upper', 'LAF7D31617'), ('eq:code:lower', 'laf7d31617')]),
    dict(proc=K + 'P_SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL', vary='P_ITEM_ID', key=[], base=dict(B_STK2, P_LOT_ID='LAF7D31617'), values=[
        ('eq:nodate:upper', 'APCAN2778A'), ('eq:nodate:lower', 'apcan2778a')]),
    dict(proc=K + 'P_SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL', vary='P_LOT_ID', key=[], base=dict(B_STK2, P_ITEM_ID='APCAN2778A'), values=[
        ('eq:nodatelot:upper', 'LAF7D31617'), ('eq:nodatelot:lower', 'laf7d31617')]),
]
