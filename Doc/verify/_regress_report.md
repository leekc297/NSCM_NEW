# 검사기 회귀 보고 — 2026-11-05 08:01

오라클: Doc\verify\_user_verdicts.csv (323건 · 판정오류/중복/대상아님만 검사) · 놓친결함 오라클 Doc\verify\_missed_oracle.csv
위반 합계: 3

## SCP0111 — 대조 0건 · 위반 0 · 놓친결함 오라클 9건 중 위반 3
- ✖ 오라클 C4 /cboPlanDate|Plan ?Date/ 기대 FAIL · 일치 1행 — 놓친 결함 — 일치 1행 결과 PASS · 조회 1714행 → 'Plan Date' 변경('2026-10-26 (W44)') 후 0행(그리드별 0) · 자동 재조회 0건 — 기대 그리드 초기화(AS-IS CboPlanDate_SelectedIndexChang · Plan Date 변경 시 그리드 초기화 안됨(AS-IS cs:1860 ClearDataSource)
- ✔ 오라클 C4 /cboPlanType|Plan ?Type/ 기대 NA · 일치 1행 · Plan Type 은 AS-IS PlanType.Visibility=Never(화면 미표시)·조회조건 기준표 미등재 → CR-071 대상 아님(
- ✔ 오라클 F1 /SCP0111 화면/ 기대 FAIL · 일치 1행 · 저장 버튼 동작 안함(편집 셀 추적 0 → MSG00004)
- ✔ 오라클 F4 /SCP0111 화면|SAVE/ 기대 FAIL · 일치 6행 · Save 클릭 시 저장 SP 호출 없음
- ✔ 오라클 G3 /SCP0111 화면/ 기대 FAIL · 일치 1행 · Condition(F6) 가 ConditionNotUseList(PlanDate·PlanType) 까지 저장 · Reset 이 화면값까지 비움
- ✔ 오라클 D1 /BOH_QTY/ 기대 FAIL · 일치 1행 · BOH 편집가능 색인데 편집 불가(AS-IS ADMIN 전 행 편집)
- ✔ 오라클 D1 /<DYNAMIC:/ 기대 FAIL · 일치 1행 · 월 컬럼 편집 조건(AS-IS 값 있으면 편집 · 빈 셀 잠금) 과 다름
- ✖ 오라클 H13 /<DYNAMIC:/ 기대 FAIL · 일치 1행 — 놓친 결함 — 일치 1행 결과 PASS · 202609 r67 값 '-1,520' 글자색 rgb(255, 0, 0) (동적 <DYNAMIC:CalendarMonth> → 대표 202609(6개 중)) · 음수 글자색 빨강(NegativeRed 프레임워크 기본) 미적용
- ✖ 오라클 E1 /BOH_QTY|<DYNAMIC:/ 기대 FAIL_OR_BLOCKED · 일치 2행 — 놓친 결함 — 일치 2행 중 측정 FAIL 0 · 차단(D1 FAIL 연결) 1 · 그 외 PASS · 정수만 입력(소수·문자 거부) 미적용 — TO-BE 가 BOH·월 컬럼을 전부 잠가(D1 FAIL) 입력 자체가 불가하면 '[편집 불가로 미측정
