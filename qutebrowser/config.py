import os

# Load settings done via the GUI to avoid conflicts
config.load_autoconfig()

# =======================
# 1. GENERAL & TABS
# =======================
# Prevent closing the window when closing the last tab
c.tabs.last_close = 'startpage'
c.auto_save.session = True
c.downloads.remove_finished = 2000

# Hide the statusbar unless you are typing a command (Cleaner look)
c.statusbar.show = 'in-mode' 

# =======================
# 2. SEARCH ENGINES & SHORTCUTS
# =======================
c.url.searchengines = {
    'DEFAULT': 'https://duckduckgo.com/?q={}',
    'aw': 'https://wiki.archlinux.org/?search={}',
    'yt': 'https://www.youtube.com/results?search_query={}'
}

# Shortcut: Press 'ym' to open YouTube Music instantly
config.bind('ym', 'open https://music.youtube.com')

# =======================
# 3. EDITOR & EXTERNAL TOOLS (New!)
# =======================
# Press 'Ctrl+e' in any text box to edit it in Neovim inside Kitty
# We add a class so you can float it in Hyprland if you like
c.editor.command = ['kitty', '--class', 'floating', '-e', 'nvim', '{file}']

# =======================
# 4. KEYBINDINGS (New!)
# =======================
# Pin/Unpin Tab: Press 'tp' (Toggle Pin)
config.bind('tp', 'tab-pin')

# Bookmarks: Press 'sb' (Show Bookmarks) to open the bookmark list
config.bind('sb', 'open qute://bookmarks')

# Stream to MPV: Press 'M', then tap the hint letter to watch in MPV
config.bind('M', 'hint links spawn mpv {hint-url}')

config.bind('wd', 'tab-give')
config.bind('wt', 'set-cmd-text -s :tab-take')

config.bind('<Ctrl-Shift-J>', 'tab-move -')
config.bind('<Ctrl-Shift-K>', 'tab-move +')

# =======================
# 5. JAVASCRIPT & PER-DOMAIN SETTINGS
# =======================
# Note: Your previous config had this set to True (Enabled) globally.
# If you want it disabled by default, change True to False below.
c.content.javascript.enabled = True

# --- GitHub ---
with config.pattern('*://github.com/*') as p:
    p.content.javascript.enabled = True
    p.content.javascript.clipboard = 'access'

# --- YouTube & YouTube Music ---
with config.pattern('*://*.youtube.com/*') as p:
    p.content.javascript.enabled = True
    p.content.autoplay = True

# =======================
# 6. DARK MODE & ADBLOCKING
# =======================
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.policy.images = 'smart'
c.content.blocking.method = 'both'

# =======================
# 7. YAZI FILE PICKER INTEGRATION
# =======================
c.fileselect.handler = 'external'
c.fileselect.single_file.command = ['kitty', '--class', 'yazi-float', '-e', 'yazi', '--chooser-file', '{}']
c.fileselect.multiple_files.command = ['kitty', '--class', 'yazi-float', '-e', 'yazi', '--chooser-file', '{}']
c.fileselect.folder.command = ['kitty', '--class', 'yazi-float', '-e', 'yazi', '--chooser-file', '{}']
