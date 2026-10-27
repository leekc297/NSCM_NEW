// SCP YN 'Y' 정확히 1건 검증 (사용자 요청 2026-10-14). 같은 Division+Plant+Parent 안에서 Y 인 Child 는 반드시 1개.
//   저장 SP 를 Division+Plant+Parent+Child 기준 UPDATE 로 바꾸는 전제(2026-10-15). Model 별 중복행은 Child 단위로 제거해 센다.
type Row = Record<string, unknown>;

const s = (v: unknown): string =>
  typeof v === 'string' ? v.trim() : typeof v === 'number' ? String(v) : '';

// 이전 기준(SP 가 Plant 무시하고 전 플랜트 반영하던 때): Division+Parent
// const parentKey = (r: Row) => `${s(r.DIVISION_ID)}|${s(r.PARENT_ITEM_ID)}`;
const parentKey = (r: Row) => `${s(r.DIVISION_ID)}|${s(r.PLANT_ID)}|${s(r.PARENT_ITEM_ID)}`;

// 위반 'Plant / Parent' 목록을 돌려준다. 변경행이 있는 Plant+Parent 만 검사(조회 범위 안의 행 기준).
export const findInvalidScpYnParents = (rows: Row[]): string[] => {
  const targets = new Set(rows.filter(r => r.CRUD_TYPE).map(parentKey));
  // Plant+Parent별 Child -> SCP YN. 변경행 값이 미변경 중복행(타 Model) 값보다 우선한다.
  const map = new Map<string, Map<string, { yn: string; dirty: boolean }>>();
  for (const r of rows) {
    const pk = parentKey(r);
    if (!targets.has(pk)) continue;
    const child = s(r.CHILD_ITEM_ID);
    const children = map.get(pk) ?? new Map<string, { yn: string; dirty: boolean }>();
    map.set(pk, children);
    const prev = children.get(child);
    const dirty = !!r.CRUD_TYPE;
    if (prev?.dirty && !dirty) continue;
    children.set(child, { yn: s(r.SCP_PLAN_YN).toUpperCase(), dirty });
  }
  const hits: string[] = [];
  for (const [pk, children] of map) {
    const yCount = [...children.values()].filter(c => c.yn === 'Y').length;
    // if (yCount !== 1) hits.push(pk.split('|')[1] ?? '');
    const [, plant = '', parent = ''] = pk.split('|');
    if (yCount !== 1) hits.push(`${plant}/${parent}`);
  }
  return hits;
};
