(TeX-add-style-hook
 "FinalExam"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("article" "12pt")))
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("geometry" "margin=1in")))
   (TeX-run-style-hooks
    "latex2e"
    "article"
    "art12"
    "geometry"
    "amsmath"
    "amsthm"
    "amssymb"
    "amsfonts")
   (TeX-add-symbols
    "N"
    "Z"
    "R"
    "lra")
   (LaTeX-add-environments
    '("solution" LaTeX-env-args ["argument"] 0)
    '("subproblem" LaTeX-env-args ["argument"] 1)
    '("problem" LaTeX-env-args ["argument"] 1)))
 :latex)

