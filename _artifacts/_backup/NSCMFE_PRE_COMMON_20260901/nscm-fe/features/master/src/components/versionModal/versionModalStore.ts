import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStore } from '@shared/stores';

import { MODAL_SALES_VERSION, MODAL_SALES_VERSION_COLUMN_SHEET } from './version-modal.constants';

export interface VersionSearchConditions {
  sdt: string;
  edt: string;
  versionType: string;
  description: string;
}

const initSearchConditions: VersionSearchConditions = {
  sdt: '',
  edt: '',
  versionType: '',
  description: '',
};

interface VersionModalState {
  staticColumns: RawFlexGridColumnConfig[];
  searchConditions: VersionSearchConditions;
}

interface VersionModalAction {
  fetchStaticColumns: (divisionId: string) => Promise<void>;
  setSearchConditions: (next: VersionSearchConditions) => void;
}

export const useVersionModalStore = createPersistedStore<VersionModalState & VersionModalAction>(
  set => ({
    staticColumns: [],
    searchConditions: initSearchConditions,
    fetchStaticColumns: async divisionId => {
      const columns = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MODAL_SALES_VERSION}/column`,
        {
          sheetNm: MODAL_SALES_VERSION_COLUMN_SHEET,
          divisionId,
        }
      );
      set(state => {
        state.staticColumns = columns.data.result;
      });
    },
    // 검색 조건 확정(Search 클릭·모달 open 초기화)마다 참조를 새로 만들어 filters useMemo 의 deps 로 쓴다.
    setSearchConditions: next => {
      set(state => {
        state.searchConditions = next;
      });
    },
  }),
  'modal-sales-version'
);
