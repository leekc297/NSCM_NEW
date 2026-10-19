# PKG_DMF0007 변경 diff

```diff
--- SPEC(before)
+++ SPEC(after)
@@ -90,2 +90,23 @@
 
+    -- [2026-09-15 UIPKG] standalone PR_DM_MST_CUSTOMER_FCST_HIST
+    PROCEDURE P_PR_DM_MST_CUSTOMER_FCST_HIST 
+(
+    P_DIVISION_ID            IN VARCHAR2
+  , P_PLAN_WEEK              IN VARCHAR2
+  , P_CUSTOMER_CODE          IN VARCHAR2
+  , P_SCM_SITE_ID            IN VARCHAR2
+  , P_SUMMARY_BUCKET_VALUE   IN VARCHAR2
+  , P_MEASURE_GROUP          IN VARCHAR2
+  , P_MEASURE                IN VARCHAR2
+  , P_VALID_YN               IN VARCHAR2
+  , P_CUSTOMER_PSI           IN VARCHAR2
+  , P_UPLOAD_UOM             IN VARCHAR2
+  , P_UPLOAD_BUCKET_TYPE     IN VARCHAR2
+  , P_SUMMARY_BUCKET_TYPE    IN VARCHAR2
+  , P_EDI_FCST_YN            IN VARCHAR2
+  , P_UPLOAD_USER_ID         IN VARCHAR2
+  , P_CREATED_BY             IN VARCHAR2
+  , P_UPDATE_BY              IN VARCHAR2
+);
+
 END PKG_DMF0007;
--- BODY(before)
+++ BODY(after)
@@ -1496,3 +1496,3 @@
     --------------------------------------------------------------------- history insert
-            SCM_MGR.PR_DM_MST_CUSTOMER_FCST_HIST(
+            P_PR_DM_MST_CUSTOMER_FCST_HIST(
                 v_division_id,
@@ -1855,2 +1855,185 @@
 
+    -- [2026-09-15 UIPKG] standalone PR_DM_MST_CUSTOMER_FCST_HIST 취합
+PROCEDURE P_PR_DM_MST_CUSTOMER_FCST_HIST 
+(
+    P_DIVISION_ID            IN VARCHAR2
+  , P_PLAN_WEEK              IN VARCHAR2
+  , P_CUSTOMER_CODE          IN VARCHAR2
+  , P_SCM_SITE_ID            IN VARCHAR2
+  , P_SUMMARY_BUCKET_VALUE   IN VARCHAR2
+  , P_MEASURE_GROUP          IN VARCHAR2
+  , P_MEASURE                IN VARCHAR2
+  , P_VALID_YN               IN VARCHAR2
+  , P_CUSTOMER_PSI           IN VARCHAR2
+  , P_UPLOAD_UOM             IN VARCHAR2
+  , P_UPLOAD_BUCKET_TYPE     IN VARCHAR2
+  , P_SUMMARY_BUCKET_TYPE    IN VARCHAR2
+  , P_EDI_FCST_YN            IN VARCHAR2
+  , P_UPLOAD_USER_ID         IN VARCHAR2
+  , P_CREATED_BY             IN VARCHAR2
+  , P_UPDATE_BY              IN VARCHAR2
+)
+/*
+ * Program ID   : PR_DM_MST_CUSTOMER_FCST_HIST
+ * Description  : Dynamic Query Register Batch ('SCM_ADM_DQ_PARAMETER' TABLE INSERT/UPDATE/DELETE)
+ * Program History
+ *===================================================================================================
+ *   Date       In Charge      Description
+ *===================================================================================================
+ * 2018. 03. 14    JHBAEK      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
+ * 2026.07.06      ZIONEX           [PJ202650304] NextSCM Migration
+ *
+ */
+IS
+    N_HISTORY_SEQ    INTEGER;
+
+    /* LOG 용 변수 설정 */
+    V_PROGRAM_NAME   VARCHAR2(150 CHAR) := 'PR_DM_MST_CUSTOMER_FCST_HIST';
+    V_LOG_TYPE       VARCHAR2(30 CHAR);        /* START/END/ERROR/... */
+    N_LOG_COUNT      NUMBER(10)         := 0;
+    V_LOG_MESSAGE    VARCHAR2(1000 CHAR);
+    V_DESCRIPTION    VARCHAR2(500 CHAR);
+    D_EVENT_DATE     DATE;
+BEGIN
+    /*
+       원본 MSSQL 세션 설정 SET TRANSACTION ISOLATION LEVEL READ COMMITTED /
+        아래 EXCEPTION 의 명시적 ROLLBACK 으로 대응).
+    */
+
+    /* 시작 LOG  (START) */
+    V_LOG_TYPE    := 'START';
+    V_LOG_MESSAGE := '########## Start of procedure ##########';
+    V_DESCRIPTION := '';
+    D_EVENT_DATE  := SYSDATE;
+    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
+
+    V_LOG_MESSAGE := NULL;      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
+    /* 시작 LOG  (END) */
+
+    /* 트랜잭션 (START) : 원본 BEGIN TRANSACTION PR_DM_MST_CUSTOMER_FCST_HIST -> Oracle 블록 끝 COMMIT / EXCEPTION 시작 ROLLBACK */
+    BEGIN
+
+        /* (1) HISTIRY INSERT */
+        SELECT SEQ1_DM_MST_CUSTOMER_FCST_H.NEXTVAL
+          INTO N_HISTORY_SEQ
+          FROM DUAL;
+
+        INSERT
+          INTO DM_MST_CUSTOMER_FCST_H
+             ( DIVISION_ID
+             , HISTORY_SEQ
+             , PLAN_WEEK
+             , CUSTOMER_CODE
+             , SCM_SITE_ID
+             , SUMMARY_BUCKET_VALUE
+             , MEASURE_GROUP
+             , MEASURE
+             , VALID_YN
+             , CUSTOMER_PSI
+             , UPLOAD_UOM
+             , UPLOAD_BUCKET_TYPE
+             , SUMMARY_BUCKET_TYPE
+             , EDI_FCST_YN
+             , UPLOAD_USER_ID
+             , CREATED_BY
+             , CREATION_DATE
+             , LAST_UPDATED_BY
+             , LAST_UPDATE_DATE
+             , ATTRIBUTE1
+             , ATTRIBUTE2
+             , ATTRIBUTE3
+             , ATTRIBUTE4
+             , ATTRIBUTE5
+             , ATTRIBUTE6
+             , ATTRIBUTE7
+             , ATTRIBUTE8
+             , ATTRIBUTE9
+             , ATTRIBUTE10 )
+        VALUES ( P_DIVISION_ID
+             , N_HISTORY_SEQ
+             , P_PLAN_WEEK
+             , P_CUSTOMER_CODE
+             , P_SCM_SITE_ID
+             , P_SUMMARY_BUCKET_VALUE
+             , P_MEASURE_GROUP
+             , P_MEASURE
+             , P_VALID_YN
+             , P_CUSTOMER_PSI
+             , P_UPLOAD_UOM
+             , P_UPLOAD_BUCKET_TYPE
+             , P_SUMMARY_BUCKET_TYPE
+             , P_EDI_FCST_YN
+             , P_UPLOAD_USER_ID
+             , P_CREATED_BY
+             , SYSDATE
+             , P_UPDATE_BY
+             , SYSDATE
+             , NULL
+             , NULL
+             , NULL
+             , NULL
+             , NULL
+             , NULL
+             , NULL
+             , NULL
+             , NULL
+             , NULL );
+        /* (1) */
+
+        /*           Oracle COMMIT 은 즉시 실커밋이라 상위(DMF0007_SAVE_CUST_FCST_DATA,PKG_DMF0007)의 ROLLBACK 을 무력화한다 -> 제거. 커밋은 호출자 책임. */
+
+    /*
+       원본 BEGIN CATCH : ROLLBACK 후 에러 LOG 만 기록(RAISERROR/THROW 없이 삼킴)
+    */
+    EXCEPTION
+        WHEN OTHERS THEN
+            /* 트랜잭션 (END) */
+            ROLLBACK;
+
+            /* ERROR LOG VALUE SAVE */
+            V_LOG_TYPE    := 'ERROR';
+            V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
+            V_DESCRIPTION := SUBSTR('ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 500);
+            D_EVENT_DATE  := SYSDATE;
+
+            /*-- 에러메시지 DISPLAY (원본 CATCH 결과셋 SELECT -> Oracle 암시적 결과셋 불가, 디버그 아티팩트로 주석 보존)
+            */
+
+            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE
+                               , JSON_OBJECT('p_division_id'          VALUE P_DIVISION_ID
+                               , 'p_plan_week'            VALUE P_PLAN_WEEK
+                               , 'p_customer_code'        VALUE P_CUSTOMER_CODE
+                               , 'p_scm_site_id'          VALUE P_SCM_SITE_ID
+                               , 'p_summary_bucket_value' VALUE P_SUMMARY_BUCKET_VALUE
+                               , 'p_measure_group'        VALUE P_MEASURE_GROUP
+                               , 'p_measure'              VALUE P_MEASURE
+                               , 'p_valid_yn'             VALUE P_VALID_YN
+                               , 'p_customer_psi'         VALUE P_CUSTOMER_PSI
+                               , 'p_upload_uom'           VALUE P_UPLOAD_UOM
+                               , 'p_upload_bucket_type'   VALUE P_UPLOAD_BUCKET_TYPE
+                               , 'p_summary_bucket_type'  VALUE P_SUMMARY_BUCKET_TYPE
+                               , 'p_edi_fcst_yn'          VALUE P_EDI_FCST_YN
+                               , 'p_upload_user_id'       VALUE P_UPLOAD_USER_ID
+                               , 'p_created_by'           VALUE P_CREATED_BY
+                               , 'p_update_by'            VALUE P_UPDATE_BY
+                                             RETURNING VARCHAR2(4000 CHAR))
+                               , SQLCODE, SQLERRM, DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
+    END;
+
+    /* 종료 LOG */
+    V_LOG_TYPE    := 'END';
+    V_LOG_MESSAGE := '########## END of procedure ##########';
+    V_DESCRIPTION := '';
+    D_EVENT_DATE  := SYSDATE;
+
+    /*
+       ERROR LOG DB INSERT (로직의 TRANSACTION 종료 이후 수행 : 충돌방지)
+       원본 주석처리 유지 : PR_SCM_SYS_LOG_BATCH_CALL_TRAN 은 TRANSACTION 충돌되므로 주석처리
+       PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
+    */
+
+    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
+
+END P_PR_DM_MST_CUSTOMER_FCST_HIST;
+
 END PKG_DMF0007;
```
