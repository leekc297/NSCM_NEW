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

## Roslyn 의미 분석 (2026-11-25, `src/Semantic.cs`)
추출 뒤·전파 전에 범위 안 파일(`asisfacts.json` `semanticScreens` 화면ID 접두, `semanticAlwaysPaths` 경로 접두)을 csproj 별 `CSharpCompilation`(Compile 항목, ProjectReference, HintPath DLL, .NET Framework 참조 어셈블리)으로 다시 본다. 빌드는 하지 않는다.
- 호출 대상 특정(`CallRec.SemTarget`): 같은 이름 메서드가 여럿이면 의미 모델이 고른 메서드로만 전파. 외부 DLL 메서드로 확정되면 소스의 같은 이름 메서드로 전파하지 않음(예: DM 화면 `FoxDataClient` = `TheOne.ServiceModel.Data`, 소스 PseudoFoxClient 아님). 저장소 소스로 만드는 DLL 은 같은 시그니처면 허용
- 값 보완: 상수(다른 프로젝트 포함), `string.Empty`, 지역변수 경로별 정의(람다 바깥 변수 포함), 필드·자동 속성, 메서드 반환. 열거형은 숫자로 바꾸지 않음(switch 가드 대조용)
- 값별 조건(`Site.ValueConds`): 매개변수(또는 생성자 매개변수로 정해지는 속성)에 대한 문자열 판정 아래의 값은 전파 때 호출자 인자로 평가해 타지 않는 값을 뺌
- 결과가 문법 해석보다 덜 풀리면 바꾸지 않음. 전후 = `semantic_report.csv`, 컴파일 현황 = `semantic_projects.csv`, 요약 = `_run.log` 의 `semantic:` 줄
- 직접 SQL 실행 수집: `sinks.propertyAssign` 에 `CommandText` 추가(SP 직접 호출 → `NOT_IN_FOXQUERY`)
- DM 44화면 전후(2026-11-25): BIZ_MATCH 3,167 → 869(가짜 PseudoDataClient 연결 2,296 제거), WRAPS_FOX_REQUEST 1,166 → 0, UNRESOLVED 8 → 1, MATCH 1,168 그대로. 대조 = `Doc/asisfacts_cmp/compare.py`
- 범위 확대(2026-11-25 18:53): `semanticScreens` = DMF·SCP·SSP. SCP·SSP 전후 BIZ_MATCH 3,809 → 1,021, WRAPS_FOX_REQUEST 1,686 → 184, UNRESOLVED 18 → 2, NOT_IN_FOXQUERY 58 → 31, MATCH 1,509 그대로. BIZ 후보가 하나로 정해진 PseudoDataClient 지점 180곳 모두 쿼리 ID 접두(fp) 규칙과 일치
- 요청 파라미터 대입 `req.Parameters["pagePath"] = request.QueryId`: request 가 요청 객체 매개변수이고 속성이 생성자 인자로 정해지면 매개변수 자리표시자로 둠 → 전파 때 호출자의 요청 객체로 바뀜(WRAPS_FOX_REQUEST)

### 의미 분석 일괄 조회 `resolve` (2026-11-25, 검사 하네스용)
`dotnet _bin/AsisFacts.dll resolve --config asisfacts.json --in 요청.csv --result 결과.csv`
- 요청 열: id, file(asisRoot 상대), line, expr(그 줄의 식 원문), kind
  - `value`(기본): 값 후보(`{p:이름}` 매개변수 의존, `{?식}` 미결정)
  - `defs`: 식이 가리키는 변수·필드·속성·매개변수에 값을 넣는 오른쪽 식(local·init·assign·caller)
  - `target`: 호출식의 호출 대상 소스 메서드 선언 위치와 매개변수 이름
- Python 도우미 = `tools/Harness/verify/asis_sem.py`(파일 sha256 기준 캐시 `Doc/verify/_asis_sem_cache.json`, `ASIS_SEM_OFF=1` 이면 끔)
- 사용처: `facts_combosrc.py` — 정규식이 원천 대입을 못 찾은 변수를 `defs` 로 찾고, 등록되지 않은 원천 함수는 `target` + `sites.csv` 로 그 메서드 안 SP·요청 파라미터를 원천으로 씀. DM·SCP·SSP 34화면 같은 입력 끔/켬 대조: 콤보 원천 미해결 65 → 61(SCP0100 6 → 2)
- `facts_lockrules.py` 에도 비교 우변 상수 조회를 붙여 같은 대조를 했으나 RAW 241 → 241(바뀐 조건 0행, 좌변이 런타임 컨트롤 값)이라 되돌림
- 2026-11-25 20:42 나머지 추출기 연결(끔/켬 같은 입력 대조 · 효과 0 은 되돌림)
  - `facts_defcols.py` 연결: 같은 이름이 클래스마다 다른 값(충돌)인 Def* 상수를 사실 행의 파일 기준 `value` 로 확정(`defcol_alias_sem.csv`). DM·SCP·SSP 남는 혼합 이름 1,548 → 834곳, 충돌 725 → 11곳(DMF0003 555 → 127)
  - `popup_args_check.py` 연결: 팝업 인자 변수가 같은 메서드 지역 대입에 없으면 `value` 로 원천 식 확정(`sem_prefetch`). 32화면 FAIL 79 → 76, NA 738 → 735, PASS 391 → 399, 원천 표기만 바뀐 행 100(변수 → 컨트롤·셀)
  - `facts_popup.py` 연결: 팝업 클래스의 `FoxDataRequest(변수)` SP 이름을 `asis_sem.fox_endpoints` 로 확정. 팝업·Framework 비리터럴 110곳 중 82곳 확정. 208화면 SP 칸 1,756 → 1,876(86화면 223칸 변경). 인자 원천 종류도 popup_args 와 같이 바뀜
  - `gen_param_map.py`: 팝업·Framework 변수 SP 이름 보조 조회를 붙였으나 sp_pair 249·param_map 2,243 행 변화 0 이라 되돌림
  - 연결 안 함(측정 근거): `facts_gridcols` 미확정 123칸 = 런타임 값 · `facts_cellrules` Def* 참조 955 중 못 찾음 0 · `facts_sortrules` 코드 정렬 누락 = SQL 문자열·LINQ(SQL 정렬은 이미 의미 분석 엔드포인트로 읽음)

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

## 액션 추출 (2026-10-23 추가 — 사용자 지시: 파싱 단계에서 핸들러 본문의 구체 액션까지)
`pack` 이 화면마다 추가로 만든다(`src/Actions.cs`, 분류 사전 `actions_dict.json`):
- `actions.csv` — 화면 클래스 메서드의 **모든 실행 문장**(메서드당 1회). kind = VALUE_CLEAR/VALUE_SET(컨트롤 값) · LIST_REBIND/LIST_CLEAR/LIST_BIND(목록) · GRID_INIT/GRID_CLEAR/GRID_SET/GRID_LOCK/GRID_STYLE · STATE(Enabled/Visible/ReadOnly) · FLAG(화면 필드) · STATE_RESET · MESSAGE · VALIDATE · RETURN/THROW/FLOW · ENDPOINT(endpoint 열 = FoxQuery 키) · COMBO_DATA · POPUP · CALL_LOCAL · CALL_EXT(사전 미등록 외부 호출) · OTHER(미분류 — 버리지 않음) 등. guard = if/else/switch case/loop/try/catch/lambda 문맥.
- `actions_entries.csv` — 진입점(이벤트·버튼 override·기타 override·생성자, 진입점 미연결 포함) → 도달 메서드(depth·path·호출 지점의 call_guard 누적).
- `actions_summary.csv` — 진입점별 문장 수·분류 수·OTHER·CALL_EXT·분류율·kind 분포.
- 제외: 주석·#if 비활성(Roslyn trivia), legacy 사본 파일, 디자이너 `InitializeComponent` 본문(props/controls/events.csv 담당).
- 분류율 개선 = `actions_dict.json` 에 반복 CALL_EXT 추가(코드 수정 불필요). 화면 지정 `pack` 도 `screens/_index.csv` 의 다른 화면 행을 보존한다(2026-10-23 수정).

## 2a — 액션 → DB 정적 연결 (2026-10-23 추가 — 사용자 지시: 콤보·조회조건은 DB 안 2~3단계 실행까지 담는다)
- `pack`(전체 실행)이 `framework_actions/`(01.Framework 182파일의 액션 — `GetDMInnerTable` 등 switch case 별 필터·엔드포인트)를 추가 생성.
- `python links.py [화면ID…]` → `screens/<ID>/action_links.csv`: 액션 1건이 DB 까지 닿는 체인(홉 1행). PARAM(요청 파라미터) · FW_METHOD/FW_CASE(프레임워크 메서드·넘긴 코드값의 case 동작) · ENDPOINT(FoxQuery·BIZ→BLL→DLL, 같은 프로젝트·같은 클래스 우선) · SP/SQL · SP_BRANCH(`IF @변수='값'` — 넘긴 값과 일치 RESOLVED / 미확정 CANDIDATE) · SP_REF(테이블·하위 SP 4단계) · STORED_QUERY(SCM_ADM_DQ_LIST.DQ_TEXT) · DYNAMIC_SQL(sp_executesql) · DATA_SOURCE(목록·그리드에 넣는 화면 필드가 채워진 행).
- 키 비교는 대소문자 무시. 스캐너 래퍼 전파의 일반 템플릿 키(`{p:…}`, `PseudoDataClient`)는 실행부에서 무시(실제 키는 요청 생성 행).
- 한계: 지역 변수로 넘긴 목록 데이터 원천 미추적(DATA_SOURCE UNRESOLVED) · 동적 키/동적 SQL 은 실행 시 결정(2b 데이터셋 단계에서 확정).

## 2b — 액션 데이터셋 (2026-10-23 — 사용자 승인: 계획(--dry) 검토 후 실행)
- `python datasets.py [--dry] [화면ID…]` → `datasets/plan.csv`(계획) · `datasets/runs.csv`(실행 1건 1행: 파라미터 값·출처·안전판정·상태·결과셋별 행 수) · `datasets/<DB>/<SP|키>/<run_id>_rs<n>.csv`(결과셋마다 최대 1,000행) · `screens/<ID>/action_data.csv`(액션 → 실행).
- 안전: closure 영구 테이블 쓰기·COMMIT·시스템 SP·동적 SQL 쓰기 문자열 = 실행 안 함(UNSAFE) · 트랜잭션+항상 ROLLBACK · 실행 뒤 트랜잭션 로그 기록 수 확인(1차 전체 0).
- 인라인 SQL 은 sp_executesql 바인딩(FoxQuery 런타임과 동일) · dbType=command 파라미터는 본문 텍스트 치환(필터 없음 = 빈 텍스트).
- 재실행 시 OK/EMPTY 는 재사용(오류·신규만 실행). 2026-10-23 결과: 4,150건 — OK 1,228 · EMPTY 1,894 · UNSAFE 585 · UNRESOLVED 261 · ERROR 174 · TIMEOUT 8.
- 한계: 지역 변수로 넘기는 파라미터는 빈값(실제 운영 호출 값 원천 없음 — TB_FX_PerformanceLog* 0행, TB_STORED_PROCEDURE_LOG = DDL 이력) → EMPTY 다수의 원인.
- ⭐ **사용 원칙(사용자 결정 2026-10-23)**: datasets/·action_data.csv 는 **기대값으로 쓰지 않는다** — 데이터는 사용자 권한·조건마다 다르므로 사전 데이터셋은 잘못된 판정을 낳는다. 실행 가능 여부·결과 컬럼 구조·UNSAFE 판정 참고용. 실제 데이터 동작 확인은 E2E 실행 시점에 실제 사용자로 추출해 검증한다. 2b 개선(대표 사용자 보정·재실행)은 진행하지 않음.
