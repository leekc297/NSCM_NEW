# DMF0035 Demand Plan Waterfall — AS-IS 매핑 (1차 = 조회 전용 통합)

> 정본: `Doc/화면분석서/DMF0035_DemandPlanWaterfall_ASIS_통합분석_v1.0.md` (§1~§5) + `..._Cascade_Filter_전수.md`.
> AS-IS 3 UI(DMF0035 MKT FCST / DMF0022 SALES PLAN / DMF0051 BIZ PLAN) → GUBUN 통합. 초기값 MKT_FCST(사용자 확정).
> 그리드 = Wijmo OLAP 표준 컴포넌트(사용자 지시) — `@shared` `OlapPivotGrid` 첫 적용.

## 1. 조회조건 (통합분석 §4.3 설계표 1:1)

| AS-IS | TO-BE | 구현 |
|---|---|---|
| (신규) GUBUN | `GUBUN_OPTIONS` 콤보, 초기 MKT_FCST | Form Row A. 전환=`gubunResetParams`(버킷 스왑+버전 클리어) |
| cboDivision(필수) | Div. 콤보(MyDivision) | cascade+텍스트 4종 클리어(AS-IS .cs:1609-1612 — 0022 TO-BE 누락분 보완) |
| clbTeam/Customer/SalesSite/PlantSite/BizType/ItemType | 멀티 콤보 6종 | Team→Customer→SalesSite 연쇄. div40: Project·PlantSite disable(+BIZ 는 BizType), CellQty enable |
| clbEDISender (0035, div81만) | Sender Code 콤보 | `isMkt && isDivision81` 활성 |
| txtProject/ItemId/Owner + 팝업 | 공용 모달 3종 | Project/Item/OwnerByDivisionModal |
| txtVersion + 팝업 3종 | `WaterfallVersionModal`(신설) | DMF0073 9-arg 공유 계약 + GUBUN 접두 확장(MF·SF+ME_S / SP / BP). MKT 비필수(''=CURRENT) |
| drpPeriod | DatePickerCalendar | 상한 MKT/SALES 3년·BIZ 10년(MSG00164, To 보정) |
| cboBucketType | Bucket 콤보 | MKT/SALES=CMBO 'BucketType' / BIZ=BUCKET2 상수(AS-IS LOOKUP 실측 3계층 — CMBO 'BucketType2' 등록 시 교체) |
| chkSum/chkColor(chkMem) | 체크박스 | ONLY_WEEKLY 시 Sum 강제 해제 |
| cboCellQty | Cell Qty | MKT·BIZ 만 표시(SALES 는 AS-IS Visible=false → 미표시·'N' 고정), div40 만 활성, 이탈 시 해제 |
| InternalYN (0022) | 미표시 | AS-IS Visible=false → `internalYn:'N'` 고정 |
| cbxQty "Qty≠0" (0051) | 체크박스 | BIZ 만 표시 → `qtyYn` |
| cboKRW/USD/LOC/QTY | 환산 콤보 | SALES/BIZ=4종, MKT=QTY만. CODE=배수('1'~'100000000') |

## 2. SP 계약 (procedures.d.ts DMF0035 블록)

| 시트 | canonical PROC | IN |
|---|---|---|
| mktFcstWaterfall | PKG_DMF0035.P_DMF0035_GET_MKT_FCST_WATERFALL | AS-IS 19 + USER/MENU = 21 |
| salesPlanWaterfall | PKG_DMF0022.P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL | 20+2 = 22 (기존 재사용) |
| bizPlanWaterfall | PKG_DMF0051.P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL | AS-IS 17+2 = 19 (재변환 — Phase B) |
| *SpreadTitle ×3 | 각 PKG GET_SPREAD_TITLE | 5 |
| version | DMF0073_GET_VERSION_SALESPRICE | 9-arg 공유(DMF0082 선례) |

- `p_now`(SALES/BIZ): **이번주 월요일 + from/to 경계 보정**(AS-IS .cs:1077-1081 1:1 — `calcNowYyyymmdd`). dayjs() 단순 대입(구 오구현) 승계 금지.
- dead 쌍 `p_user_dept_id/p_group_id`: SP 본문 미사용 실측 — 시그니처 유지용 빈값(주석 명기).

## 3. Validation·MSG (실문구 대사 #114 — 통합분석 §2.F 실측)

| MSG | 조건 | 위치 |
|---|---|---|
| MSG00137 | 조회 중 재조회 | handleSubmit |
| MSG00097 | Division 미선택 | handleSubmit |
| MSG00013 | Period 미입력 / Version 미입력(SALES·BIZ) | handleSubmit |
| MSG00108 | From > To | handleSubmit |
| MSG00164 | 기간 상한 초과(3y/10y) — To 보정 후 중단 | handleSubmit |
| (MSG00109) | 조회 전용 — hotkeyConfig 로 CUD 자체 숨김이라 미발화 | hotkeyConfig |

## 4. Grid (OLAP 대체 매핑)

| AS-IS | TO-BE OLAP | 상태 |
|---|---|---|
| 동적 PIVOT + titleset 'C' 고정컬럼 | TITLE SP → rowFields(SORT_ORDER_NO 순, B_/VISIBLE 'N' 제외) | ✅ |
| 기간 컬럼 D_/W_/M_(0035·0022) / M_/Q_/Y_(0051) | wide→long `unpivotWideRows` + PERIOD 열 축 | ✅ |
| 버킷·Sum 토글(SetSpreadColumn) | `visiblePrefixes` 접두 필터 | ✅ (실측 규칙 1:1) |
| footer SUM(SumIgnoreHidden) | showRowTotals='GrandTotals' | ✅ (총계 행) |
| 환산 콤보(SetAmountCalculating) | `divisorFor` — 금액 6·수량 8(+BIZ Business_Plan)·MKT 전행, Round 2 | ✅ (실측 measure 목록) |
| 전 컬럼 읽기전용 | PivotGrid 기본 read-only | ✅ |
| Excel(F12) | OlapPivotGridRef.exportExcel + SubTitle grid 연동 | ✅ |
| 3단 헤더 병합(LARGE/SMALL 라벨) | OLAP 열 계층 미적용 — PERIOD 원시 키(M_202608) 헤더 | ⚠ 부분(하기 잔여) |
| chkColor 회색 실적구간 / NOTATION 행 포맷 / 당기 Green·주말색 / 헤더 더블클릭 드릴 | 미구현 | ⚠ 잔여(하기) |

### 잔여(2차 또는 폴리시 확정 필요 — 침묵 금지 전수 기록)
1. **PERIOD 헤더 라벨**: TITLE SP 의 lCls/sCls 3단 라벨 → OLAP 열 계층(연>월>주) 매핑 — 2차.
2. **chkColor(Gainsboro 실적구간)**: OLAP formatItem 커스터마이징 — 2차. 기준일 GUBUN별(주/전월) 상이 — 통합분석 §4.2.
3. **NOTATION 행 포맷 / 당기 강조 / 주말색**: formatItem — 2차.
4. **헤더 드릴(M_→W_→D_ / M_↔Q_)**: OLAP 계층 접기로 대체 검토 — 2차.
5. **Version 팝업 sPeriod(조회기간 덮어쓰기)**: 공유 계약(DMF0073)에 버전 기준일 컬럼 부재 — 계약 결손. Phase B 에서 SP OUT 확장 또는 버전명 파싱 정책 확정 후 반영.
6. CMBO 신설 대기: 'BucketType2'(BIZ M/Q/Y), 'QtyType'(환산 배수 — 현재 상수 옵션) — Phase B 메타 세트.

## 5. 이관 제외 (AS-IS dead — Cascade 전수 md §4.9)
SetClbVersion(빈 함수)/spdMain_ComboSelChange(사문)/구 ExportExcel(주석 블록)/p_user_dept_id·p_group_id(본문 미사용)/MSG00003(dead)/그리드 셀 더블클릭 팝업 2종(read-only 도달 불가).
