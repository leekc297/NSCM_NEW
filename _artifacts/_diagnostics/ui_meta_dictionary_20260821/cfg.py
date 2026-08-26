# -*- coding: utf-8 -*-
"""cfg.py — 00_config.py 로더 (모듈명이 숫자로 시작해 직접 import 불가).

다른 스크립트는 `import cfg` 만 하면 00_config.py 의 모든 심볼을 그대로 쓴다.
설정 값은 00_config.py 한 곳에서만 관리한다.
"""
import importlib.util
import os

_HERE = os.path.dirname(os.path.abspath(__file__))
_spec = importlib.util.spec_from_file_location("_ui_meta_cfg", os.path.join(_HERE, "00_config.py"))
_mod = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(_mod)

globals().update({k: v for k, v in vars(_mod).items() if not k.startswith("__")})
