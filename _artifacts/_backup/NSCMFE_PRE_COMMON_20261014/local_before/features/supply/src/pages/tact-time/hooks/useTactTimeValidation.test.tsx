// @vitest-environment jsdom

import { renderHook } from '@testing-library/react';
import { beforeEach, describe, expect, it, vi } from 'vitest';

import { EXCEPT_DATE_MIN, MSG, YIELD_MAX, YIELD_MIN } from '../tact-time.constants';

import { useTactTimeValidation } from './useTactTimeValidation';

// setAlert 는 hook 이 useMessageStore.getState() 로 꺼내 쓴다 — getState 를 가진 객체로 mock.
//   실패 시 content 로 넘어오는 MSG 코드까지 검증하려고 t 는 첫 인자(msgId)를 그대로 돌려준다(아래 stubGlobal).
const { setAlertMock } = vi.hoisted(() => ({ setAlertMock: vi.fn() }));

vi.mock('@shared/stores', () => ({
  useMessageStore: { getState: () => ({ setAlert: setAlertMock }) },
}));

// useTranslation 은 unplugin-auto-import 전역(@foundation/i18n) — vitest 엔 AutoImport 플러그인이 없어
//   직접 stub. t(msgId, fallback) 가 msgId 를 반환하도록 해 setAlert content = 매핑된 MSG 코드가 되게 한다.
vi.stubGlobal('useTranslation', () => ({ t: (key: string) => key }));

const setup = () => renderHook(() => useTactTimeValidation()).result.current;

beforeEach(() => {
  setAlertMock.mockClear();
});

// dirty 판정은 CRUD_TYPE 유무 — 조회건(CRUD_TYPE 없음)은 검증 대상에서 제외된다.
const dirty = (over: Record<string, unknown>) => ({ CRUD_TYPE: 'U', ...over });

describe('validateMainRows — Plant/Packer 저장 검증', () => {
  it('CRUD_TYPE 없는 조회건은 값이 잘못돼도 통과(dirty 만 검사)', () => {
    const { validateMainRows } = setup();
    // PRIORITY=-1 이지만 CRUD_TYPE 없음 → skip
    expect(validateMainRows([{ PRIORITY: -1, TACT_TIME: -1 }]).ok).toBe(true);
    expect(setAlertMock).not.toHaveBeenCalled();
  });

  it('PRIORITY <= 0 이면 MSG00193(REQUIRED_POSITIVE) 로 실패', () => {
    const { validateMainRows } = setup();
    expect(validateMainRows([dirty({ PRIORITY: 0 })]).ok).toBe(false);
    expect(setAlertMock).toHaveBeenCalledWith({ type: 'alert', content: MSG.REQUIRED_POSITIVE });
  });

  it('TACT_TIME <= 0 이면 MSG00193(REQUIRED_POSITIVE) 로 실패', () => {
    const { validateMainRows } = setup();
    expect(validateMainRows([dirty({ PRIORITY: 1, TACT_TIME: 0 })]).ok).toBe(false);
    expect(setAlertMock).toHaveBeenCalledWith({ type: 'alert', content: MSG.REQUIRED_POSITIVE });
  });

  it('빈 PRIORITY/TACT_TIME(null) 은 검사 건너뜀 — 통과', () => {
    const { validateMainRows } = setup();
    expect(validateMainRows([dirty({ PRIORITY: '', TACT_TIME: '' })]).ok).toBe(true);
  });

  it(`YIELD < ${YIELD_MIN} 이면 MSG00085(RANGE_MIN) 로 실패`, () => {
    const { validateMainRows } = setup();
    expect(validateMainRows([dirty({ PRIORITY: 1, YIELD: YIELD_MIN - 1 })]).ok).toBe(false);
    expect(setAlertMock).toHaveBeenCalledWith({ type: 'alert', content: MSG.RANGE_MIN });
  });

  it(`YIELD > ${YIELD_MAX} 이면 MSG00072(RANGE_MAX) 로 실패`, () => {
    const { validateMainRows } = setup();
    expect(validateMainRows([dirty({ PRIORITY: 1, YIELD: YIELD_MAX + 1 })]).ok).toBe(false);
    expect(setAlertMock).toHaveBeenCalledWith({ type: 'alert', content: MSG.RANGE_MAX });
  });

  it('YIELD 경계(1, 100)는 통과', () => {
    const { validateMainRows } = setup();
    expect(validateMainRows([dirty({ PRIORITY: 1, YIELD: YIELD_MIN })]).ok).toBe(true);
    expect(validateMainRows([dirty({ PRIORITY: 1, YIELD: YIELD_MAX })]).ok).toBe(true);
  });

  it('전극(E) 행에 LANE_QTY 누락/0 이면 MSG00429(REQUIRED_FIELD) 로 실패', () => {
    const { validateMainRows } = setup();
    expect(validateMainRows([dirty({ PRIORITY: 1, OPERATION_GROUP_ID: 'E' })]).ok).toBe(false);
    expect(setAlertMock).toHaveBeenCalledWith({ type: 'alert', content: MSG.REQUIRED_FIELD });

    setAlertMock.mockClear();
    expect(
      validateMainRows([dirty({ PRIORITY: 1, OPERATION_GROUP_ID: 'E', LANE_QTY: 0 })]).ok
    ).toBe(false);
  });

  it('전극(E) 행에 LANE_QTY > 0 이면 통과', () => {
    const { validateMainRows } = setup();
    expect(
      validateMainRows([dirty({ PRIORITY: 1, OPERATION_GROUP_ID: 'E', LANE_QTY: 4 })]).ok
    ).toBe(true);
  });

  it('비전극 행은 LANE_QTY 없어도 통과', () => {
    const { validateMainRows } = setup();
    expect(validateMainRows([dirty({ PRIORITY: 1, OPERATION_GROUP_ID: 'P' })]).ok).toBe(true);
  });

  it('모든 규칙을 만족하는 행은 통과 — setAlert 미호출', () => {
    const { validateMainRows } = setup();
    const ok = validateMainRows([
      dirty({ PRIORITY: 3, TACT_TIME: 120, YIELD: 95, OPERATION_GROUP_ID: 'E', LANE_QTY: 2 }),
    ]);
    expect(ok.ok).toBe(true);
    expect(setAlertMock).not.toHaveBeenCalled();
  });
});

describe('validateExceptRows — Except 저장 검증', () => {
  // 통과하는 기준 행 — 필요한 축만 덮어써서 실패를 유도한다.
  const baseExcept = (over: Record<string, unknown> = {}) =>
    dirty({
      LINE_ID: 'L1',
      DIVISION_ID: '81',
      PLANT_SITE_ID: 'P1',
      ITEM_ID: 'I1',
      OPERATION_ID: 'O1',
      TACT_TIME_START_DATE: '20260101',
      TACT_TIME_END_DATE: '20260131',
      ...over,
    });

  it('LINE_ID 공백이면 MSG00429(REQUIRED_FIELD) 로 실패', () => {
    const { validateExceptRows } = setup();
    expect(validateExceptRows([baseExcept({ LINE_ID: '   ' })]).ok).toBe(false);
    expect(setAlertMock).toHaveBeenCalledWith({ type: 'alert', content: MSG.REQUIRED_FIELD });
  });

  it('날짜 형식이 yyyyMMdd 가 아니면 MSG00611(DATE_FORMAT) 로 실패', () => {
    const { validateExceptRows } = setup();
    expect(validateExceptRows([baseExcept({ TACT_TIME_START_DATE: '2026-01-01' })]).ok).toBe(false);
    expect(setAlertMock).toHaveBeenCalledWith({ type: 'alert', content: MSG.DATE_FORMAT });
  });

  it('형식은 맞지만 실재하지 않는 날짜(20260230)면 DATE_FORMAT 로 실패', () => {
    const { validateExceptRows } = setup();
    expect(validateExceptRows([baseExcept({ TACT_TIME_START_DATE: '20260230' })]).ok).toBe(false);
    expect(setAlertMock).toHaveBeenCalledWith({ type: 'alert', content: MSG.DATE_FORMAT });
  });

  it(`날짜가 하한(${EXCEPT_DATE_MIN}) 미만이면 MSG00048(DATE_RANGE) 로 실패`, () => {
    const { validateExceptRows } = setup();
    // 17520101 = 유효 형식·실재 날짜이지만 하한 미만
    expect(
      validateExceptRows([
        baseExcept({ TACT_TIME_START_DATE: '17520101', TACT_TIME_END_DATE: '17520201' }),
      ]).ok
    ).toBe(false);
    expect(setAlertMock).toHaveBeenCalledWith({ type: 'alert', content: MSG.DATE_RANGE });
  });

  it('시작 > 종료면 MSG00108(START_END_ORDER) 로 실패', () => {
    const { validateExceptRows } = setup();
    expect(
      validateExceptRows([
        baseExcept({ TACT_TIME_START_DATE: '20260201', TACT_TIME_END_DATE: '20260101' }),
      ]).ok
    ).toBe(false);
    expect(setAlertMock).toHaveBeenCalledWith({ type: 'alert', content: MSG.START_END_ORDER });
  });

  it('YIELD 범위 위반이면 실패(Except 도 1~100)', () => {
    const { validateExceptRows } = setup();
    expect(validateExceptRows([baseExcept({ YIELD: YIELD_MAX + 1 })]).ok).toBe(false);
    expect(setAlertMock).toHaveBeenCalledWith({ type: 'alert', content: MSG.RANGE_MAX });
  });

  it('같은 복합키에서 기간이 겹치면 MSG00105(PERIOD_OVERLAP) 로 실패', () => {
    const { validateExceptRows } = setup();
    const rows = [
      baseExcept({ TACT_TIME_START_DATE: '20260101', TACT_TIME_END_DATE: '20260131' }),
      baseExcept({ TACT_TIME_START_DATE: '20260115', TACT_TIME_END_DATE: '20260210' }),
    ];
    expect(validateExceptRows(rows).ok).toBe(false);
    expect(setAlertMock).toHaveBeenCalledWith({ type: 'alert', content: MSG.PERIOD_OVERLAP });
  });

  it('같은 복합키라도 기간이 안 겹치면 통과', () => {
    const { validateExceptRows } = setup();
    const rows = [
      baseExcept({ TACT_TIME_START_DATE: '20260101', TACT_TIME_END_DATE: '20260131' }),
      baseExcept({ TACT_TIME_START_DATE: '20260201', TACT_TIME_END_DATE: '20260228' }),
    ];
    expect(validateExceptRows(rows).ok).toBe(true);
    expect(setAlertMock).not.toHaveBeenCalled();
  });

  it('복합키가 다르면 기간이 겹쳐도 통과(그룹 분리)', () => {
    const { validateExceptRows } = setup();
    const rows = [
      baseExcept({ LINE_ID: 'L1', TACT_TIME_START_DATE: '20260101', TACT_TIME_END_DATE: '20260131' }),
      baseExcept({ LINE_ID: 'L2', TACT_TIME_START_DATE: '20260115', TACT_TIME_END_DATE: '20260210' }),
    ];
    expect(validateExceptRows(rows).ok).toBe(true);
  });

  it('유효한 단일 행은 통과 — setAlert 미호출', () => {
    const { validateExceptRows } = setup();
    expect(validateExceptRows([baseExcept({ YIELD: 90 })]).ok).toBe(true);
    expect(setAlertMock).not.toHaveBeenCalled();
  });
});
