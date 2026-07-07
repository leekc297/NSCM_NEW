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
import { dynKindOf } from './mkt-fcst.editLock';

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
  bucket: string;
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
  for (const [row, changedBindings] of editedChanges) {
    if (row.CRUD_TYPE === 'I') continue; // 신규는 (1) 에서 처리
    for (const key of Object.keys(changedBindings)) {
      if (!isDailyCell(key)) continue;
      out.push(unfoldCell(row, divisionId, createdBy, key, row[key], 'M'));
    }
  }

  return out;
};

// SaveUnfoldRow[] → 15 키 ^delim payload. bucket 은 단일값(행 무관).
export const buildSavePayload = (rows: SaveUnfoldRow[], bucket: string): SaveProcPayload | null => {
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
    bucket, // 단일값 (AS-IS p_bucket = cboBucketType.ControlValues)
  };
};
