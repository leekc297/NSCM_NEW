# AS-IS 액션 대조표 — NMM0270

> 원천: `Doc/asisfacts/screens/NMM0270/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 14행 · 메서드 6 · 종류 CALL_EXT 9 · ENDPOINT 2 · UI_PROP 2 · RETURN 1 · ⚠ 의미 확인 필요 9


## NMM0270.BatchLog

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7388a25 | (진입점 미연결) | NMM0270.asmx.cs:124 |  | CALL_EXT | service.SCM_SYS_LOG_BATCH | (program_name, logType, 0, logMessage, logDesc, user_id) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a09d6007 | (진입점 미연결) | NMM0270.asmx.cs:128 |  | CALL_EXT | service.SCM_SYS_LOG_BATCH | (program_name, logType, cnt, logMessage, logDesc, user_id) | ⚠ 의미 확인 필요 |  |  |  |

## NMM0270.BatchLogError

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d8200cee | (진입점 미연결) | NMM0270.asmx.cs:132 |  | CALL_EXT | service.SCM_SYS_LOG_BATCH | (program_name, "ERROR", 1, logMessage, logDesc, user_id) | ⚠ 의미 확인 필요 |  |  |  |

## NMM0270.FN_NMM0270

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fdf103a5 | (진입점 미연결) | NMM0270.asmx.cs:61 | try ▸ try | CALL_EXT | sql.AddParameter | (SqlDbType.Structured, paramName, NMM0270_SEND_TO_SCM.List_ZNMMSCP_0270S.ListToDataTableEm… | ⚠ 의미 확인 필요 |  |  |  |
| AC-0f9569f8 | (진입점 미연결) | NMM0270.asmx.cs:61 | try ▸ try | CALL_EXT | NMM0270_SEND_TO_SCM.List_ZNMMSCP_0270S.ListToDataTableEmptyToNull | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-911bd2c5 | (진입점 미연결) | NMM0270.asmx.cs:62 | try ▸ try | ENDPOINT | sql.ExcuteProcedure(spNameFull).DataTableToList | () ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.PR_GSCM_XIF_MRP_PIC… | 엔드포인트 호출 |  |  |  |
| AC-3a9f1df3 | (진입점 미연결) | NMM0270.asmx.cs:62 | try ▸ try | ENDPOINT | sql.ExcuteProcedure | (spNameFull) ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.PR_GSCM_XIF_MRP_PIC… | 엔드포인트 호출 |  |  |  |
| AC-4f95246b | (진입점 미연결) | NMM0270.asmx.cs:87 | try ▸ catch ((Exception ex)) | UI_PROP | result.E_TYPE | "E" | 속성 E_TYPE 설정 |  |  |  |
| AC-515bb91f | (진입점 미연결) | NMM0270.asmx.cs:88 | try ▸ catch ((Exception ex)) | UI_PROP | result.E_MESSAGE | ex.Message.ToString() | 속성 E_MESSAGE 설정 |  |  |  |
| AC-0f5ca3b1 | (진입점 미연결) | NMM0270.asmx.cs:96 | catch ((Exception ex)) | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-da141bd0 | (진입점 미연결) | NMM0270.asmx.cs:99 |  | RETURN | return result; |  | 처리 중단/반환 |  |  |  |

## NMM0270.WriteLog

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f31bc05 | (진입점 미연결) | NMM0270.asmx.cs:107 |  | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |

## NMM0270.WriteLogDebug

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1567a34 | (진입점 미연결) | NMM0270.asmx.cs:115 |  | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |

## NMM0270.WriteLogEvent

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49e55dd7 | (진입점 미연결) | NMM0270.asmx.cs:111 |  | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |

