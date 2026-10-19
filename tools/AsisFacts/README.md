# AsisFacts — GSCM As-is 정적 사실 추출기 (1단계)

As-is(C#.NET WinForms + TheOne FoxQuery) 소스에서 **화면 → 호출 → 엔드포인트(FoxQuery) → SP/SQL** 연결 사실을
누락 없이 뽑아 CSV로 만든다. LLM 해석은 이 출력만 근거로 한다.

## 원칙
1. **As-is 원본은 읽기 전용.** outDir이 asisRoot 안이면 실행을 거부한다.
2. **주석/문자열/`#if` 판정은 정식 파서만 사용.** C#은 Roslyn Trivia, XML은 XComment 노드, T-SQL은 ScriptDom 토큰. 정규식으로 판정하지 않는다.
3. **주석 안의 코드도 버리지 않는다.** 같은 Roslyn으로 다시 파싱해 `commented=1`로 기록하고(중첩 `// //`, `////` 포함) 활성 집계에서는 제외한다. `#if` 비활성 블록은 `active=0`.
4. **결정하지 못한 값도 버리지 않는다.** `{?식}`(미해결), `{p:이름}`(파라미터 의존) 자리표시자로 남긴다.
5. **두 개의 독립 구현으로 대조한다.** Roslyn 결과와 Python 자체 렉서(`verify/crosscheck.py`)의 건수가 파일 단위로 1건이라도 다르면 실패한다.

## 실행 (Windows)
```powershell
cd C:\Projects\NSCM\tools\AsisFacts
powershell -NoProfile -ExecutionPolicy Bypass -File run.ps1
```
빌드 → 함정 회귀테스트(`tests/trap`) → 전체 스캔(약 2분) → 교차검증 순으로 진행한다. 하나라도 실패하면 exit 1.
설정은 `asisfacts.json`: `asisRoot`, `outDir`, `preprocessorSymbols`(Release 기준 `TRACE`), sink 정의.

## 화면별로 보기
`run.ps1` 마지막 단계에서 `outDir\screens\` 가 만들어진다 (scan 결과만 다시 묶으려면 `pack.ps1 [화면ID]`, 수 초).
- `screens\_index.csv` : 화면 전체 목록 (파일 수, 현행/구버전 사본, 엔드포인트·미해결·주석 호출 건수, 현행 csproj)
- `screens\<화면ID>\<화면ID>_summary.md` : 파일 구성 → 기능 흐름(진입점 → 메서드 → 엔드포인트 → SP) → 엔드포인트 목록 → 메타 컬럼(프레임워크 Grid 메타 포함) → 이벤트 → 컨트롤 → 확인 필요 → 주석 처리된 호출
- 같은 폴더 CSV: `flow.csv`, `endpoints.csv`, `events.csv`, `controls.csv`, `meta_reads.csv`, `commented_calls.csv`, `files.csv` (모두 variant 열로 current / legacy / only 구분)

## 해석 계층
| 계층 | 처리 |
|---|---|
| FoxQuery `.foxml` | `파일명.id` 키 (예: `DM.DMF0052_GET_SPREAD_TITLE`), procedure 텍스트 = 실제 SP |
| FoxQuery `.xml` (SQLS) | `pagePath#id` 키 (예: `FP\Common\Authority#findInstanceAuthority`), update-batch 하위 insert/update/delete-sql 포함 |
| 인라인 SQL | ScriptDom → 테이블(SELECT/INSERT/UPDATE/DELETE/MERGE), EXEC, 함수, 임시테이블, 동적SQL |
| C# sink | `new FoxDataRequest(id)`, `new FoxBizRequest(bll, method)`, `client.ExecuteDataSet("id")`, `DbAccess.CreateCommand("id")`, `.QueryID = "id"`, `request.Parameters["pagePath"/"batchId"/"procedure"/"code"]` |
| 값 해석 | 리터럴, 상수/정적필드(클래스·조상·중첩 struct), 지역변수 모든 대입 후보, `+`, `$""`, `string.Format/Concat`, `ToUpper()` 등, 삼항 |
| 래퍼 전파 | sink 값이 메서드 파라미터에 의존하면 그 메서드를 파생 sink로 보고 모든 호출 지점으로 역전파(고정점). 예: `FP_ExecuteProcedure2(sp)`, `UsrComboBox.DataBind(type)` |
| switch 디스패치 | `switch(param) case X:` 안의 sink에는 가드가 붙고, 호출 인자가 case와 일치할 때만 연결. 예: `Data.Common(Data.Type.YesOrNo)` → `CommonData.YesOrNo` |
| BIZ | `FoxBizRequest("CommonData","CommonDataList")` → `[FoxBizMethod]` 메서드 → 내부 sink에 요청 파라미터를 이름으로 치환 |

## 출력 (outDir)
| 파일 | 내용 |
|---|---|
| `files.csv` | 파일·레이어·csproj·화면ID·인코딩·sha256·구문오류·사이트/주석/비활성 건수 |
| `foxquery_endpoints.csv` / `_params.csv` / `_sql_refs.csv` / `foxquery_sql\` | 엔드포인트 카탈로그, 파라미터, SQL 참조 객체, 인라인 SQL 원문 |
| `sites.csv` | 모든 sink 지점(원본 + 파생). values / values2 / req_params / via(전파 경로) / active / commented |
| `endpoint_usage.csv` | 사이트별 카탈로그 조인 결과와 상태 (아래) |
| `calls.csv` | 전체 호출 그래프(메서드 → 피호출, 인자 해석값) |
| `members.csv`, `events.csv`, `controls.csv`, `props.csv` | 클래스/메서드, 이벤트 배선, 디자이너 컨트롤 트리, 속성 대입 |
| `meta_reads.csv` | `row["COL"]`, `Field<T>("COL")` 등 DB 메타 컬럼 소비 지점 (예: `CreateSheetHeaderColumn` → `COLUMN_NAME`, `COLUMN_WIDTH`, `VALID_YN` …) |
| `literals.csv` | 활성 코드의 식별자형 문자열과 카탈로그 일치 여부 (안전망) |
| `trivia_fragments.csv` | 재파싱한 주석/비활성 블록 목록 |
| `crosscheck_report.csv` | 독립 교차검증 불일치 목록 (0행이어야 통과) |

### endpoint_usage.status
`MATCH` 카탈로그 일치 · `MATCH_BARE` 네임스페이스 없이 유일 일치 · `MATCH_PATTERN` 일부 미해결, 패턴으로 후보 특정 ·
`BIZ_MATCH` BIZ 메서드 존재 · `TEMPLATE` 파라미터 의존(호출 지점의 derived 행에서 해석) ·
`WRAPS_FOX_REQUEST` 요청 객체 전달(원 생성 지점에서 해석) · `EMPTY` 빈 값(디자이너 기본값) ·
`NOT_IN_FOXQUERY` FoxQuery에 없음(SP 직접호출/폐기 → DB 단계에서 확인) · `UNRESOLVED` 정적 결정 불가 · `MATCH_COMMENTED_ONLY` 주석 처리된 엔드포인트만 존재

## 2단계: DB (`db.ps1`)
접속정보는 `C:\Projects\NSCM\.env.asis` 의 `ASIS_DB_*` 를 읽는다 (asisfacts.json `db.envFile`). 비밀번호는 어떤 출력에도 남기지 않는다.
SELECT 만 실행하며(가드로 차단), SP 는 실행하지 않는다. 결과는 `outDir\db\`, 이어서 화면 Pack 을 다시 만든다.

| 파일 | 내용 |
|---|---|
| `db_objects.csv` | SP/함수/뷰/테이블/트리거/동의어 목록, 생성·수정일 |
| `modules\*.sql` | SP·함수·뷰 원문 |
| `db_module_refs.csv` | 원문 ScriptDom 분석: 테이블(SELECT/INSERT/UPDATE/DELETE/MERGE), EXEC, 함수, 임시테이블, 동적SQL (주석 제외) |
| `db_code_branches.csv` | `IF @Code = 'X'` / `IN (...)` 분기별 참조 객체 → 공통코드/API 디스패치 SP 해석 |
| `db_params.csv`, `db_columns.csv`, `db_indexes.csv`, `db_dependencies.csv`, `db_synonyms.csv`, `db_rowcounts.csv` | 카탈로그 |
| `db_resultsets.csv` | SP 결과셋 컬럼 (dm_exec_describe_first_result_set_for_object, 실행 없음) |
| `meta\*.csv`, `db_meta_tables.csv` | 메타 테이블 데이터. 대상 = `metaSourceModules`(예: `*SPREAD_TITLE*`, 권한·공통코드 SP)가 SELECT 하는 테이블 + `metaTablePatterns` + `metaTables` |

Pack 은 DB 결과가 있으면 자동으로 결합한다: 엔드포인트별 SP 내부 참조(EXEC 전이 포함), DB 에 없는 SP 경고,
FoxQuery 없이 직접 호출된 SP, `biz:CommonData.CommonDataList [code=X]` 의 코드 분기 테이블, 화면ID가 값으로 들어있는 메타 행(`dbmeta_*.csv`).

## 3단계: division별 Grid (`grid.ps1`)
- 메타 규칙 전개(업무 규칙): DIVISION_ID 빈값=전체·값=해당 division만 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수(항상 표시) / DEFAULT_FLAG='Y'=기본 선택 / 그 외=선택 가능
  → 화면 폴더 `grid_rule.csv` (컬럼 × division 매트릭스), 요약 10장 (division별 `필수+기본/선택` 컬럼 수)
- 실제 실행 검증: `*_SPREAD_TITLE` SP 중 EXEC 전이 closure 에 영구 테이블 쓰기·동적 SQL·원문 없는 모듈이 없는 SP 만, division×sheet 별로
  트랜잭션 안에서 실행하고 항상 ROLLBACK (`db\grid\grid_sp_safety.csv` 에 판정 근거). 사용자 = `__ASISFACTS__`(개인 컬럼설정 없음 → 기본 분기),
  날짜 파라미터 = 오늘~+28일, 기타 = `gridParamDefaults` 또는 NULL (`grid_runs.csv` 에 기록)
  → 화면 폴더 `grid_diff.csv`: 규칙과 실제 결과가 다른 컬럼

## Grid 구성 방식 판정 (화면 요약 11·12장, `screens\_index.csv` grid_mode)
DM 은 메타(SCM_MST_SHEET_COLUMNS/MEASURE) 구동이 기본이지만 하드코딩이 섞여 있고, SCP/SSP 는 하드코딩이 기본이다. 그래서 메타만 보지 않는다.
- `grid_code.csv` (scan 산출): `Add*Column`(하드코딩 컬럼 / DB 루프), `CreateSheetHeaderColumn`·`SetSheetHeaderColumn`·`SetSpreadColumn`(메타 생성),
  `Columns[...].Visible = …`·`VisibleColumns`(표시 변경), `AddSheet/ChangeSheet`(시트 문맥). 각 호출에 **감싸는 분기 조건**(if/else/switch/foreach, 상수는 리터럴로 치환)을 붙인다.
- 화면별 `grid_code.csv`: 시트 문맥 추정 + 구분(COLUMN / META_BUILD / OVERRIDE / SHEET)
- 구성 방식: `META(프레임워크)` / `HARDCODED` / `DB루프(코드)` / `HYBRID: …` / `(+코드 표시/라벨 변경)`
- `grid_effective.csv` (12장): 메타 규칙 + 코드 컬럼 + 코드 표시 변경을 division 별로 합성. 분기 조건은 division 변수 비교(`==`, `Equals`, `Substring(0,2).Equals("EE")`, switch case, 시트명 비교)만 정적 평가하고, 판단 못 한 건은 `?` 로 남긴다(실행 확인 필요). 추측하지 않는다.

## 시트 연결 규칙 (요약 12장 `연결 규칙` 열, grid_effective.csv `sheet_rule`)
메타(SCM_MST_SHEET_COLUMNS)의 시트와 코드가 실제로 쓰는 시트는 다를 수 있다. 시트마다 다음 중 하나로 판정한다.
- `META+코드연결` : 메타 시트명을 코드가 AddSheet/ChangeSheet/InitSheet 로 사용 → 메타 규칙 + 코드 변경 합성
- `메타 미연결(코드는 하드코딩)` : 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성 → 코드가 진실, 메타 행은 미사용
- `메타 정의만, 코드 미참조(미사용 가능)` : 메타에만 있고 코드 어디서도 안 씀 → 폐기 후보 (예: DMF0052 `Site Popup`; 실제 팝업은 `EDI Summary GSCM DATA Popup` 시트를 하드코딩)
- `코드 하드코딩 전용(메타 없음)` : AddSheet + Add*Column 리터럴만 → 코드가 진실
- 하드코딩/표시변경의 시트 범위는 **같은 클래스가 AddSheet 로 만든 시트**로 한정한다 (팝업 컬럼이 본 화면 시트에 섞이지 않게).
- 파일 variant: 화면 전용 csproj 에 같은 파일명이 있을 때만 `legacy`; 전용 csproj 에 없는 팝업·공용 파일은 `shared`(현행 취급).

## Agent (`agent.ps1 화면ID`)
Fact Pack 만을 입력으로 LLM 이 분석서 5종을 쓰고, 프로그램이 **건수 게이트**를 검사한다(엔드포인트·이벤트 핸들러·시트·SP 가 문서에 전부 등장해야 PASS, 실패 시 누락 목록을 붙여 1회 재시도).
- 드라이버: `claude-cli`(Claude Code 로그인, headless `claude -p`) / `api`(ANTHROPIC_API_KEY) / `dry`(프롬프트만)
- 원본 .cs 를 LLM 에 주지 않는다. 주석 처리된 호출은 '주석 처리됨'으로만 쓰도록 지시한다.
- 산출: `Doc\asisfacts\agent\<ID>\{analysis,source_links,web_components,oracle_migration,tobe_design}.md`, `_gate.csv`
- 기존 `Doc\_analysis\domain_*\screens\<ID>_*\` 8종 중 validation.md / expressions.md 는 기존 추출 스크립트 산출을 그대로 쓰고, figma_link.md 는 사용자 작성.

## 다음 단계
- 3단계: SP 본문 상세(동적 SQL·커서·임시테이블 → Oracle 변환 난이도), division별 실효 Grid 정의 전개
- 4단계: 화면별 Fact Pack 기반 단독 실행 Agent

## Agent 2차 문서 3종 (2026-10-16 추가)
- `agent.ps1 <화면ID>` 는 1차 분석서 5종 뒤에 **업무분석서 `business_analysis.md` · 화면설계서 `screen_design.md` · 단위테스트 `unit_test.md`** 를 2차 호출로 생성합니다.
- `-Phase docs` : 이미 PASS 한 1차 분석서를 그대로 두고 문서 3종만 생성 / `-Phase analysis` : 1차만.
- 2차 게이트(`_gate.csv` 의 `summary2`): 업무분석서에 엔드포인트·SP 전부, 화면설계서에 컨트롤·시트·이벤트·엔드포인트 전부, 단위테스트의 근거 열에 이벤트·엔드포인트·시트 전부. `total` 행이 최종 PASS/FAIL.
