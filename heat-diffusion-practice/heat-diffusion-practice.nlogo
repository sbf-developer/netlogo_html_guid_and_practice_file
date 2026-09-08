patches-own [ heat ]

to setup
    clear-all
    ask patches [ set heat 0 set pcolor black ]
    ask patch 0 0 [ set heat 100 set pcolor red ]
    reset-ticks
end

to go 
    diffuse heat 0.2
    ask patches [
        set pcolor scale-color red heat 0 50
        set plabel precision heat 1
    ]
    tick
end
