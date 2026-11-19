import { useCallback } from 'react';

import { useMessageStore } from '@shared/stores';

import { BUCKET_TYPE, MSG, QTY_MAX, QTY_MAX_LABEL, QTY_MIN } from '../production-plan-line.constants';
import type { SearchCondition } from '../production-plan-line.types';
import { toNum } from '../utils/productionPlanLineDerive';
import { editablePivotKindForBucket, pivotKind } from '../utils/productionPlanLineEditLock';

type Row = Record<string, unknown>;
interface Result {
  ok: boolean;
}

const s = (v: unknown): string => (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '');

// SCP0013 조회/저장 전 검증 (design 03 §3 파생 white-list / design 00 §4-D 31건 중 셀검증).
export const useProductionPlanLineValidation = () => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  // p0 지정 시 메시지의 {0} 를 치환한다 — i18next 는 .NET 형식 {0} 를 치환하지 않으므로 라벨을 직접 꽂는다
  //   (자매 ProductionPlanLine REQUIRED_FIELD .replace('{0}', …) 규약과 동일).
  const alert = useCallback(
    (msgId: string, fallback: string, p0?: string): Result => {
      const msg = t(msgId, `_${fallback}`);
      void setAlert({ type: 'alert', content: p0 === undefined ? msg : msg.replace('{0}', p0) });
      return { ok: false };
    },
    [setAlert, t]
  );

  // 조회 전 검증 — chkLineAssign 체크 시 Material(txtItemId) 필수 (design 01 H3 — MSG00290)
  //   + 기간(Period) 유효성: from > to 금지 (design 02 §4.5 #13 — BtnLoad Check_PeriodDate 사전조건).
  const validateSearch = useCallback(
    (sc: SearchCondition): Result => {
      if (sc.chkLineAssign && sc.itemId.trim() === '')
        return alert(MSG.LINE_ASSIGN_ITEM, 'Material is required when Line Assign is checked.');
      // YYYYMMDD 문자열 사전순 비교 = 날짜 비교(zero-pad 전제). 둘 다 입력됐을 때만 검증.
      const from = sc.fromYyyymmdd.replace(/\D/g, '');
      const to = sc.toYyyymmdd.replace(/\D/g, '');
      if (from && to && from > to)
        return alert(MSG.PLAN_PERIOD_RANGE, 'The end date must be on or after the start date.');
      return { ok: true };
    },
    [alert]
  );

  // 저장 전 검증 — 편집 pivot 셀 수량 범위(MSG00084 <0 / MSG00317 >99999999) + 신규행 붉은셀(MSG00026).
  //   수량 범위는 '입력 셀'(해당 bucket 편집 kind — Daily=D_ / Weekly=W_)만 대상이다. SUM 컬럼(W_/M_ 월·주합,
  //   파생 집계값)은 사용자 입력이 아니고 합산으로 상한을 넘을 수 있어 검증에서 제외한다
  //   (AS-IS cs:2551 nDayQty / cs:2621 nWeekQty — 편집 granularity 셀만 검증, 합계 컬럼 미검증).
  const validateSave = useCallback(
    (rows: Row[], bucket: BUCKET_TYPE): Result => {
      const editKind = editablePivotKindForBucket(bucket);
      for (const r of rows) {
        if (!s(r.CRUD_TYPE)) continue;
        // 신규행('I') 붉은셀(미입력 필수) 저장 차단 (design 03 §3 파생 — MSG00026).
        if (s(r.CRUD_TYPE) === 'I' && s(r.MEASURE).trim() === '')
          return alert(MSG.NEW_ROW_RED_CELL, 'New row has empty required cells.');
        for (const [key, val] of Object.entries(r)) {
          // 입력(편집 kind) 셀만 검증 — SUM 컬럼(다른 kind) 및 비-pivot 컬럼 제외. Monthly(editKind=null)는 입력 없음.
          if (editKind === null || pivotKind(key) !== editKind) continue;
          const n = toNum(val);
          if (n === null) continue;
          if (n < QTY_MIN) return alert(MSG.QTY_NEGATIVE, 'Quantity must be >= 0.');
          // AS-IS 입력상한(cs:2551/2621): {0}="100,000,000" 치환 → "100,000,000 미만의 값만 입력 가능합니다."(MSG00317).
          if (n > QTY_MAX)
            return alert(MSG.QTY_OVERFLOW, 'Only values below {0} can be entered.', QTY_MAX_LABEL);
        }
      }
      return { ok: true };
    },
    [alert]
  );

  return { validateSearch, validateSave };
};
