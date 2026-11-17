# 스냅샷 검토 SCP0108 — 2026-11-14 04:57

| 키 | 종류 | 범위 | 상태 | 골든 | 수신 | 차이 | 설명 |
|---|---|---|---|---|---|---|---|
| 조회조건_Div_40 | 조회조건 | Div 40 | NEW |  | Doc\verify\SCP0108\snap\received\조회조건_Div_40.aria.yml |  | 골든 없음 — 수신본 Doc\verify\SCP0108\snap\received\조회조건_Div_40.aria.yml 를 snap_validate.py 로 AS-IS 기대와 대조한 뒤 snap_approve.py 로 승인 · 조회영역 aria(77줄 · 바디 구간 폴백) · 시각 순서  |
| 버튼_Div_40 | 버튼 | Div 40 | ERROR |  |  |  | 버튼 바 컨테이너를 찾지 못함(로케이터 미확인) |
| 헤더_CURRENT | 헤더 | CURRENT | NEW |  | Doc\verify\SCP0108\snap\received\헤더_CURRENT.txt |  | 골든 없음 — 수신본 Doc\verify\SCP0108\snap\received\헤더_CURRENT.txt 를 snap_validate.py 로 AS-IS 기대와 대조한 뒤 snap_approve.py 로 승인 · 헤더 3행 · 칸 35 |
| 팝업_Basic_Nickname | 팝업 | Basic Nickname | NEW |  | Doc\verify\SCP0108\snap\received\팝업_Basic_Nickname.aria.yml |  | 골든 없음 — 수신본 Doc\verify\SCP0108\snap\received\팝업_Basic_Nickname.aria.yml 를 snap_validate.py 로 AS-IS 기대와 대조한 뒤 snap_approve.py 로 승인 · 팝업 aria(339줄) |
| 화면샷_1920 | 화면샷 | 1920 | NEW | Doc\verify\SCP0108\snap\golden\화면샷_1920.png | C:\Projects\NSCM\Doc\verify\SCP0108\e2e\artifacts\_snap--snap-스냅샷-형상-검사-snap-화면샷-패널-헤더-띠-1920-1366-chromium | C:\Projects\NSCM\Doc\verify\SCP0108\e2e\artifacts\_snap--snap-스냅샷-형상-검사-snap-화면샷-패널-헤더-띠-1920-1366-chromium | 골든 없음(승인 전) — 자동 생성 골든 후보 png 와 차이 — Error: [2mexpect([22m[31mpage[39m[2m).[22mtoHaveScreenshot[2m([22m[32mexpected[39m[2m)[22m failed Expected an i |
| 화면샷_1366 | 화면샷 | 1366 | NEW | Doc\verify\SCP0108\snap\golden\화면샷_1366.png | C:\Projects\NSCM\Doc\verify\SCP0108\e2e\artifacts\_snap--snap-스냅샷-형상-검사-snap-화면샷-패널-헤더-띠-1920-1366-chromium | C:\Projects\NSCM\Doc\verify\SCP0108\e2e\artifacts\_snap--snap-스냅샷-형상-검사-snap-화면샷-패널-헤더-띠-1920-1366-chromium | 골든 없음(승인 전) — 자동 생성 골든 후보 png 와 차이 — Error: [2mexpect([22m[31mpage[39m[2m).[22mtoHaveScreenshot[2m([22m[32mexpected[39m[2m)[22m failed Expected an i |

승인: `python tools/Harness/verify/snap_expect.py <ID>` → `snap_validate.py <ID>`(불일치 0 확인) → `snap_approve.py <ID> [--item 키] --by 이름 --opinion 사유`
