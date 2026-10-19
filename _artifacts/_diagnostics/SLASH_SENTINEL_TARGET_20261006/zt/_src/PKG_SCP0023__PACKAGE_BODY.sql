PACKAGE BODY PKG_SCP0023 IS

  /* ------------------------------------------------------------------
     리스트 파라미터 → ',v1,v2,' (INSTR 매칭용). AS-IS dbo.String_Split 대응.
     GET 의 p_plant_site_id/p_item_id 는 AS-IS 가 콤마(,) 분할 → 콤마 정규화.
     ------------------------------------------------------------------ */
  FUNCTION F_LIST_PARAM(P_VAL IN VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN ',' || UPPER(REGEXP_REPLACE(TRIM(P_VAL), ' *, *', ',')) || ',';
  END F_LIST_PARAM;

  /* ------------------------------------------------------------------
     이력 적재 — AS-IS dbo.PR_SCP_MST_OUTSOURCING_CAPA_HIST 이관.
     전제: SCP_MST_OUTSOURCING_CAPA_H + SEQ1_SCP_MST_OUTSOURCING_CAPA_H (prereq.sql).
     ------------------------------------------------------------------ */
  PROCEDURE P_SCP_MST_OUTSOURCING_CAPA_HIST
  (
      P_DIVISION_ID     IN VARCHAR2
    , P_PLANT_SITE_ID   IN VARCHAR2
    , P_ITEM_ID         IN VARCHAR2
    , P_DAILY_CAPA_QTY  IN NUMBER
    , P_VALID_YN        IN VARCHAR2
    , P_CREATED_BY      IN VARCHAR2
    , P_CREATION_DATE   IN DATE
    , P_LAST_UPDATED_BY IN VARCHAR2
  ) IS
  BEGIN
    INSERT INTO SCP_MST_OUTSOURCING_CAPA_H
        ( HISTORY_SEQ, DIVISION_ID, PLANT_SITE_ID, ITEM_ID, DAILY_CAPA_QTY, VALID_YN
        , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, HISTORY_CREATION_DATE )
    VALUES
        ( SEQ1_SCP_MST_OUTSOURCING_CAPA_H.NEXTVAL, P_DIVISION_ID, P_PLANT_SITE_ID, P_ITEM_ID
        , P_DAILY_CAPA_QTY, P_VALID_YN, P_CREATED_BY, P_CREATION_DATE, P_LAST_UPDATED_BY
        , SYSDATE, SYSDATE );
  END P_SCP_MST_OUTSOURCING_CAPA_HIST;

  /* ==================================================================
     조회 — AS-IS SCP0023_GET_OUTSOURCING_CAPA
     ================================================================== */
  PROCEDURE P_SCP0023_GET_OUTSOURCING_CAPA
  (
      P_DIVISION_ID     IN  VARCHAR2
    , P_PLANT_SITE_ID   IN  VARCHAR2
    , P_ITEM_ID         IN  VARCHAR2
    , P_NICK_NAME       IN  VARCHAR2
    , P_VALID           IN  VARCHAR2
    , P_DEBUG_MODE      IN  VARCHAR2
    , O_RC1             OUT SYS_REFCURSOR
    , O_RESULT_CURSOR   OUT SYS_REFCURSOR
  ) IS
    V_PLANT_ALL   VARCHAR2(1 CHAR);
    V_PLANT_LIST  VARCHAR2(32767 CHAR);
    V_ITEM_ALL    VARCHAR2(1 CHAR);
    V_ITEM_LIST   VARCHAR2(32767 CHAR);
    V_VALID_ALL   VARCHAR2(1 CHAR);
    V_VALID_LIST  VARCHAR2(32767 CHAR);
    V_NICK        VARCHAR2(4000 CHAR);
    V_ERR_MSG     VARCHAR2(4000 CHAR);
  BEGIN
    /* AS-IS isnull(@x,'')='' / 'ALL' 미지정 처리 */
    V_PLANT_ALL  := CASE WHEN TRIM(P_PLANT_SITE_ID) IS NULL OR UPPER(TRIM(P_PLANT_SITE_ID)) = 'ALL' THEN 'Y' ELSE 'N' END;
    V_PLANT_LIST := F_LIST_PARAM(P_PLANT_SITE_ID);
    V_ITEM_ALL   := CASE WHEN TRIM(P_ITEM_ID) IS NULL OR UPPER(TRIM(P_ITEM_ID)) = 'ALL' THEN 'Y' ELSE 'N' END;
    V_ITEM_LIST  := F_LIST_PARAM(P_ITEM_ID);
    V_VALID_ALL  := CASE WHEN TRIM(P_VALID) IS NULL OR UPPER(TRIM(P_VALID)) = 'ALL' THEN 'Y' ELSE 'N' END;
    V_VALID_LIST := F_LIST_PARAM(P_VALID);
    V_NICK       := CASE WHEN TRIM(P_NICK_NAME) IS NULL OR UPPER(TRIM(P_NICK_NAME)) = 'ALL' THEN NULL ELSE TRIM(P_NICK_NAME) END;

    OPEN O_RC1 FOR
    WITH NICKITEM AS (
      /* AS-IS #TblDynamicPivot_SCP0023_NICKITEM — nick_name LIKE '...%' 로 item 도출 */
      SELECT DISTINCT s.ITEM_ID
        FROM SCM_MST_ITEM_SN s
       WHERE s.NICK_NAME IS NOT NULL
         AND V_NICK IS NOT NULL
         AND s.NICK_NAME LIKE V_NICK || '%'
    ),
    PLANTFILT AS (
      /* AS-IS #TblDynamicPivot_SCP0023_PLANT — 검색 item/nick 을 가진 OSP 플랜트 */
      SELECT DISTINCT a.scm_site_id
        FROM SCM_MST_SITE a
        JOIN SCM_MST_VENDOR b ON a.plant_id = b.vendor_code
        JOIN SCM_MST_SITE_ITEM_PRIORITY c ON a.division_id = c.DIVISION_ID AND a.scm_site_id = c.plant_site_id
       WHERE a.osp_yn = 'Y' AND a.valid_yn = 'Y' AND c.valid_yn = 'Y'
         AND ( (V_ITEM_ALL = 'N' AND INSTR(V_ITEM_LIST, ',' || UPPER(c.item_id) || ',') > 0)
               OR c.item_id IN (SELECT ITEM_ID FROM NICKITEM) )
    )
    -- 결과 컬럼 별칭은 소문자로 강제(따옴표)한다 — SCP0023 은 FE/SHEET_COLUMNS/procedures.d.ts/SAVE 가
    --   전부 소문자 바인딩이라, 따옴표 없는 별칭이 Oracle 기본 대문자로 접혀 그리드가 값을 못 읽고
    --   빈 셀로 표시되는 문제(2026-09-22 gap-resolve 실측)를 막는다.
    SELECT  t.division_id AS "division_id"
          , t.scm_site_id AS "scm_site_id"
          , t.vendor_code AS "vendor_code"
          , (SELECT b.vendor_name FROM SCM_MST_VENDOR b WHERE b.vendor_code = t.vendor_code AND ROWNUM <= 1) AS "vendor_name"
          , (CASE WHEN t.item_id = '-' THEN 'Total' ELSE t.item_id END) AS "item_id"
          , (CASE WHEN t.item_id = '-' THEN ''
                  ELSE NVL((SELECT NVL(NULLIF(x.NICK_NAME, ''), '-') FROM SCM_MST_ITEM_SN x
                             WHERE x.ITEM_ID = t.item_id AND ROWNUM <= 1), '-') END) AS "nick_name"
          , t.daily_capa_qty AS "daily_capa_qty"
          , (CASE WHEN t.daily_capa_qty IS NULL THEN '1' ELSE '2' END) AS "capa_order"
          , t.valid_yn AS "valid_yn"
          , t.created_by AS "created_by"
          , TO_CHAR(t.creation_date, 'YYYY-MM-DD HH24:MI:SS') AS "creation_date"
          , t.last_updated_by AS "last_updated_by"
          , TO_CHAR(t.last_update_date, 'YYYY-MM-DD HH24:MI:SS') AS "last_update_date"
      FROM (
            /* (1) outsourcing 모델 조회 */
            SELECT DISTINCT a.division_id, a.scm_site_id, b.vendor_code, c.item_id
                 , d.daily_capa_qty, d.valid_yn, d.created_by, d.creation_date, d.last_updated_by, d.last_update_date
              FROM SCM_MST_SITE a
              JOIN SCM_MST_VENDOR b ON a.plant_id = b.vendor_code
              JOIN SCM_MST_SITE_ITEM_PRIORITY c ON a.division_id = c.DIVISION_ID AND a.scm_site_id = c.plant_site_id
              LEFT OUTER JOIN SCP_MST_OUTSOURCING_CAPA d
                   ON a.division_id = d.division_id AND a.scm_site_id = d.plant_site_id AND c.item_id = d.item_id
             WHERE a.osp_yn = 'Y' AND a.valid_yn = 'Y' AND c.valid_yn = 'Y'
               AND NVL(a.ATTRIBUTE1, 'N') <> 'Y'          /* ESS 외주 Packer Line 지정 Plant 제외(화면설계서 v4) */
            UNION
            /* (2) 업체 Total 표시용 '-' 행 */
            SELECT DISTINCT a.division_id, a.scm_site_id, b.vendor_code, d.item_id
                 , d.daily_capa_qty, d.valid_yn, d.created_by, d.creation_date, d.last_updated_by, d.last_update_date
              FROM SCM_MST_SITE a
              JOIN SCM_MST_VENDOR b ON a.plant_id = b.vendor_code
              JOIN SCM_MST_SITE_ITEM_PRIORITY c ON a.division_id = c.DIVISION_ID AND a.scm_site_id = c.plant_site_id
              LEFT OUTER JOIN SCP_MST_OUTSOURCING_CAPA d
                   ON a.division_id = d.division_id AND a.scm_site_id = d.plant_site_id
             WHERE a.osp_yn = 'Y' AND a.valid_yn = 'Y' AND c.valid_yn = 'Y'
               AND d.item_id = '-'
               AND NVL(a.ATTRIBUTE1, 'N') <> 'Y'
            UNION
            /* (3) SCP_MST_OUTSOURCING_CAPA 에 '-' 미등록이라 등록 필요한 플랜트 */
            SELECT DISTINCT a.division_id, a.scm_site_id, b.vendor_code, '-'
                 , CAST(NULL AS NUMBER), CAST(NULL AS VARCHAR2(4)), CAST(NULL AS VARCHAR2(600))
                 , CAST(NULL AS DATE), CAST(NULL AS VARCHAR2(600)), CAST(NULL AS DATE)
              FROM SCM_MST_SITE a
              JOIN SCM_MST_VENDOR b ON a.plant_id = b.vendor_code
              JOIN SCM_MST_SITE_ITEM_PRIORITY c ON a.division_id = c.DIVISION_ID AND a.scm_site_id = c.plant_site_id
             WHERE a.osp_yn = 'Y' AND a.valid_yn = 'Y' AND c.valid_yn = 'Y'
               AND NOT EXISTS (SELECT 'X' FROM SCP_MST_OUTSOURCING_CAPA d
                                WHERE a.division_id = d.division_id AND a.scm_site_id = d.plant_site_id AND d.item_id = '-')
               AND NVL(a.ATTRIBUTE1, 'N') <> 'Y'
           ) t
     WHERE ( UPPER(P_DIVISION_ID) = 'ALL'
             OR t.division_id = UPPER(P_DIVISION_ID) )   /* 2026.09.24 ZIONEX 조회조건 ALL 추가 */
       AND (V_PLANT_ALL = 'Y' OR INSTR(V_PLANT_LIST, ',' || UPPER(t.scm_site_id) || ',') > 0)
       AND (V_VALID_ALL = 'Y' OR (t.valid_yn IS NOT NULL AND INSTR(V_VALID_LIST, ',' || UPPER(t.valid_yn) || ',') > 0))
       AND (   (V_ITEM_ALL = 'Y' AND V_NICK IS NULL)
            OR (V_ITEM_ALL = 'N' AND INSTR(V_ITEM_LIST, ',' || UPPER(t.item_id) || ',') > 0)
            OR t.item_id IN (SELECT ITEM_ID FROM NICKITEM)
            OR (t.scm_site_id IN (SELECT scm_site_id FROM PLANTFILT) AND t.item_id = '-')
           )
     ORDER BY "capa_order", t.division_id, t.scm_site_id, t.vendor_code, t.item_id;

    OPEN O_RESULT_CURSOR FOR
      SELECT '0' AS CODE, 'SUCCESS' AS MSG, '0' AS EVENT FROM DUAL;

  EXCEPTION
    WHEN OTHERS THEN
      V_ERR_MSG := SUBSTR(SQLERRM, 1, 4000);        /* SQLERRM 은 SQL 문에서 직접 못 씀 → 변수 경유 */
      OPEN O_RESULT_CURSOR FOR
        SELECT '-1' AS CODE, V_ERR_MSG AS MSG, '0' AS EVENT FROM DUAL;
      RAISE;
  END P_SCP0023_GET_OUTSOURCING_CAPA;

  /* ==================================================================
     저장 — AS-IS SCP0023_SAVE_OUTSOURCING_CAPA (MERGE + 이력)
       - AS-IS '^' bulk → NSCM 표준 CLOB + JSON_TABLE
       - TOTAL → '-' 치환, valid_yn 은 AS-IS 처럼 'Y' 고정 저장
       - created_by/last_updated_by 는 스칼라(P_USER_ID) — '^' 오염 없음(설계 03 §4.2 함정)
       - Delete 는 AS-IS NO-OP(화면 미노출) — D 마킹 무시(MERGE 만)
     ================================================================== */
  PROCEDURE P_SCP0023_SAVE_OUTSOURCING_CAPA
  (
      P_DATA            IN  CLOB
    , P_USER_ID         IN  VARCHAR2
    , O_RESULT_CURSOR   OUT SYS_REFCURSOR
  ) IS
    V_CNT     PLS_INTEGER := 0;
    V_ITEM    VARCHAR2(200 CHAR);
    V_QTY     NUMBER;
    V_ERR_MSG VARCHAR2(4000 CHAR);
  BEGIN
    SAVEPOINT SP_SCP0023_SAVE;

    FOR R IN (
      SELECT A.CRUD_TYPE, A.DIVISION_ID, A.SCM_SITE_ID, A.ITEM_ID, A.DAILY_CAPA_QTY, A.VALID_YN
        FROM JSON_TABLE(P_DATA, '$[*]'
               COLUMNS ( RN             FOR ORDINALITY
                       , CRUD_TYPE      VARCHAR2(10 CHAR)   PATH '$.CRUD_TYPE'      NULL ON EMPTY
--                       , DIVISION_ID    VARCHAR2(4000 CHAR) PATH '$.DIVISION_ID'    NULL ON EMPTY   --  2026.10.06 AJS
                       , DIVISION_ID    VARCHAR2(4000 CHAR) PATH '$.division_id'    NULL ON EMPTY   --  2026.10.06 AJS
--                       , SCM_SITE_ID    VARCHAR2(4000 CHAR) PATH '$.SCM_SITE_ID'    NULL ON EMPTY   --  2026.10.06 AJS
                       , SCM_SITE_ID    VARCHAR2(4000 CHAR) PATH '$.scm_site_id'    NULL ON EMPTY   --  2026.10.06 AJS
--                       , ITEM_ID        VARCHAR2(4000 CHAR) PATH '$.ITEM_ID'        NULL ON EMPTY   --  2026.10.06 AJS
                       , ITEM_ID        VARCHAR2(4000 CHAR) PATH '$.item_id'        NULL ON EMPTY   --  2026.10.06 AJS
--                       , DAILY_CAPA_QTY VARCHAR2(4000 CHAR) PATH '$.DAILY_CAPA_QTY' NULL ON EMPTY   --  2026.10.06 AJS
                       , DAILY_CAPA_QTY VARCHAR2(4000 CHAR) PATH '$.daily_capa_qty' NULL ON EMPTY   --  2026.10.06 AJS
--                       , VALID_YN       VARCHAR2(4000 CHAR) PATH '$.VALID_YN'       NULL ON EMPTY   --  2026.10.06 AJS
                       , VALID_YN       VARCHAR2(4000 CHAR) PATH '$.valid_yn'       NULL ON EMPTY   --  2026.10.06 AJS
                       )) A
       WHERE A.CRUD_TYPE IN ('I', 'M')            /* Delete = AS-IS NO-OP → 제외 */
       ORDER BY A.RN
    ) LOOP
      V_CNT := V_CNT + 1;

      /* AS-IS: Total 표시값 'TOTAL' → 저장 시 '-' 로 치환 */
      V_ITEM := CASE WHEN UPPER(TRIM(R.ITEM_ID)) = 'TOTAL' THEN '-' ELSE R.ITEM_ID END;
      V_QTY  := TO_NUMBER(R.DAILY_CAPA_QTY);

      /* 이력 적재 (전제: _H 테이블·시퀀스) */
      P_SCP_MST_OUTSOURCING_CAPA_HIST(
          R.DIVISION_ID, R.SCM_SITE_ID, V_ITEM, V_QTY, 'Y'
        , P_USER_ID, SYSDATE, P_USER_ID);

      /* 마스터 MERGE (AS-IS: valid_yn 항상 'Y', 감사키 스칼라) */
      MERGE INTO SCP_MST_OUTSOURCING_CAPA A
      USING (SELECT R.DIVISION_ID AS division_id, R.SCM_SITE_ID AS plant_site_id, V_ITEM AS item_id FROM DUAL) B
         ON (A.division_id = B.division_id AND A.plant_site_id = B.plant_site_id AND A.item_id = B.item_id)
      WHEN MATCHED THEN
        UPDATE SET A.daily_capa_qty   = V_QTY
                 , A.valid_yn         = 'Y'
                 , A.last_updated_by  = P_USER_ID
                 , A.last_update_date = SYSDATE
      WHEN NOT MATCHED THEN
        INSERT (DIVISION_ID, PLANT_SITE_ID, ITEM_ID, DAILY_CAPA_QTY, VALID_YN
              , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (R.DIVISION_ID, R.SCM_SITE_ID, V_ITEM, V_QTY, 'Y'
              , P_USER_ID, SYSDATE, P_USER_ID, SYSDATE);
    END LOOP;

    COMMIT;

    OPEN O_RESULT_CURSOR FOR
      SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_CNT) AS EVENT FROM DUAL;

  EXCEPTION
    WHEN OTHERS THEN
      V_ERR_MSG := SUBSTR(SQLERRM, 1, 4000);        /* SQLERRM 은 SQL 문에서 직접 못 씀 → 변수 경유 */
      ROLLBACK TO SAVEPOINT SP_SCP0023_SAVE;
      OPEN O_RESULT_CURSOR FOR
        SELECT '-1' AS CODE, V_ERR_MSG AS MSG, '0' AS EVENT FROM DUAL;
  END P_SCP0023_SAVE_OUTSOURCING_CAPA;

END PKG_SCP0023;