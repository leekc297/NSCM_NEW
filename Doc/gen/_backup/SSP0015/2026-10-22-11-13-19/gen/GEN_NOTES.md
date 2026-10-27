# GEN_NOTES — SSP0015 ShipmentPSI (TobeGen 2026-10-21)

생성 대상: `features/shipping/src/pages/shipment-plan-mobility-it/` (To-Be 메뉴 메타 확정: 상위 Shipping_Schedule, MNU_URL shipment-plan-mobility-it, USE_YN=Y)
As-is grid_mode: HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경) · 시트 15 (+팝업 0) · 조회조건 17 · 버튼 6 · 이벤트 25 · 엔드포인트 39

## 기계가 끝낸 것 (손대지 말 것 — 사전 규칙)
- constants(MENU_ID/SHEETS/RESPONSE_SET/DIVISION), store(검색 파라미터·메타 컬럼·저장 조회조건), Page 조합, Form 필드 17개, Grid(DataGrid), __asis-mapping__.md 초기본, register.json, 단위테스트 it.todo 121건

## Claude Code 가 채울 것 (TODO(이식) 표시 지점만)
1. 라벨 코드: 자동 매칭 15/17 (To-Be 코드 사용 빈도 사전 rules/lbl_codes.csv). 미확정 `LBL?????` 2곳: chkSum='Change Qty', txtRequestor='item.UserName' → 메시지 마스터(SCM_ADM_MSG_M) 조회 후 코드 기입, 없으면 신규 채번 요청. Doc/tobefacts/db/msg_master.csv 가 있으면 생성기가 자동 조회
2. 콤보ID 5개: cboPlanDate→'Plan-date*', clbPlantSite→'FromSite', cboBucketType→'Bucket', clbDivision→'Division*', clbResultType→'ResultType' — As-is 소스는 Fact Pack endpoints 의 UP_FX_GetCommonDataList_* / meta_reads 참조
3. 이벤트 핸들러 로직 24개 (flow.csv 의 호출 체인 그대로)
4. 팝업/모달: btnMeasure→MeasureSelectModal, btnItemId→ItemByDivisionModal · As-is 팝업 클래스 SSP0015_ShipmentPSICommentsPopup → components/modals/
5. 스프레드 2개 → spdMain→GridMain(WH In Plan Detail), spdDetail→GridDetail(Hold stock Detail/Hold stock/MES Stock Detail/SCS Stock Detail/Shipment Confirm Detail/Shipment PSI(IT & Mobile)/Shipment PSI(Mobility & IT)/Shipment PSI(Packer)/Shipment Request Detail/Shipment Result/Stock Detail/Stock Location Detail/W/H stock/W/H stock Detail) — PanelGroup 세로 분할로 생성. As-is SplitContainer 방향/비율에 맞게 orientation·defaultSize 조정
6. division 변형: 40, 81, 82, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC — grid_effective 의 division 열이 비어있지 않은 컬럼은 표시 조건 분기
7. 검증/표현식: hooks/useShipmentPlanMobilityItValidation.ts V-마커 16건(+팝업 0) · useShipmentPlanMobilityItExpression.ts E-마커 127건 — apply 본문 채우기 (마커 수 = validation.md 행 수, 게이트 V01)
8. register.json → P_REGISTER_SCREEN (클라우드) → `pnpm gen:procedures` → procedures.d.ts 반영 후 타입 느슨 구간 제거
9. 동적 헤더(기간 컬럼): SCP0009_GET_SHEET_CALENDAR_3SPAN(As-is GetSpdTitle) → 시트 'calendar' = 사내 PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN · As-is DB루프 InitSpreadDateColumn:1110, InitSpreadDateColumn:1114 — 조회기간으로 타이틀 시트를 **반드시 조회**하고 o_rc1(COLUMN_NAME·COLUMN_LABEL_NAME·SMALL/LARGE_CLASS_LABEL_NAME·DAY_CODE)로 헤더를 만든다. 응답 키는 proc_params.csv OUT COL_NM 만(o_rc1_columns 금지 — SYS0013 전용). 게이트 B26·B27

## 사전에 없던 것 (룰 보완 후보 — rules/*.csv 에 추가)
- 없음
- 이벤트 this.spdMain.TextTipFetch : map_event.csv 추가
