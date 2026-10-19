PACKAGE BODY PKG_SCP0025
IS
    /*
     * Program ID   : PKG_SCP0025
     * Description  : SCP0025 Shipment Plan Fix 화면 - Fix 계획 조회 / Unfix(삭제) 저장
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2026.09.17   AJS            AS-IS(LGCE_SCMDEV) 프로시저 2 건 패키지 전환
     * 2026.10.08   AJS            조회조건 Model/Nickname : 코드 또는 닉네임 부분일치 · 대소문자 무시 · ALL 은 조건 없음
     */

    /* ==============================================================================================
       SCP0025_GET_SHIPMENT_PLAN_FIX
       ============================================================================================== */
    PROCEDURE P_SCP0025_GET_SHIP_PLAN_FIX
    (
        P_DIVISION_ID       IN  VARCHAR2,
        P_BIZ_TYPE          IN  VARCHAR2,
        P_ITEM_ID           IN  VARCHAR2,
        P_FROM_YYYYMMDD     IN  VARCHAR2,
        P_TO_YYYYMMDD       IN  VARCHAR2,
        P_ELECTYPE          IN  VARCHAR2,
        P_PROGRAM_ID        IN  VARCHAR2 DEFAULT 'SCP0025',
        P_SHEET_NAME        IN  VARCHAR2 DEFAULT 'Shipment Plan Fix',
        P_USER_ID           IN  VARCHAR2 DEFAULT NULL,
        P_DEBUG_MODE        IN  VARCHAR2 DEFAULT 'F',
        O_RC1               OUT SYS_REFCURSOR,
        O_RC2               OUT SYS_REFCURSOR,
        O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    IS
    /*
     * Program ID   : SCP0025_GET_SHIPMENT_PLAN_FIX
     * Description  : Production Plan Line 별 조회
     * Program History
     *===================================================================================================
     *   Date       In Charge			Description
     *===================================================================================================
     * 2018/05/28   byunghunjung		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
     * 2018/05/31	KYH					년조회시 년도가 다른 같은 월 조회시 sum이 표시되는 문제 ex) 2018.0528 ~ 2019.0527 조회시 2019.5월 (마지막 주)에 2018.5월 sum값 표시2018.5월의 sum이 표시된다
     * 2018/07/02	KYH					신규 컬럼 추가 조회. (ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, ELECTRODE_TYPE)
     * 2019/06/07	HWYOON				[CSR ID:4010290] SCP UI 생산/출하 계획 저장속도 개선
     * 2019/07/15	HWYOON				[CSR ID:4071705] Production Plan Fix에서 Unfix 기능 추가 - BOD 조회추가
     * 2021/07/07   khj79			    PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD 2단계 개발 : FROM,TO 추가 , scp_mst_bod_v=> scp_mst_bod_n_v
     * 2022/04/29   chaan				81_UC, EE_UC 추가로 DIVSION 크기 확장
     * 2023/04/10   LWY					PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - DIVISION_ID 공통화 작업(div_commonization)
     * 2026.09.17   AJS                 [MSSQL -> Oracle 전환]
     *                                  - 임시테이블(#TblDynamicPivot_SCP0025) 적재 대신 피벗 문장 안의 인라인 뷰로 조회
     *                                    (반환 커서가 임시테이블을 읽으면 커밋 시 비는 문제 · 세션 재사용 시 누적 문제 회피)
     *                                  - 임시테이블 수량 칸 NUMERIC(20,0) 반올림을 ROUND(QTY, 0) 으로 재현
     *                                  - 업무유형명 룩업 유형을 대문자 'BIZ_TYPE' 로 호출 (Oracle 은 대소문자 구분)
     *                                  - 별칭 없음 판정 ('' 비교) 을 NVL 로 재현
     *                                  - 조회조건 대소문자 무시 재현 (사업부 · 업무유형 · 아이템 · 전극유형 파라미터 UPPER)
     *                                  - 정렬 : 옛 정렬규칙(대소문자 무시 · 하이픈 무시 · 밑줄 우선) 재현
     *
     ex) EXEC SCP0025_GET_SHIPMENT_PLAN_FIX @p_division_id='81', @p_biz_type='P', @p_item_id='', @p_from_yyyymmdd='20180702', @p_to_yyyymmdd='20190630', @p_electype='', @p_program_id='SCP0025', @p_sheet_name='Shipment Plan Fix', @p_user_id='kaiser99', @debug_mode='T'
     */
        V_DIVISION_ID   VARCHAR2(30 CHAR)  := UPPER(P_DIVISION_ID);
        V_BIZ_TYPE      VARCHAR2(30 CHAR)  := UPPER(P_BIZ_TYPE);
--      V_ITEM_ID       VARCHAR2(32767)    := UPPER(P_ITEM_ID);   --  2026.10.08 AJS
        V_ITEM_ID       VARCHAR2(32767)    := CASE WHEN UPPER(TRIM(P_ITEM_ID)) = 'ALL' THEN NULL ELSE UPPER(TRIM(P_ITEM_ID)) END;   /* 조회조건 ALL 은 조건 없음 */   --  2026.10.08 AJS
        V_ELECTYPE      VARCHAR2(300 CHAR) := UPPER(P_ELECTYPE);
        V_EE_CNT        PLS_INTEGER        := 0;
        V_MQUERY        CLOB;
        V_MEXEC         CLOB;
        V_INNER         VARCHAR2(32767);
        V_POS           PLS_INTEGER;
        V_LEN           PLS_INTEGER;
        V_ERR           VARCHAR2(4000 CHAR);

        /* 사업부별 조회 원본 (Ship Plan · Fix Reason 두 갈래)
           P_EE = TRUE  : EE 계열 사업부 - BOD 조인에 사업부 조건 없음 · 전극유형 조건 있음
           P_EE = FALSE : 그 외 사업부   - BOD 조인에 사업부 조건 있음 · 전극유형 조건 주석 처리(AS-IS) */
        FUNCTION F_INNER_SQL(P_EE IN BOOLEAN) RETURN VARCHAR2
        IS
            V_TXT   VARCHAR2(32767);
        BEGIN
            V_TXT :=           '                SELECT A.DIVISION_ID'
                || CHR(10) ||  '                     , A.BIZ_TYPE'
                || CHR(10) ||  '                     , A.ITEM_ID'
                || CHR(10) ||  '                     , NVL(A.ELECTRODE_TYPE, ''-'') AS ELECTRODE_TYPE'
                || CHR(10) ||  '                     , NVL(A.ORIGIN_TO_DIVISION_ID, ''-'') AS ORIGIN_TO_DIVISION_ID'
                || CHR(10) ||  '                     , A.TO_SITE'
                || CHR(10) ||  '                     , NVL(A.ORIGIN_FROM_DIVISION_ID, ''-'') AS ORIGIN_FROM_DIVISION_ID'
                || CHR(10) ||  '                     , A.FROM_SITE'
                || CHR(10) ||  '                     , A.INCOTERMS'
                || CHR(10) ||  '                     , A.PROJECT_CODE'
                || CHR(10) ||  '                     , B.TRANSPORT_MODE'
                || CHR(10) ||  '                     , B.LT_TOTAL'
                || CHR(10) ||  '                     , ''Ship Plan'' AS MEASURE'
                || CHR(10) ||  '                     , A.YYYYMMDD'
                || CHR(10) ||  '                     , ROUND(A.QTY, 0) AS QTY /* AS-IS 임시테이블 NUMERIC(20,0) 적재 시 반올림 */'
                || CHR(10) ||  '                     , A.BOD_ID'
                || CHR(10) ||  '                     , B.FROM_YYYYMMDD AS BOD_FROM_YYYYMMDD'
                || CHR(10) ||  '                     , B.TO_YYYYMMDD AS BOD_TO_YYYYMMDD'
                || CHR(10) ||  '                  FROM SCP_ANL_SHIPMENT_PLAN_FIX A'
                || CHR(10) ||  '                     , SCP_MST_BOD_N_V B'
                || CHR(10) ||  CASE WHEN P_EE
                                    THEN '                 WHERE A.BOD_ID = B.BOD_ID'
                                    ELSE '                 WHERE A.DIVISION_ID = B.DIVISION_ID'
                                         || CHR(10) || '                   AND A.BOD_ID = B.BOD_ID'
                               END
--              || CHR(10) ||  '                   AND (:ITEM_ID1 IS NULL OR A.ITEM_ID IN (SELECT SA.COLUMN_VALUE FROM TABLE(STRING_SPLIT(:ITEM_ID2, '','')) SA))'   --  2026.10.08 AJS
                || CHR(10) ||  '                   AND (:ITEM_ID1 IS NULL OR EXISTS (SELECT 1 FROM TABLE(STRING_SPLIT(:ITEM_ID2, '','')) SA WHERE TRIM(SA.COLUMN_VALUE) IS NOT NULL AND (UPPER(A.ITEM_ID) LIKE ''%'' || UPPER(TRIM(SA.COLUMN_VALUE)) || ''%'' OR UPPER(FN_GET_ITEM_NICKNAME(A.DIVISION_ID, A.ITEM_ID)) LIKE ''%'' || UPPER(TRIM(SA.COLUMN_VALUE)) || ''%'')))'   --  2026.10.08 AJS
                || CASE WHEN P_EE
                        THEN CHR(10) || '                   AND (:ELECTYPE1 IS NULL OR A.ELECTRODE_TYPE IN (SELECT SB.COLUMN_VALUE FROM TABLE(STRING_SPLIT(:ELECTYPE2, '','')) SB))'
                   END
                || CHR(10) ||  '                   AND A.YYYYMMDD >= :FROM_YYYYMMDD'
                || CHR(10) ||  '                   AND A.YYYYMMDD <= :TO_YYYYMMDD'
                || CHR(10) ||  '                   AND A.DIVISION_ID = :DIVISION_ID'
                || CHR(10) ||  '                   AND A.BIZ_TYPE = :BIZ_TYPE'
                || CHR(10) ||  '                 UNION ALL'
                || CHR(10) ||  '                SELECT C.DIVISION_ID'
                || CHR(10) ||  '                     , C.BIZ_TYPE'
                || CHR(10) ||  '                     , C.ITEM_ID'
                || CHR(10) ||  '                     , NVL(C.ELECTRODE_TYPE, ''-'') AS ELECTRODE_TYPE'
                || CHR(10) ||  '                     , NVL(C.ORIGIN_TO_DIVISION_ID, ''-'') AS ORIGIN_TO_DIVISION_ID'
                || CHR(10) ||  '                     , C.TO_SITE'
                || CHR(10) ||  '                     , NVL(C.ORIGIN_FROM_DIVISION_ID, ''-'') AS ORIGIN_FROM_DIVISION_ID'
                || CHR(10) ||  '                     , C.FROM_SITE'
                || CHR(10) ||  '                     , C.INCOTERMS'
                || CHR(10) ||  '                     , C.PROJECT_CODE'
                || CHR(10) ||  '                     , D.TRANSPORT_MODE'
                || CHR(10) ||  '                     , D.LT_TOTAL'
                || CHR(10) ||  '                     , ''Fix Reason'' AS MEASURE'
                || CHR(10) ||  '                     , C.YYYYMMDD'
                || CHR(10) ||  '                     , NULL AS QTY'
                || CHR(10) ||  '                     , C.BOD_ID'
                || CHR(10) ||  '                     , D.FROM_YYYYMMDD AS BOD_FROM_YYYYMMDD'
                || CHR(10) ||  '                     , D.TO_YYYYMMDD AS BOD_TO_YYYYMMDD'
                || CHR(10) ||  '                  FROM SCP_ANL_SHIPMENT_PLAN_FIX C'
                || CHR(10) ||  '                     , SCP_MST_BOD_N_V D'
                || CHR(10) ||  CASE WHEN P_EE
                                    THEN '                 WHERE C.BOD_ID = D.BOD_ID'
                                    ELSE '                 WHERE C.DIVISION_ID = D.DIVISION_ID'
                                         || CHR(10) || '                   AND C.BOD_ID = D.BOD_ID'
                               END
--              || CHR(10) ||  '                   AND (:ITEM_ID3 IS NULL OR C.ITEM_ID IN (SELECT XA.COLUMN_VALUE FROM TABLE(STRING_SPLIT(:ITEM_ID4, '','')) XA))'   --  2026.10.08 AJS
                || CHR(10) ||  '                   AND (:ITEM_ID3 IS NULL OR EXISTS (SELECT 1 FROM TABLE(STRING_SPLIT(:ITEM_ID4, '','')) XA WHERE TRIM(XA.COLUMN_VALUE) IS NOT NULL AND (UPPER(C.ITEM_ID) LIKE ''%'' || UPPER(TRIM(XA.COLUMN_VALUE)) || ''%'' OR UPPER(FN_GET_ITEM_NICKNAME(C.DIVISION_ID, C.ITEM_ID)) LIKE ''%'' || UPPER(TRIM(XA.COLUMN_VALUE)) || ''%'')))'   --  2026.10.08 AJS
                || CASE WHEN P_EE
                        THEN CHR(10) || '                   AND (:ELECTYPE3 IS NULL OR C.ELECTRODE_TYPE IN (SELECT XB.COLUMN_VALUE FROM TABLE(STRING_SPLIT(:ELECTYPE4, '','')) XB))'
                   END
                || CHR(10) ||  '                   AND C.YYYYMMDD >= :FROM_YYYYMMDD2'
                || CHR(10) ||  '                   AND C.YYYYMMDD <= :TO_YYYYMMDD2'
                || CHR(10) ||  '                   AND C.DIVISION_ID = :DIVISION_ID2'
                || CHR(10) ||  '                   AND C.BIZ_TYPE = :BIZ_TYPE2';
            RETURN V_TXT;
        END F_INNER_SQL;

    BEGIN
        /********************************************************************************
        * 데이타조회 대상 사업부 구분
        ********************************************************************************/
        --IF @p_division_id NOT IN ('EE','EE_UC')
        SELECT COUNT(*)
          INTO V_EE_CNT
          FROM TABLE(FN_GET_DIVISION_DIV('EE')) A
         WHERE ROWNUM = 1
           AND A.COLUMN_VALUE = V_DIVISION_ID; --div_commonization

        -- BOD 2단계 개발 : FROM , TO 추가
        V_INNER := F_INNER_SQL(V_EE_CNT > 0);

        /********************************************************************************
        * PIVOIT처리
        ********************************************************************************/
        -- PIVOIT 대상 날짜문자열 생성
        --SELECT @mQuery = @mQuery + '[' + yyyymmdd + '], '
        FOR R IN (SELECT IA.YYYYMMDD
                    FROM (SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK AS YYYYMMDD
                               , A.BASIS_START_DATE || '21' AS SORT_ORDER_NO
                            FROM SCM_SYS_CALENDAR_M A
                           WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                           GROUP BY A.BASIS_YYYYMM
                                  , A.ISO_WEEK
                                  , A.BASIS_START_DATE
                           UNION ALL
                          SELECT 'M_' || B.BASIS_YYYYMM AS YYYYMMDD
                               , MIN(B.BASIS_START_DATE) || '01' AS SORT_ORDER_NO
                            FROM SCM_SYS_CALENDAR_M B
                           WHERE B.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                           GROUP BY B.BASIS_YYYYMM
                                  , B.MONTH_NAME
                           UNION ALL
                          SELECT 'D_' || C.BASIS_YYYYMMDD AS YYYYMMDD
                               , C.BASIS_YYYYMMDD || '31' AS SORT_ORDER_NO
                            FROM SCM_SYS_CALENDAR_M C
                           WHERE C.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                           GROUP BY C.BASIS_YYYYMMDD) IA
                   ORDER BY IA.SORT_ORDER_NO)
        LOOP
            V_MQUERY := V_MQUERY
                     || '     , '
                     || CASE WHEN SUBSTR(R.YYYYMMDD, 1, 2) = 'M_'
                             THEN 'TO_CHAR(SUM(CASE WHEN IA.YYYYMM = ''' || SUBSTR(R.YYYYMMDD, -6) || ''' THEN IA.QTY END)) AS ' || R.YYYYMMDD
                             WHEN SUBSTR(R.YYYYMMDD, 1, 2) = 'W_'
                             THEN 'TO_CHAR(SUM(CASE WHEN IA.ISO_WEEK = ''' || SUBSTR(R.YYYYMMDD, -6) || ''' THEN IA.QTY END)) AS ' || R.YYYYMMDD
                             WHEN SUBSTR(R.YYYYMMDD, 1, 2) = 'D_'
                             THEN 'TO_CHAR(SUM(CASE WHEN IA.YYYYMMDD = ''' || SUBSTR(R.YYYYMMDD, 3) || ''' THEN IA.QTY END)) AS ' || R.YYYYMMDD
                        END
                     || CHR(10);
        END LOOP;

        V_MEXEC :=            'SELECT IA.DIVISION_ID'
            || CHR(10) ||     '     , FN_GET_DIVISION_NAME(IA.DIVISION_ID) AS DIVISION_NAME'
            || CHR(10) ||     '     , IA.BIZ_TYPE'
            || CHR(10) ||     '     , FN_GET_LOOKUP_CODE_DESC(''BIZ_TYPE'', IA.BIZ_TYPE) AS BIZ_TYPE_NAME'
            || CHR(10) ||     '     , IA.ITEM_ID'
            || CHR(10) ||     '     , NVL(FN_GET_ITEM_NICKNAME(IA.DIVISION_ID, IA.ITEM_ID), ''-'') AS NICK_NAME'
            || CHR(10) ||     '     , IA.ORIGIN_TO_DIVISION_ID'
            || CHR(10) ||     '     , IA.TO_SITE'
            || CHR(10) ||     '     , FN_GET_SCM_SITE_DESCRIPTION(IA.DIVISION_ID, IA.TO_SITE) AS TO_SITE_DESCRIPTION'
            || CHR(10) ||     '     , IA.ORIGIN_FROM_DIVISION_ID'
            || CHR(10) ||     '     , IA.FROM_SITE'
            || CHR(10) ||     '     , FN_GET_SCM_SITE_DESCRIPTION(IA.DIVISION_ID, IA.FROM_SITE) AS FROM_SITE_DESCRIPTION'
            || CHR(10) ||     '     , NVL(IA.INCOTERMS, ''/'') AS INCOTERMS'
            || CHR(10) ||     '     , NVL(IA.PROJECT_CODE, ''-'') AS PROJECT_CODE'
            || CHR(10) ||     '     , IA.TRANSPORT_MODE'
            || CHR(10) ||     '     , IA.LT_TOTAL'
            || CHR(10) ||     '     , IA.ELECTRODE_TYPE'
            || CHR(10) ||     '     , IA.BOD_ID'
            || CHR(10) ||     '     , IA.BOD_FROM_YYYYMMDD'
            || CHR(10) ||     '     , IA.BOD_TO_YYYYMMDD'
            || CHR(10) ||     '     , IA.MEASURE'
            || CHR(10) ||     V_MQUERY
            ||                '  FROM (SELECT IB.DIVISION_ID'
            || CHR(10) ||     '             , IB.BIZ_TYPE'
            || CHR(10) ||     '             , IB.ITEM_ID'
            || CHR(10) ||     '             , IB.ELECTRODE_TYPE'
            || CHR(10) ||     '             , IB.ORIGIN_TO_DIVISION_ID'
            || CHR(10) ||     '             , IB.TO_SITE'
            || CHR(10) ||     '             , IB.ORIGIN_FROM_DIVISION_ID'
            || CHR(10) ||     '             , IB.FROM_SITE'
            || CHR(10) ||     '             , IB.INCOTERMS'
            || CHR(10) ||     '             , IB.PROJECT_CODE'
            || CHR(10) ||     '             , IB.TRANSPORT_MODE'
            || CHR(10) ||     '             , IB.LT_TOTAL'
            || CHR(10) ||     '             , IB.MEASURE'
            || CHR(10) ||     '             , IB.QTY'
            || CHR(10) ||     '             , IB.YYYYMMDD'
            || CHR(10) ||     '             , E.BASIS_YYYYMM AS YYYYMM'
            || CHR(10) ||     '             , SUBSTR(E.BASIS_YYYYMM, -4) || E.ISO_WEEK AS ISO_WEEK'
            || CHR(10) ||     '             , IB.BOD_ID'
            || CHR(10) ||     '             , IB.BOD_FROM_YYYYMMDD'
            || CHR(10) ||     '             , IB.BOD_TO_YYYYMMDD'
            || CHR(10) ||     '          FROM ('
            || CHR(10) ||     V_INNER
            || CHR(10) ||     '               ) IB'
            || CHR(10) ||     '             , SCM_SYS_CALENDAR_M E'
            || CHR(10) ||     '         WHERE IB.YYYYMMDD = E.BASIS_YYYYMMDD'
            || CHR(10) ||     '       ) IA'
            || CHR(10) ||     ' GROUP BY IA.DIVISION_ID'
            || CHR(10) ||     '        , IA.BIZ_TYPE'
            || CHR(10) ||     '        , IA.ITEM_ID'
            || CHR(10) ||     '        , IA.TO_SITE'
            || CHR(10) ||     '        , IA.FROM_SITE'
            || CHR(10) ||     '        , IA.INCOTERMS'
            || CHR(10) ||     '        , IA.PROJECT_CODE'
            || CHR(10) ||     '        , IA.TRANSPORT_MODE'
            || CHR(10) ||     '        , IA.LT_TOTAL'
            || CHR(10) ||     '        , IA.MEASURE'
            || CHR(10) ||     '        , IA.ELECTRODE_TYPE'
            || CHR(10) ||     '        , IA.ORIGIN_FROM_DIVISION_ID'
            || CHR(10) ||     '        , IA.ORIGIN_TO_DIVISION_ID'
            || CHR(10) ||     '        , IA.BOD_ID'
            || CHR(10) ||     '        , IA.BOD_FROM_YYYYMMDD'
            || CHR(10) ||     '        , IA.BOD_TO_YYYYMMDD'
            /* 옛 정렬규칙 재현 : 대소문자 무시 · 하이픈 무시 · 밑줄은 글자·숫자보다 앞 · 빈값 맨 앞 */
            || CHR(10) ||     ' ORDER BY UPPER(TRANSLATE(IA.DIVISION_ID, ''_-'', ''/'')) NULLS FIRST'
            || CHR(10) ||     '        , IA.DIVISION_ID NULLS FIRST'
            || CHR(10) ||     '        , UPPER(TRANSLATE(IA.BIZ_TYPE, ''_-'', ''/'')) NULLS FIRST'
            || CHR(10) ||     '        , IA.BIZ_TYPE NULLS FIRST'
            || CHR(10) ||     '        , UPPER(TRANSLATE(IA.ITEM_ID, ''_-'', ''/'')) NULLS FIRST'
            || CHR(10) ||     '        , IA.ITEM_ID NULLS FIRST'
            || CHR(10) ||     '        , UPPER(TRANSLATE(IA.TO_SITE, ''_-'', ''/'')) NULLS FIRST'
            || CHR(10) ||     '        , IA.TO_SITE NULLS FIRST'
            || CHR(10) ||     '        , UPPER(TRANSLATE(IA.FROM_SITE, ''_-'', ''/'')) NULLS FIRST'
            || CHR(10) ||     '        , IA.FROM_SITE NULLS FIRST'
            || CHR(10) ||     '        , UPPER(TRANSLATE(IA.TRANSPORT_MODE, ''_-'', ''/'')) NULLS FIRST'
            || CHR(10) ||     '        , IA.TRANSPORT_MODE NULLS FIRST'
            || CHR(10) ||     '        , UPPER(TRANSLATE(NVL(IA.INCOTERMS, ''/''), ''_-'', ''/'')) NULLS FIRST'
            || CHR(10) ||     '        , NVL(IA.INCOTERMS, ''/'')'
            || CHR(10) ||     '        , UPPER(TRANSLATE(NVL(IA.PROJECT_CODE, ''-''), ''_-'', ''/'')) NULLS FIRST'
            || CHR(10) ||     '        , NVL(IA.PROJECT_CODE, ''-'')'
            || CHR(10) ||     '        , UPPER(TRANSLATE(IA.BOD_ID, ''_-'', ''/'')) NULLS FIRST'
            || CHR(10) ||     '        , IA.BOD_ID NULLS FIRST'
            || CHR(10) ||     '        , IA.MEASURE DESC';
            --SET @mEXEC = @mEXEC+'		ORDER BY  division_id, biz_type, item_id, to_site, from_site, transport_mode, incoterms, project_code, measure desc '+CHAR(10);

        -----------------------------------------------------------
        -- DEBUG QRY 출력
        -----------------------------------------------------------
        IF P_DEBUG_MODE = 'T' THEN
            BEGIN
                V_POS := 1;
                V_LEN := DBMS_LOB.GETLENGTH(V_MEXEC);
                WHILE V_POS <= V_LEN LOOP
                    DBMS_OUTPUT.PUT_LINE(DBMS_LOB.SUBSTR(V_MEXEC, 4000, V_POS));
                    V_POS := V_POS + 4000;
                END LOOP;
            EXCEPTION
                WHEN OTHERS THEN
                    NULL;   /* 출력 버퍼 한도 초과는 조회 결과와 무관하므로 무시 */
            END;
        END IF;
        -----------------------------------------------------------

        /* 피벗 칸이 조회기간에 따라 달라지므로 동적 문장으로 연다 (조건값은 모두 바인드) */
        IF V_EE_CNT > 0 THEN
            OPEN O_RC1 FOR V_MEXEC
            USING V_ITEM_ID, V_ITEM_ID, V_ELECTYPE, V_ELECTYPE, P_FROM_YYYYMMDD, P_TO_YYYYMMDD, V_DIVISION_ID, V_BIZ_TYPE
                , V_ITEM_ID, V_ITEM_ID, V_ELECTYPE, V_ELECTYPE, P_FROM_YYYYMMDD, P_TO_YYYYMMDD, V_DIVISION_ID, V_BIZ_TYPE;
        ELSE
            OPEN O_RC1 FOR V_MEXEC
            USING V_ITEM_ID, V_ITEM_ID, P_FROM_YYYYMMDD, P_TO_YYYYMMDD, V_DIVISION_ID, V_BIZ_TYPE
                , V_ITEM_ID, V_ITEM_ID, P_FROM_YYYYMMDD, P_TO_YYYYMMDD, V_DIVISION_ID, V_BIZ_TYPE;
        END IF;

        --IF @p_division_id NOT IN ('EE','EE_UC')
        IF V_EE_CNT = 0 THEN --div_commonization
            OPEN O_RC2 FOR
                SELECT A.DIVISION_ID
                     , A.BIZ_TYPE
                     , A.ITEM_ID
                     , NVL(A.ELECTRODE_TYPE, '-') AS ELECTRODE_TYPE
                     , NVL(A.ORIGIN_TO_DIVISION_ID, '-') AS ORIGIN_TO_DIVISION_ID
                     , A.TO_SITE
                     , NVL(A.ORIGIN_FROM_DIVISION_ID, '-') AS ORIGIN_FROM_DIVISION_ID
                     , A.FROM_SITE
                     , A.INCOTERMS
                     , A.PROJECT_CODE
                     , B.TRANSPORT_MODE
                     , B.LT_TOTAL
                     , B.BOD_ID                         -- BOD 2단계 개발
                     , 'Fix Reason' AS MEASURE
                     , A.YYYYMMDD
                     , A.FIX_REASON
                  FROM SCP_ANL_SHIPMENT_PLAN_FIX A
                     -- BOD 2단계 개발 : scp_mst_bod_v -> scp_mst_bod_n_v
                     , SCP_MST_BOD_N_V B
                 WHERE A.DIVISION_ID = B.DIVISION_ID
                   AND A.BOD_ID = B.BOD_ID
--                 AND (V_ITEM_ID IS NULL OR A.ITEM_ID IN (SELECT SA.COLUMN_VALUE FROM TABLE(STRING_SPLIT(V_ITEM_ID, ',')) SA))   --  2026.10.08 AJS
                   /* 2026.10.08 AJS Model/Nickname 검색 (START) : 입력값(쉼표 여러 개)이 코드 또는 닉네임에 부분일치 */
                   AND (   V_ITEM_ID IS NULL
                        OR EXISTS (SELECT 1
                                     FROM TABLE(STRING_SPLIT(V_ITEM_ID, ',')) SA
                                    WHERE TRIM(SA.COLUMN_VALUE) IS NOT NULL
                                      AND (   UPPER(A.ITEM_ID) LIKE '%' || UPPER(TRIM(SA.COLUMN_VALUE)) || '%'
                                           OR UPPER(FN_GET_ITEM_NICKNAME(A.DIVISION_ID, A.ITEM_ID)) LIKE '%' || UPPER(TRIM(SA.COLUMN_VALUE)) || '%')))
                   /* 2026.10.08 AJS Model/Nickname 검색 (END) */
                   --AND ( ( @p_electype IS NULL OR  @p_electype ='') OR A.ELECTRODE_TYPE	IN (SELECT token FROM dbo.String_Split(@p_electype, ',')))
                   AND A.YYYYMMDD >= P_FROM_YYYYMMDD
                   AND A.YYYYMMDD <= P_TO_YYYYMMDD
                   AND A.DIVISION_ID = V_DIVISION_ID
                   AND A.BIZ_TYPE = V_BIZ_TYPE
                 ORDER BY UPPER(TRANSLATE(A.DIVISION_ID, '_-', '/')) NULLS FIRST
                        , A.DIVISION_ID NULLS FIRST
                        , UPPER(TRANSLATE(A.BIZ_TYPE, '_-', '/')) NULLS FIRST
                        , A.BIZ_TYPE NULLS FIRST
                        , UPPER(TRANSLATE(A.ITEM_ID, '_-', '/')) NULLS FIRST
                        , A.ITEM_ID NULLS FIRST
                        , UPPER(TRANSLATE(A.TO_SITE, '_-', '/')) NULLS FIRST
                        , A.TO_SITE NULLS FIRST
                        , UPPER(TRANSLATE(A.FROM_SITE, '_-', '/')) NULLS FIRST
                        , A.FROM_SITE NULLS FIRST
                        , MEASURE DESC;
        ELSE
            OPEN O_RC2 FOR
                SELECT A.DIVISION_ID
                     , A.BIZ_TYPE
                     , A.ITEM_ID
                     , NVL(A.ELECTRODE_TYPE, '-') AS ELECTRODE_TYPE
                     , NVL(A.ORIGIN_TO_DIVISION_ID, '-') AS ORIGIN_TO_DIVISION_ID
                     , A.TO_SITE
                     , NVL(A.ORIGIN_FROM_DIVISION_ID, '-') AS ORIGIN_FROM_DIVISION_ID
                     , A.FROM_SITE
                     , A.INCOTERMS
                     , A.PROJECT_CODE
                     , B.TRANSPORT_MODE
                     , B.LT_TOTAL
                     , B.BOD_ID                         -- BOD 2단계 개발
                     , 'Fix Reason' AS MEASURE
                     , A.YYYYMMDD
                     , A.FIX_REASON
                  FROM SCP_ANL_SHIPMENT_PLAN_FIX A
                     -- BOD 2단계 개발 : scp_mst_bod_v -> scp_mst_bod_n_v
                     , SCP_MST_BOD_N_V B
                 WHERE A.BOD_ID = B.BOD_ID
--                 AND (V_ITEM_ID IS NULL OR A.ITEM_ID IN (SELECT SA.COLUMN_VALUE FROM TABLE(STRING_SPLIT(V_ITEM_ID, ',')) SA))   --  2026.10.08 AJS
                   /* 2026.10.08 AJS Model/Nickname 검색 (START) : 입력값(쉼표 여러 개)이 코드 또는 닉네임에 부분일치 */
                   AND (   V_ITEM_ID IS NULL
                        OR EXISTS (SELECT 1
                                     FROM TABLE(STRING_SPLIT(V_ITEM_ID, ',')) SA
                                    WHERE TRIM(SA.COLUMN_VALUE) IS NOT NULL
                                      AND (   UPPER(A.ITEM_ID) LIKE '%' || UPPER(TRIM(SA.COLUMN_VALUE)) || '%'
                                           OR UPPER(FN_GET_ITEM_NICKNAME(A.DIVISION_ID, A.ITEM_ID)) LIKE '%' || UPPER(TRIM(SA.COLUMN_VALUE)) || '%')))
                   /* 2026.10.08 AJS Model/Nickname 검색 (END) */
                   AND (V_ELECTYPE IS NULL OR A.ELECTRODE_TYPE IN (SELECT XA.COLUMN_VALUE FROM TABLE(STRING_SPLIT(V_ELECTYPE, ',')) XA))
                   AND A.YYYYMMDD >= P_FROM_YYYYMMDD
                   AND A.YYYYMMDD <= P_TO_YYYYMMDD
                   AND A.DIVISION_ID = V_DIVISION_ID
                   AND A.BIZ_TYPE = V_BIZ_TYPE
                 ORDER BY UPPER(TRANSLATE(A.DIVISION_ID, '_-', '/')) NULLS FIRST
                        , A.DIVISION_ID NULLS FIRST
                        , UPPER(TRANSLATE(A.BIZ_TYPE, '_-', '/')) NULLS FIRST
                        , A.BIZ_TYPE NULLS FIRST
                        , UPPER(TRANSLATE(A.ITEM_ID, '_-', '/')) NULLS FIRST
                        , A.ITEM_ID NULLS FIRST
                        , UPPER(TRANSLATE(A.TO_SITE, '_-', '/')) NULLS FIRST
                        , A.TO_SITE NULLS FIRST
                        , UPPER(TRANSLATE(A.FROM_SITE, '_-', '/')) NULLS FIRST
                        , A.FROM_SITE NULLS FIRST
                        , MEASURE DESC;
        END IF;

        OPEN O_RESULT_CURSOR FOR
            SELECT '0'       AS CODE
                 , 'SUCCESS' AS MSG
              FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR := SUBSTR(SQLERRM, 1, 4000);
            OPEN O_RC1 FOR
                SELECT NULL AS DUMMY
                  FROM DUAL
                 WHERE 1 = 0;
            OPEN O_RC2 FOR
                SELECT NULL AS DUMMY
                  FROM DUAL
                 WHERE 1 = 0;
            OPEN O_RESULT_CURSOR FOR
                SELECT '-1'  AS CODE
                     , V_ERR AS MSG
                  FROM DUAL;
    END P_SCP0025_GET_SHIP_PLAN_FIX;

    /* ==============================================================================================
       SCP0025_SAVE_SHIPMENT_PLAN_FIX_DATASET
       ============================================================================================== */
    PROCEDURE P_SCP0025_SAVE_FIX_DATASET
    (
        P_DATA              IN  CLOB,
        P_USER_ID           IN  VARCHAR2,
        O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    IS
    /*
     * Program ID   : SCP0025_SAVE_SHIPMENT_PLAN_FIX_DATASET
     * Description  : SHIPMENT PLAN FG/SEMI FIX 삭제
     * Program History
     *===================================================================================================
     *   Date       In Charge		Description
     *===================================================================================================
     * 2019/07/25   yhw				[CSR ID:4071705] Production Plan Fix에서 Unfix 기능 추가
     * 2022/04/29   chaan			81_UC, EE_UC 추가로 DIVSION 크기 확장
     * 2025/11/11   hrkim			[PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선
     *								  : ESS 가상 사이트 계획을 매핑된 JV 사이트 계획으로 동기화 저장 (ESS 가상 -> JV Real 단방향 저장)
     *									- @SCP0025를 @SCP0025_WITH_JV 변수로 대체하여 사용
     *									- TO Site 정보는 그대로 가져간다. (BOD_ID는 매핑이 안되면 '-')
     *								    - 2025.12.16 동기화 대상 데이터 from/to 사이트와 무관하게 origin from/to division_id 컬럼 division_id와 같은 값으로 저장(81_ST) : 김춘동 책임님
     *								    - 2025.12.23 동기화 데이터 생성시 BOD_ID 매핑이 안되는 경우 ESS 가상 사이트 BOD_ID 유지
     * 2026.09.17   AJS             [MSSQL -> Oracle 전환]
     *                              - 테이블 형식 파라미터 @SCP0025 -> JSON 배열(P_DATA) · 행 키는 파일 머리 설명 참조
     *                              - @SCP0025_WITH_JV 변수 -> GT_SCP0025_FIX_DATA (ON COMMIT DELETE ROWS)
     *                              - #JV_ESS_SCM_SITE_MAP · #DIVISION_LAST_PLAN_INFO · #BOD_ITEM -> 인라인 뷰
     *                              - 등록자(p_created_by) 는 행 값 대신 세션 사용자(P_USER_ID)
     *                              - 트랜잭션 : AS-IS 는 BEGIN TRAN 없이 문장 단위로 반영되고 CATCH 에서 COMMIT 한다.
     *                                           실패한 문장만 되돌려지고 앞 문장 반영분은 남는 동작을 그대로 유지한다.
     *                              - 키 비교 대소문자 무시 재현 : 삭제 플래그 · 입력 키 UPPER,
     *                                원장에 소문자가 있는 칸(TO_SITE · PROJECT_CODE, BOD 의 TO_SITE)은 양쪽 UPPER
     *                              - BOD 대표 선정 : 이관 시 수정일시 밀리초가 잘려 생긴 동률을 BOD_ID 내림차순으로 고정
     */
        V_MAX_LOOP_CNT      VARCHAR2(50 CHAR);

        -- LOG 용 변수 설정
        V_PROGRAM_NAME      VARCHAR2(150 CHAR) := 'SCP0025_SAVE_SHIPMENT_PLAN_FIX_DATASET';
        V_LOG_TYPE          VARCHAR2(30 CHAR);     -- START/END/ERROR/...
        V_N_LOG_COUNT       PLS_INTEGER := 0;
        V_LOG_MESSAGE       VARCHAR2(1000 CHAR);
        V_DESCRIPTION       VARCHAR2(500 CHAR);
        V_EVENT_DATE        DATE;

        -- 실행시간 확인용
        V_START_TIME        DATE := SYSDATE;
        V_EXEC_TIME         VARCHAR2(10 CHAR) := ''; --'00:00';

        V_TODAY             VARCHAR2(8 CHAR) := TO_CHAR(SYSDATE, 'YYYYMMDD');
        V_BEFORE_20         VARCHAR2(8 CHAR) := TO_CHAR(SYSDATE - 20, 'YYYYMMDD');
        V_BEFORE_7          VARCHAR2(8 CHAR) := TO_CHAR(SYSDATE - 7, 'YYYYMMDD');
        V_LAST_MONDAY       VARCHAR2(8 CHAR);

        V_ERR_CODE          VARCHAR2(20 CHAR);
        V_ERR_MESSAGE       VARCHAR2(4000 CHAR);
    BEGIN
        /* GTT 초기화 (TRUNCATE 금지) */
        DELETE FROM GT_SCP0025_FIX_DATA;

        -- 시작 LOG
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := '';
        V_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, V_N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, V_EVENT_DATE);

        -------------------------------------------------------------------------------------------------------------------------------------------------------
        --### Start : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장)
        -------------------------------------------------------------------------------------------------------------------------------------------------------
        ------------------------------------------------------------------------------------------------------------------
        -- 파마미터로 받은 데이터 @SCP0025_WITH_JV 변수에 추가
        -- ESS MI법인 -> JV 동기화 저장 (단방향 저장으로 가상 사이트에 매핑된 JV 사이트 데이터는 제외)
        ------------------------------------------------------------------------------------------------------------------
        INSERT INTO GT_SCP0025_FIX_DATA
             (
               P_ACTIVE_FLAG
             , P_DIVISION_ID
             , P_OPERATION_GROUP
             , P_ITEM_ID
             , P_TO_SITE
             , P_FROM_SITE
             , P_BOD_ID
             , P_YYYYMMDD
             , P_PROJECT_CODE
             , P_INCOTERMS
             , P_QTY
             , P_ORIGIN_FROM_DIVISION_ID
             , P_ORIGIN_TO_DIVISION_ID
             , P_ELECTRODE_TYPE
             , P_CREATED_BY
             )
        SELECT A.ACTIVE_FLAG
             , A.DIVISION_ID
             , A.BIZ_TYPE
             , A.ITEM_ID
             , A.TO_SITE
             , A.FROM_SITE
             , A.BOD_ID
             , A.YYYYMMDD
             , A.PROJECT_CODE
             , A.INCOTERMS
             , A.QTY
             , A.ORIGIN_FROM_DIVISION_ID
             , A.ORIGIN_TO_DIVISION_ID
             , A.ELECTRODE_TYPE
             , P_USER_ID
          FROM JSON_TABLE(P_DATA, '$[*]' ERROR ON ERROR
                          COLUMNS ( ACTIVE_FLAG             VARCHAR2(4000) PATH '$.ACTIVE_FLAG'             NULL ON EMPTY
                                  , DIVISION_ID             VARCHAR2(4000) PATH '$.DIVISION_ID'             NULL ON EMPTY
                                  , BIZ_TYPE                VARCHAR2(4000) PATH '$.BIZ_TYPE'                NULL ON EMPTY
                                  , ITEM_ID                 VARCHAR2(4000) PATH '$.ITEM_ID'                 NULL ON EMPTY
                                  , TO_SITE                 VARCHAR2(4000) PATH '$.TO_SITE'                 NULL ON EMPTY
                                  , FROM_SITE               VARCHAR2(4000) PATH '$.FROM_SITE'               NULL ON EMPTY
                                  , BOD_ID                  VARCHAR2(4000) PATH '$.BOD_ID'                  NULL ON EMPTY
                                  , YYYYMMDD                VARCHAR2(4000) PATH '$.YYYYMMDD'                NULL ON EMPTY
                                  , PROJECT_CODE            VARCHAR2(4000) PATH '$.PROJECT_CODE'            NULL ON EMPTY
                                  , INCOTERMS               VARCHAR2(4000) PATH '$.INCOTERMS'               NULL ON EMPTY
                                  , QTY                     VARCHAR2(4000) PATH '$.QTY'                     NULL ON EMPTY
                                  , ORIGIN_FROM_DIVISION_ID VARCHAR2(4000) PATH '$.ORIGIN_FROM_DIVISION_ID' NULL ON EMPTY
                                  , ORIGIN_TO_DIVISION_ID   VARCHAR2(4000) PATH '$.ORIGIN_TO_DIVISION_ID'   NULL ON EMPTY
                                  , ELECTRODE_TYPE          VARCHAR2(4000) PATH '$.ELECTRODE_TYPE'          NULL ON EMPTY
                                  )) A;
        -- 2025.12.16 주석 처리 (자동차 품목 생산될 수 있음) 	  LEFT JOIN #JV_ESS_SCM_SITE_MAP SM
        -- 2025.12.16 주석 처리 (자동차 품목 생산될 수 있음) 		     ON SM.RP_DIVISION_ID	= PR.P_DIVISION_ID
        -- 2025.12.16 주석 처리 (자동차 품목 생산될 수 있음) 		    AND SM.RP_SCM_SITE_ID	= PR.P_FROM_SITE
        -- 2025.12.16 주석 처리 (자동차 품목 생산될 수 있음) WHERE SM.RP_DIVISION_ID IS NULL  --- 가상 사이트에 매핑된 JV 사이트 데이터는 제외

        ------------------------------------------------------------------------------------------------------------------
        -- 가상 사이트에 매핑된 JV 사이트 데이터 @SCP0025_WITH_JV 변수에 추가
        -- ESS MI법인 -> JV 동기화 저장 (단방향 저장으로 가상 사이트에 매핑된 JV 사이트 데이터는 제외)
        ------------------------------------------------------------------------------------------------------------------
        SELECT MAX(YYYYMMDD)
          INTO V_LAST_MONDAY
          FROM SCM_MST_BUCKET
         WHERE YYYYMMDD <= V_TODAY
           AND DAYOFWEEK = 'MON';

        INSERT INTO GT_SCP0025_FIX_DATA
             (
               P_ACTIVE_FLAG
             , P_DIVISION_ID
             , P_OPERATION_GROUP
             , P_ITEM_ID
             , P_TO_SITE
             , P_FROM_SITE
             , P_BOD_ID
             , P_YYYYMMDD
             , P_PROJECT_CODE
             , P_INCOTERMS
             , P_QTY
             , P_ORIGIN_FROM_DIVISION_ID
             , P_ORIGIN_TO_DIVISION_ID
             , P_ELECTRODE_TYPE
             , P_CREATED_BY
             )
        SELECT A.P_ACTIVE_FLAG
             , B.RP_DIVISION_ID AS P_DIVISION_ID
             , A.P_OPERATION_GROUP
             , A.P_ITEM_ID
             , A.P_TO_SITE
             , B.RP_SCM_SITE_ID AS P_FROM_SITE
             , NVL(NVL(XA.BOD_ID, A.P_BOD_ID), '/') AS P_BOD_ID       -- 2025.12.23 bod_id 매핑이 안되는 경우 ESS가상 사이트 기준 BOD_ID 유지
             , A.P_YYYYMMDD
             , A.P_PROJECT_CODE
             , A.P_INCOTERMS
             , A.P_QTY
             , B.RP_DIVISION_ID AS P_ORIGIN_FROM_DIVISION_ID
             , B.RP_DIVISION_ID AS P_ORIGIN_TO_DIVISION_ID            -- 2025.12.16 division_id와 같은 값으로
             , A.P_ELECTRODE_TYPE
             , A.P_CREATED_BY
          FROM GT_SCP0025_FIX_DATA A
             , TABLE(FN_GET_JV_REAL_ESS_VIRTUAL_SITE_MAP()) B
               ------------------------------------------------------------------------------------------------------------
               -- DIVISION 주차별 최종 수행 Plan 버전 정보
               -- ESS 가상 라인 매핑 JV division의 동기화 대상 버전 정보 확인을 위한 데이터
               -- Final Plan은 수정 대상에서 제외 ?
               ------------------------------------------------------------------------------------------------------------
             , (SELECT SA.DIVISION_ID
                     , SA.PLAN_START_YYYYMMDD
                  FROM (SELECT E.DIVISION_ID
                             , D.PLAN_NAME AS PLAN_START_YYYYMMDD
                             , E.PLAN_TYPE
                             , ROW_NUMBER() OVER (PARTITION BY E.DIVISION_ID
                                                             , D.PLAN_NAME
                                                      ORDER BY CASE WHEN E.PLAN_TYPE = 'PR' THEN 4
                                                                    WHEN E.PLAN_TYPE = 'MA' THEN 3
                                                                    WHEN E.PLAN_TYPE = 'SE' THEN 2
                                                                    WHEN E.PLAN_TYPE = 'FN' THEN 1
                                                                    ELSE 0
                                                               END
                                                             , E.PLAN_SEQ DESC NULLS LAST
                                                             , E.INPUT_START_DATE DESC NULLS LAST) AS RN
                          FROM SCM_MST_PLAN D
                             , SCM_MST_PLAN_DETAIL E
                             , SCM_MST_DIVISION F
                         WHERE E.DIVISION_ID = D.DIVISION_ID
                           AND E.PLAN_ID = D.PLAN_ID
                           AND F.DIVISION_ID = D.DIVISION_ID
                           AND E.PLAN_STATUS = '1'
                           AND F.ATTRIBUTE3 != 'EE'
                           AND D.PLAN_CYCLE = 'WEEKLY'
                           AND D.PLAN_NAME >= V_BEFORE_20) SA
                 WHERE SA.RN = 1
                   AND SA.PLAN_TYPE != 'FN') IA  -- Final plan 대상에서 제외
             , SCP_MST_BOD C
               ------------------------------------------------------------------------------------------------------------------
               -- BOD 및 BOD ITEM 정보
               ------------------------------------------------------------------------------------------------------------------
             , (SELECT SB.DIVISION_ID
                     , SB.FROM_SITE
                     , SB.TO_SITE
                     , SB.INCOTERMS
                     , SB.ITEM_ID
                     , SB.BOD_ID
                  FROM (SELECT G.DIVISION_ID
                             , G.FROM_SITE
                             , G.TO_SITE
                             , G.INCOTERMS
                             , H.ITEM_ID
                             , G.BOD_ID
                             , ROW_NUMBER() OVER (PARTITION BY G.DIVISION_ID
                                                             , G.FROM_SITE
                                                             , G.TO_SITE
                                                             , G.INCOTERMS
                                                             , H.ITEM_ID
                                                      ORDER BY G.PRIORITY NULLS FIRST
                                                             , H.PRIORITY NULLS FIRST
                                                             , G.ATTRIBUTE3 DESC NULLS LAST
                                                             , G.LAST_UPDATE_DATE DESC NULLS LAST
                                                             , LENGTH(G.BOD_ID) DESC       /* 수정일시 밀리초 절삭 동률 고정 */
                                                             , G.BOD_ID DESC) AS RN
                          FROM SCP_MST_BOD G
                             , SCP_MST_BOD_ITEM H
                         WHERE H.BOD_ID = G.BOD_ID
                           AND EXISTS (SELECT 1
                                         FROM TABLE(FN_GET_JV_REAL_ESS_VIRTUAL_SITE_MAP()) SC
                                        WHERE SC.RP_DIVISION_ID = G.DIVISION_ID
                                          AND SC.RP_SCM_SITE_ID = G.FROM_SITE)
                           AND H.VALID_YN = 'Y'
                           AND G.VALID_YN = 'Y'
                           AND H.TO_YYYYMMDD >= V_BEFORE_7
                           AND G.ATTRIBUTE3 > V_BEFORE_7) SB
                 WHERE SB.RN = 1) XA
         WHERE B.VP_DIVISION_ID = UPPER(A.P_DIVISION_ID)
           AND B.VP_SCM_SITE_ID = UPPER(A.P_FROM_SITE)
           AND IA.DIVISION_ID = B.RP_DIVISION_ID            -- 수정할 대상 버전이 있어야 수정 (FN 까지 완료된 경우 수정하지 않음)
           AND C.BOD_ID(+) = UPPER(A.P_BOD_ID)
           AND XA.DIVISION_ID(+) = B.RP_DIVISION_ID
           AND XA.FROM_SITE(+) = B.RP_SCM_SITE_ID
           AND UPPER(XA.TO_SITE(+)) = UPPER(A.P_TO_SITE)
           AND XA.INCOTERMS(+) = C.INCOTERMS
           AND XA.ITEM_ID(+) = UPPER(A.P_ITEM_ID)
           AND IA.PLAN_START_YYYYMMDD = V_LAST_MONDAY;
        -------------------------------------------------------------------------------------------------------------------------------------------------------
        --### End : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장)
        -------------------------------------------------------------------------------------------------------------------------------------------------------

        --수정 Row
        SELECT TO_CHAR(COUNT(*))
          INTO V_MAX_LOOP_CNT
          FROM GT_SCP0025_FIX_DATA; -- PJ2025F254 : @SCP0025를 @SCP0025_WITH_JV 변수로 대체하여 사용

        --3. Fix History
        INSERT INTO SCP_ANL_SHIPMENT_PLAN_FIX_H
             (
               HISTORY_SEQ
             , FIX_ID
             , DIVISION_ID
             , BIZ_TYPE
             , ITEM_ID
             , TO_SITE
             , FROM_SITE
             , PROJECT_CODE
             , INCOTERMS
             , BOD_ID
             , YYYYMMDD
             , QTY
             , ORIGIN_FROM_DIVISION_ID
             , ORIGIN_TO_DIVISION_ID
             , ELECTRODE_TYPE
             , FIX_REASON
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , HISTORY_CREATION_DATE
             , ATTRIBUTE1
             )
        SELECT SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H.NEXTVAL
             , B.FIX_ID
             , A.P_DIVISION_ID
             , A.P_OPERATION_GROUP
             , A.P_ITEM_ID
             , A.P_TO_SITE
             , A.P_FROM_SITE
             , A.P_PROJECT_CODE
             , A.P_INCOTERMS
             , A.P_BOD_ID
             , A.P_YYYYMMDD
             , TRUNC(TO_NUMBER(A.P_QTY))       /* cast(round(x, 0, 1) as int) : 세 번째 인자 1 은 절삭 */
             , A.P_ORIGIN_FROM_DIVISION_ID
             , A.P_ORIGIN_TO_DIVISION_ID
             , A.P_ELECTRODE_TYPE
             , B.FIX_REASON
             , A.P_CREATED_BY
             , SYSDATE
             , A.P_CREATED_BY
             , SYSDATE
             , SYSDATE
             , A.P_ACTIVE_FLAG
          FROM GT_SCP0025_FIX_DATA A -- PJ2025F254 : @SCP0025를 @SCP0025_WITH_JV 변수로 대체하여 사용 B
             , SCP_ANL_SHIPMENT_PLAN_FIX B
         WHERE B.DIVISION_ID = UPPER(A.P_DIVISION_ID)
           AND B.BIZ_TYPE = UPPER(A.P_OPERATION_GROUP)
           AND B.ITEM_ID = UPPER(A.P_ITEM_ID)
           AND UPPER(B.TO_SITE) = UPPER(A.P_TO_SITE)
           AND B.FROM_SITE = UPPER(A.P_FROM_SITE)
           AND UPPER(NVL(B.PROJECT_CODE, '-')) = UPPER(NVL(A.P_PROJECT_CODE, '-'))
           AND NVL(B.INCOTERMS, '-') = UPPER(NVL(A.P_INCOTERMS, '-'))
           AND B.BOD_ID = UPPER(A.P_BOD_ID)
           AND B.YYYYMMDD = A.P_YYYYMMDD
           AND NVL(B.ORIGIN_FROM_DIVISION_ID, '-') = UPPER(NVL(A.P_ORIGIN_FROM_DIVISION_ID, '-'))
           AND NVL(B.ORIGIN_TO_DIVISION_ID, '-') = UPPER(NVL(A.P_ORIGIN_TO_DIVISION_ID, '-'))
           AND NVL(B.ELECTRODE_TYPE, '-') = UPPER(NVL(A.P_ELECTRODE_TYPE, '-'));

        --4. 삭제
        DELETE FROM SCP_ANL_SHIPMENT_PLAN_FIX A
         WHERE EXISTS (SELECT 1
                         FROM GT_SCP0025_FIX_DATA SA -- PJ2025F254 : @SCP0025를 @SCP0025_WITH_JV 변수로 대체하여 사용 B
                        WHERE A.DIVISION_ID = UPPER(SA.P_DIVISION_ID)
                          AND A.BIZ_TYPE = UPPER(SA.P_OPERATION_GROUP)
                          AND A.ITEM_ID = UPPER(SA.P_ITEM_ID)
                          AND UPPER(A.TO_SITE) = UPPER(SA.P_TO_SITE)
                          AND A.FROM_SITE = UPPER(SA.P_FROM_SITE)
                          AND UPPER(NVL(A.PROJECT_CODE, '-')) = UPPER(NVL(SA.P_PROJECT_CODE, '-'))
                          AND NVL(A.INCOTERMS, '-') = UPPER(NVL(SA.P_INCOTERMS, '-'))
                          AND A.BOD_ID = UPPER(SA.P_BOD_ID)
                          AND A.YYYYMMDD = SA.P_YYYYMMDD
                          AND NVL(A.ORIGIN_FROM_DIVISION_ID, '-') = UPPER(NVL(SA.P_ORIGIN_FROM_DIVISION_ID, '-'))
                          AND NVL(A.ORIGIN_TO_DIVISION_ID, '-') = UPPER(NVL(SA.P_ORIGIN_TO_DIVISION_ID, '-'))
                          AND NVL(A.ELECTRODE_TYPE, '-') = UPPER(NVL(SA.P_ELECTRODE_TYPE, '-'))
                          AND UPPER(SA.P_ACTIVE_FLAG) = 'D');

        V_EXEC_TIME := LPAD(TO_CHAR(TRUNC(((SYSDATE - V_START_TIME) * 86400) / 60)), 2, '0')
                    || ':'
                    || LPAD(TO_CHAR(MOD(TRUNC((SYSDATE - V_START_TIME) * 86400), 60)), 2, '0');

        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := '[' || V_EXEC_TIME || ']';
        V_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, V_N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, V_EVENT_DATE);

        COMMIT;

        -- 결과코드, 결과 카운트 반환
        OPEN O_RESULT_CURSOR FOR
            SELECT 'S'            AS RESULT_CODE
                 , V_MAX_LOOP_CNT AS RESULT_CNT
                 , '0'            AS CODE
                 , 'SUCCESS'      AS MSG
              FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            /* SQLCODE · SQLERRM 은 SQL 문 안에서 바로 쓸 수 없으므로 변수로 받는다 */
            V_ERR_CODE    := TO_CHAR(SQLCODE);
            V_ERR_MESSAGE := SUBSTR(SQLERRM, 1, 4000);

            INSERT INTO SCM_SYS_LOG_BATCH
                 (
                   PROGRAM_NAME
                 , LOG_TYPE
                 , LOG_COUNT
                 , LOG_MESSAGE
                 , DESCRIPTION
                 , EVENT_DATE
                 , CREATION_DATE
                 , CREATED_BY
                 , LAST_UPDATE_DATE
                 , LAST_UPDATED_BY
                 )
            VALUES
                 (
                   V_PROGRAM_NAME
                 , 'ERROR'
                 , NULL
                 , V_ERR_MESSAGE
                 , NULL
                 , SYSDATE
                 , SYSDATE
                 , V_PROGRAM_NAME
                 , SYSDATE
                 , V_PROGRAM_NAME
                 );

            /* IF @@TRANCOUNT > 0 COMMIT WORK - 실패한 문장 이전 반영분 유지 */
            COMMIT;

            -- error코드, errror 메시지 반환
            OPEN O_RESULT_CURSOR FOR
                SELECT 'F'                                        AS RESULT_CODE
                     , '[' || V_ERR_CODE || ']' || V_ERR_MESSAGE  AS ERR_MESSAGE
                     , '-1'                                       AS CODE
                     , '[' || V_ERR_CODE || ']' || V_ERR_MESSAGE  AS MSG
                  FROM DUAL;
    END P_SCP0025_SAVE_FIX_DATASET;

END PKG_SCP0025;