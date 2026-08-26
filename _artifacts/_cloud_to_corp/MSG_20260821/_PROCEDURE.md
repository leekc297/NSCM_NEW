# MSG/LBL 클라우드→사내 이관 시 **명칭 충돌 적출 + 로컬 소스 보완** 절차

> 수시 반복 실행용 절차서. 클라우드 MSG 원장을 사내로 옮기기 **전에** 명칭 충돌을 적출하고,
> 그 코드를 쓰는 UI/소스를 역추적해 로컬 소스의 명칭 오류분을 보완한다.
> 최초 작성 2026-08-21 · 대상 `SCM_MGR.SCM_ADM_MSG_M`

---

## 0. 이 절차가 푸는 문제

MERGE 는 `ON (MSG_ID, LANG_CD)` 로 사내 값을 **덮어쓴다**. 그래서 같은 코드가 사내에 다른 명칭으로
등록돼 있으면, 아무 경고 없이 사내 명칭이 사라지고 화면 문구가 바뀐다. 게다가 로컬 소스에는
그 명칭이 **locales JSON** 과 **하드코딩 문자열** 양쪽에 남아 있어 DB 만 바꾸면 어긋난다.

따라서 순서가 중요하다 — **적출 → 판정 → (선별)적용 → 소스 동기화**. 적용부터 하면 되돌릴 근거가 없다.

### 명칭이 사는 곳 (실측 2026-08-21)

```
 [사내 DB] SCM_ADM_MSG_M (USE_YN='Y')      2,634행 / 917코드 / 3언어(KO 917·EN 861·CN 856)
      │
      ├─ BE  /admin/message  (Message.xml — USE_YN='Y' 필터)
      │        │
      │        └─ nscm-fe/scripts/sync-i18n.mjs  →  nscm-fe/public/locales/{KO,EN,CN}.json
      │                                              (KO 914 · EN 858 · CN 852 키)
      │                                                   │
      │                                                   └─ 화면  t('LBL00112')
      │
      ├─ SCM_ADM_MNU_M.MNU_MSG_ID                 107행 / 99코드  ← **메뉴명은 이 축이 유일**
      ├─ SCM_ADM_API_M.API_MSG_ID                 385행 / 300코드
      └─ SCM_ADM_LOOKUP_MASTER_DETAIL.SEGMENT2     20행 / 10코드

 [로컬 소스] 코드 리터럴 2,232곳 / 301파일 (nscm-fe/features 기준)
             + 하드코딩 명칭 문자열 (예: colLblNm: 'Plant Site')  ← locales 를 우회한 오염원
```

> ⚠ 코드 체계는 **5자리 고정이 아니다**. 실측 프리픽스 11종 —
> `LBL`(386) `MNU`(212) `MSG`(190) `MSG_API_SDM`(42) `MSG_API_DMF`(64) `MSG_API_SCP`(9)
> `MNU_DMF`(6) `MNU_SDM`(4) `MNU_SYS`(2) `MNU_SDM_Project`(1) `MNU_SDM_Admin`(1).
> `(LBL|MSG)[0-9]{5}` 로 스캔하면 678행(26%)이 조용히 누락된다.

---

## 1. 절차 (P0 ~ P5)

### P0. 사전 점검 — 로컬 소스가 사내와 이미 어긋나 있는지부터 본다

클라우드 스냅샷 없이 **사내 DB(권위) vs 로컬 locales** 2축만 돌린다. 이관과 무관하게 상시 유효하다.

```bash
cd _artifacts/_cloud_to_corp/MSG_20260821
python msg_sync.py run --corp-only -o out_corponly
```

`0_요약` 시트의 `LOCALE_상이` 가 0이 아니면, **이관 전에 먼저 정리**한다.
어긋난 상태에서 이관하면 원인이 이관 탓인지 기존 탓인지 못 가린다.

> **2026-08-21 실측**: `LOCALE_상이 = 0` / `LOCALE_없음 = 10` / `일치 = 2,624`.
> 누락 10건을 실제로 열어본 내역 (산술 추정이 아니라 행 전수 확인):
>
> | 코드 | 언어 | USE_YN | 판정 |
> |---|---|---|---|
> | `LBL00350` / `MNU00025` | KO·EN·CN 각 3 | **N** | 정상 — BE 가 `USE_YN='Y'` 만 내려주므로 locales 에 없는 게 맞다 (6건) |
> | `MSG01014` | KO·EN·CN | Y | ⭐ **실결함** — 사내 DB 에는 있는데 locales 3본 모두 없음 (3건) |
> | `LBL00097` | CN | Y | ⭐ 사내 `MSG_NM` 이 **NULL** — CN 라벨 자체가 미정의 (1건) |
>
> `MSG01014` 는 **DMF0082 에서 실제 사용 중**이다 —
> `ForecastPrice.tsx:360` / `:959` / `components/modals/ForecastTemplateModal.tsx:25`.
> locales 에 키가 없으므로 현재 이 3곳은 fallback 으로 표시된다. P0 를 돌리자마자 나온 건이며,
> **이관과 무관하게 지금 보완 대상**이다 (P5-1 `sync-i18n.mjs` 재생성으로 해소).
> `LBL00097/CN` 은 `LOOKUP.SEGMENT2 = LOG_TP_CD/LOGIN` 축에도 걸려 있어 DB 원장 쪽 입력이 필요하다.

### P1. 양측 스냅샷 확보

| 측 | 방법 |
|---|---|
| **클라우드** | `10_EXPORT_MSG_SNAPSHOT.sql` 을 클라우드 DB 에서 실행 → 결과(LINE 컬럼) 전량 복사 → `snap_cloud.txt` 저장 |
| **사내** | 자동 — `python msg_sync.py export-corp -o snap_corp.txt` (ora.py 접속정보 재사용) |

두 파일은 **같은 이스케이프 규약**(`\\` `\r` `\n` `\t` `\N`)을 쓰므로 개행·따옴표를 품은 명칭도 1행 1레코드로 안전하다.
감사컬럼(CREATED_BY / *_DATE)은 **의도적으로 제외**한다 — 적재 시각은 항상 달라 전 행이 차이로 잡히기 때문이다.

### P2. 차이 분류 + 사용처 역추적 + 판정표 생성 (일괄)

```bash
python msg_sync.py run --cloud snap_cloud.txt -o out_20260821
```

내부적으로 `export-corp → diff → usage → report` 4단계를 돈다. 개별 재실행도 가능하다.

### P3. 판정 — `MSG_DIFF_REPORT.xlsx` 를 사람이 읽고 결정

| 분류 | 의미 | MERGE 영향 | 판단해야 할 것 |
|---|---|---|---|
| **NAME_DIFF** ⭐ | 같은 코드, 다른 명칭 | **UPDATE — 사내 명칭 소실** | 클라우드/사내 중 어느 쪽이 정본인가 |
| **CODE_SPLIT** ⭐ | 같은 명칭이 서로 다른 코드로 양측 등재 | (직접 영향 없음) | 재채번 사고인가 — 한쪽 코드 폐기 필요한가 |
| CLOUD_ONLY | 사내에 없는 신규 코드 | INSERT | 그대로 유입해도 되는가 |
| CORP_ONLY | 사내 단독 보유 | 없음 (MERGE 미대상) | 남길 것인가 정리할 것인가 |
| ATTR_DIFF | 명칭 동일, DESC/TP/USE_YN 만 상이 | UPDATE | 대개 무해 |
| SAME | 동일 | 없음 | — |

**도구는 권위를 판정하지 않는다.** 어느 쪽이 정본인지는 화면 요건이 정하는 것이므로,
`1_명칭충돌` 시트의 `사용화면ID` / `사용처(상위5)` 를 근거로 사용자가 `조치` 열에 적는다.

각 행에 붙는 역추적 결과:
- `사용화면ID` — `features/*/src/pages/<폴더>/*.constants.ts` 의 `MENU_ID` 실측 매핑 (폴더 51개 인식)
- `사용처(상위5)` — 소스 `파일:라인` + 사내 DB 메타 축(`MNU_M.MNU_MSG_ID` / `API_M.API_MSG_ID` / `LOOKUP.SEGMENT2`)
- `LOCALE_VAL` / `LOCALE_상태` — 로컬 locales 의 현재 값과 일치 여부
- `7_사용처인덱스` 시트 — 코드→사용처 전량 (상위5 로 잘리지 않은 원본)

> `MNU_M.MNU_MSG_ID` 축은 특히 주의. `SCM_ADM_MNU_M` 에는 메뉴명 컬럼이 **없고**
> 메뉴 표시명이 전적으로 이 MSG 코드에서 나온다. 이 축에 걸린 NAME_DIFF 는 곧 메뉴 라벨 변경이다.

### P4. 선별 적용 — 사내 정본으로 남길 코드는 MERGE 에서 제외

P3 판정 후 `exclude_candidates.txt`(= NAME_DIFF 코드 전량)에서 **사내를 정본으로 유지할 코드만 남기고**
나머지를 지운 뒤, `01_GEN_MSG_MERGE.sql` 상단 `P_EXCLUDE_MSG_IDS` 에 한 줄로 붙여넣는다.

```sql
, CAST('LBL00005,LBL00067,MSG00097' AS VARCHAR2(4000)) AS P_EXCLUDE_MSG_IDS
```

그 상태로 클라우드에서 생성기를 실행 → 생성된 MERGE 스크립트를 사내에서 실행 → `90_VERIFY_CORP.sql` 대조.
(생성물 헤더에 `EXCLUDE ...` 가 찍히므로, 나중에 무엇을 제외하고 적용했는지 스크립트만 봐도 남는다.)

### P5. 로컬 소스 보완 — 여기까지 해야 끝난다

1. **locales 재생성** — BE 기동 상태에서
   ```bash
   cd nscm-fe && node scripts/sync-i18n.mjs        # = pnpm gen:i18n 의 실체
   ```
   API 3후보(`NSCM_I18N_API` → `127.0.0.1:8080` → 구주소)가 전부 실패하면 **기존 locales 를 보존한 채 중단**한다
   (2026-08-13 목데이터 덮어쓰기 사고 후 삽입된 가드 — 소스에서 확인함).
   실행 후 `git diff nscm-fe/public/locales` 로 변경 키를 눈으로 확인한다.
2. **하드코딩 명칭 정리** — `1_명칭충돌` / `7_사용처인덱스` 의 `구분=하드코딩텍스트` 행.
   `colLblNm: 'Plant Site'` 처럼 locales 를 우회해 박힌 문자열은 gen:i18n 으로 고쳐지지 않는다. 수동 수정 대상이다.
3. **테스트 동반 수정** — 옛 명칭을 단언하는 `*.test.ts` 도 같이 깨진다. 스캔에 **의도적으로 포함**돼 있다.
4. **재검증** — `python msg_sync.py run --corp-only -o out_after` 로 `LOCALE_상이 = 0` 복귀 확인.

---

## 2. 산출물

| 파일 | 내용 |
|---|---|
| `snap_corp.txt` / `snap_cloud.txt` | 양측 스냅샷 (이스케이프 TSV) |
| `diff.tsv` | 키별 분류 전량 (15컬럼) |
| `code_split.tsv` | 같은 명칭·다른 코드 후보 |
| `usage.tsv` | 코드→사용처 전량 (소스 / locales / DB메타 / 하드코딩) |
| `exclude_candidates.txt` | P4 에 붙여넣을 NAME_DIFF 코드 목록 (선별 전 후보) |
| **`MSG_DIFF_REPORT.xlsx`** | 8시트 판정표 — 0_요약 / 1_명칭충돌 / 2_코드분리 / 3_클라우드신규 / 4_사내단독 / 5_속성차이 / 6_locales격차 / 7_사용처인덱스 |

---

## 3. 검증 실적 (2026-08-21)

클라우드 접속 권한이 없어, 사내 스냅샷을 의도적으로 변형한 **합성 픽스처**(`_selftest_make_fixture.py`)로
클라우드측 분기를 전수 발동시켜 확인했다. 픽스처 산출물은 실 데이터가 아니다.

| 검증 | 기대 | 실측 |
|---|---|---|
| `--corp-only` 실동작 | — | 2,634행 분류 / locales 일치 2,624·없음 10 |
| NAME_DIFF 발동 | 주입 4 | **4** |
| ATTR_DIFF 발동 | 주입 2 | **2** |
| CORP_ONLY 발동 | 주입 2 | **2** |
| CLOUD_ONLY 발동 | 주입 3 + 분리코드 1 | **4** |
| CODE_SPLIT 발동 | 1 | **검출**(LBL09902 ↔ LBL00069 'Date') |
| LOCALE_상이 연동 | NAME_DIFF 와 동수 | **4** |
| 하드코딩텍스트 축 | LBL00005 'Plant Site' | **25건** — SCP0013·DMF0048·DMF0020·DMF0003·DMF0042 에서 `colLblNm: 'Plant Site'` 적출 |
| 화면ID 귀속률 | — | 소스 사용처 110건 중 **103건 귀속**(미검출 7) |
| 제외 필터 | 3코드 × 3언어 = 9행 감소 | 2,634 → **2,625** |
| 제외 부분일치 오탐 | `'LBL0000'` 는 LBL00005 를 먹지 않아야 | **2,634 (0건 제외)** — 오탐 없음 |

### 하드코딩 판정을 좁힌 근거 (실측)

사내 KO 명칭 762개를 소스에 단순 부분일치시키면 **338개**가 걸린다. 그러나 `Column` `Filter` `Request`
같은 명칭이 **식별자**에 걸린 것이어서 대부분 거짓이었다. 따옴표 리터럴 안에 실제로 들어있는 것만
세면 **163개**. 도구는 후자만 인정한다(`'name'` / `"name"` / `` `name` ``, 길이 4 이상).

---

## 4. 한계 (반드시 인지)

1. **권위 판정은 자동화하지 않는다.** 어느 쪽 명칭이 옳은지는 화면 요건이 정한다. 도구는 후보와 근거만 제시한다.
2. **CORP_ONLY 는 MERGE 가 건드리지 않는다.** 사내 단독 행의 삭제는 이 절차 밖이며, 사용자 판단 사항이다.
3. **화면ID 미검출**이 남는다(픽스처 기준 110건 중 7건). 공용 컴포넌트·`packages/` 하위처럼 `pages/` 밖에서
   쓰이는 코드는 화면에 귀속되지 않는다. `사용파일` 경로로 직접 판단해야 한다.
4. **하드코딩 축은 후보 목록이다.** 따옴표 한정으로 노이즈를 줄였지만 `'Language'` 같은 일반 단어는 여전히 섞인다.
5. **`gen:i18n` 은 이 세션에서 실행하지 않았다.** 소스의 안전 가드(전 API 실패 시 기존 locales 보존)는 읽어 확인했으나,
   실행 검증은 하지 않았다. P5-1 수행 시 `git diff` 로 결과를 직접 확인할 것.
6. 스냅샷은 **USE_YN 무관 전량**을 담는다. locales 는 `USE_YN='Y'` 만 담으므로 `LOCALE_없음` 에는 정상적인 'N' 행이 섞인다.
