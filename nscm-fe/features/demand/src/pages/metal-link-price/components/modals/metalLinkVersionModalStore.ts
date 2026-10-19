import dayjs from 'dayjs';

import { createPersistedStore } from '@shared/stores';

export interface MetalLinkVersionSearchParams {
  divisionId: string;
  periodFrom: string;
  periodTo: string;
  description: string;
}

const initSearchParams = (): MetalLinkVersionSearchParams => ({
  divisionId: '',
  periodFrom: dayjs().subtract(3, 'month').format('YYYYMMDD'),
  periodTo: dayjs().add(3, 'month').format('YYYYMMDD'),
  description: '',
});

interface MetalLinkVersionModalState {
  searchParams: MetalLinkVersionSearchParams;
}

interface MetalLinkVersionModalAction {
  setSearchParams: (patch: Partial<MetalLinkVersionSearchParams>) => void;
  // period 를 넘기면 그 값(YYYYMMDD)으로 초기화, 없으면 AS-IS 기본값(오늘±3M) 유지.
  //   메인 화면 조회조건(fromYyyymm~toYyyymm)을 물려줄 때 from=해당월 1일 / to=해당월 말일로 변환해 전달.
  resetSearchParams: (divisionId: string, period?: { from: string; to: string }) => void;
}

export const useMetalLinkVersionModalStore = createPersistedStore<
  MetalLinkVersionModalState & MetalLinkVersionModalAction
>(
  set => ({
    searchParams: initSearchParams(),
    // 조회조건 변경마다 참조를 새로 만들어 filters useMemo 의 deps 로 쓴다.
    setSearchParams: patch => {
      set(state => {
        state.searchParams = { ...state.searchParams, ...patch };
      });
    },
    // 모달 open 시 초기화. period 를 주면 메인 조회조건에서 물려받은 값으로,
    //   없으면 AS-IS 기본값(오늘±3M — Form_Load 1:1)으로 복원.
    resetSearchParams: (divisionId, period) => {
      set(state => {
        const base = initSearchParams();
        state.searchParams = {
          ...base,
          divisionId,
          periodFrom: period?.from || base.periodFrom,
          periodTo: period?.to || base.periodTo,
        };
      });
    },
  }),
  'modal-metal-link-version'
);
