# asisfacts: 전 화면 공통 결과

AS-IS 소스 전체(.cs 3,312개, csproj 381개, 2026-11-10 기준 `_run.log`)를 한 번에 스캔한 결과입니다. 화면별 폴더는 이 파일들을 화면ID로 나눠 묶은 것입니다.

## 스캔 결과

| 파일 | 내용 | 주요 열 |
|---|---|---|
| `files.csv` | 파일 목록. 레이어, csproj, 화면ID, 인코딩, sha256, 구문 오류, 주석·비활성 건수 | file, layer, project, screen_id, parse_errors |
| `members.csv` | 클래스, 메서드, 속성, 필드 선언 | class_full, member, kind, params, base_list, line |
| `calls.csv` | 전체 호출 그래프. 호출한 메서드 → 불린 메서드, 인자 해석값 | member, callee, receiver, args |
| `sites.csv` | SP·쿼리 호출 지점 전체(원본 + 호출자 쪽으로 전파된 derived). 해석값, 요청 파라미터, 전파 경로 | site_kind, kind, values, values2, req_params, via |
| `endpoint_usage.csv` | 호출 지점을 FoxQuery 카탈로그와 맞춘 결과. 화면별 SP 연결의 기준 파일 | candidate, key, status, via |
| `endpoint_usage_summary.txt` | status 별 건수 | |
| `events.csv` | 이벤트 연결(`+=`). 컨트롤, 이벤트, 처리 메서드 | target, event, handler |
| `controls.csv` | 디자이너 컨트롤 트리 | name, type, parent |
| `props.csv` | 속성 대입 | target, prop, value |
| `meta_reads.csv` | DB 메타 컬럼을 읽는 지점(`row["COL"]` 등) | receiver, column, via |
| `grid_code.csv` | 코드로 Grid 컬럼·헤더·시트를 정의하는 호출 | api, args, conditions, columns |
| `literals.csv` | 코드 안 식별자형 문자열과 카탈로그 일치 여부(누락 안전망) | value, catalog_match |
| `trivia_fragments.csv` | 주석·비활성(#if) 블록을 다시 파싱한 목록 | kind, line, end_line, sites |
| `crosscheck_report.csv` | Roslyn ↔ Python 독립 렉서 건수 불일치(0행이어야 통과) | file, metric, python, roslyn |
| `semantic_report.csv` | 2026-11-25 추가. 의미 분석으로 값을 다시 푼 지점의 전후 값과 값별 조건 | before, after, value_conds, result |
| `semantic_projects.csv` | 2026-11-25 추가. 의미 분석용 csproj 컴파일 현황 | trees, refs, missing_refs, errors, unresolved_symbol_errors |
| `_run.log` | 스캔 실행 기록(단계별 건수, 의미 분석 요약 줄 `semantic:`) | |

## FoxQuery 카탈로그

| 파일 | 내용 |
|---|---|
| `foxquery_endpoints.csv` | FoxQuery 엔드포인트 전체. `.foxml` 은 `파일명.id`(예: `DM.DMF0052_GET_SPREAD_TITLE`), `.xml` 은 `pagePath#id`. procedure 이면 sp_name |
| `foxquery_params.csv` | 엔드포인트 파라미터(이름, 속성, DB 형식, 방향) |
| `foxquery_sql_refs.csv` | 인라인 SQL이 참조하는 테이블·SP·함수(ScriptDom 분석) |
| `foxquery_errors.txt` | FoxQuery 파일 읽기 오류(비어 있으면 0건) |

## 다른 단계 기록

| 파일 | 내용 |
|---|---|
| `agent-log.txt` | 분석서 생성 에이전트 실행 기록 |
| `grid-log.txt` | Grid 단계(`grid.ps1`) 실행 기록 |

## endpoint_usage.status

| 값 | 뜻 |
|---|---|
| `MATCH` | 카탈로그 키 일치 |
| `MATCH_BARE` | 네임스페이스 없이 이름만으로 1건 일치 |
| `MATCH_PATTERN` | 값 일부가 미해결. 나머지 글자로 후보 특정 |
| `BIZ_MATCH` | BIZ 메서드(`[FoxBizMethod]`) 존재 |
| `TEMPLATE` | 매개변수 의존. 호출 지점(derived 행)에서 풀림 |
| `WRAPS_FOX_REQUEST` | 요청 객체를 넘기는 지점. 원래 생성 지점에서 풀림 |
| `EMPTY` | 빈 값(디자이너 기본값, 초기값 경로) |
| `NOT_IN_FOXQUERY` | FoxQuery에 없음. SP 직접 호출 또는 미등록 |
| `UNRESOLVED` | 정적으로 정할 수 없음 |
| `MATCH_COMMENTED_ONLY` | 주석 처리된 엔드포인트만 있음 |
