# AS-IS 액션 대조표 — NSD0101

> 원천: `Doc/asisfacts/screens/NSD0101/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 13행 · 메서드 1 · 종류 CALL_EXT 8 · ENDPOINT 2 · UI_PROP 2 · RETURN 1 · ⚠ 의미 확인 필요 8


## GSCM_ERP_NSD0101.FN_NSD0101

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-13b4e036 | (진입점 미연결) | GSCM_ERP_NSD0101.asmx.cs:38 |  | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b64c75d1 | (진입점 미연결) | GSCM_ERP_NSD0101.asmx.cs:39 |  | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-eca9c487 | (진입점 미연결) | GSCM_ERP_NSD0101.asmx.cs:57 | try | CALL_EXT | sql.AddParameter | (SqlDbType.NVarChar, "@I_IFGB", NSD0101_SEND_SO_TO_SSP.I_IFGB) | ⚠ 의미 확인 필요 |  |  |  |
| AC-753f6fad | (진입점 미연결) | GSCM_ERP_NSD0101.asmx.cs:58 | try | CALL_EXT | sql.AddParameter | (SqlDbType.Structured, "@NSDESSP_0020S", NSD0101_SEND_SO_TO_SSP.List_NSDESSP_0020S.ListToD… | ⚠ 의미 확인 필요 |  |  |  |
| AC-8307b995 | (진입점 미연결) | GSCM_ERP_NSD0101.asmx.cs:58 | try | CALL_EXT | NSD0101_SEND_SO_TO_SSP.List_NSDESSP_0020S.ListToDataTableEmptyToNull | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c73d0e54 | (진입점 미연결) | GSCM_ERP_NSD0101.asmx.cs:59 | try | ENDPOINT | sql.ExcuteProcedure("dbo.NERP_PR_SSP_XIF_ERP_SHIP_DOC_R").DataTableToList | () ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.NERP_PR_SSP_XIF_ERP… | 엔드포인트 호출 |  |  |  |
| AC-f7f5db35 | (진입점 미연결) | GSCM_ERP_NSD0101.asmx.cs:59 | try | ENDPOINT | sql.ExcuteProcedure | ("dbo.NERP_PR_SSP_XIF_ERP_SHIP_DOC_R") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.NERP_PR_SSP_XIF_ERP… | 엔드포인트 호출 |  |  |  |
| AC-b46bddba | (진입점 미연결) | GSCM_ERP_NSD0101.asmx.cs:60 | try | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-08aecfbc | (진입점 미연결) | GSCM_ERP_NSD0101.asmx.cs:67 | catch ((Exception ex)) | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-0458c730 | (진입점 미연결) | GSCM_ERP_NSD0101.asmx.cs:68 | catch ((Exception ex)) | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5984b3e0 | (진입점 미연결) | GSCM_ERP_NSD0101.asmx.cs:69 | catch ((Exception ex)) | UI_PROP | result.E_TYPE | "E" | 속성 E_TYPE 설정 |  |  |  |
| AC-2719e30d | (진입점 미연결) | GSCM_ERP_NSD0101.asmx.cs:70 | catch ((Exception ex)) | UI_PROP | result.E_MESSAGE | ex.Message.ToString() | 속성 E_MESSAGE 설정 |  |  |  |
| AC-1b44f77e | (진입점 미연결) | GSCM_ERP_NSD0101.asmx.cs:73 |  | RETURN | return result; |  | 처리 중단/반환 |  |  |  |

