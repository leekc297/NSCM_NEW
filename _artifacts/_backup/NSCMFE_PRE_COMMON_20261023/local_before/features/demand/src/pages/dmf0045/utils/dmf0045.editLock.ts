// DMF0045 — 편집/잠금 규칙 엔진 (design 03 §3 gridSignals 21 + 셀 팝업 3종 집약).
//   sales-plan/utils/sales-plan.editLock.ts 계보를 DMF0045 규칙(더 단순)으로 축약 이식한다.
//   AS-IS 와 달리 DMF0045 는 calendar cutoff 커서(THIS_YYYYMM/주차)·measure 편집권한 커서가 없다
//   (design 03 §4 SP 3종에 해당 OUT 없음) — 과거(Gray) cutoff·권한 게이트를 두지 않는다.
//   근거(design 03 §3, AS-IS DMF0045_ShipmentRequest.cs 정본):
//     R1 버킷 게이트  : cboBucketType 과 kind 일치 셀만 편집(#15-17 LockRange 1042/1057/1064).
//                       Daily=D_ / Weekly=W_ / Monthly=M_ 만 입력, 그 외 버킷 컬럼은 잠금.
//     R2 measure 게이트: measure ∈ EDIT_MEASURE_WHITELIST(6종) 행만 편집, 그 외 음영+잠금(design 03 §3).
//     R3 행 액션 게이트: 셀 편집·팝업은 action='I'(신규) 또는 조회행 변경('M') — 조회영역 기본 read-only는
//                       canEdit(hasButton EDIT)이 mount 1회로 담당(#2 LockColumn 446 / convert-core §2.4).
//     R4 SHIP_FROZEN : 행별 frozen 카운트만큼 선두 D_ 컬럼 잠금(마감 일자 편집 금지, cs 654-693).
//     R5 Insert 정적 : 신규행에서 편집 대상 정적 컬럼만 개방(#12-14/#18 LockRange) — 그 외 자동 read-only.
import { BUCKET_TYPE, EDIT_MEASURE_WHITELIST } from '../dmf0045.constants';
import type { ShipmentRequestRow } from '../dmf0045.types';

import { isDiv40 } from './dmf0045.division';
import { toCellStr } from './dmf0045.gridCombos';

// 동적 PIVOT binding 종류 — M_/W_/D_ (DB_* 는 항상 숨김 — 동적 컬럼 생성 단계에서 제외).
export type DynKind = 'M' | 'W' | 'D' | null;
export const dynKindOf = (binding: string): DynKind => {
  if (/^M_\d{6}$/.test(binding)) return 'M';
  if (/^W_\d{7,10}$/.test(binding)) return 'W';
  if (/^D_\d{8}$/.test(binding)) return 'D';
  return null;
};

// 현재 버킷의 kind — 활성 버킷 컬럼만 입력(design 03 §2.4/§3 #15-17).
const bucketKind = (bucketType: BUCKET_TYPE): 'M' | 'W' | 'D' =>
  bucketType === BUCKET_TYPE.MONTHLY ? 'M' : bucketType === BUCKET_TYPE.WEEKLY ? 'W' : 'D';

// measure 편집 가능(음영 아님) 여부 — 화이트리스트 6종만(design 03 §3 비편집 measure 음영).
export const isEditableMeasure = (measure: string): boolean =>
  (EDIT_MEASURE_WHITELIST as readonly string[]).includes(measure);

export interface DynCellState {
  editable: boolean; // 최종 편집 가능
  shaded: boolean; // 비편집 measure 음영 (measure 화이트리스트 밖 — 행 차원)
}

const LOCKED: DynCellState = { editable: false, shaded: false };

// SHIP_FROZEN 선두 D_ 잠금 판정 — 행별 frozen 카운트만큼 앞쪽 D_ 컬럼을 잠근다(cs 654-693).
//   dOrderedDayBindings = 정렬된 D_ binding 목록(오름차순). frozen 개수 이내 index 는 마감 일자.
export const isFrozenLeadingDay = (
  binding: string,
  row: ShipmentRequestRow | undefined,
  dOrderedDayBindings: readonly string[]
): boolean => {
  if (!/^D_\d{8}$/.test(binding)) return false;
  const frozen = Number(row?.SHIP_FROZEN ?? 0);
  if (!Number.isFinite(frozen) || frozen <= 0) return false;
  const idx = dOrderedDayBindings.indexOf(binding);
  return idx >= 0 && idx < frozen;
};

// 동적 셀(M_/W_/D_) 편집 가능 여부 — R1(버킷)×R2(measure)×R3(행 액션)×R4(frozen) 종합.
//   formatItem(음영/편집색) + beginningEdit(cancel) 공유. calendar cutoff 없음(위 헤더 참조).
export const evalShipmentDynCell = (params: {
  binding: string;
  row: ShipmentRequestRow | undefined;
  bucketType: BUCKET_TYPE;
  dOrderedDayBindings: readonly string[];
}): DynCellState => {
  const { binding, row, bucketType, dOrderedDayBindings } = params;
  const kind = dynKindOf(binding);
  if (!kind) return LOCKED;

  const measure = typeof row?.MEASURE === 'string' ? row.MEASURE : '';
  const shaded = !isEditableMeasure(measure);

  // R1 버킷 게이트 — 활성 버킷 kind 만 편집.
  if (kind !== bucketKind(bucketType)) return { editable: false, shaded };
  // R2 measure 게이트 — 화이트리스트 밖 measure 행은 음영+잠금.
  if (shaded) return { editable: false, shaded };
  // R3 행 액션 게이트 — 신규(I)/변경대상(M) 행만. (조회 직후 기존행도 measure 화이트리스트면 M 편집 허용)
  const action = typeof row?.CRUD_TYPE === 'string' ? row.CRUD_TYPE : '';
  if (action === 'D') return { editable: false, shaded };
  // R4 SHIP_FROZEN — 선두 D_ 잠금(Daily 에서만 D_ 편집이므로 이 경로만 영향).
  if (isFrozenLeadingDay(binding, row, dOrderedDayBindings)) return { editable: false, shaded };

  return { editable: true, shaded };
};

// R5 — Insert 행 정적 컬럼 화이트리스트 (design 03 §1 편집(신규행) 열 + §3 #12-14/#18).
//   신규행에서 직접 편집 가능한 정적 셀만 true — 그 외(NICK_NAME/END_CUSTOMER/TEAM/BOD_ID 등
//   팝업이 채우는 파생 컬럼, LAST_UPDATED_BY 시스템)는 자동 read-only.
//   MEASURE = 신규행 콤보(cs 1005) — 단, 그리드가 비어 있을 때 삽입한 첫 행에서만 개방한다.
//     AS-IS InsertRow cs 1012 `if (siMain.GetMaxRowIndex() > 0)` 은 삽입 후 총 행이 2개 이상이면
//     Measure~Requestor 를 LockRange 로 잠근다(design 03 §3 #12-14 "InsertRow(비-첫행)"). 즉
//     빈 그리드에 넣는 유일한 행에서만 Measure 콤보가 열리고, 기존행(조회결과)·추가 신규행이 있으면
//     기본값 'SHIP_REQ' 고정 표시다. isSoleRow = 이 삽입행이 그리드의 유일한 행인지(총 1행).
//   INCOTERMS/FCST_TYPE = 콤보 편집(design 03 §1 #9/#10). ITEM_ID/PROJECT_CODE/TR_MODE = 모달 전용
//   (직접 타이핑 불가 — isInsertModalCell). DIVISION_ID = 조회조건 고정값 잠금(#10/#12).
export const insertStaticEditable = (
  binding: string,
  _row: ShipmentRequestRow,
  _divisionId: string,
  // MEASURE 콤보 개방 게이트 — 빈 그리드에 넣은 유일한 행일 때만 true(cs 1012 GetMaxRowIndex()==0).
  isSoleRow = false
): boolean => {
  switch (binding) {
    case 'INCOTERMS':
    case 'FCST_TYPE':
      return true; // 콤보 편집 (전 division 공통)
    case 'MEASURE':
      return isSoleRow; // 빈 그리드 첫 신규행에서만 콤보 개방 (그 외 SHIP_REQ 고정)
    default:
      return false; // 참조/파생/시스템 컬럼 전부 read-only, 모달 셀은 isInsertModalCell 로 별도 판정
  }
};

// R5 보조 — Insert 행 모달 전용 입력 셀 (직접 타이핑 불가, dblclick 팝업으로만 값 입력).
//   PROJECT_CODE = 40 제외(design 02 §3 40 비활성) / TR_MODE = 상시(BOD 셀 아이콘 노출) /
//   ITEM_ID = 상시. insertStaticEditable 은 false 를 유지(직접 편집 차단) — 대신 표시(편집 색)와
//   팝업 아이콘 판정에 이 함수를 쓴다(mkt-fcst FPModal 셀과 동일 계약).
//   주의: 이 함수는 "모달 셀 여부(아이콘/편집색)"만 판정한다 — TR_MODE(BOD) 의 ITEM_ID 선입력 전제
//   (design 03 §3, AS-IS MSG00098)는 여기서 강제하지 않고 팝업 오픈 시점(canOpenBodPopup)에 차단한다.
//   AS-IS 도 셀은 상시 클릭 가능하되 클릭 시 ITEM_ID 없으면 MSG 로 막았다 — 아이콘은 유지, 오픈만 가드.
export const isInsertModalCell = (
  binding: string,
  row: ShipmentRequestRow,
  divisionId: string
): boolean => {
  if (row.CRUD_TYPE !== 'I') return false;
  if (binding === 'PROJECT_CODE') return !isDiv40(divisionId);
  if (binding === 'TR_MODE') return true;
  if (binding === 'ITEM_ID') return true;
  return false;
};

// TR_MODE(BOD·DMF0046) 팝업 오픈 전제 강제 — ITEM_ID(Model) 선입력 시에만 개방(design 03 §3).
//   AS-IS spdMain_CellDoubleClick: BOD 팝업은 Model 필수, 미입력 시 MSG00098 차단(cs 1312-1393).
//   isInsertModalCell(TR_MODE)=true 로 아이콘/편집색은 유지하되, 실제 오픈만 이 게이트로 막는다.
//   반환 false 면 호출측이 MSG(ITEM_REQUIRED_FOR_BOD) 를 띄우고 오픈을 취소한다.
export const canOpenBodPopup = (row: ShipmentRequestRow | undefined): boolean =>
  toCellStr(row?.ITEM_ID).trim() !== '';
