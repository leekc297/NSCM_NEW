# E2E — NSCM To-Be 화면 자동 테스트 (Playwright)

Fact Pack 으로 고정한 화면 플랜(`Doc\gen\<ID>\e2e_plan.json`) 과 Oracle 메타·테스트계정에서 **스펙을 생성**한다. 사람이 스펙을 쓰지 않는다.

| 종류 | 태그 | 내용 |
|---|---|---|
| 스모크 | `@smoke` | 화면 열림(404/권한 안내 아님) → **조회조건 라벨**(2026-10-21 SCP0100: 공용 SearchArea 의 접힌 조건을 화살표로 펼친 뒤, 기대 라벨 = To-Be LBL 문구(`msg_master.csv` EN) → As-is 라벨('*' 제거) → '/' 분할 후보 순 · 괄호 접미 `Unit (Qty)`/`From (YYYYMMDD)` 허용 · FE `__asis-mapping__.md` 의 **§1 컨트롤 행이 '제외'** 인 As-is 컨트롤(dead control·NO-OP 콤보)·As-is designer `Visibility = Never` 로 숨긴 컨트롤·조회조건 카탈로그(`Doc/_rules_v2/_mapping/search_conditions*.md`)가 '조회조건 삭제' 로 닫은 항목은 검사하지 않고 어노테이션 `labels` 에만 기록. 카탈로그의 To-Be 명칭(Project→PJT 등)은 첫 후보. 그리드 컬럼은 Fact Pack grid_code 의 SetLayout/VisibleColumns 대상(조회조건에 따라 숨는 컬럼)을 누락에서 뺀다 — 2026-10-21 SCP0100) → Division 선택 → 조회(call-proc HTTP<400, 오류 알림 없음) → 그리드 컬럼 대사(메타 `sheet_columns.csv` 우선, 없으면 As-is 라벨, 누락 ≤20% — **기대 시트 = 실제 조회된 시트**: 첫 SEARCH call-proc 의 FE 시트명을 `Doc\gen\<ID>\register.json` 의 adminSheetName 으로 바꿔 고른다. SCP0100 은 기본 Search Mode 가 SEARCH_LEVEL 시트라 REPORT 컬럼을 기대하면 오탐) → **동적 기간 컬럼**(As-is 기간형 타이틀 SP·DB루프가 있으면 `gridBindings` 로 Wijmo 컬럼 정의를 읽어 정적 메타 밖 binding ≥1 + 사내 배선 타이틀 시트 call-proc 호출 확인, 어노테이션 `dynamic` — 2026-10-20 SCP0096 '헤더 6/기대 6 PASS' 구멍) |
| CRUD | `@crud` | 공용 사이클 `lib/crud.ts`(2026-10-20, **접속된 Oracle 에 실제 저장** — 사용자 승인). 저장 SP 가 있는 화면: **Insert 가 있으면** 마커 행 Insert(F8) → 입력 → Save(F7) → 재조회(존재) → 수정 → Save → Delete(F9) → Save → 재조회(부재) — 어떤 경우에도 끝에 마커 행 정리(`cleaned`). **Insert 가 없는 셀 편집 저장형**은 편집 가능 셀(Wijmo readOnly 아님) 값을 바꿔(숫자 +1 · Y/N 토글 · 문자 뒤 X) Save → 재조회로 반영 확인 → **원래 값으로 복원 Save** → 재조회로 복원 확인(`restored`, 실패 시 테스트 FAIL + 수동 복원 필요). 조회 전용 화면은 Save 비노출 확인. 어노테이션 `crud` |
| 권한 | `@auth` | 통합테스트 데이터셋의 **테스트계정 12 × Division(40/81/82)**: 접근 가능 여부, 노출 버튼(btn_auth 메타 있으면 그룹별 기대 버튼 대사 — 버튼 이름은 텍스트 → aria-label/title → 가장 가까운 상위 aria-label/title 순. SubTitle 의 Excel 다운로드는 아이콘 전용이라 MUI Tooltip 의 상위 div aria-label 'Excel' 로만 잡힌다, 2026-10-21), Division 별 조회 성공·DIVISION 컬럼 값 범위. 저장 없음 |
| 권한별 CRUD | `@authcrud` | **계정별** 기대 권한을 To-Be 메타에서 만든다: 그룹 소속 `user_group_user.csv` → 메뉴 권한 `user_group_menu.csv`(접근) → 버튼 권한 `btn_auth.csv`(SAVE/INSERT/DELETE/EDIT, 그 메뉴에 등록된 코드만 비교). 계산식은 BE `PKG_NSCM_UI_COM_AUTH.PR_GET_MNU_BTN_AUTH` 와 같다 — **그 메뉴 권한이 있는 그룹들의 버튼 합집합**(메뉴 권한 없는 그룹의 버튼 행은 제외). `run-e2e.cmd` 가 실행 전에 이 3표를 사내 DB 에서 새로고침한다(권한은 수시로 바뀜). 메뉴 권한 없는 계정도 `/view/<ID>` 직접 접근으로는 열린다(FE 라우트 가드 없음) → 어노테이션 `gap` 으로 기록하고 버튼·편집은 '없어야 함' 으로 검증. 계정마다 로그인 → 접근 기대 대조 → Save/Insert/Delete 노출 기대 대조 → **허용 계정**은 위 CRUD 공용 사이클(마커 행 또는 편집기 확인) → **비허용 계정**은 편집기 안 열림 + SAVE 계열 call-proc 0. btn_auth 에 그 그룹 행이 없으면 실측만 기록. 어노테이션 `authcrud`(tobeGroups·menuAccess·expected·dataset·matrix) + `crud` |

## 테스트 사용자 명부 `users.json` (2026-10-20 — 사용자가 직접 관리)
- `divisions.<DIV>.<역할>` = 계정: 40/81/82 × DM Admin · DM Planner · DM Planner (W/S) · DM Viewer · SCP Planner. `admins.<영역 ADMIN>` = SYSTEM ADMIN + 해당 ADMIN 권한 계정(DM: minyonglee1·k0101 / SCP: minyonglee1·jaeuk.shin / SSP: minyonglee1·attackgo). SCP/SSP 의 Division 별 사용자는 `pending` 에 표기(차후 추가).
- `gen-e2e.js` 는 이 파일이 있으면 **여기 등록된 계정 전부**를 auth/authcrud 계정으로 쓴다(역할 계정은 배정 Division 만, ADMIN 계정은 40/81/82 전부). 없는 계정(BE 사용자 아님)은 `probe-accounts.js` 결과로 걸러 경고만 남긴다. 역할·Division 은 표기/범위용이고 **기대 권한은 사내 DB 메타로 계산**한다. 파일이 없으면 데이터셋 `accounts.json` 으로 되돌아간다.
- Vibe_Manager: `UI 분석·생성·보완 › 테스트 › 👥 E2E 사용자 관리` 로 연다. 저장 후 다음 실행부터 반영.
- **테스트 모드(화면 성격별 계정 축, 2026-10-20)** — 실행 시 지정: `run-e2e.cmd <종류> <ID> --mode admin|division|auto` (Vibe_Manager 의 E2E 작업은 선택 입력으로 묻는다). `admin` = 영역 ADMIN **1명**(그 영역 전용 ADMIN 우선, 없으면 minyonglee1: DMF→DM ADMIN, SCP→SCP ADMIN, SSP→SSP ADMIN) + 메뉴 권한 없는 사용자 1명, Division 반복 없음 → **마스터 화면**. `division` = **화면 영역의 역할만** Division 별로(DMF 화면 → DM Admin·DM Planner·DM Planner (W/S)·DM Viewer / SCP 화면 → SCP Planner / SSP → 차후) + 영역 ADMIN 1 + 메뉴 권한 없는 사용자 1 → Division 데이터 범위가 있는 화면. 명부(users.json)는 계정 풀이지 전수 테스트 대상이 아니다. `auto` = `users.json screens[<메뉴>].mode` 가 있으면 그것, 없으면 Division 조회조건 유무로 추정. 명시한 모드는 `users.json screens` 에 저장돼 다음 기본값이 된다(예: SCP0096 = admin). 체인(🚀/🧩/📏/🚒) 안에서는 auto 로 돈다.

## 로그인(비밀번호 없음)
FE 와 동일하게 `POST {beUrl}/user/login {userId}`(JsonLoginFilter · 비밀번호 없음) 로 세션을 만든다 — 2026-10-20 변경. `GET /sso/dev-login` 은 BE `SsoDevController` 에 `@AuthCheck(NONE)` 이 없어 401 이라 fallback 으로만 쓴다. 계정은 `accounts.json`(04_TESTDATA_SET.xlsx 의 테스트계정_권한해석) — 비밀번호 저장/입력 없음. qa/prd 에는 이 엔드포인트가 없다.

## 실행(노트북)
```
run-e2e.cmd smoke                 # Doc\gen 전체 화면 스모크
run-e2e.cmd crud SCP0096          # CRUD (마커 행 / 편집기 확인)
run-e2e.cmd auth SCP0096          # 권한 (계정×Division) — @auth(?!crud) 로 authcrud 는 제외
run-e2e.cmd authcrud SCP0096      # 권한별 CRUD (계정별 btn_auth 기대 ↔ 실측)
run-e2e.cmd all DMF0003 DMF0052   # 지정 화면 전부(4단계: smoke+crud+auth+authcrud)
```
선행: FE `http://127.0.0.1:5173`(vite.cmd) + BE `http://localhost:8080`(local 프로파일, Oracle 연결) 기동 — 미응답이면 `[FAIL]` exit 5 로 즉시 중단. Vibe_Manager(1.9.6) 의 E2E 작업은 미기동이면 ☕ BE Start / 🎨 FE Start 로 먼저 기동한 뒤 돌린다. 결과 `Doc\e2e\results\_summary.md / _summary.csv / html\index.html`.
node_modules 는 자동 설치하지 않는다(외부망 금지 — VM 에서 설치한 것을 복사).

**실행 보호(2026-10-21 사고 보완)** — 다른 run-e2e 가 공용 로그를 쥐고 있어 리다이렉트가 전부 실패했는데 exit 0 이 반환돼 Vibe_Manager 가 '완료' 로 표시한 사고:
- `runlock.js` 동시 실행 잠금 `Doc\e2e\_run.lock` — 살아 있는 PID 가 있으면 `[FAIL] 다른 E2E 실행이 진행 중` **exit 4** (`node runlock.js status` 로 확인, 프로세스가 없으면 자동 무시)
- 실행마다 별도 로그 `Doc\e2e\logs\run_<RUNID>_<종류>.log`(최근 40개 유지), `_run.log` 는 한 줄 색인만

**화면 ID 중간 폴더(2026-11-06 사용자 지시)** — 여러 화면을 동시에 돌려도 서로 영향 없게. 11-06 10:17 SCP0084·0037·0016 smoke 가 동시에 돌며 공용 `results.json`·`artifacts`(Playwright 가 시작 때 비움)·`_summary.csv` 를 덮어써 SCP0084 실패 원인을 읽을 수 없었던 사고 보완:
- `run-e2e.cmd <종류> <ID 1개>` → 결과 `Doc\e2e\results\<ID>\`(results.json · html\ · artifacts\ · shots\ · dberr_partial.json · _summary.csv · _summary.md) · 로그 `Doc\e2e\logs\<ID>\run_<RUNID>_<종류>.log` · 색인 `Doc\e2e\logs\<ID>\_run.log` · 잠금 `Doc\e2e\_run.e2e.<ID>.lock`(같은 화면만 직렬, 다른 화면은 동시)
- 화면 여러 개·없음(`--all`) → 종전 공용 폴더·공용 잠금 `_run.lock`. 화면별 잠금과 공용 잠금은 서로 막는다(같은 화면 결과를 건드리므로). 호출자가 `E2E_RESULTS` 를 주면 그 폴더를 쓴다
- 요약: 화면별 `results\<ID>\_summary.csv` 가 **정본**. 공용 `results\_summary.csv`·`_summary.md` 는 `report.js` 가 잠금(`results\_summary.lock`) 안에서 화면별 요약을 다시 모아 원자 교체하는 **색인**(화면 전체 목록용)
- 읽는 쪽 규칙: 화면 하나 = 화면 폴더 먼저, 없으면(전환 전 결과) 공용 위치 — Python `tools/Harness/verify/e2e_paths.py`(summary_rows · run_logs · shots_dirs · golden_path) · VibeManager `e2eSummaryFile`·`e2eForId`
- 공용 입력 파일 원자 쓰기: `accounts.json`(probe-accounts) · `Doc\tobefacts\db\*.csv`(dbconn.write_csv) · `Doc\e2e\specs\_index.csv`·`_matrix.csv`(gen-e2e — 이번 화면 행만 교체, 다른 화면 행 유지 · 종전엔 마지막 화면 1개만 남았다)
- `report.js` 가 results.json 이 이번 실행 뒤 갱신됐는지 확인 — 아니면 **exit 3**(Playwright 미실행). 종료코드: 2 node_modules 없음 · 3 결과 미갱신 · 4 잠금 · 5 FE/BE 미기동 · 6 스펙 생성 실패 · 그 외 Playwright 코드
- `run-e2e.cmd` 는 **ASCII 전용**으로 유지한다 — chcp 65001 배치에 한글이 있으면 cmd 가 goto/블록 뒤 파일 위치를 잘못 잡아 깨진다(실측). 한글 메시지는 node 스크립트(runlock/report)에서 출력

## 파일
`gen-e2e.js`(스펙 생성) · `gen-accounts.py`(계정/권한매트릭스/시나리오 추출) · `lib/nscm.ts`(화면 헬퍼: 로그인=POST /api/user/login · 공지 팝업 닫기 dismissNotices · 딥링크 탭 활성화 activateScreenTab · 보이는 요소 우선 visibleFirst, /view/MENU, SearchArea·SubTitle 버튼·Wijmo 그리드·call-proc 수집) · `fixtures/test.ts`(account/division 옵션) · `report.js`(results.json → 요약) · `playwright.config.ts` · `e2e.config.json`(URL/경로)

## 보완 포인트(플랜 데이터로 고친다 — 스펙 손수정 금지)
- CRUD 키 컬럼: `Doc\e2e\specs\<ID>.plan.json` 의 `keyColumns` 에 필수 입력 컬럼 헤더를 넣으면 마커를 그 컬럼에 입력한다
- 라벨 미확정(F12 WARN) 화면은 조회조건 라벨 검사가 soft 실패로 남는다 → `lbl_codes.csv`/msg_master 보강이 근본 조치
- 메타 CSV(`export_tobe_meta.py`) 를 내려받으면 컬럼·버튼 권한 대사가 메타 기준으로 바뀐다

**기대값 결함 큐(2026-10-21)** — 🩹 E2E 오류 보완이 실패 항목을 (a)화면 (b)DB·메타 (c)기대값/측정 결함 으로 판정하고 `Doc/gen/<ID>/E2E_REPAIR.md` 섹션 끝에 `판정요약: a= b= c=` 를 쓴다. (c) 는 `Doc/e2e/_expectation_issues.md` 에 append 된다(생성기·헬퍼 보정 큐 — E2E 도구 담당이 처리). 체인은 (c) 만 남으면 그 단계를 WARN 으로 넘기고 계속 진행하므로, **이 파일이 쌓이면 gen-e2e.js/lib 를 고쳐야 한다**. 10-21 하루 (c) 9건의 원천: 조회조건 카탈로그·As-is 숨김(Visibility.Never)·SetLayout 조건부 컬럼·헤더 사양(행 수/리터럴/분리/높이) 측정.

## 소요 시간 계측(2026-11-06 — CheckList 속도 개선 ①)
판정·동작은 바꾸지 않고 걸린 시간만 남긴다(개선 전후 비교의 유일한 근거 · 감·예측 금지).
- `run_verify.py` — 도구마다 로그 줄 `[시간] 도구 · 시작 HH:MM:SS · N.Ns · rc` · 단계 끝 `[시간] 단계 <key> 끝 · N분` · 실행 끝에 `Doc/verify/<ID>/_timing.csv`(실행마다 누적).
- `fixtures/test.ts` — 테스트마다 `_test_timing.jsonl` 한 줄(VERIFY_ID 있으면 `Doc/verify/<ID>/`, 없으면 결과 폴더): 로그인·화면 열기·조회·고정 대기(waitForTimeout)·시간초과 탐침(locator.waitFor 실패)·나머지, 로그인·화면 열기 내부 구간(`parts`), 요청 수, 시간을 쓴 위치 상위 15곳(`sites` = 종류@파일:줄).
- 집계: `python tools/Harness/verify/timing_report.py <ID> [--all]`.
- 한계: 팝업으로 새로 뜬 page 의 대기는 안 센다 · wait/miss 는 open·search 안의 것과 겹친다 · miss 에는 Promise.race 에서 진 쪽(실제 시간 안 씀)도 섞인다.
- 첫 개선(같은 날): `Nscm.activateScreenTab` — 딥링크가 Home 으로 되돌아갈 때 8초 시간초과를 다 기다린 뒤 탭을 누르던 것을, URL 이 1초 이상 /view/<ID> 가 아니면 바로 탭 클릭 보정으로. SCP0127 smoke 실측 화면 열기 8.84s → 1.9s(13:36 vs 13:39), 판정 동일(PASS 2·FAIL 1·같은 실패 문구).

## 허위 FAIL 근본 보완(2026-11-06 P1~P7 · 상세 Doc/verify/_checker_root_cause_20261106.md)
- P1 측정 전제 게이트: 스펙 `put()` 이 측정 맥락 `mctx{calls,rows,req}` 를 결과 행에 싣고 judge 가 '행 0·호출 0 + 없음 류 증거' FAIL 을 ERROR `[측정 전제 미충족]` 로 돌린다(stat PRECOND_ERROR).
- P2 공용 컴포넌트 계약: `tools/Harness/rules/common_contract.csv`(CC-nnn) — 기대 원천 우선순위 TO-BE 확정 > TO-BE 메타 > 공용 계약 > AS-IS. judge stat CONTRACT. 공용 컴포넌트를 고치면 이 표도 고친다.
- P3 FAIL 승격 게이트: `tools/Harness/rules/check_maturity.csv` status=trial 검사의 FAIL 은 `[시험 검사 CM-nnn]` 판정필요로만 발행 · 화면 2개 이상 사용자 확인 뒤 confirmed. 검사기 자체 회귀 `checker_regress.py <ID> [--baseline]`(골든 SCP0007·SCP0096 기준 Doc/verify/_checker_golden/) 이 docs 단계에 돈다(경고).
- P4 측정 전제 helper `lib/precond.ts measurable(nscm,{rows,binding,control,headerRows})` — EG315·G1 단일선택·A5 Division 컬럼에 배선. 새 검사기는 측정 전에 호출한다.
- P5 유사 사용자 판정: 다른 화면 사용자 판정과 같은 규칙·대상/증거 패턴이면 judge 가 note `유사 사용자 판정:` → CheckList 설명에 '★ … 전 화면 제외 여부 결정 요청'.
- P6 재현 표식: 조치 필요 설명에 '재현 2회(이전 실행도 FAIL)' / '1회 실측 — 재현 확인 필요'(e2e_results.json.prev 대조).
- P7 놓친 결함: B4 AS-IS 전용 후보가 있으면 NA 로 묻지 않고 판정필요 `[AS-IS 에만 있는 후보]` · 원장 행 '필수 조건 자동 채움(검사기 우회 기록)' = nscm.search 자동 채움 횟수(>0 이면 판정필요).
