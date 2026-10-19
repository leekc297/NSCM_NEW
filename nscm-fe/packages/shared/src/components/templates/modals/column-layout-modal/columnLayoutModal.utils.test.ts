import { describe, expect, it } from 'vitest';

import type { ColumnLayoutRow } from '../../../molecules/columnLayoutList/ColumnLayoutList';

import {
  buildInitialRows,
  buildSavePayload,
  changeCellColor,
  deriveIsKey,
  overrideRows,
  parseWidth,
  reorderRows,
  serializeSavePayload,
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
  it('buildSavePayload: 숨김 컬럼(MEASURE)은 USER_FLAG 와 무관하게 항상 표시로 저장된다', () => {
    // 팝업 목록에 없어 사용자가 되살릴 수 없다 — 빠지면 titleSet(DELETE 후 INSERT)에서 영구 소실.
    const rows = [
      mk({ COLUMN_NAME: 'A', USER_FLAG: 'Y', SORT_ORDER_NO: 2 }),
      mk({ COLUMN_NAME: 'MEASURE', USER_FLAG: 'N', SORT_ORDER_NO: 0 }),
      mk({ COLUMN_NAME: 'B', USER_FLAG: 'Y', SORT_ORDER_NO: 1 }),
      mk({ COLUMN_NAME: 'C', USER_FLAG: 'N', SORT_ORDER_NO: 0 }),
    ];
    const out = buildSavePayload(rows, new Set(['MEASURE']));
    expect(out.map(r => [r.COLUMN_NAME, r.USER_FLAG, r.SORT_ORDER_NO])).toStrictEqual([
      ['B', 'Y', 1],
      ['A', 'Y', 2],
      ['MEASURE', 'Y', 3],
      ['C', 'N', 0],
    ]);
  });

  it('buildSavePayload: 숨김 컬럼의 옛 SORT_ORDER_NO 는 무시하고 항상 맨 뒤 (드래그 대상 아님)', () => {
    const rows = [
      mk({ COLUMN_NAME: 'MEASURE', USER_FLAG: 'Y', SORT_ORDER_NO: 1 }),
      mk({ COLUMN_NAME: 'A', USER_FLAG: 'Y', SORT_ORDER_NO: 5 }),
      mk({ COLUMN_NAME: 'B', USER_FLAG: 'Y', SORT_ORDER_NO: 9 }),
    ];
    expect(
      buildSavePayload(rows, new Set(['MEASURE'])).map(r => [r.COLUMN_NAME, r.SORT_ORDER_NO])
    ).toStrictEqual([
      ['A', 1],
      ['B', 2],
      ['MEASURE', 3],
    ]);
  });

  it('deriveIsKey 는 USER_SELECTABLE_FLAG=N 일 때만 true (라벨 * 무관)', () => {
    expect(deriveIsKey({ USER_SELECTABLE_FLAG: 'N' })).toBe(true);
    expect(deriveIsKey({ USER_SELECTABLE_FLAG: 'Y' })).toBe(false);
    // 값 미제공 = 변경 가능 / 라벨의 '*' 는 판정에 쓰지 않는다
    expect(deriveIsKey({})).toBe(false);
    expect(deriveIsKey({ COLUMN_LABEL_NAME: 'Division*' })).toBe(false);
  });

  it('parseWidth: 빈값/무효는 fallback, 음수는 0, 정상은 정수', () => {
    expect(parseWidth('', 14)).toBe(14);
    expect(parseWidth('abc', 14)).toBe(14);
    expect(parseWidth('-5', 14)).toBe(0);
    expect(parseWidth('25', 14)).toBe(25);
  });

  it('buildInitialRows: fallback 매핑 — isKey/USER_FLAG 는 플래그 기준 (라벨 * 무관)', () => {
    const rows = buildInitialRows(
      [],
      [{ key: 'DIV', header: 'Division*', width: 14, personalizable: false }]
    );
    expect(rows).toHaveLength(1);
    expect(rows[0]).toMatchObject({
      COLUMN_NAME: 'DIV',
      COLUMN_LABEL_NAME: 'Division*',
      USER_FLAG: 'Y',
      COL_WIDTH: 14,
      isKey: true,
    });
    // 라벨에 '*' 가 있어도 플래그가 없으면 고정 아님, display=false 면 좌측(N)
    const plain = buildInitialRows([], [{ key: 'T', header: 'Text*', display: false }]);
    expect(plain[0]).toMatchObject({ USER_FLAG: 'N', isKey: false });
  });

  it('buildInitialRows: USER_FLAG 부재 시 DEFAULT_FLAG 로 좌/우 배치 (VISIBLE_FLAG 폴백 금지)', () => {
    const be: Record<string, string>[] = [
      { COLUMN_NAME: 'A', COLUMN_LABEL_NAME: 'A*', VISIBLE_FLAG: 'Y', DEFAULT_FLAG: 'N' },
      { COLUMN_NAME: 'B', COLUMN_LABEL_NAME: 'B', VISIBLE_FLAG: 'Y', DEFAULT_FLAG: 'Y' },
      // 저장된 사용자값이 있으면 그게 우선
      { COLUMN_NAME: 'C', COLUMN_LABEL_NAME: 'C', USER_FLAG: 'Y', DEFAULT_FLAG: 'N' },
    ];
    expect(buildInitialRows(be, []).map(r => r.USER_FLAG)).toStrictEqual(['N', 'Y', 'Y']);
  });

  it('buildInitialRows: isKey 는 USER_SELECTABLE_FLAG 에서만 온다', () => {
    const be: Record<string, string>[] = [
      { COLUMN_NAME: 'A', COLUMN_LABEL_NAME: 'Div*', USER_SELECTABLE_FLAG: 'Y' },
      { COLUMN_NAME: 'B', COLUMN_LABEL_NAME: 'Team', USER_SELECTABLE_FLAG: 'N' },
    ];
    expect(buildInitialRows(be, []).map(r => r.isKey)).toStrictEqual([false, true]);
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

  it('overrideRows: 고정 컬럼(isKey)도 표시 여부는 덮어쓴다 (Default 원복이 admin 기준이어야 함)', () => {
    const base = [mk({ COLUMN_NAME: 'K', isKey: true, USER_FLAG: 'Y' })];
    const next = overrideRows(base, [mk({ COLUMN_NAME: 'K', USER_FLAG: 'N' })]);
    expect(next[0].USER_FLAG).toBe('N');
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
      {
        colNm: 'DIV',
        colLblNm: 'Division*',
        colWth: 14,
        cellColor: '#FF0000',
        personalizable: false,
      },
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
    // visible=false → 'N', colWth 미지정 → DEFAULT_COL_WIDTH, personalizable 미지정 = 고정 아님
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

  it('toHiddenColumnSet: visible=false 또는 폭 0 인 컬럼만 목록에서 뺀다', () => {
    const hidden = toHiddenColumnSet([
      { colNm: 'A', visible: false, colWth: 100 },
      { colNm: 'B', colWth: 0 },
      // SP 가 문자열로 내려주는 경우
      { colNm: 'C', colWth: '0' as unknown as number },
      { colNm: 'D', colWth: 100 },
      // 폭 미제공은 제외하지 않는다 (메타에 폭이 없는 화면 방어)
      { colNm: 'E' },
      // display=false 는 '기본 미표시' 일 뿐 — 좌측 목록에 남아야 한다
      { colNm: 'F', display: false, colWth: 80 },
    ]);
    expect([...hidden].sort()).toEqual(['A', 'B', 'C']);
  });

  it('serializeSavePayload: 값(표시/순서/폭/색) 같으면 배열 순서 달라도 동일 문자열 (무변경 판정)', () => {
    // buildSavePayload 를 거친 두 payload — 배열 순서만 다르고 값은 같다 → 저장할 변경 없음.
    const a = buildSavePayload(
      [
        mk({ COLUMN_NAME: 'A', USER_FLAG: 'Y', SORT_ORDER_NO: 1 }),
        mk({ COLUMN_NAME: 'B', USER_FLAG: 'Y', SORT_ORDER_NO: 2 }),
        mk({ COLUMN_NAME: 'C', USER_FLAG: 'N', SORT_ORDER_NO: 0 }),
      ],
      new Set()
    );
    const b = buildSavePayload(
      [
        mk({ COLUMN_NAME: 'C', USER_FLAG: 'N', SORT_ORDER_NO: 0 }),
        mk({ COLUMN_NAME: 'B', USER_FLAG: 'Y', SORT_ORDER_NO: 2 }),
        mk({ COLUMN_NAME: 'A', USER_FLAG: 'Y', SORT_ORDER_NO: 1 }),
      ],
      new Set()
    );
    expect(serializeSavePayload(a)).toBe(serializeSavePayload(b));
  });

  it('serializeSavePayload: 표시 순서/폭/색 중 하나라도 바뀌면 다른 문자열 (변경 판정)', () => {
    const base = [
      mk({ COLUMN_NAME: 'A', USER_FLAG: 'Y', SORT_ORDER_NO: 1, COL_WIDTH: 100 }),
      mk({ COLUMN_NAME: 'B', USER_FLAG: 'Y', SORT_ORDER_NO: 2 }),
    ];
    const s0 = serializeSavePayload(buildSavePayload(base, new Set()));
    // 순서 바꿈
    expect(serializeSavePayload(buildSavePayload(reorderRows(base, ['B', 'A']), new Set()))).not.toBe(
      s0
    );
    // 폭 바꿈
    expect(
      serializeSavePayload(buildSavePayload(changeCellColor(base, 'A', '#FF0000'), new Set()))
    ).not.toBe(s0);
    // 표시 토글
    expect(serializeSavePayload(buildSavePayload(toggleDisplay(base, 'B'), new Set()))).not.toBe(s0);
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
