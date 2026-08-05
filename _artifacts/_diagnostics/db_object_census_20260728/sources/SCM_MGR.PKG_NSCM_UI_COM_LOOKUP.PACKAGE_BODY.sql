PACKAGE BODY           "PKG_NSCM_UI_COM_LOOKUP"
AS

    PROCEDURE PR_GET_LOOKUP_INFO_LIST (
                                        P_LOOKUP_TYPE	IN 		VARCHAR2,
                                        O_CURSOR		  OUT		SYS_REFCURSOR
                                      )
    AS
    --------------------------------------------------------------
        V_MASTER_CNT	INT := 0;
        V_SQL    VARCHAR2(8000);
        V_COLS   VARCHAR2(4000);
        V_SELECT_COLS VARCHAR2(4000); -- 최종 SELECT할 컬럼 리스트
        --------------------------------------------------------------
        V_ERR_CODE  NUMBER;
        V_ERR_MSG   VARCHAR2(4000);
    --------------------------------------------------------------
		BEGIN

          -- LOOKUP TABLE

          -- 0. validation
          SELECT  COUNT(1)
            INTO  V_MASTER_CNT
            FROM  SCM_ADM_LOOKUP_MASTER
           WHERE  LOOKUP_TYPE = P_LOOKUP_TYPE;

          IF(V_MASTER_CNT <> 1) THEN
            RAISE_APPLICATION_ERROR(-20002, 'Error: LOOKUP_TYPE [' || P_LOOKUP_TYPE || '] is not valid type.');
          END IF;
          -- 0. validation End

          -- 1. 조회 컬럼
            SELECT
                LISTAGG('''' || HEADER_VAL || ''' AS "' || HEADER_VAL || '"', ', ') WITHIN GROUP (ORDER BY MIN_LVL),
                LISTAGG('"' || HEADER_VAL || '"', ', ') WITHIN GROUP (ORDER BY MIN_LVL)
            INTO V_COLS, V_SELECT_COLS
            FROM (
            	SELECT HEADER_VAL, MIN(LVL) MIN_LVL
    			FROM (
	                SELECT SEGMENT1 AS HEADER_VAL, 1 AS LVL FROM SCM_ADM_LOOKUP_MASTER WHERE LOOKUP_TYPE = P_LOOKUP_TYPE AND SEGMENT1 IS NOT NULL AND SEGMENT1 <> '-'
	                UNION ALL
	                SELECT SEGMENT2, 2 FROM SCM_ADM_LOOKUP_MASTER WHERE LOOKUP_TYPE = P_LOOKUP_TYPE AND SEGMENT2 IS NOT NULL AND SEGMENT2 <> '-'
	                UNION ALL
	                SELECT SEGMENT3, 3 FROM SCM_ADM_LOOKUP_MASTER WHERE LOOKUP_TYPE = P_LOOKUP_TYPE AND SEGMENT3 IS NOT NULL AND SEGMENT3 <> '-'
	                UNION ALL
	                SELECT SEGMENT4, 4 FROM SCM_ADM_LOOKUP_MASTER WHERE LOOKUP_TYPE = P_LOOKUP_TYPE AND SEGMENT4 IS NOT NULL AND SEGMENT4 <> '-'
	                UNION ALL
	                SELECT SEGMENT5, 5 FROM SCM_ADM_LOOKUP_MASTER WHERE LOOKUP_TYPE = P_LOOKUP_TYPE AND SEGMENT5 IS NOT NULL AND SEGMENT5 <> '-'
	                UNION ALL
	                SELECT ATTRIBUTE1, 6 FROM SCM_ADM_LOOKUP_MASTER WHERE LOOKUP_TYPE = P_LOOKUP_TYPE AND ATTRIBUTE1 IS NOT NULL AND ATTRIBUTE1 <> '-'
	                UNION ALL
	                SELECT ATTRIBUTE2, 7 FROM SCM_ADM_LOOKUP_MASTER WHERE LOOKUP_TYPE = P_LOOKUP_TYPE AND ATTRIBUTE2 IS NOT NULL AND ATTRIBUTE2 <> '-'
	                UNION ALL
	                SELECT ATTRIBUTE3, 8 FROM SCM_ADM_LOOKUP_MASTER WHERE LOOKUP_TYPE = P_LOOKUP_TYPE AND ATTRIBUTE3 IS NOT NULL AND ATTRIBUTE3 <> '-'
	                UNION ALL
	                SELECT ATTRIBUTE4, 9 FROM SCM_ADM_LOOKUP_MASTER WHERE LOOKUP_TYPE = P_LOOKUP_TYPE AND ATTRIBUTE4 IS NOT NULL AND ATTRIBUTE4 <> '-'
	                UNION ALL
	                SELECT ATTRIBUTE5, 10 FROM SCM_ADM_LOOKUP_MASTER WHERE LOOKUP_TYPE = P_LOOKUP_TYPE AND ATTRIBUTE5 IS NOT NULL AND ATTRIBUTE5 <> '-'
	                UNION ALL
	                SELECT ATTRIBUTE6, 11 FROM SCM_ADM_LOOKUP_MASTER WHERE LOOKUP_TYPE = P_LOOKUP_TYPE AND ATTRIBUTE6 IS NOT NULL AND ATTRIBUTE6 <> '-'
	                UNION ALL
	                SELECT ATTRIBUTE7, 12 FROM SCM_ADM_LOOKUP_MASTER WHERE LOOKUP_TYPE = P_LOOKUP_TYPE AND ATTRIBUTE7 IS NOT NULL AND ATTRIBUTE7 <> '-'
	                UNION ALL
	                SELECT ATTRIBUTE8, 13 FROM SCM_ADM_LOOKUP_MASTER WHERE LOOKUP_TYPE = P_LOOKUP_TYPE AND ATTRIBUTE8 IS NOT NULL AND ATTRIBUTE8 <> '-'
	                UNION ALL
	                SELECT ATTRIBUTE9, 14 FROM SCM_ADM_LOOKUP_MASTER WHERE LOOKUP_TYPE = P_LOOKUP_TYPE AND ATTRIBUTE9 IS NOT NULL AND ATTRIBUTE9 <> '-'
	                UNION ALL
	                SELECT ATTRIBUTE10, 15 FROM SCM_ADM_LOOKUP_MASTER WHERE LOOKUP_TYPE = P_LOOKUP_TYPE AND ATTRIBUTE10 IS NOT NULL AND ATTRIBUTE10 <> '-'
	                UNION ALL
	                SELECT ATTRIBUTE11, 16 FROM SCM_ADM_LOOKUP_MASTER WHERE LOOKUP_TYPE = P_LOOKUP_TYPE AND ATTRIBUTE11 IS NOT NULL AND ATTRIBUTE11 <> '-'
	                UNION ALL
	                SELECT ATTRIBUTE12, 17 FROM SCM_ADM_LOOKUP_MASTER WHERE LOOKUP_TYPE = P_LOOKUP_TYPE AND ATTRIBUTE12 IS NOT NULL AND ATTRIBUTE12 <> '-'
	                UNION ALL
	                SELECT ATTRIBUTE13, 18 FROM SCM_ADM_LOOKUP_MASTER WHERE LOOKUP_TYPE = P_LOOKUP_TYPE AND ATTRIBUTE13 IS NOT NULL AND ATTRIBUTE13 <> '-'
	                UNION ALL
	                SELECT ATTRIBUTE14, 19 FROM SCM_ADM_LOOKUP_MASTER WHERE LOOKUP_TYPE = P_LOOKUP_TYPE AND ATTRIBUTE14 IS NOT NULL AND ATTRIBUTE14 <> '-'
	                UNION ALL
	                SELECT ATTRIBUTE15, 20 FROM SCM_ADM_LOOKUP_MASTER WHERE LOOKUP_TYPE = P_LOOKUP_TYPE AND ATTRIBUTE15 IS NOT NULL AND ATTRIBUTE15 <> '-'
	            )
    			GROUP BY HEADER_VAL
            );

  --			   DBMS_OUTPUT.PUT_LINE('COLS>>>>  '||V_SELECT_COLS);

            -- 2. 동적 SQL 조립
            -- 가장 바깥쪽 SELECT에서 LOOKUP_TYPE과 동적 컬럼들만 지정하여 ROW_IDENTIFIER를 제거합니다.
            V_SQL := 'SELECT LOOKUP_TYPE, ' || V_SELECT_COLS || ' FROM (
                        SELECT * FROM (
                            SELECT
                                LOOKUP_TYPE, ROW_IDENTIFIER, M_VAL AS COL_HEADER, D_VAL AS DATA_VALUE
                            FROM (
                                SELECT
                                    SALD.LOOKUP_TYPE,
                                    SALD.ROWID AS ROW_IDENTIFIER,
                                    SALM.SEGMENT1 AS M1, SALM.SEGMENT2 AS M2, SALM.SEGMENT3 AS M3, SALM.SEGMENT4 AS M4, SALM.SEGMENT5 AS M5,
                                    SALD.SEGMENT1 AS D1, SALD.SEGMENT2 AS D2, SALD.SEGMENT3 AS D3, SALD.SEGMENT4 AS D4, SALD.SEGMENT5 AS D5,
                      SALM.ATTRIBUTE1 AS M6, SALM.ATTRIBUTE2 AS M7, SALM.ATTRIBUTE3 AS M8, SALM.ATTRIBUTE4 AS M9, SALM.ATTRIBUTE5 AS M10,
                                    SALD.ATTRIBUTE1 AS D6, SALD.ATTRIBUTE2 AS D7, SALD.ATTRIBUTE3 AS D8, SALD.ATTRIBUTE4 AS D9, SALD.ATTRIBUTE5 AS D10,
                      SALM.ATTRIBUTE6 AS M11, SALM.ATTRIBUTE7 AS M12, SALM.ATTRIBUTE8 AS M13, SALM.ATTRIBUTE9 AS M14, SALM.ATTRIBUTE10 AS M15,
                                    SALD.ATTRIBUTE6 AS D11, SALD.ATTRIBUTE7 AS D12, SALD.ATTRIBUTE8 AS D13, SALD.ATTRIBUTE9 AS D14, SALD.ATTRIBUTE10 AS D15,
                      SALM.ATTRIBUTE11 AS M16, SALM.ATTRIBUTE12 AS M17, SALM.ATTRIBUTE13 AS M18, SALM.ATTRIBUTE14 AS M19, SALM.ATTRIBUTE15 AS M20,
                                    SALD.ATTRIBUTE11 AS D16, SALD.ATTRIBUTE12 AS D17, SALD.ATTRIBUTE13 AS D18, SALD.ATTRIBUTE14 AS D19, SALD.ATTRIBUTE15 AS D20
                                FROM SCM_ADM_LOOKUP_MASTER SALM
                                JOIN SCM_ADM_LOOKUP_MASTER_DETAIL SALD ON SALM.LOOKUP_TYPE = SALD.LOOKUP_TYPE
                                WHERE SALM.VALID_YN = ''Y'' AND SALD.VALID_YN = ''Y''
								  AND SALM.LOOKUP_TYPE = ''' || P_LOOKUP_TYPE || '''
                            )
                            UNPIVOT (
                                (M_VAL, D_VAL) FOR LVL IN (
                                    (M1, D1) AS 1, (M2, D2) AS 2, (M3, D3) AS 3, (M4, D4) AS 4, (M5, D5) AS 5,
                      (M6, D6) AS 6, (M7, D7) AS 7, (M8, D8) AS 8, (M9, D9) AS 9, (M10, D10) AS 10,
                      (M11, D11) AS 11, (M12, D12) AS 12, (M13, D13) AS 13, (M14, D14) AS 14, (M15, D15) AS 15,
                      (M16, D16) AS 16, (M17, D17) AS 17, (M18, D18) AS 18, (M19, D19) AS 19, (M20, D20) AS 20
                                )
                            )
                            WHERE M_VAL <> ''-''
                        )
                        PIVOT (
                            MAX(DATA_VALUE)
                            FOR COL_HEADER IN (' || V_COLS || ')
                        )
                )';
		--	              ) ORDER BY 1'; -- 첫 번째 컬럼(LOOKUP_TYPE) 기준으로 정렬

                -- 2. SORT_ORD 존재 여부에 따른 ORDER BY 추가 로직
				-- V_COLS 문자열 안에 'SORT_ORD'라는 단어가 있는지 확인합니다.
				IF INSTR(V_COLS, '''SORT_ORD''') > 0 THEN
				    -- SORT_ORD 컬럼이 PIVOT 리스트에 있다면 해당 컬럼으로 정렬
				    V_SQL := V_SQL || ' ORDER BY TO_NUMBER("SORT_ORD") ASC';
				ELSE
				    -- 없다면 기본값인 첫 번째 컬럼(LOOKUP_TYPE)으로 정렬
				    V_SQL := V_SQL || ' ORDER BY 1';
				END IF;
							    -- 디버깅용 쿼리 출력
			    DBMS_OUTPUT.PUT_LINE(V_SQL);

			    -- 3. 커서 오픈
			    OPEN O_CURSOR FOR V_SQL;


		--------------------------------------------------------------
		EXCEPTION
    --------------------------------------------------------------
		    WHEN OTHERS THEN
		    	V_ERR_CODE := SQLCODE;
		        V_ERR_MSG := REPLACE(V_ERR_MSG, CHR(10), SQLERRM);
--	        	V_ERR_MSG := REPLACE(V_ERR_MSG, CHR(13), '');
	        	RAISE_APPLICATION_ERROR(V_ERR_CODE, V_ERR_MSG);
    --------------------------------------------------------------
		END;
--------------------------------------------------------------
END PKG_NSCM_UI_COM_LOOKUP;