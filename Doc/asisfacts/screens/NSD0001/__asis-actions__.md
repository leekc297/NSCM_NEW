# AS-IS 액션 대조표 — NSD0001

> 원천: `Doc/asisfacts/screens/NSD0001/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 19행 · 메서드 1 · 종류 CALL_EXT 14 · ENDPOINT 2 · UI_PROP 2 · RETURN 1 · ⚠ 의미 확인 필요 14


## NSD0001.FN_NSD0001

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb82a541 | (진입점 미연결) | NSD0001.asmx.cs:38 |  | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-663070b5 | (진입점 미연결) | NSD0001.asmx.cs:39 |  | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a3a03247 | (진입점 미연결) | NSD0001.asmx.cs:57 | try | CALL_EXT | sql.AddParameter | (SqlDbType.Structured, "@ET_NEDIHEADER", NSD0001_SEND_TO_SCM.List_ET_NEDIHEADER.ListToData… | ⚠ 의미 확인 필요 |  |  |  |
| AC-acaba1ac | (진입점 미연결) | NSD0001.asmx.cs:57 | try | CALL_EXT | NSD0001_SEND_TO_SCM.List_ET_NEDIHEADER.ListToDataTableEmptyToNull | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-162c2caf | (진입점 미연결) | NSD0001.asmx.cs:58 | try | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-99982ba6 | (진입점 미연결) | NSD0001.asmx.cs:59 | try | CALL_EXT | sql.AddParameter | (SqlDbType.Structured, "@ET_NEDIPARTNER", NSD0001_SEND_TO_SCM.List_ET_NEDIPARTNER.ListToDa… | ⚠ 의미 확인 필요 |  |  |  |
| AC-030be083 | (진입점 미연결) | NSD0001.asmx.cs:59 | try | CALL_EXT | NSD0001_SEND_TO_SCM.List_ET_NEDIPARTNER.ListToDataTableEmptyToNull | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-973660cf | (진입점 미연결) | NSD0001.asmx.cs:60 | try | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-29a56c9b | (진입점 미연결) | NSD0001.asmx.cs:61 | try | CALL_EXT | sql.AddParameter | (SqlDbType.Structured, "@ET_NEDIITEM", NSD0001_SEND_TO_SCM.List_ET_NEDIITEM.ListToDataTabl… | ⚠ 의미 확인 필요 |  |  |  |
| AC-20715ffe | (진입점 미연결) | NSD0001.asmx.cs:61 | try | CALL_EXT | NSD0001_SEND_TO_SCM.List_ET_NEDIITEM.ListToDataTableEmptyToNull | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-bd81e55b | (진입점 미연결) | NSD0001.asmx.cs:62 | try | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d8cf72c7 | (진입점 미연결) | NSD0001.asmx.cs:64 | try | ENDPOINT | sql.ExcuteProcedure("dbo.PR_DM_XIF_ERP_NSD0001_R").DataTableToList | () ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.PR_DM_XIF_ERP_NSD00… | 엔드포인트 호출 |  |  |  |
| AC-7e46c101 | (진입점 미연결) | NSD0001.asmx.cs:64 | try | ENDPOINT | sql.ExcuteProcedure | ("dbo.PR_DM_XIF_ERP_NSD0001_R") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.PR_DM_XIF_ERP_NSD00… | 엔드포인트 호출 |  |  |  |
| AC-56191288 | (진입점 미연결) | NSD0001.asmx.cs:65 | try | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-eea5d18b | (진입점 미연결) | NSD0001.asmx.cs:72 | catch ((Exception ex)) | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5db8db06 | (진입점 미연결) | NSD0001.asmx.cs:73 | catch ((Exception ex)) | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4605ec4f | (진입점 미연결) | NSD0001.asmx.cs:74 | catch ((Exception ex)) | UI_PROP | result.E_TYPE | "E" | 속성 E_TYPE 설정 |  |  |  |
| AC-8db26fbc | (진입점 미연결) | NSD0001.asmx.cs:75 | catch ((Exception ex)) | UI_PROP | result.E_MESSAGE | ex.Message.ToString() | 속성 E_MESSAGE 설정 |  |  |  |
| AC-9c5c09f6 | (진입점 미연결) | NSD0001.asmx.cs:114 |  | RETURN | return result; |  | 처리 중단/반환 |  |  |  |

