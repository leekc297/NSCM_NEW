// @vitest-environment node
/**
 * 과거 구간 잠금 — AS-IS SetEditList(.cs L9128~9138) "금주 월요일 포함 이후가 Unlock" 1:1.
 *
 * 이 화면이 공용 `@foundation/utils isNonEditableDateColumn` 을 쓰지 않는 이유는
 * `isPastPeriodLocked` 헤더 주석이 단일 출처다 (공용 함수는 파싱 버그로 항상 false).
 * 그 사실 자체를 아래 마지막 describe 가 못 박는다 — 공용 함수가 고쳐지면 이 테스트가 깨져서
 * "이제 위임해도 된다"는 신호가 된다.
 */
import { describe, expect, it } from 'vitest';

import { isNonEditableDateColumn } from '@foundation/utils';

import {
  editableDayColumnsOf,
  isPastPeriodLocked,
  thisWeekMondayYmd,
} from './forecast-price.editLock';

// 2026-08-05(수). 금주 = 8/3(월)~8/9(일) → 금주 월요일 = 20260803.
const TODAY = new Date(2026, 7, 5);

const WEEK_THIS = new Set(['D_20260803', 'D_20260804', 'D_20260805']);
const WEEK_PREV = new Set(['D_20260727', 'D_20260728', 'D_20260729']);
const weekMap = () =>
  new Map<string, Set<string>>([
    ['W_2026082', WEEK_THIS],
    ['W_2026081', WEEK_PREV],
  ]);

describe('thisWeekMondayYmd', () => {
  it('수요일 기준 그 주 월요일', () => {
    expect(thisWeekMondayYmd(TODAY)).toBe('20260803');
  });

  // 일요일은 그 주의 끝 — 다음날 월요일이 아니라 6일 전 월요일로 간다.
  it('일요일은 6일 전 월요일로 간다', () => {
    expect(thisWeekMondayYmd(new Date(2026, 7, 9))).toBe('20260803');
  });
});

describe('isPastPeriodLocked — M_ (당월 기준)', () => {
  // 현업 검수 40번 "Monthly Bucket 조회 시 Unit Price(LOC) 는 당월부터 입력 가능".
  it('당월은 열려 있다', () => {
    expect(isPastPeriodLocked('M_202608', weekMap(), TODAY)).toBe(false);
  });

  it('미래 월은 열려 있다', () => {
    expect(isPastPeriodLocked('M_202609', weekMap(), TODAY)).toBe(false);
  });

  it('과거 월은 잠긴다', () => {
    expect(isPastPeriodLocked('M_202607', weekMap(), TODAY)).toBe(true);
    expect(isPastPeriodLocked('M_202512', weekMap(), TODAY)).toBe(true);
  });
});

describe('isPastPeriodLocked — D_ (금주 월요일 기준)', () => {
  it('금주 월요일 당일은 열려 있다', () => {
    expect(isPastPeriodLocked('D_20260803', weekMap(), TODAY)).toBe(false);
  });

  it('금주 월요일 이전은 잠긴다', () => {
    expect(isPastPeriodLocked('D_20260802', weekMap(), TODAY)).toBe(true);
  });

  it('미래 일자는 열려 있다', () => {
    expect(isPastPeriodLocked('D_20261225', weekMap(), TODAY)).toBe(false);
  });

  // 저장 측(editableDayColumnsOf)과 같은 경계를 써야 "입력은 되는데 저장에서 잘리는" 구간이 안 생긴다.
  it('editableDayColumnsOf 와 경계가 일치한다', () => {
    const days = ['D_20260802', 'D_20260803', 'D_20260804'];
    const savable = new Set(editableDayColumnsOf(days, TODAY));
    days.forEach(d => {
      expect(isPastPeriodLocked(d, weekMap(), TODAY)).toBe(!savable.has(d));
    });
  });
});

describe('isPastPeriodLocked — W_ (주 최소일 기준)', () => {
  it('금주는 열려 있다', () => {
    expect(isPastPeriodLocked('W_2026082', weekMap(), TODAY)).toBe(false);
  });

  it('지난주는 잠긴다', () => {
    expect(isPastPeriodLocked('W_2026081', weekMap(), TODAY)).toBe(true);
  });

  // Weekly 조회는 D_ 컬럼이 아예 없다 — 그때는 binding 의 년월·ISO 주차로 판정한다.
  describe('weekMap 에 일자가 없을 때의 폴백', () => {
    const empty = () => new Map<string, Set<string>>();

    it('과거 월의 주는 잠긴다', () => {
      expect(isPastPeriodLocked('W_2026074', empty(), TODAY)).toBe(true);
    });

    it('미래 월의 주는 열려 있다', () => {
      expect(isPastPeriodLocked('W_2026091', empty(), TODAY)).toBe(false);
    });

    // 2026-08-05 는 ISO 32주차 — 당월 안에서는 주차 번호로 가른다.
    it('당월 안에서는 ISO 주차 번호로 가른다', () => {
      expect(isPastPeriodLocked('W_20260831', empty(), TODAY)).toBe(true);
      expect(isPastPeriodLocked('W_20260832', empty(), TODAY)).toBe(false);
      expect(isPastPeriodLocked('W_20260833', empty(), TODAY)).toBe(false);
    });
  });
});

describe('isPastPeriodLocked — 대상 아닌 binding', () => {
  it('정적 컬럼은 판정 대상이 아니다', () => {
    expect(isPastPeriodLocked('MEASURE', weekMap(), TODAY)).toBe(false);
    expect(isPastPeriodLocked('', weekMap(), TODAY)).toBe(false);
  });
});

// 공용 함수를 쓰지 않는 근거를 실측으로 고정한다 (2026-08-05 발견 / 2026-08-13 재확인).
//   `substring(1)` 이 언더스코어를 남기고 customParseFormat 도 미등록이라 파싱이 항상 Invalid,
//   Invalid 의 isBefore/isSame 은 false → 결과가 언제나 "잠금 없음" 이었다.
//   이 테스트가 깨지면 공용 함수가 고쳐진 것이므로 위임으로 되돌릴지 검토한다.
describe('공용 isNonEditableDateColumn 은 이 화면에서 쓸 수 없다', () => {
  it('M_/W_/D_ 어느 쪽도 잠그지 못한다 (항상 false)', () => {
    const wm = weekMap();
    expect(isNonEditableDateColumn('M_202001', wm)).toBe(false);
    expect(isNonEditableDateColumn('W_2026081', wm)).toBe(false);
    expect(isNonEditableDateColumn('D_20200101', wm)).toBe(false);
  });
});
