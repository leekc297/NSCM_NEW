# -*- coding: utf-8 -*-
# SSP0025 Shipment Requestor PIC — Material (plan.csv no 65) / 품목 선택 팝업 Material·Model (no 66) : AS-IS 완전 일치(IN) → LIKE 미적용, 컬럼·입력 양쪽 UPPER.
#   P_SSP0025_GET_SHIPMENT_REQUESTOR_PIC : A.ITEM_ID IN (… V_ITEM_ID) 1곳
#   P_SSP0025_GET_ITEM_BY_DIVISION_POPUP : A.ITEM_ID IN (… V_ITEM_ID) 1곳 + A.MODEL_ID IN (… V_MODEL_ID) 1곳
#   유지: 같은 프로시저의 TO_SITE·NICK_NAME(IA.MODEL_ID_NICK_NAME)·FROM_SITE·TO_SITE(C.ATTRIBUTE1)·DIVISION 비교 = plan.csv 대상 아님(다른 인자).
#         REQUESTOR_PIC 의 V_MODEL_ID 는 이미 UPPER LIKE. P_SSP0025_GET_USER_ID_CHECK(:299 USER_ID IN …)·P_SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC(:401 ITEM_ID = V_ITEM_ID) = 검증·저장 경로라 제외.
#         'ALL'·빈값 판정 줄은 그대로.
# LOWER: SSP_MST_MODEL_USER_EE.ITEM_ID 소문자 0건 / 전체 130건 · SSP_MST_SITE_ITEM_EE_V.ITEM_ID 0건, MODEL_ID 0건 / 전체 3,475건 (2026-11-13 10:30 조회)
RX = [
    (r"(?<![\w.(])A\.ITEM_ID IN \(SELECT COLUMN_VALUE(?=\s*$)", r"UPPER(A.ITEM_ID) IN (SELECT UPPER(COLUMN_VALUE)", 2),
    (r"(?<![\w.(])A\.MODEL_ID IN \(SELECT COLUMN_VALUE(?=\s*$)", r"UPPER(A.MODEL_ID) IN (SELECT UPPER(COLUMN_VALUE)", 1),
]
P1 = 'PKG_SSP0025.P_SSP0025_GET_SHIPMENT_REQUESTOR_PIC'
P2 = 'PKG_SSP0025.P_SSP0025_GET_ITEM_BY_DIVISION_POPUP'
B1 = {'P_DIVISION_ID': 'ALL', 'P_PLANT_SITE': None, 'P_NICK_NAME': None, 'P_MODEL_ID': None, 'P_LANGUAGE': 'EN'}
TESTS = [
    dict(proc=P1, vary='P_ITEM_ID', key=[], base=B1, values=[
        ('same:empty', None),
        ('same:ALL', 'ALL'),
        ('eq:code:upper', 'APCAN0023A'),
        ('eq:code:lower', 'apcan0023a'),
        ('eq:multi:upper', 'APCAN0023A,APCAN0051A'),
        ('eq:multi:lower', 'apcan0023a,apcan0051a'),
    ]),
    dict(proc=P2, vary='P_ITEM_ID', key=[], base={'P_DIVISION_ID': '40', 'P_FROM_SITE_ID': None, 'P_TO_SITE_ID': None, 'P_MODEL_ID': None}, values=[
        ('same:empty', None),
        ('same:ALL', 'ALL'),
        ('eq:code:upper', 'APCAN0002A'),
        ('eq:code:lower', 'apcan0002a'),
        ('eq:multi:upper', 'APCAN0002A,APCAN0005A'),
        ('eq:multi:lower', 'apcan0002a,apcan0005a'),
    ]),
    dict(proc=P2, vary='P_MODEL_ID', key=[], base={'P_DIVISION_ID': '40', 'P_FROM_SITE_ID': None, 'P_TO_SITE_ID': None, 'P_ITEM_ID': None}, values=[
        ('same:empty', None),
        ('same:ALL', 'ALL'),
        ('eq:code:upper', 'MCCH125030A1'),
        ('eq:code:lower', 'mcch125030a1'),
        ('eq:multi:upper', 'MCCH125030A1,MCCM131012A2'),
        ('eq:multi:lower', 'mcch125030a1,mccm131012a2'),
    ]),
]
