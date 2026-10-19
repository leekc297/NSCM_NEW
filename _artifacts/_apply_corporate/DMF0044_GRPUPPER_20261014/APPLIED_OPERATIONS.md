# DMF0044 조회 CUTOFF DATA 구간 ORA-00979 보완 `[E20261014-DMF0044GRPUPPER]`

- 대상 DB: 사내오라클 `59.19.252.148:2521/ZIOUI1` (SERVER_HOST=localhost) · 계정 SCM_MGR
- 사용자 신고(2026-10-14): 클라우드 DMF0044 조회 — Data Type 이 ALL · CUTOFF DATA 이면 SQL ERROR, ETC 는 정상.

## 원인 (사내 재현)
`PKG_DMF0044.P_DMF0044_GET_SALES_REPORTS_DATA` 의 CUTOFF DATA INSERT 문에서 Model Type 식이 SELECT 와 GROUP BY 에서 서로 다르다.

| 위치 | 식 |
|---|---|
| SELECT (L1531~1533) | `CASE WHEN UPPER(SINGLE.ITEM_CLASS_NAME) LIKE '%CELL%' …` |
| GROUP BY (L1603~1605) | `CASE WHEN SINGLE.ITEM_CLASS_NAME LIKE '%CELL%' …` |

→ `ORA-00979: "SINGLE"."ITEM_CLASS_NAME": must appear in the GROUP BY clause` (line 1482). 컴파일은 VALID 이고 실행 시점에만 난다.

- 10-06 백업본(`DMF0044_0049_ASISPARITY_20261006/00_BACKUP`)에는 SELECT 에도 UPPER 가 없었다. 그 뒤 SELECT 3줄에만 UPPER 가 들어갔다.
  BODY LAST_DDL 2026-10-13 19:46:40 · 마커 없음 — 누가 언제 넣었는지는 확인하지 못했다.
- ETC 구간은 SELECT · GROUP BY 모두 UPPER 가 없어 정상이다.
- 사내 오류 기록(`SCM_SYS_LOG_BATCH`)에는 이번 재현 4건만 있다 — 사내에서는 변경 뒤 CUTOFF DATA 조회가 없었다.

## 변경 내용
GROUP BY 의 3줄을 SELECT 와 같은 식(UPPER)으로 맞췄다. SELECT · ETC 구간 · 그 밖의 문장 무변경(변경 3줄).

## 실행 작업 ↔ 파일
| # | 작업 | 파일 | 시각 | 결과 |
|---|---|---|---|---|
| 1 | 적용 전 재현 (조회만) | `test_call.py` 와 같은 호출 | 09:24 | ALL · CUTOFF DATA = ORA-00979 / ETC = 정상 |
| 2 | BODY 최신 원문 조회·백업 (LAST_DDL 10-13 19:46:40) | `00_BACKUP_PKG_DMF0044_BODY.sql` | 09:28 | 10,587줄 |
| 3 | PKG_DMF0044 BODY 적용 | `01_PKG_DMF0044_BODY.sql` (`build_apply.py apply`) | 09:28:20 | VALID · 오류 0 · DB==적용본 · INVALID 63→63 |
| 4 | 적용 후 호출 | `test_call.py` | 09:28 | 6케이스 정상 |
| 5 | 클라우드 패키지 리허설 (원복 → 점검 → 적용 → 재적용 → 검증) | `_deploy_packages/DMF0044_GRPUPPER_CLOUD_20261014/` | 09:30:23 | 최종 적용 상태 · 마커 1 |
| 6 | 리허설 뒤 호출 재확인 | `test_call.py` | 09:31 | PASS |

권한·시노님·메타·데이터 변경 없음. SPEC 무변경.

## 검증 (40 · 2026년 · 버전 2종 × Data Type 3종)
| 버전 | ALL | CUTOFF DATA | ETC | ALL = CUTOFF + ETC |
|---|---|---|---|---|
| REPORT_SP_W `R_S_20261002_V001_C` | 4,458행 | 4,266행 | 192행 | 일치 |
| REPORT_BP_M `R_B_20260814_V001` | 8,227행 | 8,035행 | 192행 | 일치 |

## 미실행
- 81 · 82 사업부 호출 (사내 `DM_PLN_SALES_PLAN_REPORT_C` 2026년분은 40 만 있다).
- 화면 확인 · 클라우드 적용.
- 클라우드 원문이 사내와 같은 상태인지는 확인하지 못했다 — 패키지의 00 L1(오류 기록) · L2(식 4줄)로 확인한다.

## 원복
`00_BACKUP_PKG_DMF0044_BODY.sql` 실행, 또는 패키지의 `99_ROLLBACK_GRPUPPER_PATCH.sql` (되돌리면 오류가 다시 난다).
