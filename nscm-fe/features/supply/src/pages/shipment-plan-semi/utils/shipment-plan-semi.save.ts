// 저장(P_SCP0010_SAVE_SEMI_DATASET / _FIX_DS / _WEEKLY) — CLOB(JSON 배열) payload 조립.
//   근거: .atlas/gscm-design/SCP0010/design/03_grid-columns.md §4.4(24필드 JSON_TABLE 목록) +
//   ora.py all_arguments 실측(PKG_SCP0010, 2026-09-24) — 3개 SP 전부 (P_DATA CLOB, P_USER_ID
//   VARCHAR2 -> O_RC1, O_RESULT_CURSOR) 동일 시그니처. SCP0009(TVP) 와 저장 payload 형식이 다르다
//   — TVP 문자열 접기(^-delim) 방식을 그대로 복붙하지 않는다.
//
// "행 단위 = 변경된 D_ 셀 1개"(design §4.4) — Weekly 입력은 shipment-plan-semi.deptDayDistribute.ts 로
//   이미 D_ 로 분배된 뒤 저장 대상이 된다(W_ 자체는 저장하지 않는다).
//
// 정직 기록(iter-2 갱신): PKG_SCP0010 의 SCM_ADM_PROC_M 파라미터 메타는 iter-1 시점 0행이었으나
//   이번 회차(ora.py 재확인) GET/SAVE_DATASET/SAVE_FIX_DS/SAVE_WEEKLY 4개 프로시저 전건 등록 완료
//   상태로 바뀌어 있었다(convert-sp 진행분, 이 activity 소관 아님). 등록된 COL_NM 은 P_DATA->data,
//   P_USER_ID->sesUserId(SORT_ORD 1/2, ora.py all_arguments 위치와 1:1 일치 확인) — 호출부가 기존에
//   pData/pUserId 로 보내던 것을 iter-2 에서 data/sesUserId 로 수정(ShipmentPlanSemi.tsx 2곳).
import type { FlexGrid } from '@mescius/wijmo.grid';

import type { EditTracker } from '@foundation/utils';

import { MEASURE } from '../shipment-plan-semi.constants';
import { dynColKindOf, pickField } from './shipment-plan-semi.editLock';

// design 03 §4.4 24필드 순서 그대로(A 포함) — JSON_TABLE COLUMNS 절과 1:1 대응.
//
// 필드 의미 확정(iter-3, PKG_SCP0010 PACKAGE BODY DBMS_METADATA.GET_DDL 전문 실측, ora.py):
// - `a`(JSON_TABLE PATH '$.A'/'$.a') — P_LOAD_INPUT 이 GT_SCP0010_INPUT.A 로 그대로 적재하지만,
//   P_SCP0010_SAVE_SEMI_DATASET 의 UPDATE/INSERT/DELETE 3개 구간(L696-832) 어디에도 A 컬럼을 쓰는
//   WHERE/JOIN/SET 절이 없다 — GT_SCP0010_DYNAMIC.A 로 한 번 더 복사되지만(L644-689) 그 이후
//   전혀 참조되지 않는 dead 필드로 확정(iter-2 gap-audit SCP0010-G-11 해소). 빈 문자열 유지가 맞다.
// - `bizType`(p_biz_type) — GT_SCP0010_INPUT 단계까지는 값이 실리지만 GT_SCP0010_DYNAMIC INSERT
//   컬럼 목록(L644-666)에 P_BIZ_TYPE 자체가 없어 P_SCP0010_SAVE_SEMI_DATASET 경로에서는 조용히
//   드롭된다. 반면 P_SEMI_FIX_HIST_DS(Fix/Unfix 이력, L399-457)는 B.P_BIZ_TYPE 을
//   SCP_ANL_SHIPMENT_PLAN_FIX.BIZ_TYPE 조인키로 실제 사용(L427,449) — 이 화면 도메인에서
//   BIZ_TYPE 은 AS-IS 그대로 "OPERATION_GROUP 값"이 맞다(AS-IS BtnFix_Click 계열이 같은 값을
//   n_operation_group/biz_type 양쪽에 싣던 관례와 일치) — operationGroup 과 동일 값 유지가 맞다.
export interface SaveCellRow {
  a: string; // A — 저장 SP 전 경로에서 미사용 확정(dead field). 빈 문자열로 전송.
  activeFlag: string; // p_active_flag(I/M) — 이 화면은 SHIP_PLAN_AMEND 기존행 수정만 가능하므로 'M' 고정
  divisionId: string;
  planStartYyyymmdd: string;
  planType: string;
  seq: string;
  bizType: string; // p_biz_type — SAVE_DATASET 경로는 미사용(GT_SCP0010_DYNAMIC 미포함), FIX_HIST 경로는 BIZ_TYPE 조인키로 사용. operationGroup 과 동일 값.
  operationGroup: string;
  itemId: string;
  fromSite: string;
  bodId: string;
  measure: string;
  yyyymmdd: string; // D_ 대표일(8자리) — W_ 입력은 저장 전 D_ 로 분배됨
  qty: string;
  toSite: string;
  originFromDivisionId: string;
  originToDivisionId: string;
  electrodeType: string;
  fixReason: string; // Fix 저장 시에만 값 채움, 일반 저장은 빈 문자열
  createdBy: string;
  lastUpdatedBy: string;
  timeZone: string;
  bucketType: string;
  transMode: string;
  debugMode: string;
}

const s = (v: unknown): string => (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '');

// Cell(비전극) 전극값 정규화 — o_rc1(GET SP)은 원천 NULL 을 '/' 로 표시하지만, 저장/Fix SP 의
//   ELECTRODE_TYPE 일치 비교는 NVL(...,'-') 기준이고 fix 테이블 실제값은 '-'(메인은 NULL)다. '/' 를
//   그대로 보내면 NVL('/','-')='/' != NVL('-','-')='-' 라 UPDATE/DELETE 가 0건이 된다(Unfix 무효 사고,
//   DB 실측 2026-10-13). '/' 를 빈값으로 바꿔 보내면 서버에서 NULL→NVL '-' 로 매칭된다.
const normElectrode = (v: string): string => (v === '/' ? '' : v);

// 변경된 D_ 셀만 순회해 24필드 행으로 변환한다. row 는 정보컬럼(design 03 §1)을 그대로 갖고
//   있으므로 Division/BizType/OperGroup 등은 그 행에서 읽는다 — 단 PlanType/Seq 는 MAIN_COLUMNS
//   27건 어디에도 없는 필드다(행별로 다를 수 없는 값 — 한 조회결과는 항상 단일 Plan). 조회조건
//   스냅샷(useShipmentPlanSemiStore appliedPlanType/appliedPlanSeq)에서 받는다(호출측 책임).
export const buildSaveRows = (
  tracker: EditTracker | undefined,
  userId: string,
  timeZone: string,
  planType: string,
  seq: string,
  fixReason = ''
): SaveCellRow[] => {
  if (!tracker) return [];
  const rows: SaveCellRow[] = [];
  tracker.getOriginalValues().forEach((changed, row) => {
    const r = row as unknown as Record<string, unknown>;
    Object.keys(changed).forEach(binding => {
      const kind = dynColKindOf(binding);
      if (kind !== 'D') return; // 저장 대상은 D_ 셀뿐(W_ 입력은 deptDayDistribute 로 이미 D_ 로 분배됨)
      const yyyymmdd = binding.slice(2, 10);
      rows.push({
        a: '', // dead field(SP 미사용 확정) — SaveCellRow 주석 참조
        activeFlag: 'M',
        divisionId: s(pickField(r, 'DIVISION_ID')),
        planStartYyyymmdd: s(pickField(r, 'FROM_YYYYMMDD')),
        planType,
        seq,
        bizType: s(pickField(r, 'OPERATION_GROUP')),
        operationGroup: s(pickField(r, 'OPERATION_GROUP')),
        itemId: s(pickField(r, 'ITEM_ID')),
        fromSite: s(pickField(r, 'FROM_SITE')),
        bodId: s(pickField(r, 'BOD_ID')),
        measure: s(pickField(r, 'MEASURE')),
        yyyymmdd,
        qty: s(r[binding]),
        toSite: s(pickField(r, 'TO_SITE')),
        originFromDivisionId: s(pickField(r, 'ORIGIN_FROM_DIVISION_ID')),
        originToDivisionId: s(pickField(r, 'ORIGIN_TO_DIVISION_ID')),
        electrodeType: normElectrode(s(pickField(r, 'ELECTRODE_TYPE'))),
        fixReason,
        createdBy: userId,
        lastUpdatedBy: userId,
        timeZone,
        bucketType: 'DAILY',
        transMode: s(pickField(r, 'TRANSPORT_MODE')),
        debugMode: 'F',
      });
    });
  });
  return rows;
};

// P_DATA(CLOB) — JSON 배열 문자열로 직렬화. SCP0009 의 '^'-delim TVP 방식과 다르다(§4.4 주석 참조).
export const buildSavePayloadJson = (rows: SaveCellRow[]): string => JSON.stringify(rows);

export const isSaveResultFailure = (res: { status: number; data?: { code?: unknown } }): boolean =>
  res.status >= 400 || Number(res.data?.code ?? 0) !== 0;

// W_(주 SUM) binding -> 그 주의 D_(일) binding 목록. calendar SP 결과(COLUMN_NAME/BASIS_START_DATE)의
//   주시작일(BASIS_START_DATE) 매칭으로 구성한다(그리드 ShipmentPlanSemiGrid.weekToDayBindings 와 동일
//   로직). 선택 셀 Fix 에서 주 SUM 선택을 일자로 전개하는 데 쓴다(AS-IS SaveData_FixInfo W_ 확장 파리티).
export const buildWeekToDayBindings = (
  cols: { COLUMN_NAME?: string; BASIS_START_DATE?: string }[]
): Map<string, string[]> => {
  const startOf = new Map<string, string>();
  cols.forEach(c => {
    const b = s(c.COLUMN_NAME);
    const ws = s(c.BASIS_START_DATE);
    if (b && ws) startOf.set(b, ws);
  });
  const dBindings = cols.map(c => s(c.COLUMN_NAME)).filter(b => dynColKindOf(b) === 'D');
  const map = new Map<string, string[]>();
  cols
    .map(c => s(c.COLUMN_NAME))
    .filter(b => dynColKindOf(b) === 'W')
    .forEach(w => {
      const ws = startOf.get(w);
      if (!ws) return;
      const days = dBindings.filter(d => startOf.get(d) === ws);
      if (days.length > 0) map.set(w, days);
    });
  return map;
};

const pf = (row: Record<string, unknown>, key: string): string => s(pickField(row, key));

// 선택 셀 기반 Fix/Unfix payload — AS-IS SaveData_FixInfo(.cs:3989-4186) 재현. EditTracker(편집)와 무관,
//   grid.selectedRanges 의 SHIP_PLAN_AMEND 행 × D_(일) 셀을 24필드 행으로 만든다(사용자 결정 2026-10-13
//   '선택 셀 기반, AS-IS 충실'). W_(주 SUM) 선택은 weekToDays 로 그 주의 D_ 로 전개(AS-IS W_ 확장).
//   QTY 는 셀 현재 표시값(빈 값 -> '0', AS-IS sQty 동일). activeFlag: Fix='M'(서버가 존재여부로 I/M
//   재판정) / Unfix='D'(DELETE). Unfix 는 현재 fix 된 일자(fixedDays)만 포함(AS-IS 비-fix색 셀 skip).
//   M_(월 SUM) 선택은 제외(AS-IS 미처리). 업무키+일자로 중복 제거.
//   미구현(확인 필요): AS-IS Fix 의 '미저장(red) 셀 선택 시 MSG00026 차단'(.cs:4053) — EditTracker
//   per-cell dirty 조회가 필요해 이번 범위 밖. 저장된 데이터 fix 는 정상 동작한다.
export const buildFixRows = (
  grid: FlexGrid | undefined,
  mode: 'FIX' | 'UNFIX',
  reason: string,
  userId: string,
  planType: string,
  seq: string,
  weekToDays: Map<string, string[]>,
  fixedDays: Set<string>
): SaveCellRow[] => {
  if (!grid) return [];
  const ranges = grid.selectedRanges?.length ? grid.selectedRanges : grid.selection ? [grid.selection] : [];
  const out: SaveCellRow[] = [];
  const seen = new Set<string>();
  const activeFlag = mode === 'UNFIX' ? 'D' : 'M';
  const pushDay = (row: Record<string, unknown>, dBinding: string) => {
    const yyyymmdd = dBinding.slice(2, 10);
    if (mode === 'UNFIX' && !fixedDays.has(yyyymmdd)) return; // 현재 fix 안 된 일자는 unfix 대상 아님(AS-IS)
    const key = [
      pf(row, 'DIVISION_ID'),
      pf(row, 'ITEM_ID'),
      pf(row, 'FROM_SITE'),
      pf(row, 'TO_SITE'),
      pf(row, 'BOD_ID'),
      yyyymmdd,
    ].join('|');
    if (seen.has(key)) return;
    seen.add(key);
    out.push({
      a: '',
      activeFlag,
      divisionId: pf(row, 'DIVISION_ID'),
      planStartYyyymmdd: pf(row, 'FROM_YYYYMMDD'),
      planType,
      seq,
      bizType: pf(row, 'OPERATION_GROUP'),
      operationGroup: pf(row, 'OPERATION_GROUP'),
      itemId: pf(row, 'ITEM_ID'),
      fromSite: pf(row, 'FROM_SITE'),
      bodId: pf(row, 'BOD_ID'),
      measure: pf(row, 'MEASURE'),
      yyyymmdd,
      qty: s(row[dBinding]) || '0',
      toSite: pf(row, 'TO_SITE'),
      originFromDivisionId: pf(row, 'ORIGIN_FROM_DIVISION_ID'),
      originToDivisionId: pf(row, 'ORIGIN_TO_DIVISION_ID'),
      electrodeType: normElectrode(pf(row, 'ELECTRODE_TYPE')),
      fixReason: mode === 'FIX' ? reason : '',
      createdBy: userId,
      lastUpdatedBy: userId,
      timeZone: '',
      bucketType: 'DAILY',
      transMode: pf(row, 'TRANSPORT_MODE'),
      debugMode: 'F',
    });
  };
  for (const range of ranges) {
    if (!range || range.row < 0 || range.col < 0) continue;
    for (let r = range.topRow; r <= range.bottomRow; r++) {
      const row = grid.rows[r]?.dataItem as Record<string, unknown> | undefined;
      if (!row) continue;
      if (pf(row, 'MEASURE') !== MEASURE.SHIP_PLAN_AMEND) continue; // SHIP_PLAN_AMEND 행만 fix 대상
      for (let c = range.leftCol; c <= range.rightCol; c++) {
        const binding = grid.columns[c]?.binding ?? '';
        const kind = dynColKindOf(binding);
        if (kind === 'D') pushDay(row, binding);
        else if (kind === 'W') (weekToDays.get(binding) ?? []).forEach(d => pushDay(row, d));
      }
    }
  }
  return out;
};
