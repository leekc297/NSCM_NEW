# REPAIR SCP0100 — 2026-10-20 14:32:04

## 게이트 0회차 — BLOCK 15 / WARN 0
- ✗ P20 미이식 TODO 잔존 @SCP0100_PKG.sql:80
- ✗ P20 미이식 TODO 잔존 @SCP0100_PKG.sql:271
- ✗ P20 미이식 TODO 잔존 @SCP0100_PKG.sql:272
- ✗ P20 미이식 TODO 잔존 @SCP0100_PKG.sql:276
- ✗ P20 미이식 TODO 잔존 @SCP0100_PKG.sql:277
- ✗ P20 미이식 TODO 잔존 @SCP0100_PKG.sql:420
- ✗ P20 미이식 TODO 잔존 @SCP0100_PKG.sql:423
- ✗ P21 빈 결과셋 스텁 잔존 @SCP0100_PKG.sql:80
- ✗ P21 빈 결과셋 스텁 잔존 @SCP0100_PKG.sql:270
- ✗ P21 빈 결과셋 스텁 잔존 @SCP0100_PKG.sql:272
- ✗ P21 빈 결과셋 스텁 잔존 @SCP0100_PKG.sql:274
- ✗ P21 빈 결과셋 스텁 잔존 @SCP0100_PKG.sql:276
- ✗ P21 빈 결과셋 스텁 잔존 @SCP0100_PKG.sql:418
- ✗ P21 빈 결과셋 스텁 잔존 @SCP0100_PKG.sql:422
- ✗ P00 ASIS 원문 블록 3개 잔존 — 이식 후 삭제 @SCP0100_PKG.sql

## Claude 1회차 (exit 0)
```

- 사내 현행 프로시저와 결과(컬럼·행·순서)를 78케이스 대조했습니다.
  - 50건은 완전히 같습니다.
  - 28건은 조건에 맞는 갈래가 없는 경우입니다. 현행은 결과를 열지 않고, 이식본은 0행을 돌려줍니다(아래 의도된 차이).
  - 다른 결과는 0건입니다.
- AS-IS MSSQL 원본과 결과를 직접 대조하지는 않았습니다. 이번 대조 기준은 사내 To-Be 현행본입니다.

## 남은 항목
1. ⚠️ **이 파일을 사내에 그대로 배포하면 안 됩니다.** 사내 PKG_SCP0100 에는 메인 조회 `P_SCP0100_GET_GLOBAL_PSI_REPORT`, `_WW/_MM_DATAONLY`, 내부 `PR_SET_FINAL_COLS` 가 있습니다. 이 파일을 그대로 `CREATE OR REPLACE` 하면 이것들이 지워집니다. 반영할 때는 최신 원문을 다시 조회한 뒤 그 위에 프로시저 단위로 병합해야 합니다. 파일 머리말과 NOTES 에 이 경고를 적어 두었습니다.
2. **O_RC 수를 줄였습니다.** GET_SITE 는 4개에서 1개로, PLAN_DATE 는 2개에서 1개로 바꿨습니다. As-is 가 실행 시 SELECT 1개만 돌려주고, 사내 현행 시그니처도 1개입니다. `e2e_plan.json` 과 `__asis-mapping__.md` §4 에는 O_RC 수 항목이 없어 고칠 곳이 없었습니다.
3. **As-is 와 다르게 한 부분**(사유는 NOTES 에 적었습니다):
   - 골격에 있던 필수값 검사를 지웠습니다. As-is 에는 없는 검사입니다.
   - 조건에 맞는 갈래가 없으면 같은 컬럼의 0행 결과를 엽니다. 결과를 열지 않은 채 돌려주면 BE 가 읽을 때 오류가 납니다.
   - 오류가 나면 골격 규약대로 -20001 예외를 던집니다. 사내 현행본은 `'-1'` 결과를 돌려주는 방식이라, 오류 표시가 달라집니다.
4. **아직 하지 않은 것**: 공식 check-pkg 실행, 사내 반영(병합), registration.sql 재실행, 클라우드 패키지 생성. 사내에 적용한 것이 없어서 클라우드 패키지 대상도 아직 없습니다.

변경 파일: `Doc/gen/SCP0100/SCP0100_PKG.sql`, `Doc/gen/SCP0100/SCP0100_PKG_NOTES.md`
Ignoring --allowedTools rule "*)": Wildcard tool name "*)" is not supported in allow rules. An allow pattern must name the scope it widens — globs are permitted only in the tool position after a literal mcp__<server>__ prefix. Deny and ask rules accept wildcards anywhere.
Ignoring --allowedTools rule "*)": Wildcard tool name "*)" is not supported in allow rules. An allow pattern must name the scope it widens — globs are permitted only in the tool position after a literal mcp__<server>__ prefix. Deny and ask rules accept wildcards anywhere.
Ignoring --allowedTools rule "*)": Wildcard tool name "*)" is not supported in allow rules. An allow pattern must name the scope it widens — globs are permitted only in the tool position after a literal mcp__<server>__ prefix. Deny and ask rules accept wildcards anywhere.
Ignoring --allowedTools rule "*)": Wildcard tool name "*)" is not supported in allow rules. An allow pattern must name the scope it widens — globs are permitted only in the tool position after a literal mcp__<server>__ prefix. Deny and ask rules accept wildcards anywhere.
Ignoring --allowedTools rule "*)": Wildcard tool name "*)" is not supported in allow rules. An allow pattern must name the scope it widens — globs are permitted only in the tool position after a literal mcp__<server>__ prefix. Deny and ask rules accept wildcards anywhere.
```

## 게이트 1회차 — BLOCK 0 / WARN 0

**PASS** (WARN 0) — 1회 수선
