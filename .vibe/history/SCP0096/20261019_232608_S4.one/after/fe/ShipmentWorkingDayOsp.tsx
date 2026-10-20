// SCP0096 Shipment_Working_Day_OSP — TobeGen 생성 골격 (As-is SCP0096_Shipment_Working_Day_OSP, Fact Pack Doc/asisfacts/screens/SCP0096)
//   생성기: tools/Harness/gen.js · 사전: tools/Harness/rules/ · 수정 지점은 TODO(이식) 주석 — 그 외는 사전 규칙이므로 손대지 말 것
import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useCallback, useEffect, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { ShipmentWorkingDayOspForm } from './components/ShipmentWorkingDayOspForm';
import { ShipmentWorkingDayOspGrid } from './components/ShipmentWorkingDayOspGrid';
import type { RESPONSE_SET } from './shipment-working-day-osp.constants';
import { MENU_ID, SHEETS } from './shipment-working-day-osp.constants';
import { useShipmentWorkingDayOspStore } from './useShipmentWorkingDayOspStore';

export const ShipmentWorkingDayOsp = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const gridRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.SHIPMENT_WORKING_DAY_OSP, RESPONSE_SET.MAIN>>>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const setAlert = useMessageStore.getState().setAlert;

  const filters = useShipmentWorkingDayOspStore(state => state.filters);
  const setFilters = useShipmentWorkingDayOspStore(state => state.setFilters);
  const searchParams = useShipmentWorkingDayOspStore(state => state.searchParams);
  const staticColumns = useShipmentWorkingDayOspStore(state => state.staticColumns);
  const fetchStaticColumns = useShipmentWorkingDayOspStore(state => state.fetchStaticColumns);
  const isOpenSearchArea = useShipmentWorkingDayOspStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useShipmentWorkingDayOspStore(state => state.setOpenSearchArea);

  // spdMain ← 시트 'Shipment Working Day OSP'. As-is 조회 SP: DM0003_GET_BUCKET_TYPE_CODE, SCP0096_GET_SHIPMENT_WORKING_DAY_OSP, SCP0009_GET_SHEET_CALENDAR_3SPAN
  const { data: data } = useTabProcQuery<MENU_ID>({
    menuId: MENU_ID,
    sheetName: SHEETS.SHIPMENT_WORKING_DAY_OSP,
    tabId,
    filters,
    enabled: filters !== undefined,
  });
  // As-is 저장 SP 없음 — 조회 전용 화면 (useProcMutation 미사용)

  // As-is this.Load (Form_Load) → 메타 컬럼 + 저장된 조회조건
  useEffect(() => {
    void fetchStaticColumns();
  }, [tabId, fetchStaticColumns]);

  // AS-IS BtnInput_Click (SCP0096_Shipment_Working_Day_OSP.cs:684-809) — cboDayWeek(SelectDay/EveryDay/요일코드)
  //   × cboInputValue(Y/N) 로 D_YYYYMMDD 셀을 일괄 입력한다. "SelectDay" = 선택 영역, "EveryDay" = 전체 행,
  //   그 외 = 컬럼의 DAY_CODE(요일) 가 일치하는 셀만. 요일 미선택이면 Form 이 cboInputValue 를 비활성화한다.
  const handleInput = useCallback((): void => {
    const grid = gridRef.current;
    if (!grid) return;
    // AS-IS cs:686-691 수정모드가 아니면 입력 불가(MSG00135). To-Be 는 DataGrid 가 isReadOnly 로 셀 편집을
    //   잠그므로, columns[0](선택적 CRUD 플래그) 가 숨겨져 있으면 수정모드 아님으로 간주.
    if (grid.columns[0]?.visible === false) {
      void setAlert({ type: 'alert', content: t('MSG00135', '_수정모드가 아니므로 입력할 수 없습니다.') });
      return;
    }
    const dayWeekCode = searchParams.dayWeek;
    const inputValue = searchParams.inputValue;
    // AS-IS cs:710-713 요일 미선택이면 무시(Form 에서 cboInputValue disabled 1차 차단, 방어적 재확인).
    if (!dayWeekCode) return;
    // AS-IS cs:700-707 "SelectDay" 는 셀 선택이 반드시 있어야(MSG00134).
    const ranges = grid.selectedRanges;
    if (dayWeekCode === 'SelectDay' && (!ranges || ranges.length === 0)) {
      void setAlert({ type: 'alert', content: t('MSG00134', '_날짜 선택 후 입력하세요.') });
      return;
    }

    const isDayCol = (binding: string | null | undefined): boolean =>
      typeof binding === 'string' && binding.startsWith('D_');
    const writeCell = (row: number, col: number): void => {
      if (!isDayCol(grid.columns[col]?.binding)) return;
      grid.setCellData(row, col, inputValue, true);
    };

    grid.deferUpdate(() => {
      // AS-IS cs:729-779 "SelectDay": 선택 범위를 row/col 조합으로 분기 — row 선택(모든 D_), col 선택(모든 row),
      //   셀 선택(교집합). topRow/bottomRow/leftCol/rightCol 은 음수가 아니므로 분기 없이 교집합 루프로 흡수.
      if (dayWeekCode === 'SelectDay') {
        for (const r of ranges) {
          for (let row = r.topRow; row <= r.bottomRow; row++) {
            for (let col = r.leftCol; col <= r.rightCol; col++) writeCell(row, col);
          }
        }
        return;
      }
      // AS-IS cs:784-807 "EveryDay" = 전체 D_ 셀, 그 외 = 컬럼 header 의 DAY_CODE(요일) 가 일치하는 셀만.
      //   컬럼 메타의 요일코드는 header DAY_CODE / dsSpdTitle(SCP0009) 로부터 온다 — To-Be 는 메타가 column
      //   dataMap 또는 header 에 심겨 있지 않으므로, 컬럼명 D_YYYYMMDD 에서 Date 로 복원해 요일을 산출한다.
      const DAY_LABEL = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
      const colDayCode = (binding: string): string => {
        const m = binding.match(/^D_(\d{4})(\d{2})(\d{2})$/);
        if (!m) return '';
        const d = new Date(Number(m[1]), Number(m[2]) - 1, Number(m[3]));
        return DAY_LABEL[d.getDay()] ?? '';
      };
      for (let row = 0; row < grid.rows.length; row++) {
        for (let col = 0; col < grid.columns.length; col++) {
          const binding = grid.columns[col]?.binding ?? '';
          if (!isDayCol(binding)) continue;
          if (dayWeekCode === 'EveryDay') writeCell(row, col);
          else if (colDayCode(binding).toUpperCase() === dayWeekCode.toUpperCase()) writeCell(row, col);
        }
      }
    });
    grid.invalidate(true);
  }, [searchParams.dayWeek, searchParams.inputValue, setAlert, t]);

  // AS-IS SaveButton SCP0096_Shipment_Working_Day_OSP.cs:299 4줄 — 저장 SP(SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP) 가
  //   Fact Pack endpoints 에 비포함(request.UpdateQueryId 문자열 지정 패턴으로 추출 누락) → PKG 신규 등록 후 배선
  const handleSave = () => {
    // TODO(이식): As-is SaveData_Main — PKG_SCP0096.P_SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP 등록 후 배선
  };
  // AS-IS EditButton SCP0096_Shipment_Working_Day_OSP.cs:282 16줄 — hotkeyConfig 미지원: DataGrid 자체 edit 토글로 흡수

  // AS-IS 빈 override(기능 비활성으로 해석 → false): InsertButton(cs:274 3줄 빈 본문), DeleteButton(cs:278 3줄 빈 본문)
  // 공통 버튼 — As-is BaseForm override 근거(members.csv). 룰 25 §1.5.1/§1.5.3: 정의 없는 키는 false 명시(silent omit 금지)
  const hotkeyConfig: HotkeyConfig = {
    search: setFilters, // AS-IS FindButton (SCP0096_Shipment_Working_Day_OSP.cs:269 4줄)
    save: handleSave, // AS-IS SaveButton SCP0096_Shipment_Working_Day_OSP.cs:299 4줄
    insert: false, // AS-IS InsertButton 미정의
    delete: false, // AS-IS DeleteButton 미정의
    excel: false, // AS-IS ExcelButton 미정의
    upload: false, // AS-IS Upload/ImportButton 미정의
    manual: false,
    // condition/resetCondition: (생략 = 기본 활성) AS-IS UsrConditionPanel 있음
  };

  // As-is 화면 버튼 → SubTitle customButtons (dmf0045 선례). 라벨은 LBL 코드, 동작은 위 핸들러.
  //   AS-IS usrButton1 (D00-1-001) 은 events.csv 에 핸들러 바인딩 없음 → 미노출(해당없음).
  const customButtons = [
    { label: t('LBL00872', '_Input'), action: handleInput }, // AS-IS btnInput (SCP0096_Shipment_Working_Day_OSP.Designer.cs:btnInput)
  ];
  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <ShipmentWorkingDayOspForm />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={data?.o_rc?.length ?? 0}
        excelFileName='Shipment_Working_Day_OSP'
        hotkeyConfig={hotkeyConfig}
        searchParam={filters as Record<string, string> | undefined}
        customButtons={customButtons}
      />
      <ShipmentWorkingDayOspGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        data={data?.o_rc ?? []}
        staticColumns={staticColumns}
        sumYn={searchParams.sumYn}
      />
    </>
  );
};
