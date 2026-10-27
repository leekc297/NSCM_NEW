# AS-IS 액션 대조표 — NSD0100

> 원천: `Doc/asisfacts/screens/NSD0100/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 52행 · 메서드 6 · 종류 FLAG 24 · RETURN 16 · CALL_BASE 12 · ⚠ 의미 확인 필요 12


## NSD0100_SSPX_SOCompletedEventArgs..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b3aed297 | .ctor | Reference.cs:932 |  | FLAG | this.results | results | 화면 필드/플래그 변경 |  |  |  |
| AC-a8a76f36 | .ctor | Reference.cs:932 |  | FLAG | this.results | results | 화면 필드/플래그 변경 |  |  |  |
| AC-8d0ffbeb | .ctor | Reference.cs:932 |  | FLAG | this.results | results | 화면 필드/플래그 변경 |  |  |  |
| AC-3ae88e7c | .ctor | Reference.cs:932 |  | FLAG | this.results | results | 화면 필드/플래그 변경 |  |  |  |

## NSD0100_SSPX_SOService..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82f2e4af | .ctor | Reference.cs:38 |  | FLAG | this.Url | global::GMES_WEBSERVICE.Properties.Settings.Default.GMES_WEBSERVICE_NSD0100_NSD0100_SSPX_S… | 화면 필드/플래그 변경 |  |  |  |
| AC-fa0abc3b | .ctor | Reference.cs:40 | if ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.UseDefaultCredentials | true | 화면 필드/플래그 변경 |  |  |  |
| AC-bb32d24e | .ctor | Reference.cs:41 | if ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.useDefaultCredentialsSetExplicitly | false | 화면 필드/플래그 변경 |  |  |  |
| AC-196cdabe | .ctor | Reference.cs:44 | else of ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.useDefaultCredentialsSetExplicitly | true | 화면 필드/플래그 변경 |  |  |  |
| AC-e8ca1f4e | .ctor | Reference.cs:38 |  | FLAG | this.Url | global::GMES_WEBSERVICE.Properties.Settings.Default.GMES_WEBSERVICE_NSD0100_PRD_NSD0100_SS… | 화면 필드/플래그 변경 |  |  |  |
| AC-da087af4 | .ctor | Reference.cs:40 | if ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.UseDefaultCredentials | true | 화면 필드/플래그 변경 |  |  |  |
| AC-0c8859fa | .ctor | Reference.cs:41 | if ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.useDefaultCredentialsSetExplicitly | false | 화면 필드/플래그 변경 |  |  |  |
| AC-66fe5077 | .ctor | Reference.cs:44 | else of ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.useDefaultCredentialsSetExplicitly | true | 화면 필드/플래그 변경 |  |  |  |
| AC-6f2e1352 | .ctor | Reference.cs:38 |  | FLAG | this.Url | global::GMES_WEBSERVICE.Properties.Settings.Default.GMES_WEBSERVICE_NSD0100_NSD0100_SSPX_S… | 화면 필드/플래그 변경 |  |  |  |
| AC-d5d18b96 | .ctor | Reference.cs:40 | if ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.UseDefaultCredentials | true | 화면 필드/플래그 변경 |  |  |  |
| AC-aef12098 | .ctor | Reference.cs:41 | if ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.useDefaultCredentialsSetExplicitly | false | 화면 필드/플래그 변경 |  |  |  |
| AC-da2c08a8 | .ctor | Reference.cs:44 | else of ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.useDefaultCredentialsSetExplicitly | true | 화면 필드/플래그 변경 |  |  |  |
| AC-efad6a1a | .ctor | Reference.cs:38 |  | FLAG | this.Url | global::GMES_WEBSERVICE.Properties.Settings.Default.GMES_WEBSERVICE_NSD0100_PRD_NSD0100_SS… | 화면 필드/플래그 변경 |  |  |  |
| AC-78ff1e88 | .ctor | Reference.cs:40 | if ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.UseDefaultCredentials | true | 화면 필드/플래그 변경 |  |  |  |
| AC-e6e3ff62 | .ctor | Reference.cs:41 | if ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.useDefaultCredentialsSetExplicitly | false | 화면 필드/플래그 변경 |  |  |  |
| AC-62adc761 | .ctor | Reference.cs:44 | else of ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.useDefaultCredentialsSetExplicitly | true | 화면 필드/플래그 변경 |  |  |  |

## NSD0100_SSPX_SOService.IsLocalFileSystemWebService

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74eaa2f7 | .ctor | Reference.cs:113 | if (((url == null) \|\| (url == string.Empty))) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-deae17fd | .ctor | Reference.cs:118 | if (((wsUri.Port >= 1024) && (string.Compare(wsUri.Host, "localHost", System.StringComparison.OrdinalIgnoreCase) == 0))) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-57fec8ac | .ctor | Reference.cs:120 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-36cb9a60 | .ctor | Reference.cs:113 | if (((url == null) \|\| (url == string.Empty))) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-561f92c5 | .ctor | Reference.cs:118 | if (((wsUri.Port >= 1024) && (string.Compare(wsUri.Host, "localHost", System.StringComparison.OrdinalIgnoreCase) == 0))) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-e91068b0 | .ctor | Reference.cs:120 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-d2eeacba | .ctor | Reference.cs:113 | if (((url == null) \|\| (url == string.Empty))) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-0fe5f80b | .ctor | Reference.cs:118 | if (((wsUri.Port >= 1024) && (string.Compare(wsUri.Host, "localHost", System.StringComparison.OrdinalIgnoreCase) == 0))) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-b27393d8 | .ctor | Reference.cs:120 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-73b42c69 | .ctor | Reference.cs:113 | if (((url == null) \|\| (url == string.Empty))) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-4eb43873 | .ctor | Reference.cs:118 | if (((wsUri.Port >= 1024) && (string.Compare(wsUri.Host, "localHost", System.StringComparison.OrdinalIgnoreCase) == 0))) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-77cd68e1 | .ctor | Reference.cs:120 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## NSD0100_SSPX_SOService.NSD0100_SSPX_SO

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fd4d4cd9 | (진입점 미연결) | Reference.cs:79 |  | CALL_BASE | this.Invoke | ("NSD0100_SSPX_SO", new object[] { MT_NSD0100_SSPX}) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4f8a9f51 | (진입점 미연결) | Reference.cs:81 |  | RETURN | return ((DT_NSD0100_SSPX_response)(results[0])); |  | 처리 중단/반환 |  |  |  |
| AC-a3da41d2 | (진입점 미연결) | Reference.cs:79 |  | CALL_BASE | this.Invoke | ("NSD0100_SSPX_SO", new object[] { MT_NSD0100_SSPX}) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cbcb4a97 | (진입점 미연결) | Reference.cs:81 |  | RETURN | return ((DT_NSD0100_SSPX_response)(results[0])); |  | 처리 중단/반환 |  |  |  |
| AC-3d0f8fc8 | (진입점 미연결) | Reference.cs:79 |  | CALL_BASE | this.Invoke | ("NSD0100_SSPX_SO", new object[] { MT_NSD0100_SSPX}) | ⚠ 의미 확인 필요 |  |  |  |
| AC-22195015 | (진입점 미연결) | Reference.cs:81 |  | RETURN | return ((DT_NSD0100_SSPX_response)(results[0])); |  | 처리 중단/반환 |  |  |  |
| AC-688ae995 | (진입점 미연결) | Reference.cs:79 |  | CALL_BASE | this.Invoke | ("NSD0100_SSPX_SO", new object[] { MT_NSD0100_SSPX}) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d9b70e56 | (진입점 미연결) | Reference.cs:81 |  | RETURN | return ((DT_NSD0100_SSPX_response)(results[0])); |  | 처리 중단/반환 |  |  |  |

## NSD0100_SSPX_SOService.NSD0100_SSPX_SOAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c34dba6d | (진입점 미연결) | Reference.cs:92 | if ((this.NSD0100_SSPX_SOOperationCompleted == null)) | FLAG | this.NSD0100_SSPX_SOOperationCompleted | new System.Threading.SendOrPostCallback(this.OnNSD0100_SSPX_SOOperationCompleted) | 화면 필드/플래그 변경 |  |  |  |
| AC-7ce370a1 | (진입점 미연결) | Reference.cs:94 |  | CALL_BASE | this.InvokeAsync | ("NSD0100_SSPX_SO", new object[] { MT_NSD0100_SSPX}, this.NSD0100_SSPX_SOOperationComplete… | ⚠ 의미 확인 필요 |  |  |  |
| AC-30747d1e | (진입점 미연결) | Reference.cs:92 | if ((this.NSD0100_SSPX_SOOperationCompleted == null)) | FLAG | this.NSD0100_SSPX_SOOperationCompleted | new System.Threading.SendOrPostCallback(this.OnNSD0100_SSPX_SOOperationCompleted) | 화면 필드/플래그 변경 |  |  |  |
| AC-f1368df3 | (진입점 미연결) | Reference.cs:94 |  | CALL_BASE | this.InvokeAsync | ("NSD0100_SSPX_SO", new object[] { MT_NSD0100_SSPX}, this.NSD0100_SSPX_SOOperationComplete… | ⚠ 의미 확인 필요 |  |  |  |
| AC-03027334 | (진입점 미연결) | Reference.cs:92 | if ((this.NSD0100_SSPX_SOOperationCompleted == null)) | FLAG | this.NSD0100_SSPX_SOOperationCompleted | new System.Threading.SendOrPostCallback(this.OnNSD0100_SSPX_SOOperationCompleted) | 화면 필드/플래그 변경 |  |  |  |
| AC-3aa6b6b4 | (진입점 미연결) | Reference.cs:94 |  | CALL_BASE | this.InvokeAsync | ("NSD0100_SSPX_SO", new object[] { MT_NSD0100_SSPX}, this.NSD0100_SSPX_SOOperationComplete… | ⚠ 의미 확인 필요 |  |  |  |
| AC-af16be53 | (진입점 미연결) | Reference.cs:92 | if ((this.NSD0100_SSPX_SOOperationCompleted == null)) | FLAG | this.NSD0100_SSPX_SOOperationCompleted | new System.Threading.SendOrPostCallback(this.OnNSD0100_SSPX_SOOperationCompleted) | 화면 필드/플래그 변경 |  |  |  |
| AC-5ef9ede9 | (진입점 미연결) | Reference.cs:94 |  | CALL_BASE | this.InvokeAsync | ("NSD0100_SSPX_SO", new object[] { MT_NSD0100_SSPX}, this.NSD0100_SSPX_SOOperationComplete… | ⚠ 의미 확인 필요 |  |  |  |

## NSD0100_SSPX_SOService.OnNSD0100_SSPX_SOOperationCompleted

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5565f604 | (진입점 미연결) | Reference.cs:101 | if ((this.NSD0100_SSPX_SOCompleted != null)) | CALL_BASE | this.NSD0100_SSPX_SOCompleted | (this, new NSD0100_SSPX_SOCompletedEventArgs(invokeArgs.Results, invokeArgs.Error, invokeA… | ⚠ 의미 확인 필요 |  |  |  |
| AC-a3b1de6e | (진입점 미연결) | Reference.cs:101 | if ((this.NSD0100_SSPX_SOCompleted != null)) | CALL_BASE | this.NSD0100_SSPX_SOCompleted | (this, new NSD0100_SSPX_SOCompletedEventArgs(invokeArgs.Results, invokeArgs.Error, invokeA… | ⚠ 의미 확인 필요 |  |  |  |
| AC-813c7ae5 | (진입점 미연결) | Reference.cs:101 | if ((this.NSD0100_SSPX_SOCompleted != null)) | CALL_BASE | this.NSD0100_SSPX_SOCompleted | (this, new NSD0100_SSPX_SOCompletedEventArgs(invokeArgs.Results, invokeArgs.Error, invokeA… | ⚠ 의미 확인 필요 |  |  |  |
| AC-8c0c0cb7 | (진입점 미연결) | Reference.cs:101 | if ((this.NSD0100_SSPX_SOCompleted != null)) | CALL_BASE | this.NSD0100_SSPX_SOCompleted | (this, new NSD0100_SSPX_SOCompletedEventArgs(invokeArgs.Results, invokeArgs.Error, invokeA… | ⚠ 의미 확인 필요 |  |  |  |

