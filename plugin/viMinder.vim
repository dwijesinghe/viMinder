function! SetupViminder()
                :cd ~
                :call mkdir('ViMinders')
endfunction
 
function! NewViminder()
                :set splitbelow
                :4new
                map <buffer> <cr> :call SaveViminder()<cr>
endfunction
 
function! SaveViminder()
                :let l:vimPath = $VIMRUNTIME
                :let l:vimPath = l:vimPath . '\gvim.exe'
                :let l:tildaPath = expand("~")
                :0
                :normal ggVG
                let l:viMindStr = getline('.')
                let l:viMindDateStr = substitute(l:viMindStr,"^.*\t.*\t","","g")
                let l:viMindTimeStr = substitute(l:viMindStr,"\t".l:viMindDateStr,"","g")
                let l:viMindTimeStr = substitute(l:viMindTimeStr,"^.*\t","","g")
                let l:viMindFileStr = substitute(l:viMindStr,"[^a-zA-Z0-9]","_","g")
                let l:viMindTaskName = l:viMindFileStr
                let l:viMindFileStr = l:tildaPath .'\ViMinders\' . l:viMindFileStr
               
                "Save the reminder text
                :sil execute ':w ' . l:viMindFileStr
               
                "Add text for  with vim (we are now generating the batch file)
                :put = 'echo ' . l:viMindStr
								:put = 'pause' 
               
                "Get rid of original reminder text as we are now generating the batch file
                :0
                :normal dd
               
                "Save the batch file
                :sil execute ':w ' . l:viMindFileStr . '.bat'
               
                "Clear batch file text
                :normal dd
 
                "Generate the schtasks batch file
                :let l:viMindCmd = 'schtasks /create /tn "' . l:viMindTaskName
                :let l:viMindTask = '" /tr ' . l:viMindFileStr .'.bat /sc once /st '
                :let l:viMindCmd = l:viMindCmd . l:viMindTask . l:viMindDateStr . ' /sd ' . l:viMindTimeStr
                :put =l:viMindCmd
                :0
                :normal dd
                :execute ':w ' . l:viMindFileStr . 'schtasks.bat'
                :execute ':!' . l:viMindFileStr . 'schtasks.bat'
                "Close the New Viminder window
                :bd!
endfunction
 
"Setup keyboard shortcut \r for making new Viminders
map <leader>r :call NewViminder()<cr>
