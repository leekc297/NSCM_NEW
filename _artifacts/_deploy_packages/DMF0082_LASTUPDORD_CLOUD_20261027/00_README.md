# DMF0082 조회 — LAST UPDATED BY / LAST UPDATE DATE 를 정렬 키(ORDER BY)에서 제외 (클라우드 이관 · 패치형)

> 마커 `[E20261027-DMF0082LASTUPDORD]` — PKG_DMF0082 BODY 조회 프로시저 2종에 1문장씩 삽입. 기존 문장·데이터·메타 변경 없음.

| 항목 | 값 |
|---|---|
| 요청 (2026-10-27) | 두 컬럼을 GROUP BY 에서 뺀 [E20261027-DMF0082LASTUPD] 에 이어 ORDER BY 에서도 제외 |
| 보완 | C_TITLE 루프 직후 `V_ORDERBY` 에서 `, LAST_UPDATED_BY` · `, LAST_UPDATE_DATE` 토큰만 제거. 두 컬럼을 고르지 않으면 정렬 키는 원래 값 그대로 |
| 사내 적용 | **완료** ZIOUI1 2026-10-27 15:45:34 → 리허설 재적용 16:31:47 · 40케이스 전후 비교 PASS (BASE 줄 순서·값 완전 동일 · 두 컬럼 선택 시 키 순서 = BASE) |
| 클라우드 | **미적용** |
| BE 재기동 · FE | 불요 (셀 병합 제외는 FE 화면 소스에서 별도 반영 — ForecastPriceGrid.tsx / ForecastPriceGridUtils.ts / forecast-price.constants.ts) |

## 실행 순서 (SCM_MGR · 각 파일 전체 F5 · 값 입력 없음)
| # | 파일 | 기대 |
|---|---|---|
| 1 | A_DB/00_PRECHECK_CLOUD.sql | L1 앵커 `2 PASS` · L2 마커 0 · L3 선행 LASTUPD `2` · L4 선택 사용자 수 · L5 실행 중 세션 없음 |
| 2 | A_DB/10_APPLY_LASTUPDORD_PATCH.sql | `APPLIED — PKG_DMF0082 BODY VALID · 마커 2곳` (이미 적용이면 `SKIP`, 앵커 ≠2 면 ORA-20001 로 중단·원문 무변경) |
| 3 | A_DB/90_VERIFY.sql | V1 PASS(2) · V2 VALID/오류 0 · V3 삽입 줄 2 |

원복: A_DB/99_ROLLBACK_LASTUPDORD_PATCH.sql

## 주의
- 패치형 — 클라우드 원문을 읽어 `END LOOP; CLOSE C_TITLE;` 2곳 뒤에만 끼워 넣는다(앵커 ASCII). 다른 패치(LASTUPD · CELLPRODDASH 등)와 구간이 달라 순서 무관.
- 실제 효과: 두 컬럼은 정렬 키 맨 뒤(순번 560·800)에 붙고 LASTUPD 로 키당 1쌍이라, 사내 실측에서는 적용 전에도 순서가 같았다. 이 패치는 그 조건이 깨져도 정렬이 바뀌지 않게 하는 방어.
- 10 은 패키지 BODY 재생성 — DMF0082 조회·저장 실행 중이면 대기 (00 L5 확인).

## 리허설 (사내 ZIOUI1 2026-10-27 16:31, `_rehearsal_out/`)
99(`ROLLED BACK` 마커 0) → 00(L1 2 PASS · L2 0 · L3 2) → 90(V1 미적용) → 10(`APPLIED` 2곳) → 10(`SKIP`) → 90(PASS · VALID) → 99(`ROLLED BACK`) → 99(`SKIP`) → 10(`APPLIED`) → 90(PASS). 최종 DB 원문 == 사내 적용본 True.
