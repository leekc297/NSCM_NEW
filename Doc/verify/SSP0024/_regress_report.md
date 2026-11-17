# 검사기 회귀 보고 — 2026-11-15 04:02

오라클: Doc\verify\_user_verdicts.csv (435건 · 판정오류/중복/대상아님만 검사) · 놓친결함 오라클 Doc\verify\_missed_oracle.csv
위반 합계: 2

## SSP0024 — 대조 10건 · 위반 2 · 놓친결함 오라클 0건 중 위반 0
- V-b1b7474e [판정오류]   — 검사기 원판정 FAIL 유지 — 사용자: '4번 BOX_PER_CUT 신규행 편집(편집기 'Number expected') — 조치필요 아님 · TO-' · 현재 증거: [사용자판정] PASS — 4번 BOX_PER_CUT 신규행 편집(편집기 'Number expected') — 조치필요 아님 · TO-BE 룰(사용자 판정) (사용자(대화) 2026-11-10) — 실측: [화면 오류] 신규행 r0 BOX_PER_CU
- V-dbabc274 [판정오류]   — 검사기 원판정 FAIL 유지 — 사용자: '5번 STEELRACK_PER_CUT 신규행 편집(편집기 'Number expected') — 조치필요 아님' · 현재 증거: [사용자판정] PASS — 5번 STEELRACK_PER_CUT 신규행 편집(편집기 'Number expected') — 조치필요 아님 · TO-BE 룰(사용자 판정) (사용자(대화) 2026-11-10) — 실측: [화면 오류] 신규행 r0 STEE
