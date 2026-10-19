

/*
 * Program ID   : PR_SCP_ANL_MAT_SUPPLY
 * Description  : 자재 제약 가시화 집계 => SCP_ANL_MAT_SUPPLY 에 저장
 * Program History
 *================================================================================================================================================
 *   Date       In Charge                           Description
 *================================================================================================================================================
 * 2023/11/07	chaan					V1.1.9		PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Initial release
 * 2023/11/09	chaan					V1.1.10		PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - 재고 로직 개선
 * 2023/11/10	chaan					V1.1.11		PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - 집계 로직 수정
 * 2023/11/13	chaan					V1.1.13		PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - P, I NICKNAME => '-' 로 고정
 *                                                  PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - I 반제품 전개후 재고적용
 * 2023/11/30	chaan					V1.1.14		PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - EE 사업부 집계 추가
 * 2023/11/30	chaan					V1.1.15		PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - EE 사업부 집계 로직 수정
 * 2023/12/07	chaan					V1.1.16		PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Operation Group 추가
 * 2023/12/19	chaan					V1.1.17		PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - PROD_PLAN_AMEND, REQUIREMENT 도 Supplier 정보 연결
 * 2024/01/16	chaan					V1.1.18		PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - SEMI CELL_CF 환산 로직 수정(1순위만 취합 => SCM_MST_BOM_SN.ALT_PRIORITY = 'Y')
 * 2024/01/18	chaan					V1.2.1		PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - 집계일자를 특정해서 집계하기 위해 프로시저 분리
 *
 */


--CREATE PROCEDURE [dbo].[PR_SCP_ANL_MAT_SUPPLY]
CREATE PROCEDURE [dbo].[PR_SCP_ANL_MAT_SUPPLY]
AS
BEGIN
	EXEC [dbo].[PR_SCP_ANL_MAT_SUPPLY_BATCH] '', '';
END
