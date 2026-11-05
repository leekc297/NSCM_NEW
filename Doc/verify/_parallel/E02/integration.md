# E02 팝업 — 메인 세션 통합 요청 (에이전트는 공용 파일을 고치지 않았다)

## 1. 새 파일(E02 소유)
- `tools/E2E/lib/popupprobe.ts` — 열린 팝업 측정·조작·변이(`CL_POPMUT`)
- `Doc/e2e/specs/eg_popup.spec.ts` — @eg-popup. 결과 = `$E2E_RESULTS/popup_results.json`, `popup_rowsets.json`
- `tools/Harness/verify/facts_popup.py` — AS-IS 팝업 사실. 출력 `Doc/verify/_parallel/E02/facts/<ID>.json`
- `tools/Harness/verify/facts_popup_meta.py` — TO-BE 메타(읽기 전용). 출력 `facts/<ID>.meta.json`
- `tools/Harness/verify/facts_popup_golden.py` — 팝업 목록 ↔ AS-IS SP·문서 원천 SQL. 출력 `<run>/popup_source.csv`
- `tools/Harness/verify/facts_popup_accounts.py` — 계정 간 팝업 비교. 출력 `<run>/popup_accounts.csv`

## 2. 공용 파일 변경 요청

### 2-1 `tools/Harness/verify/run_verify.py`
- 전: facts_popup 단계·eg_popup 실행 없음
- 후: E2E 앞에 `facts_popup.py <AS-IS ID>`, `facts_popup_meta.py <ID> --account <계정>` · E2E 체인에 `eg_popup`(EG_META=1) · 뒤에 `facts_popup_golden.py <결과폴더> <ID>`
- 이유: 현재 코드는 수동 실행 전용. 출력 폴더도 `_parallel/E02/facts` 고정이라 통합 시 `Doc/asisfacts/screens/<ID>/popup_facts.json` 으로 옮기는 편이 맞다(스펙 `FACTS`·python `OUT`·`FACTS` 상수 3곳).

### 2-2 `tools/Harness/verify/ledger.py` — 행 정의
- 전: 팝업 행은 G5·H6·M3(그리드 트리거) 위주
- 후: 호출(facts `calls[]`)마다 아래 표의 check 1행 생성. `row_id` = 메뉴+호출 키(클래스·트리거·컬럼)+check 해시
- 이유: 원장에 자리가 없으면 측정해도 판정이 CheckList 에 안 나온다(T8).

| check | 규칙 | check | 규칙 |
|---|---|---|---|
| OPEN·DATA | M3 | ORDER | B3(ORDER 없으면 NA) |
| TITLE | H5·I2 | IDENTITY | D5 |
| BTN_ORDER·NO_COL·NO_WIDTH·COUNT | H6 | MERGE | H3 |
| COND_LIST·COND_ENABLED | G4 | COND_MULTI | B6 |
| DIV_FIXED·PERIOD·FILTER_ARG·TEXT_PASS·CORNERS | G5 | PERIOD_BACK·PICK_OK·PICK_DBL·SELECT_MODE | M4·C3 |
| FILTER_ROWS·FILTER_LIKE·FILTER_ALL | G1·G2 | FILTER_CASE | G8 |
| FILTER_COMMA | G9 | GRID_SORT·GRID_FILTER | K1 |
| GRID_KEYS | K3 | GRID_LOCK | D3 |
| LAYOUT_*·DRAG*·RESIZE_* | H4 | TOPLINE·SECTION_TITLE | H6 |
| DYN_COLS | A8·G5 | PICK_FORMAT | G7 |
| PICK_SEARCH | G1·A1 | CELL_NOEDIT·CELL_DELETE·CELL_PASTE | D1 |
| CELL_TYPE·CELL_ICON·CELL_KEYIN·TEXT_INPUT | D5 | CELL_BADKEY | E7 |
| INSERT_POPUP·INSERT_DIRECT·INSERT_FILL | D4·M4 | TS_* | A5·B5·K2 |
| SAVE_REQ | F1 | SAVE_CLOSE | M4 |

### 2-3 `tools/Harness/verify/judge.py` — 반입
- 전: `e2e_results.json` 만 반입
- 후: `popup_results.json`·`popup_source.csv`·`popup_accounts.csv` 반입. `basis` 를 근거 등급으로 사용. `basis` 빈 FAIL 은 스펙이 이미 ERROR 로 강등(`[근거 불충분]`).
- `ORDER` FAIL: `sort_review` 정책(§2-1 SORT 기준 차이 = 판정필요)을 B3 팝업에도 적용할지 메인 결정 필요. 현재 스펙은 AS-IS ORDER BY 위반을 FAIL 로 낸다.

### 2-4 `tools/Harness/verify/mapping_checkdefs.csv`
- 후: 위 규칙 행에 팝업 범위를 추가(G8·G9 '팝업 포함' 문구와 코드 일치).

## 3. 메인 세션 실저장 필요(이 작업은 VERIFY_NO_SAVE=1 전용)
- EG178·EG434: 팝업 저장 DB 반영(Exchange Rate·BPS I/F·Version Create·Price Batch·Mail Setup·대량 저장·ROLLBACK). 이 작업은 저장 요청 본문까지만 재며, 저장 응답은 픽스처의 가짜다.
- EG197: 재오픈 재조회 중 저장 건수. EG304: 실제 RESULT_CODE/RESULT_MSG 문구.
- 방법: `CL_FAKE` 없이 `runSaveState` 실행 + `db_snapshot.py` 전후 대조 + 원복.

## 4. 부하 해소 뒤 이어서 할 실행(메인 세션 판단 후)
- 23:01 부터 이 에이전트의 E2E 는 멈춰 있다(§5). 재개 명령 = `python -I Doc/verify/_parallel/E02/sweep.py Doc/verify/_parallel/E02/_sweep.json DMF0005 DMF0082 DMF0042 DMF0044 DMF0021 DMF0035 DMF0049 DMF0003 DMF0045 DMF0043 SCP0007 SCP0006 DMF0068 DMF0053 DMF0006 DMF0074 DMF0020 SYS0014:INSERT`
- 변이 잔여 = `Doc/verify/_parallel/E02/batch2.sh` 의 N4~N7(`casesens,commaoff` · 단일 선택 · 셀) + `EG_GROUPS=LAYOUT` 로 `topline` + DMF0044 호출 1 `undisable,periodoff`.
- 계정 축: `E2E_ACCOUNT` = 문서 계정(k0101·eunah.koo·hongjae.kim·attackgo)으로 run.sh 6번째 인자 지정 → `facts_popup_accounts.py`.
- SYS0012·SYS0014·SYS0016·SYS0017·SYS0005·SYS0006·SYS0010·DMF0043_01 은 AS-IS Fact Pack 없음 → 호출 facts 0, INSERT 모드와 메타 팝업만 가능. COMMON 행은 대표 화면 연결 필요(W1 과제).

## 5. 실행 환경 사고
- 22:48~23:01 DMF0005 N4·N5 로그인 픽스처 360s 초과(`nscm.ts:110` 로그인 폼 조작 180s 시간 초과). 22:58:26 CPU LoadPercentage 100 · chrome 38개. BE health 응답 0.02s · HikariPool 타임아웃 0건 → 원인 확정 못 함(CPU 포화와 시각만 일치).
- `run.sh` 는 실행 중 고치면 안 된다(21:55 실행의 run.log 가 깨짐 — 결과 JSON 은 정상).
- `runlock acquire` 는 임시 부모 PID 를 적어 MSYS 에서 곧바로 '잠금 잔존' 으로 보인다. run.sh 가 자기 Windows PID 로 다시 쓰도록 우회했다. 공용 `runlock.js` 를 인자 PID 받도록 고치는 편이 낫다.
