# MD · Hook · Rule · 하네스 전수 점검과 정리안 (2026-11-13)

> 측정: 2026-11-13 14:46 ~ 14:58 (이 PC · `date` 실측). 수치는 전부 이번 측정 결과이며 출처(스크립트·명령)를 함께 적었다.
> 상태: **정리안 제시 단계 — 아직 아무것도 고치거나 지우지 않았다.** 적용은 §5 의 승인 묶음별로 사용자 확인 뒤에만 한다.
> 재측정 스크립트(임시 폴더): `inv_tools.py`(도구 참조) · `inv_vm.py`(VM 작업·메뉴·체인) · `inv_hooks.py`(문서 hook 카탈로그) · `inv_paths.py`(경로 참조·.bak) · `inv_coderefs.py`(코드의 파일 참조). 승인되면 `scripts/rules/` 로 옮겨 상시 도구로 둔다(§4 N-01).

## 1. 인벤토리 (분모와 분류)

분류 뜻: **현행** = 연결돼 쓰임 · **보완** = 쓰이지만 내용이 실제와 다름 · **미등록** = 파일은 있는데 진입점·카탈로그에 없음 · **깨진 참조** = 가리키는 대상이 없음 · **폐기 후보** = 대체됐거나 일회성.

### 1-1. 진입 문서 · 실행 hook

| 영역 | 분모 | 현행 | 보완 | 미등록 | 깨진 참조 | 폐기 후보 | 출처 |
|---|---:|---:|---:|---:|---:|---:|---|
| `CLAUDE.md` | 1 | 0 | 1 (hook 수 153 표기 · §5 에 하네스 hook 3종 없음) | – | 0 (경로 18 중) | 0 | inv_paths · inv_hooks |
| `.claude/rules/*.md` | 4 | 4 | 0 | – | 0 (경로 32 중 실제 대상 없음 0 · 자리표시 2건은 예시 문구) | 0 | inv_paths |
| `.claude/commands/*` | 1 | 0 | 1 (예시 파일 `Doc/단위테스트/SCP0007_BOD_TestCases4_v2.0.xlsx` 없음) | – | 1 | 0 | inv_paths |
| `.claude/settings.json` 실행 hook 연결 | 13 | 13 (가리키는 ps1 13/13 실재) | 0 | – | 0 | 0 | 파일 판독 |
| `.claude/hooks/*.ps1` | 10 | 10 (전부 settings 연결 · 구문 검사 10/10 OK) | 0 | 0 | 0 | 0 | verify_hooks.ps1 1단계 14:53 |
| `.claude/hooks/*.sh` | 5 | 0 | 0 | 5 (Windows 연결 없음 · `attach-context.sh` 는 구 v2 로직이라고 README 가 명시) | 0 | 0 | 파일 판독 |
| `.claude/hooks/README.md` | 1 | 0 | 1 (제목 "9 스크립트 / 10 wiring" ↔ 실측 10 스크립트 + 하네스 3 = 13 연결 · 끝줄 "(69)") | – | 0 | 0 | inv_hooks |
| `tools/Harness/hooks/*.ps1` | 3 | 3 (settings 연결) | 0 | 0 (`CLAUDE.md §5`·hooks README 에는 미기재) | 0 | 0 | grep |

### 1-2. 문서 hook · 룰 카탈로그

| 항목 | 실측 | 문서 표기 | 차이 |
|---|---:|---|---|
| `Doc/_rules_v2/hooks/*.md` (분모) | **156** | – | – |
| `RULESET_MASTER §4` 표 행 | 151 | 상단 "155" · §4 헤더 "전체 142" · §4 주석 "123" · 말미 "125" | 표에 행 없는 hook 5 · 수치 4곳 서로 다름 |
| `RULESET_MASTER` 본문 어디든 언급 | 155 | – | 미언급 1 = `ui-mandatory-12-behaviors` |
| `00_INDEX.md` 언급 | 155 | 머리 "155" · 38행 "142" · §B.3 헤더 "144 (+ Retracted 1)" | 미언급 1(같은 파일) · 수치 3곳 서로 다름 |
| `_categories/00_CATEGORY_MAP.md` 언급 | 151 | – | 미등재 5 |
| `tools/VibeManager/rules/30_HOOK_DISPOSITION.csv` | 154행 | – | 미등재 2 (`search-area-bulk-input-button-popup` · `search-condition-labelless-toggle-input-column`) |
| `TRIGGER_ROUTER.md` 언급 | 95 | 사용법 5 "142+ hook" | 수치 다름 (출처 `scripts/rules/build_router.py:58` 고정 문구) |
| `CLAUDE.md §3` | – | "hook 한 줄 요약 153종" | 수치 다름 |
| `.claude/hooks/README.md` | – | "문서 hook 153종" · "(69)" | 수치 다름 |
| `build_router.py --check` | rc 1 | "disk=156 MASTER상단=155 MASTER§4헤더=142" | 기존 점검 도구도 같은 어긋남을 보고 (14:53) |

- §4 표에 행이 없는 5개: `screen-modal-cascade-filter-analysis`(#123) · `msg-table-cloud-sync-and-insert-only`(#140) · `wijmo-merge-row-data-only`(#141) · `asis-db-live-connection-mandatory`(#151) · `ui-mandatory-12-behaviors`.
- **번호 충돌 1건**: `ui-mandatory-12-behaviors.md` 제목은 "Hook #149" 인데 MASTER §4 의 #149 는 `remediation-closure-symptom-reproduction`.
- CATEGORY_MAP 미등재 5: `asis-db-live-connection-mandatory` · `db-source-refresh-before-work` · `dept-id-derivation-standard` · `pinpoint-request-scope-first` · `ui-mandatory-12-behaviors`.
- 깨진 참조: `hooks/<이름>.md` 형태 참조 중 파일 없는 것 0 · 라우터 핵심 Hook 열 토큰 99 중 파일 없는 것 1 = `figma-mapping-check`(표에 "v1" 로 표기된 것).
- 2026-10-23 #155 이후 새 문서 hook 은 없고, 그 뒤 룰은 `confirmed_requirements.csv`(CR-001~103)로 들어갔다(§2-4).

### 1-3. 룰 문서 폴더

| 위치 | 파일 수 | 분류 |
|---|---:|---|
| `Doc/_rules_consolidation/*.md` | 9 | 현행 4(`RULESET_MASTER`·`TRIGGER_ROUTER`·`UI_MANDATORY_CHECKLIST`·`00_DIAGNOSIS`[README·MASTER 가 참조]) · 코드가 읽음 2(`TOBE_RULES_DEV`·`TOBE_RULES_DIFF` ← `tobe_rule_registry.py`) · 참조 0 인 것 2(`PROMPT_TEMPLATES.md` 06-18 · `2026-10-12_RULE_HOOK_RESTRUCTURE.md`) · 이 문서 1 |
| `Doc/_rules_consolidation/_claude_hooks_staged/` | 5 | 폐기 후보 — 10-12 재편 때의 대기본. `.sh` 2개는 현행과 동일, `attach-context.ps1` 은 현행(11-05)보다 옛 판(06-18) |
| `Doc/_rules_v2/` 최상위 md | 8 | 현행 3(`00_INDEX`·`anti-simplification`·`meta-rule-evolution`) · 참조 0 인 과거 보고서 4(`FINAL_REPORT`·`PHASE7_FINAL_REPORT`·`SCM_4SCREENS_PLAN`·`SESSION_2026-06-04_HANDOVER`) · 구판 1(`CLAUDE.md` 07-03 — 없는 경로 4건 · MASTER·INDEX·진단보고서가 언급) |
| `Doc/_rules_v2/_archive_be_phase6_wrong/` | 6 | 폐기 후보(참조 0) |
| `Doc/_rules_v2/_categories/` | 13 | 현행(맵 1 + 카테고리 12) |
| `Doc/_rules_v2/_asis · _tobe · _dictionary · _mapping` | 26 · 15 · 4 · 4 | 현행(라우터 필독 룰 열이 가리킴) — 본문 내용은 이번에 검토하지 않음 |
| `Doc/_dev_rules/` | 70 | 현행(라우터 T10~T16 이 가리킴) — 본문 미검토 |
| `Doc/_archive/` | md 7 + 폴더 2(12 · 48) | 보관소 그대로 |

### 1-4. 하네스 · VM · 도구

| 영역 | 분모 | 진입점 직접 참조 | 다른 코드에서만 참조 | 어디서도 참조 없음 | 출처 |
|---|---:|---:|---:|---:|---|
| 도구 파일 전체(18 폴더 · .bak 제외) | 262 | 147 | 69 | **46** | inv_tools |
| 그중 `tools/Harness/verify/*.py` | 139 | – | – | 21 | 같은 출력 |
| 그중 `tools/AsisLive` | 15 | – | – | 2 (`asis_live_winwatch.py` · `backfill_calls.py`) | 같은 출력 |

진입점 = `run_verify.py` · `steps.json` · `quick.json` · VM js · `.claude/settings*.json`.

| VM 항목 | 실측 | 비고 |
|---|---:|---|
| `steps.json` 단계 / 작업 | 8 / 107 | 중복 id 0 · 가리키는 script·path·prompt 없는 것 **0** |
| `quick.json` 그룹 / 항목 / 체인 | 5 / 75 / 6 | 중복 라벨 0 · 없는 작업 id·라벨·경로 참조 **0** |
| 체인 단계 수 | testreport 3 · docs 6 · full 18 · new-asis-full 16 · new-design-full 14 · autofix-full 9 | CHANGELOG 2.0.7 기록과 일치 |
| 메뉴·체인·VM js 어디에도 없는 작업(Flow 패널 단계 목록에서만 보임) | 52 / 107 | 대부분 열기·보조 작업 |
| VM js 가 참조하는데 `steps.json` 에 없는 작업 id | 2 | `history.js` 의 `S4.one` · `S5.pkgdeploy` |
| `package.json` version ↔ CHANGELOG 최신 | 2.0.1 ↔ 2.0.8 | `dist/` 최신 vsix 도 2.0.1 (vsix 69개 · 9.7MB) |
| 코드가 문자열로 가리키는 스크립트 파일명(236 파일 · 230 참조) | 없는 이름 3 | `claude.cmd`(외부 CLI) · `x.py`(자기 시험 예시) · `ora.py`(`_artifacts/_diagnostics/ora.py` 로 실재) → 실제 깨짐 **0** |

### 1-5. 백업(.bak) · 메모리

| 영역 | .bak 수 | 크기 | 14일 넘은 것 |
|---|---:|---:|---:|
| 대상 16개 위치 합계 | **440** | 39.4MB | **137** |
| 큰 곳: `tools/VibeManager` 136(12.4MB) · `tools/Harness` 141(6.1MB) · `Doc/e2e/specs` 29(13.3MB) · `tools/E2E` 54 · `tools/AsisLive` 15 · `Doc/verify`(최상위) 12 · `Doc/_rules_v2` 12 · `.claude` 9 | | | |
| git 이 추적 중인 .bak | 376 | – | `.gitignore` 에 .bak 규칙 없음 |

| 메모리 | 실측 |
|---|---:|
| md 파일 | 576 |
| `MEMORY.md` | 22,815 bytes · 113줄 · 링크 121(고유 109) · 깨진 링크 0 |
| `_index_bundles.md` | 50,420 bytes · 276줄 · 링크 404(고유 399) · 깨진 링크 0 |
| 어느 색인에도 없는 파일 | **70** |
| 중복 등재 | MEMORY 안 1(`project_asis_live_plan_20261112.md` 2회) · 양쪽 모두 2 · bundles 안 5 |
| frontmatter 없는 파일 | 2 (`project_sdm1020_status.md` · `project_sdm5010_status.md`) |

## 2. 하네스 순차 반영 대조표 (최우선)

### 2-1. `run_verify.py` 단계별 실제 실행 수 ↔ `STAGES` 예정 수

실제 수 = 코드의 `run()` + 건너뜀 `sub()` 를 줄 단위로 센 값(파일 수정 시각 11-13 14:32).

| 단계 | STAGES 예정 | 실제 | 일치 | 근거 |
|---|---:|---:|---|---|
| pre | (prereq 가 냄) | – | – | |
| facts | **14** | **15** | ✗ | `facts_defcols` 1 + 반복 9 + `facts_popup_meta` · `facts_append_tables` · `gen_expect` · `scenario_env` · `ledger`. 실행 로그 3개에 `[WARN] 진행 표시 — 단계 2 세부 실행 15 ≠ 예정 14` (`.vibe/logs`) |
| static | 10 | 10 | ✓ | |
| e2e | 0 | – | – | Playwright 테스트 수 |
| eg | 1 | 1 | ✓ | `eg_chain.py`(안에서 facts_popup · facts_popup_meta · eg_popup · facts_popup_golden · facts_auth · eg_auth · facts_auth_combo) |
| diff | 7 | 7 | ✓ | sqllog_calls · gen_param_map · diff_verify · diff_ingest · **asis_live_auto · asis_live_screen --after-basic · asis_live_ingest** |
| post | 31 | 31 (일반) / **30 (`--static`)** | 일반 ✓ · `--static` ✗ | `--static` 분기는 `a1_live` 만 건너뜀 표시하고 `asis_live_rows` 건너뜀 표시가 없다(526~530행). `--static` 실행으로 직접 재지는 않음(코드 판독) |
| docs | 4 | 4 | ✓ | |

- 판정에는 영향 없다(진행 표시 분모만 어긋남 — 코드 주석에 명시).
- 머리말 주석의 "순서" 목록에 eg · 차등 검증(diff) · AS-IS Live · 사후 검사 30여 개가 없다(10-26 무렵 내용).

### 2-2. AS-IS Live 도구(11-12~13 추가) 반영 여부

| 도구 | 체인(`run_verify`) | VM 작업 | VM 메뉴 | `_ENGINE_MASTER` | VM CHANGELOG | 변경 게이트(`engine_selfcheck`) |
|---|---|---|---|---|---|---|
| `verify/asis_live_auto.py` | diff ✓ | – | – | ✓ | – | ✓(verify 폴더) |
| `verify/asis_live_ingest.py` | diff ✓ | – | – | ✓ | – | ✓ |
| `verify/asis_live_rows.py` | post ✓ | – | – | ✓ | – | ✓ |
| `verify/asis_live_doc.py` | (문서 도구가 import) | – | – | ✓ | – | ✓ |
| `AsisLive/asis_live_screen.py` | diff ✓ | `S1.liveScreen` ✓ | ✓ | ✓ | **✗** | **✗** |
| `AsisLive/asis_live_run.py` | (auto 가 부름) | `S1.live` ✓ | ✓ + 체인 5종 | ✓ | ✓ | ✗ |
| `AsisLive/asis_live_batch.py` | – | `S1.liveFill` ✓ | ✓ | ✓ | ✓ | ✗ |
| `AsisLive/asis_live_cond.py` | (rows 가 import) | `S1.liveCond` ✓ | ✓ | ✓ | ✓ | ✗ |
| `AsisLive/asis_live_scen_loop.py` | – | `S1.liveScen` ✓ | ✓ | (scen 으로 언급) | ✓ | ✗ |
| `AsisLive/asis_live_scen_src.py` | (screen 이 부름) | `S1.liveScenSrc` ✓ | ✓ | ✓ | ✓ | ✗ |
| `AsisLive/asis_live_scen_cov.py` | (screen 이 부름) | `S1.liveScenCov` ✓ | ✓ | ✓ | ✓ | ✗ |
| `AsisLive/asis_live_scen_run.py` | (screen 이 부름) | `S1.liveScenRun` ✓ | ✓ | ✓ | ✓ | ✗ |
| `AsisLive/asis_live_scen.py` · `asis_live_fill.py` · `asis_live_excel.py` · `excel_guard.ps1` | 다른 AsisLive 도구가 import | – | – | 일부 | – | ✗ |
| `AsisLive/probe.py` | – | – | – | – | ✓(언급) | ✗ |
| `AsisLive/asis_live_winwatch.py` · `backfill_calls.py` | **참조 0** | – | – | – | – | ✗ |
| `AsisLocal/asis_env_check.py` | – | `S1.liveCheck` ✓ | ✓ | – | ✓ | ✗ |

- 체인·작업·메뉴 누락은 **없다**. 빠진 것은 ① CHANGELOG 에 `S1.liveScreen` 과 체인 편입(asis_live_auto·screen·rows) 기록 ② 변경 게이트의 감시 범위 ③ 한곳에 모인 안내 문서.
- 변경 게이트 `PY_GLOBS` = `tools/Harness/verify/*.py` · `tools/DbConn/*.py` · `tools/Harness/*.py` 뿐이다. 체인이 직접 부르는 `tools/AsisLive/asis_live_screen.py` 와 문서 단계가 import 하는 `tools/Docs/*.py` 는 고쳐도 게이트가 보지 않는다. 지금 그 범위(AsisLive·Docs·AsisLocal)를 같은 검사 함수로 재면 컴파일 오류 0 · 미정의 이름 0 (14:57 실측) → 감시 범위에 넣어도 현재는 통과한다.
- 안내 문서: `CLAUDE.md` · `.claude/rules` · `tools/Harness/README.md`(10-26) · `tools/VibeManager/README.md`(10-19) · `CONCEPT.md`(10-16) · `10_RULES_KEEP.md` · `tools/E2E/README.md` 에 AS-IS Live 언급 0건. 내용은 `_ENGINE_MASTER.md` 의 작업 로그와 CHANGELOG 에만 있다.

### 2-3. 어디서도 참조되지 않는 도구 46개

| 묶음 | 수 | 파일 | 제안 |
|---|---:|---|---|
| 손으로 돌리는 현행 도구(머리말에 사용법 있음 · 11월 수정) | 17 | `save_diff` · `keyset_guard` · `repair_plan` · `repair_apply` · `backlog_types`(→`proof_backlog`) · `feature_inventory` · `guess_scan` · `tobe_rule_registry` · `judge_popup_selftest`(자체 점검이 `--selftest` 형태로 자동 수집) · `dict_sweep` · `timing_report` · `gap267_setprice_run` · `tools/E2E/lint_tpl_regex.py` · `tools/AsisLive/asis_live_winwatch.py` · `backfill_calls.py` · `tools/Env/msys-repair.ps1` · `scripts/rules/verify_hooks.ps1` | 유지 + 도구 등록부(§4 C-01)에 등재 |
| 10월 도구 — 지금 쓰는지 이번 측정으로는 알 수 없음 | 11 | `decisions` · `engine_audit` · `engine_gap_cluster` · `engine_gap_merge` · `facts_auth_db` · `facts_popup_accounts` · `run_docs_batch` · `snap_parallel` · `tools/E2E/extract-role-users.py` · `tools/AsisFacts/datasets.py` · `links.py` | 유지(사용자 확인 뒤 분류) |
| 대체됨 | 1 | `cr_harness_gap.py`(10-28 · 산출물 `_cr_harness_gap.md` 10-29) → `tobe_rule_registry.py`(11-11)가 같은 현황을 냄 | 보관 이동 |
| 환경 구성 자료(AS-IS 로컬 실행) | 7 | `tools/AsisLocal` 6 · `tools/CommonSync/be_sso.init.gradle` | 유지(CHANGELOG 에 기록 있음) |
| 일회성·특정 화면용 | 6 | `tools/Harness/harness_DMF0052_step1.cmd` · `step2.cmd` · `tmp_strip_asis.js` · `tools/AsisFacts/agent_DMF0052.cmd` · `grid.cmd` · `actions_dict.json` | 앞 4개 보관 이동 · 뒤 2개는 확인 필요 |
| VM 이전 수동 실행 묶음(Harness README 가 언급) | 4 | `harness_pipeline.cmd` · `harness_pkg.cmd` · `harness_repair.cmd` · `install.js` | 유지 |

추가(분모 밖 · `tools/` 최상위): `batch_B.cmd` · `batch_B2.cmd`(10-19) · `_vm_dev_backup_20261016.tgz`(0.4MB) = 일회성.

### 2-4. 확정 룰(CR) → 하네스 반영

출처: `tobe_rule_registry.py --check` 14:55 실행(rc 0) + `tobe_rule_registry.csv`(11-12 14:53 생성본).

| 항목 | 실측 |
|---|---|
| 룰 원장 | 344행 = CR 103 · DD 219 · AG 21 · SPR 1 |
| `confirmed_requirements.csv` | 103행 · CR-001~103 결번 0 · 원장 미등재 0 · 종류 미지정 0 |
| 코드에는 있는데 원장에 없는 룰 번호 | 0 |
| CR 이 원장(ledger) 판정 행으로 들어가는가 | 103/103 |
| CR 중 코드에 강제 지점이 없는 것(NO_ENFORCER — 사후 판정 행으로만 존재) | **68** |
| CR 중 생성 단계 미연결(GEN_UNLINKED) | 13 · 연결됨(OK) 22 |
| CR `harness` 열이 빈 것 | 81/103 |
| 규칙 ID 축: `detect_rules.csv` 94 ↔ `_oracle_class.csv` 104 | detect 에만 있는 것 0 · 분류 마스터에만 10(`LB1`·`LB2`·`SC2`·`K-SA`·`G03-WIRE`·`X-*` 5) |
| `rule_applicability.csv` / `fix_recipes.csv` 에 있는데 `detect_rules.csv` 에 없는 규칙 | `LB1`·`LB2`·`SC2` / `LB1` |

- 등록 자체의 누락은 0 이다. NO_ENFORCER 68 은 기존에 추적 중인 항목(원장 문서의 EN-11 전환 대상)이며 이번 정리 범위(등록·문서 정합) 밖이라 수치만 싣는다.
- `tobe_rule_registry.py --check` 는 어떤 체인·게이트에도 연결돼 있지 않다(손으로 실행).
- `detect_rules.csv`(94) · `mapping_checkdefs.csv`(101)의 각 규칙이 실제 검사 코드로 구현됐는지는 `engine_audit.py` 의 일이며 이번에 돌리지 않았다(미측정).

### 2-5. 기존 점검 도구 상태

| 도구 | 결과(시각) |
|---|---|
| `engine_selfcheck.py --quick` | PASS — PY_COMPILE 0 · PY_UNDEF 0 · CTRL_CHARS 0 · JS_SYNTAX 0 · SPEC_SIZE 0 (14:53 · 4.5초) |
| `scripts/rules/build_router.py --check` | rc 1 — hook 수 어긋남(§1-2) |
| `scripts/rules/verify_hooks.ps1` | 1단계 구문 10/10 OK · **2단계 판별 3건 FAIL · 3단계에서 중단(4·5단계 미실행)**. 같은 3건을 PowerShell 7 에서 직접 넣으면 3건 모두 FULL(14:53) → hook 결함이 아니라 점검 스크립트가 Windows PowerShell 5.1 에서 한글 입력을 넘기지 못하는 것으로 보이나, 5.1 쪽 인코딩 값은 직접 재지 않았다(미측정) |

## 3. 깨진 참조 목록(실제 대상 없음)

| 위치 | 가리키는 것 | 비고 |
|---|---|---|
| `tools/VibeManager/history.js` | 작업 id `S4.one` · `S5.pkgdeploy` | steps.json 에 없음 — 계층 표시 매핑의 남은 키(동작 영향 미확인) |
| `tools/Harness/README.md` | `Doc/e2e/_human_review.md` | 파일 없음(코드 `e2e-judge.js`·`workbench.js` 도 이 이름을 씀 — 실행 때 생성되는 파일일 수 있음 · 미확인) |
| `.claude/commands/단위테스트.md` | `Doc/단위테스트/SCP0007_BOD_TestCases4_v2.0.xlsx` | 예시 파일 없음 |
| `tools/VibeManager/rules/10_RULES_KEEP.md` | `framework/spreadinfo_defaults.csv` | 기준 폴더 불명 — 미확인 |
| `Doc/_rules_v2/CLAUDE.md`(구판) | `hooks/anti-simplification.md` · `C:/Users/ejene/.claude/plans/…` 외 2 | 구판 문서 |
| `TRIGGER_ROUTER.md` T11 | `figma-mapping-check` | "v1" 표기 — hook 파일 없음 |

현행 문서 26개의 경로 참조 240건 중 "없음" 은 24건이고, 위 표에 올린 것 외에는 `dto/`·`sp/`·`kebab-case/` 같은 예시·자리표시이거나 있어도 되고 없어도 되는 덮어쓰기 경로(`.vibe/steps.json`·`.vibe/quick.json`)였다.

## 4. 정리안

구분: **보완**(고침) · **통합**(한곳으로) · **이동**(`Doc/_archive/` — 삭제 아님) · **삭제** · **유지**. 공유 파일(`run_verify.py`·`steps.json`·`quick.json`)은 고치기 직전에 다시 읽고 백업 후 최소 변경.

### A. 하네스 순차 반영 (최우선)

| ID | 대상 | 조치 | 내용 |
|---|---|---|---|
| A-01 | `run_verify.py` STAGES | 보완 | `facts` 14 → 15 (1줄) |
| A-02 | `run_verify.py` `--static` 분기 | 보완 | `sub('asis_live_rows.py', '--static…')` 1줄 추가 → post 31 일치 |
| A-03 | `run_verify.py` 머리말 "순서" | 보완 | eg · 차등 검증 · AS-IS Live 3종 · 사후 검사 묶음을 현재 단계 순서대로 적음(주석만) |
| A-04 | `engine_selfcheck.py` 감시 범위 | 보완 | `PY_GLOBS` 에 `tools/AsisLive/*.py` · `tools/Docs/*.py` 추가(현재 그 범위 오류 0). AsisLive 코드 자체는 건드리지 않음 |
| A-05 | `engine_selfcheck.py` 전체 검사 | 보완 | `tobe_rule_registry.py --check` 를 한 항목으로 편입(룰 번호 미등재가 생기면 게이트에서 드러남) |
| A-06 | `tools/VibeManager/CHANGELOG.md` | 보완 | 2.0.9 항목 — `S1.liveScreen`(작업·메뉴) + CheckList 체인 편입(asis_live_auto → asis_live_screen → asis_live_ingest · asis_live_rows) 기록 |
| A-07 | `history.js` 의 `S4.one` · `S5.pkgdeploy` | 유지(보고) | VM 코드라 vsix 재설치가 따르는 변경 — 사용자 절차 영역 |
| A-08 | `steps.json` `S6.regen`(gap.js — GAP 분석 10-30 폐지) | 삭제 후보 | 메뉴·체인에 없고 Flow 패널에만 보임. 기존 항목이라 승인 필요 |
| A-09 | `new-design-full` 체인에 `S1.live`·`S8.precheck` 없음 | 유지 | CHANGELOG 2.0.7 에 "14(불변)" 로 의도 기록 있음 |
| A-10 | `package.json` 2.0.1 ↔ CHANGELOG 2.0.8 | 유지(보고) | 버전·vsix 는 사용자 절차 |

### B. 문서 hook · 룰 카탈로그

| ID | 대상 | 조치 | 내용 |
|---|---|---|---|
| B-01 | hook 수 표기 11곳 | 보완 | 실측 156 으로 통일 — `RULESET_MASTER`(상단·§4 헤더·§4 주석·말미) · `00_INDEX`(머리·38행·§B.3 헤더) · `CLAUDE.md §3` · hooks README 2곳 · `build_router.py:58` 문구 → 라우터 재추출 |
| B-02 | `RULESET_MASTER §4` 표 | 보완 | 행 없는 5개(#123 · #140 · #141 · #151 · `ui-mandatory-12-behaviors`) 행 추가 |
| B-03 | 번호 충돌 #149 | 보완 | `ui-mandatory-12-behaviors` 에 새 번호 **#156** 부여(파일 제목 1줄 + 카탈로그) — 번호 선택은 확인 필요 |
| B-04 | `00_INDEX §B.3` · `00_CATEGORY_MAP` · 해당 카테고리 파일 | 보완 | 미등재 1 · 5 등재 |
| B-05 | `30_HOOK_DISPOSITION.csv` | 보완 | #154 · #155 2행 추가(처분 값은 확인 필요) |
| B-06 | `.claude/hooks/README.md` | 보완 | "10 스크립트 + 하네스 hook 3 = 연결 13" · 하네스 hook 3행 · 끝줄 수치 |
| B-07 | `CLAUDE.md §3·§5` | 보완 | 153 → 156 · §5 에 하네스 hook 3종(`check-asis-harness` · `harness-gen-context` · `harness-stop-gate`). 이력은 `Doc/_archive/CLAUDE_changelog_2026-11.md`(신규)에 1줄 |
| B-08 | `scripts/rules/verify_hooks.ps1` | 보완 | 한글 입력 인코딩 지정 · 3단계의 차단 출력으로 스크립트가 멈추지 않게 → 5단계까지 돌게 |
| B-09 | `tools/Harness/README.md` · `tools/VibeManager/README.md` | 보완 | 없는 경로 정정 · CheckList 체인 현재 단계표와 AS-IS Live 절 추가 |
| B-10 | `.claude/commands/단위테스트.md` | 보완 | 예시 파일 경로를 실재 파일로 |

### C. 한곳으로 모으기

| ID | 대상 | 조치 | 내용 |
|---|---|---|---|
| C-01 | 도구 등록부 | 통합(신설) | `tools/Harness/README.md` 에 "도구 등록부" 절 — 도구별 진입점(체인 단계 / VM 작업 / 손 실행) · 산출물 · 상태. §2-2·§2-3 표가 초안 |
| C-02 | AS-IS Live 안내 | 통합 | `_ENGINE_MASTER` 로그·CHANGELOG 에 흩어진 구동 방법·대상 제외·끄기(`VERIFY_ASIS_LIVE=off`)·산출물 위치를 C-01 절 아래 한 단락으로(`_ENGINE_MASTER` 는 끝에 1줄 포인터만 덧붙임) |
| C-03 | 점검 스크립트 | 통합(신설) | 이번 측정 스크립트 5개를 `scripts/rules/inventory_check.py` 하나로 합쳐 상시 도구로(읽기 전용 · 어긋나면 rc 1) |

### D. 이동 · 삭제 (승인 필요 — 기본안은 `Doc/_archive/` 이동)

| ID | 대상 | 수 | 조치 | 근거 |
|---|---|---:|---|---|
| D-01 | `Doc/_rules_v2/` 과거 보고서 4개 | 4 | 이동 → `Doc/_archive/rules_v2_reports/` | 참조 0 |
| D-02 | `Doc/_rules_v2/CLAUDE.md`(구판 07-03) | 1 | 이동 + 언급 3곳(MASTER·INDEX·진단보고서) 경로 정정 | 없는 경로 4 · 현행 진입은 루트 `CLAUDE.md` |
| D-03 | `Doc/_rules_v2/_archive_be_phase6_wrong/` | 6 | 이동 | 참조 0 |
| D-04 | `Doc/_rules_consolidation/_claude_hooks_staged/` | 5 | 이동 | 적용 끝난 대기본 |
| D-05 | `PROMPT_TEMPLATES.md` · `2026-10-12_RULE_HOOK_RESTRUCTURE.md` | 2 | 이동 | 참조 0 (뒤 것은 `CLAUDE.md` 가 날짜로만 언급) |
| D-06 | 14일 넘은 .bak | 137 | 이동 → `Doc/_archive/bak_20261113/<원래 경로>` | 최근 .bak 303개는 다른 세션의 되돌리기용이라 그대로 |
| D-07 | 일회성 스크립트 | 7 | 이동 | `harness_DMF0052_step1/2.cmd` · `tmp_strip_asis.js` · `agent_DMF0052.cmd` · `tools/batch_B.cmd` · `batch_B2.cmd` · `_vm_dev_backup_20261016.tgz` |
| D-08 | `cr_harness_gap.py` + `Doc/verify/_cr_harness_gap.md` | 2 | 이동 | `tobe_rule_registry` 로 대체 |
| D-09 | `.claude/hooks/*.sh` | 5 | 유지 | README 가 Linux 전환용으로 명시 |
| D-10 | `tools/VibeManager/dist/*.vsix` | 69 | 유지 | 사용자 설치 절차 |
| D-11 | `.gitignore` 에 `*.bak_*` | – | 유지(보고) | git 추적 376개 — 커밋 정책은 사용자 결정 |

### E. 메모리 색인

| ID | 대상 | 조치 | 내용 |
|---|---|---|---|
| E-01 | 색인에 없는 70개 | 통합 | `_index_bundles.md` 에 "미색인 등재(2026-11-13)" 절로 한 줄씩(파일 보존) |
| E-02 | 대체된 지시가 `MEMORY.md` 상단에 남은 것 | 통합 | `feedback_rule_harness_work_no_fe_edit`(10-26 해제) · `feedback_db_object_fix_first…`(10-26 해제 문구 ↔ 11-02 작업 모드) · `feedback_no_docker_oracle`(09-21 해제) → 묶음 색인의 "대체됨" 절로 내리고 현행은 작업 모드 항목 1줄로 |
| E-03 | 중복 등재 8건 | 보완 | 한 번만 남김 |
| E-04 | frontmatter 없는 2개 | 보완 | 머리말 추가 |
| E-05 | 메모리 파일 삭제 | 안 함 | 색인만 정리 |

## 5. 승인 묶음

| 묶음 | 포함 | 성격 |
|---|---|---|
| ① 문서·카탈로그 보완 | A-06 · B-01~B-10 · C-01 · C-02 | 문서만 고침(공유 JSON·엔진 코드 불변) |
| ② 엔진 최소 보완 | A-01~A-05 · C-03 | `run_verify.py` 3곳 · `engine_selfcheck.py` 2곳(백업 · 적용 뒤 자체 점검 전체 실행) |
| ③ 보관 이동 | D-01~D-08 | 파일 이동(삭제 없음 · 이동 목록 기록) |
| ④ 메모리 색인 | E-01~E-04 | 색인 2개 파일만 |
| ⑤ 기존 항목 삭제 | A-08 | `steps.json` 작업 1개 삭제 |

## 6. 이번에 하지 않았거나 확인하지 못한 것

- 문서 hook 156개 · `_asis`·`_tobe`·`_dev_rules` 본문끼리의 모순·대체 여부(파일 단위 등재만 확인).
- `.claude/rules` 4개 · `10_RULES_KEEP.md` 의 문구가 현재 코드와 맞는지(경로 참조만 확인).
- `detect_rules.csv` 94 · `mapping_checkdefs.csv` 101 규칙의 검사 구현 여부(`engine_audit.py` 미실행).
- `--static` 실행 때의 단계 수 경고(코드 판독으로만 확인).
- `verify_hooks.ps1` FAIL 3건의 원인(PowerShell 7 에서는 재현 안 됨까지만 확인).
- `history.js` 의 없는 작업 id 2개가 화면에 미치는 영향 · `Doc/e2e/_human_review.md` 가 실행 때 생기는 파일인지.
- §2-3 "10월 도구" 11개가 지금도 쓰이는지.
- VM 메뉴를 VS Code 에서 실제로 눌러 본 것은 없다(JSON 정합만 확인).
- `engine_selfcheck.py` 전체 검사(tsc·selftest 포함)는 돌리지 않았다(빠른 검사만).

## 7. 적용 결과 (2026-11-13 15:03 ~ 15:14 · 사용자 승인 "①②④ 적용")

§1~§6 은 적용 전(14:46~14:58) 측정값이다. 아래가 적용 뒤 상태다.

| ID | 결과 | 실측 근거 |
|---|---|---|
| A-01 | 다른 세션이 같은 시각 먼저 반영(14 → 15) | `run_verify.py` 백업과의 차이 3곳 중 1곳이 그쪽 변경 |
| A-02 | 적용 | `--static` 분기 건너뜀 표시 1줄 · `--static` 실행으로는 재지 않음(미측정) |
| A-03 | 적용 | 머리말 "현재 실행 단계" 12줄(주석) |
| A-04 | 적용 | `PY_GLOBS` + `tools/AsisLive/*.py` · `tools/Docs/*.py` |
| A-05 | 적용 | 전체 검사 항목 `RULE_REGISTRY` |
| A-06 | 하지 않음 | 15:02 에 다른 세션이 CHANGELOG 2.0.9 로 `S1.liveScreen`·CheckList 자동 구동을 기록 — 중복 기록 안 함 |
| B-01·B-02·B-04 | 적용 | `inventory_check.py` HOOK_COUNT: 디스크 156 = MASTER 상단 = §4 헤더 = §4 표 행 = CLAUDE.md = hooks README · HOOK_CATALOG 미등재 0 |
| B-03 | 적용(#156) | `ui-mandatory-12-behaviors.md` 제목 1줄 + 끝에 정정 사유 1줄 · 본문 불변 |
| B-05 | 적용 | `30_HOOK_DISPOSITION.csv` 154 → 156행 · #154 = KEEP-RULE(근거 `10_RULES_KEEP.md` E12) · #155 = KEEP-RULE(E14) |
| B-06·B-07 | 적용 | hooks README(10 스크립트 + 하네스 3 = 연결 13) · `CLAUDE.md` §3·§5(7,474 → 7,650 bytes) · 이력 `Doc/_archive/CLAUDE_changelog_2026-11.md` 신설 |
| B-08 | 적용 | `verify_hooks.ps1` 을 UTF-8 BOM + 인코딩 고정 + 3단계 중단 방지 → Windows PowerShell 5.1 에서 5단계 전부 실행 · 판별 6/6 OK(15:06). 원인 = BOM 없는 스크립트의 한글을 5.1 이 잘못 읽은 것 |
| B-09 | 적용 | `tools/Harness/README.md` 에 2026-11-13 절(체인 단계표 · AS-IS Live · 도구 등록부) · `tools/VibeManager/README.md` · `Doc/verify/README.md` 끝에 현행 안내 |
| B-10 | 적용 | 견본 경로를 실제 위치(`Doc/단위테스트/old/…v2.0.xlsx`)로 |
| C-01·C-02 | 적용 | 도구 등록부 204개(자동 생성 · 손 실행 도구 포함) · REGISTRY 미등록 0 |
| C-03 | 적용 | `scripts/rules/inventory_check.py`(읽기 전용 · 0.7초) — 15:13 전 항목 PASS |
| E-01 | 적용 | 미색인 70건을 `_index_bundles.md` "§미색인 등재" 절에(파일 보존) → MEMORY 점검: 색인에 없는 파일 0 · 깨진 링크 0 |
| E-02 | 일부 적용 | `feedback_rule_harness_work_no_fe_edit` 를 "§대체된 지시" 로 이동 · `feedback_db_object_fix_first…` 줄을 작업 모드 기준 문구로. `feedback_no_docker_oracle` 은 현재 유효 여부를 확인하지 못해 그대로 둠 |
| E-03 | 하지 않음 | 중복으로 본 8건을 열어 보니 같은 파일을 서로 다른 내용으로 가리키는 포인터였다(중복 아님 — §1-5 의 "중복 등재" 는 오분류) |
| E-04 | 하지 않음 | 두 파일 모두 머리말이 있었다(BOM 때문에 점검 스크립트가 못 읽은 것 — §1-5 의 "frontmatter 없는 파일 2" 는 오측정) |

적용 뒤 검증(15:13~15:14):
- `python scripts/rules/inventory_check.py --memory` → PASS (HOOK_WIRING 13 · HOOK_COUNT 156 · HOOK_CATALOG 0 · ROUTER_REFS 0 · VM_JSON 작업 110·메뉴 78·체인 6·깨진 참조 0 · CHAIN_FILES 105/0 · GATE_SCOPE 0 · REGISTRY 204/0 · MEMORY 576/0).
- `python tools/Harness/verify/engine_selfcheck.py`(전체) → PASS · 26.7초 · PY_COMPILE 0 · PY_UNDEF 0 · CTRL_CHARS 0 · JS_SYNTAX 0 · SPEC_SIZE 0 · TSC 0 · SELFTEST_JS 0(29개) · SELFTEST_PY 0(40개) · RULE_REGISTRY 0.
- JSON 파싱 8개 OK(`steps.json` · `quick.json` · `harness.json` · `settings.json` · `settings.local.json` · `package.json` · `e2e.config.json` · `cleanup_spec.json`). `steps.json`·`quick.json` 은 이 세션이 고치지 않았다(그 사이 다른 세션이 작업 107 → 110 · 메뉴 75 → 78 로 추가).
- STAGE_WARN 은 `run_verify.py` 수정 뒤 CheckList 실행 로그가 아직 없어 미측정이다. 다음 CheckList 실행 뒤 `inventory_check.py` 를 다시 돌리면 잰다.

남은 것: ③ 보관 이동(D-01~D-08) · ⑤ `S6.regen` 삭제 · §6 의 미확인 항목 · 이번에 뒤늦게 확인한 `Doc/verify/README.md`(81KB · 10-31 · 11월 내용 없음 — 끝에 포인터만 덧붙임, 본문 갱신은 안 함) · 백업 `*.bak_20261113_inv` 16개(저장소) + 메모리 색인 백업 2개(`memory/_archive/*_backup_20261113_inv.md`)는 그대로 둠.

## 8. 보관 이동 결과 (2026-11-13 15:18 · 사용자 승인 "③ 진행")

삭제 0. 이동 목록 = `Doc/_archive/_moved_20261113.csv`(145건 · 파일 154개) · 설명 = `Doc/_archive/README_moved_20261113.md`. 되돌리려면 그 표의 to → from.

| ID | 결과 | 비고 |
|---|---|---|
| D-01 | 이동 4 → `Doc/_archive/rules_v2_reports/` | 서로만 참조하던 과거 보고서 |
| D-02 | 이동 1 + 언급 4곳에 이동 표기 | `RULESET_MASTER` · `00_INDEX` · `Doc/_dev_rules/README.md` 는 해당 줄에, 진단보고서는 본문을 두고 끝에 1줄 |
| D-03 | 이동(폴더 · 파일 6) → `Doc/_archive/rules_v2_archive_be_phase6_wrong/` | `meta-rule-evolution.md` 해당 줄 · `PoC_FIX_REPORT.md` 끝에 이동 표기 |
| D-04 | 이동(폴더 · 파일 5) | |
| D-05 | 이동 2 | |
| D-06 | 이동 **127**(정리안의 137 과 다름) | 기준을 좁혔다 — 수정 시각 14일 초과 **이면서** 접미사 날짜가 2026-10-30 이전(또는 날짜 없음). 오늘 만든 백업이 원본의 수정 시각을 물려받아 "14일 넘음" 으로 잡히는 것을 제외. 대상 위치의 `.bak` 471개 중 344개는 제자리 |
| D-07 | 이동 7 → `Doc/_archive/tools_retired/` | |
| D-08 | 이동 2 + `Doc/verify/README.md` 끝에 대체 표기 | `tobe_rule_registry.py` 의 제외 패턴에 남은 이름은 동작에 영향 없음(그대로 둠) |

이동 뒤 검증(15:18~15:19):
- `engine_selfcheck.py` 전체 → PASS(21.9초 · 전 항목 0 · selftest JS 29 · PY 40).
- `inventory_check.py --memory` → PASS(REGISTRY 도구 204 → 202 = `cr_harness_gap.py` · `tmp_strip_asis.js` 빠짐 · 미등록 0).
- `verify_hooks.ps1` → OK 16줄 · FAIL 0.
- 사고 1건(복구 완료): 등록부를 다시 쓰는 중 README 잘림이 거부돼(PermissionError) `tools/Harness/README.md` 끝에 옛 내용 일부가 남았다 → 끝부분 정리 · `inventory_check.py --write-registry` 를 임시 파일 + 바꿔치기 방식으로 고침 · 표식 2개 · UTF-8 정상 확인. 같은 세션에서 제자리 덮어쓰기로 고친 다른 14개 파일은 전부 크기가 늘어난 변경이라 해당 없음(UTF-8·끝부분 확인).

남은 것: ⑤ `steps.json` `S6.regen` 삭제 · §6 미확인 항목 · `Doc/verify/README.md` 본문 갱신.

## 9. `S6.regen` 삭제 결과 (2026-11-13 15:30 · 사용자 승인 "⑤ 진행")

- 삭제 직전 재확인: `S6.regen` 참조는 `steps.json` 자체와 자동 생성 등록부 1줄뿐(메뉴·체인·VM js 0) · `steps.json` 형식 왕복 동일(들여쓰기 2 · LF · BOM 없음).
- 적용: `tools/VibeManager/steps.json` 작업 110 → 109 · 차이 7줄 = 삭제한 객체뿐 · 백업 `steps.json.bak_20261113_s6regen` · 임시 파일에 쓴 뒤 바꿔치기. `gap.js` 는 다른 도구 6개가 쓰고 있어 그대로 둠. `quick.json` 불변.
- 기록: `tools/VibeManager/CHANGELOG.md` 맨 위 항목.
- 검증(15:30): `inventory_check.py --memory` PASS(VM_JSON 작업 109 · 메뉴 78 · 체인 6 · 깨진 참조 0) · `engine_selfcheck.py` 전체 PASS(24.1초 · 전 항목 0).
- 미검증: VS Code Flow 패널 화면 확인 · 설치 폴더 반영(사용자 절차).

승인 묶음 ①~⑤ 가 모두 적용됐다. 남은 것은 §6 의 미확인 항목과 `Doc/verify/README.md` 본문 갱신이다.

## 10. §6 미확인 항목 확인 결과 (2026-11-13 15:40 ~ · 사용자 지시 "§6 미확인 항목 진행")

이 절은 측정만 했다. 고친 파일은 없다(산출물 `Doc/verify/_engine_audit.csv` 재생성 1개 제외).

| §6 항목 | 결과 | 근거(시각) |
|---|---|---|
| 규칙의 검사 구현 여부 | 규칙 101 = **OK 96 · 대상 생성 없음 5**(B5 · D2 · B8 · G03-WIRE · X-LOC). 11-08 판과 판정이 바뀐 규칙 0. `detect_rules.csv` 94개는 전부 조사 대상에 있음. `mapping_checkdefs.csv` 101행은 impl 열이 전부 Y · checker 열이 가리키는 파일 중 없는 것 0 | `engine_audit.py` 실행 15:43(rc 0) — 탐지는 문자열 패턴이라 '없음' 은 사람이 확인해야 한다는 도구 자체 한계 있음 |
| `--static` 단계 수 | 경고 0줄 — facts 15/15 · static 10/10 · post 31/31 · docs 1/1. `--skip-e2e` 도 diff 7/7 · docs 4/4 포함 전 단계 일치 | `run_verify.main()` 을 도구 실행 없이(모든 `run()`·subprocess 가짜) 태운 모의 실행 15:44. E2E 를 실제로 도는 경로(e2e·eg 단계)는 이 방법으로 재지 못함 |
| `verify_hooks.ps1` FAIL 3건 | 원인 확정·수정 완료(§7 B-08) | 15:06 |
| `history.js` 의 `S4.one`·`S5.pkgdeploy` | 영향 없음 — 작업 id → 분류를 찾는 표(`history.js:10`)와 하네스 적용 대상 집합(`workbench.js:32`)의 남은 키. 그 id 의 작업이 없으므로 조회되지 않는다 | 코드 판독 |
| `Doc/e2e/_human_review.md` | 깨진 참조 아님 — `e2e-judge.js:130` 이 사람 확인 항목이 생길 때 만들어 덧붙이는 파일(지금은 항목이 없어 파일 없음) | 코드 판독 |
| "10월 도구" 11개 사용 흔적 | 산출물이 11월에 갱신된 것 3(`decisions.py` 11-09 · `engine_gap_cluster.py`·`engine_gap_merge.py` 11-04) · 오늘 실행한 것 1(`engine_audit.py`) · 산출물이 10월에 멈춘 것 4(`facts_auth_db.py` 10-31 · `run_docs_batch.py` 10-31 · `extract-role-users.py` 10-27 · `datasets.py` 10-23) · 산출물 못 찾음 3(`facts_popup_accounts.py` · `snap_parallel.py` · `links.py`) | 산출물 수정 시각 15:4x — 산출물 경로는 머리말에서 읽은 것이라, 못 찾음 3개는 "안 쓰임" 이 아니라 미확인 |
| VM 메뉴 실제 동작 | 여전히 미검증(VS Code 화면 조작은 이 세션에서 못 함). 대신 설치본과 저장소를 대조: 설치 폴더 `marisoft.vibe-manager-2.0.1` 의 `quick.json`·`extension.js`·`workbench.js` = 저장소와 동일 · `steps.json` 은 `S6.regen` 1개만 다름(설치본 110 · 저장소 109 — 오늘 삭제분 미반영) | 파일 비교 15:4x |
| `engine_selfcheck.py` 전체 | PASS(§7·§8·§9 에서 4회) | 15:05 · 15:14 · 15:18 · 15:30 |

### `.claude/rules` 4개 · `10_RULES_KEEP.md` 문구 대조

| 위치 | 어긋남 | 근거 |
|---|---|---|
| `.claude/rules/00-fe-screen.md` F절 | "✅ `pnpm lint:fix` · `pnpm type-check` · `pnpm build` 통과" — 로컬 `pnpm` 은 실행 hook `block-dev-commands` 가 막고, 상시 지시는 "type-check/lint 는 요청 시만 · `_artifacts/_tools/fe-check.ps1`" | hooks README · 메모리 상시 지시 |
| `.claude/rules/00-fe-screen.md` · `01-be.md` | 작업 모드(DB MODE 에서 FE·BE 직접 수정 금지) 언급 없음 — 이 두 파일은 FE·BE 를 만질 때 자동으로 읽히는 문서 | `CLAUDE.md §1-8` |
| `.claude/rules/03-analysis-docs.md` D절 | 통계가 "2026-05-22 기준" — 재집계 안 됨(문서에 기준일은 적혀 있음) | 본문 |
| `.claude/rules` 4개가 가리키는 경로 | 16개 확인 중 없는 것 0(`Router.tsx` = `nscm-fe/apps/web/src/core/Router.tsx`) | 실재 확인 |
| `10_RULES_KEEP.md` E15 | "FE 보완 범위 해제(10-26) · 기본 repairScope=DB_FE" 가 E17 "작업 모드(11-02)" 와 함께 현행 행으로 남아 있음 — 현재 `harness.json` repairScope = DB_ONLY | `10_RULES_KEEP.md:78`·`:80` |
| `10_RULES_KEEP.md` 의 코드형 토큰 108개 | 98개는 하네스 코드·규칙 CSV 에 있음 · 없는 10개(C10 · D10 · E14 · E15 · E17 · H14 · H16 · H17 · H18 · H20)는 게이트 코드가 아니라 이 문서의 행 번호 | 문자열 대조 |

룰 문서 본문(문서 hook 156 · `_tobe` 15 · `_dev_rules` 9)의 모순·대체 대조 결과는 아래 §10-1 에 덧붙인다.

### 10-1. 룰 문서 본문 대조 (15:41 ~ 15:58 · 측정만 — 본문은 고치지 않음)

방법: 문서 hook 156 + 구 룰 v1 `Doc/_dev_rules/*.md` 9 + TO-BE 정밀 룰 `Doc/_rules_v2/_tobe` 15 = **180개**를 9묶음으로 나눠 하위 점검 9개가 각각 처음부터 끝까지 읽고(읽은 파일 180/180 · 끝까지 못 읽은 파일 0 — 각 점검의 보고 기준), 현재 기준(`CLAUDE.md` §1·§4 · 확정 룰 CR-001~103 · 날짜별 결정 9개)과 어긋나는 문장을 파일:줄 + 원문 인용으로 적게 했다. 전 건 목록 = `Doc/_rules_consolidation/2026-11-13_RULE_BODY_FINDINGS.csv`(490행).

| 유형 | 확실 | 검토 | 계 |
|---|---:|---:|---:|
| A 현재 기준과 모순 | 36 | 65 | 101 |
| B 뒤 결정으로 대체됐는데 표기 없음 | 25 | 75 | 100 |
| C 문서 간·문서 내 불일치 | 120 | 90 | 210 |
| D 없는 대상 참조 | 59 | 20 | 79 |
| 계 | **240** | **250** | **490** |

지적이 1건이라도 나온 파일 146개.

이 세션이 직접 한 재확인:
- 인용 실재(기계 대조 490건): 인용이 그 줄 ±3 에 있음 436 · 줄 번호만 다름 8 · 앞부분만 일치 35 · 못 찾음 11(인용을 풀어 쓴 것으로 보이며 개별 확인 안 함).
- "없는 대상" 79건 중 파일명이 들어 있는 40건: 저장소에 그 이름 없음 17 · 다른 위치(주로 `Doc/_dev_rules/_archive`)에 있음 21 · 일부만 있음 2. 나머지 39건은 함수·컴포넌트·별칭 이름이라 이 방법으로 재확인하지 못함.
- 상대 근거 직접 확인 9건(전부 지적과 일치): `row-crud.ts` 의 값은 C/I/D/M 뿐('U' 없음) · `block-dev-commands.ps1` 차단 목록에 type-check·build·lint 포함 · `screen-completion-gate.md:13` "11 게이트" · `column-config.ts` 입력 유형 S/O/M/IO/IM · 컨트롤 `FPModal`·`FPTextModal`·`FPComboBox` · `apps/web/package.json` react `^18.3.0` · `useMessageStore` 에 YesNoCancel 없음 · `SubTitle.tsx` 권한 게이트 4곳 · CR-071 원문 "Division→Div" · `getCombosMulti`·`getLookupsMulti`·`callQueryProc` 코드 0건.
- 그 밖의 지적(특히 '검토' 250건과 C 유형의 "어느 쪽이 맞는가")은 하위 점검의 판단이며 이 세션이 전수 재확인하지 않았다.

주제별(한 지적은 한 주제로만 셈):

| 주제 | 확실 | 검토 | 대표 |
|---|---:|---:|---|
| 문서 간·문서 내 값 불일치 | 100 | 79 | `CRUD_TYPE` 'U' ↔ 'M' · 데이터 커서 `o_rc` ↔ `o_rc1` · 컬럼 메타 테이블명 `SCM_ADM_MNU_M_SHEET_COLUMNS` ↔ `SCM_MST_SHEET_COLUMNS` · `MAIN_COLUMNS` fallback 허용 ↔ 금지 · 조회조건 1단 개수 |
| 없는 파일·컴포넌트·함수 참조 | 56 | 20 | `apps/web/src/app/router/AppRouter.tsx` · `public/locales/ko/translation.json` · `_tobe/14_error_handling.md` · `setConfirmYesNoCancel` · `@master/components` 별칭 · `_archive` 로 옮겨진 v1 문서 링크 |
| 확정 룰(CR) 미반영 | 16 | 50 | CR-070(권한 있을 때만 버튼 노출) 11 · CR-020·CR-076 각 7 · CR-071 6 · CR-093·CR-072 각 5 |
| `pnpm`·lint·type-check 실행 요구 | 15 | 11 | `screen-completion-gate.md:21` G5 · `regression-zero-mandatory.md:10` · `pre-submit.md:35` · `fe-cloud-type-lint-readiness.md:193` |
| `CLAUDE.md` 옛 절 번호 | 10 | 18 | "CLAUDE.md §15 / §8 / Step 3.5" |
| NULL 대체값 `'-'` ↔ `'/'` | 9 | 7 | `oracle-nvl-null-antipattern.md:13` · `pivot-dynamic-column-nvl.md:66` · `oracle-db-workflow.md:79` |
| 상대경로 import 예시 | 7 | 6 | `popup-modal-and-routing-mandatory.md:44` · `_tobe/02_imports.md:76` |
| 완료 게이트 수 | 6 | 3 | 같은 hook 안에서 8 · 10 · 11 |
| 작업 모드(11-02) 미반영 | 2 | 8 | `regression-zero-mandatory.md:39` "BE 변경 금지" |
| 검증 기본 계정 | 2 | 2 | `ui-selfcheck-runtime-mandatory.md:117` 5역할 전수 |
| 앱 계정명 SCMD_APP ↔ SCMP_APP | 0 | 8 | 환경별로 다를 수 있어 전부 검토 |
| 용어 "대사표" | 0 | 19 | 파일당 1건 |
| 기타 | 17 | 19 | |

확실 지적이 많은 파일: `ui-category-setup-column-meta.md` 11 · `_tobe/12_metadata_sql.md` 9 · `subtitle-button-actions-mandatory.md` 8 · `_dev_rules/22_PACKAGE_ARTIFACTS.md` 8 · `_tobe/07_datagrid.md` 7 · `_tobe/13_routing_menu.md` 7.

상시 문서(매 턴 또는 경로별로 자동 로드) 쪽에서 드러난 것 — 하위 점검이 근거로 삼다 알려 온 것이며 위 9건 재확인에 포함:
- `CLAUDE.md §0` "React 19" ↔ `nscm-fe/apps/web/package.json` `^18.3.0`.
- `CLAUDE.md §3` · `RULESET_MASTER`(4곳) "8 게이트" ↔ `screen-completion-gate.md:13` "11 게이트".
- `CLAUDE.md §1-2` "reference 화면 DMF0004~0007" ↔ `.claude/rules/00-fe-screen.md:14` 와 hook 2개는 DMF0004·0005·0006 3개 — 어느 쪽이 현행인지는 미확인.
- `.claude/rules/00-fe-screen.md:20` "Router.tsx import 검색으로 기존 작성 판별" ↔ 현재 `Router.tsx` 에 feature import 0건(경로 매핑이 DB 로 이관).

한계:
- 현재 기준으로 준 날짜별 결정은 9개뿐이다. 그 밖의 메모리 상시 지시(DB Docker · 사내 DB 주소 등)에 어긋나는 문장은 대상이 아니었고, 하위 점검이 본 것 일부만 '검토' 로 올라와 있다.
- DB 는 조회하지 않았다 — 테이블·컬럼 이름이 문서끼리 다른 지적은 어느 쪽이 맞는지 미측정.
- `Doc/_rules_v2/_asis`(26) · `_dictionary` · `_mapping` · `_categories` 본문은 이번 대조 대상이 아니다.
- 9개 묶음은 서로의 문서를 보지 않았다 — 묶음을 넘는 문서 간 불일치는 일부만 잡혔다.

## §11 상시 문서 정정 (사용자 승인 "상시 문서만 정정" · 2026-11-13 17:04~17:06)

| # | 파일 | 변경 전 | 변경 후 | 근거(이번 실측) |
|---|---|---|---|---|
| 1 | `CLAUDE.md` §0 | React 19 | React 18 | `nscm-fe/node_modules/react/package.json` version 18.3.1 · `apps/web/package.json` ^18.3.0 |
| 2 | `CLAUDE.md` §3 | (8 게이트) | (11 게이트 G1~G11) | `hooks/screen-completion-gate.md` §0 표 = G1~G11 |
| 3 | `.claude/rules/00-fe-screen.md` A | 8 게이트 | 11 게이트(G1~G11) + 작업 모드 확인 1줄 추가 | 위와 같음 · CLAUDE.md §1-8 · `check-work-mode` |
| 4 | 같은 파일 C-3 | `Router.tsx` import 검색 | `mdi/viewRegistry.tsx` 자동 수집 + DB `ROUTE_PATH` 기준 확인 | `core/Router.tsx` 39줄 · feature import 0 · `viewRegistry.tsx:24` import.meta.glob |
| 5 | 같은 파일 F | `pnpm lint:fix`·`type-check`·`build` 통과 | AI 직접 실행 금지 · 요청 시 `_artifacts/_tools/fe-check.ps1` · 미실행은 ERROR | `.claude/hooks/block-dev-commands.ps1` 차단 목록 |
| 6 | `RULESET_MASTER.md` 5곳(§2 T20 · §3.4 제목 · §3.4 본문 · §4 #46 · §7-8) | 8 게이트 | 11 게이트(+ G9~G11 설명) | hook §0 표 |
| 7 | `TRIGGER_ROUTER.md` · `UI_MANDATORY_CHECKLIST.md` | (추출본) | `build_router.py` 재추출 | 재추출 뒤 "8 게이트" 0줄 |
| 8 | `tools/VibeManager/rules/10_RULES_KEEP.md` E15 | "FE 는 가이드만 룰은 더 이상 적용하지 않는다 · 기본 DB_FE" | 작업 모드(E17)로 대체 표기 · 나머지 문장(미구현=FAIL · NA · 사용자의견 열)은 그대로 | E17(11-02) · 이 행을 읽는 코드 없음(grep) |

- 변경 전 사본: `Doc/_archive/bak_20261113/always_docs_before/` (6개 파일).
- CLAUDE.md 이력: `Doc/_archive/CLAUDE_changelog_2026-11.md` 1줄.
- 확인: `inventory_check.py` PASS(17:06:28) · `engine_selfcheck.py` 전체 PASS(17:06). 점검 중 다른 세션이 16:01 에 만든 `tools/Harness/verify/safe_io.py` 가 등록부에 없어 `--write-registry` 로 반영(도구 202 → 203).
- 손대지 않은 것: ① `CLAUDE.md §1-2` reference 화면 "DMF0004~0007" ↔ `00-fe-screen.md` B·hook 2개 "3개 화면" — 어느 쪽이 현행인지 미확인(사용자 결정 필요). ② `Doc/_rules_v2/00_INDEX.md` 36·121행 "8 게이트", `RULESET_MASTER.md` 339·352행 "8게이트"(당시 경위 서술), `screen-completion-gate.md` 내부 "G1~G8"·"8/8" 표기 — 상시 문서가 아니어서 이번 범위 밖. ③ `CLAUDE.md §1-4` "FE·BE lint + type-check + build 통과"는 요구 기준이라 유지(실행 방법만 `.claude/rules` 에서 정정).

### §11-1 reference 화면 범위 확정 (사용자 답 "3개(0004~0006)" · 2026-11-13)
- 정정 4곳: `CLAUDE.md §1-2` · `RULESET_MASTER.md` §1 표 1행 · `10_RULES_KEEP.md` 원칙 3 · `hooks/pre-write.md` 점검 항목 → DMF0004~0006.
- 그대로 둔 것: `_tobe/*.md` 변경 이력·추출 출처("DMF0004~7 통합 분석" 등), `cascade-combo-filter.md`(4개 화면에서 추출했다는 경위), `framework-foundation-entry.md:11`, `_mapping`·`_asis` 문서, `TOBE_RULES_DIFF.md` DD-164·166("DMF0004~0007 동일 정책" — 화면 동작 근거) — 당시 사실 기록이라 범위 밖. `_tobe/09_subtitle_hotkey.md:315` "현재 4 reference 화면" 은 본문 서술이라 룰 본문 정정 때 함께 볼 대상.

## §12 룰 본문 정정 — 확실 등급 240건 (사용자 지시 "확실 등급 240건 정정 진행" · 2026-11-13 17:14~17:42)

- 결과: **정정 203 · 보류 36 · 지적 오류 1** (합 240 · 입력 id 누락 0 · 초과 0). 전 건 목록 = `2026-11-13_RULE_BODY_FIX_RESULT.csv` (id · 파일 · 상태 · 변경 전/후 · 근거).
- 변경 파일 82개(백업 88개 중 · 나머지 6개는 보류만 있어 무변경) · 변경 덩어리 297 · 추가 461줄 / 교체 전 341줄 · 줄 수가 준 파일 0 · 줄바꿈 형식 바뀐 파일 0 · 깨진 문자 새로 생긴 파일 0 · 대상 외 룰 폴더 파일 변경 0.
- 변경 전 사본: `Doc/_archive/bak_20261113/rule_body_before/` (88개).
- 재대조(직접): 정정 203건 전부 해당 파일에 변경 있음 · 199건은 지적 줄 ±8 안, 4건(hg8-016·037·038·035)은 같은 문서의 다른 줄(그림 아래 단서·표 행 추가)에서 정정. 지적 줄과 떨어진 변경 덩어리 46개는 같은 종류를 함께 고친 자리로 모두 "11-13 정정" 표식 있음(내용의 옳고 그름은 전수 재확인하지 않음 — 근거 5건만 직접 확인: CRUD_TYPE.MODIFY='M' row-crud.ts:5 · origin NSCM_NEW.git 등).
- 직접 고친 1곳: `screen-create-checklist.md:16` — 하위 점검이 보관본 CLAUDE.md 를 "모두 read" 대상으로 바꿔 놓아 루트 `CLAUDE.md` 로 정정.
- 확인: `inventory_check.py` PASS(17:42) · `engine_selfcheck.py` 전체 PASS · `build_router.py --check` rc 0 · `verify_hooks.ps1` FAIL 0. (`build_router.py` 1회차는 쓰기 OSError Errno 22 → 재실행 성공 · 파일 크기 동일.) 등록부에 다른 세션 신규 도구 2개 반영(205).
- 방식 주의: 값을 바꾼 것과 "현재 저장소에 없음/현행은 …" 단서만 붙인 것이 섞여 있음(상태는 둘 다 FIXED — CSV after 열에 구분 기재).

### 보류 36 · 지적 오류 1 (사용자 결정 필요)

| id | 파일 | 사유(요약) |
|---|---|---|
| hg1-012 | `corp-meta-integrity-and-wiring.md` | 양쪽 모두 근거가 있어 코드로 판별 불가: column-config.ts:9-27 CELL_CONTROL_TYPE 에 'S' 없음(FE 미인식 — §6.1 편) vs .claude/hooks/check-meta-sql.ps1:11-12,39 'S' = hidden 용도 실데이터 존재로 허용(§6.2-T 편). FE packages 에서 ctrlType==='S' 처리 Grep 0건. 'S' 를 교정 대상으로 볼지 허용할지는 정책 결정 + DB 실데이터 확인 필요 |
| hg2-006 (지적 오류) | `datagrid-shared-component-mandatory.md` | FIX_BRIEF 확정 기준 'reference 화면 = DMF0004·0005·0006 3개' 와 252줄이 일치 — 어긋난 쪽은 conflicts_with 로 든 CLAUDE.md §1-2 문구(읽기 전용 대상)이며 이 줄이 아님 · 같은 파일 248-250 master 표도 3 화면 |
| hg2-007 | `grid-column-setting-popup-pattern.md` | 코드로 판별 불가: nscm-fe/features/*.tsx 의 ColumnSettingModal 사용처 10개 파일에 DMF0004·0005·0006(master/src/pages/sales-site·sales-site-project-model·customer-model-mapping) 없음 → 이 패턴의 대체 reference 를 3 화면에서 정할 수 없음. contribute-view 는 ContributeViewGrid.tsx 에 ColumnSetting |
| hg2-013 | `grid-cell-backcolor-standard.md` | 맥락별 병존 — 코드로 한쪽 확정 불가: 0 사용 = master/sales-site/SalesSiteGrid.tsx:153, supply/plant-site/PlantSiteGrid.tsx:345, formation 3개, contribute-main:372, spms-demand/plan-yield/YieldLossGrid.tsx:89('병합 그리드 — zebra 충돌 방지') 등 / 1 강제 = sdm·demand 다수('// zebra (#95)'). n |
| hg3-002 | `messaging-api-and-search-fields-mandatory.md` | 대체할 alias 없음: nscm-fe/configs/tsconfig.base.json:29 '@master/*' = features/master/src/pages/*/index.ts 라 @master/components 는 해석 안 됨. 실제 코드는 master 내부 '../../../components'(SalesFuturePriceForm.tsx:16 등), 타 feature 는 비-alias 'features/master/src/components'(Op |
| hg4-011 | `popup-modal-and-routing-mandatory.md` | nscm-fe/configs/tsconfig.base.json:27-30 — @master/* 는 pages/*/index.ts 만 매핑, features/{domain}/src/components 용 alias 없음 · 실코드도 '../../../components' 사용(CustomerModelMappingGrid.tsx:16 등) · '@master/components' 사용 0건 → 대체할 alias 확인 불가 |
| hg4-012 | `popup-modal-and-routing-mandatory.md` | hg4-011 과 동일 — components barrel 용 alias 가 tsconfig paths 에 없음 |
| hg4-023 | `oracle-perf-fix-priority-order.md` | §0.4 와 §9.5 가 같은 날(08-15) 서로 반대 값을 적음 — 실제 전송값은 SP 입력 로그(SCM_SYS_LOG_BATCH.IN_PARA_DATA)로만 판별 가능(DB 조회 금지) · 계정/권한에 따라 달라지는 값 |
| hg4-024 | `oracle-sp-perf-anti-patterns.md` | ''=NULL 이면 항상 UNKNOWN 이라는 지적은 타 hook 서술과 일치하나, 저장소 실 SQL 도 같은 계열 구문 사용(_artifacts/_apply_corporate/DMF0003_GET_MKT_FCST_DATA_patched_20260711.sql:294 NOT IN ('ALL','%','')) — 실제 0행 여부·대체 구문은 DB 실행 없이 확정 불가 |
| hg4-025 | `oracle-sp-perf-anti-patterns.md` | hg4-024 와 동일 — 실 SQL(_artifacts/DMF0003_GTT_RENAME_20260723_1035/_backup_PKG_DMF0003_body_original_20260723.sql:5274 등)이 문서와 같은 구문. DB 실행 없이 판별 불가(_artifacts Grep 은 시간 제한으로 일부만 확인) |
| hg4-027 | `post-write.md` | 맥락별 병존 — type-check-error-patterns.md:106-110,364-367 은 커서 결과 direct cast 에 as unknown as 의무, regression-zero-mandatory.md:60,103,141 · procedure-dts-ssot-mandatory.md:40,60 은 0건 요구. 실코드 nscm-fe/features 에 as unknown as 다수(ProjectRegTab1Grid.tsx 12건 등) → 현행 판별 |
| hg4-028 | `pre-write.md` | hg4-027 과 동일 사유 |
| hg5-023 | `screen-runtime-pitfalls-mandatory.md` | 문서 안 3가지(§6.3 column height 명시 · :518 SCSS override 확정·useEffect 무용 · :522 useEffect 추가)에 더해 현행 코드는 또 다른 방식: 공용 DataGrid headerRowHeight prop(packages/shared/src/components/organisms/data-grid 의 DataGrid :535·:656·:1929) · features/demand/src/pages/mkt-fcst/Mk |
| hg6-013 | `sp-dual-cursor-pattern.md` | FE 에 두 키가 화면별로 병존해 코드로 단일 표준 판별 불가: ?.o_rc 66건/20파일(features/**/pages/**/*.tsx — auth-request·user-management·dmf0052 등) · ?.o_rc1 은 master pages 만 35건/15파일. sp-cursor-name-response-key.md:61 'SP 별로 다름 — PROC_M/SP signature cross-check'. 실제 COL_NM 은 DB(SCM_ADM |
| hg7-001 | `ui-layout-shell-modal-feedback-standard.md` | 상대경로 아님(baseUrl 기준 경로). nscm-fe/configs/tsconfig.base.json:29 '@master/*' 는 features/master/src/pages/*/index.ts 만 가리켜 components 용 alias 없음. 실코드도 같은 경로 사용(demand/mkt-fcst/MktFcst.tsx:3-7, demand/sales-reports/components/SalesReportsModals.tsx:1, supply/waterf |
| hg7-009 | `subtitle-button-actions-mandatory.md` | SubTitle.tsx:211-228 현행 DefaultButtonActions = F7 no-op·F8 addRow({})·F9 removeRow+MSG00014 (false 아님), :256 {...Default,...hotkeyConfig}, :301-311 gateByAuth 는 '정의됐는데 권한 없음'만 숨김, PERMISSION_BUTTON_CODE 문자열 없음. 즉 현행 코드는 지적된 '구' 문장과 일치하고 같은 문서 :25-27·:82 의 '202 |
| hg7-010 | `subtitle-button-actions-mandatory.md` | SubTitle.tsx:211-228 현행 DefaultButtonActions = F7 no-op·F8 addRow({})·F9 removeRow+MSG00014 (false 아님), :256 {...Default,...hotkeyConfig}, :301-311 gateByAuth 는 '정의됐는데 권한 없음'만 숨김, PERMISSION_BUTTON_CODE 문자열 없음. 즉 현행 코드는 지적된 '구' 문장과 일치하고 같은 문서 :25-27·:82 의 '202 |
| hg7-011 | `subtitle-button-actions-mandatory.md` | SubTitle.tsx:211-228 현행 DefaultButtonActions = F7 no-op·F8 addRow({})·F9 removeRow+MSG00014 (false 아님), :256 {...Default,...hotkeyConfig}, :301-311 gateByAuth 는 '정의됐는데 권한 없음'만 숨김, PERMISSION_BUTTON_CODE 문자열 없음. 즉 현행 코드는 지적된 '구' 문장과 일치하고 같은 문서 :25-27·:82 의 '202 |
| hg7-012 | `subtitle-button-actions-mandatory.md` | SubTitle.tsx:211-228 현행 DefaultButtonActions = F7 no-op·F8 addRow({})·F9 removeRow+MSG00014 (false 아님), :256 {...Default,...hotkeyConfig}, :301-311 gateByAuth 는 '정의됐는데 권한 없음'만 숨김, PERMISSION_BUTTON_CODE 문자열 없음. 즉 현행 코드는 지적된 '구' 문장과 일치하고 같은 문서 :25-27·:82 의 '202 |
| hg7-013 | `subtitle-button-actions-mandatory.md` | SubTitle.tsx:211-228 현행 DefaultButtonActions = F7 no-op·F8 addRow({})·F9 removeRow+MSG00014 (false 아님), :256 {...Default,...hotkeyConfig}, :301-311 gateByAuth 는 '정의됐는데 권한 없음'만 숨김, PERMISSION_BUTTON_CODE 문자열 없음. 즉 현행 코드는 지적된 '구' 문장과 일치하고 같은 문서 :25-27·:82 의 '202 |
| hg7-014 | `subtitle-button-actions-mandatory.md` | SubTitle.tsx:211-228 현행 DefaultButtonActions = F7 no-op·F8 addRow({})·F9 removeRow+MSG00014 (false 아님), :256 {...Default,...hotkeyConfig}, :301-311 gateByAuth 는 '정의됐는데 권한 없음'만 숨김, PERMISSION_BUTTON_CODE 문자열 없음. 즉 현행 코드는 지적된 '구' 문장과 일치하고 같은 문서 :25-27·:82 의 '202 |
| hg7-015 | `ui-category-setup-column-meta.md` | 문서 간 주장만 있음: ui-category-setup-no-arbitrary-data.md:41·:66(06-22 AI 임의 INSERT 금지·보고) vs 같은 파일 §12.2-2(07-04 '메타가 비면 deploy SQL §9 BLOCK 6 로 채운다')·no-arbitrary §3(실데이터 복사·사용자 명시 요청은 허용). 코드·확정 기준으로 판별 불가 |
| hg7-018 | `ui-category-setup-column-meta.md` | 실코드 병존: divisionId 전송 = demand/forecast-price/useForecastPriceStore.ts:535-538, sales-plan/useSalesPlanStore.ts:458-461, sales-reports/useSalesReportsStore.ts:309-312, sales-monitoring/useSalesMonitoringStore.ts:444- / 미전송 = master/sales-future-price/useSalesF |
| hg7-019 | `ui-category-setup-column-meta.md` | 실코드가 fallback 사용 중: master/sales-future-price/components/SalesFuturePriceGrid.tsx:215, demand/sales-monitoring/components/SalesMonitoringGrid.tsx:125, demand/mkt-fcst-01/components/MktFcst01Grid.tsx:338, demand/cust-psi-upload/components/CustPsiUploadGrid.tsx: |
| hg7-020 | `ui-category-setup-column-meta.md` | hg7-019 와 동일 근거(실코드 fallback 사용 중 vs #113 문서 금지) |
| hg7-021 | `ui-category-setup-column-meta.md` | 실코드 동일 패턴 사용 중: master/sales-future-price/SalesFuturePrice.tsx:385·:402·:426, sales-future-price.constants.ts:264, demand/sales-future-price-01/SalesFuturePrice01.tsx:584. 문서 :528 금지 문장과 코드가 갈림 — 판별 불가 |
| hg7-022 | `ui-category-setup-column-meta.md` | reference DMF0004 실코드가 지적된 형태 그대로: master/sales-site/SalesSite.tsx:338-340 (스토어 = createPersistedStoreWithTab, useSalesSiteStore.ts:90 · 복원 가드 :158). §5.2 금지 서술과 reference 코드가 갈림 — 판별 불가 |
| hg7-027 | `ui-dynamic-property-management.md` | hg7-015 와 동일 — ui-category-setup-no-arbitrary-data.md:41·:66 와 문서 간 주장만 있고 코드·확정 기준으로 판별 불가 |
| hg7-028 | `ui-dynamic-property-management.md` | hg7-018 와 동일 — measure 호출의 divisionId 전송/미전송이 실코드에 병존 |
| hg7-031 | `ui-category-setup-column-meta.md` | 모달키 슬롯을 판별할 코드 근거 못 찾음: packages/shared/.../data-grid 에 modalKey·attribute1 grep 0건, features·packages 에 `_modalKey:` 대입 0건. ui-meta-dictionary-mandatory.md §4.3 규약 1-2 문서 주장뿐이고 실제 값은 DB 메타로만 판별 |
| hg8-024 | `02_DEVELOPMENT_RULES.md` | 맥락별 병존으로 판별 불가: 02 는 사내 GitLab(nscm-fe/be) 브랜치 규약, 28·30 은 개인 GitHub 백업 원격. nscm-fe/.husky/pre-push 에는 정규식 2종이 있고 첫 정규식은 main 허용 → 코드로 어느 쪽이 현행인지 확정 못 함 |
| hg8-025 | `02_DEVELOPMENT_RULES.md` | nscm-fe/commitlint.config.js 는 config-conventional + subject-case off 뿐(scope 대소문자 규칙을 저장소 안에서 확인 못 함). 28 은 다른 저장소(루트 백업) 커밋 규칙 → 판별 불가 |
| hg8-026 | `21_TROUBLESHOOTING.md` | 폐기 근거가 22_PACKAGE_ARTIFACTS.md:55 한 곳뿐이고, Doc/_rules_v2/_tobe/12_metadata_sql.md:32 는 4-파일 세트를 표준으로, .claude/rules/02-db-sql.md:23 은 *_DBeaver*.sql 검사 hook 을 현행으로 적음 → 문서 간 주장만 있고 코드로 판별 불가 |
| hg9-030 | `00_SCREEN_ANATOMY.md` | 판별 불가(맥락별 병존): reference 3화면(SalesSite.tsx:338-340 · SalesSiteProjectModel.tsx:274 · CustomerModelMapping.tsx:152)과 70개 페이지가 guard 안 호출을 실제로 쓰고(이 구조는 fetchStaticColumns 가 initialized 를 세팅), 04 §10 은 fetchSearchConditions 를 따로 둔 화면의 사고 패턴. 어느 쪽으로 통일할지는 코드로 정할 수 |
| hg9-031 | `01_file_structure.md` | 문서 주장만 있음: 01 §1.5.1 = 300 권장 / 03 §3.7 = 200 권장 / 03 §4 = ≤250 권장 / 01 §3.2 = 200 의무. 확정 기준·실행 hook·코드에서 권장 라인 수를 정하는 근거를 찾지 못함 |
| hg9-036 | `03_main_component.md` | hg9-030 과 같은 사유 — reference 3화면·70개 페이지가 실제로 이 형태를 쓰고 04 §10 은 다른 구조의 사고 패턴. 코드로 판별 불가 |
| hg9-049 | `12_metadata_sql.md` | 둘 다 실제 사용(병존): FE RESPONSE_SET 'o_rc1' 150파일(DMF 등) / 'o_rc' 20파일(admin: group-menu·lookup·menu-management·user-management 등) · SP OUT 은 O_RC1 51건 / O_RC 1건(_artifacts/63_SYS0012_SP_dual_cursor_fix.sql). 예시가 SYS0012(실제 o_rc)라 한쪽으로 통일 불가 (11:134 도 그대로 둠) |

## §13 보류 36건 결정안 (2026-11-13 · 근거는 이번에 직접 읽은 파일)

### 13-1 문서만 고치면 되는 것 — 13건 (근거 확인됨 · 승인 시 바로 정정)
| 묶음 | id | 현재 어긋남 | 결정안 | 직접 확인한 근거 |
|---|---|---|---|---|
| B 컬럼 메타 첫 호출 형태 | hg7-022 · hg9-030 · hg9-036 | 문서 한쪽은 `if (!initialized) void fetchStaticColumns()` 를 금지, 다른 쪽은 표준 | 표준으로 유지하고, 금지 문장에 "조회조건 복원(fetchSearchConditions)을 따로 둔 구조에서만 해당" 단서 | reference DMF0004 `SalesSite.tsx:338-340` 이 이 형태(하위 점검 보고: reference 3화면·70개 페이지) |
| E 메타 없을 때 | hg7-015 · hg7-027 | "없으면 반드시 신규 등록" ↔ "AI 임의 INSERT 금지" | 두 문장을 합침: 화면설계서·AS-IS 실데이터 근거가 있거나 사용자가 요청하면 deploy SQL 로 등록, 근거 없이 추정 등록 금지(보고) | `ui-category-setup-no-arbitrary-data.md:41·66` (추정 INSERT 금지 · 명시 요청 시 처리) |
| F 커서 키 | hg6-013 · hg9-049 | `o_rc` 단일 표준처럼 서술 | "커서 키는 SP 별 — `SCM_ADM_PROC_M` 등록값을 따른다(DM 계열 o_rc1 · admin 계열 o_rc)" 로 | 하위 점검 Grep: FE 에 두 키 병존(o_rc1 150파일 · o_rc 20파일) |
| H 타입 단언 | hg4-027 · hg4-028 | `as unknown as` 를 "우회/의무"로 안내 | "`as unknown as` 는 쓰지 않는다 — 타입은 procedures.d.ts 에서 맞춘다"로. `type-check-error-patterns.md:106-110` 도 같은 정정 대상(검토 등급) | 실행 hook `.claude/hooks/check-fe-import.ps1:64-69` 가 `as unknown as` 를 경고 |
| I 컨트롤 'S' | hg1-012 | §6.1 "'C'/'S' 검출 시 교정" ↔ §6.2 'S' 허용 | "'C' 등 미정의값만 교정, 'S' 는 숨김 용도로 허용"으로 | 실행 hook `check-meta-sql.ps1:11-12,39` 허용 목록에 'S' |
| K 다단 헤더 높이 | hg5-023 | 문서 안에 3가지 방식 | 522줄에 "현행은 공용 DataGrid `headerRowHeight` prop" 단서 | `DataGrid.tsx:535·635·655` |
| L 컬럼 설정 팝업 reference | hg2-007 | DMF0043_01 을 "master 표준"이라 적음 | "이 패턴 한정 참조 화면(화면 reference 3개와 별개)" 단서 | reference 3화면에 이 팝업 사용처 없음(하위 점검 Grep) |
| O-1 main push | hg8-024 | "main 직접 push 금지" | "사내 GitLab(nscm-fe/be) 한정 — 개인 백업 원격(NSCM_NEW)은 main 에 백업 커밋" 단서 | `git log` 최근 5건이 main 의 BACKUP_ 커밋 · `.husky/pre-push` 첫 정규식 main 허용 |

### 13-2 사용자 결정이 필요한 것 — 19건 (문서와 실제 코드가 갈림)
| 묶음 | id | 갈리는 내용 | 권장 | 권장 근거 / 결정에 따른 후속 |
|---|---|---|---|---|
| A 공통버튼 기본 동작 | hg7-009~014 (6) | 문서 표(10-26)·CR-070: Save/Insert/Delete 는 화면이 핸들러를 줄 때만 노출 ↔ 공용 `SubTitle.tsx:211-228` 은 기본 동작이 살아 있음(F8 addRow · F9 removeRow · F7 no-op 노출) | 문서 6줄을 10-26 표에 맞춤("생략 가능/자동" → "핸들러 명시") | CR-070 원문 `confirmed_requirements.csv:71`. ⚠ 공용 코드가 룰과 다름 — 공통 컴포넌트라 코드 수정은 별도 확인 필요(이번 범위 밖) |
| C 메타 실패 시 대체 컬럼 | hg7-019·020·021 (3) | 문서 예시가 `MAIN_COLUMNS`/`MEASURE_4` 대체값 사용 ↔ 다른 hook(#113)은 금지 ↔ 실코드 6곳 사용 | 금지 유지 · 문서 예시에서 대체값 제거 | "admin 운영 결정이 화면에서 무효화" 방지 원칙(`00-fe-screen.md` A). 금지로 정하면 실코드 6곳은 보완 후보 |
| D measure 호출 Division | hg7-018 · hg7-028 (2) | `divisionId` 전송 4화면 ↔ 미전송 4화면 | 전송으로 통일 | 같은 문서의 컬럼 호출은 "항상 전송"(이번 정정 hg7-016). 통일하면 미전송 4화면은 보완 후보 |
| G 화면 밖 components import | hg3-002 · hg4-011 · hg4-012 · hg7-001 (4) | 문서는 `'../../../components'` 또는 없는 별칭 `@master/components` ↔ `tsconfig.base.json:27-35` 에 components 별칭 없음 | `'features/<도메인>/src/components'`(비상대 경로)로 통일 — hg7-001 은 이미 이 형태라 그대로 | `_tobe` 3건은 이번에 이 경로로 정정됨 · 린트 설정 `configs/eslint.config.mjs:78` 의 상위 상대 import 제한 규칙(warn). ⚠ 다른 feature 에서 이 경로를 쓰면 `CLAUDE.md §4-②`(feature 간 직접 import 금지)와 부딪힘 — 별칭 신설 여부는 FE 구조 결정 |
| J zebra 끄기 | hg2-013 (1) | 문서 "`alternatingRowStep=0` 금지" ↔ reference DMF0004 `SalesSiteGrid.tsx:153` 등 병합 그리드가 0 사용 | "병합 그리드만 예외 허용" 명시 | 실코드 주석 "병합 그리드 — zebra 충돌 방지" |
| M 진입 페이지 길이 | hg9-031 (1) | 300 권장 / 200 권장 / 250 권장 / 200 의무 | 값 1개 지정 필요(권장안 없음) | 정하는 근거(hook·코드)를 찾지 못함 |
| O-2 커밋 scope 대소문자 | hg8-025 (1) | 02 문서 "화면 ID 소문자" ↔ 28 문서 다른 규칙 | 그대로 둠 | `commitlint.config.js` 에 scope 규칙 없음 — 판별 근거 없음 |
| O-3 SQL 4-파일 세트 | hg8-026 (1) | `22_PACKAGE_ARTIFACTS.md:55` "07-29 사용자 지시로 폐기·단일본" ↔ `_tobe/12_metadata_sql.md:32` 표준 · `.claude/rules/02-db-sql.md:23` DBeaver 검사 hook 현행 | 어느 쪽이 현행인지 지정 필요 | 실행 hook `check-dbeaver-sql.ps1` 은 `_DBeaver*.sql` 파일이 있을 때만 검사(생성을 요구하지는 않음) |

### 13-3 DB 조회가 있어야 정할 수 있는 것 — 4건
| id | 내용 | 필요한 확인 |
|---|---|---|
| hg4-024 · hg4-025 | `P_ITEM_ID <> ''` · `NOT IN ('ALL','%','')` 를 권장 패턴으로 적음(Oracle 에서 `''` 는 NULL) | 사내 DB 에서 `SELECT 1 FROM DUAL WHERE 'A' <> ''` · `WHERE 'A' NOT IN ('ALL','')` 행 수 1회 조회 → 0행이면 문서 정정 + 같은 구문을 쓰는 PKG 는 별도 점검 대상 |
| hg4-023 | 미선택 필터 전송값(빈 문자열 ↔ 'ALL') · userGroup | SP 입력 로그 `SCM_SYS_LOG_BATCH.IN_PARA_DATA` 최근 행 조회 |
| hg7-031 | 모달 키 메타 위치(`ATTRIBUTE1` ↔ `CELL_COMBO_DATA_TYPE`) | `SCM_MST_SHEET_COLUMNS` 에서 FPModal 행의 두 컬럼 값 분포 조회 |

- 지적 오류 1건(hg2-006)은 조치 없음.

## §14 보류 건 권장안 반영 (사용자 승인 "권장안 전부 적용" · 2026-11-13 17:56)

- 반영: §13-1 13건 + §13-2 중 권장안 있는 16건 = 29건. 그중 문서를 고친 것 27건(치환 33곳 · 문서 15개), 변경 없이 확정한 것 2건(hg7-001 이미 그 형태 · hg8-025 그대로 둠).
- 최종 상태(240건): 1차 정정 203 · 2차 정정(FIXED_2) 28 · 유지 확정(KEEP) 2 · 남은 보류 6 · 지적 오류 1. 결과 CSV 에 반영. (2차 정정 28 = id 기준 — hg7-019·020 등 한 id 가 여러 자리.)
- 남은 보류 6: hg9-031(진입 페이지 길이 값 지정 필요) · hg8-026(SQL 4-파일 세트 현행 여부 지정 필요) · hg4-023 · hg4-024 · hg4-025 · hg7-031(DB 조회 필요).
- B 묶음은 금지 문장 2곳(`04_store.md` §10 · `ui-category-setup-column-meta.md` §5.2)에 단서를 붙였고, 표준 줄이 있는 `00_SCREEN_ANATOMY.md` · `03_main_component.md` 는 고칠 것이 없어 무변경.
- 변경 전 사본: `Doc/_archive/bak_20261113/rule_body_before_hold/` (17개).
- 확인: 치환 33곳 모두 사전 확인에서 정확히 1회 일치 · 줄바꿈 형식 바뀐 파일 0 · 깨진 문자 0 · `build_router.py --check` rc 0 · `inventory_check.py` PASS · `engine_selfcheck.py` 전체 PASS(17:57). 등록부에 다른 세션 신규 도구 1개 반영(206).
- ⚠ 이 반영으로 **룰과 실제 코드가 다른 곳이 문서에 명시됨**(코드는 손대지 않음 — 보완 후보):
  1. 공용 `SubTitle.tsx:211-228` — Insert/Delete 기본 동작이 살아 있음(룰·CR-070 은 핸들러 있을 때만 노출).
  2. 메타 미응답 시 대체 컬럼/measure 사용 6곳 — `SalesFuturePriceGrid.tsx:215` · `SalesMonitoringGrid.tsx:125` · `MktFcst01Grid.tsx:338` · `CustPsiUploadGrid.tsx:84` · `SalesFuturePrice.tsx:426` · `SalesFuturePrice01.tsx:584`.
  3. measure 호출에 divisionId 미전송 4화면 — sales-future-price · sales-price-model-group · shipment-plan-semi · waterfall-shipment-plan-semi.
  (2·3 의 파일·줄은 하위 점검 보고 기준이며 이번에 직접 다시 열어 보지는 않음.)

## §15 DB 조회로 확인한 보류 4건 (사용자 지시 "DB 조회 진행" · 사내 ZIOUI1 · 2026-11-13 18:00~18:02 · SELECT 만 · 끝에 ROLLBACK)

| id | 조회 | 결과 | 조치 |
|---|---|---|---|
| hg4-024 | `SELECT COUNT(*) FROM DUAL WHERE 'A' <> ''` | **0행** (대조 `'A' IS NOT NULL` 1행) | `oracle-sp-perf-anti-patterns.md` 권장 패턴 3곳에서 빈 문자열 비교 삭제 |
| hg4-025 | `… WHERE 'A' NOT IN ('ALL','%','')` | **0행** (대조 `NOT IN ('ALL','%')` 1행) | 같은 문서 3곳에서 NOT IN 목록의 `''` 삭제 |
| hg4-023 | `SCM_SYS_LOG_BATCH` 의 `P_DMF0082_GET_MAIN_DATA START` 1,705행(2026-10-31~11-12) `IN_PARA_DATA` | 미선택 필터 = `'ALL'`(p_project_code 'ALL' 1,505 · null 149 · 값 51) · **빈 문자열 0행** · `p_item_id` null 1,646 · `p_user_group` 'ADMIN' 1,354 · 'DM ADMIN' 202 · userId 형태 146 | `oracle-perf-fix-priority-order.md` §0.4 에 "§9.5(로그가 정본)가 맞다" 단서 |
| hg7-031 | `SCM_MST_SHEET_COLUMNS` Modal 컨트롤 127행의 두 컬럼 값 | ATTRIBUTE1 채움 25(모달 키와 Division 토큰이 섞임) · CELL_COMBO_DATA_TYPE 채움 18(공백 1칸 16 · 'PROJECT' 1 · 'ITEM' 1) | 표준 미확정 — 실측 분포만 단서로 기재(보류 유지) |

- 주의: hg4-023 의 로그에는 화면 호출과 시험 호출이 섞여 있을 수 있음(구분하지 않고 셈).
- 변경 전 사본 `Doc/_archive/bak_20261113/rule_body_before_db/` (3개). 확인: `build_router.py --check` rc 0 · `inventory_check.py` PASS · `engine_selfcheck.py` 전체 PASS(18:03).
- 최종(240건): 정정 234(1차 203 · 2차 28 · 3차 3) · 유지 확정 2 · 지적 오류 1 · **남은 보류 3**(hg9-031 진입 페이지 길이 · hg8-026 SQL 4-파일 세트 · hg7-031 모달 키 위치).

### 15-1 조회 중 드러난 것 — 사내 PKG 원문의 같은 구문 (문서가 아니라 DB 객체 · 이번 작업 범위 밖 · 미조치)
- `ALL_SOURCE`(OWNER=SCM_MGR · PACKAGE BODY/PROCEDURE/FUNCTION · 주석 줄 제외) 정규식 조회 18:00:
  - 빈 문자열 부등 비교(`<> ''` · `!= ''`) **170줄 / 78개 객체** — 상위: PKG_SDM1010 11 · PKG_SDM2010 6 · PKG_SDM2020 6 · PKG_DMF0003 5 · PKG_DMF0003_01 5 · PR_SCP_XLS_EXCEL_BODY_QUERY 5 · PKG_DMF0008 4 · PKG_SCP0100 4 · PKG_DMF0082 3 · PKG_DMF0053 3 … (백업용 PKG_DMF0082_1104* 등 포함)
  - `NOT IN (…, '')` **8줄 / 8개 객체** — PKG_SCP0039 · PKG_SCP0039_VF · PKG_S39V2~V7.
- 이 줄들이 실제로 결과를 틀리게 하는지는 **미확인**(줄마다 문맥 — 예: `NVL(x,'-') <> ''` 꼴인지, 죽은 분기인지 — 을 봐야 함). 정규식 일치 수일 뿐 결함 수가 아님.

## §16 남은 보류 3건 권장안 (2026-11-13 · 제시만 — 문서 미수정)

| id | 권장안 | 근거(이번 실측) | 반영하면 바뀌는 곳 | 확신 |
|---|---|---|---|---|
| hg8-026 SQL 4-파일 세트 | **단일본(SQL*Plus/SQLcl)이 현행** — DBeaver 변형은 만들지 않는다 | ① 메모리 `feedback_sql_dual_output.md`: 사용자 지시 2026-07-29 "디비버용은 생성하지 않아도 됩니다. 이것도 RULE 로" — 구 4-파일 세트 폐기 ② `_artifacts` 의 .sql 수정 월별: `_DBeaver` 이름 파일 = 05월 31 · 06월 11 · 07월 1 · 08월 0 · 09월 2 · 10월 0 · 11월 0 (일반 .sql 은 10월 1,628 · 11월 503) ③ `22_PACKAGE_ARTIFACTS.md:55` 같은 내용 | `21_TROUBLESHOOTING.md` 3곳(4-파일 세트 안내) · `_tobe/12_metadata_sql.md:32` 에 폐기 단서. `.claude/rules/02-db-sql.md:23` 은 "그런 파일이 있을 때만 검사"로 읽히므로 "(생성 의무 아님)" 1구 추가 | 높음 |
| hg9-031 진입 페이지 길이 | **강제 400줄 · 권장 300줄** 로 통일 (`01_file_structure.md` §1.5.1 값) | ① 강제 400 은 두 문서(01 §1.5.1 · 03 §3.7)가 이미 같음 — 갈리는 것은 권장값뿐(300 / 200 / 250) ② reference 3화면 진입 페이지 실측: DMF0004 412줄 · DMF0005 327줄 · DMF0006 201줄 → 권장 200·250 은 reference 2개가 넘음 ③ 진입 페이지 142개 실측: 중앙값 366 · 200 이하 21 · 250 이하 36 · 300 이하 47 · 400 이하 82 · 최대 1,848 | `03_main_component.md` §3.7·§4 의 200·250 권장 → 300 · `01_file_structure.md` §3.2 "200 lines 이상 분할 의무"에 "진입 페이지는 §1.5.1(400 강제)" 단서 | 중간 — 300 이라는 값 자체는 문서 값 중 고른 것이며 측정으로 정해진 값이 아님. ⚠ 강제 400 을 넘는 진입 페이지가 60개(142-82), reference DMF0004 도 412줄 |
| hg7-031 모달 키 메타 위치 | **표준 = `CELL_COMBO_DATA_TYPE`** · `ATTRIBUTE1` 은 모달 키로 쓰지 않음(기존 값은 과도기 병행) | ① 기존 룰이 이미 lookup 메타 표준 위치를 `CELL_COMBO_DATA_TYPE` 으로 정함(`column-lookup-meta-standard.md:30-37·156` "ATTRIBUTE1 아님" · `screen-completion-gate.md` G3) ② `ATTRIBUTE1` 은 사내 DB 에서 Division 토큰('81,82' 5 · '40,81,82' 2 · '40' 2 등)과 모달 키('PROJECT' 3 · 'ITEM' 3 등)가 섞여 있음 ③ 화면 코드 주석에 충돌 사고 기록: `MktFcstGrid.tsx:353-354` "corp attribute1 이 'ITEM' modalKey 를 division 토큰으로 덮어 Model popup 깨지던 사고" | `ui-category-setup-column-meta.md:508`(표) · :481(예시 `_modalKey: sc.attribute1 ?? …`)을 `cellCboDataTp` 우선으로 · 과도기 문구 추가 | 중간 — 미확인 2가지: 현재 서버가 Division 필터에 어느 컬럼을 쓰는지(BE java 에 `isDivisionAllowed` 없음 — SP 쪽 미조회) · `CELL_COMBO_DATA_TYPE` 실제 값은 Modal 127행 중 2행뿐('PROJECT' 1 · 'ITEM' 1)이라 표준으로 정하면 메타 데이터 14행 안팎 이관과 화면 4곳 이상(`attribute1` 로 모달 키를 읽는 Grid) 보완이 뒤따름 |

- 세 건 모두 문서만 고치면 룰은 정리되지만, 2·3번은 룰과 다른 코드·데이터가 남는다(코드·DB 는 이번 범위 밖).

## §17 남은 보류 3건 반영 (사용자 승인 "3건 반영" · 2026-11-13)

- §16 권장안대로 문서 6개 · 치환 14곳 정정(사전 확인 14곳 모두 정확히 1회 일치). 변경 전 사본 `Doc/_archive/bak_20261113/rule_body_before_last3/`.
- 대상: `21_TROUBLESHOOTING.md` 3곳 · `_tobe/12_metadata_sql.md` 3곳 · `.claude/rules/02-db-sql.md` 1곳(SQL 단일본) / `_tobe/03_main_component.md` 4곳 · `_tobe/01_file_structure.md` 1곳(진입 페이지 강제 400 · 권장 300) / `ui-category-setup-column-meta.md` 2곳(모달 키 표준 = CELL_COMBO_DATA_TYPE).
- 최종(240건): 정정 237(1차 203 · 2차 28 · 3차 3 · 4차 3) · 유지 확정 2 · 지적 오류 1 · **남은 보류 0**.
- 룰과 다른 코드·데이터로 남는 것(미조치 · 보완 후보): 강제 400줄 초과 진입 페이지 60개(142개 중 · reference DMF0004 412줄 포함) / 모달 키가 ATTRIBUTE1 에 있는 메타 행과 `attribute1` 로 모달 키를 읽는 화면 Grid.

## §18 룰 본문 정정, 검토 등급 250건 (사용자 지시 "검토 등급 250건 정정 진행", 2026-11-13 18:45~21:48)

- 결과: 정정 132, 이미 반영 1, 보류 66, 지적 오류 46, 이력 줄 5. 합 250, 입력 id 누락 0.
- 건별 목록: `2026-11-13_RULE_BODY_REVIEW_RESULT.csv` (id, 파일, 상태, 변경 전후, 근거).
- 변경 파일 97개(백업 133개 중), 변경 덩어리 178개. 줄 수 감소 0, 깨진 문자 0, 대상 외 룰 문서 변경 0.
- `request-ledger-and-subclause-mapping.md` 는 섞여 있던 CRLF 1줄이 LF 로 바뀜(97줄 중 1줄).
- 변경 전 사본: `Doc/_archive/bak_20261113/rule_body_before_review/` (133개).
- 18:50 무렵 세션이 끊겨 8개 묶음이 멈춤. 19:02 에 멈춘 지점부터 재개해 9개 묶음 모두 결과 파일을 남김.
- 재대조: 정정 132건 모두 해당 파일에 변경 있음. 127건은 지적 줄 ±8 안. 5건(r1-005, r5-011, r7-004, r9-005, r9-014)은 같은 문서의 다른 줄에서 정정했고 내용을 직접 확인함.
- 지적 줄과 떨어진 변경 37곳 중 표식 없는 28곳: 용어 대사표 → 대조표 치환 25곳(파일마다 첫 자리 1곳에만 표식), 그 밖 3곳은 표식이 줄 안쪽에 있거나 빈 줄 추가.
- 정정 내용의 옳고 그름은 전수 재확인하지 않음. 하위 점검이 남긴 근거(CSV evidence 열)에 의존.
- 확인: `build_router.py --check` rc 0, `engine_selfcheck.py` 전체 PASS, `verify_hooks.ps1` FAIL 0, `inventory_check.py` PASS(21:4x, 다른 세션 신규 도구 2개 등록부 반영 후).

### 18-1 주제별

| 주제 | 정정 | 보류 | 지적 오류 | 이력 줄 | 이미 반영 |
|---|---:|---:|---:|---:|---:|
| 01 pnpm·lint·type-check 실행 요구 | 5 | 3 | 2 | 0 | 1 |
| 02 NULL 대체값 '-' ↔ '/' | 1 | 3 | 3 | 0 | 0 |
| 03 상대경로 import 예시 | 2 | 2 | 2 | 0 | 0 |
| 04 작업 모드(11-02) 미반영 | 8 | 0 | 0 | 0 | 0 |
| 05 앱 계정명 SCMD_APP ↔ SCMP_APP | 3 | 4 | 0 | 1 | 0 |
| 06 용어 대사표 | 15 | 0 | 4 | 0 | 0 |
| 07 검증 기본 계정 | 0 | 0 | 2 | 0 | 0 |
| 08 CLAUDE.md 옛 절 번호 | 11 | 2 | 4 | 1 | 0 |
| 09 완료 게이트 수(8·10·11) | 1 | 1 | 1 | 0 | 0 |
| 10 없는 파일·컴포넌트·함수 참조 | 19 | 0 | 0 | 1 | 0 |
| 11 확정 룰(CR) 미반영 | 28 | 13 | 9 | 0 | 0 |
| 12 문서 간·문서 내 값 불일치 | 27 | 31 | 19 | 2 | 0 |
| 13 기타 | 12 | 7 | 0 | 0 | 0 |

### 18-2 보류 66건 (결정 또는 추가 확인 필요)

| id | 파일 | 사유 |
|---|---|---|
| r1-017 | `asis-grid-cell-event-full-extraction.md` | 행 키로 apiClient.getCombo 를 다시 부르는 코드가 정본 화면에 있음: nscm-fe/features/demand/src/pages/forecast-price/components/ForecastPriceGrid.tsx:441, 583, 615, 653, 787. be-api-contract-ui.md:46 은 getCombo 를 legacy 로 분류. 두 방식이 코드에 함께 있어 어느 쪽을 표준 문장으로 둘지 문 |
| r1-020 | `cascade-combo-filter.md` | 5-G 가 정본으로 든 SalesFuturePriceGrid.tsx:267~276 주석은 2026-09-01 부터 공용 DataGrid 가 컬럼 메타(PARAM2, PARAM10)로 행별 후보를 처리하고 편집 진입 시 col.dataMap 스왑을 금지한다고 적음. ForecastPriceGrid.tsx:1345, 1382 는 dataMap 을 교체함. 문서 2종과 코드 2종이 서로 달라 표준 방식 결정이 필요함. 5-G.1 표 |
| r1-022 | `cascade-pattern-check.md` | asis-coverage-check.md:27 의 총합 비교 폐지는 Event 축 게이트 판정식 대상. 이 hook 은 §3(64~81행)에 sub-pattern 별 대조 표를 PR 게이트로 두고 16, 60행 건수 비교는 POST-WRITE 점검임. 폐지 조항이 이 점검까지 적용되는지 문서로 판별 불가 |
| r1-023 | `cascade-pattern-check.md` | r1-020 과 같은 사안. 행별 후보 처리 방식이 문서(beginningEdit 스왑)와 코드(SalesFuturePriceGrid.tsx:275 스왑 금지, 공용 DataGrid 메타 처리)에서 다름. _tobe/07_datagrid.md:539, 607 도 전체 grid 로 적음. 대체 문장을 정할 근거 부족 |
| r1-024 | `cloud-deploy-silent-failure-gates.md` | 제목 6계보, 24행 절 제목 5계보(2026-08-27 실측), 표 S1~S7 7행(S7 은 2026-08-28 추가, S6 은 부수). 어느 수가 현행 기준인지 문서에 정의 없음. hook 제목 줄은 수정 대상에서 제외 |
| r1-027 | `corp-meta-integrity-and-wiring.md` | 30행 값은 실제 적용 스크립트와 일치: _artifacts/_apply_corporate/28_sys0013_role_save_wiring.py:27 (API_ID=API_SYS0013_SAVE_USER_GROUP), :37 (API_TP_CD='POST'). be-infrastructure-reuse.md:117 은 'SAVE'. 두 값이 저장소에 함께 있고 DB 실값은 미조회 |
| r1-028 | `corp-meta-integrity-and-wiring.md` | 124행은 배포 패키지에 locales 변경 파일을 '명시'하고 README 에 기재하라는 문장. cloud-ui-db-object-fetch.md:42 는 locale JSON 이 git 경로이며 DB 패키지 범위 외라고 적음. '명시'가 목록 기재인지 파일 동봉인지 문서로 판별 불가 |
| r2-004 | `framework-foundation-entry.md` | reference DMF0005 SalesSiteProjectModelGrid.tsx:19 가 '../../../components/ownerModal/owner-modal.constants' 상대 import 를 쓰고 hook #42 relative-import-order 도 현존. REV_BRIEF 는 '../../../components' 를 비상대 경로로 바꾸라 함 — 패키지 내부 상대 import 허용 범위를 코드로  |
| r2-005 | `grid-cell-interaction-patterns-mandatory.md` | features/master/src/components/index.ts 는 OwnerModal 만 export 하고 owner-modal.constants(MODAL_OWNER)는 export 하지 않음(:11-12). 'features/master/src/components' 로 바꾸면 MODAL_OWNER 를 못 가져옴. 깊은 비상대 경로 사용례는 저장소에서 미확인. reference SalesSiteProjectModel |
| r2-013 | `db-corporate-apply.md` | CR-076(confirmed_requirements.csv:77)의 condition 은 'CheckList(정합검증) 실행' 중 syn_fix 자동 시노님 추가. 인용 줄은 화면 이관 패키지의 GRANT/SYNONYM 적용 순서 — 적용 맥락이 달라 CR-076 을 이 절차에 그대로 옮길 근거 없음 |
| r2-017 | `grid-column-setting-popup-pattern.md` | 이 문서가 참조 구현으로 든 contribute-view 에서 visibleBaseColumns 경로가 제거됨(ContributeViewGrid.tsx:91 '구 visibleBaseColumns 경로 제거', useContributeViewStore.ts 에 visibleBaseColumns 0건). §1 전체가 현행 코드와 달라 한 줄 정정으로 맞출 수 없음 — 절 단위 재작성 판단 필요 |
| r2-018 | `grid-column-setting-popup-pattern.md` | 현행 ContributeView.tsx:246 onSave 는 clearGridOnSettingChange → applyColumnLayout → saveTitleSet 구조로 문서 예시와 다름(handleColumnApply 0건). ColumnSettingModal.tsx:320-326 handleOk 는 변경 여부 판단 없이 onSave 호출 — CR-045 와 맞는지는 화면 쪽 구현에 달려 있어 문서 한 줄로 확정 불가 |
| r2-020 | `deploy-package-completeness.md` | §3 은 없는 행을 채우는 사후 보강, §4.5-2 는 MERGE 가 ORA-00001 을 내는 PROC_M 이관 방식 — 대상 상황이 다른 두 규정이 같이 있음. PROC_M 보강에 어느 쪽을 쓰는지는 문서·코드로 확정 불가(proc-meta-signature-match.md:252 는 순서 교정에 DELETE+INSERT). 같은 줄의 '4-파일 세트'·§2 의 _DBeaver 는 이번 지적 범위 밖이라 손대지 않음 |
| r2-021 | `destructive-git-ops.md` | 문서 안 두 표기뿐이고 Doc/_dev_rules/28_GIT_MULTI_REMOTE.md 에 stash 절차 없음 — 어느 쪽이 맞는지 저장소 근거 없음 |
| r2-028 | `db-corporate-apply.md` | _artifacts/_apply_corporate/apply.sh:38 이 지금도 docker exec -i nscm-oracle sqlplus 로 적용하고 Doc/_dev_rules/32_CLAUDE_ORACLE_DIRECT.md:55 옵션 C 도 docker exec 를 둠. 로컬 instantclient·Docker 금지는 저장소 룰 파일에서 미확인(메모리 색인에만 있고 'DB Docker 금지 — 09-21 해제' 표기 |
| r3-002 | `menu-not-displayed-debug.md` | UNIT_TP_CD 의 '-' 가 실값인지 NULL 대체값인지 저장소 파일로 판별 불가(DB 조회 필요). Doc/_rules_v2/_tobe/12_metadata_sql.md:86,88 은 컬럼 목록만 있음 |
| r3-008 | `grid-insert-and-modal-derived-parity.md` | G-I2 는 신규행이 키를 보유하는지를 묻고 CR-096(confirmed_requirements.csv:97)은 공용 모달 호출 인자를 다룸. 공용 모달 대상 화면에서 두 기준이 겹치는 범위를 문서·코드로 판별 못 함 |
| r3-011 | `i18n-ko-en-alignment.md` | 문서 근거는 사용자 명시 요구 2026-06-12(L3~4). 현행 KO.json 은 한글 문구 다수(예 KO.json:758,760,825). 사용자 지시와 현행 데이터 중 어느 쪽이 현재 기준인지 확정 기준·CR 에 없음 — 사용자 결정 필요 |
| r3-013 | `localstorage-persist-pattern.md` | CR-001·CR-058(confirmed_requirements.csv:2,59)에 저장 위치 명시 없음. nscm-fe/features/demand/src/pages 의 *.tsx 에서 localStorage.setItem/getItem 0건(Grep)이나 현행 저장 위치를 코드로 확정하지 못함 |
| r3-014 | `menu-not-displayed-debug.md` | CR-102(confirmed_requirements.csv:103)는 권한 판정 기준이고 인용은 진단 예시 SQL. SCM_ADM_USER_GR_MNU_MPG_M 의 컬럼 구성은 DB 조회 없이는 미확인(nscm-be/src/main/resources Grep 0건) — GR_ID 조건을 빼는 정정의 근거 부족 |
| r3-015 | `modal-callback-cascade-check.md` | CR-072(confirmed_requirements.csv:73)는 팝업 입력 셀의 노랑 표시 기준이고 신규행 한정 가드 여부는 화면별 AS-IS 에 달림. 가드 의무 범위를 좁힐 근거를 CR·코드에서 확인 못 함 |
| r3-020 | `menu-not-displayed-debug.md` | menu-button-dynamic-fetch.md:143 · _tobe/12_metadata_sql.md:232 는 USER_GR_ID 컬럼으로 적음. 실제 테이블 컬럼은 DB 로만 판별 — nscm-be/src/main/resources Grep 0건. FIX_BRIEF 규칙 1(DB 판별 = HOLD) |
| r3-023 | `oracle-cmbo-varname-quote.md` | L56~57 은 1차 정정(11-13)이 들어간 자리. messaging-api-and-search-fields-mandatory.md:165~166 의 FE quoting 과 SQL 쪽 TO_CHAR wrap 이 병행 처방인지 대체 처방인지 BE 코드 실행 없이 판별 못 함 |
| r4-001 | `oracle-perf-fix-priority-order.md` | 조회 시점 스테이징 정규화 예시. 센티널 기준은 신규 '/' 이고 원래 '-' 데이터는 유지인데, 이 예시는 NULL·''·'--' 를 기존 '-' 로 합치는 용도라 '/' 로 바꿀지 코드로 판별 불가. 같은 문서 :435 R3·:449 IN ('-','--') 확인 |
| r4-003 | `oracle-sp-perf-anti-patterns.md` | 표준 DDL 예시에 환경(사내/클라우드) 표기 없음. cloud-deploy-silent-failure-gates.md:60 은 (SCMP_APP, SCMD_APP) 둘 다 GRANT 대상으로 적음. 사내 문맥 한정으로 볼 근거 없음 |
| r4-012 | `popup-modal-and-routing-mandatory.md` | master RegionModal.tsx:52-79 실물은 클라이언트 필터가 아니고 Search 시 프로시저(country/city IN 파라미터) 재조회. 예시와 §3.2 "클라이언트 측 필터" 표준 문장을 함께 바꿔야 해 최소 수정 범위를 넘음. 콤마 다중값(CR-083) 처리는 SP 쪽이라 DB 조회 없이 미확인 |
| r4-013 | `pre-submit.md` | CR-070(csv:71)은 버튼 노출 조건(기능 있음 + 권한 있음). BTN_MPG 메타 행을 기능 없는 버튼까지 등록할지는 CR-070 문장과 코드로 판별 불가(메타 등록 기준은 DB 쪽) |
| r4-015 | `oracle-perf-fix-priority-order.md` | §1(:120) 2순위 = 테이블 함수 → GTT 선적재. 같은 문서 :40·:278 에 2순위 삽입으로 번호가 밀렸다는 1차 정정 기록. R2 가 현행 1순위(구조)·3순위(구문 변경) 중 어느 쪽인지 문서와 코드로 판별 불가 |
| r4-016 | `oracle-save-payload-integrity.md` | 다른 hook 의 ALL_SOURCE 는 OWNER=SCM_MGR 조건이 붙어 있어 문장끼리 충돌하지 않음. USER_SOURCE 가 현 접속 계정에서 SCM_MGR 본문을 보여주는지는 DB 조회 필요. _artifacts/_diagnostics/ora.py 에 _SOURCE 문자열 0건 |
| r4-018 | `oracle-sp-perf-anti-patterns.md` | oracle-perf-fix-priority-order.md:138 "GTT 는 원칙적으로 제외"는 튜닝 4순위(인덱스 추가) 조건, 이쪽은 GTT 생성 시 DDL 기준. 두 문서 주장만 있고 코드로 판별 불가 |
| r4-019 | `oracle-sp-perf-anti-patterns.md` | 둘 다 실사용: _artifacts/_deploy_packages/DMF0003_*/sp 에 GT_GGET_SPLIT_* · _artifacts *.sql 에 GT_DMF0082_PARAM_TOKEN 15,245회, GT_DMF0020_PARAM_TOKEN 1,072회. 맥락별 병존 |
| r4-020 | `popup-modal-and-routing-mandatory.md` | RULESET_MASTER.md:272 카탈로그 #35 도 T01/T13 로 적혀 hook 과 일치. TRIGGER_ROUTER.md:25·:28·:32 매트릭스는 T06 에 이 hook, T09 메뉴, T13 CSV 적재. 정본 안에서 어긋나고 정본은 읽기 전용 |
| r4-025 | `oracle-sp-perf-anti-patterns.md` | 5초(SP 호출)·30초(:897 PROFILER step)·2초(oracle-perf-fix-priority-order.md:116 호출별 튜닝 대상)는 측정 단위와 용도가 다름. 통일 값을 정한 사용자 확정·코드 근거 없음 |
| r5-003 | `screen-meta-and-permissions-mandatory.md` | gen:i18n 은 차단 목록에 없음(block-dev-commands.ps1:40 pnpmSubs) · 스크립트 실재(nscm-fe/package.json:41 node scripts/sync-i18n.mjs). 로컬 pnpm 금지가 gen 스크립트까지 포함하는지 확정 기준·코드로 판별 불가. 같은 내용 :234 · :286 |
| r5-009 | `screen-create-checklist.md` | 패키지 구성 표기가 문서마다 다름: screen-completion-gate.md:24 (5종 DDL/META/SP body/GRANT/i18n) · scmd-app-grant-mandatory.md:94-103 ({SCREEN}_v1_full/03_META) · deploy-package-completeness.md:68 (6-종 인벤토리). 어느 쪽이 현행인지 코드로 판별 불가 |
| r5-015 | `screen-create-checklist.md` | 1차 정정 표식이 있는 줄(2026-11-13 정정: Doc/_rules_v2/CLAUDE.md → 루트 CLAUDE.md). 같은 자리 재수정은 REV_BRIEF 에 따라 보류. 남은 불일치: CLAUDE.md §3 은 TRIGGER_ROUTER 4단계 라우팅이고 00_INDEX 는 카탈로그가 필요할 때만 열도록 함 |
| r5-019 | `screen-combo-validation-message-mandatory.md` | CR-030 원문은 '조회조건 콤보 후보'(confirmed_requirements.csv:31). 이 예시는 모달/Form select 용(같은 파일 §1.4 :79). CR-030 이 모달 Form 콤보에 적용되는지 원문으로 판별 불가 |
| r5-021 | `screen-grid-edit-merge-and-meta-mandatory.md` | 문장은 클릭·포커스로 병합이 풀리는 요구를 확인하라는 내용이고 CR-031(신규 행 입력·붙여넣기 중 병합 해제, confirmed_requirements.csv:32)을 막지 않음. 이 파일과 wijmo-merge-row-data-only.md 에 CR-031 언급 0건(Grep). CR-031 구현이 행 데이터 기준인지 코드 미확인 |
| r5-023 | `screen-analysis-workbook-standard.md` | 개정내역 표 폐지(:108 2026-07-20 사용자 지시)는 §1-C UI분석서 개요에 적힌 것. :153 · :161 은 설계서·분석서를 한 줄에 묶어 '개요 개정내역 표 폐지'라고 적음. 폐지가 화면설계서(§1-A :48)에도 적용되는지 본문으로 판별 불가 |
| r5-029 | `screen-runtime-pitfalls-mandatory.md` | DMF0043 실제 코드는 접두 분기를 쓰지만 판정은 e.cancel = !isRowEditable(행) 으로 EDIT_FLAG='Y' 행만 허용(2026-08-11 사용자 요구): nscm-fe/features/master/src/pages/contribute-main/components/ContributeMainGrid.tsx:256-271. 문서 §7 은 EDIT_FLAG 우회(cancel=false 고정)라 코드와 다름 |
| r5-030 | `screen-runtime-pitfalls-mandatory.md` | 2 인자 형식 의무(screen-conventions-mandatory.md:335)와 다른 것은 맞음. LBL00366 실제 값은 'Search User Info'(nscm-fe/public/locales/EN.json:651)로 OK/Save 가 아님. 정본이라 한 ExchangeRateModal.tsx 에 LBL00366 없음(Grep). 맞는 라벨 코드·fallback 을 확정할 근거 없음 |
| r6-001 | `sdm-domain-development-standard.md` | 실행 hook .claude/hooks/block-dev-commands.ps1:40 차단 목록에 gen:i18n 없음(:43 정규식도 불일치) · nscm-fe/package.json:41 에 gen:i18n 스크립트 실재(node scripts/sync-i18n.mjs) · 확정 기준은 lint·type-check·build 만 명시 — 이 명령이 직접 실행 금지 대상인지 판별 근거 없음 |
| r6-009 | `sdm-domain-development-standard.md` | 'E2E 시나리오 등재+8축'이 2026-11-04 폐지된 E2E 메뉴 단계와 같은 것인지 저장소 파일로 확인하지 못함(근거가 메모리 색인뿐) · 코드 블록 안 절차 줄 |
| r6-019 | `sheet-columns-meta-completeness.md` | sheet-name-asis-preserve-mandatory.md:11~16 과 방향이 엇갈릴 수 있으나 '구 PascalCase' 시트가 AS-IS 등록명인지(DMF0072 NNMasterMapping 등)는 DB 조회로만 판별 — DB 미조회 원칙 |
| r6-020 | `sheet-columns-meta-completeness.md` | 주석 앞 컬럼 12개(:50~52) vs :172 목록 13개(HORIZONTAL_ALIGN_CODE 추가) 불일치는 실재 — 실제 NOT NULL 수는 SCM_MST_SHEET_COLUMNS desc(DB)로만 판별 · 저장소 hook(.claude/hooks/check-meta-sql.ps1)에도 NOT NULL 목록 없음 |
| r6-021 | `sp-dual-cursor-pattern.md` | sp-cursor-name-response-key.md:57,61(단일 cursor SP 도 규약 유형 · SP 별)과 엇갈리나 본 hook 트리거는 '신규 GET SP 작성'(:3) — 신규 의무 vs 기존 현황 설명인지 코드로 판별 불가. 참고: :135~139 · :173 의 'o_rc 만' 단정은 1차 정정(:104 SP 별)과 같은 종류로 남아 있음(배정 인용 밖 · 미수정) |
| r6-022 | `sp-dual-cursor-pattern.md` | sp-exception-handler-debug-friendly.md §3(:55~68 로그 후 RAISE)과 패턴이 다르나 GET SP 한정/전체 SP 범위 중 어느 쪽이 현행 표준인지 확정 기준·코드로 판별 불가 |
| r6-023 | `sp-dual-cursor-pattern.md` | sp-deploy-verify-target-object.md:39~41 은 특정 standalone 잔재의 오탐 주의 서술이고 sdm-domain-development-standard.md:22 는 SDM 한정 — '신규 GET SP 는 반드시 PKG' 라는 전 도메인 기준 문장을 .claude/rules/02-db-sql.md 등에서 찾지 못함. 본 hook 의 주제는 커서 시그니처 |
| r7-001 | `sp-patch-file-deploy.md` | 이 절은 클라우드 적용 검증(문서 :3 "클라우드 적용 시", :105 "클라우드 SQL client"). 클라우드 계정명은 저장소에서 미확인. scmd-app-grant-mandatory.md:64·175 는 클라우드 BE=SCMD_APP 로 기술, CR-076 은 SCMP_APP |
| r7-013 | `ui-layout-shell-modal-feedback-standard.md` | CR-044(컬럼 즉시 재구성)와 충돌 없음. CR-045 는 "변경 없이 Save/OK 시 재조회 안 함"이고 이 절도 자동 재조회 금지(:145). 변경 없는 OK 때 그리드를 비우는지는 CR 문구로 판별 불가. confirmed_requirements.csv:45-46 |
| r7-021 | `type-check-error-patterns.md` | nscm-fe/configs/types/procedures.d.ts 에 요청 키 menuId 17건, mnuId 40건이 함께 쓰임(SP 별 COL_NM). BaseService.java:472·656 은 mnuId. 병존이라 한쪽으로 통일 불가 |
| r7-023 | `ui-dynamic-property-management.md` | ui-category-setup-no-arbitrary-data.md:28·44 는 다른 화면 메타 복사 금지, subtitle-button-actions-mandatory.md:44 는 같은 메뉴·시트 SAVE 권한 복사. 자매 화면 복사 허용 여부는 문서 주장뿐이고 코드로 판별 불가 |
| r7-025 | `ui-common-testitem-mapping-axis.md` | hook 파일 request-ledger-and-subclause-mapping.md 와 Doc/단위테스트_보완대상/보완요청_원장.md 실재, hook 본문에 폐기·대체 표기 0건. 2026-10-30 CheckList 단일화가 #139 원장을 대체했다는 근거 미확인 |
| r8-004 | `wijmo-insert-cell-dropdown.md` | L19 는 1차 정정(절 번호 §6→§4) 표식이 붙은 줄 — REV_BRIEF '1차 정정 문장·표식은 건드리지 않는다'. 같은 줄에 lint·type-check 단서를 더 붙여야 하는지는 미결 |
| r8-007 | `02_DEVELOPMENT_RULES.md` | 10.34.220.81 ESSCMD 는 사내 ZIOUI1 이 아닌 환경의 접속 예시 — 이 환경의 앱 계정명은 저장소에서 미확인(REV_BRIEF: 클라우드 문맥 계정명 미확인이면 HOLD). 접속 값 자체는 평가 대상 아님 |
| r8-014 | `32_CLAUDE_ORACLE_DIRECT.md` | 상시 허용 지시는 메모리 색인에만 있고 FIX_BRIEF·REV_BRIEF 확정 기준에 없음. CLAUDE.md §1-6 은 '승인된 절차(T18)만' — 룰 문서 기준으로 어느 쪽이 현행인지 판별 불가 |
| r8-026 | `22_PACKAGE_ARTIFACTS.md` | 28_GIT_MULTI_REMOTE.md L174~184 는 '이 PC 에서는 사내 GitLab push 안 함 · 별도 PC 로 수동 복사'. 22 는 '검토' 권고 문장이라 양쪽 문서 주장만 있고 어느 쪽이 현행 운영인지 코드·파일로 판별 불가 |
| r8-027 | `30_LOCAL_BACKUP_RESTORE.md` | §2 표 머리글은 '예상 크기'로 표기돼 있음. §3.5 수치가 실측인지는 manifest.json 이 없어 미확인(같은 파일 L139 1차 단서: D:\NSCM_backup\·_backup_metadata 폴더 현재 없음) |
| r8-028 | `31_FIGMA_DESIGN_INTEGRATION.md` | '~120 req/min' 은 외부 서비스 수치라 저장소에서 확인 불가. §6.2 는 엔드포인트별 pool 실측(2026-05-30)이라 어느 쪽으로 맞출지 근거 없음 |
| r8-029 | `32_CLAUDE_ORACLE_DIRECT.md` | 접속 값은 평가 대상 아님(지적 자체가 '값은 평가하지 않음'). 같은 파일 L84 가 '기존 평문 잔존분은 점진 제거 대상'으로 이미 적음. 현행 접속 값은 DB·.env 로만 확인되므로 문서 값을 고치지 않음 |
| r8-034 | `32_CLAUDE_ORACLE_DIRECT.md` | Test-Path C:\oracle\instantclient_23_0\sqlplus.exe = False(2026-11-13 18:50) — 메모리 색인의 경로에서 sqlplus 실재를 확인하지 못함. 현행 sqlplus 실행 경로 미확인 |
| r8-035 | `ui-selfcheck-runtime-mandatory.md` | CheckList 단일 기준 전환(10-30·11-04)은 메모리 색인에만 있고 FIX_BRIEF·REV_BRIEF 확정 기준에 없음. 이 hook 의 3 산출물 요구를 대체하는지 룰 문서로 판별 불가 |
| r8-036 | `verification-completion-honesty.md` | r8-035 와 같음 — CheckList 기준 전환이 완료 판정식(§2)·HTTP E2E 의무를 대체하는지 확정 기준·룰 문서에 근거 없음 |
| r8-037 | `verification-completion-honesty.md` | 22_PACKAGE_ARTIFACTS.md:11·258 은 패키지 생성 후 클라우드 사용자 적용. 이 hook 은 '승인 후 클로드 적용' — 승인 절차가 따로 남아 있는지 룰 문서로 판별 불가(.claude/rules/02-db-sql.md 에 적용 주체 규정 없음) |
| r9-001 | `13_routing_menu.md` | 실제 SQL _artifacts/73_SYS0015_PROGRAM_full_create.sql:122 · 75_SYS0014_GroupUser_full_create.sql:119 도 admin 메뉴 UNIT_TP_CD '-' (DMF 메뉴는 'D' — 40_Register_5_DMF_Menus:77). '-' 가 NULL 대체값인지 단위 유형 코드값인지 저장소로 판별 불가(DB 조회 필요) → 미수정 |
| r9-019 | `10_popup_modal.md` | Grid 호출처가 false(CustomerModelMappingGrid.tsx:366,383)와 true(NnMasterMappingGrid.tsx:372,390)로 병존. ProjectByDivisionModal.tsx:61 · ItemByDivisionModal.tsx:140 은 값을 받기만 하고 쓰지 않음(_callFromCell · 2026-07-03 주석 :205-207). 어느 값이 표준인지 코드로 판별 불가 |

### 18-3 지적 오류 46건 (조치 없음)

| id | 파일 | 사유 |
|---|---|---|
| r1-001 | `comment-live-code-discrimination.md` | 문자열 리터럴 안 '--' 가 주석이 아니라는 함정 예시임. IN ('-','--') 는 저장소 SQL 에 있음: _artifacts/_deploy_packages/CLOUD_ORA12704_NCHARUNION_20260831/02_PKG_DMF0021_BODY.sql:594, 1211, 1247 (PLANTNORM 다중 센티널 흡수). 센티널 표준값을 정하는 문장이 아님 |
| r1-008 | `auth-by-userid-not-groupid.md` | 91행은 §5 의 A(다중그룹), B(무권한) 2축에 쓸 계정을 로스터에서 고르라는 문장임. 15계정 전수 실행 요구 없음(84~91행). 기본 1계정 기준과 어긋나지 않음 |
| r1-019 | `atomic-design-components.md` | SubTitle.tsx 핸들러는 Hotkeys.F1~F10 (sub-title/SubTitle.tsx:183~229). Excel 내려받기는 F11 (foundation/src/utils/gridAction.ts:1129). foundation, sub-title 폴더에 F12 없음. F1~F11 표기가 코드와 일치. 어긋난 쪽은 asis-button-mapping.md:50 의 F12 표기이며 이 행의 대상 문장이 아니라 미 |
| r1-021 | `cascade-combo-filter.md` | 같은 문서 63행이 적용 조건을 나눠 적음. 57행은 일반 위치, §1.4.1 은 Search 버튼으로만 조회하는 persist 화면 한정이며 effect 분리 이유(중복, 경합 방지)를 명시. 45행은 하위 combo reset 대상 문장 |
| r1-026 | `corp-meta-integrity-and-wiring.md` | .claude/rules/00-fe-screen.md E 가 apiClient.post(call-proc) 호출을 판정 조건과 함께 허용. be-infrastructure-reuse.md:138 의 금지 대상은 custom endpoint 직접 작성. 33행은 메타 배선된 generic call-proc 경로 설명 |
| r2-002 | `deploy-package-completeness.md` | §1.6 은 이관 직후 DUMP 가 사내 DUMP 와 일치하는지 보는 절차(기대값 = 사내 실측). 해당 행은 2026-06-15 SYS0013 DIVISION_ID 사고 패턴 서술이고 원래 '-' 인 기존 데이터는 유지 대상 — 같은 문서 §1.0 표 ② |
| r2-008 | `deploy-package-completeness.md` | 2026-10-21 지시는 '대사표' 단어를 '대조표' 로 바꾸는 것(산출물 이름). 인용 줄에 '대사표' 없음 — '분포 대사'·'1:1 대사' 는 수치 맞춰 보기 동작을 가리키는 말이라 지시 범위 밖 |
| r2-009 | `dept-id-derivation-standard.md` | r2-008 과 같은 사유 — '대사표' 단어 없음. G150-5 는 게이트 항목 이름 |
| r2-015 | `grid-cell-interaction-patterns-mandatory.md` | 이 절은 본문 hook 을 가리키는 요약이고, 본문 wijmo-merge-row-data-only.md:31 에 1차 정정으로 'CR-031 과 충돌하지 않는다' 가 적혀 있음 |
| r2-016 | `grid-column-meta.md` | CR-072(confirmed_requirements.csv:73)는 팝업 입력 셀 배경색(노랑) 판정 룰이고 팝업 열림 가드 룰이 아님. reference SalesSiteGrid.tsx:74·105, SalesSiteCustomerGrid.tsx:65, SalesSiteLocationGrid.tsx:41 이 CRUD_TYPE.INSERT 가드를 씀 · _tobe/07_datagrid.md §3.5 |
| r2-024 | `feature-button-meta-completeness.md` | 7번째가 '화면특화'(예 STATUS_UPDATE) 열린 범주라 FORM_DATA·UPLOAD·UPLOAD_SAVE 는 여기에 든다. packages/foundation/src/constants·packages/shared/src/hooks 에 버튼 코드 고정 열거 없음(FORM_DATA·UPLOAD_SAVE 0건) |
| r2-026 | `grid-cell-interaction-patterns-mandatory.md` | reference 3화면 Grid 컴포넌트(sales-site/components, sales-site-project-model/componenets, customer-model-mapping/components)에 useTabProcQuery 0건 — 인용 줄이 reference 와 일치. 충돌 상대인 grid-column-setting-popup-pattern §1.2 가 구 코드 서술(r2-017 HOLD) |
| r3-003 | `oracle-db-workflow.md` | oracle-save-payload-integrity.md:63,65,66 — DMF0020 div 82 PLANT_SITE_ID 는 실데이터 전량 '-' 이고 기존 데이터와 같은 값을 채우라는 뜻. 원래 '-' 인 데이터 유지 기준(oracle-null-sentinel-and-notnull-default.md:36)과 일치 |
| r3-016 | `msg-id-asis-tobe-conversion.md` | nscm-fe/public/locales/KO.json:760 MSG00668 = 'Edit Mode 에서는 수행할 수 없습니다.' · :758 MSG00662 = '조회 후 수정모드로 가능합니다.' — 표는 AS-IS 문구와 같은 문구의 TO-BE ID 대응이고 표시 의무(CR-022·CR-103)를 정하는 표가 아님 |
| r3-022 | `msg-id-asis-tobe-conversion.md` | msg-table-cloud-sync-and-insert-only.md:5~6 — MERGE 금지는 §B 클라우드 이관 취합 SQL 범위. 인용은 사내 등록(MERGE)과 이관 SQL 을 따로 적었고 사내 신규 코드 등록의 MERGE 를 금지한 문장은 확인되지 않음 |
| r4-004 | `pinpoint-request-scope-first.md` | tools/E2E/e2e.config.json:5-6 defaultAccount·forceAccount = minyonglee1 · tools/E2E/README.md:13 admins(DM·SCP·SSP ADMIN)에 minyonglee1. 기본 ADMIN 계정 1개 기준과 일치 |
| r4-022 | `procedure-dts-ssot-mandatory.md` | RULESET_MASTER.md:310 카탈로그 #73 = T01/T07/T08 로 hook 과 일치. TRIGGER_ROUTER.md:26 T07 키워드에 저장 포함. 괄호 설명만 다름 |
| r4-023 | `procedure-dts-ssot-mandatory.md` | RULESET_MASTER.md:284 #47 screen-conventions-mandatory · :276 #39 · :278 #41 · :301 #64 로 이 줄 번호가 카탈로그와 일치. 어긋난 쪽은 popup-modal-and-routing-mandatory.md 의 #63(세트 hook 번호 체계) |
| r4-024 | `regression-zero-mandatory.md` | nscm-fe/packages/shared/src/stores/index.ts:6 export useMessageStore · useSaveWithValidation.ts:69 useMessageStore(state => state.setAlert) · useDirtyRegistry.ts:127. 현행 코드와 일치 |
| r5-002 | `screen-completion-gate.md` | 게이트 통과 기준 문장이며 실행 주체 지시가 아님. 실행 주체는 같은 파일 :21 G5 행에 1차 정정으로 기재됨(AI 직접 실행 금지 · fe-check.ps1 · 미실행 ERROR). FIX_BRIEF: 요구 기준은 유지 |
| r5-004 | `relative-import-order.md` | 화면 폴더 내부 상대 import 는 reference 화면 DMF0004 실제 코드와 같음: nscm-fe/features/master/src/pages/sales-site/components/SalesSiteCustomerGrid.tsx:12-14, SalesSiteBucketGrid.tsx:10-12. 페이지 폴더 내부 파일용 alias 없음. hook 본문 §1 이 상대 import 그룹 순서를 정의 |
| r5-005 | `screen-conventions-mandatory.md` | DMF0004 실제 코드와 같음: nscm-fe/features/master/src/pages/sales-site/utils/sales-site.util.ts:5 |
| r5-014 | `screen-conventions-mandatory.md` | FIX_BRIEF 확정 기준 reference 화면 = DMF0004·0005·0006 3개와 일치. 현재 CLAUDE.md §1-2 도 DMF0004~0006 · .claude/rules/00-fe-screen.md §B 3화면 |
| r5-016 | `screen-meta-and-permissions-mandatory.md` | reference 화면 실제 호출과 같음: nscm-fe/features/master/src/pages/sales-site-project-model/SalesSiteProjectModel.tsx:69 · customer-model-mapping/CustomerModelMapping.tsx:44. CR-070 Division 권한 게이트는 공용 SubTitle 에서 처리(packages/shared/src/components/o |
| r5-020 | `screen-conventions-mandatory.md` | DMF0004 실제 코드와 같음: sales-site/components/SalesSiteCustomerGrid.tsx:170 · SalesSiteGrid.tsx:123 · SalesSiteLocationGrid.tsx:78. screen-additional-skills-mandatory.md:304 가 두 방식 병존을 적어 둠(DMF0004 = CRUD_TYPE INSERT 분기, DMF0006 = isEditableCell |
| r5-022 | `screen-runtime-pitfalls-mandatory.md` | 컬럼 allowSorting 은 F3 가 켜는 정렬 스위치이고 초기값 false 가 공용 표준: packages/shared/src/components/organisms/data-grid/DataGrid.tsx:665-671 · packages/foundation/src/utils/columnMapping.ts:716 · gridAction.ts:692-703. 동적 컬럼도 켜면 정렬됨: dataGridUtils.test.ts |
| r5-024 | `screen-analysis-workbook-standard.md` | Doc/화면분석서/old/DMF0003_MktFcst_UI분석서_v1.7.xlsx 의 xl/workbook.xml 시트 10개 실측(1.개요 ~ 10.단위테스트). :183 의 10시트가 맞음. :22 표의 '~v1.7 11시트'와 차이는 남아 있음(DMF0082 계열 시트 수 미측정) |
| r5-027 | `screen-meta-and-permissions-mandatory.md` | 가리키는 hook 제목이 'SubTitle 공통 버튼 11종'(subtitle-button-actions-mandatory.md:1 · :11 · :15). 10 키(CRUD 6 + Aux 4)는 AS-IS 버튼 매핑 축으로 세는 대상이 다름 |
| r6-006 | `screen-shell-composition-mandatory.md` | FIX_BRIEF 확정 기준 reference 화면 = DMF0004·0005·0006 3개 · .claude/rules/00-fe-screen.md B절 — 본문이 현행과 일치(낡은 쪽은 CLAUDE.md 문구) |
| r6-007 | `search-condition-datasource-asis-parity.md` | nscm-fe/configs/eslint.config.mjs:59 'no-console': ['warn', { allow: ['warn', 'error'] }] — console.error 는 허용, 금지 대상은 console.log |
| r6-014 | `search-condition-asis-tobe-catalog.md` | Doc/_rules_v2/_mapping/search_conditions_scp_dm.md:106 'Long-term stock'(4행)과 :107 'Long-term stock MGMT'(12행)는 별개 화면 — search_cond.csv:563 SCP0084 는 'Long-term stock' 쪽. Sun-Set 은 MGMT 화면이라 충돌 아님 |
| r6-016 | `screen-shell-composition-mandatory.md` | 실제 화면은 useQueryClient 를 '@foundation/query-client' 에서 import(nscm-fe/features/master/src/pages/sales-site-project-model-01/SalesSiteProjectModel01.tsx:8 · shipping/.../ShipmentWorkingDay.tsx:7) — 이 grep 에 걸리지 않음. 낡은 쪽은 search-button-when-no |
| r6-017 | `search-area-bulk-input-button-popup.md` | 대상이 다름: X3 = customButtons 버튼 라벨의 t() 없는 리터럴 금지 / labelless-toggle :106 M8 = 조회조건 라벨 LBL 미등록 시 t('', '문구') + GEN_NOTES 과도 처리(t() 경유) — 서로 모순 아님 |
| r6-018 | `search-condition-height-uniformity.md` | 같은 파일 :45 'Main UI 는 표준 컴포넌트 · Popup 의 raw 컨트롤만 36px 보정'으로 범위를 구분 — screen-shell §8 은 화면(Main UI) 안티 패턴 표. 이 줄은 raw select 허용 선언이 아니라 팝업에 남아 있는 raw 컨트롤의 높이 보정 기준 |
| r7-005 | `ui-meta-dictionary-mandatory.md` | 파일에 "대사표" 0건. :24 는 Doc/_rules_v2/_dictionary/03_sheet_measures.md:1 제목 "SHEET_MEASURE 지식사전 + AS-IS↔TO-BE 대사" 인용. :406 "차이 대사"는 표 이름 아님 |
| r7-010 | `ui-common-testitem-mapping-axis.md` | MSG00703 은 미저장 변경 confirm, MSG00680 은 pending 차단으로 용도가 다름. shipment-request.constants.ts:116, production-request.constants.ts:65, useDirtyRegistry.ts:112 (MSG00703) / sales-reports.constants.ts:65 (MSG00680) |
| r7-012 | `ui-dynamic-property-management.md` | 이 문서 시그니처가 현행 코드와 같음: useTabBtnPermissions.ts:43-49 (menuId, enabled), SubTitle.tsx:300 호출도 { menuId, enabled }. divisionId 인자는 코드에 없음 |
| r7-020 | `titleset-cache-immunization.md` | 서로 다른 객체. DMF0002_GET_TITLESET_POPUP = TO-BE(nscm-be/src/main/resources/sql/admin/Menu.xml:90), SCM0002_GET_TITLESET_POPUP = AS-IS(Doc/_analysis/domain_DM/screens/DMF0020_POPUP_GridColumnSetting/analysis.md). :50 도 "AS-IS(…)" 로 표기 |
| r7-022 | `ui-category-setup-column-meta.md` | REV_BRIEF 추가 확정 기준 "메타가 비면 빈 그리드 + deploy SQL 로 메타를 채운다"와 같은 내용 |
| r8-002 | `22_PACKAGE_ARTIFACTS.md` | 같은 파일 L256~258 '## 6. 클라우드 적용 절차' · '클라우드 사용자가 압축 풀고 그대로 따라 실행' — 적용 주체가 클라우드 사용자로 이미 한정돼 있어 AI 로컬 실행 지시가 아님 |
| r8-009 | `verification-completion-honesty.md` | _artifacts/_diagnostics/ui_gate_runner.py:661 섹션 이름이 'EID 1:1 대사표' — 도구 섹션 이름 인용이라 REV_BRIEF 예외(도구 이름·코드 문자열은 바꾸지 않음). L171 은 사고 경위 표라 이력 |
| r8-011 | `02_DEVELOPMENT_RULES.md` | .claude/rules/00-fe-screen.md B 항 '표준 패턴: nscm-fe/features/admin/src/pages/user-management/ · reference 화면 Tab형=DMF0004 / Panel형=DMF0005 / 단일 grid=DMF0006' — user-management 는 현행 표준 패턴 예시와 일치 |
| r8-025 | `21_TROUBLESHOOTING.md` | 두 문장의 작업이 다름 — L1033~1035 는 PROC_M 에 빠진 O_RESULT_CURSOR 행 추가(NOT EXISTS INSERT), L718~721 은 잘못 시드한 COL_NM 값 정정(PK 충돌이라 DELETE+INSERT). 값 불일치 아님. L1037 artifact 파일은 현재 저장소에 없어 대조 못 함 |
| r9-012 | `09_subtitle_hotkey.md` | CR-070 대상 = 'Insert(F8)/Delete(F9)/Save(F7)/Upload' (confirmed_requirements.csv:71 항목 열). sort·filter·excel·condition·resetCondition 은 CR-070 범위 밖. insert/delete/save/upload 는 같은 문서 §2.2.1 표·1차 정정(09:22-23,79)에 이미 반영 |
| r9-016 | `07_datagrid.md` | §8 은 선택 전용 grid, §12.1 #1 은 Insert 셀 dropdown grid(DMF0003)로 적용 유형이 다름. §12.5 grep 은 문자열 리터럴 selectionMode='Row' 만 잡고 §8 의 {SelectionMode.Row} 는 대상 아님. 실제 코드도 병존 — AuthorityGrid.tsx:34 · GroupUserMainGrid.tsx:69 · DynamicQueryMainGrid.tsx:1 |
| r9-017 | `07_datagrid.md` | §12 는 FlexGrid 직접 사용 + F4 때만 FlexGridFilter attach(§12.1 #5) 구조. SubTitle 기본 filter 동작은 gridFilter.current 가 있어야 함(sub-title/SubTitle.tsx:185-189) → 이 구조에서는 명시 handler 필요. 09 의 '생략 = 자동 활성' 은 DataGrid wrapper 화면 기준이라 충돌 아님 |

## §19 검토 등급 보류 66건 결정안 (2026-11-14, 문서 미수정)

사내 ZIOUI1 읽기 전용 조회 2026-11-13 21:51 (SELECT 만, 끝에 ROLLBACK). 접속 계정 SYSTEM, CURRENT_SCHEMA SCM_MGR.

### 19-1 DB 실측으로 정정할 수 있는 것, 9건
| id | 문서 | 실측 | 결정안 |
|---|---|---|---|
| r3-014 | `menu-not-displayed-debug.md:127` | `SCM_ADM_USER_GR_MNU_MPG_M` 키 컬럼 = USER_GR_ID, MNU_ID. USER_ID, GR_ID 컬럼 없음 | 예시 SQL 을 USER_GR_ID 기준으로 정정. 사용자 소속은 `SCM_ADM_USER_GR_MPG_M`(USER_GR_ID, USER_ID) 조인 |
| r3-020 | `menu-not-displayed-debug.md:191` | `SCM_ADM_USER_GR_MNU_BTN_MPG_M` 키 컬럼 = USER_GR_ID, MNU_ID, MNU_BTN_CD. USER_ID 없음 | 예시 SQL 의 USER_ID 조건을 USER_GR_ID 로 정정 |
| r6-020 | `sheet-columns-meta-completeness.md:52` | `SCM_MST_SHEET_COLUMNS` NOT NULL 컬럼 16개 | "12종"을 16개로 정정하고 목록 기재 |
| r3-002, r9-001 | `menu-not-displayed-debug.md:110`, `13_routing_menu.md:431` | `SCM_ADM_MNU_M.UNIT_TP_CD` 분포 S 82, '-' 81, D 61. NOT NULL, DEFAULT '/' | 예시 값 '-' 유지. "신규 등록 기본값은 '/', 기존 '-' 81행은 유지" 단서 |
| r1-027 | `corp-meta-integrity-and-wiring.md:30` | `SCM_ADM_API_M.API_TP_CD` 분포 PROC_SELECT 551, PROC_SAVE 243, PROC 175, POST 24, PROC_UPDATE 5, EXCELUPLOAD 1. 'SAVE' 0행 | 이 줄('POST')은 유지. 상대 문서 `be-infrastructure-reuse.md:117` 의 'SAVE' 에 "DB 에 없는 값" 단서 |
| r4-016 | `oracle-save-payload-integrity.md:73` | 현 접속 계정에서 `USER_SOURCE` 의 PKG_DMF% 0줄. `ALL_SOURCE` 의 PKG_DMF% 본문 OWNER 는 SCM_MGR 1개(39개 객체) | "USER_SOURCE 사용"을 "ALL_SOURCE WHERE OWNER='SCM_MGR'"로 정정 |
| r4-003 | `oracle-sp-perf-anti-patterns.md:251-253` | 사내 DB 의 SCM% 계정 = SCMP_APP, SCM_MGR, SCM_USER. SCMD_APP 없음 | GRANT 예시에 "사내 = SCMP_APP, 다른 환경은 그 환경 계정" 단서 |
| r6-021 | `sp-dual-cursor-pattern.md:172` | `SCM_ADM_PROC_M` 커서 COL_NM 분포 o_rc1 537, O_RESULT_CURSOR 390, o_rc2 111, o_rc 52, o_rc3 43, O_RC1 18 | "O_RC + O_RESULT_CURSOR" 에 "데이터 커서 이름은 SP 별" 단서 |

### 19-2 근거를 확인해 단서나 정정으로 정리할 수 있는 것, 15건
| id | 문서 | 결정안 | 근거 |
|---|---|---|---|
| r8-004 | `wijmo-insert-cell-dropdown.md:19` | lint, type-check 는 AI 직접 실행 금지 단서 추가 | 확정 기준(1차와 같음) |
| r5-015 | `screen-create-checklist.md:16` | "00_INDEX 모두 read"를 "TRIGGER_ROUTER 로 진입, 00_INDEX 는 카탈로그가 필요할 때만"으로 | `CLAUDE.md §3` |
| r4-020 | `popup-modal-and-routing-mandatory.md:3` | Trigger 표기 T13 을 T06, T09 로 | `TRIGGER_ROUTER.md` T06 행에 이 hook, T09 메뉴, T13 은 CSV 적재. `RULESET_MASTER.md` §4 #35 행도 같이 정정 대상 |
| r1-024 | `cloud-deploy-silent-failure-gates.md` | 절 제목 "5계보"에 "현재 표는 S1~S7 7행" 단서. 제목 줄은 그대로 | 같은 문서 표 |
| r5-030 | `screen-runtime-pitfalls-mandatory.md:709` | 예시의 LBL00366 에 "실제 값은 'Search User Info', 예시 코드"라는 단서 | `EN.json:651` |
| r5-029 | 같은 문서 :579-581 | "현행 DMF0043 코드는 EDIT_FLAG='Y' 행만 편집 허용(2026-08-11)" 단서 | `ContributeMainGrid.tsx:256-271` |
| r2-017, r2-018 | `grid-column-setting-popup-pattern.md` §1 | 절 머리에 "참조 구현 contribute-view 에서 visibleBaseColumns 경로와 handleColumnApply 가 제거됨, 이 절은 구 구현" 단서 | `ContributeViewGrid.tsx:91`, `ContributeView.tsx:246` |
| r4-012 | `popup-modal-and-routing-mandatory.md:127-130` | "RegionModal 실물은 Search 때 프로시저 재조회" 단서 | `RegionModal.tsx:52-79` |
| r9-019 | `10_popup_modal.md:86` | "ProjectByDivisionModal, ItemByDivisionModal 은 callFromCell 값을 쓰지 않음" 단서 | 두 모달 소스 |
| r7-021 | `type-check-error-patterns.md:333` | 요청 키는 SP 별(menuId 17, mnuId 40) 단서 | `procedures.d.ts` |
| r4-019 | `oracle-sp-perf-anti-patterns.md:223` | 파라미터별 GT 와 2컬럼 PARAM_TOKEN GT 두 방식이 쓰인다는 단서 | `_artifacts` SQL |
| r2-028, r8-034 | `db-corporate-apply.md:19`, `32_CLAUDE_ORACLE_DIRECT.md:57` | "현행 접속 도구는 `tools/DbConn`(python-oracledb thin, 클라이언트 설치 불필요)" 단서 | `tools/DbConn/README.md:23`, 이번 세션 조회 4회 |
| r8-029 | `32_CLAUDE_ORACLE_DIRECT.md:11` | "현행 접속 값은 `.env.asis`" 단서. 문서 값은 고치지 않음 | `.env.asis` |

### 19-3 변경 없이 확정할 것, 20건
충돌이 아니거나, 맥락이 달라 두 문장이 함께 성립하거나, 값을 정할 근거가 없는 것.

| 사유 | id |
|---|---|
| `gen:i18n` 은 차단 목록에 없고 스크립트 있음 | r5-003, r6-001 |
| CR 과 다루는 대상이 달라 충돌 아님 | r1-022, r2-013, r3-008, r3-015, r4-013, r5-019, r5-021, r7-013 |
| 두 문장의 맥락이 다름(용도, 단계) | r2-020, r4-018, r4-025, r6-022 |
| 기존 '-' 데이터를 다루는 예시 | r4-001 |
| 1차 정정 자리, 추가 근거 없음 | r3-023, r4-015 |
| 저장소에 근거 없음(외부 수치, 문서 2곳 표기뿐) | r2-021, r8-027, r8-028 |

### 19-4 사용자 결정이 필요한 것, 21건
| 묶음 | id | 갈리는 내용 | 권장 |
|---|---|---|---|
| 행별 콤보 후보 처리 | r1-017, r1-020, r1-023 | 문서: 편집 진입 때 dataMap 교체가 유일한 방법. `SalesFuturePriceGrid.tsx:267-276` 주석: 2026-09-01 부터 공용 DataGrid 가 컬럼 메타로 처리, dataMap 교체 금지. `ForecastPriceGrid.tsx:1345,1382` 는 dataMap 교체 | 공용 DataGrid 메타 처리를 표준으로. ForecastPriceGrid 는 보완 후보 |
| 화면 폴더 내부 상대 import | r2-004, r2-005 | `CLAUDE.md §4-①` 상대경로 금지. reference DMF0005 `SalesSiteProjectModelGrid.tsx:19` 는 `../../../components/ownerModal/...` 사용. 공용 index 가 그 상수를 export 하지 않음 | 같은 화면 폴더 안(`./`, `../`)은 허용, 화면 밖은 비상대 경로. r2-005 는 index export 추가가 선행(코드 변경) |
| KO 문구 = EN 문구 | r3-011 | 2026-06-12 지시: KO 와 EN 을 같게. 현행 `KO.json` 은 한글 문구(:758, :760, :825) | 권장안 없음 |
| 컬럼 설정 저장 위치 | r3-013 | 문서: localStorage. demand 화면에 localStorage 사용 0건 | 권장안 없음. 현행 저장 위치(서버 저장본) 확인 후 정정 |
| Deploy 패키지 구성 | r5-009 | 문서 4곳 표기가 다름(4항목, 5종, 6종, v1_full) | `deploy-package-completeness.md` 6종을 정본으로 |
| 개요의 개정내역 표 | r5-023 | 2026-07-20 폐지가 UI분석서만인지 화면설계서도인지 | 권장안 없음 |
| locales 변경 파일 | r1-028 | 배포 패키지에 '명시'가 목록 기재인지 파일 동봉인지 | 목록 기재(locale JSON 은 git 경로라 DB 패키지 범위 밖) |
| 사내 DB 쓰기 승인 | r8-014 | 룰 32: 실행 전 보고 후 승인. 저장된 상시 지시: 사내 ZIOUI1 쓰기 상시 허용. `CLAUDE.md §1-6`: 승인된 절차만 | 권장안 없음 |
| CheckList 단일화의 범위 | r6-009, r7-025, r8-035, r8-036 | 구 요구(E2E 시나리오 8축, 보완요청 원장, 3 산출물, HTTP E2E)가 CheckList 로 대체됐는지 | 권장안 없음. 대체 여부를 정해 주면 4곳에 반영 |
| 클라우드 적용 주체와 이관 방식 | r8-037, r8-026 | 한쪽: 승인 후 AI 적용, 사내 push 후 클라우드 pull. 다른 쪽: 패키지 생성까지, 적용은 클라우드 사용자, 별도 PC 수동 복사 | 패키지 생성까지 AI, 적용은 사용자 |
| 클라우드 앱 계정명 | r7-001, r8-007 | 문서: SCMD_APP. 사내 DB 에는 SCMP_APP 만 있음 | 권장안 없음. 클라우드 계정명 확인 필요 |
| 자매 화면 권한 행 복사 | r7-023 | 한쪽: 다른 화면 메타 복사 금지. 다른 쪽: 같은 메뉴, 시트의 SAVE 권한 복사 | 권장안 없음 |
| 신규 GET SP 형태 | r6-023 | 예시는 standalone PROCEDURE. PKG 의무는 SDM 한정 문서에만 있음 | 권장안 없음 |

### 19-5 추가 DB 조회가 필요한 것, 1건
| id | 내용 | 필요한 조회 |
|---|---|---|
| r6-019 | "구 PascalCase 시트 0 row" 기대값과 AS-IS 시트명 보존 룰의 관계 | `SCM_MST_SHEET_COLUMNS` 의 SHEET_NAME 목록과 FE SHEETS 값 대조 |

## §20 검토 등급 보류 건 권장안 반영 (사용자 승인 "권장안 전부 적용", 2026-11-14 01:18)

- 반영 53건: 문서 정정 33건(§19-1 9건, §19-2 15건, §19-4 중 권장안 있는 9건), 변경 없이 확정 20건(§19-3).
- 치환 33곳, 문서 26개. 사전 확인에서 33곳 모두 1회 일치. `RULESET_MASTER.md` §4 #35 행의 Trigger 표기 포함.
- 변경 전 사본: `Doc/_archive/bak_20261113/rule_body_before_review_hold/` (26개).
- 검토 등급 250건 최종: 정정 165(1차 132, 2차 33), 변경 없이 확정 20, 이미 반영 1, 지적 오류 46, 이력 줄 5, 남은 보류 13.
- 남은 보류 13: r3-011(KO 문구), r3-013(컬럼 설정 저장 위치), r5-023(개정내역 표), r6-009, r7-025, r8-035, r8-036(CheckList 단일화 범위), r6-023(신규 조회 SP 형태), r7-001, r8-007(클라우드 앱 계정명), r7-023(권한 행 복사), r8-014(사내 DB 쓰기 승인), r6-019(추가 DB 조회).
- 확인: `build_router.py --check` rc 0, `inventory_check.py` PASS, `engine_selfcheck.py` 전체 PASS, `verify_hooks.ps1` FAIL 0 (01:19).
- 문서에 "보완 후보"로 적힌 코드(미조치): `ForecastPriceGrid.tsx:1345,1382` 의 dataMap 교체, `features/master/src/components/index.ts` 의 MODAL_OWNER export 없음.

## §21 남은 보류 13건 권장안 (2026-11-14, 제시만, 문서 미수정)

사내 DB 읽기 전용 조회 2026-11-14 01:25. 저장소 파일 확인 같은 날 01:2x.

| 묶음 | id | 권장안 | 근거(이번 실측) | 확신 |
|---|---|---|---|---|
| CheckList 단일화 범위 | r6-009, r7-025, r8-035, r8-036 | 4곳에 "2026-10-30 부터 화면 대조와 보완 기준은 CheckList. 완료 근거는 `Doc/verify/<ID>/fixlist.csv` 의 조치 필요 0행. 아래 요구는 그 전 절차" 단서 | 지시 기록 2건: 10-30 GAP 폐지와 CheckList 단일, 11-04 E2E 메뉴 폐지와 E2E 는 CheckList 안에서만. 구 도구 수정일 `ui_gate_runner.py` 08-20, `ui_http_e2e.py` 08-28, `_gate_reports` 마지막 파일 08-31, `보완요청_원장.md` 10-20. `run_verify.py`, `quick.json`, `steps.json` 에 이 세 이름 참조 0건 | 중간. 지시 원문은 GAP 과 E2E 메뉴를 말하고 보완요청 원장과 3 산출물을 직접 말하지 않음 |
| 클라우드 앱 계정명 | r7-001 | 클라우드도 `SCMP_APP` 으로 정정 | 클라우드 경로 SQL 파일 수: SCMD_APP 05월 15, 07월 3, 08월 31, 09월 1, 10월 0, 11월 0. SCMP_APP 08월 41, 09월 100, 10월 20, 11월 27. CR-076 원문이 SCMP_APP | 중간. 클라우드 DB 는 조회하지 못함 |
| 〃 | r8-007 | 접속 예시(10.34.220.81 ESSCMD, SCMD_APP)에 "2026-06 구 접속 정보" 단서 | 같은 주소가 접속 이력 표의 06-10~06-15 행 | 높음 |
| KO 문구 | r3-011 | "KO = EN 동일" 의무를 라벨(LBL)에 한정. 메시지(MSG)는 한글 문구 허용 | `KO.json` 과 `EN.json` 공통 키 1,734개 중 값 같음 875, 다름 859. LBL 656개 중 같음 463, 한글 204. MSG 759개 중 같음 120, 한글 664 | 낮음. 현행 데이터에 맞춘 안이고 2026-06-12 지시와 다름 |
| 컬럼 설정 저장 위치 | r3-013 | "localStorage"를 "서버 저장본(titleSet)"으로 단서 | `packages/shared`, `packages/foundation` 에 localStorage 사용 0건. `titleSetApi.ts`, `columnLayoutModal.utils.ts` 가 서버 저장. Measure 선택 저장 위치는 미확인 | 컬럼 설정은 높음 |
| 개정내역 표 폐지 범위 | r5-023 | 폐지는 UI분석서만. 화면설계서 개요는 개정 이력 유지 | 화면설계서 최근 25개(11-10 생성) 첫 시트에 개정 이력 있음 25개. 생성기 `tools/Docs/make_docs.py:278` 이 개정 이력을 씀 | 높음 |
| 사내 DB 쓰기 승인 | r8-014 | 룰 32 문장에 "사내 개발 DB(ZIOUI1)는 상시 허용(2026-09-14). 적용, 원복, README 를 만든 뒤 적용하고 검증. 클라우드는 패키지만. 정합검증 단계에서는 보완 실행 금지(2026-10-28)" 단서 | 지시 기록 `feedback_corporate_db_write_standing_approval`(09-14), 색인의 10-28 항목 | 중간. `CLAUDE.md §1-6` 문구("승인된 절차만")는 그대로 둠 |
| 자매 화면 권한 행 복사 | r7-023 | 예시에 "복사할 그룹은 사용자가 지정한 경우만. 지정이 없으면 등록하지 않고 보고" 단서 | `ui-category-setup-no-arbitrary-data.md` 금지 4번(다른 화면 메타 복사). §13 E 묶음에서 정한 "추정 등록 금지"와 같은 방향 | 중간 |
| 신규 조회 SP 형태 | r6-023 | 예시에 "화면 조회 SP 는 PKG 안에 둔다" 단서 | `SCM_ADM_API_M` 조회 계열 551건 중 PKG.프로시저 510, 단독 41. 단독은 DMF 29, P_D 7 등 | 중간. 전 도메인 의무라는 문장은 룰에 없음 |
| 시트명 기대값 | r6-019 | "다른 sheet (구 PascalCase / 폐기) 0 row"를 "FE SHEETS 값과 다른 시트 0 row. 대소문자만 다른 중복 시트는 등록명 하나로 단일화"로 정정 | 시트명 대문자 시작 714개(341개 화면), 소문자 시작 128개(62개 화면). 대문자 시작이 다수라 "구 PascalCase" 표현이 맞지 않음. 대소문자만 다른 중복 5건: DMF0004 CountryPopup/countryPopup, DMF0005 와 DMF0005_01 의 Production/production, Purchase/purchase | 높음. 중복 5건은 데이터 정리 후보(어느 쪽이 등록명인지 미확인) |

## §22 남은 보류 13건 반영 (사용자 승인 "13건 반영", 2026-11-14 01:31)

- §21 권장안대로 문서 14개, 치환 14곳 정정. 사전 확인에서 14곳 모두 1회 일치. `10_RULES_KEEP.md` E6 행 포함.
- 변경 전 사본: `Doc/_archive/bak_20261113/rule_body_before_last13/` (14개).
- 검토 등급 250건 최종: 정정 178(1차 132, 2차 33, 3차 13), 변경 없이 확정 20, 이미 반영 1, 지적 오류 46, 이력 줄 5, 보류 0.
- 확실 등급 240건 최종: 정정 237, 변경 없이 확정 2, 지적 오류 1, 보류 0.
- 490건 합계: 정정 415, 변경 없이 확정 22, 이미 반영 1, 지적 오류 47, 이력 줄 5, 보류 0.
- 확인: `build_router.py --check` rc 0, `inventory_check.py` PASS, `engine_selfcheck.py` 전체 PASS, `verify_hooks.ps1` FAIL 0 (01:31). `inventory_check.py` 의 STAGE_WARN 항목은 `run_verify.py` 수정 뒤 실행 로그 1개에서 단계 예정 수 경고 0줄.
- 미확인으로 남긴 것: 클라우드 DB 의 앱 계정명(조회하지 못함), Measure 선택 저장 위치, 대소문자만 다른 중복 시트 5건의 등록명.

## §23 룰과 다른 코드, 데이터 보완 후보 (2026-11-14 02:15, 조사만)

- FE 소스 2,181개 파일 전수 측정과 사내 DB 읽기 전용 조회. 코드와 DB 미수정.
- 산출물: `2026-11-14_RULE_VS_CODE_보완후보.md`(요약, 진행 순서), `2026-11-14_RULE_VS_CODE_보완후보.csv`(건별).
- 후보 13종. SCM_MGR INVALID 객체 12개(마지막 DDL 2026-11-13 21:21~21:22)가 조회에서 나옴. 원인 미확인.
