import type { FlexGrid } from '@mescius/wijmo.grid';
import type { MutableRefObject } from 'react';
import { useRef } from 'react';

import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { useSaveWithValidation } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import {
  DB_ERR_DIFFERENT_EQUIPMENT_TYPE,
  MENU_ID,
  MSG,
  type GridSheet,
} from '../capa-speed-plan.constants';
import type { Scp0105Row, SearchCondition } from '../capa-speed-plan.types';
import { buildSavePayload, pickDirtyRows, readSaveOutcome } from '../utils/capaSpeedPlan.save';

interface UseCapaSpeedPlanSaveParams {
  gridRef: MutableRefObject<FlexGrid | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  sheetName: GridSheet;
  /** 저장 대상 기간 컬럼명 — `*_ASSIGN_PRIORITY` 를 뺀 순서 확정 목록. */
  periodColumnNames: string[];
  /** 확정 조회조건(`applied ?? searchCondition`) — 저장은 화면 현재값이 아니라 조회 시점 값을 쓴다. */
  condition: SearchCondition;
  /** 편집 권한(`hasButton('EDIT')`, mount 1회) — 읽기전용 사용자의 저장을 막는다. */
  canEdit: boolean;
  /** 필수검증 기준 메타 — 현재 시트분. */
  staticColumns: RawFlexGridColumnConfig[];
  /** 저장 성공 후 재조회 — AS-IS 는 SAVE -> GET 을 연쇄 실행한다(cs:2392~2399). */
  refetch: () => void;
}

/**
 * 저장 체인 — AS-IS `SaveButton()`(cs:2009~2021) + `CheckChangedValues`(cs:2404~2414) +
 * `SetQueryInfoSave`(cs:2261~2352) 전송.
 * Page 에 인라인이던 것을 분리했다(구조 룰 #9 — Page 는 조립만 한다). 동작은 그대로다.
 */
export const useCapaSpeedPlanSave = ({
  gridRef,
  editTrackerRef,
  sheetName,
  periodColumnNames,
  condition,
  canEdit,
  staticColumns,
  refetch,
}: UseCapaSpeedPlanSaveParams) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const sessionUserId = useSessionStore(state => state.session.userId);
  const { saveWithValidation } = useSaveWithValidation();
  const savingRef = useRef(false);

  /** 저장 전송 — `^`/`;` 직렬화 후 call-proc. 응답은 반드시 `result_code` 로 판정한다(false-success 차단). */
  const doSave = (dirty: Scp0105Row[]) => {
    void (async () => {
      if (savingRef.current) return;
      const payload = buildSavePayload({
        rows: dirty,
        periodColumnNames,
        sheetName,
        version: condition.version,
        versionSeq: condition.versionSeq,
        progressStatus: condition.progressStatus,
        userId: sessionUserId ?? '',
      });

      savingRef.current = true;
      try {
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
          // `50426` = 동일 라인에 서로 다른 설비유형. TO-BE `SCM_ADM_MSG_M` 에 등가 메시지가 없어
          //   (실측 2026-09-23 MSG00426 0건) 서버 원문을 그대로 표면화하고 없으면 일반 오류로 떨어진다.
          //   AS-IS 분기 자체는 추측으로 제거하지 않는다(03 C-08).
          const isEquipmentTypeError = outcome.dbErrorNo === DB_ERR_DIFFERENT_EQUIPMENT_TYPE;
          void setAlert({
            type: 'alert',
            content:
              (isEquipmentTypeError ? outcome.message.trim() : '') ||
              outcome.message.trim() ||
              t(MSG.SAVE_FAIL, { defaultValue: 'Failed to save.' }),
          });
          return; // 편집 유지 — 사용자가 고쳐 재저장한다.
        }

        void setToast({
          type: 'success',
          // i18next 기본 보간자는 `{{ }}` 라 DB 메시지의 `{0}` 은 옵션 전달로 치환되지 않는다.
          message: t(MSG.SAVE_SUCCESS, { defaultValue: '{0} data saved.' }).replace(
            '{0}',
            String(outcome.savedCount || dirty.length)
          ),
        });
        editTrackerRef.current?.clearChanges();
        // "조회모드 복귀"는 없다 — TO-BE 는 Edit 모드토글이 없어 복귀할 모드가 없다(canEdit 는 권한).
        //   AS-IS 는 SAVE -> GET 을 연쇄 실행한다(cs:2392~2399).
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
   * Save — AS-IS `SaveButton()`(cs:2009~2021) 가드 3종: 그리드 없음 / **편집권한 없음** / 빈 그리드.
   * AS-IS 의 `IsLock`(비편집 상태) 가드는 TO-BE 편집권한(`canEdit`)으로 치환한다 — 읽기전용
   * 사용자의 저장을 막되, 편집모드 토글은 두지 않는다(convert-core §2.4).
   * 이어서 `CheckChangedValues`(cs:2404~2414) 가 변경 0건이면 `MSG00133` 으로 중단한다.
   */
  const handleSave = () => {
    const grid = gridRef.current;
    if (!grid) return;
    if (!canEdit) return;
    if (grid.rows.length === 0) return;
    grid.finishEditing();

    const source = (grid.collectionView?.sourceCollection ?? []) as Scp0105Row[];
    const dirty = pickDirtyRows(source);
    if (dirty.length === 0) {
      void setToast({
        type: 'error',
        message: t(MSG.NO_CHANGES, { defaultValue: 'No modifications have been made.' }),
      });
      return;
    }
    // 메타 기반 필수검증(공용) — 커스텀 검증만 두면 필수 컬럼 공백 저장이 통과한다(SCP0020 실사고).
    //   현 메타는 `INPUT_TP_CD='S'` 63행 전건이라 무발동이다. 사용자 확정(BLK-10)으로 **파리티 유지** —
    //   메타를 정정하거나 코드로 검증을 강제 발동시키지 않는다. 배선만 표준대로 건다.
    saveWithValidation(dirty, staticColumns, saveRows => doSave(saveRows));
  };

  return { handleSave };
};
