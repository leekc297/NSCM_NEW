# DMF0082 (Fcst&Price MGMT) — AS-IS ↔ TO-BE 매핑 (2026-07-12 신규 생성)

> AS-IS: `DMF0082_FcstNPrice_Mgmt.cs` 8,295줄 + Designer 1,293줄 + 전용팝업 `DMF0082_SaveSalesFuturePrice_Popup.cs` 2,414줄(+Designer 890).
> 분석 md 9종은 Phase A "추정"이라 **실소스 실측이 본 매핑의 정답 기준** (xlsx 분석서·통합 매트릭스에 DMF0082 없음).

## 1. 조회조건 (Designer 15 컨트롤 → 카탈로그+인라인)

| # | AS-IS | TO-BE | 상태 |
|---|---|---|---|
| 1 | clbDivision | DivisionField (카탈로그) | ✅ |
| 2 | clbTeam | TeamField | ✅ |
| 3 | clbCustomer | EndCustomerField | ✅ |
| 4 | clbBizType | BizTypeField | ✅ |
| 5 | clbSalesSite | SalesSiteField | ✅ |
| 6 | drpPeriod | PeriodField | ✅ |
| 7 | txtItemId+btnItemId | ItemField (팝업) | ✅ |
| 8 | txtVersion+btnVersion | VersionField + VersionSelectModal | ✅ |
| 9 | cboBucketType (D/W/M) | 인라인 CustomDropdown (BucketType CMBO+fallback) | ✅ |
| 10 | cboQty | Qty ≥ 0 체크박스 (LBL00689) | ✅ |
| 11 | chkSum | Sum 체크박스 (LBL00687) | ✅ |
| 12 | btnExchangeRate | 커스텀버튼 → ExchangeRateModal | ✅ |
| 13 | btnSavePricePeriod | 커스텀버튼 → SavePricePeriodModal | ✅ |
| 14 | btnMeasure | 커스텀버튼 → MeasureSelectModal (titleSet 'M') | ✅ |
| 15 | btnColumn | 커스텀버튼 → ColumnSettingModal (공용, titleSet 'C') | ✅ |

## 2. 버튼 (CRUD 5 + Aux)

| AS-IS override | TO-BE | 상태 |
|---|---|---|
| FindButton(:671) | hotkeyConfig.search (V1~V4 검증 포함) | ✅ |
| InsertButton(:678) — Current 만 | hotkeyConfig.insert (isCurVersion 게이트) | ✅ |
| DeleteButton(:686) — measure 4종+권한 검증 | hotkeyConfig.delete (MSG00671) | ✅ |
| SaveButton(:1612) | hotkeyConfig.save (16 IN '^' bulk) | ✅ |
| ExcelButton(:1618) | SubTitle excel 다운로드 (표준) | ✅ |
| (AS-IS 공통 ExcelUpload) | hotkeyConfig.upload — FcstUploadModal 2-Step (UPLOAD 권한) | ✅ |
| Sort/Filter/Condition/Reset | 자동 활성 (생략 규칙) | ✅ |

## 3. SP (실측 15종 + Excel 3종 신규 변환)

| AS-IS SP | TO-BE | 상태 |
|---|---|---|
| DMF0082_GET_MAIN_DATA (12 IN+6 cursor) | PKG_DMF0082.P_DMF0082_GET_MAIN_DATA — **6줄 결함패치 후 사용** (ORA-00960/NLS/alias) | ✅ 적용 |
| DMF0082_GET_SPREAD_TITLE | 동일 SP + PROC_M/API/BTN 신규 배선 | ✅ 적용 |
| DMF0082_SAVE_MAIN_DATA (16 IN '^') | 동일 SP (fcstNPrice/SAVE 기배선) | ✅ |
| SCM0001_GET_BIZ_TYPE_BY_DIVISION | BizType CMBO (카탈로그 내장) | ✅ |
| PR_GET_DAY_RANGE | PeriodField 클라 계산 대체 | ✅ |
| DMF0082_POPUP_GET_FUTUREPRICE_INFO | ExchangeRateModal + PROC_M/API/BTN 신규 배선 | ✅ 적용 |
| **DMF0000_SAVE_EXCHANGE_POPUP_DATA** (8 IN '^' — AS-IS DMF0000_ExchangeRatePopup SaveData L440) | **PKG_DMF0000.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA** (기배포 본문 무수정) + futurePriceInfo SAVE 배선 (`DMF0082_exchange_modal_save_wiring_20260724.sql` — API_M/PROC_M 9행/BTN SAVE·EDIT·INSERT×ADMIN·DM ADMIN/MSG00689). ⚠ PROC_M 감사 2키 = `createdByBulk`/`lastUpdatedByBulk` (BE 가 `createdBy` 키를 세션 단일값으로 덮어써 '^' N-토큰 파싱 SP 와 계약 충돌 → 별도 키명. AS-IS FE L414~415 반복 append 1:1) | ✅ 적용 (2026-07-24) |
| UP_FX_GetCommonDataList_DM (6곳) | CMBO 등록명 (BucketType 등) | ✅ |
| DMF0003_GET_BUCKET_TYPE_CODE | BucketType CMBO | ✅ |
| DMF0003_GET_MKT_FCST_COMPARE_POPUP | ⏳ SSP 비교 팝업 — 잔여 (아래 §7) | ⏳ |
| 팝업 GET_SPREAD_TITLE_SAVE_PRICE / GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP | SavePricePeriodModal (savePriceTitle/savePriceData 배선) — **SP 22줄 결함패치**(LISTAGG bracket·`+`연결·AS ROWNUM·TRUNCATE 8) | ✅ 적용 |
| 팝업 GET_WEEKDATA / GET_MEASURE_COUNTINFO(_SAVE_PRICE) / GET_FUTUREPRICE_INFO(캐스케이드) | 미배선 — AS-IS dead/불달 경로 실측 근거 (P2 보고 §SP표) | ✅ 근거문서화 |
| **DMF0082_EXCEL_UPLOAD** (AS-IS 미이관) | **MSSQL→Oracle 신규 변환** (mode 2-Step) + 배선 | ✅ 적용 |
| **DMF0082_GET_EXCEL_UPLOAD_DATA** (〃) | 신규 변환 + 배선 | ✅ 적용 |
| **DMF0082_GET_MAIN_DATA_CURRENT** (〃) | 신규 변환 + 배선 (SEARCH_CURRENT) | ✅ 적용 |

## 4. Validation (MSG — AS-IS 활성 16종 실문구 전수 대사)

| AS-IS | 원문 | TO-BE | 상태 |
|---|---|---|---|
| MSG00002 | {0} 값은 필수 입력 | **MSG00429** (동ID 문구 뒤틀림 — 재매핑) | ✅ |
| MSG00004 | {0}개 저장됨 | MSG00002(성공 저장)/MSG00672(신규, 팝업) | ✅ |
| MSG00012 | 저장하시겠습니까 | **MSG00001** (재매핑) | ✅ |
| MSG00043 | 중복 저장 오류 | MSG00043 (동일) | ✅ |
| MSG00097 | 권한 Division 없음 | **MSG00667 (신규)** | ✅ |
| MSG00108 | 시작>종료 | MSG00108 (동일 의미) | ✅ |
| MSG00113 | 필수 컬럼 없음 | MSG00113 (동일) | ✅ |
| MSG00142 | Edit Mode 수행불가 | **MSG00668 (신규)** | ✅ |
| MSG00164 | 3년 제한 | MSG00164 (동일 의미) | ✅ |
| MSG00227 | Bucket 변경 불가 | MSG00227 (동일 의미) | ✅ |
| MSG00259 | 조회 후 수정모드 | **MSG00662** (재매핑) | ✅ |
| MSG00260 | 신규 중복 | MSG00260 (동일 의미) | ✅ |
| MSG00283 | Version 선택 | MSG00283 (동일) | ✅ |
| MSG00408 | 수정모드 입력불가 | **MSG00669 (신규)** | ✅ |
| MSG00449 | 수량/가격 미입력 | **MSG00670 (신규)** | ✅ |
| MSG00464 | 수정불가 메져 | **MSG00671 (신규)** | ✅ |
| (팝업 11종) | MSG00330/00409 ID승계 + MSG00137/00079… | P2 보고 대사표 | ✅ |

## 5. Expression / 편집 매트릭스

| AS-IS | TO-BE | 상태 |
|---|---|---|
| bEDIT_AUTH_* 4분기 (GET Tables[3]) | measureAuth (drop3 EDIT_AUTH_YN — 실행 실측 컬럼) | ✅ |
| 행별 EDIT_FLAG (요일제한 종합 — PKG L2630) | isNonEditableCell (GridUtils) | ✅ |
| SetEditList 금주 월요일 경계 (:9128) | editLock.thisWeekMondayYmd + isNonEditableDateColumn | ✅ |
| bucket 별 편집컬럼 (M/W/D) | isNonEditableCell bucket 분기 | ✅ |
| **M+4 월잠금** (list_EDIT_Month_M4 :9264 — MKT/SCM/VMI 월셀은 M+3 기준월 초과만 편집) | isNonEditableCell m3CutoffYyyymm 분기 (GET drop1 O_RC2 M3_CUTOFF_DATE) | ✅ **2026-07-20 보완(#4)** |
| **SCM_FCST × RMA 잠금** (gate3 :9239) | isNonEditableCell FCST_TYPE='RMA' 분기 | ✅ **2026-07-20 보완(#5)** |
| 월간→주간→일별 배분 (MKT/SCM_FCST) | divideByMonth/Week/Date (GridUtils — cellEditEnded 연결) | ✅ |
| ↳ **월(M_) 배분 = 달력 기반** (Truncate(월합/MONTH_DAY_CNT)×WEEK_DAY_CNT + 월잔량 기존셀 가산 :7222/7320) | divideByMonth (GET drop4 O_RC5 MONTH_DAY_CNT/WEEK_DAY_CNT 소비) | ✅ **2026-07-20 교정(#1)** — 구: 가시 컬럼수 비례 |
| **SALES_BUCKET 요일 캐스케이드** (Site/Incoterms 변경 :5862 → 행 BUCKET) | applySalesBucket (getCombo 'SalesBucket' — DM_MST_BUCKET_CONVERSION 룩업) | ✅ **2026-07-20 보완(#2)** |
| ↳ **요일비트 규약 = SUN-first** (AS-IS/PKG BUCKET=SUN\|\|…\|\|SAT L3483) | dowSunFirst = dayjs().day() (구 isoWeekday()-1 MON-first 오독 교정) | ✅ **2026-07-20 교정(#2)** |
| LOC 일괄할당 | allocateLoc | ✅ |
| ↳ **LOC 월합 = 평균** (값 있는 주차 평균, 합계 아님 :6716) | allocateLoc W_ 분기 월(M_) 재계산 | ✅ **2026-07-20 보완(#3)** — 구: M_ 미갱신 |
| 편집 Yellow / 과거 Gray (#95) | formatItem 클래스 토글 | ✅ |
| **당주 녹색 보더** (Green BevelBorder :1970) | formatItem boxShadow inset(당월M_/당주W_/금주월D_) | ✅ **2026-07-20 보완(#12)** |
| **NOTATION 행 숫자포맷** (INTEGER/POINT3 :1853) | formatItem — POINT3·LOC=소수3자리/그외 정수 | ✅ **2026-07-20 보완(#11)** |
| Delete 키 범위 clear + 재배분 | keydown 핸들러 | ✅ |
| **Insert 시드 10키 복사** (포커스 행 :2636) | handleInsert seed 복제(없으면 Measure=MKT_FCST) | ✅ **2026-07-20 보완(#9)** |
| **Daily FCST 정수절삭** (:6094) | cellEditHandler D_ 입력 Math.trunc(MKT/SCM/VMI) | ✅ **2026-07-20 보완(#14)** |
| **Bucket 전환 가드** (cboBucketType_Click MSG00227 :3361) | handleBucketChange — insertedRows>0 차단 | ✅ **2026-07-20 보완(#13)** |
| **Insert 행 실시간 중복(MSG00260 :5878)** | cellEditHandler 8키 완전일치 감지→롤백+alert | ✅ **2026-07-20 보완(#10)** |

## 6. 팝업 (6종)

| AS-IS | TO-BE | 상태 |
|---|---|---|
| SCM0002_ProjectbyDivisionPopupEx | ProjectByDivisionModal (공용 — SavePrice 모달 내) | ✅ |
| DM0002_ItembyDivisionPopupEx | ItemByDivisionModal (공용 — ItemField/SavePrice) | ✅ |
| SCM0002_VersionByWaterfallPopup | VersionSelectModal (DMF0073 공유 계약 — 원 SP INVALID ORA-01790 로 대체) | ✅ |
| DM0002_TitleSetForm_Popup | ColumnSettingModal + MeasureSelectModal (titleSet C/M) | ✅ |
| DMF0082_SaveSalesFuturePrice_Popup (2,414줄) | SavePricePeriodModal (AS-IS 전량 read 1:1) | ✅ |
| DMF0003_SspSyncComparePopUp (:3697) | ⏳ 잔여 (§7) | ⏳ |

## 7. 잔여 (정직 보고 — 은폐 아님)

1. **SSP Sync 비교 팝업** (Div40 전용 — spdMain_CellDoubleClick :3534/:3697 → DMF0003_GET_MKT_FCST_COMPARE_POPUP): mkt-fcst 의 SspSyncCompareModal 과 동일 기능이나 화면 간 직접 import 금지로 **복제 구현 필요**. ⏸ **2026-07-20 사용자 결정 = 보류** — 완전재현이 PKG_DMF0082 GET_MAIN_DATA 에 SSP_SYNC 수집+ATTR1 emit(라이브 핵심 조회 SP 개조)을 요구(실측: 현재 마커 전무). 라우트/SP(DMF0003_GET_MKT_FCST_COMPARE_POPUP, PROC_M)는 기존재라 후속 사이클에 route-only 또는 완전재현 택1.
2. **SCMD_APP SYNONYM 3종** (Excel SP): SCM_MGR 에 CREATE ANY SYNONYM 권한 없음 — `_dmf0082_excel/05_synonym_scmd_app_user.sql` 을 SCMD_APP 접속으로 실행 필요 (GRANT EXECUTE 는 적용 완료).
3. Version 원 SP `SCM0002_GET_VERSIONBYWATERFALLPOPUP` INVALID (ORA-01790 4곳) — DMF0073 공유 계약으로 대체 배선했으므로 비차단. 수리는 선택.
4. **Insert 행 캐스케이드 콤보** (#7 — Measure 재조회 FCST_PRICE_EDIT_MEASURE / CELL_PROD_SITE_ID, AS-IS :5839~5860): ✅ **2026-07-21 구현**. Measure = 신규 CMBO `FcstPriceEditMeasure`(div/site/bucket 편집가능 measure, UP_FX L438 단일SELECT 변환) 등록 + FE hook #59 §5-G dataMap 스왑(Site 변경→행별 후보 캐시, MEASURE 편집 진입 시 스왑, 종료 시 원복). CELL_PROD_SITE_ID = 기존 CMBO(`CELL_PROD_SITE_ID`, SP_CELL_PROD_SITE)가 shared DataGrid 캐스케이드로 이미 item 필터.
5. **고급 붙여넣기 1행→N행** (#8 — AS-IS :7864~8199): ✅ **achievable 범위 완료 / 행확장 = Wijmo 한계**. 셀별 붙여넣기(pastedCell→cellEditHandler)로 #2/#7 캐스케이드·#10 중복체크·수량 배분 모두 발동. **1행복사→N행확장은 Wijmo 가 whole-range 'pasted' 이벤트 미제공**(자매 mkt-fcst 도 동일 사유로 미구현, MktFcstGrid L1090 명시) — 플랫폼 한계로 parity 제외.

## 8. 게이트 결과 (2026-07-12)

- tsc 0 / eslint 0 errors (warning 2 = DMF0020 원본 동일 패턴) / 진입 392줄(≤400)
- POST-WRITE grep: FlexGrid JSX 0 · 금지 import 0 · window.alert 0 · console.log 0 · selector fallback 0 · initialized= 0
- nscm-be diff 0 / packages 변경 = 이전 세션(DMF0003) 잔존분만
- DB: PKG 6줄 패치 + SAVEPRICE SP 22줄 패치 + 배선 3종(P1/P2/Excel) 전부 적용·VALID·스모크 통과
