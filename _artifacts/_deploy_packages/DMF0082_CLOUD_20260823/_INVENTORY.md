# DMF0082 클라우드 이관 대상 인벤토리 — 2026-08-23 (기계 전수 스윕 실측)

> 도출 방법: `_artifacts/_diagnostics/_dmf0082_deploy_axis_sweep.py` (사내 라이브 접속, 2026-08-23)
> — 손나열 금지 룰(hook #140 deploy-axis-sweep-mandatory) 준수. 원자료 = `_survey/axis_sweep_result.txt|json`, 산출 실측 = `_survey/collect_report.json`.
> 스윕 범위: `SCM_ADM_%` / `SCM_MST_%` / `DM_ADM_%` **158 테이블 × 전 문자열 컬럼** `LIKE '%DMF0082%'` + DB 객체 이름/의존 + FE·BODY 코드 추출.

---

## A. 요약 — 이관 대상 / 제외 판정

| 축 | 대상 | 실측 | 산출물 | 판정 |
|---|---|---:|---|---|
| DB 객체 | `PKG_DMF0082` SPEC / BODY | 94줄 / 14,755줄 | `A_DB/01`, `A_DB/02` | ✅ 전체 교체 |
| DB 객체 | DMF0082 전용 GTT + 인덱스 | 33 + 1 | `A_DB/03` | ✅ 멱등 DDL |
| DB 객체 | 공용 GTT (`GT_PRDM1_*`, `GT_DMF0003_*`) | 14 | — | ⛔ 제외 (타 패키지 소관) → PRECHECK **C2** 존재확인 |
| DDL | 원장 4본 + `GT_PRDM1_T_MAIN` `DEFAULT ON NULL '-'` | 12/12/13/11/13 | `A_DB/03B` | ✅ (0820 패키지분 승계) |
| 메타 | `SCM_MST_SHEET_COLUMNS` | 90행 (FcstNPrice 65 + Sales Price Save All 25) | `A_DB/05` | ✅ 시트 단위 전량 재적재 |
| 메타 | `SCM_MST_SHEET_MEASURE` | 22행 | `A_DB/06` | ✅ 전량 재적재 |
| 메타 | `SCM_ADM_EXCEL_COLUMNS` | 1행 | `A_DB/07` | ✅ 재적재 |
| 메타 | `SCM_ADM_CMBO_SQL_M` | 소비 47종 중 **23본 + admin `ColumnControlType` 1본 = 24본 동봉** | `A_DB/04` | ✅ 동봉 / ⚠ 24종은 존재확인만(C6) |
| 메타 | `SCM_ADM_MSG_M` (MSG/LBL/MNU 공용 원장) | 스캔 MSG 47 + LBL 44 + MNU 1 중 **76종 / 227행** (MSG 41 · LBL 34 · MNU 1) | `A_DB/08` | ✅ **INSERT-only(NOT EXISTS)** — 사내 미등록 16종 제외 |
| 배선 | `SCM_ADM_PROC_M` | 123행 | `A_DB/09` | ✅ |
| 배선 | `SCM_ADM_API_M` | 17행 | `A_DB/09` | ✅ |
| 배선 | `SCM_ADM_MNU_M` / `SCM_ADM_PROGRAM` | 1 / 1 | `A_DB/09` | ✅ |
| 배선 | `SCM_ADM_MNU_BTN_MPG_M` | 18행 | `A_DB/09` | ✅ |
| 권한 | `SCM_ADM_USER_GR_MNU_MPG_M` | 6행 | `A_DB/09` | ✅ ⚠ 그룹 실존 확인(C7) |
| 권한 | `SCM_ADM_USER_GR_MNU_BTN_MPG_M` | 100행 | `A_DB/09` | ✅ ⚠ 동일 |
| 메타 | `SCM_ADM_LOOKUP_MASTER_DETAIL` | 21행 | `A_DB/10` | ✅ NULL-safe MERGE |
| FE | `forecast-price` 화면 폴더 | 32 파일 | `B_FE/forecast-price/` | ✅ **폴더 전체** |
| FE | 공용 의존 파일 | 18 파일 | `B_FE/{foundation,shared,master,configs-types}/` | ✅ ⚠ 공유 |
| BE | admin/menu titleset 4파일 | 4 | `C_BE/admin-menu/` | ✅ (공용 복원분 승계) |

---

## B. 제외 대상과 사유 (기계 스윕에는 잡혔으나 이관하지 않음)

| 테이블/자산 | 실측 | 제외 사유 |
|---|---:|---|
| `SCM_MST_TITLESET_USER` | 349행 | **사용자 개인화 데이터** — 이관 제외 표준 (환경별 사용자 상이) |
| `SCM_ADM_EXCEL_UPLOAD` | 163행 (08-20 이후 86) | Excel 업로드 **스테이징 실행 데이터** (메타 아님) |
| `SCM_ADM_LOOKUP_MASTER_DETAIL_H` | 1행 | 이력 테이블 — 본체(`_DETAIL`)만 이관 |
| `SCM_ADM_CMBO_SQL_M_BK20260821`, `..._BK20260821_FN` | 각 7행 | 사내 작업 백업 테이블 |
| `SCM_MST_SHEET_COLUMNS_0408`, `_260408` | 각 69행 | 구 스냅샷 백업 |
| `BAK_DMF0082_*` 5본, `ADM_PROC_M_BAK_*`, `SHEET_*_BAK_*`, `TITLESET_USER_BAK_*`, `DROP_RUN_*` | 9 객체 | 사내 정정 작업 백업/폐기 객체 |
| 원장 데이터 (`DM_PLN_CFM_*`, `SCM_MST_FUTURE_PRICE`) 정리 UPDATE | 101만행 삭제 / 44.5만행 정규화 | 2026-08-20 사용자 지시로 **데이터 UPDATE 제외** 유지 — 클라우드는 PRECHECK **C4** 게이트로 판단 |
| 공유 CMBO 24종 | — | 클라우드 기존재 가정. 덮어쓰기 부작용 방지 → C6 존재확인만 |

---

## C. 2026-08-20 패키지 이후 delta (본 패키지가 새로 담는 것)

> 직전 취합본 `DMF0082_CLOUD_20260820` 대비. **0818·0820 둘 다 클라우드 미적용**이므로 본 패키지는 **둘을 흡수한 누적본**이다.

| # | 정정 | 축 | 근거(마커/실측) |
|---|---|---|---|
| 1 | 수요 measure DELETE 대칭화 (`MKT_FCST`/`VMI_In_Req`/`SCM_FCST` — 0 저장 시 행 삭제) | BODY | 마커 없음 → V3 본문 실측 (DELETE measure 목록 5종) |
| 2 | DIV81 수요 행 삭제 신설 (ACTION='D') | BODY | `E20260822-DIV81DEL` 2 |
| 3 | GET 키컬럼 상시 반환 | BODY | `E20260822-KEYCOL` 2 |
| 4 | LOC 주간합계 액션 | BODY | `E20260822-LOCWEEKSUM` 1 |
| 5 | `V_PROC_INPUT` ORA-06502 정정 (rows + 인자 50자 선절단 × 6지점) | BODY | V3 본문 실측 6/6 |
| 6 | 편집 콤보 ID → 메타 `ATTRIBUTE9` 이관 (UI Category Setup 노출) | SHEET_COLUMNS | 08-21 |
| 7 | UI CATEGORY 보완 5행 (PROJECT_CODE.ATTRIBUTE1='PROJECT' 등) | SHEET_COLUMNS | 08-21 (지식사전 v1.0 대조) |
| 8 | `ATTRIBUTE2='ITEM_M'` 25행 제거 (소비처 0 실증) | SHEET_COLUMNS | 08-22 |
| 9 | `CELL_PROD_SITE_ID.DIVISION_ID` → `'40'` (AS-IS 정본) | SHEET_COLUMNS | 08-22 |
| 10 | `VERSION_NO.VISIBLE_FLAG` → `'Y'` (AS-IS 화면 파리티) | SHEET_COLUMNS | 08-22 |
| 11 | `DM_UI_EDITABLE_DIVISION` DMF0082/82 추가 | LOOKUP | 08-21 17:33 |
| 12 | MSG 08-21 갱신 3종 (`MSG00703`/`MSG00718`/`MSG01023`) + `MSG01016` 신설 | MSG | 08-21 14:10 |
| 13 | **FE 셀 컨트롤 `FPTextModal` 신설** — 텍스트 입력 + 모달(돋보기) 동시 허용 (AS-IS `TextCellType`+`ImagePopUp` 파리티) | FE 공용 3파일 | `column-config.ts` / `DataGrid.tsx` / `dataGridUtils.ts` (08-22) |
| 14 | 공용 `ColumnLayoutModal` 보완 (+ zeroWidth 회귀 테스트 신설) | FE 공용 | 08-22 13:49 |
| 15 | `useDirtyRegistry` 재조회 confirm `MSG00703` → `MSG01016` | FE 공용 | 08-21 |
| 16 | 화면 FE 7파일 변경 (Form/Grid/ForecastPrice/SavePricePeriodModal/constants/ForecastTemplateModal/`__asis-mapping__`) | FE | 0820본 대비 diff |

> BODY 총 diff (0820본 → 0823본) = **229줄**. 마커 30계보 / BODY 14,753줄(덤프 14,755줄).

---

## D. 열린 항목 (적용 판단 필요)

| # | 항목 | 상태 |
|---|---|---|
| D1 | **⛔ C4 센티널 게이트** — 클라우드 원장 `PLANT_SITE_ID` 변형이 0 이어야 02(BODY)·03B(DDL) 적용 가능 | 클라우드 실측 필요 |
| D2 | 사내 원장 미등록 **16종** — MSG 6(`MSG00079`/`00133`/`00259`/`00449`/`00456`/`00464`) + LBL 10(`LBL00501`·`00502`·`00505`~`00508`·`00510`~`00513`). FE 참조는 있으나 행 없음 → fallback 문구 표시. 추가로 `LBL00111` 은 KO/EN 2개 언어만(CN 누락) | 선재 결함, 본 패키지 범위 밖 (별도 채번 필요) |
| D3 | 공유 CMBO **12종**은 그리드 메타 소비화면이 0~1 이라 '전용'으로 분류됐으나, FE 전수 grep 결과 **타 화면 조회조건에서 사용 중** (`SalesSite` 12, `TeambyDivision` 9, `BucketType` 7 …). 04 파일 헤더에 실측 병기 — 사내 정본으로 덮는 것이 의도인지 확인 후 적용 | 확인 필요 |
| D4 | `ColumnControlType`(admin UI Category Setup 셀컨트롤 목록) 08-22 00:36 변경 — DMF0082 `ITEM_ID` 가 신설값 **`FPTextModal`** 을 쓰므로(SHEET_COLUMNS 실측) **동봉 필수**로 판정·추가함. 공용 콤보라 타 화면 admin 화면에도 신설값이 노출됨(의도) | ✅ 04 에 동봉 |
| D5 | 권한 행 106건(그룹 6종)은 사내 그룹 체계 기준 — 클라우드 그룹 상이 시 고아 | C7 로 판정 |
| D6 | `_artifacts/_apply_corporate/DMF0082_SENTINEL_20260820/02_DEDUP_NORMALIZE.sql` (데이터 정리) 는 사용자 지시로 **미동봉** 유지 | 클라우드 DBA 협의 |
| D7 | **GTT 수량 컬럼 `NUMBER(20,10)` 잔존 23컬럼** (`GT_DMF0082_MF_SP` 15 / `TEMP_FCST_N_PRICE` 4 / `FCST_N_PRICE`·`SITE_ITEM`·`MST_ITEM_SINGLE_*` 각 1 — CELL_QUANTITY·CELL_PER_CAR·MON~SUN 등 수량 계열). 표준은 `NUMBER(30,10)`(hook: 백억 이상에서 ORA-01438 — DMF0082 클라우드 61.8B 실사고 계보). 본 패키지는 **사내 현행 그대로** 이관하며(정본 보존), 정밀도 교정은 별도 결정 사항. ⚠ 기존재 GTT 는 -955 skip 이라 교정이 반영되지 않음 — 교정 시 `00A_GTT_REBUILD` 필요 | 별도 판단 |
