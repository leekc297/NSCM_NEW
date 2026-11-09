// ⭐ DMF0003 Phase 2d — SAVE payload 구성 (^delim 다건, AS-IS SaveData/SetSaveData 1:1).
//   근거(라인 = AS-IS DMF0003_MktFcst.cs):
//     · SaveData L2146~2366  : dtSaveFinal row 누적 → 15 키 '^' 결합 → DM.DMF0003_SAVE_MKT_FCST 호출.
//     · SetSaveData L5205~5332: 변경 셀을 (identity keys + YYYYMMDD + QTY) 일자 row 로 unfold (dtSave).
//     · 셀→일자 L4280/5041   : sYYYYMMDD = sColName.Replace("D_", "") — 저장 단위는 D_(일자) 셀.
//     · Division 분기 L2194/2226: divisionId 가 "81" 시작 또는 "82" = Project/ScmSiteId/ItemId 키,
//                               그 외(40) = Customer40/ScmSiteId40/ItemId40 키.
//     · ActiveFlag L2193/2225 : CAppSetting.StringM("M") 행별. (신규 행은 'I'.)
//     · p_bucket L2173/2299   : 조회조건 Bucket 단일값 — 행마다 동일 토큰 반복.
//     · p_as_from_site L2262  : ',' → '^' 치환.
//   SP body 실측: 모든 IN(P_CREATED_BY 포함)을 '^' split → row 별 처리. 단일값 P_BUCKET 도 split 후 첫 토큰.
//   BE call-proc 경로(getRetrieveParam)는 createdBy 미주입 → ^delim 다건 유지 (collapse 없음).
import { dynKindOf, thisWeekMondayYmd } from './mkt-fcst-01.editLock';

// [DMF0003_01] Prod. Country · Option 칸 — 기존 행에서 이 둘만 바꿔도 저장해야 한다(사용자 결정 2026-11-06).
export const PRDN_CTRY_COLUMNS = ['PRDN_CTRY', 'PRDN_CTRY_OPT'] as const;

// SAVE 한 row(=일자 단위) 의 원시 값. 모든 키는 SP positional 매핑.
export interface SaveUnfoldRow {
  activeFlag: string; // 'M' (수정) / 'I' (신규)
  divisionId: string;
  projectCode: string; // Div40=Customer40, 81/82=Project
  scmSiteId: string; // Div40=ScmSiteId40, 81/82=ScmSiteId
  itemId: string; // Div40=ItemId40, 81/82=ItemId
  domExp: string;
  fcstType: string;
  incoterms: string;
  measure: string;
  plantSiteId: string;
  yyyymmdd: string; // 8자리 (D_ 컬럼명 prefix 제거)
  qty: string; // 정수 문자열 (빈 셀=0)
  createdBy: string; // 세션 userId
  asFromSite: string;
  // [DMF0003_01] Prod. Country · Option — 저장 인자 prdnCtry · prdnCtryOpt (PROC_M 15 · 16).
  prdnCtry: string;
  prdnCtryOpt: string;
}

// 15 키 ^delim payload (camelCase = SCM_ADM_PROC_M COL_NM). bucket 은 단일값.
export interface SaveProcPayload {
  activeFlag: string;
  divisionId: string;
  projectCode: string;
  scmSiteId: string;
  itemId: string;
  domExp: string;
  fcstType: string;
  incoterms: string;
  measure: string;
  plantSiteId: string;
  yyyymmdd: string;
  qty: string;
  createdBy: string;
  asFromSite: string;
  prdnCtry: string;
  prdnCtryOpt: string;
  bucket: string;
  // ⭐ [E20260604-000994] 저장 시 로그인 권한 그룹 (.cs L2243~2244 sAuthority=NowGroupID, SP 16번째 IN).
  //   bucket 과 같은 단일값 (행 무관). SP p_authority DEFAULT NULL — 게이트 본문은 AS-IS 원문 확보 후.
  authority: string;
}

type Row = Record<string, unknown>;

// 타입 안전 문자열 변환 — SP 컬럼 값은 string/number 만 (no-base-to-string 회피, 객체는 '').
const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 정수 문자열 정규화 — 빈 셀/비숫자 = '0' (AS-IS Convert.ToInt32(GetText().Replace(",",""))).
const qtyOf = (v: unknown): string => {
  if (v == null || v === '') return '0';
  const n = typeof v === 'number' ? v : Number(str(v).replace(/,/g, ''));
  return Number.isFinite(n) ? String(Math.trunc(n)) : '0';
};

// Division 81 시작 또는 82 = 'project' 계열 키, 그 외(40) = '40' 계열 키 (AS-IS L2194/2226).
const isProjectKeyDivision = (divisionId: string): boolean =>
  divisionId.startsWith('81') || divisionId === '82';

// 한 row 의 identity 키 추출 (division 분기). AS-IS SaveData 의 dr[DefColumns.*] 선택과 동일.
const identityOf = (
  row: Row,
  divisionId: string
): Pick<
  SaveUnfoldRow,
  | 'divisionId'
  | 'projectCode'
  | 'scmSiteId'
  | 'itemId'
  | 'domExp'
  | 'fcstType'
  | 'incoterms'
  | 'measure'
  | 'plantSiteId'
  | 'asFromSite'
  | 'prdnCtry'
  | 'prdnCtryOpt'
> => {
  const useProjectKeys = isProjectKeyDivision(divisionId);
  return {
    divisionId: str(row.DIVISION_ID) || divisionId,
    projectCode: useProjectKeys ? str(row.PROJECT_CODE) : str(row.CUSTOMER_40 ?? row.PROJECT_CODE),
    scmSiteId: useProjectKeys ? str(row.SCM_SITE_ID) : str(row.SCM_SITE_ID_40 ?? row.SCM_SITE_ID),
    itemId: useProjectKeys ? str(row.ITEM_ID) : str(row.ITEM_ID_40 ?? row.ITEM_ID),
    domExp: str(row.DOM_EXP),
    fcstType: str(row.FCST_TYPE),
    incoterms: str(row.INCOTERMS),
    measure: str(row.MEASURE),
    plantSiteId: str(row.PLANT_SITE_ID),
    // AS-IS L2262 — ',' → '^' (다건 site). 빈 값 보존.
    asFromSite: str(row.AS_FROM_SITE).replace(/,/g, '^'),
    // 조회는 빈 값을 ' ' 로 내려준다(NVL(A.PRDN_CTRY, ' ')) — 공백만 있으면 빈 값으로 보낸다.
    //   Prod. Country 는 쉼표 구분이라 '^' 와 섞이지 않는다.
    prdnCtry: str(row.PRDN_CTRY).trim(),
    prdnCtryOpt: str(row.PRDN_CTRY_OPT).trim(),
  };
};

// D_ 셀 1개 → SaveUnfoldRow (identity + yyyymmdd + qty).
const unfoldCell = (
  row: Row,
  divisionId: string,
  createdBy: string,
  binding: string,
  qtyValue: unknown,
  activeFlag: string
): SaveUnfoldRow => ({
  activeFlag,
  ...identityOf(row, divisionId),
  yyyymmdd: binding.slice(2), // 'D_' 제거 (AS-IS L4280/5041)
  qty: qtyOf(qtyValue),
  createdBy,
});

/**
 * 변경된 모든 행/셀 → 일자별 SaveUnfoldRow 목록.
 *   - 신규 행(insertedRows): 모든 D_ 키를 일자 row 로 unfold (값 존재분만, AS-IS InsertRow 후 입력 cascade).
 *   - 수정 행(editedTracker): EditTracker 가 추적한 D_ binding 만 unfold (현재 값 사용).
 * yyyymmdd 8자리 아닌 셀(W_/M_ 합 컬럼)은 제외 — AS-IS 는 D_ 일자 셀만 SP 전송.
 */
export const buildUnfoldRows = (params: {
  insertedRows: Row[];
  editedChanges: Map<Row, Record<string, unknown>>; // row → 변경 binding map (EditTracker.getOriginalValues 키셋)
  divisionId: string;
  createdBy: string;
}): SaveUnfoldRow[] => {
  const { insertedRows, editedChanges, divisionId, createdBy } = params;
  const out: SaveUnfoldRow[] = [];
  const isDailyCell = (b: string): boolean => dynKindOf(b) === 'D' && b.slice(2).length === 8;

  // (1) 신규 행 — 모든 D_ 키 중 값 있는 셀
  for (const row of insertedRows) {
    for (const key of Object.keys(row)) {
      if (!isDailyCell(key)) continue;
      const v = row[key];
      if (v == null || v === '') continue; // 빈 셀 skip (신규는 입력분만)
      out.push(unfoldCell(row, divisionId, createdBy, key, v, 'I'));
    }
  }

  // (2) 수정 행 — EditTracker 가 추적한 D_ binding (원본≠현재). 현재 값 전송(빈 셀=0 으로 clear 의도 포함).
  //   [DMF0003_01] 저장 프로시저는 Prod. Country · Option 을 일자 행마다 저장한다. 그래서 기존 행에서
  //   두 칸을 바꾸면 이번 주 월요일 이후 수량이 있는 일자를 모두 함께 보낸다(사용자 결정 2026-11-06,
  //   안 (a)). 고친 일자만 보내면 같은 행 안에서 일자마다 값이 섞이고, 수량을 안 고치면 저장할 것이 없다.
  //   이번 주 월요일 = 화면 Daily 편집 시작일(editLock isPastDynColumn) 과 같은 기준.
  const monday = thisWeekMondayYmd();
  for (const [row, changedBindings] of editedChanges) {
    if (row.CRUD_TYPE === 'I') continue; // 신규는 (1) 에서 처리
    const sent = new Set<string>();
    for (const key of Object.keys(changedBindings)) {
      if (!isDailyCell(key)) continue;
      sent.add(key);
      out.push(unfoldCell(row, divisionId, createdBy, key, row[key], 'M'));
    }
    const prdnChanged = PRDN_CTRY_COLUMNS.some(col => col in changedBindings);
    if (!prdnChanged) continue;
    for (const key of Object.keys(row)) {
      if (sent.has(key) || !isDailyCell(key) || key.slice(2) < monday) continue;
      if (qtyOf(row[key]) === '0') continue; // 수량 없는 일자는 원장에 행이 없다
      out.push(unfoldCell(row, divisionId, createdBy, key, row[key], 'M'));
    }
  }

  return out;
};

// SaveUnfoldRow[] → 16 키 ^delim payload. bucket/authority 는 단일값(행 무관).
export const buildSavePayload = (
  rows: SaveUnfoldRow[],
  bucket: string,
  authority: string
): SaveProcPayload | null => {
  if (rows.length === 0) return null;
  const join = (sel: (r: SaveUnfoldRow) => string): string => rows.map(sel).join('^');
  return {
    activeFlag: join(r => r.activeFlag),
    divisionId: join(r => r.divisionId),
    projectCode: join(r => r.projectCode),
    scmSiteId: join(r => r.scmSiteId),
    itemId: join(r => r.itemId),
    domExp: join(r => r.domExp),
    fcstType: join(r => r.fcstType),
    incoterms: join(r => r.incoterms),
    measure: join(r => r.measure),
    plantSiteId: join(r => r.plantSiteId),
    yyyymmdd: join(r => r.yyyymmdd),
    qty: join(r => r.qty),
    createdBy: join(r => r.createdBy),
    asFromSite: join(r => r.asFromSite),
    prdnCtry: join(r => r.prdnCtry),
    prdnCtryOpt: join(r => r.prdnCtryOpt),
    bucket, // 단일값 (AS-IS p_bucket = cboBucketType.ControlValues)
    authority, // 단일값 (AS-IS L2441 p_authority = sAuthority — 로그인 권한 그룹 원문)
  };
};

// [DMF0003_01] Prod. Country · Option 필수 (요건 14) — 저장 프로시저 검사와 같은 대상을 화면에서 먼저 막는다.
//   대상 = 82 의 MKT FCST[R+P] 저장 행 중 수량이 0 이 아닌 행(프로시저는 룩업 DMF0003_01_PRDN_CTRY_RULE
//   ATTRIBUTE4 = Y 사업부를 본다 — 지금 82 한 줄. 이 화면은 82 만 입력한다, 사용자 결정 2026-11-06).
//   보낼 행(unfold) 기준으로 보므로 프로시저가 받는 것과 정확히 같은 행을 검사한다.
const PRDN_CTRY_REQUIRED_DIVISION = '82';
const PRDN_CTRY_REQUIRED_MEASURE = 'MKT_FCST_RP';

export const findMissingPrdnCtry = (
  rows: SaveUnfoldRow[]
): (typeof PRDN_CTRY_COLUMNS)[number] | null => {
  for (const r of rows) {
    if (r.divisionId !== PRDN_CTRY_REQUIRED_DIVISION) continue;
    if (r.measure !== PRDN_CTRY_REQUIRED_MEASURE || r.qty === '0') continue;
    if (r.prdnCtry === '') return 'PRDN_CTRY';
    if (r.prdnCtryOpt === '') return 'PRDN_CTRY_OPT';
  }
  return null;
};
