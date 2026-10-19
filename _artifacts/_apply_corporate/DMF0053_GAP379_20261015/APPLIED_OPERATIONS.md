# GAP 379 — DMF0053 칸·Measure 사용자별 화면 설정 이관 (사내 ZIOUI1 적용 기록)

- 대상: `SCM_MGR.SCM_MST_TITLESET_USER` PROGRAM_ID='DMF0053' / SHEET_NAME='CUST Fcst Waterfall'
- 원천: AS-IS `LESDFPSTO1C01/LGCE_SCMDEV` 직접 조회(2026-10-15 20:45:46) — 162행 = C 132행/8명(philsu.park 20·kjj0070 19·jssbae 18·kcw3408 17·hjkang.lges 17·lges_anhnv 14·dong.lee2 14·yangsh2 13) + M 30행/15명(전원 CUST_FCST·CUST_FCST_EDI 2행)
- 적용: 2026-10-15 20:57 (패키지 SQL 그대로 실행) · 접속 59.19.252.148:2521/ZIOUI1 (SERVER_HOST=localhost)

## 판정 근거
| 항목 | 실측 |
|---|---|
| 적용 전 TO-BE | C 80행/4명 · M 8행/4명 (qjastar·bpark416·jaehun_cho·minyonglee1 — 전부 TO-BE 생성분, AS-IS 사용자와 겹침 0) |
| 칸 메타 | SHEET_COLUMNS 66 · SHEET_MEASURE(VALID) 2 — AS-IS 162행의 칸 이름 **전부 존재**(메타 없음 0) |
| 읽기 경로 | `PKG_DMF0053` L1181~1188 정렬식이 titleset 'C' COLUMN_NAME 을 메타 조인 없이 동적 ORDER BY 에 사용 → 없는 칸 이관 시 ORA-00904 → 칸 메타 존재 조건 필수 |
| `DATA_SORT_METHOD_CODE=''` 행 | Oracle NULL 로 적재 — SP 가 `NVL(...,'ASC')` 로 읽어 AS-IS 와 동일 |
- ⚠ GAP 기재 AS-IS 604행(C 463/23명, hwayoung.lim·yeo0422 포함)은 AS-IS DEV 와 다름 — 다른 AS-IS 환경 수치로 추정, 해당 DB 미접속(인스턴스 DB 목록에 QA/운영 없음).

## 검증
| 항목 | 결과 |
|---|---|
| 트랜잭션 검증 `verify_txn.py` (INSERT → 실제 GET 2종 → ROLLBACK, FE 실전송값 81·20260901~20270228·ONLY_WEEKLY, 사용자만 교체) | 11/11 PASS — 오류 0 · 결과코드 0 · 칸 제목 47→39~46 사용자 설정 반영 · 정렬식 = AS-IS 칸 순서 일치 · ROLLBACK 후 88행 원상 |
| 실제 적용·리허설 (00→10→90→10→99→90→10→90) | 적용 후 C 212/12명 · M 38/19명 · 재실행 동일(멱등) · 99 후 반영 0 · 재적용 후 132/30 · 무효 칸 0 |

## 파일
- `analyze.py`(AS-IS↔TO-BE 대조, `asis_rows.json` 원천 스냅샷) · `build_sql.py`(패키지 SQL 생성) · `verify_txn.py`
- 패키지: `_artifacts/_deploy_packages/DMF0053_GAP379_TITLESET_CLOUD_20261015/` (00/10/90/99 · `_rehearsal_out/`)
