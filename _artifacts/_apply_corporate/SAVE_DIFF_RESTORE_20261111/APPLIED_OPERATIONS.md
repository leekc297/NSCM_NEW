# 사내 DB(ZIOUI1 · SCM_MGR) 적용 기록 — 저장 대조 시험 잔여 복원 (2026-11-11)

## 1. 무슨 일이 있었나 (시각은 도구 출력·DB 값 그대로)

| 시각 | 내용 |
|---|---|
| 2026-11-11 15:43:21 | `tools/Harness/verify/save_diff.py SCP0028 --run --max 1` 실행(저장 SP AS-IS↔TO-BE 실행 대조 첫 실행) |
| 2026-11-11 15:43:26 | TO-BE `PKG_SCP0028.P_SCP0028_SAVE_SHIPMENT_LOT_SIZE` 가 PROC 안의 `COMMIT`(본문 823·863행)으로 **확정** — 도구의 ROLLBACK 이 듣지 않음 |
| 2026-11-11 15:43:2x | 도구가 ROLLBACK 뒤 잔여를 검출해 `RESIDUE` 로 즉시 중단(exit 4) |
| 2026-11-11 15:45:31 | 아래 2. 의 복원 적용·확인 완료 |

실행한 저장 본문 = 사내 호출 로그 `SCM_COM_SQL_LOG` #4453752(2026-11-10 09:19:31 · minyonglee1 · E2E 가 원복 저장했던 값):
`lotSize 12800^5760 · increment 12800^288 · itemId ACEP2065I-B1^ACEN1053I-A1 · toSite Club Car_US_AGS^CS Enertech_KR_OSN · transportMode SEA^TRK · divisionId 81 · fromSite HQ07-A · operationGroup A · activeFlag M^M`

## 2. 남았던 것과 복원 (flashback `AS OF TIMESTAMP 2026-11-11 15:43:00` 과 대조)

| 표 | 시험이 남긴 것 | 복원 | 확인 |
|---|---|---|---|
| `SCP_MST_SHIPMENT_LOT_SIZE` | 2행의 `LAST_UPDATE_DATE` 2026-11-02 14:26:01 → 2026-11-11 15:43:26 (업무 컬럼·`LAST_UPDATED_BY` 는 실행 전과 같음) | `UPDATE … SET LAST_UPDATE_DATE = 2026-11-02 14:26:01` — 키 6컬럼 + `LAST_UPDATE_DATE = 15:43:26` + `LAST_UPDATED_BY = 'minyonglee1'` 가드 · 각 1행 | 실행 전 시점과 `MINUS` 양방향 0행 |
| `SCP_MST_SHIPMENT_LOT_SIZE_H` | 이력 +2행(`HISTORY_SEQ` 1568·1569) | `DELETE … WHERE HISTORY_SEQ IN (1568,1569)` + `CREATION_DATE = 15:43:26` + `CREATED_BY = 'minyonglee1'` 가드 · 2행 | 행 수 1459 = 실행 전 1459 |
| `SCM_SYS_LOG_BATCH` | 로그 +2행(`SCP0028_SAVE_SHIPMENT_LOT_SIZE` START·END · 15:43:26 · scm_batch) | **남김** — 프로시저가 실행됐다는 사실 기록 | - |

가드 건수가 기대(1·1·2)와 다르면 ROLLBACK 하도록 한 스크립트로 적용했고, 기대와 일치해 COMMIT 했다.
AS-IS DEV(MSSQL) 쪽은 도구의 잔여 검사에서 차이 0(바깥 트랜잭션 ROLLBACK 으로 되돌려짐).

## 3. 원인

- 저장 대조 대상 목록(`save_diff_targets.py`)이 "TO-BE 를 ROLLBACK 으로 되돌릴 수 있는가"를 `f10_check.csv` 의 PASS 로 판정했다.
- `f10_check` 는 저장 **원자성** 검사라서 최상위 저장 PROC 의 마지막 `COMMIT` 을 정상으로 보고 PASS 를 낸다(T71). PASS ≠ "COMMIT 없음".
- 즉 검사 결과의 뜻을 확인하지 않고 다른 목적의 안전 판정에 가져다 쓴 것(추측)이 원인이다.

## 4. 재발 방지 (같은 날 반영 · 결함 대장 T237)

1. `save_diff_targets.py` — 되돌림 판정을 **사내 `ALL_SOURCE` 원문(피호출 재귀)의 확정 문장 실측**으로 교체(`COMMIT`·`AUTONOMOUS_TRANSACTION`·`EXECUTE IMMEDIATE`·`TRUNCATE`·`DBMS_STATS`). 원문을 못 읽으면 "없음"이 아니라 제외(미측정).
   재판정 결과(15:47:38): 저장 SP 짝 61건 중 ROLLBACK 가능 6 · 확정 문장 있음 19 · 제외 36.
2. `save_diff.py` — 실행 직전에 원문을 다시 읽어 확인 + TO-BE 세션에 `ALTER SESSION DISABLE COMMIT IN PROCEDURE`(확정 시도 = ORA-00034).
3. 확정 문장이 있는 TO-BE 저장 PROC(19건)은 **실행하지 않는다** — 스냅샷·복원 방식은 사용자 결정 전까지 미구현으로 둔다.

## 5. 복원 방식 실행분 (사용자 승인 2026-11-11 16:2x "실제 저장 후 복원 방식으로 대조 - 진행")

`save_diff.py <ID> --run --snapshot`: 실행 전 SCN 기록 → TO-BE 저장 PROC 실제 실행(확정) → `표 MINUS 표 AS OF SCN` 으로 바뀐 행 측정 → 실행 전 값과 다른 행만 삭제·재삽입 → 실행 전과 차이 0 확인 후 COMMIT. 로그 표 `SCM_SYS_LOG_BATCH` 의 시작/종료 행은 남김.

| 화면 | 실행 시각 | 호출 로그 본문 # | TO-BE PROC | 판정 | 복원 후 잔여 | 증거 |
|---|---|---|---|---|---|---|
| SCP0028 | 2026-11-11 16:30:14 | 4453752 | PKG_SCP0028.P_SCP0028_SAVE_SHIPMENT_LOT_SIZE | PASS | 0 | Doc/verify/SCP0028/save_diff/P_SCP0028_SAVE_SHIPMENT_LOT_SIZE__1.md |
| SCP0028 | 2026-11-11 16:30:16 | 4453720 | PKG_SCP0028.P_SCP0028_SAVE_SHIPMENT_LOT_SIZE | PASS | 0 | Doc/verify/SCP0028/save_diff/P_SCP0028_SAVE_SHIPMENT_LOT_SIZE__2.md |
| SCP0033 | 2026-11-11 16:31:15 | 4600015 | PKG_SCP0033.P_SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY | PASS | 0 | Doc/verify/SCP0033/save_diff/P_SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY__1.md |
| SCP0033 | 2026-11-11 16:31:17 | 4599870 | PKG_SCP0033.P_SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY | PASS | 0 | Doc/verify/SCP0033/save_diff/P_SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY__2.md |
| SSP0025 | 2026-11-11 16:31:19 | 4398131 | PKG_SSP0025.P_SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC | PASS | 0 | Doc/verify/SSP0025/save_diff/P_SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC__1.md |
| SSP0025 | 2026-11-11 16:31:20 | 4398114 | PKG_SSP0025.P_SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC | PASS | 0 | Doc/verify/SSP0025/save_diff/P_SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC__2.md |

- 16:28:29 첫 실행(SCP0028)은 복원 대상을 블록 단위로 골라 본 표 1007행·이력 1461행을 지웠다 다시 넣었다(결과는 실행 전과 차이 0). 이후 실행은 값이 달라진 행만 복원하도록 고쳤다(결함 대장 T238).
- 같은 화면 요약 파일은 마지막 실행 결과만 담는다(SCP0028 은 16:28·16:29·16:30 세 번 실행 — 표는 마지막 실행분).
