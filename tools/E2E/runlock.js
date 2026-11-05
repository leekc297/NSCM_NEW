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
// 2026-10-28: 화면별 잠금 — 'verify <ID>' 는 _run.verify.<ID>.lock (다른 화면은 동시 실행 · 같은 화면만 직렬). 레거시(run-e2e.cmd smoke 등)는 공용 _run.lock 유지
// 2026-10-29: 'slot <i>' 는 동시 E2E 상한 슬롯(_run.slot.<i>.lock) — run_verify 가 verifyMaxConcurrent 개 슬롯 중 빈 것을 잡고, 없으면 기다린다(5화면 동시 실행 → BE 풀 고갈·엔진 미기동 재발 방지)
const keyOf = (args) => ((args[0] === 'verify' || args[0] === 'slot') && args[1] != null && String(args[1]) !== '') ? `${args[0]}.${String(args[1]).toUpperCase()}` : '';
const lockOf = (key) => key ? path.join(e2eDir, `_run.${key}.lock`) : lockF;
const allLocks = () => { try { return fs.readdirSync(e2eDir).filter(f => /^_run(\.[\w.-]+)?\.lock$/.test(f)).map(f => path.join(e2eDir, f)); } catch { return []; } };
const readLockAt = (f) => { try { return JSON.parse(fs.readFileSync(f, 'utf8')); } catch { return null; } };
const pad = n => String(n).padStart(2, '0');
const stamp = d => `${d.getFullYear()}${pad(d.getMonth() + 1)}${pad(d.getDate())}_${pad(d.getHours())}${pad(d.getMinutes())}${pad(d.getSeconds())}`;
// 2026-10-28: 살아있음 판정은 보수적으로 — tasklist 가 부하로 지연·오류를 내도 '죽었다' 로 보지 않는다(다섯 창 동시 실행 때 잠금 보유 실행을 죽은 것으로 오판해 잠금을 덮어쓴 사고 19:15·19:26)
const alive = pid => { if (!pid) return false; try { const o = cp.execSync(`tasklist /FI "PID eq ${pid}" /FO CSV /NH`, { encoding: 'utf8', windowsHide: true, timeout: 20000 }); if (new RegExp(`"${pid}"`).test(o)) return true; if (/No tasks|작업이 없습니다|정보:|INFO:/i.test(o)) return false; return true; } catch { try { process.kill(pid, 0); return true; } catch { return false; } } };
const readLock = () => { try { return JSON.parse(fs.readFileSync(lockF, 'utf8')); } catch { return null; } };
if (cmd === 'acquire') {
  const lf = lockOf(keyOf(process.argv.slice(3)));
  const cur = readLockAt(lf);
  if (cur && alive(cur.pid)) {
    const min = Math.round((Date.now() - (cur.startedMs || 0)) / 60000);
    process.stderr.write(`[FAIL] 다른 E2E 실행이 진행 중입니다 — PID ${cur.pid} · 시작 ${cur.started} (${min}분 전) · 인자 "${cur.args}"\n       끝나기를 기다리거나 그 프로세스를 종료한 뒤 다시 실행하세요. (잠금: ${lockF})\n`);
    process.exit(4);
  }
  if (cur) process.stderr.write(`[INFO] 이전 잠금(PID ${cur.pid}, ${cur.started}) 의 프로세스가 없어 무시합니다\n`);
  const d = new Date(); const runId = stamp(d);
  fs.mkdirSync(logDir, { recursive: true });
  fs.writeFileSync(lf, JSON.stringify({ pid: process.ppid, started: d.toISOString(), startedMs: d.getTime(), runId, args: process.argv.slice(3).join(' ') }, null, 2), 'utf8');
  process.stdout.write(runId + '\n');
} else if (cmd === 'release') {
  const key = keyOf(process.argv.slice(3));
  if (key) { try { fs.unlinkSync(lockOf(key)); } catch { } }
  else { try { fs.unlinkSync(lockF); } catch { } for (const f of allLocks()) { const c = readLockAt(f); if (c && (c.pid === process.ppid || !alive(c.pid))) { try { fs.unlinkSync(f); } catch { } } } }  // 인자 없는 release = 공용 잠금 + 내 pid 소유·죽은 화면별 잠금 정리
  try { const files = fs.readdirSync(logDir).filter(f => /^run_.*\.log$/.test(f)).sort(); for (const f of files.slice(0, Math.max(0, files.length - 40))) fs.unlinkSync(path.join(logDir, f)); } catch { }
} else {
  const locks = allLocks().map(f => [f, readLockAt(f)]).filter(x => x[1]);
  if (!locks.length) console.log('잠금 없음');
  for (const [f, c] of locks) console.log(`${path.basename(f)}: ${alive(c.pid) ? '실행 중' : '잠금 잔존(프로세스 없음)'} — PID ${c.pid} · ${c.started} · ${c.args}`);
  const cur = null; if (false) console.log(`${alive(cur.pid) ? '실행 중' : '잠금 잔존(프로세스 없음)'} — PID ${cur.pid} · ${cur.started} · ${cur.args}`);
}
