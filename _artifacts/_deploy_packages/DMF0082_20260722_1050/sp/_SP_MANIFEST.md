# DMF0082 SP/PKG 매니페스트 (사내 OCGSCMD_P01 실측 DDL — 2026-07-21)

> `DBMS_METADATA.GET_DDL` 전수 추출(CREATE OR REPLACE). 스키마 SCM_MGR. 배포 순서 = PKG(SPEC→BODY) 우선, standalone 순서 무관.

## PKG (필수 — 메인 조회/팝업 멤버 포함)

| 파일 | 객체 | 설명 |
|---|---|---|
| `PKG_DMF0082_SPEC.sql` | PKG_DMF0082 (SPEC) | 패키지 스펙 |
| `PKG_DMF0082_BODY.sql` | PKG_DMF0082 (BODY) | ⭐ **라이브 2026-07-14 div81 반영본**. `P_DMF0082_GET_MAIN_DATA`(메인 조회 SEARCH — 12 IN + O_RC1~O_RC5 + O_RESULT_CURSOR; drop1=M3_CUTOFF/drop4=배분달력 포함)·POPUP 멤버들. Division 40/81 분기. |

## Standalone SP (wired — API_M 배선분)

| 파일 | 버튼/용도 | 설명 |
|---|---|---|
| `DMF0082_GET_MAIN_DATA_CURRENT.sql` | FcstNPrice SEARCH_CURRENT | Current 버전 조회 |
| `DMF0082_GET_SPREAD_TITLE.sql` | spreadTitle SEARCH | 동적 시간축(월>주>일 3단) 컬럼 정의 |
| `DMF0082_SAVE_MAIN_DATA.sql` | FcstNPrice SAVE | 16 IN '^' bulk 저장(편집 M/신규 I/삭제 D) |
| `DMF0082_POPUP_GET_FUTUREPRICE_INFO.sql` | futurePriceInfo SEARCH | 환율(Exchange Rate) 팝업 조회 |
| `DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP.sql` | savePriceData SEARCH | Price 기간 일괄저장 팝업 조회(LOC 주차 PIVOT) |
| `DMF0082_POPUP_GET_SPREAD_TITLE_SAVE_PRICE.sql` | savePriceTitle SEARCH | 일괄저장 팝업 시간축(W_주차) |
| `DMF0082_EXCEL_UPLOAD.sql` | FcstNPrice UPLOAD_SAVE | Excel 업로드 저장(2-Step) |
| `DMF0082_GET_EXCEL_UPLOAD_DATA.sql` | FcstNPrice UPLOAD_DATA | Excel 업로드 검증/분류 조회 |

## 미포함 — 공유 SP (클라우드 기존재 가정, 01 API_M 배선 존재)

| SP | 용도 |
|---|---|
| `DMF0002_GET_TITLESET_POPUP` / `SCM0002_SET_TITLESET_POPUP` | titleSet 조회/저장 (Column·Measure 설정) |
| `DMF0073_GET_VERSION_SALESPRICE` | version 선택 팝업 (9-arg 공유 계약) |
| `PR_SCM_MST_EXCHANGE_RATE_UI` | 환율 IF (futurePriceInfo IF 버튼) |

## 미포함 — dev 잔재 (배포 제외)
`DMF0082_GET_MAIN_DATA_0129/0202/0203/0204/CLAUDE/AI_POC/TEST/DEL/...` 등 INVALID/실험본 다수 — **이관 대상 아님**.

## 의존 인프라 (공유 — 클라우드 기존재 가정, 본 패키지 범위 밖)
- GTT: `GT_DMF0082_*`(MF_SP / TEMP_FCST_N_PRICE / TEMP_ADMIN_GROUP_MEASURE / SP_FILTER / PJT 등, 성능 인덱스 `IX_GT82_*` 포함)
- 마스터/뷰: `SCM_SYS_CALENDAR_M`, `DM_MST_BUCKET_CONVERSION`(SalesBucket 원천), `SCM_MST_SITE`(VMI_YN), `SCM_ADM_LOOKUP_MASTER_DETAIL`
- 공유 함수/프로시저: `UP_FX_*`, `PR_SCM_SYS_LOG_BATCH`, `PR_GET_SHEET_COLUMN_LIST` 등

> ⚠ SP 재배포 시 라이브러리 캐시 배타적 락(hook #107 §4) — 접속 세션 종료 또는 `ALTER SESSION SET DDL_LOCK_TIMEOUT=30`.
