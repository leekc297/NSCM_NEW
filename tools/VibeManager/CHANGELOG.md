## 1.7.7 + 하네스 보강 3 (2026-10-20 오후 · 확장 재빌드 불필요 — tools/Harness · tools/E2E · quick.json · rules 만)
- **질문**: "파싱에 있었는데 왜 대사표·GAP·E2E 어디서도 안 나왔나" — 파싱(Fact Pack)은 정상(endpoints/flow 3SPAN · grid_code DB_DRIVEN 196/203). 하류가 전부 정적 grid_effective(6컬럼)를 정답으로 썼다: 대사표 생성기 §5 '6컬럼' 자동 구현·DB루프 행 미생성, 수작업이 3SPAN 행을 근거 없는 '구현'으로 닫음, E2E 기대 헤더 = sheet_columns 6 → '헤더 6/기대 6' PASS.
- **결함 정정**: `lib/dyncol.asisDbLoop` 가 `/DB루프/` 로 걸러 항상 0건(실제 source 값 `DB_DRIVEN`) → `DB_DRIVEN` + kind COLUMN/Add*Column.
- **대사표**: 생성기 `## §6 동적 컬럼` (타이틀 SP 시트 행 + DB루프 컬럼 생성 행, 초기 미구현). 게이트 `M08`(DB루프 행 누락, WARN — 전수 31화면 73행) · `M09`(엔드포인트 '구현' 인데 사내 정확 배선 시트 FE 미조회 = 구현 근거 불일치, final BLOCK — 전수 1건 SCP0096).
- **E2E**: `lib/nscm.gridBindings`(Wijmo `$WJ-CTRL` columns — 가상화 무관) · gen-e2e plan `dynamicHeader`(As-is 타이틀·DB루프·사내 타이틀 시트·정적 메타 binding) · smoke 에 정적 메타 밖 binding ≥1 + 타이틀 시트 호출 soft 판정·어노테이션 `dynamic`. `--all` 재생성(플랜 보유 2화면 중 SCP0096 대상), tsc strict 통과.
- **🧯 프롬프트**: M08/M09·E2E dynamic 진단, §6 행 추가·근거 불일치 행 정정·FE 수정 후 gen-e2e 재생성 지시.
- **SCP0096 `--final`**: BLOCK 3(B26·B27·M09) / WARN 2(M08·T02).

## 1.7.7 + 하네스 보강 2 (2026-10-20 · 확장 재빌드 불필요 — tools/Harness · quick.json · rules 만)
- **사고**: SCP0096 조회 시 동적 기간 컬럼(D_yyyymmdd)이 0개. FE 가 BE 에 없는 응답 키 `o_rc1_columns`(SYS0013 DynamicQuery 전용 사이드카)에서 컬럼을 파생하고, As-is `GetSpdTitle → SCP0009_GET_SHEET_CALENDAR_3SPAN` 에 해당하는 사내 배선 `calendar/SEARCH` 는 호출하지 않았다. 그런데 check.js BLOCK 0 · DoD 28/28 · GAP COVERED 로 통과. 원인 = ①gen.js 타이틀 판정이 `_SPREAD_TITLE` 정규식 1개(3SPAN 누락) ②gap.js 가 '사내 등록'만으로 COVERED ③응답 키 존재를 보는 게이트 없음 ④보완 세션이 자매 화면(SCP0019) 주석을 근거로 복제.
- **공용 판정 `lib/dyncol.js`**: 타이틀 SP 다중 신호(SP 이름 계열 — 전수 9,283 엔드포인트 접미 분포 기반 · GetSpdTitle 계열 메서드 · grid_code DB루프) · 기간형/메타형 분류(SHEET_COLUMNS 만 읽는 공통 타이틀은 메타형=admin 컬럼 메타 대체) · 사내 배선 시트 대응(정확 → 계열) · FE 시트 조회 판정(상수 객체명 무관) · 응답 키 허용 집합.
- **게이트(check.js)**: `DoD B26` RESPONSE_SET 값 ⊂ PROC_M OUT COL_NM ∪ DATARESULT(대소문자 그대로, 타 메뉴 OUT 은 WARN) · `DoD B27` 기간형 타이틀 SP 의 사내 정확 배선 시트를 FE 가 조회(배선 없음/계열 추정은 WARN, 대사표 제외+사유면 통과).
- **GAP(gap.js)**: 기간형 타이틀 SP 는 FE 가 배선 시트를 조회해야 COVERED(정확 배선 없으면 같은 화면 타이틀 계열 시트 조회도 인정) — 등록만이면 MISSING. 전 화면 재산출 결과 기간형 MISSING 13건/11화면(SCP0096·SCP0011·DMF0020 = 배선 있음·FE 미조회).
- **생성기(gen.js/templates.js)**: 타이틀 시트를 사내 배선 시트명으로 SHEETS 에 생성(TODO 주석) · register.json 시트 배정 · GEN_NOTES 9번 항목.
- **자동 보완 프롬프트(quick.json 🧯)**: 진단에 Grid 동적 컬럼 원천(B26·B27) 추가 · 주석/대사표 서술은 근거 아님 · 보완 방법(타이틀 시트 조회·o_rc1 헤더·fixture/대사표 정정) · 메뉴 선택 = 해당 화면 FE 페이지 수정 승인 명시.
- **부수 검출(미수정)**: B26 전수 스캔에서 `o_rc1_columns` 3화면(SCP0096·SCP0019·SSP0005 죽은 상수) + DMF0043 contribute-view `TITLE_SET='o_cursor'`(사내 OUT 은 o_rc1).

## 1.7.7 + 하네스 보강 (2026-10-19 저녁 · 확장 재빌드 불필요 — tools/Harness · quick.json · rules 만)
- **사고**: SCP0096 파이프라인 1단계가 손으로 완성해 커밋해 둔 페이지를 골격으로 교체(1,361줄 삭제 · 대사표 91→20행 · dynamic-columns/types 삭제 · 저장 핸들러 빈 스텁 · 초기기간 공란 · filter 키가 사내 PROC_M COL_NM 과 불일치)했는데 정적 게이트는 PASS. 원인 = `lib/applied.isTouched` 가 "매니페스트 없음 = 구버전 골격 = 재적용 허용" 으로 판정
- **보호**: `lib/applied.touchReason` — git 추적 파일 있음(커밋본)·매니페스트 없음·적용 후 변경·REPAIR.md 중 하나면 보존. `gen.js --apply --overwrite` 는 사유를 출력하고 거부, 사람이 `--force` 를 줄 때만 `Doc/gen/<ID>/_backup/<ts>/` 백업 후 교체. `pipeline.js` 는 절대 --force 하지 않고 보존 사유를 단계명에 표시
- **게이트(check.js)**: `M07` 커밋본 파일 삭제 · `M06` 커밋본 대비 대사표 행/구현 수 축소 · `DoD B22` 조회 filter 키 = 사내 PROC_M COL_NM(`Doc/tobefacts/db/proc_params.csv`) · `B23` registration.sql API 배선 = 사내 현행(`proc_meta.csv`, 프로시저명 공란 BLOCK) · `B24` As-is Form_Load 초기 조회기간(InitValue/DateUtil.GetDayRange — flow.csv 미수록) ↔ store 초기값 공란 · `B25` hotkeyConfig save/insert/delete/upload 핸들러 본문 공란(TODO 스텁). `harness.json` 에 `asisSrcRoot` 추가(.cs 원문 대조)
- **메뉴**: 분석·문서 그룹에 `🛠️ 기존 화면 보완 (Claude · 골격 재생성 금지)` 추가 — 기존 화면은 이 항목 또는 💬 프롬프트로만 보완, ✨ 새 화면/★ 파이프라인/🔄 수선 루프는 신규 화면 전용
- **룰셋**: `10_RULES_KEEP.md` B11(커밋본 덮어쓰기 금지)·C6(filter 키↔COL_NM·등록 SQL↔사내 배선)·E9(신설: Form_Load 초기값 보존)·F1(빈 핸들러)·J ③⑤⑥ 갱신, `prompts/new_screen.md` 입력 2-1/2-2·하지 말 것 추가
## 1.9.9 (2026-10-21)
- **⬆️ Source Backup 자동화**(사용자 지시): 커밋 메시지 입력창·확인창 없이 `git add -A → commit -m "BACKUP_YYYYMMDD_HH24MISS"(로컬 시각) → push origin main`(leekc297 자격증명) 을 바로 실행. quick.json `autoMessage: "BACKUP_${ts}"` 로 지정(다른 git-upload 항목은 종전대로 입력). 모의 테스트 4/4.
## 1.9.8 + 하네스 보강 (2026-10-21 · tools/Harness 만, 확장 재빌드 불필요)
- **"TSC 메모리 오류" 원인 확정**: 메모리 부족이 아니라 타입 폭발. `supply/group-code-management/utils/group-code-management.save.ts` 가 `t` 를 i18next `TFunction` 으로 받아, `useTranslation()` 의 t(react-i18next 제네릭)와의 대입 검사가 typed resources(ko.json 1,614 키) 오버로드 교차곱(`getCrossProductIntersections`)으로 번져 feature 전체 tsc 가 4/8/12GB 모두에서 죽음(`RangeError: Map maximum size exceeded`). 페이지 사본에서 그 매개변수를 좁은 콜백 타입으로 바꾸면 647MB·127s 정상 — SCP0100·SCP0096 은 무관(단독 655MB·52s).
- **check.js**: ① tsc 게이트 = 페이지 범위 임시 tsconfig + `--max-old-space-size`(harness.json `tscHeapMb`, 기본 4096) + 비정상 종료 **BLOCK T00**(종전엔 exit 134 를 WARN T02 로 흘려 BLOCK 0 통과 — SCP0100 CHECK.md) · `--tsc-feature` 로 종전 전체 검사 ② **T03** 정적 검출: 페이지 파일의 `TFunction` 타입 사용 = BLOCK(원인 설명·대안 포함). 10_RULES_KEEP #5 에 "tsc 직접 실행 금지 · check.js --tsc 만 · TFunction 금지" 추가.
## 1.9.8 (2026-10-21)
- **동적 탭이 '버튼만 생기고 내용은 안 보이는' 사고 수정**(사용자 신고: 전환 흐름 대시보드·FLOW 진척·소스 전후 diff 등 전부): 원인 = FLOW 탭은 기존 `#flow` 요소를 탭 pane 안으로 옮겨 쓰는데, ① 탭을 보여주는 `showDynTab` 이 고정 컨테이너 목록을 돌며 `#flow` 를 무조건 숨겨 **FLOW 탭 내용이 비고** ② FLOW 탭을 닫으면 pane 과 함께 `#flow` 가 DOM 에서 사라져 이후 `showDynTab` 이 `$('flow').style` 에서 예외 → **모든 동적 탭의 pane 이 표시되지 않음**(버튼만 생성). 수정: 요소가 없으면 건너뛰고 탭 안의 `#flow` 는 숨기지 않으며, FLOW 탭을 닫을 때 `#flow` 를 `#top` 으로 되돌린다. jsdom 재현 테스트(diff·html·flow·md 탭 + FLOW 닫은 뒤 새 탭 + FLOW 재열기) 12/12.
- **용어 '대사표' → '대조표'**(사용자 지시): 메뉴·탭·체인 단계명·힌트·룰(10_RULES_KEEP)·하네스 메시지(check/gap/pipeline/templates)·md2xlsx 시트명. 파일 경로(`Doc/recon/대사표*.csv/.md`, Recon 도구 내부)는 유지 — 파일명 변경은 별도 확인 뒤.
- **UI 별 대조표 Excel**(사용자 요청 "Overview 대조표는 HTML 전체 현황 — 자신의 UI 대조표는 Excel 로 UI 별 문서에"): `tools/Docs/make_docs.py` 가 `Doc/화면분석서/{ID}_{Name}_대조표_v{N}.0.xlsx` 를 추가 생성 — 1.화면 대조(Doc/recon 화면 행 key/value) · 2.시트 대조 · 3.SP 대조 · 4.AS-IS↔TO-BE 매핑(페이지 `__asis-mapping__.md` 전체 표, 상태별 색). UI Status 📗 문서 칩에 자동 표시(ID 접두 xlsx). S3.xlsx(체인 마지막 단계)에서 함께 만들어진다.
## 1.9.7 (2026-10-21)
- **새 화면 체인에 자동 보완·수선 내장**(사용자 지시: "ID 하나로 전체로 만든 화면이 🧯 자동보완의 40+ 단계 보정을 거치지 않아 제대로 생성되지 않았다 — 생성·GAP·TEST 오류 보완까지 누락 없이"): 🚀 ID 하나로 전체 / 🧩 새 화면(AS-IS) / 📏 새 화면(설계서) 체인에 **🧯 자동 보완 단계**(pipeline 7단계·GAP 뒤, 기존 🧯 프롬프트 그대로 — 게이트·GAP·대사표·As-is 원문 기준으로 찾아서 끝까지)를 넣었다(16/14/14 단계).
- **단계 수선(repair)**: quick.json 체인 step 에 `repair: { claudeOf, rounds }` — 단계가 실패(종료코드≠0 또는 verify 실패)하면 지정 Claude 프롬프트로 수선한 뒤 **같은 단계를 재실행**(rounds 회, 기본 1). E2E 4단계 전부(4체인) `🩹 E2E 오류 보완 (Claude)` ×2회. Flow 보드 REPAIR(🩹 수선 중 r/n) 상태 · FULLRUN.md 단계명에 '(수선 n회)' · 완료 요약에 수선 횟수. 수선을 다 써도 실패면 종전처럼 FAIL 중단.
- **🩹 E2E 오류 보완 (Claude)** 신설(보완 서브그룹 · 수동 실행도 가능): `${kind}`(smoke/crud/auth/authcrud)·`${round}` 치환. _summary.csv 행·로그 Error 블록·스크린샷·스펙/plan 을 읽고 실패마다 (a)화면 결함 / (b)DB 객체·메타 결함 / (c)E2E 기대값 결함 의심 으로 판정 → (a)(b)만 수정(DB 객체·메타 우선, FE 는 지정 지점 최소 수정·라벨 LBL 코드 필수) → check.js --final → `Doc/gen/<ID>/E2E_REPAIR.md` 회차별 기록. **tools/E2E 와 Doc/e2e/specs 는 수정 금지**(테스트 약화로 통과시키기 금지 — (c)는 보고만). E2E 는 직접 돌리지 않고 체인이 재실행.
## 1.9.6 (2026-10-21)
- **E2E 미실행 사고(🎬 E2E 전체 4단계 가 1~3초 만에 '완료')**: 원인 = 다른 run-e2e(수동 실행)가 공용 `Doc\e2e\_run.log` 를 쥐고 있어 배치의 모든 `>> _run.log` 리다이렉트가 "다른 프로세스가 사용 중" 으로 실패 → probe·권한 메타·스펙 생성·Playwright 가 하나도 돌지 않았는데 마지막 명령(report)의 0 이 반환. 보완(`tools/E2E`): ① `runlock.js` 동시 실행 잠금(`_run.lock`, 살아 있는 PID 면 `[FAIL] 다른 E2E 실행이 진행 중` exit 4) ② 실행마다 별도 로그 `Doc\e2e\logs\run_<RUNID>_<종류>.log`(`_run.log` 는 색인만) ③ `report.js` 가 results.json 이 잠금 시각 이후 갱신됐는지 확인(아니면 exit 3) ④ FE/BE 미응답이면 `[FAIL]` exit 5 로 즉시 중단(예전엔 [WARN] 뒤 전부 실패). **배치는 ASCII 전용** — chcp 65001 + 한글이 있으면 cmd 가 goto/블록 뒤 파일 위치를 잘못 잡아 깨짐(실측).
- **SCP0100 E2E 4단계 결과 보정(tools/E2E 만 · 확장 재빌드 불필요)**: 1.9.6 로 실제 실행된 첫 결과 2 FAIL 의 원인이 전부 E2E 기대값 결함 — ① auth: SubTitle Excel 다운로드가 아이콘 전용(이름은 MUI Tooltip 상위 div aria-label) → `visibleButtons` 가 텍스트→aria-label/title→상위 aria-label/title 순으로 이름 수집 ② smoke 라벨: 공용 SearchArea 의 접힌 조건을 `expandSearchArea()` 로 펼친 뒤 To-Be LBL 문구(msg_master EN)→As-is 라벨('*' 제거)→'/' 분할 후보로 찾고, `__asis-mapping__.md` §1 컨트롤 행 '제외'(dead control·NO-OP) 는 검사 제외 ③ smoke 컬럼: 기대 시트 = 실제 조회된 시트(call-proc sheet → register.json adminSheetName, 타이틀 시트 제외). 재실행 11/12 PASS — 남은 1 = 화면 발견(A/S 체크박스 라벨이 FE 리터럴 'AS 포함', As-is 'A/S'·LBL00685 'AS' 와 불일치 → 가이드만). SCP0096 smoke 회귀 PASS.
- **E2E 선행 자동 기동**(사용자 지시): `run-e2e.cmd` 를 쓰는 작업(S7.smoke/crud/auth/authcrud/all · steps.json `requireServers:[8080,5173]`)은 메뉴·스테퍼·체인 어느 경로든 실행 전에 BE 8080/FE 5173 LISTEN 을 확인하고, 미기동이면 quick.json 의 ☕ BE Start / 🎨 FE Start 로 동시 기동 → 완료 로그(ready)·포트 LISTEN 까지 대기 후 진행. 기동 실패/시간초과면 E2E 를 돌리지 않고 exit 5(Flow 보드 FAIL). `startServerStream` 은 `Promise<{ok,sec}>` 반환.
## 1.9.5 (2026-10-21)
- **체인 E2E 무실행 → "완료" 오판 보완**(SCP0100 사고): ① VS Code 루트 `c:\…`(소문자) 와 설정 `C:\…` 가 섞여 Playwright 가 `Requiring @playwright/test second time` 로 시작도 못 함 → 확장 루트 드라이브 문자 대문자 통일(normDrive) + `playwright.config.ts` testDir 을 설정 파일 기준 같은 표기로 ② `run-e2e.cmd` 가 Playwright 종료코드를 전파(실패 시 로그 꼬리 출력) ③ 체인 단계 `verify`: E2E 4단계는 `_summary.csv` 가 이번 실행에서 갱신되고 (화면,종류) 행이 있어야 OK, 파싱은 Fact Pack summary 존재, Excel 은 폴더 존재 — 종료코드 0 이어도 산출물 없으면 FAIL

## 1.9.4 (2026-10-20)
- **체인 단계 세분화**(사용자 지시 "너무 큰 작업이 하나로 묶여 있다"): 새 화면 pipeline 1단계 → **7단계**(FE 골격 → 등록 SQL → PKG 골격 → FE 수선(선택) → PKG 이식(선택) → E2E 스펙 → 대사표(선택)), E2E 전체 1단계 → **4단계**(smoke → crud → auth → authcrud, 각 auto 모드). 🚀 전체 15단계 · 🧩/📏 13단계 · 🚒 7단계. 체인 단계에 `args` 지정 지원(같은 작업을 인자만 바꿔 호출)
- `tools/Harness/pipeline.js --phase N` 신설: 단계만 실행, 결과는 `Doc/gen/<ID>/_pipeline_steps.json` 에 누적되고 PIPELINE.md 는 누적본으로 재작성(기존 전체 실행 동작은 그대로)
- `tools/E2E/report.js`: 종류별 실행 결과를 **병합**해 `_summary.csv/md` 에 쌓는다(이번 실행의 (화면,종류)만 교체) — 체인이 4종을 따로 돌려도 UI Status 타일 4개가 전부 남음

## 1.9.3 (2026-10-20)
- **명령형 항목도 Workbench 탭으로**(1.9.0 에서 빠진 것): 🛰️ 전환 흐름 대시보드 → HTML 탭(단계×게이트 판정, 작업 실행·🔄 갱신 버튼 동작 유지) · 📶 FLOW 진척 → FLOW 탭(중복이던 🗓️ FLOW 진척판 항목 제거) · 🕒 작업 이력 → Workbench History 탭 · 🧪 환경 점검 / 📊 Agent 게이트 집계 / 📒 runs.log / ✎ steps.json → 파일 탭. 별도 웹뷰 창은 Workbench 가 없을 때만. 웹뷰 메시지 `tab:refresh` / `tab:action` / `tab:closed`, 확장 API `openHtmlTab · refreshHtmlTab · showTab`

## 1.9.2 (2026-10-20)
- **체인 즉시 시작**: 🚀/🧩/📏/🚒 체인은 화면 ID 확정(QuickPick) 뒤 두 번째 모달 확인창 없이 바로 시작(비차단 알림 + Task Log 안내). 모달이 바깥 클릭/Esc 로 조용히 취소돼 "신규 ID 를 넣었는데 진행이 안 된다" 로 보이던 문제(사용자 지시). 중지는 ⏹ 중지

## 1.9.1 (2026-10-20)
- **E2E CRUD = 실제 저장**(사용자 지시): Insert 없는 셀 편집 저장형도 값 변경 → Save → 재조회 반영 확인 → 원래 값 복원 Save → 재조회 복원 확인(`mode=edit-save`, `restored` 필수). Insert/Delete 화면은 마커 행 실제 생성·수정·삭제(기존). 이전 '편집기 열림만 확인' 폐기. 편집 후보 = `.wj-cell-editable` 셀(값 있는 셀 우선) · 재조회 직후 렌더 폴링 · SAVE 요청/응답(결과 커서 ERR_CODE) 기록 · 오류 알림 반복 닫기. **실측으로 SCP0096 저장 결함(ORA-01407, FE userIdList vs PROC_M userId) 발견 → DB 객체 보완(PROC_M + PKG_SCP0096/SCP0019, 사내 적용·클라우드 패키지)** 뒤 crud PASS 51s
- **E2E 테스트 모드(화면 성격별 계정 축)**: E2E 작업(스모크·CRUD·권한·권한별 CRUD·전체) 실행 시 선택 입력 `mode` — `admin`(영역 ADMIN 1명 + 권한 없는 사용자 1명, Division 반복 없음 = 마스터 화면 → 스모크·CRUD 각 1 + 권한·권한별 CRUD 각 2 = 6건) / `division`(화면 영역의 역할 계정만 Division 별로 + 영역 ADMIN 1 + 권한 없는 사용자 1 — 명부는 계정 풀, 전수 아님) / `auto`(users.json 화면 지정 → 없으면 Division 조회조건 유무로 추정). `run-e2e.cmd … --mode`, `gen-e2e.js --mode`. 명시한 모드는 `tools/E2E/users.json screens[<메뉴>].mode` 에 저장돼 다음 기본값(SCP0096 = admin 등록). 체인 안에서는 auto. `_index.csv` 에 mode 열. 입력 정의 `inputs[].options` → QuickPick 지원(collectInputs)
- 검증: SCP0096 `--mode admin`(jaeuk.shin + hongjae.kim) **6/6 PASS**(smoke 26s · crud 49s 편집기 열림 · auth 2 · authcrud 2, 권한 없는 계정은 URL 접근 가능하나 Save 비노출·편집 불가·SAVE 호출 0 = `gap` 기록). 모드 도입 전 18계정 3차 실행은 17/17 통과 시점에 중단(보정 2종 확인)

## 1.9.0 (2026-10-20)
- **Workbench 내부 탭(열기 류 전부)**: 새 창·외부 프로그램을 만드는 기능(Workbench 새 창 · Open Browser(NSCM) · E2E HTML 리포트 · Excel 등 바이너리 · 원격)을 제외한 모든 "열기" 가 Workbench 의 **닫을 수 있는 탭**으로 열린다 — 메뉴 `open` 항목(DoD·PIPELINE·FULLRUN·룰셋·설정 json…), steps `open`(결과 md·GAP csv·매트릭스·등록 SQL·폴더…), 사이드바 항목(룰·hook·DoD 패널·게이트 BLOCK 파일:라인 → 해당 줄 강조), UI Status 문서 칩, FLOW 의 폴더 열기, History 의 수정전↔수정후 / 작업후↔현재 비교, 5단계 전/후 diff(HEAD↔작업본). 뷰어: md 렌더링(제목·표·목록·코드·체크·경로 링크 → 다른 탭) · csv 표(필터·PASS/FAIL 색) · json/sql/ts/log 코드 보기(줄번호) · 폴더 목록(상위 폴더·클릭 이동) · 이미지 · 줄 단위 diff(변경 주변 3줄, 전체 보기 토글). 툴바: 🔄 새로고침 · ✏️ 편집/👁 보기 · 💾 저장(텍스트 파일, quick.json 저장 시 메뉴 즉시 갱신) · 📝 에디터로 · ↗ OS 로 열기. 새 모듈 `tabview.js`, 웹뷰 메시지 `tab` / `tab:open|save|editor|os|ext`
- **tools/E2E 보정 2차(SCP0096 2차 실측 38건 → 16 FAIL)**: ① 조회 버튼이 없는 계정(메뉴/SEARCH 권한 없음)에서 `search()` 가 F5 무동작 후 120s 를 기다려 auth 240s 초과 → 버튼 없으면 10s 만 ② 편집 가능 판정이 고정 (0,1) 셀(키 컬럼)이라 허용 계정 7건이 '안 열림' 오탐 → Wijmo 컬럼 정의(`gridColumnsMeta`: isReadOnly)에서 편집 가능 컬럼을 골라 차례로 더블클릭(`cellEditable(0)`), 편집 가능 컬럼이 없으면 false. 단일 crud 재실행 PASS(편집기 열림)
- **FLOW 고정 탭 제외**: 탭바는 Claude · Log · Task Log · UI Status · History. FLOW 는 `Overview & Reports › 🗓️ FLOW 진척판`(kind `flowtab`)으로 여는 탭(내용·필터·클릭 동작 동일)

## 1.8.9 (2026-10-20)
- **Flow 보드**(Claude 탭): 체인(🚀/🧩/📏/🚒)과 메뉴·스테퍼에서 실행한 **단일 작업**도 텍스트 로그가 아니라 보드로 — 헤더(🧭 Flow 이름 · 화면 · **현재 Step / 전체 Step** · 진행바 · 완료 수 · 경과 · 상태) + Step 카드(대기 ○ / 진행 ⏳ / 완료 ✅ / 경고 ⚠ / 실패 ✖ / 미실행, 소요·exit, 접힌 상태에서 마지막 출력 한 줄, 펼치면 최근 60줄). Claude 단계(✴️)의 상황판은 그 Step 카드 안에 중첩. 작업 출력 원문은 Task Log 에 그대로. 웹뷰 메시지 `fb`(start/step/end). 보드 안 글자색은 로그용 색상 클래스(.bad/.ok)의 상속을 끊어 상태 배지·테두리만 색을 가진다
- 검증: jsdom 16항목 PASS(체인 4단계·Claude 중첩·선택 단계 경고·중단·단일 작업) · Chrome 스냅샷
- **tools/E2E 보정(SCP0096 4단계 실측 26건 → 23 FAIL 원인 4종)**: ① 숨은 `.wj-flexgrid`(Home keep-alive)가 첫 그리드로 잡혀 `dblclick` 이 테스트 타임아웃까지 대기 → 보이는 그리드만(`:visible`) + `cellEditable` 시간 상한(5s, force 재시도, 실패 시 판정 불가) ② auth 가 Division 3개 계정에서 180s 초과 → Division 수 × 조회 타임아웃으로 `test.setTimeout`, authcrud 420s ③ btn_auth 의 `EDIT`(셀 편집 권한)·`SEARCH` 를 버튼으로 오판 → 버튼 코드 사전(SAVE/INSERT/DELETE/EXCEL…)만 양방향 대조, EDIT 는 편집기 열림과 대조 ④ 기대 권한 계산을 BE `PR_GET_MNU_BTN_AUTH` 원문과 동일하게(메뉴 권한 있는 그룹들의 버튼 합집합) + `run-e2e.cmd` 가 실행 전 권한 3표(btn_auth·user_group_user·user_group_menu)를 사내 DB 에서 새로고침(10-19 스냅샷의 SCM Viewer SAVE 가 제거돼 ys_cho 기대가 어긋났던 사례). 메뉴 권한 없는 계정의 URL 직접 접근은 실패가 아니라 어노테이션 `gap` 으로 기록

## 1.8.8 (2026-10-20)
- **E2E 테스트 단계 4종**: smoke · crud · auth · **authcrud(계정별 권한 CRUD, 신설)**. FLOW/UI Status 단계 9~12 = `9 Smoke / 10 CRUD / 11 Auth / 12 Auth×CRUD`(판정 = `Doc/e2e/results/_summary.csv` 의 kind 열, 결과 없고 스펙만 있으면 '미실행'), UI Status 타일 4종, 스테퍼 클릭 = S7.smoke/crud/auth/authcrud, DoD 패널 E2E 결과 종류별 합계
- **tools/E2E** — `lib/crud.ts` 공용 CRUD 사이클(Insert 화면만 마커 행 C→R→U→D 후 반드시 정리 · Insert 없는 셀 편집 저장형은 **기존 행 보호**: 편집기 열림만 확인하고 저장 안 함 — 사내 E2E 원칙) · `lib/nscm.cellEditable` · `gen-e2e.js` 계정별 기대 권한을 To-Be 메타에서 산출(`user_group_user` 그룹 소속 → `user_group_menu` 메뉴 접근 → `btn_auth` SAVE/INSERT/DELETE, 메뉴에 등록된 코드만 비교) + `<ID>.authcrud.spec.ts` 생성 · `report.js` 4종 집계(요약표 "권한별 CRUD(계정)" 열) · `run-e2e.cmd [smoke|crud|auth|authcrud|all] ID…` — auth 는 `@auth(?!crud)`, **화면ID 가 있으면 그 화면 스펙 파일만 실행**(이전엔 specs 폴더 전체) · README 갱신
- **메뉴 서브그룹**: `UI 분석·생성·보완` 아래 🔭 분석(3) / 🧱 생성(10: 단계 작업·새 화면 AS-IS·설계서·드라이런·PKG 배포·등록 미리보기/커밋/되돌리기·매핑표·PIPELINE) / 🪛 보완(6: 기존 화면 보완·자동 보완·GAP 보완·게이트 BLOCK·PKG 이식 마무리·DoD) / 🎯 테스트(6) / 📚 문서(4) — quick.json 항목 `sub/sub_en/sub_icon`, 사이드바가 서브그룹 노드(펼침·건수)로 묶음. 테스트 서브그룹 = 🔥 Smoke · 🧫 CRUD · 🔐 권한 · 🧬 권한별 CRUD · 🎬 전체 4단계 · 🔎 실패 분석
- steps.json S7: `S7.authcrud` 신설, 그룹 제목 "7. 테스트 (E2E: Smoke · CRUD · 권한 · 권한별 CRUD)"
- **순차 체인(quick kind `chain`)** — 단계를 차례로 실행, 실패(또는 입력 취소)하면 거기서 멈추고 `optional` 단계는 경고로 계속. 진행·결과 = Task Log + `Doc/gen/<ID>/FULLRUN.md`(단계표·exit·소요·다음 할 일, 단계마다 갱신). 단계 내부 확인창은 체인 시작 확인 1회로 갈음. Claude 단계는 `askClaude` 가 Promise 를 반환하도록 바꿔 종료(코드·is_error)를 기다린다. 항목 4개: 🚀 **ID 하나로 전체**(파싱 → 문서 MD → GAP → 새 화면 pipeline → E2E 4단계 → 문서 Excel) · 🧩 **새 화면(AS-IS) → 테스트·문서까지** · 📏 **새 화면(설계서) → 테스트·문서까지**(둘 다 파싱·AS-IS 분석 제외: pipeline → GAP(선택) → E2E 4단계 → Excel) · 🚒 **자동 보완 → 테스트·문서까지**(🧯 자동 보완 Claude → GAP → E2E 4단계 → Excel). "프로그램 ID 로 단계 작업" 퀵픽에도 ★ 전체 체인 추가. 기존 ✨/📐/🧯 단일 항목은 그대로

## 1.8.7 (2026-10-20)
- **UI Status 문서(Excel) 칩 열기 오류 수정**: "An error occurred opening an external program — 지정된 파일을 찾을 수 없습니다 (0x2)". 원인 = vscode.env.openExternal(Uri.file) 이 Windows 에서 한글 경로(Doc화면설계서·화면분석서·단위테스트)를 file: URI 로 넘기며 깨짐. Windows 는 `cmd /c start "" "<경로>"` 로 열도록 교체(openWithOS · 존재 확인 후, 없으면 경로를 Task Log 에 표시). History 의 폴더 열기도 같은 경로를 탐

## 1.8.6 (2026-10-20)
- **Source Backup push 인증**: quick.json 항목에 `credUser: leekc297` 추가, push 명령에만 `git -c credential.https://github.com.username=leekc297 push origin main` 로 1회 지정(전역 git 설정 변경 없음). 이 PC 전역 GitHub username 이 사내 계정(gyucheol_lee@zionex.com)이라 비대화(GIT_TERMINAL_PROMPT=0) push 가 인증 실패하던 문제. 확인 대화상자에 계정 표시. 대상 확인: Source Backup = 루트 `origin` = leekc297/NSCM_NEW.git · Source Download/Upload(UI) = nscm-fe `common` = eunjoo-hwang/nscm-fe.git (변경 없음)

## 1.8.5 (2026-10-20)
- **Agent Model 기본값 Opus 5.5**: 설정 `vibeManager.agentModel` 기본 `claude-sonnet-4-5` → `claude-opus-5-5`. 같은 기본값이 박혀 있던 `tools/AsisFacts/agent.ps1`(-Model 기본) · `AsisFacts/src/Agent.cs`(최종 폴백) 도 함께 변경. 이 값은 3단계 Agent 배치(agent.ps1 → dotnet AsisFacts agent → claude -p --model)에만 쓰이고 Workbench 대화·🧯 자동 보완 모델과는 무관(설명문에 명기)

## 1.8.4 (2026-10-20)
- **Claude 탭 = 상황판**: 프롬프트 1회가 보드 1개. 맨 위 헤더에 **현재 Step / 전체 Step** · 현재 Step 제목 · 진행바 · 지금 하는 일 한 줄 · KPI(도구 수 · 수정 수 · 경과 시간 · 상태 진행 중/완료/오류/중지). 그 아래 **Step 카드(기본 접힘)** — 번호 배지(완료 초록·진행 주황·대기 흐림) · 제목 · 종류별 도구 칩(📖읽기 ✏️수정 ▶실행 🔎검색 🤖에이전트 🌐웹) · 접힌 상태에서 마지막 작업 한 줄. 카드를 펼치면 그 Step 의 설명과 도구 행, 도구 행을 다시 펼치면 입력·결과(오류 결과는 빨간 표시). 끝나면 **최종 보고** 가 펼쳐진 채 보드 하단에, 완료·비용·수정 이력 줄은 보드 푸터로
- Step 판정: Claude 가 할 일 목록(TodoWrite)을 쓰면 그 목록이 Step 전체(총수·진행 상태 동기화, 목록 이전 작업은 `0 준비` 로 묶음). 없으면 설명 단락 단위로 자동 묶음(도구 사용 뒤 새 설명 = 새 Step, 프롬프트의 `[1 진단]…` 마커 수를 전체 Step 힌트로)
- 도구 호출 요약을 사람이 읽는 형태로(`읽기 VibeManager/quick.json` · `실행 컴파일` 등, 언어 설정 따라 en/ko). 보드·카드 라벨도 언어 설정 적용
- 검증: jsdom 재생 29항목 PASS(todo 모드·동적 모드·오류·중지·지우기) · Chrome 스크린샷 확인

## 1.8.3 (2026-10-20)
- **언어 설정** `vibeManager.language` (`en` 기본 / `ko`): 사이드바 메뉴 그룹·항목(quick.json `title_en`/`label_en` 61개), 단계·작업 제목(steps.json `title_en` 85개), 카테고리(NSCM Migration Steps · Definition of Done · Rules · Hooks · Harness · Settings), Workbench 탭·버튼·드롭다운·placeholder 가 설정 언어로 표시. 사이드바는 즉시, Workbench 는 새 창부터. 메뉴 실행 키(라벨 참조·multi)는 원문 라벨 유지
- **UI Status = 대시보드**: 헤더(화면 ID·화면명·메뉴 경로·페이지) · KPI 타일 6종(진행률 % · DoD · FE Gate B/W · PKG Gate B/W · GAP 미반영 · E2E) 색상 판정 · 단계 스테퍼(클릭 = 해당 작업 실행) · 산출물/문서 칩(팀 폴더 Doc/화면설계서·화면분석서·단위테스트의 해당 ID Excel 자동 수집) · 최근 작업 타임라인
- **문서 Excel 생성기 `tools/Docs/make_docs.py`**(`📗 문서 Excel` · S3.xlsx): 팀 양식(hook #105 · SB 스타일 · 맑은 고딕 10 · 가로 머지 규칙)으로 **화면설계서 8시트 · UI분석서 10시트 · GAP분석서 3시트(요약·전체·조치 필요) · 단위테스트 TestCases4(33열 · Division 시트)** 를 `Doc/화면설계서`·`Doc/화면분석서`·`Doc/단위테스트` 에 생성(기존 파일 덮어쓰지 않고 버전 +1). 도구 내부 용어·소스 라인번호 제거, 판정/구분/동작/컨트롤 유형을 읽는 말로 치환. 원천이 없는 시트는 "원천 없음" 명기
- **메뉴**: `전체`→`Overview & Reports` · `Source Upload(UI)` 를 `Source Merge` 아래로
- **버전 불일치 안내**: 새 VSIX 가 설치됐지만 이전 버전이 실행 중이면(Reload 전 — quick.json 은 실시간이라 메뉴만 먼저 바뀌어 "폴더 없음" 같은 오동작) 활성화 시 경고 + Reload 버튼
- 검증: 모의 — en/ko 메뉴·카테고리·Workbench 라벨 전환, 대시보드(SCP0096: KPI 7·단계 10·칩 9), `🛑 BE & FE Finish` 멀티 경로 실제 종료·포트 해제 확인(⚠ 테스트가 실제 서버를 종료시켜 즉시 재기동함)
## 1.8.2 (2026-10-20)
- **이력 시각 = 로컬 시간**(사용자 지적): 저장 `toISOString()`(UTC) → `nowLocal()`(`YYYY-MM-DDTHH:mm:ss+09:00`), 표시 `fmtLocal()` 로 구 UTC 기록도 로컬로 환산(검증: `…T14:18:04Z` → `23:18:04`). runs.log · .vibe/logs 파일명 · 붙여넣기 이미지명 · 리포트 파일명도 로컬 시간
- **탭 명칭**: `화면 현황`→`UI Status` · `이력`→`History`
- **Git 메뉴**: `Source Upload`→`⬆️ Source Backup` 으로 바꿔 **환경설정** 그룹 맨 아래로 이동 · **신규 `📤 Source Upload(UI)`** — 화면 ID 하나의 FE 소스(페이지 폴더 + 그 화면을 참조하는 변경 파일)만 공통소스 Git(`common` = eunjoo-hwang/nscm-fe, fetch URL 사용 · push URL no_push 유지)에 `feat/<id>-<날짜>` 브랜치로 업로드. 방식 = `common/main` 트리 + 선택 파일만 얹은 합성 커밋(임시 인덱스 · 로컬 브랜치/인덱스 불변) → push. 푸시 전 하네스 게이트(`check.js --final`) 실행, BLOCK 이면 확인 후 진행. nscm-fe pre-push(`pnpm type-check`: 이 PC pnpm 금지 → 항상 실패)와 무관한 합성 커밋이므로 `--no-verify`. **금지 영역 이중 차단**(사용자 지시): tools/·VibeManager·Harness·.vibe·.claude·_artifacts·Doc/·.husky·.env 는 후보에서 제외 + 푸시 직전 재검사. 다른 화면 폴더·ID 만 언급한 문서는 후보 제외(실측 오염 수정). 검증: 스크래치 베어 저장소에 SCP0096 11파일 → 커밋 1개·로컬 불변 확인
- **메뉴 재편**: `분석·문서`·`화면`·`Claude 에게` 3그룹 → **`UI 분석·생성·보완 (ID 필요)`** 하나로, 파싱→문서→Excel→GAP→골격/새 화면→보완→게이트/PKG→등록→E2E→DoD/PIPELINE/매핑표→설명→문서 폴더 순. ID 불필요 2건(Agent 게이트 집계·산출물 폴더)은 `전체` 로
## 1.8.1 (2026-10-20)
- **Server(Start/Finish)**: 그룹 `Server Start`→`Server(Start/Finish)` · `Start BE & FE`→`🔁 BE & FE Start` · `Start BE`→`☕ BE Start` · `Start FE`→`🎨 FE Start` · **신규** `🛑 BE & FE Finish` · `🟥 BE Finish` · `🟧 FE Finish`(quick kind `server-stop`: `name`·`port`·`expectProc`)
- **Finish 동작**(`WB.stopServer`): ① 포트 점유 프로세스(`netstat`→PID·`tasklist`→이름)가 `expectProc`(BE=java · FE=node)이면 `taskkill /T /F`(실패 시 PowerShell Stop-Process) ② 워크벤치가 띄운 같은 이름의 프로세스 트리도 종료 ③ 포트 해제까지 최대 20초 대기 → `✅ 종료 완료 (Ns)` 출력·알림·Log 헤더 `⏹ 종료됨`. 보호: VPN/시스템(F5FltSrv·svchost 등)은 ⛔ 중단, 예상 밖 프로세스는 ⚠ 보류(종료하지 않음), 실행 중 아니면 ℹ 안내. 명령 팔레트 `startBE/startFE` 라벨 매칭 갱신
- 검증: 모의(포트 5199 가짜 서버) — 기동 감지 → Finish 로 종료·포트 해제 확인 · 미실행 안내 · 예상 밖 프로세스 보류 · 멀티 Finish 참조 해석
## 1.8.0 (2026-10-20)
- **명칭**: 패널 제목 `Vibe_Manager 워크벤치` → `Vibe_Manager Workbench`(새 창 `#n`) · 명령 팔레트 `Vibe_Manager Workbench 열기` / `Workbench — 새 창` · quick `🧰 워크벤치`→`🧰 Workbench` · `🌐 Open Browser`→`🌐 Open Browser(NSCM)`
- **Log 탭**: `📜 작업 출력` → `📜 Log` = **BE Log | FE Log** 두 창(서버 기동 스트림을 포트 8080/5173·이름 BE/FE 로 분리, 각 창에 `⤓ 최신`(맨 아래로)·`🧹`, 헤더에 ✅ 기동 완료/✖ 실패 표시). 그 외 작업(gap.js·pipeline 등) 출력은 `🧾 Task Log` 탭(`⤓ 최신` 포함). 스크롤이 바닥 근처일 때만 자동 따라감(위로 올려 보는 중엔 고정) · 창당 4,000줄 보존
- **수정 이력 = 수정전 ↔ 수정후**(사용자 지적): 종료 시점 after 가 없던 이력을 열람할 때 현재 상태를 after 처럼 기록·비교하던 동작을 고침 — `afterMode` 기록(`end`=작업 종료 시점 / `view`=열람 시점 대체), 목록·상세·diff 제목에 `⚠ 작업후 미기록(열람시점 비교)` 명시, `end` 이력은 `view` 로 덮어쓰지 않음. **Claude 프롬프트(🛠️·🧯·💬 보완)도 화면ID 가 있으면 작업 전·후 스냅샷**(scope both)을 남기고 종료 시 `🕒 수정 이력 저장 — 변경 n개 파일` 안내 + 이력 탭 갱신
- 검증: 모의 — 탭 구성·BE 스트림 라우팅(showTab logs · server 메시지)·이력 afterMode(end/view 라벨) 통과
## 1.7.9 (2026-10-20)
- **BE 기동 실패 수정**: `gradlew.bat` 이 `'is not recognized'` 로 실패 — 이 PC 는 `NoDefaultCurrentDirectoryInExePath` 가 켜져 cmd 가 현재 폴더의 실행 파일을 찾지 않음(2026-08-11 메모와 동일 함정). 명령을 `.\gradlew.bat bootRun --args="--spring.profiles.active=local"` 로 경로 명시(실측: `.\` 붙이면 Gradle 8.8 인식, 없으면 실패)
- **서버 기동 완료 대기·확인**(Claude Code 와 같은 방식): quick.json 항목에 `ready`(완료 로그 정규식)·`port`·`readyTimeoutSec` 추가. 출력 스트림에서 `Started ScpApplication in N seconds` / vite `Local: http://127.0.0.1:5173` 을 감지하면 ✅ 기동 완료(소요 초) 를 작업 출력·Claude 탭·VS Code 알림에 표시. 완료 전 종료 → ✖ 기동 실패(마지막 출력 4줄) · `is not recognized`/`Port already in use` 즉시 실패 판정 · 시간 초과 시 포트 LISTEN 이면 완료 간주, 아니면 ⚠ 안내
- **포트 선점검**: 기동 전 `netstat` 으로 포트 점유자(프로세스명 PID)를 확인해 이미 떠 있으면 기동 생략 + 안내(종료는 사용자 판단 — VPN 프로세스 보호)
- **Server Start 그룹 영문화·순서**: `Server Start` ▸ `🔁 Start BE & FE`(첫 번째) · `☕ Start BE` · `🎨 Start FE` · `🌐 Open Browser`. 명령 팔레트 `startBE/startFE` 라벨 매칭 갱신. 검증: 모의 4케이스(완료 감지·명령 불가·포트 점유·조기 종료) 통과
## 1.7.8 (2026-10-20)
- **메뉴 라벨 정리(사용자 지시)**: 그룹 `서버`→`서버 기동`(`🔁 둘 다`→`BE&FE 기동` · `🌐 브라우저`→`브라우저 실행`) · 그룹 `소스`→`Git(Upload/Download)`(`Source Upload` / `Source Download` / `Source Merge` / `Source Update Status` — 저장소 정보는 hint 로 이동). 그룹 아이콘 판정에 `git` 추가(📦 유지)
- **메뉴 추가**: `🧯 기존 화면 자동 보완 (Claude · 찾아서 끝까지)` — 게이트·DoD·GAP·대사표·As-is 원문 대조로 부족분을 전부 목록화 후 순서대로 보완, 커밋본 후퇴만 묻고 멈춤. `🛠️ 하네스`→`🔩`(이모지 중복 해소)

## 1.7.7 (2026-10-19)
- **GAP 클릭 "✗ … (exit undefined)" 경고 · E2E 스모크 '실행 중' 고착 수정**: 원인 = FLOW 셀·프로그램 ID 단계 작업·DoD·대시보드 ▶ 등 확장 쪽 진입점이 **VS Code 작업 터미널**(ShellExecution)로 실행되는데, 이 워크스페이스 터미널 프로파일(`-NoExit` + `shellIntegration.enabled=false`)에서는 VS Code 가 프로세스 종료를 못 잡는다 → 종료 코드 undefined(✗ 경고) · 작업이 끝나도 '실행 중' · `runs.log` end 공란. 실제 GAP(gap.js) 은 정상 완료(23:19 산출물)였음
- **실행 경로 단일화**: 확장 `runShell` 이 워크벤치가 열려 있으면 `workbench.runShell` → `WB.execShell`(spawn 스트리밍, 작업 출력 탭 자동 전환, 실제 exit code · 이력 스냅샷 · FLOW/이력 갱신) 로 위임. 워크벤치가 없을 때만 VS Code 작업으로 fallback 하며, 그때 종료 코드가 비면 `?` 안내(프로파일 원인 + 워크벤치 사용 권고)
- 검증: FLOW→GAP(S4.one SCP0096) 스트리밍 exit 0 · `vibeManager.runTask` 직접 호출도 동일 · 워크벤치 없음 → VS Code 작업 fallback 확인
- (참고) E2E 스모크 자체는 BE `/sso/dev-login` 401 로 실패 — Vibe_Manager 문제 아님. BE `SsoDevController.devLogin` 에 `@AuthCheck(Type.NONE)` 이 없어 `CustomAuthorizationManager` 기본값 LOGIN 으로 거부됨(가이드 제공, BE 미수정)
## 1.7.6 (2026-10-19)
- **프롬프트 우측 버튼**: `📤 전송 (Ctrl+Enter)` · `⏹️ 중지` · `🧹 지우기` 를 프롬프트 입력창 오른쪽에 세로 배치(전송 버튼이 남는 높이 차지). 하단 줄에서는 세 버튼 제거 — 첨부·ID·모드·모델·원격·세션·새 세션·새 창·quick.json 유지

## 1.7.5 (2026-10-19)
- **새 화면 생성 중지(400) 수정**: 원인 = 하네스·워크벤치가 PATH 의 `claude`(`~/.local/bin` **2.1.123**, 4월 설치 후 자동 업데이트 정지)를 실행 → 모델 드롭다운에서 고른 신규 모델 요청이 `Claude Code 2.1.123 does not support this model; 2.1.251+ required`(400)로 거부. 실측: 2.1.123 + `claude-fable-5-1`→400(2.1.251+ 요구) · `claude-opus-5-5`→400(2.1.280+ 요구) · sonnet-5-5/기본→정상 / 2.1.301 은 전부 정상
- **Claude CLI 자동 선택**: `vibeManager.claudeCommand` 가 기본값(`claude`)이면 PATH + VS Code(·Insiders·Cursor·Windsurf) Claude Code 확장 내장 CLI 중 **최신 버전**을 사용(버전은 파일 mtime 기준 캐시). 최신이 2.1.280 미만이면 업데이트 안내 경고. 환경설정 트리에 선택 CLI·버전·후보 표시
- **하위 프로세스 전달**: `CLAUDE_BIN`·`ASISFACTS_CLAUDE`(AsisFacts agent, 기존 지원 변수) 를 확장 호스트 env 와 VS Code 작업(ShellExecution) env 에 주입, 워크벤치에서 실행한 작업은 창의 모델 선택을 `CLAUDE_MODEL` 로 전달
- **하네스**: `repair-loop.js` 가 `CLAUDE_BIN` 우선·`CLAUDE_MODEL` 있으면 `--model` 전달, 버전 부족 오류 시 안내 문구를 REPAIR.md 에 남김 · `new-screen.ps1 -Claude` 도 `CLAUDE_BIN` 우선
## 1.7.4 (2026-10-19)
- **워크벤치 좌측 메뉴 영역 제거**: 전체 메뉴는 사이드바(`vibeManager.menu`) 하나로 — 워크벤치는 Claude 대화·작업 출력·프롬프트를 전체 폭으로 사용. 사이드바 항목은 `vibeManager.runQuick` → 워크벤치에서 그대로 실행. 메뉴 전용 코드(아코디언·트리 스냅샷 `snapCat`/`execNode`·`cat:load` 등) 삭제
- **한 행에 아이콘 1개**: 라벨이 이모지로 시작하는 항목(quick 55 · 그룹 6 · 카테고리 4 · 액션 2)은 codicon 미표시, 게이트 상태 아이콘이 있는 단계 항목은 앞의 `★` 제거. 점검 374행 → 아이콘+이모지 겹침 62→0 · 이모지 2개 2→0 · 아이콘 없음 1→0(이관 룰셋에 아이콘 지정)
- **메뉴 간 이모지 중복 제거**(67개 → 중복 0): ⚙️ BE 기동→☕ · 🧩 AS-IS 파싱→🔬 · 📂 Excel 폴더→🗂️ · ✨ GAP 보완→🩹 · 🧪 드라이런→🏃 · 📦 PKG 배포→🚚 · ✔️ DoD→🏁 · 🪟 워크벤치→🧰 · 🧭 대시보드→🛰️ · 📊 FLOW→📶 · ✴️ 새 Claude 터미널→💻 · 📊 환경 요약→🧾 · ⚙️ VS Code 설정→🎛️ · 🕒 실행 기록→📒 · ↻ 게이트 다시 판정→🔄 · 현재 설정값→📋. `🔁 둘 다` 의 라벨 참조 동시 갱신
- **BE/FE 기동 명령 버그 수정**: `vibeManager.startBE/startFE` 가 이모지 없는 라벨(`'BE 기동'`)로 찾아 항상 실패하던 문제 → 라벨 끝 일치로 수정
## 1.7.3 (2026-10-19)
- **전체 메뉴 단일 정의**: `menuSections()` 하나로 워크벤치 아코디언과 사이드바 트리를 같이 그림. 구성 = quick.json 6그룹(서버·소스·분석·문서·화면·전체·Claude 에게) + **🌲 NSCM 전환 단계 · ✔️ 완료 정의(DoD)—현재 화면 · 🧩 룰·Hook·하네스 · ⚙️ 환경설정**
- **구 사이드바 4개 카테고리 → 워크벤치 메뉴로 포함(누락 0)**: 내용은 기존 트리 제공자(Steps/Dod/Harness/Env)를 그대로 위임해 스냅샷 → 사이드바와 항목 수 동일(검증: 단계 85·DoD 95·룰 31·환경 95 = 사이드바 경로와 일치). 하위 그룹은 아래로 펼침, Hook 은 `켜기/끄기` 버튼, 환경 파일은 `열기` 버튼. 사이드바 타이틀 액션 중 메뉴에 없던 `↻ 게이트 다시 판정`·`📍 화면 선택`도 해당 섹션에 추가
- **환경설정 합침**: quick.json `환경설정` 그룹 12항목 + 사이드바 환경설정(루트·env 파일 키값·Claude CLI) → 한 섹션(`현재 설정값` 하위)
- **사이드바 = 전체 메뉴**: 4개 뷰(`steps/dod/harness/env`) → `vibeManager.menu`("전체 메뉴") 1개. 타이틀 버튼 12종·인라인 액션(작업 실행·Hook 토글·열기) 유지. quick 항목은 `vibeManager.runQuick` 으로 워크벤치에서 실행
- **"빠른 실행" 문구 제거** → `☰ 전체 메뉴`. **상세 항목 1행 1개**(버튼 전체 폭, 줄바꿈 배치 없음)

## 1.7.2 (2026-10-19)
- **모델 목록 복원**: 하단에 모델 드롭다운 재도입 — `기본(Claude Code /model·settings)` · Opus 5.5 · Fable 5.1 · Sonnet 5.5 · Haiku 5.5 · opus/sonnet/haiku 별칭 · `✏️ 직접 입력…`. 목록은 새 설정 `vibeManager.modelList` 로 관리(코드 하드코딩 아님), 실제 응답 모델은 목록에 자동 추가. 선택값은 창(세션)별로 저장, 다음 전송부터 `--model` 로 전달(세션 유지). 옆의 "사용중" 라벨 = stream 에서 받은 실제 모델
- **메뉴 아래로 펼치기**: 좌측 가로 탭 리본 → **아코디언** — 그룹 헤더 클릭 시 바로 아래로 항목 펼침/접기, 여러 그룹 동시 펼침, `모두 펼치기/접기`, 펼침 상태 기억. 🌲 단계도 마지막 섹션으로 포함

## 1.7.1 (2026-10-19)
- **실행창 자동승인**: 기본 Claude 모드를 `bypassPermissions`(🔓 자동승인)로 변경 — 워크벤치(`-p` stream-json)에서 허용목록 밖 Bash 등이 확인 없이 거부되던 문제 해소. `.claude/settings.json` PreToolUse 차단 hook(block-dev-commands 등)은 그대로 동작
- **기본값 버그 수정**: `vibeManager.defaultPermissionMode` 를 workspaceState 에서 읽어 설정이 무시되던 문제 → `paths().permissionMode`(VS Code 설정)로 읽음. 예전 저장값(acceptEdits)은 1회 폐기(permVer=2)
- **터미널 실행도 동일 적용**: `Vibe: <작업>` 터미널(runClaude)·`Claude Code (Vibe)` 터미널(ensureClaude)에 `--permission-mode <설정값>` 전달

## 1.7.0 (2026-10-19)
- **원칙 재천명**: VibeManager 는 Claude Code 흉내 금지 — **Claude Code 공식 기능은 그대로 통과시키고**, 신규화면 개발용 하네스/골격/매핑/대사표만 얹는다. 사용자 지시(2026-10-19)
- **모델 하드코딩 제거**: 하단 모델 셀렉트의 고정 리스트(Opus 4.7·Sonnet 4.6·Haiku 4.5) 삭제 — 최신 모델(Opus 5.5·Fable 5.1 등)이 CLI 에만 추가돼도 **자동으로 노출**됨. 셀렉트 자리에는 **현재 세션 모델명 라벨**(🪪 modelbox)만 표시. 바꾸려면 Claude 창 `/model` 또는 VS Code 설정 `vibeManager.claudeModel`. `claudeArgs()` 는 전역 설정이 비어 있으면 `--model` 자체를 전달하지 않아 Claude Code CLI 디폴트가 그대로 유효
- **stream-json 모델 캡처**: `system`/`assistant` 이벤트의 `model` 필드를 받아 webview 로 `{type:'model',name}` 로 전달 → `#modelName` 즉시 갱신. 세션이 시작되는 순간 "진짜 쓰이는 모델"이 UI 에 뜸
- **상단 탭 Claude 우선**: `rtabs` 순서 재배치 — **✴️ Claude** 를 첫 번째로, 기본 선택 탭을 Claude 로 변경. 아이콘도 🤖 → ✴️ (Anthropic asterisk) 로 통일. 작업 출력(📜)은 두 번째
- **좌측 리본 통합**: `.ltabs`(빠른 실행 / 단계 트리 분리) 제거 → **하나의 리본**으로. 단계 트리는 리본 마지막 탭 "🌲 단계" 로 포함. 리본 기본 선택 = **🖥️ 서버** (quick.json 첫 번째 그룹). 사용자 지시 "펼치기 리본 메뉴" 적용
- **메뉴 재구성 (quick.json)**: 그룹 순서 = 서버 → 소스 → 분석·문서 → 화면 → 전체 → Claude 에게 → 환경설정. **누락 명령 보강** — 화면에 `⚡ 프로그램 ID 로 단계 작업`(quickScreen), 분석·문서에 `📊 Agent 게이트 집계`·`📂 산출물 폴더`, 전체에 `🧭 전환 흐름 대시보드`·`✴️ 새 Claude 터미널`, 환경설정에 `🧪 환경 점검`·`✎ 단계 정의(steps.json)`·`⚙️ VS Code 설정`·`🕒 실행 기록`
- **model UI override 삭제**: `getState`/`setState`/`st()` 에서 model 필드 전송 중단. `askClaude` 의 `overrides` 는 `permissionMode` 만 전달. 하위 호환: `workspaceState` 의 model 값은 그대로 두되 로직에서 미참조 (하네스 혼선 방지)

## 1.6.0 (2026-10-19)
- **사이드바 Prompt 뷰 제거 → 워크벤치가 첫 화면**: `vibeManager.prompt` WebviewView 등록 삭제. 활성화 시 `vibeManager.openWorkbench` 를 자동 실행(끄려면 `vibeManager.autoOpenWorkbench=false`)
- **화면 ID 묵시 재사용 금지**: ID-base quick 아이템(`needsId:true` 23종 전부) 은 실행 전 **QuickPick 4-choice** 통과 필수 — ① 현재 ID 유지 ② 다른 ID 직접 입력 ③ **AS-IS DB 프로그램 목록에서 선택** (`tools/DbConn/list_asis_programs.py` · TB_FX_ProgramInfo UseYN=Y) ④ 취소. 변경 시 세션 자동 리셋
- **Claude /mode 선택기**: 하단에 드롭다운 — 🤖 자동(acceptEdits) · 🖐️ 수동(default) · 📋 PLAN · 🔓 전부허용(bypassPermissions). 세션별 override, 전역 기본값은 `vibeManager.defaultPermissionMode`
- **Claude /model 선택기**: 하단 드롭다운 — ✴️ Opus 4.7 (1M) · Opus 4.7 · Sonnet 4.6 · Haiku 4.5 · 기본(전역 `vibeManager.claudeModel`). 세션 override 가 전역보다 우선
- **📱 원격(모바일)**: 현재 Claude 세션 ID 를 모바일 Claude Code 에서 이어받기 위한 **세션 ID / `claude --resume <id>` 복사** 다이얼로그. 공식 CLI 플래그가 없어 안내 + 복사 조합
- **하단바 재구성**: 화면ID 입력란·컨텍스트(자동)·하네스(자동) 체크박스 제거(실질 효과 없는 데드컨트롤 — `withCtx` 는 ID 유무로 자동, `effectiveHarness` 는 ID/작업으로 자동). 대신 **📍 ID 뱃지 버튼** → 클릭하면 QuickPick, **✎ quick.json 편집** 버튼 추가
- **이모지 재설계** (로켓 제거 · 공간/도구/흐름 테마): 서버 🚀→🖥️ · 분석·문서 📚→📑 · 화면 🎯→🪟 · 전체 🧰→🧭 · Claude 🤖→✴️ · 새 화면(from AS-IS) 🚀→✨. 소스 📦 · 환경 ⚙️ · 리본 아이템 유지(의미 일치)

## 1.5.0 (2026-10-19)
- **패널 탭 아이콘**: 에디터 탭에 Vibe_Manager 로고(vibe.svg/vibe-color.svg) 표시 — 테마 라이트/다크 대응
- **멀티 인스턴스**: `➕ 새 창` 버튼 + `vibeManager.openWorkbenchNew` 명령 — 워크벤치를 2개·3개 띄워 각 창이 **독립된 Claude 세션 · 화면ID · procs · 첨부 리스트**로 멀티 작업. 각 창에 `#2`, `#3` 번호 표기
- **상단 탭 ≠ 버튼**: 작업 출력/Claude/화면 현황/**FLOW**/**이력** 탭은 언더라인 스타일(투명 배경+하단 2px focusBorder, 선택 시 굵게). 일반 버튼은 둥근 배경 유지
- **FLOW/이력을 워크벤치 내부 탭으로**: 별도 창 없이 같은 워크벤치 안에서 전환. FLOW 셀 클릭 → 그 단계 작업 자동 실행 · 이력에서 파일 클릭 → 작업전↔작업후 diff. 작업 종료 시 자동 재조회
- **첨부 (📎)**: 파일/이미지 다중 선택 → 칩으로 표시 → 전송 시 `@경로` 토큰으로 Claude Code 에 전달. 이미지는 Claude 가 직접 읽음. **textarea Ctrl+V 로 클립보드 이미지 붙여넣기** 지원(.vibe/attached/ 에 자동 저장)
- **로딩 애니**: 상단 탭 바 우측 **스피너 + Claude 응답 중 라벨**, Claude 탭엔 `✻ Thinking…` 펄스 — 백그라운드 작업/Claude 호출 중임을 항시 시각화. 전송 버튼도 "⌛ 응답 중…" 으로 전환
- **메뉴/버튼 이모지**: quick.json 전 그룹·버튼에 이모지 — 서버 🚀 · 소스 📦 · 분석·문서 📚 · 화면 🎯 · 전체 🧰 · Claude 🤖 · 환경설정 ⚙️. 상단 탭 📜/🤖/🎯/📊/🕒, 하단 📤/📎/🔄/🎯/➕/🧹/⏹️
- **자동 컨텍스트/하네스** (사용자 선택 불이익 제거): 화면ID 가 있으면 **ctx 체크박스와 무관하게** 그 화면 컨텍스트가 자동으로 prefix 됨. 신규 UI 생성·GAP 분석·보완(S5.pipeline/pipelinedesign/pipelinedry/new/claude/repair/check/final/pkgrepair/pkg/pkgdeploy, S4.one, S3.agent, needsId:true 인 Claude 지시) 작업은 **하네스 모드 자동 ON** — 사용자가 체크 안 해도 적용. 체크박스 라벨에 "(자동)" 명기 + 툴팁에 적용 범위 설명

## 1.4.2 (2026-10-19)
- 왼쪽 하단에 **새 화면** 버튼 추가(사이드바 프롬프트 패널 · 워크벤치 양쪽) — 클릭 시 화면ID 입력창(형식 검증 DMF0052/SCP0096 등) → workspaceState 즉시 갱신 + Claude 세션 리셋 + 상태 패널 재조회. 이전 화면ID 가 workspaceState 에 남아 자동 prefix 로 섞이는 혼선 해소
- 워크벤치 레이아웃: **중지·지우기** 버튼을 상단 탭 바 → **하단 프롬프트 행 우측**으로 이동(실행 중 입력 중단이 손 가까이에서 가능). 왼쪽 빠른 실행을 **리본 메뉴**로 재구성(상단 탭=그룹, 하단=버튼 스트립, 기본 탭=화면 · ★ 새 화면(from AS-IS) 하이라이트). 상단 Claude 창의 **도구 호출(🔧)·도구 결과(↳)는 접힌 요약으로 표시**하고 클릭 시 상세(최대 360px)로 펼침 — Claude Code 터미널과 동일한 패턴

## 1.4.1 (2026-10-19)
- 터미널 완전 제거: 사이드바 프롬프트/빠른 실행은 워크벤치로 전달, git 업로드·병합도 패널 스트리밍(GIT_TERMINAL_PROMPT=0), "터미널에서 열기" 버튼 삭제. 아이콘 확정(vibe.svg / vibe-color.png)

## 1.4.0 (2026-10-19)
- **워크벤치**(vibeManager.openWorkbench, 상태 표시줄 클릭): 에디터 한 장을 3분할 — 왼쪽 빠른 실행/단계 트리(+FLOW·이력 버튼), 오른쪽 위 작업 내역(작업 출력 스트리밍 · Claude 대화 · 화면 현황), 오른쪽 아래 프롬프트
- 작업은 터미널 대신 자식 프로세스로 실행해 출력을 패널에 스트리밍(.vibe/logs/ 로그, ■ 중지), 서버 기동도 패널 스트리밍. Claude 는 `claude -p --output-format stream-json`(세션 유지, 응답·도구 사용 표시, 터미널로 전환 가능)
- 아이콘 교체: 활동 바 단색(V 흐름+단계 노드+허브 링) / 컬러 `media/vibe-color.png`(Claude 팔레트)

## 1.3.1 (2026-10-19)
- 빠른 실행 추가: 소스(업로드 leekc297/NSCM_NEW · 공통소스 가져오기/병합 eunjoo-hwang/nscm-fe · 상태), 분석·문서(AS-IS 파싱 1화면 · 문서 생성 · **Excel 묶음**(tools/Docs/md2xlsx.py → Doc/documents/<ID>) · GAP 분석/보완), 새 화면 2종(from AS-IS / **from 설계서** pipeline --design), 환경설정(DB·AS-IS·TO-BE·하네스·E2E·env.json·probe)
- **FLOW 진척 패널**(vibeManager.openFlow): 화면×단계(파싱→문서→Excel→GAP→생성→게이트→수선→PKG→등록→E2E) 상태를 산출물로 판정, 진행률·단계별 집계·셀 클릭 실행·CSV 저장
- **작업 이력**(vibeManager.openHistory): 파이프라인/수선/PKG/등록/GAP/문서 작업 전·후 스냅샷(.vibe/history/<ID>/<ts>_<task>/before|after) — 화면별/일자별 목록, 변경 파일(FE 페이지 · DB 객체 SQL · 문서 · GAP) 클릭 = 작업전↔작업후 diff, "현재와" = 작업후↔현재
- 하네스: pipeline/repair-loop `--design <화면설계서.md>`(설계서 우선, 차이는 매핑표에 '설계서 우선' 사유)

## 1.3.0 (2026-10-19)
- **Claude 프롬프트 패널**(사이드바 최상단): 입력 → 전용 터미널 "Claude Code (Vibe)" 의 대화형 `claude` 에 그대로 전달(Claude Code 기능·slash 명령 그대로). 새 세션 / 이전 세션 이어서(--continue) / 화면 컨텍스트 자동 첨부 / 하네스 모드(VIBE_HARNESS=1)
- **빠른 실행 버튼**(`quick.json` — `.vibe/quick.json` 으로 덮어쓰기 가능): 서버(BE/FE/둘 다/브라우저), 화면ID 작업(파이프라인·드라이런·PKG 배포·등록·되돌리기·E2E·DoD·PIPELINE·매핑표), 전체(계정 확인·대사표·E2E 리포트·룰셋·환경), Claude 프리셋(게이트 BLOCK 고치기·PKG 이식 마무리·E2E 실패 분석·화면 설명)
- 명령: `Vibe_Manager: BE 서버 기동` / `FE 서버 기동` / `Claude Code 새 세션 터미널`

## 1.2.2 (2026-10-19)
- 룰 이관: `tools/VibeManager/rules/` 신설 — `00_ENV.md`+`env.json`(환경 단일 출처), `10_RULES_KEEP.md`(이관 룰 + 게이트 코드), `20_RULES_SKIP.md`(제외/보류 사유), `30_HOOK_DISPOSITION.csv`(hook 154 전수 처분)
- 게이트 신설: check.js R01~R16(FE 이관 룰), check-pkg.js P30~P38(Oracle 이관 룰)
- 하네스 Claude 호출에 `VIBE_HARNESS=1` — `.claude/hooks/check-rules-read`·`attach-context` 통과(대화형 세션은 그대로)
- "룰·Hook·하네스" 뷰에 이관 룰셋 그룹, S6 에 열기 작업 3종

## 1.2.1 (2026-10-19)
- S5: 등록 되돌리기(`<ID>_revert.sql` 미리보기/커밋), 파이프라인 `--regen-pkg`(이식된 PKG 보존이 기본이 됨)
- S7: dev-login 가능 계정 확인(`probe-accounts.js`), 스모크/CRUD/권한 작업에 화면ID 입력
- 러너: npm/npx/브라우저 다운로드 제거(로컬 Chrome 사용) — Local 환경 보호

## 1.2.0 (2026-10-16)
- **완료 정의(DoD) 패널** 신설: 현재 화면의 DOD.md(B01~B21 ✅/❌), FE 게이트 BLOCK/WARN(클릭 → 파일:라인), PKG 게이트, 파이프라인·E2E·골든·신뢰도 한눈에
- **ID 하나로 끝까지**(pipeline.js): FE 골격 → 등록 SQL → PKG 골격 → FE 수선(Claude ×3) → PKG 이식(Claude ×3) → E2E 스펙 → 대사표. 드라이런(--no-claude) 작업 포함
- 2단계: To-Be 프레임워크·공통 카탈로그(framework.js) 생성/열기
- 빠른 실행에 ★ 파이프라인 항목, 화면 선택 시 DoD 패널 자동 갱신

## 1.1.0 (2026-10-16)
- 작업 종류 `python` / `cmd` 추가 (설정 `vibeManager.pythonCommand`)
- 2단계: DB 접속 점검(probe.py) · To-Be Oracle 메타 export(export_tobe_meta.py) · dbconn.json 열기 — 접속정보는 tools/DbConn/dbconn.json + .env.asis 로 일원화(비밀번호 미표시)
- 1단계: 개발대상 대사표(Recon) — xlsx→csv, recon.js, 대시보드
- 4단계: 골든 테스트(As-is SP ↔ To-Be PROC 결과 대조) 케이스 생성/실행/열기
- 5단계: 자동 수선 루프(repair-loop.js: gen→Claude→게이트 ×3) · 컴파일/린트 게이트(check.js --tsc --lint; --final 에 포함)
- 7단계 신설: E2E(Playwright) — 계정/권한매트릭스 추출, 스펙 생성, 스모크/CRUD/권한·Division 실행, 결과/HTML 리포트
- 빠른 실행(화면ID): 자동 수선 · 골든 · E2E 전체 항목 추가

# Changelog
## 1.0.0 — 2026-10-16
- 최초 릴리스: 6단계 트리(30작업)·게이트 판정·대시보드·상태표시줄, 프로그램 ID 빠른 실행, 룰·Hook·하네스 뷰(hook 켜기/끄기), 환경설정 뷰·환경 점검, 실행 이력, 전/후 소스 비교(git), Agent 배치/게이트 집계.
