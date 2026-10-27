# AS-IS 액션 대조표 — MM0502

> 원천: `Doc/asisfacts/screens/MM0502/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 19행 · 메서드 1 · 종류 CALL_EXT 14 · ENDPOINT 2 · UI_PROP 2 · RETURN 1 · ⚠ 의미 확인 필요 14


## MM0502.FN_MM0502

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-005468af | (진입점 미연결) | MM0502.asmx.cs:38 |  | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e4694653 | (진입점 미연결) | MM0502.asmx.cs:39 |  | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-bce245cc | (진입점 미연결) | MM0502.asmx.cs:51 | try | CALL_EXT | service.SCM_SYS_LOG_BATCH | (program_name, "START", 0, "########## Start of FN_MM0502 Call ##########", "FN_MM0502", u… | ⚠ 의미 확인 필요 |  |  |  |
| AC-73e94147 | (진입점 미연결) | MM0502.asmx.cs:53 | try | CALL_EXT | sql.AddParameter | (SqlDbType.Structured, "@TAB_DISP_MM0502", MM0502_SEND_TO_SSP.List_MM0502_TAB_DISP.ListToD… | ⚠ 의미 확인 필요 |  |  |  |
| AC-7e9e4307 | (진입점 미연결) | MM0502.asmx.cs:53 | try | CALL_EXT | MM0502_SEND_TO_SSP.List_MM0502_TAB_DISP.ListToDataTableEmptyToNull | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-36c1021c | (진입점 미연결) | MM0502.asmx.cs:54 | try | ENDPOINT | sql.ExcuteProcedure("dbo.PR_SSP_XIF_ERP_SHIP_PO_R").DataTableToList | () ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.PR_SSP_XIF_ERP_SHIP… | 엔드포인트 호출 |  |  |  |
| AC-b6e9b3c0 | (진입점 미연결) | MM0502.asmx.cs:54 | try | ENDPOINT | sql.ExcuteProcedure | ("dbo.PR_SSP_XIF_ERP_SHIP_PO_R") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.PR_SSP_XIF_ERP_SHIP… | 엔드포인트 호출 |  |  |  |
| AC-820d35a9 | (진입점 미연결) | MM0502.asmx.cs:55 | try | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-db4a6a75 | (진입점 미연결) | MM0502.asmx.cs:60 | try | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-089c21de | (진입점 미연결) | MM0502.asmx.cs:61 | try | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2d75a963 | (진입점 미연결) | MM0502.asmx.cs:65 | try ▸ if (result.E_TYPE == "E") | CALL_EXT | service.SCM_SYS_LOG_BATCH | (program_name, "ERROR", 1, "########## FN_MM0502 Call Error - DB ##########", "Result : " … | ⚠ 의미 확인 필요 |  |  |  |
| AC-0bef226e | (진입점 미연결) | MM0502.asmx.cs:69 | try ▸ else of (result.E_TYPE == "E") | CALL_EXT | service.SCM_SYS_LOG_BATCH | (program_name, "END", 1, "########## END of FN_MM0502 Call Success ##########", "Result : … | ⚠ 의미 확인 필요 |  |  |  |
| AC-c0b5531d | (진입점 미연결) | MM0502.asmx.cs:74 | catch ((Exception ex)) | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4a75ec07 | (진입점 미연결) | MM0502.asmx.cs:75 | catch ((Exception ex)) | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d6f4241b | (진입점 미연결) | MM0502.asmx.cs:77 | catch ((Exception ex)) | CALL_EXT | service.SCM_SYS_LOG_BATCH | (program_name, "ERROR", 1, "########## FN_MM0502 Call Error - Source ##########", "ErrorMS… | ⚠ 의미 확인 필요 |  |  |  |
| AC-c95fded6 | (진입점 미연결) | MM0502.asmx.cs:78 | catch ((Exception ex)) | CALL_EXT | service.SCM_SYS_LOG_BATCH | (program_name, "ERROR", 1, "########## FN_MM0502 Call Error - DB ##########", "ErrorMSG : … | ⚠ 의미 확인 필요 |  |  |  |
| AC-1366c521 | (진입점 미연결) | MM0502.asmx.cs:79 | catch ((Exception ex)) | UI_PROP | result.E_TYPE | "E" | 속성 E_TYPE 설정 |  |  |  |
| AC-d4ede991 | (진입점 미연결) | MM0502.asmx.cs:80 | catch ((Exception ex)) | UI_PROP | result.E_MESSAGE | ex.Message.ToString() | 속성 E_MESSAGE 설정 |  |  |  |
| AC-6e820b41 | (진입점 미연결) | MM0502.asmx.cs:85 |  | RETURN | return result; |  | 처리 중단/반환 |  |  |  |

