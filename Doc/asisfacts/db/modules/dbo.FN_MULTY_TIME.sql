CREATE FUNCTION [dbo].[FN_MULTY_TIME](@v_time_zone NVARCHAR(6))
/*
 * Program ID   : FN_MULTY_TIME
 * Description  : 멀티 타임
 * 사용방법: SELECT DBO.FN_MULTY_TIME('EU042')		;
 * 부가설명: 매월 주차는 1일 기준으로 돌아오는 같은주 이전 일까지를 1주차로 본다
 * 입력방법: ATTRIBUTE1(국가), ATTRIBUTE2(OFFSET), ATTRIBUTE3(써머타입 적용여부), LOOKUP_CODE(기준코드)
 * 			 시작: ATTRIBUTE4(월), ATTRIBUTE5(주차), ATTRIBUTE6 (요일),ATTRIBUTE7 (시간)
 *           종료: ATTRIBUTE8(월), ATTRIBUTE9(주차), ATTRIBUTE10(요일),ATTRIBUTE11(시간)
 *           ATTRIBUTE5(주차), ATTRIBUTE9(주차) : -1 일 경우 마지막 주차의 요일을 가져온다.
 *			 Summer Time 적용 기준
 *           - 월   : 1 ~ 12
 *           - 주차 : 1 (1주차), 2 (2주차), 3 (3주차), -1 (마지막주차)  -> 1주차 기준 : 해당 월의 일자가 첫번째 일요일인 경우 1주차 ( ex- 3일이 일요일인 경우 3일 주차가 1주차)
 *           - 요일 : 1 (일), 2 (월), 3 (화), 4 (수), 5 (목), 6 (금), 7 (토)
 *           - 시간 : 0 ~ 23
 * Program History
 *===================================================================================================
 *   Date          In Charge      Description
 *===================================================================================================
 * 2017. 11. 27    정원식         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018. 03. 21    ygkim		  
 * - 입력방법 수정, LOOKUP 테이블 변경, 프로시저 신규 작성, 시작, 종료 일자 가져오는 FN_WEEKOFDAY_DATE 함수 추가
 */
RETURNS datetime
AS

BEGIN
	DECLARE @o_time_zone datetime;

	SELECT @o_time_zone = CASE WHEN SUMMERTIME = 'Y' AND SUMMER_TIME_ZONE > END_DATE THEN DATEADD(HOUR, -1, SUMMER_TIME_ZONE) ELSE DATEADD(HOUR, 0, SUMMER_TIME_ZONE) END
	FROM(
		SELECT CASE WHEN SUMMERTIME = 'Y' AND UTCTIME >= START_DATE THEN  DATEADD(HOUR, 1, UTCTIME)
			ELSE UTCTIME END SUMMER_TIME_ZONE, END_DATE, SUMMERTIME
		FROM(
			 SELECT CASE WHEN SUMMERTIME = 'Y' THEN dbo.FN_WEEKOFDAY_DATE(SRT_DATE,START_WEEK,START_DAY) ELSE '' END + ' ' + REPLICATE(0,2 - LEN(START_TIME))+START_TIME + ':00:00' START_DATE
				,CASE WHEN SUMMERTIME = 'Y' THEN dbo.FN_WEEKOFDAY_DATE(END_DATE,END_WEEK,END_DAY) ELSE '' END + ' ' + REPLICATE(0,2 - LEN(END_TIME))+END_TIME + ':00:00' END_DATE
				,UTCTIME, SUMMERTIME, DIFF, GET_DATE
			 FROM(
				  SELECT CONVERT(CHAR(6), DATENAME(YEAR, GETUTCDATE())+REPLICATE(0,2 - LEN(A.ATTRIBUTE4))+A.ATTRIBUTE4) SRT_DATE
					  ,A.ATTRIBUTE5 START_WEEK, A.ATTRIBUTE6 START_DAY, A.ATTRIBUTE7 START_TIME
					  ,DATENAME(YEAR, GETUTCDATE())+REPLICATE(0,2 - LEN(A.ATTRIBUTE8))+A.ATTRIBUTE8 END_DATE
					  ,A.ATTRIBUTE9 END_WEEK, A.ATTRIBUTE10 END_DAY, A.ATTRIBUTE11 END_TIME, A.ATTRIBUTE3 SUMMERTIME, DATEADD(HOUR, CONVERT(INT, A.ATTRIBUTE2), GETUTCDATE()) UTCTIME, A.ATTRIBUTE2 DIFF, GETUTCDATE() GET_DATE
				  FROM SCM_ADM_LOOKUP_MASTER_DETAIL  A
				  WHERE A.SEGMENT1 = isnull(@v_time_zone, 'AS054')
					AND A.LOOKUP_TYPE = 'TIME_ZONE'
					AND A.VALID_YN = 'Y'
			 ) A
		) A	
	) A


	/*
	  SELECT @o_time_zone = 
			CASE  WHEN (STANDARD_TIME >= CONVERT(DATETIME,CONVERT(CHAR(10), (DATEADD(dd, 
										( case (iif(ATTRIBUTE5='-1',S_End_Week,S_Fst_Week))
										  	when 1 then iif((A.ATTRIBUTE6 - 1) >= 7, -7,0)+(A.ATTRIBUTE6 + (iif(ATTRIBUTE5='-1',(-1),((-1) + 7 *(A.ATTRIBUTE5 -1)))))
											when 2 then iif((A.ATTRIBUTE6 + 5) >= 7, -7,0)+(A.ATTRIBUTE6 + (iif(ATTRIBUTE5='-1',(-2),((+5) + 7 *(A.ATTRIBUTE5 -1)))))
											when 3 then iif((A.ATTRIBUTE6 + 4) >= 7, -7,0)+(A.ATTRIBUTE6 + (iif(ATTRIBUTE5='-1',(-3),((+4) + 7 *(A.ATTRIBUTE5 -1)))))
											when 4 then iif((A.ATTRIBUTE6 + 3) >= 7, -7,0)+(A.ATTRIBUTE6 + (iif(ATTRIBUTE5='-1',(-4),((+3) + 7 *(A.ATTRIBUTE5 -1)))))
											when 5 then iif((A.ATTRIBUTE6 + 2) >= 7, -7,0)+(A.ATTRIBUTE6 + (iif(ATTRIBUTE5='-1',(-5),((+2) + 7 *(A.ATTRIBUTE5 -1)))))
											when 6 then iif((A.ATTRIBUTE6 + 1) >= 7, -7,0)+(A.ATTRIBUTE6 + (iif(ATTRIBUTE5='-1',(+0),((+1) + 7 *(A.ATTRIBUTE5 -1)))))
											when 7 then iif((A.ATTRIBUTE6 + 0) >= 7, -7,0)+(A.ATTRIBUTE6 + (iif(ATTRIBUTE5='-1',(+1),((+0) + 7 *(A.ATTRIBUTE5 -1))))) end )+iif(ATTRIBUTE5 = '-1', 0,(7*(ATTRIBUTE5-1)))
												, (iif(ATTRIBUTE5='-1',S_End_Dt,SS_DT)))),120)
								+' '+(REPLICATE('0', 2 - LEN(ATTRIBUTE7))+ ATTRIBUTE7)+':00:00.000')
						AND STANDARD_TIME <= DATEADD(HH,-1.5,CONVERT(DATETIME,CONVERT(CHAR(10), (DATEADD(dd, 
										( case (iif(ATTRIBUTE9='-1',E_End_Week,E_Fst_Week))
										  	when 1 then iif((A.ATTRIBUTE10 - 1) >= 7, -7,0)+(A.ATTRIBUTE10 + (iif(ATTRIBUTE9='-1',(-1),((-1) + 7 *(A.ATTRIBUTE9 -1)))))
											when 2 then iif((A.ATTRIBUTE10 + 5) >= 7, -7,0)+(A.ATTRIBUTE10 + (iif(ATTRIBUTE9='-1',(-2),((+5) + 7 *(A.ATTRIBUTE9 -1)))))
											when 3 then iif((A.ATTRIBUTE10 + 4) >= 7, -7,0)+(A.ATTRIBUTE10 + (iif(ATTRIBUTE9='-1',(-3),((+4) + 7 *(A.ATTRIBUTE9 -1)))))
											when 4 then iif((A.ATTRIBUTE10 + 3) >= 7, -7,0)+(A.ATTRIBUTE10 + (iif(ATTRIBUTE9='-1',(-4),((+3) + 7 *(A.ATTRIBUTE9 -1)))))
											when 5 then iif((A.ATTRIBUTE10 + 2) >= 7, -7,0)+(A.ATTRIBUTE10 + (iif(ATTRIBUTE9='-1',(-5),((+2) + 7 *(A.ATTRIBUTE9 -1)))))
											when 6 then iif((A.ATTRIBUTE10 + 1) >= 7, -7,0)+(A.ATTRIBUTE10 + (iif(ATTRIBUTE9='-1',(+0),((+1) + 7 *(A.ATTRIBUTE9 -1)))))
											when 7 then iif((A.ATTRIBUTE10 + 0) >= 7, -7,0)+(A.ATTRIBUTE10 + (iif(ATTRIBUTE9='-1',(+1),((+0) + 7 *(A.ATTRIBUTE9 -1))))) end )+iif(ATTRIBUTE9 = '-1', 0,(7*(ATTRIBUTE9-1)))
												, (iif(ATTRIBUTE9='-1',E_End_Dt,ES_DT)))),120)
								+' '+(REPLICATE('0', 2 - LEN(ATTRIBUTE11))+ ATTRIBUTE11)+':00:00.000')))
						THEN (iif(ISNULL(A.ATTRIBUTE3,'N')='Y'
								, dateadd( hh, 1, STANDARD_TIME) 
								, dateadd( hh, 0, STANDARD_TIME) 
								)) 
		                ELSE dateadd( hh, 0, STANDARD_TIME) 
						END
		FROM(SELECT dateadd( hh, CONVERT(INT,A1.ATTRIBUTE2), GETUTCDATE() )  AS STANDARD_TIME
						, S_Fst_Dt AS SS_DT 
						, iif (ATTRIBUTE6 = datepart(dw,(DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0
									,(CONVERT(CHAR(4),DATEPART(YEAR,GETUTCDATE()))
									+'-'+CONVERT(CHAR(2),(REPLICATE('0', 2 - LEN(A1.ATTRIBUTE4)) + A1.ATTRIBUTE4))
									+'-01'
									))+1,0))))
								,(DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0
									,(CONVERT(CHAR(4),DATEPART(YEAR,GETUTCDATE()))
									+'-'+CONVERT(CHAR(2),(REPLICATE('0', 2 - LEN(A1.ATTRIBUTE4)) + A1.ATTRIBUTE4))
									+'-01'
									))+1,0))) 
								,DATEADD(Day, (7*(iif(ATTRIBUTE5='-1', S_End_Part, ATTRIBUTE5)-1)), (CONVERT(CHAR(4),DATEPART(YEAR,GETUTCDATE()))
									+'-'+CONVERT(CHAR(2),(REPLICATE('0', 2 - LEN(A1.ATTRIBUTE4)) + A1.ATTRIBUTE4))
									+'-01 ' ))
								) AS SE_DT
						, E_Fst_Dt AS ES_DT
						, iif (ATTRIBUTE10 = datepart(dw,(DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0
									,(CONVERT(CHAR(4),DATEPART(YEAR,GETUTCDATE()))
									+'-'+CONVERT(CHAR(2),(REPLICATE('0', 2 - LEN(A1.ATTRIBUTE8)) + A1.ATTRIBUTE8))
									+'-01'
									))+1,0))))
								,(DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0
									,(CONVERT(CHAR(4),DATEPART(YEAR,GETUTCDATE()))
									+'-'+CONVERT(CHAR(2),(REPLICATE('0', 2 - LEN(A1.ATTRIBUTE8)) + A1.ATTRIBUTE8))
									+'-01'
									))+1,0))) 
								,DATEADD(Day, (7*(iif(ATTRIBUTE9='-1', E_End_Part, ATTRIBUTE9)-1)), (CONVERT(CHAR(4),DATEPART(YEAR,GETUTCDATE()))
									+'-'+CONVERT(CHAR(2),(REPLICATE('0', 2 - LEN(A1.ATTRIBUTE8)) + A1.ATTRIBUTE8))
									+'-01 ' ))
								) AS EE_DT
						, *
					FROM (select (CONVERT(CHAR(4),DATEPART(YEAR,GETUTCDATE()))
																	+'-'+CONVERT(CHAR(2),(REPLICATE('0', 2 - LEN(A1.ATTRIBUTE4)) + A1.ATTRIBUTE4))
																	+'-01 ' )  AS S_Fst_Dt-- 첫날 요일
								, DATEPART(dw, DATEADD(Day, (7*(ATTRIBUTE9-1)), (CONVERT(CHAR(4),DATEPART(YEAR,GETUTCDATE()))
																		+'-'+CONVERT(CHAR(2),(REPLICATE('0', 2 - LEN(A1.ATTRIBUTE4)) + A1.ATTRIBUTE4))
																		+'-01 ' )))   AS S_Fst_Week-- 첫날 요일
								, DATEADD(Day, -1, DATEADD(mm, DATEDIFF(m,0
																		,(CONVERT(CHAR(4),DATEPART(YEAR,GETUTCDATE()))
																		+'-'+CONVERT(CHAR(2),(REPLICATE('0', 2 - LEN(A1.ATTRIBUTE4)) + A1.ATTRIBUTE4))
																		+'-01'
																		))+1,0))  AS S_End_Dt -- 마지막 일자
								, DATEPART(dw, DATEADD (MONTH, DATEDIFF (MONTH, 0,convert(varchar(10)
															, convert(varchar(10), DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0
																,(CONVERT(CHAR(4),DATEPART(YEAR,GETUTCDATE()))
																+'-'+CONVERT(CHAR(2),(REPLICATE('0', 2 - LEN(A1.ATTRIBUTE4)) + A1.ATTRIBUTE4)) 
																+'-01'
																))+1,0)), 120)
															,120)), 0)) AS S_End_Part -- 마지막 주차
								, DATEPART(dw, DATEADD(Day, -1, DATEADD(mm, DATEDIFF(m,0
																		,(CONVERT(CHAR(4),DATEPART(YEAR,GETUTCDATE()))
																		+'-'+CONVERT(CHAR(2),(REPLICATE('0', 2 - LEN(A1.ATTRIBUTE4)) + A1.ATTRIBUTE4))
																		+'-01'
																		))+1,0)))   AS S_End_Week-- 마지막 요일
								, (CONVERT(CHAR(4),DATEPART(YEAR,GETUTCDATE()))
																	+'-'+CONVERT(CHAR(2),(REPLICATE('0', 2 - LEN(A1.ATTRIBUTE8)) + A1.ATTRIBUTE8))
																	+'-01 ' )  AS E_Fst_Dt-- 첫날 요일
								, DATEPART(dw, DATEADD(Day, (7*(ATTRIBUTE9-1)), (CONVERT(CHAR(4),DATEPART(YEAR,GETUTCDATE()))
																		+'-'+CONVERT(CHAR(2),(REPLICATE('0', 2 - LEN(A1.ATTRIBUTE8)) + A1.ATTRIBUTE8))
																		+'-01 ' )))   AS E_Fst_Week-- 첫날 요일
								, DATEADD(Day, -1, DATEADD(mm, DATEDIFF(m,0
																		,(CONVERT(CHAR(4),DATEPART(YEAR,GETUTCDATE()))
																		+'-'+CONVERT(CHAR(2),(REPLICATE('0', 2 - LEN(A1.ATTRIBUTE8)) + A1.ATTRIBUTE8))
																		+'-01'
																		))+1,0))  AS E_End_Week_Dt -- 마지막 주차 일자
								, (DATEPART(dw, DATEADD (MONTH, DATEDIFF (MONTH, 0,convert(varchar(10)
															, convert(varchar(10), DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0
																,(CONVERT(CHAR(4),DATEPART(YEAR,GETUTCDATE()))
																+'-'+CONVERT(CHAR(2),(REPLICATE('0', 2 - LEN(A1.ATTRIBUTE8)) + A1.ATTRIBUTE8)) 
																+'-01'
																))+1,0)), 120)
															,120)), 0)) -1)   AS E_End_Part -- 마지막 주차
								, DATEPART(dw, DATEADD(Day, -1, DATEADD(mm, DATEDIFF(m,0
																		,(CONVERT(CHAR(4),DATEPART(YEAR,GETUTCDATE()))
																		+'-'+CONVERT(CHAR(2),(REPLICATE('0', 2 - LEN(A1.ATTRIBUTE8)) + A1.ATTRIBUTE8))
																		+'-01'
																		))+1,0)))   AS E_End_Week-- 마지막 요일
								, DATEADD(Day, -1, DATEADD(mm, DATEDIFF(m,0
																		,(CONVERT(CHAR(4),DATEPART(YEAR,GETUTCDATE()))
																		+'-'+CONVERT(CHAR(2),(REPLICATE('0', 2 - LEN(A1.ATTRIBUTE8)) + A1.ATTRIBUTE8))
																		+'-01'
																		))+1,0))  AS E_End_Dt -- 마지막 일자
								, *
							--FROM SCM_ADM_LOOKUP_VALUES A1
							--WHERE  A1.LOOKUP_CODE = isnull(@v_time_zone, 'AS054')) A1
							FROM SCM_ADM_LOOKUP_MASTER_DETAIL A1
							WHERE  A1.SEGMENT1 = isnull(@v_time_zone, 'AS054')) A1
					) A
	*/
		;
	RETURN(@o_time_zone);
END
