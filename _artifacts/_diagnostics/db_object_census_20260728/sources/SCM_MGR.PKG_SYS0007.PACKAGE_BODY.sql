PACKAGE BODY           "PKG_SYS0007"
AS

	PROCEDURE SYS0007_GET_MAIN_DATA (
	    P_GR_CTN       	IN      VARCHAR2,
	    P_USE_YN		IN		VARCHAR2,
	    O_CURSOR        OUT     SYS_REFCURSOR,
		O_RESULT_CURSOR	OUT		SYS_REFCURSOR
	) IS
	BEGIN

		OPEN O_CURSOR FOR
			SELECT	G.USER_GR_ID
				  , G.USER_GR_NM
				  , G.USE_YN
				  , G.CREATED_BY
				  , G.CREATION_DATE
				  , G.LAST_UPDATED_BY
				  , G.LAST_UPDATE_DATE
			FROM	SCM_ADM_USER_GR_M G
			WHERE	(P_GR_CTN IS NULL OR (UPPER(G.USER_GR_ID) LIKE UPPER('%' || P_GR_CTN || '%')) OR
					 (UPPER(G.USER_GR_NM) LIKE UPPER('%' || P_GR_CTN || '%')))
			AND		(P_USE_YN = 'ALL' OR G.USE_YN = P_USE_YN)
			ORDER BY G.USER_GR_ID
			;

		OPEN O_RESULT_CURSOR FOR
			SELECT '0' AS CODE, 'SUCCESS' AS MSG, '0' AS EVENT FROM DUAL;

		EXCEPTION
		    WHEN OTHERS THEN
		        RAISE_APPLICATION_ERROR(-20001,
		        '[' || $$PLSQL_UNIT || '] SQLCODE=' || TO_CHAR(SQLCODE) ||
		        ' / SQLERRM=' || SQLERRM ||
		        ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
		        ' / PARAMS=' || '-' );

	END SYS0007_GET_MAIN_DATA;

	PROCEDURE SYS0007_SAVE_MAIN_DATA(
		P_DATA			IN 		CLOB,
		P_USER_ID		IN 		VARCHAR2,
		O_RESULT_CURSOR		OUT		SYS_REFCURSOR
	) IS
		V_ERR_MSG 	VARCHAR2(4000);
		V_ROW_CNT	NUMBER := 0;
	BEGIN

		DELETE
		FROM	SCM_ADM_USER_GR_M
        WHERE	USER_GR_ID IN (
			SELECT V_USER_GR_ID
            FROM JSON_TABLE(P_DATA, '$[*]'
                COLUMNS (
                    V_CRUD_TYPE 	VARCHAR2(20)  PATH '$.CRUD_TYPE',
                    V_USER_GR_ID    VARCHAR2(200) PATH '$.USER_GR_ID'
                ))
			WHERE V_CRUD_TYPE = 'D'
        );

		V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;

		MERGE INTO SCM_ADM_USER_GR_M T
        USING (
			SELECT
                V_CRUD_TYPE 	AS CRUD_TYPE,
                V_USER_GR_ID    AS USER_GR_ID,
                V_USER_GR_NM    AS USER_GR_NM,
                V_USE_YN    	AS USE_YN
            FROM JSON_TABLE(P_DATA, '$[*]'
                COLUMNS (
                    V_CRUD_TYPE 	VARCHAR2(20)  PATH '$.CRUD_TYPE',
                    V_USER_GR_ID    VARCHAR2(200) PATH '$.USER_GR_ID',
                    V_USER_GR_NM    VARCHAR2(200) PATH '$.USER_GR_NM',
                    V_USE_YN    	VARCHAR2(1)   PATH '$.USE_YN'
                ))
			WHERE V_CRUD_TYPE IN ('I', 'M')
        ) M
        ON (T.USER_GR_ID = M.USER_GR_ID AND M.CRUD_TYPE = 'M')
        WHEN MATCHED THEN
            UPDATE SET	T.USER_GR_NM 		= M.USER_GR_NM
            		  , T.USE_YN			= M.USE_YN
            		  , T.LAST_UPDATED_BY 	= P_USER_ID
            		  , T.LAST_UPDATE_DATE 	= SYSDATE
        WHEN NOT MATCHED THEN
            INSERT (USER_GR_ID
            	  , USER_GR_NM
            	  , USE_YN
            	  , CREATED_BY
            	  , CREATION_DATE
            	  , LAST_UPDATED_BY
            	  , LAST_UPDATE_DATE)
            VALUES (M.USER_GR_ID
           	 	  , M.USER_GR_NM
           	 	  , M.USE_YN
           	 	  , P_USER_ID
           	 	  , SYSDATE
           	 	  , P_USER_ID
           	 	  , SYSDATE)
	    ;

		V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;

		COMMIT;

	    OPEN O_RESULT_CURSOR FOR
	         SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;

		EXCEPTION
		    WHEN OTHERS THEN
		        ROLLBACK;

				IF SQLCODE = -1 THEN
		            V_ERR_MSG := 'Duplicate key error.';
	           	    OPEN O_RESULT_CURSOR FOR
			            SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;
        		ELSIF SQLCODE = -1400 THEN
   		            V_ERR_MSG := 'Required value is missing.';
	           	    OPEN O_RESULT_CURSOR FOR
			            SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;
        		ELSIF SQLCODE = -12899 THEN
		            V_ERR_MSG := 'Maximum data size exceeded.';
	           	    OPEN O_RESULT_CURSOR FOR
			            SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;
        		ELSE
			        RAISE_APPLICATION_ERROR(-20001,
			        '[' || $$PLSQL_UNIT || '] SQLCODE=' || TO_CHAR(SQLCODE) ||
			        ' / SQLERRM=' || SQLERRM ||
			        ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
			        ' / PARAMS=' || '-' );
        		END IF;

	END SYS0007_SAVE_MAIN_DATA;

END PKG_SYS0007;