// DMF0021 Insert 위치 — "라인추가할 때 data Group 제일 위로 / 선택한 값의 병합한 데이터 위로"
//   (통합테스트 35번 + 2026-08-17 사용자 요구. DMF0082 ForecastPriceGridUtils 테스트 이식).
import { describe, expect, it } from 'vitest';

import type { SalesPlanRow } from '../sales-plan.types';

import {
  findGroupTopIndex,
  groupKeyBindings,
  mergeInsertedRows,
  type PendingInsert,
} from './sales-plan.insertAnchor';

/** 행 픽스처 — CRUD_TYPE 리터럴 좁힘을 피하려고 Record 로 받아 캐스팅한다. */
const row = (values: Record<string, unknown>): SalesPlanRow => values as SalesPlanRow;

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

describe('findGroupTopIndex — Insert 앵커(머지 블록 첫 행)', () => {
  const KEYS = ['DIVISION_ID', 'ITEM_ID', 'INCOTERMS'];
  /** 블록 A(DAP) 3행 + 블록 B(EXW) 3행 — measure 만 다른 전형적 구성. */
  const groupRows = (): SalesPlanRow[] =>
    [
      { DIVISION_ID: '40', ITEM_ID: 'MCCM349215A1', INCOTERMS: 'DAP', MEASURE: 'SalesAmt_LOC' },
      { DIVISION_ID: '40', ITEM_ID: 'MCCM349215A1', INCOTERMS: 'DAP', MEASURE: 'RTF_SYS_RP' },
      { DIVISION_ID: '40', ITEM_ID: 'MCCM349215A1', INCOTERMS: 'DAP', MEASURE: 'Catch_Up' },
      { DIVISION_ID: '40', ITEM_ID: 'MCCM349215A1', INCOTERMS: 'EXW', MEASURE: 'SalesAmt_LOC' },
      { DIVISION_ID: '40', ITEM_ID: 'MCCM349215A1', INCOTERMS: 'EXW', MEASURE: 'RTF_SYS_RP' },
      { DIVISION_ID: '40', ITEM_ID: 'MCCM349215A1', INCOTERMS: 'EXW', MEASURE: 'Catch_Up' },
    ].map(row);

  it('블록 중간을 찍어도 그 블록의 첫 행을 돌려준다', () => {
    expect(findGroupTopIndex(groupRows(), 2, KEYS)).toBe(0);
    expect(findGroupTopIndex(groupRows(), 5, KEYS)).toBe(3);
  });

  it('이미 첫 행이면 그대로', () => {
    expect(findGroupTopIndex(groupRows(), 0, KEYS)).toBe(0);
    expect(findGroupTopIndex(groupRows(), 3, KEYS)).toBe(3);
  });

  it('키가 하나라도 다르면 다른 블록 — INCOTERMS 경계를 넘지 않는다', () => {
    expect(findGroupTopIndex(groupRows(), 4, KEYS)).toBe(3);
  });

  // "선택한 값의 병합한 데이터 위로" — 왼쪽 컬럼(Model 등)을 누르면 그 병합 셀이 DAP/EXW 두 블록을
  //   덮으므로 EXW 중간을 찍었어도 0 까지 올라간다.
  it('왼쪽 컬럼 클릭(키에서 INCOTERMS 제외)은 두 블록을 합친 맨 위로 올라간다', () => {
    expect(findGroupTopIndex(groupRows(), 4, ['DIVISION_ID', 'ITEM_ID'])).toBe(0);
  });

  it('위쪽 신규행(CRUD_TYPE=I)에서 멈춘다 — 머지가 거기서 끊긴다', () => {
    const withInsert = [
      row({ DIVISION_ID: '40', ITEM_ID: 'MCCM349215A1', INCOTERMS: 'DAP', CRUD_TYPE: 'I' }),
      ...groupRows(),
    ];
    expect(findGroupTopIndex(withInsert, 3, KEYS)).toBe(1);
  });

  it('신규행에서 눌렀거나 키가 없으면 그 자리 그대로', () => {
    expect(findGroupTopIndex(groupRows(), 2, [])).toBe(2);
    expect(findGroupTopIndex([row({ CRUD_TYPE: 'I' })], 0, KEYS)).toBe(0);
    expect(findGroupTopIndex(groupRows(), -1, KEYS)).toBe(-1);
  });

  // DMF0082 와 다른 점: HierarchicalMergeManager 는 빈 값도 '' === '' 로 머지하므로
  //   빈 셀 블록도 정상 앵커다 (공용 CustomMergeManager 의 빈 셀 제외 규칙 없음).
  it('빈 값 컬럼도 블록을 이룬다', () => {
    const rows = [
      { DIVISION_ID: '40', INCOTERMS: '' },
      { DIVISION_ID: '40', INCOTERMS: '' },
      { DIVISION_ID: '40', INCOTERMS: 'DAP' },
    ].map(row);
    expect(findGroupTopIndex(rows, 1, ['DIVISION_ID', 'INCOTERMS'])).toBe(0);
    expect(findGroupTopIndex(rows, 2, ['DIVISION_ID', 'INCOTERMS'])).toBe(2);
  });
});

describe('mergeInsertedRows — 신규행을 앵커 바로 위에 끼운다', () => {
  const base = (): SalesPlanRow[] => [{ ITEM_ID: 'A' }, { ITEM_ID: 'B' }, { ITEM_ID: 'C' }].map(row);
  const ins = (id: string): SalesPlanRow => row({ CRUD_TYPE: 'I', INSERT_GROUP_ID: id });

  it('앵커 없으면 그리드 맨 위', () => {
    const rows = base();
    const n = ins('I_1');
    expect(mergeInsertedRows(rows, [{ row: n, anchor: null }])).toStrictEqual([n, ...rows]);
  });

  it('앵커 바로 위에 놓는다', () => {
    const rows = base();
    const n = ins('I_1');
    expect(mergeInsertedRows(rows, [{ row: n, anchor: rows[1] }])).toStrictEqual([
      rows[0],
      n,
      rows[1],
      rows[2],
    ]);
  });

  it('같은 앵커 연속 Insert = 누른 순서대로 위에서 아래로', () => {
    const rows = base();
    const first = ins('I_1');
    const second = ins('I_2');
    const pending: PendingInsert[] = [
      { row: first, anchor: rows[1] },
      { row: second, anchor: rows[1] },
    ];
    expect(mergeInsertedRows(rows, pending)).toStrictEqual([
      rows[0],
      first,
      second,
      rows[1],
      rows[2],
    ]);
  });

  it('신규행을 앵커로 잡은 신규행도 재귀로 펼친다', () => {
    const rows = base();
    const first = ins('I_1');
    const second = ins('I_2');
    const pending: PendingInsert[] = [
      { row: first, anchor: rows[2] },
      { row: second, anchor: first },
    ];
    expect(mergeInsertedRows(rows, pending)).toStrictEqual([
      rows[0],
      rows[1],
      second,
      first,
      rows[2],
    ]);
  });

  // 재조회로 앵커 객체 참조가 바뀌면 앵커가 유실된다 — 행이 증발하지 않게 맨 위로 폴백한다.
  it('유실된 앵커는 맨 위로 폴백 (행 증발 금지)', () => {
    const rows = base();
    const n = ins('I_1');
    const stale = row({ ITEM_ID: 'Z' });
    expect(mergeInsertedRows(rows, [{ row: n, anchor: stale }])).toStrictEqual([n, ...rows]);
  });

  it('신규행이 없으면 조회행 그대로', () => {
    const rows = base();
    expect(mergeInsertedRows(rows, [])).toStrictEqual(rows);
  });
});
