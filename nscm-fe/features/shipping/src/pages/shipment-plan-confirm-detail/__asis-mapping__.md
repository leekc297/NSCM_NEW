# SSP0012 Shipment Plan Confirm Detail — AS-IS ↔ TO-BE 매핑

- AS-IS: `GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0012_ShipmentPlanConfirmDetail.cs` (+ Designer)
- 설계: `.atlas/gscm-design/SSP0012/design/00_checklist.md ~ 03_grid-columns.md`
- 화면 성격: 읽기전용 조회(Inquiry) + 고정 47컬럼 상세 그리드. 편집·저장·동적 PIVOT 없음.

## 영역1 — Layout / 툴바 (design 01)

| AS-IS | cs 근거 | TO-BE |
|---|---|---|
| Form(BaseFormAsync) | Designer:537 | `ShipmentPlanConfirmDetail.tsx` + Form + Store |
| usrConditionPanel1(HidePanel) | Designer:116 | `SearchArea`(openSearchArea 접기/펼치기) |
| L1 권한 게이트(dtMyDivision 0건) | cs:232-233 | Form: MyDivision(EE제외) 0건 → `hasDivisionAuth=false` → 조회영역 disable + MSG00667("No authority assigned." — TO-BE 문구 실측 코드, AS-IS MSG00097 답습 금지 Hook#114) |
| L2 Insert = NO-OP | cs:303-306 | `hotkeyConfig.insert = hasButton ? () => undefined : false` |
| L3 Delete = NO-OP | cs:308-311 | `hotkeyConfig.delete = hasButton ? () => undefined : false` |
| L4 Save = NO-OP | cs:345-347 | `hotkeyConfig.save = hasButton ? () => undefined : false` |
| L5 Edit = MSG00109 안내 | cs:314-318 | customButton Edit → `handleEdit` → alert MSG00109(읽기전용) |
| L6 Find = 조회 | cs:298-301,384 | `hotkeyConfig.search = handleSearch`(Period 필수 가드) |
| L7 btnColumn(컬럼설정) | cs:605-615 | SubTitle 아이콘 customButton(#120) → `ColumnSettingModal` → OK 시 `fetchStaticColumns` refetch |

## 영역2 — 조회조건 콤보 (design 02)

| AS-IS | cs 근거 | TO-BE |
|---|---|---|
| Division(clbDivision) MyDivisionInEE + EE 제외 | cs:48,237 | 콤보 `MyDivisionInEE_SCP` + 클라 필터 `CODE!=='EE'`(정확히 'EE') |
| From Site(clbPlantSite) EE/비-EE 분기 재조회 | cs:364-378 | `useTabComboQueries` comboId 분기(`ShipmentPlanPlantSite_SCP`/`PlantSiteByDivision_SCP`) @divisionId 재발사 + ALL |
| Division 변경 = Period 리셋 | cs:380 | `setDivisions` → Period 기본값 재설정 + From Site 초기화 |
| Model(txtItemId) 팝업 | cs:322-343 | `ItemByDivisionModal`(division/model 사전필터) → itemId 세팅 |
| Period* 기본값(오늘~+55영업일) | cs:243,587-604 | `initPeriodDefault`(dayjs 영업일 근사 — SCM0001_GET_SCP_DAY_PERIOD 미배포, convert-sp 후 정밀화) |
| Sold To / Ship To Party | cs:403-404 | 자유 텍스트 → SP p_Sold_To_Party / p_Ship_To_Party |
| LABEL 6종 | design 02 §4.5 | LBL00641/00022/00669/00013/01122/01114(실측 존재, 신규 0) |

## 영역3 — 그리드 (design 03)

| AS-IS | cs/메타 근거 | TO-BE |
|---|---|---|
| 47컬럼 고정 스키마 | SCM_MST_SHEET_COLUMNS 47행 | `staticColumns`(admin 메타 구동, 하드코딩 없음 #130) |
| W1/W3/W7 세로 머지 sticky | cs:267,287-291,441 | DataGrid `allowMerging=Cells` + CustomMergeManager(hook #69) |
| W5 조회 바인딩 | cs:438 | `useTabProcQuery` 결과 바인딩 |
| W6 전열 읽기전용 잠금 | cs:439 | DataGrid `isReadOnly` |
| W4 SetLockSumColumn(dead) / 동적 PIVOT | cs:353-362(호출부 없음) | 미구현(반증, 구현 시 AS-IS 초과 결함) |
| 2단 머지 헤더(Departure Port/Arrival Port/Departure days/Lead Time) | cs:266 | admin 메타 SMALL_CLASS_LABEL_NAME 구동 다단 헤더(hook #93) |
| INCOTERMS 좌측 고정(FIXED_FLAG=Y) | 메타 | admin 메타 `fixed` → DataGrid frozenColumns |
| FCST_TYPE 코드→표시(SALES_TYPE_CODE) | cs:56 메타 FPComboBox | admin 메타 자동 콤보(표시매핑, 편집 아님) |
| W9 INCOTERMS 셀 클릭 → BOD 상세 | cs:507-523 | Grid click → `BodDetailModal`(divisionId[EE면 ORIGIN_FROM_DIVISION_ID]+bodId) |
| W10 CHANGE_REQ_NO 셀 클릭 → 변경요청 상세 | cs:524-534 | Grid click → `ShipmentRequestDetailModal`(changeReqNo) |
| G1 빈 그리드 가드 | cs:505 | click: `g.rows.length===0` return |
| G2 컬럼 판정 가드 | cs:507/524 | click: binding == INCOTERMS/CHANGE_REQ_NO |
| G3 공백 CHANGE_REQ_NO 가드 | cs:528 | click: changeReqNo 공백이면 미오픈 |
| hidden 4컬럼(PLAN_QTY/BOD_ID/ORIGIN_FROM_DIVISION_ID +1) | 메타 VISIBLE_FLAG=N | admin 메타 visible=false 유지(드릴다운 파라미터) |

## 미이관/유예 (정직 보고)

- GET SP `P_SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` 미배포(PKG_SSP0012) → 실 조회 런타임 ERROR(convert-sp 후속).
- Period 서버 기본값 SP(SCM0001_GET_SCP_DAY_PERIOD) 미배포 → dayjs 영업일 근사(공휴일 미반영).
- 드릴다운 BOD/변경요청 상세 팝업의 데이터 원천 SP 는 별도 팝업 전환+SP 배포 대상 — 트리거·가드·파라미터만 구현, 상세 데이터 유예.
- 드릴다운 모달 제목/라벨 i18n(Hook#114): 'BOD Detail'/'Change Request Detail'/'Change Request No' 문구 코드가 SCM_ADM_MSG_M 에 없음(LBL01047='Receiver Setup', LBL01048='SMS Content *', LBL01108='Requestor'). AS-IS 번호 답습 대신 화면 스코프 키(`_ssp0012.*`)+defaultValue 사용. message-master 신규 등록은 실 팝업 전환(convert-sp) 때로 유예.
- SetChangedPeriod/dBaseDate = dead(cs 주석·미참조) → 이식 안 함.
