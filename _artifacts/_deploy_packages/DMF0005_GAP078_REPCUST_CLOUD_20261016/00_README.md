# DMF0005_GAP078_REPCUST_CLOUD_20261016 — 대표 Sold-To/Ship-To 유효 여부 무관 표시 (클라우드 패치)

- 마커: `[GAP078 2026-10-16]` · 대상: `SCM_MGR.PKG_DMF0005` PACKAGE BODY → `P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION`
- 실행 계정: SCM_MGR · 대상: 클라우드 QA → DEV 순
- 사내 ZIOUI1: 적용 완료(2026-10-16 16:08:37) · 리허설 후 최종 재적용(16:11:06, 내용 동일 md5 `59b1fbaa…`) — `_artifacts/_apply_corporate/DMF0005_GAP078_REPCUST_20261016/APPLIED_OPERATIONS.md`

## 무엇이 바뀌나
GAP 78: 일부 행의 Sold-To·Ship-To 가 빈칸. 대표 거래처(`SCM_MST_SITE_CUSTOMER.REP_YN='Y'`)가 무효(`VALID_YN<>'Y'`)인 사이트였다.
- **AS-IS 최신**(운영 추출본 2026-09-17 `modules.sql` · 개발 DB `LGCE_SCMDEV` 라이브 2026-10-16): `DMF0005_GET_SALES_SITE_MODEL_PRODUCTION` 40·82·81 세 분기 모두 `DIVISION_ID · SCM_SITE_ID · REP_YN = 'Y'` 만 조건 — 유효 여부와 관계없이 대표 거래처 표시.
- **TO-BE 수정**: 대표 거래처 조인의 `AND SC.VALID_YN = 'Y'` 1줄을 주석 처리(원문 보존).
- 조회 행 수 · 다른 컬럼 · 원장 · 메타 · FE · 권한 무변경. **BE 재기동 불필요.**

## 사내 검증 결과 (ZIOUI1, minyonglee1 · 전체 조건, 전/후 결과 키 단위 대조)
| 사업부 | 행 수 (전→후) | 바뀐 행 | 바뀐 컬럼 | 소요 (전→후) |
|---|---|---|---|---|
| 40 | 15,569 → 15,569 | 220 (GAP 기재 220과 같음) | SOLDTO_CODE · SOLDTO_DESCRIPTION · SHIPTO_CODE · SHIPTO_DESCRIPTION, 빈칸→값만 | 2.5 → 2.5초 |
| 81 | 42,088 → 42,088 | 82 (원장 90 중 8행은 81 조회 필터로 원래 미표시) | 같음 | 5.5 → 5.6초 |
| 82 | 38,621 → 38,621 | 238 (GAP 기재 289 — 기재 수치는 다른 환경 데이터 기준으로 보임, 미확인) | 같음 | 5.3 → 4.8초 |

- 대표 거래처 2건 이상 사이트 0건 → 조인으로 행이 늘지 않는다(90_VERIFY V5 로 클라우드도 확인).
- 리허설: 99(SKIP 사본) → 90 → 99 → 99(SKIP) → 90(미적용 FAIL 검출) → 00 → 10 → 10(SKIP) → 90, 전 단계 기대대로.
- **99 원복 결과 == 수정 전 원문 (md5 `4987a8c5…`)** · **10 재적용 결과 == 사내 적용본 (md5 `59b1fbaa…`)**.

## 실행 순서 (전부 전체 F5, 값 입력 없음, 치환변수·바인드 없음)
| 순서 | 파일 | 기대 결과 | 다르면 |
|---|---|---|---|
| 1 | `A_DB/00_PRECHECK_CLOUD.sql` | L1 V1 1건 PASS · L2 마커 0 · L3 0행 | L1 FAIL 이면 **10 실행 금지**, 결과 회신. L3 에 세션이 있으면 끝난 뒤 실행 |
| 2 | `A_DB/10_APPLY_GAP078_PATCH.sql` | `APPLIED — PKG_DMF0005 BODY VALID · 마커 1곳` | `중단 — …` 이면 원문 무변경. 메시지 회신. 컴파일 실패 시 원문 자동 복원 |
| 3 | `A_DB/90_VERIFY.sql` | V1 PASS · V2 VALID/오류 0/의존 INVALID 0 · V3 PASS · V4 사업부별 대상 행 수(참고) · V5 PASS | 회신 |
| 4 | 화면 DMF0005 40/81/82 조회 | 행 수 그대로 · 무효 대표 거래처 사이트의 Sold-To/Ship-To 가 채워짐 | 회신 |
| 원복 | `A_DB/99_ROLLBACK_GAP078_PATCH.sql` | `ROLLED BACK — … 마커 0` | 회신 |

## 패치 방식
- 클라우드 BODY 와 사내 BODY 는 세대가 달라(사내 SPEC 44줄 · 클라우드 55줄 관찰) **전체본 교체 금지**. `10_APPLY` 는 그 DB 의 `USER_SOURCE` 를 읽어 대상 2줄 문구(REP_YN·VALID_YN 연속 2줄)만 바꾼다. ASCII · 탭 없음.
- 가드: 마커 존재 → SKIP / 대상 건수 불일치 → 중단 / 조립 마커 수 불일치 → 중단 / 컴파일 오류 → 원문 자동 복원(ORA-24344 대응 감쌈).

## 이관 축 점검
| 축 | 해당 |
|---|---|
| PKG BODY | ✅ 10_APPLY (패치) |
| PKG SPEC · 시그니처 · PROC_M | 무변경 |
| 메타 · GTT/TABLE DDL · GRANT/SYNONYM | 해당 없음 |
| FE · BE | 해당 없음 |

## 파일
- `build_package.py` (단일 원천 = 사내 `apply_corp.py` OPS · FRESH-GATE · 시뮬레이터) · `run_rehearsal.py` · `_rehearsal_out/`(A·B) · `_rehearsal_99_SKIPCOPY.sql` · `_md5_corporate_applied.txt` · `_md5now.py`
