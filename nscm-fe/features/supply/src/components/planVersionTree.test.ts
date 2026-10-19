import { describe, expect, it } from 'vitest';

import { buildPlanVersionTree, type PlanVersionLevel } from './planVersionTree';

// 콤보 행(_SCP_ALL) — DATE: CODE=plan_start, TYPE: +PLANDATE, SEQ: +PLANDATE/PLANTYPE. 전량이라 DIVISION_ID 보유.
const dates = [
  { DIVISION_ID: '40', CODE: '20260810', NAME: '2026-08-10' },
  { DIVISION_ID: '40', CODE: '20260803', NAME: '2026-08-03' },
  { DIVISION_ID: '82', CODE: '20260810', NAME: '2026-08-10(82)' },
];
const types = [
  { DIVISION_ID: '40', PLANDATE: '20260810', CODE: 'TE', NAME: 'TE' },
  { DIVISION_ID: '40', PLANDATE: '20260810', CODE: 'FN', NAME: 'FN' },
  { DIVISION_ID: '40', PLANDATE: '20260803', CODE: 'MA', NAME: 'MA' },
  { DIVISION_ID: '82', PLANDATE: '20260810', CODE: 'MASS', NAME: 'MASS' },
];
const seqs = [
  { DIVISION_ID: '40', PLANDATE: '20260810', PLANTYPE: 'TE', CODE: '1', NAME: '1 - Confirm' },
  { DIVISION_ID: '40', PLANDATE: '20260810', PLANTYPE: 'TE', CODE: '2', NAME: '2' },
  { DIVISION_ID: '82', PLANDATE: '20260810', PLANTYPE: 'MASS', CODE: '1', NAME: '1' },
];

const threeLevels = (): PlanVersionLevel[] => [
  { name: 'planDate', label: 'Plan Date', rows: dates },
  { name: 'planType', label: 'Plan Type', rows: types, parentKeys: ['PLANDATE'] },
  { name: 'planSeq', label: 'Seq', rows: seqs, parentKeys: ['PLANDATE', 'PLANTYPE'] },
];

describe('buildPlanVersionTree (3단계)', () => {
  it('division 으로 거르고 date→type→seq 로 중첩한다', () => {
    const tree = buildPlanVersionTree(threeLevels(), '40');
    // div40 의 date 2건 (div82 제외)
    expect(tree.map(n => n.value)).toEqual(['20260810', '20260803']);
    // 20260810 의 type = TE/FN (PLANDATE 매칭, div82 MASS 제외)
    const d0810 = tree.find(n => n.value === '20260810');
    expect(d0810?.children?.map(n => n.value)).toEqual(['TE', 'FN']);
    // 20260810·TE 의 seq = 1/2
    const te = d0810?.children?.find(n => n.value === 'TE');
    expect(te?.children?.map(n => n.value)).toEqual(['1', '2']);
    // 20260803 의 type = MA, 그 seq 는 없음(빈 배열)
    const d0803 = tree.find(n => n.value === '20260803');
    expect(d0803?.children?.map(n => n.value)).toEqual(['MA']);
    expect(d0803?.children?.[0]?.children).toEqual([]);
  });

  it('label 은 NAME, 없으면 CODE', () => {
    const tree = buildPlanVersionTree(threeLevels(), '40');
    expect(tree[0]?.label).toBe('2026-08-10');
  });

  it('division 이 바뀌면 그 division 의 버전만 나온다', () => {
    const tree = buildPlanVersionTree(threeLevels(), '82');
    expect(tree.map(n => n.value)).toEqual(['20260810']);
    expect(tree[0]?.children?.map(n => n.value)).toEqual(['MASS']);
  });
});

describe('buildPlanVersionTree (2단계)', () => {
  it('seq 없이 date→type 2단계 트리를 만든다(잎 = type)', () => {
    const levels: PlanVersionLevel[] = [
      { name: 'planDate', label: 'Plan Date', rows: dates },
      { name: 'planType', label: 'Plan Type', rows: types, parentKeys: ['PLANDATE'] },
    ];
    const tree = buildPlanVersionTree(levels, '40');
    expect(tree.map(n => n.value)).toEqual(['20260810', '20260803']);
    const d0810 = tree.find(n => n.value === '20260810');
    // 마지막 단계는 children 을 만들지 않는다(잎).
    expect(d0810?.children?.map(n => n.value)).toEqual(['TE', 'FN']);
    expect(d0810?.children?.every(n => n.children === undefined)).toBe(true);
  });
});

describe('buildPlanVersionTree (divisionId 없음)', () => {
  it('divisionId 가 빈 값이면 전 division 을 통과시킨다', () => {
    const tree = buildPlanVersionTree(threeLevels(), '');
    // dedupe(first-wins) — 20260810 은 div40/div82 중복이라 1건
    expect(tree.map(n => n.value)).toEqual(['20260810', '20260803']);
    const d0810 = tree.find(n => n.value === '20260810');
    // division 필터 없으니 TE/FN(40) + MASS(82) 모두
    expect(d0810?.children?.map(n => n.value)).toEqual(['TE', 'FN', 'MASS']);
  });
});
