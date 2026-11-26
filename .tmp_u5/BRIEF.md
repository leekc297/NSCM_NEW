# SCP0005 미검증 해소 라운드 3 공통 지시(2026-11-25)

## 목표
CheckList(SCP0005) 원장에서 미검증(ERROR) 이거나 AI 판정 검토가 '검사기오판·추출오류'로 가린 행을, 공용 검사엔진을 고쳐 다음 CheckList 에서 기계가 판정하게 만든다. 맡은 행 목록은 `C:\Projects\NSCM\.tmp_u5\rows_by_bundle.csv`(bundle 열)에 증거·처리 방법과 함께 있다.

## 먼저 읽을 것
- `Doc/verify/SCP0005/_unverified_work.md` 라운드 1·2 기록(같은 시도 되풀이 금지)
- 원장 `Doc/verify/SCP0005/verify_ledger.csv`(row_id 로 찾기), E2E 결과 `Doc/verify/SCP0005/e2e_results.json`, `e2e/`, `_test_timing.jsonl`, `llm_review.csv`(AI 검토 근거·fix_hint), 기준 `Doc/verify/SCP0005/criteria/criteria.md`
- AS-IS 원문 `GSCM/06.UIL/**/SCP0005_DistributionRoute.cs` 등, AS-IS 사실 `Doc/asisfacts/screens/SCP0005/`, TO-BE 사실 `Doc/tobefacts/`
- 검사기 결함 유형 `Doc/verify/_checker_defects.md`(쓰지 말 것, 읽기만)

## 규칙
1. 원인은 실측으로 확인한다(결과 파일·로그·원문 줄). 추측으로 쓰지 않는다. AI 검토 문장은 출발점일 뿐이고 원문을 직접 다시 본다.
2. 고치는 대상은 공용 검사엔진(tools/Harness/verify, tools/E2E, Doc/e2e/specs 공용 스펙, 규칙표 csv). 화면 ID·시트명·컬럼명·라벨을 검사기에 고정하지 않는다. 다른 화면도 같이 풀리게 만든다.
3. nscm-fe, nscm-be, AS-IS 원본 소스, Doc/asisfacts 사실 파일(손 수정), llm_review.csv·opinion_intake.csv·llm_facts.csv 는 고치지 않는다. 화면 결함이면 FAIL 이 되게 측정 경로를 만들고 고칠 곳은 보고서에 가이드로 적는다.
4. 판정을 낮추지 않는다. 재지 못한 행을 NA·PASS 로 바꾸는 코드 금지. NA 는 AS-IS 원문·메타 근거가 있을 때만. 기대값을 실측값에 맞추지 않는다.
5. 맡은 파일만 고친다(아래 소유표). 다른 에이전트 소유 파일을 고쳐야 하면 고치지 말고 보고서에 '타 파일 필요: 파일, 변경 내용'으로 적는다. 다른 세션도 같은 파일을 고치므로 수정 직전에 파일을 다시 읽고 필요한 부분만 고친다. 수정 전 백업 `<파일>.bak_20261125_scp05u3` 를 만든다. 줄바꿈(CRLF/LF)을 원래대로 유지한다.
6. CheckList(run_verify.py, checklist_run.py), E2E·Playwright 실행, 개별 검사기 전체 재실행 금지. 확인은 단위 함수 시험·검사기 selftest·py_compile·tsc(`cd tools/E2E && npx tsc --noEmit -p .` 또는 engine_selfcheck 가 쓰는 방식)로만 한다. 30초 넘을 수 있는 명령은 timeout 을 건다.
7. DB 는 조회만(사내 오라클 접속은 tools/DbConn 사용). 쓰기 금지.
8. 고친 각 원인마다 수정 지점 위에 `# T5xx(2026-11-25 SCP0005 <규칙> <행 수>행): 원인 한 줄` 주석을 단다. 배정된 T 번호 범위 안에서 쓴다. `_checker_defects.md`, `_ENGINE_MASTER.md`, `unverified_classes.csv` 는 쓰지 않는다(필요한 내용은 보고서에).
9. 판단이 필요한 것(AS-IS·TO-BE 근거 없음, 화면 기능 누락 때문에 측정 불가 등)은 고치지 말고 결정 후보로 보고한다(정할 내용, 권장안, 근거 경로:줄).
10. 문장 규칙: 한국어, 수식어·번역투·줄표 없이 짧게. 화면ID·컬럼명·파일:줄·건수로 쓴다.

## 산출물(필수)
- `C:\Projects\NSCM\.tmp_u5\res_<담당>.csv` (utf-8-sig) 열: row_id,result,note
  - result 는 다음 중 하나: `보완`(검사기 고침, 다음 CheckList 에서 판정 경로 바뀜) · `결정`(결정 목록) · `재수행`(일시 실패 확인, 재수행에 맡김) · `미처리`(못 고침)
  - note: 원인(실측 근거 파일:줄) + 고친 파일:줄 + 다음 CheckList 예상 판정 경로(미측정) 또는 미처리 사유(막힌 파일·원인·필요한 결정). 220자 안
  - 맡은 행 전부를 한 행씩 빠짐없이 적는다
- `C:\Projects\NSCM\.tmp_u5\rep_<담당>.md`: 묶음별 원인(실측 근거), 고친 파일:라인, 확인 명령과 결과, 새 결함 유형(T번호·이름·한 줄 설명), 결정 후보, 타 파일 필요 항목, 새로 만든 도구 파일 목록

## 파일 소유표
| 담당 | 소유 파일 | T 번호 |
|---|---|---|
| T | Doc/e2e/specs/_trace.spec.ts | T540~T544 |
| V | Doc/e2e/specs/_verify.spec.ts, tools/E2E/lib/*.ts(saveprobe, newrow, crud, langacct 등) | T545~T549 |
| G | tools/Harness/verify/gen_expect.py | T550~T554 |
| L | tools/Harness/verify/ledger.py, judge.py, mapping_trace.py, backlog_types.py, menu_auth 관련 py | T555~T559 |
| S | tools/DbConn/golden.py, Doc/golden/golden_cases.csv, tools/Harness/verify/diff_verify.py, diff_ingest.py, sort_check.py, syn_check.py, facts_sortrules.py, gen_param_map.py | T560~T564 |
| P | Doc/e2e/specs/eg_popup.spec.ts, tools/Harness/verify/facts_cellrules.py, facts_lockrules.py, 그 밖 facts_*.py(facts_sortrules 제외), tools/AsisFacts | T565~T569 |
