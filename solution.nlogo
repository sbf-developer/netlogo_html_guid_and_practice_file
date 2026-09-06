globals [
  total-trades
  mean-market-price
  system-cash
  system-goods
  last-trade-log
  rng-seed
]

breed [ households household ]
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

  initialize-patches
  seed-firms
  seed-households
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
  create-households num-households [
    set color green
    set size 1
    set cash 20 + random 30
    set goods random 5
    set reservation-price 4 + random-float 6
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
    set pcolor scale-color red activity -4 8
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

to households-seek-markets
  ask households [
    let target max-one-of patches with [ activity > 0 ] [ activity ]
    ifelse target != nobody
      [
        face target
        if can-move? 1 [ fd 1 ]
      ]
      [ rt random 40 - random 20 ]
    set reservation-price 3 + (goods * 0.2) + random-float 2
    set color scale-color green cash 0 80
    set label word "$" precision cash 1
  ]
end

to attempt-exchanges
  ask households [
    let seller one-of firms-here with [ stock > 0 ]
    let market-price [ local-price ] of patch-here
    if seller != nobody and trade-is-viable self seller market-price [
      execute-trade self seller market-price
    ]
  ]
end

to-report trade-is-viable [buyer seller price]
  report [ cash ] of buyer >= price
         and [ reservation-price ] of buyer >= price - trade-margin
         and [ stock ] of seller > 0
end

to execute-trade [buyer seller price]
  let qty 1
  ask buyer [
    set cash cash - price
    set goods goods + qty
    set trades trades + 1
  ]
  ask seller [
    set stock stock - qty
    set revenue revenue + price
    set sales sales + 1
  ]
  set total-trades total-trades + 1
  set last-trade-log trade-message price buyer seller
  register-trade-network buyer seller price
end

to-report trade-message [price buyer seller]
  report word "t=" total-trades " p=" precision price 2
              " h=" [who] of buyer " f=" [who] of seller
end

to register-trade-network [buyer seller price]
  ask buyer [
    ifelse partnership-with seller != nobody
      [
        ask partnership-with seller [
          set deal-count deal-count + 1
          set volume volume + price
        ]
      ]
      [
        create-partnership-with seller [
          set deal-count 1
          set volume price
        ]
      ]
    create-payment-to seller [
      set amount price
      set color yellow
    ]
  ]
end

to fade-payment-links
  ask payments [
    set color scale-color gray color 0 140
    if color < 10 [ die ]
  ]
end

to record-system-stats
  let cash-list sentence [cash] of households [revenue] of firms
  set system-cash reduce + cash-list
  set system-goods (sum [goods] of households) + (sum [stock] of firms)
  set mean-market-price mean [local-price] of patches
end


to-report household-utility [agent]
  report sqrt ([cash] of agent * ([goods] of agent + 1))
end

to-report firm-markup [agent]
  report [ revenue ] of agent / (1 + [ sales ] of agent)
end

to-report richest-household
  if not any? households [ report nobody ]
  report max-one-of households [ cash ]
end

to swap-reservation-prices [agent-a agent-b]
  let temp [reservation-price] of agent-a
  ask agent-a [ set reservation-price [reservation-price] of agent-b ]
  ask agent-b [ set reservation-price temp ]
end

to print-market-audit
  print "=== exchange economy audit ==="
  show count households
  show count firms
  show count partnerships
  show mean-market-price
  show system-cash
  show system-goods
  show map household-utility households
  show sort-by [ [a b] -> [cash] of a > [cash] of b ] households
  if any? households [
    show household-utility richest-household
    ask richest-household [ show patch-here ]
  ]
  print last-trade-log
end
