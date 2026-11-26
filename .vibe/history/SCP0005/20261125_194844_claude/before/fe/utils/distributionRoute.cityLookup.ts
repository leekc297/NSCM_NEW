// SCP0005 도시 파생 — FROM/TO CITY 직접 키인·붙여넣기 시 AS-IS SetCityCode(cs:1300~1346) 재현.
//   AS-IS 는 CITY 코드만으로 dtCountryCity(SCP0005_GET_COUNTRY_CITY 전건)를 client select("CITY='<upper>'")
//   해서 매칭 시 COUNTRY·CITY·CITY_NAME 3칸을 함께 채우고, 무매칭 시 COUNTRY·CITY_NAME 을 비운다(country 무관).
//   TO-BE SP = PKG_SCP0005.P_SCP0005_GET_COUNTRY_CITY (버튼 SEARCH_CITY, SHT_NM='route'),
//   country/city LIKE 필터(SP body L911~922 실측). country 를 비워 CITY 단독 조회 → 정확일치는 client 에서 선별.

import { apiClient } from '@foundation/apis';
import { safeString } from '@foundation/utils';

import { MENU_ID, SHEETS } from '../distribution-route.constants';

interface CityRow {
  COUNTRY?: unknown;
  CITY?: unknown;
  CITY_NAME?: unknown;
  [key: string]: unknown;
}

// CITY 코드 조회 결과 상태 (AS-IS SetCityCode 분기 대응):
//   - 'match'  : 정확히 일치하는 도시 → 호출부가 COUNTRY/CITY/CITY_NAME 3칸을 함께 세팅
//   - 'nomatch': 조회 성공했으나 일치 도시 없음(잘못된 코드) 또는 CITY 빈값(삭제) → COUNTRY/CITY_NAME 비움
//   - 'defer'  : 조회 자체 실패(네트워크/인터셉터 throw) → 판단 보류(기존 값 유지, console 금지)
export type CityLookup =
  | { status: 'match'; country: string; city: string; cityName: string }
  | { status: 'nomatch' }
  | { status: 'defer' };

/**
 * CITY 코드만으로 도시(COUNTRY/CITY/CITY_NAME)를 조회한다 — AS-IS SetCityCode 와 동일하게
 * country 무관, CITY 정확일치(대소문자 무시) 첫 행을 채택한다. CITY 가 비면 조회 없이 'nomatch'
 * (호출부가 COUNTRY·CITY_NAME 을 비워 삭제 캐스케이드를 완성한다).
 */
export const lookupCityByCode = async (city: string): Promise<CityLookup> => {
  const ct = safeString(city).trim();
  if (!ct) return { status: 'nomatch' };
  try {
    const res = await apiClient.post<{ o_rc1?: CityRow[] }>(
      `/${MENU_ID}/${SHEETS.ROUTE}/SEARCH_CITY/call-proc`,
      { country: '', city: ct, cityName: '' }
    );
    const rows = res.data.result?.o_rc1 ?? [];
    const ctu = ct.toUpperCase();
    const exact = rows.find(r => safeString(r.CITY).toUpperCase() === ctu);
    if (!exact) return { status: 'nomatch' };
    return {
      status: 'match',
      country: safeString(exact.COUNTRY),
      city: safeString(exact.CITY),
      cityName: safeString(exact.CITY_NAME),
    };
  } catch {
    // 조회 실패(네트워크/인터셉터 throw) = 판단 보류 — 기존 country/city_name 유지.
    return { status: 'defer' };
  }
};
