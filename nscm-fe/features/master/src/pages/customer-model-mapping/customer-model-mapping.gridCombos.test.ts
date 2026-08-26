import { describe, expect, it } from 'vitest';

import { buildTeamDataMap } from './customer-model-mapping.gridCombos';

// 메타 콤보('DeptId') — 표시 원천. 조회행에는 지금 division 밖 팀도 섞여 온다.
const DISPLAY = [
  { CODE: 'T01', NAME: '81 1팀', DIVISION_ID: '81' },
  { CODE: 'T02', NAME: '81 2팀', DIVISION_ID: '81' },
  { CODE: 'T40', NAME: '40 팀', DIVISION_ID: '40' },
];
// 신규행 후보 콤보 — 그 division 으로 좁혀진 목록. T99 는 표시 콤보에 없는 코드.
const INSERT = [
  { CODE: 'T01', NAME: 'DIV81 1팀', DIVISION_ID: '81' },
  { CODE: 'T99', NAME: '신설팀', DIVISION_ID: '81' },
];

const insertRow = { CRUD_TYPE: 'I', DIVISION_ID: '81' };
const searchedRow = { DIVISION_ID: '81' };

describe('buildTeamDataMap (Team 표시 = 메타 콤보 / 신규행 후보 = TeamByDivision)', () => {
  it('양쪽 다 0건이면 맵을 만들지 않는다 (컬럼 콤보 미부착)', () => {
    expect(buildTeamDataMap([], [])).toBeNull();
  });

  it('표시명은 메타 콤보가 이긴다 — 같은 CODE 가 후보 콤보에도 있어도 바뀌지 않는다', () => {
    const dataMap = buildTeamDataMap(DISPLAY, INSERT);
    expect(dataMap?.getDisplayValue('T01')).toBe('81 1팀');
  });

  it('후보 콤보에만 있는 코드도 이름으로 표시된다 (superset — 신규행 커밋값 되돌리기용)', () => {
    const dataMap = buildTeamDataMap(DISPLAY, INSERT);
    expect(dataMap?.getDisplayValue('T99')).toBe('신설팀');
    // 드롭다운에서 고른 이름을 코드로 되돌리는 경로도 같은 컬렉션을 쓴다.
    expect(dataMap?.getKeyValue('신설팀')).toBe('T99');
  });

  it('신규행 후보는 TeamByDivision 목록이다 (라벨은 표시 콤보 이름 체계)', () => {
    const dataMap = buildTeamDataMap(DISPLAY, INSERT);
    expect(dataMap?.getDisplayValues(insertRow)).toEqual(['81 1팀', '신설팀']);
  });

  it('조회행 후보는 메타 콤보 목록이다', () => {
    const dataMap = buildTeamDataMap(DISPLAY, INSERT);
    expect(dataMap?.getDisplayValues(searchedRow)).toEqual(['81 1팀', '81 2팀', '40 팀']);
  });

  it('조회행은 메타 ATTRIBUTE2 cascade 를 그대로 지킨다', () => {
    const dataMap = buildTeamDataMap(DISPLAY, INSERT, 'DIVISION_ID:DIVISION_ID');
    expect(dataMap?.getDisplayValues(searchedRow)).toEqual(['81 1팀', '81 2팀']);
  });

  it('후보 콤보가 0건이면 신규행도 메타 콤보를 쓴다 (드롭다운이 비어 굳지 않게)', () => {
    const dataMap = buildTeamDataMap(DISPLAY, []);
    expect(dataMap?.getDisplayValues(insertRow)).toEqual(['81 1팀', '81 2팀', '40 팀']);
  });

  it('CODE 별칭이 없는 응답은 버린다 — 빈 항목이 후보에 섞이지 않는다', () => {
    // 콤보 SQL 이 CODE/NAME 이 아닌 별칭으로 내려주는 경우. 그대로 담으면 DataMap 이 키 없는
    //   항목을 만들어 드롭다운에 빈 줄만 늘어선다(실측 getDisplayValues() === [null, null]).
    const aliasMismatch = [
      { DEPT_ID: 'T01', DEPT_NAME: '1팀' },
      { DEPT_ID: 'T99', DEPT_NAME: '신설팀' },
    ] as unknown as typeof INSERT;

    const dataMap = buildTeamDataMap(DISPLAY, aliasMismatch);
    // 후보 콤보가 통째로 버려져 표시 콤보로 폴백한다.
    expect(dataMap?.getDisplayValues(insertRow)).toEqual(['81 1팀', '81 2팀', '40 팀']);
    // 양쪽 다 쓸 수 없으면 맵 자체를 만들지 않는다(컬럼 콤보 미부착).
    expect(buildTeamDataMap(aliasMismatch, aliasMismatch)).toBeNull();
  });
});
