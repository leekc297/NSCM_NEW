# AS-IS 액션 대조표 — MM0501

> 원천: `Doc/asisfacts/screens/MM0501/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 13행 · 메서드 6 · 종류 FLAG 6 · RETURN 4 · CALL_BASE 3 · ⚠ 의미 확인 필요 3


## MM0501_SSPX_SOCompletedEventArgs..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d8fbc9e6 | .ctor | Reference.cs:737 |  | FLAG | this.results | results | 화면 필드/플래그 변경 |  |  |  |

## MM0501_SSPX_SOService..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1cfc3916 | .ctor | Reference.cs:38 |  | FLAG | this.Url | global::GMES_WEBSERVICE.Properties.Settings.Default.GMES_WEBSERVICE_MM0501_PRD_MM0501_SSPX… | 화면 필드/플래그 변경 |  |  |  |
| AC-7c607d60 | .ctor | Reference.cs:40 | if ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.UseDefaultCredentials | true | 화면 필드/플래그 변경 |  |  |  |
| AC-535fe546 | .ctor | Reference.cs:41 | if ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.useDefaultCredentialsSetExplicitly | false | 화면 필드/플래그 변경 |  |  |  |
| AC-7ff586cd | .ctor | Reference.cs:44 | else of ((this.IsLocalFileSystemWebService(this.Url) == true)) | FLAG | this.useDefaultCredentialsSetExplicitly | true | 화면 필드/플래그 변경 |  |  |  |

## MM0501_SSPX_SOService.IsLocalFileSystemWebService

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-76623140 | .ctor | Reference.cs:113 | if (((url == null) \|\| (url == string.Empty))) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-775856b7 | .ctor | Reference.cs:118 | if (((wsUri.Port >= 1024) && (string.Compare(wsUri.Host, "localHost", System.StringComparison.OrdinalIgnoreCase) == 0))) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-b5161d42 | .ctor | Reference.cs:120 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## MM0501_SSPX_SOService.MM0501_SSPX_SO

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e3c3d2f | (진입점 미연결) | Reference.cs:79 |  | CALL_BASE | this.Invoke | ("MM0501_SSPX_SO", new object[] { MT_MM0501_SSPX}) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bd85d96d | (진입점 미연결) | Reference.cs:81 |  | RETURN | return ((DT_MM0501_SSPX_response)(results[0])); |  | 처리 중단/반환 |  |  |  |

## MM0501_SSPX_SOService.MM0501_SSPX_SOAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8bf3276b | (진입점 미연결) | Reference.cs:92 | if ((this.MM0501_SSPX_SOOperationCompleted == null)) | FLAG | this.MM0501_SSPX_SOOperationCompleted | new System.Threading.SendOrPostCallback(this.OnMM0501_SSPX_SOOperationCompleted) | 화면 필드/플래그 변경 |  |  |  |
| AC-d19a21a6 | (진입점 미연결) | Reference.cs:94 |  | CALL_BASE | this.InvokeAsync | ("MM0501_SSPX_SO", new object[] { MT_MM0501_SSPX}, this.MM0501_SSPX_SOOperationCompleted, … | ⚠ 의미 확인 필요 |  |  |  |

## MM0501_SSPX_SOService.OnMM0501_SSPX_SOOperationCompleted

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-748bd32e | (진입점 미연결) | Reference.cs:101 | if ((this.MM0501_SSPX_SOCompleted != null)) | CALL_BASE | this.MM0501_SSPX_SOCompleted | (this, new MM0501_SSPX_SOCompletedEventArgs(invokeArgs.Results, invokeArgs.Error, invokeAr… | ⚠ 의미 확인 필요 |  |  |  |

