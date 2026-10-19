
/*
 * Program ID   : SCP0091_GET_VALIDATION_SHIPMENT_DETAIL (참고 SCM0014_GET_VALIDATION_SHIPMENT_RESULT)
 * Description  : 출하실적 Validation
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2022/03/10    vadabi3	CREATE
 * 2022/03/21    vadabi3	운영배포 후 수정
 * 2022/03/29    vadabi3	CELL_GROUP 항목 추가
                 vadabi3	PACK_GROUP 항목 추가
 * 2022/03/29    vadabi3	파라미터 추가 @p_cell_group, @p_pack_group , @p_incoterms 
 * 2022/08/07    vadabi3	shipment no = '-' 인 경우 조회 개선
 * 2022/08/07    vadabi3	shipment no = EQUAL -> LIKE (_1,_2,_3,_4)
 * 2022/08/10    vadabi3	Result Date 기간으로 조회 (@p_result_date => @p_from_yyyymmdd, @p_to_yyyymmdd)
 * 2022/08/19    vadabi3	항목추가 [POL, POD(Arrive, Departure), CY2] 추가
 * 2022/08/25    vadabi3	CY2 관련 데이터 적용
 * 2022/12/18    vadabi3	port_description Join 개선
 *===================================================================================================
 EXEC SCP0091_GET_VALIDATION_SHIPMENT_DETAIL @p_result_date='20220701', @p_division_id='81', @p_plant_site_id='A040-A', @p_sales_site_id='LGCPI_US_TYM', @p_project_code='TBD', @p_item_id='ACEN4065I-A1-101', @p_from_yyyymmdd='20220701', @p_to_yyyymmdd='20220701', @p_result_type='I,C,B', @p_shipment_no='0026031522', @p_bucket_type='DAILY', @p_period_from='20220701', @p_period_to='20230701', @p_trans_mode='SEA', @p_searchdate='20220710', @p_cell_group='', @p_pack_group='', @p_incoterms='FOB', @p_operation_group='A'


 */

--CREATE PROCEDURE [dbo].[SCP0091_GET_VALIDATION_SHIPMENT_DETAIL]
CREATE PROCEDURE [dbo].[SCP0091_GET_VALIDATION_SHIPMENT_DETAIL]  
  @p_result_date     NVARCHAR(MAX),
  @p_division_id     NVARCHAR(MAX),
  @p_plant_site_id   NVARCHAR(MAX),    
  @p_sales_site_id   NVARCHAR(MAX),    
  @p_project_code    NVARCHAR(MAX),
  @p_item_id		 NVARCHAR(MAX),
  @p_from_yyyymmdd	 NVARCHAR(8),
  @p_to_yyyymmdd	 NVARCHAR(8),
  @p_result_type	 NVARCHAR(1),
  @p_shipment_no	 NVARCHAR(100),
  @p_bucket_type	 NVARCHAR(10),
  @p_period_from	 NVARCHAR(8),
  @p_period_to	     NVARCHAR(8),
  @p_trans_mode		 NVARCHAR(MAX),
  @p_searchdate	     NVARCHAR(10),
  @p_cell_group      NVARCHAR(MAX),
  @p_pack_group		 NVARCHAR(MAX),
  @p_incoterms		 NVARCHAR(MAX),
  @p_operation_group NVARCHAR(MAX)
AS

BEGIN
 -- SCM0014 참조

   --SET @p_project_code = REPLACE(@p_project_code,'-', '');
   --SET @p_project_code = REPLACE(@p_project_code,'*', '');


   	DECLARE @mEXEC NVARCHAR(MAX);
	SET @mEXEC = '';
/********************************************************************************
-- WEEKLY
********************************************************************************/
IF @p_bucket_type = 'WEEKLY'
BEGIN


		/********************************************************************************
		-- WEEKLY start, end date
		********************************************************************************/
		DECLARE @v_yyyy nvarchar(4);
		DECLARE @v_month nvarchar(2);
		DECLARE @v_week_no nvarchar(2);
		DECLARE @v_year_week_no nvarchar(6);
		DECLARE @v_start_date nvarchar(8);
		DECLARE @v_end_date nvarchar(8);

		select @v_yyyy = substring(@p_searchdate,1,4);
		select @v_month = substring(@p_searchdate,5,2);
		select @v_week_no = substring(@p_searchdate,7,2);
		select @v_year_week_no = concat(@v_yyyy,@v_week_no);

		-- 202201 52주 => 2021년도의 52주인데 2022년 52주로 간주되고 있음
		if @v_month = '01' and @v_week_no > '10'
		begin
		SELECT @v_yyyy = CAST( CAST(@v_yyyy AS INT) -1 AS nvarchar(4))
		select @v_year_week_no = concat(@v_yyyy,@v_week_no);
		end

		select @v_start_date = MIN(BASIS_START_DATE)
			  ,@v_end_date   = max(BASIS_END_DATE)
		from scm_sys_calendar_m 
		where iso_yyyyww = @v_year_week_no
		--select @v_yyyy,@v_month, @v_week_no, @v_year_week_no, @v_start_date, @v_end_date;

		/********************************************************************************
		-- WEEKLY Data
		********************************************************************************/

		-- Cy2
	    SET @mEXEC = @MEXEC+' with CY2 as   (															' + CHAR(10);
		SET @mEXEC = @MEXEC+' select * from (															' + CHAR(10);
		SET @mEXEC = @MEXEC+' SELECT COMPANY_ID    														' + CHAR(10);
	    SET @mEXEC = @MEXEC+' 	  , SHIPMENT_NO    														' + CHAR(10);
		SET @mEXEC = @MEXEC+' 	  , ZFCY2 AS cy2_port    												' + CHAR(10);
	  --SET @mEXEC = @MEXEC+' 	  , IIF(ZFCY2ETA = '', null, convert(char(10), convert(datetime, ZFCY2ETA ), 23)) AS cy2_eta    	' + CHAR(10);
	  --SET @mEXEC = @MEXEC+' 	  , IIF(ZFCY2ETA = '', null, convert(char(10), convert(datetime, ZFCY2ATA ), 23)) AS cy2_ata    	' + CHAR(10);
		SET @mEXEC = @MEXEC+' 	  , CASE WHEN ZFCY2ETA is null then null WHEN ZFCY2ETA = '''' then null else  convert(char(10), convert(datetime, ZFCY2ETA ), 23) END AS cy2_eta    	' + CHAR(10);
		SET @mEXEC = @MEXEC+' 	  , CASE WHEN ZFCY2ATA is null then null WHEN ZFCY2ATA = '''' then null else  convert(char(10), convert(datetime, ZFCY2ATA ), 23) END AS cy2_ata    	' + CHAR(10);
		SET @mEXEC = @MEXEC+' 	  , ROW_NUMBER() OVER (PARTITION BY COMPANY_ID,SHIPMENT_NO ORDER BY LAST_UPDATE_DATE DESC) AS seq    			' + CHAR(10);
		SET @mEXEC = @MEXEC+' 	  FROM SCM_DNM_DELIVERY_TRACKING WITH (NOLOCK)  									' + CHAR(10);
		SET @mEXEC = @MEXEC+' 	  WHERE COMPANY_ID is not null    										' + CHAR(10);
		SET @mEXEC = @MEXEC+' 	  AND  COMPANY_ID != ''''    											' + CHAR(10);
		SET @mEXEC = @MEXEC+' 	  AND ( ZFCY2 IS NOT NULL     											' + CHAR(10);
		SET @mEXEC = @MEXEC+' 	     OR ZFCY2ETA IS NOT NULL     										' + CHAR(10);
		SET @mEXEC = @MEXEC+' 		 OR ZFCY2ATA IS NOT NULL     										' + CHAR(10);
		SET @mEXEC = @MEXEC+' 		 )    																' + CHAR(10);
		SET @mEXEC = @MEXEC+' 		)  data  where data.seq = 1	   										' + CHAR(10);
		SET @mEXEC = @MEXEC+' 	)    																	' + CHAR(10);
		SET @mEXEC = @MEXEC+' 	, PID as   (																				  ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 				SELECT COMPANY_ID , SHIPMENT_NO, MAX(PLANT_ISSUE_DATE)  AS PLANT_ISSUE_DATE		  ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 	 			  FROM scm_dnm_intransit_c  WITH (NOLOCK)     									    			  ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 	 			group by COMPANY_ID, SHIPMENT_NO										    	  ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 		       )	    																	      ' + CHAR(10);

		SET @mEXEC = @MEXEC+' 				SELECT *	    	' + CHAR(10);
		SET @mEXEC = @MEXEC+'       		FROM         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       		(         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       		SELECT convert(char(10), convert(datetime, sdic.result_date), 23) result_date         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			  ,dbo.FN_GET_LOOKUP_CODE_DESC(''SHIPMENT_RESULT_TYPE'', sdic.result_type) AS result_type         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			  ,sdic.division_id         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			  ,CASE sdic.result_type          ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       				WHEN ''S'' THEN ''-''         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       				ELSE  dbo.FN_GET_SHIPMENT_NO_DISPLAY(sdic.shipment_no, sdic.result_type)         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       				END  shipment_no          ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			  ,sdic.project_code         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			  , cp.GROUP_CODE1 AS  CELL_GROUP         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			  , cp.GROUP_CODE2 AS  PACK_GROUP         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			  ,sdic.item_id         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			  ,(SELECT TOP 1 (CASE WHEN X.NICK_NAME IS NULL THEN ''-'' WHEN X.NICK_NAME='''' THEN ''-'' ELSE X.NICK_NAME END) FROM DBO.SCM_MST_ITEM_SN X WITH (NOLOCK) WHERE X.ITEM_ID = sdic.item_id) AS nick_name         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			  ,sdic.plant_id as plant         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			  ,sdic.transport_mode as Trans_Mode         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			  ,dbo.fn_get_item_operation_group(sdic.division_id, sdic.item_id) operation_group         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			  ,sdic.delivery_qty         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			  ,sdic.final_soldto_code	AS customer_code         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			  ,sdic.shipto_code         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			  ,sdic.final_incoterms		AS incoterms         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			  ,sdic.from_scm_site_id         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			  ,sdic.to_scm_site_id         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			  ,smbv.lt_total bod_lead_time         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			  ,IIF(ISNULL(sdic.plant_issue_date,'''')='''','''', convert(char(10), convert(datetime, sdic.plant_issue_date), 23)) as plant_issue_date         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			  ,case when isnull(sdic.pol_atd_date,'''') = '''' then ''''          ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			   else IIF(ISNULL(sdic.pol_atd_date,'''')='''','''', convert(char(10), convert(datetime, sdic.pol_atd_date), 23))         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			   end pol_atd_date         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			  ,case when isnull(sdic.pod_ata_date,'''') = ''''          ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       					then IIF(ISNULL(sdic.pod_eta_date,'''')='''','''', convert(char(10), convert(datetime, sdic.pod_eta_date), 23))         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       					when sdic.pod_ata_date = ''''          ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       					then IIF(ISNULL(sdic.pod_eta_date,'''')='''','''', convert(char(10), convert(datetime, sdic.pod_eta_date), 23))         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			   else convert(char(10), convert(datetime, sdic.pod_ata_date), 23)          ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			   end pod_ata_date         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			  ,case when isnull(sdic.pod_atd_date,'''') = ''''          ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       					then IIF(ISNULL(sdic.pod_etd_date,'''')='''','''', convert(char(10), convert(datetime, sdic.pod_etd_date), 23))         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       					when sdic.pod_atd_date =''''         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       					then IIF(ISNULL(sdic.pod_etd_date,'''')='''','''', convert(char(10), convert(datetime, sdic.pod_etd_date), 23))         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			   else convert(char(10), convert(datetime, sdic.pod_atd_date), 23)          ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			   end pod_atd_date         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			  ,case when isnull(sdic.ATTRIBUTE3,'''')= '''' then ''''          ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       					when sdic.ATTRIBUTE3 ='''' then ''''         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       					else         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       						CASE          ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       						WHEN convert(char(10), convert(datetime, sdic.ATTRIBUTE3), 23)  <  convert(char(10), convert(datetime, sdic.result_date), 23)          ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       						then convert(char(10), convert(datetime, sdic.result_date), 23)          ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       						ELSE convert(char(10), convert(datetime, sdic.ATTRIBUTE3), 23)          ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       						END         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       					end f_dest_eta_date         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			 ,case when isnull(sdic.ATTRIBUTE3,'''')= '''' then ''''          ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       					when sdic.ATTRIBUTE3 ='''' then ''''         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       					else         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       						CASE          ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       						WHEN convert(char(8), convert(datetime, sdic.ATTRIBUTE3), 112)  <  convert(char(8), convert(datetime, sdic.result_date), 112)          ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       						then convert(char(8), convert(datetime, sdic.result_date), 112)          ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       						ELSE convert(char(8), convert(datetime, sdic.ATTRIBUTE3), 112)          ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       						END         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       					end f_dest_eta_yyyymmdd         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			  ,case when isnull(sdic.f_dest_eta_date,'''')= '''' then ''''          ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       					when sdic.f_dest_eta_date ='''' then ''''         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			  else convert(char(10), convert(datetime, sdic.f_dest_eta_date), 23) end f_dest_eta_date2         ' + CHAR(10);

		-- 20220819 추가
		--SET @mEXEC = @MEXEC+'       			  ,(select max(port_description) from SCM_MST_PORT WITH (NOLOCK)  where concat(country,port_code) = sdic.POL)              AS pol_port				' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			  ,(select max(port_description) from SCM_MST_PORT WITH (NOLOCK)  where port_code = sdic.POL)              AS pol_port				' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			  ,IIF(ISNULL(sdic.POL_ATD_DATE,'''')='''','''', convert(char(10), convert(datetime, sdic.POL_ATD_DATE), 23))    AS pol_atd					' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			  ,''''					AS pol_etd				' + CHAR(10);
		--SET @mEXEC = @MEXEC+'       			  ,(select max(port_description) from SCM_MST_PORT where concat(country,port_code) = sdic.POD)            AS pod_arrive_port      ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			  ,(select max(port_description) from SCM_MST_PORT where port_code = sdic.POD)            AS pod_arrive_port      ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			  ,IIF(ISNULL(sdic.POD_ETA_DATE    ,'''')='''','''', convert(char(10), convert(datetime, sdic.POD_ETA_DATE    ), 23)) AS pod_arrive_eta     ' + CHAR(10);		 
		SET @mEXEC = @MEXEC+'       			  ,IIF(ISNULL(sdic.POD_ATA_DATE    ,'''')='''','''', convert(char(10), convert(datetime, sdic.POD_ATA_DATE    ), 23)) AS pod_arrive_ata     ' + CHAR(10);		 
		SET @mEXEC = @MEXEC+'       			  ,IIF(ISNULL(sdic.POD_ETD_DATE    ,'''')='''','''', convert(char(10), convert(datetime, sdic.POD_ETD_DATE    ), 23)) AS pod_departure_etd  ' + CHAR(10);		 
		SET @mEXEC = @MEXEC+'       			  ,IIF(ISNULL(sdic.POD_ATD_DATE    ,'''')='''','''', convert(char(10), convert(datetime, sdic.POD_ATD_DATE    ), 23)) AS pod_departure_atd  ' + CHAR(10);

		-- 20220825 추가		 
		--SET @mEXEC = @MEXEC+'       			  ,(select max(port_description) from SCM_MST_PORT where concat(country,port_code) = cy2.ZFCY2) AS cy2_port					' + CHAR(10);		 
		--SET @mEXEC = @MEXEC+'       			  ,IIF(ISNULL(sdic.F_DEST_ETA_DATE ,'''')='''','''', convert(char(10), convert(datetime, cy2.ZFCY2ETA ), 23)) AS cy2_eta	' + CHAR(10);	 
		--SET @mEXEC = @MEXEC+'       			  ,IIF(ISNULL(sdic.F_DEST_ATA_DATE ,'''')='''','''', convert(char(10), convert(datetime, cy2.ZFCY2ATA ), 23)) AS cy2_ata	' + CHAR(10);	
		--SET @mEXEC = @MEXEC+'       			  ,(select max(ZFCY2) from SCM_DNM_DELIVERY_TRACKING where COMPANY_ID = sdic.COMPANY_ID AND SHIPMENT_NO = sdic.SHIPMENT_NO)   AS cy2_port												' + CHAR(10);
		--SET @mEXEC = @MEXEC+'       			  ,(select  convert(char(10), convert(datetime, max(ZFCY2ETA) ), 23) from SCM_DNM_DELIVERY_TRACKING where COMPANY_ID = sdic.COMPANY_ID AND SHIPMENT_NO = sdic.SHIPMENT_NO)  AS cy2_eta ' + CHAR(10);	
		--SET @mEXEC = @MEXEC+'       			  ,(select  convert(char(10), convert(datetime, max(ZFCY2ATA) ), 23) from SCM_DNM_DELIVERY_TRACKING where COMPANY_ID = sdic.COMPANY_ID AND SHIPMENT_NO = sdic.SHIPMENT_NO)  AS cy2_ata ' + CHAR(10);	
		SET @mEXEC = @MEXEC+'       			   ,(select max(cy2_port) from CY2 where COMPANY_ID = sdic.COMPANY_ID AND SHIPMENT_NO = sdic.SHIPMENT_NO and sdic.plant_issue_date  =pid.plant_issue_date)  AS cy2_port		' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			   ,(select max(cy2_eta)  from CY2 where COMPANY_ID = sdic.COMPANY_ID AND SHIPMENT_NO = sdic.SHIPMENT_NO  and sdic.plant_issue_date =pid.plant_issue_date)  AS cy2_eta		' + CHAR(10);	
		SET @mEXEC = @MEXEC+'       			   ,(select max(cy2_ata)  from CY2 where COMPANY_ID = sdic.COMPANY_ID AND SHIPMENT_NO = sdic.SHIPMENT_NO  and sdic.plant_issue_date =pid.plant_issue_date)  AS cy2_ata 		' + CHAR(10);		 

		SET @mEXEC = @MEXEC+'       		FROM  scm_dnm_intransit_c sdic WITH (NOLOCK)         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       		LEFT JOIN scp_mst_bod_n_v smbv WITH (NOLOCK)         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			ON    sdic.division_id = smbv.division_id         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			AND   sdic.from_scm_site_id = smbv.from_site         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			AND   sdic.to_scm_site_id = smbv.to_site         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			AND   ( CASE WHEN ISNULL(sdic.final_incoterms, '''') = '''' THEN sdic.incoterms         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       					ELSE sdic.final_incoterms         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       				   END ) = smbv.incoterms         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			AND   sdic.transport_mode = smbv.transport_mode         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			AND   smbv.bod_valid_yn = ''Y''         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			AND   smbv.route_valid_yn = ''Y''         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			AND sdic.result_date >= smbv.from_yyyymmdd         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			AND sdic.result_date <= smbv.to_yyyymmdd         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'             LEFT JOIN SCP_MST_FINAL_ITEM cp WITH (NOLOCK)  on cp.DIVISION_ID = sdic.division_id and  cp.ITEM_ID = sdic.ITEM_ID           ' + CHAR(10);
		SET @mEXEC = @MEXEC+'             left join pid on  pid.COMPANY_ID = sdic.COMPANY_ID AND pid.SHIPMENT_NO = sdic.SHIPMENT_NO  AND pid.plant_issue_date = sdic.plant_issue_date        ' + CHAR(10);

		--SET @mEXEC = @MEXEC+'             LEFT JOIN SCM_DNM_DELIVERY_TRACKING cy2 ON cy2.COMPANY_ID = sdic.COMPANY_ID AND cy2.SHIPMENT_NO = sdic.SHIPMENT_NO  ' + CHAR(10); -- 20220825 CY2
		SET @mEXEC = @MEXEC+'       		WHERE 1 = 1       ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       		    [@p_division_id]        ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			[@p_plant_site_id]      ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			[@p_sales_site_id]      ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			[@p_project_code]       ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			[@p_item_id]            ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			[@p_trans_mode]         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			[@p_shipment_no]        ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			[@p_result_date]        ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			AND sdic.RESULT_TYPE in (''I'',''C'',''B'')         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			AND dbo.fn_get_item_operation_group(sdic.division_id, sdic.item_id) != ''''         ' + CHAR(10);


		IF @p_cell_group = '*' OR @p_cell_group = ''
			BEGIN
			SET @mEXEC = @MEXEC+' 		AND cp.GROUP_CODE1 IS NULL																												 ' + CHAR(10);
			END
		ELSE
			BEGIN
			SET @mEXEC = @MEXEC+' 		AND cp.GROUP_CODE1			IN ( SELECT token FROM dbo.String_Split([@p_cell_group]	 ,''''))   ' + CHAR(10);
			END

		IF @p_pack_group = '*' OR @p_pack_group = ''
			BEGIN
			--SET @mEXEC = @MEXEC+' 		AND cp.GROUP_CODE2 IS NULL																												 ' + CHAR(10);
			SET @mEXEC = @MEXEC+' 										' + CHAR(10);
			END
		ELSE
			BEGIN
			SET @mEXEC = @MEXEC+' 		AND cp.GROUP_CODE2			IN ( SELECT token FROM dbo.String_Split([@p_pack_group]	 ,''''))   ' + CHAR(10);
			END

		IF @p_incoterms = '*' OR @p_incoterms = ''
			BEGIN
			SET @mEXEC = @MEXEC+' 	' + CHAR(10);
			END
		ELSE
			BEGIN
			SET @mEXEC = @MEXEC+' 		AND sdic.final_incoterms		IN ( SELECT token FROM dbo.String_Split([@p_incoterms]	 ,''''))   ' + CHAR(10);                                                                                                                           
			END

		SET @mEXEC = @MEXEC+'       		) DATA         ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       		WHERE  f_dest_eta_yyyymmdd between  [@v_start_date] and [@v_end_date]         ' + CHAR(10);
		
		IF @p_operation_group = '*' OR @p_operation_group = ''
			BEGIN
			SET @mEXEC = @MEXEC+' 	' + CHAR(10);
			END
		ELSE
			BEGIN
			SET @mEXEC = @MEXEC+' 		AND operation_group		IN ( SELECT token FROM dbo.String_Split([@p_operation_group]	 ,''''))   ' + CHAR(10);                                                                                                                           
			END



		SET @mEXEC = @MEXEC+'       		ORDER BY result_date, result_type, division_id, shipment_no         ' + CHAR(10);

		SET @mEXEC = REPLACE(@mEXEC,'[@p_division_id]'		    , [dbo].[FN_SCM_GET_WHERE_SQL]('sdic.division_id','EQUAL', @p_division_id ));
		SET @mEXEC = REPLACE(@mEXEC,'[@p_plant_site_id]'		, [dbo].[FN_SCM_GET_WHERE_SQL]('sdic.from_scm_site_id', 'LIKE', @p_plant_site_id ));
		SET @mEXEC = REPLACE(@mEXEC,'[@p_sales_site_id]'		, [dbo].[FN_SCM_GET_WHERE_SQL]('sdic.to_scm_site_id', 'LIKE', @p_sales_site_id ));
		SET @mEXEC = REPLACE(@mEXEC,'[@p_project_code]'		    , [dbo].[FN_SCM_GET_WHERE_SQL]('sdic.project_code', 'EQUAL', @p_project_code ));
		SET @mEXEC = REPLACE(@mEXEC,'[@p_item_id]'				, [dbo].[FN_SCM_GET_WHERE_SQL]('sdic.item_id', 'EQUAL', @p_item_id ));
		SET @mEXEC = REPLACE(@mEXEC,'[@p_trans_mode]'			, [dbo].[FN_SCM_GET_WHERE_SQL]('sdic.transport_mode', 'EQUAL', @p_trans_mode ));
		SET @mEXEC = REPLACE(@mEXEC,'[@p_shipment_no]'			, [dbo].[FN_SCM_GET_WHERE_SQL]('sdic.shipment_no', 'LIKE', @p_shipment_no ));
	    SET @mEXEC = REPLACE(@mEXEC,'[@p_result_date]'			, 'AND sdic.result_date BETWEEN '''+@p_from_yyyymmdd+''' AND '''+@p_to_yyyymmdd+'''');-- 20220810

		SET @mEXEC = REPLACE(@mEXEC,'[@p_cell_group]'			, 'N'''+@p_cell_group+'''');
		SET @mEXEC = REPLACE(@mEXEC,'[@p_pack_group]'			, 'N'''+@p_pack_group+'''');
		SET @mEXEC = REPLACE(@mEXEC,'[@p_incoterms]'			, 'N'''+@p_incoterms+'''');
		SET @mEXEC = REPLACE(@mEXEC,'[@v_start_date]'			, ''''+@v_start_date+'''');
		SET @mEXEC = REPLACE(@mEXEC,'[@v_end_date]'				, ''''+@v_end_date+'''');
		SET @mEXEC = REPLACE(@mEXEC,'[@p_operation_group]'		, 'N'''+@p_operation_group+'''');

END


/********************************************************************************
-- MONTHLY
********************************************************************************/
ELSE IF @p_bucket_type = 'MONTHLY'
BEGIN
		-- Cy2
	    SET @mEXEC = @MEXEC+' with CY2 as   (															' + CHAR(10);
		SET @mEXEC = @MEXEC+' select * from (															' + CHAR(10);
		SET @mEXEC = @MEXEC+' SELECT COMPANY_ID    														' + CHAR(10);
	    SET @mEXEC = @MEXEC+' 	  , SHIPMENT_NO    														' + CHAR(10);
		SET @mEXEC = @MEXEC+' 	  , ZFCY2 AS cy2_port    												' + CHAR(10);
		--SET @mEXEC = @MEXEC+' 	  , IIF(ZFCY2ETA = '', null, convert(char(10), convert(datetime, ZFCY2ETA ), 23)) AS cy2_eta    	' + CHAR(10);
		--SET @mEXEC = @MEXEC+' 	  , IIF(ZFCY2ETA = '', null, convert(char(10), convert(datetime, ZFCY2ATA ), 23)) AS cy2_ata    	' + CHAR(10);
		SET @mEXEC = @MEXEC+' 	  , CASE WHEN ZFCY2ETA is null then null WHEN ZFCY2ETA = '''' then null else  convert(char(10), convert(datetime, ZFCY2ETA ), 23) END AS cy2_eta    	' + CHAR(10);
		SET @mEXEC = @MEXEC+' 	  , CASE WHEN ZFCY2ATA is null then null WHEN ZFCY2ATA = '''' then null else  convert(char(10), convert(datetime, ZFCY2ATA ), 23) END AS cy2_ata    	' + CHAR(10);
		SET @mEXEC = @MEXEC+' 	  , ROW_NUMBER() OVER (PARTITION BY COMPANY_ID,SHIPMENT_NO ORDER BY LAST_UPDATE_DATE DESC) AS seq    			' + CHAR(10);
		SET @mEXEC = @MEXEC+' 	  FROM SCM_DNM_DELIVERY_TRACKING WITH (NOLOCK)    									' + CHAR(10);
		SET @mEXEC = @MEXEC+' 	  WHERE COMPANY_ID is not null    										' + CHAR(10);
		SET @mEXEC = @MEXEC+' 	  AND  COMPANY_ID != ''''    											' + CHAR(10);
		SET @mEXEC = @MEXEC+' 	  AND ( ZFCY2 IS NOT NULL     											' + CHAR(10);
		SET @mEXEC = @MEXEC+' 	     OR ZFCY2ETA IS NOT NULL     										' + CHAR(10);
		SET @mEXEC = @MEXEC+' 		 OR ZFCY2ATA IS NOT NULL     										' + CHAR(10);
		SET @mEXEC = @MEXEC+' 		 )    																' + CHAR(10);
		SET @mEXEC = @MEXEC+' 		)  data  where data.seq = 1	   										' + CHAR(10);
		SET @mEXEC = @MEXEC+' 	)    																	' + CHAR(10);

		SET @mEXEC = @MEXEC+' 	, PID as   (																				  ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 				SELECT COMPANY_ID , SHIPMENT_NO, MAX(PLANT_ISSUE_DATE)  AS PLANT_ISSUE_DATE		  ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 	 			  FROM scm_dnm_intransit_c  WITH (NOLOCK)   									    			  ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 	 			group by COMPANY_ID, SHIPMENT_NO										    	  ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 		       )	    																	      ' + CHAR(10);

		SET @mEXEC = @MEXEC+'       SELECT *																																																					' + CHAR(10);
		SET @mEXEC = @MEXEC+' 		FROM                                                                                                                                                                                                                        ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 		(                                                                                                                                                                                                                           ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 		SELECT convert(char(10), convert(datetime, sdic.result_date), 23) result_date                                                                                                                                               ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			  --,CASE sdic.result_type WHEN ''P'' THEN ''Plant Issue'' ELSE ''Intransit'' END result_type                                                                                                                           ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			  ,dbo.FN_GET_LOOKUP_CODE_DESC(''SHIPMENT_RESULT_TYPE'', sdic.result_type) AS result_type                                                                                                                               ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			  ,sdic.division_id                                                                                                                                                                                                     ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			  ,CASE sdic.result_type -- WHEN ''C'' THEN ''-'' 2020/10/07                                                                                                                                                            ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 									 WHEN ''S'' THEN ''-''                                                                                                                                                                          ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 									 ELSE  dbo.FN_GET_SHIPMENT_NO_DISPLAY(sdic.shipment_no, sdic.result_type)                                                                                                                                                                         ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 									 END  shipment_no -- 2018/09/20                                                                                                                                                                 ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			  ,sdic.project_code                                                                                                                                                                                                    ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			  , cp.GROUP_CODE1 AS  CELL_GROUP                                                                                                                                                                                       ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			  , cp.GROUP_CODE2 AS  PACK_GROUP                                                                                                                                                                                       ' + CHAR(10);
		SET @mEXEC = @MEXEC+'                                                                                                                                                                                                                                   ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			  /*                                                                                                                                                                                                                    ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			  ,CASE sdic.result_type WHEN ''C'' THEN ''-''                                                                                                                                                                          ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 									 ELSE sdic.project_code                                                                                                                                                                         ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 									 END  project_code -- 2018/09/20                                                                                                                                                                ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			  */                                                                                                                                                                                                                    ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			  ,sdic.item_id                                                                                                                                                                                                         ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			  ,(SELECT TOP 1 (CASE WHEN X.NICK_NAME IS NULL THEN ''-'' WHEN X.NICK_NAME='''' THEN ''-'' ELSE X.NICK_NAME END) FROM DBO.SCM_MST_ITEM_SN X WITH (NOLOCK) WHERE X.ITEM_ID = sdic.item_id) AS nick_name                   ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			  ,sdic.plant_id as plant                                                                                                                                                                                               ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			  ,sdic.transport_mode as Trans_Mode                                                                                                                                                                                    ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			  ,dbo.fn_get_item_operation_group(sdic.division_id, sdic.item_id) operation_group                                                                                                                                      ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			  ,sdic.delivery_qty                                                                                                                                                                                                    ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			  ,sdic.final_soldto_code	AS customer_code                                                                                                                                                                            ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			  ,sdic.shipto_code                                                                                                                                                                                                     ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			  ,sdic.final_incoterms		AS incoterms                                                                                                                                                                                ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			  ,sdic.from_scm_site_id                                                                                                                                                                                                ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			  ,sdic.to_scm_site_id                                                                                                                                                                                                  ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			  ,smbv.lt_total bod_lead_time                                                                                                                                                                                          ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			  ,IIF(ISNULL(sdic.plant_issue_date,'''')='''','''', convert(char(10), convert(datetime, sdic.plant_issue_date), 23)) as plant_issue_date                                                                                     ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			  ,case when isnull(sdic.pol_atd_date,'''') = '''' then ''''                                                                                                                                                                  ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			   else IIF(ISNULL(sdic.pol_atd_date,'''')='''','''', convert(char(10), convert(datetime, sdic.pol_atd_date), 23))                                                                                                            ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			  end pol_atd_date                                                                                                                                                                                                      ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			  ,case when isnull(sdic.pod_ata_date,'''') = ''''                                                                                                                                                                          ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 					then IIF(ISNULL(sdic.pod_eta_date,'''')='''','''', convert(char(10), convert(datetime, sdic.pod_eta_date), 23))                                                                                                       ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 					when sdic.pod_ata_date = ''''                                                                                                                                                                                     ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 					then IIF(ISNULL(sdic.pod_eta_date,'''')='''','''', convert(char(10), convert(datetime, sdic.pod_eta_date), 23))                                                                                                       ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			   else convert(char(10), convert(datetime, sdic.pod_ata_date), 23)                                                                                                                                                     ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			   end pod_ata_date                                                                                                                                                                                                     ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			  ,case when isnull(sdic.pod_atd_date,'''') = ''''                                                                                                                                                                          ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 					then IIF(ISNULL(sdic.pod_etd_date,'''')='''','''', convert(char(10), convert(datetime, sdic.pod_etd_date), 23))                                                                                                       ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 					when sdic.pod_atd_date =''''                                                                                                                                                                                      ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 					then IIF(ISNULL(sdic.pod_etd_date,'''')='''','''', convert(char(10), convert(datetime, sdic.pod_etd_date), 23))                                                                                                       ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			   else convert(char(10), convert(datetime, sdic.pod_atd_date), 23)                                                                                                                                                     ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			   end pod_atd_date                                                                                                                                                                                                     ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			  ,case when isnull(sdic.ATTRIBUTE3,'''')= '''' then ''''                                                                                                                                                                     ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 					when sdic.ATTRIBUTE3 ='''' then ''''                                                                                                                                                                                ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 					else                                                                                                                                                                                                            ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 						CASE                                                                                                                                                                                                        ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 						WHEN convert(char(10), convert(datetime, sdic.ATTRIBUTE3), 23)  <  convert(char(10), convert(datetime, sdic.result_date), 23)                                                                               ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 						then convert(char(10), convert(datetime, sdic.result_date), 23)                                                                                                                                             ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 						ELSE convert(char(10), convert(datetime, sdic.ATTRIBUTE3), 23)                                                                                                                                              ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 						END                                                                                                                                                                                                         ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 					end f_dest_eta_date                                                                                                                                                                                             ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			 ,case when isnull(sdic.ATTRIBUTE3,'''')= '''' then ''''                                                                                                                                                                      ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 					when sdic.ATTRIBUTE3 ='''' then ''''                                                                                                                                                                                ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 					else                                                                                                                                                                                                            ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 						CASE                                                                                                                                                                                                        ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 						WHEN convert(char(8), convert(datetime, sdic.ATTRIBUTE3), 112)  <  convert(char(8), convert(datetime, sdic.result_date), 112)                                                                               ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 						then convert(char(8), convert(datetime, sdic.result_date), 112)                                                                                                                                             ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 						ELSE convert(char(8), convert(datetime, sdic.ATTRIBUTE3), 112)                                                                                                                                              ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 						END                                                                                                                                                                                                         ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 					end f_dest_eta_yyyymmdd                                                                                                                                                                                         ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			  ,case when isnull(sdic.f_dest_eta_date,'''')= '''' then ''''                                                                                                                                                                ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 					when sdic.f_dest_eta_date ='''' then ''''                                                                                                                                                                           ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			  else convert(char(10), convert(datetime, sdic.f_dest_eta_date), 23) end f_dest_eta_date2                                                                                                                              ' + CHAR(10);

		-- 20220819 추가
		--SET @mEXEC = @MEXEC+'       			  ,(select max(port_description) from SCM_MST_PORT WITH (NOLOCK)  where concat(country,port_code) = sdic.POL)              AS pol_port				' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			  ,(select max(port_description) from SCM_MST_PORT WITH (NOLOCK)  where port_code = sdic.POL)              AS pol_port				' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			  ,IIF(ISNULL(sdic.POL_ATD_DATE,'''')='''','''', convert(char(10), convert(datetime, sdic.POL_ATD_DATE), 23))    AS pol_atd					' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			  ,''''					AS pol_etd				' + CHAR(10);
		--SET @mEXEC = @MEXEC+'       			  ,(select max(port_description) from SCM_MST_PORT where concat(country,port_code) = sdic.POD)            AS pod_arrive_port      ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			  ,(select max(port_description) from SCM_MST_PORT where port_code = sdic.POD)            AS pod_arrive_port      ' + CHAR(10);

		SET @mEXEC = @MEXEC+'       			  ,IIF(ISNULL(sdic.POD_ETA_DATE    ,'''')='''','''', convert(char(10), convert(datetime, sdic.POD_ETA_DATE    ), 23)) AS pod_arrive_eta     ' + CHAR(10);		 
		SET @mEXEC = @MEXEC+'       			  ,IIF(ISNULL(sdic.POD_ATA_DATE    ,'''')='''','''', convert(char(10), convert(datetime, sdic.POD_ATA_DATE    ), 23)) AS pod_arrive_ata     ' + CHAR(10);		 
		SET @mEXEC = @MEXEC+'       			  ,IIF(ISNULL(sdic.POD_ETD_DATE    ,'''')='''','''', convert(char(10), convert(datetime, sdic.POD_ETD_DATE    ), 23)) AS pod_departure_etd  ' + CHAR(10);		 
		SET @mEXEC = @MEXEC+'       			  ,IIF(ISNULL(sdic.POD_ATD_DATE    ,'''')='''','''', convert(char(10), convert(datetime, sdic.POD_ATD_DATE    ), 23)) AS pod_departure_atd  ' + CHAR(10);		 
		-- 20220825 추가		 
		--SET @mEXEC = @MEXEC+'       			  ,(select max(port_description) from SCM_MST_PORT where concat(country,port_code) = cy2.ZFCY2) AS cy2_port					' + CHAR(10);		 
		--SET @mEXEC = @MEXEC+'       			  ,IIF(ISNULL(sdic.F_DEST_ETA_DATE ,'''')='''','''', convert(char(10), convert(datetime, cy2.ZFCY2ETA ), 23)) AS cy2_eta	' + CHAR(10);	 
		--SET @mEXEC = @MEXEC+'       			  ,IIF(ISNULL(sdic.F_DEST_ATA_DATE ,'''')='''','''', convert(char(10), convert(datetime, cy2.ZFCY2ATA ), 23)) AS cy2_ata	' + CHAR(10);	
		--SET @mEXEC = @MEXEC+'       			  ,(select max(ZFCY2) from SCM_DNM_DELIVERY_TRACKING where COMPANY_ID = sdic.COMPANY_ID AND SHIPMENT_NO = sdic.SHIPMENT_NO)   AS cy2_port									' + CHAR(10);
		--SET @mEXEC = @MEXEC+'       			  ,(select  convert(char(10), convert(datetime, max(ZFCY2ETA) ), 23) from SCM_DNM_DELIVERY_TRACKING where COMPANY_ID = sdic.COMPANY_ID AND SHIPMENT_NO = sdic.SHIPMENT_NO)  AS cy2_eta ' + CHAR(10);	
		--SET @mEXEC = @MEXEC+'       			  ,(select  convert(char(10), convert(datetime, max(ZFCY2ATA) ), 23) from SCM_DNM_DELIVERY_TRACKING where COMPANY_ID = sdic.COMPANY_ID AND SHIPMENT_NO = sdic.SHIPMENT_NO)  AS cy2_ata ' + CHAR(10);			 
		SET @mEXEC = @MEXEC+'       			   ,(select max(cy2_port) from CY2 where COMPANY_ID = sdic.COMPANY_ID AND SHIPMENT_NO = sdic.SHIPMENT_NO and sdic.plant_issue_date  =pid.plant_issue_date)  AS cy2_port		' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			   ,(select max(cy2_eta)  from CY2 where COMPANY_ID = sdic.COMPANY_ID AND SHIPMENT_NO = sdic.SHIPMENT_NO  and sdic.plant_issue_date =pid.plant_issue_date)  AS cy2_eta		' + CHAR(10);	
		SET @mEXEC = @MEXEC+'       			   ,(select max(cy2_ata)  from CY2 where COMPANY_ID = sdic.COMPANY_ID AND SHIPMENT_NO = sdic.SHIPMENT_NO  and sdic.plant_issue_date =pid.plant_issue_date)  AS cy2_ata 		' + CHAR(10);	

		SET @mEXEC = @MEXEC+' 		FROM  scm_dnm_intransit_c sdic  WITH (NOLOCK)                                                                                                                                                                                             ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 		LEFT JOIN scp_mst_bod_n_v smbv  WITH (NOLOCK)                                                                                                                                                                                             ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			ON    sdic.division_id = smbv.division_id                                                                                                                                                                               ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			AND   sdic.from_scm_site_id = smbv.from_site                                                                                                                                                                            ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			AND   sdic.to_scm_site_id = smbv.to_site                                                                                                                                                                                ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			AND   ( CASE                                                                                                                                                                                                            ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			        WHEN ISNULL(sdic.final_incoterms, '''') = '''' THEN sdic.incoterms                                                                                                                                                  ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 					ELSE sdic.final_incoterms                                                                                                                                                                                       ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 				    END                                                                                                                                                                                                             ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 				  ) = smbv.incoterms                                                                                                                                                                                                ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			AND   sdic.transport_mode = smbv.transport_mode                                                                                                                                                                         ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			AND   smbv.bod_valid_yn = ''Y''                                                                                                                                                                                         ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			AND   smbv.route_valid_yn = ''Y''                                                                                                                                                                                       ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 			AND sdic.result_date >= smbv.from_yyyymmdd                                                                                                                                                                              ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 	        AND sdic.result_date <= smbv.to_yyyymmdd                                                                                                                                                                                ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 	  LEFT JOIN SCP_MST_FINAL_ITEM cp WITH (NOLOCK)  on cp.DIVISION_ID = sdic.division_id and  cp.ITEM_ID = sdic.ITEM_ID                                                                                                                           ' + CHAR(10);
		SET @mEXEC = @MEXEC+'             left join pid on  pid.COMPANY_ID = sdic.COMPANY_ID AND pid.SHIPMENT_NO = sdic.SHIPMENT_NO  AND pid.plant_issue_date = sdic.plant_issue_date        ' + CHAR(10);

		
		--SET @mEXEC = @MEXEC+'     LEFT JOIN SCM_DNM_DELIVERY_TRACKING cy2 ON cy2.COMPANY_ID = sdic.COMPANY_ID AND cy2.SHIPMENT_NO = sdic.SHIPMENT_NO          ' + CHAR(10); -- 20220825 CY2		
		SET @mEXEC = @MEXEC+' 	  WHERE 1= 1																																																					' + CHAR(10);
		SET @mEXEC = @MEXEC+' 	    [@p_division_id]						                                       ' + CHAR(10);                                                                                 
		SET @mEXEC = @MEXEC+' 		[@p_plant_site_id]                                                             ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 		[@p_sales_site_id]                                                             ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 		[@p_project_code]                                                              ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 		[@p_item_id]	                                                               ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 		[@p_trans_mode]                                                                ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 		[@p_shipment_no]                                                               ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       [@p_result_date]        ' + CHAR(10);



		SET @mEXEC = @MEXEC+' 		AND sdic.RESULT_TYPE in (''I'',''C'',''B'')                                    ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 		AND dbo.fn_get_item_operation_group(sdic.division_id, sdic.item_id) != ''''    ' + CHAR(10);

		IF @p_cell_group = '*' OR @p_cell_group = ''
			BEGIN
			SET @mEXEC = @MEXEC+' 		AND cp.GROUP_CODE1 IS NULL																												 ' + CHAR(10);
			END
		ELSE
			BEGIN
			SET @mEXEC = @MEXEC+' 		AND cp.GROUP_CODE1			IN ( SELECT token FROM dbo.String_Split([@p_cell_group]	 ,''''))   ' + CHAR(10);
			END



		IF @p_pack_group = '*' OR @p_pack_group = ''
			BEGIN
			--SET @mEXEC = @MEXEC+' 		AND cp.GROUP_CODE2 IS NULL																												 ' + CHAR(10);
			SET @mEXEC = @MEXEC+' 										' + CHAR(10);
			END
		ELSE
			BEGIN
			SET @mEXEC = @MEXEC+' 		AND cp.GROUP_CODE2			IN ( SELECT token FROM dbo.String_Split([@p_pack_group]	 ,''''))   ' + CHAR(10);
			END

		IF @p_incoterms = '*' OR @p_incoterms = ''
			BEGIN
			SET @mEXEC = @MEXEC+' 	' + CHAR(10);
			END
		ELSE
			BEGIN
			SET @mEXEC = @MEXEC+' 		AND sdic.final_incoterms		IN ( SELECT token FROM dbo.String_Split([@p_incoterms]	 ,''''))   ' + CHAR(10);                                                                                                                           
			END

		SET @mEXEC = @MEXEC+' 		) DATA                                                                                                                                                                                                                      ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 		WHERE  substring(f_dest_eta_yyyymmdd,1,6)  = [@p_searchdate]                                                                                                                                                                 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		AND F_DEST_ETA_DATE between [@p_period_from] and [@p_period_to]				' + CHAR(10);
		IF @p_operation_group = '*' OR @p_operation_group = ''
			BEGIN
			SET @mEXEC = @MEXEC+' 	' + CHAR(10);
			END
		ELSE
			BEGIN
			SET @mEXEC = @MEXEC+' 		AND operation_group		IN ( SELECT token FROM dbo.String_Split([@p_operation_group]	 ,''''))   ' + CHAR(10);                                                                                                                           
			END
		SET @mEXEC = @MEXEC+' 		ORDER BY result_date, result_type, division_id, shipment_no;                                                                                                                                                                ' + CHAR(10);


		SET @mEXEC = REPLACE(@mEXEC,'[@p_division_id]'		    , [dbo].[FN_SCM_GET_WHERE_SQL]('sdic.division_id','EQUAL', @p_division_id ));
		SET @mEXEC = REPLACE(@mEXEC,'[@p_plant_site_id]'		, [dbo].[FN_SCM_GET_WHERE_SQL]('sdic.from_scm_site_id', 'LIKE', @p_plant_site_id ));
		SET @mEXEC = REPLACE(@mEXEC,'[@p_sales_site_id]'		, [dbo].[FN_SCM_GET_WHERE_SQL]('sdic.to_scm_site_id', 'LIKE', @p_sales_site_id ));
		SET @mEXEC = REPLACE(@mEXEC,'[@p_project_code]'		    , [dbo].[FN_SCM_GET_WHERE_SQL]('sdic.project_code', 'EQUAL', @p_project_code ));
		SET @mEXEC = REPLACE(@mEXEC,'[@p_item_id]'				, [dbo].[FN_SCM_GET_WHERE_SQL]('sdic.item_id', 'EQUAL', @p_item_id ));
		SET @mEXEC = REPLACE(@mEXEC,'[@p_trans_mode]'			, [dbo].[FN_SCM_GET_WHERE_SQL]('sdic.transport_mode', 'EQUAL', @p_trans_mode ));
		SET @mEXEC = REPLACE(@mEXEC,'[@p_shipment_no]'			, [dbo].[FN_SCM_GET_WHERE_SQL]('sdic.shipment_no', 'LIKE', @p_shipment_no ));
		SET @mEXEC = REPLACE(@mEXEC,'[@p_result_date]'			, 'AND sdic.result_date BETWEEN '''+@p_from_yyyymmdd+''' AND '''+@p_to_yyyymmdd+'''');-- 20220810



		SET @mEXEC = REPLACE(@mEXEC,'[@p_cell_group]'			, 'N'''+@p_cell_group+'''');
		SET @mEXEC = REPLACE(@mEXEC,'[@p_pack_group]'			, 'N'''+@p_pack_group+'''');
		SET @mEXEC = REPLACE(@mEXEC,'[@p_incoterms]'			, 'N'''+@p_incoterms+'''');
		SET @mEXEC = REPLACE(@mEXEC,'[@p_searchdate]'			, ''''+@p_searchdate+'''');
		SET @mEXEC = REPLACE(@mEXEC,'[@p_period_to]'			, ''''+@p_period_to+'''');
		SET @mEXEC = REPLACE(@mEXEC,'[@p_period_from]'			, ''''+@p_period_from+'''');
		SET @mEXEC = REPLACE(@mEXEC,'[@p_operation_group]'		, 'N'''+@p_operation_group+'''');


END;

/********************************************************************************
-- DAILY
********************************************************************************/
ELSE 
BEGIN
		-- Cy2
	    SET @mEXEC = @MEXEC+' with CY2 as   (															' + CHAR(10);
		SET @mEXEC = @MEXEC+' select * from (															' + CHAR(10);
		SET @mEXEC = @MEXEC+' SELECT COMPANY_ID    														' + CHAR(10);
	    SET @mEXEC = @MEXEC+' 	  , SHIPMENT_NO    														' + CHAR(10);
		SET @mEXEC = @MEXEC+' 	  , ZFCY2 AS cy2_port    												' + CHAR(10);
		--SET @mEXEC = @MEXEC+' 	  , IIF(ZFCY2ETA = '', null, convert(char(10), convert(datetime, ZFCY2ETA ), 23)) AS cy2_eta    	' + CHAR(10);
		--SET @mEXEC = @MEXEC+' 	  , IIF(ZFCY2ETA = '', null, convert(char(10), convert(datetime, ZFCY2ATA ), 23)) AS cy2_ata    	' + CHAR(10);
		SET @mEXEC = @MEXEC+' 	  , CASE WHEN ZFCY2ETA is null then null WHEN ZFCY2ETA = '''' then null else  convert(char(10), convert(datetime, ZFCY2ETA ), 23) END AS cy2_eta    	' + CHAR(10);
		SET @mEXEC = @MEXEC+' 	  , CASE WHEN ZFCY2ATA is null then null WHEN ZFCY2ATA = '''' then null else  convert(char(10), convert(datetime, ZFCY2ATA ), 23) END AS cy2_ata    	' + CHAR(10);
		SET @mEXEC = @MEXEC+' 	  , ROW_NUMBER() OVER (PARTITION BY COMPANY_ID,SHIPMENT_NO ORDER BY LAST_UPDATE_DATE DESC) AS seq    			' + CHAR(10);
		SET @mEXEC = @MEXEC+' 	  FROM SCM_DNM_DELIVERY_TRACKING WITH (NOLOCK)    									' + CHAR(10);
		SET @mEXEC = @MEXEC+' 	  WHERE COMPANY_ID is not null    										' + CHAR(10);
		SET @mEXEC = @MEXEC+' 	  AND  COMPANY_ID != ''''    											' + CHAR(10);
		SET @mEXEC = @MEXEC+' 	  AND ( ZFCY2 IS NOT NULL     											' + CHAR(10);
		SET @mEXEC = @MEXEC+' 	     OR ZFCY2ETA IS NOT NULL     										' + CHAR(10);
		SET @mEXEC = @MEXEC+' 		 OR ZFCY2ATA IS NOT NULL     										' + CHAR(10);
		SET @mEXEC = @MEXEC+' 		 )    																' + CHAR(10);
		SET @mEXEC = @MEXEC+' 		)  data  where data.seq = 1	   										' + CHAR(10);
		SET @mEXEC = @MEXEC+' 	)    																	' + CHAR(10);

		SET @mEXEC = @MEXEC+' 	, PID as   (																				  ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 				SELECT COMPANY_ID , SHIPMENT_NO, MAX(PLANT_ISSUE_DATE)  AS PLANT_ISSUE_DATE		  ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 	 			  FROM scm_dnm_intransit_c WITH (NOLOCK)    									    			  ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 	 			group by COMPANY_ID, SHIPMENT_NO										    	  ' + CHAR(10);
		SET @mEXEC = @MEXEC+' 		       )	    																	      ' + CHAR(10);

		SET @mEXEC = @MEXEC+' 		SELECT *		    	' + CHAR(10);
		SET @mEXEC = @MEXEC+'   	FROM					' + CHAR(10);
		SET @mEXEC = @MEXEC+'   	(						' + CHAR(10);
		SET @mEXEC = @MEXEC+'   	SELECT convert(char(10), convert(datetime, sdic.result_date), 23) result_date             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		  ,dbo.FN_GET_LOOKUP_CODE_DESC(''SHIPMENT_RESULT_TYPE'', sdic.result_type) AS result_type             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		  ,sdic.division_id             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		  ,CASE sdic.result_type              ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		   WHEN ''S'' THEN ''-''             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		   ELSE dbo.FN_GET_SHIPMENT_NO_DISPLAY(sdic.shipment_no, sdic.result_type)               ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		   END  shipment_no              ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		  ,sdic.project_code             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		  , cp.GROUP_CODE1 AS  CELL_GROUP             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		  , cp.GROUP_CODE2 AS  PACK_GROUP             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		  ,sdic.item_id             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		  ,(SELECT TOP 1 (CASE WHEN X.NICK_NAME IS NULL THEN ''-'' WHEN X.NICK_NAME='''' THEN ''-'' ELSE X.NICK_NAME END) FROM DBO.SCM_MST_ITEM_SN X WITH (NOLOCK) WHERE X.ITEM_ID = sdic.item_id) AS nick_name             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		  ,sdic.plant_id as plant             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		  ,sdic.transport_mode as Trans_Mode             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		  ,dbo.fn_get_item_operation_group(sdic.division_id, sdic.item_id) operation_group             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		  ,sdic.delivery_qty             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		  ,sdic.final_soldto_code	AS customer_code             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		  ,sdic.shipto_code             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		  ,sdic.final_incoterms		AS incoterms             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		  ,sdic.from_scm_site_id             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		  ,sdic.to_scm_site_id             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		  ,smbv.lt_total bod_lead_time             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		  ,IIF(ISNULL(sdic.plant_issue_date,'''')='''','''', convert(char(10), convert(datetime, sdic.plant_issue_date), 23)) as plant_issue_date             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		  ,case when isnull(sdic.pol_atd_date,'''') = '''' then ''''              ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		   else IIF(ISNULL(sdic.pol_atd_date,'''')='''','''', convert(char(10), convert(datetime, sdic.pol_atd_date), 23))             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		  end pol_atd_date             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		  ,case when isnull(sdic.pod_ata_date,'''') = ''''              ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   				then IIF(ISNULL(sdic.pod_eta_date,'''')='''','''', convert(char(10), convert(datetime, sdic.pod_eta_date), 23))             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   				when sdic.pod_ata_date = ''''              ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   				then IIF(ISNULL(sdic.pod_eta_date,'''')='''','''', convert(char(10), convert(datetime, sdic.pod_eta_date), 23))             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		   else convert(char(10), convert(datetime, sdic.pod_ata_date), 23)              ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		   end pod_ata_date             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		  ,case when isnull(sdic.pod_atd_date,'''') = ''''              ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   				then IIF(ISNULL(sdic.pod_etd_date,'''')='''','''', convert(char(10), convert(datetime, sdic.pod_etd_date), 23))             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   				when sdic.pod_atd_date =''''             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   				then IIF(ISNULL(sdic.pod_etd_date,'''')='''','''', convert(char(10), convert(datetime, sdic.pod_etd_date), 23))             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		   else convert(char(10), convert(datetime, sdic.pod_atd_date), 23)              ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		   end pod_atd_date             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		  ,case when isnull(sdic.ATTRIBUTE3,'''')= '''' then ''''              ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   				when sdic.ATTRIBUTE3 ='''' then ''''             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		        else              ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   					CASE              ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   					WHEN convert(char(8), convert(datetime, sdic.ATTRIBUTE3), 112) <  convert(char(8), convert(datetime, sdic.result_date), 112) then convert(char(8), convert(datetime, sdic.result_date), 112)             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   					ELSE convert(char(8), convert(datetime, sdic.ATTRIBUTE3), 112)             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   					END             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   				end f_dest_eta_date             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		  ,case when isnull(sdic.f_dest_eta_date,'''')= '''' then ''''              ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   				when sdic.f_dest_eta_date ='''' then ''''             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		  else convert(char(10), convert(datetime, sdic.f_dest_eta_date), 23) end f_dest_eta_date2             ' + CHAR(10);

		-- 20220819 추가
		--SET @mEXEC = @MEXEC+'       			  ,(select max(port_description) from SCM_MST_PORT WITH (NOLOCK)  where concat(country,port_code) = sdic.POL)              AS pol_port				' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			  ,(select max(port_description) from SCM_MST_PORT WITH (NOLOCK)  where port_code = sdic.POL)              AS pol_port				' + CHAR(10);

		SET @mEXEC = @MEXEC+'       			  ,IIF(ISNULL(sdic.POL_ATD_DATE,'''')='''','''', convert(char(10), convert(datetime, sdic.POL_ATD_DATE), 23))    AS pol_atd					' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			  ,''''					AS pol_etd				' + CHAR(10);
		--SET @mEXEC = @MEXEC+'       			  ,(select max(port_description) from SCM_MST_PORT WITH (NOLOCK)  where concat(country,port_code) = sdic.POD)            AS pod_arrive_port      ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			  ,(select max(port_description) from SCM_MST_PORT WITH (NOLOCK)  where port_code = sdic.POD)            AS pod_arrive_port      ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			  ,IIF(ISNULL(sdic.POD_ETA_DATE    ,'''')='''','''', convert(char(10), convert(datetime, sdic.POD_ETA_DATE    ), 23)) AS pod_arrive_eta     ' + CHAR(10);		 
		SET @mEXEC = @MEXEC+'       			  ,IIF(ISNULL(sdic.POD_ATA_DATE    ,'''')='''','''', convert(char(10), convert(datetime, sdic.POD_ATA_DATE    ), 23)) AS pod_arrive_ata     ' + CHAR(10);		 
		SET @mEXEC = @MEXEC+'       			  ,IIF(ISNULL(sdic.POD_ETD_DATE    ,'''')='''','''', convert(char(10), convert(datetime, sdic.POD_ETD_DATE    ), 23)) AS pod_departure_etd  ' + CHAR(10);		 
		SET @mEXEC = @MEXEC+'       			  ,IIF(ISNULL(sdic.POD_ATD_DATE    ,'''')='''','''', convert(char(10), convert(datetime, sdic.POD_ATD_DATE    ), 23)) AS pod_departure_atd  ' + CHAR(10);		 
		-- 20220825 추가		 
		--SET @mEXEC = @MEXEC+'       			  ,(select max(port_description) from SCM_MST_PORT where concat(country,port_code) = cy2.ZFCY2) AS cy2_port					' + CHAR(10);		 
		--SET @mEXEC = @MEXEC+'       			  ,IIF(ISNULL(sdic.F_DEST_ETA_DATE ,'''')='''','''', convert(char(10), convert(datetime, cy2.ZFCY2ETA ), 23)) AS cy2_eta	' + CHAR(10);	 
		--SET @mEXEC = @MEXEC+'       			  ,IIF(ISNULL(sdic.F_DEST_ATA_DATE ,'''')='''','''', convert(char(10), convert(datetime, cy2.ZFCY2ATA ), 23)) AS cy2_ata	' + CHAR(10);	
		--SET @mEXEC = @MEXEC+'       			  ,(select max(ZFCY2) from SCM_DNM_DELIVERY_TRACKING where COMPANY_ID = sdic.COMPANY_ID AND SHIPMENT_NO = sdic.SHIPMENT_NO)   AS cy2_port									' + CHAR(10);
		--SET @mEXEC = @MEXEC+'       			  ,(select  convert(char(10), convert(datetime, max(ZFCY2ETA) ), 23) from SCM_DNM_DELIVERY_TRACKING where COMPANY_ID = sdic.COMPANY_ID AND SHIPMENT_NO = sdic.SHIPMENT_NO)  AS cy2_eta ' + CHAR(10);	
		--SET @mEXEC = @MEXEC+'       			  ,(select  convert(char(10), convert(datetime, max(ZFCY2ATA) ), 23) from SCM_DNM_DELIVERY_TRACKING where COMPANY_ID = sdic.COMPANY_ID AND SHIPMENT_NO = sdic.SHIPMENT_NO)  AS cy2_ata ' + CHAR(10);	 
		SET @mEXEC = @MEXEC+'       			   ,(select max(cy2_port) from CY2 where COMPANY_ID = sdic.COMPANY_ID AND SHIPMENT_NO = sdic.SHIPMENT_NO and sdic.plant_issue_date  =pid.plant_issue_date)  AS cy2_port		' + CHAR(10);
		SET @mEXEC = @MEXEC+'       			   ,(select max(cy2_eta)  from CY2 where COMPANY_ID = sdic.COMPANY_ID AND SHIPMENT_NO = sdic.SHIPMENT_NO  and sdic.plant_issue_date =pid.plant_issue_date)  AS cy2_eta		' + CHAR(10);	
		SET @mEXEC = @MEXEC+'       			   ,(select max(cy2_ata)  from CY2 where COMPANY_ID = sdic.COMPANY_ID AND SHIPMENT_NO = sdic.SHIPMENT_NO  and sdic.plant_issue_date =pid.plant_issue_date)  AS cy2_ata 		' + CHAR(10);			 
		
		SET @mEXEC = @MEXEC+'   	FROM  scm_dnm_intransit_c sdic  WITH (NOLOCK)            ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   	LEFT JOIN scp_mst_bod_n_v smbv  WITH (NOLOCK)            ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		ON    sdic.division_id = smbv.division_id             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		AND   sdic.from_scm_site_id = smbv.from_site             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		AND   sdic.to_scm_site_id = smbv.to_site             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		AND   ( CASE WHEN ISNULL(sdic.final_incoterms, '''') = '''' THEN sdic.incoterms             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   				ELSE sdic.final_incoterms             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   			   END ) = smbv.incoterms             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		AND   sdic.transport_mode = smbv.transport_mode             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		AND   smbv.bod_valid_yn = ''Y''             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		AND   smbv.route_valid_yn = ''Y''             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		AND sdic.result_date >= smbv.from_yyyymmdd             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		AND sdic.result_date <= smbv.to_yyyymmdd             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'     LEFT JOIN SCP_MST_FINAL_ITEM cp WITH (NOLOCK) on cp.DIVISION_ID = sdic.division_id and  cp.ITEM_ID = sdic.ITEM_ID               ' + CHAR(10);
		SET @mEXEC = @MEXEC+'             left join pid on  pid.COMPANY_ID = sdic.COMPANY_ID AND pid.SHIPMENT_NO = sdic.SHIPMENT_NO  AND pid.plant_issue_date = sdic.plant_issue_date        ' + CHAR(10);
		
		
		
		--SET @mEXEC = @MEXEC+'     LEFT JOIN SCM_DNM_DELIVERY_TRACKING cy2 ON cy2.COMPANY_ID = sdic.COMPANY_ID AND cy2.SHIPMENT_NO = sdic.SHIPMENT_NO   		' + CHAR(10); -- 20220825 CY2			
		SET @mEXEC = @MEXEC+'   	  WHERE 1 = 1																									' + CHAR(10);
		SET @mEXEC = @MEXEC+'   			[@p_division_id]																						' + CHAR(10);


		SET @mEXEC = @MEXEC+'   		[@p_plant_site_id]             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		[@p_sales_site_id]             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		[@p_project_code]				' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		[@p_item_id]					' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		[@p_trans_mode]            ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		[@p_shipment_no]            ' + CHAR(10);
		SET @mEXEC = @MEXEC+'       	[@p_result_date]        ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		AND sdic.RESULT_TYPE in (''I'',''C'',''B'')             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   		AND dbo.fn_get_item_operation_group(sdic.division_id, sdic.item_id) != ''''             ' + CHAR(10);

		IF @p_pack_group = '*' OR @p_pack_group = ''
			BEGIN
			--SET @mEXEC = @MEXEC+' 		AND cp.GROUP_CODE2 IS NULL																												 ' + CHAR(10);
			SET @mEXEC = @MEXEC+' 										' + CHAR(10);
			END
		ELSE
			BEGIN
			SET @mEXEC = @MEXEC+' 		AND cp.GROUP_CODE2			IN ( SELECT token FROM dbo.String_Split([@p_pack_group]	 ,''''))   ' + CHAR(10);
			END

		IF @p_incoterms = '*' OR @p_incoterms = ''
			BEGIN
			SET @mEXEC = @MEXEC+' 	' + CHAR(10);
			END
		ELSE
			BEGIN
			SET @mEXEC = @MEXEC+' 		AND sdic.final_incoterms		IN ( SELECT token FROM dbo.String_Split([@p_incoterms]	 ,''''))   ' + CHAR(10);                                                                                                                           
			END

		SET @mEXEC = @MEXEC+'   	) DATA             ' + CHAR(10);
		SET @mEXEC = @MEXEC+'   	WHERE f_dest_eta_date = [@p_searchdate]             ' + CHAR(10);
		IF @p_operation_group = '*' OR @p_operation_group = ''
			BEGIN
			SET @mEXEC = @MEXEC+' 	' + CHAR(10);
			END
		ELSE
			BEGIN
			SET @mEXEC = @MEXEC+' 		AND operation_group		IN ( SELECT token FROM dbo.String_Split([@p_operation_group]	 ,''''))   ' + CHAR(10);                                                                                                                           
			END	
	
	
		SET @mEXEC = @MEXEC+'   	ORDER BY result_date, result_type, division_id, shipment_no             ' + CHAR(10);


		SET @mEXEC = REPLACE(@mEXEC,'[@p_division_id]'		    , [dbo].[FN_SCM_GET_WHERE_SQL]('sdic.division_id','EQUAL', @p_division_id ));
		SET @mEXEC = REPLACE(@mEXEC,'[@p_plant_site_id]'		, [dbo].[FN_SCM_GET_WHERE_SQL]('sdic.from_scm_site_id', 'LIKE', @p_plant_site_id ));
		SET @mEXEC = REPLACE(@mEXEC,'[@p_sales_site_id]'		, [dbo].[FN_SCM_GET_WHERE_SQL]('sdic.to_scm_site_id', 'LIKE', @p_sales_site_id ));
		SET @mEXEC = REPLACE(@mEXEC,'[@p_project_code]'		    , [dbo].[FN_SCM_GET_WHERE_SQL]('sdic.project_code', 'EQUAL', @p_project_code ));
		SET @mEXEC = REPLACE(@mEXEC,'[@p_item_id]'				, [dbo].[FN_SCM_GET_WHERE_SQL]('sdic.item_id', 'EQUAL', @p_item_id ));
		SET @mEXEC = REPLACE(@mEXEC,'[@p_trans_mode]'			, [dbo].[FN_SCM_GET_WHERE_SQL]('sdic.transport_mode', 'EQUAL', @p_trans_mode ));
		SET @mEXEC = REPLACE(@mEXEC,'[@p_shipment_no]'			, [dbo].[FN_SCM_GET_WHERE_SQL]('sdic.shipment_no', 'LIKE', @p_shipment_no ));
	    SET @mEXEC = REPLACE(@mEXEC,'[@p_result_date]'			, 'AND sdic.result_date BETWEEN '''+@p_from_yyyymmdd+''' AND '''+@p_to_yyyymmdd+''''); -- 20220810
		SET @mEXEC = REPLACE(@mEXEC,'[@p_cell_group]'			, 'N'''+@p_cell_group+'''');
		SET @mEXEC = REPLACE(@mEXEC,'[@p_pack_group]'			, 'N'''+@p_pack_group+'''');
		SET @mEXEC = REPLACE(@mEXEC,'[@p_incoterms]'			, 'N'''+@p_incoterms+'''');
		SET @mEXEC = REPLACE(@mEXEC,'[@p_searchdate]'			, ''''+@p_searchdate+'''');
		SET @mEXEC = REPLACE(@mEXEC,'[@p_operation_group]'		, 'N'''+@p_operation_group+'''');

END

	EXEC (@mEXEC);

    SELECT @mEXEC;

END
