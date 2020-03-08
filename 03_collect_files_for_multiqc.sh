## Collecting relevant data for MultiQC ##
# Start in Main directory
mkdir -p for_MultiQC

# install MultiQC locally if not already installed
#pip install MultiQC
#conda install -c bioconda multiqc 

# Copy FastQC output
cp working_data/*/*.zip $PWD/for_MultiQC

# Copy STAR output
cp result/*/*.out $PWD/for_MultiQC

# Copy STAR gene counts if needed
cp result/*/*Reads* $PWD/for_MultiQC

