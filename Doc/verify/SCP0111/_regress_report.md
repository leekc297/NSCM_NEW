# 검사기 회귀 보고 — 2026-11-18 19:50

오라클: Doc\verify\_user_verdicts.csv (470건 · 판정오류/중복/대상아님만 검사) · 놓친결함 오라클 Doc\verify\_missed_oracle.csv
위반 합계: 9

## SCP0111 — 대조 12건 · 위반 4 · 놓친결함 오라클 9건 중 위반 5
- V-28123894 [판정오류] G4 SCP0111 스냅샷 조회조건 Div 40 — 검사기 원판정 FAIL 유지 — 사용자: '오류 아님' · 현재 증거: [재실측 스냅샷 조회조건] 기준 Doc\verify\SCP0111\snap\golden\조회조건_Div_40.aria.yml ↔ 실측 Doc\verify\SCP0111\snap\received\조회조건_Div_40.aria.yml · 차이 13줄(Do
- V-55556e17 [판정오류] H4 SCP0111 스냅샷 화면샷 1920 — 검사기 원판정 FAIL 유지 — 사용자: '- 오류 아님 - 컬럼 폭 비율 은 오류에서 제외' · 현재 증거: [재실측 스냅샷 화면샷] 기준 Doc\verify\SCP0111\snap\golden\화면샷_1920.png ↔ 실측 C:\Projects\NSCM\Doc\verify\SCP0111\e2e\artifacts\_snap--snap-스냅샷-형상-검사-sn
- V-e8ca7b9a [판정오류] H4 SCP0111 스냅샷 화면샷 1366 — 검사기 원판정 FAIL 유지 — 사용자: '- 오류 아님 - 컬럼 폭 비율 은 오류에서 제외' · 현재 증거: [재실측 스냅샷 화면샷] 기준 Doc\verify\SCP0111\snap\golden\화면샷_1366.png ↔ 실측 C:\Projects\NSCM\Doc\verify\SCP0111\e2e\artifacts\_snap--snap-스냅샷-형상-검사-sn
- V-f5114028 [판정오류] H6 SCP0111 스냅샷 팝업 Model/Nickname — 검사기 원판정 FAIL 유지 — 사용자: '오류 아님 - TO-BE RULE' · 현재 증거: [재실측 스냅샷 팝업] 기준 Doc\verify\SCP0111\snap\golden\팝업_Model_Nickname.aria.yml ↔ 실측 Doc\verify\SCP0111\snap\received\팝업_Model_Nickname.aria.yml ·
- ✔ 오라클 C4 /cboPlanDate|Plan ?Date/ 기대 NOT_FAIL · 일치 1행 · [2026-11-05 해소 → NOT_FAIL 회귀 감시 · 원 기대 FAIL] IntegrationPsiForm.tsx:298-305 Clea
- ✔ 오라클 C4 /cboPlanType|Plan ?Type/ 기대 NA · 일치 1행 · Plan Type 은 AS-IS PlanType.Visibility=Never(화면 미표시)·조회조건 기준표 미등재 → CR-071 대상 아님(
- ✖ 오라클 F1 /SCP0111 화면/ 기대 FAIL · 일치 1행 — 놓친 결함 — 일치 1행 결과 PASS · 저장 후 재조회에 수정값 반영 — DB 반영 확인 · 원복 저장·복원 확인(정리 완료) · 수정 저장 경로 강제(edit-save) · 고정 18칸(1415px) ≥ 가시 폭 1543px 의 85% → 측정 동안 고 · 저장 버튼 동작 안함(편집 셀 추적 0 → MSG00004)
- ✖ 오라클 F4 /SCP0111 화면|SAVE/ 기대 FAIL · 일치 6행 — 놓친 결함 — 일치 6행 결과 ERROR, PASS · 수정 저장 2회 SQL 오류 없음 — main/SAVEDETAIL:200 요청={"activeFlag":"M^M^M^M^M^M","planType":"FN^FN^FN^FN^FN^FN","divisionId":"81^ · Save 클릭 시 저장 SP 호출 없음
- ✖ 오라클 G3 /SCP0111 화면/ 기대 FAIL · 일치 1행 — 놓친 결함 — 일치 1행 결과 PASS · E2E smoke 공통 'Reset Condition(F10) 화면값 유지(AS-IS 서버 저장본만 삭제)' [OK] 화면 조건값 6개 유지 | E2E smoke 공통 'Reset Condition(F10) 조회조건 · Condition(F6) 가 ConditionNotUseList(PlanDate·PlanType) 까지 저장 · Reset 이 화면값까지 비움
- ✖ 오라클 D1 /BOH_QTY/ 기대 FAIL · 일치 1행 — 놓친 결함 — 일치 1행 결과 PASS · 기존행 BOH_QTY: r0 편집=true / AS-IS 편집 가능(기본(편집 모드 전체 해제) [그룹 ADMIN 기준, 보유 그룹 합집합 CR-102]) OK · r1 편집=true / AS-IS 편집 가능(기본( · BOH 편집가능 색인데 편집 불가(AS-IS ADMIN 전 행 편집)
- ✖ 오라클 D1 /<DYNAMIC:/ 기대 FAIL · 일치 1행 — 놓친 결함 — 일치 1행 결과 PASS · 기존행 동적 <DYNAMIC:CalendarMonth> → 대표 202610(6개 중) 202610: r0 편집=true / AS-IS 편집 가능(기본(편집 모드 전체 해제) [그룹 ADMIN 기준, 보유 그룹 합집 · 월 컬럼 편집 조건(AS-IS 값 있으면 편집 · 빈 셀 잠금) 과 다름
- ✔ 오라클 H13 /<DYNAMIC:/ 기대 NOT_FAIL · 일치 1행 · [2026-11-05 해소 → NOT_FAIL 회귀 감시 · 원 기대 FAIL] IntegrationPsiGrid.tsx:427-433 음수 빨
- ✔ 오라클 E1 /BOH_QTY|<DYNAMIC:/ 기대 NOT_FAIL · 일치 2행 · [2026-11-05 해소 → NOT_FAIL 회귀 감시 · 원 기대 FAIL_OR_BLOCKED] IntegrationPsiGrid.tsx:3
