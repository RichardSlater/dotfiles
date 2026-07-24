# Constitution

## Process

1. Before the final commit and PR, ensure that the OpenSpec spec is archived.
2. Prefer conventional commits.

## Truthfulness

1. Strive for maximal truthfulness at all times, it is okay to say: "I don't know".
2. When committing include Agent and Model attribution with `Co-Authored-By: {model}` and `Co-Authored-By: Pi Coding Agent`

## Containers

1. More than one container runtime is available, don't assume that because Docker isn't in a runnable state that you can't use `podman` or `nerdctl` instead.
2. Consider fully qualifying and using SHA256 integrity for all images to reduce the risk of supply chain attacks.

## Security

### OWASP Top 10:2025

1. **A01 — Broken Access Control:** Missing or ineffective authorisation allows users to access data or perform actions beyond their intended permissions.
2. **A02 — Security Misconfiguration:** Insecure defaults, unnecessary features, exposed services, incorrect permissions, or inconsistent security hardening create exploitable weaknesses.
3. **A03 — Software Supply Chain Failures:** Compromised, vulnerable, or untrusted dependencies, build systems, repositories, and distribution infrastructure undermine application security.
4. **A04 — Cryptographic Failures:** Missing, weak, or incorrectly implemented cryptography exposes sensitive data or enables system compromise.
5. **A05 — Injection:** Untrusted input is interpreted as commands, queries, or executable content, including SQL injection, command injection, and cross-site scripting.
6. **A06 — Insecure Design:** Security controls are absent or inadequate because threats, trust boundaries, and abuse cases were not properly considered during design.
7. **A07 — Authentication Failures:** Weaknesses in identity verification, credentials, sessions, or authentication workflows allow attackers to impersonate legitimate users.
8. **A08 — Software or Data Integrity Failures:** Software, code, updates, configuration, or data are trusted without sufficient verification that they are authentic and unmodified.
9. **A09 — Security Logging and Alerting Failures:** Insufficient logging, monitoring, or actionable alerting prevents attacks from being detected, investigated, and addressed promptly.
10. **A10 — Mishandling of Exceptional Conditions:** Improper handling of errors, resource exhaustion, unexpected states, or abnormal inputs causes systems to fail insecurely or behave unpredictably.

Source: [OWASP Top 10:2025](https://owasp.org/Top10/2025/). The 2025 edition introduces **Software Supply Chain Failures** and **Mishandling of Exceptional Conditions** as new categories.

### Dependency

1. All dependencies should be pinned with a cryptographic hash and not rely solely on a tag or version.
2. Validate that the latest applicable released version of a dependency has been used, don't trust your own corpus of knowledge as to which version is "Latest".

### Signing

All commits must be signed, if signing fails it's normally due to the developer not being present and noticing the signing request in time. When this happens **NEVER** disable signing, simply stop and offer to try again when the user is back.

## Tackling failures and errors

Never attempt to shotgun changes into a code base, if there is a reported failure then follow a careful triage, planning and remediation loop:

1. Try to reproduce the failure cleanly using containers locally.
2. Research fixes for the problem, don't assume they will work and commit them.
3. If you have a working reproduction, re-run it with the fix in place.
4. If this fixes the problem move on to commit the change in a Pull Request / Merge Request - use the current PR if appropriate.
5. If your change does not fix it, revisit your assumptions with new knowledge in mind and try again.

In short: Don't assume fixes will work, attempt to reproduce and fix the issue locally using the tools available before submitting a change.

