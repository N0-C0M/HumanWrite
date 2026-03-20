#Requires AutoHotkey v2.0
#SingleInstance Force

global MinDelay := 25
global MaxDelay := 80
global IsTyping := false

F5:: {
    global IsTyping
    
    clipText := A_Clipboard
    
    if (clipText = "") {
        MsgBox("Буфер обмена пуст!")
        return
    }
    
    clipText := StrReplace(clipText, "`r`n", "`n")
    clipText := StrReplace(clipText, "`r", "`n")
    
    IsTyping := true
    Sleep(300)
    
    lines := StrSplit(clipText, "`n")
    
    for index, line in lines {
        if (!IsTyping)
            return
        
        spaceCount := 0
        i := 1
        while (i <= StrLen(line)) {
            c := SubStr(line, i, 1)
            if (c = " ")
                spaceCount++
            else if (c = "`t")
                spaceCount += 4
            else
                break
            i++
        }
        
        content := SubStr(line, i)
        
        
        Send("{End}")      
        Sleep(10)
        Send("{Home}")     
        Sleep(10)
        Send("+{End}")     
        Sleep(10)
        Send("{Delete}")   
        Sleep(20)
        
        
        Loop spaceCount {
            Send("{Space}")
            Sleep(3)
        }
        
        
        Loop Parse, content {
            if (!IsTyping)
                return
            
            ch := A_LoopField
            
            if (ch = "{")
                Send("{{}")
            else if (ch = "}")
                Send("{}}")
            else if (ch = "^")
                Send("{^}")
            else if (ch = "!")
                Send("{!}")
            else if (ch = "+")
                Send("{+}")
            else if (ch = "#")
                Send("{#}")
            else
                SendText(ch)
            
            Sleep(Random(MinDelay, MaxDelay))
        }
        
        if (index < lines.Length) {
            Send("{Enter}")
            Sleep(60)
        }
    }
    
    IsTyping := false
}

Esc:: {
    global IsTyping := false
}

^Esc:: ExitApp()
