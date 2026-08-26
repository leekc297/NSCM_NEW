import type { Aggregate, Control, DataType } from '@mescius/wijmo';
import type { DataMap } from '@mescius/wijmo.grid';

import type { CELL_CONTROL_TYPE, CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { ComboResponse } from '@foundation/models';

export interface RawFlexGridColumnConfig {
  colNm: string;
  colLblNm: string;
  horzAlgnCd?: 'L' | 'R' | 'C';
  cellCtrlObjTpCd?: CELL_CONTROL_TYPE;
  cellCboDataTp?: string;
  scale?: number;
  inputTpCd?: CELL_INPUT_EDIT_TYPE;
  colWth?: number;
  fixed?: boolean;
  uppercase?: boolean;
  visible?: boolean;
  display?: boolean;
  defaultFlag?: boolean;
  personalizable?: boolean;
  // 개인화(ColumnLayoutModal) — 사용자 지정 셀 배경/글자색 hex ('' 또는 undefined = 기본색)
  cellColor?: string;
  textColor?: string;
  sClsLblNm?: string;
  lClsLblNm?: string;
  dataMap?: ComboResponse[];
  allowMerging?: boolean;
  attribute1?: string;
  attribute2?: string;
  attribute3?: string;
  attribute4?: string;
  attribute5?: string;
  attribute6?: string;
  attribute7?: string;
  attribute8?: string;
  attribute9?: string;
  attribute10?: string;
}

export interface FlexGridColumnConfig {
  header: string;
  binding?: string;
  aggregate?: Aggregate | string;
  align?: string;
  allowDragging?: boolean;
  allowMerging?: boolean;
  allowResizing?: boolean;
  allowSorting?: boolean;
  format?: string; // .NET Globalization lib
  isReadOnly?: boolean;
  isRequired?: boolean;
  visible?: boolean;
  minWidth?: number;
  width?: number;
  collapseTo?: string;
  isCollapsed?: boolean;
  columns?: FlexGridColumnConfig[];
  _inputEditType?: CELL_INPUT_EDIT_TYPE;
  /** 화면이 직접 만든 동적(주차/월/일) 컬럼 — DataGrid 가 dynamicColumns leaf 에 자동으로 채운다. */
  _dynamic?: boolean;
  /** 관리자 메타 라벨 끝에 `*` 가 박혀 있던 컬럼 — 라벨에서 떼어내고 헤더 빨간점으로 표시한다. */
  _requiredMark?: boolean;
  _ctrlType?: CELL_CONTROL_TYPE;
  _ctrlData?: string;
  _fixed?: boolean;
  _uppercase?: boolean;
  _display?: boolean;
  _personalizable?: boolean;
  _sClsLblNm?: string;
  _lClsLblNm?: string;
  dataMap?: DataMap | string[];
  editor?: Control;
  multiLine?: boolean;
  wordWrap?: boolean;
  dataType?: DataType;
  height?: number;
}
