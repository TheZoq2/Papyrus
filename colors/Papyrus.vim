
" Theme: Papyrus
" Author: Nikyle Nguyen <NLKNguyen@MSN.com>
" License: MIT
" Source: http://github.com/NLKNguyen/papercolor-theme

" Based on PaperColor by Nikyle Nguyen. https://github.com/NLKNguyen/papercolor-theme


hi clear
syntax reset
let g:colors_name = "Papyrus"

" Helper Functions: {{{
" Returns an approximate grey index for the given grey level
fun! s:grey_number(x)
  if &t_Co == 88
    if a:x < 23
      return 0
    elseif a:x < 69
      return 1
    elseif a:x < 103
      return 2
    elseif a:x < 127
      return 3
    elseif a:x < 150
      return 4
    elseif a:x < 173
      return 5
    elseif a:x < 196
      return 6
    elseif a:x < 219
      return 7
    elseif a:x < 243
      return 8
    else
      return 9
    endif
  else
    if a:x < 14
      return 0
    else
      let l:n = (a:x - 8) / 10
      let l:m = (a:x - 8) % 10
      if l:m < 5
        return l:n
      else
        return l:n + 1
      endif
    endif
  endif
endfun

" Returns the actual grey level represented by the grey index
fun! s:grey_level(n)
  if &t_Co == 88
    if a:n == 0
      return 0
    elseif a:n == 1
      return 46
    elseif a:n == 2
      return 92
    elseif a:n == 3
      return 115
    elseif a:n == 4
      return 139
    elseif a:n == 5
      return 162
    elseif a:n == 6
      return 185
    elseif a:n == 7
      return 208
    elseif a:n == 8
      return 231
    else
      return 255
    endif
  else
    if a:n == 0
      return 0
    else
      return 8 + (a:n * 10)
    endif
  endif
endfun

" Returns the palette index for the given grey index
fun! s:grey_colour(n)
  if &t_Co == 88
    if a:n == 0
      return 16
    elseif a:n == 9
      return 79
    else
      return 79 + a:n
    endif
  else
    if a:n == 0
      return 16
    elseif a:n == 25
      return 231
    else
      return 231 + a:n
    endif
  endif
endfun

" Returns an approximate colour index for the given colour level
fun! s:rgb_number(x)
  if &t_Co == 88
    if a:x < 69
      return 0
    elseif a:x < 172
      return 1
    elseif a:x < 230
      return 2
    else
      return 3
    endif
  else
    if a:x < 75
      return 0
    else
      let l:n = (a:x - 55) / 40
      let l:m = (a:x - 55) % 40
      if l:m < 20
        return l:n
      else
        return l:n + 1
      endif
    endif
  endif
endfun

" Returns the actual colour level for the given colour index
fun! s:rgb_level(n)
  if &t_Co == 88
    if a:n == 0
      return 0
    elseif a:n == 1
      return 139
    elseif a:n == 2
      return 205
    else
      return 255
    endif
  else
    if a:n == 0
      return 0
    else
      return 55 + (a:n * 40)
    endif
  endif
endfun

" Returns the palette index for the given R/G/B colour indices
fun! s:rgb_colour(x, y, z)
  if &t_Co == 88
    return 16 + (a:x * 16) + (a:y * 4) + a:z
  else
    return 16 + (a:x * 36) + (a:y * 6) + a:z
  endif
endfun

" Returns the palette index to approximate the given R/G/B colour levels
fun! s:colour(r, g, b)
  " Get the closest grey
  let l:gx = s:grey_number(a:r)
  let l:gy = s:grey_number(a:g)
  let l:gz = s:grey_number(a:b)

  " Get the closest colour
  let l:x = s:rgb_number(a:r)
  let l:y = s:rgb_number(a:g)
  let l:z = s:rgb_number(a:b)

  if l:gx == l:gy && l:gy == l:gz
    " There are two possibilities
    let l:dgr = s:grey_level(l:gx) - a:r
    let l:dgg = s:grey_level(l:gy) - a:g
    let l:dgb = s:grey_level(l:gz) - a:b
    let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb)
    let l:dr = s:rgb_level(l:gx) - a:r
    let l:dg = s:rgb_level(l:gy) - a:g
    let l:db = s:rgb_level(l:gz) - a:b
    let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db)
    if l:dgrey < l:drgb
      " Use the grey
      return s:grey_colour(l:gx)
    else
      " Use the colour
      return s:rgb_colour(l:x, l:y, l:z)
    endif
  else
    " Only one possibility
    return s:rgb_colour(l:x, l:y, l:z)
  endif
endfun

" Returns the palette index to approximate the '#rrggbb' hex string
fun! s:rgb(rgb)
  let l:r = ("0x" . strpart(a:rgb, 1, 2)) + 0
  let l:g = ("0x" . strpart(a:rgb, 3, 2)) + 0
  let l:b = ("0x" . strpart(a:rgb, 5, 2)) + 0

  return s:colour(l:r, l:g, l:b)
endfun

" Sets the highlighting for the given group
fun! s:HL(group, fg, bg, attr)
  if !empty(a:fg)
    " echo "['" . a:fg . "', " . s:rgb(a:fg) . "]"
    exec "hi " . a:group . " guifg=" . a:fg[0] . " ctermfg=" . a:fg[1]
  endif
  if !empty(a:bg)
    " echo  "['" . a:bg . "', " . s:rgb(a:bg) . "]"
    exec "hi " . a:group . " guibg=" . a:bg[0] . " ctermbg=" . a:bg[1]
  endif
  if a:attr != ""
    exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
  endif
endfun

fun! s:Load_Settings_Override(custom)
  if has_key(a:custom, 'cursorline')
    let s:cursorline = [a:custom['cursorline'], '' . s:rgb(a:custom['cursorline'])]
  endif
  if has_key(a:custom, 'background')
    let s:background = [a:custom['background'], '' . s:rgb(a:custom['background'])]
  endif
  if has_key(a:custom, 'matchparen')
    let s:matchparen = [a:custom['matchparen'], '' . s:rgb(a:custom['matchparen'])]
  endif
  if has_key(a:custom, 'comment')
    let s:comment = [a:custom['comment'], '' . s:rgb(a:custom['comment'])]
  endif
endfun
" }}}

" Color Palette: {{{

" These color names are corresponding to the original light version,
" and they don't represent the HEX code that they store in this block.
let s:red     = ['#ae3d3d', '71'] "Include/Exception
let s:yellow   = ['#dfaf00', '178'] "Boolean/Special
let s:blue    = ['#00afaf', '37'] "Keyword
let s:darkPurple = ["#b434db", '0']

let s:green    = ['#acd02d', '112'] "Type
let s:string   = ['#dfaf5f', '179'] "String
let s:navy    = ['#df875f', '173'] "StorageClass

let s:pink  = ['#ff5faf', '205'] "Number
let s:purple  = ['#af87af', '139'] "Repeat/Conditional
let s:aqua    = ['#5fafdf', '74'] "Operator/Delimiter
let s:subtleBlue = ['#85d1b9', '14']
let s:subtlePurple = ['#dc88d5', '135']

let s:string  = ['#99c45b', '167']
let s:operator = ['#e1a71a', '178']

let s:wine  = ['#af8787', '138']

" Basics:
let s:foreground   = ['#d0d0d0', '251']
let s:selection    = ['#3a3a3a', '236']
let s:nontext      = ['#444444', '237']
let s:window       = ['#3a3a3a', '236']
let s:divider      = ['#5f8787', '66']
let s:linenumber   = ['#606060', '240']
let s:comment      = ['#529961', '71']
let s:todo         = ['#ff8700', '208']
let s:cursorcolumn = ['#303030', '235']
let s:error        = ['#5f0000', '52']
let s:matchparen   = ['#4e4e4e', '239']

if exists("g:papyrus_variant") && g:papyrus_variant == "blue"
    let s:background   = ['#0B151D', '234']
    let s:cursorline   = ['#162939', '235']
    let s:cursorlinenr = ['#ffff00', '226']
else
    let s:background   = ['#000000', '234']
    let s:cursorline   = ['#000000', '235']
    let s:cursorlinenr = ['#000000', '226']
endif

" Spelling:
let s:spellbad   = ['#5f0000', '52']
let s:spellcap   = ['#5f005f', '53']
let s:spellrare  = ['#005f00', '22']
let s:spelllocal = ['#00005f', '17']

" Tabline:
let s:tabline_bg          = ['#3a3a3a', '235']
let s:tabline_active_fg   = ['#1c1c1c', '233']
let s:tabline_active_bg   = ['#00afaf', '37']
let s:tabline_inactive_fg = ['#c6c6c6', '250']
let s:tabline_inactive_bg = ['#585858', '240']

" BufTabLine:
let s:buftabline_bg          = ['#3a3a3a', '235']
let s:buftabline_current_fg  = ['#1c1c1c', '233']
let s:buftabline_current_bg  = ['#00afaf', '37']
let s:buftabline_active_fg   = ['#1c1c1c', '233']
let s:buftabline_active_bg   = ['#00afaf', '37']
let s:buftabline_inactive_fg = ['#c6c6c6', '250']
let s:buftabline_inactive_bg = ['#585858', '240']

" Statusline:
let s:statusline_active_fg   = ['#1c1c1c', '233']
let s:statusline_active_bg   = ['#5f8787', '66']
let s:statusline_inactive_fg = ['#c6c6c6', '250']
let s:statusline_inactive_bg = ['#444444', '237']

" Search:
let s:search_fg = ['#000000', '16']
let s:search_bg = ['#00875f', '29']

" Visual:
let s:visual_fg = ['#000000', '16']
let s:visual_bg = ['#8787af', '103']

" Folded:
let s:folded_fg = ['#8289a4', '171']
let s:folded_bg = ['#1c1c1c', '234']

" WildMenu:
let s:wildmenu_fg  = s:background
let s:wildmenu_bg  = ['#afdf00', '148']

" Diff:
let s:diffadd_fg    = ['#000000', '16']
let s:diffadd_bg    = ['#5faf00', '70']

let s:diffdelete_fg = ['#000000', '16']
let s:diffdelete_bg = ['#5f0000', '52']

let s:difftext_fg   = ['#000000', '16']
let s:difftext_bg   = ['#ffdf5f', '221']

let s:diffchange_fg = ['#000000', '16']
let s:diffchange_bg = ['#dfaf00', '178']

let s:conflictmarker_ours = ['#003707', '0']
let s:conflictmarker_theirs = ['#00372e', '0']
let s:conflictmarker_common_ancestors = ['#2a0037', '0']

" User Override Settings:
if exists("g:PaperColor_Dark_Override")
  call s:Load_Settings_Override(g:PaperColor_Dark_Override)
endif
" }}}

" Syntax Highlighting: {{{
if has("gui_running") || &t_Co == 88 || &t_Co == 256

  " Vim Highlighting
  call s:HL("Normal", s:foreground, s:background, "")


  highlight LineNr term=bold cterm=NONE ctermfg=darkgrey ctermbg=NONE gui=NONE guifg=darkgrey guibg=NONE
  call s:HL("NonText", s:nontext, "", "")
  call s:HL("SpecialKey", s:nontext, "", "")
  call s:HL("Search", s:search_fg, s:search_bg, "")
  call s:HL("LineNr", s:linenumber, "", "")
  call s:HL("TabLine", s:tabline_inactive_fg, s:tabline_inactive_bg, "None")
  call s:HL("TabLineFill", "", s:tabline_bg, "None")
  call s:HL("TabLineSel", s:tabline_active_fg, s:tabline_active_bg, "None")

  call s:HL("BufTabLineCurrent", s:buftabline_current_fg, s:buftabline_current_bg, "None")
  call s:HL("BufTabLineActive", s:buftabline_active_fg, s:buftabline_active_bg, "None")
  call s:HL("BufTabLineHidden", s:buftabline_inactive_fg, s:buftabline_inactive_bg, "None")
  call s:HL("BufTabLineFill", "", s:buftabline_bg, "None")

  call s:HL("StatusLine", s:statusline_active_fg, s:statusline_active_bg, "bold")
  call s:HL("StatusLineNC", s:statusline_inactive_fg, s:statusline_inactive_bg, "None")
  call s:HL("VertSplit", s:divider, s:background, "none")
  " call s:HL("VertSplit", s:red, s:background, "none")
  call s:HL("Visual", s:visual_fg, s:visual_bg, "")
  call s:HL("Directory", s:blue, "", "")
  call s:HL("ModeMsg", s:string, "", "")
  call s:HL("MoreMsg", s:string, "", "")
  call s:HL("Question", s:string, "", "")
  call s:HL("WarningMsg", s:green, "", "")
  call s:HL("MatchParen", "", s:matchparen, "")
  call s:HL("Folded", s:folded_fg, s:folded_bg, "")
  call s:HL("FoldColumn", "", s:background, "")
  call s:HL("WildMenu", s:wildmenu_fg, s:wildmenu_bg, "bold")
  if version >= 700
    call s:HL("CursorLine", "", s:cursorline, "none")
    call s:HL("CursorLineNr", s:cursorlinenr, "", "none")
    call s:HL("CursorColumn", "", s:cursorcolumn, "none")
    call s:HL("PMenu", s:foreground, s:selection, "none")
    call s:HL("PMenuSel", s:foreground, s:selection, "reverse")
    call s:HL("SignColumn", s:yellow, s:background, "none")
  end
  if version >= 703
    call s:HL("ColorColumn", "", s:cursorcolumn, "none")
  end

  " Standard Group Highlighting:
  call s:HL("Comment", s:comment, "", "")

  call s:HL("Constant", s:pink, "", "")
  call s:HL("String", s:string, "", "")
  call s:HL("Character", s:string, "", "")
  call s:HL("Number", s:pink, "", "")
  call s:HL("Boolean", s:yellow, "", "bold")
  call s:HL("Float", s:pink, "", "")

  call s:HL("Identifier", s:navy, "", "")
  call s:HL("Function", s:foreground, "", "")

  call s:HL("Statement", s:green, "", "none")
  call s:HL("Conditional", s:purple, "", "bold")
  call s:HL("Repeat", s:purple, "", "bold")
  call s:HL("Label", s:blue, "", "")
  call s:HL("Operator", s:operator, "", "none")
  call s:HL("Keyword", s:blue, "", "")
  call s:HL("Exception", s:red, "", "")

  call s:HL("PreProc", s:darkPurple, "", "")
  call s:HL("Include", s:red, "", "")
  call s:HL("Define", s:blue, "", "")
  call s:HL("Macro", s:blue, "", "")
  call s:HL("PreCondit", s:aqua, "", "")

  call s:HL("Type", s:green, "", "bold")
  call s:HL("StorageClass", s:navy, "", "bold")
  call s:HL("Structure", s:blue, "", "bold")
  call s:HL("Typedef", s:green, "", "bold")

  call s:HL("Special", s:foreground, "", "")
  call s:HL("SpecialChar", s:foreground, "", "")
  call s:HL("Tag", s:yellow, "", "")
  call s:HL("Delimiter",s:aqua, "", "")
  call s:HL("SpecialComment", s:comment, "", "bold")
  call s:HL("Debug", s:pink, "", "")

  "call s:HL("Ignore", "666666", "", "")

  call s:HL("Error", s:foreground, s:error, "undercurl")
  call s:HL("Todo", s:todo, s:background, "bold")

  call s:HL("Title", s:comment, "", "")
  call s:HL("Global", s:blue, "", "")


  " Extension {{{
  " VimL Highlighting
  call s:HL("vimCommand", s:green, "", "none")
  call s:HL("vimVar", s:navy, "", "")
  call s:HL("vimFuncKey", s:green, "", "")
  call s:HL("vimFunction", s:blue, "", "bold")
  call s:HL("vimNotFunc", s:green, "", "")
  call s:HL("vimMap", s:red, "", "")
  call s:HL("vimAutoEvent", s:aqua, "", "bold")
  call s:HL("vimMapModKey", s:aqua, "", "")
  call s:HL("vimFuncName", s:purple, "", "")
  call s:HL("vimIsCommand", s:foreground, "", "")
  call s:HL("vimFuncVar", s:aqua, "", "")
  call s:HL("vimLet", s:red, "", "")
  call s:HL("vimMapRhsExtend", s:foreground, "", "")
  call s:HL("vimCommentTitle", s:comment, "", "bold")
  call s:HL("vimBracket", s:aqua, "", "")
  call s:HL("vimParenSep", s:aqua, "", "")
  call s:HL("vimSynType", s:string, "", "bold")
  call s:HL("vimNotation", s:aqua, "", "")
  call s:HL("vimOper", s:foreground, "", "")
  call s:HL("vimOperParen", s:foreground, "", "")
  call s:HL("vimSynType", s:purple, "", "none")
  call s:HL("vimSynReg", s:green, "", "none")
  call s:HL("vimSynKeyRegion", s:yellow, "", "")
  call s:HL("vimSynRegOpt", s:blue, "", "")
  call s:HL("vimSynMtchOpt", s:blue, "", "")
  call s:HL("vimSynContains", s:green, "", "")
  call s:HL("vimGroupName", s:foreground, "", "")
  call s:HL("vimGroupList", s:foreground, "", "")
  call s:HL("vimHiGroup", s:foreground, "", "")
  call s:HL("vimGroup", s:navy, "", "bold")

  " Makefile Highlighting
  call s:HL("makeIdent", s:blue, "", "")
  call s:HL("makeSpecTarget", s:string, "", "")
  call s:HL("makeTarget", s:red, "", "")
  call s:HL("makeStatement", s:aqua, "", "bold")
  call s:HL("makeCommands", s:foreground, "", "")
  call s:HL("makeSpecial", s:pink, "", "bold")

  " CMake Highlighting
  call s:HL("cmakeStatement", s:green, "", "")
  call s:HL("cmakeArguments", s:foreground, "", "")
  call s:HL("cmakeVariableValue", s:blue, "", "")
  call s:HL("cmakeOperators", s:red, "", "")

  " C Highlighting
  call s:HL("cType", s:green, "", "bold")
  call s:HL("cFormat", s:string, "", "")
  call s:HL("cStorageClass", s:navy, "", "bold")

  call s:HL("cBoolean", s:yellow, "", "")
  call s:HL("cCharacter", s:string, "", "")
  call s:HL("cConstant", s:yellow, "", "bold")
  call s:HL("cConditional", s:purple, "", "bold")
  call s:HL("cSpecial", s:string, "", "bold")
  call s:HL("cDefine", s:blue, "", "")
  call s:HL("cNumber", s:pink, "", "")
  call s:HL("cPreCondit", s:aqua, "", "")
  call s:HL("cRepeat", s:purple, "", "bold")
  call s:HL("cLabel",s:aqua, "", "")
  " call s:HL("cAnsiFunction",s:aqua, "", "bold")
  " call s:HL("cAnsiName",s:green, "", "")
  call s:HL("cDelimiter",s:blue, "", "")
  " call s:HL("cBraces",s:foreground, "", "")
  " call s:HL("cIdentifier",s:blue, s:green, "")
  " call s:HL("cSemiColon","", s:blue, "")
  call s:HL("cOperator",s:operator, "", "")
  " call s:HL("cStatement",s:green, "", "")
  call s:HL("cFunction", s:foreground, "", "")
  " call s:HL("cTodo", s:comment, "", "bold")
  " call s:HL("cStructure", s:blue, "", "bold")
  call s:HL("cCustomParen", s:foreground, "", "")
  " call s:HL("cCustomFunc", s:foreground, "", "")
  " call s:HL("cUserFunction",s:blue, "", "bold")
  call s:HL("cOctalZero", s:purple, "", "bold")

  " CPP highlighting
  call s:HL("cppBoolean", s:navy, "", "")
  call s:HL("cppSTLnamespace", s:purple, "", "")
  call s:HL("cppSTLconstant", s:foreground, "", "")
  call s:HL("cppSTLtype", s:foreground, "", "")
  call s:HL("cppSTLexception", s:green, "", "")
  call s:HL("cppSTLfunctional", s:foreground, "", "bold")
  call s:HL("cppSTLiterator", s:foreground, "", "bold")
  " call s:HL("cppSTLfunction", s:aqua, "", "bold")
  call s:HL("cppExceptions", s:red, "", "")
  call s:HL("cppStatement", s:blue, "", "")
  call s:HL("cppStorageClass", s:navy, "", "bold")
  call s:HL("cppAccess",s:blue, "", "")
  " call s:HL("cppSTL",s:blue, "", "")


  " Lex highlighting
  call s:HL("lexCFunctions", s:foreground, "", "")
  call s:HL("lexAbbrv", s:purple, "", "")
  call s:HL("lexAbbrvRegExp", s:aqua, "", "")
  call s:HL("lexAbbrvComment", s:comment, "", "")
  call s:HL("lexBrace", s:navy, "", "")
  call s:HL("lexPat", s:aqua, "", "")
  call s:HL("lexPatComment", s:comment, "", "")
  call s:HL("lexPatTag", s:pink, "", "")
  " call s:HL("lexPatBlock", s:foreground, "", "bold")
  call s:HL("lexSlashQuote", s:foreground, "", "")
  call s:HL("lexSep", s:foreground, "", "")
  call s:HL("lexStartState", s:pink, "", "")
  call s:HL("lexPatTagZone", s:string, "", "bold")
  call s:HL("lexMorePat", s:string, "", "bold")
  call s:HL("lexOptions", s:string, "", "bold")
  call s:HL("lexPatString", s:string, "", "")

  " Yacc highlighting
  call s:HL("yaccNonterminal", s:navy, "", "")
  call s:HL("yaccDelim", s:pink, "", "")
  call s:HL("yaccInitKey", s:aqua, "", "")
  call s:HL("yaccInit", s:navy, "", "")
  call s:HL("yaccKey", s:purple, "", "")
  call s:HL("yaccVar", s:aqua, "", "")

  " NASM highlighting
  call s:HL("nasmStdInstruction", s:navy, "", "")
  call s:HL("nasmGen08Register", s:aqua, "", "")
  call s:HL("nasmGen16Register", s:aqua, "", "")
  call s:HL("nasmGen32Register", s:aqua, "", "")
  call s:HL("nasmGen64Register", s:aqua, "", "")
  call s:HL("nasmHexNumber", s:purple, "", "")
  call s:HL("nasmStorage", s:aqua, "", "bold")
  call s:HL("nasmLabel", s:green, "", "")
  call s:HL("nasmDirective", s:blue, "", "bold")
  call s:HL("nasmLocalLabel", s:pink, "", "")

  " GAS highlighting
  call s:HL("gasSymbol", s:green, "", "")
  call s:HL("gasDirective", s:blue, "", "bold")
  call s:HL("gasOpcode_386_Base", s:navy, "", "")
  call s:HL("gasDecimalNumber", s:purple, "", "")
  call s:HL("gasSymbolRef", s:green, "", "")
  call s:HL("gasRegisterX86", s:blue, "", "")
  call s:HL("gasOpcode_P6_Base", s:navy, "", "")
  call s:HL("gasDirectiveStore", s:foreground, "", "bold")

  " MIPS highlighting
  call s:HL("mipsInstruction", s:green, "", "")
  call s:HL("mipsRegister", s:navy, "", "")
  call s:HL("mipsLabel", s:aqua, "", "bold")
  call s:HL("mipsDirective", s:purple, "", "bold")

  " Shell/Bash highlighting
  call s:HL("bashStatement", s:foreground, "", "bold")
  call s:HL("shDerefVar", s:aqua, "", "bold")
  call s:HL("shDerefSimple", s:aqua, "", "")
  call s:HL("shFunction", s:pink, "", "bold")
  call s:HL("shStatement", s:foreground, "", "")
  call s:HL("shLoop", s:purple, "", "bold")
  call s:HL("shQuote", s:string, "", "")
  call s:HL("shCaseEsac", s:aqua, "", "bold")
  call s:HL("shSnglCase", s:purple, "", "none")
  call s:HL("shFunctionOne", s:navy, "", "")
  call s:HL("shCase", s:navy, "", "")
  call s:HL("shSetList", s:navy, "", "")
  " @see Dockerfile Highlighting section for more sh*

  " HTML Highlighting
  call s:HL("htmlTitle", s:yellow, "", "bold")
  call s:HL("htmlH1", s:yellow, "", "bold")
  call s:HL("htmlH2", s:aqua, "", "bold")
  call s:HL("htmlH3", s:purple, "", "bold")
  call s:HL("htmlH4", s:pink, "", "bold")
  call s:HL("htmlTag", s:comment, "", "")
  call s:HL("htmlTagName", s:wine, "", "")
  call s:HL("htmlArg", s:green, "", "")
  call s:HL("htmlEndTag", s:comment, "", "")
  call s:HL("htmlString", s:blue, "", "")
  call s:HL("htmlScriptTag", s:comment, "", "")
  call s:HL("htmlBold", s:foreground, "", "bold")
  call s:HL("htmlItalic", s:comment, "", "bold")
  call s:HL("htmlBoldItalic", s:navy, "", "bold")
  " call s:HL("htmlLink", s:blue, "", "bold")
  call s:HL("htmlTagN", s:wine, "", "bold")
  call s:HL("htmlSpecialTagName", s:wine, "", "")
  call s:HL("htmlComment", s:comment, "", "")
  call s:HL("htmlCommentPart", s:comment, "", "")

  " CSS Highlighting
  call s:HL("cssIdentifier", s:green, "", "")
  call s:HL("cssPositioningProp", s:foreground, "", "")
  call s:HL("cssNoise", s:foreground, "", "")
  call s:HL("cssBoxProp", s:foreground, "", "")
  call s:HL("cssTableAttr", s:purple, "", "")
  call s:HL("cssPositioningAttr", s:navy, "", "")
  call s:HL("cssValueLength", s:pink, "", "")

call s:HL("cssFunctionName", s:blue, "", "")
call s:HL("cssUnitDecorators", s:aqua, "", "")
call s:HL("cssColor", s:blue, "", "bold")
call s:HL("cssBraces", s:green, "", "")
call s:HL("cssBackgroundProp", s:foreground, "", "")
call s:HL("cssTextProp", s:foreground, "", "")
call s:HL("cssDimensionProp", s:foreground, "", "")
call s:HL("cssClassName", s:green, "", "")

  " Markdown Highlighting
  call s:HL("markdownHeadingRule", s:green, "", "bold")
  call s:HL("markdownH1", s:green, "", "bold")
  call s:HL("markdownH2", s:pink, "", "bold")
  call s:HL("markdownBlockquote", s:green, "", "")
  call s:HL("markdownCodeBlock", s:string, "", "")
  call s:HL("markdownCode", s:string, "", "")
  call s:HL("markdownLink", s:blue, "", "bold")
  call s:HL("markdownUrl", s:blue, "", "")
  call s:HL("markdownLinkText", s:green, "", "")
  call s:HL("markdownLinkTextDelimiter", s:purple, "", "")
  call s:HL("markdownLinkDelimiter", s:purple, "", "")
  call s:HL("markdownCodeDelimiter", s:blue, "", "")

  call s:HL("mkdCode", s:string, "", "none")
  call s:HL("mkdLink", s:blue, "", "bold")
  call s:HL("mkdURL", s:comment, "", "none")
  call s:HL("mkdString", s:foreground, "", "none")
  call s:HL("mkdBlockQuote", s:foreground, s:window, "none")
  call s:HL("mkdLinkTitle", s:green, "", "none")
  call s:HL("mkdDelimiter", s:aqua, "", "")
  call s:HL("mkdRule", s:green, "", "")

  " reStructuredText Highlighting
  call s:HL("rstSections", s:green, "", "bold")
  call s:HL("rstDelimiter", s:green, "", "bold")
  call s:HL("rstExplicitMarkup", s:green, "", "bold")
  call s:HL("rstDirective", s:blue, "", "")
  call s:HL("rstHyperlinkTarget", s:yellow, "", "")
  call s:HL("rstExDirective", s:foreground, "", "")
  call s:HL("rstInlineLiteral", s:string, "", "")
  call s:HL("rstInterpretedTextOrHyperlinkReference", s:blue, "", "")

  " Python Highlighting
  call s:HL("pythonImport", s:green, "", "bold")
  call s:HL("pythonExceptions", s:red, "", "")
  call s:HL("pythonException", s:purple, "", "bold")
  call s:HL("pythonInclude", s:red, "", "")
  call s:HL("pythonStatement", s:green, "", "")
  call s:HL("pythonConditional", s:purple, "", "bold")
  call s:HL("pythonRepeat", s:purple, "", "bold")
  call s:HL("pythonFunction", s:aqua, "", "bold")
  call s:HL("pythonPreCondit", s:purple, "", "")
  call s:HL("pythonExClass", s:pink, "", "")
  call s:HL("pythonOperator", s:operator, "", "bold")
  call s:HL("pythonBuiltin", s:foreground, "", "")
  call s:HL("pythonDecorator", s:pink, "", "")

  call s:HL("pythonString", s:string, "", "")
  call s:HL("pythonEscape", s:string, "", "bold")
  call s:HL("pythonStrFormatting", s:string, "", "bold")

  call s:HL("pythonBoolean", s:yellow, "", "bold")
  call s:HL("pythonExClass", s:red, "", "")
  call s:HL("pythonBytesEscape", s:string, "", "bold")
  call s:HL("pythonDottedName", s:purple, "", "")
  call s:HL("pythonStrFormat", s:foreground, "", "")
  call s:HL("pythonBuiltinFunc", s:foreground, "", "")
  call s:HL("pythonBuiltinObj", s:foreground, "", "")

  " Java Highlighting
  call s:HL("javaExternal", s:green, "", "")
  call s:HL("javaAnnotation", s:pink, "", "")
  call s:HL("javaTypedef", s:aqua, "", "")
  call s:HL("javaClassDecl", s:aqua, "", "bold")
  call s:HL("javaScopeDecl", s:blue, "", "bold")
  call s:HL("javaStorageClass", s:navy, "", "bold")
  call s:HL("javaBoolean", s:yellow, "", "bold")
  call s:HL("javaConstant", s:blue, "", "")
  call s:HL("javaCommentTitle", s:wine, "", "")
  call s:HL("javaDocTags", s:aqua, "", "")
  call s:HL("javaDocComment", s:comment, "", "")
  call s:HL("javaDocParam", s:foreground, "", "")

  " JavaScript Highlighting
  call s:HL("javaScriptBraces", s:blue, "", "")
  call s:HL("javaScriptParens", s:blue, "", "")
  call s:HL("javaScriptIdentifier", s:green, "", "")
  call s:HL("javaScriptFunction", s:blue, "", "bold")
  call s:HL("javaScriptConditional", s:purple, "", "bold")
  call s:HL("javaScriptRepeat", s:purple, "", "bold")
  call s:HL("javaScriptBoolean", s:yellow, "", "bold")
  call s:HL("javaScriptNumber", s:pink, "", "")
  call s:HL("javaScriptMember", s:navy, "", "")
  call s:HL("javaScriptReserved", s:navy, "", "")
  call s:HL("javascriptNull", s:comment, "", "bold")
  call s:HL("javascriptGlobal", s:foreground, "", "")
  call s:HL("javascriptStatement", s:green, "", "")
  call s:HL("javaScriptMessage", s:foreground, "", "")
  call s:HL("javaScriptMember", s:foreground, "", "")

  " @target https://github.com/pangloss/vim-javascript
  call s:HL("jsFuncParens", s:blue, "", "")
  call s:HL("jsFuncBraces", s:blue, "", "")
  call s:HL("jsParens", s:blue, "", "")
  call s:HL("jsBraces", s:blue, "", "")
  call s:HL("jsNoise", s:blue, "", "")

  " Json Highlighting
  " @target https://github.com/elzr/vim-json
  call s:HL("jsonKeyword", s:blue, "", "")
  call s:HL("jsonString", s:string, "", "")
  call s:HL("jsonQuote", s:comment, "", "")
  call s:HL("jsonNoise", s:foreground, "", "")
  call s:HL("jsonKeywordMatch", s:foreground, "", "")
  call s:HL("jsonBraces", s:foreground, "", "")
  call s:HL("jsonNumber", s:pink, "", "")
  call s:HL("jsonNull", s:purple, "", "bold")
  call s:HL("jsonBoolean", s:yellow, "", "bold")
  call s:HL("jsonCommentError", s:green, s:background , "")

  " Go Highlighting
  call s:HL("goDirective", s:red, "", "")
  call s:HL("goDeclaration", s:blue, "", "bold")
  call s:HL("goStatement", s:green, "", "")
  call s:HL("goConditional", s:purple, "", "bold")
  call s:HL("goConstants", s:pink, "", "")
  call s:HL("goFunction", s:pink, "", "")
  " call s:HL("goTodo", s:comment, "", "bold")
  call s:HL("goDeclType", s:blue, "", "")
  call s:HL("goBuiltins", s:purple, "", "")

  " Systemtap Highlighting
  " call s:HL("stapBlock", s:comment, "", "none")
  call s:HL("stapComment", s:comment, "", "none")
  call s:HL("stapProbe", s:aqua, "", "bold")
  call s:HL("stapStat", s:navy, "", "bold")
  call s:HL("stapFunc", s:foreground, "", "")
  call s:HL("stapString", s:string, "", "")
  call s:HL("stapTarget", s:navy, "", "")
  call s:HL("stapStatement", s:green, "", "")
  call s:HL("stapType", s:green, "", "bold")
  call s:HL("stapSharpBang", s:comment, "", "")
  call s:HL("stapDeclaration", s:green, "", "")
  call s:HL("stapCMacro", s:blue, "", "")

  " DTrace Highlighting
  call s:HL("dtraceProbe", s:blue, "", "")
  call s:HL("dtracePredicate", s:purple, "", "bold")
  call s:HL("dtraceComment", s:comment, "", "")
  call s:HL("dtraceFunction", s:foreground, "", "")
  call s:HL("dtraceAggregatingFunction", s:blue, "", "bold")
  call s:HL("dtraceStatement", s:navy, "", "bold")
  call s:HL("dtraceIdentifier", s:green, "", "")
  call s:HL("dtraceOption", s:green, "", "")
  call s:HL("dtraceConstant", s:pink, "", "")
  call s:HL("dtraceType", s:green, "", "bold")

  " PlantUML Highlighting
  call s:HL("plantumlPreProc", s:pink, "", "bold")
  call s:HL("plantumlDirectedOrVerticalArrowRL", s:green, "", "")
  call s:HL("plantumlDirectedOrVerticalArrowLR", s:green, "", "")
  call s:HL("plantumlString", s:string, "", "")
  call s:HL("plantumlActivityThing", s:purple, "", "")
  call s:HL("plantumlText", s:navy, "", "")
  call s:HL("plantumlClassPublic", s:string, "", "bold")
  call s:HL("plantumlClassPrivate", s:red, "", "")
  call s:HL("plantumlColonLine", s:pink, "", "")
  call s:HL("plantumlClass", s:navy, "", "")
  call s:HL("plantumlHorizontalArrow", s:green, "", "")
  call s:HL("plantumlTypeKeyword", s:blue, "", "bold")
  call s:HL("plantumlKeyword", s:green, "", "bold")

  call s:HL("plantumlType", s:blue, "", "bold")
  call s:HL("plantumlBlock", s:green, "", "bold")
  call s:HL("plantumlPreposition", s:pink, "", "")
  call s:HL("plantumlLayout", s:blue, "", "bold")
  call s:HL("plantumlNote", s:pink, "", "")
  call s:HL("plantumlLifecycle", s:aqua, "", "")
  call s:HL("plantumlParticipant", s:foreground, "", "bold")


  " Haskell Highlighting
  call s:HL("haskellType", s:aqua, "", "bold")
  call s:HL("haskellIdentifier", s:pink, "", "bold")
  call s:HL("haskellOperators", s:operator, "", "")
  call s:HL("haskellWhere", s:foreground, "", "bold")
  call s:HL("haskellDelimiter", s:aqua, "", "")
  call s:HL("haskellImportKeywords", s:green, "", "")
  call s:HL("haskellStatement", s:purple, "", "bold")


  " SQL/MySQL Highlighting
  call s:HL("sqlStatement", s:green, "", "bold")
  call s:HL("sqlType", s:blue, "", "bold")
  call s:HL("sqlKeyword", s:green, "", "")
  call s:HL("sqlOperator", s:operator, "", "")
  call s:HL("sqlSpecial", s:yellow, "", "bold")

  call s:HL("mysqlVariable", s:string, "", "bold")
  call s:HL("mysqlType", s:blue, "", "bold")
  call s:HL("mysqlKeyword", s:green, "", "")
  call s:HL("mysqlOperator", s:operator, "", "")
  call s:HL("mysqlSpecial", s:yellow, "", "bold")


  " Octave/MATLAB Highlighting
  call s:HL("octaveVariable", s:foreground, "", "")
  call s:HL("octaveDelimiter", s:green, "", "")
  call s:HL("octaveQueryVar", s:foreground, "", "")
  call s:HL("octaveSemicolon", s:purple, "", "")
  call s:HL("octaveFunction", s:navy, "", "")
  call s:HL("octaveSetVar", s:blue, "", "")
  call s:HL("octaveUserVar", s:foreground, "", "")
  call s:HL("octaveArithmeticOperator", s:operator, "", "")
  call s:HL("octaveBeginKeyword", s:purple, "", "bold")
  call s:HL("octaveElseKeyword", s:purple, "", "bold")
  call s:HL("octaveEndKeyword", s:purple, "", "bold")
  call s:HL("octaveStatement", s:green, "", "")

  " Ruby Highlighting
  call s:HL("rubyModule", s:navy, "", "bold")
  call s:HL("rubyClass", s:green, "", "bold")
  call s:HL("rubyPseudoVariable", s:comment, "", "bold")
  call s:HL("rubyKeyword", s:green, "", "")
  call s:HL("rubyInstanceVariable", s:purple, "", "")
  call s:HL("rubyFunction", s:foreground, "", "bold")
  call s:HL("rubyDefine", s:green, "", "")
  call s:HL("rubySymbol", s:aqua, "", "")
  call s:HL("rubyConstant", s:blue, "", "")
  call s:HL("rubyAccess", s:navy, "", "")
  call s:HL("rubyAttribute", s:yellow, "", "")
  call s:HL("rubyInclude", s:red, "", "")
  call s:HL("rubyLocalVariableOrMethod", s:pink, "", "")
  call s:HL("rubyCurlyBlock", s:foreground, "", "")
  call s:HL("rubyCurlyBlockDelimiter", s:aqua, "", "")
  call s:HL("rubyArrayDelimiter", s:aqua, "", "")
  call s:HL("rubyStringDelimiter", s:string, "", "")
  call s:HL("rubyInterpolationDelimiter", s:pink, "", "")
  call s:HL("rubyConditional", s:green, "", "bold")
  call s:HL("rubyRepeat", s:purple, "", "bold")
  call s:HL("rubyControl", s:purple, "", "bold")
  call s:HL("rubyException", s:purple, "", "bold")
  call s:HL("rubyExceptional", s:purple, "", "bold")
  call s:HL("rubyBoolean", s:yellow, "", "bold")

  " Rust Highlighting
  call s:HL("rustLabel", s:aqua, "", "")
  call s:HL("rustLifetime", s:subtlePurple, "", "")

  " Fortran Highlighting
  call s:HL("fortranUnitHeader", s:foreground, "", "bold")
  call s:HL("fortranType", s:green, "", "bold")
  call s:HL("fortranStructure", s:blue, "", "bold")
  call s:HL("fortranStorageClass", s:navy, "", "bold")
  call s:HL("fortranStorageClassR", s:navy, "", "bold")
  call s:HL("fortranKeyword", s:green, "", "")
  call s:HL("fortranReadWrite", s:blue, "", "")
  call s:HL("fortranIO", s:navy, "", "")

  " R Highlighting
  call s:HL("rType", s:blue, "", "")
  call s:HL("rArrow", s:green, "", "")
  call s:HL("rDollar", s:blue, "", "")

  " XXD Highlighting
  call s:HL("xxdAddress", s:navy, "", "")
  call s:HL("xxdSep", s:green, "", "")
  call s:HL("xxdAscii", s:green, "", "")
  call s:HL("xxdDot", s:aqua, "", "")

  " PHP Highlighting
  call s:HL("phpIdentifier", s:foreground, "", "")
  call s:HL("phpVarSelector", s:green, "", "")
  call s:HL("phpKeyword", s:blue, "", "")
  call s:HL("phpRepeat", s:purple, "", "bold")
  call s:HL("phpConditional", s:purple, "", "bold")
  call s:HL("phpStatement", s:green, "", "")
  call s:HL("phpAssignByRef", s:aqua, "", "bold")
  call s:HL("phpSpecialFunction", s:blue, "", "")
  call s:HL("phpFunctions", s:blue, "", "")
  call s:HL("phpComparison", s:aqua, "", "")
  call s:HL("phpBackslashSequences", s:string, "", "bold")
  call s:HL("phpMemberSelector", s:blue, "", "")
  call s:HL("phpStorageClass", s:purple, "", "bold")
  call s:HL("phpDefine", s:navy, "", "")

  " Perl Highlighting
  call s:HL("perlFiledescRead", s:yellow, "", "")
  call s:HL("perlMatchStartEnd", s:green, "", "")
  call s:HL("perlStatementFlow", s:green, "", "")
  call s:HL("perlStatementStorage", s:green, "", "")
  call s:HL("perlFunction", s:green, "", "bold")
  call s:HL("perlMethod", s:foreground, "", "")
  call s:HL("perlStatementFiledesc", s:pink, "", "")
  call s:HL("perlVarPlain", s:navy, "", "")
  call s:HL("perlSharpBang", s:comment, "", "")
  call s:HL("perlStatementInclude", s:aqua, "", "bold")
  call s:HL("perlStatementScalar", s:purple, "", "")
  call s:HL("perlSubName", s:aqua, "", "bold")
  call s:HL("perlSpecialString", s:string, "", "bold")

  " Pascal Highlighting
  call s:HL("pascalType", s:green, "", "bold")
  call s:HL("pascalStatement", s:blue, "", "bold")
  call s:HL("pascalPredefined", s:green, "", "")
  call s:HL("pascalFunction", s:foreground, "", "")
  call s:HL("pascalStruct", s:navy, "", "bold")
  call s:HL("pascalOperator", s:operator, "", "bold")
  call s:HL("pascalPreProc", s:yellow, "", "")
  call s:HL("pascalAcces", s:navy, "", "bold")

  " Lua Highlighting
  call s:HL("luaFunc", s:foreground, "", "")
  call s:HL("luaIn", s:blue, "", "bold")
  call s:HL("luaFunction", s:green, "", "")
  call s:HL("luaStatement", s:blue, "", "")
  call s:HL("luaRepeat", s:blue, "", "bold")
  call s:HL("luaCondStart", s:purple, "", "bold")
  call s:HL("luaTable", s:aqua, "", "bold")
  call s:HL("luaConstant", s:yellow, "", "bold")
  call s:HL("luaElse", s:purple, "", "bold")
  call s:HL("luaCondElseif", s:purple, "", "bold")
  call s:HL("luaCond", s:purple, "", "bold")
  call s:HL("luaCondEnd", s:purple, "", "")

  " Clojure highlighting:
  call s:HL("clojureConstant", s:blue, "", "")
  call s:HL("clojureBoolean", s:pink, "", "")
  call s:HL("clojureCharacter", s:string, "", "")
  call s:HL("clojureKeyword", s:green, "", "")
  call s:HL("clojureNumber", s:pink, "", "")
  call s:HL("clojureString", s:string, "", "")
  call s:HL("clojureRegexp", s:purple, "", "")
  call s:HL("clojureRegexpEscape", s:green, "", "")
  call s:HL("clojureParen", s:aqua, "", "")
  call s:HL("clojureVariable", s:string, "", "")
  call s:HL("clojureCond", s:blue, "", "")
  call s:HL("clojureDefine", s:blue, "", "bold")
  call s:HL("clojureException", s:red, "", "")
  call s:HL("clojureFunc", s:navy, "", "")
  call s:HL("clojureMacro", s:blue, "", "")
  call s:HL("clojureRepeat", s:blue, "", "")
  call s:HL("clojureSpecial", s:blue, "", "bold")
  call s:HL("clojureQuote", s:blue, "", "")
  call s:HL("clojureUnquote", s:blue, "", "")
  call s:HL("clojureMeta", s:blue, "", "")
  call s:HL("clojureDeref", s:blue, "", "")
  call s:HL("clojureAnonArg", s:blue, "", "")
  call s:HL("clojureRepeat", s:blue, "", "")
  call s:HL("clojureDispatch", s:aqua, "", "")

  " Dockerfile Highlighting
  " @target https://github.com/docker/docker/tree/master/contrib/syntax/vim
  call s:HL("dockerfileKeyword", s:blue, "", "")
  call s:HL("shDerefVar", s:purple, "", "bold")
  call s:HL("shOperator", s:operator, "", "")
  call s:HL("shOption", s:navy, "", "")
  call s:HL("shLine", s:foreground, "", "")
  call s:HL("shWrapLineOperator", s:operator, "", "")

  " NGINX Highlighting
  " @target https://github.com/evanmiller/nginx-vim-syntax
  call s:HL("ngxDirectiveBlock", s:green, "", "bold")
  call s:HL("ngxDirective", s:blue, "", "none")
  call s:HL("ngxDirectiveImportant", s:blue, "", "bold")
  call s:HL("ngxString", s:string, "", "")
  call s:HL("ngxVariableString", s:purple, "", "")
  call s:HL("ngxVariable", s:purple, "", "none")

  " Yaml Highlighting
  call s:HL("yamlBlockMappingKey", s:blue, "", "")
  call s:HL("yamlKeyValueDelimiter", s:green, "", "")
  call s:HL("yamlBlockCollectionItemStart", s:green, "", "")

  " Qt QML Highlighting
  call s:HL("qmlObjectLiteralType", s:green, "", "")
  call s:HL("qmlReserved", s:purple, "", "")
  call s:HL("qmlBindingProperty", s:navy, "", "")
  call s:HL("qmlType", s:navy, "", "")

  " Dosini Highlighting
  call s:HL("dosiniHeader", s:green, "", "")
  call s:HL("dosiniLabel", s:blue, "", "")

  " Mail highlighting
  call s:HL("mailHeaderKey", s:blue, "", "")
  call s:HL("mailHeaderEmail", s:purple, "", "")
  call s:HL("mailSubject", s:green, "", "")
  call s:HL("mailHeader", s:comment, "", "")
  call s:HL("mailURL", s:aqua, "", "")
  call s:HL("mailEmail", s:purple, "", "")
  call s:HL("mailQuoted1", s:string, "", "")
  call s:HL("mailQuoted2", s:navy, "", "")

  " XML Highlighting
  call s:HL("xmlProcessingDelim", s:green, "", "")
  call s:HL("xmlString", s:string, "", "")
  call s:HL("xmlEqual", s:pink, "", "")
  call s:HL("xmlAttrib", s:navy, "", "")
  call s:HL("xmlAttribPunct", s:green, "", "")
  call s:HL("xmlTag", s:blue, "", "")
  call s:HL("xmlTagName", s:blue, "", "")
  call s:HL("xmlEndTag", s:blue, "", "")
  call s:HL("xmlNamespace", s:pink, "", "")

  " Exlixir Highlighting
  " @target https://github.com/elixir-lang/vim-elixir
  call s:HL("elixirAlias", s:blue, "", "bold")
  call s:HL("elixirAtom", s:navy, "", "")
  call s:HL("elixirVariable", s:navy, "", "")
  call s:HL("elixirUnusedVariable", s:comment, "", "")
  call s:HL("elixirInclude", s:purple, "", "")
  call s:HL("elixirStringDelimiter", s:string, "", "")
  call s:HL("elixirKeyword", s:purple, "", "bold")
  call s:HL("elixirFunctionDeclaration", s:foreground, "", "bold")
  call s:HL("elixirBlockDefinition", s:green, "", "")
  call s:HL("elixirDefine", s:green, "", "")
  call s:HL("elixirStructDefine", s:green, "", "")
  call s:HL("elixirPrivateDefine", s:green, "", "")
  call s:HL("elixirModuleDefine", s:green, "", "")
  call s:HL("elixirProtocolDefine", s:green, "", "")
  call s:HL("elixirImplDefine", s:green, "", "")

  " Erlang Highlighting
  call s:HL("erlangBIF", s:purple, "", "bold,")
  call s:HL("erlangBracket", s:green, "", "")
  call s:HL("erlangLocalFuncCall", s:foreground, "", "")
  call s:HL("erlangVariable", s:foreground, "", "")
  call s:HL("erlangAtom", s:navy, "", "")
  call s:HL("erlangAttribute", s:blue, "", "bold")
  call s:HL("erlangRecordDef", s:blue, "", "bold")
  call s:HL("erlangRecord", s:blue, "", "")
  call s:HL("erlangRightArrow", s:blue, "", "bold")
  call s:HL("erlangStringModifier", s:string, "", "bold")
  call s:HL("erlangInclude", s:blue, "", "bold")
  call s:HL("erlangKeyword", s:green, "", "")
  call s:HL("erlangGlobalFuncCall", s:foreground, "", "")

  " Cucumber Highlighting
  call s:HL("cucumberFeature", s:blue, "", "bold")
  call s:HL("cucumberBackground", s:green, "", "bold")
  call s:HL("cucumberScenario", s:green, "", "bold")
  call s:HL("cucumberGiven", s:pink, "", "")
  call s:HL("cucumberGivenAnd", s:blue, "", "")
  call s:HL("cucumberThen", s:pink, "", "")
  call s:HL("cucumberThenAnd", s:blue, "", "")
  call s:HL("cucumberWhen", s:purple, "", "bold")
  call s:HL("cucumberScenarioOutline", s:green, "", "bold")
  call s:HL("cucumberExamples", s:aqua, "", "")
  call s:HL("cucumberTags", s:aqua, "", "")
  call s:HL("cucumberPlaceholder", s:aqua, "", "")
  " }}}

  " Plugin: Netrw
  call s:HL("netrwVersion", s:red, "", "")
  call s:HL("netrwList", s:green, "", "")
  call s:HL("netrwHidePat", s:string, "", "")
  call s:HL("netrwQuickHelp", s:blue, "", "")
  call s:HL("netrwHelpCmd", s:blue, "", "")
  call s:HL("netrwDir", s:aqua, "", "bold")
  call s:HL("netrwClassify", s:green, "", "")
  call s:HL("netrwExe", s:yellow, "", "")
  call s:HL("netrwSuffixes", s:comment, "", "")
  call s:HL("netrwTreeBar", s:linenumber, "", "")

  " Plugin: NERDTree
  call s:HL("NERDTreeUp", s:comment, "", "")
  call s:HL("NERDTreeHelpCommand", s:green, "", "")
  call s:HL("NERDTreeHelpTitle", s:blue, "", "bold")
  call s:HL("NERDTreeHelpKey", s:green, "", "")
  call s:HL("NERDTreeHelp", s:foreground, "", "")
  call s:HL("NERDTreeToggleOff", s:red, "", "")
  call s:HL("NERDTreeToggleOn", s:yellow, "", "")
  call s:HL("NERDTreeDir", s:blue, "", "bold")
  call s:HL("NERDTreeDirSlash", s:green, "", "")
  call s:HL("NERDTreeFile", s:foreground, "", "")
  call s:HL("NERDTreeExecFile", s:yellow, "", "")
  call s:HL("NERDTreeOpenable", s:green, "", "bold")
  call s:HL("NERDTreeClosable", s:green, "", "")

  " Plugin: Tagbar
  call s:HL("TagbarHelpTitle", s:blue, "", "bold")
  call s:HL("TagbarHelp", s:foreground, "", "")
  call s:HL("TagbarKind", s:green, "", "")
  call s:HL("TagbarSignature", s:aqua, "", "")

  " Plugin: Vimdiff
  call s:HL("DiffAdd",    s:diffadd_fg,    s:diffadd_bg,    "none")
  call s:HL("DiffChange", s:diffchange_fg, s:diffchange_bg, "none")
  call s:HL("DiffDelete", s:diffdelete_fg, s:diffdelete_bg, "none")
  call s:HL("DiffText",   s:difftext_fg,   s:difftext_bg,   "none")

  " Plugin: Spell Checking
  call s:HL("SpellBad",   "", "",   "undercurl")
  call s:HL("SpellCap",   s:foreground, s:spellcap,   "undercurl")
  call s:HL("SpellRare",  s:foreground, s:spellrare,  "")
  call s:HL("SpellLocal", s:foreground, s:spelllocal, "")

  " Plugin: Indent Guides
  call s:HL("IndentGuidesOdd", "", s:background, "")
  call s:HL("IndentGuidesEven", "", s:cursorline, "")

  " Plugin: Startify
  call s:HL("StartifyFile", s:blue, "", "bold")
  call s:HL("StartifyPath", s:foreground, "", "")
  call s:HL("StartifySlash", s:navy, "", "")
  call s:HL("StartifyBracket", s:aqua, "", "")
  call s:HL("StartifySpecial", s:aqua, "", "")

  " Git
  call s:HL("diffAdded", s:string, "", "")
  call s:HL("diffRemoved", s:green, "", "")
  call s:HL("gitcommitSummary", "", "", "bold")


  " Elm
  call s:HL("elmOperator", s:operator, "", "")
  call s:HL("elmType", s:subtlePurple, "", "")
  call s:HL("elmImport", s:red, "", "")

  " Treesitter
  call s:HL("@include", s:blue, "", "")
  call s:HL("@type", s:foreground, "", "bold,italic")
  call s:HL("@namespace", s:red, "", "")
  call s:HL("@TSType", s:foreground, "", "bold,italic")
  call s:HL("@TSFunction", s:foreground, "", "bold")
  call s:HL("@TSConstBuiltin", s:pink, "", "")
  call s:HL("@TSInclude", s:blue, "", "")
  call s:HL("@label", s:aqua, "", "italic")
  call s:HL("@constant.builtin", s:pink, "", "bold")
  call s:HL("@type.builtin", s:green, "", "")
  call s:HL("@variable", s:foreground, "", "")
  call s:HL("@variable.builtin", s:pink, "", "")

  call s:HL("@punctuation.delimiter", s:foreground, "", "")
  call s:HL("@punctuation.bracket", s:foreground, "", "")
  call s:HL("@punctuation.bracket", s:foreground, "", "")

  call s:HL("@TSRustGeneric", s:operator, "", "")
  call s:HL("@TSRustMutSpecifier", s:subtlePurple, "", "")
  call s:HL("@TSRustTypeInPath", s:red, "", "bold")

  " Spade
  call s:HL("spadeLabel", s:aqua, "", "")
  call s:HL("spadeIdent", s:foreground, "", "")

  call s:HL("ConflictMarkerOurs", "", s:conflictmarker_ours, "")
  call s:HL("ConflictMarkerTheirs", "", s:conflictmarker_theirs, "")
  call s:HL("ConflictMarkerCommonAncestorsHunk", "", s:conflictmarker_common_ancestors, "")


  let s:error_color = "red"
  let s:error_color = "yellow"


  hi! LspDiagnosticsDefaultError           guifg=#960000 guibg=#000000
  hi! LspDiagnosticsSignError              guifg=#960000 guibg=#000000
  hi! LspDiagnosticsFloatingError          guifg=#960000 guibg=#000000
  hi! LspDiagnosticsVirtualTextError       guifg=#960000 guibg=#000000
  hi! LspDiagnosticsUnderlineError                       guisp=#ee1e1e cterm=undercurl gui=undercurl

  hi! LspDiagnosticsDefaultWarning         guifg=#eeac16 guibg=#000000
  hi! LspDiagnosticsSignWarning            guifg=#eeac16 guibg=#000000
  hi! LspDiagnosticsFloatingWarning        guifg=#eeac16 guibg=#000000
  hi! LspDiagnosticsVirtualTextWarning     guifg=#eeac16 guibg=#000000
  hi! LspDiagnosticsUnderlineWarning                     guisp=#eeac16 cterm=undercurl gui=undercurl

  hi! LspDiagnosticsDefaultInformation     guifg=#9c16ee guibg=#000000
  hi! LspDiagnosticsSignInformation        guifg=#9c16ee guibg=#000000
  hi! LspDiagnosticsFloatingInformation    guifg=#9c16ee guibg=#000000
  hi! LspDiagnosticsVirtualTextInformation guifg=#9c16ee guibg=#000000
  hi! LspDiagnosticsUnderlineInformation                 guisp=#9c16ee cterm=undercurl gui=undercurl
                                                                                                     
  hi! LspDiagnosticsDefaultHint            guifg=#1681ee guibg=#000000
  hi! LspDiagnosticsSignHint               guifg=#1681ee guibg=#000000
  hi! LspDiagnosticsFloatingHint           guifg=#1681ee guibg=#000000
  hi! LspDiagnosticsVirtualTextHint        guifg=#1681ee guibg=#000000
  hi! LspDiagnosticsUnderlineHint                        guisp=#1681ee cterm=undercurl gui=undercurl

  hi! LspSignatureActiveParameter guifg=#ce1ebf


  hi! link DiagnosticError LspDiagnosticsDefaultError
  hi! link DiagnosticWarn LspDiagnosticsDefaultWarning
  hi! link DiagnosticInfo LspDiagnosticsDefaultInformation
  hi! link DiagnosticHint LspDiagnosticsDefaultHint
  hi! link DiagnosticVirtualTextWarn LspDiagnosticsVirtualTextWarning
  hi! link DiagnosticUnderlineWarn LspDiagnosticsUnderlineWarning
  hi! link DiagnosticFloatingWarn LspDiagnosticsFloatingWarning
  hi! link DiagnosticSignWarn LspDiagnosticsSignWarning
  hi! link DiagnosticVirtualTextError LspDiagnosticsVirtualTextError
  hi! link DiagnosticUnderlineError LspDiagnosticsUnderlineError
  hi! link DiagnosticFloatingError LspDiagnosticsFloatingError
  hi! link DiagnosticSignError LspDiagnosticsSignError
  hi! link DiagnosticVirtualTextInfo LspDiagnosticsVirtualTextInformation
  hi! link DiagnosticUnderlineInfo LspDiagnosticsUnderlineInformation
  hi! link DiagnosticFloatingInfo LspDiagnosticsFloatingInformation
  hi! link DiagnosticSignInfo LspDiagnosticsSignInformation
  hi! link DiagnosticVirtualTextHint LspDiagnosticsVirtualTextHint
  hi! link DiagnosticUnderlineHint LspDiagnosticsUnderlineHint
  hi! link DiagnosticFloatingHint LspDiagnosticsFloatingHint
  hi! link DiagnosticSignHint LspDiagnosticsSignHint

  " gray
  highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080
  " blue
  highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6
  highlight! link CmpItemAbbrMatchFuzzy CmpItemAbbrMatch
  " light blue
  highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE
  highlight! link CmpItemKindInterface CmpItemKindVariable
  highlight! link CmpItemKindText CmpItemKindVariable
  " pink
  highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0
  highlight! link CmpItemKindMethod CmpItemKindFunction
  " front
  highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4
  highlight! link CmpItemKindProperty CmpItemKindKeyword
  highlight! link CmpItemKindUnit CmpItemKindKeyword

  hi! PmenuSel guibg=#282C34
  hi! Pmenu guifg=#C5CDD9 guibg=#22252A

  highlight! CmpItemAbbrDeprecated guifg=#7E8294 guibg=NONE term=strikethrough
  highlight! CmpItemAbbrMatch guifg=#82AAFF guibg=NONE term=bold
  highlight! CmpItemAbbrMatchFuzzy guifg=#82AAFF guibg=NONE term=bold
  highlight! CmpItemMenu guifg=#C792EA guibg=NONE term=italic

  highlight! CmpItemKindField guifg=#B5585F
  highlight! CmpItemKindProperty guifg=#B5585F
  highlight! CmpItemKindEvent guifg=#B5585F

  highlight! CmpItemKindText guifg=#9FBD73
  highlight! CmpItemKindEnum guifg=#9FBD73
  highlight! CmpItemKindKeyword guifg=#9FBD73

  highlight! CmpItemKindConstant guifg=#D4BB6C
  highlight! CmpItemKindConstructor guifg=#D4BB6C
  highlight! CmpItemKindReference guifg=#D4BB6C

  highlight! CmpItemKindFunction guifg=#A377BF
  highlight! CmpItemKindStruct guifg=#A377BF
  highlight! CmpItemKindClass guifg=#A377BF
  highlight! CmpItemKindModule guifg=#A377BF
  highlight! CmpItemKindOperator guifg=#A377BF

  highlight! CmpItemKindVariable guifg=#7E8294
  highlight! CmpItemKindFile guifg=#7E8294

  highlight! CmpItemKindUnit guifg=#D4A959
  highlight! CmpItemKindSnippet guifg=#D4A959
  highlight! CmpItemKindFolder guifg=#D4A959

  highlight! CmpItemKindMethod guifg=#6C8ED4
  highlight! CmpItemKindValue guifg=#6C8ED4
  highlight! CmpItemKindEnumMember guifg=#6C8ED4

  highlight! CmpItemKindInterface guifg=#58B5A8
  highlight! CmpItemKindColor guifg=#58B5A8
  highlight! CmpItemKindTypeParameter guifg=#58B5A8

  hi! CmpItemKindText guifg=#9FBD73

endif

" }}}

" Delete Helper Functions: {{{
delf s:Load_Settings_Override
delf s:HL
delf s:rgb
delf s:colour
delf s:rgb_colour
delf s:rgb_level
delf s:rgb_number
delf s:grey_colour
delf s:grey_level
delf s:grey_number
" }}}

" vim: fdm=marker
