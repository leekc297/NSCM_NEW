/*
 * Program ID   : PR_SCP_MST_BOD_HIST
 * Description  : Tac TIme Master History 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.03.27   byunghunjung      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020/09/01   KSW             PJ20202001R    LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : 법인간 거래 Incoterms 동기화
 *                              SSP용 Incoterms 컬럼 추가 <== SCP_MST_BOD.attribute1
 * 2021/05/10   khj79           [PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선 - BOD LT 1단계 개발(BEFORE_LEAD_TIME, AFTER_LEAD_TIME,REMARKS 추가)
 * 2021/06/10   khj79           [PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선 - BOD LT 2단계 개발(FROM_YYYYMMDD, TO_YYYYMMDD 추가)
 * 
 */
CREATE PROCEDURE [dbo].[PR_SCP_MST_BOD_HIST]
 @p_bod_id				NVARCHAR(MAX)
,@p_division_id			NVARCHAR(MAX)
,@p_from_site			NVARCHAR(MAX)
,@p_to_site				NVARCHAR(MAX)
,@p_incoterms			NVARCHAR(MAX)
,@p_incoterms_ssp		NVARCHAR(MAX)         -- SSP용 Incoterms 추가
,@p_safety_stock		NVARCHAR(MAX)
,@p_priority			NVARCHAR(MAX)
,@p_route_id			NVARCHAR(MAX)
,@p_valid_yn			NVARCHAR(MAX)
,@p_from_yyyymmdd		NVARCHAR(MAX)
,@p_to_yyyymmdd			NVARCHAR(MAX)
,@p_before_lead_time	NVARCHAR(MAX)
,@p_after_lead_time		NVARCHAR(MAX)
,@p_remarks				NVARCHAR(MAX)
,@p_created_by			NVARCHAR(MAX)
,@p_creation_date		DATETIME
,@p_last_updated_by		NVARCHAR(MAX)
,@p_last_update_date	DATETIME

AS

BEGIN

	--SET NOCOUNT ON;
	--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @v_history_seq nvarchar(100);
	
		BEGIN    
			SET @v_history_seq = NEXT VALUE FOR SEQ1_SCP_MST_BOD_H
				
			SET	@p_safety_stock = (case when @p_safety_stock='' then null else @p_safety_stock end);
			
			INSERT INTO dbo.SCP_MST_BOD_H
					   (
						HISTORY_SEQ
					   ,BOD_ID
					   ,DIVISION_ID
					   ,FROM_SITE
					   ,TO_SITE
					   ,INCOTERMS
					   ,ATTRIBUTE1                -- SSP용 Incoterms 추가
					   ,SAFETY_STOCK
					   ,PRIORITY
					   ,ROUTE_ID
					   ,VALID_YN
					   ,ATTRIBUTE2
					   ,ATTRIBUTE3
					   ,ATTRIBUTE4
					   ,ATTRIBUTE5
					   ,ATTRIBUTE6
					   ,CREATED_BY
					   ,CREATION_DATE
					   ,LAST_UPDATED_BY
					   ,LAST_UPDATE_DATE
					   ,HISTORY_CREATION_DATE
					   )
				 VALUES
					   (
						@v_history_seq                   																			
					   ,@p_bod_id                        																			
					   ,@p_division_id                   																			
					   ,@p_from_site                     																			
					   ,@p_to_site                       																			
					   ,@p_incoterms        
					   ,@p_incoterms_ssp         -- SSP용 Incoterms 추가
					   ,@p_safety_stock                  																			
					   ,@p_priority                      																			
					   ,@p_route_id                      																			
					   ,@p_valid_yn
					   ,@p_from_yyyymmdd
					   ,@p_to_yyyymmdd
					   ,@p_before_lead_time
					   ,@p_after_lead_time
					   ,@p_remarks
					   ,@p_created_by                    																			
					   ,@p_creation_date                 																			
					   ,@p_last_updated_by               																			
					   ,@p_last_update_date              																			
					   ,SYSDATETIME()  
					   );
		END

	END;

