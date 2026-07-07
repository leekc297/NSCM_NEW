# DMF0020 Sales Price — Figma 객체 분석 (메인 화면)

> 원본 Figma node `4790:134480` — file `c9VYF8oleb9TczKeFWi4ka` (Next SCM Working File)
> 생성: parse_figma_node.py · 방식: node JSON(absoluteBoundingBox 절대좌표 + characters 실라벨) · 좌표계 원점=프레임 좌상단 기준 절대값(px)
> 프레임: **Master > Demand Master > Sales Price** — 1920 × 963 px
> 총 객체 3174 · TEXT 라벨 517 · INSTANCE 종류 85

## §1. 객체 트리 (전체) — type / name / x / y / w / h / fill / stroke / text

| depth | type | name | x | y | w | h | fill | stroke | text/comp |
|---|---|---|--:|--:|--:|--:|---|---|---|
| 0 | FRAME | Master > Demand Master > Sales Price | 0 | 0 | 1920 | 963 |  |  |  |
| 1 | INSTANCE | ·Pattern/Navigation/Header | 0 | 0 | 1920 | 52 | #F7F9F8 | #DDE0DF | ⟶ Language=Korean, Appearance=Positive, 1Depth Menu=Yes, Left Menu=Yes |
| 2 | FRAME | ··Left Container | 0 | 0 | 322 | 52 | #F7F9F8 |  |  |
| 3 | INSTANCE | ···#Pattern/Navigation/Header/Left_Menu | 0 | 0 | 52 | 52 | #2D9BB2 |  | ⟶ Has Left Area=Yes, Status=Default |
| 4 | INSTANCE | ····Icons/Menu/Menu | 14 | 14 | 24 | 24 |  |  | ⟶ Icons/Menu/Menu |
| 5 | VECTOR | ·····Union | 17 | 18 | 18 | 16 | #FFFFFF |  |  |
| 3 | FRAME | ···System Name | 66 | 8 | 256 | 36 |  |  |  |
| 4 | INSTANCE | ····#Pattern/Navigation/Header/Logo | 66 | 8 | 126 | 36 |  |  | ⟶ Language=abbreviation, Appearance=Positive |
| 5 | TEXT | ·····ESN | 66 | 8 | 113 | 36 | #135678 |  | “Next SCM” |
| 5 | INSTANCE | ·····Component/Divider | 191 | 10 | 1 | 32 |  |  | ⟶ Placement=Tab/Content, Direction=Vertical |
| 6 | VECTOR | ······Border | 191 | 10 | 0 | 32 |  | #B9BCBB |  |
| 4 | INSTANCE | ····#Pattern/Navigation/Header/Logo | 204 | 10 | 118 | 33 |  |  | ⟶ Language=Korean, Appearance=Positive |
| 5 | TEXT | ·····한글시스템명 | 204 | 10 | 118 | 18 | #135678 |  | “Next-SCM pretask” |
| 5 | TEXT | ·····English System Name | 204 | 24 | 52 | 18 | #6E706F |  | “Next SCM” |
| 2 | FRAME | ··1 Depth Menu | 322 | 0 | 1330 | 52 |  |  |  |
| 3 | INSTANCE | ···#Pattern/Navigation/Header/Top Menu | 568 | 0 | 88 | 52 |  | #2D9BB2 | ⟶ Appearance=Positive, Status=Selected |
| 4 | TEXT | ····타이틀 | 588 | 16 | 48 | 21 | #1F1F1F |  | “Master” |
| 3 | INSTANCE | ···#Pattern/Navigation/Header/Top Menu | 656 | 0 | 98 | 52 |  |  | ⟶ Appearance=Positive, Status=Default |
| 4 | TEXT | ····타이틀 | 676 | 16 | 58 | 21 | #979998 |  | “Demand” |
| 3 | INSTANCE | ···#Pattern/Navigation/Header/Top Menu | 754 | 0 | 89 | 52 |  |  | ⟶ Appearance=Positive, Status=Default |
| 4 | TEXT | ····타이틀 | 774 | 16 | 49 | 21 | #979998 |  | “Supply” |
| 3 | INSTANCE | ···#Pattern/Navigation/Header/Top Menu | 843 | 0 | 93 | 52 |  |  | ⟶ Appearance=Positive, Status=Default |
| 4 | TEXT | ····타이틀 | 863 | 16 | 53 | 21 | #979998 |  | “Factory” |
| 3 | INSTANCE | ···#Pattern/Navigation/Header/Top Menu | 936 | 0 | 101 | 52 |  |  | ⟶ Appearance=Positive, Status=Default |
| 4 | TEXT | ····타이틀 | 956 | 16 | 61 | 21 | #979998 |  | “Shipping” |
| 3 | INSTANCE | ···#Pattern/Navigation/Header/Top Menu | 1037 | 0 | 88 | 52 |  |  | ⟶ Appearance=Positive, Status=Default |
| 4 | TEXT | ····타이틀 | 1057 | 16 | 48 | 21 | #979998 |  | “Report” |
| 3 | INSTANCE | ···#Pattern/Navigation/Header/Top Menu | 1125 | 0 | 106 | 52 |  |  | ⟶ Appearance=Positive, Status=Default |
| 4 | TEXT | ····타이틀 | 1145 | 16 | 66 | 21 | #979998 |  | “Authority” |
| 3 | INSTANCE | ···#Pattern/Navigation/Header/Top Menu | 1231 | 0 | 85 | 52 |  |  | ⟶ Appearance=Positive, Status=Default |
| 4 | TEXT | ····타이틀 | 1251 | 16 | 45 | 21 | #979998 |  | “Admin” |
| 3 | INSTANCE | ···#Pattern/Navigation/Header/Top Menu | 1316 | 0 | 90 | 52 |  |  | ⟶ Appearance=Positive, Status=Default |
| 4 | TEXT | ····타이틀 | 1336 | 16 | 50 | 21 | #979998 |  | “Spread” |
| 2 | FRAME | ··Right Container | 1652 | 0 | 268 | 52 | #F7F9F8 |  |  |
| 3 | INSTANCE | ···Component/Input Group Medium | 1668 | 10 | 296 | 32 |  |  | ⟶ Button=Yes, Units=2 |
| 4 | FRAME | ····앞의 UI 너비조정은 이 Layer를 선택한다음 Autolayout에서  | 1668 | 10 | 100 | 32 |  |  |  |
| 5 | INSTANCE | ·····Component/Dropdown/Dropdown Field | 1668 | 10 | 100 | 32 | #FFFFFF | #B9BCBB | ⟶ Size=Medium, Selection Type=Single Select, Status=Filled |
| 6 | FRAME | ······Inner | 1676 | 16 | 66 | 20 |  |  |  |
| 7 | TEXT | ·······Filled Text | 1676 | 16 | 48 | 20 | #1F1F1F |  | “통합검색” |
| 6 | INSTANCE | ······Icons/Arrow/Chevron2/ | 1750 | 21 | 10 | 10 |  |  | ⟶ Direction=Down, Appearance=Single, Color=Text-Light |
| 7 | VECTOR | ·······Union | 1752 | 25 | 5 | 3 | #5B5C5B |  |  |
| 6 | FRAME | ······Essential | 1668 | 10 | 1 | 32 |  |  |  |
| 7 | VECTOR | ·······Dot | 1670 | 12 | 4 | 4 | #F94B50 |  |  |
| 4 | INSTANCE | ····Component/Input Field/Text | 1768 | 10 | 164 | 32 | #FFFFFF | #B9BCBB | ⟶ Size=Medium, Status=Default, Text Align=Left |
| 5 | FRAME | ·····Inner | 1776 | 14 | 148 | 24 |  |  |  |
| 6 | TEXT | ······입력해주세요. | 1776 | 16 | 141 | 20 | #979998 |  | “검색 키워드를 입력하세요.” |
| 5 | FRAME | ·····Essential | 1768 | 10 | 1 | 32 |  |  |  |
| 6 | VECTOR | ······Dot | 1770 | 12 | 4 | 4 | #F94B50 |  |  |
| 4 | FRAME | ····Button_Container | 2043 | 10 | 32 | 32 | #FFFFFF | #B9BCBB |  |
| 5 | INSTANCE | ·····Component/Button | 2043 | 10 | 32 | 32 |  | #EBEEED | ⟶ Size=Medium, Appearance=Unfilled, Priority=Normal, Status=Default, Icon_Position=Leading |
| 6 | FRAME | ······Inner-Contatiner | 2049 | 16 | 20 | 20 |  |  |  |
| 7 | RECTANGLE | ·······Additional_Padding_For_Text | 2049 | 16 | 2 | 20 |  |  |  |
| 7 | FRAME | ·······Icon-Container | 2049 | 16 | 20 | 20 |  |  |  |
| 8 | INSTANCE | ········Icons/Function/Search/ | 2049 | 16 | 20 | 20 |  |  | ⟶ Appearance=Lined |
| 9 | VECTOR | ·········Union | 2051 | 18 | 17 | 17 | #5B5C5B |  |  |
| 7 | FRAME | ·······Text-Container | 2071 | 16 | 48 | 20 |  |  |  |
| 8 | TEXT | ········Text | 2073 | 16 | 45 | 20 | #5B5C5B |  | “Button” |
| 7 | RECTANGLE | ·······Additional_Padding_For_Text | 2119 | 16 | 2 | 20 |  |  |  |
| 3 | INSTANCE | ···#Pattern/Navigation/Header/Util | 1668 | 14 | 92 | 24 |  |  | ⟶ Mode=Light |
| 4 | FRAME | ····Utility Menus | 1668 | 14 | 88 | 24 |  |  |  |
| 5 | INSTANCE | ·····#Pattern/Navigation/Header/More Menu | 1668 | 14 | 24 | 24 |  |  | ⟶ Appearance=Positive, Status=Default |
| 6 | INSTANCE | ······Icons/Menu/More/ | 1668 | 14 | 24 | 24 |  |  | ⟶ Direction=Horizontal |
| 7 | VECTOR | ·······Union | 1671 | 24 | 18 | 3 | #5B5C5B |  |  |
| 5 | INSTANCE | ·····#Pattern/Navigation/Header/Util Item | 1668 | 14 | 24 | 24 |  |  | ⟶ Status=Default |
| 6 | FRAME | ······Label Container | 1668 | 14 | 24 | 24 |  |  |  |
| 7 | INSTANCE | ·······Icons/Communication/Bookmark/ | 1668 | 14 | 24 | 24 |  |  | ⟶ Appearance=Lined |
| 8 | VECTOR | ········Union | 1670 | 16 | 21 | 20 | #5B5C5B |  |  |
| 7 | TEXT | ·······타이틀 | 1694 | 16 | 35 | 20 | #5B5C5B |  | “Menu” |
| 6 | TEXT | ······Count | 1733 | 16 | 16 | 20 | #2D9BB2 |  | “20” |
| 5 | INSTANCE | ·····#Pattern/Navigation/Header/Util Item | 1700 | 14 | 24 | 24 |  |  | ⟶ Status=Default |
| 6 | FRAME | ······Label Container | 1700 | 14 | 24 | 24 |  |  |  |
| 7 | INSTANCE | ·······Icons/Status/Help/ | 1700 | 14 | 24 | 24 |  |  | ⟶ Appearance=Lined |
| 8 | VECTOR | ········Union | 1702 | 16 | 20 | 20 | #5B5C5B |  |  |
| 7 | TEXT | ·······타이틀 | 1726 | 16 | 35 | 20 | #5B5C5B |  | “Menu” |
| 6 | TEXT | ······Count | 1765 | 16 | 16 | 20 | #2D9BB2 |  | “20” |
| 5 | INSTANCE | ·····#Pattern/Navigation/Header/Util Item | 1732 | 14 | 24 | 24 |  |  | ⟶ Status=Default |
| 6 | FRAME | ······Label Container | 1732 | 14 | 24 | 24 |  |  |  |
| 7 | INSTANCE | ·······Icons/Function/Setting/ | 1732 | 14 | 24 | 24 |  |  | ⟶ Appearance=Lined |
| 8 | VECTOR | ········Union | 1734 | 16 | 20 | 20 | #5B5C5B |  |  |
| 7 | TEXT | ·······타이틀 | 1758 | 16 | 35 | 20 | #5B5C5B |  | “Menu” |
| 6 | TEXT | ······Count | 1797 | 16 | 16 | 20 | #2D9BB2 |  | “20” |
| 3 | INSTANCE | ···#Pattern/Navigation/Header/Toggle | 1768 | 11 | 60 | 30 | #EBEEED | #DDE0DF | ⟶ Mode=Light, Appearance=Positive |
| 4 | INSTANCE | ····Icons/Mode/Light/ | 1776 | 15 | 22 | 22 |  |  | ⟶ Appearance=Lined |
| 5 | VECTOR | ·····Union | 1778 | 17 | 18 | 18 | #5B5C5B |  |  |
| 4 | ELLIPSE | ····Ellipse 413 | 1802 | 15 | 22 | 22 | #FFFFFF |  |  |
| 3 | FRAME | ···Dropdown Group | 1836 | 10 | 61 | 32 |  |  |  |
| 4 | INSTANCE | ····#Pattern/Navigation/Header/Dropdown | 1840 | 14 | 53 | 24 |  |  | ⟶ Style=Light |
| 5 | FRAME | ·····Inner | 1848 | 16 | 27 | 20 |  |  |  |
| 6 | TEXT | ······Text | 1848 | 16 | 27 | 20 | #5B5C5B |  | “ENG” |
| 5 | INSTANCE | ·····Icons/Arrow/Chevron2/ | 1875 | 21 | 10 | 10 |  |  | ⟶ Direction=Down, Appearance=Single, Color=Text-Light |
| 6 | VECTOR | ······Union | 1878 | 25 | 5 | 3 | #5B5C5B |  |  |
| 3 | INSTANCE | ···#Pattern/Navigation/Header/User | 1836 | 14 | 68 | 24 |  |  | ⟶ Appearance=Light |
| 4 | INSTANCE | ····Component/Avatar/Single | 1836 | 14 | 24 | 24 |  |  | ⟶ Size=XSmall, Contents Type=Image, Border=Off |
| 5 | INSTANCE | ·····#Component/Avatar/Single/Contents | 1836 | 14 | 24 | 24 |  |  | ⟶ Appearance=Image, Status=Default, Border=Off |
| 6 | FRAME | ······Inner | 1836 | 14 | 24 | 24 |  |  |  |
| 7 | RECTANGLE | ·······Image | 1836 | 14 | 24 | 24 |  |  |  |
| 5 | INSTANCE | ·····Component/Badge/Status Dot | 1850 | 28 | 14 | 14 | #00806A | #FFFFFF | ⟶ Status=Online |
| 6 | INSTANCE | ······Icons/Control/Confirm/ | 1851 | 29 | 13 | 13 |  |  | ⟶ Size=Default, Color=Text-Light |
| 7 | VECTOR | ·······Union | 1852 | 32 | 10 | 6 | #FFFFFF |  |  |
| 5 | INSTANCE | ·····Component/Badge/Count Badge | 1850 | 8 | 16 | 16 | #F94B50 | #FFFFFF | ⟶ Data=Count, Size=XSmall |
| 6 | TEXT | ······Value | 1854 | 8 | 8 | 17 | #FFFFFF |  | “9” |
| 4 | TEXT | ····타이틀 | 1868 | 16 | 36 | 20 | #5B5C5B |  | “홍길동” |
| 3 | INSTANCE | ···Icons/Menu/Switcher | 1908 | 14 | 24 | 24 |  |  | ⟶ Icons/Menu/Switcher |
| 4 | VECTOR | ····Union | 1911 | 17 | 18 | 18 | #5B5C5B |  |  |
| 1 | FRAME | ·Page Container | 0 | 52 | 1920 | 911 |  |  |  |
| 2 | INSTANCE | ··Pattern/Navigation/Left Menu | 0 | 52 | 230 | 911 | #F7F9F8 |  | ⟶ Tree Extend=Label Only, Header=From_2depth, Folded=Off, Border-Right=Yes |
| 3 | FRAME | ···Inner | 0 | 52 | 230 | 911 | #F7F9F8 | #EBEEED |  |
| 4 | INSTANCE | ····#Pattern/Navigation/Left Menu/Head | 0 | 52 | 230 | 64 | #F7F9F8 | #EBEEED | ⟶ #Pattern/Navigation/Left Menu/Head |
| 5 | FRAME | ·····Inner | 12 | 76 | 188 | 24 |  |  |  |
| 6 | TEXT | ······Normal | 12 | 78 | 188 | 21 | #5B5C5B |  | “Master” |
| 5 | FRAME | ·····Right | 202 | 78 | 20 | 20 |  |  |  |
| 6 | FRAME | ······Setting Button | 202 | 78 | 24 | 24 |  |  |  |
| 7 | INSTANCE | ·······Icons/Function/Setting/ | 204 | 80 | 20 | 20 |  |  | ⟶ Appearance=Lined |
| 8 | VECTOR | ········Union | 206 | 82 | 17 | 17 | #5B5C5B |  |  |
| 4 | INSTANCE | ····#Pattern/Navigation/Left Menu/Filtering | 0 | 116 | 230 | 40 | #F7F9F8 |  | ⟶ Status=Default |
| 5 | INSTANCE | ·····Component/Input Field/Search | 8 | 120 | 214 | 32 | #FFFFFF | #B9BCBB | ⟶ Size=Medium, Usecase=Text Search, Status=Default |
| 6 | FRAME | ······Inner | 36 | 124 | 178 | 24 |  |  |  |
| 7 | TEXT | ·······Placeholder | 36 | 126 | 102 | 20 | #979998 |  | “검색어 입력후 엔터” |
| 6 | INSTANCE | ······#Component/Input Field/Icon_Container | 14 | 126 | 20 | 20 |  |  | ⟶ Status=Default |
| 7 | INSTANCE | ·······Icons/Function/Search/ | 16 | 128 | 16 | 16 |  |  | ⟶ Appearance=Lined |
| 8 | VECTOR | ········Union | 17 | 129 | 13 | 13 | #1F1F1F |  |  |
| 6 | FRAME | ······Essential | 8 | 120 | 1 | 32 |  |  |  |
| 7 | VECTOR | ·······Dot | 10 | 122 | 4 | 4 | #F94B50 |  |  |
| 4 | INSTANCE | ····#Pattern/Navigation/Left Menu/Left-Menu- | 0 | 156 | 230 | 36 |  |  | ⟶ #Pattern/Navigation/Left Menu/Left-Menu-Tab |
| 5 | FRAME | ·····Item | 0 | 156 | 230 | 36 |  |  |  |
| 6 | INSTANCE | ······#Pattern/Navigation/Left Menu/Left-Menu- | 0 | 156 | 116 | 36 |  |  | ⟶ Status=Selected |
| 7 | FRAME | ·······Inner | 28 | 156 | 60 | 36 |  | #2D9BB2 |  |
| 8 | TEXT | ········아이템 | 34 | 164 | 48 | 20 | #2D9BB2 |  | “탭아이템” |
| 8 | TEXT | ········Count | 86 | 162 | 8 | 20 | #1F1F1F |  | “7” |
| 6 | INSTANCE | ······#Pattern/Navigation/Left Menu/Left-Menu- | 114 | 156 | 116 | 36 |  |  | ⟶ Status=Default |
| 7 | FRAME | ·······Inner | 142 | 156 | 60 | 36 |  |  |  |
| 8 | TEXT | ········아이템 | 148 | 164 | 48 | 20 | #5B5C5B |  | “탭아이템” |
| 8 | TEXT | ········Count | 200 | 162 | 8 | 20 | #1F1F1F |  | “7” |
| 4 | FRAME | ····Item Stacked | 0 | 116 | 230 | 474 |  | #EBEEED |  |
| 5 | INSTANCE | ·····#Pattern/Navigation/Left Menu/Menu Item | 0 | 124 | 230 | 40 | #F7F9F8 |  | ⟶ Status=Selected, Depth=01, Fold to Icon=Off, Has Child=Yes, Tree Open=Non Tree |
| 6 | FRAME | ······Updated | 225 | 132 | 1 | 20 |  |  |  |
| 7 | INSTANCE | ·······Icons/Notification Layer | 220 | 132 | 4 | 4 |  |  | ⟶ Out-lined=Default |
| 8 | ELLIPSE | ········notification | 220 | 132 | 4 | 4 | #F94B50 |  |  |
| 6 | FRAME | ······Inner | 14 | 134 | 188 | 20 |  |  |  |
| 7 | INSTANCE | ·······#Pattern/Navigation/Left Menu/Menu Item/ | 14 | 134 | 20 | 20 |  |  | ⟶ #Pattern/Navigation/Left Menu/Menu Item/Icon/1 |
| 8 | INSTANCE | ········Icons/Function/Calendar/ | 16 | 136 | 16 | 16 |  |  | ⟶ Appearance=Lined |
| 9 | VECTOR | ·········Union | 18 | 137 | 12 | 13 | #1F7795 |  |  |
| 7 | TEXT | ·······Selected | 14 | 134 | 188 | 20 | #1F7795 |  | “Demand Master” |
| 6 | FRAME | ······Right | 202 | 134 | 20 | 20 |  |  |  |
| 7 | INSTANCE | ·······Icons/Control/Substract/ | 206 | 138 | 12 | 12 |  |  | ⟶ Size=Small, Color=Text-Light |
| 8 | VECTOR | ········Union | 208 | 144 | 9 | 1 | #5B5C5B |  |  |
| 5 | INSTANCE | ·····#Pattern/Navigation/Left Menu/Menu Item | 0 | 164 | 230 | 34 | #F7F9F8 |  | ⟶ Status=Default, Depth=02, Fold to Icon=Off, Has Child=No, Tree Open=Non Tree |
| 6 | FRAME | ······Updated | 225 | 170 | 1 | 20 |  |  |  |
| 7 | INSTANCE | ·······Icons/Notification Layer | 220 | 170 | 4 | 4 |  |  | ⟶ Out-lined=Default |
| 8 | ELLIPSE | ········notification | 220 | 170 | 4 | 4 | #F94B50 |  |  |
| 6 | FRAME | ······Inner | 36 | 172 | 185 | 18 |  |  |  |
| 7 | TEXT | ·······Normal | 36 | 172 | 185 | 18 | #5B5C5B |  | “Sales Site” |
| 5 | INSTANCE | ·····#Pattern/Navigation/Left Menu/Menu Item | 0 | 198 | 230 | 34 | #F7F9F8 |  | ⟶ Status=Default, Depth=02, Fold to Icon=Off, Has Child=No, Tree Open=Non Tree |
| 6 | FRAME | ······Updated | 225 | 204 | 1 | 20 |  |  |  |
| 7 | INSTANCE | ·······Icons/Notification Layer | 220 | 204 | 4 | 4 |  |  | ⟶ Out-lined=Default |
| 8 | ELLIPSE | ········notification | 220 | 204 | 4 | 4 | #F94B50 |  |  |
| 6 | FRAME | ······Inner | 36 | 206 | 185 | 18 |  |  |  |
| 7 | TEXT | ·······Normal | 36 | 206 | 185 | 18 | #5B5C5B |  | “Sales Site Project Model” |
| 5 | INSTANCE | ·····#Pattern/Navigation/Left Menu/Menu Item | 0 | 232 | 230 | 34 | #F7F9F8 |  | ⟶ Status=Default, Depth=02, Fold to Icon=Off, Has Child=No, Tree Open=Non Tree |
| 6 | FRAME | ······Updated | 225 | 238 | 1 | 20 |  |  |  |
| 7 | INSTANCE | ·······Icons/Notification Layer | 220 | 238 | 4 | 4 |  |  | ⟶ Out-lined=Default |
| 8 | ELLIPSE | ········notification | 220 | 238 | 4 | 4 | #F94B50 |  |  |
| 6 | FRAME | ······Inner | 36 | 240 | 185 | 18 |  |  |  |
| 7 | TEXT | ·······Normal | 36 | 240 | 185 | 18 | #5B5C5B |  | “Customer Model Mapping” |
| 5 | INSTANCE | ·····#Pattern/Navigation/Left Menu/Menu Item | 0 | 266 | 230 | 34 | #F7F9F8 |  | ⟶ Status=Default, Depth=02, Fold to Icon=Off, Has Child=No, Tree Open=Non Tree |
| 6 | FRAME | ······Updated | 225 | 272 | 1 | 20 |  |  |  |
| 7 | INSTANCE | ·······Icons/Notification Layer | 220 | 272 | 4 | 4 |  |  | ⟶ Out-lined=Default |
| 8 | ELLIPSE | ········notification | 220 | 272 | 4 | 4 | #F94B50 |  |  |
| 6 | FRAME | ······Inner | 36 | 274 | 185 | 18 |  |  |  |
| 7 | TEXT | ·······Normal | 36 | 274 | 185 | 18 | #5B5C5B |  | “Customer FCST Master” |
| 5 | INSTANCE | ·····#Pattern/Navigation/Left Menu/Menu Item | 0 | 300 | 230 | 34 | #6E706F |  | ⟶ Status=Selected, Depth=02, Fold to Icon=Off, Has Child=No, Tree Open=Non Tree |
| 6 | FRAME | ······Updated | 225 | 306 | 1 | 20 |  |  |  |
| 7 | INSTANCE | ·······Icons/Notification Layer | 220 | 306 | 4 | 4 |  |  | ⟶ Out-lined=Default |
| 8 | ELLIPSE | ········notification | 220 | 306 | 4 | 4 | #F94B50 |  |  |
| 6 | FRAME | ······Inner | 36 | 308 | 185 | 18 |  |  |  |
| 7 | TEXT | ·······Selected | 36 | 308 | 185 | 18 | #FFFFFF |  | “Sales Price” |
| 5 | INSTANCE | ·····#Pattern/Navigation/Left Menu/Menu Item | 0 | 334 | 230 | 34 | #F7F9F8 |  | ⟶ Status=Default, Depth=02, Fold to Icon=Off, Has Child=No, Tree Open=Non Tree |
| 6 | FRAME | ······Updated | 225 | 340 | 1 | 20 |  |  |  |
| 7 | INSTANCE | ·······Icons/Notification Layer | 220 | 340 | 4 | 4 |  |  | ⟶ Out-lined=Default |
| 8 | ELLIPSE | ········notification | 220 | 340 | 4 | 4 | #F94B50 |  |  |
| 6 | FRAME | ······Inner | 36 | 342 | 185 | 18 |  |  |  |
| 7 | TEXT | ·······Normal | 36 | 342 | 185 | 18 | #5B5C5B |  | “해외법인 기여율 등록” |
| 5 | INSTANCE | ·····#Pattern/Navigation/Left Menu/Menu Item | 0 | 368 | 230 | 34 | #F7F9F8 |  | ⟶ Status=Default, Depth=02, Fold to Icon=Off, Has Child=No, Tree Open=Non Tree |
| 6 | FRAME | ······Updated | 225 | 374 | 1 | 20 |  |  |  |
| 7 | INSTANCE | ·······Icons/Notification Layer | 220 | 374 | 4 | 4 |  |  | ⟶ Out-lined=Default |
| 8 | ELLIPSE | ········notification | 220 | 374 | 4 | 4 | #F94B50 |  |  |
| 6 | FRAME | ······Inner | 36 | 376 | 185 | 18 |  |  |  |
| 7 | TEXT | ·······Normal | 36 | 376 | 185 | 18 | #5B5C5B |  | “해외법인 기여매출” |
| 5 | INSTANCE | ·····#Pattern/Navigation/Left Menu/Menu Item | 0 | 402 | 230 | 34 | #F7F9F8 |  | ⟶ Status=Default, Depth=02, Fold to Icon=Off, Has Child=No, Tree Open=Non Tree |
| 6 | FRAME | ······Updated | 225 | 408 | 1 | 20 |  |  |  |
| 7 | INSTANCE | ·······Icons/Notification Layer | 220 | 408 | 4 | 4 |  |  | ⟶ Out-lined=Default |
| 8 | ELLIPSE | ········notification | 220 | 408 | 4 | 4 | #F94B50 |  |  |
| 6 | FRAME | ······Inner | 36 | 410 | 185 | 18 |  |  |  |
| 7 | TEXT | ·······Normal | 36 | 410 | 185 | 18 | #5B5C5B |  | “ERP EDI MASTER 정비” |
| 5 | INSTANCE | ·····#Pattern/Navigation/Left Menu/Menu Item | 0 | 436 | 230 | 34 | #F7F9F8 |  | ⟶ Status=Default, Depth=02, Fold to Icon=Off, Has Child=No, Tree Open=Non Tree |
| 6 | FRAME | ······Updated | 225 | 442 | 1 | 20 |  |  |  |
| 7 | INSTANCE | ·······Icons/Notification Layer | 220 | 442 | 4 | 4 |  |  | ⟶ Out-lined=Default |
| 8 | ELLIPSE | ········notification | 220 | 442 | 4 | 4 | #F94B50 |  |  |
| 6 | FRAME | ······Inner | 36 | 444 | 185 | 18 |  |  |  |
| 7 | TEXT | ·······Normal | 36 | 444 | 185 | 18 | #5B5C5B |  | “N: N Master Mapping” |
| 5 | INSTANCE | ·····#Pattern/Navigation/Left Menu/Menu Item | 0 | 470 | 230 | 40 | #F7F9F8 |  | ⟶ Status=Default, Depth=01, Fold to Icon=Off, Has Child=Yes, Tree Open=Non Tree |
| 6 | FRAME | ······Updated | 225 | 478 | 1 | 20 |  |  |  |
| 7 | INSTANCE | ·······Icons/Notification Layer | 220 | 478 | 4 | 4 |  |  | ⟶ Out-lined=Default |
| 8 | ELLIPSE | ········notification | 220 | 478 | 4 | 4 | #F94B50 |  |  |
| 6 | FRAME | ······Inner | 14 | 480 | 188 | 20 |  |  |  |
| 7 | INSTANCE | ·······#Pattern/Navigation/Left Menu/Menu Item/ | 14 | 480 | 20 | 20 |  |  | ⟶ #Pattern/Navigation/Left Menu/Menu Item/Icon/1 |
| 8 | INSTANCE | ········Icons/Function/Calendar/ | 16 | 482 | 16 | 16 |  |  | ⟶ Appearance=Lined |
| 9 | VECTOR | ·········Union | 18 | 483 | 12 | 13 | #5B5C5B |  |  |
| 7 | TEXT | ·······Normal | 14 | 480 | 188 | 20 | #1F1F1F |  | “Supply Master” |
| 6 | FRAME | ······Right | 202 | 480 | 20 | 20 |  |  |  |
| 7 | INSTANCE | ·······Icons/Control/Add/ | 206 | 484 | 12 | 12 |  |  | ⟶ Size=Small, Color=Text-Light |
| 8 | VECTOR | ········Union | 208 | 486 | 9 | 9 | #5B5C5B |  |  |
| 5 | INSTANCE | ·····#Pattern/Navigation/Left Menu/Menu Item | 0 | 510 | 230 | 40 | #F7F9F8 |  | ⟶ Status=Default, Depth=01, Fold to Icon=Off, Has Child=Yes, Tree Open=Non Tree |
| 6 | FRAME | ······Updated | 225 | 518 | 1 | 20 |  |  |  |
| 7 | INSTANCE | ·······Icons/Notification Layer | 220 | 518 | 4 | 4 |  |  | ⟶ Out-lined=Default |
| 8 | ELLIPSE | ········notification | 220 | 518 | 4 | 4 | #F94B50 |  |  |
| 6 | FRAME | ······Inner | 14 | 520 | 188 | 20 |  |  |  |
| 7 | INSTANCE | ·······#Pattern/Navigation/Left Menu/Menu Item/ | 14 | 520 | 20 | 20 |  |  | ⟶ #Pattern/Navigation/Left Menu/Menu Item/Icon/1 |
| 8 | INSTANCE | ········Icons/Function/Calendar/ | 16 | 522 | 16 | 16 |  |  | ⟶ Appearance=Lined |
| 9 | VECTOR | ·········Union | 18 | 523 | 12 | 13 | #5B5C5B |  |  |
| 7 | TEXT | ·······Normal | 14 | 520 | 188 | 20 | #1F1F1F |  | “Factory Master” |
| 6 | FRAME | ······Right | 202 | 520 | 20 | 20 |  |  |  |
| 7 | INSTANCE | ·······Icons/Control/Add/ | 206 | 524 | 12 | 12 |  |  | ⟶ Size=Small, Color=Text-Light |
| 8 | VECTOR | ········Union | 208 | 526 | 9 | 9 | #5B5C5B |  |  |
| 5 | INSTANCE | ·····#Pattern/Navigation/Left Menu/Menu Item | 0 | 550 | 230 | 40 | #F7F9F8 |  | ⟶ Status=Default, Depth=01, Fold to Icon=Off, Has Child=Yes, Tree Open=Non Tree |
| 6 | FRAME | ······Updated | 225 | 558 | 1 | 20 |  |  |  |
| 7 | INSTANCE | ·······Icons/Notification Layer | 220 | 558 | 4 | 4 |  |  | ⟶ Out-lined=Default |
| 8 | ELLIPSE | ········notification | 220 | 558 | 4 | 4 | #F94B50 |  |  |
| 6 | FRAME | ······Inner | 14 | 560 | 188 | 20 |  |  |  |
| 7 | INSTANCE | ·······#Pattern/Navigation/Left Menu/Menu Item/ | 14 | 560 | 20 | 20 |  |  | ⟶ #Pattern/Navigation/Left Menu/Menu Item/Icon/1 |
| 8 | INSTANCE | ········Icons/Function/Calendar/ | 16 | 562 | 16 | 16 |  |  | ⟶ Appearance=Lined |
| 9 | VECTOR | ·········Union | 18 | 563 | 12 | 13 | #5B5C5B |  |  |
| 7 | TEXT | ·······Normal | 14 | 560 | 188 | 20 | #1F1F1F |  | “Shipping Master” |
| 6 | FRAME | ······Right | 202 | 560 | 20 | 20 |  |  |  |
| 7 | INSTANCE | ·······Icons/Control/Add/ | 206 | 564 | 12 | 12 |  |  | ⟶ Size=Small, Color=Text-Light |
| 8 | VECTOR | ········Union | 208 | 566 | 9 | 9 | #5B5C5B |  |  |
| 5 | INSTANCE | ·····#Pattern/Navigation/Left Menu/Menu Item | 0 | 590 | 230 | 40 | #F7F9F8 |  | ⟶ Status=Default, Depth=01, Fold to Icon=Off, Has Child=Yes, Tree Open=Non Tree |
| 6 | FRAME | ······Updated | 225 | 598 | 1 | 20 |  |  |  |
| 7 | INSTANCE | ·······Icons/Notification Layer | 220 | 598 | 4 | 4 |  |  | ⟶ Out-lined=Default |
| 8 | ELLIPSE | ········notification | 220 | 598 | 4 | 4 | #F94B50 |  |  |
| 6 | FRAME | ······Inner | 14 | 600 | 188 | 20 |  |  |  |
| 7 | INSTANCE | ·······#Pattern/Navigation/Left Menu/Menu Item/ | 14 | 600 | 20 | 20 |  |  | ⟶ #Pattern/Navigation/Left Menu/Menu Item/Icon/1 |
| 8 | INSTANCE | ········Icons/Function/Calendar/ | 16 | 602 | 16 | 16 |  |  | ⟶ Appearance=Lined |
| 9 | VECTOR | ·········Union | 18 | 603 | 12 | 13 | #5B5C5B |  |  |
| 7 | TEXT | ·······Normal | 14 | 600 | 188 | 20 | #1F1F1F |  | “Menu Text” |
| 6 | FRAME | ······Right | 202 | 600 | 20 | 20 |  |  |  |
| 7 | INSTANCE | ·······Icons/Control/Add/ | 206 | 604 | 12 | 12 |  |  | ⟶ Size=Small, Color=Text-Light |
| 8 | VECTOR | ········Union | 208 | 606 | 9 | 9 | #5B5C5B |  |  |
| 5 | INSTANCE | ·····#Pattern/Navigation/Left Menu/Menu Item | 0 | 630 | 230 | 40 | #F7F9F8 |  | ⟶ Status=Default, Depth=01, Fold to Icon=Off, Has Child=Yes, Tree Open=Non Tree |
| 6 | FRAME | ······Updated | 225 | 638 | 1 | 20 |  |  |  |
| 7 | INSTANCE | ·······Icons/Notification Layer | 220 | 638 | 4 | 4 |  |  | ⟶ Out-lined=Default |
| 8 | ELLIPSE | ········notification | 220 | 638 | 4 | 4 | #F94B50 |  |  |
| 6 | FRAME | ······Inner | 14 | 640 | 188 | 20 |  |  |  |
| 7 | INSTANCE | ·······#Pattern/Navigation/Left Menu/Menu Item/ | 14 | 640 | 20 | 20 |  |  | ⟶ #Pattern/Navigation/Left Menu/Menu Item/Icon/1 |
| 8 | INSTANCE | ········Icons/Function/Calendar/ | 16 | 642 | 16 | 16 |  |  | ⟶ Appearance=Lined |
| 9 | VECTOR | ·········Union | 18 | 643 | 12 | 13 | #5B5C5B |  |  |
| 7 | TEXT | ·······Normal | 14 | 640 | 188 | 20 | #1F1F1F |  | “Menu Text” |
| 6 | FRAME | ······Right | 202 | 640 | 20 | 20 |  |  |  |
| 7 | INSTANCE | ·······Icons/Control/Add/ | 206 | 644 | 12 | 12 |  |  | ⟶ Size=Small, Color=Text-Light |
| 8 | VECTOR | ········Union | 208 | 646 | 9 | 9 | #5B5C5B |  |  |
| 5 | INSTANCE | ·····#Pattern/Navigation/Left Menu/Menu Item | 0 | 670 | 230 | 40 | #F7F9F8 |  | ⟶ Status=Default, Depth=01, Fold to Icon=Off, Has Child=Yes, Tree Open=Non Tree |
| 6 | FRAME | ······Updated | 225 | 678 | 1 | 20 |  |  |  |
| 7 | INSTANCE | ·······Icons/Notification Layer | 220 | 678 | 4 | 4 |  |  | ⟶ Out-lined=Default |
| 8 | ELLIPSE | ········notification | 220 | 678 | 4 | 4 | #F94B50 |  |  |
| 6 | FRAME | ······Inner | 14 | 680 | 188 | 20 |  |  |  |
| 7 | INSTANCE | ·······#Pattern/Navigation/Left Menu/Menu Item/ | 14 | 680 | 20 | 20 |  |  | ⟶ #Pattern/Navigation/Left Menu/Menu Item/Icon/1 |
| 8 | INSTANCE | ········Icons/Function/Calendar/ | 16 | 682 | 16 | 16 |  |  | ⟶ Appearance=Lined |
| 9 | VECTOR | ·········Union | 18 | 683 | 12 | 13 | #5B5C5B |  |  |
| 7 | TEXT | ·······Normal | 14 | 680 | 188 | 20 | #1F1F1F |  | “Menu Text” |
| 6 | FRAME | ······Right | 202 | 680 | 20 | 20 |  |  |  |
| 7 | INSTANCE | ·······Icons/Control/Add/ | 206 | 684 | 12 | 12 |  |  | ⟶ Size=Small, Color=Text-Light |
| 8 | VECTOR | ········Union | 208 | 686 | 9 | 9 | #5B5C5B |  |  |
| 5 | INSTANCE | ·····#Pattern/Navigation/Left Menu/Menu Item | 0 | 710 | 230 | 40 | #F7F9F8 |  | ⟶ Status=Default, Depth=01, Fold to Icon=Off, Has Child=Yes, Tree Open=Non Tree |
| 6 | FRAME | ······Updated | 225 | 718 | 1 | 20 |  |  |  |
| 7 | INSTANCE | ·······Icons/Notification Layer | 220 | 718 | 4 | 4 |  |  | ⟶ Out-lined=Default |
| 8 | ELLIPSE | ········notification | 220 | 718 | 4 | 4 | #F94B50 |  |  |
| 6 | FRAME | ······Inner | 14 | 720 | 188 | 20 |  |  |  |
| 7 | INSTANCE | ·······#Pattern/Navigation/Left Menu/Menu Item/ | 14 | 720 | 20 | 20 |  |  | ⟶ #Pattern/Navigation/Left Menu/Menu Item/Icon/1 |
| 8 | INSTANCE | ········Icons/Function/Calendar/ | 16 | 722 | 16 | 16 |  |  | ⟶ Appearance=Lined |
| 9 | VECTOR | ·········Union | 18 | 723 | 12 | 13 | #5B5C5B |  |  |
| 7 | TEXT | ·······Normal | 14 | 720 | 188 | 20 | #1F1F1F |  | “Menu Text” |
| 6 | FRAME | ······Right | 202 | 720 | 20 | 20 |  |  |  |
| 7 | INSTANCE | ·······Icons/Control/Add/ | 206 | 724 | 12 | 12 |  |  | ⟶ Size=Small, Color=Text-Light |
| 8 | VECTOR | ········Union | 208 | 726 | 9 | 9 | #5B5C5B |  |  |
| 3 | INSTANCE | ···#Others/Scroll-Thin/Vertical | 220 | 164 | 6 | 200 |  |  | ⟶ #Others/Scroll-Thin/Vertical |
| 4 | RECTANGLE | ····box | 220 | 164 | 6 | 200 | #3C3E3D |  |  |
| 3 | INSTANCE | ···Component/Handle | 224 | 476 | 12 | 64 | #FFFFFF | #B9BCBB | ⟶ Status=Default, Direction=to Right |
| 4 | VECTOR | ····Polygon 2 | 228 | 505 | 4 | 6 | #979998 |  |  |
| 2 | FRAME | ··Page Container | 230 | 52 | 1690 | 911 |  |  |  |
| 3 | INSTANCE | ···Pattern/Navigation/MDI Container | 230 | 52 | 1690 | 32 |  | #EBEEED | ⟶ Pattern/Navigation/MDI Container |
| 4 | FRAME | ····Units | 230 | 52 | 1690 | 32 | #F7F9F8 |  |  |
| 5 | FRAME | ·····Item | 230 | 52 | 172 | 32 |  |  |  |
| 6 | INSTANCE | ······#Pattern/Navigation/MDI Container/Tab It | 230 | 52 | 60 | 32 | #F7F9F8 | #F1F4F3 | ⟶ Status=Default |
| 7 | FRAME | ·······Inner | 230 | 52 | 36 | 32 |  |  |  |
| 8 | TEXT | ········아이템 | 242 | 59 | 12 | 18 | #979998 |  | “홈” |
| 7 | FRAME | ·······Close Button | 266 | 60 | 16 | 16 |  |  |  |
| 8 | INSTANCE | ········Icons/Control/Close/ | 266 | 60 | 16 | 16 |  |  | ⟶ Size=Small, Color=Text-Light |
| 9 | VECTOR | ·········Union | 269 | 63 | 9 | 9 | #979998 |  |  |
| 6 | INSTANCE | ······#Pattern/Navigation/MDI Container/Tab It | 290 | 52 | 101 | 32 | #F7F9F8 | #F1F4F3 | ⟶ Status=Default |
| 7 | FRAME | ·······Inner | 290 | 52 | 69 | 32 |  |  |  |
| 8 | TEXT | ········아이템 | 302 | 59 | 45 | 18 | #979998 |  | “탭아이템” |
| 7 | FRAME | ·······Close Button | 359 | 60 | 16 | 16 |  |  |  |
| 8 | INSTANCE | ········Icons/Control/Close/ | 359 | 60 | 16 | 16 |  |  | ⟶ Size=Small, Color=Text-Light |
| 9 | VECTOR | ·········Union | 362 | 63 | 9 | 9 | #979998 |  |  |
| 6 | INSTANCE | ······#Pattern/Navigation/MDI Container/Tab It | 290 | 52 | 112 | 32 | #FFFFFF | #F1F4F3 | ⟶ Status=Selected |
| 7 | FRAME | ·······Inner | 290 | 52 | 88 | 32 |  |  |  |
| 8 | TEXT | ········아이템 | 302 | 59 | 64 | 18 | #1F1F1F |  | “Sales Price” |
| 7 | FRAME | ·······Close Button | 378 | 60 | 16 | 16 |  |  |  |
| 8 | INSTANCE | ········Icons/Control/Close/ | 378 | 60 | 16 | 16 |  |  | ⟶ Size=Small, Color=Text-Light |
| 9 | VECTOR | ·········Union | 381 | 63 | 9 | 9 | #5B5C5B |  |  |
| 6 | INSTANCE | ······#Pattern/Navigation/MDI Container/Tab It | 354 | 52 | 101 | 32 | #F7F9F8 | #F1F4F3 | ⟶ Status=Default |
| 7 | FRAME | ·······Inner | 354 | 52 | 69 | 32 |  |  |  |
| 8 | TEXT | ········아이템 | 366 | 59 | 45 | 18 | #979998 |  | “탭아이템” |
| 7 | FRAME | ·······Close Button | 423 | 60 | 16 | 16 |  |  |  |
| 8 | INSTANCE | ········Icons/Control/Close/ | 423 | 60 | 16 | 16 |  |  | ⟶ Size=Small, Color=Text-Light |
| 9 | VECTOR | ·········Union | 426 | 63 | 9 | 9 | #979998 |  |  |
| 6 | INSTANCE | ······#Pattern/Navigation/MDI Container/Tab It | 354 | 52 | 101 | 32 | #F7F9F8 | #F1F4F3 | ⟶ Status=Default |
| 7 | FRAME | ·······Inner | 354 | 52 | 69 | 32 |  |  |  |
| 8 | TEXT | ········아이템 | 366 | 59 | 45 | 18 | #979998 |  | “탭아이템” |
| 7 | FRAME | ·······Close Button | 423 | 60 | 16 | 16 |  |  |  |
| 8 | INSTANCE | ········Icons/Control/Close/ | 423 | 60 | 16 | 16 |  |  | ⟶ Size=Small, Color=Text-Light |
| 9 | VECTOR | ·········Union | 426 | 63 | 9 | 9 | #979998 |  |  |
| 6 | INSTANCE | ······#Pattern/Navigation/MDI Container/Tab It | 354 | 52 | 101 | 32 | #F7F9F8 | #F1F4F3 | ⟶ Status=Default |
| 7 | FRAME | ·······Inner | 354 | 52 | 69 | 32 |  |  |  |
| 8 | TEXT | ········아이템 | 366 | 59 | 45 | 18 | #979998 |  | “탭아이템” |
| 7 | FRAME | ·······Close Button | 423 | 60 | 16 | 16 |  |  |  |
| 8 | INSTANCE | ········Icons/Control/Close/ | 423 | 60 | 16 | 16 |  |  | ⟶ Size=Small, Color=Text-Light |
| 9 | VECTOR | ·········Union | 426 | 63 | 9 | 9 | #979998 |  |  |
| 6 | INSTANCE | ······#Pattern/Navigation/MDI Container/Tab It | 785 | 52 | 93 | 32 | #F7F9F8 | #F1F4F3 | ⟶ Status=Default |
| 7 | FRAME | ·······Inner | 785 | 52 | 69 | 32 |  |  |  |
| 8 | TEXT | ········아이템 | 797 | 59 | 45 | 18 | #979998 |  | “탭아이템” |
| 7 | FRAME | ·······Close Button | 854 | 60 | 16 | 16 |  |  |  |
| 8 | INSTANCE | ········Icons/Control/Close/ | 854 | 60 | 16 | 16 |  |  | ⟶ Size=Small, Color=Text-Light |
| 9 | VECTOR | ·········Union | 857 | 63 | 9 | 9 | #979998 |  |  |
| 6 | INSTANCE | ······#Pattern/Navigation/MDI Container/Tab It | 878 | 52 | 93 | 32 | #F7F9F8 | #F1F4F3 | ⟶ Status=Default |
| 7 | FRAME | ·······Inner | 878 | 52 | 69 | 32 |  |  |  |
| 8 | TEXT | ········아이템 | 890 | 59 | 45 | 18 | #979998 |  | “탭아이템” |
| 7 | FRAME | ·······Close Button | 947 | 60 | 16 | 16 |  |  |  |
| 8 | INSTANCE | ········Icons/Control/Close/ | 947 | 60 | 16 | 16 |  |  | ⟶ Size=Small, Color=Text-Light |
| 9 | VECTOR | ·········Union | 950 | 63 | 9 | 9 | #979998 |  |  |
| 6 | INSTANCE | ······#Pattern/Navigation/MDI Container/Tab It | 971 | 52 | 93 | 32 | #F7F9F8 | #F1F4F3 | ⟶ Status=Default |
| 7 | FRAME | ·······Inner | 971 | 52 | 69 | 32 |  |  |  |
| 8 | TEXT | ········아이템 | 983 | 59 | 45 | 18 | #979998 |  | “탭아이템” |
| 7 | FRAME | ·······Close Button | 1040 | 60 | 16 | 16 |  |  |  |
| 8 | INSTANCE | ········Icons/Control/Close/ | 1040 | 60 | 16 | 16 |  |  | ⟶ Size=Small, Color=Text-Light |
| 9 | VECTOR | ·········Union | 1043 | 63 | 9 | 9 | #979998 |  |  |
| 6 | INSTANCE | ······#Pattern/Navigation/MDI Container/Tab It | 1064 | 52 | 93 | 32 | #F7F9F8 | #F1F4F3 | ⟶ Status=Default |
| 7 | FRAME | ·······Inner | 1064 | 52 | 69 | 32 |  |  |  |
| 8 | TEXT | ········아이템 | 1076 | 59 | 45 | 18 | #979998 |  | “탭아이템” |
| 7 | FRAME | ·······Close Button | 1133 | 60 | 16 | 16 |  |  |  |
| 8 | INSTANCE | ········Icons/Control/Close/ | 1133 | 60 | 16 | 16 |  |  | ⟶ Size=Small, Color=Text-Light |
| 9 | VECTOR | ·········Union | 1136 | 63 | 9 | 9 | #979998 |  |  |
| 6 | INSTANCE | ······#Pattern/Navigation/MDI Container/Tab It | 1157 | 52 | 93 | 32 | #F7F9F8 | #F1F4F3 | ⟶ Status=Default |
| 7 | FRAME | ·······Inner | 1157 | 52 | 69 | 32 |  |  |  |
| 8 | TEXT | ········아이템 | 1169 | 59 | 45 | 18 | #979998 |  | “탭아이템” |
| 7 | FRAME | ·······Close Button | 1226 | 60 | 16 | 16 |  |  |  |
| 8 | INSTANCE | ········Icons/Control/Close/ | 1226 | 60 | 16 | 16 |  |  | ⟶ Size=Small, Color=Text-Light |
| 9 | VECTOR | ·········Union | 1229 | 63 | 9 | 9 | #979998 |  |  |
| 5 | FRAME | ·····Controls | 1820 | 56 | 96 | 24 |  |  |  |
| 6 | INSTANCE | ······#Pattern/Navigation/MDI Container/Contro | 1820 | 56 | 24 | 24 | #F7F9F8 |  | ⟶ Function=Prev, Status=Default |
| 7 | INSTANCE | ·······Icons/Arrow/Chevron2/ | 1824 | 60 | 16 | 16 |  |  | ⟶ Direction=Left, Appearance=Single, Color=Text-Light |
| 8 | VECTOR | ········Union | 1829 | 64 | 5 | 8 | #5B5C5B |  |  |
| 6 | INSTANCE | ······#Pattern/Navigation/MDI Container/Contro | 1844 | 56 | 24 | 24 | #F7F9F8 |  | ⟶ Function=Next, Status=Default |
| 7 | INSTANCE | ·······Icons/Arrow/Chevron2/ | 1848 | 60 | 16 | 16 |  |  | ⟶ Direction=Right, Appearance=Single, Color=Text-Light |
| 8 | VECTOR | ········Union | 1854 | 64 | 5 | 8 | #5B5C5B |  |  |
| 6 | INSTANCE | ······#Pattern/Navigation/MDI Container/Contro | 1868 | 56 | 24 | 24 | #F7F9F8 |  | ⟶ Function=New Window, Status=Default |
| 7 | INSTANCE | ·······Icons/File/External-Link/ | 1872 | 60 | 16 | 16 |  |  | ⟶ Appearance=Lined |
| 8 | VECTOR | ········Union | 1874 | 61 | 13 | 13 | #5B5C5B |  |  |
| 6 | INSTANCE | ······#Pattern/Navigation/MDI Container/Contro | 1892 | 56 | 24 | 24 | #F7F9F8 |  | ⟶ Function=Close All, Status=Default |
| 7 | INSTANCE | ·······Icons/Control/Close/ | 1896 | 60 | 16 | 16 |  |  | ⟶ Size=Small, Color=Text-Light |
| 8 | VECTOR | ········Union | 1899 | 63 | 9 | 9 | #5B5C5B |  |  |
| 3 | FRAME | ···Contents | 230 | 84 | 1690 | 879 | #FFFFFF |  |  |
| 4 | INSTANCE | ····Component/Title/Page Title | 262 | 84 | 1626 | 48 | #FFFFFF |  | ⟶ Right Buttons=Off, Background=Yes |
| 5 | FRAME | ·····Left Container | 262 | 96 | 124 | 32 |  |  |  |
| 6 | INSTANCE | ······#Component/Title/Page Title/Bookmark | 262 | 100 | 24 | 24 |  |  | ⟶ Bookmark=Off, Status=Default |
| 7 | INSTANCE | ·······Icons/Communication/Bookmark/ | 264 | 102 | 20 | 20 |  |  | ⟶ Appearance=Lined |
| 8 | VECTOR | ········Union | 265 | 104 | 17 | 17 | #5B5C5B |  |  |
| 6 | FRAME | ······Bullet Container | 290 | 104 | 12 | 8 |  |  |  |
| 7 | ELLIPSE | ·······Bullet | 290 | 104 | 8 | 8 | #2D9BB2 |  |  |
| 6 | TEXT | ······H2 | 290 | 100 | 96 | 23 | #1F1F1F |  | “Sales Price” |
| 5 | FRAME | ·····Right Container | 1543 | 96 | 345 | 32 |  |  |  |
| 6 | INSTANCE | ······Component/Breadcrumb | 1543 | 103 | 233 | 18 |  |  | ⟶ Depth=3Depth |
| 7 | INSTANCE | ·······#Component/Breadcrumb/Item | 1543 | 103 | 44 | 18 |  |  | ⟶ Depth=Parent |
| 8 | TEXT | ········Label | 1546 | 103 | 38 | 18 | #2D9BB2 |  | “Master” |
| 7 | FRAME | ·······Frame 68 | 1587 | 106 | 12 | 12 |  |  |  |
| 8 | RECTANGLE | ········Padding | 1587 | 106 | 12 | 1 | #C4C4C4 |  |  |
| 8 | INSTANCE | ········Icons/Arrow/Chevron/ | 1587 | 106 | 12 | 12 |  |  | ⟶ Direction=Right, Appearance=Single, Color=Text-Light |
| 9 | VECTOR | ·········Union | 1591 | 107 | 4 | 10 | #5B5C5B |  |  |
| 7 | INSTANCE | ·······#Component/Breadcrumb/Item | 1595 | 103 | 70 | 18 |  |  | ⟶ Depth=Parent |
| 8 | TEXT | ········Label | 1598 | 103 | 36 | 18 | #2D9BB2 |  | “설계변경” |
| 7 | FRAME | ·······Frame 68 | 1665 | 106 | 12 | 12 |  |  |  |
| 8 | RECTANGLE | ········Padding | 1665 | 106 | 12 | 1 | #C4C4C4 |  |  |
| 8 | INSTANCE | ········Icons/Arrow/Chevron/ | 1665 | 106 | 12 | 12 |  |  | ⟶ Direction=Right, Appearance=Single, Color=Text-Light |
| 9 | VECTOR | ·········Union | 1669 | 107 | 4 | 10 | #5B5C5B |  |  |
| 7 | INSTANCE | ·······#Component/Breadcrumb/Item | 1599 | 103 | 95 | 18 |  |  | ⟶ Depth=Parent |
| 8 | TEXT | ········Label | 1602 | 103 | 89 | 18 | #2D9BB2 |  | “Demand Master” |
| 7 | FRAME | ·······Frame 68 | 1694 | 106 | 12 | 12 |  |  |  |
| 8 | RECTANGLE | ········Padding | 1694 | 106 | 12 | 1 | #C4C4C4 |  |  |
| 8 | INSTANCE | ········Icons/Arrow/Chevron/ | 1694 | 106 | 12 | 12 |  |  | ⟶ Direction=Right, Appearance=Single, Color=Text-Light |
| 9 | VECTOR | ·········Union | 1698 | 107 | 4 | 10 | #5B5C5B |  |  |
| 7 | INSTANCE | ·······#Component/Breadcrumb/Item | 1706 | 103 | 70 | 18 |  |  | ⟶ Depth=Current |
| 8 | TEXT | ········Label | 1709 | 103 | 64 | 18 | #2D9BB2 |  | “Sales Price” |
| 6 | FRAME | ······Component/Switch Button | 1788 | 96 | 100 | 32 | #FFFFFF | #DDE0DF |  |
| 7 | INSTANCE | ·······Component/Switch Label | 1796 | 102 | 84 | 20 |  |  | ⟶ Color=Primary, On/Off=ON, Status=Default |
| 8 | TEXT | ········Text | 1796 | 102 | 48 | 20 | #1F1F1F |  | “조회영역” |
| 8 | INSTANCE | ········Component/Switch Only | 1848 | 103 | 32 | 18 |  |  | ⟶ Color=Default, On/Off=ON, Status=Default |
| 9 | RECTANGLE | ·········Rectangle | 1848 | 106 | 32 | 12 | #2D9BB2 |  |  |
| 9 | VECTOR | ·········icon check | 1852 | 109 | 8 | 6 | #FFFFFF |  |  |
| 9 | VECTOR | ·········knob | 1862 | 103 | 18 | 18 | #FFFFFF | #2D9BB2 |  |
| 4 | FRAME | ····Component/Search Area | 262 | 132 | 1626 | 137 | #F7F9F8 | #DDE0DF |  |
| 5 | FRAME | ·····top | 278 | 140 | 1594 | 72 |  |  |  |
| 6 | FRAME | ······Search Form Container_Bottom | 278 | 140 | 1449 | 72 |  |  |  |
| 7 | FRAME | ·······Row | 278 | 140 | 1449 | 32 |  |  |  |
| 8 | FRAME | ········Inner | 278 | 140 | 344 | 32 |  |  |  |
| 9 | INSTANCE | ·········Component/Label | 278 | 140 | 120 | 32 |  |  | ⟶ Required=On, Depth=Default, Text Align=Right |
| 10 | FRAME | ··········Essential | 373 | 147 | 1 | 18 |  |  |  |
| 11 | VECTOR | ···········Dot | 369 | 150 | 4 | 4 | #F94B50 |  |  |
| 10 | TEXT | ··········Label | 374 | 146 | 24 | 20 | #1F1F1F |  | “Div.” |
| 10 | FRAME | ··········Info | 315 | 140 | 20 | 20 |  |  |  |
| 11 | INSTANCE | ···········Icons/Status/Info/ | 317 | 142 | 18 | 18 |  |  | ⟶ Appearance=Lined |
| 12 | VECTOR | ············Union | 318 | 144 | 15 | 15 | #5B5C5B |  |  |
| 9 | INSTANCE | ·········Spacing/Role | 398 | 140 | 8 | 32 |  |  | ⟶ Role=Module+Module, Direction=Height, Visibillity=No |
| 10 | INSTANCE | ··········Spacing/Global | 398 | 140 | 8 | 12 |  |  | ⟶ Direction=Height, Size=Small, Visibillity=No |
| 9 | INSTANCE | ·········Component/Dropdown/Dropdown Field | 406 | 140 | 216 | 32 | #FFFFFF | #B9BCBB | ⟶ Size=Medium, Selection Type=Single Select, Status=Filled |
| 10 | FRAME | ··········Inner | 414 | 146 | 182 | 20 |  |  |  |
| 11 | TEXT | ···········Filled Text | 414 | 146 | 66 | 20 | #1F1F1F |  | “40 Division” |
| 10 | INSTANCE | ··········Icons/Arrow/Chevron2/ | 604 | 151 | 10 | 10 |  |  | ⟶ Direction=Down, Appearance=Single, Color=Text-Light |
| 11 | VECTOR | ···········Union | 606 | 155 | 5 | 3 | #5B5C5B |  |  |
| 10 | FRAME | ··········Essential | 406 | 140 | 1 | 32 |  |  |  |
| 11 | VECTOR | ···········Dot | 408 | 142 | 4 | 4 | #F94B50 |  |  |
| 8 | INSTANCE | ········Spacing/Role | 622 | 140 | 24 | 32 |  |  | ⟶ Role=Form Item+Form Item, Direction=Width, Visibillity=No |
| 9 | INSTANCE | ·········Spacing/Global | 622 | 140 | 24 | 32 |  |  | ⟶ Direction=Width, Size=XLarge, Visibillity=Yes |
| 8 | FRAME | ········Inner | 646 | 140 | 344 | 32 |  |  |  |
| 9 | INSTANCE | ·········Component/Label | 646 | 140 | 120 | 32 |  |  | ⟶ Required=On, Depth=Default, Text Align=Right |
| 10 | FRAME | ··········Essential | 729 | 147 | 1 | 18 |  |  |  |
| 11 | VECTOR | ···········Dot | 725 | 150 | 4 | 4 | #F94B50 |  |  |
| 10 | TEXT | ··········Label | 730 | 146 | 36 | 20 | #1F1F1F |  | “Team” |
| 10 | FRAME | ··········Info | 683 | 140 | 20 | 20 |  |  |  |
| 11 | INSTANCE | ···········Icons/Status/Info/ | 685 | 142 | 18 | 18 |  |  | ⟶ Appearance=Lined |
| 12 | VECTOR | ············Union | 687 | 144 | 15 | 15 | #5B5C5B |  |  |
| 9 | INSTANCE | ·········Spacing/Role | 766 | 140 | 8 | 32 |  |  | ⟶ Role=Module+Module, Direction=Height, Visibillity=No |
| 10 | INSTANCE | ··········Spacing/Global | 766 | 140 | 8 | 12 |  |  | ⟶ Direction=Height, Size=Small, Visibillity=No |
| 9 | INSTANCE | ·········Component/Dropdown/Dropdown Field | 774 | 140 | 180 | 32 | #FFFFFF | #B9BCBB | ⟶ Size=Medium, Selection Type=Single Select, Status=Filled |
| 10 | FRAME | ··········Inner | 782 | 146 | 146 | 20 |  |  |  |
| 11 | TEXT | ···········Filled Text | 782 | 146 | 22 | 20 | #1F1F1F |  | “ALL” |
| 10 | INSTANCE | ··········Icons/Arrow/Chevron2/ | 936 | 151 | 10 | 10 |  |  | ⟶ Direction=Down, Appearance=Single, Color=Text-Light |
| 11 | VECTOR | ···········Union | 939 | 155 | 5 | 3 | #5B5C5B |  |  |
| 10 | FRAME | ··········Essential | 774 | 140 | 1 | 32 |  |  |  |
| 11 | VECTOR | ···········Dot | 776 | 142 | 4 | 4 | #F94B50 |  |  |
| 8 | INSTANCE | ········Spacing/Role | 990 | 140 | 24 | 32 |  |  | ⟶ Role=Form Item+Form Item, Direction=Width, Visibillity=No |
| 9 | INSTANCE | ·········Spacing/Global | 990 | 140 | 24 | 32 |  |  | ⟶ Direction=Width, Size=XLarge, Visibillity=Yes |
| 8 | FRAME | ········Inner | 1014 | 140 | 344 | 32 |  |  |  |
| 9 | INSTANCE | ·········Component/Label | 1014 | 140 | 120 | 32 |  |  | ⟶ Required=On, Depth=Default, Text Align=Right |
| 10 | FRAME | ··········Essential | 1042 | 147 | 1 | 18 |  |  |  |
| 11 | VECTOR | ···········Dot | 1038 | 150 | 4 | 4 | #F94B50 |  |  |
| 10 | TEXT | ··········Label | 1044 | 146 | 91 | 20 | #1F1F1F |  | “End Customer” |
| 10 | FRAME | ··········Info | 1052 | 140 | 20 | 20 |  |  |  |
| 11 | INSTANCE | ···········Icons/Status/Info/ | 1054 | 142 | 18 | 18 |  |  | ⟶ Appearance=Lined |
| 12 | VECTOR | ············Union | 1055 | 144 | 15 | 15 | #5B5C5B |  |  |
| 9 | INSTANCE | ·········Spacing/Role | 1134 | 140 | 8 | 32 |  |  | ⟶ Role=Module+Module, Direction=Height, Visibillity=No |
| 10 | INSTANCE | ··········Spacing/Global | 1134 | 140 | 8 | 12 |  |  | ⟶ Direction=Height, Size=Small, Visibillity=No |
| 9 | INSTANCE | ·········Component/Dropdown/Dropdown Field | 1142 | 140 | 216 | 32 | #FFFFFF | #B9BCBB | ⟶ Size=Medium, Selection Type=Single Select, Status=Filled |
| 10 | FRAME | ··········Inner | 1150 | 146 | 182 | 20 |  |  |  |
| 11 | TEXT | ···········Filled Text | 1150 | 146 | 22 | 20 | #1F1F1F |  | “ALL” |
| 10 | INSTANCE | ··········Icons/Arrow/Chevron2/ | 1340 | 151 | 10 | 10 |  |  | ⟶ Direction=Down, Appearance=Single, Color=Text-Light |
| 11 | VECTOR | ···········Union | 1343 | 155 | 5 | 3 | #5B5C5B |  |  |
| 10 | FRAME | ··········Essential | 1142 | 140 | 1 | 32 |  |  |  |
| 11 | VECTOR | ···········Dot | 1144 | 142 | 4 | 4 | #F94B50 |  |  |
| 8 | INSTANCE | ········Spacing/Role | 1359 | 140 | 24 | 32 |  |  | ⟶ Role=Form Item+Form Item, Direction=Width, Visibillity=No |
| 9 | INSTANCE | ·········Spacing/Global | 1359 | 140 | 24 | 32 |  |  | ⟶ Direction=Width, Size=XLarge, Visibillity=Yes |
| 8 | FRAME | ········Inner | 1383 | 140 | 344 | 32 |  |  |  |
| 9 | INSTANCE | ·········Component/Label | 1383 | 140 | 120 | 32 |  |  | ⟶ Required=On, Depth=Default, Text Align=Right |
| 10 | FRAME | ··········Essential | 1440 | 147 | 1 | 18 |  |  |  |
| 11 | VECTOR | ···········Dot | 1436 | 150 | 4 | 4 | #F94B50 |  |  |
| 10 | TEXT | ··········Label | 1441 | 146 | 62 | 20 | #1F1F1F |  | “Sales Site” |
| 10 | FRAME | ··········Info | 1420 | 140 | 20 | 20 |  |  |  |
| 11 | INSTANCE | ···········Icons/Status/Info/ | 1422 | 142 | 18 | 18 |  |  | ⟶ Appearance=Lined |
| 12 | VECTOR | ············Union | 1423 | 144 | 15 | 15 | #5B5C5B |  |  |
| 9 | INSTANCE | ·········Spacing/Role | 1503 | 140 | 8 | 32 |  |  | ⟶ Role=Module+Module, Direction=Height, Visibillity=No |
| 10 | INSTANCE | ··········Spacing/Global | 1503 | 140 | 8 | 12 |  |  | ⟶ Direction=Height, Size=Small, Visibillity=No |
| 9 | INSTANCE | ·········Component/Dropdown/Dropdown Field | 1511 | 140 | 216 | 32 | #FFFFFF | #B9BCBB | ⟶ Size=Medium, Selection Type=Single Select, Status=Filled |
| 10 | FRAME | ··········Inner | 1519 | 146 | 182 | 20 |  |  |  |
| 11 | TEXT | ···········Filled Text | 1519 | 146 | 22 | 20 | #1F1F1F |  | “ALL” |
| 10 | INSTANCE | ··········Icons/Arrow/Chevron2/ | 1709 | 151 | 10 | 10 |  |  | ⟶ Direction=Down, Appearance=Single, Color=Text-Light |
| 11 | VECTOR | ···········Union | 1711 | 155 | 5 | 3 | #5B5C5B |  |  |
| 10 | FRAME | ··········Essential | 1511 | 140 | 1 | 32 |  |  |  |
| 11 | VECTOR | ···········Dot | 1513 | 142 | 4 | 4 | #F94B50 |  |  |
| 7 | INSTANCE | ·······Spacing/Role | 278 | 172 | 1449 | 8 |  |  | ⟶ Role=Search Area Row+Row, Direction=Height, Visibillity=No |
| 8 | INSTANCE | ········Spacing/Global | 278 | 172 | 1449 | 8 |  |  | ⟶ Direction=Height, Size=XSmall, Visibillity=No |
| 7 | FRAME | ·······Row | 278 | 180 | 1449 | 32 |  |  |  |
| 8 | FRAME | ········Inner | 278 | 180 | 344 | 32 |  |  |  |
| 9 | INSTANCE | ·········Component/Label | 278 | 180 | 120 | 32 |  |  | ⟶ Required=On, Depth=Default, Text Align=Right |
| 10 | FRAME | ··········Essential | 339 | 187 | 1 | 18 |  |  |  |
| 11 | VECTOR | ···········Dot | 335 | 190 | 4 | 4 | #F94B50 |  |  |
| 10 | TEXT | ··········Label | 340 | 186 | 58 | 20 | #1F1F1F |  | “Biz. Type” |
| 10 | FRAME | ··········Info | 315 | 180 | 20 | 20 |  |  |  |
| 11 | INSTANCE | ···········Icons/Status/Info/ | 317 | 182 | 18 | 18 |  |  | ⟶ Appearance=Lined |
| 12 | VECTOR | ············Union | 318 | 184 | 15 | 15 | #5B5C5B |  |  |
| 9 | INSTANCE | ·········Spacing/Role | 398 | 180 | 8 | 32 |  |  | ⟶ Role=Module+Module, Direction=Height, Visibillity=No |
| 10 | INSTANCE | ··········Spacing/Global | 398 | 180 | 8 | 12 |  |  | ⟶ Direction=Height, Size=Small, Visibillity=No |
| 9 | INSTANCE | ·········Component/Dropdown/Dropdown Field | 406 | 180 | 216 | 32 | #FFFFFF | #B9BCBB | ⟶ Size=Medium, Selection Type=Single Select, Status=Filled |
| 10 | FRAME | ··········Inner | 414 | 186 | 182 | 20 |  |  |  |
| 11 | TEXT | ···········Filled Text | 414 | 186 | 22 | 20 | #1F1F1F |  | “ALL” |
| 10 | INSTANCE | ··········Icons/Arrow/Chevron2/ | 604 | 191 | 10 | 10 |  |  | ⟶ Direction=Down, Appearance=Single, Color=Text-Light |
| 11 | VECTOR | ···········Union | 606 | 195 | 5 | 3 | #5B5C5B |  |  |
| 10 | FRAME | ··········Essential | 406 | 180 | 1 | 32 |  |  |  |
| 11 | VECTOR | ···········Dot | 408 | 182 | 4 | 4 | #F94B50 |  |  |
| 8 | INSTANCE | ········Spacing/Role | 622 | 180 | 24 | 32 |  |  | ⟶ Role=Form Item+Form Item, Direction=Width, Visibillity=No |
| 9 | INSTANCE | ·········Spacing/Global | 622 | 180 | 24 | 32 |  |  | ⟶ Direction=Width, Size=XLarge, Visibillity=Yes |
| 8 | FRAME | ········Inner | 646 | 180 | 344 | 32 |  |  |  |
| 9 | INSTANCE | ·········Component/Label | 646 | 180 | 120 | 32 |  |  | ⟶ Required=Off, Depth=Default, Text Align=Right |
| 10 | FRAME | ··········Essential | 656 | 187 | 1 | 18 |  |  |  |
| 11 | VECTOR | ···········Dot | 652 | 190 | 4 | 4 | #2D9BB2 |  |  |
| 10 | TEXT | ··········Label | 657 | 186 | 109 | 20 | #1F1F1F |  | “Model/Nickname” |
| 10 | FRAME | ··········Info | 683 | 180 | 20 | 20 |  |  |  |
| 11 | INSTANCE | ···········Icons/Status/Info/ | 685 | 182 | 18 | 18 |  |  | ⟶ Appearance=Lined |
| 12 | VECTOR | ············Union | 687 | 184 | 15 | 15 | #5B5C5B |  |  |
| 9 | INSTANCE | ·········Spacing/Role | 766 | 180 | 8 | 32 |  |  | ⟶ Role=Module+Module, Direction=Height, Visibillity=No |
| 10 | INSTANCE | ··········Spacing/Global | 766 | 180 | 8 | 12 |  |  | ⟶ Direction=Height, Size=Small, Visibillity=No |
| 9 | FRAME | ·········input + search | 774 | 180 | 216 | 32 |  |  |  |
| 10 | INSTANCE | ··········Component/Input Field/Text | 774 | 180 | 180 | 32 | #FFFFFF | #B9BCBB | ⟶ Size=Large, Status=Default, Text Align=Left |
| 11 | FRAME | ···········Inner | 786 | 184 | 156 | 24 |  |  |  |
| 12 | TEXT | ············입력해주세요. | 786 | 186 | 0 | 20 | #979998 |  |  |
| 11 | FRAME | ···········Essential | 774 | 180 | 1 | 32 |  |  |  |
| 12 | VECTOR | ············Dot | 776 | 182 | 4 | 4 | #F94B50 |  |  |
| 10 | INSTANCE | ··········Component/Button | 958 | 180 | 32 | 32 | #FFFFFF | #DDE0DF | ⟶ Size=Medium, Appearance=Outlined, Priority=Normal, Status=Default, Icon_Position=Leading |
| 11 | FRAME | ···········Inner-Contatiner | 964 | 186 | 20 | 20 |  |  |  |
| 12 | RECTANGLE | ············Additional_Padding_For_Text | 964 | 186 | 2 | 20 |  |  |  |
| 12 | FRAME | ············Icon-Container | 964 | 186 | 20 | 20 |  |  |  |
| 13 | INSTANCE | ·············Icons/Function/Search/ | 964 | 186 | 20 | 20 |  |  | ⟶ Appearance=Lined |
| 14 | VECTOR | ··············Union | 966 | 188 | 17 | 17 | #5B5C5B |  |  |
| 12 | FRAME | ············Text-Container | 986 | 186 | 48 | 20 |  |  |  |
| 13 | TEXT | ·············Text | 988 | 186 | 100 | 20 | #5B5C5B |  | “Column Setting” |
| 12 | RECTANGLE | ············Additional_Padding_For_Text | 1034 | 186 | 2 | 20 |  |  |  |
| 8 | INSTANCE | ········Spacing/Role | 990 | 180 | 24 | 32 |  |  | ⟶ Role=Form Item+Form Item, Direction=Width, Visibillity=No |
| 9 | INSTANCE | ·········Spacing/Global | 990 | 180 | 24 | 32 |  |  | ⟶ Direction=Width, Size=XLarge, Visibillity=Yes |
| 8 | FRAME | ········Inner | 1014 | 180 | 344 | 32 |  |  |  |
| 9 | INSTANCE | ·········Component/Label | 1014 | 180 | 120 | 32 |  |  | ⟶ Required=On, Depth=Default, Text Align=Right |
| 10 | FRAME | ··········Essential | 1092 | 187 | 1 | 18 |  |  |  |
| 11 | VECTOR | ···········Dot | 1088 | 190 | 4 | 4 | #F94B50 |  |  |
| 10 | TEXT | ··········Label | 1092 | 186 | 42 | 20 | #1F1F1F |  | “Period” |
| 10 | FRAME | ··········Info | 1052 | 180 | 20 | 20 |  |  |  |
| 11 | INSTANCE | ···········Icons/Status/Info/ | 1054 | 182 | 18 | 18 |  |  | ⟶ Appearance=Lined |
| 12 | VECTOR | ············Union | 1055 | 184 | 15 | 15 | #5B5C5B |  |  |
| 9 | INSTANCE | ·········Spacing/Role | 1134 | 180 | 8 | 32 |  |  | ⟶ Role=Module+Module, Direction=Height, Visibillity=No |
| 10 | INSTANCE | ··········Spacing/Global | 1134 | 180 | 8 | 12 |  |  | ⟶ Direction=Height, Size=Small, Visibillity=No |
| 9 | INSTANCE | ·········Component/Input Field/Date&Time | 1142 | 180 | 216 | 32 | #FFFFFF | #B9BCBB | ⟶ Size=Medium, Usecase=Range, Status=Filled |
| 10 | FRAME | ··········Inner | 1170 | 184 | 180 | 24 |  |  |  |
| 11 | TEXT | ···········2023.08.08 - 2023.08.28 | 1170 | 186 | 148 | 20 | #1F1F1F |  | “2026.03.01 - 2026.08.31” |
| 10 | INSTANCE | ··········Icons/Function/Calendar/ | 1150 | 188 | 16 | 16 |  |  | ⟶ Appearance=Lined |
| 11 | VECTOR | ···········Union | 1152 | 189 | 12 | 13 | #1F1F1F |  |  |
| 10 | FRAME | ··········Essential | 1142 | 180 | 1 | 32 |  |  |  |
| 11 | VECTOR | ···········Dot | 1144 | 182 | 4 | 4 | #F94B50 |  |  |
| 8 | INSTANCE | ········Spacing/Role | 1359 | 180 | 24 | 32 |  |  | ⟶ Role=Form Item+Form Item, Direction=Width, Visibillity=No |
| 9 | INSTANCE | ·········Spacing/Global | 1359 | 180 | 24 | 32 |  |  | ⟶ Direction=Width, Size=XLarge, Visibillity=Yes |
| 8 | FRAME | ········Inner | 1383 | 180 | 344 | 32 |  |  |  |
| 9 | INSTANCE | ·········Component/Label | 1383 | 180 | 120 | 32 |  |  | ⟶ Required=On, Depth=Default, Text Align=Right |
| 10 | FRAME | ··········Essential | 1457 | 187 | 1 | 18 |  |  |  |
| 11 | VECTOR | ···········Dot | 1453 | 190 | 4 | 4 | #F94B50 |  |  |
| 10 | TEXT | ··········Label | 1458 | 186 | 45 | 20 | #1F1F1F |  | “Bucket” |
| 10 | FRAME | ··········Info | 1420 | 180 | 20 | 20 |  |  |  |
| 11 | INSTANCE | ···········Icons/Status/Info/ | 1422 | 182 | 18 | 18 |  |  | ⟶ Appearance=Lined |
| 12 | VECTOR | ············Union | 1423 | 184 | 15 | 15 | #5B5C5B |  |  |
| 9 | INSTANCE | ·········Spacing/Role | 1503 | 180 | 8 | 32 |  |  | ⟶ Role=Module+Module, Direction=Height, Visibillity=No |
| 10 | INSTANCE | ··········Spacing/Global | 1503 | 180 | 8 | 12 |  |  | ⟶ Direction=Height, Size=Small, Visibillity=No |
| 9 | FRAME | ·········dropdown | 1511 | 180 | 216 | 32 |  |  |  |
| 10 | INSTANCE | ··········Component/Dropdown/Dropdown Field | 1511 | 180 | 216 | 32 | #FFFFFF | #B9BCBB | ⟶ Size=Medium, Selection Type=Single Select, Status=Filled |
| 11 | FRAME | ···········Inner | 1519 | 186 | 182 | 20 |  |  |  |
| 12 | TEXT | ············Filled Text | 1519 | 186 | 50 | 20 | #1F1F1F |  | “Monthly” |
| 11 | INSTANCE | ···········Icons/Arrow/Chevron2/ | 1709 | 191 | 10 | 10 |  |  | ⟶ Direction=Down, Appearance=Single, Color=Text-Light |
| 12 | VECTOR | ············Union | 1711 | 195 | 5 | 3 | #5B5C5B |  |  |
| 11 | FRAME | ···········Essential | 1511 | 180 | 1 | 32 |  |  |  |
| 12 | VECTOR | ············Dot | 1513 | 182 | 4 | 4 | #F94B50 |  |  |
| 6 | FRAME | ······Btn Area | 1751 | 180 | 121 | 32 |  |  |  |
| 7 | INSTANCE | ·······Component/Button | 1751 | 180 | 32 | 32 | #FFFFFF | #DDE0DF | ⟶ Size=Medium, Appearance=Outlined, Priority=Normal, Status=Default, Icon_Position=Leading |
| 8 | FRAME | ········Inner-Contatiner | 1757 | 186 | 72 | 20 |  |  |  |
| 9 | RECTANGLE | ·········Additional_Padding_For_Text | 1757 | 186 | 2 | 20 |  |  |  |
| 9 | FRAME | ·········Icon-Container | 1759 | 186 | 20 | 20 |  |  |  |
| 10 | INSTANCE | ··········Icons/Edit/Edit-2/ | 1759 | 186 | 20 | 20 |  |  | ⟶ Appearance=Lined |
| 11 | VECTOR | ···········Union | 1763 | 189 | 16 | 18 | #5B5C5B |  |  |
| 9 | FRAME | ·········Text-Container | 1779 | 186 | 48 | 20 |  |  |  |
| 10 | TEXT | ··········Text | 1781 | 186 | 45 | 20 | #5B5C5B |  | “Button” |
| 9 | RECTANGLE | ·········Additional_Padding_For_Text | 1827 | 186 | 2 | 20 |  |  |  |
| 7 | INSTANCE | ·······Spacing/Role | 1751 | 180 | 4 | 32 |  |  | ⟶ Role=Btn+Btn(L), Direction=Width, Visibillity=No |
| 8 | INSTANCE | ········Spacing/Global | 1751 | 180 | 4 | 20 |  |  | ⟶ Direction=Width, Size=XXSmall, Visibillity=Yes |
| 7 | INSTANCE | ·······Component/Button | 1787 | 180 | 32 | 32 | #FFFFFF | #DDE0DF | ⟶ Size=Medium, Appearance=Outlined, Priority=Normal, Status=Default, Icon_Position=Leading |
| 8 | FRAME | ········Inner-Contatiner | 1793 | 186 | 72 | 20 |  |  |  |
| 9 | RECTANGLE | ·········Additional_Padding_For_Text | 1793 | 186 | 2 | 20 |  |  |  |
| 9 | FRAME | ·········Icon-Container | 1795 | 186 | 20 | 20 |  |  |  |
| 10 | INSTANCE | ··········Icons/Control/Reset/ | 1795 | 186 | 20 | 20 |  |  | ⟶ Size=Default, Color=Text-Light |
| 11 | VECTOR | ···········Union | 1798 | 188 | 19 | 19 | #5B5C5B |  |  |
| 9 | FRAME | ·········Text-Container | 1815 | 186 | 48 | 20 |  |  |  |
| 10 | TEXT | ··········Text | 1817 | 186 | 45 | 20 | #5B5C5B |  | “Button” |
| 9 | RECTANGLE | ·········Additional_Padding_For_Text | 1863 | 186 | 2 | 20 |  |  |  |
| 7 | INSTANCE | ·······Spacing/Role | 1787 | 180 | 4 | 32 |  |  | ⟶ Role=Btn+Btn(L), Direction=Width, Visibillity=No |
| 8 | INSTANCE | ········Spacing/Global | 1787 | 180 | 4 | 20 |  |  | ⟶ Direction=Width, Size=XXSmall, Visibillity=Yes |
| 7 | INSTANCE | ·······Component/Button | 1751 | 180 | 85 | 32 | #3C3E3D |  | ⟶ Size=Medium, Appearance=Contained, Priority=Normal, Status=Default, Icon_Position=Leading |
| 8 | FRAME | ········Inner-Contatiner | 1757 | 186 | 73 | 20 |  |  |  |
| 9 | RECTANGLE | ·········Additional_Padding_For_Text | 1757 | 186 | 2 | 20 |  |  |  |
| 9 | FRAME | ·········Icon-Container | 1759 | 186 | 20 | 20 |  |  |  |
| 10 | INSTANCE | ··········Icons/Function/Search/ | 1759 | 186 | 20 | 20 |  |  | ⟶ Appearance=Lined |
| 11 | VECTOR | ···········Union | 1761 | 188 | 17 | 17 | #FFFFFF | #FFFFFF |  |
| 9 | FRAME | ·········Text-Container | 1779 | 186 | 49 | 20 |  |  |  |
| 10 | TEXT | ··········Text | 1781 | 186 | 45 | 20 | #FFFFFF |  | “Search” |
| 9 | RECTANGLE | ·········Additional_Padding_For_Text | 1828 | 186 | 2 | 20 |  |  |  |
| 7 | INSTANCE | ·······Spacing/Role | 1836 | 180 | 4 | 32 |  |  | ⟶ Role=Btn+Btn(L), Direction=Width, Visibillity=No |
| 8 | INSTANCE | ········Spacing/Global | 1836 | 180 | 4 | 32 |  |  | ⟶ Direction=Width, Size=XXSmall, Visibillity=Yes |
| 7 | INSTANCE | ·······Component/Button | 1840 | 180 | 32 | 32 | #3C3E3D |  | ⟶ Size=Medium, Appearance=Contained, Priority=Normal, Status=Default, Icon_Position=Leading |
| 8 | FRAME | ········Inner-Contatiner | 1846 | 186 | 20 | 20 |  |  |  |
| 9 | RECTANGLE | ·········Additional_Padding_For_Text | 1846 | 186 | 2 | 20 |  |  |  |
| 9 | FRAME | ·········Icon-Container | 1846 | 186 | 20 | 20 |  |  |  |
| 10 | INSTANCE | ··········Icons/Arrow/Chevron/ | 1846 | 186 | 20 | 20 |  |  | ⟶ Direction=Up, Appearance=Single, Color=Text-Light |
| 11 | VECTOR | ···········Union | 1848 | 193 | 16 | 7 | #FFFFFF |  |  |
| 9 | FRAME | ·········Text-Container | 1868 | 186 | 48 | 20 |  |  |  |
| 10 | TEXT | ··········Text | 1870 | 186 | 45 | 20 | #FFFFFF |  | “Button” |
| 9 | RECTANGLE | ·········Additional_Padding_For_Text | 1916 | 186 | 2 | 20 |  |  |  |
| 5 | INSTANCE | ·····Component/Divider | 278 | 220 | 1594 | 1 |  |  | ⟶ Placement=Form, Direction=Horizontal |
| 6 | VECTOR | ······Border | 278 | 220 | 1594 | 0 |  | #DDE0DF |  |
| 5 | FRAME | ·····Row | 278 | 229 | 1594 | 32 |  |  |  |
| 6 | FRAME | ······Inner | 278 | 229 | 344 | 32 |  |  |  |
| 7 | INSTANCE | ·······Component/Label | 278 | 229 | 120 | 32 |  |  | ⟶ Required=Off, Depth=Default, Text Align=Right |
| 8 | FRAME | ········Essential | 335 | 236 | 1 | 18 |  |  |  |
| 9 | VECTOR | ·········Dot | 331 | 239 | 4 | 4 | #2D9BB2 |  |  |
| 8 | TEXT | ········Label | 336 | 235 | 62 | 20 | #1F1F1F |  | “Plant Site” |
| 8 | FRAME | ········Info | 315 | 229 | 20 | 20 |  |  |  |
| 9 | INSTANCE | ·········Icons/Status/Info/ | 317 | 231 | 18 | 18 |  |  | ⟶ Appearance=Lined |
| 10 | VECTOR | ··········Union | 318 | 232 | 15 | 15 | #5B5C5B |  |  |
| 7 | INSTANCE | ·······Spacing/Role | 398 | 229 | 8 | 32 |  |  | ⟶ Role=Module+Module, Direction=Height, Visibillity=No |
| 8 | INSTANCE | ········Spacing/Global | 398 | 229 | 8 | 12 |  |  | ⟶ Direction=Height, Size=Small, Visibillity=No |
| 7 | INSTANCE | ·······Component/Dropdown/Dropdown Field | 406 | 229 | 216 | 32 | #FFFFFF | #B9BCBB | ⟶ Size=Medium, Selection Type=Single Select, Status=Filled |
| 8 | FRAME | ········Inner | 414 | 235 | 182 | 20 |  |  |  |
| 9 | TEXT | ·········Filled Text | 414 | 235 | 22 | 20 | #1F1F1F |  | “ALL” |
| 8 | INSTANCE | ········Icons/Arrow/Chevron2/ | 604 | 240 | 10 | 10 |  |  | ⟶ Direction=Down, Appearance=Single, Color=Text-Light |
| 9 | VECTOR | ·········Union | 606 | 244 | 5 | 3 | #5B5C5B |  |  |
| 8 | FRAME | ········Essential | 406 | 229 | 1 | 32 |  |  |  |
| 9 | VECTOR | ·········Dot | 408 | 231 | 4 | 4 | #F94B50 |  |  |
| 6 | INSTANCE | ······Spacing/Role | 622 | 229 | 24 | 32 |  |  | ⟶ Role=Form Item+Form Item, Direction=Width, Visibillity=No |
| 7 | INSTANCE | ·······Spacing/Global | 622 | 229 | 24 | 32 |  |  | ⟶ Direction=Width, Size=XLarge, Visibillity=Yes |
| 6 | FRAME | ······Inner | 646 | 229 | 344 | 32 |  |  |  |
| 7 | INSTANCE | ·······Component/Label | 646 | 229 | 120 | 32 |  |  | ⟶ Required=Off, Depth=Default, Text Align=Right |
| 8 | FRAME | ········Essential | 722 | 236 | 1 | 18 |  |  |  |
| 9 | VECTOR | ·········Dot | 718 | 239 | 4 | 4 | #2D9BB2 |  |  |
| 8 | TEXT | ········Label | 723 | 235 | 43 | 20 | #1F1F1F |  | “Owner” |
| 8 | FRAME | ········Info | 683 | 229 | 20 | 20 |  |  |  |
| 9 | INSTANCE | ·········Icons/Status/Info/ | 685 | 231 | 18 | 18 |  |  | ⟶ Appearance=Lined |
| 10 | VECTOR | ··········Union | 687 | 232 | 15 | 15 | #5B5C5B |  |  |
| 7 | INSTANCE | ·······Spacing/Role | 766 | 229 | 8 | 32 |  |  | ⟶ Role=Module+Module, Direction=Height, Visibillity=No |
| 8 | INSTANCE | ········Spacing/Global | 766 | 229 | 8 | 12 |  |  | ⟶ Direction=Height, Size=Small, Visibillity=No |
| 7 | FRAME | ·······input + search | 774 | 229 | 225 | 32 |  |  |  |
| 8 | INSTANCE | ········Component/Input Field/Text | 774 | 229 | 180 | 32 | #FFFFFF | #B9BCBB | ⟶ Size=Large, Status=Default, Text Align=Left |
| 9 | FRAME | ·········Inner | 786 | 233 | 156 | 24 |  |  |  |
| 10 | TEXT | ··········입력해주세요. | 786 | 235 | 0 | 20 | #979998 |  |  |
| 9 | FRAME | ·········Essential | 774 | 229 | 1 | 32 |  |  |  |
| 10 | VECTOR | ··········Dot | 776 | 231 | 4 | 4 | #F94B50 |  |  |
| 8 | INSTANCE | ········Component/Button | 958 | 229 | 32 | 32 | #FFFFFF | #DDE0DF | ⟶ Size=Medium, Appearance=Outlined, Priority=Normal, Status=Default, Icon_Position=Leading |
| 9 | FRAME | ·········Inner-Contatiner | 964 | 235 | 20 | 20 |  |  |  |
| 10 | RECTANGLE | ··········Additional_Padding_For_Text | 964 | 235 | 2 | 20 |  |  |  |
| 10 | FRAME | ··········Icon-Container | 964 | 235 | 20 | 20 |  |  |  |
| 11 | INSTANCE | ···········Icons/Function/Search/ | 964 | 235 | 20 | 20 |  |  | ⟶ Appearance=Lined |
| 12 | VECTOR | ············Union | 966 | 237 | 17 | 17 | #5B5C5B |  |  |
| 10 | FRAME | ··········Text-Container | 986 | 235 | 48 | 20 |  |  |  |
| 11 | TEXT | ···········Text | 988 | 235 | 100 | 20 | #5B5C5B |  | “Column Setting” |
| 10 | RECTANGLE | ··········Additional_Padding_For_Text | 1034 | 235 | 2 | 20 |  |  |  |
| 6 | INSTANCE | ······Spacing/Role | 990 | 229 | 24 | 32 |  |  | ⟶ Role=Form Item+Form Item, Direction=Width, Visibillity=No |
| 7 | INSTANCE | ·······Spacing/Global | 990 | 229 | 24 | 32 |  |  | ⟶ Direction=Width, Size=XLarge, Visibillity=Yes |
| 6 | FRAME | ······Inner | 1014 | 229 | 858 | 32 |  |  |  |
| 7 | INSTANCE | ·······Component/Label | 1014 | 229 | 120 | 32 |  |  | ⟶ Required=Off, Depth=Default, Text Align=Right |
| 8 | FRAME | ········Essential | 1085 | 236 | 1 | 18 |  |  |  |
| 9 | VECTOR | ·········Dot | 1081 | 239 | 4 | 4 | #2D9BB2 |  |  |
| 8 | TEXT | ········Label | 1086 | 235 | 48 | 20 | #1F1F1F |  | “Version” |
| 8 | FRAME | ········Info | 1051 | 229 | 20 | 20 |  |  |  |
| 9 | INSTANCE | ·········Icons/Status/Info/ | 1053 | 231 | 18 | 18 |  |  | ⟶ Appearance=Lined |
| 10 | VECTOR | ··········Union | 1055 | 232 | 15 | 15 | #5B5C5B |  |  |
| 7 | INSTANCE | ·······Spacing/Role | 1134 | 229 | 8 | 32 |  |  | ⟶ Role=Module+Module, Direction=Height, Visibillity=No |
| 8 | INSTANCE | ········Spacing/Global | 1134 | 229 | 8 | 12 |  |  | ⟶ Direction=Height, Size=Small, Visibillity=No |
| 7 | FRAME | ·······input + search | 1142 | 229 | 252 | 32 |  |  |  |
| 8 | INSTANCE | ········Component/Input Field/Text | 1142 | 229 | 216 | 32 | #FFFFFF | #B9BCBB | ⟶ Size=Large, Status=Default, Text Align=Left |
| 9 | FRAME | ·········Inner | 1154 | 233 | 192 | 24 |  |  |  |
| 10 | TEXT | ··········입력해주세요. | 1154 | 235 | 0 | 20 | #979998 |  |  |
| 9 | FRAME | ·········Essential | 1142 | 229 | 1 | 32 |  |  |  |
| 10 | VECTOR | ··········Dot | 1144 | 231 | 4 | 4 | #F94B50 |  |  |
| 8 | INSTANCE | ········Component/Button | 1362 | 229 | 32 | 32 | #FFFFFF | #DDE0DF | ⟶ Size=Medium, Appearance=Outlined, Priority=Normal, Status=Default, Icon_Position=Leading |
| 9 | FRAME | ·········Inner-Contatiner | 1368 | 235 | 20 | 20 |  |  |  |
| 10 | RECTANGLE | ··········Additional_Padding_For_Text | 1368 | 235 | 2 | 20 |  |  |  |
| 10 | FRAME | ··········Icon-Container | 1368 | 235 | 20 | 20 |  |  |  |
| 11 | INSTANCE | ···········Icons/Function/Search/ | 1368 | 235 | 20 | 20 |  |  | ⟶ Appearance=Lined |
| 12 | VECTOR | ············Union | 1370 | 237 | 17 | 17 | #5B5C5B |  |  |
| 10 | FRAME | ··········Text-Container | 1390 | 235 | 48 | 20 |  |  |  |
| 11 | TEXT | ···········Text | 1392 | 235 | 100 | 20 | #5B5C5B |  | “Column Setting” |
| 10 | RECTANGLE | ··········Additional_Padding_For_Text | 1438 | 235 | 2 | 20 |  |  |  |
| 7 | INSTANCE | ·······Spacing/Role | 1394 | 229 | 8 | 32 |  |  | ⟶ Role=Module+Module, Direction=Height, Visibillity=No |
| 8 | INSTANCE | ········Spacing/Global | 1394 | 229 | 8 | 12 |  |  | ⟶ Direction=Height, Size=Small, Visibillity=No |
| 7 | FRAME | ·······Checkbox | 1402 | 235 | 130 | 20 |  |  |  |
| 8 | INSTANCE | ········Component/Check&Radio | 1402 | 235 | 130 | 20 |  |  | ⟶ Usecase=Checkbox, Checked=On, Status=Default, Color=Primary |
| 9 | INSTANCE | ·········#Component/Check&Radio/Module | 1402 | 237 | 16 | 16 |  |  | ⟶ Usecase=Checkbox, Checked=Off, Status=Default, Color=Primary |
| 10 | RECTANGLE | ··········Focus | 1401 | 236 | 18 | 18 |  | #8BF0E9 |  |
| 10 | RECTANGLE | ··········BG | 1402 | 237 | 16 | 16 | #FFFFFF | #B9BCBB |  |
| 9 | TEXT | ·········Text | 1422 | 235 | 110 | 20 | #1F1F1F |  | “Search over range” |
| 4 | INSTANCE | ····Spacing/Role | 262 | 269 | 1626 | 12 |  |  | ⟶ Role=Module+Module, Direction=Height, Visibillity=No |
| 5 | INSTANCE | ·····Spacing/Global | 262 | 269 | 1626 | 12 |  |  | ⟶ Direction=Height, Size=Small, Visibillity=No |
| 4 | FRAME | ····_Sub Title Area | 262 | 281 | 1626 | 28 |  |  |  |
| 5 | INSTANCE | ·····Component/Title/Sub Title | 262 | 281 | 36 | 28 |  |  | ⟶ Depth=H3 |
| 6 | TEXT | ······H3 | 262 | 283 | 106 | 24 | #1F1F1F |  | “서브타이틀(h3)” |
| 6 | INSTANCE | ······#Component/Title/Sub Title/Count | 376 | 285 | 55 | 20 |  |  | ⟶ Appearance=All |
| 7 | TEXT | ·······총 | 376 | 285 | 12 | 20 | #1F1F1F |  | “총” |
| 7 | TEXT | ·······21 | 394 | 285 | 8 | 20 | #2D9BB2 |  | “4” |
| 7 | TEXT | ·······건 | 408 | 285 | 12 | 20 | #1F1F1F |  | “건” |
| 5 | FRAME | ·····Right Container | 1074 | 281 | 814 | 28 |  |  |  |
| 6 | INSTANCE | ······Component/Button | 1074 | 281 | 28 | 28 | #FFFFFF | #DDE0DF | ⟶ Size=Small, Appearance=Outlined, Priority=Normal, Status=Default, Icon_Position=Leading |
| 7 | FRAME | ·······Inner-Contatiner | 1080 | 285 | 16 | 20 |  |  |  |
| 8 | FRAME | ········Icon-Container | 1080 | 287 | 16 | 16 |  |  |  |
| 9 | INSTANCE | ·········Icons/Arrow/Column Setting | 1080 | 287 | 16 | 16 |  |  | ⟶ Icons/Arrow/Column Setting |
| 10 | BOOLEAN_OPERATION | ··········Union | 1080 | 287 | 16 | 16 | #5B5C5B |  |  |
| 11 | VECTOR | ···········Union | 1080 | 291 | 6 | 12 | #5B5C5B |  |  |
| 11 | VECTOR | ···········Union | 1088 | 291 | 8 | 12 | #5B5C5B |  |  |
| 11 | VECTOR | ···········Union | 1083 | 287 | 10 | 3 | #5B5C5B |  |  |
| 8 | FRAME | ········Text-Container | 1096 | 286 | 45 | 18 |  |  |  |
| 9 | TEXT | ·········Text | 1098 | 286 | 61 | 18 | #5B5C5B |  | “Insert (F8)” |
| 6 | INSTANCE | ······Spacing/Role | 1102 | 281 | 4 | 28 |  |  | ⟶ Role=Module+Module, Direction=Height, Visibillity=No |
| 7 | INSTANCE | ·······Spacing/Global | 1102 | 281 | 4 | 12 |  |  | ⟶ Direction=Height, Size=Small, Visibillity=No |
| 6 | INSTANCE | ······Component/Button | 1106 | 281 | 93 | 28 | #FFFFFF | #DDE0DF | ⟶ Size=Small, Appearance=Outlined, Priority=Normal, Status=Default, Icon_Position=Leading |
| 7 | FRAME | ·······Inner-Contatiner | 1112 | 285 | 81 | 20 |  |  |  |
| 8 | FRAME | ········Icon-Container | 1112 | 287 | 16 | 16 |  |  |  |
| 9 | INSTANCE | ·········Icons/Control/Add/ | 1112 | 287 | 16 | 16 |  |  | ⟶ Size=Default, Color=Text-Light |
| 10 | VECTOR | ··········Union | 1113 | 288 | 13 | 13 | #5B5C5B |  |  |
| 8 | FRAME | ········Text-Container | 1128 | 286 | 65 | 18 |  |  |  |
| 9 | TEXT | ·········Text | 1130 | 286 | 61 | 18 | #5B5C5B |  | “Insert (F8)” |
| 6 | INSTANCE | ······Spacing/Role | 1199 | 281 | 4 | 28 |  |  | ⟶ Role=Module+Module, Direction=Height, Visibillity=No |
| 7 | INSTANCE | ·······Spacing/Global | 1199 | 281 | 4 | 12 |  |  | ⟶ Direction=Height, Size=Small, Visibillity=No |
| 6 | INSTANCE | ······Component/Button | 1203 | 281 | 97 | 28 | #FFFFFF | #DDE0DF | ⟶ Size=Small, Appearance=Outlined, Priority=Normal, Status=Default, Icon_Position=Leading |
| 7 | FRAME | ·······Inner-Contatiner | 1209 | 285 | 85 | 20 |  |  |  |
| 8 | FRAME | ········Icon-Container | 1209 | 287 | 16 | 16 |  |  |  |
| 9 | INSTANCE | ·········Icons/Edit/Delete/ | 1209 | 287 | 16 | 16 |  |  | ⟶ Appearance=Lined |
| 10 | VECTOR | ··········Union | 1212 | 288 | 11 | 13 | #5B5C5B |  |  |
| 8 | FRAME | ········Text-Container | 1225 | 286 | 69 | 18 |  |  |  |
| 9 | TEXT | ·········Text | 1227 | 286 | 65 | 18 | #5B5C5B |  | “Delete (F9)” |
| 6 | INSTANCE | ······Spacing/Role | 1300 | 281 | 4 | 28 |  |  | ⟶ Role=Module+Module, Direction=Height, Visibillity=No |
| 7 | INSTANCE | ·······Spacing/Global | 1300 | 281 | 4 | 12 |  |  | ⟶ Direction=Height, Size=Small, Visibillity=No |
| 6 | INSTANCE | ······Component/Button | 1304 | 281 | 87 | 28 | #FFFFFF | #DDE0DF | ⟶ Size=Small, Appearance=Outlined, Priority=Normal, Status=Default, Icon_Position=Leading |
| 7 | FRAME | ·······Inner-Contatiner | 1310 | 285 | 75 | 20 |  |  |  |
| 8 | FRAME | ········Icon-Container | 1310 | 287 | 16 | 16 |  |  |  |
| 9 | INSTANCE | ·········Icons/floppy disk | 1310 | 287 | 16 | 16 |  |  | ⟶ State=outlined |
| 10 | GROUP | ··········Group 16017 | 1313 | 291 | 17 | 17 |  |  |  |
| 11 | BOOLEAN_OPERATION | ···········Subtract | 1314 | 291 | 17 | 17 |  | #5B5C5B |  |
| 12 | RECTANGLE | ············Rectangle 39589743 | 1314 | 291 | 17 | 17 | #D9D9D9 |  |  |
| 12 | VECTOR | ············Vector 2648 | 1325 | 288 | 9 | 9 | #D9D9D9 |  |  |
| 11 | VECTOR | ···········Vector 2649 | 1315 | 291 | 6 | 4 |  | #5B5C5B |  |
| 11 | VECTOR | ···········Vector 2650 | 1313 | 298 | 10 | 9 |  | #5B5C5B |  |
| 10 | VECTOR | ··········Vector (Stroke) | 1312 | 289 | 12 | 12 | #5B5C5B |  |  |
| 8 | FRAME | ········Text-Container | 1326 | 286 | 59 | 18 |  |  |  |
| 9 | TEXT | ·········Text | 1328 | 286 | 55 | 18 | #5B5C5B |  | “Save (F7)” |
| 6 | INSTANCE | ······Spacing/Role | 1391 | 281 | 4 | 28 |  |  | ⟶ Role=Module+Module, Direction=Height, Visibillity=No |
| 7 | INSTANCE | ·······Spacing/Global | 1391 | 281 | 4 | 12 |  |  | ⟶ Direction=Height, Size=Small, Visibillity=No |
| 6 | INSTANCE | ······Component/Button | 1395 | 281 | 84 | 28 | #FFFFFF | #DDE0DF | ⟶ Size=Small, Appearance=Outlined, Priority=Normal, Status=Default, Icon_Position=Leading |
| 7 | FRAME | ·······Inner-Contatiner | 1401 | 285 | 72 | 20 |  |  |  |
| 8 | FRAME | ········Icon-Container | 1401 | 287 | 16 | 16 |  |  |  |
| 9 | INSTANCE | ·········Icons/Arrow/Condensed/ | 1401 | 287 | 16 | 16 |  |  | ⟶ Direction=Up-Down, Color=Text-Light |
| 10 | VECTOR | ··········Union | 1406 | 289 | 7 | 12 | #5B5C5B |  |  |
| 8 | FRAME | ········Text-Container | 1417 | 286 | 56 | 18 |  |  |  |
| 9 | TEXT | ·········Text | 1419 | 286 | 52 | 18 | #5B5C5B |  | “Sort (F3)” |
| 6 | INSTANCE | ······Spacing/Role | 1479 | 281 | 4 | 28 |  |  | ⟶ Role=Module+Module, Direction=Height, Visibillity=No |
| 7 | INSTANCE | ·······Spacing/Global | 1479 | 281 | 4 | 12 |  |  | ⟶ Direction=Height, Size=Small, Visibillity=No |
| 6 | INSTANCE | ······Component/Button | 1483 | 281 | 90 | 28 | #FFFFFF | #DDE0DF | ⟶ Size=Small, Appearance=Outlined, Priority=Normal, Status=Default, Icon_Position=Leading |
| 7 | FRAME | ·······Inner-Contatiner | 1489 | 285 | 78 | 20 |  |  |  |
| 8 | FRAME | ········Icon-Container | 1489 | 287 | 16 | 16 |  |  |  |
| 9 | INSTANCE | ·········Icons/List/Funnel/ | 1489 | 287 | 16 | 16 |  |  | ⟶ Appearance=Lined |
| 10 | VECTOR | ··········Union | 1492 | 289 | 11 | 13 | #5B5C5B |  |  |
| 8 | FRAME | ········Text-Container | 1505 | 286 | 62 | 18 |  |  |  |
| 9 | TEXT | ·········Text | 1507 | 286 | 58 | 18 | #5B5C5B |  | “Filter (F4)” |
| 6 | INSTANCE | ······Spacing/Role | 1573 | 281 | 4 | 28 |  |  | ⟶ Role=Module+Module, Direction=Height, Visibillity=No |
| 7 | INSTANCE | ·······Spacing/Global | 1573 | 281 | 4 | 12 |  |  | ⟶ Direction=Height, Size=Small, Visibillity=No |
| 6 | INSTANCE | ······Component/Button | 1577 | 281 | 116 | 28 | #FFFFFF | #DDE0DF | ⟶ Size=Small, Appearance=Outlined, Priority=Normal, Status=Default, Icon_Position=Leading |
| 7 | FRAME | ·······Inner-Contatiner | 1583 | 285 | 104 | 20 |  |  |  |
| 8 | FRAME | ········Icon-Container | 1583 | 287 | 16 | 16 |  |  |  |
| 9 | INSTANCE | ·········Icons/List/Todo | 1583 | 287 | 16 | 16 |  |  | ⟶ Icons/List/Todo |
| 10 | VECTOR | ··········Union | 1584 | 289 | 13 | 12 | #5B5C5B |  |  |
| 8 | FRAME | ········Text-Container | 1599 | 286 | 88 | 18 |  |  |  |
| 9 | TEXT | ·········Text | 1601 | 286 | 84 | 18 | #5B5C5B |  | “Condition (F6)” |
| 6 | INSTANCE | ······Spacing/Role | 1693 | 281 | 4 | 28 |  |  | ⟶ Role=Module+Module, Direction=Height, Visibillity=No |
| 7 | INSTANCE | ·······Spacing/Global | 1693 | 281 | 4 | 12 |  |  | ⟶ Direction=Height, Size=Small, Visibillity=No |
| 6 | INSTANCE | ······Component/Button | 1697 | 281 | 159 | 28 | #FFFFFF | #DDE0DF | ⟶ Size=Small, Appearance=Outlined, Priority=Normal, Status=Default, Icon_Position=Leading |
| 7 | FRAME | ·······Inner-Contatiner | 1703 | 285 | 147 | 20 |  |  |  |
| 8 | FRAME | ········Icon-Container | 1703 | 287 | 16 | 16 |  |  |  |
| 9 | INSTANCE | ·········Icons/Control/Refresh | 1703 | 287 | 16 | 16 |  |  | ⟶ Size=Default, Color=Text-Light |
| 10 | VECTOR | ··········Union | 1704 | 289 | 13 | 13 | #5B5C5B |  |  |
| 8 | FRAME | ········Text-Container | 1719 | 286 | 131 | 18 |  |  |  |
| 9 | TEXT | ·········Text | 1721 | 286 | 127 | 18 | #5B5C5B |  | “Reset Condition (F10)” |
| 6 | INSTANCE | ······Spacing/Role | 1856 | 281 | 4 | 28 |  |  | ⟶ Role=Module+Module, Direction=Height, Visibillity=No |
| 7 | INSTANCE | ·······Spacing/Global | 1856 | 281 | 4 | 12 |  |  | ⟶ Direction=Height, Size=Small, Visibillity=No |
| 6 | INSTANCE | ······Component/Button | 1828 | 281 | 102 | 28 | #FFFFFF | #DDE0DF | ⟶ Size=Small, Appearance=Outlined, Priority=Normal, Status=Default, Icon_Position=Leading |
| 7 | FRAME | ·······Inner-Contatiner | 1834 | 285 | 61 | 20 |  |  |  |
| 8 | FRAME | ········Icon-Container | 1834 | 287 | 16 | 16 |  |  |  |
| 9 | INSTANCE | ·········Icons/File/Download/ | 1834 | 287 | 16 | 16 |  |  | ⟶ Icons/File/Download/ |
| 10 | VECTOR | ··········Union | 1836 | 290 | 20 | 18 | #5B5C5B |  |  |
| 8 | FRAME | ········Text-Container | 1850 | 286 | 45 | 18 |  |  |  |
| 9 | TEXT | ·········Text | 1852 | 286 | 70 | 18 | #5B5C5B |  | “Manual (F1)” |
| 6 | INSTANCE | ······Spacing/Role | 1828 | 281 | 4 | 28 |  |  | ⟶ Role=Module+Module, Direction=Height, Visibillity=No |
| 7 | INSTANCE | ·······Spacing/Global | 1828 | 281 | 120 | 12 |  |  | ⟶ Direction=Height, Size=Small, Visibillity=No |
| 6 | INSTANCE | ······3 | 1860 | 281 | 28 | 28 | #FFFFFF | #DDE0DF | ⟶ Size=Small, Appearance=Outlined, Priority=Normal, Status=Default, Icon_Position=Leading |
| 7 | FRAME | ·······Inner-Contatiner | 1866 | 285 | 16 | 20 |  |  |  |
| 8 | FRAME | ········Icon-Container | 1866 | 287 | 16 | 16 |  |  |  |
| 9 | INSTANCE | ·········Icons/File/Excel_color/ | 1866 | 287 | 16 | 16 |  |  | ⟶ Appearance=Lined |
| 10 | VECTOR | ··········Union | 1869 | 288 | 11 | 13 | #00806A |  |  |
| 8 | FRAME | ········Text-Container | 1882 | 286 | 45 | 18 |  |  |  |
| 9 | TEXT | ·········Text | 1884 | 286 | 23 | 18 | #5B5C5B |  | “적용” |
| 6 | FRAME | ······setting | 1856 | 281 | 64 | 28 |  |  |  |
| 7 | INSTANCE | ·······Spacing/Role | 1856 | 281 | 4 | 28 |  |  | ⟶ Role=Module+Module, Direction=Height, Visibillity=No |
| 8 | INSTANCE | ········Spacing/Global | 1856 | 281 | 120 | 12 |  |  | ⟶ Direction=Height, Size=Small, Visibillity=No |
| 7 | INSTANCE | ·······Component/Button | 1860 | 281 | 28 | 28 | #FFFFFF | #DDE0DF | ⟶ Size=Small, Appearance=Outlined, Priority=Normal, Status=Default, Icon_Position=Leading |
| 8 | FRAME | ········Inner-Contatiner | 1866 | 285 | 61 | 20 |  |  |  |
| 9 | FRAME | ·········Icon-Container | 1866 | 287 | 16 | 16 |  |  |  |
| 10 | INSTANCE | ··········Icons/Function/Setting/ | 1866 | 287 | 16 | 16 |  |  | ⟶ Appearance=Lined |
| 11 | VECTOR | ···········Union | 1868 | 289 | 20 | 20 | #5B5C5B |  |  |
| 9 | FRAME | ·········Text-Container | 1882 | 286 | 45 | 18 |  |  |  |
| 10 | TEXT | ··········Text | 1884 | 286 | 92 | 18 | #5B5C5B |  | “Column Setting” |
| 7 | INSTANCE | ·······Spacing/Role | 1888 | 281 | 4 | 28 |  |  | ⟶ Role=Module+Module, Direction=Height, Visibillity=No |
| 8 | INSTANCE | ········Spacing/Global | 1888 | 281 | 120 | 12 |  |  | ⟶ Direction=Height, Size=Small, Visibillity=No |
| 7 | INSTANCE | ·······Component/Button | 1892 | 281 | 28 | 28 | #FFFFFF | #DDE0DF | ⟶ Size=Small, Appearance=Outlined, Priority=Normal, Status=Default, Icon_Position=Leading |
| 8 | FRAME | ········Inner-Contatiner | 1898 | 285 | 61 | 20 |  |  |  |
| 9 | FRAME | ·········Icon-Container | 1898 | 287 | 16 | 16 |  |  |  |
| 10 | INSTANCE | ··········Icons/List/Control/ | 1898 | 287 | 16 | 16 |  |  | ⟶ Appearance=Lined |
| 11 | VECTOR | ···········Union | 1901 | 290 | 18 | 18 | #5B5C5B |  |  |
| 9 | FRAME | ·········Text-Container | 1914 | 286 | 45 | 18 |  |  |  |
| 10 | TEXT | ··········Text | 1916 | 286 | 96 | 18 | #5B5C5B |  | “Measure Setting” |
| 4 | INSTANCE | ····Spacing/Role | 262 | 309 | 1626 | 4 |  |  | ⟶ Role=Inside_Module, Direction=Height, Visibillity=No |
| 5 | INSTANCE | ·····Spacing/Global | 262 | 309 | 1626 | 4 |  |  | ⟶ Direction=Height, Size=XXSmall, Visibillity=No |
| 4 | FRAME | ····Table | 262 | 313 | 1626 | 642 |  |  |  |
| 5 | FRAME | ·····Table | 262 | 313 | 2577 | 723 |  | #DDE0DF |  |
| 6 | FRAME | ······Header | 262 | 313 | 2577 | 48 |  |  |  |
| 7 | FRAME | ·······Header Row | 262 | 313 | 2577 | 48 |  |  |  |
| 8 | INSTANCE | ········#Component/Data Grid/Analytical/Header | 262 | 313 | 40 | 48 | #F1F4F3 | #DDE0DF | ⟶ Appearance=Text, Status=Default, Sort=None, Sortable=No, Checkbox Status=Checked |
| 9 | FRAME | ·········Inner | 262 | 313 | 40 | 48 |  |  |  |
| 10 | FRAME | ··········Header Text | 268 | 327 | 28 | 20 |  |  |  |
| 11 | FRAME | ···········Essential | 268 | 327 | 1 | 18 |  |  |  |
| 12 | VECTOR | ············Dot | 265 | 328 | 4 | 4 | #F94B50 |  |  |
| 11 | TEXT | ···········좌측정렬 텍스트 | 268 | 327 | 28 | 20 | #1F1F1F |  | “No” |
| 10 | INSTANCE | ··········#Component/Data Grid/Common/Header/Butto | 389 | 318 | 14 | 14 |  |  | ⟶ Function=More, Status=Default |
| 11 | INSTANCE | ···········Icons/Menu/More/ | 391 | 320 | 10 | 10 |  |  | ⟶ Direction=Vertical |
| 12 | VECTOR | ············Union | 395 | 321 | 1 | 8 | #5B5C5B |  |  |
| 10 | INSTANCE | ··········#Component/Data Grid/Common/Header/Butto | 405 | 318 | 14 | 14 |  |  | ⟶ Function=Filter, Status=Default |
| 11 | INSTANCE | ···········Icons/List/Funnel/ | 407 | 320 | 10 | 10 |  |  | ⟶ Appearance=Filled |
| 12 | VECTOR | ············Union | 409 | 321 | 7 | 8 | #5B5C5B |  |  |
| 8 | INSTANCE | ········#Component/Data Grid/Analytical/Header | 302 | 313 | 56 | 48 | #F1F4F3 | #DDE0DF | ⟶ Appearance=Text, Status=Default, Sort=None, Sortable=No, Checkbox Status=Checked |
| 9 | FRAME | ·········Inner | 302 | 313 | 56 | 48 |  |  |  |
| 10 | FRAME | ··········Header Text | 308 | 327 | 44 | 20 |  |  |  |
| 11 | FRAME | ···········Essential | 308 | 327 | 1 | 18 |  |  |  |
| 12 | VECTOR | ············Dot | 305 | 328 | 4 | 4 | #F94B50 |  |  |
| 11 | TEXT | ···········좌측정렬 텍스트 | 308 | 327 | 44 | 20 | #1F1F1F |  | “Div” |
| 10 | INSTANCE | ··········#Component/Data Grid/Common/Header/Butto | 429 | 318 | 14 | 14 |  |  | ⟶ Function=More, Status=Default |
| 11 | INSTANCE | ···········Icons/Menu/More/ | 431 | 320 | 10 | 10 |  |  | ⟶ Direction=Vertical |
| 12 | VECTOR | ············Union | 435 | 321 | 1 | 8 | #5B5C5B |  |  |
| 10 | INSTANCE | ··········#Component/Data Grid/Common/Header/Butto | 445 | 318 | 14 | 14 |  |  | ⟶ Function=Filter, Status=Default |
| 11 | INSTANCE | ···········Icons/List/Funnel/ | 447 | 320 | 10 | 10 |  |  | ⟶ Appearance=Filled |
| 12 | VECTOR | ············Union | 449 | 321 | 7 | 8 | #5B5C5B |  |  |
| 8 | INSTANCE | ········#Component/Data Grid/Analytical/Header | 358 | 313 | 140 | 48 | #F1F4F3 | #DDE0DF | ⟶ Appearance=Text, Status=Default, Sort=None, Sortable=No, Checkbox Status=Checked |
| 9 | FRAME | ·········Inner | 358 | 313 | 140 | 48 |  |  |  |
| 10 | FRAME | ··········Header Text | 364 | 327 | 128 | 20 |  |  |  |
| 11 | FRAME | ···········Essential | 364 | 327 | 1 | 18 |  |  |  |
| 12 | VECTOR | ············Dot | 361 | 328 | 4 | 4 | #F94B50 |  |  |
| 11 | TEXT | ···········좌측정렬 텍스트 | 364 | 327 | 128 | 20 | #1F1F1F |  | “Team” |
| 10 | INSTANCE | ··········#Component/Data Grid/Common/Header/Butto | 485 | 318 | 14 | 14 |  |  | ⟶ Function=More, Status=Default |
| 11 | INSTANCE | ···········Icons/Menu/More/ | 487 | 320 | 10 | 10 |  |  | ⟶ Direction=Vertical |
| 12 | VECTOR | ············Union | 491 | 321 | 1 | 8 | #5B5C5B |  |  |
| 10 | INSTANCE | ··········#Component/Data Grid/Common/Header/Butto | 501 | 318 | 14 | 14 |  |  | ⟶ Function=Filter, Status=Default |
| 11 | INSTANCE | ···········Icons/List/Funnel/ | 503 | 320 | 10 | 10 |  |  | ⟶ Appearance=Filled |
| 12 | VECTOR | ············Union | 505 | 321 | 7 | 8 | #5B5C5B |  |  |
| 8 | INSTANCE | ········#Component/Data Grid/Analytical/Header | 498 | 313 | 140 | 48 | #F1F4F3 | #DDE0DF | ⟶ Appearance=Text, Status=Default, Sort=None, Sortable=No, Checkbox Status=Checked |
| 9 | FRAME | ·········Inner | 498 | 313 | 140 | 48 |  |  |  |
| 10 | FRAME | ··········Header Text | 504 | 327 | 128 | 20 |  |  |  |
| 11 | FRAME | ···········Essential | 504 | 327 | 1 | 18 |  |  |  |
| 12 | VECTOR | ············Dot | 501 | 328 | 4 | 4 | #F94B50 |  |  |
| 11 | TEXT | ···········좌측정렬 텍스트 | 504 | 327 | 128 | 20 | #1F1F1F |  | “End Customer” |
| 10 | INSTANCE | ··········#Component/Data Grid/Common/Header/Butto | 625 | 318 | 14 | 14 |  |  | ⟶ Function=More, Status=Default |
| 11 | INSTANCE | ···········Icons/Menu/More/ | 627 | 320 | 10 | 10 |  |  | ⟶ Direction=Vertical |
| 12 | VECTOR | ············Union | 631 | 321 | 1 | 8 | #5B5C5B |  |  |
| 10 | INSTANCE | ··········#Component/Data Grid/Common/Header/Butto | 641 | 318 | 14 | 14 |  |  | ⟶ Function=Filter, Status=Default |
| 11 | INSTANCE | ···········Icons/List/Funnel/ | 643 | 320 | 10 | 10 |  |  | ⟶ Appearance=Filled |
| 12 | VECTOR | ············Union | 645 | 321 | 7 | 8 | #5B5C5B |  |  |
| 8 | INSTANCE | ········#Component/Data Grid/Analytical/Header | 638 | 313 | 160 | 48 | #F1F4F3 | #DDE0DF | ⟶ Appearance=Text, Status=Default, Sort=None, Sortable=No, Checkbox Status=Checked |
| 9 | FRAME | ·········Inner | 638 | 313 | 160 | 48 |  |  |  |
| 10 | FRAME | ··········Header Text | 644 | 327 | 148 | 20 |  |  |  |
| 11 | FRAME | ···········Essential | 644 | 327 | 1 | 18 |  |  |  |
| 12 | VECTOR | ············Dot | 641 | 328 | 4 | 4 | #F94B50 |  |  |
| 11 | TEXT | ···········좌측정렬 텍스트 | 644 | 327 | 148 | 20 | #1F1F1F |  | “Sales Site” |
| 10 | INSTANCE | ··········#Component/Data Grid/Common/Header/Butto | 765 | 318 | 14 | 14 |  |  | ⟶ Function=More, Status=Default |
| 11 | INSTANCE | ···········Icons/Menu/More/ | 767 | 320 | 10 | 10 |  |  | ⟶ Direction=Vertical |
| 12 | VECTOR | ············Union | 771 | 321 | 1 | 8 | #5B5C5B |  |  |
| 10 | INSTANCE | ··········#Component/Data Grid/Common/Header/Butto | 781 | 318 | 14 | 14 |  |  | ⟶ Function=Filter, Status=Default |
| 11 | INSTANCE | ···········Icons/List/Funnel/ | 783 | 320 | 10 | 10 |  |  | ⟶ Appearance=Filled |
| 12 | VECTOR | ············Union | 785 | 321 | 7 | 8 | #5B5C5B |  |  |
| 8 | INSTANCE | ········#Component/Data Grid/Analytical/Header | 798 | 313 | 157 | 48 | #F1F4F3 | #DDE0DF | ⟶ Appearance=Text, Status=Default, Sort=None, Sortable=No, Checkbox Status=Checked |
| 9 | FRAME | ·········Inner | 798 | 313 | 157 | 48 |  |  |  |
| 10 | FRAME | ··········Header Text | 804 | 327 | 145 | 20 |  |  |  |
| 11 | FRAME | ···········Essential | 804 | 327 | 1 | 18 |  |  |  |
| 12 | VECTOR | ············Dot | 801 | 328 | 4 | 4 | #F94B50 |  |  |
| 11 | TEXT | ···········좌측정렬 텍스트 | 804 | 327 | 145 | 20 | #1F1F1F |  | “Model” |
| 10 | INSTANCE | ··········#Component/Data Grid/Common/Header/Butto | 925 | 318 | 14 | 14 |  |  | ⟶ Function=More, Status=Default |
| 11 | INSTANCE | ···········Icons/Menu/More/ | 927 | 320 | 10 | 10 |  |  | ⟶ Direction=Vertical |
| 12 | VECTOR | ············Union | 931 | 321 | 1 | 8 | #5B5C5B |  |  |
| 10 | INSTANCE | ··········#Component/Data Grid/Common/Header/Butto | 941 | 318 | 14 | 14 |  |  | ⟶ Function=Filter, Status=Default |
| 11 | INSTANCE | ···········Icons/List/Funnel/ | 943 | 320 | 10 | 10 |  |  | ⟶ Appearance=Filled |
| 12 | VECTOR | ············Union | 945 | 321 | 7 | 8 | #5B5C5B |  |  |
| 8 | INSTANCE | ········#Component/Data Grid/Analytical/Header | 955 | 313 | 157 | 48 | #F1F4F3 | #DDE0DF | ⟶ Appearance=Text, Status=Default, Sort=None, Sortable=No, Checkbox Status=Checked |
| 9 | FRAME | ·········Inner | 955 | 313 | 157 | 48 |  |  |  |
| 10 | FRAME | ··········Header Text | 961 | 327 | 145 | 20 |  |  |  |
| 11 | FRAME | ···········Essential | 961 | 327 | 1 | 18 |  |  |  |
| 12 | VECTOR | ············Dot | 958 | 328 | 4 | 4 | #F94B50 |  |  |
| 11 | TEXT | ···········좌측정렬 텍스트 | 961 | 327 | 145 | 20 | #1F1F1F |  | “Incoterms” |
| 10 | INSTANCE | ··········#Component/Data Grid/Common/Header/Butto | 1082 | 318 | 14 | 14 |  |  | ⟶ Function=More, Status=Default |
| 11 | INSTANCE | ···········Icons/Menu/More/ | 1084 | 320 | 10 | 10 |  |  | ⟶ Direction=Vertical |
| 12 | VECTOR | ············Union | 1088 | 321 | 1 | 8 | #5B5C5B |  |  |
| 10 | INSTANCE | ··········#Component/Data Grid/Common/Header/Butto | 1098 | 318 | 14 | 14 |  |  | ⟶ Function=Filter, Status=Default |
| 11 | INSTANCE | ···········Icons/List/Funnel/ | 1100 | 320 | 10 | 10 |  |  | ⟶ Appearance=Filled |
| 12 | VECTOR | ············Union | 1102 | 321 | 7 | 8 | #5B5C5B |  |  |
| 8 | INSTANCE | ········#Component/Data Grid/Analytical/Header | 1112 | 313 | 157 | 48 | #F1F4F3 | #DDE0DF | ⟶ Appearance=Text, Status=Default, Sort=None, Sortable=No, Checkbox Status=Checked |
| 9 | FRAME | ·········Inner | 1112 | 313 | 157 | 48 |  |  |  |
| 10 | FRAME | ··········Header Text | 1118 | 327 | 145 | 20 |  |  |  |
| 11 | FRAME | ···········Essential | 1118 | 327 | 1 | 18 |  |  |  |
| 12 | VECTOR | ············Dot | 1115 | 328 | 4 | 4 | #F94B50 |  |  |
| 11 | TEXT | ···········좌측정렬 텍스트 | 1118 | 327 | 145 | 20 | #1F1F1F |  | “FCST Type” |
| 10 | INSTANCE | ··········#Component/Data Grid/Common/Header/Butto | 1239 | 318 | 14 | 14 |  |  | ⟶ Function=More, Status=Default |
| 11 | INSTANCE | ···········Icons/Menu/More/ | 1241 | 320 | 10 | 10 |  |  | ⟶ Direction=Vertical |
| 12 | VECTOR | ············Union | 1245 | 321 | 1 | 8 | #5B5C5B |  |  |
| 10 | INSTANCE | ··········#Component/Data Grid/Common/Header/Butto | 1255 | 318 | 14 | 14 |  |  | ⟶ Function=Filter, Status=Default |
| 11 | INSTANCE | ···········Icons/List/Funnel/ | 1257 | 320 | 10 | 10 |  |  | ⟶ Appearance=Filled |
| 12 | VECTOR | ············Union | 1259 | 321 | 7 | 8 | #5B5C5B |  |  |
| 8 | INSTANCE | ········#Component/Data Grid/Analytical/Header | 1269 | 313 | 157 | 48 | #F1F4F3 | #DDE0DF | ⟶ Appearance=Text, Status=Default, Sort=None, Sortable=No, Checkbox Status=Checked |
| 9 | FRAME | ·········Inner | 1269 | 313 | 157 | 48 |  |  |  |
| 10 | FRAME | ··········Header Text | 1275 | 327 | 145 | 20 |  |  |  |
| 11 | FRAME | ···········Essential | 1275 | 327 | 1 | 18 |  |  |  |
| 12 | VECTOR | ············Dot | 1272 | 328 | 4 | 4 | #F94B50 |  |  |
| 11 | TEXT | ···········좌측정렬 텍스트 | 1275 | 327 | 145 | 20 | #1F1F1F |  | “Customs Handbook” |
| 10 | INSTANCE | ··········#Component/Data Grid/Common/Header/Butto | 1396 | 318 | 14 | 14 |  |  | ⟶ Function=More, Status=Default |
| 11 | INSTANCE | ···········Icons/Menu/More/ | 1398 | 320 | 10 | 10 |  |  | ⟶ Direction=Vertical |
| 12 | VECTOR | ············Union | 1402 | 321 | 1 | 8 | #5B5C5B |  |  |
| 10 | INSTANCE | ··········#Component/Data Grid/Common/Header/Butto | 1412 | 318 | 14 | 14 |  |  | ⟶ Function=Filter, Status=Default |
| 11 | INSTANCE | ···········Icons/List/Funnel/ | 1414 | 320 | 10 | 10 |  |  | ⟶ Appearance=Filled |
| 12 | VECTOR | ············Union | 1416 | 321 | 7 | 8 | #5B5C5B |  |  |
| 8 | INSTANCE | ········#Component/Data Grid/Analytical/Header | 1426 | 313 | 157 | 48 | #F1F4F3 | #DDE0DF | ⟶ Appearance=Text, Status=Default, Sort=None, Sortable=No, Checkbox Status=Checked |
| 9 | FRAME | ·········Inner | 1426 | 313 | 157 | 48 |  |  |  |
| 10 | FRAME | ··········Header Text | 1432 | 327 | 145 | 20 |  |  |  |
| 11 | FRAME | ···········Essential | 1432 | 327 | 1 | 18 |  |  |  |
| 12 | VECTOR | ············Dot | 1429 | 328 | 4 | 4 | #F94B50 |  |  |
| 11 | TEXT | ···········좌측정렬 텍스트 | 1432 | 327 | 145 | 20 | #1F1F1F |  | “Currency” |
| 10 | INSTANCE | ··········#Component/Data Grid/Common/Header/Butto | 1553 | 318 | 14 | 14 |  |  | ⟶ Function=More, Status=Default |
| 11 | INSTANCE | ···········Icons/Menu/More/ | 1555 | 320 | 10 | 10 |  |  | ⟶ Direction=Vertical |
| 12 | VECTOR | ············Union | 1559 | 321 | 1 | 8 | #5B5C5B |  |  |
| 10 | INSTANCE | ··········#Component/Data Grid/Common/Header/Butto | 1569 | 318 | 14 | 14 |  |  | ⟶ Function=Filter, Status=Default |
| 11 | INSTANCE | ···········Icons/List/Funnel/ | 1571 | 320 | 10 | 10 |  |  | ⟶ Appearance=Filled |
| 12 | VECTOR | ············Union | 1573 | 321 | 7 | 8 | #5B5C5B |  |  |
| 8 | INSTANCE | ········#Component/Data Grid/Analytical/Header | 1583 | 313 | 157 | 48 | #F1F4F3 | #DDE0DF | ⟶ Appearance=Text, Status=Default, Sort=None, Sortable=No, Checkbox Status=Checked |
| 9 | FRAME | ·········Inner | 1583 | 313 | 157 | 48 |  |  |  |
| 10 | FRAME | ··········Header Text | 1589 | 327 | 145 | 20 |  |  |  |
| 11 | FRAME | ···········Essential | 1589 | 327 | 1 | 18 |  |  |  |
| 12 | VECTOR | ············Dot | 1586 | 328 | 4 | 4 | #F94B50 |  |  |
| 11 | TEXT | ···········좌측정렬 텍스트 | 1589 | 327 | 145 | 20 | #1F1F1F |  | “Price Exist” |
| 10 | INSTANCE | ··········#Component/Data Grid/Common/Header/Butto | 1710 | 318 | 14 | 14 |  |  | ⟶ Function=More, Status=Default |
| 11 | INSTANCE | ···········Icons/Menu/More/ | 1712 | 320 | 10 | 10 |  |  | ⟶ Direction=Vertical |
| 12 | VECTOR | ············Union | 1716 | 321 | 1 | 8 | #5B5C5B |  |  |
| 10 | INSTANCE | ··········#Component/Data Grid/Common/Header/Butto | 1726 | 318 | 14 | 14 |  |  | ⟶ Function=Filter, Status=Default |
| 11 | INSTANCE | ···········Icons/List/Funnel/ | 1728 | 320 | 10 | 10 |  |  | ⟶ Appearance=Filled |
| 12 | VECTOR | ············Union | 1730 | 321 | 7 | 8 | #5B5C5B |  |  |
| 8 | INSTANCE | ········#Component/Data Grid/Analytical/Header | 1740 | 313 | 157 | 48 | #F1F4F3 | #DDE0DF | ⟶ Appearance=Text, Status=Default, Sort=None, Sortable=No, Checkbox Status=Checked |
| 9 | FRAME | ·········Inner | 1740 | 313 | 157 | 48 |  |  |  |
| 10 | FRAME | ··········Header Text | 1746 | 327 | 145 | 20 |  |  |  |
| 11 | FRAME | ···········Essential | 1746 | 327 | 1 | 18 |  |  |  |
| 12 | VECTOR | ············Dot | 1743 | 328 | 4 | 4 | #F94B50 |  |  |
| 11 | TEXT | ···········좌측정렬 텍스트 | 1746 | 327 | 145 | 20 | #1F1F1F |  | “Measure” |
| 10 | INSTANCE | ··········#Component/Data Grid/Common/Header/Butto | 1867 | 318 | 14 | 14 |  |  | ⟶ Function=More, Status=Default |
| 11 | INSTANCE | ···········Icons/Menu/More/ | 1869 | 320 | 10 | 10 |  |  | ⟶ Direction=Vertical |
| 12 | VECTOR | ············Union | 1873 | 321 | 1 | 8 | #5B5C5B |  |  |
| 10 | INSTANCE | ··········#Component/Data Grid/Common/Header/Butto | 1883 | 318 | 14 | 14 |  |  | ⟶ Function=Filter, Status=Default |
| 11 | INSTANCE | ···········Icons/List/Funnel/ | 1885 | 320 | 10 | 10 |  |  | ⟶ Appearance=Filled |
| 12 | VECTOR | ············Union | 1887 | 321 | 7 | 8 | #5B5C5B |  |  |
| 8 | FRAME | ········Header | 1897 | 313 | 157 | 48 |  |  |  |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Header | 1897 | 313 | 157 | 24 | #F1F4F3 | #DDE0DF | ⟶ Appearance=Text, Status=Default, Sort=None, Sortable=No, Checkbox Status=Checked |
| 10 | FRAME | ··········Inner | 1897 | 313 | 157 | 24 |  |  |  |
| 11 | FRAME | ···········Header Text | 1903 | 315 | 145 | 20 |  |  |  |
| 12 | FRAME | ············Essential | 1903 | 315 | 1 | 18 |  |  |  |
| 13 | VECTOR | ·············Dot | 1900 | 316 | 4 | 4 | #F94B50 |  |  |
| 12 | TEXT | ············좌측정렬 텍스트 | 1903 | 315 | 145 | 20 | #1F1F1F |  | “2026-03” |
| 11 | INSTANCE | ···········#Component/Data Grid/Common/Header/Butto | 2024 | 318 | 14 | 14 |  |  | ⟶ Function=More, Status=Default |
| 12 | INSTANCE | ············Icons/Menu/More/ | 2026 | 320 | 10 | 10 |  |  | ⟶ Direction=Vertical |
| 13 | VECTOR | ·············Union | 2030 | 321 | 1 | 8 | #5B5C5B |  |  |
| 11 | INSTANCE | ···········#Component/Data Grid/Common/Header/Butto | 2040 | 318 | 14 | 14 |  |  | ⟶ Function=Filter, Status=Default |
| 12 | INSTANCE | ············Icons/List/Funnel/ | 2042 | 320 | 10 | 10 |  |  | ⟶ Appearance=Filled |
| 13 | VECTOR | ·············Union | 2044 | 321 | 7 | 8 | #5B5C5B |  |  |
| 9 | FRAME | ·········2nd | 1897 | 337 | 157 | 24 |  |  |  |
| 10 | INSTANCE | ··········#Component/Data Grid/Analytical/Header | 1897 | 337 | 157 | 24 | #F1F4F3 | #DDE0DF | ⟶ Appearance=Text, Status=Default, Sort=None, Sortable=No, Checkbox Status=Checked |
| 11 | FRAME | ···········Inner | 1897 | 337 | 157 | 24 |  |  |  |
| 12 | FRAME | ············Header Text | 1903 | 339 | 145 | 20 |  |  |  |
| 13 | FRAME | ·············Essential | 1903 | 339 | 1 | 18 |  |  |  |
| 14 | VECTOR | ··············Dot | 1900 | 340 | 4 | 4 | #F94B50 |  |  |
| 13 | TEXT | ·············좌측정렬 텍스트 | 1903 | 339 | 145 | 20 | #1F1F1F |  | “SUM” |
| 12 | INSTANCE | ············#Component/Data Grid/Common/Header/Butto | 2024 | 342 | 14 | 14 |  |  | ⟶ Function=More, Status=Default |
| 13 | INSTANCE | ·············Icons/Menu/More/ | 2026 | 344 | 10 | 10 |  |  | ⟶ Direction=Vertical |
| 14 | VECTOR | ··············Union | 2030 | 345 | 1 | 8 | #5B5C5B |  |  |
| 12 | INSTANCE | ············#Component/Data Grid/Common/Header/Butto | 2040 | 342 | 14 | 14 |  |  | ⟶ Function=Filter, Status=Default |
| 13 | INSTANCE | ·············Icons/List/Funnel/ | 2042 | 344 | 10 | 10 |  |  | ⟶ Appearance=Filled |
| 14 | VECTOR | ··············Union | 2044 | 345 | 7 | 8 | #5B5C5B |  |  |
| 8 | FRAME | ········Header | 2054 | 313 | 157 | 48 |  |  |  |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Header | 2054 | 313 | 157 | 24 | #F1F4F3 | #DDE0DF | ⟶ Appearance=Text, Status=Default, Sort=None, Sortable=No, Checkbox Status=Checked |
| 10 | FRAME | ··········Inner | 2054 | 313 | 157 | 24 |  |  |  |
| 11 | FRAME | ···········Header Text | 2060 | 315 | 145 | 20 |  |  |  |
| 12 | FRAME | ············Essential | 2060 | 315 | 1 | 18 |  |  |  |
| 13 | VECTOR | ·············Dot | 2057 | 316 | 4 | 4 | #F94B50 |  |  |
| 12 | TEXT | ············좌측정렬 텍스트 | 2060 | 315 | 145 | 20 | #1F1F1F |  | “2026-04” |
| 11 | INSTANCE | ···········#Component/Data Grid/Common/Header/Butto | 2181 | 318 | 14 | 14 |  |  | ⟶ Function=More, Status=Default |
| 12 | INSTANCE | ············Icons/Menu/More/ | 2183 | 320 | 10 | 10 |  |  | ⟶ Direction=Vertical |
| 13 | VECTOR | ·············Union | 2187 | 321 | 1 | 8 | #5B5C5B |  |  |
| 11 | INSTANCE | ···········#Component/Data Grid/Common/Header/Butto | 2197 | 318 | 14 | 14 |  |  | ⟶ Function=Filter, Status=Default |
| 12 | INSTANCE | ············Icons/List/Funnel/ | 2199 | 320 | 10 | 10 |  |  | ⟶ Appearance=Filled |
| 13 | VECTOR | ·············Union | 2201 | 321 | 7 | 8 | #5B5C5B |  |  |
| 9 | FRAME | ·········2nd | 2054 | 337 | 157 | 24 |  |  |  |
| 10 | INSTANCE | ··········#Component/Data Grid/Analytical/Header | 2054 | 337 | 157 | 24 | #F1F4F3 | #DDE0DF | ⟶ Appearance=Text, Status=Default, Sort=None, Sortable=No, Checkbox Status=Checked |
| 11 | FRAME | ···········Inner | 2054 | 337 | 157 | 24 |  |  |  |
| 12 | FRAME | ············Header Text | 2060 | 339 | 145 | 20 |  |  |  |
| 13 | FRAME | ·············Essential | 2060 | 339 | 1 | 18 |  |  |  |
| 14 | VECTOR | ··············Dot | 2057 | 340 | 4 | 4 | #F94B50 |  |  |
| 13 | TEXT | ·············좌측정렬 텍스트 | 2060 | 339 | 145 | 20 | #1F1F1F |  | “SUM” |
| 12 | INSTANCE | ············#Component/Data Grid/Common/Header/Butto | 2181 | 342 | 14 | 14 |  |  | ⟶ Function=More, Status=Default |
| 13 | INSTANCE | ·············Icons/Menu/More/ | 2183 | 344 | 10 | 10 |  |  | ⟶ Direction=Vertical |
| 14 | VECTOR | ··············Union | 2187 | 345 | 1 | 8 | #5B5C5B |  |  |
| 12 | INSTANCE | ············#Component/Data Grid/Common/Header/Butto | 2197 | 342 | 14 | 14 |  |  | ⟶ Function=Filter, Status=Default |
| 13 | INSTANCE | ·············Icons/List/Funnel/ | 2199 | 344 | 10 | 10 |  |  | ⟶ Appearance=Filled |
| 14 | VECTOR | ··············Union | 2201 | 345 | 7 | 8 | #5B5C5B |  |  |
| 8 | FRAME | ········Header | 2211 | 313 | 157 | 48 |  |  |  |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Header | 2211 | 313 | 157 | 24 | #F1F4F3 | #DDE0DF | ⟶ Appearance=Text, Status=Default, Sort=None, Sortable=No, Checkbox Status=Checked |
| 10 | FRAME | ··········Inner | 2211 | 313 | 157 | 24 |  |  |  |
| 11 | FRAME | ···········Header Text | 2217 | 315 | 145 | 20 |  |  |  |
| 12 | FRAME | ············Essential | 2217 | 315 | 1 | 18 |  |  |  |
| 13 | VECTOR | ·············Dot | 2214 | 316 | 4 | 4 | #F94B50 |  |  |
| 12 | TEXT | ············좌측정렬 텍스트 | 2217 | 315 | 145 | 20 | #1F1F1F |  | “2026-05” |
| 11 | INSTANCE | ···········#Component/Data Grid/Common/Header/Butto | 2338 | 318 | 14 | 14 |  |  | ⟶ Function=More, Status=Default |
| 12 | INSTANCE | ············Icons/Menu/More/ | 2340 | 320 | 10 | 10 |  |  | ⟶ Direction=Vertical |
| 13 | VECTOR | ·············Union | 2344 | 321 | 1 | 8 | #5B5C5B |  |  |
| 11 | INSTANCE | ···········#Component/Data Grid/Common/Header/Butto | 2354 | 318 | 14 | 14 |  |  | ⟶ Function=Filter, Status=Default |
| 12 | INSTANCE | ············Icons/List/Funnel/ | 2356 | 320 | 10 | 10 |  |  | ⟶ Appearance=Filled |
| 13 | VECTOR | ·············Union | 2358 | 321 | 7 | 8 | #5B5C5B |  |  |
| 9 | FRAME | ·········2nd | 2211 | 337 | 157 | 24 |  |  |  |
| 10 | INSTANCE | ··········#Component/Data Grid/Analytical/Header | 2211 | 337 | 157 | 24 | #F1F4F3 | #DDE0DF | ⟶ Appearance=Text, Status=Default, Sort=None, Sortable=No, Checkbox Status=Checked |
| 11 | FRAME | ···········Inner | 2211 | 337 | 157 | 24 |  |  |  |
| 12 | FRAME | ············Header Text | 2217 | 339 | 145 | 20 |  |  |  |
| 13 | FRAME | ·············Essential | 2217 | 339 | 1 | 18 |  |  |  |
| 14 | VECTOR | ··············Dot | 2214 | 340 | 4 | 4 | #F94B50 |  |  |
| 13 | TEXT | ·············좌측정렬 텍스트 | 2217 | 339 | 145 | 20 | #1F1F1F |  | “SUM” |
| 12 | INSTANCE | ············#Component/Data Grid/Common/Header/Butto | 2338 | 342 | 14 | 14 |  |  | ⟶ Function=More, Status=Default |
| 13 | INSTANCE | ·············Icons/Menu/More/ | 2340 | 344 | 10 | 10 |  |  | ⟶ Direction=Vertical |
| 14 | VECTOR | ··············Union | 2344 | 345 | 1 | 8 | #5B5C5B |  |  |
| 12 | INSTANCE | ············#Component/Data Grid/Common/Header/Butto | 2354 | 342 | 14 | 14 |  |  | ⟶ Function=Filter, Status=Default |
| 13 | INSTANCE | ·············Icons/List/Funnel/ | 2356 | 344 | 10 | 10 |  |  | ⟶ Appearance=Filled |
| 14 | VECTOR | ··············Union | 2358 | 345 | 7 | 8 | #5B5C5B |  |  |
| 8 | FRAME | ········Header | 2368 | 313 | 157 | 48 |  |  |  |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Header | 2368 | 313 | 157 | 24 | #F1F4F3 | #DDE0DF | ⟶ Appearance=Text, Status=Default, Sort=None, Sortable=No, Checkbox Status=Checked |
| 10 | FRAME | ··········Inner | 2368 | 313 | 157 | 24 |  |  |  |
| 11 | FRAME | ···········Header Text | 2374 | 315 | 145 | 20 |  |  |  |
| 12 | FRAME | ············Essential | 2374 | 315 | 1 | 18 |  |  |  |
| 13 | VECTOR | ·············Dot | 2371 | 316 | 4 | 4 | #F94B50 |  |  |
| 12 | TEXT | ············좌측정렬 텍스트 | 2374 | 315 | 145 | 20 | #1F1F1F |  | “2026-06” |
| 11 | INSTANCE | ···········#Component/Data Grid/Common/Header/Butto | 2495 | 318 | 14 | 14 |  |  | ⟶ Function=More, Status=Default |
| 12 | INSTANCE | ············Icons/Menu/More/ | 2497 | 320 | 10 | 10 |  |  | ⟶ Direction=Vertical |
| 13 | VECTOR | ·············Union | 2501 | 321 | 1 | 8 | #5B5C5B |  |  |
| 11 | INSTANCE | ···········#Component/Data Grid/Common/Header/Butto | 2511 | 318 | 14 | 14 |  |  | ⟶ Function=Filter, Status=Default |
| 12 | INSTANCE | ············Icons/List/Funnel/ | 2513 | 320 | 10 | 10 |  |  | ⟶ Appearance=Filled |
| 13 | VECTOR | ·············Union | 2515 | 321 | 7 | 8 | #5B5C5B |  |  |
| 9 | FRAME | ·········2nd | 2368 | 337 | 157 | 24 |  |  |  |
| 10 | INSTANCE | ··········#Component/Data Grid/Analytical/Header | 2368 | 337 | 157 | 24 | #F1F4F3 | #DDE0DF | ⟶ Appearance=Text, Status=Default, Sort=None, Sortable=No, Checkbox Status=Checked |
| 11 | FRAME | ···········Inner | 2368 | 337 | 157 | 24 |  |  |  |
| 12 | FRAME | ············Header Text | 2374 | 339 | 145 | 20 |  |  |  |
| 13 | FRAME | ·············Essential | 2374 | 339 | 1 | 18 |  |  |  |
| 14 | VECTOR | ··············Dot | 2371 | 340 | 4 | 4 | #F94B50 |  |  |
| 13 | TEXT | ·············좌측정렬 텍스트 | 2374 | 339 | 145 | 20 | #1F1F1F |  | “SUM” |
| 12 | INSTANCE | ············#Component/Data Grid/Common/Header/Butto | 2495 | 342 | 14 | 14 |  |  | ⟶ Function=More, Status=Default |
| 13 | INSTANCE | ·············Icons/Menu/More/ | 2497 | 344 | 10 | 10 |  |  | ⟶ Direction=Vertical |
| 14 | VECTOR | ··············Union | 2501 | 345 | 1 | 8 | #5B5C5B |  |  |
| 12 | INSTANCE | ············#Component/Data Grid/Common/Header/Butto | 2511 | 342 | 14 | 14 |  |  | ⟶ Function=Filter, Status=Default |
| 13 | INSTANCE | ·············Icons/List/Funnel/ | 2513 | 344 | 10 | 10 |  |  | ⟶ Appearance=Filled |
| 14 | VECTOR | ··············Union | 2515 | 345 | 7 | 8 | #5B5C5B |  |  |
| 8 | FRAME | ········Header | 2525 | 313 | 157 | 48 |  |  |  |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Header | 2525 | 313 | 157 | 24 | #F1F4F3 | #DDE0DF | ⟶ Appearance=Text, Status=Default, Sort=None, Sortable=No, Checkbox Status=Checked |
| 10 | FRAME | ··········Inner | 2525 | 313 | 157 | 24 |  |  |  |
| 11 | FRAME | ···········Header Text | 2531 | 315 | 145 | 20 |  |  |  |
| 12 | FRAME | ············Essential | 2531 | 315 | 1 | 18 |  |  |  |
| 13 | VECTOR | ·············Dot | 2528 | 316 | 4 | 4 | #F94B50 |  |  |
| 12 | TEXT | ············좌측정렬 텍스트 | 2531 | 315 | 145 | 20 | #1F1F1F |  | “2026-07” |
| 11 | INSTANCE | ···········#Component/Data Grid/Common/Header/Butto | 2652 | 318 | 14 | 14 |  |  | ⟶ Function=More, Status=Default |
| 12 | INSTANCE | ············Icons/Menu/More/ | 2654 | 320 | 10 | 10 |  |  | ⟶ Direction=Vertical |
| 13 | VECTOR | ·············Union | 2658 | 321 | 1 | 8 | #5B5C5B |  |  |
| 11 | INSTANCE | ···········#Component/Data Grid/Common/Header/Butto | 2668 | 318 | 14 | 14 |  |  | ⟶ Function=Filter, Status=Default |
| 12 | INSTANCE | ············Icons/List/Funnel/ | 2670 | 320 | 10 | 10 |  |  | ⟶ Appearance=Filled |
| 13 | VECTOR | ·············Union | 2672 | 321 | 7 | 8 | #5B5C5B |  |  |
| 9 | FRAME | ·········2nd | 2525 | 337 | 157 | 24 |  |  |  |
| 10 | INSTANCE | ··········#Component/Data Grid/Analytical/Header | 2525 | 337 | 157 | 24 | #F1F4F3 | #DDE0DF | ⟶ Appearance=Text, Status=Default, Sort=None, Sortable=No, Checkbox Status=Checked |
| 11 | FRAME | ···········Inner | 2525 | 337 | 157 | 24 |  |  |  |
| 12 | FRAME | ············Header Text | 2531 | 339 | 145 | 20 |  |  |  |
| 13 | FRAME | ·············Essential | 2531 | 339 | 1 | 18 |  |  |  |
| 14 | VECTOR | ··············Dot | 2528 | 340 | 4 | 4 | #F94B50 |  |  |
| 13 | TEXT | ·············좌측정렬 텍스트 | 2531 | 339 | 145 | 20 | #1F1F1F |  | “SUM” |
| 12 | INSTANCE | ············#Component/Data Grid/Common/Header/Butto | 2652 | 342 | 14 | 14 |  |  | ⟶ Function=More, Status=Default |
| 13 | INSTANCE | ·············Icons/Menu/More/ | 2654 | 344 | 10 | 10 |  |  | ⟶ Direction=Vertical |
| 14 | VECTOR | ··············Union | 2658 | 345 | 1 | 8 | #5B5C5B |  |  |
| 12 | INSTANCE | ············#Component/Data Grid/Common/Header/Butto | 2668 | 342 | 14 | 14 |  |  | ⟶ Function=Filter, Status=Default |
| 13 | INSTANCE | ·············Icons/List/Funnel/ | 2670 | 344 | 10 | 10 |  |  | ⟶ Appearance=Filled |
| 14 | VECTOR | ··············Union | 2672 | 345 | 7 | 8 | #5B5C5B |  |  |
| 8 | FRAME | ········Header | 2682 | 313 | 157 | 48 |  |  |  |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Header | 2682 | 313 | 157 | 24 | #F1F4F3 | #DDE0DF | ⟶ Appearance=Text, Status=Default, Sort=None, Sortable=No, Checkbox Status=Checked |
| 10 | FRAME | ··········Inner | 2682 | 313 | 157 | 24 |  |  |  |
| 11 | FRAME | ···········Header Text | 2688 | 315 | 145 | 20 |  |  |  |
| 12 | FRAME | ············Essential | 2688 | 315 | 1 | 18 |  |  |  |
| 13 | VECTOR | ·············Dot | 2685 | 316 | 4 | 4 | #F94B50 |  |  |
| 12 | TEXT | ············좌측정렬 텍스트 | 2688 | 315 | 145 | 20 | #1F1F1F |  | “2026-08” |
| 11 | INSTANCE | ···········#Component/Data Grid/Common/Header/Butto | 2809 | 318 | 14 | 14 |  |  | ⟶ Function=More, Status=Default |
| 12 | INSTANCE | ············Icons/Menu/More/ | 2811 | 320 | 10 | 10 |  |  | ⟶ Direction=Vertical |
| 13 | VECTOR | ·············Union | 2815 | 321 | 1 | 8 | #5B5C5B |  |  |
| 11 | INSTANCE | ···········#Component/Data Grid/Common/Header/Butto | 2825 | 318 | 14 | 14 |  |  | ⟶ Function=Filter, Status=Default |
| 12 | INSTANCE | ············Icons/List/Funnel/ | 2827 | 320 | 10 | 10 |  |  | ⟶ Appearance=Filled |
| 13 | VECTOR | ·············Union | 2829 | 321 | 7 | 8 | #5B5C5B |  |  |
| 9 | FRAME | ·········2nd | 2682 | 337 | 157 | 24 |  |  |  |
| 10 | INSTANCE | ··········#Component/Data Grid/Analytical/Header | 2682 | 337 | 157 | 24 | #F1F4F3 | #DDE0DF | ⟶ Appearance=Text, Status=Default, Sort=None, Sortable=No, Checkbox Status=Checked |
| 11 | FRAME | ···········Inner | 2682 | 337 | 157 | 24 |  |  |  |
| 12 | FRAME | ············Header Text | 2688 | 339 | 145 | 20 |  |  |  |
| 13 | FRAME | ·············Essential | 2688 | 339 | 1 | 18 |  |  |  |
| 14 | VECTOR | ··············Dot | 2685 | 340 | 4 | 4 | #F94B50 |  |  |
| 13 | TEXT | ·············좌측정렬 텍스트 | 2688 | 339 | 145 | 20 | #1F1F1F |  | “SUM” |
| 12 | INSTANCE | ············#Component/Data Grid/Common/Header/Butto | 2809 | 342 | 14 | 14 |  |  | ⟶ Function=More, Status=Default |
| 13 | INSTANCE | ·············Icons/Menu/More/ | 2811 | 344 | 10 | 10 |  |  | ⟶ Direction=Vertical |
| 14 | VECTOR | ··············Union | 2815 | 345 | 1 | 8 | #5B5C5B |  |  |
| 12 | INSTANCE | ············#Component/Data Grid/Common/Header/Butto | 2825 | 342 | 14 | 14 |  |  | ⟶ Function=Filter, Status=Default |
| 13 | INSTANCE | ·············Icons/List/Funnel/ | 2827 | 344 | 10 | 10 |  |  | ⟶ Appearance=Filled |
| 14 | VECTOR | ··············Union | 2829 | 345 | 7 | 8 | #5B5C5B |  |  |
| 6 | FRAME | ······Body | 262 | 361 | 2577 | 675 |  |  |  |
| 7 | FRAME | ·······RowBG | 262 | 361 | 2577 | 1175 |  |  |  |
| 8 | FRAME | ········RowBG | 262 | 361 | 40 | 1155 |  |  |  |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 361 | 40 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 386 | 40 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 411 | 40 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 436 | 40 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 461 | 40 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 486 | 40 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 511 | 40 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 536 | 40 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 561 | 40 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 586 | 40 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 611 | 40 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 636 | 40 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 661 | 40 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 686 | 40 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 711 | 40 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 736 | 40 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 761 | 40 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 786 | 40 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 811 | 40 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 836 | 40 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 861 | 40 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 886 | 40 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 911 | 40 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 936 | 40 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 961 | 40 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 986 | 40 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 1011 | 40 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 1036 | 40 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 1061 | 40 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 1086 | 40 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 1111 | 40 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 1136 | 40 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 1161 | 40 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 1186 | 40 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 1211 | 40 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 1236 | 40 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 1261 | 40 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 1286 | 40 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 1311 | 40 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 1336 | 40 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 1361 | 40 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 1386 | 40 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 1411 | 40 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 1436 | 40 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 1461 | 40 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 1486 | 40 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 262 | 1511 | 40 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 8 | FRAME | ········RowBG | 302 | 361 | 2577 | 1155 |  |  |  |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 361 | 2577 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 386 | 2577 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 411 | 2577 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 436 | 2577 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 461 | 2577 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 486 | 2577 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 511 | 2577 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 536 | 2577 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 561 | 2577 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 586 | 2577 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 611 | 2577 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 636 | 2577 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 661 | 2577 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 686 | 2577 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 711 | 2577 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 736 | 2577 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 761 | 2577 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 786 | 2577 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 811 | 2577 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 836 | 2577 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 861 | 2577 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 886 | 2577 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 911 | 2577 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 936 | 2577 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 961 | 2577 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 986 | 2577 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 1011 | 2577 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 1036 | 2577 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 1061 | 2577 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 1086 | 2577 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 1111 | 2577 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 1136 | 2577 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 1161 | 2577 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 1186 | 2577 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 1211 | 2577 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 1236 | 2577 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 1261 | 2577 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 1286 | 2577 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 1311 | 2577 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 1336 | 2577 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 1361 | 2577 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 1386 | 2577 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 1411 | 2577 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 1436 | 2577 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 1461 | 2577 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 1486 | 2577 | 25 | #F7F9F8 | #F1F4F3 | ⟶ Type=Odd-Row |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/RowBG | 302 | 1511 | 2577 | 25 | #FFFFFF | #F1F4F3 | ⟶ Type=Basic |
| 7 | FRAME | ·······Cols | 262 | 361 | 2577 | 675 |  |  |  |
| 8 | FRAME | ········Col | 262 | 361 | 40 | 675 |  |  |  |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 262 | 361 | 40 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 262 | 361 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 262 | 361 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 262 | 361 | 40 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 268 | 363 | 28 | 20 | #1F1F1F |  | “1​” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 262 | 386 | 40 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 262 | 386 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 262 | 386 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 262 | 386 | 40 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 268 | 388 | 28 | 20 | #1F1F1F |  | “2” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 262 | 411 | 40 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 262 | 411 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 262 | 411 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 262 | 411 | 40 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 268 | 413 | 28 | 20 | #1F1F1F |  | “3​” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 262 | 436 | 40 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 262 | 436 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 262 | 436 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 262 | 436 | 40 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 268 | 438 | 28 | 20 | #1F1F1F |  | “4” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 262 | 461 | 40 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 262 | 461 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 262 | 461 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 262 | 461 | 40 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 268 | 463 | 28 | 20 | #1F1F1F |  | “5” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 262 | 486 | 40 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 262 | 486 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 262 | 486 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 262 | 486 | 40 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 268 | 488 | 28 | 20 | #1F1F1F |  | “6” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 262 | 511 | 40 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 262 | 511 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 262 | 511 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 262 | 511 | 40 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 268 | 513 | 28 | 20 | #1F1F1F |  | “7” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 262 | 536 | 40 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 262 | 536 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 262 | 536 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 262 | 536 | 40 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 268 | 538 | 28 | 20 | #1F1F1F |  | “8” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 262 | 561 | 40 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 262 | 561 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 262 | 561 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 262 | 561 | 40 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 268 | 563 | 28 | 20 | #1F1F1F |  | “9” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 262 | 586 | 40 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 262 | 586 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 262 | 586 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 262 | 586 | 40 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 268 | 588 | 28 | 20 | #1F1F1F |  | “10” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 262 | 611 | 40 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 262 | 611 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 262 | 611 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 262 | 611 | 40 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 268 | 613 | 28 | 20 | #1F1F1F |  | “11” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 262 | 636 | 40 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 262 | 636 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 262 | 636 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 262 | 636 | 40 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 268 | 638 | 28 | 20 | #1F1F1F |  | “12” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 262 | 661 | 40 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 262 | 661 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 262 | 661 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 262 | 661 | 40 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 268 | 663 | 28 | 20 | #1F1F1F |  | “13” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 262 | 686 | 40 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 262 | 686 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 262 | 686 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 262 | 686 | 40 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 268 | 688 | 28 | 20 | #1F1F1F |  | “14” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 262 | 711 | 40 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 262 | 711 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 262 | 711 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 262 | 711 | 40 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 268 | 713 | 28 | 20 | #1F1F1F |  | “15” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 262 | 736 | 40 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 262 | 736 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 262 | 736 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 262 | 736 | 40 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 268 | 738 | 28 | 20 | #1F1F1F |  | “16” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 262 | 761 | 40 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 262 | 761 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 262 | 761 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 262 | 761 | 40 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 268 | 763 | 28 | 20 | #1F1F1F |  | “17” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 262 | 786 | 40 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 262 | 786 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 262 | 786 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 262 | 786 | 40 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 268 | 788 | 28 | 20 | #1F1F1F |  | “18” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 262 | 811 | 40 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 262 | 811 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 262 | 811 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 262 | 811 | 40 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 268 | 813 | 28 | 20 | #1F1F1F |  | “19” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 262 | 836 | 40 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 262 | 836 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 262 | 836 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 262 | 836 | 40 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 268 | 838 | 28 | 20 | #1F1F1F |  | “20” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 262 | 861 | 40 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 262 | 861 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 262 | 861 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 262 | 861 | 40 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 268 | 863 | 28 | 20 | #1F1F1F |  | “21” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 262 | 886 | 40 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 262 | 886 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 262 | 886 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 262 | 886 | 40 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 268 | 888 | 28 | 20 | #1F1F1F |  | “22” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 262 | 911 | 40 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 262 | 911 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 262 | 911 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 262 | 911 | 40 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 268 | 913 | 28 | 20 | #1F1F1F |  | “23” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 262 | 936 | 40 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 262 | 936 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 262 | 936 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 262 | 936 | 40 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 268 | 938 | 28 | 20 | #1F1F1F |  | “24” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 262 | 961 | 40 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 262 | 961 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 262 | 961 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 262 | 961 | 40 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 268 | 963 | 28 | 20 | #1F1F1F |  | “25” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 262 | 986 | 40 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 262 | 986 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 262 | 986 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 262 | 986 | 40 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 268 | 988 | 28 | 20 | #1F1F1F |  | “26” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 262 | 1011 | 40 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 262 | 1011 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 262 | 1011 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 262 | 1011 | 40 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 268 | 1013 | 28 | 20 | #1F1F1F |  | “27” |
| 8 | FRAME | ········Col | 302 | 361 | 56 | 672 |  |  |  |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 302 | 361 | 56 | 672 | #F7F9F8 | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 302 | 361 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 302 | 361 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 302 | 361 | 56 | 672 |  |  |  |
| 11 | TEXT | ···········텍스트 | 308 | 687 | 44 | 20 | #1F1F1F |  | “40” |
| 8 | FRAME | ········Col | 358 | 361 | 140 | 672 | #F7F9F8 |  |  |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 358 | 361 | 140 | 672 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 358 | 361 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 358 | 361 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 358 | 361 | 140 | 672 |  |  |  |
| 11 | TEXT | ···········텍스트 | 364 | 687 | 128 | 20 | #1F1F1F |  | “소형. 마케팅 2.” |
| 8 | FRAME | ········Col | 498 | 361 | 140 | 672 | #F7F9F8 |  |  |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 498 | 361 | 140 | 672 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 498 | 361 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 498 | 361 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 498 | 361 | 140 | 672 |  |  |  |
| 11 | TEXT | ···········텍스트 | 504 | 687 | 128 | 20 | #1F1F1F |  | “NT” |
| 8 | FRAME | ········Col | 638 | 361 | 160 | 650 |  |  |  |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 638 | 361 | 160 | 275 | #F7F9F8 | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 638 | 361 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 638 | 361 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 638 | 361 | 160 | 275 |  |  |  |
| 11 | TEXT | ···········텍스트 | 644 | 488 | 148 | 20 | #1F1F1F |  | “Desay_CN_HUI” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 638 | 637 | 160 | 374 | #F7F9F8 | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 638 | 637 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 638 | 637 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 638 | 637 | 160 | 374 |  |  |  |
| 11 | TEXT | ···········텍스트 | 644 | 814 | 148 | 20 | #1F1F1F |  | “Foxlink_CN_DGG” |
| 8 | FRAME | ········Col | 798 | 361 | 157 | 674 |  |  |  |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 798 | 361 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 798 | 361 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 798 | 361 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 798 | 361 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 804 | 363 | 145 | 20 | #1F1F1F |  | “MDP2949A9B11” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 798 | 386 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 798 | 386 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 798 | 386 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 798 | 386 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 804 | 388 | 145 | 20 | #1F1F1F |  | “MDP2949A9F11” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 798 | 411 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 798 | 411 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 798 | 411 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 798 | 411 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 804 | 413 | 145 | 20 | #1F1F1F |  | “MDP2949A9G11” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 798 | 436 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 798 | 436 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 798 | 436 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 798 | 436 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 804 | 438 | 145 | 20 | #1F1F1F |  | “MDP2949A9C11” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 798 | 461 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 798 | 461 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 798 | 461 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 798 | 461 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 804 | 463 | 145 | 20 | #1F1F1F |  | “MDP2949A9E11” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 798 | 486 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 798 | 486 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 798 | 486 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 798 | 486 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 804 | 488 | 145 | 20 | #1F1F1F |  | “MDP2949A9H11” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 798 | 511 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 798 | 511 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 798 | 511 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 798 | 511 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 804 | 513 | 145 | 20 | #1F1F1F |  | “MDP2949A9I11” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 798 | 536 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 798 | 536 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 798 | 536 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 798 | 536 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 804 | 538 | 145 | 20 | #1F1F1F |  | “MDP2949A9J11” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 798 | 561 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 798 | 561 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 798 | 561 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 798 | 561 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 804 | 563 | 145 | 20 | #1F1F1F |  | “MDP2949A9K11” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 798 | 586 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 798 | 586 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 798 | 586 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 798 | 586 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 804 | 588 | 145 | 20 | #1F1F1F |  | “MDP2949A9L11” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 798 | 611 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 798 | 611 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 798 | 611 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 798 | 611 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 804 | 613 | 145 | 20 | #1F1F1F |  | “MDP2949A9M11” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 798 | 636 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 798 | 636 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 798 | 636 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 798 | 636 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 804 | 638 | 145 | 20 | #1F1F1F |  | “MDP2949A9N11” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 798 | 661 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 798 | 661 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 798 | 661 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 798 | 661 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 804 | 663 | 145 | 20 | #1F1F1F |  | “MDP2949A9O11” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 798 | 686 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 798 | 686 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 798 | 686 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 798 | 686 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 804 | 688 | 145 | 20 | #1F1F1F |  | “MDP2949A9P11” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 798 | 711 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 798 | 711 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 798 | 711 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 798 | 711 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 804 | 713 | 145 | 20 | #1F1F1F |  | “MDP2949A9Q11” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 798 | 736 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 798 | 736 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 798 | 736 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 798 | 736 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 804 | 738 | 145 | 20 | #1F1F1F |  | “MDP2949A9R11” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 798 | 761 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 798 | 761 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 798 | 761 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 798 | 761 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 804 | 763 | 145 | 20 | #1F1F1F |  | “MDP2949A9S11” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 798 | 786 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 798 | 786 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 798 | 786 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 798 | 786 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 804 | 788 | 145 | 20 | #1F1F1F |  | “MDP2949A9T11” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 798 | 811 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 798 | 811 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 798 | 811 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 798 | 811 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 804 | 813 | 145 | 20 | #1F1F1F |  | “MDP2949A9U11” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 798 | 836 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 798 | 836 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 798 | 836 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 798 | 836 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 804 | 838 | 145 | 20 | #1F1F1F |  | “MDP2949A9V11” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 798 | 861 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 798 | 861 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 798 | 861 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 798 | 861 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 804 | 863 | 145 | 20 | #1F1F1F |  | “MDP2949A9W11” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 798 | 886 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 798 | 886 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 798 | 886 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 798 | 886 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 804 | 888 | 145 | 20 | #1F1F1F |  | “MDP2949A9X11” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 798 | 911 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 798 | 911 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 798 | 911 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 798 | 911 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 804 | 913 | 145 | 20 | #1F1F1F |  | “MDP2949A9Y11” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 798 | 936 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 798 | 936 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 798 | 936 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 798 | 936 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 804 | 938 | 145 | 20 | #1F1F1F |  | “MDP2949A9Z11” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 798 | 961 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 798 | 961 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 798 | 961 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 798 | 961 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 804 | 963 | 145 | 20 | #1F1F1F |  | “MDP2949A9AA11” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 798 | 986 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 798 | 986 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 798 | 986 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 798 | 986 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 804 | 988 | 145 | 20 | #1F1F1F |  | “MDP2949A9AB11” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 798 | 1011 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 798 | 1011 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 798 | 1011 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 798 | 1011 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 804 | 1013 | 145 | 20 | #1F1F1F |  | “MDP2949A9AC11” |
| 8 | FRAME | ········Col | 955 | 361 | 157 | 674 |  |  |  |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 955 | 361 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 955 | 361 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 955 | 361 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 955 | 361 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 961 | 363 | 145 | 20 | #1F1F1F |  | “Question” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 955 | 386 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 955 | 386 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 955 | 386 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 955 | 386 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 961 | 388 | 145 | 20 | #1F1F1F |  | “Information” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 955 | 411 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 955 | 411 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 955 | 411 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 955 | 411 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 961 | 413 | 145 | 20 | #1F1F1F |  | “Exclamation” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 955 | 436 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 955 | 436 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 955 | 436 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 955 | 436 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 961 | 438 | 145 | 20 | #1F1F1F |  | “Error” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 955 | 461 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 955 | 461 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 955 | 461 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 955 | 461 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 961 | 463 | 145 | 20 | #1F1F1F |  | “Information” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 955 | 486 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 955 | 486 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 955 | 486 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 955 | 486 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 961 | 488 | 145 | 20 | #1F1F1F |  | “Information” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 955 | 511 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 955 | 511 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 955 | 511 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 955 | 511 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 961 | 513 | 145 | 20 | #1F1F1F |  | “Information” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 955 | 536 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 955 | 536 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 955 | 536 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 955 | 536 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 961 | 538 | 145 | 20 | #1F1F1F |  | “Information” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 955 | 561 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 955 | 561 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 955 | 561 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 955 | 561 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 961 | 563 | 145 | 20 | #1F1F1F |  | “Information” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 955 | 586 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 955 | 586 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 955 | 586 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 955 | 586 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 961 | 588 | 145 | 20 | #1F1F1F |  | “Information” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 955 | 611 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 955 | 611 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 955 | 611 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 955 | 611 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 961 | 613 | 145 | 20 | #1F1F1F |  | “Information” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 955 | 636 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 955 | 636 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 955 | 636 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 955 | 636 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 961 | 638 | 145 | 20 | #1F1F1F |  | “Information” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 955 | 661 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 955 | 661 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 955 | 661 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 955 | 661 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 961 | 663 | 145 | 20 | #1F1F1F |  | “Question” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 955 | 686 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 955 | 686 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 955 | 686 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 955 | 686 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 961 | 688 | 145 | 20 | #1F1F1F |  | “Question” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 955 | 711 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 955 | 711 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 955 | 711 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 955 | 711 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 961 | 713 | 145 | 20 | #1F1F1F |  | “Information” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 955 | 736 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 955 | 736 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 955 | 736 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 955 | 736 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 961 | 738 | 145 | 20 | #1F1F1F |  | “Question” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 955 | 761 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 955 | 761 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 955 | 761 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 955 | 761 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 961 | 763 | 145 | 20 | #1F1F1F |  | “Question” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 955 | 786 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 955 | 786 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 955 | 786 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 955 | 786 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 961 | 788 | 145 | 20 | #1F1F1F |  | “Information” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 955 | 811 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 955 | 811 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 955 | 811 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 955 | 811 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 961 | 813 | 145 | 20 | #1F1F1F |  | “Information” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 955 | 836 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 955 | 836 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 955 | 836 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 955 | 836 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 961 | 838 | 145 | 20 | #1F1F1F |  | “Information” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 955 | 861 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 955 | 861 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 955 | 861 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 955 | 861 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 961 | 863 | 145 | 20 | #1F1F1F |  | “Information” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 955 | 886 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 955 | 886 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 955 | 886 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 955 | 886 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 961 | 888 | 145 | 20 | #1F1F1F |  | “Information” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 955 | 911 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 955 | 911 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 955 | 911 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 955 | 911 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 961 | 913 | 145 | 20 | #1F1F1F |  | “Information” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 955 | 936 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 955 | 936 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 955 | 936 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 955 | 936 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 961 | 938 | 145 | 20 | #1F1F1F |  | “Information” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 955 | 961 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 955 | 961 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 955 | 961 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 955 | 961 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 961 | 963 | 145 | 20 | #1F1F1F |  | “Information” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 955 | 986 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 955 | 986 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 955 | 986 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 955 | 986 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 961 | 988 | 145 | 20 | #1F1F1F |  | “Information” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 955 | 1011 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 955 | 1011 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 955 | 1011 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 955 | 1011 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 961 | 1013 | 145 | 20 | #1F1F1F |  | “Information” |
| 8 | FRAME | ········Col | 1112 | 361 | 157 | 674 |  |  |  |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1112 | 361 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1112 | 361 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1112 | 361 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1112 | 361 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1118 | 363 | 145 | 20 | #1F1F1F |  | “DDP” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1112 | 386 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1112 | 386 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1112 | 386 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1112 | 386 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1118 | 388 | 145 | 20 | #1F1F1F |  | “DDP” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1112 | 411 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1112 | 411 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1112 | 411 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1112 | 411 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1118 | 413 | 145 | 20 | #1F1F1F |  | “DDP” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1112 | 436 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1112 | 436 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1112 | 436 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1112 | 436 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1118 | 438 | 145 | 20 | #1F1F1F |  | “DAP” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1112 | 461 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1112 | 461 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1112 | 461 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1112 | 461 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1118 | 463 | 145 | 20 | #1F1F1F |  | “DAP” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1112 | 486 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1112 | 486 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1112 | 486 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1112 | 486 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1118 | 488 | 145 | 20 | #1F1F1F |  | “DDP” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1112 | 511 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1112 | 511 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1112 | 511 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1112 | 511 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1118 | 513 | 145 | 20 | #1F1F1F |  | “DDP” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1112 | 536 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1112 | 536 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1112 | 536 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1112 | 536 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1118 | 538 | 145 | 20 | #1F1F1F |  | “DDP” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1112 | 561 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1112 | 561 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1112 | 561 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1112 | 561 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1118 | 563 | 145 | 20 | #1F1F1F |  | “DDP” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1112 | 586 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1112 | 586 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1112 | 586 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1112 | 586 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1118 | 588 | 145 | 20 | #1F1F1F |  | “DAP” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1112 | 611 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1112 | 611 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1112 | 611 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1112 | 611 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1118 | 613 | 145 | 20 | #1F1F1F |  | “DAP” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1112 | 636 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1112 | 636 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1112 | 636 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1112 | 636 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1118 | 638 | 145 | 20 | #1F1F1F |  | “DDP” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1112 | 661 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1112 | 661 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1112 | 661 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1112 | 661 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1118 | 663 | 145 | 20 | #1F1F1F |  | “DDP” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1112 | 686 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1112 | 686 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1112 | 686 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1112 | 686 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1118 | 688 | 145 | 20 | #1F1F1F |  | “DDP” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1112 | 711 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1112 | 711 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1112 | 711 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1112 | 711 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1118 | 713 | 145 | 20 | #1F1F1F |  | “DDP” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1112 | 736 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1112 | 736 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1112 | 736 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1112 | 736 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1118 | 738 | 145 | 20 | #1F1F1F |  | “DAP” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1112 | 761 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1112 | 761 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1112 | 761 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1112 | 761 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1118 | 763 | 145 | 20 | #1F1F1F |  | “DAP” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1112 | 786 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1112 | 786 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1112 | 786 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1112 | 786 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1118 | 788 | 145 | 20 | #1F1F1F |  | “DDP” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1112 | 811 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1112 | 811 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1112 | 811 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1112 | 811 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1118 | 813 | 145 | 20 | #1F1F1F |  | “DDP” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1112 | 836 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1112 | 836 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1112 | 836 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1112 | 836 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1118 | 838 | 145 | 20 | #1F1F1F |  | “DDP” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1112 | 861 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1112 | 861 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1112 | 861 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1112 | 861 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1118 | 863 | 145 | 20 | #1F1F1F |  | “DDP” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1112 | 886 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1112 | 886 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1112 | 886 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1112 | 886 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1118 | 888 | 145 | 20 | #1F1F1F |  | “DAP” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1112 | 911 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1112 | 911 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1112 | 911 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1112 | 911 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1118 | 913 | 145 | 20 | #1F1F1F |  | “DAP” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1112 | 936 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1112 | 936 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1112 | 936 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1112 | 936 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1118 | 938 | 145 | 20 | #1F1F1F |  | “DDP” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1112 | 961 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1112 | 961 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1112 | 961 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1112 | 961 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1118 | 963 | 145 | 20 | #1F1F1F |  | “DDP” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1112 | 986 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1112 | 986 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1112 | 986 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1112 | 986 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1118 | 988 | 145 | 20 | #1F1F1F |  | “DDP” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1112 | 1011 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1112 | 1011 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1112 | 1011 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1112 | 1011 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1118 | 1013 | 145 | 20 | #1F1F1F |  | “DDP” |
| 8 | FRAME | ········Col | 1269 | 361 | 157 | 674 |  |  |  |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1269 | 361 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1269 | 361 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1269 | 361 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1269 | 361 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1275 | 363 | 145 | 20 | #1F1F1F |  | “Mass” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1269 | 386 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1269 | 386 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1269 | 386 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1269 | 386 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1275 | 388 | 145 | 20 | #1F1F1F |  | “Mass” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1269 | 411 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1269 | 411 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1269 | 411 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1269 | 411 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1275 | 413 | 145 | 20 | #1F1F1F |  | “Mass” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1269 | 436 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1269 | 436 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1269 | 436 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1269 | 436 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1275 | 438 | 145 | 20 | #1F1F1F |  | “Mass” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1269 | 461 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1269 | 461 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1269 | 461 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1269 | 461 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1275 | 463 | 145 | 20 | #1F1F1F |  | “Mass” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1269 | 486 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1269 | 486 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1269 | 486 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1269 | 486 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1275 | 488 | 145 | 20 | #1F1F1F |  | “Mass” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1269 | 511 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1269 | 511 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1269 | 511 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1269 | 511 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1275 | 513 | 145 | 20 | #1F1F1F |  | “Mass” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1269 | 536 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1269 | 536 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1269 | 536 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1269 | 536 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1275 | 538 | 145 | 20 | #1F1F1F |  | “Mass” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1269 | 561 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1269 | 561 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1269 | 561 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1269 | 561 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1275 | 563 | 145 | 20 | #1F1F1F |  | “Mass” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1269 | 586 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1269 | 586 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1269 | 586 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1269 | 586 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1275 | 588 | 145 | 20 | #1F1F1F |  | “Sample (dev)” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1269 | 611 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1269 | 611 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1269 | 611 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1269 | 611 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1275 | 613 | 145 | 20 | #1F1F1F |  | “Sample (dev)” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1269 | 636 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1269 | 636 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1269 | 636 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1269 | 636 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1275 | 638 | 145 | 20 | #1F1F1F |  | “Sample (dev)” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1269 | 661 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1269 | 661 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1269 | 661 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1269 | 661 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1275 | 663 | 145 | 20 | #1F1F1F |  | “Mass” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1269 | 686 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1269 | 686 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1269 | 686 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1269 | 686 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1275 | 688 | 145 | 20 | #1F1F1F |  | “Mass” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1269 | 711 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1269 | 711 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1269 | 711 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1269 | 711 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1275 | 713 | 145 | 20 | #1F1F1F |  | “Mass” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1269 | 736 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1269 | 736 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1269 | 736 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1269 | 736 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1275 | 738 | 145 | 20 | #1F1F1F |  | “Mass” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1269 | 761 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1269 | 761 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1269 | 761 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1269 | 761 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1275 | 763 | 145 | 20 | #1F1F1F |  | “Mass” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1269 | 786 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1269 | 786 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1269 | 786 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1269 | 786 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1275 | 788 | 145 | 20 | #1F1F1F |  | “Mass” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1269 | 811 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1269 | 811 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1269 | 811 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1269 | 811 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1275 | 813 | 145 | 20 | #1F1F1F |  | “Mass” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1269 | 836 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1269 | 836 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1269 | 836 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1269 | 836 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1275 | 838 | 145 | 20 | #1F1F1F |  | “Mass” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1269 | 861 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1269 | 861 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1269 | 861 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1269 | 861 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1275 | 863 | 145 | 20 | #1F1F1F |  | “Mass” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1269 | 886 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1269 | 886 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1269 | 886 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1269 | 886 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1275 | 888 | 145 | 20 | #1F1F1F |  | “Mass” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1269 | 911 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1269 | 911 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1269 | 911 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1269 | 911 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1275 | 913 | 145 | 20 | #1F1F1F |  | “Mass” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1269 | 936 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1269 | 936 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1269 | 936 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1269 | 936 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1275 | 938 | 145 | 20 | #1F1F1F |  | “Mass” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1269 | 961 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1269 | 961 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1269 | 961 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1269 | 961 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1275 | 963 | 145 | 20 | #1F1F1F |  | “Sample (dev)” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1269 | 986 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1269 | 986 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1269 | 986 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1269 | 986 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1275 | 988 | 145 | 20 | #1F1F1F |  | “Sample (dev)” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1269 | 1011 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1269 | 1011 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1269 | 1011 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1269 | 1011 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1275 | 1013 | 145 | 20 | #1F1F1F |  | “Mass” |
| 8 | FRAME | ········Col | 1426 | 361 | 157 | 674 |  |  |  |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1426 | 361 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1426 | 361 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1426 | 361 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1426 | 361 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1432 | 363 | 145 | 20 | #1F1F1F |  | “E” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1426 | 386 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1426 | 386 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1426 | 386 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1426 | 386 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1432 | 388 | 145 | 20 | #1F1F1F |  | “E” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1426 | 411 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1426 | 411 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1426 | 411 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1426 | 411 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1432 | 413 | 145 | 20 | #1F1F1F |  | “E” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1426 | 436 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1426 | 436 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1426 | 436 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1426 | 436 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1432 | 438 | 145 | 20 | #1F1F1F |  | “E” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1426 | 461 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1426 | 461 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1426 | 461 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1426 | 461 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1432 | 463 | 145 | 20 | #1F1F1F |  | “E” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1426 | 486 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1426 | 486 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1426 | 486 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1426 | 486 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1432 | 488 | 145 | 20 | #1F1F1F |  | “E” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1426 | 511 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1426 | 511 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1426 | 511 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1426 | 511 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1432 | 513 | 145 | 20 | #1F1F1F |  | “E” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1426 | 536 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1426 | 536 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1426 | 536 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1426 | 536 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1432 | 538 | 145 | 20 | #1F1F1F |  | “E” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1426 | 561 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1426 | 561 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1426 | 561 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1426 | 561 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1432 | 563 | 145 | 20 | #1F1F1F |  | “E” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1426 | 586 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1426 | 586 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1426 | 586 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1426 | 586 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1432 | 588 | 145 | 20 | #1F1F1F |  | “E” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1426 | 611 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1426 | 611 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1426 | 611 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1426 | 611 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1432 | 613 | 145 | 20 | #1F1F1F |  | “E” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1426 | 636 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1426 | 636 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1426 | 636 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1426 | 636 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1432 | 638 | 145 | 20 | #1F1F1F |  | “E” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1426 | 661 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1426 | 661 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1426 | 661 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1426 | 661 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1432 | 663 | 145 | 20 | #1F1F1F |  | “E” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1426 | 686 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1426 | 686 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1426 | 686 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1426 | 686 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1432 | 688 | 145 | 20 | #1F1F1F |  | “E” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1426 | 711 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1426 | 711 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1426 | 711 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1426 | 711 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1432 | 713 | 145 | 20 | #1F1F1F |  | “E” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1426 | 736 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1426 | 736 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1426 | 736 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1426 | 736 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1432 | 738 | 145 | 20 | #1F1F1F |  | “E” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1426 | 761 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1426 | 761 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1426 | 761 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1426 | 761 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1432 | 763 | 145 | 20 | #1F1F1F |  | “E” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1426 | 786 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1426 | 786 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1426 | 786 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1426 | 786 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1432 | 788 | 145 | 20 | #1F1F1F |  | “E” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1426 | 811 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1426 | 811 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1426 | 811 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1426 | 811 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1432 | 813 | 145 | 20 | #1F1F1F |  | “E” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1426 | 836 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1426 | 836 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1426 | 836 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1426 | 836 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1432 | 838 | 145 | 20 | #1F1F1F |  | “E” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1426 | 861 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1426 | 861 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1426 | 861 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1426 | 861 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1432 | 863 | 145 | 20 | #1F1F1F |  | “E” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1426 | 886 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1426 | 886 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1426 | 886 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1426 | 886 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1432 | 888 | 145 | 20 | #1F1F1F |  | “E” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1426 | 911 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1426 | 911 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1426 | 911 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1426 | 911 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1432 | 913 | 145 | 20 | #1F1F1F |  | “E” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1426 | 936 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1426 | 936 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1426 | 936 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1426 | 936 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1432 | 938 | 145 | 20 | #1F1F1F |  | “E” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1426 | 961 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1426 | 961 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1426 | 961 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1426 | 961 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1432 | 963 | 145 | 20 | #1F1F1F |  | “E” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1426 | 986 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1426 | 986 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1426 | 986 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1426 | 986 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1432 | 988 | 145 | 20 | #1F1F1F |  | “E” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1426 | 1011 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1426 | 1011 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1426 | 1011 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1426 | 1011 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1432 | 1013 | 145 | 20 | #1F1F1F |  | “E” |
| 8 | FRAME | ········Col | 1583 | 361 | 157 | 674 |  |  |  |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1583 | 361 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1583 | 361 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1583 | 361 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1583 | 361 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1589 | 363 | 145 | 20 | #1F1F1F |  | “USD” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1583 | 386 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1583 | 386 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1583 | 386 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1583 | 386 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1589 | 388 | 145 | 20 | #1F1F1F |  | “USD” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1583 | 411 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1583 | 411 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1583 | 411 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1583 | 411 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1589 | 413 | 145 | 20 | #1F1F1F |  | “USD” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1583 | 436 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1583 | 436 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1583 | 436 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1583 | 436 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1589 | 438 | 145 | 20 | #1F1F1F |  | “USD” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1583 | 461 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1583 | 461 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1583 | 461 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1583 | 461 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1589 | 463 | 145 | 20 | #1F1F1F |  | “USD” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1583 | 486 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1583 | 486 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1583 | 486 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1583 | 486 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1589 | 488 | 145 | 20 | #1F1F1F |  | “USD” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1583 | 511 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1583 | 511 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1583 | 511 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1583 | 511 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1589 | 513 | 145 | 20 | #1F1F1F |  | “USD” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1583 | 536 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1583 | 536 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1583 | 536 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1583 | 536 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1589 | 538 | 145 | 20 | #1F1F1F |  | “USD” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1583 | 561 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1583 | 561 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1583 | 561 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1583 | 561 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1589 | 563 | 145 | 20 | #1F1F1F |  | “USD” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1583 | 586 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1583 | 586 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1583 | 586 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1583 | 586 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1589 | 588 | 145 | 20 | #1F1F1F |  | “USD” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1583 | 611 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1583 | 611 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1583 | 611 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1583 | 611 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1589 | 613 | 145 | 20 | #1F1F1F |  | “USD” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1583 | 636 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1583 | 636 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1583 | 636 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1583 | 636 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1589 | 638 | 145 | 20 | #1F1F1F |  | “USD” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1583 | 661 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1583 | 661 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1583 | 661 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1583 | 661 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1589 | 663 | 145 | 20 | #1F1F1F |  | “USD” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1583 | 686 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1583 | 686 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1583 | 686 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1583 | 686 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1589 | 688 | 145 | 20 | #1F1F1F |  | “USD” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1583 | 711 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1583 | 711 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1583 | 711 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1583 | 711 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1589 | 713 | 145 | 20 | #1F1F1F |  | “USD” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1583 | 736 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1583 | 736 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1583 | 736 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1583 | 736 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1589 | 738 | 145 | 20 | #1F1F1F |  | “USD” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1583 | 761 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1583 | 761 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1583 | 761 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1583 | 761 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1589 | 763 | 145 | 20 | #1F1F1F |  | “USD” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1583 | 786 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1583 | 786 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1583 | 786 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1583 | 786 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1589 | 788 | 145 | 20 | #1F1F1F |  | “USD” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1583 | 811 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1583 | 811 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1583 | 811 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1583 | 811 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1589 | 813 | 145 | 20 | #1F1F1F |  | “USD” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1583 | 836 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1583 | 836 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1583 | 836 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1583 | 836 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1589 | 838 | 145 | 20 | #1F1F1F |  | “USD” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1583 | 861 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1583 | 861 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1583 | 861 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1583 | 861 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1589 | 863 | 145 | 20 | #1F1F1F |  | “USD” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1583 | 886 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1583 | 886 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1583 | 886 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1583 | 886 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1589 | 888 | 145 | 20 | #1F1F1F |  | “USD” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1583 | 911 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1583 | 911 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1583 | 911 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1583 | 911 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1589 | 913 | 145 | 20 | #1F1F1F |  | “USD” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1583 | 936 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1583 | 936 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1583 | 936 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1583 | 936 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1589 | 938 | 145 | 20 | #1F1F1F |  | “USD” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1583 | 961 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1583 | 961 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1583 | 961 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1583 | 961 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1589 | 963 | 145 | 20 | #1F1F1F |  | “USD” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1583 | 986 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1583 | 986 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1583 | 986 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1583 | 986 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1589 | 988 | 145 | 20 | #1F1F1F |  | “USD” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1583 | 1011 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1583 | 1011 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1583 | 1011 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1583 | 1011 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1589 | 1013 | 145 | 20 | #1F1F1F |  | “USD” |
| 8 | FRAME | ········Col | 1740 | 361 | 157 | 674 |  |  |  |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1740 | 361 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1740 | 361 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1740 | 361 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1740 | 361 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1746 | 363 | 145 | 20 | #1F1F1F |  | “Y” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1740 | 386 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1740 | 386 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1740 | 386 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1740 | 386 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1746 | 388 | 145 | 20 | #1F1F1F |  | “Y” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1740 | 411 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1740 | 411 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1740 | 411 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1740 | 411 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1746 | 413 | 145 | 20 | #1F1F1F |  | “Y” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1740 | 436 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1740 | 436 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1740 | 436 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1740 | 436 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1746 | 438 | 145 | 20 | #1F1F1F |  | “Y” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1740 | 461 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1740 | 461 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1740 | 461 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1740 | 461 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1746 | 463 | 145 | 20 | #1F1F1F |  | “Y” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1740 | 486 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1740 | 486 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1740 | 486 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1740 | 486 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1746 | 488 | 145 | 20 | #1F1F1F |  | “Y” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1740 | 511 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1740 | 511 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1740 | 511 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1740 | 511 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1746 | 513 | 145 | 20 | #1F1F1F |  | “Y” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1740 | 536 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1740 | 536 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1740 | 536 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1740 | 536 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1746 | 538 | 145 | 20 | #1F1F1F |  | “Y” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1740 | 561 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1740 | 561 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1740 | 561 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1740 | 561 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1746 | 563 | 145 | 20 | #1F1F1F |  | “Y” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1740 | 586 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1740 | 586 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1740 | 586 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1740 | 586 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1746 | 588 | 145 | 20 | #1F1F1F |  | “Y” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1740 | 611 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1740 | 611 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1740 | 611 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1740 | 611 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1746 | 613 | 145 | 20 | #1F1F1F |  | “Y” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1740 | 636 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1740 | 636 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1740 | 636 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1740 | 636 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1746 | 638 | 145 | 20 | #1F1F1F |  | “Y” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1740 | 661 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1740 | 661 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1740 | 661 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1740 | 661 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1746 | 663 | 145 | 20 | #1F1F1F |  | “Y” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1740 | 686 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1740 | 686 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1740 | 686 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1740 | 686 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1746 | 688 | 145 | 20 | #1F1F1F |  | “Y” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1740 | 711 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1740 | 711 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1740 | 711 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1740 | 711 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1746 | 713 | 145 | 20 | #1F1F1F |  | “Y” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1740 | 736 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1740 | 736 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1740 | 736 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1740 | 736 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1746 | 738 | 145 | 20 | #1F1F1F |  | “Y” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1740 | 761 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1740 | 761 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1740 | 761 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1740 | 761 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1746 | 763 | 145 | 20 | #1F1F1F |  | “Y” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1740 | 786 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1740 | 786 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1740 | 786 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1740 | 786 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1746 | 788 | 145 | 20 | #1F1F1F |  | “Y” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1740 | 811 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1740 | 811 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1740 | 811 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1740 | 811 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1746 | 813 | 145 | 20 | #1F1F1F |  | “Y” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1740 | 836 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1740 | 836 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1740 | 836 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1740 | 836 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1746 | 838 | 145 | 20 | #1F1F1F |  | “Y” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1740 | 861 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1740 | 861 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1740 | 861 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1740 | 861 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1746 | 863 | 145 | 20 | #1F1F1F |  | “Y” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1740 | 886 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1740 | 886 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1740 | 886 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1740 | 886 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1746 | 888 | 145 | 20 | #1F1F1F |  | “Y” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1740 | 911 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1740 | 911 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1740 | 911 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1740 | 911 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1746 | 913 | 145 | 20 | #1F1F1F |  | “Y” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1740 | 936 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1740 | 936 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1740 | 936 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1740 | 936 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1746 | 938 | 145 | 20 | #1F1F1F |  | “Y” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1740 | 961 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1740 | 961 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1740 | 961 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1740 | 961 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1746 | 963 | 145 | 20 | #1F1F1F |  | “Y” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1740 | 986 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1740 | 986 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1740 | 986 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1740 | 986 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1746 | 988 | 145 | 20 | #1F1F1F |  | “Y” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1740 | 1011 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Center, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1740 | 1011 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1740 | 1011 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1740 | 1011 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1746 | 1013 | 145 | 20 | #1F1F1F |  | “Y” |
| 8 | FRAME | ········Col | 1897 | 361 | 157 | 674 |  |  |  |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1897 | 361 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1897 | 361 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1897 | 361 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1897 | 361 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1903 | 363 | 145 | 20 | #1F1F1F |  | “RTF” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1897 | 386 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1897 | 386 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1897 | 386 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1897 | 386 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1903 | 388 | 145 | 20 | #1F1F1F |  | “KRW” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1897 | 411 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1897 | 411 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1897 | 411 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1897 | 411 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1903 | 413 | 145 | 20 | #1F1F1F |  | “USD” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1897 | 436 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1897 | 436 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1897 | 436 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1897 | 436 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1903 | 438 | 145 | 20 | #1F1F1F |  | “LOC” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1897 | 461 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1897 | 461 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1897 | 461 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1897 | 461 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1903 | 463 | 145 | 20 | #1F1F1F |  | “RTF” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1897 | 486 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1897 | 486 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1897 | 486 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1897 | 486 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1903 | 488 | 145 | 20 | #1F1F1F |  | “KRW” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1897 | 511 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1897 | 511 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1897 | 511 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1897 | 511 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1903 | 513 | 145 | 20 | #1F1F1F |  | “USD” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1897 | 536 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1897 | 536 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1897 | 536 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1897 | 536 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1903 | 538 | 145 | 20 | #1F1F1F |  | “LOC” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1897 | 561 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1897 | 561 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1897 | 561 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1897 | 561 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1903 | 563 | 145 | 20 | #1F1F1F |  | “RTF” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1897 | 586 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1897 | 586 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1897 | 586 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1897 | 586 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1903 | 588 | 145 | 20 | #1F1F1F |  | “KRW” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1897 | 611 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1897 | 611 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1897 | 611 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1897 | 611 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1903 | 613 | 145 | 20 | #1F1F1F |  | “USD” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1897 | 636 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1897 | 636 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1897 | 636 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1897 | 636 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1903 | 638 | 145 | 20 | #1F1F1F |  | “LOC” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1897 | 661 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1897 | 661 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1897 | 661 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1897 | 661 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1903 | 663 | 145 | 20 | #1F1F1F |  | “RTF” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1897 | 686 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1897 | 686 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1897 | 686 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1897 | 686 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1903 | 688 | 145 | 20 | #1F1F1F |  | “RTF” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1897 | 711 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1897 | 711 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1897 | 711 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1897 | 711 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1903 | 713 | 145 | 20 | #1F1F1F |  | “KRW” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1897 | 736 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1897 | 736 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1897 | 736 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1897 | 736 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1903 | 738 | 145 | 20 | #1F1F1F |  | “USD” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1897 | 761 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1897 | 761 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1897 | 761 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1897 | 761 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1903 | 763 | 145 | 20 | #1F1F1F |  | “LOC” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1897 | 786 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1897 | 786 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1897 | 786 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1897 | 786 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1903 | 788 | 145 | 20 | #1F1F1F |  | “RTF” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1897 | 811 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1897 | 811 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1897 | 811 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1897 | 811 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1903 | 813 | 145 | 20 | #1F1F1F |  | “KRW” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1897 | 836 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1897 | 836 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1897 | 836 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1897 | 836 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1903 | 838 | 145 | 20 | #1F1F1F |  | “USD” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1897 | 861 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1897 | 861 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1897 | 861 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1897 | 861 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1903 | 863 | 145 | 20 | #1F1F1F |  | “LOC” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1897 | 886 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1897 | 886 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1897 | 886 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1897 | 886 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1903 | 888 | 145 | 20 | #1F1F1F |  | “RTF” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1897 | 911 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1897 | 911 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1897 | 911 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1897 | 911 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1903 | 913 | 145 | 20 | #1F1F1F |  | “KRW” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1897 | 936 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1897 | 936 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1897 | 936 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1897 | 936 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1903 | 938 | 145 | 20 | #1F1F1F |  | “USD” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1897 | 961 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1897 | 961 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1897 | 961 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1897 | 961 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1903 | 963 | 145 | 20 | #1F1F1F |  | “LOC” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1897 | 986 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1897 | 986 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1897 | 986 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1897 | 986 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1903 | 988 | 145 | 20 | #1F1F1F |  | “RTF” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 1897 | 1011 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Left, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 1897 | 1011 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 1897 | 1011 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 1897 | 1011 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 1903 | 1013 | 145 | 20 | #1F1F1F |  | “KRW” |
| 8 | FRAME | ········Col | 2054 | 361 | 157 | 674 |  |  |  |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2054 | 361 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2054 | 361 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2054 | 361 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2054 | 361 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2060 | 363 | 145 | 20 | #1F1F1F |  | “0.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2054 | 386 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2054 | 386 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2054 | 386 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2054 | 386 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2060 | 388 | 145 | 20 | #1F1F1F |  | “4,913.200” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2054 | 411 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2054 | 411 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2054 | 411 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2054 | 411 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2060 | 413 | 145 | 20 | #1F1F1F |  | “3.460” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2054 | 436 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2054 | 436 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2054 | 436 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2054 | 436 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2060 | 438 | 145 | 20 | #1F1F1F |  | “0.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2054 | 461 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2054 | 461 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2054 | 461 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2054 | 461 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2060 | 463 | 145 | 20 | #1F1F1F |  | “3.460” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2054 | 486 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2054 | 486 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2054 | 486 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2054 | 486 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2060 | 488 | 145 | 20 | #1F1F1F |  | “3,195.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2054 | 511 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2054 | 511 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2054 | 511 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2054 | 511 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2060 | 513 | 145 | 20 | #1F1F1F |  | “2.250” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2054 | 536 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2054 | 536 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2054 | 536 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2054 | 536 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2060 | 538 | 145 | 20 | #1F1F1F |  | “3.460” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2054 | 561 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2054 | 561 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2054 | 561 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2054 | 561 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2060 | 563 | 145 | 20 | #1F1F1F |  | “0.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2054 | 586 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2054 | 586 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2054 | 586 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2054 | 586 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2060 | 588 | 145 | 20 | #1F1F1F |  | “3,209.200” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2054 | 611 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2054 | 611 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2054 | 611 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2054 | 611 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2060 | 613 | 145 | 20 | #1F1F1F |  | “2.260” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2054 | 636 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2054 | 636 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2054 | 636 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2054 | 636 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2060 | 638 | 145 | 20 | #1F1F1F |  | “3,195.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2054 | 661 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2054 | 661 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2054 | 661 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2054 | 661 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2060 | 663 | 145 | 20 | #1F1F1F |  | “2.250” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2054 | 686 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2054 | 686 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2054 | 686 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2054 | 686 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2060 | 688 | 145 | 20 | #1F1F1F |  | “9,301.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2054 | 711 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2054 | 711 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2054 | 711 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2054 | 711 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2060 | 713 | 145 | 20 | #1F1F1F |  | “6.550” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2054 | 736 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2054 | 736 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2054 | 736 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2054 | 736 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2060 | 738 | 145 | 20 | #1F1F1F |  | “2.250” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2054 | 761 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2054 | 761 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2054 | 761 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2054 | 761 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2060 | 763 | 145 | 20 | #1F1F1F |  | “0.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2054 | 786 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2054 | 786 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2054 | 786 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2054 | 786 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2060 | 788 | 145 | 20 | #1F1F1F |  | “908.800” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2054 | 811 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2054 | 811 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2054 | 811 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2054 | 811 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2060 | 813 | 145 | 20 | #1F1F1F |  | “0.640” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2054 | 836 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2054 | 836 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2054 | 836 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2054 | 836 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2060 | 838 | 145 | 20 | #1F1F1F |  | “3,209.200” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2054 | 861 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2054 | 861 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2054 | 861 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2054 | 861 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2060 | 863 | 145 | 20 | #1F1F1F |  | “2.260” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2054 | 886 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2054 | 886 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2054 | 886 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2054 | 886 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2060 | 888 | 145 | 20 | #1F1F1F |  | “2.260” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2054 | 911 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2054 | 911 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2054 | 911 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2054 | 911 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2060 | 913 | 145 | 20 | #1F1F1F |  | “0.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2054 | 936 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2054 | 936 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2054 | 936 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2054 | 936 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2060 | 938 | 145 | 20 | #1F1F1F |  | “9,301.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2054 | 961 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2054 | 961 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2054 | 961 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2054 | 961 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2060 | 963 | 145 | 20 | #1F1F1F |  | “6.550” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2054 | 986 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2054 | 986 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2054 | 986 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2054 | 986 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2060 | 988 | 145 | 20 | #1F1F1F |  | “6.550” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2054 | 1011 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2054 | 1011 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2054 | 1011 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2054 | 1011 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2060 | 1013 | 145 | 20 | #1F1F1F |  | “0.000” |
| 8 | FRAME | ········Col | 2211 | 361 | 157 | 674 |  |  |  |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2211 | 361 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2211 | 361 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2211 | 361 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2211 | 361 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2217 | 363 | 145 | 20 | #1F1F1F |  | “0.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2211 | 386 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2211 | 386 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2211 | 386 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2211 | 386 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2217 | 388 | 145 | 20 | #1F1F1F |  | “4,913.200” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2211 | 411 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2211 | 411 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2211 | 411 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2211 | 411 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2217 | 413 | 145 | 20 | #1F1F1F |  | “3.460” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2211 | 436 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2211 | 436 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2211 | 436 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2211 | 436 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2217 | 438 | 145 | 20 | #1F1F1F |  | “0.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2211 | 461 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2211 | 461 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2211 | 461 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2211 | 461 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2217 | 463 | 145 | 20 | #1F1F1F |  | “3.460” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2211 | 486 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2211 | 486 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2211 | 486 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2211 | 486 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2217 | 488 | 145 | 20 | #1F1F1F |  | “3,195.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2211 | 511 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2211 | 511 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2211 | 511 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2211 | 511 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2217 | 513 | 145 | 20 | #1F1F1F |  | “2.250” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2211 | 536 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2211 | 536 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2211 | 536 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2211 | 536 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2217 | 538 | 145 | 20 | #1F1F1F |  | “3.460” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2211 | 561 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2211 | 561 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2211 | 561 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2211 | 561 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2217 | 563 | 145 | 20 | #1F1F1F |  | “0.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2211 | 586 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2211 | 586 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2211 | 586 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2211 | 586 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2217 | 588 | 145 | 20 | #1F1F1F |  | “3,209.200” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2211 | 611 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2211 | 611 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2211 | 611 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2211 | 611 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2217 | 613 | 145 | 20 | #1F1F1F |  | “2.260” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2211 | 636 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2211 | 636 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2211 | 636 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2211 | 636 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2217 | 638 | 145 | 20 | #1F1F1F |  | “3,195.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2211 | 661 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2211 | 661 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2211 | 661 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2211 | 661 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2217 | 663 | 145 | 20 | #1F1F1F |  | “2.250” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2211 | 686 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2211 | 686 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2211 | 686 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2211 | 686 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2217 | 688 | 145 | 20 | #1F1F1F |  | “9,301.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2211 | 711 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2211 | 711 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2211 | 711 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2211 | 711 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2217 | 713 | 145 | 20 | #1F1F1F |  | “6.550” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2211 | 736 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2211 | 736 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2211 | 736 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2211 | 736 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2217 | 738 | 145 | 20 | #1F1F1F |  | “2.250” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2211 | 761 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2211 | 761 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2211 | 761 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2211 | 761 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2217 | 763 | 145 | 20 | #1F1F1F |  | “0.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2211 | 786 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2211 | 786 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2211 | 786 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2211 | 786 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2217 | 788 | 145 | 20 | #1F1F1F |  | “908.800” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2211 | 811 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2211 | 811 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2211 | 811 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2211 | 811 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2217 | 813 | 145 | 20 | #1F1F1F |  | “0.640” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2211 | 836 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2211 | 836 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2211 | 836 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2211 | 836 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2217 | 838 | 145 | 20 | #1F1F1F |  | “3,209.200” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2211 | 861 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2211 | 861 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2211 | 861 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2211 | 861 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2217 | 863 | 145 | 20 | #1F1F1F |  | “2.260” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2211 | 886 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2211 | 886 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2211 | 886 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2211 | 886 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2217 | 888 | 145 | 20 | #1F1F1F |  | “2.260” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2211 | 911 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2211 | 911 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2211 | 911 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2211 | 911 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2217 | 913 | 145 | 20 | #1F1F1F |  | “0.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2211 | 936 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2211 | 936 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2211 | 936 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2211 | 936 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2217 | 938 | 145 | 20 | #1F1F1F |  | “9,301.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2211 | 961 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2211 | 961 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2211 | 961 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2211 | 961 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2217 | 963 | 145 | 20 | #1F1F1F |  | “6.550” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2211 | 986 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2211 | 986 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2211 | 986 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2211 | 986 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2217 | 988 | 145 | 20 | #1F1F1F |  | “6.550” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2211 | 1011 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2211 | 1011 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2211 | 1011 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2211 | 1011 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2217 | 1013 | 145 | 20 | #1F1F1F |  | “0.000” |
| 8 | FRAME | ········Col | 2368 | 361 | 157 | 674 |  |  |  |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2368 | 361 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2368 | 361 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2368 | 361 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2368 | 361 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2374 | 363 | 145 | 20 | #1F1F1F |  | “0.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2368 | 386 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2368 | 386 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2368 | 386 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2368 | 386 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2374 | 388 | 145 | 20 | #1F1F1F |  | “4,913.200” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2368 | 411 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2368 | 411 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2368 | 411 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2368 | 411 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2374 | 413 | 145 | 20 | #1F1F1F |  | “3.460” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2368 | 436 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2368 | 436 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2368 | 436 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2368 | 436 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2374 | 438 | 145 | 20 | #1F1F1F |  | “0.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2368 | 461 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2368 | 461 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2368 | 461 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2368 | 461 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2374 | 463 | 145 | 20 | #1F1F1F |  | “3.460” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2368 | 486 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2368 | 486 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2368 | 486 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2368 | 486 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2374 | 488 | 145 | 20 | #1F1F1F |  | “3,195.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2368 | 511 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2368 | 511 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2368 | 511 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2368 | 511 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2374 | 513 | 145 | 20 | #1F1F1F |  | “2.250” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2368 | 536 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2368 | 536 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2368 | 536 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2368 | 536 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2374 | 538 | 145 | 20 | #1F1F1F |  | “3.460” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2368 | 561 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2368 | 561 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2368 | 561 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2368 | 561 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2374 | 563 | 145 | 20 | #1F1F1F |  | “0.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2368 | 586 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2368 | 586 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2368 | 586 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2368 | 586 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2374 | 588 | 145 | 20 | #1F1F1F |  | “3,209.200” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2368 | 611 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2368 | 611 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2368 | 611 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2368 | 611 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2374 | 613 | 145 | 20 | #1F1F1F |  | “2.260” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2368 | 636 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2368 | 636 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2368 | 636 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2368 | 636 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2374 | 638 | 145 | 20 | #1F1F1F |  | “3,195.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2368 | 661 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2368 | 661 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2368 | 661 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2368 | 661 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2374 | 663 | 145 | 20 | #1F1F1F |  | “2.250” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2368 | 686 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2368 | 686 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2368 | 686 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2368 | 686 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2374 | 688 | 145 | 20 | #1F1F1F |  | “9,301.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2368 | 711 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2368 | 711 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2368 | 711 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2368 | 711 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2374 | 713 | 145 | 20 | #1F1F1F |  | “6.550” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2368 | 736 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2368 | 736 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2368 | 736 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2368 | 736 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2374 | 738 | 145 | 20 | #1F1F1F |  | “2.250” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2368 | 761 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2368 | 761 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2368 | 761 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2368 | 761 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2374 | 763 | 145 | 20 | #1F1F1F |  | “0.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2368 | 786 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2368 | 786 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2368 | 786 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2368 | 786 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2374 | 788 | 145 | 20 | #1F1F1F |  | “908.800” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2368 | 811 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2368 | 811 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2368 | 811 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2368 | 811 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2374 | 813 | 145 | 20 | #1F1F1F |  | “0.640” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2368 | 836 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2368 | 836 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2368 | 836 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2368 | 836 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2374 | 838 | 145 | 20 | #1F1F1F |  | “3,209.200” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2368 | 861 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2368 | 861 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2368 | 861 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2368 | 861 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2374 | 863 | 145 | 20 | #1F1F1F |  | “2.260” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2368 | 886 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2368 | 886 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2368 | 886 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2368 | 886 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2374 | 888 | 145 | 20 | #1F1F1F |  | “2.260” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2368 | 911 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2368 | 911 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2368 | 911 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2368 | 911 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2374 | 913 | 145 | 20 | #1F1F1F |  | “0.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2368 | 936 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2368 | 936 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2368 | 936 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2368 | 936 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2374 | 938 | 145 | 20 | #1F1F1F |  | “9,301.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2368 | 961 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2368 | 961 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2368 | 961 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2368 | 961 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2374 | 963 | 145 | 20 | #1F1F1F |  | “6.550” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2368 | 986 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2368 | 986 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2368 | 986 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2368 | 986 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2374 | 988 | 145 | 20 | #1F1F1F |  | “6.550” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2368 | 1011 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2368 | 1011 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2368 | 1011 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2368 | 1011 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2374 | 1013 | 145 | 20 | #1F1F1F |  | “0.000” |
| 8 | FRAME | ········Col | 2525 | 361 | 157 | 674 |  |  |  |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2525 | 361 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2525 | 361 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2525 | 361 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2525 | 361 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2531 | 363 | 145 | 20 | #1F1F1F |  | “0.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2525 | 386 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2525 | 386 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2525 | 386 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2525 | 386 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2531 | 388 | 145 | 20 | #1F1F1F |  | “4,913.200” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2525 | 411 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2525 | 411 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2525 | 411 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2525 | 411 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2531 | 413 | 145 | 20 | #1F1F1F |  | “3.460” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2525 | 436 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2525 | 436 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2525 | 436 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2525 | 436 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2531 | 438 | 145 | 20 | #1F1F1F |  | “0.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2525 | 461 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2525 | 461 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2525 | 461 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2525 | 461 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2531 | 463 | 145 | 20 | #1F1F1F |  | “3.460” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2525 | 486 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2525 | 486 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2525 | 486 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2525 | 486 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2531 | 488 | 145 | 20 | #1F1F1F |  | “3,195.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2525 | 511 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2525 | 511 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2525 | 511 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2525 | 511 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2531 | 513 | 145 | 20 | #1F1F1F |  | “2.250” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2525 | 536 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2525 | 536 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2525 | 536 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2525 | 536 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2531 | 538 | 145 | 20 | #1F1F1F |  | “3.460” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2525 | 561 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2525 | 561 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2525 | 561 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2525 | 561 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2531 | 563 | 145 | 20 | #1F1F1F |  | “0.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2525 | 586 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2525 | 586 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2525 | 586 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2525 | 586 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2531 | 588 | 145 | 20 | #1F1F1F |  | “3,209.200” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2525 | 611 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2525 | 611 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2525 | 611 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2525 | 611 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2531 | 613 | 145 | 20 | #1F1F1F |  | “2.260” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2525 | 636 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2525 | 636 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2525 | 636 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2525 | 636 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2531 | 638 | 145 | 20 | #1F1F1F |  | “3,195.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2525 | 661 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2525 | 661 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2525 | 661 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2525 | 661 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2531 | 663 | 145 | 20 | #1F1F1F |  | “2.250” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2525 | 686 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2525 | 686 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2525 | 686 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2525 | 686 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2531 | 688 | 145 | 20 | #1F1F1F |  | “9,301.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2525 | 711 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2525 | 711 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2525 | 711 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2525 | 711 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2531 | 713 | 145 | 20 | #1F1F1F |  | “6.550” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2525 | 736 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2525 | 736 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2525 | 736 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2525 | 736 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2531 | 738 | 145 | 20 | #1F1F1F |  | “2.250” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2525 | 761 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2525 | 761 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2525 | 761 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2525 | 761 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2531 | 763 | 145 | 20 | #1F1F1F |  | “0.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2525 | 786 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2525 | 786 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2525 | 786 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2525 | 786 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2531 | 788 | 145 | 20 | #1F1F1F |  | “908.800” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2525 | 811 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2525 | 811 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2525 | 811 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2525 | 811 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2531 | 813 | 145 | 20 | #1F1F1F |  | “0.640” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2525 | 836 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2525 | 836 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2525 | 836 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2525 | 836 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2531 | 838 | 145 | 20 | #1F1F1F |  | “3,209.200” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2525 | 861 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2525 | 861 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2525 | 861 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2525 | 861 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2531 | 863 | 145 | 20 | #1F1F1F |  | “2.260” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2525 | 886 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2525 | 886 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2525 | 886 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2525 | 886 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2531 | 888 | 145 | 20 | #1F1F1F |  | “2.260” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2525 | 911 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2525 | 911 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2525 | 911 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2525 | 911 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2531 | 913 | 145 | 20 | #1F1F1F |  | “0.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2525 | 936 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2525 | 936 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2525 | 936 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2525 | 936 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2531 | 938 | 145 | 20 | #1F1F1F |  | “9,301.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2525 | 961 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2525 | 961 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2525 | 961 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2525 | 961 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2531 | 963 | 145 | 20 | #1F1F1F |  | “6.550” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2525 | 986 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2525 | 986 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2525 | 986 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2525 | 986 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2531 | 988 | 145 | 20 | #1F1F1F |  | “6.550” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2525 | 1011 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2525 | 1011 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2525 | 1011 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2525 | 1011 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2531 | 1013 | 145 | 20 | #1F1F1F |  | “0.000” |
| 8 | FRAME | ········Col | 2682 | 361 | 157 | 674 |  |  |  |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2682 | 361 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2682 | 361 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2682 | 361 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2682 | 361 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2688 | 363 | 145 | 20 | #1F1F1F |  | “0.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2682 | 386 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2682 | 386 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2682 | 386 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2682 | 386 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2688 | 388 | 145 | 20 | #1F1F1F |  | “4,913.200” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2682 | 411 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2682 | 411 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2682 | 411 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2682 | 411 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2688 | 413 | 145 | 20 | #1F1F1F |  | “3.460” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2682 | 436 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2682 | 436 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2682 | 436 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2682 | 436 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2688 | 438 | 145 | 20 | #1F1F1F |  | “0.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2682 | 461 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2682 | 461 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2682 | 461 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2682 | 461 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2688 | 463 | 145 | 20 | #1F1F1F |  | “3.460” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2682 | 486 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2682 | 486 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2682 | 486 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2682 | 486 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2688 | 488 | 145 | 20 | #1F1F1F |  | “3,195.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2682 | 511 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2682 | 511 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2682 | 511 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2682 | 511 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2688 | 513 | 145 | 20 | #1F1F1F |  | “2.250” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2682 | 536 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2682 | 536 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2682 | 536 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2682 | 536 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2688 | 538 | 145 | 20 | #1F1F1F |  | “3.460” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2682 | 561 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2682 | 561 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2682 | 561 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2682 | 561 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2688 | 563 | 145 | 20 | #1F1F1F |  | “0.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2682 | 586 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2682 | 586 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2682 | 586 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2682 | 586 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2688 | 588 | 145 | 20 | #1F1F1F |  | “3,209.200” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2682 | 611 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2682 | 611 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2682 | 611 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2682 | 611 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2688 | 613 | 145 | 20 | #1F1F1F |  | “2.260” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2682 | 636 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2682 | 636 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2682 | 636 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2682 | 636 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2688 | 638 | 145 | 20 | #1F1F1F |  | “3,195.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2682 | 661 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2682 | 661 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2682 | 661 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2682 | 661 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2688 | 663 | 145 | 20 | #1F1F1F |  | “2.250” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2682 | 686 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2682 | 686 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2682 | 686 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2682 | 686 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2688 | 688 | 145 | 20 | #1F1F1F |  | “9,301.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2682 | 711 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2682 | 711 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2682 | 711 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2682 | 711 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2688 | 713 | 145 | 20 | #1F1F1F |  | “6.550” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2682 | 736 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2682 | 736 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2682 | 736 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2682 | 736 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2688 | 738 | 145 | 20 | #1F1F1F |  | “2.250” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2682 | 761 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2682 | 761 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2682 | 761 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2682 | 761 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2688 | 763 | 145 | 20 | #1F1F1F |  | “0.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2682 | 786 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2682 | 786 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2682 | 786 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2682 | 786 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2688 | 788 | 145 | 20 | #1F1F1F |  | “908.800” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2682 | 811 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2682 | 811 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2682 | 811 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2682 | 811 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2688 | 813 | 145 | 20 | #1F1F1F |  | “0.640” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2682 | 836 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2682 | 836 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2682 | 836 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2682 | 836 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2688 | 838 | 145 | 20 | #1F1F1F |  | “3,209.200” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2682 | 861 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2682 | 861 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2682 | 861 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2682 | 861 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2688 | 863 | 145 | 20 | #1F1F1F |  | “2.260” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2682 | 886 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2682 | 886 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2682 | 886 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2682 | 886 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2688 | 888 | 145 | 20 | #1F1F1F |  | “2.260” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2682 | 911 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2682 | 911 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2682 | 911 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2682 | 911 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2688 | 913 | 145 | 20 | #1F1F1F |  | “0.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2682 | 936 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2682 | 936 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2682 | 936 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2682 | 936 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2688 | 938 | 145 | 20 | #1F1F1F |  | “9,301.000” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2682 | 961 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2682 | 961 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2682 | 961 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2682 | 961 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2688 | 963 | 145 | 20 | #1F1F1F |  | “6.550” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2682 | 986 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2682 | 986 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2682 | 986 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2682 | 986 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2688 | 988 | 145 | 20 | #1F1F1F |  | “6.550” |
| 9 | INSTANCE | ·········#Component/Data Grid/Analytical/Body/Tex | 2682 | 1011 | 157 | 24 |  | #F1F4F3 | ⟶ Status=Filled, Text Align=Right, Text Overflow=Ellipsis |
| 10 | FRAME | ··········Editable Tag | 2682 | 1011 | 1 | 24 |  |  |  |
| 11 | VECTOR | ···········Editable Tag | 2682 | 1011 | 4 | 4 | #554596 |  |  |
| 10 | FRAME | ··········Inner | 2682 | 1011 | 157 | 24 |  |  |  |
| 11 | TEXT | ···········텍스트 | 2688 | 1013 | 145 | 20 | #1F1F1F |  | “0.000” |
| 5 | INSTANCE | ·····#Others/Scroll | 262 | 313 | 1626 | 642 |  |  | ⟶ #Others/Scroll |
| 6 | RECTANGLE | ······Bottom-Right | 1871 | 938 | 17 | 17 | #F7F9F8 |  |  |
| 6 | INSTANCE | ······#Others/Scroll/Horizontal | 262 | 938 | 1609 | 17 | #F7F9F8 |  | ⟶ #Others/Scroll/Horizontal |
| 7 | FRAME | ·······Holder Area | 279 | 940 | 1575 | 13 |  |  |  |
| 8 | RECTANGLE | ········Holder | 279 | 940 | 1475 | 13 | #DDE0DF |  |  |
| 7 | VECTOR | ·······Left | 267 | 943 | 4 | 7 | #5B5C5B |  |  |
| 7 | VECTOR | ·······Right | 1862 | 943 | 4 | 7 | #5B5C5B |  |  |
| 6 | INSTANCE | ······#Others/Scroll/Vertical | 1871 | 313 | 17 | 625 | #F7F9F8 |  | ⟶ #Others/Scroll/Vertical |
| 7 | FRAME | ·······Holder Area | 1873 | 330 | 13 | 591 |  |  |  |
| 8 | RECTANGLE | ········Holder | 1873 | 330 | 13 | 80 | #DDE0DF |  |  |
| 7 | VECTOR | ·······Top | 1876 | 318 | 7 | 4 | #5B5C5B |  |  |
| 7 | VECTOR | ·······Bottom | 1876 | 929 | 7 | 4 | #5B5C5B |  |  |

## §2. 텍스트 라벨 (실측, y→x 정렬) — UI 라벨/버튼/컬럼 헤더

| text | x | y | w | h | font | size | weight | align | fill | style |
|---|--:|--:|--:|--:|---|--:|--:|---|---|---|
| 9 | 1854 | 8 | 8 | 17 | Spoqa Han Sans Neo | 11.0 | 400 | CENTER | #FFFFFF | Body/Xsmall - Regular |
| Next SCM | 66 | 8 | 113 | 36 | Spoqa Han Sans Neo | 24.0 | 700 | LEFT | #135678 | Title/H1 |
| Next-SCM pretask | 204 | 10 | 118 | 18 | Spoqa Han Sans Neo | 14.0 | 400 | LEFT | #135678 | Header-Area/Sys-Name-Kor |
| Demand | 676 | 16 | 58 | 21 | Spoqa Han Sans Neo | 14.0 | 700 | CENTER | #979998 | Header-Area/1Level-Menu |
| Supply | 774 | 16 | 49 | 21 | Spoqa Han Sans Neo | 14.0 | 700 | CENTER | #979998 | Header-Area/1Level-Menu |
| Factory | 863 | 16 | 53 | 21 | Spoqa Han Sans Neo | 14.0 | 700 | CENTER | #979998 | Header-Area/1Level-Menu |
| Shipping | 956 | 16 | 61 | 21 | Spoqa Han Sans Neo | 14.0 | 700 | CENTER | #979998 | Header-Area/1Level-Menu |
| Report | 1057 | 16 | 48 | 21 | Spoqa Han Sans Neo | 14.0 | 700 | CENTER | #979998 | Header-Area/1Level-Menu |
| Authority | 1145 | 16 | 66 | 21 | Spoqa Han Sans Neo | 14.0 | 700 | CENTER | #979998 | Header-Area/1Level-Menu |
| Admin | 1251 | 16 | 45 | 21 | Spoqa Han Sans Neo | 14.0 | 700 | CENTER | #979998 | Header-Area/1Level-Menu |
| Spread | 1336 | 16 | 50 | 21 | Spoqa Han Sans Neo | 14.0 | 700 | CENTER | #979998 | Header-Area/1Level-Menu |
| Master | 588 | 16 | 48 | 21 | Spoqa Han Sans Neo | 14.0 | 700 | CENTER | #1F1F1F | Header-Area/1Level-Menu |
| 통합검색 | 1676 | 16 | 48 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Menu | 1694 | 16 | 35 | 20 | Spoqa Han Sans Neo | 13.0 | 500 | CENTER | #5B5C5B | Header-Area/Util-Menu |
| Menu | 1726 | 16 | 35 | 20 | Spoqa Han Sans Neo | 13.0 | 500 | CENTER | #5B5C5B | Header-Area/Util-Menu |
| 20 | 1733 | 16 | 16 | 20 | Spoqa Han Sans Neo | 13.0 | 500 | CENTER | #2D9BB2 | Header-Area/Util-Menu |
| Menu | 1758 | 16 | 35 | 20 | Spoqa Han Sans Neo | 13.0 | 500 | CENTER | #5B5C5B | Header-Area/Util-Menu |
| 20 | 1765 | 16 | 16 | 20 | Spoqa Han Sans Neo | 13.0 | 500 | CENTER | #2D9BB2 | Header-Area/Util-Menu |
| 검색 키워드를 입력하세요. | 1776 | 16 | 141 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #979998 | Body/Basic |
| 20 | 1797 | 16 | 16 | 20 | Spoqa Han Sans Neo | 13.0 | 500 | CENTER | #2D9BB2 | Header-Area/Util-Menu |
| ENG | 1848 | 16 | 27 | 20 | Spoqa Han Sans Neo | 13.0 | 500 | CENTER | #5B5C5B | Header-Area/Util-Menu |
| 홍길동 | 1868 | 16 | 36 | 20 | Spoqa Han Sans Neo | 13.0 | 500 | CENTER | #5B5C5B | Header-Area/Util-Menu |
| Button | 2073 | 16 | 45 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | LEFT | #5B5C5B | Body/Basic-Bold |
| Next SCM | 204 | 24 | 52 | 18 | Spoqa Han Sans Neo | 12.0 | 300 | LEFT | #6E706F | Header-Area/Sys-Name-Full |
| 홈 | 242 | 59 | 12 | 18 | Spoqa Han Sans Neo | 12.0 | 400 | CENTER | #979998 | Body/Small |
| 탭아이템 | 302 | 59 | 45 | 18 | Spoqa Han Sans Neo | 12.0 | 400 | CENTER | #979998 | Body/Small |
| Sales Price | 302 | 59 | 64 | 18 | Spoqa Han Sans Neo | 12.0 | 700 | CENTER | #1F1F1F | Body/Small-Bold |
| 탭아이템 | 366 | 59 | 45 | 18 | Spoqa Han Sans Neo | 12.0 | 400 | CENTER | #979998 | Body/Small |
| 탭아이템 | 366 | 59 | 45 | 18 | Spoqa Han Sans Neo | 12.0 | 400 | CENTER | #979998 | Body/Small |
| 탭아이템 | 366 | 59 | 45 | 18 | Spoqa Han Sans Neo | 12.0 | 400 | CENTER | #979998 | Body/Small |
| 탭아이템 | 797 | 59 | 45 | 18 | Spoqa Han Sans Neo | 12.0 | 400 | CENTER | #979998 | Body/Small |
| 탭아이템 | 890 | 59 | 45 | 18 | Spoqa Han Sans Neo | 12.0 | 400 | CENTER | #979998 | Body/Small |
| 탭아이템 | 983 | 59 | 45 | 18 | Spoqa Han Sans Neo | 12.0 | 400 | CENTER | #979998 | Body/Small |
| 탭아이템 | 1076 | 59 | 45 | 18 | Spoqa Han Sans Neo | 12.0 | 400 | CENTER | #979998 | Body/Small |
| 탭아이템 | 1169 | 59 | 45 | 18 | Spoqa Han Sans Neo | 12.0 | 400 | CENTER | #979998 | Body/Small |
| Master | 12 | 78 | 188 | 21 | Spoqa Han Sans Neo | 14.0 | 700 | LEFT | #5B5C5B | Left-Area/1Level-Menu |
| Sales Price | 290 | 100 | 96 | 23 | Spoqa Han Sans Neo | 18.0 | 700 | LEFT | #1F1F1F | Title/H2 |
| 조회영역 | 1796 | 102 | 48 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Master | 1546 | 103 | 38 | 18 | Spoqa Han Sans Neo | 12.0 | 400 | LEFT | #2D9BB2 | Body/Small |
| 설계변경 | 1598 | 103 | 36 | 18 | Spoqa Han Sans Neo | 12.0 | 400 | LEFT | #2D9BB2 | Body/Small |
| Demand Master | 1602 | 103 | 89 | 18 | Spoqa Han Sans Neo | 12.0 | 400 | LEFT | #2D9BB2 | Body/Small |
| Sales Price | 1709 | 103 | 64 | 18 | Spoqa Han Sans Neo | 12.0 | 700 | LEFT | #2D9BB2 | Body/Small-Bold |
| 검색어 입력후 엔터 | 36 | 126 | 102 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #979998 | Body/Basic |
| Demand Master | 14 | 134 | 188 | 20 | Spoqa Han Sans Neo | 13.0 | 500 | LEFT | #1F7795 | Left-Area/2Level-Menu-Selected |
| Div. | 374 | 146 | 24 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | RIGHT | #1F1F1F | Body/Basic-Bold |
| 40 Division | 414 | 146 | 66 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Team | 730 | 146 | 36 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | RIGHT | #1F1F1F | Body/Basic-Bold |
| ALL | 782 | 146 | 22 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| End Customer | 1044 | 146 | 91 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | RIGHT | #1F1F1F | Body/Basic-Bold |
| ALL | 1150 | 146 | 22 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Sales Site | 1441 | 146 | 62 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | RIGHT | #1F1F1F | Body/Basic-Bold |
| ALL | 1519 | 146 | 22 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| 7 | 86 | 162 | 8 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | CENTER | #1F1F1F | Body/Basic-Bold |
| 7 | 200 | 162 | 8 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | CENTER | #1F1F1F | Body/Basic-Bold |
| 탭아이템 | 34 | 164 | 48 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | LEFT | #2D9BB2 | Body/Basic-Bold |
| 탭아이템 | 148 | 164 | 48 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #5B5C5B |  |
| Sales Site | 36 | 172 | 185 | 18 | Spoqa Han Sans Neo | 12.0 | 400 | LEFT | #5B5C5B | Left-Area/3Level-Menu |
| Biz. Type | 340 | 186 | 58 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | RIGHT | #1F1F1F | Body/Basic-Bold |
| ALL | 414 | 186 | 22 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Model/Nickname | 657 | 186 | 109 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | RIGHT | #1F1F1F | Body/Basic-Bold |
|  | 786 | 186 | 0 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #979998 | Body/Basic |
| Column Setting | 988 | 186 | 100 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | LEFT | #5B5C5B | Body/Basic-Bold |
| Period | 1092 | 186 | 42 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | RIGHT | #1F1F1F | Body/Basic-Bold |
| 2026.03.01 - 2026.08.31 | 1170 | 186 | 148 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Bucket | 1458 | 186 | 45 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | RIGHT | #1F1F1F | Body/Basic-Bold |
| Monthly | 1519 | 186 | 50 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Button | 1781 | 186 | 45 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | LEFT | #5B5C5B | Body/Basic-Bold |
| Search | 1781 | 186 | 45 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | LEFT | #FFFFFF | Body/Basic-Bold |
| Button | 1817 | 186 | 45 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | LEFT | #5B5C5B | Body/Basic-Bold |
| Button | 1870 | 186 | 45 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | LEFT | #FFFFFF | Body/Basic-Bold |
| Sales Site Project Model | 36 | 206 | 185 | 18 | Spoqa Han Sans Neo | 12.0 | 400 | LEFT | #5B5C5B | Left-Area/3Level-Menu |
| Plant Site | 336 | 235 | 62 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | RIGHT | #1F1F1F | Body/Basic-Bold |
| ALL | 414 | 235 | 22 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Owner | 723 | 235 | 43 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | RIGHT | #1F1F1F | Body/Basic-Bold |
|  | 786 | 235 | 0 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #979998 | Body/Basic |
| Column Setting | 988 | 235 | 100 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | LEFT | #5B5C5B | Body/Basic-Bold |
| Version | 1086 | 235 | 48 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | RIGHT | #1F1F1F | Body/Basic-Bold |
|  | 1154 | 235 | 0 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #979998 | Body/Basic |
| Column Setting | 1392 | 235 | 100 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | LEFT | #5B5C5B | Body/Basic-Bold |
| Search over range | 1422 | 235 | 110 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| Customer Model Mapping | 36 | 240 | 185 | 18 | Spoqa Han Sans Neo | 12.0 | 400 | LEFT | #5B5C5B | Left-Area/3Level-Menu |
| Customer FCST Master | 36 | 274 | 185 | 18 | Spoqa Han Sans Neo | 12.0 | 400 | LEFT | #5B5C5B | Left-Area/3Level-Menu |
| 서브타이틀(h3) | 262 | 283 | 106 | 24 | Spoqa Han Sans Neo | 16.0 | 700 | LEFT | #1F1F1F | Title/H3 |
| 총 | 376 | 285 | 12 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| 4 | 394 | 285 | 8 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #2D9BB2 | Body/Basic |
| 건 | 408 | 285 | 12 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| Insert (F8) | 1098 | 286 | 61 | 18 | Spoqa Han Sans Neo | 12.0 | 700 | LEFT | #5B5C5B | Body/Small-Bold |
| Insert (F8) | 1130 | 286 | 61 | 18 | Spoqa Han Sans Neo | 12.0 | 700 | LEFT | #5B5C5B | Body/Small-Bold |
| Delete (F9) | 1227 | 286 | 65 | 18 | Spoqa Han Sans Neo | 12.0 | 700 | LEFT | #5B5C5B | Body/Small-Bold |
| Save (F7) | 1328 | 286 | 55 | 18 | Spoqa Han Sans Neo | 12.0 | 700 | LEFT | #5B5C5B | Body/Small-Bold |
| Sort (F3) | 1419 | 286 | 52 | 18 | Spoqa Han Sans Neo | 12.0 | 700 | LEFT | #5B5C5B | Body/Small-Bold |
| Filter (F4) | 1507 | 286 | 58 | 18 | Spoqa Han Sans Neo | 12.0 | 700 | LEFT | #5B5C5B | Body/Small-Bold |
| Condition (F6) | 1601 | 286 | 84 | 18 | Spoqa Han Sans Neo | 12.0 | 700 | LEFT | #5B5C5B | Body/Small-Bold |
| Reset Condition (F10) | 1721 | 286 | 127 | 18 | Spoqa Han Sans Neo | 12.0 | 700 | LEFT | #5B5C5B | Body/Small-Bold |
| Manual (F1) | 1852 | 286 | 70 | 18 | Spoqa Han Sans Neo | 12.0 | 700 | LEFT | #5B5C5B | Body/Small-Bold |
| 적용 | 1884 | 286 | 23 | 18 | Spoqa Han Sans Neo | 12.0 | 700 | LEFT | #5B5C5B | Body/Small-Bold |
| Column Setting | 1884 | 286 | 92 | 18 | Spoqa Han Sans Neo | 12.0 | 700 | LEFT | #5B5C5B | Body/Small-Bold |
| Measure Setting | 1916 | 286 | 96 | 18 | Spoqa Han Sans Neo | 12.0 | 700 | LEFT | #5B5C5B | Body/Small-Bold |
| Sales Price | 36 | 308 | 185 | 18 | Spoqa Han Sans Neo | 12.0 | 500 | LEFT | #FFFFFF | Left-Area/3Level-Menu-Selected |
| 2026-03 | 1903 | 315 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | CENTER | #1F1F1F | Body/Basic-Bold |
| 2026-04 | 2060 | 315 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | CENTER | #1F1F1F | Body/Basic-Bold |
| 2026-05 | 2217 | 315 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | CENTER | #1F1F1F | Body/Basic-Bold |
| 2026-06 | 2374 | 315 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | CENTER | #1F1F1F | Body/Basic-Bold |
| 2026-07 | 2531 | 315 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | CENTER | #1F1F1F | Body/Basic-Bold |
| 2026-08 | 2688 | 315 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | CENTER | #1F1F1F | Body/Basic-Bold |
| No | 268 | 327 | 28 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | CENTER | #1F1F1F | Body/Basic-Bold |
| Div | 308 | 327 | 44 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | CENTER | #1F1F1F | Body/Basic-Bold |
| Team | 364 | 327 | 128 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | CENTER | #1F1F1F | Body/Basic-Bold |
| End Customer | 504 | 327 | 128 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | CENTER | #1F1F1F | Body/Basic-Bold |
| Sales Site | 644 | 327 | 148 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | CENTER | #1F1F1F | Body/Basic-Bold |
| Model | 804 | 327 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | CENTER | #1F1F1F | Body/Basic-Bold |
| Incoterms | 961 | 327 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | CENTER | #1F1F1F | Body/Basic-Bold |
| FCST Type | 1118 | 327 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | CENTER | #1F1F1F | Body/Basic-Bold |
| Customs Handbook | 1275 | 327 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | CENTER | #1F1F1F | Body/Basic-Bold |
| Currency | 1432 | 327 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | CENTER | #1F1F1F | Body/Basic-Bold |
| Price Exist | 1589 | 327 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | CENTER | #1F1F1F | Body/Basic-Bold |
| Measure | 1746 | 327 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | CENTER | #1F1F1F | Body/Basic-Bold |
| SUM | 1903 | 339 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | CENTER | #1F1F1F | Body/Basic-Bold |
| SUM | 2060 | 339 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | CENTER | #1F1F1F | Body/Basic-Bold |
| SUM | 2217 | 339 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | CENTER | #1F1F1F | Body/Basic-Bold |
| SUM | 2374 | 339 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | CENTER | #1F1F1F | Body/Basic-Bold |
| SUM | 2531 | 339 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | CENTER | #1F1F1F | Body/Basic-Bold |
| SUM | 2688 | 339 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 700 | CENTER | #1F1F1F | Body/Basic-Bold |
| 해외법인 기여율 등록 | 36 | 342 | 185 | 18 | Spoqa Han Sans Neo | 12.0 | 400 | LEFT | #5B5C5B | Left-Area/3Level-Menu |
| 1​ | 268 | 363 | 28 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| MDP2949A9B11 | 804 | 363 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Question | 961 | 363 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| DDP | 1118 | 363 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Mass | 1275 | 363 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| E | 1432 | 363 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| USD | 1589 | 363 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Y | 1746 | 363 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| RTF | 1903 | 363 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| 0.000 | 2060 | 363 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 0.000 | 2217 | 363 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 0.000 | 2374 | 363 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 0.000 | 2531 | 363 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 0.000 | 2688 | 363 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 해외법인 기여매출 | 36 | 376 | 185 | 18 | Spoqa Han Sans Neo | 12.0 | 400 | LEFT | #5B5C5B | Left-Area/3Level-Menu |
| 2 | 268 | 388 | 28 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| MDP2949A9F11 | 804 | 388 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Information | 961 | 388 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| DDP | 1118 | 388 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Mass | 1275 | 388 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| E | 1432 | 388 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| USD | 1589 | 388 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Y | 1746 | 388 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| KRW | 1903 | 388 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| 4,913.200 | 2060 | 388 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 4,913.200 | 2217 | 388 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 4,913.200 | 2374 | 388 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 4,913.200 | 2531 | 388 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 4,913.200 | 2688 | 388 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| ERP EDI MASTER 정비 | 36 | 410 | 185 | 18 | Spoqa Han Sans Neo | 12.0 | 400 | LEFT | #5B5C5B | Left-Area/3Level-Menu |
| 3​ | 268 | 413 | 28 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| MDP2949A9G11 | 804 | 413 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Exclamation | 961 | 413 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| DDP | 1118 | 413 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Mass | 1275 | 413 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| E | 1432 | 413 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| USD | 1589 | 413 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Y | 1746 | 413 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| USD | 1903 | 413 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| 3.460 | 2060 | 413 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 3.460 | 2217 | 413 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 3.460 | 2374 | 413 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 3.460 | 2531 | 413 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 3.460 | 2688 | 413 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 4 | 268 | 438 | 28 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| MDP2949A9C11 | 804 | 438 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Error | 961 | 438 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| DAP | 1118 | 438 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Mass | 1275 | 438 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| E | 1432 | 438 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| USD | 1589 | 438 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Y | 1746 | 438 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| LOC | 1903 | 438 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| 0.000 | 2060 | 438 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 0.000 | 2217 | 438 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 0.000 | 2374 | 438 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 0.000 | 2531 | 438 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 0.000 | 2688 | 438 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| N: N Master Mapping | 36 | 444 | 185 | 18 | Spoqa Han Sans Neo | 12.0 | 400 | LEFT | #5B5C5B | Left-Area/3Level-Menu |
| 5 | 268 | 463 | 28 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| MDP2949A9E11 | 804 | 463 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Information | 961 | 463 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| DAP | 1118 | 463 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Mass | 1275 | 463 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| E | 1432 | 463 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| USD | 1589 | 463 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Y | 1746 | 463 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| RTF | 1903 | 463 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| 3.460 | 2060 | 463 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 3.460 | 2217 | 463 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 3.460 | 2374 | 463 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 3.460 | 2531 | 463 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 3.460 | 2688 | 463 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| Supply Master | 14 | 480 | 188 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Left-Area/2Level-Menu |
| 6 | 268 | 488 | 28 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| MDP2949A9H11 | 804 | 488 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Information | 961 | 488 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| DDP | 1118 | 488 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Mass | 1275 | 488 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| E | 1432 | 488 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| USD | 1589 | 488 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Y | 1746 | 488 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| KRW | 1903 | 488 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| 3,195.000 | 2060 | 488 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 3,195.000 | 2217 | 488 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 3,195.000 | 2374 | 488 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 3,195.000 | 2531 | 488 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 3,195.000 | 2688 | 488 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| Desay_CN_HUI | 644 | 488 | 148 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| 7 | 268 | 513 | 28 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| MDP2949A9I11 | 804 | 513 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Information | 961 | 513 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| DDP | 1118 | 513 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Mass | 1275 | 513 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| E | 1432 | 513 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| USD | 1589 | 513 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Y | 1746 | 513 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| USD | 1903 | 513 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| 2.250 | 2060 | 513 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 2.250 | 2217 | 513 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 2.250 | 2374 | 513 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 2.250 | 2531 | 513 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 2.250 | 2688 | 513 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| Factory Master | 14 | 520 | 188 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Left-Area/2Level-Menu |
| 8 | 268 | 538 | 28 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| MDP2949A9J11 | 804 | 538 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Information | 961 | 538 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| DDP | 1118 | 538 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Mass | 1275 | 538 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| E | 1432 | 538 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| USD | 1589 | 538 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Y | 1746 | 538 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| LOC | 1903 | 538 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| 3.460 | 2060 | 538 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 3.460 | 2217 | 538 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 3.460 | 2374 | 538 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 3.460 | 2531 | 538 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 3.460 | 2688 | 538 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| Shipping Master | 14 | 560 | 188 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Left-Area/2Level-Menu |
| 9 | 268 | 563 | 28 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| MDP2949A9K11 | 804 | 563 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Information | 961 | 563 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| DDP | 1118 | 563 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Mass | 1275 | 563 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| E | 1432 | 563 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| USD | 1589 | 563 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Y | 1746 | 563 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| RTF | 1903 | 563 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| 0.000 | 2060 | 563 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 0.000 | 2217 | 563 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 0.000 | 2374 | 563 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 0.000 | 2531 | 563 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 0.000 | 2688 | 563 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 10 | 268 | 588 | 28 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| MDP2949A9L11 | 804 | 588 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Information | 961 | 588 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| DAP | 1118 | 588 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Sample (dev) | 1275 | 588 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| E | 1432 | 588 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| USD | 1589 | 588 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Y | 1746 | 588 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| KRW | 1903 | 588 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| 3,209.200 | 2060 | 588 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 3,209.200 | 2217 | 588 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 3,209.200 | 2374 | 588 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 3,209.200 | 2531 | 588 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 3,209.200 | 2688 | 588 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| Menu Text | 14 | 600 | 188 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Left-Area/2Level-Menu |
| 11 | 268 | 613 | 28 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| MDP2949A9M11 | 804 | 613 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Information | 961 | 613 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| DAP | 1118 | 613 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Sample (dev) | 1275 | 613 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| E | 1432 | 613 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| USD | 1589 | 613 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Y | 1746 | 613 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| USD | 1903 | 613 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| 2.260 | 2060 | 613 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 2.260 | 2217 | 613 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 2.260 | 2374 | 613 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 2.260 | 2531 | 613 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 2.260 | 2688 | 613 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 12 | 268 | 638 | 28 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| MDP2949A9N11 | 804 | 638 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Information | 961 | 638 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| DDP | 1118 | 638 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Sample (dev) | 1275 | 638 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| E | 1432 | 638 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| USD | 1589 | 638 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Y | 1746 | 638 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| LOC | 1903 | 638 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| 3,195.000 | 2060 | 638 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 3,195.000 | 2217 | 638 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 3,195.000 | 2374 | 638 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 3,195.000 | 2531 | 638 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 3,195.000 | 2688 | 638 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| Menu Text | 14 | 640 | 188 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Left-Area/2Level-Menu |
| 13 | 268 | 663 | 28 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| MDP2949A9O11 | 804 | 663 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Question | 961 | 663 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| DDP | 1118 | 663 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Mass | 1275 | 663 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| E | 1432 | 663 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| USD | 1589 | 663 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Y | 1746 | 663 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| RTF | 1903 | 663 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| 2.250 | 2060 | 663 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 2.250 | 2217 | 663 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 2.250 | 2374 | 663 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 2.250 | 2531 | 663 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 2.250 | 2688 | 663 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| Menu Text | 14 | 680 | 188 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Left-Area/2Level-Menu |
| 40 | 308 | 687 | 44 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| 소형. 마케팅 2. | 364 | 687 | 128 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| NT | 504 | 687 | 128 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| 14 | 268 | 688 | 28 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| MDP2949A9P11 | 804 | 688 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Question | 961 | 688 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| DDP | 1118 | 688 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Mass | 1275 | 688 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| E | 1432 | 688 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| USD | 1589 | 688 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Y | 1746 | 688 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| RTF | 1903 | 688 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| 9,301.000 | 2060 | 688 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 9,301.000 | 2217 | 688 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 9,301.000 | 2374 | 688 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 9,301.000 | 2531 | 688 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 9,301.000 | 2688 | 688 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 15 | 268 | 713 | 28 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| MDP2949A9Q11 | 804 | 713 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Information | 961 | 713 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| DDP | 1118 | 713 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Mass | 1275 | 713 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| E | 1432 | 713 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| USD | 1589 | 713 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Y | 1746 | 713 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| KRW | 1903 | 713 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| 6.550 | 2060 | 713 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 6.550 | 2217 | 713 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 6.550 | 2374 | 713 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 6.550 | 2531 | 713 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 6.550 | 2688 | 713 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| Menu Text | 14 | 720 | 188 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Left-Area/2Level-Menu |
| 16 | 268 | 738 | 28 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| MDP2949A9R11 | 804 | 738 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Question | 961 | 738 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| DAP | 1118 | 738 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Mass | 1275 | 738 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| E | 1432 | 738 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| USD | 1589 | 738 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Y | 1746 | 738 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| USD | 1903 | 738 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| 2.250 | 2060 | 738 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 2.250 | 2217 | 738 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 2.250 | 2374 | 738 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 2.250 | 2531 | 738 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 2.250 | 2688 | 738 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 17 | 268 | 763 | 28 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| MDP2949A9S11 | 804 | 763 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Question | 961 | 763 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| DAP | 1118 | 763 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Mass | 1275 | 763 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| E | 1432 | 763 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| USD | 1589 | 763 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Y | 1746 | 763 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| LOC | 1903 | 763 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| 0.000 | 2060 | 763 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 0.000 | 2217 | 763 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 0.000 | 2374 | 763 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 0.000 | 2531 | 763 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 0.000 | 2688 | 763 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 18 | 268 | 788 | 28 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| MDP2949A9T11 | 804 | 788 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Information | 961 | 788 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| DDP | 1118 | 788 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Mass | 1275 | 788 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| E | 1432 | 788 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| USD | 1589 | 788 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Y | 1746 | 788 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| RTF | 1903 | 788 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| 908.800 | 2060 | 788 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 908.800 | 2217 | 788 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 908.800 | 2374 | 788 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 908.800 | 2531 | 788 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 908.800 | 2688 | 788 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 19 | 268 | 813 | 28 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| MDP2949A9U11 | 804 | 813 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Information | 961 | 813 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| DDP | 1118 | 813 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Mass | 1275 | 813 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| E | 1432 | 813 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| USD | 1589 | 813 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Y | 1746 | 813 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| KRW | 1903 | 813 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| 0.640 | 2060 | 813 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 0.640 | 2217 | 813 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 0.640 | 2374 | 813 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 0.640 | 2531 | 813 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 0.640 | 2688 | 813 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| Foxlink_CN_DGG | 644 | 814 | 148 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| 20 | 268 | 838 | 28 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| MDP2949A9V11 | 804 | 838 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Information | 961 | 838 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| DDP | 1118 | 838 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Mass | 1275 | 838 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| E | 1432 | 838 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| USD | 1589 | 838 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Y | 1746 | 838 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| USD | 1903 | 838 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| 3,209.200 | 2060 | 838 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 3,209.200 | 2217 | 838 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 3,209.200 | 2374 | 838 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 3,209.200 | 2531 | 838 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 3,209.200 | 2688 | 838 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 21 | 268 | 863 | 28 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| MDP2949A9W11 | 804 | 863 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Information | 961 | 863 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| DDP | 1118 | 863 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Mass | 1275 | 863 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| E | 1432 | 863 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| USD | 1589 | 863 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Y | 1746 | 863 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| LOC | 1903 | 863 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| 2.260 | 2060 | 863 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 2.260 | 2217 | 863 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 2.260 | 2374 | 863 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 2.260 | 2531 | 863 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 2.260 | 2688 | 863 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 22 | 268 | 888 | 28 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| MDP2949A9X11 | 804 | 888 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Information | 961 | 888 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| DAP | 1118 | 888 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Mass | 1275 | 888 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| E | 1432 | 888 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| USD | 1589 | 888 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Y | 1746 | 888 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| RTF | 1903 | 888 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| 2.260 | 2060 | 888 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 2.260 | 2217 | 888 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 2.260 | 2374 | 888 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 2.260 | 2531 | 888 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 2.260 | 2688 | 888 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 23 | 268 | 913 | 28 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| MDP2949A9Y11 | 804 | 913 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Information | 961 | 913 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| DAP | 1118 | 913 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Mass | 1275 | 913 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| E | 1432 | 913 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| USD | 1589 | 913 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Y | 1746 | 913 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| KRW | 1903 | 913 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| 0.000 | 2060 | 913 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 0.000 | 2217 | 913 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 0.000 | 2374 | 913 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 0.000 | 2531 | 913 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 0.000 | 2688 | 913 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 24 | 268 | 938 | 28 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| MDP2949A9Z11 | 804 | 938 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Information | 961 | 938 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| DDP | 1118 | 938 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Mass | 1275 | 938 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| E | 1432 | 938 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| USD | 1589 | 938 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Y | 1746 | 938 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| USD | 1903 | 938 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| 9,301.000 | 2060 | 938 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 9,301.000 | 2217 | 938 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 9,301.000 | 2374 | 938 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 9,301.000 | 2531 | 938 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 9,301.000 | 2688 | 938 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 25 | 268 | 963 | 28 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| MDP2949A9AA11 | 804 | 963 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Information | 961 | 963 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| DDP | 1118 | 963 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Sample (dev) | 1275 | 963 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| E | 1432 | 963 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| USD | 1589 | 963 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Y | 1746 | 963 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| LOC | 1903 | 963 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| 6.550 | 2060 | 963 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 6.550 | 2217 | 963 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 6.550 | 2374 | 963 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 6.550 | 2531 | 963 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 6.550 | 2688 | 963 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 26 | 268 | 988 | 28 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| MDP2949A9AB11 | 804 | 988 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Information | 961 | 988 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| DDP | 1118 | 988 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Sample (dev) | 1275 | 988 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| E | 1432 | 988 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| USD | 1589 | 988 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Y | 1746 | 988 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| RTF | 1903 | 988 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| 6.550 | 2060 | 988 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 6.550 | 2217 | 988 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 6.550 | 2374 | 988 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 6.550 | 2531 | 988 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 6.550 | 2688 | 988 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 27 | 268 | 1013 | 28 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| MDP2949A9AC11 | 804 | 1013 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Information | 961 | 1013 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| DDP | 1118 | 1013 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Mass | 1275 | 1013 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| E | 1432 | 1013 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| USD | 1589 | 1013 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| Y | 1746 | 1013 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | CENTER | #1F1F1F | Body/Basic |
| KRW | 1903 | 1013 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | LEFT | #1F1F1F | Body/Basic |
| 0.000 | 2060 | 1013 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 0.000 | 2217 | 1013 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 0.000 | 2374 | 1013 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 0.000 | 2531 | 1013 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |
| 0.000 | 2688 | 1013 | 145 | 20 | Spoqa Han Sans Neo | 13.0 | 400 | RIGHT | #1F1F1F | Body/Basic |

## §3. 색상 토큰 (fill 빈도)

| HEX | 사용 수 |
|---|--:|
| `#1F1F1F` | 446 |
| `#554596` | 383 |
| `#5B5C5B` | 156 |
| `#FFFFFF` | 97 |
| `#F7F9F8` | 93 |
| `#F94B50` | 63 |
| `#979998` | 34 |
| `#F1F4F3` | 24 |
| `#2D9BB2` | 16 |
| `#3C3E3D` | 3 |
| `#C4C4C4` | 3 |
| `#135678` | 2 |
| `#6E706F` | 2 |
| `#00806A` | 2 |
| `#1F7795` | 2 |
| `#D9D9D9` | 2 |
| `#DDE0DF` | 2 |
| `#EBEEED` | 1 |

## §4. 컴포넌트 인스턴스 (Figma 컴포넌트 → @shared/components 매핑 후보)

| 인스턴스 name | 사용 수 | 대표 크기(w×h) |
|---|--:|---|
| #Component/Data Grid/Analytical/Body/Text | 383 | 40×24 |
| #Component/Data Grid/Analytical/RowBG | 94 | 40×25 |
| #Component/Data Grid/Common/Header/Buttons | 48 | 14×14 |
| Spacing/Role | 37 | 8×32 |
| Spacing/Global | 37 | 8×12 |
| Icons/Menu/More/ | 25 | 24×24 |
| Icons/List/Funnel/ | 25 | 16×16 |
| #Component/Data Grid/Analytical/Header | 24 | 40×48 |
| Component/Button | 19 | 32×32 |
| #Pattern/Navigation/Left Menu/Menu Item | 17 | 230×40 |
| Icons/Notification Layer | 17 | 4×4 |
| Icons/Control/Close/ | 12 | 16×16 |
| Icons/Arrow/Chevron2/ | 11 | 10×10 |
| #Pattern/Navigation/MDI Container/Tab Item | 11 | 60×32 |
| Component/Label | 11 | 120×32 |
| Icons/Status/Info/ | 11 | 18×18 |
| #Pattern/Navigation/Header/Top Menu | 9 | 88×52 |
| Icons/Function/Calendar/ | 9 | 16×16 |
| Component/Dropdown/Dropdown Field | 8 | 100×32 |
| #Pattern/Navigation/Left Menu/Menu Item/Icon/1 | 8 | 20×20 |
| Icons/Control/Add/ | 8 | 12×12 |
| Icons/Function/Search/ | 6 | 20×20 |
| Component/Input Field/Text | 4 | 164×32 |
| #Pattern/Navigation/MDI Container/Controls | 4 | 24×24 |
| #Component/Breadcrumb/Item | 4 | 44×18 |
| Icons/Arrow/Chevron/ | 4 | 12×12 |
| #Pattern/Navigation/Header/Util Item | 3 | 24×24 |
| Icons/Function/Setting/ | 3 | 24×24 |
| #Pattern/Navigation/Header/Logo | 2 | 126×36 |
| Component/Divider | 2 | 1×32 |
| Icons/Communication/Bookmark/ | 2 | 24×24 |
| #Pattern/Navigation/Left Menu/Left-Menu-Tab/Tab-Item | 2 | 116×36 |
| Pattern/Navigation/Header | 1 | 1920×52 |
| #Pattern/Navigation/Header/Left_Menu | 1 | 52×52 |
| Icons/Menu/Menu | 1 | 24×24 |
| Component/Input Group Medium | 1 | 296×32 |
| #Pattern/Navigation/Header/Util | 1 | 92×24 |
| #Pattern/Navigation/Header/More Menu | 1 | 24×24 |
| Icons/Status/Help/ | 1 | 24×24 |
| #Pattern/Navigation/Header/Toggle | 1 | 60×30 |
| Icons/Mode/Light/ | 1 | 22×22 |
| #Pattern/Navigation/Header/Dropdown | 1 | 53×24 |
| #Pattern/Navigation/Header/User | 1 | 68×24 |
| Component/Avatar/Single | 1 | 24×24 |
| #Component/Avatar/Single/Contents | 1 | 24×24 |
| Component/Badge/Status Dot | 1 | 14×14 |
| Icons/Control/Confirm/ | 1 | 13×13 |
| Component/Badge/Count Badge | 1 | 16×16 |
| Icons/Menu/Switcher | 1 | 24×24 |
| Pattern/Navigation/Left Menu | 1 | 230×911 |
| #Pattern/Navigation/Left Menu/Head | 1 | 230×64 |
| #Pattern/Navigation/Left Menu/Filtering | 1 | 230×40 |
| Component/Input Field/Search | 1 | 214×32 |
| #Component/Input Field/Icon_Container | 1 | 20×20 |
| #Pattern/Navigation/Left Menu/Left-Menu-Tab | 1 | 230×36 |
| Icons/Control/Substract/ | 1 | 12×12 |
| #Others/Scroll-Thin/Vertical | 1 | 6×200 |
| Component/Handle | 1 | 12×64 |
| Pattern/Navigation/MDI Container | 1 | 1690×32 |
| Icons/File/External-Link/ | 1 | 16×16 |
| Component/Title/Page Title | 1 | 1626×48 |
| #Component/Title/Page Title/Bookmark | 1 | 24×24 |
| Component/Breadcrumb | 1 | 233×18 |
| Component/Switch Label | 1 | 84×20 |
| Component/Switch Only | 1 | 32×18 |
| Component/Input Field/Date&Time | 1 | 216×32 |
| Icons/Edit/Edit-2/ | 1 | 20×20 |
| Icons/Control/Reset/ | 1 | 20×20 |
| Component/Check&Radio | 1 | 130×20 |
| #Component/Check&Radio/Module | 1 | 16×16 |
| Component/Title/Sub Title | 1 | 36×28 |
| #Component/Title/Sub Title/Count | 1 | 55×20 |
| Icons/Arrow/Column Setting | 1 | 16×16 |
| Icons/Edit/Delete/ | 1 | 16×16 |
| Icons/floppy disk | 1 | 16×16 |
| Icons/Arrow/Condensed/ | 1 | 16×16 |
| Icons/List/Todo | 1 | 16×16 |
| Icons/Control/Refresh | 1 | 16×16 |
| Icons/File/Download/ | 1 | 16×16 |
| 3 | 1 | 28×28 |
| Icons/File/Excel_color/ | 1 | 16×16 |
| Icons/List/Control/ | 1 | 16×16 |
| #Others/Scroll | 1 | 1626×642 |
| #Others/Scroll/Horizontal | 1 | 1609×17 |
| #Others/Scroll/Vertical | 1 | 17×625 |

## §5. 타이포그래피 (Figma TEXT style 토큰)

| TEXT style | 사용 수 |
|---|--:|
| Body/Basic | 402 |
| Body/Basic-Bold | 46 |
| Body/Small-Bold | 14 |
| Body/Small | 13 |
| Header-Area/1Level-Menu | 9 |
| Header-Area/Util-Menu | 8 |
| Left-Area/3Level-Menu | 8 |
| Left-Area/2Level-Menu | 7 |
| Title/H1 | 1 |
| Header-Area/Sys-Name-Kor | 1 |
| Header-Area/Sys-Name-Full | 1 |
| Body/Xsmall - Regular | 1 |
| Left-Area/1Level-Menu | 1 |
| Left-Area/2Level-Menu-Selected | 1 |
| Left-Area/3Level-Menu-Selected | 1 |
| Title/H2 | 1 |
| Title/H3 | 1 |
