import type { DupLedgerRow } from '../shipment-semi-dept-day.types';

// AS-IS SCP0033 저장 전 중복체크 2종 (design 03 §4.4, cs:499~579):
//   - checkValid()  : 신규행('I') (DIVISION_ID+ITEM_ID) 이 DB 원장(GET Table[1]=dsValiChkBinding)에 존재 -> MSG00060.
//   - checkValid1() : 신규행('I') (DIVISION_ID+ITEM_ID) 이 그리드 내부에 2건 이상 -> MSG00060.
//   둘 다 신규행만 검사(action=='I'). 화면 고유 업무규칙(Div+Item Unique — 07 §2 #13: OPERATION_GROUP 파생이라
//     실질 유일키 Division+Item 과 등가). Edit 진입 권한 SP 없음(AS-IS EditButton=SwitchLock 만, design 04 entryPoints #4).

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 공백만 있는 문자열도 미입력으로 본다(공용 useSaveWithValidation.isBlank 동일 규칙).
const isBlank = (v: unknown): boolean =>
  v === null || v === undefined || (typeof v === 'string' && v.trim() === '');

export const useShipmentSemiDeptDayValidation = () => {
  const keyOf = (r: Record<string, unknown>): string => `${str(r.DIVISION_ID)}|${str(r.ITEM_ID)}`;

  // 저장 전 필수(*) 컬럼 검사 — INPUT_TP_CD 전건 'S'(SEARCH_ONLY, design 03 §1/§6-A)라 공용
  //   useSaveWithValidation 의 isEditableForRow 가 default->false 로 필수판정을 통째로 스킵한다
  //   (필수검증 사문화, 메모리 input-tp-cd-search-only-kills-save-validation / SCP0020 실사고).
  //   그래서 화면이 inputTpCd 비의존으로 저장대상행(신규 'I' + 편집 'M')의 필수컬럼 빈값을 직접 차단한다
  //   (AS-IS checkRequiredOfSpread cs:318 등가). 빈 첫 컬럼 key 를 반환(없으면 null).
  const findMissingRequired = (
    saveTargets: Record<string, unknown>[],
    requiredColumns: readonly string[]
  ): string | null => {
    for (const r of saveTargets) {
      for (const col of requiredColumns) {
        if (isBlank(r[col])) return col;
      }
    }
    return null;
  };

  // 저장 전 중복키 검사 — 신규행('I') (DIVISION_ID+ITEM_ID) 대상.
  //   (a) DB 원장(ledger=GET Table[1]) 존재  (b) 그리드 내부 자기중복(2건 이상). 하나라도 걸리면 그 ITEM_ID 반환.
  const findDuplicate = (
    dirty: Record<string, unknown>[],
    allRows: Record<string, unknown>[],
    ledger: DupLedgerRow[]
  ): string | null => {
    // (a) DB 원장 대비
    const ledgerSet = new Set<string>(
      (ledger ?? []).map(r => `${str(r.DIVISION_ID)}|${str(r.ITEM_ID)}`)
    );
    // (b) 그리드 내부 카운트
    const gridCounts = new Map<string, number>();
    for (const r of allRows) {
      const k = keyOf(r);
      gridCounts.set(k, (gridCounts.get(k) ?? 0) + 1);
    }
    for (const r of dirty) {
      if (r.CRUD_TYPE !== 'I') continue; // 신규행만 (AS-IS checkValid/checkValid1)
      const k = keyOf(r);
      if (ledgerSet.has(k)) return str(r.ITEM_ID);
      if ((gridCounts.get(k) ?? 0) > 1) return str(r.ITEM_ID);
    }
    return null;
  };

  return { findDuplicate, findMissingRequired };
};
