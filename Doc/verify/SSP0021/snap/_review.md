# 스냅샷 검토 SSP0021 — 2026-11-14 13:38

| 키 | 종류 | 범위 | 상태 | 골든 | 수신 | 차이 | 설명 |
|---|---|---|---|---|---|---|---|
| 조회조건_Div_40 | 조회조건 | Div 40 | NEW |  | Doc\verify\SSP0021\snap\received\조회조건_Div_40.aria.yml |  | 골든 없음 — 수신본 Doc\verify\SSP0021\snap\received\조회조건_Div_40.aria.yml 를 snap_validate.py 로 AS-IS 기대와 대조한 뒤 snap_approve.py 로 승인 · 조회영역 aria(194줄 · formItem 공통 조상) · |
| 버튼_Div_40 | 버튼 | Div 40 | NEW |  | Doc\verify\SSP0021\snap\received\버튼_Div_40.aria.yml |  | 골든 없음 — 수신본 Doc\verify\SSP0021\snap\received\버튼_Div_40.aria.yml 를 snap_validate.py 로 AS-IS 기대와 대조한 뒤 snap_approve.py 로 승인 · 버튼 바 aria(13줄) · 보이는 버튼 KOR,이 이민용,Ho |
| 헤더_Hold_stock | 헤더 | Hold stock | NEW |  | Doc\verify\SSP0021\snap\received\헤더_Hold_stock.txt |  | 골든 없음 — 수신본 Doc\verify\SSP0021\snap\received\헤더_Hold_stock.txt 를 snap_validate.py 로 AS-IS 기대와 대조한 뒤 snap_approve.py 로 승인 · 헤더 3행 · 칸 64 |
| 헤더_Hold_stock_Detail | 헤더 | Hold stock Detail | NEW |  | Doc\verify\SSP0021\snap\received\헤더_Hold_stock_Detail.txt |  | 골든 없음 — 수신본 Doc\verify\SSP0021\snap\received\헤더_Hold_stock_Detail.txt 를 snap_validate.py 로 AS-IS 기대와 대조한 뒤 snap_approve.py 로 승인 · 헤더 1행 · 칸 41 |
| 팝업_Model_Nickname | 팝업 | Model/Nickname | NEW |  | Doc\verify\SSP0021\snap\received\팝업_Model_Nickname.aria.yml |  | 골든 없음 — 수신본 Doc\verify\SSP0021\snap\received\팝업_Model_Nickname.aria.yml 를 snap_validate.py 로 AS-IS 기대와 대조한 뒤 snap_approve.py 로 승인 · 팝업 aria(51줄) |
| 화면샷_1920 | 화면샷 | 1920 | NEW | Doc\verify\SSP0021\snap\golden\화면샷_1920.png |  |  | 골든 없음(승인 전) — 자동 생성 골든 후보 png 와 일치(maxDiffPixelRatio 0.002) · snap_approve.py 승인 전에는 판정필요 |
| 화면샷_1366 | 화면샷 | 1366 | NEW | Doc\verify\SSP0021\snap\golden\화면샷_1366.png |  |  | 골든 없음(승인 전) — 자동 생성 골든 후보 png 와 일치(maxDiffPixelRatio 0.002) · snap_approve.py 승인 전에는 판정필요 |

승인: `python tools/Harness/verify/snap_expect.py <ID>` → `snap_validate.py <ID>`(불일치 0 확인) → `snap_approve.py <ID> [--item 키] --by 이름 --opinion 사유`
