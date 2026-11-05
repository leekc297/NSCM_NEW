# To-Be 신규 화면 — Claude Code 작업 지시 (하네스 v1)

당신이 하는 일은 **생성기가 만든 골격의 TODO(이식) 지점을 채우는 것**뿐입니다. 골격·사전 규칙 부분은 바꾸지 않습니다.

## 입력 (전부 Read)
1. `Doc/gen/<ID>/GEN_NOTES.md` — 채울 항목 목록과 사전에 없던 것
2. `Doc/asisfacts/screens/<ID>/<ID>_summary.md` + `flow.csv` · `events.csv` · `grid_effective.csv` · `commented_calls.csv`(주석 처리된 호출 — 이식 금지)
2-1. **As-is `.cs` 원문 직접 Read**(`harness.json asisSrcRoot` + `files.csv` 의 current .cs) — 특히 `Form_Load → InitControls`: `InitValue = GetDayRange()`·콤보 기본값 같은 **프레임워크 유틸 호출은 flow.csv 에 잡히지 않는다**(`DateUtil.GetDayRange` = `SCM0001_GET_SCP_MONTH_PERIOD`). store 초기 조회조건을 빈값으로 두지 않는다(DoD B24).
2-2. **사내 현행 배선 정본** `Doc/tobefacts/db/proc_meta.csv`(화면×시트×버튼 → PROC) · `proc_params.csv`(PROC_M COL_NM). 같은 화면 행이 있으면 **filter 키 = col_nm**(DoD B22), API 배선은 그대로 두고 `<ID>_registration.sql` 은 적용하지 않는다(DoD B23).
3. `Doc/asisfacts/agent/<ID>/analysis.md` · `screen_design.md` · `unit_test.md` (있으면)
4. **이관 룰셋** `tools/VibeManager/rules/10_RULES_KEEP.md` — §A 원칙, §B~§F FE 규약, §I 런타임 함정, §J 완료 정의. 여기 적힌 것이 전부이며 `Doc/_rules_v2` 전문을 따로 읽지 않는다(필요한 항목만 그 행의 출처 hook 을 연다). 환경 제약은 `00_ENV.md`(pnpm/npm/eslint CLI 실행 금지, 서버는 사용자가 기동).
4-1. `tools/Harness/rules/map_control.csv` · `map_event.csv` · `map_button.csv` · `allowed_gaps.csv` — 변환 규칙의 본체
5. 표준 참조: `nscm-fe/features/admin/src/pages/user-management/`, 복수 시트·division 선례 `features/demand/src/pages/dmf0045/`
6. **프레임워크·공통 카탈로그**: `Doc/tobefacts/framework/INDEX.md` → 필요한 종류(components/hooks/stores/apis)를 읽고 **카탈로그에 있는 것만** 쓴다(import 경로·props 는 카탈로그 그대로). 없으면 만들지 말고 GEN_NOTES '룰 보완 후보' 로.
6-1. **VALIDATION 취합 참고자료**(SCP·SSP 화면 — 사용자 지시 2026-10-23): `Doc/화면분석서/{SCP|SSP}_화면_VALIDATION_취합_<최신>/<ID>.md`(화면별) · 전체본 `Doc/화면분석서/{SCP|SSP}_화면_VALIDATION_취합_<최신>.md`(판정 기준 = "작성기준" 시트). GEN_NOTES §11 에 이 화면 파일 경로·건수가 적혀 있다. AS-IS 화면(C#)·DB(SP) 검증 전수 + TO-BE 적용여부·적용 TAG·메시지 대조이므로 검증/메시지 작업 때 **필수 대조 원천**으로 쓴다(아래 6-2).
6-2. **조회조건 기준표 참고자료**(SCP·SSP 화면 — 사용자 지시 2026-10-23, 룰 E11): `tools/VibeManager/rules/40_SEARCH_COND.md` 의 `#### <ID>` 절(+ §2 정렬원칙·명칭/팝업 통일). 생성기가 이미 조회조건 **순서·사용여부·To-Be 명칭**을 적용했다(GEN_NOTES §12 · Form 주석 `기준표 #n`) — 아래 '해야 할 것' 1-1.
7. **하우스 스타일 예제**: `tools/Harness/prompts/examples/INDEX.md` — 채울 항목의 유형(§1 컨트롤 타입 / §2 이벤트명)에 맞는 `examples/<유형>.md` 를 먼저 읽고 **그 모양 그대로**(훅·컴포넌트·네이밍·주석 규약) 작성한다. 예제에 없는 유형만 표준 참조 화면을 본다.

## 완료 정의(DoD) — 끝났다고 말하기 전에 `node tools/Harness/check.js --page <폴더> --id <ID> --final` 의 `Doc/gen/<ID>/DOD.md` 가 전부 ✅ 여야 한다
기초 항목(B01~B21): index.ts export · MENU_ID as const+type · SHEETS · createPersistedStoreWithTab · useTabProcQuery<MENU_ID> · hotkeyConfig search/save/insert/delete/upload/manual 명시(As-is override 있으면 함수, 없으면 false; UsrConditionPanel 없으면 condition/resetCondition false) · As-is 팝업 1:1(components/modals 또는 공통 모달 재사용 명시 + 매핑표 POPUP 섹션) · Division 분기 보존 · AS-IS 파일:라인 주석 · Form 표준(SearchArea/FormItem/LBL 코드/useTabComboQueries) · DataGrid · 검증/표현식 훅 · 단위테스트 · register/e2e_plan/registration.sql/PKG.sql · **B22~B25**(filter 키 = 사내 PROC_M COL_NM · registration.sql 배선 = 사내 현행 · As-is Form_Load 초기값 반영 · 공통버튼 핸들러 빈 본문 0) · **M06/M07**(커밋본 대비 대사표 축소·파일 삭제 0).

## 해야 할 것 (순서)
1. 라벨 `LBL?????` → 등록 코드. 없으면 GEN_NOTES 에 "LBL 신규 채번 필요" 로 남기고 `_기본문구` 유지.
1-1. **조회조건 기준표(GEN_NOTES §12, 입력 6-2)** — 생성된 순서를 바꾸지 않는다(게이트 SC1). 기준표가 제외/통합한 AS-IS 조건을 되살리지 않는다(SC2 — BUTTON_AREA 는 버튼 영역으로 이식). `TODO(이식) 합침` 항목은 대표 필드를 To-Be 유형(예: 체크박스 4개 → 선택/다중 'Model Attribute')으로 바꾸고 선택값을 SP 인자로 분해. '명칭 변경' 라벨은 기존 LBL 재사용·없으면 신규 채번. 'AS-IS 컨트롤 없음' 조건은 **임의 추가하지 말고** GEN_NOTES 에 사람 판단 요청으로 남긴다. 검토중(REVIEW 류)은 AS-IS 그대로.
1-2. **조회영역 일괄 입력(Input 버튼) → 버튼 + 입력 팝업**(hook #155 · 룰 E14) — GEN_NOTES §12 에 'hook #155' 표시가 있으면: 대상 선택·Input Value·Input 버튼을 조회영역에서 빼고 SubTitle `customButtons [{ label: t(LBL.INPUT, '_Input'), action: handleInputOpen }]`(편집 권한 게이트·조회 선행 가드) + `components/<Page>InputModal.tsx` 를 **정본 SCP0096 `features/supply/src/pages/shipment-working-day-osp/` 그대로** 만든다(ShipmentWorkingDayOspInputModal · handleInputOpen · handleInputConfirm). OK = EditTracker 경유 셀 기록만(저장 SP 호출 금지), 분기·검증·메시지는 AS-IS Input 핸들러 원문. 게이트 BU1.
2. 콤보ID 확정 — As-is 콤보 SP(UP_FX_GetCommonDataList_* 등) ↔ To-Be 등록 콤보ID. 미등록이면 **코드로 우회하지 말고** GEN_NOTES 에 등록 요청으로 남긴다.
3. 이벤트 핸들러 TODO — `flow.csv` 의 호출 체인(진입점 → 메서드 → 엔드포인트) 그대로. 분기(division switch)·권한 분기는 통합하지 말고 보존.
4. 팝업/모달 — map_button.csv 의 modal 컴포넌트 사용. 없으면 `components/modals/` 에 CustomDialog 기반으로, As-is 팝업 클래스 1:1.
5. 그리드 — 메타 시트는 staticColumns 그대로. 하드코딩 시트(HARD_COLUMNS_*)만 As-is 컬럼 순서·헤더 유지. 편집 가능/잠금(LockRange) 은 `beginningEdit` 에서 `e.cancel`.
6. 검증/표현식 — `Doc/_analysis/.../validation.md`·`expressions.md` 건수 = 적용 건수.
6-1. **메시지 ID 는 AS-IS ID 를 그대로 쓰지 않는다**(룰 E5) — AS-IS 와 TO-BE 는 같은 ID 를 다른 문구에 쓴다. 검증 마커의 `msg` 는 생성기가 문구로 찾은 TO-BE ID 다(`Doc/gen/<ID>/msg_map.json`). 이벤트 핸들러 등에서 AS-IS 가 쓰던 MSG 를 새로 옮길 때도: AS-IS ID → `Doc/asisfacts/db/meta/dbo.TB_FX_MessageInfo.csv` 의 문구 → `Doc/tobefacts/db/msg_master.csv` 에서 같은 문구(KO, 없으면 EN)의 TO-BE ID. 같은 문구가 없으면 `MSG?????` + GEN_NOTES 에 신규 등록 요청(MSG01001+). 게이트 MS1 이 AS-IS ID 그대로 사용을 BLOCK 한다.
6-2. **VALIDATION 취합 대조**(SCP·SSP, 입력 6-1) — 화면 파일 `UI별VALIDATION_차단` 의 이 화면 행 전부를 검증 이식의 체크리스트로 쓴다(validation.md 와 합집합 — 한쪽에만 있는 행도 누락 금지).
   - `TO-BE 적용여부 = 미적용` 행: AS-IS 에 있고 TO-BE 에 없는 검사 → 이식하고 `__asis-mapping__.md` 에 반영(제외하려면 근거 기재).
   - `[메시지 불일치]` · `[메시지 미등록]` TAG 행: `(참고) MSG ID` 칸의 `xx(TO-BE)` 가 AS-IS 와 뜻이 다른/없는 ID 다 → `(참고) 메시지 의미 대조` 칸의 "같은 의미 ID" 로 바꾸거나(문구 기준, 6-1 규칙) 마스터 신규 등록 요청. 게이트 **VR2** 가 이 ID 가 코드에 남아 있으면 WARN.
   - `[판정 결과 차이]` 행: 막는 조건·대상·시점이 AS-IS 와 다름 — `(참고) TO-BE 근거` 의 `[적용 TAG 사유]` 를 읽고 AS-IS 와 같게 맞추거나, 의도된 변경이면 매핑표 비고에 근거.
   - `[AS-IS 결함 교정]` 행: AS-IS 결함을 고친 것이므로 AS-IS 동작으로 되돌리지 않는다.
   - `UI / DB = DB` 행은 SP 쪽 검증(PKG 이식 `port_pkg.md` 소관) — 화면은 SP 결과(코드·메시지)를 AS-IS 처럼 판정·표시하는지만 본다.
6-3. **AS-IS 액션 대조표 `__asis-actions__.md`**(사용자 지시 2026-10-23 — 페이지 폴더, 기존 화면 문서는 `Doc/asisfacts/screens/<AS-IS ID>/__asis-actions__.md`(전 화면 생성됨 — `node tools/Harness/actions-checklist.js <ID>` 로 갱신)) — AS-IS 핸들러 본문의 실행 문장 중 사용자 결과에 영향이 있는 동작 전수(값 비움·목록 재구성·그리드 Init/Clear/잠금·활성/숨김·플래그·메시지·중단·엔드포인트·콤보 데이터·팝업). 행마다 TO-BE 구현 위치(파일:라인)·상태(구현/미구현/제외/해당없음)·사유를 채운다. 조건(guard) 칸의 분기(사업부 40/81/82 등)도 같이 구현한다. **`⚠ 의미 확인 필요`**(사전 미등록 외부/상속 호출) 행은 AS-IS 원문 위치를 열어 실제 동작을 '의미' 칸에 적고 TO-BE 대응을 판단한다. 게이트 AC1(미처리 행)·AC2(의미 미기입)는 페이지 폴더 대조표(신규 화면)에서 --final BLOCK, 기존 화면 문서(AS-IS 자료 폴더)는 WARN(문서 보강 단계 — 개발된 UI·흐름 무영향, 사용자 지시 2026-10-23).
7. `__asis-mapping__.md` — 처리한 행의 상태를 **구현** 으로, 구현 위치 `파일:라인` 기입. 못 한 것은 미구현 + 사유. 빈 칸 금지.
8. 저장할 때마다 PostToolUse 게이트가 돌고, 종료 시 Stop 게이트가 `--final` 로 미구현 0 을 요구합니다. 게이트 메시지를 읽고 고치세요.

## 하지 말 것
- **git 이 추적하는(커밋된) 페이지 위에 골격 재생성·덮어쓰기** — `gen.js --apply/--overwrite`·`new-screen.ps1`·`pipeline.js`·`repair-loop.js` 를 기존 화면에 돌리지 않는다. 커밋본이 있으면 그 위에 보완만(2026-10-19 SCP0096 사고)
- 사전(rules/) 에 없는 컴포넌트 도입 → 먼저 사전에 추가 제안(GEN_NOTES "룰 보완 후보")
- 주석 처리된 As-is 코드(commented_calls.csv) 를 현행 기능으로 이식
- As-is 와 다르게 동작하도록 "개선" — 차이가 필요하면 `allowed_gaps.csv` 에 사유와 함께 등록하는 것이 먼저
- `console.log`, `any`, inline style, 상대경로 3단계 이상, feature 간 import, 자체 행상태 필드(rowStatus) — 게이트가 차단

## 감·예측 답변 금지 (사용자 상시 지시 2026-10-31 · hook #126 §0-1)

수치·진행율·소요 시간·원인·결과를 감이나 예측으로 답하지 않는다. 답은 이번에 실행한 측정·로그·파일·DB 조회 결과만 인용하고 그 출처와 시각을 함께 적는다. 측정하지 못했으면 '미측정'이라고 쓰고 측정 방법을 제시한다. '~할 것으로 기대', '약 N분', 'N% 쯤' 같은 추정 표현과, 원인을 확인하지 않은 단정을 금지한다. 진행율은 분모·분자를 명시한 실측값만 쓴다(정합검증 = tools/Harness/verify/doc_proof.py 출력).
