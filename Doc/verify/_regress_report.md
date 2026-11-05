# 검사기 회귀 보고 — 2026-11-05 13:28

오라클: Doc\verify\_user_verdicts.csv (323건 · 판정오류/중복/대상아님만 검사) · 놓친결함 오라클 Doc\verify\_missed_oracle.csv
위반 합계: 0

## SCP0111 — 대조 0건 · 위반 0 · 놓친결함 오라클 9건 중 위반 0
- ✔ 오라클 C4 /cboPlanDate|Plan ?Date/ 기대 NOT_FAIL · 일치 1행 · [2026-11-05 해소 → NOT_FAIL 회귀 감시 · 원 기대 FAIL] IntegrationPsiForm.tsx:298-305 Clea
- ✔ 오라클 C4 /cboPlanType|Plan ?Type/ 기대 NA · 일치 1행 · Plan Type 은 AS-IS PlanType.Visibility=Never(화면 미표시)·조회조건 기준표 미등재 → CR-071 대상 아님(
- ✔ 오라클 F1 /SCP0111 화면/ 기대 FAIL · 일치 1행 · 저장 버튼 동작 안함(편집 셀 추적 0 → MSG00004)
- ✔ 오라클 F4 /SCP0111 화면|SAVE/ 기대 FAIL · 일치 6행 · Save 클릭 시 저장 SP 호출 없음
- ✔ 오라클 G3 /SCP0111 화면/ 기대 FAIL · 일치 1행 · Condition(F6) 가 ConditionNotUseList(PlanDate·PlanType) 까지 저장 · Reset 이 화면값까지 비움
- ✔ 오라클 D1 /BOH_QTY/ 기대 FAIL · 일치 1행 · BOH 편집가능 색인데 편집 불가(AS-IS ADMIN 전 행 편집)
- ✔ 오라클 D1 /<DYNAMIC:/ 기대 FAIL · 일치 1행 · 월 컬럼 편집 조건(AS-IS 값 있으면 편집 · 빈 셀 잠금) 과 다름
- ✔ 오라클 H13 /<DYNAMIC:/ 기대 NOT_FAIL · 일치 1행 · [2026-11-05 해소 → NOT_FAIL 회귀 감시 · 원 기대 FAIL] IntegrationPsiGrid.tsx:427-433 음수 빨
- ✔ 오라클 E1 /BOH_QTY|<DYNAMIC:/ 기대 NOT_FAIL · 일치 2행 · [2026-11-05 해소 → NOT_FAIL 회귀 감시 · 원 기대 FAIL_OR_BLOCKED] IntegrationPsiGrid.tsx:3
