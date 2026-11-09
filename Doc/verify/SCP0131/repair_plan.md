# 보완 계획 SCP0131 — 2026-11-08 11:47 · 대상 조치 필요 5행 · 레시피 있음 5 · 레시피 없음 0

> 적용은 보완실행 단계에서(hook #152 절차 · repairScope 에 따라 FE 는 가이드). 각 행의 검증 = 부분 재판정 명령(--only) 1회.

## FE — 4행 · 적용 여부: 범위 밖(가이드만)

| 보완 ID | 규칙 | 대상 | 현상(실측) | 변경 요지(레시피) | 대상 객체 | 검증 | 자동 |
|---|---|---|---|---|---|---|---|
| FX-SCP0131-004 | F2 | SCP0131 시나리오 [자동] 기존행 수정 + 신규행 동시 Save 1 | [자동] 기존행 수정 + 신규행 동시 Save 1회 → 요청에 M·I: 저장 요청 없음 · 저장 요청 없음 · 저장 요청 0 · 편집기 null · search:0행·신규0·호출0·요청9 → type:61행·신규0· | 변경 행 수집 0 또는 사전검증 실패 시 사용자 알림 표시 · 저장 요청이 실제 발생하는지(call-proc) 확인 | 화면 저장 핸들러(saveRequest·useSaveWithValidation) | `python tools/Harness/verify/run_verify.py SCP0131 --only F2` | N |
| FX-SCP0131-012 | E7 | Sales Site Priority.ITEM_ID (Model*) | ITEM_ID 신규행 r0: 잘못된 값 'ZZ_E2E_BAD_POPUP_KEY' key-in → 셀 값 'ZZ_E2E_BAD_POPUP_KEY' — 잘못된 값이 검증 없이 남아 저장 대상이 됨(AS-IS 는 팝업 값 | 키인 값이 팝업 후보 밖이면 되돌림 또는 검증 메시지(AS-IS MSG00458) — 저장 전 차단 | 팝업 입력 컬럼 셀 편집기(onBlur) 사전검증 | `python tools/Harness/verify/run_verify.py SCP0131 --only E7` | N |
| FX-SCP0131-014 | E1 | Sales Site Priority.PRIO_RANK (Priority* | 신규행 r0 PRIO_RANK: 유효값 '1' 입력 OK(편집기) · 소수 0자리 초과 입력 '1.5' → 값 '1.5' NG · 문자(숫자 아님) 입력 'ab' → 값 '1.5' OK (AS-IS cell_rule | 신규행 숫자 칸 기본값 '' → null(InputNumber 와 충돌 제거) · 최대/최소는 메타가 정본 | pages/*/editLock.ts 신규행 기본값 · columnMapping InputNumber | `python tools/Harness/verify/run_verify.py SCP0131 --only E1` | N |
| FX-SCP0131-015 | H13 | Sales Site Priority.PRIO_RANK (Priority* | PRIO_RANK r0 값 '-1' 글자색 rgb(0, 0, 0) · -1 입력 후 측정(복원) — 음수가 빨강이 아님(AS-IS NegativeRed=true · TO-BE 그리드 formatter 음수 글자색 처 | 음수 셀 글자색 빨강(AS-IS NegativeRed=true) — 공통 formatter 옵션 또는 컬럼 cssClass | DataGrid formatter(음수 글자색) | `python tools/Harness/verify/run_verify.py SCP0131 --only H13` | N |

## COMMON — 1행 · 적용 여부: 범위 밖(가이드만 · 공통 컴포넌트)

| 보완 ID | 규칙 | 대상 | 현상(실측) | 변경 요지(레시피) | 대상 객체 | 검증 | 자동 |
|---|---|---|---|---|---|---|---|
| FX-SCP0131-001 | G3 | SCP0131 화면 | E2E smoke 공통 'Condition(F6) Period 비저장(기간 조건 제외)' [FAIL] 기간 키 저장됨: fromDate, toDate (공통 요건 11 · CR-029: 기간 조건은 저장 제외) ／  | 기간 조건 키(fromDate/toDate 등 period 류)를 저장 대상에서 제외(CR-029) | 조회조건 저장(Condition F6) 훅 — 저장 키 목록(공통 훅이면 COMMON · 화면 exclude | `python tools/Harness/verify/run_verify.py SCP0131 --only G3` | N |

