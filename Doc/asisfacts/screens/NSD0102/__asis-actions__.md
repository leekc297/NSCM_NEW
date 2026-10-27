# AS-IS 액션 대조표 — NSD0102

> 원천: `Doc/asisfacts/screens/NSD0102/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 22행 · 메서드 5 · 종류 FLAG 10 · RETURN 6 · CALL_BASE 6 · ⚠ 의미 확인 필요 6


## NSD0102_SSPX_AOService..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ba24db4 | .ctor | Reference.cs:38 |  | FLAG | this.Url | global::GMES_WEBSERVICE.Properties.Settings.Default.GMES_WEBSERVICE_NSD0102_NSD0102_SSPX_A… | 화면 필드/플래그 변경 |  |  |  |
| AC-529b69c6 | .ctor | Reference.cs:40 | if ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.UseDefaultCredentials | true | 화면 필드/플래그 변경 |  |  |  |
| AC-7f3f8d65 | .ctor | Reference.cs:41 | if ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.useDefaultCredentialsSetExplicitly | false | 화면 필드/플래그 변경 |  |  |  |
| AC-048a04b1 | .ctor | Reference.cs:44 | else of ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.useDefaultCredentialsSetExplicitly | true | 화면 필드/플래그 변경 |  |  |  |
| AC-e35df0dc | .ctor | Reference.cs:38 |  | FLAG | this.Url | global::GMES_WEBSERVICE.Properties.Settings.Default.GMES_WEBSERVICE_NSD0102_PRD_NSD0102_SS… | 화면 필드/플래그 변경 |  |  |  |
| AC-37c4cec2 | .ctor | Reference.cs:40 | if ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.UseDefaultCredentials | true | 화면 필드/플래그 변경 |  |  |  |
| AC-6f8835de | .ctor | Reference.cs:41 | if ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.useDefaultCredentialsSetExplicitly | false | 화면 필드/플래그 변경 |  |  |  |
| AC-e8fe5722 | .ctor | Reference.cs:44 | else of ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.useDefaultCredentialsSetExplicitly | true | 화면 필드/플래그 변경 |  |  |  |

## NSD0102_SSPX_AOService.IsLocalFileSystemWebService

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-63b1df41 | .ctor | Reference.cs:111 | if (((url == null) \|\| (url == string.Empty))) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-7c2068d3 | .ctor | Reference.cs:116 | if (((wsUri.Port >= 1024) && (string.Compare(wsUri.Host, "localHost", System.StringComparison.OrdinalIgnoreCase) == 0))) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-da002fd4 | .ctor | Reference.cs:118 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-1fb9829d | .ctor | Reference.cs:111 | if (((url == null) \|\| (url == string.Empty))) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-2e078105 | .ctor | Reference.cs:116 | if (((wsUri.Port >= 1024) && (string.Compare(wsUri.Host, "localHost", System.StringComparison.OrdinalIgnoreCase) == 0))) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-972dc511 | .ctor | Reference.cs:118 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## NSD0102_SSPX_AOService.NSD0102_SSPX_AO

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-57a0d0a6 | (진입점 미연결) | Reference.cs:78 |  | CALL_BASE | this.Invoke | ("NSD0102_SSPX_AO", new object[] { MT_NSD0102_SSPX}) | ⚠ 의미 확인 필요 |  |  |  |
| AC-426c741a | (진입점 미연결) | Reference.cs:78 |  | CALL_BASE | this.Invoke | ("NSD0102_SSPX_AO", new object[] { MT_NSD0102_SSPX}) | ⚠ 의미 확인 필요 |  |  |  |

## NSD0102_SSPX_AOService.NSD0102_SSPX_AOAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b7c0d5bd | (진입점 미연결) | Reference.cs:90 | if ((this.NSD0102_SSPX_AOOperationCompleted == null)) | FLAG | this.NSD0102_SSPX_AOOperationCompleted | new System.Threading.SendOrPostCallback(this.OnNSD0102_SSPX_AOOperationCompleted) | 화면 필드/플래그 변경 |  |  |  |
| AC-4c8d00e5 | (진입점 미연결) | Reference.cs:92 |  | CALL_BASE | this.InvokeAsync | ("NSD0102_SSPX_AO", new object[] { MT_NSD0102_SSPX}, this.NSD0102_SSPX_AOOperationComplete… | ⚠ 의미 확인 필요 |  |  |  |
| AC-111f988e | (진입점 미연결) | Reference.cs:90 | if ((this.NSD0102_SSPX_AOOperationCompleted == null)) | FLAG | this.NSD0102_SSPX_AOOperationCompleted | new System.Threading.SendOrPostCallback(this.OnNSD0102_SSPX_AOOperationCompleted) | 화면 필드/플래그 변경 |  |  |  |
| AC-4a62e8c3 | (진입점 미연결) | Reference.cs:92 |  | CALL_BASE | this.InvokeAsync | ("NSD0102_SSPX_AO", new object[] { MT_NSD0102_SSPX}, this.NSD0102_SSPX_AOOperationComplete… | ⚠ 의미 확인 필요 |  |  |  |

## NSD0102_SSPX_AOService.OnNSD0102_SSPX_AOOperationCompleted

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b99c911b | (진입점 미연결) | Reference.cs:99 | if ((this.NSD0102_SSPX_AOCompleted != null)) | CALL_BASE | this.NSD0102_SSPX_AOCompleted | (this, new System.ComponentModel.AsyncCompletedEventArgs(invokeArgs.Error, invokeArgs.Canc… | ⚠ 의미 확인 필요 |  |  |  |
| AC-501d13d4 | (진입점 미연결) | Reference.cs:99 | if ((this.NSD0102_SSPX_AOCompleted != null)) | CALL_BASE | this.NSD0102_SSPX_AOCompleted | (this, new System.ComponentModel.AsyncCompletedEventArgs(invokeArgs.Error, invokeArgs.Canc… | ⚠ 의미 확인 필요 |  |  |  |

