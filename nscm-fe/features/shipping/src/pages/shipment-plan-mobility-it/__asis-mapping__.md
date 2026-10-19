# SSP0015 Shipment Plan(Mobility & IT) — AS-IS ↔ TO-BE 매핑

> AS-IS 정본: `GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0015_ShipmentPSI.cs`(9,856줄) + `.Designer.cs`.
> 설계 근거: `.atlas/gscm-design/SSP0015/design/00_checklist.md ~ 03_grid-columns.md`.
> 이 문서는 convert-core §2.1(11) "AS-IS 검증·표현식 100% 매핑, 조용한 제외 금지" 이행 기록이다.
> **주의(정직 보고, convert-core §4.3)**: 이번 회차(iter-1)는 화면 골격 + 핵심 조회/편집/저장 경로를
> 구현했고, 아래 표의 다수 항목은 **부분 구현 / 후속(convert-sp·차기 회차)** 상태다 — 상태 열을 참조.

## 1. 툴바 override (§4d 본문 판정)

| override | AS-IS 판정 | TO-BE | 상태 |
|---|---|---|---|
| FindButton | 실동작(활성시트 0/1 분기) | `handleSearch`→`runMainSearch`(mainSheet 분기 main/mainPacker) | 구현 |
| InsertButton | 실동작(Hold stock 신규행) | `handleInsert`(Hold stock 가드 + siMain 활성행 복사 `GridAction.addRow`) | 구현(gap-resolve 재확인) |
| DeleteButton | 실동작(spdDetail+shtBolckStock+신규행'I') | `handleDelete`(가드 + `GridAction.removeRow(deleteOnlyNew)`) | 구현(gap-resolve 재확인) |
| EditButton | 모드토글 | **미이식**(편집 기본 ON, `canEdit=hasButton('EDIT')`) — convert-core §2.4 | 구현(미이식 결정) |
| SaveButton | 실동작(fps 분기 → ERP 연쇄) | `handleSave`(main WH_IN / confirmDetail 분기) | 부분(ERP 연쇄 후속) |
| btnMeasure_Click | master 활성시만 팝업 | `handleMeasure`(activeGrid==='detail' no-op) + ColumnSettingModal | 구현 |

### EditButton 업무가드 미이식 근거 (§5#2, R7a/R7b)
- R7a `GetSSPUserCheck()==false → MSG00251`: GET SP `SSP0002_GET_USER_INFO_LIST`(PKG_SSP0002)로 사용자
  등록 확인 후 편집 허용. TO-BE 미배포 → **fail-open**(편집 허용). convert-sp 후속.
- R7b `oldPlanDate != newPlanDate → MSG00170`: 최신 Plan 아니면 편집 차단. TO-BE 는 realFlag 판정
  수단(콤보 index0)이 확정되지 않아 **미배선** — 04_react-gap.md 확인필요.
- SwitchLock/LockRange 모드토글: convert-core §2.4 대로 미이식(편집 기본 ON). `editMode`/`setEditMode` 미신설.

## 2. validations (n=56, 00_checklist §2b) — 매핑 상태

| 그룹 | AS-IS(대표) | TO-BE | 상태 |
|---|---|---|---|
| Measure 활성그리드 (#4·5 MSG00007) | fps null / spdDetail | `handleMeasure` no-op | 구현 |
| master 음수 (#6 MSG00084) | nDayQty<0 | `collectMainSaveRows` negatives → alert | 구현 |
| 변경없음 (#11·15 MSG00133) | bolChang_Flag | 저장 시 dirty 0 → toast | 구현 |
| Detail 확인창 (#13·17·52 MSG00324) | GMessageBox | `handleSave` confirm(MSG01201) | 구현 |
| 운송수단 필수 (#43·45 MSG00278) | TRANSPORT_MODE 공백 | 저장 전 행별 검증 | 구현 |
| 변경사유 (#26·46 MSG00286/287) | reason '-'/공백 | cellEditEnded + 저장 전 검증 | 구현 |
| ERP 연쇄 (#27~39·44·50~56) | GetERPInterface RtFlag E/F/C_E, remainMinute, SO_NO_CNT, CHG_BATCH | **미이식** — SP 오케스트레이션(convert-sp/런타임 후속) | 후속 |
| 읽기전용 sheet (#3 MSG00109) | Edit 거부 8종 | 읽기전용 시트 isReadOnly | 구현 |

> ERP 인터페이스 연쇄(#27~39·44·50~56, 약 20건)는 다중 SP 오케스트레이션(GetERPInterface →
> ERP_SO_NO_CNT / SHIPMENT_STATUS / CONFIRM_CHANGETIME / ANL_SHIP_CONFIRM_CHG_BATCH)로,
> BE SP + 런타임 배선 영역이다. FE 는 저장 라우팅 + 행별 필수검증 + 확인창까지 구현했고 ERP
> 응답 분기(RtFlag)는 **convert-sp 후속**으로 남긴다(조용한 제외 아님 — 명시 보류).

## 3. buttonGuards (n=40, 00_checklist §4d) — 매핑 상태

- Insert/Delete 가드(#1·2·3 fps/shtBolckStock/신규행): `handleInsert`/`handleDelete` 활성시트 가드 구현,
  실제 addRow/removeRow 배선은 후속.
- shtDetail_Change 가드(#13~21 IsLock/ERP_STATUS='C'/TRANSPORT_MODE/CHANGE_REASON): `isDetailCellEditable`
  + `cellEditEnded` 로 재현(구현).
- CellDoubleClick 가드(#22·24·25 ActiveSheetIndex/WH_IN/"WH in Plan") — 기간셀(D_) 더블클릭 measure 분기(IsLock=읽기전용에서만):
  - **WH_IN → Comments(memo) 팝업**(AS-IS L8177, 드릴 아님). `ShipmentPsiMainGrid` dblClick → `onMemo`(우클릭 Memo 와 동일 경로) 재사용. 이전 Plan(editable=false)에서 동작.
  - **SHIP_CONFIRM → Confirm Detail**(L8068), **WH_STOCK → W/H stock**(L8089). `measureDrilldownOf` 2종만.
  - MES stock/Hold stock/Balance 드릴(L8111·8134·8155)은 'Figure' 정적 열 클릭 전용이라 기간셀 더블클릭에선 미동작 → 미매핑(사용자 결정 2026-10-08 "엄격 AS-IS"). 종전 WH_IN→Confirm Detail·MES_FCS→MES 오매핑 교정.
- CellClick 가드(#26·27 CHANGE_REQ_NO/sRequestNo): `onConfirmDetail`(CHANGE_REQ_NO 비공백 가드) 구현.
- ClipboardPasted 가드(#34~40): pastingCell 게이트로 재현(구현).

## 4. gridSignals (n=272, 00_checklist §3) — 카테고리별 상태

| category | n | TO-BE | 상태 |
|---|--:|---|---|
| lock | 43 | `isMainCellEditable`/`isDetailCellEditable` white-list(INPUT_TP_CD 전건 'S' 갭 대응) | 구현(주요) |
| value | 76 | EDIT_MAIN='Y'→CRUD_TYPE + SO그룹 전파(cellEditEnded) + paste NEW_ETD/ETA/NEW_SHIPMENT_DATE 선산정+SO그룹 전파(pastedDateHandler) | 구현(SO그룹·reason·paste 날짜파생 gap-resolve I09 해소) |
| color | 32 | 편집셀 Yellow(#FFFDE7)/wj-cell-editable, 토/일 헤더색, MES USER_MOD_RELEASE_DATE Blue, 음수=빨간글자(AS-IS NegativeRed — Main+전 detail 시트·footer, 정본 paintNegativeText #c0392b) | 구현(USER_MOD Blue gap-resolve I15 해소, 음수 NegativeRed 전역 파리티). 저장 시 음수 차단 alert(MSG00225)은 별개 유지 |
| merge | 8 | TYPE·PSI_NAME 세로 merge | 구현 |
| span | 10 | 동적 3단 헤더(calendar 3span) | 구현 |
| visible | 21 | Bucket/chkSum D_/W_/M_ 토글 | 구현 |
| cellType | 6 | admin 메타 구동(FPComboBox 등) + master PROD_DATE(date-to-text)·LOT(center·빈/"0"→"") + Production(PROD_PLAN)·Production Date(PROD_DATE) 빈/"0"→"" (no-data 공백) | 구현(PROD_DATE/LOT gap-resolve I14 해소). 주의: Production/Production Date no-data(0)→공백은 사용자 요구 divergence(2026-10-08) — AS-IS 는 LOT 만 0 blank, Production 은 SP null 로 공백. TO-BE SP 가 0 을 채워 와 표시단 blank 로 재현. 되돌리지 말 것 |
| dataSource | 21 | React Query useTabProcQuery | 구현 |
| other | 55 | 시트전환·드릴다운·Insert/Delete 라우팅 | 부분(드릴다운 구현, 코멘트 sticky/OrderDetail 후속) |

## 5. 미이관/후속 (조용한 제외 금지 — 04_react-gap.md 상세)

- **TransMode/ShipToCode 셀콤보 + PARAM2/ATTRIBUTE10='D'**(design 03 §6-B): `05_register.sql`로
  `SCM_MST_SHEET_COLUMNS` enrichment(FPComboBox 등록). 런타임 lazy 재조회(EE 치환)는 후속.
- **INPUT_TP_CD 편집메타 전건 'S'**(design 03 §6-A): 코드 white-list(`editLock.ts`)로 재현.
  `useSaveWithValidation` 라벨 `*` 인식 보강은 후속.
- **PlanDateShip 콤보**: `PlanDate` 재사용(Main "A" 등가). Packer("P")=SSP_ANL_SHIP_PLAN_P 등가 미등록 — 확인필요.
- **Comments sticky note / OrderDetail(SSP0300) / ShipmentRequest 팝업**: TO-BE 팝업 부재 — 후속.
- **PACKER_PAST 조회**(cboPlanDate index 분기): 미배선 — 후속.
- **Requestor UserInfoPopup**: 자유입력 대체, 팝업 미배선 — 후속.

> gap-resolve iter-1(2026-09-28): I09(paste NEW_ETD/ETA+SO그룹 전파)·I14(PROD_DATE/LOT 특수셀)·
> I15(MES USER_MOD Blue) 를 AS-IS cs 대사(L8995-9029·L2668-2680·L3943-3946)로 코드 해소. 잔여
> (ERP 연쇄·R7a/b·PlanDateShip·EE 치환·PACKER_PAST·읽기전용 변형·Requestor/아이콘 팝업)는 DB 접속·
> convert-sp·컴포넌트·사용자 결정 블로커 — `.atlas/gscm-design/SSP0015/gap-resolve/iter-1/notes.md` 참조.
