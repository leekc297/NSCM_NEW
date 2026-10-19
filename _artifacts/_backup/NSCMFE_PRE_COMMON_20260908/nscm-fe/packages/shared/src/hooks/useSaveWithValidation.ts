import { CELL_INPUT_EDIT_TYPE, CRUD_MSG, CRUD_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { hasRequiredMark, stripRequiredMark } from '@foundation/utils';
import { useMessageStore } from '@shared/stores';

// 공백만 있는 문자열도 미입력으로 본다 — 사용자가 스페이스만 친 셀이 필수 검증을 통과하면 안 된다.
const isBlank = (value: unknown): boolean =>
  value === null || value === undefined || (typeof value === 'string' && value.trim() === '');

// 필수 컬럼 판정 — 헤더 빨간 점(dataGridUtils.formatEditableColumns)과 반드시 같은 조건이어야 한다.
//   메타 등록 방식이 화면마다 둘로 갈린다: inputTpCd = M / IM, 또는 라벨(colLblNm) 끝의 `*`
//   (AS-IS 잔재 — columnMapping 이 `*` 를 떼어 _requiredMark 로 옮긴다).
//   한쪽만 보면 점은 찍히는데 저장은 그냥 통과하는 상태가 된다.
// 주의: 여기 들어오는 staticColumns 는 columnMapping 을 거치기 전 raw 라 _requiredMark 가 아직 없다.
//   그래서 라벨 원본에 hasRequiredMark 를 직접 건다.
export const isMandatoryColumn = (column: RawFlexGridColumnConfig): boolean =>
  column.inputTpCd === CELL_INPUT_EDIT_TYPE.MANDATORY ||
  column.inputTpCd === CELL_INPUT_EDIT_TYPE.MANDATORY_INSERT_ONLY ||
  hasRequiredMark(column.colLblNm);

// 그 행에서 사용자가 실제로 채울 수 있는 셀인가 — GridUtils.isEditableCell 과 같은 규칙을
//   grid 대신 raw 메타/행 데이터로 판정한 것이다.
// 필수 표시가 있어도 편집할 수 없는 셀은 검증하지 않는다. 막아봐야 사용자가 값을 넣을 방법이
//   없어 저장이 영구히 불가능해진다 (읽기전용인데 라벨에 `*` 만 붙은 컬럼이 실제로 있다).
export const isEditableForRow = (column: RawFlexGridColumnConfig, row: WijmoRowItem): boolean => {
  if (row.EDIT_FLAG === 'N') return false;
  switch (column.inputTpCd) {
    case CELL_INPUT_EDIT_TYPE.MANDATORY:
    case CELL_INPUT_EDIT_TYPE.OPTIONAL:
      return true;
    case CELL_INPUT_EDIT_TYPE.MANDATORY_INSERT_ONLY:
    case CELL_INPUT_EDIT_TYPE.OPTIONAL_INSERT_ONLY:
      return row.CRUD_TYPE === CRUD_TYPE.INSERT;
    // SEARCH_ONLY / 미등록 — 라벨에 `*` 가 있어도 채울 수 없으므로 대상 아님
    default:
      return false;
  }
};

// 필수인데 값이 빈 첫 컬럼을 돌려준다 (없으면 undefined).
//   누락 전체를 모아 보여주지 않고 첫 1건만 알린다.
const findMissingMandatory = <T>(
  saveData: T[],
  staticColumns: RawFlexGridColumnConfig[]
): RawFlexGridColumnConfig | undefined => {
  const mandatoryColumns = staticColumns.filter(isMandatoryColumn);

  if (mandatoryColumns.length <= 0) return undefined;

  for (const row of saveData) {
    const rowItem = row as WijmoRowItem;
    const missing = mandatoryColumns.find(
      col => isEditableForRow(col, rowItem) && isBlank(rowItem[col.colNm])
    );
    if (missing) return missing;
  }

  return undefined;
};

export const useSaveWithValidation = () => {
  // 검증 실패는 Alert — 사용자가 읽고 넘어가야 하는 메시지다.
  //   저장 성공/실패 Toast(useCustomQueryClient)와 달리 자동으로 사라지면 안 된다.
  const setAlert = useMessageStore(state => state.setAlert);
  const { t } = useTranslation();

  const saveWithValidation = <T>(
    saveData: T[] | undefined,
    staticColumns: RawFlexGridColumnConfig[],
    mutate: (data: T[]) => void
  ) => {
    // 저장 대상 자체가 없으면 어느 항목이 비었는지 특정할 수 없어 일반 문구를 쓴다.
    if (!saveData) {
      void setAlert({
        type: 'alert',
        content: t(CRUD_MSG.REQUIRED_INPUT.id, CRUD_MSG.REQUIRED_INPUT.fallback),
      });
      return;
    }

    const missing = findMissingMandatory(saveData, staticColumns);
    if (missing) {
      // 항목명은 컬럼 메타의 화면 라벨(colLblNm) 우선 — 사용자가 헤더에서 본 이름과 같게.
      //   라벨 끝 `*` 는 떼고 보여준다(헤더도 `*` 없이 빨간 점으로 그려진다).
      const label = stripRequiredMark(missing.colLblNm) || missing.colNm;
      void setAlert({
        type: 'alert',
        content: t(CRUD_MSG.REQUIRED_FIELD.id, CRUD_MSG.REQUIRED_FIELD.fallback).replace(
          '{0}',
          `[${label}]`
        ),
      });
      return;
    }

    mutate(saveData);
  };

  return { saveWithValidation };
};
