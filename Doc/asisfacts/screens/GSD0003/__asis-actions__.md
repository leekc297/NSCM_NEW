# AS-IS 액션 대조표 — GSD0003

> 원천: `Doc/asisfacts/screens/GSD0003/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 11행 · 메서드 1 · 종류 CALL_EXT 7 · ENDPOINT 2 · UI_PROP 2 · ⚠ 의미 확인 필요 7


## GSD0003.FN_GSD0003

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb4a4c81 | (진입점 미연결) | GSD0003.asmx.cs:39 |  | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4521d719 | (진입점 미연결) | GSD0003.asmx.cs:40 |  | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b2d3c39c | (진입점 미연결) | GSD0003.asmx.cs:60 | try | CALL_EXT | sql.AddParameter | (SqlDbType.Structured, "@ZSDE1010T", GSD0003_SEND_TO_SCM.List_ZSDE1010T.ListToDataTableEmp… | ⚠ 의미 확인 필요 |  |  |  |
| AC-a05fd315 | (진입점 미연결) | GSD0003.asmx.cs:60 | try | CALL_EXT | GSD0003_SEND_TO_SCM.List_ZSDE1010T.ListToDataTableEmptyToNull | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-515a9414 | (진입점 미연결) | GSD0003.asmx.cs:62 | try | ENDPOINT | sql.ExcuteProcedure("dbo.PR_GSCM_XIF_DM_GSD0003_R").DataTableToList | () ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.PR_GSCM_XIF_DM_GSD0… | 엔드포인트 호출 |  |  |  |
| AC-e8789dba | (진입점 미연결) | GSD0003.asmx.cs:62 | try | ENDPOINT | sql.ExcuteProcedure | ("dbo.PR_GSCM_XIF_DM_GSD0003_R") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.PR_GSCM_XIF_DM_GSD0… | 엔드포인트 호출 |  |  |  |
| AC-79dc1bd8 | (진입점 미연결) | GSD0003.asmx.cs:64 | try | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ee65470a | (진입점 미연결) | GSD0003.asmx.cs:71 | catch ((Exception ex)) | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3a7ccff8 | (진입점 미연결) | GSD0003.asmx.cs:72 | catch ((Exception ex)) | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8d45ba2e | (진입점 미연결) | GSD0003.asmx.cs:75 | catch ((Exception ex)) | UI_PROP | result.E_TYPE | "E" | 속성 E_TYPE 설정 |  |  |  |
| AC-3bc699aa | (진입점 미연결) | GSD0003.asmx.cs:76 | catch ((Exception ex)) | UI_PROP | result.E_MESSAGE | ex.Message.ToString() | 속성 E_MESSAGE 설정 |  |  |  |

