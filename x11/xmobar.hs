Config { font = "xft:ChicagoFLF:size=9"
       , borderColor = "#464b50"
       , border = TopB
       , bgColor = "#1e1e1e"
       , fgColor = "#e8e8e8"
       , position = Top
       , lowerOnStart = True
       , pickBroadest = False
       , persistent = False
       , hideOnStart = False
       , allDesktops = True
       , overrideRedirect = True
       , commands = [ Run StdinReader
                    , Run Com "uname" ["-s","-r"] "" 36000
                    , Run Com "mpc" ["current", "-h", "greg-imac.local"] "" 20
                    , Run Kbd [("us(colemak)", "EN"), ("ru", "RU")]
                    , Run Date "%a %b %_d %Y %H:%M:%S" "date" 10
                    ]
       , sepChar = "%"
       , alignSep = "}{"
       , template = " %StdinReader% }{ <fc=#8f9d6a>%mpc%</fc> <fc=#f9ee98>%kbd%</fc> <fc=#afc4db>%date%</fc> <fc=#cf6a4c>%uname%</fc>"
       }
