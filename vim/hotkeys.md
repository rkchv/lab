# Neovim Hotkeys Table

## Normal Mode Hotkeys

| **Hotkey**      | **Description**                                                        |
|-----------------|------------------------------------------------------------------------|
| `e`             | Move to the end of the next word (stops at symbols)                    |
| `b`             | Move to the beginning of the previous word (stops at symbols)          |
| `''`            | Jump back to the cursor position before the last jump                  |
| `.`             | Repeat the last command and remain in command mode                     |
| `x`             | Cut text and copy it to the clipboard                                  |
| `yw`            | Yank the word                                                          |
| `dw`            | Delete word from cursor position (stops at symbols)                    |
| `db`            | Delete to the beginning of the previous word (stops at symbols)        |
| `D`             | Delete until the end of the line, starting at the cursor               |
| `P`             | Paste before the cursor (or above if pasting a line)                   |
| `p`             | Paste after the cursor (or below if pasting a line)                    |

## Paragraph and Text Manipulation

| **Hotkey**      | **Description**                                                        |
|-----------------|------------------------------------------------------------------------|
| `dip`           | Delete inside paragraph                                                |
| `yip`           | Yank inside paragraph                                                  |
| `cip`           | Change inside paragraph                                                |
| `vip`           | Select inside paragraph                                                |
| `caw` / `ciw`   | Change a word (even if cursor is in the middle)                        |
| `ca"` / `ci"`   | Change “text in double quotes”                                         |
| `ca'` / `ci'`   | Change ‘text in single quotes’                                         |
| `ca\`` / `ci\`` | Change text in backticks                                               |
| `ca(` / `ci(`   | Change text in parentheses                                             |
| `ca{` / `ci{`   | Change text in curly braces                                            |
| `ca[` / `ci[`   | Change text in square brackets                                         |
| `cap` / `cip`   | Change paragraph                                                       |
| `cat` / `cit`   | Change tags (e.g., `<div>text</div>`)                                  |
| `cao` / `cio`   | Change text inside a code block                                        |
| `cf[`           | Change find `[beginning of square bracket]`                            |
| `ct[`           | Change until the next `[beginning of square bracket]`                  |

## Find / Replace

| **Hotkey**      | **Description**                                                        |
|-----------------|------------------------------------------------------------------------|
| `/[pattern]`    | search forward                                                         |
| `?[pattern]`    | search backward                                                        |

## Insert Mode

| **Hotkey**      | **Description**                                                        |
|-----------------|------------------------------------------------------------------------|
| `I`             | Insert text at the beginning of the line                               |
| `A`             | Append text at the end of the line                                     |
| `gi`            | Return to the last position in insert mode                             |
| `<C-T>`         | Increase the indent while in insert mode                               |
| `<C-D>`         | Decrease the indent while in insert mode                               |

## Visual Mode

| **Hotkey**      | **Description**                                                        |
|-----------------|------------------------------------------------------------------------|
| `gv`            | Return to the last visual selection                                    |
| `vig`           | Select inside a paragraph                                              |
| `P`             | Paste without replacing the selected text                              |
| `p`             | Paste, replacing the selected text                                     |

## Vertical Visual Mode

| **Hotkey**      | **Description**                                                        |
|-----------------|------------------------------------------------------------------------|
| `Ctrl + v`      | Enter vertical visual mode                                             |
| `$`             | Move to the end of every selected line                                 |
| `A`             | Append text at the end of every selected line                          |
| `I`             | Insert text at the beginning of every selected line                    |
| `l` / `e`       | Select the rest of the word/line                                       |
| `c`             | Change the selected text in vertical mode                              |


