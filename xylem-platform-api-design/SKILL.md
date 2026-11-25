---
name: xylem-platform-api-design
description: Design and evolve versioned Xylem platform contracts with explicit refusal and a stable error taxonomy. Use when adding a contract identity, changing version negotiation, adding or renaming a refusal code or envelope field, deprecating a contract, or exposing a cross-layer API; trigger on "family/vN", "contract_id", "UMS-REF", "unknown major", "add error code", "bump major", or "public interface change".
---

# Platform API design

The canonical vocabulary is `lotus/contracts/{core,refusal,version}.xy`: read those three files before designing any platform interface. This skill states the rules they implement; it does not restate their code. All claims are source-backed and `PENDING_INDEPENDENT_VERIFICATION` until independently reproduced (workspace verification rule).

## Identity

- MUST express every versioned contract identity as `family/vN`, built by `contract_id(family, major)` from a named family and an explicit positive major (`lotus/contracts/core.xy:3-7,16-19`). Rationale: a declared, precise public API is what gives version numbers meaning; `MAJOR` signals incompatible change while `MINOR`/`PATCH` stay compatible (SemVer 2.0.0, https://semver.org/spec/v2.0.0.html).
- MUST parse identity only through `parse_contract_id`: two `/`-separated parts, lowercase namespaced family, `v` plus decimal major ≥ 1 (`core.xy:26-39,118-141`). A malformed spelling MUST produce `UMS-REF-0048` (`core.xy:41-43`). Rationale: one parser gives one notion of validity, so no consumer invents a family or major.
- DEFAULT TO one `family` constant and one `supported_contract()` helper per module (`lotus/contracts/manifest.xy:37-40,158-172`; `plugin.xy:35-38,75-89`). MUST keep the `lotus.*` namespace; an `xylem.lotus.*` alias is an owner decision, not a local rename (`docs/decisions/D-005-lotus-port-strategy.md:231-232`; `lotus/README.md:51-62`). Rationale: two spellings of one identity split the registry.

## Negotiation

- MUST accept a requested id only when a supported id has the same family and the exact same numeric major; success returns the requested id unchanged (`lotus/contracts/version.xy:11-45`). An absent major MUST be refused with `UMS-REF-0009`; a malformed id with `UMS-REF-0048` (`version.xy:18-20,31-33,43-44`). Rationale: explicit versioning is mandatory and an unsupported version gets a machine-readable failure, never a default (Microsoft REST API Guidelines §12, https://github.com/microsoft/api-guidelines/blob/master/Guidelines.md; Azure unsupported-version rule, https://github.com/microsoft/api-guidelines/blob/vNext/azure/Guidelines.md).
- MUST route every support query through `is_supported`, which delegates to `negotiate` (`version.xy:47-70`). MUST NOT add a second compatibility predicate. Rationale: `negotiate` is the single source of truth; a parallel check drifts.
- MUST NOT upgrade, downgrade, substitute, or fall back to a neighbouring major even when the payload looks compatible (`version.xy:3-6`; D-005:194-196). Rationale: fallback turns a contract violation into wrong behaviour that no log records.

## Refusal envelope and error taxonomy

- MUST build every refusal through `refusal(code, message, contract_version)` with all seven fields: `code`, `severity`, `message`, `contract_version`, `context`, `remediation`, `correlation_id` (`lotus/contracts/refusal.xy:24-32,101-114`). MUST keep snake_case field names as in the serialized Rust struct and published schema (`lotus/README.md:112-123`). Rationale: one envelope lets callers write one error handler.
- MUST use only the two registered canonical codes in this port: `UMS-REF-0009` (unsupported major) and `UMS-REF-0048` (malformed contract), both `Severity.Error`; legacy aliases resolve explicitly and unregistered codes inherit neither severity nor remedy (`refusal.xy:8-14,54-99,137-142`). Rationale: a new client-visible `code` value is a breaking change (Microsoft §7.10.2, Guidelines.md URL above).
- MUST derive `correlation_id` deterministically from SHA-256 of code+message, not host randomness (`refusal.xy:34-52`). Rationale: conformance fixtures must be byte-identical; the id is shaped like a UUID but is not RFC-4122 v4.
- MUST keep the taxonomy closed: an unknown capability or target, a self-edge or cycle, an invalid run transition, or an ambiguous provider returns a registered refusal, never an empty success (`lotus/contracts/manifest.xy:181-220,288-301`; `graph.xy:158-190`; `workflow.xy:39-46`). Rationale: silent success hides malformed input.

## Evolution

- DEFAULT TO additive-only change inside a major: add optional fields with deterministic defaults and let clients ignore unknown fields; existing fixtures stay byte-identical (Microsoft §6.1 ignore rule, Guidelines.md URL above). MUST treat a new enum variant or a changed field type as breaking and publish `family/vN+1` with a migration note — adding `RunState.Waiting`/`Cancelled` made a pre-existing `label()` match non-exhaustive (`E3010`) and needed a governed exception (D-005:22-26). Rationale: exhaustive matches make variant addition observable everywhere.
- MUST deprecate before removal: document the old major, keep it supported for one release window, then answer it with an explicit refusal in the next major (SemVer deprecation FAQ, https://semver.org/spec/v2.0.0.html; Microsoft Graph lifecycle, https://github.com/microsoft/api-guidelines/blob/vNext/graph/GuidelinesGraph.md).
- MUST ship a negative fixture for every new refusal path before calling the change done (`lotus/tests/l1_core_refusal.xy`, `lotus/tests/l1_core_version.xy`; D-003 contract, `docs/decisions/D-003-platform-app-conformance.md:14-29`).

## Completion criteria

- [ ] Identity is `family/vN` from `contract_id`, parsed only by `parse_contract_id`.
- [ ] A positive fixture and a negative fixture prove each major accept/refuse case.
- [ ] Every new refusal uses `refusal(...)` with all seven fields and a registered canonical code.
- [ ] A negative fixture exists for every new refusal path.
- [ ] Additive change leaves all pre-existing fixtures byte-identical.
- [ ] Deprecation has a migration note and keeps the old major supported.
- [ ] No second identity grammar, error vocabulary, or compatibility predicate exists.

## References

- Local: `lotus/contracts/core.xy:3-7,16-19,26-39,41-47,118-141`; `refusal.xy:8-14,24-32,34-52,54-99,101-142`; `version.xy:1-70`; `manifest.xy:158-172,288-301`; `plugin.xy:35-38,75-89`; `lotus/README.md:51-62,112-123`; `docs/decisions/D-005-lotus-port-strategy.md:22-26,194-196,231-232`; `docs/decisions/D-003-platform-app-conformance.md:14-29`.
- Web, fetched 2026-11-25: https://semver.org/spec/v2.0.0.html ; https://github.com/microsoft/api-guidelines/blob/master/Guidelines.md ; https://github.com/microsoft/api-guidelines/blob/vNext/azure/Guidelines.md ; https://github.com/microsoft/api-guidelines/blob/vNext/graph/GuidelinesGraph.md .
