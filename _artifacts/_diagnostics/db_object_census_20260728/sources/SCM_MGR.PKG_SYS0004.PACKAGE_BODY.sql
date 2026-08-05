PACKAGE BODY           "PKG_SYS0004" IS

PROCEDURE P_SYS0004_GET_UI_CATEGORY_SETUP (
    p_program_id          IN  VARCHAR2,
    p_sheet_name          IN  VARCHAR2,
    p_column_name         IN  VARCHAR2,
    p_colmum_lavel_name   IN  VARCHAR2,
    p_default_flag        IN  VARCHAR2,
    p_valid_yn            IN  VARCHAR2,
    P_USER_ID             IN    VARCHAR2,
    P_MENU_ID             IN    VARCHAR2,
    o_rc1                OUT SYS_REFCURSOR,
    o_rc2                OUT SYS_REFCURSOR,
    O_RESULT_CURSOR      OUT SYS_REFCURSOR
)

/*
*===================================================================================================
* Program ID   : P_SYS0004_GET_UI_CATEGORY_SETUP
* Description  : UI Category
* Program History
*===================================================================================================
* Date          In Charge       Description
*===================================================================================================
* 2026.03.03   park.choyi       Next SCM
*===================================================================================================
*/

AS

    V_ROW_CNT  NUMBER := 0;

BEGIN


    OPEN o_rc1 FOR

    SELECT C.PROGRAM_ID
         , M.MNU_DESC AS PROGRAM_NAME
         , C.SHEET_NAME
         , C.COLUMN_NAME
         , C.COLUMN_LABEL_NAME
         , C.SORT_ORDER_NO
         , C.DATA_SORT_METHOD_CODE
         , C.SMALL_CLASS_LABEL_NAME
         , C.LARGE_CLASS_LABEL_NAME
         , C.FIXED_FLAG
         , C.COLUMN_WIDTH
         , C.CELL_CONTROL_OBJECT_TYPE_CODE
         , C.CELL_COMBO_DATA_TYPE
         , C.DATA_SCALE_NUMBER
         , C.DATA_MAX_LENGTH
         , C.HORIZONTAL_ALIGN_CODE
         , C.UPPERCASE_APPLY_FLAG
         , C.VISIBLE_FLAG
         , CASE WHEN C.DEFAULT_FLAG = 'NLL' THEN 'NULL' ELSE C.DEFAULT_FLAG END AS DEFAULT_FLAG
         , C.VALID_YN
         , C.USER_SELECTABLE_FLAG
         , C.INPUT_TP_CD
         , C.DIVISION_ID
         , C.ATTRIBUTE1
         , C.ATTRIBUTE2
         , C.ATTRIBUTE3
         , C.ATTRIBUTE4
         , C.ATTRIBUTE5
         , C.ATTRIBUTE6
         , C.ATTRIBUTE7
         , C.ATTRIBUTE8
         , C.ATTRIBUTE9
         , C.ATTRIBUTE10
         , C.CREATED_BY
         , C.CREATION_DATE
         , C.LAST_UPDATED_BY
         , C.LAST_UPDATE_DATE
      FROM SCM_MST_SHEET_COLUMNS C
      LEFT JOIN SCM_ADM_MNU_M M
             ON C.PROGRAM_ID = M.MNU_ID
     WHERE 1=1
       AND (p_program_id IS NULL OR UPPER(C.PROGRAM_ID) LIKE '%' || UPPER(p_program_id) || '%')
       AND (p_sheet_name IS NULL OR UPPER(C.SHEET_NAME) LIKE '%' || UPPER(p_sheet_name) || '%')
       AND (p_column_name IS NULL OR UPPER(C.COLUMN_NAME) LIKE '%' || UPPER(p_column_name) || '%')
       AND (p_colmum_lavel_name IS NULL OR UPPER(C.COLUMN_LABEL_NAME) LIKE '%' || UPPER(p_colmum_lavel_name) || '%')
       AND (p_valid_yn IS NULL OR p_valid_yn = 'ALL' OR C.VALID_YN = p_valid_yn)
       AND C.PROGRAM_ID IS NOT NULL
     ORDER BY C.PROGRAM_ID, C.SHEET_NAME, C.SORT_ORDER_NO;

    V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;

    OPEN o_rc2 FOR

    SELECT A.*
    FROM (
        SELECT C.PROGRAM_ID
             , C.SHEET_NAME
             , C.COLUMN_NAME
             , C.COLUMN_LABEL_NAME
             , C.SORT_ORDER_NO
             , C.SMALL_CLASS_LABEL_NAME
             , C.LARGE_CLASS_LABEL_NAME
             , CASE WHEN C.DEFAULT_FLAG = 'NLL' THEN 'NULL' ELSE C.DEFAULT_FLAG END AS DEFAULT_FLAG
             , C.USER_SELECTABLE_FLAG
             , C.INPUT_TP_CD
             , C.DIVISION_ID
             , C.VALID_YN
             , C.CREATED_BY
             , C.CREATION_DATE
             , C.LAST_UPDATED_BY
             , C.LAST_UPDATE_DATE
             , C.ATTRIBUTE1
             , C.ATTRIBUTE2
             , C.ATTRIBUTE3 AS MEASURE_COLOR
             , C.ATTRIBUTE4
             , C.ATTRIBUTE5
             , C.ATTRIBUTE6
             , B.MNU_DESC AS PROGRAM_NAME
        FROM SCM_MST_SHEET_MEASURE C
        LEFT JOIN scm_adm_mnu_m B
               ON C.PROGRAM_ID = B.MNU_ID
        WHERE 1=1
          AND (p_program_id IS NULL OR UPPER(C.PROGRAM_ID) LIKE '%' || UPPER(p_program_id) || '%')
          AND (p_sheet_name IS NULL OR UPPER(C.SHEET_NAME) LIKE '%' || UPPER(p_sheet_name) || '%')
          AND (p_column_name IS NULL OR UPPER(C.COLUMN_NAME) LIKE '%' || UPPER(p_column_name) || '%')
          AND (p_colmum_lavel_name IS NULL OR UPPER(C.COLUMN_LABEL_NAME) LIKE '%' || UPPER(p_colmum_lavel_name) || '%')
          AND (p_valid_yn IS NULL OR p_valid_yn = 'ALL' OR C.VALID_YN = p_valid_yn)
    ) A
    WHERE A.PROGRAM_ID IS NOT NULL
    ORDER BY A.PROGRAM_ID, A.SHEET_NAME, A.SORT_ORDER_NO;

    V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;

    OPEN O_RESULT_CURSOR FOR
         SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN

        RAISE_APPLICATION_ERROR(-20001,
        '[' || $$PLSQL_UNIT || '] SQLCODE=' || TO_CHAR(SQLCODE) ||
        ' / SQLERRM=' || SQLERRM ||
        ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
        ' / PARAMS=' || '-' );


END P_SYS0004_GET_UI_CATEGORY_SETUP;


PROCEDURE P_SYS0004_SAVE_UI_CATEGORY_SETUP_COLUMN(
    P_DATA      IN    CLOB,
    P_USER_ID   IN    VARCHAR2,

    O_RESULT_CURSOR      OUT SYS_REFCURSOR
	)

/*
*===================================================================================================
* Program ID   : P_SYS0004_SAVE_UI_CATEGORY_SETUP_COLUMN
* Description  : UI Category
* Program History
*===================================================================================================
* Date          In Charge       Description
*===================================================================================================
* 2026.03.03   park.choyi       Next SCM
*===================================================================================================
*/

  IS
		EX_BIZ_EX	EXCEPTION;
		V_ROW_CNT	NUMBER := 0;
		V_ERR_MSG 	VARCHAR2(4000);
	BEGIN

		MERGE INTO  SCM_MST_SHEET_COLUMNS TGT
			 USING  ( SELECT
                      V_PROGRAM_ID                    AS PROGRAM_ID
                    , V_SHEET_NAME                    AS SHEET_NAME
                    , V_COLUMN_NAME                   AS COLUMN_NAME
                    , V_COLUMN_LABEL_NAME             AS COLUMN_LABEL_NAME
                    , N_SORT_ORDER_NO                 AS SORT_ORDER_NO
                    , V_DATA_SORT_METHOD_CODE         AS DATA_SORT_METHOD_CODE
                    , V_SMALL_CLASS_LABEL_NAME        AS SMALL_CLASS_LABEL_NAME
                    , V_LARGE_CLASS_LABEL_NAME        AS LARGE_CLASS_LABEL_NAME
                    , V_FIXED_FLAG                    AS FIXED_FLAG
                    , N_COLUMN_WIDTH                  AS COLUMN_WIDTH
                    , V_CELL_CONTROL_OBJECT_TYPE_CODE AS CELL_CONTROL_OBJECT_TYPE_CODE
                    , V_CELL_COMBO_DATA_TYPE          AS CELL_COMBO_DATA_TYPE
                    , N_DATA_SCALE_NUMBER             AS DATA_SCALE_NUMBER
                    , N_DATA_MAX_LENGTH               AS DATA_MAX_LENGTH
                    , V_HORIZONTAL_ALIGN_CODE         AS HORIZONTAL_ALIGN_CODE
                    , V_UPPERCASE_APPLY_FLAG          AS UPPERCASE_APPLY_FLAG
                    , V_VISIBLE_FLAG                  AS VISIBLE_FLAG
                    , V_DIVISION_ID                   AS DIVISION_ID
                    , V_DEFAULT_FLAG                  AS DEFAULT_FLAG
                    , V_USER_SELECTABLE_FLAG          AS USER_SELECTABLE_FLAG
                    , V_INPUT_TP_CD                   AS INPUT_TP_CD
                    , NULLIF(TRIM(V_ATTRIBUTE1), '')  AS ATTRIBUTE1
                    , NULLIF(TRIM(V_ATTRIBUTE2), '')  AS ATTRIBUTE2
                    , NULLIF(TRIM(V_ATTRIBUTE3), '')  AS ATTRIBUTE3
                    , NULLIF(TRIM(V_ATTRIBUTE4), '')  AS ATTRIBUTE4
                    , NULLIF(TRIM(V_ATTRIBUTE5), '')  AS ATTRIBUTE5
                    , NVL(V_VALID_YN, 'Y')            AS VALID_YN
                    , P_USER_ID                          AS USER_ID
						FROM JSON_TABLE(P_DATA, '$[*]'
			    	 	COLUMNS (
                    V_PROGRAM_ID                    VARCHAR2(100 CHAR) PATH '$."PROGRAM_ID"'
                  , V_SHEET_NAME                    VARCHAR2(150 CHAR) PATH '$."SHEET_NAME"'
                  , V_COLUMN_NAME                   VARCHAR2(200 CHAR) PATH '$."COLUMN_NAME"'
                  , V_COLUMN_LABEL_NAME             VARCHAR2(150 CHAR) PATH '$."COLUMN_LABEL_NAME"'
                  , N_SORT_ORDER_NO                 NUMBER(10)         PATH '$."SORT_ORDER_NO"'
                  , V_DATA_SORT_METHOD_CODE         VARCHAR2(10 CHAR)  PATH '$."DATA_SORT_METHOD_CODE"'
                  , V_SMALL_CLASS_LABEL_NAME        VARCHAR2(150 CHAR) PATH '$."SMALL_CLASS_LABEL_NAME"'
                  , V_LARGE_CLASS_LABEL_NAME        VARCHAR2(150 CHAR) PATH '$."LARGE_CLASS_LABEL_NAME"'
                  , V_FIXED_FLAG                    VARCHAR2(1 CHAR)   PATH '$."FIXED_FLAG"'
                  , N_COLUMN_WIDTH                  NUMBER(10)         PATH '$."COLUMN_WIDTH"'
                  , V_CELL_CONTROL_OBJECT_TYPE_CODE VARCHAR2(50 CHAR)  PATH '$."CELL_CONTROL_OBJECT_TYPE_CODE"'
                  , V_CELL_COMBO_DATA_TYPE          VARCHAR2(50 CHAR)  PATH '$."CELL_COMBO_DATA_TYPE"'
                  , N_DATA_SCALE_NUMBER             NUMBER(10)         PATH '$."DATA_SCALE_NUMBER"'
                  , N_DATA_MAX_LENGTH               NUMBER(10)         PATH '$."DATA_MAX_LENGTH"'
                  , V_HORIZONTAL_ALIGN_CODE         VARCHAR2(50 CHAR)  PATH '$."HORIZONTAL_ALIGN_CODE"'
                  , V_UPPERCASE_APPLY_FLAG          VARCHAR2(1 CHAR)   PATH '$."UPPERCASE_APPLY_FLAG"'
                  , V_VISIBLE_FLAG                  VARCHAR2(1 CHAR)   PATH '$."VISIBLE_FLAG"'
                  , V_DIVISION_ID                   VARCHAR2(200 CHAR) PATH '$."DIVISION_ID"'
                  , V_DEFAULT_FLAG                  VARCHAR2(1 CHAR)   PATH '$."DEFAULT_FLAG"'
                  , V_USER_SELECTABLE_FLAG          VARCHAR2(1 CHAR)   PATH '$."USER_SELECTABLE_FLAG"'
                  , V_INPUT_TP_CD                   VARCHAR2(100 CHAR) PATH '$."INPUT_TP_CD"'
                  , V_ATTRIBUTE1                    VARCHAR2(400 CHAR) PATH '$."ATTRIBUTE1"'
                  , V_ATTRIBUTE2                    VARCHAR2(400 CHAR) PATH '$."ATTRIBUTE2"'
                  , V_ATTRIBUTE3                    VARCHAR2(400 CHAR) PATH '$."ATTRIBUTE3"'
                  , V_ATTRIBUTE4                    VARCHAR2(400 CHAR) PATH '$."ATTRIBUTE4"'
                  , V_ATTRIBUTE5                    VARCHAR2(400 CHAR) PATH '$."ATTRIBUTE5"'
                  , V_VALID_YN                      VARCHAR2(1 CHAR)   PATH '$."VALID_YN"'

			    	 	))) SRC
		        ON  (TGT.PROGRAM_ID = SRC.PROGRAM_ID
		             AND TGT.SHEET_NAME = SRC.SHEET_NAME
		             AND TGT.COLUMN_NAME = SRC.COLUMN_NAME)

		WHEN MATCHED THEN
	  			UPDATE SET
            TGT.COLUMN_LABEL_NAME             = SRC.COLUMN_LABEL_NAME
          , TGT.SORT_ORDER_NO                 = SRC.SORT_ORDER_NO
          , TGT.DATA_SORT_METHOD_CODE         = SRC.DATA_SORT_METHOD_CODE
          , TGT.SMALL_CLASS_LABEL_NAME        = SRC.SMALL_CLASS_LABEL_NAME
          , TGT.LARGE_CLASS_LABEL_NAME        = SRC.LARGE_CLASS_LABEL_NAME
          , TGT.FIXED_FLAG                    = SRC.FIXED_FLAG
          , TGT.COLUMN_WIDTH                  = SRC.COLUMN_WIDTH
          , TGT.CELL_CONTROL_OBJECT_TYPE_CODE = SRC.CELL_CONTROL_OBJECT_TYPE_CODE
          , TGT.CELL_COMBO_DATA_TYPE          = SRC.CELL_COMBO_DATA_TYPE
          , TGT.DATA_SCALE_NUMBER             = SRC.DATA_SCALE_NUMBER
          , TGT.DATA_MAX_LENGTH               = SRC.DATA_MAX_LENGTH
          , TGT.HORIZONTAL_ALIGN_CODE         = SRC.HORIZONTAL_ALIGN_CODE
          , TGT.UPPERCASE_APPLY_FLAG          = SRC.UPPERCASE_APPLY_FLAG
          , TGT.VISIBLE_FLAG                  = SRC.VISIBLE_FLAG
          , TGT.DIVISION_ID                   = SRC.DIVISION_ID
          , TGT.DEFAULT_FLAG                  = SRC.DEFAULT_FLAG
          , TGT.USER_SELECTABLE_FLAG          = SRC.USER_SELECTABLE_FLAG
          , TGT.INPUT_TP_CD                   = SRC.INPUT_TP_CD
          , TGT.ATTRIBUTE1                    = SRC.ATTRIBUTE1
          , TGT.ATTRIBUTE2                    = SRC.ATTRIBUTE2
          , TGT.ATTRIBUTE3                    = SRC.ATTRIBUTE3
          , TGT.ATTRIBUTE4                    = SRC.ATTRIBUTE4
          , TGT.ATTRIBUTE5                    = SRC.ATTRIBUTE5
          , TGT.VALID_YN                      = SRC.VALID_YN
          , TGT.LAST_UPDATED_BY               = SRC.USER_ID
          , TGT.LAST_UPDATE_DATE              = SYSDATE
		WHEN NOT MATCHED THEN
      INSERT (
            PROGRAM_ID, SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO
          , DATA_SORT_METHOD_CODE, SMALL_CLASS_LABEL_NAME, LARGE_CLASS_LABEL_NAME
          , FIXED_FLAG, COLUMN_WIDTH, CELL_CONTROL_OBJECT_TYPE_CODE, CELL_COMBO_DATA_TYPE
          , DATA_SCALE_NUMBER, DATA_MAX_LENGTH, HORIZONTAL_ALIGN_CODE, UPPERCASE_APPLY_FLAG
          , VISIBLE_FLAG, DIVISION_ID, DEFAULT_FLAG, USER_SELECTABLE_FLAG
          , INPUT_TP_CD, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
          , VALID_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
      )
      VALUES (
            SRC.PROGRAM_ID, SRC.SHEET_NAME, SRC.COLUMN_NAME, SRC.COLUMN_LABEL_NAME, SRC.SORT_ORDER_NO
          , SRC.DATA_SORT_METHOD_CODE, SRC.SMALL_CLASS_LABEL_NAME, SRC.LARGE_CLASS_LABEL_NAME
          , SRC.FIXED_FLAG, SRC.COLUMN_WIDTH, SRC.CELL_CONTROL_OBJECT_TYPE_CODE, SRC.CELL_COMBO_DATA_TYPE
          , SRC.DATA_SCALE_NUMBER, SRC.DATA_MAX_LENGTH, SRC.HORIZONTAL_ALIGN_CODE, SRC.UPPERCASE_APPLY_FLAG
          , SRC.VISIBLE_FLAG, SRC.DIVISION_ID, SRC.DEFAULT_FLAG, SRC.USER_SELECTABLE_FLAG
          , SRC.INPUT_TP_CD, SRC.ATTRIBUTE1, SRC.ATTRIBUTE2, SRC.ATTRIBUTE3, SRC.ATTRIBUTE4, SRC.ATTRIBUTE5
          , SRC.VALID_YN, SRC.USER_ID, SYSDATE, SRC.USER_ID, SYSDATE
      );

    V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;

    OPEN O_RESULT_CURSOR FOR
         SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN

        RAISE_APPLICATION_ERROR(-20001,
        '[' || $$PLSQL_UNIT || '] SQLCODE=' || TO_CHAR(SQLCODE) ||
        ' / SQLERRM=' || SQLERRM ||
        ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
        ' / PARAMS=' || '-' );

END P_SYS0004_SAVE_UI_CATEGORY_SETUP_COLUMN;

PROCEDURE P_SYS0004_SAVE_UI_CATEGORY_SETUP_MEASURE(
    P_DATA      IN    CLOB,
    P_USER_ID   IN    VARCHAR2,

    O_RESULT_CURSOR      OUT SYS_REFCURSOR
  )

/*
*===================================================================================================
* Program ID   : P_SYS0004_SAVE_UI_CATEGORY_SETUP_MEASURE
* Description  : UI Category
* Program History
*===================================================================================================
* Date          In Charge       Description
*===================================================================================================
* 2026.03.35   park.choyi       Next SCM
*===================================================================================================
*/

  IS
    EX_BIZ_EX EXCEPTION;
    V_ROW_CNT NUMBER := 0;
    V_ERR_MSG   VARCHAR2(4000);
  BEGIN

    MERGE INTO SCM_MST_SHEET_MEASURE A
  USING (
      SELECT
            JT.PROGRAM_ID
          , JT.SHEET_NAME
          , JT.COLUMN_NAME
          , JT.COLUMN_LABEL_NAME
          , JT.SORT_ORDER_NO
          , JT.SMALL_CLASS_LABEL_NAME
          , JT.LARGE_CLASS_LABEL_NAME
          , JT.DEFAULT_FLAG
          , JT.USER_SELECTABLE_FLAG
          , JT.DIVISION_ID
          , JT.VALID_YN
          , JT.MEASURE_COLOR
          , JT.ATTRIBUTE1
          , JT.ATTRIBUTE2
          , JT.ATTRIBUTE4
          , JT.ATTRIBUTE5
          , JT.ATTRIBUTE6
          , JT.ATTRIBUTE7
          , JT.ATTRIBUTE8
          , JT.ATTRIBUTE9
          , JT.ATTRIBUTE10
          , JT.INPUT_TP_CD
          , P_USER_ID AS USER_ID
      FROM JSON_TABLE(
          P_DATA,
          '$[*]'
          COLUMNS (
                PROGRAM_ID              VARCHAR2(100) PATH '$.PROGRAM_ID'
              , SHEET_NAME              VARCHAR2(100) PATH '$.SHEET_NAME'
              , COLUMN_NAME             VARCHAR2(100) PATH '$.COLUMN_NAME'
              , COLUMN_LABEL_NAME       VARCHAR2(400) PATH '$.COLUMN_LABEL_NAME'
              , SORT_ORDER_NO           NUMBER        PATH '$.SORT_ORDER_NO'
              , SMALL_CLASS_LABEL_NAME  VARCHAR2(400) PATH '$.SMALL_CLASS_LABEL_NAME'
              , LARGE_CLASS_LABEL_NAME  VARCHAR2(400) PATH '$.LARGE_CLASS_LABEL_NAME'
              , DEFAULT_FLAG            VARCHAR2(1)   PATH '$.DEFAULT_FLAG'
              , USER_SELECTABLE_FLAG    VARCHAR2(1)   PATH '$.USER_SELECTABLE_FLAG'
              , DIVISION_ID             VARCHAR2(50)  PATH '$.DIVISION_ID'
              , VALID_YN                VARCHAR2(1)   PATH '$.VALID_YN'
              , MEASURE_COLOR           VARCHAR2(200) PATH '$.MEASURE_COLOR'
              , ATTRIBUTE1              VARCHAR2(4000) PATH '$.ATTRIBUTE1'
              , ATTRIBUTE2              VARCHAR2(4000) PATH '$.ATTRIBUTE2'
              , ATTRIBUTE4              VARCHAR2(4000) PATH '$.ATTRIBUTE4'
              , ATTRIBUTE5              VARCHAR2(4000) PATH '$.ATTRIBUTE5'
              , ATTRIBUTE6              VARCHAR2(4000) PATH '$.ATTRIBUTE6'
              , ATTRIBUTE7              VARCHAR2(4000) PATH '$.ATTRIBUTE7'
              , ATTRIBUTE8              VARCHAR2(4000) PATH '$.ATTRIBUTE8'
              , ATTRIBUTE9              VARCHAR2(4000) PATH '$.ATTRIBUTE9'
              , ATTRIBUTE10             VARCHAR2(4000) PATH '$.ATTRIBUTE10'
              , INPUT_TP_CD           VARCHAR2(100 CHAR) PATH '$."INPUT_TP_CD"'
          )
      ) JT
  ) B
  ON (
         A.PROGRAM_ID  = B.PROGRAM_ID
     AND A.SHEET_NAME  = B.SHEET_NAME
     AND A.COLUMN_NAME = B.COLUMN_NAME
  )
  WHEN MATCHED THEN
      UPDATE SET
            A.COLUMN_LABEL_NAME      = B.COLUMN_LABEL_NAME
          , A.SORT_ORDER_NO          = B.SORT_ORDER_NO
          , A.SMALL_CLASS_LABEL_NAME = B.SMALL_CLASS_LABEL_NAME
          , A.LARGE_CLASS_LABEL_NAME = B.LARGE_CLASS_LABEL_NAME
          , A.DEFAULT_FLAG           = B.DEFAULT_FLAG
          , A.USER_SELECTABLE_FLAG   = B.USER_SELECTABLE_FLAG
          , A.DIVISION_ID            = B.DIVISION_ID
          , A.VALID_YN               = B.VALID_YN
          , A.LAST_UPDATED_BY        = B.USER_ID
          , A.LAST_UPDATE_DATE       = SYSDATE
          , A.ATTRIBUTE3             = B.MEASURE_COLOR
          , A.ATTRIBUTE1             = B.ATTRIBUTE1
          , A.ATTRIBUTE2             = B.ATTRIBUTE2
          , A.ATTRIBUTE4             = B.ATTRIBUTE4
          , A.ATTRIBUTE5             = B.ATTRIBUTE5
          , A.ATTRIBUTE6             = B.ATTRIBUTE6
          , A.ATTRIBUTE7             = B.ATTRIBUTE7
          , A.ATTRIBUTE8             = B.ATTRIBUTE8
          , A.ATTRIBUTE9             = B.ATTRIBUTE9
          , A.ATTRIBUTE10            = B.ATTRIBUTE10
          , A.INPUT_TP_CD            = B.INPUT_TP_CD
  WHEN NOT MATCHED THEN
      INSERT (
            PROGRAM_ID, SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO
          , SMALL_CLASS_LABEL_NAME, LARGE_CLASS_LABEL_NAME, DEFAULT_FLAG, USER_SELECTABLE_FLAG
          , DIVISION_ID, VALID_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
          , ATTRIBUTE3, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7
          , ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, INPUT_TP_CD
      )
      VALUES (
            B.PROGRAM_ID, B.SHEET_NAME, B.COLUMN_NAME, B.COLUMN_LABEL_NAME, B.SORT_ORDER_NO
          , B.SMALL_CLASS_LABEL_NAME, B.LARGE_CLASS_LABEL_NAME, B.DEFAULT_FLAG, B.USER_SELECTABLE_FLAG
          , B.DIVISION_ID, B.VALID_YN, B.USER_ID, SYSDATE, B.USER_ID, SYSDATE
          , B.MEASURE_COLOR, B.ATTRIBUTE1, B.ATTRIBUTE2, B.ATTRIBUTE4, B.ATTRIBUTE5, B.ATTRIBUTE6, B.ATTRIBUTE7
          , B.ATTRIBUTE8, B.ATTRIBUTE9, B.ATTRIBUTE10, B.INPUT_TP_CD
      );

    V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;

    OPEN O_RESULT_CURSOR FOR
         SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN

        RAISE_APPLICATION_ERROR(-20001,
        '[' || $$PLSQL_UNIT || '] SQLCODE=' || TO_CHAR(SQLCODE) ||
        ' / SQLERRM=' || SQLERRM ||
        ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
        ' / PARAMS=' || '-' );


END P_SYS0004_SAVE_UI_CATEGORY_SETUP_MEASURE;


END PKG_SYS0004;