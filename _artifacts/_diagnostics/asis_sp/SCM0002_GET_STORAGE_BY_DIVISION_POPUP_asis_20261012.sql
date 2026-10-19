dbo.SCM0002_GET_STORAGE_BY_DIVISION_POPUP 2023-08-23 03:09:18.997 2026-01-09 10:19:36.567


/*============================================================================================================================
 * Program ID  : SCM0002_GET_STORAGE_BY_DIVISION_POPUP                                                 
 * Description : Procedure 작성 가이드                                                              
 * Usage       : Procedure 작성 시 참조하세요!                                                      
 * Parameter   :                                                                                    
 *                                                                                                  
 *============================================================================================================================
 *	  Date		In Charge	Description                                                             
 *============================================================================================================================
 * 2017/12/05	SongDH		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 
 * 2018/06/20	JYE			STORAGE_DESCRIPTION 추가                                                
 * 2020/02/27	P.C.I		[C20200224-000354] 자동차 사업부 SLOC 조회 시 7990, 7999를 제외한 799*가 조회됨 
 * 2021/03/15	KUNIID		[C20210201-000592] Sales Site _ 가상_보류창고 validation 적용 건	
 * 2026/01/08	JSSBAE		[E20260107-001541]_Sales Site - Sales Location 로직 개선	
============================================================================================================================*/
/*============================================================================================================================
 ※ 작성 Rule 
   1. 대문자, 소문자
      - 테이블, 컬럼, 변수는 소문자로 작성하고, 그 이외는 대문자로 통일
   2. Naming Rule - Prefix
      - 파라메터 : @p_
      - 변수 : 데이타 타입에 따라 @v_(문자), @n_(숫자), @d_(날짜)
   3. 들여쓰기 : 2 space
   4. 기타
      - SQL 수직 배치 : SQL 구문의 세로줄(왼쪽)로 맞춤, 컬럼이나 변수도 KEYWORD 이후 왼쪽 정렬
      - 콤마로 분리된 ID 가 여러 줄에 걸쳐 나올 때, 콤마를 라인의 처음에 위치
============================================================================================================================*/

CREATE PROCEDURE [dbo].[SCM0002_GET_STORAGE_BY_DIVISION_POPUP]  
   @p_division_id		NVARCHAR(1000)
 , @p_storage_id		NVARCHAR(50)
AS

BEGIN	
  SET NOCOUNT ON;  

  SELECT S.DIVISION_ID, D.DIVISION_NAME, S.STORAGE_ID, S.PLANT_ID, S.STORAGE_DESCRIPTION  -- 20180620
    FROM [dbo].[SCM_MST_SLOC]     S WITH(NOLOCK)	
       , [dbo].[SCM_MST_DIVISION] D WITH(NOLOCK)	
   WHERE S.DIVISION_ID = D.DIVISION_ID
-- Modify by ytchoi 180704 소형 VMI A,B 창고 조회 추가.
--  AND    s.STORAGE_ID like '6%'
--  AND    ( s.STORAGE_ID like '6%' OR s.STORAGE_ID like 'A%' OR s.STORAGE_ID like 'B%' )
-- Modify by jsyoun 799A 추가 (김성은책임요청)
-- [C20200224-000354] 자동차 사업부 SLOC 조회 시 7990, 7999를 제외한 799*가 조회됨
     AND ( S.STORAGE_ID LIKE '6%' OR S.STORAGE_ID LIKE 'A%' OR S.STORAGE_ID LIKE 'B%' OR S.STORAGE_ID NOT IN ( '7990', '7999') )
     AND CASE WHEN @p_division_id = 'ALL' THEN 'ALL'
			  ELSE S.DIVISION_ID END IN ( SELECT t.c.value('.', 'NVARCHAR(4000)') FROM ( SELECT x = CAST('<t>' + REPLACE(@p_division_id, ',', '</t><t>') + '</t>' AS xml)) b
										  CROSS APPLY x.nodes('/t') t(c))    
     AND S.STORAGE_ID  LIKE '%' + @p_storage_id + '%' 
-- [C20210201-000592]
     AND NOT EXISTS ( SELECT SEGMENT1 FROM [DBO].[SCM_ADM_LOOKUP_MASTER_DETAIL] LOOK WITH(NOLOCK) 
					   WHERE LOOKUP_TYPE	= 'SALES_SITE_VS_WAREHOUSE' 
						 AND VALID_YN		= 'Y' 
						 AND LOOK.SEGMENT3	= @p_division_id
						 AND LOOK.SEGMENT1	= S.STORAGE_ID ) 
	 --[E20260107-001541]_GERP에서 NERP로 변경되었으므로, VALID_YN을 추가 (START)
     AND S.VALID_YN = 'Y' 
	 --[E20260107-001541]_GERP에서 NERP로 변경되었으므로, VALID_YN을 추가 (END)
END

