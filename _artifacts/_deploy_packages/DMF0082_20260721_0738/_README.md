# DMF0082 (Fcst&Price MGMT) — 클라우드 전체 이관 패키지

> **신규 이관 기준 전체 취합** — FE 화면 전체 + DB 메타 전량(사내 OCGSCMD_P01 실측) + SP/PKG DDL.
> 클라우드 환경에서 DMF0082 를 **처음부터 배포**할 수 있도록 자급 구성. (2026-07-20~21 보완분 포함)

- 화면 ID: **DMF0082** (Fcst & Price MGMT / 소형사업부 FCST+PRICE 통합) · 도메인 `demand` · slug **`forecast-price`**
- Division **40 전용**(+ 81 분기 SP 보유) · 원장 = `DM_PLN_CFM_*`(40) / `DM_PLN_MKT_FCST`·`SCM_MST_FUTURE_PRICE`(81)
- 근거: `Doc/화면분석서/DMF0082_FcstNPrice_UI분석서_v2.3.xlsx` + `주요이벤트/제약매트릭스_상세.md` + FE `__asis-mapping__.md`

---

## 1. 패키지 구성 (fe 24 + sql 7 + sp 10)

```
DMF0082_20260721_0738/
├── fe/features/demand/src/pages/forecast-price/   ← 화면 전체 24파일 + __asis-mapping__.md
│   ├── ForecastPrice.tsx / index.ts / *.constants.ts / *.types.ts / useForecastPriceStore.ts (+ .test)
│   ├── components/  (ForecastPriceForm, ForecastPriceGrid, ForecastPriceGridUtils + modals 4종)
│   └── utils/       (api / editLock / save / validate)
├── sql/                                           ← DB 메타 전량 (멱등 MERGE, 사내 실측)
│   ├── 01_DMF0082_menu_api_button.sql             MNU_M 1 / MNU_BTN_MPG 14 / API_M 14
│   ├── 02_DMF0082_proc_m.sql                      PROC_M 123 (DMF0082 SP + PKG 멤버 시그니처)
│   ├── 03_DMF0082_sheet_columns_measure.sql       SHEET_COLUMNS 69 / SHEET_MEASURE 14 (2 sheet)
│   ├── 04_DMF0082_authority.sql                   USER_GR_MNU 3 / USER_GR_BTN 38
│   ├── 05_DMF0082_combo.sql                       CMBO_SQL_M 25 (⭐ SalesBucket·FcstPriceEditMeasure 신규 포함)
│   ├── 06_DMF0082_message.sql                     MSG_M 66 (22 ID × KO/EN/CN)
│   └── 07_DMF0082_lookup.sql                      LOOKUP_MASTER 1 / DETAIL 24 (DM_UI_EDITABLE_MEASURE)
├── sp/                                            ← SP/PKG DDL (CREATE OR REPLACE, 사내 실측)
│   ├── PKG_DMF0082_SPEC.sql / PKG_DMF0082_BODY.sql  (⭐ 라이브 div81 반영본 — P_DMF0082_GET_MAIN_DATA 등 멤버)
│   ├── DMF0082_GET_MAIN_DATA_CURRENT / _GET_SPREAD_TITLE / _SAVE_MAIN_DATA
│   ├── DMF0082_POPUP_GET_FUTUREPRICE_INFO / _..._SAVE_PRICE_POPUP / _GET_SPREAD_TITLE_SAVE_PRICE
│   ├── DMF0082_EXCEL_UPLOAD / _GET_EXCEL_UPLOAD_DATA
│   └── _SP_MANIFEST.md
├── _README.md
└── _COMMON_FILES_GUIDE.md
```

> 메타 총 **370행** 전수 export (12 테이블). SP **10 객체**(PKG spec+body + standalone 8).
> ⚠ **공유 SP 4종은 미포함(클라우드 기존재 가정)**: `DMF0002_GET_TITLESET_POPUP`·`SCM0002_SET_TITLESET_POPUP`(titleSet), `DMF0073_GET_VERSION_SALESPRICE`(version), `PR_SCM_MST_EXCHANGE_RATE_UI`(환율 IF). 01 API_M 에는 배선 존재.

## 2. 2026-07-20~21 보완분 (전체에 이미 반영됨)

최신분석(2026-07-20 화면분석서) 기준 배분/잠금 정합 + 캐스케이드 12갭 + #7. 상세 = `Doc/_archive/work_reports/2026-07-20_DMF0082_fcstprice_보완.md`. 핵심:
- **배분 정합(FE)**: #1 월배분 달력기반(GET drop4) / #3 LOC 월평균 / #2 SALES_BUCKET 캐스케이드 + **요일비트 SUN-first 교정** / #4 M+4 월잠금(GET drop1) / #5 SCM_FCST×RMA
- **UX/편집(FE)**: #9 Insert 시드10키 / #10 실시간중복 MSG00260 / #11 NOTATION 소수3 / #12 당주 녹색보더 / #13 버킷가드 MSG00227 / #14 Daily 정수절삭 / #7 Insert 편집가능 Measure 캐스케이드
- **DB 신규 콤보 2종(05 포함)**: `SalesBucket`(DM_MST_BUCKET_CONVERSION, SUN-first) · `FcstPriceEditMeasure`(DM_UI_EDITABLE_MEASURE, div/site/bucket) — 사내 적용·probe 검증 완료
- **PKG 무변경**: 본 세션은 PKG_DMF0082 미수정(라이브 = 2026-07-14 div81 반영본 그대로 export)
- **보류/한계**: #6 SSP 비교 팝업 = 사용자 보류(ATTR1 마커 부재 — 라이브 핵심 SP 개조 필요) / #8 붙여넣기 1행→N행 = Wijmo whole-range paste 이벤트 부재(플랫폼 한계, 자매 mkt-fcst 동일)

## 3. 적용 순서 (클라우드 — 신규 배포)

### Step 1. 브랜치
```
git checkout -b feat/dmf0082-full-transfer-20260721
```

### Step 2. SP/PKG 배포 (SCM_MGR) — 의존 인프라 선행
```
sqlplus SCM_MGR/**@{dsn} @sp/PKG_DMF0082_SPEC.sql
sqlplus SCM_MGR/**@{dsn} @sp/PKG_DMF0082_BODY.sql
for f in sp/DMF0082_*.sql; do sqlplus SCM_MGR/**@{dsn} @$f; done
```
- ⚠ SP 재배포 세션 pin hang(hook #107 §4) 주의 — 접속 종료 후 또는 `ALTER SESSION SET DDL_LOCK_TIMEOUT=30`.
- 컴파일 오류 시 의존 객체(GTT `GT_DMF0082_*`, 공유 뷰/함수 `UP_FX_*`, `SCM_SYS_CALENDAR_M`, 마스터 `DM_MST_BUCKET_CONVERSION`·`SCM_MST_SITE`) 우선 확인 — 본 패키지 범위 밖(공유·마스터 인프라, 클라우드 기존재 가정).
- VALID 검증: `SELECT object_name,status FROM all_objects WHERE object_name LIKE 'DMF0082%' OR object_name='PKG_DMF0082';`

### Step 3. DB 메타 등록 (01→07 순서)
```
for n in 01 02 03 04 05 06 07; do sqlplus SCM_MGR/**@{dsn} @sql/${n}_DMF0082_*.sql; done
```
- 전부 멱등 MERGE — 재실행 안전, 기존 값은 정합.
- ⚠ **audit 컬럼 = 'admin'** 정합(hook #98). 신규 콤보 2종은 05 에 포함(재실행 시 값 갱신).

### Step 4. FE 파일 복사 (전체 폴더)
```
robocopy fe\features\demand\src\pages\forecast-price {repo}\nscm-fe\features\demand\src\pages\forecast-price /E
```

### Step 5. 공통 파일 patch (`_COMMON_FILES_GUIDE.md`) — Router/route-paths/MNU_URL 3-SET slug(`forecast-price`) 확인

### Step 6. 빌드 (`type-check && lint && build`) → Step 7. 브라우저 동작 검증 (§4 시나리오)

## 4. 트러블슈팅
- "빈 결과" → 02 PROC_M 미적용(SP positional 불일치) / SP INVALID / GTT·마스터 부재
- "No Permission"(-9994) → 04 권한 2테이블 미적용 / 로그인 그룹 미배정
- "API not found" → 01 API_M·BTN_MPG 미적용 / 공유 SP 4종 미존재
- Grid 컬럼 빈 상태 → 03 SHEET_COLUMNS 미적용
- Measure/콤보 코드 표시 → 05 CMBO 미적용 또는 FE mnuId 전달 누락
- **Insert 배분요일 항상 월요일** → 05 `SalesBucket` 미적용 or `DM_MST_BUCKET_CONVERSION` 데이터 부재
- **Insert Measure 콤보 미필터** → 05 `FcstPriceEditMeasure` + 07 `DM_UI_EDITABLE_MEASURE`(SEGMENT1='DMF0082') 미적용
- **월 배분 수량 이상 / LOC 월합 이상** → SP GET drop4(달력)·drop1(M3_CUTOFF) 커서 미반환(구 PKG) — sp/PKG_DMF0082_BODY 재배포 확인

## 5. E2E 검증 시나리오 (div40)
1. 조회 → 월(M_) 편집 시 달력 기반 배분(주=Truncate(월합/월일수)×주일수), 월잔량 가산
2. LOC 주간 편집 → 월(M_) = 값 있는 주차 **평균**
3. Insert → Site/Incoterms 변경 시 배분 요일 반영(SALES_BUCKET) + Measure 콤보가 편집가능분으로 좁혀짐
4. MKT/SCM/VMI 월셀 M+3 이하 잠금 / SCM_FCST+RMA 잠금
5. 저장 → 재조회 **SUM 불변**(SUN-first 교정 회귀 확인)

## 6. 메타데이터
- 작성: Claude Opus 4.8 (2026-07-21) · 룰: 22_PACKAGE_ARTIFACTS / hook #105 / feedback_migration_folder_naming
- 검증: FE tsc 0 · 사내 메타/SP 전수 실측 export(370행/10 객체) · regression-impact Hard Boundary 0 · 신규 콤보 probe 검증
- ⚠ SP/공유콤보/공유lookup/마스터데이터 = AS-IS·공유 자산 — 클라우드에 이미 있으면 MERGE/CREATE OR REPLACE 가 현행 정합(무해)
