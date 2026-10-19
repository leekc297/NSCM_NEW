'use strict';
const fs = require('fs');
const p = process.argv[2];
let s = fs.readFileSync(p, 'utf8');
s = s.replace(/\/\* ===== (?:ASIS|REMOVED ASIS)[^\r\n]*?\r?\n[\s\S]*?===== END ASIS ===== \*\/\r?\n/g, '');
fs.writeFileSync(p, s, 'utf8');
console.log('ASIS blocks removed');
