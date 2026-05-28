# 13. i18n / 다국어 메시지 (MSG·LBL·MNU 코드)

> NSCM 의 다국어 시스템. DB 마스터 (`SCM_ADM_MSG_M`) + locales JSON + `useTranslation` Hook 의 3 단계.
> 신규 화면 추가 시 새 MSG/LBL/MNU 코드 등록 절차 + 자동 생성 스크립트 사용법.
>
> ⭐ **선행 룰**: [`08_SCREEN_REGISTRATION.md`](08_SCREEN_REGISTRATION.md) §3 (BLOCK 1 i18n DML), [`14_ERROR_HANDLING.md`](14_ERROR_HANDLING.md) §9 (사용자 메시지)
> ⭐ **연관**: 메모리 `reference_scm_adm_api_m_ddl.md` (API_MSG_ID 동반 INSERT)

---

## 1. 한 줄 요약

```
[DB] SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, ...)
  ↓ (build-time) python3 gen_i18n_msg_json.py
[FE] apps/web/src/locales/{KO|EN|CN}/msg.json
  ↓ (runtime) i18next-http-backend → /locales/{lng}.json
[Page] const { t } = useTranslation();
       t('MSG00002', '_필수입력', { 0: 'Division' })
```

---

## 2. 코드 체계 — 3 접두사

`SCM_ADM_MSG_M.MSG_TP_CD` 로 분류. **신규 코드 작성 시 접두사 반드시 사용**.

| 접두사 | 용도 | 예시 | 길이 |
|---|---|---|---|
| **`MSG`** | 사용자 메시지 (alert/toast/confirm) | `MSG00002` = "[{0}]은 필수 입력사항입니다" | 8자 (MSG + 5자리) |
| **`LBL`** | UI 라벨 (필드명/버튼명/컬럼명) | `LBL00112` = "조회" | 8자 (LBL + 5자리) |
| **`MNU`** | 메뉴명 | `MNU_DMF0099` = "판매 모니터" | 가변 (MNU_ + MENU_ID) |
| (특수) `MSG_API_*` | API 호출 시 에러 메시지 | `MSG_API_DMF0099_MAIN_SEARCH` | (API_MSG_ID 용) |

> ❌ **금지**: 임의 한글 메시지 하드코딩. 모든 사용자 메시지 / 라벨은 위 3 접두사 코드 경유.
> ✅ **권장**: 기존 MSG 재사용 (MSG00002 같은 표준 메시지 58종). 새로 만들기 전에 `SCM_ADM_MSG_M` 검색.

---

## 3. 핵심 파일 위치

### 3.1 BE / DB

```
SCM_ADM_MSG_M                                       ← 마스터 테이블 (3 lang × N 코드)
  ├─ MSG_ID (PK part)        : 'MSG00002' / 'LBL00112' / 'MNU_DMF0099' / 'MSG_API_DMF0099_MAIN_SEARCH'
  ├─ LANG_CD (PK part)       : 'KO' / 'EN' / 'CN'
  ├─ MSG_NM                  : 실제 다국어 문자열
  ├─ MSG_TP_CD               : 'MSG' / 'LBL' / 'MNU' / 'API' (분류)
  └─ USE_YN, CREATED_BY, CREATION_DATE, ...

nscm-be/src/main/resources/sql/admin/Message.xml    ← MyBatis 매퍼
nscm-be/.../admin/message/MessageServiceImpl.java   ← 조회 서비스
PKG_SYS0001                                         ← i18n 화면 (SYS0001) 관리 PKG
```

### 3.2 FE

```
nscm-fe/packages/foundation/src/lib/i18n.ts          ← i18next 설정 + useTranslation export
nscm-fe/apps/web/public/locales/{KO|EN|CN}.json     ← 런타임 로드 (i18next-http-backend)
  └─ 또는 src/locales/ (빌드 시 복사)
```

### 3.3 자동 생성 스크립트

```
Doc/_analysis/scripts/gen_i18n_msg_json.py          ← MSG/LBL 마스터 + validation.md 스캔 → JSON
Doc/output/i18n/                                    ← 기본 출력 위치
```

---

## 4. 신규 화면 추가 시 i18n 등록 (BLOCK 1)

자기완결형 인라인 DML 7-BLOCK 의 BLOCK 1:

```sql
-- BLOCK 1: SCM_ADM_MSG_M  (i18n × KO/EN/CN)
INSERT ALL
  -- 메뉴명
  INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN, CREATED_BY, CREATION_DATE)
    VALUES ('MNU_DMF0099', 'KO', '판매 모니터링', 'MNU', 'Y', 'admin', SYSDATE)
  INTO SCM_ADM_MSG_M (...) VALUES ('MNU_DMF0099', 'EN', 'Sales Monitor', 'MNU', 'Y', 'admin', SYSDATE)
  INTO SCM_ADM_MSG_M (...) VALUES ('MNU_DMF0099', 'CN', '销售监控', 'MNU', 'Y', 'admin', SYSDATE)

  -- 화면 고유 라벨 (필요 시)
  INTO SCM_ADM_MSG_M (...) VALUES ('LBL_DMF0099_DIVISION', 'KO', '사업부', 'LBL', 'Y', 'admin', SYSDATE)
  INTO SCM_ADM_MSG_M (...) VALUES ('LBL_DMF0099_DIVISION', 'EN', 'Division',  'LBL', 'Y', 'admin', SYSDATE)
  INTO SCM_ADM_MSG_M (...) VALUES ('LBL_DMF0099_DIVISION', 'CN', '事业部',    'LBL', 'Y', 'admin', SYSDATE)

  -- API 에러 메시지 (BLOCK 4 의 API_MSG_ID NOT NULL 대비)
  INTO SCM_ADM_MSG_M (...) VALUES ('MSG_API_DMF0099_MAIN_SEARCH', 'KO', '메인 조회 실패', 'API', 'Y', 'admin', SYSDATE)
  INTO SCM_ADM_MSG_M (...) VALUES ('MSG_API_DMF0099_MAIN_SEARCH', 'EN', 'Main search failed', 'API', 'Y', 'admin', SYSDATE)
  INTO SCM_ADM_MSG_M (...) VALUES ('MSG_API_DMF0099_MAIN_SEARCH', 'CN', '主查询失败', 'API', 'Y', 'admin', SYSDATE)
SELECT * FROM DUAL;
COMMIT;
```

> ⚠ **누락 시**: `SCM_ADM_API_M.API_MSG_ID` 가 NOT NULL → INSERT 실패. BLOCK 1 → BLOCK 4 의존 선후 필수.
> 표준 MSG 재사용 (예: MSG00002) 은 INSERT 불필요. 화면 고유 코드만 등록.

---

## 5. FE 사용 패턴 — `useTranslation`

### 5.1 표준 import

```ts
import { useTranslation } from '@foundation/lib';

const { t } = useTranslation();
```

### 5.2 일반 텍스트

```tsx
<button>{t('LBL00112', '_조회')}</button>     // 두 번째 인자 = 누락 시 fallback (개발 편의)
<MainTitle title={t('MNU_DMF0099', '_판매 모니터링')} />
```

### 5.3 인자 치환 (placeholder)

```ts
// SCM_ADM_MSG_M: 'MSG00002' = "[{0}]은 필수 입력사항입니다."
t('MSG00002', '_필수입력', { 0: 'Division' });
// → "[Division]은 필수 입력사항입니다."
```

### 5.4 메시지 박스 호출

```ts
import { showAlert, showConfirm } from '@shared/components';

showAlert(t('MSG00005', '_저장되었습니다'));
showConfirm(t('MSG00060', '_삭제하시겠습니까?'), () => deleteRow());
```

> ❌ **금지**: 한글/영문 직접 하드코딩.  ✅ **요청**: t() 함수 경유.

---

## 6. 자동 생성 스크립트 (`gen_i18n_msg_json.py`)

### 6.1 동작 원리
1. 스크립트 내 `MASTER_MSG` 사전 (표준 58종) 로드
2. `Doc/_analysis/domain_*/screens/*/validation.md` 의 모든 MD 스캔 → 사용된 MSG/LBL ID 추출
3. `MASTER_MSG` 에 없는 ID 는 `TODO` 표시 (수동 등록 필요)
4. KO/EN/CN 3 JSON 파일 생성

### 6.2 명령

```bash
# 기본 (Doc/output/i18n/ 에 출력)
python3 Doc/_analysis/scripts/gen_i18n_msg_json.py

# FE 실 위치에 직접 출력
python3 Doc/_analysis/scripts/gen_i18n_msg_json.py \
    --out C:/Projects/NSCM/nscm-fe/apps/web/public/locales/
```

### 6.3 TODO 처리

스크립트 실행 후 출력 보고서 (`unmapped_msg_ids.txt`) 에 TODO 표시된 ID 가 있다면:
1. 해당 MSG/LBL 의 다국어 텍스트 확정
2. `SCM_ADM_MSG_M` 에 INSERT (3 lang)
3. `gen_i18n_msg_json.py` 재실행 → TODO 해소

---

## 7. langCd 전파 (FE → BE → DB)

### 7.1 BE
```java
@LoginUser UserSession userSession  // userSession.getLangCd() = 'KO' / 'EN' / 'CN'
params.put("langCd", userSession.getLangCd());   // SP 의 P_LANG_CD 로 전달
```

### 7.2 DB
```sql
SELECT MSG_NM
  FROM SCM_ADM_MSG_M
 WHERE MSG_ID  = #{msgId}
   AND LANG_CD = #{langCd};
```

### 7.3 FE 언어 변경
```ts
import { i18n } from '@foundation/lib';
import { useSessionStore } from '@shared/stores';

const onLanguageChange = (lang: 'KO' | 'EN' | 'CN') => {
  void i18n.changeLanguage(lang);
  useSessionStore.getState().changeLanguage(lang);
  // BE 도 다음 호출부터 자동으로 새 langCd 사용 (세션에 저장됨)
};
```

---

## 8. supportedLngs 와 fallback

```ts
// foundation/lib/i18n.ts
export const supportedLngs = ['KO', 'EN', 'CN'];
fallbackLng: 'KO',
```

- 지원 언어 3개. 다른 언어로 요청 시 KO 로 fallback.
- BE `SCM_ADM_MSG_M.LANG_CD` 는 정확히 3 값 ('KO'/'EN'/'CN') — lower-case 'ko'/'en'/'cn' 사용 금지.

---

## 9. 흔한 실수

### 9.1 MNU 코드 누락
- 메뉴 등록 후 `SCM_ADM_MSG_M` 에 `MNU_{MENU_ID}` 가 없으면 → 메뉴 트리에 코드 그대로 표시.
- 검증: 메뉴 등록 후 `Verify.sql` 의 `7.I18N_MNU` 행이 CNT >= 3.

### 9.2 API_MSG_ID 누락
- `SCM_ADM_API_M.API_MSG_ID` NOT NULL → BLOCK 4 INSERT 실패.
- 해결: BLOCK 1 에 `MSG_API_{MENU}_{SHEET}_{ACTION}` 패턴으로 3 lang 동반 INSERT.
- 메모리: `reference_scm_adm_api_m_ddl.md`.

### 9.3 placeholder 누락
- `MSG00002 = "[{0}]은 필수입력"` → 호출 시 `t('MSG00002', '_', { 0: 'Division' })` 인자 전달 필수.
- 누락 시 화면에 `[{0}]` 그대로 표시.

### 9.4 fallback 영문이 영구 잔존
- 개발 중 `t('MSG00005', '_저장됨')` 같이 한글 fallback 작성 → DB 등록 누락 시 영구 잔존.
- 해결: PR 직전 `gen_i18n_msg_json.py` 실행 → TODO 보고서 0건 확인.

---

## 10. 자기 점검 체크리스트

```
[ ] 신규 화면의 MNU/LBL/MSG 코드 모두 SCM_ADM_MSG_M 등록 (3 lang)
[ ] BLOCK 1 (i18n) → BLOCK 4 (API) 의존 선후 준수
[ ] FE 코드에 한글/영문 직접 하드코딩 0건 (t() 경유)
[ ] gen_i18n_msg_json.py 실행 → TODO 보고서 0건
[ ] supportedLngs = ['KO','EN','CN'] 만 사용 (lower-case 금지)
[ ] placeholder ({0}, {1}) 필요한 MSG 호출 시 인자 전달
[ ] API_MSG_ID 가 MSG_API_{MENU}_{SHEET}_{ACTION} 패턴
[ ] 표준 메시지 (MSG00002 등 58종) 재사용 — 신규 작성 전 검색
```

---

## 11. 관련 문서

| 룰 | 주제 |
|---|---|
| [`08_SCREEN_REGISTRATION.md`](08_SCREEN_REGISTRATION.md) §3 Step 2 | BLOCK 1 i18n INSERT 패턴 |
| [`14_ERROR_HANDLING.md`](14_ERROR_HANDLING.md) §9 | 사용자 친화 메시지 가이드 |
| [`hooks/post-write.md`](hooks/post-write.md) §5.5 | MSG ID 신규 시 i18n JSON 갱신 |
| 메모리 `reference_scm_adm_api_m_ddl.md` | API_MSG_ID NOT NULL 대응 |
