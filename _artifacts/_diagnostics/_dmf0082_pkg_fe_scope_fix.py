#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""DMF0082_CLOUD_20260814 FE 범위 정정 (사용자 지시 2026-08-14).

지시: "폴더 전체 취합 = **수정한 파일이 존재하는 폴더** 전체이지,
       수정하지 않은 파일(폴더)까지의 전체가 아니다."

⇒ 규칙: git 기준 수정/신규 파일이 **1건이라도 있는 폴더**만 → 그 폴더는 **전체 파일** 반입.
        수정 0건인 폴더는 제외. (부분 파일 반입은 여전히 금지 — index.ts 누락 사고 계보)
"""
import io, pathlib, shutil, subprocess, sys
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")

ROOT = pathlib.Path(r"C:\Projects\NSCM")
PKG = ROOT / "_artifacts" / "_deploy_packages" / "DMF0082_CLOUD_20260814"
FE = ROOT / "nscm-fe"
SKIP_DIRS = {"node_modules", "__snapshots__", ".turbo", "dist"}


def modified_rel(tree_rel):
    """git status 로 tree_rel 하위의 수정/신규 파일 상대경로 집합."""
    out = subprocess.run(
        ["git", "status", "--porcelain", "--untracked-files=all", "--", tree_rel],
        cwd=ROOT, capture_output=True, text=True, encoding="utf-8", errors="replace").stdout
    rels = set()
    for ln in out.splitlines():
        path = ln[3:].strip().strip('"')
        if path.startswith(tree_rel):
            rels.add(path[len(tree_rel):].lstrip("/"))
    return rels


def build(tree_rel, dst, label, unit="subfolder"):
    """unit='self'     : 이 폴더 자체가 반입 단위 → **폴더 전체**(미수정 파일 포함).
                         페이지 폴더가 여기 해당한다 — `index.ts` 는 수정되지 않아도
                         viewRegistry glob 의 등록 키라 빠지면 화면이 사라진다(Page Not Found).
       unit='subfolder': 하위 컴포넌트 폴더가 각각 반입 단위 → 수정 있는 하위폴더 + 수정된 루트 파일만.
    """
    src = ROOT / tree_rel
    mods = modified_rel(tree_rel)
    if unit == "self":
        keep_dirs = {p.name for p in src.iterdir() if p.is_dir()}
        keep_root_files = {p.name for p in src.iterdir() if p.is_file()}
    else:
        keep_dirs, keep_root_files = set(), set()
        for r in mods:
            head = r.split("/")[0]
            (keep_dirs if "/" in r else keep_root_files).add(head)

    if dst.exists():
        shutil.rmtree(dst)
    n, folders = 0, set()
    for f in src.rglob("*"):
        if f.is_dir() or any(p in SKIP_DIRS for p in f.parts) or f.name == "__asis-mapping__.md":
            continue
        rel = f.relative_to(src).as_posix()
        head = rel.split("/")[0]
        take = (head in keep_dirs) if "/" in rel else (rel in keep_root_files)
        if not take:
            continue
        out = dst / rel
        out.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(f, out)
        n += 1
        folders.add(head)

    all_heads = {p.name for p in src.iterdir() if p.is_dir()}
    excluded = sorted(all_heads - keep_dirs)
    print(f"\n## {label}  ({tree_rel})")
    print(f"   수정 파일 {len(mods)}건 → 반입 폴더 {len(keep_dirs)}개 + 루트파일 {len(keep_root_files)}개 = {n}파일")
    print(f"   반입 : {', '.join(sorted(keep_dirs | keep_root_files)) or '-'}")
    print(f"   제외 : {', '.join(excluded) or '-'}  (수정 0건)")
    return n, sorted(keep_dirs | keep_root_files), excluded


res = {}
res["page"] = build("nscm-fe/features/demand/src/pages/forecast-price",
                    PKG / "B_FE" / "forecast-price", "DMF0082 페이지", unit="self")
res["master"] = build("nscm-fe/features/master/src/components",
                      PKG / "C_FE_SHARED" / "master-components", "master 공용 컴포넌트")

# demand 공용 — 수정 0건이면 폴더 자체를 뺀다
dmd = modified_rel("nscm-fe/features/demand/src/components")
dpath = PKG / "B_FE" / "demand-components"
if not dmd:
    if dpath.exists():
        shutil.rmtree(dpath)
    print("\n## demand 공용 컴포넌트 — 수정 0건 → **패키지에서 제외**(기준선분 그대로 유효)")
else:
    res["demand"] = build("nscm-fe/features/demand/src/components", dpath, "demand 공용 컴포넌트")

# 페이지 폴더는 index.ts 가 반드시 있어야 한다 (viewRegistry 등록 키)
key = PKG / "B_FE" / "forecast-price" / "index.ts"
print(f"\n[ASSERT] forecast-price/index.ts = {key.exists()}   (False 면 Page Not Found 재발)")
print(f"[ASSERT] master-components/index.ts(barrel) = {(PKG / 'C_FE_SHARED' / 'master-components' / 'index.ts').exists()}")
print(f"\n총 FE 파일 = {sum(1 for _ in (PKG / 'B_FE').rglob('*') if _.is_file()) + sum(1 for _ in (PKG / 'C_FE_SHARED').rglob('*') if _.is_file())}")
