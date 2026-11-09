import type { FlexGrid } from '@mescius/wijmo.grid';
import type { MutableRefObject } from 'react';
import { useRef } from 'react';

import { apiClient } from '@foundation/apis';
import { CRUD_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { useSaveWithValidation } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { MENU_ID, MSG, SHEETS } from '../shipment-request-semi.constants';
import type { SaveCell } from '../utils/shipmentRequestSemi.save';
import {
  buildSavePayload,
  collectSaveCells,
  findDuplicateKey,
  findMissingRequired,
  findNegativeCells,
} from '../utils/shipmentRequestSemi.save';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

interface Params {
  gridRef: MutableRefObject<FlexGrid | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  staticColumns: RawFlexGridColumnConfig[];
  /** 저장 성공 직후 재조회 — filters 가 불변이라 `refetch()` 직접 호출이 허용되는 유일한 경로(hook #131). */
  onSaved: () => void;
  /** 음수 셀 집합 갱신 — AS-IS `SetBGColor(InvalidColor)` 대응(R13/S37). 정상 경로에서는 빈 배열로 해제한다. */
  onNegativeCells: (cells: readonly SaveCell[]) => void;
}

/**
 * 저장 오케스트레이션 (AS-IS `SaveButton` → `SaveData`, design 03 §4.3 / G05).
 *
 * 순서가 곧 계약이다:
 *   ① 행 0건 → 무동작                                    (G05 ③)
 *   ② 변경 행 0건 → "변경/추가 없음" toast                 (V06)
 *   ③ `*` 라벨 필수컬럼 공백 → 차단                        (V01, AS-IS checkRequiredOfSpread)
 *   ④ 9키 중복 → 차단                                     (V09)
 *   ⑤ 공용 메타 필수검증 배선                              (convert-core §2.4)
 *   ⑥ 셀 단위 수집 → 음수 셀 표시 + 차단 → '^' payload 전송 (K9 / V02 / R13)
 *   ⑦ 응답 3분기(S / N / 그 외)                            (V03·V04·V05)
 */
export const useShipmentRequestSemiSave = ({
  gridRef,
  editTrackerRef,
  staticColumns,
  onSaved,
  onNegativeCells,
}: Params) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const sessionUserId = useSessionStore(s => s.session.userId);
  const { saveWithValidation } = useSaveWithValidation();
  const savingRef = useRef(false);

  const systemError = () => t(MSG.SYSTEM_ERROR, { defaultValue: 'System error.' });
  const noChange = () => t(MSG.NO_CHANGE, { defaultValue: 'There is no data to save.' });

  const doSave = (dirty: Record<string, unknown>[]) => {
    void (async () => {
      if (savingRef.current) return;
      const changed = editTrackerRef.current?.getOriginalValues() ?? new Map();
      const cells = collectSaveCells(dirty, changed);
      if (cells.length === 0) {
        setToast({ type: 'error', message: noChange() });
        return;
      }
      // R13 / V02 — 음수는 입력을 허용하되 저장 시 셀 배경으로 표시하고 알린 뒤 **전체 중단**한다.
      const negatives = findNegativeCells(cells);
      onNegativeCells(negatives);
      if (negatives.length > 0) {
        void setAlert({
          type: 'alert',
          content: `${t(MSG.NEGATIVE_QTY, { defaultValue: 'Please enter an integer greater than 0.' })} [${negatives[0].binding}]`,
        });
        return;
      }

      savingRef.current = true;
      try {
        const res = await apiClient.post<{ o_rc1?: { RESULT_CODE?: string; MSG?: string }[] }>(
          `/${MENU_ID}/${SHEETS.MAIN}/SAVE/call-proc`,
          buildSavePayload(cells, sessionUserId ?? '')
        );
        // false-success 차단(nscm-patterns §5-10) — 인터셉터가 500/403 도 resolve 한다.
        if (res.status >= 400 || Number(res.data?.code)) {
          void setAlert({
            type: 'alert',
            content: String(res.data?.message ?? '').trim() || systemError(),
          });
          return;
        }
        const result = (res.data?.result?.o_rc1 ?? [])[0];
        const code = str(result?.RESULT_CODE);
        if (code === 'N') {
          // SP 가 BOD 유효성 실패로 반환한 서버 메시지를 그대로 보여 준다(V04).
          void setAlert({ type: 'alert', content: str(result?.MSG) || systemError() });
          return;
        }
        if (code !== 'S') {
          void setAlert({ type: 'alert', content: systemError() });
          return;
        }
        // 저장 성공은 Alert 가 아니라 Toast (hook #132).
        setToast({
          type: 'success',
          message: t(MSG.SAVE_SUCCESS, { defaultValue: '{0} data saved.' }).replace(
            '{0}',
            String(cells.length)
          ),
        });
        editTrackerRef.current?.clearChanges();
        onSaved();
      } catch (e) {
        void setAlert({
          type: 'alert',
          content: e instanceof Error ? e.message : systemError(),
        });
      } finally {
        savingRef.current = false;
      }
    })();
  };

  const handleSave = () => {
    const grid = gridRef.current;
    grid?.finishEditing();
    const src = (grid?.collectionView?.sourceCollection ?? []) as Record<string, unknown>[];
    if (src.length === 0) return; // G05 ③
    const dirty = src.filter(
      r => r.CRUD_TYPE === CRUD_TYPE.INSERT || r.CRUD_TYPE === CRUD_TYPE.MODIFY
    );
    // 가드 순서는 AS-IS `SaveButton` 그대로다(cs:867-873 → cs:1011-1014, iter-3 N-06):
    //   행 0건 → **필수 → 9키 중복** → (수집) → 변경 0건 안내.
    //   금지: 변경 0건 가드를 필수·중복보다 앞에 두는 것 — 조회 결과에 이미 9키 중복이 있는 상태에서
    //   아무것도 고치지 않고 저장하면 AS-IS 는 중복을 경고하는데 TO-BE 는 "변경 없음" 으로 빠져
    //   경고가 사라진다. 중복검사 대상이 CRUD 상태와 무관한 **그리드 전 행**이라 실제로 갈린다.
    // V01 — 필수(`*` 라벨) 컬럼 공백 차단. AS-IS `checkRequiredOfSpread`(cs:870)의 대응이며
    //   공용 메타 필수검증이 이 화면에서 무발동이라(아래 주석) **이 검사가 실질 유일한 필수 게이트**다.
    //   대상을 `src`(전 행)로 넘기지만 함수 내부가 `I`/`M` 행만 보므로 판정 집합은 dirty 와 같다.
    const missing = findMissingRequired(src, staticColumns);
    if (missing) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED, { defaultValue: '{0} value is required.' }).replace(
          '{0}',
          `[${missing.label || missing.binding}]`
        ),
      });
      return;
    }
    // V09 — 9키 중복 차단. 대상은 **그리드 전 행**(MEASURE='SHIP_REQ')이다. AS-IS cs:1391-1407 이
    //   CRUD 상태와 무관하게 전 행을 모아 자기비교하므로, 신규행이 조회로 내려온 기존 행과 키가
    //   겹치는 경우도 차단된다 — dirty 행끼리만 비교하면 그 경우가 통과한다(iter-2 H-02).
    const dup = findDuplicateKey(src);
    if (dup) {
      void setAlert({
        type: 'alert',
        content: `${t(MSG.DUPLICATE, { defaultValue: 'There are duplicate entries among the newly entered data.' })} [${dup}]`,
      });
      return;
    }
    // 변경 0건 안내 — AS-IS 는 수집 이후(cs:1011-1014)에 판정한다. 위 두 검사를 통과한 뒤에 온다.
    if (dirty.length === 0) {
      setToast({ type: 'error', message: noChange() });
      return;
    }
    // 공용 메타 필수검증도 반드시 배선한다(convert-core §2.4 / SCP0020 실사고).
    //   주의: 이 화면은 컬럼메타 18행이 **전건 `INPUT_TP_CD='S'`** 라 메타 필수검사가 무발동이다
    //   (K11 / U5, 메모리 input-tp-cd-search-only-kills-save-validation). 그래서 위 `findMissingRequired`
    //   (라벨 `*` 축 — AS-IS 와 같은 기준)를 화면 로컬로 별도 구현했다. 향후 admin 이 `IM` 을 등록하면
    //   공용 훅이 자동으로 실효되고 두 검사는 같은 결론으로 수렴한다.
    saveWithValidation(dirty, staticColumns, doSave);
  };

  return { handleSave };
};
