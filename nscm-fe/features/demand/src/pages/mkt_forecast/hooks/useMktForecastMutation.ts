import { useQueryClient } from '@tanstack/react-query';

import { apiClient } from '@foundation/apis';
import { useMessageStore } from '@shared/stores';

import { MENU_ID } from '../mkt-forecast-master.constants';
import type { MktFcstRow } from '../mkt-forecast-master.types';
import { toActiveFlag } from '../utils/crudTypeMarker';

// AS-IS DMF0003_SAVE_MKT_FCST (archive L8332~10549, 2,218 lines):
//   15 IN 파라미터 (^-delim 누적 array 로 펼침):
//     activeFlag / divisionId / projectCode / scmSiteId / itemId / domExp /
//     fcstType / incoterms / measure / plantSiteId / yyyymmdd / qty /
//     createdBy / asFromSite / bucket
//   2 OUT cursor (o_rc1 / o_result_cursor)
//
// 호출 endpoint: POST /api/{MENU_ID}/main/SAVE/call-proc
// hook mutation-onsuccess-defaults 의무 — default invalidate + toast 명시 실행

export const useMktForecastMutation = () => {
  const queryClient = useQueryClient();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;

  // F7 Save — AS-IS L1392 SaveButton override
  // CRUD_TYPE marker ('I'/'U'/'D') 모든 row → activeFlag 로 SP 호출
  const saveRows = async (
    modifiedRows: MktFcstRow[],
    opts: { userId: string; bucketType: string; asFromSite: string },
  ): Promise<{ ok: boolean; error?: string }> => {
    if (modifiedRows.length === 0) {
      return { ok: false, error: '저장할 데이터가 없습니다.' };
    }

    // 17 IN params 의 ^-delim 누적 array
    const acc: Record<string, string[]> = {
      activeFlag: [], divisionId: [], projectCode: [], scmSiteId: [], itemId: [],
      domExp: [], fcstType: [], incoterms: [], measure: [], plantSiteId: [],
      yyyymmdd: [], qty: [], createdBy: [], asFromSite: [], bucket: [],
    };

    for (const row of modifiedRows) {
      acc.activeFlag.push(toActiveFlag(row));
      acc.divisionId.push(String(row.DIVISION_ID ?? ''));
      acc.projectCode.push(String(row.PROJECT_CODE ?? ''));
      acc.scmSiteId.push(String(row.SCM_SITE_ID ?? ''));
      acc.itemId.push(String(row.ITEM_ID ?? ''));
      acc.domExp.push(String(row.DOM_EXP ?? ''));
      acc.fcstType.push(String(row.FCST_TYPE ?? ''));
      acc.incoterms.push(String(row.INCOTERMS ?? ''));
      acc.measure.push(String(row.MEASURE ?? ''));
      acc.plantSiteId.push(String(row.PLANT_SITE_ID ?? ''));
      acc.yyyymmdd.push(String(row.YYYYMMDD ?? ''));
      acc.qty.push(String(row.QTY ?? 0));
      acc.createdBy.push(opts.userId);
      acc.asFromSite.push(opts.asFromSite);
      acc.bucket.push(opts.bucketType);
    }

    const payload: Record<string, string> = {};
    for (const [k, arr] of Object.entries(acc)) payload[k] = arr.join('^');

    try {
      await apiClient.post(`/${MENU_ID}/main/SAVE/call-proc`, payload);

      // mutation-onsuccess-defaults 의무: default invalidate + toast 명시 호출
      void queryClient.invalidateQueries({ queryKey: [MENU_ID, 'main'] });
      void setToast({
        message: '[MSG00020] 저장되었습니다.',
        type: 'success',
        duration: 3000,
      });
      return { ok: true };
    } catch (e) {
      const msg = e instanceof Error ? e.message : '[MSG00284] 저장 중 오류가 발생했습니다.';
      void setAlert({ type: 'alert', content: msg });
      return { ok: false, error: msg };
    }
  };

  return { saveRows };
};
