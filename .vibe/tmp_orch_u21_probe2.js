// VMO 진단용 임시 스크립트(읽기만 함): 두 실행 기록의 편집 도구 호출 요약
'use strict';
const fs = require('fs'); const path = require('path');
const root = process.argv[2];
for (const lg of ['2026-11-23T21-42-29_claude_orch.log', '2026-11-23T21-51-34_claude_orch.log']) {
  const txt = fs.readFileSync(path.join(root, '.vibe/logs', lg), 'utf8');
  const first = txt.split('\n').find(l => l.includes('"type":"user"')) || '';
  console.log('==', lg, '첫 user 앞', first.slice(0, 300).replace(/\\n/g, ' '));
  for (const ln of txt.split('\n')) {
    if (ln[0] !== '{') continue; let j; try { j = JSON.parse(ln); } catch { continue; }
    if (j.type !== 'assistant') continue;
    for (const c of (j.message && j.message.content) || []) {
      if (c.type !== 'tool_use' || !['Edit', 'MultiEdit', 'Write'].includes(c.name)) continue;
      const i = c.input || {}; const s = String(i.new_string || i.content || JSON.stringify(i.edits || '')).replace(/\s+/g, ' ');
      console.log(' ', c.name, path.basename(String(i.file_path)), '|', s.slice(0, 140));
    }
  }
}
