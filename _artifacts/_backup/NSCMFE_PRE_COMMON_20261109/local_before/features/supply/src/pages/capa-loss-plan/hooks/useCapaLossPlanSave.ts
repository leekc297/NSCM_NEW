import type { FlexGrid } from '@mescius/wijmo.grid';
import type { MutableRefObject } from 'react';
import { useRef } from 'react';

import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { useSaveWithValidation } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import {
  COLUMN,
  DIRTY_ONLY_MEASURES,
  MENU_ID,
  MSG,
  PROGRESS_STATUS,
  type DivisionType,
  type GridSheet,
  type SheetType,
} from '../capa-loss-plan.constants';
import type { Scp0106Row } from '../capa-loss-plan.types';
import { blockKeyOf } from '../utils/capaLossPlan.recalc';
import { buildSavePayload, pickDirtyRows, readSaveOutcome } from '../utils/capaLossPlan.save';
import { toSaveSheetNameParam, usesModelSaveSp } from '../utils/capaLossPlan.sheetKey';

interface UseCapaLossPlanSaveParams {
  gridRef: MutableRefObject<FlexGrid | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  sheetName: GridSheet;
  /** 저장 대상 기간 컬럼명 — `*_ASSIGN_PRIORITY` 를 뺀 순서 확정 목록. */
  periodColumnNames: string[];
  /** 확정 조회조건 — 저장은 화면 현재값이 아니라 조회 시점 값을 쓴다. */
  version: string;
  versionSeq: string;
  progressStatus: string;
  sheetType: SheetType;
  divisionType: DivisionType;
  /** 편집권한 — `canEdit = hasButton('EDIT')`. AS-IS Edit 토글 미이식(convert-core §2.4). */
  canEdit: boolean;
  /** 필수검증 기준 메타 — 현재 시트분. */
  staticColumns: RawFlexGridColumnConfig[];
  /** 저장 성공 후 재조회 — AS-IS 는 SAVE -> GET 을 연쇄 실행한다. */
  refetch: () => void;
}

/**
 * 저장 체인 — AS-IS `SaveButton()` + `CheckChangedValues` + `SetQueryInfoSave`(MODEL) /
 * `SetQueryInfoSaveLine`(LINE) 전송.
 * Page 는 조립만 한다(구조 룰 #9)라 저장 로직을 이 훅으로 분리했다.
 */
export const useCapaLossPlanSave = ({
  gridRef,
  editTrackerRef,
  sheetName,
  periodColumnNames,
  version,
  versionSeq,
  progressStatus,
  sheetType,
  divisionType,
  canEdit,
  staticColumns,
  refetch,
}: UseCapaLossPlanSaveParams) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const sessionUserId = useSessionStore(state => state.session.userId);
  const { saveWithValidation } = useSaveWithValidation();
  const savingRef = useRef(false);

  /**
   * R-09 재현 — "한 셀을 고치면 **그 열의 measure 세트가 통째로 저장 대상**" 이 저장 계약이다(V-39).
   *
   * AS-IS 는 파생 반영 7종에 값을 쓰고, 나머지 18종에는 **값 없이 0열 `"M"` 플래그만** 찍어
   * 저장 대상으로 만든다. TO-BE 의 `EditTracker` 는 "값이 달라졌을 때만" `CRUD_TYPE='M'` 을 찍는
   * 계약이라(`packages/foundation/src/utils/editTracker.ts`) 값 없이 마킹하려면 그 규약을 깨거나
   * 자체 상태필드를 신설해야 한다 — 둘 다 금지다(convert-core §2.4).
   *
   * 그래서 **마킹 대신 저장 payload 조립 단계에서 블록을 확장**한다. 저장되는 행 집합은 AS-IS 와
   * 같고, 다른 점은 그리드에 빨간 변경표시가 18행에 뜨지 않는 것뿐이다(04 리포트 기록).
   *
   * AS-IS 도 `ApplyToSheetOnlyEditModeCurrent` 라 **CURRENT 에서만** 발동한다 — LINE 계열에는
   * 확장을 걸지 않는다.
   */
  const expandDirtyRows = (source: readonly Scp0106Row[], dirty: Scp0106Row[]): Scp0106Row[] => {
    const isCurrent =
      progressStatus === PROGRESS_STATUS.PRE || progressStatus === PROGRESS_STATUS.CURRENT;
    if (!isCurrent || dirty.length === 0) return dirty;

    const blockKeys = new Set(dirty.map(blockKeyOf));
    const picked = new Set<Scp0106Row>(dirty);
    for (const row of source) {
      if (picked.has(row)) continue;
      if (!blockKeys.has(blockKeyOf(row))) continue;
      const measure = typeof row[COLUMN.MEASURE] === 'string' ? (row[COLUMN.MEASURE] as string) : '';
      if (!DIRTY_ONLY_MEASURES.includes(measure)) continue;
      picked.add(row);
    }
    // 원본 순서를 유지한다 — 직렬화 토큰 순서가 SP 의 행 인덱스와 짝이다.
    return source.filter(row => picked.has(row));
  };

  /** 저장 전송 — `^`/`;` 직렬화 후 call-proc. 응답은 반드시 판정한다(false-success 차단, V-46). */
  const doSave = (rowsToSave: Scp0106Row[]) => {
    void (async () => {
      if (savingRef.current) return;
      const isModelSave = usesModelSaveSp(progressStatus, sheetType);
      const payload = buildSavePayload({
        rows: rowsToSave,
        periodColumnNames,
        isModelSave,
        // MODEL 은 `_sheet_status`, LINE 은 `_sheet_name` — 비대칭 그대로 보낸다(V-50).
        sheetNameParam: toSaveSheetNameParam(progressStatus, sheetType, divisionType),
        version,
        versionSeq,
        progressStatus,
        userId: sessionUserId ?? '',
      });

      savingRef.current = true;
      try {
        // URL 의 시트는 버튼 메타(`SCM_ADM_MNU_BTN_MPG_M`) 조회 키라 **`_sheet_name` 8값**이다.
        //   payload 의 `p_sheet_name` 과 값이 다를 수 있다(MODEL 저장). 둘은 다른 축이다.
        const response = await apiClient.post<Record<string, unknown>>(
          `/${MENU_ID}/${sheetName}/SAVE/call-proc`,
          payload
        );
        // 인터셉터가 500/CODE!=0 도 resolve 하므로 HTTP 축을 먼저 본다(nscm-patterns §5-10).
        if (response.status >= 400 || Number(response.data?.code)) {
          void setAlert({
            type: 'alert',
            content:
              (response.data as { message?: string })?.message?.trim() ||
              t(MSG.SAVE_FAIL, { defaultValue: 'Failed to save.' }),
          });
          return;
        }
        const outcome = readSaveOutcome(response.data?.result);
        if (!outcome.ok) {
          void setAlert({
            type: 'alert',
            content:
              outcome.message.trim() || t(MSG.SAVE_FAIL, { defaultValue: 'Failed to save.' }),
          });
          return; // 편집 유지 — 사용자가 고쳐 재저장한다.
        }

        void setToast({
          type: 'success',
          // i18next 기본 보간자는 `{{ }}` 라 DB 메시지의 `{0}` 은 옵션 전달로 치환되지 않는다.
          //   `MSG00004` 를 쓰면 TO-BE 에서 "No changes to save." 로 뜻이 뒤집힌다(hook #114 함정).
          message: t(MSG.SAVE_SUCCESS, { defaultValue: '{0} data saved.' }).replace(
            '{0}',
            String(outcome.savedCount || rowsToSave.length)
          ),
        });
        editTrackerRef.current?.clearChanges();
        // 저장 성공 후 재조회 — AS-IS 는 SAVE -> GET 을 연쇄한다(01 V-17). 편집모드 토글은 미이식이라
        //   해제/유지 논쟁은 없다(convert-core §2.4).
        refetch();
      } catch (error) {
        void setAlert({
          type: 'alert',
          content:
            error instanceof Error
              ? error.message
              : t(MSG.SAVE_FAIL, { defaultValue: 'Failed to save.' }),
        });
      } finally {
        savingRef.current = false;
      }
    })();
  };

  /**
   * Save — AS-IS `SaveButton()` 가드 3종(01 L-19~L-21): 그리드 없음 / **편집권한 없음** / 빈 그리드.
   * AS-IS 의 `!IsEditMode` 가드는 편집모드 토글 미이식이라 `!canEdit`(편집권한) 로 치환한다(convert-core §2.4).
   * 이어서 `CheckChangedValues` 가 변경 0건이면 `MSG00133` 으로 중단한다(R-22, V-44).
   */
  const handleSave = () => {
    const grid = gridRef.current;
    if (!grid) return;
    if (!canEdit) return;
    if (grid.rows.length === 0) return;
    grid.finishEditing();

    const source = (grid.collectionView?.sourceCollection ?? []) as Scp0106Row[];
    const dirty = pickDirtyRows(source);
    if (dirty.length === 0) {
      void setToast({
        type: 'error',
        message: t(MSG.NO_CHANGES, { defaultValue: 'No modifications have been made.' }),
      });
      return;
    }
    const rowsToSave = expandDirtyRows(source, dirty);

    /**
     * 메타 기반 필수검증(공용) — 커스텀 검증만 두면 필수 컬럼 공백 저장이 통과한다(SCP0020 실사고).
     * 현 메타는 `INPUT_TP_CD='S'` **226행 전건**이라 실제로는 무발동이다(C-04).
     * 사용자 확정(decisions §A BLK-3)으로 **파리티 유지** — 메타를 정정하거나 코드로 검증을 강제
     * 발동시키지 않는다. 배선만 표준대로 걸어 둔다(메타가 정비되면 그날부터 동작한다).
     */
    saveWithValidation(rowsToSave, staticColumns, saveRows => doSave(saveRows));
  };

  return { handleSave };
};
