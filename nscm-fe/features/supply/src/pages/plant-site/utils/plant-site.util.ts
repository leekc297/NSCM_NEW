import type { ComboResponse, RawFlexGridColumnConfig } from '@foundation/models';

import { CONST, MSG } from '../plant-site.constants';

interface Option {
  label: string;
  value: string;
}

// 저장 커스텀 검증 결과 — null 이면 통과, 아니면 차단 메시지 코드 + args.
export interface SaveValidationError {
  code: string;
  args?: string[];
}

// staticColumns 메타에서 컬럼 라벨(colLblNm) 조회 — 필수/중복 메시지 args 에 AS-IS 헤더 텍스트를 넣는다.
const columnLabel = (cols: RawFlexGridColumnConfig[], colNm: string): string =>
  cols.find(c => c.colNm === colNm)?.colLblNm ?? colNm;

type Cell = Record<string, unknown>;

export const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const isDirty = (row: Cell): boolean => !!str(row.CRUD_TYPE);

// 콤보 응답 -> 드롭다운 옵션(CODE/NAME). CODE 중복은 첫 행 우선, 빈 코드 제거.
export const toComboOptions = (rows: ComboResponse[] | undefined): Option[] => [
  ...new Map(
    (rows ?? [])
      .map(row => [str(row.CODE).trim(), row] as const)
      .filter(([code]) => code !== '')
      .map(([code, row]) => [code, { label: str(row.NAME).trim() || code, value: code }] as const)
  ).values(),
];

// Division 콤보 — AS-IS GetDivisionWithoutEE 재현: ATTRIBUTE3<>'EE'(전극 제외) 클라 필터.
//   Division_SCP CMBO WHERE 에 이 필터가 없어 FE 재현 필수(design 02 §2-1, operation-lt 선례).
export const filterEeDivisions = (rows: ComboResponse[] | undefined): ComboResponse[] =>
  (rows ?? []).filter(r => str(r.ATTRIBUTE3) !== 'EE');

// Division 선택값으로 Plant Site(Bod From Site 공유 콤보) 행을 client-side 필터링.
//   서버 재조회 없이 1회 조회한 전체 목록을 DIVISION_ID 로 좁힌다(Bod.buildDivisionFilteredOptions와 동일 패턴,
//   cascade-combo-filter.md §4). divisionId 가 비어있거나 'ALL' 이면 전체 통과.
export const filterPlantSiteByDivision = (rows: ComboResponse[] | undefined, divisionId: string): Option[] => {
  const divisionCodes = str(divisionId)
    .split(',')
    .map(v => v.trim())
    .filter(v => v !== '' && v.toUpperCase() !== 'ALL');

  const byCode = new Map<string, Option>();
  for (const row of rows ?? []) {
    const code = str(row.CODE).trim();
    if (code === '') continue;
    if (divisionCodes.length > 0) {
      const rowDivision = str(row.DIVISION_ID).trim();
      if (rowDivision !== '' && !divisionCodes.includes(rowDivision)) continue;
    }
    if (byCode.has(code)) continue;
    byCode.set(code, { label: str(row.NAME).trim() || code, value: code });
  }
  return [...byCode.values()];
};

// 'ALL' sentinel(다중선택 전체) -> 권한 division(EE 제외) 전 코드 콤마 확장.
//   주의: null/빈문자 전달 금지 — GET SP 는 P_DIVISION_ID IS NULL 이면 권한 무관 전체를 반환한다
//   (권한 우회 결함, design 02 §2-1 권한 함정). 그래서 ALL 은 권한 division 콤마 목록으로 넘긴다.
export const expandDivisionAll = (selected: string, authDivisions: string[]): string => {
  const picked = str(selected)
    .split(',')
    .map(v => v.trim())
    .filter(v => v !== '' && v.toUpperCase() !== 'ALL');
  const codes = picked.length > 0 ? picked : authDivisions;
  return codes.join(',');
};

// 조회조건 콤보 'ALL' -> null(OSP/Active). SP 는 IS NULL 이면 전체(design 02 §2-2).
export const comboAllToNull = (value: string): string | null =>
  !value || value.toUpperCase() === 'ALL' ? null : value;

// SCM_SITE_ID 파생식: PLANT_ID + "_" + DIVISION_ID + "-" + OPERATION_GROUP (design 03 R-17·21).
//   PLANT_ID 가 공백이면 파생하지 않는다(AS-IS cs:1805~1836 가드).
export const deriveScmSiteId = (
  plantId: string,
  divisionId: string,
  operationGroup: string
): string => {
  if (!str(plantId)) return '';
  return `${str(plantId)}_${str(divisionId)}-${str(operationGroup)}`;
};

// 신규행 기본값 lookup(DEFAULT_PERIOD) 조회 — CODE(SEGMENT1) 로 NAME(SEGMENT2) 값을 읽는다.
//   AS-IS dtPlanPeriod.Select().Where(code==...)["NAME"](cs:1439~1441) 재현. 행 부재 시 실측 현재값 '0' fallback
//   (AS-IS 는 FirstOrDefault 무방어 — 방어만 추가, 값 원천은 lookup).
export const defaultPeriodOf = (rows: ComboResponse[] | undefined, code: string): string => {
  const hit = (rows ?? []).find(r => str(r.CODE) === code);
  return hit ? str(hit.NAME) : '0';
};

// site.PACKER_ITEM_ID_SUFFIX 행 편집 허용 여부 — DIVISION_ID='40' AND OSP_YN='Y' (design 03 R-05·22).
export const canEditPackerSuffix = (divisionId: unknown, ospYn: unknown): boolean =>
  str(divisionId) === CONST.AUTOMOTIVE_DIVISION && str(ospYn) === 'Y';

// site.PACKER_LINE_ACTIVE_YN 행 편집 허용 여부 — OSP_YN='Y' (design 03 R-05·23).
export const canEditPackerLineActive = (ospYn: unknown): boolean => str(ospYn) === 'Y';

// OPERATION_GROUP='W'(Warranty) 행 판정(design 03 R-05).
export const isWarrantyRow = (operationGroup: unknown): boolean =>
  str(operationGroup) === CONST.WARRANTY_OP_GROUP;

// 행 조건부 편집 잠금 판정 — beginningEdit(차단)·formatItem(배경색)·pastingCell(붙여넣기)이 같은 함수를
//   써야 한다(grid-behavior-parity §2, hook #95 — 노란칸인데 못 고치는 상태·붙여넣기 우회 방지).
//   메타(INPUT_TP_CD) 판정은 공용 DataGrid 가 먼저 하고, 여기는 행 조건으로 잠그는 컬럼만 추가 판정한다.
export const isSiteCellRowLocked = (binding: string, row: Cell): boolean => {
  // DIVISION_ID/OPERATION_GROUP: 기존행 잠금 — 신규행('I')만 편집. SCM_SITE_ID 파생식
  //   (PLANT_ID+DIVISION_ID+OPERATION_GROUP, R-21)의 구성요소라 기존행에서 바꾸면 저장키가 조용히 바뀐다.
  //   SITE_DESCRIPTION 은 이 그룹이 아니다 — DB 메타(INPUT_TP_CD='OPTIONAL')상 일반 편집 컬럼이고
  //   파생식에도 들어가지 않는다(2026-09-28 커밋에서 함께 잠갔던 건 회귀 — 기존행 Plant Site 이름을
  //   고칠 수 없게 돼 사용자 보고로 재확인 후 원복, design 03 §1.1-7).
  if (binding === 'DIVISION_ID' || binding === 'OPERATION_GROUP') {
    return str(row.CRUD_TYPE) !== 'I';
  }
  // R-22: DIVISION_ID='40' AND OSP_YN='Y' 행만 편집.
  if (binding === 'PACKER_ITEM_ID_SUFFIX') return !canEditPackerSuffix(row.DIVISION_ID, row.OSP_YN);
  // R-23: OSP_YN='Y' 행만 편집.
  if (binding === 'PACKER_LINE_ACTIVE_YN') return !canEditPackerLineActive(row.OSP_YN);
  return false;
};

// customer: EDIT_FLAG='N' 기존행은 전 컬럼 편집 차단(hook #128 행 게이트, design 03 §1.3-9).
export const isCustomerCellRowLocked = (row: Cell): boolean =>
  str(row.CRUD_TYPE) !== 'I' && str(row.EDIT_FLAG) === 'N';

// locationOsp: STORAGE_ID 는 MERGE 키 — 기존행 편집 잠금(교정 §6-8③, 신규행만 편집).
export const isLocationOspCellRowLocked = (binding: string, row: Cell): boolean =>
  binding === 'STORAGE_ID' && str(row.CRUD_TYPE) !== 'I';

// R-33 + R-34: Location 저장 전 커스텀 검증(AS-IS cs:1103-1131·1947-2016 재현).
//   R-33 필수: 변경행(I/M/D) 중 STORAGE_ID 공백이면 FACTORY_ID·OPERATION_ID 필수(MSG00614 args=라벨).
//   R-34 중복: 변경행을 전 행과 비교 — STORAGE_ID 있으면 STORAGE 중복 금지 / 없으면 (FACTORY,OPERATION)
//     조합 중복 금지(MSG00060). AS-IS 는 j 루프가 전 행 대상이므로 all 로 비교한다.
export const validateLocationSave = (
  allRows: Cell[],
  cols: RawFlexGridColumnConfig[]
): SaveValidationError | null => {
  const dirty = allRows.filter(isDirty);
  // R-33 필수
  for (const row of dirty) {
    if (str(row.STORAGE_ID)) continue;
    if (!str(row.FACTORY_ID))
      return { code: MSG.REQUIRE_VALUE, args: [columnLabel(cols, 'FACTORY_ID2')] };
    if (!str(row.OPERATION_ID))
      return { code: MSG.REQUIRE_VALUE, args: [columnLabel(cols, 'OPERATION_ID2')] };
  }
  // R-34 중복(변경행 x 전 행)
  for (const row of dirty) {
    const storage = str(row.STORAGE_ID);
    const factory = str(row.FACTORY_ID);
    const operation = str(row.OPERATION_ID);
    for (const other of allRows) {
      if (other === row) continue;
      if (storage) {
        if (str(other.STORAGE_ID) === storage)
          return { code: MSG.DUPLICATE_KEY, args: [columnLabel(cols, 'STORAGE_ID')] };
      } else {
        if (!factory || !operation) continue;
        if (str(other.FACTORY_ID) === factory && str(other.OPERATION_ID) === operation)
          return {
            code: MSG.DUPLICATE_KEY,
            args: [`${columnLabel(cols, 'FACTORY_ID2')}/${columnLabel(cols, 'OPERATION_ID2')}`],
          };
      }
    }
  }
  return null;
};

// R-38: customer 신규행(CRUD_TYPE='I') 의 SOLDTO_CODE/SHIPTO_CODE 공백 검사(AS-IS cs:1246-1253).
export const validateCustomerSave = (allRows: Cell[]): SaveValidationError | null => {
  const invalid = allRows.some(
    row => str(row.CRUD_TYPE) === 'I' && (!str(row.SOLDTO_CODE) || !str(row.SHIPTO_CODE))
  );
  return invalid ? { code: MSG.CUSTOMER_REQUIRED } : null;
};
