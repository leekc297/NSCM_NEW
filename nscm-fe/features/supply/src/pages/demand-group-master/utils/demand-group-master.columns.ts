import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { ComboResponse, RawFlexGridColumnConfig } from '@foundation/models';

export interface CustomComboOption {
  label: string;
  value: string;
}

/**
 * 그리드 정적 컬럼 가공 — 편집범위 선언 + 셀 콤보 dataMap 주입.
 *
 * 편집범위(§11 EditButton 미이식 — 편집모드 상태 없이 컬럼 조건만으로 판정):
 *   SCM_MST_SHEET_COLUMNS 는 전열 INPUT_TP_CD='S'(전셀 잠금)라 공용 DataGrid isEditableCell 이
 *   모든 편집을 막는다(메모리 scp-sheet-columns-input-tp-all-s-edit-dead). AS-IS 는 SwitchLock 로
 *   코드에서 편집구간을 열었으므로, DB 메타 UPDATE(승인 필요) 대신 FE 에서 편집 컬럼만
 *   INPUT_TP_CD='O'(OPTIONAL)로 재선언한다 — cust-psi-upload(DMF0014) wrapper-override 선례와 동일.
 *   나머지 키 컬럼은 'S' 유지(AS-IS LockColumn 범위 재현).
 *
 * 셀 콤보: 메타 CELL_COMBO_DATA_TYPE 은 OPERATION_GROUP='LookupCommon'(@lookupType 미지원)·
 *   GROUP_ID='GroupMaster'(SQL_ID 미등록)이라 공용 자동 콤보로는 후보가 안 뜬다. 자동 콤보(cellCboDataTp)를
 *   끄고 화면이 만든 후보(ComboResponse[])만 dataMap 으로 주입한다
 *   (columnMapping.buildLeafColumnDataMap 이 DataMap 으로 변환).
 */
export const buildGridColumns = (
  columns: RawFlexGridColumnConfig[],
  editableColNms: readonly string[],
  comboByColNm: Record<string, ComboResponse[] | undefined>
): RawFlexGridColumnConfig[] =>
  columns.map(col => {
    const rows = comboByColNm[col.colNm];
    return {
      ...col,
      inputTpCd: editableColNms.includes(col.colNm)
        ? CELL_INPUT_EDIT_TYPE.OPTIONAL
        : CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
      ...(rows ? { cellCboDataTp: undefined, dataMap: rows } : {}),
    };
  });
