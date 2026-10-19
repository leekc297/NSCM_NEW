# DMF0082 조회 — MKT_FCST 의 AS From Site 를 같은 키의 다른 메저 행에도 표시 `[E20261013-DMF0082AFSSHARE]`

- 대상 DB: 사내오라클 `59.19.252.148:2521/ZIOUI1` (SERVER_HOST=localhost) · 계정 SCM_MGR
- 사용자 요청(2026-10-13): "MKT_FCST 에 AS_FROM_SITE 에 값이 있으며 동일 KEY 기준에 AS_FROM_SITE 가 같이 보여지고, CELL MERGE 가 발생하도록"

## 배경
- AS From Site 는 수요 원장(`ATTRIBUTE10`)에만 저장된다. 판가(LOC·KRW·USD) 원장에는 기록하지 않는다(AS-IS 판가 원장 약 450만 행 중 값 있는 행 0).
- 조회에서 판가 · 실적 · 계산 메저 행은 빈칸으로 내려가, 같은 품목이어도 MKT_FCST 행과 값이 달라 화면의 셀 병합이 끊겼다.
- AS-IS 도 같은 동작이다(판가 행 `'' AS AS_FROM_SITE`). **이번 변경은 AS-IS 와 다르게 가는 의도적 변경이다.**

## 변경 내용
`P_DMF0082_GET_MAIN_DATA` · `P_DMF0082_GET_MAIN_DATA_CURRENT` 의 AS From Site 빈값 정규화 문장(`[E20260825-AFSBLANK]`) 바로 뒤에 MERGE 1문장씩 삽입(+68줄, 기존 문장 무변경).

| 항목 | 규칙 |
|---|---|
| 원천 | 같은 조회 결과 안의 MKT_FCST 행 중 AS From Site 값이 있는 것 (빈칸 · `'-'` · `'/'` 는 값 없음) |
| 키 | Division · Project · End Customer · Sales Site · Model · Customs Handbook · Fcst Type · Incoterms · Plant Site · Cell Prod Site |
| 대상 | 같은 키의 MKT_FCST 가 아닌 행 중 AS From Site 가 비어 있는 것 |
| 건드리지 않는 것 | MKT_FCST 행 자신 · 자기 값이 있는 다른 메저 행 |
| 값이 둘 이상 | 한 키의 MKT_FCST 에 서로 다른 값이 있으면 채우지 않는다 |
| 실행 조건 | 결과 컬럼에 AS_FROM_SITE 가 있을 때만 (40 처럼 그 컬럼이 없는 조회는 건너뜀) |

조회용 임시 테이블의 표시값만 바꾼다. 원장 · 저장 SP · 단가 검증 무변경.

## 실행 작업 ↔ 파일
| # | 작업 | 파일 | 시각 | 결과 |
|---|---|---|---|---|
| 1 | BODY 최신 원문 조회·백업 (LAST_DDL 18:16:59 — 17:48 본과 내용 동일, 재컴파일만) | `00_BACKUP_PKG_DMF0082_BODY.sql` | 18:21 | 17,177줄 |
| 2 | 적용 전 조회 결과 저장 (조회만) | `test_before_after.py before` | 18:17 | 16케이스 |
| 3 | 삽입 MERGE 모의 행 테스트 (임시 테이블 · ROLLBACK) | `test_mock.py` | 18:20 | 7케이스 × 2 테이블 PASS |
| 4 | PKG_DMF0082 BODY 적용 | `01_PKG_DMF0082_BODY.sql` (`build_apply.py apply`) | 18:21:26 | VALID · 오류 0 · DB==적용본 · INVALID 124→124 |
| 5 | 전후 비교 | `test_before_after.py after` | 18:21 | 16케이스 PASS |
| 6 | 클라우드 패키지 리허설 (원복 → 적용 → 재적용 → 검증) | `_deploy_packages/DMF0082_AFSSHARE_CLOUD_20261013/` | 18:25:18 | 최종 적용 상태 · 마커 2 |
| 7 | 리허설 뒤 전후 비교 · 모의 행 테스트 재실행 | 위 2종 | 18:26 | PASS |

권한·시노님·메타·데이터 변경 없음. SPEC 무변경.

## 검증
- **모의 행 (7케이스 × 임시 테이블 2종)**: 값 1개 → 빈칸·`'-'`·`'/'` 행에 채움 / 자기 값 있는 행 유지 / 값 2개 → 미채움 / 값 없음 → 그대로 / 일부 주차만 값 → 다른 메저 채움·MKT_FCST 빈 주차 유지 / Plant Site 다른 키 격리 / 키 NULL 끼리 일치 / MKT_FCST 없는 키 그대로.
- **실제 조회 전후 (프로시저 2 × 조건 4 × 사용자 2 = 16케이스)**: 모두 적용 전과 동일.
  조건 = 81 HKMC_KR_ASA(10~12월) · 81 Volvo AS_WA_SE_GOT(1~4월) · 82 NextEra_US_PHX · 40 acer/acer_CN_CKG.

## 미실행
- **값이 있는 실제 데이터로의 조회 확인.** 사내 원장에는 당주 이후 MKT_FCST 에 AS From Site 값이 있는 행이 없다(81·82 모두 0건). 과거 구간은 실적 원천이라 값이 내려오지 않는다.
  그래서 실제 조회로는 "값이 없으면 달라지지 않는다"만 확인했고, 값이 있을 때의 동작은 모의 행으로만 확인했다.
- 화면에서의 셀 병합 확인 · 클라우드 적용.

## 알아 둘 점
- 같은 메저 안에서 계획 주차(값 있음)와 실적 주차(빈칸)로 2행으로 나뉘던 행은, 빈칸 쪽이 채워지면서 1행으로 합쳐진다.
- 화면이 편집한 행의 AS From Site 를 저장 SP 로 보내므로, 채워진 값이 보이는 수요 메저 행(SCM_FCST · VMI_In_Req · AS_In_Req)을 수정·저장하면 그 행의 `ATTRIBUTE10` 에도 그 값이 기록된다. 판가(LOC) 저장은 종전대로 AS From Site 를 기록하지 않는다.

## 원복
`00_BACKUP_PKG_DMF0082_BODY.sql` 실행, 또는 패키지의 `99_ROLLBACK_AFSSHARE_PATCH.sql`.
