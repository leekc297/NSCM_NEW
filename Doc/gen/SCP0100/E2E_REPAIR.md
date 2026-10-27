# E2E 수선 기록 — SCP0100 Global_PSI_Report

> 체인이 실패한 E2E 단계를 수선하면서 남기는 기록이다. 섹션은 append 만 한다(기존 내용 유지).
> 판정: (a) 화면 결함 / (b) DB 객체·메타 결함 / (c) E2E 기대값 결함 의심. (c) 는 수정하지 않고 근거만 남긴다.

## 수선 1 — smoke — 2026-10-21 15:38

- 호출 프롬프트의 `${kind}`·`${step}`·`${round}` 가 치환되지 않은 채 전달됨 → `_summary.csv` 에서 SCP0100 FAIL 행이 smoke 1건뿐이라 kind=smoke 로 판정, round=1(이 파일 신규).
- 입력: `Doc/e2e/results/_summary.csv:13` (SCP0100 smoke FAIL, 2026-10-21 13:31) · `Doc/e2e/logs/run_20261021_132508_all.log`(smoke 단독 로그 run_20261021_092613_smoke.log 보다 최신) · 실패 스크린샷 `artifacts/SCP0100.smoke-…-chromium-retry1/test-failed-1.png` · `Doc/e2e/specs/SCP0100.smoke.spec.ts` · `SCP0100.plan.json`
- 결과 요약: **실패 4건 모두 (c)**. (a)·(b) 0건이라 FE·PKG·메타·대조표는 고치지 않았다. FE 를 고치지 않았으므로 `check.js --final` 은 실행하지 않았다(필요 조건 아님).

| # | 실패 항목 | 판정 | 근거 | 처리 |
|---|---|---|---|---|
| 1 | 조회조건 'Display' (CustomDropdown) 후보 [Display] | (c) | As-is `SCP0100_Global_PSI_Report.designer.cs:1180` `layDisplay.Visibility = LayoutVisibility.Never` 라서 As-is 화면에도 보이지 않는다. `.cs` 에는 layDisplay 가시성을 바꾸는 코드가 없다(cboDisplay 값만 `.cs:540` idx2=GRID, `.cs:1827` 분기에서 쓰임). To-Be 는 Form 에 렌더하지 않고 store 기본값 GRID 만 유지한다(`GlobalPsiReportForm.tsx:57` 주석, `__asis-mapping__.md:150` D00-1-011, `:228` D00-7-011). 스펙은 대조표 상태가 '제외' 인 컨트롤만 건너뛰는데, 이 행은 '숨김 값 보존 = 구현' 으로 닫혀 있어서 검사 대상이 됐다(Graph 는 '제외' 라 건너뜀). | 미수정. Display 를 렌더하면 As-is 파리티가 깨진다. 생성기가 designer `Visibility=Never` 컨트롤을 라벨 검사에서 빼야 한다. |
| 2 | 조회조건 'Project' (ProjectField) 후보 [Project] | (c) | 조회조건 카탈로그 `Doc/_rules_v2/_mapping/search_conditions_scp_dm.md:706` Global PSI New: As-is **Project** → To-Be **PJT**(변경 O: 명칭/유형/팝업). 룰 E4(10_RULES_KEEP)는 카탈로그 To-Be 명칭을 따르도록 정한다. FE 는 `t(LBL.PROJECT,'PJT')`(`GlobalPsiReportForm.tsx:480`, `global-psi-report.constants.ts:190` LBL00012), msg_master LBL00012 KO/EN/CN = 'PJT'(`Doc/tobefacts/db/msg_master.csv:32-34`)이고 스크린샷에도 'PJT' 가 보인다. plan.json 은 lbl=LBL00617('Project')만 후보로 갖고 있어 카탈로그 To-Be 명칭 'PJT' 가 후보에 없다. | 미수정. 후보 목록에 카탈로그 To-Be 명칭(PJT)을 추가해야 한다(생성기 몫). |
| 3 | 조회조건 'Unit (Qty)' (CustomDropdown) 후보 [Unit (Qty)] | (c) | 카탈로그 같은 표 `:713`: As-is **Unit (Qty)** → To-Be **Unit**(변경 O: 명칭). FE 는 `t(LBL.UNIT,'Unit')`(`GlobalPsiReportForm.tsx:459`, constants `:193` LBL00045), msg_master LBL00045 = 'Unit'(`msg_master.csv:131-133`)이고 스크린샷에도 'Unit' 이 보인다. plan.json 후보는 LBL01129('Unit (Qty)', `msg_master.csv:1510-1512`)뿐이다. | 미수정. 후보에 카탈로그 To-Be 명칭(Unit)을 추가해야 한다. |
| 4 | 그리드 컬럼 누락(메타 기준) — 시트 SEARCH_LEVEL 기대 8 / 누락 3: Product Level1·2·3 (허용 ≤ ceil(8×0.2)=2) | (c) | As-is `SetLayout`(`SCP0100_Global_PSI_Report.cs:1490-1542`) `switch (cboSearchLevel.SelectedIndex)` 의 `default`(idx0 = Cell Group) 분기는 PRODUCT_LEVEL1/2/3 을 모두 `VisibleColumns(false)` 로 숨긴다. 진입 기본값은 idx0 이다(`.cs:621`, To-Be `useGlobalPsiReportStore.ts:99` searchLevel=CELL_GROUP). To-Be `applySearchLevelLayout`(`utils/globalPsiReportColumns.ts`, `PRODUCT_LEVEL_VISIBLE` 에 CELL_GROUP 없음 → 3개 모두 visible=false)이 같게 재현하며 대조표 `:218` D00-7-001 이 이를 기록한다. 메타 `sheet_columns.csv`(SEARCH_LEVEL PRODUCT_LEVEL1~3 visible_flag=Y)는 정적 기본값일 뿐이고, 스모크는 기본 Search Level(Cell Group)로 조회하기 때문에 As-is 동작상 이 3개는 보이면 안 된다. 나머지 기대 5개(Div 등)는 헤더 17개 안에 있어 일치한다. | 미수정. 기대 컬럼에서 Search Level 런타임 레이아웃(SetLayout)으로 숨겨지는 컬럼을 빼야 한다. 또는 smoke 가 PRODUCT_LEVEL3(idx4)로 조회해 3개 모두 표시를 확인하는 방식이 맞다. |

### 함께 본 것 (실패 항목 외 · 처리 안 함)
- 실패 스크린샷에서 SearchArea 첫 열 라벨(Div.·Period·Cell Group)이 화면 왼쪽 밖으로 잘려 보인다(MainTitle 도 잘림). DOM 라벨 검사는 통과(일치 13)했다. 이번 수선 범위(실패 4건) 밖이라 고치지 않았다. 화면 폭·스크롤 위치 때문인지 레이아웃 결함인지는 사람이 확인해야 한다.
- Cell Qty 체크박스는 DOM 검사는 통과했지만 스크린샷 범위(펼친 영역 4행) 안에서는 보이지 않는다. 5행째로 줄바꿈된 것으로 보이며 같은 이유로 확인이 필요하다.

### 검증
- FE·DB 수정 0건 → `check.js --final` 미실행(대상 없음). 직전 게이트 결과 `Doc/gen/SCP0100/CHECK.md` BLOCK 0 / WARN 0(11:24)은 그대로 유효하다.
- E2E 는 직접 돌리지 않았다(체인이 다시 실행). **기대값이 바뀌지 않으면 smoke 는 같은 4건으로 다시 실패한다** — 4건 모두 생성기(gen-e2e.js)·plan 쪽 보정이 필요하며, 수정 금지 범위라 사람이 결정해야 한다.

### 후속 (2026-10-21 자율 보완 중 확인)
- `node tools/E2E/gen-e2e.js --all` 로 재생성한 `SCP0100.plan.json` 기준 #1 Display = `excluded:true`, #2 Project 후보 = [PJT, Project], #3 Unit (Qty) 후보 = [Unit, Unit (Qty)] — 생성기 쪽에서 해소됨(이 작업이 고친 것 아님). #4 Product Level1~3(기본 Search Level 숨김)은 기대값 계산이 그대로라 smoke 재실행 시 남을 수 있음.

## 수선 1 — smoke — 2026-10-21 19:20

- 입력: `Doc/e2e/results/_summary.csv:13`(SCP0100 smoke FAIL 1건) · `Doc/e2e/logs/run_20261021_183937_smoke.log` · 스펙 `SCP0100.smoke.spec.ts:54-61`(headerSpec rows 3 · literals [Qty] · maxRowPx 32) · 대조표 D00-6-005 의 2026-10-21 18:5x 사용자 실측 지침
- 실패: `헤더 행 수 (As-is SetSheetHeaderColumn 3)` 기대 ≥3 / 실측 2 — 어노테이션 `To-Be 행 2(높이 72+24=96px)`

| # | 항목 | 판정 | 근거 | 처리 |
|---|---|---|---|---|
| 1 | 헤더가 1·2행 병합, Qty 가 전 월에 걸쳐 1칸 | (a) | 공용 `CustomMergeManager._getColumnHeaderMergedRange`(`packages/foundation/src/utils/mergeManager.ts:158-202`)는 헤더를 같은 문구 기준으로 가로·세로 병합한다. MONTHLY 3SPAN 은 M_ 행의 LARGE·SMALL 라벨이 같은 월('2026-09')이라 1·2행이 합쳐졌고, 인접 'Qty' 도 1칸으로 합쳐졌다(사용자 실측 w910). As-is ColumnHeaderSpan(`.cs:787·788·794`)은 명시 범위라 문구가 같아도 합쳐지지 않는다. | 신규 `utils/globalPsiReportMerge.ts` GlobalPsiReportMergeManager: 기간칼럼(M_/W_/B_) 헤더만 Wijmo 기본(컬럼그룹 `_rng`) 범위로 병합하고, 고정 컬럼·본문은 공용 CustomMergeManager 에 위임한다. `GlobalPsiReportGrid.tsx:243·254` mergeManager prop 으로 직접 전달(룰 D4). 공용 코드 변경 0. check.js H05 해소 |
| 2 | 헤더 행 높이(그룹 20 / Qty 40·30) | (a) | D00-6-005 지침 ②③ · As-is `.cs:787`(그룹 20)·`.cs:788`('Qty' 1~2행 병합)·`.cs:794`(Qty 30) | `utils/globalPsiReportColumns.ts:114-137` PIVOT_HEADER_HEIGHT·headerRowHeights 신설. `GlobalPsiReportGrid.tsx:206-240` updatedLayout 에서 행 인덱스별로 재적용(전: 전 행 24 → 후: 월간 [20,40] · 주간 [20,20,30]). HEADER_ROW_HEIGHT 24→20 |
| 3 | 월간 헤더 깊이 | (a) | D00-6-005 지침 ②: "월간은 헤더 2행(월/Qty) — 숨긴 주간 그룹 깊이 제거". M_ 행에도 SMALL_CLASS_LABEL_NAME(=월 문자열)이 와서 중간 그룹이 생겼다 | `buildPivotColumns`(Cols:144-203): MONTHLY = 월 > Qty 2단, WEEKLY 만 월 > 주 > Qty 3단. 그룹에 allowMerging·allowSorting=false·height 명시(룰 D3) |
| 4 | smoke 기대 "헤더 행 ≥3" (MONTHLY 조회) | **(c) 기대값 결함 의심** | plan.json `headerSpec.rows=3` 은 `SetSheetHeaderColumn(_SI,3)`(`.cs:705`) 행 **수**만 본다. As-is 월간 M_ 열은 `ColumnHeaderSpan(1, …, 2, 1, 20, "Qty")`(`.cs:788`)로 'Qty' 가 1~2행 병합이라 보이는 단은 2단이다. 사용자 지침(D00-6-005 18:5x)도 "월간 2행". 위 #3 을 반영하면 기본 Bucket(Monthly) smoke 는 DOM 행 2로 계속 `≥3` 을 통과하지 못한다(주간 조회면 3행). 높이 기준(≤32×3)과 'Qty' 리터럴 검사는 통과 예상(월간 60px) | 미수정. 생성기 headerSpec 이 Bucket 별 기대 행 수(월간 2 / 주간 3)와 leaf 행 높이(≥ 상단 행)를 따져야 한다 — 사람이 결정 |

### 검증
- `node tools/Harness/check.js --page nscm-fe/features/supply/src/pages/global-psi-report --id SCP0100 --final` → **BLOCK 0 / WARN 0**(수선 전 WARN H05·M06)
- 단위테스트: TC-SCP0100-006(월간 2단) 수정 · TC-SCP0100-017(행 높이·그룹 D3 플래그) 추가 — **vitest 미실행**(요청 시만). tsc 미실행
- E2E 는 직접 돌리지 않았다(체인이 다시 실행). 라이브 헤더 행 수·높이·Qty 분리는 **런타임 미검증**
- DB 객체·메타 변경 없음

## 자율 보완 — 2026-10-21 21:40 (H06 회귀 정정 + 런타임 확인)
- 원인: 직전 수선의 `utils/globalPsiReportMerge.ts` 인스턴스 필드 `private inner` → Wijmo copy() "Unknown property 'inner'" 단언으로 화면 생성 실패(19:22 smoke 오류 화면, 라벨 15건 전부 누락).
- 처리: 위임 대상을 모듈 `WeakMap<FlexGrid, CustomMergeManager>`(:17-25)로 옮기고 클래스에는 메서드만 둠(:27-40). check.js H06 이 여러 줄 메서드 시그니처를 필드로 오인(도구 오탐)해 시그니처를 한 줄로 정리.
- 게이트: check.js --final BLOCK 1(H06) → **BLOCK 0 / WARN 0**.
- 런타임(로컬 FE 5173·BE 8080, `run_20261021_212730_smoke.log`): 화면 정상 열림 · 조회조건 라벨 15/15 · 컬럼 누락 0 · 동적 기간칼럼 13 + calendar 호출 1 · 치명 콘솔 오류 0(비치명 ThemeProvider children prop 경고 58~60 = 공용·전역, 이 페이지 밖).
- 남은 smoke 실패 2건 = **(c) 기대값/측정 결함 의심**: 헤더는 월 행 20 / Qty 행 40, 총 60px(스크린샷 헤더 y≈376~436). helper `gridHeaderRows`(tools/E2E/lib/nscm.ts:258-266)가 행별 높이를 그 top 의 **첫 셀** 높이로 기록하는데, 첫 셀이 2행을 세로 병합한 고정 컬럼(60px)이라 '상단 60 vs 리터럴 40', 합계 '60+40=100px' 로 잘못 잰다. 생성기·헬퍼는 수정 금지 범위라 미수정.

## 수선 1 — smoke — 2026-10-21 21:45

- 입력: `Doc/e2e/results/_summary.csv:13`(SCP0100 smoke FAIL 2건) · `Doc/e2e/logs/run_20261021_213859_smoke.log:41·57` · 스펙 `SCP0100.smoke.spec.ts`(headerSpec rows 3 · maxRowPx 32) · results.json header 어노테이션 `To-Be 행 2(높이 60+40=100px)` / `리터럴 행 칸 12 / 상단 동적 칸 12 · 높이 상단 60 vs 리터럴 행 40` · 헬퍼 `tools/E2E/lib/nscm.ts:262-271`
- 통과 항목: 화면 열림 · 조회조건 15/15 · 컬럼 누락 0 · 동적 기간칼럼 · Qty 월마다 분리(12/12) · 치명 콘솔 0

| # | 실패 항목 | 판정 | 근거 | 처리 |
|---|---|---|---|---|
| 1 | 헤더 총 높이 ≤ 96px (실측 100) | **(c) 측정 결함 의심** | 헬퍼 `gridHeaderRows`(nscm.ts:267)는 헤더 셀을 top 좌표별로 묶고 그 묶음의 **첫 셀 높이**를 행 높이 `h` 로 기록한다. 같은 top(0행)의 첫 셀은 2행을 세로로 덮는 고정 컬럼(Cell Group 등, 20+40=60px)이라 0행이 60, 1행(Qty)이 40으로 잡힌다. `.wj-colheaders` 경계 높이가 0이면 합계 fallback(nscm.ts:269)이 60+40=100 으로 **고정 컬럼 높이를 이중 합산**한다. 실제 헤더 = 월 행 20 + Qty 행 40 = 60px(`utils/globalPsiReportColumns.ts:114-137` headerRowHeights [20,40], 21:27 스크린샷 헤더 y≈376~436) | 미수정 |
| 2 | leaf(Qty) 행 높이(40) ≥ 상단 그룹 행(60) | **(c) 측정 결함 의심** | 위와 같은 원인 — '상단 60' 은 월 그룹 행(20px)이 아니라 2행을 병합한 고정 컬럼 셀 높이다. 실제 기간칼럼 기준은 월 20 < Qty 40 으로 사용자 지침(대조표 D00-6-005 18:5x: 그룹 20 / leaf 40)과 일치 | 미수정 |

- 결론: (a)·(b) 0건 → FE·PKG·메타·대조표 수정 없음(check.js 실행 불필요 — 직전 21:40 `--final` BLOCK 0 / WARN 0 유효). 헬퍼가 행 높이를 그 행의 **기간칼럼 셀**(또는 행 단위 최소 높이)로 재고 총 높이를 `.wj-colheaders` 실측(또는 행별 고유 높이 합)으로 잡아야 통과한다 — tools/E2E 수정 금지 범위라 사람이 결정.
- 화면을 테스트에 맞추려고 고정 컬럼 헤더 병합을 깨는 것은 As-is(고정 컬럼 헤더 세로 병합)와 어긋나고 테스트 약화 우회라 하지 않았다.

## 수선 2 — smoke — 2026-10-21 21:52

- 입력: `Doc/e2e/results/_summary.csv:13`(FAIL 2) · `Doc/e2e/logs/run_20261021_214645_smoke.log:41·57` · results.json header 어노테이션 `To-Be 행 2(높이 60+40=100px)` / `높이 상단 60 vs 리터럴 행 40` · 헬퍼 `tools/E2E/lib/nscm.ts:262-271`(수선 1 이후 변경 없음)
- 수선 1(21:45) 과 **같은 2건·같은 수치** — 화면·헬퍼 모두 그 사이 변경 없음. 통과 항목도 동일(화면 열림·조회조건 15/15·컬럼 누락 0·동적 기간칼럼·Qty 월마다 분리 12/12·치명 콘솔 0).

| # | 실패 항목 | 판정 | 근거 | 처리 |
|---|---|---|---|---|
| 1 | 헤더 총 높이 ≤ 96px (측정 100) | **(c) 측정 결함 의심** | 측정값 자체가 실제 높이 60px 을 증명한다: 0행 top 에서 첫 셀(고정 컬럼 Cell Group)은 헤더 전 행을 세로로 덮는 셀인데 그 높이가 60 → 헤더 전체 = 60px. '100' 은 `.wj-colheaders` 경계 높이 대신 행별 첫 셀 높이 합(nscm.ts:269 fallback) 60(고정 컬럼 전체)+40(Qty 행) 로 고정 컬럼을 이중 합산한 값. 코드 기준도 `utils/globalPsiReportColumns.ts:114-137` headerRowHeights(2)=[20,40] 합 60 | 미수정 |
| 2 | leaf(Qty) 행 높이(40) ≥ 상단 그룹 행(60) | **(c) 측정 결함 의심** | '상단 60' = 0행 top 의 첫 셀(고정 컬럼, 2행 병합) 높이(nscm.ts:267 `h` 는 그 top 의 첫 셀 높이). 기간칼럼 기준 0행(월)은 20px < Qty 40px — 사용자 지침(대조표 D00-6-005: 그룹 20 / leaf 40)·As-is(.cs:788 Qty 1~2행 병합)와 일치 | 미수정 |

- (a)·(b) 0건 → FE·PKG·메타·대조표 수정 없음. check.js 미실행(FE 무변경 — 21:40 `--final` BLOCK 0 / WARN 0 유효).
- **체인이 다시 돌려도 이 2건은 계속 실패한다.** 해소하려면 헬퍼가 ① 행 높이를 그 행의 기간칼럼 셀(또는 그 top 에서 **가장 낮은** 셀) 높이로, ② 총 높이를 `.wj-colheaders` 실측(0이면 0행 top 최대 셀 높이 = 고정 컬럼 높이)으로 재야 한다 — tools/E2E 수정 금지 범위라 사람이 결정. 화면에서 고정 컬럼 헤더 세로 병합을 깨 우회하는 것은 As-is 와 어긋나는 테스트 약화라 하지 않음.
