// VMO 개선안 맡음 표시 도구(2026-11-26 사용자 지시 '병렬로 펼쳐서 진행 · 하위 세션 멀티'): Claude Code 세션이 개선안을 직접 고칠 때 VMO 자동 반영과 겹치지 않게 한다.
//   claim  <맡은 세션> <id...> : autoWaitMs = 지금 + 8시간(VMO 자동 반영 고르기에서 빠짐, orch-selfcheck.js pend0 조건), claimedBy 기록
//   done   <id> <확인 문장>    : status applied, appliedMs, 이력(by = 맡은 세션). 고친 파일과 시험 결과를 확인 문장에 적는다
//   release <id...>            : 맡음 해제(VMO 자동 반영 대상으로 되돌림)
//   hold   <id> <사유>          : 사람 판단이 필요한 안 = impact core, userHold, autoWaitMs 10년(coreAutoApply 가 켜져 있어도 VMO 자동 반영 안 함)
//   list   [맡은 세션]          : 맡은 안 목록
//   사용: node tools/VibeManager/claim_proposal.js claim S-A 20261126115652_SELF 20261126115652_SELF_2
//   --root <저장소 폴더> : 시험용(그 폴더의 .vibe/orch/proposals 를 씀)
//   2026-11-26 개선안 20261126180320_VISION: claim 때 다른 세션이 지금 맡은 안과 대상 파일(targets)이 겹치면 'WARN 대상 파일 겹침 …' 을 출력하고 이력에 남김(맡기는 막지 않음). list 에 대상 파일 앞 3개
const fs = require('fs'); const path = require('path');
const argv0 = process.argv.slice(2); const ri = argv0.indexOf('--root'); const rootArg = ri >= 0 ? argv0.splice(ri, 2)[1] : '';
const root = rootArg ? path.resolve(rootArg) : path.resolve(__dirname, '..', '..'); const dir = path.join(root, '.vibe', 'orch', 'proposals');
const normT = t => String(t || '').replace(/\\/g, '/').replace(/\s*\(.*$/, '').trim().replace(/^\.\//, '');
const activeClaims = (exceptId, who) => { const out = []; for (const n of fs.readdirSync(dir).filter(x => x.endsWith('.json'))) { let q; try { q = JSON.parse(fs.readFileSync(path.join(dir, n), 'utf8')); } catch { continue; } if (q.id !== exceptId && q.claimedBy && q.claimedBy !== who && Number(q.autoWaitMs) > Date.now() && /^(pending|apply-failed|approved)$/.test(q.status) && !q.userHold) out.push(q); } return out; };
const pad = n => String(n).padStart(2, '0');
const nowLocal = (d = new Date()) => { const o = -d.getTimezoneOffset(); const s = o >= 0 ? '+' : '-'; return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}T${pad(d.getHours())}:${pad(d.getMinutes())}:${pad(d.getSeconds())}${s}${pad(Math.floor(Math.abs(o) / 60))}:${pad(Math.abs(o) % 60)}`; };
const file = id => { if (!/^\d{14}_[A-Z]+(_\d+)?$/.test(id)) throw new Error(`개선안 번호 형식 아님: ${id}`); return path.join(dir, `${id}.json`); };
const read = id => JSON.parse(fs.readFileSync(file(id), 'utf8'));
const write = p => { const f = file(p.id); const t = `${f}.tmp${process.pid}`; fs.writeFileSync(t, JSON.stringify(p, null, 2), 'utf8'); fs.renameSync(t, f); };
const hist = (p, by, what) => (p.history = p.history || []).push({ at: nowLocal(), by, what });
const [cmd, ...a] = argv0;
try {
  if (cmd === 'claim') {
    const who = a.shift(); if (!who || !a.length) throw new Error('claim <맡은 세션> <id...>');
    for (const id of a) {
      const p = read(id);
      if (!/^(pending|apply-failed)$/.test(p.status)) { console.log(`SKIP ${id} 상태 ${p.status}`); continue; }
      if (p.claimedBy && p.claimedBy !== who && (p.autoWaitMs || 0) > Date.now()) { console.log(`SKIP ${id} 이미 ${p.claimedBy} 가 맡음`); continue; }
      const mine = new Set((p.targets || []).map(normT).filter(Boolean)); const over = [];
      for (const q of activeClaims(id, who)) for (const t of (q.targets || []).map(normT)) if (mine.has(t)) over.push(`${t} (${q.claimedBy} ${q.id})`);
      p.claimedBy = who; p.autoWaitMs = Date.now() + 8 * 3600000; p.waitNote = `Claude Code 세션 ${who} 가 직접 보완 중`; hist(p, who, '세션이 맡음(VMO 자동 반영 8시간 보류)');
      if (over.length) { const w = `대상 파일 겹침 ${over.slice(0, 6).join(', ')}${over.length > 6 ? ` 외 ${over.length - 6}` : ''}`; hist(p, who, `경고: ${w}`); console.log(`WARN ${id} ${w}`); }
      write(p); console.log(`OK claim ${id}`);
    }
  } else if (cmd === 'done') {
    const id = a.shift(); const note = a.join(' ').trim(); if (!id || !note) throw new Error('done <id> <확인 문장>');
    const p = read(id); const who = p.claimedBy || 'Claude Code 세션';
    if (p.status === 'applied') { console.log(`SKIP ${id} 이미 반영 완료`); process.exit(0); }
    p.status = 'applied'; p.appliedMs = Date.now(); p.waitNote = ''; delete p.autoWaitMs; hist(p, who, `반영 완료(세션 직접 보완) · ${note}`); write(p); console.log(`OK done ${id}`);
  } else if (cmd === 'release') {
    for (const id of a) { const p = read(id); delete p.autoWaitMs; delete p.claimedBy; p.waitNote = ''; hist(p, 'Claude Code 세션', '맡음 해제'); write(p); console.log(`OK release ${id}`); }
  } else if (cmd === 'hold') { // 사람 판단이 필요한 안: impact core 로 바꿔 VMO 자동 반영에서 빼고(orch-selfcheck autoEligible) 승인 대기로 보이게 한다
    const id = a.shift(); const why = a.join(' ').trim(); if (!id || !why) throw new Error('hold <id> <사람 판단이 필요한 사유>');
    const p = read(id); if (!/^(pending|apply-failed)$/.test(p.status)) { console.log(`SKIP ${id} 상태 ${p.status}`); process.exit(0); }
    p.impactWas = p.impactWas || p.impact || ''; p.impact = 'core'; p.levelWhy = why; p.needsApproval = `사람 판단 필요: ${why}`; p.userHold = true; p.reason = p.reason || `사람 판단 필요: ${why}`; p.autoWaitMs = Date.now() + 3650 * 86400000; p.waitNote = '사람 판단 대기(자동 반영 안 함)'; /* 2026-11-26 16:05: harness orch.coreAutoApply true 면 impact core 만으로는 autoEligible 을 통과함(S-D2 보고). autoWaitMs 로 orch-selfcheck pend0 에서 빼고 reason 으로 반영 실패 재시도에서도 뺌 */ hist(p, p.claimedBy || 'Claude Code 세션', `사용자 판단 대기로 보류(자동 반영 안 함) · ${why}`); delete p.claimedBy; write(p); console.log(`OK hold ${id}`);
  } else if (cmd === 'list') {
    const who = a[0] || ''; for (const n of fs.readdirSync(dir).filter(x => x.endsWith('.json'))) { let p; try { p = JSON.parse(fs.readFileSync(path.join(dir, n), 'utf8')); } catch { continue; } if (p.claimedBy && (!who || p.claimedBy === who)) console.log(`${p.id}\t${p.status}\t${p.claimedBy}\t${String(p.title).slice(0, 90)}\t${(p.targets || []).map(normT).slice(0, 3).join(', ')}`); }
  } else { console.log('사용: claim <세션> <id...> | done <id> <확인 문장> | release <id...> | hold <id> <사유> | list [세션]'); process.exit(2); }
} catch (e) { console.log(`ERROR ${e.message}`); process.exit(1); }
