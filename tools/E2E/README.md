# E2E — NSCM To-Be 화면 자동 테스트 (Playwright)

Fact Pack 으로 고정한 화면 플랜(`Doc\gen\<ID>\e2e_plan.json`) 과 Oracle 메타·테스트계정에서 **스펙을 생성**한다. 사람이 스펙을 쓰지 않는다.

| 종류 | 태그 | 내용 |
|---|---|---|
| 스모크 | `@smoke` | 화면 열림(404/권한 안내 아님) → 조회조건 라벨 → Division 선택 → 조회(call-proc HTTP<400, 오류 알림 없음) → 그리드 컬럼 대사(메타 `sheet_columns.csv` 우선, 없으면 As-is 라벨, 누락 ≤20%) → **동적 기간 컬럼**(As-is 기간형 타이틀 SP·DB루프가 있으면 `gridBindings` 로 Wijmo 컬럼 정의를 읽어 정적 메타 밖 binding ≥1 + 사내 배선 타이틀 시트 call-proc 호출 확인, 어노테이션 `dynamic` — 2026-10-20 SCP0096 '헤더 6/기대 6 PASS' 구멍) |
| CRUD | `@crud` | 저장 SP 가 있는 화면: Insert(F8) → 마커 입력 → Save(F7) → 재조회(존재) → 수정 → Save → 재조회 → Delete(F9) → Save → 재조회(부재). Insert 없는 화면은 셀 편집 저장 후 원복. 조회 전용 화면은 Save 비노출 확인 |
| 권한 | `@auth` | 통합테스트 데이터셋의 **테스트계정 12 × Division(40/81/82)**: 접근 가능 여부, 노출 버튼(btn_auth 메타 있으면 그룹별 기대 버튼 대사), Division 별 조회 성공·DIVISION 컬럼 값 범위 |

## 로그인(비밀번호 없음)
FE 와 동일하게 `POST {beUrl}/user/login {userId}`(JsonLoginFilter · 비밀번호 없음) 로 세션을 만든다 — 2026-10-20 변경. `GET /sso/dev-login` 은 BE `SsoDevController` 에 `@AuthCheck(NONE)` 이 없어 401 이라 fallback 으로만 쓴다. 계정은 `accounts.json`(04_TESTDATA_SET.xlsx 의 테스트계정_권한해석) — 비밀번호 저장/입력 없음. qa/prd 에는 이 엔드포인트가 없다.

## 실행(노트북)
```
run-e2e.cmd smoke                 # Doc\gen 전체 화면 스모크
run-e2e.cmd all DMF0003 DMF0052   # 지정 화면 전부(스모크+CRUD+권한)
```
선행: `pnpm --filter @web local`(FE 3000) + BE(local 프로파일, Oracle 연결) 기동. 결과 `Doc\e2e\results\_summary.md / _summary.csv / html\index.html`.
처음 한 번 `npm install` + `npx playwright install chromium` (run-e2e.cmd 가 자동).

## 파일
`gen-e2e.js`(스펙 생성) · `gen-accounts.py`(계정/권한매트릭스/시나리오 추출) · `lib/nscm.ts`(화면 헬퍼: 로그인=POST /api/user/login · 공지 팝업 닫기 dismissNotices · 딥링크 탭 활성화 activateScreenTab · 보이는 요소 우선 visibleFirst, /view/MENU, SearchArea·SubTitle 버튼·Wijmo 그리드·call-proc 수집) · `fixtures/test.ts`(account/division 옵션) · `report.js`(results.json → 요약) · `playwright.config.ts` · `e2e.config.json`(URL/경로)

## 보완 포인트(플랜 데이터로 고친다 — 스펙 손수정 금지)
- CRUD 키 컬럼: `Doc\e2e\specs\<ID>.plan.json` 의 `keyColumns` 에 필수 입력 컬럼 헤더를 넣으면 마커를 그 컬럼에 입력한다
- 라벨 미확정(F12 WARN) 화면은 조회조건 라벨 검사가 soft 실패로 남는다 → `lbl_codes.csv`/msg_master 보강이 근본 조치
- 메타 CSV(`export_tobe_meta.py`) 를 내려받으면 컬럼·버튼 권한 대사가 메타 기준으로 바뀐다
