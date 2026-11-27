// 2026-11-26 개선안 20261126164445_VISION_2: VM 이 띄운 서버 출력 중계기. server-service.js start() 가 서버 명령 대신 이 파일을 띄운다.
//   사용: node logpipe.js <로그 파일> <상한 바이트> <남길 part 개수> -- <명령 1줄(셸로 실행)>
//   서버(명령) 출력(stdout, stderr)을 받아 로그 파일에 쓰고, 쓴 바이트가 상한을 넘으면 파일을 닫고 <로그>_partN.log 로 이름을 바꾼 뒤 같은 이름으로 새로 연다.
//   중계기만 로그 파일을 쥐므로 줄이 빠지지 않음. part 파일은 남길 개수만 두고 오래된 것부터 지움. 종료 코드 = 서버 종료 코드.
//   이 프로세스는 VM(확장 호스트)과 따로 돌아 창을 다시 로드해도 서버와 함께 남음(종전 cmd 자식과 같음)
'use strict';
const fs = require('fs'); const path = require('path'); const cp = require('child_process');

const partFile = (logF, n) => logF.replace(/\.log$/i, '') + `_part${n}.log`;
function partsOf(logF) {
  const dir = path.dirname(logF), base = path.basename(logF).replace(/\.log$/i, '').toLowerCase();
  let names = []; try { names = fs.readdirSync(dir); } catch { names = []; }
  return names.map(n => { const l = n.toLowerCase(); if (!l.startsWith(base + '_part') || !l.endsWith('.log')) return null; const k = Number(l.slice(base.length + 5, -4)); return Number.isInteger(k) && k > 0 ? { n: k, f: path.join(dir, n) } : null; }).filter(Boolean).sort((a, b) => a.n - b.n);
}

/** 상한마다 파일을 바꾸는 쓰기 도구. write(buf) 는 동기 쓰기(순서 유지) */
function rotatingWriter(logF, maxBytes, keep, onRotate) {
  let fd = fs.openSync(logF, 'a'); let size = 0; try { size = fs.fstatSync(fd).size; } catch { size = 0; }
  let partN = partsOf(logF).reduce((a, x) => Math.max(a, x.n), 0);
  const rotate = () => {
    try { fs.closeSync(fd); } catch { /* 이미 닫힘 */ }
    partN += 1; const pf = partFile(logF, partN);
    try { fs.renameSync(logF, pf); } catch (e) { fd = fs.openSync(logF, 'a'); return; } // 이름 바꾸기 실패 = 같은 파일에 계속 씀
    fd = fs.openSync(logF, 'a'); const bytes = size; size = 0;
    const removed = []; const ps = partsOf(logF); while (ps.length > keep) { const x = ps.shift(); try { fs.unlinkSync(x.f); removed.push(x.f); } catch { /* 다음 교체 때 다시 */ } }
    if (onRotate) try { onRotate({ part: pf, bytes, removed }); } catch { /* 알림 실패 무시 */ }
  };
  return {
    write(buf) { if (!buf || !buf.length) return; if (maxBytes > 0 && size >= maxBytes) rotate(); let off = 0; while (off < buf.length) off += fs.writeSync(fd, buf, off, buf.length - off); size += buf.length; },
    close() { try { fs.closeSync(fd); } catch { /* 이미 닫힘 */ } },
    get partN() { return partN; },
  };
}

function main(argv) {
  const sep = argv.indexOf('--'); if (sep < 3) { process.stderr.write('사용: logpipe.js <로그> <상한 바이트> <남길 개수> -- <명령> [인자...]\n'); return process.exit(2); }
  const [logF, maxS, keepS] = argv.slice(0, 3); const cmdLine = argv.slice(sep + 1).join(' '); // 명령 1줄을 셸로 실행(종전 server-service 의 cmd /c 와 같은 명령줄)
  const w = rotatingWriter(logF, Number(maxS) || 0, Math.max(1, Number(keepS) || 5), r => { w.write(Buffer.from(`[logpipe] ${path.basename(r.part)} 로 옮김 ${r.bytes} 바이트${r.removed.length ? `, 지움 ${r.removed.map(f => path.basename(f)).join(', ')}` : ''}\n`)); });
  const env = Object.assign({}, process.env); delete env.ELECTRON_RUN_AS_NODE; // 서버에는 VM 실행용 값을 넘기지 않음
  let child;
  try { child = cp.spawn(cmdLine, [], { cwd: process.cwd(), env, stdio: ['ignore', 'pipe', 'pipe'], windowsHide: true, shell: true }); }
  catch (e) { w.write(Buffer.from(`spawn 실패: ${e.message}\n`)); w.close(); return process.exit(1); }
  child.stdout.on('data', d => w.write(d)); child.stderr.on('data', d => w.write(d));
  child.on('error', e => w.write(Buffer.from(`spawn 실패: ${e.message}\n`)));
  child.on('close', code => { w.close(); process.exit(code == null ? 1 : code); });
  for (const sig of ['SIGINT', 'SIGTERM', 'SIGBREAK']) { try { process.on(sig, () => { try { child.kill(); } catch { /* 이미 끝남 */ } }); } catch { /* 신호 없음 */ } }
}

if (require.main === module) main(process.argv.slice(2));
module.exports = { rotatingWriter, partsOf, partFile, main };
