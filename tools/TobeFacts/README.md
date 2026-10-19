# TobeFacts — To-Be(React/Wijmo FE + Spring/MyBatis BE) Fact 추출기

2단계(TO-BE 분석) 도구. As-is 파서(AsisFacts)와 같은 원칙 — **구문트리 기반, 주석은 Trivia 로만, 독립 교차검증 불일치 0 이 통과 기준** — 으로 To-Be 소스를 Fact(CSV) 로 바꾼다. LLM 은 쓰지 않는다.

## 실행
```
cd C:\Projects\NSCM\tools\TobeFacts
powershell -NoProfile -ExecutionPolicy Bypass -File run.ps1
```
- Node 20+ (nscm-fe 가 요구) 와 `nscm-fe\node_modules\typescript` 를 빌려 쓴다. 별도 npm install 없음.
- 설정 `tobefacts.json`: feRoot / beRoot / outDir / asisOutDir / sinks(엔드포인트 호출로 간주할 함수 목록).

## 출력 (`Doc\tobefacts\`)
| 파일 | 내용 |
|---|---|
| `files.csv` | 파일 · page_key(feature/pageDir) · MENU_ID · 역할(page/component/util/store/api/constants/types/hook/mapping/test) |
| `endpoints.csv` | **호출 지점 단위** 엔드포인트. kind=callProc/hook/http, menu/sheet/action 해석값, url(`MENU/sheet/action/call-proc`, `/admin/menu/MENU/column` …), resolved(Y/N), args, `commented`(1=주석 속 — 현행 아님) |
| `events.csv` | JSX 이벤트 prop(onClick/onChange/…), Wijmo `x.evt.addHandler(fn)`, `addEventListener` — element/event/handler |
| `controls.csv` | 대문자 컴포넌트 사용(SearchArea, FormItem, CustomDropdown, DataGrid, Button …) + 주요 props |
| `grid_columns.csv` | 하드코딩 컬럼 정의: `{binding, header…}` 객체(via=object), `<…Column binding=…/>`(jsx), 메타 모양 `{colNm, colLblNm, colWth}`(meta-shape=리터럴, meta-map=SP 결과 매핑) |
| `messages.csv` | MSG/LBL/BTN/TTL 코드 사용 지점 |
| `constants.csv` | `export const`, enum, `as const` 객체의 문자열 상수 (MENU_ID, SHEETS, DIVISION …) |
| `asis_refs.csv` | 주석에 적힌 As-is 참조 — 화면ID · SP/PKG · cs 줄번호 · 테이블 (개발자가 남긴 As-is↔To-Be 연결 근거) |
| `commented_code.csv` | 주석 처리된 코드(endpoint/jsx/code). 현행 기능으로 집계되지 않음 |
| `asis_mapping.csv` | 각 페이지의 `__asis-mapping__.md` 표(design_id, 요지, 구현 위치, 사유, 상태) |
| `procedures_dts.csv` | `configs/types/procedures.d.ts` 의 MENU×시트 request/response 키와 주석의 SP 힌트 |
| `be_endpoints.csv` | Spring Controller 매핑(http, path, 메서드, 파라미터). 주석 속 매핑은 commented=1 |
| `be_methods.csv` | Controller/Service 메서드별 호출 SQL id · 호출 메서드 · 테이블/프로시저 문자열 |
| `be_sql.csv` | MyBatis `<select/insert/update/delete>` 별 테이블 · `{call …}` 프로시저 · 파라미터 · 동적 태그 |
| `be_rules.csv` | call-proc 디스패치 근거 줄(SCM_ADM_MNU_BTN_MPG_M → API_M → PROC_M, `{call procNm`, pathMatcher 권한 경로) |
| `screens\_index.csv` | 페이지별 건수 요약 + `asis_present`(As-is Fact Pack 존재) + `dts_sheets` |
| `screens\<MENU_ID>\` | 위 CSV 의 페이지 분할본 + `<MENU_ID>_summary.md` |
| `crosscheck_report.csv` | 독립 교차검증 불일치(비어 있어야 통과) |

## To-Be 구조 요약 (파서가 전제로 삼는 사실)
- 화면 = `features/<feature>/src/pages/<pageDir>/`, 화면ID = 그 안의 `export const MENU_ID = 'XXX'`. 메뉴↔페이지 연결은 DB(SCM_ADM_MNU_M.ROUTE_PATH) 라 소스에 없다.
- 데이터 호출은 `apiClient.callProc(menu, sheet, action)` / `useTabProcQuery({menuId, sheetName, procedureAction})` / `useProcMutation` / `apiClient.post('/{MENU}/{sheet}/{btn}/call-proc')` 로 모이고, BE `GeneralController` 가 `PKG_NSCM_UI_COMM.PR_GET_PROC_INFO_LIST(mnuId, shtNm, mnuBtnCd)` 로 프로시저를 찾아 `{call procNm(...)}` 한다. **어느 SP 가 붙는지는 Oracle 메타(SCM_ADM_PROC_M) 에 있다** — 소스에서는 `(MENU, sheet, action)` 3-키까지가 사실이고, SP 이름은 `procedures.d.ts` 주석·`asis_refs`·design `05_register.sql` 에서 힌트로만 얻는다.
- Grid 컬럼은 `/admin/menu/{MENU}/column`(SCM_MST_SHEET_COLUMNS) + `spreadTitle` 시트(동적 헤더 SP) 가 기본, 하드코딩은 `grid_columns.csv` 에 따로.

## 미해결(`resolved=N`) 의 뜻
sheet/action 이 변수(`activeSheet`, `btnCd`, 공용 모달의 `menuId` 파라미터)인 호출. As-is 파서의 파라미터 전파와 같은 보강이 다음 단계 후보.

## db/ — 클라우드에서 내려받는 To-Be 메타 (2026-10-16 추가)
`db/export_tobe_meta.sql` 을 LGES 클라우드(Oracle, SCM_MGR) 에서 실행해 `Doc\tobefacts\db\` 에 CSV 7종(proc_meta, proc_params, sheet_columns, sheet_measures, combo_sql, menu, btn_auth) 을 둔다.
소스에 없는 "어느 SP/컬럼/콤보가 붙는가" 가 여기 있으므로, 파일이 있으면 `tools/Harness/gap.js` 가 엔드포인트·시트·하드코딩 컬럼 대응을 메타 기준으로 재판정한다(없으면 UNMAPPED 로 남긴다).

## framework.js — To-Be 프레임워크·공통 카탈로그 (2026-10-16)
`@foundation` / `@shared` / `features/master/src/components`(공통 모달·조회조건 Field) / `apps/web/src/mdi` 의 export 509건을 TS 컴파일러로 추출 → `Doc\tobefacts\framework\{INDEX,components,hooks,stores,apis,utils,types}.md` + `framework.csv`, `tools\Harness\rules\tobe_catalog.csv`. 각 항목: 종류·import 경로·시그니처·props·JSDoc·features 사용 수·As-is 대응(룰 사전). run.ps1 4/4 단계에 포함. 신규 화면은 **카탈로그에 있는 것만** 쓰고(check.js D01), Claude 프롬프트가 INDEX.md 를 먼저 읽는다.
