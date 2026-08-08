# __asis-mapping__.md — EID 1:1 대사표 (asis-coverage-check §0.0/§0.1)

> 원천: `DMF0082_FcstNPrice_주요이벤트_상세분석.md`(구양식 — 핸들러 단위 8절), `DMF0082_FcstNPrice_제약매트릭스_상세.md` · 생성: asis_mapping_gate.py --init + 수기 기입 2026-08-07
> ⚠️ 원천 md 가 hook #105 E번호 양식 이전 판 — §0.0 fallback 로 **md 절 단위 자체 채번**(E01~E08, 세부 항번 = md 하위 절 1:1).
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수 — 조회 전용 화면의 CRUD 행 등). 빈 칸 1개 = 게이트 실패.
> 런타임 실증 원장: `_artifacts/_apply_corporate/CRUD_ROUNDTRIP_DMF0082_20260807.txt` (SAVE SP 직접 실행 — 2026-08-07 사용자 승인)

## 이벤트·제약 (EID 1:1)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| E01 | spdMain_Changed — 셀 값 변경·배분 엔진 (md §1) | ForecastPriceGrid.tsx:394-531 cellEditEnded + ForecastPriceGridUtils.ts 배분 엔진 | — | 구현 |
| E01-A | Insert 행 키 셀 처리(sAction='I' 캐스케이드) (md §1-A) | ForecastPriceGrid.tsx:429-496 (MEASURE dataMap 스왑/원복 + SCM_SITE·INCOTERMS→SalesBucket + FcstPriceEditMeasure 재조회 — hook #59 §5-G) | — | 구현 |
| E01-B | 수량 변경 — 버킷 요일비트 산출 (md §1-B) | ForecastPriceGridUtils.ts:80-95 (row BUCKET 비트 + DEFAULT_BUCKET_40/ETC 분기 :84) | — | 구현 |
| E01-B1 | Daily 버킷 D_ 셀 수정 (md §1-B1) | ForecastPriceGrid.tsx cellEditHandler → D_ 직접 반영 + 검증(editLock) | — | 구현 |
| E01-B2 | Weekly W_ 셀 수정 — 주배분(요일비트 SUN-first) (md §1-B2) | ForecastPriceGridUtils.ts:182-200 주배분(2026-07-20 #2 SUN-first 교정) | — | 구현 |
| E01-B3 | Monthly M_ 셀 수정 — 월수량 일별 배분 (md §1-B3) | ForecastPriceGridUtils.ts 월배분 — drop4 MONTH_DAY_CNT/WEEK_DAY_CNT 달력기반(2026-07-20 #1) | — | 구현 |
| E01-B4 | 키 변경(수량 아님) else 분기 (md §1-B4) | ForecastPriceGrid.tsx:443-456,494-496 키 셀 cascade | — | 구현 |
| E02 | SetSaveData/SetSaveDataRemove — 저장 버퍼 (md §2) | @foundation EditTracker(CRUD_TYPE 마킹) + utils/forecast-price.save.ts:59-98 buildSaveRows(I/M/D×D_ flat) | — | 구현 |
| E03 | EditButton+SetEditList+SetLockRange — 잠금 게이트 5종 (md §3) | 서버 EDIT_FLAG(PKG GET L3041-3069: ADMIN/EDIT_AUTH_YN×요일 + 82='N') + utils/editLock.ts(금주 월요일) + measureAuth(drop3)+M+4(drop1 M3_CUTOFF) + wrapper 편집판정(ForecastPrice.tsx:204-206) | — | 구현 |
| E04 | SaveData(F7)+fnValidation (md §4) | ForecastPrice.tsx:309-354 handleSave + utils/forecast-price.validate.ts:20-51(V1~V3) + PKG SAVE — **2026-08-07 SP 직접 왕복 실증**(40/81 M·I 원장 반영·원복, 판가 52주·BIZ_TYPE·구간 검증 게이트 작동, 82 V82-00 차단) | — | 구현 |
| E05 | FindData(F5) 조회+Draw (md §5) | ForecastPrice.tsx:213-237 handleSubmit(V1~V4)+useTabProcQuery SEARCH/SEARCH_CURRENT — 2026-08-07 실측 40=17,343/81=6,518/82=4,890행 | — | 구현 |
| E06-A | InsertRow — 시드 10키 복사 (md §6-A) | ForecastPrice.tsx:241-266 handleInsert(#9 시드 복사, 82 차단 hotkey 게이트) | — | 구현 |
| E06-B | DeleteButton — D·I·DB행 3분기 (md §6-B) | ForecastPrice.tsx:281-306 handleDelete(I 즉시 제거/D 마킹·토글/measure 권한 MSG) | — | 구현 |
| E07 | ClipboardPasted/KeyUp — 붙여넣기 (md §7) | ForecastPriceGrid pastedCell→cellEditHandler(#8 2026-07-21 — 캐스케이드·중복·배분 발동). 1행→N행 확장은 Wijmo whole-range paste 이벤트 부재로 원천 불가(mkt-fcst L1090 동일 한계) | — | 구현 |
| E08-A | 헤더 더블클릭 드릴다운 (md §8-A) | ForecastPriceGrid.tsx:711-775 dblclickHandler + drillVisRef(hook #103 계열) | — | 구현 |
| E08-B | 셀 더블클릭 — SSP 비교 팝업 (md §8-B) | — | 제외 — 2026-07-20 사용자 결정 보류(완전재현=라이브 GET 개조 필요·route-only 대안 기록). 동기화 마커 ATTR1 캐리어는 2026-08-07 UICATEGORY 로 적재 준비됨 | 제외 |
| E08-C | Insert 행 키 셀 더블클릭 — 검색 팝업 (md §8-C) | ForecastPriceGrid.tsx:429-496 — 셀 종속 콤보로 대체 구현(2026-07-21 #7, CELL_PROD_SITE_ID/FcstPriceEditMeasure 캐스케이드) | — | 구현 |

## CRUD·모달 매트릭스 (2026-08-07 축 — MAIN UI 와 모달의 CRUD 누락 0)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| CRUD:MAIN:SEARCH | 버전 조회 (GET_MAIN_DATA) | useForecastPriceStore.setFilters→useTabProcQuery(SEARCH)→PKG_DMF0082.P_DMF0082_GET_MAIN_DATA — 실측 40/81/82 SUCCESS | — | 구현 |
| CRUD:MAIN:SEARCH_CURRENT | Current 조회 | SEARCH_CURRENT 배선→P_DMF0082_GET_MAIN_DATA_CURRENT — 2026-08-07 사문 파손(ORA-00904) 복구 실증 | — | 구현 |
| CRUD:MAIN:INSERT | 행 추가 → SAVE 'I' | ForecastPrice.tsx:241-266 + SAVE 'I' — SP 직접 실증(40/81 신규 7 원장 생성 확인) | — | 구현 |
| CRUD:MAIN:UPDATE | 셀 편집 → SAVE 'M' | cellEditEnded+EditTracker + SAVE 'M' — SP 직접 실증(40/81 +1→원장 반영→원복) | — | 구현 |
| CRUD:MAIN:DELETE | 행 삭제 → SAVE 'D' | ForecastPrice.tsx:281-306 + SAVE 'D' — 81=QTY 0 물리 저장(원문 정본, 실증) / 40 수요=원장 무변경(AS-IS Phase2 MERGE `QTY_PRICE<>0` 규약 — LOC 판가 삭제는 별도 검증·삭제 경로 L11773~) 실증 | — | 구현 |
| CRUD:MAIN:SAVE | 저장 (16+1 IN '^' bulk) | handleSave→/DMF0082/FcstNPrice/SAVE/call-proc — 82 는 V82-00 서버 거부+FE 버튼 숨김(2026-08-07) 실증 | — | 구현 |
| CRUD:MAIN:UPLOAD | Excel Upload (81 전용) | UploadModal→P_DMF0082_EXCEL_UPLOAD/GET_EXCEL_UPLOAD_DATA 배선(UPLOAD/UPLOAD_DATA/UPLOAD_SAVE BTN_MPG 실측) — isDiv81 게이트 | — | 구현 |
| MODAL:DMF0003_SspSyncComparePopUp | AS-IS 팝업 (분석 md) | — | 제외 — E08-B 와 동일(2026-07-20 사용자 보류 결정) | 제외 |
| MODAL:DMF0003_SspSyncPopUp | AS-IS 팝업 (분석 md) | — | 제외 — E08-B 와 동일(SSP 동기화 계열 보류) | 제외 |
| MODAL:ExchangeRateModal | 환율 팝업 (AS-IS DMF0000_ExchangeRatePopup 1:1) | components/modals/ExchangeRateModal.tsx — R:POPUP_GET_FUTUREPRICE_INFO / CUD:PKG_DMF0000.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA(hasButton EDIT×div40 게이트, Delete=사문·사용자 확정 2026-07-24) | — | 구현 |
| MODAL:ForecastTemplateModal | Excel Form 템플릿 다운로드 (81 전용) | components/modals/ForecastTemplateModal.tsx — 조회·다운로드 전용(저장 CRUD 없음: 템플릿 생성 모달) | — | 구현 |
| MODAL:MeasureSelectModal | Measure 개인화 선택 | components/modals/MeasureSelectModal.tsx — R:measureCount 계열 / U:titleSet 'M' SAVE(개인화 저장) | — | 구현 |
| MODAL:SavePricePeriodModal | Price Batch Input (기간 판가 일괄 저장) | components/modals/SavePricePeriodModal.tsx — R:savePriceData/savePriceTitle / CU:SAVE_PRICE 경로. div82 = 진입 버튼 숨김(2026-08-07 사용자 지정) | — | 구현 |
| MODAL:VersionSelectModal | 버전 선택 팝업 | components/modals/VersionSelectModal.tsx — R:version 시트(DMF0073_GET_VERSION_SALESPRICE 공유) 조회 전용, dblclick 선택 | — | 구현 |
