// ⭐ DMF0003 Phase 2c — SSP 동기화 셀 색 (PaleGreen=전체동기 / PapayaWhip=부분동기) 파싱.
//   근거: AS-IS DMF0003_MktFcst.cs L1414~1441 (Division 40·82 + ATTR1 컬럼) + 보강스펙 §1.
//   SSP 응답 소스(사내 Oracle ora.py 실측):
//     DMF0003_GET_MKT_FCST_DATA O_RC1 의 row 컬럼 `ATTR1` = NVL(B1.ATTR1, B2.ATTR1) (SP L3729).
//     B1 = GT_GGET_T_SSP_SYNC (MEASURE='MKT_FCST_RP', SP L3847~3851).
//     ATTR1 형식 = '^' 구분 토큰 = "YYYYMMDD/X^YYYYMMDD/X^…" (SP L644~666 PIVOT → L647~653 LISTAGG).
//       X = 'A' (All/전체동기 → PaleGreen) / 'P' (Partial/부분동기 → PapayaWhip) (SP L656~666, .cs L1428).
//   AS-IS: D_<YYYYMMDD> 컬럼 셀에만 색 적용 (.cs L1430). Division 40·82 만 (.cs L1415).
//   ⚠️ 재계산(주→일 분배)에서 PaleGreen 동기화 셀은 분배 대상 제외 (AS-IS L3624/3652/3693/3713 BackColor!=PaleGreen).
//      따라서 색은 "표시"뿐 아니라 cascade 로직의 입력 — recalc 가 본 맵을 참조한다.
import { DIVISION } from '../mkt-fcst.constants';
import type { MktFcstRow } from '../mkt-fcst.types';

// 셀 동기화 상태 — 'A'(전체=PaleGreen) / 'P'(부분=PapayaWhip) / null(비동기).
export type SspSyncState = 'A' | 'P' | null;

// row 의 ATTR1 → { 'D_YYYYMMDD': 'A'|'P' } 맵. (AS-IS L1422~1431 1:1)
//   ATTR1 비어있거나 division 비대상이면 빈 맵.
export const parseSspSyncMap = (
  row: MktFcstRow | undefined,
  divisionId: string
): Record<string, SspSyncState> => {
  // AS-IS L1415 — Division 40·82 만 SSP 동기화 색 (실 sync 데이터는 40 MKT_FCST_RP).
  if (divisionId !== DIVISION.MOBILITY && divisionId !== DIVISION.POWER) return {};
  const raw = (row as Record<string, unknown> | undefined)?.ATTR1;
  if (typeof raw !== 'string' || raw === '') return {};

  const map: Record<string, SspSyncState> = {};
  for (const token of raw.split('^')) {
    if (token === '') continue; // AS-IS L1425 빈 토큰 skip
    const slash = token.indexOf('/');
    if (slash < 0) continue;
    const ymd = token.slice(0, slash); // YYYYMMDD (.cs L1427)
    const ap = token.slice(slash + 1); // 'A' | 'P'  (.cs L1428)
    if (ymd.length !== 8) continue;
    map[`D_${ymd}`] = ap === 'A' ? 'A' : 'P'; // .cs L1431 (A=PaleGreen, else PapayaWhip)
  }
  return map;
};

// 단일 binding(D_YYYYMMDD) 의 동기화 상태 조회 (formatItem / recalc 공용).
export const sspSyncStateOf = (
  syncMap: Record<string, SspSyncState>,
  binding: string
): SspSyncState => syncMap[binding] ?? null;
