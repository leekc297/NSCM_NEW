#!/usr/bin/env python3
"""
GSCM 운영 메뉴 데이터 import 스크립트
사용법: python import_menu_data.py <17_Menu_Import_Template.xlsx>
산출물:
  - 14_IA_Tree.svg / .md (권한별 메뉴 트리로 갱신)
  - 14_IA_Tree_PermMatrix.xlsx (그룹×메뉴 권한 매트릭스)
  - 18_Menu_Coverage_Report.md (운영 메뉴 vs 분석 화면 cross-check)
"""
import sys, os, json
from openpyxl import load_workbook
from collections import defaultdict, Counter

def load_sheet(wb, name):
    ws = wb[name]
    headers = [c.value for c in ws[1]]
    rows = []
    for row in ws.iter_rows(min_row=2, values_only=True):
        if all(v is None for v in row): continue
        rows.append(dict(zip(headers, row)))
    return rows

def main(xlsx_path):
    wb = load_workbook(xlsx_path)
    menus = load_sheet(wb, "1_MenuTitleInfo")
    items = load_sheet(wb, "2_MenuItemInfo")
    groups = load_sheet(wb, "3_GroupInfo")
    auth = load_sheet(wb, "4_GroupMenuAuth")
    user_auth = load_sheet(wb, "5_UserMenuAuth")

    # Filter out example rows (highlighted yellow) — heuristic: skip if MENU_ID is integer 1-200
    # For real import, all rows are real
    print(f"Loaded: {len(menus)} menus, {len(items)} items, {len(groups)} groups, {len(auth)} auth rules")

    # Build menu tree
    menu_tree = {}
    for m in menus:
        menu_tree[m['MENU_ID']] = {**m, 'children': []}
    for m in menus:
        pid = m.get('PARENT_MENU_ID')
        if pid in menu_tree:
            menu_tree[pid]['children'].append(m['MENU_ID'])

    # Map screen → menu
    screen_to_menu = {i['SCREEN_ID']: i['MENU_ID'] for i in items}

    # Cross-check with analysis screens
    screens = json.load(open("../outputs/_scan2/screens_inventory.json"))
    analysis_ids = set(s['screen_id'] for s in screens)
    menu_screen_ids = set(screen_to_menu.keys())

    coverage = {
        "in_menu_and_analysis": menu_screen_ids & analysis_ids,
        "in_menu_only": menu_screen_ids - analysis_ids,
        "in_analysis_only": analysis_ids - menu_screen_ids,
    }
    print(f"Coverage: in both = {len(coverage['in_menu_and_analysis'])}, "
          f"menu only = {len(coverage['in_menu_only'])}, "
          f"analysis only = {len(coverage['in_analysis_only'])}")

    # Generate updated IA tree (placeholder)
    print("\n[TODO] Generate 14_IA_Tree.svg with permission tiers")
    print("[TODO] Generate 14_IA_Tree_PermMatrix.xlsx (group×menu)")
    print("[TODO] Generate 18_Menu_Coverage_Report.md")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python import_menu_data.py <xlsx_path>")
        sys.exit(1)
    main(sys.argv[1])
