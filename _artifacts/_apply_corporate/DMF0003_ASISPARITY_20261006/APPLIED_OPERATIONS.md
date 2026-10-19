# DMF0003 저장 AS-IS 운영 동작 일치 `[E20261006-ASISPARITY]` — 사내 ZIOUI1 실행 작업 대조표

> ⚠ **2026-10-06 17:12:18 대체됨** — 사용자 결정 변경("TO-BE 에서 394행을 똑바로 수정하고, 이에 따라 제대로 동작하도록 보완").
> 본 건의 가드 8곳 + 주석 3줄은 `[E20261006-ITEMGT]` 적용 때 제거됐다 (품목 원천을 임시테이블로 올바르게 적재하는 방식으로 교체).
> 현행 = [../DMF0003_ITEMGT_20261006/APPLIED_OPERATIONS.md](../DMF0003_ITEMGT_20261006/APPLIED_OPERATIONS.md). 아래 `99_ROLLBACK_apply.py` 는 더 이상 쓰지 않는다(가드가 없어 ABORT).

| 시각 (2026-10-06) | 계정 | 작업 | 대상 | SQL / 스크립트 |
|---|---|---|---|---|
| 14:31:57 | SCM_MGR | 적용 전 원문 조회·백업 (조회 전용) | `PKG_DMF0003` BODY (LAST_DDL 2026-10-02 20:31:56) | [00_BACKUP_PKG_DMF0003_BODY.sql](00_BACKUP_PKG_DMF0003_BODY.sql) |
| 14:39:56 | SCM_MGR | **PKG BODY 적용** (FRESH-GATE 통과 · VALID · ERR 0 · 적용본 == DB 원문 · 의존 INVALID 0) | `PKG_DMF0003` BODY | [01_PKG_DMF0003_BODY.sql](01_PKG_DMF0003_BODY.sql) (`python build_apply.py apply`) |

## 변경 내용 — `P_DMF0003_SAVE_MKT_FCST` 삽입 8곳 + 설명 주석 3줄 (기존 줄 삭제 없음)

| # | 대상 | 적용 후 줄 | 방식 |
|---|---|---|---|
| ① | 81 환산정보(Cell/Car) 검증 (품목 GT 적재 포함) | L11339 | `IF V_CHECK_CNT > 0 AND 1 = 0 … THEN` |
| ② | 81 Kwh/Cell·CELL_TYPE·Cell/Car 항목 검증 | L11417 | 〃 |
| ③ | BOM 존재 검증 (후보 선확인 + 본 검증) | L11574, L11607 | 〃 (`V_BOM_YN` 갱신 UPDATE 는 AS-IS 도 수행 → 유지) |
| ④ | 상품·전극 RTF_SYS_RP 삭제 / 생성 | L12187, L12235 | WHERE 에 `AND 1 = 0` |
| ⑤ | RMA RTF_SYS_RP 삭제 / 생성 | L12277, L12313 | 〃 |

## 근거
- AS-IS 운영 `DMF0003_SAVE_MKT_FCST` (덤프 수정일 2026-07-22) [E20260720-000270]: 품목 원천을 뷰 → `#TEMP_DM_MST_ITEM_SINGLE_V_ALL` 로 교체.
  적재 조건 L394 `WHERE DIVISION_ID = @p_division_id` 가 L189 에서 `'^'` 가 붙은 값(`'82^'`)과 비교 → 항상 0건 → 위 ①~⑤ 가 운영에서 동작하지 않음.
- AS-IS 개발 DB(`LGCE_SCMDEV`, 2026-10-06 14:25) 실측: `'82'` 76,277건 / `'82^'` 0건 / `'82^82^82^'` 0건.
- 사용자 확정 2026-10-06: "as-is 사용하지 않는 검증은 to-be 에서도 하지 않으면", "운영 as-is 와 같이 맞춰주세요".

## 검증 (2026-10-06 15:05~16:00) — 수정 전 = 검증용 복제 `PKG_DMF0003_TB`(적용 전 백업본), 수정 후 = `PKG_DMF0003`

| 시각 | 계정 | 작업 | 스크립트 · 결과 파일 |
|---|---|---|---|
| 15:05 / 15:50 | SCM_MGR | 검증용 복제 패키지 생성 (2회) — 운영 무영향 | `t01_test.py clone` |
| 15:18~15:27 | SCM_MGR | **검증 3종 호출 비교** — 대표 SHIP-TO 없는 사이트 입력(다음 검증에서 반드시 중단 · 원장 무기록 · 호출마다 ROLLBACK) | `t01_test.py cases` / `cases3` → `_test_result_run1.json` · `_test_result_run2.json` · `_test_result.json` |
| 15:40경 | SCM_MGR | **RTF_SYS_RP 4문장 대상 건수 비교** (조회만 · 세션 임시 테이블 적재 후 ROLLBACK) | `t01_test.py rtf` → `_test_rtf.json` |
| 15:53~16:00 | SCM_MGR | **실제 저장 왕복** — 원장에 없는 81 키 2개 · 수정 전 저장→정리→수정 후 저장→정리 (DELETE = 그 키의 행 전부, 사전 0건 확인분) | `t02_e2e.py` → `_test_e2e.json` |
| 15:30 / 16:00 | SCM_MGR | 검증용 복제 패키지 삭제 (2회) | `t01_test.py drop` |

결과
- 검증 3종: 수정 전 `BOM does not exist !`(82 2건·40 2건) / `Cell/Car does not exist !`(81 2건) / `Kwh/Cell does not exist !`(81 2건) → 수정 후 8건 모두 해당 검증 통과(다음 `SITE SHIP-TO does not exist !` 에서 중단). 테스트 계정 원장 변경 0건.
- RTF 건수(당주 MKT_FCST 키 전부 재저장 가정): 82 = 삭제 319→0 · 생성 319→0 / 40·81 = 0→0 / RMA = 당주 이후 원장 행 0건이라 0→0 (데이터로 차이 실증 불가).
- 실제 저장 왕복(81): 2개 키 모두 수정 전·후 `SUCCESS`, 결과 행 `DM_PLN_MKT_FCST` 569건(MKT_FCST·BALANCE) 감사 일시 제외 전 컬럼 동일, `DM_PLN_CFM_MKT_DEMAND_PLAN` 0건 동일. 정리 후 잔존 0건.
- 잔존: `DM_PLN_MKT_FCST_H` 이력에 테스트 저장분(키 `81/A15BW7002/BMW_DE_BKB/APBMW48CL-A2-2I0`, `81/A15FD5002/Ford_US_URI/AMDAU0095B`, 20261012, minyonglee1) 추가 — 감사 기록으로 남김(건수 미계수).

## 미실시·주의
- **82·40 사업부의 실제 저장 성공 경로 미실행** — 82 는 저장 후 Sales Plan 동기화, 40 은 매출금액 재계산이 추가로 실행되어 테스트 키 밖 데이터에 영향을 줄 수 있어 제외. 82 상품·전극 품목 저장 시 RTF_SYS_RP 가 그대로 남는지는 화면 확인 필요.
- SPEC · PROC_M · GRANT · 메타 · 테이블 변경 없음 (BODY 교체만).
- 클라우드 미적용 (이관 패키지 미작성).
- 원복: `python 99_ROLLBACK_apply.py` (현재 DB 원문에서 삽입분만 제거).
- asis_delta_20261002 대응: 1단계 SR 우선순위 1번 묶음(`DMF0003_SAVE_MKT_FCST` #002·#004·#009·#015·#023~026) — 임시테이블 이식 대신 본 건으로 종결.
