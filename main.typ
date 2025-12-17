#import "@preview/typslides:1.3.0": *

// Project configuration
#show: typslides.with(
  ratio: "16-9",
  theme: "bluey",
  font: "Fira Sans",
  font-size: 20pt,
  link-style: "color",
  show-progress: true,
)

// Front slide
#front-slide(
  title: "Efficient Coalition Structure Generation",
  subtitle: [via _Branch-and-Bound Pruning_],
  authors: "Simone De Carli",
  info: [TDDE13 - Linköping University],
)

// Table of contents
#table-of-contents()

// Introduction
#title-slide[
  The Problem
]

#slide(title: "What is Coalition Structure Generation?")[

  // A CS is a partition of agents into disjoint coalitions
  *Definition:* A CS is a partition of agents into disjoint coalitions

  *Scenario:* You have $n$ agents that need to form teams (coalitions)

  #v(0.5cm)

  #cols(columns: (1fr, 1fr), gutter: 2em)[
    *Example:* 4 agents {A, B, C, D}

    Possible structures:
    - {A, B, C, D} — one big team
    - {A, B}, {C, D} — two pairs
    - {A}, {B, C, D} — one alone, three together
    - {A}, {B}, {C}, {D} — all separate
    - ... and many more!
  ][
    *Goal:* Find the partition that #stress[maximizes total value]

    #v(0.5cm)

    Each coalition has a value $v(C)$

    Total value: $V("CS") = sum_(C in "CS") v(C)$
  ]
]

#slide(title: "The Challenge: Exponential Growth")[

  *How many possible coalition structures exist?*

  #v(0.5cm)

  Answer: #stress[Bell numbers] $B_n$ @rahwan2007anytime #h(1cm) (the number of ways to partition n agents)

  #v(0.3cm)

  #table(
    columns: (auto, auto, auto),
    align: center,
    [*Agents*], [*Structures*], [*Growth*],
    [3], [5], [-],
    [4], [15], [3×],
    [5], [52], [3.5×],
    [10], [115,975], [super-exponential],
    [15], [1,382,958,545], [#stress[infeasible!]],
  )

  #v(0.5cm)

  #framed[*Problem:* Exhaustive search becomes impossible even for small $n$]
]

// Branch-and-Bound Solution
#title-slide[
  The Solution Approach
]

#slide(title: "Branch-and-Bound: Core Idea")[

  *Idea:* Don't explore regions that #stress[cannot] contain optimal solution

  #v(0.5cm)

  #cols(columns: (1.2fr, 1fr), gutter: 2em)[
    // *Three components:*

    1. *Search tree structure*
      - Nodes = partial solutions
      - Branches = adding coalitions

    2. *Upper bound* for each node
      - Optimistic estimate of best achievable value

    3. *Pruning rule*
      - If upper bound $<=$ best solution found
      - #sym.arrow Skip entire subtree!
  ][
    #framed(title: "Example")[
      Best so far: $100$

      Node $X$ upper bound: $95$

      #v(0.3cm)

      #sym.arrow #stress[Prune!] Node $X$ and all descendants cannot beat $100$
    ]
  ]
]

#slide(title: "How Upper Bounds Work")[

  #align(center)[
  *Admissible bounds* #sym.arrow Never underestimate the true optimal value]

  #v(0.5cm)

  #cols(columns: (1fr, 1fr), gutter: 2em)[
    *Common approach:*

    For remaining agents, assume they can form coalitions with the maximum value achievable for each coalition size

    #v(0.3cm)

    // Upper bound =
    - Value of current partial structure \+
    - Best packing of remaining agents using per-size maximum coalition values
  ][
    *Why admissibility matters:*

    ✓ Too high #sym.arrow safe but less pruning

    ✗ Too low #sym.arrow might prune optimal solution!

    // #v(0.3cm)

    // #framed[With admissibility guarantees we find the #stress[optimal] solution]
  ]
]

#slide(title: "Branch-and-Bound in Action")[

  #align(center)[
    *Small Example: 3 agents*
  ]

  #v(0.5cm)

  #cols(columns: (1fr, 1fr), gutter: 2em)[
    *Search tree:*

    ```
    Root
    ├─ {ABC}        UB=100
    ├─ {AB},{C}     UB=90  ← Best = 85
    │  └─ ...
    ├─ {AC},{B}     UB=75
    │  └─ PRUNED! (75 < 85)
    └─ ...
    ```

  ][
    Once we find solution worth $85$, any branch with $"UB" <= 85$ can be skipped

  ]

  #v(0.5cm)
  
  #stress[Result:] Exponential reduction in practice (when bounds are tight)

  #stress[Note:] With larger problems (e.g., 10+ agents), pruning eliminates millions of CS
]

// Guarantees and Limitations
#title-slide[
  What Can We Guarantee?
]

#slide(title: "Theoretical Guarantees")[

  #v(5cm)

  *Correctness:* Branch-and-bound #stress[always] finds the optimal solution with admissible bounds.

  #v(2.5cm)

  #framed[
  *Note:* Branch-and-bound is an exact algorithm, but it can be interrupted early, yielding intermediate (suboptimal) solutions.]

  #v(6cm)

  If interrupted early, solution quality may be poor in the worst case @sandholm1999coalition @rahwan2011minimum.
  #framed(title: "Worst-case anytime guarantees")[

    After searching $2^(n-1)$ coalition structures (the two lowest levels):
    - Worst-case bound: $beta = n$ 
      - meaning the optimal solution is at most $n$ times better than what we found
    - With just #stress[one more evaluation] (grand coalition): $beta approx n/2$
  ]

]

#slide(title: "Limitations: When Does It Fail?")[

  *Problem:* Effectiveness depends on #stress[problem structure] @prantare2017algorithm

  #v(0.5cm)

  #cols(columns: (1fr, 1fr), gutter: 2em)[
    *Good cases* (much pruning):

    - Diminishing returns
    - Bounded complementarity
    - Regular value patterns

    #sym.arrow Tight upper bounds

    #sym.arrow Substantial pruning
  ][
    *Bad cases* (little pruning):

    - Irregular valuations
    - Near-additive functions
    - Adversarial instances

    #sym.arrow Loose upper bounds

    #sym.arrow Near-exhaustive search
  ]

  #v(0.5cm)

  #framed[#stress[Key point:] Branch-and-bound cannot overcome fundamental combinatorial hardness in worst case]
]

// Practical Considerations
#title-slide[
  Practical Impact
]

#slide(title: "Anytime Behavior")[

  *Diminishing returns of computation*

  #v(0.5cm)

  #align(center)[
    Quality vs. Time trade-off:
  
  #table(
    columns: (auto, auto, auto),
    align: center,
    [*Stage*], [*Effort*], [*Bound*],
    [Initial], [Minimal search], [$beta = n$],
    [+1 evaluation], [Grand coalition], [$beta approx n/2$],
    [Continue...], [More nodes], [Better bounds],
    [Complete], [Full search], [Optimal],
  )
  ]
  #v(0.5cm)

  #framed[*Anytime property:* Can stop early with quality guarantees]
]

#slide(title: "Where Branch-and-Bound Fits")[

  // *Role in CSG research:*

  // #v(1cm)

  #cols(columns: (1fr, 1fr), gutter: 2em)[
    *Strengths:*

    ✓ Optimal solutions

    ✓ Worst-case anytime guarantees

    ✓ Sound theoretical foundation

    ✓ Reference baseline for evaluation

    #sym.arrow Used to evaluate approximate methods
  ][
    *Motivated alternatives:*

    - Anytime algorithms
    - Approximation methods
    - Heuristic approaches

    #v(0.3cm)

    #sym.arrow Trade optimality for scalability
  ]


  // #framed[Not a universal solution, but a principled framework that exploits structure when present]
]

#slide(title: "Summary")[

  *Coalition Structure Generation:*
  - Super-exponential search space (Bell numbers)
  - Need to partition agents into optimal coalitions

  #v(0.3cm)

  *Branch-and-Bound Pruning:*
  - Uses admissible upper bounds to eliminate subtrees
  - Guarantees optimality while reducing search
  - Effectiveness varies with valuation structure

  #v(0.3cm)

  *Anytime Behavior:*
  - Can provide quality guarantees at any time
  - Useful as a benchmark for approximate methods
]

// Bibliography
#let bib = bibliography("Report.bib")
#bibliography-slide(bib)
