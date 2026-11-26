# AS-IS 소스 파서 결과 (공통 + 화면별)

AS-IS GSCM(C#.NET WinForms + TheOne FoxQuery) 원본 소스를 정적 분석해 만든 사실 파일 모음입니다.
화면 → 호출 → FoxQuery 엔드포인트 → SP/SQL 연결을 CSV로 남깁니다.

## 만든 방법

| 항목 | 내용 |
|---|---|
| 도구 | `tools/AsisFacts` (Roslyn 4.11 + SQL Server ScriptDom) |
| 원본 | `C:\Projects\NSCM\GSCM` (읽기 전용, 수정하지 않음) |
| 실행 | `run.ps1 -SkipBuild`: 함정 회귀시험(주석·문자열·#if) → 전체 스캔 → Python 독립 교차검증 → 화면별 Pack |
| 생성 시각 | ZIP 파일 이름의 `yyyyMMdd_HHmm` |
| 설정 | `tools/AsisFacts/asisfacts.json` |

## 2026-11-25 변경: Roslyn 의미 분석 추가

종전에는 문법 트리만 보고 값을 해석했습니다. 이번 판부터 csproj마다 컴파일을 만들어 의미 모델(SemanticModel)로 다시 확인합니다.

- 적용 범위: 화면ID가 `DMF` 로 시작하는 파일, `01.Framework\` 아래 파일
- 호출 대상 특정: 같은 이름의 메서드가 여러 곳에 있으면 실제로 연결되는 메서드로만 이어 붙입니다.
  - 외부 DLL 메서드로 확정된 호출은 소스의 같은 이름 메서드로 잇지 않습니다.
  - 예: DM 화면의 `client.ExecuteDataSet` 는 `using TheOne.ServiceModel.Data` 를 통해 외부 DLL로 연결됩니다. 소스의 PseudoFoxClient가 아닙니다.
- 값 해석 보완:
  - 상수(다른 프로젝트 포함)
  - `string.Empty`
  - 지역변수의 경로별 정의(람다 안에서 바깥 변수를 쓰는 경우 포함)
  - 필드
  - 메서드 반환값
- 값별 조건: `if (!request.QueryId.ToLower().StartsWith("fp"))` 처럼 매개변수에 따라 갈리는 값은 호출자 인자로 조건을 평가해 타지 않는 값을 뺍니다.
- 직접 SQL 실행 수집: `command.CommandText = 프로시저명` 을 수집 지점으로 추가했습니다. FoxQuery를 거치지 않는 SP 직접 호출이 `NOT_IN_FOXQUERY` 로 남습니다.
- 전후 대조(DM 44화면 활성 호출):

| 상태 | 의미 분석 전 | 의미 분석 후 | 이유 |
|---|---|---|---|
| BIZ_MATCH | 3,167 | 869 | 가짜 PseudoDataClient 연결 2,296건, DMF0068 사본 2건 제거 |
| WRAPS_FOX_REQUEST | 1,166 | 0 | 위 가짜 연결에서 생긴 행 |
| UNRESOLVED | 8 | 1 | DMF0009·DMF0010 SP 2개로 해소, DMF0046 람다 바깥 변수 해소, DMF0068 사본은 직접 SP |
| NOT_IN_FOXQUERY | 15 | 13 | DMF0068 현행 파일의 가짜 DataSql 연결 2건 제거, 사본 직접 SP 2건 |
| EMPTY | 1,658 | 1,662 | DMF0009·DMF0010 빈 값 초기 경로 |
| MATCH | 1,168 | 1,168 | 변화 없음 |

- 남은 미해결:
  - UNRESOLVED 1건: DMF0044 `sFoxData`. 팝업 `LoadData` 를 부르는 곳이 소스에 없어 소스만으로 정할 수 없음
  - MATCH_PATTERN 2건: DMF0068 `{?definition_path}`. 나머지 글자로 후보는 특정됨
- 대조 기준: 같은 코드·같은 원본을 의미 분석 끔(`Doc/asisfacts_cmp/base`)과 켬(운영 출력)으로 스캔해 비교(2026-11-25 18:01)

## ZIP 구성

| 경로 | 내용 | 설명 |
|---|---|---|
| `asisfacts/` 바로 아래 파일 | 전 화면 공통 결과 | `asisfacts/README.md` |
| `asisfacts/foxquery_sql/` | FoxQuery 인라인 SQL 원문 | `asisfacts/foxquery_sql/README.md` |
| `asisfacts/screens/<화면ID>/` | 화면별 결과(Fact Pack) | `asisfacts/screens/README.md` |
| `asisfacts/framework_actions/` | 공통 프레임워크(BaseForm 등) 메서드의 실행 문장(Pack 이 만듦) | `asisfacts/framework_actions/README.md` |
| `asisfacts/db/` | AS-IS SCM DB(LGCE_SCMDEV) 추출: 카탈로그, SP 원문, 메타 테이블, Grid SP 실행, 배치 | `asisfacts/db/README.md` |
| `asisfacts/_fpdb/` | AS-IS FP DB(LGCE_FPDEV_TR) 추출 | `asisfacts/_fpdb/README.md` |
| `asisfacts/datasets/` | 액션별 AS-IS SP·SQL 실행 결과셋(ROLLBACK) | `asisfacts/datasets/README.md` |

DB 추출 결과(`db/`, `_fpdb/`, `datasets/`)는 이번에 다시 뽑지 않았습니다. 추출일은 각 README 에 적었습니다(SCM DB 2026-10-16, FP DB·datasets 2026-10-23, 배치 2026-11-09).

## 넣지 않은 폴더

같은 출력 폴더(`Doc/asisfacts`)에 있지만 소스 파서·DB 추출 결과가 아니라서 넣지 않았습니다.

| 폴더 | 내용 | 크기(2026-11-25 측정) |
|---|---|---|
| `agent/` | 분석서 생성 에이전트 결과 | 18MB |
| `_review/` | 만든 단계 미확인 | 52KB |
| `framework/` | 만든 단계 미확인 | 4KB |

## 값 표기

| 표기 | 뜻 |
|---|---|
| `{p:이름}` | 메서드 매개변수에 따라 정해지는 값. 호출 지점(derived 행)에서 풀림 |
| `{?식}` | 정적으로 정할 수 없는 값. 원문 식을 그대로 남김 |
| ` \|\| ` | 값 후보 여러 개 |
| `variant` 열 | `current` 현행 csproj 소속 · `legacy` 구버전 사본 · `only` 사본 없음 |
