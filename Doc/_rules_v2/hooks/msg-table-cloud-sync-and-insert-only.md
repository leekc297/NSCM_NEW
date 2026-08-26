# Hook — MSG TABLE 클라우드 동기화 + 이관은 INSERT(NOT EXISTS) 전용

> ⭐ **두 가지 의무를 한 룰로 묶는다.**
> §A. "MSG TABLE 클라우드 기준(첨부) 으로 업데이트 해줘" = **정해진 1-명령 절차**를 수행한다.
> §B. UI 생성·보완 후 **클라우드 이관 취합 시 `SCM_ADM_MSG_M` 축은 `INSERT ... NOT EXISTS` 로만** 만든다.
>     기존 코드의 문구를 덮어쓰는 MERGE/UPDATE 금지 — 신규 코드만 추가된다.

작성: 2026-08-21 (사용자 명시 2건 — ①상시 실행 절차 고정 ②이관 시 INSERT-only 강제)
도구: `_artifacts/_cloud_to_corp/MSG_SYNC/msg_update.py`
관련 룰: `22_PACKAGE_ARTIFACTS.md` §9, hook #98(메타 무결성), #114(MSG ID 대사), #122(클라우드 역이관)
관련 메모리: `feedback_i18n_new_code_three_point_sync`, `feedback_deploy_package_msg_lbl_mnu_omission`,
`feedback_corp_meta_integrity_wiring`

---

## §A. 트리거 — "MSG TABLE 클라우드 기준(첨부) 으로 업데이트 해줘"

사용자가 클라우드에서 뽑은 `SCM_ADM_MSG_M` 추출본(CSV/TSV/JSON, 형식 무관)을 주며 위 문구를
말하면 **아래 절차를 그대로 수행한다.** 절차를 새로 설계하지 말 것.

```bash
cd _artifacts/_cloud_to_corp/MSG_SYNC
python msg_update.py <첨부파일>                     # 1) 판정 + SQL 생성 (무변경)
#   -> out_<파일명>/00_REPORT.xlsx 검토
python msg_update.py <첨부파일> --apply-db --apply-ui   # 2) 승인 후 적용
cd ../../../nscm-fe && node scripts/sync-i18n.mjs       # 3) locales 재생성 (BE 기동 필요)
```

### A-1. 처리 규칙 (도구가 자동 수행)

| # | 상황 | 처리 |
|---|---|---|
| **A** | 코드 동일 · 명칭 상이 | 사내 명칭을 **클라우드 기준으로 UPDATE** |
| **B** | 사내에 코드 없음 | **신규 INSERT** |
| **C** | A 인데 그 코드를 **사내 UI 가 사용 중** | C-1 / C-2 |
| C-1 | 클라우드에 **옛 명칭을 가진 다른 코드** 존재 | UI 를 그 코드로 **치환** |
| C-2 | 없음 | **신규 채번**(01001+) → 옛 명칭으로 사내 INSERT → UI 치환 → **클라우드에도 INSERT** |
| **D** | 사내 단독 보유 (클라우드에 없음) | 삭제 금지. **클라우드 INSERT 후보**로 §B 형식 생성 |

> **C 가 A 를 안전하게 만든다.** C 없이 A 만 하면 그 코드를 쓰는 다른 화면이 조용히 오표기된다.

### A-2. 절대 준수 5항 (전부 실사고 계보)

1. **값을 트림하지 말 것.** 사내 원장에 뒤 공백이 실재한다(`MNU00185 = 'Biz Plan Price '`).
   트림하면 없는 차이가 생기고, 그 차이가 **신규 코드 채번까지 유발**한다.
2. **차이의 성격을 가를 것.** `공백차이` / `표기차이`(구두점·간격) / `번역채움` / `언어퇴행` / `의미변경`.
   **의미변경만** UI 치환·신규 채번 대상이다. 구두점 하나로 코드를 따면 안 된다.
3. **언어퇴행 확인.** 클라우드 EN/CN 칸에 한글이 들어온 행은 사내 번역이 더 정확할 수 있다.
   기본은 **UPDATE 제외**, 덮어쓰려면 `--allow-lang-regression` + **사용자 승인**.
4. **순환 치환 대비.** 코드↔문구 배정이 어긋난 대역에서는 `A→B`, `B→A` 상호 교환이 실재한다
   (2026-08-21 `MSG00711 ↔ MSG00712`). 소스는 **정규식 1패스 동시 치환**, DB 메타는
   **임시 센티널 경유 2단계 UPDATE**. 순차 처리하면 뒤 치환이 앞을 되돌려 두 코드가 한 값으로 뭉개진다.
5. **조용한 누락 차단.** 생성 SQL 말미에 `-- STMT_COUNT: n` 을 남기고, 적용 시 분해 결과가 다르면
   **실행하지 않고 중단**한다. (헤더 주석 + `SET DEFINE OFF` + 첫 문장이 한 덩어리로 묶여
   통째로 스킵된 실사고 계보 — `feedback_sql_split_comment_filter_drops_stmt`)

### A-3. 채번 규약 (= `feedback_i18n_new_code_three_point_sync`)

- 기존에 **같은 명칭이 있으면 그 코드 재사용**(= C-1). 없을 때만 신규 채번(= C-2).
- 신규는 **`01001` 이상 대역**에서 MAX+1. 1000 미만 공번 메우기 ⛔, 전대역 MAX+1 ⛔.
- MAX 는 **사내 + 클라우드 양측**을 함께 본다(클라우드 선점 코드 충돌 방지).
- 대역 밖 이상치(`MSG99999` = 테스트 행)는 MAX 계산에서 제외한다.

### A-4. ⭐ 치환 후 문서·주석 전수 스윕 (2026-08-21 추가 — 실사고 계기)

도구는 **따옴표 리터럴만** 치환한다. 그래서 치환된 옛 코드가 **룰 문서·주석에 하드코딩**돼 있으면
그대로 남고, 특히 **룰이 그 코드를 '정본' 으로 지시하고 있으면 다음 작업이 잘못된 문구를 띄운다.**

```bash
# 치환된 옛 코드 전부에 대해 수행 (40_UI_REMAP.md 의 '옛코드' 목록)
rg -n "<옛코드>" Doc nscm-fe nscm-be
```

판정 기준:

| 히트 위치 | 조치 |
|---|---|
| 룰 문서(`Doc/_rules_v2/**`, `RULESET_MASTER`)가 **정본으로 지시** | ⛔ **반드시 정정** — 기능 영향 |
| 소스 **주석** | 정정 (실행 코드는 이미 치환됨. 다음 작업자가 주석을 근거로 삼는 사고 차단 — #138) |
| `public/locales/*.json`, `configs/types/generated-keys.d.ts` | **정상** — 전 코드를 담는 사전 항목이므로 손대지 않는다 |
| 채번 기준선을 적은 문서 | 01001+ 대역 max 가 바뀌었으면 갱신 (전 대역 max 표기 금지) |

> **실사고(2026-08-21)**: `MSG00718` 이 클라우드에서 '권한 요청을 반려하시겠습니까?' 로 재정의되어
> 옛 의미가 `MSG01023` 으로 이관됐는데, hook #135 가 여전히 "조회 0건 = 정본 `MSG00718`" 을
> 지시하고 있었다. 코드 참조는 0건이었지만 **룰이 틀린 코드를 가리켜** 다음 Excel Form 작업이
> 반려 confirm 문구를 띄울 상태였다. 함께 hook #98·RULESET_MASTER 의 채번 기준선도 stale 이었다.

### A-5. 완료 조건

- 재실행 시 **명칭상이 0 / 사내미보유 0 / UI치환 0** 으로 수렴할 것 (실측 보고 의무).
- `node scripts/sync-i18n.mjs` 로 locales 재생성 + 신규 코드가 3언어에 모두 들어갔는지 확인.
- 적용 전 **백업**(`08_BACKUP_PRE_APPLY.json`)과 **원복 스크립트**(`09_ROLLBACK_CORP.sql`) 보유.
- **A-4 스윕 완료** — 옛 코드가 룰 문서·주석에 남아 있지 않을 것(사전 항목 제외).

---

## §B. 클라우드 이관 취합 시 — MSG/LBL 축은 `INSERT ... NOT EXISTS` 전용 ⭐

UI 생성·보완 후 이관 패키지를 만들 때, `SCM_ADM_MSG_M` 축은 **반드시 아래 형식**으로 낸다.

```sql
INSERT INTO SCM_MGR.SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_DESC, MSG_TP_CD, USE_YN,
                                   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'MSG01016', 'KO', '...', NULL, 'MSG', 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_MSG_M T
                    WHERE T.MSG_ID = 'MSG01016' AND T.LANG_CD = 'KO');
```

### B-1. 금지·의무

| | 내용 |
|---|---|
| ⛔ 금지 | `MERGE INTO SCM_ADM_MSG_M`, 기존 코드에 대한 `UPDATE MSG_NM`, `DELETE` |
| ✅ 의무 | 전 행 `NOT EXISTS` 가드 (PK = **MSG_ID + LANG_CD** 양쪽 모두) |
| ✅ 의무 | 감사컬럼 = `'admin'` 고정 (claude ID ⛔) |
| ✅ 의무 | 재실행 멱등 — 두 번 돌려도 결과 동일 |
| ✅ 의무 | 대상 = **신규 채번분 + 사내 단독 보유분**. 이미 양측에 있는 코드는 담지 않는다 |

### B-2. 왜 INSERT-only 인가

기존 코드의 문구를 이관물이 덮으면, **그 코드를 쓰는 다른 화면 전부가 조용히 오표기**된다
(2026-08-14 사용자 확정: "기존 코드에 명칭을 변경하면 기존 프로그램에 다른 TEXT 로 보이는 치명적인 오류").
코드는 화면 간 공유 자산이므로, 한 화면 기준으로 문구를 바꾸는 이관은 성립하지 않는다.
문구를 정말 바꿔야 하면 **§A 절차**(UI 치환까지 동반)로 처리하거나, 별도 명시 승인 후 단건으로만 한다.

### B-3. 이관 취합 체크 (deploy-package-completeness 와 함께 본다)

```
[ ] MSG/LBL 축 SQL 에 MERGE / UPDATE MSG_NM / DELETE 가 0건인가?   (grep 으로 실측)
[ ] 모든 INSERT 에 NOT EXISTS 가드가 붙었는가? (INSERT 수 == NOT EXISTS 수)
[ ] 담긴 코드가 신규분뿐인가? 대상 환경에 이미 있는 코드가 섞이지 않았는가?
[ ] 감사컬럼이 전부 'admin' 인가?
[ ] 재실행 시 0행 반영(멱등)인가?
```

> 자동 생성이 필요하면 `msg_update.py` 가 만든 `30_CLOUD_PUSH.sql` 을 그대로 쓴다 —
> 이 파일이 §B 형식의 **정본**이다.

---

## 실적 (2026-08-21 최초 적용)

클라우드 2,718행/947코드 ↔ 사내 2,634행/917코드.
- UPDATE 68 / INSERT 213 / UI 치환 19코드(FE 30곳·메타 8건) / 신규 채번 12코드 36행
- 적용 후 재판정 = **명칭상이 0 · 미보유 0 · 치환 0** 수렴, 사내 2,883행
- `30_CLOUD_PUSH.sql` = 165행 전량 `NOT EXISTS` 가드
- 잡은 결함: 값 트림으로 인한 허위 차이 / `SEGMENT2` 미필터로 사용중 판정 오염 /
  SQL 분해기 첫 문장 누락 / 순차 치환으로 인한 소스 2파일 손상 (전부 적용 전 정정)
