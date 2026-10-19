# PKG_DMF0008 변경 diff

```diff
--- SPEC(before)
+++ SPEC(after)
@@ -4,37 +4,37 @@
     /* 1단 요약 조회 */
-    PROCEDURE P_DMF0008_GET_EDI_MST_SUMMARY
-    (
-        p_FROM_YYYYMMDD         VARCHAR2
-      , p_TO_YYYYMMDD           VARCHAR2
-      , p_DIVISION_ID           VARCHAR2
-      , p_user_id               VARCHAR2
-      , p_menu_id               VARCHAR2
-      , O_RC1                   OUT SYS_REFCURSOR
-      , O_RC3                   OUT SYS_REFCURSOR
-      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
-    );
+    PROCEDURE P_DMF0008_GET_EDI_MST_SUMMARY 
+(
+  p_FROM_YYYYMMDD VARCHAR2,  --안쓰임
+  p_TO_YYYYMMDD   VARCHAR2,  --안쓰임
+  p_DIVISION_ID   VARCHAR2,  --쓰임
+  p_user_id       VARCHAR2,
+  p_menu_id       VARCHAR2,
+  O_RC1           OUT SYS_REFCURSOR,
+  O_RC3           OUT SYS_REFCURSOR,
+  O_RESULT_CURSOR OUT SYS_REFCURSOR
+);
 
     /* 2단 정비 대상 조회 */
-    PROCEDURE P_DMF0008_GET_EDI_MST_REPAIR
-    (
-        p_DIVISION_ID           VARCHAR2
-      , p_FROM_YYYYMMDD         VARCHAR2
-      , p_TO_YYYYMMDD           VARCHAR2
-      , p_Sender_Name           VARCHAR2
-      , p_Flag                  VARCHAR2
-      , p_user_id               VARCHAR2
-      , p_menu_id               VARCHAR2
-      , O_RC1                   OUT SYS_REFCURSOR
-      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
-    );
+    PROCEDURE P_DMF0008_GET_EDI_MST_REPAIR 
+(
+	  p_DIVISION_ID        VARCHAR2
+	, p_FROM_YYYYMMDD	    VARCHAR2
+	, p_TO_YYYYMMDD		VARCHAR2
+	, p_Sender_Name		VARCHAR2
+	, p_Flag				VARCHAR2
+    , p_user_id VARCHAR2
+    , p_menu_id VARCHAR2
+    , O_RC1  OUT  SYS_REFCURSOR
+    , O_RESULT_CURSOR OUT SYS_REFCURSOR
+);
 
     /* 3단 Sales Site 조회 */
-    PROCEDURE P_DMF0008_GET_SALES_SITE
-    (
-        p_division_id           VARCHAR2
-      , p_soldto                VARCHAR2
-      , p_shipto                VARCHAR2
-      , p_scm_site_id           VARCHAR2
-      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
-    );
+    PROCEDURE P_DMF0008_GET_SALES_SITE 
+(
+  p_division_id   VARCHAR2,
+  p_soldto        VARCHAR2,
+  p_shipto        VARCHAR2,
+  p_scm_site_id   VARCHAR2,
+  O_RESULT_CURSOR OUT SYS_REFCURSOR
+);
 
@@ -53,58 +53,58 @@
     /* 갱신 이력 조회 */
-    PROCEDURE P_DMF0008_GET_UPDATE_HISTORY
-    (
-        P_USER_ID               VARCHAR2
-      , P_MENU_ID               VARCHAR2
-      , O_RC1                   OUT SYS_REFCURSOR
-    );
+    PROCEDURE P_DMF0008_GET_UPDATE_HISTORY (
+    P_USER_ID VARCHAR2,
+    P_MENU_ID VARCHAR2,
+    O_RC1     OUT SYS_REFCURSOR
+);
 
     /* Sales Site 저장 */
-    PROCEDURE P_DMF0008_SAVE_SALES_SITE_EDI_REPAIR
-    (
-        p_division_id           IN  VARCHAR2
-      , p_end_customer          IN  VARCHAR2
-      , p_soldto_customer       IN  VARCHAR2
-      , p_company_id            IN  VARCHAR2
-      , p_scm_site_id           IN  VARCHAR2
-      , p_soldto_code           IN  VARCHAR2
-      , p_shipto_code           IN  VARCHAR2
-      , p_vmi_yn                IN  VARCHAR2
-      , p_valid_yn              IN  VARCHAR2
-      , p_cust_valid_yn         IN  VARCHAR2
-      , p_rep_yn                IN  VARCHAR2
-      , p_country               IN  VARCHAR2
-      , p_city                  IN  VARCHAR2
-      , p_ship_plan_auto        IN  VARCHAR2
-      , p_dept_id               IN  VARCHAR2
-      , p_created_by            IN  VARCHAR2
-      , p_message_cursor        OUT SYS_REFCURSOR
-    );
+    PROCEDURE P_DMF0008_SAVE_SALES_SITE_EDI_REPAIR 
+(
+		p_division_id					IN  VARCHAR2,
+		p_end_customer				IN  VARCHAR2,
+		p_soldto_customer			IN  VARCHAR2,
+		p_company_id					IN  VARCHAR2,
+		p_scm_site_id					IN  VARCHAR2,
+		p_soldto_code					IN  VARCHAR2,
+		p_shipto_code					IN  VARCHAR2,
+		p_vmi_yn							IN  VARCHAR2,
+		p_valid_yn						IN  VARCHAR2,
+		p_cust_valid_yn					IN  VARCHAR2,
+		p_rep_yn							IN  VARCHAR2,
+		p_country						IN  VARCHAR2,
+		p_city								IN  VARCHAR2,
+		p_ship_plan_auto				IN  VARCHAR2,
+		p_dept_id						IN  VARCHAR2,
+		p_created_by					IN  VARCHAR2,
+		p_message_cursor				OUT SYS_REFCURSOR
+);
 
     /* Project Model 저장 */
-    PROCEDURE P_DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR
-    (
-        p_division_id           VARCHAR2
-      , p_project_code          VARCHAR2
-      , p_scm_site_id           VARCHAR2
-      , p_item_id               VARCHAR2
-      , p_currency              VARCHAR2
-      , p_kwh                   VARCHAR2
-      , p_cell_per_car          VARCHAR2
-      , p_cell_per_module       VARCHAR2
-      , p_liability_period      VARCHAR2
-      , p_valid_yn              VARCHAR2
-      , p_bpms_exist            VARCHAR2
-      , p_sales_company         VARCHAR2
-      , p_sales_plant           VARCHAR2
-      , p_module_variant        VARCHAR2
-      , p_incoterms             VARCHAR2
-      , p_created_by            VARCHAR2
-      , O_RC1                   OUT SYS_REFCURSOR
-      , O_RC2                   OUT SYS_REFCURSOR
-      , O_RC3                   OUT SYS_REFCURSOR
-      , O_RC4                   OUT SYS_REFCURSOR
-      , O_RC5                   OUT SYS_REFCURSOR
-      , O_RC6                   OUT SYS_REFCURSOR
-      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
-    );
+    PROCEDURE P_DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR 
+(
+    p_division_id         VARCHAR2,
+    p_project_code          VARCHAR2,
+    p_scm_site_id         VARCHAR2,
+    p_item_id             VARCHAR2,
+    p_currency            VARCHAR2,
+    p_kwh               VARCHAR2, --ATTRIBUTE8
+    p_cell_per_car          VARCHAR2,
+    p_cell_per_module       VARCHAR2,
+    p_liability_period        VARCHAR2,
+    p_valid_yn            VARCHAR2,
+    p_bpms_exist          VARCHAR2,
+    p_sales_company       VARCHAR2,
+    p_sales_plant         VARCHAR2,
+    p_module_variant        VARCHAR2, --ATTRIBUTE2
+    p_incoterms           VARCHAR2, --ATTRIBUTE6
+    p_created_by          VARCHAR2
+
+    , O_RC1  OUT  SYS_REFCURSOR
+    , O_RC2  OUT  SYS_REFCURSOR
+    , O_RC3  OUT  SYS_REFCURSOR
+    , O_RC4  OUT  SYS_REFCURSOR
+    , O_RC5  OUT  SYS_REFCURSOR
+    , O_RC6  OUT  SYS_REFCURSOR
+    , O_RESULT_CURSOR OUT SYS_REFCURSOR
+);
 
--- BODY(before)
+++ BODY(after)
@@ -3,3 +3,3 @@
 
-PROCEDURE P_DMF0008_GET_EDI_MST_SUMMARY
+PROCEDURE P_DMF0008_GET_EDI_MST_SUMMARY 
 (
@@ -44,4 +44,3 @@
   V_BACKTRACE     VARCHAR2(4000 CHAR) := NULL;
---  v_program_name  VARCHAR2(150 CHAR)  := $$PLSQL_UNIT;
-  v_program_name  VARCHAR2(150 CHAR)  := $$PLSQL_UNIT || '.P_DMF0008_GET_EDI_MST_SUMMARY';   -- 2026.09.14 AJS
+  v_program_name  VARCHAR2(150 CHAR)  := $$PLSQL_UNIT;
 BEGIN
@@ -118,4 +117,3 @@
     PR_SCM_SYS_LOG_BATCH(
---      $$PLSQL_UNIT,
-      v_program_name,   -- 2026.09.14 AJS
+      $$PLSQL_UNIT,
       V_LOG_TYPE,
@@ -132,4 +130,3 @@
       -20001,
---      '[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE
-      '[' || v_program_name || '] SQLCODE=' || SQLCODE   -- 2026.09.14 AJS
+      '[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE
         || ' / SQLERRM='   || SQLERRM
@@ -139,3 +136,3 @@
 
-PROCEDURE P_DMF0008_GET_EDI_MST_REPAIR
+PROCEDURE P_DMF0008_GET_EDI_MST_REPAIR 
 (
@@ -186,4 +183,3 @@
     V_BACKTRACE   VARCHAR2(4000 CHAR) := NULL;
---    v_program_name VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
-    v_program_name VARCHAR2(150 CHAR) := $$PLSQL_UNIT || '.P_DMF0008_GET_EDI_MST_REPAIR';   -- 2026.09.14 AJS
+    v_program_name VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
 BEGIN
@@ -431,4 +427,3 @@
         V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
---        PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT,
-        PR_SCM_SYS_LOG_BATCH(v_program_name,   -- 2026.09.14 AJS
+        PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT,
                             V_LOG_TYPE,
@@ -444,4 +439,3 @@
     RAISE_APPLICATION_ERROR(-20001,
---        '[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE ||
-        '[' || v_program_name || '] SQLCODE=' || SQLCODE ||   -- 2026.09.14 AJS
+        '[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE ||
         ' / SQLERRM=' || SQLERRM ||
@@ -452,3 +446,3 @@
 
-PROCEDURE P_DMF0008_GET_SALES_SITE
+PROCEDURE P_DMF0008_GET_SALES_SITE 
 (
@@ -617,4 +611,3 @@
     OPEN O_RESULT_CURSOR FOR
---    SELECT T.* FROM GT_GSSI_DMF0008_RESULT_TABLE_2_2 T;
-    SELECT '2' AS SEARCHTYPE, T.* FROM GT_GSSI_DMF0008_RESULT_TABLE_2_2 T;   -- 2026.09.14 AJS
+    SELECT T.* FROM GT_GSSI_DMF0008_RESULT_TABLE_2_2 T;
   END IF;
@@ -1061,3 +1054,3 @@
 
-PROCEDURE P_DMF0008_GET_UPDATE_HISTORY(
+PROCEDURE P_DMF0008_GET_UPDATE_HISTORY (
     P_USER_ID VARCHAR2,
@@ -1068,7 +1061,6 @@
 BEGIN
---    SCM_MGR.DMF0000_GET_UPDATE_HISTORY(O_RC1, v_dummy);
-    DMF0000_GET_UPDATE_HISTORY(O_RC1, v_dummy);   -- 2026.09.14 AJS
+    PKG_DMF0000.P_DMF0000_GET_UPDATE_HISTORY(O_RC1, v_dummy);
 END P_DMF0008_GET_UPDATE_HISTORY;
 
-PROCEDURE P_DMF0008_SAVE_SALES_SITE_EDI_REPAIR
+PROCEDURE P_DMF0008_SAVE_SALES_SITE_EDI_REPAIR 
 (
@@ -1123,4 +1115,3 @@
 	-- LOG 용 변수 설정
---	v_program_name		VARCHAR2(150 CHAR) := 'DMF0008_SAVE_SALES_SITE_EDI_REPAIR';
-	v_program_name		VARCHAR2(150 CHAR) := $$PLSQL_UNIT || '.P_DMF0008_SAVE_SALES_SITE_EDI_REPAIR';   -- 2026.09.14 AJS
+	v_program_name		VARCHAR2(150 CHAR) := 'DMF0008_SAVE_SALES_SITE_EDI_REPAIR';
 	v_log_type				VARCHAR2(30 CHAR); -- START/END/ERROR/...
@@ -1497,3 +1488,3 @@
 
-PROCEDURE P_DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR
+PROCEDURE P_DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR 
 (
@@ -1564,4 +1555,3 @@
     v_mst_loop_cnt INTEGER := 0;
---    v_program_name VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
-    v_program_name VARCHAR2(150 CHAR) := $$PLSQL_UNIT || '.P_DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR';   -- 2026.09.14 AJS
+    v_program_name VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
     v_log_type VARCHAR2(30 CHAR);
@@ -1626,3 +1616,2 @@
   -- BEGIN TRY (Oracle: EXCEPTION 블록으로 대체)
-  SAVEPOINT SAVE_SALES_SITE_EDI;   -- 2026.09.14 AJS
 
@@ -1675,3 +1664,2 @@
           v_log_type := 'INVALID';
-          ROLLBACK TO SAVEPOINT SAVE_SALES_SITE_EDI;   -- 2026.09.14 AJS
           OPEN O_RC1 FOR
@@ -1685,3 +1673,2 @@
           v_log_type := 'INVALID';
-          ROLLBACK TO SAVEPOINT SAVE_SALES_SITE_EDI;   -- 2026.09.14 AJS
           OPEN O_RC2 FOR
@@ -1695,3 +1682,2 @@
           v_log_type := 'INVALID';
-          ROLLBACK TO SAVEPOINT SAVE_SALES_SITE_EDI;   -- 2026.09.14 AJS
           OPEN O_RC3 FOR
@@ -1705,3 +1691,2 @@
           v_log_type := 'INVALID';
-          ROLLBACK TO SAVEPOINT SAVE_SALES_SITE_EDI;   -- 2026.09.14 AJS
           OPEN O_RC4 FOR
@@ -1715,3 +1700,2 @@
           v_log_type := 'INVALID';
-          ROLLBACK TO SAVEPOINT SAVE_SALES_SITE_EDI;   -- 2026.09.14 AJS
           OPEN O_RC5 FOR
@@ -1852,4 +1836,2 @@
     COMMIT;
-    OPEN O_RESULT_CURSOR FOR   -- 2026.09.14 AJS
-    SELECT '1' AS RESULT_CODE, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS RESULT_MSG, 'SUCCESS' AS ERR_EVENT FROM DUAL;   -- 2026.09.14 AJS
 
@@ -1868,28 +1850,6 @@
 
-  IF NOT O_RC1%ISOPEN THEN   -- 2026.09.14 AJS
-      OPEN O_RC1 FOR SELECT NULL AS RESULT_MSG FROM DUAL WHERE 1 = 0;   -- 2026.09.14 AJS
-  END IF;   -- 2026.09.14 AJS
-  IF NOT O_RC2%ISOPEN THEN   -- 2026.09.14 AJS
-      OPEN O_RC2 FOR SELECT NULL AS RESULT_MSG FROM DUAL WHERE 1 = 0;   -- 2026.09.14 AJS
-  END IF;   -- 2026.09.14 AJS
-  IF NOT O_RC3%ISOPEN THEN   -- 2026.09.14 AJS
-      OPEN O_RC3 FOR SELECT NULL AS RESULT_MSG FROM DUAL WHERE 1 = 0;   -- 2026.09.14 AJS
-  END IF;   -- 2026.09.14 AJS
-  IF NOT O_RC4%ISOPEN THEN   -- 2026.09.14 AJS
-      OPEN O_RC4 FOR SELECT NULL AS RESULT_MSG FROM DUAL WHERE 1 = 0;   -- 2026.09.14 AJS
-  END IF;   -- 2026.09.14 AJS
-  IF NOT O_RC5%ISOPEN THEN   -- 2026.09.14 AJS
-      OPEN O_RC5 FOR SELECT NULL AS RESULT_MSG FROM DUAL WHERE 1 = 0;   -- 2026.09.14 AJS
-  END IF;   -- 2026.09.14 AJS
-  IF NOT O_RC6%ISOPEN THEN   -- 2026.09.14 AJS
-      OPEN O_RC6 FOR SELECT NULL AS RESULT_MSG FROM DUAL WHERE 1 = 0;   -- 2026.09.14 AJS
-  END IF;   -- 2026.09.14 AJS
-  IF NOT O_RESULT_CURSOR%ISOPEN THEN   -- 2026.09.14 AJS
-      OPEN O_RESULT_CURSOR FOR SELECT NULL AS RESULT_MSG FROM DUAL WHERE 1 = 0;   -- 2026.09.14 AJS
-  END IF;   -- 2026.09.14 AJS
-
   RETURN;
 
---    OPEN O_RESULT_CURSOR FOR
---    SELECT '1' AS RESULT_CODE, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS RESULT_MSG, 'SUCCESS' AS ERR_EVENT FROM DUAL;
+    OPEN O_RESULT_CURSOR FOR
+    SELECT '1' AS RESULT_CODE, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS RESULT_MSG, 'SUCCESS' AS ERR_EVENT FROM DUAL;
   EXCEPTION
@@ -1928,4 +1888,3 @@
     RAISE_APPLICATION_ERROR(-20001,
---        '[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE ||
-        '[' || v_program_name || '] SQLCODE=' || SQLCODE ||   -- 2026.09.14 AJS
+        '[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE ||
         ' / SQLERRM=' || SQLERRM ||
```
