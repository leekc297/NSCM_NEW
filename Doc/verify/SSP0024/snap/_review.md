# 스냅샷 검토 SSP0024 — 2026-11-09 02:06

| 키 | 종류 | 범위 | 상태 | 골든 | 수신 | 차이 | 설명 |
|---|---|---|---|---|---|---|---|
| 조회조건_Div_40 | 조회조건 | Div 40 | NEW |  | Doc\verify\SSP0024\snap\received\조회조건_Div_40.aria.yml |  | 골든 없음 — 수신본 Doc\verify\SSP0024\snap\received\조회조건_Div_40.aria.yml 를 snap_validate.py 로 AS-IS 기대와 대조한 뒤 snap_approve.py 로 승인 · 조회영역 aria(15줄 · formItem 공통 조상) ·  |
| 버튼_Div_40 | 버튼 | Div 40 | NEW |  | Doc\verify\SSP0024\snap\received\버튼_Div_40.aria.yml |  | 골든 없음 — 수신본 Doc\verify\SSP0024\snap\received\버튼_Div_40.aria.yml 를 snap_validate.py 로 AS-IS 기대와 대조한 뒤 snap_approve.py 로 승인 · 버튼 바 aria(11줄) · 보이는 버튼 KOR,이 이민용,Ho |
| 헤더_Project | 헤더 | Project | NEW |  | Doc\verify\SSP0024\snap\received\헤더_Project.txt |  | 골든 없음 — 수신본 Doc\verify\SSP0024\snap\received\헤더_Project.txt 를 snap_validate.py 로 AS-IS 기대와 대조한 뒤 snap_approve.py 로 승인 · 헤더 1행 · 칸 25 |
| 팝업_Material | 팝업 | Material | NEW |  | Doc\verify\SSP0024\snap\received\팝업_Material.aria.yml |  | 골든 없음 — 수신본 Doc\verify\SSP0024\snap\received\팝업_Material.aria.yml 를 snap_validate.py 로 AS-IS 기대와 대조한 뒤 snap_approve.py 로 승인 · 팝업 aria(32줄) |
| 팝업_Model_Nickname | 팝업 | Model/Nickname | NEW |  | Doc\verify\SSP0024\snap\received\팝업_Model_Nickname.aria.yml |  | 골든 없음 — 수신본 Doc\verify\SSP0024\snap\received\팝업_Model_Nickname.aria.yml 를 snap_validate.py 로 AS-IS 기대와 대조한 뒤 snap_approve.py 로 승인 · 팝업 aria(32줄) |
| 화면샷_1920 | 화면샷 | 1920 | NEW | Doc\verify\SSP0024\snap\golden\화면샷_1920.png |  |  | 골든 없음 — 첫 캡처가 골든 후보로 저장됨(승인 전에는 판정필요) |
| 화면샷_1366 | 화면샷 | 1366 | NEW | Doc\verify\SSP0024\snap\golden\화면샷_1366.png |  |  | 골든 없음 — 첫 캡처가 골든 후보로 저장됨(승인 전에는 판정필요) |

승인: `python tools/Harness/verify/snap_expect.py <ID>` → `snap_validate.py <ID>`(불일치 0 확인) → `snap_approve.py <ID> [--item 키] --by 이름 --opinion 사유`
