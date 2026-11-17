# -*- coding: utf-8 -*-
# SCP0006 저장 팝업(ProjectRouteListSaveModal) — Model / Item Code (plan.csv no 7,8) : P_SCM0002_GET_PROJECT_ROUTE_LIST_FORSAVE_POPUP 4곳
#   Division 81 분기 + 그 외(ELSE) 분기 각각 XB.MODEL_ID · XB.ITEM_ID. LIKE '%값%' 유지, 컬럼 쪽 UPPER 추가.
#   입력은 이미 UPPER(V_MODEL_ID := UPPER(P_MODEL_ID), V_ITEM_ID := UPPER(P_ITEM_ID)) → 입력 쪽 변경 없음. 단일 값(쉼표 분해 없음)·'ALL' 처리 없음 = 그대로.
# 유지: PKG_SCM0002 의 다른 팝업 프로시저(P_ITEM_ID 를 쓰는 CAPACITY_ALLOCATION·ITEM_BY_* 등)는 이 화면 조건이 아니라 담당 범위(no 7,8) 밖 — 손대지 않음 /
#       P_SCM0002_GET_BODITEM_FOR_SUPPLY_POPUP(= V_ITEM_ID 완전 일치, 다른 화면) / 저장 프로시저
# LOWER: SCM_MST_BOM_SN_V.MODEL_ID 소문자 0건 · CHILD_ITEM_ID(=XB.ITEM_ID) 소문자 0건 / 전체 5,630,884건 (2026-11-13 10:31:58)
# LOWER: SCM_MST_ITEM_SN.ITEM_ID(전극일 때 XB.MODEL_ID) 소문자 0건 / 전체 796,166건 (2026-11-13 10:32:00)
# 대상 줄에 따옴표가 있어 표시 주석이 자동으로 붙지 않으므로 치환식에 줄 끝 표시를 포함(4줄 모두 이 식으로 줄이 끝난다)
RX = [
    (r"(?<![\w.(])(XB\.MODEL_ID) LIKE '%' \|\| V_MODEL_ID \|\| '%'\)$",
     r"UPPER(\1) LIKE '%' || V_MODEL_ID || '%')   /* 2026.11.13 조회조건 대소문자 무시 */", 2),
    (r"(?<![\w.(])(XB\.ITEM_ID)  LIKE '%' \|\| V_ITEM_ID  \|\| '%'\)$",
     r"UPPER(\1) LIKE '%' || V_ITEM_ID  || '%')   /* 2026.11.13 조회조건 대소문자 무시 */", 2),
]
P = 'PKG_SCM0002.P_SCM0002_GET_PROJECT_ROUTE_LIST_FORSAVE_POPUP'
B81 = {'P_DIVISION_ID': '81', 'P_TIMEZONE': 'AS054'}
B40 = {'P_DIVISION_ID': '40', 'P_TIMEZONE': 'AS054'}   # ELSE 분기
# 같은 프로시저·같은 인자를 Division 별로 두 번 시험하므로 라벨에 Division 을 붙여 구분한다(결과 키 = 프로시저·인자·라벨)
TESTS = [
    dict(proc=P, vary='P_MODEL_ID', key=[], base=B81, values=[
        ('same:empty81', None),
        ('eq:code81:upper', 'ECP0640N5-02'), ('eq:code81:lower', 'ecp0640n5-02'),
        ('eq:part81:upper', 'P0640N'), ('eq:part81:lower', 'p0640n'),
    ]),
    dict(proc=P, vary='P_ITEM_ID', key=[], base=B81, values=[
        ('same:empty81', None),
        ('eq:code81:upper', 'EAP0640N5-02'), ('eq:code81:lower', 'eap0640n5-02'),
        ('eq:part81:upper', 'P0640N'), ('eq:part81:lower', 'p0640n'),
    ]),
    dict(proc=P, vary='P_MODEL_ID', key=[], base=B40, values=[
        ('same:empty40', None),
        ('eq:code40:upper', 'MCP376880A10'), ('eq:code40:lower', 'mcp376880a10'),
        ('eq:part40:upper', 'P376880'), ('eq:part40:lower', 'p376880'),
    ]),
    dict(proc=P, vary='P_ITEM_ID', key=[], base=B40, values=[
        ('same:empty40', None),
        ('eq:code40:upper', 'MAP376880A10'), ('eq:code40:lower', 'map376880a10'),
        ('eq:part40:upper', 'P376880'), ('eq:part40:lower', 'p376880'),
    ]),
]
