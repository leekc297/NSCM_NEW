# -*- coding: utf-8 -*-
# SCP0022 Formation — Material (plan.csv no 13, 시트 3개) : INSTR(쉼표로 감싼 목록 포함 = 값 단위 완전 일치) 형태 유지, 컬럼 쪽 UPPER 추가 (6곳)
#   P_SCP0022_GET_FORMATION           4곳 : SCM_MST_ITEM_SN D.ITEM_ID / D.ITEM_NAME / D.NICK_NAME, SCP_MST_FORMATION I.ITEM_ID
#   P_SCP0022_GET_FORMATION_EXCEPT    1곳 : SCP_MST_FORMATION A.ITEM_ID
#   P_SCP0022_GET_FORMATION_EXCEPT_LT 1곳 : SCP_MST_FORMATION A.ITEM_ID
#   입력 목록은 이미 UPPER(F_LIST_PARAM = ','||UPPER(…)||',') → 입력 쪽 변경 없음. 'ALL'·빈값 판정(V_ITEM_ALL) 그대로.
# 유지: 같은 꼴의 Division·Plant 조건(V_DIV_LIST·V_PLANT_LIST — 콤보 조건, 대상 아님) /
#       저장 동기화 프로시저(P_SYNC_*·P_DEL_* 의 D.ITEM_ID = UPPER(RTRIM(P_ITEM_ID)) 등 저장 행 키) / 저장 프로시저
# LOWER: SCM_MST_ITEM_SN.ITEM_ID 소문자 0건 · ITEM_NAME 소문자 502,278건 · NICK_NAME 소문자 0건 / 전체 796,166건 (2026-11-13 10:40:40)
#   ※ ITEM_NAME 은 소문자 포함 값이 많다 → 수정 후에는 품목명을 대소문자 구분 없이 넣어도 일치(수정 전에는 대문자만으로 된 품목명만 일치 가능).
# LOWER: SCP_MST_FORMATION.ITEM_ID 소문자 0건 / 전체 7,685건 (2026-11-13 10:40:41)
# 대상 줄에 따옴표가 있어 표시 주석이 자동으로 붙지 않으므로 치환식에 줄 끝 표시를 포함(6줄 모두 '> 0' 또는 '> 0)' 로 줄이 끝난다)
RX = [(r"INSTR\(V_ITEM_LIST, ',' \|\| ([DIA]\.(?:ITEM_ID|ITEM_NAME|NICK_NAME)) \|\| ','\) > 0(\)?)$",
       r"INSTR(V_ITEM_LIST, ',' || UPPER(\1) || ',') > 0\2   /* 2026.11.13 조회조건 대소문자 무시 */", 6)]
B = {'P_DIVISION_ID': 'ALL', 'P_PLANT_SITE_ID': 'ALL', 'P_USER_ID': 'minyonglee1', 'P_MENU_ID': 'SCP0022'}
TESTS = [
    dict(proc='PKG_SCP0022.P_SCP0022_GET_FORMATION', vary='P_ITEM_ID', key=[], base=B, values=[
        ('same:empty', None), ('same:ALL', 'ALL'),
        ('eq:code:upper', 'AAPN1030U-B1'), ('eq:code:lower', 'aapn1030u-b1'),
        ('eq:multi:upper', 'AAPN1030U-B1, AALN1007I-A1'), ('eq:multi:lower', 'aapn1030u-b1, aaln1007i-a1'),
        # 아래 4개는 '입력대상' 갈래(SCM_MST_ITEM_SN D — 전체 조회 3,833행 중 FORMATION_ORDER '1' 16행)의 품목으로 시험: 코드·닉네임·품목명 각각
        ('eq:dcode:upper', 'AAEN1042I-B1'), ('eq:dcode:lower', 'aaen1042i-b1'),
        ('eq:nick:upper', 'E42B'), ('eq:nick:lower', 'e42b'),
        ('eq:name:upper', 'ACEN1042I-B1 P'), ('eq:name:lower', 'acen1042i-b1 p'),
    ]),
    dict(proc='PKG_SCP0022.P_SCP0022_GET_FORMATION_EXCEPT', vary='P_ITEM_ID', key=[], base=B, values=[
        ('same:empty', None), ('same:ALL', 'ALL'),
        ('eq:code:upper', 'EAE0345F1-01'), ('eq:code:lower', 'eae0345f1-01'),
        ('eq:multi:upper', 'EAE0345F1-01, EAP0620N5-01'), ('eq:multi:lower', 'eae0345f1-01, eap0620n5-01'),
    ]),
    dict(proc='PKG_SCP0022.P_SCP0022_GET_FORMATION_EXCEPT_LT', vary='P_ITEM_ID', key=[], base=B, values=[
        ('same:empty', None), ('same:ALL', 'ALL'),
        ('eq:code:upper', 'MACH114030D3'), ('eq:code:lower', 'mach114030d3'),
        ('eq:multi:upper', 'MACH114030D3, MACH114030L1'), ('eq:multi:lower', 'mach114030d3, mach114030l1'),
    ]),
]
