# Makefile for Installation Guide

.PHONY: all clean install

# Default target
all: installation_guide.pdf

# Compile the PDF
installation_guide.pdf: main.tex
	pdflatex main.tex
	pdflatex main.tex  # Run twice for proper cross-references

# Clean auxiliary files
clean:
	rm -f *.aux *.log *.out *.toc *.lof *.lot *.nav *.snm *.vrb

# Install dependencies (for systems with tlmgr)
install:
	tlmgr install geometry hyperref listings xcolor titling enumitem

# Clean and compile fresh
fresh: clean all

# View the PDF (macOS)
view: installation_guide.pdf
	open installation_guide.pdf

# View the PDF (Linux)
view-linux: installation_guide.pdf
	xdg-open installation_guide.pdf

# View the PDF (Windows)
view-windows: installation_guide.pdf
	start installation_guide.pdf



