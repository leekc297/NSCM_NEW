/*
 * Program ID   : PR_SSP_XIF_SCS_PACK_SHIP_PLAN_MOD_R
 * Description  : 출하계획 수신
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/01/11   kimbk          SCS Packer 출하 계획 수신정보 처리
 *
 */

CREATE PROCEDURE [dbo].[PR_SSP_XIF_SCS_PACK_SHIP_PLAN_MOD_R]
( 
     @IF_ID                     NVARCHAR(50)
    ,@O_ERRFLAG                 NVARCHAR(50)  OUTPUT
    ,@O_ERRDESC                 NVARCHAR(200) OUTPUT
) AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @IFSEQNO              NVARCHAR(14) = '';
    DECLARE @TRANSFER_DATE        DATETIME         = GETDATE();    
    DECLARE @TRANSFER_FLAG        NVARCHAR(50)  = 'N';

    DECLARE @E_TYPE               NVARCHAR(50)  = N'S'; --메시지 유형: S 성공, E 오류
    DECLARE @E_MESSAGE            NVARCHAR(100) = N'SUCCESS';

	-----------------------------------------------------------
	-- PREPROCESSING
	-----------------------------------------------------------
	SET @IF_ID						= 'OSCS_OSCM_SCS_PACK_SHIP_PLAN_MOD';
	SET @O_ERRFLAG					= ''
	SET @O_ERRDESC					= '' 

    BEGIN TRY
		BEGIN TRAN
               
			------------------------------------------------------------------------------
			-- SCS I/F DATA 처리를 위한 UPDATE 수행
			------------------------------------------------------------------------------
			UPDATE XIF_SCS_PACK_SHIP_PLAN_MOD_R_SN
			   SET PROC_FLAG = 'P'
			 WHERE 1 = 1
			   AND PROC_FLAG = 'N'
			;

			------------------------------------------------------------------------------
			-- SCS I/F DATA 를 기준으로 PACK REQ 정보 UPDATE
			-- ATTRIBUTE2 : SCS IF SEQ
			-- ATTRIBUTE3 : RTF ( Y : 전체 가능 / P : 날짜 또는 수량 변경 / N : 출하불가 )
			-- ATTRIBUTE4 : RTF_EDT ( 출하 일자 )
			-- ATTRIBUTE5 : RTF_QTY ( 출하 수량 )
			-- ATTRIBUTE6 : RTF_DETAIL ( 출하 관련 적요 )
			------------------------------------------------------------------------------
			UPDATE A
			   SET A.ATTRIBUTE2 = B.IF_SEQ
			     , A.ATTRIBUTE3 = B.RTF       -- Y : 전체 가능 / P : 날짜 또는 수량 변경 / N : 출하불가
			     , A.ATTRIBUTE4 = B.RTF_EDT
			     , A.ATTRIBUTE5 = B.RTF_QTY
			     , A.ATTRIBUTE6 = B.RTF_DETAIL
			  FROM SSP_ANL_SHIP_REQ_P AS A WITH(NOLOCK)
				   JOIN (
						SELECT A.IF_SEQ
							 , A.RTF
							 , A.RTF_EDT
							 , A.RTF_QTY
							 , A.RTF_DETAIL
							 , A.REQ_ID      AS REQUEST_ID
						  FROM XIF_SCS_PACK_SHIP_PLAN_MOD_R_SN   A WITH(NOLOCK)
							   JOIN (
									SELECT MAX(B.IF_SEQ) AS IF_SEQ
										 , B.REQ_ID
									  FROM XIF_SCS_PACK_SHIP_PLAN_MOD_R_SN   B WITH(NOLOCK)
									 WHERE 1 = 1
									   AND B.PROC_FLAG = 'P'
									 GROUP BY B.REQ_ID
									) B
						    ON B.IF_SEQ = A.IF_SEQ
						   AND B.REQ_ID = A.REQ_ID
						 WHERE 1 = 1
						   AND A.PROC_FLAG = 'P'
						) B
					 ON B.REQUEST_ID = A.REQUEST_ID
			 WHERE 1 = 1
			;
			------------------------------------------------------------------------------
			-- SCS I/F DATA 처리를 완료 UPDATE 수행
			------------------------------------------------------------------------------
			UPDATE XIF_SCS_PACK_SHIP_PLAN_MOD_R_SN
			   SET PROC_FLAG = 'Y'
			 WHERE 1 = 1
			   AND PROC_FLAG = 'P'
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

