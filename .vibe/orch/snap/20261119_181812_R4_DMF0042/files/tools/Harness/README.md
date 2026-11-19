# Harness — To-Be 신규 화면 생성 하네스 (v1, 2026-10-16)

As-is Fact Pack(AsisFacts) → **사전(rules/)** → 골격 생성(gen.js) → Claude Code 가 TODO 만 채움 → 같은 검사기(check.js)가 저장·종료·커밋 세 시점에서 판정.
룰은 문서가 아니라 **데이터(CSV)** 로 두어 생성기와 검사기가 같은 룰을 읽는다. 룰 보완(6단계) = CSV 한 줄 추가.

## 한 줄 사용
```
cd C:\Projects\NSCM\tools\Harness
powershell -NoProfile -ExecutionPolicy Bypass -File new-screen.ps1 DMF0052            # 골격 생성 + nscm-fe 적용 + 1차 게이트 + GEN_NOTES
powershell -NoProfile -ExecutionPolicy Bypass -File new-screen.ps1 DMF0052 -Claude    # + Claude Code 기동(프롬프트 자동)
node install.js                                                                       # .claude/settings.json 에 hook 3개 + husky pre-commit 게이트 (1회)
```

## 구성
| 파일 | 역할 |
|---|---|
| `rules/map_control.csv` | As-is 컨트롤 타입 → To-Be 컴포넌트·import·props·생성 방식(field/button/grid/container/skip/todo) |
| `rules/map_button.csv` | 버튼 이름 규칙 → SubTitle customButtons / 팝업 필드(FunctionSearchIcon+모달) / 내장 기능(조회·엑셀) / 단축키 |
| `rules/map_event.csv` | As-is 이벤트(타깃 접두+이벤트명) → To-Be 배선 슬롯(handler/grid-event/lifecycle/state)과 패턴 |
| `rules/map_domain.csv` | 화면ID 접두 → features 폴더 (최종 확정은 SCM_ADM_MNU_M 트리) |
| `rules/allowed_gaps.csv` | 의도된 차이 — 검사기가 GAP 으로 세지 않음 (레이아웃 아티팩트, 내장 버튼, SPREAD_TITLE→메타, 공통 콤보 SP…) |
| `rules/forbidden.csv` | 금지 패턴(Top 11 + SYS0017 감사) — BLOCK/WARN |
| `rules/*.mined.csv` · `pairs.csv` | `mine.js` 가 110개 짝 화면·`__asis-mapping__.md` 1,747행에서 채굴한 빈도표 — 사전 보완의 근거 |
| `lib/analysis.js` | `Doc/_analysis` 의 validation.md/expressions.md 표 파서 (gen·check 공용) |
| `lib/dyncol.js` | 동적 헤더(기간 컬럼) 원천 판정 (gen·check B26/B27·gap 공용, 2026-10-20) — As-is 타이틀 SP 다중 신호(SP 이름 계열·GetSpdTitle 메서드·grid_code DB루프), 기간형/메타형 분류, 사내 배선 시트(proc_meta) 대응, FE 시트 조회 판정, 응답 키 허용 집합(PROC_M OUT COL_NM ∪ DATARESULT) |
| `gen.js` + `templates.js` | 골격 생성기. 표준 참조(user-management) 구조 그대로: constants / store / Page / index / Form / Grid / `__asis-mapping__.md` 초기본 / `__tests__/*.asis.spec.ts`(Agent 단위테스트 → it.todo) / `register.json`(P_REGISTER_SCREEN 입력 초안) / `hooks/use{Page}Validation.ts`·`Expression.ts`(As-is 검증·계산식 1행 = 1마커) / `GEN_NOTES.md` |
| `check.js` | 게이트: 금지 패턴(주석 제외) · 표준 파일·Form/Page 표준(S02/S03) · 매핑표 빈칸/위치/사유 · As-is 시트·엔드포인트·이벤트·컨트롤 대사 · 사전 밖 컴포넌트 · Validation/Expression 마커 수(V01)·미이식(V02). exit 0/1/2 |
| `hooks/check-asis-harness.ps1` | Claude Code PostToolUse — 저장 즉시 check; BLOCK 은 차단, WARN 은 additionalContext |
| `hooks/harness-stop-gate.ps1` | Claude Code Stop — 바뀐 화면 폴더에 `--final`(미구현 0) 요구, 아니면 종료 차단·사유 반환 |
| `hooks/harness-gen-context.ps1` | Claude Code UserPromptSubmit — 화면ID+생성 의도면 절차·GEN_NOTES 첨부 |
| `pre-commit.js` | husky — 스테이징된 화면 폴더 게이트(BLOCK 만 커밋 차단) |
| `prompts/new_screen.md` | Claude Code 작업 지시(채울 것/하지 말 것) |
| `gap.js` | 4단계 GAP 도구 — As-is Fact vs To-Be Fact 를 110개 짝 화면에 대사. COVERED/INTENDED/MISSING/UNMAPPED + 점수 → `Doc/gap/<ID>_gap.csv`, `_summary.csv/.md`. `Doc/tobefacts/db/proc_meta.csv`(클라우드 SP 등록 메타) 가 있으면 SP 대응을 그 기준으로 재판정 |
| `suggest-rules.js` | 6단계 룰 보완 입력 — `Doc/gap/*_gap.csv` 의 MISSING/UNMAPPED 를 유형별 집계, 이미 사전에 있는 것은 제외, 붙여 넣을 CSV 행 초안 → `rules/_candidates.md/.csv` |
| `harness.json` | 경로 설정 |

## 룰 보완(원천 차단) 절차
0. `node gap.js` → `node suggest-rules.js` → `rules/_candidates.md` 에서 반복되는 미대응 요소를 본다 (2026-10-16 첫 적용: 공통 콤보 SP·로그 SP·조회조건 저장 SP 를 allowed_gaps 에, SCP 조회조건 11종을 map_field 에 추가 → 엔드포인트 INTENDED 187→317, MISSING 452→334).
1. 게이트가 WARN `D01 사전 밖 컴포넌트` / GEN_NOTES "사전에 없던 것" 을 내면 → 표준이면 `map_control.csv`(또는 map_event/map_button) 에 한 줄, 의도된 차이면 `allowed_gaps.csv` 에 사유와 함께 한 줄.
2. 다음 화면부터 생성기·검사기가 같이 바뀐 룰을 쓴다. 문서(`Doc/_dev_rules`) 는 사람용 설명으로 유지하되 **판정은 CSV 가 한다**.

## 레이아웃·라벨 (As-is 디자이너 속성 사용)
AsisFacts Pack 이 화면별 `props.csv`(Text/Orientation/SplitterDistance/Size/Control…) 를 내므로(2026-10-16 추가 — 노트북은 run.ps1 재실행 필요), 생성기는
- SplitContainer 트리를 그대로 `PanelGroup` 중첩으로 옮긴다: WinForms Orientation.Horizontal(상/하) → `orientation='vertical'`, Vertical(좌/우) → `'horizontal'`, SplitterDistance/Size → `defaultSize` %. 배치 트리에 없는 스프레드(동적 추가)는 뒤에 붙이고 TODO 표시.
- 라벨은 LayoutControlItem.Text(해당 Control 기준) → 없으면 컨트롤 Text → 없으면 이름에서 유도. LBL 코드는 `rules/lbl_codes.csv`(To-Be 코드의 `t('LBLxxxxx','_Text')` 447건 채굴) 로 문구 매칭, `Doc/tobefacts/db/msg_master.csv` 가 있으면 마스터도 조회. 못 찾으면 `LBL?????` + GEN_NOTES 에 채번 요청 목록.

## 복수 스프레드 화면
As-is FpSpread 가 여러 개면 스프레드 이름↔시트명 토큰 매칭으로 시트를 배정해 `components/{Page}Grid{Suffix}.tsx` 를 스프레드마다 만들고, Page 는 `PanelGroup/Panel/PanelSeparator`(@shared/panel, production-plan 선례) 세로 분할 + 그리드별 `useTabProcQuery` + 시트별 `staticColumns[SHEETS.X]` 로 조합한다. 남는 시트는 미배정 스프레드의 `activeSheet{Suffix}` 전환으로. 스프레드 컨트롤이 디자이너에 없는(동적 생성) 화면은 가상 spdMain 1개.

## 한계
- SP 연결은 Oracle 메타(SCM_ADM_PROC_M) 라 소스에서 확정 불가 → `register.json` 은 3-키 초안, 등록 후 `pnpm gen:procedures`.
- 업무 로직의 의미 동일성은 게이트가 보장하지 않음 → Agent 단위테스트(it.todo) 를 실제 테스트로.
- 기존 23개 `__asis-mapping__.md` 는 design 번호 체계라 §4/§5 행이 없어 G02 경고가 난다(차단 아님).

## 2026-10-16 추가 — 99% 자동화를 향한 보강
| 파일 | 역할 |
|---|---|
| `repair-loop.js` / `harness_repair.cmd` | 골격 생성 → `claude -p` 채움 → `check.js --final` → BLOCK findings 를 붙여 재시도(기본 3회) → PASS 또는 사람 확인 큐. `Doc/gen/<ID>/REPAIR.md`, `Doc/gen/_repair_summary.csv` |
| `check.js --tsc / --lint` | 저장소 `node_modules` 의 tsc·eslint 를 직접 실행(pnpm 미사용·오프라인). T01 타입오류·L01 eslint error = BLOCK, L02 = WARN. `--final` 에 포함(Stop 훅·husky·수선 루프) |
| `rules/map_screen.csv` | As-is ID ≠ To-Be MENU_ID 짝(SCM0008→SYS0011, GSCM_USERINFO→SYS0002 …). `tools/Recon/xlsx_to_csv.py` 가 개발대상 xlsx 에서 생성(`source=manual` 행 보존). gen.js 는 어느 ID 로 불러도 짝을 찾고, gap.js 는 이 표로 As-is 폴더를 찾는다 |
| `gen.js` → `Doc/gen/<ID>/e2e_plan.json` | E2E 생성기(`tools/E2E/gen-e2e.js`) 입력 — 조회조건/버튼/시트/프로시저/핸들러 |
| `harness.json` `tobePkgDir` / `dbconnDir` | To-Be 패키지 소스(PROC 매칭 폴백) · DB 접속 도구 위치 |

연관 도구: `tools/DbConn`(접속정보·Oracle 메타 export·골든 테스트) · `tools/Recon`(개발대상 대사표) · `tools/E2E`(Playwright 스모크/CRUD/권한·Division)

### 2026-10-16 (2차) — 자동화 보강
| 파일 | 역할 |
|---|---|
| `gen-register-sql.js` | 화면 하나의 **Oracle 메타 등록 SQL 7영역**(i18n·PROC_M·SHEET_COLUMNS·MNU_M·API_M·MNU_BTN_MPG·그룹권한)을 register.json + As-is 메타(SCM_MST_SHEET_COLUMNS 전 컬럼 이관, TB_FX_MenuItemInfo, TB_FX_GroupMenuAuth)에서 생성. PROC_M 은 ALL_ARGUMENTS 동적(PKG 미배포 시 As-is 파라미터로 임시 + WARN). → `Doc/gen/<ID>/<ID>_registration.sql` |
| `snapshot.js` | 생성기 회귀 테스트 — 전 화면 골격 해시를 `rules/_snapshot.json` 기준선과 비교(`--update` 로 갱신). 룰/템플릿 변경이 의도한 화면만 바꿨는지 확인 |
| `mine-examples.js` → `prompts/examples/` | 매핑표 '구현' 772행에서 As-is 유형별(§1 컨트롤 타입 / §2 이벤트명 38유형) 실제 To-Be 코드 조각을 떠 few-shot 예제로. `new_screen.md` 입력 6번으로 Claude 가 기존 코드 모양 그대로 채우게 한다 |
| recon `confidence` | 대사표 화면 행에 신뢰도(0~100: GAP·BLOCK/WARN·골든·E2E·문서)와 사유 — 70 미만은 `검토필요` = 사람이 볼 1% |

### DB 조각 자동화 (2026-10-16 3차)
| 파일 | 역할 |
|---|---|
| `gen-pkg.js` | As-is SP → To-Be 규약 Oracle PACKAGE 골격(SPEC+BODY): IN 타입 매핑, O_RC<n>(최상위 SELECT 수 추정)+O_RESULT_CURSOR, SAVE 류 `P_DATA CLOB`, EXCEPTION 규약, As-is 원문을 `/* ===== ASIS */` 로 동봉 → `Doc/gen/<ID>/<ID>_PKG.sql` + `_PKG_NOTES.md`(임시테이블·동적SQL·하위 SP·결과셋 컬럼) |
| `check-pkg.js` | PKG 이식 게이트 P00~P93: T-SQL 잔재(ISNULL/GETDATE/TOP/#temp/@@/CONVERT/DATEADD/EXEC…), 미이식 TODO·스텁·ASIS 블록 잔존, O_RESULT_CURSOR/EXCEPTION 규약 |
| `prompts/port_pkg.md` · `repair-loop.js --pkg` | Claude Code 이식 지시 + 게이트 재시도 루프(`REPAIR_PKG.md`) |
| `harness_pkg.cmd <ID>` | 등록 SQL 생성 → 이식 루프 → `tools/DbConn/run_sql.py` 로 컴파일(USER_ERRORS) → 등록 SQL 미리보기(ROLLBACK) |

### 2026-10-16 (4차) — "기초 누락 0" 과 "ID 하나로 끝까지"
| 파일 | 역할 |
|---|---|
| `check.js` B01~B21 + `Doc/gen/<ID>/DOD.md` | 룰 25/12/13/17 의 기초 항목을 기계 판정하는 **완료 정의(DoD)**: index export · MENU_ID/SHEETS · createPersistedStoreWithTab · useTabProcQuery · hotkeyConfig 명시(As-is override 대조 B08, UsrConditionPanel 유무 B09) · 팝업 1:1(B10/B11) · Division 분기(B12) · AS-IS 라인 주석(B13) · Form 표준(B14~B17) · DataGrid(B18) · 검증/표현식 훅(B19) · 테스트(B20) · 등록 SQL/PKG(B21) · 조회 filter 키=PROC_M IN(B22) · 등록 SQL 배선=사내 현행(B23) · 초기 조회기간(B24) · 공통버튼 핸들러 본문(B25) · **응답 키(RESPONSE_SET)=PROC_M OUT COL_NM(B26)** · **기간형 동적 헤더 = 사내 배선 타이틀 시트 FE 조회(B27)**. `--final` 에서 BLOCK. 대사표 게이트: M08(As-is DB루프 컬럼 생성 행 누락, WARN) · M09(엔드포인트 '구현' 인데 사내 정확 배선 시트 FE 미조회 = 구현 근거 불일치, final BLOCK) |
| `gen.js`/`templates.js` 공통 버튼 | As-is `members.csv`(BaseForm override: Find/Insert/Delete/Save/Edit/Excel/Upload) 로 hotkeyConfig 를 **근거 주석과 함께** 채움 — 정의 없으면 false 명시, UsrConditionPanel 없으면 condition/resetCondition false, Insert/Delete 는 `GridAction.addRow/removeRow` 스텁 |
| `rules/tobe_catalog.csv` + `check.js D01` | TobeFacts `framework.js` 카탈로그의 컴포넌트 전부가 허용 집합 — 사전 밖 컴포넌트는 전 tsx 에서 WARN |
| `pipeline.js` / `harness_pipeline.cmd <ID> [--e2e] [--no-claude]` | FE 골격 → 등록 SQL → PKG 골격 → FE 수선 루프 → PKG 이식 루프 → E2E 스펙 → 대사표. `Doc/gen/<ID>/PIPELINE.md` 에 단계·다음 할 일 |
| `prompts/new_screen.md` | 입력 6 카탈로그(있는 것만 쓴다) · 7 예제, 상단에 DoD 요구 |

### 2026-10-23 — VALIDATION 취합 참고자료 연결 (사용자 지시)
- 원천: `Doc/화면분석서/{SCP|SSP}_화면_VALIDATION_취합_<STAMP>.md`(엑셀 전 시트 텍스트본) + 같은 이름 폴더 `<ID>.md`(화면별)·`_INDEX.md`. 엑셀 재생성 시 `Doc/화면분석서/_work/SCP_SSP_UI_VALIDATION_20261022/export_md.py` 재실행. STAMP 는 최신 자동 선택.
- `lib/valref.js` — 화면 ID → 화면 파일·차단/보정_필터/제외 행·적용여부·TAG 집계(SCP/SSP 외 null).
- 생성기 `gen.js` → GEN_NOTES **§11**(화면 파일·건수·대조 지시) · 프롬프트 `new_screen.md` **6-1/6-2**(UI 검증·메시지) · `port_pkg.md` **3-1/3-2**(DB 검증) · `repair-loop.js`·`new-screen.ps1` 지시문에 화면 파일 첨부.
- 게이트(WARN — 취합은 2026-10-22 판독 시점 판정이라 이후 보완은 코드 우선): `check.js` **VR1**(UI 미적용 행) · **VR2**(취합이 [메시지 불일치]/[메시지 미등록]으로 판정한 TO-BE ID 가 코드에 잔존 — 의도면 같은 줄 `VR-OK`) · `check-pkg.js` **VR3**(DB 미적용·TAG 현황). 룰 `VibeManager/rules/10_RULES_KEEP.md` E10.

### 2026-10-23 — AS-IS 액션 대조표 (사용자 지시: 사전 미등록 외부 호출까지 대조표·게이트 연결)
- 원천 `Doc/asisfacts/screens/<AS-IS ID>/actions.csv`·`actions_entries.csv`(AsisFacts pack 액션 추출). `lib/actions.js` 가 사용자 결과에 영향 있는 kind 전수를 `__asis-actions__.md` 로 렌더(메서드별 묶음, 진입점·호출 조건·guard·종류·대상·값·의미·TO-BE 위치·상태·사유). 행 ID `AC-<hash8>` 고정 → 재생성 시 상태·위치·사유·의미 보존.
- 신규 화면 = `gen.js` 가 페이지 폴더에 생성 · 기존 화면 문서 = `node tools/Harness/actions-checklist.js <ID>|--all` → `Doc/asisfacts/screens/<AS-IS ID>/__asis-actions__.md`(커밋본 페이지·Doc/gen 무변경 — Doc/gen 은 VM 생성분 판정·gen.js 삭제 대상이라 쓰지 않음). 2026-10-23 445화면 생성(226,959행 · 의미 확인 필요 9,609).
- `CALL_EXT`(사전 미등록 외부)·`CALL_BASE`(상속 메서드) 행 '의미' = `⚠ 의미 확인 필요` → AS-IS 원문 확인 후 실제 의미 기입.
- 게이트 `check.js`: **AC0** 대조표 없음(WARN) · **AC1** 상태 빈칸/미구현/위치·사유 누락 · **AC2** 의미 미기입 — 페이지 폴더 대조표(신규 화면)는 --final BLOCK, 기존 화면 문서는 항상 WARN(사용자 지시: 개발된 UI·흐름 무영향, 문서 보강 먼저). 프롬프트 `new_screen.md` 6-3 · 룰 `10_RULES_KEEP.md` E11.

### 2026-10-26 — 독립 판정 · 근거 등급 · 결과 봉투 (Atlas Studio 규약 이식)
| 파일 | 역할 |
|---|---|
| `e2e-judge.js <ID> <kind> [--round N] [--from json]` | 🩹 수선 뒤 **새 Claude 세션·읽기 전용**(Read·Glob·Grep) 독립 판정 → `Doc/gen/<ID>/E2E_REPAIR.result.json`(decision.expectFix = 근거 확인된 기대값 결함만 보정 허용 · decision.human = 사람 확인 큐 `Doc/e2e/_human_review.md`) |
| `verify/evidence_check.py <봉투>` | 근거(경로:줄 + 원문 인용)가 실제로 있는지 기계 확인 → 이슈별 grade hard/soft |
| `verify/weaken_check.py <ID> --snapshot/--compare` | 시험 기준 보정 전후 테스트 약화(검사 감소·skip 증가·예외 삼키기·파일 삭제) → `Doc/gen/<ID>/E2E_EXPECTFIX.result.json` |
| `lib/envelope.js` ↔ `verify/envelope.py` | 결과 봉투 vibe-result/1(state·verdict·summary·issues·evidence) 읽기·쓰기 — 없음·깨짐 = error. 생산처: e2e-judge · check.js(`CHECK.result.json`) · run_verify(`Doc/verify/<ID>/run_verify.result.json`) |
상세·한계: `Doc/verify/README.md` §12 · 변경 이력: `tools/VibeManager/CHANGELOG.md`.

---

## 2026-11-13 — CheckList 체인 현재 단계 · AS-IS Live · 도구 등록부 (전수 점검에서 한곳으로 모음)

이 절이 **검증·실측 도구의 등록 단일 출처**다. 새 도구를 만들면 ① 체인(`verify/run_verify.py`) 또는 VM 작업(`tools/VibeManager/steps.json`)에 연결하거나 손 실행 도구임을 정하고 ② `python scripts/rules/inventory_check.py --write-registry` 로 아래 등록부를 다시 만든 뒤 ③ `python scripts/rules/inventory_check.py` 가 PASS 인지 본다. 등록부에 없는 도구 파일이 있으면 그 점검이 실패한다(REGISTRY).
점검 근거·당시 수치: `Doc/_rules_consolidation/2026-11-13_INVENTORY_정리안.md`.

### CheckList 체인 (`verify/run_verify.py` — VM `S8.verify`)

| 단계 | 세부 수(`STAGES`) | 실행 순서 |
|---|---:|---|
| pre | prereq 가 냄 | `prereq.py`(DB 접속 점검 · TO-BE 메타 export · 골든 케이스 · `gen.js --plan-only` · `gen-e2e.js` · smoke) + 보조 `db_orphan_sessions.py --ensure-watch` |
| facts | 15 | `facts_defcols` → `facts_gridcols`·`dyncols`·`cellclear`·`cellrules`·`lockrules`·`combosrc`·`combovalues`·`sortrules`·`prereq` → `facts_popup_meta` → `facts_append_tables` → `gen_expect` → `scenario_env` → `ledger` |
| static | 10 | `syn_check` → `syn_fix`(차단 객체 있을 때) → `sort_check` → `align_check` → `popup_args_check` → `popup_data_check` → `f10_check` → `DbConn/golden.py` → `b7_check` → `mapping_trace --to-ledger` |
| e2e | Playwright 테스트 수 | (`gen_cleanup_spec --write` — 정리 정의 없을 때) → `_verify`·`_trace`·`_snap` 스펙 |
| eg | 1 | `eg_chain.py` = `facts_popup` · `facts_popup_meta` · `eg_popup` 스펙 · `facts_popup_golden` · `facts_auth` · `eg_auth` 스펙 · `facts_auth_combo` (tier all/slow 에서만) |
| diff | 7 | `sqllog_calls --from-calls` → `gen_param_map` → `diff_verify` → `diff_ingest` → `asis_live_auto` → `tools/AsisLive/asis_live_screen.py --after-basic` → `asis_live_ingest` (`--static`·`--only` 는 건너뜀) |
| post | 31 | `combo_oracle` → `db_orphan_sessions --kill` → `restore_touched` → `cleanup_marker` → `save_audit` → `sp_branch_check` → `a1_live` → `asis_live_rows` → `sp_dml_check` → `i18n_static` → `lookup_check` → `sort_ci_check` → `i18n_lang_check` → `measure_sweep` → `db_ref_check` → `display_sort_check` → `all_cols_check` → `combo_live_check` → `measure_by_site_check` → `bg_style_check` → `master_sweep` → `titleset_check` → `eg_ingest` → `oracle_class --check` → `judge` → `mapping_trace --to-ledger` → `eg_ingest` → `judge` → `mapping_trace` → `impl_engine` → `coverage` |
| docs | 4 | `make_verify_docs` → `regress --harvest` → `checker_regress` → `precision` (`--static` 은 `static_gate` 1) |

- 실행 전 게이트: `engine_selfcheck.py --if-changed` — 감시 파일이 마지막 전체 통과 뒤 바뀌었으면 전체 검사. 감시 범위(Python) = `tools/Harness/verify` · `tools/DbConn` · `tools/Harness` · `tools/AsisLive` · `tools/Docs`(뒤 2개는 2026-11-13 추가). 전체 검사에는 TO-BE 룰 원장 무결성(`tobe_rule_registry.py --check`)이 포함된다(2026-11-13 추가).
- 단계에 `run()` 을 넣거나 빼면 `STAGES` 의 세부 수와 `run_verify.py` 머리말의 "현재 실행 단계" 를 같이 고친다. 어긋나면 실행 로그에 `[WARN] 진행 표시 — 단계 …` 가 남고 `inventory_check.py` 의 STAGE_WARN 이 그 줄을 센다.
- VM 체인(`quick.json`): `full` · `new-asis-full` · `new-design-full` · `autofix-full` · `docs` · `testreport`. 체인 단계의 실재 여부는 `inventory_check.py` 의 VM_JSON 이 본다.

### AS-IS Live (AS-IS 런처 실구동 — 2026-11-12~13)

- **무엇**: AS-IS WinForms 런처를 이 PC 에서 실제로 구동해 화면 열기·조회 → 컨트롤·그리드 덤프·캡처·서버 호출(SP·인자·건수)을 모은다. 호스트 = `tools/AsisLive/host`(런처 프로세스 안 구동 · AS-IS 소스 무수정) · 로컬 서버 = IIS Express 8086(`tools/AsisLocal/asis_iis.cmd`) · 환경 점검 = `tools/AsisLocal/asis_env_check.py`.
- **산출물**: `Doc/asislive/<ID>/run_<시각>/`(run.json · calls.json · controls.json · grids.json · shots · summary.md) + `latest.json` · 엔진 반영 `Doc/verify/<ID>/asis_live/` · 전체 요약 `Doc/asislive/_summary.csv` · `_ingest_summary.csv` · 동시 실행 잠금 `Doc/asislive/_run.lock`.
- **CheckList 연결**: diff 단계 `asis_live_auto.py`(24시간 안 정상 실측이 있으면 재사용 · 없으면 8086·런처를 띄워 조회 · 메뉴 목록 응답이 느리면 띄우지 않고 미측정) → `asis_live_screen.py --after-basic`(소스 분기 시나리오 도출 → 버튼 분기 실행 → 실행 현황 → TO-BE 조건 대조 · 저장 계열 버튼은 누르지 않음) → `asis_live_ingest.py`. post 단계 `asis_live_rows.py` 가 AS-IS 실구동 건수 ↔ TO-BE 건수를 `a1_live.csv` 에 넣어 `eg_ingest` 의 A1 행이 된다(같은 조건일 때만 · 소량 차이 = 판정필요 · TO-BE 0건/공통 키 0 = FAIL).
- **끄기·미측정**: 환경변수 `VERIFY_ASIS_LIVE=off` · 대상 아님/환경 미비/잠금 대기 초과 = rc 3(미측정)으로 체인 계속(판정 행을 만들지 않음).
- **대상 제외(사용자 결정 2026-11-13)**: FP 화면 전체 · Material 필수 4개(FP02510 · FP02800N · SCP0008 · SCP0038).
- **VM**: 작업 `S1.live*`(목록은 아래 등록부의 `tools/AsisLive/` · `tools/AsisLocal/` 표 "진입" 열) · 체인 `full`·`docs`·`new-asis-full`·`autofix-full`·`testreport` 의 선택 단계 `S1.live`(실측이 없을 때만).
- **문서**: `verify/asis_live_doc.py` 가 테스트결과서 'AS-IS 실측' · 화면설계서·UI분석서 '부록.AS-IS 실측' 시트를 만든다(실측이 없으면 시트 없음).
- 진행 기록·결정 이력 = `Doc/verify/_ENGINE_MASTER.md` 의 "AS-IS Live" 절 이하 · VM 변경 = `tools/VibeManager/CHANGELOG.md` 2.0.5~.

### 도구 등록부

<!-- TOOL-REGISTRY:BEGIN -->
> 자동 생성 — `python scripts/rules/inventory_check.py --write-registry` (2026-11-19 17:09 · 도구 242개 · 손 실행 35개). 직접 고치지 말고 다시 생성한다.
> 진입 열: `체인 <단계>` = `run_verify.py`(CheckList) 가 그 단계에서 실행 · `VM <작업 id>` = `tools/VibeManager/steps.json` 작업 · `다른 도구가 사용` = import·호출만 · `손 실행` = 어떤 진입점에도 연결 없음(명령줄에서 직접).


### `scripts/rules/`

| 도구 | 진입 | 머리말 첫 줄 |
|---|---|---|
| `build_router.py` | 다른 도구가 사용: inventory_check.py, verify_hooks.ps1 | build_router.py — RULESET_MASTER.md 에서 '경량 진입 문서' 2종을 추출 생성한다. |
| `inventory_check.py` | 다른 도구가 사용: extension.js | 룰·hook·하네스 등록 정합 점검 (2026-11-13 전수 점검에서 상시 도구로 — 읽기 전용) |
| `scan_labelless_toggle.py` | 다른 도구가 사용: check-ui-gates.ps1 | hook #154 search-condition-labelless-toggle-input-column — 전수 스캔기 (v2 2026-10-23). |
| `verify_hooks.ps1` | 손 실행(진입점 연결 없음) | verify_hooks.ps1 — 2026-10-12 재구성 검증 (Windows PowerShell 에서 실행) |

### `tools/AsisLive/`

| 도구 | 진입 | 머리말 첫 줄 |
|---|---|---|
| `asis_live_batch.py` | VM S1.liveFill | AS-IS 실측 일괄 실행 (2026-11-12 · 승인 플랜 velvet-conjuring-lake P5) |
| `asis_live_cell_facts.py` | 손 실행(진입점 연결 없음) | asis_live_cell_facts.py — AS-IS 런처 셀 실행 결과를 열 단위 사실표로 모은다 (2026-11-15, 27화면 미검증·미판단 0 작업) |
| `asis_live_cond.py` | VM S1.liveCond | AS-IS 실측 ↔ TO-BE 검증의 조회 조건 대조 (2026-11-13 · 플랜 P5 조건 시나리오 1단계) |
| `asis_live_datafind.py` | 다른 도구가 사용: asis_live_run.py, asis_live_scen_run.py | AS-IS 런처 조회 0행 → 데이터 있는 조회조건 자동 탐색·재조회(2026-11-17 사용자 지시: 배치에서 사람이 시트·조건을 지정하지 않는다). |
| `asis_live_excel.py` | 다른 도구가 사용: asis_live_scen_event.py, asis_live_scen_input.py, asis_live_scen_run.py | 런처가 띄운 Excel 기록·종료 (2026-11-13 · 사용자 지시 "EXCEL DOWN 등으로 런처가 EXCEL 을 실행한 경우에도 EXCEL 확인 후 종료") |
| `asis_live_fill.py` | 다른 도구가 사용: asis_live_batch.py, asis_live_datafind.py, asis_live_save.py 외 2 | AS-IS 실측 2차 — 필수 조회조건을 "가장 최근 값"으로 채운다 (2026-11-12 · 사용자 결정 "최근 값으로 진행") |
| `asis_live_msg_cover.py` | 다른 도구가 사용: asis_live_proof_answers.py | AS-IS 경로 메시지 실측 대조 (2026-11-15) |
| `asis_live_overlap.py` | 다른 도구가 사용: asis_live_scen_cov.py | asis_live_overlap.py — 런처 실행이 서로 겹친 실행 폴더 찾기 (2026-11-14 잠금 결함 사후 점검) |
| `asis_live_proof_answers.py` | 다른 도구가 사용: asis_live_proof_join.py | asis_live_proof_answers.py — 런처 몫 미증명 항목(_proof_live_targets.csv)마다 AS-IS 런처 실행 결과(정답)가 있는지 연결한다 (2026-11-15, 27화면 미검증·미판단 0 작업) |
| `asis_live_proof_join.py` | 손 실행(진입점 연결 없음) | asis_live_proof_join.py — 런처 정답 연결(_proof_live_answers.csv)에 판정 단위와 다음 조치를 붙인다 (2026-11-16 사용자 지시: 정적으로 되는 것은 정적으로, 런처는 동적 항목만) |
| `asis_live_proof_targets.py` | 다른 도구가 사용: asis_live_proof_answers.py | asis_live_proof_targets.py — 증명 목록(_proof_backlog)의 미증명 검사 단위 가운데 AS-IS 런처 실행으로 정답을 줄 수 있는 것을 고른다 (2026-11-14 사용자 지시: 27화면에서 미검증·미판단 0 먼저) |
| `asis_live_rule_map.py` | VM S1.liveRuleMap | AS-IS 관찰 문구 → TO-BE 룰 대응표 생성 (2026-11-13 · 사용자 "TO-BE RULE 로 정의된 부분은 AS-IS 와 차이가 발생해도 오류가 아니다") |
| `asis_live_run.py` | VM S1.live | AS-IS 실측 실행기 (2026-11-12 · 승인 플랜 velvet-conjuring-lake P0) |
| `asis_live_save.py` | VM S1.liveSaveDry·S1.liveSave·S1.liveSaveDraftDry | AS-IS 저장 시나리오 — 수정 · 없던 행 입력 · 여러 행 · 검증 메시지 · 팝업 삭제 → 저장 인자 포착 → 원래 값 복원·대조 (2026-11-13 · 플랜 P6-2) |
| `asis_live_save_cmp.py` | VM S1.liveSaveCmp | AS-IS 저장 인자 ↔ TO-BE 저장 인자 대조 (2026-11-13 · 플랜 P6-4 저장) |
| `asis_live_save_draft.py` | VM S1.liveSaveDraft | 저장 시나리오 정의 초안 — 저장 SP 원문과 DB 키, 화면 그리드에서 근거를 모아 초안을 만든다 (2026-11-13, 플랜 P6-2) |
| `asis_live_scen.py` | 다른 도구가 사용: asis_live_scen_loop.py | TO-BE 검증 조건 → AS-IS 조건 시나리오 (2026-11-13 · 플랜 P5 조건 시나리오 2단계) |
| `asis_live_scen_cmp.py` | VM S1.liveScenCmp | 소스 분기 시나리오별 AS-IS 실행 결과 ↔ TO-BE 검증 결과 대조 (2026-11-13 · 플랜 P6-4) |
| `asis_live_scen_cov.py` | VM S1.liveScenCov | 소스 분기 시나리오 ↔ 런처 실측 실행 여부 (2026-11-13 · 플랜 P6) |
| `asis_live_scen_event.py` | VM S1.liveScenEvent | 스크롤 · 키 입력 · 붙여넣기 분기 실행 (2026-11-14, 플랜 P6-2) |
| `asis_live_scen_input.py` | VM S1.liveScenInput | 셀 값 입력 분기 · 시트 전환 분기 실행 (2026-11-13, 플랜 P6-2) |
| `asis_live_scen_loop.py` | VM S1.liveScen | TO-BE 조건 시나리오 반복 실행 (2026-11-13 · 플랜 P5) |
| `asis_live_scen_matrix.py` | VM S1.liveScenMatrix | 버튼 분기 실행 결과를 그룹(권한)·Division 별로 맞대는 표 (2026-11-13 · 플랜 P6-3) |
| `asis_live_scen_run.py` | VM S1.liveGroups·S1.liveScenRun·S1.liveScenRunGroup·S1.liveScenRunDiv 외 2 | 소스 분기 시나리오 실행 — 화면 안 버튼으로 타는 조회·팝업 분기 (2026-11-13 · 플랜 P6-2 1단계) |
| `asis_live_scen_spec.py` | VM S1.liveScenSpec | 소스 분기 전부에 대한 시나리오 명세 — 분기마다 "무엇을 해야 그 분기를 타는지 · 그 조작을 실행할 수단이 있는지 · AS-IS/TO-BE 에서 실행됐는지" |
| `asis_live_scen_src.py` | VM S1.liveScenSrc | 소스 분기 기반 시나리오 도출 (2026-11-13 · 플랜 P6-1 · 사용자 지시 "소스를 확인해서 확인이 필요한 시나리오를 직접 수립") |
| `asis_live_scen_unreached.py` | VM S1.liveScenUnreached | 진입 경로 없는 분기 분류 — 그 메서드를 부르는 곳을 현행 소스 원문에서 다시 찾는다 (2026-11-13, 플랜 P6-1) |
| `asis_live_scen_values.py` | VM S1.liveScenValues | 분기 조건식에서 전제 값(Division, 그룹) 도출 → 실행 계획 → 실행 (2026-11-13, 플랜 P6-3) |
| `asis_live_screen.py` | 체인 diff / VM S1.liveScreen | 화면 1개의 AS-IS 런처 실측 묶음 — CheckList 작업 때 구동 (2026-11-13 · 사용자 지시 |
| `asis_live_sheet_nav.py` | 다른 도구가 사용: asis_live_scen_run.py | AS-IS 시트 → 탭 전환 경로(2026-11-17 SCP0104 SOP 탭 런처 자동 전환). |
| `asis_live_winwatch.py` | 손 실행(진입점 연결 없음) | 자동화 런처(AsisLive.Host)의 보이는 창 수를 30초마다 기록 — 창 쌓임 재발 감시. 인자: 로그 경로 · 감시할 python PID 파일 |
| `backfill_calls.py` | 손 실행(진입점 연결 없음) | AS-IS 실측 호출 목록 다시 채우기 (2026-11-12) |
| `excel_guard.ps1` | 다른 도구가 사용: asis_live_excel.py | AS-IS Live — 런처가 띄운 Excel 을 기록하고 닫는다 (2026-11-13 · 사용자 지시 "EXCEL 확인 후 종료") |
| `probe.py` | 체인 pre(prereq 안) / VM S2.probe | AS-IS 실측 탐침 — 화면을 열고 조건 설정 명령을 차례로 보낸 뒤 조건 컨트롤 상태를 찍는다(규칙 설계·확인용). |

### `tools/AsisLocal/`

| 도구 | 진입 | 머리말 첫 줄 |
|---|---|---|
| `asis_env_check.py` | VM S1.liveCheck | AS-IS 로컬 실행 환경 점검 (2026-11-12 · 승인 플랜 velvet-conjuring-lake P1) |
| `asis_iis.cmd` | 다른 도구가 사용: asis_env_check.py, asis_live_auto.py | if not exist "%IIS%" ( echo [FAIL] IIS Express not found: %IIS% & exit /b 2 ) |
| `audit_foxquery.py` | 손 실행(진입점 연결 없음) | AS-IS 소스가 호출하는 FoxQuery id ↔ FoxQuery/*.foxml 정의 대조 (2026-11-12) |
| `force_asis_mssql.py` | 손 실행(진입점 연결 없음) | 로컬 AS-IS 실행 사본의 모든 DB 연결을 AS-IS MSSQL(.env.asis) 로만 강제 (2026-11-12 사용자 지시 "DB 연결은 AS-IS MSSQL 로만") |
| `gen_foxquery_supplement.py` | 손 실행(진입점 연결 없음) | 코드는 호출하지만 FoxQuery 에 정의가 없고 DB 프로시저는 있는 id → 로컬 사본 foxml 에 보충 정의 생성 (2026-11-12) |
| `make_local_wsl.py` | 손 실행(진입점 연결 없음) | AS-IS 웹 서비스(04.WSL) 로컬 실행용 사본 생성 (2026-11-12) |

### `tools/DbConn/`

| 도구 | 진입 | 머리말 첫 줄 |
|---|---|---|
| `bucket_day.py` | 다른 도구가 사용: _verify.spec.ts | 사업부 기본 Bucket 요일 — AS-IS UP_FX_GetCommonDataList 'DefaultBucketDay'(SCM_ADM_LOOKUP_MASTER_DETAIL LOOKUP_TYPE='DEFAULT_BUCKET_DAY' SEGMENT1=Division SE |
| `dbconn.py` | 다른 도구가 사용: a1_live.py, all_cols_check.py, asis_batch_facts.py 외 66 | dbconn — NSCM DB 접속정보 레지스트리 (비밀번호는 절대 출력/저장하지 않는다) |
| `export_tobe_meta.py` | 체인 pre(prereq 안) / VM S2.export | export_tobe_meta — To-Be Oracle 메타를 CSV 로 내려 Doc        obefacts\db\ 에 둔다 (gap.js / gen.js / E2E 생성기가 읽는다). |
| `gen_golden_cases.py` | 체인 pre(prereq 안) / VM S4.goldgen | gen_golden_cases — 화면별 골든 케이스 초안 생성 (As-is SP ↔ To-Be PKG.PROC 짝 + 파라미터) |
| `golden.py` | 체인 static / VM S4.golden | golden — As-is SP(MSSQL) 와 To-Be PKG.PROC(Oracle) 를 같은 파라미터로 실행해 결과셋을 대조한다. |
| `list_asis_programs.py` | 다른 도구가 사용: workbench.js | list_asis_programs — AS-IS DB(.env.asis MSSQL) 접속해서 사용 중(UseYN='Y')인 프로그램 목록을 JSON stdout 으로 반환. |
| `meta_apply.py` | VM S5.regrun·S5.regcommit | meta_apply — Vibe_Manager 👀 META 미리보기 / ✅ META 커밋 (사용자 지시 2026-10-22: 사내 META 작업 때 PROCEDURE 도 같이) |
| `probe.py` | 체인 pre(prereq 안) / VM S2.probe | probe — 등록된 모든 DB 접속을 시험하고 리포트(Doc\db\probe_<날짜>.md)를 남긴다. 비밀번호는 기록하지 않는다. |
| `run_sql.py` | VM S5.revert·S5.revertcommit | run_sql — 하네스가 생성한 SQL*Plus 스타일 스크립트(<ID>_PKG.sql, <ID>_registration.sql)를 python-oracledb 로 실행한다 (SQL*Plus/SQLcl 불필요) |

### `tools/Docs/`

| 도구 | 진입 | 머리말 첫 줄 |
|---|---|---|
| `doc_archive.py` | 다른 도구가 사용: make_docs.py, make_test_report.py, make_testcases.py 외 1 | 버전 문서 공용 — 다음 버전 번호 · 이전 버전 old/ 이동 (2026-10-28 사용자 요청) |
| `doc_style.py` | 다른 도구가 사용: llm_desc.py, make_docs.py, make_test_report.py 외 5 | 문서 문장 규칙 검사 — 사용자 상시 지시 2026-11-13 |
| `make_docs.py` | VM S3.xlsx | make_docs — 화면 ID 하나로 사람이 보는 Excel 문서 4종을 팀 양식(hook #105 · TestCases4)으로 생성한다. |
| `make_testcases.py` | 다른 도구가 사용: doc_archive.py, make_docs.py | make_testcases — 단위테스트(TestCases4) 를 '실제 사용자 흐름' 으로 재구성해 생성한다 (2026-10-27 사용자 지시). |
| `md2xlsx.py` | 다른 도구가 사용: agent.ps1 | md2xlsx — 화면 문서(MD) + Fact Pack CSV + GAP CSV 를 사용자가 보는 Excel 1권으로 묶는다. |
| `screen_status.py` | 다른 도구가 사용: workbench.js | 화면 건수 현황판 생성 (샘플 2026-11-18). |

### `tools/E2E/`

| 도구 | 진입 | 머리말 첫 줄 |
|---|---|---|
| `extract-role-users.py` | 손 실행(진입점 연결 없음) | extract-role-users — SCP·SSP 권한 × Division 대표 사용자 추출 (사내오라클 실조회, 2026-10-27 사용자 지시) |
| `gen-accounts.py` | VM S7.accounts | gen-accounts — 통합테스트_데이터셋(04_TESTDATA_SET.xlsx) 의 테스트계정·권한매트릭스·시나리오 → accounts.json / scenarios.csv |
| `gen-e2e.js` | 체인 pre(prereq 안) / VM S7.gen | gen-e2e — Fact Pack(e2e_plan.json) + Oracle 메타 + 테스트계정 → Playwright 스펙 생성 |
| `lint_tpl_regex.py` | 손 실행(진입점 연결 없음) | E2E 스펙·프로브의 템플릿 문자열(백틱) 안 단일 역슬래시 정규식 검사(2026-11-02 T40) — JS 가 \d·\s 의 역슬래시를 버려 정규식이 조용히 깨진다 |
| `probe-accounts.js` | VM S7.probe | probe-accounts — accounts.json 의 계정(+ defaultAccount + scenarios 계정)을 BE 로그인으로 실제 확인해 loginOk 를 기록한다. |
| `report.js` | 다른 도구가 사용: e2e_paths.py, gen_expect.py, gen_expect_recall.py 외 3 | port — Playwright results.json → 화면별 Doc/e2e/results/<ID>/_summary.csv·_summary.md(정본) + 공용 색인 Doc/e2e/results/_summary.csv·_summary.md (화면×종류 판정, 어노테 |
| `run-e2e.cmd` | 체인 e2e / 체인 pre(prereq 안) / VM S7.smoke·S7.crud·S7.auth·S7.authcrud 외 1 | 2E batch runner: deps check -> run lock -> FE/BE check -> accounts/specs -> Playwright -> report |
| `runlock.js` | 체인 e2e·eg | unlock — run-e2e.cmd 의 동시 실행 방지 + 실행 ID 발급 (2026-10-21) |

### `tools/Harness/`

| 도구 | 진입 | 머리말 첫 줄 |
|---|---|---|
| `actions-checklist.js` | 다른 도구가 사용: check.js | AS-IS 액션 대조표 생성/갱신 (사용자 지시 2026-10-23) — **문서 보강 단계: 개발된 FE·작업 흐름 무영향** |
| `check-pkg.js` | VM S5.pkgcheck | check-pkg — PKG 이식 게이트: Doc/gen/<ID>/<ID>_PKG.sql (또는 --file) 에 T-SQL 잔재·미이식 TODO·ASIS 원문 블록이 남아 있으면 BLOCK |
| `check.js` | VM S5.check·S5.final·S5.tsc | 하네스 게이트 — To-Be 화면 폴더를 As-is Fact Pack + 사전(rules/) 에 대고 판정한다. Claude Code hook / husky / CI 가 같은 이 파일을 부른다. |
| `e2e-judge.js` | 다른 도구가 사용: llm_call.py, weaken_check.py, workbench.js | 2e-judge — 🩹 E2E 오류 보완의 '독립 판정 세션' (2026-10-26, Atlas Studio 규약 이식: 검토자 분리 · 근거 등급) |
| `gap.js` | 다른 도구가 사용: export_tobe_meta.py, gen-e2e.js, gen.js 외 3 | GapCheck — As-is Fact(Doc/asisfacts) vs To-Be Fact(Doc/tobefacts) 를 화면(MENU_ID)별로 대사해 3분류한다. |
| `gen-pkg.js` | VM S5.pkg | gen-pkg — 화면의 As-is SP 들을 To-Be 규약의 Oracle PACKAGE 골격(SPEC+BODY)으로 생성한다. SQL 본문 이식은 TODO(Claude Code / 사람) — FE 골격과 같은 방식. |
| `gen-register-sql.js` | VM S5.regsql | gen-register-sql — 신규 화면의 Oracle 메타 등록 SQL(7영역) 을 Fact Pack 에서 생성한다 (템플릿: To-be_v2_converted/08_Screen_Registration/02_NEW_SCREEN_FULL_REGISTRATION_TE |
| `gen.js` | 체인 pre(prereq 안) | TobeGen — As-is Fact Pack(Doc/asisfacts/screens/<ID>) + 매핑 사전(rules/) → To-Be 화면 골격 생성기 (결정론적, LLM 없음) |
| `install.js` | 손 실행(진입점 연결 없음) | 하네스 설치 — .claude/settings.json 에 hook 3개를 병합(중복 없이), husky pre-commit 에 게이트 한 줄 추가. 백업을 남긴다. |
| `mine-examples.js` | VM S2.examples | ine-examples — 하우스 스타일 few-shot 코퍼스: 매핑표(상태 구현)의 "As-is 항목 → To-Be 구현 위치(파일:라인)" 짝에서 실제 코드 조각을 떠서 |
| `mine.js` | VM S2.mine | 짝지어진 화면(As-is Fact ↔ To-Be Fact + __asis-mapping__.md)에서 매핑 사전 초안을 채굴한다. |
| `pipeline.js` | VM S5.pipeline·S5.pipelinedesign·S5.pipelinedry·S5.pipelineregen | pipeline — 화면 ID 하나로 끝까지: FE 골격 → 등록 SQL → PKG 골격 → FE 수선 루프(게이트 PASS) → PKG 이식 루프 → E2E 스펙 → [E2E 실행] → 대조표 갱신 |
| `pre-commit.js` | 다른 도구가 사용: install.js | husky pre-commit 용 — 스테이징된 파일이 속한 화면 폴더마다 check.js (BLOCK 만 커밋 차단, 미구현은 경고) |
| `repair-loop.js` | VM S5.repair·S5.pkgrepair | pair-loop — 화면 하나를 사람 개입 없이 끝까지: 골격 생성(gen --apply) → Claude Code 채움 → 게이트(check --final: 매핑표·대사·tsc·eslint) → 실패 findings 를 붙여 재시도 … → PASS 또는 사람 확인  |
| `snapshot.js` | VM S6.snapshot·S6.snapupd | snapshot — 생성기 회귀 테스트: 전 화면 골격을 임시 폴더에 생성해 파일 해시를 기준선과 비교한다 (룰/템플릿 변경이 의도한 화면만 바꿨는지 확인) |
| `suggest-rules.js` | VM S6.suggest | 룰 보완 후보 — Doc/gap/*_gap.csv 의 MISSING/UNMAPPED 를 유형별로 집계해, 사전에 붙여 넣을 수 있는 CSV 행 초안을 만든다 (6단계 "원천 차단" 루프의 입력). |
| `templates.js` | 손 실행(진입점 연결 없음) | To-Be 화면 골격 템플릿 — 표준 참조 nscm-fe/features/admin/src/pages/user-management 의 구조·import 순서·명명 을 그대로 따른다. |

### `tools/Harness/verify/`

| 도구 | 진입 | 머리말 첫 줄 |
|---|---|---|
| `a1_live.py` | 체인 post | 화면 실전송 인자로 AS-IS 조회 SP 실행 → 건수·키 대조(2026-11-01 엔진 갭 EG006) |
| `active_policy.py` | 다른 도구가 사용: combo_oracle.py | 콤보 후보의 Active 정책 판정(2026-11-02 엔진 갭 EG055) |
| `align_check.py` | 체인 static | H1 가로 정렬 정적 검사 — AS-IS 그리드 컬럼 정렬 ↔ TO-BE 컬럼 메타(HORIZONTAL_ALIGN_CODE) + 화면 FE 정렬 덮어쓰기 (2026-10-27) |
| `all_cols_check.py` | 체인 post | 전 컬럼 선택 조회 SQL 오류(2026-11-03 엔진 갭 EG213 · GAP-340 Forecast Info All ORA-01722 유형) |
| `applicability.py` | 다른 도구가 사용: e2e_suite_ingest.py, judge.py | GENERAL(타 화면 결함 일반화)·DEFECT·CONFIRMED·RULE_SCREEN 행의 '이 화면 적용 여부'(2026-11-06 플랜 1-4) |
| `asis_delete.py` | 다른 도구가 사용: _trace.spec.ts, asisdelete.selftest.js, gen_expect.py 외 1 | AS-IS Delete 동작 판정 단일 원천(2026-11-09 T173 — SSP0025 2·4번 허위 FAIL) |
| `asis_layout.py` | 다른 도구가 사용: judge.py | AS-IS 조회조건 패널 배치 순서 — 디자이너 LayoutControl 좌표(그룹 오프셋 누적) 기준 위→아래 줄, 줄 안 왼→오른 (2026-10-30 SCP0100 조치 필요 6번 계기 · 검사기 결함 T11) |
| `asis_live.py` | 다른 도구가 사용: b7_check.py, facts_auth.py, facts_cellclear.py 외 1 | AS-IS 실행되지 않는 코드(진입점 미연결 메서드) 판정 — 검사기 공통 (2026-10-30 SCP0041 조치 필요 3번 계기 · 검사기 결함 T4) |
| `asis_live_auto.py` | 체인 diff | CheckList 실행 중 AS-IS 런처 자동 구동 (사용자 2026-11-13: "VM CHECKLIST 실행 시 AS-IS 실구동 런처 자동구동해서 필요한 데이터 취합") |
| `asis_live_doc.py` | 다른 도구가 사용: make_docs.py, make_test_report.py | AS-IS 실측(Doc/asislive/<ID>/latest.json) → 문서(xlsx) 시트 (2026-11-12 · 승인 플랜 velvet-conjuring-lake P3) |
| `asis_live_ingest.py` | 체인 diff | AS-IS 실측(Doc/asislive/<ID>/latest.json) → 검증 엔진 입력 (2026-11-12 · 승인 플랜 velvet-conjuring-lake P2) |
| `asis_live_rows.py` | 체인 post | AS-IS 실구동 결과 ↔ TO-BE 결과 건수·데이터 대조 → A1 판정 행 (사용자 2026-11-13) |
| `asis_sp_src.py` | 다른 도구가 사용: gen_param_map.py, golden.py | AS-IS SP 원문(Doc/asisfacts/db/modules/<schema>.<SP>.sql) 판독 공용 함수 (2026-11-18 미검증 해소) |
| `asis_variant.py` | 다른 도구가 사용: asis_layout.py, asis_live.py, asis_live_scen_unreached.py 외 17 | AS-IS facts variant 판정 단일 원천(2026-11-09 SSP0024·SSP0025 CheckList exit 6 — 검사기 결함 T172). |
| `b7_check.py` | 체인 static | B7 기준 데이터 변경 후 후보 갱신 — (a) 이 화면 저장이 콤보 원천을 바꾸는가 정적 대조 (2026-10-28) |
| `backlog_types.py` | 손 실행(진입점 연결 없음) | 전수 목록의 '아직 증명 안 됨' 을 보완 유형으로 묶는다 (2026-11-12 주기 방식 — 일괄 보완의 작업 단위) |
| `bg_style_check.py` | 체인 post | AS-IS 조건부 셀 스타일(SetBGColor/SetFontColor/SetForeColor) ↔ TO-BE 화면 스타일 코드 존재(H2 정적 · EG312 · SCPSSP-14) — Doc/verify/<ID>/bg_style.csv (2026-11-03) |
| `checker_regress.py` | 체인 docs | 검사기 자체 회귀(P3 · 2026-11-06 근본 보완 · W8 플랜 1-6 확장) — 골든 화면의 원장 판정 스냅숏을 기준으로, 검사기·공용 컴포넌트를 고친 뒤 판정이 어떻게 바뀌었는지 대조한다. |
| `checklist_run.py` | VM S8.checklistRecheck·S8.checklistRun | VM 🔎 CheckList 체인의 1단계·3단계 실행기 (2026-11-18 사용자 지시) |
| `checklist_selftest.py` | 다른 도구가 사용: mutate.ts | CheckList 자기검증(변이 시험) — 검사기가 오류를 실제로 잡는지 화면마다 기계적으로 증명 (2026-10-28) |
| `cleanup_marker.py` | 체인 post | 정합검증 CRUD 실제 저장 마커 행 정리 — 사내 DB(tobe)에서 E2E 마커 행과 그 저장이 연쇄로 만든 행을 백업 후 삭제(2026-10-24) |
| `combo_live_check.py` | 체인 post | 콤보 응답 ↔ DB 최신 후보 대조(B7 · EG075 · DM-P1/DM-216) — Doc/verify/<ID>/combo_live.csv (2026-11-03) |
| `combo_oracle.py` | 체인 post | 콤보 후보 AS-IS 원천 비교(W1 · B4 집합 / B3 순서) — Doc/verify/<ID>/combo_oracle.json (2026-10-24) |
| `coverage.py` | 체인 post | 검사 커버리지 집계 — Doc/verify/<ID>/coverage.csv + 봉투 summary.coverage (2026-10-30 WP8-b · 검사기 결함 T13 "Playwright passed ≠ 판정") |
| `db_orphan_sessions.py` | 체인 pre·post | 검증 실행이 사내 Oracle 에 남긴 장시간 세션 찾기·종료 (2026-11-12 T250) |
| `db_ref_check.py` | 체인 post | DB 참조 정합(2026-11-02 엔진 갭 EG142·EG143) |
| `db_snapshot.py` | 다른 도구가 사용: _verify.spec.ts | 저장 전후 DB 스냅샷(2026-10-31 E05) — 저장 대상 테이블에서 화면 행과 같은 키의 행을 읽는다. 저장 세부 판정(행 수 불변·감사 컬럼·연계 테이블)의 원천 |
| `dbq.py` | 다른 도구가 사용: _verify.spec.ts | E2E 시나리오용 단건 DB 조회 — 결과를 JSON 으로 출력(2026-11-03 · dbcell 단계 EG129/EG103) |
| `decisions.py` | 손 실행(진입점 연결 없음) | 결정표 — 기계로 PASS/FAIL 을 못 정한 항목(판정필요·WARN)을 사람이 한 번에 답할 수 있는 표로 만들고, 답을 원장에 '수동' 판정으로 반영한다 (2026-10-26) |
| `defects_import.py` | VM S8.defects | 결함 원장(사람이 수행한 단위테스트 결과) → Doc/verify/defects_baseline.csv |
| `defects_sources_merge.py` | VM S8.merge | 원천 CSV(Doc/verify/sources/*.csv · sources_extract.py 산출) → 결함 원장 확장 (2026-10-30 2단계) |
| `diagnose_layer.py` | VM S8.diagnose | 보완 전 원인 계층 확정(EN-24 · 2026-11-11) — 조치 필요 행마다 원인이 메타·DB 객체·FE 중 어디인지를 '재서' 정한다. |
| `dict_sweep.py` | 손 실행(진입점 연결 없음) | LBL·MSG·MNU 코드 사전 중복 스윕(2026-11-02 엔진 갭 EG358·EG461 · 문서 DM-96 '동일 문구는 하나의 ID 만') |
| `diff_ingest.py` | 체인 diff | 차등 검증 결과(Doc/verify/<ID>/diff/diff_summary.csv) → 원장 행(source=ASIS_DIFF · row_id AD-…) + e2e_results.json 반입(2026-11-06 플랜 2-4) |
| `diff_verify.py` | 체인 diff | 차등 검증(diff) — 화면이 실제로 보낸 call-proc 인자로 AS-IS SP(MSSQL) 와 TO-BE PROC(Oracle) 를 실행해 결과집합을 키 기반으로 비교한다(2026-11-06 플랜 2-4). |
| `display_sort_check.py` | 체인 post | 콤보 후보 표시명 정렬(2026-11-03 엔진 갭 EG053) |
| `doc_patterns.py` | 다른 도구가 사용: gen_expect.py, pattern_coverage.py | doc_patterns.py — 문서 행 → 결함 패턴 연결표(W8-3, 2026-11-05) |
| `doc_proof.py` | 다른 도구가 사용: doc_patterns.py, engine_audit.py, run_docs_batch.py | 3개 문서(defects_classified.csv) 기준 검증엔진 입증 현황 — 진행율의 단일 출처(2026-10-31 사용자: 감·예측 금지, 3개 문서 전체 확인 가능해야 함) |
| `e2e_paths.py` | 다른 도구가 사용: e2e_suite.py, e2e_suite_ingest.py, judge.py 외 4 | e2e_paths — 화면별 E2E 결과·로그 위치 찾기 (2026-11-06 사용자 지시: 화면 ID 중간 폴더) |
| `e2e_suite.py` | 다른 도구가 사용: e2e_suite_ingest.py, run_verify.py, unverified_resolve.py | CheckList 안에서 E2E 테스트 4종 실행 (2026-11-18 사용자 지시) |
| `e2e_suite_ingest.py` | 다른 도구가 사용: e2e_suite.py, run_verify.py | E2E 테스트 결과 중 CheckList 판정에 들어가지 않던 기능 시험 → 원장 ES- 행 (2026-11-18 사용자 지시 |
| `eg_chain.py` | 체인 eg | 엔진 갭 전용 검사기 실행(2026-11-01) — 팝업(eg_popup)·Division·권한(eg_auth). run_verify 가 화면 잠금을 쥔 채로 부른다(--tier all/slow) |
| `eg_ingest.py` | 체인 post | 엔진 갭 전용 검사기(팝업 eg_popup · Division·권한 eg_auth) 결과 → 원장 행 + e2e_results 반입(2026-11-01) |
| `engine_audit.py` | 다른 도구가 사용: inventory_check.py | 검사엔진 존재 전수 조사(2026-10-31) — impl=Y 표시를 믿지 않고 규칙마다 코드에서 확인한다 |
| `engine_gap_cluster.py` | 손 실행(진입점 연결 없음) | 엔진 갭 항목을 신설 묶음(engine)으로 분류해 _engine_gap.csv 에 고정하고 진행 현황을 출력한다(2026-10-31) — 진행율의 분모는 이 파일 |
| `engine_gap_merge.py` | 손 실행(진입점 연결 없음) | 엔진 갭 대조표 병합·온전성 점검(2026-10-31) — gap_*.csv → Doc/verify/_engine_gap.csv(항목 ID 부여·상태 열 유지) |
| `engine_selfcheck.py` | 다른 도구가 사용: inventory_check.py, run_verify.py | 엔진 변경 게이트(EN-00 · 2026-11-11) — 검증·생성 도구를 고친 뒤 실행에 투입하기 전에 '돌려 보면 드러나는' 결함을 실제로 돌려서 잡는다. |
| `envelope.py` | 다른 도구가 사용: decisions.py, evidence_check.py, run_verify.py 외 1 | 결과 봉투 vibe-result/1 — 판정 산출물 옆 <이름>.result.json (2026-10-26) |
| `evidence_check.py` | 다른 도구가 사용: decisions.py, e2e-judge.js, llm_call.py 외 1 | 근거 확인기 — 결과 봉투(vibe-result/1)의 인용 근거가 실제로 있는지 기계로 확인해 근거 등급(hard/soft)을 매긴다 (2026-10-26) |
| `excel_stage_clean.py` | 다른 도구가 사용: _verify.spec.ts | Excel 업로드 시험이 남긴 스테이징 행 정리(2026-11-02) |
| `expect_rows.py` | 다른 도구가 사용: doc_patterns.py, gen_expect.py, gen_expect_recall.py 외 2 | expect_rows — 화면별 기대 행 = 손 행(Doc/verify/<name>) ∪ 자동 행(Doc/verify/<ID>/auto_expect/<name>) (W8-2, 2026-11-04) |
| `f10_check.py` | 체인 static | F10 저장 트랜잭션 원자성 — 화면 저장 PROC(PROC_M SAVE/INS/UPD/DEL 배선)와 그 하위 호출 PROC 본문(사내오라클 ALL_SOURCE 새로 조회 · hook #152)에 |
| `facts_append_tables.py` | 체인 facts | AS-IS 저장 SP 가 '저장마다 새 키로 행을 쌓는' 표 — Doc/asisfacts/screens/<ID>/append_tables.csv (2026-11-10 T212) |
| `facts_auth.py` | 체인 eg(eg_chain 안) | facts_auth — Division·권한 분기 사실 추출(E03 · 2026-10-31). 화면 독립: 컬럼·컨트롤·그룹 이름은 AS-IS 원문/DB 에서만 온다. |
| `facts_auth_combo.py` | 체인 eg(eg_chain 안) | facts_auth_combo — 계정·Div 별 조회조건 후보 ↔ AS-IS 원천(같은 계정·보유 그룹 합집합) 대조. EG367·EG061(조회조건)·EG366 교차 (E03 · 2026-10-31) |
| `facts_auth_db.py` | 손 실행(진입점 연결 없음) | facts_auth_db — E03 정적 DB 대조(화면 없이 측정). 읽기 전용. 결과 = Doc/verify/_parallel/E03/static/<검사>.json + stdout 요약. |
| `facts_cellclear.py` | 체인 facts | 상위 셀 변경 → 하위 셀 초기화 AS-IS 사실(2026-11-01 엔진 갭 EG085) |
| `facts_cellrules.py` | 체인 facts | AS-IS 셀 입력 규칙 추출 — Doc/asisfacts/screens/<AS-IS ID>/cell_rules.csv |
| `facts_combosrc.py` | 체인 facts | AS-IS 콤보 원천 추출 — Doc/asisfacts/screens/<AS-IS ID>/combo_src.csv (W1 B4·B3 AS-IS 원천 비교 엔진의 AS-IS 쪽, 2026-10-24) |
| `facts_combovalues.py` | 체인 facts | AS-IS 콤보 원천 후보 값(정적 사실) — Doc/asisfacts/screens/<AS-IS ID>/combo_values.json (2026-10-28) |
| `facts_defcols.py` | 체인 facts | AS-IS 사실 파일의 컬럼 상수 이름 정규화 (2026-11-12 T266 · 주기 1 C1-27) |
| `facts_dyncols.py` | 체인 facts | AS-IS 런타임(동적) 그리드 컬럼 패밀리 추출 — Doc/asisfacts/screens/<AS-IS ID>/dyn_columns.csv (2026-10-30 SCP0111 월 컬럼 검사 우주 밖 · 검사기 결함 T15) |
| `facts_gridcols.py` | 체인 facts | AS-IS 그리드 컬럼 선언 사실(정합검증용) — Doc/asisfacts/screens/<AS-IS ID>/grid_columns_asis.csv (2026-10-27 사용자 요청: 정합검증에 필요한 AS-IS 정적 정보 추가 취합) |
| `facts_lockrules.py` | 체인 facts | AS-IS 그리드 잠금 규칙 전개 + 컬럼별 편집 기대표 (v2 — 2026-10-30 SCP0111 D1 전면 UNKNOWN 계기 · 검사기 결함 T11) |
| `facts_popup.py` | 체인 eg(eg_chain 안) | AS-IS 팝업 사실 추출 - 팝업마다 트리거·조건 칸·SP·정렬·선택 방식·병합·저장 (2026-10-31 E02 팝업 검사기) |
| `facts_popup_accounts.py` | 손 실행(진입점 연결 없음) | 팝업 계정 간 비교 (2026-10-31 E02) — 같은 팝업을 다른 계정으로 연 결과(popup_rowsets.json) 비교 |
| `facts_popup_golden.py` | 체인 eg(eg_chain 안) | 팝업 목록 원천 대조 (2026-10-31 E02) — popup_rowsets.json(E2E 실측) ↔ AS-IS 팝업 SP · 문서 확정 원천 SQL |
| `facts_popup_meta.py` | 체인 facts / 체인 eg(eg_chain 안) | TO-BE 메타 조회(읽기 전용) — 팝업 검사 기대값 원천 (2026-10-31 E02) |
| `facts_prereq.py` | 체인 facts | 선행 칸(먼저 채워야 하는 칸) AS-IS 사실 — 2026-11-09 T176(SSP0025 신규행 Division 오탐 10건) |
| `facts_sortrules.py` | 체인 facts | AS-IS 결과 정렬 사실 추출 — SQL(SP ORDER BY) 인지 그리드/코드 정렬인지 (2026-10-26 사용자 지시: "AS-IS 에서 정렬을 어떻게 수행하는지 확인해서 동일하게 SORT 적용") |
| `fe_gate.py` | VM S8.feGate | fe_gate.py — EN-04 FE 화면 열기·조회 smoke 게이트 (2026-11-11 · 플랜 '추측 대신 실행' M1) |
| `feature_inventory.py` | 손 실행(진입점 연결 없음) | feature_inventory.py — AS-IS 기능 목록(화면 단위 · 기능 단위) (2026-11-11 · 사용자 목적 "TO-BE 룰을 지키면서 AS-IS 기능을 완벽하게 구현") |
| `g2_asis.py` | 다른 도구가 사용: _verify.spec.ts | G2 선택 조회 '조건 밖 값' 확인 — 화면이 보낸 같은 인자로 AS-IS 조회 SP 를 실행해 AS-IS 결과에도 같은 값이 나오는지 (2026-11-10 T217) |
| `gap267_setprice_run.py` | 손 실행(진입점 연결 없음) | GAP-267 Set Price(DMF0042 · Div 40) 1회 실측 + 자동 복원 — 사용자 직접 실행용 (2026-11-04) |
| `gen_cleanup_spec.py` | 체인 e2e | 메뉴별 실저장 정리 정의 자동 생성(2026-10-31) — 저장 PROC(PROC_M SAVE/INS/UPD/DEL) 본문을 사내오라클 ALL_SOURCE 에서 새로 읽어 하위 호출까지(깊이 3) DML 대상 테이블을 찾는다. |
| `gen_expect.py` | 체인 facts | gen_expect.py <ID>... / --all [--report] — 화면 사실 → 자동 기대 행 (W8-2, 2026-11-04 사용자 지시) |
| `gen_expect_recall.py` | 다른 도구가 사용: doc_patterns.py, expect_rows.py, gen_expect.py | gen_expect_recall.py [--write] — 자동 생성기 재현율(W8-2 합격 기준, 2026-11-04) |
| `gen_param_map.py` | 체인 diff | AS-IS SP ↔ TO-BE PROC 짝(sp_pair.csv)·인자 번역표(param_map.csv) 생성 — 차등 검증(diff_verify.py)의 데이터 원천(2026-11-06 플랜 2-2) |
| `gen_param_map_manual.py` | 손 실행(진입점 연결 없음) | 수동 지정 짝(sp_pair.csv source=manual)의 인자 번역표(param_map.csv) 행 생성 (2026-11-16 · SSP0020·SCP0104 차등 검증 'AS-IS 인자 {}' 실행 오류) |
| `guess_scan.py` | 손 실행(진입점 연결 없음) | 추측 지점 원장(2026-11-11 · 플랜 §1) — 도구·체인이 '실행해서 재지 않고' 추정·근사·이름 규칙·LLM 서술로 결론을 내는 지점을 전수 목록으로 관리한다. |
| `i18n_lang_check.py` | 체인 post | 언어 전환 문구 판정(2026-11-02 엔진 갭 EG361) |
| `i18n_static.py` | 체인 post | 다국어 정적 점검(2026-11-01 엔진 갭 EG451·EG356·EG364) |
| `impl_engine.py` | 체인 post | 구현 엔진 v2 — 작업 원장(work ledger) 단일화 (2026-10-26) |
| `judge.py` | 체인 post | 검증 항목 원장 판정 — Doc/verify/<ID>/verify_ledger.csv 의 result·evidence·tobe_ref 를 채운다. |
| `judge_e4f1_selftest.py` | 손 실행(진입점 연결 없음) | judge.py 의 저장 성공 메시지(E4) ← F1(CRUD 실저장) 승계 규칙(T292) 변이 입증 |
| `judge_popup_selftest.py` | 손 실행(진입점 연결 없음) | judge.py 의 팝업 문장 → 팝업 클래스 해석(T269) 변이 입증 |
| `keyset_guard.py` | 손 실행(진입점 연결 없음) | 키 범위 스냅샷·복원 — 자동 복원기(restore_touched)가 못 되살리는 '지우고 다시 넣기·삭제' 저장 시험용 (2026-11-04 · GAP-175) |
| `ledger.py` | 체인 facts | 화면 검증 항목 원장 생성 — Doc/verify/<ID>/verify_ledger.csv |
| `ledger_guard.py` | 다른 도구가 사용: _verify.spec.ts, cleanup_marker.py | 정합검증 CRUD 실제 저장 안전장치 — 저장 직전 빈 키 확인 · 공유 마스터 스냅샷 기록(2026-10-24) |
| `llm_call.py` | 다른 도구가 사용: llm_desc.py, llm_facts.py, llm_review.py 외 2 | AI 검토 공용 호출기 — 검증 체인(Python)에서 Claude Code 를 읽기 전용으로 불러 JSON 답을 받는다 (2026-11-19 사용자 지시) |
| `llm_desc.py` | 다른 도구가 사용: make_verify_docs.py, run_verify.py | CheckList 설명 문장 작성 — '조치 필요'·'판정 필요' 시트의 설명 칸 정리 문장을 Claude 가 쓴다 (2026-11-19 사용자 지시 · 적용 단계 '설명 문장 작성') |
| `llm_facts.py` | 다른 도구가 사용: judge.py, run_verify.py | AS-IS 사실 추출 검토 — 검사엔진이 기대값으로 쓰는 AS-IS 사실 추출본을 Claude 가 화면 원문과 대조해 누락·오추출을 찾는다 (2026-11-19 사용자 지시 · 적용 단계 'AS-IS 사실 추출 검토') |
| `llm_review.py` | 다른 도구가 사용: judge.py, llm_desc.py, llm_facts.py 외 4 | AI 판정 검토 — 검사엔진이 FAIL·판정필요·미검증으로 남긴 행을 Claude 가 원문과 대조해 가린다 (2026-11-19 사용자 지시) |
| `lookup_check.py` | 체인 post | Lookup 기반 셀 편집 후보 판정(2026-11-01 엔진 갭 EG066) |
| `make_test_report.py` | VM S8.report | 테스트결과서 — UI CheckList(run_verify) 결과를 사용자가 읽는 '테스트 내역 · 결과' Excel 로 (2026-10-30 사용자 요청) |
| `make_ui_test_sheet.py` | VM S8.uitest | UI 테스트 Sheet — CheckList '조치 필요' 시트를 Doc/UI_TEST(SCP&SSP) 의 화면별 테스트 Excel 로 옮긴다 |
| `make_verify_docs.py` | 다른 도구가 사용: decisions.py, doc_archive.py, llm_desc.py 외 6 | 화면 정합검증서 + 보완대상목록 xlsx 생성 |
| `mapping_trace.py` | 체인 static·post | 대조표 ↔ 검증 추적표 v2 — 대조표의 모든 행을 '검증 대상'으로 보고, 행마다 해야 할 검사를 카탈로그로 정해 결과를 단다 (2026-10-26) |
| `master_sweep.py` | 체인 post | 기준정보 존재·활성 스윕(2026-11-02 엔진 갭 EG455) |
| `measure_by_site_check.py` | 체인 post | Sales Site 유형별 입력 Measure 허용 목록(B5 · EG068 · DM-37/DM-135/DM-139/DM-153) — Doc/verify/<ID>/measure_by_site.csv (2026-11-03) |
| `measure_sweep.py` | 체인 post | Measure 기준 코드 정합 점검(2026-11-02 엔진 갭 EG453) |
| `menu_auth_sync.py` | 체인 post | menu_auth_sync — 그룹별 메뉴·버튼 권한 AS-IS ↔ TO-BE 대조(읽기 전용 · 2026-11-18 SCP0111 V-d9598564 J4 GAPSELF-22 '측정 코드 없음') |
| `meta_live_check.py` | VM S8.metaLive | 메타·배선 실시간 검증(EN-03 · EN-22 의 확인 단계 · 2026-11-11) — 생성·보완 뒤 화면이 실제로 동작할 DB 상태인지를 사내 DB 를 '지금' 조회해 확인한다. |
| `new_screen_precheck.py` | VM S8.precheck | new_screen_precheck.py — EN-25 신규 화면 사전 점검 (2026-11-11 · 플랜 '추측 대신 실행') |
| `opinion_intake.py` | 다른 도구가 사용: run_verify.py | 사용자의견 자동 처리 — CheckList '사용자의견' 열에 적은 의견을 Claude 가 읽고 처리 구분·근거·답을 만든다 (2026-11-19 사용자 지시 · 적용 단계 '사용자의견 자동 처리') |
| `oracle_class.py` | 체인 post | 규칙 → 오라클 분류 마스터(2026-11-06 사용자 원칙: AS-IS 직접 비교가 1순위 정답 · 룰은 AS-IS 로 비교할 수 없는 항목만) |
| `orch_event.py` | 다른 도구가 사용: db_orphan_sessions.py, orch-events.js, run_verify.py | 오케스트라 사건 기록(Python 쪽) — .vibe/orch/events.jsonl 에 한 줄 1건(JSON) 덧붙임 (2026-11-19 오케스트라 P1) |
| `pattern_coverage.py` | 다른 도구가 사용: gen_expect.py | pattern_coverage.py <ID> [<ID> ...] — 화면별 결함 패턴 적용표(W8-3, 2026-11-05) |
| `pending_recheck.py` | 다른 도구가 사용: recheck.js, screen_status.py, unverified_resolve.py | 미검증 해소 보완 뒤 CheckList 재수행 전인지 판단(2026-11-19 사용자 지시) |
| `pkg_asis_map.py` | 다른 도구가 사용: gen_param_map.py | pkg_asis_map.py — TO-BE PKG 원문에 적힌 AS-IS SP 이름으로 짝을 읽는다 (2026-11-11 · EN-02 ② 짝 = 기록된 사실) |
| `pkg_gate.py` | VM S8.pkgGate | pkg_gate.py — EN-05 PKG 컴파일·실행 대조 게이트 (2026-11-11 · 플랜 '추측 대신 실행' M1) |
| `plain_detail.py` | 손 실행(진입점 연결 없음) | plain_detail — CheckList '설명' 열을 처음 보는 사람도 읽을 수 있게 다시 쓴다 (사용자 2026-11-13). |
| `popup_args_check.py` | 체인 static | G5 팝업 조건 연동 정적 검사 — AS-IS 팝업 호출 인자 ↔ TO-BE 모달 전달값 + 화면 조회조건 연동 (2026-10-29) |
| `popup_data_check.py` | 체인 static | M3 팝업 데이터 조회 정적+DB 검사 — AS-IS 개인화(TitleSet) 팝업 목록 ↔ TO-BE 메타 조회를 '화면이 보낼 수 있는 Division 값'마다 실행 (2026-10-30) |
| `precision.py` | 체인 docs | 조치필요 정밀도(2026-11-06 플랜 G1) — 판(version)마다 '조치 필요' 시트 행 수 ÷ 사용자 확인 실결함 수를 기록한다. |
| `prereq.py` | 체인 pre / VM S3.prep | 정합검증 사전 작업 점검·선수행 — run_verify.py 1단계 앞에서 실행 (2026-10-28) |
| `proof_backlog.py` | 다른 도구가 사용: asis_live_proof_targets.py, backlog_types.py | proof_backlog.py — "AS-IS 기능 100% 구현 증명"까지 남은 일의 전수 목록 (2026-11-11 사용자 지시: "누락하지 말고 … 순차적으로 하나씩 · 해야 할 일을 누락하고 완료되었다고 보고하지 말 것") |
| `regress.py` | 체인 docs | 검사기 회귀 게이트(2026-10-29 사용자: "검사기 오류로 인한 조치 필요 항목 — 재발하지 않도록") — 사용자 판정을 회귀 오라클로 쓴다. |
| `repair_apply.py` | 손 실행(진입점 연결 없음) | 레시피 자동 적용기(보완실행 단계 · 2026-11-08 사용자 결정 '남은 것 진행' ③) — fixlist.csv × fix_recipes.csv 중 auto_apply=Y 이고 sql_template 이 있는 DB 레시피만 |
| `repair_close.py` | VM S8.repairSnapshot·S8.repairClose·S8.repairCompare | 보완 증명 루프(EN-01 · 2026-11-11) — 보완한 항목이 실제로 고쳐졌는지를 '고친 규칙만 다시 측정'해서 증명하고, 다른 항목이 나빠지지 않았는지 확인한다. |
| `repair_plan.py` | 손 실행(진입점 연결 없음) | 보완 계획 — fixlist.csv(조치 필요·판정 필요 행) × fix_recipes.csv(규칙별 보정 레시피) → Doc/verify/<ID>/repair_plan.md (2026-11-08 · 사용자 결정 '순차 진행' (c)) |
| `repair_scope.py` | 다른 도구가 사용: repair_close.py | 보완 영향 범위 산출(EN-23 · 2026-11-11) — 직전 정합검증 뒤에 '실제로 바뀐 것'을 측정하고, 그 변경이 걸리는 원장 행·검사 규칙을 사실로 계산한다. |
| `restore_touched.py` | 체인 post | 시험이 원복하지 못한 기존 행 자동 복원(2026-11-02 T39 — DMF0005 저장 SP 가 다른 칸까지 변경) |
| `run_docs_batch.py` | 손 실행(진입점 연결 없음) | 3개 문서가 지목한 메뉴 전체에 정합검증 실행(2026-10-31) — 문서 행 많은 메뉴부터 · 동시 상한 3(BE 풀 · 메모리 기록) |
| `run_verify.py` | 체인 진입점 / VM S8.verify·S8.verifyStatic | 화면 정합검증 한 번에 실행 — Vibe_Manager '🔎 화면 정합검증' 이 부르는 진입점 |
| `safe_io.py` | 다른 도구가 사용: diff_ingest.py, e2e_suite_ingest.py, eg_ingest.py | 공용 결과 파일 안전 읽기·쓰기(2026-11-13 엔진 점검 · T284) |
| `save_audit.py` | 체인 post | F8 감사 필드 · F7 저장 연계 테이블 정적 판정 — CRUD 실제 저장(E2E) 이 남긴 행의 정리 백업으로 판정 (2026-10-27) |
| `save_diff.py` | 손 실행(진입점 연결 없음) | save_diff.py — EN-02 ③ 저장 SP 실행 대조 (2026-11-11 · 플랜 '추측 대신 실행' M1 · 사용자 승인 2026-11-11 "AS-IS DEV 저장 SP 트랜잭션+ROLLBACK 대조 허용") |
| `save_diff_targets.py` | 다른 도구가 사용: save_diff.py, sqllog_calls.py | save_diff_targets.py — EN-02 ③ 저장 SP 실행 대조의 대상·제외 목록 (2026-11-11 · 플랜 '추측 대신 실행' M1) |
| `save_residue.py` | 다른 도구가 사용: cleanup_marker.py, gen_cleanup_spec.py, run_docs_batch.py | 실저장 잔존 변경 실측(2026-10-31) — 저장 대상 테이블에서 E2E 계정이 --since 이후 만들거나 고친 행 수를 DB 에서 센다. 정리가 끝났다는 주장의 증거. |
| `scenario_env.py` | 체인 facts | scenario_env.py <ID> [...] — 화면별 데이터 전제 프로필(W8-5, 2026-11-05) → Doc/verify/<ID>/scenario_env.json |
| `server_guard.py` | 다른 도구가 사용: nscm.ts, run-e2e.cmd, run_verify.py 외 1 | CheckList 서버 확인·자동 기동 (2026-11-19 사용자 지시) |
| `set_llm_review.py` | VM S8.llmReview | AI 검토 켜고 끄기 — tools/Harness/harness.json 의 llmReview 를 읽고 쓴다(단일 원천 · 2026-11-19 사용자 지시 'VM 환경설정에 AI 검토 켜고 끄는 항목') |
| `set_scope.py` | VM S8.scope | 보완 범위 환경설정 — tools/Harness/harness.json 의 repairScope 를 읽고 쓴다(단일 원천) |
| `sheet_data_cond.py` | 다른 도구가 사용: asis_live_scen_run.py, smoke-extra.ts | 시트별 데이터 조건 탐색(2026-11-17 SCP0104 SOP 탭 0행 미측정 대응). |
| `snap_approve.py` | 체인 post | 스냅샷 승인 = 골든(2026-11-06 플랜 3-4) — 수신본을 골든으로 올리고 사용자 판정 회귀 오라클(_user_verdicts_direct.csv)에 기록한다. |
| `snap_expect.py` | 체인 post | 스냅샷 기대 템플릿(AS-IS 유래 부분 기대) 생성 — Doc/verify/<ID>/snap/expected/<key>.json (2026-11-06 플랜 3-4) |
| `snap_parallel.py` | 손 실행(진입점 연결 없음) | 스냅샷 행 ↔ 구 프로브 행 병행 대조(2026-11-06 플랜 3-5) — 같은 규칙(G4·K4·A5·H6·H4·H5·SC1)의 기존 실측 판정과 스냅샷 판정을 나란히 놓는다. |
| `snap_validate.py` | 체인 post | 수신 스냅샷(snap/received) ↔ AS-IS 유래 기대(snap/expected) 대조 — 골든 승인 전 기계 검증(2026-11-06 플랜 3-4) |
| `sort_check.py` | 체인 static | 결과 정렬(A6) 정적 대조 — AS-IS SP ORDER BY(sort_rules.csv) ↔ TO-BE PKG 프로시저 ORDER BY(사내오라클 ALL_SOURCE 새로 조회) (2026-10-26) |
| `sort_ci_check.py` | 체인 post | 문자 정렬 키의 대소문자 무시·NULL 먼저 점검(2026-11-02 엔진 갭 EG034) |
| `sources_extract.py` | VM S8.sources | 검증 지식 원천 xlsx 3개 → MD + 기계판독 CSV + 이미지 (누락 0 증명 포함) — Doc/verify/sources/ |
| `sp_branch_check.py` | 체인 post | 저장 SP 검증 분기 대조(2026-11-01 엔진 갭 EG161) — AS-IS 저장 SP 의 오류 문구 ↔ TO-BE 저장 PROC·화면 코드 |
| `sp_dml_check.py` | 체인 post | 저장 SP 쓰기 컬럼 대조(2026-11-01 엔진 갭 EG238·EG230·EG223) — AS-IS 저장 SP 가 쓰는 표·컬럼 ↔ TO-BE 저장 PROC |
| `sqllog_calls.py` | 체인 diff | sqllog_calls.py — 사내 호출 로그(SCM_COM_SQL_LOG)에서 화면의 실제 PROC 호출 인자를 읽는다 (2026-11-11 · EN-02 ①③) |
| `static_gate.py` | 체인 docs | 정적 게이트 요약 — `run_verify.py <ID> --static` 의 마지막 단계(2026-11-08 · 사용자 결정 '순차 진행' (a)) |
| `syn_check.py` | 체인 static | 화면이 BE 계정(SCMP_APP)으로 접근하는 DB 객체의 시노님·권한 정적 검사 (읽기 전용 — 고치지 않는다) |
| `syn_fix.py` | 체인 static | 앱 계정(SCMP_APP) 시노님 누락 자동 보완 + 이력 (2026-10-29 사용자 지시: "시노님이 없어서 실행이 안되는 경우에는 시노님 추가하고, 시노님 없어서 오류발생한 이력 남겨주세요") |
| `timing_report.py` | 손 실행(진입점 연결 없음) | CheckList 소요 시간 집계 (2026-11-06 속도 개선 ① 계측) — 측정값만 읽어 요약한다(추정 없음). |
| `titleset_check.py` | 체인 post | 사용자 칸·Measure 설정(SCM_MST_TITLESET_USER) 정합(2026-11-02 엔진 갭 EG025·EG399) |
| `titleset_guard.py` | 다른 도구가 사용: _verify.spec.ts | 컬럼 설정 Save 시험용 개인화 스냅샷·복원 (2026-11-04 · EG021/EG392) |
| `tobe_rule_registry.py` | 다른 도구가 사용: engine_selfcheck.py, unverified_resolve.py | TO-BE 룰 원장(2026-11-11 · 플랜 §3) — 흩어진 TO-BE 룰을 1룰 1행으로 모으고, 각 룰이 어느 단계에서 무엇으로 강제되는지를 코드 실측으로 붙인다. |
| `trace_all.py` | 손 실행(진입점 연결 없음) | 전 화면 대조표 검증 커버리지 집계 (사용자 지시 2026-10-26 — '전체에 대해서 검증을 제대로 하도록') |
| `unverified_resolve.py` | VM S8.unverified | CheckList 미검증 자동 해소 1단계: 분류 + 자동 재측정 (2026-11-18 사용자 지시) |
| `validate_classified.py` | 다른 도구가 사용: defects_sources_merge.py | 분류 CSV(Doc/verify/sources/_classified/*.csv 또는 defects_classified.csv) 형식·일관성 검사 — 보고만(자동 수정 없음) |
| `verify_if_stale.py` | VM S8.verifyIfStale | 정합검증 최신 여부 확인 → 최신이 아니면 정합검증 실행 (2026-10-28) |
| `weaken_check.py` | 다른 도구가 사용: workbench.js | 테스트 약화 검사 — E2E 기대값 보정(🩹 시험 기준 보정) 전후로 시험 도구·스펙이 약해졌는지 기계로 본다 (2026-10-26) |
| `xlsx_probe.py` | 다른 도구가 사용: _verify.spec.ts | Excel 시험 도우미(2026-11-01 EG420·EG421) |

<!-- TOOL-REGISTRY:END -->
