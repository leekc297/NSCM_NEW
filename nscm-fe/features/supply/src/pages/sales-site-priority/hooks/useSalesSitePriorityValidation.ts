import { useCallback } from 'react';

import { useMessageStore } from '@shared/stores';

import { MSG, REQUIRED_COLUMNS } from '../sales-site-priority.constants';
import { ymd8 } from '../utils/salesSitePriority.saveRequest';

type Row = Record<string, unknown>;
interface Result {
  ok: boolean;
}

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 저장 전 검증(design 00 §4a validations 12건 중 저장 시점 6건 — #1/#4/#5/#6, 나머지는 붙여넣기·
//   결과 toast 는 useProcMutation 표준 경로로 처리됨).
//   1) 필수값(division/planGroup/site/item/prioRank/from/to/validYn 8개) 공백 차단 — VALID_YN 은
//      라벨 '*' 불일치(design 03 §1 비고)로 REQUIRED_COLUMNS(라벨기준 7칸)에서 제외했으나,
//      AS-IS validations#1 이 실제로 검사하는 8번째 값이라 이 화면 커스텀 검증에서 별도 포함한다.
//   2) PRIO_RANK 는 1 이상의 정수(소수/음수/0 차단, MSG00175 등가 MSG01190, {0}=PRIORITY).
//   3) From > To 차단(MSG00219 등가 MSG01135).
//   안전재고 경고(AS-IS MSG00260)·item 존재확인(MSG00458)은 서버(SAVE SP) 판정 영역이라 SP 배포 후
//   런타임에서만 검증 가능 — 이 화면은 SP MISSING 이므로 미검증 상태(확인 필요, __asis-mapping__.md 명시).
export const useSalesSitePriorityValidation = () => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  const alert = useCallback(
    (msgId: string, fallback: string, arg?: string): Result => {
      const text = t(msgId, `_${fallback}`);
      void setAlert({
        type: 'alert',
        content: arg === undefined ? text : text.replace('{0}', arg),
      });
      return { ok: false };
    },
    [setAlert, t]
  );

  const validateSaveRows = useCallback(
    (rows: Row[]): Result => {
      const dirty = rows.filter(r => s(r.CRUD_TYPE));
      if (dirty.length === 0) return { ok: true };

      // 1) 필수값 — 라벨 '*' 7칸 + VALID_YN(AS-IS validations#1 실제 검사 대상, 라벨 불일치 별도 반영).
      const requiredForSave = [...REQUIRED_COLUMNS, 'VALID_YN'];
      for (const r of dirty) {
        for (const key of requiredForSave) {
          if (s(r[key]).trim() === '') {
            return alert(MSG.REQUIRED_FIELDS, 'Please enter the required fields.');
          }
        }
      }

      // 2) PRIO_RANK >= 1 인 정수. 셀 편집기(SalesSitePriorityGrid, format 'n0')가 직접 입력의 소수점을
      //    이미 막지만, 붙여넣기 등 편집기를 우회하는 경로의 이중 안전망으로 저장 시에도 재검증한다.
      //    AS-IS 는 저장 시 Convert.ToInt32(v_prio_rank) 가 try/catch 밖이라 "1.5" 에서 FormatException
      //    으로 저장이 중단된다(SCP0131_SalesSitePriority.cs:674). Number.isInteger 는 NaN/Infinity/소수
      //    를 모두 false 로 거른다.
      for (const r of dirty) {
        const prio = Number(r.PRIO_RANK);
        if (!Number.isInteger(prio) || prio < 1) {
          return alert(MSG.PRIO_MIN, '{0} must be an integer greater than 0.', 'PRIORITY');
        }
        // 상한 — AS-IS 는 저장 시 Convert.ToInt32(v_prio_rank)(cs:675)가 Int32.MaxValue(2,147,483,647)
        //   초과에서 OverflowException 으로 저장을 중단한다(전용 메시지 없이 abort). TO-BE 는 등가 상한을
        //   MSG01036 으로 명시 차단한다. 셀 입력은 15자리로 cap(SalesSitePriorityGrid)해 JS 수치 정밀도
        //   손실·지수표기를 막되, 2,147,483,648~(15자리) 구간은 이 저장검증이 걸러 AS-IS 저장 중단과 등가.
        if (prio > 2147483647) {
          return alert(MSG.PRIO_MAX, 'Only values less than or equal to {0} are allowed.', '2,147,483,647');
        }
      }

      // 3) From <= To. 셀 원형(표시값)은 포맷이 섞인다 — GET 은 'yyyy-MM-dd HH:mm:ss'(시간부 포함),
      //    붙여넣기 셀은 복사원 포맷 그대로라 구분자/시간부/자리수가 행마다 다를 수 있다. 저장 payload 와
      //    동일한 ymd8(숫자만 8자리)로 정규화해 비교해야 포맷 불일치로 비교가 뒤집히는 우회를 막는다
      //    (실측 2026-11-03: To 셀에 From 이전 날짜를 복붙 저장 시 원형 문자열 비교가 통과하던 버그).
      for (const r of dirty) {
        const from = ymd8(r.FROM_YYYYMMDD);
        const to = ymd8(r.TO_YYYYMMDD);
        if (from.length === 8 && to.length === 8 && from > to) {
          return alert(
            MSG.PERIOD_INVALID,
            'The start date can not be later than the end date.\n\rSearch the list and enter it again.'
          );
        }
      }

      return { ok: true };
    },
    [alert]
  );

  return { validateSaveRows };
};
