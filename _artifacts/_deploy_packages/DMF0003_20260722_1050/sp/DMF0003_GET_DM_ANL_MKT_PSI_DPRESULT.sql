CREATE OR REPLACE PROCEDURE           "DMF0003_GET_DM_ANL_MKT_PSI_DPRESULT"
(
	p_division_id	VARCHAR2,
    p_project_code	 VARCHAR2,
	p_yyyymm    VARCHAR2,
	p_created_by	VARCHAR2,
    p_end_customer VARCHAR2,
	O_RC1 OUT SYS_REFCURSOR
)
AS
/*
 * Program ID  : [DMF0003_GET_DM_ANL_MKT_PSI_DPRESULT]
 * Author:		<Author,,Name>
 * Create date: <Create Date,,>
 * Description  : 고객수요증감 입력(DMF0003_GET_DM_ANL_MKT_PSI_DATA:고객수요증감분석 PSI 조회 sub)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 2023.11.02 kcw3408 	[개발요청] 수요분석시스템_36번	Final 값은 실적 값으로 변경
 2023.11.08 kcw3408 	[개발요청] 수요분석시스템_12_End Customer 단위 세분화 필요 (Sales site는 미포함)
 2024.01.10    kcw3408        [개발요청] 고객수요증감분석_배치작업 신규(표준리포트/RPA팀 우혜라 요청)으로 데이타 존재여부 확인

-- EXEC DMF0003_GET_DM_ANL_MKT_PSI_DPRESULT @p_division_id=N'81',@p_project_code=N'A15BW7003',@p_yyyymm=N'202308',@p_created_by=N'',@p_end_customer=N'BMW'
 2026.06.08 ZIONEX [PJ202650304] NextSCM Migration : 결과셋 반환 복원(BULK COLLECT→OUT SYS_REFCURSOR+OPEN FOR), 누락된 "DESC" 컬럼 복원, QTYCD3 빈문자 비교 RTRIM(...) IS NOT NULL 보정
 */
BEGIN
		/*
	   2023.11.02	   kcw3408		  ⓓ MKT.FCST (DP) 을 월 MKT FCST[R+P] Measure실적과 동일하게 관리
	*/
	BEGIN
		MERGE INTO DM_ANL_MKT_PSI_DETAIL T1
		USING (SELECT X.DIVISION_ID
			      , X.END_CUSTOMER
			      , X.PROJECT_CODE
				  , X.YYYYMM
			      , NVL(CEIL(X.MKT_FCST_M), 0) AS MKT_FCST_M
			   FROM DM_ANL_MKT_PSI X
		      WHERE 1 = 1
			AND X.DIVISION_ID = p_division_id
			    AND X.END_CUSTOMER = p_end_customer
			    AND X.PROJECT_CODE = p_project_code
		    AND X.MEASURE = 'DP_RESULT'
				AND X.YYYYMM = p_yyyymm
		  ) T2
		  ON (T2.DIVISION_ID  = T1.DIVISION_ID
		  AND T2.END_CUSTOMER = T1.END_CUSTOMER
		  AND T2.PROJECT_CODE = T1.PROJECT_CODE
		  AND T2.YYYYMM       = T1.YYYYMM
		  AND T1.MEASURE = 'DP_RESULT')
		WHEN MATCHED THEN
		UPDATE SET
		    T1.MKT_FCST_M = T2.MKT_FCST_M;
	END;

    -- 수요계획 Result 조회 쿼리
	OPEN O_RC1 FOR
	SELECT PROJECT_CODE
		 , END_CUSTOMER
		 , YYYYMM
		 , NVL(CEIL(CUST_FCST_M), 0) AS EDI_QTY
		 , NVL(CEIL(QTY), 0) AS IN_DE_VOL
		 , CASE QTYCD1 WHEN 'CUSTOMER' THEN '고객'
					   WHEN 'COMPANY' THEN '당사' END AS IMPUTATION_YN
		 , CASE QTYCD2 WHEN 'DEMAND' THEN '수요'
					   WHEN 'OPERATION' THEN '운영'
					   WHEN 'SUPPLY' THEN '공급'  END AS DEMAND_OPERATION
		 , CASE QTYCD3 WHEN 'PRODUCT' THEN '차량생산'
					   WHEN 'SALES' THEN '차량판매'
					   WHEN 'INVENTORY' THEN '물류이슈'
					   WHEN 'VPA' THEN '시점조정'
					   WHEN 'MODELMIX' THEN '모델믹스'
					   WHEN 'SUPPLYISSUE' THEN '공급차질' END AS VARIATION_FACTOR
		 , "DESC" AS "DESC"
		 , NVL(CEIL(MKT_FCST_M), 0) AS MKT_FCST
	  FROM DM_ANL_MKT_PSI_DETAIL
	 WHERE 1=1
	   AND DIVISION_ID = p_division_id
	   AND END_CUSTOMER = p_end_customer
	   AND PROJECT_CODE = p_project_code
	   AND MEASURE = 'DP_RESULT'
	   AND RTRIM(QTYCD3) IS NOT NULL
	   --AND YYYYMM BETWEEN TO_CHAR(ADD_MONTHS(SYSDATE, -11), 'YYYYMMDD') AND TO_CHAR(SYSDATE, 'YYYYMMDD');
	   AND YYYYMM = p_yyyymm
	 ORDER BY SEQ;
END;
/
