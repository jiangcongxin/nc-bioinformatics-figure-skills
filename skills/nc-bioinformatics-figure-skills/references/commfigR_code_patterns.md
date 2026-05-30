# commfigR Code Patterns

Purpose: record how A1/A2 GitHub code-learning patterns were rewritten into `commfigR` without copying upstream source code.

## Pattern Sources

| Source Repo | Evidence | Learned Pattern | commfigR Rewrite |
|---|---|---|---|
| FastCCC | `fastccc_demo.ipynb`; `examples/report_single_condition.py`; `examples/report_multi_condition.py`; report image examples | full LR table first, filtered network second, differential evidence third | `plot_lr_heatmap_panel()`, `plot_lr_network_panel()`, `plot_differential_communication_panel()` |
| Human_endometrium | `cellphonedb_step*.R/sh`; `nichenet.R`; `scenic_step*.R/py` | stage-aware communication/regulatory outputs need compact evidence panels | `plot_sender_receiver_score_panel()` and communication score schema |
| FineST | `docs/source/*LRI_CCC_count.ipynb`; `FineST/plottings.py` | spatial LR count should be paired with spatial validation | `commfigR` LR panels plus `spfigR` spatial feature/domain panels |
| Tumor-cell-villages | `3.Identify_SDNs.r`; `5.spatial_gene_codependency_of_tumor_and_TME.r` | TME communication/network panels need filtered interpretable edges | `network_edges.tsv` and `plot_lr_network_panel()` |

## Implementation Choices

| Choice | Reason |
|---|---|
| TSV-first LR tables | Stable across FastCCC, CellPhoneDB, NicheNet, CellChat, and custom LR outputs. |
| heatmap + filtered network | Prevents unreadable all-edge communication graphs. |
| differential lollipop | Keeps condition contrast compact and rankable. |
| `ncfigR` dependency | Reuse shared heatmap, network, theme, composition, and export behavior. |
| no analysis functions | Keeps package focused on figure generation, not method execution. |

## Communication Figure Panel Grammar

| Panel | Function | Role | Main-Figure Rule |
|---|---|---|---|
| A | `plot_lr_heatmap_panel()` | global sender-receiver structure | use all retained interactions or summarized score |
| B | `plot_lr_network_panel()` | interpretable top network | use filtered top edges only |
| C | `plot_sender_receiver_score_panel()` | sender/receiver or score-type comparison | show condition/stage facets when needed |
| D | `plot_differential_communication_panel()` | condition contrast | rank top differential LR pairs |

## QA Checklist

- Full LR source table is preserved.
- Network edge list records filtering decisions.
- Differential LR table includes effect size and adjusted P-value.
- Sender/receiver scores have explicit score type.
- Heatmap and network use the same source/target naming.
- Export is done through `ncfigR::export_figure_bundle()`.
