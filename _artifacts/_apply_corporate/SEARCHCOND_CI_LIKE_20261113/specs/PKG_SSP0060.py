# -*- coding: utf-8 -*-
# SSP0060 Shipment Plan(Auto & ESS)-WA_UC — Requestor / Box ID (plan.csv no 69, 70 — no 71 Requestor 팝업은 콤보 SQL 이라 제외) : AS-IS 완전 일치(IN) → LIKE 미적용, 컬럼·입력 양쪽 UPPER.
#   Requestor : P_SSP0060_GET_SHIPMENT_PLAN_DETAIL — 사용자 원장(SCM_ADM_USER_M SA) USER_NM / USER_ID 와 입력 토큰을 견주는 식만 양쪽 UPPER (2묶음×2식 = 4곳).
#   Box ID    : P_SSP0060_GET_MES_STOCK_DETAIL — A.BOXID IN (… STRING_SPLIT(P_BOX_ID …)) 1곳 (조회 버튼 갈래. 더블클릭 갈래 P_DBL_FLAG='Y' 에는 Box 조건 없음).
#   유지: 바깥 XA.REQUESTOR IN (원장 USER_ID) = ID 대 ID 비교라 그대로. "P_DBL_FLAG = 'Y' OR TRIM(P_REQUESTOR) IS NULL"·"TRIM(P_BOX_ID) IS NULL" 판정 그대로.
#         '--' 주석 줄(TB_FX_USER 옛 식) 그대로. D.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK …) = 로그인 사용자 비교(조회조건 입력 아님)라 제외.
#         저장·삭제 프로시저는 대상 아님. Requestor 팝업(콤보 SQL SSP0060_UserInfoList)은 PKG 가 아니라 이 명세 범위 밖.
# LOWER: SSP_DNM_GMES_STOCK_81_82.BOXID 소문자 0건 / 전체 4,611,178건
#        SCM_ADM_USER_M.USER_NM 소문자 포함 1,571건, USER_ID 소문자 포함 4,495건 / 전체 8,612건
#        · USER_ID 값 종류 8,612 = UPPER 후 8,612(대소문자만 다른 ID 0쌍) · USER_NM 값 종류 7,886 → UPPER 후 7,884(대소문자만 다른 이름 2쌍: Paula Zalewska-Sung / Arkadiusz Kowalewski) (2026-11-13 10:30 조회)
RX = [
    (r"(?<![\w.(])(SA\.USER_(?:NM|ID)) IN \(SELECT COLUMN_VALUE(?=\s*$)", r"UPPER(\1) IN (SELECT UPPER(COLUMN_VALUE)", 4),
    (r"(?<![\w.(])A\.BOXID IN \(SELECT COLUMN_VALUE(?=\s*$)", r"UPPER(A.BOXID) IN (SELECT UPPER(COLUMN_VALUE)", 1),
]
PD = 'PKG_SSP0060.P_SSP0060_GET_SHIPMENT_PLAN_DETAIL'
PB = 'PKG_SSP0060.P_SSP0060_GET_MES_STOCK_DETAIL'
BD = {'P_DIVISION_ID': '81_UC', 'P_COMPANY_ID': 'GM00', 'P_FROM_SITE': None, 'P_ITEM_ID': None, 'P_PRODUCT_LEVEL1': None, 'P_TO_SITE': None, 'P_TRANSPORT_MODE': None, 'P_INCOTERMS': None, 'P_FCST_TYPE': None,
      'P_PLAN_START_YYYYMMDD': '20261008',
      'P_FROM_YYYYMMDD': '20261001', 'P_TO_YYYYMMDD': '20261031', 'P_DBL_FLAG': 'N', 'P_LANGUAGE': 'EN', 'P_PROGRAM_ID': 'SSP0060',
      'P_SHEET_NAME': 'PlanDetail', 'DEBUG_MODE': 'N'}
BB = {'P_DIVISION_ID': '81_UC', 'P_COMPANY_ID': 'GM00', 'P_FROM_SITE': None, 'P_ITEM_ID': None, 'P_PRODUCT_LEVEL1': None, 'P_PLAN_START_YYYYMMDD': '20261009',
      'P_DBL_FLAG': 'N', 'P_LANGUAGE': 'EN', 'P_PROGRAM_ID': 'SSP0060', 'P_SHEET_NAME': 'MesStockDetail', 'DEBUG_MODE': 'N'}


def _req(tag, uid, uid2, nm=None):
    v = [('same:%s-empty' % tag, None),
         ('same:%s-none' % tag, 'no_such_user_zz'),
         ('same:%s-id' % tag, uid),
         ('eq:%sid:exact' % tag, uid),
         ('eq:%sid:upper' % tag, uid.upper()),
         ('eq:%smulti:exact' % tag, uid + ',' + uid2),
         ('eq:%smulti:upper' % tag, (uid + ',' + uid2).upper())]
    if nm:
        v += [('eq:%snm:exact' % tag, nm), ('eq:%snm:lower' % tag, nm.lower())]
    return v


TESTS = [
    # 실적 갈래(P_REAL_FLAG='Y') — SSP_ANL_SHIP_CONFIRM
    dict(proc=PD, vary='P_REQUESTOR', key=[], base=dict(BD, P_REAL_FLAG='Y'), values=_req('R', 'sihyeong.ha', 'zajacp', 'Sihyeong Ha')),
    # 계획 갈래(P_REAL_FLAG='N') — SSP_ANL_SHIP_PLAN_ALL
    dict(proc=PD, vary='P_REQUESTOR', key=[], base=dict(BD, P_REAL_FLAG='N'), values=_req('N', 'sihyeong.ha', 'zajacp')),
    dict(proc=PB, vary='P_BOX_ID', key=[], base=BB, values=[
        ('same:empty', None),
        ('same:code', 'PZ5G90013'),
        ('eq:code:upper', 'PZ5G90013'),
        ('eq:code:lower', 'PZ5G90013'.lower()),
        ('eq:multi:upper', 'PZ5G90013,PZ2G60004'),
        ('eq:multi:lower', 'PZ5G90013,PZ2G60004'.lower()),
    ]),
]
