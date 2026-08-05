import { useTabLookupQueries } from '@shared/hooks';
import { useSessionStore } from '@shared/stores';

/** 홈 System Administrators 한 행 (Lookup `SYSTEM_ADM` 의 세그먼트 매핑). */
export interface SystemAdmin {
  module: string;
  division: string;
  pic: string;
}

/**
 * System Administrators 조회.
 * 관리자가 Lookup(`LOOKUP_TYPE = 'SYSTEM_ADM'`)에 등록한 값을 공통 Lookup API 로 가져와 홈 테이블에 뿌린다.
 * 응답은 세그먼트 라벨 컬럼명(MODULE / DIVISION / PIC) 그대로 내려온다.
 */
export const useSystemAdmins = (): SystemAdmin[] => {
  const isLogin = useSessionStore(state => state.isLogin);
  const [rows] = useTabLookupQueries({ filters: ['SYSTEM_ADM'], enabled: isLogin });

  return (rows ?? []).map(row => ({
    module: row.MODULE ?? '',
    division: row.DIVISION ?? '',
    pic: row.PIC ?? '',
  }));
};
