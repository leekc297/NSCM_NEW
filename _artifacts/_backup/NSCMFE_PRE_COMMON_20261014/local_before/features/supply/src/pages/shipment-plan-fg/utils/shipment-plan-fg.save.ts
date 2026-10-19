// 저장(P_SCP0009_SAVE_ANL_SHIP_PLAN_FG_WEEKLY / _FIX_DATASET) 26필드 TVP payload 조립.
//   근거: .atlas/gscm-design/SCP0009/design/03_grid-columns.md §4.4(26필드 목록) +
//   ora.py all_type_attrs 실측(T_SCP0009_ROW, iter-2 재확인) — 두 SP 모두 동일 TVP(T_SCP0009_TAB) 형상.
//   "행 단위 = 변경된 셀 1개"(AS-IS ForeColor==Red 탐지 방식 대신 EditTracker.getOriginalValues() 사용).
//
// 정직 기록(iter-2, 중대 제약 — ERROR 로 기록할 것): 이 SP 의 Oracle IN 파라미터는 진짜 TABLE
//   타입(TVP, SCM_MGR.T_SCP0009_TAB — ALL_ARGUMENTS DATA_TYPE='TABLE')이다. 아래 buildSavePayload
//   는 '^'-delim 문자열(JVARCHAR 관례, forecast-price.save.ts 패턴)로 payload 를 접지만, 이 JVARCHAR
//   문자열 접기는 BE 가 VARCHAR2 파라미터를 흉내낼 때만 유효하다(MapUtils.cvtJsonToJVarchar). 실제
//   Oracle Collection(TABLE OF OBJECT) 파라미터를 JDBC 로 바인딩하려면 java.sql.Array/STRUCT 변환이
//   필요한데, nscm-be BaseService(callProc/callProc2 둘 다, 2026-09-24 실측)에는 그런 변환 코드가
//   없다 — CallableStatement.setObject 단순 바인딩 또는 JVARCHAR 문자열 접기 뿐이다. 즉 이 payload
//   형식 그대로는 BE 개선 없이 런타임에서 절대 성공하지 않는다(파라미터 개수/타입 불일치로 즉시
//   실패 예상). Hard Boundary(convert-core §2.2 — nscm-be 수정 금지)로 이 activity 범위에서 BE TVP
//   바인딩 지원을 추가할 수 없다 — 배선(FE 코드)만 완료하고 "런타임 미검증(BE TVP 미지원, ERROR)"으로
//   정직 보고한다. 후속 조치는 nscm-be 에 TVP 전용 바인딩 경로 신설(별도 activity/사용자 결정).
import type { EditTracker } from '@foundation/utils';

import { dynColKindOf } from './shipment-plan-fg.editLock';

// design 03 §4.4 26필드 순서 그대로(A 포함) — TVP ATTR_NO 1~26과 1:1.
export interface SaveCellRow {
  a: string; // A — 용도 확인 필요(design 03 §4.4, ATTR_NO=1). 빈 문자열로 전송.
  activeFlag: string; // P_ACTIVE_FLAG — 이 화면은 편집 가능 셀이 전부 기존행(SHIP_PLAN_AMEND) 수정뿐이라 'M' 고정
  divisionId: string;
  planStartYyyymmdd: string;
  planType: string;
  seq: string;
  bizType: string;
  projectCode: string;
  itemId: string;
  toSite: string;
  incoterms: string;
  fromSite: string;
  bodId: string;
  measure: string;
  yyyymmdd: string; // D_/W_/M_ 대표일(8자리)
  qty: string;
  originFromDivisionId: string;
  originToDivisionId: string;
  electrodeType: string;
  fixReason: string; // Fix 저장 시에만 값 채움(핸들러가 결정), 일반 저장은 빈 문자열
  bucketType: string;
  transMode: string;
  createdBy: string;
  lastUpdatedBy: string;
  timeZone: string;
  debugMode: string;
}

const s = (v: unknown): string => (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '');

// 변경된 D_/W_/M_ 셀만 순회해 26필드 행으로 변환한다. row 는 정보컬럼(§0)을 그대로 갖고 있으므로
//   Division/PlanDate/Type/Seq/BizType 등은 그 행에서 그대로 읽는다(design 03 §1.A 44개 정보컬럼).
export const buildSaveRows = (
  tracker: EditTracker | undefined,
  userId: string,
  timeZone: string,
  fixReason = ''
): SaveCellRow[] => {
  if (!tracker) return [];
  const rows: SaveCellRow[] = [];
  tracker.getOriginalValues().forEach((changed, row) => {
    const r = row as unknown as Record<string, unknown>;
    Object.keys(changed).forEach(binding => {
      if (!dynColKindOf(binding)) return; // 정보컬럼은 편집 대상이 아니므로(§0) 저장 후보에서 제외
      const yyyymmdd = binding.slice(2, 10); // D_yyyymmdd/W_.../M_yyyymm — design 03 §4.4 P_YYYYMMDD
      rows.push({
        a: '',
        activeFlag: 'M', // 이 화면은 기존 SHIP_PLAN_AMEND 행 수정만 가능(§0) — Insert 경로 없음
        divisionId: s(r.DIVISION_ID),
        planStartYyyymmdd: s(r.plan_start_yyyymmdd),
        planType: s(r.plan_type),
        seq: s(r.seq),
        bizType: s(r.biz_type),
        projectCode: s(r.project_code),
        itemId: s(r.ITEM_ID),
        toSite: s(r.to_site),
        incoterms: s(r.incoterms),
        fromSite: s(r.from_site),
        bodId: s(r.bod_id),
        measure: s(r.measure),
        yyyymmdd,
        qty: s(r[binding]),
        originFromDivisionId: s(r.ORIGIN_FROM_DIVISION_ID),
        originToDivisionId: s(r.ORIGIN_TO_DIVISION_ID),
        electrodeType: s(r.ELECTRODE_TYPE),
        fixReason,
        bucketType: dynColKindOf(binding) === 'D' ? 'DAILY' : dynColKindOf(binding) === 'W' ? 'WEEKLY' : 'MONTHLY',
        transMode: s(r.transport_mode),
        createdBy: userId,
        lastUpdatedBy: userId,
        timeZone,
        debugMode: 'F',
      });
    });
  });
  return rows;
};

// call-proc 은 '^'-delim bulk 배열(키별 caret-join, forecast-price.save.ts buildSavePayload 표준
//   패턴)을 받는다 — createdBy/lastUpdatedBy 는 BE 가 세션값으로 덮어쓰므로 키명 그대로는 위험하나
//   이 화면은 컬럼명이 PROC_M COL_NM(P_CREATED_BY 등)과 정확히 일치해야 하는 특수 케이스라
//   convert-sp PROC_M 등록 시 실제 COL_NM 을 확인해 키를 맞춘다(§6 확인 필요).
export const buildSavePayload = (rows: SaveCellRow[]): Record<string, string> => ({
  a: rows.map(r => r.a).join('^'),
  activeFlag: rows.map(r => r.activeFlag).join('^'),
  divisionId: rows.map(r => r.divisionId).join('^'),
  planStartYyyymmdd: rows.map(r => r.planStartYyyymmdd).join('^'),
  planType: rows.map(r => r.planType).join('^'),
  seq: rows.map(r => r.seq).join('^'),
  bizType: rows.map(r => r.bizType).join('^'),
  projectCode: rows.map(r => r.projectCode).join('^'),
  itemId: rows.map(r => r.itemId).join('^'),
  toSite: rows.map(r => r.toSite).join('^'),
  incoterms: rows.map(r => r.incoterms).join('^'),
  fromSite: rows.map(r => r.fromSite).join('^'),
  bodId: rows.map(r => r.bodId).join('^'),
  measure: rows.map(r => r.measure).join('^'),
  yyyymmdd: rows.map(r => r.yyyymmdd).join('^'),
  qty: rows.map(r => r.qty).join('^'),
  originFromDivisionId: rows.map(r => r.originFromDivisionId).join('^'),
  originToDivisionId: rows.map(r => r.originToDivisionId).join('^'),
  electrodeType: rows.map(r => r.electrodeType).join('^'),
  fixReason: rows.map(r => r.fixReason).join('^'),
  bucketType: rows.map(r => r.bucketType).join('^'),
  transMode: rows.map(r => r.transMode).join('^'),
  createdByList: rows.map(r => r.createdBy).join('^'), // createdBy 키명은 BE 가 세션값으로 가로챔(nscm-patterns.md §5-11)
  lastUpdatedByList: rows.map(r => r.lastUpdatedBy).join('^'),
  timeZone: rows.map(r => r.timeZone).join('^'),
  debugMode: rows.map(r => r.debugMode).join('^'),
});

export const isSaveResultFailure = (res: { status: number; data?: { code?: unknown } }): boolean =>
  res.status >= 400 || Number(res.data?.code ?? 0) !== 0;
