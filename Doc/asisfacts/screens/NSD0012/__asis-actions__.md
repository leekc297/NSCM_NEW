# AS-IS 액션 대조표 — NSD0012

> 원천: `Doc/asisfacts/screens/NSD0012/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 22행 · 메서드 5 · 종류 FLAG 10 · RETURN 6 · CALL_BASE 6 · ⚠ 의미 확인 필요 6


## NSD0012_DMXX_AOService..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7379029f | .ctor | Reference.cs:38 |  | FLAG | this.Url | global::GMES_WEBSERVICE.Properties.Settings.Default.GMES_WEBSERVICE_NSD0012_NSD0012_DMXX_A… | 화면 필드/플래그 변경 |  |  |  |
| AC-1d95dcd1 | .ctor | Reference.cs:40 | if ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.UseDefaultCredentials | true | 화면 필드/플래그 변경 |  |  |  |
| AC-d352ad24 | .ctor | Reference.cs:41 | if ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.useDefaultCredentialsSetExplicitly | false | 화면 필드/플래그 변경 |  |  |  |
| AC-5bc81c56 | .ctor | Reference.cs:44 | else of ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.useDefaultCredentialsSetExplicitly | true | 화면 필드/플래그 변경 |  |  |  |
| AC-186d4104 | .ctor | Reference.cs:38 |  | FLAG | this.Url | global::GMES_WEBSERVICE.Properties.Settings.Default.GMES_WEBSERVICE_NSD0012_PRD_NSD0012_DM… | 화면 필드/플래그 변경 |  |  |  |
| AC-02932fe1 | .ctor | Reference.cs:40 | if ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.UseDefaultCredentials | true | 화면 필드/플래그 변경 |  |  |  |
| AC-efcf1a3f | .ctor | Reference.cs:41 | if ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.useDefaultCredentialsSetExplicitly | false | 화면 필드/플래그 변경 |  |  |  |
| AC-6f8138dc | .ctor | Reference.cs:44 | else of ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.useDefaultCredentialsSetExplicitly | true | 화면 필드/플래그 변경 |  |  |  |

## NSD0012_DMXX_AOService.IsLocalFileSystemWebService

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-579295d6 | .ctor | Reference.cs:111 | if (((url == null) \|\| (url == string.Empty))) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-9f5fadd9 | .ctor | Reference.cs:116 | if (((wsUri.Port >= 1024) && (string.Compare(wsUri.Host, "localHost", System.StringComparison.OrdinalIgnoreCase) == 0))) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-fa4f12de | .ctor | Reference.cs:118 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-7aec3ced | .ctor | Reference.cs:111 | if (((url == null) \|\| (url == string.Empty))) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-435b6227 | .ctor | Reference.cs:116 | if (((wsUri.Port >= 1024) && (string.Compare(wsUri.Host, "localHost", System.StringComparison.OrdinalIgnoreCase) == 0))) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-1d9266d6 | .ctor | Reference.cs:118 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## NSD0012_DMXX_AOService.NSD0012_DMXX_AO

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b4c92cf1 | (진입점 미연결) | Reference.cs:78 |  | CALL_BASE | this.Invoke | ("NSD0012_DMXX_AO", new object[] { MT_NSD0012_DMXX}) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4f12f4e6 | (진입점 미연결) | Reference.cs:78 |  | CALL_BASE | this.Invoke | ("NSD0012_DMXX_AO", new object[] { MT_NSD0012_DMXX}) | ⚠ 의미 확인 필요 |  |  |  |

## NSD0012_DMXX_AOService.NSD0012_DMXX_AOAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-931f15ce | (진입점 미연결) | Reference.cs:90 | if ((this.NSD0012_DMXX_AOOperationCompleted == null)) | FLAG | this.NSD0012_DMXX_AOOperationCompleted | new System.Threading.SendOrPostCallback(this.OnNSD0012_DMXX_AOOperationCompleted) | 화면 필드/플래그 변경 |  |  |  |
| AC-cb57102a | (진입점 미연결) | Reference.cs:92 |  | CALL_BASE | this.InvokeAsync | ("NSD0012_DMXX_AO", new object[] { MT_NSD0012_DMXX}, this.NSD0012_DMXX_AOOperationComplete… | ⚠ 의미 확인 필요 |  |  |  |
| AC-53f05589 | (진입점 미연결) | Reference.cs:90 | if ((this.NSD0012_DMXX_AOOperationCompleted == null)) | FLAG | this.NSD0012_DMXX_AOOperationCompleted | new System.Threading.SendOrPostCallback(this.OnNSD0012_DMXX_AOOperationCompleted) | 화면 필드/플래그 변경 |  |  |  |
| AC-fc8c409b | (진입점 미연결) | Reference.cs:92 |  | CALL_BASE | this.InvokeAsync | ("NSD0012_DMXX_AO", new object[] { MT_NSD0012_DMXX}, this.NSD0012_DMXX_AOOperationComplete… | ⚠ 의미 확인 필요 |  |  |  |

## NSD0012_DMXX_AOService.OnNSD0012_DMXX_AOOperationCompleted

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9a060c3 | (진입점 미연결) | Reference.cs:99 | if ((this.NSD0012_DMXX_AOCompleted != null)) | CALL_BASE | this.NSD0012_DMXX_AOCompleted | (this, new System.ComponentModel.AsyncCompletedEventArgs(invokeArgs.Error, invokeArgs.Canc… | ⚠ 의미 확인 필요 |  |  |  |
| AC-136f4ff0 | (진입점 미연결) | Reference.cs:99 | if ((this.NSD0012_DMXX_AOCompleted != null)) | CALL_BASE | this.NSD0012_DMXX_AOCompleted | (this, new System.ComponentModel.AsyncCompletedEventArgs(invokeArgs.Error, invokeArgs.Canc… | ⚠ 의미 확인 필요 |  |  |  |

