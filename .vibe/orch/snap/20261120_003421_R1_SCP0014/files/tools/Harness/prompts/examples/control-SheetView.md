# 예제 — control-SheetView (7건 중 3)

같은 유형의 As-is 항목을 기존 To-Be 화면이 어떻게 구현했는지. **모양(훅·컴포넌트·네이밍·주석 규약)을 그대로 따른다.**

## SSP0024 · §1 spdMain_Sheet1 / SheetView
- 위치: `features/shipping/src/pages/shipment-master-electrode/shipment-master-electrode.constants.ts:21-47`

```tsx
// AS-IS GSCM.SSP.Plan.UIL SSP0024_ShipmentMasterElectrode (단일 그리드 spdMain "Ship Master Elec"):
//   설계 근거: .atlas/gscm-design/SSP0024/design/00_checklist.md ~ 03_grid-columns.md, 07_human-doc-supplement.md
//   - GET  SP  : PKG_SSP0024.P_SSP0024_GET_SHIP_MASTER          (반환 25컬럼, o_rc1)
//   - SAVE SP  : PKG_SSP0024.P_SSP0024_SAVE_SHIP_MASTER         (변경행만 ^-delim, 16 파라미터, SSP_MST_SHIP_MASTER_EE)
//   - CHECK SP : PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST       (Edit 진입 SSP Planner 권한체크, 0건→MSG00251)
//   - POPUP SP : PKG_SSP0024.P_SSP0024_GET_ITEM_BY_DIVISION_POPUP (Material/Model 선택 팝업, 원천 SCP_MST_FINAL_ITEM)
//   - 편집 상태기계: 조회=전체 lock(뷰) -> Edit(권한체크 통과) 진입 = 기존행 9칸 편집 / Insert = 신규행 지정칸 편집
//     -> Save 성공 후 뷰 복귀. 신규행('I')만 삭제 가능(기존행 삭제 불가).
//   - SP 미배포(design 00 §0 / goal.md): PKG_SSP0024·PKG_SSP0002 all_objects 0건 → 런타임 실행체인 미완(convert-sp 후속).
export enum SHEETS {
  MAIN = 'main', // spdMain 단일 시트 (25컬럼)
  POPUP = 'popup', // SSP0024_ItembyDivisionPopup (Material/Model 선택, 원천 SCP_MST_FINAL_ITEM)
}

// NSCM 단일 cursor 표준 'o_rc1'
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
  POPUP: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS) SHEET_NAME — AS-IS SpdSheet 그대로 (design 03 §1).
//   실측: SCM_MST_SHEET_COLUMNS PROGRAM_ID='SSP0024' SHEET_NAME='Ship Master Elec' 25행(배포됨, goal.md ②).
export const ADMIN_SHEET_NAME: Partial<Record<SHEETS, string>> = {
  [SHEETS.MAIN]: 'Ship Master Elec',
};

```

## SSP0014 · §1 spdMain_Sheet1 / SheetView(시트)
- 위치: `features/shipping/src/pages/shipment-model-pic/shipment-model-pic.constants.ts:6-32`

```tsx
//   - GET  SP : PKG_SSP0014.P_SSP0014_GET_MODEL_PIC  (반환 21컬럼, o_rc1)
//   - SAVE SP : PKG_SSP0014.P_SSP0014_SAVE_MODEL_PIC (변경행만 ^-delim UPSERT, SSP_MST_MODEL_USER)
//   - CHECK SP: PKG_SSP0014.P_SSP0014_GET_USER_ID_CHECK (저장 전 그룹권한 검증, 미통과 시 MSG01261)
//   - 편집모드: AS-IS Edit(SwitchLock) 토글은 미이식(convert-core §2.4 — 조회 직후부터 편집 가능).
//   - Insert/Delete = NO-OP (AS-IS override 본문 주석처리 cs:254/259) -> 버튼 노출 + 클릭 무동작
//   - 편집셀 9 = USER_ID(필수 M) + PART_LEADER/TEAM_LEADER/MAIL_USER1~5/VALID_YN(선택 O). 나머지 12 lock.
//     편집가능 판정은 admin 메타(INPUT_TP_CD)가 정본 — 화면 상수/핸들러로 덮어쓰지 않는다.
export enum SHEETS {
  MAIN = 'main', // spdMain 단일 시트 (21컬럼)
}

// NSCM 단일 cursor 표준 'o_rc1'
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS) SHEET_NAME — AS-IS SpdSheet 그대로 (design 03 §1).
//   실측: SCM_MST_SHEET_COLUMNS PROGRAM_ID='SSP0014' SHEET_NAME='Shipment Model PIC' 21행(배포됨).
export const ADMIN_SHEET_NAME: Partial<Record<SHEETS, string>> = {
  [SHEETS.MAIN]: 'Shipment Model PIC',
};

// 더블클릭 UserInfoPopup(SsoUserModal) 대상 8열 — 선택 UserID 를 그 셀에 SetValue
//   (AS-IS cs:225~233 cellTypeImage / 메타 FPTextModal 8열과 1:1, design 03 §3 R4/R6).
//   이 목록은 "팝업 대상"만 정의한다 — 편집가능 여부는 메타 INPUT_TP_CD 소관.
export const USER_POPUP_COLUMNS = [
```

## SSP0023 · §1 spdDetail_Sheet1 / SheetView
- 위치: `features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailGrid.tsx:228-256`

```tsx
  return (
    <TabWrapper
      persist
      activeTabIndex={activeIndex}
      setActiveTabIndex={index => setActiveDetailSheet(DETAIL_SHEETS[index])}
    >
      {DETAIL_SHEETS.map(sheet => (
        <TabItem key={sheet} label={ADMIN_SHEET_NAME[sheet] ?? sheet}>
          <DataGrid
            gridRef={gridRefs[sheet]}
            gridFilterRef={gridFilterRefs[sheet]}
            editTrackerRef={isReadOnlySheet(sheet) ? undefined : editTrackerRefs[sheet]}
            isReadOnly={isReadOnlySheet(sheet)}
            itemsSource={rowsBySheet[sheet] ?? []}
            staticColumns={staticColumns[sheet] ?? []}
            comboParams={{ mnuId: `'${MENU_ID}'` }}
            // AllowMerging.Cells 만 주면 컬럼 헤더 병합이 꺼져 정적 컬럼의 단일 라벨이 그룹 헤더행+leaf
            //   행에 각각 찍혀 "같은 텍스트가 여러 줄"로 보인다(2단 헤더 StockDetail 신고 2026-10-11,
            //   memory datagrid-allowmerging-cells-breaks-header-merge). .All 이어야 헤더 병합(정적 컬럼
            //   세로 span)과 데이터 셀 병합(SO 그룹)이 둘 다 동작 — 메인 그리드와 동일.
            allowMerging={AllowMerging.All}
            gotFocus={() => setActiveGrid('detail')}
          />
        </TabItem>
      ))}
    </TabWrapper>
  );
};

```
