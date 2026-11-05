import { type CellRangeEventArgs, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, type MutableRefObject } from 'react';

import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import type { MENU_ID, SHEETS } from '../plant-site.constants';
import { MSG, SHEET_INDEX } from '../plant-site.constants';
import { usePlantSiteStore } from '../usePlantSiteStore';
import { COMBO, ELECTRODE_TYPE_LOOKUP_TYPE } from '../utils/plant-site.plantSiteCombo';
import { str } from '../utils/plant-site.util';

type LocationRow = ResponseData<MENU_ID, SHEETS.LOCATION, 'o_rc1'>;

interface PlantSiteLocationGridProps {
  gridRef: MutableRefObject<FlexGrid<LocationRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: LocationRow[];
  setActiveTab: (tab: SHEET_INDEX) => void;
  isMainDirty: () => boolean;
}

// 붙여넣기 name->code 역매핑 대상 셀콤보(R-31, AS-IS cs:2209-2232). 나머지 컬럼은 정방향 그대로.
const PASTE_REVERSE_BINDINGS = ['LOCATION_CODE2', 'FACTORY_ID2', 'OPERATION_ID2', 'STORAGE_ID'];

// 셀의 콤보 표시명(CODE->NAME) 조회 — 파생 컬럼(코드/명칭) 채움용.
const displayOf = (grid: FlexGrid<LocationRow>, binding: string, code: unknown): string => {
  const dm = grid.columns.getColumn(binding)?.dataMap;
  const name = dm?.getDisplayValue(code);
  return typeof name === 'string' && name !== '' ? name : str(code);
};

export const PlantSiteLocationGrid = ({
  gridRef,
  gridFilterRef,
  data,
  setActiveTab,
  isMainDirty,
}: PlantSiteLocationGridProps) => {
  const { t } = useTranslation();
  const editTrackerRef = useRef<EditTracker<LocationRow> | undefined>();

  const staticColumns = usePlantSiteStore(state => state.staticColumns);
  const selectedSite = usePlantSiteStore(state => state.selectedSite);
  const { setAlert } = useMessageStore.getState();

  // ELECTRODE_TYPE 셀 콤보 후보 화면 직접 조회 — 공용 DataGrid 자동 콤보가 컬럼별 ATTRIBUTE1(lookupType)을
  //   읽지 못해 늘 빈 후보를 받는 결함 우회(plant-site.plantSiteCombo.ts 주석).
  const [electrodeTypeRows] = useTabComboQueries({
    filters: [{ comboId: COMBO.LOOKUP_COMMON, lookupType: ELECTRODE_TYPE_LOOKUP_TYPE, mnuId: 'SCP0001' }],
  });
  const locationColumns = useMemo(() => {
    if (electrodeTypeRows === undefined) return staticColumns.location;
    return staticColumns.location.map(col =>
      col.colNm === 'ELECTRODE_TYPE'
        ? { ...col, cellCboDataTp: undefined, dataMap: electrodeTypeRows }
        : col
    );
  }, [staticColumns.location, electrodeTypeRows]);

  const handleFocus = () => setActiveTab(SHEET_INDEX.LOCATION);

  // location 셀콤보 4종 마스터 컨텍스트(design 03 §1.5-B B안) — 마스터 선택 시 comboParams 로 주입.
  //   Location(@segment1=OP.Group) / BuildingByPlant(@plantId) / OperationByBuilding(@divisionId,
  //   @pPlantSiteId) / StorageID(@divisionId,@plantId). 마스터 행 변경 시 객체가 바뀌어 재조회된다.
  const comboParams = useMemo(
    () => ({
      mnuId: 'SCP0001',
      divisionId: selectedSite?.divisionId ?? '',
      plantId: selectedSite?.plantId ?? '',
      pPlantSiteId: selectedSite?.scmSiteId ?? '',
      segment1: selectedSite?.operationGroup ?? '',
    }),
    [selectedSite]
  );

  // 편집 배타 가드 — R-06①(main dirty 시 sub 편집 차단) + R-06②(외주 site 는 Location 불가).
  //   붙여넣기(pastingCell)도 동일 배타 게이트를 통과해야 한다(alert 없이 차단 — 다중 셀 paste 알림 반복 방지).
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;
    const handler = (_s: FlexGrid<LocationRow>, e: CellRangeEventArgs) => {
      // R-06①(G6): 상단 site 그리드에 미저장 변경이 있으면 하단 편집 차단(AS-IS cs:556-560).
      if (isMainDirty()) {
        e.cancel = true;
        void setAlert({
          type: 'alert',
          content: t(MSG.MAIN_SUB_EDIT_NOTICE, '_상단 그리드의 변경사항을 먼저 저장하세요.'),
        });
        return;
      }
      // R-06②: 외주(OSP_YN='Y') 마스터 선택 상태에서는 Location 편집 차단.
      if (selectedSite?.ospYn === 'Y') {
        e.cancel = true;
        void setAlert({
          type: 'alert',
          content: t(MSG.NO_LOCATION_FOR_OSP, '_Outsourcing Vendor는 Location을 등록할 수 없습니다.'),
        });
      }
    };
    const pasteHandler = (_s: FlexGrid<LocationRow>, e: CellRangeEventArgs) => {
      if (isMainDirty() || selectedSite?.ospYn === 'Y') e.cancel = true;
    };
    grid.beginningEdit.addHandler(handler);
    grid.pastingCell.addHandler(pasteHandler);
    return () => {
      grid.beginningEdit.removeHandler(handler);
      grid.pastingCell.removeHandler(pasteHandler);
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [selectedSite]);

  // cascade — R-11(Location)·R-12(Factory+하위리셋)·R-13(Operation+Storage리셋)·R-14(Storage 배타).
  const handleCellEdit = (grid: FlexGrid<LocationRow>, e: CellRangeEventArgs) => {
    const binding = grid.columns[e.col]?.binding;
    const row = GridUtils.getRow(grid, e.row);
    if (!binding || !row) return;

    if (binding === 'LOCATION_CODE2') {
      row.LOCATION_CODE = str(row.LOCATION_CODE2);
      row.LOCATION_DESCRIPTION = displayOf(grid, 'LOCATION_CODE2', row.LOCATION_CODE2);
      GridUtils.refreshRow(grid, e.row);
      return;
    }
    if (binding === 'FACTORY_ID2') {
      // R-12(교정 §6-8①): FACTORY_NAME 은 FACTORY_ID2 표시명에서 읽는다(AS-IS 오배선 교정).
      row.FACTORY_ID = str(row.FACTORY_ID2);
      row.FACTORY_NAME = displayOf(grid, 'FACTORY_ID2', row.FACTORY_ID2);
      row.OPERATION_ID = '';
      row.OPERATION_ID2 = '';
      row.STORAGE_ID = '';
      GridUtils.refreshRow(grid, e.row);
      return;
    }
    if (binding === 'OPERATION_ID2') {
      row.OPERATION_ID = str(row.OPERATION_ID2);
      row.STORAGE_ID = '';
      GridUtils.refreshRow(grid, e.row);
      return;
    }
    if (binding === 'STORAGE_ID' && str(row.STORAGE_ID)) {
      // R-14: Storage 지정 시 Factory/Operation/Electrode 상호배타 클리어.
      row.FACTORY_ID = '';
      row.FACTORY_ID2 = '';
      row.OPERATION_ID = '';
      row.OPERATION_ID2 = '';
      row.ELECTRODE_TYPE = '';
      GridUtils.refreshRow(grid, e.row);
    }
  };

  // R-31(G4): 붙여넣기 표시명(name)->코드(code) 역매핑과 "후보 밖 값 클리어"는 공용 DataGrid 가
  //   담당한다(wijmo dataMap coerce + clearOutOfListComboOnPaste). 과거 이 핸들러가 getKeyValue 로
  //   한 번 더 역조회했는데, 공용이 이미 코드로 바꿔 둔 값을 '이름'으로 간주해 재역조회하는 바람에
  //   드롭다운에 있는 유효 값까지 "존재하지 않음"으로 지워졌다(2026-10-29 실사고, Location·Building 등).
  //   여기서는 (a) 후보 밖이라 공용이 셀을 비웠으면 경고만 띄우고({0}=컬럼 라벨명), (b) 파생
  //   cascade(코드/명칭·하위 리셋)를 태운다. (빈 값을 붙여넣어 비는 드문 경우에도 경고가 뜰 수 있다.)
  const handlePaste = (grid: FlexGrid<LocationRow>, e: CellRangeEventArgs) => {
    const binding = grid.columns[e.col]?.binding;
    const row = GridUtils.getRow(grid, e.row);
    if (!binding || !row) return;

    if (
      PASTE_REVERSE_BINDINGS.includes(binding) &&
      str((row as Record<string, unknown>)[binding]) === ''
    ) {
      void setAlert({
        type: 'alert',
        // DB 메시지 자리표시는 `{0}`(i18next `{{ }}` 보간이 아님)이라 직접 치환한다({0}=컬럼 라벨명).
        content: t(MSG.PASTE_NOT_FOUND, '_목록에 없는 값입니다.').replace(
          '{0}',
          str(grid.columns[e.col]?.header) || binding
        ),
      });
    }
    handleCellEdit(grid, e);
  };

  return (
    <DataGrid<LocationRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={locationColumns}
      comboParams={comboParams}
      gotFocus={handleFocus}
      cellEditEnded={handleCellEdit}
      pastedCell={handlePaste}
    />
  );
};
