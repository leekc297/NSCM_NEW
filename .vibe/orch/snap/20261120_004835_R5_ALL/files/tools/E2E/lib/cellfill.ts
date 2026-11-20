// 원천 선택 → 대상 자동 채움 값 판정(2026-11-01 엔진 갭 EG092). 순수 함수 — cellfill.selftest.js
export type J = { result: 'PASS' | 'FAIL' | 'ERROR'; why: string };
export type Peer = { n: number; values: string[] };

/**
 * 채운 값이 맞는지 — 기대값 원천 2종
 *  copyFrom: AS-IS 가 다른 칸을 그대로 복사(GetText/GetValue) → 그 칸 값과 달라면 FAIL
 *  peer: 같은 원천 값을 가진 기존 행의 대상 값 — 저장 당시 값일 수 있어 불일치는 FAIL 이 아니라 ERROR(확인 대상)
 */
export function judgeFill(s: { src: string; tgt: string; v: string; got: string; copyFrom?: string; copyVal?: string; peer?: Peer | null }): J {
  const ctx = `${s.src}='${s.v}' → ${s.tgt}='${s.got}'`;
  if (!s.got.trim()) {
    if (s.peer && s.peer.values.length) return { result: 'FAIL', why: `원천 선택 후 대상 빈 값 — 같은 원천 기존 행 ${s.peer.n}건은 값 있음(${s.peer.values.slice(0, 3).join('/')}) · ${ctx}` };
    if (s.peer && s.peer.n) return { result: 'PASS', why: `대상 빈 값 = 같은 원천 기존 행 ${s.peer.n}건도 빈 값 · ${ctx}` };
    return { result: 'ERROR', why: `[확인 대상] 대상 빈 값 — 같은 원천 기존 행 없어 원천 데이터 유무 모름 · ${ctx}` };
  }
  if (s.copyFrom) return s.got === (s.copyVal ?? '') ? { result: 'PASS', why: `${ctx} = ${s.copyFrom} 복사 일치` } : { result: 'FAIL', why: `${ctx} — AS-IS 는 ${s.copyFrom} 값 복사인데 그 값은 '${s.copyVal ?? ''}'` };
  if (!s.peer || !s.peer.n) return { result: 'PASS', why: `${ctx} · 값 채워짐(같은 원천의 기존 행 없음 — 값 대조 미실시)` };
  if (s.peer.values.includes(s.got)) return { result: 'PASS', why: `${ctx} = 같은 원천 기존 행 ${s.peer.n}건 값과 일치` };
  return { result: 'ERROR', why: `[확인 대상] ${ctx} — 같은 원천 기존 행 ${s.peer.n}건 값 ${s.peer.values.slice(0, 4).join('/')} 와 다름` };
}
