// SCP0037 Plant Site 콤보 좁힘 — 조회영역 cascade(design 02 §3) + 신규행 SCM_SITE_ID 셀콤보(design 03 §3-2).
//   AS-IS 는 생성자에서 PlantByDivisionOperNonOsp1_SCP_ALL(OSP_YN='N')·PlantByDivisionOperOsp21_SCP_ALL
//   (OSP_YN='Y')을 광범위 로드한 뒤 DBUtils.Filter(클라 RowFilter)로만 좁힌다(재조회 없음).
//   admin 셀콤보 메타 PARAM2/9/10 전부 공란 = 이 좁힘 미이관 → FE 로 재현(design 03 §6#1 FAIL 방지).

import { LT_OP } from '../operation-lt.constants';
import type { PlantSiteSource } from '../operation-lt.types';

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 콤보 응답(unknown[]) -> PlantSiteSource. NonOsp/Osp 콤보 모두 동일 컬럼(CODE/NAME/OSP_YN/OPERATION_GROUP/DIVISION_ID).
export const toPlantSiteSource = (rows: readonly unknown[] | undefined): PlantSiteSource[] =>
  (rows ?? []).map(r => {
    const rec = r as Record<string, unknown>;
    return {
      CODE: s(rec.CODE),
      NAME: s(rec.NAME),
      OSP_YN: s(rec.OSP_YN),
      OPERATION_GROUP: s(rec.OPERATION_GROUP),
      DIVISION_ID: s(rec.DIVISION_ID),
    };
  });

// dtPlantSite(DefineProperty L135~148) — NonOsp(OPERATION_GROUP IN P/E/A) ∪ Osp(OPERATION_GROUP IN P/E).
const combinedBase = (nonOsp: PlantSiteSource[], osp: PlantSiteSource[]): PlantSiteSource[] => [
  ...nonOsp.filter(r => ['P', 'E', 'A'].includes(r.OPERATION_GROUP)),
  ...osp.filter(r => ['P', 'E'].includes(r.OPERATION_GROUP)),
];

const dedup = (rows: PlantSiteSource[]): PlantSiteSource[] => [
  ...new Map(rows.map(r => [r.CODE, r])).values(),
];

// ===== 조회영역 clbPlantSite 후보 (design 02 §3) =====
//   LT Operation 단일 선택 시 NonOsp 원본을 OPERATION_GROUP 로 좁힘, 그 외/다중/미선택은
//   dtPlantSite(NonOsp P/E/A ∪ Osp P/E) 전체. Division 체크값으로 division 필터.
//   filterCalls #5(OSP_LT) AS-IS 원문 AND 누락 결함은 의도된 AND 로 구현(design 02 §7#2, convert-core §1).
export const buildSearchPlantSiteOptions = (
  nonOsp: PlantSiteSource[],
  osp: PlantSiteSource[],
  divisionIds: string[],
  ltOperationIds: string[]
): { label: string; value: string }[] => {
  const inDivs = (r: PlantSiteSource): boolean =>
    divisionIds.length === 0 || divisionIds.includes(r.DIVISION_ID);

  let src: PlantSiteSource[];
  if (ltOperationIds.length === 1) {
    // 단일 LT Operation 분기 — AS-IS SetChangedControl 은 NonOsp 원본(dtPlantSiteByDivisionAll)만 사용.
    const nonOspInDiv = nonOsp.filter(inDivs);
    const g = (r: PlantSiteSource): string => r.OPERATION_GROUP;
    switch (ltOperationIds[0]) {
      case LT_OP.SLITTING:
        src = nonOspInDiv.filter(r => g(r) === 'E');
        break;
      case LT_OP.PRE_INSP:
        src = nonOspInDiv.filter(r => g(r) === 'P');
        break;
      case LT_OP.OSP_LT:
        src = nonOspInDiv.filter(r => g(r) === 'P' || g(r) === 'E'); // AND 결함 -> 의도된 IN('P','E')
        break;
      case LT_OP.CTP_LT:
        src = nonOspInDiv.filter(r => g(r) === 'A');
        break;
      default:
        src = combinedBase(nonOsp, osp).filter(inDivs);
    }
  } else {
    // else(미선택/다중) — dtPlantSite 전체(NonOsp P/E/A ∪ Osp P/E).
    src = combinedBase(nonOsp, osp).filter(inDivs);
  }
  return dedup(src).map(r => ({ label: r.NAME || r.CODE, value: r.CODE }));
};

// ===== 신규행 SCM_SITE_ID 셀콤보 후보 (design 03 §3-2) =====
//   그 행의 DIVISION_ID + LT_OPERATION 으로 OSP_YN/OPERATION_GROUP 좁힘. 원본 = NonOsp ∪ Osp(OSP_YN 보유).
export const buildCellPlantSiteCandidates = (
  nonOsp: PlantSiteSource[],
  osp: PlantSiteSource[],
  rowDivision: string,
  rowLtOperation: string
): PlantSiteSource[] => {
  const inDiv = [...nonOsp, ...osp].filter(r => r.DIVISION_ID === rowDivision);
  const g = (r: PlantSiteSource): string => r.OPERATION_GROUP;
  let out: PlantSiteSource[];
  switch (rowLtOperation) {
    case LT_OP.SLITTING:
      out = inDiv.filter(r => r.OSP_YN === 'N' && g(r) === 'E');
      break;
    case LT_OP.PRE_INSP:
      out = inDiv.filter(r => r.OSP_YN === 'N' && g(r) === 'P');
      break;
    case LT_OP.OSP_LT:
      out = inDiv.filter(r => r.OSP_YN === 'Y');
      break;
    case LT_OP.CTP_LT:
      out = inDiv.filter(r => r.OSP_YN === 'N' && g(r) === 'A');
      break;
    default:
      out = inDiv;
  }
  return dedup(out);
};
