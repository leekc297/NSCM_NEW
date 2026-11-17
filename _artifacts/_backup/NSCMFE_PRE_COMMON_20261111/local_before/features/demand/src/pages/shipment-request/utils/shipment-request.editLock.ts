// DMF0045 — 편집/잠금 규칙 엔진 (design 03 §3 gridSignals 21 + 셀 팝업 3종 집약).
//   sales-plan/utils/sales-plan.editLock.ts 계보를 DMF0045 규칙(더 단순)으로 축약 이식한다.
//   AS-IS 와 달리 DMF0045 는 calendar cutoff 커서(THIS_YYYYMM/주차)·measure 편집권한 커서가 없다
//   (design 03 §4 SP 3종에 해당 OUT 없음) — 과거(Gray) cutoff·권한 게이트를 두지 않는다.
//   근거(design 03 §3, AS-IS DMF0045_ShipmentRequest.cs 정본):
//     R1 버킷 게이트  : cboBucketType 과 kind 일치 셀만 편집(#15-17 LockRange 1042/1057/1064).
//                       Daily=D_ / Weekly=W_ / Monthly=M_ 만 입력, 그 외 버킷 컬럼은 잠금.
//     R2 measure 게이트: 입력목록(INPUT_MEASURE_WHITELIST 6종) 밖 measure 행은 음영(Gray)+잠금(design 03 §3).
//     R2' 편집 measure : 입력행 중 실제 값셀/FCST_TYPE 편집은 EDITABLE_MEASURE(SHIP_REQ) 만(AS-IS cs 543·545).
//                        나머지 5종은 흰색이나 잠금(표시 전용).
//     R3 행 액션 게이트: 셀 편집·팝업은 action='I'(신규) 또는 조회행 변경('M') — 조회영역 기본 read-only는
//                       canEdit(hasButton EDIT)이 mount 1회로 담당(#2 LockColumn 446 / convert-core §2.4).
//     R4 Frozen(D_)  : 기존행=행별 SHIP_FROZEN(From Site별) 카운트만큼 선두 D_ 잠금(cs 654-693).
//                       신규행(I)=From Site 미선택이라 SHIP_FROZEN 없음 → AS-IS 처럼 '오늘+10일' 이전 D_ 잠금
//                       (cs 1012-1047 Today.AddDays(10)). isInsertFrozenDay / insertFrozenCutoffYmd.
//     R5 Insert 정적 : 신규행에서 편집 대상 정적 컬럼만 개방(#12-14/#18 LockRange) — 그 외 자동 read-only.
import { BUCKET_TYPE, EDITABLE_MEASURE, INPUT_MEASURE_WHITELIST } from '../shipment-request.constants';
import type { ShipmentRequestRow } from '../shipment-request.types';

import { isDiv40 } from './shipment-request.division';
import { toCellStr } from './shipment-request.gridCombos';

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

// 입력(흰색) measure 여부 — 음영(Gray) 판정용. 입력목록 밖 measure 는 집계/시스템 행(음영+잠금).
//   주의: 입력(흰색)이라고 편집 가능한 것은 아니다 — 실제 편집은 EDITABLE_MEASURE(SHIP_REQ) 만(아래 R2').
export const isInputMeasure = (measure: string): boolean =>
  (INPUT_MEASURE_WHITELIST as readonly string[]).includes(measure);

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

// 신규행(Insert) 마감(frozen) D_ 판정 — 신규행은 From Site 미선택이라 SHIP_FROZEN(행별=From Site별)을
//   못 쓴다. AS-IS 는 그 대신 일괄 '오늘+10일' 커트라인 이전 D_ 일자를 잠근다(cs 1012-1047: Today.AddDays(10)
//   → iResultCol LockRange). binding 'D_yyyymmdd' 의 일자가 cutoff(yyyymmdd) 미만이면 frozen.
//   cutoff(todayPlus10Ymd)는 호출측이 dayjs().add(10,'day').format('YYYYMMDD') 로 계산해 넘긴다(순수 함수 유지,
//   D_ 바인딩 생성 포맷과 동일 기준). AS-IS 와 동일하게 Daily(D_)에만 적용한다(cs 1030 이 D_ 컬럼만 커트라인
//   비교 — Weekly/Monthly 신규행엔 +10 잠금 없음). cutoff 가 yyyymmdd 형식이 아니면 잠그지 않는다(안전측).
export const isInsertFrozenDay = (binding: string, todayPlus10Ymd: string): boolean => {
  const m = /^D_(\d{8})$/.exec(binding);
  if (!m) return false;
  if (!/^\d{8}$/.test(todayPlus10Ymd)) return false;
  return m[1] < todayPlus10Ymd;
};

// 동적 셀(M_/W_/D_) 편집 가능 여부 — R1(버킷)×R2(measure)×R3(행 액션)×R4(frozen) 종합.
//   formatItem(음영/편집색) + beginningEdit(cancel) 공유. calendar cutoff 없음(위 헤더 참조).
export const evalShipmentDynCell = (params: {
  binding: string;
  row: ShipmentRequestRow | undefined;
  bucketType: BUCKET_TYPE;
  dOrderedDayBindings: readonly string[];
  // 신규행(Insert) 오늘+10일 D_ frozen cutoff(yyyymmdd) — AS-IS cs 1022. 호출측이 계산해 넘긴다.
  insertFrozenCutoffYmd: string;
}): DynCellState => {
  const { binding, row, bucketType, dOrderedDayBindings, insertFrozenCutoffYmd } = params;
  const kind = dynKindOf(binding);
  if (!kind) return LOCKED;

  const measure = typeof row?.MEASURE === 'string' ? row.MEASURE : '';
  const inputMeasure = isInputMeasure(measure);
  const action = typeof row?.CRUD_TYPE === 'string' ? row.CRUD_TYPE : '';
  // R4 마감(frozen) D_ 판정 — AS-IS cs 486/540 은 마감 구간을 전 measure 행에 회색(242,242,242)+잠금으로 칠한다
  //   → 음영(shaded)에 포함(Daily D_ 에만 해당). 기존행: SHIP_FROZEN(From Site별) 선두 D_(cs 540).
  //   신규행(I): From Site 미선택이라 SHIP_FROZEN 이 없어, AS-IS 처럼 '오늘+10일' 이전 D_ 를 잠근다(cs 1022·1042).
  const frozen =
    action === 'I'
      ? isInsertFrozenDay(binding, insertFrozenCutoffYmd)
      : isFrozenLeadingDay(binding, row, dOrderedDayBindings);
  // 음영(Gray) = 마감(frozen) D_ 셀 뿐이다. AS-IS cs 486/540 은 회색(242,242,242)을 Frozen 선두 구간에만
  //   칠하고, 집계/시스템 measure 행이라고 기간열 전체를 회색으로 덮지 않는다(공통 measure 는 ToSite~Requestor
  //   정적열만 연파랑). `!inputMeasure` 를 음영에 넣으면 Frozen 이후까지 회색이 번져 AS-IS 와 어긋난다
  //   (사용자 신고 2026-11-09 "Frozen 구간 이후, 공통 Measure 색상 불필요"). 편집 가부는 아래 R2 게이트가
  //   별도로 막으므로 음영과 분리한다.
  const shaded = frozen;

  // R1 버킷 게이트 — 활성 버킷 kind 만 편집.
  if (kind !== bucketKind(bucketType)) return { editable: false, shaded };
  // R2 measure 음영 게이트 — 입력목록 밖(집계/시스템) measure 행은 음영+잠금.
  if (!inputMeasure) return { editable: false, shaded };
  // R2' 편집 measure 게이트 — 입력행 중에서도 실제 값셀 편집은 SHIP_REQ 만(AS-IS EditButton cs 543·545).
  //   나머지 입력 measure(SHIP_PLAN/RTF/RTF_SCP/SCP_PLAN/SCP_SHIP_PLAN)는 흰색이나 잠금(표시 전용).
  if (measure !== EDITABLE_MEASURE) return { editable: false, shaded };
  // R3 행 액션 게이트 — 신규(I)/변경대상(M) 행만(action 은 위에서 선언). 삭제행(D)은 편집 불가.
  if (action === 'D') return { editable: false, shaded };
  // R4 — 마감(frozen) 선두 D_ 는 잠금+회색(위 shaded 에 반영됨).
  if (frozen) return { editable: false, shaded };

  return { editable: true, shaded: false };
};

// 기존(조회) '행' FCST_TYPE 편집 가능 여부 — AS-IS EditButton cs 543-551.
//   조건: Measure='SHIP_REQ' 행 + SHIP_FROZEN>0(frozen 구간) + 삭제행 아님.
//   FCST_TYPE 는 AS-IS 처럼 그룹 세로 병합되어 그룹당 셀이 1개(앵커=첫 measure)로 보인다. 병합 셀의
//   편집 가부는 '블록(병합 스팬) 안에 이 함수가 참인 Ship Req 행이 있는가'로 판정한다
//   (ShipmentRequestGrid.isFcstBlockEditable). 편집 시 Ship Req 행에만 값을 적용해 병합이 풀리면,
//   이후엔 Ship Req 블록만 참·나머지 블록은 거짓이 되어 Ship Req 만 편집 상태로 남는다.
//   Insert 행 FCST_TYPE 개방은 insertStaticEditable 가 별도로 담당(이 함수는 기존 행 전용).
export const isFcstTypeEditableExistingRow = (row: ShipmentRequestRow | undefined): boolean => {
  if (!row || row.CRUD_TYPE === 'I' || row.CRUD_TYPE === 'D') return false;
  if ((typeof row.MEASURE === 'string' ? row.MEASURE : '') !== EDITABLE_MEASURE) return false;
  const frozen = Number(row.SHIP_FROZEN ?? 0);
  return Number.isFinite(frozen) && frozen > 0;
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
