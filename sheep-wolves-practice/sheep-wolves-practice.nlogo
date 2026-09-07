breed [ sheep a-sheep ]
breed [ wolves wolf ]
sheep-own [ grass-eaten ]
wolves-own [ hunger ]

to setup
    clear-all
    create-sheep 30 [ set color white set grass-eaten 0 ]
    create-wolves 5 [ set color black set hunger 0 ]
    
