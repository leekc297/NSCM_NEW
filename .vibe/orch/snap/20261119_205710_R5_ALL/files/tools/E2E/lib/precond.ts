// P4(2026-11-06 근본 보완) — 측정 전제(precondition) 공통 helper. 검사기는 측정 전에 이것을 불러 전제가 안 되면 FAIL 대신 ERROR '[측정 전제 미충족]' 을 쓴다.
//   전제: 조회 요청 완료(networkidle) · 조회 행 > 0 · 대상 컬럼이 그리드에 있고 화면에 그려짐(가상화면 스크롤) · 조회조건 칸 활성 · 헤더 행 수 안정.
//   '못 쟀다' 를 '없다' 로 적어 허위 FAIL 이 나던 유형(T82·T100·T101·EG315·Electrode)의 공통 차단.
import type { Nscm } from './nscm';
import { probe } from './probe';

export type Pre = { ok: boolean; why: string; rows: number; calls: number; headerRows: number };

export async function measurable(nscm: Nscm, opt: { rows?: boolean; binding?: string; control?: string; headerRows?: number; idle?: boolean } = {}): Promise<Pre> {
  const p = nscm.page; const why: string[] = [];
  if (opt.idle !== false) await p.waitForLoadState('networkidle', { timeout: 30_000 }).catch(() => undefined);
  const rows = await probe.rowCount(p).catch(() => -1); const calls = nscm.calls.length;
  if (opt.rows && rows <= 0) why.push(`조회 행 ${rows < 0 ? '읽기 실패' : 0}(호출 ${calls}건)`);
  if (opt.binding) {
    const info = await probe.colInfo(p, opt.binding).catch(() => null);
    if (!info) why.push(`컬럼 ${opt.binding} 그리드에 없음`);
    else { await probe.unfreezeIfNeeded(p, opt.binding).catch(() => null); await probe.cellClasses(p, 0, opt.binding).catch(() => null); }  // 가로 가상화 — 칸이 그려지게 스크롤
  }
  if (opt.control) {
    const lab = opt.control;
    const dis = await p.evaluate((label: string) => {
      const esc = label.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
      const items = Array.from(document.querySelectorAll('[class*="_formItem_"]')) as HTMLElement[];
      const it = items.find(e => new RegExp(`^\\s*\\*?\\s*${esc}\\s*\\*?\\s*$`, 'i').test(((e.querySelector('label') as HTMLElement | null)?.innerText || '').trim()));
      if (!it) return 'missing';
      const ins = Array.from(it.querySelectorAll('input:not([type="hidden"]), [role="combobox"]')) as HTMLInputElement[];
      if (!ins.length) return 'noinput';
      return ins.every(i => i.disabled || i.getAttribute('aria-disabled') === 'true' || !!i.closest('.Mui-disabled')) ? 'disabled' : 'ok';
    }, lab).catch(() => 'err');
    if (dis === 'missing') why.push(`조회조건 칸 '${lab}' 없음`);
    else if (dis === 'disabled') why.push(`조회조건 칸 '${lab}' 비활성(현재 Division 에서 사용 안 함)`);
    else if (dis === 'noinput') why.push(`조회조건 칸 '${lab}' 입력 요소 없음`);
  }
  let headerRows = -1;
  if (opt.headerRows) {
    headerRows = (await p.evaluate(`(() => { const c = ${probe.CTL_SRC}; return c ? c.columnHeaders.rows.length : -1; })()`).catch(() => -1)) as number;
    if (headerRows < opt.headerRows) why.push(`헤더 ${headerRows}행 < 기대 ${opt.headerRows}행(동적 컬럼·헤더 반영 전)`);
  }
  return { ok: !why.length, why: why.length ? `[측정 전제 미충족] ${why.join(' · ')} — 화면 결함이 아니라 측정 실패(ERROR)` : '', rows, calls, headerRows };
}
