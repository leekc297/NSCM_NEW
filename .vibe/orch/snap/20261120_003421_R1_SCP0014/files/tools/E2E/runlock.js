#!/usr/bin/env node
'use strict';
// runlock — run-e2e.cmd 의 동시 실행 방지 + 실행 ID 발급 (2026-10-21)
//   사고: 다른 run-e2e 가 돌고 있는 동안 메뉴에서 다시 실행 → 공용 _run.log 를 다른 프로세스가 쥐고 있어 `>> %LOG%` 리다이렉트가
//        "다른 프로세스가 사용 중" 으로 전부 실패 → probe/메타/스펙 생성/Playwright 가 하나도 돌지 않았는데 exit 0 → Vibe_Manager 가 '완료' 로 표시.
//   사용: node runlock.js acquire <args…>   → stdout 에 RUNID(yyyyMMdd_HHmmss) 한 줄. 다른 실행이 살아 있으면 stderr [FAIL] + 빈 stdout + exit 4
//         node runlock.js release           → 잠금 해제 + 오래된 실행 로그 정리(최근 40개 유지)
//         node runlock.js status            → 잠금 상태 출력
const fs = require('fs'); const path = require('path'); const cp = require('child_process');
const cfg = JSON.parse(fs.readFileSync(path.join(__dirname, 'e2e.config.json'), 'utf8').replace(/^﻿/, ''));
const e2eDir = path.dirname(cfg.resultsDir); const lockF = path.join(e2eDir, '_run.lock'); const logDir = path.join(e2eDir, 'logs');
const cmd = process.argv[2] || 'status';
// 2026-10-28: 화면별 잠금 — 'verify <ID>' 는 _run.verify.<ID>.lock (다른 화면은 동시 실행 · 같은 화면만 직렬).
// 2026-11-06(사용자 지시 '한쪽 방식 통일'): run-e2e.cmd 는 항상 화면별 잠금 _run.e2e.<ID>.lock — 여러 화면·전체 실행도 화면별 실행을 하나씩 부른다.
//   공용 _run.lock 은 호출자가 E2E_RESULTS 를 직접 지정한 예외 실행에만 남는다. 잠금이 잡혀 있으면 실패 대신 대기(아래 acquire)
// 2026-10-29: 'slot <i>' 는 동시 E2E 상한 슬롯(_run.slot.<i>.lock) — run_verify 가 verifyMaxConcurrent 개 슬롯 중 빈 것을 잡고, 없으면 기다린다(5화면 동시 실행 → BE 풀 고갈·엔진 미기동 재발 방지)
// 2026-11-06(사용자 지시): run-e2e.cmd <종류> <화면ID 1개> 는 화면별 잠금 _run.e2e.<ID>.lock — 결과·로그가 Doc/e2e/results/<ID>/·logs/<ID>/ 로 분리돼
//   다른 화면의 smoke·crud 와 동시에 돌아도 서로 덮어쓰지 않는다. 화면 여러 개·화면 없음(--all) 은 종전 공용 _run.lock(공용 폴더) — 둘은 서로 막는다.
const E2E_KINDS = ['smoke', 'crud', 'auth', 'authcrud', 'all'];
const e2eIds = (args) => { const out = []; for (let i = 1; i < args.length; i++) { const a = String(args[i] || '').trim(); if (!a) continue; if (a === '--mode') { i++; continue; } out.push(a.toUpperCase()); } return out; };
const keyOf = (args) => {
  if ((args[0] === 'verify' || args[0] === 'slot') && args[1] != null && String(args[1]) !== '') return `${args[0]}.${String(args[1]).toUpperCase()}`;
  if (E2E_KINDS.includes(String(args[0] || '').toLowerCase())) { const ids = e2eIds(args); if (ids.length === 1) return `e2e.${ids[0]}`; }
  return '';
};
const lockOf = (key) => key ? path.join(e2eDir, `_run.${key}.lock`) : lockF;
const allLocks = () => { try { return fs.readdirSync(e2eDir).filter(f => /^_run(\.[\w.-]+)?\.lock$/.test(f)).map(f => path.join(e2eDir, f)); } catch { return []; } };
const readLockAt = (f) => { try { return JSON.parse(fs.readFileSync(f, 'utf8')); } catch { return null; } };
const pad = n => String(n).padStart(2, '0');
const stamp = d => `${d.getFullYear()}${pad(d.getMonth() + 1)}${pad(d.getDate())}_${pad(d.getHours())}${pad(d.getMinutes())}${pad(d.getSeconds())}`;
// 2026-10-28: 살아있음 판정은 보수적으로 — tasklist 가 부하로 지연·오류를 내도 '죽었다' 로 보지 않는다(다섯 창 동시 실행 때 잠금 보유 실행을 죽은 것으로 오판해 잠금을 덮어쓴 사고 19:15·19:26)
const alive = pid => { if (!pid) return false; try { const o = cp.execSync(`tasklist /FI "PID eq ${pid}" /FO CSV /NH`, { encoding: 'utf8', windowsHide: true, timeout: 20000 }); if (new RegExp(`"${pid}"`).test(o)) return true; if (/No tasks|작업이 없습니다|정보:|INFO:/i.test(o)) return false; return true; } catch { try { process.kill(pid, 0); return true; } catch { return false; } } };
const readLock = () => { try { return JSON.parse(fs.readFileSync(lockF, 'utf8')); } catch { return null; } };
if (cmd === 'acquire') {
  // 2026-11-06(사용자 지시 "smoke 잠금 한쪽 방식 통일 · 중복 수행해도 괜찮도록"): run-e2e 잠금(화면별 e2e.<ID> · 공용)이 잡혀 있으면
  //   실패(exit 4) 대신 풀릴 때까지 기다렸다가 잡는다(15초 간격 · 최대 E2E_LOCK_WAIT_MIN 분, 기본 120). verify·slot 은 run_verify 가 자체 대기·슬롯 선택을 하므로 즉시 응답(종전과 같음).
  const args = process.argv.slice(3); const myKey = keyOf(args); const lf = lockOf(myKey);
  const waitable = !/^(verify|slot)\./.test(myKey);
  const waitMax = Math.max(0, Number(process.env.E2E_LOCK_WAIT_MIN ?? 120)) * 60_000;
  const sleep = ms => Atomics.wait(new Int32Array(new SharedArrayBuffer(4)), 0, 0, ms);
  const busyWhy = () => {
    const cur = readLockAt(lf);
    if (cur && alive(cur.pid)) return `다른 E2E 실행이 진행 중 — PID ${cur.pid} · 시작 ${cur.started} · 인자 "${cur.args}" (잠금: ${lf})`;
    if (cur) { process.stderr.write(`[INFO] 이전 잠금(PID ${cur.pid}, ${cur.started}) 의 프로세스가 없어 무시합니다\n`); try { fs.unlinkSync(lf); } catch { } }
    // 화면별 E2E(_run.e2e.<ID>) ↔ 공용 E2E(_run.lock) 는 같은 화면 결과를 건드릴 수 있어 서로 막는다(verify·slot 무관)
    if (!myKey || myKey.startsWith('e2e.')) {
      const others = myKey ? [lockF] : allLocks().filter(f => /^_run\.e2e\./.test(path.basename(f)));
      for (const f of others) { const c = readLockAt(f); if (c && alive(c.pid)) return `${myKey ? '공용(여러 화면·전체) E2E' : '화면별 E2E'} 실행이 진행 중 — ${path.basename(f)} · PID ${c.pid} · 인자 "${c.args}"`; }
    }
    return '';
  };
  // 2026-11-19 오케스트라 P1: 잠금 대기 사건 기록(.vibe/orch/events.jsonl — VM orch-events.js 와 같은 줄 형식). 기록 실패는 잠금 처리에 영향 없음
  const oev = (type, d) => { try { const od = process.env.VIBE_ORCH_DIR || path.join(__dirname, '..', '..', '.vibe', 'orch'); fs.mkdirSync(od, { recursive: true }); const n = new Date(); const off = -n.getTimezoneOffset(); const at = `${n.getFullYear()}-${pad(n.getMonth() + 1)}-${pad(n.getDate())}T${pad(n.getHours())}:${pad(n.getMinutes())}:${pad(n.getSeconds())}${off >= 0 ? '+' : '-'}${pad(Math.floor(Math.abs(off) / 60))}:${pad(Math.abs(off) % 60)}`; fs.appendFileSync(path.join(od, 'events.jsonl'), JSON.stringify(Object.assign({ at, ms: n.getTime(), type, src: 'node', pid: process.pid, script: 'runlock.js' }, d)) + '\n', 'utf8'); } catch { } };
  const evScreen = myKey.replace(/^(e2e|verify|slot)\./, '');
  const t0 = Date.now(); let told = false; let runId = '';
  for (;;) {
    const why = busyWhy();
    if (!why) {
      const d = new Date(); runId = stamp(d);
      fs.mkdirSync(logDir, { recursive: true });
      // 2026-11-06: 잠금 주인 = 오래 사는 프로세스. run-e2e.cmd 는 `for /f` 의 일시 셸이 node 를 띄워 process.ppid 가 곧 사라진다 → 화면별·공용 잠금은 그 셸의 부모(run-e2e.cmd 셸)를 주인으로.
      //   verify·slot 은 run_verify(python)가 직접 잡아 ppid 가 곧 주인
  const owner = (() => { if (/^(verify|slot)\./.test(keyOf(process.argv.slice(3)))) return process.ppid; try { const o = cp.execSync(`powershell -NoProfile -Command "(Get-CimInstance Win32_Process -Filter 'ProcessId=${process.ppid}').ParentProcessId"`, { encoding: 'utf8', windowsHide: true, timeout: 20000 }).trim(); const n = Number(o); return n > 0 ? n : process.ppid; } catch { return process.ppid; } })();
      // 원자적 생성(wx) — 두 실행이 같은 순간 '잠금 없음' 을 보고 둘 다 쓰던 경합 제거 · 지면 다시 대기
      try { fs.writeFileSync(lf, JSON.stringify({ pid: owner, started: d.toISOString(), startedMs: d.getTime(), runId, args: args.join(' ') }, null, 2), { encoding: 'utf8', flag: 'wx' }); break; }
      catch (e) { if (!(e && e.code === 'EEXIST')) throw e; }
    }
    const msg = why || '다른 E2E 실행이 방금 잠금을 잡았습니다';
    if (!waitable || Date.now() - t0 >= waitMax) {
      if (told) oev('wait.end', { kind: 'e2elock', screen: evScreen, sec_wait: Math.round((Date.now() - t0) / 1000), gave_up: true });
      process.stderr.write(`[FAIL] ${msg}${waitable ? ` — ${Math.round((Date.now() - t0) / 60000)}분 대기 초과` : ''}\n       끝나기를 기다리거나 그 프로세스를 종료한 뒤 다시 실행하세요.\n`);
      process.exit(4);
    }
    if (!told) { process.stderr.write(`[WAIT] ${msg} — 끝나면 이어서 실행(15초 간격 · 최대 ${Math.round(waitMax / 60000)}분)\n`); told = true; oev('wait.start', { kind: 'e2elock', screen: evScreen, why: msg.slice(0, 300), max_sec: Math.round(waitMax / 1000) }); }
    sleep(15_000);
  }
  if (told) { process.stderr.write(`[INFO] E2E 잠금 획득 — ${Math.round((Date.now() - t0) / 1000)}초 대기 후 실행\n`); oev('wait.end', { kind: 'e2elock', screen: evScreen, sec_wait: Math.round((Date.now() - t0) / 1000), gave_up: false }); }
  process.stdout.write(runId + '\n');
} else if (cmd === 'release') {
  const key = keyOf(process.argv.slice(3));
  if (key) { try { fs.unlinkSync(lockOf(key)); } catch { } }
  else { try { fs.unlinkSync(lockF); } catch { } for (const f of allLocks()) { const c = readLockAt(f); if (c && (c.pid === process.ppid || !alive(c.pid))) { try { fs.unlinkSync(f); } catch { } } } }  // 인자 없는 release = 공용 잠금 + 내 pid 소유·죽은 화면별 잠금 정리
  // 오래된 실행 로그 정리 — 공용 logs/ 와 화면별 logs/<ID>/ 각각 최근 40개 유지(2026-11-06 화면별 폴더)
  const prune = (dir) => { try { const files = fs.readdirSync(dir).filter(f => /^run_.*\.log$/.test(f)).sort(); for (const f of files.slice(0, Math.max(0, files.length - 40))) fs.unlinkSync(path.join(dir, f)); } catch { } };
  prune(logDir); try { for (const s of fs.readdirSync(logDir, { withFileTypes: true })) if (s.isDirectory()) prune(path.join(logDir, s.name)); } catch { }
} else {
  const locks = allLocks().map(f => [f, readLockAt(f)]).filter(x => x[1]);
  if (!locks.length) console.log('잠금 없음');
  for (const [f, c] of locks) console.log(`${path.basename(f)}: ${alive(c.pid) ? '실행 중' : '잠금 잔존(프로세스 없음)'} — PID ${c.pid} · ${c.started} · ${c.args}`);
  const cur = null; if (false) console.log(`${alive(cur.pid) ? '실행 중' : '잠금 잔존(프로세스 없음)'} — PID ${cur.pid} · ${cur.started} · ${cur.args}`);
}
