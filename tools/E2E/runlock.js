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
const pad = n => String(n).padStart(2, '0');
const stamp = d => `${d.getFullYear()}${pad(d.getMonth() + 1)}${pad(d.getDate())}_${pad(d.getHours())}${pad(d.getMinutes())}${pad(d.getSeconds())}`;
const alive = pid => { if (!pid) return false; try { const o = cp.execSync(`tasklist /FI "PID eq ${pid}" /FO CSV /NH`, { encoding: 'utf8', windowsHide: true, timeout: 8000 }); return new RegExp(`"${pid}"`).test(o); } catch { try { process.kill(pid, 0); return true; } catch { return false; } } };
const readLock = () => { try { return JSON.parse(fs.readFileSync(lockF, 'utf8')); } catch { return null; } };
if (cmd === 'acquire') {
  const cur = readLock();
  if (cur && alive(cur.pid)) {
    const min = Math.round((Date.now() - (cur.startedMs || 0)) / 60000);
    process.stderr.write(`[FAIL] 다른 E2E 실행이 진행 중입니다 — PID ${cur.pid} · 시작 ${cur.started} (${min}분 전) · 인자 "${cur.args}"\n       끝나기를 기다리거나 그 프로세스를 종료한 뒤 다시 실행하세요. (잠금: ${lockF})\n`);
    process.exit(4);
  }
  if (cur) process.stderr.write(`[INFO] 이전 잠금(PID ${cur.pid}, ${cur.started}) 의 프로세스가 없어 무시합니다\n`);
  const d = new Date(); const runId = stamp(d);
  fs.mkdirSync(logDir, { recursive: true });
  fs.writeFileSync(lockF, JSON.stringify({ pid: process.ppid, started: d.toISOString(), startedMs: d.getTime(), runId, args: process.argv.slice(3).join(' ') }, null, 2), 'utf8');
  process.stdout.write(runId + '\n');
} else if (cmd === 'release') {
  try { fs.unlinkSync(lockF); } catch { }
  try { const files = fs.readdirSync(logDir).filter(f => /^run_.*\.log$/.test(f)).sort(); for (const f of files.slice(0, Math.max(0, files.length - 40))) fs.unlinkSync(path.join(logDir, f)); } catch { }
} else {
  const cur = readLock(); if (!cur) console.log('잠금 없음'); else console.log(`${alive(cur.pid) ? '실행 중' : '잠금 잔존(프로세스 없음)'} — PID ${cur.pid} · ${cur.started} · ${cur.args}`);
}
