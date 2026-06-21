# `packages/shared/src/hooks/index.ts` — PATCH 안내

⚠ **이 파일을 통째로 교체하지 마세요.** 클라우드 측 `index.ts` 의 기존 export 목록이 로컬과 다를 수 있어 다른 hook 들이 resolve 실패합니다.

## 적용 방법 (한 줄 추가)

클라우드 측 `nscm-fe/packages/shared/src/hooks/index.ts` 파일 끝에 다음 한 줄만 추가:

```typescript
export * from './useTabBtnPermissions';
```

## 동반 파일

같은 폴더에 `useTabBtnPermissions.ts` 신규 파일을 함께 배포 (이 zip 안 `01_FE/useTabBtnPermissions.ts`).

## 검증

- 추가 후 dev server 재시작 (또는 빌드 + 배포)
- 브라우저 F12 → Application → Clear site data → 재로그인
- SYS0013 화면 진입 시 `useTabBtnPermissions` import 정상 동작
