# AS-IS 액션 대조표 — NMM0266

> 원천: `Doc/asisfacts/screens/NMM0266/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 14행 · 메서드 6 · 종류 CALL_EXT 9 · ENDPOINT 2 · UI_PROP 2 · RETURN 1 · ⚠ 의미 확인 필요 9


## NMM0266.BatchLog

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dfcd73e0 | (진입점 미연결) | NMM0266.asmx.cs:124 |  | CALL_EXT | service.SCM_SYS_LOG_BATCH | (program_name, logType, 0, logMessage, logDesc, user_id) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5694d760 | (진입점 미연결) | NMM0266.asmx.cs:128 |  | CALL_EXT | service.SCM_SYS_LOG_BATCH | (program_name, logType, cnt, logMessage, logDesc, user_id) | ⚠ 의미 확인 필요 |  |  |  |

## NMM0266.BatchLogError

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e4872c0 | (진입점 미연결) | NMM0266.asmx.cs:132 |  | CALL_EXT | service.SCM_SYS_LOG_BATCH | (program_name, "ERROR", 1, logMessage, logDesc, user_id) | ⚠ 의미 확인 필요 |  |  |  |

## NMM0266.FN_NMM0266

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9708b641 | (진입점 미연결) | NMM0266.asmx.cs:60 | try ▸ try | CALL_EXT | sql.AddParameter | (SqlDbType.Structured, paramName, NMM0266_SEND_TO_SCM.List_ZNMMSCP_0266S.ListToDataTableEm… | ⚠ 의미 확인 필요 |  |  |  |
| AC-054b042d | (진입점 미연결) | NMM0266.asmx.cs:60 | try ▸ try | CALL_EXT | NMM0266_SEND_TO_SCM.List_ZNMMSCP_0266S.ListToDataTableEmptyToNull | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-eb883d3f | (진입점 미연결) | NMM0266.asmx.cs:61 | try ▸ try | ENDPOINT | sql.ExcuteProcedure(spNameFull).DataTableToList | () ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.PR_GSCM_XIF_MRP_NO_… | 엔드포인트 호출 |  |  |  |
| AC-ccc18187 | (진입점 미연결) | NMM0266.asmx.cs:61 | try ▸ try | ENDPOINT | sql.ExcuteProcedure | (spNameFull) ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.PR_GSCM_XIF_MRP_NO_… | 엔드포인트 호출 |  |  |  |
| AC-68259591 | (진입점 미연결) | NMM0266.asmx.cs:86 | try ▸ catch ((Exception ex)) | UI_PROP | result.E_TYPE | "E" | 속성 E_TYPE 설정 |  |  |  |
| AC-e2e16a42 | (진입점 미연결) | NMM0266.asmx.cs:87 | try ▸ catch ((Exception ex)) | UI_PROP | result.E_MESSAGE | ex.Message.ToString() | 속성 E_MESSAGE 설정 |  |  |  |
| AC-d7a9e57c | (진입점 미연결) | NMM0266.asmx.cs:95 | catch ((Exception ex)) | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-374f05fd | (진입점 미연결) | NMM0266.asmx.cs:99 |  | RETURN | return result; |  | 처리 중단/반환 |  |  |  |

## NMM0266.WriteLog

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-938acd24 | (진입점 미연결) | NMM0266.asmx.cs:107 |  | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |

## NMM0266.WriteLogDebug

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a519caa | (진입점 미연결) | NMM0266.asmx.cs:115 |  | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |

## NMM0266.WriteLogEvent

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d603c6d | (진입점 미연결) | NMM0266.asmx.cs:111 |  | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |

