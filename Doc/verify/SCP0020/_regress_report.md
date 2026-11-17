# 검사기 회귀 보고 — 2026-11-14 11:09

오라클: Doc\verify\_user_verdicts.csv (435건 · 판정오류/중복/대상아님만 검사) · 놓친결함 오라클 Doc\verify\_missed_oracle.csv
위반 합계: 4

## SCP0020 — 대조 17건 · 위반 4 · 놓친결함 오라클 0건 중 위반 0
- V-15d2ee9d [판정오류] D1 Tact Time Except.LINE_ID (Line) — 검사기 원판정 FAIL 유지 — 사용자: '판정오류 - as-is 와 동일(AS-IS 오판)' · 현재 증거: [사용자판정] 판정오류 - as-is 와 동일(AS-IS 오판) — 실측: 신규행 r0 LINE_ID 편집=true (AS-IS 잠금)
- V-a193fc4f [판정오류] D4 VALID_YN — 검사기 원판정 FAIL 유지 — 사용자: '판정오류 - as-is 와 동일(AS-IS 오판)' · 현재 증거: [사용자판정] 판정오류 - as-is 와 동일(AS-IS 오판) — 실측: 신규행 VALID_YN='' ↔ AS-IS 기본값 "Y" 불일치
- V-cd782314 [중복] D1 Plant.DAILY_CAPACITY (Daily Capacity) — 조치 필요에 별도 항목으로 남음(묶이지 않음) — 사용자: '중복항목'
- V-d866915f [판정오류] A5 Plant.JUMBO_MIN (Jumbo / Min) — 검사기 원판정 FAIL 유지 — 사용자: '판정오류 - as-is 와 동일(AS-IS 오판)' · 현재 증거: [사용자판정] 판정오류 - as-is 와 동일(AS-IS 오판) — 실측: JUMBO_MIN 화면 표시=N (기대 표시 여부 = AS-IS VISIBLE_FLAG 'Y' (TO-BE 'N'))
