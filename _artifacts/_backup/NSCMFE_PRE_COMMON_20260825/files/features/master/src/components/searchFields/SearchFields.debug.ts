/* eslint-disable no-console -- 임시 로컬 디버그. 확인 끝나면 이 파일 + 호출부 삭제. */
// SearchFields cascade 디버그 — 아래 ON 을 false 로 바꾸면 조용해진다 (dev 서버에서만 동작).
//   [cascade] 콤보 원본 -> 단계별 필터 -> 최종 옵션. 어느 단계에서 몇 건이 잘렸는지 본다.
//   [reset]   상위 조회조건 변경으로 하위 값이 재세팅된 시점 + 이전값/새값.
// 찍히는 대상은 debugLabel prop 을 넘긴 호출부뿐이라 다른 화면은 조용하다.
//
// console.group 은 안 쓴다 (브라우저에 따라 펼쳐도 내용이 안 보이는 사례가 있었다).
// 리스트는 최상위에서 배열로 찍어 접었다 펼친다. 표로 보려면 AS_TABLE = true.

const ON = true;

/** true = console.table(표, 항상 펼침) / false = 배열(펼침 토글) */
const AS_TABLE = false;

const off = (): boolean => !ON || !import.meta.env.DEV;

type Row = Record<string, string>;

const SEP = '='.repeat(40);

/** 필터 기준값 표시 — null(미적용)과 실제 값 목록을 구분해서 보여준다. */
const showFilter = (filter: Set<string> | null): string =>
  filter === null ? '(미적용 = ALL)' : `[${[...filter].join(', ')}]`;

const list = (title: string, rows: Row[], keys: string[]): void => {
  const cols = [...new Set(['CODE', 'NAME', ...keys])];
  const view = rows.map(r => Object.fromEntries(cols.map((k): [string, string] => [k, r[k] ?? ''])));
  const label = `  ${title} — ${rows.length}건`;
  if (AS_TABLE) {
    console.warn(label);
    console.table(view);
  } else {
    console.warn(label, view); // 리스트는 노란색(warn) 으로 — 설명 줄과 구별
  }
};

// ============================================================================
// [cascade] 콤보 원본 -> 단계별 필터 -> 최종 옵션
// ============================================================================
export const logCascade = (opts: {
  /** 호출 화면 식별자 (debugLabel prop). */
  label: string;
  /** 실제 조회한 콤보 ID. */
  comboId: string;
  /** 콤보에 보낸 파라미터 (서버 바인드 경로에서만 값이 있다). */
  param?: string;
  division?: string;
  /** 단계별 스냅샷 — 순서대로 좁혀진 결과. strict = 공란 행도 잘랐는지. */
  steps: { column: string; filter: Set<string> | null; strict?: boolean; rows: Row[] }[];
  /** 콤보 원본 (필터 전). */
  rawRows: Row[];
  /** CustomDropdown 에 최종으로 들어간 옵션. */
  options: { label: string; value: string }[];
}): void => {
  if (off()) return;
  const { label, comboId, param, division, steps, rawRows, options } = opts;
  const keys = ['DIVISION_ID', ...steps.map(s => s.column)];
  // 매칭 방식을 같이 찍는다 — "필터를 걸었는데 목록이 안 줄어든다" 의 원인은 대개 관대 매칭이다
  // (공란 행 통과). 단계 이름 옆 [엄격]/[관대] 를 먼저 본다.
  const chain = steps
    .map(
      s =>
        `${s.column}[${s.strict ? '엄격' : '관대'}]=${showFilter(s.filter)} -> ${s.rows.length}건`
    )
    .join('\n    ');
  console.log(
    `${SEP}\n[cascade] ${label} (${comboId})\n${SEP}\n` +
      `  전송 파라미터: ${param ?? '(없음)'}\n` +
      `  콤보 원본: ${rawRows.length}건\n` +
      `    ${chain}\n` +
      `  CODE 중복제거 -> 최종 옵션 ${options.length}건  (division='${division ?? ''}')`
  );
  list('콤보 원본', rawRows, keys);
  steps.forEach(s =>
    list(
      `${s.column}[${s.strict ? '엄격 — 공란 행도 자름' : '관대 — 공란 행 통과'}] 필터 후 ${showFilter(s.filter)}`,
      s.rows,
      keys
    )
  );
  console.warn(`  최종 옵션 — ${options.length}건`, options);
};

// ============================================================================
// [reset] 상위 조회조건 변경 -> 하위 값 재세팅
// ============================================================================
export const logSearchReset = (opts: {
  label: string;
  /** 사용자가 직접 바꾼 항목. */
  changed: { field: string; from: string; to: string };
  /** 그 때문에 같이 초기화되는 항목들. */
  resets: { field: string; from: string; to: string }[];
}): void => {
  if (off()) return;
  const { label, changed, resets } = opts;
  const body = resets
    .map(r => `    ${r.field}: '${r.from}' -> '${r.to}'${r.from === r.to ? '  (변화 없음)' : ''}`)
    .join('\n');
  console.log(
    `[reset] ${label} — ${changed.field}: '${changed.from}' -> '${changed.to}'\n` +
      (resets.length > 0 ? `  같이 재세팅:\n${body}` : '  같이 재세팅되는 항목 없음')
  );
};
