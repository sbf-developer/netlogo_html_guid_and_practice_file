globals [
  total-trades
  mean-markets-price
  system-cash
  system-goods
  last-trade-log
  rng-seed
]

breed [ households households ]
breed [ firms firm ]

directed-link-breed [ payments payment ]
undirected-link-breed [ partnerships partnership ]

households-own [
  cash 
  goods
  reservation-price
  trades
]

firms-own [
  revenue
  stock
  unit-cost
  sales
]

patches-own [
  local-price
  supply
  demand
  activity
]

partnerships-own [
  deal-count
  volume
]

payments-own [
  amount
]


to setup
  clear-all
  set rng-seed 42
  random-seed rng-seed
  set total-trades 0
  set last-trade-log "none"

  intialize-patches
  seed-firms
  seed-househoulds
  reset-ticks
end

to go 
  firms-produce
  update-patch-markets
  households-seek-markets
  attempt-exchanges
  fade-payment-links
  record-system-stats
  tick
end


to initialize-patches
  ask patches [
    set local-price 5 + abs pxcor mod 4
    set supply 0
    set demand 0
    set activity 0
    set pcolor scale-color blue pxcor min-pxcor max-pxcor
  ]
end

to seed-firms
  ask n-of num-firms patches [
    sprout-firms 1 [
      set color blue
      set size 1.3
      set stock 8 + random 8
      set revenue 0
      set sales 0
      set unit-cost 2 + random-float 3
      set label "F"
    ]
  ]
end

to seed-households
  create-households  num-households [
    set color green
    set size 1
    set cash 20 + random 30
    set goods random 5
    set researvation-price 4 + random-float 6
    set trades 0
    set heading random-float 360
    setxy random-xcor random-ycor
    set label word "$" cash
  ]
end


to firms-produce 
  ask firms [
    set stock stock + production-rate
    if stock > 40 [ set stock 40 ]
    set label word "S:" stock
  ]
end

to update-patch-markets
  ask patches [
    set supply sum [ stock ] of firms-here
    set demand count households-here + count households in-radius 2
    set local-price unit-cost-if-any
    set local-price local-price + (demand / (supply + 1))
    set activity demand - supply
    set pcolor scale-color red activity activity -4 8
    set plabel word "P" precision local-price 1
  ]
  diffuse activity 0.15
end

to-report unit-cost-if-any
  if any? firms-here [
    report mean [ unit-cost ] of firms-here
  ]
  report 5
end

to households-seel-markets
  ask households [
    let target max-one-of patches with [ activity > 0 ] [ activity ]
    ifelse target != nobody
      [CONTINUE FROM HERE]





  ]