import { type FlexGrid } from '@mescius/wijmo.grid';
import { type FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useMemo, useRef, type MutableRefObject } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import type { MENU_ID, RESPONSE_SET, SHEETS } from '../lookup.constants';
import { useLookupStore } from '../useLookupStore';

interface LookupDetailGridProps {
  gridRef: MutableRefObject<
    FlexGrid<ResponseData<MENU_ID, SHEETS.LOOKUP_DETAIL, RESPONSE_SET.SAVE>> | undefined
  >;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  /**
   * 저장 시 세그먼트 원본값(UPDATE 키)을 읽어야 해서 화면이 tracker 를 넘겨받는다.
   * 미지정이면 내부 ref 를 쓴다.
   */
  editTrackerRef?: MutableRefObject<
    EditTracker<ResponseData<MENU_ID, SHEETS.LOOKUP_DETAIL, RESPONSE_SET.SAVE>> | undefined
  >;
  data: ResponseData<MENU_ID, SHEETS.LOOKUP_DETAIL, RESPONSE_SET.SAVE>[];
}

export const LookupDetailGrid = ({
  gridRef,
  gridFilterRef,
  editTrackerRef,
  data,
}: LookupDetailGridProps) => {
  const internalEditTrackerRef =
    useRef<EditTracker<ResponseData<MENU_ID, SHEETS.LOOKUP_DETAIL, RESPONSE_SET.SAVE>>>();

  const baseColumns = useLookupStore(state => state.staticColumns.lookupDetail);
  const dynamicColumnLabels = useLookupStore(state => state.dynamicColumnLabels);
  const hiddenSubColumns = useLookupStore(state => state.hiddenSubColumns);
  const setActiveGrid = useLookupStore(state => state.setActiveGrid);

  const staticColumns = useMemo<RawFlexGridColumnConfig[]>(() => {
    return baseColumns.map(col => {
      const field = col.colNm;
      if (!field) return col;
      const overriddenLabel = dynamicColumnLabels[field];
      const hidden = !!hiddenSubColumns[field];
      const visible = hidden ? false : (col.visible ?? true);
      if (overriddenLabel === undefined && visible === (col.visible ?? true)) {
        return col;
      }
      return {
        ...col,
        ...(overriddenLabel !== undefined ? { colLblNm: overriddenLabel } : {}),
        visible,
      };
    });
  }, [baseColumns, dynamicColumnLabels, hiddenSubColumns]);

  const handleGotFocus = () => {
    setActiveGrid('sub');
  };

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.LOOKUP_DETAIL, RESPONSE_SET.SAVE>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef ?? internalEditTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns}
      gotFocus={handleGotFocus}
    />
  );
};
