





/*
 * Program ID   : FN_DQ_MKT_FCST_81                                                              
 * Description  : 자동차 DQ 용 Stock
 * 실행 예제    : SELECT * FROM dbo.FN_DQ_MKT_FCST_81('20231106', '81', 'E66C')
 * Program History  
 *===================================================================================================  
 *   Date       In Charge		Description  
 *===================================================================================================  
 * 2023.11.09	KSG			[PJ20230692] LGES SCM 역량 강화 위한 SCP 개선과제 이행 Phase2 : 자동차 DQ 용 Stock 정보
 * 2023.11.20	KHJ			@p_division_id에 여러사업장 입력시 지원하도록 Split 처리
 * 2023.11.21	KHJ			@@p_cell_nickname에 여러 NickName 입력시는 In 조건으로 처리 / 1개 NickName 들어올 경우 Like로 처리.
 */
 
CREATE FUNCTION [dbo].[FN_DQ_MKT_FCST_81]
(	
      @p_cutoff_date         NVARCHAR(8)
    , @p_division_id         NVARCHAR(1000)
	, @p_cell_nickname       NVARCHAR(1000)
)
RETURNS @MKT_FCST_81 TABLE
(
	  DIVISION_ID				NVARCHAR(30)	NOT NULL
    , VERSION					NVARCHAR(50)	NOT NULL
    , PROJECT_CODE				NVARCHAR(50)	NOT NULL
    , FCST_TYPE					NVARCHAR(50)	NULL
    , PROJECT					NVARCHAR(200)	NULL
    , TO_SITE					NVARCHAR(50)	NULL
    , INCOTERMS					NVARCHAR(10)	NULL
    , ITEM_TYPE					NVARCHAR(100)	NULL
    , CELL_ITEM_ID				NVARCHAR(100)	NULL
    , ITEM_ID					NVARCHAR(50)	NULL
    , CELL_MODEL				NVARCHAR(150)	NULL
    , MEASURE					NVARCHAR(30)	NULL
    , YYYYPW					NVARCHAR(7)		NULL
    , QTY						NUMERIC (20,10) NULL
    , CELL_CONV					NUMERIC (20,10) NULL
    , KCELL						NUMERIC (20,10) NULL
)
AS

BEGIN

	INSERT INTO @MKT_FCST_81
	SELECT DIVISION_ID, VERSION, PROJECT_CODE, FCST_TYPE, PROJECT, TO_SITE, INCOTERMS, ITEM_TYPE, CELL_ITEM_ID, ITEM_ID, CELL_MODEL, MEASURE, YYYYPW
			, SUM(qty)   AS QTY
			, MAX(Cell_Conversion_Factor)  AS CELL_CONV
			, (SUM(qty) * MAX(Cell_Conversion_Factor)) / 1000.0  AS KCELL
		 
	FROM  (
			SELECT m.division_id 
					, m.version_no  AS version
					, m.project_code
					,(SELECT segment2 FROM scm_adm_lookup_master_detail l WITH(NOLOCK)
					WHERE  l.lookup_type = 'SALES_TYPE_CODE'
					AND    l.segment1    = m.fcst_type
					) AS fcst_type

					, p.project_name AS project, m.scm_site_id AS to_site, m.incoterms

					,(SELECT segment2 FROM scm_adm_lookup_master_detail l WITH(NOLOCK)
					WHERE  l.lookup_type = 'ITEM_TYPE_CODE'
					AND    l.segment1    = i.item_type
					) AS item_type

					, CASE WHEN fi.operation_group = 'A' THEN m.item_id
							WHEN fi.operation_group = 'P' THEN fi.attribute1
							ELSE ''
					END AS cell_item_id

					, m.item_id 

					, CASE WHEN fi.operation_group = 'A' THEN fi.group_code1
							WHEN fi.operation_group = 'P' THEN (SELECT group_code1 FROM SCP_MST_FINAL_ITEM B WITH(NOLOCK) WHERE B.DIVISION_ID = fi.DIVISION_ID AND b.ITEM_ID = fi.ATTRIBUTE1)
							ELSE ''
					END AS cell_model

					, CASE WHEN m.measure = 'MKT_FCST_RP' THEN 'MKT FCST[R+P]'
							WHEN m.measure = 'RTF_SYS_RP'  THEN 'RTF[R+P]'
							WHEN m.measure = 'AS_In_Req'   THEN 'AS in Request[R+P]'
							WHEN m.measure = 'AS_In_Plan'  THEN 'AS in Plan[R+P]'
							ELSE ''
					END AS measure

					--, m.yyyymmdd
					, buc.yyyypw AS yyyypw

					, m.qty
					, IIF(ISNULL(fi.cell_cf, '') = '', 1.0, CONVERT(NUMERIC(20,10), fi.cell_cf)) AS Cell_Conversion_Factor

					, CASE WHEN fi.operation_group = 'A' THEN m.qty
							ELSE m.qty * IIF(ISNULL(fi.cell_cf, '') = '', 1.0, CONVERT(NUMERIC(20,10), fi.cell_cf))
					END AS CELL
					, CASE WHEN fi.operation_group = 'A' THEN m.qty
							ELSE m.qty * IIF(ISNULL(fi.cell_cf, '') = '', 1.0, CONVERT(NUMERIC(20,10), fi.cell_cf))
					END / 1000.0 AS KCELL

			FROM  DM_PLN_MKT_FCST_C m WITH(NOLOCK)

			INNER JOIN (-- 입력 일자의 주차 월요일 이후 최신 버전
						SELECT cutoff_type, MAX(version_no) AS version_no
						FROM   DM_PLN_MKT_FCST_C WITH(NOLOCK)
						WHERE  1=1
						AND    division_id IN (SELECT token FROM [dbo].[String_Split](@p_division_id, ','))
						AND    cutoff_yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( CONVERT(DATETIME, @p_cutoff_date), 'MON')), 112) -- 입력 일자의 주차 월요일
						AND    cutoff_yyyymmdd <  CONVERT(CHAR(8), DATEADD(DD, -0, dbo.FN_NEXT_DAY( CONVERT(DATETIME, @p_cutoff_date), 'MON')), 112) -- 입력 일자의 다음 주차 월요일
						AND    cutoff_type = 'MF_W'
						GROUP BY cutoff_type
						) cf
			ON  m.cutoff_type = cf.cutoff_type
			AND m.version_no  = cf.version_no

			LEFT JOIN scp_mst_final_item fi WITH(NOLOCK)
			ON  m.division_id = fi.division_id
			AND m.item_id     = fi.item_id

			LEFT JOIN scm_mst_project p WITH(NOLOCK)
			ON  m.division_id  = p.division_id
			AND m.project_code = p.project_code

			INNER JOIN (
						SELECT division_id, item_id, item_type
						FROM  (
								SELECT division_id, item_id, item_type, ROW_NUMBER() OVER (PARTITION BY division_id, item_id ORDER BY seq ) AS rnum
								FROM  (
										SELECT division_id, item_id, item_type
												, CASE WHEN item_type = 'P' THEN 10
													WHEN item_type = 'H' THEN 20
													WHEN item_type = 'Q' THEN 30
													WHEN item_type = 'R' THEN 40
													ELSE 99
												END  AS seq
										FROM   scm_mst_item_sn WITH(NOLOCK)
										WHERE  1=1
										AND    division_id IN (SELECT token FROM [dbo].[String_Split](@p_division_id, ','))
										) a
								) b
						WHERE rnum = 1
						) i
			ON  m.division_id = i.division_id
			AND m.item_id     = i.item_id
	
			INNER JOIN SCM_MST_BUCKET buc WITH(NOLOCK)
			ON m.yyyymmdd = buc.yyyymmdd

			where 1=1
			AND   m.division_id IN (SELECT token FROM [dbo].[String_Split](@p_division_id, ','))
			AND   m.measure in ('MKT_FCST_RP', 'RTF_SYS_RP', 'AS_In_Req', 'AS_In_Plan')
			) res
	WHERE  1=1
	AND    cell_model IN (SELECT token FROM [dbo].[String_Split](@p_cell_nickname, ','))
	GROUP BY division_id, version, project_code, fcst_type, project, to_site, incoterms, item_type, cell_item_id, item_id, cell_model, measure, yyyypw


RETURN;
END;

