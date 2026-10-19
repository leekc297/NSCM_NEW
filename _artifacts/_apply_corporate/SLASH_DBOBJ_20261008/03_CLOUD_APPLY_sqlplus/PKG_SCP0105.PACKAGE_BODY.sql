-- [E20261008-SLASHOBJ] PACKAGE BODY PKG_SCP0105 — 사내 현재 원문(적용본, 사내 LAST_DDL 2026-10-08 16:51:03, 4592줄)
CREATE OR REPLACE PACKAGE BODY PKG_SCP0105
AS

    /*******************************************************************************
     * P_SCP0105_GET_SPEED_CURRENT_ASM  (패키지 안에서만 쓰는 갈래)
     *   AS-IS SCP0105_GET_CAPA_SPEED_PLAN_CURRENT_ASSEMBLY — 현재분 조립 조회
     *
     * AS-IS 절차
     *   1. 날짜 칸을 공용 함수에서 받는다(버전의 다음 달 기준). 정렬키 앞 두 자리가 99 인 것은 뺀다.
     *   2. 속도계획 뷰에서 조회조건에 맞는 원자료를 임시 테이블에 담는다.
     *   3. 날짜 칸 수만큼 피벗식을 조립해 동적 조회로 화면에 돌려준다.
     *   4. 화면이 되돌리기(Unpivot)에 쓸 원본 구조를 빈 결과로 한 번 더 돌려준다.
     *
     * ★날짜 칸 수가 조회 시점에 따라 달라지므로 마지막 조회는 동적으로 만든다
     *   (CNS 규칙의 「피벗처럼 불가피한 동적 컬럼」 예외). 날짜 칸 이름은 달력 함수에서 오고
     *   값은 리터럴로 박는다 — 바인드할 자리가 아니다.
     * ★AS-IS 가 만드는 임시 테이블 가운데 최종 조회가 읽지 않는 것이 여럿 있다
     *   (공정·전극구분 묶음 세 개 · 속도단위 묶음 두 개 · 전극유형 룩업).
     *   읽지 않으므로 옮기지 않았다.
     * ★AS-IS 가 계산하지만 쓰지 않는 변수 세 개(@v_from_yyyy · @v_to_yyyy · @v_result_to_yyyymm)도 옮기지 않았다.
     * ★원본 MSSQL 주석은 형태 그대로 둔다.
     * 2026.10.07   AJS   조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시
     *******************************************************************************/
    PROCEDURE P_SCP0105_GET_SPEED_CURRENT_ASM
    (
        P_VERSION               IN  VARCHAR2
      , P_VERSION_SEQ           IN  VARCHAR2
      , P_PROG_STAT             IN  VARCHAR2
      , P_DIVISION_ID           IN  VARCHAR2
      , P_SITE_ID               IN  VARCHAR2
      , P_PLANT_ID              IN  VARCHAR2
      , P_FACTORY_ID            IN  VARCHAR2
      , P_LINE_ID               IN  VARCHAR2
      , P_OPERATION_ID          IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_ELECTRODE_TYPE        IN  VARCHAR2
      , P_PROGRAM_ID            IN  VARCHAR2
      , P_SHEET_NAME            IN  VARCHAR2
      , P_USER_ID               IN  VARCHAR2
      , DEBUG_MODE              IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RC2                   OUT SYS_REFCURSOR
    )
    IS
        V_FROM_YYYYMM               VARCHAR2(6 CHAR);
        V_DATE_COLS                 CLOB;
        V_PRIORITY_COLS             CLOB;
        V_FINAL_SUM_COLS            CLOB;
        V_FINAL_SUM_PRIORITY_COLS   CLOB;
        V_FINAL_COLS                CLOB;
        V_FINAL_PRIORITY_COLS       CLOB;
        V_SQL                       CLOB;
    BEGIN

        DBMS_LOB.CREATETEMPORARY(V_DATE_COLS, TRUE);
        DBMS_LOB.CREATETEMPORARY(V_PRIORITY_COLS, TRUE);
        DBMS_LOB.CREATETEMPORARY(V_FINAL_SUM_COLS, TRUE);
        DBMS_LOB.CREATETEMPORARY(V_FINAL_SUM_PRIORITY_COLS, TRUE);
        DBMS_LOB.CREATETEMPORARY(V_FINAL_COLS, TRUE);
        DBMS_LOB.CREATETEMPORARY(V_FINAL_PRIORITY_COLS, TRUE);
        DBMS_LOB.CREATETEMPORARY(V_SQL, TRUE);

        V_FROM_YYYYMM := TO_CHAR(ADD_MONTHS(TO_DATE(P_VERSION || '01', 'YYYYMMDD'), 1), 'YYYYMM');

        DELETE FROM GT_SCP0105_RAW;

        INSERT INTO GT_SCP0105_RAW
             ( VER_ID, VER_SEQ, DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID
             , OPERATION_ID, ELTR_LN_TP_CD, ITEM_ID, NICK_NAME, SPEED_UNIT_GROUP, MSR_TP_CD
             , YYYYMM, PFRSLT_QTY, BASE_QTY, QTY, ELTR_QTY, MMS_CF, UI_UPD_YN, ASSIGN_PRIORITY
             , DUMMY_YN, PROG_STAT, REMARK, CREATED_BY, CREATION_DATE
             , LAST_UPDATED_BY, LAST_UPDATE_DATE )
        SELECT A.VER_ID
             , A.VER_SEQ
             , A.DIVISION_ID
             , A.COMPANY_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.LINE_ID
             , A.OPERATION_ID
             , A.ELTR_LN_TP_CD
             , A.ITEM_ID
             , A.NICK_NAME
             , A.SPEED_UNIT_GROUP
             , A.MSR_TP_CD
             , A.YYYYMM
             , A.PFRSLT_QTY
             , A.BASE_QTY
             , A.QTY
             , A.ELTR_QTY
             , A.MMS_CF
             , A.UI_UPD_YN
             , A.ASSIGN_PRIORITY
             , A.DUMMY_YN
             , A.PROG_STAT
             , A.REMARK
             , A.CREATED_BY
             , A.CREATION_DATE
             , A.LAST_UPDATED_BY
             , A.LAST_UPDATE_DATE
          FROM SCP_MST_CAPA_SPEED_PLAN_V A
         WHERE A.OPERATION_ID <> 'AFFFF'
           AND ( TRIM(P_DIVISION_ID) IS NULL
              OR UPPER(P_DIVISION_ID) = 'ALL'                                   /* 조회조건 ALL 은 조건 없음 */
              OR A.DIVISION_ID IN (SELECT UPPER(COLUMN_VALUE)
                                     FROM TABLE(STRING_SPLIT(P_DIVISION_ID, ','))) )
           AND ( TRIM(P_SITE_ID) IS NULL
              OR UPPER(P_SITE_ID) = 'ALL'
              OR A.SITE_ID IN (SELECT UPPER(COLUMN_VALUE)
                                 FROM TABLE(STRING_SPLIT(P_SITE_ID, ','))) )
           AND ( TRIM(P_PLANT_ID) IS NULL
              OR UPPER(P_PLANT_ID) = 'ALL'
              OR A.PLANT_ID IN (SELECT UPPER(COLUMN_VALUE)
                                  FROM TABLE(STRING_SPLIT(P_PLANT_ID, ','))) )
           AND ( TRIM(P_FACTORY_ID) IS NULL
              OR UPPER(P_FACTORY_ID) = 'ALL'
              OR A.FACTORY_ID IN (SELECT UPPER(COLUMN_VALUE)
                                    FROM TABLE(STRING_SPLIT(P_FACTORY_ID, ','))) )
           AND ( TRIM(P_LINE_ID) IS NULL
              OR UPPER(P_LINE_ID) = 'ALL'
              OR A.LINE_ID IN (SELECT UPPER(COLUMN_VALUE)
                                 FROM TABLE(STRING_SPLIT(P_LINE_ID, ','))) )
           AND ( TRIM(P_OPERATION_ID) IS NULL
              OR UPPER(P_OPERATION_ID) = 'ALL'
              OR A.OPERATION_ID IN (SELECT UPPER(COLUMN_VALUE)
                                      FROM TABLE(STRING_SPLIT(P_OPERATION_ID, ','))) )
           AND ( TRIM(P_ELECTRODE_TYPE) IS NULL
              OR UPPER(P_ELECTRODE_TYPE) = 'ALL'
              /* ★전극구분 칸에는 소문자가 섞여 있다(29,160행) — AS-IS 는 대소문자를 가리지 않으므로 양쪽을 UPPER */
              OR UPPER(A.ELTR_LN_TP_CD) IN (SELECT UPPER(COLUMN_VALUE)
                                              FROM TABLE(STRING_SPLIT(P_ELECTRODE_TYPE, ','))) )
           AND ( ( TRIM(P_ITEM_ID) IS NULL
                OR UPPER(P_ITEM_ID) = 'ALL'
                /* 2026.10.07 AJS Model/Nickname 검색 (START) */
--              OR A.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE)
--                                 FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )
--            OR A.NICK_NAME IN (SELECT COLUMN_VALUE
--                                 FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) );
                OR EXISTS (SELECT 1
                             FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SM
                            WHERE TRIM(SM.COLUMN_VALUE) IS NOT NULL
                              AND (   UPPER(A.ITEM_ID)   LIKE '%' || UPPER(TRIM(SM.COLUMN_VALUE)) || '%'
                                   OR UPPER(A.NICK_NAME) LIKE '%' || UPPER(TRIM(SM.COLUMN_VALUE)) || '%')) ) );
                /* 2026.10.07 AJS Model/Nickname 검색 (END) */

        /* 날짜 칸 수만큼 피벗식을 조립한다 */
        FOR C IN ( SELECT A.COLUMN_NAME
                     FROM TABLE(FN_SCP0104_GET_SPREAD_TITLE(V_FROM_YYYYMM, P_PROGRAM_ID, P_SHEET_NAME)) A
                    WHERE SUBSTR(A.SORT_ORDER_NO, 1, 2) <> '99'
                    ORDER BY A.SORT_ORDER_NO )
        LOOP
            IF INSTR(C.COLUMN_NAME, 'M_') = 1 THEN
                DBMS_LOB.APPEND(V_DATE_COLS, TO_CLOB(CHR(10) || '     , CAST(CASE WHEN YYYYMM = '''
                    || SUBSTR(C.COLUMN_NAME, 5, 6) || ''' THEN QTY END AS BINARY_DOUBLE) AS ' || C.COLUMN_NAME));
            ELSIF INSTR(C.COLUMN_NAME, 'Y_') = 1 THEN
                DBMS_LOB.APPEND(V_DATE_COLS, TO_CLOB(CHR(10) || '     , CAST(CASE WHEN YYYYMM = '''
                    || SUBSTR(C.COLUMN_NAME, 3, 4) || ''' THEN QTY END AS BINARY_DOUBLE) AS ' || C.COLUMN_NAME));
            END IF;

            IF INSTR(C.COLUMN_NAME, 'M_01') = 1 THEN
                DBMS_LOB.APPEND(V_PRIORITY_COLS, TO_CLOB(CHR(10) || '     , CASE WHEN YYYYMM = '''
                    || SUBSTR(C.COLUMN_NAME, 5, 6) || ''' THEN ASSIGN_PRIORITY END AS '
                    || C.COLUMN_NAME || '_ASSIGN_PRIORITY'));
            ELSIF INSTR(C.COLUMN_NAME, 'Y_') = 1 THEN
                DBMS_LOB.APPEND(V_PRIORITY_COLS, TO_CLOB(CHR(10) || '     , CASE WHEN YYYYMM = '''
                    || SUBSTR(C.COLUMN_NAME, 3, 4) || ''' THEN ASSIGN_PRIORITY END AS '
                    || C.COLUMN_NAME || '_ASSIGN_PRIORITY'));
            END IF;

            DBMS_LOB.APPEND(V_FINAL_SUM_COLS, TO_CLOB(CHR(10) || '     , MAX(' || C.COLUMN_NAME
                || ') AS ' || C.COLUMN_NAME));
            DBMS_LOB.APPEND(V_FINAL_SUM_PRIORITY_COLS, TO_CLOB(CHR(10) || '     , MAX('
                || C.COLUMN_NAME || '_ASSIGN_PRIORITY) AS ' || C.COLUMN_NAME || '_ASSIGN_PRIORITY'));
            DBMS_LOB.APPEND(V_FINAL_COLS, TO_CLOB(CHR(10) || '     , A.' || C.COLUMN_NAME));
            DBMS_LOB.APPEND(V_FINAL_PRIORITY_COLS, TO_CLOB(CHR(10) || '     , A.'
                || C.COLUMN_NAME || '_ASSIGN_PRIORITY AS ' || C.COLUMN_NAME || '_ASSIGN_PRIORITY'));
        END LOOP;

        DBMS_LOB.APPEND(V_SQL, TO_CLOB(
            'SELECT A.VER_ID' || CHR(10)
         || '     , A.VER_SEQ' || CHR(10)
         || '     , A.DIVISION_ID' || CHR(10)
         || '     , A.COMPANY_ID' || CHR(10)
         || '     , A.SITE_ID' || CHR(10)
         || '     , A.PLANT_ID' || CHR(10)
         || '     , A.FACTORY_ID' || CHR(10)
         || '     , A.LINE_ID' || CHR(10)
         || '     , A.OPERATION_ID' || CHR(10)
         || '     , A.ELTR_LN_TP_CD' || CHR(10)
         || '     , A.ITEM_ID' || CHR(10)
         || '     , A.NICK_NAME' || CHR(10)
         || '     , A.SPEED_UNIT_GROUP' || CHR(10)
         || '     , A.MSR_TP_CD' || CHR(10)
         || '     , A.PFRSLT_QTY' || CHR(10)
         || '     , A.BASE_QTY' || CHR(10)
         || '     , A.ELTR_QTY' || CHR(10)
         || '     , A.MMS_CF' || CHR(10)
         || '     , A.UI_UPD_YN'));
        DBMS_LOB.APPEND(V_SQL, V_FINAL_COLS);
        DBMS_LOB.APPEND(V_SQL, V_FINAL_PRIORITY_COLS);
        DBMS_LOB.APPEND(V_SQL, TO_CLOB(CHR(10)
         || '     , M.MEASURE_NAME' || CHR(10)
         || '     , M.SORT_ORDER_NO' || CHR(10)
         || '     , G.UNIT_GROUP_SEQ AS SPEED_UNIT_GROUP_SEQ' || CHR(10)
         /* NICK_NAME 더미 여부는 Speed Plan 입력항목(Meaasrue) 을 결정하므로 따로 저장해둔다 */
         || '     , ''N'' AS NICK_NAME_DUMMY_YN' || CHR(10)
         || '     , A.DUMMY_YN' || CHR(10)
         || '     , CASE WHEN A.SPEED_UNIT_GROUP IN (''EQP_NBU'') THEN ''Y''' || CHR(10)
         || '            WHEN A.SPEED_UNIT_GROUP IN (''EQP_SPED'') THEN ''Y''' || CHR(10)
         || '            WHEN A.SPEED_UNIT_GROUP IN (''PPM'') AND N.NICK_NAME IS NULL'
         || ' AND A.OPERATION_ID IN (''A5000'', ''A7000'', ''A7400'') THEN ''Y''' || CHR(10)
         || '            ELSE ''N'' END AS EDITABLE_YN' || CHR(10)
         || '     , CASE WHEN A.SPEED_UNIT_GROUP IN (''EQP_NBU'') THEN ''Y''' || CHR(10)
         || '            WHEN A.SPEED_UNIT_GROUP IN (''EQP_SPED'') THEN ''Y''' || CHR(10)
         || '            WHEN A.SPEED_UNIT_GROUP IN (''PPM'') AND N.NICK_NAME IS NULL'
         || ' AND A.OPERATION_ID IN (''A5000'', ''A7000'', ''A7400'') THEN ''Y''' || CHR(10)
         || '            ELSE ''N'' END AS BASE_EDITABLE_YN' || CHR(10)
         || '     , FN_GET_DIVISION_NAME(A.DIVISION_ID) AS DIVISION_NAME' || CHR(10)
         || '     , S.SITE_NAME AS SITE_NAME' || CHR(10)
         || '     , P.PLANT_NAME AS PLANT_NAME' || CHR(10)
         || '     , F.FACTORY_NAME AS FACTORY_NAME' || CHR(10)
         || '     , L.LINE_NAME AS LINE_NAME' || CHR(10)
         || '     , O.OPERATION_NAME' || CHR(10)
         || '     , M.ATTRIBUTE3 AS MEASURE_COLOR' || CHR(10)
         || '     , ROW_NUMBER() OVER (ORDER BY NULL) AS IDX' || CHR(10)
         || '  FROM (SELECT IA.VER_ID' || CHR(10)
         || '             , IA.VER_SEQ' || CHR(10)
         || '             , IA.DIVISION_ID' || CHR(10)
         || '             , IA.COMPANY_ID' || CHR(10)
         || '             , IA.SITE_ID' || CHR(10)
         || '             , IA.PLANT_ID' || CHR(10)
         || '             , IA.FACTORY_ID' || CHR(10)
         || '             , IA.LINE_ID' || CHR(10)
         || '             , IA.OPERATION_ID' || CHR(10)
         || '             , IA.ELTR_LN_TP_CD' || CHR(10)
         || '             , IA.ITEM_ID' || CHR(10)
         || '             , IA.NICK_NAME' || CHR(10)
         || '             , IA.SPEED_UNIT_GROUP' || CHR(10)
         || '             , IA.MSR_TP_CD' || CHR(10)
         || '             , MAX(IA.PFRSLT_QTY) AS PFRSLT_QTY' || CHR(10)
         || '             , MAX(IA.BASE_QTY) AS BASE_QTY' || CHR(10)
         || '             , MAX(IA.ELTR_QTY) AS ELTR_QTY' || CHR(10)
         || '             , MAX(IA.MMS_CF) AS MMS_CF' || CHR(10)
         || '             , MAX(IA.UI_UPD_YN) AS UI_UPD_YN' || CHR(10)
         || '             , MAX(IA.DUMMY_YN) AS DUMMY_YN'));
        DBMS_LOB.APPEND(V_SQL, REPLACE(V_FINAL_SUM_COLS, CHR(10) || '     , ', CHR(10) || '             , '));
        DBMS_LOB.APPEND(V_SQL, REPLACE(V_FINAL_SUM_PRIORITY_COLS, CHR(10) || '     , ', CHR(10) || '             , '));
        DBMS_LOB.APPEND(V_SQL, TO_CLOB(CHR(10)
         || '          FROM (SELECT XA.VER_ID' || CHR(10)
         || '                     , XA.VER_SEQ' || CHR(10)
         || '                     , XA.DIVISION_ID' || CHR(10)
         || '                     , XA.COMPANY_ID' || CHR(10)
         || '                     , XA.SITE_ID' || CHR(10)
         || '                     , XA.PLANT_ID' || CHR(10)
         || '                     , XA.FACTORY_ID' || CHR(10)
         || '                     , XA.LINE_ID' || CHR(10)
         || '                     , XA.OPERATION_ID' || CHR(10)
         || '                     , XA.ELTR_LN_TP_CD' || CHR(10)
         || '                     , XA.ITEM_ID' || CHR(10)
         || '                     , XA.NICK_NAME' || CHR(10)
         || '                     , XA.SPEED_UNIT_GROUP' || CHR(10)
         || '                     , XA.MSR_TP_CD' || CHR(10)
         || '                     , XA.PFRSLT_QTY' || CHR(10)
         || '                     , XA.BASE_QTY' || CHR(10)
         || '                     , XA.ELTR_QTY' || CHR(10)
         || '                     , XA.MMS_CF' || CHR(10)
         || '                     , XA.UI_UPD_YN' || CHR(10)
         || '                     , XA.DUMMY_YN'));
        DBMS_LOB.APPEND(V_SQL, REPLACE(V_DATE_COLS, CHR(10) || '     , ', CHR(10) || '                     , '));
        DBMS_LOB.APPEND(V_SQL, REPLACE(V_PRIORITY_COLS, CHR(10) || '     , ', CHR(10) || '                     , '));
        DBMS_LOB.APPEND(V_SQL, TO_CLOB(CHR(10)
         || '                  FROM GT_SCP0105_RAW XA) IA' || CHR(10)
         || '         GROUP BY IA.VER_ID' || CHR(10)
         || '                , IA.VER_SEQ' || CHR(10)
         || '                , IA.DIVISION_ID' || CHR(10)
         || '                , IA.COMPANY_ID' || CHR(10)
         || '                , IA.SITE_ID' || CHR(10)
         || '                , IA.PLANT_ID' || CHR(10)
         || '                , IA.FACTORY_ID' || CHR(10)
         || '                , IA.LINE_ID' || CHR(10)
         || '                , IA.OPERATION_ID' || CHR(10)
         || '                , IA.ELTR_LN_TP_CD' || CHR(10)
         || '                , IA.ITEM_ID' || CHR(10)
         || '                , IA.NICK_NAME' || CHR(10)
         || '                , IA.SPEED_UNIT_GROUP' || CHR(10)
         || '                , IA.MSR_TP_CD) A' || CHR(10)
         || '     , (SELECT SITE_ID, SITE_NAME FROM SCP_MST_CAPA_LINE WHERE VALID_YN = ''Y'''
         || ' GROUP BY SITE_ID, SITE_NAME) S' || CHR(10)
         || '     , (SELECT COMPANY_ID, COMPANY_NAME FROM SCP_MST_CAPA_LINE WHERE VALID_YN = ''Y'''
         || ' GROUP BY COMPANY_ID, COMPANY_NAME) C' || CHR(10)
         || '     , (SELECT PLANT_ID, PLANT_NAME FROM SCP_MST_CAPA_LINE WHERE VALID_YN = ''Y'''
         || ' GROUP BY PLANT_ID, PLANT_NAME) P' || CHR(10)
         || '     , (SELECT FACTORY_ID, FACTORY_NAME FROM SCP_MST_CAPA_LINE WHERE VALID_YN = ''Y'''
         || ' GROUP BY FACTORY_ID, FACTORY_NAME) F' || CHR(10)
         || '     , (SELECT LINE_ID, LINE_NAME FROM SCP_MST_CAPA_LINE WHERE VALID_YN = ''Y'''
         || ' GROUP BY LINE_ID, LINE_NAME) L' || CHR(10)
         || '     , (SELECT SA.OPERATION_ID, MAX(SA.OPERATION_NAME) AS OPERATION_NAME'
         || ' FROM SCM_MST_OPERATION_SN SA GROUP BY SA.OPERATION_ID' || CHR(10)
         || '        UNION ALL' || CHR(10)
         || '        SELECT SC.SEGMENT1, SC.ATTRIBUTE1 FROM SCM_ADM_LOOKUP_MASTER SB'
         || '           , SCM_ADM_LOOKUP_MASTER_DETAIL SC' || CHR(10)
         || '         WHERE SB.LOOKUP_TYPE = SC.LOOKUP_TYPE AND SB.LOOKUP_GROUP = ''SCP'''
         || ' AND SB.LOOKUP_TYPE = ''CPS_FORMATION_OPERATION'' AND SC.VALID_YN = ''Y'''
         || ' GROUP BY SC.SEGMENT1, SC.ATTRIBUTE1) O' || CHR(10)
         || '     , (SELECT DISTINCT SD.NICK_NAME FROM TABLE(FN_SCM0002_GET_CAPA_ITEM_POPUP('''', '''')) SD'
         || ' WHERE TRIM(SD.NICK_NAME) IS NOT NULL) N' || CHR(10)
         || '     , (SELECT SE.COLUMN_NAME AS MEASURE, SE.COLUMN_LABEL_NAME AS MEASURE_NAME'
         || ' , SE.SORT_ORDER_NO, SE.ATTRIBUTE3 FROM SCM_MST_SHEET_MEASURE SE' || CHR(10)
         || '         WHERE SE.PROGRAM_ID = ''SCP0105'' AND SE.SHEET_NAME = ''ASSEMBLY'''
         || ' AND SE.VALID_YN = ''Y'') M' || CHR(10)
         || '     , (SELECT SF.SEGMENT1 AS UNIT_GROUP, SF.SEGMENT3 AS MSR_TP_CD'
         || ' , SF.SEGMENT5 AS UNIT_GROUP_SEQ FROM SCM_ADM_LOOKUP_MASTER_DETAIL SF' || CHR(10)
         || '         WHERE SF.LOOKUP_TYPE = ''OPERATION_SPEED_UNIT'' AND SF.VALID_YN = ''Y'') G' || CHR(10)
         || ' WHERE A.SITE_ID = S.SITE_ID(+)' || CHR(10)
         || '   AND A.COMPANY_ID = C.COMPANY_ID(+)' || CHR(10)
         || '   AND A.PLANT_ID = P.PLANT_ID(+)' || CHR(10)
         || '   AND A.FACTORY_ID = F.FACTORY_ID(+)' || CHR(10)
         || '   AND A.LINE_ID = L.LINE_ID(+)' || CHR(10)
         || '   AND A.OPERATION_ID = O.OPERATION_ID(+)' || CHR(10)
         || '   AND A.NICK_NAME = N.NICK_NAME(+)' || CHR(10)
         || '   AND A.MSR_TP_CD = M.MEASURE(+)' || CHR(10)
         || '   AND A.SPEED_UNIT_GROUP = G.UNIT_GROUP(+)' || CHR(10)
         || '   AND A.MSR_TP_CD = G.MSR_TP_CD(+)' || CHR(10)
         || ' ORDER BY A.VER_ID' || CHR(10)
         || '        , A.VER_SEQ' || CHR(10)
         || '        , A.DIVISION_ID' || CHR(10)
         || '        , A.COMPANY_ID' || CHR(10)
         || '        , S.SITE_NAME' || CHR(10)
         || '        , P.PLANT_NAME' || CHR(10)
         || '        , F.FACTORY_NAME' || CHR(10)
         || '        , L.LINE_NAME' || CHR(10)
         || '        , A.ITEM_ID' || CHR(10)
         || '        , A.NICK_NAME' || CHR(10)
         || '        , A.OPERATION_ID' || CHR(10)
         || '        , A.ELTR_LN_TP_CD' || CHR(10)
         || '        , M.SORT_ORDER_NO'));

        OPEN O_RC1 FOR V_SQL;

        /* Unpivot 용 오리지널 테이블 구조 저장 */
        OPEN O_RC2 FOR
            SELECT VER_ID
                 , VER_SEQ
                 , DIVISION_ID
                 , COMPANY_ID
                 , SITE_ID
                 , PLANT_ID
                 , FACTORY_ID
                 , LINE_ID
                 , OPERATION_ID
                 , ELTR_LN_TP_CD
                 , ITEM_ID
                 , NICK_NAME
                 , MSR_TP_CD
                 , YYYYMM
                 , BASE_QTY
                 , QTY
              FROM SCP_MST_CAPA_SPEED_PLAN_CUTF
             WHERE 1 <> 1;

        DBMS_LOB.FREETEMPORARY(V_DATE_COLS);
        DBMS_LOB.FREETEMPORARY(V_PRIORITY_COLS);
        DBMS_LOB.FREETEMPORARY(V_FINAL_SUM_COLS);
        DBMS_LOB.FREETEMPORARY(V_FINAL_SUM_PRIORITY_COLS);
        DBMS_LOB.FREETEMPORARY(V_FINAL_COLS);
        DBMS_LOB.FREETEMPORARY(V_FINAL_PRIORITY_COLS);
        DBMS_LOB.FREETEMPORARY(V_SQL);

    END P_SCP0105_GET_SPEED_CURRENT_ASM;

    /*******************************************************************************
     * P_SCP0105_GET_SPEED_CURRENT_ELTR  (패키지 안에서만 쓰는 갈래)
     *   AS-IS SCP0105_GET_CAPA_SPEED_PLAN_CURRENT_ELTR — 현재분 전극 조회
     *
     * ★조립 갈래와 원장 이름만 다른 것이 아니다. 아래가 갈린다.
     *   원자료 뷰 · 계층 원장(COMPANY_ID <> '-' 조건 추가) · 되돌리기 구조 · 속도단위 룩업
     *   공정 이름(조립은 Formation 룩업을 UNION ALL, 전극은 공정 원장 한 곳)
     *   약칭(조립은 목록으로 더미 여부만 판정, 전극은 사업부+품목으로 약칭 자체를 가져온다)
     *   더미 판정(전극은 더미 품목 코드 CODE_TP='I' 의 NAME 과 품목을 맞춘다)
     *   전극유형 이름 칸 추가 · 설비 칸 추가 · 수정가능 칸 없음 · 묶음 열쇠에서 약칭 제외
     *   품목 조회조건에 약칭이 없다
     * ★결과 칸 차례도 다르다 — 순번(IDX)이 전극유형 이름보다 앞에 온다.
     * ★AS-IS 가 원장 값을 NVL(…, 0.0) 으로 감싸 담는다.
     * ★뷰의 DAY_CNT 칸은 읽지 않는다 — 읽는 순간 ORA-01840 이 나는 이관 결함이 있고
     *   AS-IS 도 최종 조회에서 쓰지 않는다.
     * ★원본 MSSQL 주석은 형태 그대로 둔다.
     * 2026.10.07   AJS   조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시
     * 2026.10.07   AJS   조회 속도 : 약칭을 공용 함수 전체 결과 대신 원자료 품목으로 한정한 같은 조회로(결과 동일)
     *******************************************************************************/
    PROCEDURE P_SCP0105_GET_SPEED_CURRENT_ELTR
    (
        P_VERSION               IN  VARCHAR2
      , P_VERSION_SEQ           IN  VARCHAR2
      , P_PROG_STAT             IN  VARCHAR2
      , P_DIVISION_ID           IN  VARCHAR2
      , P_SITE_ID               IN  VARCHAR2
      , P_PLANT_ID              IN  VARCHAR2
      , P_FACTORY_ID            IN  VARCHAR2
      , P_LINE_ID               IN  VARCHAR2
      , P_OPERATION_ID          IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_ELECTRODE_TYPE        IN  VARCHAR2
      , P_PROGRAM_ID            IN  VARCHAR2
      , P_SHEET_NAME            IN  VARCHAR2
      , P_USER_ID               IN  VARCHAR2
      , DEBUG_MODE              IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RC2                   OUT SYS_REFCURSOR
    )
    IS
        V_FROM_YYYYMM               VARCHAR2(6 CHAR);
        V_DATE_COLS                 CLOB;
        V_PRIORITY_COLS             CLOB;
        V_FINAL_SUM_COLS            CLOB;
        V_FINAL_SUM_PRIORITY_COLS   CLOB;
        V_FINAL_COLS                CLOB;
        V_FINAL_PRIORITY_COLS       CLOB;
        V_SQL                       CLOB;
    BEGIN

        DBMS_LOB.CREATETEMPORARY(V_DATE_COLS, TRUE);
        DBMS_LOB.CREATETEMPORARY(V_PRIORITY_COLS, TRUE);
        DBMS_LOB.CREATETEMPORARY(V_FINAL_SUM_COLS, TRUE);
        DBMS_LOB.CREATETEMPORARY(V_FINAL_SUM_PRIORITY_COLS, TRUE);
        DBMS_LOB.CREATETEMPORARY(V_FINAL_COLS, TRUE);
        DBMS_LOB.CREATETEMPORARY(V_FINAL_PRIORITY_COLS, TRUE);
        DBMS_LOB.CREATETEMPORARY(V_SQL, TRUE);

        V_FROM_YYYYMM := TO_CHAR(ADD_MONTHS(TO_DATE(P_VERSION || '01', 'YYYYMMDD'), 1), 'YYYYMM');

        DELETE FROM GT_SCP0105_RAW_ELTR;

        INSERT INTO GT_SCP0105_RAW_ELTR
             ( VER_ID, VER_SEQ, DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID
             , OPERATION_ID, ELTR_LN_TP_CD, ITEM_ID, NICK_NAME, SPEED_UNIT_GROUP, MSR_TP_CD
             , YYYYMM, UI_UPD_YN, ASSIGN_PRIORITY, EQUIPMENT_ID, EQUIPMENT_NAME
             , PFRSLT_QTY, BASE_QTY, QTY )
        SELECT A.VER_ID
             , A.VER_SEQ
             , A.DIVISION_ID
             , A.COMPANY_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.LINE_ID
             , A.OPERATION_ID
             , A.ELTR_LN_TP_CD
             , A.ITEM_ID
             , A.NICK_NAME
             , A.SPEED_UNIT_GROUP
             , A.MSR_TP_CD
             , A.YYYYMM
             , A.UI_UPD_YN
             , A.ASSIGN_PRIORITY
             , A.EQUIPMENT_ID
             , A.EQUIPMENT_NAME
             , NVL(A.PFRSLT_QTY, 0.0)
             , NVL(A.BASE_QTY, 0.0)
             , NVL(A.QTY, 0.0)
          FROM SCP_MST_CAPA_ELTR_SPEED_PLAN_V A
         WHERE A.OPERATION_ID <> 'AFFFF'
           AND ( TRIM(P_DIVISION_ID) IS NULL
              OR UPPER(P_DIVISION_ID) = 'ALL'                                   /* 조회조건 ALL 은 조건 없음 */
              OR A.DIVISION_ID IN (SELECT UPPER(COLUMN_VALUE)
                                     FROM TABLE(STRING_SPLIT(P_DIVISION_ID, ','))) )
           AND ( TRIM(P_SITE_ID) IS NULL
              OR UPPER(P_SITE_ID) = 'ALL'
              OR A.SITE_ID IN (SELECT UPPER(COLUMN_VALUE)
                                 FROM TABLE(STRING_SPLIT(P_SITE_ID, ','))) )
           AND ( TRIM(P_PLANT_ID) IS NULL
              OR UPPER(P_PLANT_ID) = 'ALL'
              OR A.PLANT_ID IN (SELECT UPPER(COLUMN_VALUE)
                                  FROM TABLE(STRING_SPLIT(P_PLANT_ID, ','))) )
           AND ( TRIM(P_FACTORY_ID) IS NULL
              OR UPPER(P_FACTORY_ID) = 'ALL'
              OR A.FACTORY_ID IN (SELECT UPPER(COLUMN_VALUE)
                                    FROM TABLE(STRING_SPLIT(P_FACTORY_ID, ','))) )
           AND ( TRIM(P_LINE_ID) IS NULL
              OR UPPER(P_LINE_ID) = 'ALL'
              OR A.LINE_ID IN (SELECT UPPER(COLUMN_VALUE)
                                 FROM TABLE(STRING_SPLIT(P_LINE_ID, ','))) )
           AND ( TRIM(P_OPERATION_ID) IS NULL
              OR UPPER(P_OPERATION_ID) = 'ALL'
              OR A.OPERATION_ID IN (SELECT UPPER(COLUMN_VALUE)
                                      FROM TABLE(STRING_SPLIT(P_OPERATION_ID, ','))) )
           AND ( TRIM(P_ELECTRODE_TYPE) IS NULL
              OR UPPER(P_ELECTRODE_TYPE) = 'ALL'
              /* ★전극구분 칸에는 소문자가 섞여 있다 — AS-IS 는 대소문자를 가리지 않으므로 양쪽을 UPPER */
              OR UPPER(A.ELTR_LN_TP_CD) IN (SELECT UPPER(COLUMN_VALUE)
                                              FROM TABLE(STRING_SPLIT(P_ELECTRODE_TYPE, ','))) )
           /* ★전극은 품목만 본다 — 조립과 달리 약칭 조건이 없다 */
           AND ( TRIM(P_ITEM_ID) IS NULL
              OR UPPER(P_ITEM_ID) = 'ALL'
              /* 2026.10.07 AJS Model/Nickname 검색 (START) */
--            OR A.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE)
--                               FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) );
              OR EXISTS (SELECT 1
                           FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SM
                          WHERE TRIM(SM.COLUMN_VALUE) IS NOT NULL
                            AND (   UPPER(A.ITEM_ID) LIKE '%' || UPPER(TRIM(SM.COLUMN_VALUE)) || '%'
                                 OR EXISTS (SELECT 1      /* 전극 원장 약칭은 전부 '-' : 품목 원장 약칭으로 비교 */
                                              FROM SCM_MST_ITEM_SN SN
                                             WHERE SN.ITEM_ID = A.ITEM_ID
                                               AND UPPER(SN.NICK_NAME) LIKE '%' || UPPER(TRIM(SM.COLUMN_VALUE)) || '%')) ) );
              /* 2026.10.07 AJS Model/Nickname 검색 (END) */

        /* 날짜 칸 수만큼 피벗식을 조립한다 */
        FOR C IN ( SELECT A.COLUMN_NAME
                     FROM TABLE(FN_SCP0104_GET_SPREAD_TITLE(V_FROM_YYYYMM, P_PROGRAM_ID, P_SHEET_NAME)) A
                    WHERE SUBSTR(A.SORT_ORDER_NO, 1, 2) <> '99'
                    ORDER BY A.SORT_ORDER_NO )
        LOOP
            IF INSTR(C.COLUMN_NAME, 'M_') = 1 THEN
                DBMS_LOB.APPEND(V_DATE_COLS, TO_CLOB(CHR(10) || '     , CAST(CASE WHEN YYYYMM = '''
                    || SUBSTR(C.COLUMN_NAME, 5, 6) || ''' THEN QTY END AS BINARY_DOUBLE) AS ' || C.COLUMN_NAME));
            ELSIF INSTR(C.COLUMN_NAME, 'Y_') = 1 THEN
                DBMS_LOB.APPEND(V_DATE_COLS, TO_CLOB(CHR(10) || '     , CAST(CASE WHEN YYYYMM = '''
                    || SUBSTR(C.COLUMN_NAME, 3, 4) || ''' THEN QTY END AS BINARY_DOUBLE) AS ' || C.COLUMN_NAME));
            END IF;

            IF INSTR(C.COLUMN_NAME, 'M_01') = 1 THEN
                DBMS_LOB.APPEND(V_PRIORITY_COLS, TO_CLOB(CHR(10) || '     , CASE WHEN YYYYMM = '''
                    || SUBSTR(C.COLUMN_NAME, 5, 6) || ''' THEN ASSIGN_PRIORITY END AS '
                    || C.COLUMN_NAME || '_ASSIGN_PRIORITY'));
            ELSIF INSTR(C.COLUMN_NAME, 'Y_') = 1 THEN
                DBMS_LOB.APPEND(V_PRIORITY_COLS, TO_CLOB(CHR(10) || '     , CASE WHEN YYYYMM = '''
                    || SUBSTR(C.COLUMN_NAME, 3, 4) || ''' THEN ASSIGN_PRIORITY END AS '
                    || C.COLUMN_NAME || '_ASSIGN_PRIORITY'));
            END IF;

            DBMS_LOB.APPEND(V_FINAL_SUM_COLS, TO_CLOB(CHR(10) || '     , MAX(' || C.COLUMN_NAME
                || ') AS ' || C.COLUMN_NAME));
            DBMS_LOB.APPEND(V_FINAL_SUM_PRIORITY_COLS, TO_CLOB(CHR(10) || '     , MAX('
                || C.COLUMN_NAME || '_ASSIGN_PRIORITY) AS ' || C.COLUMN_NAME || '_ASSIGN_PRIORITY'));
            DBMS_LOB.APPEND(V_FINAL_COLS, TO_CLOB(CHR(10) || '     , A.' || C.COLUMN_NAME));
            DBMS_LOB.APPEND(V_FINAL_PRIORITY_COLS, TO_CLOB(CHR(10) || '     , A.'
                || C.COLUMN_NAME || '_ASSIGN_PRIORITY AS ' || C.COLUMN_NAME || '_ASSIGN_PRIORITY'));
        END LOOP;

        DBMS_LOB.APPEND(V_SQL, TO_CLOB(
/*          'SELECT A.VER_ID' || CHR(10) */
            'SELECT /*+ NO_PUSH_PRED(K) */ A.VER_ID' || CHR(10) /* AJS 20261007 속도 */
         || '     , A.VER_SEQ' || CHR(10)
         || '     , A.DIVISION_ID' || CHR(10)
         || '     , A.COMPANY_ID' || CHR(10)
         || '     , A.SITE_ID' || CHR(10)
         || '     , A.PLANT_ID' || CHR(10)
         || '     , A.FACTORY_ID' || CHR(10)
         || '     , A.LINE_ID' || CHR(10)
         || '     , A.OPERATION_ID' || CHR(10)
         || '     , A.ELTR_LN_TP_CD' || CHR(10)
         || '     , A.ITEM_ID' || CHR(10)
         /* ★약칭은 원장 값이 아니라 사업부+품목으로 가져온 값을 돌려준다 */
         || '     , K.NICK_NAME' || CHR(10)
         || '     , A.SPEED_UNIT_GROUP' || CHR(10)
         || '     , A.MSR_TP_CD' || CHR(10)
         || '     , A.PFRSLT_QTY' || CHR(10)
         || '     , A.BASE_QTY' || CHR(10)
         || '     , A.UI_UPD_YN'));
        DBMS_LOB.APPEND(V_SQL, V_FINAL_COLS);
        DBMS_LOB.APPEND(V_SQL, V_FINAL_PRIORITY_COLS);
        DBMS_LOB.APPEND(V_SQL, TO_CLOB(CHR(10)
         || '     , M.MEASURE_NAME' || CHR(10)
         || '     , M.SORT_ORDER_NO' || CHR(10)
         || '     , G.UNIT_GROUP_SEQ AS SPEED_UNIT_GROUP_SEQ' || CHR(10)
         /* NICK_NAME 더미 여부는 Speed Plan 입력항목(Meaasrue) 을 결정하므로 따로 저장해둔다 */
         || '     , CASE WHEN I.CODE IS NOT NULL THEN ''Y'' ELSE ''N'' END AS NICK_NAME_DUMMY_YN' || CHR(10)
         || '     , FN_GET_DIVISION_NAME(A.DIVISION_ID) AS DIVISION_NAME' || CHR(10)
         || '     , S.SITE_NAME AS SITE_NAME' || CHR(10)
         || '     , P.PLANT_NAME AS PLANT_NAME' || CHR(10)
         || '     , F.FACTORY_NAME AS FACTORY_NAME' || CHR(10)
         || '     , L.LINE_NAME AS LINE_NAME' || CHR(10)
         || '     , O.OPERATION_NAME' || CHR(10)
         || '     , ROW_NUMBER() OVER (ORDER BY NULL) AS IDX' || CHR(10)
         || '     , E.ELTR_TP_NM_EN' || CHR(10)
         || '     , A.EQUIPMENT_ID' || CHR(10)
         || '     , A.EQUIPMENT_NAME' || CHR(10)
         || '  FROM (SELECT IA.VER_ID' || CHR(10)
         || '             , IA.VER_SEQ' || CHR(10)
         || '             , IA.DIVISION_ID' || CHR(10)
         || '             , IA.COMPANY_ID' || CHR(10)
         || '             , IA.SITE_ID' || CHR(10)
         || '             , IA.PLANT_ID' || CHR(10)
         || '             , IA.FACTORY_ID' || CHR(10)
         || '             , IA.LINE_ID' || CHR(10)
         || '             , IA.OPERATION_ID' || CHR(10)
         || '             , IA.ELTR_LN_TP_CD' || CHR(10)
         || '             , IA.ITEM_ID' || CHR(10)
         || '             , IA.SPEED_UNIT_GROUP' || CHR(10)
         || '             , IA.MSR_TP_CD' || CHR(10)
         || '             , MAX(IA.PFRSLT_QTY) AS PFRSLT_QTY' || CHR(10)
         || '             , MAX(IA.BASE_QTY) AS BASE_QTY' || CHR(10)
         || '             , MAX(IA.UI_UPD_YN) AS UI_UPD_YN' || CHR(10)
         || '             , MAX(IA.EQUIPMENT_ID) AS EQUIPMENT_ID' || CHR(10)
         || '             , MAX(IA.EQUIPMENT_NAME) AS EQUIPMENT_NAME'));
        DBMS_LOB.APPEND(V_SQL, REPLACE(V_FINAL_SUM_COLS, CHR(10) || '     , ', CHR(10) || '             , '));
        DBMS_LOB.APPEND(V_SQL, REPLACE(V_FINAL_SUM_PRIORITY_COLS, CHR(10) || '     , ', CHR(10) || '             , '));
        DBMS_LOB.APPEND(V_SQL, TO_CLOB(CHR(10)
         || '          FROM (SELECT XA.VER_ID' || CHR(10)
         || '                     , XA.VER_SEQ' || CHR(10)
         || '                     , XA.DIVISION_ID' || CHR(10)
         || '                     , XA.COMPANY_ID' || CHR(10)
         || '                     , XA.SITE_ID' || CHR(10)
         || '                     , XA.PLANT_ID' || CHR(10)
         || '                     , XA.FACTORY_ID' || CHR(10)
         || '                     , XA.LINE_ID' || CHR(10)
         || '                     , XA.OPERATION_ID' || CHR(10)
         || '                     , XA.ELTR_LN_TP_CD' || CHR(10)
         || '                     , XA.ITEM_ID' || CHR(10)
         || '                     , XA.SPEED_UNIT_GROUP' || CHR(10)
         || '                     , XA.MSR_TP_CD' || CHR(10)
         || '                     , XA.PFRSLT_QTY' || CHR(10)
         || '                     , XA.BASE_QTY' || CHR(10)
         || '                     , XA.UI_UPD_YN' || CHR(10)
         || '                     , XA.EQUIPMENT_ID' || CHR(10)
         || '                     , XA.EQUIPMENT_NAME'));
        DBMS_LOB.APPEND(V_SQL, REPLACE(V_DATE_COLS, CHR(10) || '     , ', CHR(10) || '                     , '));
        DBMS_LOB.APPEND(V_SQL, REPLACE(V_PRIORITY_COLS, CHR(10) || '     , ', CHR(10) || '                     , '));
        DBMS_LOB.APPEND(V_SQL, TO_CLOB(CHR(10)
         || '                  FROM GT_SCP0105_RAW_ELTR XA) IA' || CHR(10)
         || '         GROUP BY IA.VER_ID' || CHR(10)
         || '                , IA.VER_SEQ' || CHR(10)
         || '                , IA.DIVISION_ID' || CHR(10)
         || '                , IA.COMPANY_ID' || CHR(10)
         || '                , IA.SITE_ID' || CHR(10)
         || '                , IA.PLANT_ID' || CHR(10)
         || '                , IA.FACTORY_ID' || CHR(10)
         || '                , IA.LINE_ID' || CHR(10)
         || '                , IA.OPERATION_ID' || CHR(10)
         || '                , IA.ELTR_LN_TP_CD' || CHR(10)
         || '                , IA.ITEM_ID' || CHR(10)
         || '                , IA.SPEED_UNIT_GROUP' || CHR(10)
         || '                , IA.MSR_TP_CD) A' || CHR(10)
         /* ★전극 계층 원장은 회사 값이 '-' 인 줄을 뺀다 */
         || '     , (SELECT SITE_ID, SITE_NAME FROM SCP_MST_CAPA_ELTR_LINE'
         || ' WHERE VALID_YN = ''Y'' AND COMPANY_ID <> ''-'' GROUP BY SITE_ID, SITE_NAME) S' || CHR(10)
         || '     , (SELECT COMPANY_ID, COMPANY_NAME FROM SCP_MST_CAPA_ELTR_LINE'
         || ' WHERE VALID_YN = ''Y'' AND COMPANY_ID <> ''-'' GROUP BY COMPANY_ID, COMPANY_NAME) C' || CHR(10)
         || '     , (SELECT PLANT_ID, PLANT_NAME FROM SCP_MST_CAPA_ELTR_LINE'
         || ' WHERE VALID_YN = ''Y'' AND COMPANY_ID <> ''-'' GROUP BY PLANT_ID, PLANT_NAME) P' || CHR(10)
         || '     , (SELECT FACTORY_ID, FACTORY_NAME FROM SCP_MST_CAPA_ELTR_LINE'
         || ' WHERE VALID_YN = ''Y'' AND COMPANY_ID <> ''-'' GROUP BY FACTORY_ID, FACTORY_NAME) F' || CHR(10)
         || '     , (SELECT LINE_ID, LINE_NAME FROM SCP_MST_CAPA_ELTR_LINE'
         || ' WHERE VALID_YN = ''Y'' AND COMPANY_ID <> ''-'' GROUP BY LINE_ID, LINE_NAME) L' || CHR(10)
         /* ★전극 공정 이름은 공정 원장 한 곳만 본다 — 조립처럼 Formation 룩업을 합치지 않는다 */
         || '     , (SELECT SA.OPERATION_ID, MAX(SA.OPERATION_NAME) AS OPERATION_NAME'
         || ' FROM SCM_MST_OPERATION_SN SA GROUP BY SA.OPERATION_ID) O' || CHR(10)
         /* ★더미 판정은 더미 품목 코드의 이름과 품목을 맞춘다 */
         || '     , (SELECT SB.CODE, SB.NAME FROM SCP_MST_CAPA_DUMMY_CODE SB'
         || ' WHERE SB.CODE_TP = ''I'') I' || CHR(10)
         || '     , (SELECT SC.COLUMN_NAME AS MEASURE, SC.COLUMN_LABEL_NAME AS MEASURE_NAME'
         || ' , SC.SORT_ORDER_NO FROM SCM_MST_SHEET_MEASURE SC' || CHR(10)
         || '         WHERE SC.PROGRAM_ID = ''' || P_PROGRAM_ID || ''''
         || ' AND SC.SHEET_NAME = ''' || P_SHEET_NAME || ''''
         || ' AND SC.VALID_YN = ''Y'') M' || CHR(10)
         || '     , (SELECT SD.SEGMENT1 AS UNIT_GROUP, SD.SEGMENT3 AS MSR_TP_CD'
         || ' , SD.SEGMENT5 AS UNIT_GROUP_SEQ FROM SCM_ADM_LOOKUP_MASTER_DETAIL SD' || CHR(10)
         || '         WHERE SD.LOOKUP_TYPE = ''OPERATION_SPEED_ELTR_UNIT'''
         || ' AND SD.VALID_YN = ''Y'') G' || CHR(10)
         || '     , (SELECT SE.SEGMENT3 AS ELTR_TP_CD, SE.SEGMENT4 AS ELTR_TP_NM_EN'
         || ' FROM SCM_ADM_LOOKUP_MASTER_DETAIL SE' || CHR(10)
         || '         WHERE SE.LOOKUP_TYPE = ''SCP_CAPA_ELTR_TP'''
         || ' AND SE.VALID_YN = ''Y'') E' || CHR(10)
/* AJS 20261007 속도 — 원본 2줄 (공용 함수 전체 결과 35,844행을 매번 읽는다)
         || '     , (SELECT SF.DIVISION_ID, SF.ITEM_ID, SF.NICK_NAME'
         || ' FROM TABLE(FN_SCM0002_GET_CAPA_ITEM_POPUP('''', '''')) SF) K' || CHR(10)
*/
         /* 약칭 : 공용 함수 FN_SCM0002_GET_CAPA_ITEM_POPUP('', '') 와 같은 조회를 원자료 임시 테이블의 사업부 · 품목으로 한정 — 품목 기준 PK 라 결과 동일 */
         || '     , (SELECT /*+ NO_MERGE(XB) LEADING(XB XC XD) USE_NL(XC XD) */ XC.DIVISION_ID, XC.ITEM_ID' /* AJS 20261007 속도 */
         || ' , MAX(CASE WHEN XD.NICK_NAME IS NULL THEN XC.NICK_NAME ELSE XD.NICK_NAME END) AS NICK_NAME' || CHR(10) /* AJS 20261007 속도 */
         || '          FROM (SELECT DISTINCT XE.DIVISION_ID, XE.ITEM_ID FROM GT_SCP0105_RAW_ELTR XE) XB' /* AJS 20261007 속도 */
         || ' , SCP_MST_FINAL_ITEM XC, SCM_MST_ITEM_SN XD' || CHR(10) /* AJS 20261007 속도 */
         || '         WHERE XC.DIVISION_ID = XB.DIVISION_ID AND XC.ITEM_ID = XB.ITEM_ID' /* AJS 20261007 속도 */
         || ' AND XD.DIVISION_ID = XC.DIVISION_ID AND XD.ITEM_ID = XC.ITEM_ID' || CHR(10) /* AJS 20261007 속도 */
         || '         GROUP BY XC.DIVISION_ID, XC.OPERATION_GROUP, XC.FLOW_ID, XC.ITEM_ID) K' || CHR(10) /* AJS 20261007 속도 */
         || ' WHERE A.SITE_ID = S.SITE_ID(+)' || CHR(10)
         || '   AND A.COMPANY_ID = C.COMPANY_ID(+)' || CHR(10)
         || '   AND A.PLANT_ID = P.PLANT_ID(+)' || CHR(10)
         || '   AND A.FACTORY_ID = F.FACTORY_ID(+)' || CHR(10)
         || '   AND A.LINE_ID = L.LINE_ID(+)' || CHR(10)
         || '   AND A.OPERATION_ID = O.OPERATION_ID(+)' || CHR(10)
         || '   AND A.ITEM_ID = I.NAME(+)' || CHR(10)
         || '   AND A.MSR_TP_CD = M.MEASURE(+)' || CHR(10)
         || '   AND A.SPEED_UNIT_GROUP = G.UNIT_GROUP(+)' || CHR(10)
         || '   AND A.MSR_TP_CD = G.MSR_TP_CD(+)' || CHR(10)
         || '   AND A.ELTR_LN_TP_CD = E.ELTR_TP_CD(+)' || CHR(10)
         || '   AND A.DIVISION_ID = K.DIVISION_ID(+)' || CHR(10)
         || '   AND A.ITEM_ID = K.ITEM_ID(+)' || CHR(10)
         /* ★AS-IS 정렬은 하이픈을 무시하고 대소문자를 가리지 않는다 — 라인 이름에 (-)·(+) 가 섞여
            그냥 두면 같은 라인 쌍의 차례가 뒤바뀐다. 공용 정렬키 함수로 맞춘다. */
         || ' ORDER BY FN_ASIS_SORT_KEY(A.VER_ID) NULLS FIRST' || CHR(10)
         || '        , A.VER_SEQ NULLS FIRST' || CHR(10)
         || '        , FN_ASIS_SORT_KEY(A.DIVISION_ID) NULLS FIRST' || CHR(10)
         || '        , FN_ASIS_SORT_KEY(A.COMPANY_ID) NULLS FIRST' || CHR(10)
         || '        , FN_ASIS_SORT_KEY(S.SITE_NAME) NULLS FIRST' || CHR(10)
         || '        , FN_ASIS_SORT_KEY(P.PLANT_NAME) NULLS FIRST' || CHR(10)
         || '        , FN_ASIS_SORT_KEY(F.FACTORY_NAME) NULLS FIRST' || CHR(10)
         || '        , FN_ASIS_SORT_KEY(L.LINE_NAME) NULLS FIRST' || CHR(10)
         || '        , FN_ASIS_SORT_KEY(A.ITEM_ID) NULLS FIRST' || CHR(10)
         || '        , FN_ASIS_SORT_KEY(K.NICK_NAME) NULLS FIRST' || CHR(10)
         || '        , FN_ASIS_SORT_KEY(A.OPERATION_ID) NULLS FIRST' || CHR(10)
         || '        , FN_ASIS_SORT_KEY(A.ELTR_LN_TP_CD) NULLS FIRST' || CHR(10)
         || '        , M.SORT_ORDER_NO NULLS FIRST'));

        OPEN O_RC1 FOR V_SQL;

        /* Unpivot 용 오리지널 테이블 구조 저장 */
        OPEN O_RC2 FOR
            SELECT VER_ID
                 , VER_SEQ
                 , DIVISION_ID
                 , COMPANY_ID
                 , SITE_ID
                 , PLANT_ID
                 , FACTORY_ID
                 , LINE_ID
                 , OPERATION_ID
                 , ELTR_LN_TP_CD
                 , ITEM_ID
                 , NICK_NAME
                 , MSR_TP_CD
                 , YYYYMM
                 , BASE_QTY
                 , QTY
              FROM SCP_MST_CAPA_ELTR_SPEED_PLAN_CUTF
             WHERE 1 <> 1;

        DBMS_LOB.FREETEMPORARY(V_DATE_COLS);
        DBMS_LOB.FREETEMPORARY(V_PRIORITY_COLS);
        DBMS_LOB.FREETEMPORARY(V_FINAL_SUM_COLS);
        DBMS_LOB.FREETEMPORARY(V_FINAL_SUM_PRIORITY_COLS);
        DBMS_LOB.FREETEMPORARY(V_FINAL_COLS);
        DBMS_LOB.FREETEMPORARY(V_FINAL_PRIORITY_COLS);
        DBMS_LOB.FREETEMPORARY(V_SQL);

    END P_SCP0105_GET_SPEED_CURRENT_ELTR;

    /*******************************************************************************
     * P_SCP0105_GET_SPEED_CUTOFF_ASM  (패키지 안에서만 쓰는 갈래)
     *   AS-IS SCP0105_GET_CAPA_SPEED_PLAN_1ST_CUTOFF_ASSEMBLY — 마감분 조립 조회
     *
     * AS-IS 절차
     *   1. 날짜 칸을 공용 함수에서 받는다. ★현재분과 달리 정렬키 앞 두 자리 99 를 빼지 않는다.
     *   2. 실적(설비 월별 실적) · 기준(모델별 설비 속도)을 각각 묶어 담는다.
     *   3. 마감 라인배정에서 차례가 매겨진 열쇠만 남기고, 마감 속도계획을 그 열쇠로 좁힌다.
     *   4. 속도단위 묶음을 곱해 측정항목별 줄을 만들고 실적 · 기준 · 전극 수량을 붙인다.
     *   5. 열쇠별 평균을 낸 뒤 날짜 칸 수만큼 피벗식을 조립해 동적 조회로 돌려준다.
     *
     * ★MSSQL 은 십진수 평균을 그 자리수에서 자른다(반올림이 아니다) — TRUNC 로 재현한다.
     *   설비 수는 자리수가 0 이라 평균이 정수로 잘린다.
     * ★배정밀도 실수로 계산한 값을 십진수 칸에 담는 자리는 소수 열 자리로 맞춘다.
     * ★원본 MSSQL 주석은 형태 그대로 둔다.
     * 2026.10.07   AJS   조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시
     * 2026.10.07   AJS   조회 속도 : 원자료 적재의 속도단위 묶음 · 전극 수량 결합을 해시 결합으로(결과 동일)
     *******************************************************************************/
    PROCEDURE P_SCP0105_GET_SPEED_CUTOFF_ASM
    (
        P_VERSION               IN  VARCHAR2
      , P_VERSION_SEQ           IN  VARCHAR2
      , P_PROG_STAT             IN  VARCHAR2
      , P_DIVISION_ID           IN  VARCHAR2
      , P_SITE_ID               IN  VARCHAR2
      , P_PLANT_ID              IN  VARCHAR2
      , P_FACTORY_ID            IN  VARCHAR2
      , P_LINE_ID               IN  VARCHAR2
      , P_OPERATION_ID          IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_ELECTRODE_TYPE        IN  VARCHAR2
      , P_PROGRAM_ID            IN  VARCHAR2
      , P_SHEET_NAME            IN  VARCHAR2
      , P_USER_ID               IN  VARCHAR2
      , DEBUG_MODE              IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RC2                   OUT SYS_REFCURSOR
    )
    IS
        V_FROM_YYYYMM               VARCHAR2(6 CHAR);
        V_RESULT_TO_YYYYMM          VARCHAR2(6 CHAR);
        V_DATE_COLS                 CLOB;
        V_FINAL_COLS                CLOB;
        V_OUT_COLS                  CLOB;
        V_SQL                       CLOB;
    BEGIN

        DBMS_LOB.CREATETEMPORARY(V_DATE_COLS, TRUE);
        DBMS_LOB.CREATETEMPORARY(V_FINAL_COLS, TRUE);
        DBMS_LOB.CREATETEMPORARY(V_OUT_COLS, TRUE);
        DBMS_LOB.CREATETEMPORARY(V_SQL, TRUE);

        V_FROM_YYYYMM      := TO_CHAR(ADD_MONTHS(TO_DATE(P_VERSION || '01', 'YYYYMMDD'),  1), 'YYYYMM');
        V_RESULT_TO_YYYYMM := TO_CHAR(ADD_MONTHS(TO_DATE(P_VERSION || '01', 'YYYYMMDD'), -1), 'YYYYMM');

        DELETE FROM GT_SCP0105_CUT_RSLT;
        DELETE FROM GT_SCP0105_CUT_BASE;
        DELETE FROM GT_SCP0105_CUT_BASE_UPD;
        DELETE FROM GT_SCP0105_CUT_ASSIGN;
        DELETE FROM GT_SCP0105_CUT_RAW_ALL_T;
        DELETE FROM GT_SCP0105_CUT_RAW;

        /* 실적 — 설비 월별 실적을 열쇠별로 평균 낸다 */
        INSERT INTO GT_SCP0105_CUT_RSLT
             ( DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID
             , ELTR_LN_TP_CD, NICK_NAME, SPEED_UNIT_GROUP, MSR_TP_CD, EQP_NBU, EQP_SPED, PPM )
        SELECT A.DIVISION_ID
             , A.COMPANY_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.LINE_ID
             , A.OPERATION_ID
             , A.ELTR_LN_TP_CD
             , A.MDL_NM
             , B.UNIT_GROUP
             , UPPER(A.EQP_SPED_UNIT_CD)
             /* ★설비 수는 자리수가 0 이라 평균이 정수로 잘린다 */
             , TRUNC(AVG(A.EQP_NBU), 0)
             , TRUNC(AVG(A.EQP_SPED), 10)
             , AVG(TO_BINARY_DOUBLE(A.ATTRIBUTE1))
          FROM SCM_DNM_EQP_SPED_MMLY A
             , (SELECT IA.SEGMENT1 AS UNIT_GROUP
                     , IA.SEGMENT3 AS MSR_TP_CD
                  FROM SCM_ADM_LOOKUP_MASTER_DETAIL IA
                 WHERE IA.LOOKUP_TYPE = 'OPERATION_SPEED_UNIT'
                   AND IA.VALID_YN    = 'Y'
                 GROUP BY IA.SEGMENT1
                        , IA.SEGMENT3) B
         WHERE A.EQP_SPED_UNIT_CD = B.MSR_TP_CD(+)
           AND A.PERD_DIVS_CD     = '3'
           AND A.PFRSLT_YM        = V_RESULT_TO_YYYYMM
         GROUP BY A.DIVISION_ID
                , A.COMPANY_ID
                , A.SITE_ID
                , A.PLANT_ID
                , A.FACTORY_ID
                , A.LINE_ID
                , A.OPERATION_ID
                , A.ELTR_LN_TP_CD
                , A.MDL_NM
                , B.UNIT_GROUP
                , A.EQP_SPED_UNIT_CD;

        /* 기준 — 모델별 설비 속도 */
        INSERT INTO GT_SCP0105_CUT_BASE
             ( DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID
             , NICK_NAME, ELTR_LN_TP_CD, SPEED_UNIT_GROUP, MSR_TP_CD, EQP_NBU, EQP_SPED, UI_UPD_YN )
        SELECT A.DIVISION_ID
             , A.COMPANY_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.LINE_ID
             , A.OPERATION_ID
             , A.MDL_NM
             , A.ELTR_LN_TP_CD
             , B.UNIT_GROUP
             , UPPER(A.EQP_SPED_UNIT_CD)
             , A.EQP_NBU
             , A.EQP_SPED
             , A.UI_UPD_YN
          FROM SCP_MST_MDL_EQP_SPED A
             , (SELECT IA.SEGMENT1 AS UNIT_GROUP
                     , IA.SEGMENT3 AS MSR_TP_CD
                  FROM SCM_ADM_LOOKUP_MASTER_DETAIL IA
                 WHERE IA.LOOKUP_TYPE = 'OPERATION_SPEED_UNIT'
                   AND IA.VALID_YN    = 'Y'
                 GROUP BY IA.SEGMENT1
                        , IA.SEGMENT3) B
         WHERE A.EQP_SPED_UNIT_CD = B.MSR_TP_CD(+)
           AND A.USE_YN           = 'Y';

        INSERT INTO GT_SCP0105_CUT_BASE_UPD
             ( DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID
             , ELTR_LN_TP_CD, NICK_NAME, UI_UPD_YN )
        SELECT DIVISION_ID
             , COMPANY_ID
             , SITE_ID
             , PLANT_ID
             , FACTORY_ID
             , LINE_ID
             , OPERATION_ID
             , ELTR_LN_TP_CD
             , NICK_NAME
             , MAX(UI_UPD_YN)
          FROM GT_SCP0105_CUT_BASE
         GROUP BY DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , NICK_NAME;

        /* 마감 라인배정 — 차례가 매겨진 열쇠만 */
        INSERT INTO GT_SCP0105_CUT_ASSIGN
             ( VER_ID, VER_SEQ, DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID
             , OPERATION_ID, ELTR_LN_TP_CD, ITEM_ID, NICK_NAME, YYYYMM, ASSIGN_PRIORITY )
        SELECT P_VERSION
             , TO_NUMBER(P_VERSION_SEQ)
             , A.DIVISION_ID
             , A.COMPANY_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.LINE_ID
             , A.OPERATION_ID
             , A.ELTR_LN_TP_CD
             , A.ITEM_ID
             , A.NICK_NAME
             , A.YYYYMM
             , A.ASSIGN_PRIORITY
          FROM SCP_MST_CAPA_LINE_ASSIGN_CUTF A
         WHERE A.VALID_YN = 'Y'
           AND A.OPERATION_ID <> 'AFFFF'
           AND NVL(A.ASSIGN_PRIORITY, 0) <> 0
           AND A.VER_ID  = P_VERSION
           AND A.VER_SEQ = TO_NUMBER(P_VERSION_SEQ)
           AND ( TRIM(P_DIVISION_ID) IS NULL
              OR UPPER(P_DIVISION_ID) = 'ALL'                                   /* 조회조건 ALL 은 조건 없음 */
              OR A.DIVISION_ID IN (SELECT UPPER(COLUMN_VALUE)
                                     FROM TABLE(STRING_SPLIT(P_DIVISION_ID, ','))) )
           AND ( TRIM(P_SITE_ID) IS NULL
              OR UPPER(P_SITE_ID) = 'ALL'
              OR A.SITE_ID IN (SELECT UPPER(COLUMN_VALUE)
                                 FROM TABLE(STRING_SPLIT(P_SITE_ID, ','))) )
           AND ( TRIM(P_PLANT_ID) IS NULL
              OR UPPER(P_PLANT_ID) = 'ALL'
              OR A.PLANT_ID IN (SELECT UPPER(COLUMN_VALUE)
                                  FROM TABLE(STRING_SPLIT(P_PLANT_ID, ','))) )
           AND ( TRIM(P_FACTORY_ID) IS NULL
              OR UPPER(P_FACTORY_ID) = 'ALL'
              OR A.FACTORY_ID IN (SELECT UPPER(COLUMN_VALUE)
                                    FROM TABLE(STRING_SPLIT(P_FACTORY_ID, ','))) )
           AND ( TRIM(P_LINE_ID) IS NULL
              OR UPPER(P_LINE_ID) = 'ALL'
              OR A.LINE_ID IN (SELECT UPPER(COLUMN_VALUE)
                                 FROM TABLE(STRING_SPLIT(P_LINE_ID, ','))) )
           AND ( TRIM(P_OPERATION_ID) IS NULL
              OR UPPER(P_OPERATION_ID) = 'ALL'
              OR A.OPERATION_ID IN (SELECT UPPER(COLUMN_VALUE)
                                      FROM TABLE(STRING_SPLIT(P_OPERATION_ID, ','))) )
           AND ( TRIM(P_ELECTRODE_TYPE) IS NULL
              OR UPPER(P_ELECTRODE_TYPE) = 'ALL'
              /* ★전극구분 칸에는 소문자가 섞여 있다 — 양쪽을 UPPER */
              OR UPPER(A.ELTR_LN_TP_CD) IN (SELECT UPPER(COLUMN_VALUE)
                                              FROM TABLE(STRING_SPLIT(P_ELECTRODE_TYPE, ','))) )
           AND ( ( TRIM(P_ITEM_ID) IS NULL
                OR UPPER(P_ITEM_ID) = 'ALL'
                /* 2026.10.07 AJS Model/Nickname 검색 (START) */
--              OR A.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE)
--                                 FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )
--            OR A.NICK_NAME IN (SELECT COLUMN_VALUE
--                                 FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) );
                OR EXISTS (SELECT 1
                             FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SM
                            WHERE TRIM(SM.COLUMN_VALUE) IS NOT NULL
                              AND (   UPPER(A.ITEM_ID)   LIKE '%' || UPPER(TRIM(SM.COLUMN_VALUE)) || '%'
                                   OR UPPER(A.NICK_NAME) LIKE '%' || UPPER(TRIM(SM.COLUMN_VALUE)) || '%')) ) );
                /* 2026.10.07 AJS Model/Nickname 검색 (END) */

        /* 마감 속도계획을 라인배정 열쇠로 좁힌다 */
        INSERT INTO GT_SCP0105_CUT_RAW_ALL_T
             ( VER_ID, VER_SEQ, DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID
             , OPERATION_ID, ELTR_LN_TP_CD, ITEM_ID, NICK_NAME, MSR_TP_CD, YYYYMM
             , PFRSLT_QTY, BASE_QTY, QTY )
        SELECT A.VER_ID
             , A.VER_SEQ
             , A.DIVISION_ID
             , A.COMPANY_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.LINE_ID
             , A.OPERATION_ID
             , A.ELTR_LN_TP_CD
             , A.ITEM_ID
             , A.NICK_NAME
             , A.MSR_TP_CD
             , A.YYYYMM
             , A.BASE_QTY
             , A.BASE_QTY
             , A.QTY
          FROM SCP_MST_CAPA_SPEED_PLAN_CUTF A
             , GT_SCP0105_CUT_ASSIGN B
         WHERE B.DIVISION_ID   = A.DIVISION_ID
           AND B.COMPANY_ID    = A.COMPANY_ID
           AND B.SITE_ID       = A.SITE_ID
           AND B.PLANT_ID      = A.PLANT_ID
           AND B.FACTORY_ID    = A.FACTORY_ID
           AND B.LINE_ID       = A.LINE_ID
           AND B.OPERATION_ID  = A.OPERATION_ID
           AND B.ELTR_LN_TP_CD = A.ELTR_LN_TP_CD
           AND B.NICK_NAME     = A.NICK_NAME
           AND B.YYYYMM        = A.YYYYMM
           AND NVL(B.ASSIGN_PRIORITY, 0) <> 0
           AND A.OPERATION_ID <> 'AFFFF'
           AND A.VER_ID  = P_VERSION
           AND A.VER_SEQ = TO_NUMBER(P_VERSION_SEQ)
           AND ( TRIM(P_DIVISION_ID) IS NULL
              OR UPPER(P_DIVISION_ID) = 'ALL'
              OR A.DIVISION_ID IN (SELECT UPPER(COLUMN_VALUE)
                                     FROM TABLE(STRING_SPLIT(P_DIVISION_ID, ','))) )
           AND ( TRIM(P_SITE_ID) IS NULL
              OR UPPER(P_SITE_ID) = 'ALL'
              OR A.SITE_ID IN (SELECT UPPER(COLUMN_VALUE)
                                 FROM TABLE(STRING_SPLIT(P_SITE_ID, ','))) )
           AND ( TRIM(P_PLANT_ID) IS NULL
              OR UPPER(P_PLANT_ID) = 'ALL'
              OR A.PLANT_ID IN (SELECT UPPER(COLUMN_VALUE)
                                  FROM TABLE(STRING_SPLIT(P_PLANT_ID, ','))) )
           AND ( TRIM(P_FACTORY_ID) IS NULL
              OR UPPER(P_FACTORY_ID) = 'ALL'
              OR A.FACTORY_ID IN (SELECT UPPER(COLUMN_VALUE)
                                    FROM TABLE(STRING_SPLIT(P_FACTORY_ID, ','))) )
           AND ( TRIM(P_LINE_ID) IS NULL
              OR UPPER(P_LINE_ID) = 'ALL'
              OR A.LINE_ID IN (SELECT UPPER(COLUMN_VALUE)
                                 FROM TABLE(STRING_SPLIT(P_LINE_ID, ','))) )
           AND ( TRIM(P_OPERATION_ID) IS NULL
              OR UPPER(P_OPERATION_ID) = 'ALL'
              OR A.OPERATION_ID IN (SELECT UPPER(COLUMN_VALUE)
                                      FROM TABLE(STRING_SPLIT(P_OPERATION_ID, ','))) )
           AND ( TRIM(P_ELECTRODE_TYPE) IS NULL
              OR UPPER(P_ELECTRODE_TYPE) = 'ALL'
              OR UPPER(A.ELTR_LN_TP_CD) IN (SELECT UPPER(COLUMN_VALUE)
                                              FROM TABLE(STRING_SPLIT(P_ELECTRODE_TYPE, ','))) )
           AND ( ( TRIM(P_ITEM_ID) IS NULL
                OR UPPER(P_ITEM_ID) = 'ALL'
                /* 2026.10.07 AJS Model/Nickname 검색 (START) */
--              OR A.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE)
--                                 FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )
--            OR A.NICK_NAME IN (SELECT COLUMN_VALUE
--                                 FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) );
                OR EXISTS (SELECT 1
                             FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SM
                            WHERE TRIM(SM.COLUMN_VALUE) IS NOT NULL
                              AND (   UPPER(A.ITEM_ID)   LIKE '%' || UPPER(TRIM(SM.COLUMN_VALUE)) || '%'
                                   OR UPPER(A.NICK_NAME) LIKE '%' || UPPER(TRIM(SM.COLUMN_VALUE)) || '%')) ) );
                /* 2026.10.07 AJS Model/Nickname 검색 (END) */

        /* 속도단위 묶음을 곱해 측정항목별 줄을 만들고 실적 · 기준 · 전극 수량을 붙여 평균을 낸다 */
        INSERT INTO GT_SCP0105_CUT_RAW
             ( VER_ID, VER_SEQ, DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID
             , OPERATION_ID, ELTR_LN_TP_CD, ITEM_ID, NICK_NAME, SPEED_UNIT_GROUP, MSR_TP_CD
             , YYYYMM, UI_UPD_YN, PFRSLT_QTY, BASE_QTY, QTY, ELTR_QTY, MMS_CF, PROG_STAT )
        SELECT XA.VER_ID
             , XA.VER_SEQ
             , XA.DIVISION_ID
             , XA.COMPANY_ID
             , XA.SITE_ID
             , XA.PLANT_ID
             , XA.FACTORY_ID
             , XA.LINE_ID
             , XA.OPERATION_ID
             , XA.ELTR_LN_TP_CD
             , XA.ITEM_ID
             , XA.NICK_NAME
             , XA.SPEED_UNIT_GROUP
             , XA.MSR_TP_CD
             , XA.YYYYMM
             , XA.UI_UPD_YN
             /* ★MSSQL 은 십진수 평균을 그 자리수에서 자른다 */
             , TRUNC(AVG(NVL(XA.PFRSLT_QTY, 0)), 10)
             , TRUNC(AVG(NVL(XA.BASE_QTY, 0)), 10)
             , TRUNC(AVG(NVL(XA.QTY, 0)), 10)
             , TRUNC(AVG(NVL(XA.ELTR_QTY, 0)), 10)
             , TRUNC(AVG(NVL(XA.MMS_CF, 0)), 10)
             , P_PROG_STAT
/*        FROM (SELECT IA.VER_ID */
          FROM (SELECT /*+ USE_HASH(Q) */ IA.VER_ID /* AJS 20261007 속도 */
                     , IA.VER_SEQ
                     , IA.DIVISION_ID
                     , IA.COMPANY_ID
                     , IA.SITE_ID
                     , IA.PLANT_ID
                     , IA.FACTORY_ID
                     , IA.LINE_ID
                     , IA.OPERATION_ID
                     , IA.ELTR_LN_TP_CD
                     , IA.ITEM_ID
                     , IA.NICK_NAME
                     , IA.SPEED_UNIT_GROUP
                     , IA.MSR_TP_CD
                     , IA.YYYYMM
                     , CASE WHEN IA.SPEED_UNIT_GROUP = 'EQP_SPED' THEN R.EQP_SPED   /* ★실적 속도다(기준이 아니다) */
                            WHEN IA.SPEED_UNIT_GROUP = 'EQP_NBU'  THEN R.EQP_NBU
                            ELSE ROUND(R.PPM, 10)
                       END                                              AS PFRSLT_QTY
                     , X.BASE_QTY
                     , X.QTY
                     , Q.ELTR_QTY
                     , ROUND(Q.ELTR_QTY * Q.ELTR_PCH_LEN, 10)           AS MMS_CF
                     , NVL(BU.UI_UPD_YN, 'Y')                           AS UI_UPD_YN
/*                FROM (SELECT SA.VER_ID */
                  FROM (SELECT /*+ LEADING(SA SB) USE_HASH(SB) */ SA.VER_ID /* AJS 20261007 속도 */
                             , SA.VER_SEQ
                             , SA.DIVISION_ID
                             , SA.COMPANY_ID
                             , SA.SITE_ID
                             , SA.PLANT_ID
                             , SA.FACTORY_ID
                             , SA.LINE_ID
                             , SA.OPERATION_ID
                             , SA.ELTR_LN_TP_CD
                             , SA.ITEM_ID
                             , SA.NICK_NAME
                             , SB.UNIT_GROUP AS SPEED_UNIT_GROUP
                             , SA.MSR_TP_CD
                             , SA.YYYYMM
                          FROM GT_SCP0105_CUT_RAW_ALL_T SA
                             , (SELECT SC.SEGMENT1 AS UNIT_GROUP
                                  FROM SCM_ADM_LOOKUP_MASTER_DETAIL SC
                                 WHERE SC.LOOKUP_TYPE = 'OPERATION_SPEED_UNIT'
                                   AND SC.VALID_YN    = 'Y'
                                 GROUP BY SC.SEGMENT1) SB
                         WHERE ( SB.UNIT_GROUP = 'EQP_NBU'  AND SA.MSR_TP_CD IN ('EQP_NBU')
                              OR SB.UNIT_GROUP = 'PPM'      AND SA.MSR_TP_CD IN ('PPM')
                              OR SB.UNIT_GROUP = 'EQP_SPED' AND SA.MSR_TP_CD IN ('MMS', 'CPM', 'PPM_AVG', 'TTT') )
                         GROUP BY SA.VER_ID
                                , SA.VER_SEQ
                                , SA.DIVISION_ID
                                , SA.COMPANY_ID
                                , SA.SITE_ID
                                , SA.PLANT_ID
                                , SA.FACTORY_ID
                                , SA.LINE_ID
                                , SA.OPERATION_ID
                                , SA.ELTR_LN_TP_CD
                                , SA.ITEM_ID
                                , SA.NICK_NAME
                                , SB.UNIT_GROUP
                                , SA.MSR_TP_CD
                                , SA.YYYYMM) IA
                     , GT_SCP0105_CUT_RAW_ALL_T X
                     , GT_SCP0105_CUT_RSLT R
                     , GT_SCP0105_CUT_BASE B
                     , SCP_MST_MDL_ELTR_QTY Q
                     , GT_SCP0105_CUT_BASE_UPD BU
                 WHERE X.VER_ID(+)         = IA.VER_ID
                   AND X.VER_SEQ(+)        = IA.VER_SEQ
                   AND X.DIVISION_ID(+)    = IA.DIVISION_ID
                   AND X.COMPANY_ID(+)     = IA.COMPANY_ID
                   AND X.SITE_ID(+)        = IA.SITE_ID
                   AND X.PLANT_ID(+)       = IA.PLANT_ID
                   AND X.FACTORY_ID(+)     = IA.FACTORY_ID
                   AND X.LINE_ID(+)        = IA.LINE_ID
                   AND X.OPERATION_ID(+)   = IA.OPERATION_ID
                   AND X.ELTR_LN_TP_CD(+)  = IA.ELTR_LN_TP_CD
                   AND X.ITEM_ID(+)        = IA.ITEM_ID
                   AND X.NICK_NAME(+)      = IA.NICK_NAME
                   AND X.MSR_TP_CD(+)      = IA.MSR_TP_CD
                   AND X.YYYYMM(+)         = IA.YYYYMM
                   AND R.DIVISION_ID(+)    = IA.DIVISION_ID
                   AND R.COMPANY_ID(+)     = IA.COMPANY_ID
                   AND R.SITE_ID(+)        = IA.SITE_ID
                   AND R.PLANT_ID(+)       = IA.PLANT_ID
                   AND R.FACTORY_ID(+)     = IA.FACTORY_ID
                   AND R.LINE_ID(+)        = IA.LINE_ID
                   AND R.OPERATION_ID(+)   = IA.OPERATION_ID
                   AND R.ELTR_LN_TP_CD(+)  = IA.ELTR_LN_TP_CD
                   AND B.DIVISION_ID(+)    = IA.DIVISION_ID
                   AND B.COMPANY_ID(+)     = IA.COMPANY_ID
                   AND B.SITE_ID(+)        = IA.SITE_ID
                   AND B.PLANT_ID(+)       = IA.PLANT_ID
                   AND B.FACTORY_ID(+)     = IA.FACTORY_ID
                   AND B.LINE_ID(+)        = IA.LINE_ID
                   AND B.OPERATION_ID(+)   = IA.OPERATION_ID
                   /* ★품목이 '-' 이면 약칭으로 맞춘다 */
                   AND B.NICK_NAME(+)      = CASE WHEN IA.ITEM_ID = '-' THEN IA.NICK_NAME ELSE IA.ITEM_ID END
                   AND B.ELTR_LN_TP_CD(+)  = IA.ELTR_LN_TP_CD
                   AND Q.NICK_NM(+)        = CASE WHEN IA.ITEM_ID = '-' THEN IA.NICK_NAME ELSE IA.ITEM_ID END
                   AND Q.ELTR_LN_TP_CD(+)  = IA.ELTR_LN_TP_CD
                   AND BU.DIVISION_ID(+)   = IA.DIVISION_ID
                   AND BU.COMPANY_ID(+)    = IA.COMPANY_ID
                   AND BU.SITE_ID(+)       = IA.SITE_ID
                   AND BU.PLANT_ID(+)      = IA.PLANT_ID
                   AND BU.FACTORY_ID(+)    = IA.FACTORY_ID
                   AND BU.LINE_ID(+)       = IA.LINE_ID
                   AND BU.OPERATION_ID(+)  = IA.OPERATION_ID
                   AND BU.ELTR_LN_TP_CD(+) = IA.ELTR_LN_TP_CD
                   AND BU.NICK_NAME(+)     = CASE WHEN IA.ITEM_ID = '-' THEN IA.NICK_NAME ELSE IA.ITEM_ID END) XA
         GROUP BY XA.VER_ID
                , XA.VER_SEQ
                , XA.DIVISION_ID
                , XA.COMPANY_ID
                , XA.SITE_ID
                , XA.PLANT_ID
                , XA.FACTORY_ID
                , XA.LINE_ID
                , XA.OPERATION_ID
                , XA.ELTR_LN_TP_CD
                , XA.ITEM_ID
                , XA.NICK_NAME
                , XA.SPEED_UNIT_GROUP
                , XA.MSR_TP_CD
                , XA.YYYYMM
                , XA.UI_UPD_YN;

        /* 날짜 칸 수만큼 피벗식을 조립한다. ★마감분은 정렬키 99 를 빼지 않는다 */
        FOR C IN ( SELECT A.COLUMN_NAME
                     FROM TABLE(FN_SCP0104_GET_SPREAD_TITLE(V_FROM_YYYYMM, P_PROGRAM_ID, P_SHEET_NAME)) A
                    ORDER BY A.SORT_ORDER_NO )
        LOOP
            IF INSTR(C.COLUMN_NAME, 'M_') = 1 THEN
                DBMS_LOB.APPEND(V_DATE_COLS, TO_CLOB(CHR(10) || '     , CAST(CASE WHEN YYYYMM = '''
                    || SUBSTR(C.COLUMN_NAME, 5, 6) || ''' THEN QTY END AS BINARY_DOUBLE) AS ' || C.COLUMN_NAME));
            ELSIF INSTR(C.COLUMN_NAME, 'Y_') = 1 THEN
                DBMS_LOB.APPEND(V_DATE_COLS, TO_CLOB(CHR(10) || '     , CAST(CASE WHEN YYYYMM = '''
                    || SUBSTR(C.COLUMN_NAME, 3, 4) || ''' THEN QTY END AS BINARY_DOUBLE) AS ' || C.COLUMN_NAME));
            END IF;

            DBMS_LOB.APPEND(V_FINAL_COLS, TO_CLOB(CHR(10) || '     , MAX(' || C.COLUMN_NAME
                || ') AS ' || C.COLUMN_NAME));
            DBMS_LOB.APPEND(V_OUT_COLS, TO_CLOB(CHR(10) || '     , A.' || C.COLUMN_NAME));
        END LOOP;

        DBMS_LOB.APPEND(V_SQL, TO_CLOB(
            'SELECT A.VER_ID' || CHR(10)
         || '     , A.VER_SEQ' || CHR(10)
         || '     , A.DIVISION_ID' || CHR(10)
         || '     , A.COMPANY_ID' || CHR(10)
         || '     , A.SITE_ID' || CHR(10)
         || '     , A.PLANT_ID' || CHR(10)
         || '     , A.FACTORY_ID' || CHR(10)
         || '     , A.LINE_ID' || CHR(10)
         || '     , A.OPERATION_ID' || CHR(10)
         || '     , A.ELTR_LN_TP_CD' || CHR(10)
         || '     , A.ITEM_ID' || CHR(10)
         || '     , A.NICK_NAME' || CHR(10)
         || '     , A.SPEED_UNIT_GROUP' || CHR(10)
         || '     , A.MSR_TP_CD' || CHR(10)
         || '     , A.PFRSLT_QTY' || CHR(10)
         || '     , A.BASE_QTY' || CHR(10)
         || '     , A.ELTR_QTY' || CHR(10)
         || '     , A.MMS_CF' || CHR(10)
         || '     , A.UI_UPD_YN'));
        DBMS_LOB.APPEND(V_SQL, V_OUT_COLS);
        DBMS_LOB.APPEND(V_SQL, TO_CLOB(CHR(10)
         || '     , M.MEASURE_NAME' || CHR(10)
         || '     , M.SORT_ORDER_NO' || CHR(10)
         || '     , G.UNIT_GROUP_SEQ AS SPEED_UNIT_GROUP_SEQ' || CHR(10)
         /* NICK_NAME 더미 여부는 Speed Plan 입력항목(Meaasrue) 을 결정하므로 따로 저장해둔다 */
         || '     , CASE WHEN N.CODE IS NOT NULL THEN ''Y'' ELSE ''N'' END AS NICK_NAME_DUMMY_YN' || CHR(10)
         || '     , FN_GET_DIVISION_NAME(A.DIVISION_ID) AS DIVISION_NAME' || CHR(10)
         || '     , S.SITE_NAME AS SITE_NAME' || CHR(10)
         || '     , P.PLANT_NAME AS PLANT_NAME' || CHR(10)
         || '     , F.FACTORY_NAME AS FACTORY_NAME' || CHR(10)
         || '     , L.LINE_NAME AS LINE_NAME' || CHR(10)
         || '     , O.OPERATION_NAME' || CHR(10)
         || '     , M.ATTRIBUTE3 AS MEASURE_COLOR' || CHR(10)
         || '  FROM (SELECT IA.VER_ID' || CHR(10)
         || '             , IA.VER_SEQ' || CHR(10)
         || '             , IA.DIVISION_ID' || CHR(10)
         || '             , IA.COMPANY_ID' || CHR(10)
         || '             , IA.SITE_ID' || CHR(10)
         || '             , IA.PLANT_ID' || CHR(10)
         || '             , IA.FACTORY_ID' || CHR(10)
         || '             , IA.LINE_ID' || CHR(10)
         || '             , IA.OPERATION_ID' || CHR(10)
         || '             , IA.ELTR_LN_TP_CD' || CHR(10)
         || '             , IA.ITEM_ID' || CHR(10)
         || '             , IA.NICK_NAME' || CHR(10)
         || '             , IA.SPEED_UNIT_GROUP' || CHR(10)
         || '             , IA.MSR_TP_CD' || CHR(10)
         || '             , IA.UI_UPD_YN' || CHR(10)
         || '             , MAX(IA.PFRSLT_QTY) AS PFRSLT_QTY' || CHR(10)
         || '             , MAX(IA.BASE_QTY) AS BASE_QTY' || CHR(10)
         || '             , MAX(IA.ELTR_QTY) AS ELTR_QTY' || CHR(10)
         || '             , MAX(IA.MMS_CF) AS MMS_CF'));
        DBMS_LOB.APPEND(V_SQL, REPLACE(V_FINAL_COLS, CHR(10) || '     , ', CHR(10) || '             , '));
        DBMS_LOB.APPEND(V_SQL, TO_CLOB(CHR(10)
         || '          FROM (SELECT XA.VER_ID' || CHR(10)
         || '                     , XA.VER_SEQ' || CHR(10)
         || '                     , XA.DIVISION_ID' || CHR(10)
         || '                     , XA.COMPANY_ID' || CHR(10)
         || '                     , XA.SITE_ID' || CHR(10)
         || '                     , XA.PLANT_ID' || CHR(10)
         || '                     , XA.FACTORY_ID' || CHR(10)
         || '                     , XA.LINE_ID' || CHR(10)
         || '                     , XA.OPERATION_ID' || CHR(10)
         || '                     , XA.ELTR_LN_TP_CD' || CHR(10)
         || '                     , XA.ITEM_ID' || CHR(10)
         || '                     , XA.NICK_NAME' || CHR(10)
         || '                     , XA.SPEED_UNIT_GROUP' || CHR(10)
         || '                     , XA.MSR_TP_CD' || CHR(10)
         || '                     , XA.UI_UPD_YN' || CHR(10)
         || '                     , XA.PFRSLT_QTY' || CHR(10)
         || '                     , XA.BASE_QTY' || CHR(10)
         || '                     , XA.ELTR_QTY' || CHR(10)
         || '                     , XA.MMS_CF'));
        DBMS_LOB.APPEND(V_SQL, REPLACE(V_DATE_COLS, CHR(10) || '     , ', CHR(10) || '                     , '));
        DBMS_LOB.APPEND(V_SQL, TO_CLOB(CHR(10)
         || '                  FROM GT_SCP0105_CUT_RAW XA) IA' || CHR(10)
         || '         GROUP BY IA.VER_ID' || CHR(10)
         || '                , IA.VER_SEQ' || CHR(10)
         || '                , IA.DIVISION_ID' || CHR(10)
         || '                , IA.COMPANY_ID' || CHR(10)
         || '                , IA.SITE_ID' || CHR(10)
         || '                , IA.PLANT_ID' || CHR(10)
         || '                , IA.FACTORY_ID' || CHR(10)
         || '                , IA.LINE_ID' || CHR(10)
         || '                , IA.OPERATION_ID' || CHR(10)
         || '                , IA.ELTR_LN_TP_CD' || CHR(10)
         || '                , IA.ITEM_ID' || CHR(10)
         || '                , IA.NICK_NAME' || CHR(10)
         || '                , IA.SPEED_UNIT_GROUP' || CHR(10)
         || '                , IA.MSR_TP_CD' || CHR(10)
         || '                , IA.UI_UPD_YN) A' || CHR(10)
         || '     , (SELECT SITE_ID, SITE_NAME FROM SCP_MST_CAPA_LINE WHERE VALID_YN = ''Y'''
         || ' GROUP BY SITE_ID, SITE_NAME) S' || CHR(10)
         || '     , (SELECT COMPANY_ID, COMPANY_NAME FROM SCP_MST_CAPA_LINE WHERE VALID_YN = ''Y'''
         || ' GROUP BY COMPANY_ID, COMPANY_NAME) C' || CHR(10)
         || '     , (SELECT PLANT_ID, PLANT_NAME FROM SCP_MST_CAPA_LINE WHERE VALID_YN = ''Y'''
         || ' GROUP BY PLANT_ID, PLANT_NAME) P' || CHR(10)
         || '     , (SELECT FACTORY_ID, FACTORY_NAME FROM SCP_MST_CAPA_LINE WHERE VALID_YN = ''Y'''
         || ' GROUP BY FACTORY_ID, FACTORY_NAME) F' || CHR(10)
         || '     , (SELECT LINE_ID, LINE_NAME FROM SCP_MST_CAPA_LINE WHERE VALID_YN = ''Y'''
         || ' GROUP BY LINE_ID, LINE_NAME) L' || CHR(10)
         || '     , (SELECT SA.OPERATION_ID, MAX(SA.OPERATION_NAME) AS OPERATION_NAME'
         || ' FROM SCM_MST_OPERATION_SN SA GROUP BY SA.OPERATION_ID' || CHR(10)
         || '        UNION ALL' || CHR(10)
         || '        SELECT SC.SEGMENT1, SC.ATTRIBUTE1 FROM SCM_ADM_LOOKUP_MASTER SB'
         || '           , SCM_ADM_LOOKUP_MASTER_DETAIL SC' || CHR(10)
         || '         WHERE SB.LOOKUP_TYPE = SC.LOOKUP_TYPE AND SB.LOOKUP_GROUP = ''SCP'''
         || ' AND SB.LOOKUP_TYPE = ''CPS_FORMATION_OPERATION'' AND SC.VALID_YN = ''Y'''
         || ' GROUP BY SC.SEGMENT1, SC.ATTRIBUTE1) O' || CHR(10)
         /* ★마감분 더미 판정은 더미 약칭 코드의 이름과 약칭을 맞춘다 */
         || '     , (SELECT MAX(SD.CODE) AS CODE, SD.NAME FROM SCP_MST_CAPA_DUMMY_CODE SD'
         || ' WHERE SD.CODE_TP = ''N'' GROUP BY SD.NAME) N' || CHR(10)
         || '     , (SELECT SE.COLUMN_NAME AS MEASURE, SE.COLUMN_LABEL_NAME AS MEASURE_NAME'
         || ' , SE.SORT_ORDER_NO, SE.ATTRIBUTE3 FROM SCM_MST_SHEET_MEASURE SE' || CHR(10)
         || '         WHERE SE.PROGRAM_ID = ''' || P_PROGRAM_ID || ''''
         || ' AND SE.SHEET_NAME = ''' || P_SHEET_NAME || ''''
         || ' AND SE.VALID_YN = ''Y'') M' || CHR(10)
         || '     , (SELECT SF.SEGMENT1 AS UNIT_GROUP, SF.SEGMENT3 AS MSR_TP_CD'
         || ' , SF.SEGMENT5 AS UNIT_GROUP_SEQ FROM SCM_ADM_LOOKUP_MASTER_DETAIL SF' || CHR(10)
         || '         WHERE SF.LOOKUP_TYPE = ''OPERATION_SPEED_UNIT'' AND SF.VALID_YN = ''Y'') G' || CHR(10)
         || ' WHERE A.SITE_ID = S.SITE_ID(+)' || CHR(10)
         || '   AND A.COMPANY_ID = C.COMPANY_ID(+)' || CHR(10)
         || '   AND A.PLANT_ID = P.PLANT_ID(+)' || CHR(10)
         || '   AND A.FACTORY_ID = F.FACTORY_ID(+)' || CHR(10)
         || '   AND A.LINE_ID = L.LINE_ID(+)' || CHR(10)
         || '   AND A.OPERATION_ID = O.OPERATION_ID(+)' || CHR(10)
         || '   AND A.NICK_NAME = N.NAME(+)' || CHR(10)
         || '   AND A.MSR_TP_CD = M.MEASURE(+)' || CHR(10)
         || '   AND A.SPEED_UNIT_GROUP = G.UNIT_GROUP(+)' || CHR(10)
         || '   AND A.MSR_TP_CD = G.MSR_TP_CD(+)' || CHR(10)
         /* ★AS-IS 정렬은 하이픈을 무시하고 대소문자를 가리지 않는다 */
         || ' ORDER BY FN_ASIS_SORT_KEY(A.VER_ID) NULLS FIRST' || CHR(10)
         || '        , A.VER_SEQ NULLS FIRST' || CHR(10)
         || '        , FN_ASIS_SORT_KEY(A.DIVISION_ID) NULLS FIRST' || CHR(10)
         || '        , FN_ASIS_SORT_KEY(A.COMPANY_ID) NULLS FIRST' || CHR(10)
         || '        , FN_ASIS_SORT_KEY(S.SITE_NAME) NULLS FIRST' || CHR(10)
         || '        , FN_ASIS_SORT_KEY(P.PLANT_NAME) NULLS FIRST' || CHR(10)
         || '        , FN_ASIS_SORT_KEY(F.FACTORY_NAME) NULLS FIRST' || CHR(10)
         || '        , FN_ASIS_SORT_KEY(L.LINE_NAME) NULLS FIRST' || CHR(10)
         || '        , FN_ASIS_SORT_KEY(A.ITEM_ID) NULLS FIRST' || CHR(10)
         || '        , FN_ASIS_SORT_KEY(A.NICK_NAME) NULLS FIRST' || CHR(10)
         || '        , FN_ASIS_SORT_KEY(A.OPERATION_ID) NULLS FIRST' || CHR(10)
         || '        , FN_ASIS_SORT_KEY(A.ELTR_LN_TP_CD) NULLS FIRST' || CHR(10)
         || '        , FN_ASIS_SORT_KEY(G.UNIT_GROUP_SEQ) NULLS FIRST' || CHR(10)
         || '        , M.SORT_ORDER_NO NULLS FIRST'));

        OPEN O_RC1 FOR V_SQL;

        /* Unpivot 용 오리지널 테이블 구조 저장 */
        OPEN O_RC2 FOR
            SELECT VER_ID
                 , VER_SEQ
                 , DIVISION_ID
                 , COMPANY_ID
                 , SITE_ID
                 , PLANT_ID
                 , FACTORY_ID
                 , LINE_ID
                 , OPERATION_ID
                 , ELTR_LN_TP_CD
                 , ITEM_ID
                 , NICK_NAME
                 , MSR_TP_CD
                 , YYYYMM
                 , BASE_QTY
                 , QTY
              FROM SCP_MST_CAPA_SPEED_PLAN_CUTF
             WHERE 1 <> 1;

        DBMS_LOB.FREETEMPORARY(V_DATE_COLS);
        DBMS_LOB.FREETEMPORARY(V_FINAL_COLS);
        DBMS_LOB.FREETEMPORARY(V_OUT_COLS);
        DBMS_LOB.FREETEMPORARY(V_SQL);

    END P_SCP0105_GET_SPEED_CUTOFF_ASM;

    /*******************************************************************************
     * P_SCP0105_GET_SPEED_CUTOFF_ELTR  (패키지 안에서만 쓰는 갈래)
     *   AS-IS SCP0105_GET_CAPA_SPEED_PLAN_1ST_CUTOFF_ELTR — 마감분 전극 조회
     *
     * ★조립 마감분과 갈리는 곳
     *   - 실적을 전극 전용 원장(SCM_DNM_ELTR_EQP_SPED_MMLY)에서 읽고 모델명을 품목으로 쓴다(약칭은 '-')
     *   - 기준을 모델별 설비 속도가 아니라 **설비 원장**에서 만든다
     *     (SCM_MST_EQUIPMENT_SN + 설비 생산속도, 공정 E2000 계열 · 설비유형 M · 사용중)
     *   - 측정항목이 EQP_SPED 한 가지뿐이라 속도단위 묶음을 곱하지 않는다
     *   - 기준값이 없으면 설비 속도로 갈음한다
     *   - 수량 칸이 십진수가 아니라 배정밀도 실수라 평균에서 자리수가 잘리지 않는다
     *   - 약칭은 사업부+품목으로 가져온 값을 돌려준다 · 더미 판정은 더미 품목 코드의 이름으로
     *   - 결과 칸 끝이 측정항목 색상이 아니라 설비 아이디 · 설비 이름이다
     *   - 정렬에 속도단위 순번이 없다(AS-IS 에 주석 처리되어 있다)
     * ★라인배정은 유효여부만 걸러 전량을 담는다(버전 · 조회조건을 걸지 않는다) — AS-IS 그대로.
     * ★원본 MSSQL 주석은 형태 그대로 둔다.
     * 2026.10.07   AJS   조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시
     * 2026.10.07   AJS   조회 속도 : 라인배정 전량 임시 적재를 빼고 원장 직접 결합 · 약칭을 원자료 품목으로 한정(결과 동일)
     *******************************************************************************/
    PROCEDURE P_SCP0105_GET_SPEED_CUTOFF_ELTR
    (
        P_VERSION               IN  VARCHAR2
      , P_VERSION_SEQ           IN  VARCHAR2
      , P_PROG_STAT             IN  VARCHAR2
      , P_DIVISION_ID           IN  VARCHAR2
      , P_SITE_ID               IN  VARCHAR2
      , P_PLANT_ID              IN  VARCHAR2
      , P_FACTORY_ID            IN  VARCHAR2
      , P_LINE_ID               IN  VARCHAR2
      , P_OPERATION_ID          IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_ELECTRODE_TYPE        IN  VARCHAR2
      , P_PROGRAM_ID            IN  VARCHAR2
      , P_SHEET_NAME            IN  VARCHAR2
      , P_USER_ID               IN  VARCHAR2
      , DEBUG_MODE              IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RC2                   OUT SYS_REFCURSOR
    )
    IS
        V_FROM_YYYYMM               VARCHAR2(6 CHAR);
        V_RESULT_TO_YYYYMM          VARCHAR2(6 CHAR);
        V_DATE_COLS                 CLOB;
        V_FINAL_COLS                CLOB;
        V_OUT_COLS                  CLOB;
        V_SQL                       CLOB;
    BEGIN

        DBMS_LOB.CREATETEMPORARY(V_DATE_COLS, TRUE);
        DBMS_LOB.CREATETEMPORARY(V_FINAL_COLS, TRUE);
        DBMS_LOB.CREATETEMPORARY(V_OUT_COLS, TRUE);
        DBMS_LOB.CREATETEMPORARY(V_SQL, TRUE);

        V_FROM_YYYYMM      := TO_CHAR(ADD_MONTHS(TO_DATE(P_VERSION || '01', 'YYYYMMDD'),  1), 'YYYYMM');
        V_RESULT_TO_YYYYMM := TO_CHAR(ADD_MONTHS(TO_DATE(P_VERSION || '01', 'YYYYMMDD'), -1), 'YYYYMM');

        DELETE FROM GT_SCP0105_CUT_RSLT;
        DELETE FROM GT_SCP0105_CUT_EQP;
        DELETE FROM GT_SCP0105_CUT_BASE;
        DELETE FROM GT_SCP0105_CUT_BASE_UPD;
        DELETE FROM GT_SCP0105_CUT_ASSIGN;
        DELETE FROM GT_SCP0105_CUT_RAW_ALL_T;
        DELETE FROM GT_SCP0105_CUT_RAW_ELTR;

        /* 실적 — 전극 설비 월별 실적을 열쇠별로 평균 낸다. 모델명이 품목 자리다 */
        INSERT INTO GT_SCP0105_CUT_RSLT
             ( DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID
             , ELTR_LN_TP_CD, ITEM_ID, NICK_NAME, SPEED_UNIT_GROUP, MSR_TP_CD, EQP_NBU, EQP_SPED )
        SELECT A.DIVISION_ID
             , A.COMPANY_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.LINE_ID
             , A.OPERATION_ID
             , A.ELTR_LN_TP_CD
             , A.MDL_NM
             , '/'
             , B.UNIT_GROUP
             , UPPER(A.EQP_SPED_UNIT_CD)
             /* ★MSSQL 은 십진수 평균을 그 자리수에서 자른다 */
             , TRUNC(AVG(A.EQP_NBU), 10)
             , TRUNC(AVG(A.EQP_SPED), 10)
          FROM SCM_DNM_ELTR_EQP_SPED_MMLY A
             , (SELECT IA.SEGMENT1 AS UNIT_GROUP
                     , IA.SEGMENT3 AS MSR_TP_CD
                  FROM SCM_ADM_LOOKUP_MASTER_DETAIL IA
                 WHERE IA.LOOKUP_TYPE = 'OPERATION_SPEED_ELTR_UNIT'
                   AND IA.VALID_YN    = 'Y'
                 GROUP BY IA.SEGMENT1
                        , IA.SEGMENT3) B
         WHERE A.EQP_SPED_UNIT_CD = B.MSR_TP_CD(+)
           AND A.PERD_DIVS_CD     = '3'
           AND A.PFRSLT_YM        = V_RESULT_TO_YYYYMM
         GROUP BY A.DIVISION_ID
                , A.COMPANY_ID
                , A.SITE_ID
                , A.PLANT_ID
                , A.FACTORY_ID
                , A.LINE_ID
                , A.OPERATION_ID
                , A.ELTR_LN_TP_CD
                , A.MDL_NM
                , B.UNIT_GROUP
                , A.EQP_SPED_UNIT_CD;

        /* 설비 — 설비 원장과 설비 생산속도를 맞춰 가장 최근 것만 남긴다 */
        /* ★기준 테이블을 모델별 설비 속도에서 설비 원장으로 갈음한 자리다 */
        INSERT INTO GT_SCP0105_CUT_EQP
             ( COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID
             , EQUIPMENT_ID, EQUIPMENT_NAME, ELTR_LN_TP_CD, ITEM_ID, EQP_SPED )
        SELECT IA.COMPANY_ID
             , IA.DIVISION_ID
             , IA.SITE_ID
             , IA.PLANT_ID
             , IA.FACTORY_ID
             , IA.LINE_ID
             , IA.OPERATION_ID
             , IA.EQUIPMENT_ID
             , IA.EQUIPMENT_NAME
             , IA.ELTR_LN_TP_CD
             , IA.BOM_ITEM_ID
             , TRUNC(AVG(IA.EQP_SPED), 5)
          FROM (SELECT A.COMPANY_ID
                     , A.DIVISION_ID
                     , A.SITE_ID
                     , A.PLANT_ID
                     , A.FACTORY_ID
                     , A.LINE_ID
                     , A.OPERATION_ID
                     , B.BOM_ITEM_ID
                     , A.EQUIPMENT_ID
                     , A.EQUIPMENT_NAME
                     , CASE WHEN A.WIDE_ROLL_ENABLE_FLAG = 'Y' THEN 'W' ELSE 'S' END AS ELTR_LN_TP_CD
                     , B.EQP_SPED
                     , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID
                                                    , A.SITE_ID
                                                    , A.COMPANY_ID
                                                    , A.PLANT_ID
                                                    , A.LINE_ID
                                                    , A.OPERATION_ID
                                                    , B.BOM_ITEM_ID
                                              ORDER BY B.UPDATE_TIME DESC
                                                    , A.UPDATE_TIME DESC) AS RN
                  FROM SCM_MST_EQUIPMENT_SN A
                     , SCM_MMD_EQPT_PRDT_SPEED_SN B
                 WHERE B.EQP_ID = A.EQUIPMENT_ID
                   AND A.OPERATION_ID LIKE 'E2000%'
                   AND A.EQUIPMENT_TYPE = 'M'
                   AND A.ACTIVE_FLAG    = 'Y') IA
         WHERE IA.RN = 1
         GROUP BY IA.COMPANY_ID
                , IA.DIVISION_ID
                , IA.SITE_ID
                , IA.PLANT_ID
                , IA.FACTORY_ID
                , IA.LINE_ID
                , IA.OPERATION_ID
                , IA.EQUIPMENT_ID
                , IA.EQUIPMENT_NAME
                , IA.ELTR_LN_TP_CD
                , IA.BOM_ITEM_ID;

        /* 기준 — 설비 속도를 조회조건으로 좁힌다 */
        INSERT INTO GT_SCP0105_CUT_BASE
             ( DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID
             , ITEM_ID, NICK_NAME, ELTR_LN_TP_CD, SPEED_UNIT_GROUP, MSR_TP_CD, EQP_SPED, UI_UPD_YN )
        SELECT A.DIVISION_ID
             , A.COMPANY_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.LINE_ID
             , A.OPERATION_ID
             , A.ITEM_ID
             , '/'
             , A.ELTR_LN_TP_CD
             , 'EQP_SPED'
             , 'EQP_SPED'
             , A.EQP_SPED
             , 'N'
          FROM GT_SCP0105_CUT_EQP A
         WHERE ( TRIM(P_DIVISION_ID) IS NULL
              OR UPPER(P_DIVISION_ID) = 'ALL'                                   /* 조회조건 ALL 은 조건 없음 */
              OR A.DIVISION_ID IN (SELECT UPPER(COLUMN_VALUE)
                                     FROM TABLE(STRING_SPLIT(P_DIVISION_ID, ','))) )
           AND ( TRIM(P_SITE_ID) IS NULL
              OR UPPER(P_SITE_ID) = 'ALL'
              OR A.SITE_ID IN (SELECT UPPER(COLUMN_VALUE)
                                 FROM TABLE(STRING_SPLIT(P_SITE_ID, ','))) )
           AND ( TRIM(P_PLANT_ID) IS NULL
              OR UPPER(P_PLANT_ID) = 'ALL'
              OR A.PLANT_ID IN (SELECT UPPER(COLUMN_VALUE)
                                  FROM TABLE(STRING_SPLIT(P_PLANT_ID, ','))) )
           AND ( TRIM(P_FACTORY_ID) IS NULL
              OR UPPER(P_FACTORY_ID) = 'ALL'
              OR A.FACTORY_ID IN (SELECT UPPER(COLUMN_VALUE)
                                    FROM TABLE(STRING_SPLIT(P_FACTORY_ID, ','))) )
           AND ( TRIM(P_LINE_ID) IS NULL
              OR UPPER(P_LINE_ID) = 'ALL'
              OR A.LINE_ID IN (SELECT UPPER(COLUMN_VALUE)
                                 FROM TABLE(STRING_SPLIT(P_LINE_ID, ','))) )
           AND ( TRIM(P_OPERATION_ID) IS NULL
              OR UPPER(P_OPERATION_ID) = 'ALL'
              OR A.OPERATION_ID IN (SELECT UPPER(COLUMN_VALUE)
                                      FROM TABLE(STRING_SPLIT(P_OPERATION_ID, ','))) )
           AND ( TRIM(P_ELECTRODE_TYPE) IS NULL
              OR UPPER(P_ELECTRODE_TYPE) = 'ALL'
              OR UPPER(A.ELTR_LN_TP_CD) IN (SELECT UPPER(COLUMN_VALUE)
                                              FROM TABLE(STRING_SPLIT(P_ELECTRODE_TYPE, ','))) )
           AND ( TRIM(P_ITEM_ID) IS NULL
              OR UPPER(P_ITEM_ID) = 'ALL'
              /* 2026.10.07 AJS Model/Nickname 검색 (START) */
--            OR A.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE)
--                               FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) );
              OR EXISTS (SELECT 1
                           FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SM
                          WHERE TRIM(SM.COLUMN_VALUE) IS NOT NULL
                            AND (   UPPER(A.ITEM_ID) LIKE '%' || UPPER(TRIM(SM.COLUMN_VALUE)) || '%'
                                 OR EXISTS (SELECT 1      /* 전극 원장 약칭은 전부 '-' : 품목 원장 약칭으로 비교 */
                                              FROM SCM_MST_ITEM_SN SN
                                             WHERE SN.ITEM_ID = A.ITEM_ID
                                               AND UPPER(SN.NICK_NAME) LIKE '%' || UPPER(TRIM(SM.COLUMN_VALUE)) || '%')) ) );
              /* 2026.10.07 AJS Model/Nickname 검색 (END) */

        INSERT INTO GT_SCP0105_CUT_BASE_UPD
             ( DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID
             , ELTR_LN_TP_CD, ITEM_ID, NICK_NAME, UI_UPD_YN )
        SELECT DIVISION_ID
             , COMPANY_ID
             , SITE_ID
             , PLANT_ID
             , FACTORY_ID
             , LINE_ID
             , OPERATION_ID
             , ELTR_LN_TP_CD
             , ITEM_ID
             , '/'
             , UI_UPD_YN
          FROM GT_SCP0105_CUT_BASE
         GROUP BY DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , ITEM_ID
                , UI_UPD_YN;

        /* AJS 20261007 속도 — 마감 라인배정 전량(452,144행)을 임시 테이블에 담던 문장을 빼고
           다음 문장이 원장을 직접 결합한다(유효여부 조건 동일 · 결합 행 수 동일). 원본 주석과 문장 :
        마감 라인배정 — ★유효여부만 걸러 전량을 담는다(AS-IS 그대로)
        INSERT INTO GT_SCP0105_CUT_ASSIGN
             ( VER_ID, VER_SEQ, DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID
             , OPERATION_ID, ELTR_LN_TP_CD, ITEM_ID, NICK_NAME, YYYYMM, ASSIGN_PRIORITY )
        SELECT P_VERSION
             , TO_NUMBER(P_VERSION_SEQ)
             , A.DIVISION_ID
             , A.COMPANY_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.LINE_ID
             , A.OPERATION_ID
             , A.ELTR_LN_TP_CD
             , A.ITEM_ID
             , A.NICK_NAME
             , A.YYYYMM
             , A.ASSIGN_PRIORITY
          FROM SCP_MST_CAPA_ELTR_LINE_ASSIGN_CUTF A
         WHERE A.VALID_YN = 'Y';
        */

        /* 마감 속도계획을 라인배정 열쇠로 좁힌다 — ★전극은 품목까지 맞춘다 */
        INSERT INTO GT_SCP0105_CUT_RAW_ALL_T
             ( VER_ID, VER_SEQ, DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID
             , OPERATION_ID, ELTR_LN_TP_CD, ITEM_ID, NICK_NAME, MSR_TP_CD, YYYYMM
             , PFRSLT_QTY, BASE_QTY, QTY )
        SELECT A.VER_ID
             , A.VER_SEQ
             , A.DIVISION_ID
             , A.COMPANY_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.LINE_ID
             , A.OPERATION_ID
             , A.ELTR_LN_TP_CD
             , A.ITEM_ID
             , A.NICK_NAME
             , A.MSR_TP_CD
             , A.YYYYMM
             , A.BASE_QTY
             , A.BASE_QTY
             , A.QTY
          FROM SCP_MST_CAPA_ELTR_SPEED_PLAN_CUTF A
/*           , GT_SCP0105_CUT_ASSIGN B */
             , SCP_MST_CAPA_ELTR_LINE_ASSIGN_CUTF B /* AJS 20261007 속도 */
         WHERE B.DIVISION_ID   = A.DIVISION_ID
           AND B.COMPANY_ID    = A.COMPANY_ID
           AND B.SITE_ID       = A.SITE_ID
           AND B.PLANT_ID      = A.PLANT_ID
           AND B.FACTORY_ID    = A.FACTORY_ID
           AND B.LINE_ID       = A.LINE_ID
           AND B.OPERATION_ID  = A.OPERATION_ID
           AND B.ELTR_LN_TP_CD = A.ELTR_LN_TP_CD
           AND B.ITEM_ID       = A.ITEM_ID
           AND B.NICK_NAME     = A.NICK_NAME
           AND B.YYYYMM        = A.YYYYMM
           AND NVL(B.ASSIGN_PRIORITY, 0) <> 0
           AND A.OPERATION_ID <> 'AFFFF'
           AND B.VALID_YN = 'Y' /* AJS 20261007 속도 */
           AND A.VER_ID  = P_VERSION
           AND A.VER_SEQ = TO_NUMBER(P_VERSION_SEQ)
           AND ( TRIM(P_DIVISION_ID) IS NULL
              OR UPPER(P_DIVISION_ID) = 'ALL'
              OR A.DIVISION_ID IN (SELECT UPPER(COLUMN_VALUE)
                                     FROM TABLE(STRING_SPLIT(P_DIVISION_ID, ','))) )
           AND ( TRIM(P_SITE_ID) IS NULL
              OR UPPER(P_SITE_ID) = 'ALL'
              OR A.SITE_ID IN (SELECT UPPER(COLUMN_VALUE)
                                 FROM TABLE(STRING_SPLIT(P_SITE_ID, ','))) )
           AND ( TRIM(P_PLANT_ID) IS NULL
              OR UPPER(P_PLANT_ID) = 'ALL'
              OR A.PLANT_ID IN (SELECT UPPER(COLUMN_VALUE)
                                  FROM TABLE(STRING_SPLIT(P_PLANT_ID, ','))) )
           AND ( TRIM(P_FACTORY_ID) IS NULL
              OR UPPER(P_FACTORY_ID) = 'ALL'
              OR A.FACTORY_ID IN (SELECT UPPER(COLUMN_VALUE)
                                    FROM TABLE(STRING_SPLIT(P_FACTORY_ID, ','))) )
           AND ( TRIM(P_LINE_ID) IS NULL
              OR UPPER(P_LINE_ID) = 'ALL'
              OR A.LINE_ID IN (SELECT UPPER(COLUMN_VALUE)
                                 FROM TABLE(STRING_SPLIT(P_LINE_ID, ','))) )
           AND ( TRIM(P_OPERATION_ID) IS NULL
              OR UPPER(P_OPERATION_ID) = 'ALL'
              OR A.OPERATION_ID IN (SELECT UPPER(COLUMN_VALUE)
                                      FROM TABLE(STRING_SPLIT(P_OPERATION_ID, ','))) )
           AND ( TRIM(P_ELECTRODE_TYPE) IS NULL
              OR UPPER(P_ELECTRODE_TYPE) = 'ALL'
              OR UPPER(A.ELTR_LN_TP_CD) IN (SELECT UPPER(COLUMN_VALUE)
                                              FROM TABLE(STRING_SPLIT(P_ELECTRODE_TYPE, ','))) )
           AND ( TRIM(P_ITEM_ID) IS NULL
              OR UPPER(P_ITEM_ID) = 'ALL'
              /* 2026.10.07 AJS Model/Nickname 검색 (START) */
--            OR A.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE)
--                               FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) );
              OR EXISTS (SELECT 1
                           FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SM
                          WHERE TRIM(SM.COLUMN_VALUE) IS NOT NULL
                            AND (   UPPER(A.ITEM_ID) LIKE '%' || UPPER(TRIM(SM.COLUMN_VALUE)) || '%'
                                 OR EXISTS (SELECT 1      /* 전극 원장 약칭은 전부 '-' : 품목 원장 약칭으로 비교 */
                                              FROM SCM_MST_ITEM_SN SN
                                             WHERE SN.ITEM_ID = A.ITEM_ID
                                               AND UPPER(SN.NICK_NAME) LIKE '%' || UPPER(TRIM(SM.COLUMN_VALUE)) || '%')) ) );
              /* 2026.10.07 AJS Model/Nickname 검색 (END) */

        /* 측정항목이 EQP_SPED 하나뿐이라 속도단위 묶음을 곱하지 않는다 */
        /* ★수량 칸이 배정밀도 실수라 평균에서 자리수가 잘리지 않는다 */
        INSERT INTO GT_SCP0105_CUT_RAW_ELTR
             ( VER_ID, VER_SEQ, DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID
             , OPERATION_ID, ELTR_LN_TP_CD, ITEM_ID, NICK_NAME, SPEED_UNIT_GROUP, MSR_TP_CD
             , YYYYMM, UI_UPD_YN, PFRSLT_QTY, BASE_QTY, QTY, PROG_STAT )
        SELECT XA.VER_ID
             , XA.VER_SEQ
             , XA.DIVISION_ID
             , XA.COMPANY_ID
             , XA.SITE_ID
             , XA.PLANT_ID
             , XA.FACTORY_ID
             , XA.LINE_ID
             , XA.OPERATION_ID
             , XA.ELTR_LN_TP_CD
             , XA.ITEM_ID
             , XA.NICK_NAME
             , XA.SPEED_UNIT_GROUP
             , XA.MSR_TP_CD
             , XA.YYYYMM
             , XA.UI_UPD_YN
             , AVG(NVL(XA.PFRSLT_QTY, 0))
             , AVG(NVL(XA.BASE_QTY, 0))
             , AVG(NVL(XA.QTY, 0))
             , P_PROG_STAT
          FROM (SELECT IA.VER_ID
                     , IA.VER_SEQ
                     , IA.DIVISION_ID
                     , IA.COMPANY_ID
                     , IA.SITE_ID
                     , IA.PLANT_ID
                     , IA.FACTORY_ID
                     , IA.LINE_ID
                     , IA.OPERATION_ID
                     , IA.ELTR_LN_TP_CD
                     , IA.ITEM_ID
                     , IA.NICK_NAME
                     , IA.SPEED_UNIT_GROUP
                     , IA.MSR_TP_CD
                     , IA.YYYYMM
                     , TO_BINARY_DOUBLE(R.EQP_SPED)                                 AS PFRSLT_QTY
                     /* ★기준값이 없으면 설비 속도로 갈음한다 */
                     , TO_BINARY_DOUBLE(NVL(X.BASE_QTY, B.EQP_SPED))                AS BASE_QTY
                     , TO_BINARY_DOUBLE(X.QTY)                                      AS QTY
                     , NVL(BU.UI_UPD_YN, 'Y')                                       AS UI_UPD_YN
                  FROM (SELECT SA.VER_ID
                             , SA.VER_SEQ
                             , SA.DIVISION_ID
                             , SA.COMPANY_ID
                             , SA.SITE_ID
                             , SA.PLANT_ID
                             , SA.FACTORY_ID
                             , SA.LINE_ID
                             , SA.OPERATION_ID
                             , SA.ELTR_LN_TP_CD
                             , SA.ITEM_ID
                             , SA.NICK_NAME
                             , SB.UNIT_GROUP AS SPEED_UNIT_GROUP
                             , SA.MSR_TP_CD
                             , SA.YYYYMM
                          FROM GT_SCP0105_CUT_RAW_ALL_T SA
                             , (SELECT SC.SEGMENT1 AS UNIT_GROUP
                                  FROM SCM_ADM_LOOKUP_MASTER_DETAIL SC
                                 WHERE SC.LOOKUP_TYPE = 'OPERATION_SPEED_ELTR_UNIT'
                                   AND SC.VALID_YN    = 'Y'
                                 GROUP BY SC.SEGMENT1) SB
                         WHERE SB.UNIT_GROUP = 'EQP_SPED'
                           AND SA.MSR_TP_CD  = 'EQP_SPED'
                         GROUP BY SA.VER_ID
                                , SA.VER_SEQ
                                , SA.DIVISION_ID
                                , SA.COMPANY_ID
                                , SA.SITE_ID
                                , SA.PLANT_ID
                                , SA.FACTORY_ID
                                , SA.LINE_ID
                                , SA.OPERATION_ID
                                , SA.ELTR_LN_TP_CD
                                , SA.ITEM_ID
                                , SA.NICK_NAME
                                , SB.UNIT_GROUP
                                , SA.MSR_TP_CD
                                , SA.YYYYMM) IA
                     , GT_SCP0105_CUT_RAW_ALL_T X
                     , GT_SCP0105_CUT_RSLT R
                     , GT_SCP0105_CUT_BASE B
                     , GT_SCP0105_CUT_BASE_UPD BU
                 WHERE X.VER_ID(+)         = IA.VER_ID
                   AND X.VER_SEQ(+)        = IA.VER_SEQ
                   AND X.DIVISION_ID(+)    = IA.DIVISION_ID
                   AND X.COMPANY_ID(+)     = IA.COMPANY_ID
                   AND X.SITE_ID(+)        = IA.SITE_ID
                   AND X.PLANT_ID(+)       = IA.PLANT_ID
                   AND X.FACTORY_ID(+)     = IA.FACTORY_ID
                   AND X.LINE_ID(+)        = IA.LINE_ID
                   AND X.OPERATION_ID(+)   = IA.OPERATION_ID
                   AND X.ELTR_LN_TP_CD(+)  = IA.ELTR_LN_TP_CD
                   AND X.ITEM_ID(+)        = IA.ITEM_ID
                   AND X.NICK_NAME(+)      = IA.NICK_NAME
                   AND X.MSR_TP_CD(+)      = IA.MSR_TP_CD
                   AND X.YYYYMM(+)         = IA.YYYYMM
                   AND R.DIVISION_ID(+)    = IA.DIVISION_ID
                   AND R.COMPANY_ID(+)     = IA.COMPANY_ID
                   AND R.SITE_ID(+)        = IA.SITE_ID
                   AND R.PLANT_ID(+)       = IA.PLANT_ID
                   AND R.FACTORY_ID(+)     = IA.FACTORY_ID
                   AND R.LINE_ID(+)        = IA.LINE_ID
                   AND R.OPERATION_ID(+)   = IA.OPERATION_ID
                   AND R.ELTR_LN_TP_CD(+)  = IA.ELTR_LN_TP_CD
                   AND B.DIVISION_ID(+)    = IA.DIVISION_ID
                   AND B.COMPANY_ID(+)     = IA.COMPANY_ID
                   AND B.SITE_ID(+)        = IA.SITE_ID
                   AND B.PLANT_ID(+)       = IA.PLANT_ID
                   AND B.FACTORY_ID(+)     = IA.FACTORY_ID
                   AND B.LINE_ID(+)        = IA.LINE_ID
                   AND B.OPERATION_ID(+)   = IA.OPERATION_ID
                   AND B.ITEM_ID(+)        = IA.ITEM_ID
                   AND B.NICK_NAME(+)      = IA.NICK_NAME
                   AND B.ELTR_LN_TP_CD(+)  = IA.ELTR_LN_TP_CD
                   AND BU.DIVISION_ID(+)   = IA.DIVISION_ID
                   AND BU.COMPANY_ID(+)    = IA.COMPANY_ID
                   AND BU.SITE_ID(+)       = IA.SITE_ID
                   AND BU.PLANT_ID(+)      = IA.PLANT_ID
                   AND BU.FACTORY_ID(+)    = IA.FACTORY_ID
                   AND BU.LINE_ID(+)       = IA.LINE_ID
                   AND BU.OPERATION_ID(+)  = IA.OPERATION_ID
                   AND BU.ITEM_ID(+)       = IA.ITEM_ID
                   AND BU.NICK_NAME(+)     = IA.NICK_NAME
                   AND BU.ELTR_LN_TP_CD(+) = IA.ELTR_LN_TP_CD) XA
         GROUP BY XA.VER_ID
                , XA.VER_SEQ
                , XA.DIVISION_ID
                , XA.COMPANY_ID
                , XA.SITE_ID
                , XA.PLANT_ID
                , XA.FACTORY_ID
                , XA.LINE_ID
                , XA.OPERATION_ID
                , XA.ELTR_LN_TP_CD
                , XA.ITEM_ID
                , XA.NICK_NAME
                , XA.SPEED_UNIT_GROUP
                , XA.MSR_TP_CD
                , XA.YYYYMM
                , XA.UI_UPD_YN;

        /* 날짜 칸 수만큼 피벗식을 조립한다. ★마감분은 정렬키 99 를 빼지 않는다 */
        FOR C IN ( SELECT A.COLUMN_NAME
                     FROM TABLE(FN_SCP0104_GET_SPREAD_TITLE(V_FROM_YYYYMM, P_PROGRAM_ID, P_SHEET_NAME)) A
                    ORDER BY A.SORT_ORDER_NO )
        LOOP
            IF INSTR(C.COLUMN_NAME, 'M_') = 1 THEN
                DBMS_LOB.APPEND(V_DATE_COLS, TO_CLOB(CHR(10) || '     , CAST(CASE WHEN YYYYMM = '''
                    || SUBSTR(C.COLUMN_NAME, 5, 6) || ''' THEN QTY END AS BINARY_DOUBLE) AS ' || C.COLUMN_NAME));
            ELSIF INSTR(C.COLUMN_NAME, 'Y_') = 1 THEN
                DBMS_LOB.APPEND(V_DATE_COLS, TO_CLOB(CHR(10) || '     , CAST(CASE WHEN YYYYMM = '''
                    || SUBSTR(C.COLUMN_NAME, 3, 4) || ''' THEN QTY END AS BINARY_DOUBLE) AS ' || C.COLUMN_NAME));
            END IF;

            DBMS_LOB.APPEND(V_FINAL_COLS, TO_CLOB(CHR(10) || '     , MAX(' || C.COLUMN_NAME
                || ') AS ' || C.COLUMN_NAME));
            DBMS_LOB.APPEND(V_OUT_COLS, TO_CLOB(CHR(10) || '     , A.' || C.COLUMN_NAME));
        END LOOP;

        DBMS_LOB.APPEND(V_SQL, TO_CLOB(
            'SELECT A.VER_ID' || CHR(10)
         || '     , A.VER_SEQ' || CHR(10)
         || '     , A.DIVISION_ID' || CHR(10)
         || '     , A.COMPANY_ID' || CHR(10)
         || '     , A.SITE_ID' || CHR(10)
         || '     , A.PLANT_ID' || CHR(10)
         || '     , A.FACTORY_ID' || CHR(10)
         || '     , A.LINE_ID' || CHR(10)
         || '     , A.OPERATION_ID' || CHR(10)
         || '     , A.ELTR_LN_TP_CD' || CHR(10)
         || '     , A.ITEM_ID' || CHR(10)
         || '     , A.NICK_NAME' || CHR(10)
         || '     , A.SPEED_UNIT_GROUP' || CHR(10)
         || '     , A.MSR_TP_CD' || CHR(10)
         || '     , A.PFRSLT_QTY' || CHR(10)
         || '     , A.BASE_QTY' || CHR(10)
         || '     , A.UI_UPD_YN'));
        DBMS_LOB.APPEND(V_SQL, V_OUT_COLS);
        DBMS_LOB.APPEND(V_SQL, TO_CLOB(CHR(10)
         || '     , M.MEASURE_NAME' || CHR(10)
         || '     , M.SORT_ORDER_NO' || CHR(10)
         || '     , G.UNIT_GROUP_SEQ AS SPEED_UNIT_GROUP_SEQ' || CHR(10)
         /* NICK_NAME 더미 여부는 Speed Plan 입력항목(Meaasrue) 을 결정하므로 따로 저장해둔다 */
         || '     , CASE WHEN I.CODE IS NOT NULL THEN ''Y'' ELSE ''N'' END AS NICK_NAME_DUMMY_YN' || CHR(10)
         || '     , FN_GET_DIVISION_NAME(A.DIVISION_ID) AS DIVISION_NAME' || CHR(10)
         || '     , S.SITE_NAME AS SITE_NAME' || CHR(10)
         || '     , P.PLANT_NAME AS PLANT_NAME' || CHR(10)
         || '     , F.FACTORY_NAME AS FACTORY_NAME' || CHR(10)
         || '     , L.LINE_NAME AS LINE_NAME' || CHR(10)
         || '     , O.OPERATION_NAME' || CHR(10)
         || '     , Z.EQUIPMENT_ID' || CHR(10)
         || '     , NVL(Z.EQUIPMENT_NAME, ''-'') AS EQUIPMENT_NAME' || CHR(10)
         || '  FROM (SELECT IA.VER_ID' || CHR(10)
         || '             , IA.VER_SEQ' || CHR(10)
         || '             , IA.DIVISION_ID' || CHR(10)
         || '             , IA.COMPANY_ID' || CHR(10)
         || '             , IA.SITE_ID' || CHR(10)
         || '             , IA.PLANT_ID' || CHR(10)
         || '             , IA.FACTORY_ID' || CHR(10)
         || '             , IA.LINE_ID' || CHR(10)
         || '             , IA.OPERATION_ID' || CHR(10)
         || '             , IA.ELTR_LN_TP_CD' || CHR(10)
         || '             , IA.ITEM_ID' || CHR(10)
         /* ★약칭은 사업부+품목으로 가져온 값으로 바꿔 묶는다 */
         || '             , IA.NICK_NAME' || CHR(10)
         || '             , IA.SPEED_UNIT_GROUP' || CHR(10)
         || '             , IA.MSR_TP_CD' || CHR(10)
         || '             , IA.UI_UPD_YN' || CHR(10)
         || '             , MAX(IA.PFRSLT_QTY) AS PFRSLT_QTY' || CHR(10)
         || '             , MAX(IA.BASE_QTY) AS BASE_QTY'));
        DBMS_LOB.APPEND(V_SQL, REPLACE(V_FINAL_COLS, CHR(10) || '     , ', CHR(10) || '             , '));
        DBMS_LOB.APPEND(V_SQL, TO_CLOB(CHR(10)
/*       || '          FROM (SELECT XA.VER_ID' || CHR(10) */
         || '          FROM (SELECT /*+ NO_PUSH_PRED(SA) */ XA.VER_ID' || CHR(10) /* AJS 20261007 속도 */
         || '                     , XA.VER_SEQ' || CHR(10)
         || '                     , XA.DIVISION_ID' || CHR(10)
         || '                     , XA.COMPANY_ID' || CHR(10)
         || '                     , XA.SITE_ID' || CHR(10)
         || '                     , XA.PLANT_ID' || CHR(10)
         || '                     , XA.FACTORY_ID' || CHR(10)
         || '                     , XA.LINE_ID' || CHR(10)
         || '                     , XA.OPERATION_ID' || CHR(10)
         || '                     , XA.ELTR_LN_TP_CD' || CHR(10)
         || '                     , XA.ITEM_ID' || CHR(10)
         || '                     , SA.NICK_NAME' || CHR(10)
         || '                     , XA.SPEED_UNIT_GROUP' || CHR(10)
         || '                     , XA.MSR_TP_CD' || CHR(10)
         || '                     , XA.UI_UPD_YN' || CHR(10)
         || '                     , XA.PFRSLT_QTY' || CHR(10)
         || '                     , XA.BASE_QTY'));
        DBMS_LOB.APPEND(V_SQL, REPLACE(V_DATE_COLS, CHR(10) || '     , ', CHR(10) || '                     , '));
        DBMS_LOB.APPEND(V_SQL, TO_CLOB(CHR(10)
         || '                  FROM GT_SCP0105_CUT_RAW_ELTR XA' || CHR(10)
/* AJS 20261007 속도 — 원본 2줄 (공용 함수 전체 결과 35,844행을 매번 읽는다)
         || '                     , (SELECT SB.DIVISION_ID, SB.ITEM_ID, SB.NICK_NAME'
         || ' FROM TABLE(FN_SCM0002_GET_CAPA_ITEM_POPUP('''', '''')) SB) SA' || CHR(10)
*/
         /* 약칭 : 공용 함수와 같은 조회를 원자료 임시 테이블의 사업부 · 품목으로 한정(결과 동일) */
         || '                     , (SELECT /*+ NO_MERGE(XB) LEADING(XB XC XD) USE_NL(XC XD) */ XC.DIVISION_ID, XC.ITEM_ID' /* AJS 20261007 속도 */
         || ' , MAX(CASE WHEN XD.NICK_NAME IS NULL THEN XC.NICK_NAME ELSE XD.NICK_NAME END) AS NICK_NAME' || CHR(10) /* AJS 20261007 속도 */
         || '                          FROM (SELECT DISTINCT XE.DIVISION_ID, XE.ITEM_ID FROM GT_SCP0105_CUT_RAW_ELTR XE) XB' /* AJS 20261007 속도 */
         || ' , SCP_MST_FINAL_ITEM XC, SCM_MST_ITEM_SN XD' || CHR(10) /* AJS 20261007 속도 */
         || '                         WHERE XC.DIVISION_ID = XB.DIVISION_ID AND XC.ITEM_ID = XB.ITEM_ID' /* AJS 20261007 속도 */
         || ' AND XD.DIVISION_ID = XC.DIVISION_ID AND XD.ITEM_ID = XC.ITEM_ID' || CHR(10) /* AJS 20261007 속도 */
         || '                         GROUP BY XC.DIVISION_ID, XC.OPERATION_GROUP, XC.FLOW_ID, XC.ITEM_ID) SA' || CHR(10) /* AJS 20261007 속도 */
         || '                 WHERE SA.DIVISION_ID(+) = XA.DIVISION_ID' || CHR(10)
         || '                   AND SA.ITEM_ID(+) = XA.ITEM_ID) IA' || CHR(10)
         || '         GROUP BY IA.VER_ID' || CHR(10)
         || '                , IA.VER_SEQ' || CHR(10)
         || '                , IA.DIVISION_ID' || CHR(10)
         || '                , IA.COMPANY_ID' || CHR(10)
         || '                , IA.SITE_ID' || CHR(10)
         || '                , IA.PLANT_ID' || CHR(10)
         || '                , IA.FACTORY_ID' || CHR(10)
         || '                , IA.LINE_ID' || CHR(10)
         || '                , IA.OPERATION_ID' || CHR(10)
         || '                , IA.ELTR_LN_TP_CD' || CHR(10)
         || '                , IA.ITEM_ID' || CHR(10)
         || '                , IA.NICK_NAME' || CHR(10)
         || '                , IA.SPEED_UNIT_GROUP' || CHR(10)
         || '                , IA.MSR_TP_CD' || CHR(10)
         || '                , IA.UI_UPD_YN) A' || CHR(10)
         || '     , (SELECT SITE_ID, SITE_NAME FROM SCP_MST_CAPA_ELTR_LINE'
         || ' WHERE VALID_YN = ''Y'' AND COMPANY_ID <> ''-'' GROUP BY SITE_ID, SITE_NAME) S' || CHR(10)
         || '     , (SELECT COMPANY_ID, COMPANY_NAME FROM SCP_MST_CAPA_ELTR_LINE'
         || ' WHERE VALID_YN = ''Y'' AND COMPANY_ID <> ''-'' GROUP BY COMPANY_ID, COMPANY_NAME) C' || CHR(10)
         || '     , (SELECT PLANT_ID, PLANT_NAME FROM SCP_MST_CAPA_ELTR_LINE'
         || ' WHERE VALID_YN = ''Y'' AND COMPANY_ID <> ''-'' GROUP BY PLANT_ID, PLANT_NAME) P' || CHR(10)
         || '     , (SELECT FACTORY_ID, FACTORY_NAME FROM SCP_MST_CAPA_ELTR_LINE'
         || ' WHERE VALID_YN = ''Y'' AND COMPANY_ID <> ''-'' GROUP BY FACTORY_ID, FACTORY_NAME) F' || CHR(10)
         || '     , (SELECT LINE_ID, LINE_NAME FROM SCP_MST_CAPA_ELTR_LINE'
         || ' WHERE VALID_YN = ''Y'' AND COMPANY_ID <> ''-'' GROUP BY LINE_ID, LINE_NAME) L' || CHR(10)
         || '     , (SELECT SA.OPERATION_ID, MAX(SA.OPERATION_NAME) AS OPERATION_NAME'
         || ' FROM SCM_MST_OPERATION_SN SA GROUP BY SA.OPERATION_ID) O' || CHR(10)
         || '     , (SELECT SB.CODE, SB.NAME FROM SCP_MST_CAPA_DUMMY_CODE SB'
         || ' WHERE SB.CODE_TP = ''I'') I' || CHR(10)
         || '     , (SELECT SC.COLUMN_NAME AS MEASURE, SC.COLUMN_LABEL_NAME AS MEASURE_NAME'
         || ' , SC.SORT_ORDER_NO FROM SCM_MST_SHEET_MEASURE SC' || CHR(10)
         || '         WHERE SC.PROGRAM_ID = ''' || P_PROGRAM_ID || ''''
         || ' AND SC.SHEET_NAME = ''' || P_SHEET_NAME || ''''
         || ' AND SC.VALID_YN = ''Y'') M' || CHR(10)
         || '     , (SELECT SD.SEGMENT1 AS UNIT_GROUP, SD.SEGMENT3 AS MSR_TP_CD'
         || ' , SD.SEGMENT5 AS UNIT_GROUP_SEQ FROM SCM_ADM_LOOKUP_MASTER_DETAIL SD' || CHR(10)
         || '         WHERE SD.LOOKUP_TYPE = ''OPERATION_SPEED_ELTR_UNIT'''
         || ' AND SD.VALID_YN = ''Y'') G' || CHR(10)
         || '     , (SELECT SE.DIVISION_ID, SE.COMPANY_ID, SE.SITE_ID, SE.PLANT_ID, SE.FACTORY_ID'
         || ' , SE.LINE_ID, SE.OPERATION_ID, SE.EQUIPMENT_ID, SE.EQUIPMENT_NAME' || CHR(10)
         || '         FROM GT_SCP0105_CUT_EQP SE GROUP BY SE.DIVISION_ID, SE.COMPANY_ID, SE.SITE_ID'
         || ' , SE.PLANT_ID, SE.FACTORY_ID, SE.LINE_ID, SE.OPERATION_ID, SE.EQUIPMENT_ID'
         || ' , SE.EQUIPMENT_NAME) Z' || CHR(10)
         || ' WHERE A.SITE_ID = S.SITE_ID(+)' || CHR(10)
         || '   AND A.COMPANY_ID = C.COMPANY_ID(+)' || CHR(10)
         || '   AND A.PLANT_ID = P.PLANT_ID(+)' || CHR(10)
         || '   AND A.FACTORY_ID = F.FACTORY_ID(+)' || CHR(10)
         || '   AND A.LINE_ID = L.LINE_ID(+)' || CHR(10)
         || '   AND A.OPERATION_ID = O.OPERATION_ID(+)' || CHR(10)
         || '   AND A.ITEM_ID = I.NAME(+)' || CHR(10)
         || '   AND A.MSR_TP_CD = M.MEASURE(+)' || CHR(10)
         || '   AND A.SPEED_UNIT_GROUP = G.UNIT_GROUP(+)' || CHR(10)
         || '   AND A.MSR_TP_CD = G.MSR_TP_CD(+)' || CHR(10)
         || '   AND A.DIVISION_ID = Z.DIVISION_ID(+)' || CHR(10)
         || '   AND A.COMPANY_ID = Z.COMPANY_ID(+)' || CHR(10)
         || '   AND A.SITE_ID = Z.SITE_ID(+)' || CHR(10)
         || '   AND A.PLANT_ID = Z.PLANT_ID(+)' || CHR(10)
         || '   AND A.FACTORY_ID = Z.FACTORY_ID(+)' || CHR(10)
         || '   AND A.LINE_ID = Z.LINE_ID(+)' || CHR(10)
         || '   AND A.OPERATION_ID = Z.OPERATION_ID(+)' || CHR(10)
         /* ★AS-IS 정렬은 하이픈을 무시하고 대소문자를 가리지 않는다. 속도단위 순번은 AS-IS 에 주석 처리되어 있다 */
         || ' ORDER BY FN_ASIS_SORT_KEY(A.VER_ID) NULLS FIRST' || CHR(10)
         || '        , A.VER_SEQ NULLS FIRST' || CHR(10)
         || '        , FN_ASIS_SORT_KEY(A.DIVISION_ID) NULLS FIRST' || CHR(10)
         || '        , FN_ASIS_SORT_KEY(A.COMPANY_ID) NULLS FIRST' || CHR(10)
         || '        , FN_ASIS_SORT_KEY(S.SITE_NAME) NULLS FIRST' || CHR(10)
         || '        , FN_ASIS_SORT_KEY(P.PLANT_NAME) NULLS FIRST' || CHR(10)
         || '        , FN_ASIS_SORT_KEY(F.FACTORY_NAME) NULLS FIRST' || CHR(10)
         || '        , FN_ASIS_SORT_KEY(L.LINE_NAME) NULLS FIRST' || CHR(10)
         || '        , FN_ASIS_SORT_KEY(A.ITEM_ID) NULLS FIRST' || CHR(10)
         || '        , FN_ASIS_SORT_KEY(A.NICK_NAME) NULLS FIRST' || CHR(10)
         || '        , FN_ASIS_SORT_KEY(A.OPERATION_ID) NULLS FIRST' || CHR(10)
         || '        , FN_ASIS_SORT_KEY(A.ELTR_LN_TP_CD) NULLS FIRST' || CHR(10)
         || '        , M.SORT_ORDER_NO NULLS FIRST'));

        OPEN O_RC1 FOR V_SQL;

        /* Unpivot 용 오리지널 테이블 구조 저장 */
        OPEN O_RC2 FOR
            SELECT VER_ID
                 , VER_SEQ
                 , DIVISION_ID
                 , COMPANY_ID
                 , SITE_ID
                 , PLANT_ID
                 , FACTORY_ID
                 , LINE_ID
                 , OPERATION_ID
                 , ELTR_LN_TP_CD
                 , ITEM_ID
                 , NICK_NAME
                 , MSR_TP_CD
                 , YYYYMM
                 , BASE_QTY
                 , QTY
              FROM SCP_MST_CAPA_ELTR_SPEED_PLAN_CUTF
             WHERE 1 <> 1;

        DBMS_LOB.FREETEMPORARY(V_DATE_COLS);
        DBMS_LOB.FREETEMPORARY(V_FINAL_COLS);
        DBMS_LOB.FREETEMPORARY(V_OUT_COLS);
        DBMS_LOB.FREETEMPORARY(V_SQL);

    END P_SCP0105_GET_SPEED_CUTOFF_ELTR;

    /*******************************************************************************
     * P_SCP0106_CHK_LOSS_SPD_ASM  (패키지 안에서만 쓰는 갈래)
     *   AS-IS SCP0106_CHECK_CAPA_LOSS_PLAN_BY_SPEED_ASSEMBLY
     *   속도계획(PPM)이 바뀐 열쇠의 손실계획 능력값을 다시 계산해 원장을 고친다 — 조립
     *   전달 테이블은 GT_SCP_CAPA_SPEED_PLAN_KEYS 로 받는다(부르는 쪽이 채운다)
     *
     * AS-IS 절차
     *   1. 라인 SOP 일수를 담는다.
     *   2. 전달받은 열쇠로 속도계획 뷰에서 PPM 줄만 가져온다(수량이 없으면 기준수량으로).
     *   3. 그 열쇠의 모델별 손실계획을 기준(BASE_NVL)과 운영계획(LOSS_RT) 두 벌로 만든다.
     *   4. 측정항목을 칸으로 펼쳐 이론능력 · 생산능력(일 · 월)을 계산한다.
     *   5. 측정항목별로 되돌려 담고 평균을 낸 뒤 능력 · 성능률 네 항목만 원장에 반영한다.
     *
     * ★운영계획 쪽 손실률은 AS-IS 가 전부 0 으로 채운다(2025-02-10 개선율 입력 영역 제거).
     *   그래서 운영계획 생산능력은 0 이 되고 이론능력만 값이 남는다 — 원문 그대로 옮긴다.
     * ★AS-IS 가 측정항목마다 임시 테이블을 따로 만들지만 모두 같은 자료를 조건만 달리 거른 것이라
     *   한 테이블에 담고 측정항목 조건으로 가른다.
     * ★최종변경자에 들어가는 이름이 AS-IS 에서 BY_ASSIGN 쪽으로 적혀 있다 — 원문 그대로 둔다.
     * ★AS-IS 가 계산하지만 쓰지 않는 변수 두 개(@v_from_yyyy · @v_result_to_yyyymm)는 옮기지 않았다.
     * ★부르는 쪽이 트랜잭션을 쥐고 있으므로 이 갈래는 커밋하지 않는다.
     *******************************************************************************/
    PROCEDURE P_SCP0106_CHK_LOSS_SPD_ASM
    (
        P_PROGRAM_ID            IN  VARCHAR2
      , P_SHEET_NAME            IN  VARCHAR2
      , P_USER_ID               IN  VARCHAR2
      , P_DEBUG_MODE            IN  VARCHAR2
    )
    IS
        V_PROGRAM_NAME      VARCHAR2(150 CHAR) := 'SCP0106_CHECK_CAPA_LOSS_PLAN_BY_ASSIGN_ASSEMBLY';
        V_STAMP             VARCHAR2(800 CHAR);
        V_VERSION           VARCHAR2(40 CHAR);
        V_VERSION_SEQ       NUMBER;
    BEGIN

        V_STAMP := V_PROGRAM_NAME || '-' || P_USER_ID;

        SELECT MAX(VER_ID)
             , MAX(VER_SEQ)
          INTO V_VERSION
             , V_VERSION_SEQ
          FROM GT_SCP_CAPA_SPEED_PLAN_KEYS;

        DELETE GT_SCP0106_SPD_DAY_CNT;
        DELETE GT_SCP0106_SPD_PLAN_RAW;
        DELETE GT_SCP0106_SPD_PLAN_KEY;
        DELETE GT_SCP0106_SPD_RAW_BASE;
        DELETE GT_SCP0106_SPD_LOSS_KEY;
        DELETE GT_SCP0106_SPD_RAW_KEY;
        DELETE GT_SCP0106_SPD_FIN;
        DELETE GT_SCP0106_SPD_FINAL;

        /* 1. 라인 SOP 일수 */
        INSERT INTO GT_SCP0106_SPD_DAY_CNT
             ( DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID
             , ELTR_LN_TP_CD, SOP_DT, YYYYMM, DAY_CNT, DAY_CNT_YEAR, YYYY )
        SELECT DIVISION_ID
             , COMPANY_ID
             , SITE_ID
             , PLANT_ID
             , FACTORY_ID
             , LINE_ID
             , OPERATION_ID
             , ELTR_LN_TP_CD
             , SOP_DT
             , SOP_YM
             , SOP_DDN
             , CASE WHEN TRIM(SOP_DT) IS NULL THEN 0
                    ELSE TO_DATE(SUBSTR(SOP_YM, 1, 4) || '1231', 'YYYYMMDD')
                       - TO_DATE(SOP_DT, 'YYYYMMDD') + 1
               END
             , SUBSTR(SOP_YM, 1, 4)
          FROM SCP_MST_CAPA_LINE_SOP
         WHERE VALID_YN = 'Y';

        /* 2. 속도계획 뷰에서 PPM 줄만. 기준일수는 버전 달의 남은 날 수 */
        INSERT INTO GT_SCP0106_SPD_PLAN_RAW
             ( VER_ID, VER_SEQ, DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID
             , OPERATION_ID, ELTR_LN_TP_CD, ITEM_ID, NICK_NAME, MSR_TP_CD, YYYYMM
             , BASE_QTY, QTY, UI_UPD_YN, BASE_DAY_CNT, DAY_CNT )
        SELECT T.VER_ID
             , T.VER_SEQ
             , A.DIVISION_ID
             , A.COMPANY_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.LINE_ID
             , A.OPERATION_ID
             , A.ELTR_LN_TP_CD
             , A.ITEM_ID
             , A.NICK_NAME
             , A.MSR_TP_CD
             , A.YYYYMM
             , A.BASE_QTY
             , NVL(A.QTY, A.BASE_QTY)
             , A.UI_UPD_YN
             , TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE(T.VER_ID || '01', 'YYYYMMDD')), 'DD'))
             - TO_NUMBER(TO_CHAR(TO_DATE(T.VER_ID || '01', 'YYYYMMDD'), 'DD')) + 1
             /* ★조업일수는 뷰 칸(DAY_CNT)을 읽지 않고 뷰와 같은 산식으로 직접 낸다 —
                  그 칸은 연도 줄(YYYYMM 네 자리)에서 ORA-01840 이 나는 이관 결함이 있다.
                  날짜 만들기를 SUBSTR 로 감싸 갈림 앞에서 셈해도 터지지 않게 한다. */
             , CASE WHEN LENGTH(A.YYYYMM) = 4 THEN
                         CASE WHEN DY.DIVISION_ID IS NULL
                              THEN TO_DATE(SUBSTR(A.YYYYMM, 1, 4) || '1231', 'YYYYMMDD')
                                 - TO_DATE(SUBSTR(A.YYYYMM, 1, 4) || '0101', 'YYYYMMDD') + 1
                              ELSE DY.DAY_CNT_YEAR
                         END
                    ELSE
                         CASE WHEN DC.DIVISION_ID IS NULL
                              THEN EXTRACT(DAY FROM LAST_DAY(TO_DATE(SUBSTR(A.YYYYMM || '0101', 1, 8), 'YYYYMMDD')))
                              ELSE DC.DAY_CNT
                         END
               END
          FROM SCP_MST_CAPA_SPEED_PLAN_V A
             , (SELECT IA.VER_ID
                     , IA.VER_SEQ
                     , IA.DIVISION_ID
                     , IA.COMPANY_ID
                     , IA.SITE_ID
                     , IA.PLANT_ID
                     , IA.FACTORY_ID
                     , IA.LINE_ID
                     , IA.OPERATION_ID
                     , IA.ELTR_LN_TP_CD
                     , IA.ITEM_ID
                     , IA.NICK_NAME
                     , IA.YYYYMM
                  FROM GT_SCP_CAPA_SPEED_PLAN_KEYS IA
                 GROUP BY IA.VER_ID
                        , IA.VER_SEQ
                        , IA.DIVISION_ID
                        , IA.COMPANY_ID
                        , IA.SITE_ID
                        , IA.PLANT_ID
                        , IA.FACTORY_ID
                        , IA.LINE_ID
                        , IA.OPERATION_ID
                        , IA.ELTR_LN_TP_CD
                        , IA.ITEM_ID
                        , IA.NICK_NAME
                        , IA.YYYYMM) T
             , GT_SCP0106_SPD_DAY_CNT DC
             , GT_SCP0106_SPD_DAY_CNT DY
         WHERE T.DIVISION_ID      = A.DIVISION_ID
           AND T.COMPANY_ID       = A.COMPANY_ID
           AND T.SITE_ID          = A.SITE_ID
           AND T.PLANT_ID         = A.PLANT_ID
           AND T.FACTORY_ID       = A.FACTORY_ID
           AND T.LINE_ID          = A.LINE_ID
           AND T.OPERATION_ID     = A.OPERATION_ID
           AND T.ELTR_LN_TP_CD    = A.ELTR_LN_TP_CD
           AND T.ITEM_ID          = A.ITEM_ID
           AND T.NICK_NAME        = A.NICK_NAME
           AND T.YYYYMM           = A.YYYYMM
           AND DC.DIVISION_ID(+)    = A.DIVISION_ID
           AND DC.COMPANY_ID(+)     = A.COMPANY_ID
           AND DC.SITE_ID(+)        = A.SITE_ID
           AND DC.PLANT_ID(+)       = A.PLANT_ID
           AND DC.FACTORY_ID(+)     = A.FACTORY_ID
           AND DC.LINE_ID(+)        = A.LINE_ID
           AND DC.OPERATION_ID(+)   = A.OPERATION_ID
           AND DC.ELTR_LN_TP_CD(+)  = A.ELTR_LN_TP_CD
           AND DC.YYYYMM(+)         = A.YYYYMM
           AND DY.DIVISION_ID(+)    = A.DIVISION_ID
           AND DY.COMPANY_ID(+)     = A.COMPANY_ID
           AND DY.SITE_ID(+)        = A.SITE_ID
           AND DY.PLANT_ID(+)       = A.PLANT_ID
           AND DY.FACTORY_ID(+)     = A.FACTORY_ID
           AND DY.LINE_ID(+)        = A.LINE_ID
           AND DY.OPERATION_ID(+)   = A.OPERATION_ID
           AND DY.YYYY(+)           = A.YYYYMM
           AND A.MSR_TP_CD = 'PPM'   /* PPM 변경시 영향을 받으므로 */;

        /* 3. 속도계획 열쇠 묶음 */
        INSERT INTO GT_SCP0106_SPD_PLAN_KEY
             ( DIVISION_ID, MDL_NM, PLANT_ID, LINE_ID, OPERATION_ID, ELTR_LN_TP_CD
             , COMPANY_ID, SITE_ID, FACTORY_ID )
        SELECT A.DIVISION_ID
             , A.NICK_NAME
             , A.PLANT_ID
             , A.LINE_ID
             , A.OPERATION_ID
             , A.ELTR_LN_TP_CD
             , A.COMPANY_ID
             , A.SITE_ID
             , A.FACTORY_ID
          FROM GT_SCP0106_SPD_PLAN_RAW A
         GROUP BY A.DIVISION_ID
                , A.NICK_NAME
                , A.PLANT_ID
                , A.LINE_ID
                , A.OPERATION_ID
                , A.ELTR_LN_TP_CD
                , A.COMPANY_ID
                , A.SITE_ID
                , A.FACTORY_ID;

        /* 4. 그 열쇠의 모델별 손실계획. ★운영계획 손실률은 AS-IS 가 0 으로 채운다 */
        INSERT INTO GT_SCP0106_SPD_RAW_BASE
             ( DIVISION_ID, SITE_ID, COMPANY_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID
             , ELTR_LN_TP_CD, MDL_NM, MSR_GR_CD, LOSS_CD, YYYYMM, PFRSLT_NVL, BASE_NVL, LOSS_RT )
        SELECT A.DIVISION_ID
             , A.SITE_ID
             , A.COMPANY_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.LINE_ID
             , A.OPERATION_ID
             , A.ELTR_LN_TP_CD
             , A.MDL_NM
             , A.MSR_GR_CD
             , A.MSR_TP_CD
             , A.YYYYMM
             , A.PFRSLT_NVL
             , A.BASE_NVL
             , 0.0
          FROM SCP_MST_CAPA_LOSS_PLAN_MDL A
             , GT_SCP0106_SPD_PLAN_KEY B
         WHERE B.DIVISION_ID   = A.DIVISION_ID
           AND B.COMPANY_ID    = A.COMPANY_ID
           AND B.SITE_ID       = A.SITE_ID
           AND B.PLANT_ID      = A.PLANT_ID
           AND B.FACTORY_ID    = A.FACTORY_ID
           AND B.LINE_ID       = A.LINE_ID
           AND B.OPERATION_ID  = A.OPERATION_ID
           AND B.ELTR_LN_TP_CD = A.ELTR_LN_TP_CD
           AND B.MDL_NM        = A.MDL_NM;

        /* 5. 측정항목을 포함한 열쇠 · 뺀 열쇠 */
        INSERT INTO GT_SCP0106_SPD_LOSS_KEY
             ( DIVISION_ID, SITE_ID, COMPANY_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID
             , ELTR_LN_TP_CD, MDL_NM, MSR_GR_CD, LOSS_CD, YYYYMM )
        SELECT A.DIVISION_ID
             , A.SITE_ID
             , A.COMPANY_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.LINE_ID
             , A.OPERATION_ID
             , A.ELTR_LN_TP_CD
             , A.MDL_NM
             , A.MSR_GR_CD
             , A.LOSS_CD
             , A.YYYYMM
          FROM GT_SCP0106_SPD_RAW_BASE A
         GROUP BY A.DIVISION_ID
                , A.SITE_ID
                , A.COMPANY_ID
                , A.PLANT_ID
                , A.FACTORY_ID
                , A.LINE_ID
                , A.OPERATION_ID
                , A.ELTR_LN_TP_CD
                , A.MDL_NM
                , A.MSR_GR_CD
                , A.LOSS_CD
                , A.YYYYMM;

        INSERT INTO GT_SCP0106_SPD_RAW_KEY
             ( DIVISION_ID, SITE_ID, COMPANY_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID
             , ELTR_LN_TP_CD, MDL_NM, YYYYMM )
        SELECT A.DIVISION_ID
             , A.SITE_ID
             , A.COMPANY_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.LINE_ID
             , A.OPERATION_ID
             , A.ELTR_LN_TP_CD
             , A.MDL_NM
             , A.YYYYMM
          FROM GT_SCP0106_SPD_LOSS_KEY A
         GROUP BY A.DIVISION_ID
                , A.SITE_ID
                , A.COMPANY_ID
                , A.PLANT_ID
                , A.FACTORY_ID
                , A.LINE_ID
                , A.OPERATION_ID
                , A.ELTR_LN_TP_CD
                , A.MDL_NM
                , A.YYYYMM;

        /* 6. 기준(B) · 운영계획(O) 두 벌로 측정항목을 칸으로 펼쳐 능력값을 계산한다 */
        /*    ★성능률은 AS-IS 가 1.0 으로 고정한다                                   */
        INSERT INTO GT_SCP0106_SPD_FIN
             ( SRC_TP, DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID
             , OPERATION_ID, ELTR_LN_TP_CD, MDL_NM, YYYYMM
             , BM_RT, CM_RT, ID_RT, MR_RT, NM_RT, PD_RT, PM_RT, PP_RT, UD_RT
             , OP_RT, LD_RT, AV_RT, PF_RT, QL_RT, TEEP, PROD_OP_RT
             , THRY_CAPA_D, PROD_CAPA_D, PROD_CAPA_M
             , BASE_THRY_CAPA_D, BASE_PROD_CAPA_D, BASE_PROD_CAPA_M
             , PPM, BASE_PPM )
        SELECT XA.SRC_TP
             , XA.DIVISION_ID
             , XA.COMPANY_ID
             , XA.SITE_ID
             , XA.PLANT_ID
             , XA.FACTORY_ID
             , XA.LINE_ID
             , XA.OPERATION_ID
             , XA.ELTR_LN_TP_CD
             , XA.MDL_NM
             , XA.YYYYMM
             , MAX(XA.BM_RT)
             , MAX(XA.CM_RT)
             , MAX(XA.ID_RT)
             , MAX(XA.MR_RT)
             , MAX(XA.NM_RT)
             , MAX(XA.PD_RT)
             , MAX(XA.PM_RT)
             , MAX(XA.PP_RT)
             , MAX(XA.UD_RT)
             , MAX(XA.OP_RT)
             , MAX(XA.LD_RT)
             , MAX(XA.AV_RT)
             , MAX(XA.PF_RT)
             , MAX(XA.QL_RT)
             , MAX(XA.TEEP)
             , MAX(XA.PROD_OP_RT)
             , MAX(XA.THRY_CAPA_D)
             , MAX(XA.PROD_CAPA_D)
             , MAX(XA.PROD_CAPA_M)
             , MAX(XA.BASE_THRY_CAPA_D)
             , MAX(XA.BASE_PROD_CAPA_D)
             , MAX(XA.BASE_PROD_CAPA_M)
             , MAX(XA.PPM)
             , MAX(XA.BASE_PPM)
          FROM (SELECT IA.SRC_TP
                     , IA.DIVISION_ID
                     , IA.COMPANY_ID
                     , IA.SITE_ID
                     , IA.PLANT_ID
                     , IA.FACTORY_ID
                     , IA.LINE_ID
                     , IA.OPERATION_ID
                     , IA.ELTR_LN_TP_CD
                     , IA.MDL_NM
                     , IA.YYYYMM
                     , IA.BM_RT
                     , IA.CM_RT
                     , IA.ID_RT
                     , IA.MR_RT
                     , IA.NM_RT
                     , IA.PD_RT
                     , IA.PM_RT
                     , IA.PP_RT
                     , IA.UD_RT
                     , IA.OP_RT
                     , IA.LD_RT
                     , IA.AV_RT
                     , IA.PF_RT
                     , IA.QL_RT
                     , IA.TEEP
                     , IA.PROD_OP_RT
                     , S.QTY * 1440.0                                       AS THRY_CAPA_D
                     , S.QTY * 1440.0 * IA.PROD_OP_RT                       AS PROD_CAPA_D
                     , S.QTY * 1440.0 * IA.PROD_OP_RT * S.DAY_CNT           AS PROD_CAPA_M
                     , S.BASE_QTY * 1440.0                                  AS BASE_THRY_CAPA_D
                     , S.BASE_QTY * 1440.0 * IA.PROD_OP_RT                  AS BASE_PROD_CAPA_D
                     , S.BASE_QTY * 1440.0 * IA.PROD_OP_RT * S.BASE_DAY_CNT AS BASE_PROD_CAPA_M
                     , S.QTY                                                AS PPM
                     , S.BASE_QTY                                           AS BASE_PPM
                  FROM (SELECT SB.SRC_TP
                             , K.DIVISION_ID
                             , K.COMPANY_ID
                             , K.SITE_ID
                             , K.PLANT_ID
                             , K.FACTORY_ID
                             , K.LINE_ID
                             , K.OPERATION_ID
                             , K.ELTR_LN_TP_CD
                             , K.MDL_NM
                             , K.YYYYMM
                             /* ★고장정지만 값이 없으면 0 으로 본다 */
                             , NVL(MAX(CASE WHEN SA.LOSS_CD = 'BM_RT'      THEN SA.NVL_VAL END), 0) AS BM_RT
                             , MAX(CASE WHEN SA.LOSS_CD = 'CM_RT'      THEN SA.NVL_VAL END)     AS CM_RT
                             , MAX(CASE WHEN SA.LOSS_CD = 'ID_RT'      THEN SA.NVL_VAL END)     AS ID_RT
                             , MAX(CASE WHEN SA.LOSS_CD = 'MR_RT'      THEN SA.NVL_VAL END)     AS MR_RT
                             , MAX(CASE WHEN SA.LOSS_CD = 'NM_RT'      THEN SA.NVL_VAL END)     AS NM_RT
                             , MAX(CASE WHEN SA.LOSS_CD = 'PD_RT'      THEN SA.NVL_VAL END)     AS PD_RT
                             , MAX(CASE WHEN SA.LOSS_CD = 'PM_RT'      THEN SA.NVL_VAL END)     AS PM_RT
                             , MAX(CASE WHEN SA.LOSS_CD = 'PP_RT'      THEN SA.NVL_VAL END)     AS PP_RT
                             , MAX(CASE WHEN SA.LOSS_CD = 'UD_RT'      THEN SA.NVL_VAL END)     AS UD_RT
                             , MAX(CASE WHEN SA.LOSS_CD = 'OP_RT'      THEN SA.NVL_VAL END)     AS OP_RT
                             , MAX(CASE WHEN SA.LOSS_CD = 'LD_RT'      THEN SA.NVL_VAL END)     AS LD_RT
                             , MAX(CASE WHEN SA.LOSS_CD = 'AV_RT'      THEN SA.NVL_VAL END)     AS AV_RT
                             /* ★성능률은 AS-IS 가 1.0 으로 고정한다 */
                             , 1.0                                                              AS PF_RT
                             , MAX(CASE WHEN SA.LOSS_CD = 'QL_RT'      THEN SA.NVL_VAL END)     AS QL_RT
                             , MAX(CASE WHEN SA.LOSS_CD = 'TEEP'       THEN SA.NVL_VAL END)     AS TEEP
                             , MAX(CASE WHEN SA.LOSS_CD = 'PROD_OP_RT' THEN SA.NVL_VAL END)     AS PROD_OP_RT
                          FROM GT_SCP0106_SPD_RAW_KEY K
                             , (SELECT 'B' AS SRC_TP FROM DUAL
                                 UNION ALL
                                SELECT 'O' AS SRC_TP FROM DUAL) SB
                             , (SELECT SC.DIVISION_ID
                                     , SC.COMPANY_ID
                                     , SC.SITE_ID
                                     , SC.PLANT_ID
                                     , SC.FACTORY_ID
                                     , SC.LINE_ID
                                     , SC.OPERATION_ID
                                     , SC.ELTR_LN_TP_CD
                                     , SC.MDL_NM
                                     , SC.YYYYMM
                                     , SC.LOSS_CD
                                     , 'B'          AS SRC_TP
                                     , SC.BASE_NVL  AS NVL_VAL
                                  FROM GT_SCP0106_SPD_RAW_BASE SC
                                 UNION ALL
                                SELECT SD.DIVISION_ID
                                     , SD.COMPANY_ID
                                     , SD.SITE_ID
                                     , SD.PLANT_ID
                                     , SD.FACTORY_ID
                                     , SD.LINE_ID
                                     , SD.OPERATION_ID
                                     , SD.ELTR_LN_TP_CD
                                     , SD.MDL_NM
                                     , SD.YYYYMM
                                     , SD.LOSS_CD
                                     , 'O'          AS SRC_TP
                                     , SD.LOSS_RT   AS NVL_VAL
                                  FROM GT_SCP0106_SPD_RAW_BASE SD) SA
                         WHERE SA.SRC_TP(+)        = SB.SRC_TP
                           AND SA.DIVISION_ID(+)   = K.DIVISION_ID
                           AND SA.COMPANY_ID(+)    = K.COMPANY_ID
                           AND SA.SITE_ID(+)       = K.SITE_ID
                           AND SA.PLANT_ID(+)      = K.PLANT_ID
                           AND SA.FACTORY_ID(+)    = K.FACTORY_ID
                           AND SA.LINE_ID(+)       = K.LINE_ID
                           AND SA.OPERATION_ID(+)  = K.OPERATION_ID
                           AND SA.ELTR_LN_TP_CD(+) = K.ELTR_LN_TP_CD
                           AND SA.MDL_NM(+)        = K.MDL_NM
                           AND SA.YYYYMM(+)        = K.YYYYMM
                         GROUP BY SB.SRC_TP
                                , K.DIVISION_ID
                                , K.COMPANY_ID
                                , K.SITE_ID
                                , K.PLANT_ID
                                , K.FACTORY_ID
                                , K.LINE_ID
                                , K.OPERATION_ID
                                , K.ELTR_LN_TP_CD
                                , K.MDL_NM
                                , K.YYYYMM) IA
                     , GT_SCP0106_SPD_PLAN_RAW S
                 WHERE S.DIVISION_ID   = IA.DIVISION_ID
                   AND S.COMPANY_ID    = IA.COMPANY_ID
                   AND S.SITE_ID       = IA.SITE_ID
                   AND S.PLANT_ID      = IA.PLANT_ID
                   AND S.FACTORY_ID    = IA.FACTORY_ID
                   AND S.LINE_ID       = IA.LINE_ID
                   AND S.OPERATION_ID  = IA.OPERATION_ID
                   AND S.ELTR_LN_TP_CD = IA.ELTR_LN_TP_CD
                   AND S.NICK_NAME     = IA.MDL_NM
                   AND S.YYYYMM        = IA.YYYYMM) XA
         GROUP BY XA.SRC_TP
                , XA.DIVISION_ID
                , XA.COMPANY_ID
                , XA.SITE_ID
                , XA.PLANT_ID
                , XA.FACTORY_ID
                , XA.LINE_ID
                , XA.OPERATION_ID
                , XA.ELTR_LN_TP_CD
                , XA.MDL_NM
                , XA.YYYYMM;

        /* 7. 측정항목별로 되돌려 담고 평균을 낸다 */
        INSERT INTO GT_SCP0106_SPD_FINAL
             ( VER_ID, VER_SEQ, DIVISION_ID, MDL_NM, PLANT_ID, LINE_ID, OPERATION_ID
             , ELTR_LN_TP_CD, COMPANY_ID, SITE_ID, FACTORY_ID, MSR_TP_CD, YYYYMM
             , BASE_NVL, MSR_GR_CD, MSR_NVL )
        SELECT XA.VER_ID
             , XA.VER_SEQ
             , XA.DIVISION_ID
             , XA.MDL_NM
             , XA.PLANT_ID
             , XA.LINE_ID
             , XA.OPERATION_ID
             , XA.ELTR_LN_TP_CD
             , XA.COMPANY_ID
             , XA.SITE_ID
             , XA.FACTORY_ID
             , XA.MSR_TP_CD
             , XA.YYYYMM
             , AVG(XA.BASE_NVL)
             , XA.MSR_GR_CD
             , AVG(XA.MSR_NVL)
          FROM (SELECT V_VERSION                                            AS VER_ID
                     , V_VERSION_SEQ                                        AS VER_SEQ
                     , A.DIVISION_ID
                     , A.MDL_NM
                     , A.PLANT_ID
                     , A.LINE_ID
                     , A.OPERATION_ID
                     , A.ELTR_LN_TP_CD
                     , A.COMPANY_ID
                     , A.SITE_ID
                     , A.FACTORY_ID
                     , A.LOSS_CD                                            AS MSR_TP_CD
                     , A.YYYYMM
                     , CASE A.LOSS_CD
                            WHEN 'BM_RT'       THEN B.BM_RT
                            WHEN 'CM_RT'       THEN B.CM_RT
                            WHEN 'ID_RT'       THEN B.ID_RT
                            WHEN 'MR_RT'       THEN B.MR_RT
                            WHEN 'NM_RT'       THEN B.NM_RT
                            WHEN 'PD_RT'       THEN B.PD_RT
                            WHEN 'PM_RT'       THEN B.PM_RT
                            WHEN 'PP_RT'       THEN B.PP_RT
                            WHEN 'UD_RT'       THEN B.UD_RT
                            WHEN 'OP_RT'       THEN B.OP_RT
                            WHEN 'LD_RT'       THEN B.LD_RT
                            WHEN 'AV_RT'       THEN B.AV_RT
                            WHEN 'PF_RT'       THEN B.PF_RT
                            WHEN 'QL_RT'       THEN B.QL_RT
                            WHEN 'TEEP'        THEN B.TEEP
                            WHEN 'PROD_OP_RT'  THEN B.PROD_OP_RT
                            WHEN 'THRY_CAPA_D' THEN B.BASE_THRY_CAPA_D
                            WHEN 'PROD_CAPA_D' THEN B.BASE_PROD_CAPA_D
                            WHEN 'PROD_CAPA_M' THEN B.BASE_PROD_CAPA_M
                       END                                                  AS BASE_NVL
                     , A.MSR_GR_CD
                     , CASE A.LOSS_CD
                            WHEN 'BM_RT'       THEN O.BM_RT
                            WHEN 'CM_RT'       THEN O.CM_RT
                            WHEN 'ID_RT'       THEN O.ID_RT
                            WHEN 'MR_RT'       THEN O.MR_RT
                            WHEN 'NM_RT'       THEN O.NM_RT
                            WHEN 'PD_RT'       THEN O.PD_RT
                            WHEN 'PM_RT'       THEN O.PM_RT
                            WHEN 'PP_RT'       THEN O.PP_RT
                            WHEN 'UD_RT'       THEN O.UD_RT
                            WHEN 'OP_RT'       THEN O.OP_RT
                            WHEN 'LD_RT'       THEN O.LD_RT
                            WHEN 'AV_RT'       THEN O.AV_RT
                            WHEN 'PF_RT'       THEN O.PF_RT
                            WHEN 'QL_RT'       THEN O.QL_RT
                            WHEN 'TEEP'        THEN O.TEEP
                            WHEN 'PROD_OP_RT'  THEN O.PROD_OP_RT
                            WHEN 'THRY_CAPA_D' THEN O.THRY_CAPA_D
                            WHEN 'PROD_CAPA_D' THEN O.PROD_CAPA_D
                            WHEN 'PROD_CAPA_M' THEN O.PROD_CAPA_M
                       END                                                  AS MSR_NVL
                  FROM GT_SCP0106_SPD_LOSS_KEY K
                     , GT_SCP0106_SPD_PLAN_RAW S
                     , GT_SCP0106_SPD_RAW_BASE A
                     , GT_SCP0106_SPD_FIN B
                     , GT_SCP0106_SPD_FIN O
                 WHERE S.DIVISION_ID      = K.DIVISION_ID
                   AND S.COMPANY_ID       = K.COMPANY_ID
                   AND S.SITE_ID          = K.SITE_ID
                   AND S.PLANT_ID         = K.PLANT_ID
                   AND S.FACTORY_ID       = K.FACTORY_ID
                   AND S.LINE_ID          = K.LINE_ID
                   AND S.OPERATION_ID     = K.OPERATION_ID
                   AND S.ELTR_LN_TP_CD    = K.ELTR_LN_TP_CD
                   AND S.NICK_NAME        = K.MDL_NM
                   AND S.YYYYMM           = K.YYYYMM
                   AND A.DIVISION_ID(+)   = K.DIVISION_ID
                   AND A.COMPANY_ID(+)    = K.COMPANY_ID
                   AND A.SITE_ID(+)       = K.SITE_ID
                   AND A.PLANT_ID(+)      = K.PLANT_ID
                   AND A.FACTORY_ID(+)    = K.FACTORY_ID
                   AND A.LINE_ID(+)       = K.LINE_ID
                   AND A.OPERATION_ID(+)  = K.OPERATION_ID
                   AND A.ELTR_LN_TP_CD(+) = K.ELTR_LN_TP_CD
                   AND A.MDL_NM(+)        = K.MDL_NM
                   AND A.LOSS_CD(+)       = K.LOSS_CD
                   AND A.YYYYMM(+)        = K.YYYYMM
                   AND B.DIVISION_ID(+)   = A.DIVISION_ID
                   AND B.COMPANY_ID(+)    = A.COMPANY_ID
                   AND B.SITE_ID(+)       = A.SITE_ID
                   AND B.PLANT_ID(+)      = A.PLANT_ID
                   AND B.FACTORY_ID(+)    = A.FACTORY_ID
                   AND B.LINE_ID(+)       = A.LINE_ID
                   AND B.OPERATION_ID(+)  = A.OPERATION_ID
                   AND B.ELTR_LN_TP_CD(+) = A.ELTR_LN_TP_CD
                   AND B.MDL_NM(+)        = A.MDL_NM
                   AND B.YYYYMM(+)        = A.YYYYMM
                   AND B.SRC_TP(+)        = 'B'
                   AND O.DIVISION_ID(+)   = A.DIVISION_ID
                   AND O.COMPANY_ID(+)    = A.COMPANY_ID
                   AND O.SITE_ID(+)       = A.SITE_ID
                   AND O.PLANT_ID(+)      = A.PLANT_ID
                   AND O.FACTORY_ID(+)    = A.FACTORY_ID
                   AND O.LINE_ID(+)       = A.LINE_ID
                   AND O.OPERATION_ID(+)  = A.OPERATION_ID
                   AND O.ELTR_LN_TP_CD(+) = A.ELTR_LN_TP_CD
                   AND O.MDL_NM(+)        = A.MDL_NM
                   AND O.YYYYMM(+)        = A.YYYYMM
                   AND O.SRC_TP(+)        = 'O') XA
         GROUP BY XA.VER_ID
                , XA.VER_SEQ
                , XA.DIVISION_ID
                , XA.MDL_NM
                , XA.PLANT_ID
                , XA.LINE_ID
                , XA.OPERATION_ID
                , XA.ELTR_LN_TP_CD
                , XA.COMPANY_ID
                , XA.SITE_ID
                , XA.FACTORY_ID
                , XA.MSR_GR_CD
                , XA.MSR_TP_CD
                , XA.YYYYMM;

        /* 8. 능력 세 항목과 성능률만 원장에 반영한다(2024.07.31 기준) */
        /*    ★AS-IS 는 MERGE 이지만 넣는 갈래가 주석 처리되어 있어 수정만 한다 */
        UPDATE SCP_MST_CAPA_LOSS_PLAN_MDL A
           SET ( BASE_NVL
               , MSR_NVL
               , LAST_UPDATED_BY
               , LAST_UPDATE_DATE ) =
               (SELECT B.BASE_NVL
                     , B.MSR_NVL
                     , V_STAMP
                     , SYSDATE
                  FROM GT_SCP0106_SPD_FINAL B
                 WHERE B.DIVISION_ID   = A.DIVISION_ID
                   AND B.MDL_NM        = A.MDL_NM
                   AND B.PLANT_ID      = A.PLANT_ID
                   AND B.LINE_ID       = A.LINE_ID
                   AND B.OPERATION_ID  = A.OPERATION_ID
                   AND B.ELTR_LN_TP_CD = A.ELTR_LN_TP_CD
                   AND B.COMPANY_ID    = A.COMPANY_ID
                   AND B.SITE_ID       = A.SITE_ID
                   AND B.FACTORY_ID    = A.FACTORY_ID
                   AND B.MSR_TP_CD     = A.MSR_TP_CD
                   AND B.YYYYMM        = A.YYYYMM
                   AND B.MSR_GR_CD     = A.MSR_GR_CD)
         WHERE EXISTS (SELECT 1
                         FROM GT_SCP0106_SPD_FINAL B
                        WHERE B.DIVISION_ID   = A.DIVISION_ID
                          AND B.MDL_NM        = A.MDL_NM
                          AND B.PLANT_ID      = A.PLANT_ID
                          AND B.LINE_ID       = A.LINE_ID
                          AND B.OPERATION_ID  = A.OPERATION_ID
                          AND B.ELTR_LN_TP_CD = A.ELTR_LN_TP_CD
                          AND B.COMPANY_ID    = A.COMPANY_ID
                          AND B.SITE_ID       = A.SITE_ID
                          AND B.FACTORY_ID    = A.FACTORY_ID
                          AND B.MSR_TP_CD     = A.MSR_TP_CD
                          AND B.YYYYMM        = A.YYYYMM
                          AND B.MSR_GR_CD     = A.MSR_GR_CD
                          AND B.MSR_TP_CD IN ('THRY_CAPA_D', 'PROD_CAPA_D', 'PROD_CAPA_M', 'PF_RT'));

    END P_SCP0106_CHK_LOSS_SPD_ASM;


    /*******************************************************************************
     * P_SCP0106_CHK_LOSS_SPD_ELTR  (패키지 안에서만 쓰는 갈래)
     *   AS-IS SCP0106_CHECK_CAPA_LOSS_PLAN_BY_SPEED_ELTR
     *   속도계획이 바뀐 열쇠의 손실계획 능력값을 다시 계산해 원장을 고친다 — 전극
     *   전달 테이블은 GT_SCP_CAPA_SPEED_PLAN_KEYS 로 받는다(부르는 쪽이 채운다)
     *
     * ★조립 갈래와 갈리는 곳
     *   - 읽는 원장이 모두 전극 전용(라인 SOP · 속도계획 뷰 · 모델별 손실계획)
     *   - 전달받은 열쇠를 따로 묶지 않고 인자 표를 그대로 읽는다
     *   - 수량이 비어도 기준수량으로 갈음하지 않는다
     *   - 펼치는 측정항목이 생산운전율 하나뿐이다
     *   - 가동률을 원장에서 읽지 않고 1.0 으로 둔다(Current 조업율 100)
     *   - 생산운전율을 기준값이 아니라 운영계획값에서 가져온다
     *   - 운영계획 손실률을 0 으로 덮지 않는다 → 기준 쪽과 운영계획 쪽 값이 같아진다
     *   - 이론능력에 전극구분이 광폭('W')이면 2배가 붙는다
     *   - 손실계획을 계층만으로 맞춘다(모델 조건이 AS-IS 에 주석 처리되어 있다)
     *   - 속도계획을 약칭이 아니라 품목으로 맞춘다
     *   - 원장 반영이 두 벌이다 — 월별 운영계획과 기준값을 따로 고친다
     *     (기준값 쪽은 기간 조건 없이 맞춘다 — 기준이 바뀌면 전 구간을 다시 잡는다)
     *   - 바뀌지 않은 줄을 반영 전에 지운다(화면이 열쇠의 전 기간을 다 보내기 때문)
     * ★부르는 쪽이 트랜잭션을 쥐고 있으므로 이 갈래는 커밋하지 않는다.
     * ★최종변경자에 들어가는 이름은 AS-IS 표기를 그대로 둔다.
     *******************************************************************************/
    PROCEDURE P_SCP0106_CHK_LOSS_SPD_ELTR
    (
        P_PROGRAM_ID            IN  VARCHAR2
      , P_SHEET_NAME            IN  VARCHAR2
      , P_USER_ID               IN  VARCHAR2
      , P_DEBUG_MODE            IN  VARCHAR2
    )
    IS
        V_PROGRAM_NAME      VARCHAR2(150 CHAR) := 'SCP0106_CHECK_CAPA_LOSS_PLAN_BY_ASSIGN_ELTR';
        V_STAMP             VARCHAR2(800 CHAR);
        V_VERSION           VARCHAR2(40 CHAR);
        V_VERSION_SEQ       NUMBER;
    BEGIN

        V_STAMP := V_PROGRAM_NAME || '-' || P_USER_ID;

        SELECT MAX(VER_ID)
             , MAX(VER_SEQ)
          INTO V_VERSION
             , V_VERSION_SEQ
          FROM GT_SCP_CAPA_SPEED_PLAN_KEYS;

        DELETE GT_SCP0106_SPD_DAY_CNT;
        DELETE GT_SCP0106_SPD_PLAN_RAW;
        DELETE GT_SCP0106_SPD_PLAN_KEY;
        DELETE GT_SCP0106_SPD_RAW_BASE;
        DELETE GT_SCP0106_SPD_LOSS_KEY;
        DELETE GT_SCP0106_SPD_RAW_KEY;
        DELETE GT_SCP0106_SPD_FIN;
        DELETE GT_SCP0106_SPD_FINAL;
        DELETE GT_SCP0106_SPD_FINAL_BASE;

        /* 1. 전극 라인 SOP 일수 */
        INSERT INTO GT_SCP0106_SPD_DAY_CNT
             ( DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID
             , ELTR_LN_TP_CD, SOP_DT, YYYYMM, DAY_CNT, DAY_CNT_YEAR, YYYY )
        SELECT DIVISION_ID
             , COMPANY_ID
             , SITE_ID
             , PLANT_ID
             , FACTORY_ID
             , LINE_ID
             , OPERATION_ID
             , ELTR_LN_TP_CD
             , SOP_DT
             , SOP_YM
             , SOP_DDN
             , CASE WHEN TRIM(SOP_DT) IS NULL THEN 0
                    ELSE TO_DATE(SUBSTR(SOP_YM, 1, 4) || '1231', 'YYYYMMDD')
                       - TO_DATE(SOP_DT, 'YYYYMMDD') + 1
               END
             , SUBSTR(SOP_YM, 1, 4)
          FROM SCP_MST_CAPA_ELTR_LINE_SOP
         WHERE VALID_YN = 'Y';

        /* 2. 전극 속도계획 뷰에서 PPM 줄만. ★수량을 기준수량으로 갈음하지 않는다 */
        INSERT INTO GT_SCP0106_SPD_PLAN_RAW
             ( VER_ID, VER_SEQ, DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID
             , OPERATION_ID, ELTR_LN_TP_CD, ITEM_ID, NICK_NAME, MSR_TP_CD, YYYYMM
             , BASE_QTY, QTY, UI_UPD_YN, BASE_DAY_CNT, DAY_CNT )
        SELECT A.VER_ID
             , A.VER_SEQ
             , A.DIVISION_ID
             , A.COMPANY_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.LINE_ID
             , A.OPERATION_ID
             , A.ELTR_LN_TP_CD
             , A.ITEM_ID
             , A.NICK_NAME
             , A.MSR_TP_CD
             , A.YYYYMM
             , A.BASE_QTY
             , A.QTY
             , A.UI_UPD_YN
             , TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE(A.VER_ID || '01', 'YYYYMMDD')), 'DD'))
             - TO_NUMBER(TO_CHAR(TO_DATE(A.VER_ID || '01', 'YYYYMMDD'), 'DD')) + 1
             /* ★조업일수는 뷰 칸(DAY_CNT)을 읽지 않고 뷰와 같은 산식으로 직접 낸다 —
                  그 칸은 연도 줄(YYYYMM 네 자리)에서 ORA-01840 이 나는 이관 결함이 있다.
                  날짜 만들기를 SUBSTR 로 감싸 갈림 앞에서 셈해도 터지지 않게 한다. */
             , CASE WHEN LENGTH(A.YYYYMM) = 4 THEN
                         CASE WHEN DY.DIVISION_ID IS NULL
                              THEN TO_DATE(SUBSTR(A.YYYYMM, 1, 4) || '1231', 'YYYYMMDD')
                                 - TO_DATE(SUBSTR(A.YYYYMM, 1, 4) || '0101', 'YYYYMMDD') + 1
                              ELSE DY.DAY_CNT_YEAR
                         END
                    ELSE
                         CASE WHEN DC.DIVISION_ID IS NULL
                              THEN EXTRACT(DAY FROM LAST_DAY(TO_DATE(SUBSTR(A.YYYYMM || '0101', 1, 8), 'YYYYMMDD')))
                              ELSE DC.DAY_CNT
                         END
               END
          FROM SCP_MST_CAPA_ELTR_SPEED_PLAN_V A
             , GT_SCP0106_SPD_DAY_CNT DC
             , GT_SCP0106_SPD_DAY_CNT DY
         WHERE DC.DIVISION_ID(+)    = A.DIVISION_ID
           AND DC.COMPANY_ID(+)     = A.COMPANY_ID
           AND DC.SITE_ID(+)        = A.SITE_ID
           AND DC.PLANT_ID(+)       = A.PLANT_ID
           AND DC.FACTORY_ID(+)     = A.FACTORY_ID
           AND DC.LINE_ID(+)        = A.LINE_ID
           AND DC.OPERATION_ID(+)   = A.OPERATION_ID
           AND DC.YYYYMM(+)         = A.YYYYMM
           AND DY.DIVISION_ID(+)    = A.DIVISION_ID
           AND DY.COMPANY_ID(+)     = A.COMPANY_ID
           AND DY.SITE_ID(+)        = A.SITE_ID
           AND DY.PLANT_ID(+)       = A.PLANT_ID
           AND DY.FACTORY_ID(+)     = A.FACTORY_ID
           AND DY.LINE_ID(+)        = A.LINE_ID
           AND DY.OPERATION_ID(+)   = A.OPERATION_ID
           AND DY.YYYY(+)           = A.YYYYMM
           AND A.MSR_TP_CD = 'PPM'   /* PPM 변경시 영향을 받으므로 */
           AND EXISTS (SELECT 1
                         FROM GT_SCP_CAPA_SPEED_PLAN_KEYS IA
                        WHERE IA.DIVISION_ID   = A.DIVISION_ID
                          AND IA.COMPANY_ID    = A.COMPANY_ID
                          AND IA.SITE_ID       = A.SITE_ID
                          AND IA.PLANT_ID      = A.PLANT_ID
                          AND IA.FACTORY_ID    = A.FACTORY_ID
                          AND IA.LINE_ID       = A.LINE_ID
                          AND IA.OPERATION_ID  = A.OPERATION_ID
                          AND IA.ELTR_LN_TP_CD = A.ELTR_LN_TP_CD
                          AND IA.ITEM_ID       = A.ITEM_ID
                          AND IA.NICK_NAME     = A.NICK_NAME
                          AND IA.YYYYMM        = A.YYYYMM);

        /* 3. 속도계획 열쇠 묶음. ★모델 자리에 품목이 들어간다 */
        INSERT INTO GT_SCP0106_SPD_PLAN_KEY
             ( DIVISION_ID, MDL_NM, PLANT_ID, LINE_ID, OPERATION_ID, ELTR_LN_TP_CD
             , COMPANY_ID, SITE_ID, FACTORY_ID )
        SELECT A.DIVISION_ID
             , A.ITEM_ID
             , A.PLANT_ID
             , A.LINE_ID
             , A.OPERATION_ID
             , A.ELTR_LN_TP_CD
             , A.COMPANY_ID
             , A.SITE_ID
             , A.FACTORY_ID
          FROM GT_SCP0106_SPD_PLAN_RAW A
         GROUP BY A.DIVISION_ID
                , A.ITEM_ID
                , A.PLANT_ID
                , A.LINE_ID
                , A.OPERATION_ID
                , A.ELTR_LN_TP_CD
                , A.COMPANY_ID
                , A.SITE_ID
                , A.FACTORY_ID;

        /* 4. 그 열쇠의 모델별 손실계획. ★계층만으로 맞춘다(모델 조건이 AS-IS 에 주석 처리) */
        /*    ★운영계획 손실률을 0 으로 덮지 않는다 — 기준 쪽과 같은 값이 된다 */
        INSERT INTO GT_SCP0106_SPD_RAW_BASE
             ( DIVISION_ID, SITE_ID, COMPANY_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID
             , ELTR_LN_TP_CD, MDL_NM, MSR_GR_CD, LOSS_CD, YYYYMM, PFRSLT_NVL, BASE_NVL, LOSS_RT )
        SELECT A.DIVISION_ID
             , A.SITE_ID
             , A.COMPANY_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.LINE_ID
             , A.OPERATION_ID
             , A.ELTR_LN_TP_CD
             , A.MDL_NM
             , A.MSR_GR_CD
             , A.MSR_TP_CD
             , A.YYYYMM
             , A.PFRSLT_NVL
             , A.BASE_NVL
             , A.MSR_NVL
          FROM SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL A
             , GT_SCP0106_SPD_PLAN_KEY B
         WHERE B.DIVISION_ID   = A.DIVISION_ID
           AND B.COMPANY_ID    = A.COMPANY_ID
           AND B.SITE_ID       = A.SITE_ID
           AND B.PLANT_ID      = A.PLANT_ID
           AND B.FACTORY_ID    = A.FACTORY_ID
           AND B.LINE_ID       = A.LINE_ID
           AND B.OPERATION_ID  = A.OPERATION_ID;

        /* 5. 측정항목을 포함한 열쇠 · 뺀 열쇠 */
        INSERT INTO GT_SCP0106_SPD_LOSS_KEY
             ( DIVISION_ID, SITE_ID, COMPANY_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID
             , ELTR_LN_TP_CD, MDL_NM, MSR_GR_CD, LOSS_CD, YYYYMM )
        SELECT A.DIVISION_ID
             , A.SITE_ID
             , A.COMPANY_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.LINE_ID
             , A.OPERATION_ID
             , A.ELTR_LN_TP_CD
             , A.MDL_NM
             , A.MSR_GR_CD
             , A.LOSS_CD
             , A.YYYYMM
          FROM GT_SCP0106_SPD_RAW_BASE A
         GROUP BY A.DIVISION_ID
                , A.SITE_ID
                , A.COMPANY_ID
                , A.PLANT_ID
                , A.FACTORY_ID
                , A.LINE_ID
                , A.OPERATION_ID
                , A.ELTR_LN_TP_CD
                , A.MDL_NM
                , A.MSR_GR_CD
                , A.LOSS_CD
                , A.YYYYMM;

        INSERT INTO GT_SCP0106_SPD_RAW_KEY
             ( DIVISION_ID, SITE_ID, COMPANY_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID
             , ELTR_LN_TP_CD, MDL_NM, YYYYMM )
        SELECT A.DIVISION_ID
             , A.SITE_ID
             , A.COMPANY_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.LINE_ID
             , A.OPERATION_ID
             , A.ELTR_LN_TP_CD
             , A.MDL_NM
             , A.YYYYMM
          FROM GT_SCP0106_SPD_LOSS_KEY A
         GROUP BY A.DIVISION_ID
                , A.SITE_ID
                , A.COMPANY_ID
                , A.PLANT_ID
                , A.FACTORY_ID
                , A.LINE_ID
                , A.OPERATION_ID
                , A.ELTR_LN_TP_CD
                , A.MDL_NM
                , A.YYYYMM;

        /* 6. 능력값 계산. ★생산운전율 하나만 쓰고 가동률은 1.0, 광폭이면 이론능력이 2배          */
        /*    ★기준 쪽과 운영계획 쪽 산식이 같으므로 한 벌만 담고 두 자리에서 같이 쓴다            */
        /*      (AS-IS 는 두 벌을 따로 만들지만 운영계획 손실률을 덮지 않아 값이 같다)              */
        INSERT INTO GT_SCP0106_SPD_FIN
             ( SRC_TP, DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID
             , OPERATION_ID, ELTR_LN_TP_CD, MDL_NM, YYYYMM
             , AV_RT, PROD_OP_RT
             , THRY_CAPA_D, PROD_CAPA_D, PROD_CAPA_M
             , BASE_THRY_CAPA_D, BASE_PROD_CAPA_D, BASE_PROD_CAPA_M
             , PPM, BASE_PPM )
        SELECT 'B'
             , A.DIVISION_ID
             , A.COMPANY_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.LINE_ID
             , A.OPERATION_ID
             , A.ELTR_LN_TP_CD
             , A.MDL_NM
             , A.YYYYMM
             , 1.0
             , B.PROD_OP_RT
             , CASE WHEN A.ELTR_LN_TP_CD = 'W' THEN 2.0 ELSE 1.0 END * (S.QTY * 1440.0)
             , CASE WHEN A.ELTR_LN_TP_CD = 'W' THEN 2.0 ELSE 1.0 END * (S.QTY * 1440.0) * B.PROD_OP_RT
             , CASE WHEN A.ELTR_LN_TP_CD = 'W' THEN 2.0 ELSE 1.0 END * (S.QTY * 1440.0) * B.PROD_OP_RT * S.DAY_CNT
             , CASE WHEN A.ELTR_LN_TP_CD = 'W' THEN 2.0 ELSE 1.0 END * (S.BASE_QTY * 1440.0)
             , CASE WHEN A.ELTR_LN_TP_CD = 'W' THEN 2.0 ELSE 1.0 END * (S.BASE_QTY * 1440.0) * B.PROD_OP_RT
             , CASE WHEN A.ELTR_LN_TP_CD = 'W' THEN 2.0 ELSE 1.0 END * (S.BASE_QTY * 1440.0) * B.PROD_OP_RT * S.BASE_DAY_CNT
             , S.QTY
             , S.BASE_QTY
          FROM GT_SCP0106_SPD_RAW_KEY A
             , (SELECT IA.DIVISION_ID
                     , IA.COMPANY_ID
                     , IA.SITE_ID
                     , IA.PLANT_ID
                     , IA.FACTORY_ID
                     , IA.LINE_ID
                     , IA.OPERATION_ID
                     , IA.MDL_NM
                     , IA.YYYYMM
                     , MAX(IA.LOSS_RT) AS PROD_OP_RT
                  FROM GT_SCP0106_SPD_RAW_BASE IA
                 WHERE IA.LOSS_CD = 'PROD_OP_RT'
                 GROUP BY IA.DIVISION_ID
                        , IA.COMPANY_ID
                        , IA.SITE_ID
                        , IA.PLANT_ID
                        , IA.FACTORY_ID
                        , IA.LINE_ID
                        , IA.OPERATION_ID
                        , IA.MDL_NM
                        , IA.YYYYMM) B
             , GT_SCP0106_SPD_PLAN_RAW S
         WHERE B.DIVISION_ID(+)   = A.DIVISION_ID
           AND B.COMPANY_ID(+)    = A.COMPANY_ID
           AND B.SITE_ID(+)       = A.SITE_ID
           AND B.PLANT_ID(+)      = A.PLANT_ID
           AND B.FACTORY_ID(+)    = A.FACTORY_ID
           AND B.LINE_ID(+)       = A.LINE_ID
           AND B.OPERATION_ID(+)  = A.OPERATION_ID
           AND B.MDL_NM(+)        = A.MDL_NM
           AND B.YYYYMM(+)        = A.YYYYMM
           AND S.DIVISION_ID   = A.DIVISION_ID
           AND S.COMPANY_ID    = A.COMPANY_ID
           AND S.SITE_ID       = A.SITE_ID
           AND S.PLANT_ID      = A.PLANT_ID
           AND S.FACTORY_ID    = A.FACTORY_ID
           AND S.LINE_ID       = A.LINE_ID
           AND S.OPERATION_ID  = A.OPERATION_ID
           AND S.ITEM_ID       = A.MDL_NM
           AND S.YYYYMM        = A.YYYYMM;

        /* 7. 능력 세 항목만 되돌려 담고 최대값을 낸다. ★모델이 '-' 인 줄은 뺀다 */
        INSERT INTO GT_SCP0106_SPD_FINAL
             ( VER_ID, VER_SEQ, DIVISION_ID, MDL_NM, PLANT_ID, LINE_ID, OPERATION_ID
             , ELTR_LN_TP_CD, COMPANY_ID, SITE_ID, FACTORY_ID, MSR_TP_CD, YYYYMM
             , BASE_NVL, MSR_GR_CD, MSR_NVL )
        SELECT XA.VER_ID
             , XA.VER_SEQ
             , XA.DIVISION_ID
             , XA.MDL_NM
             , XA.PLANT_ID
             , XA.LINE_ID
             , XA.OPERATION_ID
             , XA.ELTR_LN_TP_CD
             , XA.COMPANY_ID
             , XA.SITE_ID
             , XA.FACTORY_ID
             , XA.MSR_TP_CD
             , XA.YYYYMM
             , MAX(XA.BASE_NVL)
             , MAX(XA.MSR_GR_CD)
             , MAX(XA.MSR_NVL)
          FROM (SELECT V_VERSION                                    AS VER_ID
                     , V_VERSION_SEQ                                AS VER_SEQ
                     , A.DIVISION_ID
                     , A.MDL_NM
                     , A.PLANT_ID
                     , A.LINE_ID
                     , A.OPERATION_ID
                     , A.ELTR_LN_TP_CD
                     , A.COMPANY_ID
                     , A.SITE_ID
                     , A.FACTORY_ID
                     , A.LOSS_CD                                    AS MSR_TP_CD
                     , A.YYYYMM
                     , CASE A.LOSS_CD
                            WHEN 'THRY_CAPA_D' THEN B.BASE_THRY_CAPA_D
                            WHEN 'PROD_CAPA_D' THEN B.BASE_PROD_CAPA_D
                            WHEN 'PROD_CAPA_M' THEN B.BASE_PROD_CAPA_M
                       END                                          AS BASE_NVL
                     , A.MSR_GR_CD
                     , CASE A.LOSS_CD
                            WHEN 'THRY_CAPA_D' THEN O.THRY_CAPA_D
                            WHEN 'PROD_CAPA_D' THEN O.PROD_CAPA_D
                            WHEN 'PROD_CAPA_M' THEN O.PROD_CAPA_M
                       END                                          AS MSR_NVL
                  FROM GT_SCP0106_SPD_RAW_BASE A
                     , GT_SCP0106_SPD_FIN B
                     , GT_SCP0106_SPD_FIN O
                 WHERE B.DIVISION_ID   = A.DIVISION_ID
                   AND B.COMPANY_ID    = A.COMPANY_ID
                   AND B.SITE_ID       = A.SITE_ID
                   AND B.PLANT_ID      = A.PLANT_ID
                   AND B.FACTORY_ID    = A.FACTORY_ID
                   AND B.LINE_ID       = A.LINE_ID
                   AND B.OPERATION_ID  = A.OPERATION_ID
                   AND B.MDL_NM        = A.MDL_NM
                   AND B.YYYYMM        = A.YYYYMM
                   AND O.DIVISION_ID   = A.DIVISION_ID
                   AND O.COMPANY_ID    = A.COMPANY_ID
                   AND O.SITE_ID       = A.SITE_ID
                   AND O.PLANT_ID      = A.PLANT_ID
                   AND O.FACTORY_ID    = A.FACTORY_ID
                   AND O.LINE_ID       = A.LINE_ID
                   AND O.OPERATION_ID  = A.OPERATION_ID
                   AND O.MDL_NM        = A.MDL_NM
                   AND O.YYYYMM        = A.YYYYMM
                   AND A.LOSS_CD IN ('THRY_CAPA_D', 'PROD_CAPA_D', 'PROD_CAPA_M')
                   AND A.MDL_NM <> '-') XA
         GROUP BY XA.VER_ID
                , XA.VER_SEQ
                , XA.DIVISION_ID
                , XA.MDL_NM
                , XA.PLANT_ID
                , XA.LINE_ID
                , XA.OPERATION_ID
                , XA.ELTR_LN_TP_CD
                , XA.COMPANY_ID
                , XA.SITE_ID
                , XA.FACTORY_ID
                , XA.MSR_TP_CD
                , XA.YYYYMM;

        /* 8. 기준값은 기간을 빼고 다시 묶는다 — 기준이 바뀌면 전 구간을 다시 잡는다 */
        INSERT INTO GT_SCP0106_SPD_FINAL_BASE
             ( VER_ID, VER_SEQ, DIVISION_ID, MDL_NM, PLANT_ID, LINE_ID, OPERATION_ID
             , ELTR_LN_TP_CD, COMPANY_ID, SITE_ID, FACTORY_ID, MSR_TP_CD, BASE_NVL, MSR_GR_CD )
        SELECT A.VER_ID
             , A.VER_SEQ
             , A.DIVISION_ID
             , A.MDL_NM
             , A.PLANT_ID
             , A.LINE_ID
             , A.OPERATION_ID
             , A.ELTR_LN_TP_CD
             , A.COMPANY_ID
             , A.SITE_ID
             , A.FACTORY_ID
             , A.MSR_TP_CD
             , MAX(A.BASE_NVL)
             , A.MSR_GR_CD
          FROM GT_SCP0106_SPD_FINAL A
         GROUP BY A.VER_ID
                , A.VER_SEQ
                , A.DIVISION_ID
                , A.MDL_NM
                , A.PLANT_ID
                , A.LINE_ID
                , A.OPERATION_ID
                , A.ELTR_LN_TP_CD
                , A.COMPANY_ID
                , A.SITE_ID
                , A.FACTORY_ID
                , A.MSR_TP_CD
                , A.MSR_GR_CD;

        /* 9. 바뀌지 않은 줄은 반영 대상에서 뺀다 */
        /*    (화면이 열쇠의 전 기간을 다 보내므로 여기서 걸러야 한다) */
        DELETE GT_SCP0106_SPD_FINAL A
         WHERE EXISTS (SELECT 1
                         FROM SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL B
                        WHERE B.DIVISION_ID   = A.DIVISION_ID
                          AND B.MDL_NM        = A.MDL_NM
                          AND B.PLANT_ID      = A.PLANT_ID
                          AND B.LINE_ID       = A.LINE_ID
                          AND B.OPERATION_ID  = A.OPERATION_ID
                          AND B.COMPANY_ID    = A.COMPANY_ID
                          AND B.SITE_ID       = A.SITE_ID
                          AND B.FACTORY_ID    = A.FACTORY_ID
                          AND B.MSR_TP_CD     = A.MSR_TP_CD
                          AND B.YYYYMM        = A.YYYYMM
                          AND B.MSR_GR_CD     = A.MSR_GR_CD
                          AND NVL(A.MSR_NVL, 0.0) = NVL(B.MSR_NVL, 0.0)
                          AND NVL(A.ELTR_LN_TP_CD, ' ') = NVL(B.ELTR_LN_TP_CD, ' '));

        DELETE GT_SCP0106_SPD_FINAL_BASE A
         WHERE EXISTS (SELECT 1
                         FROM SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL B
                        WHERE B.DIVISION_ID   = A.DIVISION_ID
                          AND B.MDL_NM        = A.MDL_NM
                          AND B.PLANT_ID      = A.PLANT_ID
                          AND B.LINE_ID       = A.LINE_ID
                          AND B.OPERATION_ID  = A.OPERATION_ID
                          AND B.COMPANY_ID    = A.COMPANY_ID
                          AND B.SITE_ID       = A.SITE_ID
                          AND B.FACTORY_ID    = A.FACTORY_ID
                          AND B.MSR_TP_CD     = A.MSR_TP_CD
                          AND B.MSR_GR_CD     = A.MSR_GR_CD
                          AND NVL(A.BASE_NVL, 0.0) = NVL(B.BASE_NVL, 0.0)
                          AND NVL(A.ELTR_LN_TP_CD, ' ') = NVL(B.ELTR_LN_TP_CD, ' '));

        /* 10. 월별 운영계획 반영. ★전극구분은 맞추지 않고 값으로 덮는다 */
        UPDATE SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL A
           SET ( MSR_NVL
               , ELTR_LN_TP_CD
               , LAST_UPDATED_BY
               , LAST_UPDATE_DATE ) =
               (SELECT B.MSR_NVL
                     , B.ELTR_LN_TP_CD
                     , V_STAMP
                     , SYSDATE
                  FROM GT_SCP0106_SPD_FINAL B
                 WHERE B.DIVISION_ID   = A.DIVISION_ID
                   AND B.MDL_NM        = A.MDL_NM
                   AND B.PLANT_ID      = A.PLANT_ID
                   AND B.LINE_ID       = A.LINE_ID
                   AND B.OPERATION_ID  = A.OPERATION_ID
                   AND B.COMPANY_ID    = A.COMPANY_ID
                   AND B.SITE_ID       = A.SITE_ID
                   AND B.FACTORY_ID    = A.FACTORY_ID
                   AND B.MSR_TP_CD     = A.MSR_TP_CD
                   AND B.YYYYMM        = A.YYYYMM
                   AND B.MSR_GR_CD     = A.MSR_GR_CD)
         WHERE EXISTS (SELECT 1
                         FROM GT_SCP0106_SPD_FINAL B
                        WHERE B.DIVISION_ID   = A.DIVISION_ID
                          AND B.MDL_NM        = A.MDL_NM
                          AND B.PLANT_ID      = A.PLANT_ID
                          AND B.LINE_ID       = A.LINE_ID
                          AND B.OPERATION_ID  = A.OPERATION_ID
                          AND B.COMPANY_ID    = A.COMPANY_ID
                          AND B.SITE_ID       = A.SITE_ID
                          AND B.FACTORY_ID    = A.FACTORY_ID
                          AND B.MSR_TP_CD     = A.MSR_TP_CD
                          AND B.YYYYMM        = A.YYYYMM
                          AND B.MSR_GR_CD     = A.MSR_GR_CD);

        /* 11. 기준값 반영. ★기간 조건이 없다 — 열쇠의 전 구간을 고친다 */
        UPDATE SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL A
           SET ( BASE_NVL
               , ELTR_LN_TP_CD
               , LAST_UPDATED_BY
               , LAST_UPDATE_DATE ) =
               (SELECT MAX(B.BASE_NVL)
                     , MAX(B.ELTR_LN_TP_CD)
                     , V_STAMP
                     , SYSDATE
                  FROM GT_SCP0106_SPD_FINAL_BASE B
                 WHERE B.DIVISION_ID   = A.DIVISION_ID
                   AND B.MDL_NM        = A.MDL_NM
                   AND B.PLANT_ID      = A.PLANT_ID
                   AND B.LINE_ID       = A.LINE_ID
                   AND B.OPERATION_ID  = A.OPERATION_ID
                   AND B.COMPANY_ID    = A.COMPANY_ID
                   AND B.SITE_ID       = A.SITE_ID
                   AND B.FACTORY_ID    = A.FACTORY_ID
                   AND B.MSR_TP_CD     = A.MSR_TP_CD
                   AND B.MSR_GR_CD     = A.MSR_GR_CD)
         WHERE EXISTS (SELECT 1
                         FROM GT_SCP0106_SPD_FINAL_BASE B
                        WHERE B.DIVISION_ID   = A.DIVISION_ID
                          AND B.MDL_NM        = A.MDL_NM
                          AND B.PLANT_ID      = A.PLANT_ID
                          AND B.LINE_ID       = A.LINE_ID
                          AND B.OPERATION_ID  = A.OPERATION_ID
                          AND B.COMPANY_ID    = A.COMPANY_ID
                          AND B.SITE_ID       = A.SITE_ID
                          AND B.FACTORY_ID    = A.FACTORY_ID
                          AND B.MSR_TP_CD     = A.MSR_TP_CD
                          AND B.MSR_GR_CD     = A.MSR_GR_CD);

    END P_SCP0106_CHK_LOSS_SPD_ELTR;


    /*******************************************************************************
     * P_SCP0105_SPLIT_CLOB  (패키지 안에서만 쓰는 갈래)
     *   화면이 보내는 긴 칸 값을 구분자로 풀어 자리 번호와 함께 적재
     *   (원문은 dbo.String_Split 을 쓰나 전달값이 길어 CLOB 로 받으므로 따로 둔다)
     *******************************************************************************/
    PROCEDURE P_SCP0105_SPLIT_CLOB
    (
        P_SLOT_NO               IN  NUMBER
      , P_CLOB                  IN  CLOB
      , P_DELIM                 IN  VARCHAR2
    )
    IS
        V_LEN       NUMBER      := NVL(DBMS_LOB.GETLENGTH(P_CLOB), 0);
        V_FROM      NUMBER      := 1;
        V_POS       NUMBER      := 0;
        V_NR        NUMBER      := 0;
        V_TOKEN     VARCHAR2(32767 CHAR);
    BEGIN

        IF V_LEN = 0 THEN
            RETURN;
        END IF;

        LOOP

            V_POS := DBMS_LOB.INSTR(P_CLOB, P_DELIM, V_FROM, 1);
            V_NR  := V_NR + 1;

            IF V_POS = 0 THEN

                V_TOKEN := DBMS_LOB.SUBSTR(P_CLOB, V_LEN - V_FROM + 1, V_FROM);

                INSERT INTO GT_SCP0105_SAV_TOKEN
                            ( SLOT_NO
                            , NR
                            , TOKEN )
                     VALUES ( P_SLOT_NO
                            , V_NR
                            , V_TOKEN );

                EXIT;

            END IF;

            IF V_POS > V_FROM THEN
                V_TOKEN := DBMS_LOB.SUBSTR(P_CLOB, V_POS - V_FROM, V_FROM);
            ELSE
                V_TOKEN := NULL;
            END IF;

            INSERT INTO GT_SCP0105_SAV_TOKEN
                        ( SLOT_NO
                        , NR
                        , TOKEN )
                 VALUES ( P_SLOT_NO
                        , V_NR
                        , V_TOKEN );

            V_FROM := V_POS + LENGTH(P_DELIM);

            IF V_FROM > V_LEN THEN
                EXIT;
            END IF;

        END LOOP;

    END P_SCP0105_SPLIT_CLOB;


    /*******************************************************************************
     * P_SCP0105_SAVE_SPEED_ASM  (패키지 안에서만 쓰는 갈래)
     *   AS-IS SCP0105_SAVE_CAPA_SPEED_PLAN_ASSEMBLY — 조립 저장
     *
     * AS-IS 절차
     *   1. 화면이 줄마다 `^` 로, 줄 안의 날짜 칸을 `;` 로 이어 보낸 값을 세로로 펼친다.
     *   2. 날짜 칸 이름에서 기간을 떼어 기간별 값으로 만든다(달 칸은 M_01…, 해 칸은 Y_…).
     *   3. 열쇠가 빈 줄을 뺀다.
     *   4. 원장과 견줘 값이 바뀐 줄만 남긴다.
     *   5. 현재분일 때만 원장을 고치고, 분당 생산량 줄만 손실계획 재계산에 넘긴다.
     *
     * ★AS-IS 는 커서로 줄마다 돌며 날짜 칸을 풀지만 자리 번호를 붙여 담는 것으로 같은 결과가 된다.
     *   ★빈 토큰도 자리를 차지하므로(`;;2;1` 은 1·2 가 빈 값) 자리 번호를 맞춰야 값이 밀리지 않는다.
     * ★AS-IS 는 MERGE 지만 넣는 갈래가 주석 처리되어 있어 수정만 한다 — 없는 열쇠는 넣지 않는다.
     * ★원장과 견주는 열쇠에 품목이 없다(약칭까지만 맞춘다) — AS-IS 그대로.
     * ★분당 생산량만 넘긴다 — PPM 만 있으면 Loss Plan 계산 가능하므로 설비대수, Speed는 제외!!!
     * ★부르는 쪽이 트랜잭션을 쥐고 있으므로 이 갈래는 커밋하지 않는다.
     *******************************************************************************/
    PROCEDURE P_SCP0105_SAVE_SPEED_ASM
    (
        P_VERSION               IN  VARCHAR2
      , P_VERSION_SEQ           IN  VARCHAR2
      , P_PROG_STAT             IN  VARCHAR2
      , P_DIVISION_ID           IN  CLOB
      , P_COMPANY_ID            IN  CLOB
      , P_SITE_ID               IN  CLOB
      , P_PLANT_ID              IN  CLOB
      , P_FACTORY_ID            IN  CLOB
      , P_LINE_ID               IN  CLOB
      , P_OPERATION_ID          IN  CLOB
      , P_ELECTRODE_TYPE        IN  CLOB
      , P_ITEM_ID               IN  CLOB
      , P_NICK_NAME             IN  CLOB
      , P_CAPA_SPEED_MEASURE    IN  CLOB
      , P_BASE_QTY              IN  CLOB
      , P_UI_UPD_YN             IN  CLOB
      , P_DATE_COLUMN_NAMES     IN  CLOB
      , P_DATE_COLUMN_VALUES    IN  CLOB
      , P_PROGRAM_ID            IN  VARCHAR2
      , P_SHEET_NAME            IN  VARCHAR2
      , P_USER_ID               IN  VARCHAR2
      , DEBUG_MODE              IN  VARCHAR2
      , O_RESULT_CNT            OUT NUMBER
    )
    IS
        C_DELIMITER     CONSTANT VARCHAR2(1 CHAR) := '^';
        C_NAME_SLOT     CONSTANT NUMBER           := 14;
        C_VALUE_SLOT    CONSTANT NUMBER           := 15;
        C_NAME_BASE     CONSTANT NUMBER           := 100000;
        C_VALUE_BASE    CONSTANT NUMBER           := 200000;
    BEGIN

        O_RESULT_CNT := SCM_ARR_SPL_CNT(TO_CHAR(SUBSTR(P_DIVISION_ID, 1, 32767)), C_DELIMITER);

        DELETE GT_SCP0105_SAV_TOKEN;
        DELETE GT_SCP0105_SAV_IN;
        DELETE GT_SCP0105_SAV_ALL;
        DELETE GT_SCP0105_SAV_CHG;

        /* 1. 전달값을 줄 단위로 푼다 */
        P_SCP0105_SPLIT_CLOB( 1, P_DIVISION_ID,         C_DELIMITER);
        P_SCP0105_SPLIT_CLOB( 2, P_COMPANY_ID,          C_DELIMITER);
        P_SCP0105_SPLIT_CLOB( 3, P_SITE_ID,             C_DELIMITER);
        P_SCP0105_SPLIT_CLOB( 4, P_PLANT_ID,            C_DELIMITER);
        P_SCP0105_SPLIT_CLOB( 5, P_FACTORY_ID,          C_DELIMITER);
        P_SCP0105_SPLIT_CLOB( 6, P_LINE_ID,             C_DELIMITER);
        P_SCP0105_SPLIT_CLOB( 7, P_OPERATION_ID,        C_DELIMITER);
        P_SCP0105_SPLIT_CLOB( 8, P_ELECTRODE_TYPE,      C_DELIMITER);
        P_SCP0105_SPLIT_CLOB( 9, P_ITEM_ID,             C_DELIMITER);
        P_SCP0105_SPLIT_CLOB(10, P_NICK_NAME,           C_DELIMITER);
        P_SCP0105_SPLIT_CLOB(11, P_CAPA_SPEED_MEASURE,  C_DELIMITER);
        P_SCP0105_SPLIT_CLOB(12, P_BASE_QTY,            C_DELIMITER);
        P_SCP0105_SPLIT_CLOB(13, P_UI_UPD_YN,           C_DELIMITER);
        P_SCP0105_SPLIT_CLOB(C_NAME_SLOT,  P_DATE_COLUMN_NAMES,  C_DELIMITER);
        P_SCP0105_SPLIT_CLOB(C_VALUE_SLOT, P_DATE_COLUMN_VALUES, C_DELIMITER);

        INSERT INTO GT_SCP0105_SAV_IN
             ( ROW_NR, DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID
             , OPERATION_ID, ELTR_LN_TP_CD, ITEM_ID, NICK_NAME, MSR_TP_CD
             , BASE_QTY_TXT, UI_UPD_YN )
        SELECT A.NR
             , MAX(CASE WHEN A.SLOT_NO =  1 THEN A.TOKEN END)
             , MAX(CASE WHEN A.SLOT_NO =  2 THEN A.TOKEN END)
             , MAX(CASE WHEN A.SLOT_NO =  3 THEN A.TOKEN END)
             , MAX(CASE WHEN A.SLOT_NO =  4 THEN A.TOKEN END)
             , MAX(CASE WHEN A.SLOT_NO =  5 THEN A.TOKEN END)
             , MAX(CASE WHEN A.SLOT_NO =  6 THEN A.TOKEN END)
             , MAX(CASE WHEN A.SLOT_NO =  7 THEN A.TOKEN END)
             , MAX(CASE WHEN A.SLOT_NO =  8 THEN A.TOKEN END)
             , MAX(CASE WHEN A.SLOT_NO =  9 THEN A.TOKEN END)
             , MAX(CASE WHEN A.SLOT_NO = 10 THEN A.TOKEN END)
             , MAX(CASE WHEN A.SLOT_NO = 11 THEN A.TOKEN END)
             , MAX(CASE WHEN A.SLOT_NO = 12 THEN A.TOKEN END)
             , MAX(CASE WHEN A.SLOT_NO = 13 THEN A.TOKEN END)
          FROM GT_SCP0105_SAV_TOKEN A
         WHERE A.SLOT_NO BETWEEN 1 AND 13
         GROUP BY A.NR;

        /* 2. 줄마다 날짜 칸 이름과 값을 다시 푼다 */
        FOR R IN ( SELECT A.NR
                        , MAX(CASE WHEN A.SLOT_NO = C_NAME_SLOT  THEN A.TOKEN END) AS COL_NAMES
                        , MAX(CASE WHEN A.SLOT_NO = C_VALUE_SLOT THEN A.TOKEN END) AS COL_VALUES
                     FROM GT_SCP0105_SAV_TOKEN A
                    WHERE A.SLOT_NO IN (C_NAME_SLOT, C_VALUE_SLOT)
                    GROUP BY A.NR
                   HAVING MAX(CASE WHEN A.SLOT_NO = C_NAME_SLOT THEN A.TOKEN END) IS NOT NULL )
        LOOP
            P_SCP0105_SPLIT_CLOB(C_NAME_BASE  + R.NR, TO_CLOB(R.COL_NAMES),  ';');
            P_SCP0105_SPLIT_CLOB(C_VALUE_BASE + R.NR, TO_CLOB(R.COL_VALUES), ';');
        END LOOP;

        /* 3. 날짜 칸을 세로로 펼친다. ★달 칸은 이름 3~4자리가 '01' 인 것, 해 칸은 'Y_' 로 시작 */
        INSERT INTO GT_SCP0105_SAV_ALL
             ( VER_ID, VER_SEQ, DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID
             , OPERATION_ID, ELTR_LN_TP_CD, ITEM_ID, NICK_NAME, MSR_TP_CD, BASE_QTY, UI_UPD_YN
             , YYYYMM, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
        SELECT P_VERSION
             , TO_NUMBER(P_VERSION_SEQ)
             , A.DIVISION_ID
             , A.COMPANY_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.LINE_ID
             , A.OPERATION_ID
             , A.ELTR_LN_TP_CD
             , A.ITEM_ID
             , A.NICK_NAME
             , A.MSR_TP_CD
             , CASE WHEN TRIM(A.BASE_QTY_TXT) IS NULL THEN 0.0
                    ELSE TO_BINARY_DOUBLE(A.BASE_QTY_TXT)
               END
             , A.UI_UPD_YN
             , REPLACE(REPLACE(REPLACE(N.TOKEN, 'M_00', ''), 'M_01', ''), 'Y_', '')
             , CASE WHEN TRIM(V.TOKEN) IS NULL THEN 0.0
                    ELSE TO_BINARY_DOUBLE(V.TOKEN)
               END
             , P_USER_ID
             , SYSDATE
             , P_USER_ID
             , SYSDATE
          FROM GT_SCP0105_SAV_IN A
             , GT_SCP0105_SAV_TOKEN N
             , GT_SCP0105_SAV_TOKEN V
         WHERE N.SLOT_NO = C_NAME_BASE  + A.ROW_NR
           AND V.SLOT_NO = C_VALUE_BASE + A.ROW_NR
           AND V.NR      = N.NR
           AND N.TOKEN IS NOT NULL
           AND ( SUBSTR(N.TOKEN, 3, 2) = '01'
              OR SUBSTR(N.TOKEN, 1, 2) = 'Y_' );

        /* 4. 빈라인이 추가되어 삭제 */
        DELETE GT_SCP0105_SAV_ALL
         WHERE TRIM(DIVISION_ID) IS NULL
            OR TRIM(COMPANY_ID) IS NULL
            OR TRIM(SITE_ID) IS NULL
            OR TRIM(PLANT_ID) IS NULL
            OR TRIM(FACTORY_ID) IS NULL
            OR TRIM(LINE_ID) IS NULL
            OR TRIM(OPERATION_ID) IS NULL
            OR TRIM(ELTR_LN_TP_CD) IS NULL
            OR TRIM(ITEM_ID) IS NULL
            OR TRIM(NICK_NAME) IS NULL
            OR TRIM(MSR_TP_CD) IS NULL
            OR TRIM(YYYYMM) IS NULL;

        /* 5. 변경된 데이터만 해당 — 원장에 없거나 값이 달라진 줄만 */
        /*    ★견주는 열쇠에 품목이 없다(약칭까지만) — AS-IS 그대로 */
        INSERT INTO GT_SCP0105_SAV_CHG
             ( VER_ID, VER_SEQ, DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID
             , OPERATION_ID, ELTR_LN_TP_CD, ITEM_ID, NICK_NAME, MSR_TP_CD, BASE_QTY, UI_UPD_YN
             , YYYYMM, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
        SELECT A.VER_ID
             , A.VER_SEQ
             , A.DIVISION_ID
             , A.COMPANY_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.LINE_ID
             , A.OPERATION_ID
             , A.ELTR_LN_TP_CD
             , A.ITEM_ID
             , A.NICK_NAME
             , A.MSR_TP_CD
             , A.BASE_QTY
             , A.UI_UPD_YN
             , A.YYYYMM
             , A.QTY
             , A.CREATED_BY
             , A.CREATION_DATE
             , A.LAST_UPDATED_BY
             , A.LAST_UPDATE_DATE
          FROM GT_SCP0105_SAV_ALL A
             , SCP_MST_CAPA_SPEED_PLAN B
         WHERE B.DIVISION_ID(+)   = A.DIVISION_ID
           AND B.COMPANY_ID(+)    = A.COMPANY_ID
           AND B.SITE_ID(+)       = A.SITE_ID
           AND B.PLANT_ID(+)      = A.PLANT_ID
           AND B.FACTORY_ID(+)    = A.FACTORY_ID
           AND B.LINE_ID(+)       = A.LINE_ID
           AND B.OPERATION_ID(+)  = A.OPERATION_ID
           AND B.ELTR_LN_TP_CD(+) = A.ELTR_LN_TP_CD
           AND B.NICK_NAME(+)     = A.NICK_NAME
           AND B.MSR_TP_CD(+)     = A.MSR_TP_CD
           AND B.YYYYMM(+)        = A.YYYYMM
           AND ( B.DIVISION_ID IS NULL
              OR NVL(A.BASE_QTY, 0) <> NVL(B.BASE_QTY, 0)
              OR NVL(A.QTY, 0) <> NVL(B.QTY, 0) );

        IF P_PROG_STAT = '0' THEN                             /* 0 : Current */

            /* 6. 데이터 저장 - 본테이블. ★AS-IS 는 넣는 갈래가 주석 처리되어 있다 */
            UPDATE SCP_MST_CAPA_SPEED_PLAN A
               SET ( BASE_QTY
                   , UI_UPD_YN
                   , QTY
                   , LAST_UPDATED_BY
                   , LAST_UPDATE_DATE ) =
                   (SELECT B.BASE_QTY
                         , B.UI_UPD_YN
                         , B.QTY
                         , B.LAST_UPDATED_BY
                         , B.LAST_UPDATE_DATE
                      FROM GT_SCP0105_SAV_CHG B
                     WHERE B.DIVISION_ID   = A.DIVISION_ID
                       AND B.COMPANY_ID    = A.COMPANY_ID
                       AND B.SITE_ID       = A.SITE_ID
                       AND B.PLANT_ID      = A.PLANT_ID
                       AND B.FACTORY_ID    = A.FACTORY_ID
                       AND B.LINE_ID       = A.LINE_ID
                       AND B.OPERATION_ID  = A.OPERATION_ID
                       AND B.ELTR_LN_TP_CD = A.ELTR_LN_TP_CD
                       AND B.ITEM_ID       = A.ITEM_ID
                       AND B.NICK_NAME     = A.NICK_NAME
                       AND B.MSR_TP_CD     = A.MSR_TP_CD
                       AND B.YYYYMM        = A.YYYYMM)
             WHERE EXISTS (SELECT 1
                             FROM GT_SCP0105_SAV_CHG B
                            WHERE B.DIVISION_ID   = A.DIVISION_ID
                              AND B.COMPANY_ID    = A.COMPANY_ID
                              AND B.SITE_ID       = A.SITE_ID
                              AND B.PLANT_ID      = A.PLANT_ID
                              AND B.FACTORY_ID    = A.FACTORY_ID
                              AND B.LINE_ID       = A.LINE_ID
                              AND B.OPERATION_ID  = A.OPERATION_ID
                              AND B.ELTR_LN_TP_CD = A.ELTR_LN_TP_CD
                              AND B.ITEM_ID       = A.ITEM_ID
                              AND B.NICK_NAME     = A.NICK_NAME
                              AND B.MSR_TP_CD     = A.MSR_TP_CD
                              AND B.YYYYMM        = A.YYYYMM);

            /* 7. 손실계획 재계산에 넘길 줄 */
            /*    PPM 만 있으면 Loss Plan 계산 가능하므로 설비대수, Speed는 제외!!! */
            DELETE GT_SCP_CAPA_SPEED_PLAN_KEYS;

            INSERT INTO GT_SCP_CAPA_SPEED_PLAN_KEYS
                 ( VER_ID, VER_SEQ, DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, FACTORY_ID
                 , LINE_ID, OPERATION_ID, ELTR_LN_TP_CD, ITEM_ID, NICK_NAME, MSR_TP_CD, YYYYMM
                 , BASE_QTY, QTY, UI_UPD_YN, REMARK
                 , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
            SELECT P_VERSION
                 , TO_NUMBER(P_VERSION_SEQ)
                 , DIVISION_ID
                 , COMPANY_ID
                 , SITE_ID
                 , PLANT_ID
                 , FACTORY_ID
                 , LINE_ID
                 , OPERATION_ID
                 , ELTR_LN_TP_CD
                 , ITEM_ID
                 , NICK_NAME
                 , MSR_TP_CD
                 , YYYYMM
                 , BASE_QTY
                 , QTY
                 , UI_UPD_YN
                 , NULL
                 , CREATED_BY
                 , CREATION_DATE
                 , LAST_UPDATED_BY
                 , LAST_UPDATE_DATE
              FROM GT_SCP0105_SAV_CHG
             WHERE MSR_TP_CD = 'PPM';

            P_SCP0106_CHK_LOSS_SPD_ASM('SCP0106', 'CURRENT', P_USER_ID, 'F');

        END IF;

    END P_SCP0105_SAVE_SPEED_ASM;

    /* AJS 20261008 전극저장 (START) */
    /*******************************************************************************
     * P_SCP0105_SAVE_SPEED_ELTR  (패키지 안에서만 쓰는 갈래)
     *   AS-IS SCP0105_SAVE_CAPA_SPEED_PLAN_ELTR — 전극 저장
     *   2026.10.08   AJS   전극 저장 갈래 전환
     *
     * AS-IS 절차
     *   1. 화면이 줄마다 `^` 로, 줄 안의 날짜 칸을 `;` 로 이어 보낸 값을 세로로 펼친다(조립과 같다).
     *   2. 약칭은 화면 값을 쓰지 않고 '-' 로 담는다(전극조회에 Nickname 추가되서 저장시에는 '-' 로 저장).
     *   3. 열쇠가 빈 줄을 뺀다.
     *   4. 원장과 견줘 원장에 없거나 기준값 · 값 · 전극구분이 바뀐 줄만 남긴다.
     *      견주는 열쇠는 품목 · 측정항목 · 기간까지이고 전극구분 · 약칭은 열쇠에서 뺀다.
     *   5. 동일 라인은 동일한 설비유형을 강제 수정하도록 수정 대상에서 제외된 동일 라인 item 데이터 추가
     *      — 바뀐 줄이 있는 라인의 다른 품목 줄을 원장에서 모두 끌어와 라인의 전극구분(가장 큰 값)으로 맞춘다.
     *   6. 전극구분을 원장 세 곳에 반영한다
     *      라인 모델(품목별) · 라인배정(품목별 → 라인별) · 모델별 손실계획(품목별 → 라인 '-' 줄)
     *   7. 전극 속도계획 원장의 기준값 · 갱신여부 · 값 · 전극구분을 고친다.
     *   8. 설비 속도(EQP_SPED) 줄만 손실계획 재계산에 넘긴다 — 전극은 PPM이 아니라 EQP_SPED 로 저장됨
     *
     * ★AS-IS MERGE 여섯 벌은 모두 맞는 줄 수정만 있다(넣는 갈래 없음). 그중 전극 라인 한 벌은 AS-IS 에
     *   주석 처리되어 있다. 온라인 MERGE 금지 규칙에 따라 나머지 다섯 벌을 수정 문장으로 옮겼다.
     *   없는 열쇠는 넣지 않는다.
     * ★AS-IS MERGE 는 원장 한 줄에 원천 두 줄이 맞으면 오류로 끝난다. 원천 묶음 열쇠(전극구분 포함)를
     *   값 하위질의의 GROUP BY 로 그대로 두어 같은 경우 ORA-01427 로 같이 실패한다.
     * ★조립과 달리 진행상태로 가르지 않는다 — AS-IS 전극 저장에 진행상태 조건이 없다.
     * ★AS-IS 시작 · 끝 로그(PR_SCM_SYS_LOG_BATCH)는 조립 저장 전환과 같이 옮기지 않았다.
     * ★전극구분 바뀜 판정은 AS-IS 대소문자 무시 비교에 맞춰 UPPER 로 견준다.
     * ★AS-IS 는 열세 칸 전달값을 자리 번호로 내부 결합한다 — 한 칸이라도 그 자리 토큰이 없으면 그 줄을 뺀다.
     * ★부르는 쪽이 트랜잭션을 쥐고 있으므로 이 갈래는 커밋하지 않는다.
     *******************************************************************************/
    PROCEDURE P_SCP0105_SAVE_SPEED_ELTR /* AJS 20261008 전극저장 */
    ( /* AJS 20261008 전극저장 */
        P_VERSION               IN  VARCHAR2 /* AJS 20261008 전극저장 */
      , P_VERSION_SEQ           IN  VARCHAR2 /* AJS 20261008 전극저장 */
      , P_PROG_STAT             IN  VARCHAR2 /* AJS 20261008 전극저장 */
      , P_DIVISION_ID           IN  CLOB /* AJS 20261008 전극저장 */
      , P_COMPANY_ID            IN  CLOB /* AJS 20261008 전극저장 */
      , P_SITE_ID               IN  CLOB /* AJS 20261008 전극저장 */
      , P_PLANT_ID              IN  CLOB /* AJS 20261008 전극저장 */
      , P_FACTORY_ID            IN  CLOB /* AJS 20261008 전극저장 */
      , P_LINE_ID               IN  CLOB /* AJS 20261008 전극저장 */
      , P_OPERATION_ID          IN  CLOB /* AJS 20261008 전극저장 */
      , P_ELECTRODE_TYPE        IN  CLOB /* AJS 20261008 전극저장 */
      , P_ITEM_ID               IN  CLOB /* AJS 20261008 전극저장 */
      , P_NICK_NAME             IN  CLOB /* AJS 20261008 전극저장 */
      , P_CAPA_SPEED_MEASURE    IN  CLOB /* AJS 20261008 전극저장 */
      , P_BASE_QTY              IN  CLOB /* AJS 20261008 전극저장 */
      , P_UI_UPD_YN             IN  CLOB /* AJS 20261008 전극저장 */
      , P_DATE_COLUMN_NAMES     IN  CLOB /* AJS 20261008 전극저장 */
      , P_DATE_COLUMN_VALUES    IN  CLOB /* AJS 20261008 전극저장 */
      , P_PROGRAM_ID            IN  VARCHAR2 /* AJS 20261008 전극저장 */
      , P_SHEET_NAME            IN  VARCHAR2 /* AJS 20261008 전극저장 */
      , P_USER_ID               IN  VARCHAR2 /* AJS 20261008 전극저장 */
      , DEBUG_MODE              IN  VARCHAR2 /* AJS 20261008 전극저장 */
      , O_RESULT_CNT            OUT NUMBER /* AJS 20261008 전극저장 */
    ) /* AJS 20261008 전극저장 */
    IS /* AJS 20261008 전극저장 */
        C_DELIMITER     CONSTANT VARCHAR2(1 CHAR) := '^'; /* AJS 20261008 전극저장 */
        C_NAME_SLOT     CONSTANT NUMBER           := 14; /* AJS 20261008 전극저장 */
        C_VALUE_SLOT    CONSTANT NUMBER           := 15; /* AJS 20261008 전극저장 */
        C_NAME_BASE     CONSTANT NUMBER           := 100000; /* AJS 20261008 전극저장 */
        C_VALUE_BASE    CONSTANT NUMBER           := 200000; /* AJS 20261008 전극저장 */
    BEGIN /* AJS 20261008 전극저장 */

        O_RESULT_CNT := SCM_ARR_SPL_CNT(TO_CHAR(SUBSTR(P_DIVISION_ID, 1, 32767)), C_DELIMITER); /* AJS 20261008 전극저장 */

        DELETE /* AJS 20261008 전극저장 */
          FROM GT_SCP0105_SAV_TOKEN; /* AJS 20261008 전극저장 */
        DELETE /* AJS 20261008 전극저장 */
          FROM GT_SCP0105_SAV_IN; /* AJS 20261008 전극저장 */
        DELETE /* AJS 20261008 전극저장 */
          FROM GT_SCP0105_SAV_ALL; /* AJS 20261008 전극저장 */
        DELETE /* AJS 20261008 전극저장 */
          FROM GT_SCP0105_SAV_CHG; /* AJS 20261008 전극저장 */

        /* 1. 전달값을 줄 단위로 푼다 */ /* AJS 20261008 전극저장 */
        P_SCP0105_SPLIT_CLOB( 1, P_DIVISION_ID,         C_DELIMITER); /* AJS 20261008 전극저장 */
        P_SCP0105_SPLIT_CLOB( 2, P_COMPANY_ID,          C_DELIMITER); /* AJS 20261008 전극저장 */
        P_SCP0105_SPLIT_CLOB( 3, P_SITE_ID,             C_DELIMITER); /* AJS 20261008 전극저장 */
        P_SCP0105_SPLIT_CLOB( 4, P_PLANT_ID,            C_DELIMITER); /* AJS 20261008 전극저장 */
        P_SCP0105_SPLIT_CLOB( 5, P_FACTORY_ID,          C_DELIMITER); /* AJS 20261008 전극저장 */
        P_SCP0105_SPLIT_CLOB( 6, P_LINE_ID,             C_DELIMITER); /* AJS 20261008 전극저장 */
        P_SCP0105_SPLIT_CLOB( 7, P_OPERATION_ID,        C_DELIMITER); /* AJS 20261008 전극저장 */
        P_SCP0105_SPLIT_CLOB( 8, P_ELECTRODE_TYPE,      C_DELIMITER); /* AJS 20261008 전극저장 */
        P_SCP0105_SPLIT_CLOB( 9, P_ITEM_ID,             C_DELIMITER); /* AJS 20261008 전극저장 */
        P_SCP0105_SPLIT_CLOB(10, P_NICK_NAME,           C_DELIMITER); /* AJS 20261008 전극저장 */
        P_SCP0105_SPLIT_CLOB(11, P_CAPA_SPEED_MEASURE,  C_DELIMITER); /* AJS 20261008 전극저장 */
        P_SCP0105_SPLIT_CLOB(12, P_BASE_QTY,            C_DELIMITER); /* AJS 20261008 전극저장 */
        P_SCP0105_SPLIT_CLOB(13, P_UI_UPD_YN,           C_DELIMITER); /* AJS 20261008 전극저장 */
        P_SCP0105_SPLIT_CLOB(C_NAME_SLOT,  P_DATE_COLUMN_NAMES,  C_DELIMITER); /* AJS 20261008 전극저장 */
        P_SCP0105_SPLIT_CLOB(C_VALUE_SLOT, P_DATE_COLUMN_VALUES, C_DELIMITER); /* AJS 20261008 전극저장 */

        /*    열세 칸이 모두 같은 자리 토큰을 가진 줄만(AS-IS 자리 번호 내부 결합) */ /* AJS 20261008 전극저장 */
        INSERT /* AJS 20261008 전극저장 */
          INTO GT_SCP0105_SAV_IN /* AJS 20261008 전극저장 */
             ( ROW_NR /* AJS 20261008 전극저장 */
             , DIVISION_ID /* AJS 20261008 전극저장 */
             , COMPANY_ID /* AJS 20261008 전극저장 */
             , SITE_ID /* AJS 20261008 전극저장 */
             , PLANT_ID /* AJS 20261008 전극저장 */
             , FACTORY_ID /* AJS 20261008 전극저장 */
             , LINE_ID /* AJS 20261008 전극저장 */
             , OPERATION_ID /* AJS 20261008 전극저장 */
             , ELTR_LN_TP_CD /* AJS 20261008 전극저장 */
             , ITEM_ID /* AJS 20261008 전극저장 */
             , NICK_NAME /* AJS 20261008 전극저장 */
             , MSR_TP_CD /* AJS 20261008 전극저장 */
             , BASE_QTY_TXT /* AJS 20261008 전극저장 */
             , UI_UPD_YN ) /* AJS 20261008 전극저장 */
        SELECT NR /* AJS 20261008 전극저장 */
             , MAX(CASE WHEN SLOT_NO =  1 THEN TOKEN END) AS DIVISION_ID /* AJS 20261008 전극저장 */
             , MAX(CASE WHEN SLOT_NO =  2 THEN TOKEN END) AS COMPANY_ID /* AJS 20261008 전극저장 */
             , MAX(CASE WHEN SLOT_NO =  3 THEN TOKEN END) AS SITE_ID /* AJS 20261008 전극저장 */
             , MAX(CASE WHEN SLOT_NO =  4 THEN TOKEN END) AS PLANT_ID /* AJS 20261008 전극저장 */
             , MAX(CASE WHEN SLOT_NO =  5 THEN TOKEN END) AS FACTORY_ID /* AJS 20261008 전극저장 */
             , MAX(CASE WHEN SLOT_NO =  6 THEN TOKEN END) AS LINE_ID /* AJS 20261008 전극저장 */
             , MAX(CASE WHEN SLOT_NO =  7 THEN TOKEN END) AS OPERATION_ID /* AJS 20261008 전극저장 */
             , MAX(CASE WHEN SLOT_NO =  8 THEN TOKEN END) AS ELTR_LN_TP_CD /* AJS 20261008 전극저장 */
             , MAX(CASE WHEN SLOT_NO =  9 THEN TOKEN END) AS ITEM_ID /* AJS 20261008 전극저장 */
             , '-'                                        AS NICK_NAME /* 전극조회에 Nickname 추가되서 저장시에는 '-' 로 저장 */ /* AJS 20261008 전극저장 */
             , MAX(CASE WHEN SLOT_NO = 11 THEN TOKEN END) AS MSR_TP_CD /* AJS 20261008 전극저장 */
             , MAX(CASE WHEN SLOT_NO = 12 THEN TOKEN END) AS BASE_QTY_TXT /* AJS 20261008 전극저장 */
             , MAX(CASE WHEN SLOT_NO = 13 THEN TOKEN END) AS UI_UPD_YN /* AJS 20261008 전극저장 */
          FROM GT_SCP0105_SAV_TOKEN /* AJS 20261008 전극저장 */
         WHERE SLOT_NO BETWEEN 1 AND 13 /* AJS 20261008 전극저장 */
         GROUP BY NR /* AJS 20261008 전극저장 */
        HAVING COUNT(DISTINCT SLOT_NO) = 13; /* AJS 20261008 전극저장 */

        /* 2. 줄마다 날짜 칸 이름과 값을 다시 푼다 */ /* AJS 20261008 전극저장 */
        FOR R IN (SELECT NR /* AJS 20261008 전극저장 */
                       , MAX(CASE WHEN SLOT_NO = C_NAME_SLOT  THEN TOKEN END) AS COL_NAMES /* AJS 20261008 전극저장 */
                       , MAX(CASE WHEN SLOT_NO = C_VALUE_SLOT THEN TOKEN END) AS COL_VALUES /* AJS 20261008 전극저장 */
                    FROM GT_SCP0105_SAV_TOKEN /* AJS 20261008 전극저장 */
                   WHERE SLOT_NO IN (C_NAME_SLOT, C_VALUE_SLOT) /* AJS 20261008 전극저장 */
                   GROUP BY NR /* AJS 20261008 전극저장 */
                  HAVING MAX(CASE WHEN SLOT_NO = C_NAME_SLOT THEN TOKEN END) IS NOT NULL) /* AJS 20261008 전극저장 */
        LOOP /* AJS 20261008 전극저장 */
            P_SCP0105_SPLIT_CLOB(C_NAME_BASE  + R.NR, TO_CLOB(R.COL_NAMES),  ';'); /* AJS 20261008 전극저장 */
            P_SCP0105_SPLIT_CLOB(C_VALUE_BASE + R.NR, TO_CLOB(R.COL_VALUES), ';'); /* AJS 20261008 전극저장 */
        END LOOP; /* AJS 20261008 전극저장 */

        /* 3. 날짜 칸을 세로로 펼친다. 달 칸은 이름 3~4자리가 '01' 인 것, 해 칸은 'Y_' 로 시작 */ /* AJS 20261008 전극저장 */
        INSERT /* AJS 20261008 전극저장 */
          INTO GT_SCP0105_SAV_ALL /* AJS 20261008 전극저장 */
             ( VER_ID /* AJS 20261008 전극저장 */
             , VER_SEQ /* AJS 20261008 전극저장 */
             , DIVISION_ID /* AJS 20261008 전극저장 */
             , COMPANY_ID /* AJS 20261008 전극저장 */
             , SITE_ID /* AJS 20261008 전극저장 */
             , PLANT_ID /* AJS 20261008 전극저장 */
             , FACTORY_ID /* AJS 20261008 전극저장 */
             , LINE_ID /* AJS 20261008 전극저장 */
             , OPERATION_ID /* AJS 20261008 전극저장 */
             , ELTR_LN_TP_CD /* AJS 20261008 전극저장 */
             , ITEM_ID /* AJS 20261008 전극저장 */
             , NICK_NAME /* AJS 20261008 전극저장 */
             , MSR_TP_CD /* AJS 20261008 전극저장 */
             , BASE_QTY /* AJS 20261008 전극저장 */
             , UI_UPD_YN /* AJS 20261008 전극저장 */
             , YYYYMM /* AJS 20261008 전극저장 */
             , QTY /* AJS 20261008 전극저장 */
             , CREATED_BY /* AJS 20261008 전극저장 */
             , CREATION_DATE /* AJS 20261008 전극저장 */
             , LAST_UPDATED_BY /* AJS 20261008 전극저장 */
             , LAST_UPDATE_DATE ) /* AJS 20261008 전극저장 */
        SELECT P_VERSION                  AS VER_ID /* AJS 20261008 전극저장 */
             , TO_NUMBER(P_VERSION_SEQ)   AS VER_SEQ /* AJS 20261008 전극저장 */
             , A.DIVISION_ID /* AJS 20261008 전극저장 */
             , A.COMPANY_ID /* AJS 20261008 전극저장 */
             , A.SITE_ID /* AJS 20261008 전극저장 */
             , A.PLANT_ID /* AJS 20261008 전극저장 */
             , A.FACTORY_ID /* AJS 20261008 전극저장 */
             , A.LINE_ID /* AJS 20261008 전극저장 */
             , A.OPERATION_ID /* AJS 20261008 전극저장 */
             , A.ELTR_LN_TP_CD /* AJS 20261008 전극저장 */
             , A.ITEM_ID /* AJS 20261008 전극저장 */
             , A.NICK_NAME /* AJS 20261008 전극저장 */
             , A.MSR_TP_CD /* AJS 20261008 전극저장 */
             , CASE WHEN TRIM(A.BASE_QTY_TXT) IS NULL THEN 0.0 /* AJS 20261008 전극저장 */
                    ELSE TO_BINARY_DOUBLE(A.BASE_QTY_TXT) /* AJS 20261008 전극저장 */
               END                        AS BASE_QTY /* AJS 20261008 전극저장 */
             , A.UI_UPD_YN /* AJS 20261008 전극저장 */
             , REPLACE(REPLACE(REPLACE(B.TOKEN, 'M_00', ''), 'M_01', ''), 'Y_', '') AS YYYYMM /* AJS 20261008 전극저장 */
             , CASE WHEN TRIM(C.TOKEN) IS NULL THEN 0.0 /* AJS 20261008 전극저장 */
                    ELSE TO_BINARY_DOUBLE(C.TOKEN) /* AJS 20261008 전극저장 */
               END                        AS QTY /* AJS 20261008 전극저장 */
             , P_USER_ID                  AS CREATED_BY /* AJS 20261008 전극저장 */
             , SYSDATE                    AS CREATION_DATE /* AJS 20261008 전극저장 */
             , P_USER_ID                  AS LAST_UPDATED_BY /* AJS 20261008 전극저장 */
             , SYSDATE                    AS LAST_UPDATE_DATE /* AJS 20261008 전극저장 */
          FROM GT_SCP0105_SAV_IN    A /* AJS 20261008 전극저장 */
             , GT_SCP0105_SAV_TOKEN B /* AJS 20261008 전극저장 */
             , GT_SCP0105_SAV_TOKEN C /* AJS 20261008 전극저장 */
         WHERE B.SLOT_NO = C_NAME_BASE + A.ROW_NR /* AJS 20261008 전극저장 */
           AND C.SLOT_NO = C_VALUE_BASE + A.ROW_NR /* AJS 20261008 전극저장 */
           AND C.NR      = B.NR /* AJS 20261008 전극저장 */
           AND B.TOKEN IS NOT NULL /* AJS 20261008 전극저장 */
           AND (SUBSTR(B.TOKEN, 3, 2) = '01' /* AJS 20261008 전극저장 */
             OR SUBSTR(B.TOKEN, 1, 2) = 'Y_'); /* AJS 20261008 전극저장 */

        /* 4. 빈라인이 추가되어 삭제 */ /* AJS 20261008 전극저장 */
        DELETE /* AJS 20261008 전극저장 */
          FROM GT_SCP0105_SAV_ALL /* AJS 20261008 전극저장 */
         WHERE TRIM(DIVISION_ID) IS NULL /* AJS 20261008 전극저장 */
            OR TRIM(COMPANY_ID) IS NULL /* AJS 20261008 전극저장 */
            OR TRIM(SITE_ID) IS NULL /* AJS 20261008 전극저장 */
            OR TRIM(PLANT_ID) IS NULL /* AJS 20261008 전극저장 */
            OR TRIM(FACTORY_ID) IS NULL /* AJS 20261008 전극저장 */
            OR TRIM(LINE_ID) IS NULL /* AJS 20261008 전극저장 */
            OR TRIM(OPERATION_ID) IS NULL /* AJS 20261008 전극저장 */
            OR TRIM(ELTR_LN_TP_CD) IS NULL /* AJS 20261008 전극저장 */
            OR TRIM(ITEM_ID) IS NULL /* AJS 20261008 전극저장 */
            OR TRIM(NICK_NAME) IS NULL /* AJS 20261008 전극저장 */
            OR TRIM(MSR_TP_CD) IS NULL /* AJS 20261008 전극저장 */
            OR TRIM(YYYYMM) IS NULL; /* AJS 20261008 전극저장 */

        /* 5. 변경된 데이터만 해당 — 원장에 없거나 기준값 · 값 · 전극구분이 달라진 줄만 */ /* AJS 20261008 전극저장 */
        /*    견주는 열쇠에 전극구분 · 약칭이 없다(품목 · 측정항목 · 기간까지) — AS-IS 그대로 */ /* AJS 20261008 전극저장 */
        INSERT /* AJS 20261008 전극저장 */
          INTO GT_SCP0105_SAV_CHG /* AJS 20261008 전극저장 */
             ( VER_ID /* AJS 20261008 전극저장 */
             , VER_SEQ /* AJS 20261008 전극저장 */
             , DIVISION_ID /* AJS 20261008 전극저장 */
             , COMPANY_ID /* AJS 20261008 전극저장 */
             , SITE_ID /* AJS 20261008 전극저장 */
             , PLANT_ID /* AJS 20261008 전극저장 */
             , FACTORY_ID /* AJS 20261008 전극저장 */
             , LINE_ID /* AJS 20261008 전극저장 */
             , OPERATION_ID /* AJS 20261008 전극저장 */
             , ELTR_LN_TP_CD /* AJS 20261008 전극저장 */
             , ITEM_ID /* AJS 20261008 전극저장 */
             , NICK_NAME /* AJS 20261008 전극저장 */
             , MSR_TP_CD /* AJS 20261008 전극저장 */
             , BASE_QTY /* AJS 20261008 전극저장 */
             , UI_UPD_YN /* AJS 20261008 전극저장 */
             , YYYYMM /* AJS 20261008 전극저장 */
             , QTY /* AJS 20261008 전극저장 */
             , CREATED_BY /* AJS 20261008 전극저장 */
             , CREATION_DATE /* AJS 20261008 전극저장 */
             , LAST_UPDATED_BY /* AJS 20261008 전극저장 */
             , LAST_UPDATE_DATE ) /* AJS 20261008 전극저장 */
        SELECT A.VER_ID /* AJS 20261008 전극저장 */
             , A.VER_SEQ /* AJS 20261008 전극저장 */
             , A.DIVISION_ID /* AJS 20261008 전극저장 */
             , A.COMPANY_ID /* AJS 20261008 전극저장 */
             , A.SITE_ID /* AJS 20261008 전극저장 */
             , A.PLANT_ID /* AJS 20261008 전극저장 */
             , A.FACTORY_ID /* AJS 20261008 전극저장 */
             , A.LINE_ID /* AJS 20261008 전극저장 */
             , A.OPERATION_ID /* AJS 20261008 전극저장 */
             , A.ELTR_LN_TP_CD /* AJS 20261008 전극저장 */
             , A.ITEM_ID /* AJS 20261008 전극저장 */
             , A.NICK_NAME /* AJS 20261008 전극저장 */
             , A.MSR_TP_CD /* AJS 20261008 전극저장 */
             , A.BASE_QTY /* AJS 20261008 전극저장 */
             , A.UI_UPD_YN /* AJS 20261008 전극저장 */
             , A.YYYYMM /* AJS 20261008 전극저장 */
             , A.QTY /* AJS 20261008 전극저장 */
             , A.CREATED_BY /* AJS 20261008 전극저장 */
             , A.CREATION_DATE /* AJS 20261008 전극저장 */
             , A.LAST_UPDATED_BY /* AJS 20261008 전극저장 */
             , A.LAST_UPDATE_DATE /* AJS 20261008 전극저장 */
          FROM GT_SCP0105_SAV_ALL           A /* AJS 20261008 전극저장 */
             , SCP_MST_CAPA_ELTR_SPEED_PLAN B /* AJS 20261008 전극저장 */
         WHERE B.DIVISION_ID(+)  = A.DIVISION_ID /* AJS 20261008 전극저장 */
           AND B.COMPANY_ID(+)   = A.COMPANY_ID /* AJS 20261008 전극저장 */
           AND B.SITE_ID(+)      = A.SITE_ID /* AJS 20261008 전극저장 */
           AND B.PLANT_ID(+)     = A.PLANT_ID /* AJS 20261008 전극저장 */
           AND B.FACTORY_ID(+)   = A.FACTORY_ID /* AJS 20261008 전극저장 */
           AND B.LINE_ID(+)      = A.LINE_ID /* AJS 20261008 전극저장 */
           AND B.OPERATION_ID(+) = A.OPERATION_ID /* AJS 20261008 전극저장 */
           AND B.ITEM_ID(+)      = A.ITEM_ID /* AJS 20261008 전극저장 */
           AND B.MSR_TP_CD(+)    = A.MSR_TP_CD /* AJS 20261008 전극저장 */
           AND B.YYYYMM(+)       = A.YYYYMM /* AJS 20261008 전극저장 */
           AND (B.DIVISION_ID IS NULL /* AJS 20261008 전극저장 */
             OR NVL(A.BASE_QTY, 0) <> NVL(B.BASE_QTY, 0) /* AJS 20261008 전극저장 */
             OR NVL(A.QTY, 0) <> NVL(B.QTY, 0) /* AJS 20261008 전극저장 */
             OR UPPER(A.ELTR_LN_TP_CD) <> UPPER(B.ELTR_LN_TP_CD)); /* AJS 20261008 전극저장 */

        /* 6. 동일 라인은 동일한 설비유형을 강제 수정하도록 수정 대상에서 제외된 동일 라인 item 데이터 추가 */ /* AJS 20261008 전극저장 */
        /*    바뀐 줄이 있는 라인의 원장 줄 중 바뀐 줄에 없는 품목을 라인의 가장 큰 전극구분으로 담는다 */ /* AJS 20261008 전극저장 */
        INSERT /* AJS 20261008 전극저장 */
          INTO GT_SCP0105_SAV_CHG /* AJS 20261008 전극저장 */
             ( VER_ID /* AJS 20261008 전극저장 */
             , VER_SEQ /* AJS 20261008 전극저장 */
             , DIVISION_ID /* AJS 20261008 전극저장 */
             , COMPANY_ID /* AJS 20261008 전극저장 */
             , SITE_ID /* AJS 20261008 전극저장 */
             , PLANT_ID /* AJS 20261008 전극저장 */
             , FACTORY_ID /* AJS 20261008 전극저장 */
             , LINE_ID /* AJS 20261008 전극저장 */
             , OPERATION_ID /* AJS 20261008 전극저장 */
             , ELTR_LN_TP_CD /* AJS 20261008 전극저장 */
             , ITEM_ID /* AJS 20261008 전극저장 */
             , NICK_NAME /* AJS 20261008 전극저장 */
             , MSR_TP_CD /* AJS 20261008 전극저장 */
             , BASE_QTY /* AJS 20261008 전극저장 */
             , UI_UPD_YN /* AJS 20261008 전극저장 */
             , YYYYMM /* AJS 20261008 전극저장 */
             , QTY /* AJS 20261008 전극저장 */
             , CREATED_BY /* AJS 20261008 전극저장 */
             , CREATION_DATE /* AJS 20261008 전극저장 */
             , LAST_UPDATED_BY /* AJS 20261008 전극저장 */
             , LAST_UPDATE_DATE ) /* AJS 20261008 전극저장 */
        SELECT P_VERSION                  AS VER_ID /* AJS 20261008 전극저장 */
             , TO_NUMBER(P_VERSION_SEQ)   AS VER_SEQ /* AJS 20261008 전극저장 */
             , A.DIVISION_ID /* AJS 20261008 전극저장 */
             , A.COMPANY_ID /* AJS 20261008 전극저장 */
             , A.SITE_ID /* AJS 20261008 전극저장 */
             , A.PLANT_ID /* AJS 20261008 전극저장 */
             , A.FACTORY_ID /* AJS 20261008 전극저장 */
             , A.LINE_ID /* AJS 20261008 전극저장 */
             , A.OPERATION_ID /* AJS 20261008 전극저장 */
             , IA.ELTR_LN_TP_CD /* AJS 20261008 전극저장 */
             , A.ITEM_ID /* AJS 20261008 전극저장 */
             , A.NICK_NAME /* AJS 20261008 전극저장 */
             , A.MSR_TP_CD /* AJS 20261008 전극저장 */
             , A.BASE_QTY /* AJS 20261008 전극저장 */
             , A.UI_UPD_YN /* AJS 20261008 전극저장 */
             , A.YYYYMM /* AJS 20261008 전극저장 */
             , A.QTY /* AJS 20261008 전극저장 */
             , P_USER_ID                  AS CREATED_BY /* AJS 20261008 전극저장 */
             , SYSDATE                    AS CREATION_DATE /* AJS 20261008 전극저장 */
             , P_USER_ID                  AS LAST_UPDATED_BY /* AJS 20261008 전극저장 */
             , SYSDATE                    AS LAST_UPDATE_DATE /* AJS 20261008 전극저장 */
          FROM (SELECT DIVISION_ID /* AJS 20261008 전극저장 */
                     , COMPANY_ID /* AJS 20261008 전극저장 */
                     , SITE_ID /* AJS 20261008 전극저장 */
                     , PLANT_ID /* AJS 20261008 전극저장 */
                     , FACTORY_ID /* AJS 20261008 전극저장 */
                     , LINE_ID /* AJS 20261008 전극저장 */
                     , MAX(ELTR_LN_TP_CD) AS ELTR_LN_TP_CD /* AJS 20261008 전극저장 */
                  FROM GT_SCP0105_SAV_CHG /* AJS 20261008 전극저장 */
                 GROUP BY DIVISION_ID /* AJS 20261008 전극저장 */
                     , COMPANY_ID /* AJS 20261008 전극저장 */
                     , SITE_ID /* AJS 20261008 전극저장 */
                     , PLANT_ID /* AJS 20261008 전극저장 */
                     , FACTORY_ID /* AJS 20261008 전극저장 */
                     , LINE_ID) IA /* AJS 20261008 전극저장 */
             , SCP_MST_CAPA_ELTR_SPEED_PLAN A /* AJS 20261008 전극저장 */
         WHERE A.DIVISION_ID = IA.DIVISION_ID /* AJS 20261008 전극저장 */
           AND A.COMPANY_ID  = IA.COMPANY_ID /* AJS 20261008 전극저장 */
           AND A.SITE_ID     = IA.SITE_ID /* AJS 20261008 전극저장 */
           AND A.PLANT_ID    = IA.PLANT_ID /* AJS 20261008 전극저장 */
           AND A.FACTORY_ID  = IA.FACTORY_ID /* AJS 20261008 전극저장 */
           AND A.LINE_ID     = IA.LINE_ID /* AJS 20261008 전극저장 */
           AND NOT EXISTS (SELECT 1 /* AJS 20261008 전극저장 */
                             FROM GT_SCP0105_SAV_CHG XA /* AJS 20261008 전극저장 */
                            WHERE XA.DIVISION_ID = A.DIVISION_ID /* AJS 20261008 전극저장 */
                              AND XA.COMPANY_ID  = A.COMPANY_ID /* AJS 20261008 전극저장 */
                              AND XA.SITE_ID     = A.SITE_ID /* AJS 20261008 전극저장 */
                              AND XA.PLANT_ID    = A.PLANT_ID /* AJS 20261008 전극저장 */
                              AND XA.FACTORY_ID  = A.FACTORY_ID /* AJS 20261008 전극저장 */
                              AND XA.LINE_ID     = A.LINE_ID /* AJS 20261008 전극저장 */
                              AND XA.ITEM_ID     = A.ITEM_ID); /* AJS 20261008 전극저장 */

        /* 7. 키값 변경시 저장 - Line Model (AS-IS MERGE 맞는 줄 수정) */ /* AJS 20261008 전극저장 */
        UPDATE SCP_MST_CAPA_ELTR_LINE_MDL A /* AJS 20261008 전극저장 */
           SET (A.ELTR_LN_TP_CD /* AJS 20261008 전극저장 */
              , A.LAST_UPDATED_BY /* AJS 20261008 전극저장 */
              , A.LAST_UPDATE_DATE) = (SELECT SA.ELTR_LN_TP_CD /* AJS 20261008 전극저장 */
                                            , MAX(SA.LAST_UPDATED_BY)  AS LAST_UPDATED_BY /* AJS 20261008 전극저장 */
                                            , MAX(SA.LAST_UPDATE_DATE) AS LAST_UPDATE_DATE /* AJS 20261008 전극저장 */
                                         FROM GT_SCP0105_SAV_CHG SA /* AJS 20261008 전극저장 */
                                        WHERE SA.DIVISION_ID  = A.DIVISION_ID /* AJS 20261008 전극저장 */
                                          AND SA.COMPANY_ID   = A.COMPANY_ID /* AJS 20261008 전극저장 */
                                          AND SA.SITE_ID      = A.SITE_ID /* AJS 20261008 전극저장 */
                                          AND SA.PLANT_ID     = A.PLANT_ID /* AJS 20261008 전극저장 */
                                          AND SA.FACTORY_ID   = A.FACTORY_ID /* AJS 20261008 전극저장 */
                                          AND SA.LINE_ID      = A.LINE_ID /* AJS 20261008 전극저장 */
                                          AND SA.OPERATION_ID = A.OPERATION_ID /* AJS 20261008 전극저장 */
                                          AND SA.ITEM_ID      = A.ITEM_ID /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.DIVISION_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.COMPANY_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.SITE_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.PLANT_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.FACTORY_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.LINE_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.OPERATION_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.ELTR_LN_TP_CD) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.ITEM_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                        GROUP BY SA.ELTR_LN_TP_CD) /* AJS 20261008 전극저장 */
         WHERE EXISTS (SELECT 1 /* AJS 20261008 전극저장 */
                         FROM GT_SCP0105_SAV_CHG XA /* AJS 20261008 전극저장 */
                        WHERE XA.DIVISION_ID  = A.DIVISION_ID /* AJS 20261008 전극저장 */
                          AND XA.COMPANY_ID   = A.COMPANY_ID /* AJS 20261008 전극저장 */
                          AND XA.SITE_ID      = A.SITE_ID /* AJS 20261008 전극저장 */
                          AND XA.PLANT_ID     = A.PLANT_ID /* AJS 20261008 전극저장 */
                          AND XA.FACTORY_ID   = A.FACTORY_ID /* AJS 20261008 전극저장 */
                          AND XA.LINE_ID      = A.LINE_ID /* AJS 20261008 전극저장 */
                          AND XA.OPERATION_ID = A.OPERATION_ID /* AJS 20261008 전극저장 */
                          AND XA.ITEM_ID      = A.ITEM_ID /* AJS 20261008 전극저장 */
                          AND TRIM(XA.DIVISION_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.COMPANY_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.SITE_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.PLANT_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.FACTORY_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.LINE_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.OPERATION_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.ELTR_LN_TP_CD) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.ITEM_ID) IS NOT NULL); /* AJS 20261008 전극저장 */

        /* 8. 키값 변경시 저장 - Line Assign (품목별) */ /* AJS 20261008 전극저장 */
        UPDATE SCP_MST_CAPA_ELTR_LINE_ASSIGN A /* AJS 20261008 전극저장 */
           SET (A.ELTR_LN_TP_CD /* AJS 20261008 전극저장 */
              , A.LAST_UPDATED_BY /* AJS 20261008 전극저장 */
              , A.LAST_UPDATE_DATE) = (SELECT SA.ELTR_LN_TP_CD /* AJS 20261008 전극저장 */
                                            , MAX(SA.LAST_UPDATED_BY)  AS LAST_UPDATED_BY /* AJS 20261008 전극저장 */
                                            , MAX(SA.LAST_UPDATE_DATE) AS LAST_UPDATE_DATE /* AJS 20261008 전극저장 */
                                         FROM GT_SCP0105_SAV_CHG SA /* AJS 20261008 전극저장 */
                                        WHERE SA.DIVISION_ID  = A.DIVISION_ID /* AJS 20261008 전극저장 */
                                          AND SA.COMPANY_ID   = A.COMPANY_ID /* AJS 20261008 전극저장 */
                                          AND SA.SITE_ID      = A.SITE_ID /* AJS 20261008 전극저장 */
                                          AND SA.PLANT_ID     = A.PLANT_ID /* AJS 20261008 전극저장 */
                                          AND SA.FACTORY_ID   = A.FACTORY_ID /* AJS 20261008 전극저장 */
                                          AND SA.LINE_ID      = A.LINE_ID /* AJS 20261008 전극저장 */
                                          AND SA.OPERATION_ID = A.OPERATION_ID /* AJS 20261008 전극저장 */
                                          AND SA.ITEM_ID      = A.ITEM_ID /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.DIVISION_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.COMPANY_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.SITE_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.PLANT_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.FACTORY_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.LINE_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.OPERATION_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.ELTR_LN_TP_CD) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.ITEM_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                        GROUP BY SA.ELTR_LN_TP_CD) /* AJS 20261008 전극저장 */
         WHERE EXISTS (SELECT 1 /* AJS 20261008 전극저장 */
                         FROM GT_SCP0105_SAV_CHG XA /* AJS 20261008 전극저장 */
                        WHERE XA.DIVISION_ID  = A.DIVISION_ID /* AJS 20261008 전극저장 */
                          AND XA.COMPANY_ID   = A.COMPANY_ID /* AJS 20261008 전극저장 */
                          AND XA.SITE_ID      = A.SITE_ID /* AJS 20261008 전극저장 */
                          AND XA.PLANT_ID     = A.PLANT_ID /* AJS 20261008 전극저장 */
                          AND XA.FACTORY_ID   = A.FACTORY_ID /* AJS 20261008 전극저장 */
                          AND XA.LINE_ID      = A.LINE_ID /* AJS 20261008 전극저장 */
                          AND XA.OPERATION_ID = A.OPERATION_ID /* AJS 20261008 전극저장 */
                          AND XA.ITEM_ID      = A.ITEM_ID /* AJS 20261008 전극저장 */
                          AND TRIM(XA.DIVISION_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.COMPANY_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.SITE_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.PLANT_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.FACTORY_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.LINE_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.OPERATION_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.ELTR_LN_TP_CD) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.ITEM_ID) IS NOT NULL); /* AJS 20261008 전극저장 */

        /* 9. Line Assign 라인별 동일한 설비유형 적용 — 라인 묶음 한 줄이라 하위질의는 늘 한 줄 */ /* AJS 20261008 전극저장 */
        UPDATE SCP_MST_CAPA_ELTR_LINE_ASSIGN A /* AJS 20261008 전극저장 */
           SET (A.ELTR_LN_TP_CD /* AJS 20261008 전극저장 */
              , A.LAST_UPDATED_BY /* AJS 20261008 전극저장 */
              , A.LAST_UPDATE_DATE) = (SELECT MAX(SA.ELTR_LN_TP_CD)    AS ELTR_LN_TP_CD /* AJS 20261008 전극저장 */
                                            , MAX(SA.LAST_UPDATED_BY)  AS LAST_UPDATED_BY /* AJS 20261008 전극저장 */
                                            , MAX(SA.LAST_UPDATE_DATE) AS LAST_UPDATE_DATE /* AJS 20261008 전극저장 */
                                         FROM GT_SCP0105_SAV_CHG SA /* AJS 20261008 전극저장 */
                                        WHERE SA.DIVISION_ID  = A.DIVISION_ID /* AJS 20261008 전극저장 */
                                          AND SA.COMPANY_ID   = A.COMPANY_ID /* AJS 20261008 전극저장 */
                                          AND SA.SITE_ID      = A.SITE_ID /* AJS 20261008 전극저장 */
                                          AND SA.PLANT_ID     = A.PLANT_ID /* AJS 20261008 전극저장 */
                                          AND SA.FACTORY_ID   = A.FACTORY_ID /* AJS 20261008 전극저장 */
                                          AND SA.LINE_ID      = A.LINE_ID /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.DIVISION_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.COMPANY_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.SITE_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.PLANT_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.FACTORY_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.LINE_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.OPERATION_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.ELTR_LN_TP_CD) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.ITEM_ID) IS NOT NULL) /* AJS 20261008 전극저장 */
         WHERE EXISTS (SELECT 1 /* AJS 20261008 전극저장 */
                         FROM GT_SCP0105_SAV_CHG XA /* AJS 20261008 전극저장 */
                        WHERE XA.DIVISION_ID  = A.DIVISION_ID /* AJS 20261008 전극저장 */
                          AND XA.COMPANY_ID   = A.COMPANY_ID /* AJS 20261008 전극저장 */
                          AND XA.SITE_ID      = A.SITE_ID /* AJS 20261008 전극저장 */
                          AND XA.PLANT_ID     = A.PLANT_ID /* AJS 20261008 전극저장 */
                          AND XA.FACTORY_ID   = A.FACTORY_ID /* AJS 20261008 전극저장 */
                          AND XA.LINE_ID      = A.LINE_ID /* AJS 20261008 전극저장 */
                          AND TRIM(XA.DIVISION_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.COMPANY_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.SITE_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.PLANT_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.FACTORY_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.LINE_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.OPERATION_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.ELTR_LN_TP_CD) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.ITEM_ID) IS NOT NULL); /* AJS 20261008 전극저장 */

        /* 10. 키값 변경시 저장 - Loss Plan - Model (모델명 = 품목) */ /* AJS 20261008 전극저장 */
        UPDATE SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL A /* AJS 20261008 전극저장 */
           SET (A.ELTR_LN_TP_CD /* AJS 20261008 전극저장 */
              , A.LAST_UPDATED_BY /* AJS 20261008 전극저장 */
              , A.LAST_UPDATE_DATE) = (SELECT SA.ELTR_LN_TP_CD /* AJS 20261008 전극저장 */
                                            , MAX(SA.LAST_UPDATED_BY)  AS LAST_UPDATED_BY /* AJS 20261008 전극저장 */
                                            , MAX(SA.LAST_UPDATE_DATE) AS LAST_UPDATE_DATE /* AJS 20261008 전극저장 */
                                         FROM GT_SCP0105_SAV_CHG SA /* AJS 20261008 전극저장 */
                                        WHERE SA.DIVISION_ID  = A.DIVISION_ID /* AJS 20261008 전극저장 */
                                          AND SA.COMPANY_ID   = A.COMPANY_ID /* AJS 20261008 전극저장 */
                                          AND SA.SITE_ID      = A.SITE_ID /* AJS 20261008 전극저장 */
                                          AND SA.PLANT_ID     = A.PLANT_ID /* AJS 20261008 전극저장 */
                                          AND SA.FACTORY_ID   = A.FACTORY_ID /* AJS 20261008 전극저장 */
                                          AND SA.LINE_ID      = A.LINE_ID /* AJS 20261008 전극저장 */
                                          AND SA.OPERATION_ID = A.OPERATION_ID /* AJS 20261008 전극저장 */
                                          AND SA.ITEM_ID      = A.MDL_NM /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.DIVISION_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.COMPANY_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.SITE_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.PLANT_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.FACTORY_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.LINE_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.OPERATION_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.ELTR_LN_TP_CD) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.ITEM_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                        GROUP BY SA.ELTR_LN_TP_CD) /* AJS 20261008 전극저장 */
         WHERE EXISTS (SELECT 1 /* AJS 20261008 전극저장 */
                         FROM GT_SCP0105_SAV_CHG XA /* AJS 20261008 전극저장 */
                        WHERE XA.DIVISION_ID  = A.DIVISION_ID /* AJS 20261008 전극저장 */
                          AND XA.COMPANY_ID   = A.COMPANY_ID /* AJS 20261008 전극저장 */
                          AND XA.SITE_ID      = A.SITE_ID /* AJS 20261008 전극저장 */
                          AND XA.PLANT_ID     = A.PLANT_ID /* AJS 20261008 전극저장 */
                          AND XA.FACTORY_ID   = A.FACTORY_ID /* AJS 20261008 전극저장 */
                          AND XA.LINE_ID      = A.LINE_ID /* AJS 20261008 전극저장 */
                          AND XA.OPERATION_ID = A.OPERATION_ID /* AJS 20261008 전극저장 */
                          AND XA.ITEM_ID      = A.MDL_NM /* AJS 20261008 전극저장 */
                          AND TRIM(XA.DIVISION_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.COMPANY_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.SITE_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.PLANT_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.FACTORY_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.LINE_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.OPERATION_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.ELTR_LN_TP_CD) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.ITEM_ID) IS NOT NULL); /* AJS 20261008 전극저장 */

        /* 11. 키값 변경시 저장 - Loss Plan - Line (모델명 '-' 줄) */ /* AJS 20261008 전극저장 */
        UPDATE SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL A /* AJS 20261008 전극저장 */
           SET (A.ELTR_LN_TP_CD /* AJS 20261008 전극저장 */
              , A.LAST_UPDATED_BY /* AJS 20261008 전극저장 */
              , A.LAST_UPDATE_DATE) = (SELECT SA.ELTR_LN_TP_CD /* AJS 20261008 전극저장 */
                                            , MAX(SA.LAST_UPDATED_BY)  AS LAST_UPDATED_BY /* AJS 20261008 전극저장 */
                                            , MAX(SA.LAST_UPDATE_DATE) AS LAST_UPDATE_DATE /* AJS 20261008 전극저장 */
                                         FROM GT_SCP0105_SAV_CHG SA /* AJS 20261008 전극저장 */
                                        WHERE SA.DIVISION_ID  = A.DIVISION_ID /* AJS 20261008 전극저장 */
                                          AND SA.COMPANY_ID   = A.COMPANY_ID /* AJS 20261008 전극저장 */
                                          AND SA.SITE_ID      = A.SITE_ID /* AJS 20261008 전극저장 */
                                          AND SA.PLANT_ID     = A.PLANT_ID /* AJS 20261008 전극저장 */
                                          AND SA.FACTORY_ID   = A.FACTORY_ID /* AJS 20261008 전극저장 */
                                          AND SA.LINE_ID      = A.LINE_ID /* AJS 20261008 전극저장 */
                                          AND SA.OPERATION_ID = A.OPERATION_ID /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.DIVISION_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.COMPANY_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.SITE_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.PLANT_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.FACTORY_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.LINE_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.OPERATION_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.ELTR_LN_TP_CD) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.ITEM_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                        GROUP BY SA.ELTR_LN_TP_CD) /* AJS 20261008 전극저장 */
         WHERE EXISTS (SELECT 1 /* AJS 20261008 전극저장 */
                         FROM GT_SCP0105_SAV_CHG XA /* AJS 20261008 전극저장 */
                        WHERE XA.DIVISION_ID  = A.DIVISION_ID /* AJS 20261008 전극저장 */
                          AND XA.COMPANY_ID   = A.COMPANY_ID /* AJS 20261008 전극저장 */
                          AND XA.SITE_ID      = A.SITE_ID /* AJS 20261008 전극저장 */
                          AND XA.PLANT_ID     = A.PLANT_ID /* AJS 20261008 전극저장 */
                          AND XA.FACTORY_ID   = A.FACTORY_ID /* AJS 20261008 전극저장 */
                          AND XA.LINE_ID      = A.LINE_ID /* AJS 20261008 전극저장 */
                          AND XA.OPERATION_ID = A.OPERATION_ID /* AJS 20261008 전극저장 */
                          AND TRIM(XA.DIVISION_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.COMPANY_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.SITE_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.PLANT_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.FACTORY_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.LINE_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.OPERATION_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.ELTR_LN_TP_CD) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.ITEM_ID) IS NOT NULL) /* AJS 20261008 전극저장 */
           AND A.MDL_NM = '-'; /* AJS 20261008 전극저장 */

        /* 12. 데이터 저장 - 본테이블 (전극구분은 맞추는 열쇠에서 빼고 값으로 고친다) */ /* AJS 20261008 전극저장 */
        UPDATE SCP_MST_CAPA_ELTR_SPEED_PLAN A /* AJS 20261008 전극저장 */
           SET (A.BASE_QTY /* AJS 20261008 전극저장 */
              , A.UI_UPD_YN /* AJS 20261008 전극저장 */
              , A.QTY /* AJS 20261008 전극저장 */
              , A.ELTR_LN_TP_CD /* AJS 20261008 전극저장 */
              , A.LAST_UPDATED_BY /* AJS 20261008 전극저장 */
              , A.LAST_UPDATE_DATE) = (SELECT SA.BASE_QTY /* AJS 20261008 전극저장 */
                                            , SA.UI_UPD_YN /* AJS 20261008 전극저장 */
                                            , SA.QTY /* AJS 20261008 전극저장 */
                                            , SA.ELTR_LN_TP_CD /* AJS 20261008 전극저장 */
                                            , SA.LAST_UPDATED_BY /* AJS 20261008 전극저장 */
                                            , SA.LAST_UPDATE_DATE /* AJS 20261008 전극저장 */
                                         FROM GT_SCP0105_SAV_CHG SA /* AJS 20261008 전극저장 */
                                        WHERE SA.DIVISION_ID  = A.DIVISION_ID /* AJS 20261008 전극저장 */
                                          AND SA.COMPANY_ID   = A.COMPANY_ID /* AJS 20261008 전극저장 */
                                          AND SA.SITE_ID      = A.SITE_ID /* AJS 20261008 전극저장 */
                                          AND SA.PLANT_ID     = A.PLANT_ID /* AJS 20261008 전극저장 */
                                          AND SA.FACTORY_ID   = A.FACTORY_ID /* AJS 20261008 전극저장 */
                                          AND SA.LINE_ID      = A.LINE_ID /* AJS 20261008 전극저장 */
                                          AND SA.OPERATION_ID = A.OPERATION_ID /* AJS 20261008 전극저장 */
                                          AND SA.ITEM_ID      = A.ITEM_ID /* AJS 20261008 전극저장 */
                                          AND SA.NICK_NAME    = A.NICK_NAME /* AJS 20261008 전극저장 */
                                          AND SA.MSR_TP_CD    = A.MSR_TP_CD /* AJS 20261008 전극저장 */
                                          AND SA.YYYYMM       = A.YYYYMM /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.DIVISION_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.COMPANY_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.SITE_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.PLANT_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.FACTORY_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.LINE_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.OPERATION_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.ELTR_LN_TP_CD) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.ITEM_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.MSR_TP_CD) IS NOT NULL /* AJS 20261008 전극저장 */
                                          AND TRIM(SA.YYYYMM) IS NOT NULL) /* AJS 20261008 전극저장 */
         WHERE EXISTS (SELECT 1 /* AJS 20261008 전극저장 */
                         FROM GT_SCP0105_SAV_CHG XA /* AJS 20261008 전극저장 */
                        WHERE XA.DIVISION_ID  = A.DIVISION_ID /* AJS 20261008 전극저장 */
                          AND XA.COMPANY_ID   = A.COMPANY_ID /* AJS 20261008 전극저장 */
                          AND XA.SITE_ID      = A.SITE_ID /* AJS 20261008 전극저장 */
                          AND XA.PLANT_ID     = A.PLANT_ID /* AJS 20261008 전극저장 */
                          AND XA.FACTORY_ID   = A.FACTORY_ID /* AJS 20261008 전극저장 */
                          AND XA.LINE_ID      = A.LINE_ID /* AJS 20261008 전극저장 */
                          AND XA.OPERATION_ID = A.OPERATION_ID /* AJS 20261008 전극저장 */
                          AND XA.ITEM_ID      = A.ITEM_ID /* AJS 20261008 전극저장 */
                          AND XA.NICK_NAME    = A.NICK_NAME /* AJS 20261008 전극저장 */
                          AND XA.MSR_TP_CD    = A.MSR_TP_CD /* AJS 20261008 전극저장 */
                          AND XA.YYYYMM       = A.YYYYMM /* AJS 20261008 전극저장 */
                          AND TRIM(XA.DIVISION_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.COMPANY_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.SITE_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.PLANT_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.FACTORY_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.LINE_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.OPERATION_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.ELTR_LN_TP_CD) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.ITEM_ID) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.MSR_TP_CD) IS NOT NULL /* AJS 20261008 전극저장 */
                          AND TRIM(XA.YYYYMM) IS NOT NULL); /* AJS 20261008 전극저장 */

        /* 13. 손실계획 재계산에 넘길 줄 — 전극은 PPM이 아니라 EQP_SPED 로 저장됨 */ /* AJS 20261008 전극저장 */
        DELETE /* AJS 20261008 전극저장 */
          FROM GT_SCP_CAPA_SPEED_PLAN_KEYS; /* AJS 20261008 전극저장 */

        INSERT /* AJS 20261008 전극저장 */
          INTO GT_SCP_CAPA_SPEED_PLAN_KEYS /* AJS 20261008 전극저장 */
             ( VER_ID /* AJS 20261008 전극저장 */
             , VER_SEQ /* AJS 20261008 전극저장 */
             , DIVISION_ID /* AJS 20261008 전극저장 */
             , COMPANY_ID /* AJS 20261008 전극저장 */
             , SITE_ID /* AJS 20261008 전극저장 */
             , PLANT_ID /* AJS 20261008 전극저장 */
             , FACTORY_ID /* AJS 20261008 전극저장 */
             , LINE_ID /* AJS 20261008 전극저장 */
             , OPERATION_ID /* AJS 20261008 전극저장 */
             , ELTR_LN_TP_CD /* AJS 20261008 전극저장 */
             , ITEM_ID /* AJS 20261008 전극저장 */
             , NICK_NAME /* AJS 20261008 전극저장 */
             , MSR_TP_CD /* AJS 20261008 전극저장 */
             , YYYYMM /* AJS 20261008 전극저장 */
             , BASE_QTY /* AJS 20261008 전극저장 */
             , QTY /* AJS 20261008 전극저장 */
             , UI_UPD_YN /* AJS 20261008 전극저장 */
             , REMARK /* AJS 20261008 전극저장 */
             , CREATED_BY /* AJS 20261008 전극저장 */
             , CREATION_DATE /* AJS 20261008 전극저장 */
             , LAST_UPDATED_BY /* AJS 20261008 전극저장 */
             , LAST_UPDATE_DATE ) /* AJS 20261008 전극저장 */
        SELECT P_VERSION                  AS VER_ID /* AJS 20261008 전극저장 */
             , TO_NUMBER(P_VERSION_SEQ)   AS VER_SEQ /* AJS 20261008 전극저장 */
             , DIVISION_ID /* AJS 20261008 전극저장 */
             , COMPANY_ID /* AJS 20261008 전극저장 */
             , SITE_ID /* AJS 20261008 전극저장 */
             , PLANT_ID /* AJS 20261008 전극저장 */
             , FACTORY_ID /* AJS 20261008 전극저장 */
             , LINE_ID /* AJS 20261008 전극저장 */
             , OPERATION_ID /* AJS 20261008 전극저장 */
             , ELTR_LN_TP_CD /* AJS 20261008 전극저장 */
             , ITEM_ID /* AJS 20261008 전극저장 */
             , NICK_NAME /* AJS 20261008 전극저장 */
             , MSR_TP_CD /* AJS 20261008 전극저장 */
             , YYYYMM /* AJS 20261008 전극저장 */
             , BASE_QTY /* AJS 20261008 전극저장 */
             , QTY /* AJS 20261008 전극저장 */
             , UI_UPD_YN /* AJS 20261008 전극저장 */
             , NULL                       AS REMARK /* AJS 20261008 전극저장 */
             , CREATED_BY /* AJS 20261008 전극저장 */
             , CREATION_DATE /* AJS 20261008 전극저장 */
             , LAST_UPDATED_BY /* AJS 20261008 전극저장 */
             , LAST_UPDATE_DATE /* AJS 20261008 전극저장 */
          FROM GT_SCP0105_SAV_CHG /* AJS 20261008 전극저장 */
         WHERE MSR_TP_CD = 'EQP_SPED'; /* AJS 20261008 전극저장 */

        P_SCP0106_CHK_LOSS_SPD_ELTR('SCP0106', 'CURRENT', P_USER_ID, 'F'); /* AJS 20261008 전극저장 */

    END P_SCP0105_SAVE_SPEED_ELTR; /* AJS 20261008 전극저장 */
    /* AJS 20261008 전극저장 (END) */

    /*******************************************************************************
     * P_SCP0105_GET_CAPA_SPEED_PLAN
     *   화면이 부르는 조회 갈래 — 진행상태와 시트로 AS-IS 네 갈래를 가른다
     *
     * ★진행상태 '0'(현재) · '-'(Pre) 는 현재분, 그 밖은 마감분이다.
     *   AS-IS 화면이 이름을 조립할 때 쓰는 판정과 같다.
     *******************************************************************************/
    PROCEDURE P_SCP0105_GET_CAPA_SPEED_PLAN
    (
        P_VERSION               IN  VARCHAR2
      , P_VERSION_SEQ           IN  VARCHAR2
      , P_PROG_STAT             IN  VARCHAR2
      , P_DIVISION_ID           IN  VARCHAR2
      , P_SITE_ID               IN  VARCHAR2
      , P_PLANT_ID              IN  VARCHAR2
      , P_FACTORY_ID            IN  VARCHAR2
      , P_LINE_ID               IN  VARCHAR2
      , P_OPERATION_ID          IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_ELECTRODE_TYPE        IN  VARCHAR2
      , P_PROGRAM_ID            IN  VARCHAR2
      , P_SHEET_NAME            IN  VARCHAR2
      , P_USER_ID               IN  VARCHAR2
      , DEBUG_MODE              IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RC2                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    IS
        V_ERR_MSG               VARCHAR2(4000 CHAR);
    BEGIN

        IF NVL(P_PROG_STAT, '0') IN ('0', '-') THEN          /* 현재분 · Pre */

            IF UPPER(P_SHEET_NAME) = 'ASSEMBLY' THEN
                P_SCP0105_GET_SPEED_CURRENT_ASM(P_VERSION, P_VERSION_SEQ, P_PROG_STAT
                    , P_DIVISION_ID, P_SITE_ID, P_PLANT_ID, P_FACTORY_ID, P_LINE_ID
                    , P_OPERATION_ID, P_ITEM_ID, P_ELECTRODE_TYPE, P_PROGRAM_ID, P_SHEET_NAME
                    , P_USER_ID, DEBUG_MODE, O_RC1, O_RC2);
            ELSE
                P_SCP0105_GET_SPEED_CURRENT_ELTR(P_VERSION, P_VERSION_SEQ, P_PROG_STAT
                    , P_DIVISION_ID, P_SITE_ID, P_PLANT_ID, P_FACTORY_ID, P_LINE_ID
                    , P_OPERATION_ID, P_ITEM_ID, P_ELECTRODE_TYPE, P_PROGRAM_ID, P_SHEET_NAME
                    , P_USER_ID, DEBUG_MODE, O_RC1, O_RC2);
            END IF;

        ELSE                                                  /* 마감분 */

            IF UPPER(P_SHEET_NAME) = 'ASSEMBLY' THEN
                P_SCP0105_GET_SPEED_CUTOFF_ASM(P_VERSION, P_VERSION_SEQ, P_PROG_STAT
                    , P_DIVISION_ID, P_SITE_ID, P_PLANT_ID, P_FACTORY_ID, P_LINE_ID
                    , P_OPERATION_ID, P_ITEM_ID, P_ELECTRODE_TYPE, P_PROGRAM_ID, P_SHEET_NAME
                    , P_USER_ID, DEBUG_MODE, O_RC1, O_RC2);
            ELSE
                P_SCP0105_GET_SPEED_CUTOFF_ELTR(P_VERSION, P_VERSION_SEQ, P_PROG_STAT
                    , P_DIVISION_ID, P_SITE_ID, P_PLANT_ID, P_FACTORY_ID, P_LINE_ID
                    , P_OPERATION_ID, P_ITEM_ID, P_ELECTRODE_TYPE, P_PROGRAM_ID, P_SHEET_NAME
                    , P_USER_ID, DEBUG_MODE, O_RC1, O_RC2);
            END IF;

        END IF;

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_MSG := SQLERRM;

            IF O_RC1%ISOPEN = FALSE THEN
                OPEN O_RC1 FOR SELECT NULL AS VER_ID FROM DUAL WHERE 1 = 0;
            END IF;
            IF O_RC2%ISOPEN = FALSE THEN
                OPEN O_RC2 FOR SELECT NULL AS VER_ID FROM DUAL WHERE 1 = 0;
            END IF;

            OPEN O_RESULT_CURSOR FOR
                SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    END P_SCP0105_GET_CAPA_SPEED_PLAN;

    /*******************************************************************************
     * P_SCP0105_SAVE_CAPA_SPEED_PLAN
     *   화면이 부르는 저장 갈래 — 시트로 AS-IS 두 갈래를 가른다
     *   AS-IS SCP0105_SAVE_CAPA_SPEED_PLAN_ASSEMBLY / _ELTR
     *
     * ★결과는 코드 · 문구 · 건수를 한 커서로 돌려준다(조회 갈래와 같은 꼴).
     *   AS-IS 는 성공 때 결과코드와 건수를, 오류 때 결과코드와 오류문구를 따로 돌려준다.
     * ★오류가 나면 이 갈래에서 되돌린다 — 저장 중간까지 들어간 것을 남기지 않는다.
     *******************************************************************************/
    PROCEDURE P_SCP0105_SAVE_CAPA_SPEED_PLAN
    (
        P_VERSION               IN  CLOB
      , P_VERSION_SEQ           IN  CLOB
      , P_PROG_STAT             IN  CLOB
      , P_DIVISION_ID           IN  CLOB
      , P_COMPANY_ID            IN  CLOB
      , P_SITE_ID               IN  CLOB
      , P_PLANT_ID              IN  CLOB
      , P_FACTORY_ID            IN  CLOB
      , P_LINE_ID               IN  CLOB
      , P_OPERATION_ID          IN  CLOB
      , P_ELECTRODE_TYPE        IN  CLOB
      , P_ITEM_ID               IN  CLOB
      , P_NICK_NAME             IN  CLOB
      , P_CAPA_SPEED_MEASURE    IN  CLOB
      , P_BASE_QTY              IN  CLOB
      , P_UI_UPD_YN             IN  CLOB
      , P_DATE_COLUMN_NAMES     IN  CLOB
      , P_DATE_COLUMN_VALUES    IN  CLOB
      , P_PROGRAM_ID            IN  CLOB
      , P_SHEET_NAME            IN  CLOB
      , P_USER_ID               IN  CLOB
      , P_DEBUG_MODE            IN  CLOB
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    IS
        V_SHEET_NAME    VARCHAR2(400 CHAR) := TO_CHAR(P_SHEET_NAME);
        V_RESULT_CNT    NUMBER := 0;
        V_ERR_MSG       VARCHAR2(4000 CHAR);
    BEGIN

        SAVEPOINT SP_SCP0105_SAVE;

        IF UPPER(V_SHEET_NAME) = 'ASSEMBLY' THEN

            P_SCP0105_SAVE_SPEED_ASM( TO_CHAR(P_VERSION)
                                    , TO_CHAR(P_VERSION_SEQ)
                                    , TO_CHAR(P_PROG_STAT)
                                    , P_DIVISION_ID
                                    , P_COMPANY_ID
                                    , P_SITE_ID
                                    , P_PLANT_ID
                                    , P_FACTORY_ID
                                    , P_LINE_ID
                                    , P_OPERATION_ID
                                    , P_ELECTRODE_TYPE
                                    , P_ITEM_ID
                                    , P_NICK_NAME
                                    , P_CAPA_SPEED_MEASURE
                                    , P_BASE_QTY
                                    , P_UI_UPD_YN
                                    , P_DATE_COLUMN_NAMES
                                    , P_DATE_COLUMN_VALUES
                                    , TO_CHAR(P_PROGRAM_ID)
                                    , TO_CHAR(P_SHEET_NAME)
                                    , TO_CHAR(P_USER_ID)
                                    , TO_CHAR(P_DEBUG_MODE)
                                    , V_RESULT_CNT );

        ELSE

            /* 전극 저장 — 다음 단계에서 옮긴다.
               AS-IS 는 원장 다섯 곳(전극 라인 · 라인 모델 · 라인배정 · 손실계획 · 속도계획)에
               MERGE 여섯 벌을 걸고 없는 기준정보를 만들어 넣는다. */
/*          RAISE_APPLICATION_ERROR(-20001, '전극 저장 갈래 미전환'); */ /* AJS 20261008 전극저장 */
            /* 정정 : AS-IS MERGE 여섯 벌(전극 라인 한 벌은 주석)은 맞는 줄 수정만 있다 — 넣지 않는다 */ /* AJS 20261008 전극저장 */
            P_SCP0105_SAVE_SPEED_ELTR( TO_CHAR(P_VERSION) /* AJS 20261008 전극저장 */
                                     , TO_CHAR(P_VERSION_SEQ) /* AJS 20261008 전극저장 */
                                     , TO_CHAR(P_PROG_STAT) /* AJS 20261008 전극저장 */
                                     , P_DIVISION_ID /* AJS 20261008 전극저장 */
                                     , P_COMPANY_ID /* AJS 20261008 전극저장 */
                                     , P_SITE_ID /* AJS 20261008 전극저장 */
                                     , P_PLANT_ID /* AJS 20261008 전극저장 */
                                     , P_FACTORY_ID /* AJS 20261008 전극저장 */
                                     , P_LINE_ID /* AJS 20261008 전극저장 */
                                     , P_OPERATION_ID /* AJS 20261008 전극저장 */
                                     , P_ELECTRODE_TYPE /* AJS 20261008 전극저장 */
                                     , P_ITEM_ID /* AJS 20261008 전극저장 */
                                     , P_NICK_NAME /* AJS 20261008 전극저장 */
                                     , P_CAPA_SPEED_MEASURE /* AJS 20261008 전극저장 */
                                     , P_BASE_QTY /* AJS 20261008 전극저장 */
                                     , P_UI_UPD_YN /* AJS 20261008 전극저장 */
                                     , P_DATE_COLUMN_NAMES /* AJS 20261008 전극저장 */
                                     , P_DATE_COLUMN_VALUES /* AJS 20261008 전극저장 */
                                     , TO_CHAR(P_PROGRAM_ID) /* AJS 20261008 전극저장 */
                                     , TO_CHAR(P_SHEET_NAME) /* AJS 20261008 전극저장 */
                                     , TO_CHAR(P_USER_ID) /* AJS 20261008 전극저장 */
                                     , TO_CHAR(P_DEBUG_MODE) /* AJS 20261008 전극저장 */
                                     , V_RESULT_CNT ); /* AJS 20261008 전극저장 */

        END IF;

        OPEN O_RESULT_CURSOR FOR
            SELECT '0'                      AS CODE
                 , 'SUCCESS'                AS MSG
                 , TO_CHAR(V_RESULT_CNT)    AS EVENT
                 , 'S'                      AS RESULT_CODE   /* AJS 20261007 화면검증 */
                 , V_RESULT_CNT             AS RESULT_CNT    /* AJS 20261007 화면검증 */
              FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN

            ROLLBACK TO SP_SCP0105_SAVE;

            V_ERR_MSG := '[' || SQLCODE || ']' || SUBSTR(SQLERRM, 1, 1000)
                      || ' @' || SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 2000);

            OPEN O_RESULT_CURSOR FOR
                SELECT '-1'         AS CODE
                     , V_ERR_MSG    AS MSG
                     , TO_CHAR(0)   AS EVENT
                     , 'F'          AS RESULT_CODE   /* AJS 20261007 화면검증 */
                  FROM DUAL;

    END P_SCP0105_SAVE_CAPA_SPEED_PLAN;


END PKG_SCP0105;
/
SHOW ERRORS PACKAGE BODY PKG_SCP0105
