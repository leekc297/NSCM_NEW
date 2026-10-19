// New Plan 팝업(AS-IS SCM0002_ShipmentPlanInsertPopup) 순수 규칙 — 행 기본값, 잠금, 필수값, 중복 검사, SP 인자 조립.
//   근거: .atlas/gscm-design/SCM0002/design/00_checklist.md ~ 03_grid-columns.md. 화면(wijmo)에 의존하지 않아 vitest 로 검증한다.
export type NewPlanProgramId = 'FG' | 'SEMI';

// 호출 화면 조회조건에서 넘어오는 값. 모든 행에 읽기 전용으로 붙는다(AS-IS InsertRow, 팝업.cs:375-379).
export interface NewPlanContext {
  divisionId: string;
  operationGroupId: string;
  planStartYyyymmdd: string; // 하이픈이 섞여 있어도 SP 인자로 만들 때 제거한다
  planType: string;
  planSeq: string;
  programId: NewPlanProgramId;
}

// 편집 가능한 그리드 행. BOD 팝업이 채우는 값(voyage, L/T, From, To)도 같이 보관한다.
export interface NewPlanRow {
  rowKey: string;
  itemId: string;
  projectCode: string;
  electrodeType: string;
  projectName: string;
  originFromDivisionId: string;
  fromSite: string;
  originToDivisionId: string;
  toSite: string;
  bodId: string;
  incoterms: string;
  transportMode: string;
  voyageMon: string;
  voyageTue: string;
  voyageWed: string;
  voyageThu: string;
  voyageFri: string;
  voyageSat: string;
  voyageSun: string;
  ltDay: string;
  fromYyyymmdd: string;
  toYyyymmdd: string;
  // EE 에서 Model 을 바꾸면 Project 이름을 비우고 이후 다시 열지 않는다(AS-IS 팝업.cs:812, 817).
  projectNameLocked?: boolean;
}

export type NewPlanColumnKey = Exclude<keyof NewPlanRow, 'rowKey' | 'projectNameLocked'>;

// BOD 팝업 OK 결과 한 건(AS-IS SCM0002_GetBODItemPopup 반환 필드, .cs:320-337).
export interface BodPick {
  fromSite: string;
  toSite: string;
  bodId: string;
  incoterms: string;
  transportMode: string;
  voyageMon: string;
  voyageTue: string;
  voyageWed: string;
  voyageThu: string;
  voyageFri: string;
  voyageSat: string;
  voyageSun: string;
  ltDay: string;
  fromYyyymmdd: string;
  toYyyymmdd: string;
}

// 호출부 EE 판정 — AS-IS 는 division.Substring(0, 2) == "EE" 이다.
export const isEeDivision = (divisionId: string): boolean => divisionId.startsWith('EE');

// EE+Operation Group A 조합은 FG 호출부에서만 팝업을 막는다(SEMI 는 가드가 없다, FG .cs:1130-1131).
export const isNewPlanBlocked = (ctx: Pick<NewPlanContext, 'divisionId' | 'operationGroupId' | 'programId'>): boolean =>
  ctx.programId === 'FG' && isEeDivision(ctx.divisionId) && ctx.operationGroupId === 'A';

// 수정 불가 Plan Type — AS-IS 팝업.cs:463-467 이 FN 이면 저장을 막는다(MSG00182).
export const isPlanTypeLocked = (planType: string): boolean => planType === 'FN';

const trim = (v: string | undefined | null): string => (v ?? '').trim();

let rowSeq = 0;
const nextRowKey = (): string => `np-${(rowSeq += 1)}`;

// 새 행. 비EE 는 Origin From/To Div 를 division 으로 채운다(팝업.cs:380-400). EE 는 사용자가 고른다.
export const createEmptyRow = (ctx: NewPlanContext): NewPlanRow => {
  const origin = isEeDivision(ctx.divisionId) ? '' : ctx.divisionId;
  return {
    rowKey: nextRowKey(),
    itemId: '',
    projectCode: '',
    electrodeType: '',
    projectName: '',
    originFromDivisionId: origin,
    fromSite: '',
    originToDivisionId: origin,
    toSite: '',
    bodId: '',
    incoterms: '',
    transportMode: '',
    voyageMon: '',
    voyageTue: '',
    voyageWed: '',
    voyageThu: '',
    voyageFri: '',
    voyageSat: '',
    voyageSun: '',
    ltDay: '',
    fromYyyymmdd: '',
    toYyyymmdd: '',
  };
};

// 복제 행(AS-IS InsertRow2) — Origin From/To Div 와 Model 만 복사하고 Electrode Type 은 비운다(팝업.cs:1043-1045, 434).
export const createClonedRow = (ctx: NewPlanContext, parent: NewPlanRow): NewPlanRow => ({
  ...createEmptyRow(ctx),
  originFromDivisionId: parent.originFromDivisionId,
  originToDivisionId: parent.originToDivisionId,
  itemId: parent.itemId,
});

// BOD 선택 결과를 행에 반영한다. 호출 행의 Project Code 는 호출 쪽이 후보를 보고 따로 정한다.
export const applyBodPick = (row: NewPlanRow, pick: BodPick): NewPlanRow => ({ ...row, ...pick });

// 항상 잠금인 컬럼 — Div~Operation Group(그리드에는 없음), BOD 팝업이 채우는 구간, From/To Site(팝업.cs:327-328, 388-391).
const ALWAYS_LOCKED: ReadonlySet<NewPlanColumnKey> = new Set<NewPlanColumnKey>([
  'fromSite',
  'toSite',
  'bodId',
  'incoterms',
  'transportMode',
  'voyageMon',
  'voyageTue',
  'voyageWed',
  'voyageThu',
  'voyageFri',
  'voyageSat',
  'voyageSun',
  'ltDay',
  'fromYyyymmdd',
  'toYyyymmdd',
]);

// BOD 컬럼은 클릭으로 BOD 팝업을 여는 컬럼이라 직접 입력은 막지만 클릭은 허용한다. 편집 여부와 구분해 따로 둔다.
export const isBodClickColumn = (key: NewPlanColumnKey): boolean => key === 'bodId';

// 선행 선택이 없으면 잠기는 컬럼(팝업.cs:733-825 cascade 와 396, 404-405, 1093 의 잠금 해제).
//   Model: 비EE 는 처음부터 선택 가능, EE 는 Origin From/To Div 를 모두 고른 뒤에 가능하다.
//   Project Code: FG 에서만 쓰고, BOD 를 고른 뒤에야 풀린다(BOD 선택이 후보를 만든다).
//   Electrode Type: EE 는 Operation Group 과 무관하게 선택할 수 있다(필수 여부만 Operation Group E 에 따른다, 팝업.cs:396-406).
//   Project 이름: 비EE 는 잠기고, EE 는 Model 을 바꾸기 전까지만 직접 입력할 수 있다. 서버로 보내지 않는 값이다.
export const isCellEditable = (ctx: NewPlanContext, row: NewPlanRow, key: NewPlanColumnKey): boolean => {
  if (ALWAYS_LOCKED.has(key)) return false;
  const ee = isEeDivision(ctx.divisionId);
  if (key === 'originFromDivisionId' || key === 'originToDivisionId') return ee;
  if (key === 'electrodeType') return ee;
  if (key === 'itemId') return !ee || (row.originFromDivisionId !== '' && row.originToDivisionId !== '');
  if (key === 'projectCode') return ctx.programId === 'FG' && row.bodId !== '';
  if (key === 'projectName') return ee && !row.projectNameLocked;
  return true;
};

// 셀 값 변경 cascade — AS-IS SpdMain_ComboSelChange(팝업.cs:733-825). 하위 값을 비우고 BOD 구간도 비운다.
//   Origin Div 변경 시 Model 은 새 후보에 남아 있을 때만 유지하므로 호출 쪽이 itemStillValid 로 알려 준다.
const BOD_SECTION_KEYS: NewPlanColumnKey[] = [
  'bodId',
  'incoterms',
  'transportMode',
  'voyageMon',
  'voyageTue',
  'voyageWed',
  'voyageThu',
  'voyageFri',
  'voyageSat',
  'voyageSun',
  'ltDay',
  'fromYyyymmdd',
  'toYyyymmdd',
];

const clearKeys = (row: NewPlanRow, keys: NewPlanColumnKey[]): NewPlanRow => {
  const next = { ...row };
  keys.forEach(k => {
    next[k] = '';
  });
  return next;
};

export const applyCellChange = (
  row: NewPlanRow,
  key: NewPlanColumnKey,
  value: string,
  options: { itemStillValid?: boolean; projectName?: string } = {}
): NewPlanRow => {
  const next: NewPlanRow = { ...row, [key]: value };
  if (key === 'originFromDivisionId' || key === 'originToDivisionId') {
    const bothSelected = next.originFromDivisionId !== '' && next.originToDivisionId !== '';
    const keepItem = bothSelected && options.itemStillValid === true;
    // AS-IS SpdMain_ComboSelChange(.cs:739-805)는 Origin From/To Div 변경 시 PROJECT_NAME(Project)을 지우지
    //   않는다 — item(재검증)·projectCode·fromSite·toSite·BOD 구간만 초기화한다. projectName 은 Model(ITEM_ID)
    //   변경 시에만 비운다(.cs:811-812). EE 는 projectName 이 사용자 직접 입력이라 Origin Div 를 바꿔도 유지돼야 한다.
    return clearKeys(next, [
      ...(keepItem ? [] : (['itemId'] as NewPlanColumnKey[])),
      'projectCode',
      'fromSite',
      'toSite',
      ...BOD_SECTION_KEYS,
    ]);
  }
  if (key === 'itemId') {
    return {
      ...clearKeys(next, ['projectCode', 'projectName', 'fromSite', 'toSite', ...BOD_SECTION_KEYS]),
      projectNameLocked: true,
    };
  }
  if (key === 'projectCode') return { ...next, projectName: options.projectName ?? '' };
  return next;
};

// 컬럼을 화면에 보일지. 비EE 는 Origin Div 두 컬럼과 Electrode Type 을, SEMI 는 Project Code 를 폭 0 으로 숨긴다(팝업.cs:380-412).
export const isColumnVisible = (ctx: NewPlanContext, key: NewPlanColumnKey): boolean => {
  const ee = isEeDivision(ctx.divisionId);
  if (key === 'originFromDivisionId' || key === 'originToDivisionId') return ee;
  if (key === 'electrodeType') return ee;
  if (key === 'projectCode') return ctx.programId === 'FG';
  return true;
};

// 필수 컬럼. AS-IS 는 헤더에 `*` 가 붙은 컬럼을 검사한다. Electrode Type 은 비EE 에서 숨겨졌는데도 `*` 가 남아
//   저장이 영구히 막히는 결함이 있어(팝업.cs:258-261, 399) EE 이고 Operation Group 이 E 일 때만 필수로 둔다.
export const getRequiredColumns = (ctx: NewPlanContext): NewPlanColumnKey[] => {
  const cols: NewPlanColumnKey[] = [
    'itemId',
    'originFromDivisionId',
    'fromSite',
    'originToDivisionId',
    'toSite',
    'bodId',
    'incoterms',
    'transportMode',
  ];
  if (ctx.programId === 'FG') cols.push('projectCode');
  if (isEeDivision(ctx.divisionId) && ctx.operationGroupId === 'E') cols.push('electrodeType');
  return cols;
};

export interface MissingRequired {
  rowIndex: number;
  column: NewPlanColumnKey;
}

// 첫 번째 누락 위치. 모두 채워져 있으면 null.
export const findMissingRequired = (ctx: NewPlanContext, rows: NewPlanRow[]): MissingRequired | null => {
  const cols = getRequiredColumns(ctx);
  for (let rowIndex = 0; rowIndex < rows.length; rowIndex += 1) {
    const row = rows[rowIndex];
    const column = cols.find(c => trim(row[c]) === '');
    if (column) return { rowIndex, column };
  }
  return null;
};

// 클라이언트 중복 검사 키 — Project, Item, To Site, Incoterms, From Site, BOD, Origin From/To Div, Electrode Type(팝업.cs:1526-1629).
const dupKey = (row: NewPlanRow): string =>
  [
    row.projectCode,
    row.itemId,
    row.toSite,
    row.incoterms,
    row.fromSite,
    row.bodId,
    row.originFromDivisionId,
    row.originToDivisionId,
    row.electrodeType,
  ]
    .map(trim)
    .join('\u0000');

export const hasDuplicateRows = (rows: NewPlanRow[]): boolean => {
  const seen = new Set<string>();
  return rows.some(r => {
    const k = dupKey(r);
    if (seen.has(k)) return true;
    seen.add(k);
    return false;
  });
};

const joinCaret = (rows: NewPlanRow[], pick: (r: NewPlanRow) => string): string => rows.map(r => trim(pick(r))).join('^');

const toYyyymmdd = (v: string): string => v.replace(/-/g, '').slice(0, 8);

// NEW_CHECK(PKG_SCM0002.P_SCM0002_GET_SHIPMENT_PLAN_NEW_CHECK) 인자 — 팝업.cs:515-527. 키는 PROC_M COL_NM 그대로(`prgramId` 철자 포함).
export const buildNewCheckArgs = (ctx: NewPlanContext, rows: NewPlanRow[]) => ({
  divisionId: ctx.divisionId,
  planStartYyyymmdd: toYyyymmdd(ctx.planStartYyyymmdd),
  planType: ctx.planType,
  seq: ctx.planSeq,
  operationGroup: ctx.operationGroupId,
  projectCode: joinCaret(rows, r => r.projectCode),
  itemId: joinCaret(rows, r => r.itemId),
  toSite: joinCaret(rows, r => r.toSite),
  incoterms: joinCaret(rows, r => r.incoterms),
  fromSite: joinCaret(rows, r => r.fromSite),
  bodId: joinCaret(rows, r => r.bodId),
  transportMode: joinCaret(rows, r => r.transportMode),
  prgramId: ctx.programId,
});

// SAVE(PKG_SCM0002.P_SCM0002_SAVE_SHIPMENT_PLAN_NEW) 인자 — 팝업.cs:620-635. transportMode 가 없고 Origin Div/Electrode Type 이 있다.
//   sesUserId 는 서버가 로그인 세션에서 주입하므로 보내지 않는다(ProductionPlanInsertModal 과 같은 방식).
export const buildNewSaveArgs = (ctx: NewPlanContext, rows: NewPlanRow[]) => ({
  divisionId: ctx.divisionId,
  planStartYyyymmdd: toYyyymmdd(ctx.planStartYyyymmdd),
  planType: ctx.planType,
  seq: ctx.planSeq,
  operationGroup: ctx.operationGroupId,
  projectCode: joinCaret(rows, r => r.projectCode),
  itemId: joinCaret(rows, r => r.itemId),
  toSite: joinCaret(rows, r => r.toSite),
  incoterms: joinCaret(rows, r => r.incoterms),
  fromSite: joinCaret(rows, r => r.fromSite),
  bodId: joinCaret(rows, r => r.bodId),
  originFromDivisionId: joinCaret(rows, r => r.originFromDivisionId),
  originToDivisionId: joinCaret(rows, r => r.originToDivisionId),
  electrodeType: joinCaret(rows, r => r.electrodeType),
  prgramId: ctx.programId,
});

// 저장 후 호출 화면 Item 조회조건에 넣을 값. AS-IS 는 행 Item 을 `,` 로 이어 붙이고 중복을 제거하지 않는다(팝업.cs:604-606).
export const buildSavedItemIds = (rows: NewPlanRow[]): string[] => rows.map(r => trim(r.itemId));

// 응답 셀 값을 문자열로. 문자열과 숫자만 다루고 그 외(객체, null)는 빈 문자열이다.
const cellText = (v: unknown): string => (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '');

export type CheckStatus = 'OK' | 'DUPLICATE' | 'ERROR';

// NEW_CHECK 결과 첫 행 판정 — 첫 열 S 는 통과, D 는 중복(둘째 열이 메시지 인자), 그 외는 오류(팝업.cs:538-555).
export const judgeCheckResult = (first: Record<string, unknown> | undefined): { status: CheckStatus; detail: string } => {
  if (!first) return { status: 'ERROR', detail: '' };
  const code = cellText(first.RESULT_CODE ?? Object.values(first)[0]);
  const detail = cellText(first.MSG ?? Object.values(first)[1]);
  if (code === 'S') return { status: 'OK', detail: '' };
  if (code === 'D') return { status: 'DUPLICATE', detail };
  return { status: 'ERROR', detail };
};

// SAVE 결과 판정 — 첫 열 S 만 성공이다(팝업.cs:646-673). 실패 상세(ERR_MESSAGE)는 사용자에게 보이지 않는다(사용자 결정).
export const isSaveSuccess = (first: Record<string, unknown> | undefined): boolean => {
  if (!first) return false;
  return cellText(first.RESULT_CODE ?? Object.values(first)[0]) === 'S';
};
