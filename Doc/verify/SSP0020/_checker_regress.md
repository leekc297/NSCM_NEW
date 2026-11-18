# 검사기 회귀 대조 SSP0020 — 기준 2026-11-18 09:47 (6행) ↔ 현재 2026-11-18 11:52 (1468행)

- 악화(기준 비FAIL → 현재 FAIL): **0** (그중 승인 스냅샷 0) · 개선(FAIL → 비FAIL): 2 · 그 외 변경: 0 · 사용자 판정 자동 승인 0 · 기준에만 있는 행 0 · 새 행 1462
- 승격 대기(received): Doc\verify\_checker_golden\SSP0020.received.csv — 확인 뒤 `checker_regress.py SSP0020 --approve --by 이름`

## 악화 — 검사기 수정이 허위 FAIL 을 만들었는지 확인

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|

## 개선

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|
| V-db5fae91 | A5 | SSP0020 스냅샷 헤더 Delegate | FAIL | PASS | [정적 판정] 헤더 라벨 Active 반영 확인. 수신본 snap/received/헤더_Delegate.txt(11-17 22:46)에 'Active', snap_validate. |  |
| V-52d828e2 | A5 | SSP0020 스냅샷 헤더 Delegated List | FAIL | PASS | [정적 판정] 헤더 라벨 Active 반영 확인. 수신본 snap/received/헤더_Delegated_List.txt(11-17 22:46)에 'Active', snap_val |  |

## 그 외 변경

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|
