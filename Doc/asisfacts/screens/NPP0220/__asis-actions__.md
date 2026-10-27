# AS-IS 액션 대조표 — NPP0220

> 원천: `Doc/asisfacts/screens/NPP0220/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 54행 · 메서드 7 · 종류 FLAG 24 · RETURN 17 · CALL_BASE 12 · CALL_EXT 1 · ⚠ 의미 확인 필요 13


## NPP0220_GSCM_SOCompletedEventArgs..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-844d8994 | .ctor | Reference.cs:594 |  | FLAG | this.results | results | 화면 필드/플래그 변경 |  |  |  |
| AC-87c7d1e1 | .ctor | Reference.cs:594 |  | FLAG | this.results | results | 화면 필드/플래그 변경 |  |  |  |
| AC-49c3128f | .ctor | Reference.cs:594 |  | FLAG | this.results | results | 화면 필드/플래그 변경 |  |  |  |
| AC-f4048de9 | .ctor | Reference.cs:594 |  | FLAG | this.results | results | 화면 필드/플래그 변경 |  |  |  |

## NPP0220_GSCM_SOService..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9bfd6feb | .ctor | Reference.cs:38 |  | FLAG | this.Url | global::GMES_WEBSERVICE.Properties.Settings.Default.GMES_WEBSERVICE_WebReference_NPP0220_G… | 화면 필드/플래그 변경 |  |  |  |
| AC-9b80815b | .ctor | Reference.cs:40 | if ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.UseDefaultCredentials | true | 화면 필드/플래그 변경 |  |  |  |
| AC-84382af1 | .ctor | Reference.cs:41 | if ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.useDefaultCredentialsSetExplicitly | false | 화면 필드/플래그 변경 |  |  |  |
| AC-e95f243f | .ctor | Reference.cs:44 | else of ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.useDefaultCredentialsSetExplicitly | true | 화면 필드/플래그 변경 |  |  |  |
| AC-b181fd33 | .ctor | Reference.cs:38 |  | FLAG | this.Url | global::GMES_WEBSERVICE.Properties.Settings.Default.GMES_WEBSERVICE_com_lgensol_lespidb_NP… | 화면 필드/플래그 변경 |  |  |  |
| AC-17aae801 | .ctor | Reference.cs:40 | if ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.UseDefaultCredentials | true | 화면 필드/플래그 변경 |  |  |  |
| AC-790cfc5e | .ctor | Reference.cs:41 | if ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.useDefaultCredentialsSetExplicitly | false | 화면 필드/플래그 변경 |  |  |  |
| AC-95cc8450 | .ctor | Reference.cs:44 | else of ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.useDefaultCredentialsSetExplicitly | true | 화면 필드/플래그 변경 |  |  |  |
| AC-13f4ab9e | .ctor | Reference.cs:38 |  | FLAG | this.Url | global::GMES_WEBSERVICE.Properties.Settings.Default.GMES_WEBSERVICE_NPP0220_NPP0220_GSCM_S… | 화면 필드/플래그 변경 |  |  |  |
| AC-65a81d68 | .ctor | Reference.cs:40 | if ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.UseDefaultCredentials | true | 화면 필드/플래그 변경 |  |  |  |
| AC-01e58116 | .ctor | Reference.cs:41 | if ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.useDefaultCredentialsSetExplicitly | false | 화면 필드/플래그 변경 |  |  |  |
| AC-075e81f0 | .ctor | Reference.cs:44 | else of ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.useDefaultCredentialsSetExplicitly | true | 화면 필드/플래그 변경 |  |  |  |
| AC-d26321fa | .ctor | Reference.cs:38 |  | FLAG | this.Url | global::GMES_WEBSERVICE.Properties.Settings.Default.GMES_WEBSERVICE_NPP0220_PRD_NPP0220_GS… | 화면 필드/플래그 변경 |  |  |  |
| AC-3b59c233 | .ctor | Reference.cs:40 | if ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.UseDefaultCredentials | true | 화면 필드/플래그 변경 |  |  |  |
| AC-aba6553f | .ctor | Reference.cs:41 | if ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.useDefaultCredentialsSetExplicitly | false | 화면 필드/플래그 변경 |  |  |  |
| AC-ec694bd5 | .ctor | Reference.cs:44 | else of ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.useDefaultCredentialsSetExplicitly | true | 화면 필드/플래그 변경 |  |  |  |

## NPP0220_GSCM_SOService.IsLocalFileSystemWebService

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1195ec95 | .ctor | Reference.cs:113 | if (((url == null) \|\| (url == string.Empty))) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-23b10f37 | .ctor | Reference.cs:118 | if (((wsUri.Port >= 1024) && (string.Compare(wsUri.Host, "localHost", System.StringComparison.OrdinalIgnoreCase) == 0))) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-f5e22a48 | .ctor | Reference.cs:120 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-36c75f27 | .ctor | Reference.cs:113 | if (((url == null) \|\| (url == string.Empty))) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-ae5b4fd6 | .ctor | Reference.cs:118 | if (((wsUri.Port >= 1024) && (string.Compare(wsUri.Host, "localHost", System.StringComparison.OrdinalIgnoreCase) == 0))) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-81bd6f0f | .ctor | Reference.cs:120 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-d6101f6b | .ctor | Reference.cs:113 | if (((url == null) \|\| (url == string.Empty))) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-bb3b5105 | .ctor | Reference.cs:118 | if (((wsUri.Port >= 1024) && (string.Compare(wsUri.Host, "localHost", System.StringComparison.OrdinalIgnoreCase) == 0))) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-fa4cee18 | .ctor | Reference.cs:120 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-2c8a996a | .ctor | Reference.cs:113 | if (((url == null) \|\| (url == string.Empty))) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-32ddae17 | .ctor | Reference.cs:118 | if (((wsUri.Port >= 1024) && (string.Compare(wsUri.Host, "localHost", System.StringComparison.OrdinalIgnoreCase) == 0))) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-76837294 | .ctor | Reference.cs:120 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## NPP0220_GSCM_SOService.NPP0220_GSCM_SO

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3d81924 | (진입점 미연결) | Reference.cs:79 |  | CALL_BASE | this.Invoke | ("NPP0220_GSCM_SO", new object[] { MT_NPP0220_GSCM}) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0578e80b | (진입점 미연결) | Reference.cs:81 |  | RETURN | return ((DT_NPP0220_GSCM_response)(results[0])); |  | 처리 중단/반환 |  |  |  |
| AC-de58df6d | (진입점 미연결) | Reference.cs:79 |  | CALL_BASE | this.Invoke | ("NPP0220_GSCM_SO", new object[] { MT_NPP0220_GSCM}) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cdafc9d4 | (진입점 미연결) | Reference.cs:81 |  | RETURN | return ((DT_NPP0220_GSCM_response)(results[0])); |  | 처리 중단/반환 |  |  |  |
| AC-78621da8 | (진입점 미연결) | Reference.cs:79 |  | CALL_BASE | this.Invoke | ("NPP0220_GSCM_SO", new object[] { MT_NPP0220_GSCM}) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e8f3769e | (진입점 미연결) | Reference.cs:81 |  | RETURN | return ((DT_NPP0220_GSCM_response)(results[0])); |  | 처리 중단/반환 |  |  |  |
| AC-eccb0b8c | (진입점 미연결) | Reference.cs:79 |  | CALL_BASE | this.Invoke | ("NPP0220_GSCM_SO", new object[] { MT_NPP0220_GSCM}) | ⚠ 의미 확인 필요 |  |  |  |
| AC-97235927 | (진입점 미연결) | Reference.cs:81 |  | RETURN | return ((DT_NPP0220_GSCM_response)(results[0])); |  | 처리 중단/반환 |  |  |  |

## NPP0220_GSCM_SOService.NPP0220_GSCM_SOAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e3cddeb0 | (진입점 미연결) | Reference.cs:92 | if ((this.NPP0220_GSCM_SOOperationCompleted == null)) | FLAG | this.NPP0220_GSCM_SOOperationCompleted | new System.Threading.SendOrPostCallback(this.OnNPP0220_GSCM_SOOperationCompleted) | 화면 필드/플래그 변경 |  |  |  |
| AC-162684b8 | (진입점 미연결) | Reference.cs:94 |  | CALL_BASE | this.InvokeAsync | ("NPP0220_GSCM_SO", new object[] { MT_NPP0220_GSCM}, this.NPP0220_GSCM_SOOperationComplete… | ⚠ 의미 확인 필요 |  |  |  |
| AC-a229be57 | (진입점 미연결) | Reference.cs:92 | if ((this.NPP0220_GSCM_SOOperationCompleted == null)) | FLAG | this.NPP0220_GSCM_SOOperationCompleted | new System.Threading.SendOrPostCallback(this.OnNPP0220_GSCM_SOOperationCompleted) | 화면 필드/플래그 변경 |  |  |  |
| AC-9f648855 | (진입점 미연결) | Reference.cs:94 |  | CALL_BASE | this.InvokeAsync | ("NPP0220_GSCM_SO", new object[] { MT_NPP0220_GSCM}, this.NPP0220_GSCM_SOOperationComplete… | ⚠ 의미 확인 필요 |  |  |  |
| AC-42326635 | (진입점 미연결) | Reference.cs:92 | if ((this.NPP0220_GSCM_SOOperationCompleted == null)) | FLAG | this.NPP0220_GSCM_SOOperationCompleted | new System.Threading.SendOrPostCallback(this.OnNPP0220_GSCM_SOOperationCompleted) | 화면 필드/플래그 변경 |  |  |  |
| AC-1615adb6 | (진입점 미연결) | Reference.cs:94 |  | CALL_BASE | this.InvokeAsync | ("NPP0220_GSCM_SO", new object[] { MT_NPP0220_GSCM}, this.NPP0220_GSCM_SOOperationComplete… | ⚠ 의미 확인 필요 |  |  |  |
| AC-a4dbe839 | (진입점 미연결) | Reference.cs:92 | if ((this.NPP0220_GSCM_SOOperationCompleted == null)) | FLAG | this.NPP0220_GSCM_SOOperationCompleted | new System.Threading.SendOrPostCallback(this.OnNPP0220_GSCM_SOOperationCompleted) | 화면 필드/플래그 변경 |  |  |  |
| AC-401096b4 | (진입점 미연결) | Reference.cs:94 |  | CALL_BASE | this.InvokeAsync | ("NPP0220_GSCM_SO", new object[] { MT_NPP0220_GSCM}, this.NPP0220_GSCM_SOOperationComplete… | ⚠ 의미 확인 필요 |  |  |  |

## NPP0220_GSCM_SOService.OnNPP0220_GSCM_SOOperationCompleted

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-96837609 | (진입점 미연결) | Reference.cs:101 | if ((this.NPP0220_GSCM_SOCompleted != null)) | CALL_BASE | this.NPP0220_GSCM_SOCompleted | (this, new NPP0220_GSCM_SOCompletedEventArgs(invokeArgs.Results, invokeArgs.Error, invokeA… | ⚠ 의미 확인 필요 |  |  |  |
| AC-f52435df | (진입점 미연결) | Reference.cs:101 | if ((this.NPP0220_GSCM_SOCompleted != null)) | CALL_BASE | this.NPP0220_GSCM_SOCompleted | (this, new NPP0220_GSCM_SOCompletedEventArgs(invokeArgs.Results, invokeArgs.Error, invokeA… | ⚠ 의미 확인 필요 |  |  |  |
| AC-43d74855 | (진입점 미연결) | Reference.cs:101 | if ((this.NPP0220_GSCM_SOCompleted != null)) | CALL_BASE | this.NPP0220_GSCM_SOCompleted | (this, new NPP0220_GSCM_SOCompletedEventArgs(invokeArgs.Results, invokeArgs.Error, invokeA… | ⚠ 의미 확인 필요 |  |  |  |
| AC-02044905 | (진입점 미연결) | Reference.cs:101 | if ((this.NPP0220_GSCM_SOCompleted != null)) | CALL_BASE | this.NPP0220_GSCM_SOCompleted | (this, new NPP0220_GSCM_SOCompletedEventArgs(invokeArgs.Results, invokeArgs.Error, invokeA… | ⚠ 의미 확인 필요 |  |  |  |

## NPP0220.FN_NPP0220

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-26056f08 | (진입점 미연결) | NPP0220.asmx.cs:55 | catch ((Exception ex)) | CALL_EXT | log.GetInstance | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-7ca41643 | (진입점 미연결) | NPP0220.asmx.cs:58 |  | RETURN | return result; |  | 처리 중단/반환 |  |  |  |

