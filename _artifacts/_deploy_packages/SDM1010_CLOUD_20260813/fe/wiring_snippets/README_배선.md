# 배선 스니펫 (수동 병합 — 파일 통짜 덮어쓰기 금지, 클라우드 본과 diff 후 삽입)

1. `nscm-fe/configs/types/procedures.d.ts`
   - `procedures.d.ts__SDM1010_block.txt` 를 `RawProcedureMap` 인터페이스 안(마지막 화면 블록 뒤,
     닫는 `}` 앞)에 삽입. 기존 SDM1010 블록이 있으면 통째 교체.
   - 2026-08-13 갱신 포함: POP1_GRID1.request.userName / POP1_GRID4.response.REQ_ACTION
2. `nscm-fe/configs/tsconfig.base.json` — compilerOptions.paths 에:
   "@sdm/*": ["features/sdm/src/pages/*/index.ts"],
3. `nscm-fe/apps/web/package.json` — dependencies 에:
   "@sdm": "workspace:*",
