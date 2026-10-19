// DMF0021 Insert 위치 — "라인추가할 때 data Group 제일 위로 / 선택한 값의 병합한 데이터 위로"
//   (통합테스트 35번 + 2026-08-17 사용자 요구. DMF0082 ForecastPriceGridUtils 테스트 이식).
//   findGroupTopIndex/mergeInsertedRows/PendingInsert 는 GridAction.addRowSet 로 대체돼
//   packages/foundation/src/utils/gridAction.test.ts 로 계약이 이관됐다 — 이 파일에는
//   화면 고유 로직으로 남는 groupKeyBindings 만 남긴다.
import { describe, expect, it } from 'vitest';

import { groupKeyBindings } from './sales-plan.insertAnchor';

/** 그리드 표시 순서 픽스처 — Sales Site(3) < Model(5) < Incoterms(7) < MEASURE(8). */
const col = (binding: string, visible = true) => ({ binding, visible });
const COLUMNS = [
  col('DIVISION_ID'),
  col('DEPT_ID'),
  col('END_CUSTOMER'),
  col('SCM_SITE_ID'),
  col('PROJECT_CODE'),
  col('ITEM_ID'),
  col('NICK_NAME'),
  col('INCOTERMS'),
  col('MEASURE'),
  col('M_202608'),
  col('W_20260833'),
  col('D_20260803'),
];
const DATA_GROUP = [
  'DIVISION_ID',
  'DEPT_ID',
  'END_CUSTOMER',
  'SCM_SITE_ID',
  'PROJECT_CODE',
  'ITEM_ID',
  'NICK_NAME',
  'INCOTERMS',
];

describe('groupKeyBindings — 머지 범위 키 컬럼 (계층형 머지 0~클릭컬럼)', () => {
  it('Sales Site(3) 클릭 = 0~3 — 그 오른쪽 Model/Incoterms 는 범위를 좁히지 않는다', () => {
    expect(groupKeyBindings(COLUMNS, 3)).toStrictEqual([
      'DIVISION_ID',
      'DEPT_ID',
      'END_CUSTOMER',
      'SCM_SITE_ID',
    ]);
  });

  it('오른쪽 컬럼을 누를수록 범위가 좁아진다 — Model(5) < Incoterms(7)', () => {
    expect(groupKeyBindings(COLUMNS, 5)).toHaveLength(6);
    expect(groupKeyBindings(COLUMNS, 7)).toHaveLength(8);
  });

  it('MEASURE·동적 기간 컬럼·범위 밖 인덱스는 data Group 으로 폴백', () => {
    expect(groupKeyBindings(COLUMNS, 8)).toStrictEqual(DATA_GROUP); // MEASURE
    expect(groupKeyBindings(COLUMNS, 10)).toStrictEqual(DATA_GROUP); // W_ 동적 컬럼
    expect(groupKeyBindings(COLUMNS, -1)).toStrictEqual(DATA_GROUP); // 선택 없음
    expect(groupKeyBindings(COLUMNS, 99)).toStrictEqual(DATA_GROUP);
  });

  it('비표시 컬럼은 키에서 뺀다 — 화면에 없는 컬럼은 머지에도 참여하지 않는다', () => {
    const withHidden = [col('DIVISION_ID'), col('B_HIDDEN', false), col('SCM_SITE_ID')];
    expect(groupKeyBindings(withHidden, 2)).toStrictEqual(['DIVISION_ID', 'SCM_SITE_ID']);
  });

  it('비표시 컬럼을 클릭 축으로 넘기면 폴백 — 병합 자체가 없다', () => {
    const withHidden = [col('DIVISION_ID'), col('B_HIDDEN', false), col('MEASURE')];
    expect(groupKeyBindings(withHidden, 1)).toStrictEqual(['DIVISION_ID']);
  });
});
