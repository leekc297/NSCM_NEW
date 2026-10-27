# DMF0082_LASTUPD_20261027 — 사내 ZIOUI1 적용 기록 `[E20261027-DMF0082LASTUPD]`

- 요청(2026-10-27): Column Set 에서 LAST UPDATED BY · LAST UPDATE DATE 선택 시 GROUP BY 대상이 아니라, 선택 컬럼 키별 수정일 최대 행의 수정자·수정일 1쌍만 표시. 메저 표기 불변. 미선택 시 로직 미적용.
- 접속: 59.19.252.148:2521/ZIOUI1 · SERVER_HOST=localhost · SCM_MGR
- 기준 원문: ALL_SOURCE 재조회 2026-10-27 13:28 · BODY LAST_DDL 2026-10-27 11:57:29 (17,843줄) → `00_BACKUP_PKG_DMF0082_BODY.sql`

| 시각 | 작업 | 결과 |
|---|---|---|
| 13:30 | 적용 전 기준 수집 `test_before_after.py before` (40호출) | 증상 재현: 두 컬럼 선택 시 줄 증가 (GET 81 124→136 · 82 2046→2090 · 40 117→123, CURRENT 40 120→124 등) → `_before.log` |
| 13:33:46 | `build_apply.py apply` — FRESH-GATE PASS → BODY 2곳 삽입(+72줄, 기존 줄 변경 0) | VALID · USER_ERRORS 0 · INVALID 39→39 (무변동) |
| 13:34 | `test_before_after.py after` | **40/40 PASS** → `_after.log` |
| 13:42 | 클라우드 패키지 리허설 99→00→90→10→10→90→99→99→10 | 99 후 원문 == 수정 전 원문 True(2회) · 10 재실행 SKIP · VALID/오류 0 |
| 13:42:55 | 최종 = 클라우드 패치 방식 적용본 (CURRENT 블록이 DEFECT_GUARD 주석 다음 · IF 앞 — 01 파일과 주석 위치만 다름) | 마커 2 |
| 13:43~ | 리허설 뒤 `test_before_after.py after` 재실행 | 29 PASS · 11 FAIL — **전부 minyonglee1**. 실행 중 13:45:14 에 그 계정 Measure 설정('M' 7행)이 화면에서 변경됨 → 블록 미실행인 BASE 도 117→113 으로 바뀜(적용 전 스냅샷과 비교 불가). k0101 20건은 전부 PASS → `_after_rehearsal.log` |
| 13:50~ | `test_consistency.py` — 같은 실행 안 BASE→BY/DATE/BOTH→BASE (적용 전 스냅샷 불필요) | **30/30 PASS** (BASE 안정 · 줄 수·키·메저 = BASE · 키당 1쌍) → `_consistency.log` |

## 판정 기준 (test_before_after.py)
- 프로시저 2종 × (81 HKMC_KR_ASA · 82 NextEra_US_PHX · 40 acer_CN_CKG) × 사용자(minyonglee1 · k0101) × 변형(BASE · BY · DATE · BOTH)
- BASE: 적용 전과 완전 동일 / BY·DATE·BOTH: 줄 수 = BASE · 두 컬럼 뺀 내용(키+메저) = BASE · 두 컬럼 값 = 적용 전 BOTH 결과에서 키별 수정일 MAX·그 수정자 MAX 로 독립 계산한 정답과 일치
- 테스트 Column Set 행은 같은 세션 INSERT → 호출 → ROLLBACK (잔존 0 확인)
- 한계: CURRENT 의 81·82 는 사내 데이터 0행이라 실값 검증 없음(오류 없음만 확인)

원복: `_deploy_packages/DMF0082_LASTUPD_CLOUD_20261027/A_DB/99_ROLLBACK_LASTUPD_PATCH.sql` (사내 검증 완료) 또는 `00_BACKUP_PKG_DMF0082_BODY.sql`(단, 이후 타 작업분 있으면 덮어씀 — 99 권장)
