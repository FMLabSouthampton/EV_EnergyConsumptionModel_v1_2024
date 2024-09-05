# Kia Niro EV Energy Consumption Models

## Overview

This MATLAB script allows users to explore various energy consumption models for the Kia Niro EV (Model Year 2023), as discussed in the research article. The models include:

1. **NARXP** (Nonlinear AutoRegressive with eXogenous inputs in Prediction configuration)
2. **NARXS** (Nonlinear AutoRegressive with eXogenous inputs in Simulation configuration)
3. **LSTM** (Long Short-Term Memory)
4. **NN** (single-layer feedforward Neural Network)
5. **NNP** (single-layer feedforward Neural Network in Prediction configuration)
6. **NNS** (single-layer feedforward Neural Network in Simulation configuration)
\
The model inputs are **motor torque** (Nm) and **vehicle speed** (m/s), while the output is the **electric power** (kW) from the battery pack.

The script uses on-road trip data for the Kia Niro EV (Model Year 2023), collected by the **Future Mobility Lab** at the **University of Southampton**. Data was recorded over four days on various routes, including Southampton to Chilworth, Alderbury, Basingstoke, Portsmouth, Beaulieu, Christchurch, and Bournemouth.

## Directory

```
.
├── Existing_Models           # Files containing models and required dataset 
├── Model_Result_Scripts      # Scripts to display results for every model
├── Road_Trip_Data            # Complete dataset containing all variables for all road trips
```

## Features

- **Explore Models:** Users can choose from a list of pre-defined models and view their results.
- **Results Visualization:** The package displays graphs and prints the result table in the MATLAB command window.
- **Workspace Integration:** Models and results are loaded into the MATLAB workspace for further exploration.

## Requirements
The script was developed with the following MATLAB installation:
- **MATLAB Version:** 23.2.0.2515942 (R2023b) Update 7
- **Toolboxes Required:**
  1. Deep Learning Toolbox (Version 23.2)
  2. Statistics and Machine Learning Toolbox (Version 23.2)
  3. System Identification Toolbox (Version 23.2)

**Operating System:** Microsoft Windows 10 Enterprise Version 10.0 (Build 19045)

**Java Version:** Java 1.8.0_202-b08 with Oracle Corporation Java HotSpot(TM) 64-Bit Server VM mixed mode

*Note: The script may or may not be compatible with other MATLAB versions.*

## Installation

**Run the script from the repository:**

1. Clone the Repository:
```
git clone https://github.com/FMLabSouthampton/EV_EnergyConsumptionModel_v1_2024.git
```
2. Navigate to the Directory:
```
cd EV_EnergyConsumptionModel_v1_2024
```
3. Open MATLAB:

- Start MATLAB and set the cloned repository as the current directory.

**Alternative method, download and run:**
1. Download the repository as a zip file and extract it.
2. Open MATLAB, and change the current directory to the extracted folder.

## Usage
1. **Run the Script:**

In the MATLAB command window, type: 
```
Kia_Niro_EV_Energy_Consumption_Models
```

2. **Select a Model to Explore:**
- Choose from the available models by entering the corresponding number(1-6).

3. **View Results:**
- The script will display the selected model’s output graph and a summary of the results in the command window. The model’s data will also be loaded into the MATLAB workspace.

## Contributing
We welcome contributions to enhance this script. If you have any suggestions or improvements, please fork the repository and submit a pull request.

## Contact
For any questions or issues, please contact bilal.baluch@soton.ac.uk

© School of Engineering, University of Southampton, UK