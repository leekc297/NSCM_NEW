// SCP0001 도시 파생 — CITY 직접 키인·붙여넣기·삭제 시 형제 화면 SCP0005(SetCityCode) 동작을 재현한다.
//   CITY 코드만으로 공용 City-by-Country 조회(COM0001/region/SEARCH, CityByCountryModal 과 동일 경로)를
//   해서 정확일치(대소문자 무시) 첫 행의 COUNTRY·CITY 를 함께 채우고, 무매칭·빈값이면 COUNTRY 를 비운다
//   (country 무관). SCP0005 는 CITY_NAME 3칸을 다루지만 SCP0001 그리드에는 CITY_NAME 컬럼이 없어
//   COUNTRY·CITY 두 칸만 세팅한다.

import { apiClient } from '@foundation/apis';
import { safeString } from '@foundation/utils';

interface CityRow {
  COUNTRY?: unknown;
  CITY?: unknown;
  [key: string]: unknown;
}

// CITY 코드 조회 결과 상태 (SCP0005 SetCityCode 분기 대응):
//   - 'match'  : 정확히 일치하는 도시 → 호출부가 COUNTRY/CITY 를 함께 세팅
//   - 'nomatch': 조회 성공했으나 일치 도시 없음(잘못된 코드) 또는 CITY 빈값(삭제) → COUNTRY 비움
//   - 'defer'  : 조회 자체 실패(네트워크/인터셉터 throw) → 판단 보류(기존 값 유지)
export type CityLookup =
  | { status: 'match'; country: string; city: string }
  | { status: 'nomatch' }
  | { status: 'defer' };

/**
 * CITY 코드만으로 도시(COUNTRY/CITY)를 조회한다 — country 무관, CITY 정확일치(대소문자 무시) 첫 행을
 * 채택한다. CITY 가 비면 조회 없이 'nomatch'(호출부가 COUNTRY 를 비워 삭제 캐스케이드를 완성한다).
 */
export const lookupCityByCode = async (city: string): Promise<CityLookup> => {
  const ct = safeString(city).trim();
  if (!ct) return { status: 'nomatch' };
  try {
    const res = await apiClient.post<{ o_rc1?: CityRow[] }>('COM0001/region/SEARCH/call-proc', {
      country: '',
      city: ct,
    });
    const rows = res.data.result?.o_rc1 ?? [];
    const ctu = ct.toUpperCase();
    const exact = rows.find(r => safeString(r.CITY).toUpperCase() === ctu);
    if (!exact) return { status: 'nomatch' };
    return {
      status: 'match',
      country: safeString(exact.COUNTRY),
      city: safeString(exact.CITY),
    };
  } catch {
    // 조회 실패(네트워크/인터셉터 throw) = 판단 보류 — 기존 country/city 유지.
    return { status: 'defer' };
  }
};
