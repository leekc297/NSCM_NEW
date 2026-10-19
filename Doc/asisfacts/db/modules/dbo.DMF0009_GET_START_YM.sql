

/*
 * Program ID   : DMF0009_GET_START_YM
 * Description  :DMF0010_BizPlanPrice(메탈 판가 등록 화면)의 메저 계산을 위한 분기 및 반기 시작연월 반환
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023/07/31	ilovu1			Initial Release 사업계획 프로젝트
 * 2023/09/19   ilovu1		    @p_METAL_LINK_START_MONTH 추가
 * 2023/09/21   ilovu1		    Compile
 */
 --drop function dbo.fn_lpad;
--select dbo.DMF0009_GET_START_YM('H', '202401') f1;
CREATE function [dbo].[DMF0009_GET_START_YM]
(
	  @p_GUBUN					varchar(1)	--반기(H)/분기(Q) 구분
    , @p_METAL_LINK_START_MONTH nvarchar(3)	--동일값(Metal Index(Cur)) 기간 시작연월
	, @p_YM						varchar(6)	--연월
) returns varchar(6)
as
begin
	declare @v_YM varchar(6);
	select @v_YM =
	       case @p_GUBUN
				when 'H' then
					case @p_METAL_LINK_START_MONTH
						when 'JAN' then
							case 
								when substring(@p_YM, 5, 2) in ('01', '02', '03', '04', '05', '06') then substring(@p_YM, 1, 4) + '01'
								when substring(@p_YM, 5, 2) in ('07', '08', '09', '10', '11', '12') then substring(@p_YM, 1, 4) + '07'
							end
						when 'FEB' then
							case 
								when substring(@p_YM, 5, 2) in ('02', '03', '04', '05', '06', '07') then substring(@p_YM, 1, 4) + '02'
								when substring(@p_YM, 5, 2) in ('08', '09', '10', '11', '12'      ) then substring(@p_YM, 1, 4) + '08'
								when substring(@p_YM, 5, 2) = '01'                                  then FORMAT(DATEADD(YEAR, -1, @p_YM + '01'), 'yyyy') + '08'
							end
						when 'MAR' then
							case 
								when substring(@p_YM, 5, 2) in ('03', '04', '05', '06', '07', '08') then substring(@p_YM, 1, 4) + '03'
								when substring(@p_YM, 5, 2) in ('09', '10', '11', '12'            ) then substring(@p_YM, 1, 4) + '09'
								when substring(@p_YM, 5, 2) in ('01', '02')                         then FORMAT(DATEADD(YEAR, -1, @p_YM + '01'), 'yyyy') + '09'
							end
						when 'APR' then
							case 
								when substring(@p_YM, 5, 2) in ('04', '05', '06', '07', '08', '09') then substring(@p_YM, 1, 4) + '04'
								when substring(@p_YM, 5, 2) in ('10', '11', '12'                  ) then substring(@p_YM, 1, 4) + '10'
								when substring(@p_YM, 5, 2) in ('01', '02', '03')                   then FORMAT(DATEADD(YEAR, -1, @p_YM + '01'), 'yyyy') + '10'
							end
						when 'MAY' then
							case 
								when substring(@p_YM, 5, 2) in ('05', '06', '07', '08', '09', '10') then substring(@p_YM, 1, 4) + '05'
								when substring(@p_YM, 5, 2) in ('11', '12'                        ) then substring(@p_YM, 1, 4) + '11'
								when substring(@p_YM, 5, 2) in ('01', '02', '03', '04')             then FORMAT(DATEADD(YEAR, -1, @p_YM + '01'), 'yyyy') + '11'
							end
						when 'JUN' then
							case 
								when substring(@p_YM, 5, 2) in ('06', '07', '08', '09', '10', '11') then substring(@p_YM, 1, 4) + '06'
								when substring(@p_YM, 5, 2) in ('12'                              ) then substring(@p_YM, 1, 4) + '12'
								when substring(@p_YM, 5, 2) in ('01', '02', '03', '04', '05')       then FORMAT(DATEADD(YEAR, -1, @p_YM + '01'), 'yyyy') + '12'
							end
					end--//case @p_METAL_LINK_START_MONTH
				when 'Q' then
					case @p_METAL_LINK_START_MONTH
						when 'JAN' then
							case 
								when substring(@p_YM, 5, 2) in ('01', '02', '03') then substring(@p_YM, 1, 4) + '01'
								when substring(@p_YM, 5, 2) in ('04', '05', '06') then substring(@p_YM, 1, 4) + '04'
								when substring(@p_YM, 5, 2) in ('07', '08', '09') then substring(@p_YM, 1, 4) + '07'
								when substring(@p_YM, 5, 2) in ('10', '11', '12') then substring(@p_YM, 1, 4) + '10'
							end			
						when 'FEB' then
							case 
								when substring(@p_YM, 5, 2) in ('02', '03', '04') then substring(@p_YM, 1, 4) + '02'
								when substring(@p_YM, 5, 2) in ('05', '06', '07') then substring(@p_YM, 1, 4) + '05'
								when substring(@p_YM, 5, 2) in ('08', '09', '10') then substring(@p_YM, 1, 4) + '08'
								when substring(@p_YM, 5, 2) in ('11', '12')       then substring(@p_YM, 1, 4) + '11'
								when substring(@p_YM, 5, 2) = '01'                then FORMAT(DATEADD(YEAR, -1, @p_YM + '01'), 'yyyy') + '11'
							end
						when 'MAR' then
							case 
								when substring(@p_YM, 5, 2) in ('03', '04', '05') then substring(@p_YM, 1, 4) + '03'
								when substring(@p_YM, 5, 2) in ('06', '07', '08') then substring(@p_YM, 1, 4) + '06'
								when substring(@p_YM, 5, 2) in ('09', '10', '11') then substring(@p_YM, 1, 4) + '09'
								when substring(@p_YM, 5, 2) in ('12')             then substring(@p_YM, 1, 4) + '12'
								when substring(@p_YM, 5, 2) in ('01', '02')       then FORMAT(DATEADD(YEAR, -1, @p_YM + '01'), 'yyyy') + '12'
							end
					end--//case @p_METAL_LINK_START_MONTH
	       end;
		
		return (@v_YM);
end;
