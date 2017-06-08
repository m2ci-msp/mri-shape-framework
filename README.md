# MSP Multilinear Tongue Model Gradle Framework

## Introduction

This framework derives a multilinear tongue model from a given MRI dataset by performing the steps described in [*Hewer et al.*][1] in a minimally supervised way.
Basically, this means that the framework automatically takes care of the dependencies between the different steps and calls the respective tools.
As a user, you only have to provide the MRI data with labels and the settings you want to use for the dataset.

## Requirements

Please make sure that the following tools are installed and are also available on your path:

- Java SDK ( version 7 or greater )
- [Blender](https://www.blender.org)
- [R](https://www.r-project.org)
- The R packages ggplot2, reshape2, plyr, and reshape2
- All tools from [MSP MRI Shape Tools][2]

## Setup

The following sections explain how to add an MRI dataset to the framework and how it is configured.
In the following, *${...}* are always placeholder variables.

### Adding a Dataset

Adding a dataset of MRI scans to the framework is straightforward:
The scan files have to placed in the *resources/mri* folder where the following directory hierarchy is expected:

```sh
.
└── resources
    └── mri
        └── ${DATASET_NAME}
            └── ${SPEAKER_NAME}
                └── ${SCAN_NAME}
                    └── scan.json
```

where *${DATASET_NAME}*, *${SPEAKER_NAME}*, and *${SCAN_NAME}* can be freely chosen.
The file *scan.json* is the actual MRI scan in [JSON format][3].

### Configuring the Dataset

In this step, we create the configuration files for the dataset.
These are placed in the *configuration* folder:

```sh
.
└── configuration
    └── ${DATASET_NAME}
```

where *${DATASET_NAME}* is the same name chosen above.

First, we create the file *database.json* that contains meta information about the added dataset.
This file contains a JSON list of JSON objects.
Each object has the following structure:

```sh
{
    "prompt": "${LABEL}",
    "speaker": "${SPEAKER_NAME}",
    "missing": true|false,
    "id": "${SCAN_NAME}"
}
```

Here, *prompt* is a label that identifies the sound that was produced during the scan.
The variables *${SCAN_NAME}* and *${SPEAKER_NAME}* are chosen like above.
The flag *missing* indicates if the scan for the respective speaker and prompt is missing in the dataset.
In this case, *${SCAN_NAME}* should be set to something that also indicates that the scan is missing.

Furthermore, we create the file *palateDatabase.json* that contains information about scans that are used for deriving the hard palate shape of each speaker in the dataset.
Again, we have a list of JSON objects:

```sh
{
    "prompt": "palate",
    "speaker": "${SPEAKER_NAME}",
    "missing": false,
    "id": "${SCAN_NAME}"
}
```

Afterwards, we add the file *dataset.groovy* to the folder that contains the following settings:

```groovy

// these are settings for bootstrapping the tongue model
bootstrapTongue{

  // iterations to perform
  iterations = 4
  // iteration that should be used for the deriving the final model
  selectedIteration = 4

}

// these are settings for bootstrapping the palate shapes
bootstrapPalate{
  // is the bootstrapping active?
  active = true
  // iterations to perform
  iterations = 1
  // iteration to use for the shapes
  selectedIteration = 1
}


// settings for evaluation the final model
evaluation{
  priorSize = 2
  convergenceFactor = 10000000
  projectedGradientTolerance = 0.00001
  maxFunctionEvals = 1000
  // sample amount for specificity
  samples = 1000000
  // truncated modes for specificity
  truncatedPhoneme = 4
  truncatedSpeaker = 5
  // subsets to use, have a look at the resources/evaluation folder for available subsets.
  // you can also add your own
  subsets = ["bladetip", "combined", "bladebackdorsum"]
}

// settings for the final tongue model
finalModel{
  truncatedSpeaker = 5
  truncatedPhoneme = 4
}

// settings for the final palate model
finalPalateModel{
  truncatedSpeaker = 11
}

// settings for performing the Procrustes alignment of the palate shapes
procrustesPalate{
  originIndex = 93
  iter = 40
}

dataset{
  name = "${DATASET_NAME}"
  speakers = ["${SPEAKER_NAME}", ... ]
}
```

Finally, we create, for each considered speaker in the dataset, a subfolder with the corresponding name. Such a folder must contain a file named *speaker.groovy* with the following settings:

```groovy
speaker {
  // name of the speaker
  name = "${SPEAKER_NAME}"
  // list of scans to consider
  scans = ["${SCAN_NAME}", ...]
  palateScan = "${PALATE_SCAN_NAME}"
}
```

Optionally, this folder can contain a *settings.groovy* file that overrides the [default settings](resources/settings/default.groovy).
For example, you could provide for each speaker the region of interest of the associated scans:

```groovy
speaker {
  cropToVocalTract{
    minX = 41
    minY = 152
    minZ = 0
    maxX = 171
    maxY = 258
    maxZ = 43
  }
}
```

### Providing Landmarks

It is necessary to provide landmarks for each considered scan.
These should be organized as follows:

```sh
.
└── resources
    └── landmarksPalate
        └── ${DATASET_NAME}
            └── ${SPEAKER_NAME}
                └── ${SCAN_NAME}
                    └── landmarks.json
.
└── resources
    └── landmarksTongue
        └── ${DATASET_NAME}
            └── ${SPEAKER_NAME}
                └── ${SCAN_NAME}
                    └── landmarks.json
```

For the tongue, the following landmarks are available:

- FrontBaseCenter
- Tip
- SurfaceCenter
- BackCenter
- Airway

For the palate, we have:

- FrontTeethCenter
- SlopeMiddleRight
- SlopeMiddleCenter
- SlopeMiddleLeft
- SlopeEndedRight
- SlopeEndedCenter
- SlopeEndedLeft
- BackLeft
- BackCenter
- BackRight

Open the *blend files* in [resources/template](resources/template) with Blender to see where these landmarks are located on the template meshes. (They are stored in the form of *VertexGroups*)
Basically, you can also add your own landmarks by modifying the blend files.
We recommend using the *landmark-tool* of the [MSP MRI Shape Tools][2] to distribute the landmarks on the MRI scans.

## Running the Framework

After the configuration is finished, you can run the following commands from the root directory.

### Deriving the Models

```sh
    ./gradlew createFinalModel
    ./gradlew createFinalPalateModel
```

These commands perform the necessary steps to derive the final tongue model (first command) and palate model (second command).
The results are afterwards available under

```sh
.
└── build
    └── ${DATASET_NAME}
        └── finalModel
```

and

```sh
.
└── build
    └── ${DATASET_NAME}
        └── finalPalateModel
```

In both cases, the model is output in YAML and JSON format.
Have a look at the documentation of the [MSP MRI Shape Tools][2] to learn more about the data format.
Furthermore, most results of the immediate steps are available in the subfolders of

```sh
.
└── build
    └── ${DATASET_NAME}
```

Here, for example the template matching or segmentation results can be inspected.

### Evaluating the Tongue Model

Run the command

```sh
./gradlew evaluateTongueModel
```

to evaluate the specificity, generalization, and compactness of the model.
Plots of the results can then be found in

```sh
.
└── build
    └── ${DATASET_NAME}
        └── evaluation
```

### Visualizing the Results

Execute

```sh
./gradlew createHTML
```

to create HTML visualizations of the achieved results after the initial matching and at each boostrap iteration.

The visualizations of the initial results are available in

```sh
.
└── build
    └── ${DATASET_NAME}
        └── html
```

The visualizations of the bootstrap results are present in


```sh
.
└── build
    └── ${DATASET_NAME}
        └── bootstrapTongue
            └── ${COUNT}
                └── html
```
where *${COUNT}* is the number of the iteration.

In both cases, you can start a HTML server in the corresponding subfolder and then inspect the results in your browser.

[1]: http://arxiv.org/abs/1612.05005
[2]: https://github.com/m2ci-msp/mri-shape-tools
