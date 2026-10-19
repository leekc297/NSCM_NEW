# DMF0072_GAP418_ENDCUSTKEY_CLOUD_20261015 — 저장 매칭 키에서 End Customer 제외 (클라우드 패치, DB 만)

- 마커: `[GAP418 2026-10-15]` 2곳
- 대상: `SCM_MGR.PKG_DMF0072` PACKAGE BODY → `P_DMF0072_SAVE_NNMASTER_MAPPING` 의 END_CUSTOMER 조건 2줄
- 실행 계정: SCM_MGR / 적용 순서: 클라우드 QA → DEV
- ⚠ **선행 필수: `DMF0072_GAP412_INSDUP_CLOUD_20261015`.** 10 은 GAP412 마커가 없으면 원문을 바꾸지 않고 중단한다.
- **FE·BE 무변경 · BE 재기동 불필요.** 원장 · 메타 · 권한 무변경.

## 무엇이 바뀌나
| 구분 | 저장 시 기존 행을 찾는 키 |
|---|---|
| AS-IS `DMF0072_SAVE_NNMASTER_MAPPING` (LGCE_SCMDEV 2025-01-21) | MERGE 1문장. ON = PK 와 같은 15개 축(Mapping Item 은 수정 전 값)이고, `--AND A.END_CUSTOMER = B.END_CUSTOMER` 는 주석이다 |
| TO-BE 현재 | 행별 존재 확인 + UPDATE. 존재 확인과 UPDATE 조건 모두 **END_CUSTOMER 포함** |
| 패치 후 | 두 조건에서 END_CUSTOMER 를 뺀다. 매칭 키 = AS-IS 와 같다 |

- 결과가 달라지는 경우: SCM 기존 행은 End Customer 를 편집할 수 있다 (AS-IS `.cs` L1443 · TO-BE `beginningEdit` 동일).
  - End Customer 만 바꾸고 나머지 키는 그대로인 수정 행을 저장할 때 차이가 난다.
  - AS-IS: 같은 원장 행을 UPDATE 한다(End Customer 값 자체는 바뀌지 않음).
  - TO-BE 현재: 매칭에 실패해 INSERT 하고 **ORA-00001 로 저장 실패**한다.
  - 패치 후: AS-IS 와 같다.
- 행별 루프 구조는 유지한다. MERGE 로는 ON 컬럼인 MAPPING_ITEM_ID 를 갱신할 수 없다(ORA-38104, 원문 주석 사유). 그래서 저장 방식은 달라도 결과는 같다.
- **GAP412 를 선행해야 하는 이유**: 412 없이 418 만 넣으면, End Customer 만 다른 같은 PK 의 신규 행이 ORA-00001 대신 **기존 행 덮어쓰기**로 바뀐다. 412 의 신규 행 중복 오류가 이 경우를 막는다.

## 검증 상태 (2026-10-15 21:19, 사내 ZIOUI1 59.19.252.148)
- ⚠ **사내 ZIOUI1 은 GAP412·418 모두 미적용이다.** 적용 실행이 권한 분류기에 막혀 있다. 사내 컴파일과 화면 저장 실측은 **미검증**이다.
- 확인한 것 (모두 DB 무변경):
  - 생성 직전 사내 원문을 다시 읽어 착수 조회본과 같음을 확인했다 (FRESH-GATE, LAST_DDL 2026-10-15 11:17:46).
  - 패치 문구 기준본은 GAP412 적용본이다 (사내 412 적용기의 적용본 파일).
  - **DRY-RUN**: 10/99 PL/SQL 블록을 사내에서 실행했다. 소스는 바인드로 넣고, 컴파일 대신 결과를 반환하게 했다. 결과:
    - 412 적용본 → 10 적용 == 418 적용본 전문
    - 10 재실행 = SKIP
    - 412 미적용 원문 → 10 = ORA-20003 중단
    - 99 원복 == 412 적용본 전문
    - 99 재실행 = SKIP
  - 00_PRECHECK 사내 실행: L1 2줄 PASS · L2 FAIL. 사내 412 미적용 상태이므로 FAIL 이 맞다.
  - 90_VERIFY 사내 실행: 문법 정상. 적용 전이라 V3 가 대상 2줄을 잡는 것이 맞다.
  - 결과 기록 위치: `_rehearsal_out/`
- 사내 적용기: `_artifacts/_apply_corporate/DMF0072_GAP418_20261015/apply_gap418.py apply`. GAP412 적용 후에만 진행된다.

## 실행 순서 (전부 전체 F5, 값 입력 없음, 치환변수·바인드 없음)
| 순서 | 파일 | 기대 결과 | 다르면 |
|---|---|---|---|
| 0 | `DMF0072_GAP412_INSDUP_CLOUD_20261015` 전체 | 그 패키지 README 대로 | — |
| 1 | `A_DB/00_PRECHECK_CLOUD.sql` | L1 2줄 PASS · L2 PASS · L3 마커 0 · L4 0행 | L1 FAIL → **10 실행 금지**, 결과 회신 / L2 FAIL → 412 먼저 |
| 2 | `A_DB/10_APPLY_GAP418_PATCH.sql` | `APPLIED — PKG_DMF0072 BODY VALID · 마커 2곳` | `중단 — …` 이면 원문은 바뀌지 않음. 컴파일 실패 시 원문 자동 복원 |
| 3 | `A_DB/90_VERIFY.sql` | V1 2 PASS · V2 VALID/오류 0/의존 INVALID 0 · V3 0 PASS | 회신 |
| 4 | 화면 DMF0072 | SCM 기존 행의 Valid From/To·Active 수정 저장 정상 / 기존 행과 같은 키 신규 행 → 오류(412) | 회신 |
| 원복 | `A_DB/99_ROLLBACK_GAP418_PATCH.sql` | `ROLLED BACK — … 마커 0`. GAP412 는 그대로 남음 | 회신 |

## 파일
- `build_package.py` — 생성기 (FRESH-GATE · 시뮬레이터 · DRY-RUN, 문구는 사내 적용기와 단일 소스).
- `run_rehearsal.py` · `_rehearsal_out/` — 사내 조회 전용 실행 결과 (00·90).
- `_md5_corporate.txt` — 사내 현재본 · 412 적용본 · 418 적용본 md5.
