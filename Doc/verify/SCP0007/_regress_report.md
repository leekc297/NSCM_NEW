# 검사기 회귀 보고 — 2026-11-14 09:56

오라클: Doc\verify\_user_verdicts.csv (435건 · 판정오류/중복/대상아님만 검사) · 놓친결함 오라클 Doc\verify\_missed_oracle.csv
위반 합계: 2

## SCP0007 — 대조 35건 · 위반 2 · 놓친결함 오라클 0건 중 위반 0
- T-00e52cb4 [판정오류] G6 cboInputStatus / Input Status / Status — 검사기 원판정 FAIL 유지 — 사용자: '판정오류
(오류 아님,,  AS-IS 초기값을 못가져 온 검증엔진의 잘못을 오류로 판정함)' · 현재 증거: [사용자판정] 판정오류 (오류 아님,, AS-IS 초기값을 못가져 온 검증엔진의 잘못을 오류로 판정함) — 실측: AS-IS 초기값 코드 'C'(라벨 미확인(옵션·콤보 API 응답에 코드 없음)) ↔ TO-BE 초기 표시 'Completed' 불일치
- V-e53c539d [판정오류] B2 bod.TO_SITE_CODE (To Site*) — 검사기 원판정 FAIL 유지 — 사용자: '실제 조회 시 이상 없음.
판정오류' · 현재 증거: [사용자판정] 실제 조회 시 이상 없음. 판정오류 — 실측: TO_SITE_CODE 후보 5480건(신규행 Division='81' 기준) · 중복 AU00×2, EG00×6, IL00×2, MI00×2, AC00-A×12, AT00-A×3, AU00
