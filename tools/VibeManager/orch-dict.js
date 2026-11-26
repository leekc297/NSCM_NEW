// 2026-11-20 VMO Dictionary 탭 — 사용자 지시: "VM, VMO 가 사용하는 각 규칙의 약자를 전체 정리 ... R1, R2 가 무엇을 의미하는지? D1, D2가 무엇을 의미하는지 전체 코드에 대해서 설명자료"
//   원천을 읽어 만든다(코드가 바뀌면 사전도 바뀜): orch-watch TITLE · orch-selfcheck NAMES · user_checks.json · tools/Harness/verify/mapping_checkdefs.csv
//   · Doc/_rules_consolidation/TOBE_RULES_DIFF.md(CR) · TRIGGER_ROUTER.md(T). 플랜 약자(P, Q, 속도 개선 A~G·R0~R5, H)와 상태값은 이 파일의 고정 표(출처 적음)
'use strict';
const fs = require('fs');
const path = require('path');
let errlog = { note() { return null; } }; try { errlog = require('./orch-errlog'); } catch { /* 오류 기록 모듈 없음 */ }
const readText = f => { try { return fs.readFileSync(f, 'utf8').replace(/^﻿/, ''); } catch { return ''; } };
const readJson = (f, d) => { try { return JSON.parse(readText(f)); } catch { return d; } };
const mod = n => { try { return require(`./${n}`); } catch (e) { errlog.note('orch-dict', `require ${n}`, e); return null; } };
function csvRows(text) { // 따옴표 안 쉼표·줄바꿈 처리
  const rows = []; let row = [], cur = '', q = false;
  for (let i = 0; i < text.length; i++) { const ch = text[i];
    if (q) { if (ch === '"') { if (text[i + 1] === '"') { cur += '"'; i++; } else q = false; } else cur += ch; }
    else if (ch === '"') q = true; else if (ch === ',') { row.push(cur); cur = ''; } else if (ch === '\n' || ch === '\r') { if (ch === '\r' && text[i + 1] === '\n') i++; row.push(cur); rows.push(row); row = []; cur = ''; } else cur += ch; }
  if (cur || row.length) { row.push(cur); rows.push(row); }
  const head = rows.shift() || []; return rows.filter(r => r.some(Boolean)).map(r => Object.fromEntries(head.map((h, i) => [h.trim(), r[i] || ''])));
}

const R_DESC = {
  R15: ['VMO 개입 오판. VMO 가 실행 중지, 잠금 삭제, 사건 자동 해결 같은 개입을 한 뒤 사후 검증에서 그 전제가 틀린 것으로 확인됨', 'VMO 가 피해 복구(재개 기록 되살림, 사건 다시 열기) · 개선안 등록 · 그 규칙 관찰 모드'],
  R1: ['단계, 프로세스가 0 이 아닌 종료코드로 끝남', '에이전트(AI Agent) 조치'],
  R2: ['같은 오류가 14일 안 같은 화면 2회 또는 전 화면 3회 반복. 같은 죽은 잠금이 60분 안 3회 이상이어도 R2 로 묶음', '에이전트 조치. 죽은 잠금 묶음은 VMO 가 잠금 파일 삭제'],
  R3: ['단계 소요가 같은 작업 최근 10회 중앙값의 2배 초과(60초 이상)', '에이전트 조치'],
  R4: ['대기(부하 입장, 화면 잠금, 동시 상한, 시험 데이터 구간 등)가 10분 초과', '에이전트 조치'],
  R5: ['로그와 E2E 추적 파일이 10분 무변경, 또는 종료 기록 없이 사라진 실행. 창 다시 로드로 끊긴 실행은 알림 1건으로 묶음', '에이전트 조치'],
  R6: ['서버 포트만 열리고 HTTP 응답 없음 60초, 또는 체인 실행 중 서버 꺼짐', 'VMO 코드 조치(서버 재기동), VMW 작업 일시 중지'],
  R7: ['Claude CLI 비정상 종료. 세션 이어받기 실패, 로그인 만료, CLI 경로 등으로 분류', '안내'],
  R8: ['TCP 연결 수 12,000 이상(E2E 소켓 고갈 위험)', 'VMO 코드 조치(점유 프로세스 집계), VMW 작업 일시 중지'],
  R9: ['죽은 잠금. 잠금 파일 주인 프로세스가 없음', 'VMO 가 잠금 파일 삭제'],
  R10: ['CheckList 판정 정체. 연속 2회 FAIL, 미검증 행 집합이 같음', '에이전트 조치'],
  R11: ['AI Agent 단계 없이 끝난 체인에 FAIL, 미검증이 남음', '에이전트 조치'],
  R12: ['VM 자가진단(S1~S13) 실패 항목. orch-selfcheck.js 가 올림', 'AI Agent 진단 → 개선안 → VM 코드면 게이트 통과 조건 자동 반영'],
  R13: ['화면 진입 실패 반복. 실행 로그에 화면 진입 실패 5회 이상 또는 진입 확인 실패', 'VMO 자가 복구(공용 파일 받기 → 변환 확인 → 그 화면 다시 실행), 못 풀면 에이전트'],
  R14: ['중지 뒤 계속 실행. 중지한 체인이 새 단계, 프로세스, AI Agent 를 띄우거나 VMW 작업 기록은 중지인데 체인이 60초 넘게 살아 있음', 'VMO 자가 복구(프로세스 종료, 중지 다시 요청), 재발하면 에이전트'],
};
const S_DESC = {
  S15: ['진단 사다리. 올림 조건이 참인데 아직 진단이 안 돈 묶음, 개념 재정립(L4) 승인 대기를 알림', '가벼운 점검(10분)'],
  S16: ['검사기 판정 결함. 전 화면 원장의 판정 근거에서 검사기 결함 후보(한 글자 칸 이름, 같은 문구 반복, 재지 못한 행의 해당없음, 결과와 증거 어긋남, 칸 값 없음)와 미검증 상위 묶음을 찾고, 새로 생기거나 늘면 검사기 진단으로 개선안을 올림(tools/Harness/verify/checker_defect_scan.py, orch-checkerscan.js)', '가벼운 점검(10분) · 진단 6시간 간격'],
  S14: ['VMO 개입 정확도. 개입 장부(.vibe/orch/interventions.jsonl)의 사후 검증 결과를 규칙별로 셈. 오판이 나온 규칙은 관찰 모드(사건만 올리고 개입 안 함)', '가벼운 점검(10분)'],
  S1: ['VM JS 구문, package.json·quick.json·steps.json JSON 형식', '무거운 점검'], S2: ['VM 시험 test/run_all.js 실행 결과', '무거운 점검'], S3: ['저장소와 설치 폴더 파일 내용 차이', '가벼운 점검'],
  S4: ['정의 파일 정합(quick.json, steps.json, package.json 명령, require 대상)', '무거운 점검'], S5: ['VM 실행 오류 기록(.vibe/orch/vm_errors.jsonl) 반복', '가벼운 점검'], S6: ['CHANGELOG 미확인 항목 원장 추적', '가벼운 점검'],
  S7: ['VMO 자기 상태(감시기 tick, 에이전트, 미해결 사건)', '가벼운 점검'], S8: ['반영한 개선안의 재발', '가벼운 점검'], S9: ['반복 수정 지점(작업 이력에서 여러 번 고친 파일, 되풀이된 지시)', '가벼운 점검'],
  S10: ['용량(.vibe 로그, BE 파일 로그 nscm-be/logs, 백업, 스냅샷, 디스크 남은 용량)', '하루 1회'], S11: ['고정 문구 문장 규칙(doc_style.py)', '무거운 점검'], S12: ['설정 정합(harness.json orch 절, 환경설정 키 사용)', '무거운 점검'],
  S13: ['사용자 지적 점검. user_checks.json 원장의 감지기 실행(U1~)', '가벼운 점검(10분)'],
};
const STATIC = [
  { id: 'L', title: 'VMO 진단 사다리와 스킬', src: 'orch-ladder.js · .claude/skills/vmo-diagnosis-ladder, vmo-concept-review · 2026-11-20', items: [
    ['L1 사소', '문구, 표시, 설정 값, 설치본 차이. 바로 고침(fix)'], ['L2 결함', '버그, 실행 실패, 오판 1건. 자가 복구, 에이전트, fix 자동 반영'], ['L3 구조', '같은 종류 결함이 되풀이됨(재발 2건, 반복 수정 상위 파일 4건 이상, 오판 2건, 반영 실패 2건, 사용자 지적 재발). 공통 원인을 찾는 AI 진단 → 구조 개선안'], ['L4 개념', '구조 개선 뒤에도 같은 묶음 재발, 같은 목적 어긋남 3회 연속, 같은 축 사용자 지적 7일 3건. 개념 재정립 문서와 개선안(core, 사용자 승인)'],
    ['vmo-diagnosis-ladder', '단계 판정, 단계별 근거 기준, 반증 시도, 오판 확인'], ['vmo-concept-review', '개념 재정립 순서와 결과 문서 형식'], ['systematic-debugging', 'L2·L3 원인 찾기'], ['verification-before-completion', '반영·통과를 적기 전에 검증 명령 실행'], ['writing-plans', '승인된 L4 전환 계획'] ] },
  { id: 'K', title: 'VMO 개입 종류와 사후 검증 판정', src: 'orch-ledger.js, 개입 장부 .vibe/orch/interventions.jsonl, 2026-11-20', items: [
    ['stop', '실행 중지. 사후 검증 = 멈춘 체인이 중지 시각 전에 시작했는가'], ['requeue', '다시 실행. 사후 검증 = 다시 실행 뒤 단계 OK 가 나왔는가'], ['lockdel', '잠금 삭제. 사후 검증 = 잠금 주인 PID 가 없었는가'], ['server', '서버 재기동. 사후 검증 = 포트가 응답하는가'], ['resolve', '사건 자동 해결. 사후 검증 = 같은 사건이 다시 나왔는가'], ['apply', '개선안 자동 반영. 사후 검증 = 30분 안에 되돌림이 없었는가'], ['pause, delete, revert', '작업 일시 중지, 생성물 삭제, 파일 되돌림. 기록만(검증 대상 아님)'],
    ['맞음', '개입 전제가 맞았음'], ['오판', '개입 전제가 틀렸음. 피해 복구, 사건 R15, 개선안 등록, 그 규칙 관찰 모드'], ['효과 없음', '전제는 맞았지만 개입 뒤에도 문제가 남음'], ['미확인', '전제를 다시 확인할 원천이 없음'], ['관찰 모드', '오판이 나온 규칙은 사건만 올리고 개입하지 않음. 그 규칙 개선안 반영 완료 때 해제, 또는 Health S14 의 해제 단추'], ['재수행 설정', 'VM 환경설정 🔁 VMO 보완 뒤 재수행(harness.json orch.rerunAfterFix). 재수행(기본) = R13 보완 뒤 화면 다시 실행, 에이전트 다시 실행 요청, R6/R8 해결 뒤 일시 중지 작업 이어서 실행, 오판 복구 뒤 작업 재개. 수행 없음 = VMO 는 보완까지만, 작업 재개·재실행은 사용자'], ['재수행 한도', '작업·화면마다 VMO 재수행 orch.rerunMax(기본 2)번까지. 3번째 오류면 그 작업 화면은 재수행하지 않고 화면 카드에 "재수행 한도 도달" 표시'] ] },
  { id: 'P', title: 'VMO 1차 플랜 단계', src: '메모리 project_vm_orchestra_plan_20261119 · 2026-11-19', items: [
    ['P0', '사건 기록(orch-events.js, .vibe/orch/events.jsonl)'], ['P1', '체인·단계 사건 기록(실행 주체 script, claude)'], ['P2', 'VMO 창(공통 기능, BE/FE Log, 상황판) 분리, 서버 소유 server-service.js'], ['P3', '규칙 감시기 R1~R11(orch-watch.js)'],
    ['P4', '에이전트 조치(orch-agent.js, .claude/agents/vm-orchestra.md)'], ['P5', '상시 개선안(orch-improve.js, 승인 뒤 반영)'], ['P6', '실행 주체 표시, 체인 요약에 스크립트/Claude 수'], ['P7', '창 없는 체인 실행기(chain-runner.js)'],
    ['P8', 'VMW 창(업무 작업, job-runner.js, jobs.js)'], ['P9', '동시 실행(부하 입장, AI Agent 세션 상한, R6/R8 일시 중지)'], ['P10', '생성·보완 체인 batch 4개']] },
  { id: 'Q', title: 'VMO 2차 플랜(자가진단)', src: '메모리 project_vm_orchestra_plan_20261119 · 2026-11-19', items: [
    ['Q1', 'VM 실행 오류 기록(orch-errlog.js)'], ['Q2', '작업 이력 취합(orch-history.js, 원천 H1~H8)'], ['Q3', '이력 탭(주제별 정리)'], ['Q4', '자가진단 점검 S1~S12(orch-selfcheck.js)'], ['Q5', '자가진단 탭과 미확인 원장'], ['Q6', '자가 보완(AI Agent 진단 → 개선안 → 게이트 통과 자동 반영)']] },
  { id: 'SP', title: 'CheckList 속도 개선 플랜(A~G, R0~R5)', src: 'CheckList 속도 개선 플랜(2026-11-19), CHANGELOG 2026-11-20 05:30 절', items: [
    ['A1', '진입 확인 선행. E2E 앞에서 화면 열기 1회 확인, 열리지 않으면 원인별 1회 조치 뒤 다시(_open.spec, preflight_open)'], ['A2', 'SCP0028, SSP0014 진입 실패 원인 조사(공용 파일 빠짐)'], ['A3', 'AI 검토 앞 차단. 같은 사유 미검증 대량이면 원인 1건으로 묶어 보고'],
    ['B1', '0행 응답 뒤 행 대기 생략(pagereg.emptyAnswered)'], ['B2', '조회 120초 시간 초과 원인 확인(알림에 막힌 조회는 대기 생략)'], ['B3', '화면 열기 고정 2초 → 조건 대기(하지 않음: 판정 결과가 달라짐)'], ['B4', '고정 대기 조건화(시나리오 0.8초는 하지 않음)'], ['B5', 'CRUD 2회 실행 묶기(하지 않음: 다른 측정)'],
    ['C1', '미검증 자동 해소를 AI 검토 앞으로'], ['C2', '같은 원인 미검증 행 묶어 1번 질의'], ['C3', 'AI 검토 동시 호출(llmReviewPar 4)'], ['C4', 'AI 검토 캐시를 행 단위로(llm_rowcache.json)'], ['C5', '답 JSON 해석 실패 1회 다시 요청'],
    ['D1', '한 화면 안 E2E 병렬. 읽기 시험 작업자 3개 + 쓰기 시험 차례(writeguard.ts, e2e_shard.py)'], ['D2', '시험 단위 재사용(시험 지문이 같으면 직전 결과). 이후 수정분 재점검으로 대체'],
    ['E', '진행 표시(VMW 카드 세부 n/41, 시험 n/80, AI 묶음, 대기 사유)와 구간별 소요표 run_timing.json'], ['F', '체인 실행 중 VMO 자가진단 계속(가벼운 점검, 진단, VM 코드 반영)'],
    ['G1', '결함 유형 중복 정리(AI 판단, dedup_general.py, 727건 → 586묶음)'], ['G2', '화면 안 중복 정리(규칙별 AI 판단, 대표 결과 상속, dedup_screen.py)'],
    ['R0~R5', '속도 플랜 진행 단계(R0 기준선, R1 F·E, R2 A, R3 B, R4 C, R5 D). 감시 규칙 R1~R14 와 다른 번호']] },
  { id: 'H', title: '작업 이력 원천(H1~H8)', src: 'tools/VibeManager/orch-history.js', items: [
    ['H1', 'CHANGELOG.md 절'], ['H2', 'Claude Code 세션 기록(~/.claude/projects/<프로젝트>/*.jsonl)'], ['H3', '.vibe/history 실행 meta.json'], ['H4', '.vibe/logs AI Agent 실행 로그 머리'], ['H5', 'VMO 사건, 개선안'], ['H6', '백업 파일(.bak_<날짜>_<태그>)'], ['H7', 'Claude 메모리 frontmatter'], ['H8', '검사기 결함 문서, 룰 변경 이력']] },
  { id: 'G', title: '에이전트 조치 등급', src: '.claude/agents/vm-orchestra.md · orch-agent.js', items: [
    ['A', '진단, 단독 재실행. 자동'], ['B', 'tools/Harness, tools/E2E, tools/Docs 수정. 자동 + 보고(수정 전 스냅샷, 되돌리기 가능)'], ['C', 'FE, BE, DB 객체, VM, 룰 수정. 개선안만(승인 뒤 반영)'], ['D', '금지(운영 DB, 파괴적 Git 등)']] },
  { id: 'NM', title: '창 이름', src: '2026-11-20 사용자 지정', items: [
    ['VM', 'Vibe_Manager. 화면(UI)별 작업 창 Workbench 와 메뉴'], ['VMW', 'VM Work. 업무 1개(문서 생성, CheckList 등)를 화면 여러 개에 실행하는 창(jobs.js, job-runner.js)'], ['VMO', 'VM 오케스트라. 감시, 자가 복구, 자가진단, 개선안, 에이전트, 공통 기능 창(orchestra.js, orch-*.js)']] },
  { id: 'ST', title: '상태값과 ID 접미사', src: 'orch-watch.js · orch-improve.js · job-runner.js', items: [
    ['open', '사건 열림(조치 대기)'], ['acting', '사건 조치 중'], ['need-user', '사람 확인 필요'], ['resolved', '해결'], ['closed', '닫음'],
    ['pending', '개선안 승인 대기(자동 대상이면 자동 반영 대기)'], ['applying', '반영 중'], ['applied', '반영 완료'], ['apply-failed', '반영 실패(대상 파일 복원)'], ['rejected', '반려'], ['superseded', '고친 안으로 대체'],
    ['_INC', '사건 조치에서 나온 개선안'], ['_REVIEW', '상시 분석(7일 집계)에서 나온 개선안'], ['_SELF', 'VM 자가진단에서 나온 개선안'], ['_VISION', '큰 그림 점검(Overall Review)에서 나온 개선안. 승인 뒤 반영'],
    ['user.stop', '사용자, VMO, 창 종료가 실행을 멈춘 사건 기록. 뒤따르는 실패는 사건으로 올리지 않음'], ['interrupted', 'VMW 작업 중단됨(창 다시 로드, VS Code 종료). 작업 재개로 끊긴 단계부터 다시 실행'], ['chain_progress', '체인 진행 기록(.vibe/orch/chain_progress). 끊긴 체인 재개에 씀, 24시간 유효, 삭제하면 재개 불가'], ['DB MODE', 'repairScope DB_ONLY. DB 객체만 수정, FE·BE 는 가이드만'], ['UI/DB MODE', 'repairScope DB_FE. 제약 없음']] },
];

/** 사전 전체: [{ id, title, src, items: [{ code, name, desc, extra }] }] */
function build(paths) {
  const p = paths(); const out = [];
  const w = mod('orch-watch'); const T = (w && w.TITLE) || {};
  out.push({ id: 'R', title: '감시 규칙(R1~R14)', src: 'tools/VibeManager/orch-watch.js TITLE · Events 탭(사건, Incidents)', items: Object.keys(Object.assign({}, R_DESC, T)).sort((a, b) => Number(a.slice(1)) - Number(b.slice(1))).map(k => ({ code: k, name: T[k] || '', desc: (R_DESC[k] || [''])[0], extra: R_DESC[k] ? `조치: ${R_DESC[k][1]}` : '' })) });
  const sc = mod('orch-selfcheck'); const N = (sc && sc.NAMES) || {};
  out.push({ id: 'S', title: '자가진단 항목(S1~S13)', src: 'tools/VibeManager/orch-selfcheck.js NAMES · Health 탭', items: Object.keys(Object.assign({}, S_DESC, N)).sort((a, b) => Number(a.slice(1)) - Number(b.slice(1))).map(k => ({ code: k, name: N[k] || '', desc: (S_DESC[k] || [''])[0], extra: S_DESC[k] ? `주기: ${S_DESC[k][1]}` : '' })) });
  const L = readJson(path.join(p.root, 'tools', 'VibeManager', 'user_checks.json'), { items: [] });
  out.push({ id: 'U', title: '사용자 지적(U1~)', src: 'tools/VibeManager/user_checks.json · 자가진단 S13', items: (L.items || []).map(u => ({ code: u.id, name: u.symptom || '', desc: `${u.at || ''} "${String(u.quote || '').slice(0, 220)}"`, extra: `감지기 ${u.detector || '-'} · ${u.status || ''}` })) });
  const urf = path.join(p.root, 'tools', 'VibeManager', 'user_rules.json'); // 2026-11-26 사용자 지시 규칙 묶음, 파일이 없으면 건너뜀
  if (fs.existsSync(urf)) { const UR = readJson(urf, { items: [] }); const cat = Object.fromEntries((UR.categories || []).map(c => [c.key, c.name])); const ui = UR.items || [];
    out.push({ id: 'UR', title: `사용자 지시 규칙(${ui.length}개, 감시 규칙 R# 과 다른 번호 체계)`, src: 'tools/VibeManager/user_rules.json, orch-userrule.js, 자가진단 S13', items: ui.map(r => ({ code: r.id, name: cat[r.category] || r.category || '', desc: String(r.rule || r.quote || '').slice(0, 400), extra: `등록 ${r.at || '-'}, 상태 ${r.status || '-'}` })) }); }
  try { const rows = csvRows(readText(path.join(p.root, 'tools', 'Harness', 'verify', 'mapping_checkdefs.csv'))); out.push({ id: 'CK', title: `CheckList 점검 규칙(${rows.length}개)`, src: 'tools/Harness/verify/mapping_checkdefs.csv', items: rows.map(r => ({ code: r.check, name: `${r.layer || ''} · ${r.subject || ''}`, desc: r.how || '', extra: `검사: ${String(r.checker || '').slice(0, 200)}${r.impl && r.impl !== 'Y' ? ` · 구현 ${r.impl}` : ''}` })) }); } catch (e) { errlog.note('orch-dict', 'checkdefs', e); }
  try { const t = readText(path.join(p.root, 'Doc', '_rules_consolidation', 'TOBE_RULES_DIFF.md')); const it = []; for (const ln of t.split(/\r?\n/)) { const m = /^\|\s*(CR-\d+)\s*\|\s*([^|]*)\|\s*([^|]*)\|\s*([^|]*)\|/.exec(ln); if (m) it.push({ code: m[1], name: m[3].trim(), desc: m[4].trim().slice(0, 400), extra: `범위 ${m[2].trim()}` }); } if (it.length) out.push({ id: 'CR', title: `TO-BE 룰(CR, ${it.length}개)`, src: 'Doc/_rules_consolidation/TOBE_RULES_DIFF.md', items: it }); } catch (e) { errlog.note('orch-dict', 'cr', e); }
  try { const t = readText(path.join(p.root, 'Doc', '_rules_consolidation', 'TRIGGER_ROUTER.md')); const it = []; for (const ln of t.split(/\r?\n/)) { const m = /^\|\s*\**(T\d+M?)\**\s*\|\s*([^|]*)\|\s*([^|]*)\|\s*([^|]*)\|/.exec(ln); if (m) it.push({ code: m[1], name: m[2].replace(/\*\*/g, '').trim().slice(0, 160), desc: `필독 룰 ${m[3].replace(/\*\*/g, '').trim().slice(0, 200)}`, extra: `핵심 hook ${m[4].replace(/\*\*|⭐/g, '').trim().slice(0, 200)}` }); } if (it.length) out.push({ id: 'T', title: `작업 유형 라우팅(T, ${it.length}개)`, src: 'Doc/_rules_consolidation/TRIGGER_ROUTER.md', items: it }); } catch (e) { errlog.note('orch-dict', 'trigger', e); }
  for (const g of STATIC) out.push({ id: g.id, title: g.title, src: g.src, items: g.items.map(([code, desc]) => ({ code, name: '', desc, extra: '' })) });
  return out;
}
module.exports = { build, R_DESC, S_DESC, STATIC };
