import { DataType } from '@mescius/wijmo';
import { CellRange, FlexGrid, type DataMap } from '@mescius/wijmo.grid';
import { describe, expect, it } from 'vitest';

import { CELL_CONTROL_TYPE, CRUD_TYPE } from '@foundation/constants';
import type {
  ComboResponse,
  FlexGridColumnConfig,
  RawFlexGridColumnConfig,
} from '@foundation/models';

import {
  findStaleComboCells,
  findStaleRowParamComboCells,
  normalizeDynamicColumns,
  hasRequiredMark,
  mapRawColumnsToWijmoColumns,
  rowParamKey,
  rowParamValues,
  stripRequiredMark,
} from './columnMapping';

const col = (c: Partial<RawFlexGridColumnConfig>): RawFlexGridColumnConfig => ({
  colNm: 'A',
  colLblNm: 'A',
  display: true,
  ...c,
});

describe('필수표시(*) 정규화', () => {
  it('라벨 끝 * 를 감지한다 (뒤 공백 허용)', () => {
    expect(hasRequiredMark('End Customer*')).toBe(true);
    expect(hasRequiredMark('End Customer* ')).toBe(true);
    expect(hasRequiredMark('End Customer')).toBe(false);
    expect(hasRequiredMark('A*B')).toBe(false); // 끝이 아니면 라벨의 일부
    expect(hasRequiredMark(undefined)).toBe(false);
  });

  it('라벨 끝 * 만 떼어낸다', () => {
    expect(stripRequiredMark('End Customer*')).toBe('End Customer');
    expect(stripRequiredMark('Sales Site *')).toBe('Sales Site');
    expect(stripRequiredMark('A*B')).toBe('A*B');
    expect(stripRequiredMark(undefined)).toBe('');
  });

  it('leaf 헤더에서 * 를 떼고 _requiredMark 로 옮긴다', () => {
    const [mapped] = mapRawColumnsToWijmoColumns([
      col({ colNm: 'END_CUSTOMER', colLblNm: 'End Customer*' }),
    ]);

    expect(mapped.header).toBe('End Customer');
    expect(mapped._requiredMark).toBe(true);
  });

  it('* 없는 컬럼은 _requiredMark 가 false 다', () => {
    const [mapped] = mapRawColumnsToWijmoColumns([col({ colNm: 'TEAM', colLblNm: 'Team' })]);

    expect(mapped.header).toBe('Team');
    expect(mapped._requiredMark).toBe(false);
  });

  it('_inputEditType 은 승격하지 않는다 (편집가능 판정 입력이라 건드리면 안 된다)', () => {
    const [mapped] = mapRawColumnsToWijmoColumns([
      col({
        colNm: 'MODEL',
        colLblNm: 'Model*',
        inputTpCd: 'S' as RawFlexGridColumnConfig['inputTpCd'],
      }),
    ]);

    expect(mapped._inputEditType).toBe('S');
    expect(mapped._requiredMark).toBe(true);
  });

  it('그룹 라벨도 같이 벗겨 그룹이 쪼개지지 않는다', () => {
    const mapped = mapRawColumnsToWijmoColumns([
      col({ colNm: 'QTY', colLblNm: 'Qty*', sClsLblNm: 'Price*' }),
      col({ colNm: 'AMT', colLblNm: 'Amt', sClsLblNm: 'Price*' }),
    ]);

    expect(mapped).toHaveLength(1);
    expect(mapped[0].header).toBe('Price');
    expect(mapped[0].columns?.map(c => c.header)).toEqual(['Qty', 'Amt']);
    expect(mapped[0].columns?.map(c => c._requiredMark)).toEqual([true, false]);
  });
});

describe('동적 컬럼 Delete 키 허용(isRequired 기본값)', () => {
  it('3단 중첩 leaf 에 isRequired:false 를 채운다', () => {
    const [ym] = normalizeDynamicColumns([
      {
        header: '2026-08',
        columns: [{ header: 'W31', columns: [{ header: '0803', binding: 'W_20260803' }] }],
      },
    ]);

    expect(ym.columns?.[0].columns?.[0].isRequired).toBe(false);
  });

  it('명시 지정한 isRequired 는 존중한다', () => {
    const [leaf] = normalizeDynamicColumns([{ header: 'QTY', binding: 'QTY', isRequired: true }]);

    expect(leaf.isRequired).toBe(true);
  });

  it('원본 배열/객체를 변형하지 않는다', () => {
    const source: FlexGridColumnConfig[] = [{ header: '0803', binding: 'W_20260803' }];
    normalizeDynamicColumns(source);

    expect(source[0].isRequired).toBeUndefined();
  });

  // 증상 회귀 테스트 — 실제 FlexGrid 에 Delete 키를 눌러 값이 비는지 확인한다.
  //   (isRequired 플래그만 보면 Wijmo 내부 규칙이 바뀌었을 때 놓친다.)
  const pressDeleteOn = (columnGroups: FlexGridColumnConfig[], items: WijmoRowItem[]) => {
    const host = document.createElement('div');
    document.body.appendChild(host);
    const grid = new FlexGrid(host, {
      autoGenerateColumns: false,
      columnGroups: columnGroups as never,
      itemsSource: items,
    });
    grid.select(new CellRange(0, 0), false);
    grid.hostElement.dispatchEvent(
      new KeyboardEvent('keydown', { key: 'Delete', keyCode: 46, bubbles: true } as never)
    );
  };

  const weekColumns: FlexGridColumnConfig[] = [
    {
      header: '2026-08',
      columns: [
        {
          header: 'W31',
          columns: [{ header: '0803', binding: 'W_20260803', format: 'n3', width: 90 }],
        },
      ],
    },
  ];

  it('보정 전에는 Delete 가 숫자 셀을 비우지 못한다', () => {
    const items = [{ W_20260803: 122500 }];
    pressDeleteOn(weekColumns, items);

    expect(items[0].W_20260803).toBe(122500);
  });

  it('보정 후에는 Delete 가 숫자 셀을 비운다', () => {
    const items = [{ W_20260803: 122500 }];
    pressDeleteOn(normalizeDynamicColumns(weekColumns), items);

    expect(items[0].W_20260803).toBeNull();
  });
});

describe('동적 컬럼 숫자 dataType 보정', () => {
  const leafOf = (columns: FlexGridColumnConfig[]) =>
    normalizeDynamicColumns(columns)[0].columns?.[0].columns?.[0];

  const weekLeaf = (format?: string): FlexGridColumnConfig[] => [
    {
      header: '2026-08',
      columns: [{ header: 'W31', columns: [{ header: '0803', binding: 'W_20260803', format }] }],
    },
  ];

  it('숫자 서식(n3) leaf 에 dataType=Number 를 채운다', () => {
    expect(leafOf(weekLeaf('n3'))?.dataType).toBe(DataType.Number);
  });

  it('자리표시자 숫자 패턴에도 채운다', () => {
    expect(leafOf(weekLeaf('#,##0.###'))?.dataType).toBe(DataType.Number);
  });

  it('format 이 없거나 날짜 서식이면 채우지 않는다', () => {
    expect(leafOf(weekLeaf())?.dataType).toBeUndefined();
    expect(leafOf(weekLeaf('yyyy-MM-dd'))?.dataType).toBeUndefined();
    expect(leafOf(weekLeaf('d'))?.dataType).toBeUndefined();
  });

  it('명시 지정한 dataType 은 존중한다', () => {
    const [leaf] = normalizeDynamicColumns([
      { header: 'QTY', binding: 'QTY', format: 'n3', dataType: DataType.String },
    ]);

    expect(leaf.dataType).toBe(DataType.String);
  });

  it('그룹 헤더에는 채우지 않는다', () => {
    const [group] = normalizeDynamicColumns(weekLeaf('n3'));

    expect(group.dataType).toBeUndefined();
  });

  // 증상 회귀 — 빈 셀에 입력하면 문자열이 아니라 숫자로 저장되어야 한다.
  //   (Wijmo 는 dataType 미지정 시 items[0] 로만 타입을 추론해, 첫 행이 비면 Object 로 남는다.)
  const typeIntoFirstCell = (columnGroups: FlexGridColumnConfig[], items: WijmoRowItem[]) => {
    const host = document.createElement('div');
    document.body.appendChild(host);
    const grid = new FlexGrid(host, {
      autoGenerateColumns: false,
      columnGroups: columnGroups as never,
      itemsSource: items,
    });
    grid.cells.setCellData(0, 0, '5000', true, false);
  };

  it('보정 전에는 빈 셀 입력이 문자열로 저장된다', () => {
    const items: WijmoRowItem[] = [{ W_20260803: null }];
    typeIntoFirstCell(weekLeaf('n3'), items);

    expect(items[0].W_20260803).toBe('5000');
  });

  it('보정 후에는 빈 셀 입력이 숫자로 저장된다', () => {
    const items: WijmoRowItem[] = [{ W_20260803: null }];
    typeIntoFirstCell(normalizeDynamicColumns(weekLeaf('n3')), items);

    expect(items[0].W_20260803).toBe(5000);
  });
});

// 관리자 메타(SCM_MST_SHEET_COLUMNS.DATA_MAX_LENGTH)로 입력 글자수를 제한하는 경로 —
//   AS-IS SpdSheet MaxLength 이식. PRIORITY(DATA_MAX_LENGTH=2)처럼 화면 코드가 아니라 메타로
//   "N자까지만 입력" 을 건다. Wijmo Column.maxLength 로 배선되어야 편집기가 실제로 막는다.
describe('입력 최대 길이 (DATA_MAX_LENGTH -> Wijmo maxLength)', () => {
  it('dataMaxLength 를 leaf 컬럼 maxLength 로 싣는다', () => {
    const [mapped] = mapRawColumnsToWijmoColumns([col({ colNm: 'PRIORITY', dataMaxLength: 2 })]);

    expect(mapped.maxLength).toBe(2);
  });

  it('dataMaxLength 가 없으면 maxLength 를 걸지 않는다 (무제한)', () => {
    const [mapped] = mapRawColumnsToWijmoColumns([col({ colNm: 'ITEM_ID' })]);

    expect(mapped.maxLength).toBeUndefined();
  });

  it('다단 헤더 leaf 에도 실린다', () => {
    const [group] = mapRawColumnsToWijmoColumns([
      col({ colNm: 'PRIORITY', sClsLblNm: 'Plan', dataMaxLength: 2 }),
    ]);

    expect(group.columns?.[0].maxLength).toBe(2);
  });

  // 증상 회귀 — 실제 FlexGrid Column 에 maxLength 가 실제로 반영되는지 확인한다.
  //   (config 필드만 보면 Wijmo 가 그 프로퍼티명을 안 읽을 때 놓친다.)
  it('실제 Wijmo Column.maxLength 로 반영된다', () => {
    const columns = mapRawColumnsToWijmoColumns([col({ colNm: 'PRIORITY', dataMaxLength: 2 })]);
    const host = document.createElement('div');
    document.body.appendChild(host);
    const grid = new FlexGrid(host, {
      autoGenerateColumns: false,
      columnGroups: columns as never,
      itemsSource: [{ PRIORITY: 1 }],
    });

    expect(grid.columns[0].maxLength).toBe(2);
  });
});

describe('셀 콤보 행 단위 필터 (attribute2)', () => {
  // SalesSite 콤보 실측 형태 — 좁힘 기준 컬럼을 결과로도 내려준다.
  const SITES: ComboResponse[] = [
    { CODE: 'S40A', NAME: 'Site 40-A', DIVISION_ID: '40', END_CUSTOMER: 'C1' },
    { CODE: 'S40B', NAME: 'Site 40-B', DIVISION_ID: '40', END_CUSTOMER: 'C2' },
    { CODE: 'S81A', NAME: 'Site 81-A', DIVISION_ID: '81', END_CUSTOMER: 'C1' },
  ];

  const siteDataMap = (attribute2?: string) => {
    const [leaf] = mapRawColumnsToWijmoColumns([
      col({ colNm: 'SCM_SITE_ID', colLblNm: 'Sales Site', dataMap: SITES, attribute2 }),
    ]);
    return leaf.dataMap as DataMap;
  };

  const namesFor = (attribute2: string, row: WijmoRowItem): string[] =>
    siteDataMap(attribute2).getDisplayValues(row);

  it('attribute2 가 없으면 전체 목록이다', () => {
    expect(siteDataMap(undefined).getDisplayValues({})).toEqual([
      'Site 40-A',
      'Site 40-B',
      'Site 81-A',
    ]);
  });

  it('행 값이 있는 조건은 일치하는 후보만 남긴다', () => {
    expect(
      namesFor('DIVISION_ID:DIVISION_ID,END_CUSTOMER:END_CUSTOMER', {
        DIVISION_ID: '40',
        END_CUSTOMER: 'C1',
      })
    ).toEqual(['Site 40-A']);
  });

  it('상위 컬럼이 비어 있으면 그 조건만 건너뛴다 (Division 은 계속 좁힌다)', () => {
    expect(
      namesFor('DIVISION_ID:DIVISION_ID,END_CUSTOMER:END_CUSTOMER', {
        DIVISION_ID: '40',
        END_CUSTOMER: '',
      })
    ).toEqual(['Site 40-A', 'Site 40-B']);
  });

  it('상위 컬럼이 null/undefined/공백 이어도 건너뛴다', () => {
    const binding = 'DIVISION_ID:DIVISION_ID,END_CUSTOMER:END_CUSTOMER';
    expect(namesFor(binding, { DIVISION_ID: '40', END_CUSTOMER: null })).toEqual([
      'Site 40-A',
      'Site 40-B',
    ]);
    expect(namesFor(binding, { DIVISION_ID: '40' })).toEqual(['Site 40-A', 'Site 40-B']);
    expect(namesFor(binding, { DIVISION_ID: '40', END_CUSTOMER: '   ' })).toEqual([
      'Site 40-A',
      'Site 40-B',
    ]);
  });

  it('행 값이 있는데 콤보 row 값이 비면 후보에서 뺀다 (Division 엄격 유지)', () => {
    const [leaf] = mapRawColumnsToWijmoColumns([
      col({
        colNm: 'SCM_SITE_ID',
        dataMap: [{ CODE: 'SX', NAME: 'Site X', DIVISION_ID: '', END_CUSTOMER: 'C1' }],
        attribute2: 'DIVISION_ID:DIVISION_ID',
      }),
    ]);
    expect((leaf.dataMap as DataMap).getDisplayValues({ DIVISION_ID: '40' })).toEqual([]);
  });
});

describe('상위 콤보 변경 시 후보 밖이 된 하위 셀 (findStaleComboCells)', () => {
  // DMF0006 3단 종속 — Team(DEPT_ID) → End Customer → Sales Site
  const COLUMNS: RawFlexGridColumnConfig[] = [
    col({ colNm: 'DEPT_ID', cellCtrlObjTpCd: CELL_CONTROL_TYPE.COMBO, cellCboDataTp: 'Team' }),
    col({
      colNm: 'END_CUSTOMER',
      cellCtrlObjTpCd: CELL_CONTROL_TYPE.COMBO,
      cellCboDataTp: 'EndCustomer',
      attribute2: 'DIVISION_ID:DIVISION_ID,DEPT_ID:DEPT_ID',
    }),
    col({
      colNm: 'SCM_SITE_ID',
      cellCtrlObjTpCd: CELL_CONTROL_TYPE.COMBO,
      cellCboDataTp: 'SalesSite',
      attribute2: 'DIVISION_ID:DIVISION_ID,END_CUSTOMER:END_CUSTOMER',
    }),
  ];

  const COMBO_ROWS: Record<string, ComboResponse[]> = {
    EndCustomer: [
      { CODE: 'C1', NAME: 'Customer 1', DIVISION_ID: '40', DEPT_ID: 'T1' },
      { CODE: 'C2', NAME: 'Customer 2', DIVISION_ID: '40', DEPT_ID: 'T2' },
    ],
    SalesSite: [
      { CODE: 'S1', NAME: 'Site 1', DIVISION_ID: '40', END_CUSTOMER: 'C1' },
      { CODE: 'S2', NAME: 'Site 2', DIVISION_ID: '40', END_CUSTOMER: 'C2' },
    ],
  };

  const find = (row: WijmoRowItem, changedBinding: string) =>
    findStaleComboCells(COLUMNS, COMBO_ROWS, row, changedBinding);

  it('상위를 바꿔 하위 값이 후보 밖이 되면 대상이다', () => {
    // Team T1 에서 고른 C1 을 그대로 둔 채 Team 을 T2 로 바꿨다.
    expect(find({ DIVISION_ID: '40', DEPT_ID: 'T2', END_CUSTOMER: 'C1' }, 'DEPT_ID')).toEqual([
      { binding: 'END_CUSTOMER', previousValue: 'C1' },
    ]);
  });

  it('하위 값이 새 조건에도 맞으면 그대로 둔다', () => {
    expect(find({ DIVISION_ID: '40', DEPT_ID: 'T2', END_CUSTOMER: 'C2' }, 'DEPT_ID')).toEqual([]);
  });

  it('비움은 연쇄하지 않는다 — 상위가 비면 그 조건이 풀려 하위는 유효하면 남는다', () => {
    // Team 을 T2 로 바꾸면 C1 은 빠지지만, S1 은 END_CUSTOMER 조건에서 풀려 division 기준으로 유효하다.
    expect(
      find({ DIVISION_ID: '40', DEPT_ID: 'T2', END_CUSTOMER: 'C1', SCM_SITE_ID: 'S1' }, 'DEPT_ID')
    ).toEqual([{ binding: 'END_CUSTOMER', previousValue: 'C1' }]);
  });

  it('바꾼 컬럼에 매달리지 않은 컬럼은 건드리지 않는다', () => {
    // SCM_SITE_ID 의 조건은 DIVISION_ID/END_CUSTOMER 뿐 — DEPT_ID 와 무관하다.
    expect(
      find({ DIVISION_ID: '40', DEPT_ID: 'T2', END_CUSTOMER: 'C2', SCM_SITE_ID: 'S2' }, 'DEPT_ID')
    ).toEqual([]);
  });

  it('하위가 비어 있으면 비울 것이 없다', () => {
    expect(find({ DIVISION_ID: '40', DEPT_ID: 'T2', END_CUSTOMER: '' }, 'DEPT_ID')).toEqual([]);
  });

  it('자기 자신은 비우지 않는다', () => {
    expect(
      find({ DIVISION_ID: '40', DEPT_ID: 'T1', END_CUSTOMER: 'C1', SCM_SITE_ID: 'S1' }, 'END_CUSTOMER')
    ).toEqual([]);
  });

  it('상위를 비우면 그 조건이 풀려 하위는 유지된다', () => {
    // DEPT_ID 를 지우면 END_CUSTOMER 조건이 건너뛰어져 C1 은 division 기준으로 여전히 유효하다.
    expect(
      find({ DIVISION_ID: '40', DEPT_ID: '', END_CUSTOMER: 'C1', SCM_SITE_ID: 'S1' }, 'DEPT_ID')
    ).toEqual([]);
  });

  it('콤보가 아직 안 실렸으면 비우지 않는다 (미도착을 후보 0건으로 오인 금지)', () => {
    expect(
      findStaleComboCells(COLUMNS, {}, { DIVISION_ID: '40', DEPT_ID: 'T2', END_CUSTOMER: 'C1' }, 'DEPT_ID')
    ).toEqual([]);
  });

  it('attribute2 가 없으면 대상이 아니다', () => {
    const columns = [
      col({ colNm: 'END_CUSTOMER', cellCtrlObjTpCd: CELL_CONTROL_TYPE.COMBO, cellCboDataTp: 'EndCustomer' }),
    ];
    expect(
      findStaleComboCells(columns, COMBO_ROWS, { DEPT_ID: 'T2', END_CUSTOMER: 'C1' }, 'DEPT_ID')
    ).toEqual([]);
  });

  it('콤보 컬럼이 아니면 대상이 아니다', () => {
    const columns = [
      col({
        colNm: 'END_CUSTOMER',
        cellCtrlObjTpCd: CELL_CONTROL_TYPE.TEXT,
        cellCboDataTp: 'EndCustomer',
        attribute2: 'DEPT_ID:DEPT_ID',
      }),
    ];
    expect(
      findStaleComboCells(columns, COMBO_ROWS, { DEPT_ID: 'T2', END_CUSTOMER: 'C1' }, 'DEPT_ID')
    ).toEqual([]);
  });
});

describe('재조회형 상위 콤보 변경 시 후보 밖 하위 셀 (findStaleRowParamComboCells)', () => {
  const SITE = 'SCM_SITE_ID';
  // DMF0007 Sales Site — PARAM10='D' 재조회형. PARAM2 오른쪽은 SQL 바인드명이다.
  const COLUMNS: RawFlexGridColumnConfig[] = [
    col({
      colNm: SITE,
      cellCtrlObjTpCd: CELL_CONTROL_TYPE.COMBO,
      cellCboDataTp: 'SalesSite',
      attribute10: 'D',
      attribute2: 'DIVISION_ID:divisionId,END_CUSTOMER:endCustomer',
    }),
  ];
  const bindings = { DIVISION_ID: 'divisionId', END_CUSTOMER: 'endCustomer' };
  const keyOf = (row: WijmoRowItem) => rowParamKey(bindings, row);

  // End Customer C2 로 재조회한 Sales Site 후보 = S2 만.
  const rowC2: WijmoRowItem = { DIVISION_ID: '40', END_CUSTOMER: 'C2', [SITE]: 'S1' };
  const byBinding = {
    [SITE]: { [keyOf(rowC2)]: [{ CODE: 'S2', NAME: 'Site 2' }] as ComboResponse[] },
  };

  it('End Customer 를 바꿔 Sales Site 값이 새 후보 밖이면 stale 이다', () => {
    const { stale, awaiting } = findStaleRowParamComboCells(
      COLUMNS,
      byBinding,
      {},
      rowC2,
      'END_CUSTOMER'
    );
    expect(stale).toEqual([{ binding: SITE, previousValue: 'S1' }]);
    expect(awaiting).toEqual([]);
  });

  it('값이 새 후보에 있으면 그대로 둔다', () => {
    const rowValid: WijmoRowItem = { DIVISION_ID: '40', END_CUSTOMER: 'C2', [SITE]: 'S2' };
    const map = {
      [SITE]: { [keyOf(rowValid)]: [{ CODE: 'S2', NAME: 'Site 2' }] as ComboResponse[] },
    };
    expect(
      findStaleRowParamComboCells(COLUMNS, map, {}, rowValid, 'END_CUSTOMER').stale
    ).toEqual([]);
  });

  it('재조회 미도착이면 비우지 않고 awaiting 으로 미룬다', () => {
    const { stale, awaiting } = findStaleRowParamComboCells(COLUMNS, {}, {}, rowC2, 'END_CUSTOMER');
    expect(stale).toEqual([]);
    expect(awaiting).toEqual([SITE]);
  });

  it('도착한 0건은 stale 이다 — 미도착(undefined)과 구분한다', () => {
    const map = { [SITE]: { [keyOf(rowC2)]: [] as ComboResponse[] } };
    const { stale, awaiting } = findStaleRowParamComboCells(COLUMNS, map, {}, rowC2, 'END_CUSTOMER');
    expect(stale).toEqual([{ binding: SITE, previousValue: 'S1' }]);
    expect(awaiting).toEqual([]);
  });

  it('하위가 비어 있으면 대상이 아니다', () => {
    const row: WijmoRowItem = { DIVISION_ID: '40', END_CUSTOMER: 'C2', [SITE]: '' };
    expect(findStaleRowParamComboCells(COLUMNS, byBinding, {}, row, 'END_CUSTOMER').stale).toEqual(
      []
    );
  });

  it('바뀐 셀에 종속되지 않은 컬럼은 대상이 아니다', () => {
    const { stale, awaiting } = findStaleRowParamComboCells(
      COLUMNS,
      byBinding,
      {},
      rowC2,
      'DEPT_ID'
    );
    expect(stale).toEqual([]);
    expect(awaiting).toEqual([]);
  });

  it('자기 자신은 비우지 않는다', () => {
    expect(findStaleRowParamComboCells(COLUMNS, byBinding, {}, rowC2, SITE).stale).toEqual([]);
  });

  it('필터형(PARAM10≠D) 콤보는 대상이 아니다 — findStaleComboCells 몫이다', () => {
    const filterCols = [
      col({
        colNm: SITE,
        cellCtrlObjTpCd: CELL_CONTROL_TYPE.COMBO,
        cellCboDataTp: 'SalesSite',
        attribute2: 'END_CUSTOMER:END_CUSTOMER',
      }),
    ];
    const { stale, awaiting } = findStaleRowParamComboCells(
      filterCols,
      byBinding,
      {},
      rowC2,
      'END_CUSTOMER'
    );
    expect(stale).toEqual([]);
    expect(awaiting).toEqual([]);
  });

  it('신규행은 PARAM9 insert 버킷을 기준으로 판정한다', () => {
    const insertCols = [
      col({
        colNm: SITE,
        cellCtrlObjTpCd: CELL_CONTROL_TYPE.COMBO,
        cellCboDataTp: 'SalesSite',
        attribute9: 'SalesSiteInsert',
        attribute10: 'D',
        attribute2: 'DIVISION_ID:divisionId,END_CUSTOMER:endCustomer',
      }),
    ];
    const insertRow: WijmoRowItem = {
      CRUD_TYPE: CRUD_TYPE.INSERT,
      DIVISION_ID: '40',
      END_CUSTOMER: 'C2',
      [SITE]: 'S1',
    };
    // 기본 버킷엔 S1 이 있어도, 신규행은 insert 버킷(S9 만)을 봐야 하므로 S1 은 stale 이다.
    const base = {
      [SITE]: { [keyOf(insertRow)]: [{ CODE: 'S1', NAME: 'Site 1' }] as ComboResponse[] },
    };
    const insert = {
      [SITE]: { [keyOf(insertRow)]: [{ CODE: 'S9', NAME: 'Site 9' }] as ComboResponse[] },
    };
    expect(
      findStaleRowParamComboCells(insertCols, base, insert, insertRow, 'END_CUSTOMER').stale
    ).toEqual([{ binding: SITE, previousValue: 'S1' }]);
  });
});

// 헤더 클릭 정렬(dataGridUtils.setSortableColumnHeaderClick)이 allowSorting 을 스위치로 읽으므로,
//   여기서 true 가 새어 나가면 F3 없이도 헤더 클릭만으로 정렬이 걸린다.
describe('정렬 스위치 기본값 (헤더 클릭 정렬 차단 전제)', () => {
  it('leaf 컬럼은 allowSorting 이 꺼진 상태로 만들어진다 — 정렬은 F3 로만 켠다', () => {
    const mapped = mapRawColumnsToWijmoColumns([
      col({ colNm: 'ITEM_CD' }),
      col({ colNm: 'ITEM_NM' }),
    ]);

    expect(mapped.map(column => column.allowSorting)).toEqual([false, false]);
  });

  it('다단 헤더에서도 leaf 마다 allowSorting 이 꺼져 있다', () => {
    const [group] = mapRawColumnsToWijmoColumns([
      col({ colNm: 'PLAN_QTY', sClsLblNm: 'Plan' }),
      col({ colNm: 'ACT_QTY', sClsLblNm: 'Plan' }),
    ]);

    expect(group.columns?.map(leaf => leaf.allowSorting)).toEqual([false, false]);
  });
});

// 관리자 메타(Cell object)로 숫자 전용 컬럼을 만드는 경로 — DMF0043 버전관리 팝업의 Year 처럼
//   "숫자만 입력" 을 화면 코드가 아니라 SHEET_COLUMNS 설정으로 거는 방식이 표준이다.
//   그 계약이 실제로 입력을 막는 지점(Wijmo setCellData 의 dataType 검사)까지 함께 고정한다.
describe('숫자 전용 컬럼 (Cell object = FPNumber)', () => {
  const commit = (columns: FlexGridColumnConfig[], items: WijmoRowItem[], text: string) => {
    const host = document.createElement('div');
    document.body.appendChild(host);
    const grid = new FlexGrid(host, {
      autoGenerateColumns: false,
      columnGroups: columns as never,
      itemsSource: items,
    });
    return { ok: grid.cells.setCellData(0, 0, text, true, false), grid };
  };

  const yearMeta = (ctrlType?: CELL_CONTROL_TYPE): RawFlexGridColumnConfig[] => [
    col({ colNm: 'YYYY', colLblNm: 'Year', cellCtrlObjTpCd: ctrlType }),
  ];

  it('FPNumber 메타는 컬럼 dataType 을 Number 로 만든다', () => {
    const [column] = mapRawColumnsToWijmoColumns(yearMeta(CELL_CONTROL_TYPE.NUMBER));

    expect(column.dataType).toBe(DataType.Number);
  });

  it('scale 이 비어 있으면 서식을 걸지 않는다 — 연도에 천단위 구분(2,026)이 붙으면 안 된다', () => {
    const [column] = mapRawColumnsToWijmoColumns(yearMeta(CELL_CONTROL_TYPE.NUMBER));

    expect(column.format).toBeUndefined();
  });

  it('문자 커밋은 거부되고 셀 값이 그대로 남는다', () => {
    const items: WijmoRowItem[] = [{ YYYY: '2026' }];
    const { ok } = commit(
      mapRawColumnsToWijmoColumns(yearMeta(CELL_CONTROL_TYPE.NUMBER)),
      items,
      'test'
    );

    expect(ok).toBe(false);
    expect(items[0].YYYY).toBe('2026');
  });

  it('신규 행(빈 값)에서도 문자 커밋은 거부된다', () => {
    const items: WijmoRowItem[] = [{ YYYY: '' }];
    const { ok } = commit(
      mapRawColumnsToWijmoColumns(yearMeta(CELL_CONTROL_TYPE.NUMBER)),
      items,
      'test'
    );

    expect(ok).toBe(false);
    expect(items[0].YYYY).toBe('');
  });

  it('숫자 커밋은 통과한다', () => {
    const items: WijmoRowItem[] = [{ YYYY: '2026' }];
    const { ok } = commit(
      mapRawColumnsToWijmoColumns(yearMeta(CELL_CONTROL_TYPE.NUMBER)),
      items,
      '2027'
    );

    expect(ok).toBe(true);
    expect(items[0].YYYY).toBe(2027);
  });

  // 증상 대조 — Cell object 가 비어 있는 메타(옛 캐시 포함)로는 문자가 그대로 들어간다.
  it('Cell object 미지정 메타로는 문자가 들어간다', () => {
    const items: WijmoRowItem[] = [{ YYYY: '2026' }];
    const { ok } = commit(mapRawColumnsToWijmoColumns(yearMeta()), items, 'test');

    expect(ok).toBe(true);
    expect(items[0].YYYY).toBe('test');
  });
});

/**
 * 신규행 전용 콤보 (컬럼 메타 PARAM9) — 2026-08-31 사용자 확정.
 *
 * 신규행(CRUD_TYPE='I')만 PARAM9 콤보를 보고, 조회로 내려온 행은 종전대로 Cell Combo Data Type
 * 을 본다. 방식(필터/재조회)은 양쪽 다 PARAM10 을 따르고 PARAM2 도 공유한다.
 * PARAM9 가 비면 종전과 완전히 같아야 한다.
 */
describe('신규행 전용 콤보 (PARAM9)', () => {
  const BASE = [{ CODE: 'B1', NAME: '기존1' }] as unknown as ComboResponse[];
  const INSERT = [{ CODE: 'N1', NAME: '신규1' }] as unknown as ComboResponse[];

  const leafOf = (extra: Partial<RawFlexGridColumnConfig>) =>
    mapRawColumnsToWijmoColumns([
      col({ colNm: 'SCM_SITE_ID', cellCboDataTp: 'Base', dataMap: BASE, ...extra }),
    ])[0];

  it('PARAM9 가 비면 종전과 같다 - 신규행도 기본 콤보를 본다', () => {
    const leaf = leafOf({});
    expect((leaf.dataMap as DataMap).getDisplayValues({ CRUD_TYPE: 'I' })).toEqual(['기존1']);
  });

  it('신규행은 PARAM9 콤보 후보만 본다', () => {
    const leaf = leafOf({ attribute9: 'InsertCombo', insertDataMap: INSERT });
    expect((leaf.dataMap as DataMap).getDisplayValues({ CRUD_TYPE: 'I' })).toEqual(['신규1']);
  });

  it('조회로 내려온 행은 기본 콤보 후보만 본다', () => {
    const leaf = leafOf({ attribute9: 'InsertCombo', insertDataMap: INSERT });
    expect((leaf.dataMap as DataMap).getDisplayValues({ CRUD_TYPE: 'M' })).toEqual(['기존1']);
    expect((leaf.dataMap as DataMap).getDisplayValues({})).toEqual(['기존1']);
  });

  it('색인에는 두 콤보가 다 들어간다 - 라벨과 getKeyValue 가 양쪽 다 살아야 한다', () => {
    const leaf = leafOf({ attribute9: 'InsertCombo', insertDataMap: INSERT });
    const map = leaf.dataMap as DataMap;
    expect(map.getDisplayValue('B1')).toBe('기존1');
    expect(map.getDisplayValue('N1')).toBe('신규1');
    expect(map.getKeyValue('신규1')).toBe('N1');
  });

  it('PARAM2 는 두 콤보가 공유한다 - 신규행 후보도 같은 조건으로 좁힌다', () => {
    const leaf = leafOf({
      attribute2: 'DIVISION_ID:DIVISION_ID',
      attribute9: 'InsertCombo',
      insertDataMap: [
        { CODE: 'N1', NAME: '신규1', DIVISION_ID: '40' },
        { CODE: 'N2', NAME: '신규2', DIVISION_ID: '82' },
      ] as unknown as ComboResponse[],
    });
    expect(
      (leaf.dataMap as DataMap).getDisplayValues({ CRUD_TYPE: 'I', DIVISION_ID: '82' })
    ).toEqual(['신규2']);
  });
});

describe('행 파라미터 콤보 - 바인드 값 접기 (PARAM10=D)', () => {
  const BINDINGS = {
    DIVISION_ID: 'divisionId',
    END_CUSTOMER: 'endCustomer',
    END_CUSTOMER40: 'endCustomer',
  };

  it('한 바인드명에 걸린 행 컬럼 중 먼저 채워진 값을 쓴다 - 비40 행', () => {
    expect(
      rowParamValues(BINDINGS, { DIVISION_ID: '82', END_CUSTOMER: 'C1', END_CUSTOMER40: '' })
    ).toEqual({ divisionId: '82', endCustomer: 'C1' });
  });

  it('앞 컬럼이 비면 뒤 컬럼 값을 쓴다 - 40 행', () => {
    expect(
      rowParamValues(BINDINGS, { DIVISION_ID: '40', END_CUSTOMER: '', END_CUSTOMER40: 'C40' })
    ).toEqual({ divisionId: '40', endCustomer: 'C40' });
  });

  it('전부 비면 공란을 남긴다 - 키를 빼지 않는다', () => {
    expect(rowParamValues(BINDINGS, {})).toEqual({ divisionId: '', endCustomer: '' });
  });

  it('바인드명이 겹치지 않으면 종전과 같다', () => {
    expect(
      rowParamValues({ DIVISION_ID: 'divisionId', ITEM_ID: 'itemId' }, {
        DIVISION_ID: '40',
        ITEM_ID: 'IT1',
      })
    ).toEqual({ divisionId: '40', itemId: 'IT1' });
  });

  it('바인드명이 Object 프로토타입 키여도 값으로 다룬다', () => {
    expect(rowParamValues({ A: 'constructor' }, { A: 'V' })).toEqual({ constructor: 'V' });
  });
});
