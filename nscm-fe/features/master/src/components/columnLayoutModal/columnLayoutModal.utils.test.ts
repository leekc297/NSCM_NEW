import { describe, expect, it } from 'vitest';

import type { ColumnLayoutRow } from '@shared/components';

import {
  buildInitialRows,
  changeCellColor,
  deriveIsKey,
  overrideRows,
  parseWidth,
  reorderRows,
  toAllowedColumnSet,
  toColumnLayoutSettings,
  toggleDisplay,
  toHiddenColumnSet,
} from './columnLayoutModal.utils';

const mk = (over: Partial<ColumnLayoutRow>): ColumnLayoutRow => ({
  COLUMN_NAME: 'X',
  COLUMN_LABEL_NAME: 'X',
  USER_FLAG: 'Y',
  SORT_ORDER_NO: 1,
  COL_WIDTH: 100,
  CELL_COLOR: '',
  TEXT_COLOR: '',
  isKey: false,
  ...over,
});

describe('columnLayoutModal.utils', () => {
  it('deriveIsKey 는 라벨이 * 로 끝날 때만 true', () => {
    expect(deriveIsKey('Division*')).toBe(true);
    expect(deriveIsKey('Team')).toBe(false);
  });

  it('parseWidth: 빈값/무효는 fallback, 음수는 0, 정상은 정수', () => {
    expect(parseWidth('', 14)).toBe(14);
    expect(parseWidth('abc', 14)).toBe(14);
    expect(parseWidth('-5', 14)).toBe(0);
    expect(parseWidth('25', 14)).toBe(25);
  });

  it('buildInitialRows: fallback 매핑 + isKey 파생', () => {
    const rows = buildInitialRows([], [{ key: 'DIV', header: 'Division*', width: 14 }]);
    expect(rows).toHaveLength(1);
    expect(rows[0]).toMatchObject({
      COLUMN_NAME: 'DIV',
      COLUMN_LABEL_NAME: 'Division*',
      USER_FLAG: 'Y',
      COL_WIDTH: 14,
      isKey: true,
    });
  });

  it('buildInitialRows: BE(DB) 값이 initialSettings 보다 우선', () => {
    const be: Record<string, string>[] = [
      { COLUMN_NAME: 'A', COLUMN_LABEL_NAME: 'A', USER_FLAG: 'Y' },
      {
        COLUMN_NAME: 'B',
        COLUMN_LABEL_NAME: 'B',
        USER_FLAG: 'N',
        COLUMN_WIDTH: '55',
        CELL_COLOR: '#00FF00',
      },
    ];
    const init: ColumnLayoutRow[] = [
      mk({ COLUMN_NAME: 'B', USER_FLAG: 'Y', COL_WIDTH: 30, CELL_COLOR: '#FF0000' }),
    ];
    const b = buildInitialRows(be, [], init).find(r => r.COLUMN_NAME === 'B')!;
    expect(b.USER_FLAG).toBe('N');
    expect(b.COL_WIDTH).toBe(55);
    expect(b.CELL_COLOR).toBe('#00FF00');
  });

  it('buildInitialRows: BE 가 안 준 필드만 initialSettings 로 보완', () => {
    // COLUMN_WIDTH/CELL_COLOR 미제공(BE 미확장 상태) → 화면 상태 값으로 채운다.
    const be = [{ COLUMN_NAME: 'B', COLUMN_LABEL_NAME: 'B', USER_FLAG: 'Y' }];
    const init: ColumnLayoutRow[] = [
      mk({ COLUMN_NAME: 'B', COL_WIDTH: 30, CELL_COLOR: '#FF0000', TEXT_COLOR: '#0000FF' }),
    ];
    const b = buildInitialRows(be, [], init)[0];
    expect(b.USER_FLAG).toBe('Y'); // BE 값 유지
    expect(b.COL_WIDTH).toBe(30);
    expect(b.CELL_COLOR).toBe('#FF0000');
    expect(b.TEXT_COLOR).toBe('#0000FF');
  });

  it('buildInitialRows: SP 가 숫자로 내려주는 필드도 처리 (string 전제 .trim() TypeError 회귀)', () => {
    // 실제 SP 응답은 COLUMN_WIDTH/SORT_ORDER_NO 를 number 로 준다.
    const be = [
      { COLUMN_NAME: 'B', COLUMN_LABEL_NAME: 'B', USER_FLAG: 'Y', COLUMN_WIDTH: 55 },
    ] as unknown as Record<string, string>[];
    const init: ColumnLayoutRow[] = [mk({ COLUMN_NAME: 'B', COL_WIDTH: 30 })];
    expect(() => buildInitialRows(be, [], init)).not.toThrow();
    expect(buildInitialRows(be, [], init)[0].COL_WIDTH).toBe(55);
  });

  it('buildInitialRows: USER_COLUMN_WIDTH/USER_SORT_ORDER_NO(사용자값)가 관리자 기본값보다 우선', () => {
    // SP 는 관리자 기본(COLUMN_WIDTH=80/SORT_ORDER_NO=2)과 사용자 저장값(100/1)을 함께 내려준다.
    const be = [
      {
        COLUMN_NAME: 'TEAM_ID',
        COLUMN_LABEL_NAME: 'Team',
        USER_FLAG: 'Y',
        COLUMN_WIDTH: 80,
        USER_COLUMN_WIDTH: 100,
        SORT_ORDER_NO: 2,
        USER_SORT_ORDER_NO: 1,
      },
    ] as unknown as Record<string, string>[];
    const row = buildInitialRows(be, [])[0];
    expect(row.COL_WIDTH).toBe(100);
    expect(row.SORT_ORDER_NO).toBe(1);
  });

  it('buildInitialRows: 사용자 별칭이 없으면 관리자 기본값으로 폴백', () => {
    const be = [
      { COLUMN_NAME: 'A', COLUMN_LABEL_NAME: 'A', USER_FLAG: 'Y', COLUMN_WIDTH: 80 },
    ] as unknown as Record<string, string>[];
    expect(buildInitialRows(be, [])[0].COL_WIDTH).toBe(80);
  });

  it('overrideRows: settings 를 강제로 덮어쓴다 (Default 원복 경로)', () => {
    const base = [mk({ COLUMN_NAME: 'B', USER_FLAG: 'Y', COL_WIDTH: 55, CELL_COLOR: '#00FF00' })];
    const next = overrideRows(base, [
      mk({ COLUMN_NAME: 'B', USER_FLAG: 'N', COL_WIDTH: 30, CELL_COLOR: '' }),
    ]);
    expect(next[0].USER_FLAG).toBe('N');
    expect(next[0].COL_WIDTH).toBe(30);
    expect(next[0].CELL_COLOR).toBe('');
  });

  it('overrideRows: key 컬럼은 항상 표시 유지', () => {
    const base = [mk({ COLUMN_NAME: 'K', isKey: true, USER_FLAG: 'Y' })];
    const next = overrideRows(base, [mk({ COLUMN_NAME: 'K', USER_FLAG: 'N' })]);
    expect(next[0].USER_FLAG).toBe('Y');
  });

  it('toggleDisplay: key 행은 항상 Y 유지, 비-key 는 토글', () => {
    const rows = [mk({ COLUMN_NAME: 'K', isKey: true }), mk({ COLUMN_NAME: 'N', USER_FLAG: 'Y' })];
    const afterKey = toggleDisplay(rows, 'K');
    expect(afterKey.find(r => r.COLUMN_NAME === 'K')!.USER_FLAG).toBe('Y');
    const afterN = toggleDisplay(rows, 'N');
    expect(afterN.find(r => r.COLUMN_NAME === 'N')!.USER_FLAG).toBe('N');
  });

  it('changeCellColor: 해당 key 만 변경', () => {
    const rows = [mk({ COLUMN_NAME: 'A' }), mk({ COLUMN_NAME: 'B' })];
    const next = changeCellColor(rows, 'A', '#00FF00');
    expect(next.find(r => r.COLUMN_NAME === 'A')!.CELL_COLOR).toBe('#00FF00');
    expect(next.find(r => r.COLUMN_NAME === 'B')!.CELL_COLOR).toBe('');
  });

  it('toColumnLayoutSettings: grid 메타의 colWth/visible/색상을 그대로 옮기고 배열 순서를 SORT_ORDER_NO 로', () => {
    const rows = toColumnLayoutSettings([
      { colNm: 'DIV', colLblNm: 'Division*', colWth: 14, cellColor: '#FF0000' },
      { colNm: 'TEAM', colLblNm: 'Team', visible: false },
    ]);
    expect(rows[0]).toStrictEqual({
      COLUMN_NAME: 'DIV',
      COLUMN_LABEL_NAME: 'Division*',
      USER_FLAG: 'Y',
      SORT_ORDER_NO: 1,
      COL_WIDTH: 14,
      CELL_COLOR: '#FF0000',
      TEXT_COLOR: '',
      isKey: true,
    });
    // visible=false → 'N', colWth 미지정 → DEFAULT_COL_WIDTH, '*' 없으면 key 아님
    expect(rows[1]).toMatchObject({
      SORT_ORDER_NO: 2,
      USER_FLAG: 'N',
      COL_WIDTH: 100,
      isKey: false,
    });
  });

  it('toColumnLayoutSettings: display=false 도 미표시로 본다 (Default 과다 노출 회귀)', () => {
    const rows = toColumnLayoutSettings([
      { colNm: 'A', colLblNm: 'A', visible: true, display: false },
      { colNm: 'B', colLblNm: 'B', visible: true, display: true },
      { colNm: 'C', colLblNm: 'C' }, // 두 플래그 미제공 = 표시
    ]);
    expect(rows.map(r => r.USER_FLAG)).toStrictEqual(['N', 'Y', 'Y']);
  });

  it('reorderRows: orderedKeys 순서대로 SORT_ORDER_NO 재부여', () => {
    const rows = [
      mk({ COLUMN_NAME: 'A', SORT_ORDER_NO: 1 }),
      mk({ COLUMN_NAME: 'B', SORT_ORDER_NO: 2 }),
    ];
    const next = reorderRows(rows, ['B', 'A']);
    expect(next.find(r => r.COLUMN_NAME === 'B')!.SORT_ORDER_NO).toBe(1);
    expect(next.find(r => r.COLUMN_NAME === 'A')!.SORT_ORDER_NO).toBe(2);
  });
});

describe('toHiddenColumnSet / toAllowedColumnSet (division 스코프 메타 필터)', () => {
  const meta = [
    { colNm: 'DIVISION_ID', visible: true },
    { colNm: 'PROJECT_CODE', visible: true },
    { colNm: 'HIDDEN_COL', visible: false },
    { colNm: 'NO_FLAG_COL' }, // visible 미제공 — 제외 금지
  ];

  it('toHiddenColumnSet: visible === false 만 담는다', () => {
    expect([...toHiddenColumnSet(meta)]).toEqual(['HIDDEN_COL']);
  });

  it('toAllowedColumnSet: 메타 등재 컬럼 전부 (visible 무관 — 숨김 판정은 hidden 이 담당)', () => {
    const allowed = toAllowedColumnSet(meta)!;
    expect(allowed.has('PROJECT_CODE')).toBe(true);
    expect(allowed.has('NO_FLAG_COL')).toBe(true);
    // division 미등록 컬럼(메타에 없음) — DMF0082 div 40 의 PROJECT_CODE 계보 재현
    expect(allowed.has('CELL_QUANTITY')).toBe(false);
  });

  it('toAllowedColumnSet: 메타 0건 = null (필터 no-op — 목록 전멸 방지)', () => {
    expect(toAllowedColumnSet([])).toBeNull();
  });
});
