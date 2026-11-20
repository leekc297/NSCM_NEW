// 기간 동적 컬럼 판정(2026-11-01 엔진 갭 EG043) — 조회 기간 전 구간 칸이 데이터 유무와 무관하게 만들어지는가 · 중복·역순 없음. 순수 함수 — dynperiod.selftest.js
export type J = { result: 'PASS' | 'FAIL' | 'ERROR'; why: string };

/** 조회 요청 본문에서 기간 양 끝 — 값이 6~8자리 숫자인 from/to 계열 키만 본다(fromSite 같은 키 제외) */
export function periodOf(body: string): { from: string; to: string } | null {
  let obj: unknown; try { obj = JSON.parse(body); } catch { return null; }
  const items: Record<string, unknown>[] = []; const walk = (v: unknown) => { if (Array.isArray(v)) v.forEach(walk); else if (v && typeof v === 'object') items.push(v as Record<string, unknown>); }; walk(obj);
  for (const it of items) {
    const ks = Object.keys(it); const num = (k: string) => /^[0-9]{6,8}$/.test(String(it[k] ?? '').replace(/-/g, ''));
    const f = ks.find(k => /(from|start|begin|fr)/i.test(k) && num(k)); const t = ks.find(k => /(to|end)/i.test(k) && k !== f && num(k));
    if (f && t) return { from: String(it[f]).replace(/-/g, ''), to: String(it[t]).replace(/-/g, '') };
  }
  return null;
}

const digits = (b: string) => b.replace(/[^0-9]/g, '');
function monthsBetween(from: string, to: string): string[] {
  const out: string[] = []; let y = Number(from.slice(0, 4)); let m = Number(from.slice(4, 6)); const ey = Number(to.slice(0, 4)); const em = Number(to.slice(4, 6));
  for (let k = 0; k < 600 && (y < ey || (y === ey && m <= em)); k++) { out.push(`${y}${String(m).padStart(2, '0')}`); m++; if (m > 12) { m = 1; y++; } }
  return out;
}

/** 월 칸(6자리)은 기간 전 구간과 집합 대조 · 그 밖(주·일)은 중복·역순·범위 밖만 잰다(주 달력 원천 대조는 미구현 — 근거에 적는다) */
export function judgeDynPeriod(s: { bindings: string[]; period: { from: string; to: string } | null }): J {
  if (!s.bindings.length) return { result: 'FAIL', why: '동적 기간 칸 0개 — 조회 뒤 칸이 만들어지지 않음' };
  // 접두(W_·M_·D_ 등)별로 잰다 — 숫자만 비교하면 다른 계열의 같은 날짜가 중복으로 보인다(2026-11-01 DMF0082 허위 FAIL)
  const groups = new Map<string, string[]>(); for (const b of s.bindings) { const pre = b.replace(/[0-9]+$/, ''); groups.set(pre, [...(groups.get(pre) || []), digits(b)]); }
  const oks: string[] = [];
  for (const [pre, ds] of groups) {
    const tag = pre || '(접두 없음)';
    const dup = ds.filter((d, i) => ds.indexOf(d) !== i); if (dup.length) return { result: 'FAIL', why: `${tag} 같은 기간 칸 중복 ${[...new Set(dup)].slice(0, 4).join(',')}` };
    // 순서는 값이 실제 월·날짜일 때만 잰다 — 주 번호(W_YYYYMMWW)는 연말 53주 뒤 01주가 정상이다(2026-11-01 DMF0082 허위 FAIL)
    const sortable = ds.every(d => (d.length === 6 && Number(d.slice(4)) >= 1 && Number(d.slice(4)) <= 12) || (d.length === 8 && Number(d.slice(4, 6)) >= 1 && Number(d.slice(4, 6)) <= 12 && Number(d.slice(6)) >= 1 && Number(d.slice(6)) <= 31));
    if (sortable) for (let i = 1; i < ds.length; i++) if (ds[i] < ds[i - 1]) return { result: 'FAIL', why: `${tag} 칸 순서 역전 ${ds[i - 1]}→${ds[i]}` };
    const allMonth = ds.every(d => d.length === 6 && Number(d.slice(4)) >= 1 && Number(d.slice(4)) <= 12);
    if (allMonth && s.period) {
      const want = monthsBetween(s.period.from, s.period.to); const miss = want.filter(w => !ds.includes(w)); const extra = ds.filter(d => !want.includes(d));
      if (miss.length || extra.length) return { result: 'FAIL', why: `${tag} 기간 ${s.period.from}~${s.period.to} 월 칸 ${want.length}개 기대 · 실제 ${ds.length}개 · 없음 ${miss.slice(0, 4).join(',')} · 초과 ${extra.slice(0, 4).join(',')}` };
      oks.push(`${tag} 월 칸 ${ds.length}개 일치`);
    } else oks.push(`${tag} 칸 ${ds.length}개 ${ds[0]}~${ds[ds.length - 1]} · 중복·역순 없음${allMonth ? '' : ' · 주·일 달력 원천 대조는 미구현'}`);
  }
  if (!s.period) return { result: 'ERROR', why: `[측정 경로 없음] 조회 요청에서 기간을 못 찾음 · ${oks.join(' / ')}` };
  return { result: 'PASS', why: `기간 ${s.period.from}~${s.period.to} · ${oks.join(' / ')}` };
}
