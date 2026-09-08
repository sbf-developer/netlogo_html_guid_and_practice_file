globals [
    total-harvested
    mean-resource
]

patches-own [ resource ]

turtles-own [
    wealth
    harvest-amount
]

to setup
    clear-all
    set total-harvested 0
    ask patches [ 
        set resource 100
        set pcolor scale-color green resource 0 100
    ]
    create-turtles num-agent [
        set wealth 0
        set harvest-amount harvest-rate
        set color blue
        set size 1
        setxy random-xcor random-ycor
    ]
    reset-ticks
end

to go 
    ask turtles [ harvest-and-move ]
    ask patches [ regrow ]
    ask patches [ update-color ]
    record-stats
    tick
end

to harvest-and-move
    let take min harvest-amount resource
    set resource resource - take
    set wealth wealth + take
    set total-harvested total-harvested + take
    move-to one-of neighbors
end

to regrow
    set resource min (resource + regrowth-rate) 100
end

to update-color
    set pcolor scale-color green resource 0 100
end

to record-stats
    set mean-resource mean [ resource ] of patches
end 

to print-commons-audit
    print "=== tragedy of thhe commons audit ==="
    show count turtles 
    show mean-resource
    show total-harvested
    show mean [ wealth ] of turtles
    show max [ wealth ] of turtles
end