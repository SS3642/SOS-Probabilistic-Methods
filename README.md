# Probabilistic Methods

My Summer of Science (SoS) project at IIT Bombay: a short book on the probabilistic method in combinatorics, written in LaTeX.

The idea behind the method is simple to state and strange the first time you see it. To prove that an object with some property exists, pick one at random and show that it has the property with positive probability. Questions with no randomness in them get answered by randomness that the answer then throws away. These notes follow that idea from the first moment through the Lovász Local Lemma, with full proofs and short "Insight" boxes on why each argument works.

**Read the book:** [main.pdf](main.pdf) (49 pages)

## Contents

| Chapter | What it covers |
|---|---|
| 1. The Probabilistic Method | Large bipartite subgraphs; from existence to algorithm (conditional expectations, MAX-SAT); Szele's theorem on Hamilton paths in tournaments; lower bounds for Ramsey numbers (Erdős 1947, alteration, Spencer's Local Lemma bound); extremal set systems (Sperner, LYM, Bollobás two families, Erdős-Ko-Rado); two-colourable hypergraphs; the list chromatic number of K<sub>n,n</sub> |
| 2. Linearity of Expectation | Fixed points of a random permutation; Hamilton paths in tournaments; large sum-free subsets (Erdős 1965); Caro-Wei and Turán's theorem; bounding by sampling (hypergraph Turán problem for tetrahedra); unbalancing lights; the crossing number inequality |
| 3. Alterations | Dominating sets; the Heilbronn triangle problem; graphs with high girth and high chromatic number (Erdős 1959); random greedy colouring (Radhakrishnan-Srinivasan) |
| 4. The Second Moment Method | The triangle threshold in G(n,p); thresholds for fixed subgraphs; existence of thresholds (Bollobás-Thomason); two-point concentration of the clique number of G(n,1/2); Hardy-Ramanujan; sets with distinct subset sums; the Weierstrass approximation theorem |
| 5. The Chernoff Bound | Discrepancy and Spencer's "six standard deviations suffice"; exponentially many nearly orthogonal vectors; the Erdős-Fajtlowicz counterexample to the Hajós conjecture |
| 6. The Lovász Local Lemma | Symmetric and general forms with proof; colouring hypergraphs; Latin transversals (Erdős-Spencer); the algorithmic Local Lemma (Moser-Tardos) |
| Appendix A. A Probability Toolkit | Union bound, expectation, variance, Markov, Chebyshev and Chernoff, Jensen, standard estimates, G(n,p), moment generating functions |

Each chapter ends with exercises.

## Building the PDF

You need a TeX distribution (TeX Live or MiKTeX) with `latexmk` and `pdflatex`.

```bash
make          # build main.pdf (incremental)
make watch    # rebuild automatically on every save
make quick    # one fast pass, useful for spotting errors
make clean    # remove auxiliary files, keep the PDF
```

Auxiliary files go into `build/`, and the finished PDF is copied to the top level as `main.pdf`.

## Layout

```
main.tex        preamble, styling, title page, chapter includes
chapters/       one .tex file per chapter
appendix/       probability toolkit
figures/        cover image
Makefile        build targets
```
