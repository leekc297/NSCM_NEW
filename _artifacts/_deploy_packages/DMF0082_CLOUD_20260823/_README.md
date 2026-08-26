> ⛔ **SUPERSEDED (2026-08-23).** 이 폴더는 `DMF0082_CLOUD_20260823_FULL` 로 대체되었다.
> FULL 은 기계 전수 스윕으로 본 폴더의 6개 메타 파일과 **행수 1:1 일치**를 교차검증했고,
> 추가로 ①감사컬럼 `'admin'` 정규화 ②`90_VERIFY` V2 마커 집계 오탐 정정(XLSWEEKLY 11→14)
> ③MSG 92코드 227행 합집합 재도출을 담았다. **적용은 FULL 폴더로 할 것.**

# DMF0082 (FCST & PRICE MGMT) 클라우드 이관 패키지 — 2026-08-23 취합

> **상태: 취합 완료 / 클라우드 미적용.**
> 본 패키지는 **누적본**이다 — `DMF0082_CLOUD_20260818` · `DMF0082_CLOUD_20260820` 두 미적용 패키지를 흡수했다.
> 두 패키지를 따로 적용할 필요 없이 **본 패키지 단독 적용**으로 사내 2026-08-23 상태와 동치가 된다.
> DB 원문은 전부 **사내 라이브 신선 덤프**(ALL_SOURCE·원장 메타, 2026-08-23 — 기존 파일 재사용 아님).
> 이관 대상 축은 **기계 전수 스윕**으로 도출했다 (손나열 금지, hook #140). 상세 = [`_INVENTORY.md`](./_INVENTORY.md).

## 1. 취합 근거 (기계 도출)

| 산출물 | 내용 |
|---|---|
| `_survey/axis_sweep_report.txt` | 스윕 원출력 — A 메타 문자열축(158 테이블 전수) / B DB 객체·의존·GTT / C MSG·LBL·MNU / D CMBO / E 시간축 / F BODY 마커 |
| `_survey/axis_sweep_result.json` | 위 스윕의 구조화 결과 (생성기 입력) |
| `_survey/collect_report.json` | 실제 산출 카운트 (파일별 statement/line 수 포함) |
| `_artifacts/_diagnostics/_dmf0082_deploy_axis_sweep.py` | 스윕 도구 (쿼리 실패 = 즉시 중단, SKIP 금지) |
| `_generate_db_files.py` | A_DB 생성기 (01·02·03·04·05·06·07·08·09·10) |

## 2. 담긴 정정 — 2026-08-20 패키지 이후 delta

| # | 정정 | 검증 마커/실측 |
|---|---|---|
| 1 | 수요 measure **DELETE 대칭화** — 40 분기의 "수량 0 = 삭제" 가 `MKT_AMT` 2종에만 적용돼 `MKT_FCST`/`VMI_In_Req`/`SCM_FCST` 는 삭제되지 않던 결함 | V3 본문 실측 |
| 2 | **DIV81 수요 행 삭제 신설** (ACTION='D') — 81 편집권한이 생긴 TO-BE 에서 행이 남던 결함 | `E20260822-DIV81DEL` 2 |
| 3 | GET 키컬럼 상시 반환 | `E20260822-KEYCOL` 2 |
| 4 | LOC 주간합계 액션 | `E20260822-LOCWEEKSUM` 1 |
| 5 | `V_PROC_INPUT` **ORA-06502** 정정 — 24 파라미터 JSON 이 4000자 초과로 SP 시작부에서 실패(저장 전멸). `rows` + 인자 50자 선절단 6지점 | V3 본문 실측 6/6 |
| 6 | 편집 콤보 ID → 메타 **`ATTRIBUTE9`** 이관 (admin UI Category Setup 에서 편집 콤보 확인 가능) | SHEET_COLUMNS |
| 7 | UI CATEGORY 보완 5행 (지식사전 v1.0 대조 — `PROJECT_CODE.ATTRIBUTE1='PROJECT'` 등) | V5b |
| 8 | `ATTRIBUTE2='ITEM_M'` 25행 제거 (소비처 0 전수 실증) | V5b |
| 9 | `CELL_PROD_SITE_ID.DIVISION_ID` → `'40'` (AS-IS 정본 대조) | V5b |
| 10 | `VERSION_NO.VISIBLE_FLAG` → `'Y'` (AS-IS 프레임워크가 플래그를 무시하고 표시하던 사실을 메타로 표현) | V5b |
| 11 | `DM_UI_EDITABLE_DIVISION` DMF0082/82 추가 | LOOKUP 21행 |
| 12 | MSG — `MSG01016` 신설(수정 중 재조회 confirm) + `MSG00703`/`MSG00718`/`MSG01023` 갱신 | V6 |
| 12b | **LBL 34종 + 메뉴 라벨 `MNU00042` 축 추가** — `SCM_ADM_MSG_M` 은 MSG/LBL/MNU 공용 원장인데 08 이 MSG 만 담고 있던 누락을 정정 (MSG/LBL/MNU 4분류 동봉 의무) | 08 파일 |
| 13 | **FE 셀 컨트롤 `FPTextModal` 신설** — 타이핑 O + 돋보기 아이콘 O (AS-IS `TextCellType`+`ImagePopUp` 파리티). DMF0082 `ITEM_ID` 소비 | `column-config.ts`/`DataGrid.tsx`/`dataGridUtils.ts` + admin 콤보 `ColumnControlType` |
| 14 | 공용 `ColumnLayoutModal` 보완 + zeroWidth 회귀 테스트 | B_FE shared |
| 15 | 화면 FE 7파일 변경 (Form/Grid/ForecastPrice/SavePricePeriodModal/constants/ForecastTemplateModal/`__asis-mapping__`) | B_FE forecast-price |

> 0818·0820 세대분(Excel 주간 업로드·81 LOC 전용·SENDER 병합·GTT 선적재 성능·Project 명 조인·동시편집 제약·저장 성능 407s→0.016s·센티널 스키마 전환·AS From Site NULL·titleset BE 복원)은 **모두 본 패키지에 포함**되어 있다 (BODY 전체 교체 + 메타 전량 재적재).

## 3. ⛔ 적용 게이트 (00_CLOUD_PRECHECK C4)

BODY 는 센티널 변형(`' '`/`'-'`/`'--'`/CHR(0)) 동일 처리가 **삭제된** 본문이다. 클라우드 원장
(`DM_PLN_CFM_MKT_DEMAND_PLAN` / `DM_PLN_CFM_SELLING_PRICE` / `SCM_MST_FUTURE_PRICE`)에 변형이 실재하면
조회 dedup·저장 MERGE 키가 갈라져 **중복/누락이 재발**한다 (사내는 140만 행 실재 → 2026-08-20 정리 완료).

C4 결과 `VARIANTS > 0` 이면:
1. `A_DB/02`(BODY) · `A_DB/03B`(DDL) 적용 **보류**
2. 데이터 정리(사내 절차 `_artifacts/_apply_corporate/DMF0082_SENTINEL_20260820/01_BACKUP.sql` + `02_DEDUP_NORMALIZE.sql` — 사용자 지시로 **본 패키지 미동봉**)를 클라우드 DBA 와 협의·선행
3. 변형 기록 배치(EXCHANGE_RATE / BATCH_CFM_TO_ALL / BALANCE_MAKE 계열) `'-'` 정규화 반영 확인

## 4. 파일 구성 / 적용 순서

```
00_CLOUD_PRECHECK.sql          C1 마커세대 / C2 GTT 47종 / C3 DEFAULT_ON_NULL / C4 ⛔변형 게이트
                               C5 의존객체 15 / C6 미동봉 공유CMBO 24 / C7 권한그룹 / C8 baseline / C9 MSG 채번충돌
A_DB/03_DDL_GTT_DMF0082.sql    DMF0082 전용 GTT 33종 + 인덱스 (멱등 -955 가드)
A_DB/03B_DDL_DEFAULT_ON_NULL.sql  원장 4본 + GT_PRDM1_T_MAIN 키 DEFAULT ON NULL '-' (GTT ALTER 는 BE 유휴 시점)
A_DB/01_PKG_DMF0082_SPEC.sql   94줄
A_DB/02_PKG_DMF0082_BODY.sql   14,755줄 ⭐ 본문 전체 교체 (C4 게이트 통과 후!)
A_DB/04_CMBO_SYNC.sql          24 MERGE (전용 + 08-04 이후 변경 공유 + admin ColumnControlType)
A_DB/05_SHEET_META_SYNC.sql    시트 2본 전량 재적재 (FcstNPrice 65 + Sales Price Save All 25)
A_DB/06_SHEET_MEASURE_SYNC.sql 22행 전량 재적재
A_DB/07_EXCEL_META_SYNC.sql    EXCEL_COLUMNS 1행
A_DB/08_MSG_SYNC.sql           SCM_ADM_MSG_M **INSERT-only(NOT EXISTS)** — MSG 41 + LBL 34 + MNU 1 = 76종 / 227행
A_DB/09_PROC_API_BTN_AUTH_SYNC.sql  PROGRAM 1 / MNU 1 / API 17 / PROC 123 / BTN 18 / 권한 6+100
A_DB/10_LOOKUP_SYNC.sql        LOOKUP_MASTER_DETAIL 21행 (NULL-safe ON)
A_DB/90_VERIFY.sql             V1~V10 기대값 단언 + 런타임 스모크 6종
B_FE/forecast-price/           화면 폴더 **전체** (부분 이관 금지 — resolveView 사고 계보)
                               ⚠ 삭제 파일: utils/forecast-price.excelForm.test.ts — 클라우드에서 제거
B_FE/foundation/               → packages/foundation/src/constants/column-config.ts (⭐FPTextModal)
                                 packages/foundation/src/utils/mergeManager.ts
B_FE/shared/                   → packages/shared/src/... (stores/useDirtyRegistry.ts,
                                 components/organisms/{index.ts,data-grid/*,olap-pivot-grid/*},
                                 components/molecules/customDropdown/CustomDropdown.tsx,
                                 components/templates/modals/column-layout-modal/*)
B_FE/master/                   → features/master/src/components/{columnLayoutModal(스텁 2),searchFields/*}
B_FE/configs-types/            → nscm-fe/configs/types/procedures.d.ts
C_BE/admin-menu/               → nscm-be .../admin/menu/{MenuController,MenuService,MenuServiceImpl}.java
                                 + resources/sql/admin/Menu.xml (공용 titleset 엔드포인트)
```

**적용 순서**
1. `00_CLOUD_PRECHECK.sql` (QA/DEV 각각) — **C4 변형 0 확인이 02 적용의 전제**
2. `A_DB/03` → `A_DB/03B` (DDL) → `A_DB/01` → `A_DB/02` (각각 단독 실행)
3. `A_DB/04` ~ `A_DB/10` (메타·배선·권한)
4. `B_FE` 폴더 교체(삭제 파일 포함) + `C_BE` 4파일 → 빌드·재기동
5. `A_DB/90_VERIFY.sql` + V10 런타임 스모크 6종

## 4-1. 메타 적용 방식 (파일별 의도 — 혼동 금지 / 사용자 확정 2026-08-23)

| 파일 | 방식 | 이유 |
|---|---|---|
| `08_MSG_SYNC.sql` | **INSERT-only (`INSERT ... SELECT ... FROM DUAL WHERE NOT EXISTS`)** | 사용자 지정. MSG/LBL/MNU 코드는 화면 간 공유 자산 — 한 화면 기준으로 문구를 덮으면 타 화면이 조용히 오표기된다. 기존재 코드는 건드리지 않고, 차이는 V6b 로 뽑아 별도 판단 |
| `04`/`09`/`10` | MERGE (UPSERT) | 화면 소유 배선·권한·룩업 — 사내 정본이 기준값. **사용자 확정 2026-08-23**: INSERT-only 로 바꾸면 콤보 SQL 갱신 12본(EndCustomerByDivisionDMF0082·FcstType 2본·ColumnControlType 등)이 클라우드에 미반영되어 결함이 재현되므로 MERGE 유지 |
| `05`/`06`/`07` | DELETE(범위 한정) + INSERT 전량 | 시트 메타는 행 집합 자체가 정본 (hook #98 §9 — 삭제 범위 = 삽입 범위) |

## 5. ⚠ 공유 자산 경고

| 자산 | 영향 범위 | 판단 |
|---|---|---|
| CMBO 12종 (`SalesSite`·`TeambyDivision`·`BucketType`·`EndCustomerByDivision*`·`UserSiteByEndCustomer` 등) | FE 전수 grep 실측 — 타 화면 조회조건에서 사용 (04 파일 헤더에 소비처 병기) | 사내 정본으로 덮음. 의도 확인 후 적용 |
| `ColumnControlType` (admin) | UI Category Setup 셀컨트롤 목록 — 전 화면 admin 공용 | `FPTextModal` 신설값 때문에 **필수 동봉** |
| `B_FE/shared/*`, `B_FE/foundation/*`, `B_FE/master/*` | 전 화면 공용 컴포넌트 | DMF0082 가 의존 — 미이관 시 **빌드 실패** 또는 셀 동작 회귀 |
| `C_BE/admin-menu/*` | 전 화면 Grid Column Setting 모달 | 미이관 시 **전 화면 컬럼 목록 빈 목록** |
| `SCM_MST_SHEET_COLUMNS` 시트 `Sales Price Save All` | 동명 SHEET_NAME 보유 PROGRAM_ID 2종 실측 | DELETE 는 `PROGRAM_ID='DMF0082'` 로 한정 — 타 프로그램 행 무영향 |

## 6. 미해결 / 범위 밖

- 사내 원장 미등록 **16종** — MSG 6종(`MSG00079`/`00133`/`00259`/`00449`/`00456`/`00464`) + LBL 10종(`LBL00501`·`00502`·`00505`~`00508`·`00510`~`00513`). FE 참조는 있으나 `SCM_ADM_MSG_M` 행 없음(fallback 문구 표시). 선재 결함, 별도 채번 필요.
- `LBL00111` 은 사내 원장에 **2개 언어(KO/EN)** 만 있음 — CN 누락. 90_VERIFY V6b 로 노출.
- 원장 데이터 정리(중복 삭제·`'-'` 정규화) 는 사용자 지시로 **미동봉** — C4 게이트로 판단.
- 공용 GTT 14종(`GT_PRDM1_*`, `GT_DMF0003_*`)은 타 패키지 소관 — C2 로 존재 확인만.
- **GTT 수량 컬럼 `NUMBER(20,10)` 23컬럼 잔존** (표준 `NUMBER(30,10)`) — 사내 현행 그대로 이관. 교정은 별도 결정이며 기존재 GTT 는 `-955` skip 으로 반영되지 않는다(REBUILD 필요). 상세 = `_INVENTORY.md` D7.
