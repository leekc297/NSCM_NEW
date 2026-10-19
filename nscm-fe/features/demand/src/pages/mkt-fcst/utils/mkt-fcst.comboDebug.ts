/* eslint-disable no-console -- 임시 로컬 디버그. 확인 끝나면 이 파일 통째로 삭제. */
// DMF0003 콤보 디버그 — 아래 ON 을 true 로 바꾸면 콘솔에 찍힌다 (dev 서버에서만 동작).
//   [조회] division 기준으로 그리드에 셋팅된 콤보 — 컬럼별 전체 리스트 + division 필터 후 리스트
//   [Insert] 행 편집 진입 시 — 그 행의 어떤 값에 종속돼 리스트가 좁혀졌는지 + 좁혀진 리스트
//   ※ 임시 로컬 디버그. 확인 끝나면 이 파일 + MktFcstGrid 의 logCombo* 호출 삭제.
//
// console.group 은 안 쓴다 (그룹 안에 넣으면 브라우저에 따라 펼쳐도 내용이 안 보였다).
// 리스트는 최상위에서 배열로 찍어 ▶ 로 접었다 펼쳤다 한다. 표로 보고 싶으면 AS_TABLE = true.
import { parseComboFilterBindings } from '@foundation/utils';

import { filterComboRowsByRow, GRID_CASCADE_FILTERS } from './mkt-fcst.gridCombos';
import { toCellStr } from './mkt-fcst.prContext';

const ON = false;

// 검색조건(Sales Site) 콤보 로그 스위치. 그리드 로그(ON)와 따로 켠다.
//   확인 끝나면 false 로 되돌리거나 이 파일 + MktFcstForm 의 logSearchSalesSite 호출을 지운다.
const ON_SEARCH = false;

// 메타 이관 콤보(END_CUSTOMER/END_CUSTOMER40/SCM_SITE_ID/SCM_SITE_ID40) 로그 스위치.
//   2026-09-03 이관 검증 중이라 기본 true — 컬럼당 4줄, 컬럼 메타가 바뀔 때만 찍혀 양이 적다.
//   서버에 실제로 등록된 PARAM2/9/10 을 봐야 "좁힘이 안 걸린다 / 재조회가 안 나간다" 를 가를 수
//   있어서 켜 둔다. 검증이 끝나면 false 로 되돌린다.
const ON_META = false;

/** true = console.table(표, 항상 펼침) / false = 배열(▶ 로 접었다 펼쳤다) */
const AS_TABLE = false;

const off = (): boolean => !ON || !import.meta.env.DEV;
const offSearch = (): boolean => !ON_SEARCH || !import.meta.env.DEV;
const offMeta = (): boolean => !ON_META || !import.meta.env.DEV;

type Row = Record<string, unknown>;

/** 리스트 한 블록. CODE/NAME + 필터에 쓰이는 키만 추려서 찍는다. */
const list = (title: string, rows: Row[], keys: string[]): void => {
  const cols = [...new Set(['CODE', 'NAME', ...keys])];
  const view = rows.map(r =>
    Object.fromEntries(cols.map((k): [string, string] => [k, toCellStr(r[k])]))
  );
  const label = `  ${title} — ${rows.length}건`;
  if (AS_TABLE) {
    console.warn(label);
    console.table(view);
  } else {
    console.warn(label, view); // 리스트는 노란색(warn)으로 — 헤더/설명 줄과 구별
  }
};

const SEP = '='.repeat(40);

// ============================================================================
// [조회] division 값으로 셋팅된 그리드 콤보 — 컬럼별 전체 / division 필터 후
// ============================================================================
export const logComboSetup = (
  kind: '조회 표시' | '편집 전용',
  division: string,
  columns: { binding: string; comboId: string; param?: string; rows: Row[] }[]
): void => {
  if (off()) return;
  console.log(`${SEP}\n[콤보 ${kind}] division='${division}' — ${columns.length}개 컬럼\n${SEP}`);
  columns.forEach(({ binding, comboId, param, rows }) => {
    // 이 컬럼이 어떤 컬럼 값에 종속되는지 (cascade 정의). 조회 시점엔 행이 없으므로 DIVISION_ID 만 적용.
    const deps = GRID_CASCADE_FILTERS[binding] ?? [];
    const keys = deps.map(d => d.comboKey);
    const byDivision =
      deps.length > 0 ? filterComboRowsByRow(rows, { DIVISION_ID: division }, deps) : rows;
    const head = `[콤보 ${kind}] ${binding} (${comboId})`;
    const cnt = `전체 ${rows.length}건 → division='${division}' 필터 ${byDivision.length}건`;
    console.log(
      `${head} — ${cnt}\n` +
        `  전송 파라미터: ${param ?? '(없음)'}\n` +
        (deps.length > 0
          ? `  종속 컬럼: ${deps.map(d => `행.${d.rowKey} = 콤보.${d.comboKey}`).join('  /  ')}`
          : '  종속 컬럼 없음 (행 값과 무관하게 전체 노출)')
    );
    list('전체 리스트', rows, keys);
    if (deps.length > 0) list(`division='${division}' 필터 리스트`, byDivision, keys);
  });
  console.log(`${SEP}\n[콤보 ${kind}] 끝 — division='${division}'\n${SEP}`);
};

// ============================================================================
// [메타 이관] 공용 DataGrid 가 콤보를 전담하는 컬럼(META_DRIVEN_COMBO_COLUMNS) — 서버에서
//   실제로 도착한 PARAM2/9/10 을 그대로 찍는다. 값이 비어 있거나 '행컬럼:콤보컬럼' 형식이
//   아니면 columnMapping 이 그 선언을 통째로 버려 좁힘이 조용히 사라지므로, 이관 검증은
//   이 로그로 시작한다.
// ============================================================================
export const logMetaCombo = (
  columns: {
    binding: string;
    comboId?: string;
    param2?: string;
    param9?: string;
    param10?: string;
  }[],
  /** 그리드에 실제로 있는 컬럼 binding 전체. PARAM2 의 행컬럼이 여기 없으면 그 선언은 죽은 선언이다. */
  gridBindings: string[] = []
): void => {
  if (offMeta()) return;
  const known = new Set(gridBindings);
  console.log(`${SEP}\n[콤보 메타 이관] ${columns.length}개 컬럼 — 도착한 컬럼 메타\n${SEP}`);
  columns.forEach(({ binding, comboId, param2, param9, param10 }) => {
    const bindings = parseComboFilterBindings(param2);
    const isD = (param10 ?? '').trim().toUpperCase() === 'D';
    const declared = Object.entries(bindings)
      .map(([rowCol, key]) => {
        // 재조회(D)는 오른쪽이 콤보 SQL 바인드명, 필터는 콤보 결과 컬럼명이다.
        const arrow = isD ? `@${key}` : `콤보.${key}`;
        // 왼쪽(행 컬럼)이 그리드에 없으면 그 행 값을 실을 수도, 변경을 감지할 수도 없다 —
        //   재조회형에서는 이게 곧 "상위를 바꿔도 재조회가 안 나간다" 의 원인이다.
        const miss = known.size > 0 && !known.has(rowCol) ? '  <== 그리드에 없는 컬럼' : '';
        return `행.${rowCol} → ${arrow}${miss}`;
      })
      .join('\n           ');
    const deadRowCols = Object.keys(bindings).filter(
      rowCol => known.size > 0 && !known.has(rowCol)
    );
    console.log(
      `[콤보 메타] ${binding} (${comboId ?? '-'}) — ${isD ? '재조회(D)' : '필터'}\n` +
        `  PARAM2 : ${param2 ?? '(없음)'}${
          param2 && Object.keys(bindings).length === 0
            ? '  <== 형식 불일치 → 좁힘 선언 전체 무시됨'
            : ''
        }\n` +
        `  해석   : ${declared || '(좁힘 없음)'}\n` +
        `  PARAM9 : ${param9 ?? '(없음 — 신규행도 조회 콤보 그대로)'}\n` +
        `  PARAM10: ${param10 ?? '(없음)'}` +
        (deadRowCols.length > 0
          ? `\n  경고   : 행컬럼 [${deadRowCols.join(', ')}] 이 이 그리드에 없다.` +
            `${isD ? ' 그 컬럼을 바꿔도 재조회가 나가지 않는다.' : ' 그 조건은 항상 통과된다.'}`
          : '')
    );
  });
  console.log(`${SEP}\n[콤보 메타 이관] 끝\n${SEP}`);
};

// ============================================================================
// [메타 이관 - 편집 진입] 드롭다운이 왜 비었는지 조건 단위로 가른다.
//   columnMapping.filterComboRowsByRowItem 은 조건을 AND 로 걸고, "행 값이 공란" 일 때만 그 조건을
//   건너뛴다 — 화면 코드 cascade 에 있던 "콤보 쪽 값이 공란/컬럼 없음이면 통과" 가 없다. 그래서
//   콤보 응답이 좁힘 기준 컬럼을 안 내려주면 후보가 통째로 0건이 된다. 어느 조건이 죽이는지
//   조건별 생존 수로 바로 보이게 찍는다.
// ============================================================================
export const logMetaComboEdit = (opts: {
  binding: string;
  comboId?: string;
  param2?: string;
  /** 편집 진입한 행. PARAM2 왼쪽 컬럼 값을 여기서 읽는다. */
  rowItem: Row;
  /** 컬럼 dataMap 이 들고 있는 콤보 응답 전량 (조회 콤보 + PARAM9 신규행 콤보 합집합). */
  allRows: Row[];
  /** 실제로 드롭다운에 뜬 후보 이름. */
  candidates: string[];
  /** 신규행인가 — PARAM9 가 있으면 신규행만 그 콤보를 본다. */
  isInsert: boolean;
}): void => {
  if (offMeta()) return;
  const { binding, comboId, param2, rowItem, allRows, candidates, isInsert } = opts;
  const bindings = Object.entries(parseComboFilterBindings(param2));
  const sampleKeys = allRows.length > 0 ? Object.keys(allRows[0]) : [];
  console.log(
    `[콤보 메타 편집] ${binding} (${comboId ?? '-'}) — 신규행=${isInsert}\n` +
      `  콤보 응답 : ${allRows.length}건 / 드롭다운 후보 : ${candidates.length}건\n` +
      `  응답 컬럼 : ${sampleKeys.join(', ') || '(응답 0건 — 컬럼 확인 불가)'}\n` +
      `  PARAM2   : ${param2 ?? '(없음)'}`
  );
  if (bindings.length === 0) {
    console.warn('  좁힘 조건 없음 — 응답 전량이 후보다.');
  }
  // 조건 하나씩 단독으로 걸어 본다. 어느 줄에서 생존이 0 이 되는지가 곧 원인이다.
  bindings.forEach(([rowCol, comboCol]) => {
    const rowVal = toCellStr(rowItem[rowCol]).trim();
    const hasKey = sampleKeys.includes(comboCol);
    const survive =
      rowVal === '' ? allRows.length : allRows.filter(r => rowItem[rowCol] === r[comboCol]).length;
    const verdict =
      rowVal === ''
        ? '행 값 공란 → 이 조건 건너뜀'
        : !hasKey
          ? '콤보 응답에 이 컬럼이 없음 → 전건 탈락 (원인)'
          : survive === 0
            ? '값이 하나도 안 맞음 → 전건 탈락 (원인)'
            : '정상';
    console.warn(
      `  조건 [행.${rowCol}='${rowVal}' = 콤보.${comboCol}] 단독 생존 ${survive}건 — ${verdict}`
    );
  });
  list('콤보 응답 전량', allRows, [...new Set(bindings.map(([, comboCol]) => comboCol))]);
};

// ============================================================================
// [Insert] 행 편집 진입 — 그 행의 어떤 값 때문에 리스트가 바뀌었는지
// ============================================================================
export const logComboEdit = (opts: {
  binding: string;
  /** 이 셀에 실제로 물린 콤보 ID (편집 콤보 스왑되면 편집 콤보 ID). */
  comboId: string;
  /** 그 콤보를 조회할 때 실제로 보낸 파라미터(JSON). */
  param?: string;
  /** 이 컬럼이 종속된 값 설명 (예: "행.DIVISION_ID='81' / 행.END_CUSTOMER='C001'"). */
  dependsOn: string;
  before: Row[];
  after: Row[];
  keys?: string[];
}): void => {
  if (off()) return;
  const { binding, comboId, param, dependsOn, before, after, keys = [] } = opts;
  console.log(
    `[콤보 Insert행] ${binding} (${comboId}) — ` +
      `필터 전 ${before.length}건 → 편집 후보 ${after.length}건\n` +
      `  전송 파라미터: ${param ?? '(없음)'}\n` +
      `  종속: ${dependsOn || '없음'}`
  );
  list('편집 후보 리스트', after, keys);
  list('필터 전 전체', before, keys);
};

// ============================================================================
// [검색조건] Sales Site 콤보 — 앞 조건(Division/Team/End Customer)이 바뀔 때마다
//   어떤 콤보 SQL ID 가 선택됐고 서버에 무엇을 보냈는지, 결과가 몇 건인지 찍는다.
// ============================================================================
export const logSearchSalesSite = (opts: {
  division: string;
  deptIds: string[];
  endCustomers: string[];
  /** 실제로 호출한 콤보 SQL ID. */
  comboId: string;
  /** 그 ID 가 선택된 이유 (AS-IS 이벤트 환산). */
  reason: string;
  /** 서버로 보낸 파라미터 그대로 (값의 따옴표까지 보이게 찍는다). */
  param: Record<string, string>;
  /** End Customer 드롭다운에 실제로 걸린 옵션. */
  endCustomerOptions: { label: string; value: string }[];
  /** Sales Site 콤보 응답. undefined = 아직 로딩 중. */
  salesSiteRows?: Row[];
}): void => {
  if (offSearch()) return;
  const { division, deptIds, endCustomers, comboId, reason, param } = opts;
  const rows = opts.salesSiteRows;
  const paramText = Object.entries(param)
    .map(([k, v]) => `${k}=${v}`)
    .join('  ');
  const lines = [
    SEP,
    `[검색조건 Sales Site] 콤보 SQL ID = ${comboId}`,
    SEP,
    `  선택 이유         : ${reason}`,
    `  Division          : '${division}'`,
    `  Team              : [${deptIds.join(',') || '미선택'}]`,
    `  End Customer      : [${endCustomers.join(',') || '미선택'}]`,
    `  전송 파라미터     : ${paramText}`,
    `  End Customer 옵션 : ${opts.endCustomerOptions.length}건`,
    `  Sales Site 결과   : ${rows === undefined ? '(로딩 중)' : `${rows.length}건`}`,
  ];
  console.log(lines.join('\n'));
  if (rows !== undefined) {
    list('Sales Site 리스트', rows, ['DIVISION_ID', 'DEPT_ID', 'END_CUSTOMER']);
  }
};
