import type { Control } from '@mescius/wijmo';
import { DataType } from '@mescius/wijmo';
import { LinearGauge } from '@mescius/wijmo.gauge';
import { DataMap } from '@mescius/wijmo.grid';
import { InputDateTime } from '@mescius/wijmo.input';

import { CELL_CONTROL_TYPE } from '@foundation/constants';
import type {
  ComboResponse,
  FlexGridColumnConfig,
  RawFlexGridColumnConfig,
} from '@foundation/models';

const alignMap = {
  L: 'left',
  R: 'right',
  C: 'center',
};

enum COLUMN_DEPTH {
  ONE_DEPTH = 1,
  TWO_DEPTH = 2,
  THREE_DEPTH = 3,
}

enum HEIGHT_BY_COLUMN_DEPTH {
  ONE_DEPTH = 48,
  TWO_DEPTH = 24,
  THREE_DEPTH = 16,
}

const getDataType = (ctrlType: CELL_CONTROL_TYPE): DataType | undefined => {
  switch (ctrlType) {
    case CELL_CONTROL_TYPE.NUMBER:
    case CELL_CONTROL_TYPE.NUMBER_TEXT:
      return DataType.Number;
    case CELL_CONTROL_TYPE.CHECKBOX:
      // TODO: 체크박스 디자인 조절 필요 + 값 매핑 필요
      return DataType.Boolean;
    default:
      return undefined;
  }
};

const getFormat = (
  ctrlType: CELL_CONTROL_TYPE | undefined,
  scale: number | undefined
): string | undefined => {
  // TODO: 숫자 외의 다른 format 필요 시 추가 - 강민재
  if (ctrlType === CELL_CONTROL_TYPE.NUMBER && scale) return `n${scale}`;
  if (ctrlType === CELL_CONTROL_TYPE.NUMBER_TEXT) return 'd0';
  return undefined;
};

const getEditor = (ctrlType: CELL_CONTROL_TYPE): Control | undefined => {
  switch (ctrlType) {
    // TODO: 테스트 필요, 투머치면 빼기
    case CELL_CONTROL_TYPE.PERCENT:
      return new LinearGauge(document.createElement('div'), {
        min: 0,
        max: 100,
      });
    // TODO: 날짜 형식에 따른 format 설정 필요 + 날짜 버튼 디자인 조절 필요
    case CELL_CONTROL_TYPE.DATE:
    case CELL_CONTROL_TYPE.DATE_MONTH:
    case CELL_CONTROL_TYPE.DATE_TIME:
    case CELL_CONTROL_TYPE.DATE_TEXT:
      return new InputDateTime(document.createElement('div'), {
        format: 'yyyy-MM-dd HH:mm:ss',
        isReadOnly: false,
      });
    default:
      break;
  }

  return undefined;
};

const parseBindingString = (bindingString?: string): Record<string, string> => {
  if (!bindingString?.trim()) return {};

  const entries = bindingString.split(',').map(token => token.trim());
  if (entries.length === 0) return {};

  const result: Record<string, string> = {};

  for (const entry of entries) {
    if (!entry) return {};

    const bindingAndKey = entry.split(':');
    if (bindingAndKey.length !== 2) return {};

    const bindingOfRow = bindingAndKey[0].trim();
    const keyOfDataMap = bindingAndKey[1].trim();
    if (!bindingOfRow || !keyOfDataMap) return {};

    result[bindingOfRow] = keyOfDataMap;
  }

  return result;
};

const getDataMap = (dataMap: ComboResponse[] | undefined, bindingString?: string) => {
  if (!dataMap || dataMap.length === 0) return undefined;

  const wjDataMap = new DataMap(dataMap, 'CODE', 'NAME');
  if (!bindingString) return wjDataMap;

  const bindingMap = parseBindingString(bindingString);
  const filters = Object.entries(bindingMap);
  if (filters.length <= 0) return wjDataMap;

  wjDataMap.getDisplayValues = (rowItem: WijmoRowItem) => {
    return dataMap
      .filter(dataMapItem =>
        filters.every(
          ([bindingOfRow, keyOfDataMap]) => rowItem[bindingOfRow] === dataMapItem[keyOfDataMap]
        )
      )
      .map(item => item.NAME);
  };

  return wjDataMap;
};

const getColumnDepth = (rawColumns: RawFlexGridColumnConfig[]) => {
  if (
    rawColumns.every(
      rawCol =>
        ((!rawCol.sClsLblNm || rawCol.sClsLblNm.trim() === '') &&
          (!rawCol.lClsLblNm || rawCol.lClsLblNm.trim() === '')) ||
        (rawCol.colLblNm === rawCol.sClsLblNm && rawCol.sClsLblNm === rawCol.lClsLblNm)
    )
  )
    return COLUMN_DEPTH.ONE_DEPTH;
  else if (
    rawColumns.every(
      rawCol =>
        !rawCol.lClsLblNm || rawCol.lClsLblNm.trim() === '' || rawCol.sClsLblNm === rawCol.lClsLblNm
    )
  )
    return COLUMN_DEPTH.TWO_DEPTH;

  return COLUMN_DEPTH.THREE_DEPTH;
};

const toLeafColumn = (column: RawFlexGridColumnConfig): FlexGridColumnConfig => ({
  binding: column.colNm,
  header: column.colLblNm,
  align: alignMap[column.horzAlgnCd ?? 'L'],
  allowDragging: true,
  allowMerging: column.allowMerging ?? true,
  allowResizing: true,
  allowSorting: false,
  // TODO: 숫자 외의 다른 format 필요 시 추가 - 강민재
  format: getFormat(column.cellCtrlObjTpCd, column.scale),
  width: column.colWth,
  visible: column.visible,
  _inputEditType: column.inputTpCd,
  _ctrlType: column.cellCtrlObjTpCd,
  _ctrlData: column.cellCboDataTp,
  _fixed: column.fixed,
  _uppercase: column.uppercase,
  _display: column.display,
  _personalizable: column.personalizable,
  _sClsLblNm: column.sClsLblNm,
  _lClsLblNm: column.lClsLblNm,
  dataMap: getDataMap(column.dataMap, column.attribute2),
  isRequired: false, // TODO: 논의 필요..? -강민재
  editor: column.cellCtrlObjTpCd ? getEditor(column.cellCtrlObjTpCd) : undefined,
  dataType: column.cellCtrlObjTpCd ? getDataType(column.cellCtrlObjTpCd) : undefined,
  multiLine: column.cellCtrlObjTpCd === CELL_CONTROL_TYPE.MULTILINE_TEXT,
  wordWrap: column.cellCtrlObjTpCd === CELL_CONTROL_TYPE.MULTILINE_TEXT,
});

export const mapRawColumnsToWijmoColumns = (
  rawColumns: RawFlexGridColumnConfig[]
): Array<FlexGridColumnConfig> => {
  const columnDepth = getColumnDepth(rawColumns);

  const mappedResult: Array<FlexGridColumnConfig> = [];

  switch (columnDepth) {
    case COLUMN_DEPTH.ONE_DEPTH:
      rawColumns.forEach(rawColumn =>
        mappedResult.push({ ...toLeafColumn(rawColumn), height: HEIGHT_BY_COLUMN_DEPTH.ONE_DEPTH })
      );
      break;
    case COLUMN_DEPTH.TWO_DEPTH: {
      const smallGroups = [
        ...new Set(
          rawColumns.map(rawColumn =>
            rawColumn.sClsLblNm ? rawColumn.sClsLblNm : rawColumn.colLblNm
          )
        ).values(),
      ];
      smallGroups.forEach(smallGroupLabel =>
        mappedResult.push({
          header: smallGroupLabel,
          align: 'center',
          columns: [],
          height: HEIGHT_BY_COLUMN_DEPTH.TWO_DEPTH,
        })
      );

      rawColumns.forEach(rawColumn =>
        mappedResult
          .find(smallGroup =>
            rawColumn.sClsLblNm && rawColumn.sClsLblNm !== ''
              ? smallGroup.header === rawColumn.sClsLblNm
              : smallGroup.header === rawColumn.colLblNm
          )
          ?.columns?.push({ ...toLeafColumn(rawColumn), height: HEIGHT_BY_COLUMN_DEPTH.TWO_DEPTH })
      );

      break;
    }
    case COLUMN_DEPTH.THREE_DEPTH: {
      const largeGroups = [
        ...new Set(rawColumns.map(rawColumn => rawColumn.lClsLblNm ?? rawColumn.colLblNm)).values(),
      ];
      largeGroups.forEach(largeGroupLabel =>
        mappedResult.push({
          header: largeGroupLabel,
          align: 'center',
          columns: [],
          height: HEIGHT_BY_COLUMN_DEPTH.THREE_DEPTH,
        })
      );

      rawColumns.forEach(rawColumn => {
        const largeGroupLabel = rawColumn.lClsLblNm ?? rawColumn.colLblNm;
        const smallGroupLabel = rawColumn.sClsLblNm ?? rawColumn.colLblNm;

        const targetLargeGroup = mappedResult.find(
          largeGroup => largeGroup.header === largeGroupLabel
        );
        if (!targetLargeGroup?.columns) return;

        let targetSmallGroup = targetLargeGroup.columns.find(
          smallGroup => smallGroup.header === smallGroupLabel
        );
        if (!targetSmallGroup) {
          targetSmallGroup = { header: smallGroupLabel, align: 'center', columns: [] };
          targetLargeGroup.columns.push({
            ...targetSmallGroup,
            height: HEIGHT_BY_COLUMN_DEPTH.THREE_DEPTH,
          });
        }

        targetSmallGroup.columns?.push({
          ...toLeafColumn(rawColumn),
          height: HEIGHT_BY_COLUMN_DEPTH.THREE_DEPTH,
        });
      });

      break;
    }
    default:
      break;
  }

  return mappedResult;
};
