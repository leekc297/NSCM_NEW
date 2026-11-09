import type { FlexGrid } from '@mescius/wijmo.grid';
import { type MutableRefObject, useRef, useState } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { useSaveWithValidation } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { MSG } from '../sales-price-model-group.constants';
import type { ModelGroupRow } from '../sales-price-model-group.types';
import { postSave } from '../utils/sales-price-model-group.save';
import {
  buildMainSaveEntries,
  describeRow,
  findDuplicateInsertBundle,
  toSavePayload,
} from '../utils/sales-price-model-group.save';
import type { ExchangeRateMap } from '../utils/sales-price-model-group.util';
import { showAlert } from '../utils/sales-price-model-group.util';
import { thisWeekMonday } from '../utils/sales-price-model-group.util';

interface Params {
  gridRef: MutableRefObject<FlexGrid<ModelGroupRow> | null>;
  editTrackerRef: MutableRefObject<EditTracker<ModelGroupRow> | undefined>;
  staticColumns: RawFlexGridColumnConfig[];
  weeksByMonth: Map<string, string[]>;
  rateMap: ExchangeRateMap;
  // 52주 채우기 시작 — 조회한 기간의 시작일 (PKG_DMF0083 3-5 P_FROM_YYYYMMDD)
  fromYyyymmdd: string;
  onSaved: () => void;
}

// 메인 그리드 Save (설계서 [개요] grid-1 Save H26). 저장 행 구성 규칙은 utils/sales-price-model-group.save 참조.
export const useSalesPriceModelGroupSave = ({
  gridRef,
  editTrackerRef,
  staticColumns,
  weeksByMonth,
  rateMap,
  fromYyyymmdd,
  onSaved,
}: Params) => {
  const { t } = useTranslation();
  const { saveWithValidation } = useSaveWithValidation();
  const savingRef = useRef(false);
  const [saving, setSaving] = useState(false);

  const submit = async (allRows: ModelGroupRow[]) => {
    const duplicate = findDuplicateInsertBundle(allRows);
    if (duplicate) {
      showAlert(`${t(MSG.DUPLICATE_NEW, '_신규 입력 데이터 중 중복된 데이터가 있습니다.')} [${describeRow(duplicate)}]`);
      return;
    }
    const built = buildMainSaveEntries({
      rows: allRows,
      originals: editTrackerRef.current?.getOriginalValues(),
      weeksByMonth,
      monday: thisWeekMonday(),
      rateMap,
    });
    if (!built.ok) {
      const msg =
        built.error === 'NO_FUTURE_WEEK'
          ? t(MSG.PAST_PERIOD, '_과거 구간은 일괄입력이 불가합니다.')
          : built.error === 'NO_PRICE'
            ? t(MSG.PRICE_EMPTY, '_판가 미입력 상태입니다. 판가 입력 후 진행해 주세요.')
            : t(MSG.REQUIRED_INPUT, '_필수 입력란을 입력해 주세요.');
      showAlert(`${msg} [${describeRow(built.row)}]`);
      return;
    }
    if (built.entries.length === 0) {
      useMessageStore
        .getState()
        .setToast({ type: 'error', message: t(MSG.NO_CHANGES, '_수정한 내용이 없습니다.') });
      return;
    }
    const confirmed = await useMessageStore
      .getState()
      .setAlert({ type: 'confirm', content: t(MSG.CONFIRM_SAVE, '_저장 하시겠습니까?') });
    if (!confirmed) return;

    savingRef.current = true;
    setSaving(true);
    try {
      const result = await postSave(
        toSavePayload(built.entries, fromYyyymmdd),
        t(MSG.SAVE_FAIL, '_저장 중 오류가 발생했습니다.')
      );
      if (!result.ok) {
        showAlert(result.message);
        return;
      }
      useMessageStore.getState().setToast({ type: 'success', message: t(MSG.SAVED, '_저장되었습니다.') });
      editTrackerRef.current?.clearChanges();
      onSaved();
    } finally {
      savingRef.current = false;
      setSaving(false);
    }
  };

  const handleSave = () => {
    if (savingRef.current) {
      showAlert(t(MSG.BUSY, '_이전 작업이 아직 실행 중입니다. 잠시 후 다시 시도해주세요.'));
      return;
    }
    const g = gridRef.current;
    if (!g) return;
    g.finishEditing();
    const allRows = [...((g.collectionView?.sourceCollection as ModelGroupRow[] | undefined) ?? [])];
    const targetRows = allRows.filter(
      r => r.CRUD_TYPE === CRUD_TYPE.INSERT || r.CRUD_TYPE === CRUD_TYPE.MODIFY
    );
    // 필수값(메타 M · IM, 라벨 *) 검증을 먼저 한다 — 신규 · 수정 행 기준(STR-23).
    saveWithValidation(targetRows, staticColumns, () => void submit(allRows), targetRows);
  };

  return { handleSave, saving };
};
