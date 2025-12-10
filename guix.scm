;; asdf-acceleration-middleware - Guix Package Definition
;; Run: guix shell -D -f guix.scm

(use-modules (guix packages)
             (guix gexp)
             (guix git-download)
             (guix build-system cargo)
             ((guix licenses) #:prefix license:)
             (gnu packages base))

(define-public asdf_acceleration_middleware
  (package
    (name "asdf-acceleration-middleware")
    (version "0.1.0")
    (source (local-file "." "asdf-acceleration-middleware-checkout"
                        #:recursive? #t
                        #:select? (git-predicate ".")))
    (build-system cargo-build-system)
    (synopsis "Rust application")
    (description "Rust application - part of the RSR ecosystem.")
    (home-page "https://github.com/hyperpolymath/asdf-acceleration-middleware")
    (license license:agpl3+)))

;; Return package for guix shell
asdf_acceleration_middleware
