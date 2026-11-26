// 2026-11-20 T496(SCP0028 K3 V-4c3670c9·V-cbcda052·V-6cf2af49·V-729c8d58 '미포함: 팝업 그리드(이 시험은 메인 그리드만)'):
//   K3 그리드 조작 시험이 팝업 그리드를 재지 않아 행 문구에 '팝업'이 있으면 ERROR 로 남았다.
//   화면의 팝업(조회조건 돋보기 칸 · AS-IS 가 팝업을 여는 버튼)을 열어 잰 값을 이 순수 판정으로 묶는다(브라우저 조작 없음 · popk3.selftest.js 변이 입증).
//   판정 원칙: 팝업 그리드 0행·열리지 않음·재지 못함 = ERROR(결함 없음 아님) · 팝업 없음은 AS-IS 팝업 호출 0건 근거가 있을 때만 NA
export type K3R = 'PASS' | 'FAIL' | 'ERROR' | 'NA';
export type PopK3 = {
  name: string;            // 팝업을 연 경로(조건 'Model/Nickname' 아이콘 · 버튼 'Input')
  title: string;           // 팝업 제목
  opened: boolean;
  cond?: boolean;          // 조회조건 팝업 칸에서 연 팝업(값 고르기 OK 허용)
  why?: string;            // 열기·준비 실패 사유
  grid: boolean;           // 팝업 안 그리드 있음
  rows: number;            // 측정 시점 팝업 그리드 행 수
  fill?: string;           // 0행이라 조회조건을 채워 다시 조회한 내역
  hasSearch?: boolean;     // 팝업 안 조회(Search) 버튼 있음
  no?: { corner: string[]; firstHdr: string; n: number } | null;
  count?: string | null;   // 건수 문구('' = 없음 · null = 재지 않음)
  ctrl?: { ok: boolean; rs: string; why?: string } | null;
  shift?: { ok: boolean; rs: string; why?: string } | null;  // Shift+클릭 연속 선택
  f5?: { pop: number; main: number; nav: number; sheets: string; why?: string } | null;
  sort?: { on: boolean; s1: string; s2: string; why?: string } | null;
  filter?: { n0: number; n1: number; n2: number; count1: string; why: string } | null;
  pickf5?: { picked: boolean; main: number; nav: number; why?: string } | null;  // 조건 팝업에서 값을 고른 직후 메인 F5
};
export type K3Key = 'ctrl' | 'shift' | 'f5' | 'no' | 'count' | 'sort' | 'filter' | 'pickf5';

const one = (p: PopK3, k: K3Key): { res: K3R; ev: string } => {
  const nm = `${p.name}${p.title ? `('${p.title.slice(0, 30)}')` : ''}`;
  if (!p.opened) return { res: 'ERROR', ev: `${nm} 팝업 열리지 않음${p.why ? ` · ${p.why}` : ''}` };
  if (!p.grid) return { res: 'NA', ev: `${nm} 팝업에 그리드 없음` };
  if (k === 'pickf5') {
    if (!p.cond) return { res: 'NA', ev: `${nm} 값 선택형 조건 팝업 아님(버튼 팝업은 OK 를 누르지 않음)` };
    if (p.rows <= 0) return { res: 'ERROR', ev: `${nm} 팝업 그리드 0행${p.fill ? `(조회 시도: ${p.fill})` : ''} · 고를 값 없음` };
    const q = p.pickf5; if (!q) return { res: 'ERROR', ev: `${nm} 값 고른 직후 F5 측정 안 됨` };
    if (q.why) return { res: 'ERROR', ev: `${nm} 값 고른 직후 F5: ${q.why}` };
    if (!q.picked) return { res: 'ERROR', ev: `${nm} 팝업에서 값을 고르지 못함(팝업 ${p.rows}행) · 고른 직후 F5 측정 불가` };
    return { res: q.main > 0 && q.nav === 0 ? 'PASS' : 'FAIL', ev: `${nm} 값 고른 직후 메인 F5 → 조회 호출 ${q.main}건 · 페이지 이동 ${q.nav}회${q.nav ? ' · 브라우저 새로고침' : q.main ? '' : ' · 조회 미실행'}` };
  }
  if (p.rows <= 0) return { res: 'ERROR', ev: `${nm} 팝업 그리드 0행${p.fill ? `(조회 시도: ${p.fill})` : ''} · 0행은 결함 없음이 아님(측정 재료 없음)` };
  if (k === 'no') {
    const q = p.no; if (!q) return { res: 'ERROR', ev: `${nm} No. 컬럼 측정 실패` };
    return { res: q.n === 1 ? 'PASS' : 'FAIL', ev: `${nm} No. 컬럼 ${q.n}개(코너 [${q.corner.join(',')}] · 첫 컬럼 '${q.firstHdr}')${q.n === 1 ? '' : q.n ? ' · No. 중복' : ' · 왼쪽 No. 컬럼 없음'}` };
  }
  if (k === 'count') {
    if (p.count == null) return { res: 'ERROR', ev: `${nm} 건수 문구 측정 실패` };
    return { res: p.count ? 'PASS' : 'FAIL', ev: `${nm} 건수 표시 ${p.count ? `'${p.count}'` : '없음'}(${p.rows}행)` };
  }
  if (k === 'ctrl') {
    if (p.rows < 3) return { res: 'ERROR', ev: `${nm} 팝업 ${p.rows}행 · 비연속 다중 선택 시험에 3행 필요${p.fill ? `(조회 시도: ${p.fill})` : ''}` };
    const q = p.ctrl; if (!q || q.why) return { res: 'ERROR', ev: `${nm} Ctrl+클릭 측정 실패${q && q.why ? `: ${q.why}` : ''}` };
    return { res: q.ok ? 'PASS' : 'FAIL', ev: `${nm} Ctrl+클릭 0행·2행 → 선택 ${q.rs}${q.ok ? ' · 비연속 다중 선택' : ' · 비연속 다중 선택 안 됨'}` };
  }
  if (k === 'shift') {
    if (p.rows < 3) return { res: 'ERROR', ev: `${nm} 팝업 ${p.rows}행 · 연속 선택 시험에 3행 필요${p.fill ? `(조회 시도: ${p.fill})` : ''}` };
    const q = p.shift; if (!q || q.why) return { res: 'ERROR', ev: `${nm} Shift+클릭 측정 실패${q && q.why ? `: ${q.why}` : ''}` };
    return { res: q.ok ? 'PASS' : 'FAIL', ev: `${nm} Shift+클릭·드래그 0행→2행 → ${q.rs}${q.ok ? ' · 연속 선택' : ' · 연속 선택 안 됨'}` };
  }
  if (k === 'f5') {
    if (p.hasSearch === false) return { res: 'NA', ev: `${nm} 팝업에 조회 버튼 없음 · 팝업 F5 대상 아님` };
    const q = p.f5; if (!q || q.why) return { res: 'ERROR', ev: `${nm} 팝업 F5 측정 실패${q && q.why ? `: ${q.why}` : ''}` };
    const ok = q.pop > 0 && q.nav === 0;
    return { res: ok ? 'PASS' : 'FAIL', ev: `${nm} 팝업 그리드 포커스 F5 → 팝업 조회 호출 ${q.pop}건 · 메인 조회 ${q.main}건 · 페이지 이동 ${q.nav}회(${q.sheets || '-'})${ok ? '' : q.nav ? ' · 브라우저 새로고침' : q.main ? ' · 팝업 대신 메인 조회 실행' : ' · 팝업 조회 미실행'}` };
  }
  if (k === 'sort') {
    if (p.rows < 2) return { res: 'ERROR', ev: `${nm} 팝업 ${p.rows}행 · 정렬 효과 대조 불가` };
    const q = p.sort; if (!q || q.why) return { res: 'ERROR', ev: `${nm} 팝업 Sort 측정 실패${q && q.why ? `: ${q.why}` : ''}` };
    const ok = q.on && !!q.s1 && q.s1 !== q.s2;
    return { res: ok ? 'PASS' : 'FAIL', ev: `${nm} F3 + 머리글 2회 → 정렬 스위치 ${q.on} · 1회 '${q.s1 || '정렬 없음'}' · 2회 '${q.s2 || '정렬 없음'}'${ok ? '' : ' · 정렬 토글 안 됨'}` };
  }
  // filter
  const q = p.filter; if (!q) return { res: 'ERROR', ev: `${nm} 팝업 Filter 측정 실패` };
  if (p.rows < 2) return { res: 'ERROR', ev: `${nm} 팝업 ${p.rows}행 · 필터 대조 불가` };
  if (q.why) return { res: 'ERROR', ev: `${nm} 팝업 F4 필터: ${q.why}` };
  const ok = q.n1 > 0 && q.n1 < q.n0 && q.n2 === q.n0 && !!q.count1;
  return { res: ok ? 'PASS' : 'FAIL', ev: `${nm} F4 필터 → 행 ${q.n0}→${q.n1}→${q.n2} · 필터 후 건수 '${q.count1}'${ok ? '' : !q.count1 ? ' · 필터 후 건수 표시 없음' : ' · 필터 적용·해제 행 수 이상'}` };
};

/** 팝업별 측정을 행 문구 항목(keys)으로 묶는다. asisPops = AS-IS 가 여는 팝업 클래스(근거 · 0건이고 TO-BE 팝업도 0건일 때만 NA) */
export function judgePopK3(pops: PopK3[], keys: K3Key[], asisPops: string[], why = ''): { res: K3R; ev: string } {
  if (!keys.length) return { res: 'NA', ev: '팝업 측정 항목 없음' };
  if (!pops.length) {
    if (why) return { res: 'ERROR', ev: `팝업 측정 실패: ${why}` };
    if (!asisPops.length) return { res: 'NA', ev: '팝업 없음 · AS-IS 팝업 호출 0건 · TO-BE 조회조건 팝업 칸·팝업 버튼 0건' };
    return { res: 'ERROR', ev: `AS-IS 팝업 ${asisPops.join(', ')} 이 있는데 TO-BE 에서 연 팝업 0건 · 팝업 경로 못 찾음` };
  }
  const parts: { res: K3R; ev: string }[] = [];
  for (const k of keys) for (const p of pops) parts.push(one(p, k));
  const live = parts.filter(x => x.res !== 'NA');
  const res: K3R = !live.length ? 'NA' : live.some(x => x.res === 'FAIL') ? 'FAIL' : live.some(x => x.res === 'ERROR') ? 'ERROR' : 'PASS';
  return { res, ev: `팝업 ${pops.length}개: ${parts.map(x => `${x.res} ${x.ev}`).join(' / ')}` };
}

/** 행 문구에서 팝업 측정 항목을 고른다 */
export function popK3Keys(text: string): K3Key[] {
  const t = String(text || '');
  if (!/팝업|popup/i.test(t)) return [];
  const k: K3Key[] = [];
  if (/Ctrl/i.test(t)) k.push('ctrl');
  if (/Shift|드래그|연속 선택/i.test(t)) k.push('shift');
  if (/F5|단축키/.test(t)) k.push('f5');
  if (/No\.|No 컬럼|번호/.test(t)) k.push('no');
  if (/건수/.test(t)) k.push('count');
  if (/Sort|정렬/i.test(t)) k.push('sort');
  if (/Filter|필터/i.test(t)) k.push('filter');
  // 팝업에서 값을 고른 직후 F5(메인 조회)를 묻는 행은 팝업 안 F5 가 아니라 고른 뒤 메인 F5 를 잰다
  if (/(고른|선택한|선택 한)\s*(직후|뒤|후)/.test(t) && /F5|조회/.test(t)) { const i = k.indexOf('f5'); if (i >= 0) k.splice(i, 1); k.push('pickf5'); }
  return k;
}
