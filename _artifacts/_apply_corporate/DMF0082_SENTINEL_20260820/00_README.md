# DMF0082 센티널 무결성·속도 개선 (2026-08-20) — 승인 대기

> 목표(사용자 지시): 저장 경로 테이블 키 컬럼을 `DEFAULT ON NULL '-' NOT NULL` 로 스키마 강제하고,
> PKG_DMF0082 의 NVL('-') 처리(35곳)와 변형(' '/'-'/'--') 동일 처리(8개 문장)를 삭제한다.

## 실측 요약 (2026-08-20 사내)

| 테이블 | 총행 | PLANT_SITE_ID 변형 | 정규화 시 중복 그룹(행) | 활성 기록자(최근) |
|---|---:|---:|---|---|
| DM_PLN_CFM_MKT_DEMAND_PLAN | 385,192 | ' ' 114,306 | 71,909 (143,818) | BALANCE_MAKE·SYSTEM (08-17) |
| DM_PLN_CFM_MKT_DEMAND_PLAN_H | 38,979 | 0 | — | — |
| DM_PLN_CFM_SELLING_PRICE | 1,651,396 | CHR(0) 539,853 + '--' 305,082 | 360,675 (942,069) | EXCHANGE_RATE (08-18) |
| SCM_MST_FUTURE_PRICE | 1,737,631 | '--' 246,531 + CHR(0) 185,841 | 185,550 (542,436) | SYSTEM·BATCH_CFM_TO_ALL (08-18) |

- 변형은 전부 **PLANT_SITE_ID 단일 컬럼**에서만 발견 (다른 12 키 컬럼 변형 0 — 전수 스캔).
- GT_PRDM1_T_MAIN 은 PKG_DMF0082 단독 소비 (DBA_DEPENDENCIES 실측) — GTT DDL 안전.

## ⛔ 차단 리스크 (동일 처리 삭제의 전제)

**배치 3계열(EXCHANGE_RATE / BATCH_CFM_TO_ALL / SYSTEM·BALANCE_MAKE)이 지금도 변형을 쓴다.**
데이터만 정리하고 PKG 동일 처리를 삭제하면 다음 배치 실행 시 변형이 재유입되어
DMF0082 조회 dedup·저장 MERGE 키가 다시 갈라진다 (c3669d9 3배 중복 사고 재발).
→ 순서: **배치 기록 SP 정규화(또는 원장 CHECK 제약) → 데이터 정리 → DDL → PKG 삭제** 가 안전.

## 사용자 결정 필요 3건

1. **중복 생존자 규칙**: 정규화 키 충돌 그룹(최대 94만 행)에서 남길 1행 =
   제안: `NVL(LAST_UPDATE_DATE,CREATION_DATE)` 최신 → 동률 시 shape 우선순위('-'>'--'>CHR0>' ') → ROWID.
   (조회 dedup 의 기존 확정 규칙은 "QTY 최대"였음 — 원장 삭제에는 최신 우선을 권고)
2. **배치 기록 SP 수정 포함 여부**: EXCHANGE_RATE/CFM_TO_ALL/BALANCE_MAKE 계열 SP 를 찾아
   PLANT_SITE_ID 기록을 '-' 정규화. (미포함 시 PKG 동일 처리 삭제는 보류 권고)
3. **감사컬럼 제외 확인**: CREATED_BY/LAST_UPDATED_BY (SELLING/FUTURE 에서 NOT NULL) 는
   DEFAULT ON NULL '-' **제외** 권고 — 넣으면 감사키 미전달 결함(ORA-01400 검출 계보)이 은폐됨.

## 파일

- `01_BACKUP.sql` — CTAS 백업 3본 (BAK0820_*)
- `02_DEDUP_NORMALIZE.sql` — 중복 삭제 + PLANT_SITE_ID '-' 정규화 (결정 1 반영본)
- `03_DDL_DEFAULT_ON_NULL.sql` — 원장 4본 키 컬럼 DEFAULT ON NULL + GTT 13 컬럼 NOT NULL 승격
- PKG 삭제 대상 인벤토리(적용은 위 전제 충족 후): NVL(키,'-') 35곳 /
  변형 동일 처리 8문장 (L3181·L5483-5486·L5511·L5534-5537·L5558·L5577·L11814-11817·L12417-12420) /
  GT_PRDM1_T_MAIN NVL 정규화 UPDATE (L13560-13578)

## 90_VERIFY (적용 후)

변형 재스캔 0 / 중복 그룹 0 / PKG 컴파일 VALID / DMF0082 조회·저장·Excel Upload 스모크 / 익일 배치 후 변형 재스캔 0.
