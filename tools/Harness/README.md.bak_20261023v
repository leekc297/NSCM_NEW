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
