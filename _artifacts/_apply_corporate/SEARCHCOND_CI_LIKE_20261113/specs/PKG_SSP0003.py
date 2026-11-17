# -*- coding: utf-8 -*-
# SSP0003 Shipment Change Request Confirm — Requestor (plan.csv no 48) : AS-IS 완전 일치(IN) → LIKE 미적용, 컬럼·입력 양쪽 UPPER(1곳).
#   대상 = P_SSP0003_GET_CHG_REQ_CONFIRM 의 A.REQUEST_USER IN (… STRING_SPLIT(P_REQUEST_ID …)) 1곳 (입력값과 직접 비교하는 식).
#   포함·제외: 패키지 안에 P_REQUEST_ID 를 쓰는 곳은 이 1줄뿐(인자 선언 :178 제외). 같은 줄의 "P_REQUEST_ID = 'ALL'" 판정은 그대로 둠(지침 5 — ALL 처리 유지).
#   B.USER_ID(+) = A.REQUEST_USER (:321, :539, :4068) 은 ID 대 ID 조인이라 유지.
# LOWER: SSP_ANL_SHIP_CONFIRM_CHG_REQ.REQUEST_USER 소문자 포함 393,222건 / 전체 393,222건 · 값 종류 978 = UPPER 후 978(대소문자만 다른 값 0쌍) (2026-11-13 10:30 조회)
RX = [(r"(?<![\w.(])A\.REQUEST_USER IN \(SELECT COLUMN_VALUE FROM TABLE\(STRING_SPLIT\(P_REQUEST_ID,",
       r"UPPER(A.REQUEST_USER) IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_REQUEST_ID,", 1)]
P = 'PKG_SSP0003.P_SSP0003_GET_CHG_REQ_CONFIRM'
B = {'P_DIVISION_ID': 'ALL', 'P_FROM_SITE': 'ALL', 'P_FROM_YYYYMMDD': '20261001', 'P_TO_YYYYMMDD': '20261031',
     'P_STATUS': 'ALL', 'P_LANGUAGE': 'EN', 'P_ITEM_ID': None, 'P_CHANGE_TYPE': 'ALL'}
TESTS = [dict(proc=P, vary='P_REQUEST_ID', key=[], base=B, values=[
    ('same:empty', None),
    ('same:ALL', 'ALL'),
    ('same:exact', 'gsong'),
    ('eq:code:exact', 'gsong'),
    ('eq:code:upper', 'GSONG'),
    ('eq:code:mixed', 'GSong'),
    ('same:multi-exact', 'gsong,kwilczewska'),
    ('eq:multi:exact', 'gsong,kwilczewska'),
    ('eq:multi:upper', 'GSONG,KWILCZEWSKA'),
])]
