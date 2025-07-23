# Tariffs

This repository hosts several datasets and code files to replicate the Equitable Growth tariff project. The project produces a baseline estimate of costs facing U.S. industries from tariffs on imported inputs, before any adjustments are made to compensate for or pass down those costs. All files here can also be found in a Dropbox folder here: https://www.dropbox.com/scl/fo/1rb2erl8e5wgvce89w3yh/AP6pY1f5lDklUKA3O1bB8G8?rlkey=tygj3ww0sacmnirvklwtv4jdv&st=beek4jl1&dl=0. The employment data files are too large to upload to GitHub and are only stored on Dropbox.

**Data Files**

Tariffs – Intermediate inputs analysis.do: A master code file that allows users to set characteristics of a desired dataset including year, industrial specificity, and geographic specificity.

Matrices.do: a secondary code file called by the master file that crosswalks BEA codes to NAICS, aggregates to the industrial specificity set in the master file, and produces some initial variables.

CES.do: a secondary code file called by the master file that cleans the raw CES data and aggregates to the level set in the master file.

County Business Patterns.do: a secondary code file called by the master file that cleans the raw CBP data and aggregates.

Imports_multi.do: a secondary code file called by the master file that cleans desired year of import data.

Tariffs graphics.do: a separate code file that contains chunks of code users can run to produce various data visualizations depending on the dataset called in the master file.

Tariff rate sheet.dta: a basic sheet with tariff rate set at 10% for every country of origin.

Tariff rate sheet updated 7.21.dta: an updated sheet with tariff rates set at reciprocal rates due to take effect in August, per the tracker maintained by Reed Smith.

ImportMatrices_Before_Redefinitions_DET_2017.xlsx: raw import-input data from the BEA.

Use_SUT_Framework_2017_DET.xlsx: raw use-input data from the BEA.

ces.dta: raw national employment data from the BLS.

CBP2017.csv: raw county employment data from the Census.

CBP2018.csv: raw county employment data from the Census.

CBP2019.csv: raw county employment data from the Census.

CBP2020.csv: raw county employment data from the Census.

CBP2021.csv: raw county employment data from the Census.

CBP2022.csv: raw county employment data from the Census.

US imports by state and country of origin, 2017.csv: raw import data from the Census by commodity, country of origin, and state of destination.

US imports by state and country of origin, 2018.csv: raw import data from the Census by commodity, country of origin, and state of destination.

US imports by state and country of origin, 2019.csv: raw import data from the Census by commodity, country of origin, and state of destination.

US imports by state and country of origin, 2020.csv: raw import data from the Census by commodity, country of origin, and state of destination.

US imports by state and country of origin, 2021.csv: raw import data from the Census by commodity, country of origin, and state of destination.

US imports by state and country of origin, 2022.csv: raw import data from the Census by commodity, country of origin, and state of destination.

US imports by state and country of origin, 2023.csv: raw import data from the Census by commodity, country of origin, and state of destination.

US imports by state and country of origin, 2024.csv: raw import data from the Census by commodity, country of origin, and state of destination.
