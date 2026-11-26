import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';

import type {
  PivotMonthMeta,
  PlanRawRow,
  ResultRawRow,
  ShipmentAlloRow,
  TeamRow,
} from '../shipment-allo-report.types';
import { PIVOT_KIND } from '../shipment-allo-report.types';

const s = (v: unknown): string => (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '');
const n = (v: unknown): number => (typeof v === 'number' && Number.isFinite(v) ? v : Number(v) || 0);

// AS-IS 셀 반올림 — 월/소계/GAP 셀은 NumberCellType DecimalPlaces=0(SetReNumerCellType(-9999999999, 0),
//   cs:197~255)이고, AS-IS 는 값을 누적·합산할 때 셀 Value 가 아니라 화면 Text(정수로 반올림된 표시값)를
//   다시 읽어 더한다(cs:857·912 누적, 928 소계, 1079/1081 GAP, 1094 Total, 1149 요약). 그래서 소수 수량
//   (SHIP_PLAN_AMEND 에 실재)이 있으면 셀마다 반올림된 정수로 소계·GAP·요약이 계산된다. TO-BE 가 소수 원값을
//   그대로 합산하면 표시는 같아도 소계/GAP/요약이 1~2씩 어긋났다(테스트 이슈 "소수점 표시 기준·GAP 차이").
//   .NET decimal 표시 반올림은 0.5 를 0 에서 먼 쪽으로 올린다(MidpointRounding.AwayFromZero).
const roundAway = (v: number): number => Math.sign(v) * Math.round(Math.abs(v));

// AS-IS 정적 DEPT_ID/SITE_ID 는 폭0(비노출) — TeamRow 키(4키)는 텍스트 값으로 매칭한다(design 03 §4.1,
// SITE_ID/DEPT_ID 는 값 매칭에 안 쓰임 — SITE_NAME/DEPT_NAME 텍스트 비교로 행을 찾는 AS-IS 그대로).
export const rowKeyOf = (r: {
  FROM_SITE?: string;
  EXTRA_SPEC?: string;
  NICK_NAME?: string;
  TEAM_NAME?: string;
}): string => `${s(r.FROM_SITE)}|${s(r.EXTRA_SPEC)}|${s(r.NICK_NAME)}|${s(r.TEAM_NAME)}`;

/** 'YYYYMM' → 'yy/MM' (design 03 §2.2 헤더 라벨). */
const toHeaderLabel = (yyyymm: string): string =>
  yyyymm.length === 6 ? `${yyyymm.slice(2, 4)}/${yyyymm.slice(4, 6)}` : yyyymm;

const addMonth = (yyyymm: string, delta: number): string => {
  const y = Number(yyyymm.slice(0, 4));
  const m = Number(yyyymm.slice(4, 6)) - 1 + delta;
  const d = new Date(Date.UTC(y, m, 1));
  return `${d.getUTCFullYear()}${String(d.getUTCMonth() + 1).padStart(2, '0')}`;
};

/**
 * Period From~To(YYYYMM) 월단위 순회 + 기준월(baseYyyymm) 3-way 분기(design 03 §2.2).
 * baseYyyymm 이 없으면(기준일 미선택) 전 구간을 RESULT 로 처리(표시만, 조회 전 상태).
 */
export const buildPivotMonths = (
  fromYyyymm: string,
  toYyyymm: string,
  baseYyyymm: string
): PivotMonthMeta[] => {
  if (!fromYyyymm || !toYyyymm || fromYyyymm.length !== 6 || toYyyymm.length !== 6) return [];
  const months: PivotMonthMeta[] = [];
  let cur = fromYyyymm;
  let guard = 0;
  while (cur <= toYyyymm && guard < 240) {
    const kind =
      !baseYyyymm || cur < baseYyyymm
        ? PIVOT_KIND.RESULT
        : cur > baseYyyymm
          ? PIVOT_KIND.PLAN
          : PIVOT_KIND.BASE;
    months.push({ yyMM: cur.slice(2), headerLabel: toHeaderLabel(cur), kind });
    cur = addMonth(cur, 1);
    guard += 1;
  }
  return months;
};

/** binding 목록(값 채우기·순서 판정용) — 기준월은 서브키 3종(design 03 §2.4 오병합 방지). */
export const pivotBindingsOf = (month: PivotMonthMeta): string[] =>
  month.kind === PIVOT_KIND.BASE
    ? [`M_${month.yyMM}_RESULT`, `M_${month.yyMM}_PLAN`, `M_${month.yyMM}_TOTAL`]
    : [`M_${month.yyMM}`];

/** DataGrid dynamicColumns — 2단 헤더(yy/MM 상단 + Result/Plan/Total 하단, 기준월은 3칸 스팬). */
export const buildPivotColumns = (months: PivotMonthMeta[]): FlexGridColumnConfig[] =>
  months.map(month => {
    const leaf = (binding: string, header: string): FlexGridColumnConfig => ({
      binding,
      header,
      align: 'right',
      width: 70,
      allowMerging: false,
      allowSorting: false,
      isReadOnly: true, // FROM_SITE~GAP 구간 항상 잠금(design 03 §3 #29)
      format: '#,##0',
      _dynamic: true,
    });
    if (month.kind === PIVOT_KIND.RESULT) {
      return { header: month.headerLabel, align: 'center', columns: [leaf(`M_${month.yyMM}`, 'Result')] };
    }
    if (month.kind === PIVOT_KIND.PLAN) {
      return { header: month.headerLabel, align: 'center', columns: [leaf(`M_${month.yyMM}`, 'Plan')] };
    }
    return {
      header: month.headerLabel,
      align: 'center',
      columns: [
        leaf(`M_${month.yyMM}_RESULT`, 'Result'),
        leaf(`M_${month.yyMM}_PLAN`, 'Plan'),
        leaf(`M_${month.yyMM}_TOTAL`, 'Total'),
      ],
    };
  });

// SUBTOTAL/GAP/비고 — admin 메타 밖 코드리터럴 칼럼(design 03 §1.2). 비고만 편집대상.
//   비고(NOTE)는 _inputEditType 를 설정해 공통 인프라(GridUtils.isEditableCell→setEditablecolumns 편집 허용,
//   EditTracker 변경추적, formatEditableColumns 스타일)가 '편집 컬럼'으로 인식하게 한다. 이게 없으면
//   isEditableCell default:false 로 떨어져 편집은 돼도 변경추적이 안 돼 저장 시 '수정 내용 없음'이 된다.
//   Main = OPTIONAL(편집), Gap = SEARCH_ONLY(읽기전용). GridUtils.getColumn 이 columnGroups(config)를 읽어
//   동적컬럼 config 의 _inputEditType 가 그대로 반영된다(ora 아님, 코드 실측).
// allowSorting:false — AS-IS SCP0055 는 어느 컬럼도 사용자 헤더 클릭 정렬을 켜지 않는다
//   (FarPoint AllowAutoSort 기본 false, SpreadInfo Add* 헬퍼의 SetColumnAllowAutoSort 호출 전부 주석,
//   .cs 는 프로그램 1회 SortRows(4키)만 수행). pivot 월컬럼(buildPivotColumns)과 동일하게 명시 차단.
export const buildDerivedColumns = (isGapTab: boolean): FlexGridColumnConfig[] => [
  { binding: 'SUBTOTAL', header: '소계', align: 'right', width: 70, isReadOnly: true, format: '#,##0', allowSorting: false },
  // GAP 컬럼은 Main/Gap 탭 모두 생성 — AS-IS InitSpreadDateColumn(cs:178)은 시트 분기 없는 공용 함수라
  //   siMain·siGap 양쪽에 동일하게 GAP 칼럼(cs:254)을 만든다. 단 RefreshGridGAP(cs:604)이 siMain 에만
  //   값을 채우므로 Gap 탭 GAP 은 항상 빈 칸(값 미할당)으로 남는다 — AS-IS siGap 파리티.
  {
    binding: 'GAP',
    header: 'GAP',
    align: 'right',
    width: 70,
    isReadOnly: true,
    format: '#,##0',
    allowSorting: false,
  } as FlexGridColumnConfig,
  {
    binding: 'NOTE',
    header: '비고',
    align: 'left',
    width: 200,
    isReadOnly: isGapTab,
    _inputEditType: isGapTab ? CELL_INPUT_EDIT_TYPE.SEARCH_ONLY : CELL_INPUT_EDIT_TYPE.OPTIONAL,
    multiLine: true,
    wordWrap: true,
    allowSorting: false,
  },
];

/**
 * DB메타 6칼럼(FROM_SITE/SITE_ID/EXTRA_SPEC/NICK_NAME/DEPT_ID/TEAM_NAME) — admin 동적 반영,
 * SEARCH_ONLY(읽기전용) + 세로 병합(design 03 §1.1 FPMerge.Restricted 무조건 적용).
 */
export const buildFixedColumns = (adminColumns: RawFlexGridColumnConfig[]): RawFlexGridColumnConfig[] =>
  adminColumns.map(c => ({ ...c, allowMerging: true }));

/**
 * 팀 목록(o_rc2)을 그리드 row 뼈대로 변환 — SITE_NAME→FROM_SITE, DEPT_NAME→TEAM_NAME(design 03 §4.1).
 * 팀명(TEAM_NAME) 공백 행은 IS_TEAM_BLANK=true(비고 배경 LightGray, design 03 §3 #29-부속).
 */
export const buildBaseRows = (teamRows: TeamRow[]): ShipmentAlloRow[] =>
  teamRows.map(t => ({
    SITE_ID: s(t.SITE_ID),
    FROM_SITE: s(t.SITE_NAME),
    EXTRA_SPEC: s(t.EXTRA_SPEC),
    NICK_NAME: s(t.NICK_NAME),
    DEPT_ID: s(t.DEPT_ID),
    TEAM_NAME: s(t.DEPT_NAME),
    NOTE: '',
    SUBTOTAL: 0,
    IS_TEAM_BLANK: !s(t.DEPT_NAME),
  }));

/**
 * 계획/실적 raw(o_rc1/o_rc3)를 pivot 칼럼에 매칭·가산(design 03 §4.1 — 동일 (행,월) 조합이 중복
 * 반환될 수 있어 가산(+=)한다, SP 가 1행 1값으로 집계해 준다고 가정하지 않는다).
 * SUBTOTAL = 기준월 Result/Plan 리프 + 나머지 월 값 합산(기준월 Total 칸은 제외) — AS-IS 파리티.
 *   AS-IS 는 RefreshGrid(cs:595)에서 소계를 계산하는데(cs:974-982) 그 시점엔 기준월 Total 칸이
 *   아직 비어(0) 있어 사실상 Result+Plan 만 더해진다. Total 은 그 뒤 RefreshGridGAP(cs:1138-1148)에서
 *   표시용으로만 채워진다. 따라서 TO-BE 도 Total 바인딩을 소계 합산에서 빼야 기준월이 이중계산되지 않는다.
 */
export const fillPivotValues = (
  rows: ShipmentAlloRow[],
  planRaw: PlanRawRow[],
  resultRaw: ResultRawRow[],
  months: PivotMonthMeta[]
): ShipmentAlloRow[] => {
  const byKey = new Map<string, ShipmentAlloRow>();
  rows.forEach(r => byKey.set(rowKeyOf(r), r));
  const allBindings = months.flatMap(pivotBindingsOf);
  // 소계 합산 대상 = 기준월 Total 칸 제외(위 주석 참조 — AS-IS 소계 계산 시점엔 Total 이 빈 셀).
  const subtotalBindings = allBindings.filter(b => !b.endsWith('_TOTAL'));
  rows.forEach(r => allBindings.forEach(b => { r[b] = n(r[b]); }));

  const monthByYyyymm = new Map<string, PivotMonthMeta>(months.map(m => [`20${m.yyMM}`, m]));

  const accumulate = (raw: { YYYYMMDD: string; QTY: number }[], key: (raw: unknown) => string, sub: 'RESULT' | 'PLAN') => {
    raw.forEach(entry => {
      const row = byKey.get(key(entry));
      if (!row) return;
      const yyyymm = s(entry.YYYYMMDD).slice(0, 6);
      const month = monthByYyyymm.get(yyyymm);
      if (!month) return;
      const binding = month.kind === PIVOT_KIND.BASE ? `M_${month.yyMM}_${sub}` : `M_${month.yyMM}`;
      // AS-IS: 셀 표시값(반올림 정수) + 이번 수량 → 다시 셀에 넣고 표시는 반올림(cs:857-859). 매 누적마다
      //   반올림한 값을 저장하면 다음 누적이 읽는 값(표시값)과 최종 표시값이 AS-IS 와 같아진다.
      row[binding] = roundAway(n(row[binding]) + n(entry.QTY));
    });
  };

  accumulate(
    planRaw,
    e => rowKeyOf({ FROM_SITE: (e as PlanRawRow).SITE_NAME, EXTRA_SPEC: (e as PlanRawRow).EXTRA_SPEC, NICK_NAME: (e as PlanRawRow).NICK_NAME, TEAM_NAME: (e as PlanRawRow).DEPT_NAME }),
    'PLAN'
  );
  accumulate(
    resultRaw,
    e => rowKeyOf({ FROM_SITE: (e as ResultRawRow).SITE_NAME, EXTRA_SPEC: (e as ResultRawRow).EXTRA_SPEC, NICK_NAME: (e as ResultRawRow).NICK_NAME, TEAM_NAME: (e as ResultRawRow).DEPT_NAME }),
    'RESULT'
  );

  // 기준월 Total = Result + Plan(design 03 §1.2 #9, §2.4)
  rows.forEach(r => {
    months
      .filter(m => m.kind === PIVOT_KIND.BASE)
      .forEach(m => {
        const total = n(r[`M_${m.yyMM}_RESULT`]) + n(r[`M_${m.yyMM}_PLAN`]);
        r[`M_${m.yyMM}_TOTAL`] = total;
      });
    r.SUBTOTAL = subtotalBindings.reduce((sum, b) => sum + n(r[b]), 0);
  });

  return rows;
};

/** Main⊇Gap 행 보장(MergeGrid, design 03 §3.1) — Gap 전용 조합을 Main 에 삽입 후 4키 재정렬. */
export const mergeMainWithGap = (mainRows: ShipmentAlloRow[], gapRows: ShipmentAlloRow[]): ShipmentAlloRow[] => {
  const mainKeys = new Set(mainRows.map(rowKeyOf));
  const missing = gapRows.filter(g => !mainKeys.has(rowKeyOf(g))).map(g => ({ ...g, NOTE: '', SUBTOTAL: 0 }));
  return [...mainRows, ...missing].sort((a, b) => {
    const ka = [a.NICK_NAME, a.FROM_SITE, a.EXTRA_SPEC, a.TEAM_NAME];
    const kb = [b.NICK_NAME, b.FROM_SITE, b.EXTRA_SPEC, b.TEAM_NAME];
    for (let i = 0; i < ka.length; i += 1) {
      const cmp = s(ka[i]).localeCompare(s(kb[i]));
      if (cmp !== 0) return cmp;
    }
    return 0;
  });
};

/** GAP = Main.SUBTOTAL - Gap.SUBTOTAL(같은 키 행 매칭, design 03 §3.1). Main 행에만 세팅. */
export const applyGap = (mainRows: ShipmentAlloRow[], gapRows: ShipmentAlloRow[]): ShipmentAlloRow[] => {
  const gapByKey = new Map(gapRows.map(r => [rowKeyOf(r), r] as const));
  return mainRows.map(r => {
    const gap = gapByKey.get(rowKeyOf(r));
    return { ...r, GAP: n(r.SUBTOTAL) - (gap ? n(gap.SUBTOTAL) : 0) };
  });
};

/**
 * 요약행 삽입(RefreshGridGAP, design 03 §3.1) — From Site+Extra Spec+Nick Name 키 경계마다
 * "닉네임+요약" 행을 노란 배경(IS_SUMMARY)으로 삽입하고 그룹 pivot~GAP 합산.
 */
export const insertSummaryRows = (rows: ShipmentAlloRow[], months: PivotMonthMeta[], hasGap: boolean): ShipmentAlloRow[] => {
  const bindings = [...months.flatMap(pivotBindingsOf), 'SUBTOTAL', ...(hasGap ? ['GAP'] : [])];
  const groupKeyOf = (r: ShipmentAlloRow) => `${s(r.FROM_SITE)}|${s(r.EXTRA_SPEC)}|${s(r.NICK_NAME)}`;

  const result: ShipmentAlloRow[] = [];
  let i = 0;
  while (i < rows.length) {
    const groupKey = groupKeyOf(rows[i]);
    const group: ShipmentAlloRow[] = [];
    while (i < rows.length && groupKeyOf(rows[i]) === groupKey) {
      group.push(rows[i]);
      i += 1;
    }
    result.push(...group);
    // 그룹 크기 조건 없이 매 경계마다 요약행 삽입 — AS-IS RefreshGridGAP(cs:1157-1205)은 From Site+
    //   Extra Spec+Nick Name 이 바뀌는 경계마다 요약행을 넣는다. 그룹이 1행이어도 경계는 성립하므로
    //   1행 그룹에도 요약행이 생긴다(그 1행 값 그대로 합산). 이전의 `if (group.length > 1)` 는 1행
    //   그룹 요약행을 누락시켜 AS-IS 와 어긋났다(G-07, 사용자 지시 2026-11-09 AS-IS 맞춤).
    const summary: ShipmentAlloRow = {
      ...group[0],
      TEAM_NAME: `${group[0].NICK_NAME} 요약`,
      NOTE: '',
      IS_SUMMARY: true,
      IS_TEAM_BLANK: false,
    };
    bindings.forEach(b => {
      summary[b] = group.reduce((sum, r) => sum + n(r[b]), 0);
    });
    result.push(summary);
  }
  return result;
};
