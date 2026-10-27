# AS-IS 액션 대조표 — NLE0033

> 원천: `Doc/asisfacts/screens/NLE0033/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 19행 · 메서드 1 · 종류 CALL_EXT 14 · ENDPOINT 2 · UI_PROP 2 · RETURN 1 · ⚠ 의미 확인 필요 14


## NLE0033.FN_NLE0033

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7de8389b | (진입점 미연결) | NLE0033.asmx.cs:39 |  | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5b07623a | (진입점 미연결) | NLE0033.asmx.cs:40 |  | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-92aab236 | (진입점 미연결) | NLE0033.asmx.cs:52 | try | CALL_EXT | service.SCM_SYS_LOG_BATCH | (program_name, "START", 0, "########## Start of FN_NLE0033 Call ##########", "FN_NLE0033",… | ⚠ 의미 확인 필요 |  |  |  |
| AC-0f0b46d4 | (진입점 미연결) | NLE0033.asmx.cs:54 | try | CALL_EXT | sql.AddParameter | (SqlDbType.Structured, "@NSDESSP_0140S", NLE0033_SEND_TO_SCM.List_NSDESSP40S.ListToDataTab… | ⚠ 의미 확인 필요 |  |  |  |
| AC-72e46c16 | (진입점 미연결) | NLE0033.asmx.cs:54 | try | CALL_EXT | NLE0033_SEND_TO_SCM.List_NSDESSP40S.ListToDataTableEmptyToNull | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4b0e5310 | (진입점 미연결) | NLE0033.asmx.cs:55 | try | ENDPOINT | sql.ExcuteProcedure("dbo.PR_GSCM_XIF_SSP_NLE0033_R").DataTableToList | () ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.PR_GSCM_XIF_SSP_NLE… | 엔드포인트 호출 |  |  |  |
| AC-da1d8d91 | (진입점 미연결) | NLE0033.asmx.cs:55 | try | ENDPOINT | sql.ExcuteProcedure | ("dbo.PR_GSCM_XIF_SSP_NLE0033_R") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.PR_GSCM_XIF_SSP_NLE… | 엔드포인트 호출 |  |  |  |
| AC-29211051 | (진입점 미연결) | NLE0033.asmx.cs:56 | try | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4d8eae02 | (진입점 미연결) | NLE0033.asmx.cs:61 | try | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ca0ec0b6 | (진입점 미연결) | NLE0033.asmx.cs:62 | try | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a05feb00 | (진입점 미연결) | NLE0033.asmx.cs:66 | try ▸ if (result.E_TYPE == "E") | CALL_EXT | service.SCM_SYS_LOG_BATCH | (program_name, "ERROR", 1, "########## FN_NLE0033 Call Error - DB ##########", "Result : "… | ⚠ 의미 확인 필요 |  |  |  |
| AC-72f15023 | (진입점 미연결) | NLE0033.asmx.cs:70 | try ▸ else of (result.E_TYPE == "E") | CALL_EXT | service.SCM_SYS_LOG_BATCH | (program_name, "END", 1, "########## END of FN_NLE0033 Call Success ##########", "Result :… | ⚠ 의미 확인 필요 |  |  |  |
| AC-e7e0c2a7 | (진입점 미연결) | NLE0033.asmx.cs:75 | catch ((Exception ex)) | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-540346ec | (진입점 미연결) | NLE0033.asmx.cs:76 | catch ((Exception ex)) | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4ebe94b6 | (진입점 미연결) | NLE0033.asmx.cs:78 | catch ((Exception ex)) | CALL_EXT | service.SCM_SYS_LOG_BATCH | (program_name, "ERROR", 1, "########## FN_NLE0033 Call Error - Source ##########", "ErrorM… | ⚠ 의미 확인 필요 |  |  |  |
| AC-63336de6 | (진입점 미연결) | NLE0033.asmx.cs:79 | catch ((Exception ex)) | CALL_EXT | service.SCM_SYS_LOG_BATCH | (program_name, "ERROR", 1, "########## FN_NLE0033 Call Error - DB ##########", "ErrorMSG :… | ⚠ 의미 확인 필요 |  |  |  |
| AC-d49dc64c | (진입점 미연결) | NLE0033.asmx.cs:80 | catch ((Exception ex)) | UI_PROP | result.E_TYPE | "E" | 속성 E_TYPE 설정 |  |  |  |
| AC-061444cf | (진입점 미연결) | NLE0033.asmx.cs:81 | catch ((Exception ex)) | UI_PROP | result.E_MESSAGE | ex.Message.ToString() | 속성 E_MESSAGE 설정 |  |  |  |
| AC-25fbd00a | (진입점 미연결) | NLE0033.asmx.cs:86 |  | RETURN | return result; |  | 처리 중단/반환 |  |  |  |

