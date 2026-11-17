# 스냅샷 검토 SSP0003 — 2026-11-14 10:27

| 키 | 종류 | 범위 | 상태 | 골든 | 수신 | 차이 | 설명 |
|---|---|---|---|---|---|---|---|
| 조회조건_Div_40 | 조회조건 | Div 40 | NEW |  | Doc\verify\SSP0003\snap\received\조회조건_Div_40.aria.yml |  | 골든 없음 — 수신본 Doc\verify\SSP0003\snap\received\조회조건_Div_40.aria.yml 를 snap_validate.py 로 AS-IS 기대와 대조한 뒤 snap_approve.py 로 승인 · 조회영역 aria(158줄 · formItem 공통 조상) · |
| 버튼_Div_40 | 버튼 | Div 40 | NEW |  | Doc\verify\SSP0003\snap\received\버튼_Div_40.aria.yml |  | 골든 없음 — 수신본 Doc\verify\SSP0003\snap\received\버튼_Div_40.aria.yml 를 snap_validate.py 로 AS-IS 기대와 대조한 뒤 snap_approve.py 로 승인 · 버튼 바 aria(9줄) · 보이는 버튼 KOR,이 이민용,Hom |
| 헤더_Shipment_Change_Request_Confirm | 헤더 | Shipment Change Request Confirm | NEW |  | Doc\verify\SSP0003\snap\received\헤더_Shipment_Change_Request_Confirm.txt |  | 골든 없음 — 수신본 Doc\verify\SSP0003\snap\received\헤더_Shipment_Change_Request_Confirm.txt 를 snap_validate.py 로 AS-IS 기대와 대조한 뒤 snap_approve.py 로 승인 · 헤더 1행 · 칸 19 |
| 헤더_Shipment_Change_Request_Confirm_Detail | 헤더 | Shipment Change Request Confirm Detail | NEW |  | Doc\verify\SSP0003\snap\received\헤더_Shipment_Change_Request_Confirm_Detail.txt |  | 골든 없음 — 수신본 Doc\verify\SSP0003\snap\received\헤더_Shipment_Change_Request_Confirm_Detail.txt 를 snap_validate.py 로 AS-IS 기대와 대조한 뒤 snap_approve.py 로 승인 · 헤더 2행 · 칸 |
| 팝업_Requestor | 팝업 | Requestor | NEW |  | Doc\verify\SSP0003\snap\received\팝업_Requestor.aria.yml |  | 골든 없음 — 수신본 Doc\verify\SSP0003\snap\received\팝업_Requestor.aria.yml 를 snap_validate.py 로 AS-IS 기대와 대조한 뒤 snap_approve.py 로 승인 · 팝업 aria(225줄) |
| 화면샷_1920 | 화면샷 | 1920 | NEW | Doc\verify\SSP0003\snap\golden\화면샷_1920.png |  |  | 골든 없음(승인 전) — 자동 생성 골든 후보 png 와 일치(maxDiffPixelRatio 0.002) · snap_approve.py 승인 전에는 판정필요 |
| 화면샷_1366 | 화면샷 | 1366 | NEW | Doc\verify\SSP0003\snap\golden\화면샷_1366.png |  |  | 골든 없음(승인 전) — 자동 생성 골든 후보 png 와 일치(maxDiffPixelRatio 0.002) · snap_approve.py 승인 전에는 판정필요 |

승인: `python tools/Harness/verify/snap_expect.py <ID>` → `snap_validate.py <ID>`(불일치 0 확인) → `snap_approve.py <ID> [--item 키] --by 이름 --opinion 사유`
