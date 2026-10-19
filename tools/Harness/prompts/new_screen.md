# To-Be 신규 화면 — Claude Code 작업 지시 (하네스 v1)

당신이 하는 일은 **생성기가 만든 골격의 TODO(이식) 지점을 채우는 것**뿐입니다. 골격·사전 규칙 부분은 바꾸지 않습니다.

## 입력 (전부 Read)
1. `Doc/gen/<ID>/GEN_NOTES.md` — 채울 항목 목록과 사전에 없던 것
2. `Doc/asisfacts/screens/<ID>/<ID>_summary.md` + `flow.csv` · `events.csv` · `grid_effective.csv` · `commented_calls.csv`(주석 처리된 호출 — 이식 금지)
3. `Doc/asisfacts/agent/<ID>/analysis.md` · `screen_design.md` · `unit_test.md` (있으면)
4. `tools/Harness/rules/map_control.csv` · `map_event.csv` · `map_button.csv` · `allowed_gaps.csv` — 변환 규칙의 본체
5. 표준 참조: `nscm-fe/features/admin/src/pages/user-management/`, 복수 시트·division 선례 `features/demand/src/pages/dmf0045/`
6. **프레임워크·공통 카탈로그**: `Doc/tobefacts/framework/INDEX.md` → 필요한 종류(components/hooks/stores/apis)를 읽고 **카탈로그에 있는 것만** 쓴다(import 경로·props 는 카탈로그 그대로). 없으면 만들지 말고 GEN_NOTES '룰 보완 후보' 로.
7. **하우스 스타일 예제**: `tools/Harness/prompts/examples/INDEX.md` — 채울 항목의 유형(§1 컨트롤 타입 / §2 이벤트명)에 맞는 `examples/<유형>.md` 를 먼저 읽고 **그 모양 그대로**(훅·컴포넌트·네이밍·주석 규약) 작성한다. 예제에 없는 유형만 표준 참조 화면을 본다.

## 완료 정의(DoD) — 끝났다고 말하기 전에 `node tools/Harness/check.js --page <폴더> --id <ID> --final` 의 `Doc/gen/<ID>/DOD.md` 가 전부 ✅ 여야 한다
기초 항목(B01~B21): index.ts export · MENU_ID as const+type · SHEETS · createPersistedStoreWithTab · useTabProcQuery<MENU_ID> · hotkeyConfig search/save/insert/delete/upload/manual 명시(As-is override 있으면 함수, 없으면 false; UsrConditionPanel 없으면 condition/resetCondition false) · As-is 팝업 1:1(components/modals 또는 공통 모달 재사용 명시 + 매핑표 POPUP 섹션) · Division 분기 보존 · AS-IS 파일:라인 주석 · Form 표준(SearchArea/FormItem/LBL 코드/useTabComboQueries) · DataGrid · 검증/표현식 훅 · 단위테스트 · register/e2e_plan/registration.sql/PKG.sql.

## 해야 할 것 (순서)
1. 라벨 `LBL?????` → 등록 코드. 없으면 GEN_NOTES 에 "LBL 신규 채번 필요" 로 남기고 `_기본문구` 유지.
2. 콤보ID 확정 — As-is 콤보 SP(UP_FX_GetCommonDataList_* 등) ↔ To-Be 등록 콤보ID. 미등록이면 **코드로 우회하지 말고** GEN_NOTES 에 등록 요청으로 남긴다.
3. 이벤트 핸들러 TODO — `flow.csv` 의 호출 체인(진입점 → 메서드 → 엔드포인트) 그대로. 분기(division switch)·권한 분기는 통합하지 말고 보존.
4. 팝업/모달 — map_button.csv 의 modal 컴포넌트 사용. 없으면 `components/modals/` 에 CustomDialog 기반으로, As-is 팝업 클래스 1:1.
5. 그리드 — 메타 시트는 staticColumns 그대로. 하드코딩 시트(HARD_COLUMNS_*)만 As-is 컬럼 순서·헤더 유지. 편집 가능/잠금(LockRange) 은 `beginningEdit` 에서 `e.cancel`.
6. 검증/표현식 — `Doc/_analysis/.../validation.md`·`expressions.md` 건수 = 적용 건수.
7. `__asis-mapping__.md` — 처리한 행의 상태를 **구현** 으로, 구현 위치 `파일:라인` 기입. 못 한 것은 미구현 + 사유. 빈 칸 금지.
8. 저장할 때마다 PostToolUse 게이트가 돌고, 종료 시 Stop 게이트가 `--final` 로 미구현 0 을 요구합니다. 게이트 메시지를 읽고 고치세요.

## 하지 말 것
- 사전(rules/) 에 없는 컴포넌트 도입 → 먼저 사전에 추가 제안(GEN_NOTES "룰 보완 후보")
- 주석 처리된 As-is 코드(commented_calls.csv) 를 현행 기능으로 이식
- As-is 와 다르게 동작하도록 "개선" — 차이가 필요하면 `allowed_gaps.csv` 에 사유와 함께 등록하는 것이 먼저
- `console.log`, `any`, inline style, 상대경로 3단계 이상, feature 간 import, 자체 행상태 필드(rowStatus) — 게이트가 차단
