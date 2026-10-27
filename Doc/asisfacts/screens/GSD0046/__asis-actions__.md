# AS-IS 액션 대조표 — GSD0046

> 원천: `Doc/asisfacts/screens/GSD0046/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 13행 · 메서드 1 · 종류 CALL_EXT 8 · ENDPOINT 2 · UI_PROP 2 · RETURN 1 · ⚠ 의미 확인 필요 8


## GSCM_ERP_GSD0046.FN_GSD0046

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af41086f | (진입점 미연결) | GSCM_ERP_GSD0046.asmx.cs:39 |  | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-aaef9ddf | (진입점 미연결) | GSCM_ERP_GSD0046.asmx.cs:40 |  | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ced6d19b | (진입점 미연결) | GSCM_ERP_GSD0046.asmx.cs:57 | try | CALL_EXT | sql.AddParameter | (SqlDbType.NVarChar, "@I_IFGB", ZSDESSP_011_SEND_SO_TO_SSP.I_IFGB) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a4d3ef15 | (진입점 미연결) | GSCM_ERP_GSD0046.asmx.cs:58 | try | CALL_EXT | sql.AddParameter | (SqlDbType.Structured, "@ZSDESSP_0020S", ZSDESSP_011_SEND_SO_TO_SSP.List_ZSDESSP_0020S.Lis… | ⚠ 의미 확인 필요 |  |  |  |
| AC-443468e5 | (진입점 미연결) | GSCM_ERP_GSD0046.asmx.cs:58 | try | CALL_EXT | ZSDESSP_011_SEND_SO_TO_SSP.List_ZSDESSP_0020S.ListToDataTableEmptyToNull | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-48ccc08b | (진입점 미연결) | GSCM_ERP_GSD0046.asmx.cs:59 | try | ENDPOINT | sql.ExcuteProcedure("dbo.PR_SSP_XIF_ERP_SHIP_DOC_R").DataTableToList | () ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.PR_SSP_XIF_ERP_SHIP… | 엔드포인트 호출 |  |  |  |
| AC-09bb19dc | (진입점 미연결) | GSCM_ERP_GSD0046.asmx.cs:59 | try | ENDPOINT | sql.ExcuteProcedure | ("dbo.PR_SSP_XIF_ERP_SHIP_DOC_R") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.PR_SSP_XIF_ERP_SHIP… | 엔드포인트 호출 |  |  |  |
| AC-f0415046 | (진입점 미연결) | GSCM_ERP_GSD0046.asmx.cs:60 | try | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d0ad0b68 | (진입점 미연결) | GSCM_ERP_GSD0046.asmx.cs:68 | catch ((Exception ex)) | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c666daec | (진입점 미연결) | GSCM_ERP_GSD0046.asmx.cs:69 | catch ((Exception ex)) | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c82f0515 | (진입점 미연결) | GSCM_ERP_GSD0046.asmx.cs:70 | catch ((Exception ex)) | UI_PROP | result.E_TYPE | "E" | 속성 E_TYPE 설정 |  |  |  |
| AC-cce4aaea | (진입점 미연결) | GSCM_ERP_GSD0046.asmx.cs:71 | catch ((Exception ex)) | UI_PROP | result.E_MESSAGE | ex.Message.ToString() | 속성 E_MESSAGE 설정 |  |  |  |
| AC-c68f9650 | (진입점 미연결) | GSCM_ERP_GSD0046.asmx.cs:74 |  | RETURN | return result; |  | 처리 중단/반환 |  |  |  |

