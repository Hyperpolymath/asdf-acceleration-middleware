;; SPDX-License-Identifier: PMPL-1.0-or-later
;; STATE.scm - Current project state

(state
  (metadata
    (version "1.0.0")
    (schema-version "1.0")
    (created "2026-01-08")
    (updated "2026-01-08")
    (project "asdf-acceleration-middleware")
    (repo "https://github.com/hyperpolymath/asdf-acceleration-middleware"))

  (project-context
    (name "asdf-acceleration-middleware")
    (tagline "asdf plugin for Performance middleware toolkit")
    (tech-stack "bash" "shellcheck"))

  (current-position
    (phase "active")
    (overall-completion 80)
    (components
      (list-all "complete")
      (download "complete")
      (install "complete")
      (help "complete"))
    (working-features
      "version listing"
      "binary download"
      "installation"
      "version switching"))

  (route-to-mvp
    (milestone "1.0"
      (items
        "Core plugin functionality"
        "CI/CD pipeline"
        "Documentation")))

  (blockers-and-issues
    (critical)
    (high)
    (medium)
    (low))

  (critical-next-actions
    (immediate)
    (this-week)
    (this-month)))
