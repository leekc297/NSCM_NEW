# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: SSP0014.smoke.spec.ts >> SSP0014 ShipmentModelPIC 스모크 @smoke >> 화면 열림 · 조회조건 · 조회 · 그리드 컬럼
- Location: ..\..\Doc\e2e\specs\SSP0014.smoke.spec.ts:11:7

# Error details

```
Error: 권한 안내 없이 열림

expect(received).toBeTruthy()

Received: false
```

# Page snapshot

```yaml
- generic [active] [ref=f5e1]:
  - generic [ref=f5e2]:
    - banner [ref=f5e3]:
      - link "SCM 공급망관리시스템 Supply Chain Management system" [ref=f5e5] [cursor=pointer]:
        - /url: /view/home
        - generic [ref=f5e6]: SCM
        - generic [ref=f5e7]:
          - generic [ref=f5e8]: 공급망관리시스템
          - generic [ref=f5e9]: Supply Chain Management system
      - navigation [ref=f5e10]:
        - link "Demand" [ref=f5e11] [cursor=pointer]:
          - /url: /view/home
        - link "Supply" [ref=f5e12] [cursor=pointer]:
          - /url: /view/home
        - link "Shipping" [ref=f5e13] [cursor=pointer]:
          - /url: /view/home
        - link "Report" [ref=f5e14] [cursor=pointer]:
          - /url: /view/home
        - link "Authority" [ref=f5e15] [cursor=pointer]:
          - /url: /view/home
        - link "Admin" [ref=f5e16] [cursor=pointer]:
          - /url: /view/home
      - generic [ref=f5e17]:
        - button "KOR" [ref=f5e19] [cursor=pointer]
        - button "이 이민용" [ref=f5e23] [cursor=pointer]:
          - paragraph [ref=f5e28]: 이
          - generic [ref=f5e29]: 이민용
    - generic [ref=f5e30]:
      - button [ref=f5e31] [cursor=pointer]
      - complementary [ref=f5e37]:
        - navigation [ref=f5e38]:
          - paragraph [ref=f5e39]: Shipping
          - generic [ref=f5e40]:
            - link [ref=f5e41] [cursor=pointer]:
              - /url: /view/home
              - paragraph [ref=f5e42]: Shipping Master
            - link [ref=f5e45] [cursor=pointer]:
              - /url: /view/home
              - paragraph [ref=f5e46]: Distribution Route
            - link [ref=f5e47] [cursor=pointer]:
              - /url: /view/home
              - paragraph [ref=f5e48]: SSP Model PIC
            - link [ref=f5e49] [cursor=pointer]:
              - /url: /view/home
              - paragraph [ref=f5e50]: SSP Lot Size
            - link [ref=f5e51] [cursor=pointer]:
              - /url: /view/home
              - paragraph [ref=f5e52]: Delegate
            - link [ref=f5e53] [cursor=pointer]:
              - /url: /view/home
              - paragraph [ref=f5e54]: SSP Master Electrode
            - link [ref=f5e55] [cursor=pointer]:
              - /url: /view/home
              - paragraph [ref=f5e56]: SSP Requestor PIC
            - link [ref=f5e57] [cursor=pointer]:
              - /url: /view/home
              - paragraph [ref=f5e58]: SSP Semi Dept Day
            - link [ref=f5e59] [cursor=pointer]:
              - /url: /view/home
              - paragraph [ref=f5e60]: SSP Working Day
          - generic [ref=f5e61]:
            - link [ref=f5e62] [cursor=pointer]:
              - /url: /view/home
              - paragraph [ref=f5e63]: Shipping Schedule
            - link "SSP Request":
              - /url: /view/home
              - paragraph [ref=f5e66] [cursor=pointer]: SSP Request
            - link "SSP Plan(Mobility & IT)":
              - /url: /view/home
              - paragraph [ref=f5e67] [cursor=pointer]: SSP Plan(Mobility & IT)
            - link "SSP Plan(Electrode)":
              - /url: /view/home
              - paragraph [ref=f5e68] [cursor=pointer]: SSP Plan(Electrode)
            - link "SSP Plan(Auto & ESS)-WA_UC":
              - /url: /view/home
              - paragraph [ref=f5e69] [cursor=pointer]: SSP Plan(Auto & ESS)-WA_UC
            - link "SSP Plan Detail":
              - /url: /view/home
              - paragraph [ref=f5e70] [cursor=pointer]: SSP Plan Detail
            - link "SSP Change History":
              - /url: /view/home
              - paragraph [ref=f5e71] [cursor=pointer]: SSP Change History
            - link "SSP Plan(Auto & ESS)":
              - /url: /view/home
              - paragraph [ref=f5e72] [cursor=pointer]: SSP Plan(Auto & ESS)
            - link "SSP Request(Mobility & IT)":
              - /url: /view/home
              - paragraph [ref=f5e73] [cursor=pointer]: SSP Request(Mobility & IT)
            - link "SSP Request(Electrode)":
              - /url: /view/home
              - paragraph [ref=f5e74] [cursor=pointer]: SSP Request(Electrode)
            - link "SSP Change Request":
              - /url: /view/home
              - paragraph [ref=f5e75] [cursor=pointer]: SSP Change Request
            - link "SSP Change Request Confirm":
              - /url: /view/home
              - paragraph [ref=f5e76] [cursor=pointer]: SSP Change Request Confirm
            - link "Inventory Raw(Mobility & IT)":
              - /url: /view/home
              - paragraph [ref=f5e77] [cursor=pointer]: Inventory Raw(Mobility & IT)
            - link "SSP Change Request(Packer)":
              - /url: /view/home
              - paragraph [ref=f5e78] [cursor=pointer]: SSP Change Request(Packer)
            - link "SSP Change Request Confirm(Packer)":
              - /url: /view/home
              - paragraph [ref=f5e79] [cursor=pointer]: SSP Change Request Confirm(Packer)
            - link "SSP Request SEMI":
              - /url: /view/home
              - paragraph [ref=f5e80] [cursor=pointer]: SSP Request SEMI
      - main [ref=f5e81]:
        - generic [ref=f5e83]:
          - generic [ref=f5e84]:
            - generic [ref=f5e85]:
              - button "Home" [ref=f5e86] [cursor=pointer]
              - button "SSP Model PIC" [ref=f5e88] [cursor=pointer]
            - generic [ref=f5e93]:
              - button "Scroll tabs left" [disabled] [ref=f5e94]
              - button "Scroll tabs right" [disabled] [ref=f5e97]
              - button "Close others" [ref=f5e100] [cursor=pointer]
              - button "Close All" [ref=f5e101] [cursor=pointer]
          - generic [ref=f5e102]:
            - generic [ref=f5e106]:
              - generic [ref=f5e107]:
                - generic [ref=f5e108]: Hello! 이민용
                - button "Logout" [ref=f5e109] [cursor=pointer]
              - generic [ref=f5e110]:
                - generic [ref=f5e112]:
                  - generic [ref=f5e113]: Favorite Screens
                  - generic [ref=f5e115]:
                    - generic [ref=f5e116]:
                      - button "Fcst&Price MGMT Demand > Demand Plan" [ref=f5e117] [cursor=pointer]:
                        - generic [ref=f5e118]: Fcst&Price MGMT
                        - generic [ref=f5e119]: Demand > Demand Plan
                      - button "Fcst MGMT delete" [ref=f5e120] [cursor=pointer]: 🗑️
                    - generic [ref=f5e121]:
                      - button "Model Code Master Supply > Supply Master" [ref=f5e122] [cursor=pointer]:
                        - generic [ref=f5e123]: Model Code Master
                        - generic [ref=f5e124]: Supply > Supply Master
                      - button "Model Code Master delete" [ref=f5e125] [cursor=pointer]: 🗑️
                - generic [ref=f5e126]:
                  - generic [ref=f5e127]:
                    - generic [ref=f5e128]: Announcements
                    - paragraph [ref=f5e131]: No announcements.
                  - generic [ref=f5e132]:
                    - generic [ref=f5e133]: My Authorities
                    - generic [ref=f5e135]:
                      - generic [ref=f5e136]: DM Administrator
                      - generic [ref=f5e139]: DM Planner
                      - generic [ref=f5e142]: DM Planner (W/S)
                      - generic [ref=f5e145]: DM Viewer
                      - generic [ref=f5e148]: Guest
                      - generic [ref=f5e151]: SCM PI Admin
                      - generic [ref=f5e154]: SCP Planner
                      - generic [ref=f5e157]: System Administrator
                  - generic [ref=f5e160]:
                    - generic [ref=f5e161]: System Administrators
                    - table [ref=f5e164]:
                      - rowgroup [ref=f5e165]:
                        - row [ref=f5e166]:
                          - columnheader "Module" [ref=f5e167]
                          - columnheader "Division" [ref=f5e168]
                          - columnheader "PIC" [ref=f5e169]
                      - rowgroup [ref=f5e170]:
                        - row [ref=f5e171]:
                          - cell "DM" [ref=f5e172]
                          - cell "40" [ref=f5e173]
                          - cell "김현기" [ref=f5e174]
                        - row [ref=f5e175]:
                          - cell "Logistics" [ref=f5e176]
                          - cell "Shipping Dept" [ref=f5e177]
                          - cell "David Choi" [ref=f5e178]
                        - row [ref=f5e179]:
                          - cell "SCP" [ref=f5e180]
                          - cell "40" [ref=f5e181]
                          - cell "임화영" [ref=f5e182]
                        - row [ref=f5e183]:
                          - cell "Reporting" [ref=f5e184]
                          - cell "BI Team" [ref=f5e185]
                          - cell "Emily Yoon" [ref=f5e186]
                        - row [ref=f5e187]:
                          - cell "SCM Core" [ref=f5e188]
                          - cell "It Operations" [ref=f5e189]
                          - cell "Alice Kim" [ref=f5e190]
                        - row [ref=f5e191]:
                          - cell "Procurement" [ref=f5e192]
                          - cell "Purchasing Dept" [ref=f5e193]
                          - cell "Brian Lee" [ref=f5e194]
            - alert [ref=f5e195]:
              - generic [ref=f5e196] [cursor=pointer]
  - generic [ref=f5e200]:
    - generic [ref=f5e201]: "[plugin:vite:import-analysis] Failed to resolve import \"@shared/paste\" from \"../../features/shipping/src/pages/shipment-model-pic/components/ShipmentModelPicForm.tsx\". Does the file exist?"
    - generic [ref=f5e202]: C:/Projects/NSCM/nscm-fe/features/shipping/src/pages/shipment-model-pic/components/ShipmentModelPicForm.tsx:8:44
    - generic [ref=f5e203]: "22 | import { FunctionSearchIcon } from \"@shared/lges-icons\"; 23 | import { Grid } from \"@shared/mui\"; 24 | import { createMultilinePasteHandler } from \"@shared/paste\"; | ^ 25 | import { confirmIfDirtyKey, tabDirtyKey, useTabid } from \"@shared/stores\"; 26 | import {"
    - generic [ref=f5e204]: at TransformPluginContext._formatLog (file:///C:/Projects/NSCM/nscm-fe/apps/web/node_modules/vite/dist/node/chunks/dep-D4NMHUTW.js:42528:41) at TransformPluginContext.error (file:///C:/Projects/NSCM/nscm-fe/apps/web/node_modules/vite/dist/node/chunks/dep-D4NMHUTW.js:42525:16) at normalizeUrl (file:///C:/Projects/NSCM/nscm-fe/apps/web/node_modules/vite/dist/node/chunks/dep-D4NMHUTW.js:40504:23) at process.processTicksAndRejections (node:internal/process/task_queues:104:5) at async file:///C:/Projects/NSCM/nscm-fe/apps/web/node_modules/vite/dist/node/chunks/dep-D4NMHUTW.js:40623:37 at async Promise.all (index 9) at async TransformPluginContext.transform (file:///C:/Projects/NSCM/nscm-fe/apps/web/node_modules/vite/dist/node/chunks/dep-D4NMHUTW.js:40550:7) at async EnvironmentPluginContainer.transform (file:///C:/Projects/NSCM/nscm-fe/apps/web/node_modules/vite/dist/node/chunks/dep-D4NMHUTW.js:42323:18) at async loadAndTransform (file:///C:/Projects/NSCM/nscm-fe/apps/web/node_modules/vite/dist/node/chunks/dep-D4NMHUTW.js:35739:27) at async viteTransformMiddleware (file:///C:/Projects/NSCM/nscm-fe/apps/web/node_modules/vite/dist/node/chunks/dep-D4NMHUTW.js:37254:24
    - generic [ref=f5e205]:
      - text: Click outside, press Esc key, or fix the code to dismiss.You can also disable this overlay by setting
      - code [ref=f5e206]: server.hmr.overlay
      - text: to
      - code [ref=f5e207]: "false"
      - text: in
      - code [ref=f5e208]: vite.config.ts
      - text: .
```

# Test source

```ts
  1   | // 자동 생성 — tools/E2E/gen-e2e.js (2026-11-19) · 원천: Doc/gen/SSP0014/e2e_plan.json · 손으로 고치지 말고 룰/플랜을 고칠 것
  2   | import { test, expect } from '../../../tools/E2E/fixtures/test';
  3   | import * as fs from 'node:fs';
  4   | const PLAN = JSON.parse(fs.readFileSync(__dirname + '/SSP0014.plan.json', 'utf8'));
  5   | const MENU = "SSP0014";
  6   | import { conditionCycle, commonCycle, record } from '../../../tools/E2E/lib/smoke-extra';
  7   | import { loadLabelAliases, aliasFor } from '../../../tools/E2E/lib/labelalias';  // 2026-11-08 (a) 사양 표 공유 — 검사기(_trace G4)와 같은 라벨 별칭 표(label_alias.csv · CR-092 Valid→Active)
  8   | 
  9   | test.describe(`${MENU} ShipmentModelPIC 스모크 @smoke`, () => {
  10  |   test.use({ account: PLAN.sample.account || undefined });
  11  |   test('화면 열림 · 조회조건 · 조회 · 그리드 컬럼', async ({ nscm, page }) => {
  12  |     const r = await nscm.openScreen(MENU);
  13  |     expect(r.notFound, '404 아님').toBeFalsy();
> 14  |     expect(r.authorized, '권한 안내 없이 열림').toBeTruthy();
      |                                         ^ Error: 권한 안내 없이 열림
  15  |     await nscm.snapshot(`${MENU}_open`);
  16  |     // 2026-10-21: 화면 열자마자 콘솔 치명 오류를 먼저 확인 — 그리드 생성이 Wijmo 단언으로 죽으면(SCP0100 "Unknown property inner") 뒤의 라벨/그리드 검사는 전부 부수 증상이다
  17  |     { await page.waitForTimeout(800); const errs0 = nscm.consoleErrors; const fatal0 = errs0.filter(e => /Assertion failed|Uncaught|is not a function|Cannot read propert|Unknown property/i.test(e));
  18  |       if (errs0.length) test.info().annotations.push({ type: 'console', description: `열림 직후 오류 ${errs0.length}(치명 ${fatal0.length}): ${[...fatal0, ...errs0.filter(e => !fatal0.includes(e))].slice(0, 3).join(' || ')}` });
  19  |       expect.soft(fatal0.length, `화면 열림 직후 브라우저 콘솔 치명 오류 0 — ${fatal0[0] || ''}`).toBe(0); }
  20  |     // 조회조건 라벨 존재(soft) — 2026-10-21: 접힌 조건(extraConditions) 펼친 뒤, To-Be LBL 문구 → As-is 라벨('*' 제거) → '/' 분할 후보 순으로 찾는다.
  21  |     //   __asis-mapping__.md 에서 '제외' 로 닫힌 As-is 컨트롤(dead control·NO-OP)은 검사하지 않고 어노테이션만 남긴다.
  22  |     const expanded = await nscm.expandSearchArea();
  23  |     const labelHits: string[] = [], labelMiss: string[] = [], labelSkip: string[] = [];
  24  |     for (const f of PLAN.fields) {
  25  |       if (f.excluded) { labelSkip.push(`${f.label}(${f.asis}: ${f.excludedWhy})`); continue; }
  26  |       // 2026-11-08 (a): 별칭 표의 TO-BE 명칭(예 Valid→Active)도 후보 — 검사기와 기대값 원천을 같이 쓴다(종전엔 smoke 만 별칭 없이 '누락' → 검사기 PASS 와 불일치)
  27  |       const cands0: string[] = f.labels && f.labels.length ? f.labels : [f.label];
  28  |       const AL = loadLabelAliases(MENU); const cands = [...new Set([...cands0, ...cands0.map((l: string) => aliasFor(l, AL)?.tobe_label || '').filter(Boolean)])];
  29  |       const hit = await nscm.fieldExistsAny(cands);
  30  |       if (hit) labelHits.push(`${f.label}→${hit}`); else labelMiss.push(f.label);
  31  |       expect.soft(!!hit, `조회조건 '${f.label}' (${f.component}) — 후보 [${(f.labels || [f.label]).join(' | ')}]`).toBeTruthy();
  32  |     }
  33  |     test.info().annotations.push({ type: 'labels', description: `펼침=${expanded} 일치 ${labelHits.length} / 누락 ${labelMiss.length}${labelMiss.length ? ': ' + labelMiss.join(', ') : ''}${labelSkip.length ? ' / 제외 ' + labelSkip.length + ': ' + labelSkip.join('; ') : ''}` });
  34  |     // 그리드 수 ≥ 1 (다그리드는 탭/패널이라 1 이상이면 통과, 메인시트 수와 함께 기록)
  35  |     const gridCount = await nscm.grids().count();
  36  |     expect(gridCount, `그리드 ≥1 (메인시트 ${PLAN.mainSheets.length})`).toBeGreaterThanOrEqual(1);
  37  |     // Division 선택(있으면) 후 조회
  38  |     if (PLAN.sample.div) await nscm.setDivision(PLAN.sample.div);
  39  |     const calls = await nscm.search();
  40  |     const search = calls.filter(c => /SEARCH|GET|_|^$/i.test(c.btn));
  41  |     expect(calls.length, 'call-proc 호출 발생').toBeGreaterThan(0);
  42  |     for (const c of calls) expect.soft(c.status, `call-proc ${c.sheet}/${c.btn} HTTP`).toBeLessThan(400);
  43  |     // 2026-10-21: 브라우저 콘솔 오류/페이지 예외 — Wijmo 단언(그리드 생성 실패)·Uncaught 는 화면 결함으로 FAIL, 나머지는 기록만
  44  |     { const errs = nscm.consoleErrors; const fatal = errs.filter(e => /Assertion failed|Uncaught|is not a function|Cannot read propert|Unknown property/i.test(e));
  45  |       test.info().annotations.push({ type: 'console', description: errs.length ? `오류 ${errs.length}(치명 ${fatal.length}): ${[...fatal, ...errs.filter(e => !fatal.includes(e))].slice(0, 3).join(' || ')}` : '오류 0' });
  46  |       expect.soft(fatal.length, `브라우저 콘솔 치명 오류 0 — ${fatal[0] || ''}`).toBe(0); }
  47  |     const alert = await nscm.alertText(); if (alert) { await nscm.closeAlert(); }
  48  |     expect.soft(alert, '조회 후 오류 알림 없음').not.toMatch(/ORA-|Exception|오류|error/i);
  49  |     // 컬럼 대사: 메타(sheet_columns) 있으면 메타, 없으면 As-is 라벨(soft)
  50  |     const headers = await nscm.gridHeadersAll(0);  // T162: 가로 가상화로 DOM 헤더가 일부만 보여 허위 누락
  51  |     // 기대 컬럼의 시트 = 실제 조회된 시트(첫 SEARCH call-proc 의 sheet → register.json adminSheetName). 매핑이 없으면 mainSheets[0]
  52  |     const titleSheets: string[] = (PLAN.dynamicHeader && PLAN.dynamicHeader.titleSheets) || [];
  53  |     const firstSearch = calls.find(c => /SEARCH/i.test(c.btn) && !titleSheets.includes(c.sheet)) || calls.find(c => /SEARCH/i.test(c.btn)) || calls[0]; // 타이틀(기간 헤더) 시트 호출은 제외
  54  |     const mappedSheet = firstSearch && PLAN.sheetMap ? PLAN.sheetMap[firstSearch.sheet] : '';
  55  |     const sheetName = mappedSheet && PLAN.mainSheets.some((s: { name: string }) => s.name === mappedSheet) ? mappedSheet : PLAN.mainSheets[0]?.name;
  56  |     const expectCols = PLAN.hasMeta ? (PLAN.expectedCols[sheetName]?.[PLAN.sample.div] || []) : (PLAN.mainSheets.find((s: { name: string }) => s.name === sheetName)?.labels || []);
  57  |     const norm = (s: string) => s.toLowerCase().replace(/[^a-z0-9가-힣]/g, '');
  58  |     // 2026-10-21: As-is SetLayout(조회조건에 따라 표시/숨김)이 다루는 컬럼은 기본 조회에서 안 보여도 '누락' 이 아니다(SCP0100 Product Level1~3)
  59  |     const condSet = new Set(((PLAN.condLabels || []) as string[]).map(norm));
  60  |     const missingAll = expectCols.filter((c: string) => c && !headers.some(h => norm(h) === norm(c) || norm(h).includes(norm(c))));
  61  |     const condHidden = missingAll.filter((c: string) => condSet.has(norm(c)));
  62  |     const missing = missingAll.filter((c: string) => !condSet.has(norm(c)));
  63  |     test.info().annotations.push({ type: 'columns', description: `시트 ${sheetName}(${firstSearch ? firstSearch.sheet : '-'}) 헤더 ${headers.length} / 기대 ${expectCols.length} / 누락 ${missing.length}: ${missing.slice(0, 10).join(', ')}${condHidden.length ? ' / 조건부 표시(SetLayout) 제외 ' + condHidden.length + ': ' + condHidden.join(', ') : ''}` });
  64  |     expect.soft(missing.length, `그리드 컬럼 누락 (${PLAN.hasMeta ? '메타' : 'As-is 라벨'} 기준)`).toBeLessThanOrEqual(Math.ceil(expectCols.length * 0.2));
  65  |     // 동적 헤더(기간 컬럼) — As-is 타이틀 SP/DB루프가 있으면 정적 메타 밖 컬럼 ≥1 + 사내 배선 타이틀 시트 조회(2026-10-20 SCP0096)
  66  |     // As-is 헤더 사양 대조(2026-10-21 SCP0100: 대조표 '구현' 인데 3단 헤더가 144px 한 칸으로 병합되고 "Qty" 행이 없었다) — 행 수·병합 리터럴·행 높이
  67  |     if (PLAN.headerSpec && PLAN.headerSpec.rows > 1) {
  68  |       const HS = PLAN.headerSpec; const hr = await nscm.gridHeaderRows(0);
  69  |       const texts = new Set(hr.rows.flatMap(r => r.texts));
  70  |       const missLit = (HS.literals || []).filter((l: string) => !texts.has(l));
  71  |       test.info().annotations.push({ type: 'header', description: `As-is 헤더 ${HS.rows}행(병합 리터럴 ${(HS.literals || []).join('/') || '-'}) ↔ To-Be 행 ${hr.rows.length}(높이 ${hr.rows.map(r => r.h).join('+')}=${hr.height}px)${missLit.length ? ' · 리터럴 누락 ' + missLit.join(',') : ''}` });
  72  |       // 행 수는 '시각적 단' 기준 — As-is 월간은 3행이어도 Qty 가 1~2행을 병합해 2단으로 보인다. 따라서 2단 이상이면 통과(리터럴·분리·높이 검사가 실질 판정)
  73  |       expect.soft(hr.rows.length, `헤더 시각적 단 수 ≥ 2 (As-is SetSheetHeaderColumn ${HS.rows}행 · 월간은 Qty 2행 병합 = 2단) — 1단이면 columnGroups leaf 라벨 점검`).toBeGreaterThanOrEqual(Math.min(HS.rows, 2));
  74  |       expect.soft(missLit.length, `As-is 병합 헤더 리터럴 노출 [${(HS.literals || []).join(', ')}]`).toBe(0);
  75  |       expect.soft(hr.height, `헤더 총 높이 ≤ ${HS.maxRowPx}px × ${HS.rows}행 (headerRowHeight 재적용 — check.js H01)`).toBeLessThanOrEqual(HS.maxRowPx * HS.rows);
  76  |       // 2026-10-21 사용자 지적: ① 리터럴(Qty) 칸은 상단 월 칸이 분리돼 있으면 하단도 분리(가로 병합 1칸 금지) ② leaf(Qty) 행이 그룹(월) 행보다 낮으면 As-is 와 역전
  77  |       if (HS.literals && HS.literals.length && hr.rows.length >= 2) {
  78  |         const top = hr.rows[0]; const litRow = hr.rows.find(r => (HS.literals as string[]).some((l: string) => r.texts.includes(l)));
  79  |         if (litRow) {
  80  |           const topDyn = top.cells.filter(c => !/^[A-Za-z가-힣 ./()]+$/.test(c)).length; // 상단 행에서 문자 라벨(고정 컬럼)이 아닌 칸(연월·주차) 수
  81  |           test.info().annotations.push({ type: 'header', description: `리터럴 행 칸 ${litRow.n} / 상단 동적 칸 ${topDyn} · 높이 상단 ${top.h} vs 리터럴 행 ${litRow.h}` });
  82  |           if (topDyn >= 2) expect.soft(litRow.n, `리터럴(${HS.literals.join('/')}) 칸이 월마다 분리(상단 동적 칸 ${topDyn}) — 1칸이면 헤더 가로 병합(check.js H05)`).toBeGreaterThanOrEqual(Math.min(topDyn, 2));
  83  |           expect.soft(litRow.h >= top.h, `leaf(${HS.literals.join('/')}) 행 높이(${litRow.h}) ≥ 상단 그룹 행(${top.h}) — As-is 는 Qty 영역이 더 높다(1~2행 병합)`).toBeTruthy();
  84  |         }
  85  |       }
  86  |     }
  87  |     if (PLAN.dynamicHeader) {
  88  |       const DH = PLAN.dynamicHeader;
  89  |       const binds = await nscm.gridBindings(0);
  90  |       const stat = new Set((DH.staticBindings || []).map((s: string) => s.toUpperCase()));
  91  |       const dyn = (binds || []).filter((b: string) => !stat.has(b.toUpperCase()));
  92  |       const titleCalls = nscm.calls.filter(c => (DH.titlePairs || []).some((p: { sheet: string; btn: string }) => p.sheet === c.sheet && p.btn.toUpperCase() === c.btn.toUpperCase()));
  93  |       test.info().annotations.push({ type: 'dynamic', description: `As-is ${DH.titles.map((t: { sp: string }) => t.sp).join(',') || '-'} · DB루프 ${(DH.dbLoop || []).join(',') || '-'} · 컬럼정의 ${binds ? binds.length : '판정불가'} / 정적밖 ${dyn.length} (${dyn.slice(0, 5).join(',')}) · 타이틀 시트 ${(DH.titleSheets || []).join(',') || '(사내 배선 없음)'} 호출 ${titleCalls.length}` });
  94  |       expect.soft(binds, '그리드 컬럼 정의 판독(Wijmo columns) — null 이면 판정 불가(ERROR)').not.toBeNull();
  95  |       expect.soft(dyn.length, `동적 기간 컬럼 ≥1 (As-is ${DH.titles.map((t: { sp: string }) => t.sp).join(',') || 'DB루프'} — 정적 메타 ${stat.size}개 밖 컬럼)`).toBeGreaterThan(0);
  96  |       if ((DH.titleSheets || []).length) expect.soft(titleCalls.some(c => c.status < 400), `타이틀 시트 '${DH.titleSheets.join("','")}' call-proc 조회`).toBeTruthy();
  97  |     }
  98  |     await nscm.snapshot(`${MENU}_searched`);
  99  |     test.info().annotations.push({ type: 'calls', description: JSON.stringify(calls.map(c => [c.sheet, c.btn, c.status, c.rows, c.ms])) });
  100 |     // 2026-10-23 사용자 지시: 다국어 미적용(코드 미등록 → '_기본문구' 노출) = 오류 — 조회조건 펼침·조회 후 보이는 글자 전체
  101 |     { const u = await nscm.untranslatedTexts();
  102 |       test.info().annotations.push({ type: 'i18n', description: u.length ? `'_' 노출 ${u.length}: ${u.slice(0, 15).join(' | ')}` : "'_' 노출 0" });
  103 |       expect.soft(u.length, `다국어 미적용 '_' 노출 0 — ${u.slice(0, 8).join(' | ')} (SCM_ADM_MSG_M 에 코드 등록 또는 기존 LBL/MSG 재사용 · 하네스 I18N1)`).toBe(0); }
  104 |   });
  105 |   // 2026-10-23 사용자 지시: 조회조건 각각의 동작 · 공통 기능 동작 (lib/smoke-extra.ts) — 결과는 cond:/common: 어노테이션 → _summary · 대조표(recon) 열
  106 |   test('조회조건 동작 — 조건별 값 변경 → 조회 · 기준표 순서 · Checkbox/Radio 디자인', async ({ nscm }) => {
  107 |     test.setTimeout(1_200_000);
  108 |     const r = await nscm.openScreen(MENU); expect(r.authorized, '권한 안내 없이 열림').toBeTruthy();
  109 |     const items = await conditionCycle(nscm, test.info(), PLAN);
  110 |     const s = record(test.info(), 'cond', items);
  111 |     await nscm.snapshot(`${MENU}_cond`);
  112 |     expect.soft(s.fail, `조회조건 동작 FAIL ${s.fail}: ${items.filter(i => i.verdict === 'FAIL').map(i => i.name).join(', ')}`).toBe(0);
  113 |     expect.soft(s.error, `조회조건 판정 불가(ERROR) ${s.error}: ${items.filter(i => i.verdict === 'ERROR').map(i => i.name).join(', ')}`).toBe(0);
  114 |   });
```