import type { FlexGrid } from '@mescius/wijmo.grid';

// design 01 §2(#2,#6) + design 03 §1.1/§3(gridSignals#7~18) 편집잠금 재현.
//   AS-IS 규칙: DIVISION_ID·감사4컬럼(CREATED_BY/CREATION_DATE/LAST_UPDATED_BY/LAST_UPDATE_DATE)
//   + PRE_KEY_VALUES 는 신규행 포함 항상 잠금(LockColumn/LockRange). AS-IS EditButton(SwitchLock)
//   의 "수정 모드" 토글 어포던스 자체는 TO-BE 미이식 결정(전 화면 공통, `.atlas/memory/
//   editbutton-toggle-not-ported.md`, `Doc/Doc_lgc_bak/rules/11_asis_parity/asis_to_tobe.md §11`) — 아래는 그 토글과
//   무관하게 항상 잠겨야 하는 컬럼 화이트리스트(AS-IS LockColumn 하드코딩 컬럼)만 판정한다.

// AS-IS gridSignals#8/#9/#13/#14 LockColumn/LockRange 대상(신규행 포함 항상 잠금).
export const ALWAYS_LOCKED_COLUMNS = [
  'DIVISION_ID',
  'CREATED_BY',
  'CREATION_DATE',
  'LAST_UPDATED_BY',
  'LAST_UPDATE_DATE',
  'PRE_KEY_VALUES',
] as const;

/**
 * 셀 편집 가능 여부. ALWAYS_LOCKED_COLUMNS 만 예외 없이 잠금, 그 외 컬럼은 조회 직후에도 바로
 * 편집 가능(EditButton 토글 어포던스 미이식). ITEM_ID 는 admin 메타 Cell Object 타입(FPTextModal)
 * 대로 key-in 과 더블클릭 팝업을 모두 허용한다(사용자 지시 2026-11-23 — AS-IS 팝업 전용 하드코딩 제거).
 */
export const isCellEditable = (binding: string): boolean => {
  if ((ALWAYS_LOCKED_COLUMNS as readonly string[]).includes(binding)) return false;
  return true;
};

// MAX_CAPA/STOR_PER 음수 클램프 0(design 03 §3 #27, MSG00193/MSG00085). 정수 여부는 admin
//   DATA_SCALE_NUMBER 가 두 컬럼 모두 NULL(design 03 §6-11 확인 필요)이라 이 화면은 부호만 강제한다.
export const clampNonNegative = (raw: unknown): { value: number; coerced: boolean } => {
  const num = Number(raw);
  if (Number.isNaN(num) || num < 0) return { value: 0, coerced: true };
  return { value: num, coerced: false };
};

// MAX_CAPA(WhCapa)/STOR_PER(Item Mapping) 정수부 10자리 제한(사용자 요청 2026-11-10). admin
//   DATA_MAX_LENGTH 는 두 컬럼 모두 NULL 이지만 메타는 건드리지 않고 화면 코드로만 막는다.
//   천단위 콤마·부호·소수부는 자릿수에 넣지 않는다.
export const MAX_INTEGER_DIGITS = 10;
export const DIGIT_LIMITED_COLUMNS = ['MAX_CAPA', 'STOR_PER'] as const;
export const isDigitLimitedColumn = (binding: string): boolean =>
  (DIGIT_LIMITED_COLUMNS as readonly string[]).includes(binding);
export const isWithinDigitLimit = (text: unknown): boolean => {
  const raw = typeof text === 'string' || typeof text === 'number' ? String(text) : '';
  const intPart = raw.split('.')[0] ?? '';
  return intPart.replace(/\D/g, '').length <= MAX_INTEGER_DIGITS;
};

// 위 제한을 그리드에 건다(WarehouseCapacityGrid/WarehouseItemMappingGrid 공용). 타이핑은 초과 입력
//   자체를 막고, 붙여넣기·확정은 값을 반영하지 않는다(공용 DataGrid numberRules 와 같은 방식). 반환값은
//   핸들러 해제 함수.
export const attachDigitLimit = (g: FlexGrid): (() => void) => {
  const prepareHandler = (sender: FlexGrid, e: { col: number }) => {
    if (!isDigitLimitedColumn(sender.columns[e.col]?.binding ?? '')) return;
    const editor = sender.activeEditor;
    if (!editor) return;
    editor.addEventListener('beforeinput', (inputEvent: InputEvent) => {
      if (inputEvent.data == null) return;
      const { value, selectionStart, selectionEnd } = editor;
      const next =
        value.slice(0, selectionStart ?? value.length) +
        inputEvent.data +
        value.slice(selectionEnd ?? value.length);
      if (!isWithinDigitLimit(next)) inputEvent.preventDefault();
    });
  };
  const editEndingHandler = (sender: FlexGrid, e: { col: number; cancel: boolean }) => {
    if (e.cancel || !isDigitLimitedColumn(sender.columns[e.col]?.binding ?? '')) return;
    const editor = sender.activeEditor;
    if (editor && !isWithinDigitLimit(editor.value)) e.cancel = true;
  };
  const pastingHandler = (sender: FlexGrid, e: { col: number; data: unknown; cancel: boolean }) => {
    if (e.cancel || !isDigitLimitedColumn(sender.columns[e.col]?.binding ?? '')) return;
    if (!isWithinDigitLimit(e.data)) e.cancel = true;
  };
  g.prepareCellForEdit.addHandler(prepareHandler as never);
  g.cellEditEnding.addHandler(editEndingHandler as never);
  g.pastingCell.addHandler(pastingHandler as never);
  return () => {
    g.prepareCellForEdit?.removeHandler(prepareHandler as never);
    g.cellEditEnding?.removeHandler(editEndingHandler as never);
    g.pastingCell?.removeHandler(pastingHandler as never);
  };
};

// Warehouse Item Mapping 시트 전용(design 03 §1.2 #7~9, AS-IS SCP0133_WarehouseCapacity.cs:512-532).
//   STOR_LOC_NAME 컬럼은 division 에 '81_UC' 가 포함될 때만 표시(그 외 division 은 숨김) — AS-IS
//   `SetVisibleSheetColumn(STOR_LOC_NAME, 80, true/false)`처럼 너비를 직접 덮어씀. admin 메타는
//   VISIBLE_FLAG='N'/COLUMN_WIDTH=0 고정이라 컬럼 목록에서 빼고 넣는 것만으론 안 보인다
//   (WarehouseItemMappingGrid.tsx columns useMemo 가 colWth/visible 을 직접 덮어쓴다).
export const STOR_LOC_NAME_DIVISION_KEYWORD = '81_UC';
export const isStorLocNameVisible = (divisionId: string): boolean =>
  divisionId.includes(STOR_LOC_NAME_DIVISION_KEYWORD);

// Site 콤보(조회조건 + 그리드 셀)의 Division cascade — AS-IS RefreshSiteByDivision EE 분기 재현.
//   · 'EE'                → DIVISION_ID IN ('81','40','82') (Cell 3 사업부 전체)
//   · 'EE_UC/HM/ST/HD/HG' → '81_UC/81_HM/81_ST/81_HD/81_HG' 매핑 후 일치(GetDivisionChecked)
//   · 그 외               → DIVISION_ID = 선택 Division (원값)
//   memory scp-site-combo-ee-branch-not-global-base-filter: 단순 `includes(['81','40','82']) AND
//   =division` 으로 이식하면 EE·EE_* 선택 시 Site 가 통째로 빈다(실사고). 자매 SCP0127/0128
//   matchSiteByDivision 과 동형. PlanGroup/Stage 는 EE 특수분기 없이 단순일치라 메타 cascade
//   (ATTRIBUTE2='DIVISION_ID:DIVISION_ID')로 처리하고 Site 만 이 화면 코드가 불가피하다.
const EE_SUB_DIVISION_MAP: Record<string, string> = {
  EE_UC: '81_UC',
  EE_HM: '81_HM',
  EE_ST: '81_ST',
  EE_HD: '81_HD',
  EE_HG: '81_HG',
};
export const matchSiteByDivision = (siteDivisionId: unknown, selectedDivision: string): boolean => {
  const sid = typeof siteDivisionId === 'string' ? siteDivisionId : '';
  if (!selectedDivision) return true;
  if (selectedDivision === 'EE') return ['81', '40', '82'].includes(sid);
  return sid === (EE_SUB_DIVISION_MAP[selectedDivision] ?? selectedDivision);
};

// STOR_LOC_NAME(East/West 직접입력) → STOR_LOC 코드 파생(AS-IS .cs:1317-1336 ClipboardPasted,
//   1388-1406 ComboSelChange — 붙여넣기·셀 변경 두 경로 모두 동일 매핑). 그 외 값은 빈 코드.
export const deriveStorLocCode = (storLocName: unknown): string => {
  const name = typeof storLocName === 'string' ? storLocName : '';
  if (name === 'East') return '@E';
  if (name === 'West') return '@W';
  return '';
};

// WhCapa 저장행 FROM/TO 날짜 검증(AS-IS SaveData_WhCapa .cs:829-845 재현, 07_validation-audit S3·S4).
//   셀 값은 FPDate 경로(Date / 'yyyy-MM-dd' / 'yyyy-MM-dd HH:mm:ss' / 'yyyyMMdd')로 들어올 수 있어
//   숫자만 추출해 YYYYMMDD 로 정규화한 뒤 형식·대소를 비교한다. 빈값은 공통 필수검증(saveWithValidation)
//   소관이라 여기서 건너뛴다.
const pad2 = (n: number): string => String(n).padStart(2, '0');
export const normalizeYmd = (v: unknown): string => {
  if (v instanceof Date) return `${v.getFullYear()}${pad2(v.getMonth() + 1)}${pad2(v.getDate())}`;
  if (typeof v === 'string') return v.replace(/\D/g, '').slice(0, 8);
  if (typeof v === 'number') return String(v).replace(/\D/g, '').slice(0, 8);
  return '';
};
export const isValidYmd = (ymd: string): boolean => {
  if (!/^\d{8}$/.test(ymd)) return false;
  const y = Number(ymd.slice(0, 4));
  const m = Number(ymd.slice(4, 6));
  const d = Number(ymd.slice(6, 8));
  const dt = new Date(y, m - 1, d);
  return dt.getFullYear() === y && dt.getMonth() === m - 1 && dt.getDate() === d;
};

// OPMZ_PLAN_GR_ID 빈 값 표시(QA I-06, 사용자 보고 2026-11-10) — formatItem 에서 텍스트만 지우고
//   Wijmo 가 콤보 컬럼에 같이 심어 둔 드롭다운 화살표 등 자식 요소는 건드리지 않는다.
//   `cell.textContent = ''` 는 자식 노드를 통째로 비워 그 요소까지 같이 지워버린다(2026-11-10
//   실사고 — 편집 진입은 되는데 드롭다운 화살표/목록이 안 보임). 텍스트 노드만 선별해 비운다.
export const clearCellText = (cell: HTMLElement): void => {
  cell.childNodes.forEach(node => {
    if (node.nodeType === Node.TEXT_NODE) node.textContent = '';
  });
};

// 행의 OPMZ_PLAN_GR_ID 가 유효 Plan Group 집합 밖인지(= 화면에 빈값으로 보여야 하는지) 판정.
//   validKeys 는 `DIVISION_ID|CODE` 형식(WarehouseCapacityGrid/WarehouseItemMappingGrid 공용).
const toPlainString = (v: unknown): string =>
  typeof v === 'string' || typeof v === 'number' ? String(v) : '';

export const isInvalidPlanGroupRow = (
  row: Record<string, unknown> | undefined,
  validKeys: Set<string>
): boolean => {
  if (!row || !row.OPMZ_PLAN_GR_ID) return false;
  const key = `${toPlainString(row.DIVISION_ID)}|${toPlainString(row.OPMZ_PLAN_GR_ID)}`;
  return !validKeys.has(key);
};

// 저장 대상 행들의 날짜 결함을 찾는다. 'format' = YYYYMMDD 형식 오류(S3, AS-IS DateTime.ParseExact
//   예외/MSG00046) · 'order' = From>To(S4, AS-IS MSG00219). 하나라도 있으면 첫 결함 종류를 반환.
export type PeriodErrorKind = 'format' | 'order';
export const findPeriodError = (rows: readonly Record<string, unknown>[]): PeriodErrorKind | null => {
  for (const row of rows) {
    const from = normalizeYmd(row.FROM_YYYYMMDD);
    const to = normalizeYmd(row.TO_YYYYMMDD);
    if ((from && !isValidYmd(from)) || (to && !isValidYmd(to))) return 'format';
    if (from && to && from > to) return 'order';
  }
  return null;
};
