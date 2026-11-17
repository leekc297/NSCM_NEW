# SCP0111 BOH 저장 2행 분리 — 사내 적용 기록

- 대상 DB: 사내 ZIOUI1 (SERVER_HOST=localhost · SERVICE=zioui1)
- 현행 적용: 2026-11-03 10:47:55 (LAST_DDL) · STATUS=VALID · ALL_ERRORS 0 · 마커 `2026.11.03 SCP0111 BOH DB-ONLY` + `2026.11.03 SCP0111 BOH INV-QTY`

| # | 시각 | 작업 | 파일 |
|---:|---|---|---|
| 1 | 09:48:28 | 착수 원문 조회 (당시 BODY INVALID · LAST_DDL 2026-11-02 09:14:49 · ALL_ERRORS 0) | - |
| 2 | 09:55:12 | 재현 시험의 SP 호출로 BODY 자동 재컴파일 (원문 동일 · VALID 전환) | - |
| 3 | 10:01:20 | 1차: `P_SCP0111_SAVE_PSI_ADMIN` M 분기 BOH 동기화 추가 (FE 절대값 전송 전제 · 폐기) | `apply_boh_sync.py` |
| 4 | 10:18~10:20 | FE 수정분 되돌림 · repairScope DB_FE→DB_ONLY | `tools/Harness/verify/set_scope.py` |
| 5 | 10:20:30 | 2차(현행): M 분기를 현재 FE 전송값 기준으로 변경 (FRESH-GATE 통과) | `apply_boh_db_only.py` |
| 6 | 09:55~10:48 | PLAN_START=20991231 전용 시험 행 생성·삭제 (잔존 0 확인) | - |
| 7 | 10:47:55 | 3차(현행): BOH 저장 시 월별 INV QTY 를 BOH 변경량만큼 가감 (FRESH-GATE 통과) | `apply_boh_inv_qty.py` |

## 현행 M 분기 계약
- `MEASURE=INV` = BOH 셀: 같은 KEY 전체 월 BOH 를 새 값으로 맞추고 QTY 는 월별 (새 BOH - 그 월 BOH) 만큼 가감.
  AS-IS 일반 SP 의 INV 분기 동작이다. AS-IS ADMIN 경로는 QTY 를 바꾸지 않으므로 이 부분은 AS-IS ADMIN 과 다르다.
- 그 외 = 월 수량 셀: `QTY = QTY + 가감값`. BOH 변경 없음.
- FE 가 ADMIN 저장을 절대값 전송으로 바꾸면 이 SP 와 맞지 않는다. 함께 바꿔야 한다.

## 원복
- 수정 전 원문(1차 이전): `PKG_SCP0111_BODY.ASIS.sql` 앞에 `CREATE OR REPLACE ` 를 붙여 실행.
- 2차 적용 직전(1차 적용본): `PKG_SCP0111_BODY.DBONLY_ASIS.sql`.
- INV 반영만 되돌리기(2차 적용본): `PKG_SCP0111_BODY.INVQTY_ASIS.sql`. 3차 적용본: `PKG_SCP0111_BODY.INVQTY_TOBE.sql`.

타 사용자 행 변경 없음. 기존 BOH 분리 12 KEY(09:48:56 측정)는 수정하지 않았다.

## 2026-11-17 대체

- 2026-11-17 17:35:22 `M` 분기를 AS-IS UPDATE 1문으로 되돌림(FE 절대값 전송 전제). 이 기록의 "현행 M 분기 계약"은 더 이상 현행이 아님. 기록: `_artifacts/_apply_corporate/SCP0111_ADMIN_M_ASIS_20261117/APPLIED_OPERATIONS.md`
