# AS-IS 액션 대조표 — GSD0201

> 원천: `Doc/asisfacts/screens/GSD0201/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 19행 · 메서드 1 · 종류 CALL_EXT 14 · ENDPOINT 2 · UI_PROP 2 · RETURN 1 · ⚠ 의미 확인 필요 14


## GSD0201.FN_GSD0201

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-25cad830 | (진입점 미연결) | GSD0201.asmx.cs:50 |  | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a4e74a7c | (진입점 미연결) | GSD0201.asmx.cs:51 |  | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-442dad36 | (진입점 미연결) | GSD0201.asmx.cs:62 | try | CALL_EXT | service.SCM_SYS_LOG_BATCH | (program_name, "START", 0, string.Format("########## Start of {0} Call ##########", progra… | ⚠ 의미 확인 필요 |  |  |  |
| AC-f7a262c0 | (진입점 미연결) | GSD0201.asmx.cs:64 | try | CALL_EXT | sql.AddParameter | (SqlDbType.Structured, paramName, GSD0201_SEND_TO_SCM.List_ZSDGR05700.ListToDataTableEmpty… | ⚠ 의미 확인 필요 |  |  |  |
| AC-11d72dd2 | (진입점 미연결) | GSD0201.asmx.cs:64 | try | CALL_EXT | GSD0201_SEND_TO_SCM.List_ZSDGR05700.ListToDataTableEmptyToNull | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6abc95a6 | (진입점 미연결) | GSD0201.asmx.cs:65 | try | ENDPOINT | sql.ExcuteProcedure(spNameFull).DataTableToList | () ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.PR_GSCM_XIF_SCP_SD0… | 엔드포인트 호출 |  |  |  |
| AC-c50ce60e | (진입점 미연결) | GSD0201.asmx.cs:65 | try | ENDPOINT | sql.ExcuteProcedure | (spNameFull) ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.PR_GSCM_XIF_SCP_SD0… | 엔드포인트 호출 |  |  |  |
| AC-8bc58e70 | (진입점 미연결) | GSD0201.asmx.cs:66 | try | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b4611f4c | (진입점 미연결) | GSD0201.asmx.cs:71 | try | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-57fb74f5 | (진입점 미연결) | GSD0201.asmx.cs:72 | try | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-23f8ceb9 | (진입점 미연결) | GSD0201.asmx.cs:76 | try ▸ if (result.E_TYPE == "E") | CALL_EXT | service.SCM_SYS_LOG_BATCH | (program_name , "ERROR" , 1 , string.Format("########## {0} Call Error - DB ##########", p… | ⚠ 의미 확인 필요 |  |  |  |
| AC-0adc8a9b | (진입점 미연결) | GSD0201.asmx.cs:85 | try ▸ else of (result.E_TYPE == "E") | CALL_EXT | service.SCM_SYS_LOG_BATCH | (program_name , "END" , 1 , string.Format("########## END of {0} Call Success ##########",… | ⚠ 의미 확인 필요 |  |  |  |
| AC-5588a88d | (진입점 미연결) | GSD0201.asmx.cs:95 | catch ((Exception ex)) | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3e732277 | (진입점 미연결) | GSD0201.asmx.cs:96 | catch ((Exception ex)) | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e6fa3641 | (진입점 미연결) | GSD0201.asmx.cs:98 | catch ((Exception ex)) | CALL_EXT | service.SCM_SYS_LOG_BATCH | (program_name , "ERROR" , 1 , string.Format("########## {0} Call Error - Source ##########… | ⚠ 의미 확인 필요 |  |  |  |
| AC-f058186b | (진입점 미연결) | GSD0201.asmx.cs:104 | catch ((Exception ex)) | CALL_EXT | service.SCM_SYS_LOG_BATCH | (program_name , "ERROR" , 1 , string.Format("########## {0} Call Error - DB ##########", p… | ⚠ 의미 확인 필요 |  |  |  |
| AC-23ebc5f4 | (진입점 미연결) | GSD0201.asmx.cs:110 | catch ((Exception ex)) | UI_PROP | result.E_TYPE | "E" | 속성 E_TYPE 설정 |  |  |  |
| AC-6bab6850 | (진입점 미연결) | GSD0201.asmx.cs:111 | catch ((Exception ex)) | UI_PROP | result.E_MESSAGE | ex.Message.ToString() | 속성 E_MESSAGE 설정 |  |  |  |
| AC-b2b51ce6 | (진입점 미연결) | GSD0201.asmx.cs:116 |  | RETURN | return result; |  | 처리 중단/반환 |  |  |  |

