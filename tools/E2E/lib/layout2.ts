// 헤더 높이·중복 스크롤·헤더 잘림·조건 후보 '-'·ALL 조회·입력 중 재렌더 판정(2026-11-02 엔진 갭 EG325·EG326·EG327·EG459·EG254·EG263·EG419). 순수 함수 — layout2.selftest.js
export type J = { result: 'PASS' | 'FAIL' | 'ERROR' | 'NA' | '판정필요'; why: string };

/** 시점별 헤더 높이(px) — 1px 넘게 달라지면 FAIL */
// 2026-11-10 T216(SSP0015 v3 H4 '조회 전 48 · 조회 뒤 72' 허위 FAIL): 조회 뒤 동적 기간 컬럼(다단 헤더 연월/주/일)이 생기는 화면은 컬럼 구성이 바뀌어 헤더 높이가 바뀐다 —
//   요건 EG325 는 'Division 전환 뒤' 같은 컬럼 구성에서의 높이 유지. 시점별 컬럼 수(cols)가 있으면 마지막 시점과 컬럼 수가 같은 시점끼리만 비교한다
export function judgeHeaderHeight(s: { steps: { name: string; h: number; cols?: number }[] }): J {
  const all = s.steps.filter(x => x.h > 0); const last = all[all.length - 1];
  const ok = last && last.cols != null ? all.filter(x => x.cols == null || x.cols === last.cols) : all; const skipped = all.filter(x => !ok.includes(x));
  const sk = skipped.length ? ` · 컬럼 구성 다른 시점 제외: ${skipped.map(x => `${x.name} ${Math.round(x.h)}(컬럼 ${x.cols})`).join(', ')}(T216)` : '';
  if (ok.length < 2) return { result: skipped.length ? 'NA' : 'ERROR', why: skipped.length ? `같은 컬럼 구성에서 비교할 시점 ${ok.length}개 — Division 전환 단계 없음(고정·비활성 조건 등)${sk}` : `[측정 경로 없음] 헤더 높이 측정 ${ok.length}회` };
  const lo = Math.min(...ok.map(x => x.h)), hi = Math.max(...ok.map(x => x.h)); const txt = ok.map(x => `${x.name} ${Math.round(x.h)}`).join(' · ');
  return hi - lo > 1 ? { result: 'FAIL', why: `헤더 높이 변함 — ${txt}${sk}` } : { result: 'PASS', why: `헤더 높이 유지 — ${txt}${sk}` };
}

/** page 페이지 자체 세로 스크롤 · nested 그리드 바깥 스크롤 영역 */
export function judgeScroll(s: { page: boolean; nested: string[]; rows: number }): J {
  if (s.rows <= 0) return { result: 'ERROR', why: `[측정 경로 없음] 조회 0행 — 스크롤 판정 불가` };
  if (s.page) return { result: 'FAIL', why: `페이지 전체에 세로 스크롤바 — 그리드 밖으로 넘침` };
  if (s.nested.length) return { result: 'FAIL', why: `그리드 바깥에 스크롤 영역 ${s.nested.length}개: ${s.nested.slice(0, 3).join(', ')}` };
  return { result: 'PASS', why: `조회 ${s.rows}행 · 페이지·그리드 바깥 스크롤 없음` };
}

/** 헤더 글자 잘림 — seen 렌더된 헤더 수 · clipped 잘린 컬럼 */
export function judgeHeaderFit(s: { seen: number; clipped: string[] }): J {
  if (!s.seen) return { result: 'ERROR', why: `[측정 경로 없음] 렌더된 헤더 0` };
  // 2026-11-06 사용자 지시(SCP0016 2번 '오류아님, 판정 필요로 이관'): 헤더 글자 잘림은 칸 폭(메타 COLUMN_WIDTH)·사용자 조정 영역이라 기계가 결함으로 확정하지 않는다 → 판정필요
  if (s.clipped.length) return { result: '판정필요', why: `헤더 ${s.seen}개 중 글자 잘림 ${s.clipped.length}개: ${s.clipped.slice(0, 5).join(', ')} — 칸 폭(COLUMN_WIDTH) 확인 대상(사람 판정)` };
  return { result: 'PASS', why: `렌더된 헤더 ${s.seen}개 글자 잘림 0` };
}

/** 조회조건 콤보 후보 — 후보 전부가 '-'·'/' 인 조건 */
export function judgeCandDash(s: { fields: { name: string; opts: string[] }[] }): J {
  const f = s.fields.filter(x => x.opts.length);
  if (!f.length) return { result: 'NA', why: `후보를 읽을 콤보 조건 없음` };
  const bad = f.filter(x => x.opts.every(o => /^[-/]$/.test(o.trim())));
  if (bad.length) return { result: 'FAIL', why: `조건 ${bad.map(x => x.name).join(', ')} 후보가 '-'·'/' 일색` };
  return { result: 'PASS', why: `콤보 조건 ${f.length}개 후보 정상` };
}

/** ALL 상태 조회 — allFields ALL 인 조건 · sent 조회 요청 · dialog 뜬 안내 */
export function judgeAllSearch(s: { allFields: string[]; sent: boolean; dialog: string; rows: number }): J {
  if (!s.allFields.length) return { result: 'NA', why: `ALL 상태 조건 없음` };
  if (/필수|required|입력.*(하세요|주세요)|선택.*(하세요|주세요)|please (select|input|enter)/i.test(s.dialog)) return { result: 'FAIL', why: `ALL(${s.allFields.slice(0, 4).join(',')}) 조회에 필수 안내 '${s.dialog.slice(0, 60)}'` };
  if (!s.sent) return { result: 'ERROR', why: `[측정 경로 없음] ALL 조회 요청 없음${s.dialog ? ` · 알림 '${s.dialog.slice(0, 60)}'` : ''}` };
  return { result: 'PASS', why: `ALL(${s.allFields.slice(0, 4).join(',')}) 조회 ${s.rows}행 · 필수 안내 없음` };
}

/** 조건 입력 중 그리드 — idle 입력 없을 때 변화 수(대조군) · typing 입력 중 변화 수 · scroll 스크롤 이동 여부 */
export function judgeTypingStable(s: { typed: boolean; idle: number; typing: number; moved: boolean; why?: string }): J {
  if (s.why) return { result: 'ERROR', why: `[측정 경로 없음] ${s.why}` };
  if (!s.typed) return { result: 'NA', why: `글자 입력되는 텍스트 조건 없음` };
  if (s.moved) return { result: 'FAIL', why: `조건 입력 중 그리드 스크롤 이동` };
  if (s.typing > s.idle) return { result: 'FAIL', why: `조건 입력 중 그리드 재렌더 ${s.typing}회(입력 없을 때 ${s.idle}회)` };
  return { result: 'PASS', why: `조건 입력 중 그리드 변화 ${s.typing}회(입력 없을 때 ${s.idle}회) · 이동 없음` };
}

/** 값 필터 편집기 항목 — items 항목 문구(Select All 제외) · distinct 그리드 전 행 비지 않은 고유 표시값 수 · blanksInGrid 빈 칸 존재 (EG386·EG387) */
export function judgeFilterItems(s: { b: string; items: string[]; distinct: number; blanksInGrid: boolean; why?: string }): J {
  if (s.why) return { result: 'ERROR', why: `[측정 경로 없음] ${s.why}` };
  const blank = s.items.filter(t => !t.trim() || /^\(?(blanks?|공백|빈 ?값|\(blank\))\)?$/i.test(t.trim()));
  const vals = s.items.length - blank.length;
  if (blank.length > 1) return { result: 'FAIL', why: `${s.b} 필터 항목에 공란류 ${blank.length}개 — 1개여야 함` };
  if (vals < s.distinct) return { result: 'FAIL', why: `${s.b} 필터 값 항목 ${vals}개 < 그리드 고유값 ${s.distinct}개 — 후보 잘림` };
  return { result: 'PASS', why: `${s.b} 필터 값 항목 ${vals}개 = 고유값 ${s.distinct}개 · 공란류 ${blank.length}개(그리드 빈 칸 ${s.blanksInGrid ? '있음' : '없음'})` };
}

/** 연속 조회 본문 — same 조건 그대로 재조회 때 달라진 키 · changed 조건 하나 바꾼 뒤 달라진 키 · 조건 키는 1개까지 허용 (EG252·EG291) */
export function judgeBodyDiff(s: { sent: boolean; same: string[]; changed: string[]; typed: boolean; sent2?: boolean; label?: string; required?: string }): J {
  if (!s.sent) return { result: 'ERROR', why: `[측정 경로 없음] 조회 본문을 못 읽음` };
  if (s.same.length) return { result: 'FAIL', why: `조건 그대로 재조회인데 본문 키가 달라짐: ${s.same.slice(0, 5).join(', ')}` };
  if (!s.typed) return { result: 'PASS', why: `조건 그대로 재조회 본문 동일 · 글자 입력 조건 없어 변경 시험 미측정` };
  // 2026-11-06(SCP0016 3번): 바꾼 조건·조회 요청 여부·필수 알림을 증거에 남긴다 — 조건 변경 뒤 조회 요청이 안 나갔으면(필수 조건 알림 등) '본문 변화 없음' 이 아니라 그 사실로 적는다
  const at = s.label ? `'${s.label}' 에 'E2E' 입력 뒤 ` : '';
  if (s.sent2 === false) return { result: 'FAIL', why: `${at}조회 요청이 나가지 않음${s.required ? ` — 필수 조건 알림: ${s.required.slice(0, 160)}` : ''}` };
  if (!s.changed.length) return { result: 'FAIL', why: `${at}조회 본문 변화 없음(입력한 조건이 조회 인자로 전달되지 않음)${s.required ? ` · 필수 조건 알림: ${s.required.slice(0, 160)}` : ''}` };
  if (s.changed.length > 1) return { result: 'ERROR', why: `[확인 대상] 조건 1개 변경에 본문 키 ${s.changed.length}개 달라짐: ${s.changed.slice(0, 6).join(', ')}` };
  return { result: 'PASS', why: `재조회 본문 동일 · 조건 변경 시 키 ${s.changed[0]} 만 달라짐` };
}
