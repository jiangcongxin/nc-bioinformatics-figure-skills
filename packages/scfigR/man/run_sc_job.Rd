\name{run_sc_job}
\alias{run_sc_job}
\alias{review_sc_job}
\title{Execute and review a structured single-cell figure task}
\description{Run the bounded single_cell_atlas task from JSON, preserve source data, and return a machine-readable report. Visual inspection is required before approval.}
\usage{
run_sc_job(spec_path, output_dir = NULL)
review_sc_job(run_dir, review_path)
}
\arguments{
\item{spec_path}{Path to a schema 1.0 task JSON file. Input and output paths are relative to its directory unless absolute.}
\item{output_dir}{Optional output root override, relative to the task file. A new attempt directory is always created; source files and earlier attempts are not overwritten.}
\item{run_dir}{An unreviewed, technically completed attempt directory returned by run_sc_job. Revised, failed, and passed runs are terminal; corrections require a new attempt.}
\item{review_path}{Path to a schema 1.0 visual review JSON file with the matching run_id, inspected PNG/vector paths, final size and six evidence-backed checks.}
}
\details{
Inputs are cell-level CSV/TSV embedding and complete long expression tables. Expression
scale and provenance must be declared. Only descriptive marker summaries and cell
fractions are computed; no annotation inference or differential expression testing.
Successful execution returns needs_review, not passed. CLI exit codes are 1 for
failure, 2 for review/revision, and 0 for reviewed pass. Reports include source and
artifact checksums, methods, warnings and next actions. Checksums detect changes to
recorded files; they are not cryptographic attestations against tampering.
review_sc_job verifies artifact checksums and the review protocol, not whether the
reviewer's observations are truthful. Inspection is self-reported and does not certify
journal acceptance or biological validity. Invalid review input leaves the task unapproved.
}
\value{A list containing status, exit_code, run_dir, report_path and next_action. Execution failures also return structured errors when the output directory is writable.}
