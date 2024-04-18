F1:: 

  StopLoop := False 

  Loop, 

    { 

       ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 download.png
       MouseClick, left, %foundx%, %foundy%
       Sleep, 8000
       if StopLoop 

           break 

     } 

return 



Esc:: 

  StopLoop := True 

return