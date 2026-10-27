# AS-IS 액션 대조표 — GSD0039

> 원천: `Doc/asisfacts/screens/GSD0039/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 40행 · 메서드 5 · 종류 CALL_EXT 17 · ENDPOINT 6 · UI_PROP 6 · FLAG 5 · CALL_BASE 3 · RETURN 3 · ⚠ 의미 확인 필요 20


## GSD0039..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f1617c5d | .ctor | Reference.cs:38 |  | FLAG | this.Url | global::GMES_WEBSERVICE.Properties.Settings.Default.GMES_WEBSERVICE_GSD0039_GSD0039 | 화면 필드/플래그 변경 |  |  |  |
| AC-ff8d6155 | .ctor | Reference.cs:40 | if ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.UseDefaultCredentials | true | 화면 필드/플래그 변경 |  |  |  |
| AC-3ac67b24 | .ctor | Reference.cs:41 | if ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.useDefaultCredentialsSetExplicitly | false | 화면 필드/플래그 변경 |  |  |  |
| AC-cd771fbc | .ctor | Reference.cs:44 | else of ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.useDefaultCredentialsSetExplicitly | true | 화면 필드/플래그 변경 |  |  |  |

## GSD0039.FN_GSD0039

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-22e895a3 | (진입점 미연결) | GSD0039.asmx.cs:41 |  | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-aa22f945 | (진입점 미연결) | GSD0039.asmx.cs:42 |  | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ba013aae | (진입점 미연결) | GSD0039.asmx.cs:56 | try | CALL_EXT | sql.AddParameter | (SqlDbType.Structured, "@ET_ZCUST_MAT", GSD0039_SEND_TO_SCM.List_ET_ZCUST_MAT.ListToDataTa… | ⚠ 의미 확인 필요 |  |  |  |
| AC-bba92087 | (진입점 미연결) | GSD0039.asmx.cs:56 | try | CALL_EXT | GSD0039_SEND_TO_SCM.List_ET_ZCUST_MAT.ListToDataTableEmptyToNull | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-caf3dfc9 | (진입점 미연결) | GSD0039.asmx.cs:57 | try | ENDPOINT | sql.ExcuteProcedure("dbo.PR_GSCM_XIF_DM_GSD0039_R").DataTableToList | () ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.PR_GSCM_XIF_DM_GSD0… | 엔드포인트 호출 |  |  |  |
| AC-85975521 | (진입점 미연결) | GSD0039.asmx.cs:57 | try | ENDPOINT | sql.ExcuteProcedure | ("dbo.PR_GSCM_XIF_DM_GSD0039_R") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.PR_GSCM_XIF_DM_GSD0… | 엔드포인트 호출 |  |  |  |
| AC-6be80add | (진입점 미연결) | GSD0039.asmx.cs:58 | try | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c814dfe6 | (진입점 미연결) | GSD0039.asmx.cs:65 | catch ((Exception ex)) | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-67b7a8e5 | (진입점 미연결) | GSD0039.asmx.cs:66 | catch ((Exception ex)) | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-9c26f6f1 | (진입점 미연결) | GSD0039.asmx.cs:67 | catch ((Exception ex)) | UI_PROP | result.E_TYPE | "E" | 속성 E_TYPE 설정 |  |  |  |
| AC-2c65812f | (진입점 미연결) | GSD0039.asmx.cs:68 | catch ((Exception ex)) | UI_PROP | result.E_MESSAGE | ex.Message.ToString() | 속성 E_MESSAGE 설정 |  |  |  |
| AC-dd41af49 | (진입점 미연결) | GSD0039.asmx.cs:74 | try | CALL_EXT | sql.AddParameter | (SqlDbType.Structured, "@ET_ZEDI_MODEL", GSD0039_SEND_TO_SCM.List_ET_ZEDI_MODEL.ListToData… | ⚠ 의미 확인 필요 |  |  |  |
| AC-7a42c427 | (진입점 미연결) | GSD0039.asmx.cs:74 | try | CALL_EXT | GSD0039_SEND_TO_SCM.List_ET_ZEDI_MODEL.ListToDataTableEmptyToNull | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-aabf1de4 | (진입점 미연결) | GSD0039.asmx.cs:75 | try | ENDPOINT | sql.ExcuteProcedure("dbo.PR_GSCM_XIF_DM_GSD0039_R").DataTableToList | () ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.PR_GSCM_XIF_DM_GSD0… | 엔드포인트 호출 |  |  |  |
| AC-4287798c | (진입점 미연결) | GSD0039.asmx.cs:75 | try | ENDPOINT | sql.ExcuteProcedure | ("dbo.PR_GSCM_XIF_DM_GSD0039_R") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.PR_GSCM_XIF_DM_GSD0… | 엔드포인트 호출 |  |  |  |
| AC-2cfde742 | (진입점 미연결) | GSD0039.asmx.cs:76 | try | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-7ba991ce | (진입점 미연결) | GSD0039.asmx.cs:83 | catch ((Exception ex)) | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-bffbce45 | (진입점 미연결) | GSD0039.asmx.cs:84 | catch ((Exception ex)) | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-09babc16 | (진입점 미연결) | GSD0039.asmx.cs:85 | catch ((Exception ex)) | UI_PROP | result1.E_TYPE | "E" | 속성 E_TYPE 설정 |  |  |  |
| AC-e52b44d8 | (진입점 미연결) | GSD0039.asmx.cs:86 | catch ((Exception ex)) | UI_PROP | result1.E_MESSAGE | ex.Message.ToString() | 속성 E_MESSAGE 설정 |  |  |  |
| AC-e8e343e8 | (진입점 미연결) | GSD0039.asmx.cs:91 | try | CALL_EXT | sql.AddParameter | (SqlDbType.Structured, "@ET_ZEDI_STRUCT", GSD0039_SEND_TO_SCM.List_ET_ZEDI_STRUCT.ListToDa… | ⚠ 의미 확인 필요 |  |  |  |
| AC-733e4f64 | (진입점 미연결) | GSD0039.asmx.cs:91 | try | CALL_EXT | GSD0039_SEND_TO_SCM.List_ET_ZEDI_STRUCT.ListToDataTableEmptyToNull | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6ee75922 | (진입점 미연결) | GSD0039.asmx.cs:92 | try | ENDPOINT | sql.ExcuteProcedure("dbo.PR_GSCM_XIF_DM_GSD0039_R").DataTableToList | () ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.PR_GSCM_XIF_DM_GSD0… | 엔드포인트 호출 |  |  |  |
| AC-35049449 | (진입점 미연결) | GSD0039.asmx.cs:92 | try | ENDPOINT | sql.ExcuteProcedure | ("dbo.PR_GSCM_XIF_DM_GSD0039_R") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.PR_GSCM_XIF_DM_GSD0… | 엔드포인트 호출 |  |  |  |
| AC-986565d6 | (진입점 미연결) | GSD0039.asmx.cs:93 | try | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-89c35a14 | (진입점 미연결) | GSD0039.asmx.cs:100 | catch ((Exception ex)) | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c3cf5947 | (진입점 미연결) | GSD0039.asmx.cs:101 | catch ((Exception ex)) | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-60e92ffa | (진입점 미연결) | GSD0039.asmx.cs:102 | catch ((Exception ex)) | UI_PROP | result2.E_TYPE | "E" | 속성 E_TYPE 설정 |  |  |  |
| AC-2dfa023f | (진입점 미연결) | GSD0039.asmx.cs:103 | catch ((Exception ex)) | UI_PROP | result2.E_MESSAGE | ex.Message.ToString() | 속성 E_MESSAGE 설정 |  |  |  |
| AC-cf5d9e88 | (진입점 미연결) | Reference.cs:78 |  | CALL_BASE | this.Invoke | ("FN_GSD0039", new object[] { GSD0039_SEND_TO_SCM}) | ⚠ 의미 확인 필요 |  |  |  |

## GSD0039.FN_GSD0039Async

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d79abdba | (진입점 미연결) | Reference.cs:90 | if ((this.FN_GSD0039OperationCompleted == null)) | FLAG | this.FN_GSD0039OperationCompleted | new System.Threading.SendOrPostCallback(this.OnFN_GSD0039OperationCompleted) | 화면 필드/플래그 변경 |  |  |  |
| AC-2ca8bd6a | (진입점 미연결) | Reference.cs:92 |  | CALL_BASE | this.InvokeAsync | ("FN_GSD0039", new object[] { GSD0039_SEND_TO_SCM}, this.FN_GSD0039OperationCompleted, use… | ⚠ 의미 확인 필요 |  |  |  |

## GSD0039.IsLocalFileSystemWebService

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-92c06fbf | .ctor | Reference.cs:111 | if (((url == null) \|\| (url == string.Empty))) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-cecb977b | .ctor | Reference.cs:116 | if (((wsUri.Port >= 1024) && (string.Compare(wsUri.Host, "localHost", System.StringComparison.OrdinalIgnoreCase) == 0))) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-73316f20 | .ctor | Reference.cs:118 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## GSD0039.OnFN_GSD0039OperationCompleted

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-01dc8783 | (진입점 미연결) | Reference.cs:99 | if ((this.FN_GSD0039Completed != null)) | CALL_BASE | this.FN_GSD0039Completed | (this, new System.ComponentModel.AsyncCompletedEventArgs(invokeArgs.Error, invokeArgs.Canc… | ⚠ 의미 확인 필요 |  |  |  |

