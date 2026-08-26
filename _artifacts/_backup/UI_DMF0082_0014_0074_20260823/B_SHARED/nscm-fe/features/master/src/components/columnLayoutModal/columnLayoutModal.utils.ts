// ⭐ [2026-08-20 정본 단일화] Grid Column Setting 모달 유틸 정본 =
//   `packages/shared/src/components/templates/modals/column-layout-modal/columnLayoutModal.utils.ts` 유일.
//   본 파일은 기존 소비처 호환용 재수출 스텁 — 구현 금지 (hook #132 §Column 모달 정본).
//   ⚠ `ColumnSettingFallback` 타입은 재수출하지 않는다 — master barrel 이
//   `columnSettingModal/ColumnSettingModal.tsx` 의 동명 export 와 충돌(ambiguous star export)하기 때문.
//   구조 동일 타입이라 소비처는 기존 import 경로 그대로 동작한다.
export {
  DEFAULT_COL_WIDTH,
  deriveIsKey,
  toColumnLayoutSettings,
  parseWidth,
  isVisibleColumn,
  toHiddenColumnSet,
  overrideRows,
  buildInitialRows,
  toggleDisplay,
  changeWidth,
  changeCellColor,
  changeTextColor,
  reorderRows,
} from '@shared/components';
