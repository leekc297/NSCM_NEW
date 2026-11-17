# -*- coding: utf-8 -*-
# SSP0015 Shipment Plan(Mobility & IT) — Lot ID (plan.csv no 49) / Requestor (no 50) : AS-IS 완전 일치(IN) → LIKE 미적용, 컬럼·입력 양쪽 UPPER.
#   Lot ID    : P_SSP0015_GET_MES_STOCK 의 X.LOT_ID / A.LOT_ID IN (… FN_STRING_SPLIT(P_LOT_ID …)) 2곳.
#   Requestor : 사용자 원장(SCM_ADM_USER_M) USER_NM / USER_ID 와 입력 토큰을 견주는 식만 양쪽 UPPER.
#               P_SSP0015_GET_SHIPMENT_CONFIRM_DETAIL 3묶음×2식 = 6곳, …_DETAIL_PACKER 4묶음×2식 = 8곳 (합 14곳).
#   유지: 바깥의 A.REQUESTOR / T.LAST_UPDATED_BY / TT0.REQUESTOR / TT0.LAST_UPDATED_BY IN (원장 USER_ID) = ID 대 ID 비교라 그대로.
#         "(P_LOT_ID IS NULL OR P_LOT_ID = '')"·"(P_REQUESTOR IS NULL OR …)" 빈값 판정 그대로. '--' 주석 줄(TB_FX_USER 옛 식) 그대로.
#         P_SSP0015_SAVE_MES_STOCK 의 P_LOT_ID(:3791, :3862) = 저장 경로라 제외.
# LOWER: SSP_ANL_MES_FCS_STOCK_40_C.LOT_ID 소문자 0건 / 전체 128,931건 · SSP_ANL_OWMS_STOCK_C.LOT_ID 0건 / 542,693건
#        SCM_ADM_USER_M.USER_NM 소문자 포함 1,571건, USER_ID 소문자 포함 4,495건 / 전체 8,612건
#        · USER_ID 값 종류 8,612 = UPPER 후 8,612(대소문자만 다른 ID 0쌍) · USER_NM 값 종류 7,886 → UPPER 후 7,884(대소문자만 다른 이름 2쌍: Paula Zalewska-Sung / Arkadiusz Kowalewski) (2026-11-13 10:30 조회)
RX = [
    (r"(?<![\w.(])([XA]\.LOT_ID) IN \(SELECT TOKEN FROM TABLE\(FN_STRING_SPLIT\(P_LOT_ID,",
     r"UPPER(\1) IN (SELECT UPPER(TOKEN) FROM TABLE(FN_STRING_SPLIT(P_LOT_ID,", 2),
    (r"(?<![\w.(])(S[ACEG]\.USER_(?:NM|ID)) IN \(SELECT TOKEN FROM TABLE\(FN_STRING_SPLIT\(P_REQUESTOR,",
     r"UPPER(\1) IN (SELECT UPPER(TOKEN) FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR,", 14),
]
PM = 'PKG_SSP0015.P_SSP0015_GET_MES_STOCK'
PC = 'PKG_SSP0015.P_SSP0015_GET_SHIPMENT_CONFIRM_DETAIL'
PP = 'PKG_SSP0015.P_SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER'
BM = {'P_DIVISION_ID': '40', 'P_FROM_SITE': None, 'P_ITEM_ID': None, 'P_PLAN_START_YYYYMMDD': '20260821', 'P_USER_ID': 'minyonglee1',
      'P_MYMODELCHK': 'N', 'P_PARTLEADERCHK': 'N', 'P_TEAMLEADERCHK': 'N', 'P_DELEGATEECHK': 'N', 'P_NONCHK': 'Y', 'P_LANGUAGE': 'EN'}
BC = {'P_DIVISION_ID': '40', 'P_FROM_SITE': None, 'P_ITEM_ID': None, 'P_FROM_YYYYMMDD': '20261001', 'P_TO_YYYYMMDD': '20261031',
      'P_PLAN_START_YYYYMMDD': '20261008', 'P_LANGUAGE': 'EN', 'P_USER_ID': 'minyonglee1', 'P_MYMODELCHK': 'N', 'P_PARTLEADERCHK': 'N',
      'P_TEAMLEADERCHK': 'N', 'P_SEARCH_YN': 'Y', 'P_NONCHK': 'Y', 'P_DEBUG_MODE': 'T', 'P_DELEGATEECHK': 'N'}
BP = dict(BC, P_FROM_YYYYMMDD='20260701')


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
    dict(proc=PM, vary='P_LOT_ID', key=[], base=BM, values=[
        ('same:empty', None),
        ('eq:code:upper', 'ZDJEH15W'),
        ('eq:code:lower', 'zdjeh15w'),
        ('eq:owms:upper', 'MA8EA11B'),
        ('eq:owms:lower', 'ma8ea11b'),
        ('eq:multi:upper', 'ZDJEH15W,ZDGEH11W,MA8EA11B'),
        ('eq:multi:lower', 'zdjeh15w,zdgeh11w,ma8ea11b'),
    ]),
    # 실적 갈래(P_REAL_FLAG='Y') — SSP_ANL_SHIP_CONFIRM / DM_PLN_SHIPMENT_REQ 2묶음
    dict(proc=PC, vary='P_REQUESTOR', key=[], base=dict(BC, P_REAL_FLAG='Y'), values=_req('R', 'xiaojpnj', 'nmwoo92') + [('eq:Rnm:exact', 'Yueyu Pan'), ('eq:Rnm:lower', 'yueyu pan'), ('eq:Rnm:upper', 'YUEYU PAN')]),
    # 계획 갈래(P_REAL_FLAG='N') — SSP_ANL_SHIP_PLAN_ALL 1묶음
    dict(proc=PC, vary='P_REQUESTOR', key=[], base=dict(BC, P_REAL_FLAG='N'), values=_req('N', 'xiaojpnj', 'nmwoo92')),
    # PACKER 실적 갈래 — SSP_ANL_SHIP_CONFIRM / SSP_ANL_SHIP_REQ_P 2묶음
    dict(proc=PP, vary='P_REQUESTOR', key=[], base=dict(BP, P_REAL_FLAG='Y'), values=_req('R', 'shenhuihui', 'danbii')),
    # PACKER 계획 갈래 — SSP_ANL_SHIP_PLAN_P (SHIP_REQ / SHIP_CONFIRM) 2묶음
    dict(proc=PP, vary='P_REQUESTOR', key=[], base=dict(BP, P_REAL_FLAG='N'), values=_req('N', 'shenhuihui', 'danbii')),
]
