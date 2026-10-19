// @vitest-environment node
/**
 * ForecastPriceGridUtils 단위테스트 — **AS-IS 산식 1:1 대사** (2026-08-08 신설)
 *
 * 왜 필요한가: `__asis-mapping__.md` 는 "누락 없음"을 강제하지만 **"동일하게 동작함"은 보증하지 못한다.**
 *   인용 실재성 검사도 "코드가 거기 있다"까지만 증명한다. 2026-08-08 에 실제로 이런 일이 있었다 —
 *   함수는 존재했고 대사표는 "구현"이었는데 **주배분 분기식에 버그**가 있었고 **LOC 월 기준일이 일요일**이었다.
 *   배분 로직은 틀리면 **저장되는 수치가 틀린다** → 순수 함수인 이 파일부터 값으로 못 박는다.
 *
 * 기준 원천: `Doc/_legacy_source/.../DMF0082_FcstNPrice_Mgmt.cs` (라인은 각 테스트에 인용)
 *   + `Doc/화면분석서/DMF0082_FcstNPrice_제약매트릭스_상세.md` 제약 ID(M-xx / P-xx)
 */
import { describe, expect, it, vi } from 'vitest';

import {
  allocateLoc,
  bucketBitsOfDay,
  divideByMonth,
  divideByWeek,
  isNonEditableCell,
  LOC_BUCKET_BITS,
  type CalendarInfo,
} from './ForecastPriceGridUtils';

/** EditTracker 스텁 — 배분 함수는 storeChange 로 변경 이력만 남기므로 no-op 로 충분. */
const tracker = () => ({ storeChange: vi.fn() }) as never;

/** 2026-08-03(월) ~ 2026-08-09(일) 1주. dayjs().day(): 0=SUN … 6=SAT */
const WEEK1 = [
  'D_20260803',
  'D_20260804',
  'D_20260805',
  'D_20260806',
  'D_20260807',
  'D_20260808',
  'D_20260809',
];
const WEEK2 = [
  'D_20260810',
  'D_20260811',
  'D_20260812',
  'D_20260813',
  'D_20260814',
  'D_20260815',
  'D_20260816',
];

const weekMap = () =>
  new Map<string, Set<string>>([
    ['W_2026081', new Set(WEEK1)],
    ['W_2026082', new Set(WEEK2)],
  ]);
const monthMap = () =>
  new Map<string, Set<string>>([['M_202608', new Set(['W_2026081', 'W_2026082'])]]);

const row = (over: Record<string, unknown> = {}) =>
  ({ DIVISION_ID: '81', MEASURE: 'MKT_FCST', BUCKET: null, ...over }) as never;

describe('bucketBitsOfDay — AS-IS sDefaultDay switch (.cs L6024~6055)', () => {
  it('요일 코드를 SUN-first 요일비트로 변환한다', () => {
    expect(bucketBitsOfDay('SUN')).toBe('1000000');
    expect(bucketBitsOfDay('MON')).toBe('0100000');
    expect(bucketBitsOfDay('TUE')).toBe('0010000');
    expect(bucketBitsOfDay('WED')).toBe('0001000');
    expect(bucketBitsOfDay('THU')).toBe('0000100');
    expect(bucketBitsOfDay('FRI')).toBe('0000010');
    expect(bucketBitsOfDay('SAT')).toBe('0000001');
  });

  it('미지정·미매칭 폴백은 **월요일**이다 (AS-IS switch default — 금요일 아님)', () => {
    expect(bucketBitsOfDay(undefined)).toBe('0100000');
    expect(bucketBitsOfDay('')).toBe('0100000');
    expect(bucketBitsOfDay('XXX')).toBe('0100000');
  });

  it('LOC 는 버킷과 무관하게 월요일 고정 (.cs L6008~6012)', () => {
    expect(LOC_BUCKET_BITS).toBe('0100000');
  });
});

describe('divideByWeek — 주 수량의 버킷요일 배분 (M-15)', () => {
  it('버킷요일에 균등 배분하고 **마지막 버킷요일에 잔량**을 준다', () => {
    // 수요일(0001000) 1일만 버킷 → 전량 수요일
    const r = row({ BUCKET: '0001000' });
    divideByWeek('W_2026081', r, 100, null, weekMap(), tracker(), '0100000');
    expect(r['D_20260805']).toBe(100); // 수요일
    expect(r['D_20260803']).toBe(0); // 월요일은 0
  });

  it('버킷요일 2일이면 앞은 몫, 마지막은 잔량 (7 → 3 + 4)', () => {
    const r = row({ BUCKET: '0101000' }); // 월(1) + 수(3)
    divideByWeek('W_2026081', r, 7, null, weekMap(), tracker(), '0100000');
    expect(r['D_20260803']).toBe(3); // 월 = trunc(7/2)
    expect(r['D_20260805']).toBe(4); // 수 = 잔량
  });

  it('⭐ 회귀 — division 81 이어도 **유효 요일비트는 덮어쓰지 않는다** (2026-08-08 결함)', () => {
    // 구 코드: `else if (bucketValue==='0000000' || DIVISION_ID!=='40')` → 정상 비트열도 FRI 로 덮어씀
    const r = row({ DIVISION_ID: '81', BUCKET: '0001000' }); // 수요일
    divideByWeek('W_2026081', r, 50, null, weekMap(), tracker(), '0000010' /* FRI */);
    expect(r['D_20260805']).toBe(50); // 수요일에 들어가야 한다
    expect(r['D_20260807']).toBe(0); // 금요일이 아니다
  });

  it('BUCKET 이 "0000000"/null 이면 defaultBucket 을 쓴다 (P-23)', () => {
    const r = row({ BUCKET: '0000000' });
    divideByWeek('W_2026081', r, 30, null, weekMap(), tracker(), '0000010' /* FRI */);
    expect(r['D_20260807']).toBe(30); // 금요일
  });
});

describe('divideByMonth — 월수량 일별 배분 (M-19, .cs L7205~7279)', () => {
  // AS-IS: iWeeklyQty = Truncate(월합 / MONTH_DAY_CNT) * WEEK_DAY_CNT
  //        iDailyQty  = Truncate(iWeeklyQty / 버킷요일수), 마지막 버킷요일 = 주 잔량
  const calendar = (): Map<string, CalendarInfo> =>
    new Map([
      ['D_20260803', { monthDayCnt: 14, weekDayCnt: 7 }],
      ['D_20260810', { monthDayCnt: 14, weekDayCnt: 7 }],
    ]);

  it('주간 수량 = trunc(월합/월일수) × 주일수', () => {
    const r = row({ BUCKET: '0100000' }); // 월요일만
    divideByMonth('M_202608', r, 100, monthMap(), weekMap(), calendar(), tracker(), '0100000');
    // trunc(100/14)=7 → 7*7 = 49 (주별)
    expect(r['W_2026081']).toBe(49);
  });

  it('버킷요일이 1일이면 주간 수량 전액이 그 날짜에 들어간다', () => {
    const r = row({ BUCKET: '0100000' });
    divideByMonth('M_202608', r, 100, monthMap(), weekMap(), calendar(), tracker(), '0100000');
    expect(r['D_20260803']).toBe(49); // 1주차 월요일
    expect(r['D_20260804']).toBe(0); // 비버킷일은 0 초기화
  });

  it('월 잔량은 **마지막 버킷주에 가산**된다 (step3, .cs L7315~7365)', () => {
    const r = row({ BUCKET: '0100000' });
    divideByMonth('M_202608', r, 100, monthMap(), weekMap(), calendar(), tracker(), '0100000');
    // 배분 합 49*2=98, 잔량 2 → 마지막 주(2주차)에 가산
    expect(r['W_2026082']).toBe(51);
    expect(r['D_20260810']).toBe(51);
    // 월 총합 보존
    expect(Number(r['W_2026081']) + Number(r['W_2026082'])).toBe(100);
  });
});

describe('allocateLoc — LOC 일괄 할당 (M-16 / M-20)', () => {
  it('주(W_) 수정: **월요일 셀에만** 값, 나머지 0', () => {
    const r = row({ MEASURE: 'LOC' });
    allocateLoc('W_2026081', r, 1234, monthMap(), weekMap(), tracker());
    expect(r['D_20260803']).toBe(1234); // 월요일
    expect(r['D_20260804']).toBe(0);
    expect(r['D_20260809']).toBe(0);
  });

  it('⭐ 회귀 — 월(M_) 수정도 **월요일** 기준이다 (2026-08-08 결함: 일요일이었음)', () => {
    const r = row({ MEASURE: 'LOC' });
    allocateLoc('M_202608', r, 500, monthMap(), weekMap(), tracker());
    expect(r['D_20260803']).toBe(500); // 1주차 월요일
    expect(r['D_20260810']).toBe(500); // 2주차 월요일
    expect(r['D_20260809']).toBe(0); // 일요일에 들어가면 안 된다
    expect(r['D_20260816']).toBe(0);
  });

  it('월(M_) 수정 시 각 주차 셀에도 월값을 기입한다', () => {
    const r = row({ MEASURE: 'LOC' });
    allocateLoc('M_202608', r, 500, monthMap(), weekMap(), tracker());
    expect(r['W_2026081']).toBe(500);
    expect(r['W_2026082']).toBe(500);
  });
});

describe('isNonEditableCell — 편집 차단 게이트 (M-03 / M-04·F-01 / M-07)', () => {
  const grid = () => ({ isReadOnly: false }) as never;
  const call = (item: Record<string, unknown>, binding: string, bucket: string) =>
    isNonEditableCell(grid(), binding, item as never, weekMap(), bucket, '');

  it('EDIT_FLAG=N 행은 편집 불가', () => {
    expect(call({ EDIT_FLAG: 'N', MEASURE: 'MKT_FCST' }, 'W_2026081', 'Weekly')).toBe(true);
  });

  it('편집대상 measure 가 아니면 불가 (M-07)', () => {
    expect(call({ MEASURE: 'BALANCE' }, 'W_2026081', 'Weekly')).toBe(true);
  });

  it('SCM_FCST × FCST_TYPE=RMA 는 편집 불가 (M-04 / F-01, .cs L9239)', () => {
    expect(call({ MEASURE: 'SCM_FCST', FCST_TYPE: 'RMA' }, 'W_2026081', 'Weekly')).toBe(true);
    expect(call({ MEASURE: 'SCM_FCST', FCST_TYPE: 'NOR' }, 'W_2026081', 'Weekly')).toBe(false);
  });

  it('Daily 버킷 × LOC 는 편집 불가 (M-03, 2025-08-05)', () => {
    expect(call({ MEASURE: 'LOC' }, 'D_20260803', 'Daily')).toBe(true);
    expect(call({ MEASURE: 'MKT_FCST' }, 'D_20260803', 'Daily')).toBe(false);
  });

  it('버킷과 컬럼 종류가 어긋나면 편집 불가 (P-12)', () => {
    expect(call({ MEASURE: 'MKT_FCST' }, 'W_2026081', 'Monthly')).toBe(true);
    expect(call({ MEASURE: 'MKT_FCST' }, 'M_202608', 'Weekly')).toBe(true);
  });
});
