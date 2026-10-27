# AS-IS 액션 대조표 — NSD0011

> 원천: `Doc/asisfacts/screens/NSD0011/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 22행 · 메서드 5 · 종류 FLAG 10 · RETURN 6 · CALL_BASE 6 · ⚠ 의미 확인 필요 6


## NSD0011_DMXX_AOService..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fb795608 | .ctor | Reference.cs:38 |  | FLAG | this.Url | global::GMES_WEBSERVICE.Properties.Settings.Default.GMES_WEBSERVICE_NSD0011_NSD0011_DMXX_A… | 화면 필드/플래그 변경 |  |  |  |
| AC-a488c4a3 | .ctor | Reference.cs:40 | if ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.UseDefaultCredentials | true | 화면 필드/플래그 변경 |  |  |  |
| AC-2c3e1550 | .ctor | Reference.cs:41 | if ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.useDefaultCredentialsSetExplicitly | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b83fea1a | .ctor | Reference.cs:44 | else of ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.useDefaultCredentialsSetExplicitly | true | 화면 필드/플래그 변경 |  |  |  |
| AC-06117560 | .ctor | Reference.cs:38 |  | FLAG | this.Url | global::GMES_WEBSERVICE.Properties.Settings.Default.GMES_WEBSERVICE_NSD0011_PRD_NSD0011_DM… | 화면 필드/플래그 변경 |  |  |  |
| AC-3569ee5a | .ctor | Reference.cs:40 | if ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.UseDefaultCredentials | true | 화면 필드/플래그 변경 |  |  |  |
| AC-213607fb | .ctor | Reference.cs:41 | if ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.useDefaultCredentialsSetExplicitly | false | 화면 필드/플래그 변경 |  |  |  |
| AC-54b7e39f | .ctor | Reference.cs:44 | else of ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.useDefaultCredentialsSetExplicitly | true | 화면 필드/플래그 변경 |  |  |  |

## NSD0011_DMXX_AOService.IsLocalFileSystemWebService

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ddc2234 | .ctor | Reference.cs:111 | if (((url == null) \|\| (url == string.Empty))) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-f71a92e7 | .ctor | Reference.cs:116 | if (((wsUri.Port >= 1024) && (string.Compare(wsUri.Host, "localHost", System.StringComparison.OrdinalIgnoreCase) == 0))) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-18017ad2 | .ctor | Reference.cs:118 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-110048f3 | .ctor | Reference.cs:111 | if (((url == null) \|\| (url == string.Empty))) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-39f552fe | .ctor | Reference.cs:116 | if (((wsUri.Port >= 1024) && (string.Compare(wsUri.Host, "localHost", System.StringComparison.OrdinalIgnoreCase) == 0))) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-056fb2d3 | .ctor | Reference.cs:118 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## NSD0011_DMXX_AOService.NSD0011_DMXX_AO

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7c4eedf4 | (진입점 미연결) | Reference.cs:78 |  | CALL_BASE | this.Invoke | ("NSD0011_DMXX_AO", new object[] { MT_NSD0011_DMXX}) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bc97499f | (진입점 미연결) | Reference.cs:78 |  | CALL_BASE | this.Invoke | ("NSD0011_DMXX_AO", new object[] { MT_NSD0011_DMXX}) | ⚠ 의미 확인 필요 |  |  |  |

## NSD0011_DMXX_AOService.NSD0011_DMXX_AOAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e6a7f82a | (진입점 미연결) | Reference.cs:90 | if ((this.NSD0011_DMXX_AOOperationCompleted == null)) | FLAG | this.NSD0011_DMXX_AOOperationCompleted | new System.Threading.SendOrPostCallback(this.OnNSD0011_DMXX_AOOperationCompleted) | 화면 필드/플래그 변경 |  |  |  |
| AC-d88071a3 | (진입점 미연결) | Reference.cs:92 |  | CALL_BASE | this.InvokeAsync | ("NSD0011_DMXX_AO", new object[] { MT_NSD0011_DMXX}, this.NSD0011_DMXX_AOOperationComplete… | ⚠ 의미 확인 필요 |  |  |  |
| AC-c21b913c | (진입점 미연결) | Reference.cs:90 | if ((this.NSD0011_DMXX_AOOperationCompleted == null)) | FLAG | this.NSD0011_DMXX_AOOperationCompleted | new System.Threading.SendOrPostCallback(this.OnNSD0011_DMXX_AOOperationCompleted) | 화면 필드/플래그 변경 |  |  |  |
| AC-70fa164d | (진입점 미연결) | Reference.cs:92 |  | CALL_BASE | this.InvokeAsync | ("NSD0011_DMXX_AO", new object[] { MT_NSD0011_DMXX}, this.NSD0011_DMXX_AOOperationComplete… | ⚠ 의미 확인 필요 |  |  |  |

## NSD0011_DMXX_AOService.OnNSD0011_DMXX_AOOperationCompleted

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c80e1914 | (진입점 미연결) | Reference.cs:99 | if ((this.NSD0011_DMXX_AOCompleted != null)) | CALL_BASE | this.NSD0011_DMXX_AOCompleted | (this, new System.ComponentModel.AsyncCompletedEventArgs(invokeArgs.Error, invokeArgs.Canc… | ⚠ 의미 확인 필요 |  |  |  |
| AC-a7816f8b | (진입점 미연결) | Reference.cs:99 | if ((this.NSD0011_DMXX_AOCompleted != null)) | CALL_BASE | this.NSD0011_DMXX_AOCompleted | (this, new System.ComponentModel.AsyncCompletedEventArgs(invokeArgs.Error, invokeArgs.Canc… | ⚠ 의미 확인 필요 |  |  |  |

