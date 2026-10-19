# DMF0082_RLXPRE_CLOUD_20261014 — 조회조건 Project / Owner / Team 완화 선행축소 (클라우드 패치)

- 마커: `[E20261014-DMF0082RLXPRE]` · 대상: `SCM_MGR.PKG_DMF0082` PACKAGE BODY → `P_DMF0082_GET_MAIN_DATA`
- 실행 계정: SCM_MGR · 대상: 클라우드 QA → DEV 순
- 사내 ZIOUI1: 적용 완료(2026-10-14 16:17:21) · 리허설 재적용(16:34:07, 내용 동일) — `_artifacts/_apply_corporate/DMF0082_RLXPRE_20261014/APPLIED_OPERATIONS.md`

## 무엇이 바뀌나
DMF0082 조회에서 **Project / Owner / Team** 중 하나라도 지정하면, 판가·수요를 적재하기 전에 품목 마스터 GTT(`GT_DMF0082_TEMP_SITE_ITEM`)를 미리 줄인다. 선택 조건과 같은 (사업부, Sales Site, 품목) 묶음만 남긴다.
- 기존 Project / Owner / Team 필터 DELETE는 그대로 둔다 → **조회 결과는 같고 적재·삭제량만 줄어든다.**
- 조건을 지정하지 않은 조회는 블록이 실행되지 않는다(변화 없음).
- 원장 · 저장 SP · 메타 · FE · 권한 · GTT 정의 무변경. **BE 재기동 불필요.**

## 왜 (클라우드 QA 실측 G01/G02, 2026-10-14)
| 항목 | 값 |
|---|---|
| 81 Project 지정 시 판가 적재 INSERT | 2.1초 · 18만 행 |
| 그 직후 Project 필터 DELETE | 1.4초 · 21.6만 행 삭제 |
| 45일 조회 — 81 Project 단독 / Project+SalesSite | 중앙값 10초 / 2초 |

## 사내 검증 결과 (30케이스, 반환 커서 6개 전행 해시 비교)
- **29 PASS · 1건(82-ALL)**: 조건 미지정이라 블록이 실행되지 않는 경로다. 측정 사이(16:14~16:17)에 82 원장이 바뀌어 RC1 값이 달랐다(코드 무관).
- 소요(사내 1회 측정): 지정 조회 1.2~3.7배 빨라짐. **버전 MF/SF 지정 조회 424~459초 → 5.6~61초.**
- 리허설: 00 → 90 → 99(원복) → 00 → 10 → 10(SKIP) → 90 전 단계 기대대로. **패치로 다시 만든 BODY == 사내 적용본(md5 일치).**

## 실행 순서 (전부 전체 F5, 값 입력 없음, 치환변수·바인드 없음)
| 순서 | 파일 | 기대 결과 | 다르면 |
|---|---|---|---|
| 1 | `A_DB/00_PRECHECK_CLOUD.sql` | L1 4줄 PASS · L2 마커 0 · L3 컬럼 8개 PASS · L4 0행 | L1·L3 FAIL이면 **10 실행 금지**, 결과 회신. L4에 세션이 있으면 끝난 뒤 실행 |
| 2 | `A_DB/10_APPLY_RLXPRE_PATCH.sql` | `APPLIED — PKG_DMF0082 BODY VALID · 마커 1곳` | `중단 — …`이면 원문 무변경. 메시지 회신. 컴파일 실패 시 원문 자동 복원 |
| 3 | `A_DB/90_VERIFY.sql` | V1 PASS · V2 VALID/오류 0/의존 INVALID 0 · V3 PASS · V4 4줄 PASS | 회신 |
| 4 | (선택) 화면에서 Project 지정 조회 → `90_VERIFY.sql` 재실행 | V5에 "신규 선행축소" 행 생성 · "기존 Project 필터(누적)"의 TOTAL_ROWS가 거의 늘지 않음 | 회신 |
| 원복 | `A_DB/99_ROLLBACK_RLXPRE_PATCH.sql` | `ROLLED BACK — … 마커 0` | **10과 같은 도구로 실행**(블록 안 한글 주석을 같은 방식으로 비교) |

## 패치 방식 (왜 전체본이 아닌가)
- 클라우드 BODY(LAST_DDL 13:46:31)와 사내 BODY는 적용 시점이 달라 **전체본 교체를 금지**한다. `10_APPLY`는 그 DB의 `USER_SOURCE`를 읽어 블록만 삽입한다.
- 앵커는 ASCII 한 줄이다: `    GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME;` (GET_MAIN_DATA 구간 안 1건). 블록은 그 다음 줄(`-- #TempSiteItem 만들기 종료`) 뒤에 들어간다. 한글 줄은 비교하지 않아 문자셋 변환 영향이 없다.
- 가드: 마커 존재 → SKIP / 앵커·기존 필터 DELETE 3종이 구간 안 각 1건이 아님 → 중단 / 조립 길이 불일치 → 중단 / 컴파일 오류 → 원문 자동 복원.

## 이관 축 점검
| 축 | 해당 |
|---|---|
| PKG BODY | ✅ 10_APPLY (패치) |
| PKG SPEC · 시그니처 · PROC_M | 무변경 — 인자 22개 그대로 |
| 메타(MNU/API/BTN/SHEET_COLUMNS/MSG/LBL) | 해당 없음 |
| GTT/TABLE DDL | 해당 없음 — 기존 GTT 2종의 컬럼만 사용(00 L3 실존 확인) |
| GRANT/SYNONYM | 해당 없음 — 객체 신설 없음 |
| FE (`B_FE` / `FE_MERGE`) | 해당 없음 |
| BE | 해당 없음 (재기동 불필요) |

## 파일
- `build_package.py` — 생성기. 사내 BODY 대조 FRESH-GATE 포함, 블록 문구는 사내 적용 스크립트에서 가져온다.
- `run_rehearsal.py` · `_rehearsal_out/` — 사내 리허설 실행기와 결과.
