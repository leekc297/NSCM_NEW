## 1.9.43 패널 가로 축소 시 맨 아래 항목 유지 — 채팅·로그 상자가 바닥에 붙어 있던 상태면 크기 변경 뒤 자동으로 맨 아래로(ResizeObserver) (2026-11-06 · workbench.js 설치 폴더 반영 — VS Code 창 다시 로드 필요)
- 사용자: "VM UI 를 가로로 줄였을 때 마지막 항목이 보이도록 VSCROLL 을 맨 아래로" — 종전엔 새 메시지가 올 때만 바닥으로 갔고, 가로 축소로 내용이 길어지면 스크롤 위치가 그대로라 마지막 줄이 가려졌다.

## 1.9.42 화면 ID 중간 폴더(동시 실행 격리) · CheckList 진행 = 단계 i/7 · 세부 j/M · 테스트 n/N (2026-11-06 · workbench.js·extension.js·flow-panel.js·quick.json 설치 폴더 반영 — VS Code 창 다시 로드 필요)
- 사용자: "results.json 을 UI ID 별로 … 다른 작업에 영향을 미치지 않도록 세션별/UI별로 파일을 다르게" · "UI_ID 별 작업은 중간 폴더로 UI_ID 를 넣어서" · "변경된 폴더의 결과를 찾아서 사용할 때 제대로 찾도록"
- **원인(실측 11-06 10:17~10:47)**: SCP0084·0037·0016 smoke 가 동시에 돌며 공용 `Doc/e2e/results/results.json`(10:26 다른 화면이 덮음)·`artifacts`(Playwright 가 시작 때 비움 → SCP0084 trace 없음)·`_summary.csv` 를 공유 → SCP0084 실패 원인을 읽을 수 없었다.
- **E2E(tools/E2E)**: `run-e2e.cmd <종류> <ID 1개>` → 결과 `Doc/e2e/results/<ID>/`(results.json·html·artifacts·shots·_summary.*) · 로그 `Doc/e2e/logs/<ID>/` · 잠금 `_run.e2e.<ID>.lock`(같은 화면만 직렬). 여러 화면·전체 = 종전 공용 폴더·`_run.lock`(둘은 서로 막음). `report.js` = 화면별 요약이 정본 · 공용 `_summary.csv/.md` 는 잠금 안 재조립 색인(원자 교체). `gen-e2e.js` `_index.csv`·`_matrix.csv` = 이번 화면 행만 교체(종전: 마지막 화면 1행만 남음). `probe-accounts.js`·`dbconn.write_csv`(Doc/tobefacts/db) 원자 쓰기.
- **골든·회귀**: `golden.py` 화면별 `Doc/golden/<ID>/_summary.csv` + 공용 색인 잠금 병합(`--case` 는 그 케이스만 교체) · `regress.py` 화면별 `Doc/verify/<ID>/_regress_report.md` + 원자 쓰기.
- **읽는 쪽(화면 폴더 먼저, 없으면 공용)**: `tools/Harness/verify/e2e_paths.py`(prereq·judge·mapping_trace·make_test_report·sort_check) · `e2e-judge.js`(로그도 화면 것만 — 종전엔 화면 구분 없이 최신 로그) · VM `e2eSummaryFile`(체인 e2eRows 검증·E2E 보완·종류 선택) · `flow-panel.js` · 트리 'E2E 결과'·'골든 테스트'(PASS 를 verdict 열로 셈 — 종전 줄 끝 ',PASS' 는 order 열을 셌다) · 'E2E 결과 열기'·'HTML 리포트' 메뉴 = 현재 화면 폴더 파일(e2eForId).
- **CheckList 진행 표시**: 종전 Flow 카드는 'Running N tests' 마다 전체 수만 바꾸고 완료 목록은 누적 → 검증엔진 72개 뒤 팝업·권한 9개가 시작되면 '73/9'. 이제 `run_verify.py` 가 `[단계 i/7] 이름`(사전 작업 → AS-IS 사실·원장 → 정적 검사 → E2E 검증엔진 → 팝업·권한 검사기 → 사후 판정 → 문서) · `[세부 j/M] 도구`(건너뛴 조건부 도구도 번호 사용 · 예정 수와 어긋나면 [WARN]) 를, `prereq.py` 가 사전 작업 항목마다 `[세부 j/M]` 을 내고, 카드 머리 = `📍 단계 i/7 이름 · 세부 j/M 도구 · 🧪 n/N (k번째 실행) · ✅ · ✖`, 테스트 목록은 실행별 머리줄, 진행바 = (끝난 단계 + 단계 안 비율)/7.
- 확인: report.js 두 화면 동시 실행(임시 폴더) 색인 70행 유지·두 화면 반영 · gen-e2e 3회 생성 4화면/5행 유지 · golden 요약 6화면 동시 병합 손실 0 · runlock 6가지 규칙 · 실제 `run-e2e.cmd smoke SCP0122`(11:21~11:22, 3 passed) 결과·로그가 화면 폴더에 생성·공용 results.json 무변경(10:26:05) · Flow 카드 모의(smoke 3 → 72 → 9) '📍 단계 5/7 … 🧪 1/9 (3번째 실행)' · VS Code 창 표시는 미확인(다시 로드 후 사용자 확인 필요). 백업 *.bak_20261106.

## 1.9.41 화면 ID 첫 입력 무반응 보완 — 확정 창에 ID 를 바로 치고 Enter 한 번으로 지정 (2026-11-05 · workbench.js 설치 폴더 반영 — VS Code 창 다시 로드 필요)
- 사용자: "VM 에서 UI ID 미지정 상태에서 최초 UI ID 입력하면 반응하지 않습니다, 한번더 입력해야 입력됩니다."
- **원인(코드 확인)**: 📍 ID 버튼·needsId 메뉴의 화면 ID 확정 창(`confirmScreenIdOrPick`)은 `showQuickPick` 이라 입력칸이 '목록 필터'다. ID 미지정이면 안내문이 "입력 또는 선택하세요"라서 그 칸에 `SCP0084` 를 바로 치게 되는데, 맞는 항목이 0개라 Enter 가 무반응 → '✏️ 다른 ID 직접 입력' 을 골라 입력창에 다시 쳐야 했다.
- **보완**: `createQuickPick` 로 바꾸고, 입력값이 ID 형식(2~4자 영문 + 2~6자리 숫자)이면 맨 위에 `✅ <ID> 로 지정` 항목을 즉시 만들어 활성화 → Enter 한 번으로 확정. 형식이 아니면 Enter 해도 닫히지 않고 대기. 기존 선택지(현재 ID 유지·✏️ 직접 입력·🔎 AS-IS 목록·⛔ 취소)와 확정 후 동작(세션 리셋·setId·탭 제목)은 그대로.
- 확인: `node --check workbench.js` 통과. 실제 창 조작 확인은 미실행(VS Code 창 다시 로드 후 사용자 확인 필요). 백업 *.bak_20261105.

## 1.9.40 작업 실패 시 원인 줄 표시 — 로그의 [FAIL]/[ERROR] 줄을 작업창·채팅·Flow 보드·VS Code 알림에 (2026-11-04 · workbench.js·package.json 설치 폴더 반영 — VS Code 창 다시 로드 필요)
- 사용자: "VM CHECKLIST 작업 수행 시 오류 발생 — 작업창에 어떤 오류인지가 보이지 않습니다. 오류 발생 시 어떤 오류가 발생했는지 쉽게 인지할 수 있도록 알려주세요."
- **증상**: 🔎 CheckList SCP0122(17:04:59) 가 `✖ 실패 — … (exit 6) · 844s` 로만 끝남. 실제 원인 `[FAIL] SCP0122: files.csv current 변형 없음 — AsisFacts 먼저 실행` 은 Task Log 65줄 안에 묻혀 있었다(10-30 SCP0125 exit 6 도 같은 줄).
- **spawnStream**: 출력 줄 중 표식(`[FAIL]`/`[ERROR]`/`✖`/`Traceback`/`…Error:`/`ORA-`/`PLS-`/`ENOENT`/`EADDRINUSE`/`npm ERR!`/`error TSnnnn`) 줄을 최대 8개 모아 두고, 종료코드≠0 이면 ① Task Log 에 `✖ 실패 원인(로그의 [FAIL]/[ERROR] 줄)` 블록 ② 채팅 meta `✖ <작업> 실패 (exit N) + 원인 줄 + 로그 경로` ③ VS Code 경고(첫 원인 줄 · 'Log 보기'). 표식 줄이 없으면 마지막 출력 3줄을 원인 후보로. 서버 기동(startServerStream)은 `failReport:false`(taskkill 종료는 실패가 아님).
- **단일 작업(메뉴)**: Flow 보드 결과 줄 `✖ 실패 — 제목 (exit N)` 아래에 `원인: …` · `로그: …` 추가.
- **체인 단계**: 결과 note 에 `원인: <첫 줄>`(FULLRUN.md·단계 목록) · `⏭ 실행 실패라 보완하지 않음` 줄에 원인 · 체인 중단 요약에 원인 전체(여러 줄일 때). verify 실패는 verifyStep 사유를 그대로 원인으로.
- 확인: 두 실패 로그 재생(11-04 SCP0122 · 10-30 SCP0125) → 각각 `[ERROR] 골든 케이스 … 생성 0건` + `[FAIL] …: files.csv current 변형 없음` 2줄만 추출 · 정상 종료 로그(11-03 ☁️)는 표시 없음. `node --check` 통과. 백업 *.bak_20261104b.
- 이번 exit 6 의 근본 원인(검증엔진 결함 · 같은 날 보완 — Pack.cs variant 분리 · files.csv sln_registered 열 · 31 화면 Pack 재생성 · _checker_defects.md T53): AsisFacts Pack.cs 가 .sln 미등록 프로젝트의 variant 를 `current(sln미등록)` 으로 기록하는데 `facts_combosrc.py`(== 'current') · `gen_golden_cases.py`(== 'current') 가 정확히 `current` 만 받는다 → files.csv 31 화면(FP00602·FP00900~903·FP02003·SCP0104~0109·0112·0114~0116·0120~0133·SSP0046) 에서 CheckList 가 같은 줄로 중단된다.

## 1.9.39 E2E 테스트 메뉴 단계 폐지 · 자동보완 = CheckList → 오류분 보완 → 재판정 반복 (2026-11-04 · quick.json·workbench.js·extension.js — VS Code 창 다시 로드 필요)
- 사용자: "E2E 테스트 메뉴단계는 없애 주세요. 자동보완 시 CHECKLIST 작업을 진행하고 오류분에 대해서 자동보완되도록 하는 구조로 진행해주세요."
- **E2E 메뉴 단계 제거**: 🚀·🧩·📏·🚒 체인의 E2E 1/4~4/4(S7.smoke·crud·auth·authcrud) 단계 · 🎬 E2E 전체 4단계 메뉴 · 🩹 E2E 오류 보완 메뉴 · 빈 '테스트' 묶음 · 명령 팔레트 '7 E2E 전체 4단계'. E2E(Playwright @verify·@trace)는 CheckList(run_verify) 안에서 그대로 실행된다. steps.json S7.* 작업 정의와 E2E 도구는 보존(CheckList 가 스펙을 쓴다).
- **재판정 단계 신설**(체인 4개 · 🧯 단계 바로 뒤): S8.verify + verify `checklistOpen`(이번 실행이 만든 fixlist.csv 의 action_needed=Y 0행이어야 통과) + repair `🧯 자동 보완` 2회 · `on: verify`(조치 필요가 남았을 때만 보완 — 서버 미기동·CheckList 미생성 같은 실행 실패는 보완하지 않고 FAIL).
- **okCodes**: run_verify 종료코드 10(검사기 회귀·커버리지 게이트)은 화면 보완 대상이 아니므로 판정을 계속하고 단계 WARN 으로 남긴다.
- fixlist.csv 는 칸 안 줄바꿈이 있어(DMF0003·DMF0082·SCP0007·SCP0111) CSV 파서로 집계 — Python csv 와 행 수·조치 필요 수 일치 확인(11-04).
- 🚒 이름 = '🚒 자동보완 (CheckList → 오류분 보완 → 재판정 반복 → 문서)' · chainId(autofix-full) 유지.

## 1.9.38 ☁️ 수정본 대상 누락 보완 · 이관 기준선 = 완료 표시로만 이동 (2026-11-03 · quick.json·steps.json·tools/CloudPkg/cloud_pkg.py 1.1.0)
- 사용자: "이전 작업에서 1021 폴더를 만들었는데, 수정본 클릭 시 그 폴더를 알려주거나 수정본만 추출하면 되는데 새 수정본에 적용 대상이 누락된다."
- **원인**: 패키지를 만들기만 해도 '직전 이관' 기준선이 옮겨졌다. SCP0111 10:21 생성 → 10:37 수정본 = 전부 '직전과 같음' 제외, 00·90 만 남음.
- **☁️ 클라우드 이관 완료 표시**(S5.cloudApplied · `--applied`) 신설: 기준선은 이것으로만 옮긴다. 수정본은 그때까지 누적된다.
- **다시 클릭**: 입력이 같으면 기존 폴더 안내 · 기준선 이후 변경 없으면 새 폴더 없이 마지막 패키지 안내.
- **같은 분 재생성**: 이전 폴더를 지우던 결함 수정 — 이름이 있으면 초까지 붙인다.

## 1.9.37 + 환경설정 🧭 작업 모드(DB MODE / UI/DB MODE) · ☁️ 메뉴 4→2 · 🧯 메뉴 2→1 (2026-11-02 · quick.json·steps.json·workbench.js·package.json 설치 폴더 반영 — VS Code 창 다시 로드 필요)
- 사용자: "환경설정에서 DB MODE, UI/DB MODE 선택 · UI/DB = 제약 없이 개발, Git Download & Merge 때 로컬 보호 · DB = DB·META 만, FE 는 가이드만, Git Download & Merge 때 로컬 보호 안 함 · CheckList 는 모드 무관 전체" · "클라우드 이관도 모드로 자동 선택, 메뉴 4개 → 2개" · "자동 보완, 자동 보완(DB) 도 하나로".
- **🧭 작업 모드**(kind work-mode): 값 저장 = `tools/Harness/harness.json repairScope`(DB_ONLY = DB MODE · DB_FE = UI/DB MODE) · 쓰기 = `set_scope.py`(DB·UIDB 별칭 추가). 🧭 보완 범위 메뉴를 대체.
- **DB MODE 강제**: 모든 Claude 요청 앞에 DB MODE 문단 주입(메뉴·체인·수선·직접 입력 공통) · 실행 hook `.claude/hooks/check-work-mode.ps1`(FE·BE 수정 차단) · `gen.js --apply` 는 Doc/gen 만 생성 · `repair-loop.js` FE 수선 건너뜀(--pkg 는 실행) · 체인 E2E 는 FE 페이지가 없을 때만 SKIP.
- **🧯 자동 보완 통합**: 🧯 자동 보완(DB) 제거 — 🧯 자동 보완 1개가 작업 모드를 따른다.
- **☁️ 통합**: ☁️ 클라우드 이관 패키지(수정본)·(전체) 2개(S5.cloudMod·S5.cloudFull) · `cloud_pkg.py --mode auto`(기본값) · `--stage` = 작업 모드 범위의 수정본+전체 2종. `--mode db|all` 직접 지정은 유지.
- **⬇️🔀 Source Download & Merge**: DB MODE = `common_sync.py --overwrite-local`(로컬 편집본도 공통 원문으로 덮어씀 · 공통이 지운 파일 삭제 · 로컬 전용 파일 유지 · 백업 유지) / UI/DB MODE = 기존 보호 병합.
- **CheckList**: 검사·판정 코드는 모드를 읽지 않음(표시 열·문구만 사용). 변경 없음. 공통 컴포넌트 변경 전 확인(E15)은 유지. 백업 *.bak_20261102.

## 1.9.36 + Task History 신설 · 작업 이력 → Revision History · 기본 일자별 (2026-10-30 · quick.json·workbench.js·extension.js·history.js·package.json 설치 폴더 반영 — VS Code 창 다시 로드 필요)
- 사용자: "History 초기값 = 일자별(화면별은 내 작업본이 아닌 화면이 먼저 보임)" · "VM 메뉴·프롬프트 입력 작업 내역을 이력으로 보기" · "현재 작업 이력·WorkBench History = Revision History, 추가 기능 = Task History, Overview & Reports 에".
- **Revision History**(기존): 메뉴·탭 이름 변경 · 파일 전후 스냅샷이 있는 이력만 · 기본 일자별 · 선택·삭제 후에도 보던 방식 유지(종전엔 화면별로 되돌아감).
- **Task History**(신규): 워크벤치 탭 🧾 + Overview & Reports 메뉴(명령 vibeManager.openTaskHistory). VM 메뉴·체인·체인 단계·작업·직접 입력 프롬프트 전부 기록 — 화면 ID 없음·스냅샷 비대상 포함(scope none, `.vibe/history/_공통/`). 필터 전체/메뉴/프롬프트/체인 단계/작업 · 상세 = 출처·메뉴 이름·프롬프트 원문(withCtx 앞 사용자 입력)·시각·소요·결과·사용자·변경 파일. 터미널·서버·Git 처럼 즉시 끝나는 메뉴는 실행 사실만(▶ 실행). 1.9.36 이전 실행은 스냅샷 이력만 보임.
- history.begin 시그니처 확장(extra) · history.event 추가 · askClaude 4번째 인자 hmeta. 백업 *.bak_20261030_hist.

## 1.9.35 − GAP 분석 폐지 → CheckList 로 대체 (2026-10-30 · quick.json·steps.json·workbench.js·extension.js·flow-panel.js·package.json 설치 폴더 반영 — VS Code 창 다시 로드 필요)
- 사용자: "CheckList 가 완성되면 GAP 분석은 필요 없음 → 제거". CheckList 파이프라인(run_verify)은 GAP 을 쓰지 않음(사전 확인).
- 제거: 메뉴 🔍 GAP 분석 · steps S4.run/S4.one/S4.dash/S4.open(S4 = 골든 테스트만 남김) · 체인 📝·🚀·🧩·📏·🚒 의 GAP 단계 · 🧯 자동 보완/🧯 자동 보완(DB) 진단의 gap.js·gap.csv · 문서 사전 준비(prereq.py --docs) gap.js 재생성 · make_docs.py GAP분석서 · md2xlsx.py GAP 시트 · 빠른 화면 메뉴 '4 GAP 실행/열기' · 환경 요약 GAP 줄 · 하네스 자동 대상 S4.one · KEEP D8a 의 gap.js 판정 문구.
- 대체: FLOW 진척 '3 GAP' → '3 CheckList'(Doc/verify/<ID>/fixlist.csv action_needed=Y 중 미적용) · 상태 타일 'GAP 미반영' → 'CheckList 조치 필요'. 메뉴·체인 문구의 'UI CheckList' → 'CheckList'.
- 보존(삭제 안 함): tools/Harness/gap.js · Doc/gap/* 기존 산출물 · make_docs.build_gap(이력). 백업 *.bak_20261030_gap.

## 1.9.34 + 클라우드 이관 = 결정적 빌더 · 수정본/전체 4종 · PKG 보완 · META 생성 및 보완 · 자동 보완(DB) (2026-10-30 · quick.json·steps.json·workbench.js·extension.js·package.json 설치 폴더 반영 — VS Code 창 다시 로드 필요)
- 사용자: "클라우드 이관(DB) 1시간 넘게 걸림 — 생성·보완 때 미리 만들고, 요청하면 취합만. 미리 만들지 않았어도 5분 안에". → Claude 프롬프트 방식 폐지, `tools/CloudPkg/cloud_pkg.py`(사내 1회 조회 → 00 PRECHECK·05 BACKUP·10 DDL·20 PKG·25 SHARED·30 META·40 GRANT·90 VERIFY·99 ROLLBACK · 사내 리허설 DRY/ROLLBACK). 실측 SCP0100: 즉시 생성 12~53초 · 사전 생성 4종 94초 · 미리 만든 묶음 취합 10~30초.
- 메뉴(사용자 지정 명칭): ☁️ 클라우드 이관 패키지(DB, UI)(수정본) · (DB)(수정본) = 직전 이관(`_artifacts/_deploy_packages/_cloud_state/<ID>.json`) 이후 바뀐 것만 / ☁️ 클라우드 이관 패키지(DB, UI) · (DB) = 전체 취합(화면 소유 DB·META 전부 + FE 페이지 폴더·참조 파일 + ID 참조 BE). 폴더 `<ID>_CLOUD_{DB|DBUI}_{MOD|FULL}_<일시>`.
- 사전 생성: quick 항목 `postTask: S5.cloudStage`(🧯 자동 보완 · 🧯 자동 보완(DB) · 🩹 · 🔗 · 🩺 · 🧾 성공 뒤) + 체인(🚀·🧩·📏·🚒) 끝 단계 + 🛠️ 수동 보완 프롬프트 끝 안내. 묶음 = `_staging/<ID>/<mode>_<scope>/` + 입력 지문(manifest.json) — 메뉴 실행 시 지문 같으면 복사, 다르면 즉시 생성.
- 🔗 PKG 변환 → 🔗 PKG 변환 (AS-IS>>TO-BE) · 신규 🩺 PKG 보완(컴파일·실행 ORA- 오류 재현·수정·검증, FE/BE 가이드만) · 신규 🧾 META 생성 및 보완(없으면 생성, 있으면 현재 PKG ALL_ARGUMENTS·UI 에 맞게 보완) · 신규 🧯 자동 보완(DB)(자동 보완 아래 — DB 직접 수정, FE·BE 는 Doc/verify/<ID>/FE_GUIDE_*.md 가이드만, repairScope 무관). 🧯 자동 보완 · 🚒 자동보완 & 테스트 유지.
- 🔎 UI CheckList → 🔎 CheckList (상단 아이콘 qCheckList 접두도 변경). 백업 *.bak_20261030(b).

## 1.9.33 + 📋 테스트결과서 메뉴 (2026-10-30 · quick.json·steps.json·package.json 설치 폴더 반영 — VS Code 창 다시 로드 필요)
- 사용자 요청: "CheckList 작업 후 작업 내역에 대해서 테스트결과서를 생성 — 항목별 Group, 상세 내역을 테스트 내역과 결과로, 사용자의 언어로 보기 편하게 Excel, 필요하면 화면 캡처 포함, 메뉴는 UI CheckList 하단에(차후 UI CheckList 에 포함 예정이나 지금은 별도)".
- 메뉴 `📋 테스트결과서` = 체인 `S8.verifyIfStale`(CheckList 없거나 오래됐으면 E2E 포함 전체 실행) → `S8.report`(`tools/Harness/verify/make_test_report.py <ID>`). 산출 `Doc/테스트결과서/<ID>_<화면명>_테스트결과서_v<n>.xlsx`(이전 판 old/).
- 시트: 요약(실행 시각·환경·Playwright 실행·CheckList 대조·전체/그룹별 통과·실패·확인 필요·미검증·해당 없음·통과율) · 테스트결과(영역 11그룹 → 검사 규칙 → 항목 · Excel 개요(outline) 접기 · 테스트 내역[방법·조건·기준·AS-IS 근거·판정 출처]·기대·실제 상세·결과·설명·겪는 일·캡처·비고·검증 ID) · 실패 상세(항목별 블록 + 조치 계층·종결 근거 + 캡처 이미지) · 실행 테스트 · 화면 캡처(스모크 + 실패) · 용어 설명.
- 캡처: `_verify.spec`·`_trace.spec` afterEach — 그 테스트에서 FAIL 행이 나오면 종료 시점 화면을 `Doc/verify/<ID>/e2e/shots/`(색인 `index_verify.json`·`index_trace.json`)에 저장(실패 순간과 다를 수 있음을 note 에 명시) · run_verify 가 E2E 전에 이전 캡처 제거. 스모크 캡처(`Doc/e2e/results/shots/<ID>_*.png`)는 그대로 실린다.
- 결과 수치는 같은 실행의 CheckList 와 1:1(SCP0100 v12 ↔ 테스트결과서 v1: 1630행 · 통과 492 · 실패 19 · 확인 필요 36 · 미검증 48 · 해당 없음 1035). 테스트결과서는 아무것도 다시 측정하지 않는다.
- (같은 날 추가) 룰 **H21 — SCP·SSP 컬럼·조회조건 명칭 Valid→Active 일괄(TO-BE 룰 CR-092, 사용자 지시 2026-10-30)**: 정본 `tools/Harness/rules/label_alias.csv` · `rules/10_RULES_KEEP.md` H21 · `40_SEARCH_COND.md` 명칭 변경 룰 행 · check.js `LB1`(페이지 소스 라벨 리터럴 'Valid' → FINAL BLOCK · 예외 `LB-OK`) `LB2`(TO-BE 메타 COLUMN_LABEL_NAME 'Valid' → WARN · 메타 UPDATE 안내) · 정합검증 judge/`_trace.spec` H5 별칭 판정(AS-IS Valid↔TO-BE Active = PASS · TO-BE Valid 잔존 = CR-092 FAIL). 룰 파일은 저장소에서 읽으므로 설치 폴더 복사 불필요(CHANGELOG 만 복사).

## 1.9.32 + 서버 기동 완료 → 상단 스피너 중지 (2026-10-30 · workbench.js·package.json 설치 폴더 반영 — VS Code 창 다시 로드 필요)
- 결함: ☕ BE Start / 🎨 FE Start 로 띄운 서버는 기동 완료 후에도 프로세스가 계속 살아 있어 `procs` 에 남고, 상단 busy 표시(스피너 + `NSCM BE, NSCM FE`)가 계속 돎.
- 교정: 완료 로그(ready) 매치 또는 포트 LISTEN 확인으로 기동 완료 판정 시 해당 프로세스를 `ready` 로 표시 → `updateBusy()` 가 ready 프로세스를 스피너 대상에서 제외. 기동 중·시간 초과(완료 미확인)·다른 작업 실행 중에는 기존대로 스피너 표시. 종료(Finish)·프로세스 관리 대상은 그대로.

## 1.9.31 + 탭 명칭 = 화면 ID 반영 (2026-10-30 · workbench.js·package.json 설치 폴더 반영 — VS Code 창 다시 로드 필요)
- 화면 ID 미지정 창 = 기존과 동일 `VM#n`(열린 창 순서) · 지정 후 = `VM-<ID>`(예: `VM-SCP0100`) · 같은 ID 창 2개 이상 = `VM-<ID>#1`·`VM-<ID>#2`(그 ID 창끼리 열린 순서).
- `retitle()` 가 창 열기·닫기·ID 변경(setState) 때 전 창 명칭 재계산 — ID 해제 시 `VM#n` 복귀.

## 1.9.30 + 완료 판정 = 후속 작업(자식 프로세스) 종료까지 (2026-10-29 · workbench.js 설치 폴더 반영 — VS Code 창 다시 로드 필요)
- 사고: VM#2 가 '완료' 로 표시된 뒤에도 Claude 가 백그라운드로 띄운 `run_verify.py SCP0020`(r41) 이 돌고 있었고(Playwright 트레이스 18:47:00 까지 기록), 사용자가 중지하자 18:47:04 자식 프로세스가 함께 종료 → 23/23 직전에서 검증 소실·판정/CheckList 미생성. 원인 = Claude 가 "아직 끝나지 않아 중간 결과만 보고" 로 턴을 끝냈고 워크벤치는 result 이벤트만 보고 완료 처리.
- 워크벤치: result 가 와도 `liveDescendants(pid)`(프로세스 트리, cmd/conhost/claude 제외)가 비어 있지 않으면 상태를 **'보고 완료 · 후속 작업 진행 중'**(run pending · 경과 시계 유지 · 최종 보고는 바로 펼침)으로 두고, 10초마다 다시 확인해 전부 끝났을 때만 '완료'(종료 확인 시각·보고 후 경과 표기). 조회 실패는 '확인 불가' 로 적고 완료로 바꾸지 않음. 보고 뒤 후속 작업 중 중지(종료 코드≠0)면 '⏹ 중지 — 후속 작업도 함께 종료됨(결과 소실·재실행 필요)'.
- 중지 버튼: 중지 직전에 함께 종료될 후속 작업 목록(이름·PID·명령 110자)을 채팅 meta 로 먼저 보여 줌.
- 룰: `rules/10_RULES_KEEP.md` **H20** — 검증 실행을 띄운 턴은 끝날 때까지 턴을 끝내지 않는다(중간 보고 종료 금지 · 상한 초과 시 '미완료' 명시).
## 1.9.29 + Enter 전송 · 질문 줄 한 줄 표시 (2026-10-29 · workbench.js·prompt-panel.js 설치 폴더 반영 — VS Code 창 다시 로드 필요)
- 사용자 요청: 프롬프트 창도 Claude 와 같이 **Enter = 전송 · Shift+Enter = 줄바꿈**(워크벤치 입력창·프롬프트 패널 둘 다) · 한글 IME 조합 중 Enter(isComposing·keyCode 229)는 조합 확정만 하고 전송하지 않음 · Ctrl+Enter 도 전송 · ↑/↓ 이력 탐색 유지 · 버튼·안내 문구 갱신.
- 질문 줄(💬) = `💬 [화면 <ID>] : <질문 첫 줄>` — 화면 컨텍스트 경로 접두 숨김 · 기본 한 줄(넘치면 …) · 여러 줄이거나 140자 넘는 질문만 펼쳐서 질문 전문 · 접두 포함 원문 전체는 마우스 올리면(툴팁).

## 1.9.29 + LITE 질의 = Step 상황판 없이 질문 + 결과만 (2026-10-29 · workbench.js 설치 폴더 반영 — VS Code 창 다시 로드 필요)
- 사용자 요청: Step Status 가 필요 없는 LITE 질의(산출물 없는 질문·확인)는 상황판(현재 Step/전체·진행바·도구/수정/경과·Step 카드)을 띄우지 않고 위 질문 + 아래 결과만.
- 판별: 시작 시 프롬프트로 예측(attach-context 훅과 같은 기준 — 300자 미만 · 질의 신호 있음 · 산출물 동사 없음 · `!lite`/`!full` 강제, 화면 컨텍스트 접두 `[화면 …] … — 참고 후:` 는 빼고 판단) → 응답 첫 줄 `[LITE]` 면 LITE 확정 · `[T# …]` 표기나 할 일 목록(TodoWrite)이 오면 작업(FULL)으로 확정해 상황판 복귀.
- LITE 화면: 진행 중 = '⏳ 진행 중 · 경과' 한 줄 · 끝나면 결과 본문(높이 제한 없음, '최종 보고' 머리 숨김) · 비용/시간 메타 줄 유지.
- 질문 줄(💬)은 모든 실행에서 화면 컨텍스트 접두 대신 실제 질문 첫 줄을 보여줌(펼치면 전문).
- Claude 비정상 종료 진단(사용자: '세션이 끊어졌다' 메시지만 반복): stderr 를 .vibe/logs/<ts>_claude_wb<N>.log 에 기록하고 종료 코드 메시지에 마지막 stderr 와 원인별 안내(세션 재개 실패/로그인 만료/CLI 경로/네트워크)를 붙임 · '새 세션' 안내는 --resume 실패일 때만
- 프롬프트 입력창 ↑/↓ 이력 탐색(사용자 요청): 캐럿이 첫 줄일 때 ↑ = 이전 명령, 마지막 줄일 때 ↓ = 다음 명령, 마지막 다음은 작성 중이던 초안 복원 · webview state 에 최근 200건 유지

## 1.9.28 + 창별 독립 E2E(하네스 측: tools/E2E/runlock.js 화면별 잠금 · run_verify 대기 · golden/gen-e2e/prereq 공용 파일 보호) — 2026-10-28
- 다른 화면의 UI CheckList 는 창마다 동시에, 같은 화면만 순서대로. 이미 돌고 있던 실행(옛 코드)은 영향 없음.

## 1.9.28 + 창별 화면 ID 독립 · 탭 명칭 VM#n · 재기동 아이콘 (2026-10-28 · workbench.js·extension.js·package.json 설치 폴더 반영 — VS Code 창 다시 로드 필요)
- 결함: 사이드바 빠른 실행이 공용 `vibeManager.lastId`(마지막으로 어느 창이든 정한 ID)를 현재 창에 넘겨 '현재 ID 유지' 로 확정되면 그 창의 ID 가 다른 창 ID 로 바뀜. 새 창도 다른 창의 ID 를 기본값으로 가져옴.
- 교정: `workbench.currentId()`(현재 창의 ID) 우선 — 사이드바 실행·입력 기본값·트리 ID. 새 창(VM#2…)은 빈 ID 로 시작, 1번 창만 마지막 ID 복원. 공용 lastId 는 새 창 기본값/입력 기본값으로만.
- 탭 명칭 `VM#1`·`VM#2`… = 열린 창 순서의 연속 번호(닫으면 남은 창 번호 재부여 · 생성 누적 번호 #3·#5 건너뜀 교정) · 재기동(BE & FE Finish & Start) 아이콘 `$(debug-restart)`(녹색) → `$(device-desktop)`(단색 모니터).

## 1.9.28 + Workbench 다중 창 — 명령은 현재 선택된 창에서 실행 (2026-10-28 · workbench.js 설치 폴더 반영 — VS Code 창 다시 로드 필요)
- 결함: 새 창(Workbench #2, #3…)을 여러 개 연 뒤 첫 창에 포커스를 두고 사이드바·빠른 실행·열기 명령을 실행하면 **마지막에 만든 창**으로 넘어갔다 — 라우팅 기준 `lastWB` 가 '마지막에 생성된 창' 으로만 갱신되고 포커스 이동을 따라가지 않았음.
- 교정: 패널 `onDidChangeViewState`(활성 전환)·웹뷰 메시지 수신 시 그 창을 `lastWB` 로 갱신 → 명령은 사용자가 보고 있는 창에서 실행. 창을 닫으면 남은 창 중 하나로.

## 1.9.28 + 생성·보완 ↔ 정합검증 연결 · 메뉴 재편 (2026-10-28 · workbench.js 설치 폴더 반영 — VS Code 창 다시 로드 필요)
- 사용자 지시: 생성 시 생성 후 정합검증 / 자동 보완 시 정합검증이 최신이 아니면 정합검증 후 보완 / 보완은 정합검증 '조치 필요' 항목을 일괄 보완 / 정합검증은 소스를 수정하지 않는다.
- **정합검증 사전 작업 선수행**(`tools/Harness/verify/prereq.py`, run_verify 0단계): DB 접속 · AS-IS Fact Pack(pack.ps1) · TO-BE 메타(export_tobe_meta, 12시간 기준) · TO-BE 화면 인덱스(TobeFacts, FE 소스가 더 새로우면) · 골든 케이스(gen_golden_cases) · E2E 스펙(gen-e2e)·smoke 를 없거나 오래되면 먼저 실행. 생성 절차 산출물(Doc/gen e2e_plan)·FE 대조표·조회조건 기준표는 만들지 않고 MANUAL 로 기록(Doc/verify/<ID>/prereq.json · 정합검증서에는 넣지 않음).
- **S8.verifyIfStale**(`verify/verify_if_stale.py`): 직전 정합검증 시작(run_verify.result.json started) 이후 FE 소스·PKG LAST_DDL_TIME·화면 메타 LAST_UPDATE_DATE 가 바뀌었거나 결과가 없으면 run_verify 실행, 최신이면 건너뜀.
- **생성**(🚀·🧩·📏): '새 화면 7/7 대조표 갱신' 뒤 `S8.verify`(optional) → 이어지는 자동 보완이 조치 필요 항목을 일괄 보완.
- **보완**(🛠️·🧯·🩹·🔗): quick 항목 `preTask: "S8.verifyIfStale"` — workbench.js 가 Claude 로 보내기 전에 실행(🛠️ 입력창 채움 · 🩹 E2E 종류 선택·수선 회차 동작 유지, 사전 단계 실패해도 보완은 계속). 🚒 체인 첫 단계 = S8.verifyIfStale.
- **보완 지시문**: 일괄 대상 = `Doc/verify/<ID>/fixlist.csv` 의 `action_needed=Y` 행 전부(= 정합검증서 '조치 필요' 시트, 상속 FAIL 포함·중복 제외) · 행마다 처리 결과 보고 · 끝나면 정합검증 재실행. fixlist 없으면 기존 방식. 🔗 PKG 변환 = 조치 필요 중 DB 객체·DB 메타 행 동반 해소.
- **메뉴 재편**: 카테고리 '분석' → '분석,문서'(📝 문서 생성 · 🗂️ Excel 폴더를 🔎 화면 정합검증 뒤로 이동, '문서' 카테고리 삭제) · 보완 메뉴 이름 🛠️ 수동 보완 · 🧯 자동 보완 · 🚒 자동보완 & 테스트(claudeOf 참조 20건 갱신).
- **📝 문서 생성 = 생성 절차 없이**(사용자: 다른 PC 에서 만든 UI 도 파싱부터 필요한 절차만 거쳐 문서화): 체인 2단계 `S3.prep`(prereq.py --docs) — TO-BE 메타·TO-BE 인덱스를 소스보다 오래됐으면 다시, GAP 은 '없을 때만'→ 파싱 결과보다 오래되면 재생성(DMF0082 실측: 옛 GAP 재생성). `tools/Docs/make_docs.py` 페이지 폴더 = register.json(생성 산출물) 없거나 그 폴더가 실제로 없으면 TO-BE 인덱스로(종전: 'TO-BE 페이지 미생성'·대조표 매핑 시트 빈칸).
- **🌐 다국어 JSON 재생성**(Git 그룹, `S2.genI18n` → `tools/Env/fe_gen_i18n.py`): `pnpm gen`(gen:icons → gen:i18n)과 같은 내용을 pnpm 없이 실행 · 로컬 BE(127.0.0.1:8080) 메시지만 — 로컬이 메시지를 안 주면 아무것도 바꾸지 않고 중단(목데이터 덮어쓰기 방지) · 전후 KO/EN/CN 키 수 보고.
- **S8.verifyIfStale 실행 중 확인**: 같은 화면 정합검증이 실행 중(Doc/e2e/_run.lock 'verify <ID>' + pid 생존)이면 새로 돌리지 않음(rc 4) — 다른 세션 실행 도중 중간 원장으로 문서가 생긴 사고(10-28 v72 중간본, 삭제함) 재발 방지.
- **정합검증서 → CheckList**(사용자: 폴더·문서 명칭 변경): `Doc/CheckList/<ID>_<화면명>_CheckList_v<N>.xlsx` · 보완대상도 `Doc/CheckList` · 번호는 옛 정합검증서 번호를 이어감(SCP0007 → v73) · 사용자 의견 누적은 옛 이름·이전 위치(Doc/화면분석서)·old/ 까지 읽음. 메뉴 🔎 UI CheckList · S8 폴더 열기 = Doc/CheckList · UI Status 문서 카드에 📋 CheckList 폴더 추가(workbench.js 설치 반영).
- **이전 버전 old/ 이동**(사용자: 신규 버전 문서를 만들면 같은 UI 의 이전 버전은 폴더 내 old 로, 없으면 생성): `tools/Docs/doc_archive.py` — 같은 UI·같은 문서 = 접두 '{ID}_{화면명}_{종류}' 정확 일치(DMF0003 ↔ DMF0003_1 섞임 방지) · 번호는 old/ 포함 계산 · 열려 있어 못 옮긴 파일은 경고. 적용: make_docs(화면설계서·UI분석서·GAP분석서·대조표) · make_testcases(TestCases4) · make_verify_docs(CheckList·보완대상 — 이전 위치 Doc/화면분석서 의 같은 화면 정합검증서·보완대상도 Doc/CheckList/old 로).
- 메뉴 카테고리 이름 '분석,문서' → '분석·문서'.
- **명칭 일괄 변경**(사용자): 화면에 보이는 '정합검증' → 'CheckList'(메뉴·단계·지시문·실행 로그·워크벤치 문구) · 보완대상(목록) 문서 → **ActionItemList**(`Doc/CheckList/<ID>_<화면명>_ActionItemList_v<N>.xlsx`, 번호는 옛 보완대상 이어감 · 옛 보완대상은 다음 생성 때 old/). 옛 파일 찾기 패턴(정합검증서·보완대상)은 이전 버전 읽기용으로 유지.
- **상단 아이콘 재구성**(사용자 지정): Workbench · Flow · 🔄 BE & FE Finish & Start · ⬇️🔀 Source Download & Merge · 🚀 ID 하나로 전체 · 🔎 UI CheckList 만(신규 명령 vibeManager.qRestart·qSourceSync·qFullChain·qCheckList = quick.json 메뉴를 label 로 찾아 실행). 제거: 화면 선택·대시보드·새로고침·게이트 집계·환경 점검·이력(명령은 명령 팔레트에 남음) · '…' 더보기 유지. extension.js·package.json 설치 폴더 반영(package.json 은 설치 메타 보존) — VS Code 창 다시 로드 필요. 백업 *.bak_20261028b
- 백업: workbench.js.bak_20261028 · quick.json.bak_20261028 · steps.json.bak_20261028 · CHANGELOG.md.bak_20261028 · 설치 폴더 workbench.js.bak_20261028
## 1.9.28 + UI Status 문서 = 같은 문서는 마지막 버전만 (2026-10-27 · workbench.js 설치 폴더 반영 — VS Code 창 다시 로드 필요)
- 사용자 지시: "UI STATUS TAB 문서에는 동일 문서의 경우 제일 마지막에 생성된 버전의 문서만 표기". 📚 문서 카드의 Excel(화면설계서·화면분석서·단위테스트·documents/<ID>)을 **폴더 + 끝 버전 토큰들을 뗀 이름(대소문자 무시)** 으로 묶어 1건만 표시.
- 최신 판정: 두 파일 모두 날짜(_YYYYMMDD)가 있으면 날짜 우선 → 버전 숫자(_v1.0 · _v28 · TestCases4.1 · _v1.2_20260827) → 같으면 수정 시각 최신. 화면 ID 숫자는 버전으로 떼지 않음. 실측(전 30화면): DMF0005 56→2 · SCP0007 63→8(종류별 1) · DMF0014 ValidationCases 6→1 · Validation_Rules 3→1(v3_20260923).
- 백업: workbench.js.bak_20261027 · CHANGELOG.md.bak_20261027 · 설치 폴더 workbench.js.bak_20261027
## 1.9.28 + 독립 판정·근거 등급·결과 봉투 (2026-10-26 · workbench.js 설치 폴더 반영 — VS Code 창 다시 로드 필요)
Atlas Studio 내장 규약(검토자 분리 · 통과 근거 등급 · 결과 봉투)을 이식(사용자 지시 2026-10-26: "1·2번을 적용해 정합검증서를 생성하고 차후 보완에 도움이 되게 · 4번은 추천 범위에서").
- **🩹 독립 판정(검토자 분리)**: 수선 세션이 기대값 결함(c)을 주장하거나 판정요약이 없으면 `tools/Harness/e2e-judge.js` 가 **새 Claude 세션**(이전 대화 이어받지 않음)·**읽기 전용 도구**(Read·Glob·Grep, 수정·실행 차단)로 실패 원인을 다시 분류. 실패 원문(요약 FAIL 행·로그 Error 블록)은 스크립트가 직접 실어 준다. 판정 항목이 실제 실패 목록에 없으면 보정 허용에서 뺀다.
- **근거 등급**: 판정 근거 = `경로:줄` + 그 줄 원문 인용 → `tools/Harness/verify/evidence_check.py` 가 실제로 있는지 기계 확인(hard) / 확인 안 됨·설명만(soft). **시험 기준 보정은 근거가 확인된 기대값 결함만**(`${xids}`), 근거 미확인·판정 불가는 `Doc/e2e/_human_review.md` 사람 확인 큐.
- **테스트 약화 검사**: 시험 기준 보정 전후 `verify/weaken_check.py --snapshot/--compare` — 검사(expect) 감소·skip/N/A 증가·예외 삼키기·파일 삭제. 걸리면 재시험이 통과해도 통과로 인정하지 않음.
- **단계 상태 HOLD(⏸ 사람 확인)**: 종전 '(c) 만 남으면 WARN 으로 계속' → 근거 확인된 경우만 WARN, 근거 미확인·약화 의심·판정 불가는 HOLD. 체인은 멈추지 않지만(10-21 지시 "E2E 오류로 멈추지 말 것") 요약이 '✅ 체인 완료' 가 아니라 '⏸ 체인 종료(사람 확인 필요)'.
- **정합검증서 근거 등급**: 각 행 '근거 등급' 열(기계 · 기계(상속·집계) · 사람 · AI 작성·인용 확인 · AI 판단만 · 출처 미기록 · 없음) + 요약 시트 '근거 등급 × 결과' 표. **AI 판단만으로 PASS·해당없음인 행은 판정필요로 셈**(원장 값은 보존). 보완대상목록에 '현재 판정 근거 등급'·'종결 근거(해결로 인정하는 조건)' 열 — fixlist.csv 에도 `grade`·`close_evidence`.
- **결정표(decisions.py) 작성자·근거**: `by`(답한 사람, 필수) · AI 답의 P·N 은 `evidence_ref`+`evidence_quote` 가 기계 확인될 때만 반영(아니면 판정필요 유지) · AI 의 F 는 보수적으로 반영. 원장 tobe_ref = `수동 결정(사람:…)` / `수동 결정(AI·근거 확인)` / `수동 결정(AI·근거 없음)`.
- **결과 봉투 vibe-result/1**(추천 범위 3곳): `Doc/gen/<ID>/E2E_REPAIR.result.json`(독립 판정) · `Doc/gen/<ID>/CHECK.result.json`(check.js) · `Doc/verify/<ID>/run_verify.result.json`(정합검증 실행 — 실패 단계 포함). 짝 모듈 `tools/Harness/lib/envelope.js` ↔ `verify/envelope.py`. 파일 없음·깨짐 = state error(통과 아님). 사람이 읽는 md·xlsx 는 그대로.
- 지시문: 🩹 [4 보고] — (c) 근거는 경로:줄 + 원문 인용 · 🩹 expectPrompt [범위] — 보정 대상 = decision.expectFix 만, 약화 검사 안내 · 🛠️·🧯·🩹 — fixlist status 는 '적용·보류' 까지만(‘검증완료’ 자기 보고 금지), 종결 = close_evidence 의 기계 재판정 또는 사람 판정.
- 백업: workbench.js.bak_20261026 · quick.json.bak_20261026j · 설치 폴더 workbench.js.bak_20261026_pre_judge · verify/*.bak_20261026* · check.js.bak_20261026c
## 1.9.28 (2026-10-23)
- **🔎 화면 정합검증 (AS-IS vs TO-BE → 정합검증서·보완대상목록)**(사용자 지시: 사람이 단위테스트에서 찾은 오류를 시스템이 전부 도출 · 보완 전 목록 Excel · 보완 범위는 환경설정). 정답지 = 결함 원장 310건(공통·DM 285 + SCP·SSP 25, `Doc/verify/defects_baseline.csv`). 오류 정의 = 정답 3종(O1 AS-IS 동작 · O2 확정 규칙 · O3 기능 무결성). 검출 규칙 81(`tools/Harness/verify/detect_rules.csv`) · 확정 규칙 69(`tools/Harness/rules/confirmed_requirements.csv`). 실행기 `tools/Harness/verify/run_verify.py <ID>` = AS-IS 사실 보강(셀 규칙·잠금 전개) → 검증 항목 원장 → E2E `@verify`(원장 구동 · 저장 안 함) → 판정 → `Doc/화면분석서/<ID>_<명>_정합검증서_v<N>.xlsx` + `_보완대상_v<N>.xlsx`. 미검증은 PASS 아님(미검증 시트). 가이드 `Doc/verify/README.md`.
- **🧭 보완 범위 (repairScope)** 환경설정: `DB_ONLY`(기본 — DB 메타·객체만, 화면 FE 는 가이드) / `DB_FE`(화면 FE 까지). 단일 원천 `tools/Harness/harness.json`. 공통 컴포넌트(@shared·@foundation)는 항상 가이드만.
- **🛠️·🧯·🩹 보완 = 보완대상목록 기준**: `Doc/verify/<ID>/fixlist.csv` 를 보완 기준으로 읽고 실행 시점 repairScope 를 따른다(🧯·🩹 의 FE 수정 승인은 DB_FE 일 때만 유효). 🛠️ 는 보완 요청이 비면 fixlist 를 요청으로 삼는다. 처리 결과를 fixlist status·change 에 기록 후 재판정.
- steps.json `S8`(verify · verifyStatic · scope · defects · folder).
## 1.9.27 (2026-10-23)
- **액션 대조표 = 문서 보강 단계**(사용자 지시: 개발된 UI·흐름 무영향): 기존 화면 문서 위치 Doc/gen → `Doc/asisfacts/screens/<AS-IS ID>/__asis-actions__.md`(445화면 생성). 이 문서의 게이트 AC0~AC2 = WARN, BLOCK 은 생성기가 만든 신규 화면 페이지 폴더 대조표만. 작업 컨텍스트 첨부 경로도 변경.
## 1.9.26 (2026-10-23)
- **AS-IS 액션 대조표 연결**(사용자 지시): AsisFacts 액션 추출(actions.csv) → `__asis-actions__.md`(신규 화면 페이지 폴더 / 기존 화면 Doc/gen/<ID>/ — `node tools/Harness/actions-checklist.js <ID>`). 사전 미등록 외부/상속 호출도 행으로(⚠ 의미 확인 필요). 게이트 AC0(없음 WARN)·AC1(미처리 --final BLOCK)·AC2(의미 미기입 --final BLOCK). 작업 컨텍스트에 Doc/gen/<ID>/__asis-actions__.md 자동 첨부. 룰 E11.
## 1.9.25 (2026-10-23)
- **참고자료: SCP·SSP 화면 VALIDATION 취합**(사용자 지시): `Doc/화면분석서/{SCP|SSP}_화면_VALIDATION_취합_<최신>.md`(엑셀 전 시트 텍스트본) + 화면별 `<ID>.md`·`_INDEX.md`. 룰 트리 '룰 문서 · 색인 · 참고자료' 에 전체본·화면별 인덱스 노출(최신 STAMP 자동).
- **검증 작업에 자동 참고**: 작업 컨텍스트(화면 ID 있을 때)와 Claude 프롬프트 작업 지시에 그 화면의 VALIDATION 취합 파일을 첨부. 하네스 — GEN_NOTES §11 · new_screen.md 6-1/6-2 · port_pkg.md 3-1/3-2 · repair-loop/new-screen 지시문 · 게이트 VR1(UI 미적용)/VR2(메시지 TAG 판정 ID 잔존)/VR3(PKG DB 미적용·TAG) — 모두 WARN. 룰 10_RULES_KEEP E10.
## 1.9.24 (2026-10-22)
- **☁️ 클라우드 이관 패키지 2종**(사용자 지시): (전체: FE·BE·PKG·META·MENU) · **(DB)**(PKG·META·MENU, 폴더 `_CLOUD_DB_<날짜>`). 이관 대상 = 이번 작업에서 새로 만들었거나 수정한 것만(수정 없이 쓰는 기존 파일·객체 제외, BE 는 수정된 경우만). 공용 PKG 멤버·standalone PROCEDURE·공용 FE/BE 파일은 이 화면 몫만 추출하고 **파일명 끝 `_<ID>`**(다른 화면 패키지의 공통 파일 덮어쓰기 방지).
- **META 작업에 PROCEDURE 포함**(사용자 지시): 👀 META 미리보기 / ✅ META 커밋 = `tools/DbConn/meta_apply.py` — ① `<ID>_PKG.sql` 을 사내 ALL_SOURCE 와 비교(같으면 생략 · 사내에 없으면 컴파일 · 사내 = 이 파일로 마지막 적용한 상태(`Doc/gen/<ID>/_pkg_applied.json` 지문)면 컴파일 · 그 밖(다른 작업자·직접 수정·사내 현행본)은 **중단**, `--force-pkg` 로만 덮어씀) → ② `registration.sql`(미리보기 ROLLBACK / 커밋 COMMIT). 미리보기는 PKG 를 실행하지 않음(DDL 되돌림 불가). 실측: SCP0122 생성 파일이 사내(10-09)보다 '최신'이지만 740줄 다름 → 시각 비교만으로는 사내 현행본을 덮을 뻔 → 지문 기준으로 강화.
- **파일 = 사내 적용본**(룰 H14): 보완 중 사내 PKG/SP·META 를 고치면 Doc/gen 의 PKG.sql·registration.sql 도 같은 작업 안에서 갱신 — 10_RULES_KEEP.md H14 · 🛠️ 프롬프트.
## 1.9.23 (2026-10-22)
- **메뉴 이름**(사용자 지시): 👀 등록 미리보기 → **META 미리보기** · ✅ 등록 커밋 → **META 커밋** · ↩️ 되돌리기 → **되돌리기(PKG,META,MENU)**.
- **🚚 PKG 배포 삭제 → ☁️ 클라우드 이관 패키지 (PKG·META·FE)**(사용자 승인): PKG 는 작업 중(PKG 이식·🩹/🧯/🛠️ 보완) 사내 ZIOUI1 에 즉시 적용되므로 사내 재컴파일 메뉴는 의미가 작고, 클라우드 이관 묶음을 만드는 메뉴가 없었다. ☁️ = Claude 가 사내 최신 원문(SOURCE-FRESH)으로 PKG·참조 GTT/TYPE·권한·META 7영역·MSG/LBL·콤보·FE 를 추출 → `_artifacts/_deploy_packages/<ID>_…_CLOUD_<날짜>/`(00 점검 → 10 DDL → 20 PKG → 30 META → 40 권한 → 90 검증 → 99 롤백 · B_FE · README) → 사내 리허설(적용 2회·검증·롤백·재적용). 클라우드에 이미 있는 객체는 자기 USER_SOURCE 패치 방식(전체본 교체 금지). 클라우드에는 실행하지 않음. steps.json `S5.pkgdeploy` 도 삭제.
## 1.9.22 (2026-10-22)
- **📝 문서 생성 = MD + Excel 한 번에**(사용자 지시): 📗 문서 Excel 메뉴를 흡수(삭제). 체인(chainId docs) — AS-IS 파싱(없을 때만) → 문서 MD(Agent) → GAP 분석(없거나 비었을 때만) → 대조표 갱신(이 화면 행 없을 때만) → 문서 Excel.
- **체인 단계 `ifMissing`**: 자료가 이미 있으면 그 단계를 ⏭ SKIP, 없으면 "자료 부족(…) → 실행". 항목 = 경로(존재) 또는 { file, minLines, has }.
- **메뉴 이름**: 🧩 새 화면 (from AS-IS) · 📏 새 화면 (from 설계서) → "개발부터 테스트까지".
## 1.9.21 (2026-10-22)
- **FLOW ★ 끝까지**(사용자 지시): 종전엔 `S5.pipeline`(새 화면 생성 7단계)이라 이미 만든 화면에서 '기존 생성분 삭제/중지' 확인창이 떴다. 이제 페이지가 있으면 **🚒 자동 보완 → 테스트·문서까지**, 없으면 **🚀 ID 하나로 전체**(Workbench `flowEnd` · FLOW 독립 패널도 같은 판정 `runFlowEnd`). 버튼 툴팁에 동작 표시.
## 1.9.20 (2026-10-22)
- **🩹 E2E 오류 보완 = 한 번에 끝까지**(사용자 지시: 🔧 기대값 보정 기능을 🩹 에 포함 · 사용자는 오류 상세를 알 필요 없음). 🔧 메뉴 삭제 → 그 지시문은 🩹 의 `expectPrompt`.
  - 메뉴: 종류를 묻지 않고 최근 결과에서 실패한 첫 단계(smoke→crud→auth→authcrud) 자동 선택. Flow 보드 3단계 ① 화면·DB 점검·보완 ② 시험 기준 보정(판정에 기대값 결함이 있을 때만 — 없으면 ⏭) ③ 재시험(통과하면 의존 단계 — CRUD 뒤 권한별 CRUD — 도 이어서). 결과 알림은 "✅ 보완 완료 · 재시험 통과" / "⚠ 보완 후에도 실패 — 한 번 더" 만.
  - 체인: 수선 뒤 판정에 기대값 결함이 있으면(화면·DB 수정 여부와 무관) 시험 기준 보정 → 재실행. 그래도 실패하고 판정이 기대값 결함뿐이면 WARN 으로 계속.
  - 모의 시험 3경우(기대값 결함만 / 화면만 수정 / 보완 후에도 실패) 보드·재시험 순서 확인.
## 1.9.19 (2026-10-22)
- **사고(SCP0122 15:25~15:58)**: 🩹 E2E 오류 보완 → Claude 판정 a=0 b=0 c=1(화면·DB 결함 없음, E2E 기대값 결함) → 고친 것 없이 메뉴가 판정을 무시하고 authcrud 재실행 → 같은 실패 → "보완했는데 오류로 종료". (c) 큐(`Doc/e2e/_expectation_issues.md`)는 쌓이기만 하고 처리 경로가 없었다.
- **🩹 판정 분기**(메뉴): 이번 회차 `판정요약` 을 읽어 a·b 수정이 있으면 재실행 / (c) 만이면 재실행 생략 + ⚠ 안내(🔧 버튼) / 판정요약 없음·회차 불일치면 재실행 생략 + 오류 안내. 공용 `readRepairVerdict`.
- **🔧 E2E 기대값 보정 (Claude)** 신설: (c) 큐를 읽어 tools/E2E 생성기·헬퍼를 일반 규칙으로 보정(화면 FE·DB 수정 금지 · 테스트 약화 금지 · 수행 불가 사이클은 근거 있는 skip/N/A 또는 원천 기반 대체 사이클) → 스펙 재생성 → 끝나면 그 E2E 종류 재실행. 큐 끝 `## 처리 이력` 기록 · `보정요약: fixed= pending=`.
- **체인**: E2E 단계 수선 판정이 (c) 만이면 🔧 를 1회 실행 후 재실행(성공 시 OK) · 그래도 실패면 WARN 으로 계속(16개 단계에 `repair.expectFixOf`).
- **E2E 헬퍼**: `lib/crud.ts` insert 모드 저장 성공 = call-proc 1건 이상(종전 0건도 saved=Y — 판정 오도).
## 1.9.18 (2026-10-22)
- **CRUD 실패 → 권한별 CRUD SKIP**(사용자 지시): 같은 저장 경로라 CRUD 가 실패하면 권한별 CRUD 결과는 의미가 없다. 의존표 `E2E_DEPENDS = { authcrud: 'crud' }`.
  - 🎬 E2E 전체 4단계(runSplitKinds): CRUD 단계가 OK 가 아니면 4단계를 실행하지 않고 ⏭ SKIP(Flow 보드 새 상태 '건너뜀') · 요약에 SKIP 수.
  - 체인(🚀·🧩·📏·🚒): S7.crud 단계가 OK 가 아니면(실패·기대값 결함 WARN 포함) S7.authcrud 단계 SKIP 후 다음 단계(문서)로 진행 · FULLRUN.md 에 사유.
  - `run-e2e.cmd all`: Playwright 1회 전체 실행 → smoke·crud·auth 순차 후 crud exit 0 일 때만 authcrud(아니면 [SKIP] 기록). 파일을 CRLF 로 정리(call 라벨 탐색 안정).
  - 모의 시험: crud 실패 → smoke·crud·auth 실행·authcrud SKIP / crud 성공 → 4단계 모두 실행(Workbench 메서드·배치 둘 다).
## 1.9.17 (2026-10-22)
- **🎬 E2E 전체 4단계 = Flow 보드 4단계**(사용자 지시 "4단계 중 어느 단계인지·무슨 작업인지 안 보임"): 종전엔 `run-e2e.cmd all` 1회 = 1/1 Step 이라 진행이 보이지 않았다. steps.json `S7.all` 에 `splitKinds`(smoke·crud·auth·authcrud)·`splitTitles` → `runSplitKinds` 가 kind 별로 순차 실행(단계 = `E2E n/4 …`). 테스트 실패(exit 1)는 다음 단계 계속, 실행 환경 실패(2 node_modules · 4 다른 E2E 실행 중 · 5 BE/FE 미기동)는 나머지 미실행. kind 마다 계정 확인·권한 메타·스펙 생성이 다시 돌아 단계당 수십 초 더 걸린다.
- **E2E 로그 실시간 표시**: run-e2e.cmd 는 Playwright 출력을 실행별 로그(`Doc/e2e/logs/run_<RUNID>_<kind>.log`)로만 써 화면에 "output goes to the log file" 뿐이었다. stdout 의 `RUNID … - log <path>` 로 파일을 찾아 1초 간격으로 이어 읽어 Task Log(`│` 접두)·단계 카드로 흘린다(UTF-8 청크 경계·ANSI 처리). 체인(🚀·🚒)의 E2E 단계에도 적용.
- **단계 카드 = 테스트별 결과**: 카드 머리 `🧪 완료/전체 · ✅ · ⚠(재시도 후 성공) · ✖`, 카드를 펼치면 테스트 목록(계정·제목·소요시간·재시도 횟수). 진행바도 테스트 완료 비율만큼 진행. 재시도 줄 `(retry #N)`·분 단위 소요시간 `(2.7m)` 처리 — 10-22 SCP0122 실행 로그(12건·재시도 5)로 집계 12/12 · ✅7 · ✖5 · 재시도 5 일치 확인(모의 검증, 웹뷰 실화면 미확인).
- **⬇️🔀 Source Download & Merge**(사용자 지시): ⬇️ Source Download · 🔀 Source Merge 2항목을 1개로. 종전 Merge 는 `git merge --no-ff common/main` 이라 미커밋 566파일·이력 분기(1,207/1,823 커밋) 상태에서 동작 불가였다. 공통소스 다운로드 규칙(메모리 §2 · 회차 README 08-25~10-14)을 `tools/CommonSync/common_sync.py` 로 고정 — 미리보기(파일별 판정) → 확인 → 적용(같은 커밋일 때만) · 백업 · README · 기준선(state.json).
  - 내가 안 고친 파일(공통 이력본과 내용 일치) = 공통 원문 / 내 편집본 = 유지 또는 내 수정분 + 공통 수정분 3-way / 충돌 = 내 소스 유지(결정 대기) / d.ts = 메뉴 키 블록 단위 / locales = 키 단위.
  - 10-14 회차(2dc843467→965d11de5) 재현: 채택 611·신규 146·삭제 26·d.ts 블록 처리·3-way 충돌 수가 README 와 일치. 재현 중 찾은 결함 3건 정정(블록 앞 빈 줄 오판 · 이력 색인의 이전 판본 라벨 · base 선택 기준 — 기준선 base 로는 공통 주석 블록 18줄 유실).
- **📤 Source Upload(UI) — 파일별 '내 작업분'만**(사용자 지시): 종전엔 로컬 파일 전체를 공통 트리에 얹어 공통의 다른 사람 수정분을 덮을 수 있었고, 공통 트리 경로 접두(`nscm-fe/`)도 빠져 루트 `features/` 로 올라가는 결함이 있었다(실제 업로드 이력 없음). 이제 공통 최신을 받은 뒤 파일마다 판정: 신규·공통 무변경 = 전체 / 공통도 바뀜 = 내 수정분만 3-way / `procedures.d.ts` = 이 화면 메뉴 키 블록만 / 동일·내 편집 없음(옛 판본)·충돌 = 제외. 판정표 UPLOAD_PREP.md 탭 · 커밋 트리의 변경 파일 = 준비 파일뿐인지 확인 후 푸시.
  - 업로드 내용 정리: 주석 속 생성기·도구 경로 표기 제거(코드 줄에 남으면 그 파일 제외) · md 는 중립어 치환(줄 유지) · 커밋 메시지·브랜치명 검사.
- 다운로드 적용 안전: 백업을 전부 끝낸 뒤 적용(백업 실패 시 무변경) · Windows 260자 경로 한도 회피.
## 1.9.16 (2026-10-22)
- **메뉴 창 상단 아이콘 순서**(사용자 지시): Workbench 를 맨 앞으로. order 가 없어 앞에 붙던 FLOW·History 포함 전 아이콘에 명시 순서 — Workbench → FLOW → History → 화면 빠른 메뉴 → 대시보드 → 환경 점검 → 새로고침 → 게이트 리포트.
## 1.9.15 (2026-10-22)
- **탭 자동 전환 제거**(사용자 지시): Claude 창을 보는 중 작업 실행·BE/FE 기동·종료·체인 시작·소스 업로드 이벤트가 Log / Task Log / Claude 탭으로 화면을 강제로 옮기던 동작을 없앰. 자동 이벤트(showTab auto:true · Claude 메시지 · Flow 보드)는 보고 있는 탭을 유지.
- **새 내용 표시 'N'**: 보고 있지 않은 탭에 출력·메시지가 생기면 그 탭 헤더에 N 배지(Log = BE/FE 출력 · Task Log = 작업 출력 · Claude = 응답·Flow 보드). 그 탭을 열면 사라짐.
- 사용자가 직접 누른 이동(서버 실패 알림의 'Log 보기' · 히스토리 명령 · 파일/FLOW 탭 열기 · 전송 · 프롬프트 채우기)은 그대로 이동.
## 1.9.14 (2026-10-22)
- **사고(10-21 SSP0015)**: 이미 구현·커밋된 화면(10-14 커밋본 20파일)에 🚀 ID 하나로 전체 를 실행 → 파싱·Agent(18분)·GAP 뒤 `pipeline --phase 1` 이 `gen --apply` 로 가서 "이미 존재" exit 3 으로 중단.
- **원인 ①(pipeline.js)**: 페이지 존재 판정이 `Doc/gen/<ID>/register.json` 기준인데 이 파일은 gen.js 가 만든다 — Doc/gen 이 비어 있으면 "페이지 없음"으로 오판해 보호 분기(touchReason)를 건너뜀. → 판정 전에 Doc/gen 만 생성(--apply 없음)해 위치를 확정. 같은 조건 재현 시 `Doc/gen 만 — 페이지 보존` exit 0, 페이지 무변경 확인.
- **원인 ②(체인)**: 새 화면 체인이 시작 전에 기존 생성분을 확인하지 않음. → **기존 생성분 확인창**(사용자 지시): quick.json 체인 `newScreen:true`(🚀 전체 · 🧩 from AS-IS · 📏 from 설계서) · steps.json `S5.pipeline`/`S5.pipelinedesign`/`S5.new` 실행 시 페이지(register.json ∪ To-Be 메뉴 MNU_URL ∪ __asis-mapping__.md 의 ID)가 있으면 **[⏹ 중지 / 🗑 기존 삭제 후 신규 생성]**. Esc·닫기 = 중지. 삭제는 페이지 + Doc/gen/<ID> 를 `Doc/gen/_backup/<ID>/<시각>/` 에 백업 후 수행. 체인은 첫 단계 전에 묻는다. 워크벤치 없는 터미널 fallback 에서는 새 화면 작업 실행 차단.
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
## 1.9.13 (2026-10-21 밤)
- **🛠️ 기존 화면 보완(Claude · 골격 재생성 금지) — 입력 전에 실행되던 문제**(사용자 신고): 종전엔 메뉴 선택 즉시 준비 턴이 Claude 로 전송되고 그 뒤 채팅으로 요청을 받는 2단 구조라 수정 내용을 적을 틈이 없었다. 이제 quick.json `prefill: true` 항목은 **전송하지 않고 채팅 입력창에 프롬프트를 채워 두며**(웹뷰 `prefill` 메시지 → textarea·커서 끝), 사용자가 맨 아래 `[보완 요청]` 에 내용을 적고 보내야 실행된다. 프롬프트도 "[보완 요청] 이 비어 있으면 작업하지 않는다" 로 정리. 모의 테스트 4/4(Claude 미실행·입력창 채움).
## 1.9.12 (2026-10-21 밤)
- **E2E 전체 진단**(사용자: "E2E 에서 계속 오류가 나며 멈춘다"): 10-21 smoke 14회 중 실패 원인은 ① 생성기 기대값(조회조건 카탈로그·As-is 숨김·조건부 컬럼) ② 헤더 사양 검사 신설 직후 측정 결함(행 높이·총 높이) ③ 수선이 만든 런타임 단언 1건. 🩹 판정 12건 중 **(c) 기대값/측정 결함 9건** — 즉 체인이 멈춘 주원인은 화면이 아니라 **도구 기대값**이었고, 체인은 (c) 를 고칠 수 없어 FAIL 로 끝났다.
- **보완**: 🩹 프롬프트가 섹션 끝에 `판정요약: a= b= c=` 를 쓰고 (c) 항목을 `Doc/e2e/_expectation_issues.md`(도구 보정 큐)에 append. 체인은 수선 뒤 이 줄을 읽어 **(c)만 남으면 재실행을 생략하고 단계를 WARN 으로 넘겨 계속 진행**(FULLRUN 행에 사유 · Task Log/Claude 탭 안내). (a)/(b) 가 남아 실패하면 종전대로 FAIL 중단. 모의 테스트 27/27.
- **E2E 헬퍼 측정 정정**: `gridHeaderRows` 행 높이 = 그 행의 가장 낮은 셀(고정 컬럼 세로 병합 셀 제외) · 총 높이 = 셀 top~bottom 실측. SCP0100 smoke **12/12 PASS**(월 20 / Qty 40 · Qty 월별 분리 · 콘솔 치명 0).
## 1.9.11 (2026-10-21 저녁)
- **체인이 E2E smoke 단계에서 조용히 종료된 사고(19:28 SCP0100 🚒)**: smoke FAIL → 🩹 수선 2 호출 시점에 Claude 가 사용자의 채팅 질문("진행중인가요?", 19:26)에 응답 중이라 `askClaude` 가 null → 단계 CANCEL → 체인 종료. 수정: 체인의 Claude 단계·수선은 **Claude 가 빌 때까지 기다렸다가 진행**(`askClaudeWhenIdle`, 최대 60분, Task Log/Claude 탭에 ⏳ 대기·▶ 재개 안내) · CANCEL 사유를 FULLRUN 에 기록. 모의 테스트(Claude 점유 3초 뒤 해제 → 7단계 완료) 포함 24/24.
- **🩹 수선 1 이 화면을 깨뜨린 사고(Wijmo "Unknown property inner")**: 수선이 만든 커스텀 MergeManager 에 인스턴스 필드(`private inner = null`)가 있어 DataGrid `mergeManager` prop → Wijmo `copy()` 재귀 복사 단언 → 그리드 생성 실패(화면 빈 화면, smoke 라벨 0/15). 게이트 없음이 원인 → check.js **H06**(props 로 넘기는 MergeManager 클래스에 인스턴스 필드 → BLOCK, WeakMap/클로저 지침) · 룰 D4 보강 · E2E smoke **브라우저 콘솔 오류 수집**(`console` 어노테이션, Assertion/Uncaught 는 FAIL) · 🧯 프롬프트 "FE 고친 뒤 화면 열어 콘솔 오류 0 확인". SCP0100 대조표 D00-6-005 에 원인·처리 지침 추가. check.js --final: H06 BLOCK 1 → 🧯 처리 대상.
## 1.9.10 + 하네스/E2E 보강 (2026-10-21 오후 · tools/Harness·tools/E2E·quick.json 프롬프트·rules — 확장 재빌드 불필요)
- **SCP0100 "그리드 헤더 다단·높이, 라디오→드롭다운, Plan Type 비활성, 체크박스 묶음, Column Setting 모달 빈 목록" 대조표 등록/구현 확인 요청** 결과: 헤더(D00-6-005)·모달(D00-1-018/D00-2-015/MODAL) 행이 '구현' 인데 라이브 실측과 불일치(헤더 144px 한 칸·'Qty' 행 없음 / 모달 "No Column" — fallbackColumns 미전달), 체크박스 묶음 배치는 미등록. 사용자 지시 "사전 조치 2개(대조표 정정·처리 지침)를 앞으로는 자동 적용 + 지금 적용".
- **자동 적용(앞으로)**: check.js **H01**(headerRowHeight + 동적 컬럼인데 `updatedLayout` 재적용 없음 → BLOCK, 지침 포함) · **H02**(ColumnLayoutModal fallbackColumns 없음 → BLOCK) · **M06 보정**(비고에 'YYYY-MM-DD 실측 정정' 표식이 있는 구현→부분 하향은 후퇴로 세지 않음 — 정정 때문에 🧯 가 멈추지 않게) · gen-e2e `headerSpec`(As-is `SetSheetHeaderColumn N`·`ColumnHeaderSpan "리터럴"` 추출) + smoke `header` 어노테이션(행 수 ≥ N · 리터럴 노출 · 높이 ≤ 32px×N, nscm.gridHeaderRows) · 10_RULES_KEEP 헤더/모달 파리티 규칙 · 🧯/🩹 프롬프트 진단 항목 추가.
- **지금 적용(SCP0100)**: 대조표 D00-6-005·D00-1-018·D00-2-015·MODAL 행 '구현'→'부분' + 처리 지침(leaf 'Qty' 고정 · updatedLayout 재적용 · fallbackColumns) · 신규 행 D00-7-017(체크박스 한 영역 배치)·D00-7-018(라디오 RadioGroup 복원, 카탈로그 삭제 결정 시 제외) · D00-1-002 '규칙 정정'(부분). check.js --final: H01·H02·H03·H04·M04×2 BLOCK 6 → 🧯 실행 시 처리 대상.
- **헤더 Qty 분리·행 높이 역전**(사용자 지적, 🧯 1차 보완 뒤 실측: 월 칸 h48(행 0~1 병합) / Qty 행 h24 · Qty 가 전 월에 걸쳐 1칸(w910) 가로 병합 — As-is 는 월 행 20 / Qty 1~2행 병합 40~50 · 월마다 Qty 분리): 룰(상단 그룹 칸이 분리되면 하단 리터럴 칸도 분리 · 그룹 행 20 / leaf 행 40 · 월간 2행·주간 3행) · check.js **H05**(동적 그룹 헤더인데 allowMerging 기본/All → 최종 BLOCK, AllowMerging.Cells 또는 mergeManager 헤더 제외 지침) · E2E smoke header 검사 확장(리터럴 칸 수 ≥ 상단 동적 칸, leaf 행 높이 ≥ 상단 행) · SCP0100 D00-6-005 '규칙 정정' 부분 + 지침. 체크박스/라디오 배치는 Box 영역(FormItem 라벨 공란) — 사용자 결정.
- **체크박스·라디오 디자인 룰**(사용자 지시): 10_RULES_KEEP — ① 조회조건 체크박스는 한 Grid 칸의 customCheckbox 컨테이너에 모아 나란히(기준 DMF0082 MktFcstForm:424-440) `G:H03` ② As-is RadioGroup/UsrRadio/RadioButton 은 `@shared/lges` `RadioGroup`+`Radio(labelText)` 로(lges.ts 가 design-system radio 를 재export — "공용 RadioGroup 부재" 는 오판) 드롭다운 대체 금지, 카탈로그 '조회조건 삭제' 만 매핑표 '제외' `G:H04`. check.js H03/H04(최종 BLOCK) · M06 정정 표식 '실측|규칙 정정' · 🧯 진단 항목. 기준 화면 DMF0082 에 H01~H04 오탐 0.
## 1.9.10 (2026-10-21)
- **"🩹 E2E 오류 보완을 지시했는데 오류 지속" 원인 2가지 보완**: ① 메뉴에서 직접 실행하면 `${kind}/${round}/${step}` 이 치환되지 않은 채 Claude 에 전달됐고(수선 기록 15:38), 끝나도 E2E 를 다시 돌리지 않아 결과가 그대로였다 → 종류 QuickPick(기본 = 최근 FAIL 종류) · round = E2E_REPAIR.md 수선 수+1 · 수선 뒤 `S7.<kind>` 자동 재실행(mode auto, 입력 없음, quick.json `afterTask`). ② 수선 세션이 실패 4건을 전부 "(c) 기대값 결함" 으로 판정했는데 실제로 생성기 원천이 부족했다 → gen-e2e 에 권위 원천 3종 추가: 조회조건 카탈로그(`Doc/_rules_v2/_mapping/search_conditions*.md` To-Be 명칭 Project→PJT·Unit (Qty)→Unit·'조회조건 삭제'=제외) · As-is designer `Visibility = Never`(Display 등) = 검사 제외 · Fact Pack grid_code SetLayout/VisibleColumns 컬럼(Product Level1~3) = 조건부 표시로 누락 제외. SCP0100 smoke 재실행 PASS(일치 15/누락 0, 12/12 전체 PASS).
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
