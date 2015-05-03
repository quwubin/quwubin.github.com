---
layout: post
title: mprimer manual
date:   2015-01-20 18:49:56
categories: PCR
---

Copyright © 2013-2015, Wubin Qu (quwubin@gmail.com)

Update date: 2015-1-19

# Installation

0. Linux and Mac OS X are supported. Tested on Ubuntu Linux 12.04 and Mac OS X 10.8.
1. Make sure Ruby (version >= 2.0) was installed. If not, please go to [here](https://www.ruby-lang.org/en/) for help.
2. Install BioRuby gem: `gem install bio`.
2. Make sure MySQL was installed. If not, please go to [here](http://dev.mysql.com/doc/refman/5.1/en/installing.html) for help.
3. MySQL: create database "mfeprimerdb" and create user "mfeprimer" with password "mfeprimer". You may use the following command to create database for mprimer:

    ```
    create database mfeprimerdb;
    grant all privileges on mfeprimerdb.* to mfeprimer@localhost identified by 'mfeprimer';
    ```
2. Untar the files: `tar jxvf mprimer-x.x-os.tar.bz2`. (Note: x.x is the version number and os is one of "linux" or "mac".)
0. After that, `cd` into the "mprimer" directory, and type `./mprimer`, if installed correctly, you will see the usage message. Otherwise, please contact the author for help.


# Quick use

Firstly, we design a 4-plex multiplex PCR primers to have a glance at mprimer.

0. `cd` into the "test" directory.
1. "test.rna" is the template sequences (contains 4 sequences) for design primers. We format the sequences firstly: `../mfeprimer-indexer -i test.rna`. After 30 seconds later, the database should be formatted done.
2. Then we tell mprimer our specific need for the primer design, such as product size, by run `../mprimer-config -in test.rna -productMinSize 100 -productMaxSize 200 -primerMinSize 18 primerMaxSize 26`. A file named "test.rna.csv" will be created, which have detailed configures for each template sequence.
3. Run "mprimer" to design primers: `../mprimer -in test.rna -out primer.tsv`. We can use "Microsoft Excel" to open the output primers.


    ![Mprimer Example Output] (/images/mprimer_example_output.png)


# Database preparation

The most important feature of mprimer is that we use background DNA to avoid nonspecific primers. Here, take human genome database as an example to show how to prepare the database.

0. Download hg19.2bit from [ucsc](http://hgdownload.cse.ucsc.edu/goldenpath/hg19/bigZips/hg19.2bit) and then convert it to fasta format by using "twoBitToFa" command: `twoBitToFa hg19.2bit hg19.fa`. If your database is already in fasta format, please skip the converting step. (twoBitToFa command is in "bin/linx/64" subdirectory of mprimer.)
1. If you want to mask the **bad regions** (e.g. repeat regions) before selecting primers, you can mask the genome here. hg19.2bit already masked in lower case by RepeatMasker and Tandem Repeats Finder. **Note: The 3'-end of the primers picked by mprimer won't sit in the masked regions**.
1. Run `./mfeprimer-indexer -i /path/to/hg19.fa`. **Note: Format large database such as human genome will need 16GB memory at least, and will take about 20 hours. However, this step just need format once.** This command will create a table with name "hg19_fa" in MySQL and three files in the path of original fasta format database, named as:
    * hg19.fa.2bit
    * hg19.fa.json
    * hg19.fa.log


<br />
# Template preparation

Mprimer requires template sequences in fasta format. But we have several useful scripts to help users to prepare the template sequences from other formats. Currently, we have developed several scripts to prepare template from the famous [bed](http://genome.ucsc.edu/FAQ/FAQformat.html#format1) format. We plan to support other more formats, such as, users just need to provide gene names.

## Template sequences in fasta format

If your template sequences are already in fasta format (below is an example), that's easy for mprimer, just feed it to mprimer using "-in your_template_sequences.fasta".

    >Mus_AQP11 mRNA for aquaporin 11, complete cds
    CCGCGCTACTGGGGCTCCGGCCCGAGGTGCAGGACACCTGCATCTCGCTGGGGCTAATGCTGCTGTTCGTGCTGTTCGTG
    GGGCTGGCCCGCGTGATCGCCCGGCAACAGCTACACAGGCCCGTGGTCCACGCCTTCGTCCTGGAGTTTCTAGCTACCTT
    CCAGCTCTGCTGCTGCACCCACGAGCTCCAAGTGCTGAGCGAGCAGGACTCTGCGCACCCCACCTGGACTCTGACACTGA
    TCTACTTCTTTTCCTTGGTGCATGGCCTGACCCTGGTGGGCACAGCTAGCAACCCGTGCGGCGTGATGATGCAGATGATT
    CTGGGGGGTATGTCCCCCGAAATGGGTGCCGTGAGGTTGTTGGCTCAGCTGGTTAGCGCCCTGTGCAGCAGGTACTGCAT
    AAGCGCCCTGTGGAGCCTGAGTCTGACCAAGTACCATTACGACGAAAGGATCTTAGCTTGCAGGAATCCCATCCACACCG
    ACATGTCCAAAGCGATCATCATAGAGGCCATCTGCTCCTTTATTTTCCACAGCGCTCTACTGCACTTCCAGGAGGTCCGA
    ACCAAGCTTCGCATCCACCTGCTGGCTGCACTCATCACCTTTTTGGCCTATGCAGGAGGGAGCCTCACAGGAGCATTGTT
    TAACCCAGCGCTGGCACTTTCTCTGCACTTTCCGTGCTTTGACGAACTCTTCTATAAGTTTTTTGTAGTATACTGGCTTG
    CTCCTTCTGTAGGTGTGCTGATGATGATCCTCATGTTCAGTTTTTTCCTTCCATGGCTGCATAACAATCAAATGACTAAT
    AAAAAAGAGTAA
    >Mus_AQP12 mRNA for aquaporin 12, complete cds
    ATGGCCAGTCTGAATGTGTCCCTCTGTTTCTTTTTTGCTACTTGTGCCATCTGTGAGGTGGCTAGAAGGGCATCTAAAGC
    CCTGCTTCCAGCAGGTACCTATGCCAGTTTTGCCCGGGGGGCAGTAGGCGCAGCCCAGCTGGCAGCCTGCTGCCTGGAGA
    TGCGAGTGTTGGTGGAGCTTGGCCCCTGGGCAGGGGGCTTCGGACCCGACCTGTTGCTGACCCTGGTCTTCCTGCTTTTC
    CTGGTACATGGGGTCACCTTCGATGGGGCCTCTGCCAACCCCACCGTGGCCCTGCAGGAGTTCCTCATGGTGGAGGCATC
    GCTGCCCAACACTCTGCTGAAACTGTCGGCCCAGGTGCTGGGTGCACAGGCTGCCTGTGCCCTGACCCAGCGCTGCTGGG
    CCTGGGAGCTCAGCGAACTACACTTACTACAGAGCCTCATGGCTGCACACTGCAGCTCAACCCTGCGTACATCCGTGCTG
    CAGGGCATGCTCGTGGAGGGTGCCTGCACCTTCTTCTTCCATCTGAGCCTCCTCCACCTGCAGCACAGCCTTCTTGTCTA
    CAGGGTGCCTGCCCTGGCCCTGCTGGTCACTCTCATGGCCTACACAGCAGGGCCCTACACATCTGCCTTCTTCAATCCTG
    CCCTGGCTGCCTCTGTCACATTCCACTGCCCTGGGAACACCTTGCTGGAGTATGCCCACGTGTACTGCCTGGGTCCTGTC
    GCAGGGATGATCCTGGCTGTCCTCCTCCATCAGGGCCACCTTCCCCGCCTTTTCCAGAGAAATCTGTTCTACCGGCAGAA
    AAGCAAATACCGAACTCCCAGGGGGAAGCTGTCCCCAGGTTCTGTGGACGCCAAGATGCACAAAGGGGAGTAG
    >Mus_AQP6 mRNA, complete cds
    ATGGAGCCAGGGCTGTGTAGCAGGGCTTACCTTCTGGTTGGCGGGCTTTGGACCGCCATCAGCAAGGCGCTTTTTGCTGA
    GTTCCTGGCCACGGGGCTGTACGTTTTCTTTGGTGTGGGCTCTGTTCTGCCCTGGCCTGTGGCGCTTCCCTCTGTGCTCC
    AGATCGCCATCACCTTCAATCTGGCCACAGCCACAGCCGTGCAGATCTCCTGGAAGACCAGCGGGGCCCACGCCAACCCT
    GCTGTGACCCTGGCCTACCTCGTGGGATCCCATATCTCTCTGCCTCGGGCTATGGCCTATATCGCTGCGCAGCTGGCTGG
    GGCCACAGCTGGGGCTGCTCTTCTTTACGGGGTAACTCCAGGAGGTATTCGAGAGACCCTTGGGGTCAACGTGGTCCACA
    ACAGCACATCAACTGGCCAGGCGGTGGCCGTGGAGCTGGTTCTGACGCTGCAGCTGGTGCTCTGTGTCTTTGCTTCCATG
    GATGGCCGGCAGACCTTGGCGTCCCCAGCTGCCATGATTGGAACCTCTGTGGCACTGGGCCACCTCATTGGGATCTACTT
    CACTGGCTGTTCCATGAACCCAGCCCGCTCCTTCGGCCCTGCCGTCATTGTTGGGAAGTTCGCAGTCCATTGGATCTTCT
    GGGTAGGACCGCTCACAGGGGCTGTCCTGGCTTCGCTGATCTACAACTTTATCTTGTTCCCTGACACCAAGACTGTAGCC
    CAGCGATTGGCCATCCTTGTGGGCACCACAAAGGTGGAGAAAGTGGTAGACCTGGAGCCCCAGAAGAAAGAATCACAGAC
    AAACTCTGAGGACACAGAATGTTTGACTTCTCCGTGTGAGGAGGCTGTCCGGTCATTTTCATTCACGCTTGGCCTTTGCT
    GA
    >Mus_AQP2 mRNA, complete cds
    ATGTGGGAACTCCGGTCCATAGCGTTCTCCCGAGCGGTGCTGGCCGAGTTCCTGGCCACGCTCCTTTTCGTCTTCTTTGG
    CCTTGGCTCAGCCCTCCAGTGGGCCAGCTCCCCACCCTCTGTGCTCCAGATTGCCGTGGCCTTTGGTCTGGGCATTGGCA
    CCCTGGTTCAGGCTCTGGGCCATGTCAGCGGGGCCCACATCAACCCTGCTGTGACTGTGGCGTGCCTGGTGGGTTGCCAT
    GTCTCCTTCCTTCGAGCTGCCTTCTACGTGGCTGCCCAGCTGCTGGGGGCCGTGGCCGGGGCCGCCATCCTCCATGAGAT
    TACCCCTGTAGAAATCCGCGGGGACCTGGCTGTCAATGCTCTCCACAACAATGCAACAGCCGGCCAGGCGGTGACTGTGG
    AGCTCTTCCTGACCATGCAGCTGGTGCTGTGCATCTTTGCCTCCACTGATGAGCGCCGCAGTGACAACCTGGGTAGCCCT
    GCTCTCTCCATTGGTTTCTCTGTTACCCTGGGCCACCTCCTTGGGATCTATTTCACCGGCTGCTCCATGAATCCAGCCCG
    CTCCCTGGCTCCAGCAGTTGTCACTGGCAAGTTTGATGATCACTGGGTCTTCTGGATCGGACCCCTGGTGGGCGCCGTCA
    TCGGTTCCCTCCTCTACAACTACCTGCTGTTCCCCTCGACCAAGAGCCTGCAGGAGCGCCTGGCGGTGCTCAAGGGCCTG
    GAGCCGGACACTGACTGGGAGGAACGCGAAGTGCGGCGGCGGCAGTCGGTGGAGCTGCACTCTCCGCAGAGCCTGCCGCG
    CGGCAGCAAGGCCTGA

<br />
## Target sites in bed format

0. Here is an example file name 'example.bed' in "test" directory, each line gives clear information about the target site: chromosome, target_start, target_stop, name (optional)

    ```
    chr1  115258619 115258774 gene1
    chr2  209113077 209113233 gene2
    chr2  212589736 212589895 gene3
    chr3  10188173  10188334 gene4
    chr3  41266010  41266202 gene5
    chr4  1806045 1806199 gene6
    chr4  55593505  55593704 gene7
    chr4  153249294 153249443 gene8
    chr5  112175133 112175302 gene9
    chr5  112175334 112175529 gene10
    chr5  112175516 112175709 gene11
    ```

1. Check the target regions and combine the duplicate regions into larger one. Run the command:

    ```
    ../mprimer-target-check -t example.bed -o example.merged.bed
    ```
    Open the output file 'example.merged.bed' with a text editor and we will see that the last two target sites for 'chr5' were merged into one larger region.

    ```
    chr1    115258619   115258774   gene1
    chr2    209113077   209113233   gene2
    chr2    212589736   212589895   gene3
    chr3    10188173    10188334    gene4
    chr3    41266010    41266202    gene5
    chr4    1806045 1806199 gene6
    chr4    55593505    55593704    gene7
    chr4    153249294   153249443   gene8
    chr5    112175133   112175302   gene9
    chr5    112175334   112175709   gene10/gene11
    ```

2. Extracting target sequences with essential flank sequence, possibly tiling primer design when it's needed. Run the command:

    ```
    ../mprimer-template-create --bed-file example.merged.bed --db /path/to/hg19.fa
    --tube-num 2 --product-min-size 100 --product-max-size 200 --product-opt-size 150
    ```

    It will create three new files:

    ```
    example.merged.config.json
    example.merged.template.fa
    example.merged.used.bed
    ```


    While file **example.merged.config.json** contains the target sites coordinates and other information and will be used later. File **example.merged.template.fa** contains the template sequences in fasta format and will be used for picking primers by mprimer. And file **example.merged.used.bed** contains the actual coordinates information used when picking primers, as well as the tiling primer design strategy. Take the first line as an example. The "Start in use" and "Stop in use" here are identical to "Start" and "Stop". In some cases, usually for SNPs panel, the "Start in use" = "Start" - 5 and "Stop in use" = "Stop + 5". This is because the SNP site usually is 1 bp in site, ever 0 bp in site sometimes.


Chr | Start | Stop| Split for tiling primer design | Chr | Start in use | Stop in use |
--- | ----- | --- | ------------------------------ | --- | ------------ | ----------- |
chr1 | 115258619 | 115258774 | chr1:115258419-115258769,chr1:115258669-115258974 | chr1 | 115258619 | 115258774   |

3. Mask SNP sites to avoid 3'-end (usually the last 5 residues) of primers locating at the SNP sites. **Note: make sure the coordinates of the SNP build version is based on the genome version you downloaded in "Database preparation" section**.
    * **Download SNP database**. We can download the human SNP database in bed format from [NCBI dbSNP](ftp.ncbi.nlm.nih.gov/snp/organisms/human_9606/BED) ftp server. There are multiple bed files, we can download them and put them into one directory.
    * **Format SNP database**. Run the following command:

        ```mprimer-snp-format -i BED -o hg19.137``` if the SNP database files in BED format are downloaded from dbSNP, where BED is a directory contains files downloaded from dbSNP, where 137 is dbSNP version number.

        After the command run down, a file named 'hg19.137.snp.json' will be created.
    *  **Mask SNP sites**. Run the following command:

        ```../mprimer-snp-mask  -i example.merged.template.fa -d /path/to/hg19.137.snp.json -o example.merged.masked.template.fa```

        This command will mask previous created 'example.merged.template.fa' using the SNP information we prepared just before. The new masked output file named 'example.merged.masked.template.fa' can be used in next step.

# Run mprimer

0. Before running mprimer, we need to create a user customer configure file first. Assume that the request for multiplex PCR primers are: Tm range [56, 60], Amplicon size range [150, 200], GC content range [20, 80], Max tube number: 2. Other parameters use the default parameters provided by mprimer. So the command should be:

    ```../mprimer-config -primerMinTm 56 -primerOptTm 58 -primerMaxTm 60 -productMinSize 150 -productMaxSize 200 -primerMinGC 20 -primerMaxGC 80 -in example.merged.masked.template.fa```

    After the command is done, a file named 'example.merged.masked.template.fa.csv' will be created. Let's open it with Microsoft Excel (or Numbers) and look at it:

    ![Mprimer Default Parameters and its values](/images/mprimer_default_parameters.png)


    We can see that each column is a parameter and each row is a template sequence. And importantly, this is Primer3 compatible configure file, anyone who are familiar with Primer3 can custom this file easily. For example, if we have existing primer sequences for a template, we can copy and paste the primer sequences into the cells of that template (column SEQUENCE_PRIMER and SEQUENCE_PRIMER_REVCOMP).

    **You can find the Primer3 parameters from [here](http://biocompute.bmi.ac.cn/CZlab/primer3_manual.htm#globalTags) and [here](http://biocompute.bmi.ac.cn/CZlab/primer3_manual.htm#sequenceTags).**

    Typical use for editing this configure file are: 1) if a template is AT rich sequence, we can lower the cutoff for this template while not affecting other templates. 2) If we want to design primers around a SNP site, we can specify the target site here by set proper value for parameter 'SEQUENCE_TARGET', e.g. 499,1, means start at position 500, with size 1bp. **Note: the position of first base is 0**.

0. **Custom the mprimer settings**. Because tiling primer design strategy was used, we need to tell mprimer the target sites for the tiling PCR. But we don't need to do this manually, just run the following command:

    ```../mprimer-config-custom -o example.merged.masked.template.fa.csv -s example.merged.config.json```

    ![Mprimer Custom Parameters and its values](/images/mprimer_custom_parameters.png)

    We can see that the 'SEQUENCE_TARGET' for each template was clearly specified.

0. Run mprimer. Firstly, we need to format the template sequences file:

    ```/mfeprimer-indexer -i example.merged.masked.template.fa```

    And then run mprimer:

    ```../mprimer -tubeNum 2 -cpuNum 4 -db ~/MFEprimerDB/hg19 -in example.merged.masked.template.fa -out result.csv```

0. Check the result files. All the output files can be opened with a text editor.
    * **result.tsv**: Beside the text editor, we can also open this file with Microsoft Excel (or Numbers in OSX). We can see that 21 template sequences were successfully designed primers and grouped into two tubes, one with 10 template sequences and the other with 11 template sequences. Unfortunately, mprimer failed design for template "chr4:55593305-55593655", let's check the log file and see what happens to this template sequence.
    ![Mprimer result](/images/mprimer_result.png)
    * **result.tsv.log**: This file is very important and it tell us the detailed designing process, especially when we examining why failed design for template 'xxx'. We can get a clue from the reasons, and get back to change the configure file (.csv) and redesign again.

        After opening the log file, we can use the find function from text editor to find the section of the failed template sequence. The log (in red box) information tells us that this template has multiple reasons which resulted in failed primer design. For the left primer, "high tm" and "lowercase masking" are the main reasons. For the right primer, "lowercase masking" is the main reason. From these information, we can get a basic conclusion about this template sequence: 1) high GC content in local regions which resulted in "high tm" for left primer; 2) too many lowercase masking sits and left very limited regions for picking both forward and reverse primers.

        ![Mprimer log](/images/mprimer_log.png)

        \>chr4:55593305-55593655
        TCAGTTTGGGACTGAGTGGCTGTGGTAGAGATCCCATCCTGCCAAAGTTTGTGATTCCACATTTCTcttccattgTAGAG
        CAAATCCAtccccacaccctgttcacTCCTTTGCTGATTGgtttcgtaatcgtagcTGGCATGATGTGCATTATtgtgat
        gatTCTGAcctacaaatattTACAGGTAACCATTTATTTGTTCTCTCTCCAGAGTGCTCTAATGACTGagacaataatta
        ttaaaaggtgatctatttttccctttCTCCCCACAGAAACCCATGTATGAAGTacagtggaaggttgttgagGAGATAaa
        tggaaacAATTATGTTTACATAGACCCAAC


# Tips


0. Type `mprimer` following press `TAB` key twice to show all the commands provided by mprimer.
0. `mprimer -h` will show detailed explanation for each of the parameters. 'mprimer' here can be any commands from mprimer.

<br />
# Help

Please contact the author if you have any questions or suggestions.


# FAQ

0. **How to specify the regions of interest?**

    Run mprimer-config firstly, `mprimer-config -i test/test.rna`, a file named test.rna.csv will be created. In this file, you can specify many parameters which are from Primer3, you can refer them from [here](http://biocompute.bmi.ac.cn/CZlab/primer3_manual.htm#sequenceTags) and [here](http://biocompute.bmi.ac.cn/CZlab/primer3_manual.htm#globalTags).

    To be noticed that, you should use Excel to open the .csv file and change default value (blank) for each template. For the parameters not listed in the file, you can just add a column and specify the parameter name (be identical to Primer3) in the first line. After that, **make that you save the file in csv format in the same directory** with the template file (here is test.rna).


0. **How many oligos should be in a single tube?**

    Actually, it mainly depends on two factors:

    **Firstly, the method for detecting the amplicons.** For example, if you check the amplicons by agarose gel, then the sizes of amplicons should have at least 20 bp differences in order to distinguish them by using electrophoresis. So in this situation, a tube should have no more than 20 amplicons (40 primers). Otherwise, if you use 2nd-sequencing technology for detecting amplicons, then it's no need to make the size difference among amplicons. And in this situation, in my opinion, a tube can contain as many as primers if we can make sure they couldn't hybrid into dimers and non-specific amplification.

    **Secondly, dimers and non-specific amplification.** This is the key problem of multiplex PCR and this is my research field. If primers can't format to dimers or non-specific amplification, they are called compatible, and they can be in a same tube, no matter how many they are. Otherwise, if primers can format to dimers, even two primers should be in different tubes.
