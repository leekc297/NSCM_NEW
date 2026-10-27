# AS-IS 액션 대조표 — NMM0503

> 원천: `Doc/asisfacts/screens/NMM0503/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 19행 · 메서드 1 · 종류 CALL_EXT 14 · ENDPOINT 2 · UI_PROP 2 · RETURN 1 · ⚠ 의미 확인 필요 14


## NMM0503.FN_NMM0503

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-df88a4c7 | (진입점 미연결) | NMM0503.asmx.cs:38 |  | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-22f01e29 | (진입점 미연결) | NMM0503.asmx.cs:39 |  | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4c3e8f90 | (진입점 미연결) | NMM0503.asmx.cs:51 | try | CALL_EXT | service.SCM_SYS_LOG_BATCH | (program_name, "START", 0, "########## Start of FN_NMM0503 Call ##########", "FN_NMM0503",… | ⚠ 의미 확인 필요 |  |  |  |
| AC-e0be0431 | (진입점 미연결) | NMM0503.asmx.cs:53 | try | CALL_EXT | sql.AddParameter | (SqlDbType.Structured, "@TAB_DISP_MM0503", NMM0503_SEND_TO_SSP.List_NMM0503_TAB_DISP.ListT… | ⚠ 의미 확인 필요 |  |  |  |
| AC-02fb2839 | (진입점 미연결) | NMM0503.asmx.cs:53 | try | CALL_EXT | NMM0503_SEND_TO_SSP.List_NMM0503_TAB_DISP.ListToDataTableEmptyToNull | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-08a4b5a3 | (진입점 미연결) | NMM0503.asmx.cs:54 | try | ENDPOINT | sql.ExcuteProcedure("dbo.PR_SSP_XIF_ERP_SHIP_PO_IN_R").DataTableToList | () ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.PR_SSP_XIF_ERP_SHIP… | 엔드포인트 호출 |  |  |  |
| AC-8e0bd45a | (진입점 미연결) | NMM0503.asmx.cs:54 | try | ENDPOINT | sql.ExcuteProcedure | ("dbo.PR_SSP_XIF_ERP_SHIP_PO_IN_R") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.PR_SSP_XIF_ERP_SHIP… | 엔드포인트 호출 |  |  |  |
| AC-aa45324a | (진입점 미연결) | NMM0503.asmx.cs:55 | try | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3bc26e18 | (진입점 미연결) | NMM0503.asmx.cs:60 | try | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-1925ae06 | (진입점 미연결) | NMM0503.asmx.cs:61 | try | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-24844204 | (진입점 미연결) | NMM0503.asmx.cs:65 | try ▸ if (result.E_TYPE == "E") | CALL_EXT | service.SCM_SYS_LOG_BATCH | (program_name, "ERROR", 1, "########## FN_NMM0503 Call Error - DB ##########", "Result : "… | ⚠ 의미 확인 필요 |  |  |  |
| AC-b6388d8b | (진입점 미연결) | NMM0503.asmx.cs:69 | try ▸ else of (result.E_TYPE == "E") | CALL_EXT | service.SCM_SYS_LOG_BATCH | (program_name, "END", 1, "########## END of FN_NMM0503 Call Success ##########", "Result :… | ⚠ 의미 확인 필요 |  |  |  |
| AC-b12697d4 | (진입점 미연결) | NMM0503.asmx.cs:74 | catch ((Exception ex)) | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-58c6c12d | (진입점 미연결) | NMM0503.asmx.cs:75 | catch ((Exception ex)) | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e9079304 | (진입점 미연결) | NMM0503.asmx.cs:77 | catch ((Exception ex)) | CALL_EXT | service.SCM_SYS_LOG_BATCH | (program_name, "ERROR", 1, "########## FN_NMM0503 Call Error - Source ##########", "ErrorM… | ⚠ 의미 확인 필요 |  |  |  |
| AC-8b7903b3 | (진입점 미연결) | NMM0503.asmx.cs:78 | catch ((Exception ex)) | CALL_EXT | service.SCM_SYS_LOG_BATCH | (program_name, "ERROR", 1, "########## FN_NMM0503 Call Error - DB ##########", "ErrorMSG :… | ⚠ 의미 확인 필요 |  |  |  |
| AC-1f315caa | (진입점 미연결) | NMM0503.asmx.cs:79 | catch ((Exception ex)) | UI_PROP | result.E_TYPE | "E" | 속성 E_TYPE 설정 |  |  |  |
| AC-8247f62b | (진입점 미연결) | NMM0503.asmx.cs:80 | catch ((Exception ex)) | UI_PROP | result.E_MESSAGE | ex.Message.ToString() | 속성 E_MESSAGE 설정 |  |  |  |
| AC-22ce8948 | (진입점 미연결) | NMM0503.asmx.cs:85 |  | RETURN | return result; |  | 처리 중단/반환 |  |  |  |

