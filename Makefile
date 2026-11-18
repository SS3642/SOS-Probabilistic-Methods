# =====================================================================
#  Makefile for the "Probabilistic Methods" book
#  Layout:  main.tex  +  chapters/  appendix/  figures/
#
#  Quick start:
#     make            -> build main.pdf (incremental, recommended)
#     make watch      -> auto-rebuild on every save (live preview)
#     make quick      -> single fast pass (for checking errors)
#     make fast       -> TURBO build using a precompiled preamble
#     make clean      -> remove auxiliary files
#     make cleanall   -> remove everything generated (incl. PDF & format)
#
#  Requires a local TeX Live / MiKTeX with `latexmk` and `pdflatex`.
# =====================================================================

MAIN    := main
OUTDIR  := build
LATEXMK := latexmk

# Let pdflatex find a precompiled format (main.fmt) in this directory.
export TEXFORMATS := .:

# pdflatex options shared by every target.
TEXFLAGS := -interaction=nonstopmode -halt-on-error -file-line-error -synctex=1

# latexmk does the minimum number of passes and only when needed.
LMKFLAGS := -pdf $(TEXFLAGS) -outdir=$(OUTDIR)

# Any source folder that holds a .tex (chapters/, appendix/, ...) must be
# mirrored inside $(OUTDIR), because \include writes its .aux there and
# pdflatex will NOT create missing subdirectories on its own.
SRCSUBDIRS := $(shell find . -path './$(OUTDIR)' -prune -o -name '*.tex' -print 2>/dev/null \
                | sed 's|/[^/]*$$||;s|^\./||' | sort -u | grep -v -e '^\.$$' -e '^$$')

.PHONY: all pdf watch quick fmt fast prepdirs clean cleanall help

all: pdf

# Mirror source subfolders into the build directory (fixes the
# "I can't write on file chapters/xx.aux" error from \include).
prepdirs:
	@mkdir -p $(OUTDIR) $(addprefix $(OUTDIR)/,$(SRCSUBDIRS))

# --- Recommended build -------------------------------------------------
# Incremental: latexmk reruns only the passes that are actually required
# (resolving the table of contents and the cross-chapter \ref's), and does
# nothing at all if no source file changed.
pdf: prepdirs
	$(LATEXMK) $(LMKFLAGS) $(MAIN).tex
	@cp -f $(OUTDIR)/$(MAIN).pdf ./$(MAIN).pdf 2>/dev/null || true
	@echo ">> ./$(MAIN).pdf is up to date."

# --- Live preview ------------------------------------------------------
# Rebuilds automatically whenever you save; keeps a viewer open if set up.
watch: prepdirs
	$(LATEXMK) $(LMKFLAGS) -pvc $(MAIN).tex

# --- One quick pass ----------------------------------------------------
# Fastest way to surface a LaTeX error. Cross-references/ToC may show "??"
# until you run `make` again -- that is expected for a single pass.
quick: prepdirs
	pdflatex $(TEXFLAGS) -output-directory=$(OUTDIR) $(MAIN).tex
	@cp -f $(OUTDIR)/$(MAIN).pdf ./$(MAIN).pdf 2>/dev/null || true

# =====================================================================
#  TURBO MODE  (precompiled preamble via mylatexformat)
#  ---------------------------------------------------------------------
#  Your preamble loads the heavy trio tcolorbox + tikz + hyperref on every
#  run. Dumping it into a binary format file (main.fmt) once means each
#  later compile skips re-loading them.
#
#  ONE-TIME EDIT REQUIRED:
#     add a line   \endofdump   immediately BEFORE  \begin{document}
#     in main.tex. (Harmless to the normal `make` target.)
#
#  Then:  make fast      (auto-builds main.fmt the first time)
#  Rebuild the format only after changing the preamble:  make fmt
# =====================================================================
fmt:
	@echo ">> Dumping precompiled preamble -> $(MAIN).fmt"
	pdftex -ini -jobname=$(MAIN) "&pdflatex" mylatexformat.ltx $(MAIN).tex

fast:
	@mkdir -p $(OUTDIR)
	@$(MAKE) --no-print-directory prepdirs
	@test -f $(MAIN).fmt || $(MAKE) --no-print-directory fmt
	pdflatex -fmt=$(MAIN) $(TEXFLAGS) -output-directory=$(OUTDIR) $(MAIN).tex
	pdflatex -fmt=$(MAIN) $(TEXFLAGS) -output-directory=$(OUTDIR) $(MAIN).tex
	@cp -f $(OUTDIR)/$(MAIN).pdf ./$(MAIN).pdf 2>/dev/null || true
	@echo ">> ./$(MAIN).pdf built with precompiled preamble."

# --- Cleanup -----------------------------------------------------------
clean:
	$(LATEXMK) -outdir=$(OUTDIR) -c $(MAIN).tex 2>/dev/null || true
	@rm -f $(MAIN).fmt
	@echo ">> Auxiliary files removed (PDF kept)."

cleanall:
	$(LATEXMK) -outdir=$(OUTDIR) -C $(MAIN).tex 2>/dev/null || true
	@rm -rf $(OUTDIR) $(MAIN).pdf $(MAIN).fmt
	@echo ">> All generated files removed."

help:
	@echo "make        build main.pdf (incremental, recommended)"
	@echo "make watch  auto-rebuild on save"
	@echo "make quick  single fast pass (error checking)"
	@echo "make fast   turbo build via precompiled preamble (needs \\endofdump)"
	@echo "make fmt    (re)build the precompiled preamble main.fmt"
	@echo "make clean / make cleanall"
