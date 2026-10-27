
CREATE 
--create
FUNCTION  [dbo].[FN_GET_CELL_PRODUCT_ITEM_ID]
(
	@P_COMPANY_ID		NVARCHAR(100),
	@P_DIVISIOIN_ID		NVARCHAR(100),
	@P_SITE_ID			NVARCHAR(100),
	@P_CELL_ASSY_ITEM_ID	NVARCHAR(100)
)
RETURNS NVARCHAR(100)
AS
/*********************************************************************************************/
/** 프로그램 ID   	: FN_GET_CELL_PRODUCT_ITEM_ID                                  			**/
/** 프로그램 명   	: FN_GET_CELL_PRODUCT_ITEM_ID 		                             		**/
/** 설       명	 	: 																		**/
/** VERSION			:	V1.0.0									        					**/
/** ARGUMENT   		:																		**/
/**	@P_COMPANY_ID	: COMPANY_ID															**/
/**	@P_DIVISIOIN_ID	: DIVISIOIN_ID															**/
/**	@P_SITE_ID		: SITE_ID																**/
/**	@P_CELL_ASSY_ITEM_ID	: @P_CELL_ASSY_ITEM_ID											**/
/** LOGIC    		:										        			     		**/
/**-----------------------------------------------------------------------------------------**/
/** 작 성 일 자		작 성 자			사	   유											**/
/**=========================================================================================**/
/** 2023.06.08		HMKWAK		CELL_ASSY_ITEM_ID를 통해 CELL_PRODUCT_ITEM_ID를 가져오기 위한 함수 생성	*/
/*								P_CELL_ASSY_ITEM_ID에 CELL_PRODUCT_ITEM_ID 입력 시, CELL_PRODUCT_ITEM_ID를 반환 */
/*********************************************************************************************/
/*
	SELECT DBO.FN_GET_CELL_PRODUCT_ITEM_ID('C100','81','A001','ACLN1010I-A1-100_ASSY' ) 
	조회 결과 : ACLN1010I-A1-100
*/
BEGIN
	DECLARE	@V_CELL_PRODUCT_ITEM_ID				NVARCHAR(100)
	
	IF EXISTS (
				SELECT  MAX(A.APPLIED_MODEL) --as CELL_PRODUCT_ITEM_ID
				FROM SCM_ITEM_M A
				WHERE 1=1
				AND A.COMPANY_ID			=	@P_COMPANY_ID
				AND A.DIVISION_ID			=	@P_DIVISIOIN_ID
				AND A.SITE_ID				=	@P_SITE_ID
				AND A.ITEM_ID				=	@P_CELL_ASSY_ITEM_ID
				AND A.ITEM_CLASS			= 'ES1901' -- Cell Assy class code 
				GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID
	) 
	BEGIN
			SELECT @V_CELL_PRODUCT_ITEM_ID = max(A.APPLIED_MODEL) --as CELL_PRODUCT_ITEM_ID
			FROM LGCE_FPDEV_TR.DBO.SCM_ITEM_M A
			WHERE 1=1
			AND A.COMPANY_ID			=	@P_COMPANY_ID
			AND A.DIVISION_ID			=	@P_DIVISIOIN_ID
			AND A.SITE_ID				=	@P_SITE_ID
			AND A.ITEM_ID				=	@P_CELL_ASSY_ITEM_ID
			AND A.ITEM_CLASS			= 'ES1901' -- Cell Assy class code 
			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID

  	END
	ELSE 
	BEGIN 
		SET @V_CELL_PRODUCT_ITEM_ID = @P_CELL_ASSY_ITEM_ID
	END
	RETURN @V_CELL_PRODUCT_ITEM_ID
END
