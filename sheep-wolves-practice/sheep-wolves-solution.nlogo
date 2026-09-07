breed [ sheep a-sheep ]
breed [ wolves wolf ]
sheep-own [ grass-eaten ]
wolves-own [ hunger ]

to setup
  clear-all
  create-sheep 30 [ set color white set grass-eaten 0 ]
  create-wolves 5  [ set color black set hunger 0 ]
  reset-ticks
end

to go
  ask sheep [ eat-grass move-random ]
  ask wolves [ hunt ]
  tick
end

to eat-grass
  set grass-eaten grass-eaten + 1
  set color scale-color green grass-eaten 0 20
end

to move-random
  rt random 40 - random 40
  fd 1
end

to hunt
  let prey one-of sheep-here
  if prey != nobody [ ask prey [ die ] set hunger hunger + 1 ]
  fd 1
end
