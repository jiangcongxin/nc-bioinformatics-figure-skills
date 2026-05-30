# NC 优先的生信 Figure 绘图 Skill 库（50 篇）

生成日期：2026-05-30

目标：通过 Nature Communications 优先、GitHub 代码可追踪的高分生信/组学论文，建立自己的绘图 skills。时间窗放宽到 2024-2026 为主；为覆盖热门方法，补充少量 Nature / Nature Methods / Nature Biotechnology / Genome Biology。

证据等级：A = 已看到 figures/notebooks/reproduce/code/source data 等明确入口，适合作为第一批精读复刻；B = Nature 页面 Code availability 指向 GitHub，但具体 Fig 脚本需进仓库继续定位。

## 1. 先学的绘图 Skill 模块

### Skill 1: 单细胞 UMAP / embedding 叙事
代表条目：scPRINT、CellMentor、RareQ、CellANOVA、scFoundation。训练目标：不要只画 UMAP，要把 embedding 和 cell type、状态、疾病组、模型指标绑定。练习：同一 h5ad 输出 3 列图，raw/integrated/model embedding，并在右侧放 silhouette 或 accuracy。

### Skill 2: 空间组织图与 histology overlay
代表条目：Sopa、FineST、CellRefiner、DICER1 sarcoma、GBM atlas。训练目标：统一坐标比例、spot/cell size、domain 色板和局部 zoom-in。练习：H&E 或背景图 + spatial scatter + marker feature + zoom-in 四联图。

### Skill 3: marker dotplot / heatmap / annotation heatmap
代表条目：TranScale、Aboelnour demyelination、ILC-NK HIPEC、CAR-T、melanoma transition。训练目标：热图必须有分组注释和解释性排序。练习：cell type x marker heatmap，顶部加 disease/stage/treatment annotation。

### Skill 4: cell-cell communication / niche / network 图
代表条目：NiCo、FastCCC、Tumor cell villages、Endometrium、FineST。训练目标：网络图只显示关键边，完整信息交给热图。练习：LR heatmap + top ligand-receptor network + spatial niche map。

### Skill 5: pseudotime / trajectory / state transition 图
代表条目：VeloCD、ddHodge、MoFlow、silkworm wing disc、DICER1 sarcoma。训练目标：trajectory 必须同时给 direction、gene dynamics 和 biological state labels。练习：UMAP velocity arrows + pseudotime gradient + top gene trend。

### Skill 6: benchmark / 统计比较图
代表条目：NEP comparison、SMART、CAMEX、cPeaks、ProteoCast。训练目标：benchmark 主体用矩阵或 rank，旁边必须配代表性真实案例。练习：method x dataset heatmap + average-rank lollipop + one example panel。

### Skill 7: 多组学整合组合图
代表条目：SMART、SpatialGlue、MoFlow、TDP-43 motor cortex、melanoma transition。训练目标：同一 sample/cell state 跨 RNA、ATAC、protein、spatial 维度对齐。练习：RNA UMAP + ATAC heatmap + protein/marker panel + integrated score。

### Skill 8: genome track / variant / pangenome 图
代表条目：GET、AlphaGenome、RBM20、NUMT pangenome、cPeaks、Trisomy 21。训练目标：所有 tracks 共用 x 轴，variant/effect 放在最下方。练习：gene model + observed track + predicted track + delta bar。

### Skill 9: microbiome / metagenomics 网络图
代表条目：gut microbiome topology、coffee microbiome、CRC tissue microbiota。训练目标：composition、co-occurrence、host association 三层分开。练习：stacked composition bar + co-occurrence network + phenotype heatmap。

### Skill 10: 期刊级 Figure 组版
代表条目：CAST、Panpipes、Novae、scPRINT、AlphaGenome。训练目标：每张主图只回答一个问题；panel 顺序从“输入/设计”到“结果/机制”。练习：用 6 个 panel 组一张 Figure 1：workflow、data overview、main map、quantification、case zoom、take-home model。

## 2. 50 篇论文主索引

|#|论文|期刊|生物/方法问题|Figure code / analysis 入口|最值得学的图|版式思维|绘图语言/包|可复刻 skill|个人模板沉淀|证据|
|---|---|---|---|---|---|---|---|---|---|---|
|1|[scPRINT: large-scale single-cell foundation model with gene network inference](https://www.nature.com/articles/s41467-025-58699-1)|Nature Communications 2025|单细胞 foundation model + GRN|[code](https://github.com/cantinilab/scPRINT/blob/1.6.4/figures/nice_umap.ipynb)|atlas UMAP、GRN network、benchmark bar/PR-AUC|入口大 UMAP 建立数据规模，右侧接 GRN/benchmark，形成“模型能力 -> 生物解释”闭环|Python；figure notebook 已给出|UMAP/embedding; network; benchmark|大 UMAP + 网络 + 性能条形图|A|
|2|[Sopa: technology-invariant pipeline for image-based spatial-omics](https://www.nature.com/articles/s41467-024-48981-z)|Nature Communications 2024|空间组学 pipeline / segmentation / viewer|[code](https://github.com/gustaveroussy/sopa)|segmentation overlay、cell table、spatial scatter、QC panel|左侧技术输入，中间处理模块，右侧统一 cell table 和空间图|Python；spatialdata/napari 生态，具体 figure 脚本需仓库复核|空间组织图; QC; 组版|pipeline schematic + segmentation overlay + QC|B|
|3|[NiCo identifies niche covariations and extrinsic drivers](https://www.nature.com/articles/s41467-024-54973-w)|Nature Communications 2024|空间 niche / cell-state modulation|[code](https://github.com/ankitbioinfo/nico_tutorial)|niche graph、regression coefficient network、factor heatmap|空间位置图先定场，网络/热图解释 microenvironment driver|Python 文档/教程；具体 figure 脚本需复核|network; niche; heatmap|spatial map + neighborhood network + factor heatmap|A|
|4|[CellRefiner reconstructs single-cell resolution from spatial transcriptomics](https://www.nature.com/articles/s41467-026-70090-2)|Nature Communications 2026|空间转录组单细胞分辨率重建|[code](https://github.com/XiangyuKuang/cellrefiner)|spot-to-cell reconstruction、pseudo-Visium benchmark、communication recovery|低分辨率 spot -> 重建 cell map -> ground truth/benchmark 三联|Python；tutorial/reproducible code|空间组织图; benchmark; communication|spot pie + reconstructed cells + error plot|A|
|5|[Predicting trajectories of illness using RNA velocity of whole blood](https://www.nature.com/articles/s41467-026-71685-5)|Nature Communications 2026|RNA velocity / 临床轨迹|[code](https://github.com/DrClaireDunican/VeloCD/tree/main)|velocity embedding、trajectory arrows、clinical state transition|embedding 图上叠加方向场，再用临床分组/时间验证|R/Python 混合；Nature 页指向 VeloCD repo|trajectory; embedding|UMAP + velocity arrows + clinical timeline|A|
|6|[Comparison and optimization of cellular neighbor preference methods](https://www.nature.com/articles/s41467-026-71699-z)|Nature Communications 2026|空间邻域偏好方法比较|[code](https://github.com/SchapiroLabor/NEP_comparison)|neighbor preference benchmark、simulated tissue、method comparison heatmap|先用模拟组织解释 ground truth，再用方法矩阵做横向比较|R/Python；多个 NEP repos 和 simulated_data|benchmark; spatial; network|simulated tissue + method heatmap + rank plot|A|
|7|[Cell neighborhood topology directs rare cell population identification](https://www.nature.com/articles/s41467-026-71180-x)|Nature Communications 2026|稀有细胞识别 / 空间拓扑|[code](https://github.com/xiaolab-xjtu/RareQ)|rare cell UMAP、topology graph、benchmark|突出 rare cluster：左侧整体 embedding，右侧局部放大和拓扑证据|推断 R/Python，需仓库复核|UMAP/embedding; network|rare cluster zoom-in + topology graph|B|
|8|[Spatial single-cell transcriptomic analysis informs DICER1 sarcoma hierarchy](https://www.nature.com/articles/s41467-026-70971-6)|Nature Communications 2026|肿瘤空间单细胞 / 发育层级|[code](https://github.com/Huntsmanlab/dicer1-cell-of-origin)|spatial tumor map、cell-of-origin trajectory、lineage hierarchy|病例组织图与 trajectory 并排，形成“空间位置 -> 层级来源”叙事|R/Python；需仓库复核|spatial; trajectory; tumor atlas|spatial case map + hierarchy tree|B|
|9|[SMART: spatial multi-omic aggregation using graph neural networks](https://www.nature.com/articles/s41467-026-70821-5)|Nature Communications 2026|空间多组学整合 / GNN|[code](https://github.com/Xubin-s-Lab/SMART-main/tree/SMART-reproduce)|multi-omic domain map、GNN workflow、benchmark heatmap|每列一个模态/样本，每行一个方法或指标，突出 cross-modal gain|Python；SMART-reproduce|multiomics; spatial; benchmark|multi-modal grid + benchmark matrix|A|
|10|[TranScale: SI-anchored absolute transcriptomics](https://www.nature.com/articles/s41467-026-70582-1)|Nature Communications 2026|绝对转录组定量 / 标准化|[code](https://github.com/zhyu0807/TranScale/tree/main/code)|calibration curve、absolute expression heatmap、source data panels|方法校准图在前，真实数据矩阵/热图在后|Python/R；code 与 Source_Data 明确|benchmark; heatmap|calibration curve + expression heatmap|A|
|11|[FineST integrates histology and spatial transcriptomics](https://www.nature.com/articles/s41467-026-70528-7)|Nature Communications 2026|histology + ST / ligand-receptor|[code](https://github.com/StatBiomed/FineST)|histology patch、nuclei-resolved map、LR interaction|H&E/patch 做视觉入口，空间点图和 LR 网络解释局部通讯|Python；需仓库复核 figure scripts|histology overlay; communication; spatial|H&E tile + spatial LR map + interaction network|B|
|12|[HRCHY-CytoCommunity identifies hierarchical tissue organization](https://www.nature.com/articles/s41467-026-70069-z)|Nature Communications 2026|组织空间层级 / community|[code](https://github.com/huBioinfo/HRCHY-CytoCommunity)|hierarchical tissue map、community tree、spatial domain|空间 domain 与层级树同步配色，读者能沿颜色追踪组织层级|推断 Python/R；需仓库复核|spatial; hierarchy; network|domain map + community tree|B|
|13|[FastCCC: scalable cell-cell communication analysis](https://www.nature.com/articles/s41467-025-66272-z)|Nature Communications 2025|单细胞通讯分析|[code](https://github.com/Svvord/FastCCC)|CCC network、ligand-receptor heatmap、scalability benchmark|先展示通讯矩阵，再用 case study 网络讲具体通路|Python；repo 明确|communication; benchmark; heatmap|LR heatmap + cell-cell network|A|
|14|[CellMentor: cell-type aware dimensionality reduction](https://www.nature.com/articles/s41467-025-67088-7)|Nature Communications 2025|单细胞降维 / cell type aware embedding|[code](https://github.com/petrenkokate/CellMentor_paper)|embedding comparison、cell type separation、method benchmark|把同一数据在不同 embedding 中并排，旁边放定量指标|Python；paper repo|UMAP/embedding; benchmark|embedding grid + separation metric|A|
|15|[Spatial perturb-seq within intact tissue architecture](https://www.nature.com/articles/s41467-026-69677-6)|Nature Communications 2026|空间 Perturb-seq / functional genomics|[code](https://github.com/kimberle9/spatialperturbseq)|perturbation map、spatial effect heatmap、gene program panels|扰动设计 schematic -> 空间效应图 -> 基因程序热图|R/Python；需仓库复核|spatial; perturbation; heatmap|perturbation design + spatial effect map|B|
|16|[Tumor cell villages define tumor-microenvironment co-dependency in liver cancer](https://www.nature.com/articles/s41467-026-69797-z)|Nature Communications 2026|肝癌空间生态位 / TME|[code](https://github.com/MengLiu1/Tumor-cell-villages)|tumor village map、cell composition、interaction network|先定义 village，再分解组成、通讯和临床关联|R/Python；需仓库复核|spatial; niche; communication|tumor village map + composition bar + network|B|
|17|[Single-cell and spatial transcriptomics of silkworm wing disc](https://www.nature.com/articles/s41467-026-69518-6)|Nature Communications 2026|发育 atlas / scRNA + ST|[code](https://github.com/meimeihe/Bombyx-mori-wing-disc.git)|developmental UMAP、spatial domains、pseudotime|UMAP 讲细胞谱系，空间图讲位置，pseudotime 讲时间|R/Python；需仓库复核|UMAP; spatial; trajectory|UMAP + spatial domain + pseudotime|B|
|18|[A spatially resolved human glioblastoma atlas](https://www.nature.com/articles/s41467-026-69716-2)|Nature Communications 2026|GBM 空间 atlas / anatomical niche|[code](https://github.com/nameetas/TSKGA)|anatomical niche map、spatial cell states、marker heatmap|以 anatomical niche 分组，减少空间 atlas 图的混乱|R/Python；需仓库复核|spatial; heatmap; atlas|niche map + marker heatmap|B|
|19|[Spatial cartography of human thymus](https://www.nature.com/articles/s41467-026-68596-w)|Nature Communications 2026|人胸腺空间图谱 / rare cell定位|[code](https://github.com/UmaSangumathi/mimeTFs.git)|geopositioning map、rare cell spatial enrichment、TF map|先用空间坐标定位 rare population，再叠加 lineage TF|R/Python；需仓库复核|spatial; marker; rare cell|rare-cell spatial enrichment map|B|
|20|[Multi-modal dissection of TDP-43 pathology in motor cortex](https://www.nature.com/articles/s41467-026-69944-6)|Nature Communications 2026|多模态脑区病理 atlas|[code](https://github.com/DanzerLab/Ruf_et_al_2026)|cell-type pathology map、multi-modal integration、differential heatmap|病理分层与 cell-type 分层并列，适合疾病 atlas|R/Python；需仓库复核|multiomics; heatmap; atlas|pathology strata + cell type heatmap|B|
|21|[CAMEX: cross-species single-cell integration and annotation](https://www.nature.com/articles/s41467-026-69696-3)|Nature Communications 2026|跨物种 scRNA 整合|[code](https://github.com/zhanglabtools/CAMEX/)|cross-species embedding、alignment score、annotation transfer|每个物种一列，统一 embedding/marker/score|Python；repo 明确|embedding; benchmark; annotation|cross-species embedding grid|A|
|22|[cPeaks: generic reference for scATAC-seq consensus peaks](https://www.nature.com/articles/s41467-026-69461-6)|Nature Communications 2026|scATAC reference / peak atlas|[code](https://github.com/MengQiuchen/cPeaks)|peak reference schematic、coverage track、benchmark|轨道图和 peak-set benchmark 结合，适合 epigenomics|Python/R；repo 明确|genome track; benchmark|ATAC track + peak set heatmap|A|
|23|[ddHodge: vector field reconstruction of cell-state dynamics](https://www.nature.com/articles/s41467-025-67782-6)|Nature Communications 2025|细胞状态动力学 / vector field|[code](https://github.com/kazumits/ddHodge_figures)|vector field、trajectory landscape、method comparison|把复杂数学压缩为“箭头场 + landscape + benchmark”|Julia；figure repo 明确|trajectory; vector field|embedding vector field + landscape|A|
|24|[MoFlow: multi-omic relay velocity modeling](https://www.nature.com/articles/s41467-025-67259-6)|Nature Communications 2025|多组学 velocity / chromatin-transcription|[code](https://github.com/AriHong/MoFlow)|relay velocity arrows、chromatin-RNA coupling、gene dynamics|上层 chromatin，下层 RNA，箭头连接状态变化|Python；repo 明确|trajectory; multiomics|multi-omic velocity panel|A|
|25|[Spatiotemporal code of human endometrial receptivity](https://www.nature.com/articles/s41467-025-67492-z)|Nature Communications 2025|时空单细胞 atlas / 生殖医学|[code](https://github.com/Zluei/Human_endometrium)|cycle phase UMAP、spatial map、cell-cell interaction|以时间阶段为主线，把空间与通讯作为解释层|R/Python；需仓库复核|trajectory; spatial; communication|time-stage UMAP + spatial map + LR network|B|
|26|[Tissue-resident microbiota across normal, polyp and CRC tissues](https://www.nature.com/articles/s41467-026-69705-5)|Nature Communications 2026|组织微生物组 / CRC|[code](https://github.com/Lingning927/microbioInCRC)|microbiome composition、spatial/tissue strata、association heatmap|组织分层在列，菌群/通路在行，突出 normal-polyp-cancer 梯度|R/Python；需仓库复核|microbiome; heatmap|composition bar + association heatmap|B|
|27|[Comparative transcriptomic analysis of demyelination models and MS lesions](https://www.nature.com/articles/s41467-026-72383-y)|Nature Communications 2026|疾病转录组 meta-analysis|[code](https://github.com/AdamsLabNotreDame/Aboelnour_et_al)|cross-model heatmap、module score、cell type comparison|疾病模型与人类病灶并列，强调 conserved vs model-specific|R/Python；需仓库复核|heatmap; module score; comparison|model x disease heatmap|B|
|28|[PD-1 blockade plus TKI remodels RCC tumor microenvironment](https://www.nature.com/articles/s41467-026-70978-z)|Nature Communications 2026|肾癌治疗前后 TME|[code](https://github.com/zhang-qi-max/PLAGHNeo)|pre/post therapy UMAP、cell fraction、interaction network|治疗时间点作为列，cell type/function/communication 为行|R/Python；需仓库复核|UMAP; communication; clinical|pre-post UMAP + fraction plot + LR network|B|
|29|[Tumor-infiltrating ILC/NK differentiation in colorectal cancer](https://www.nature.com/articles/s41467-026-71085-9)|Nature Communications 2026|CRC 免疫单细胞 / differentiation|[code](https://github.com/Mjosberg-Lab/ILC-NK-HIPEC)|immune UMAP、trajectory、signature heatmap|先分群，再沿 trajectory 解释分化偏向，最后连接临床/空间|R/Python；需仓库复核|UMAP; trajectory; heatmap|immune trajectory + signature heatmap|B|
|30|[Lymphodepleting preconditioning impairs antitumor immunity after ACT](https://www.nature.com/articles/s41467-026-71082-y)|Nature Communications 2026|免疫治疗 / 单细胞机制|[code](https://github.com/ahernandezoliv/Figueroa_etal_2026)|immune composition、T cell state map、functional score|处理组对照应固定 panel 结构，避免每图重新编码|R/Python；repo 名直接为论文代码|UMAP; composition; clinical|grouped UMAP + stacked composition|A|
|31|[RBM20 isoform regulation adapts splicing](https://www.nature.com/articles/s41467-026-73230-w)|Nature Communications 2026|可变剪接 / isoform regulation|[code](https://github.com/MitchGotthardt/GotthardtLab/tree/main)|isoform sashimi/PSI plot、developmental series、disease comparison|基因结构图 + PSI/isoform 定量并排，适合 splicing 论文|R/Python；需仓库复核|genome track; statistics|gene model + PSI violin + sashimi-like panel|B|
|32|[Long-read human pangenome initiative for NUMT interpretation](https://www.nature.com/articles/s41467-026-71348-5)|Nature Communications 2026|长读长 pangenome / NUMT|[code](https://github.com/LiantingFu/NUMT_Analysis)|pangenome schematic、variant/NUMT track、population heatmap|用 genome track 定位复杂区域，再用 population matrix 展示频率|Python/R；需仓库复核|genome track; pangenome|locus track + population heatmap|B|
|33|[Network topology of gut microbiome associates with metabolic health](https://www.nature.com/articles/s41467-026-72588-1)|Nature Communications 2026|肠道微生物组网络|[code](https://github.com/blacruz17/MHOmicrobiome)|microbiome network、co-occurrence modules、clinical association|网络图只保留模块级结构，细节放热图/条形图|R/Python；需仓库复核|microbiome; network|co-occurrence network + phenotype heatmap|B|
|34|[Habitual coffee intake shapes gut microbiome](https://www.nature.com/articles/s41467-026-71264-8)|Nature Communications 2026|饮食-微生物组-表型|[code](https://github.com/thomazbastiaanssen/coffee/)|composition bar、dose-response、microbe-host association|人群暴露分层清楚，microbe associations 用森林图/热图|R/Python；需仓库复核|microbiome; statistics|exposure gradient + microbe association heatmap|B|
|35|[ProteoCast predicts functional impact of missense variants](https://www.nature.com/articles/s41467-026-72140-1)|Nature Communications 2026|蛋白变异效应预测|[code](https://github.com/abakarovaMarina/ProteoCast)|variant effect heatmap、protein domain map、benchmark ROC|蛋白 domain schematic 与 variant score heatmap 绑定|Python；repo 明确|variant; benchmark|protein domain + variant score heatmap|B|
|36|[Sequential transcriptional waves and chromatin remodeling in cancer dedifferentiation](https://www.nature.com/articles/s41467-026-71349-4)|Nature Communications 2026|癌症去分化 / scRNA+chromatin|[code](https://github.com/jihoonlee0/melanoma_reversible_transition)|time-course UMAP、chromatin accessibility heatmap、TF network|时间轴是主骨架，转录与染色质并排解释|R/Python；需仓库复核|trajectory; multiomics; heatmap|time-course UMAP + TF/accessibility heatmap|B|
|37|[CAR-T affinity combination balances efficacy and safety](https://www.nature.com/articles/s41467-026-71354-7)|Nature Communications 2026|CAR-T scRNA / therapy design|[code](https://github.com/Busch-Lab/2026_Warmuth_Doetsch_affinity-combined-CAR-T_cell-products_scRNAseq)|CAR-T state UMAP、dose/affinity response、cytokine/function heatmap|实验条件多时，用条件矩阵而不是散乱 panel|R/Python；repo 明确|UMAP; heatmap; statistics|condition matrix + T cell state UMAP|B|
|38|[Trisomy 21 and premature RNA recoding in fetal brain](https://www.nature.com/articles/s41467-026-70217-5)|Nature Communications 2026|发育脑 / RNA editing|[code](https://github.com/BreenMS/Trisomy21)|cell type UMAP、RNA editing sites、developmental comparison|cell-type 图与 editing-site genome track 组合|R/Python；需仓库复核|UMAP; genome track|cell type map + editing site lollipop|B|
|39|[SpatialGlue integrates spatial multi-omics](https://www.nature.com/articles/s41592-024-02316-4)|Nature Methods 2024|空间多组学整合|[code](https://github.com/JinmiaoChenLab/SpatialGlue)|spatial domain map、modality integration、benchmark|多模态输入图 + domain grid + 指标矩阵|Python；repo 明确|spatial; multiomics; benchmark|domain map grid + metric heatmap|A|
|40|[CAST searches and matches across spatial omics samples](https://www.nature.com/articles/s41592-024-02410-7)|Nature Methods 2024|跨样本空间匹配|[code](https://zenodo.org/records/12215315)|alignment before/after、query-reference match、similarity heatmap|横向流程：query -> reference -> aligned -> biology|Python/R；Zenodo reproduction package 明确|spatial; alignment|before-after alignment + similarity map|A|
|41|[Panpipes: reproducible pipelines for scRNA/spatial omics](https://genomebiology.biomedcentral.com/articles/10.1186/s13059-024-03322-7)|Genome Biology 2024|单细胞/空间 workflow|[code](https://github.com/DendrouLab/panpipes)|workflow DAG、QC violin、UMAP、integration result|模块化泳道图最值得学：每个步骤配一个小输出|Python/scverse；docs 明确|workflow; QC; UMAP|pipeline DAG + QC mini-panels|A|
|42|[scHolography reconstructs spatial context from single-cell data](https://genomebiology.biomedcentral.com/articles/10.1186/s13059-024-03299-3)|Genome Biology 2024|单细胞空间邻域重建|[code](https://github.com/YiLab-SC/scHolography)|3D scatter、neighborhood graph、communication heatmap|先给 3D 空间直觉，再接邻域/通讯定量|R package；manuscript scripts|3D/spatial; network|3D cell map + neighborhood composition heatmap|A|
|43|[aKNNO: adaptive kNN for single-cell/spatial clustering](https://genomebiology.biomedcentral.com/articles/10.1186/s13059-024-03339-y)|Genome Biology 2024|聚类 / rare cell / spatial clustering|[code](https://github.com/liuqivandy/aKNNO)|cluster UMAP、simulation benchmark、rare cell detection|算法图简洁，结果用 rare cell 局部放大体现优势|R package；repo 明确|UMAP; benchmark|rare cluster UMAP + confusion matrix|A|
|44|[CellANOVA recovers biological signal lost in integration](https://www.nature.com/articles/s41587-024-02463-1)|Nature Biotechnology 2025|批次整合 / 信号恢复|[code](https://github.com/Janezjz/cellanova)|raw/integrated/recovered UMAP、variance partition|三联图最强：同一数据三种状态并排|Python；repo 明确|UMAP; benchmark; integration|raw-integrated-recovered UMAP triptych|A|
|45|[Nicheformer: spatial single-cell foundation model](https://www.nature.com/articles/s41592-025-02814-z)|Nature Methods 2025|空间单细胞 foundation model|[code](https://github.com/theislab/nicheformer)|data corpus map、neighborhood prediction、benchmark|先给大语料地图，再给空间邻域预测 case|Python；package/data repo 明确|foundation model; spatial; benchmark|corpus map + predicted-vs-true spatial panels|A|
|46|[Novae: graph-based foundation model for spatial transcriptomics](https://www.nature.com/articles/s41592-025-02899-6)|Nature Methods 2025|空间图 foundation model|[code](https://github.com/MICS-Lab/novae_benchmark)|multi-tissue domain maps、robustness benchmark、model overview|组织切片排成 grid，统一色板和比例|Python；benchmark repo 明确|spatial; foundation model; benchmark|multi-slice domain grid + benchmark|A|
|47|[GET: foundation model of transcription across cell types](https://www.nature.com/articles/s41586-024-08391-z)|Nature 2025|调控基因组 foundation model|[code](https://github.com/GET-Foundation/get_model)|genome tracks、motif grammar、cell-type prediction|所有轨道共用 locus x-axis，model output 与实验数据并排|Python；repo 明确|genome track; model interpretation|multi-track genome panel|A|
|48|[AlphaGenome: regulatory variant effect prediction](https://www.nature.com/articles/s41586-025-10014-0)|Nature 2026|调控变异预测|[code](https://github.com/google-deepmind/alphagenome_research)|variant effect tracks、multi-assay prediction、delta heatmap|locus schematic + multi-track prediction + variant delta|Python；research/API repo 明确|genome track; variant|variant delta track panel|A|
|49|[Evo 2: genome modelling and design](https://www.nature.com/articles/s41586-026-10176-5)|Nature 2026|长序列 DNA foundation model|[code](https://github.com/ArcInstitute/evo2)|model scaling、sequence generation、benchmark matrix|首图强调 scale，后图按 prediction/generation/design 分区|Python；repo 明确|foundation model; benchmark|scale bubble + task matrix|A|
|50|[scFoundation: large-scale foundation model on single-cell transcriptomics](https://www.nature.com/articles/s41592-024-02305-7)|Nature Methods 2024|单细胞 foundation model|[code](https://github.com/biomap-research/scFoundation)|model overview、embedding benchmark、perturbation/task panels|数据/预训练/任务 head 放在首图，后续每图一类下游任务|Python/PyTorch；repo 明确|foundation model; UMAP; benchmark|architecture schematic + task benchmark grid|A|

## 3. 推荐精读顺序

1. 第一周只读 A 级仓库：scPRINT、CAST、SMART、NEP comparison、ddHodge、Novae、AlphaGenome。目标是找到 figure/notebook/source data 的真实路径。

2. 第二周按技能复刻：UMAP、空间图、热图、通讯网络、trajectory、benchmark、genome track 各做一张最小图。

3. 第三周做组版：选一个自己的项目，把 6 个 panel 排成 Figure 1，不追求配色相同，只追求信息层级相同。

4. B 级论文作为扩展阅读：优先看 Code availability 和 repo 目录，只有找到 `fig`, `figure`, `plot`, `notebook`, `analysis`, `scripts`, `source_data` 后再纳入个人模板库。


## 4. 不要优先学的情况

- 只有模型推理代码，没有 figure/source data/notebook 的仓库。

- 图形只是普通 UMAP + 柱状图，没有明确叙事结构的文章。

- 仓库只能复现算法结果，但不能定位绘图或分析脚本的文章。

- 需要大量私有数据或交互式网页才能复现核心图的文章。


## 5. 个人绘图 Skill 沉淀模板

|模板名|输入数据|核心图型|最小代码包|输出 panel|验收标准|
|---|---|---|---|---|---|

|Embedding narrative|AnnData/Seurat object|UMAP + labels + metric|scanpy/Seurat + ggplot2/matplotlib|3列 embedding + 1列指标|颜色一致，legend 不重复，指标能解释图|
|Spatial domain story|spatial coordinates + image/labels|domain map + marker map + zoom|squidpy/spatialdata/Seurat|组织图、domain、marker、zoom|坐标比例一致，zoom 区域明确|
|Communication story|cell type x LR table|LR heatmap + network|CellChat/FastCCC/NicheNet/networkx|热图、网络、top pairs|网络只显示 top edges，热图保留完整矩阵|
|Trajectory story|embedding + pseudotime/velocity|arrows + gradient + gene trend|scVelo/dynamo/monocle3|方向场、pseudotime、gene trend|方向和生物阶段一致|
|Benchmark story|method x dataset metrics|heatmap + rank + case|seaborn/ComplexHeatmap|指标矩阵、rank、代表案例|排序规则清楚，有真实案例|
|Genome track story|locus + signal tracks|gene model + tracks + delta|pyGenomeTracks/Gviz|基因结构、观测、预测、变异影响|所有轨道共用 x 轴|
