# AS-IS 액션 대조표 — NSD0010

> 원천: `Doc/asisfacts/screens/NSD0010/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 13행 · 메서드 1 · 종류 CALL_EXT 8 · ENDPOINT 2 · UI_PROP 2 · RETURN 1 · ⚠ 의미 확인 필요 8


## NSD0010.FN_NSD0010

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ccc3dcb7 | (진입점 미연결) | NSD0010.asmx.cs:38 |  | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d244df63 | (진입점 미연결) | NSD0010.asmx.cs:39 |  | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-99fb1dab | (진입점 미연결) | NSD0010.asmx.cs:46 | try | CALL_EXT | sql.AddParameter | (SqlDbType.Structured, "@ET_CUST_DEMAND_MAPPING", NSD0010_SEND_TO_SCM.List_ET_CUST_DEMAND_… | ⚠ 의미 확인 필요 |  |  |  |
| AC-e7864972 | (진입점 미연결) | NSD0010.asmx.cs:46 | try | CALL_EXT | NSD0010_SEND_TO_SCM.List_ET_CUST_DEMAND_MAPPING.ListToDataTableEmptyToNull | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d9352af8 | (진입점 미연결) | NSD0010.asmx.cs:47 | try | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-be355a59 | (진입점 미연결) | NSD0010.asmx.cs:49 | try | ENDPOINT | sql.ExcuteProcedure("dbo.PR_DM_XIF_ERP_NSD0010_R").DataTableToList | () ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.PR_DM_XIF_ERP_NSD00… | 엔드포인트 호출 |  |  |  |
| AC-452fb5f7 | (진입점 미연결) | NSD0010.asmx.cs:49 | try | ENDPOINT | sql.ExcuteProcedure | ("dbo.PR_DM_XIF_ERP_NSD0010_R") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.PR_DM_XIF_ERP_NSD00… | 엔드포인트 호출 |  |  |  |
| AC-238b5fdf | (진입점 미연결) | NSD0010.asmx.cs:50 | try | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-97cd6448 | (진입점 미연결) | NSD0010.asmx.cs:57 | catch ((Exception ex)) | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6b36e5cd | (진입점 미연결) | NSD0010.asmx.cs:58 | catch ((Exception ex)) | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c3bd878f | (진입점 미연결) | NSD0010.asmx.cs:59 | catch ((Exception ex)) | UI_PROP | result.E_TYPE | "E" | 속성 E_TYPE 설정 |  |  |  |
| AC-cb9a1ec2 | (진입점 미연결) | NSD0010.asmx.cs:60 | catch ((Exception ex)) | UI_PROP | result.E_MESSAGE | ex.Message.ToString() | 속성 E_MESSAGE 설정 |  |  |  |
| AC-8bbd9543 | (진입점 미연결) | NSD0010.asmx.cs:63 |  | RETURN | return result; |  | 처리 중단/반환 |  |  |  |

