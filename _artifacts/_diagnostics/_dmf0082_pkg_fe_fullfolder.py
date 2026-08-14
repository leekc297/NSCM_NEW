#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""DMF0082_CLOUD_20260814 정정 — FE 를 **폴더 전체**로 재구성.

사고(2026-08-14): B_FE 를 "기준선 대비 변경분만" 담아 **`index.ts` 가 빠졌다**.
  `apps/web/src/mdi/viewRegistry.tsx` 는
  `import.meta.glob('../../../../features/*/src/pages/*/index.ts')` 로 화면을 수집한다 —
  즉 **`index.ts` 가 화면 등록의 유일한 키**다. 폴더를 부분 교체하면 glob 이 화면을 못 찾고
  `resolveView()` → undefined → `ViewContainer.tsx:139` 이 탭 안에 **NotFoundPage** 를 그린다
  (= "Page Not Found. Unfortunately, the requested page could not be found.").

메모리 규약 재확인: feedback_cloud_shell_generation_mismatch §2026-08-11
  "이관 단위는 **import 가 통과하는 최상위 폴더**다" — barrel/폴더 부분 반입 금지.
"""
import io, pathlib, shutil, sys
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")

ROOT = pathlib.Path(r"C:\Projects\NSCM")
PKG = ROOT / "_artifacts" / "_deploy_packages" / "DMF0082_CLOUD_20260814"
FE = ROOT / "nscm-fe"

SETS = [
    # (src, dst, 설명)
    (FE / "features/demand/src/pages/forecast-price", PKG / "B_FE" / "forecast-price",
     "DMF0082 페이지 폴더 전체 (index.ts 포함 — 화면 등록 키)"),
    (FE / "features/demand/src/components", PKG / "B_FE" / "demand-components",
     "demand 공용 barrel 폴더 전체 (FcstUploadModal 등 — 화면이 barrel 경유 import)"),
    (FE / "features/master/src/components", PKG / "C_FE_SHARED" / "master-components",
     "master 공용 컴포넌트 폴더 전체 (index.ts barrel 포함 — MeasureSelectModal 등 승격분)"),
]

SKIP_DIRS = {"node_modules", "__snapshots__", ".turbo", "dist"}

for src, dst, desc in SETS:
    if dst.exists():
        shutil.rmtree(dst)
    n = 0
    for f in src.rglob("*"):
        if f.is_dir() or any(p in SKIP_DIRS for p in f.parts):
            continue
        if f.name == "__asis-mapping__.md":
            continue
        out = dst / f.relative_to(src)
        out.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(f, out)
        n += 1
    print(f"[full] {dst.relative_to(PKG)} — {n}파일  ({desc})")

# 부분 반입 잔재 제거 (구 C_FE_SHARED 하위 모달 폴더 + 참조용 barrel)
for stale in ("measureSelectModal", "columnLayoutModal", "projectByDivisionModal",
              "itemByDivisionModal", "index.ts.REFERENCE_MERGE_ONLY"):
    p = PKG / "C_FE_SHARED" / stale
    if p.is_dir():
        shutil.rmtree(p); print(f"[rm] C_FE_SHARED/{stale} (부분 반입본 — 폴더 전체본으로 대체)")
    elif p.exists():
        p.unlink(); print(f"[rm] C_FE_SHARED/{stale}")

# index.ts 존재 단언
key = PKG / "B_FE" / "forecast-price" / "index.ts"
print(f"\n[ASSERT] 화면 등록 키 index.ts 포함 = {key.exists()}  (False 면 재발)")
print(f"[ASSERT] master barrel index.ts 포함 = {(PKG / 'C_FE_SHARED' / 'master-components' / 'index.ts').exists()}")
print(f"[ASSERT] demand barrel index.ts 포함 = {(PKG / 'B_FE' / 'demand-components' / 'index.ts').exists()}")
