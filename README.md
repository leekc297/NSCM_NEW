# NSCM AS-IS 인덱스 + 커버리지 장부

Claude Code 가 매 세션 AS-IS 트리를 전부 훑느라 느려지는 문제를,
**스크립트가 만든 인덱스 + 검증 가능한 커버리지 장부**로 대체하는 도구 모음입니다.

- LLM이 하던 "전부 읽기" → 스크립트가 1회 수행하는 인덱싱
- 프롬프트로 강제하던 "SKIP 금지" → `Check-Coverage.ps1` 의 exit code

## 설치

`C:\Projects\NSCM` 아래에 압축을 풀면 다음 구조가 됩니다.

```
C:\Projects\NSCM\
  scripts\
    Run-AsisIndex.ps1            <- 전체 파이프라인
    asis\
      asis-config.psd1           <- 튜닝은 전부 여기서
      lib\AsisCommon.psm1
      00-Probe-Asis.ps1
      01-Extract-Foxml.ps1
      02-Scan-Sources.ps1
      03-Extract-SpInventory.ps1
    coverage\
      Init-Coverage.ps1
      Check-Coverage.ps1
  doc\                           <- 산출물 (스크립트가 생성)
```

## 현재 작업에 영향이 없는 이유

| 대상 | 동작 |
|---|---|
| AS-IS 소스 (`GSCM\`) | 읽기만 함. 쓰기·이동·삭제 없음 |
| AS-IS DB (MS SQL) | `sys.*` 카탈로그 뷰 `SELECT` 만. DDL/DML 없음 |
| TO-BE 소스 / `node_modules` / `.git` | 접근하지 않음 |
| 신규 생성 | `doc\asis\`, `doc\coverage\` 만 |

Claude Code 가 다른 창에서 돌고 있어도 그대로 실행할 수 있습니다.

## 실행 순서

### 1단계 — 정찰 (필수, 5분)

```powershell
cd C:\Projects\NSCM\scripts\asis
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\00-Probe-Asis.ps1
```

`doc\asis\_probe\probe-report.md` 를 **반드시 먼저 읽으세요.** 확인할 것:

| 리포트 절 | 정상 기준 | 낮으면 고칠 곳 |
|---|---|---|
| 2. 화면ID 적중률 | 미적중 10% 미만 | `ScreenIdPattern` |
| 3. 레이어 분포 | `ETC` 비중이 작음 | `LayerToken` |
| 6. 동적 UI 적중 | 0건이 아님 | `DynamicUiPattern` |
| 7. SP 명명규칙 | 실제 SP명이 보임 | `SpNamePattern` |

이 프로젝트의 실제 규칙을 모르는 상태로 만든 기본값이므로, **1단계에서 조정하지 않으면
이후 산출물의 정확도가 떨어집니다.** 리포트를 보내주시면 패턴을 맞춰 드리겠습니다.

### 2단계 — 전체 파이프라인

```powershell
cd C:\Projects\NSCM\scripts

# 소스만
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\Run-AsisIndex.ps1 -SkipProbe

# AS-IS DB 까지 (Windows 인증)
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\Run-AsisIndex.ps1 -SkipProbe `
    -Server localhost -Database GSCM -IntegratedSecurity
```

DB를 함께 뽑으면 SP 연결이 명명규칙 추측이 아니라 **실제 SP 목록과의 정확 매칭**이 됩니다.
(`sp_conf` 열이 `exact` 로 바뀝니다)

### 3단계 — 화면 작업 시 사용

```powershell
# 완료 선언 전 게이트. 0 이어야 완료
powershell.exe -NoProfile -File .\coverage\Check-Coverage.ps1 -ScreenId DMF0043

# 전체 잔량 현황
powershell.exe -NoProfile -File .\coverage\Check-Coverage.ps1 -Summary
```

## 산출물

| 파일 | 용도 | Claude Code 가 읽는 방식 |
|---|---|---|
| `doc\asis\screen-inventory.csv` | 화면 1행 요약 | **화면 작업 시작 시 해당 행 1개만** |
| `doc\asis\screen-file-map.csv` | 화면-파일 1:N | 커버리지 장부의 원본 |
| `doc\asis\dynamic-ui.csv` | 동적 그리드 코드 위치(파일:라인) | 해당 화면 행만 필터 |
| `doc\asis\foxml-catalog.md` | 쿼리 본문 | `foxml_refs` 의 ID 섹션만 |
| `doc\asis\foxml-catalog.csv` | 쿼리 메타(파라미터/테이블) | 조인용 |
| `doc\asis\sp-inventory.csv` | SP/함수/뷰 전수 | `sp_refs` 로 조회 |
| `doc\asis\sp\<schema>.<name>.sql` | SP 정의 원문 | 변환 대상 파일 |
| `doc\asis\sp-params.csv` | SP 파라미터 | Oracle 시그니처 설계 |
| `doc\asis\sp-dependencies.csv` | SP 참조 관계 | 이관 순서 결정 |
| `doc\coverage\<domain>.csv` | 커버리지 장부 | 완료 판정 |

`screen-inventory.csv` 주요 열:

```
screen_id, domain, file_count, total_lines,
uil_files, wsl_files, biz_files, dac_files, etc_files,   # ';' 구분
foxml_refs, sp_refs, dyn_ui_files, dyn_ui_count, entry_file
```

## 커버리지 장부 규칙

`doc\coverage\<domain>.csv`

| status | 의미 |
|---|---|
| `todo` | 미착수 |
| `wip` | 진행 중 |
| `done` | 완료 — **`evidence_path` 필수** (TO-BE 산출물 경로, 프로젝트 루트 기준 상대경로) |
| `n/a` | 변환 대상 아님 (이유를 `note` 에 기록) |
| `gone` | AS-IS 원본에서 사라짐 (자동) |

`Init-Coverage.ps1` 은 재실행해도 안전합니다.

- 신규 파일 → `todo` 추가
- **AS-IS 원본의 sha256 이 바뀌면 → `done` 이었어도 `todo` 로 회귀** (원본에서 직접 재계산)
- 그 외 기존 `status` / `evidence_path` 보존

`Check-Coverage.ps1` 완료 판정:

1. 모든 행이 `done` / `n/a` / `gone`
2. `done` 행은 `evidence_path` 가 채워져 있고 **실제 파일이 존재**
3. 원본 sha256 이 장부와 일치

→ 통과 `exit 0`, 미완 `exit 1`, 설정 오류 `exit 2`

## Claude Code 훅 연동 (선택)

`.claude\settings.json` 의 Stop 훅에 걸어 두면 세션 종료 시 잔량을 경고합니다.

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "powershell.exe -NoProfile -ExecutionPolicy Bypass -File C:\\Projects\\NSCM\\scripts\\coverage\\Check-Coverage.ps1 -Summary"
          }
        ]
      }
    ]
  }
}
```

## 재실행 주기

| 시점 | 실행 |
|---|---|
| AS-IS 소스가 갱신됐을 때 | `Run-AsisIndex.ps1 -SkipProbe` |
| AS-IS DB SP가 바뀌었을 때 | `03-Extract-SpInventory.ps1` 후 `02-Scan-Sources.ps1` |
| 화면 작업을 끝냈을 때 | 장부의 해당 행을 `done` + `evidence_path` 기입 → `Check-Coverage.ps1` |
| 매일 아침 | `Check-Coverage.ps1 -Summary` |

## 요구사항

- Windows PowerShell 5.1 (기본 탑재) 또는 PowerShell 7+
- `03-Extract-SpInventory.ps1` 은 **Windows PowerShell 5.1 권장** (`System.Data.SqlClient` 기본 제공)
- 외부 모듈·인터넷 연결 불필요. 방화벽 환경에서 그대로 동작합니다.

## 알려진 제약

- 한글 소스 인코딩은 BOM 검사 → UTF-8 엄격 디코딩 시도 → 실패 시 CP949 순으로 판별합니다.
  드물게 CP949 바이트열이 우연히 유효한 UTF-8 인 경우 오판할 수 있습니다.
- `.designer.cs` 가 없거나 컨트롤을 완전히 동적 생성하는 화면은 `dynamic-ui.csv` 의
  파일:라인으로 **실제 코드를 봐야** 컬럼 구성을 알 수 있습니다. 이 표는 "어디를 볼지"까지만
  알려 줍니다.
- `WITH ENCRYPTION` SP는 정의를 가져올 수 없습니다 (`sp-inventory.csv` 의 `is_encrypted=1`).
