// @vitest-environment node
/**
 * DMF0003 재계산(주/월→일 분배) 중 기본 배분요일(sDefaultDay) 처리 단위테스트.
 *
 * 원천: 정본 `GSCM.DM.Plan.UIL/DMF0003_MktFcst.cs`
 *   · bWeekAll 폴백 — L3685~3743 (버킷 요일 없음 → sDefaultDay 셀 1개, 없으면 마지막 D_).
 *   · bMonthAll 폴백 — L3833~3838(iDaycnt=iMonthCnt) / L4051~4092(sDefaultDay 셀 균등분배).
 *
 * 검증 요지: 과거 코드는 폴백 요일을 월요일로 박아 두었으나(사용자 지적 "월요일 고정은 잘못"),
 *   AS-IS 는 마스터 DefaultBucketDay(division×bucketType) 로 요일을 결정한다. 여기서는 그 요일이
 *   실제 분배 셀을 좌우하는지를 dowIndexOfCode 변환값과 함께 대사한다.
 */
import { describe, expect, it } from 'vitest';

import { BUCKET_TYPE } from '../mkt-fcst.constants';

import {
  dispatchRecalc,
  dowIndexOfCode,
  type RecalcAccessor,
} from './mkt-fcst.recalc';

// 요일 인덱스: 0=일..6=토. 아래 날짜들의 실제 요일(UTC)로 컬럼을 구성한다.
//   2024-01-01(월) 기준 한 주: 01=월,02=화,03=수,04=목,05=금,06=토,07=일.
const D = (ymd: string) => `D_${ymd}`;
const W = (yyyymmww: string) => `W_${yyyymmww}`;
const M = (yyyymm: string) => `M_${yyyymm}`;

/**
 * 간단한 in-memory RecalcAccessor 팩토리.
 * cols: 좌→우 binding 순서. init: 초기값. bucket: 7자리 요일 플래그(전 행 공통).
 * thisMondayYmd: 과거 판정 기준(이 값보다 작은 D_ 는 과거 = 보존).
 */
const makeAcc = (
  cols: string[],
  init: Record<string, number | null>,
  bucket: string,
  thisMondayYmd: string,
  sspSync: Record<string, 'A'> = {}
): { acc: RecalcAccessor; store: Record<string, number | null> } => {
  const store: Record<string, number | null> = {};
  cols.forEach(c => {
    store[c] = c in init ? init[c] : null;
  });
  const acc: RecalcAccessor = {
    dynBindings: cols,
    get: b => (b in store ? store[b] : null),
    set: (b, v) => {
      store[b] = v;
    },
    bucket,
    sspSyncOf: b => (sspSync[b] === 'A' ? 'A' : null),
    thisMondayYmd,
  };
  return { acc, store };
};

describe('dowIndexOfCode — sDefaultDay 코드 → 요일 인덱스(0=일..6=토)', () => {
  it('SUN..SAT 정매핑', () => {
    expect(dowIndexOfCode('SUN')).toBe(0);
    expect(dowIndexOfCode('MON')).toBe(1);
    expect(dowIndexOfCode('TUE')).toBe(2);
    expect(dowIndexOfCode('WED')).toBe(3);
    expect(dowIndexOfCode('THU')).toBe(4);
    expect(dowIndexOfCode('FRI')).toBe(5);
    expect(dowIndexOfCode('SAT')).toBe(6);
  });

  it('공백/대소문자/미지정 → 정규화 또는 -1', () => {
    expect(dowIndexOfCode(' fri ')).toBe(5);
    expect(dowIndexOfCode('')).toBe(-1);
    expect(dowIndexOfCode(undefined)).toBe(-1);
    expect(dowIndexOfCode('XXX')).toBe(-1);
  });
});

describe('recalcWeeklyToDaily bWeekAll 폴백 — 버킷 요일 없음 (.cs L3685~3743)', () => {
  // 한 주 D_ 7일(월~일) + 주헤더 W_. bucket='0000000' → 버킷 허용 요일 0개 → weekAll.
  const week = [
    W('20240101'),
    D('20240101'), // 월
    D('20240102'), // 화
    D('20240103'), // 수
    D('20240104'), // 목
    D('20240105'), // 금
    D('20240106'), // 토
    D('20240107'), // 일
    M('202401'), // 경계
  ];
  const noBucket = '0000000';
  const monday = '20240101'; // 모든 날짜가 당주(과거 아님)

  it('sDefaultDay=FRI 면 금요일 셀에 전량 배분(월요일 아님)', () => {
    const { acc, store } = makeAcc(week, { [W('20240101')]: 70 }, noBucket, monday);
    dispatchRecalc({
      acc,
      editedBinding: W('20240101'),
      bucketType: BUCKET_TYPE.WEEKLY,
      divisionId: '81',
      measure: 'MKT_FCST',
      defaultBucketDow: dowIndexOfCode('FRI'), // 5
    });
    expect(store[D('20240105')]).toBe(70); // 금요일
    expect(store[D('20240101')]).toBeNull(); // 월요일엔 배분되지 않는다
  });

  it('sDefaultDay=WED 면 수요일 셀에 전량 배분', () => {
    const { acc, store } = makeAcc(week, { [W('20240101')]: 70 }, noBucket, monday);
    dispatchRecalc({
      acc,
      editedBinding: W('20240101'),
      bucketType: BUCKET_TYPE.WEEKLY,
      divisionId: '81',
      measure: 'MKT_FCST',
      defaultBucketDow: dowIndexOfCode('WED'), // 3
    });
    expect(store[D('20240103')]).toBe(70); // 수요일
  });

  it('마스터 미해소(-1) → 그 주 마지막 D_ 셀 폴백 (.cs L3732~3741)', () => {
    const { acc, store } = makeAcc(week, { [W('20240101')]: 70 }, noBucket, monday);
    dispatchRecalc({
      acc,
      editedBinding: W('20240101'),
      bucketType: BUCKET_TYPE.WEEKLY,
      divisionId: '81',
      measure: 'MKT_FCST',
      defaultBucketDow: -1,
    });
    expect(store[D('20240107')]).toBe(70); // 마지막 D_ = 일요일
  });

  it('sDefaultDay 요일이 그 주에 없으면(부분주) 마지막 D_ 폴백', () => {
    // 월~수 3일짜리 부분주. sDefaultDay=FRI(금)은 이 주에 없다.
    const partial = [W('20240101'), D('20240101'), D('20240102'), D('20240103'), M('202401')];
    const { acc, store } = makeAcc(partial, { [W('20240101')]: 30 }, noBucket, monday);
    dispatchRecalc({
      acc,
      editedBinding: W('20240101'),
      bucketType: BUCKET_TYPE.WEEKLY,
      divisionId: '81',
      measure: 'MKT_FCST',
      defaultBucketDow: dowIndexOfCode('FRI'), // 5 — 없음
    });
    expect(store[D('20240103')]).toBe(30); // 마지막 D_ = 수요일
  });
});

describe('recalcMonthlyToDaily bMonthAll 폴백 — 버킷 요일 없음 (.cs L3833~4092)', () => {
  // 2주 × 7일 = D_ 14일 + 두 주헤더. bucket='0000000' → iDaycnt=0 → bMonthAll(iMonthCnt).
  const cols = [
    M('202401'),
    W('20240101'),
    D('20240101'), // 월
    D('20240102'), // 화
    D('20240103'), // 수
    D('20240104'), // 목
    D('20240105'), // 금
    D('20240106'), // 토
    D('20240107'), // 일
    W('20240102'),
    D('20240108'), // 월
    D('20240109'), // 화
    D('20240110'), // 수
    D('20240111'), // 목
    D('20240112'), // 금
    D('20240113'), // 토
    D('20240114'), // 일
  ];
  const noBucket = '0000000';
  const monday = '20240101';

  it('sDefaultDay=MON 면 두 월요일에 균등분배 + 나머지 마지막 월요일 (.cs L4068~4084)', () => {
    // 월합 100 → MON 2일 → 50/50, 나머지 0.
    const { acc, store } = makeAcc(cols, { [M('202401')]: 100 }, noBucket, monday);
    const r = dispatchRecalc({
      acc,
      editedBinding: M('202401'),
      bucketType: BUCKET_TYPE.MONTHLY,
      divisionId: '81',
      measure: 'MKT_FCST',
      defaultBucketDow: dowIndexOfCode('MON'), // 1
    });
    expect(r.kind).toBe('ok');
    expect(store[D('20240101')]).toBe(50); // 첫 월요일
    expect(store[D('20240108')]).toBe(50); // 둘째 월요일
    // 월요일 아닌 셀은 clear
    expect(store[D('20240102')]).toBeNull();
    expect(store[D('20240105')]).toBeNull();
  });

  it('나머지(remnant)는 마지막 sDefaultDay 셀에 가산 (.cs L4071~4077)', () => {
    // 월합 101 → MON 2일 → 50, 나머지 1 → 마지막 월요일 51.
    const { acc, store } = makeAcc(cols, { [M('202401')]: 101 }, noBucket, monday);
    dispatchRecalc({
      acc,
      editedBinding: M('202401'),
      bucketType: BUCKET_TYPE.MONTHLY,
      divisionId: '81',
      measure: 'MKT_FCST',
      defaultBucketDow: dowIndexOfCode('MON'),
    });
    expect(store[D('20240101')]).toBe(50);
    expect(store[D('20240108')]).toBe(51); // 마지막 월요일에 나머지 가산
  });

  it('sDefaultDay=FRI 면 금요일에만 분배(월요일 고정 아님)', () => {
    const { acc, store } = makeAcc(cols, { [M('202401')]: 100 }, noBucket, monday);
    dispatchRecalc({
      acc,
      editedBinding: M('202401'),
      bucketType: BUCKET_TYPE.MONTHLY,
      divisionId: '81',
      measure: 'MKT_FCST',
      defaultBucketDow: dowIndexOfCode('FRI'), // 5
    });
    expect(store[D('20240105')]).toBe(50); // 첫 금요일
    expect(store[D('20240112')]).toBe(50); // 둘째 금요일
    expect(store[D('20240101')]).toBeNull(); // 월요일엔 배분되지 않는다
  });
});

describe('recalcMonthlyToDaily — 버킷 요일 존재 시엔 bMonthAll 미진입(버킷 분배)', () => {
  const cols = [
    M('202401'),
    W('20240101'),
    D('20240101'), // 월
    D('20240102'), // 화
    D('20240103'), // 수
    D('20240104'), // 목
    D('20240105'), // 금
    D('20240106'), // 토
    D('20240107'), // 일
    M('202402'),
  ];
  // bucket 에 화(idx2)·목(idx4) 허용. 0=일..6=토 → '0010100'.
  const tueThuBucket = '0010100';
  const monday = '20240101';

  it('버킷 허용 요일(화·목)에 분배 — sDefaultDay 무관', () => {
    // 월합 100 → 화·목 2일 → 50/50.
    const { acc, store } = makeAcc(cols, { [M('202401')]: 100 }, tueThuBucket, monday);
    dispatchRecalc({
      acc,
      editedBinding: M('202401'),
      bucketType: BUCKET_TYPE.MONTHLY,
      divisionId: '81',
      measure: 'MKT_FCST',
      defaultBucketDow: dowIndexOfCode('MON'), // bMonthAll 아니므로 무시돼야 함
    });
    expect(store[D('20240102')]).toBe(50); // 화
    expect(store[D('20240104')]).toBe(50); // 목
    expect(store[D('20240101')]).toBeNull(); // 월(버킷 비허용) clear
  });
});
