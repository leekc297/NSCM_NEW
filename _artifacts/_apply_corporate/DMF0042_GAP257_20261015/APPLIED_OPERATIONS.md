# GAP 257 — DMF0042 빈 FCST Type·Incoterms 행 키 보정 (사내 ZIOUI1 적용 기록)

- 대상: `SCM_MGR.PKG_DMF0042` PACKAGE BODY → `P_DMF0042_SAVE_DM_PLN_BP_FCST` "2021.7.23 키 업데이트용으로 들어온 데이터 처리" 블록 (현행 L4788~4855 · GAP 기재 4686~4741 은 타 작업자 수정으로 행 이동)
- 마커: `[E20261015-GAP257]` 5곳 · 접속: 59.19.252.148:2521/ZIOUI1 (SERVER_HOST=localhost)
- 기준본: 2026-10-15 18:3x DB 재조회 LAST_DDL **2026-10-14 09:22:09** (VALID) → 적용 18:36:13 (FRESH-GATE 통과)
  → 클라우드 패키지 리허설로 원복·재적용, 최종 LAST_DDL **2026-10-15 18:48:21** (md5 = 사내 적용본 `710eda3b…`)

## 원인 (실측)
| # | 원인 | 근거 |
|---|---|---|
| 1 | `WHERE A.FCST_TYPE IS NULL OR A.INCOTERMS IS NULL` 가 항상 거짓 | 두 컬럼 NOT NULL · PK · `DEFAULT ON NULL '/'` (ALL_TAB_COLUMNS) |
| 2 | AS-IS 의 `AND @v_DIVISION_ID = '40'` 누락 | AS-IS 운영본 `DMF0042_SAVE_DM_PLN_BP_FCST` (SP1_DDL L138795~) |
| 3 | 11키 조인 센티널 불일치 — 40 원장 DEPT_ID·END_CUSTOMER·BIZ_TYPE·ITEM_USE = `'-'`(1,186,444행 전부), GT 정규화(L4341~4350) = `'/'` | 1 만 고쳐도 영구 미매칭 |

- 빈값 실태: 사내 원장 40 71,673 · 81 3,084 · 82 368행 = 전부 `'-'`/`'-'` (YYYYMM ≤ 202412, 82 ≤ 202512) · `'/'` 0행.
- AS-IS(LESDFPSTO1C01/LGCE_SCMDEV, 2026-10-15 18:25 직접 조회): 같은 행이 전부 빈값 `''`, 실제 `'-'` 값 0 → TO-BE `'-'` = 이관 빈값 자리표시.
- 사용자 방침(2026-10-15): 과도기에는 `'-'`·`'/'` 공존 → **둘 다 허용**.

## 변경 (+11줄, 블록 1곳)
1. 빈값 검사 → `A.FCST_TYPE IN ('-', '/') OR A.INCOTERMS IN ('-', '/')`
2. `IF V_CNT_1 > 0 AND V_DIVISION_ID = '40' THEN` (AS-IS 1:1 — V_DIVISION_ID = 쪼개기 반복문 마지막 값, AS-IS 와 동일 의미)
3. GT 쪽(count·MERGE USING): 센티널 키 4종 `DECODE(x,'-','/',x)` 인라인 뷰 / 원장 쪽 ON: `DECODE(A.x,'-','/',A.x) = B.x` (4종 × 2)
   - PROJECT_CODE·SCM_SITE_ID·ITEM_ID 는 raw 유지 → PK 선두 4컬럼 인덱스 사용 유지
- 유지(AS-IS 파리티): MERGE UPDATE 는 키 11개 일치 행 전체(빈값 행만이 아님) · 채운 뒤 `GOTO END_PKUPDATE`(그 저장의 수량 반영 없음 — AS-IS 동일).
- 충돌 점검: 40 키 4,471 중 빈값 키 1,662 · 빈값/값 혼재 4키 — 빈값 행(2018~2020)과 값 행(2022~) YYYYMM 겹침 0 → PK 충돌 없음.

## 검증
| 항목 | 결과 |
|---|---|
| 컴파일 | VALID · ALL_ERRORS 0 · DMF0042 INVALID 0 |
| E2E (`e2e.py`, 원장에 없는 시험키 ZZGAP257*, 종료 시 삭제 — 잔존 0) | K1 40 `'-'` 빈값 → MPS/FCA 채움 ✅ · K2 40 `'/'` 빈값 → 채움 ✅ · K3 81 `'-'` → 미변경(40 조건) ✅ · 결과커서 SUCCESS 3/3 |
| 클라우드 패키지 리허설 | 90→99→00→10→10(SKIP)→90→99→99(SKIP)→10→90 전 단계 기대대로 · 99 후 md5 = 수정 전 · 10 후 md5 = 적용본 · 최종 상태에서 E2E 재통과 |

## 파일
- `apply.py` (plan/apply · FRESH-GATE) · `00_BACKUP_PKG_DMF0042_BODY_2026-10-14.sql`(수정 전 원문) · `_new_PKG_DMF0042_BODY.txt`
- `e2e.py` · `e2e_dupcheck.py`(범위 밖 관찰 — 시험 사이트가 Sales Site 검증에 막혀 미재현)
- 클라우드: `_artifacts/_deploy_packages/DMF0042_GAP257_BLANKFILL_CLOUD_20261015/`

## 범위 밖 관찰 (미조치 · 별건 판단 필요)
- 10-08 SLASHOBJ 로 GT 정규화가 40 DEPT_ID·END_CUSTOMER·BIZ_TYPE 를 `'/'` 로 넣는데 원장 40 은 전부 `'-'`(10-08 이후 40 저장 0건 — 원장 최종 갱신 10-01).
  "INSERT 전 중복값 삭제"(L4868~) 는 `A.DEPT_ID = NVL(B.DEPT_ID,'/')` raw 비교 → **다음 40 저장부터 기존 `'-'` 행이 지워지지 않고 `'/'` 행이 새로 생길 가능성**(81 BIZ_TYPE·ITEM_USE 도 같은 구조 — E2E K3 에서 신규 행 BIZ_TYPE `'/'` 확인). 실제 키 재현은 하지 않음.
