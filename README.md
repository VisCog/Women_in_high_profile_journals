# Women in High Profile Journals

Online supplementary materials for Shen, Y. A., Shoda, Y., & Fine, I. (2018). Too few women authors on research papers in leading journals. Nature, 555(7695), 165-165.

[bioRxiv Pre-Print](https://www.biorxiv.org/content/early/2018/03/02/275362)

# Impact Factor Data

[Thomas Reuters Impact Factor](https://jcr.incites.thomsonreuters.com/JCRJournalHomeAction.action)

# NIH RO1 Grant Data

[NIH RO1 Grant Award Percentages](https://report.nih.gov/nihdatabook/charts/Default.aspx?sid=0&index=1&catId=15&chartId=172)

# Script Processing Order

**Downloading Data from PubMed**
1. [PubMed_DownloadData.ipynb](https://github.com/VisCog/Women_in_high_profile_journals/blob/master/Women_in_High_Profile_Journals/Code/PubMed_DownloadData.ipynb)

⋅⋅⋅Downloads data from PubMed's server and transforms compressed data into csv files.

2. [PubMed_ProcessData.ipynb](https://github.com/VisCog/Women_in_high_profile_journals/blob/master/Women_in_High_Profile_Journals/Code/PubMed_ProcessData.ipynb)

...Extracts journal specific data and saves to csv files by journal.

**Cleaning Data from PubMed**
1. [PubMed_Genderize.R](https://github.com/VisCog/Women_in_high_profile_journals/blob/master/Women_in_High_Profile_Journals/Code/PubMed_Genderize.R)

...Genderize first names of all the extracted journals with the [genderizeR]() package.

2. [PubMed_JoinData.R](https://github.com/VisCog/Women_in_high_profile_journals/blob/master/Women_in_High_Profile_Journals/Code/PubMed_JoinData.R)

...Joins the genderized first name data with the journal data.

**Figure 1 - Scatter plot of percent female authors as a function of impact factor by journal**
1. [Figure1_CleanImpactFactor.R](https://github.com/VisCog/Women_in_high_profile_journals/blob/master/Women_in_High_Profile_Journals/Code/Figure1_CleanImpactFactor.R)

...Extracts specified journal impact factors from the [Thomas Reuters Impact Factor](https://jcr.incites.thomsonreuters.com/JCRJournalHomeAction.action) data

2. [Figure1_Scatter.R](https://github.com/VisCog/Women_in_high_profile_journals/blob/master/Women_in_High_Profile_Journals/Code/Figure1_Scatter.R)

...Plots and saves Figure 1 sctatter plots. Contains two graphs: percent female authors as a function of impact factor for first and last authorship positions. Also plots the legend.

**Figure 2 - Line plot of average percent female authors as a function of year**
1. [Figure2_CalculateLineData.R](https://github.com/VisCog/Women_in_high_profile_journals/blob/master/Women_in_High_Profile_Journals/Code/Figure2_CalculateLineData.R)

...Calculates the average percent female author as a function of year by journal. Also combines data with [NIH RO1 Grant Award Percentage](https://report.nih.gov/nihdatabook/charts/Default.aspx?sid=0&index=1&catId=15&chartId=172) data.

2. [Figure2_Lineplot.R](https://github.com/VisCog/Women_in_high_profile_journals/blob/master/Women_in_High_Profile_Journals/Code/Figure2_Lineplot.R)

...Plots and saves Figure 2 line plots. Contains two graphs: average percent female authors as a function of year for first and last authorship positions. 

**Table 1 - Calculates the slope of percent female authors as a function of impact factor by journal**
1. [Table1_Slopes.R](https://github.com/VisCog/Women_in_high_profile_journals/blob/master/Women_in_High_Profile_Journals/Code/Table1_Slopes.R)

...Calculate Table 1. Contain a table of slopes of percent female authors as a fucntion of impact factor by journals for first and last authorship positions. Also plot and saves supplementary figure 1 (a figure for table 1).
