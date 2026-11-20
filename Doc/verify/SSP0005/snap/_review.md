# 스냅샷 검토 SSP0005 — 2026-11-20 01:05

| 키 | 종류 | 범위 | 상태 | 골든 | 수신 | 차이 | 설명 |
|---|---|---|---|---|---|---|---|
| 조회조건_Div_40 | 조회조건 | Div 40 | NEW |  | Doc\verify\SSP0005\snap\received\조회조건_Div_40.aria.yml |  | 골든 없음 — 수신본 Doc\verify\SSP0005\snap\received\조회조건_Div_40.aria.yml 를 snap_validate.py 로 AS-IS 기대와 대조한 뒤 snap_approve.py 로 승인 · 조회영역 aria(13줄 · formItem 공통 조상) ·  |
| 버튼_Div_40 | 버튼 | Div 40 | NEW |  | Doc\verify\SSP0005\snap\received\버튼_Div_40.aria.yml |  | 골든 없음 — 수신본 Doc\verify\SSP0005\snap\received\버튼_Div_40.aria.yml 를 snap_validate.py 로 AS-IS 기대와 대조한 뒤 snap_approve.py 로 승인 · 버튼 바 aria(10줄) · 보이는 버튼 KOR,이 이민용,Ho |
| 헤더_Shipment_Working_Day | 헤더 | Shipment Working Day | MATCH | Doc\verify\SSP0005\snap\golden\헤더_Shipment_Working_Day.txt | Doc\verify\SSP0005\snap\received\헤더_Shipment_Working_Day.txt |  | 골든 Doc\verify\SSP0005\snap\golden\헤더_Shipment_Working_Day.txt 와 일치 · 헤더 3행 · 칸 362 |
| 화면샷_1920 | 화면샷 | 1920 | MATCH | Doc\verify\SSP0005\snap\golden\화면샷_1920.png |  |  | 골든 화면샷과 일치(maxDiffPixelRatio 0.002) |
| 화면샷_1366 | 화면샷 | 1366 | MATCH | Doc\verify\SSP0005\snap\golden\화면샷_1366.png |  |  | 골든 화면샷과 일치(maxDiffPixelRatio 0.002) |

승인: `python tools/Harness/verify/snap_expect.py <ID>` → `snap_validate.py <ID>`(불일치 0 확인) → `snap_approve.py <ID> [--item 키] --by 이름 --opinion 사유`
