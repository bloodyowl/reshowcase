(lang dune 3.8)

(using melange 0.1)

(generate_opam_files true)

(name ahrefs-reshowcase)

(source
 (github ahrefs/reshowcase))

(documentation "https://github.com/ahrefs/reshowcase")

(bug_reports "https://github.com/ahrefs/reshowcase/issues")

(license "MIT")

(package
 (name ahrefs-reshowcase)
 (synopsis "")
 (description "")
 (depends
  (ocaml
   (>= 4.13.0))
  (melange
   (>= 1.0.0))
  (reason
   (>= 3.6.0))
  reason-react
  rescript-syntax
  reactjs-jsx-ppx
  (ocaml-lsp-server :with-test)))
