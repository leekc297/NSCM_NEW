// SCP0005 도시명 파생 — FROM/TO CITY 직접 키인 시 city_name 을 서버 조회로 채운다.
//   AS-IS SetCityCode(dt,row,"FROM/TO")(cs:1066/1070) 재현: CITY 코드가 바뀌면 SCM_MST_CITY 를
//   조회해 잠금 컬럼 *_CITY_NAME 을 갱신한다. TO-BE SP = PKG_SCP0005.P_SCP0005_GET_COUNTRY_CITY
//   (버튼 SEARCH_CITY, SHT_NM='route'). PROC_M(country/city/cityName IN) 실측 등록 확인(2026-09-25).
//   O_RC 반환 = {COUNTRY, CITY, CITY_NAME}(SP body L911~922 실측 — country/city LIKE 필터).

import { apiClient } from '@foundation/apis';
import { safeString } from '@foundation/utils';

import { MENU_ID, SHEETS } from '../distribution-route.constants';

interface CityRow {
  COUNTRY?: unknown;
  CITY?: unknown;
  CITY_NAME?: unknown;
  [key: string]: unknown;
}

/**
 * (country, city) 조합의 도시명을 조회한다.
 * - 반환 '' : 조회 성공했으나 정확히 일치하는 도시가 없음(잘못된 코드) → 호출부가 name 을 비워
 *   저장검증(FROM/TO City Name 필수)에서 차단되게 한다.
 * - 반환 null: country/city 가 비었거나 조회 자체 실패 → 판단 보류(기존 name 유지, console 금지).
 */
export const lookupCityName = async (country: string, city: string): Promise<string | null> => {
  const c = safeString(country).trim();
  const ct = safeString(city).trim();
  if (!c || !ct) return null;
  try {
    const res = await apiClient.post<{ o_rc1?: CityRow[] }>(
      `/${MENU_ID}/${SHEETS.ROUTE}/SEARCH_CITY/call-proc`,
      { country: c, city: ct, cityName: '' }
    );
    const rows = res.data.result?.o_rc1 ?? [];
    const cu = c.toUpperCase();
    const ctu = ct.toUpperCase();
    const exact = rows.find(
      r => safeString(r.COUNTRY).toUpperCase() === cu && safeString(r.CITY).toUpperCase() === ctu
    );
    return exact ? safeString(exact.CITY_NAME) : '';
  } catch {
    // 조회 실패(네트워크/인터셉터 throw) = 판단 보류 — 기존 city_name 유지.
    return null;
  }
};
