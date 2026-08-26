# -*- coding: utf-8 -*-
"""PKG_DMF0051 BODY 정밀 치환 패치 생성 (전사 금지 — 원문 라인 바이트 보존 + 전제 assert).

P1 [E20260820-D51SCALAR]  L1149~ GT_DM51_SCM_MST_SITE_ITEM : 행별 상관 스칼라/함수 → DISTINCT OWNER 선계산 + LEFT JOIN
P2 [E20260820-D51REGROUP] L1131~ GT_DM22_DM_MST_ITEM_SINGLE_V : 증명 가능한 무용 GROUP BY 제거
P3 [E20260820-D51SEMI]    L1610  동적SQL div40 분기 : INNER JOIN SCM_MST_SITE F(컬럼 미사용·PK 유일) → EXISTS
"""
import io
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")

SRC = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0051_PERF_20260820\PKG_DMF0051_BODY_LIVE.sql"
DST = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0051_PERF_20260820\PKG_DMF0051_BODY_PATCHED.sql"

src = open(SRC, encoding="utf-8").read()


def rep(tag, old, new, expect=1):
    global src
    n = src.count(old)
    assert n == expect, f"[{tag}] 전제 불일치: 원문 출현 {n}회 (기대 {expect}) — 중단"
    src = src.replace(old, new, expect)
    print(f"  [OK] {tag} — {expect}곳 치환 ({len(old)} → {len(new)} bytes)")


print("[전제 assert]")
for tag, pat, exp in [
    ("마커 DS2 보존", "[E20260820-DS2]", 1),
    ("마커 00979 보존", "[E20260806-00979]", 3),
    ("마커 WF 보존", "[E20260806-WF]", 3),
    ("신규 마커 미존재", "E20260820-D51", 0),
]:
    got = src.count(pat)
    assert got == exp, f"{tag}: {got} != {exp}"
    print(f"  [OK] {tag} = {exp}")

# ── P1 ──────────────────────────────────────────────────────────────────────
P1_OLD = """        SELECT DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, CURRENCY, CUST_GROUP
             , CUST_GROUP_DTL, APPLICATION, ROUTE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE5
             , REPORT_GROUP1, REPORT_GROUP2, REPORT_GROUP3, REPORT_GROUP4, REPORT_GROUP5
             , REPORT_GROUP6, OWNER, CELL_PER_CAR, CELL_PER_MODULE
             , SCM_MGR.FN_GET_DM_MKT_OWNER_NAME(SMSI.OWNER, ',', 'EN')                AS OWNER_NAME
             , SCM_MGR.FN_GET_DM_MKT_OWNER_NAME(SMSI.OWNER, ',', 'KO')                AS OWNER_NAME_KO
             , ( SELECT SU.DEPT_ID
                   FROM SCM_MGR.SCM_MST_SSO_USER_INFO SU
                  WHERE SU.USER_ID = (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(SMSI.OWNER, ',')) P WHERE ROWNUM = 1)
               ) AS DEPT_ID
          FROM SCM_MGR.SCM_MST_SITE_ITEM SMSI
         WHERE SMSI.DIVISION_ID = P_DIVISION_ID
        ;"""

P1_NEW = """        --[E20260820-D51SCALAR] hook #129 ① SELECT 목록 행별 상관 스칼라/함수 제거 → 선계산 + LEFT JOIN
        --  FN_GET_DM_MKT_OWNER_NAME(EN/KO) 와 DEPT_ID 스칼라 서브쿼리는 모두 OWNER 만의 결정함수이므로
        --  DISTINCT OWNER 당 1회만 평가한 뒤 조인한다. 값 산식·NULL 거동(미매칭 → NULL) 원본 동일.
        --  사내 div40 실측: 대상 23,193행 / DISTINCT OWNER 88종 (함수·서브쿼리 평가 69,579회 → 264회)
        SELECT SMSI.DIVISION_ID, SMSI.SCM_SITE_ID, SMSI.PROJECT_CODE, SMSI.ITEM_ID, SMSI.CURRENCY, SMSI.CUST_GROUP
             , SMSI.CUST_GROUP_DTL, SMSI.APPLICATION, SMSI.ROUTE, SMSI.ATTRIBUTE1, SMSI.ATTRIBUTE2, SMSI.ATTRIBUTE5
             , SMSI.REPORT_GROUP1, SMSI.REPORT_GROUP2, SMSI.REPORT_GROUP3, SMSI.REPORT_GROUP4, SMSI.REPORT_GROUP5
             , SMSI.REPORT_GROUP6, SMSI.OWNER, SMSI.CELL_PER_CAR, SMSI.CELL_PER_MODULE
             , OW.OWNER_NAME                                                          AS OWNER_NAME
             , OW.OWNER_NAME_KO                                                       AS OWNER_NAME_KO
             , OW.DEPT_ID                                                             AS DEPT_ID
          FROM SCM_MGR.SCM_MST_SITE_ITEM SMSI
          LEFT JOIN ( SELECT O.OWNER                                                  AS OWNER
                           , SCM_MGR.FN_GET_DM_MKT_OWNER_NAME(O.OWNER, ',', 'EN')     AS OWNER_NAME
                           , SCM_MGR.FN_GET_DM_MKT_OWNER_NAME(O.OWNER, ',', 'KO')     AS OWNER_NAME_KO
                           , ( SELECT SU.DEPT_ID
                                 FROM SCM_MGR.SCM_MST_SSO_USER_INFO SU
                                WHERE SU.USER_ID = (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(O.OWNER, ',')) P WHERE ROWNUM = 1)
                             ) AS DEPT_ID
                        FROM ( SELECT DISTINCT OWNER
                                 FROM SCM_MGR.SCM_MST_SITE_ITEM
                                WHERE DIVISION_ID = P_DIVISION_ID ) O
                    ) OW
                 ON OW.OWNER = SMSI.OWNER
         WHERE SMSI.DIVISION_ID = P_DIVISION_ID
        ;"""
rep("P1 D51SCALAR", P1_OLD, P1_NEW)

# ── P2 ──────────────────────────────────────────────────────────────────────
P2_OLD = """          ) A
         GROUP BY A.DIVISION_ID, A.ITEM_ID, A.ITEM_NAME, A.ITEM_CLASS, A.ITEM_CLASS_NAME, A.NICK_NAME, A.ITEM_TYPE, A.MATERIAL_CLASS_NAME
                , A.ITEM_UOM, A.SPEC, A.MDM_PROJECT_NAME, A.MIN_CAPACITY, A.FORECAST_INFO_BIZ_TYPE, A.FORECAST_INFO_PRODUCT_GROUP
                , A.FORECAST_INFO_CELL_MODEL, A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_SPEC, A.FORECAST_INFOR_VERSION
                , A.ACTIVE_FLAG, A.CELL_TYPE, A.ENERGE, A.CELL_QUANTITY, A.SCP_EXTRA_SPEC
        ;"""

P2_NEW = """          ) A
        --[E20260820-D51REGROUP] 무용 GROUP BY 제거 (값 무영향 — 증명):
        --  A_V = GROUP BY (DIVISION_ID, ITEM_ID)           → (DIVISION_ID, ITEM_ID) 유일
        --  B_V = GROUP BY (DIVISION_ID, SUBSTR(ITEM_ID,1,12)) → 조인키당 최대 1행
        --  ⇒ 인라인뷰 A 는 이미 (DIVISION_ID, ITEM_ID) 유일이고 GROUP BY 목록이 그 두 컬럼을 포함하므로
        --    전 컬럼 GROUP BY 는 항등 연산(행 축약 0). 사내 실측 169,928행 IN = 169,928행 OUT.
        ;"""
rep("P2 D51REGROUP", P2_OLD, P2_NEW)

# ── P3 ──────────────────────────────────────────────────────────────────────
#  ⚠ 근거 서술은 PL/SQL 주석(문자열 밖)에 둔다 — v_sql_text 는 VARCHAR2(32767 CHAR) 라
#    동적 SQL 문자열 안에 주석을 넣으면 넓은 titleset 에서 ORA-06502 여유를 갉아먹는다.
P3_OLD = """            FROM SCM_MGR.GT_DM51_RAW_DATA A
            INNER JOIN SCM_MGR.SCM_MST_SITE             F ON (A.DIVISION_ID = F.DIVISION_ID AND A.SCM_SITE_ID = F.SCM_SITE_ID)
            LEFT JOIN SCM_MGR.SCM_MST_PROJECT           B ON (A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE)"""

P3_NEW = """            FROM SCM_MGR.GT_DM51_RAW_DATA A
            LEFT JOIN SCM_MGR.SCM_MST_PROJECT           B ON (A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE)"""
rep("P3a D51SEMI(조인 제거)", P3_OLD, P3_NEW)

P3B_OLD = """            INNER JOIN SCM_MGR.SCM_ADM_USER_MNU_EDIT_AUTH_V EDY
                 ON EDY.USER_ID = ''' || P_USER_ID || '''
                AND EDY.MNU_ID  = ''' || P_MENU_ID || '''
                AND EDY.UNIT_ID = A.DIVISION_ID
            )
            ';
        ELSE"""

P3B_NEW = """            INNER JOIN SCM_MGR.SCM_ADM_USER_MNU_EDIT_AUTH_V EDY
                 ON EDY.USER_ID = ''' || P_USER_ID || '''
                AND EDY.MNU_ID  = ''' || P_MENU_ID || '''
                AND EDY.UNIT_ID = A.DIVISION_ID
            WHERE EXISTS (SELECT 1
                            FROM SCM_MGR.SCM_MST_SITE F
                           WHERE F.DIVISION_ID = A.DIVISION_ID
                             AND F.SCM_SITE_ID = A.SCM_SITE_ID)
            )
            ';
        ELSE"""
rep("P3b D51SEMI(EXISTS 추가)", P3B_OLD, P3B_NEW)

# 마커·근거는 문자열 밖 PL/SQL 주석으로 (동적 SQL 길이 무증가)
P3C_OLD = """        IF P_DIVISION_ID = '40' THEN
            v_sql_text := 'WITH T_DM51_WF AS ('"""
P3C_NEW = """        --[E20260820-D51SEMI] div40 분기: INNER JOIN SCM_MGR.SCM_MST_SITE F → WHERE EXISTS 로 전환 (등가 — 증명)
        --  · F 는 GT_DM22_T_COLUMN_SETUP 의 어느 별칭에도 쓰이지 않아 SELECT 목록에 기여하지 않는다
        --  · 조인키 (DIVISION_ID, SCM_SITE_ID) = PK_SCM_MST_SITE (사내 실측 3,029/3,029 유일) → 매칭 0 또는 1행, 증식 불가
        --  ⇒ INNER JOIN 은 순수 존재필터이므로 EXISTS 와 결과 동일. 권한축(EDY) 은 원본 그대로 보존한다.
        --  사내 실측 근거: 이 조인이 NESTED LOOPS + PK 단일스캔 1,033K회 = 최종문 버퍼겟의 91% (223K/245K)
        --  ⚠ 근거를 동적 SQL 문자열 안에 넣지 않는 이유: v_sql_text 는 VARCHAR2(32767 CHAR) — 여유 보존
        IF P_DIVISION_ID = '40' THEN
            v_sql_text := 'WITH T_DM51_WF AS ('"""
rep("P3c D51SEMI(근거 주석)", P3C_OLD, P3C_NEW)

# ── P4 ──────────────────────────────────────────────────────────────────────
# DMF0022 작업자 실측 제보(Stage A 동형) — 공유 GTT 를 선행축소 없이 회당 243,050행 적재하고 있었음.
P4_OLD = """          FROM SCM_MGR.SCM_MST_ITEM_SN
         WHERE DIVISION_ID = P_DIVISION_ID
        ;"""

P4_NEW = """          FROM SCM_MGR.SCM_MST_ITEM_SN
         WHERE DIVISION_ID = P_DIVISION_ID
        --[E20260820-D51ITEMPFX] hook #129 ④ 선행축소 — 소비되지 않는 품목을 GTT 에 싣지 않는다.
        --  ⚠ 축소 단위는 반드시 SUBSTR(ITEM_ID,1,12) prefix.
        --     하류 _B_V 가 (DIVISION_ID, SUBSTR(ITEM_ID,1,12)) 로 MAX 집계하므로 정확 ITEM_ID 로 축소하면
        --     같은 prefix 를 공유하는 형제 품목이 빠져 MAX 그룹이 바뀐다(값 등가 파괴). prefix 단위면 그룹 원형 보존.
        --  전제(정적 확인): GT_DM51_RAW_DATA 의 INSERT 는 전부 이 문장보다 위(본문 688/727/777/834/874/928)에서 끝나고,
        --     이 아래는 DELETE(1215~1324) 뿐이라 prefix 집합은 최종 집합의 상위집합 → 축소 과소 위험 없음.
        --  등가: 소비처는 모두 정확 (DIVISION_ID, ITEM_ID) 로 조인/EXISTS 하며, RAW_DATA 의 ITEM_ID 는
        --     정의상 자기 prefix 가 집합에 있으므로 SN 에 존재하면 반드시 잔류한다(=조인 결과 불변).
        --  사내 div40 실측: 243,050행 → 6,053행 (-97.5%), 원장 prefix 899종
           AND SUBSTR(ITEM_ID, 1, 12) IN (SELECT DISTINCT SUBSTR(R.ITEM_ID, 1, 12)
                                            FROM SCM_MGR.GT_DM51_RAW_DATA R)
        ;"""
rep("P4 D51ITEMPFX", P4_OLD, P4_NEW)

print("\n[사후 assert]")
for tag, pat, exp in [
    ("DS2 보존", "[E20260820-DS2]", 1),
    ("00979 보존", "[E20260806-00979]", 3),
    ("WF 보존", "[E20260806-WF]", 3),
    ("D51SCALAR", "[E20260820-D51SCALAR]", 1),
    ("D51REGROUP", "[E20260820-D51REGROUP]", 1),
    ("D51SEMI", "[E20260820-D51SEMI]", 1),
    ("D51ITEMPFX", "[E20260820-D51ITEMPFX]", 1),
    ("EDIT_AUTH_V 보존(2분기)", "SCM_ADM_USER_MNU_EDIT_AUTH_V EDY", 2),
    ("작은따옴표 총수 짝수", "'", None),
]:
    got = src.count(pat)
    if exp is None:
        assert got % 2 == 0, f"{tag}: 홑따옴표 {got}개(홀수) — 동적SQL 리터럴 파손 의심"
        print(f"  [OK] {tag} = {got}")
    else:
        assert got == exp, f"{tag}: {got} != {exp}"
        print(f"  [OK] {tag} = {exp}")

open(DST, "w", encoding="utf-8").write(src)
print(f"\n[saved] {DST} ({src.count(chr(10))} lines)")
