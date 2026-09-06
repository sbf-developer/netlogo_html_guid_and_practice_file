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
  [CONTINUE FROM HERE]