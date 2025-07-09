# Test Data Sources

These are small simulated files used for pipeline testing:

---

## Simulated Data Details

| File                     | Description                                                                 |
|--------------------------|-----------------------------------------------------------------------------|
| `reads.fastq.gz`         | Simulated Oxford Nanopore reads generated using `badread`                   |
| `reference.fa`           | Toy reference genome (100 kb region)                                        |
| `target_regions.bed`     | BED file with toy target regions                                            |
| `non_target_regions.bed` | BED file computed as the complement of target regions over the reference    |
| `sequencing_summary.txt` | Mock ONT-style sequencing summary                                           |


## Where to Get Real Data

If you'd like to replace the test data with real datasets, see:

- **NA12878 reference data**:
  - [Genome in a Bottle](https://www.nist.gov/programs-projects/genome-bottle)
  - [ENA - PRJEB23027 (Nanopore)](https://www.ebi.ac.uk/ena/browser/view/PRJEB23027)
- **Reference genome**:
  - [GENCODE GRCh38.p14](https://www.gencodegenes.org/human/)
- **BED target examples**:
  - [UCSC Table Browser](https://genome.ucsc.edu/cgi-bin/hgTables)

---

**Note:** These files are not suitable for biological conclusions. They are **mock files** for validating pipeline structure only.
