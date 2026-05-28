# Architecture Guide

## 3-Layer Architecture

### Layer 1: Foundation (@foundation)

- 순수 함수 및 유틸리티
- 타입 정의 및 모델
- HTTP 클라이언트
- 디자인 시스템 (SCSS)

### Layer 2: Shared (@shared)

- 재사용 가능한 훅
- 전역 상태 관리 (Zustand)
- UI 컴포넌트 (Button, DataTable 등)

### Layer 3: Application (apps/web, features/\*)

- 페이지 및 비즈니스 로직
- 도메인별 feature
- MDI 탭 관리

## 의존성 규칙

✅ Layer 3 → Layer 2 → Layer 1
❌ 상향 의존 불가
❌ Feature 간 의존 불가

---

See README.md for more details.
