Linedit is a readline-style library written in Common Lisp that
provides customizable line-editing for Common Lisp programs.

Linedit is basically portable between implementations, but most
development and testing has so far been carried out on SBCL - but CCL at
least is expected to work as well.

The canonical place to get linedit is

    https://github.com/sharplispers/linedit

but unless you want to hack on linedit you should take the Quicklisp
version! To report a bug submit a GitHub issue at the above URL. For
patches please submit a pull request from a topic-branch.

Features
========

* single-line text reader
* multi-line form reader
* completions on packages and symbols in current image
* completions on directories and filenames
* apropos-word and describe-word
* unlimited undo
* unlimited kill-ring
* unlimited history
* paren matching (not across lines)
* multiple histories
* use in REPL on SBCL and Clozure CL
* paging
* fully customizable in CL
* works on Linux, FreeBSD, macOS

Usage
=====

    > (ql:quickload "linedit")

    > (linedit:linedit :prompt "-> ")

    > (linedit:formedit :prompt1 "=> " :prompt2 "|   ")

Meta-H in the prompt displays help.
(Try ESC-H if your terminal misbehaves with meta-proper.)

Linedit in the REPL
===================

SBCL and CCL only for now:

    (linedit:install-repl :wrap-current t :eof-quits t)

in e.g. your Lisp initialization file (~/.sbclrc for SBCL). If you
don't want to preserve your current input handler you can omit the
WRAP-CURRENT keyword.

Documentation
=============

*function* __INSTALL-REPL__ &key wrap-current eof-quits

Installs Linedit REPL input handler. (SBCL and CCL only.)

*function* __UNINSTALL-REPL__

Removes Linedit REPL input handler. (SBCL and CCL only.)

*function* __LINEDIT__ &rest keys &key prompt

Reads a single line of input with line-editing from standard input of
the process and returns it as a string.

Results are unspecified if \*STANDARD-INPUT* has been bound or altered.

:PROMPT specifies the string to print to \*STANDARD-OUTPUT* before
starting to accept input.

Further keyword arguments to LINEDIT are an advanced and undocumented
topic, but if you're willing to dive into sources you can e.g. use
multiple kill-rings not shared between different invocations of
LINEDIT, or change the function responsible for providing input
completion.

*function* __FORMEDIT__ &rest keys &key prompt1 prompt2

Reads a single form (s-expession) of input with line-editing from
standard input of the process and returns it as a string.

Results are unspecified if \*STANDARD-INPUT* has been bound or altered,
or if *READTABLE* is not the standard one.

:PROMPT1 specifies the string to print to \*STANDARD-OUTPUT* before
starting to accept input.

:PROMPT2 specified the string to print to \*STANDARD-OUTPUT* when input
spans multiple lines (prefixing every but first line of input from the
user perspective.)

Further keyword arguments to FORMEDIT are an advanced and undocumented
topic, but if you're willing to dive into sources you can e.g. use
multiple kill-rings not shared between different invocations of
FORMEDIT, or change the function responsible for providing input
completion.
