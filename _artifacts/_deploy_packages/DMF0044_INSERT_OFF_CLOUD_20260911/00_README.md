# DMF0044 INSERT 버튼 회수 — 클라우드 이관 패키지 (2026-09-11)

| 항목 | 값 |
|---|---|
| 요청 | 사용자 지시 2026-09-11 — "DMF0044 에서는 INSERT 기능을 사용하지 않는다" |
| 원장 | `REQ:CHAT-20260911-W65` |
| 마커 | `E20260911-DMF0044INSOFF` |
| 방식 | **메타(버튼 권한) 변경만** — FE/BE/SP 코드 변경 **0건** |
| 사내 적용 | 2026-09-11 11:25 완료·검증 PASS |

## 실행 순서

| # | 파일 | 내용 |
|---:|---|---|
| 1 | `01_BTN_INSERT_OFF.sql` | `SCM_ADM_USER_GR_MNU_BTN_MPG_M` 2행 + `SCM_ADM_MNU_BTN_MPG_M` 1행 `USE_YN='N'` |

원복 = `99_ROLLBACK.sql` (둘 다 `'Y'` 복원).

## 왜 코드 변경이 필요 없나 (실측 근거)

FE `SalesReports.tsx` 의 버튼 배선이 **이미 메타 구동**이다:

```ts
insert: hasButton('INSERT') && searched.dataType === DATA_TYPE.ETC ? handleInsert : false
```

`hasButton` 원천 = `GET /admin/menu/DMF0044/auth` → `PKG_NSCM_UI_COM_AUTH.PR_GET_MNU_BTN_AUTH`
(BODY L60~73). 이 SP 는 `SCM_ADM_USER_GR_MNU_BTN_MPG_M` 만 읽고 `UG.USE_YN='Y' AND GMB.USE_YN='Y'`
로 거른다(`[E20260826-BTNUSEYN]`). 따라서 권한 행을 `'N'` 으로 내리면 `mnuBtnAuth` 에서 INSERT 가
빠지고, 공용 `SubTitle.tsx` 규약상 `false` = **버튼 미렌더 + F8 핫키 미등록**이 된다.

⭐ Insert 는 이 화면에서 **ETC(Data Type=2) 전용**이었다 → ETC 에서 없애는 것이 화면 전체 제거와 같다.

## 적용 축이 2개인 이유

| 표 | 행 | 성격 |
|---|---:|---|
| `SCM_ADM_USER_GR_MNU_BTN_MPG_M` | 2 (ADMIN / DM ADMIN) | **실효 축** — 이것만이 버튼 노출을 가른다 |
| `SCM_ADM_MNU_BTN_MPG_M` | 1 | **선언 축** — 런타임 효과 0 (아래 실측). SYS0009 에서 "미사용" 표시 목적 |

배선표 `USE_YN` 이 런타임 무효과인 실측 근거:
- `PR_GET_MNU_BTN_AUTH` — 이 표 자체를 안 읽음
- `PKG_NSCM_UI_COMM` — `API_URL` 해석 시 `(MNU_ID, SHT_NM, MNU_BTN_CD)` 만 사용, `USE_YN` 필터 없음
- `PKG_SYS0008` 버튼목록 — `MB.USE_YN` 필터 없음 (L104~114. L109 의 `M.USE_YN` 은 `SCM_ADM_MSG_M`)

## 부수영향 없음 확인 (사내 실측)

- DMF0044 버튼 배선 **29행 전수** 조회 — `MNU_BTN_CD='INSERT'` 는 `MDF Reports` 시트에만 존재
- 환율 팝업 자체 Insert 는 FE 에서 `hasButton('EXRATE_SAVE')` 로 별도 게이트 → 무영향
- `SCM_ADM_API_M` 은 **미변경** (다른 참조 가능성 + 실익 없음)

## 사내 검증 결과 (2026-09-11)

1. 행 상태 — GR 2행 + MPG 1행 모두 `USE_YN='N'`, `LAST_UPDATED_BY='admin'`
2. 권한 SP 로직 재현 — DMF0044 버튼 **29 → 28행**, `INSERT` 만 빠지고 나머지 전부 유지
3. HTTP E2E (`/user/login` → `/admin/menu/DMF0044/auth`) 3계정 실측

| 계정 | 권한 | 버튼 수 | INSERT | DELETE | SAVE | SEARCH |
|---|---|---:|---|---|---|---|
| minyonglee1 | - | 28 | 없음 ✅ | Y | Y | Y |
| hongjae.kim | 40 DM Admin | 28 | 없음 ✅ | Y | Y | Y |
| yooah.chung | 40 DM Viewer | 19 | 없음 ✅ | N | Y | Y |

## ⚠ 주의

- FE 는 `useTabBtnPermissions` 가 `staleTime: 60_000` 으로 캐시한다 — 적용 후 화면은
  **새로고침(또는 60초 경과)** 해야 반영된다.
- 이 방식은 **되살릴 수 있다** — 관리자가 SYS0008(사용자그룹 버튼권한)에서 INSERT 를 다시 `'Y'` 로
  주면 버튼이 돌아온다. FE 코드에는 `handleInsert` 가 그대로 남아 있다(사용자 선택: DB 메타만).
  영구 차단이 필요하면 별도 지시 필요.
