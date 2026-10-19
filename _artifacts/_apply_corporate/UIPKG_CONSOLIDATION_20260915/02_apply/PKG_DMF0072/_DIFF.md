# PKG_DMF0072 변경 diff

```diff
--- SPEC(before)
+++ SPEC(after)
@@ -58,2 +58,41 @@
 
+    -- [2026-09-15 UIPKG] standalone DMF0072_GET_DATA_TYPE_LIST
+    PROCEDURE P_DMF0072_GET_DATA_TYPE_LIST (
+    O_RC1 OUT SYS_REFCURSOR
+);
+
+    -- [2026-09-15 UIPKG] standalone DMF0072_GET_END_CUSTOMER_LIST
+    PROCEDURE P_DMF0072_GET_END_CUSTOMER_LIST (
+    P_DIVISION_ID VARCHAR2,
+    P_DEPT_ID     VARCHAR2,
+    O_RC1 OUT SYS_REFCURSOR
+);
+
+    -- [2026-09-15 UIPKG] standalone DMF0072_GET_NNMASTER_MAPPING_WRAPPER
+    PROCEDURE P_DMF0072_GET_NNMASTER_MAPPING_WRAPPER (
+    P_DATA_TYPE_CODE VARCHAR2,
+    P_DIVISION_ID    VARCHAR2,
+    P_DEPT_ID        VARCHAR2,
+    P_END_CUSTOMER   VARCHAR2,
+    P_SCM_SITE_ID    VARCHAR2,
+    P_PROJECT_CODE   VARCHAR2,
+    P_ITEM_ID        VARCHAR2,
+    P_USER_ID        VARCHAR2,
+    P_MENU_ID        VARCHAR2,
+    O_RC1            OUT SYS_REFCURSOR
+);
+
+    -- [2026-09-15 UIPKG] standalone DMF0072_GET_SALES_SITE_LIST
+    PROCEDURE P_DMF0072_GET_SALES_SITE_LIST (
+    P_DIVISION_ID  VARCHAR2,
+    P_END_CUSTOMER VARCHAR2,
+    O_RC1 OUT SYS_REFCURSOR
+);
+
+    -- [2026-09-15 UIPKG] standalone DMF0072_GET_TEAM_LIST
+    PROCEDURE P_DMF0072_GET_TEAM_LIST (
+    P_DIVISION_ID VARCHAR2,
+    O_RC1 OUT SYS_REFCURSOR
+);
+
 END PKG_DMF0072;
--- BODY(before)
+++ BODY(after)
@@ -734,2 +734,152 @@
 
+    -- [2026-09-15 UIPKG] standalone DMF0072_GET_DATA_TYPE_LIST 취합
+PROCEDURE P_DMF0072_GET_DATA_TYPE_LIST (
+    O_RC1 OUT SYS_REFCURSOR
+) AS
+BEGIN
+    OPEN O_RC1 FOR
+        SELECT 'ALL' AS CODE, 'ALL' AS NAME FROM DUAL
+        UNION ALL
+        SELECT DISTINCT SEGMENT1, NVL(SEGMENT2, SEGMENT1) AS NAME
+          FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
+         WHERE LOOKUP_TYPE='DM_EDI_DATA_TYPE_CODE' AND VALID_YN='Y'
+         ORDER BY 1;
+END P_DMF0072_GET_DATA_TYPE_LIST;
+
+    -- [2026-09-15 UIPKG] standalone DMF0072_GET_END_CUSTOMER_LIST 취합
+PROCEDURE P_DMF0072_GET_END_CUSTOMER_LIST (
+    P_DIVISION_ID VARCHAR2,
+    P_DEPT_ID     VARCHAR2,
+    O_RC1 OUT SYS_REFCURSOR
+) AS
+BEGIN
+    -- As-Is .cs L165~178: EndCustomerByDivision[40]
+    --   div='40' 분기는 To-Be 에서 통합 SP 로 단일화 (분기 logic 은 wrapper 측에서 처리 가능)
+    --   P_DEPT_ID 'ALL' 또는 NULL → 부서 무관 / 그 외 → 콤마 split 후 매칭
+    OPEN O_RC1 FOR
+      SELECT DISTINCT END_CUSTOMER AS CODE,
+             END_CUSTOMER AS NAME
+        FROM SCM_MGR.SCM_MST_SITE S
+       WHERE (P_DIVISION_ID IS NULL OR P_DIVISION_ID = 'ALL' OR S.DIVISION_ID = P_DIVISION_ID)
+         AND S.END_CUSTOMER IS NOT NULL
+         AND S.VALID_YN = 'Y'
+         -- cascading: P_DEPT_ID 가 'ALL' 또는 빈 값이면 전체, 그 외 부서별 (현 시점 매핑 부재 — site.OWNER dept 매핑 후속 작업)
+         AND (P_DEPT_ID IS NULL OR P_DEPT_ID = 'ALL'
+              OR EXISTS (
+                SELECT 1 FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_DEPT_ID, ',')) P
+                 WHERE P.TOKEN IS NOT NULL
+              )
+             )
+       ORDER BY 1;
+END P_DMF0072_GET_END_CUSTOMER_LIST;
+
+    -- [2026-09-15 UIPKG] standalone DMF0072_GET_NNMASTER_MAPPING_WRAPPER 취합
+PROCEDURE P_DMF0072_GET_NNMASTER_MAPPING_WRAPPER (
+    P_DATA_TYPE_CODE VARCHAR2,
+    P_DIVISION_ID    VARCHAR2,
+    P_DEPT_ID        VARCHAR2,
+    P_END_CUSTOMER   VARCHAR2,
+    P_SCM_SITE_ID    VARCHAR2,
+    P_PROJECT_CODE   VARCHAR2,
+    P_ITEM_ID        VARCHAR2,
+    P_USER_ID        VARCHAR2,
+    P_MENU_ID        VARCHAR2,
+    O_RC1            OUT SYS_REFCURSOR
+) AS
+    V_RESULT_CURSOR SYS_REFCURSOR;
+BEGIN
+    -- As-Is .cs L477~485: FoxDataRequest("DMF0072_GET_NNMASTER_MAPPING")
+    --   p_data_type_code/divisionId/deptId/endCustomer/scmSiteId 모두 콤마 join 그대로 전달
+    --   ('ALL' 도 그대로 — 메인 SP 가 CASE WHEN P_XXX='ALL' THEN ... 으로 처리)
+    SCM_MGR.PKG_DMF0072.P_DMF0072_GET_NNMASTER_MAPPING(
+        P_DATA_TYPE_CODE,
+        P_DIVISION_ID,
+        P_DEPT_ID,
+        P_END_CUSTOMER,
+        P_SCM_SITE_ID,
+        P_PROJECT_CODE,
+        P_ITEM_ID,
+        P_USER_ID,
+        P_MENU_ID,
+        O_RC1,
+        V_RESULT_CURSOR
+    );
+END P_DMF0072_GET_NNMASTER_MAPPING_WRAPPER;
+
+    -- [2026-09-15 UIPKG] standalone DMF0072_GET_SALES_SITE_LIST 취합
+PROCEDURE P_DMF0072_GET_SALES_SITE_LIST (
+    P_DIVISION_ID  VARCHAR2,
+    P_END_CUSTOMER VARCHAR2,
+    O_RC1 OUT SYS_REFCURSOR
+) AS
+BEGIN
+    -- As-Is .cs L186: UserSiteByEndCustomer — Division + End Customer(다중) 기반 SCM Site list
+    OPEN O_RC1 FOR
+      SELECT DISTINCT S.SCM_SITE_ID AS CODE,
+             NVL(S.SITE_DESCRIPTION, S.SCM_SITE_ID) AS NAME
+        FROM SCM_MGR.SCM_MST_SITE S
+       WHERE (P_DIVISION_ID IS NULL OR P_DIVISION_ID = 'ALL' OR S.DIVISION_ID = P_DIVISION_ID)
+         AND S.VALID_YN = 'Y'
+         -- multi-value cascading: 콤마 split
+         AND (P_END_CUSTOMER IS NULL OR P_END_CUSTOMER = 'ALL'
+              OR S.END_CUSTOMER IN (
+                SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_END_CUSTOMER, ','))
+                 WHERE TOKEN IS NOT NULL
+              )
+             )
+       ORDER BY 1
+       FETCH FIRST 500 ROWS ONLY;
+END P_DMF0072_GET_SALES_SITE_LIST;
+
+    -- [2026-09-15 UIPKG] standalone DMF0072_GET_TEAM_LIST 취합
+PROCEDURE P_DMF0072_GET_TEAM_LIST (
+    P_DIVISION_ID VARCHAR2,
+    O_RC1 OUT SYS_REFCURSOR
+) AS
+BEGIN
+    -- As-Is SCM0001_GET_TEAM_BY_DIVISION 1:1 변환
+    --   - SCM_MST_SITE A (SITE_TYPE='SALES') ⋈ SCM_MST_SSO_DEPT_INFO B (DEPT_ID 매칭)
+    --   - P_DIVISION_ID 'ALL' 또는 콤마 split IN 매칭
+    --   - WITH(NOLOCK) 제거 (Oracle read consistency)
+    --   - XML split → UF_FX_STRING_SPLIT (메인 SP P_DMF0072_GET_NNMASTER_MAPPING 과 일관)
+    OPEN O_RC1 FOR
+--      SELECT DISTINCT
+----           B.DEPT_ID      AS CODE,
+--             C.DEPT_ID      AS CODE,   /* 부서코드 : 아이템 원장 */                    -- 2026.09.06 AJS
+--             B.DEPT_NAME_KO AS NAME
+--        FROM SCM_MGR.SCM_MST_SITE          A,
+--             SCM_MGR.SCM_MST_SITE_ITEM     C,   /* 아이템 원장 추가 */                 -- 2026.09.06 AJS
+--             SCM_MGR.SCM_MST_SSO_DEPT_INFO B
+--       WHERE A.SITE_TYPE = 'SALES'
+----       AND A.DEPT_ID   = B.DEPT_ID
+--         AND A.DIVISION_ID = C.DIVISION_ID                                             -- 2026.09.06 AJS
+--         AND A.SCM_SITE_ID = C.SCM_SITE_ID                                             -- 2026.09.06 AJS
+--         AND C.DEPT_ID     = B.DEPT_ID                                                 -- 2026.09.06 AJS
+--         AND (P_DIVISION_ID IS NULL
+--              OR P_DIVISION_ID = 'ALL'
+--              OR A.DIVISION_ID IN (
+--                  SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_DIVISION_ID, ','))
+--                   WHERE TOKEN IS NOT NULL
+--              )
+--             )
+--       ORDER BY 2;
+    --*[2026-09-06] SSPM 적용 기준
+      SELECT DISTINCT
+             C.DEPT_ID      AS CODE,   /* 부서코드 : 아이템 원장 */                    -- 2026.09.06 AJS
+             B.DEPT_NAME_KO AS NAME
+             
+        FROM SCM_MGR.SCM_MST_SITE_ITEM     C,   /* 아이템 원장 추가 */                 -- 2026.09.06 AJS
+             SCM_MGR.SCM_MST_SSO_DEPT_INFO B
+       WHERE C.DEPT_ID     = B.DEPT_ID                                                 -- 2026.09.06 AJS
+         AND C.VALID_YN    = 'Y'
+         AND (P_DIVISION_ID IS NULL
+              OR P_DIVISION_ID = 'ALL'
+              OR C.DIVISION_ID IN (
+                  SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_DIVISION_ID, ','))
+                   WHERE TOKEN IS NOT NULL
+              )
+             )
+       ORDER BY 2;
+END P_DMF0072_GET_TEAM_LIST;
+
 END PKG_DMF0072;
```
