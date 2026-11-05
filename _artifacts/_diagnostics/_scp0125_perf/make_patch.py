# 최신 원문(pkg_body_before.sql, 착수 시 ALL_SOURCE) 위 외과적 치환 — 고유 매칭 assert
src = open('pkg_body_before.sql', encoding='utf-8').read()
def rep(old, new):
    global src
    n = src.count(old); assert n == 1, (n, old[:80]); src = src.replace(old, new)

# (1) 변수 선언 — P_LOAD_STOCK 의 선언부(V_MAX_TUESDAY 다음)
rep("""        V_DEMAND_CUTOFF_DAY     VARCHAR2(8 CHAR);
        V_MAX_TUESDAY           VARCHAR2(8 CHAR);
    BEGIN

        /* GTT 초기화 - TRUNCATE 는 암묵적 커밋이라 쓰지 않는다 */
        DELETE FROM GT_0125_NET_DEMAND;""",
"""        V_DEMAND_CUTOFF_DAY     VARCHAR2(8 CHAR);
        V_MAX_TUESDAY           VARCHAR2(8 CHAR);
        V_AGE_FROM_DATE         DATE;                   /* 재고 경과 읽기 시작 원장 마감일 (2026.10.30 속도) */
        V_AGE_SITE_MAX_DATE     DATE;
    BEGIN

        /* GTT 초기화 - TRUNCATE 는 암묵적 커밋이라 쓰지 않는다 */
        DELETE FROM GT_0125_NET_DEMAND;""")

# (2) 재고 경과 적재 직전 — 읽기 시작일 산출
rep("""        INSERT INTO GT_0125_INVENTORY_AGE
                    (
                      DIVISION_ID""",
"""        /* 2026.10.30 (START) 재고 경과 읽기 범위 축소 (속도)
           아래 적재는 사이트별 마지막 마감일 행만 남긴다 (IA.CUTOFF_DATE = IA.MAX_CUTOFF_DATE).
           따라서 '모든 사이트의 마지막 마감일 중 가장 이른 날' 보다 앞선 행은 결과에 들 수 없고,
           그 행을 빼도 어느 사이트의 마지막 마감일도 바뀌지 않는다 → 그 날부터만 읽는다. 결과 행은 같다.
           - 뷰 첫 갈래 : 원장 행이 바깥 조인만으로 그대로 나온다 → 원장(SCM_AGING_STOCK_H)의 사이트별 마지막 날이
                          그 사이트 묶음의 마지막 날 이하이다 (원장을 바로 읽으면 뷰보다 빠르다)
           - 뷰 둘째 갈래(ESS 가상 line) : 원장에 이 사업부 행이 없는 사이트로도 들어온다
                          → 그런 사이트만 뷰에서 마지막 날을 직접 구해 함께 비교한다 */
        SELECT MIN(XA.MAX_CUTOFF_DATE)
          INTO V_AGE_FROM_DATE
          FROM (SELECT XB.SITE_ID
                     , MAX(XB.CUTOFF_DATE) AS MAX_CUTOFF_DATE
                  FROM SCM_AGING_STOCK_H XB
                 WHERE XB.DIVISION_ID = P_DIVISION_ID
                   AND XB.SITE_ID IS NOT NULL
                   AND XB.CUTOFF_DATE >  V_D_CUTOFF_DAY - 6
                   AND XB.CUTOFF_DATE <= V_D_CUTOFF_DAY + 1
                 GROUP BY XB.SITE_ID) XA;

        FOR R_VL IN (SELECT DISTINCT XC.VL_SITE_ID
                       FROM TABLE(FN_GET_JV_REAL_ESS_VIRTUAL_LINE_MAP()) XC
                      WHERE XC.VL_DIVISION_ID = P_DIVISION_ID
                        AND XC.VL_SITE_ID IS NOT NULL
                        AND NOT EXISTS (SELECT 1
                                          FROM SCM_AGING_STOCK_H XD
                                         WHERE XD.DIVISION_ID = P_DIVISION_ID
                                           AND XD.SITE_ID = XC.VL_SITE_ID
                                           AND XD.CUTOFF_DATE >  V_D_CUTOFF_DAY - 6
                                           AND XD.CUTOFF_DATE <= V_D_CUTOFF_DAY + 1))
        LOOP
            SELECT MAX(XE.ORG_CUTOFF_DATE)
              INTO V_AGE_SITE_MAX_DATE
              FROM SCM_DNM_STOCK_AGING_V XE
             WHERE XE.DIVISION_ID = P_DIVISION_ID
               AND XE.SITE_ID = R_VL.VL_SITE_ID
               AND XE.ORG_CUTOFF_DATE >  V_D_CUTOFF_DAY - 6
               AND XE.ORG_CUTOFF_DATE <= V_D_CUTOFF_DAY + 1;

            IF V_AGE_SITE_MAX_DATE IS NOT NULL THEN
                V_AGE_FROM_DATE := LEAST(NVL(V_AGE_FROM_DATE, V_AGE_SITE_MAX_DATE), V_AGE_SITE_MAX_DATE);
            END IF;
        END LOOP;

        /* 대상 행이 없으면 기존 범위 그대로 (추가 조건 무효) */
        V_AGE_FROM_DATE := NVL(V_AGE_FROM_DATE, V_D_CUTOFF_DAY - 6);
        /* 2026.10.30 (END) */

        INSERT INTO GT_0125_INVENTORY_AGE
                    (
                      DIVISION_ID""")

# (3) 재고 경과 적재 WHERE — 읽기 시작일 조건 추가
rep("""                   AND A.ORG_CUTOFF_DATE >  V_D_CUTOFF_DAY - 6
                   AND A.ORG_CUTOFF_DATE <= V_D_CUTOFF_DAY + 1) IA
                   /* 2026.10.07 AJS (END) */""",
"""                   AND A.ORG_CUTOFF_DATE >  V_D_CUTOFF_DAY - 6
                   AND A.ORG_CUTOFF_DATE <= V_D_CUTOFF_DAY + 1
                   AND A.ORG_CUTOFF_DATE >= V_AGE_FROM_DATE                              /* 2026.10.30 읽기 범위 축소 (위 주석) */
                ) IA
                   /* 2026.10.07 AJS (END) */""")
open('pkg_body_after.sql', 'w', encoding='utf-8', newline='').write(src)
print('ok', len(src.splitlines()))
