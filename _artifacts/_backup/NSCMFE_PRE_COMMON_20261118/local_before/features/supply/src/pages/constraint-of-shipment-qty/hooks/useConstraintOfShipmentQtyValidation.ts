import { useCallback } from 'react';

import { useMessageStore } from '@shared/stores';

import { MSG, REQUIRED_COLUMNS } from '../constraint-of-shipment-qty.constants';

type Row = Record<string, unknown>;
interface Result {
  ok: boolean;
}

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 저장 전 커스텀 검증(design 03 §3.1/§4) — AS-IS SaveData 의 UI 측 사전검증(.cs:678~) 재현.
//   8개 필수값(#2 MSG00013) + 수량 게이트(#1 MSG00099, #5 MSG00022, 일반 쌍만 — SAT/SUN 쌍 적용
//   여부는 확인 필요, design 03 §6#6) + 날짜 게이트(#4 MSG00219)를 전건 재현한다. 공통
//   saveWithValidation 도 메타(INPUT_TP_CD=M: OPMZ_PLAN_GR_ID/MDL_GR_NM/ITEM_ID)로 필수를 병행
//   검증하나, 8개 필수 조건·수량/날짜 게이트는 메타로 표현되지 않아 이 커스텀 검증이 정본이다.
//   Item 존재 확인(#6 MSG00458)·Sales Site Priority(#3 MSG00046)는 서버(SAVE SP) 판정 영역이며
//   PKG_SCP0132 미배포로 이 회차에서는 검증하지 않는다(확인 필요, __asis-mapping__.md 명시).
export const useConstraintOfShipmentQtyValidation = () => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  const alert = useCallback(
    (msgId: string, fallback: string, ...args: string[]): Result => {
      // {0}, {1}, ... 순서대로 치환(AS-IS GMessageBox(msgId, new object[]{...}) 파리티).
      const content = args.reduce((acc, a, i) => acc.split(`{${i}}`).join(a), t(msgId, `_${fallback}`));
      void setAlert({ type: 'alert', content });
      return { ok: false };
    },
    [setAlert, t]
  );

  const validateSaveRows = useCallback(
    (rows: Row[]): Result => {
      const dirty = rows.filter(r => s(r.CRUD_TYPE));
      if (dirty.length === 0) return { ok: true };

      // 1) 필수값 8개(design 03 §3.1 #2 MSG00001 원문 그대로 — STAGE/MDL_GR_NM 은 조건식에 없어 제외).
      for (const r of dirty) {
        for (const key of REQUIRED_COLUMNS) {
          if (s(r[key]).trim() === '') {
            return alert(MSG.REQUIRED_FIELDS, 'Please enter the required fields.');
          }
        }
      }

      // 2) Min>Max 금지(AS-IS SaveData checkMinMax .cs:534~552, #1 MSG00099) — 일반쌍 + SAT쌍 + SUN쌍.
      //   AS-IS 는 세 쌍 모두 checkMinMax(Min/Max 둘 다 값 있을 때만 정수비교 후 Min>Max 체크)를 돌고
      //   (.cs:743 일반, 748 SAT, 753 SUN) MSG00099 에 쌍 이름을 {0}=MIN타이틀, {1}=MAX타이틀로 넘긴다
      //   (.cs:547). MSG00099 는 TO-BE DB 등록됨("{0}은 {1} 보다 클 수 없습니다.", KO/EN/CN USE_YN=Y).
      //   빈값 쌍은 비교 생략. SAT/SUN 은 동시공백(MSG00022) 대상 아니고 Min>Max 만 검사(동시공백 필수는 일반쌍 전용 .cs:735).
      const QTY_PAIRS = [
        { minKey: 'SIPM_MIN_QYT', maxKey: 'SIPM_MAX_QTY', minTitle: 'MIN', maxTitle: 'MAX' },
        {
          minKey: 'SAT_SIPM_MIN_QTY',
          maxKey: 'SAT_SIPM_MAX_QTY',
          minTitle: 'MIN(SAT)',
          maxTitle: 'MAX(SAT)',
        },
        {
          minKey: 'SUN_SIPM_MIN_QTY',
          maxKey: 'SUN_SIPM_MAX_QTY',
          minTitle: 'MIN(SUN)',
          maxTitle: 'MAX(SUN)',
        },
      ] as const;
      for (const r of dirty) {
        for (const { minKey, maxKey, minTitle, maxTitle } of QTY_PAIRS) {
          const minStr = s(r[minKey]).trim();
          const maxStr = s(r[maxKey]).trim();
          // AS-IS checkMinMax(.cs:539): Min·Max 둘 다 비어있지 않을 때만 비교. 빈 문자열은
          //   Number('')===0 으로 오판되므로 숫자화 전에 공백부터 건너뛴다.
          if (minStr === '' || maxStr === '') continue;
          const min = Number(minStr);
          const max = Number(maxStr);
          if (Number.isFinite(min) && Number.isFinite(max) && min > max) {
            return alert(MSG.MIN_MAX_INVALID, '{0} can not be greater than {1}.', minTitle, maxTitle);
          }
        }
      }

      // 3) 일반 쌍 Min/Max 동시 공백 금지(design 03 §3.1 #5 MSG00022).
      for (const r of dirty) {
        if (s(r.SIPM_MIN_QYT).trim() === '' && s(r.SIPM_MAX_QTY).trim() === '') {
          return alert(MSG.MIN_MAX_BOTH_EMPTY, 'Please enter Min qty or Max qty.');
        }
      }

      // 4) From <= To(design 03 §3.1 #4 MSG00219).
      for (const r of dirty) {
        const from = s(r.FROM_YYYYMMDD);
        const to = s(r.TO_YYYYMMDD);
        if (from && to && from > to) {
          return alert(MSG.PERIOD_INVALID, 'The start date can not be later than the end date.');
        }
      }

      return { ok: true };
    },
    [alert]
  );

  return { validateSaveRows };
};
