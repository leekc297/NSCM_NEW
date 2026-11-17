# -*- coding: utf-8 -*-
# SSP0022 Shipment Request(Electrode) — Material / Requestor / Lot ID / (품목 팝업) : 비교 형태(IN 완전 일치) 유지, 컬럼·입력 양쪽 UPPER (plan.csv no 56~60)
# RX1 Material(P_ITEM_ID) 19곳 : <별칭>.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE) …) → UPPER(<별칭>.ITEM_ID) IN (…)  — 입력 쪽은 이미 UPPER
#   P_SSP0022_GET_ITEM_POPUP 1 (no 60) · GET_REQUEST_DETAIL 1 · GET_REQUEST_DETAIL_EXCEL_DOWN 2(엑셀 내려받기용 — plan 범위 밖, 같은 식이라 포함)
#   · GET_STOCK_DETAIL 1 · PSI_PRE 1 · PSI_ETD 3 · PSI_INTRANSIT 4 · PSI_ROWDATA 4 · PSI_ROWDATA_OLD 2(과거 기준 경로 — 같은 식이라 포함)
# RX2 Lot ID(P_LOT_ID) 1곳 : GET_STOCK_DETAIL A.LOT_ID
# RX3·RX4 Requestor(P_REQUESTOR_ID) 2곳 : GET_REQUEST_DETAIL 의 사용자 원장 SA.USER_NM / SA.USER_ID 대 입력 비교만 양쪽 UPPER.
#   바깥 A.LAST_UPDATED_BY IN (원장에서 꺼낸 USER_ID) 는 ID 대 ID 비교라 유지.
# 유지: Model/Nickname(P_MODEL_ID) EXISTS·LIKE 분기(이미 양쪽 UPPER) · P_NICK_NAME / P_CELL_TYPE / P_PLANT_ID IN 식(담당 행 아님)
#       · P_SSP0022_GET_BOD_ITEM_VALID_CHECK 의 A.ITEM_ID LIKE '%'||P_ITEM_ID||'%' (저장 전 검증 프로시저 — 조회조건 아님)
#       · 저장·업로드 프로시저 · '--' 주석 줄(USERNAME/USERID 옛 식)
# LOWER(2026-11-13 10:30~10:32 실측, 소문자 포함 건수 / 전체):
#   SCM_ADM_USER_M.USER_NM 1571/8612 · SCM_ADM_USER_M.USER_ID 4495/8612 · SCP_MST_BOD_ITEM.ITEM_ID 0/334787
#   SSP_ANL_SHIP_REQ_EE.ITEM_ID 0/10298 · SSP_ANL_BOH_CUTOFF_EE.ITEM_ID 0/536242 · SSP_ANL_SHIP_CONFIRM.ITEM_ID 11/476866
#   SSP_DNM_FP_MRP_INTRANSIT_SN.ITEM_ID -/0(빈 테이블) · SSP_ANL_SHIP_PLAN_EE.ITEM_ID 0/9196016 · SSP_DNM_SHIP_RESULT_OWMS_V.ITEM_ID 0/154296
#   SSP_ANL_STOCK_EE_C.ITEM_ID 0/21819423 · SSP_ANL_STOCK_EE_C.LOT_ID 0/21819423
RX = [
    (r"\bOR (\w+\.ITEM_ID) IN \(SELECT UPPER\(COLUMN_VALUE\)", r"OR UPPER(\1) IN (SELECT UPPER(COLUMN_VALUE)", 19),
    (r"\bOR (A\.LOT_ID) IN \(SELECT UPPER\(COLUMN_VALUE\)", r"OR UPPER(\1) IN (SELECT UPPER(COLUMN_VALUE)", 1),
    (r"\bWHERE (SA\.USER_NM) IN \(SELECT COLUMN_VALUE\b", r"WHERE UPPER(\1) IN (SELECT UPPER(COLUMN_VALUE)", 1),
    (r"\bOR (SA\.USER_ID) IN \(SELECT COLUMN_VALUE\b", r"OR UPPER(\1) IN (SELECT UPPER(COLUMN_VALUE)", 1),
]
K = 'PKG_SSP0022.'
CHK = {'P_NON_CHK': 'Y', 'P_MY_MODEL_CHK': 'N', 'P_DELEGATE_CHK': 'N', 'P_PART_LEADER_CHK': 'N', 'P_TEAM_LEADER_CHK': 'N'}
COM = dict(CHK, P_DIVISION_ID='40', P_PLAN_START_YYYYMMDD='20261010', P_PLANT_ID='ALL', P_CELL_TYPE='ALL', P_MODEL_ID='ALL', P_NICK_NAME='ALL',
           P_USER_ID='minyonglee1', P_PROGRAM_ID='SSP0022', P_SHEET_NAME='Shipment Request(Electrode)', P_REAL_FLAG='Y')
B_REQ = dict(COM, P_COMPANY_ID='HQ00', P_FROM_YYYYMMDD='20260801', P_TO_YYYYMMDD='20261231')      # 출하 요청(도착일 08~12월)
B_STK = dict(COM, P_COMPANY_ID='NJ00', P_FROM_YYYYMMDD='20261010', P_TO_YYYYMMDD='20261107')      # 재고(계획 시작일 20261010)
B_PSI = dict(COM, P_COMPANY_ID='HQ00', P_FROM_YYYYMMDD='20261010', P_TO_YYYYMMDD='20261107')
B_OLD = dict(B_PSI, P_REAL_FLAG='N')                                                              # 과거 기준 경로(PSI_ROWDATA_OLD)
B_POP = {'P_DIVISION_ID': '40', 'P_FROM_SITE_ID': 'HQ06-E', 'P_TO_SITE_ID': 'HQ06-A', 'P_BOD_ID': None, 'P_INCOTERMS': 'ALL',
         'P_TRANSPORT_MODE': 'ALL', 'P_PLAN_START_YYYYMMDD': '20261010'}
ITEM = [('same:empty', None), ('same:ALL', 'ALL'), ('eq:code:upper', 'APCAN0006A'), ('eq:code:lower', 'apcan0006a'),
        ('eq:multi:upper', 'APCAN0006A,APCCA1714A'), ('eq:multi:lower', 'apcan0006a,apcca1714a')]
TESTS = [
    dict(proc=K + 'P_SSP0022_GET_ITEM_POPUP', vary='P_ITEM_ID', key=[], base=B_POP, values=ITEM),
    dict(proc=K + 'P_SSP0022_GET_REQUEST_DETAIL', vary='P_ITEM_ID', key=[], base=B_REQ, values=ITEM),
    dict(proc=K + 'P_SSP0022_GET_REQUEST_DETAIL', vary='P_REQUESTOR_ID', key=[], base=B_REQ, values=[
        ('same:empty', None), ('same:ALL', 'ALL'), ('same:name', '이민용'),
        ('eq:id:lower', 'minyonglee1'), ('eq:id:upper', 'MINYONGLEE1'),          # 원장 USER_ID 는 소문자 — 수정 전 대문자 입력은 0행
        ('eq:multi:lower', 'minyonglee1,이민용'), ('eq:multi:upper', 'MINYONGLEE1,이민용')]),
    dict(proc=K + 'P_SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN', vary='P_ITEM_ID', key=[], base=B_REQ, values=ITEM),
    dict(proc=K + 'P_SSP0022_GET_STOCK_DETAIL', vary='P_ITEM_ID', key=[], base=B_STK, values=[
        ('same:empty', None), ('same:ALL', 'ALL'), ('eq:code:upper', 'APCAN2778A'), ('eq:code:lower', 'apcan2778a'),
        ('eq:multi:upper', 'APCAN2778A,APCCS0948A'), ('eq:multi:lower', 'apcan2778a,apccs0948a')]),
    dict(proc=K + 'P_SSP0022_GET_STOCK_DETAIL', vary='P_LOT_ID', key=[], base=B_STK, values=[
        ('same:empty', None), ('same:ALL', 'ALL'), ('eq:code:upper', 'LAF7D31617'), ('eq:code:lower', 'laf7d31617'),
        ('eq:multi:upper', 'LAF7D31617,LBF9H22114'), ('eq:multi:lower', 'laf7d31617,lbf9h22114')]),
    dict(proc=K + 'P_SSP0022_GET_SHIPMENT_PSI', vary='P_ITEM_ID', key=[], base=B_PSI, values=[
        ('same:empty', None), ('same:ALL', 'ALL'), ('eq:code:upper', 'APCAN1650A'), ('eq:code:lower', 'apcan1650a'),
        ('eq:multi:upper', 'APCAN1650A,APCCA3528B'), ('eq:multi:lower', 'apcan1650a,apcca3528b')]),
    dict(proc=K + 'P_SSP0022_GET_SHIPMENT_PSI', vary='P_ITEM_ID', key=[], base=B_OLD, values=[
        ('same:old:empty', None), ('eq:oldcode:upper', 'APCAN1650A'), ('eq:oldcode:lower', 'apcan1650a'),
        ('eq:oldmulti:upper', 'APCAN1650A,APCCA3528B'), ('eq:oldmulti:lower', 'apcan1650a,apcca3528b')]),
]
