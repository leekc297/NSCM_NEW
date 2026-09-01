/* eslint-disable no-console -- 임시 로컬 디버그. 확인 끝나면 이 파일 통째로 삭제. */
// DMF0003 콤보 디버그 — 아래 ON 을 true 로 바꾸면 콘솔에 찍힌다 (dev 서버에서만 동작).
//   [조회] division 기준으로 그리드에 셋팅된 콤보 — 컬럼별 전체 리스트 + division 필터 후 리스트
//   [Insert] 행 편집 진입 시 — 그 행의 어떤 값에 종속돼 리스트가 좁혀졌는지 + 좁혀진 리스트
//   ※ 임시 로컬 디버그. 확인 끝나면 이 파일 + MktFcstGrid 의 logCombo* 호출 삭제.
//
// console.group 은 안 쓴다 (그룹 안에 넣으면 브라우저에 따라 펼쳐도 내용이 안 보였다).
// 리스트는 최상위에서 배열로 찍어 ▶ 로 접었다 펼쳤다 한다. 표로 보고 싶으면 AS_TABLE = true.
import { filterComboRowsByRow, GRID_CASCADE_FILTERS } from './mkt-fcst.gridCombos';
import { toCellStr } from './mkt-fcst.prContext';

const ON = false;

// 검색조건(Sales Site) 콤보 로그 스위치. 그리드 로그(ON)와 따로 켠다.
//   확인 끝나면 false 로 되돌리거나 이 파일 + MktFcstForm 의 logSearchSalesSite 호출을 지운다.
const ON_SEARCH = false;

/** true = console.table(표, 항상 펼침) / false = 배열(▶ 로 접었다 펼쳤다) */
const AS_TABLE = false;

const off = (): boolean => !ON || !import.meta.env.DEV;
const offSearch = (): boolean => !ON_SEARCH || !import.meta.env.DEV;

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
