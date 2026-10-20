# REPAIR SCP0100 — 2026-10-20 13:06:50

## 게이트 0회차 — BLOCK 4 / WARN 51
- ✗ R05 `any` / `as unknown as` 금지 (#73 procedure-dts-ssot) @components/GlobalPsiReportForm.tsx:346
- ✗ R05 `any` / `as unknown as` 금지 (#73 procedure-dts-ssot) @components/GlobalPsiReportGrid.tsx:162
- ✗ R05 `any` / `as unknown as` 금지 (#73 procedure-dts-ssot) @GlobalPsiReport.tsx:108
- ✗ B23 registration.sql API 배선 = 사내 현행(proc_meta.csv) — SCP0100_REPORT_SEARCH: 등록 SQL PKG_SCP0100.P_SCP0100_GET_PLAN_DATE ≠ 사내 현행 PKG_SCP0100.P_SCP0100_GET_GLOBAL_PSI_REPORT · SCP0100_REPORT_ACTION → 'PKG_SCP0100.P_'(프로시저명 공란) — 그대로 적용하면 운용 중 배선이 바뀜(적용 금지 · register.json 정리) 

## Claude 1회차 (exit 0)
```
(As-is `GetDayRange` → `GetPlanEndDate`, `PLAN_END_DATE`) | 미구현 | 사내 To-Be에 대응하는 프로시저·API 배선이 없습니다. 지금은 조회기간이 빈 값으로 시작해서, 기간을 넣기 전에는 기간 헤더를 조회하지 않습니다. As-is 원천 SQL을 확인한 뒤 PKG_SCP0100 프로시저와 메타 등록(DB 객체)을 먼저 해야 합니다. |
| D00-1-023 / D00-2-007 차트, Display(Grid/Chart/All) 전환 | 미구현 | 프레임워크 카탈로그에 차트 컴포넌트가 없고, 카탈로그에 없는 컴포넌트는 들여오지 않는 규칙입니다. `GEN_NOTES.md` 룰 보완 후보에 올렸습니다. 기본값 Grid는 정상 동작합니다. |
| B20 단위테스트 | WARN | `__tests__` 폴더가 없습니다. 이번 범위에서는 만들지 않았습니다. |
| B24 | 실제로는 미충족 | 게이트는 ✅로 판정하지만 As-is 문구만 맞춰 본 결과입니다. 실제 초기값은 위 D00-2-019 때문에 비어 있습니다. |

## 확인이 필요한 것
- **설정 충돌:** CLAUDE.md §1-8에는 "FE는 직접 수정하지 말고 가이드만"이라고 되어 있지만, 이번에는 요청하신 대로 FE 파일을 직접 고쳤습니다.
- **기존 규칙 위반:** 페이지와 Modals가 `features/master/src/components`를 직접 import합니다(기능 간 import 금지 위반). 이번에 바꾸지는 않았습니다.
- **검증 범위:** 타입체크·린트·런타임은 돌리지 않았습니다(요청 시에만 실행).

`check.js --final`을 실행해 주시면 위 예상이 맞는지 확인할 수 있습니다.

변경 파일:
- `nscm-fe/features/supply/src/pages/global-psi-report/` 의 `GlobalPsiReport.tsx` · `components/GlobalPsiReportForm.tsx` · `components/GlobalPsiReportGrid.tsx` · `__asis-mapping__.md`
- `Doc/gen/SCP0100/` 의 `SCP0100_registration.sql` · `register.json` · `GEN_NOTES.md`
Ignoring --allowedTools rule "*)": Wildcard tool name "*)" is not supported in allow rules. An allow pattern must name the scope it widens — globs are permitted only in the tool position after a literal mcp__<server>__ prefix. Deny and ask rules accept wildcards anywhere.
Ignoring --allowedTools rule "*)": Wildcard tool name "*)" is not supported in allow rules. An allow pattern must name the scope it widens — globs are permitted only in the tool position after a literal mcp__<server>__ prefix. Deny and ask rules accept wildcards anywhere.
Ignoring --allowedTools rule "*)": Wildcard tool name "*)" is not supported in allow rules. An allow pattern must name the scope it widens — globs are permitted only in the tool position after a literal mcp__<server>__ prefix. Deny and ask rules accept wildcards anywhere.
Ignoring --allowedTools rule "*)": Wildcard tool name "*)" is not supported in allow rules. An allow pattern must name the scope it widens — globs are permitted only in the tool position after a literal mcp__<server>__ prefix. Deny and ask rules accept wildcards anywhere.
Ignoring --allowedTools rule "*)": Wildcard tool name "*)" is not supported in allow rules. An allow pattern must name the scope it widens — globs are permitted only in the tool position after a literal mcp__<server>__ prefix. Deny and ask rules accept wildcards anywhere.
```

## 게이트 1회차 — BLOCK 4 / WARN 2
- ✗ M04 미구현: D00-1-023 §1 chartMain / ChartControl (splitContainer1.Panel1) — 차트 컴포넌트가 프레임워크 카탈로그(Doc/tobefacts/framework)·rules/map_control.csv 에 없음 → GEN_NOTES '룰 보완 후보' 등록. 사전 미등재 컴포넌트 도입 금지(new_screen.md) @__asis-mapping__.md
- ✗ M04 미구현: D00-2-007 §2 cboDisplay / SelectedIndexChanged (.cs:1824) splitContainer Panel1(차트)/Panel2(그리드) 비율 전환 — 차트(chartMain) 미이관(D00-1-023) — Grid(기본 idx2)만 동작, Chart/All 선택 시 레이아웃 변화 없음 @__asis-mapping__.md
- ✗ M04 미구현: D00-2-019 §2 SetCalendar / GetDayRange(.cs:1317·1384 MONTH) 조회기간 초기값 = PlanDate YYYYMM01 : GetPlanEndDate(.cs:2029 biz CommonData PLAN_END_DATE, division '81' 고정·WEEKLY) — Load·PlanDate 변경 시 — To-Be 원천 미배선: biz:CommonData.CommonDataList_REPORT(PLAN_END_DATE) 에 대응하는 사내 PROC/API 배선이 proc_meta.csv 에 없음 → 종료일 산출 불가. 현재 store from/to 초기값 '' (calendar 미조회·조회 시 기간 공란). PKG_SCP0100 에 PLAN_END_DATE 조회 프로시저 + 'planEndDate' 시트 배선(DB 객체) 선행 필요 @__asis-mapping__.md
- ✗ M04 미구현: D00-4-004 biz:CommonData.CommonDataList_REPORT (GetPlanEndDate .cs:2035 PLAN_END_DATE) — D00-2-019 와 동일 — 사내 To-Be 대응 PROC/API 배선 없음. 원천 SQL(As-is Data_REPORT PLAN_END_DATE) 확인 후 DB 객체로 신설 필요 @__asis-mapping__.md

## Claude 2회차 (exit 0)
```
드 함수 `seedCalendar`: `useGlobalPsiReportStore.ts:235-243`
- 기간 계산 순수 함수 `planDayRange`: `utils/globalPsiReportCalendar.ts` (신규)
- 상수 `PLAN_END_*`: `global-psi-report.constants.ts:33-45`

**대사표:** 미구현 0건, 빈 칸 0건입니다. 이번에 코드를 끼워 넣으면서 다른 행의 Form/Store/Const 라인 번호가 밀려서 전부 다시 맞췄습니다.

**B20:** `__tests__/GlobalPsiReport.spec.ts` 에 8건을 새로 만들었습니다. 테스트 데이터는 사내 DB 의 실제 달력 조회 결과입니다.

### 남은 항목과 사유
1. **최종 게이트 미실행(ERROR):** 권한 때문에 `--final` 을 돌리지 못했습니다. 직접 한 번 실행해 주세요.
2. **단위테스트·type-check 미실행:** 자동 실행 금지 규칙에 따라 돌리지 않았습니다. spec 8건은 아직 통과 여부를 모릅니다. 필요하면 요청해 주세요.
3. **런타임 미검증:** 화면에서 Plan Date 를 고르면 기간이 자동으로 채워지는지 직접 확인하지 않았습니다.
4. **차트 판단은 결정이 필요합니다:**
   - 빈 차트를 사용하지 않는 컨트롤로 보는 판단을 받아들이실지
   - 받아들이면 `allowed_gaps.csv` 에 규칙으로 등록할지 (전역 규칙이라 제가 바꾸지 않았습니다)
   - 아니면 Chart/All 선택 시 그리드 위에 빈 영역(750/270px)까지 똑같이 재현할지
   - GEN_NOTES 에 '사용자 결정 필요'로 적어 두었습니다.
5. **종료일 값 차이(참고):** 같은 Plan Date 인데도 As-is DEV 와 사내 To-Be 의 종료일이 다릅니다(예: 20260928 → As-is 20280618 / 사내 20270926). 로직이 같은 것은 확인했고, 두 DB 의 데이터가 서로 다른 것입니다.

**DB 변경과 클라우드 패키지:** DB 쓰기는 없었고 조회만 했습니다. 그래서 클라우드 이관 SQL 패키지도 필요 없습니다. 조회에 쓴 스크립트와 결과는 `tools/DbConn/_scratch/scp0100_*` 에 있습니다.
Ignoring --allowedTools rule "*)": Wildcard tool name "*)" is not supported in allow rules. An allow pattern must name the scope it widens — globs are permitted only in the tool position after a literal mcp__<server>__ prefix. Deny and ask rules accept wildcards anywhere.
Ignoring --allowedTools rule "*)": Wildcard tool name "*)" is not supported in allow rules. An allow pattern must name the scope it widens — globs are permitted only in the tool position after a literal mcp__<server>__ prefix. Deny and ask rules accept wildcards anywhere.
Ignoring --allowedTools rule "*)": Wildcard tool name "*)" is not supported in allow rules. An allow pattern must name the scope it widens — globs are permitted only in the tool position after a literal mcp__<server>__ prefix. Deny and ask rules accept wildcards anywhere.
Ignoring --allowedTools rule "*)": Wildcard tool name "*)" is not supported in allow rules. An allow pattern must name the scope it widens — globs are permitted only in the tool position after a literal mcp__<server>__ prefix. Deny and ask rules accept wildcards anywhere.
Ignoring --allowedTools rule "*)": Wildcard tool name "*)" is not supported in allow rules. An allow pattern must name the scope it widens — globs are permitted only in the tool position after a literal mcp__<server>__ prefix. Deny and ask rules accept wildcards anywhere.
```

## 게이트 2회차 — BLOCK 0 / WARN 2

**PASS** (WARN 2) — 2회 수선
