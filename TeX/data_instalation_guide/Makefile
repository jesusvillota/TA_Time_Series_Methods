# Makefile for Data Installation Guide

.PHONY: all clean install

# Default target
all: data_instalation_guide.pdf

# Compile the PDF
data_instalation_guide.pdf: main.tex
	pdflatex main.tex
	pdflatex main.tex  # Run twice for proper cross-references

# Clean auxiliary files
clean:
	rm -f *.aux *.log *.out *.toc *.lof *.lot *.nav *.snm *.vrb

# Install dependencies (for systems with tlmgr)
install:
	tlmgr install geometry hyperref listings xcolor titling enumitem booktabs array float

# Clean and compile fresh
fresh: clean all

# View the PDF (macOS)
view: data_instalation_guide.pdf
	open data_instalation_guide.pdf

# View the PDF (Linux)
view-linux: data_instalation_guide.pdf
	xdg-open data_instalation_guide.pdf

# View the PDF (Windows)
view-windows: data_instalation_guide.pdf
	start data_instalation_guide.pdf

