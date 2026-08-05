# 공통 파일 patch (통째 교체 금지 — 아래 지점만 수동 반영)

## 1. `nscm-fe/features/admin/src/index.ts` — export 1줄 추가

기존 `notice-setup` export 바로 아래에 추가:

```diff
 export * from './pages/notice-setup/NoticeSetup';
+export * from './pages/mail-setup/MailSetup';
```

## 2. `nscm-fe/configs/types/procedures.d.ts` — SYS0017 블록 추가

`procedures.d.ts.SYS0017_BLOCK.ts` 내용을 `ProcedureMap` 인터페이스 안에 붙여넣는다.
(본 패키지 작업 시엔 `SYS0016` 블록과 `COM0004` 블록 사이에 삽입했다. 위치는 무관하나 **기존 블록 삭제·재정렬 금지**.)

## 3. `nscm-fe/public/locales/{KO,EN,CN}.json` — 각 19키 추가

`locales.SYS0017_PATCH.json` 의 언어별 객체를 각 파일에 **머지**(기존 키 유지, 중복 키 덮어쓰기 금지).
키 목록: `MNU00690` / `MSG00690~MSG00698`(9) / `LBL00774~LBL00782`(9).
값은 사내 `SCM_ADM_MSG_M` 등록분과 동일하며, MSG 9종은 AS-IS `TB_FX_MessageInfo` 실문구 기준이다.

## 4. 라우팅 — ⚠️ **먼저 클라우드 viewRegistry 세대를 판별할 것** (2026-07-30 정정)

> 이전 판에 "FE 코드 변경 불필요" 라고만 적었던 것은 **로컬(신판) 기준이라 불완전**했다.
> 클라우드 `apps/web/src/mdi/` 는 신·구 세대가 혼재할 수 있다 (hook — `feedback_cloud_shell_generation_mismatch`).

`apps/web/src/mdi/viewRegistry.tsx` 를 열어 판별한다:

### (A) 신판 — `import.meta.glob` + `URL_ALIASES` 가 있다 → **FE 코드 변경 불필요**

폴더를 빌드타임 glob 으로 자동 수집한다. 단, 매칭 key 는 다음 순서다:

```
[ ROUTE_PATH('<도메인>/<폴더>' — 2단만 유효), MNU_URL 마지막 세그먼트, URL_ALIASES[leaf] ]
```

⚠️ 우리가 넣은 `ROUTE_PATH='admin/system/mail-setup'` 은 **3단이라 매칭되지 않는다**(자매 SYS0004/SYS0016 도 동일하며, 실제로는 전부 MNU_URL leaf 로 매칭되고 있다).
→ 따라서 **`MNU_URL` 이 정확히 `mail-setup` 이어야** 한다. 아니면 404. 정정 = `sql/98_mnu_url_align.sql`.

추가로, glob 은 **빌드타임 정적 분석**이라 폴더를 새로 넣었으면 **dev 서버 재기동 / 재빌드 필수**.

### (B) 구판 — `export const VIEW_REGISTRY: Record<string, LazyPage>` 정적 맵이다 → **코드 1줄 등록 필수**

구판은 **MNU_ID 키**라 DB `ROUTE_PATH` / `MNU_URL` 과 무관하게 코드 등록이 없으면 404 다.
`SYS0016` 항목 바로 아래에 이웃과 동일 형식으로 추가한다:

```diff
   SYS0016: view(() => import('@admin/notice-setup').then(m => ({ default: m.NoticeSetup }))),
+  SYS0017: view(() => import('@admin/mail-setup').then(m => ({ default: m.MailSetup }))),
```

(`@admin/*` alias = `features/admin/src/pages/*/index.ts` — `configs/tsconfig.base.json`. 우리 `index.ts` 는 `MailSetup` 을 named export 한다.)

⛔ 세대 판별 없이 로컬 `viewRegistry.tsx` 를 클라우드에 **덮어쓰지 말 것** — export 계약 불일치로 **앱 전체 백지** 사고 선례(2026-07-22).

### 404 위치로 원인 좁히기

| 증상 | 원인 위치 |
|---|---|
| **탭은 열리고 탭 안쪽만** 404 (탭바·사이드바 정상) | `ViewContainer` → viewRegistry 매칭 실패 = 위 (A) MNU_URL leaf 또는 (B) 코드 등록 누락 |
| 탭이 안 열리고 **컨텐츠 영역 전체** 404 | `Router` catch-all = URL 이 라우트와 불일치 (구세대 셸에서 MNU_URL 조인 경로로 이동하는 경우) |

깨진 탭은 sessionStorage `MDI-store` 에 영속되어 리로드마다 재현된다 → 조치 후 **Application 탭에서 삭제**.

