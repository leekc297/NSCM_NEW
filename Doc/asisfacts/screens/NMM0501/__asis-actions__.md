# AS-IS 액션 대조표 — NMM0501

> 원천: `Doc/asisfacts/screens/NMM0501/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 26행 · 메서드 6 · 종류 FLAG 12 · RETURN 8 · CALL_BASE 6 · ⚠ 의미 확인 필요 6


## NMM0501_SSPX_SOCompletedEventArgs..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d080569 | .ctor | Reference.cs:737 |  | FLAG | this.results | results | 화면 필드/플래그 변경 |  |  |  |
| AC-a8895871 | .ctor | Reference.cs:737 |  | FLAG | this.results | results | 화면 필드/플래그 변경 |  |  |  |

## NMM0501_SSPX_SOService..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe4b8655 | .ctor | Reference.cs:38 |  | FLAG | this.Url | global::GMES_WEBSERVICE.Properties.Settings.Default.GMES_WEBSERVICE_NMM0501_NMM0501_SSPX_S… | 화면 필드/플래그 변경 |  |  |  |
| AC-e9819c15 | .ctor | Reference.cs:40 | if ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.UseDefaultCredentials | true | 화면 필드/플래그 변경 |  |  |  |
| AC-a3671839 | .ctor | Reference.cs:41 | if ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.useDefaultCredentialsSetExplicitly | false | 화면 필드/플래그 변경 |  |  |  |
| AC-a244f21c | .ctor | Reference.cs:44 | else of ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.useDefaultCredentialsSetExplicitly | true | 화면 필드/플래그 변경 |  |  |  |
| AC-6817c67c | .ctor | Reference.cs:38 |  | FLAG | this.Url | global::GMES_WEBSERVICE.Properties.Settings.Default.GMES_WEBSERVICE_NMM0501_PRD_NMM0501_SS… | 화면 필드/플래그 변경 |  |  |  |
| AC-a4bcd729 | .ctor | Reference.cs:40 | if ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.UseDefaultCredentials | true | 화면 필드/플래그 변경 |  |  |  |
| AC-365d9532 | .ctor | Reference.cs:41 | if ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.useDefaultCredentialsSetExplicitly | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b634fd7e | .ctor | Reference.cs:44 | else of ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.useDefaultCredentialsSetExplicitly | true | 화면 필드/플래그 변경 |  |  |  |

## NMM0501_SSPX_SOService.IsLocalFileSystemWebService

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae95e69a | .ctor | Reference.cs:113 | if (((url == null) \|\| (url == string.Empty))) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-b57ddd3f | .ctor | Reference.cs:118 | if (((wsUri.Port >= 1024) && (string.Compare(wsUri.Host, "localHost", System.StringComparison.OrdinalIgnoreCase) == 0))) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-b4a56302 | .ctor | Reference.cs:120 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-79afcb27 | .ctor | Reference.cs:113 | if (((url == null) \|\| (url == string.Empty))) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-3fc82936 | .ctor | Reference.cs:118 | if (((wsUri.Port >= 1024) && (string.Compare(wsUri.Host, "localHost", System.StringComparison.OrdinalIgnoreCase) == 0))) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-dc61421e | .ctor | Reference.cs:120 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## NMM0501_SSPX_SOService.NMM0501_SSPX_SO

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-01d51a02 | (진입점 미연결) | Reference.cs:79 |  | CALL_BASE | this.Invoke | ("NMM0501_SSPX_SO", new object[] { MT_NMM0501_SSPX}) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ba6c46a9 | (진입점 미연결) | Reference.cs:81 |  | RETURN | return ((DT_NMM0501_SSPX_response)(results[0])); |  | 처리 중단/반환 |  |  |  |
| AC-d51c3962 | (진입점 미연결) | Reference.cs:79 |  | CALL_BASE | this.Invoke | ("NMM0501_SSPX_SO", new object[] { MT_NMM0501_SSPX}) | ⚠ 의미 확인 필요 |  |  |  |
| AC-917fc826 | (진입점 미연결) | Reference.cs:81 |  | RETURN | return ((DT_NMM0501_SSPX_response)(results[0])); |  | 처리 중단/반환 |  |  |  |

## NMM0501_SSPX_SOService.NMM0501_SSPX_SOAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-92e46b6b | (진입점 미연결) | Reference.cs:92 | if ((this.NMM0501_SSPX_SOOperationCompleted == null)) | FLAG | this.NMM0501_SSPX_SOOperationCompleted | new System.Threading.SendOrPostCallback(this.OnNMM0501_SSPX_SOOperationCompleted) | 화면 필드/플래그 변경 |  |  |  |
| AC-2af0c80f | (진입점 미연결) | Reference.cs:94 |  | CALL_BASE | this.InvokeAsync | ("NMM0501_SSPX_SO", new object[] { MT_NMM0501_SSPX}, this.NMM0501_SSPX_SOOperationComplete… | ⚠ 의미 확인 필요 |  |  |  |
| AC-8eff468b | (진입점 미연결) | Reference.cs:92 | if ((this.NMM0501_SSPX_SOOperationCompleted == null)) | FLAG | this.NMM0501_SSPX_SOOperationCompleted | new System.Threading.SendOrPostCallback(this.OnNMM0501_SSPX_SOOperationCompleted) | 화면 필드/플래그 변경 |  |  |  |
| AC-3232ead7 | (진입점 미연결) | Reference.cs:94 |  | CALL_BASE | this.InvokeAsync | ("NMM0501_SSPX_SO", new object[] { MT_NMM0501_SSPX}, this.NMM0501_SSPX_SOOperationComplete… | ⚠ 의미 확인 필요 |  |  |  |

## NMM0501_SSPX_SOService.OnNMM0501_SSPX_SOOperationCompleted

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c6665ea | (진입점 미연결) | Reference.cs:101 | if ((this.NMM0501_SSPX_SOCompleted != null)) | CALL_BASE | this.NMM0501_SSPX_SOCompleted | (this, new NMM0501_SSPX_SOCompletedEventArgs(invokeArgs.Results, invokeArgs.Error, invokeA… | ⚠ 의미 확인 필요 |  |  |  |
| AC-7ba339de | (진입점 미연결) | Reference.cs:101 | if ((this.NMM0501_SSPX_SOCompleted != null)) | CALL_BASE | this.NMM0501_SSPX_SOCompleted | (this, new NMM0501_SSPX_SOCompletedEventArgs(invokeArgs.Results, invokeArgs.Error, invokeA… | ⚠ 의미 확인 필요 |  |  |  |

