# E03 통합 요청 (메인 세션용)

이 에이전트는 공용 파일을 고치지 않았다. 아래를 메인 세션이 통합한다. 검사기는 `Doc/e2e/specs/eg_auth.spec.ts`(@eg-auth) · `tools/E2E/lib/authprobe.ts` · `tools/Harness/verify/facts_auth.py` · `facts_auth_db.py` · `facts_auth_combo.py` 이다.

## 1. 체인 연결 (run_verify.py)
- 변경 전: E03 검사기 호출 없음.
- 변경 후: 화면 체인에 다음 순서 추가(계정 순회가 길어 `--tier slow` 권장).
  1. `python -I tools/Harness/verify/facts_auth.py <ID>` — 산출물 경로를 공식 위치(`Doc/verify/<ID>/auth_facts.json`)로 옮길 경우 `OUT` 와 `authprobe.loadFacts` 를 같이 바꾼다.
  2. `VERIFY_ID=<ID> CL_RESULTS=Doc/verify/<ID>/eg_auth.json E2E_RESULTS=<폴더> ... playwright test eg_auth --workers 1 --retries 0`. `VERIFY_NO_SAVE=1` 이 없으면 스펙이 skip 한다.
  3. `python -I tools/Harness/verify/facts_auth_combo.py <ID> <폴더>` (eg_combos.json → eg_combo_judge.json, EG367·EG061·EG366).
- 이유: 스펙이 공식 체인 필터(_verify·_trace)에 걸리지 않게 분리되어 있다.

## 2. 원장·판정 반입 (ledger.py · judge.py · mapping_checkdefs.csv)
결과 형식: `[{eg, screen, target, ctx, result(PASS|FAIL|NA|ERROR|판정필요), expected, actual, asis, note}]`
- ledger.py 변경 전: Div 순회·계정 순회 행 없음 → 변경 후: RULE_SCREEN 행을 규칙별 1행 추가(화면이 Division 칸을 가진 경우).
- judge.py 변경 전: 반입 없음 → 변경 후: `eg_auth.json` 을 EG→규칙으로 묶어 반입. 한 규칙에 FAIL 이 하나라도 있으면 FAIL, 판정이 PASS 뿐이면 PASS, ERROR 만 있으면 ERROR. **판정필요 는 FAIL 로 올리지 말 것**.

| EG | 규칙 | | EG | 규칙 |
|---|---|---|---|---|
| EG007 EG368 | A1·J1 | | EG271 EG275 EG294 | G4·G6 |
| EG022 EG402 | A5·K2 | | EG365 EG366 EG367 | J1 |
| EG024 EG257 | A5·G1 | | EG369 EG373 EG374 EG372 | J2 |
| EG032 | A6 | | EG376 EG377 EG378 | J3 |
| EG061 EG067 | B4·B5 | | EG380 EG382 | J4 |
| EG065 EG086 | B5·C2 | | EG395 EG402 | K2 |
| EG109 EG113 EG123 EG124 | D1·D2·D3 | | EG411 | K4 |
| EG126 EG140 EG319 EG315 | D4·D6·H3 | | EG160 EG212 EG231 EG242 | E3·F4·F7·F8 |

- 이유: FAIL 계약(기대·실제·AS-IS 근거)이 결과 행에 이미 있다. `asis` 가 빈 행은 없어야 하지만, 문서 행(DM-85 등)만 근거인 FAIL 은 evidence_check 통과 여부를 확인할 것.

## 3. 공용 파일 변경 제안
- `tools/E2E/lib/condeval.ts`: 그대로 재사용. `CTL(x)=="v"` 원자는 authprobe 가 평가 전 치환한다(변경 불필요).
- `Doc/asisfacts` 추출기: `facts_auth.py` 의 DIVX 패턴 밖 변수명은 RAW 로 남아 ERROR 로 보고된다. 이번 측정 화면에서 RAW 0건(status.csv 증거 참조) — 추가 화면에서 RAW 가 나오면 패턴 보강.
- `tools/E2E/users.json`(사용자 관리): GUEST 전용 대표 계정 1개 등록 요청. 없으면 EG380 의 BE 판정을 잴 수 없다.

## 4. 메인 세션 실저장 필요
- EG231 삭제 연계: AS-IS DELETE 대상 추출 → Delete 저장 전후 대상 테이블 행 수(ETC 원장 · 권한 요청 · 하위 권한) · 문서 GAP-327·473·476 · 화면 DMF0044·SYS0014. `lib/savecheck.ts` diffSnap 재사용 권장.
- EG242 감사 칸: `save_audit.py` 대상을 루트 행 → `backs` 전 테이블로 확대 · 문서 GAP-278 · 화면 DMF0043.
- EG160 필수: 메타 필수 컬럼마다 공란 저장 → 저장 검증 메시지 집합 ↔ 컬럼 설정 '*' ↔ 메타 3자 대조.
- EG113·EG376 저장 차단: 룩업 시간창 밖 계정으로 저장 → 서버 메시지(MSG00474 등) 확인.
- EG395 저장 구성: 칸 순서 변경 저장 → 재조회 헤더 순서 → Default 복원. 이번 측정은 POST 를 서버로 보내지 않고 화면 반응만 쟀다.

## 5. 사용자 결정 필요
- 메뉴 권한 없는 계정의 URL 직접 접근 허용(라우트 가드 없음) 이 결함인가(EG382 판정필요).
- `.env.asis` 접속처가 운영 AS-IS 인가 — EG372 대조 전제.
- AS-IS UI Category(dbmeta)와 TO-BE UI Category 차이(EG022 정적 판정필요 행): 문서가 TO-BE 확정이라 적은 화면과 동기화 대상 화면 구분.

## 6. 재개 명령 (부하 확인 후 메인 세션이 순차 실행)
이 에이전트는 코디네이터 지시(23:12)로 E2E 를 멈췄다. 남은 실측:
```
rm Doc/verify/_parallel/E03/tools/STOP.flag      # 부하 해소 확인 후에만. 있으면 run_screen.sh 가 건너뛴다
bash Doc/verify/_parallel/E03/tools/chain.sh Doc/verify/_parallel/E03/tools/plan_resume.txt
python -I tools/Harness/verify/facts_auth_combo.py DMF0003 Doc/verify/_parallel/E03/runs/r9_DMF0003
python -I Doc/verify/_parallel/E03/tools/status_build.py     # status.csv 재생성(실행 결과만 집계)
```
`plan_resume.txt` 한 줄 = `화면|실행명|grep(# = 또는)|EG_MUT|계정 상한`. 변이 실행명은 `m_` 로 시작해야 변이로 집계된다. chain.sh 는 줄 사이에 BE 로그 'Connection is not available' 증가·실행 로그 ERR_CONNECTION/로그인 실패를 보면 멈춘다. CPU 100%·픽스처 타임아웃은 자동 판단하지 않으니 줄 사이에 사람이 확인할 것. 시작 전 `facts_auth.py <ID>` 로 facts 를 새로 만들 것(룩업·권한이 바뀌었을 수 있음).

주의: 다음 수정은 **실행 검증 전**이다 — Insert 대기 폴링·Div 없는 화면(patch 22:32) · Measure 재측정·EG380 실계정 전용·설정 저장 전 항목 이동(23:11) · 콤보 전체 후보(23:20). 타입 검사만 통과.

## 7. 판정 주의 (반입 전 확인)
- EG271 DMF0040 Plant Site Div 82 FAIL: AS-IS 문장(DMF0040_MktFcst_Comparison.cs:998)은 활성, 문서 DM-P59 는 'ESS 선택 시 비활성' — 문서가 확정이면 허위 FAIL. 규칙 면제가 아니라 설계 결정 CSV 로 처리 필요.
- EG372 FAIL 96/106 메뉴: `.env.asis` 가 운영본인지 미확인 · 설계상 다른 그룹 포함 가능.
- 라벨 미대응(EG271·EG275·EG369 ERROR): Color·Cell Qty·Master Chg·Detail·Batch Job·Upload·Excel Form 등 '어느 Div 에도 없음' — 미구현 또는 설계 제외. 대조표 판단 필요.
