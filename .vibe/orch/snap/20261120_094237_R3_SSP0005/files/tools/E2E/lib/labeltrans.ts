// 2026-11-19 미검증 해소(SCP0028 M3 EG-5ca14a48 'BTN:Input 비노출'): 측정 계정 언어가 KO 이면 AS-IS 영문 버튼 'Input' 이 TO-BE 에서
//   같은 라벨 코드(LBL00872 EN 'Input' · KO '입력')의 KO 글자로 보인다. 영문 글자만 찾던 검사기가 버튼을 못 찾아 미검증이 됐다.
//   메시지 원장(Doc/tobefacts/db/msg_master.csv · export_tobe_meta.py)에서 같은 라벨 코드의 다른 언어 글자를 찾아 함께 찾게 한다.
import * as fs from 'node:fs';
import * as path from 'node:path';

import { parseCsv } from './probe';

const ROOT = path.resolve(__dirname, '..', '..', '..');
const CSV = path.join(ROOT, 'Doc', 'tobefacts', 'db', 'msg_master.csv');
const canon = (s: unknown) => String(s || '').toLowerCase().replace(/[^a-z0-9가-힣一-鿿]/g, '');
let BY_TEXT: Map<string, Set<string>> | null = null;

/** 라벨 글자 → 같은 라벨 코드(LBL·use_yn Y)의 전 언어 글자(입력 글자 제외). 원장이 없으면 [] */
export function labelVariants(text: string): string[] {
  if (!BY_TEXT) {
    BY_TEXT = new Map();
    try {
      const rows = parseCsv(fs.readFileSync(CSV, 'utf8').replace(/^﻿/, '')) as unknown as Record<string, string>[];
      const byId = new Map<string, string[]>();
      for (const r of rows) {
        if (!/^LBL/i.test(r.msg_id || '') || (r.use_yn && r.use_yn !== 'Y') || !r.msg_nm) continue;
        const a = byId.get(r.msg_id) || []; a.push(r.msg_nm.trim()); byId.set(r.msg_id, a);
      }
      for (const texts of byId.values()) for (const t of texts) { const k = canon(t); if (!k) continue; const s = BY_TEXT.get(k) || new Set<string>(); texts.forEach(x => s.add(x)); BY_TEXT.set(k, s); }
    } catch { /* 원장 없음, 종전 동작 */ }
  }
  const k = canon(text); const s = BY_TEXT.get(k);
  return s ? [...s].filter(x => canon(x) !== k) : [];
}

/** 2026-11-20 T435(SCP0028 V-b45d4015 J4 탭 이름 '탭 SSP Lot Size ≠ 메뉴 등록 이름 Shipment Lot Size'): TO-BE 메뉴·탭 이름은 메뉴 메시지 코드(menu.csv mnu_msg_id)를
 *  번역한 글자다. 번역 전 기본값 mnu_desc 만 기대값으로 쓰면 메시지 코드 글자가 다른 화면은 허위 FAIL. 이 코드의 전 언어 글자(use_yn Y)를 돌려준다. 원장이 없으면 [] */
export function msgTexts(msgId: string): string[] {
  if (!msgId) return [];
  try {
    const rows = parseCsv(fs.readFileSync(CSV, 'utf8').replace(/^﻿/, '')) as unknown as Record<string, string>[];
    return [...new Set(rows.filter(r => (r.msg_id || '').toUpperCase() === msgId.toUpperCase() && (!r.use_yn || r.use_yn === 'Y') && r.msg_nm).map(r => r.msg_nm.trim()))];
  } catch { return []; }
}
