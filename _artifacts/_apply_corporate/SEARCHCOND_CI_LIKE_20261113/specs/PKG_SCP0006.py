# -*- coding: utf-8 -*-
# SCP0006 Project Route — PJT (plan.csv no 6) : P_SCP0006_GET_PROJECT_ROUTE_SITE 의 PROJECT_CODE 비교 3곳(DM_PLN_MKT_FCST A 2곳, DM_PLN_MKT_FCST_RESULT C 1곳)
#   IN 유지, 컬럼 쪽 UPPER 추가. 입력은 이미 UPPER(P_SPLIT_LIST 호출 인자 UPPER(P_PROJECT_CODE)) → 입력 쪽 변경 없음
# 유지: P_SCP0006_GET_PROJECT_ROUTE_SITE_82(Division 82/40 분기 — P_PROJECT_CODE 는 인자 선언뿐, 비교식 없음 = plan '변경 없음') /
#       P_GET_GROUP_MODEL·_BOM·_PLANT 의 PROJECT_CODE = P_PROJECT_CODE(행 더블클릭 키 = 드릴다운) / 저장 프로시저 / '--' 주석 줄
# LOWER: DM_PLN_MKT_FCST.PROJECT_CODE 소문자 675,827건 / 전체 2,320,791건 (2026-11-13 10:30:19) — 소문자는 전부 Division 40(492종), Division 81 은 0건(아래 Division 별 실측)
# LOWER: DM_PLN_MKT_FCST_RESULT.PROJECT_CODE 소문자 1,497,657건 / 전체 4,303,133건 (2026-11-13 10:30:19)
#   ※ Division 40·82 는 _82 분기(PJT 비교 없음)로 가므로 이 3곳은 Division 81 등 그 밖의 사업부 조회에서만 실행된다.
# 대상 줄에 따옴표('Y')가 있어 표시 주석이 자동으로 붙지 않으므로 치환식에 줄 끝 표시를 포함(3줄 모두 이 식으로 줄이 끝난다)
RX = [(r"(?<![\w.(])([AC]\.PROJECT_CODE) IN \(SELECT COLUMN_VALUE FROM TABLE\(V_PROJECT_TAB\)\)\)$",
       r"UPPER(\1) IN (SELECT COLUMN_VALUE FROM TABLE(V_PROJECT_TAB)))   /* 2026.11.13 조회조건 대소문자 무시 */", 3)]
P = 'PKG_SCP0006.P_SCP0006_GET_PROJECT_ROUTE_SITE'
B = {'P_DIVISION_ID': '81', 'P_SCM_SITE_ID': 'ALL', 'P_ITEM_ID': 'ALL', 'P_FROM_YYYYMM': '202611', 'P_TO_YYYYMM': '202703', 'P_STATUS': 'ALL', 'P_DEBUG_MODE': 'F'}
TESTS = [dict(proc=P, vary='P_PROJECT_CODE', key=[], base=B, values=[
    ('same:empty', None),
    ('same:ALL', 'ALL'),
    ('eq:code:upper', 'A15FD5002'),
    ('eq:code:lower', 'a15fd5002'),
    ('eq:multi:upper', 'A15FD5002, A15AI7001'),
    ('eq:multi:lower', 'a15fd5002, a15ai7001'),
])]
