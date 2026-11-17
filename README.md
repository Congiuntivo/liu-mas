# Efficient Coalition Structure Generation via Branch-and-Bound Pruning

Course report for **TDDE13 Multi-Agent Systems** at Linköping
University, Erasmus+ semester (September 2025 - January 2026).

Coalition Structure Generation (CSG) is a fundamental problem in
cooperative multi-agent systems: given a set of agents and a value
function over subsets, partition them into coalitions that maximise
total value. The search space grows super-exponentially (Bell
numbers), so exact algorithms rely on principled pruning.

This report reviews branch-and-bound pruning for CSG, builds on the
frameworks of Sandholm et al. and Rahwan et al., and analyses when
admissible upper bounds yield substantial pruning and when
adversarial valuation functions preserve worst-case complexity.

Written in LaTeX (IJCAI template). Slides in Typst.

- [Report (PDF)](TDDE13-simde798-report.pdf)
- [Slides (PDF)](slides.pdf)
