# DMF0021 RTFGATE2 + MSG01001 이관 패키지 (2026-08-18)

> 통합테스트 1st **No.58** (RTF[R+P] Sales Plan Cutoff 게이트) 정밀화 + 차단 메시지 코드 충돌 해소.
> **사내 적용 완료 / 클라우드 미적용.**

## 왜 다시 손댔나 (2026-08-12 RTFGATE 의 한계)

| 축 | 구 RTFGATE(08-12) | 실측 문제 | RTFGATE2(08-18) |
|---|---|---|---|
| 판정 근거 | "이번 주 A1요일 A2시각 **경과**" | 시각은 Cutoff 실행 여부와 무관하게 흐름 → 결함 원문("Cutoff 미완료인데 수정 가능")을 못 막음 | **Cutoff 원장(`DM_MST_VERSION.SP_W`) 실존** |
| 81 | SAT 1600 경과만 인정 | 당주 Cutoff 완료(2026-08-17 월 20:22)인데도 토요일까지 **역차단** | 앵커(직전 토 16:00) 이후 Cutoff 1일자 → **허용** |
| ④ 2차 Cutoff | 익주 진입으로 간접 근사 | 같은 주 2차 Cutoff 를 못 봄 | 앵커 이후 **DISTINCT YYYYMMDD ≥ 2 = 차단** |
| 차단 MSG | `MSG00704` | 클라우드에 **다른 뜻**으로 선점된 코드 — 사내 원장이 2026-08-15 그 문구로 덮임 | **`MSG01001`** 신규 채번 (01001+ 대역 최초) |

## 판정 산식 (GET/SAVE 동일)

```
앵커 = lookup GET_ADMIN_GROUP_MEASURE(DMF0021 · RTF_SYS_RP) 의 ATTRIBUTE1(요일)·ATTRIBUTE2(HHMM)
       그 시점의 직전 도래분 (이번 주 분이 아직 미래면 지난 주 같은 시점)
허용 = 앵커 이후 생성된 SP_W(SALES_PLAN WEEKLY CUTOFF) 가 정확히 1 일자
       0 일자 = Cutoff 미완료 → 차단 (요구 ①)
       2 일자 이상 = 2차 Cutoff 완료 → 차단 (요구 ④)
회차 = VERSION_NO 가 아니라 DISTINCT YYYYMMDD
       (한 배치가 같은 날 V001~V003 을 남기는 사례 실재 — 81_HD 2026-08-12 15:06 3건)
```

- ③ "SCP Final 수행 완료 시점"은 요구문 그대로 **lookup 이 지배**한다 (40=MON1600 / 81=SAT1600).
  `DM_MST_VERSION` 8종(SP_W/SP_D/SF_W/MF_W/MF_D/CF_W/EC_D/BP_M) 중 *SCP Final* 에 대응하는 축은
  없다 — `SF_W` 는 *SCM FCST Weekly Cutoff* 로 등치 근거가 없어 **추정 배선하지 않았다.**
- SAVE 게이트는 GT 전행이 아니라 `DISTINCT (division, user)` 집합에 대해 1회 평가한다
  (행별 앵커 재계산 = 행별 스칼라 연산 성능 함정 회피).

## 파일

| 파일 | 내용 |
|---|---|
| `A_DB/01_PKG_DMF0021_BODY.sql` | PKG BODY 전문 (기준선 = 2026-08-18 사내 배포본 실측 덤프 + 치환 2건) |
| `A_DB/02_MSG01001.sql` | `MSG01001` 3언어 MERGE (CREATED_BY='admin') |
| `A_DB/90_VERIFY.sql` | 배포 검증 6항목 (대상 객체 실측) |
| `B_FE/locales/{KO,EN,CN}.json` | `MSG01001` 추가 + `MSG00704` 를 **원장 문구와 일치**시킴 |

## 적용 순서

1. `A_DB/02_MSG01001.sql` (메시지 먼저 — 차단 시 코드만 뜨는 창 제거)
2. `A_DB/01_PKG_DMF0021_BODY.sql` (라이브 재배포 시 `ALTER SESSION SET DDL_LOCK_TIMEOUT=120`)
3. `A_DB/90_VERIFY.sql` — 6항목 기대치 일치 확인
4. `B_FE/locales/*.json` 3본

## ⚠ 필수 — GET 측 별칭 `L` (RTFGATE2-FIX)

`DM_MST_VERSION` 도 `ATTRIBUTE1~10` 을 가진다. GET 게이트의 스칼라 서브쿼리(`FROM DM_MST_VERSION V`)
안에서 **무한정 `ATTRIBUTE1/2` 는 lookup 이 아니라 버전 테이블 컬럼으로 잡힌다**(내부 스코프 우선).
값이 NULL 이라 `DECODE`→NULL → 앵커 NULL → `V.CREATION_DATE > NULL` = UNKNOWN → 카운트 0 →
**RTF 편집 권한이 전 division 상시 0** 이 된다(2026-08-18 최초 배포분 실사고 — 81/40 편집 불가 신고).
⇒ lookup 에 별칭 `L` 을 주고 서브쿼리 안 참조를 `L.ATTRIBUTE1/2` 로 한정해야 한다.
SAVE 측은 처음부터 `B.` 로 한정돼 있어 무영향.

**검증은 산식 재작성이 아니라 `ALL_SOURCE` 의 배포 원문을 그대로 실행**해야 이 계열 결함이 잡힌다
(`_artifacts/_diagnostics/_rtfgate2_verify_deployed_sql_20260818.py`).

## 사내 적용 실측 (2026-08-18)

- `PKG_DMF0021` BODY **VALID** (LAST_DDL 2026-08-18 09:52:21 = FIX 반영본), `ALL_ERRORS` **0행**
- 마커 `[RTFGATE2-FIX]` L286 / `[RTFGATE2]` GET L299 · SAVE L2760, `V_S_CODE := 'MSG01001'` L2803, 비주석 `MSG00704` **0건**
- `MSG01001` 3언어 등재 (KO/EN/CN, CREATED_BY='admin')
- **배포 원문 실행 검증**: GET `AUTH_CNT`=1 → 40·81·81_UC·81_HD·81_HG·81_HM·81_ST **전부 편집가능** /
  SAVE 게이트 = 81 **통과**, 82(RTF lookup 미등재) **차단(MSG01001)**
- 모델 검증(산식 재작성): 앵커 이후 0건 → BLOCK 7/7 / 1일자 → ALLOW 7/7 / 2일자 → BLOCK(40·81_HD)
- FE: `vitest` sales-plan **33 PASS**(4파일) / `tsc --noEmit` **exit 0**

## ⭐ 클라우드 반영 절차 (QA · DEV **2개 DB 각각**)

### 0단계 — 선행 확인 (필수, 조회만)

`00_CLOUD_PRECHECK.sql` 실행 후 아래를 판단한다. **여기서 갈리면 적용 순서가 달라진다.**

| 확인 | 기대 | 어긋나면 |
|---|---|---|
| C1 lookup `GET_ADMIN_GROUP_MEASURE`(DMF0021·RTF_SYS_RP) 행 + `ATTRIBUTE1/2` | division 별 행 존재·요일/시각 값 有 | `ATTRIBUTE1` NULL = 게이트 **무력화(상시 허용)** / 행 부재 = 그 division **편집 불가**. 사내값(40·81_xx=MON1600 / 81=SAT1600)을 참고해 운영 합의 후 등재 |
| C2 `DM_MST_VERSION` SP_W 적재 | division 별 주 1회 이상 | **0행이면 RTF 편집 전면 차단**된다(원장 기준 판정이므로). Cutoff 배치 적재부터 해결 — 이번 이관 최대 리스크 |
| C3 판정 시뮬 `CUTOFF_DAYS` | 1 | 0=미완료 차단 / 2 이상=2차 Cutoff 차단. 적용 후 화면 상태를 미리 알 수 있다 |
| C4 `MSG00704` | 클라우드 기존 문구 그대로 | **절대 UPDATE 금지** (다른 화면이 쓰는 코드). 이번 이관은 `MSG01001` INSERT 만 |
| C5 `MSG01001` | 0행 | 이미 있으면 채번 충돌 → 다음 번호로 재채번 + `01_PKG` 의 `V_S_CODE` 도 같이 변경 |
| C6 현재 BODY 마커 | — | `[RTFGATE 2026-08-12]`·PERFHINT·COLDEDUP 이 0이면 클라우드는 **08-12 TESTFIX 미적용 기준선**이다. 본문 전체 교체이므로 그 변경들도 함께 반영된다(의도된 것이나 회귀 확인 범위는 그만큼 넓어짐) |
| C7 참조 객체 | 3개 모두 존재 | 부재 시 컴파일/실행 실패 |

### 1단계 — DB (SCM_MGR)

1. `A_DB/02_MSG01001.sql` — **INSERT 만** (MSG00704 미접촉). 메시지를 먼저 넣어야 차단 시 코드만 뜨는 창이 없다
2. `A_DB/01_PKG_DMF0021_BODY.sql` — BODY 전체 교체. 라이브면 `ALTER SESSION SET DDL_LOCK_TIMEOUT=120`
3. `A_DB/90_VERIFY.sql` — 6항목 기대치 확인 (VALID / 오류 0 / RTFGATE2 2행 / MSG01001 3언어 / 비주석 MSG00704 0 / 판정 현황)

### 2단계 — FE

| 대상 | 이유 |
|---|---|
| `B_FE/locales/{KO,EN,CN}.json` 의 **`MSG01001` 키** | 차단 팝업 실문구. 없으면 "(MSG01001)" 코드만 노출. ⚠ **키 단위 추가** — 파일 통짜 덮어쓰기는 클라우드 전용 키를 지울 수 있다. `MSG00704` 키는 클라우드 원장 문구에 맞출 것 |
| `B_FE/sales-plan/` **폴더 전체**(`index.ts` 포함) | `sales-plan.api.ts` 의 MSG 토큰 전수 탐색이 없으면 팝업에 `ERR_RTN: - Validation Check^MSG01001^` 원문이 그대로 뜬다. 폴더 부분 이관은 `resolveView()` 실패("Page Not Found") 사고 계보라 **폴더 단위** 고정 |
| `B_FE/gridAction.ts` | 08-12 TESTFIX 미적용 상태라면 Excel Download 콤보명 표시(No.60-①)까지 같이 반영 |

### 3단계 — 적용 후 검증

- `_artifacts/_diagnostics/_rtfgate2_verify_deployed_sql_20260818.py` 를 클라우드 접속으로 실행
  (**배포 원문 실행** 검증 — 산식 재작성 검증은 컬럼명 캡처 결함을 통과시킨다)
- 확인 축 2개: ① 정상 사용자·division 이 **통과(AUTH_CNT=1)** ② 미등재 division(82)이 **차단**
- 화면: 재배포 직후 세션당 1회 `ORA-04068` 가능 → 재조회하면 정상

## 원복

`_artifacts/_apply_corporate/BACKUP_PKG_DMF0021_BODY_pre_rtfgate2_20260818.sql` (배포 직전 실측 덤프, `CREATE OR REPLACE` 형태 그대로 실행 가능)
