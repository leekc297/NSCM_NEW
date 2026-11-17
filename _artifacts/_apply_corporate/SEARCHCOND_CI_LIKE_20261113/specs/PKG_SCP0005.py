# -*- coding: utf-8 -*-
# SCP0005 Distribution Route — From/To Country·City (plan.csv no 2,3,4,5) : P_SCP0005_GET_DISTRIBUTION_ROUTE 1개 프로시저, 4곳
#   no 2 From Country / no 4 To Country : IN 유지, 컬럼 쪽 UPPER 추가(입력 토큰은 이미 UPPER)
#   no 3 From City / no 5 To City       : 값% → %값% (사용자 확정), 컬럼 쪽 UPPER 추가(입력 토큰은 이미 UPPER). 빈 토큰 제외(TOKEN IS NOT NULL) 유지
# 유지: 'ALL' 판정(P_xxx = 'ALL')·빈값 판정 그대로 / :251-260 주석 줄 / P_SCP0005_GET_COUNTRY_CITY(도시 선택 팝업 — 인자 P_COUNTRY·P_CITY·P_CITY_NAME, SCM_MST_CITY 대상 = 다른 조회조건) /
#       P_SCP0005_GET_ROUTEID·GET_ROUTE_HIST(행 키 ROUTE_ID) / 저장·업로드 프로시저
# LOWER: SCP_MST_DISTRIBUTION_ROUTE.FROM_COUNTRY 소문자 0건 · FROM_CITY 0건 · TO_COUNTRY 0건 · TO_CITY 0건 / 전체 8,036건 (2026-11-13 10:29:20)
HUNKS = [
    ("                    OR T.FROM_COUNTRY IN (SELECT UPPER(XA.TOKEN)\n",
     "                    OR UPPER(T.FROM_COUNTRY) IN (SELECT UPPER(XA.TOKEN)   /* 2026.11.13 조회조건 대소문자 무시 */\n"),
    ("                                WHERE T.FROM_CITY LIKE UPPER(XB.TOKEN) || '%'\n",
     "                                WHERE UPPER(T.FROM_CITY) LIKE '%' || UPPER(XB.TOKEN) || '%'   /* 2026.11.13 조회조건 부분 일치 · 대소문자 무시 */\n"),
    ("                    OR T.TO_COUNTRY IN (SELECT UPPER(XC.TOKEN)\n",
     "                    OR UPPER(T.TO_COUNTRY) IN (SELECT UPPER(XC.TOKEN)   /* 2026.11.13 조회조건 대소문자 무시 */\n"),
    ("                                WHERE T.TO_CITY LIKE UPPER(XD.TOKEN) || '%'\n",
     "                                WHERE UPPER(T.TO_CITY) LIKE '%' || UPPER(XD.TOKEN) || '%'   /* 2026.11.13 조회조건 부분 일치 · 대소문자 무시 */\n"),
]
P = 'PKG_SCP0005.P_SCP0005_GET_DISTRIBUTION_ROUTE'
B = {}
TESTS = [
    dict(proc=P, vary='P_FROM_COUNTRY', cursor='O_RC', key=[], base=B, values=[
        ('same:empty', None), ('same:ALL', 'ALL'),
        ('eq:code:upper', 'KR'), ('eq:code:lower', 'kr'),
        ('eq:multi:upper', 'KR, CN'), ('eq:multi:lower', 'kr, cn'),
    ]),
    dict(proc=P, vary='P_FROM_CITY', cursor='O_RC', key=[], base=B, values=[
        ('same:empty', None), ('same:ALL', 'ALL'),
        ('eq:code:upper', 'KRCOJ'), ('eq:code:lower', 'krcoj'),
        ('eq:front:upper', 'KRC'), ('eq:front:lower', 'krc'),
        ('eq:mid:upper', 'RCO'), ('eq:mid:lower', 'rco'),
        ('eq:multi:upper', 'KRCOJ, CNNKG'), ('eq:multi:lower', 'krcoj, cnnkg'),
    ]),
    dict(proc=P, vary='P_TO_COUNTRY', cursor='O_RC', key=[], base=B, values=[
        ('same:empty', None), ('same:ALL', 'ALL'),
        ('eq:code:upper', 'PL'), ('eq:code:lower', 'pl'),
        ('eq:multi:upper', 'PL, US'), ('eq:multi:lower', 'pl, us'),
    ]),
    dict(proc=P, vary='P_TO_CITY', cursor='O_RC', key=[], base=B, values=[
        ('same:empty', None), ('same:ALL', 'ALL'),
        ('eq:code:upper', 'PLWRO'), ('eq:code:lower', 'plwro'),
        ('eq:front:upper', 'PLW'), ('eq:front:lower', 'plw'),
        ('eq:mid:upper', 'LWR'), ('eq:mid:lower', 'lwr'),
        ('eq:multi:upper', 'PLWRO, USHLM'), ('eq:multi:lower', 'plwro, ushlm'),
    ]),
]
