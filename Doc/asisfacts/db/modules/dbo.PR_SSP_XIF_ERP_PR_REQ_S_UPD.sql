/*
 * Program ID   : PR_SSP_XIF_ERP_SHIP_PLAN_CONFIRM_S_UPD
 * Description  : 출하계획 전송결과 UPDATE
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/05/04   PJS    Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 *
 */

create  PROCEDURE [dbo].[PR_SSP_XIF_ERP_PR_REQ_S_UPD]
    @XIF_ERP_PR_REQ_S_UPD  AS DBO.XIF_ERP_PR_REQ_S_UPD       READONLY
	                            
AS

BEGIN

SET NOCOUNT ON;

        DECLARE @TRANSFER_DATE        DATETIME         = GETDATE();    
        DECLARE @TRANSFER_FLAG        NVARCHAR(50)  = 'Y';

        DECLARE @E_TYPE               NVARCHAR(50)  = N'S'; --메시지 유형: S 성공, E 오류
        DECLARE @E_MESSAGE            NVARCHAR(100) = N'SUCCESS';

        BEGIN TRY
			BEGIN TRAN
            

				 UPDATE A
				   SET IF_FLAG		= @TRANSFER_FLAG
					  , IF_SND_DATE = @TRANSFER_DATE
				  FROM dbo.XIF_ERP_PR_REQ_S_SN	    AS A WITH(NOLOCK) 
					   INNER JOIN @XIF_ERP_PR_REQ_S_UPD	AS B
					ON A.IFSEQNO	  = B.IFSEQNO  
					;

			
			 COMMIT TRAN;
        END TRY

        BEGIN CATCH
               ROLLBACK TRAN;
               --PRINT ERROR_MESSAGE();
               SET @E_TYPE = 'E';
               SET @E_MESSAGE = ERROR_MESSAGE();
        END CATCH      

        SELECT @E_TYPE AS E_TYPE, @E_MESSAGE AS E_MESSAGE

        SET NOCOUNT OFF

END

