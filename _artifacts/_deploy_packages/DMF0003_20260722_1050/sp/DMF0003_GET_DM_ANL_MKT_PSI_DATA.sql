CREATE OR REPLACE PROCEDURE           "DMF0003_GET_DM_ANL_MKT_PSI_DATA" (
	 p_division_id IN VARCHAR2
	,p_project_code IN VARCHAR2
	,p_project_name IN VARCHAR2
	,p_yyyymm IN VARCHAR2
	,p_created_by IN VARCHAR2
	,p_end_customer IN VARCHAR2
	,O_RESULT_CURSOR OUT SYS_REFCURSOR
)
AS
	v_CNT NUMBER(10) := 0;
	v_i NUMBER(10) := 1;
	v_CUST_FCST_M NUMBER(20, 10);
	v_MKT_FCST_S NUMBER(20, 10);
	v_MKT_FCST_R NUMBER(20, 10);
	v_DP_RESULT_SUM NUMBER(20, 10);
	v_DP_RESULT_P NUMBER(20, 10);
	v_DP_RESULT_S NUMBER(20, 10);
	v_DP_RESULT_I NUMBER(20, 10);
	v_DP_RESULT_V NUMBER(20, 10);
	v_DP_RESULT_M NUMBER(20, 10);
	v_DP_RESULT_CP NUMBER(20, 10);
	v_EDI_SUM NUMBER(20, 10);
	v_DP_ANL_SUM NUMBER(20, 10);
	v_DP_ANL_P NUMBER(20, 10);
	v_DP_ANL_S NUMBER(20, 10);
	v_DP_ANL_I NUMBER(20, 10);
	v_DP_ANL_V NUMBER(20, 10);
	v_DP_ANL_M NUMBER(20, 10);
	v_DP_ANL_CP NUMBER(20, 10);
	v_DP_ANL_CPI NUMBER(20, 10);
	v_0month_tuesday VARCHAR2(08);
	v_0month VARCHAR2(6);
	v_1month VARCHAR2(6);

BEGIN

	v_0month := TO_CHAR(SYSTIMESTAMP, 'YYYYMM'); --M0 당월
	v_1month := TO_CHAR(ADD_MONTHS(SYSTIMESTAMP, -1), 'YYYYMM'); --M-1 전월
	v_i := -12;

	EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GTT_TMP_DM_ANL_MKT_PSI_DATA';
	EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GTT_TMP_DM_MST_VERSION';
	EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GTT_TMP_PROJECT_CODE';

	BEGIN
		INSERT INTO GTT_TMP_PROJECT_CODE (PROJECT_CODE)
		SELECT
			PROJECT_CODE
		FROM SCM_MST_PROJECT
		WHERE DIVISION_ID = p_division_id
		AND PROJECT_NAME = p_project_name;
	END;


	BEGIN
		-- 월의 첫날이 수요일인 경우 전달의 마지막 MKT_FCST CUTOFF 일자를 사용한다.
		IF TO_CHAR(SYSDATE, 'D') = '4'
		THEN
			v_0month_tuesday := TO_CHAR(FN_NEXT_DAY(TO_CHAR(SYSDATE, 'YYYYMM') || '01', 'TUE') - 7, 'YYYYMMDD');
		ELSE
				--당월 첫번째 수요일이 포함된 주차의 MKT_FCST Cutoff
			v_0month_tuesday := TO_CHAR(FN_NEXT_DAY(TRUNC(SYSDATE, 'MM') - 1, 'WED') - 1,'YYYYMMDD');
		END IF;

		BEGIN
			INSERT INTO SCM_MGR.GTT_TMP_DM_MST_VERSION (
				NUM
				,VERSION_NO
				,VERSION_TYPE
				)
			SELECT
				ROW_NUMBER() OVER(ORDER BY X.VERSION_NO) AS NUM
				,X.VERSION_NO
				,X.VERSION_TYPE
			FROM (
				SELECT
					ROW_NUMBER() OVER (PARTITION BY A.VERSION_TYPE ORDER BY A.VERSION_NO DESC) AS RNK
					,A.VERSION_NO
					,A.VERSION_TYPE
				FROM DM_MST_VERSION A
				JOIN SCM_SYS_CALENDAR_M B ON A.YYYYMMDD = B.BASIS_YYYYMMDD
				WHERE 1 = 1
				AND A.DIVISION_ID = p_division_id
				AND A.VERSION_TYPE = 'MF_W'
				AND A.YYYYMMDD = v_0month_tuesday
			) X
			WHERE RNK = 1;
		END;

		--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')------------------------------------------------------------------------------------------------
		BEGIN
	    	EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GTT_TMP_DM_MST_ITEM_SINGLE_V';

			INSERT INTO GTT_TMP_DM_MST_ITEM_SINGLE_V (
				DIVISION_ID
				,ITEM_ID
				,ITEM_NAME
				,ITEM_CLASS
				,ITEM_CLASS_NAME
				,NICK_NAME
				,ITEM_TYPE
				,MATERIAL_CLASS_NAME
				,ITEM_UOM
				,SPEC
				,MDM_PROJECT_NAME
				,MIN_CAPACITY
				,FORECAST_INFO_BIZ_TYPE
				,FORECAST_INFO_PRODUCT_GROUP
				,FORECAST_INFO_CELL_MODEL
				,FORECAST_INFO_CELL_PACK_COUNT
				,FORECAST_INFO_SPEC
				,FORECAST_INFOR_VERSION
				,ACTIVE_FLAG
				,CELL_TYPE
				,ENERGE
				,CELL_QUANTITY
				,SCP_EXTRA_SPEC
			)
			SELECT
				DIVISION_ID
				,ITEM_ID
				,ITEM_NAME
				,ITEM_CLASS
				,ITEM_CLASS_NAME
				,NICK_NAME
				,ITEM_TYPE
				,MATERIAL_CLASS_NAME
				,ITEM_UOM
				,SPEC
				,MDM_PROJECT_NAME
				,MIN_CAPACITY
				,FORECAST_INFO_BIZ_TYPE
				,FORECAST_INFO_PRODUCT_GROUP
				,FORECAST_INFO_CELL_MODEL
				,FORECAST_INFO_CELL_PACK_COUNT
				,FORECAST_INFO_SPEC
				,FORECAST_INFOR_VERSION
				,ACTIVE_FLAG
				,CELL_TYPE
				,ENERGE
				,CELL_QUANTITY
				,SCP_EXTRA_SPEC
			FROM DM_MST_ITEM_SINGLE_V
			WHERE DIVISION_ID = p_division_id
			AND ITEM_ID IN (
				SELECT ITEM_ID
				FROM SCM_MST_PROJECT_ITEM
				WHERE PROJECT_CODE = p_project_code
				AND VALID_YN = 'Y'
			)
			AND ITEM_TYPE = 'P'
			AND ACTIVE_FLAG = 'Y';
		END;

		--SCM_MST_SITE 대상건만 추출
		BEGIN
        	EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GTT_TMP_SCM_MST_SITE';

			INSERT INTO GTT_TMP_SCM_MST_SITE (
				DIVISION_ID
			    ,SCM_SITE_ID
				,END_CUSTOMER
			)
			SELECT
				DIVISION_ID
			    ,SCM_SITE_ID
				,END_CUSTOMER
			FROM SCM_MGR.SCM_MST_SITE
			WHERE DIVISION_ID  = p_division_id
	          AND END_CUSTOMER = p_end_customer;
		END;
	END;

	BEGIN
		MERGE INTO SCM_MGR.DM_ANL_MKT_PSI T1
		USING (
			SELECT
				X.DIVISION_ID
				,H.END_CUSTOMER
				,X.PROJECT_CODE
				,SUBSTR(X.YYYYMMDD, 1, 6) AS YYYYMM
				,NVL(CEIL(SUM(X.QTY)), 0) AS A_QTY
			FROM DM_PLN_MKT_FCST_RESULT X
			INNER JOIN SCM_MST_SITE_ITEM F
				ON F.DIVISION_ID = X.DIVISION_ID
				AND F.PROJECT_CODE = X.PROJECT_CODE
				AND F.SCM_SITE_ID = X.SCM_SITE_ID
				AND F.ITEM_ID = X.ITEM_ID
			INNER JOIN GTT_TMP_SCM_MST_SITE H
				ON F.DIVISION_ID = H.DIVISION_ID
				AND F.SCM_SITE_ID = H.SCM_SITE_ID
			INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL G
				ON G.SEGMENT1 = X.FCST_TYPE
				AND G.LOOKUP_TYPE = X.FCST_TYPE
			WHERE X.DIVISION_ID = p_division_id
			AND X.PROJECT_CODE = p_project_code
			AND X.MEASURE = 'RTF_SYS_RP'
			-- 날짜 계산: 파라미터가 '202310' 형태라고 가정할 때 12개월전~1개월 전 계산
			AND SUBSTR(X.YYYYMMDD, 1, 6) >= TO_CHAR(ADD_MONTHS(TO_DATE(p_yyyymm || '01', 'YYYYMMDD'), -12), 'YYYYMM')
			AND SUBSTR(X.YYYYMMDD, 1, 6) <= TO_CHAR(ADD_MONTHS(TO_DATE(p_yyyymm || '01', 'YYYYMMDD'), -1), 'YYYYMM')
			GROUP BY
				X.DIVISION_ID
				,H.END_CUSTOMER
				,X.PROJECT_CODE
				,SUBSTR(X.YYYYMMDD, 1, 6)
		) T2
		ON (
			T1.DIVISION_ID = T2.DIVISION_ID
			AND T1.PROJECT_CODE = T2.PROJECT_CODE
			AND T1.END_CUSTOMER = T2.END_CUSTOMER
			AND T1.YYYYMM = T2.YYYYMM
			AND T1.MEASURE = 'DP_RESULT'
		)
		WHEN MATCHED THEN UPDATE SET T1.MKT_FCST_M = T2.A_QTY;
	END;

	WHILE v_i <= 0
	LOOP
		BEGIN
			SELECT COUNT(*) INTO v_CNT
			FROM DM_ANL_MKT_PSI
			WHERE DIVISION_ID = p_division_id
			AND PROJECT_CODE = p_project_code
			AND END_CUSTOMER = p_end_customer
			AND YYYYMM = TO_CHAR(ADD_MONTHS(TO_DATE(p_yyyymm, 'YYYYMM'), v_i), 'YYYYMM');
		END;

		BEGIN
			IF v_0month_tuesday <= TO_CHAR(SYSTIMESTAMP, 'YYYYMMDD')
			THEN
				--고객수요계획
				BEGIN
					IF TO_CHAR(ADD_MONTHS(TO_DATE(p_yyyymm || '01', 'YYYYMMDD'), v_i), 'YYYYMM') = v_0month
					THEN
						SELECT (A_QTY + B_QTY)
						INTO v_CUST_FCST_M
						FROM (
							SELECT
								NVL(CEIL(SUM(X.QTY)), 0) AS A_QTY
							FROM DM_PLN_MKT_FCST_C X
							JOIN GTT_TMP_DM_MST_VERSION Y
								ON X.VERSION_NO = Y.VERSION_NO
							JOIN GTT_TMP_SCM_MST_SITE Z
								ON X.DIVISION_ID = Z.DIVISION_ID
								AND X.SCM_SITE_ID = Z.SCM_SITE_ID
							WHERE X.DIVISION_ID = p_division_id
							AND X.MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST')
							AND X.PROJECT_CODE = p_project_code
							AND X.ITEM_ID IN (SELECT ITEM_ID FROM GTT_TMP_DM_MST_ITEM_SINGLE_V)
							AND X.FCST_TYPE = 'MPS'
							AND SUBSTR(X.YYYYMMDD, 1, 6) = p_yyyymm
							AND X.QTY <> 0
						) A
						,(
							SELECT NVL(CEIL(SUM(X.QTY)), 0) AS B_QTY
							FROM DM_PLN_MKT_FCST_RESULT_C X
							JOIN GTT_TMP_DM_MST_VERSION Y ON X.VERSION_NO = Y.VERSION_NO
							JOIN GTT_TMP_SCM_MST_SITE Z
						     	ON X.DIVISION_ID = Z.DIVISION_ID AND  X.SCM_SITE_ID = Z.SCM_SITE_ID
							WHERE X.DIVISION_ID = p_division_id
							AND X.MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST')
							AND X.PROJECT_CODE = p_project_code
							AND X.ITEM_ID IN (SELECT ITEM_ID FROM GTT_TMP_DM_MST_ITEM_SINGLE_V)
							AND X.FCST_TYPE = 'MPS'
							AND SUBSTR(X.YYYYMMDD, 1, 6) = p_yyyymm
						) B;
					ELSE
						v_CUST_FCST_M := 0;
					END IF;
				END;

				--마케팅수요계획
				BEGIN
					IF TO_CHAR(ADD_MONTHS(TO_DATE(p_yyyymm || '01', 'YYYYMMDD'), v_i), 'YYYYMM') = v_0month
					THEN
						--수요계획(1st)
						SELECT (A_QTY + B_QTY) INTO v_MKT_FCST_S
						FROM (
							SELECT NVL(CEIL(SUM(X.QTY)), 0) AS A_QTY
							FROM DM_PLN_MKT_FCST_C X
							JOIN GTT_TMP_DM_MST_VERSION Y
								ON X.VERSION_NO = Y.VERSION_NO
							JOIN GTT_TMP_SCM_MST_SITE Z
								ON X.DIVISION_ID = Z.DIVISION_ID
								AND  X.SCM_SITE_ID = Z.SCM_SITE_ID
							WHERE X.DIVISION_ID = p_division_id
							AND X.MEASURE = 'RTF_SYS_RP'
							AND X.PROJECT_CODE = p_project_code
							AND X.ITEM_ID IN (SELECT ITEM_ID FROM GTT_TMP_DM_MST_ITEM_SINGLE_V)
							AND X.FCST_TYPE = 'MPS'
							AND SUBSTR(X.YYYYMMDD, 1, 6) = p_yyyymm
							AND X.QTY <> 0
						) A
						,(
							SELECT NVL(CEIL(SUM(X.QTY)), 0) AS B_QTY
							FROM DM_PLN_MKT_FCST_RESULT_C X
							JOIN GTT_TMP_DM_MST_VERSION Y
								ON X.VERSION_NO = Y.VERSION_NO
							JOIN GTT_TMP_SCM_MST_SITE Z
							    ON X.DIVISION_ID = Z.DIVISION_ID
								AND  X.SCM_SITE_ID = Z.SCM_SITE_ID
							WHERE X.DIVISION_ID = p_division_id
							AND X.MEASURE = 'RTF_SYS_RP'
							AND X.PROJECT_CODE = p_project_code
							AND X.ITEM_ID IN (SELECT ITEM_ID FROM GTT_TMP_DM_MST_ITEM_SINGLE_V)
							AND X.FCST_TYPE = 'MPS'
							AND SUBSTR(X.YYYYMMDD, 1, 6) = p_yyyymm
						) B;
					ELSE
						v_MKT_FCST_S := 0;
					END IF;
					IF TO_CHAR(ADD_MONTHS(TO_DATE(p_yyyymm || '01', 'YYYYMMDD'), v_i), 'YYYYMM') = v_1month OR v_CNT = 0
					THEN
						--수요계획(result)
						SELECT A.A_QTY INTO v_MKT_FCST_R
						FROM (
							SELECT NVL(CEIL(SUM(QTY)), 0) AS A_QTY
							FROM DM_PLN_MKT_FCST_RESULT X
		                    JOIN SCM_MST_SITE_ITEM F
								ON F.DIVISION_ID = X.DIVISION_ID
								AND F.PROJECT_CODE = X.PROJECT_CODE
			                    AND	F.SCM_SITE_ID = X.SCM_SITE_ID
                                AND	F.ITEM_ID = X.ITEM_ID
							JOIN GTT_TMP_SCM_MST_SITE H
								ON F.DIVISION_ID = H.DIVISION_ID
								AND	F.SCM_SITE_ID = H.SCM_SITE_ID
							JOIN SCM_ADM_LOOKUP_MASTER_DETAIL G
								ON G.SEGMENT1 = X.FCST_TYPE
								AND	G.LOOKUP_TYPE = 'SALES_TYPE_CODE'
							WHERE X.DIVISION_ID = p_division_id
							AND X.MEASURE = 'RTF_SYS_RP'
							AND X.PROJECT_CODE = p_project_code
							AND SUBSTR(X.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(TO_DATE(p_yyyymm || '01', 'YYYYMMDD'), v_i), 'YYYYMM')
						) A;
					ELSE
						v_MKT_FCST_R := 0;
					END IF;
				END;
			ELSE
				v_CUST_FCST_M := 0;
				v_MKT_FCST_S := 0;
				v_MKT_FCST_R := 0;
			END IF;
		END;

		DBMS_OUTPUT.PUT_LINE ('=================================');
		DBMS_OUTPUT.PUT_LINE (p_yyyymm);
		DBMS_OUTPUT.PUT_LINE (v_0month_tuesday);
		DBMS_OUTPUT.PUT_LINE (TO_CHAR (SYSTIMESTAMP, 'YYYYMMDD'));
		DBMS_OUTPUT.PUT_LINE (TO_CHAR(ADD_MONTHS(TO_DATE(p_yyyymm, 'YYYYMM'), v_i), 'YYYYMM'));
		DBMS_OUTPUT.PUT_LINE (v_0month);
		DBMS_OUTPUT.PUT_LINE (v_CNT);
		DBMS_OUTPUT.PUT_LINE ('=================================');

		IF (v_CNT = 0) THEN
			IF v_0month_tuesday <= TO_CHAR(SYSTIMESTAMP, 'YYYYMMDD')
			AND TO_CHAR(ADD_MONTHS(TO_DATE(p_yyyymm || '01' , 'YYYYMMDD'), v_i) , 'YYYYMM') = v_0month
			THEN
				BEGIN
					INSERT INTO SCM_MGR.GTT_TMP_DM_ANL_MKT_PSI_DATA
					SELECT p_division_id
						,p_end_customer
						,p_project_name
						,p_project_code
						,TO_CHAR(ADD_MONTHS(TO_DATE(p_yyyymm || '01', 'YYYYMMDD'), v_i), 'YYYYMM')
						,v_CUST_FCST_M
						,'Average impact(%)'
						,'0%'
						,'0%'
						,'0%'
						,'0%'
						,'0%'
						,'0%'
						,'0%'
						,NULL
						,'1'
					FROM DUAL;
				END;

				BEGIN
					INSERT INTO SCM_MGR.GTT_TMP_DM_ANL_MKT_PSI_DATA
					SELECT p_division_id
						,p_end_customer
						,p_project_name
						,p_project_code
						,TO_CHAR(ADD_MONTHS(TO_DATE(p_yyyymm || '01', 'YYYYMMDD'), v_i) , 'YYYYMM')
						,v_CUST_FCST_M
						,'Simulation (Impact)'
						,0
						,0
						,0
						,0
						,0
						,0
						,0
						,TO_CHAR(0)
						,'2'
					FROM DUAL;
				END;

				BEGIN
					INSERT INTO SCM_MGR.GTT_TMP_DM_ANL_MKT_PSI_DATA
					SELECT p_division_id
						,p_end_customer
						,p_project_name
						,p_project_code
						,TO_CHAR(ADD_MONTHS(TO_DATE(p_yyyymm || '01', 'YYYYMMDD'), v_i), 'YYYYMM')
						,v_CUST_FCST_M
						,'Demand Plan (1st)'
						,0
						,0
						,0
						,0
						,0
						,0
						,0
						,CEIL(TO_NUMBER(v_MKT_FCST_S))
						,'3'
					FROM DUAL;
				END;

				BEGIN
					INSERT INTO SCM_MGR.GTT_TMP_DM_ANL_MKT_PSI_DATA
					SELECT p_division_id
						,p_end_customer
						,p_project_name
						,p_project_code
						,TO_CHAR(ADD_MONTHS(TO_DATE(p_yyyymm || '01', 'YYYYMMDD'), v_i), 'YYYYMM')
						,v_CUST_FCST_M
						,'Demand Plan (final)'
						,0
						,0
						,0
						,0
						,0
						,0
						,0
						,CEIL(TO_NUMBER(v_MKT_FCST_R))
						,'4'
					FROM DUAL;
				END;
			ELSE
				BEGIN
					INSERT INTO SCM_MGR.GTT_TMP_DM_ANL_MKT_PSI_DATA
					SELECT p_division_id
						,p_end_customer
						,p_project_name
						,p_project_code
						,TO_CHAR(ADD_MONTHS(TO_DATE(p_yyyymm || '01', 'YYYYMMDD'), v_i), 'YYYYMM')
						,0
						,'Average impact(%)'
						,'0%'
						,'0%'
						,'0%'
						,'0%'
						,'0%'
						,'0%'
						,'0%'
						,NULL
						,'1' FROM dual;
				END;

				BEGIN
					INSERT INTO SCM_MGR.GTT_TMP_DM_ANL_MKT_PSI_DATA
					SELECT p_division_id
						,p_end_customer
						,p_project_name
						,p_project_code
						,TO_CHAR(ADD_MONTHS(TO_DATE(p_yyyymm || '01', 'YYYYMMDD'), v_i), 'YYYYMM')
						,0
						,'Simulation (Impact)'
						,0
						,0
						,0
						,0
						,0
						,0
						,0
						,0
						,'2'
					FROM DUAL;
				END;

				BEGIN
					INSERT INTO SCM_MGR.GTT_TMP_DM_ANL_MKT_PSI_DATA
					SELECT p_division_id
						,p_end_customer
						,p_project_name
						,p_project_code
						,TO_CHAR(ADD_MONTHS(TO_DATE(p_yyyymm || '01', 'YYYYMMDD'), v_i), 'YYYYMM')
						,0
						,'Demand Plan (1st)'
						,0
						,0
						,0
						,0
						,0
						,0
						,0
						,CEIL(TO_NUMBER(v_MKT_FCST_S))
						,'3'
					FROM DUAL;
				END;

				BEGIN
					INSERT INTO SCM_MGR.GTT_TMP_DM_ANL_MKT_PSI_DATA
					SELECT p_division_id
						,p_end_customer
						,p_project_name
						,p_project_code
						,TO_CHAR(ADD_MONTHS(TO_DATE(p_yyyymm || '01', 'YYYYMMDD'), v_i), 'YYYYMM')
						,0
						,'Demand Plan (final)'
						,0
						,0
						,0
						,0
						,0
						,0
						,0
						,CEIL(TO_NUMBER(v_MKT_FCST_R))
						,'4'
					FROM DUAL;
				END;
			END IF;
		ELSE
			-- 고객수요증감분석 전체조회
			INSERT INTO SCM_MGR.GTT_TMP_DM_ANL_MKT_PSI_DATA
			SELECT T1.DIVISION_ID AS DIVISION_ID
				,p_end_customer
				,p_project_name
				,p_project_code
				,T1.YYYYMM AS YYYYMM
				,(
					CASE
						WHEN NVL(T1.CUST_FCST_M, 0) = 0
							THEN v_CUST_FCST_M
						WHEN v_0month_tuesday <= TO_CHAR (SYSTIMESTAMP, 'YYYYMMDD')
							AND TO_CHAR(ADD_MONTHS(TO_DATE(p_yyyymm || '01', 'YYYYMMDD'), v_i), 'YYYYMM') = v_0month
							THEN v_CUST_FCST_M
						ELSE CEIL(T1.CUST_FCST_M)
					END
				) AS EDI_QTY
				,(
					CASE T1.MEASURE
						WHEN 'AN_LOGIC'
							THEN 'Average impact(%)'
						WHEN 'AN_RESULT'
							THEN 'Simulation (Impact)'
						WHEN 'DP_INIT'
							THEN 'Demand Plan (1st)'
						WHEN 'DP_RESULT'
							THEN 'Demand Plan (final)'
					END
				) AS MEASURE
				,(
					CASE
						WHEN T1.MEASURE = 'AN_LOGIC'
							THEN TO_CHAR(ROUND(T2.VSUM, 2)) || '%'
						ELSE TO_CHAR(CEIL(T2.VSUM), 'FM999,999,999,999,990')
					END
				) AS SUM
				,(
					CASE
						WHEN T1.MEASURE = 'AN_LOGIC'
							THEN TO_CHAR(ROUND(T1.P_VALUE, 2)) || '%'
						ELSE
							TO_CHAR(CEIL(T1.P_VALUE), 'FM999,999,999,999,990')
					END
				) AS PRODUCT
				,(
					CASE
						WHEN T1.MEASURE = 'AN_LOGIC'
							THEN TO_CHAR(ROUND(T1.S_VALUE, 2)) || '%'
						ELSE TO_CHAR(CEIL(T1.S_VALUE), 'FM999,999,999,999,990')
					END
				) AS SALE
				,(
					CASE
						WHEN T1.MEASURE = 'AN_LOGIC'
							THEN TO_CHAR(ROUND(T1.I_VALUE, 2)) || '%'
						ELSE TO_CHAR(CEIL(T1.I_VALUE), 'FM999,999,999,999,990')
					END
				) AS INVENTORY
				,(
					CASE
						WHEN T1.MEASURE = 'AN_LOGIC'
							THEN TO_CHAR(ROUND(T1.V_VALUE, 2)) || '%'
						ELSE TO_CHAR(CEIL(T1.V_VALUE), 'FM999,999,999,999,990')
					END
				) AS TIME_ADJUST
				,(
					CASE
						WHEN T1.MEASURE = 'AN_LOGIC'
							THEN TO_CHAR(ROUND(T1.M_VALUE, 2)) || '%'
						ELSE TO_CHAR(CEIL(T1.M_VALUE), 'FM999,999,999,999,990')
					END
				) AS MODEL_MIX
				,(
					CASE
						WHEN T1.MEASURE = 'AN_LOGIC'
							THEN TO_CHAR(ROUND(NVL(T1.CP_VALUE, 0), 2)) || '%'
						ELSE TO_CHAR(CEIL(NVL(T1.CP_VALUE, 0)), 'FM999,999,999,999,990')
					END
				) AS SUPPLY_ISSUE
				,(
					CASE
						WHEN T1.MEASURE = 'AN_RESULT'
							THEN (
								CASE
									WHEN NVL(T1.MKT_FCST_M, 0) = 0
										THEN 0
									ELSE CEIL(T1.MKT_FCST_M)
								END
							)
						WHEN T1.MEASURE = 'DP_INIT'
							THEN (
								CASE
									WHEN NVL(T1.MKT_FCST_M, 0) = 0
										THEN CEIL(v_MKT_FCST_S)
									WHEN v_0month_tuesday <= TO_CHAR(SYSTIMESTAMP, 'YYYYMMDD')
										AND TO_CHAR(ADD_MONTHS(TO_DATE(p_yyyymm || '01', 'YYYYMMDD'), v_i),'YYYYMM') = v_0month
										THEN CEIL(v_MKT_FCST_S)
									ELSE CEIL(T1.MKT_FCST_M)
								END
							)
						WHEN T1.MEASURE = 'DP_RESULT'
							THEN (
								CASE
									WHEN NVL(T1.MKT_FCST_M, 0) = 0
									THEN CEIL(v_MKT_FCST_R)
									WHEN v_0month_tuesday <= TO_CHAR(SYSTIMESTAMP, 'YYYYMMDD')
										AND TO_CHAR(ADD_MONTHS(TO_DATE(p_yyyymm || '01', 'YYYYMMDD'), v_i),'YYYYMM') = v_0month
										THEN CEIL(v_MKT_FCST_R)
									ELSE CEIL(T1.MKT_FCST_M)
								END
							)
						ELSE NULL
					END
				) AS MKT_DP
				,(
					CASE
						WHEN T1.MEASURE = 'AN_LOGIC'
							THEN '1'
						WHEN T1.MEASURE = 'AN_RESULT'
							THEN '2'
					WHEN T1.MEASURE = 'DP_INIT'
							THEN '3'
						ELSE '4'
					END
				) AS RNK
			FROM DM_ANL_MKT_PSI T1
			LEFT OUTER JOIN (
				SELECT PROJECT_CODE
			      	,END_CUSTOMER
					,YYYYMM
					,MEASURE
					,SUM(VVALUE) AS VSUM
				FROM DM_ANL_MKT_PSI
				UNPIVOT(VVALUE FOR VLIST IN (P_VALUE, S_VALUE, I_VALUE, V_VALUE, M_VALUE, CP_VALUE))
				GROUP BY PROJECT_CODE, END_CUSTOMER, YYYYMM,MEASURE
			) T2 ON T1.PROJECT_CODE = T2.PROJECT_CODE
				AND T1.END_CUSTOMER = T2.END_CUSTOMER
				AND T1.YYYYMM = T2.YYYYMM
				AND T1.MEASURE = T2.MEASURE
			WHERE T1.DIVISION_ID = p_division_id
				AND T1.END_CUSTOMER = p_end_customer
				AND T1.PROJECT_CODE = p_project_code
				AND T1.YYYYMM = TO_CHAR(ADD_MONTHS(TO_DATE(p_yyyymm || '01', 'YYYYMMDD'), v_i), 'YYYYMM');
			IF v_i <= -1
			THEN
				SELECT T1.CUST_FCST_M + NVL(v_EDI_SUM, 0)
					, T2.VSUM + NVL(v_DP_RESULT_SUM, 0)
					, T1.P_VALUE + NVL(v_DP_RESULT_P, 0)
					, T1.S_VALUE + NVL(v_DP_RESULT_S, 0)
					, T1.I_VALUE + NVL(v_DP_RESULT_I, 0)
					, T1.V_VALUE + NVL(v_DP_RESULT_V, 0)
					, T1.M_VALUE + NVL(v_DP_RESULT_M, 0)
					, NVL(T1.CP_VALUE, 0) + NVL(v_DP_RESULT_CP, 0)
				INTO v_EDI_SUM, v_DP_RESULT_SUM, v_DP_RESULT_P, v_DP_RESULT_S, v_DP_RESULT_I, v_DP_RESULT_V, v_DP_RESULT_M, v_DP_RESULT_CP
				FROM DM_ANL_MKT_PSI T1
				LEFT OUTER JOIN (
					SELECT PROJECT_CODE
						,END_CUSTOMER
						,YYYYMM
						,MEASURE
						,SUM(VVALUE) AS VSUM
					FROM DM_ANL_MKT_PSI
					UNPIVOT(VVALUE FOR VLIST IN (P_VALUE, S_VALUE, I_VALUE, V_VALUE, M_VALUE, CP_VALUE))
					GROUP BY PROJECT_CODE,END_CUSTOMER, YYYYMM, MEASURE
				) T2 ON T1.PROJECT_CODE = T2.PROJECT_CODE
					AND T1.YYYYMM = T2.YYYYMM
					AND T1.END_CUSTOMER = T2.END_CUSTOMER
					AND T1.MEASURE = T2.MEASURE
				WHERE 1 = 1
					AND T1.DIVISION_ID = p_division_id
		     		AND T1.END_CUSTOMER = p_end_customer
					AND T1.PROJECT_CODE = p_project_code
					AND T1.YYYYMM = TO_CHAR(ADD_MONTHS(TO_DATE(p_yyyymm || '01', 'YYYYMMDD'), v_i), 'YYYYMM')
					AND T1.MEASURE = 'DP_RESULT';
			END IF;
		END IF;
		v_i := v_i + 1;
	END LOOP;

	-------------------------------------------------------------------------------------------------------------------------------
	BEGIN
		v_DP_ANL_SUM := CASE v_EDI_SUM WHEN 0 THEN 0 ELSE CAST(v_DP_RESULT_SUM / v_EDI_SUM AS BINARY_DOUBLE) END;
		v_DP_ANL_P := CASE v_EDI_SUM WHEN 0 THEN 0 ELSE CAST(v_DP_RESULT_P / v_EDI_SUM AS BINARY_DOUBLE) END;
		v_DP_ANL_S := CASE v_EDI_SUM WHEN 0 THEN 0 ELSE CAST(v_DP_RESULT_S / v_EDI_SUM AS BINARY_DOUBLE) END;
		v_DP_ANL_I := CASE v_EDI_SUM WHEN 0 THEN 0 ELSE CAST(v_DP_RESULT_I / v_EDI_SUM AS BINARY_DOUBLE) END;
		v_DP_ANL_V := CASE v_EDI_SUM WHEN 0 THEN 0 ELSE CAST(v_DP_RESULT_V / v_EDI_SUM AS BINARY_DOUBLE) END;
		v_DP_ANL_M := CASE v_EDI_SUM WHEN 0 THEN 0 ELSE CAST(v_DP_RESULT_M / v_EDI_SUM AS BINARY_DOUBLE) END;
		v_DP_ANL_CP := CASE v_EDI_SUM WHEN 0 THEN 0 ELSE CAST(v_DP_RESULT_CP / v_EDI_SUM AS BINARY_DOUBLE) END;
	END;

	BEGIN
		UPDATE GTT_TMP_DM_ANL_MKT_PSI_DATA SET
			SUM = TO_CHAR(CAST(ROUND(NVL(v_DP_ANL_SUM, 0), 2) AS NUMBER(5, 2)) * 100) || '%'
			,PRODUCT = TO_CHAR(CAST(ROUND(NVL(v_DP_ANL_P, 0), 2) AS NUMBER(5, 2)) * 100) || '%'
			,SALE = TO_CHAR(CAST(ROUND(NVL(v_DP_ANL_S, 0), 2) AS NUMBER(5, 2)) * 100) || '%'
			,INVENTORY = TO_CHAR(CAST(ROUND(NVL(v_DP_ANL_I, 0), 2) AS NUMBER(5, 2)) * 100) || '%'
			,TIME_ADJUST = TO_CHAR(CAST(ROUND(NVL(v_DP_ANL_V, 0), 2) AS NUMBER(5, 2)) * 100) || '%'
			,MODEL_MIX = TO_CHAR(CAST(ROUND(NVL(v_DP_ANL_M, 0), 2) AS NUMBER(5, 2)) * 100) || '%'
			,SUPPLY_ISSUE = TO_CHAR(CAST(ROUND(NVL(v_DP_ANL_CP, 0), 2) AS NUMBER(5, 2)) * 100) || '%'
		WHERE YYYYMM = TO_CHAR(ADD_MONTHS(TO_DATE(p_yyyymm || '01', 'YYYYMMDD'), v_i), 'YYYYMM')
		AND MEASURE = 'Average impact(%)';
	END;

	OPEN O_RESULT_CURSOR FOR
	SELECT T.DIVISION_ID
		,T.END_CUSTOMER
		,T.PROJECT_NAME
		,T.PROJECT_CODE
		,SUBSTR(YYYYMM, 1, 4) || '.' || SUBSTR(YYYYMM, 5, 2) AS YYYYMM
		,CEIL(EDI_QTY) AS EDI_QTY
		,MEASURE
		,SUM
		,PRODUCT
		,SALE
		,INVENTORY
		,TIME_ADJUST
		,MODEL_MIX
		,MKT_DP
		,SUPPLY_ISSUE
	FROM GTT_TMP_DM_ANL_MKT_PSI_DATA T
	ORDER BY YYYYMM, RNK ASC;
END;
/
